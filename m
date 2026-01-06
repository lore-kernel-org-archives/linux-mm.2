Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70539CEFCE4
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B767A6B008A; Tue,  6 Jan 2026 12:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24A86B0092; Tue,  6 Jan 2026 12:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8606B0093; Tue,  6 Jan 2026 12:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4066B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:34:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 303D3C239E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:34:52 +0000 (UTC)
X-FDA: 84302239224.06.C19BB2C
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28C0E20010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:34:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lYiy+aRp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of elver@google.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767720890; a=rsa-sha256;
	cv=none;
	b=Xbi0JlrgMA1MtasyPvLoDUyyvHdj2dFPKsu94pOWj7sN2LweWGBrXKztZpOPCULdqt53IZ
	BXibMQ+hu/h8VAGBGWrkW8xPIjSak+lrm8PWgTywSjWwz0WRJGoC99vIVCYYVdorz4DtAS
	FkFRkv28szz0X+s7paX/C1bkTm3n1T4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lYiy+aRp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of elver@google.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767720890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXcHtzljW/LEwcnvhUw7B+CYy+kN5WC/pk6M+qEtNI0=;
	b=UolusHGYn37aYLao4ncMd3j7321y7sR5sPv0yqlNUHZ8rrE4qtMOroHitki28PomHNmvCE
	ek7Qbs5L6j5CLW6cFsehFBBa8LGka4apR36gq4IdzMJYx/JM9YiiN62eClIES0t5GxCQKU
	IiTRynx5/FOAPsa9zbDg1JMccsX4cik=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-477770019e4so10424945e9.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 09:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767720888; x=1768325688; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXcHtzljW/LEwcnvhUw7B+CYy+kN5WC/pk6M+qEtNI0=;
        b=lYiy+aRpUXr6A5C2qhL56/dC1VeHyWV3aI9B9TglL3LXa3rrrMuawO6C9MGhu5BP6H
         Kryj0B0ODBMIOJlWHHD6JqFkoVEYMi7qVSSV1b4I6SDKrWqCwnZPg0xY2pImIaft5tTC
         ZoP1DKTl/NCiw+egBj55CEQX7ie4pE/kdhAT53JevihMiMht+0+MDpde3NBFDOt7nx8y
         7mqCFGQoCk23fWTzxfxk0XUs/f8kggXduu3Ziy+wxV4V4I6lVZUXTezb1H4yr27ZsKse
         doya/3VOsEc2A2ov7epERTCrUMPbNsE0abbrQ44Zc76bQQg9Vpw6V70tJ1Bp08eyy57q
         00mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767720888; x=1768325688;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RXcHtzljW/LEwcnvhUw7B+CYy+kN5WC/pk6M+qEtNI0=;
        b=CM41GNLZ8FpMVbuVSfnQ9doKbdFAG+HB5gOrOzHRFpek1nLcTwVsJE/CaMEKuRrwUh
         GFMF4Lhf/mgYCOKMyy5g6HFbYpWzdu7MI45XTgKbBFl5LvsqOvdcxFuIeJ1eE+AwCBGN
         QYhmYTyfgvZywr8MIP2GNR9FdCPldmA8W1ZraARTgzTLZvYbUsTKmAfYeMen0QT0KvGe
         qJLMqMLLRlE3m++401k9fi1SFCv5VhbSaplp8KEpaw0X7WboZnZ5zZ/AOItrH5YBNm/o
         HR4mJiWLdJqSIzxELUxfQii51vvlcN2wQBQF5m01U1k/XSsqWSgodMekONb2swUwuWcz
         5iEw==
X-Forwarded-Encrypted: i=1; AJvYcCWNwUEj4Xkikzg0Mcg/8zWOC+EBa/3y8AS7JfSZYyqPUxEOHR29YyUf25dJE71dw8flNAl1q3SgGg==@kvack.org
X-Gm-Message-State: AOJu0YyKYL62fM907q9HPZfc7jG/qVZbh7ppE+3pv84DdijgH3ZF37xC
	rqZX/PibqohpURj6uTIyq573XB5fJ0Q7jXYUKI33jNDE9wl47gCx7RKB/oYA9nV7Nw==
