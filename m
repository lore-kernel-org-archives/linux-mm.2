Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92490C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 01:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE13A6B0088; Mon, 14 Sep 2026 21:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92F06B008C; Mon, 14 Sep 2026 21:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D875D6B0092; Mon, 14 Sep 2026 21:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0C2F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:40:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C06FA1402EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:40:42 +0000 (UTC)
X-FDA: 85214292324.13.1A0198F
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41FF4A0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:40:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xG6JBmrM;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789436441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63+GqYE4DQfR0Bx5ZSWXPstN8CpGM93K7KKkieJ+w5k=;
	b=ml0wNn7QTNqSiRD7FwwhHf9/ZBV6EAz7aw0D9qipg2FNIOPDxudtVZVXQb2Y6MX5Q2Idjr
	qp5Bj3ypkxiFDOr8DUJoQ9ic7S9ckhMO51xxQrGqV5At7TcvtfiVTfeH4Onpwc4hPE7U4p
	ERXQak9WIMdiz4R0RXcnh5+FbG6PAWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789436441;
	b=TlLv9KfZWmSxVxyBwYRFL2Kyvry8QUOWdq/kMTmnmWu5+mVvtirN5ixJvDhVWigAD0VDNi
	qWSHW47sKcjndAPDOquVA/VbwRq37yaxGqMADBCFU5RS3AvkksB46UVGlgcWGVl+O3UGdj
	h5zsZflwuuHo9zYLNMIwW+pxul9/u3A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xG6JBmrM;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=05uRaWUcaOG/Q/CWJc/l3BnefdP/MWiBuuzMMUHj9ko=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789436438; v=1; x=1790041238;
 b=xG6JBmrMklm9hb4prYYVKhT91g9W8p/yh24RxHsUyes/Efqo68xd1mIPhyqat/8RSxqSv/gB
 RBzYZxWBJ8naglS9uPzcsXgY9qTEsqov1G6p0D1Yw2BecHxXJR8FtaGkDtyXLoXF/WgkbYgMtNO
 YSq0O1Hd8W6GLCpIN8A10vCg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 98afbac615a21c5e;
	Tue, 15 Sep 2026 01:40:38 +0000
X-Mizu-Trace-ID: 98afbac615a21c5e
X-Migadu-Flow: FLOW_OUT
Date: Mon, 14 Sep 2026 18:40:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v10 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-ID: <aqihfvKMqJAudSQK@linux.dev>
References: <cover.1789091855.git.zhuhui@kylinos.cn>
 <e00910f328c129fea716e9fd031dada328e60313.1789091855.git.zhuhui@kylinos.cn>
 <DLF8UFBL6NEL.MAD9F5418DIG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLF8UFBL6NEL.MAD9F5418DIG@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n3xgdm94zrdrimnwomckyxhrchnfe6n3
X-Rspamd-Queue-Id: 41FF4A0005
X-HE-Tag: 1789436440-600478
X-HE-Meta: U2FsdGVkX1+edK4jSKxyCM6fF85qnZTW0pETfmRgIJdCrR+ERBE9sJaumL2dEyRE7Oc6dtoWfH6REBaApT1pP064Qnwk79cfchQEv1oPxY3lLTlK9P/+p5ckCgB2WdYOaId4DVlcL8il1LGg0hFxvqvTYRG0Ygm+64/rbSoQaJ0YAB6QilBx8DzhI5KctOnq8xs6bIV4HubdGvj6+ph/mCT7bRNvCVR2PC0yy0RBksrDD5Un2sE1jmtdgr3zcgm0Ge00s2VgHINC2ZVJRWzvvWt84/Uyqs0ZaJVcUZic1t2UiS0cCmfeUSWSN1PCHZxkiC+Lbjl8vON/3MZJL13waNxyPBLCjQUrgLXYb6tk2jqrQTeqwdA8Vcj2/lY6Fl7jIVy41UWBj7aPvEl+ECRHtxQHTN9ukOaWAhWh+ilK21D1e/3ef4tpZAy+BAPOmbvpQgcxPohHDXKNDQPbp3UAl1vWMRnRkB4W0CT6ppUkC2EJCRSmXd4I0DYUftvmvD7p/418L9CKgzQdzBXK/NcM9RbHpXTwbBagOxMsuf45frNGIcoomqDXOj1vf/jzwN4xN9e0r0rY9+FDvX9KqGH9Pc+iB43AJtC3E2dl2JAS7Otu9sphkoxD5tBUsBFks0JatW5MeEisG0hHJ9mJx8imB5qu4Yq24p/I4aUnkXouOK1Hxz6UzSt+GCl3emP/wQDBLf3789OHQE6f775MgZg02KKAgYH0p1HVQG8O9dfDqoNRJku1BrmiuEVT2BobQUR1pMFOr/goolRgVaqlP7ho8PCgh0l/s9/UInNaw0mmg6fZc5vvNh4D4GBTgMDUpv9q6BN+/e0o4lZXpx2pjcI84DmVLst9USfolY0LjLYMjIIrfGU25HJz3RXHoKa1xtWk73J3duEs2FO1qbGyhAZrPM5wGLTW4j67o3P5Y8VppEc7xoYjjjgyj2SCrtPKLO99j6M8NhwV/Tcd/LPlsuf
 dPHBMDqs
 bYcL33As/F06CJOXLmpJyZ6BRo1vgy84iTAJTMmc4jtxckMvWJ3o9Tou9Cy73eo32JHb7d5xSCQuA6eigb9gta+dTBkXT/YdqVf8CJ2YCxFEnLgFOKHFr8AGfVgIWst510pOWbQIvv/EOngVn+/gqtYKumbV7SfG9s/Ftq81K4qvlYoTVCOjwWcZ+jDfhE16uT1CJaJ/6MgbsjdMoSVm4rL/MYtSo3vJ7cy5+M6YxwSE2D58I+drTPb1sGi8LDg2nWuB/QNC77sZIkfqiZjt8hLBamhvpYrcIFzzi+F+4n2JMxez+SYG3ydV9fvrRxTPSZMaN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 08:17:09PM +0200, Kumar Kartikeya Dwivedi wrote:
