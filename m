Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6B2CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392AF6B0088; Thu, 21 May 2026 09:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D6E6B008A; Thu, 21 May 2026 09:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E42D6B008C; Thu, 21 May 2026 09:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4006B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:08:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABF4C120556
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:08:11 +0000 (UTC)
X-FDA: 84791455182.12.1D27427
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CBAAC0012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:08:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KDRIRh9/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779368890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kH75eGyD1Xxw3x8hVUBkXOxTI7M2wHXbhfDEg/PZvU0=;
	b=3ZTpdT+kdiOKIrY0ga8H/TruPQ62EIhudNZKG/crv2ZfWrKgGReOUlQXXdXctrOwlh/wN1
	HBqZNv17iTE2AzCKNugcZ7a6//ZrEtLxkXzwDkkJUHATQHZGn5spW2bYCoQ6wjSVfiuzsL
	VtUYsfuObNxiN4ge5gbEfwdjqOBKBWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779368890; a=rsa-sha256;
	cv=none;
	b=HGXRCGsn8EtKHVAaJuwfcHf+7rCrTA1p2AK6qcPbbouD4ZgfphAls9paAed48Q9vH1iZXD
	gdyzWmIDq4kHUgCBDiOnlQ/nvx/u/I4EgyIgyXL/EgT9N6xcT1NBBHJO5EEBP+t5n6w5Z3
	DqfIFm3ST9/VV2nWwooCXoFvBkUQxGY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KDRIRh9/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88B37601F4;
	Thu, 21 May 2026 13:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70641F000E9;
	Thu, 21 May 2026 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368889;
	bh=kH75eGyD1Xxw3x8hVUBkXOxTI7M2wHXbhfDEg/PZvU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDRIRh9/t7Eaoxi+32lpYT+KY+lDT8mnOj0w9M6PfXr8UQFsghRJ4OjwFrD1zpDk6
	 5rd09CyLvsNas3qNp3Hrrw2O6Myzkl/W9A0cjvPtPFWM7/vOKI4OHmbGQqH/FGbWtB
	 VKuXkaIg89b/WeQUoGkgvnz/AfXtUVO3RDeYPDna+vlUemvg8mV5QOFFnZ6XHtjEZz
	 /BVBXhkbU2GIHMNM5AJsjY4/asCV40jpmA1tiBKsTPV5GSqWtfIfvYV2n/KZA1IrSO
	 sevxYU6o80r1tGiWam1srstdPVEIsb+OC9bMctGYuGUHTGNbrIJKuXnz4Irkwv8aUJ
	 jQATNAhX+gtYQ==
Date: Thu, 21 May 2026 15:08:03 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 4/4] exec_state: relocate dumpable information
Message-ID: <20260521-atemnot-unappetitlich-03e445ed1015@brauner>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-4-69f895bc1385@kernel.org>
 <CAG48ez3Fd=4hoc=zt77paKxjpSnuf2ESVho6WSH47M1t3Cg5GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3Fd=4hoc=zt77paKxjpSnuf2ESVho6WSH47M1t3Cg5GA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CBAAC0012
