Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B387FC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756946B00D7; Wed, 23 Jul 2025 09:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7068B6B00D9; Wed, 23 Jul 2025 09:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEE46B00DA; Wed, 23 Jul 2025 09:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4218D6B00D7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A8A2133884
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:27 +0000 (UTC)
X-FDA: 83695626294.19.26B07A4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A8F1100005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRy0XfV6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q81RoC3k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRy0XfV6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q81RoC3k;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZ8jFguaUhh6ngJiPeQDDEWlyXz498l0EKqDytKUQuU=;
	b=BVjvaHxT64HIO9BxjQsuK4cTpbx6E/G+Amfe9Egb17P53EQ15WsRhUQ5ec8jLn66sJWujo
	elSut8iwvzffGcJ+xehCwsZyIPw7ga/LXYOeGoAwACWMN3fXHeI1onQMSXur3VlBjktifE
	F+x78v1h8FuxqWV/LdqALTIeihZeWwY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277724; a=rsa-sha256;
	cv=none;
	b=6oLGhRuDKH53prkV3D8BvXPGSbt9Rb9bu08BqC7DWFKDF/jHDoRGSQ9JzG9nQO7qOmTEKA
	XPXNCMyFfpZc3JrYS9q2xsuZMRKZSSPZRLfR80ahKC5wzQV/5+AofhXcxkh7Hne9Kqo/G7
	EIXTf0ij9moLRrNfLVfLGzNMAlCQjYU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRy0XfV6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q81RoC3k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRy0XfV6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q81RoC3k;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5FF7218F3;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ8jFguaUhh6ngJiPeQDDEWlyXz498l0EKqDytKUQuU=;
	b=aRy0XfV6iBHXc66Atd1OdHGcjOJGeVoDwjCdDi6IG1bqBLcKJ03/Ff4rIHu8ienAkNndOt
	7tKn/qP7oLqwY8TurNMa3eEGZ2DkqfD+BVqGpYBGZZISazTibzMxZMebBqVsMZrM8FnKgM
	ne7GThlYOUOie8dD7tbLgYExXL+P4u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ8jFguaUhh6ngJiPeQDDEWlyXz498l0EKqDytKUQuU=;
	b=Q81RoC3k+Z4CAeXV+PTWo4u8vh/2Wn16aPOVxjCfIaXnN/mzeCqB9IOAHMQ7h8/oLePiSo
	zT/j7zbDqxQu19BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ8jFguaUhh6ngJiPeQDDEWlyXz498l0EKqDytKUQuU=;
	b=aRy0XfV6iBHXc66Atd1OdHGcjOJGeVoDwjCdDi6IG1bqBLcKJ03/Ff4rIHu8ienAkNndOt
	7tKn/qP7oLqwY8TurNMa3eEGZ2DkqfD+BVqGpYBGZZISazTibzMxZMebBqVsMZrM8FnKgM
	ne7GThlYOUOie8dD7tbLgYExXL+P4u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ8jFguaUhh6ngJiPeQDDEWlyXz498l0EKqDytKUQuU=;
	b=Q81RoC3k+Z4CAeXV+PTWo4u8vh/2Wn16aPOVxjCfIaXnN/mzeCqB9IOAHMQ7h8/oLePiSo
	zT/j7zbDqxQu19BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FF1F13ADD;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AOy/JgjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:44 +0200
Subject: [PATCH v5 11/14] testing/radix-tree/maple: Increase readers and
 reduce delay for faster machines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-11-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <howlett@gmail.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9A8F1100005
