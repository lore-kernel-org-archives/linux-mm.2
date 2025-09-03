Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A71ECA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952A38E0014; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929258E0013; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F128E0014; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 752658E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24CB51DEA65
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:14 +0000 (UTC)
X-FDA: 83847947148.11.0E74932
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id B125C8001F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=arrlLRSN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dt+VVdAf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlow2CE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oiNOm3uq;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904412; a=rsa-sha256;
	cv=none;
	b=N0kP+mRIUr4D+et2J11QLZqamhdGbRGyDA8pt0TbVmP4lnjKE5nuMbZylqVVPlIgTy5JAB
	yJXABU+K27Sen8IvdYsHJAFJJztdX5wDXPl1yRv5euDqkg3WEFHOKiZomiYQ5JgLgAiaVt
	+gbFKzEKYAd1XyYO2LIH0s09PJcb8vI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=arrlLRSN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dt+VVdAf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlow2CE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oiNOm3uq;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04+J/P3cAQAe3/G2iQS1u1ZbTuFSibWkDWn/mbh0R6o=;
	b=d8tfxIQy88AYQ3B3mfLr1iGDCGMPjSspasphIAEVXHENEOGSSmlkHPycYPu3wO4TKnNa5p
	IGU17DCzeoUSh9LjEhRa6VLwgl4Gc07HLyO0HEgqQvDvMcg5XfXhaliv6T0O/FPwuJJSUX
	rZHmLHPAY9Oe4JNNDputFfxy+83VEkM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C4771F460;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04+J/P3cAQAe3/G2iQS1u1ZbTuFSibWkDWn/mbh0R6o=;
	b=arrlLRSNCRL6ztrX4z+FD1hSkyyR9ZqSZNGG9Ed+HwGctCLDYHwoF/xJXBgSnpXh8ZYbHa
	ImQWKKzYk+O3SFPxoA44W6RoOKd22MkH39Wa/SNLF1GLnCqBN3HKYxgVz+wQ3849+Kivo6
	QDOrNC8qkUlCSZbqJeGL9B+JCJHw2ZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04+J/P3cAQAe3/G2iQS1u1ZbTuFSibWkDWn/mbh0R6o=;
	b=Dt+VVdAf1kIxpkQBwHp5ohN73Uh9pPEAROl9LO8dyW7F8E9ilLpImzRQORnm9urOS2kZqA
	zEW7Pi2l0WmCC0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04+J/P3cAQAe3/G2iQS1u1ZbTuFSibWkDWn/mbh0R6o=;
	b=EFlow2CECEAnA7D8X1e5og3e94SIX/I73jq5GNahYqNxIwOTEctVEt8z4kzvQn0rNE7ywJ
	Nx8GvUXnF9YbrZ771Q62/SM6ZLBb7jW6aZNiaqvuYh5ylYB6PFUSU+HLNjTNWQc5n2Ho6+
	yESXtGfE/J7n1Z4NbG0RqzkObpqorXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04+J/P3cAQAe3/G2iQS1u1ZbTuFSibWkDWn/mbh0R6o=;
	b=oiNOm3uqjFRngvdN1r9enuok7DnUulcXMnJLb7Th9LxevZPfHOm3qhKwdrMH2qgHABx0pB
	qf+yX15kU2XL36CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2097613A94;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CJWwB9k7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:43 +0200
Subject: [PATCH v7 01/21] locking/local_lock: Expose dep_map in
 local_trylock_t.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-1-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 Alexei Starovoitov <ast@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B125C8001F
