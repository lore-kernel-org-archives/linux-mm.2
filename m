Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B21EE3686
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB48C6B0095; Thu, 12 Feb 2026 09:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EFA6B0096; Thu, 12 Feb 2026 09:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D615B6B0098; Thu, 12 Feb 2026 09:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C51496B0095
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:02:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C564B62C3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:02:30 +0000 (UTC)
X-FDA: 84435969660.18.9F4F595
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7F5144000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:02:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LxCgJiJP;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770904948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFo74y0zOAZJ1gXikBmhZ5x7gnmWzyBSYEmf4KFlu6g=;
	b=Oz5h1xywZ7mtHV7RGTzdSijt77QYWNVbm/4vRTc4BvcZ5IELPiwPOHayTo1ZpZLqLNlwsJ
	taLP7q/KYu1thdtcJjkPt4LYtjGZh3lHmcs5bCdiVg69PYyIQyH1iDmR/09cValoCGJMvT
	kHNujcRIEp5J0Y4xsJsMl8h3QbC3Hs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770904948; a=rsa-sha256;
	cv=none;
	b=jWgM5nvtzPPVO30Q2LUWdHB60j31DWz8d/3e3uPeZU1NX51U/QPfAx4z5gPLUlILHWb5FN
	i3/M04ijdK/ia39XkYvsB4hPZcuPgfZobrnb2dCVBx+TiUJr5z+wAQ5O7AM8iRPptgFYw2
	vaVnrfpmryHsPI1anv+q+mxIFeTDb0Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LxCgJiJP;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8249aca0affso1023131b3a.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904947; x=1771509747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TFo74y0zOAZJ1gXikBmhZ5x7gnmWzyBSYEmf4KFlu6g=;
        b=LxCgJiJPtpcqMrczyMZqCn3dzgp15B+u3iSEN4ObYtZgTjJmiGg7eQwfOAfwetgL9R
         8L5YoNaVcDtcYBw9H/PMj1qdsQbD7kot/CbXdajaBXlrOaPChd5NEQMc9NwCK32V3e5T
         uZ1l1CEoVuWQnjG7fjcmb+mwiJJVeqT6OIRFXj+JbFi4YvQg2dac0yrFR8yCRxsLbkkP
         uKodfb9iEQANdnkGWjEeRsgWbZEOkeUkFNphitXanUmAjWVuZCp0hJkbGXUdqU5NI+7w
         bPgGWsx5GKcavVUmae3k0oWsLBHzLO0/+wzKOV1h8vkIyqk7oW0Kr8xZfaV7RdW3BqIp
         89bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904947; x=1771509747;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TFo74y0zOAZJ1gXikBmhZ5x7gnmWzyBSYEmf4KFlu6g=;
        b=qLq0lyWwArdLl/k1BAKrwKJgOUWW8ZpDMpQkR1UfbtRfafmC0LEnn9eoOEiP2V2BNo
         s7AFe/aDbIfPqMMDrGyZaFU5EWL2nvzaF/aqHJz+9L9EnOqXaoZTzApf2SB+iod9ZL/t
         MP3WF4GEXoKzGeWFgzse/zCHCQwERjwxZd61B/nH6OiqFsEJsLNOiSs6XqiCIMjzCvj+
         0JpsHd7Q8zIasxudEvpDn57/xt4TKTJXoIv6KgTEDvxlTurfw/j8xx1kxTeH3SqpXPEg
         2MkCgSC/0JZkLm+jqVpLm+57oHasBRU9tdhFJ0smO1Td9WLZ2DQIDCSQJejZ17ZInPAG
         kSGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYf0tMZvQaY4nievE5t5xH0lgejS5o+3tvVCqkMNhyi5RyEEGVFdT/cSVEadhkPeqgv8J+6UoiVw==@kvack.org
X-Gm-Message-State: AOJu0Yx/fC7kWOa7sgv3VL2bHP0JdHhsFCFeoBpxSCYEnISC4fNr0vIp
	4CtTp7J0YcYubjpycX2fBbpf8yKL9udj5cqsPirRjZgv9UDWM+Lq8TkJ
