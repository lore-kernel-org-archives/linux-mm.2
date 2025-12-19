Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1ACE66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F546B008A; Fri, 19 Dec 2025 16:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C326B008C; Fri, 19 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AD96B0092; Fri, 19 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81BD16B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:17:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 360DC1402C3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:17:16 +0000 (UTC)
X-FDA: 84237481272.09.79924AF
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59A45180008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:17:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TADNIt5M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766179034; a=rsa-sha256;
	cv=none;
	b=ZNDOBlBRgYAVqIscbFcGj2ptgBelnLTOGSf3iXGWHHHhSs5kGHpu1OAfjJPZdOL5Ai20OS
	46JbXz6Mex2IWg86+jDJZyJYG36DcGtH0uIharpFQc8zcXEiKlK4KAgyo3tjPSSkcjyp89
	fcxNsyWkL1PjLBG29fV6vqPUlZcfZDA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TADNIt5M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766179034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rK9w1Snx+IiOS1yyTvDXywJSRfl2rZ6jIui6kPmEaA=;
	b=YzdHwnOJrliteAfDkGW/RBVRZN+ucLqztPES0nKQM23vyN3G19lhmoviYHhyllvdc51fOM
	C05e7jgI4XxUP0QuHnnrDuFgfHRL1diCc2iyu/y8JuT37OzZR7ET+AjN+X7UL7W39BVy2l
	+Q+ZbUT3d8wuBpSLgz6k3z+XMmR0Idc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a081c163b0so21189155ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766179033; x=1766783833; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0rK9w1Snx+IiOS1yyTvDXywJSRfl2rZ6jIui6kPmEaA=;
        b=TADNIt5MsBHGFhY53uchkCPaoqK4PUiBDqlaXmCjYjdovDpOzRc1CnM7qZnxqumo2P
         GBPhGQSHGhZhwaTTyBDocBan4F5+ayxqOVLziBIoi0F6TsJ0+qu59kv3159AqSiV2ikF
         wP5wpr+HVL5DEwCNgyu4iuk2nAcSfiTbIw7Wql3S0RSD1oDyQ6l91lJ6GU3lIiiP9/dQ
         72DTg8xTsaQPsDkSq46paBAa2XuFgym/H/C4/yfA8uqNx6EzIM/SJuR/vJaYdacW0WXs
         uI9G3ifWBRCNeJuFz2hTZxrgCAHf1yFtAlByeMv1SS3u+quzJowOz5uEDCVreYfxiVYs
         9GEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766179033; x=1766783833;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rK9w1Snx+IiOS1yyTvDXywJSRfl2rZ6jIui6kPmEaA=;
        b=cHPQ3CeKqIjXF1/owhmOMipZ6U/fHmGbopfE3F10hBbPYpkBlq4b3H4ye4zg6I/2u5
         Y/XXI3exNfJlDK+W70NrxAmOWYPKLmblqVKLl0vNEpDM9ryLFJhlzZogQPDEuRFzLZ6+
         SmUwfzhpb/dSepHniF14hxWQx/ZDFH5xYX+/BphvtrawPvJAdgcRHeMppJEuLK7eDKQE
         o3XGEqXv332cZyo8jvk7xre/HSEO5v6QCR/5obnRoj1B355KJTp/pzwyxk8ojxsvkXJU
         Y7tSXKyPtI7eQiBeHJ60VYREn43O5MYhDQ51yeGk+GVF2WegoSavBvFSKXm7Lq+5BvJq
         jd6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUW+kLR+vka0VaCH3bDtYAzcGtpLxRD412hK6fcul5SYm52Wsq1kvl7yUlerBjAeZSgwrrukTOqeQ==@kvack.org
X-Gm-Message-State: AOJu0YwPxZiem0T1DqNOlHs1HishdddMduuMPm5xYt64YZMuy6BEOtQW
	mJjZ9vjwoNwR2FU4+HyXQVG5w7v03hIUOpV2eR9yqGIBlDuNiffqqggJSpe05FOt3G5Nc4C5p8y
	PM1WWYHoaTOykFojOKZ/Q3F0EQTi4+dPkPpa5nCl6
