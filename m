Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2694FC87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958816B007B; Tue, 29 Jul 2025 14:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908DE6B0088; Tue, 29 Jul 2025 14:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1576B0089; Tue, 29 Jul 2025 14:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 690326B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:39:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B49F956E57
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:39:10 +0000 (UTC)
X-FDA: 83718164460.17.B7D8E95
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94AA81C000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:39:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MeoDf6pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753814348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYRfCV3hbQi5DsgzlDild2w/1OeWF4e+oM87WSvfwwM=;
	b=kZM+VBtCl3SN/TxGJ5O8CAEmlzIlKzUL92umL0Y+WX1a1/h3UDHmT8gq2owll8m/DYoMGd
	zm02U6J4gHvbIIe7Va30OVJP/Gq0BLcj3SS+4Fg+Qh80Qy53f3ilY235U+K+sk9llIrN+o
	ySpsi4n4j8NstttihKluJM8WWsP0rUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753814348; a=rsa-sha256;
	cv=none;
	b=abkkzhVHrdXNAR+eYc/kfgJEkNyChprT/8S05M1ctAlV2aoobfLwi4QCFP8htkEDkDiDKk
	jor71FES9guY+d8WC8EqSb1PmmmNHqula+Ex7y2vZYj/0dV6RnkEH1ATXjY9uZiausBHxp
	vIJLHWtHoHkmmTS7IKYQr4SwGWdzsXQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MeoDf6pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-33212cf558fso14800031fa.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753814347; x=1754419147; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYRfCV3hbQi5DsgzlDild2w/1OeWF4e+oM87WSvfwwM=;
        b=MeoDf6pW2iCe4dkpnj8F5g3bwTUoPUwNx21qcCHT+vTDHxeNnGy9HWtO5/xBkZRCgR
         z8VeEcf8+MelW207nDcqjiIJhLNTgd30xL+XJGoJqPTSx3N2YTpFatH9f7wucoHA+K4+
         bUc/8jSh7r7pjnvyO0ed8M3jmmSho/oojAyD4nxFmvrYhXD+DE5Qndceo9C3ou/I/wtw
         9tVPcmKFCTcDe8AuujRlrti6CROqX9G9YvSM4P4m4Flml7ol8dYTQSzF3a8mVzYXljTA
         cRdaR8rz0z3KC2LyQlghwkl0v0rfDHUlqa54FQUAxO6S/F+KLEmMHc7oO+M5D/VeOdu8
         xOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753814347; x=1754419147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYRfCV3hbQi5DsgzlDild2w/1OeWF4e+oM87WSvfwwM=;
        b=GsUu+rD3Bfx+GHq1IglBfKLkEt5OmMkYICXFkKWfZU16Aieidgb57b5YNoRdw13F7o
         v5yrRGqF8cOc0kzC1lQe1l+PJuD9jqPk6PlduzPBLDFnR/EddlGrwy1v+2gGhRcnHAPC
         /5iSDsl/TC9OmgXzBYdGnh12iGW4EPj5y9bj/XETbXvtPsH2U285TqleWk72og96rOEg
         SyFl0vRN0+KkErc+XJ3KEnprdxUUOsityLB19LW0vuxXQehRpLPqXABPiQhhi2LyiKis
         BltTqXDSyFZZ2Bn8RcFaK79QdXM7HavhcFvTdj6Nls6HWh/1YkQ+EwcGSm6a0Z4sRUeR
         1M+g==
X-Forwarded-Encrypted: i=1; AJvYcCWNsh3lSQ53rMBMBEjcJI5wKSAesFTy6c95h5+XgMBonojWiONGjCVoEzKCv3Nd0KzUg4IuoRWSlg==@kvack.org
X-Gm-Message-State: AOJu0Yx0q4LUSK9RJaikUC4W3xo+FoeaEGcfQISWpKKGFk0RcUqkpuue
	GEmH4vqYctngWMxqvqHW1CKRVtCYJzUFmKSD1WyVnvniH6yqNLGn/Xvu
X-Gm-Gg: ASbGncuqLgouky/5GLHsPq+1USaQE94uwAz2N2t/PWBfXu4QKUX1YOW9Dw2RV3dDUiv
	m2jjqFTJ3SXCM4s6TEFjZG0SqhjNHL9jrKywkno77oZATrWZVLzYlf1xyq6hRlVt5DRAP896nVu
	aY9s6dZYgbqPTIldd0VMt2Uuip8pQxyBUkY67L7TBXQVcV2NylAX/pVuW2GBYTefGokf0Y4ne51
	qpo3gCW6CypL/L5BRvH+pddgboupLt09IB/RRTV52OY6WTwVzYOdVzT3h7A7Qo3moqPOsOkUCOe
	bC4CRlDXqIJ0ZnkUblKICtsOekjuTi7lRwe8qHN02xD0cVT2qSrowSLA0FQXw1kN