X-Gm-Gg: AZuq6aK8nzIriP6vnL6hxUJRmyOqDAKS0ToVxELv8zYDMP9nb1A2KpuFyBPARQ12gFI
	5ARIJHymYAi2avyCb5uuH9E/Tk5nJM63uMUU4APM/hGg78ZtjpX/2UYUa0HAdhGQE6LyCbwjb23
	0PxRO4haRp7ETRxJSeSx2W6d2q4M+TsR8Y4PLsOCDD5XHe0ixHLq7qJKGVdEQy2OwyiEnDgAeZo
	O2e/wjHrOMaoEgyaWQ895zrlJRRAReFKqyh0X/wCerJF9aClMuc+k6X3YPvc0G4WwmHhBw/HLeh
	ETi/bDEBXeOOQDZTABllTvf5munCnwRJyebgboOgoDsQOIhhLnYiCely+9Ekqc/15snSp2zyA7i
	Uyahu4bc0tT9d+zvjZGGBCjn62OSGqNHtzEvAh8tACnS+6wtBUPepxNy7i9atCpbE7wjGzRQiBI
	yGxUWE39xBbUa4m8j0
X-Received: by 2002:a05:6a00:a24b:b0:823:7ac:1417 with SMTP id d2e1a72fcca58-824b05a920bmr2508988b3a.67.1770904946842;
        Thu, 12 Feb 2026 06:02:26 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd8cbsm5369677b3a.24.2026.02.12.06.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:02:26 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
In-Reply-To: <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
Date: Thu, 12 Feb 2026 17:43:33 +0530
Message-ID: <875x82ma6q.ritesh.list@gmail.com>
References: <20260211125507.4175026-1-usama.arif@linux.dev> <20260211125507.4175026-2-usama.arif@linux.dev> <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F5144000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4it11755z6833ooq9inyadkz8y88eyoq
X-HE-Tag: 1770904948-390381
X-HE-Meta: U2FsdGVkX1/MxGZWBd/4S3oE7XULlJVjUwXMIQ7JA3WFJl7Yv+O8cvVBn7dLtI9dQUbAIYaoC0QcgbEqAx0inpgtDGnx7nDeyXK/jjW3zAJdQx5IA0aEAGGsvuemoi2Hths5fvsOuFhL8ktkVzoku4l2XEYNQKHXbCd+cMlZo8EV/hPEfYBfORERssCSuGBgUT1EyvgdB9zoLkiV5GXKdMUpTxR9HhX2i72wuigoOGDRuvEvevzFNZC9ShN5Xftok/AHgY7vhilZ6MBWh7xrbcwRUHprfdlFlVv+MU4JjTfCY/ccBez/c5BqFFmqpr0o94T9fkeGkAiCkvqxXGpx/CH6gYUrtcaX9P1ekbFg+sGE616SGwCGUnnEqSpIjoNAbhvWHPSn9LMyTi7iC0doIMoQ+b/Ii3VPwOMhJeK8RbdOq/m6/IAOsOosrwUTbmDuNjjurGUM5v6pM3H9IHRhojFMZWhSIxrPCzRBJKHp466SflCH5H3ud0TqoX4enupSZ3GmJZ/l7WnWWCijNI634NO+GK1HL04kGwb40sp1REY5qJkfBOGEx7oWMXc/ycY0OwQLvy8u4ijmhs2SwWIvEUeXmk0tH45y4fXBR0GRyfbNIAneA83jo3LNBHsa5+gx7wFtL7fi9HVMoLmxDiTuyO65zobz7fX4qPrCfqtvkzBpicYiz7Bd7xsl5HuBALKCDZE3t6x4g9T0c0lc614wHivuLoHWwtrz4FnhZAjLrdsUFAEMgYwdmBN7DdIFbnzZPLlDCnpDurWgP378yNZr/qZAu4k5wEbKtW6fyFXNVZBkwfAj09mI5M/PAATqSp3rGJ1mS5qAFkHzePGuEliCgWinR/j+0FSwW21fPuvHwmbO8K0kGLaPYAFLX4l3z08jGUnxQPBX13kRdXDPCau5n9nNlId0FC+l4lp6QekaMIZsXDQbiPLACekQyQH1Kn+Cy0Toa6rE4uU+6nZfou4
 n1SrEWig
 Vsn4If1R6DZNUGosLLdwPMYL7HhTBj7jQ3GZ6JQ4RRH0RgUeYXuraaUMZIscPuv+Gm2wKOsDaSViVaH80Dz9y1uyVy2Ngk5D2OLZ+ldq/Qa93N7kKpKnkd9ziJLcdPalZRSARHSh3RAe1HyydIjPBoiOWSYSq2daJlvfgnfAH+8RsBk3ssGjj4A1zcQNaOL0V7wKYNYMGlJ1Ne0fMQ+auK+X2+857rQtIlTtks1Lz5qgXB6hOYDZdYe7rCZB8hP1yLR38Pl5I9Mc5prpOg0rWiZarTbzYEH4piVV7l87YyfD1Gjqc46WP9AF+JXKmv/ipWGuI2I2RqrLykUAc8CcoX5QOex4dQ4hfPhQiw+FZVb26/oSELgXLFaGnkJrdr5qcUN8s4rzeeVGlM21ot6oN93lKYNya/D1erdfM71qPIPzXE4h280LZujMjuNBMGuHm6UkUfEJCopoXMCGraq9zdU1tpo+Fmyja25UUbFPiY9kPVP4X4zHi34zAxXz8pRt8wV+sIErZwSBkvoc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> CCing ppc folks
