Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07BDC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554666B00A6; Tue,  5 Aug 2025 12:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C0A6B00A7; Tue,  5 Aug 2025 12:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441EA6B00A8; Tue,  5 Aug 2025 12:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3483E6B00A6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:14:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCDFB1D3B03
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:14:05 +0000 (UTC)
X-FDA: 83743200450.19.43B6E75
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB73A18000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:14:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NIew5jZf;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ut5lsjSSswYnbLzk6rrdmu5+CeAKFhijQRi1rB1wfMg=;
	b=2o72vhbJwKbkLbs2SNobswU1gHOwOEKwmRUDVeHo+3dUMJ/KIWhe5cSQDhlPmA2fUmbFFV
	6sf8cDd+z+3lTinLK008nZDkm30AyVcUPHS5+U/nyJAmMkc7VdQ9KVOF5BZus8YRbKctIw
	kgUTrfJwbSWvnv/2tThK/tCl2X0Lsbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410443; a=rsa-sha256;
	cv=none;
	b=ZBbpasblqEAPSUdBDoYw5szPNZ6cr+oASchj5KrmqLpUdqPoJl3xhR2p5Kkqm6Pao9XGMI
	rvGfAHXr6KGbo3d0QbpysjR0z4qRlI4aR6yAp1WLOYbov8R1itHp64bMjOFZOUjxFynzgH
	NVFGFKBBnEnmOTEidPxgF1ziP412QL0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NIew5jZf;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-332631e47afso714461fa.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410442; x=1755015242; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ut5lsjSSswYnbLzk6rrdmu5+CeAKFhijQRi1rB1wfMg=;
        b=NIew5jZfYZ/PHfRtkSNZj1cRNycxGyXqHIo1DkzU3RmXoX+sRuHSpKA1D1cEljNqi2
         5n/DB7ngMNazOo4/XaOVZ7k2fg/bWYMkK0JPen/AjSdqV5omG5Fk360qe8LWpRn58lME
         58xczwtjzrn4OJbARlpSG6srl26mbVP7DsIwbaNnbgtyLXxrorNVjR3B74cMqhr9lUyN
         Pi6K7m4vrCoElzmUcdWXY4V/H6E509gZO4zSlRE1LwY7jR3I7wSWolwHoefX4vUiiu/q
         ir3JF/MYrP5HLgC3R8qLVBMVTL1ZIEIv5/E6hfeZuSmyKTUmn5cMfom6R7rFW/2GwDuN
         GwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410442; x=1755015242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ut5lsjSSswYnbLzk6rrdmu5+CeAKFhijQRi1rB1wfMg=;
        b=eCVWyHo6uuIPIokhjUEkX/9NWANO2NWmMX9lGfat+aKcdRG+P9B6XUxFMexviIDMbA
         wEP9YtoZ/RPxvAad7HxIDcdQS6pR/SDpdTbOMfPw43bMFLCLkRrrC2jlFPXDcqVaR35l
         +1MsHH30OqSwQI0k588b1cPqGy9nCUvt+GKPipAfkNmhoTvtjmD286cBXQFxSawopvwK
         lj089FO8t1K0+zD6DHirX9erQddb6dGbyBYrCwzTrUNypDZ0j1EbDaeKnzzzSjIc47s+
         KsCU1DmG3E08uHJ3CZHXMrqDFkjIduOs83xC6J6DaksjiUQX2/+gTTqICAdVEuTC7OQd
         WKeA==
X-Forwarded-Encrypted: i=1; AJvYcCVRxFRSqvk5CggnOuWAN+bf1acpXqd5Jd4vcASCa4MuKrHq0d7jUD7G9ETs6yo/rWQrVWQq+XiLXA==@kvack.org
X-Gm-Message-State: AOJu0YzXM6dWkYlYSzlMRGgpwEZ7C4imwcmfZ0enFrtSXBU8A0D8lKo8
	hJ0eW8xVT+dlcrVhsjomZ6avytEiymJBysF5GIPZaCLw/+MyMMwS1+dc
