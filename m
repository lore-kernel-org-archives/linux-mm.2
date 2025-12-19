Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40744E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF8F6B00A2; Fri, 19 Dec 2025 15:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7A46B00A4; Fri, 19 Dec 2025 15:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA856B00A5; Fri, 19 Dec 2025 15:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6A76B00A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:26:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1728713AC5E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:26:39 +0000 (UTC)
X-FDA: 84237353718.21.D9A5661
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id 278F412001A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:26:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3LHIpw+i;
	spf=pass (imf29.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766175997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XIWCwsoEOSiUB9cSDM01ohKHVap8EzItAr4kGei6l0=;
	b=7h47fw0YibT7R0JWvxMFcWtxZ01vjinsctuDaYh/2UBBotO4rna+XYb9n1Y3MnHacYPnPV
	PxPWhPsVp2hQIVHXuRKVLaEJ1hx8tfwfzH2OH8DpH8nMfPo8yNZyNuCHfx3DyO48Xhh5kA
	/PvNmJxi0tUIC4JNdkdldEWs6WhzaeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766175997; a=rsa-sha256;
	cv=none;
	b=Ci5YjBCh6hWIvbUEesUeHqurF/fteOEPn2DlY29GwLH1OYTnUxbiJ3BtTfj8wDusX8CIjr
	dKETM49GXfGAcpMZu2DFTsz7LkRPWVTNvw3ZQuCYh/4VSc/onlk+Sbaiy5drSCQXWrjAEY
	tgQ/9jTSHNkyr9uBWMmMKxZN/zSrxIs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3LHIpw+i;
	spf=pass (imf29.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dXzb00Dlzz1XM0pZ;
	Fri, 19 Dec 2025 20:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766175988; x=1768767989; bh=+XIWCwsoEOSiUB9cSDM01ohK
	HVap8EzItAr4kGei6l0=; b=3LHIpw+ieGDbEleAlfBlytRlkHzz0FuNkyXKj3yU
	S32iMbGcs0xQwrQ96fRo/sfT2B1xWjxWBl4Zmwsh3C+nrtdKA6Xed25MPdOCf9cm
	OqPTEBPUhtk0GS4PDhB/osqX2tyQ5qlnUBv7p0VyAR6hSFuFmB0OawSv0O47US5/
	JVEkmMhGnXcUDadT9IfMciHirW0f53kX6OuysmpCmU7SzmEVCZCFZ5kBWMSaeAD5
	ifMcPAA3c5cPVUXL08MT0F8lNI15xLyN9g+ZI4CeiJTFZ9V40mxi28nG+Y2Qlfgn
	U/PZ4Dn7NZgRHwASo68yhekJGP/2bVFKJP5Y3DR1pjapoQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qiEhQEwhfLs6; Fri, 19 Dec 2025 20:26:28 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dXzZd0R6zz1XM6Jk;
	Fri, 19 Dec 2025 20:26:16 +0000 (UTC)
Message-ID: <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
Date: Fri, 19 Dec 2025 12:26:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-9-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-9-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j9qso9kd9jazutk5zjha811eb5pppdzr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 278F412001A
X-Rspam-User: 
X-HE-Tag: 1766175996-219352
X-HE-Meta: U2FsdGVkX18aB4hrOaT8aaDTTJr1n56gSVBD3m2kAf6VCS2fYeIDWatVg1Ikth1aQAm1xKmM08s+rFj8JO4eUyKO10rtGiR+sb0YS97NUnyKs7DKa1gyaQWMRnJPcSr2XfiHWFw4lsuYsGA4QduGuy1WPUXBv/OMrdLXnvMzY/VTBG6NMSxFu6tzPOfkiXT5xri3dYGdjzn/r3NKoGntRRe4GhNmHg5ZQJtus78HiAXJaj/inBl/6WOR7F7uunDPE0nHyNFDgS13B4yIx4LXFLntWoD0KeBOdm960rIiBYTm4e1M8EB1M2juGjQzOSKTnBCxTp+L3AJJhqR4EI5NqfYylk8nsGgzYCo4qgDIqfVhsVrhH61RnzO2OmphSS/CdCDekBbYFl51OW9rb75KAJzjfSGmKCPaWAgWjMgx4sQpP9Nv3n5KDSv/4jYJFELPiM6EWXxFN6UypZFRfXUD10ZSeRwfk1UQ6iT6esNqsrJC8+hLoGGQ0Ro0usQXDH4P/4ihqMiFyLSMZ0WTUF7GXqqnsiYT2+cB1ak6rMbCJ2zil3wUaB/EZ5VDrs8dRyFy9mRSz5WBRn1hh0RIgrv0H/vx1g2Ttj80/OyYGExcmdC8sUg4HRCfvRS9tbsdXDg9b/gnr6sAaPFJnXzq+h7f5xBPinPlgpIPAOMynf8ifRCf1pkkwETdxJ8VmUyiRCJH3l8A2s88xq3srMVIv6RlWAj9arcGMN7Kuoni47+g+rQ2fBxm7mAit5H153BclYQUj8Tt8HhGNVIEN7Wx4RqyHEvCHLUX4P1GkeWyPFiMJWTgYesXhjV/fsiq4ClcKTdcJHmU0hOWTXbsgQMau82ZxBhSiPZofBPJlbES4X+h8H5e4JV+M6vgJr8G7nxbbBrGW2Ywt08k7zZzc+d5VwVkzvhiqfsQ2eB5Hf4nMsZu1k08S7546NWPKazl8htE64eDfn53DCuQc2BJW9CCCzx
 D9voJSgS
 I1rmmoD1uz1Bo3jnXJc1qRQqQhsR9XOhPCUtugP7cl1jSLiZV98qe2Ez84Jil2KfmARlAELA3/7TDUQauJw/6sielQXsOrxxpg3Xg6KVYFxCaUYa40vgUbCmlR5OrbRzrOA+9mhdJ6iFL0uIp274BFPALLqNpbP6IyRwNxvdhRks0IJl/qIvJ2odx5RhFm9S/YBwy/rW0NRddOyyKGXXXl3CViaPR1dNQZKP2Wc6Nsjs2kqvVFB+X9nCZvCvgadValaO6JDU1VyqD5Zf0k5SsXn80+AxeTj/hQFJTF11MGibL1meErSwo8K9BkZI8FYKUpK6CQloH7EqmQG9Zr6erEfv2Og0pzbRVL84nXtKP5hJ/hCCk673Lj4LsVibZyvVQ9xVY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:39 AM, Marco Elver wrote:
> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);

Given the "one change per patch" rule, shouldn't the annotation fixes
for rwlock operations be moved into a separate patch?

> -typedef struct {
> +context_lock_struct(rwlock) {
>   	arch_rwlock_t raw_lock;
>   #ifdef CONFIG_DEBUG_SPINLOCK
>   	unsigned int magic, owner_cpu;
> @@ -31,7 +31,8 @@ typedef struct {
>   #ifdef CONFIG_DEBUG_LOCK_ALLOC
>   	struct lockdep_map dep_map;
>   #endif
> -} rwlock_t;
> +};
> +typedef struct rwlock rwlock_t;

This change introduces a new globally visible "struct rwlock". Although
I haven't found any existing "struct rwlock" definitions, maybe it's a
good idea to use a more unique name instead.

> diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
> index 819aeba1c87e..018f5aabc1be 100644
> --- a/include/linux/spinlock_api_up.h
> +++ b/include/linux/spinlock_api_up.h
> @@ -24,68 +24,77 @@
>    * flags straight, to suppress compiler warnings of unused lock
>    * variables, and to add the proper checker annotations:
>    */
> -#define ___LOCK(lock) \
> -  do { __acquire(lock); (void)(lock); } while (0)
> +#define ___LOCK_void(lock) \
> +  do { (void)(lock); } while (0)

Instead of introducing a new macro ___LOCK_void(), please expand this
macro where it is used ((void)(lock)). I think this will make the code
in this header file easier to read.
    > -#define __LOCK(lock) \
> -  do { preempt_disable(); ___LOCK(lock); } while (0)
> +#define ___LOCK_(lock) \
> +  do { __acquire(lock); ___LOCK_void(lock); } while (0)

Is the macro ___LOCK_() used anywhere? If not, can it be left out?

> -#define __LOCK_BH(lock) \
> -  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK(lock); } while (0)
> +#define ___LOCK_shared(lock) \
> +  do { __acquire_shared(lock); ___LOCK_void(lock); } while (0)

The introduction of the new macros in this header file make the changes
hard to follow. Please consider splitting the changes for this header
file as follows:
* A first patch that splits ___LOCK() into ___LOCK_exclusive() and
   ___LOCK_shared().
* A second patch with the thread-safety annotation changes
   (__acquire() -> __acquire_shared()).

>   /* Non PREEMPT_RT kernels map spinlock to raw_spinlock */
> -typedef struct spinlock {
> +context_lock_struct(spinlock) {
>   	union {
>   		struct raw_spinlock rlock;
>   
> @@ -26,7 +26,8 @@ typedef struct spinlock {
>   		};
>   #endif
>   	};
> -} spinlock_t;
> +};
> +typedef struct spinlock spinlock_t;

Also here, a new global struct name is introduced (spinlock). Maybe the
name of this new struct should be made more unique?

Thanks,

Bart.

