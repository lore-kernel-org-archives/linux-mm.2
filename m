Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FAFEF8FE4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606166B0096; Thu,  5 Mar 2026 08:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7846B0098; Thu,  5 Mar 2026 08:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3E86B0099; Thu,  5 Mar 2026 08:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F86A6B0096
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:38:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E18BF14016C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:38:08 +0000 (UTC)
X-FDA: 84512113056.03.0F9D1C7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id C331B40010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:38:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GlXtjOuJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ckrEx+v1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v0vJbOVq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SjaIV6rV;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772717887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWiaf7JHO1yQMIZzhMHLzk5TF56RcSb1mn/7GtkevQw=;
	b=kamfnZPcwUlulaATs7SDvi3i77rqf5ZyWboCvZ84FK5blWQNpxomP7Hx1PI2ZTHsYx9OOi
	Bk65EzGRL3lZceruu7zjf8PsYkVz4XJyTb98jSQvecJmHsHUy/1MEQPhNS66AePHZJyS4M
	KgqmN/WldIFtLuYhqN5YjGyxeCyLZeM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GlXtjOuJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ckrEx+v1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v0vJbOVq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SjaIV6rV;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772717887; a=rsa-sha256;
	cv=none;
	b=vijGVAmr5Pe/zs1zsrJ3EEOaONdD4Ud1CHBnOx+r/m0ZiJ2J1m3S+bC0cutx6m2j+Fq7pT
	qC6hqbPqiAXOnCcqQPBAo6Tzj3x0sPU63oP1A3QPzdo5Wr31PyjKG81cWkSnLJ4jBKJb+e
	hdVgFnh5rJX8pzfhlNiurAZkrMFvObg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ABED43F845;
	Thu,  5 Mar 2026 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772717885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vWiaf7JHO1yQMIZzhMHLzk5TF56RcSb1mn/7GtkevQw=;
	b=GlXtjOuJ0gwKMbkRVxjztv//Fwp7K3jYaYoqTR5jDj9m+rQ14tLrSTxCL3L2U1lz1MipS9
	pl03zkn4U31TBoU7ZIiz85NUyfZriKCL/XqIodWGnjsFbYs7U5FKvS6ZHJponkh499KykW
	XFEuTFJ6BjKFGbODYUpT4IncSZOumZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772717885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vWiaf7JHO1yQMIZzhMHLzk5TF56RcSb1mn/7GtkevQw=;
	b=ckrEx+v1zHHWCzgxKE788tHF/BtxC67UTkHevytiMBoQVaTUwa+oyh0tUd0QAMwZX28auY
	8HGFL5ePAx/Y4IDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772717883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vWiaf7JHO1yQMIZzhMHLzk5TF56RcSb1mn/7GtkevQw=;
	b=v0vJbOVqnQsz8U+MYjT84HjrJ5DFz1kpjm/wALajLHEsfHjFqoQbJQ84r8VLRcDt2Y+ir7
	kfu0+G+L2jYkeWPAIA+sI/geyx+2TEFPejRqGUt8gWf4sIcNNG1Pwmv7bgU8ACc62lBdfp
	DMbuxqyvjSkS56aHnPO8NOZEaGTILBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772717883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vWiaf7JHO1yQMIZzhMHLzk5TF56RcSb1mn/7GtkevQw=;
	b=SjaIV6rV0Y18j2O930WQqY4c/J45JieRbwT412/J9nFJGxy0kbU7KZJ/kEBxtSeQJPqiW+
	PsKZKb+HZXrtTqDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B186C3EA68;
	Thu,  5 Mar 2026 13:38:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7MYHKDqHqWloPgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 05 Mar 2026 13:38:02 +0000
