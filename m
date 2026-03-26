Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80271109E52B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 01:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4F76B0089; Wed, 25 Mar 2026 21:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555E46B008C; Wed, 25 Mar 2026 21:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BDC6B0092; Wed, 25 Mar 2026 21:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36C146B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:28:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7F60C18A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:28:53 +0000 (UTC)
X-FDA: 84586480146.10.0DE5E2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D6AF40005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:28:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLfhqhkz;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774488532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJUyYOE4gNy9nIbHmGhUMsC/EZizc05mxfyrzumWyhc=;
	b=pydHbjz7g8osGTdQy/h/7usx7Qu20OVGrbytKSteTLwqeFNaehSDOmbNASSjwXMi4S0M+a
	If3fNgnBWmloq3r5/a36md6tbSjl3INMDMqgdot5J3mXTzlKp9ntb/4LSKSUq748rrrnHG
	/XO7h08bCOCDJJHQ63m/IgT+de4OSto=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLfhqhkz;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774488532; a=rsa-sha256;
	cv=none;
	b=GqPqLLTqxgDrgxE8cqENCizHVQjAWj9e+rocUqRsaaOO14zPCLu/k0P2Bo5UKxdklgAWiI
	NcWDDz1AWRl2ugR3kHugnbrDoFeMv+QPYdrOcjRnQQfWhVyM6wuPbnPEgPN+gC2H9tN3o8
	YeX7UBnRH/3KcihwsGbMC1SoYMcVdDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6626160103;
	Thu, 26 Mar 2026 01:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3592AC4CEF7;
	Thu, 26 Mar 2026 01:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774488531;
	bh=0Cq7OMqDyz29Hy/YQIvOOTgh39yp/jjxAwDycnlq/O0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MLfhqhkzsxa7tc0jHzhytzV6qchl81dHU9KAPgpYRYmOHYLzk4wblKHPtqEHyv28p
	 Q/b1ZGVBAKVMA2DtsWIH4xs0i1VJ2p7crVWlc/njQGIq3j2rxJcz4zZlqQtGtXSKGY
	 qE7kmn3skAAmdHpynUh6G1IcDYzRBpRJQJ2v9dHtuEYl1SHM9u79m3ODxDTtFbRHwF
	 TrXVRIXikjQcC748T/h8YzRRuj5Is74hno4IqadGPqhCATzpJM+vXtHmT1645lImlw
	 xbcKSEnaeY6vjDCFgor9rDZ7RPAf5TB+nN0PUncVs3G3ToCrGTMxxDR5q52eHlIdvK
	 yL93d9yknBOTA==
Date: Thu, 26 Mar 2026 10:28:40 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra
 <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon Maloy
 <jmaloy@redhat.com>, Aaron Conole <aconole@redhat.com>, Eelco Chaudron
 <echaudro@redhat.com>, Ilya Maximets <i.maximets@ovn.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org, Jiri Pirko
 <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz
 <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar
 <viresh.kumar@linaro.org>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
 Huang Rui <ray.huang@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, Srinivas
 Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org,
 MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park
 <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, Eddie James
 <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, Joel
 Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, Harry
 Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, Wolfram Sang
 <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, Mark Brown
 <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>,
 Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Thomas Gleixner
 <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, SeongJae
 Park <sj@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/19] tracepoint: Add trace_call__##name() API
Message-Id: <20260326102840.80a270ec818fea7e000aeef4@kernel.org>
In-Reply-To: <20260323160052.17528-2-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
	<20260323160052.17528-2-vineeth@bitbyteword.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0D6AF40005
