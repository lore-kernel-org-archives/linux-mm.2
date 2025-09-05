Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C92CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214BB8E000B; Fri,  5 Sep 2025 13:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5468E0001; Fri,  5 Sep 2025 13:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D3E8E000B; Fri,  5 Sep 2025 13:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4F5B8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:31:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93DE784624
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:31:20 +0000 (UTC)
X-FDA: 83855887920.17.73F1CD8
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9BD244000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:31:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BpTCvPUk;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757093479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKUOxUkpu87y0JAxWfPS0hdSys91o2uD8NOBJG7K0rg=;
	b=WqtYICxp3U7dyDVyzeyI4O7jQ7ADcFHWTJmNpQkz9A46LM7pBhxbdGYUN8+7YzUJvL5LzS
	DRyHpmCMdOjinKP6cR96OELvqAIKyPRVyPDqibU1WNcMDZGFrm2WunPIXsSvThrzunBR4W
	H0y1r4fOQmDesyxgdyRzO5Ihj99W5lQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757093479; a=rsa-sha256;
	cv=none;
	b=llDk9q7XPdEDmXgm2STyGERC0mZ9VT1MjB0/Rr4Z+si6cE05heQZwuT7KiAKH0COG8Jfyx
	dbivfN3PewzoKoTMxrqAmykJ2oI1YCPhKDlYMivrE/sfWFJbuxEau3Flbyxc+V6LnrZCL1
	TGw+PzaAuSVa9QFhy5LJVL16KFzi3k4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BpTCvPUk;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 5 Sep 2025 10:31:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757093476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKUOxUkpu87y0JAxWfPS0hdSys91o2uD8NOBJG7K0rg=;
	b=BpTCvPUktRzrG+iXU0FzgQsLrNO2LYX/uFi6fH2cRqj6a/1KhipVksQ2SzTj1j6pEg3Jw7
	mT8SfMHdOBXj8e1SwcUd3N3soT8ljERduQ2Zx9tT4ay/QAmVs7i7VcL4r5IKDxvPVOWduw
	q9fU3PHD3PFGDI/uOcbPBJEYO01JLU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Peilin Ye <yepeilin@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Tejun Heo <tj@kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BD244000E
X-Stat-Signature: iq3gmtd7shmsy8yn4jue31twkmgsksky
X-Rspam-User: 
X-HE-Tag: 1757093478-601983
X-HE-Meta: U2FsdGVkX19QbpdUnS6ObOlhRT+nXPOf4rmUvHPPL8cXQVnUKt/PRs3Tq2eExDJoDjrZg3OpDNJx96EN7pcJ/gCzoZ/w/bt/b3GCpT8Ogeet1Hbgaw1d0/KZlveD3Ty295QOBejrqO4izwm2liu3aVfERc4X3R463VSeP5NOT5W2qJfQAbnCDgvIMdbL3/LeUnJ7gn7xBQ/AbhJj7D/BhurFSR80v4yzi5AuRncYq50/1hD2dh40zXC0ggE8ksoc+9anfC87oT+yBZeuZlFgZsB4966ZaK0D70q3rTeymPotOxStpga8SLzDLK1jSPB0HAf/9mFeIzPRXuka0/w070SbHknKFdqcesTaDsjzF4KaSLgBd5weD/BeQUfh3De6GcgXXdjfv0OYL1qTAWkMt30nk2UXaQubcj+08lsL/nbJ9lkLhifnHj00VL7v50l8m5SC34GwjWLnrmUkBwEFj1PAMs9FSoL4PQI0heXUadUwkHoDrGFq5v7OKnqQsGm2gOA0PJuA5D4A/CS7M/Lc5Ener2lDxSK2UKgxqxK5e7i3RizF4JS6BXPbRwSqLGUbdqbm6H0Y7u0smUslUhwLa+mGF/zA9jV1lJ5d7s5nrT9c3A2W8ukvTeiT3JDu3lXWaazJPxT3dVjqRkVQkrQdxmycwehOUNjjzqaqWNR/VfZGfgL59q+mGz0TfKHcUuoZavVXlDk/jvyyjMC/BJrjletyBC1TFprY838+xLYZPjKOdhwgleMbPBRKNmcz1aIiqe1UxGjR4ZTX0/P3+Lp+dEdm1CAA/sQcDU8gsdDcgR0j8ft0/vC4rrhU+uLDj9h6aGAQP1oNOHr5WMWoezHdC+G1EiZKffJ+KnpgCUqddtM6qbfgOXs/GjbRgQlphGClRTGBGKx8Zd4WQ6F+B13quR8Tr8n1esmRTOWmwGl66mi4hfcRwOyuLhK0D95jS2L4SZWfJ/yOYycgRxsXZ+Y
 mv+XSAQg
 pALaMJPN5XdYycbbT5jOS+lEehFYxJusyva9oX9IXnw7tja3j8xLJgNXZBRyMX5blhd5UZcYdnifg2zq4aeLbbxlhGWhHkdolwVmDBGyyXnYNVcwg3iUZOkNpU5sKoJ4TOoaGi3yBd6wnc/vcLxg6CsG/jP/TraxBSRzVC8znNoCJpHetgjVha7KKR8IFpfxXMqQHVguYyH6wXDu/WvZLynX1nfGpb6bG69fHAVpEfOhxiWpGVnaa0aFlkEvNxD9xyauy3L13kRfH+z6zw93nzzfdJCKoN51FI+KxarH5eixnqDG+Fy9lMpr539Cw1w07bllO5kyGCR+OKmJ/sjuAfP6j/MfTgeyn3ees4MckP+JauWCA9ZmR3o00ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> >
