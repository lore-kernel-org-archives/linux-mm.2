Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E24CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02A58E000D; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BEF8E0002; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BEC8E000D; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5728E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14079BA5B1
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:24:43 +0000 (UTC)
X-FDA: 84079496046.29.1F0C46C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8466B20007
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:24:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MQfFohEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762417481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FnkNdHhMVBUSWhSH665J4Pt2qzWSihqM7/C3ojK3sM=;
	b=X3VfzkeNAhbIJEK6toJtMD2HLSs6J6eFaMv6cprRRz9IhUDCMdhzSBaySrwusxfzkqwnfT
	w0fiGhT8/kSDbJwcV73DFQfOhKLHx2LKTQTlksvOGduyaMjGz179TA+aqqTSKYR4XOUyLF
	pAt0CTjamnLCZf2uO1wzQeNixgx46q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762417481; a=rsa-sha256;
	cv=none;
	b=gnj0r2YyCvIj6BbJ/fcB5jFMDiyCbd6NT4Yb3H+WbybTJa+jLtKWV5a0yT4CsvCZk+wU4w
	lwQAhliIQ0bdWCd3eyvZWSe4sz571UiTKDFaoahBuNxszi9dWt+5Qxv944rEiujBxHBrVr
	lKT7/kPUfsgZqU6zV/dpmv3iuoeUzZQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MQfFohEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A105F6022B;
	Thu,  6 Nov 2025 08:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3145C4CEFB;
	Thu,  6 Nov 2025 08:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762417480;
	bh=tnT+oLc/kBo4dvSKn58H5wJqyeTpfH6PqdkJR5lwiCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MQfFohEUn+hXz5i9qgPu11Y8k2A6IGar+vdTxNhbAo5kq96oZC66SvEwCEwZLngMa
	 nZqgVO6+lGr5SbnAscnFEGlOYth+V4uFEvuRy8xVQMnvVEiHxMmse/uc5VnagiJNt8
	 7+LUyj+hqpudRx/65qxTU8MdcRF9WWbQQgyoIMJ5FYNqvVvXm0EJe3tzNLVe4x9hWN
	 OwMtBjGFSqk12yNZ+IiQNnuFCH6ChjQrOxCXNG3qNwMylFktFN1x1Sr2exkVzhcv2W
	 GcbUH/H4EasrjeEnAZuC2B/VAI67qBmhIzlMObyBFLthPShiCWyultl0kZZGY0ZbBJ
	 1YtPynLoEba2g==
Date: Thu, 6 Nov 2025 10:24:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com,
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org,
	bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net,
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
	dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com,
	hpa@zytor.com, jgowans@amazon.com, kexec@lists.infradead.org,
	krzk@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
	mark.rutland@arm.com, mingo@redhat.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterz@infradead.org, robh@kernel.org,
	rostedt@goodmis.org, saravanak@google.com,
	skinsburskii@linux.microsoft.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
Message-ID: <aQxbOG65t-Vu6TVe@kernel.org>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-2-changyuanl@google.com>
 <ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
 <mafs0wm4yluej.fsf@kernel.org>
 <mafs0h5w2lpqu.fsf@kernel.org>
 <2ege2jfbevtunhxsnutbzde7cqwgu5qbj4bbuw2umw7ke7ogcn@5wtskk4exzsi>
 <mafs0cy6pljci.fsf@kernel.org>
 <c2nrxby4atq75o5yhwdpoikyso42tzimwn2bnl7fk54wuwdqax@i6kdssez3kfj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2nrxby4atq75o5yhwdpoikyso42tzimwn2bnl7fk54wuwdqax@i6kdssez3kfj>
