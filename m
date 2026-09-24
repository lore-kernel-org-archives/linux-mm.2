Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA8BC98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981FF6B0088; Thu, 24 Sep 2026 16:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9585D6B0096; Thu, 24 Sep 2026 16:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895746B0098; Thu, 24 Sep 2026 16:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63BA36B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:42:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC7CE40463
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:42:30 +0000 (UTC)
X-FDA: 85249828860.18.49DAE3F
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F8DE180006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:42:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=movhOMzi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790282549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q02PnOw+IihxD3pubEnPLP6QFDjRhf/Aoa7XuGLmNbQ=;
	b=fmE5SgRf9tnSjJcyWdOal7LRlYziH98Hu+TMZm35IoX+1lOC5tpZZU71c1cftzVayQ+VlB
	1KzSp8F3LzAxvlVLgBAKVu/+ksbiyAs6QbltsIiFKPrFYYAhJcKo9KNjztEdOWI2xvNFIc
	W2S8UH5qjM7hduQ42QlBPzrcArOIyZg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=movhOMzi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790282549;
	b=gLHd2xQ2hEUZRdtdxrtFIAkyfNODqJ0UMt3TAUymf/eU01FMQdlAhcqKPNTIIogyNpeHr/
	9OSwe38wuzqerv3ZYsjQ2jiwlw2hfAiuSLuBeZ53DhBttq0WyY1vI5CDzvQ8JcB5R/5gae
	T5nbgQpOByud7wwxjjrwEOxGItAMtH4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nnArrsZ9H8yG5uIeRkg0y81lA15dy/yoQgT4igabXhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790282547; v=1; x=1790887347;
 b=movhOMziQtRSeKkzCtOdTDgLn/vpuXyK3ONg4P+AqvP9xRlLcvwoVH9I7sTEjNelr4oKA0T0
 CMQdTkWulpOzBLIKErJjheg6krYOy5tP0AhfgpKjLrwDUpoWsRduXhpPGkriFs1QtDMs2SledM4
 3KOQyAivloZDBVXZgA8qgW2A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2e7b493161569e3;
	Thu, 24 Sep 2026 20:42:26 +0000
X-Mizu-Trace-ID: e2e7b493161569e3
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 13:42:24 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <arWJBBOdvLsOSdCt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
 <arPyspcEFNkqfNyr@linux.dev>
 <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
X-Rspamd-Queue-Id: 9F8DE180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fg3d5mtsoozfn4irwowbwsurpmix1rke
X-HE-Tag: 1790282548-452285
X-HE-Meta: U2FsdGVkX19+XrX/JVnVhI3yWgs3bnphwW0tUBsgB0QxmWfagAL9qmzL+PlE8YdcDgfU+Xnvw/mULoFrIlFy3RAXwaLOeRdhU66lxAyDenOlfcXUyxD4xStCvQup562hPPBG63G7a8zmgdN04BO5zHVcTrk3XinULCvIkXrmX5niUa0yKANWjC1mG3DltaPIH5LejhzduaKaIUJCLcCsvzoj3H7zgEu+1q01GtSWwxj0JfdvtsYti9KFHB8ZAdEF9E32ViOKf+zSsKhwzj6z6bYoEBr4lfHo0rgKtEHcWgukw6Y02J+dwXw1V7rKKRgFLqCkxjh9SHsflIrpgSciVN6xapgh5dx4ky4VC5Ldxq+KDE3HU6J0XSAmL6eBhhSLVR76hjvqOk3evkDriq0aEdWbSOCMKrmZMd3E75fUGdj3AFQBUKJjgpHQSLYWlPIUsMUY/P5lExJf/ODALmI0H2u+AQLWHHmEs+/R53xTgAaMz3LnU+KcBNahRRg7I9mp8q/GkeK5E4Dx5AsESwOeJX3twXwyL9IdyCxGde7thZFL/MMQqvYcZLOIm7G/5xODDadkW8K2w7+GIigc2fD8cj/gVO1VDQ2Pz0HylrWv+dA4XqJuYsIK3Dvn+eWedkiRepR79yw/qw28DR3wC+/qxqakw8JKF7yJgThj2T9jpUWbMNb5MRnmBG0GweMDVLYtaomi3j1sn1rdiDBr3WyBL0XcFFvFSC9Z7C7CRyLQi20uRTwHpILcC3FPzJ6mLPRGmWhiGiSFEqRpjV5Qb/1juRvbUGT23g9j+iSnbOcMyTYocPZt5SYA26ja96mKKzHrMlB7zFpsfQED1ZbyKaYAvkTbJbilrXJ1QBoyA4XcFAVe3jh7Qqn+UdM01vbl92TwrJn0IFicDGMrSemSBBFoiBynigpuOMpd/6dJLSOX4RbXAU78mODwwyBB202LQeMR1PEfOmMEORtuJ73SNES
 fiAQdR/Q
 jwedFn7QR3gGNZiK/XjQSOfKyxcJYBmTVZwXg1ThhjwvAq2hcP2Gj6EqDJ5lNEhEWeKmc5TQGU9leMPsu8Lry4RQYXttXtDPp2ZLZMHpqsupUdTZXuSbje8/Ld2Z38s9FJYXoYLauHA+tRotAzu7Hzuu4GZ6GRv54UVa083MYathMKCIJZUII9p+zLL09rigPhQKk9FnzQiHNAt/jk8bwZfhmiNVRzwh2T2cfldFT6ByhczzdnxW9moz9UGdIKPTS15ABlKd51LLCDVprXBpUV69f3zwEg44+OLNQciEEicO1FQbhnicP8m/4t52YSwL/uLBXrfNiQ3o/unmW8lGo0YvuCo0Rb2GYZwIJMDLr8n3ViyIDhzYHS+5JcTK74aR7XpqCD1GqB7/6JP1sOX91RQ7YCeiGE0UK4Mns/gSge1MiNvITkOgonVkMNHEJjnpd+HMTu1x//5rkloPk9e3tS0+RGQ6YpMcvI+hv1KvIOgtQecwIQchxazC21gIX3IbmNGJjTo/R000cPIo3OvD92XbNCS5u2GYbGe90hk5B6UhnE1JTpz9CTbMXmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 06:01:27PM +0800, Yafang Shao wrote:
