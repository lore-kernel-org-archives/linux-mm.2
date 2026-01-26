Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E44CD1950D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED306B0005; Mon, 26 Jan 2026 12:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5736B0089; Mon, 26 Jan 2026 12:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBFE6B008C; Mon, 26 Jan 2026 12:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 707D16B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:31:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F6EE1A0853
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:31:35 +0000 (UTC)
X-FDA: 84374806950.07.5EEF642
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id F29AD18000C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:31:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=Jfjqa2A5;
	spf=pass (imf24.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769448693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqyCB6D2UZUFPhod4jHX3yXa2CT5+Aq6RptHuHLLwP4=;
	b=ZoXQNFF6BfBqgpLizSos5bl6JVcP/6NUSv1Q8AkQv4abvj8Ao9XW5jC6YMw3CTfrGK5gdt
	aH6iVHrqcX6xq0mBuXeUNZpp2NSZbA922BGxvUwhal1Z0KSrXo+FKApGqwNBQkiQ77GpSr
	fNO7nHm6lH8jJFsvK4FpJntmle556+w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=Jfjqa2A5;
	spf=pass (imf24.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769448693; a=rsa-sha256;
	cv=none;
	b=h4UG9xH6a923z1dWzer/dHyNL2UmZmsTnatFPEs1/9jAvt5zKa7FgK0SkpoAhlPfKKXNfb
	4rWAell5dstkDBff9jlNEeNpZQGAZIqU+LrbvgQv3ni6CJdyAwwcq2ilN7qtelY4ScwScK
	IRQCt2cBWMpFsyw2irPRAWMpXvYzT/4=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f0FvS0HvMz1XM5kt;
	Mon, 26 Jan 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769448682; x=1772040683; bh=cqyCB6D2UZUFPhod4jHX3yXa
	2CT5+Aq6RptHuHLLwP4=; b=Jfjqa2A5xcoH8vxqxrPT6Fc3T+WNWvUSPtyI3dfc
	K+K74UqCtqhORUbqAIJ2PabUFFnbxrVNvd96sUMMU/MEnaVjk9rgNQ8t5/0nRw19
	sH24JJ46JZl/8BikOO9Kx+mt4Ur/Rh8Yzl6nngAhCrvlw0oYG3zzrCOIJGm0wInA
	YwG5Fyd74wCsCC2gIdMl3vVF8TZuM0JPKyJCc8OrmAE33h8ZSEoKEb2DqwDLr2sf
	hlPf/0+ka1e80z6j8NCnVVqxTk2wxfTwIisYs3BeL1zHtJcgzeItDapUP68dFmWE
	DNXn0jJrQCoweUxibEiMVlGVbmaZJxeooqs7mbStQv3LCg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XReqotH7_hjc; Mon, 26 Jan 2026 17:31:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f0Fv22xNsz1XLyhK;
	Mon, 26 Jan 2026 17:31:10 +0000 (UTC)
Message-ID: <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org>
Date: Mon, 26 Jan 2026 09:31:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/36] srcu: Support Clang's context analysis
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
 <20251219154418.3592607-16-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-16-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ourixnsotmyf1w37j53pq3u4edg1uo5s
X-Rspamd-Queue-Id: F29AD18000C
X-Rspam-User: 
X-HE-Tag: 1769448692-782461
X-HE-Meta: U2FsdGVkX196m1qSxQtFmv1kNCI9j0Tgte/1dV5D5JLNrxOwF16aH/422MGjg7Ye38kYZX1W2ke+QVRHVUkGWX7efMGMiypeJUvo2jTsxOdN/o732X0ssxnRRybhHpwhK8+JEsg5oBMzj0iJpBVxkg9r8+r489GJm9HQCwA0W9v18EpFavEnUNlnR15aHIvY3b22iwp3jz2+eBn2gHCqIyYzZcQCsdLG7rpUrVBj7VpycHSHzftC3LUYOQ0bCQp4AJECL4gki1QCUzLIkvA9zMXFEaIgCWWHZTs7GVnyUmc4UPPyZt3uC+9KxxvcVWv76sgjBczsYpw7OpPPb1hDCqbyloZidzAmDYsSDErgM9233Jl3IIAayveaaoha1zC0fU9vqZmUZSH8REQAQe4lrPrxpsbcWO0kavfXvu6uZKbiBexMge7eukS3VHY0fKsM/TA+TKifOxrzk6x7IpId8cfmDCp8K6+mc1O6zhPtCXSCyisanFuTaEXIkfLwU8XI6yMjWdLMvcf7NvJjclS5zeK5+oPdh92xjAcmp63d7fJA41VS4sCI/xGosfvZHKPwComjeH8wII7IibAFZGWbHOTjZDgeIbpgT2HX42JzF/lKP5zEG9QN7VmziSKBLlzAhIm5IhjJ6jtOWhr4KDzOd8LxeBE+GWMuffPQaib8w75lxR9E+riL5jLfAT4nvKAXySJbNOKLl7lmWveIbPsVdYZlI09+CPPlbbHJviIetnwOnaiXh1HN4rceG0yf+wdvlhl6B1GhMxVwfpnGUswvXxQb3RmclH624eLOKArxiBteu+lBeGA4nk1TfeRLszFc6rPSBjnZBx5lbVPRhDxwiZIDJG+2fMgecLSj4GL0DuGtENrAzTApsPwYqh11qnAzclfd7O2UwIt8FQispabf8wF3t9AkqhuP5e8qJ/SLC1V2pKvmni0mo5tNMEkUHR28UWLXh3zPWRKGirl+VMg
 hQFu5Oad
 zGK0/MtHrVX2BkGtAgOCm7gvDQYLx+d7wURGKOqteHzTbonisaPNugYK9SReM4kfsdja66o7Xa4KYZ648AaXyig86BlNmJtjtW+iuwN78s62E3lYn9V0LV1btxRC3RnxVdh+bhZC6L+VDDRkQwwNV51dZ1cTx28sAg2s3wsALsFs2rnNiDeeyqJMS7P2Gv+4l4r9dRcBJZXf/DYlGIFOOjD0P2kNJKigf82Eaez74qtiBdTC6QBQQxrpY9YJTPyW7rkgG+IDHINrfsM9rNBVNdY5GtkA35WO3c0lffkpFIeo7GfKVU5rg8lQyor4EAS7u1PZLcNb05QfE08Eu69w/7ybqLcuBFGp8wzEJVgkVgd0aTgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> +/*
> + * No-op helper to denote that ssp must be held. Because SRCU-protected pointers
> + * should still be marked with __rcu_guarded, and we do not want to mark them
> + * with __guarded_by(ssp) as it would complicate annotations for writers, we
> + * choose the following strategy: srcu_dereference_check() calls this helper
> + * that checks that the passed ssp is held, and then fake-acquires 'RCU'.
> + */
> +static inline void __srcu_read_lock_must_hold(const struct srcu_struct *ssp) __must_hold_shared(ssp) { }
>   
>   /**
>    * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
> @@ -223,9 +233,15 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
>    * to 1.  The @c argument will normally be a logical expression containing
>    * lockdep_is_held() calls.
>    */
> -#define srcu_dereference_check(p, ssp, c) \
> -	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
> -				(c) || srcu_read_lock_held(ssp), __rcu)
> +#define srcu_dereference_check(p, ssp, c)					\
> +({										\
> +	__srcu_read_lock_must_hold(ssp);					\
> +	__acquire_shared_ctx_lock(RCU);					\
> +	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
> +				(c) || srcu_read_lock_held(ssp), __rcu);	\
> +	__release_shared_ctx_lock(RCU);					\
> +	__v;									\
> +})

Hi Marco,

The above change is something I'm not happy about. The original
implementation of the srcu_dereference_check() macro shows that it is
sufficient to either hold an SRCU reader lock or the updater lock ('c').
The addition of "__srcu_read_lock_must_hold()" will cause compilation to
fail if the caller doesn't hold an SRCU reader lock. I'm concerned that
this will either lead to adding __no_context_analysis to SRCU updater
code that uses srcu_dereference_check() or to adding misleading
__assume_ctx_lock(ssp) annotations in SRCU updater code.

Thanks,

Bart.

