Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30950CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1FB6B0373; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483116B0375; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372966B0374; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9426B0372
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0067C04A5
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:57 +0000 (UTC)
X-FDA: 83821856874.09.0A68D4A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id C52BB1C0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7n9AthleVAC7CbjCfDhrQCMsFl6bTZ9tskVayPwQzEM=;
	b=xUj7G48gEx5ds6VUKMs9piWQFb0qfCHOnPoSN3ZGrRomGyMG3F1MGjCmuq2IlJAGcCE3Jn
	NVUld8TQ4dSp5CeeW4y/X4sNP7gbNVyyIJuKyRzs/+PQRx5IfQWJC3NDbgDAmdP0lBxHJm
	XYXebJC0o2Tc6mq9+Ot8aNfYmdSj/lY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283216; a=rsa-sha256;
	cv=none;
	b=e6cg63PATmlHfoq8IdT8R0n/2hW8hxH3nTv8xjT8KUiPCdvjItBbKHqwJwNIk6lBaFaHp4
	d9FtSRFk5PI7ABP8HRnxsbHfEAKZRKFfKG1p2HJad2be+XMzPpAkh2S4oDQWW+BIZ79Rih
	enkdKA99CfoWJDRZbsBNm3ucVY30m68=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EEFB1FF22;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A4F813A31;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFnDFTvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:37 +0200
Subject: [PATCH v6 05/10] slab: determine barn status racily outside of
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-5-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C52BB1C0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1axo9wkf5yb44ubq5eormmg9tnkmqtrw
X-HE-Tag: 1756283215-583851
X-HE-Meta: U2FsdGVkX1/wUCzRnQhUcbRAU60N++Avqg3j+qo4/oNxnwUFK2Z6IRa9LPeKB/l/tIGMngzKVMytY+V2wFca8j1WNtlh8mRMFSO9IFY5lM/3r8S4m/Mb0KYE0UVr3LqMwG/JoG4X/UhMtW8Qxy69bEZbqm6N5qKPCLTB3y9f1MFzXfe+S2seEeNOCU8sRVttf+z3WwZP6Iu0uM7NjJAp+K642vau2kN19bwmMaTY76SQXfErTjSdNaxG7pHzvDdNI2PwC6EwE2dA/gOrEznYEEEQjbsO/wifw0U/xIUZDblWhFjcdMP7NtIfS/xo+VhVju+wbJYSXyFE3mpN6s+WqNToGuDxt4OHwAbRVk4jwecAJMsbWnnak5rPowZLsnanJ+w5FhEHxDKBHx66FNzwrwEw96qCmN+ihPIzDVl5ABhXB6pXn452uMOlTPpfVk/Uz8BC7R8RUhVUwGtpFOLXe51XKxhT3T3I/fhZjz/SeOHOM+sx1o17uViftJlDRP/ic9+xR7rkaTLKpLDPKuQO8eMatMxPgebzUBhEninojuhAOQKrp3WS6K1qpIlGy4eLzl+X0bK1heMPQa7SEuGTXfDNjFta3aArOwFEhwPKseZ21z49umiA6aMNJEsDcItBXFN/TqPJAWVI3hiX/0dwmpaRUO/tmoLzs1FzazNNzIRseZp9/kuF6oO6v02qvvJCHd4McfGsFRqijx1YU/aaOMQbRfHohKDA3OtgvGGbC6FaN1Td9eECF5tAdRzDJbn42xcOKonAEHKVtua5Lm9iHKYVX+r8pg2heSijbKuAhyb7JuaEjAkh/1KMvLcumJMJdzfqISHj21U3nOTaB/Ne8QzoS2WSy6kpdMXBo98zF94rSQd8Dz+onJR1TiSRpB+lf0sS2xV6pbiGxzup5b6G5T3ctg1uWmyaLOsC8lX7NetwCe0XPo3KsCP5oyKuWb/xcJzF1UBI1P3Abc6nFUd
 3ziLk3ku
 xYHBAWJyPvNw0S/M2RSe2Z0ciTVDD4T687TxPBcZpJJv6jZrw+ywHl5lqGIxsF/AmeOSeaQ7DaBesQd3E6RH2bVETB34OZBVOlowm5d5Bn6CU1kNVgtkKiMj+ITp3MDVCBQPg
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
index c8dda640f95e7e738cf2ceb05b98d1176df6e83f..ee3a222acd6b15389a71bb47429d22b5326a4624 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2796,9 +2796,12 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
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
@@ -2845,6 +2848,9 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *sheaf = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full) && !data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	if (barn->nr_full) {
@@ -2875,9 +2881,12 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
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
@@ -2901,19 +2910,23 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
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
2.51.0


