Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C983D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE04F6B008C; Fri, 19 Dec 2025 14:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C972A6B0092; Fri, 19 Dec 2025 14:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3D96B0093; Fri, 19 Dec 2025 14:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE98E6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:16:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69FE4C06C6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:16:41 +0000 (UTC)
X-FDA: 84237177402.22.9561BA8
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 85AC2100002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:16:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=xlPNwaOS;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf14.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766171799; a=rsa-sha256;
	cv=none;
	b=s8vqHoiuOsFjt6fhXenAgRcj/qVcIDuGKgRY0Yy7+mu4T+pIxuFIivd3w+uTzD9FP8TkGM
	p9yTr75n2ee7PcgZRKBDE70wIglfYSOohhiEJIVDEyfbx90HiDE9k0M3qez3oreoeH9Vuc
	VrOcXHhL+r5exBH0fObQNBIxJaO0xWs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=xlPNwaOS;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf14.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766171799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d1QBQb0DaVer6VJvBPQjMiptd3tuqlZ2ZCZ+5iT1Wk=;
	b=BxdIwJTDd/s4n6w4KIZ08rL0GhYJyX2D9vGMpK26QNynIXfqYZAs58ePncY//88DjKkea5
	BYHolNbA4KCo4cwkARhrKATV7Wf4/45Ze2cpiSs8J4iC5lxwXF1z/zqGrOD8EQxUeDaInJ
	T/T85Ey0fBO7/tk0eGj+ihYsrHIqRos=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXy2G3SrRzlwmGs;
	Fri, 19 Dec 2025 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766171790; x=1768763791; bh=1d1QBQb0DaVer6VJvBPQjMip
	td3tuqlZ2ZCZ+5iT1Wk=; b=xlPNwaOSqS55oacKDxS5VHJW1eG+zFRK68hAmav2
	HEBWfm14o66rCOyR/8lRaTTTNFWfyer9OfLLqQVI9vQ4uww4GFmxCvKf/jw9MKMt
	cC5R34XygMp1hTaFaA3ZLzX3JbNMZUuLk+2Fn/RvXWr3YHYqV1lVZ+XEKxUsSnIv
	GpVLDlWSvwcTs6ssuRGT/XOxb009+othv9txBuH3W24r/98gFG6ysd8p1YkYWM7F
	WenbZkluwcT5WPWTukR2Hfmr4JLxhVObewGYlTZpnsZApLL1+tHVDpK8l0WIVVW0
	d9jjJOjoDRZeyH/o++wfO7y04X8X9fbXjVpMlTjiGJDSGw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tXR7wglYQRQC; Fri, 19 Dec 2025 19:16:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXy1p2cmLzlvwXP;
	Fri, 19 Dec 2025 19:16:13 +0000 (UTC)
Message-ID: <9d548e47-82c0-4f81-8a53-faee09d22b15@acm.org>
Date: Fri, 19 Dec 2025 11:16:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context
 analysis
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
 <20251219154418.3592607-7-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-7-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85AC2100002
X-Stat-Signature: q5tog6ppney9tojjd8xgsar6wtxojydr
X-HE-Tag: 1766171799-622808
X-HE-Meta: U2FsdGVkX194DPNZOLkOpONUAYjTruaGsLTEI1ImZkL+0OZhMg9qxDFV+3fUGTafBBSTjUsYHiyLWZ6zBdfaZzV6NQUlSnr4GIwtkwcLi4C/BXCVqIry13JjK3tMyMdA/Icw5+F6vULi36sqwcVdZkiCyBnsd6lMAJiX45wf2cpOyvtnxGGY6qQ2+hHh1QiWKT/8Zs5TBMOZWZm3PqsfVa+8SHUlQoXlFXR/7oKcNvTRbT762z09KVkXscmXbXah7kV6g2YvGmzuxr1ixtNZ4CB0tIcJvZArDFPqv4yKCFt5puUrko6KSZgIekEPKFrG/xnAqtC+E2T+xYLKnS1PB/lz35gi+nWRCMo2KxtwMWe6wZiimx++RZTjK3yWsx5uMkYuCoyBnyva+Cn+etUWd1QTq7CzqBzvd84aJVnJjxDAYZWVczx5wYElCU3ZCPp84y/VLMdqJDnK5J9xb/gY97lmFOqBDCi94J35/RczYTeshTzxj5Dips1zvQH39Tiq9fG6qWn7WoEf/pQizEcqbWSXZhqNdyxd8xnXlxqY/UrGYzWGHpdq0AeuVprXBVQ79u2GJqvW5w4nmv6h9clzb8PRV/4D3KNW4XGsMvw61M97r6n0hy3CQ+sFLrrFD6VG8JaBtFS9SOZCd76BpYIe+B0Pc9dwnbm5BerB+vw9lUzR71Fz0n+JSttmeAHvO+co53SzyhRq2iPfmU5bkMvqWTiOsuojErqgUflthL8yHuDIUXONGMLwEAYm5MdDWVdVQtC+TsfgrzuBnDBR09zyicvFgSv8aK6d1YM/eN7Y/XcT8CdCE2vYGgmznj3E2Q/Sfez6YrZeMiiq9j/hl8Ry0HNiUmM76e3vsaD+RrTRiF6uB1wZzZiTzc2QoZaK2sEdatNcyK3fYWPGSEofwB/xyTM4pljxMeCJ2CPp7QUgOBBvZN/XZJQDKJCoXrI+9JWPpK8uLjE8p623X+Ajkm4
 qkRazE+X
 +yvy2pFsaE1M297U4rKdTJq/ISJjQWrgjgQytoNi3/6YoAhwIUBV8386BNJUNnjjp4A1a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:39 AM, Marco Elver wrote:
> +#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
> +static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
> +static __always_inline void __class_##_name##_cleanup_ctx(class_##_name##_t **_T) \
> +	__no_context_analysis _unlock { }
Elsewhere in the cleanup.h header arguments with the names "_lock" and
"_unlock" hold executable code that perform "lock" and "unlock"
operations respectively, e.g. mutex_lock() and mutex_unlock(). The
DECLARE_LOCK_GUARD_1_ATTRS() "_lock" and "_unlock" arguments however are
function annotations. Please prevent confusion and use other names for
the _lock and _unlock arguments, e.g. _acquire_attr and _release_attr.

Thanks,

Bart.

