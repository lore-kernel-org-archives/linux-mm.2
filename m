Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD36CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CBB8E0009; Wed, 12 Nov 2025 06:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDEE8E0005; Wed, 12 Nov 2025 06:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBAF8E0009; Wed, 12 Nov 2025 06:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8439C8E0005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:15:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE1F891EF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:15:41 +0000 (UTC)
X-FDA: 84101699682.22.D2CB1DA
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id C88D240015
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:15:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762946139; a=rsa-sha256;
	cv=none;
	b=KXi65XhIjDMh/EPcQNEkajfT2LNH4fTa6fLIc1KLdt3HMEd0dONzirJ0oIPuzkj4+KnjvF
	Mf0BcXrOqIevpq5hboie9ltN4iMF2cLCDwGxMdYLIOPFVPEQ689w7Klx3+k9JoiI+an0jA
	01zJcQKk6/h2oFl7YWQNxjy0XSoMmhE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf01.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762946139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbAH9ltoJxJkHN8bSWaXy1SJilPSqT6BewxNoTRwLHs=;
	b=7gdrn8ovyQk4U3WizsP7eX/0BMaPRG2vuBx6qqMZta2Tr7lFB+CRZGcGq7rb+Q37Hs7NOd
	NbOZhKuLWsnIHRvwC1PhEeCgEeHFgLHG/p3Tn5/bzJePVT5/eSHmyB+6MscNoAb4UT7HWv
	zNy4DMybKK673WbjIoi++wPqNAWica8=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4d616J1lGlz9sSb;
	Wed, 12 Nov 2025 12:15:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IDngTuJZ3gRw; Wed, 12 Nov 2025 12:15:36 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4d616J0kqSz9sSZ;
	Wed, 12 Nov 2025 12:15:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 03A088B76E;
	Wed, 12 Nov 2025 12:15:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id WbBSOMNQv6aS; Wed, 12 Nov 2025 12:15:35 +0100 (CET)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 69C278B764;
	Wed, 12 Nov 2025 12:15:35 +0100 (CET)
Message-ID: <caf091d5-6122-4cd7-bdbd-88b3f9a4029e@csgroup.eu>
Date: Wed, 12 Nov 2025 12:15:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] powerpc, mm: Fix mprotect on book3s 32-bit
To: Dave Vasilevsky <dave@vasilevsky.ca>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Nadav Amit <nadav.amit@gmail.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ritesh Harjani <ritesh.list@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-mm@kvack.org
References: <20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C88D240015
X-Stat-Signature: u85ymf8fddsehexa3hwfyoic88inhg6o
X-Rspam-User: 
X-HE-Tag: 1762946138-192550
X-HE-Meta: U2FsdGVkX18q6AbF0pf7zct2qhPh9eCQIkpApQ1HdSXTRmsek69u3axxxF+dsq/prK42tCJ5Tt9bgTF5EuedZt9rN8/4N7Nlv4ohpOrgwsv7qXmEYkaJPU6Yfugh37fud28YEWb+1XvO+TQQZAIzJ/7TiHIPGP7BY5Qx8xe4DqMY31ZYAVArhdCNZ0ApqHb3VzhXWvZyccKArEeBRtE8961/fxuf/AQKRqb2oJHOrg6O23NBzs9o25VWJ601jVxIeUgVDuoUwRbJ2ldV4SrNYLL7q/S7pj6MEcGi2jT9qJ6OR2Lw9u07onDnH8iawNUXQzcR/xcA72R/SxI36EhQd4Vv/SQ61S6QYwuNROmk9gHz5xlp2bLETEBdYDUO+i3mAEgwXDCv8BdPtN//2boLyGQ2WqUGtj//Kl2MNoQ0CH/uek3CHyvLqXaBe118g/31wLqNxLHzX7IVwtbOh+Ffa1bV9FQPS0Q0Ik+TTh9WrGKzXDqKvYw4OSzH5Pu+CieVzFC5YcZSKZTJfNj7FSSSp3TaVHt2N0N3GOhbS+ptUA3af2lWFT+l+Wr5CffI6XUcNzg9xCEiHh9J4rwgiZFS+FDc4j+3/zr8/b066jzsrBCUwzDGlxS/xS7vhlbtlyzG3lwycjAhQeSxC0del6N/yJWmxFuZP8rFsqp4BwFM++bu6pb2KuaWp7cEUz0I7wEBe/GZXrTnTxWbMrwRAaPrv1KeuMlWKRArl6x/IOmJEUj+ZxnIuKWr+w4bURBrNZPRw1gyFIpydldxstVANrRDc8HapdIu00/qZcwYtpK4vOZD8zVnoY1vNoumxyPrYwNaqLfM6p5Sepbx1NjGwcCTIu+YD6WhD+UjDUOmd9oAWUYOnMz4FG5oxFCoBBBtqnIoWPKQTARfyKxeLZVlsYs4pQhkE2qZXQ1ApnsGrOyY/URy1c7h+PmITq2oA2nxmE15T+qgIPltdBYm4F2DOBo
 5QksSc8P
 H84njamem1T5pQB5AAswyqYeGO/IsMqn5WT8XbGHhPbdfFGJqdSpjPOf9AkZuN79017I7HiDt/pDNaK0ZUefIft2gMlcMdT3p/dZRJpEvhDFBgo6CyDJadmG3Gj4qVWZVkY2DFCTI1UCTyhL2MOatOzrr3+xZVfMg+aUrgbmbPZ9mOiri1UYdFkcYxFojyyNfMRHrIRF8LWefx6AeHoFf2D54tv62LIboaMPki9nCbDDW8SqznD09ms9QVUF1LgnhC/Z/rxtZnvKBqeMTVES/5Cy9ojEgcAzRmMwVnXN9mWOGjmSFa0W2dv8r2Bf4lffWL7vvZahMylMQQB/YxdtNkP8co+uepACb2aVGBXRpmJTMvhE64efG3XzZIUDFdQURQRNro96SragZb73mcTxSfQAWo1Ad/ksY4+MqjU4HIADhdZ41eCNxTuG0A5lOmP4W7rjWC7WnRg3vNHtPpEJ7fYT4COV99pVaGf2B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 11/11/2025 à 22:42, Dave Vasilevsky a écrit :
