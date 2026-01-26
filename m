Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F649D19523
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 23:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552DB6B0088; Mon, 26 Jan 2026 18:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513946B0089; Mon, 26 Jan 2026 18:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F656B008A; Mon, 26 Jan 2026 18:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFDA6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:47:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF63113BE0A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:47:28 +0000 (UTC)
X-FDA: 84375754176.09.65169B7
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4046C0004
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:47:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=23sbsjIP;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769471246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X34tjfxPPMupW8WHmEJAIsWdH0Oem6uch60iKqedEdc=;
	b=bg05XztRPApXAlT+FWU4vk5zBvIyQJabaMNvYq+OW4iklS+B6/i8H+mZwzmDL6e78AvczN
	dBOv9mm+1vALGm9ao58dNU8Y7jz1g6BIRA2a9VzC+A8QXqzLLr4xCWVE3EQbz0FyQiaBuG
	kBCVtp1G7W87RhfG/PCK14loaPjzSI4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=23sbsjIP;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769471246; a=rsa-sha256;
	cv=pass;
	b=GiMVe6+MWBE0U3ZIhqSaN0pktttiKn3Ux0hByE+yACDr+x5gEuAwaZBBiJSw3oxYR13Z2A
	VaV0msKJpuPOn8a8UIKu58l7+SDXGWUZuv1u3WX4Kl0Nzn38cBhBC4opTLc0o9gWjQs3ln
	Wclq4LNJ50gRATpiYFS9rXcA57rpK7w=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1249b9f5703so1040968c88.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:47:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769471245; cv=none;
        d=google.com; s=arc-20240605;
        b=eihUJBvwEN2wOfg+fTN8rpAyKKS33XFCQdZp0zQHl9EmW53eArSnKH6yjp99bc3iKW
         1EnUFPnWhEu5TQMmQEsCE66WHHPGt0KrVHAqUAHcgF/zKVuZ5EsY77qG/fvv1pMiyDVU
         xG68OvucQL++A4c8OJBhBqBnnT7aeApD6uUSdixYg0g1Zt1DXnG0oecNbcNlYjd2LM6M
         e6fS/7a582eNqwl0O7JiY7HbTG0adgptDak/M5J9DijcNRYD7tUUWqCTcfjUoq9aJsgr
         XOMlJIkNmng8opXbWzhiZwCDqgo2QvVIOrL4v+q/u5jrDjs1AkSXMnprIUXar6CVskbV
         gR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X34tjfxPPMupW8WHmEJAIsWdH0Oem6uch60iKqedEdc=;
        fh=tUMiR/44plqaTAB8uB8/B4lSjfg15mxY2UhBj3p1+BE=;
        b=IuuWyhQ7XRNKA4Wum9AUbYgKbrX3/NdWmmFWCidPBi8uQTb4q/IL/qmrYkcs604PxL
         aB9ZElCbLA9Vd8YaGrHKqQsyYoOozl2GJUIworxagBRHkY0SjoFjqj+hz2lGmflRBS5a
         LE0Eu/q56MC31DXmEpm3G3UQxYdDxCSxOtZGEa6X+jx7e1vERnoQR6IoJX5lMOnq1JA+
         OITYjDURFgPjDaYhOEK5nxPzRwyE2jJWk7gXg3HX3hVtpRjD6EPItpe2JV4SrxyxCDch
         nPyt+up23fWDzkDuTB8IoqgTxcZpG+K1gCEufVBRFdvbsEyB2RcWhLdPq2x/qMV/W25w
         1quA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769471245; x=1770076045; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X34tjfxPPMupW8WHmEJAIsWdH0Oem6uch60iKqedEdc=;
        b=23sbsjIPNRRmtHDrMQf90KineomsjQi93J27oQs6BXvfqV9C2JZcAhw5jIDfMbdphC
         8pNBVbHGL3vhNTKQ5YXsJmUteZ2Bf6aakVurS4+EabSvqm1e4xBroKgM+onOgMdyTRXh
         RbTLo5scrG5yKs8sMNAfxCCrzLARlhORZ69PZj8TD9slcWoykafpC7SCXSIhwpn4QohV
         iuOaEHAHdmVVGs43PLV3pQQ+xEm+OGM5OH6eAsI0d5L7mL48xP0itAwClJm1Ym/6bkvS
         7lI9hwIqX/JJGDM/C9V16vGJmzrGXv+hosbrWOMMBzXBvu+WN0xh9v4OkXDSL+t9rhv6
         Mjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769471245; x=1770076045;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X34tjfxPPMupW8WHmEJAIsWdH0Oem6uch60iKqedEdc=;
        b=CQbDN8RPoldO0NFrgDcACz4rgw7GA5IERerp/GQP5zPJBsCa8IWzKk4Uce1yy8ZxOc
         CPeulud/yLNFt8QDEeqFkoVmoTNh7n7DBl64eHE5b5xi1/EUwWCNFE9ixi6jTPWwlupy
         4n70aYipEOY8wSIno8CvsSArtard3etgoQR8zZO1OZPYU0yNx+Fzx2PEoh6gTLijCZGG
         xv2uKb71FwB5PrQH9UvZ44PW8RCw1PU3x+7lMOWOwrDV3zGtySiLE6MeVobplgKcpbFv
         zD6hnkIDSTR/nh8Gpi26XDdVV46GM7Ew9fd5erNFwzhMCu6x3+6Vg72pyQPPmouBxxyx
         1pPw==
