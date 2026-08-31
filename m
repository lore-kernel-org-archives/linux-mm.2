Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D916C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114496B0099; Mon, 31 Aug 2026 06:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5066B009B; Mon, 31 Aug 2026 06:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001926B009D; Mon, 31 Aug 2026 06:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFCF86B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:04:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D634B80436
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:04:19 +0000 (UTC)
X-FDA: 85161129438.12.5C98469
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27BD140002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:04:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vcWR19Vc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="ZdYB0sm/";
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170658;
	b=0okeGC2oFFpi5BIsD/Rj32OAB15ogILcRofWzxzgfU0IN6UB9G7X839/NPoHCsUrRcbbVB
	26uEx0x2rGDwdNFwXd5eYHZge99HdvyuId72bS/cglzSP0mmSzAn9nzlP927Dw2G2/ZP2W
	Nur1ee6VhtHJnR6UtG3BhDPhgfV5XXM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vcWR19Vc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="ZdYB0sm/";
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCQ0uyM4692RoIkTWKrkGu+rliBBROpUs8fWhmht4h8=;
	b=DUE0X7rZ1J2qRQshDXv6CP7iUdIOsSoBUYP74wE0vWhbSYoEeBm5Timv0MvKHRSI8ymZEL
	TyeNtNTg+eNvqdl589yEzN3KdKxAxT7BpIe9Qr4/3RpX+F2VyGsWjlnbhMvE09YFNOO2lp
	EmTGbkCdXk/2eZVHFQcJK13rBB0CslE=
Date: Mon, 31 Aug 2026 12:04:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788170656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uCQ0uyM4692RoIkTWKrkGu+rliBBROpUs8fWhmht4h8=;
	b=vcWR19VcrvMLVUa/4K8K3SOnyMwCg1ghhwEs0ehCHq9u1rYo6KytDe6agVmijeuCGNEhjD
	UW7enWy7B0sl2zS4ho0V8cmhZfJvGQD3jPiQ4Uj6yOqW49PSPx7wsBZarsQql2Ap75Vcjo
	lzmeRlQiAgV/A5RXzfOF4n/MweY7DdYTZofKPtcZsk3DxYinI+X38n/c4IF4EOY5J9u7DM
	W4Pcj+iSfXkvCDCYvgFgd+SKs0OifuhHZH0QXJXNW7TtLTRFfgruSZ3lNSClkAbYdo1lm4
	PeSf/zg4IjxGXF1KzwovQBIH2wHofs8MDz8DVsf4RHEOhoDohazB13yaC72V/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788170656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uCQ0uyM4692RoIkTWKrkGu+rliBBROpUs8fWhmht4h8=;
	b=ZdYB0sm//eKlIf0ySbEEjnBQEcqTseALllEudAJfgw+DWF8nit5vZyQ7ZUb3Tagf72UJr7
	+I2ZZk40qRYznTBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <20260831100414.Yx-lNATi@linutronix.de>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
 <apNjw0HRyr1Oj7q4@linux.dev>
 <apOAF5CPFWUUH9du@linux.dev>
 <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27BD140002
