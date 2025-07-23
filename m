Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B21C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644D46B00C5; Wed, 23 Jul 2025 09:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5046B00D7; Wed, 23 Jul 2025 09:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD4D6B00D8; Wed, 23 Jul 2025 09:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 377AE6B00C5
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5DEC1A06E2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:25 +0000 (UTC)
X-FDA: 83695626210.24.E50584A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CC5C180009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PeRIBlAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QH0aAN2I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PeRIBlAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QH0aAN2I;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnB5Z/uUr1V7ojjJYSvVXb431U/VD/MFqSsJJofBvxs=;
	b=TZYtHU3i933u2cJUtBeIXJ/FCPTYNY6oPshzO4uuqGwUoJ4jgb+1+MrD4ZkdkXda4B0PUO
	kwEG4unA00mQi8I7HlX8e+dZPBrmHCk99VG+lFp4OkwGwDm9z2YM8gWG0+MrKJQM1xwHSv
	G0DKfEkmrDrX5L9oI2czilqFooa/dR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277723; a=rsa-sha256;
	cv=none;
	b=6I4E35ApfZCfh9bZJwDsho+qWKkQ+UqWItnVO/lqY1c6lzcFzkyfqncfNYZD7xTCA9R0Ts
	+QdhQk0gJx3iFgCwtZIuuMEEgrZwOF8WTO5vqMS8xQ5ltDkYLs7u+PGgQKufm1mrnSa/jd
	kQNxbuCzklR/ng58P2xLjq5JoG2HdZg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PeRIBlAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QH0aAN2I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PeRIBlAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QH0aAN2I;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F3B01F790;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnB5Z/uUr1V7ojjJYSvVXb431U/VD/MFqSsJJofBvxs=;
	b=PeRIBlAGtgcYtv6sV41maiS0N6Wyp9R4jEVFozj0FAL64NcONmOw/HHDJ2Uw8yqbS/yj07
	uX72Rm5xLLHPkWs44sV8qF8N+d3fCZfgQXV66toCcEpscT4Ay5+zMYiiY5IXJE+McEceiL
	Z7ktm3gD6bc8QbxCGpjmf5rdQMqKc5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnB5Z/uUr1V7ojjJYSvVXb431U/VD/MFqSsJJofBvxs=;
	b=QH0aAN2IfgpijQ3IVcSa2GuONJ86Wq/eNK/EUoByY4hgIJ+MyRWxfLYayE4qTrn8LBop5m
	HT0bOSzSE5uZgDAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnB5Z/uUr1V7ojjJYSvVXb431U/VD/MFqSsJJofBvxs=;
	b=PeRIBlAGtgcYtv6sV41maiS0N6Wyp9R4jEVFozj0FAL64NcONmOw/HHDJ2Uw8yqbS/yj07
	uX72Rm5xLLHPkWs44sV8qF8N+d3fCZfgQXV66toCcEpscT4Ay5+zMYiiY5IXJE+McEceiL
	Z7ktm3gD6bc8QbxCGpjmf5rdQMqKc5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnB5Z/uUr1V7ojjJYSvVXb431U/VD/MFqSsJJofBvxs=;
	b=QH0aAN2IfgpijQ3IVcSa2GuONJ86Wq/eNK/EUoByY4hgIJ+MyRWxfLYayE4qTrn8LBop5m
	HT0bOSzSE5uZgDAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17D7613AFB;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4KOKBQjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:37 +0200
