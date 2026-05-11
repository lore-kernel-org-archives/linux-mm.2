Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA936CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAF36B00DA; Mon, 11 May 2026 12:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1286B00E8; Mon, 11 May 2026 12:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEAF6B0153; Mon, 11 May 2026 12:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 314236B00DA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:49:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF81EA01D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:49:22 +0000 (UTC)
X-FDA: 84755724564.19.0C15609
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41557C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:49:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iwom6Y0A;
	spf=pass (imf10.hostedemail.com: domain of 3jwgCaggKCP4pgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jwgCaggKCP4pgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778518161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5JRk3Gs5cW/rB1bt3fcvkhvfAgO2Qm/GtAi3vtMAZg=;
	b=DXn0Z1Di+GVlF/hvbPKiF5exXqykKCuAukPzqyCAXjiUmgD0C8QLju4D/yUv8aH2vTT2RW
	MOTobp99BHx4gczlq5tNXDHRmSegGR3TPgzJCoF3o4Q2BHL8YqvoNn2ZqKA0pR6GOYxawB
	mawUBfH9cSWlaT6RLoUNlIgI+gdOiM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778518161; a=rsa-sha256;
	cv=none;
	b=wxbIO+IrgEbgmsnw8fzdVdTbE0MZDc/Am51m39OwNEd3xwHigcq6EQZ4OxiFQkRPV1GIMm
	bIrSP1o58r62bpPLV03UwDYIxglXT6IvXg4Kn645w/4bYiKOmu1F/0F416Njwk2SUZdO6W
	m2Kw/eSn4sztBUDMApTUgf6wrfz6Lc8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iwom6Y0A;
	spf=pass (imf10.hostedemail.com: domain of 3jwgCaggKCP4pgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jwgCaggKCP4pgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso4312689f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778518160; x=1779122960; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u5JRk3Gs5cW/rB1bt3fcvkhvfAgO2Qm/GtAi3vtMAZg=;
        b=iwom6Y0A3cyP1VfVbf9S9eviqcps7Yecjh6vQ0mNxbCO6qQqcoypnFpWlinP6/lJFi
         JhA3Fpg7NQwD8XyD9sPwSK1xaBR2FB0TvXXRYUTHJ0T74L88yLn4P9yYCjtwm06vt8S8
         VeUENZk6DwkIQ9Vo3y1iM4rEbCLbi4Sm7fLPb7emXYYmiwxKDXHOdNlqOxFnUxf7o+fD
         Hte9VnSz0gH5UpUBxlcryFOnO6ONKwHzpm79n+y/7cXjav3e5GTEAjjAxTOTSjLhpKNq
         +RllqEElWw2ClRgY7YNTy9OSoUPQ1BYaxgXfko3p9FPY+Ffhtwc0aaoKpx5BCPf97X/a
         DO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778518160; x=1779122960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u5JRk3Gs5cW/rB1bt3fcvkhvfAgO2Qm/GtAi3vtMAZg=;
        b=Bn1tdDCjSPD3nXcaR7YL8afrqyUKigwYDPROdr2KoGAGXl4W3AbsKfclyaGLBOUG+x
         zxJPm0rmIy+8YTUP5oJXeja8w7S0srb7yXD1bIbWS5tSfNFBjxWrfc0JXl8/d69przsJ
         DJOq3jOt9V2NTZjli2wgSBSGAP8H9G74U21BC0Oy9UQzPRYwzUXRWitvkvrBXD5U9xKy
         FaiWEnFQeP9RNlQG+WLeOhBdrBQfFaVAi7bxlZKANeVh2jnunZ1Q9IvPgPWl5auf1wOi
         tCJIS1dXYFu73p/wX45tezj3XQTRmvRn2fjoJ9UThT5Dask4kYlPorCmBs+OJCWxwdTD
         WhbQ==
X-Gm-Message-State: AOJu0YwhT3T/nbcG8+9jBRDaN52oamYYbY6G0LDoyZf84k5KUBxloP64
	/OKE4KjdXnXlYa2zPwL1RfaSMzke5wTbRFGAvr3WjJjOmOC9UFWAGeodoKzC2d0BUzaH7NiwepG
	PUQrds5fg4uYdgw==
X-Received: from wrrg13.prod.google.com ([2002:adf:fc8d:0:b0:449:9039:96bf])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:420e:b0:455:544d:68c9 with SMTP id ffacd0b85a97d-456a401aa22mr16802688f8f.25.1778518159355;
 Mon, 11 May 2026 09:49:19 -0700 (PDT)
Date: Mon, 11 May 2026 16:49:18 +0000
In-Reply-To: <016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com> <016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIG02IRTZEXG.22IYXOVI83DJD@google.com>
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41557C0004
X-Rspam-User: 
X-Stat-Signature: dtie1ufczj9h79nynbw7jkyn1bn4ja9k
X-HE-Tag: 1778518160-788128
X-HE-Meta: U2FsdGVkX19yatyRFPK6S4XmZ6Py0iKHGinNYpITYzdR6UaX+umnwVvJ+Gt3p254GK/MVrqHST1/OvPvvAb9HzHbHbwmBSp6JslBzbUyeeTFQF6JmG6Jae0B0Dkt7Nw8yLKLC9qQ+83w0zN4Lhpn/BvXJO4z9o3+k8piz7oZxbKRRbng/h2okh5+PkHvHonEMQnp19UBl6uWJDoGkXBMQY03v+6OZv5AaJwZ5s4rZEk+CHY5V4NCevQvFA+Re7uDQWk/MUW1tI3HYCCLuA00GjXKqyDbpX0eSp5YkMO2t5aQSMVWzeJDVGnuN9Bm/QMGROqLTGa4QgxzhioHthc1DBHk6FbdqZdx/r+Al6Z/kH7NWBUuJmqfJ09ItekydaplHcl0LYTr1RPwa2U88S+dmhWy8Baz5uE1AGDqjgOiuVMGIZPt56uQHORVCOClkXU7LR8wwvNKXPTPDcgJKQzFYkX4b1TJLko0AUo/UO6LfjudKhEezy9MgiGYgZtgfPMpvdZOluTdMyyHLEl3xi3ybgcwzdc2tQys5Nvz03SBe8eqpWXszjZ2YnnTU6H4pg19+7q8uS6H7ge69Tstk1gmC8vRdcKBuLlNW+sHJHCGjDoCn9s6X/y+2b7EFQqPBbWLTIdsSHkMTXbgzWGWhJG1thesTDLWOPfUov74IxIIy8ajNx+xUhyRurcWynGVFdEB/DeAAK8xMA61y21zcCTBxdaL9gaLCx66ZECb5lvZ7/z0Ubq+gztodoT1tTHigkKQDAAvhp+uCMMkM+QzrtBXYCv9GpAFm5WM0keqP7jzv2DhvAzDblnd7Uftf/FxHsDJJZjMPiEXdNneWUBYGU5cAljCwASViZ+FX10NEsHVcodmw3iHM1oUrQCJxnZTg1N6A0/j/UxRJ90G/2pZc31rQnhz6CHStjKhOH3XKzJtz/MpF6jhFsxI/2XC256wb2togdLCug/hmXoBqLCSsRx
 j1ND7utv
 4z8FE+UfTRW3K6JdETSezNlZ81OUG03KTrJV+uZpCKozVXnbHetcZ3ydmLDGui+OL++vk2qKoCNGduBshAu8bdK2ZPv2Vh1NWhkAQ9CEB+pNqROvxtH42nJIXvLwDigDr5m/w7Ana62kvKRHBfqfGYYDR2L6rcnSu7DDTCQqOqlTPeaKZWqKmU27Bt0sMIlWjra5qi4bYcbqwITVI+BbxTl+atwkaAwADOCJf9UAabiF/aLYYCeimnEN9gUwzgNbHBvOvuTlzMdPt8AgdbWC7cnisI1j1agt8/pP+OIpwurKrlXzWue3ibZA8qCH5+CPQGd2v8dMBfD2exLatSeqikq9z+wJCHC37THr+Ghx3zLHmjtQ0rwsR/QLdsoieJ2wV7y1cYTFYnSBM544a7uRwn3HNnIHfBX+YOwCi5rC9ss1oIsmVaqXy2ja9YT0VroMHl8GKWBKcZTuNQlrG8Mr133e8b7XOHqDyjmQQh5P8PzgqsjVTk5Od8xY+fGlYSNyYBAXuvay9sZAwgfpUVisUwP7J4bDkd/KzL6hi8XtHbj+JgJ8Yy1JG12JE4nHAEQCm3mIaXSBzFTOCNqW5kumTH7t2FMqrIWMGJHUYXCtDKOnZ1s+G0BUj7hIifg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 11, 2026 at 3:34 PM UTC, Vlastimil Babka (SUSE) wrote:
>> +/**
>> + * __get_pfnblock_freetype - Return the freetype of a pageblock, optionally
>> + * ignoring the fact that it's currently isolated.
>> + * @page: The page within the block of interest
>> + * @pfn: The target page frame number
>> + * @ignore_iso: If isolated, return the migratetype that the block had before
>> + *              isolation.
>> + */
>> +__always_inline freetype_t
>
> 'static' too?

Yup thanks

>
>> +__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
>> +			bool ignore_iso)
>> +{
>> +	int mt = get_pfnblock_migratetype(page, pfn);
>> +
>> +	return migrate_to_freetype(mt, 0);
>> +}
>> +
>> +/**
>> + * get_pfnblock_migratetype - Return the freetype of a pageblock
>> + * @page: The page within the block of interest
>> + * @pfn: The target page frame number
>> + *
>> + * Return: The freetype of the pageblock
>> + */
>> +__always_inline freetype_t
>
> And this is declared in a header so the __always_inline is not really
> applicable?

> (seems we should fix up get_pfnblock_migratetype too)

Um, I think  it probably still forces inlining in calls within the same
translation unit?

Anyway I am pretty meh about this, I suspect humans and compilers are
equally bad at making this decision, I was just trying to be consistent
with the code it's replacing.

>> +		/*
>> +		 * Fallback to different migratetypes, but currently always with
>> +		 * the same freetype flags.
>> +		 */
>> +		freetype_t fallback_ft = freetype_with_migrate(freetype, fallback_mt);
>>  
>> -		if (!free_area_empty(area, fallback_mt)) {
>> -			if (mt_out)
>> -				*mt_out = fallback_mt;
>> +		if (freetype_idx(fallback_ft) < 0)
>> +			continue;
>
> How can this happen? Is it preparatory?

Oops, yeah looks like I need to clean up how this happens in the
history and clarify the commit messages.

In a later patch I add an optimisation where we avoid having freelists
for freetypes that never arise in practice. And in those cases
freetype_idx() returns -1.

