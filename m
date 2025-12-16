Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED36D5E125
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A066B0089; Tue, 16 Dec 2025 06:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5006B008A; Tue, 16 Dec 2025 06:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01F16B008C; Tue, 16 Dec 2025 06:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E04016B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:01:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EB481A05E0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:01:14 +0000 (UTC)
X-FDA: 84225042468.10.CB10A26
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 822F9A0010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:01:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yu5PJgNV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765882872; a=rsa-sha256;
	cv=none;
	b=RHWLFxArUHh/AZyLHHnMAwaxAsXOryOjXovgaiLqeG0AB+QzIFPPcI3osbow/TnikitRrR
	hkv/bovcTJP2ZrcWtq4dq+3uA1FdeSQAg6j89cPELNq9DznobGug3U/s0fv+jxnVaTR+0y
	IFPx6Bp0jIY7/p/pTMKZnpI/JWui4hQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yu5PJgNV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765882872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fwbXvgWn6Nd0xRDLnbqnTLufRK/0AjdBlMA+CLIc/0=;
	b=AvcjE5YXut/dogeN2KbDouksU3aJiBSmbzpzs+2gtV7Dv8l4LdCy9z4GElrYyIujhDixaX
	T9lPpX8x0EKDmhDzvWtqt2WaBfDmv5qGlruLY1iCGQUjtzvRCFvwOIpfoV60AXk2bZs5zx
	M8LvpW31UHyETf8Z6sWgkrKVmSUJ9aU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso36161005e9.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765882871; x=1766487671; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fwbXvgWn6Nd0xRDLnbqnTLufRK/0AjdBlMA+CLIc/0=;
        b=Yu5PJgNVkI+MQuRmQhzfgTxgu+y3Ll0BmkRnZHHI4gEgOvC+YFSvP/f3uY7Z0jFlEC
         Phy96u1/M6ZJhjDKE7bsV5KvaP43AcTNQK3KOWcwXSgGXjjhg79qyz0csPzxUqwSLRap
         gjsoG79+jQGa15ouhpxgRSpF8vr2aq9GE4qH6VZYV5hDshPav99IBsILKoha5FYkzkC+
         NWdP9S1yiPM/vXQwKTBgpzlz65FoCRlfGWROPmTAe3Z/+o5/WGXcVkD/sI99h+8/o/wM
         M4gcmB2WtWlUPytaOJmy7K8LX7scUDXpFPa2wcFhX437lXmcQ1A5xKYTA1usDnuGm2r4
         w8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765882871; x=1766487671;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3fwbXvgWn6Nd0xRDLnbqnTLufRK/0AjdBlMA+CLIc/0=;
        b=QeedMXklzk96w0FJFWmwqFI76bWsQCtCZXcCk8hNlcVg+WFB3lpigkX6wX2KMBUEEr
         kfi3/KsLP7g6TQIOB7o0jn18sWlSiNOFwnQbOK1VM5dYuPqtRjAo0URQIJYnFf/2E05D
         DvYllYrQcPSASLDNFx68Cv8Yp8/uJrma8tHXq8LlOCSv4jhYVb0jLQ/Ezq7ENWAOQ2os
         Olp1yVZEqPjZAT5Bhigw/6sPweLjRSOkV3nZOOl1jrI5DlyOlESVOEtuv1Os3hjX1mym
         c7I/sFkC8FY2IqrQk33eW5EaLatGLGXxJm26u9FXoUMVDJHopBA8Q+AQGTLwKCbm3Fqb
         MuJw==
X-Forwarded-Encrypted: i=1; AJvYcCXQRcL4L6roV8omNOwRPRoUchL1/87jHfIdAIsVlNINMzBRGmt/P1SAnEvLreSlT+N7HKvewBcYkg==@kvack.org
X-Gm-Message-State: AOJu0Ywch103iNKgcQwPGcVTdD7jtCsKLisPaloRnQx9vf4MbxYWQeay
	XOSu0wTf9aPDhYlGHSG2r21kaRWQo6hNJSwfhJ32D4vwqfiB29kUgB6lgkei8GjD3g==
