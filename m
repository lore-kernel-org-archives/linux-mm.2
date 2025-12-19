Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429DCE66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07B06B00A6; Fri, 19 Dec 2025 16:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0D36B00A8; Fri, 19 Dec 2025 16:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8832A6B00A9; Fri, 19 Dec 2025 16:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74A926B00A6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:03:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 126D9C06FA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:03:37 +0000 (UTC)
X-FDA: 84237446874.19.F20B3AD
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 211CF40010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:03:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Xn5fafQ5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766178215; a=rsa-sha256;
	cv=none;
	b=H4FP3wtVDqVpjEcwJxUg8VrDC8QT3yeJkFKh9Xa4orSDex0O6bKJQe6qgW+8ILR17nXs01
	d6CbHZR1NteKTzB92Kb34U7g9q2+sC6nHgzhz0TbKP9i2rlk+WAVWwB3LzUZSIYp4qLCM4
	BYLs2OgHEu/7AxpvZEUIb6+jqxlfcPw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Xn5fafQ5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766178215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=de8pCxnipY54b0+yxIRceTprHyPFDweXvtkEVQB+6ZQ=;
	b=A38fvfggcCZhZT2Q7jY41BY898mdHk/54BcR6ldBdkwPqQc0AvuWryJ1KAKykAHqkVHbgH
	FqIjH7Cupqgw7stpto1XDMT7ME5wCjWAJdPseppJ1+j84ch/xmp4RxY3VQhMHYar2WQ96K
	811t/y0R4F+f4g6KMUDnt9NQX6SAqfg=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c0ec27cad8cso1323961a12.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766178214; x=1766783014; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=de8pCxnipY54b0+yxIRceTprHyPFDweXvtkEVQB+6ZQ=;
        b=Xn5fafQ5I0t0OhbjDUYpuQTKRnEdvdDQibrGk8OQo5j/PBJ+i9H0mw5wWNWF15GpRq
         cSYWl9DthgWPIiwDobIPsSHaGi2wWCKvkJd7/zz1USOp1fVmvWXaMEZ9+3JeapkIW6Ek
         uSL7niFJCxQmLFrahTTP4wZhIeaQBSsydk4WygXW4HzazjqkGK3rXEVcsgiXO4tB9nN4
         5rjsM1hSuD8x//MWDXRMtL6j5BSYpJ8jeISGhLXCCszey6z/w4F30++jXOlxuJ3NGyH+
         ZU/2dtPQhEaEZ+GTrA3jaV3ogqJ2+M+1Yov24zZKbvSZ2NU0PcGiPgV3dsMyYeanZd5a
         /CsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766178214; x=1766783014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=de8pCxnipY54b0+yxIRceTprHyPFDweXvtkEVQB+6ZQ=;
        b=ZtG7iXr6tFLynUNqhPJuiTnkluyX2sFX8SsIlb7zAZ/i8f90ErBTYYxMRo7trSv2oT
         bq6VJJIsJd5WgviEy8BXqYiIjr2Zi29RB3RkuxbPxNb6wF97zxoeQPiRnFkK4ddBkCi8
         hR3GfyQ+PHJFYNT6ee9A0gc2VfNI3KJMi+Bx6DvuWtKOtoeaIaZLbuON3hQcLYjQqiL/
         oD24wmZ3FyoV0ctc7S82dF0H2upcH9K7XYPIcT8pRNNogfVmsuujJQJXZYHpFzGFiiMc
         hqZu/fZuFzb+KMNNwwBBjjJ+RvvKyZILkhHrl3cB9ufTdCn8+Z9hwguUpF0a21PVf8Wo
         rGSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+994PuIWEfLbxtHtSKJhEtHb7cQ2v9k2FkYENs/lEkuQENzTtcaw9QGy8KS8Qf8/m/Cm5FuP8jw==@kvack.org
X-Gm-Message-State: AOJu0YyF/QS7xslTGyaDWVNDwB+9z4jtyiYKUC70PDNHOAt25szE3WDe
	i2f44RnsMJoAU8/kOmFcW+o7UxoPg/qRzrtVHQJRQ4uG79w33dq48/h0A/mYGWhUDPUc3g8GSXU
	NyyJdMk6fMDJcZ2SeEBGIn5mncRYByly5gYkwNQ5u
