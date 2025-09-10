Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7F3CAC58C
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC1C8E001E; Wed, 10 Sep 2025 04:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894148E001A; Wed, 10 Sep 2025 04:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9218E001E; Wed, 10 Sep 2025 04:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4558E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24D46C0417
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:01 +0000 (UTC)
X-FDA: 83872597242.03.12E9C07
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCCEF100002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uj8nV6zM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="RKOm/P8Z";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uj8nV6zM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="RKOm/P8Z";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ynsc07sxqAYxTDrBUJOoa/Bn9nwG7erBp//UIQgFkWA=;
	b=0A+ITaQhM75Y4QC57d1NobI/dGJOB3+g8BG0mMkwB3NDty2PNXwoyXAfcEfY5LoU7ZP482
	VWHL1ib37R/+qsOVml0N8FDJ5Ds4gEvJj79ZRlQfQyyYLgjKdIIPRMqWjMzegs2ygtkz+g
	ibekEvkpSTqIoJIxT8Q+u3PAyUiZl44=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uj8nV6zM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="RKOm/P8Z";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uj8nV6zM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="RKOm/P8Z";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491319; a=rsa-sha256;
	cv=none;
	b=3r5hScDm9T6lpTyEDFEIXPTnM9RwLnYHKOJ0yuDzowhLqk08imyXZjGsECRzIdKNeSy49Q
	9WsaqZB7GWH54FLJj5F4jSkLf/diyT/RpecNIluBDQyV9Ad98rnEB4gOIo119Pkd5+FPq8
	7BvkgyUwp07ThbHKINXvTXa45Cx4i4c=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 523C834C57;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynsc07sxqAYxTDrBUJOoa/Bn9nwG7erBp//UIQgFkWA=;
	b=uj8nV6zMzC/X6EkNSTlNcIpAeSk4jvyl1rMWK3jrJhQVkVYp+W8Zvaoqb0bpVwphKaSFdR
	WkeJrRmogsazbVcO2UDw9QnjvRhZIZcbJyKraY7UETW2U6LwfiLfkRWaYpemkA61eYQjJg
	6RdkIVbYPDwciKcGUMEmL0zSpLZbD7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynsc07sxqAYxTDrBUJOoa/Bn9nwG7erBp//UIQgFkWA=;
	b=RKOm/P8ZnTjxWcdQiJRPf9DbZAmsXc2caBMPSBD3vKcFNOD6G+6srjaUd6qFWTlpnPFwe2
	vwd4/VYfuUWDKQDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynsc07sxqAYxTDrBUJOoa/Bn9nwG7erBp//UIQgFkWA=;
	b=uj8nV6zMzC/X6EkNSTlNcIpAeSk4jvyl1rMWK3jrJhQVkVYp+W8Zvaoqb0bpVwphKaSFdR
	WkeJrRmogsazbVcO2UDw9QnjvRhZIZcbJyKraY7UETW2U6LwfiLfkRWaYpemkA61eYQjJg
	6RdkIVbYPDwciKcGUMEmL0zSpLZbD7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynsc07sxqAYxTDrBUJOoa/Bn9nwG7erBp//UIQgFkWA=;
	b=RKOm/P8ZnTjxWcdQiJRPf9DbZAmsXc2caBMPSBD3vKcFNOD6G+6srjaUd6qFWTlpnPFwe2
	vwd4/VYfuUWDKQDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F041D13B05;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6GVeOkIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:17 +0200
Subject: [PATCH v8 15/23] maple_tree: use percpu sheaves for
 maple_node_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-15-ca3099d8352c@suse.cz>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DCCEF100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x37rd9i5gn56g7nkaqsefj7wmxtgnzh6
