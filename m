Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B587CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 20:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689938E000A; Sat,  8 Nov 2025 15:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639408E0003; Sat,  8 Nov 2025 15:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5011F8E000A; Sat,  8 Nov 2025 15:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38EEC8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 15:18:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB4E04C0E6
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 20:18:44 +0000 (UTC)
X-FDA: 84088552968.06.7A69D3F
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2772940002
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 20:18:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C+pyQQfK;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762633123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=eptMmi/rSmOF7zh3lnbB0jvPX8L9rhMmLXfTARMvAA4=;
	b=38drfC0PJLlYvkE6VWnSa4P5Inanskf55lkfmiadJWbdXQPBHeRnnApaPNoSPA/gQuY0je
	0Ib+/qLcIJ6EUGn8AjdnzHlZjjPrLWwfYDGh0L6xnwuN+1wVDbCOX87summvaNHYBSvPyo
	D64RV0vjjs2dp2IitoFtDKqpxC8rphI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C+pyQQfK;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762633123; a=rsa-sha256;
	cv=none;
	b=UH9eZaR6VPuHGdclQLB2KlCjGGi9exMaWRfL42shUPgvBq6pFyx53wF2N1EbFo6JquB76t
	38D4KoF7D62B82gdJ0gq1vQa+f93sdsYVI3VVfnJd0SuDKS1jZ/ilYuMKNkE+kcB4x07KM
	LX+aPEmcdU/wROFbALha8snMlu6aqnI=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2958db8ae4fso14852075ad.2
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 12:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762633121; x=1763237921; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eptMmi/rSmOF7zh3lnbB0jvPX8L9rhMmLXfTARMvAA4=;
        b=C+pyQQfKssAYE8SxFc6gr4pDMavEhN7575X5/IEjjHJ3IPt5kmokrAth8bDAHbadn7
         lHQMmNNEWDkOuYmZC/L3f2wLy65BiXn1vIwPkg60bT+tDVeU0biNx/8uJUX7doQ8rKjP
         xdZSi/jCdsLsWZKUMlTcWj78xquygIU05+AEkNW9cIlPwuGtUnsXdur/at67BgDMu1e1
         G1bS575euq6Wn4u6eZLjwyOlH66ED5GuMT6opxlizPbGE7um+xgDchVWMlfHiYGJtnyI
         merLjL9zevgIVsaBQleNbnGiwKx/ykWxErbCdhuUTXNhgeMue3OdxJaqDXmDriVXbVx7
         MsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762633121; x=1763237921;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eptMmi/rSmOF7zh3lnbB0jvPX8L9rhMmLXfTARMvAA4=;
        b=P2Lct8XI3Db3I/dHH3qS5YlwBy0xlYC+6dhL3L6SurrfgpDdK9Nkjyh6nvkgfzvQaP
         DvZVDwA/JJwAXYsuS81iWtXycW7VTLcuRzsQVVd+3YhsG/9IHbX4Q01C/0caMOI6QI4b
         sR5MDvLKewerLV7xD5DB0k3j+WMPXIKYpDsKon9ZncBb8wG435FynwcYDw7WDK2K8SWJ
         X+BdwRZY4AHK0DFvD+PyvTnPzyDKRRVmptYisyR6WMoauQVOwZspnxTkOAqFOfBv8egL
         43aURha71g7kuhA/cDnH2o242iPUPc6KE0ec+AAtB/pQDoVSLQKLmW8ECndAf0oxkVXJ
         N7Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVn0AOICtAAMWR59pzisMMnMEuVMsjtJh+ThhXQw1sHQKo4A//NOEjrKSM+WDoOcmEaomGsCq2dxQ==@kvack.org
X-Gm-Message-State: AOJu0YxFiC+6PDh8BR7KHr67UaZYZVyV5WwxO+QuOv6x6Skapo1bXiRG
	uoPPi8jkSE0jrVhSh2YNvrjNLihBG1MPAZ+Eti4SKuYjIIiV2SbORRpuHZRDiIGVUWU=