X-Stat-Signature: d1s6nmyyqacg73g4ppu6o4moa7y9xg6z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774488531-426713
X-HE-Meta: U2FsdGVkX19yf4D2WiceWcLln25TauRFgpTB65jX/6JX1NnBU6GNGnqrTsnWZr91FFk88MW2ydM7jRnzZCHESt5l61LgtHx0m4je/6BSguCEUu0RYvzfyTdC9BQfbI0hwsk1jB+6K5C0FXe4tM2ptgkwEq3TPB8xVOGvUThqPBcDiIBQ42ErY8Vw/C0ti2+UzViZ0QveLU/D1XFrCD0pzAmSBQQ7sIE/kN8cY3IjACxIcwqURFaVerk5m8lQKDibeDDe7W23iuj24srMtvYzBMpmaPcflyN6yw3TisBdSsjLYLQONdGZjb6NRLWeNOv1vd/IRPj+0p1zj+ikFrok8HOSZy6H9WQRrKQj191QWktNGQhNejKAuj0JAZSjYKZyyprrD0Ezrbr5yiGUa0C5V30fH5M/UOeFv9S/otaahDCYbmk6ziEFR+eYeqjZkvvuHIIek/VWubVC1Kd4C+RzqiU4dUD888Qy7b5rWUPT1ASfk+MYaapT7lAAq80Ys2Y0YNQPb3pPczJ5JiyKlRCWhmsk8i6ODysHxZtrXHVUZNWHbBir55S967AvNIgLN4t1XsQ5exWDR24BsST9UNHRZyD3LWX7h7x2fNJK+MiPYkX09gCRuEgxG6jOiXjPuNUfx2z79/Qz0gUhPF3McD91QXelvrBia6xGv5LE1/YjhN26OmrCPL3a7pOxnjte5E/pxG0VcA9CVtdyxU8MuzNWzimmiZuTrlXc9i/p6RjFCtczgwKAGUYppJ4SL/LYuC/pvzY7WNIOwtfUVvNHtUheuPC7kvVAXKmlU3fuhiG0/Hfgv+2EJl44ZieWY5Z8jmCqXiiy83u7f+RtcTiPO1ZVXN34FxrEDu28lIKphttyouNxckbDTYSPtYqASESW7ZnkcpReUqOeMJwKKR8y7BvuHdHTgOHwt5h8C1+E1cZ2EwtkMIu5iI+vrk8ocpQ50MECh/7JVJOWqfrX+J/bROC
 MwGezuTC
 T5rmdEkqTzMIIsPN1AdqQGEnTEhmgnabsFSaxmqKlYjHuLmRBx3KHT1SJeV5+/V2ZT2rExZIuSoz1cZgqkyra1RTuntFl5OFmCyAjMjzKNVQsKOC1qmndUv2SR2fk8b65CNMR7CTuS/DNHkQU5+0YhmrbnfGDOXQpg7YjLaI62w35kFp7mdOw+UccoIBJN4OxjpPCYOurHPxqt7pjgMnStIbpbO+Pyrbb535+wJWNKR+DGTbjQkk4DUKfYXzFOZjLrEMWUMIwgPTgGU1/lpUnqIQFgl0e5l2V6n2XCxZXE6ZGRAf3YI5rDLcbcTj7TcqIt7Iatkwz4+bpDZDAYo64Io4jLGN/k7Uhv44H1DG0Sp3MTQKgCIiwBhGrDuKanBBtjb8ryO3iXlyD92wgMi5dVLmRjyk/jkfRJrDvwsBkTB1k/qjZ4gDoDNTuwMze8hBdmgViwWd6/BdDhjAYWBwb5gNhb0HHAS/dMCEupEMwzvHXFpeMoM8W/CHctRn+iC4mVd/S7f+RE2aArOpuu1HJTyZW2ObTMSzzS6fAzbDailZ/PvxHvAj/i/DQAkEP4jMjMUHwX5cV9iLs0RGpwl9vKSzWGj3/xw9PujqV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:00:20 -0400
"Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> Add trace_call__##name() as a companion to trace_##name().  When a
> caller already guards a tracepoint with an explicit enabled check:
> 
>   if (trace_foo_enabled() && cond)
>       trace_foo(args);
> 
> trace_foo() internally repeats the static_branch_unlikely() test, which
> the compiler cannot fold since static branches are patched binary
> instructions.  This results in two static-branch evaluations for every
> guarded call site.
> 
> trace_call__##name() calls __do_trace_##name() directly, skipping the
> redundant static-branch re-check.  This avoids leaking the internal
> __do_trace_##name() symbol into call sites while still eliminating the
> double evaluation:
> 
>   if (trace_foo_enabled() && cond)
>       trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

nit: trace_call_foo() instead of trace_invoke_foo()?

Anyway looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>


> 
> Three locations are updated:
> - __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
>   the LOCKDEP RCU-watching assertion.
> - __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
> - !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
>   when tracepoints are compiled out.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6
> ---
>  include/linux/tracepoint.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 22ca1c8b54f32..ed969705341f1 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_call__##name(proto)			\
> +	{								\
> +		__do_trace_##name(args);				\
>  	}
>  
>  #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
> @@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  			WARN_ONCE(!rcu_is_watching(),			\
>  				  "RCU not watching for tracepoint");	\
>  		}							\
> +	}								\
> +	static inline void trace_call__##name(proto)			\
> +	{								\
> +		might_fault();						\
> +		__do_trace_##name(args);				\
>  	}
>  
>  /*
> @@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
>  	static inline void trace_##name(proto)				\
>  	{ }								\
> +	static inline void trace_call__##name(proto)			\
> +	{ }								\
>  	static inline int						\
>  	register_trace_##name(void (*probe)(data_proto),		\
>  			      void *data)				\
> -- 
> 2.53.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