> On Wed, Sep 23, 2026 at 11:47 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > Hi Yafang,
> >
> > On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > > On Tue, Sep 22, 2026 at 3:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > Hello Shakeel,
> > >
> > > On the open question of how deferred debt eventually gets paid: would
> > > it make sense for the policy to also notify userspace (e.g. via
> > > ringbuf) when it defers,
> >
> > I think the notification through bpf programs is already possible and a bpf
> > program deciding to bypass memory.high can already do notification via ringbuf.
> >
> > > and have a userspace reclaimer do the reclaim
> > > through memory.reclaim?
> > >
> > > I understand one of the concerns for the async worker is CPU
> > > accounting. If the concern is that the kworker's CPU usage is not
> > > charged to the target cgroup, the userspace reclaimer could instead be
> > > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > > cgroup, and both its CPU and memory usage get charged there.
> > >
> > > One caveat: intermediate cgroups with the no-internal-process
> > > constraint cannot take processes, so this would only work for leaf
> > > cgroups.
> > >
> > > What do you think?
> >
> > I think all of this is possible without additional code and with this series.
> > With AI, should be very easy to prototype it. Please take a stab and I will look
> > into it as well (time permitting).
> 
> An LLM helped me quickly implement a userspace async memcg reclaimer
> based on your series, and it seems to work quite well.

That's awesome. Please do take a look at the code and provide feedback and if
you don't mind, a tested-by tag would be awesome.

> 
> >
> > Thanks for taking a look and also please let me know what other ways you think
> > memcg can be customized through BPF in a beneficial way.
> 
> Sure. On our production servers we have been running a set of BPF
> programs to tailor kernel behavior for different workloads — all of
> them global programs so far — and I believe they are all good
> candidates for per-cgroup BPF policies now that cgroup-attached
> struct_ops is available. They have been really helpful in our
> Kubernetes production environment. I have sent some of them upstream,
> such as:
> 
>   - BPF-THP
>     https://lwn.net/Articles/1039689/
>   - BPF-auto-NUMA
>     https://lwn.net/Articles/1054030/
> 
> Perhaps we can revisit both of them and turn them into per-cgroup
> policies — what do you think?

Yes seems interesting and I remember other folks (I think Rik) were interested
in these ideas as well.

> 
> We are also running some custom BPF programs that have not been sent
> upstream yet, such as:
> 
>   - BPF-async-reclaimer
>     We don't care about the CPU accounting of the kworker, so we just
> wake up a kworker to do the async reclaiming.

I understand but I think for general solution we do need accounting for this and
I have rfc out for this.

>   - BPF-fault-around
> 
> Both are really beneficial to our workloads, and both are global programs today.
> 
> We are planning a few more customizations to resolve painful
> production issues, such as:
> 
>   - The long-standing inode::lock contention caused by dentries [0].
>     We have not started implementing it yet, but we might introduce a
> memcg->dentry_limit or a memcg->vfs_cache_pressure as BPF policies..
>   - cgroup-level readahead.
> 
> So, to answer your question directly: for memcg itself, the beneficial
> customizations for us are the reclaim policy (the async reclaimer
> above), the dentry/vfs cache pressure knobs, and fault-around; the
> rest are per-cgroup MM policies that would need the
> struct_ops-to-cgroup mechanism generalized beyond memcg — which is why
> I hope these use cases can help make the design more generic.
> 

Thanks a lot for this information, I will think more on these.

> [0] https://lore.kernel.org/linux-fsdevel/20240511200240.6354-2-torvalds@linux-foundation.org/
> 
> -- 
> Regards
> Yafang