X-Gm-Gg: ASbGnctilpaf+5sss6mP+8X0AxsplrWnyHRs+PiFw6Gew3U0dILAM5E4AgZFr0FADYn
	ruhqsu9cZHX8bqJm9MQYDq/GZIZBZPUO5NBnA5wNmxi82jex84igK6eCx1zhGmhZmbaGG6VKrmJ
	N2iwKlNFbtrI5OXGKnfnli39Ar/a59ljDKhrwSZwxHYLNLMWT0y100o6KW/OMLkzoy6KRpO5Tjt
	8QxozZQ9Uwzp0w17TLwyxL+rWN+VxOFbsliGTKJLwSunkpBNkgvRk94X40mHp4z80E4dR3Y8p9J
	JsGEMwAt/+TgWF+F/PYPNLJ/0dBYWZmmYK37xyWJvYRyMC1+r3lmdiTMY1+KUdHMAUAPF/85QcP
	7U2lqeTmC3xqqAjhacUE6nQoSww89gGzu54YvOc+8A53CETtUpEVY9L6hdS9YjEBJLojFaQ==
X-Google-Smtp-Source: AGHT+IFb5ZIMhb48UQ+0j2VRNphIuxham09NgnX5MSt7QH3z4h9Q5UU4rBsGOgTmioZaQIMKF6pn6w==
X-Received: by 2002:a17:903:f83:b0:295:5613:c19f with SMTP id d9443c01a7336-297e56f6b9amr42076845ad.42.1762633121076;
        Sat, 08 Nov 2025 12:18:41 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-297d766efe6sm44719285ad.49.2025.11.08.12.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 12:18:40 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Vasilevsky via B4 Relay <devnull+dave.vasilevsky.ca@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Nadav Amit <nadav.amit@gmail.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Dave Vasilevsky <dave@vasilevsky.ca>, linux-mm@kvack.org
Subject: Re: [PATCH] powerpc: Fix mprotect on book3s32
In-Reply-To: <20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca>
Date: Sun, 09 Nov 2025 00:46:04 +0530
Message-ID: <878qgg49or.ritesh.list@gmail.com>
References: <20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2772940002
X-Stat-Signature: x3os8znzzw1u9sgzuzrthapu5foqdjb7
X-Rspam-User: 
X-HE-Tag: 1762633122-998947
X-HE-Meta: U2FsdGVkX1+Flsdia7/d5ujuIWA8f3UzqzSMHt+LBchzRgHIXMW0LlSjk4vqQUpK4dNJxXYIOuTgCLKkdz+xI1LF2KWBXmfWaXO2SylXM2xbjld2Fzjo+e+kscpYkpjCDeA7ueB7NBBjcwslIqB01GvAt9l6JlOi1iSfoOBXRzKiCuqB/NuEGPsJqJlqU38gMPBO/chxAfCwzPId2fadi++RyDHtDKo3ckPmE71Zk+dcywfa/H7BTW5JxOkFThSe9Awvrehk82hVB0FfsHCajMuqYSts9lnWpEsa3rOr3jawSIqjaw0OpAJROBVcLZYjE/p8B2SRtmVvHL+PevAzEwdMCtyHp1lqk+C9js1yT5kvJm1GtoWttMswcSRfy1tljCPo62Z70nrykIfKnMbdYUWtNReiQqqigkXrhdChLWoyNrCto3Nvbb0vRssHd6bMvh2cn98AiOUUUzYlY/fHIPy4VBcsSwJUh1SNKqcMZDzuE5ek6OcnXZLZZR6AlhgANOnnE4BulnTjv1x6TRg8sNQgoWuUSM9Ggg4GSPnVe0nuB8ZmpzfRf+UZpm9z3pX6Ota0sDVYmMUZ2zI17b42WqEAl4PjXGvbH0Ac4l7xNtlN30OpRK7gnW4LJlfKUrLfix1G6NMLnIAJQCNWyoRHBMiimWdM1ej5HCYrlqwgp5ojpPkSiew2EBRPlJ10NB4tajlPSu0ryMQWatGiURT+aK+5fmEjPheTHh0vo0xFqq2vyhhik+flJTiSKj9AUKWSQYqWXKi0gzrpo/NAbhb2Bu82KLhtTKwaXDwEBpJlVSrj0cg/MQ0MlTq3vDPftKo3+bOW/lVPwqT3TOnsYO2S/uv4QIOCCZKTXoNnAQcFPh+dvFRPZEf0e9lCu+06D54Wb+O7tnaduO/0FMQ08ksdQNVXLH5qLVsyzZ0ALq61vDFxtgDVfsdnf/MHI1NubDh3Gpdt5esyjuk4PTe44xx
 yeeLSkpN
 Ri1q40Q/6ZvRy4aIPWqcbPbChBVnhY3Kimy5tqcHjFfELDWi9SF/WsJGFaVBQPwrnX4u9gI3yvpBeRilvYeo03PLClqnyPQua0lR85OUsoEsT2yKkeafIzua+xs6WV8TSn1EHa0b1W9hrnywl+TmtWY/Fs+eZGGyXQqfBErNxqc0hWCKx7uw2vV4to1U8UZuDzt71j0SmtXfOQ2RCtaL6HBSq6PQCQdf+Po+NxG7dOJBRZphBVzi+FEDw/Seb8rYlRqJkXJIQ43PyHAtnTXF1g9/ubT21o4fLAVyjnovx7FEcwPOXWRVKQIQ74vwEHejb6vMEYNNbTihNLjXIyyyWh45wOOjW2X6PGyuPn1I1z/lN1RFKp24/Pz+CF8NvfVUDqqpy4suy1eRbFBR813bElUWelu/duaDg+FxVObq6mm4ste1zlYr1uYNt7Md5FonF6uth57gKg9Fo8lY8IpPREp78WAFpPNks8VyLy5GVixrGJ98vb2aH5OB5xMJfwbPa8kVSvjDtRi/Vop6yle//hWMZ6O855sApRQn0i/hjGfVSz4aCSQwI1pCujH9YmniR8S0BiUdd0LyfqwGHLFGesXmYiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