X-HE-Tag: 1757491318-908484
X-HE-Meta: U2FsdGVkX19sXYLewBPvXc7cAZAUuvgLiwVYrc4cAO0HFHJ/5g9dIW3qJ/LbIrx1bCKNhM+pX2ziOODu/tyvTIqnUDZCNH2Qdn5pAgslQKadxawre9CP9+g21o8oIyhRrZ5ALWMCUu2WbdV54JI0bhHyIUuMhCtSk7JOH+2ARKLvmx7upGesdiC+GgURPJ2JeqEQVS0l8j4XrGg9U0Uau0nNwR7QFHBk61KV0oc4PI6WaUlFLhEdJDqLleR23s0sjcn7EPmAGGD5+UA02HZT4dYjPN18IwRknXf+R3naYi++/QYavVFIa6lmaC3/cBnudDHCB3HaC55h76U2GpVzd8bCg9jKAeoy9yiJ8zOjCWmPSjSrC4R6o5NYaJvO1ToUQLptVO9gVLiFXJYoUT6m+flf51HgKkQ1xl7uvHWY3RqmBnEAngWpPr/zdXWPJvhr7NYO40NT9g4TZFsYDoQIvtJJR2U4+WFEllQlNyzXxJJNpoRTwnKwhObLjT2D8sX5dAQk9EZQxkdA1gY7OUZmftjPrpql/yTl+9mFT7O5uGJtXVMAR0EEiOjDEieEp/IV2I3bHBl6LeaMKzYi+NOyQLrjMUlvHUZD133OhDKGDFeLO70wO+RZ12GMKb0EunDR78Et+s9eEOH1f3gbqt21Ji3wJZAme/HJe6rWcrbacg3K/jzuODJY/y500Rzl3uMYP44iY11cb/2EjZzXMTcsehhji+wxPBGaWPAyfUZVRyX+ZiuN7mGEe73RFxkTZmH7MWDbbki1XzPCqJZlZGYpGIytvs6Ew22q3kozs+DdiwaK4hUzQtkPCG1hoEmPHCpYe5OHhTZfpvayzxzvB1fjt+n2S3myQCNq4CDrcMoQ/KKQ47pheYT7ogMEI5OtwiZbUlrlXbkanqGSmjM1HQpZPNL2KsiJOjMeNk6GKvuK9EKCyBe5D/m++GySoJVdyIBHwQwTOCvj4nGIEq/OP4K
 0kGhkBJQ
 CiAqQH497jmLciUbB49bMXIVk9dEdSxLGT6J4CFvAZnRA0XDTwAEPYedoBYlxKQFyENplvtagCrtRyLZgIN4qHsCiWVC4MreuxAQdYVwSqATVxFbYK4Sr7NVnRuEO+50JNybI6Zb5hhgCi6j6lO/CbOduPaCKUcJ1sVwqVTDFD2L7nTHDi1Cmk3+pUaXU/mANrYhcbjnxvZADyEmxUxlasAdwH7xMWdktQmjSb7ZZ3Qx9J8d0ZSi6r3jYApi+Y7rgfbVbM5DCE8cviDuoCnQEzhX8bNg73I/FmEFTBClAAaKCEkGY/5ezclpBWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
improve its performance. Note this will not immediately take advantage
of sheaf batching of kfree_rcu() operations due to the maple tree using
call_rcu with custom callbacks. The followup changes to maple tree will
change that and also make use of the prefilled sheaves functionality.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4f0e30b57b0cef9e5cf791f3f64f5898752db402..d034f170ac897341b40cfd050b6aee86b6d2cf60 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6040,9 +6040,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 void __init maple_tree_init(void)
 {
+	struct kmem_cache_args args = {
+		.align  = sizeof(struct maple_node),
+		.sheaf_capacity = 32,
+	};
+
 	maple_node_cache = kmem_cache_create("maple_node",
-			sizeof(struct maple_node), sizeof(struct maple_node),
-			SLAB_PANIC, NULL);
+			sizeof(struct maple_node), &args,
+			SLAB_PANIC);
 }
 
 /**

-- 
2.51.0


