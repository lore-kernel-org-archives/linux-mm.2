Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FA26079555
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFwEUG2M
Received: by kanga.kvack.org (Postfix)
	id 0540B6B05C0; Thu,  5 Nov 2026 14:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B776B05C1; Thu,  5 Nov 2026 14:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E839D6B05C2; Thu,  5 Nov 2026 14:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6D116B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:45:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68284140962
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:45:11 +0000 (UTC)
X-FDA: 85402094022.22.F0C4D83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9096F1C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:45:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aFwEUG2M;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwwRFdOw4oikJB0l/UHgh6k09vdq8uhcaONY4VtARHI=;
	b=EWgcZshHb1+HxhRtVWcI48HeO4ItnYOkUApZZ3OBafy3q4dxkvOMfBO8PnMTWTSP+WMJFp
	LoaCc+TSpJGbu403BHgd34rSiU/w+wKGO51FEeX1tkk6JywdsvaGv9ZnBI2dOn3F23WBtU
	DhM9YsZqEkXGE04uZf7x2q2TIE5ZOMg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aFwEUG2M;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907909;
	b=MY0SMGX3Il18F8ue7Yn/5/Auiyg26EU3w5JaaArZz9HHyemNPl/p5DxHQvcT5xsOmnEhjG
	I1/Ty4iRnBTMW2eyocKvhonFm4a7XzTWTXRPpzp+xx2PocJ4Ato9sJvZogMAznkYlM0TPI
	9tYSyeCQQBIFJ6PDGSxaIDycnBMCFs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0644090A;
	Thu,  5 Nov 2026 19:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873C91F0089F;
	Thu,  5 Nov 2026 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907908;
	bh=SwwRFdOw4oikJB0l/UHgh6k09vdq8uhcaONY4VtARHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aFwEUG2MRn1cnJpuFDp/RuKE9w9V7lQIsGOnP+6tTnyE/o+7hi44rof4K7A+A3/Me
	 LmB3NQaaHG6Fw2IrsEZpWvYrsQBeciPKqPKDDvMLdqAHh9VXKDxH+XfG1LPLQmeRmj
	 no7/Zzpy/GXlRZUJlEW5ZkBLjhGd8f06ItJIzyvVBwK6w95Dz84AIIc1C8XuceM6qX
	 rTKNcm1C+hQTK/1QoRjbmbi6KHnumMPsIKiRb3/lONH2lBIXPu+3e6QCMoERTTzkyW
	 B8zlJp5LEpjW8FeIL8f6UVFUDO84dKju21/n+JzAdWWTt6R/kgW6epXpVOpCWcJ5vi
	 1n+OA1XrQzQEg==
Message-ID: <ac54a9f6-e21d-4f03-88dc-6562afd59cf6@kernel.org>
Date: Thu, 5 Nov 2026 20:45:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10] mm: replace free hugepage folios after migration
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: linux-mm@kvack.org, yangge <yangge1116@126.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mark Bundschuh <mkbund@amazon.com>
References: <20261105070150.3093908-1-mkbund@amazon.com>
 <2026-11-05-1-daily-reply-0010-mm-hugepage-folios@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026-11-05-1-daily-reply-0010-mm-hugepage-folios@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9smqa1oz6fhpd8n51stzzw3cg6eikbjh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9096F1C0008
X-HE-Tag: 1793907909-507858
X-HE-Meta: U2FsdGVkX19C6BhGaE97kC0fzeopMVGd4gErtvPijCz8+EHXvMDlrZhbtNG5HzDc0vHi0G1MLD5puOcgjGh+ScG5XM8dsQ96Bk6hl+XFc4BgQujDnD4uefmzJcKVlU1lpeW36T4OK2nSpfXRDhBFbvog5k+Ge4rOLBpQKE83suAH8m3T2JdLGLElYP3Kc1XHMqG/bZQY5J/tFyEk6sigS+rBUDefnJoynbF7crNFUEexAvrZZs9MAtpxzmARrKrII2oZc+55RLb3FYY161hIL7lca99Az0CGrWXYNtz4ktw1ck6hrKp3LToTENpeQFlD+7hASdlWHne7joJzo5TMl9FEJC+rJl6xjYYm/JKhUJ7PKBOFevLZbTQnKHs/tDb9Ur48JfsP/jqNnSEjvqrMa2QRw20ut9wp/bJKYkQP5xuElvKFllOXEapeAgJYUfgifU6UhZyPfN4wwA9T2OZrDOnOu5Ak0aJ+EALq5OfgW/5ey8u5SxcAmmltVhRiPqJTothqLvakIb3awjOEj2ZRMf/KhKIQwNiHNDFrZkAkfoq/rkfEPMojYWvPQLWrCJN8Rjh/VrmiaB/oiYXHOtDpNN/V9eDw9J71mWFxvCONAtA38voU1NjAvr7Gz3nrmAdnLQipwVTIhoSiMBP0xInEfkMFH0noR0sLQ0fMg4YFBttk7d+dbfwVDRjk67rgYszM6lzSPVvhRtQtE+etlGYcxGIFZBWo0IhzbKhDFy5PlBc7nLxL31UMOVn7MsJeodJsGZjaptkl1oIA9R0AQhnwuu8VH2KsktudHc2wIpJG2Dec23J0JrOIa3qg1hlTYSGEKmybf84GAhVPsb7GX8tOyKEIwhGwhxstCsLZybErrAeGlgUxj/dWwTb0p2nJdx+l+LGDykeRUsq4kR0ZQCLzxDq9i/s+4t53eOg8Bba2xF+h3R7mwXCZ12SmmXyVvOea2G/yRdnz+1PPAVX6dts
 bbAQoLNc
 1mk3f1eM0znmMbeiClSrdNmFhBsroHNEzSRtlLD7Sl4wBV3oqEmiImMxjocOukZfk7BHrJP+pd22pgVN9dqmXvQ2BanJHKhWXmCFKsU+KyvDfAv6HQKWI6ZIDdbc+k//fSaFYPyApol6KesFbv12QxKA6m8e/9YRJncNe2UU4V3IC2g5aqGpq5DGPSAspVeztGrBMN/+nAqw9jlPuU6l3Ujcsl0SNS+WPtnAIu+IkOufsTJUDGG+WwCYIpJzRBY/CWWjYvqBCvDFCnLbbaLe/KVRdzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 19:39, Sasha Levin wrote:
>> [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]
> 
> These carry only the is_migrate_isolate_page() hunk of 04f13d241b8b ("mm:
> replace free hugepage folios after migration"), which has no Cc: stable or
> Fixes: tag upstream.
> 
> I need an ack from an mm maintainer (David or Andrew) on the reduced backport
> before queueing it for 5.10, 5.15, 6.1, 6.6 and 6.12.
> 

Looks alright, the other hunks are only relevant for migration support of
hugetlb folios in alloc_contig_range(), which we didn't have in 5.10 IIUC.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

