Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C9ECAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99388E0006; Sat, 20 Sep 2025 08:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70A38E0001; Sat, 20 Sep 2025 08:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986F98E0006; Sat, 20 Sep 2025 08:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8924D8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:45:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30BBA1A00E8
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:45:32 +0000 (UTC)
X-FDA: 83909599704.05.61F525C
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 440FD1C0009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:45:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DEMXBDTW;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758372330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2Xt5dxImFQDNB+zIOSzEq8xo9rsZmb+jmetH2dJjzs=;
	b=TJoDv903tU9cCan2vzyOYpLRKDc7zm87iWwD7pKDtpRpA++M7fJ4AXiU8OURu8eF1l62UC
	a0obtNrpWT1Cgf3T7tyTNYNcO862Cnh2XATbdTGBVgPYfciGfafk9qHvhAu9rWZhRwshwj
	InHy7osfqfuGjiP0kb7Ji1uEBZxZYlI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DEMXBDTW;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758372330; a=rsa-sha256;
	cv=none;
	b=cmWB26TldFxpIC58F4GvNDxEZAR2WB+dOZmKBhGKZ46ZXrKqkz8EvuZvhFOPClAWuGTAQA
	lp3JiW6oO/WXCY1gn7nhbAWkfBwA4yQeT3dqHqESaDIMt9zqQ4n1XpTKKsj3iA25CpM8Rt
	Wd5M+Ii1AWDQ3779e229NCe99pyFdGI=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2681660d604so27805755ad.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758372329; x=1758977129; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P2Xt5dxImFQDNB+zIOSzEq8xo9rsZmb+jmetH2dJjzs=;
        b=DEMXBDTWjbhaLgUy1b79UIWoPGrCqOiS3USs68rXuiKq/Aq8MIwn/9fb+GdSdzyqz4
         ULbwIwjmPTTn8YHnvrfEep4oBOOTbVAlwv7JbJf/R2D9bcC0jhDqXuqFZflwJaSDG0ig
         Bfe0xDLHkv4X7McQzBNdRgGCqwOxVBB688rlMpdoQwKzfgfWK1m49au8o0fgC1W2mP6l
         MxBE2UOSszTuIjSMxa4Bb8z28hOXkGo8aoqeL7Ybz7yaqBjm56kxNLS/ioLX2jW+x/QC
         ymVKZbtryuO5cdPlbVK5QmxuP4WVn6m1UxHvz7KEbxZHF7RMPOyuLqosck6DyVYuNjwB
         u/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758372329; x=1758977129;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P2Xt5dxImFQDNB+zIOSzEq8xo9rsZmb+jmetH2dJjzs=;
        b=jRa72C+yVByjwQR6Ko68V1PZ61CKv1tV1v6dFyDTjzawjvkWwQy3/FEV4lMaa2rGcP
         P0m1+udH3fdFQr6q7m1GcJVw1Pf7DSnltVBpOKyAK6XXb3khcd7VzIh03bxYU4fQI2xr
         VtvleKg9jxvt86sed3j/RZfwd7jpDglVagi52FpE74EHZH9hKO7lRv4AmFQsJWNkErIl
         o9Si/+UGKOZcroyVS5vY1D/JoF3M9xyLtr5iDE6EYs0m6pN0sMyHDBseOA28m02bJkuz
         nQhHATKcLSciuZd8ioHUk8vDC0YVEonzt8DhPn8FvJFKZ++v0ZABGNAqlROxFB8aLit2
         DUXw==
X-Forwarded-Encrypted: i=1; AJvYcCWh7HdUkOJ4/MiG7Tts37QW33Pt4Hs8I56qjmPnjYaGCCX2d3jaGXbIy4fMsvd4UqbwegriuVFm6A==@kvack.org
X-Gm-Message-State: AOJu0YwgL0KViQ0Myu5WueMuFDQutX6tYWaora13um3DModgZwVMeol2
	Lb5yM7h39jk/Nv9ubO3BN+xnzbQSyL5olkmVqiEc4tq0VXYWE6nNCnDMadHRlGlVyE6QrK92G4L
	wpsUFBjOOqmTbArSPN5a9mAPwG9uLFn8A4TNcKlT9
X-Gm-Gg: ASbGncvDJIdq6hOkxJIDtvXNJFR6v6PlOMhbKbCXdn6hcNoKobbXK1g+D4zR1Km/1a7
	aOV81Hg9ZsR+DNYP9RcddFS6X0VVyfDaW93T5aVgIEzFduC76yv0n2MpdoWf5OPcqyqNrPxAXn8
	jKoXDwD/z3xr1Hdfj9hFDEyADMHkgDRkDmtYszUAVgpvZix7L8KZ3xAaBR/yFhDI3ACbWPvLPPI
	yJzmKVPnUC2krjXzct572hjHGyi+rGOAqiDgUffuJPizr2c
X-Google-Smtp-Source: AGHT+IGp/N/ayplQqKKBxnGs6WOfyKUH/iITNGJNC3m56lH0ddprjnIe5eKw57ece8B9TDbj2UEYyt+VdKNzNYtu5ro=
X-Received: by 2002:a17:902:ccc9:b0:267:b2fc:8a2 with SMTP id
 d9443c01a7336-269ba46f141mr83309515ad.23.1758372328847; Sat, 20 Sep 2025
 05:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de> <CANpmjNO2b_3Q56kFLN3fAwxj0=pQo0K4CjwMJ9_gHj4c3bVVsg@mail.gmail.com>