X-Stat-Signature: jpbaizx3mx31n6583cqf8yipha1swjqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 8466B20007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762417481-337017
X-HE-Meta: U2FsdGVkX1+pi3xXGm+LmaF4kyBwU9o0nVdfDZsrRyieZql2SMLvZMHFI4ro10BfGEMkuCmKVDN4vfiKInwS+CFm5pGCGAM97MWX4V19zT1Y9f4nUR8fiRDqF1xzHelQlXj/Hz9MgefIteCRHzH1RlMOUc8R45bf65HgvmC0Shkrq4cR+Qmn4zbKMJKey0oEkdX6n7JPGepDBRo2KPzod9VsYk/YOCaqdMK67N0Gk+MVrrEcXEiHou0WuCv/5RLAyjDmTrJB3w9O2peUkgOddNlSLS4BuUoS90P4zqN2lEDYUBZuTLycNFQO4L+e/C2ONHyiAGD7j9bVks90ZsnjXzqpnhcSS1QsK3AsJdJJv43eDHHpE6WKOMM8aJ6ER6sEDWM6QkRMIozJ9FD4o52dgY0jlmUCbqInNCbR9MIaTwLBISfHRWrXIQp6RuApUb7bSYitf/OGHpAdmEDXQPUB2+mMvsYnWlNGVCaq7jJLzYlo8sofCNWHOBD6QtrbNEdevLQSCymlbd8sLCGDa96huX1KdungZ8QmfLnPaQN5+EVnCU48qhyZQ7f+HTeDJXLEtVmUxxB7Wfyo0Uc9gm+Mp2aQ61CGfyN7drHL3q+akv5gOMY4NNoR7dU3gw+h4KRmnSWMBoFbW/YYhzEX78xpSNKCofI33KGY7tXAmb1x55iWvvFv3r1knhTphJk2A22Xvn8GRQXpLk604ngtSyP6Ts4koMo73oCWOy/QbCh8S0hOp6L+9f7xWYtU3sqH+Z9XKnWn+sYvjpHjsat1YUbtoxQx7+pimN/llxOIPiUDqDADLwy/AXf6oqySn1inTOqrrK6vVehpBagNojCI/4Vj1y6qL6aoTr37OOhE86uaJljHk4MSCAKL0VC0q9eYBvfndQExIej1vbCmmlbAS/YKDGglQOCUIAAJK9mR0uBqZbTPw+jp0CaJYsPn0/+lZTrLquTLiehupPon1UdqBT/
 6DILKkSK
 YyNB9m7GJsKr86sSnwAXIluSn/4cOT7AHSeufpSQ5wxgir4Kt6/lA3daUtIFilKE4DEAl3j9tx0WOumiopLpXcc3/cmypWNo2LGBVTG0kVJH9VA1ua74V9Ow3o7Q6ddD7ume/rGiOQODSxE8aMO0Pud6C2dmuisxpPPYSukmb8NKjMl0/hb7mPP/RzHyHAYzRA1CGT5leJsUF8cb8ZrGhay5ui2wCI5EQWhMP2+1NHNnLhWuthGqx4abKrYf7hvmbdEutz1E84/FxFTHDLy655OraoH0Qh0mPVu4SYoBiVZ8dNxe6Z9JaqaRWivFQ3JC11bUudQniyjpsezk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Breno,