>

Thanks David!

> On 2/11/26 13:49, Usama Arif wrote:
>> When the kernel creates a PMD-level THP mapping for anonymous pages,
>> it pre-allocates a PTE page table and deposits it via
>> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
>> PMD split or zap. The rationale was that split must not fail—if the
>> kernel decides to split a THP, it needs a PTE table to populate.
>> 
>> However, every anon THP wastes 4KB (one page table page) that sits
>> unused in the deposit list for the lifetime of the mapping. On systems
>> with many THPs, this adds up to significant memory waste. The original
>> rationale is also not an issue. It is ok for split to fail, and if the
>> kernel can't find an order 0 allocation for split, there are much bigger
>> problems. On large servers where you can easily have 100s of GBs of THPs,
>> the memory usage for these tables is 200M per 100G. This memory could be
>> used for any other usecase, which include allocating the pagetables
>> required during split.
>> 
>> This patch removes the pre-deposit for anonymous pages on architectures
>> where arch_needs_pgtable_deposit() returns false (every arch apart from
>> powerpc, and only when radix hash tables are not enabled) and allocates
>> the PTE table lazily—only when a split actually occurs. The split path
>> is modified to accept a caller-provided page table.
>> 
>> PowerPC exception:
>> 
>> It would have been great if we can completely remove the pagetable
>> deposit code and this commit would mostly have been a code cleanup patch,
>> unfortunately PowerPC has hash MMU, it stores hash slot information in
>> the deposited page table and pre-deposit is necessary. All deposit/
>> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
>> behavior is unchanged with this patch. On a better note,
>> arch_needs_pgtable_deposit will always evaluate to false at compile time
>> on non PowerPC architectures and the pre-deposit code will not be
>> compiled in.
>
> Is there a way to remove this? It's always been a confusing hack, now 
> it's unpleasant to have around :)
>

Hash MMU on PowerPC works fundamentally different than other MMUs
(unlike Radix MMU on PowerPC). So yes, it requires few tricks to fit
into the Linux's multi-level SW page table model. ;) 


> In particular, seeing that radix__pgtable_trans_huge_deposit() just 1:1 
> copied generic pgtable_trans_huge_deposit() hurts my belly.
>

On PowerPC, pgtable_t can be a pte fragment. 

typedef pte_t *pgtable_t;

That means a single page can be shared among other PTE page tables. So, we
cannot use page->lru which the generic implementation uses. I guess due
to this, there is a slight change in implementation of
radix__pgtable_trans_huge_deposit(). 

Doing a grep search, I think that's the same for sparc and s390 as well.

>
> IIUC, hash is mostly used on legacy power systems, radix on newer ones.
>
> So one obvious solution: remove PMD THP support for hash MMUs along with 
> all this hacky deposit code.
>

Unfortunately, please no. There are real customers using Hash MMU on
Power9 and even on older generations and this would mean breaking Hash
PMD THP support for them. 


>
> the "vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()" and similar 
> checks need to be wrapped in a reasonable helper and likely this all 
> needs to get cleaned up further.
>
> The implementation if the generic pgtable_trans_huge_deposit and the 
> radix handlers etc must be removed. If any code would trigger them it 
> would be a bug.
>

Sure, I think after this patch series, the radix__pgtable_trans_huge_deposit() 
will mostly be a dead code anyways. I will spend some time going
through this series and will also give it a test on powerpc HW (with
both Hash and Radix MMU).

I guess, we should also look at removing pgtable_trans_huge_deposit() and
pgtable_trans_huge_withdraw() implementations from s390 and sparc, since
those too will be dead code after this.


> If we have to keep this around, pgtable_trans_huge_deposit() should 
> likely get renamed to arch_pgtable_trans_huge_deposit() etc, as there 
> will not be generic support for it.
>

Sure. That make sense since PowerPC Hash MMU will still need this.

-ritesh