> On 32-bit book3s with hash-MMUs, tlb_flush() was a no-op. This was
> unnoticed because all uses until recently were for unmaps, and thus
> handled by __tlb_remove_tlb_entry().
> 
> After commit 4a18419f71cd ("mm/mprotect: use mmu_gather") in kernel 5.19,
> tlb_gather_mmu() started being used for mprotect as well. This caused
> mprotect to simply not work on these machines:
> 
>    int *ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>                    MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
>    *ptr = 1; // force HPTE to be created
>    mprotect(ptr, 4096, PROT_READ);
>    *ptr = 2; // should segfault, but succeeds
> 
> Fixed by making tlb_flush() actually flush TLB pages. This finally
> agrees with the behaviour of boot3s64's tlb_flush().
> 
> Fixes: 4a18419f71cd ("mm/mprotect: use mmu_gather")
> Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
> Cc: stable@vger.kernel.org

A small comment below

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> Changes in v2:
> - Flush entire TLB if full mm is requested.
> - Link to v1: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20251027-vasi-mprotect-g3-v1-1-3c5187085f9a%40vasilevsky.ca&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C7b1beec4921c4c67c95108de216b416f%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638984941704616710%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=mJL3gS4YkTUAWmivSWL5AE9BlhAQ0R%2FI3eBwYwN26nA%3D&reserved=0
> ---
>   arch/powerpc/include/asm/book3s/32/tlbflush.h | 8 ++++++--
>   arch/powerpc/mm/book3s32/tlb.c                | 9 +++++++++
>   2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/32/tlbflush.h b/arch/powerpc/include/asm/book3s/32/tlbflush.h
> index e43534da5207aa3b0cb3c07b78e29b833c141f3f..b8c587ad2ea954f179246a57d6e86e45e91dcfdc 100644
> --- a/arch/powerpc/include/asm/book3s/32/tlbflush.h
> +++ b/arch/powerpc/include/asm/book3s/32/tlbflush.h
> @@ -11,6 +11,7 @@
>   void hash__flush_tlb_mm(struct mm_struct *mm);
>   void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
>   void hash__flush_range(struct mm_struct *mm, unsigned long start, unsigned long end);
> +void hash__flush_gather(struct mmu_gather *tlb);
>   
>   #ifdef CONFIG_SMP
>   void _tlbie(unsigned long address);
> @@ -28,9 +29,12 @@ void _tlbia(void);
>    */
>   static inline void tlb_flush(struct mmu_gather *tlb)
>   {
> -	/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
> -	if (!mmu_has_feature(MMU_FTR_HPTE_TABLE))
> +	if (mmu_has_feature(MMU_FTR_HPTE_TABLE)) {
> +		hash__flush_gather(tlb);
> +	} else {
> +		/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
>   		_tlbia();
> +	}

You should keep the comment on 603 outside the if/else and remove the 
braces, in line with 
https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces

>   }
>   
>   static inline void flush_range(struct mm_struct *mm, unsigned long start, unsigned long end)
> diff --git a/arch/powerpc/mm/book3s32/tlb.c b/arch/powerpc/mm/book3s32/tlb.c
> index 9ad6b56bfec96e989b96f027d075ad5812500854..e54a7b0112322e5818d80facd2e3c7722e6dd520 100644
> --- a/arch/powerpc/mm/book3s32/tlb.c
> +++ b/arch/powerpc/mm/book3s32/tlb.c
> @@ -105,3 +105,12 @@ void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
>   		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
>   }
>   EXPORT_SYMBOL(hash__flush_tlb_page);
> +
> +void hash__flush_gather(struct mmu_gather *tlb)
> +{
> +	if (tlb->fullmm || tlb->need_flush_all)
> +		hash__flush_tlb_mm(tlb->mm);
> +	else
> +		hash__flush_range(tlb->mm, tlb->start, tlb->end);
> +}
> +EXPORT_SYMBOL(hash__flush_gather);
> 
> ---
> base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
> change-id: 20251027-vasi-mprotect-g3-f8f5278d4140
> 
> Best regards,


