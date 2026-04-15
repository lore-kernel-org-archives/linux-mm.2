Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AE1FA0C43
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117646B0093; Wed, 15 Apr 2026 04:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7E66B0095; Wed, 15 Apr 2026 04:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9226B0096; Wed, 15 Apr 2026 04:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9706B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:04:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 863551603BC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:04:50 +0000 (UTC)
X-FDA: 84660053940.12.21487AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF30B80008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:04:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fs8l7fTu;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776240288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I17gY1VQqAFFn9QfiY1ygRtudFtlgtD9DJehm1faeYM=;
	b=Rg/kiMO2yiAbGAcZVQKZ1vd1UJNs53kRkkg7lFdiXop8oDSTSXywP1yEhyY4jkdwbNJPxR
	Xkz8OSkA8U2cvkxsVhVVsFe9nh30kFub65CntVYkpmro8pBCFwO1kssKl/t0tolOTOhlNP
	jHoqQCk1gXzckQmdkhOC2Zv6gYKqQw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776240288; a=rsa-sha256;
	cv=none;
	b=6EBL+25+y07o3YNDRDtZv5/JPVkVpeKtLHpo+/o3JKJWH/dzBXS7t96UPY5v8c+68cKD/x
	g8nuYh+Z9DYSZx4q0KibzTE8K+aJXi7bOVCf0/WMG17whMs+kVi0MUSADZ43wpCW4Arcsr
	Cu8piWpZ2jR9RP8ji+sbgSpkOxmU0tM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fs8l7fTu;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26B2B6012A;
	Wed, 15 Apr 2026 08:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFDCC19424;
	Wed, 15 Apr 2026 08:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776240287;
	bh=871zzdzT4SrXceIZaJieI+YzRKMftM9KovcUV8+EOYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fs8l7fTuVLvJS8nZ4H2fGZVoOH5TUxz+qBME9VCxjOZjAZfrYAOpWcbs+5T+uL/ce
	 LuEywyo6kWxLDDsGUhMTXtvI6Eb9JwkznyUKyHBDNPA+tovJCwW+0ZNuvcAy6uEenL
	 ibdeZCYDI6z/sMbd7lPQDJqy+Oys7CD0az/Zmumr0fvT+N2sPnr5ks3U2JL9zlJDZe
	 5hKfEByenRcvxG6iltzohnAAQd6IxhJgr9M6Xt0c7TIy4gr7AIChQ8riMJrZOTPGab
	 770Agpi7/s3AOkSZXN2n61MlixwwHtXj6CZrJiyPSfnZtN2QZeWdTgNrhP8ZmdhPjA
	 gm9ub/wuoLyNw==
Message-ID: <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
Date: Wed, 15 Apr 2026 10:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260415022326.53218-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415022326.53218-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: jgs3j3bh7e8u84t96znb793tboh1mr81
X-Rspamd-Queue-Id: CF30B80008
X-Rspam-User: 
X-HE-Tag: 1776240288-74521
X-HE-Meta: U2FsdGVkX19hrUJY+jL+3iNzhKF0l2tAJe82iXhg2c4aOVc3Vh1NVHps26uunJtOquR621XcoAVOGFvAQYRj3q1KRxQvnRGVtxpH8MPcVkhHM0oiWv/J+8RAFRXgpI4K+UFhPpYJzWUnSu3SF+LRxLlooPGnlWGP8/4ZA2+OITrP+nhsVMtbbzvMh1jqccGxgcERUTExIDhoZsqyzN8JU9omsOckj7NdUyLgYOGEThGBSfzm7NLZ3HV3z6B19i/Swc6poFTOBdbLivOxF5aX9MixAtWeUmeg7bTpOEk+ZGMDaE/g62GRqFJlFkuBfZGBlwF9LsoJbXnbbbgfwhByvKLO7939AqRXUMpApqAAmO0gG6B9FIE26nQ+oFWEgPGfVmSa+R/FFrw9SRrNeqnXl2Ku3HRbANisjorL/WxII7njEy88yYJEkOAAaFF/DAIf5YRQ/41Ye5RgQ03Y0h+npvJV/Uv2x0XTS/6JZlEQMy4Uv6kBk1GNklZ+GlewNuFjiU0ki2I17Em5Q+S8dLV1b3EAVHO24H0YLf9PjbC5ZAf4eO8K/NywoFGM0UPivl9gK4aDKQ6Q2qiWX2hFJbSBcBcpVXsydJ4dOr5urKvohLbg58WzPOs4AXJCfKjvnsA2HjoH7ILCbtQ3lAfMNhPzB1u0EaK3fUBe8fIhKo+djcepWMSW+sxzxA978OBQNE3mG62++q5PthRau37cdgj/5X7VW5v9BWHZczsmzlgkMuu5wFquXt0fRLnu1q5jkW5+Q6e/+e7AR6vM77A/Onq0VsznEEA0Kg18qKTAOyFpyxM/hfVzcMb7htz2U9AHtroJe3emq+lOIkTS6OgWgvN0In7ibf+ya5OFji4cA2VoKWxu0n+YUI4ATajUEATUN9rxCnyFDNu4wlEcN7Dm500ZcgpuQhx3wxhH4UWGOnEoHUqcR1McFDenI0AmHoMaNuggIG5a3y61tqzhvbDal6V
 YUnprrfk
 TmLWHV17dTWyeNLJo3LTKSZni5Oky+PN9Q29Yw4Im4UdEQkyRcbs4LyWFJAM0oti8JdngcNZuRxePIe9qqK3KcgG4/wXGgkoaAasdPbIomK0Cuh8KebzZXZYErQN8r0BYuKKrBp3+Pu6squVW8spZLnM9jOTd0zhWgV2IXSjMIba5kUWmwUVdRYGXsLy9LeUMVJmapp6fgqaRG+fAx34m82CMfbZAmu9gpiC+FwFDCJUPWp9CP46Ox3s6y4kt7AQWAwsYC1CASDRqtCyxKM9oMVUCjkTydm+5Z2FeGbRzswZDJLaotmB+35kpeUXmt6AmSrEoSTo7+FJrT9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 04:23, Muchun Song wrote:
> When memory is hot-removed, section_deactivate() can tear down
> mem_section->usage while concurrent pfn walkers still inspect the
> subsection map via pfn_section_valid() or pfn_section_first_valid().

I'll note that it's all racy either way: someone checking pfn_valid() /
pfn_to_online_page() can race with concurrent unplug.

We've known that for years; it's hard to fix; it never ever triggers :)

So is this really worth it, when we should in fact, work on protecting
the users of pfn_valid() / pfn_to_online_page() with rcu or similar?

-- 
Cheers,

David

