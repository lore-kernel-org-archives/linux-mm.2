Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7170EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60AB96B0098; Tue, 15 Sep 2026 06:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5966C6B009B; Tue, 15 Sep 2026 06:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437226B009D; Tue, 15 Sep 2026 06:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10EF36B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDFD1C0321
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:48 +0000 (UTC)
X-FDA: 85215608016.19.52949BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 34CDF1C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQejdY96;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467767;
	b=6rKNgKjEyvMDzK01xhtudbNRMOAgjdkdj35h+E8Z7Sh79HcG4ReM/d9r7P8o9JTcomhWvU
	nOUJ1ucdRs4qwIWnfUQWcTMS8/hWmzIPzPm/TDhZOBSD1Ow7XbULeN2DTFGUIgPbxhIZwk
	0r8AuKY/3klpYqFg7BhDwEFFVxjuOlQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQejdY96;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FD0usaDv/+Lu82oshcV7j/hEpSlA+eSeMjmlzM+oZoA=;
	b=q4lleli2BUId4cca0yyYbMQgzPkg08HloOhyV4gd9Xq7I/kZyJ2DiR+YPogVicY4VeAda8
	swdt3hukgwSXdXGIzsSRIwkFRkRHiaWPz6Wmovv+M6VKz/1Qcf15zpSgdXjqHtNbSrjFib
	F0S2RGth9o7GBLIC/OMu1rgG4YvbtjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 726F14387F;
	Tue, 15 Sep 2026 10:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E0C1F00893;
	Tue, 15 Sep 2026 10:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467766;
	bh=FD0usaDv/+Lu82oshcV7j/hEpSlA+eSeMjmlzM+oZoA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oQejdY96kS0xDsfpwi0u/8CNcZshfIEcghMbq5EHuhdKdZOZd5dm8x5NoCxMA4QJ8
	 1tVhOQNfcGdgzFkcb7ICrok85RIer0HXOnjE+ZozSow/Ote97fP1TOdja1mH1yvyBS
	 RSgIK9/EgtyJqDr/CqhxB+w5HUgoNiKCwwk/N9Xil0sAHDAY33meJquZzcN/izHJJC
	 WjbKqynoKiDnHI07kaNPPaDLHXlW/dGUxJQioKFp7J7OZWE3w2CDAdfVcivicABUYa
	 gWiWpQZFDZRKpn3GL4ByTn3Fdh1zP+EIu4R5zms3xAr/T1svYeZ8aQCnqumZjkOd+m
	 PGOU/L+HP2+2Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:18 +0200
Subject: [PATCH 3/6] coredump: hold RCU while releasing parked threads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-3-f354ca41780c@kernel.org>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1174; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4ZTB5yNEhzFeYRPm7RO+Hv5mIE3RCIsFcZAFiThZ+rg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMm4We52yWHKuhsh1+4en2LDcv2Rs99O4xW/JD/P0
 P2XHBG2vqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAihn2MDE2Fnw1CM1z0uIN3
 2JqtOFIfLr/rx8G48ws5TV3vtrV/YmNkuOw6Z5HCZO7cfUHz173WlpTR2auVcfpOl5tRt42LfmQ
 XKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34CDF1C0006
X-Stat-Signature: wie44uc1ip6b8ym384m7qmqy7kd5q648
X-HE-Tag: 1789467767-393604
X-HE-Meta: U2FsdGVkX18azQtcfBvwwLl4UIFZ9EqUXqisChVMIwWACjFv3mNZ0UsFJajX4WZtsESDhEAS/chKoPUU1EycvJWTHl9xX/a36afeNkmY2X18udXntMTOtB2cHVR08Rk872FFzANj2Xh8gMSvdzAGULS8wGYkKKUC9ytwKdBhQo+2jghbnO3+nCSUsOI6doFT5bX4YCsiiyHbctJLiwixl8m09hwXpWwE5GlTsmWYXst/fpzlutoKw3sGk7Hun63Xr9HflrD9l23hXo9mNRYysobuJIvsL7iydAN7BbMSCX2RZ8pi3djqkNjujdH6w3tvQsYUO8vIfPTZWF1W1LZUlqL9PelGPwGosQTmr76Yc1Vc4ck6yQ2N2CdokWZk+kgGmNcRxG2sULEQkOnaot4jMj3F1MY968jHRKPbwwf7CxYyZCaQEbgIu9OcIXmkg5pxuNJKcF1iO50r0msdw54ehBH8JLLgKM7ijyyK8/ro2rKFraPWGY3FmiMovxuf98LkNLInukQzYFtlP991PvOseXHKVSB6e7/ic2eQxqKIA+kwCRfo88lcWAg/zeqLVEFwaMtQI773Pu0dewmwBWz0GzwgVb+THRZGtdF2hV8ze9h/xv4QprZ+G/Rs70vH+smNtBij8rtNXDfnj3v4gguGwZQfvOBqJw/3AjVcOc11VbhT9Vj/Tyobx5vjov3nIqmrxF9OpEW2sSXF1DvXg6t+ijk71toUomRYasSRBvD8f8Asknzd3CK7uEG1bteOzIbNXlGyQCPMBVDlnppr0cQW41Oi0nTJaHuqU5aW+y81O57Cb9zIPjmvUVT8M2LTHUPogIqh7CZl/muKgtSnUbQ0Jo8c8/yvmfGxXZWF7tAhb74gcmx6wjQ3IMz3qNs04ygxrby1GyE03FrGY2k3IgeuI0v1n+L94VDYQoBb1G1o29BaUEyIB6oCEBywiafFku2365hp9sDXlgR0S+SaQpL
 5Oq05CEj
 Z9KqrCAQFdU0fK9S+a8k/kDfjR5kQ9fGW+YsasPCja+ih8NzJEb5x6526/W4zC9MOxwumkAEBWx39HfYKwz3VLMI+ien3KgBvwN3ASFtowRKO0w6Mdau9cdbY8xMv+sEVvuWrLVj3WgvswiaC6aw1IIB/n51xWmDRH8HG0PNQkowqB/pTSc2JYgrlOZiBkhoU4Z8/8FkzBl82j0Uls9nVMwVTh/Tri7GYEgxKJsGGNvVzP7D0U6nNuOTRDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When coredump_finish() releases the threads the wakeup neither holds a
reference on the task nor is it inside rcu.

The threads don't necessarily need a wakeup to exit. If it gets
preempted or was woken for other reasons it sees ->task cleared and
exits. So only rcu keeps such a task_struct alive.

If the coredump client is preempted between the store and
wake_up_process() for longer then try_to_wake_up() takes pi_lock() in
freed memory.

Hold the rcu across the loop.

Fixes: a94e2d408eae ("coredump: kill mm->core_done")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 791a9268ed96..78ab6cb78be8 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -602,6 +602,8 @@ static void coredump_finish(enum coredump_state state)
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;

-- 
2.53.0