> On Fri Sep 11, 2026 at 4:20 AM CEST, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > BPF programs can observe memory pressure on a cgroup (e.g. refault
> > stats via bpf_mem_cgroup_page_state()), but cannot act on it:
> > triggering reclaim on a chosen cgroup requires writing to
> > memory.reclaim, which BPF cannot do. Add bpf_proactive_reclaim(),
> > a sleepable kfunc which performs one proactive reclaim pass on a
> > given memory cgroup, similar to a write to memory.reclaim but
> > without retrying until the target is reached, so that when and how
> > hard to reclaim is BPF policy rather than hard-coded thresholds.
> >
> > Since some bpf program types may be invoked while holding fs locks,
> > limit the kfunc to BPF_PROG_TYPE_SYSCALL only, to avoid deadlocking
> > in filesystem shrinkers on the reclaim path. A SYSCALL program can
> > invoke the kfunc directly, or asynchronously from its bpf_wq or
> > task_work callbacks, which run in process context and keep the
> > SYSCALL program type.
> >
> > The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> > following the precedent of high_work_func(), the memory.high
> > workqueue fallback. Note that only the reclaim target is capped: the
> > actual scanning work and its duration are not bounded. Reclaiming more
> > than one batch is left to the BPF program rather than enforced by the
> > kfunc: with one call per bpf_wq callback and the same work item
> > requeued for the next batch, the program can also stop submitting
> > batches in between, e.g. once the target cgroup is dying.
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> >  mm/bpf_memcontrol.c | 88 ++++++++++++++++++++++++++++++++++++++++++++-
> >  mm/internal.h       | 10 +++---
> >  2 files changed, 93 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > index 716df49d7647..d8827bc388ef 100644
> > --- a/mm/bpf_memcontrol.c
> > +++ b/mm/bpf_memcontrol.c
> > @@ -8,6 +8,8 @@
> >  #include <linux/memcontrol.h>
> >  #include <linux/bpf.h>
> >
> > +#include "internal.h"
> > +
> >  __bpf_kfunc_start_defs();
> >
> >  /**
> > @@ -159,6 +161,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >  	mem_cgroup_flush_stats(memcg);
> >  }
> >
> > +/**
> > + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> > + *                         cgroup
> > + * @memcg: the target memory cgroup to reclaim from
> > + * @size:  the amount of memory to reclaim, in bytes, clamped to
> > + *         MEMCG_CHARGE_BATCH (64 pages)
> > + * @swappiness: the reclaim swappiness, in the range
> > + *         [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY], where
> > + *         SWAPPINESS_ANON_ONLY means anon-only reclaim, or -1 to use
> > + *         the memcg's own swappiness
> > + *
> > + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> > + * memory.reclaim, but without retrying until @size is reached.
> > + *
> > + * Only the reclaim target is capped: @size is clamped to
> > + * MEMCG_CHARGE_BATCH, following the precedent of high_work_func(),
> > + * the memory.high workqueue fallback, which bounds each reclaim
> > + * request the same way. The actual scanning work and its duration
> > + * are not bounded. To reclaim more, call this kfunc repeatedly
> > + * instead of passing a larger @size.
> > + *
> > + * The kfunc can be called directly from a BPF_PROG_TYPE_SYSCALL
> > + * program, synchronously in the context of the thread running the
> > + * program, or from the bpf_wq and task_work callbacks of a SYSCALL
> > + * program, which run in process context and keep the SYSCALL program
> > + * type. It is registered for BPF_PROG_TYPE_SYSCALL only, because
> > + * generic sleepable programs may run with filesystem locks held or
> > + * in NOFS/NOIO contexts, where the reclaim path could deadlock on
> > + * those locks via filesystem shrinkers.
> > + *
> > + * For asynchronous reclaim of more than one batch, driving the
> > + * reclaim from a bpf_wq callback is recommended: call this kfunc
> > + * once per callback and requeue the same work item for the next
> > + * batch, instead of looping inside the callback and monopolizing a
> > + * workqueue worker, and give each target memcg its own work item,
> > + * as high_work_func() does with one work item per memcg. Whether
> > + * to submit the next batch is up to the BPF program, which can stop
> > + * at any point, e.g. once the target cgroup is dying.
> > + *
> > + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> > + * smaller than a page, or (unsigned long)-1 if @swappiness is out of
> > + * range.
> > + */
> > +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> > +						unsigned long size,
> > +						int swappiness)
> 
> I'm going to have to request one final change, sorry.
> 
> I think long is more meaningful as return value than unsigned long. It's already
> restricted to MEMCG_CHARGE_BATCH. We return error for various arguments, we
> should probably change to -EINVAL.
> 
> Apart from that it looks ok to me, but please, also wait for Shakeel to review
> the set before you respin v11.

My only feedback is: please don't write essays in the comments. Just couple of
sentences should be sufficient. (Please ask your AI to be very very concise for
the comments and commit messages.)

Other than that please follow Kumar's suggestion and send the next version.

