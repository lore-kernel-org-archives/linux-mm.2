Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B0DD78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A526B0089; Fri, 19 Dec 2025 14:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1736B008C; Fri, 19 Dec 2025 14:12:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2E36B0092; Fri, 19 Dec 2025 14:12:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77F966B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:12:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DFEF1390C4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:12:11 +0000 (UTC)
X-FDA: 84237166062.04.C3BAC8C
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf21.hostedemail.com (Postfix) with ESMTP id 342A11C0011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:12:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tz2g+Qqz;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766171529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBMt69sCffmrONEUk9HcTp6E3Zeeun0qAoojziALA+o=;
	b=kIuT0SlwMS1sc1DEPmn7GvZOGgL/LVJRTr/Rt9v/VJ5/ILFISFpVQSLjzXNmg/pmJiMD0q
	PK08HbH8vqyIXpxXPxl4RgcuB+jRVlKUWlbSIxUVj1+O3XVtqaukhWPuPpWqjayVqQ1PvA
	gRSpWc8fcYAngsi3p3OE7AiLcMusN9o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tz2g+Qqz;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766171529; a=rsa-sha256;
	cv=none;
	b=aIuCtbHIEB2AlFc5yYk3NuIBq1LN7KyQ9JeM1L0fYqBUnJlKHSNp3I9nBkHzKsz7/BS+np
	/V1W0Djx0FR64X4VHhHJpQC3LeFXkx9NGWWtZPVryx9xmHaj5HbuYWUAeUbl4cDRDzMVK3
	NodXIBnrpaurf25CZjcUNkCyO0K8NcE=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so20121375e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766171527; x=1766776327; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBMt69sCffmrONEUk9HcTp6E3Zeeun0qAoojziALA+o=;
        b=tz2g+QqzLB+OUFW5PbbkYelNpXaVgYmtM/CQY/0mGLU5T2wRUoUU9uG8ltejNR8cOl
         VG3K+ZerGsSTvZzeS+Wr6Se3D38GE+NHG/z53qp1z1qUR8MABHK3h5l7H1nGY1lPVfgk
         r6AmMS68K3AHr0w7rP7Sin3evAnSPLxeHxkkIFbkaqdQTbTCRuSwHTiy3T6iOAjR3yzj
         3nM3uo+5p7xAzi9l/FFrSmbripQ7IO2cEJlqsFZcu/s/LgVFGDXoIPiPpxdQYm4BXiso
         atbvQikXgrjF07nOaPo6I7JzuYcK97AqDJ20eAHDEHrV5bMUe3zi4eSHoxe39fbZbWUm
         Uh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766171527; x=1766776327;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xBMt69sCffmrONEUk9HcTp6E3Zeeun0qAoojziALA+o=;
        b=CNA9Z8OVkoF6+iwwm4TW+ToVasnI8Q/0tpZE3txsIpXaDCUnN18OzQcj4CwzGau06j
         N3jB+lEisiqRG0/w54heWLEK+q+mO62EcDhMuyWIfdQSBt8zwB3V3JhhUNwuPdxasySU
         SIxWe4AqiMjXqsZH5wdZuT/QQAmOkDDJSKCKbfvJ7gZuB0KYuxHyZtPXf9f5gIaDlYC/
         cVvQM0zhR35TiyXEalO2T15riPGsKGT7OPSLLeS9jMM3NwBP9W/tyg9TEtXBOy8nj9Ih
         +XQq55hMxxX69dkDVHNC6ak1A9UaonVo376NwUJcUKMY2Nz4qPqdffp0w+W3yVnhWN0U
         t9Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVCJhA40hkk1acb7uGM/UVfksMi8orEo8txsQhZqQSqP67y3ssjPwZQWgkvMy+5UN0H7odMmB6JjA==@kvack.org
X-Gm-Message-State: AOJu0Yyp2dcYX8hmxuLnnQGcbKnGyL/1Oe4keu+dcanF8oyzc7Imjz+/
	WkMNOH/JOfB7EX70ZYrQ3HjG9Z6tB5qy8vBFghUgEK0JgU9rOQrbCbAw2vhD3L7KSw==