Subject: [PATCH v5 04/14] slab: determine barn status racily outside of
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-4-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6CC5C180009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 39pmpckcbd654jiuai8ef9gk4o8ny97q
X-HE-Tag: 1753277723-375758
X-HE-Meta: U2FsdGVkX1/VRmoprevpTRZQqUstajGLgxwLfemT3G1rWoaxCOOCVZKq46asWF4iqFa5ku5cP1Ylm8NaRY29pa8U5IXyBPSuxioJ/onbywzAPsbtz0kk2mnZZ4yrBRzI1WFNnPIp53afMAwpnOPhxkhS4fe5nwgnKCgzs4/T4Ym/1GnBRH9Uc1MfeuGVzGQdJQMU5m8NqKcMUjW1c0WwdjdGl4zioObpVYWarNFpmd/XqR16E++oDhy2m6Sa8X+gjFJU5HwS+vsScr+iwPGe134PwEYOE762R3Cgo1/6Gs9Ma30VsVEgP4impyf6QaA6rjtSqumhSz3ENAHMAyukHMv7pfoiuwKarZKC8pcGaXOeBwV73s/keTVjvXIhiTGC1tKZ3IX/dADxoGXxvts3oDWqzg9ytHJUpuXTvYg0aryzzymCsOdoq/qF22Z6SVcLuoH5kWtGQcyTuadCX7Km4kP/hE78WbncaviB3FTqLsq1KaQco7Aj6uW92nbmK0geac3EqIED7/aKOn5ZEic2wolSvALLDnQ4oA7YVYABeySMUDkxJvF3JBVxp1+HZwLgiNC5vEeTH8pWdxuYSIlTUkS51wyvr7bW8UcYRA+vAvQIm6vK80ntcPZqPaJRpil+Z9rvMgxK1WzEe/ix777mAglOcdBDVDQ29yZsVgqsnP6WPjLyqtN1jMR+pzhb15ZleqWMQ3H3I2JIY2aJnT14uG6M8KIskHGUCJ1TN0M9xqGuBylSx+qe0GhX1Uscv8zCQg6cIf4GX6s3W8HQQ3Eugmgu64rqpgtreP/Gt9gjhzuen0SXoGRMeC+arXAqpVeseDIr8zv0yx1VuPjrNmib4w7OyxlFzzQRzX7/AMtNxAZgw2jPszCydjFXsSXgXHYGu33sjy1JPQeAG6djS3CYVS9PUpNQPBWRGrdqDCTeyEvqMdW0KmZzPht4MWUAVNi7FMnAL4hnx9ZdJje8t7j
 OV6JatNX
 4eP4QmYNhAgkZ9PIEZqWCkuB1I+vR53nGutCafv9oAyqfJs1JgdxDbMDnQZwIpUakEQmVkOYJh3ia4IJ0lUbl1SeLMB4kaDqg41naaALQ8MakKWXtEjRKmo5OGveahA3CChwjBtsdc73annHrIW/F+1SK34nRjGIebu9UDfNBi7PE0HSL0KuDAaq5ZQsvv8ZoTlWQSJC2o6cifsLBpms2jtWEpq8l8qGW8I9t8v4Y530kg8oyvWKeJ1Y9FHfFh9Cc8Cq8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The possibility of many barn operations is determined by the current
number of full or empty sheaves. Taking the barn->lock just to find out
that e.g. there are no empty sheaves results in unnecessary overhead and
lock contention. Thus perform these checks outside of the lock with a
data_race() annotated variable read and fail quickly without taking the
lock.

Checks for sheaf availability that racily succeed have to be obviously
repeated under the lock for correctness, but we can skip repeating
checks if there are too many sheaves on the given list as the limits
don't need to be strict.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8b3093ee2e02c9ff4e149ac54833db4972b414a3..339d91c6ea29be99a14a8914117fab0e3e6ed26b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2760,9 +2760,12 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *empty = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_empty) {
+	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty,
 					 struct slab_sheaf, barn_list);
 		list_del(&empty->barn_list);
@@ -2809,6 +2812,9 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *sheaf = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full) && !data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	if (barn->nr_full) {
@@ -2839,9 +2845,12 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
 	struct slab_sheaf *full = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_full) {
+	if (likely(barn->nr_full)) {
 		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
 					barn_list);
 		list_del(&full->barn_list);
@@ -2864,19 +2873,23 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
 	struct slab_sheaf *empty;
 	unsigned long flags;
 
+	/* we don't repeat this check under barn->lock as it's not critical */
+	if (data_race(barn->nr_full) >= MAX_FULL_SHEAVES)
+		return ERR_PTR(-E2BIG);
+	if (!data_race(barn->nr_empty))
+		return ERR_PTR(-ENOMEM);
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_full >= MAX_FULL_SHEAVES) {
-		empty = ERR_PTR(-E2BIG);
-	} else if (!barn->nr_empty) {
-		empty = ERR_PTR(-ENOMEM);
-	} else {
+	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
 					 barn_list);
 		list_del(&empty->barn_list);
 		list_add(&full->barn_list, &barn->sheaves_full);
 		barn->nr_empty--;
 		barn->nr_full++;
+	} else {
+		empty = ERR_PTR(-ENOMEM);
 	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);

-- 
2.50.1