X-Forwarded-Encrypted: i=1; AJvYcCWlDToOthLBjb55P0xQQn49xDYrzju7M1I9PvR2snXQWK2CzAZIbPjJU5MvM6qu+/7kz91FLwWVPw==@kvack.org
X-Gm-Message-State: AOJu0Yw5zshtxYgOxQ5YxbCzYPmIMrmSERcqVrxW3dlt2N366q73NFs8
	icugKN/zVP20JI25X+E6bJjswpvspl5puSm9TRj8ILa2eOa470IHpvDUSelwKPX3i+esznDBwsx
	2ip3by82pxEYFGpAMXYufAO5Qyr7pV6oLOOZqJpzP
X-Gm-Gg: AZuq6aJFI754C+avC58uGuVTxhuXs2ofX8yqd/xwAJweuFgOZy2wqdA7Q7hP9ONPYjx
	x5C6T7fmBVXEe8rVGiIs985mXvcZ5B71/9nItxdCIeavdQ5aRYT/X1DJWZ0WYRH0+jOZOL7V8l/
	wLM0DW+hsiYjIBV9eD2+XXUnUDjbXCubFkcGoHIL7yJbYpA32n4iqVYEneErIW8hqmnYmlvwqbV
	/Y5F0GsrGtx96410PeuEu6N08806G+o34Y/iTdVstzCwlvyT1S2vlLBrCINaLt+w2OhJFVpUWuh
	Q1Jhz5utgZK1iU0fAUfCbzJ40n8vJAigOHb+Vw==
X-Received: by 2002:a05:7022:eb46:20b0:124:9e46:82fb with SMTP id
 a92af1059eb24-1249e468815mr157327c88.38.1769471245289; Mon, 26 Jan 2026
 15:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-16-elver@google.com>
 <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org> <aXez9fSxdfu5-Boo@elver.google.com>
 <8c1bbab4-4615-4518-b773-a006d1402b8b@acm.org> <20260126213556.GQ171111@noisy.programming.kicks-ass.net>
