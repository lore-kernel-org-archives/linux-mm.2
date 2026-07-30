Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E83AC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9BA6B009D; Thu, 30 Jul 2026 10:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE5D6B00A0; Thu, 30 Jul 2026 10:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE57A6B00A4; Thu, 30 Jul 2026 10:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8CD6B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:32:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17A741201A7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:32 +0000 (UTC)
X-FDA: 85045683744.07.51A734F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70F79120004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgbDucpS;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlCg4hKA/4zkmMDzGtbzJKj4HELVTyv3d6KsqoYYXlo=;
	b=t0eajhr4v0DbW2/uoX1NjgofGmV6yi41XzEoDUvY+wZWC4cdxIf5Yun0MnyVw6xjyOothB
	7PriaxUP42yC5glfhuef0CZQyPIJEcq57Hf91uFgE3apqZ+oAC7gGLlSgJX8FRd5nqbbFW
	NxA1/awhCb+c4rifE5PZnWEPPQaP5cQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421950;
	b=uJV4/khf9eJCiGkudQRbXh0yga0VRiK47u83dTmBzRjw+DzXrPHG6SJTkyOTrusB0yQJat
	DCi+mmerav3j3tIMcVNZirDzu76xqlDVKOhqmTVlnOfmqlB4jyJXID+YHg6BAMKezV1Lss
	uggysq1/DZupabd+WtqlcoOYPcOIUWg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgbDucpS;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEFD1600B1;
	Thu, 30 Jul 2026 14:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83131F00A3D;
	Thu, 30 Jul 2026 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785421949;
	bh=TlCg4hKA/4zkmMDzGtbzJKj4HELVTyv3d6KsqoYYXlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FgbDucpS4lw76IR0ZcU1uGDuE8Fx14VLpEA6jvtHNDM4eY6aznNPUex9EOsFI4D3Y
	 dhcvOkkwO4vFGyDILA8B8ttQTsgtcTYqM+pJSvk7UiKED7DVeJXxjzk8PP5O+Zf+ev
	 cFGFuYOjiZzP0Q2dx+4VpLB0hIqRzgHO1J3prfl95xqTvEfKRBDxhZaVYYCUC74IEt
	 8/+1XmjnyrTrNNyG3Fb6d0c5eKi8fzEUfm33rOs4Y2jaxc5/tTMPkvrVWhvPR/u4Vp
	 3BVln8kD0GBclyE2jzuh578TdsBB6Rb1mk2VzsdDB1HmqiZj3MWsa9K/pomAdFrvVh
	 JDMIZqv8XP8Dg==
Date: Thu, 30 Jul 2026 17:32:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
Message-ID: <amtgdZ0U_UIbx_hI@kernel.org>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
 <178540851830.2154539.6359871825839331816.b4-reply@b4>
 <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70F79120004
X-Stat-Signature: 6xpxsqp1fasmcjari9q6kec4e84ha84h
X-Rspam-User: 
X-HE-Tag: 1785421950-512036
X-HE-Meta: U2FsdGVkX1/dOHQmaFkulE6+oD8jgCCN9OUMgBqW016OJ4guD0xxQZbZylhnHsc59dkopIhgbrC+uMDfs1uRIc2prSGHk3v8zxnRhTYvbfK0WPQi81fkjpp/u8L5aa+ALPQUkMqJlZvOvvHp9Z54o+lK23rwzbS3JjzQNgy9YYucrJ4GD/5X9OrSVf+dxasDGhzvmTfUxTWKB4yGbBzbqIKD4DLm/Gj7adbzKiMI8AW/kdcXDHCgN8w3lKHdBK9LX1+eUznbXc5v2etFPI0Acpl+UCYfrV6i3U9dSL2Lso4YY7kNjCWe9A4o4/KzDzdePJgiUvnmTADmthhkqOHAOuwDFzmBfAJdGCnneAvqsBmNJRtMdk8wtPKVHwoAcvnNRFMkQnATl2s+3C8Nt5xmx7t5Q/jr1aOCHphMllJzVuVeUYylmVmi8AB419pH3gegJHu4LaUHz9qj3gvPzXcqwQzJdygzWdQR3lYhWVh5QFJca9iw9KLsTiK7P+OhX9O+5ZpVI5wIyG8mYCXlvWlNzLKwCulHF6d+Jemovy9xUG+hVp047VFLIZCXrEoiwDqG2pVzP2lta3IPaHjWFi8HTDPW84rOaNK3kqxp7Jxvv5IAx37V5NTPA3RAnVBOk3/Un2Xv60SRNrakQzlHlKPHmLDNUrpzYZ9fTBO9qC4IUtrQEhzwqwpB2tZWC2USwDP+vmozkSVzTu0SEY2c89cCZV0skQ9V2yqITSJSIk/qr2swITG8Dj+G5siMScnnzyMt47o3rWpaMbXvW4iTHFsub2OOGZkaE1JllCemJXYhb+g8ivAGD8wU7Il+xbWZqDExk4MlXnXqDVG11wXJx7DR7NkWvB12Cel0eV1C4Rliowd973BSV1Ym6NQxSAE2+IKJLW76TwMiPGrvSdHZ7L5pYmeWmWOIQDaollL6FqIudHEFcT4Ax8ZMFzUVa1IwuvW67opKbL6jRRtJTjy38V8
 YEHdiSe8
 bNKpObTj9BRzryRPiyPndFykUUNjh863rFq8CTaCHaIUkoxW6kcLWWDaTTejrd73CUwse8jN0RGwaj8cJjUQ/QC+keVkoFhVZ7mjBwI1BPfyrUecIGzitjotbdmT5rivILJJMcyl8dlGscDF7hlZsVMJcPvXW8/QCyTOq/v9fq6nu+z3rS/xmTVt5o2qMGeu5Et/shuDSaT0XKTWbjAtDiTNmYmael4m5W4VSZtoT+07OG6CBo7eRuTkZylXLprJKogkJCmS9JcPgaiLJMcTS/UKIS9xIKDQcqcHZjERRXGL5oMoPsLnBy+J1VPfVeuHRVaB7I0tYJfZHoTf7qjatRbQHNQb3tm6VGxv1d8XfSB9VQ0K+n/Xju0fAvZgTJK0fXmvKh0ltFmKJ7fpX+Mg+zeyrIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 09:09:00PM +0800, Muchun Song wrote:
