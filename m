Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46467C4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AF46B008A; Wed, 22 Jul 2026 02:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE596B008C; Wed, 22 Jul 2026 02:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF856B0092; Wed, 22 Jul 2026 02:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2D3A6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:23:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25EF2C0372
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:23:35 +0000 (UTC)
X-FDA: 85015421190.06.A07DBC5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B4F720007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:23:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzNq2ujD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784701413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+uZjLLQiIyJL0MNzejDqd3cWL8cnK0hiaCvU3lz9wA=;
	b=gtIQiEap/6hOhgAlvGsek8oMfBkQiBsL5Q+FxAwp4KIzAv5ZzJr8gYe0f/fEkh5+GgxWf7
	2dB1m4WWBHcvqz12t36/x8jq+ceZlG2qx6BInc64kXWdP2BIY6FD8RBJ1J2/6Sife3ydjJ
	jsAi4JS+nacN6vxlVJx5P3mSPgC6dYU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tzNq2ujD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784701413;
	b=qWJAmcFjPW/Mxnkq6Cn1D1NiKEDcebfoBf6wLSTakkdyEMUiXiH+AMMRNhLcJv7Ijc/1HQ
	D0XE/THLKGxcX4R6jKmchQPrLM+tLbWWiHpkxTQfIm4EHq6rgeNBH2AbKw9bcwfe+sHXtU
	RwSBnFne9FAIcoBFESd5d3HWHWmRAkc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784701407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+uZjLLQiIyJL0MNzejDqd3cWL8cnK0hiaCvU3lz9wA=;
	b=tzNq2ujDDloIPimF2kNcLfziGZkN9+cx5QiImual87rKZ1RhOi2sXu7LV06DGOMeuxcaqk
	Aw5LgO6eTu/mVxB5SJufTWiCxsFIWSkuIdi8mdNdz5nhodQuGRZEoh4TNDb0uGPX9/idfl
	2VzKxLsyLeOoNvDCeSQebtG+22IcZTU=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
Date: Wed, 22 Jul 2026 14:23:15 +0800
Message-ID: <20260722062315.43584-1-hongfu.li@linux.dev>
In-Reply-To: <20260721180232.0984ad6fd55ad43053b3a079@linux-foundation.org>
References: <20260721180232.0984ad6fd55ad43053b3a079@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B4F720007
X-Rspam-User: 
X-Stat-Signature: p55oreex4khiusuh5e7accpdfzgwhj5j
X-HE-Tag: 1784701413-544750
X-HE-Meta: U2FsdGVkX1/jrlY9qfyZWvPv41hqsZDfxJO95M6PGytfv++NsCvPL89utzSj+BE+gPDSMaaAXi7WKVGRnOdeySYG+nQxQaMxpofKLHX6kjxWv5RuAwPydUgdBAdOD+tQcvtgkE1JZLWuoaMenYcS56PClzmmV5LwsQtJJorh/KRj8sUguw2UWtpgkSajphoGGRIHTA9YfBXfXMyVOamLOqzLhSnfFIN4BSm81DJLf/3Jc/AMzEy5fqhRQgn8bWFsz53A3/5Ul0qpXSc59zDuoEplJpnckcMOg85Gk3JwRiXJStPbei71EKHbklXTy4fCKZtLnQsvPTVix9xLxgfsNIfHYe0P4DA0M6lgcYzJKw/Tkmap7KQKQtm/5lTgZaxrAcrwAo7xgskTQ+W6yL63cWFGUJ/rrYqUL5Uc/lAXVEqn2hKI1v90xjH9IBvwrZ2ctM/QTTjAVFB5zY4H/qV45R1mD1FtX/ZOTQtbzuLUzY3Cctbe9bik27lve2VsVBbdYqef66gchCCuTq8avP5przeVa7eG+UwumptzSpW6H2KqhpN5ta9IDiH2zU36iR5A3s42td0WivKsKQtV+okX+S/igdXJJtObBGUmV6B6KdxVN12cSgkZQf4sYJud5Hnh7P9OX123rLHLTiXAUbjJsqsb2CnyVrG5D6ucVb28G3FVoUW32kiaBQ8kcrXvTK+6vgTmZsaYZq7YYDJLWc1jAAJHsP1aT5PGNKy4zgehYUkVGp3Bp1wwanJUEwg9lBTdX/Yejk6K+eRUtql0JSobSkI5ly9o6rFWvWHOJD9ANwTleZvEN9FG4DJdaJzUht88P8vU5s6C2aSwDF+RoOLsrDmSZHkYZlItFDYs9SvCkBxMSXVZ7wZiQ/N2yNN1Y7JHNN+e75OJ8JUCeCV3I6HLYqtdexr7TgkVmkUeW6lbpD5dMyl5nbbSpdlW1Q7nq5xEKAxcVI/RTRt2mHHzEqy
 +3mia6lB
 lXywSaGuFBj8DJLPhLpqav7MF8EVjf66XM0RW85ss593u1Hk2nyUXNQ+okERLSg2BELxIEYx12fTOlZIKaxtBDi/nN630p8YgcukSKnpMTSBRwELef+7sjWP4IxWbdCsKQ3tRnWVk1/6Wt0x8o+wfsaTFR9qDL7iRX12ntFg54+dZEuiZfuSTFOYhXlMx/lUwjxkqSwDM8j20+74kRyXgzHEZPoTBRrzMz9Zaf6YXSbF12rFNJ72O0nu5n6PFIIJSR+21CX7WSD+55feHs4SmFCgxtaw++QHXImA1RpYt61wvvbD2MhHJ6Plpfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4852,6 +4852,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  			vmf->page = softleaf_to_page(entry);
> >  			ret = remove_device_exclusive_entry(vmf);
> >  		} else if (softleaf_is_device_private(entry)) {
> > +			struct folio *fault_folio;
> > +
> >  			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> >  				/*
> >  				 * migrate_to_ram is not yet ready to operate
> > @@ -4863,6 +4865,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  			}
> >  
> >  			vmf->page = softleaf_to_page(entry);
> > +			fault_folio = page_folio(vmf->page);
> >  			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> >  					vmf->address, &vmf->ptl);
> 
> AI review thinks we shouldn't be reading vmf->page until after taking
> the page table lock:
> 
> 	https://sashiko.dev/#/patchset/20260721013347.65698-1-hongfu.li@linux.dev

Thanks for the review.

The AI review makes a valid observation: `vmf->page` should not be accessed
before holding the page table lock.

I've moved `fault_folio = page_folio(vmf->page)` after `pte_offset_map_lock()`
and the PTE validation check, so `vmf->page` is now read under the page table
lock. This fix will be included in v2.

Best regards,
Hongfu

