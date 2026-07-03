Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8014AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C84D6B00B4; Fri,  3 Jul 2026 05:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F846B00B5; Fri,  3 Jul 2026 05:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF556B00B6; Fri,  3 Jul 2026 05:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304806B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:44:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A27D214046A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:44:23 +0000 (UTC)
X-FDA: 84946980006.03.EA2FC56
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB592180002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:44:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3wx+GZN3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="whrD/Ixm";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071862;
	b=fYGmkMJ2nfShnYrss8CsIo+2aLUsR9DQ6UgViszDLKPGyOLSecmZEhfN9ZnP1e6yOY6val
	YczWo76nTMSr3bwt2pfJ3I9E5s+nRi8TUPEFtNNksM/3BSUkaJJ7XCMv9slglW2X7+dJpM
	+MwAikRxOz/4cuV+1sTReBrImSCKPh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vbkc8C6vPfuFCPiBlHwfq26ZgkZnTR7YZfJ6x+U6dgw=;
	b=QiA0TbXQXkyFrNGnDWcFhe0DB3Ip9IFW9vNtSo/dMwcCHJ1VvkipSHwQvmFHcNEgxakQgB
	bOhVVDeOKlwTeLgtJ/OUBx8KVW6ovbMwbnK2Xir6+5jxVJKigIYtQFvRt3Js+wLrW584uk
	7nPV/lRT1XpaPk1ZSQniqXN0GoZ5UBc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3wx+GZN3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="whrD/Ixm";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Fri, 3 Jul 2026 11:44:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783071859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vbkc8C6vPfuFCPiBlHwfq26ZgkZnTR7YZfJ6x+U6dgw=;
	b=3wx+GZN3lUFtMi+zC9r4PUHex2Hrj5bj/px96NRFCJxYeFrkRhdZG9a3JlWoIIwuWfBB83
	NpUbJBYKtbr4ddLbrNs4614/5mxWlN05qbtSQd6qkg4lSMTrgqGvwZmIHZsaP1toX3NAek
	3QTdMQwVqxC5axCIplVnugf8z8LiXafTIE4g36P2y7qPSIWuErov/HgzcSaUrr72jtDC7s
	fxKwEfoe0OmdhQWbw6qxKWo1xYy6m6CfkjRgZTFRW0/ka6CXtzjYQb58xn2gTZ4k844eGN
	vOYXyPHHNEgyt1STYuuxIFlmwOVqk9dndhYl0jB/QpI5kA1XMlU5IAlDsqPTAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783071859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vbkc8C6vPfuFCPiBlHwfq26ZgkZnTR7YZfJ6x+U6dgw=;
	b=whrD/IxmYah58ALJenVjpQsAGHKeODZYizVPDeOc6rM12TMi1TbQNAexWnah0bkE32iMFF
	08t3rz9pX05lChAw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Douglas Anderson <dianders@chromium.org>, Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Message-ID: <20260703114128-2a7a4723-0060-436b-99d9-7499bd90fa82@linutronix.de>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703022507.187457-1-leon.hwang@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB592180002
X-Stat-Signature: pg9hwdw1u6bn6nj8ufn5t4rekeis3r3i
X-Rspam-User: 
X-HE-Tag: 1783071861-884425
X-HE-Meta: U2FsdGVkX1/2U7QAJdmOh555JWpGeR+cSHaQAV+2I/ukm885dxP4ZROaFpwSYZxzFhvhG1CeAAkKvYf8dktrZ29hA739rTP0uJKutyhbX699Oa0zad941RQK4zniVlw5uJ3K7rqq68D1lLmZmEFiD74AMHoUJO1SI8BzaqmKzk3NUlxHaHy3ldVRxqCjCRmXhAU5OzbXc+a32BKFv0eMAWSN0f2l3pYnJYHv3VGbUWlOT2VNwijuE/TIziNJ9qLEAlsMEDuKo89A+k1LcMs4Zk69Id+7QjAQ0nOaQ79HeVgXxiwGqSxJJ5Wl9ijXF1OK8tIcmzRckLvdcJ7ARYEsf1v20aOGNylaX9CBRLIevj899hbxeIyL7P5rEjMV+JRHydXljgvnGLcWvd6xN5h3AkWQM4Z1Gs7TzA1Z+CuZKqQUxzi6+1b0RQJ6raJSV20dE9BNp2OjVneMpHOMN8k99Nr3UTFG7ETlSFOQYe31UXGeeEq2G58n99vDQkpuClsduaA98ZNezF7p38YpIRBbYtvNJzGyBJyU6mnl5SHFTDLMWS2B4M4Y2ZGA+89alcMU9oAA7RzlJ+9Y/P68i4MREpPuEDT/R9SyHa0TUg9d3ovDZwBaSTTPlkRzi7LmBhmgfxvL3dEipzi6QpakueMpOLOfcixjbP7lRPZsGjGFT+5TjbtgpiKI01KQv4TfuONLelRoGqofoc/BlDYaYCz65w1gpbcqpuTLG7OTaaXMLtziRWWwml9dzNj+bFHPO0LMgMvaNzAH8q/lw+dEBA1GN340ZzLJIq5k2lirTVp6tHzOOw3L7JfzlJNeQ9wTK8cMMAvtjkRrvHzDD4ZJAXWn8LG7xxlQdxXmOCzXpvPweaU3pX8sbC+x6CHJD+JxtPg3qs9qYzCeyDdCDkx7jhvUArv0bRiN66+Fk9fuAZjjqpkOSwdxFj+W8ZtBnIrcsLRQ0nv8kAWitAjZWkC9Nk6
 8HtMsd74
 Zo9BPd1n3qAUne+xKZnr2+hsqlN15zh35teoxhH3IfqrLCoYFxriQwBjQKmrbiTn7bXuvBHyUdK0rFmqwkHznfE+Z6fvgRWZH319ELqBRRi5shS996FZaKm7mI4J0lImp2lrwCCzw+9sRUqCgnxES3Okqg6rcX517+VSexczqq3DguKpnxGdAV78cMbvfKRfU3e224z25Q1OcmjiOU4TNig5SVTZG75q8u2cp7T1pPsaSzarqSv65CxCAIcJ6EZPCrdD6V99sI4x5rMA4JYzOEdb6DjfECUe5u1LSO8vSOhw+0trhlQ/COdwl6S8n7igOuZMttA+oJLgON0lPeVbOs25qWicf4Rrui+DMj1HMDE2Wvw3KUguV6tV64RNnSALYPe3rPMJZOukSW+Tm0nB+e5wsYV3yMddzymnqP9yZFip+yXFcWI3KxwtcjEQ/8wt81fa+XAQfpue3QW3vjE/5lSBsfIJ7rJ0LEHTVNuhhAUPFCuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
(...)

>    The following architectures currently support this feature: x86-64, arm64,
> -  loongarch and s390.
> +  loongarch, riscv, and s390.

For per-architecture feature documentation we also have
Documentation/features/. Maybe move it there.

>  
>    WARNING: This feature breaks programs which rely on relocating
>    or unmapping system mappings. Known broken software at the time

(...)

