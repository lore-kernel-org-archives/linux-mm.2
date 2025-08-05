Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35387C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACE66B008C; Tue,  5 Aug 2025 05:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85666B0096; Tue,  5 Aug 2025 05:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AD86B0098; Tue,  5 Aug 2025 05:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB69D6B008C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:38:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CA92140215
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:38:23 +0000 (UTC)
X-FDA: 83742203286.14.4F5685B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8137518000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:38:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WaqdWXeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754386701; a=rsa-sha256;
	cv=none;
	b=Yn009L3FH/d+uXWjmQ1xqoQnysEoWbWz57UPCEzufHZXhyXoXjthXQNjkOTc3GNX6EtBJb
	cOj+ZqCjLSmAKD1JSnr0vB0Eue327Kwktysb1/fcn1zaimTdICNhn8OAHizefxG893Fr54
	n/Xc8lr1jX37TsbON6t/m6ENGneQVwk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WaqdWXeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754386701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qq75wLn4Jr35PxKHT8Ir8YDRfOwxEOJ3fDUl+YJWOlw=;
	b=RcpGAeqd6bRwIv0AeMIs8qFYjx9Z8sTOhFnwCjYnTzUAynTOntMjerT37FIDVjX8biZTn2
	Dn8T4nbgb+07/pQIOvZD2Z5PrR28N6PRWSavmgODmfa67yQ7nR24nE/Sa0qeZ1UMyZEO6z
	S6REqS/xYikqNAXIVQl+bgCA7beBVAc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 230995C3FEF;
	Tue,  5 Aug 2025 09:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73A3C4CEF7;
	Tue,  5 Aug 2025 09:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754386699;
	bh=PtcIziWKmeZojE8NbukEIlxT+NCLvvfcRfGscENjViM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WaqdWXeHFq4oltQn9PTlA505X/oL+/hHqNtgIoY7zKJ2rAIIyFMHaM+0OG/yh2pw4
	 a4OPg6vNpHqwYzZOYWH9z2eFj0o9qdjphfKwQATxpDET/tUKgH15v5CCmaccGtiziI
	 K47HqBXpuuIazHWs7f7nOBdJzkPcC6o7Uz2XE0NjVLokbL/vEdh4tvhC3lSlpz6wIJ
	 cRJvBI/3D77VRI3Nw6Ov+py/jFgFc5Ni8OH6Dnx4eGST8kP5vZjYp9Nb+FQNxwUhWq
	 2m2r86L7YkwtCZGME114r4pdSCFeteEHhrAOdiqvbKwV054IIClCJwCyv020K+cNSI
	 X5cmccT7jkP9Q==
Date: Tue, 5 Aug 2025 12:37:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Message-ID: <aJHQ9XCLtibFjt93@kernel.org>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJCRXVP-ZFEPtl1Y@pc636>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8137518000C
X-Stat-Signature: gz1k4m7qgt5gx4jfh8tbaz9nk4f5chx5
X-HE-Tag: 1754386701-75432
X-HE-Meta: U2FsdGVkX1/RB6yvieloPKwjejGAZOLz1phujSj4VzP+di5+RLk0O0Oz5T19p0zJ+1s8MkteouVTx8MA/tuLLhzgu+Gn69HWWV+iNBmNfQtipz1JojGSjeG4SmIzO9XDCwwk5R2db0k2WZ96VFzmscdh8kJuYsEgZXJPxD5OgFoEzMu2taSLYq2lqJxYHANDDYYb5vLom9gDNcZ+iTj5tiSJJwhfbuacMcXR6e7aSD+JkM+iwEstBIqN92rLww4wOUIB3Oj33De+8NDdya7EG17iY92otSRF8oQJOYNrjFXUPkXBMzd7UpeSJW2LNDSR3ADdh56drh8e5X7SjpnaHVgDc1xj8YmDgZT6Ei3S4U3AF+MHJR0gLoBwLehmBRWcWJ8aAdLE0CQAHv52YodtSAtimZRNWUPA4rl0SWYCooU8deXB/SK0Y8On9Ru4rhg8xTKxy4hb31hGIWs5MP/WbSDXhdlj5vLCAhuHTmmHpVu+7xM40OWyZ41ViZrsELBHyAW/cm5/tiHjtBz+vTZeBrSiBsM4empneIyAcA5jQAPVzWknAafZPtbu2bcZn8ZJli1ECcXQXmVLScvKHsdfF0ANyaTLphRn11ZEogDYYU+PGzzWKX9QCou5Ocj5b7IwhRV6AIHZ4HwQ0kvApCD87zn5vJcBh5A5bPXh1p++382k0ih7p9Wki/s4bU8ABWgm0+92nefSmI+X9Hokuq4uHo1qB3EqNOG+GlXrV2r5Q4YnS83Cz1TXQOsDArjZQNNtYBZ7TTPCf8JrMefsOXRoyLKpeGTJHdpE0dfHj8LIAF5jO6mjpePw19lnj7ybw5m2vvFKwGaHVwFUBPDYeGgm38nw9RtbUJ0xz89pc0o0ps6YXs/reoutVZQgPnZHHqDWfHpK85PuHH8m7BFGkTVRMrnySBHN6odipgsNWkooYCtBBoK6uS8W72V6J/LotAyCl2Vq+/2dicww1XQ4vbc
 Zwo0J6Hh
 fTBtY1c0Y11uD7pYhCinbHNvFOyUJPhaB2QD92wSmQc8QgiFmlWVgBlnyBysrTJTYRaZD4ru+UHoIfpxVAQ3VXFmxrEB3DUhhyyM1c20D0T9XYgnQzyRqWRRAzbhcvHzrTirimSUV1ZBGlzuRV5AlwqCpl/ZfxEKHsGI6HF6bVwfPhIXd9gQkB+Y71due0H2saZI7/G9uR7JLzksKSao4/H99BjkxiTmMUrvkfbMSl4+09X0+hwlHOOfgEg6ESfwbNbDUzivdXZb0YW+nV+Zb1RSMPvxbXrwthjn2Iw1CXnvSfhI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 12:54:21PM +0200, Uladzislau Rezki wrote:
