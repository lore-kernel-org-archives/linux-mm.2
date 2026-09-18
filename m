Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E69C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1A46B00A0; Fri, 18 Sep 2026 03:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C96B6B00A1; Fri, 18 Sep 2026 03:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406996B00A2; Fri, 18 Sep 2026 03:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0146B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:07:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A681B405E8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:06:59 +0000 (UTC)
X-FDA: 85226000958.09.953EA6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D0B480007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:06:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPezEhSF;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715218;
	b=YwDaUYtmSUUhEkwWfMXIhdRvz+cr2Fndh4z5qqsIxV/sYE1Fw21tLu6wy8VmaBd0TNsEd6
	XT7Mqs40ge5BwFc3x3VzFaWQ8Y3rhuW4LxS8W8RJMxc2muQDR6MCUMzvKoXuTy+9Y51tBF
	l91NhmI3aBX7GUBmMshw5YU/LLyLafM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPezEhSF;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYTKS6LtEqOXedQDCZMgSMsK8BAtRN8tnXK08Vs7mUg=;
	b=HlDfWIO8wbjDapkqiwRYA3C9Lsc2y0IGALl3qQL1cEeV3gZPyl8zWqylq+Wper7Ujl1gtP
	Rlw22n362LvBNxXtbRwCRATPEY7nM3swoQqMKhmuIlwyRBwr0rJVNyiCCn6GNpZJwGZKOt
	Sn2mzKGpa7foCJE0z0ER/ojOF/DOvdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FB78402DB;
	Fri, 18 Sep 2026 07:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5821F000FF;
	Fri, 18 Sep 2026 07:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715217;
	bh=CYTKS6LtEqOXedQDCZMgSMsK8BAtRN8tnXK08Vs7mUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QPezEhSFz1oJEKdWrJysPdVqTui36u9odN7Ok89a/CQ+JbBtuDOXa15EERg8ZHwM6
	 ZTt4ZDn1nuVULyCuBvwHgV2346nH5Q31xiBVxqTWKRcU7H6+vPVnG+MBoStEXxZlH1
	 Xap4i3X/5T8j7QsiIHsnc7bbLDJvtAEI0m4rAYlMU5rHISYDO7bukISllG5+xtwJNz
	 kM7l/Kjb5SAW/Fihbkforg6oxz5cfiOZ4ZYWcuKqsxjhJpAKsTlv7VRjoreQWFvDxr
	 TGrZ/lQF71IY8+LNwMLWkMQDSnXz5F5cqxBokgTzQ5HZlmjxvRF1P5+OBsVW9rmiXP
	 MqnIc0HIdvADA==
Date: Fri, 18 Sep 2026 10:06:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
Message-ID: <aqzjBA_101LcKRCD@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
 <d299f7c5-6c71-499a-b8cd-aa69c4c81dd1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d299f7c5-6c71-499a-b8cd-aa69c4c81dd1@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D0B480007
