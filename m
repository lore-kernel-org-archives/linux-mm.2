Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE3FD6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AAD16B031B; Thu, 22 Jan 2026 14:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9829C6B031C; Thu, 22 Jan 2026 14:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AD66B031D; Thu, 22 Jan 2026 14:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7517D6B031B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:29:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11860C3192
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:29:25 +0000 (UTC)
X-FDA: 84360588690.22.CA30D18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 453F640011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:29:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mSS/NLlM";
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ykXgGBs9eaPj8wyb5sENGkkzSsVAT5DPQvN0FLvWBE=;
	b=Jr+B+cCNYrux2hL2C+zh/o0QA+VgHRadTbnotr6g5JhznRaJwS85G5vVNvr3ixtVutCxQl
	heit9Ez8x60+8PyrreRjeHcFfpe7ScbqZTOCU8MXLkNNUSSjOLWjxKBvkaXaWvXEWN3bLA
	gnHpsQje4YfEXkeAAkViqIMF7gYL/qA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mSS/NLlM";
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110163; a=rsa-sha256;
	cv=none;
	b=rBZ6YmtAu7MRoziZcZV19SM5simAmiHg24dRI8mV2rKJUORv/ZROVh/kYSGh3We9IoFfMe
	kuRfe3FtkpU2Yi4n3S5cnL6wqiaRoxtVlV+u4m0/uyAZguDVHsMJLSUmui8Se8Y+ix5U8C
	hZRKVSAY9dAo7BDO+rHL+Q3Kxc7CyF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07B514349A;
	Thu, 22 Jan 2026 19:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A543C116D0;
	Thu, 22 Jan 2026 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769110161;
	bh=TRShzXRqgC1qMNEPnUKst+QX8fiXgfS27vWI+CFO9KM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mSS/NLlM2o05Lm/uZnfrOKAfF16LBgLUhq27+DlC/6LjrwmwZ9TBjOke0Pw4xv8L8
	 SFwEusrx9UFo95Jv+rPgnXlzaltukTdgWQqWkkQ3/+LmQTyWFKi9oP5y2d40FL0moY
	 91BiMqBSyenppI0G/Fwo7kTNH0SRxISMDzM9hzO8=
Date: Thu, 22 Jan 2026 11:29:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <longman@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v3] mm/mm_init: Don't cond_resched() in
 deferred_init_memmap_chunk() if called from deferred_grow_zone()
Message-Id: <20260122112920.2b435873a0cc5f396df5d1a7@linux-foundation.org>
In-Reply-To: <20260122184343.546627-1-longman@redhat.com>
References: <20260122184343.546627-1-longman@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 453F640011
X-Stat-Signature: xxec57z7uqpxrupfsothfyemk41caniq
X-Rspam-User: 
X-HE-Tag: 1769110163-458103
X-HE-Meta: U2FsdGVkX1+vdiMYoVmyHkjTuPNM4YhcQHqsbHyYFu6CCkY1TEo6nBhTw4oJM1Gff+6iH7tYUqLFUz6gKmrRgq4qivte8KATpqHqYsXmp9nKbBce9WRJy0dVTcxb6r4QnXq5HjRWxbUgTSVqgnmpZC0dq8+y/qEWsolWBNi1quY+xCCeJMnvTc3kQBrhlYMaajaZL3+A4aEDShOzcqVVEviysElz1gsGjWTBK0659hPpnnVGabGHR6TutkHXscg04L7dRwp62TyFoTMU/KezBf2+wRBzDrsyH9rgX2wLnYkqUSnhg08vm/m8w9dxzfE791GoOmQhDjJWtbNUius9W4BPDVaWxi6hn3cEXYLskY2X269gBlsFL4L4zKTlm+88tZ3aSM05MkAWfg6986BSphdtcLfDFG8VNRdCw+Za/jHR0LgqQ1Vt7XqrMle6hbVXwO7/IqHBOQuNZU0TgM5Dd2vFDxpFy60FrEFe6jTJ8HssdiZ8+DI3WJfcPCppR4Ed/7HnlHCRPUDBLkZh6fA0oxhFeWhsoOpNNNxAsgZZt+AxdlNf+qsRQAE0pjityqqdkC+kSPLnDAlExwRP45l6sq+4vZkectMPQMGxz6ELFzAuzsCIQ1FXZgv+cDbvl6z1zpq5vgo1+GHzgxJvIUGk2uxTPEpvqo29p55XxiOEgPkyXEoRzruN7C6WOWve0GpDlORpAc4EK0Bs8MzEZcD0qRS5EW84r4j6ju/yjzWVMPHN5t0QGcEdGBPpyMJuuxjuDd6857m3ycK2D854jNP955KU2rYUDaWSiS/GXKnIarwSeUBwBCKx2v/YZ5opAEKngsRC9xO+ClR4Q6iQ4/zL2w6FwmkFm4+z6ySriAJ6eq5amBKpPifbBOJ7xqL3k2Nfk1KWtTNusHsDzwV4r3S9ct/XPslBo+za0jt1GKSykR1cGqBUzTta6JeyqZVVS0amw1T9Pc6WnKqhc0z0DGc
 x4N3pXWQ
 5tU54Q//2elDKRZX7QEcqrOj+us1MlNbLO874mva4z3HAiZDcL1HiUPpw0Ns4okjAY0Bt0DtB1PI33t1TbkD8AA9+jmbfXTi8gtRG0BQ7PWYl2/NZ+yz4nWRGv5SyBMN49zInNElrIUvDVG7sJrga9sK8E4DL7NRgcZX5HODKGtF6Saq6wyIrnb54JaMhWeeK5ZPp83/7XfUnBsb+z8WJj2qx2GDHLJ5J0L9j1HudVrD2ijvBfjf+pGVLkwtBTE+RUgtDRnwLAe3XlT1WP28AYMGF5U9Urofad/yX9K8R+5rZEmF22g+Y2bJA+u5b6YjEFuPufQbnEgzbSUSPxaQsQ4gx8CBaK+wzQEt984am/pdlmRk5nxcE6g80jlyoX+tL3UxuwHNeCKTiatw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 13:43:43 -0500 Waiman Long <longman@redhat.com> wrote:

> Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
> in deferred_grow_zone()") made deferred_grow_zone() call
> deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
> section with irqs disabled.
>
> It did check for irqs_disabled() in
> deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
> PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
> interrupt but rcu_read_lock() is called. This leads to the following
> bug report.
> 
>   BUG: sleeping function called from invalid context at mm/mm_init.c:2091
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
>   preempt_count: 0, expected: 0
>
> @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  
>  			spfn = chunk_end;
>  
> -			if (irqs_disabled())
> -				touch_nmi_watchdog();
> -			else
> +			if (can_resched)
>  				cond_resched();
> +			else
> +				touch_nmi_watchdog();
>  		}
>  	}

Disables the cond_resched() in some situations.  Can this reintroduce
the watchdog warnings which that cond_resched() was intended to
prevent?

The cond_resched() was added by <dig, dig> da97f2d56bbd ("mm: call
cond_resched() from deferred_init_memmap()").

Pasha's 2020 patch replaced touch_nmi_watchdog() with cond_resched() to
prevent RCU stall warnings.  So I think the answer to my question is
yes, going back to touch_nmi_watchdog() could reintroduce those RCU
warnings.


