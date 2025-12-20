Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37170D78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 12:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DA16B0089; Sat, 20 Dec 2025 07:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947546B008A; Sat, 20 Dec 2025 07:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849E76B008C; Sat, 20 Dec 2025 07:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 734496B0089
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:52:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F89F8B391
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:52:53 +0000 (UTC)
X-FDA: 84239839026.17.987C34A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4280D4000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:52:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4GUu1Nz/";
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766235171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbJUZ0xTndCf3VdowDat4Wdfn4Fu9I8D0dKSNYqhcFE=;
	b=JzWqvpYpDp6TffbvxDA0FRGowsKBBdiuRCZYQwHSNgb9v+Q3tYwW5pXVGD8ukU+elM6LIa
	97VnTEU6tEDsD78epHY8VLlAvLMSHW5jS7HXxwyv9ViHaDdI99c5lRrnpPCFHyTrTYON8J
	zcI9JZZeoJ4KNqMLd4pQbbb5aZwZiOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766235171; a=rsa-sha256;
	cv=none;
	b=hgiUDY1yAKvsMVG6mvdqg12PNqMlUMzPxNTZyE9STRWWSzbc8DQW9ZpvYUXrFJVv9blEzi
	/EpQEuPiIl+RNo2m/s9Y4ZgZrR9vlBeZ0nL1qJK+M4na1yWFGxBKOeZfO5s80DSNddGF4w
	4rCl4HFvE00U+MSC3c/5sQWZKPY61Dg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4GUu1Nz/";
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0833b5aeeso35676895ad.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766235170; x=1766839970; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mbJUZ0xTndCf3VdowDat4Wdfn4Fu9I8D0dKSNYqhcFE=;
        b=4GUu1Nz/x36+8QCRUn3PTLOS9ak+ME0HF34i2r00HOGnhLiwqH6M26keyydChPG85n
         T57aGaf3dr3lutYo3UxF+4c2uk5AWbW5SkKJZ5Rr23CBJwBFtqLa82e+GM5bOjVTsW4V
         TlxXqMF+AwaYJI+kcFPs1LPXN5iQJL9ivRoSN613SdkqNZtlEer50AXll/R2Q457OsjG
         bBSTMYk7ybpzIPDlcdqkjAJPa3QgAfRknzK4JPmZPBrdQdf1QdERCtFThNlS8XK4sSjs
         JFjKg8iicnfeOxVNpWevXwjiL8T6xav9OBzQtWYsHM8Fuo8lW6XEOzWt8W8llzyUN/Eh
         gD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766235170; x=1766839970;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbJUZ0xTndCf3VdowDat4Wdfn4Fu9I8D0dKSNYqhcFE=;
        b=isuOGGMGPXVrKI6eZOjosRPTeWNugGRgvUkC7AJg1HIK+Q96AXmLGh4TY01VeuDT8J
         IWBVS15wYI/x19zJpri7Qw9Om/gARF4srMr+xWG9MhR8FyjCkrXNuytsjgNSCEe75BSL
         LiSUY8kFlUIA8DOGg4mluwDloZ2gywOCeVmf1OV6UXmw4AQyo/s3JZ9BkY26+nJoz5hb
         t6c7W8Pl9hf1FNSxTiHOrS0d1ye74TA3vaYBds+wae77g9JULJGh12tnp2mmedhXfHIA
         n9/WvAyH/K+lcIUWXAQzaSQJHVFpYmcCvqiuiXaZroHnzf/3GRbibBJfA4ESD6rbKGn8
         Ad2g==
X-Forwarded-Encrypted: i=1; AJvYcCWHIpLQXUlSTI9a2QJQ+ATjZ6sXqfCi9o44doe6pPm6Si0h7AIN+ByUyUmPObx02bNAiAuOd75jgw==@kvack.org
X-Gm-Message-State: AOJu0Yyg4cs2oEvFAT29zdMTvGSCUelJKzscUpRkNoU6sSouc1sDdFQQ
	DrpY+x+658nqPHJmTmLOoLSCxgbVKusX549jvUuogFmI9mJ3sp9Texxj01aOujhBHK3o8coqRT9
	EOO/OB6KKzmFcSO7bQs9lNy0BttY95gRoLBrsmV43
X-Gm-Gg: AY/fxX4dm8exhJ/Dk+7Rcul5Qh22NNVngkVqbvuWB6Egr+mbM/RkaZkJ/lIgTyu2Huj
	28CFLbEnwEdxsCnYHsOgRDGz1AyhS3iGQbKVy+ZbsAMfIIJuPi8bwfyc07uaxtIwbtq3Pm9upo9
	pJ7hnJdzsqwmoFudUScytG9VHOOQ4R8F3ZFcRloWn//n04Le/q25l2gG6tpb74Virfno6ittVnR
	DnzC/7lNtzHMnwpXEtuCz8tHXqiYRuntk+8Kz4GUEy3P6y6Kt7Tb2l2ooGc8mrzOorYJBUTU4Uy
	sKe02HqOIN/h0FtBSiOUatmWaFU=
X-Google-Smtp-Source: AGHT+IETmgOAcDHbF6MqcLCKTf5epOZwA9tGllY35Ia+ZmQjsZsBscMmnIOEXdoPmuZFimi3nJyivgIHK6DMRk5k25A=
X-Received: by 2002:a05:7022:6722:b0:119:e569:f626 with SMTP id
 a92af1059eb24-121722e0444mr6670285c88.31.1766235169708; Sat, 20 Dec 2025
 04:52:49 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-18-elver@google.com>
 <81d2defc-8980-4022-a464-3d285aff199c@acm.org>
