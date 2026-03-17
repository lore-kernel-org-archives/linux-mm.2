Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72449FEDA10
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2856B00AD; Tue, 17 Mar 2026 15:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73906B00AF; Tue, 17 Mar 2026 15:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62DC6B00B0; Tue, 17 Mar 2026 15:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B242E6B00AD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:17:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 510D11B7786
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:17:40 +0000 (UTC)
X-FDA: 84556514280.08.EC81BE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F0C9C000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:17:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iw8Z4lVG;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773775058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0w7IfElQr7VaLU6OevkZFSAxmXqv7IQN+Gv8BvPx+xg=;
	b=XrcONBWCUuo4AcC5yg+BgpHf4Ki7pMjGyLww+7OHVMNGuS0AmqYuNHwO8YtXuDyIea+iBV
	P05mCrn+qZ6+dRC8FKMrtJQV35VEFHKvd+JCac55yH0yupDBG6DdJCFPKEivswFzKKh87r
	CzSi38Ynznxw2R7uZnId/CzOTdBthJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iw8Z4lVG;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773775058; a=rsa-sha256;
	cv=none;
	b=2eRJIC3erbOmBaJ+4SEDifTE7klAJsaRdPdNRl/jT0DWGZU4AXCowsA//TkJMBBoi1YfeU
	2LWgRTeOQDlqCnE7SHs0xotj853tcSPp64QtX8MCTcrpT0wReGhsRvlvlMDARCyXGEffVK
	5DnMpNY6GE1+Na69UokZftkh6Kx+Cfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9BD0401A2;
	Tue, 17 Mar 2026 19:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD00C4CEF7;
	Tue, 17 Mar 2026 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773775057;
	bh=W+368n3zmFZXeS0XIlxfHQZMscjYF0bb1lj3Rt3JIVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Iw8Z4lVGvpXYmOoizM4V5P1V32PyCVMQTnvl26cVXiRi6dtxJJ1g0tmIH9JcrXS8h
	 NfHGAkv96sULc+DE8OA+1bvXBc9em3BR73SRfmzq6nTN7LI8/5PVHhI2mAGE0sC7k5
	 RDUCUrZaMzokURlDmCZIYxiThV5Xbk43KYwfcb6w=
Date: Tue, 17 Mar 2026 12:17:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Brendan Jackman
 <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-Id: <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
In-Reply-To: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9F0C9C000F
X-Stat-Signature: da5tdygr4xwp4yehp64ry1uttx7wp14c
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773775058-345372
X-HE-Meta: U2FsdGVkX18j6CJjaDkbhHLJJ9fds7Z9kpmSInz56Kf2b6tmkq7R2CeBvcWgg+6+tvau1YY5u9vp5cQ2iiNI1vJP3ea3laVQ/rYgX5RjKUkD8NeSmuljVLJkv6UnZwH5gHXcgvxSmxg465A0rxeLFU+zigmj0dgVKdFpVpQY4jKRiQiBcA2AGG9EQjzzYbXdzSbh+eyXq5o5MOJQOO9SH0y0Jnc/XVEkJVXMYzAd2mn19r9pl9xW8NhPxVWhpAKxNdCXGnJkupbLMN9JAt6m3vgu36EsHJqKTq0aMlaD8SknIGG/V5C7BBc8Epxf/DwjzcgGXThNfCr3KzWv98l86Dpw8jFM1rjLXrUbClk82srzQlX2JSQmPaQcCtR2UgDhrZxJUnGDB4QINrMn95DAWAZwobf5jWaS4Xo9leR/SrhdSgRThZgoFVPj8OfsYXsc0E5iWE5NhpQRQHt7mYIM23j/AyZCcCia8ylJrhbWKnc9BXNDHB8aqXTErC41tqONBLR6XpKYecHUtvofB4DfEr6z04RP0Yf3tBIv79XdbqATV9YkXYFnFZXx10adeCe30lwnL7B1jzeRU+aWjcct+Dd8pw8xriAP2fR0oJsgTbCLw0S/ACWTuVEE0pDvvaUMXSC/8AdkyvisdLSQRSuHHr4djzma/9hcGhS8Lgto5HcqKTbcN3135zTfsskZ6hKYeuo/JnbSNsvaAbw+5HVpIGZJnTsnJSct1wdS+aNLtPWQgy5AwVCsT4pqB+D3dGeh/wULpDS3yg7GzcBjKnk2SIQd13eKd4JE5wN166DVQquFpQ1mdJgx+ivqOiywQFPN5eprhyyNKZAVuM8rShRdYrLdXB5bpcN2Wrnu7Ju3GCgFZrDOSYX3TdRQsFjB7bY4QH7xQJR97dHq7raf7M8HsVdGZbu67B5eNAZUB29ZaMSIxx0sOwGiFSgyb5iLz34+dmfbThln3p/niUpUdpe
 N4tmI7rS
 6hIoL0kY9V1A5nQNYS+wcxvNgtEKc+d4tzMRpVL306IC1NyRX4+XhjyUnvUBQHGVrjiJY+MOag0JCmLnU8b/mMbZ9AgBvfBVtKyD0eh/pGjTs4D1Sw2a8Namr8gbA/ejLvsJEwCQf14p2sCUCAqFEGwxjZZIhC0X7bQRQz+m1YX9E5dzjpWns9F5D5OiRbdiTY4pmEoUaKB2MfuWLOIU+LGwziJSaa2kupyo5GI+tfo0vCKuGz8RWO14tMgQisEhhzWzAJWKvuFHaEjOh6KlHqMAIre9oistbgd8dFfAPw6UGA764Pf6M2SjZiycQWMfQP6NGF6QsgnYFWFELLMeZOYi7K7/wcR/fxobzCWMpHjbR5cSGFsAOiD1qS9ONjGm3FMCk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 13:00:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:

> The current global sysctl compact_unevictable_allowed is too coarse.
> In environments with mixed workloads, we may want to protect specific
> important cgroups from compaction to ensure their stability and
> responsiveness, while allowing compaction for others.
> 
> This patch introduces a per-memcg compact_unevictable_allowed attribute.
> This allows granular control over whether unevictable pages in a specific
> cgroup can be compacted. The global sysctl still takes precedence if set
> to disallow compaction, but this new setting allows opting out specific
> cgroups.
> 
> This also adds a new ISOLATE_UNEVICTABLE_CHECK_MEMCG flag to
> isolate_migratepages_block to preserve the old behavior for the
> ISOLATE_UNEVICTABLE flag unconditionally used by
> isolage_migratepages_range.

AI review asked questions:
	https://sashiko.dev/#/patchset/20260317100058.2316997-1-d-tatianin@yandex-team.ru

