Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA8D9CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 05:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9A66B0088; Mon, 22 Jun 2026 01:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA416B008A; Mon, 22 Jun 2026 01:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A7F6B008C; Mon, 22 Jun 2026 01:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA6AC6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:28:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5980CA0460
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:28:55 +0000 (UTC)
X-FDA: 84906419430.27.357F636
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 54D6C40007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:28:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qh0Nb2ih;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782106133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KNOLAwZyaBThMY1NJgMdUSjBoVwiFJr4CThsL0B6VY=;
	b=l0n/QDYkE9CY2rwWUDeolTpJ1QTqh+zISH+NWyapadD/4qM/qzSCa2gpveJ3y+kR6EKisP
	ZpoE+0eCOLGCHcC96Szl90sxblPuDxtRHK0+95U/kTZk31NAFJ8u1+gS2/sLNSzdtUP4J1
	ubKPqdZ31aJ6RIDODadays+i/2r8tiU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qh0Nb2ih;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782106133;
	b=zeX3Sw0792gO/mI1pRXuC6BKr71UvlWU0hzKs2YfpIwufgbkKhieQ47UxyvS+d/CTc+4tZ
	ZELJUIE7GlumfDPOXtCbt3D6NZuRRUJucLZFszMcxDELu1aUowuTJQqPy7L6d2WSry3o91
	/5UhFt3ejjznGWQAr37GC6zlpnmPC4U=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c85a297d2d2so2695026a12.0
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 22:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782106132; cv=none;
        d=google.com; s=arc-20240605;
        b=IxnSqUxXP/Mfu4aCN+JPebEO1cL035p6z9H+0HXnLmOnmG9BOUw7gfk6eFzHo5kyza
         9FMIQi3UAt/GpDmR7BMCTHf6y0znj/5/PHC710J1heI6hldNlgYCREN3oVmXtmecWbma
         PzXQFvTJZLY3Rh9DzcPXZoSJEOsTvnybO/kvZEoBa0sG9ayzoaBNU1/J0gdaKJxUgvWl
         /o8enveA+XM0IZRIPGG3H1tPnZD6VxCbPAwEzvH5UUHMPTMzgRZ2uH/ULndFL+CMliDz
         Xjk8c9z8JZqMI+5vgRsh4Krm+UTbtAeQ1TS7mYVfBool4e7fe1AK5JB3WGWqeAFv24IV
         lXhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5KNOLAwZyaBThMY1NJgMdUSjBoVwiFJr4CThsL0B6VY=;
        fh=zD/kqbAlvtE3hRGv4eiZXqAqWlWpC15TFKRKdPXVH14=;
        b=WbGu2mR1tGf6DX5ZJ8V+wwTxTwaXFhBrf9U+l/XYw7dX5ah7uNjyKhmQUWyyTh63l5
         D8W43VxkxHrrh//Yf2U384XLP+Num7AOnV/mRyF39umFC9A1ij03tw78Yg8V6G69khZ5
         hZIa1/FMJAusN3+lQ4nMj4e/SKwatGmS9326G8aaBZ0uvEBjBqD40ixtoqfCyWF+L6zz
         Nffi8RtqHOWOSG/4WDTO6TOhVW49lFnYBtT9mp4WLb3fkb9tHmm1C87J/VPOfbtRzl0r
         nja1sR87aGXcXd+bXIyVUzYv/bLRY5bBwtg8g+lxcu4vzB40AtZVQB1XkphbUA/quKRK
         5a/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782106132; x=1782710932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5KNOLAwZyaBThMY1NJgMdUSjBoVwiFJr4CThsL0B6VY=;
        b=Qh0Nb2ihjYqJIDGjyOn0eIm4J7IovKRxvqCXLLZUesFYAfT/+lKW324AgSl5XJFQGN
         btcOtk7VI9+zE2VGhp85vXNJDuKO6YPnY8kHuwfkQ/2yn9Jyq3qdscYMRyQanyCW5coj
         sxSHdMNHseEeP0jktABNlFfD9Va21WHxN83uL+9GCHJwwf7klML8jMGo+EERMvyf2I5r
         n3iqxv4bEOxzpa1ZU6Ehof/z6m1E7yalxrSGmEzXEEFSxVKQeea+/xo0O2f7TRmWfYMr
         Wy2Q5L+CpPJQLw2OuLwDRZvP2lC7R728gYzmj2lJLNSA9ccEzk2pRjjFOm2SXCKQ2X+i
         K0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782106132; x=1782710932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5KNOLAwZyaBThMY1NJgMdUSjBoVwiFJr4CThsL0B6VY=;
        b=JudLnu35WMqpU/jmW02Y61M7GVddhSOze1LlIc+yrJblFBaMxc1ZJmY8+NxHhyebQS
         Iad7Xcl/L11c78l7SMGQcBqWvOgV5BC0BRhh2v/ouO7UYUWzVRNoFwmQIiSjLpEmy2I7
         uQ2O3Eq92E7IuhqQIf21AIHblyopfHcAfgkPej8CfrFECvEP87WugoiTbnbQsUHaZtvE
         FW5aNWi3UgHVywgYvmWs40O5Bh1Tslw70Tg/6CWmp+u2gYObq/g+xJBUH4j46GuIgmHu
         Fehpkng7D1TCfJR0SINcW4fxYPF9S9HwieRi/o/N7SsP1u5e0n/RWgMHJhdkhmBh58ZW
         7EGg==