X-Stat-Signature: mfu7hgrbomi39nzo1hhg6tqmhukotdt3
X-Rspam-User: 
X-HE-Tag: 1789715217-255376
X-HE-Meta: U2FsdGVkX1+VnYLosBsH2bHmPmYCIpvunLT105HLE+Wtw8bdTfYUw7yziprJxHUc7vy6lpzBWgVTCm2HtwU2DN0g6CknW5GKDbZv7w7MTLllJUImbPkNR1lh/jlOBnCePHWWg6Kup46p4NQO0jxUCjbi0D5RHEwcm6b+xQM0c3S3zgNIhxhyhrub9QELe8s3BqpuMYW86W36+svSlzUyesrMXt1Myy6hxAE802Z9+9yujpdXHZjJ4nd+ChUle+G9tEOm5T11ETgnNNEBkEQP0SBVLhOhdrTFVs0Cr9sL08BP2SaGV6DkKwfk747OATy3f9BmJyk0oqOtgmCKMY7hd1yAaIR24d2f0kDm8O0JsDcS8tAN1IvyQXAQmRxuVKz7VoRwDJFqjGDSMo+O9pF1btBxq0UXG+wkxz306fz/qEKqaiJDnEDz+K9cXD6cYAIo/Th6gcyO/DmeHWhf0elrXB7jBBr02E8ili18Xrip+UnjTTkDj+EvFDH5DFtD/39REVoMbseremQx0AsigYtHEkNapN61L7rHpGcCKGohgfide/Ng5Vsunyi0wmTlVZV6vBt8n26F36cq+DH3TRv7nseKMjJEfDBukgvdjjJDVYSXKz5fIEkOBmfHLUrszw+hY8k5bZTJkfg97E6lFclAP57JOxCgHBIhQ+p/DeR13h28PqTTQTe+bAROm6abL3TxzoNAoOLzoMnxA2jsAV3guqv/iC2f48dq/uBb1dB01cX8tqHbUFEyNbJYK0okSvHYxjufl0L3MKwwArTUAMHYncEo17pRQi6Q2gyxxFFi1y+OSo/AP8DLJipa6TZmlGc2IdvJ+vsXtSfWCsQ2/d6xAo3EDj4u5k3jxl3Oj1Jm/KN95gbPsqRCYY1BcEoZrLQo8y4seIWGcMzpRhU/jdUlZnkhsMWneaFKipBkyRxFZ7Zv97rxQ5msFQdhJfxB15mZzYIybcxajtAvRWYEs1b
 Ohh1Ol5Z
 6WlYswhSO4vtmHGotWCjL2PllSrhJCpt8i36PMY0fDYfp60m6i4bMlFZLpV4GUl/6XR2Vnx8x7TBb3tTA6XSUYLfupGAoW1MLOxs/x5CyU/tKY4wJ2E25Re5wnoGhMzj7YdGr9+0cJEYT0uaC9aLPItHCSEsT1xW+FaLoA2/5Qy3ZQD+OnvELyxLZ0ZzyoQypyBaNdSPTcyOHvSDXOOz+6v/Y7CeH+b1g+KiWI5t70NToTIyrtVj3Wm6mhixARRTvR+ZvUwig/AnRKte9g5ZbTrmhZueYKMLXInYSl7elF58hWUp4zUctnJ0lzjwX8y8VDIExzKRFvqHrU9Wz+ssY47e3F3VbnQ2iQv7SAIsRYdVQY+yC2shDi+Sdu2OdQKPHNw9vg4xRO01Yq8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:11:22PM +0200, Kevin Brodsky wrote:
> On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> > When set_direct_map APIs were introduced by the commit d253ca0c3865
> > ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> > parameter made sense because the initial callers (vmalloc and
> > hibernation) had sets of unsorted struct pages that required changes of
> > their mappings in the direct map.
> >
> > Since there is an increasing demand for direct map manipulation and it
> > is also desirable to be able to update larger physically contiguous
> > mappings, for example an entire large folio, extend set_direct_map APIs
> > to receive number of pages parameter.
> >
> > As there is still only a handful of callers, change the existing
> > functions directly and update all the call sites rather than adding
> > wrappers for single page case.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/arm64/include/asm/set_memory.h     | 4 ++--
> >  arch/arm64/mm/pageattr.c                | 8 ++++----
> >  arch/loongarch/include/asm/set_memory.h | 4 ++--
> >  arch/loongarch/mm/pageattr.c            | 8 ++++----
> >  arch/riscv/include/asm/set_memory.h     | 4 ++--
> >  arch/riscv/mm/pageattr.c                | 8 ++++----
> >  arch/s390/include/asm/set_memory.h      | 4 ++--
> >  arch/s390/mm/pageattr.c                 | 8 ++++----
> >  arch/x86/include/asm/set_memory.h       | 4 ++--
> >  arch/x86/mm/pat/set_memory.c            | 8 ++++----
> >  include/linux/set_memory.h              | 6 ++++--
> >  kernel/power/snapshot.c                 | 4 ++--
> >  mm/secretmem.c                          | 6 +++---
> >  mm/vmalloc.c                            | 5 +++--
> >  14 files changed, 42 insertions(+), 39 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> > index 90f61b17275e1..b07fd4e026eac 100644
> > --- a/arch/arm64/include/asm/set_memory.h
> > +++ b/arch/arm64/include/asm/set_memory.h
> > @@ -11,8 +11,8 @@ bool can_set_direct_map(void);
> >  
> >  int set_memory_valid(unsigned long addr, int numpages, int enable);
> >  
> > -int set_direct_map_invalid_noflush(struct page *page);
> > -int set_direct_map_default_noflush(struct page *page);
> > +int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
> > +int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
> 
> I don't have a strong opinion on whether to call the argument nr or
> numpages, but we might as well be consistent across archs :)

Well, it's either consistent across archs or consistent within each arch :)
Or add a churny patch that renames it everywhere to nr_pages :)
 
> Aside from that:
> 
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

Thanks!

-- 
Sincerely yours,
Mike.

