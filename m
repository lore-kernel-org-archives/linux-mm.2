Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF3FC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 10:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA80C6B0089; Mon,  4 Aug 2025 06:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59036B008C; Mon,  4 Aug 2025 06:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47566B0092; Mon,  4 Aug 2025 06:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1A456B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:54:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E664AC12A9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:54:31 +0000 (UTC)
X-FDA: 83738766342.17.E20C7CD
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id E6E8C20006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:54:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=csvtxtrD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754304870; a=rsa-sha256;
	cv=none;
	b=QwVyRDR7Tst4s4AvjhxTXdcupFVxfl/zQseILwHReQU47vA883ZGUoryddm/vrU040zc9F
	Q3Tu4tvUHl8e6wT8fiHxBoX4a0X3ZeE6omL6jsANlG32mMwYkBTZNqLpktxFEs1BGVS0Wy
	RBYfwcfjM9FMHIX1kJLTZB2PeWO0chE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=csvtxtrD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754304870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4RxvHMamXD48DKrjLVxOGxx8Xo0bomZZqlvqy6+mMo=;
	b=qa1RHgsKkRPzdIn3SkBx91D4dmuai8mZEeZkSLz8k0RzrFQ89h0zaqFRVPSLydfSWDXR4L
	2/3/pN9D6yHxEtszHfgrJQL8aPDV5ca1QlB/HGr/k8U9OR/zSQ3VN3AHsxdlFdR2O+FJfV
	qv+i+FiJ2u76dYrleKgioNu2r65EvUQ=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-33211f7f06eso35695251fa.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 03:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754304868; x=1754909668; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X4RxvHMamXD48DKrjLVxOGxx8Xo0bomZZqlvqy6+mMo=;
        b=csvtxtrDmm5NufrEfr28qZH1Dwq4XnJuuth8fJ2bLx/oXcyv2KT1Ciwdp+ATk80PW0
         9xWYaa73NlptqyfxH5/x6VhlltKPdKk2ndw8FubMt6rt4LW7nVY2D6DYZE2v1r99LAYT
         9iMDc8PlQ6NBcNsg1WVlStHLO62bKdWMK785tq2GYKZ2rYTZMSnFDQq3hv9UrgvkpWE2
         KSPFbM7KSZTl6TGhvHPMq71uaRqsoWs9V/ghd6XGLi9K08/VSIgj5yy0ZVoxctCpUMe+
         wEjIETszpJrIwLtwyV8taxSnmcHckrEM29aidMbW7KJ7J4KV5G4UF0S8CAoBU62xkPKe
         SnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754304868; x=1754909668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4RxvHMamXD48DKrjLVxOGxx8Xo0bomZZqlvqy6+mMo=;
        b=W6VxGaxbXuEBP043KuO3TJasiBxlY/1e6uPygW4TaBngs0TsCVlhG1H2K+S+nibB1s
         nMWxihdjsMNNEjvPMc/G9Phyks5Ve7a/rK7apQz8DFYMUha4JR4d4H3VeQn9aa6DjHLZ
         21RbVAfFVuXhijLCMfeKh1oEXv2Mtg07Sis2/4usY0DaV/8mIadNIPYxnuP6nCdyPufW
         97lxfgl1xPQc6kho7knsu6y0G4j+V3ejpoKGEFqrA06TWxadO+c7DsmlgrysgMt2Vb8s
         /1V3SXhWGTN092ADQtOmXGMLvk1Ejm6KwjGu3irTl3+Ondp4evdzyVm4AFSfth3AMWVg
         P3iA==
X-Forwarded-Encrypted: i=1; AJvYcCViKt+Wc/6f0t6dvHowiVd/adNfRr1FSS8jdGSfBNiom5ludWg0qfGdH8JxAFZS4DxkOI54opxGkA==@kvack.org
X-Gm-Message-State: AOJu0YyXz4oh+P4rdbq3SxV8rrI+liDjGHUayRIPh3cJzZShBqi/UwDm
	E6yEg38YTovTqY4kG9Bv7mQ8nAGw93VYeUWBCz/hfVT5jbkgvtMwPUuM
