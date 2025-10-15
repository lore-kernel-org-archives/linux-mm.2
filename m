Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D94BCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2008E008F; Wed, 15 Oct 2025 15:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99748E0005; Wed, 15 Oct 2025 15:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5C28E008F; Wed, 15 Oct 2025 15:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC0E8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:27:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0492C160299
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:27:22 +0000 (UTC)
X-FDA: 84001332366.20.FE5D0C6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 45C484000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:27:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Xh+i9IUV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uxd0icnL;
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760556441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWtiYUPlnQw9OtpmC0sdUUXx3SYzXSM1Q0xsiYsFZNo=;
	b=yQzlCblJjzqicZdRFjvLvMzg7nbF6fmtPWsDODJ4tFga4FpGfexKtP8AutXk/k+op9mDfs
	nj3KPSOPTFtxJDznVIZNWugTe3IYS5TpBPTSIQZq93kRQC7KrVDqaW9uw8wBLeZ+BjsbGx
	auCY01R6/aXpY8g3Fq5PPc1FQCLMlZk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Xh+i9IUV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uxd0icnL;
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760556441; a=rsa-sha256;
	cv=none;
	b=LEE8haI0j62NRTAuy/xjzg858dticoUeyV7+0HZdT7KbWzg6vIOSdIwEoEiiRT/0lJxm0s
	2UZ2qPyFYIHJS78ESpgTiK+Ansxm6PHTmtIkq5Al3DRIjHE1dz94vs3o+DZhfnAhrJLWLn
	oVcyNKHJPFXA1TisqWOnf+cNMnjOlPQ=
Date: Wed, 15 Oct 2025 21:27:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1760556438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GWtiYUPlnQw9OtpmC0sdUUXx3SYzXSM1Q0xsiYsFZNo=;
	b=Xh+i9IUVqRb3vPqw82EPo4YL+Si/vG4jdJ39jG480GAqiXK/6Iw/zC+FHSJ1b00Tcc8Qhf
	z9DClQzxp8L5Vnn1AOxJKiMQkMPcG5jSYMlbi4eSbRfdzmYyU5V+ddaHev3z9nMGCl2Jm8
	pdjJXBlTwhtljL+6ozc0MIossZcAPwRkkDqrQc9EJtF/DqEXLokwYtGrrH6mgffKDK2F3s
	ANt7WHWyvkf9TpSUbjn98qhhFB674qCrPiU4N1apS/jMmvezTOeGTg60dbDAUPoyqv7LGf
	Pue1VsbiK7FAk6qrFdnytHdyUlO5FVTT1vTrmXucB6FBH/V5sgz3ZRsxkSLlew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1760556438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GWtiYUPlnQw9OtpmC0sdUUXx3SYzXSM1Q0xsiYsFZNo=;
	b=uxd0icnLjLD+M6AEofEoOm/uV3l3o88dWkR6JQyvg4e5o1D3QzonjA3gi85qdBfxwhk2pK
	pXHx4lbAX4YOBVCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
Message-ID: <20251015192717.HvwzCChE@linutronix.de>
References: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
 <aO_taH9CKxmJPnhV@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aO_taH9CKxmJPnhV@fedora>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45C484000F
X-Stat-Signature: yiqjd4obb6bjaory7n3p9ojsb3ox53jz
X-Rspam-User: 
X-HE-Tag: 1760556441-341930
X-HE-Meta: U2FsdGVkX18+Tr3vYUR3ZKWFQNbKBFVXKMjjd4//eIQP+nvMLZGiOOr3Q/UfWKK7KFdtbAJXkEl1GC+dRSTogcGxR2liILVnNkQZRRlAuTAsjBeBVSynAY8/4zS/fsLtOKvNzQ6tKizTNhuSMd3d5Xad9eyiod+Al7/W/b1GZ18skgL0RnuVd3l8CkJ/BvH7DCHl1J6ds287Z/eIah956GghyrrWL1qIptfSK7W1ct3s9MRw15pxwp0dQW11ua7NpLtSV04t1e1Ux5hclE7faEpqHb19PvviJMuIk4AX+9gS3uXJnTOHasVk++UtVoXvn0L99SO8PZNqLTxObsEaqAUkjz7+iibpp3Z2fECvgmutFioat86yUCGvqpWNS+/0i9nkPWcqPQFoQ2pApxEunXIqXQA0WG6FI4NJBsOASTm7V5nmftrsAvDcM8DAwSPNGaECdjuxL1n85lKGlm/HTsZKbLHuyqArUQU0S9MVWbixrfEGmvsf2XzI3jY4uFYjW5DDix9fXDd0kd0gJ71ZzbLqrZGAMMk69ZxuM911HQGZB4ZijL9DmDm7pk3646DFXRQmrhXH7bQgnEic4MF821Zxkjk6TAyLqKzmc5BlePFoAsVSd+qe1Y5cIDdCM5GqgeNVGw7gcYvqXdOMXZQqWB3cd0KHcyIjKfO9dhMrX2Qa5AJGCelM+64Gh9HEjJ8GKGMl6cXmkiB+HtzD/nshtAlwByHp62perN/IOcNzkD1Axcyw74Fp9wm/BbvgcwNsLx4WKeN3ngLaAqtXMVhK3juayL0+SR1Q3+r5qSkUbi0U8/HkC85dALjixZcyD3GiDmW8Ebi4u2nTHmu0/cCbpLykRvPueSbS6ibuLJmLYoECDgfeCj72ixuxAelQZrvYx7H/JrQTT+UJGxxd5yPHyGkxIRi4jbDko3HQ03gzPiiLREfb87PDqSHACiebfCqtbi7eA0ICWs+NAtID+IL
 o/oBOSby
 PWzHXmNd3MpPTWhgPQZW1tvurfrWmxn5oHTY5XDosfRl0gtMNi+ARnKTD0/lcklcIYH07AtKEY9/qJmGkcXEGHmQc65m9j7gdXNcqMUEjPG5zGO7FOkp3c+bIBXM+5GJ45ntAdt7vqzdRDb3Ar2HrCHHt/pZhYIagCTS33xzMqS1VL60JE0PBeX8nKX0XWrCqe9Fof+L/uR5Wa/YSaxNmHzDkCZ/SnBt9AL/V6LCKbsG4iN+4DZWdhmWyc9af94PACNPuoOPgrlW6NbUoR4AaYVrAruF2eX4oz+xF9Lk364UlCarCFxidyxmB8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-15 11:52:24 [-0700], Vishal Moola (Oracle) wrote:
> > --- a/mm/mempool.c
> > +++ b/mm/mempool.c
> > @@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
> >   *             mempool_create().
> >   *
> >   * This function is similar to mempool_alloc, but it only attempts allocating
> > - * an element from the preallocated elements. It does not sleep and immediately
> > - * returns if no preallocated elements are available.
> > + * an element from the preallocated elements. It only takes a single spinlock_t
> 
> Might it make more sense to say "It may sleep" instead of "takes a
> single spinlock_t"?

May sleep usually refers to something that can not be used in an
interrupt handler.

> I feel like the fact that we take a spinlock isn't the important part
> here (especially because we always drop it before returning).
It actually is. A spinlock_t can not be acquired in hardirq context or
when interrupts are explicitly disabled via local_irq_disable().
Therefore you should use the function in a local_irq_disable() section.

Sebastian