X-Forwarded-Encrypted: i=1; AFNElJ9UddD+czzTUaEXg3iJMPEXdCLhKsx0F1F1/l423mvaDytkpIqxgAnC1td3XnE/O0aGCFdgIpJzbg==@kvack.org
X-Gm-Message-State: AOJu0Yx1xHIQFHnYzdTGgG+iAYHYjA/LORUKPmguAacKuUoBuNnsR9VQ
	eAERNtOwFk+aO4Dm7vJtfUydbF1H6wagngQDTWBSA/3emlMgLCvfbfl8ETpL1hcpHjWYLcSi+eF
	eqvFp5/wOx+xarwJPChWFdfBvQIiAYq8=
X-Gm-Gg: AfdE7cldkAhcNncge6YLG1W8qowJjXl92ex2MSLSbMw3wcxpGiFmFXQblB6dm9cxKk/
	QsvBGZQMmjqVmXzv+gfUEcsDHat/SD3KKWs9CeToMqwPcxYw7G1Y2QAxuLC5ZOJ74KqA0VZEv5y
	kM/FKOgWflJP/PE/HKTNoeqTkOrd2QuwiD37o0uVuYWtu6HGm6A4KXltEkQ5qE3oXXNE+TsqjNi
	bRJampRf60M9lQE5kq0k/RmGq9X/HZfSRpv+odaeqJMZnZbKwRoHy9QgEA8WXjkgoKpcQeYbVN3
	KMDqYT1Kv0LcXzoIfoZNI0SlKYiqVJQYrijovh72zwfaj4kvfd3vip3w/YsO4L+5g2PPBOM9Z8C
	/jtdw9DAktiWsCmnSD54q+6Vx
X-Received: by 2002:a05:6a21:9102:b0:3b7:b328:4c8b with SMTP id
 adf61e73a8af0-3bb3241d5bemr15602261637.19.1782106131632; Sun, 21 Jun 2026
 22:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 21 Jun 2026 22:28:40 -0700
X-Gm-Features: AVVi8CdydPWkgrsWeukABG1V_xsA12RL457Ae_ewOX27KaNNGTwhs0J8OHNbSBg
Message-ID: <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor state
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Paul Moore <paul@paul-moore.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Howells <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Randy Dunlap <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net, 
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, io-uring <io-uring@vger.kernel.org>, 
	audit@vger.kernel.org, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, dri-devel@lists.freedesktop.org, 
	"linux-perf-use." <linux-perf-users@vger.kernel.org>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, kexec@lists.infradead.org, 
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Power Management <linux-pm@vger.kernel.org>, rcu@vger.kernel.org, sched-ext@lists.linux.dev, 
	linux-mm <linux-mm@kvack.org>, virtualization@lists.linux.dev, damon@lists.linux.dev, 
	clang-built-linux <llvm@lists.linux.dev>, chengkaitao <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54D6C40007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: y95cme3pz8q6du5tu9doqcfs3dxufmnu
