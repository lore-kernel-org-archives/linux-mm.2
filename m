Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DC1CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EC28E0104; Tue, 14 Oct 2025 08:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF448E000D; Tue, 14 Oct 2025 08:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADF08E0104; Tue, 14 Oct 2025 08:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6430D8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:17:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08A0E5BAD4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:17:37 +0000 (UTC)
X-FDA: 83996620554.24.091C633
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1BF7980017
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:17:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Ble0H83e;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4I1a9cCQ;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FhJoJ9sh/rzNr2PrKp88Hxaryk64dOD8tUujsdzCgGQ=;
	b=O1Oms486Fke6Oza3qZaOQLNIpnAljlygE+uvtSwt+lqUnjC07d3Qc15a+zCHt13PKD6YsT
	sjRDcbb2sICIq1e2+giqn/6eVFXyqloZftW05mKug/D6IzCs/lbPHhGg9vVGYt5QC+weWd
	WYg6Y9xd0DgfjYIIDsVCX+ZHk7jn7Gg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Ble0H83e;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4I1a9cCQ;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760444255; a=rsa-sha256;
	cv=none;
	b=LXt6092ZwiergHWdIZercRMJalLsFC/r7vZfaccaYfXR8vmxLK8kjmKgJDYC+Ai13JBTI5
	aF9Iuaul6vJoRjNTB3WFzS8+zWljYL0iaLtYSaCg44rdn97seS9WvAVWzgiWJdr7et6x4o
	AkTNHQuU60idWXxZu/NdR33xnZmcI3U=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1760444252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FhJoJ9sh/rzNr2PrKp88Hxaryk64dOD8tUujsdzCgGQ=;
	b=Ble0H83e0fuYY4+wv1NL+635xo7D3oTuXx8GedLjyBKm7HGLr9LAGuYEv8EXfOjzoN5Zar
	1rYz1bqrZ/JkdxJ+zhLIcM+w9Vwjxmin6goO9MoLXULJtXk1e0IrTX5iExO+RYtHaJzCpF
	xjEF40eUs57LwWMRekbKmply+VJ4DWiVrJmAkpyqPapquSClT94HZJh0srjueaVa4W2TEn
	6IOTyg66dmMBEcGPTGsdbmfMdt/viORmp+7QsTjkwOq5n7EMzWGd96sflG7z7dGvGNZHst
	i1683NGzGpdmgEctrcwusZB6Q6yHXZn97PzE3bpmH2GeLGN/uHpNz+U5VwdWGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1760444252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FhJoJ9sh/rzNr2PrKp88Hxaryk64dOD8tUujsdzCgGQ=;
	b=4I1a9cCQdKf3V0UthOuGjYRRLJAB9eXiEw304zCQm267VJ7N4g4wQUGlKTtjW8/uYKn7Si
	FAE1dEr/cH4hWsCg==
Date: Tue, 14 Oct 2025 14:17:23 +0200
Subject: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
X-B4-Tracking: v=1; b=H4sIAFI/7mgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDA0MT3dzU3IL8/BzdlPxkXTMj05QUE0tLM0NDAyWgjoKi1LTMCrBp0bG
 1tQAutAIpXQAAAA==