Date: Thu, 5 Mar 2026 13:38:00 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	cl@gentwo.org, hannes@cmpxchg.org, hao.li@linux.dev, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com, 
	venkat88@linux.ibm.com
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
Message-ID: <koh6zoceul7tixkkup7f5vfhfsuzeidra66qrfmojh2izt2epm@aryxsv62nfft>
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303135722.2680521-1-harry.yoo@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C331B40010
X-Rspamd-Server: rspam07
X-Stat-Signature: xk9xrsrqan7hy1cfzzhbzmnkiaz89mmm
X-Rspam-User: 
X-HE-Tag: 1772717886-790787
X-HE-Meta: U2FsdGVkX1+b/EMGB3yPlWfuDjeRihw+PraxJ6JzixhTcerf4quCTrkD6TcCmRqqI9MOWrmuQ4y0M2LaqQZ9nQ0GYAEIZi9iUv94bKWD/wP2T4k/1Y6h9gKzTEWaZziI8YAcV7B6p4KeT3Mw2wej66//B7cR1v+vQ3wPhJSqmjBJ7XJdofS6PDs96sg9uKHSkCJ1Wxj0ESA66yesJIscOhFrUqr1g86vgHcIiEqb0MFA9V3fJnR0PomtQ5mDYswB15jSJAyZ7u5cLjUPFVUirWNucuvA+FsbUq60AbQrWGxuKfiy7MIDVXla0R4K+uYTBCf//aWsA7InzceqqOCwrBjIVrttAvJLEsfBwYPCGNevrmlm5lSPojln0PheECX5gnGzVm0K5JZLOqKdqreF5+/DGP8M9dpBlNpXu7xbvDyuDY+UQoTdpQ/W0ptLB4OrxI8bXXj+omDV/2GEAfwPzcAwLPXw/tF24aIuOAbZsSJfNOW4ufrUEYJChpb04T/F1rp+G5SBtNK7quF5bksYk3n7ak7tnlR0QmNYaWbbdekuKcQoO+gtvqrbQLqkGkKZCkNy1zEXBM3Dos3Owe8t+dxdB75csM15cNd32YBCOPRJ331QWWSgzVUL7SoB3PFgVnxrQHa4NoleTKL8JnDJe5D1ziqSV51hdDPIKamBZjw2XVxORz4TJSs+XYILlX9Ng6VqWkAP5b2rc/VMf3uhsMGpTq68qNqjykQWD34hMXAtYkuVqMenyzZPZjXTkAwsgEue2McmTTLcJTXfpUnjAnzVEsonXqg/qZL4ZFvF0utIeMA8+3DfyG0Z5pJm38y6H5svgOZvbP5kxwj2cOFjBorJzFP/QpRKfvnQ1mCXcqt0ricx7bjyPSla4xrficmjU6iWv0UVn5iYzBOzsptNOBn+DpJOjq2ePM5/LLtXNdOfLWgxeU0E8D//ACXvtcONNDNNlYOaBhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:57:22PM +0900, Harry Yoo wrote:
> Commit 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> defined the type of slab->stride as unsigned short, because the author
> initially planned to store stride within the lower 16 bits of the
> page_type field, but later stored it in unused bits in the counters
> field instead.
> 
> However, the idea of having only 2-byte stride turned out to be a
> serious mistake. On systems with 64k pages, order-1 pages are 128k,
> which is larger than USHRT_MAX. It triggers a debug warning because
> s->size is 128k while stride, truncated to 2 bytes, becomes zero:
> 
>   ------------[ cut here ]------------
>   Warning! stride (0) != s->size (131072)
>   WARNING: mm/slub.c:2231 at alloc_slab_obj_exts_early.constprop.0+0x524/0x534, CPU#6: systemd-sysctl/307
>   Modules linked in:
>   CPU: 6 UID: 0 PID: 307 Comm: systemd-sysctl Not tainted 7.0.0-rc1+ #6 PREEMPTLAZY
>   Hardware name: IBM,9009-22A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW950.E0 (VL950_179) hv:phyp pSeries
>   NIP:  c0000000008a9ac0 LR: c0000000008a9abc CTR: 0000000000000000
>   REGS: c0000000141f7390 TRAP: 0700   Not tainted  (7.0.0-rc1+)
>   MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28004400  XER: 00000005
>   CFAR: c000000000279318 IRQMASK: 0
>   GPR00: c0000000008a9abc c0000000141f7630 c00000000252a300 c00000001427b200
>   GPR04: 0000000000000004 0000000000000000 c000000000278fd0 0000000000000000
>   GPR08: fffffffffffe0000 0000000000000000 0000000000000000 0000000022004400
>   GPR12: c000000000f644b0 c000000017ff8f00 0000000000000000 0000000000000000
>   GPR16: 0000000000000000 c0000000141f7aa0 0000000000000000 c0000000141f7a88
>   GPR20: 0000000000000000 0000000000400cc0 ffffffffffffffff c00000001427b180
>   GPR24: 0000000000000004 00000000000c0cc0 c000000004e89a20 c00000005de90011
>   GPR28: 0000000000010010 c00000005df00000 c000000006017f80 c00c000000177a00
>   NIP [c0000000008a9ac0] alloc_slab_obj_exts_early.constprop.0+0x524/0x534
>   LR [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534
>   Call Trace:
>   [c0000000141f7630] [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534 (unreliable)
>   [c0000000141f76c0] [c0000000008aafbc] allocate_slab+0x154/0x94c
>   [c0000000141f7760] [c0000000008b41c0] refill_objects+0x124/0x16c
>   [c0000000141f77c0] [c0000000008b4be0] __pcs_replace_empty_main+0x2b0/0x444
>   [c0000000141f7810] [c0000000008b9600] __kvmalloc_node_noprof+0x840/0x914
>   [c0000000141f7900] [c000000000a3dd40] seq_read_iter+0x60c/0xb00
>   [c0000000141f7a10] [c000000000b36b24] proc_reg_read_iter+0x154/0x1fc
>   [c0000000141f7a50] [c0000000009cee7c] vfs_read+0x39c/0x4e4
>   [c0000000141f7b30] [c0000000009d0214] ksys_read+0x9c/0x180
>   [c0000000141f7b90] [c00000000003a8d0] system_call_exception+0x1e0/0x4b0
>   [c0000000141f7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
> 
> This leads to slab_obj_ext() returning the first slabobj_ext or all
> objects and confuses the reference counting of object cgroups [1] and
> memory (un)charging for memory cgroups [2].
> 
> Fortunately, the counters field has 32 unused bits instead of 16
> on 64-bit CPUs, which is wide enough to hold any value of s->size.
> Change the type to unsigned int.
> 
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com [2]
> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

> ---
> 
> Hi Venkat, could you please test this on top of 7.0-rc2 (instead of
> 7.0-rc1) and see if the bugs [1] [2] are reproduced on your machine?
> 
> I reproduced a debug warning on a ppc machine and fixed it.
> The bugs are expected to be resolved by this fix.
> 
> p.s. After more debugging, I saw stride appeared as 0 even on the CPU
> that wrote it, which likely rules out a memory ordering issue...

More fun than debugging memory ordering issues, is debugging memory ordering
issues that actually don't exist!

-- 
Pedro