X-Gm-Gg: AY/fxX6ZdeIq2tFN8knOXiBUQOjjOjns2dS1NBTf3c3iU42pVOpg+EBNAQOPbuACkHe
	Y4so7wCyHU2oZOxLqBvvgS67GzvFOYFoVIQHpYKMIKtppBoCc8OJYG9/ivQMi8PFChnL86AMwal
	RxwgVIHNx/JB88M7MjNJ4j4EMAmQF4hVYLb4uKYdwRpUS7bTyOvBn+AsJMtcqQxDRWmda2cRdfT
	nHjOH5TzfwOX9w+GHIseOH153gTu5I/zUXcrqZfnfD8O9rDlw6m1NSf0g5sxH5BkGM+SbFb4/m1
	OJnF9jVmXTyuk/ZHXSkkQPzxi8rxc22YKTPXTo5Ie6Ov9+gVboqKhC6J03vSFhgi2gZyGw8DPEF
	0PQfRMtkHcZCdvuhdcTsal0xoau90Bdh2Y+BwPXvklvw0orGc6P4k3+epttfnAMqbagu1XwAspq
	ytVf8dfuRE3HD9IaB+FApv4gMvAlIFWYKQ3Uq1wz6MmfyK1OuM46snZLXHnO4=
X-Google-Smtp-Source: AGHT+IH9HIskBRHlFIQr/Osyy9yIUKVMwuoBBZxTrb8MCYHFqdOsUtEusA5GjiNqRLtoiyidJxfWVw==
X-Received: by 2002:a05:600c:3506:b0:477:a246:8398 with SMTP id 5b1f17b1804b1-47d1953b774mr34567195e9.2.1766171527309;
        Fri, 19 Dec 2025 11:12:07 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:f7c5:1bb4:fb06:fd5e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2bdfsm6628486f8f.32.2025.12.19.11.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:12:06 -0800 (PST)
Date: Fri, 19 Dec 2025 20:11:59 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
Message-ID: <aUWjfxQ1fIZdxd-C@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-3-elver@google.com>
 <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
 <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
 <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam02
X-Stat-Signature: o7sxo7hpwmxcjexntaeddwnccs6macdj
X-Rspam-User: 
X-Rspamd-Queue-Id: 342A11C0011
X-HE-Tag: 1766171528-343992
X-HE-Meta: U2FsdGVkX1/u71nt0pKddMf+dVnyfO+CgFvRaCR14YPTK+Y0WYk3hCh6ZPd3CTK81i93kpTFLuczW7pShY9C9dTf0iqvYFO+TxpgrBLmgCSHW6w//vsv27imqmwc1kiqj3KBGjSnCZS2/jjSapaD7a2DCSQ56BIRHT3ZZSC2R9KdWdEZQjuF/oT519U2eFp+KnvGWz/q3MgZytzPC5lugBoYICIrFTratsl1DHxj16fwdhy4qRFUEnVRlcLY69PVVJ89dll1xGYkUKXhrgwgWpQi9BhXEYoufW+17JUZ8UjklK5uu5QL5zGBrtEsbGP3a1TRCcHHypfh5w/ksuoYYCh4B0ZoM+P5pHOjqsFunWO0MA2ZqcE1VpPm6ny5rDjHzbydOt4dacpaIZVSezpEdn0PIQzLw0QAEJrUvD9MTLsW2KrEVt2WGVBjKO3l9e7OrsnAj/bGuYjP8aDkX6DNtZbA7cI0YNe/nLZroUn/fUTxwPfDdiP1XNWCrWiho4FqxU7doaBrqseV2N4HatqlWy3NqS3+Zf4gnTDn9wb8uI9qR4pC1K4OwG8W9TYx/1uW/2MsekNcj8+32lozswTnfXUPByzruFIZ64IR6jDEvyNpI9zWf3AO+6R5NOSEovdKOrBSal2PocrXx5N1R9O5/XpSO66tyk3jwRONuEiuPcCSAPCgW73rSS7OVEHmzLyEUI3XEQzuAtDClkqLzLspvAU7SKXA4NzTQzTar7lf77hzWdVYdc1du3fuQIhjbeBc8TcA001sraW/0m5uYkI+h62Nli8epFAkXJ2y1tw5zawIqN4/S2nuPch6tDRcD1nb+DofHYro8OKU20MaNpD3eaHjaY9XoAMiPn/41Py03Q9+E2+vktD0Sw8zXTaRi7IMBuqQM5hRKX73MJ74N6dd2quXAmhsfKNE+6v7+v/BWrkyAcLuMNIZ4QrB4BVImc2wfoJtN8TmWxKyDP6UhoW
 hoBjF29p
 MXpr+1mUyh1ixVoGGyJeiuJOofojSC8t/NS3aoTSKVoJAZpwxkX58TxbRq/B6YWcsnBSNv4995e/wuYq+3FnHv1Ln9u79VSGvRE0uM5kglRtCJsDpkXO449AQbiNgDuHGUc3OIZ+Ao4xQ3TQg/4bktjfi8gANFoNqXg7n7WLbvjP/ZVxrez6TV85XXSK8VjBYSUhuH0GaZsHNQsTCNcHvTi+ed/jhoSC3ImNPQoCuaHGqfziksbYHDDESQ6v944tXLoWpyxg/Z4SlZqBz4duTxj3AmdbhSsbkc+xe61ji3kAgT2P8toTCVQzWJxZq7rvh4hVlyiAIj1VKuz1pSRW05gA1bwL1G34Ek7aYX+XNzOpurP+f2Iu7LZjurHdZHipzkT/xdQRTI7WPJ7KyHZPcxsmrrRIDzsGf+JDZvth+sWGbEvAzJb8PhKO5w2XC0uB9Gr/50jv7AEtBQ3qmkcvKljqSvqHTRRZeZbjO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 11:04AM -0800, 'Bart Van Assche' via kasan-dev wrote:
> On 12/19/25 10:59 AM, Marco Elver wrote:
> > On Fri, 19 Dec 2025 at 19:39, 'Bart Van Assche' via kasan-dev
> > <kasan-dev@googlegroups.com> wrote:
> > > I'm concerned that the context_lock_struct() macro will make code harder
> > > to read. Anyone who encounters the context_lock_struct() macro will have
> > > to look up its definition to learn what it does. I propose to split this
> > > macro into two macros:
> > > * One macro that expands into "__ctx_lock_type(name)".
> > > * A second macro that expands into the rest of the above macro.
> > > 
> > > In other words, instead of having to write
> > > context_lock_struct(struct_name, { ... }); developers will have to write
> > > 
> > > struct context_lock_type struct_name {
> > >       ...;
> > > };
> > > context_struct_helper_functions(struct_name);
> > 
> > This doesn't necessarily help with not having to look up its
> > definition to learn what it does.
> > 
> > If this is the common pattern, it will blindly be repeated, and this
> > adds 1 more line and makes this a bit more verbose. Maybe the helper
> > functions aren't always needed, but I also think that context lock
> > types should remain relatively few.  For all synchronization
> > primitives that were enabled in this series, the helpers are required.
> > 
> > The current usage is simply:
> > 
> > context_lock_struct(name) {
> >     ... struct goes here ...
> > };  // note no awkward ) brace
> > 
> > I don't know which way the current kernel style is leaning towards,
> > but if we take <linux/cleanup.h> as an example, a simple programming
> > model / API is actually preferred.
> Many kernel developers are used to look up the definition of a data
> structure either by using ctags, etags or a similar tool or by using
> grep and a pattern like "${struct_name} {\$". Breaking the tools kernel
> developer use today to look up data structure definitions might cause
> considerable frustration and hence shouldn't be done lightly.

Fair point. In fact, it's as simple as e.g. (just tested with mutex) as
this:

diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index 80975935ec48..63ab9e65bb48 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,8 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-context_lock_struct(mutex) {
+context_lock_struct(mutex);
+struct mutex {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +60,8 @@ context_lock_struct(mutex) {
  */
 #include <linux/rtmutex.h>
 
-context_lock_struct(mutex) {
+context_lock_struct(mutex);
+struct mutex {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;

So the existing macro does support both use-cases as-is. I suppose we
could force the above use pattern.

The reason it works, is because it forward-declares the struct anyway to
define the helper functions.

