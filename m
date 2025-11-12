Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4893DCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 06:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28CE98E0003; Wed, 12 Nov 2025 01:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DC18E0002; Wed, 12 Nov 2025 01:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B0C8E0003; Wed, 12 Nov 2025 01:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 053198E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:09:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 589DC5896B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:09:10 +0000 (UTC)
X-FDA: 84100927260.16.0A27409
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9985A40005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:09:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lm49z3qx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762927748; a=rsa-sha256;
	cv=none;
	b=uJc84cCKUvyoR6LfJvB5NOvc21nD/0z7AwP54hwAiLSFVlUyxVgJWHnJFvr664GlJ9cdDh
	D4jlDOJ2C7RSrxG99FYSlD/HzNuIInB1TOruEzeNmZgG4K0XVcnbY68sByzRD8U1uobnR4
	61i4s7bBAakfjPSDtLSj4spUUty4QB8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lm49z3qx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762927748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Vf+V3xa9EgGUbHOlQxF1xdJJTU0DRTndVUemiyXUeyI=;
	b=PjhTs2obpwO3ZeUU8H/lgQw+z5FMxOt3kg0O+9jRwxY2u5nPzu0hbEicSGlmXGuQrkJMfi
	DfyEef9enDqyb35MZQjP86yN/30eGEKMcMGfX70xu+FY1Je1hlgg2ZCtk89Y1IP3T6x2H4
	HpSsaWbUr9D2qBejCAA7qQbmU4Dz4E0=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bc0e6d91222so64835a12.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762927747; x=1763532547; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vf+V3xa9EgGUbHOlQxF1xdJJTU0DRTndVUemiyXUeyI=;
        b=lm49z3qxVacoQEDk/spXTPiZItvILZdRs7qpgSH5dmCUmBTHdQylU5Ra2Ypt7Nm0UF
         zSumG4yQLrcmIbvNMN2/DX4MtQZBHkuKyBQPKh+9Q6V16UhmDgKC6gD7oPc6l+m9I2UM
         02PO+ZsOgPGD6LU8pP8SwckOQztA7qGvjgN/GUU+MsM+ghwYFKHLC5JJ3yryecR7Ixh6
         IlMAoTJvwMcPXaWd7j4xeVVozJnAaWrjWlYqTxP4CS+2qbedULQ9bY8zl4lxoaUm7iry
         s6RgyQ2wC7qGln+ElhGaROj+hWmTUKnbb6mNXQ9ALTRQeDre9yklUEweZ9Spe9hCaqnm
         a92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762927747; x=1763532547;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf+V3xa9EgGUbHOlQxF1xdJJTU0DRTndVUemiyXUeyI=;
        b=w2MafgOPq+EqSVTB5du9koAOpuBWFWFhwjD3sGBmFQ4lXCHvZRHv1/1uPMzGnmCEs/
         x3ScGUGXx2KzrCt3qZ9pcYkohUqPXcvijypKqUcYMCWELkYlxzAu2y+FYUKy++GmfwY5
         PuxRFUbsy8paZLY4eLr1gE4uX8k2qpyKj7WDPjGItsk/fSaLVN7L0/gzzQ6F17R4D8XD
         q9RviSUPIDsk1m0wLP24UcOLp99eLH4/fyi2IkTM0z7kSqcULexxx3fLLir7FePlOgKw
         u0173PJirFx0v1FxPDvuyi5q9HeeMd1HvvNA2jOllIM9qePAQHrkk7dvbQ79TsWd84zp
         ytSA==
X-Forwarded-Encrypted: i=1; AJvYcCWRiqqlHrB6ytziprCdddMR2mlaDhy/qGelXM5wiG0uf48IET7dJJWFyGmHiSsj4Agb7jlzNks9uQ==@kvack.org
X-Gm-Message-State: AOJu0YyoSzEucWYbokPSTeSSdyB5jOCxFha5BadMIA1zKuoKtqtNoKRP
	1+lsK92cMPCZE9k7SCZ8CHg0YtjYUfHyId0dAPGYUj3eSeC09EdeonU6