> > Calling bpf_map_kmalloc_node() from __bpf_async_init() can cause various
> > locking issues; see the following stack trace (edited for style) as one
> > example:
> >
> > ...
> >  [10.011566]  do_raw_spin_lock.cold
> >  [10.011570]  try_to_wake_up             (5) double-acquiring the same
> >  [10.011575]  kick_pool                      rq_lock, causing a hardlockup
> >  [10.011579]  __queue_work
> >  [10.011582]  queue_work_on
> >  [10.011585]  kernfs_notify
> >  [10.011589]  cgroup_file_notify
> >  [10.011593]  try_charge_memcg           (4) memcg accounting raises an
> >  [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
> >  [10.011599]  obj_cgroup_charge_account
> >  [10.011600]  __memcg_slab_post_alloc_hook
> >  [10.011603]  __kmalloc_node_noprof
> > ...
> >  [10.011611]  bpf_map_kmalloc_node
> >  [10.011612]  __bpf_async_init
> >  [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
> >  [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
> >  [10.011619]  bpf__sched_ext_ops_runnable
> >  [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
> >  [10.011622]  enqueue_task
> >  [10.011626]  ttwu_do_activate
> >  [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
> > ...
> >
> > The above was reproduced on bpf-next (b338cf849ec8) by modifying
> > ./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
> > ops.runnable(), and hacking [1] the memcg accounting code a bit to make
> > it (much more likely to) raise an MEMCG_MAX event from a
> > bpf_timer_init() call.
> >
> > We have also run into other similar variants both internally (without
> > applying the [1] hack) and on bpf-next, including:
> >
> >  * run_timer_softirq() -> cgroup_file_notify()
> >    (grabs cgroup_file_kn_lock) -> try_to_wake_up() ->
> >    BPF calls bpf_timer_init() -> bpf_map_kmalloc_node() ->
> >    try_charge_memcg() raises MEMCG_MAX ->
> >    cgroup_file_notify() (tries to grab cgroup_file_kn_lock again)
> >
> >  * __queue_work() (grabs worker_pool::lock) -> try_to_wake_up() ->
> >    BPF calls bpf_timer_init() -> bpf_map_kmalloc_node() ->
> >    try_charge_memcg() raises MEMCG_MAX -> m() ->
> >    __queue_work() (tries to grab the same worker_pool::lock)
> >  ...
> >
> > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > bpf_hrtimer and bpf_work, to skip memcg accounting.
> 
> This is a short term workaround that we shouldn't take.
> Long term bpf_mem_alloc() will use kmalloc_nolock() and
> memcg accounting that was already made to work from any context
> except that the path of memcg_memory_event() wasn't converted.
> 
> Shakeel,
> 
> Any suggestions how memcg_memory_event()->cgroup_file_notify()
> can be fixed?
> Can we just trylock and skip the event?

Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
chains? If yes, then we can change memcg_memory_event() to skip calls to
cgroup_file_notify() if spinning is not allowed.

