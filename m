Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B79CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB40B6B0005; Mon,  8 Jun 2026 11:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64346B0088; Mon,  8 Jun 2026 11:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C886B008C; Mon,  8 Jun 2026 11:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B180B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:18:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D0E6120166
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:18:40 +0000 (UTC)
X-FDA: 84857102400.23.DFD2C28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8306880014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:18:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1uyet7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780931918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbanNgvzOTBZc/hxgfXOVnrR1EORd9B3hY+LTWCW/Mk=;
	b=pWLG+oAjvm4XSrmgQArc50wSq0nFRvXIRsIy8wP8SHSMGFvdBsAPQ+gPCod8V/AZAipViH
	uz+H/vF1M1T/126SIUk3wPYBGQlO11SL5gyuRE25fU7rsLwirVTvXi31216ibPM2bM1Hff
	SJ+zZLIZSmW7TcTTn8PhMRH/nyaCYpc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1uyet7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780931918;
	b=dXMN1+xeBhtargEk/Z599zt2fwAd5P7w/2CVs11Nvw46nR2WVynZ/GfCQvZ+Zh6m+mq0ES
	pqdr9fXFF7wT3VAcpjYDW386Na5y0MZwalWDqwBq7kIH/YOfZko77TKpCprjN7tOEF2Cs9
	KEhclc0mdbyARZYBm+ukemq80piBF94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10C8D601FE;
	Mon,  8 Jun 2026 15:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91FB1F00893;
	Mon,  8 Jun 2026 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780931917;
	bh=tbanNgvzOTBZc/hxgfXOVnrR1EORd9B3hY+LTWCW/Mk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q1uyet7hoyFl9IWg+nYeyondribXFjMAh2LCw6haQsZg1rJhTAMlv+zCb90FebntO
	 q5mTQED8peHtkzPqcVgwLLSvEXsIWMn1DIKxjuVd7gu10UKcZh71cH+SLvzjkohKhq
	 SN0oa+XNFw0/gOWQVaudBYL109MnmAyoDPtq6UkE3PD50OiTpQKbZfPyUiEr6H0IJJ
	 VZpjsU4kZ56FWy9NMcYfhsFxN2Xd1097YYgrXqaichBKME1QVQnsH6eyl4XXENmY5o
	 NYbvOzVd8dSXTToc4XMdKuYWUsgmrAp7aKi2GQVSZO9qCWR/Sd6WNyJEUCDHZ2rrWR
	 5cGCgnoMMjoBA==
Message-ID: <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
Date: Mon, 8 Jun 2026 17:18:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
 <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8306880014