In-Reply-To: <CANpmjNO2b_3Q56kFLN3fAwxj0=pQo0K4CjwMJ9_gHj4c3bVVsg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Sep 2025 14:44:52 +0200
X-Gm-Features: AS18NWBli1y9TeOySCtz0PRORw8H0Rr8apw4LW7wblD60qoNXqS9BvtJEM0Stlo
Message-ID: <CANpmjNNkRQmt1Ea-EsSOVcA94kPqH_WntdT-NGnTjRocT25tFA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 440FD1C0009
X-Stat-Signature: hprdxpad3bm39169mqh8xyn3gr4c3aum
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758372330-703478
X-HE-Meta: U2FsdGVkX1+hTb9hEfpn7D+vgv8fB6Fqds1f/Z5v9q2RjbxNQzT+oWQ++i3u1mEJ9N+xD0jkmRFWyUT9WVnZgLX4QwKBb/YJoatLAmiU+JKrvqbcVcbzoWLNqwQY+iYGEsoRbupwUNQlt6xUqg2n1BgX+CeBAWvkoyswVlnJzktDfOQFMUsslpA+2zUHGQODbg5iDmt0I4HfKIDzuSght9bnrpBub/T7VHvedNX4bXZt5ZNzmTSTN86jz+myQNU41Eo9+xNmBBLBFt0MU0KVSyAtG9fXzmDrsNbToVvAdC3PAh9OvqgwoF9c/Wg5malaeGt8BrNbaU8fNF4PxRXkBpGeDj0A5WC3UV+JCnbq10detV7+8O4CLChZXruZXj9G+YWyCBbUrT3XGO6u5WvLZe8ZiXbs2E7pp6bN8Kb+JemyDk7VnCUm61WxsBPI6BLmxEW6C7CMScqrUT28dL9N6H56EAJrJlCIyxuRBLsfMj+s9hssmr/VmU8PB3ZkdiHz5WLgnZa9OZMCRrzNt+cZfUWhNjkO1AlFuOgzXSNg5bGqnSA9NlpbpXsv848IZ9jXKn+wha5O+PNu7Kr2mGqhmyVQfEe0/Tv46aMr9nsxpAIOZ17KI6ZPIvC669m/dsczNnCxh87rU6T71aV9IDZQasZQIinhOOtC8aYEh39ceHAoaF9K1RPG+MARPVR1aSi5qp0rOKDoli0KidIFjMErvwX+Bks6wHX2fZdSoY+M98cqviVt1au6S3lqCxNh78A06YsJeP8KW1ubipTztKxjJtXm1+zdbwf7pSJSaVyisWUAJo9urxYrHRxQYVImlAXZwAikItd5GMMYPSHPKqjvTuJY1/4eQLwJlT+3K0MjgZ54FJp35NomvNH7tIjlUn48TebZZbsYZIKKYcSmrZrhV5y/LQJ14z2gSD7ScoH+1/DHcJAUTlDrAaROUoykySVYS7lhhFjGhCLFCDtVI0j
 6yuFLx5B
 HdRCOWnJojsHwdBZE+J5YLsfKw36wEz6v6N65PAOqbUsf6oPMTxwi+25YWHbnoL/FPcrN4qTWjx/Mvknkta+i/3T32Y7ePUniY0vnCS0M48FtMnXp2vOF8XTTfhRNsk7LZW5mHRCrLh/RBGBk7XyXwyOadofN/s1mAo+ef4dxAo/KPOC8caDkpAV0V1ODMLzR6y88O5iCGoPWpCp/20CUc2DkxurTnqb57TnODIcXojgkCfXDUzQVUw1wmADreRwHa6SYiQg8N7/vOiID7PJPKVoK2pyNC/JVeCrhXBCkc4/rJPc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Sept 2025 at 12:23, Marco Elver <elver@google.com> wrote:
>
> On Fri, 19 Sept 2025 at 16:08, Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Thu, Sep 18, 2025 at 10:45:55AM -0700, Nathan Chancellor wrote:
> > > On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> > > > On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > > > > A Clang version that supports `-Wthread-safety-pointer` and the new
> > > > > alias-analysis of capability pointers is required (from this version
> > > > > onwards):
> > > > >
> > > > >   https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> > > >
> > > > There's no chance to make say x86 pre-built binaries for that available?
> > >
> > > I can use my existing kernel.org LLVM [1] build infrastructure to
> > > generate prebuilt x86 binaries. Just give me a bit to build and upload
> > > them. You may not be the only developer or maintainer who may want to
> > > play with this.
> >
> > That did work, thanks.
> >
> > I started to play around with that.  For the nvme code adding the
> > annotations was very simply, and I also started adding trivial
> > __guarded_by which instantly found issues.
> >
> > For XFS it was a lot more work and I still see tons of compiler
> > warnings, which I'm not entirely sure how to address.  Right now I
> > see three major classes:
> >
> > 1) locks held over loop iterations like:
> >
> > fs/xfs/xfs_extent_busy.c:573:26: warning: expecting spinlock 'xfs_group_hold(busyp->group)..xg_busy_extents->eb_lock' to be held at start of each loop [-Wthread-safety-analysis]
> >   573 |                 struct xfs_group        *xg = xfs_group_hold(busyp->group);
> >       |                                               ^
> > fs/xfs/xfs_extent_busy.c:577:3: note: spinlock acquired here
> >   577 |                 spin_lock(&eb->eb_lock);
> >       |                 ^
> >
> > This is perfectly find code and needs some annotations, but I can't find
> > any good example.
>
> This is an interesting one, and might be a bug in the alias analysis I
> recently implemented in Clang. I'll try to figure out a fix.

This fixes the problem: https://github.com/llvm/llvm-project/pull/159921

I guess I have to update the base Clang commit hash for v4 again. :-)

And thanks for testing!