X-Stat-Signature: st8fimiktsyw5rzwi5xbzjobhwhqgern
X-HE-Tag: 1788170658-70898
X-HE-Meta: U2FsdGVkX198bLjfIe358rU20BTOFKqI/5I6VHISCg6/bfClv2uygoBiCmFB/PYcl11TFf5RullIkOyypbUDXvEg/N0cPqvGu0YpvAAhHKcM2xwD4qx4pdsSXSDzzDZ55VRcCANjtFjgBOMF82Dx2DqBiD7ibAoCbVVDTl7QI6I319UVpPgEriBVAyJzBmJDm1ya9WT0LqHBshdjvxs5to+PaIgj5S7sOQQ0rHRQ2mngbGXOaWbpqn4EUzhPLPANVk7OWvWzwdL0AITCHGBc0kcKY+utKPsVwNfkeYSZ4ps/c7iOov2z2ZictXLUl/bQVNfPOTUSlRinnQ5b9yYBRljNtRh6NgH/uX6GA7swh2AWbyDhi2xgGcihH06d3zvxQJcnixWwMQlZfLWMLbBFG5yH5vz9dISRGcZczjZ5yjE6XK8zChys01KtOUKGgqT1hNhhKy2b6EpeL/96d27P5Wm2Gqd6BuwAo1yJWHbgAl2l49glQonabXv5gh8TlpLcTHuZd2AOmSeYUVBkQvrC7YL2CPULurbtGxAhZeNRiGJWYqrywkBCShgmITwtRW6WXSDDEPvOPRjettdjS+IuBDg5o69ev40/MCZ13LTh9vq+WEQXYC0T5kJhdiviF2fAwcjruzTSuyv3dzOu0+xiDbR73SdC7A9zP/Q4VvOYDZuEZu3v/u2Rt6/QSNyBL4xi49Mu32Ab6hDQydD9CzXF4ThU3embnWhALhdt6G5aCxTz4LHcTbN8CKtxRXeVXJ99+zNs9+yt5Qg8cN5LbIx6MJVm07lomY2WV7LUd+NeZQkTq98FM87qdwJVDqmWjF04tHgY4bVllKmY0v4tjNi8TgXqvi1h4bnmpLR79OgPPG6erBjRwHWVSk80Zb+ZTVZNqx9uTkDRRKkOFtgVF8ZTNeZqyUFCOUD/NVHX+Iyy4js1Xk7riWpa7CD6uJZcsBuNOWCCT7GRAROMfYDDBKo
 lx+g4/Nd
 xtCT6YvjOoVahtn/9ijihfDYwi4JhC287p8arp5u+uYbyAQFOdoGk9aUOPIqheUygCC0zVfrTAcGqLGw2NrlwpM2WSz7eo2shXI3mL79dIS9rANf42aXV+UytIKDxQzx5ZZjsG9KbP8YtkhQSbTLjgSTlZdiSn9/eCG6f5Xn7Cb6WmVNWAh3Ijg4FYVdX9+8swZ3JnjWtAq2sb1cZp8KA6n3L24Yn3O0pPEWKtskkEacFkHzuxK+zOhmt7iLFYu/l61P2anxoRO6nOjN6AtJveU5B9GUy6h+fkAfXevemBhABhbSmMepL/vUuq+5xnd4aDkmyh+SZyqgV/Jr+tib9MYSvrNQNAQcgO6LMYmPGDPFzCEyJYzEl3CstNiSmKO7YnFajqecgbWaOGoEHhFwC4t08SdS/M5G+u3M3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-29 20:26:02 [-0700], Hugh Dickins wrote:
> > Something like below. I will run some tests before proposing a formal patch.
> 
> Thanks for looking into this, Shakeel, but I don't think complicating
> __munlock_folio() is at all the right fix. This is peculiar to the use
> by mlock_drain_remote(), isn't it? Which is not taking the usual local_lock
> because the CPU is going offline. I would say, just take the local_lock in
> mlock_drain_remote(), but (I haven't read the history) for all I know,
> there may be PREEMPT_RT reasons why that would be completely wrong.

PREEMPT_RT does local_lock() as a replacement for various
preempt_disable()/ local_irq_save() usage in mm aiming for the same sort
of synchronisation.

On !RT __mod_zone_page_state() is usually invoked under an IRQ lock or
within an local_irq_save() section which ensures the per-CPU counter can
be updated safely without racing against another counter update due
preemption in the critical section.
The counter update does the not share the same local_lock() so for
PREEMPT_RT reasons the preempt_disable_nested() got added to ensure
preemption is disabled on RT, avoiding the race window since there can
not be any in-IRQ updates.

If this warning triggers on !PREEMPT_RT I would say you missed disabling
interrupts somewhere. Unless __mod_zone_page_state() relies on disabled
preemption, too if there are no longer any in-IRQ updates.

> Hugh

Sebastian

