Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490F9FEC0EA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 17:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C3F6B0005; Tue, 24 Mar 2026 13:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D746B0088; Tue, 24 Mar 2026 13:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A376B008A; Tue, 24 Mar 2026 13:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3800B6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:44:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE49413A7A3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:44:23 +0000 (UTC)
X-FDA: 84581680806.12.1A716D2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C6C410000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:44:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bTYHRtBq;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bTYHRtBq;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774374262; a=rsa-sha256;
	cv=none;
	b=TSpjy5PxkMu/1hF32bOXAmE+OyqdAtSTI8hlaPQ6D9aftpn1GWNrM2TTsKDf/8pMZBC/Rz
	CEZAyFCvj1zocH0h5bq5Dv3rnOg8Dh6QoWFJ8cd8iiY7AwtZo+1yqXJdM4TVwapxi4lTEl
	DVn5mZ4XCKxQQlYgo8yqWJPyRroXPOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774374262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W085LUSAi9mVXxNSZ1ANPdA+9qLKpFq/9UOGT2qvriI=;
	b=UKn/ohVVHDYMR9wshf7ykL7zSshV05DYSnG+xu7NgbDQk7I+/HKnMBJazcT9QANaJ2JnK4
	l6tnS7/cKoyj3PrmkcrURlz0IOUjmpHnPIhJIhe3Qn9IkEwJjHrH16Xn489x0rnfcPBwJg
	uFovYvYii5SBnSznAZdSdbLOEAzHnCs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W085LUSAi9mVXxNSZ1ANPdA+9qLKpFq/9UOGT2qvriI=; b=bTYHRtBqlKsXaeVMwCCnHZi+mE
	oHqXXubk3u4IlvBuPJAvrdC0XXH5IzQULbQ3WvyY1GE89qPJzBJ5t61sZ6mKKD5SnI8LqQ1NsjyL+
	m6o5Dq/a9ygDxuDgWaedZ0JBxmn5A03RmT0xqcwlL6m3FJ2fx/ayzKOFurtgXbkJMXvItSi3YQWJ6
	f0ynHhQMsLr2T/2gyjW1K62xPGC/8PbuKH9Cz5SsA6HSk7kJOdtarcp+nmUqjHg4KlwaXMiIlHuHG
	+9c14O4O9zx/bcohC8hsfEvS0bzPQZ5bWjHmIeMXkWxnx+t0SSa+2hv47SaKR8meqMuFxdfUwKUgr
	2TJMohxw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w55nf-0000000EOYl-0JX3;
	Tue, 24 Mar 2026 17:44:19 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8C3E73002D8; Tue, 24 Mar 2026 18:44:18 +0100 (CET)
