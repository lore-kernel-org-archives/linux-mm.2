Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5DACF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1942E6B0098; Mon, 12 Jan 2026 17:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BDE6B0099; Mon, 12 Jan 2026 17:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077B86B009B; Mon, 12 Jan 2026 17:05:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92BD6B0098
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:05:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98E3913C54E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:05:32 +0000 (UTC)
X-FDA: 84324694104.29.1BC17AF
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id A158B40003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:05:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=hs5fvItj;
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768255530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9Y4BPiPU5vZeqyn1OIEPsktkMud/fciou6gPOxT/Gg=;
	b=h63cnqvppJmhUf5gPvQ6uY5DqDao4UhH52FQQ46SVmpTKnHPVy8x10fDasCWwviza6dZy6
	ReagnHDo6wanlqDW60RKy/c/PbSbLOEtaw8N7L1bZ5oLTOOHTcPNfVCnA2tut1EGXyu1nL
	giNWRkb7wGZ1K4m/27eAPSsSJJbMK+Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=hs5fvItj;
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768255530; a=rsa-sha256;
	cv=none;
	b=bgI65bg6aaEl+QiRz6lIyy6Xs41bNtThN0BMn/0mXaa4SfJFKMjjgJD9TXqctTzpaJXzD5
	joZ9hMaXw7+8Hy5ADDlh/gDm9HyxvB82USqh7nPrQIvuMbhLg2To3frFg2B0Asfwnk+o62
	BbmlcX/Czzpxp3oAU6Fgf0ba2eZMoOE=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dqmf137mPzlqfHK;
	Mon, 12 Jan 2026 22:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768255522; x=1770847523; bh=z9Y4BPiPU5vZeqyn1OIEPskt
	kMud/fciou6gPOxT/Gg=; b=hs5fvItjOEws4VXy8vRpfYKZ6iyXl7qohAnJxjPR
	hMx4gdQ+APBsH3BLqhgEqPQMix6M9gSCOQ+5eME/2LwroWVIeUXroMEG/a3Fqknq
	FdM9OcgvI52xQwiErSfBLyFlB92ssvSNbndiHo9uc6GBOBa5lH/lnV2YC61stTL3
	LgoJdWlkxhEDR9qAW8cLuNUpV/2zWO3F1/axpXRkpjUl9rMX+fIxGiG/iqTNxXBw
	3RKN/ZrDAQ0P7Yt0aHJfTt4Q7SG8kjBXQuspB49gAWBnigIUkjm0NYEsZkQyMT+Z
	2mZFN83sJGRk0MscnaN1nLn9JPULOySkmo9EeDGhgsGmAw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IkkI-SR9t1-b; Mon, 12 Jan 2026 22:05:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dqmdS2QtzzllB6t;
	Mon, 12 Jan 2026 22:04:59 +0000 (UTC)
Message-ID: <3de714fc-7a18-4bcc-9ab5-c3831efbdb84@acm.org>
Date: Mon, 12 Jan 2026 14:04:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 36/36] sched: Enable context analysis for core.c and
 fair.c
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
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-37-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-37-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: izxg41mou9f93m8bzacztxi8c8s4a7ff
X-Rspamd-Queue-Id: A158B40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768255530-709893
X-HE-Meta: U2FsdGVkX19PGRBq3aHdnkS5jpVBU2brecG+HAPeJuSyZ1rki0czsnwnqU0Bl/0+8XXhZDnprm+gV2JWhRjDp1t7eGGwsQisXysSa83Yj6/4swuZa1Ou65CxzOcNnrfhMGG5nxZibSNdEpubsVwZ7yVPBSxw7zwVewUZRZ1kT3ICsD+1s772JYAww71/wDad8Tw+CICNigFqmIFHRiAMv0Wf9y7ZjY+djfLkb9wb23w536V1BLxQskM8TibOdCjQNv/axdRR3j5xGvpSCBrtZEF3vXyKMOm/aDu0r2Wykz5i4XKvagvuSoh6oiZum/+NTJGhtJ5ww0E8pCCT+SusuUDTWasEDfXNnZG8+w4ehrXmIPe1BygzNK1Rx6fJ/Q52qPnsOhhzFWU9V58MrUnf3Lo93iRSh7VsJWxfsWdCwkI1PwFHzOhWeLHUaFL3Z5MignNc034IAZRKr8X6fQ0fqE8/p1Lnv+e0YyQSoDTbtLiE4qdfPMpz3Epy06kdiM7QnBFlf+CFa1TD6H0qjq3euy5FY6EXaHlzRDMyc+ukb5Tl66nhjqhULU5bsrkC2i/KA2f/YA7qM1QOF6oatbsIhD6Duy4BJOR1o0FgYGhhLI55S7hLOLo6uYBirhujbu0opezn8MTmiWZs6fz8wpWEAswZGl6QA7Zv+G8tlWWd34a4dL2aJsiid/a+D8mp6kRuOAnD/7k8J0K6LIQShAESIVVhIqN1a66L04bwo4gvPBVmVwXoR5BoEyhA9U1joPQKHHlHpy+RqNYy8zr1VelDRnNp8a2kR3JCdPpATna+EZVl2/nqJt3ODxEMTTwJh7FVWMSZ9UMCe9OpPOWnIsnXW865v5kPf5+W7Rt3qf4g5IP3yk8jlt2CAw17+VwJCTMpfzRmsb//TJehcFOvAG9VD1m1iGmayZZbjkvDrjrED9C2XLlzgWe4SAXDdI4iKGvyFiukdIWRgOH3ulbv7WN
 6Egu9ue/
 P+nmBghtHYx4udU69v/esuPwRtSYfEoddn6ZBCCA/FElVAruZDs8ICkDBrVhAi8TYrQKBHXpuCibg4CROlrI0sE11fpXCFv7ym2Bn5NYAW42iygREjsgD0H2PtFDj04LH5/ROb+V0psKvXaiwuAMM8K0T6AmBjyZofNLbxwT4DK6dsB7qHrFdzdHBfxr8kAJ8wRs6vNr9XOr8e1QzKmDi01oyyXVNBguXGlt2sjtqwBFST/rBocuj9x1ndCT1iApotCW46uETCdMQ0Dcjrj7y95oXDdkSSCzF3vGekR2Z/PKedixlg3X9NX+3kw9fVUjCWjqpgdczuEUQKgP4yrSCFE7b0AqAA4zf6f9Y1Y+6pb6FAGSGAOHdaUr+i+BU1lfu30rjM0BUW0k8wzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 8:40 AM, Marco Elver wrote:
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index a63f65aa5bdd..a22248aebcf9 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -738,10 +738,12 @@ static inline int thread_group_empty(struct task_struct *p)
>   		(thread_group_leader(p) && !thread_group_empty(p))
>   
>   extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
> -						unsigned long *flags);
> +						unsigned long *flags)
> +	__acquires(&task->sighand->siglock);

I think the above annotation is wrong and should be changed into
__cond_acquires(nonnull, &task->sighand->siglock). My understanding of
the code in kernel/signal.c is that lock_task_sighand() only returns
with sighand->siglock acquired if it returns a non-NULL pointer.

Bart.