X-Stat-Signature: w18qo3sdbsm9t61xyjsxp6dowrurwwok
X-HE-Tag: 1780931918-863302
X-HE-Meta: U2FsdGVkX19wvBv9WjMRRosTWxysNdAyQSNdLoIF+yA/zm9KnTEuq/TbJ7IJ8duDDxuCCIeccT+UFBpG98qPk5jhmNcQxpcAO8mLa796Y5EEHUeHZ5Q1rye9OV6S3mUfe/PdevP3U0WyLTcwMr1djQXB7WWZDhufOMKED/oxCo9GQOJLJOQ7oDUUhHxuxyQVwLTn7HSADDeondIvbOP/exR5omr4YJeCX4UB8Nmd6Us00dnkhTOpjYFPP6tZV57/c63LNmKwEYRKmGNQvy4YWUU3vP8WDOHvEEWP7pDbosexQhK6xqb9YRkSbdFIxfDnIwOYVT6uIRVysrSHo+2ucfLGGKMpCJCZeTQlG5K2mW21NEHKXd8QnZO/KhI8Pa4EFIVbGZmmKv87b8S4EduxWZdaAGThDj+814wcWiYh6cBKr+75vXhEZF7NbIlrtk0gtRdJPkk2e3+O2rU79atL57W/gP8rHZtPZ496jTl5vUwCYu2FRU5HRRgiuth7ipcQqVkFWjbTa43KOz2RcaB5qS7wk7Rh+dqsGdsh03JtVAbsednfHKCG86EG45CtJGafERt0z1V2RDRp5cwhs+TJXx2sfLx7BLUKo7FkelmUYU69ibPOZPLuMZLDSVGw3K5AbPWj6D3aGoqN3PJhbaojt/HEMDZ1YE8nybWJXv0wYZWHp1qX4JUQZS2yGoBt85/DM6s3DkbdA910nAmzUQBrP5O/Ls38TRagjtGax6xMoQc5aFNBt/bLaXNBXhMdNrHazRGE6lvonZW/ZG8T7UpIqnWmj6lQfmJCLpF6BkjcQIzGXOLtnHjYP5RRlpMknWXBJXFRQst0tibqVL/r+S7T2fL40ItKOnvmOSfB/DSdzyJiLPmACZEW6UtKKVD/TLYvmUL3dOAEwiiJnvqqoSgln1l1pXVbV8HjCNRRvDAwUcDKW+pnfrwbafwLy2LINpnSLMvutRnKuia7JVxGDeh
 vn2vs1M0
 2GrbhNbkMRXlHC8tsZ83+mq6xwCKeSH4p3Q769AC3JWnvCBTcyyX6hFmsbLLmKuqr+q5OkHZk6e1awWyIdVqhEO/ys1/OdQC9sfr8EIMOPoS5l+sVJtHJ01B+cAeutHGs0NKSPSqd0rl6zIOmbxtCCunlxN44pGGYj5KedRI96tqPq9qMVkgv74Gylg0EO8g8CDOtWbgFC8m4p/fPaEp6rEVSD8MFwYhGR8GmLu1bnI065aHYZReQoFV5Iq91GRw/ieQehRWGiMzhIe98hgpzdhuC9wu9MXMUbVsC+NoLq0N2FVB6J0d7/43hDKxd3MCzuLtrgB1KOGebxSb8Yu8IdFO1bnryD4umMQC2yk3ipq6HomsUvYba6kme1ov9QV6x6AoG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Sashiko Comment:
> Does expanding FOLIO_OLD_STATES to include BIT(2) silently corrupt anon_vma
> pointers on 32-bit architectures?
> The anon_vma pointer is packed with FOLIO_OLD_STATES inside dst->migrate_info.
> To separate them, __migrate_folio_extract() uses info & ~FOLIO_OLD_STATES.
> Since anon_vma objects are allocated from a kmem_cache with align=0,
> ARCH_SLAB_MINALIGN defaults to 4 bytes on many 32-bit architectures. This
> means a valid anon_vma pointer can legitimately end in 0x4 or 0xC (meaning
> bit 2 is set).
> When __migrate_folio_extract() masks the pointer with ~7, it will silently
> clear bit 2 from the anon_vma pointer. Any subsequent call to put_anon_vma()
> with this corrupted pointer could cause a use-after-free or a kernel panic.
> --
> 
> #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
> 
> I initially assumed this to be always 8, confusing it to be same as size of
> unsigned long long.
> But the GCC docs note that alignment can be smaller in size:
> 
> https://gcc.gnu.org/onlinedocs/gcc/Alignment.html
> "For example, if the target machine requires a double value to be aligned on
> an 8-byte boundary, then __alignof__ (double) is 8. This is true on many RISC
> machines. On more traditional machine designs, __alignof__ (double) is 4 or
> even 2." 
> 
> If my understanding is right, Sashiko concern is valid, and I can't safely
> use BIT(2).

32bit makes this tricky indeed. And that's also the reason why
FOLIO_MAPPING_FLAGS is currently limited to 2 bits.

> I see few option from here. Either I can gate batch copy for CONFIG_64BIT,

That's a bit nasty as we'll have to special case 32bit vs 64bit.

> or I can force anon_vma_cachep to 8-byte alignment via kmem_cache_create()

That's an option, but I would not do it just for this optimization.

> align arg. Or I can change the migrate_folio() callback to pass already_copied
> info to change to dst->migrate_info enum.

Can you elaborate how that would look like?


-- 
Cheers,

David

