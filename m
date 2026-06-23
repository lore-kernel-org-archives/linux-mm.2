Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29519CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A666B0088; Tue, 23 Jun 2026 13:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB706B0092; Tue, 23 Jun 2026 13:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E176B0093; Tue, 23 Jun 2026 13:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 929BB6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:36:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA4A91C3260
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:29:36 +0000 (UTC)
X-FDA: 84911864352.25.9318AED
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2CB6F180019
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:29:26 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782235767;
	b=xs4rdtrjeBfzQooZhABa9tXNPwr4Y4pSx/UMIrOG3RBP5L/nxuUTV89pC5g/lBtj9/xLuA
	W5TmdL1+Fqs7+yo3nriCK1HZ6utlTxTKLSnRQUviwpKnKIyOu41YNavX3MrXZ+AiYJEsM2
	MHem18PP4hFYpjDgET7iPIMXlQHyc2Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782235767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
	b=DCugWeZQ3qaYPKg+VcfUw0L4p3gPFskwmZAx2qE7MzhhOYCxQVmKDO9aV5zImPkyjWQL3B
	sb+mIsYMPMhUWZXwWJGb/0HvvRQ9s7QLxucZvtc4BDce9q444GilBN+mQOQjaxW/yrW1M6
	v0iNJL5thbFdeSl6V2RqWkeuxar8DvA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RURQloiV;
	spf=pass (imf16.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4471b489240so86507fac.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782235766; cv=none;
        d=google.com; s=arc-20240605;
        b=EcTy/RAZv4hLjBoOTYBSBQEJ3UqgbF9ERRQpsfF+zEtLRflRbb70S44rMyTxX4sMFV
         s3HxVprE9/5WdlwK0Iuukree+Rn9iV6zQWqyqlTA1dnVrdxRdfsZCgvZZTFsnmiqnAxZ
         D0uuFM5G7edFYiI9uaxHCo4XjkyO+Q8OEETA58NGrEYsrXCjx6avA8QhrYuvWVEHjaw9
         hVqgNIjEWjsFHY8TqJNQm1XNGLUWV6P6Ib6iAOm+BTT8KEDfaB0BaSSS2sz+1o6iZ0tz
         Cv5Gbi6BYjlYO5fac5UTS5nYlnSWOFvNbC0c8CcP0MvKsB1ih9g4iX0oUTmrql7W/V5y
         OVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        fh=hVfL7utNu6DORL0KfP4L2VdklyNdpeQwMQwLDJK9lKc=;
        b=aBRfL8529QimMITYrT0nAZRDBKekl81af5T8IOh7PDoyf40LasEP3tSbtCkY6gwer4
         YH/7DDfGp1LFEN8nZpBcCNb3v99Elb6PNt4t8r0LOlj6NH4G0Ww8230NI9KGyyzC6PAB
         9XDbjqQBj8ijH4xmNFCRLUwHYQYDXxdNX9krrkvSRW8eg/gmjp1Kl7z7hbYEsLaYyBW1
         6ggBI+nY4OMUp2D4AMreipNDpmnDZLRcdbK+SNgnfMxMj+Q6yx2b5EvtfyHY7Kdz5q2q
         N4LFQn8ZQH8at8cvzs8kMuA44I2VtGyru4Y8gF2nXcFDFtBpv3nAFb5PK7702IxzAiiX
         JvvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782235766; x=1782840566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        b=RURQloiVsQKrqaIFbMsjUV03rIwsIHzSXiwQi9DAcDwc0RQI+P8Z4LgQONw4kit2Ob
         xgkb4yAWQT5GLC9NJbdgZ+CYS8lsDJM2RGtQKo8hgEHohHWClQk9o9VTN8JFAeYgCZve
         2Ll7+IIGlsXSHTVZVhw9p1/fFUb5I/jglt2ORjd5eEb0S1T/hFgcZezw6dzJTLI+0Ow+
         M1uQ2A7fUXSpevEkf4FPEZSMV8Fa9JnDz931aOO+VBcVgYZiln5lqZ1tvNbDUU7eYOnQ
         ZtrjzCmgmGrgT67DGNCjEcIJTaok1ETf3Z0d4gnOpnGkuGrydoWdgr1oTDkqgxjxm4MX
         Z/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782235766; x=1782840566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOKLBFVXea5OkC+RzUd8udE2QmUOJ4Ga+YnSpSPdn2Y=;
        b=MYKF74gbqjncDwIIc3WbQvKlPqTwPSMgsi0Jiqx9EsN8l9KqE0ArMXgfT9Kfgklyeb
         w0LapzgPY5ZIGKQRjg8H4KaltUVzH4UIUsUlCyxn4d4y1JYO+5VcMi6F/iIfAjm+GeYC
         Mk7QRVVle4NoSKmmAUe5LxR4/eTZbDkRGx4XN/s0TkqdnEksqunRwz+xv0sASPT/osiv
         kKjwR1sYSgQVTmvBowwRZxLlX16J0wHyHJFn4RSn8MxeTe9W1NcCyfIMcd1xAlfHT2vu
         ZIB+7McL/gMERjRBJY+sq9NVPIFGzD4yNTCuO8eUXOlWkzwGmhDzDXn+snmetNh2V/qv
         59XA==
X-Forwarded-Encrypted: i=1; AHgh+RrXOvzrWyj+Qq5XdPXxdod2rn/kSTVVf1ZnZ4QJ13hE9a/0Ab0weOyvnvjeoyh574DS3/s5N9Cczw==@kvack.org
X-Gm-Message-State: AOJu0Yz/7ScBZDDwnYfBHJWEQwgVeuUXno9QXhd0TxNE5JW9FS47Zh5O
	3I0/eRLhS5uGCnkhcfT1oOJYnA2ZZkYo9xr5gwNxkhM26DQUaAYL5YuLpnFCkrC86OaQDaRrBCz
	hVCWwG8LgW0NlzuoPc6VE0DhhwygDYiA=
X-Gm-Gg: AfdE7cmwdTpqP8JSB/kE4pkTMVugJD1PkaNDvYSpCTvX0Nx0Xegy6h88isvpIPUe8H2
	n+i2twQ4lhXwgPw17mrP5YWvYltofwy3wCtcfK2MPwSOxNyHU+5Jr9A1e8xoIlGciUglsuKh2v6
	S4Fx3VSpQrmgz+l8CzTd4i78aPY5Xi3u/N237mQWHt9WS3U1SbWmwvO5wfFywdbpv0bJCf/SEgf
	cG2FUT94tl0VpjJRLbYX7BN/9s/WZzEq3zbDssu4hd5h/3oB2UP46ef6PMqpoz+p1H5I48=
X-Received: by 2002:a05:6870:c22e:b0:430:29c3:9d15 with SMTP id
 586e51a60fabf-447b653ffaamr2576825fac.1.1782235765975; Tue, 23 Jun 2026
 10:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
 <20260623094211.1080873-1-safinaskar@gmail.com>
In-Reply-To: <20260623094211.1080873-1-safinaskar@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Tue, 23 Jun 2026 10:29:13 -0700
X-Gm-Features: AVVi8CdxhzkHtkOXOPWSv5LcqN-nC_Tc8xPzc65F7h69_IRaRTA8RjzQbS4VMPM
Message-ID: <CANaxB-wcNOSs9vHpZ_wG7Q8WJVV0D2nhtCFGyZ1_5Rg=+256cw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, alexander@mihalicyn.com, axboe@kernel.dk, 
	bernd@bsbernd.com, brauner@kernel.org, criu@lists.linux.dev, david@kernel.org, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, rostedt@goodmis.org, 
	torvalds@linux-foundation.org, val@packett.cool, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782235766-538969
X-HE-Meta: U2FsdGVkX18Iidt/jy+YDfzJBgR0QFerxjTp7C4DRm99z4B/b1gGu5dflKwDdPhJMk6V22D0PVm9Nz5g+dHpy7g4dxd0XY1k2wU0G764rI8TWz4l5cFg+Ci+3t1HbCCCCN9igq1n+FGn5gpoyRaQ8ES08jB15B/fENid1jtoDHFq1Poo/E7L4msiVqKqOTEdw/r4Ruknn65eR94Xt94kexE2pqKPisJYsXpkOm4MkP3MEoLp2Eig2XNjka6wlMFHzCALaktBGPLZ9TbV6OSFJW4M38f46g7hgj7lXUc8meb/1kiSppKMMCPvofFmUN0yFjLTileR53ShfyNa6gOlYPNS79oGvaSMZitLrB13iDBbSn+i6gi1xky9RukBVCgg+48AJdk/t0YmbjtJsxlyCFI/+rdwwEJvVu+oxUrp8jGKbz49tTscOkPZUasYidJX+1eat7b7mm0jJMsnKFavcODFUUR53Fbn75WlulkpARzHLzoQDlVapw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 2:42=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Andrei Vagin <avagin@gmail.com>:
> > Actually, this change introduces a performance and functional
> > regression for CRIU.
> >
> > Here is a brief overview of how CRIU currently dumps memory pages:
> >
> > CRIU injects a parasite code blob into the target process's address
> > space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
> > pin physical pages directly inside a pipe without copying them. The mai=
n
> > CRIU process then takes over from outside the target context, calling
> > splice() on the other end of the pipe to stream the data directly into
> > checkpoint image files or a remote network socket.
> >
> > I ran a simple test that creates an anonymous mapping and touches every
> > page within it:
> > Without this patch, CRIU takes 9 seconds to dump the test process.
> > With this patch, It takes 18 seconds...
> >
> > Plus, it obviously introduces some memory overhead.
> >
> > If these changes are merged, we will need to completely rework the
> > memory dumping mechanism in CRIU. Using vmsplice() in this proposed for=
m
> > no longer makes any sense for our architecture...
>
> I just have read some docs for CRIU. I found this statement:
>
> > #### Why `splice` is Better:
> > *   **Consistency via COW**: The `SPLICE_F_GIFT` flag ensures that if t=
he process modifies a "gifted" page after resuming, the kernel performs a *=
*Copy-on-Write (COW)**. The pipe buffer > continues to hold the *original* =
version of the page as it existed at the moment of the `vmsplice()` call, e=
nsuring a perfectly consistent snapshot of that page.
>
> This is wrong (with released kernels). I confirmed this by testing this o=
n my current kernel (6.12.90).
>
> See the code in the end of this message.
>
> If you actually rely on mentioned consistency, then, it seems, CRIU is br=
oken.
>
> So, in fact, my patch actually brings consistency to CRIU. :)

Askar, unfortunately, the statement about "Consistency via COW" is just
"AI imagination". The under-the-hood docs were recently transferred from
the criu.org wiki using some AI transformations, which introduced this
wrong statement. The original document can be found here:
https://criu.org/Memory_dumping_and_restoring.

To clarify, CRIU does not rely on page consistency for intermediate
pre-dumps. The pre-dump mechanism is designed to be iterative: During a
pre-dump, tasks are briefly frozen to vmsplice dirty pages into pipes.
Then the tasks are resumed, and CRIU drains the pipes. If the process
modifies a page after it has been spliced, the data in the pipe may
become inconsistent. However, any such modification is tracked by the
soft-dirty page tracker. In the next pre-dump iteration (or the final
dump), these modified pages will be identified as dirty again and
re-dumped. During restore, the images are applied sequentially, and the
final dump (taken while the process is fully frozen) ensures we
reconstruct a consistent final state.

But what really matters in this scheme is the vmsplice performance.
The proposed change significantly slows it down. In the case of CRIU,
vmsplice performance is critical because the target process is frozen
during these calls. Minimizing the freeze time is the primary goal of
pre-dumping to make migration almost invisible to the user workload.

Thanks,
Andrei