X-Gm-Gg: ASbGnctX4r0xQtn1NvnLBPJ1Ht2B7WmKEoiUFTpSy/umlg0Cn7OgMnrO2GILK0JTE24
	jrba7rg8ZTsek/i1AMG+ARvXcFdmqB+jgFKutbuwFrVenkKyHim5PGNlntH931DQHUqGCyNDdGx
	UZHavN2u/sNC73ZNA6WwTW5R3/O58dmZ5h3uJimmdMVPhYK7mE/SyngKpI5ibb3+Dldt1ecA2tZ
	MEbwTmkq/KAQ8k5qLJ0XHBtQUgbpq5mBVIz3q2M09BaRPOLMY3H8MSYETdtJbB/1OySWHk9Bo1j
	WnvRP4zqKNIvU98Dz6+ee4/lkRn6qVmFbDJKJeLTYqB4Gz3QfgPl4dxnEjc3sSxFdHCwG8h3YPp
	zzonE6Cj1Tvn5movf+ISwmNd9UdPhylRA7Z0mpU4dyzokf3J4o4bE33PolvYB
X-Google-Smtp-Source: AGHT+IGJZZFcFy8qBb/9BVJvSpxogtzfM17wxVB5B1bfSxKSrolhCiqzChAu468YcmIMkpSbHFvpbA==
X-Received: by 2002:a05:651c:20ce:20b0:332:4a77:ad9f with SMTP id 38308e7fff4ca-3325677af91mr12521651fa.24.1754304867614;
        Mon, 04 Aug 2025 03:54:27 -0700 (PDT)