++linux-mm to get some pointers on how to test such mmu_gather changes

Dave Vasilevsky via B4 Relay <devnull+dave.vasilevsky.ca@kernel.org>
writes:

> From: Dave Vasilevsky <dave@vasilevsky.ca>
>
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

I am surprised how come this was not caught? Don't we have any straight
forward selftest for this?

Not just mprotect then right.. Many other MM paths must also be using
mmu_gather right?

>
> Fixed by making tlb_flush() actually flush TLB pages. This finally
> agrees with the behaviour of boot3s64's tlb_flush().
>
> Fixes: 4a18419f71cd ("mm/mprotect: use mmu_gather")
> Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
> ---
>  arch/powerpc/include/asm/book3s/32/tlbflush.h | 8 ++++++--
>  arch/powerpc/mm/book3s32/tlb.c                | 6 ++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
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
>  
>  #ifdef CONFIG_SMP
>  void _tlbie(unsigned long address);
> @@ -28,9 +29,12 @@ void _tlbia(void);
>   */
>  static inline void tlb_flush(struct mmu_gather *tlb)
>  {
> -	/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
> -	if (!mmu_has_feature(MMU_FTR_HPTE_TABLE))
> +	if (mmu_has_feature(MMU_FTR_HPTE_TABLE)) {
> +		hash__flush_gather(tlb);
> +	} else {
> +		/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
>  		_tlbia();
> +	}
>  }
>  
>  static inline void flush_range(struct mm_struct *mm, unsigned long start, unsigned long end)
> diff --git a/arch/powerpc/mm/book3s32/tlb.c b/arch/powerpc/mm/book3s32/tlb.c
> index 9ad6b56bfec96e989b96f027d075ad5812500854..3da95ecfbbb296303082e378425e92a5fbdbfac8 100644
> --- a/arch/powerpc/mm/book3s32/tlb.c
> +++ b/arch/powerpc/mm/book3s32/tlb.c
> @@ -105,3 +105,9 @@ void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
>  		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
>  }
>  EXPORT_SYMBOL(hash__flush_tlb_page);
> +
> +void hash__flush_gather(struct mmu_gather *tlb)
> +{
> +	hash__flush_range(tlb->mm, tlb->start, tlb->end);
> +}
> +EXPORT_SYMBOL(hash__flush_gather);

Shouldn't we flush all if we get tlb_flush request for full mm? e.g.
Something like this maybe? 

+void hash__tlb_flush(struct mmu_gather *tlb)
+{
+       if (tlb->fullmm || tlb->need_flush_all)
+               hash__flush_tlb_mm(tlb->mm);
+       else
+               hash__flush_range(tlb->mm, tlb->start, tlb->end);
+}

It will be quicker if someone already has a set of tests which we can
run to validate. If not, I will take a look and see what tests one can
run to validate mmu_gather feature. 

>
> ---
> base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
> change-id: 20251027-vasi-mprotect-g3-f8f5278d4140
>
> Best regards,
> -- 
> Dave Vasilevsky <dave@vasilevsky.ca>

Thanks again for pointing this out. How did you find this though?
What hardware do you use?

-ritesh

