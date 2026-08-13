Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5470C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8EB6B045E; Thu, 13 Aug 2026 05:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0746B045F; Thu, 13 Aug 2026 05:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6E66B0460; Thu, 13 Aug 2026 05:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999416B045E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:46:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3720A405B8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:46:15 +0000 (UTC)
X-FDA: 85095765510.04.D4C62CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0E751C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:46:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DKnQd5xl;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786614373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+x2tiBGgnfXYaaYiZV+xganvGkJiR/qvbRK36a01nqA=;
	b=XzlZiyKMt1fczTq47Aku+UKA5d5rcmSY9iYNIArod5xE0cveNUob4B4zRxla0rC7Yn6Jhn
	96Jyda2StCgfHgeM9XXspVN7Q2Jm4lb2NDVCRrwWKohcOoOV3dd1ifgN1BFQGxsYoxoK5w
	MxFTXRzE+i05I3go5Ywz0IxHJTGIJ7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786614373;
	b=AovNu0yngils0T8PE1PCeZLsdH3EZdkJoYtte3jnlnPa8vcPMKliBRgc8RJfXbb/UJw/f4
	gJnvAy5ZwmRsNt638m967GuOt4gaDNVhCdv2Td84JSwPW/TseeNpIpgB8cQL2dRMQuc/P4
	spITbnsUbbL//n/os5kGr6aOs6K8Jfw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DKnQd5xl;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22C2E6011F;
	Thu, 13 Aug 2026 09:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D021F00A3A;
	Thu, 13 Aug 2026 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786614372;
	bh=+x2tiBGgnfXYaaYiZV+xganvGkJiR/qvbRK36a01nqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DKnQd5xlGQw8aHszKjwfbFCCC8y3Y7nwaZ0WSBdqVQgD7c4L39ViTScf20Tx2H0Tc
	 qSF5ay3tU4XMK8P3l9UG03o2FhYZZGlQK3EmSVggbqr6RVQV5wTpZQQSMBgqoVpnHY
	 /auQxWhMNLIDXnBsrBUjwNIgBOb0koxdy77mBXjQWwZRY+scOqG7bbIFoehCaqw8CT
	 +zLSgJUul/UYABxCySVnf8x2W0XiJA+JayL1r34pqVMZTLIOj6OKxlqkvUTqRv4LrR
	 /ZHKqBbBbam8hdsA/SdaE0v/ew0RIVcBt2IA+buPMpHBD4Opr6/oxZiQAcquf3MPAT
	 S178E9QyFkVAg==
Date: Thu, 13 Aug 2026 10:45:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Steffen Dirkwinkel <lists@steffen.cc>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com, x86@kernel.org
Subject: Re: [PATCH v2 5/5] x86/mm/pat: fix effective RW computation in
 lookup_address_in_pgd_attr()
Message-ID: <an2Q8Blco1diidCy@lucifer>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
 <20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 7fmasj96qyrg3sp3g3ean6xxdw9d6kuu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0E751C0006
