Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5289E66895
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235EC6B0093; Fri, 19 Dec 2025 16:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205B46B0099; Fri, 19 Dec 2025 16:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111496B009B; Fri, 19 Dec 2025 16:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F05B76B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:42:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 942B786935
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:42:44 +0000 (UTC)
X-FDA: 84237545448.18.69D2F37
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9431EA001B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:42:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqlzBM9K;
	spf=pass (imf25.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhB1Fco/aAscGV7BUmHv+KRyMsa6iylEkhRycjuIJTw=;
	b=deQNt76RRuzULxgt8j5ysdf764bI2knC9C59vOfyObOEz4Jk0sPokpvcn8VyUA0F6BfgRj
	DTa5VushXEFrflMppxWymheTSvlnBKqVIVxOfo6Da4sivtsnm73jVHqBjNeVq6YvaOxYGR
	3VW8ENSyGqGfMagXPpbQ02v8aLPDVsc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqlzBM9K;
	spf=pass (imf25.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180562; a=rsa-sha256;
	cv=none;
	b=27RPHle/xoIpCHUK+tMvhQWLSpi0TjfxYK/syBiazjAUKz87fwe/YE+c9SJbALlYxZ8hWs
	CJObBMmF2yIGH0ARca8hAgWiRSk7bnHHIbQNOvs5rxq4nrcMYjSh90e3sL3wkR2BIwfefp
	6w2jyBpVNdfJlKqSAouL4e9RrBaUueQ=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c03eb31db80so1672731a12.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180561; x=1766785361; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xhB1Fco/aAscGV7BUmHv+KRyMsa6iylEkhRycjuIJTw=;
        b=jqlzBM9Kr0uhfl9F/bDU1HsTvVuJiPrfHF3yt5sY+e7JL40XDJpeNwvN1s37clJaPw
         9sBxOS2ljz7xC2s0iOWPqMud/M/9+h0wHtJRZJX6EWVb6fP3/IiJ9beL9X7h8WFiK5z4
         dbJbp4WffV5n2fMRSLD1DJM5Mvj3+WArriPy86HuM9j4q0bO5A5uxn+DIAfrXm4EzeqU
         5WmwZ7SSoL8BTU1EIfEOy1tOrZUImsNtX60q1Lvipj4i5QteJn8O5RZheKERrCRPTzwi
         NQWWF5NqywnklAJDeVEjO5TiRltwTOD7ZyxzR0n3d5RXrjIgHaSOLdTzDh560Yz3sxhb
         +Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180561; x=1766785361;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhB1Fco/aAscGV7BUmHv+KRyMsa6iylEkhRycjuIJTw=;
        b=hHmS+tds2yLLNrLEdBb2QCZhdVdiziZVcXCjpAtUs//CjtrtbriSyVYfvE1Wa5SuwB
         D0eUJW3YYEs8V73L9tdEcpIsKSM5ljMqdCWem0F4MuqSwEVvwv7x0TrOIJEjD9m8F3br
         ceRMvoHzIzOgDgo56Xs7QMq8oUe2cR8vUAh0A+B90R0iRZL5wNka0ttcHtoV/9wfDYyf
         T6TpHwM5OJt0wUmTR1Q4YB3M8vuK3R2vVGRCF0gDnh0WxVSrNCWmOlhBfDyfFE671L9P
         Szuk9DgubgMH/YFkDfeXr1xzj9bsmEkcYz3fvJIvzXM9nRP6D8zyn6RFPs6+VmrMl6wk
         CYwA==
X-Forwarded-Encrypted: i=1; AJvYcCXHY7lz29JtRnDfluhvScnuB/KjK7Kzlwurx5TCfISv+YxwEGK7Z58JJhu/kL6uQ376XgG2XO1jBA==@kvack.org
X-Gm-Message-State: AOJu0YwZoj72YZRoeT6Tvl0xXfe+bTF3P5OtqvfN+LPggY65FQhtXo/j
	EBdPJI4VVzC76d2KXiEqY2oIDxFB/r045vm/lFuI8Mks/9dr9mazAd1B
X-Gm-Gg: AY/fxX7VWfSCVCz8Yk+EUIVURcEvHrr9q4EZGm+42mED6F4W6s/OLgMfRt7zERsFWth
	FBdCEyPPFxP33Mc8tM1nMKiOZtZvpoCGwyArfmpkcg+ZLPiOnNqMbPDUqdXgbr//E8fCc7fAQqj
	wM1wc8b3gc2eUbGTCct4jubMPphswQHhqN7Hzx3soaWN9MqiRXymE9MxR8BHjiStek92cOYpfXB
	ma8kWEvfCEI3tUJT2Qrdbe03YSNlGBqFGguDmhmdNBAdMQxC6Us17oJMPHOpNhPKk82XSsjR2Dk
	7hDlPMlEMy/XcEBAK5NUUlsrbifnQQRv/d1hP9atSHDA3emM5y7s/cdFEAikdUSBGm/u0Tjdtg7
	V3otIm6X2OJUJVjB9Sp22BBdQMH4srX1kxcg32icqSK/JW7jbpGhrSKZe42muPJVaDXzaQaGbea
	kr/Wfgp5vgQaurgr5mgKxI/seROas3P9VdCsXHk5QDrHWFkJYhqInvqjASBpRpD4gLt5EBvr42O
	jYtCFtKx1HGjDp4EWyQiiOsX2+Vgk2Acqaj5LJpW9EsWnhKoBUp7T2VxHiWZqn7HCehRvV1C31c
	VcU=
X-Google-Smtp-Source: AGHT+IGTM6mjPPfNhqA9HPe48U2bDECheHzAzGuJpcTxojW/wC3VfdWLu4jNEE4Msq7vw7t+QoPUtw==
X-Received: by 2002:a05:7022:62a9:b0:11b:78e6:8323 with SMTP id a92af1059eb24-121722fd212mr4438541c88.37.1766180561251;
        Fri, 19 Dec 2025 13:42:41 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254c734sm11636083c88.13.2025.12.19.13.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:42:40 -0800 (PST)
Message-ID: <9af0d949-45f5-45cd-b49d-d45d53f5d8f6@gmail.com>
Date: Fri, 19 Dec 2025 14:42:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/36] compiler-context-analysis: Remove __cond_lock()
 function-like helper
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
 <20251219154418.3592607-25-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20251219154418.3592607-25-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9431EA001B
X-Stat-Signature: igcyzhc8redm7b96bbho4gdrinbzwnm3
X-Rspam-User: 
X-HE-Tag: 1766180562-143698
X-HE-Meta: U2FsdGVkX19Q+/QDh6P2/0kowIrvvR42ux5u/d3DlVnm6Bqgry+pDuFi4IfjskfcEjqfxyde/Ceid0Z3B17VV3Mfq4BjFqiZld1SbFdbOKk+MxUITYjE6jO7xLUuxGIPV5ujJhVAHmVhy/lXF/Hv85au+f6DlaSN356JVR2x5rIcDBCJx7sgXkfc7or0SSngQZjtKn8SRSaQUsaDwM0zc8HshSNu+InWZpzZDBcVT5YO0aUxGDLrBZo5ryDNWcoEy6UdvS+tUjEbhaMsJyw4BuKfIOD2aKChyf2YkL80z4V+mJQwanSEESeMS9DQt9ZvtlsCbcxfrPOV+KOv30CmaizYGdYtCAj2U6zwLJJNKHGLtaHMOe2PvVzhkp14MANY8t8bFzDAVZf43b03PcyHVUwbAbjwe4gx+HL+anx+LbFn1wyKuNCrulglmB/6E6ijMSJxWhezddiWOHYZL+hWAIGui1NgnNhgzp3Yya9lsEyjIf/InubAVEB7vE6jgWUIxwfa9a7NEybymVttSvaYzV4Pkn1Bs02dM5sWIs0FmMe/P9EUxsEV8KPnrUlIat2+7+hzAzpyPhmEnt/cSZoCoGew/QXHHikgJl1lRgRruoDDRn3gtaEF1NoaGVFV1e3G5UXm7n10prIuMpZ18RmeIndtUGLzv7z9vgE5hiXMgEGP9QWNHaNIDRQPugJGBImuXiJBkQ3jDiu2xA0vTrhjRHAWqXvg4jX2WleTRypzX2ahW06bm1RlLUZxfptnqip9yVyyO4ibnjcWW+N3WdHQ5oInPn9XQRARZD46F9PHT6g+adAvItVK7HqhaUSHdIA1FHPiFhfEH39icso4U6QGOqmm/BWTMzGbX057iG/lzgDGg1X/YYSuSLhVozr37SeEMz0d+7wWCSEE8R8UIF5evSPnkjNsx8myebFytG38WjwaiP/PNkJqZ3PLp3wzkg5cRNBIXQXjax2mrPcOHVT
 fG2osXOU
 xAO/4D84tVREROqxAEU9SG6taF/Cw0Okbt06jK8xePhvrMLxLaj5rZorift/2zLavzqn9gav0M42B4q61Fiyk6d6c/yNtwOPdj+bD5km+JeDUyPYcL4K+VBKomxOv4H0z8mQb8cTILjCLfOO4C+WdXHQddCxYw3Np8ent4wY50s+rTylO1oRwEZAmzr7Of2NYdy6zwzAL+T2NDMDeMOpCHRSuaF8sV9KPegEqyoDQecSbtIb+gyzSzQWMqOCvwNWHGg+wt0RNtCdiLYk9oQrluK8p6AcXv4t4QcMc0R3VJiYsIGe8r4pcgk1V6Q397BUKnd5BGFEme7jR5+48GI4ht8ExrM+0rReV6CwY+QyefMaa7qncFN2UIdfFxWY/L4Ycms/HSsEgsPp//nVJm8CQ/hrsMj4+WlOGA/HyAJdrliisMO+2NFvJJlYucG1OwdKb5lN2phFoUAMqP7wwh2b3Mg7VQ9nobS11xQK9JhYtgrrrHZ/w90lriVd536JDKExc4xJTA5qbaqebK0VP1kQoMXECqgynX2bTO67PvKMIVX8Y50c5FQMUa7stOR2lLA+CXfN+1D53DAhpnNnhTbHNwFKB0baJm93Y72H3TGGNDq+bsLQ/SRx20RAs4HA7InbQ8opRkEnWYCcloJSFeuHxZ2B0+S4JDt9bHLAqZ2MhpKBYevAhe8pONDVV0m4UD9sGKuAdWY2ijCjWohfaoXaAgB9H1AsDHnidjrDK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 8:40 AM, Marco Elver wrote:
>   Documentation/dev-tools/context-analysis.rst  |  2 -
>   Documentation/mm/process_addrs.rst            |  6 +-
>   .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +-
>   .../net/wireless/intel/iwlwifi/iwl-trans.h    |  6 +-
>   .../intel/iwlwifi/pcie/gen1_2/internal.h      |  5 +-
>   .../intel/iwlwifi/pcie/gen1_2/trans.c         |  4 +-
>   include/linux/compiler-context-analysis.h     | 31 ----------
>   include/linux/lockref.h                       |  4 +-
>   include/linux/mm.h                            | 33 ++--------
>   include/linux/rwlock.h                        | 11 +---
>   include/linux/rwlock_api_smp.h                | 14 ++++-
>   include/linux/rwlock_rt.h                     | 21 ++++---
>   include/linux/sched/signal.h                  | 14 +----
>   include/linux/spinlock.h                      | 45 +++++---------
>   include/linux/spinlock_api_smp.h              | 20 ++++++
>   include/linux/spinlock_api_up.h               | 61 ++++++++++++++++---
>   include/linux/spinlock_rt.h                   | 26 ++++----
>   kernel/signal.c                               |  4 +-
>   kernel/time/posix-timers.c                    | 13 +---
>   lib/dec_and_lock.c                            |  8 +--
>   lib/lockref.c                                 |  1 -
>   mm/memory.c                                   |  4 +-
>   mm/pgtable-generic.c                          | 19 +++---
>   tools/include/linux/compiler_types.h          |  2 -

This patch should be split into one patch per subsystem or driver.
E.g. one patch for the iwlwifi driver, another patch for the mm
subsystem, one patch for the rwlock primitive, one patch for the
spinlock primitive, etc.

The tools/include/linux/compiler_types.h change probably should be
left out because it is user space code instead of kernel code and
the rest of the series applies to kernel code only.

Thanks,

Bart.

