Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A83EEF314
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A6A6B0088; Thu,  5 Mar 2026 02:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02936B0089; Thu,  5 Mar 2026 02:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C097D6B008A; Thu,  5 Mar 2026 02:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC61B6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:47:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 247E28C438
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:47:31 +0000 (UTC)
X-FDA: 84511229502.21.0384A10
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2984E100007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:47:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HIUBD1Is;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772696849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKeJ7rMALYTbebsY+kRx+KAJHf7HkxWsA8p9wEo81Rc=;
	b=T6Xoicap3V/qtTwD6twxa7O13zYKEmKfngmNgmSCXDFWRltv+f9PIVrI+Nr0w5NYhF9/RF
	H8WW0d6ImR+JJRqaar1Wb3Tx4a3N0GaiPH8hNmQqKkENP6WTpeJL75ksbMDL0FL2nINcIT
	271WFavjDOL88hrHnVnlUX4ainO8xyA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HIUBD1Is;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772696849; a=rsa-sha256;
	cv=none;
	b=KGQqflTedsTYGfNCzpBg2uUeXhGzI74+29NxIgPVHVb3laL/i2I3FwhME/AGNrzIoA03wo
	kcYmk/+ssFUDRB/ATpjnNQDn8CpXtfEP5kfInnbqNG3hrLMexB3o2aPD6BEdWUnBm4rDPZ
	U6B8Hsvqj5hqUgIqiNF8fUsNIaXZDy4=
Date: Thu, 5 Mar 2026 15:47:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772696846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tKeJ7rMALYTbebsY+kRx+KAJHf7HkxWsA8p9wEo81Rc=;
	b=HIUBD1IsTFwPZ4qEjY/0K3tu4spsSjCBv9LEDoadmVWlxoimJNXZbtQnZuhYoozLN9lIh6
	yX2QtLVwxcO6I5E87dHbUAbmbSGOloHzhyD7Qe1JWS/A4YNXr4vCjWgcoOnlyVX0c7p90u
	0xThu9wpor+iBCIhzgduOWfywjKUr5Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, vbabka@suse.cz, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, cl@gentwo.org, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com, pfalcato@suse.de
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
Message-ID: <osbee2ajebflm2rlcyh6qe5yhra6zulmjyz5j775z4pcmsxrmy@qgs6pi4s4fpd>
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
 <41f1c856-2c41-4d11-96e6-079d95d8efbb@linux.ibm.com>
 <aakrMQ9fKG52WtxE@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aakrMQ9fKG52WtxE@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2984E100007
X-Rspamd-Server: rspam08
X-Stat-Signature: emzu5ufoh6gj4n3pp67sskkacbi7bb9m
X-HE-Tag: 1772696848-650765
X-HE-Meta: U2FsdGVkX185y8ZLS+PF14XgZ//v6sB47p39pA4i2N7+5wYKV9fQkF0hUG5qU6KXQlxFZf6/N10Eah+XxzWtKr4MDSBEwF/mI0iyOo+dyIOCgYhQsngorU5Ehi/oBF/ykle7j3R6zXhc2AuBpxSbKGAzBLgVZSxu4ny483pQSD/2TUHHPP6kfK10lSyi2DytAvKRp2I/jPR2KPQ3iPioRZbW+cBkasjUklB0bS+zlXSv59AoAyTjCVGliZ+NamQZMHIB2zPBlz5iYMEdPpAfzx8SfeIaNMcdAc0S3srbgOn9Lr9lauY0mCWuR75V0Zl7ZlYD4fV4YqgDcHupCMvmDbzQQqe82CqPl5vMBM1JJtj2v9wfpykAu/o6arfb9yMn4OxG7P0TDuCxwLxRSe4UfwcEvQESGIHbAigrka0hoMn+sC5ggNVKDAHrsTvPKXE7xq+6qvKXZ8Na1bImwaqa/HURvYH+3VzrV4n+t1saOqxy/EsZUtf54WJg9mI4lK+XWdCwo0z+dZa9qDuus32MQFYnLxHAv0W3HOSa3Tg0P9fO7w9DDgZJHTttfybIF+jt7ba3xWBBTOSaBIc9FF/R+3NHAKD5TpWiHHkGpOxIRfzQzYcScuMc7mdzQgcJtx6HcVtTP1fna1QbdoKzmvlkAwh/XM7oprKW0inWcVwtcrfz7C16opW18v8imDWTzYG90kOpyWoTS0oURZgM6FUYedGsW5q7k4XllfpJRZoovr9SAy/2/It07rTBFkHCUA07jF1s7GBM7F5P/TJWrUYBKXau848ZqMSlqf5vCsONdC0JgWm4qh0ZaVsfAgRQ8L9xkXwxDehu9oIIi40ntWhGZT5YcLxw/EcPgZBT28lJOmCIV3KVeJN/mtk+OMkx8T/T9tQw9zCOfJiwz0gIywXxjcWBedpyKWd3J5zie7n5L8Bi4was2tcoPhfw9jAFvJJCLy2jaqPeYB9+xDALBC2
 snNKJNpT
 s3d3sYLZiQ4itgvkug6kKLrnqtW79u7dWslqf4DHwTgm7bajpITKxuUj6Bf2pLmJauvPFVHYowPWEqRPM1sngKAKbOHXlb+2p8YT8ogTZfenkDvYIbKDcPVhFKkhEgckB8A/A8rCzscuxk2rSFyox5i3DAasKYdGj0A3VAPH0OgQxPncVI1RMHDWcMKLlaWskaxahQ7/suQx7o2SrWFJffUbK7KLYuqT7CUfj8sX+Ah9xCZAoEgXokoGBEdBDeBlExg6seCyI2i9t8XtdYWAXTZ42qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 04:05:21PM +0900, Harry Yoo wrote:
