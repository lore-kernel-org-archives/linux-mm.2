Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B40C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBE96B0088; Fri, 25 Sep 2026 00:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55C36B008A; Fri, 25 Sep 2026 00:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DEA6B008C; Fri, 25 Sep 2026 00:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 812006B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:12:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C976E404D1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:12:47 +0000 (UTC)
X-FDA: 85250963574.27.CBFA12A
Received: from mail-pz2-f32.google.com (mail-pz2-f32.google.com [74.125.228.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07782180003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:12:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kUgdwyG5;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.32 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790309566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4MGTQQsIFwRWN5LVLl2bLnymyqR90tzlWdPdS9c0zU=;
	b=pVCpiIJ42uEU4tpzKeHZTimUjogVfD1SxV6R4t3LMg0xo6R7l1UnMlCkcMQZ/6s8XxNtsm
	DiDh296aV24AhsFO+xC2R4nmxZL0ccco7aQdTFOfUZ1kcCRTiaHz8+xcymqopnWSL9MCYW
	otfzxWLSYJhtTNCqD8ewRGTNvRYjC/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790309566;
	b=ddGQ7SaYLjk50b8IXoUVpLfxQIsorLlrzHOtvQiqBsmXZnVRuCgCdDSDFz/llMNiwYPlJn
	XBLhWeP5GpDIxScxiFJVBlSQRfTlmG6KwvKZ3z5vne1fLyD+T5IM2rFypIYOMe1VdsR6Qg
	hGbHQXHR/AOkac8qGC2GQ2shsOGVtE0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kUgdwyG5;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.228.32 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f32.google.com with SMTP id 41be03b00d2f7-cc4d04d73b8so141353a12.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790309565; x=1790914365; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U4MGTQQsIFwRWN5LVLl2bLnymyqR90tzlWdPdS9c0zU=;
        b=kUgdwyG51jg6+QZZDnba2EYU1wFCcYtWQd6OkoqEkNN8UBEMw5yPRL8vauciWbl2U2
         v0Ob5Bz6mg1QzSCaYxJQDM8nVIxLDp6IPtCnZ6aBOPZPEtGRtRXYe0VUbNi3Fu4AhMaM
         TwkINsD4/pU/NiuQ7mhXACE2xGdclKC1EnUrzF/7TMZXaMY8nrt2ldtb/7kvioj2C8N5
         lSqp9dm39vEd1Q+TrX6JEw5yZppdOmWMAZVplOeOSlMoubO/MifyP9McV2bDiuy3LXog
         soNrl2tPQ/4q+W2A1k5Pgjsv6+nCwRLDXy//uHFeo0PZvJ1f6a+qGLx1rbm3H7zJTMdY
         BUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790309565; x=1790914365;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U4MGTQQsIFwRWN5LVLl2bLnymyqR90tzlWdPdS9c0zU=;
        b=DL6otv5SlVkd7wHrR18YH/8E+6zCZYGZlgq18kM41mbOyAflBTzrIPy2tTYqKhaLcG
         6BUuj3+uaiDLOY8721d+PS+BudZi+Zf3pRq2GjQ8+bnbPa2amiucuKbN6A/zyeliXfGE
         g8KqbV0baki4/qh7GOeAZx/dw9EmNvOlJISkoXdlXkYrMzBx33jEYtyFzyPLJh7VQKjQ
         XNHL1qKKfS4P5zQlZjFrv3w4SQT6mgwrTXnmlmY2LCK2p9XXzhXzIzdvEFcYvLuO8PqR
         ikSLvuD/RvYJ1uyzTbMJ0srtMJVOAPhO+lPYdNHKV+xv6urrvb80OtGAhh3EZJH1+6in
         mgWw==
X-Forwarded-Encrypted: i=1; AKwUvBy0GGDUC6g+DvGlKZiIy/8rV3smdZk8EVJC9xLQ5aekk6cwpXCA48m5Ptpu57vfgrLCXGvBQ4ItOQ==@kvack.org
X-Gm-Message-State: AFuF++kvTVF/O55K2x9lt3Lk1b7lQ7QUOIZ2YOFPYrb+q+WxbiwY2ixe
	AV/cXN963FI9cVagE/QvZNAxB1EB80Q4Mc/era+w071hyz7sRDqbAUA/
X-Gm-Gg: AYBFou2vFYcSXFw9Rsj8us/K91Tmm4K9v1h+OJbATGT5CIGFxZDCA1BgTl6uIBoSWId
	hFJkx8uPYiUvywtk53U9KRqE0HKS8F53INScXTRv1GFUrpEWOT1an0ULtFVeF7sQvLIgoMKnvs8
	4ogYaXjHrA6xU2ftaxA0la91SEwwApQVh63+jXxUdg3TOLfuO4ydnjcxdNpF2YfC5H6og61PQgk
	zebVhzrF4WDvluqSMdBAsSa9ufgN8f/CimlMIFh08mLjdKEWWYC3fsWhCk5AOZyBRc8vlD+2Upk
	X0Ymv3Z+3EY828TiOEvoKJwDL5u4SFxKJ3wdrJ9lMQQ95qpTZhA2g4rfff7aypn2urTfXjka/Vx
	olufn6Wh3u5k3lHdZa7o77ViTgEauN7TenDtOBOBhnCLpDGKReB9XhEgF9DHe86kXQZfnZWhYn3
	LEHWwmokN4ycd2cBdKN3lez9EchaXGcc3UWvdSWj/PEb42+/8gzWZTAa/F3JdLqJxwaAESF7ojW
	HV0YxhqMxUkHpk2dWeEMXFusTz+itGg+w3PPX+0W1XusG7RVoK2V156ivChF4u4Pu/bbeWC2Nho
	lJU0
X-Received: by 2002:a17:90b:1a8a:b0:3a0:c22d:fbe8 with SMTP id 98e67ed59e1d1-3a0c22e01a7mr228479a91.38.1790309564539;
        Thu, 24 Sep 2026 21:12:44 -0700 (PDT)
Received: from localhost ([153.61.198.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998e2bdsm1908663a91.13.2026.09.24.21.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 21:12:43 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 04:12:43 +0000
Message-Id: <DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Hao Li" <hao.li@linux.dev>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <jackmanb@google.com>, "Amery Hung"
 <ameryhung@gmail.com>, "Swaraj Gaikwad" <swarajgaikwad1925@gmail.com>,
 "Clark Williams" <clrkwllms@kernel.org>, "Steven Rostedt"
 <rostedt@goodmis.org>, <linux-mm@kvack.org>, <bpf@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
In-Reply-To: <arIY0wMQjCCsqidI@gmail.com>
References: <20260919171443.90512-1-kmehltretter@gmail.com> <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com> <arIY0wMQjCCsqidI@gmail.com>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: n1ix54wqgg654o1yiobed1a6i6fsa6yi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 07782180003
X-HE-Tag: 1790309565-383428
X-HE-Meta: U2FsdGVkX19E7U775tMbCknPfwN0GS+ostd8AXqKchqjoU7ggXD3M+tiSBf5MKplVfP49TmpPzW0HEqQbKDcxjSkKbKK70u1OXuzhqQYrs7hmlzDPFkAqwnLDPKsbypCh4etJIC27h28iXASP2TGUHFxYxzYe7bNdf4e6vAMZ7/XZ6N8KpLVb/iU09ZAw3i3B9Qr7xQ2ymaXFmmT/zoTrwfxFPXZZpZTjUSTYAqJ2nyzrXn1LWYGP2oJUeI04a084+Tsu5iCpQnZ2ZrZlRz5huJfHmn5u6j3Vn6gQE0UBtzB+3jw01wjfU2y/OuedXoHaDwTywkO7yB/6sda4LbxJ76ukuwLzvyr9Ijs4JTOir2vnQ0pLRTtuW0VYvgL+lrlbBkYwSpFDPMch+yv0zYQ0C/qbArcCiZ1EIigLI8O7AbwMlUC6Ty1AdAQz8d9Uej5BeMSMG+2hrXPZZFewMWSrcvwlmJOvCBWZcRvcgLDKzo5rcVpPmlu9uYaJibKe/S1wa7uhGIcFhBB5HN/4XghfQGUAP3UTsvI0qSaGSDSLw25H6g+07/GwLyftOr6VFoMIopk4rz5ruEIKRG0lSg7XV53j2+iWDmO0E4hiZjey7ag+f69mjiSQLXXleLJtG4GrDR/kpgqz9Fci1aZ8hbpFlp7hFojJaIBfVPRWiaaEMNWZ0ZtAPOXIl0TyvTfYJINz/1a5FIagU05QzGZBWjoqngZsWCRxwFXi7FJOWBn44Ub7EGXnw7lFjT1Ags3wTtdwLTXdNCRdWwd4efCGSNQpn4CA0IgJ0vF9iz0FolYffR6sYzl8SI3cUr1KutiJ8yCgEHXOgEN5DmoxYJIozw95YMir8+0zqjE5oh9T0f8qlPrPfUztir6PbVKzW/ELfGtEmv9LwE088nyXx/5ZQrJoB+FUYB1vlHVMukbf+sF3QxiNptcMK3PdVRS+w1CdcMApLrHgo0huEynFyFqoFb
 2Chaub+t
 ayKZM59VIXW2HrSRcNAmiYn3QGbyvsBEsignJV3X/iN/nItxEokd2ohpygD3kZ4LRQ7zjX1U066VM1LzRxk5PBHNQo+HWQkDLdpSNcf9epp1zI3Uh4jc5++Bxr7bNxm2Rs989BGpR8KJXIuGw/1HEtIuReRDDkL3UrHLPMItBWaG8Y/bV51uXuPpZA1CliZcQGe4++Rajt7yPPWdo5brGL4Q5EfzEUkCSg/WTvlsZ/z3dpLKSjt4vGIicDzWoXFoW1SiIARFmQSgC80aNX4Y8LQfyfUL8RvF6JLYAVAM3fHWL8VLHKJvnlpQoQ56XNGAy1ndj5Q/zdhnXIDyiP8+xz4MxtoNynS1pf3cRjrXMXIJaHbxzj6UIIDrmYk1roCGpomS0btBOw/QPgd5GGCUw4jKH+1+jmhZMwv8ieIZxPHeLtljETs4NOcSDgyjM/DlVQbgvOL7g6TmwZ/NYGGRq4AJqWXoryqIG3vL/lZk4/PAEHcS6MyzeH6KNdQqA9dsOOfW6Sy/3KsJm9dNwjhTu17fDM1X7+f2+RLbjgW+caXzbfkUd7WrG2YJ46dqow/29EivgLnmuYigfvEZn/1KYIDHA6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 08:04 AM Karl Mehltretter <kmehltretter@gmail.com> wrote:
> a) Change MM so _nolock() allocation remains safe and can still succeed
>    while pi_lock or an rq lock is held. Existing BPF behavior would
>    remain unchanged. Is this feasible, or would it require substantial
>    allocator changes?

I don't think it's feasible. On RT the sheaves lock, n->list_lock and
zone->lock are all rtmutex based. When trylock succeeded and a waiter
showed up rt_spin_unlock() has to wake it.

> b) Restore BPF local storage's dedicated allocator, and document, with
>    debug checks if possible, that _nolock() must not be used in those
>    scheduler-lock contexts.

No. Local storage is not the only one. bpf_arena_alloc_pages(),
bpf_stream_vprintk(), bpf_task_work_schedule_*() call kmalloc_nolock()
as well and the same sched_waking prog can call them.
bpf_mem_alloc was removed from local storage, because it wastes memory
on preallocation. Same answer for d).

> c) Have MM detect those contexts and return NULL. This prevents the
>    deadlock while preserving ordinary raw-lock callers such as arena,
>    but task-storage creation from scheduler tracepoints then fails
>    deterministically.

This one.
bpf_task_storage_get() with F_CREATE can return NULL and the progs
have to check for it anyway.

> Are these the right alternatives? In particular, what behavior is
> intended from the _nolock() API in these scheduler-lock contexts?

It can be called from any context and it can return NULL.
That's what it does from NMI and hardirq on RT already.