X-Stat-Signature: s8ojr8qw5kwa3kihug57bw8chq5syo3q
X-Rspamd-Server: rspam06
X-HE-Tag: 1779368889-155433
X-HE-Meta: U2FsdGVkX19mDoNo6DsIJo+xgqm4AFjVafFGqDdetrzvHVN9zlKzDlnWZxRK4KsaOm5dE4mj9czye4WvTHb5K/X78Z5kQyogBE0bEODUaeq17cHeGoA+M+WcBEh3nGnmqVGkW3urf5OT5DnWPi4H3cZ/gG1r17mECq7FOIG/MDUgO/kJPhXoxhP5BIclQa5pkJgaeSr3op9KO84du5HYrnXUB6733TL15UnOvCTfV4R2MmE/++Q307Wqhy6Upt1N+oy/BwcWMPVe4LK7qjvYqbZQEqsY0IXZFVJhcen1b9UeUhPhQ/OpOK5GxNeUy89CoTJwjKHMvQ83BY6TgbBJkB1glqbV9b6q6YB2Rlx48LXlR/8bFHlXgPouu2t6Ib00yCfOwf9BgTrS7kS8hPpoe96OxemEfzbjrLvpyEhKMgnaUap7AQV+Eb3sHTCxHc/Ji42vcIU81ZpBhWvmgeeYpViyhAkZ4/6phOuj5srqkSJ28X0iwEC2Z1uAyCPNtcZOnuqZIsJK7YpeFM4Lq+7HepYEJSaVYnVVNHduEcphQHDaBCiDxg+ao4oRq6ALvj1Z1BVyh68+YbSgccVKU3RWDgmhR74j0a1oL8wya8sb+LGnDUA5P9XtFBUheCxulLV/H7cZoqnap4dDs+U4KJKNOEmweeaht4peY8sbpDvoan4XR3M88BOvWzB7am1BCFdVUCTfSFv5ATw17ZFOVgtGv7MX/Qhs2HDPl8CWjHKzKGnwR+Ih6LAZqw7zmMZiHp0lhdYPVODVf7ekFcpT5H3LfZQHFzp/JULejORh4tn14wc/EOY6mbc2wJfTzTpui+veV/cM5yxgaa/9tgdaCzLf+wXCjEYORvsvyxbIupMYJn/XizM5bJVDRDktEPle3+pZDSad3UOhNOhoAHaPAXPjMdEJy/JGY02kYIZ3X2O+C/O3uQUUO+nP210gnXNJjxVu07A0iPys70bHgBpDtbw
 2sbLD6K6
 GymCQC+2qj5bqFMHndMg94YDFHJKTh0agQDUsXcgeUyPeajVbuX3Du+5pIUKbKuFEPH5LrvQlFyfac7o/XdV3e75jvCJ+5yoHSIFh6zaoQ4+rUt0anXZSYwoQtqiqxyIqTvpuJRMJ0Dw9KpIM8DT7lE/nVuh8YPGDsXrJOPz5hd34gS5tE46NWc0K+oYxIQWAkLjxnr9qCjzh+uziYOnJYhu0ixFq4yhEoVTQuAYxsQo/y41/UypQxFLGIwHSzVtkySzCADFfA4ZRCMxWbHEthr/ybrZCVmMvoTw3m0YOkviFiobDPUJv8isiP40qPykGcE19PHc6qOSHn5xh1i0yNg1/W0PPiyhplCHpmeFyQGRw95GgX/bjTLBacpxl1A4bz5JI/tn97feAPQZohIchytskDfH13tFD1rRi50P0/RfVbtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:16:23PM +0200, Jann Horn wrote:
> On Wed, May 20, 2026 at 11:49 PM Christian Brauner (Amutable)
> <brauner@kernel.org> wrote:
> > @@ -2090,6 +2106,9 @@ __latent_entropy struct task_struct *copy_process(
> >         p = dup_task_struct(current, node);
> >         if (!p)
> >                 goto fork_out;
> > +       retval = copy_exec_state(clone_flags, p);
> > +       if (retval)
> > +               goto bad_fork_free;
> 
> AFAICS for state like this that is torn down in free_task(), normally
> dup_task_struct() NULLs out pointers that require refcounting, and
> then copy_process() initializes them properly, so that in
> copy_process() we can bail out in the middle and have the task_struct
> in a sufficiently clean state to go through more or less the normal
> free_task() path.
> 
> In particular, I'm thinking of the handling of tsk->seccomp.filter -
> dup_task_struct() sets `tsk->seccomp.filter = NULL`, and later
> copy_process() calls copy_seccomp().
> 
> With your implementation, the error handling would break if anyone
> tried to add another bailout between dup_task_struct() and
> copy_exec_state().

I folded:

diff --git a/kernel/fork.c b/kernel/fork.c
index 61a44b33da28..91545ed6463f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -947,6 +947,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
        tsk->seccomp.filter = NULL;
 #endif

+       RCU_INIT_POINTER(tsk->exec_state, NULL);
+
        setup_thread_stack(tsk, orig);
        clear_user_return_notifier(tsk);
        clear_tsk_need_resched(tsk);
@@ -1594,19 +1596,18 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)

 static int copy_exec_state(u64 clone_flags, struct task_struct *tsk)
 {
-       int ret;
        struct task_exec_state *exec_state;

-       exec_state = rcu_access_pointer(tsk->exec_state);
+       /* CLONE_VM siblings refcount-share the parent's exec_state. */
        if (clone_flags & CLONE_VM) {
+               exec_state = rcu_dereference_protected(current->exec_state, true);
                refcount_inc(&exec_state->count);
+               rcu_assign_pointer(tsk->exec_state, exec_state);
                return 0;
        }

-       ret = task_exec_state_copy(tsk);
-       if (ret)
-               RCU_INIT_POINTER(tsk->exec_state, NULL);
-       return ret;
+       /* Everyone else inherits a fresh copy. */
+       return task_exec_state_copy(tsk);
 }

> 
> (Sidenote: Ugh, the way dup_task_struct() just copies the entire
> task_struct is so ugly...)

Yes, I agree.