> On Thu, Mar 05, 2026 at 12:24:08PM +0530, Venkat Rao Bagalkote wrote:
> > On 03/03/26 7:27 pm, Harry Yoo wrote:
> > > Commit 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> > > defined the type of slab->stride as unsigned short, because the author
> > > initially planned to store stride within the lower 16 bits of the
> > > page_type field, but later stored it in unused bits in the counters
> > > field instead.
> > > 
> > > However, the idea of having only 2-byte stride turned out to be a
> > > serious mistake. On systems with 64k pages, order-1 pages are 128k,
> > > which is larger than USHRT_MAX. It triggers a debug warning because
> > > s->size is 128k while stride, truncated to 2 bytes, becomes zero:
> > > 
> > >    ------------[ cut here ]------------
> > >    Warning! stride (0) != s->size (131072)
> > >    WARNING: mm/slub.c:2231 at alloc_slab_obj_exts_early.constprop.0+0x524/0x534, CPU#6: systemd-sysctl/307
> > >    Modules linked in:
> > >    CPU: 6 UID: 0 PID: 307 Comm: systemd-sysctl Not tainted 7.0.0-rc1+ #6 PREEMPTLAZY
> > >    Hardware name: IBM,9009-22A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW950.E0 (VL950_179) hv:phyp pSeries
> > >    NIP:  c0000000008a9ac0 LR: c0000000008a9abc CTR: 0000000000000000
> > >    REGS: c0000000141f7390 TRAP: 0700   Not tainted  (7.0.0-rc1+)
> > >    MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28004400  XER: 00000005
> > >    CFAR: c000000000279318 IRQMASK: 0
> > >    GPR00: c0000000008a9abc c0000000141f7630 c00000000252a300 c00000001427b200
> > >    GPR04: 0000000000000004 0000000000000000 c000000000278fd0 0000000000000000
> > >    GPR08: fffffffffffe0000 0000000000000000 0000000000000000 0000000022004400
> > >    GPR12: c000000000f644b0 c000000017ff8f00 0000000000000000 0000000000000000
> > >    GPR16: 0000000000000000 c0000000141f7aa0 0000000000000000 c0000000141f7a88
> > >    GPR20: 0000000000000000 0000000000400cc0 ffffffffffffffff c00000001427b180
> > >    GPR24: 0000000000000004 00000000000c0cc0 c000000004e89a20 c00000005de90011
> > >    GPR28: 0000000000010010 c00000005df00000 c000000006017f80 c00c000000177a00
> > >    NIP [c0000000008a9ac0] alloc_slab_obj_exts_early.constprop.0+0x524/0x534
> > >    LR [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534
> > >    Call Trace:
> > >    [c0000000141f7630] [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534 (unreliable)
> > >    [c0000000141f76c0] [c0000000008aafbc] allocate_slab+0x154/0x94c
> > >    [c0000000141f7760] [c0000000008b41c0] refill_objects+0x124/0x16c
> > >    [c0000000141f77c0] [c0000000008b4be0] __pcs_replace_empty_main+0x2b0/0x444
> > >    [c0000000141f7810] [c0000000008b9600] __kvmalloc_node_noprof+0x840/0x914
> > >    [c0000000141f7900] [c000000000a3dd40] seq_read_iter+0x60c/0xb00
> > >    [c0000000141f7a10] [c000000000b36b24] proc_reg_read_iter+0x154/0x1fc
> > >    [c0000000141f7a50] [c0000000009cee7c] vfs_read+0x39c/0x4e4
> > >    [c0000000141f7b30] [c0000000009d0214] ksys_read+0x9c/0x180
> > >    [c0000000141f7b90] [c00000000003a8d0] system_call_exception+0x1e0/0x4b0
> > >    [c0000000141f7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> > > 
> > > This leads to slab_obj_ext() returning the first slabobj_ext or all
> > > objects and confuses the reference counting of object cgroups [1] and
> > > memory (un)charging for memory cgroups [2].
> > > 
> > > Fortunately, the counters field has 32 unused bits instead of 16
> > > on 64-bit CPUs, which is wide enough to hold any value of s->size.
> > > Change the type to unsigned int.
> > > 
> > > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > > Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
> > > Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com
> > > Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > > 
> > > Hi Venkat, could you please test this on top of 7.0-rc2 (instead of
> > > 7.0-rc1) and see if the bugs [1] [2] are reproduced on your machine?
> > 
> > 
> > Hello Harry,
> > 
> > Apologizes for delayed response,
> 
> No worries.
> 
> > I was out sick.
> 
> Ouch :( hope you feel better now.
> 
> > I have tested this patch on top of 7.0-rc2, and confirm, this patch fixes
> > both the reported issue.
> >
> > Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> 
> Thanks a lot for testing & confirming!

Indeed!
What a counterintuitive issue!

-- 
Thanks,
Hao