X-HE-Tag: 1782106133-784664
X-HE-Meta: U2FsdGVkX19wJAYRJenGVu8muaQWU39EFX1XQ4sNfGha7V3TqdACv8k32BlZsYEff3wwXsTM7ZTEf7deE8/LSnxU96XR2IFeuy+/kkJuZDH9nDPVVL3RQMWvXIKQ504HqXqyKjMIKioA1s5ZiqCPPz1Ymx6T8AH0fdf+8O1uyAm5APh6bB0BJEJCFx1CwIbWWc9e9EnCFAptF8QfQrEeVCYpOvKtYC0Rxd/wpPCdNI8oeVHvth5ja8GmW3UmbvTkGSUeAHHFkjalgO1VxojT7i6DB7nwAmLivXjlqbkqyBi/QerckCv36R7x0wim2l3fYMCSyHbSpYfM1QWlu0tUOH1tPKf+207CSz12L82+COeDAE+dZEzmUFxFrThHFyTW6B6is+r5v+tu1xbQNxyBhJDmcIUBD8GyxaNjLhjcxA7OSpZsePT4vHoahMkdfaqgC4Hr0OJXbZtsaP9XNE1WS1sBQaOVI6ElQVVjWmts5JZr6sovQMzQNblbpyy7/bp/Y4fDu8NTlsBXLP5/AWk+bV4IAvxaPAMInG3J4+UBvMF2kFualgUlRunyeCU2tVIyb2CcK8AKckpNXLiBkRmYlJcBuTQTW8E8iR8y54qZ2EGqAOYvTLbHNLYeACy1RzQVZcQJSeCycEnxrfKLfysKjVR/TPuYFbrgZg4g0S/sycFc98Faw8ZHeSDJTvd55a69d9mLskt2AR2PRMd6KvErF81hCWkiK0bltLPe8DnxJXtW8JH67mheVm5LpyrE+VwgD0tVMEgjPEFFPH8YAx0JIQ6oe4TiPbtNsVflgqwUIu4VUpj2yl/M4RowLPAwbHZWdinXcFjfEgk+BVIsdC7ADKGpxq92DgvK9B8i93SvaW/N4iNLj6AIb5cn6jFEgp7FpAePKtdWyv2sWVcAoO0Yz+/HZ9Y1xg3lBXlFznlcm3cn2aOBq+7kDqWhaJz9PDhQTLqTjDZRby+OirAxcgu
 GIDxxt7K
 3ohnGg8canFVVnfTgx5LD06ZiXSYfTGagaXG7oaUXDLN61qZrBLz9pKTsok1W86YPdfbNZSOOX0pJPN6NSPQv/f0q9+bcHGKL8wiKQbBGXJ5628Vym1owhHG3BI9sb50dvAlf9vfJr+GmmvroKkqqTx3Cx/56gZU/XY9nqlRbeMu9gIaIRUwCevOwTZ2lEu4yN3Dmqz0cdNn+Kuwh7MeOp/eu+Jp6S9jqre3don3GeKiVGML9B8Vp9Y8k9350x3fU+ABSxq4gk68rJEHQgFWwhfKEdOKHvupxeHBS9pKFDUtoDfzZlmc3RRrFBPs5zpXtxO7uHUl6veVDg+v2PI/SK2/x33RnaUMm3csFjuk11LS3TC+xHCTwNutyOezi6iq05nAWn3LJWvGSphgr+Rd8Lz2D+9IMse0uXrq0J0lfXFkuzww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 21, 2026 at 9:06=E2=80=AFPM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