X-Gm-Gg: AY/fxX7zwRSiVvuHzI3jQWGDeAkaVRjuctclPzjgvu1ho732dW54dgLqzjzowHcTQ8a
	ExnQQeKPcb9d35SEbqERGULYUSPNbfNxp41bCLhgsMC27DLbeSp8IZWxvL3qfXRrxfxM1H7QYCa
	4u1gelShx44wZ1150gme90XlimklbkJ29IhAWvzZcra1voBN+5b5UASIps2MbR7FwriLgRyAI4b
	weDuytwWE9rM2xb13zdzuN3DVAtNvT5U5JpUe2mxOykxrGTHwYstWt+usoFB3ds3MK1qBV+rUlE
	yGvICVMDnJqhIpd7tDfoi/Ip/sw=
X-Google-Smtp-Source: AGHT+IFg+H7bSZfFX25VI1D2TcRvhiMGdeLrAoERYZ7E84os+Kz9RUi2WSmTBrf46N46WhW85ro17M8H8dzWFnHpZdU=
X-Received: by 2002:a05:7022:150d:b0:11c:e661:2590 with SMTP id
 a92af1059eb24-121722ba459mr3928518c88.20.1766178213442; Fri, 19 Dec 2025
 13:03:33 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
In-Reply-To: <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:02:57 +0100
X-Gm-Features: AQt7F2r1zeH05SJ6k_ASDq36JbXz12zcm_odE6qCh7vpVVaB3K5VKsjzaangmPo
Message-ID: <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Bart Van Assche <bvanassche@acm.org>
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
X-Rspamd-Queue-Id: 211CF40010
X-Rspamd-Server: rspam03
X-Stat-Signature: p1wjefgw4n6rhyoomdqms8bx8b5sepj3
X-Rspam-User: 
X-HE-Tag: 1766178214-92948
X-HE-Meta: U2FsdGVkX1+M0BNNN+UKEMfa/fJBIeIm4pGlO8RZKOeipUaVNs7kBtGbdiA8FG744WnLMTKnDiJ+XJ1DO984cdVD9Hrf7KvZSLpwsjtTrw3VFNuOOHSiaV3Cvycop2gD2Tet/0YyG8giBU6PY7/q0kCODpz02v60IG4A36eOlqWu+M4q79NAf4Av5mO3mlgGUh3Cf8BRsJi9mha1xWfTFIP8q4xjZvOwnVV10djb8QUAo/OvNZGaEngMM1ZBm62kU5qIbFkLeclfgI0qWP7HOGQKiKUGozlA188zbGUMJBcA6gZKlFEGZafg5Lx7zfkW8nvil6LHnZlPIvsDiPMyyKL393TZhrqI1/ZOwoAy64pg6Qs2LQCEq7O1J4DvxA4aVSph+DDVNkOr8fG1vp/1ftbah2I0AKXUX2NmuzHK7ndVRPPs2uhwoSVbqbB6SsqQ6ABnZgBo1fGrJQvFUELTR1mSpkxJiSSUA3iBAYgetOpPrDSQdYojVkv6Rb2lB7yFa6Av8JrovBBseGxamGGBHdvmlcCPa98ztdeQi/ocDAo8xOBwt2APu/fLUXW15Nx0NnpaAzYlVpZND5669lC3RhLq8P/BJ4bRao/w/T2G5LCJwz89iLz8VdOOdcqEbFDUU5hiocRgRJW2GInlGxDuMp9ZgnGvoqzzmbQdS3z1+kWwuLTBK53vpMo6lt6vwEBWDusR4uDKQqfCoQxuYwyMd6TlQ4JBf0BlQFFRQZpla27xVgG1bQZfmb9WrFoyLB6zl9XyL+gxI9oEdh1EGfVB9EhmReAruLBASl9VYz2x0KyIMbdFh1AW+MmvtWEEk/3GIMd3IGvvMx3VyLYt+h2b2i7tmHT6VrWRSyHVA1uYu0vmu+TQlRSH9mX45MZP6rWw7b9C5hzaqKvYUsK5pnvO2o7S592byaK3SanAWSWnaaQ195iG/CucRoBWm2WvE4ydmGd6bbKTatUUSi9c1cK
 kqjR6OCE
 VbtrnSkuqRnobPWCcuxc2aG6BuVkKAn0PLRRxCUDGIWD2SOB+U80K2swtwePyoI054kHHbOjjBvTJ362r8iJYrHxaO57TAjjmhO1AXPX40lFhA1UE/QP28MLmqaSvjFVxUV2fqeiqJlmjpLT34l67pqRHqaXwopefbsTXO5AtTHCf1sDz2CG8HblIGRLc+BC0MHathhjAhETeRXQHoovoBhxJbLhlbJUAfnJQyEDk7P4lBFLcdMNRCF7S9DtYy+PuTTi5S7yxHdPB3wCrRONjK1tsyQmmDv5UbtsDP1o3dGOR/8/Oc72aXfAOd6mQuw3sd5m/iVtwGbG64lKZI3K84eCDA0LxeQ7STUG2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
