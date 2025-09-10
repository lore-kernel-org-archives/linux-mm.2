Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 155B4CAC58D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5348E000C; Wed, 10 Sep 2025 04:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695848E0002; Wed, 10 Sep 2025 04:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DE68E000C; Wed, 10 Sep 2025 04:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4094E8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD2481A04FD
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:29 +0000 (UTC)
X-FDA: 83872595898.18.E578416
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 90B71100003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V5c547z5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l4TTmia/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V5c547z5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l4TTmia/";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVEIM/MDCKtvnIXrVRcMDO5sWDmIfgRmhE+MlQ41QWI=;
	b=ruUN9MEZfbPi0knmFznk4KDikXO9GM9D6m8+VdhoEGB4cgAHoekbRLD/kp6A2Jq+ae/Bv9
	Y3PSo//6tR3e6pn+9qXj8pqNfA8EPRYwnLobEtec9Cmjzf+iK3lGDDpEjcRb/6MdLBWGWy
	lpthhr/AuldYclpXEA6burH7vc8ZKOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491287; a=rsa-sha256;
	cv=none;
	b=O4uB8+XQQcUIamQUMp/58Mb8qwgXoT3VrdiMP1lBx9Vitx6rHSEDUZC4p79XgFGf19L2nY
	6SHjajLq5Tv87AOjumsX+C1F+rqKQh2PY23SnaFdMMEggoyB06LEaWwfi80BLu9PRqnUSB
	X1YDg9oFRtYSeneQzmN8c36peeUcXns=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V5c547z5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l4TTmia/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V5c547z5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="l4TTmia/";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E6EA5CAC2;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVEIM/MDCKtvnIXrVRcMDO5sWDmIfgRmhE+MlQ41QWI=;
	b=V5c547z5wNthVq/56PoWXgs+qXWml7gJY+grLW4djI68pMUJKJcIdPe0g2NgQEHk0zelrg
	YBRVqZchcddgXJ+aDPDcehOzBvcE+cLUxxd8HCAce+g1w/sbrAxac0giN03FonM2pCAN7r
	7vlsrx2mdJbFUYT9OV+63xWfoSHNVHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVEIM/MDCKtvnIXrVRcMDO5sWDmIfgRmhE+MlQ41QWI=;
	b=l4TTmia/x1XZGQPqPIl0vAooT4jjY5NWGJY/yYgDFbpY060DOgsAzYqq6wYK2KxaAJK48K
	kkQ9RUVbKxQXpgBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVEIM/MDCKtvnIXrVRcMDO5sWDmIfgRmhE+MlQ41QWI=;
	b=V5c547z5wNthVq/56PoWXgs+qXWml7gJY+grLW4djI68pMUJKJcIdPe0g2NgQEHk0zelrg
	YBRVqZchcddgXJ+aDPDcehOzBvcE+cLUxxd8HCAce+g1w/sbrAxac0giN03FonM2pCAN7r
	7vlsrx2mdJbFUYT9OV+63xWfoSHNVHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVEIM/MDCKtvnIXrVRcMDO5sWDmIfgRmhE+MlQ41QWI=;
	b=l4TTmia/x1XZGQPqPIl0vAooT4jjY5NWGJY/yYgDFbpY060DOgsAzYqq6wYK2KxaAJK48K
	kkQ9RUVbKxQXpgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28A5913AD6;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mPqkCUIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:08 +0200
Subject: [PATCH v8 06/23] slab: determine barn status racily outside of
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-6-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Stat-Signature: kat9yw1ctuf7p57kkn9tkd9iqnqo7mr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 90B71100003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757491287-768491
X-HE-Meta: U2FsdGVkX1+gos8XlPVAvNl8i9t/4kKTo9ZZxbDTXXTbTpi68GsUegenctCFfUfC2hf3AjFRaNz6+eSpd7y00dhUz456ukRVLuWy7fDDkix9KPj7POdGJtyOspCjhu1qYAj0qZE2Z8i5AiKz2hsmqWptNXr4M0B7sTGL6cZMQBNWXr5JeMi/tFWkm5oaCUBEFcyWUsouh/lRp136sD9u/9eJZv2B6ONmbbYRrLT4EBiSttstJF/AAeQgm12CT4a16yUS1WoWkK5pm2C/4bOo9l3PqI6687gIKAHdjCT1HO+SzPcd1SHo2t38eoqM/oOYx6BYIE3vFrPdRlDHwdkkeZPcvZ2+vulIp3qQX0PiozT9EAl9Co6zO04LyU5OWPvJWdduUAAgjkRQB0jdx6pe7177aM1aCvg2awF/deU1OUSScD2UqAellHpMRwn7hULEfbzbpFHRqJA51Te/srw02N74+gH9h79HkRCZ/DEZr9xgOvOmpJdqe6y/QgmbZiIzKavwyQDecPF/StiFUbXlpixewDKhRSZxILboP8l2Ch8BgIAdBox7eS/HAwwO9qV3Bfo28ZhCAZQfJPdiHw2XklgE3ZXlAg1u9srTnXmWKSIUQQcXMjjOOGkq5oHGCaAbl/IoQizaDmebhAHLAeyxPUQ3k+fX+TOhmCKh0ICDmAI6Np1YxiwB05LXI2G7iXq0nDIDNszbUBMuXDfLqzVFqTMyomC4kCkxHvLt5bkWz7DygvJw705BTG7I2IAEWxinqdrYhlCaKL5vknzxdH6Hvewr9RUVwbc911E7NfzPCOVQQQ2H9lGKpB9f5qOa3lEgS6aPa2kwbDuixUWQsxhIRK/fXdtxkqltESeF5cqWpywxV38WxT1nBsEDrkNOgQbDnBI6fVtyUBIvoQYOfT6kYIT6+RIYjD+ky/X4TQGWbPnRbEubSJ9BeNqxny1LGaUPn6TINUmu88vr2qLYK0v
 QfDoQHVR
 CiqTWPAR8lbNKIOwbKEl40j6gQeGbaWs8H2YqfpGfqoLZc5POCUMI72ChC2FkbprbHmQJl7yPpZk3slnUC0o6FfEgniay0J7+BzA00zx3CtRwvZHovaE45bWyLqSa+ZCGd9qXfvFYFELXwSt+Cx8YD2r+Ipx6n5clyhagxSUx1FA7XEo9GYUS+QrliFKKk6Kth35FF4WzPmn8MRLwX7fkoqrov0mJp6HQ/Kl3yeCnIRm21XCvhaMN87W01/z96gwSV3P/JxUyCaRSJCyBB22oOvj7lmkDmy1nNprj/ft5bPOWQfc=
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 38f5b865d3093556171e0f6530d395718b438099..35274ce4e709c9da7ac8f9006c824f28709e923d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2801,9 +2801,12 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
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
@@ -2850,6 +2853,9 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *sheaf = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full) && !data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	if (barn->nr_full) {
@@ -2880,9 +2886,12 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
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
@@ -2906,19 +2915,23 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
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


