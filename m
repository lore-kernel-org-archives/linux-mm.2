Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C12C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 18:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D7F6B008C; Wed, 19 Aug 2026 14:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEA56B0092; Wed, 19 Aug 2026 14:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCC96B0095; Wed, 19 Aug 2026 14:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03C4B6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:08:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C7971605A7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:08:15 +0000 (UTC)
X-FDA: 85118803350.29.36BBA4C
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C52B18000F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:08:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u 5w5tF9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CSQq0HY7;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787162893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uaq+0fbwEcqKURx4TAQgKDlnoNt1749aqNbx25RhZlk=;
	b=4NO3n/TXbf979CbLxW9PjMnPHV/vxPR7H2UKeVh9vS0yugYowm/YIXIPmrtsSv1tfEeTKA
	s57Jw6VcwAkYnkLHu9fhbJlZDmgTugsfANS8WC5rQdRjnWzGPUlSh91r8Vr02Ze73tvKxr
	K+DX5bxEA3pLNqUS0JVZL6ri8K/gC/8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u 5w5tF9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CSQq0HY7;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787162893;
	b=N5KpmALFzJ9oJWaLU4J5lzuYD/1BIM+sO8T/ZI4QVlehNF7/n1DjxsfEqaODyyaQBj+6Re
	n2KzVy9ECGXTGlRqNERueG3H87vNzFm6jS2nNVZYgC5hLCU64VV/y+LfzxN1UlZkdDbkHY
	iU60CGgdr1vYvbYiy9P9N6swKCJIRis=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 6895E13000FB;
	Wed, 19 Aug 2026 14:08:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 19 Aug 2026 14:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787162891; x=
	1787170091; bh=uaq+0fbwEcqKURx4TAQgKDlnoNt1749aqNbx25RhZlk=; b=u
	5w5tF95V3lXZcp5D0I0zfs+ecHlKfmPG2blkZY15q6J5+xaW1Kvt5Yd8bBDrCDNR
	1TUZq+FtPFEiXhbCY2aSYH1dR/0NqHHkX5bQMkzEzGy7ieH7z/G0h8DOW9FytuK1
	Z0qBTiwBH+6SY4MuJM9YdqsqbK7fZwxtLvUxbqGzacL9uW5l1FLiz/ZI8g/m6M1n
	qdI408wm3zB4vX7lDBrmwQfwH2w8zg9uc7Rp3VmO/IScTq9U6SHc+MEhvqArW49a
	fVfRWZMH4xcwsQwSU3GgMMxaEkKOq8WR+O0jMBPHaUqPLc+bOgLG5f1a0IRQInJv
	fkWrde0dQ7kB2ixaGv74g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787162891; x=1787170091; bh=uaq+0fbwEcqKURx4TAQgKDlnoNt1749aqNb
	x25RhZlk=; b=CSQq0HY76xdlaq5ZxlAH2Psixw7Fv1d5/+v1qDCxoWI+QLfvTKs
	+Wttv0ep25W/mCZm2VJ/dE6jiGBkKvtm2mwK+gMvJnnmMFk9uX6kCSRcwr8QwXe3
	BmO28VGnkGttLEnifmwulWQTZVmjUcgUW6yBkqpy2Ocr3ENhlKBTtEdYRuh0noi7
	Whsp1pCFfrz7eyv/b40wfxoM1U9nyiaxn2F36Uiv1z48NYnIvPF+Hv5N093ep17w
	vQRlrX/KZ7KM4LOMys8u568AR23idEmH9V3DydOp8IFpdUPhhbwRbS8ME2LOY6J/
	9xndGtqNVrl3ETwirElPUdJVsXHdpzMM5Ig==
X-ME-Sender: <xms:CfGFamBmv7jTcwHu4_7WZ1usDVB61LkbyCHTGj57imaS5Qs6Xn6NNg>
    <xme:CfGFag9PC1_VlT9T7ICg8IrFgyIt6_gfraXKG9Gx-Mxb9M9rnJWLX_7s0R1yEJFdl
    jSwOrwYFf9-GdaL5sezszorg4nEJgrkDV88fm4GNS2HiYFeRScAlR-k>