> On 12/19/25 7:39 AM, Marco Elver wrote:
> > - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
> > + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
>
> Given the "one change per patch" rule, shouldn't the annotation fixes
> for rwlock operations be moved into a separate patch?
>
> > -typedef struct {
> > +context_lock_struct(rwlock) {
> >       arch_rwlock_t raw_lock;
> >   #ifdef CONFIG_DEBUG_SPINLOCK
> >       unsigned int magic, owner_cpu;
> > @@ -31,7 +31,8 @@ typedef struct {
> >   #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >       struct lockdep_map dep_map;
> >   #endif
> > -} rwlock_t;
> > +};
> > +typedef struct rwlock rwlock_t;
>
> This change introduces a new globally visible "struct rwlock". Although
> I haven't found any existing "struct rwlock" definitions, maybe it's a
> good idea to use a more unique name instead.

This doesn't actually introduce a new globally visible "struct
rwlock", it's already the case before.
An inlined struct definition in a typedef is available by its struct
name, so this is not introducing a new name
(https://godbolt.org/z/Y1jf66e1M).

> > diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
> > index 819aeba1c87e..018f5aabc1be 100644
> > --- a/include/linux/spinlock_api_up.h
> > +++ b/include/linux/spinlock_api_up.h
> > @@ -24,68 +24,77 @@
> >    * flags straight, to suppress compiler warnings of unused lock
> >    * variables, and to add the proper checker annotations:
> >    */
> > -#define ___LOCK(lock) \
> > -  do { __acquire(lock); (void)(lock); } while (0)
> > +#define ___LOCK_void(lock) \
> > +  do { (void)(lock); } while (0)
>
> Instead of introducing a new macro ___LOCK_void(), please expand this
> macro where it is used ((void)(lock)). I think this will make the code
> in this header file easier to read.

If I recall right, we needed this to generalize __LOCK(),
__LOCK_IRQ(), etc. which do preempt_disable(), local_irq_disable() in
the right way, but then need to make sure we call the right
acquire/release helper, which require different cases depending on the
lock kind. Obviously we could just expand all the macros below, but
the current pattern tried to not rewrite this altogether.

There's probably a way this can all be simplified for UP, but maybe a
separate patch. I'd leave it to the locking maintainers which way they
prefer to go.

>     > -#define __LOCK(lock) \
> > -  do { preempt_disable(); ___LOCK(lock); } while (0)
> > +#define ___LOCK_(lock) \
> > +  do { __acquire(lock); ___LOCK_void(lock); } while (0)
>
> Is the macro ___LOCK_() used anywhere? If not, can it be left out?

Yes, it's the default case if __VA_ARGS__ is empty.

> > -#define __LOCK_BH(lock) \
> > -  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK(lock); } while (0)
> > +#define ___LOCK_shared(lock) \
> > +  do { __acquire_shared(lock); ___LOCK_void(lock); } while (0)
>
> The introduction of the new macros in this header file make the changes
> hard to follow. Please consider splitting the changes for this header
> file as follows:
> * A first patch that splits ___LOCK() into ___LOCK_exclusive() and
>    ___LOCK_shared().
> * A second patch with the thread-safety annotation changes
>    (__acquire() -> __acquire_shared()).

I've wrangled with this maze of interdependent macros and definitions
for days (though that was earlier in the year), believe me when I say
I tried to split it up. I think the commit message hints at this:

> Add support for Clang's context analysis for raw_spinlock_t,
> spinlock_t, and rwlock. This wholesale conversion is required because
> all three of them are interdependent.

It's like a carefully crafted house of cards: you take one away, the
whole thing breaks apart. If I recall correctly, the main problem was
that as soon as you make one of these a context lock type, and because
they are all interdependent, the compiler will just complain endlessly
about either wrong attributes or incorrectly acquired/released locks
until they are all precisely in the way you see them here.

> >   /* Non PREEMPT_RT kernels map spinlock to raw_spinlock */
> > -typedef struct spinlock {
> > +context_lock_struct(spinlock) {
> >       union {
> >               struct raw_spinlock rlock;
> >
> > @@ -26,7 +26,8 @@ typedef struct spinlock {
> >               };
> >   #endif
> >       };
> > -} spinlock_t;
> > +};
> > +typedef struct spinlock spinlock_t;
>
> Also here, a new global struct name is introduced (spinlock). Maybe the
> name of this new struct should be made more unique?

As above.