In-Reply-To: <81d2defc-8980-4022-a464-3d285aff199c@acm.org>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Dec 2025 13:52:13 +0100
X-Gm-Features: AQt7F2oG2tk1HNWJ4txFgkKVTgQOAoxLExF81nhreitjIuVCBm-zQmVADhDjpfw
Message-ID: <CANpmjNMAGYeFK-jYafSihmA+T7wi3zC8Sb4fJ+ZjzDK5jGuMvQ@mail.gmail.com>
Subject: Re: [PATCH v5 17/36] locking/rwsem: Support Clang's context analysis
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
X-Stat-Signature: bdwzic6koxtbrukecd5yjuf4fs4hsn4a
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4280D4000B
X-Rspam-User: 
X-HE-Tag: 1766235171-408518
X-HE-Meta: U2FsdGVkX1/FHAkEhBA2pE6rRcuEDTIwCHN2wp2nPXytZDEI2z8N8d3s4pWIJbU26OfkaOzgnbmuQH+K4e+lJGVuyMtSEkoE/V+Cen9EpszFPargSiHZvBVLmrFxJJ7rk6rSeKxx7Y2GVn6FRxiOWr6MsBj+BDa3sZD+WV+w3sWXRvkATuW/YpERxoh3bF2xX/gwSO19qsDS9EFC3GBCLlD4xHUPZ3OmYYzVEJNqHm+IDHPzZK6K2nC7A/rfJ3WTM7m/mjKeS7uzPknfXSbnoGyycIzH7A6wGLYoCfVjb+tYz6rvtEQvFrnqSIbbA6mVoyGFcNaYl4Sf4kX2gUh9ozebFGeGT5kjVR3AUCpTXbC39Nd5aRGbATEQyCArUAcmqnjHQpZXn9FaYu1Ms4ugbFqGumj3h+zve38oDHiiWLonFq/34cqSpHmfE67SlnaYQAq8e72mOiKpnLm8QGsUg11l1eRydKye4A+rln5k2ihlDjEqRDa0Qw6GxHzg//+bqVSBVzBQKfvXiES1qci2/zkhOay2gCw9s/YgDPjXo/c7oLtWmOQCYBDPg6uc/W9wVPTw86KEYlU8i3ezmDUupFTxRfRi1K5IFXE5HSCw/1NXv0pJq/Ith8iyOrB3wpnKRTgn9vbvYUVQwXQkqwUqBu0oz5QbNI9jB82I9Xw7wOOOQqEzPvW/ydgQXtq5C4skfoqISZfnVmIT18VvowAmfSghVOXAyfeBQoSEa1kAsq/OoPGcRi5VU9bxeTNCpXUEtfyDb6dGCi/ji/SlpRxkxZ0pGJT3h6g7x2ROwHP7zsC99n/3kvm+n+zbreYRASkpFVTWU/PbUL9+Jq+5waJS9Dc/9Xl6FP+R8BtpQwyx600+LmO0XThL1o9Rlc9j9pf3lMnskykydR0jrWoMOrd0kahi7lkSu2LWgjrjTCQ6yzu7psoQECp8IyrCMJan8Lo9aOgvdRjxI4cXsUZgsPx
 TvGiTSqZ
 l9ynCUgtTqEpKz1S8Qh61ZyY8i8le8WefGjI48UwmC6NED7xjHXg0t6xh1wmQ/zBInpgDe18Y2EwGdMk7GPosVlZFp6TjWjICqGTr2hooOJ0ZlpKhMhJrsZICyWlRscmho37bdwzqRPWQtutE5h2gKDnxiWSHh8Hdmj3pXW93JRrrv7rikvuG/qUbtwCyti2cJ5Iqh1yV7Uqk/pF/4ESx8L3dAGs70wyr8BRsqdZ+rByCQo1JL1/9vDNd0EpP3ag06DOg/SynDApIQCFhuaIYt7MfJPv7+smnE4hwQezeIdzRPiMi/Ea0YUyIjT74QWlUQN78PUDFdQHzDB1UmJ+DGPXmOBMwfPMqIH9RiwD7truexo/x9rq84bPaQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 21:55, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On 12/19/25 7:40 AM, Marco Elver wrote:
> >   static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> > +     __assumes_ctx_lock(sem)
> >   {
> >       WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
> >   }
> >
> >   static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> > +     __assumes_ctx_lock(sem)
> >   {
> >       WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
> >   }
> > @@ -119,6 +121,7 @@ do {                                                              \
> >       static struct lock_class_key __key;                     \
> >                                                               \
> >       __init_rwsem((sem), #sem, &__key);                      \
> > +     __assume_ctx_lock(sem);                                 \
> >   } while (0)
>
> Just like as for lockdep.h, I think that the above annotations should be
> changed into __must_hold().

My point is the same: we use it to delegate to dynamic analysis where
we reach the limits of static analysis, to avoid false positives [1].
Code should apply __must_hold() or __guarded_by() to called or
protected variables respectively, which is both cleaner and the
idiomatic way to use all this.

[1] https://lore.kernel.org/all/CANpmjNPp6Gkz3rdaD0V7EkPrm60sA5tPpw+m8Xg3u8MTXuc2mg@mail.gmail.com/