X-Gm-Gg: ASbGncvMEU7u1d/3p0Co8DKoOo1sh0mka6+KS/gInG7u4jhfG2g0bM1dr/G1tHyILfO
	o+DAWv4CLRu65Sy0tmsRRt5+y05j5d51O20zX6kqGvmRvwyHh27Ab7GbqtyBpx+X0f95etOXWkJ
	eW6Oy+uZZvYZjNckxGoiYSnXWVIL3uxWhI2qBOJHuGUSfH3k8QJiBhJVdiQEYxlkaCDTTmARk0a
	NX1g4rAMAOnpSje4hxwW+ixs9TbGxBHPtUmNjThUVwOuzDGVXtNC7XHIAJ7B/qgLLRc6u8faVt6
	De0eSLZKYzIyQ3pLqIfYP8zeDg+iAWpBREMgvyUz55MPo5/2/YWl145EAdAkGVVKfw4dc5s9ZmN
	nxF6ioxwDUInm4loS/qB2SMMg5AYcj77nyqg0uxPB4PjlnkaTO9I7/DRaO/6pE7TFPjRocpM=
X-Google-Smtp-Source: AGHT+IEohiT6l/U6Q6cSeQX1Sd4BBaq0PAFAEVh2j8GuYXQZDYJogJ/Y0Dgu8WSYVH4jJhCDgr7O2w==
X-Received: by 2002:a17:902:e804:b0:296:1beb:6776 with SMTP id d9443c01a7336-2984edf314amr25324145ad.58.1762927747094;
        Tue, 11 Nov 2025 22:09:07 -0800 (PST)