X-Stat-Signature: aounegj4onris8ym3wr3y71fhfidqpwr
X-Rspam-User: 
X-HE-Tag: 1756904411-805706
X-HE-Meta: U2FsdGVkX18Opyu7jIH+jZXKYURkuZCjQhDcvublFghhPpoiCw4fJ8iiP1Rgv5Gdxh230tqy37LAzsmY+VHzWjQ+/LKCY0SLKgc+ySzDPsEDsfGl4Bam0E+SrqTlqcAXuY/4OWQACEKzXa5cEgw2/jk3jnalqiFrkR4lhgnmN28HpCEGYNugx9XCFlTx85ab7RryjGWyWDX7dYXFkYUrtSZwsPB9CcRa4NA4HE0zSOJYHYtYzWFS+T9z15i/XCHJ7QmN25kr4E0+SwLMwbusz6+LvRfmxEYo4CjDYkONVp1wLrP4pSxJhLVGH0s6Cw76csNxP61DUofFeDv9Wwq2s2BjLQVdI15FDPQIt26a0fDk+1Li/4eaZVfdtWow51mTWv4bxRMKRm5P7uf2dUFiZffBdquu5FWkmK6j+on5+jKiB4WGbQEEUsgXLyMM7XREHIA0g47N/2TxDwIQxc8iTVWn4Q6e7JAK56huUOncyx5idSkLr/yf6Z/pw5N4V6mgaWXoT1k+4BWBp9dqSf5KWeGlGrCIr9j80fKqzAHy202+WUxoumd90P1CG4Xur9My9NFzQym6QCjIdtJCmFrNJ5znEZzXvKK8rG/P+mDU5nB2tzd4h8gM0o/tifHB1wpmGtCk4yGIPF/1juFNozCxO1Nh0recqcKfQWUfuLx7E8ZaNgebl6wV9Ej73TuD/o/Xi9UnhLBqlWUuyyBpyoRF2QWv6MklbpwQkDnLOp2O8XN7Xtsa4jvCJW+6NL+U3vKyRUCMtwsZVsWdjYy480KgZlsd3Ap6dCn/FGKD4xMAa1LQORgnJEL64OQz95Y46jthWnyq68Y3tskvah1SFEWu6SlQXfK0yrSzl2G0SSl+lIjqsp2IdLnv/Yoo0Ojcw8sxbGzWZxLqYRXdzlwxxq1yxKxFPqfXkCNfx1u8QQSRAGzLIwY15BJcfUm1bpHakkoEKPTElJrKFklC6rUb5kl
 /M/G6XgH
 3AeoqEL1tCVe9nhEDoCIFDgoHcKjogeVgQaQ47GYW9Z/olHRrAYsHcUA9ifRJYSVnfwMNkoW2HZZ62xV0tcW3qviF1nBYr+qmIxtC3ye2brzaFmMNXSbYyTu57t5KF5db3Xgx/HLl0x0Ich5T1UHM6dKPBibvvuQL9k3UCYiX0YCCGAH5w4vpM1Rf+CCrRD15m4m5BG9mMvT1GmXFyyOUZN18dKrcC+UuUxpJu0peyfzzZpueLxzHHPc9apdtgs7bn4sgtBQrNjLw7WzytgjP4Ei9sjfPT03wIwFQvyKRbHWF1H1K40a1DKulVJRBtAqmkR+GI8+phayxfU7W95xO0syKma4AuAYLKKH1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

lockdep_is_held() macro assumes that "struct lockdep_map dep_map;"
is a top level field of any lock that participates in LOCKDEP.
Make it so for local_trylock_t.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/local_lock_internal.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index d80b5306a2c0ccf95a3405b6b947b5f1f9a3bd38..949de37700dbc10feafc06d0b52382cf2e00c694 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -17,7 +17,10 @@ typedef struct {
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
 typedef struct {
-	local_lock_t	llock;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+	struct task_struct	*owner;
+#endif
 	u8		acquired;
 } local_trylock_t;
 
@@ -31,7 +34,7 @@ typedef struct {
 	.owner = NULL,
 
 # define LOCAL_TRYLOCK_DEBUG_INIT(lockname)		\
-	.llock = { LOCAL_LOCK_DEBUG_INIT((lockname).llock) },
+	LOCAL_LOCK_DEBUG_INIT(lockname)
 
 static inline void local_lock_acquire(local_lock_t *l)
 {
@@ -81,7 +84,7 @@ do {								\
 	local_lock_debug_init(lock);				\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init(lock.llock)
+#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\

-- 
2.51.0