Received: from pc636 (host-95-203-22-207.mobileonline.telia.com. [95.203.22.207])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-33238271bdfsm16396311fa.6.2025.08.04.03.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 03:54:26 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 4 Aug 2025 12:54:21 +0200
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Harry Yoo <harry.yoo@oracle.com>,
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
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <aJCRXVP-ZFEPtl1Y@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
X-Stat-Signature: j6h43cqknj451grfa8m5rtgcace88tsu
X-Rspam-User: 
X-Rspamd-Queue-Id: E6E8C20006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754304869-232787
X-HE-Meta: U2FsdGVkX19KxXMTvvZryTGbxV5BqlGVu2SoFjTY8tO5MD1QUxZtXSOMM9XVmZmAn51anxpAyePgSfFaj2bxpk7+9bNNbxg6Xh3eQConpPgVcsg2BVsF09Fn8LqtzZfO+cUms0awwXrcUw5J3vBztlaTN26RRLI1PT1+Rn5JF7Z6ZY3cMrx408sl6DDKdZhy5N6qEslvJc+3S9XysmoJ6UVhiEbw3FFicNGgzd9XODeiM1llWQBMWpEkHpX9dEgoeH6yMAE4+qAf5TtQhpaqvU6JFZcH51AgOV3Xcs6tSJledrfBeDhpspeOV+9P0OGG9nUgJckKq1zI8v+MDhYwpKN8a4uCZMQVHqaotgpaf3M6IjiUNhbv4ymgrYrpe/ctcQk75zlm3N3MqtMHBh1NfZo0k9duYEyYo/PJGeD4EO92B7ClvU6SThwZGzoQmXERLCyEgL2W0q0nzskSi3DDXfSayAcPFuWxvMgumRZ07VTbzdK4dlvtThl832y+nBNcDqQTGOvEXkKtGx+RYfaxImxqlGUWcSolMDFdyfolIFC8rhW6XOCW32E8qvwxlOe22CMpGr7m2gPHI8XxMnExuvRAMUEhTs83DQf9w8dagN6TTsXJ10LNOw+qAArKeDXd8FK7vldK+ZHGeQQ1eR+UVtx4V8HDcTVxZAsjtXoC++8PzaQCh8GA7bS88mb9vN/oT/ezqgeuf88c52ADtXBBIfr+XKQ1JnwUd6faK/QLvYq7PpMEuDSVgDxnPFEQ3m53RD4iOewNA+/NEOziY26O9cBRmcswCQeiK/kJd8qJsp4scMwz7LKInh7lUSpp/AWnAhRWVBYDEuGVOVJ7Tn/XfB0A8T1nKh/nHVBQHcuGP1DrZrolzsJFc9c1us23t4Vch/TwxzbJjYBdRKcG3Ms/qWSdVbhCj3haaMJNEnTVpQNdBXU0yaHLZRlY4/mQpQqUedN2SlUY+3MCGbL9oL/
 7pkxVWdV
 UU+cPxwuBoC7BvInKAY2w3BQwIWxNNwiwe0mTNMI8JcqjSlANYcCs/RoqQbD75AdrRFXNW7PL5wwHx58Cjg980OtKKL+1tXyoa30rwSsx5iaWQ2fzmJZErGaUZpPeGyOHYVo94uySei/hvgG6sC8Cu5FE5jof5GylkaFnkX8WAr61KZS7sLKy4yFy33W4GigQ2ygEYC8Ev7K8+PGts2R3+Nt9u4zrhk0ltv4TxQImUK/lG0qkYgUtbwsDvgQaGS9SVKSosB0tFzx/QOJwEic+VDdjgNjsBb/1xRBljXBGqQqX2upCZV7Dhl/Aq3zm/kTDQSNOe++NT53sZmSlFEg2m9i5ke66WBIOtjtkFzDDgHQfKqOIRH3G6dwpfXrKHgNXTLsiWsKjOE4wdimk0I2UBB4Vhmtj/evz0NJDbAD0hU7eOW58Oqno6B5GVYeA/zjl4PNGr6lemAe/G403tIkkDtBz1IHYO5Prlygj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Lorenzo!

> So sorry Ulad, I meant to get back to you on this sooner!
> 
> On Tue, Jul 29, 2025 at 08:39:01PM +0200, Uladzislau Rezki wrote:
> > On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> > > Andrew - FYI there's nothing to worry about here, the type remains
> > > precisely the same, and I'll send a patch to fix this trivial issue so when
> > > later this type changes vmalloc will be uaffected.
> > >
> > > On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > > > [Adding Uladzislau to Cc]
> > >
> > > Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> > > same name and (currently) type as vma->vm_flags and is already the source
> > > of confusion.
> > >
> > You mean all "vm_flags" variable names? "vm_struct" has flags as a
> > member. So you want:
> >
> > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
> > 3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
> > 3875:                   pgprot_t prot, unsigned long vm_flags, int node,
> > 3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
> > 3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
> > 3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
> > 4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
> > 172:                    pgprot_t prot, unsigned long vm_flags, int node,
> > urezki@pc638:~/data/backup/coding/linux-not-broken.git$
> >
> > to rename all those "vm_flags" to something, for example, like "flags"?
> 
> Yeah, sorry I know it's a churny pain, but I think it's such a silly source
> of confusion _in general_, not only this series where I made a mistake (of
> course entirely my fault but certainly more understandable given the
> naming), but in the past I've certainly sat there thinking 'hmmm wait' :)
> 
> Really I think we should rename 'vm_struct' too, but if that causes _too
> much_ churn fair enough.
> 
> I think even though it's long-winded, 'vmalloc_flags' would be good, both
> in fields and local params as it makes things very very clear.
>
> 
> Equally 'vm_struct' -> 'vmalloc_struct' would be a good change.
> 
Uh.. This could be a pain :) I will have a look and see what we can do.

Thanks!

--
Uladzislau Rezki