X-Gm-Gg: AY/fxX5HoDu3RWc49+kG5NILyurdy6ZLjnubimo0Clu9VOsPq5GONuYiDSGMIgROAW1
	sHzaFghEuC9GR4t8y7szjik9sJAhZmvkV1X15C4CC2AO8VV8gj2aUHLd+P2QmTp4tUnPdIhndx8
	OrYAGqxuE4Kf7WttOYVOy9uIvO62duPgTaQdtJ1+eOnCMil7C4cCA7xxqUtUrK1TKb6l/BRr9aM
	7w5IlDOqqswyUNWrnLpQDrzd/0v6pLLMbeMYBxLoDYyo+T+pSUbKOO4xak2jHV9c9NYEFFeDocT
	37RfzjuwA7MBwhXy6kyC9qQs0eWG4S+6nvOzAjknBWOK51DJB14qQZqIKVV7oC78C6Z9FlcZcxH
	7Xj0NLvVjBzjiybxALzRR2Ttu7TMtiuOREiJGmzflPW6hdoXhrSuxbnQaEX2Xd0g7DI+YTZoWdc
	EiLeBypSneoJhfcpwVG0NHM9ZlFXeg7cfeFB+jw3PcBVsrDMeT
X-Google-Smtp-Source: AGHT+IHmVK6EqE14VH+HPUL16Zk51harYxsBJJheKVL1BeqXTS/M31ba8unH1eaK7+ALdSr4nMxyjw==
X-Received: by 2002:a05:600c:46ca:b0:477:7a53:f493 with SMTP id 5b1f17b1804b1-47d7f0980e2mr44046495e9.23.1767720888108;
        Tue, 06 Jan 2026 09:34:48 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:4477:8df2:f516:1bd3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7fb4b3c5sm21868415e9.15.2026.01.06.09.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 09:34:47 -0800 (PST)
Date: Tue, 6 Jan 2026 18:34:39 +0100
From: Marco Elver <elver@google.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
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
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context
 analysis
Message-ID: <aV1HrwZm6xg8PnRU@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-7-elver@google.com>
 <993d381a-c24e-41d2-a0be-c1b0b5d8cbe9@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <993d381a-c24e-41d2-a0be-c1b0b5d8cbe9@I-love.SAKURA.ne.jp>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28C0E20010