X-HE-Tag: 1786614373-365506
X-HE-Meta: U2FsdGVkX1+6Wx5Lu3rfoO6MOOGfD7gFSICNr+wt0JiHAuGQLWQmQFudRo3L6gOAI0P5ZZ8i69gryIWSO5H8Lwrzo0bsVKU/6LVJhXjP/kyUCfuAQhYz1xWdp4uwKz3WhdSYE0+pNaUWaqA5yqDOZfSBqNI8Qy/5q5KidcBCOq+tJzx17mPt+uVye12UlmxxmaT2JS85eOW1eCUS/owoqqJI3CFSiF4E8kXeb7sYZyH3jaGSgGhb6wRcv5iqCvxQ/UDQ//VLNcIrznd+c8N7xM39iBV6j2efADRrCAJf3W7z4Mg1K1FSegeEb1CyrIiIpesCxQm7FhdHf7XUEW4frRnQF0uWxRzZqlDX4XditAqJOMzasgAimV2Gy3brUKgctffjxLVZ8LILFOPzuNMiO0IP/I3Ok34uMYAKWZTsCF2ZtaW3CUgfafOdopvikcZYKInIMeHTnuc4QkraN6eDgI0hDW50h940J+0nHrKA3njpf6KiN897+stboeIV15W5h9amvnQl8VBGfLSv9Maqq1MpBOSw3TCt2RK5/ojUmOeSIaFqyb4wkdbPh/dxQ9jsO5wPZTunJOL+w+hH77fQuna2zRIOpCCNAdqcGs74SgCpuD8UaP7ngAPcUvW/OH6E1JZVXJbj2EEQZ9oWQUh9g4hadmNw+DYB2ARDJ1Sti4XRDTfZCQtrLnANT5mr/97O1k5Qp+BK8RYlUBqZDI/xooK8qJXYHOQdnhbqxd5H+AV9ITlGR2k1A29ZvHMKWChkbg6jKYRjaeqfHG/0l/Nx4Z+AHwylsDKF8uFAdo0aS1UJnFWKlHHWZjByNP1HEhbq9NsU+U8gS/BIJVx2mMFlsDocD5F9BirNYg1nRvYTCLAWAZGsbNAHjf8qDg7z63SU27WmHuBv2ygXZBqN1OP7edYNjS8fwjzq6QP6MUAE0ODZKM+4jfR1x6nOEZ6HACa1OerCry6bbErwMPVXJ1G
 fy14iy2k
 rE0T5RrTDkpscv2xV0gBcvL9WJ7gGegtzDAmVAaGHWbT1lStiLcltvbSUqkq7Zi5vhH9TpyealFzhpuQ6IaRbQqMrhIlcGVTK8jTPn3tPzI4niMZM0mVkCnZB8tvmiUdTifgg/zO4hTyoRr8oKmjzk7ZbWiLZtlDU2j72Kv3TKa0uDQgdseFp4c5Q6PIiBa5kGa9RFAbUW3FNyiwbkgXtyJIKdaqOJNNAKSbLWTq5r3vhhvs7BMRQ96WQEbyJswyDayBFm6FOypAivcpEG/z22OIoEGR4+wUh188GAGW5jnrcKDzwHardxKG/Qx9Ckf4g+6HiijT+Fa9fP79xMBohjO/CetlZYcHcN1VJ1hfBlzERLneoCEDIYJnO0I9C20xl2qj55t2cmmsMoiv/H5rwh+zmegRtbsIf3w2xBMzo8knLDNgH2LLcqbdLolb43fGF891GePDWN3Cc7ycOxQVFBuurEJI3dSmPP5B+Kox5gP6N4F9DaSq26alY/GDi77G4qpgUbqxPZzj3RWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 12:01:28PM +0300, Mike Rapoport (Microsoft) wrote:
> lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
> the walked page table levels so that verify_rwx() can detect mappings that
> are both writable and executable.
>
> The RW bits are folded into a bool with
>
> 	rw &= pXd_flags(*pXd) & _PAGE_RW;
>
> but _PAGE_RW is 0x2. So consider the accumulation line:
>
>         rw &= pXd_flags(*pXd) & _PAGE_RW;
>
> where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:
>
>         rw = 0x1 & 0x2
>
> and rw always ends up 0.
>
> This way rw becomes false at the first level walked, regardless of the
> actual permissions, and verify_rwx() treats every mapping as non-writable
> and never reports a W^X violation.
>
> Add double negation to the right side to normalize the _PAGE_RW flag to
> 0 or 1.
>
> Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
> Cc: stable@vger.kernel.org
> Assisted-by: Copilot:claude-opus-4.8
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Yikes, good find! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/x86/mm/pat/set_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index fbc418dfc597..430d0b448371 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -754,7 +754,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
>
>  	*level = PG_LEVEL_512G;
>  	*nx |= pgd_flags(*pgd) & _PAGE_NX;
> -	*rw &= pgd_flags(*pgd) & _PAGE_RW;
> +	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
>
>  	p4d = p4d_offset(pgd, address);
>  	if (p4d_none(*p4d))
> @@ -765,7 +765,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
>
>  	*level = PG_LEVEL_1G;
>  	*nx |= p4d_flags(*p4d) & _PAGE_NX;
> -	*rw &= p4d_flags(*p4d) & _PAGE_RW;
> +	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
>
>  	pud = pud_offset(p4d, address);
>  	if (pud_none(*pud))
> @@ -776,7 +776,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
>
>  	*level = PG_LEVEL_2M;
>  	*nx |= pud_flags(*pud) & _PAGE_NX;
> -	*rw &= pud_flags(*pud) & _PAGE_RW;
> +	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
>
>  	pmd = pmd_offset(pud, address);
>  	if (pmd_none(*pmd))
> @@ -787,7 +787,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
>
>  	*level = PG_LEVEL_4K;
>  	*nx |= pmd_flags(*pmd) & _PAGE_NX;
> -	*rw &= pmd_flags(*pmd) & _PAGE_RW;
> +	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
>
>  	return pte_offset_kernel(pmd, address);
>  }
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