On Wed, Nov 05, 2025 at 02:18:11AM -0800, Breno Leitao wrote:
> Hello Pratyush,
> 
> On Tue, Oct 14, 2025 at 03:10:37PM +0200, Pratyush Yadav wrote:
> > On Tue, Oct 14 2025, Breno Leitao wrote:
> > > On Mon, Oct 13, 2025 at 06:40:09PM +0200, Pratyush Yadav wrote:
> > >> On Mon, Oct 13 2025, Pratyush Yadav wrote:
> > >> >
> > >> > I suppose this would be useful. I think enabling memblock debug prints
> > >> > would also be helpful (using the "memblock=debug" commandline parameter)
> > >> > if it doesn't impact your production environment too much.
> > >> 
> > >> Actually, I think "memblock=debug" is going to be the more useful thing
> > >> since it would also show what function allocated the overlapping range
> > >> and the flags it was allocated with.
> > >> 
> > >> On my qemu VM with KVM, this results in around 70 prints from memblock.
> > >> So it adds a bit of extra prints but nothing that should be too
> > >> disrupting I think. Plus, only at boot so the worst thing you get is
> > >> slightly slower boot times.
> > >
> > > Unfortunately this issue is happening on production systems, and I don't
> > > have an easy way to reproduce it _yet_.
> > >
> > > At the same time, "memblock=debug" has two problems:
> > >
> > >  1) It slows the boot time as you suggested. Boot time at large
> > >     environments is SUPER critical and time sensitive. It is a bit
> > >     weird, but it is common for machines in production to kexec
> > >     _thousands_ of times, and kexecing is considered downtime.
> > 
> > I don't know if it would make a real enough difference on boot times,
> > only that it should theoretically affect it, mainly if you are using
> > serial for dmesg logs. Anyway, that's your production environment so you
> > know best.
> > 
> > >
> > >     This would be useful if I find some hosts getting this issue, and
> > >     then I can easily enable the extra information to collect what
> > >     I need, but, this didn't pan out because the hosts I got
> > >     `memblock=debug` didn't collaborate.
> > >
> > >  2) "memblock=debug" is verbose for all cases, which also not necessary
> > >     the desired behaviour. I am more interested in only being verbose
> > >     when there is a known problem.
> 
> I am still interested in this problem, and I finally found a host that
> constantly reproduce the issue and I was able to get `memblock=debug`
> cmdline. I am running 6.18-rc4 with some debug options enabled.
> 
> 	DMA-API: exceeded 7 overlapping mappings of cacheline 0x0000000006d6e400
> 	WARNING: CPU: 58 PID: 828 at kernel/dma/debug.c:463 add_dma_entry+0x2e4/0x330
> 	pc : add_dma_entry+0x2e4/0x330
> 	lr : add_dma_entry+0x2e4/0x330
> 	sp : ffff8000b036f7f0
> 	x29: ffff8000b036f800 x28: 0000000000000001 x27: 0000000000000008
> 	x26: ffff8000835f7fb8 x25: ffff8000835f7000 x24: ffff8000835f7ee0
> 	x23: 0000000000000000 x22: 0000000006d6e400 x21: 0000000000000000
> 	x20: 0000000006d6e400 x19: ffff0003f70c1100 x18: 00000000ffffffff
> 	x17: ffff80008019a2d8 x16: ffff80008019a08c x15: 0000000000000000
> 	x14: 0000000000000000 x13: 0000000000000820 x12: ffff00011faeaf00
> 	x11: 0000000000000000 x10: ffff8000834633d8 x9 : ffff8000801979d4
> 	x8 : 00000000fffeffff x7 : ffff8000834633d8 x6 : 0000000000000000
> 	x5 : 00000000000bfff4 x4 : 0000000000000000 x3 : ffff0001075eb7c0
> 	x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0001075eb7c0
> 	Call trace:
> 	add_dma_entry+0x2e4/0x330 (P)
> 	debug_dma_map_phys+0xc4/0xf0
> 	dma_map_phys (/home/leit/Devel/upstream/./include/linux/dma-direct.h:138 /home/leit/Devel/upstream/kernel/dma/direct.h:102 /home/leit/Devel/upstream/kernel/dma/mapping.c:169)
> 	dma_map_page_attrs (/home/leit/Devel/upstream/kernel/dma/mapping.c:387)
> 	blk_dma_map_direct.isra.0 (/home/leit/Devel/upstream/block/blk-mq-dma.c:102)
> 	blk_dma_map_iter_start (/home/leit/Devel/upstream/block/blk-mq-dma.c:123 /home/leit/Devel/upstream/block/blk-mq-dma.c:196)
> 	blk_rq_dma_map_iter_start (/home/leit/Devel/upstream/block/blk-mq-dma.c:228)
> 	nvme_prep_rq+0xb8/0x9b8
> 	nvme_queue_rq+0x44/0x1b0
> 	blk_mq_dispatch_rq_list (/home/leit/Devel/upstream/block/blk-mq.c:2129)
> 	__blk_mq_sched_dispatch_requests (/home/leit/Devel/upstream/block/blk-mq-sched.c:314)
> 	blk_mq_sched_dispatch_requests (/home/leit/Devel/upstream/block/blk-mq-sched.c:329)
> 	blk_mq_run_work_fn (/home/leit/Devel/upstream/block/blk-mq.c:219 /home/leit/Devel/upstream/block/blk-mq.c:231)
> 	process_one_work (/home/leit/Devel/upstream/kernel/workqueue.c:991 /home/leit/Devel/upstream/kernel/workqueue.c:3213)
> 	worker_thread (/home/leit/Devel/upstream/./include/linux/list.h:163 /home/leit/Devel/upstream/./include/linux/list.h:191 /home/leit/Devel/upstream/./include/linux/list.h:319 /home/leit/Devel/upstream/kernel/workqueue.c:1153 /home/leit/Devel/upstream/kernel/workqueue.c:1205 /home/leit/Devel/upstream/kernel/workqueue.c:3426)
> 	kthread (/home/leit/Devel/upstream/kernel/kthread.c:386 /home/leit/Devel/upstream/kernel/kthread.c:457)
> 	ret_from_fork (/home/leit/Devel/upstream/entry.S:861)
> 
> 
> Looking at memblock debug logs, I haven't seen anything related to
> 0x0000000006d6e400.

It looks like the crash happens way after memblock passed all the memory to
buddy. Why do you think this is related to memblock?
 
> I got the output of `dmesg | grep memblock` in, in case you are curious:
> 
> 	https://github.com/leitao/debug/blob/main/pastebin/memblock/dmesg_grep_memblock.txt
> 
> Thanks
> --breno
> 

-- 
Sincerely yours,
Mike.

