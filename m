Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CAFD41C36
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540206B0005; Thu, 11 Dec 2025 08:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1076B0007; Thu, 11 Dec 2025 08:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0186B0008; Thu, 11 Dec 2025 08:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 295BA6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:20:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD7CF13902C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:20:09 +0000 (UTC)
X-FDA: 84207248538.19.BEBA773
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03DAA4000F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:20:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vRDSOONT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765459208; a=rsa-sha256;
	cv=none;
	b=z7w+vdNotcHdQ0bJZhO7dwng5PVyTaj439gd744QTG24b/NoHLygRacSXBgc35BUgdgWjX
	cDfV+q5kTCx4RbMFg83jJ65lNHkpJnyFT8ipmea/3WFrtS4PyKSilnBvssDh5Sn/GYeyhm
	UpWqv8tktin2dziY19WYXnHRIc8eCYk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vRDSOONT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765459208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aINMqpJxr1DSJJ7CC9TS1ttoat4qqoJbgL8dBerwdo8=;
	b=kZZdaRn22pn1/DqKNVBGUHl6satNGteoOsaHHvVxpbAdWs5oQYovW3xw+a3gBkDyXcMCis
	W28yTaCWVmQ6kHEz+xkkz0OQQtMOhzHZAQ4KGBVSXceDu8cCgtek4rZN7C1fPLeWNe0iXv
	m2mPu8L6mo25KGJD2pyFg4mSTPupY2A=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78c5b5c1eccso1098477b3.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765459207; x=1766064007; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aINMqpJxr1DSJJ7CC9TS1ttoat4qqoJbgL8dBerwdo8=;
        b=vRDSOONTj3IRUx6AqLyIEV1/Vw5m6CqEGONlzv1vTeFzH5m9kYEHGwRUHNwACqLILr
         chElBwSi4PEqvmIFyedUdgj1ZOxf16k207Qs96Sk70wY3oBlFG5pugyLYhDvM6y5Mw+g
         HkPQ5xU7zxsmRSDrkcz6uMwnVXJGyiOSJxKKatwkecD3colUTHkD+a61CdVPds1Y1Vx5
         jdNxKS0Ffroef3g0lNjjwaXLL54KTPtsU918kvPslHBQAYnoNxetDS3phDno9axQCXn0
         qmg5lsQrEBsGwAHs9rJBCrEO2wn9mnOiG1VkbJGBZAsBgJlNItFA44fdr55DWttJDuVB
         SSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765459207; x=1766064007;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aINMqpJxr1DSJJ7CC9TS1ttoat4qqoJbgL8dBerwdo8=;
        b=OFuYMOINy7WY2QNGqNX9TNiVa3BraMy5jrAJs0hh3L7Bf1wpNyOWmAe4S3kX72Rj+5
         JxVxtT/FaBj4V/bUzA1WMIBhMkzh3pkeAOBEtvP1ntkuhSqdkYqpiogS+iLdGRpKTWvs
         NtEmGm08meBH4GdxIuHkz2Yw7D9UIj8uVRuZbhYFaWrshg+vVyckpRXQPDHyGQiXwAUE
         savnDswnKeTbHlYdEpcU3RGuxzJFWTd9ZQbmCRfbxHu5d2yTD1F23z12w1ayr8jWzsbu
         BAcO5p8+sSyD1DMAN4jmRoJgRM5k/UZ/YJBwkaSGaugqZCHownK2St3ek2JdoQAbjweG
         gpIA==
X-Forwarded-Encrypted: i=1; AJvYcCVz7z/W4WZqe6vwBIsNQPJZGUrFwT76g1RRrP0x1907PmP9f/r3Ij6qjSEOa5RW5f2YMhJ98Xla1Q==@kvack.org
X-Gm-Message-State: AOJu0YxsRKHeEfUvrtdyCYCKUCIbBS1K+qSNxvSSFXg4CcKg32UyElLj
	o0WBunAzi/DL9JK+zKVtBAJE+aMQy/rS8gR4/LbuE/TcG+A9+lEt7RgqUtqWZqTNT/EFZIGc9bQ
	j6HQk25hp1YPvMpXp/UhT+e/mgjlnDpkpXsz6p7fR
X-Gm-Gg: AY/fxX4dzBbllfNPRy+D9neERXIW0biAbyvbMsMtrMGyhT6b7JuYspLhLEbWyGVcrjG
	q4O1JsEsu2GIVNetCIWkBq7XX0LxHgq0dlxN+zMyBtV3DQaQ1GNmJWkJcKqIoUCToordv+4gt5t
	l3TodFCak0qzsf6UUcgV6EHkOvqvsFgVjdRhz84BTd6k5ChAv8fiuV3+keLPIkmyxY9+T/Ko6Rs
	sRgUmMLCIfQV3RDw9fgZYAVgii6ON3qmxlfMVIW7AgVhu/jL7QGaSVC8AzMxwDUI+jtyhbOKl+g
	cibDjXcZPOzbA6nHixpmBAk8N/1dIkogXio=
X-Google-Smtp-Source: AGHT+IGU9q+gRj8IYb1h4AykO50aa48oSg8Xgu9uuuuWfwfeI68H5yAO2hlPZXd3hwVQKsk/WdTiuzJsjMsANS/WvBA=
X-Received: by 2002:a05:690c:14:b0:78c:3835:496a with SMTP id
 00721157ae682-78d6dfa0ba0mr18429857b3.24.1765459206488; Thu, 11 Dec 2025
 05:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Thu, 11 Dec 2025 14:19:28 +0100