X-Stat-Signature: dohokir7d5ssgi69fgcrr6k98796zusk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753277724-484487
X-HE-Meta: U2FsdGVkX19dImXMd4TcFAD2tpqTBJrwE0tgXRwh7HWjit5hZZW3FH4DzCUyU6tl4oJxsElszJaka7HVLIMzxY4t93WLSiDKk13yKv7OM06hohKbAbvLpDxX/gTFEcdGAJbyUqx55aK4sAIYuCnuodCftZBvFRrqv265/OqXRhBtbtfEf1Grkk3ZZlx1LtCREPCiVge46TjVb+tyRLR1sGXJkRoVDc8ouUw3Fd2GHI8PEbADKu61H65IdSWTtAisWHh2UKEXxXZZdgKG4CiCdub35uLW67szMHlczP3T0FiCCMcvo0m66IDenBE0HTqwHXUmvUCZrU842sbJYBIXR23A2VMAEai2bIluEO3NoVePNAim9KEL8xOI5x+Y+hVsauO1jRAoHfPEtQUkb/pyDwYehLmZIV9Bjm+V1kOSuKmPd7WS1VPm9GYOgNgXqmoDgyMonDWVDnuNTfrlm0p/c3tqcZpY15vy7GfSuiuREFEsvqJeAcbmPKnsGQPhJiaYn8SzVLtSrTQPlGcr4vLAf0VhhJ7GmD0xjVpnHFSXgjeExOepd/gJ6rBQWIDDDQMx2+G9xVqyPfLX+W8Fq0C0TebOn/9VRY9cLuVvdQFHgY8FetMos/rHMrYtB2WQ1fKOWHprngu79UWndeP4RLWugB2NXZ1oZhnTqoLZhm/+0b2KYWp1KLQdksduP7RG3C5/njkTu8MYwpqxgv25cWfAKXD4//1Kl7ESv58OqtDwVA9Qf/QHey4nzi3tDF5DOtYSpJ78V0EB38A5euNH/H9cjPQVBv7j3iYqReJQ9d/YCas67Q6awxmIE6I3rsqpeagDF8XEQsLeqcFbLbHz/58hdKsA4YTx4CUHZrpaQRFxt8J7weqYiOg7vym5rK954vf+wIaaG3o26lv3ruoBXIZMcwSdOkzt9kEXOuq41NFvaqyrwPDR17uR2mSsQd1Sc4mW8Zj15HoZzczMoPq/ClA
 F0kwlVY5
 VnS8JlL6XFjo+1XCYuH6//ls46XmDdPTaF5aTnd3LSnYVrbuvcerydGdi+rGDiE7kLT+FJhXyfC0uroiFreDWf1USI+nBDab2c6fxXvF+W+EQmpdhm9tQQAJcr8L3pcPvcExMcABeIgx7bCO4nflyZJOKayM3Hss2LBxfgTKxK8cbqjOAu0V4ANM4b2H0rHwpykYpD2SCXedEVwnBStU38frw6dLIEgn1ZEdOb00LXhgDQ6i7p71wTNoX+EzvVnON2yLEKFWAMTRhldg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <howlett@gmail.com>

Add more threads and reduce the timing of the readers to increase the
possibility of catching the rcu changes.  The test does not pass unless
the reader is seen.

Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 2c0b3830125336af760768597d39ed07a2f8e92b..f6f923c9dc1039997953a94ec184c560b225c2d4 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35062,7 +35062,7 @@ void run_check_rcu_slowread(struct maple_tree *mt, struct rcu_test_struct *vals)
 
 	int i;
 	void *(*function)(void *);
-	pthread_t readers[20];
+	pthread_t readers[30];
 	unsigned int index = vals->index;
 
 	mt_set_in_rcu(mt);
@@ -35080,14 +35080,14 @@ void run_check_rcu_slowread(struct maple_tree *mt, struct rcu_test_struct *vals)
 		}
 	}
 
-	usleep(5); /* small yield to ensure all threads are at least started. */
+	usleep(3); /* small yield to ensure all threads are at least started. */
 
 	while (index <= vals->last) {
 		mtree_store(mt, index,
 			    (index % 2 ? vals->entry2 : vals->entry3),
 			    GFP_KERNEL);
 		index++;
-		usleep(5);
+		usleep(2);
 	}
 
 	while (i--)
@@ -35098,6 +35098,7 @@ void run_check_rcu_slowread(struct maple_tree *mt, struct rcu_test_struct *vals)
 	MT_BUG_ON(mt, !vals->seen_entry3);
 	MT_BUG_ON(mt, !vals->seen_both);
 }
+
 static noinline void __init check_rcu_simulated(struct maple_tree *mt)
 {
 	unsigned long i, nr_entries = 1000;

-- 
2.50.1