X-Gm-Gg: ASbGncuROJjpH6j0cuSkcwnXaTUrEJxiUuiNJjRGqsvvQLhl/uQljreNjEWLUdAtsDJ
	jtXgFV6S3R+Eb8Vr/9AJv6r/VtF98ubpiZZqdC3J2Blzd5gs3qRkHoujtcJleAijNA28GlLsMsF
	4ntSoUTM8oHu0zb9PQMCBQYnBYJO17hWa1nH4XNUw7xFHYaBmFhzTopikquDrZGKHAymFk4FVXh
	f8O508hMBlLQX0caUSbpv1ILDgJJEylfSW3O6DdaTBWz3RXHCB5Oud6Uwzk3Z530u4gquuIPqtX
	t/bHxDQtCpXVTi5Px2ma7F9JkArEhhW8RSDL5DyntH9Gu3lN6OhH3/e8UhJ6JHgtCKk6lBCeN4v
	rwOMvvYi5t1UgUhSJIzuseAq5vsiGy5LFp+BQ/z3Qkk9xwRescQ==
X-Google-Smtp-Source: AGHT+IH0xPAx9h/e+86wx2UChAIDs8RS46jNjVMEpxxiiDlgZAALsSVVnEbgPp+pN/RR7dfa5MNCmA==
X-Received: by 2002:a05:651c:b0f:b0:332:341d:9531 with SMTP id 38308e7fff4ca-3327b9157d5mr10915411fa.12.1754410441379;
        Tue, 05 Aug 2025 09:14:01 -0700 (PDT)
Received: from pc636 (host-95-203-18-142.mobileonline.telia.com. [95.203.18.142])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-33238272ff7sm20616811fa.7.2025.08.05.09.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:14:00 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 5 Aug 2025 18:13:56 +0200
To: Mike Rapoport <rppt@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
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
Message-ID: <aJItxJNfn8B2JBbn@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
 <aJHQ9XCLtibFjt93@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJHQ9XCLtibFjt93@kernel.org>
X-Rspamd-Queue-Id: BB73A18000C
X-Stat-Signature: dwoznanzed6psrh9nbmn3yp4dw5xk8gq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754410443-112043
X-HE-Meta: U2FsdGVkX18eoiaDoVLlAqExR2CEvQmAn4+E748RGnx1WZ6NiJV6Nt4RK84rbysyVqSFytICEvN7nzEKcuL41jHVuZ3uWp8xdyVXifqHw5TLmIfv9ftdOAGV/esxNSrWJWVQFHdGVa9sFrKJpbDqx3djzNlh+GN2lPm/AmMgDwyFaVst0muAJnF7ZJsGMW86qYg56+yotmWhkU42acewTwloeve1ecLeG6V3N0Fl2czziBffQ7rn8gaD+6Y1vlOhFv+uID8OCr3aRlkFZmy1O1QqVyA6T38xUC1orSusxrAg+I4WN2DuXvsxlufUNxwcYQUZeU8Wo8wAXP3iw7VrP1HXS95EMPVIPV0imrmFrN5tEGrJtIpAKTLix0mfUPJ+YJothyy6CPUUQ1b61SVHPNKxDg0H6SU49uC1o7GZlaVxJRFNfX6ZNTf/SG9m7/UuksWNvQabSabcRbiubJoMcUKf7XbBRAaV01gCqSYyvV6+eJ1V0wwpzRPlpu+HBux56AONAnhW4/nOvOQfLLPLLuk3psVaL8jYztAmBektpZqQlwLhxN5hJCbVSF+GCilmTqYdtYAfeNNckiZIlNjz1M+Y+IfAUAAFVRZyKrr1NFwPsTIVBoE0n1hfhx9fJo1sQ7yQSrONAbfhMtCTVUiQm7M1lLfLHZ9kXvefLlI3ROz0ylAAjFmlpjLbxlO/Q/8MX8z49c5BlCloYPPsDI+yuG9b4I6bvwmE5Fe2j+tfhMq3Bi7gTKPgcoIU4ZMwwcb9OaBnAGLCIerGVfXK/ARU47etCMUzaOcpuXsfJJhRuOs0nZwl4K9Uk3aXHanC2YmhT0Y0D5USJ0So7E0V5j+fCYZET5h2IOE9Rkk43J49/X9kPWwMyVQ2dEAyfw0YZssu5UH7jh1yX3W6ia5A6IoKWDA26Czi/3MGtFHchHyLmaNJyP3zoN08J2DrIgFmJeQEQduHVHq2uw6aSm7spM9
 paRatcnh
 n6/AP4MLYnaHWj1Swb/wjtG1StN5slpwTOJjvByNoEdx/MPrXmHwL+m72Y6/A3nPfZeR7v6lpIadpsBMuZHwmg+zG+CMKhvb8kJ4H2V7Ydpmi4Nh2Q9U6TzwmBFFoB3I0jae011iLLl1J678xT9ELsLjw+SUfdl8aQLxDGehJPJtj6lCt5CTSGa3oQPMZgkgT69HrkTSTGgdz+fhAEiN2dsIh10itMLRJr8d3bC9Sa4ewNv8ZdfImY92dLMuYMy6hnWBhCE7n9UwV+sLFkl1dsvCCxqE4T9oyV9ZkosXZMJl/DZWOGp1WTB8bZ9QeimLGeovx9zGjBtwpXx9tj4GJ2jskCxDJNRFp27STF0suSKBNYtrLnPGM8x+K5oFqlMWO65ESHF2u9PDQTwpa9W0ShtZfuOcrNRq8Uk9PPcCiKgaQ9fIOnB9jUvux94vlw1RezJYGnYN9FRlUbdoD4l1MofI4h1cBuDlfKQ9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 12:37:57PM +0300, Mike Rapoport wrote:
> On Mon, Aug 04, 2025 at 12:54:21PM +0200, Uladzislau Rezki wrote:
> > Hello, Lorenzo!
> > 
> > > So sorry Ulad, I meant to get back to you on this sooner!
> > > 
> > > On Tue, Jul 29, 2025 at 08:39:01PM +0200, Uladzislau Rezki wrote:
> > > > On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> > > > > Andrew - FYI there's nothing to worry about here, the type remains
> > > > > precisely the same, and I'll send a patch to fix this trivial issue so when
> > > > > later this type changes vmalloc will be uaffected.
> > > > >
> > > > > On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > > > > > [Adding Uladzislau to Cc]
> > > > >
> > > > > Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> > > > > same name and (currently) type as vma->vm_flags and is already the source
> > > > > of confusion.
> > > > >
> > > > You mean all "vm_flags" variable names? "vm_struct" has flags as a
> > > > member. So you want:
> > > >
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
> > > > 3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
> > > > 3875:                   pgprot_t prot, unsigned long vm_flags, int node,
> > > > 3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
> > > > 3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
> > > > 3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
> > > > 4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
> > > > 172:                    pgprot_t prot, unsigned long vm_flags, int node,
> > > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$
> > > >
> > > > to rename all those "vm_flags" to something, for example, like "flags"?
> > > 
> > > Yeah, sorry I know it's a churny pain, but I think it's such a silly source
> > > of confusion _in general_, not only this series where I made a mistake (of
> > > course entirely my fault but certainly more understandable given the
> > > naming), but in the past I've certainly sat there thinking 'hmmm wait' :)
> > > 
> > > Really I think we should rename 'vm_struct' too, but if that causes _too
> > > much_ churn fair enough.
> 
> Well, it's not that terrible :)
> 
> ~/git/linux$ git grep -w vm_struct | wc -l
> 173
> 
Indeed :)


> > > I think even though it's long-winded, 'vmalloc_flags' would be good, both
> > > in fields and local params as it makes things very very clear.
> > > 
> > > Equally 'vm_struct' -> 'vmalloc_struct' would be a good change.
> 
> Do we really need the _struct suffix?
> How about vmalloc_area?
> 
I think, we should not use vmalloc_ prefix here, because vmalloc
operates within its own range: VMALLOC_START:VMALLOC_END, therefore
it might be confusing also.

others can use another regions. vmap_mapping?

>
> It also seems that struct vmap_area can be made private to mm/.
> 
I agree. Also it can be even moved under vmalloc.c. There is only one
user which needs it globally, it is usercopy.c. It uses find_vmap_area()
which is wrong. See:

<snip>
	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
		struct vmap_area *area = find_vmap_area(addr);

		if (!area)
			usercopy_abort("vmalloc", "no area", to_user, 0, n);

		if (n > area->va_end - addr) {
			offset = addr - area->va_start;
			usercopy_abort("vmalloc", NULL, to_user, offset, n);
		}
		return;
	}
<snip>

we can add a function which just assign va_start, va_end as input
parameters and use them in the usercopy.c. 

Thanks!

--
Uladzislau Rezki

