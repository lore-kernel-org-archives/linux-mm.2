Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8BBCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 10:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDC08E0003; Sat, 20 Sep 2025 06:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94738E0001; Sat, 20 Sep 2025 06:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9B28E0003; Sat, 20 Sep 2025 06:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C82BF8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:24:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 787A51A0398
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:24:04 +0000 (UTC)
X-FDA: 83909243208.18.81709E7
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D1A1160002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:24:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b/x2MWqW";
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758363842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hZhQHzO6iaBCv+wcIWwJCdyKEWcJ4Nfwc3KoJ0ZPEA=;
	b=t8Vaquo2Ypm5HhAYL1rWB9gsIvxHdRcIN2+wjR3zUW3JvYLK0XUq9s9dcxhJbTUhmNZgWH
	IdVOAUSvgDYi7+bvMYG4o7Fr+eM+NyKH7gG1mZEapqDLfxj2SoV8647HL9Ezfm+3D1gwrP
	nuOhouK/y10iIxGHr/4RINDDn+s/De4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758363842; a=rsa-sha256;
	cv=none;
	b=l1MoRfsWYLaXt67+2IkM15DcSEB4nr1AMYqje/sNQS859L8L2KgAI3FwtG4EfKb37eSQ5y
	dk1Un7Gs1uCZTIAbGCPpoGA6oHt7S/f9kLBX+XNZ2ZZrOTacqD15LtajUu0Iyz3VbFHnHT
	MkJZsOQhzvvC1dpO3gmbdNnFhJTghHc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b/x2MWqW";
	spf=pass (imf08.hostedemail.com: domain of elver@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77e543e41e9so1327289b3a.1
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758363841; x=1758968641; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+hZhQHzO6iaBCv+wcIWwJCdyKEWcJ4Nfwc3KoJ0ZPEA=;
        b=b/x2MWqWMX3jDKcx4VDILFq2IabqK8mFPwGnfVGqst7Zf3W0em+TRthMYLSvpY+RYY
         6CFpopQBRfFgchnqll5w6oCG7PKF1FfXpbeAMWboTUKA5yAybaPOFjypRSz7sKpchkp+
         iGABKFMFvhBAskeHzgV9a0X/iganl2j4aDvmJdnibpXirWNmS0+lRCoKVK6fPiXwrtA6
         Q5sIxu340+mPkmRScZudPTpMCk9YZio7GRRTJKNtz15dZEAqfzT8Rs8/7zBFLR49TIGo
         v1yOKqeO4wEdHpvNKEikQWJ8F4MpTT5X5a/pqRzEC1pRfkq6NKazqrYS2ixTKSTCR+ye
         Cfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758363841; x=1758968641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hZhQHzO6iaBCv+wcIWwJCdyKEWcJ4Nfwc3KoJ0ZPEA=;
        b=hBb+PRKXGOM2KTTkHmEV4hMeq/pX9fZA4mNJpxHht/I9TNL8SzpBgcE8inKFCuYkMj
         Q5R3QU37hzuT+L64HsaMg/9VTZ9FfXP4vF02KVQd2unw16HNZDc0CggBM+qHKuOMsqP+
         iM2g1hb/4et6hrqaVt67KJ0UZywVCzoP2otr07ADxpyk8bFdA0U+CzWm9fVrEbgsEkIb
         s45e19ay8RvgtLqbFtoFHOIgSDksqHYfQvTHH8GUjQmhTB7YIq3V4nQJbvjNXlKB4ye9
         yNTU5YAH5XW97UaeefVQupoDtwS3xqksH6AwCOszBly6UwrpugyfL8sp5nYwIye06yLM
         FMOg==
X-Forwarded-Encrypted: i=1; AJvYcCVbdJ9Mao2rmGo21gNM8SssQXqiOK41/UtBk4me9/rt2dTV9BCkRYaW8HlAO7aVfDcKTgfrpvdEQw==@kvack.org
X-Gm-Message-State: AOJu0YwHI1QS+OOi3sHEOrqVSySphhowrIA5H4HCDnxCOgV6aAyp6M5g
	IHtAp/723/xf5vNMbvjjqWP2zzBVdw5bc36MAXX1+l3MkTDIxE77CFnzwv6CJomXg6pfVxSj7eO
	JAalgvRhngVXZZvuFgiQZVK8rK3utJVN3lmU1bYeY
X-Gm-Gg: ASbGncv4JKd0HSzYIT/U6/jPni2vp6so4XkF0oY/RZvWECDb4A48rIp+VTnbVnfb+dj
	Eul+Rjx6uz4gHCw8SIoojL5GYtW45bSteM60UBPh7oAbHiRHr5e/HLkDdvghnrAzsqSHpul8GFG
	m7HtDEV6aug8H1jz2OFeUPIOIKQQMELrUrOtTH7ys7RcGB5x8t8cdYAs+xUU6cAWa0br4XaPKRk
	ropHnoewMlIdQbctB/NqZYtsFTOEbO9mL3w1Q==
X-Google-Smtp-Source: AGHT+IF1hPc3B6dX8ioPYAwTkyAHDxIYYc2DoRTSnEgCHR4nACV75/Lf01kjKhlKCzTUMHiS0p59fc36fJvtYjO83jE=
X-Received: by 2002:a05:6a20:914d:b0:27b:dcba:a8f3 with SMTP id
 adf61e73a8af0-2925f76be25mr8434118637.15.1758363841077; Sat, 20 Sep 2025
 03:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de>
In-Reply-To: <20250919140803.GA23745@lst.de>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Sep 2025 12:23:24 +0200
X-Gm-Features: AS18NWAyC50-QQYD_wTUETPBlkphWLV8M7F-miEs8DZ-lOTnj5WEfB5uYr0Ax6s
Message-ID: <CANpmjNO2b_3Q56kFLN3fAwxj0=pQo0K4CjwMJ9_gHj4c3bVVsg@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Christoph Hellwig <hch@lst.de>
Cc: Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9D1A1160002
X-Stat-Signature: 57he4chnoprmbon5aawniespd5cdonmr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758363842-317607
X-HE-Meta: U2FsdGVkX1+5yHWWBelLJgNXdGhyCvhDapAcq7s5Cog+wa0S9cOaO/ut1+G2zixU2SKbLfOweK3dAhby5oFAzHskVO63Kf6CUcEeCm7XjC6EQSzkQr6JAgRMkQ6wX3NUzcXpf91YFj4xV5ytGB94xTN/2cyIaZX6VszZ+ExB6xSyP3RcTa0FKmA+qqKFl+n2gWCQX6mNd5UwP7lYqYcCSIPumoWz83MDGspqRtHZk0wE24/996xXxM6ERefnTLSsJ6rF4xhgKeML1HSPLLHlniHJfxNCEO2KUW9UC+UP3q7vS6sNc3tdQG59mKUoAGu2XCtZ1iAqe6YYcbOFa9Lxm1k2aImNkreTt2B8k4bzdpJZpufk8JuyZPWkwZ712POiR5UsxQMI99bg0hq0RUKBOk6ltiMI57u0EdmAcgaXv4zkcjSxfaJ+HE/6Q95i0CQoCSjOKUfqeM3LNb5QuH/9xpTox0ffU2uU9XEC2TpIsFoSUeJKTvw8zsGGnc+rac/cN38Wl39IYWvDBajpMVww+R3Ixt6k/5zMVYM/HH+QfhIJNWToDd+sREQn2hqC9S3XuE015P3kA7wkcnG2FF6hQi7K2W1Ec7OySc09IpzWwLPifPs9dJaMpghX/HEXyvwdhH9R9MZCHO0U6vjfX0cIr7Tn+tAiKlSNuljR4ZeFr23cEZKKu2Xph82fUmdAV3WRB1Rxwk6Fi+M6XxqOLFh+oNY4jQyFhSxbIq2b6HbxSDIqSo056K2F4rSmkuVStg14aK7hWuhoezEycyuExzDOmbVyLCaKuiqfBHEGsYz+jrpTPrO2zDQGCkBbUBizSS0Lm51opYcwARt4zjGArFpge6SYpKXMd5z8YUfz2pzy++dlhMBQWScRC7/1YJJN50c97qVt6lskNbi/11gMfAkagcd1CqYX+B4kvmQSZ/9Z2WeEbVB4+mv9GRvESTPwKtsqjC/ygj2vFI4lsyiBT4x
 LAiuBHqH
 Xj8gXuQYwkW7ssv9rlrjKDwvh2V7CBsi49KBWYWrjPX8l2VhtfhzaIoSroAmb1ORbyxazwTv6DeJgJtfAJYI2g98cqKCBhnb01ALBHm85zmE0qtTxQEi0RYeL92vRWeOTTGc/jH/Uc9cGgiqrh59iZYPmz+dbIjT3ZVt3ym3W/xuXaG3W/3tz0dYbSgTKhZdgJmKL1nJqBY7mId2eaeR8exaZ7un9WY631ozNi0tHJO1BFeFH+tL5aQhL4RbCFxCLFiTbSOUff6h4Cm1G32GXGFq/Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sept 2025 at 16:08, Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Sep 18, 2025 at 10:45:55AM -0700, Nathan Chancellor wrote:
> > On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> > > On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > > > A Clang version that supports `-Wthread-safety-pointer` and the new
> > > > alias-analysis of capability pointers is required (from this version
> > > > onwards):
> > > >
> > > >   https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> > >
> > > There's no chance to make say x86 pre-built binaries for that available?
> >
> > I can use my existing kernel.org LLVM [1] build infrastructure to
> > generate prebuilt x86 binaries. Just give me a bit to build and upload
> > them. You may not be the only developer or maintainer who may want to
> > play with this.
>
> That did work, thanks.
>
> I started to play around with that.  For the nvme code adding the
> annotations was very simply, and I also started adding trivial
> __guarded_by which instantly found issues.
>
> For XFS it was a lot more work and I still see tons of compiler
> warnings, which I'm not entirely sure how to address.  Right now I
> see three major classes:
>
> 1) locks held over loop iterations like:
>
> fs/xfs/xfs_extent_busy.c:573:26: warning: expecting spinlock 'xfs_group_hold(busyp->group)..xg_busy_extents->eb_lock' to be held at start of each loop [-Wthread-safety-analysis]
>   573 |                 struct xfs_group        *xg = xfs_group_hold(busyp->group);
>       |                                               ^
> fs/xfs/xfs_extent_busy.c:577:3: note: spinlock acquired here
>   577 |                 spin_lock(&eb->eb_lock);
>       |                 ^
>
> This is perfectly find code and needs some annotations, but I can't find
> any good example.

This is an interesting one, and might be a bug in the alias analysis I
recently implemented in Clang. I'll try to figure out a fix.