> From: chengkaitao <chengkaitao@kylinos.cn>
>
> The list_for_each*_safe() helpers are used when the loop body may remove
> the current entry.  Their current interface, however, forces every caller
> to define a temporary cursor outside the macro and pass it in, even when
> the caller never uses that cursor directly.  For most call sites this
> extra cursor is just boilerplate required by the macro implementation.
>
> This is awkward because the saved next pointer is an internal detail of
> the iteration.  Callers that only remove or move the current entry do not
> need to spell it out.
>
> The _safe() suffix has also caused confusion.  Christian Koenig pointed
> out that the name is easy to read as a thread-safe variant, especially
> for beginners, even though it only means that the iterator keeps enough
> state to tolerate removal of the current entry.  He suggested _mutable()
> as a clearer description of what the loop permits.
>
> Add *_mutable() iterator variants for list, hlist and llist.  The new
> helpers are variadic and support both forms.  In the common case, the
> caller omits the temporary cursor and the macro creates a unique internal
> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
> explicit temporary cursor, the caller can still pass it and the helper
> keeps the existing *_safe() behaviour.
>
> For example, a call site may use the shorter form:
>
>   list_for_each_entry_mutable(pos, head, member)
>
> or keep the explicit temporary cursor form:
>
>   list_for_each_entry_mutable(pos, tmp, head, member)
>
> The existing *_safe() helpers remain available for compatibility.  This
> series only converts users in mm, block, kernel, init and io_uring.  If
> this approach looks acceptable, the remaining users can be converted in
> follow-up series.
>
> Changes in v3 (Christian K=C3=B6nig, Andy Shevchenko):
> - Convert safe list walks to mutable iterators
>
> Changes in v2 (Muchun Song, Andy Shevchenko):
> - Drop the list_for_each_entry_mutable*() helpers from v1 and make the
>   cursor change directly in the existing list_for_each_entry*() helpers.
> - Open-code special list walks that rely on updating the loop cursor in
>   the body, preserving their existing traversal semantics.
>
> Link to v2:
> https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev=
/
>
> Link to v1:
> https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev=
/
>
> Kaitao Cheng (7):
>   list: Add mutable iterator variants
>   llist: Add mutable iterator variants
>   mm: Use mutable list iterators
>   block: Use mutable list iterators
>   kernel: Use mutable list iterators
>   initramfs: Use mutable list iterator
>   io_uring: Use mutable list iterators
>
>  block/bfq-iosched.c                 |  17 +-
>  block/blk-cgroup.c                  |  12 +-
>  block/blk-flush.c                   |   4 +-
>  block/blk-iocost.c                  |  18 +-
>  block/blk-mq.c                      |   8 +-
>  block/blk-throttle.c                |   4 +-
>  block/kyber-iosched.c               |   4 +-
>  block/partitions/ldm.c              |   8 +-
>  block/sed-opal.c                    |   4 +-
>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>  include/linux/llist.h               |  81 +++++++--
>  init/initramfs.c                    |   5 +-
>  io_uring/cancel.c                   |   6 +-
>  io_uring/poll.c                     |   3 +-
>  io_uring/rw.c                       |   4 +-
>  io_uring/timeout.c                  |   8 +-
>  io_uring/uring_cmd.c                |   3 +-
>  kernel/audit_tree.c                 |   4 +-
>  kernel/audit_watch.c                |  16 +-
>  kernel/auditfilter.c                |   4 +-
>  kernel/auditsc.c                    |   4 +-
>  kernel/bpf/arena.c                  |  10 +-
>  kernel/bpf/arraymap.c               |   8 +-
>  kernel/bpf/bpf_local_storage.c      |   3 +-
>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>  kernel/bpf/btf.c                    |  18 +-
>  kernel/bpf/cgroup.c                 |   7 +-
>  kernel/bpf/cpumap.c                 |   4 +-
>  kernel/bpf/devmap.c                 |  10 +-
>  kernel/bpf/helpers.c                |   8 +-
>  kernel/bpf/local_storage.c          |   4 +-
>  kernel/bpf/memalloc.c               |  16 +-
>  kernel/bpf/offload.c                |   8 +-
>  kernel/bpf/states.c                 |   4 +-
>  kernel/bpf/stream.c                 |   4 +-
>  kernel/bpf/verifier.c               |   6 +-
>  kernel/cgroup/cgroup-v1.c           |   4 +-
>  kernel/cgroup/cgroup.c              |  54 +++---
>  kernel/cgroup/dmem.c                |  12 +-
>  kernel/cgroup/rdma.c                |   8 +-
>  kernel/events/core.c                |  44 +++--
>  kernel/events/uprobes.c             |  12 +-
>  kernel/exit.c                       |   8 +-
>  kernel/fail_function.c              |   4 +-
>  kernel/gcov/clang.c                 |   4 +-
>  kernel/irq_work.c                   |   4 +-
>  kernel/kexec_core.c                 |   4 +-
>  kernel/kprobes.c                    |  16 +-
>  kernel/livepatch/core.c             |   4 +-
>  kernel/livepatch/core.h             |   4 +-
>  kernel/liveupdate/kho_block.c       |   4 +-
>  kernel/liveupdate/luo_flb.c         |   4 +-
>  kernel/locking/rwsem.c              |   2 +-
>  kernel/locking/test-ww_mutex.c      |   2 +-
>  kernel/module/main.c                |  11 +-
>  kernel/padata.c                     |   4 +-
>  kernel/power/snapshot.c             |   8 +-
>  kernel/power/wakelock.c             |   4 +-
>  kernel/printk/printk.c              |  11 +-
>  kernel/ptrace.c                     |   4 +-
>  kernel/rcu/rcutorture.c             |   3 +-
>  kernel/rcu/tasks.h                  |   9 +-
>  kernel/rcu/tree.c                   |   6 +-
>  kernel/resource.c                   |   4 +-
>  kernel/sched/core.c                 |   4 +-
>  kernel/sched/ext.c                  |  22 +--
>  kernel/sched/fair.c                 |  28 +--
>  kernel/sched/topology.c             |   4 +-
>  kernel/sched/wait.c                 |   4 +-
>  kernel/seccomp.c                    |   4 +-
>  kernel/signal.c                     |  11 +-
>  kernel/smp.c                        |   4 +-
>  kernel/taskstats.c                  |   8 +-
>  kernel/time/clockevents.c           |   6 +-
>  kernel/time/clocksource.c           |   4 +-
>  kernel/time/posix-cpu-timers.c      |   4 +-
>  kernel/time/posix-timers.c          |   3 +-
>  kernel/torture.c                    |   3 +-
>  kernel/trace/bpf_trace.c            |   4 +-
>  kernel/trace/ftrace.c               |  49 +++--
>  kernel/trace/ring_buffer.c          |  25 ++-
>  kernel/trace/trace.c                |  12 +-
>  kernel/trace/trace_dynevent.c       |   6 +-
>  kernel/trace/trace_dynevent.h       |   5 +-
>  kernel/trace/trace_events.c         |  35 ++--
>  kernel/trace/trace_events_filter.c  |   4 +-
>  kernel/trace/trace_events_hist.c    |   8 +-
>  kernel/trace/trace_events_trigger.c |  17 +-
>  kernel/trace/trace_events_user.c    |  16 +-
>  kernel/trace/trace_stat.c           |   4 +-
>  kernel/user-return-notifier.c       |   3 +-
>  kernel/workqueue.c                  |  16 +-
>  mm/backing-dev.c                    |   8 +-
>  mm/balloon.c                        |   8 +-
>  mm/cma.c                            |   4 +-
>  mm/compaction.c                     |   4 +-
>  mm/damon/core.c                     |   4 +-
>  mm/damon/sysfs-schemes.c            |   4 +-
>  mm/dmapool.c                        |   4 +-
>  mm/huge_memory.c                    |   8 +-
>  mm/hugetlb.c                        |  56 +++---
>  mm/hugetlb_vmemmap.c                |  16 +-
>  mm/khugepaged.c                     |  14 +-
>  mm/kmemleak.c                       |   7 +-
>  mm/ksm.c                            |  25 +--
>  mm/list_lru.c                       |   4 +-
>  mm/memcontrol-v1.c                  |   8 +-
>  mm/memory-failure.c                 |  12 +-
>  mm/memory-tiers.c                   |   4 +-
>  mm/migrate.c                        |  23 ++-
>  mm/mmu_notifier.c                   |   9 +-
>  mm/page_alloc.c                     |   8 +-
>  mm/page_reporting.c                 |   2 +-
>  mm/percpu.c                         |  11 +-
>  mm/pgtable-generic.c                |   4 +-
>  mm/rmap.c                           |  10 +-
>  mm/shmem.c                          |   9 +-
>  mm/slab_common.c                    |  14 +-
>  mm/slub.c                           |  33 ++--
>  mm/swapfile.c                       |   4 +-
>  mm/userfaultfd.c                    |  12 +-
>  mm/vmalloc.c                        |  24 +--
>  mm/vmscan.c                         |   7 +-
>  mm/zsmalloc.c                       |   4 +-
>  124 files changed, 875 insertions(+), 681 deletions(-)

Not sure what you were thinking, but this diff stat
is not landable.

pw-bot: cr