Received: from dw-tp ([49.207.219.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dbd8cd0sm18094405ad.4.2025.11.11.22.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:09:06 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Vasilevsky <dave@vasilevsky.ca>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Nadav Amit <nadav.amit@gmail.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Dave Vasilevsky <dave@vasilevsky.ca>
Subject: Re: [PATCH v2] powerpc, mm: Fix mprotect on book3s 32-bit
In-Reply-To: <20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca>
Date: Wed, 12 Nov 2025 11:03:52 +0530
Message-ID: <87ikff95mn.ritesh.list@gmail.com>
References: <20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9985A40005
X-Stat-Signature: ajp4u8sdupwz1pz96esrfuq9xxkco7qw
X-HE-Tag: 1762927748-495563
X-HE-Meta: U2FsdGVkX1+xrNZ6PSqTkKEMEYvmAFxR+jZvCvIrbrdl9Nx7ImrnqNAhk4T5QGpT7THdMjErYsKZMepAqm1Vd6y8U/QLuDWUwjycE0EsupLHJjLKW7OrAvaVQeglE2i0DzQhD5iTZR1pUHefHlNHIhpPFg2UwABNB4CzDzGwMiFnDD4Q7wj98uWVJGnIXLD3dP+MLtnkkZsHM/Vsqu2fM6CEsak1czvGaQ85KWx86AfqYy7QLFsFGG9HS5UrJNeXKc2A863O6muopB8ntVPpfr/TbEQsqknb9z0UINM+he6dbOdDEzuhtECESVIqSLLvYGXneKi3ti8gNCUpFas1EfjDLf0I4P0xkjilOmMfX5d7/U7LvlR0UIX0QktC0urJHden7QTwUovu9h3891LuDq2FlfDCPqkUzeIo8alS4up5iwrgnrlS/nu+8U/pNqE27ejrXvjMtBprboDBXvWO3JWeyBWhZ/BauOB4mv676cPVlnNxbFntZ4k7PFh5/qtk6sP5QsUfldAD74pXvRV3Oef89+iO4eRAthcxuUQ7zNQ8VJclzuww+rWPTLHUtY8cBHJKbCpm2/aRf5bMWjR+Lwzs8ULiOGQuJC3PSMBSKOghUbO+mWX0PRoJ7IDhhqAx7t6kSKq8mzI7Oz+cgfayonVAMvq7jX+fjsWSp/bT4VAdVi4F7u8fYijo9qPvAOqyDoEbiQms1wObIJxE+I8Fk88q8eDCFO9SLGdu5/Co7JRKDF5jHM+iXm0N8WFfj9NdBbWJUApOjAAvtKOx2dcPQd8D7KZ8JncgVzpZyJ2vIJP+c0IFn9eMsmUKNoLti19KMllmi0pmJ0ylf74u9hpgkPD5OxpOF5GeARLAElE5047qfCn/RE/lYVwrHHct2xN9oI9v8AbPxc4i+WhPCfte3eaed6l7zgKBXHniZ55/ZuBJp5Q4hsOGwrFMNT/RiJK1BOPBv4zOGASRlPbsqLk
 J7aDNLJx
 nlWdK+gNKc4/mqT4fOouHm4cc5CyTBrrdevyYYeChqzjV1pYBkxlD3UVZrBsLoah46V+MBC9LEbMT0MD8wpwq7x0RRjgDWNbbvx8Z0FQqQRIbE0J4Zg43sMJZMPjJ+5scbZz+BCgP+g3x8qXRFMgisg5xXsjGHexyvwY558m4dTTXn7CG9VVh+uys7pBClicuGF0UlhAGAAgpU/DVhKTka3qOJHud0RYfAZEMlReOy1IAsx0nvOi6RbVCgUX+z/wbRjWl/iMNPPt4+AAIF8ZmCZoLkH0+YFPM4qTr7+imEfF3hV555Twu/Qq/wym6xi83pKaRfkKjh8Zwl63SlZEcRNHdHddFbxS5dGoSQPasyE/dulyIdloDwvcTDvK40efgwM7Oh5gUUPf/vpIBtDNXB+RMnUculOWGTJ8RclvXJGzxIMIXbHhw0ey/pAofB6NVuvumPFjZCiV6C+xBvXcn8H359aBQDcmQ7cTVjb9P8oxwzRXVtxz1U48RIE89CKXzIdmsKJ3C7/a/kfuB3WoN2Ep2Sf1pkr6XJecMSdjeCrHMaazL2wj65WQ2LFTZYnMxcZAWx6GqRZowa4jZ8CO3mcUJXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dave Vasilevsky <dave@vasilevsky.ca> writes:

> On 32-bit book3s with hash-MMUs, tlb_flush() was a no-op. This was
> unnoticed because all uses until recently were for unmaps, and thus
> handled by __tlb_remove_tlb_entry().
>
> After commit 4a18419f71cd ("mm/mprotect: use mmu_gather") in kernel 5.19,
> tlb_gather_mmu() started being used for mprotect as well. This caused
> mprotect to simply not work on these machines:
>
>   int *ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>                   MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
>   *ptr = 1; // force HPTE to be created
>   mprotect(ptr, 4096, PROT_READ);
>   *ptr = 2; // should segfault, but succeeds
>
> Fixed by making tlb_flush() actually flush TLB pages. This finally
> agrees with the behaviour of boot3s64's tlb_flush().
>
> Fixes: 4a18419f71cd ("mm/mprotect: use mmu_gather")
> Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
> Cc: stable@vger.kernel.org
> ---
> Changes in v2:
> - Flush entire TLB if full mm is requested.
> - Link to v1: https://lore.kernel.org/r/20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca
> ---
>  arch/powerpc/include/asm/book3s/32/tlbflush.h | 8 ++++++--
>  arch/powerpc/mm/book3s32/tlb.c                | 9 +++++++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/book3s/32/tlbflush.h b/arch/powerpc/include/asm/book3s/32/tlbflush.h
> index e43534da5207aa3b0cb3c07b78e29b833c141f3f..b8c587ad2ea954f179246a57d6e86e45e91dcfdc 100644
> --- a/arch/powerpc/include/asm/book3s/32/tlbflush.h
> +++ b/arch/powerpc/include/asm/book3s/32/tlbflush.h
> @@ -11,6 +11,7 @@
>  void hash__flush_tlb_mm(struct mm_struct *mm);
>  void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
>  void hash__flush_range(struct mm_struct *mm, unsigned long start, unsigned long end);
> +void hash__flush_gather(struct mmu_gather *tlb);

Maybe I would have preferred the following naming convention for hash
specific tlb_flush w.r.t mmu_gather, which is also similar to what
book3s64 uses ;)

- hash__tlb_flush() 

But no strong objection on this either. BTW - I did run your test
program in Qemu and I was able to reproduce the problem, and this patch
fixes it.

The change overall looks good to me. So, please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