X-Google-Smtp-Source: AGHT+IF9yvJyPiTzwXfrNX8PT/G9myfdCCK3lbY+TklU3bxii0UFYjkiLDeONxAItTuHZBzIFqK+RA==
X-Received: by 2002:a05:6512:3414:b0:553:241d:4e77 with SMTP id 2adb3069b0e04-55b7c011afdmr184040e87.22.1753814346295;
        Tue, 29 Jul 2025 11:39:06 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-332219ce7aesm832441fa.34.2025.07.29.11.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 11:39:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 29 Jul 2025 20:39:01 +0200
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <aIkVRTouPqhcxOes@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
X-Rspamd-Queue-Id: 94AA81C000C
X-Stat-Signature: rn6uydrgejd5bgjbfr5w59zd7nc9yx71
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753814348-112272
X-HE-Meta: U2FsdGVkX182awwjRaE73xxT6UPkEw6b98L7hfVMdQg3iXNedw/JhHqwqAS7fB7g6rDkjdQ00sKiD5QpzYhdqdmQV/zvCKBknlUB1sPRQ5YgDIYDOjt0FYeEWydbmP7NVwukeKYd2C5VfKVwpLaUpa32tR1VMX2WYj7EpYHE9gzP+NCMaoiiB69eqVZE2ozkQu/GtFhjugE9y9uzd2PWuBQzZcTXWw4ZSiIXSEwbddflq7bZbTu//cLyXRxoTbSeBt8cFn74ZvdxB+E4B4vzHmha/1gXjmUe1YLjuHDFzVjH4+x3ZAWMrldfnI6944mf/IrPOCcWuAWEoOoLk+6F1aFqmF9SYgHGkESrhHSKLo4JM1qX1xTSww2aCjf0ksJsnYr93fZn0mYmuMNmqqZFn8BpeMhrNCncXfgnmv7DWVDnhI5cc/Pg1q5ODMRXQXALmzaMem6TUGIoxePGmfyG+gLXczyKOJAEo5sZCGjErXY7m9FSC9Gv35Rw9QcPgE3vZ8E07fHYUi4XHsBBCSIl3N52pVbDV7oNnRsAUMQtWFiCF0kfZRfE/OjfHS6YoBvGOlhwWmmAHXTSc2FveYbWNqic2dr4GK44Ye5mDTIM1g//QXOJnKFGRMGLCBe9WrVBUprPFs4VUkj33AEc3H81LFhh8ZYAODCLY8liXrTWkBtNHLnfXquV81Eb6cvOrdIRec3wzlk4wdvsZ6Z53BPrUaMk6PUHgasa9E9RGHLahURK4BD9O9NLFQOkGJmN2Aksmr+h+dkm38JGHBFaJ3RooyvFa4F7XAmKzVCzihXX8k6zLj+MXt5RtWsuesAibAoumBwZbgN7DPrZiQd5SvYOW2Vx9e5kBL8qVcTEd60FM4d5trWx6OQ5vdXzAq8rmFzjhxshFGz8g47fpw0G/cuD/hhUm+R7KJrIl8O2MmXI1iUa/IEdweF3aFmm8/m+WW0Ax7T39PhbKmoO+48VPBz
 bm6TLLO4
 cK7AgR616LDdxRh782B7zTeRGxO9faukyFTvVLpS0MI+HcQZ1v7dQlhEY3S05pWD5iNeDyPUuS8610ZfiFgB0xPOLkj6NKd+UAEKTgCLfQgI5QXNZgw5lMdXeF9MIUbVo2u1yWZbn3y/sK4X6UDHIXZCCVNRgWUKckCzfsIqa+J5zEmQXtMsG/wnq83NhucEB/NVvEh1YNer+H88ZkqPEdykz11Dz+SNnPX4DmkIvR0Mheay2PDVO8Bz531PInPYoc00Y7S2B4mGBaCAz/RycHB7x3Y3iq92DnQeOwKOtb4QRUDMXUeI664L0gpmx1SnwOpVjnmrglSjNYLxKN+MKkcBxbHfZvs5A7XfbcsOIV38lHtdyggXJOMq58SEsbZh9si8lXtX5b1oF8qQS4lsCgsS2vp6J75J5tNU2nURY2yAOMCjdVM/9LCnN82RIXAIRPSJhrew2j/uVXKfv2aj2z64FovHCV53dM/kPJ3qKKwbGGadyzicdldjDqO1tw/VbvYQTESWXnsjj5nrhySau6uCju7Kt+OzhzCrTOrdeQrL16BZbYga6X86vCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> Andrew - FYI there's nothing to worry about here, the type remains
> precisely the same, and I'll send a patch to fix this trivial issue so when
> later this type changes vmalloc will be uaffected.
> 
> On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > [Adding Uladzislau to Cc]
> 
> Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> same name and (currently) type as vma->vm_flags and is already the source
> of confusion.
> 
You mean all "vm_flags" variable names? "vm_struct" has flags as a
member. So you want:

urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
29:                          pgprot_t pgprot, unsigned long vm_flags)
39:             vm_flags |= VM_DEFER_KMEMLEAK;
41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
45:                              pgprot, vm_flags, NUMA_NO_NODE,
51:                                      pgprot, vm_flags, NUMA_NO_NODE,
85:                          pgprot_t pgprot, unsigned long vm_flags)
259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
3875:                   pgprot_t prot, unsigned long vm_flags, int node,
3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
29:                          pgprot_t pgprot, unsigned long vm_flags)
39:             vm_flags |= VM_DEFER_KMEMLEAK;
41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
45:                              pgprot, vm_flags, NUMA_NO_NODE,
51:                                      pgprot, vm_flags, NUMA_NO_NODE,
85:                          pgprot_t pgprot, unsigned long vm_flags)
259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
172:                    pgprot_t prot, unsigned long vm_flags, int node,
urezki@pc638:~/data/backup/coding/linux-not-broken.git$

to rename all those "vm_flags" to something, for example, like "flags"?

Thanks!

--
Uladzislau Rezki