X-Stat-Signature: k3usxtkjkcswzue5t1anrfhemj1x7f1g
X-Rspam-User: 
X-HE-Tag: 1767720889-815746
X-HE-Meta: U2FsdGVkX185aP0XMzLIUFXU36DZ7czlF9Z76kcbPZrMIqwin2+fZVAkNnyIUjBKnsYc8OjM9jTKCok5ydbx6akOv4ztjeqGIG1Q6VNi0zTpgT7UVFFuocUmwULPsBrpU223FoNvOpu92dQPt1nSDrjP4Xe+yIqt6C2+srxzzei1QmqvVe5VQzLEswywsJFVQbbyG7xCc0JxqgZCkc9bVqqicsloHMLHo3YmWIGdxkmLuPza9oRfCbteP6CXSHwJ4BGzhwKLqhrLb5N2LV4deJFXq0HWM4Rt5nHnGrlKpoQaRZ0HJ2oedwC/gBCQGtlNulCgtu0TnyZq7enpDlYEqzfZ2PDQlYk09zNph4DqYb2d/IdH2qWfev8KlT+VC0bx1HLvClibIaV+OBeE19RpaiRnVNgLMZdCPeHL3poWMWvl7jfR8t6z5QcfEV9ApBDEBZJjnkzSyLYbfm3fAlIl/F9oVflGUTioYvAnz+hEiw7siJjNUzRsHDgj0FK8Ci0QQ+7+MTmiJcW+4dOc8jUoevDgOpnQC5bTauHSqQiAoA4A62vomKTwPDyNIypyFG/yks6BqWt4fc+oArXBed0LnRRCsmBQCqVFOM4CWqivbbVJ93QjtEFrb6ZLvYo5wVJuJ/Yy+Lz9a69j7evQ0LJzlyUcf7NEQ0Kmnzijv9RG70l0E654aXDeWxUpVPWZupTSzWz8CvVtisT5g1DQrOrVy7LEYKgGes8XTDFbY1QJlq/PbmFi8pl3mI5FWppTeFKnA6Zakr/XoAHTfUBJrzVNvArz/MdezkLTiUA9GtcM+d0od8gC9qCFnYlaj6atLSgvRuY4GxRE5r33GO5YXhMpK2Vdl9Cj9qCyUB1EDc56i+g8EmoHM24N94ud3UQYMYSJZYF/b+iRuMygG7iP5Y9lBCLwI0OXTw6+qMf6Y9cjNek8pH/ASFcReRIrqQ0gm5qFmrvOaQ0ulhEQrDod/zX
 p0one/Ek
 eeRgKAfQ8CcB039tU5GuUO5CnU+PU8uass1kTUMp59BJjES1RAn2LUULV7hgTRA9n/nOT8w9EHGUqg/jdWiROOrKZZJKr4MXrPhUqS+ii/dW+eg326uVZEC/niXnUzF9Ql8gNROBYca3Py2MCkPqoyBj5cUmksq0A2fA8hWRdtlsUhQ3Uf+jZpMk4rdj65zEo/dXmaCTII+5DbO+7WmjgTRZESl+Dl7plPTPX1Ceo+P7ZO/r7VBDJNLGDf/EFA5FvE46HGEVeY1ctJr6/+f5HcsupNq6fTy1gLVZwY6o5pcZGGw3SK8a8jvlA7HFg1LMJhJ6vdmmfHfYR+81eh3+yDjq5YDjFXw07i9pIrdQwugmSonpWtzxkeicCwK8MDAZ66HLjhYIKzEWEo5kTkfk/BDNUAT4ICvdoHjL5Kqb2EY2vCZLZQAP/VU97QdyzfuPqsMBfUwoxDgo2xF/yGlr+vkWS/KFMsOqXmU0YeGUW+2MSq3L52lZUPHMzRUoO87p63ylTlwfzhyQF4XbKta6nwbVNr+r6LC/z5Owb0I2PN62M4+LuYvN2WfnFgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 10:21PM +0900, Tetsuo Handa wrote:
> On 2025/12/20 0:39, Marco Elver wrote:
> > Introduce basic compatibility with cleanup.h infrastructure.
> 
> Can Compiler-Based Context- and Locking-Analysis work with conditional guards
> (unlock only if lock succeeded) ?
> 
> I consider that replacing mutex_lock() with mutex_lock_killable() helps reducing
> frequency of hung tasks under heavy load where many processes are preempted waiting
> for the same mutex to become available (e.g.
> https://syzkaller.appspot.com/bug?extid=8f41dccfb6c03cc36fd6 ).
> 
> But e.g. commit f49573f2f53e ("tty: use lock guard()s in tty_io") already replaced
> plain mutex_lock()/mutex_unlock() with plain guard(mutex). If I propose a patch for
> replacing mutex_lock() with mutex_lock_killable(), can I use conditional guards?
> (Would be yes if Compiler-Based Context- and Locking-Analysis can work, would be no
>  if Compiler-Based Context- and Locking-Analysis cannot work) ?

It works for cond guards, so yes. But, only if support for
mutex_lock_killable() is added. At the moment mutex.h only has:

	...
	DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
	DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
	DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)

	DECLARE_LOCK_GUARD_1_ATTRS(mutex,	__acquires(_T), __releases(*(struct mutex **)_T))
	#define class_mutex_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex, _T)
	DECLARE_LOCK_GUARD_1_ATTRS(mutex_try,	__acquires(_T), __releases(*(struct mutex **)_T))
	#define class_mutex_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_try, _T)
	DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr,	__acquires(_T), __releases(*(struct mutex **)_T))
	#define class_mutex_intr_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_intr, _T)
	...

And we also have a test in lib/test_context-analysis.c checking it
actually works:

	...
	scoped_cond_guard(mutex_try, return, &d->mtx) {
		d->counter++;
	}
	scoped_cond_guard(mutex_intr, return, &d->mtx) {
		d->counter++;
	}
	...

What's missing is a variant for mutex_lock_killable(), but that should
be similar to the mutex_lock_interruptible() variant.