> Hello, Lorenzo!
> 
> > So sorry Ulad, I meant to get back to you on this sooner!
> > 
> > On Tue, Jul 29, 2025 at 08:39:01PM +0200, Uladzislau Rezki wrote:
> > > On Tue, Jul 29, 2025 at 06:25:39AM +0100, Lorenzo Stoakes wrote:
> > > > Andrew - FYI there's nothing to worry about here, the type remains
> > > > precisely the same, and I'll send a patch to fix this trivial issue so when
> > > > later this type changes vmalloc will be uaffected.
> > > >
> > > > On Tue, Jul 29, 2025 at 09:15:51AM +0900, Harry Yoo wrote:
> > > > > [Adding Uladzislau to Cc]
> > > >
> > > > Ulad - could we PLEASE get rid of 'vm_flags' in vmalloc? It's the precise
> > > > same name and (currently) type as vma->vm_flags and is already the source
> > > > of confusion.
> > > >
> > > You mean all "vm_flags" variable names? "vm_struct" has flags as a
> > > member. So you want:
> > >
> > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/vmalloc.c
> > > 3853: * @vm_flags:                additional vm area flags (e.g. %VM_NO_GUARD)
> > > 3875:                   pgprot_t prot, unsigned long vm_flags, int node,
> > > 3894:   if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
> > > 3912:                             VM_UNINITIALIZED | vm_flags, start, end, node,
> > > 3977:   if (!(vm_flags & VM_DEFER_KMEMLEAK))
> > > 4621:   vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags mm/execmem.c
> > > 29:                          pgprot_t pgprot, unsigned long vm_flags)
> > > 39:             vm_flags |= VM_DEFER_KMEMLEAK;
> > > 41:     if (vm_flags & VM_ALLOW_HUGE_VMAP)
> > > 45:                              pgprot, vm_flags, NUMA_NO_NODE,
> > > 51:                                      pgprot, vm_flags, NUMA_NO_NODE,
> > > 85:                          pgprot_t pgprot, unsigned long vm_flags)
> > > 259:    unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> > > 266:    p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
> > > 376:    unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
> > > 385:            p = execmem_vmalloc(range, size, pgprot, vm_flags);
> > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$ grep -rn vm_flags ./include/linux/vmalloc.h
> > > 172:                    pgprot_t prot, unsigned long vm_flags, int node,
> > > urezki@pc638:~/data/backup/coding/linux-not-broken.git$
> > >
> > > to rename all those "vm_flags" to something, for example, like "flags"?
> > 
> > Yeah, sorry I know it's a churny pain, but I think it's such a silly source
> > of confusion _in general_, not only this series where I made a mistake (of
> > course entirely my fault but certainly more understandable given the
> > naming), but in the past I've certainly sat there thinking 'hmmm wait' :)
> > 
> > Really I think we should rename 'vm_struct' too, but if that causes _too
> > much_ churn fair enough.

Well, it's not that terrible :)

~/git/linux$ git grep -w vm_struct | wc -l
173

> > I think even though it's long-winded, 'vmalloc_flags' would be good, both
> > in fields and local params as it makes things very very clear.
> > 
> > Equally 'vm_struct' -> 'vmalloc_struct' would be a good change.

Do we really need the _struct suffix?
How about vmalloc_area?

It also seems that struct vmap_area can be made private to mm/.

> Uh.. This could be a pain :) I will have a look and see what we can do.
> 
> Thanks!
> 
> --
> Uladzislau Rezki

-- 
Sincerely yours,
Mike.

