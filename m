Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6801B606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=ayzstiGI;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=0k+cdqhk
Received: by kanga.kvack.org (Postfix)
	id 39E426B05B6; Wed,  4 Nov 2026 03:21:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347C76B05B8; Wed,  4 Nov 2026 03:21:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216BA6B05B6; Wed,  4 Nov 2026 03:21:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE0976B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:21:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ECE5140637
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:21:00 +0000 (UTC)
X-FDA: 85396741080.09.68B6737
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE7C440005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:20:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ayzstiGI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0k+cdqhk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkIJPTF+rng+xUHUM1yRH1n6HfCu3188jQjR6cCCrnk=;
	b=lC+0QXYtAuSCb6AuBCBfklpZgiDdtDyjWk7gMn1hkI/Igt+L4ThTqgig0YJBL2+UnaoZaV
	ovx5aVzL6U8h9UEaxEWr3VI7CthmUhLwLy9Y3I/sVgZLQkikE3Z7Rxmlc7Htu0c6qwJ6Uy
	nxo5iPX2IQfhIzn4sC3nQcmLmBvyOcI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ayzstiGI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0k+cdqhk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793780459;
	b=5oSVHicm+uI2IkNxdAVVBnjXa4TWBbEDRhzvrbJTLorR05P1RT+4pKWOarlqE5fTkKWJo6
	YSYE4kDGrxNB2ogJn0jgyyFIf8NR52mwu+b5m5eJctT4s2sqn+LgfIVW/1r8Fg6gvw6vUc
	qMzVAN/pdJFpjwbjna4u6n2zUE7rw+A=
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793780456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkIJPTF+rng+xUHUM1yRH1n6HfCu3188jQjR6cCCrnk=;
	b=ayzstiGIpHElycU48fFZd4+l/X9fW2BRInWe3HqQDotl7y2lM36wDVG8eo9kMeRbdssafZ
	eNzOjeLjses+Uot5rMmMHny4PMuIkXPNKs9rv7Mc10wUW8S/cEL5NNgtWlWxeK1ghdJXUe
	7PsSQbIWPwNxcfQYqrT205ik4eYpa5kukFVOot82And9zEb0ERimCbyYSumRvMAla4B8RH
	3FXAoVaDcUEIsZD+gNz3J7XNKa/opEJyHE6t128QHpX1+aNjlvbUm9NoPv3aTc9F66Pacq
	ekxfUL/RbDq5plGQ5da7/sS6Z52rAFCQ9rxn4GEO0HNZyDmUaSrl5Onv9t+Hgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793780456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkIJPTF+rng+xUHUM1yRH1n6HfCu3188jQjR6cCCrnk=;
	b=0k+cdqhkA+nUcKXRkIDB51+uCSF1htbzJYUalY6So/iOiac6eulsW4ceyBDXDbG8jiF0SP
	3KGlL8JUMAW/y9BQ==
To: Breno Leitao <leitao@debian.org>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Petr Mladek <pmladek@suse.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Breno Leitao <leitao@debian.org>, Toshiyuki Sato
 <fj6611ie@aa.jp.fujitsu.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] stackdepot: don't WARN when the depot runs out of pools
In-Reply-To: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
References: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
Date: Wed, 04 Nov 2026 09:26:55 +0106
Message-ID: <87wlqtxb14.fsf@jogness.linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE7C440005
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INVALID_DATE_TZ_ABSURD,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qi5xsshstruk1i1rgqfnueg4gx3tskkf
X-HE-Tag: 1793780458-913137
X-HE-Meta: U2FsdGVkX1/E9RK39JrxyhaDLly0SsPKerKn+WpigCmOo6GxJ+WG2Q5qxTuoA3h7aZwZGmndCDtFV13tztRwfRyx6TU+VFNc5zSel4ncW0q91tqFljtP6GUUMAopHEP1nrX1Ar9+1rNGNcs6dipyDOHwthn6K5L6hGa8ZZRQe/Qz/gdJHeU4XgSJ2A92uvvAYSmeRk+W5Re8Y9orcUoKw1uxOli4kdMu9tG3E/gJCq44PIgqm9nU/ui3TJis+q918mV5Bz3sL1xi5ozioWhYpnk0vgvmX8SQXZ4pzftrDOenrLQuqg6+fXfxuSZftL5joR3F4Rtu3ybODg8NsNeY/Hxbr8+jfbw3wEPc2a2PVkevdoxbDNegELPUgkrJ7Ox2Uqtm28kqSeui4cX5gJ7xOQBlTJ5ESI/7A2yyAYiinZsMC1htjUJCJ6X/x0NG3BBQyzd95n9JXZNOCHv7b5E9A/q49VftepXGaphqrbPg5qg1TK+DGFdEzEGIPJIVpDXUIAbxhxBEKaZcPb8LA4XudwOSrA5foMtV/Yin9gFNkMbeDgDG6duiWXCFIOi0muZUVBb4L69zjgrGCE9YxR0dyTzBOLiUzP/MAdBcsjFvbCc2Wi1F8fb3prhMTPoGGkccIKJEUEmr/hxSxsfbLigrTZMrI/EyXGkG02MbShZHLUqW7Hhm/+YAF0dOCtPYFHk8SAl8a+QuevifkynyxijwSzdWThw04XPMpkTkieBGUTgpwvlfPQeL24nED/pi0K1mviwaM7aKieD1UFLZkAWs/F0AHvRlpI+gQDq/ITJIRbl2GkORMI5SMoR8oe8bRMb7tQECxcaogQtlm2PtOla4wAZHvp3+raVP/4Q9U5rNXurpqPcqxzCcNpzL8VV6XZyrGva7lBCA8NLG9pgpZYVh6UCOsfzI6dDbWUuh4j6W3/f20YHWC9IuCiAtSgIbTKXhBZi0VXb9EHv2n4s61rY
 agMM7qQ4
 Bpfq6ZLaR78R5wgmJv8i8YIUeCtJejhFVfS2FDNgG+TJW594ywBHNZH8deCFGAXNIxleZPwAeRJ5i/AcMQCRv+PHzBO1ucTJZX9Y8+vR0CyHR0R1dMpZMa/X67fLoOff5F4zNgrUyMR5J7egWugbyeszLdHw/yTqiqjAoWuvfeKigClVwZLylX+4QY9GO8MyReDPy7eCf8mwdyxciPq30Ezf7Tdf2I6R1+nBZsI0tex9EZxTV9HqHMY/wwUgohmxTo4wrQyk4s5ZD7IXg3VKqXxyoiUHb6DcLISuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-03, Breno Leitao <leitao@debian.org> wrote:
> That deferral only applies to legacy consoles. ON nbcon WARN() puts the
> CPU in emergency mode, and in emergency mode printk() flushes all
> pending records to the nbcon consoles from the calling context.

Yes. WARN() is supposed to be for critical issues.

> With
> a slow serial console (pl011 is an nbcon console) and a backlog of
> messages, that flush can outlast the hard lockup threshold, all of it
> with pool_lock held and IRQs disabled, while every other CPU that needs
> to save a new stack trace spins on pool_lock.

Several serial drivers call touch_nmi_watchdog() (such as 8250) to avoid
this issue. Perhaps the pl011 should be doing this as well (at least for
the write_atomic() path)?

> Running out of depot space is an expected condition under heavy debug
> load, not a kernel bug, so report it with pr_warn_once() instead.

This is the key takeaway. WARN() is not appropriate here.

Reviewed-by: John Ogness <john.ogness@linutronix.de>