X-Gm-Gg: AY/fxX776pfkGVxG3KWaAw2yUdhKOzD7PpgGA5kM6lIovGPnvdu5X/5c486dZfz54Fb
	0dUwFnemRPzm6rfHrCDRc79yLjYuxmMJhds81LFHV4IIR0qMxRlufOUZyPWlA+Z1hJiWVZAEjug
	MoGJoptlrKWl8BLXCHDURAyPvRhmd4ue2MAnrbPyFSoIXwyqUwLyPJKc6hb+WyGgBiZelS60PBx
	bwE6EP+TDujArZ0WDDwYTbF0MYDoksMcJdE6xgp/EXMATuwq3KX1KCCiBZUM75qaH9Ahh32pK5J
	U67WSlEQz/gDB5RcIQafmOWzdVAPHbI/Qz7ODv7eyJn50gtkWzQJOnSJITHuMrChH13WGuY5nIn
	nf5YfSdrZy4/ptXULRN8+OrCNlbm6v+JVyu1P1nZge456nERjhI2oi+P6U4Zdz1ZY+gJ/Hkz1aI
	H1popoL8/krdg+eHdzU2Bik02zPvqHB6GBXNyQOEt9icz396Se63oZGdygjNM=
X-Google-Smtp-Source: AGHT+IHPMwFoz32u9J3kCO+8mIIo+dWtYExr149Lgk7NY5BncmGMC4iCyfwqqX0j0PAhtkij+iZr9A==
X-Received: by 2002:a05:600c:3ba7:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-47bd3d41de0mr37923685e9.11.1765882870450;
        Tue, 16 Dec 2025 03:01:10 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:ea4c:b2a8:24a4:9ce9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f5f6ede8sm17789236f8f.4.2025.12.16.03.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 03:01:09 -0800 (PST)
Date: Tue, 16 Dec 2025 12:01:02 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <aUE77hgJa58waFOy@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 822F9A0010
X-Stat-Signature: 76m6c5nmuz8gneesgj4btoxca1wh3q8s
X-Rspam-User: 
X-HE-Tag: 1765882872-360467
X-HE-Meta: U2FsdGVkX19O5Yeq3QFouemfwtCXmsxIO2f3hABJ1SKpfcoDTXKxRP5T4HrP4/efipI5bw5QpxSU9YPxHrbVKOjli8R8UsljCXk6UDO8OQIov4heoYQQevDDO1+kFqhz2F2WpmkkyhSjQ/1vfVAKwcxtLqwXmo1BeWZdQ5/B4XR5235PldGdygpIcuiTJfC0tYqKZDXD0Wvwnbz/yagOMujqbU3smb8sNBG7tSPV+mgoe1cV0ID4RO9e8Un3CvIGn+Qmz/Jg7ouG0l8BR+cEvL7QUdEN9QqbK3TLn2GMe9mrGB0uWffVEgz9EiP+b9ebvrKHkZoSain6n2TlDODbR+yjVENzIl6BdZNxncwlKaUmMg6n4d48WLP7PUqwKqwI+jZD26YWqZO8MuZSK4iSsiLyr4d2QjeonhCumJz+8V+UeMY4g7QRlFxwQnoFV8m23/+Xq/co68Qy3a3qiFhzPTUzZXgfCaO9blSfPIqUm//aegTHHONPc6l029VK7SNTPx5MdVr3mcRxon+z3UHnaUsK/EYv2QDOTxcJsAj6iWyaaaTJL+8b39/6x7Dh9efE9/TcY4aBjtqtJFdTniBrjwPVXZPmSR+Cym5gN/rbsruLjra3gGJ/1bAPcNJhzIV6WlnIGgOuG4tY7KcoXikm5IwsGvjKwI63J3LoC45W78ScWVvEU2QT7qKZeP39Q2LzGCM13QXOChE0+1veDtLqRLTex01MwzxRZHJAKulAQu7m05iGoktOXltxNb2QuOBl+xDiKpCRwwgRiCKpmUH4vNOZfkpNd5+bOqTUtLu6OqQZzWLjy2IXBGNpPe9bWuszAyycDvQgneP39qMqvdGOKJr+7/AemSIhXEv9Bhnu2IvKqeBNKSBLHGJM5ol4EvPyxPKeeyzsnO8kHv0lnJz7HDGbs3RxfVhrNZ6ZSkdq9fTpe51x1m01mHsEGauAuc3broUZntt+DXCE0Qg8YV3
 AjV1OZed
 WjkxunCD4JEoND68UO9jDysuMjqvun4IIFD+IZgcAwghOKu5meqpGU5O1xDSGm/F6ZJLK1dxLrgLM+ThkfUxvWexdmDx+VwQS3+sJJZ8b9EKegPlfpKAdXMictPsROwGm84zUkaFj3aGWPZWFJ/v8/BwMHWKItGKS9hlZUxw71NW0R0aFb+hAIpWRoU4VJ0YFfhKGS39hDP8khicrtQe4mSqijX+0lPa+nprohnfvti+VC0OiZ+dfdeCAUjDL0uWRJkQwJD0/oT7UNqWW3NLD55034Oj9Tgy6XWV3yQUF5kXtZdq1UxuLuOmsQZZAHHxy9CpD8ROoV0Y4FS61I1JuAF4+/N3jeaivyDE5qmkCIEbivKgaem06nWvIT2C0TJOdef4xUIbcMSLTEj0CggS625xYXW2Pf33K6eBMDvJqMGjTk1zoPzFMM19pwPLrrsCO7IAD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 04:53PM +0100, Marco Elver wrote:
[..]
> > > So I think as is, we can start. But I really do want the cleanup thing
> > > sorted, even if just with that __release_on_cleanup mashup or so.
> >
> > Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> > abstraction. For that one I was able to make it work like I thought we
> > could (below). Some awkwardness is required to make it work in
> > for-loops, which only let you define variables with the same type.
> >
> > For <linux/cleanup.h> it needs some more thought due to extra levels of
> > indirection.
> 
> For cleanup.h, the problem is that to instantiate we use
> "guard(class)(args..)". If it had been designed as "guard(class,
> args...)", i.e. just use __VA_ARGS__ explicitly instead of the
> implicit 'args...', it might have been possible to add a second
> cleanup variable to do the same (with some additional magic to extract
> the first arg if one exists). Unfortunately, the use of the current
> guard()() idiom has become so pervasive that this is a bigger
> refactor. I'm going to leave cleanup.h as-is for now, if we think we
> want to give this a go in the current state.

Alright, this can work, but it's not that ergonomic as I'd hoped (see
below): we can redefine class_<name>_constructor to append another
cleanup variable. With enough documentation, this might be workable.

WDYT?

------ >8 ------


diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 2f998bb42c4c..b47a1ba57e8e 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -518,7 +518,10 @@ static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
 
 #define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
 static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
-static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+static __always_inline void __class_##_name##_cleanup_ctx(class_##_name##_t **_T) \
+	__no_context_analysis _unlock {}
+#define WITH_LOCK_GUARD_1_ATTRS(_name, _T) class_##_name##_constructor(_T), \
+	*__UNIQUE_ID(cleanup_ctx) __cleanup(__class_##_name##_cleanup_ctx) = (void *)(_T)
 
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 8ed48d40007b..06c3f947ea49 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -255,9 +255,12 @@ DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->
 DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
 DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)
 
-DECLARE_LOCK_GUARD_1_ATTRS(mutex, __assumes_ctx_lock(_T), /* */)
-DECLARE_LOCK_GUARD_1_ATTRS(mutex_try, __assumes_ctx_lock(_T), /* */)
-DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr, __assumes_ctx_lock(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex,	__acquires(_T), __releases(*(struct mutex **)_T))
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try,	__acquires(_T), __releases(*(struct mutex **)_T))
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr,	__acquires(_T), __releases(*(struct mutex **)_T))
+#define class_mutex_constructor(_T)	WITH_LOCK_GUARD_1_ATTRS(mutex, _T)
+#define class_mutex_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_try, _T)
+#define class_mutex_intr_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_intr, _T)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 

