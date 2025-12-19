Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E91CE66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39506B008A; Fri, 19 Dec 2025 16:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6896B008C; Fri, 19 Dec 2025 16:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8FE6B0096; Fri, 19 Dec 2025 16:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D13B06B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:49:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 513BE13ACC8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:49:15 +0000 (UTC)
X-FDA: 84237561870.22.05C84E7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F4CFC000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:49:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="PVVygbR/";
	spf=pass (imf22.hostedemail.com: domain of elver@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180953; a=rsa-sha256;
	cv=none;
	b=BWhW34mfPcmJ4fTXqdjzmBI1kRMPQKi2ilR4TfKDYPEJ9hZPXP1NyMpR3OP8yym7CYu2Ll
	R6Nosu0I+Itsf9czxTdFMuQq1Mp86tbRnPT7UEmiCHsJCOamyWR7mHfqgmulyerU6UJNah
	lk0u+kvrmXFGfxEZvo9jz8nmRM8SXow=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="PVVygbR/";
	spf=pass (imf22.hostedemail.com: domain of elver@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzDuEDjTM8ZWLDMfL/9YFXqkNSYfSWOUAvfjFgQokA0=;
	b=foVgCbQj0iquC3UiNDNFqOJP+pKRJ4MmN1LkWuVMExnFVYZuI34QMsOVkgX6sbiYU8ZCCq
	dsiXUku9dsXyaCS/Y4W/i1KDpwoLuac5pDczCFmD46Dtyx+OtJWBvOg8E43W+Jbtu4vmyV
	TjiYbeQsdemCzd2CSTyUMzx1DW7198c=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7baf61be569so2515584b3a.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766180952; x=1766785752; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NzDuEDjTM8ZWLDMfL/9YFXqkNSYfSWOUAvfjFgQokA0=;
        b=PVVygbR/YC/dmNwGdyJ24U/gA/zUlKZYkCn8NhR1Ujfx2Gy/qCLuSZFdxmJWJO8nu1
         wGFhgcHFAYZk5xUyZgU5Lj7V8VbLrsXe2lsppOwukgnUNy9meR5sFa/Ru+6TBo1upze+
         3xbvXPlTkOIMzJDSW/pzZQVRmRREAP1FOF9EkEz+96KU/oWqtPiU973bl71oW/qLEo6m
         sV3r+1hfZzOI3fi4oyyK1IjcCO483y57bVoR3H3ObeOI3RNeEQ2FMRXu30IazakxXce1
         ci1H3DMy8jOofLgct0WqI7bdoDdFxMS2hYGa1y+BCgCxS7lkC1sVRXKfWf0OLK68yiWl
         4nLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180952; x=1766785752;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzDuEDjTM8ZWLDMfL/9YFXqkNSYfSWOUAvfjFgQokA0=;
        b=aZ9E5md+GcVScCpxZBFiwCz2FmYGpurWDp8xQ60g63Vqf42BkmfoeIgGi9l+OZy//M
         LoQoQv1369a2KcBjxMFEtMlVqp9gHYx4T7G5YafVPpM7KU9i4WUCjzct1vq85quO1dNs
         ZDLlzfFjNiBwETlS1uoPYd/Dquhb0kZYNVeGVgfxDDzsuYDHbmhgSoFFN4Rtz/ZyaaB2
         wJlgflhgautsNWyjm1+Ltz28sGLnlEjtN43kecs5gxQsJnAfyf9DMg5X2QT3tG5WAi7k
         Fc8GJ8cTaV58YO6vc0BC3c6y4qOYDBlSycTk7QQM2COf3rWOn56HOhrjVA8qqdBZo+GT
         Mt5w==
X-Forwarded-Encrypted: i=1; AJvYcCU65dgdQ6JWUXAPAo3GQTDhOPErAoIYr0Kdnipp4CRpRZSRb+fGipii5i8F7lujwKZYuQq+CQiaIA==@kvack.org
X-Gm-Message-State: AOJu0Yxs4sr3DmEFHlqnNiRdRamSHfrXkeHMxoPoyfy9UbBqpz4lUvKy
	8DoySeh4rp5PZP4d1ji3aPxrvhbh0qFMSM0p7tjFH7n98J5AGw4lBBM4m562aXcgfi2WCDe0k0q
	n67euTBHS4bZgbChphwzXNpyQtllbb849mlljJaKS
X-Gm-Gg: AY/fxX77/ezZ24TcqpPIRBzrCW9mygsbPwGZWlFoycKHWXmSvoIgC1j0KzE2OHHQD5U
	MDCr6wF7FEM9SqdnnOUZ5EyLacqKX2l2cOMuZ46i6cYlhf8Gc5xrYHvOck9Nn48bGV91dkH7zF6
	pN21YgJKiIgNpBT0irludvz0Cxhg/b0qZ55ISQD5F40UtQ1J3MgeiqvF3SXBvLmyaG+BlOfO9oS
	t7xGOcX8DFu5Oh0ruaNQexRsE3fuQrWaPHaDfl7boHjdxvyN8993fApkLPJOfEOrWclT5rZjaiC
	m7Ug64UN4ppdhd4W1URj6mUrtGY=
X-Google-Smtp-Source: AGHT+IH1wb+RKJ6da97DpXPpqA5MRT8qx5b7FDx5k2pjduqaEcwfYWMMGR5Rn4FLqe1i8Vtg4dzqeBXKvhP326Y4ZH8=
X-Received: by 2002:a05:7022:213:b0:11a:4016:44a5 with SMTP id
 a92af1059eb24-121722de1e1mr5781198c88.24.1766180951816; Fri, 19 Dec 2025
 13:49:11 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org> <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
 <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
In-Reply-To: <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:48:35 +0100
X-Gm-Features: AQt7F2rGv_yg31bAGJRVSa1c9k6UbjL-L12dGmORxx_mEF1TxDypAURYmp5bQlk
Message-ID: <CANpmjNN4JNG1OSWfGd2fAqTyYQ+Re7Czn796WD-47TwmuECxaQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F4CFC000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 6sftnxwqawdp4ew5se3sqar41k7zhfoh
X-HE-Tag: 1766180953-425297
X-HE-Meta: U2FsdGVkX19WW8PL989ycRQBEY5gZny+HExi2nPBH2iHjYM9rgdpsn1MMnKrvqufOe6uGhn/mH2X1ES3s3g09ThppppyNErQ+ZsBKSGEMf2kDntFZOzwR2DSh3ma0JGfUM+KQtLK4rgr7Jmtn8AjJ4/lylYkxa2qhbZpM0X9tsLfhDkcgjTvKv8G/v4Lo5JeMNu9J4WJKwyw9dyA+0fJKkWRmx1McVXV13S/jw+1UAN+eOiF7H5NLEKyIZHlGEWuYjWIYWVSiHTVS0W4SPTtw9zHx5/OJLVo3B1s/TRKTLPN1mC9MkUwvARs3Kjradu2NeNFJ0ogFGM236igJwj5Hqs8KJ6h0qNsdoKgkgXICXibR4rZKsezTyE/MAuVbT6aZbulegc4q3KcOuyRptNnKpZvJ9bbH+9OgC5Xzhgv8SejAhjIUWIl6ADBU+4VAx24C4SZ8l5zgpXqsPMaovV5Zq2mwkGyzlnhdmq7/9QYYAPD8Ly2XOX+uh4kY+IHk8IAa7KpDkuGNYzqCi1Gwn/5HXHnX2LstWItVqd46FqZHOHcya2tuSSaenMF7xADThbnwLHHOMS+gbCmOXP2yYL9giQ2EarQk4Yqvq1eXB9zMegGGbRZSqZ0vGDm5Qp9XlpCquPXdR+lxEAykslqTvZjEsfeuMJP8oiezHk99w8+5N9gIG6xaCxzLBzsGVBfl+sTaw//K0lzWLOo7RLh/SeamNXGpqQi1f6HrpuEXXdEH0lihZHc9DZmaIzzMO+xJiSQz+Vu1QXXxKiIlYVAkVae320PN195EWmOsT0C9ZmKzLs8537XUJ+97yR/n5iPHzcauBeizrowkH/v64i3j+71lp7bEQAY5q8e5wVVOV9uEutajPIdrHbYRjwmYlUBt9QUsV25imrPsGic2H3ei1KzAUwfMRzaproBFcTeoa9p1Mq/4gw1wlROfCOzi8tYymqPQ7mg3FDFjnZ18GK2xN4
 SDjRQeY6
 H8adl1lZ9MqmuUg6mDT0egHf3Lo9Qx/cd4ME7ZKDVmFo2RPALMZyAHR7Dm+6/Z+G/GmBan5dqsCHlocqZCtK8Ftn7cmsjvPgvpunUV/k0cCx8q0G/Z3jGmGth95Nh4SgLLRhgmypoMeQqKDhSjwa3Ncpa8acmIsZYoPjOw7NJ0AYYg7iincF45XKbuKZLpffM5YAf098uAbPiHr3HEvSzMyIiwHxcW0/zVHmw/NbCWP89V5NTWy9eyobwPhwocnt06ccO1A/fPF+nYTLoNW0Ysb0OLrsuHdOAzvbU22ye+xoTk41DSz94RKI5B/GT6UM0JQ61/RUwTYqLl0GvSXA1+7dt149LJuSjpp5s/bdH1gVzrkQgRVXQX6+ZgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 22:34, Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> On 12/19/25 2:02 PM, Marco Elver wrote:
> > On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
> >> On 12/19/25 7:39 AM, Marco Elver wrote:
> >>> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
> >>> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
> >>
> >> Given the "one change per patch" rule, shouldn't the annotation fixes
> >> for rwlock operations be moved into a separate patch?
> >>
> >>> -typedef struct {
> >>> +context_lock_struct(rwlock) {
> >>>        arch_rwlock_t raw_lock;
> >>>    #ifdef CONFIG_DEBUG_SPINLOCK
> >>>        unsigned int magic, owner_cpu;
> >>> @@ -31,7 +31,8 @@ typedef struct {
> >>>    #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >>>        struct lockdep_map dep_map;
> >>>    #endif
> >>> -} rwlock_t;
> >>> +};
> >>> +typedef struct rwlock rwlock_t;
> >>
> >> This change introduces a new globally visible "struct rwlock". Although
> >> I haven't found any existing "struct rwlock" definitions, maybe it's a
> >> good idea to use a more unique name instead.
> >
> > This doesn't actually introduce a new globally visible "struct
> > rwlock", it's already the case before.
> > An inlined struct definition in a typedef is available by its struct
> > name, so this is not introducing a new name
> > (https://godbolt.org/z/Y1jf66e1M).
>
> Please take another look. The godbolt example follows the pattern
> "typedef struct name { ... } name_t;". The "name" part is missing from
> the rwlock_t definition. This is why I wrote that the above code
> introduces a new global struct name.

You're right. My point only applies to "typedef struct spinlock ..."