Date: Tue, 24 Mar 2026 18:44:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hillenbrand <david@kernel.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fr5pgp5x.ffs@tglx>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C6C410000B
X-Stat-Signature: xgizk8a7yfb7key8sp7mnozm4gs1796y
X-Rspam-User: 
X-HE-Tag: 1774374260-365393
X-HE-Meta: U2FsdGVkX19UXu9zeMj+M/UTjrm9PImlshZI/qGRzpuoznhwuw7WoOZBd7IFWu6v9CgaPlGQurQms18DLthFLMPdqK86tA6F6fPuQvtKUnTufXi2y6NxaUzhcyzkTbLRr1sa1Q0g9BoWVTLukqzuAbmr31eGGB6+tPt4kTyLaFZVJku9wHFSnmvwojuu7ZOfA7I/oXUmQmE4kDp/wliuhBy7nLtsrxI3KRu5t6iqEQk2IUGUGD8sdFQw1JXKRpF6lsZENABjhUtDLUvFt3DcDnYGu1ycumZCkCJZuVUpB48yc4+GPNeu9Xy7CCNdxgQNgaO3zBk4hVFe2eQ8QkUfe8yrH70kf+CQ8IrHukDhLYAHt4bN8eia3STf3DWdISdq7jJLnFJfdW38mqMWYWtIgJsuDH14NYAEHZ/Zm4WJlCVg9g/cGMf+7xctrraJ+BD4NEuYecXEA6wKnw+ue5nvtXCL5tu8yFJdFGoLGvDPgfwcIhFB95iP0iNJBsMuZ8gX4o+syH76X2VchrGarhlxD/mg4i+OpmVMyphaxoU8BxYbSPtEzfwUIuIQ790EcvGfARA3rUxFpRfXuiyqSptrH3GRbgjb+T84WlmmLwO14F1TF+OgwUSsW7BrAsWZfHZ7H3Z5NHYy+qdX+/N3dpjGbWtSNT1ov2COt6JlDL8BT1esAdYD6Hu34qtcgoo4TtCGFj7KI5Qq2H8MbdUdWsjLnWAj9/d36poF35IBae/cJQnzJZs/1CQP7oLWx1SOdC2om3RHHyhyZrz+jrB/CHpu1dPb/Zw0Njx211zHdyrv0M/BABWvOPsyzsaea52806ii7WlzosJNW0z/DLGazBm4cHuRKFf21UX/IWU5gbsQXxsCm8/NNP1BYF4YPYhh35S7jaubI9zli4A9E1HY/z7/wJZNEewozttZ5L3mqm6s4JyudK5JAv4NnGcalEjwJExbMfPSsQ8YxYsL5ompKSw
 OlenIuPh
 eej8nbkhrmRaP4cflCwJ3u5/NQ0XCCrbnwoA9v5SPUwxoWxFmCDXPU03WlmXgef20VvpFmrUhNIhw0eVnNzJ5KmIiiirt2I61CYJnOjaA5BU1OIpYTqkZA5iukxiiZONCnbwy7p7nYmjD9kFVa/GdFyw0wAHskXY2l6dHl7pIIrCnI04pxhbXpOVE5MsINMBSQW6LzyGAxNe/yF4y82izyzSaGm9yfK9axZd45aAxoE8cbfx8fACZ3bInWwhoyOMAwsn8QyFTm3tKO5gVMwTYPLRXDgHbTp9JTnpD5daI2TH77bAihPpVp+u28EaL3Y2GsnoUA2Z6T/4oqx+DaDQ3EcQeeOKymkHvPvxo2Bghp+cUDys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 05:36:42PM +0100, Thomas Gleixner wrote:
> On Tue, Mar 24 2026 at 15:00, Peter Zijlstra wrote:
> > On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
> > Not to mention we don't actually need any of that here, because:
> >
> >> Especially the writer side is required so that the proper memory
> >> barriers are inserted for architectures with a weakly ordered memory
> >> model.
> >
> > The vma->vm_policy thing is written under mmap_lock held for writing,
> > and the futex consumer is a speculative read lock. Specifically the
> > ordering is through the associated seqcount.
> 
> Duh. Yes.
> 
> > All that is really needed is to extend the lifetime of the mpol to the
> > associated RCU period. Which is exactly what this patch does.
> >
> > Want me to go write up a better Changelog?
> 
> And a comment in the code explaining the RCU magic perhaps?

Does this work for you?

---
Subject: futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()
From: Hao-Yu Yang <naup96721@gmail.com>
Date: Fri, 13 Mar 2026 20:47:56 +0800

From: Hao-Yu Yang <naup96721@gmail.com>

During futex_key_to_node_opt() execution, vma->vm_policy is read under
speculative mmap lock and RCU. Concurrently, mbind() may call
vma_replace_policy() which frees the old mempolicy immediately via
kmem_cache_free().

This creates a race where __futex_key_to_node() dereferences a freed
mempolicy pointer, causing a use-after-free read of mpol->mode.

[  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
[  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87

[  151.415969] Call Trace:

[  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
[  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
[  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)

Fix by adding rcu to __mpol_put().

Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -55,6 +55,7 @@ struct mempolicy {
 		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
 		nodemask_t user_nodemask;	/* nodemask passed by user */
 	} w;
+	struct rcu_head rcu;
 };
 
 /*
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -487,7 +487,13 @@ void __mpol_put(struct mempolicy *pol)
 {
 	if (!atomic_dec_and_test(&pol->refcnt))
 		return;
-	kmem_cache_free(policy_cache, pol);
+	/*
+	 * Required to allow mmap_lock_speculative*() access, see for example
+	 * futex_key_to_node_opt(). All accesses are serialized by mmap_lock,
+	 * however the speculative lock section unbound by the normal lock
+	 * boundaries, requiring RCU freeing.
+	 */
+	kfree_rcu(pol, rcu);
 }
 EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
 