> > On 2026-07-26 12:30:17+08:00, Muchun Song wrote:
> >>> 
> >>> #else
> >>> +struct mem_section;
> >>> +
> >>> #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
> >>> #define pfn_in_present_section pfn_valid
> >>> +static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> >>> +{
> >>> +  	return NULL;
> >>> +}
> >> 
> >> I'd like to propose an alternative implementation that doesn't require
> >> exposing the mem_section. The idea is to add a new helper function,
> >> pfn_to_section_order(), so that for non-sparse-memory configurations,
> >> the mem_section concept stays hidden internally. I'd really appreciate
> >> any thoughts or concerns — if everyone is comfortable with it, I can go
> >> ahead and implement this in the next version.
> > 
> > A helper that keeps mem_section hidden from !SPARSMEM makes perfect
> > sense to me.
> > 
> > I'd even take it one step further and make it return how many pfns
> > should be skipped in pfn_vmemmap_optimizable case.
> 
> To make sure we're on the same page, let me walk you through the specific
> changes I have in mind. My initial plan is to introduce pfn_to_section_order,
> and the expected diff changes are as follow to keep mem_sectionhidden from
> !SPARSEMEM.
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index dcb757b36902..0b0c2996d080 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -884,7 +884,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>                 }
> 
>                 if (pfn_vmemmap_optimizable(pfn)) {
> -                       unsigned int order = section_order(__pfn_to_section(pfn));
> +                       unsigned int order = pfn_to_section_order(pfn);
> 
>                         pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
>                         continue;
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 030248030dc7..c5fbcdde3cee 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -47,6 +47,11 @@ static inline void __section_mark_present(struct mem_section *ms,
> 
>         ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }
> +
> +static inline unsigned int pfn_to_section_order(unsigned long pfn)
> +{
> +       return section_order(__pfn_to_section(pfn));
> +}
>  #else
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
> 
> Since we also use __pfn_to_section in the patch 14 in this series for

I still didn't get to patch 14 :)

> !SPARSEMEM, we need to make corresponding adjustments—specifically, by using
> pfn_to_section_order to determine whether the vmemmap of a given section is
> optimizable. This new helper will be called from several places, so I'm afraid
> its introduction is unavoidable.

Do you mean that section_vmemmap_optimizable() will receive pfn as a
parameter and use pfn_to_section_order() internally?

If that's the case and pfn_to_section_order() will be used in several
places I think it's better than to have a dedicated helper just for
memmap_init_range().
 
> That said, I've also considered an alternative: introducing another helper that
> returns the exact number of PFNs to skip, and using it solely within
> memmap_init_range(). However, that approach doesn't seem to offer much in terms
> of code simplification. If I'm missing something or if my reasoning doesn't align
> with your expectations, I would really appreciate your guidance. Thank you for
> your patience!
> 
> Thanks,
> Muchun
> 
> 
> 

-- 
Sincerely yours,
Mike.