X-ME-Received: <xmr:CfGFarC5DjE8pq2NZguhLaP3hS2x8EltD2og72MELpSo5GwfSjVqtoTqdiY>
X-ME-Proxy-Cause: dmFkZTEgoTbh0p34SJ7+/0elPjJ1CCVFNDauFEce9e/PhqdeYc+K+ZgiTHZkYjWz6as8HW
    oQqR7eMJeilkJP6P1vcZe7H7THogp3+w/si1KyGhbFLyCmCZ3dPSp7xAHp9w9JVMzETRjH
    ZGi/BBtM8fbP2xEpT5MXNgJOPYusCj9icwG2R8r2iUSU/Af7shD7UHlpDl2FqwQISqGxrn
    4VHBTrLtusZogfLm1C7BWVIo+E+nsrpLj0jpAuYoyY+biRGqR6g19JzN77aqCq3myX5CqS
    Ub8VqStbhVuyo3lwlRqil4HhAefmg77OYfy+hvKjlo0cc4lJXUaWtMhIMsqxRKBY3dE9Ls
    EM7L17LM7uTf+mZo8Wl70TIRE0ptPYiP/tSP0az76p/Du9Z8wMv+ViEMNvMtIkWhMPlHwj
    GVP9xctd5omGc04HD83qAkNK25YjUu5tn6zQ4NkAWG/C9oBh/HZU3kbP3Y8cM4aK1fqXpb
    LqNz4vAtJFiqhGscoBf4snNRUbxuKWv16sb4TX3eoLDwCBEHTQ/B9WKLkXPdhUOUIgKIob
    Tvxkf2MrVd0T1Ro7nCtt5EPQRQ7gHD5h+IzboECIdC7ZZgl4+OMaUY+lJDQ40FwWSi35ZH
    NJvywTZIbRunZkGTSi4Nf9wcmV96zAG4Q9LJxGfSmcLsbTBh8jK/80HwU1tg
X-ME-Proxy: <xmx:CfGFakxXBBkjw866zcaxeAN8XwJoSukID1GcaW1PPLxULaKrnzrTHA>
    <xmx:CfGFaqrf5vjKwFGgHUgrf28PNDd_wKCxUZPhERsQu-IWsWP8mOBiGg>
    <xmx:CfGFanwyg8yvx0IqclLgrSuHWYJSG0qDArvdTj__rq8LDsP44ve51w>
    <xmx:CfGFakP5BQAMevJkef1rpMVWlvELiICBlM2tyKp7v78gWI6xejeRWA>
    <xmx:C_GFajaxphludb9eZOBP7B56bu181zvGOnr8Co02FXO0mHd60Etj6X7x>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 14:08:08 -0400 (EDT)
Date: Wed, 19 Aug 2026 19:08:07 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoXn1B7cPnPq7uxd@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C52B18000F
X-Stat-Signature: ehen53pp3x3hatcpmrub8zwi8fhr1xkh
X-Rspam-User: 
X-HE-Tag: 1787162893-724072
X-HE-Meta: U2FsdGVkX1+eYtXVOLW98k3yIlhShE6ref8axN7xjDPTlAX3SyM2+k5MuOYs3APojrIIv4PeuClo1w2UMTyeny3PvfDNN9fJqBEaecqO3Lopc9ZFJC4yeNhU4xhFsKJSTFTOlKzM+DwXofgZW+F8gBsCrn6BVW9m5lWlj8Pdy1VFcR6usTHGzR14l/Qi2OmUg9qu9XBNHefrsQsvXnb7qAQzEyL6FAlVUcnqggyRjRZQvoHI+1YgIFRqoHxIoaPt+mo3urbDDKdmq0ubiVqhbL5sQfbbd8PVSJDx7MSfmsMwnoioMDo62DmWCV3IPZK3XBfB6e6STwjCTd/Sevh/KThtmrddLT3kAjRyl9jFTQYU5wZG4DrBiwKczv6ilQCdiqmb0sBabO2F1PjJylTfOM8QouwTNQti+YyHaSFFQVbzec0Kp5p+VUzQ0C72Lp3usACz4NxVcosNpBOtmd6vRjI41Esxj78it4LjbgyVrOuBmRhTv5L5arhSpua0zly3oGJeB58s/87y5Zf/KMpXkNJnI04XQ0Bj7tBCbRSSLadCHMw+sZ1xyDrwLKwli+0iw64Rwauoq8NxThGX/ejNGTmlPEliBqg3ArriDEVUeN5iQrMWaa5+seCVpHQ/2MmNffz/0oIb7onl2GyUUOi4MlOvIHQd9EttRZmvwwruXoZJlM5IrkXk9iLXA+fL6n4PZZXs813C86w9eU1RkIsL11dWVqheV3oNKJ0mfVMNw7gPMWogeRd8S6FKTT8FLvscFuAnurmCq0GfHhLIjHVrCgbHBRjzNFLfVPetdj6fVv3eskqQ4oIa9dywsgihD//84SpWn12A8//K2tfO/dr8tMQT6m+CncNX+EDZX7c9kRT+mffZ/fR8O+49EFlWnTBWcxfRNdHwkzZsgvFwTGI8S8ltiPFiD6yg1I3z9ERFsAfniTZwE5vjY7ECnBx+cbS1FUdLdPxR4JEUB8yZmRp
 6PpATw79
 6IGd9GgphEoxK4VrZ9kVS/Ybh6K1ItE3Pd+44f4E63SEYsTNvaQeROnDmoncQy8U0hgw4HkXHbbGLhOpZDYhRyU6fdGuUc3lFA92q53Vijng2azavSe26vaQkImf0hfe1cZr92pFmM/LL3DT5C9LaR9aAkf8Cr9rD+bm0FuNgmRRbTbjKnAiyG4SUYf0ECi6O2gX/w2ZwWzUCcYq1p/khRc2rBZSA6jG7OPZKjzfbkLhFqYdafVRQ2corRCirMHtwSELLEZd+TVSbNlF5cynQosu/GkBZYn9cJO7HI2C15OdcikVrUsvWTowm7PbbQjMw8tkZDRGFpXldhZL9arK8D4nAT32aiT6eY1YdCXXuTCgxLQgvV5jkfPljgUz6TXX3J0owj0ZxnFeJhirQke9hUxB921sWHlyvokwU/ocD6R9ePdLOUT75b3WM/5azsE5D+iGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:12:17PM +0200, David Hildenbrand (Arm) wrote:
> I think we all agree that there is a lot of room for improvement, but the big
> question is:
> 
> (a) When does it stop being a cleanup and is a new feature in disguise that
>     makes the code more complicated and even harder to maintain.
> 
> (b) Can it just naturally be made looking like a cleanup.
> 
> Ideally, we'd get b), in small, nice-to-review chunks that incrementally improve
> the code without inflating it heavily or moving everything around.

It is not a cleanup and I would rather not sell it as one.  It replaces a
mechanism, so judged as (b) it fails by construction.

I believe the end result is much cleaner. But I might be biased. :)

> The current locking is nasty, so anything that moves us one step closer into
> something that is not only simpler but also more scalable is nice. I am a bit
> concerned with the churn in the series as is.
> 
> After this series, mm/collapse.c itself is way larger than just mm/khugepaged.c
> originally, which raises some eyebrows.

Line count is a poor proxy for simplicity or scalability.  What the
engine changes is the serialization model, and that is the part collapse
needs changed: the PMD granularity and the exclusion both come out of
the locking.

Incremental does not reach it, though.  The old mechanism is correct
because it holds mmap_write_lock, the anon_vma write lock and a reference
from the LRU; the engine is correct because the sources are frozen behind
migration entries.  There is no halfway state that is correct under both,
so the switch lands as one patch.

What can be incremental is everything around it: the engine goes in beside
the old mechanism, patch 25 points the anon path at it, and 28 removes what
it replaces.  Until 28 both are in the tree with only one of them
reachable, so the switch can be reverted on its own.

> We should also be aware that people are proposing file/shmem mTHP collapse, so
> ideally what we refactor would naturally unify some of these code paths.
> 
> I am wondering whether shmem mTHP collapse should come first. (I'm hoping that
> shmem mTHP collapse can unify some of the anon+file collapse code in a nice way,
> to similarly just look like a cleanup while enabling a new scenario.

mTHP collapse as it stands has limited usability: PMD-aligned windows only,
and one VMA has to own the PMD.  Bolting file collapse onto the same
structure adds to the debt instead of paying it down.

It would fit the new design.  The frame -- scan, candidate selection, the
round and its passes -- has nothing anon-specific in it; what is
anon-specific sits in the freeze (folio_test_anon(), PageAnonExclusive())
and the unshare in the fault-in pass.  A file source would bring its own
check, freeze, copy and install.

I am not sure it should, though.

Do we want to find file collapse candidates by walking the virtual
address space at all?

collapse_file() already works on the mapping -- it builds the folio in
the page cache and then repairs every mapping through
retract_page_tables() -- so the VMA walk only picks which inode range to
try, and it reaches only what a registered mm maps right now.  Large
folios buy more than TLB reach: fewer page cache entries, cheaper
writeback, natural locking batch, etc.  Those apply whether the file is
mapped or not, and going at the inode directly would reach them.

> Agreed, I think we really should unify+cleanup the existing code first before
> doing more drastic changes.
> 
> Having a series that throws all of khugepaged.c into a mixer and pours something
> new into collapse.c is ... concerning :)

The moving around is patches 29-35 and the tracing after them.  None of it
is needed for the engine: 1-28 add it, switch the anon path over and delete
the old mechanism, without moving anything else out of khugepaged.c.  If
the churn is the problem, v2 can stop there and the moves can come later as
their own series.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