X-Change-ID: 20251014-mempool-doc-625dd4996110
To: Vlastimil Babka <vbabka@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1760444246; l=1440;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=nfi0PfSq6Dox8FYapvzx2yyqZb6FV4A0jwmwDZVXYCA=;
 b=wKeMfz8U2ptYpXr7OqbqIBhkLpbKS7lKG6KC01/LeijIueu/9G17xbRhhBgvjAE1NGGLTL70B
 iKzdh5OSC/BAqg+8EF4qsMQBySXulgy5aBtlfgKBxExFORpBKTdRv4W
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 8ra8wrgdae54wtoadbr4woy8sgk18yq4
X-Rspamd-Queue-Id: 1BF7980017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760444254-221985
X-HE-Meta: U2FsdGVkX19uhV8mYk9saUH36SYN37UbSj5sdfbXfYlHW6h5vLqddC7hU7zx1fp0gWBTYFoA2CNqMUeV1nk9f2MfGj7LsEWAUpe8oVghBwCxF28Fg4lL33OoQj+ex38gzqw4njMxZ5yvv0rECqOzGHXTbaK2vhglot4h0rzbh9/c/aIoNf9SQzFPRwftyimZCtxVaPqoaPbhVJZKvmPrGAY0jGZdzodaXXLHuKimsFUOEtW1cweNWngJ5EdpUvqWMnuITNSRIAkWZFJuR+rhE7R/cHCzUkCqNaEyNd6TkQwreW5aBIYY7Wzw6qPrWxfrmJRpI4rMIRAk1tVvLDp/2UN2spzpVQlW+IKnmlrcJshYWwTs++RZqwH2DCTl/nZApvDSgC6lZe0av+o3c4vDihAx32heIG79T28NJBKCIlCFBBhISqoyiHJcKY6iVmFF30joLIiBWWL6AXIlMiN/NapNIWQ85cJqoBewzbQ8zdYrDT6qbBIar/Zl8Y30YwLNnU84Jv1zo3pnXggN/INnOrZY9PKNzskuRBdsQe45Ro6G5qlaqpy/XO3qe+KZ3T8mvXPKAGuSMQA86t/frc4F7Z5U7/G4IKCf52dJqGECrsIZFG9EdM/a4LZnOoCs1UsNZOzr98uW4CSwnVthG3SL5arD9Ly8Y8GSDKCYhBif5NIqQsPuJH7RNZBIRNtFxnka/ne38Qg93Viwgiyz1QmsY9VOQM+21dUiozzlMsLLRKVUwMnxlbLIMTlhk2PKwZvkp0kMxoTYLn03YV2AcO+i4nVm1z6ul1tBkv9aOq4m/hkUHOH2j6jsJ9GLSadpG7C1Pe66zJsQN0pyJcXfP+2xkt23b49hzOWckVhV8azz7jt1mPT6w1mGICv2IV8sgTVPVWH+6o6dId/fSQD9dAxrp4dprODiTI0E1nIU5XAlitCFaj82eQ0T0FUtFKocu22XXBvsJ1rR7Ww9G6cJRrP
 Uq1opR6N
 fPm6MH3UD+bQk6InaH6qTHl0qmELDjLwYiLi1CVsZUu4U8v5s6LjzuU2ihIOBnRuBxY4KvpjbRQjTcuHFkIC9eJZdPUvMcGV7VXebLEW+HtSyS6WIy0a5cC0M8WMnsn16EpP8Yh27h+d5NXi6fvD9U4mNSmHWlgZVaz37S/loV92NQi1zI9IAQy01cASK+hQQ1RxePmU+Ex7N97HMrkbeUMfBZXYrR8jcCrjTkBsJVqRuPr8kX/B7mpx0VAiIuyrKThG5RJ0Prk9egSYdPsr7HoIaEX+tUSMn8DW0wPuT/h/NjwcJYsMFfhj1y9kf4QeaY7L4DBJHmWFxnAdIvOKo7TEBlQh9fXnpSG7vMfajT6i4dngKK8xEtNY1eCGHn30jxcwcnWxq1wC4YEspXKvbBcyQPGGNKI8H89O6RGZMSLZYpck8TKRfUQD364h3eBP6ad0GkW51rYWfHgqKHUwhe5qocuW1G7aCud/tmWOLy3+giAE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The documentation of that function promises to never sleep.
However on PREEMPT_RT a spinlock_t might in fact sleep.

Reword the documentation so users can predict its behavior better.

mempool could also replace spinlock_t with raw_spinlock_t which doesn't
sleep even on PREEMPT_RT but that would take away the improved
preemptibility of sleeping locks.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 mm/mempool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546fadcc594f041874eb42774e3df16..cceb09b75ebe35f263a5fb95ff6d400221ecbdd5 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
  *             mempool_create().
  *
  * This function is similar to mempool_alloc, but it only attempts allocating
- * an element from the preallocated elements. It does not sleep and immediately
- * returns if no preallocated elements are available.
+ * an element from the preallocated elements. It only takes a single spinlock_t
+ * and immediately returns if no preallocated elements are available.
  *
  * Return: pointer to the allocated element or %NULL if no elements are
  * available.

---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20251014-mempool-doc-625dd4996110

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