X-Gm-Gg: AY/fxX52FBJvg/DPbcgjraUHm8H57pxhygxUW/8VkJg4umqqBb5kU3SeoHpgkLPPaUS
	DNRGk0K2cYucPo36RosEo3/Gk+XEtlnqj5w5qA6QcIAv2e9hIIGL5H3XKlTQkwPGHGubH9QUF62
	pkyNtH66fLlVBSmMMQtlleeQYJhIqQoj9w4/n/Abs75DPCAv4wewfN8j5KtKLWcWwuUMReHUPSX
	pLWMnrwHIn9SuREMQdEQgPVJTa1rPI0fmD9PPZO9FoyyGzGdKiwmoHGtvbvQ30B2tG3athEfqUA
	WxH2nk3MI0nD5cnfa3DMnRybBg8voMN/lk9EQQ==
X-Google-Smtp-Source: AGHT+IHpiDrn99m7x0uN4estdHNLC96nljKxP9R6JbsteT8HXtfNtk+xeDdUnA0onYdjgh5ezU9+Po7MHQlADcjwb9o=
X-Received: by 2002:a05:7022:2586:b0:11d:f037:891c with SMTP id
 a92af1059eb24-12172311ffamr3088830c88.44.1766179032817; Fri, 19 Dec 2025
 13:17:12 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-8-elver@google.com>
 <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org>
In-Reply-To: <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:16:36 +0100
X-Gm-Features: AQt7F2oJirW61gdd7JR_kO6v8Pm8LYFzp_d0WJmR_my_E34K94emt-YaA94Rukg
Message-ID: <CANpmjNPJXVtZgT96PP--eNAkHNOvw1MrYzWt5f2aA0LUeK8iGA@mail.gmail.com>
Subject: Re: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context analysis
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
X-Rspamd-Queue-Id: 59A45180008
X-Stat-Signature: mgsa8nrjfse5poqqnqkx1a16mi9wzz4n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766179034-987364
X-HE-Meta: U2FsdGVkX18sy2SVpo4ybfH72nZ5T5TOIysghhAervyxdwgwNkrAm0NLZCJynacyyaqUi63zN8dsEynWLJ90InfDNevLyj0AcYUPnP8Tl2Czk7C2FC0xskxT0JfR+lc83vDAzbQ8WsZftiQz8TI6xVECU+4NZdLISPqFvouUutUf5EUiDMatzTrJ4pkmBdL5Qp7zyA4+zeY85cSQB/FH8C6MiaYVa3EzFzCxJMibir21X9tT/nztAOt6VX9iUI/imWgKQknDNs5ydHwSm9GmgjRxdGeEpnVd2O+bG76yU97OcBBC6e8b/T/k+u+kot0AYDc8LukOomFDNZIG1xBcxtWGNX7bqbNLThxC3/lJj0BWO4PsC1vb49/wpHexJB7m+tY+iWfvak7wEK9pIzaxg63es5cvm3Y8pdSFaiZKuXUNR+KGEKVh8sCE2r9X8oY49LuebroiPp+Gc3AhhD1z746XvWXK3rLh/400yEANnpPAAj/2c+XMP93i8437c9o5TEvOqZGfTp8A5jhtZolX1HQAjgjp2ZDYQfk1MBmEhgTDXjb0dA0VfwFx9gtaDjhX2wkYRnEVT4tbHY3nYI/Ku7EzTYXrWT7q5Jj4yZz3MrLSV0T1rQtCQcauQiu97h4ipHeFXmqajS10Ksu/TK2c76pmUOzBCSWU4aJ9CrpBCbUdFwoK6fp2AUAf9bvMDXUNfAlx17MzJ1RUbvalueSfJP1ACoT0UTp/tEoFXf9L9KUO3TYSH7PrKqveshzUTZV4g8SD6iUetNDF29oJ3dOwYDWy9+bzSe/M4jbctp5uwxZIxTT0H8GwnSm0wqmqbmnphDxMHBz3bOsOTYOQjYkFh6nBoWPmRYHwPD+MQy60r5yo6smmJ6I8TmzznqaM/fyBySm9cTU84tbBzwqMsPryfFbFO7/qBKuP2uNxbI5JOdjhuSfuCgFS0BoWVIr+eNUkXKZRoQr/LV/aVmClxGo
 GN+NMaRD
 70FSeXtEbzzgBtKuQhOf7K7Z081EzDW0OzBo2E4v/ctYcN9Hl3Sp/sang+vc0sAqBym3uTtbf6nuP9wlKlFJEJKacA1QNDCatqcKI9oL2NLaohiGEQyhJYBoioySOn0Knt3VPMJTg5MXtfdBO2NbnldU/PEwP6RTCsA1L4fuPJmnp0wG8SAhOppOjZbE7UPHmaEsLTf2fkfefdafp5UdJBMzKWmKxyxhYa8+8TtQFluCWroJylvspG+6w56E8YcHQA10RJQW24rTvTARX+T8Z2YapOQsbMX5T/uDKV+OWFo60dtFSN8RHnX73z31IO4/FPkhz8SRt0LdEBpIxM7BQxmBSysd1Kj9DLEfRqE+bK+4nm6ePvwk03pjjX+1Uuss8ibSOL9B5L5zyI4mkkQaZgePGS1AOwxg3gkVldZbkqiAOIean9FHn0hpJMsjcUXqjiHCD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 21:54, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On 12/19/25 7:39 AM, Marco Elver wrote:
> > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> > index dd634103b014..621566345406 100644
> > --- a/include/linux/lockdep.h
> > +++ b/include/linux/lockdep.h
> > @@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
> >       do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
> >
> >   #define lockdep_assert_held(l)              \
> > -     lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> > +     do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_ctx_lock(l); } while (0)
> >
> >   #define lockdep_assert_not_held(l)  \
> >       lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
> >
> >   #define lockdep_assert_held_write(l)        \
> > -     lockdep_assert(lockdep_is_held_type(l, 0))
> > +     do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_lock(l); } while (0)
> >
> >   #define lockdep_assert_held_read(l) \
> > -     lockdep_assert(lockdep_is_held_type(l, 1))
> > +     do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_ctx_lock(l); } while (0)
> >
> >   #define lockdep_assert_held_once(l)         \
> >       lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> > @@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
> >   #define lockdep_assert(c)                   do { } while (0)
> >   #define lockdep_assert_once(c)                      do { } while (0)
> >
> > -#define lockdep_assert_held(l)                       do { (void)(l); } while (0)
> > +#define lockdep_assert_held(l)                       __assume_ctx_lock(l)
> >   #define lockdep_assert_not_held(l)          do { (void)(l); } while (0)
> > -#define lockdep_assert_held_write(l)         do { (void)(l); } while (0)
> > -#define lockdep_assert_held_read(l)          do { (void)(l); } while (0)
> > +#define lockdep_assert_held_write(l)         __assume_ctx_lock(l)
> > +#define lockdep_assert_held_read(l)          __assume_shared_ctx_lock(l)
> >   #define lockdep_assert_held_once(l)         do { (void)(l); } while (0)
> >   #define lockdep_assert_none_held_once()     do { } while (0)
>
> I think these macros should use __must_hold() instead of __assume...().
> lockdep_assert_held() emits a runtime warning if 'l' is not held. Hence,
> I think that code where lockdep_assert_held() is used should not compile
> if it cannot be verified at compile time that 'l' is held.

That's not the purpose of this - if a function or variable should have
a lock held, we mark them explicitly with __must_hold() or
__guarded_by(), and we don't really need to use lockdep_assert,
because the compiler helped us out. In an ideal world, every function
or variable that requires a lock held is annotated, and we don't need
to ever worry about explicitly checking if a lock is held (but we'll
be far from that for a while).

The purpose is described in the commit message:

> Presence of these annotations causes the analysis to assume the context
> lock is held after calls to the annotated function, and avoid false
> positives with complex control-flow; [...]

It's basically an escape hatch to defer to dynamic analysis where the
limits of the static analysis are reached. This is also the original
purpose of the "assert"/"assume" attributes:
https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#assert-capability-and-assert-shared-capability

Without this escape hatch, and deferral to dynamic analysis, we'd be
stuck in some cases.

