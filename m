Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24627C982DF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80E86B00A0; Mon, 21 Sep 2026 23:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D696B00A1; Mon, 21 Sep 2026 23:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95D86B00A2; Mon, 21 Sep 2026 23:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A86496B00A0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:33:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E2C31C25C9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:33:31 +0000 (UTC)
X-FDA: 85239978222.25.07E7952
Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35223C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:33:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jsTQo/Sc";
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790048009;
	b=Vbyh4hTPey8MPyJvWdM7JlaoNXLpB+TJtRw4zwJnld2oShLmaOoFnUz3ymq/e3o+GU9bEK
	cswkEihMJo2ejBBbSlirH6HjzjFtODyYcmfuDsIFbKmXFxlv/aXu9iFy+MEDr+ghOvV45C
	bivnMb3ydKYHAQa3aNSR7+byyVw7U2I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jsTQo/Sc";
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790048009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPufAAwxGdQR2h/VFyN2Q2MqxpDh1KY/Lmudi/oRr+E=;
	b=KycQ9X0/uRs7UKRX2lcEDkYwdAbFsInyAzz+ToISVpftQNATYK21p9262vzIuNcT28Dcor
	R9NCBvCbZNGK/aheoGAkhHuDWmpY3bSTt8fLJC0cwY8FUzM3f0sLrTM5SGdi1eibmebPgj
	sMky3vjHAMy1NGh21c8amBWPW1V7l+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jsmJwRa/fQr2fXpiMozTq7dippLPIT6++tb7uYe4CZE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790048006; v=1; x=1790652806;
 b=jsTQo/ScQ+WxjmiN0fEw425xrIZ9q+LdipdIkErEP13bFoHEmPcmdWhbQuKpWRj+HA3Mgb+8
 akbh0mbuMziAGJlI1peZGULX5haSvMltMMkkUDvdXfdMMSYENqjM1SsCmMVg36e0g5kvirSqZMd
 1ErqW3cZeOF+C1Dbp8bNOTmo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c0aae00e32e5a8cf;
	Tue, 22 Sep 2026 03:33:26 +0000
X-Mizu-Trace-ID: c0aae00e32e5a8cf
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
Date: Tue, 22 Sep 2026 11:33:08 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3534C571-DD8F-4FEF-8206-3CA4D783322D@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35223C0003
X-Stat-Signature: pscu6tsm1x1s1w1cikwhe3ch6raad3rs
X-Rspam-User: 
X-HE-Tag: 1790048008-278671
X-HE-Meta: U2FsdGVkX1/YDYjrd6FEceXUmhJl3967fnxHoOc5+FwqoDVeATgK9cSrtFIewIgpUTNYY3lBKil5gfCVNjjcM7PUrpHTZdMpmKhzz8hP2fdmRP9xhaq/UVWQnMjH/YPz1c6xVvW+uw1qruTdhpDmoms2W2qfhW9gG34XrvfPGh6XR3SmuOxAGuLMGrJ2vJkMLmY1u4MHO0JXK+579aF4N8BOYxTPZ9S8Bjv+HSB4x1gteIdS30wlIFMBfpMQWCePtap5h1k2SrvwLaFC/qbjd63UooY6ifuytR5ng72D8br5tM9mCyXofMrpVu6apLRkm7XD0i6+BYT02mTdHlVj3E0QhIKbsmzd4j6UzWSdeCYpBMs7NrLwTKH5cSZEqMwlAj0E4RzjZt2iUs6bd0JuJD5Me58i6r46cxLAxx9QOwbGqj9fRvORUNDa2j25Tb53wYecM3e6LHUw3a1FPRleAhLL1ZWFqXxHMzwC1xDs//s72UwUfqBc1WQ37YrR3szrFtLw8CxRN5WxFX2km+mPCwwEk35OXUt9liZldg3SFrNVYeYz+DA928HBDkSJXOY9CRr5+jLyj8Ow0nJgpg0sjgkZ0SbyknSktoH9klw7abZGW7p0OtlccllyOc/Pb4A6T373k3oofWWDdZUE+zdjO70jwjyZ39D+UOhpqsLe1IsThof4kpZc6HZwhnj+1fHfsujhiYnpoJuftpVm+RPCNKgP5soVTgViim9YfQOwbMfVqyHKuZYh2Dc1vATfrg4IP1ooBfyNbSaihf7S1rSl3tB8u9hDAsJ/aTprfptwk4PpaCy5aUA8OsTS/v40o722ij/nBUeyadiJVCZL8i6JVOHNBHs/5LA1ZXM10ZOyvutvt1wizXDca6xui+G5csnzzqSJNl678pmhQUKWmX022HAj+JmIgwedJBnoLdnH0vvgnh3qqB7x9x4ZzRfEmC7Zzbu4OMWusUUeM05k46s
 s/k9Zleh
 1A1aKrhP1gSEgtaSi2C8FXF1OxdzkOxPqO5CWKRC+7+hbxNOk5YJRVMmMpJkIPUphjIE/TGKZQFy2tG8yZp2v0ugFXXc0YwKOiISJnTvpSRoKUA8lrYqq+weGFeTRlRLu62KIVWgEE2ndwT09XGwGKvkDbrGQe6hBpmw2PfQJX8KboQSY3PhGP8BsjixXUCsAS7x9pHqI3k4aa+H8Cbfipu/JgSX1NExkJasqPKOX5h5O9vKFc8DJ23FUjeNtZIIKWzDIMVDE6KHTxY6elOKZhl8A20u1Ni9OTd+sIMRiTBx6X6UDhZiT2hAhCoGU1GMHNt2PUHKwISdd8QP2SpTiIUpVmwt6XLji1gG3rjN2zOFr6n/AxvgRRlnPq/UoJmoQvwKXoC50h4zERySRepWTn16eZ8KnnJyP0W3+ZmdVmShNnbC0Bdc4jZMlCkSwDAz7OhNz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
> when a huge page is handed to a user via hugetlb_alloc_folio() and
> decremented when it is returned to the pool via free_huge_folio().
> 
> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
> hugetlb_alloc_folio(), so it is never accounted, while its free always
> is. For a migration target this means the target node gets no matching
> increment for the decrement on the old node, so the global nr_hugetlb in
> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
> affects the failed migration path, which frees the target again right
> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
> same helper.
> 
> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
> folios, has the same asymmetry: the folio is handed to a user without
> being accounted, while its free is accounted through free_huge_folio().
> 
> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
> decrement in free_huge_folio(): a successful migration hands the folio
> to a user, a failed one frees it again.
> 
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