X-Gm-Features: AQt7F2pfFUoFUVEdkJ6Nswms767xMhA__DttYAE1PqX0AgFhiN8dcasmhdnfxEw
Message-ID: <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4j4gqjsw8fk79f4hfp4kq918ppwkxkmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 03DAA4000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1765459207-604775
X-HE-Meta: U2FsdGVkX1/+QpFr88efq+M7v+k0H2OrxWnIg0Rqhv0o1+Yn4SGr5IfPDCHtPKPaFZDdVAqJLq/qRPxSLdT8jwRu20YanFo085wnsJWihKfOQ2bMnHixeyw2DZLt95qDSIc8qDn1MSSMUVX5T74exftTCckzMnwfwm9l+VDVv+ry2TGIerUXaxb1FQyz0tOLJSyPC9UL9NUxxYudMADmwxRN0Yk2he1SbtfNlhvk1EgqXGUNTWqgtxb9CRA3qyi/yPBUiA9oLEq5msSP2Tm5/dGtGBPl/ajb9AGsF87vzgID0iN3OL5vKDyMyemlBriWMRDkbB8hNj5R/NmxqBF4mnIiFx01WE7PuChE6wNjJwTpLRcThbHaqrsnjOdXCl/fSPlPuP1xSTxJESGWqgRiURvX1qunetKTw1wUm5oIS4HZdGx1jmu/XMav+1j7eN6BCyx4kjowMDG+LHo94BZZq/EB+4HtnV4NlCq+cllVW1Lp71mqtwprLkDOpvH7xNEcsyQYlwKW2922OJqKcE94TxmRKT0AmXb5kzP3NlNlDLBpE9BkxBiTF3AmQe3Z3gTq+85Js6U14kEDK47/vyjl7cMh9gMqhc7SJBsMhR5BKy3AZhndQZ+kgoHRdqmopT4hjsUFDEV7AUZnc6/o0m8Ce5ROlY3q42w1b524dxIy4lu8howIFwjmMPyku8x12oX/FrgcAo64DeYunYQrJLjJXLGp2psGcHq92NkihCkO1/wvfPVc5d8uYNQjJANb6aCnJL+GNn0pWWE7HyTP3NBilu507/771dBk8ve9k43RoW4pCvGUYqrzLfYjGKAe/p062CvKcR8PJ6sRAIls1KxRoqz719U+jdRIJykZ0VITPmYM5RA50o4+KAgtGbpthj1YTPDBSmH84wuWdibpWPxD/OQQslVpak0yeSBB7bQzMUZZChm5lHwoAU9zwfmUPE/UcbQtzeEyjmWoUtFLgGf
 PBPZCiqP
 oJnLmajW49ksJOp5O90of0+UcG3lUFGWJ+y2uSDg4dU7TWyei0kDoB4UyEaj6C66ddXhYH7ncGYYZKvRj51pOVVk7149kkKNKf675tpXYnBVr3SyDmey7cZcdvLR+OmG86inoyjcfFDqd7x8NZfezL8wEhUstO0qI/cYqY8DxKh+p+3nuEYmnz0T2BmKYNZh/gOcirg+iaPpleMcUXBatB+SXO8DsHHVaKw1uBDg4e1FlX5JiTBkW4e5FsP4P7qcyDNh0AYaRDdUXxgGhcVrxgZt2j1+QMFUeMo2s7CzcOKED0AYsNWmYOpxHt01/zLqFyLMgpAc4ChbRe3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 13:17, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> > Introduce basic compatibility with cleanup.h infrastructure: introduce
> > DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
> > and destructors respectively.
> >
> > Note: Due to the scoped cleanup helpers used for lock guards wrapping
> > acquire and release around their own constructors/destructors that store
> > pointers to the passed locks in a separate struct, we currently cannot
> > accurately annotate *destructors* which lock was released. While it's
> > possible to annotate the constructor to say which lock was acquired,
> > that alone would result in false positives claiming the lock was not
> > released on function return.
> >
> > Instead, to avoid false positives, we can claim that the constructor
> > "assumes" that the taken lock is held via __assumes_ctx_guard().


> Moo, so the alias analysis didn't help here?

Unfortunately no, because intra-procedural alias analysis for these
kinds of diagnostics is infeasible. The compiler can only safely
perform alias analysis for local variables that do not escape the
function. The layers of wrapping here make this a bit tricky.

The compiler (unlike before) is now able to deal with things like:
{
    spinlock_t *lock_scope __attribute__((cleanup(spin_unlock))) = &lock;
    spin_lock(&lock);  // lock through &lock
    ... critical section ...
}  // unlock through lock_scope (alias -> &lock)

> What is the scope of this __assumes_ctx stuff? The way it is used in the
> lock initializes seems to suggest it escapes scope. But then something
> like:

It escapes scope.

>         scoped_guard (mutex, &foo) {
>                 ...
>         }
>         // context analysis would still assume foo held
>
> is somewhat sub-optimal, no?

Correct. We're trading false negatives over false positives at this
point, just to get things to compile cleanly.

> > Better support for Linux's scoped guard design could be added in
> > future if deemed critical.
>
> I would think so, per the above I don't think this is 'right'.

It's not sound, but we'll avoid false positives for the time being.
Maybe we can wrangle the jigsaw of macros to let it correctly acquire
and then release (via a 2nd cleanup function), it might be as simple
as marking the 'constructor' with the right __acquires(..), and then
have a 2nd __attribute__((cleanup)) variable that just does a no-op
release via __release(..) so we get the already supported pattern
above.