In-Reply-To: <20260126213556.GQ171111@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Tue, 27 Jan 2026 00:46:49 +0100
X-Gm-Features: AZwV_QgcknJe0PlLV-z7bksgFQT7uSnaZ1B5QvyI9tPRocr5FzcCAIEUg9yCt-Y
Message-ID: <CANpmjNPs9CtY1w1-MqL1-CnHVFLxXoA2rbd6d2w4wfxT8AP0ew@mail.gmail.com>
Subject: Re: [PATCH v5 15/36] srcu: Support Clang's context analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Boqun Feng <boqun.feng@gmail.com>, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: D4046C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: cruftbag8ru3yjezqd8dwaberwmam8o9
X-HE-Tag: 1769471246-602739
X-HE-Meta: U2FsdGVkX1/jam5pWZ8MyF5Ypwm1Bcz4VWMtWPtUflLsGkONuNQCJyWpohTAP4hF1+1q9Ru0FDGDRTK+8suph627Aao17F95qifqxPpxtgQPxCLVNIQIsKZAk9De3Z9JVG3jPeXjNnkJEvdY3VZMazrNsK7jSO9ZxB6hv3lTtbpXPOVN58raFSkrCyA/plFYnoWNQMvap7e2uwsoIPzqvFzg9ZzxpWnUPAVKZSGtLD3Ssi0jdtqTLIAdvOrTtQy9WlhGp4Vt1twbEninCOjICbAWqupbMnRw/aTU+1/qYsKXpaqAacbmG1L/R2zXGGr8wlmH35LeqYfSdcFTu19Efx1gWoSsjL/7q/jJRPM1yddruFs2X7WIYDzz8QC+bItor6FOZr8UzkAMSpA5ffWGTx9754q30NjVFwd0xcbdF8XOyzf0wCdJsUMoZcl4mVuKXTP28FOxxtrO7V99U9EQoIBHB0mUfIOwvaPJd1grzeelhMr87CftOWcD8k3zsqIzSWofkojQPz/0cKo1UhZr3VnXkwoWwPbS7pFkHk+MxqP+fuFhRomumdoYLzhlbSxy1IahPtfdrhczYDRhl4UvYW0RaMmqbizZzf6A/JpkCUL4btMFlHPwqhVPBpRAeuO0cEZPcwtnlGt698/c/4AGWImNPimxoP0nzXuBSXV3dsJhMY9kjTuxCpTIvQRP9lc0w6UTuMSl/b/MAdlWCFbg6OABIfAyc6v0zKx15RutSgXg3vKT7PQaCeJiDGPSpsgbaKnhg0tEhymTrQg4jr40cVz0GLYCXddxUkALTP1uSu2mqCEgHNDLXw0SGqDn/OYZZwsiZ2rH/Lv4vX9uE5wGVo5H9V7/2LrS5Cdw/anKO0iehuSl9rQZbQgZo8ANLcNpTUMcl0tF3CEpUSpVy//Kqb7OtqdDde8viMPOWYhV4m8+EyyzRaV4QgiCCHI5NfxBhnd2MBsG3jKA5teZpca
 Q0WFM669
 hSEnA+IfVrpbCNQZYJuD3DukxB5MdSsuIXa+XoD/Gjf3qb4Vannf0h7R436YoKEmwOY88vBGKTEFiukczUlt/qZKHQwCDW642xUAJQVUjpH2sD8E1cqHJUitFFkyfUzwROk4ELjVTo/8vOZj7NJTCRdxLDGVjP1bao+ERtGOki+/u+/rD57lefCTqrfn8CF3VEbVPPjPUAekoLcSSJkQKpTM+2T3MERITW4i5n23B2/LZ5MOVB1IWXwbzlqCS5ChZfOUlriLK9a/Ndv1L6QQpEfK1x2ThK8VKnfPxdeU9scAhtEzfbQu+BUMhcWLCQXHwT3j7WVujw2R47PtKmOn5oNkgfwzhYZYBHCb+k4kiAG7xHfC7WbV6z7BE+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 at 22:36, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jan 26, 2026 at 10:54:56AM -0800, Bart Van Assche wrote:
>
> > Has it ever been considered to add support in the clang compiler for a
> > variant of __must_hold() that expresses that one of two capabilities
> > must be held by the caller? I think that would remove the need to
> > annotate SRCU update-side code with __acquire_shared(ssp) and
> > __release_shared(ssp).
>
> Right, I think I've asked for logical operators like that. Although I
> think it was in the __guarded_by() clause rather than the __must_hold().
> Both || and && would be nice to have ;-)

Some attributes take multiple arguments (__must_hold does), though
__guarded_by doesn't. Yet, && can still be had with adding it multiple
times e.g. '__guarded_by(pi_lock) __guarded_by(rq->__lock)'.

Only thing that doesn't exist is ||. I think the syntax you ask for
won't fly, but I can add it to the backlog to investigate an _any
variant of these attributes. Don't hold your breath though, given the
time it takes to land all that in a released Clang version.

> Specifically, I think I asked for something like:
>
>         cpumask_t       cpus_allowed __guarded_by(pi_lock && rq->__lock)
>                                      __guarded_shared_by(pi_lock || rq->__lock);
>
>
> I think Marco's suggestion was to use 'fake' locks to mimic those
> semantics.

