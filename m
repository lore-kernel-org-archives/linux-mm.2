Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6D3C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374586B0379; Wed, 27 Aug 2025 04:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323C58E0105; Wed, 27 Aug 2025 04:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC086B037C; Wed, 27 Aug 2025 04:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 025936B0379
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:27:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7BE61A0504
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:16 +0000 (UTC)
X-FDA: 83821857672.28.3A094B2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75F77A0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xSTgJhIX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SVYIM7N9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xSTgJhIX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SVYIM7N9;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=5z+tfIJvS5hY/2+ThoWPM9qFcb7zoxEAF4nz20qOuB/g5gLhaN8zMQOyhcV2sgL0I2YNK9
	cxeEM3GffLcrZvfrrDjHA/ugBbPaaIgj4FvTyNjrdHBCfDK+wg636dLYHtHr//5U5e7Onh
	B6ddaUUzLujJUW8YRm9ZwrZrGC2OHgM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xSTgJhIX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SVYIM7N9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xSTgJhIX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SVYIM7N9;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283234; a=rsa-sha256;
	cv=none;
	b=MOgTQIDowB01fsnUcfgh6s7+noIDerok9y3xLCadT6h1aJdCeH2xVqHhu3kbdY8Yt1bn5D
	Nx9DMS0s/wI+J5kvE4cqnI8aP6+NtrBSIyhg0IWbIqe9b6iGjJeEFjPSTwoECR1X+ecgfF
	5P6Huw9Pr0dTQdGP2bkEWzZ8Wtkq++Y=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDFAC1FF25;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=xSTgJhIXzLSiuibHPW4pYXFd/u9s/jj08ZTG5dkCAya50kJwjIuH6kUeRPJjHtE7XTNkKY
	+MdhI1k/ObTywr5+SUtd8soD0Cmn1utHhNAMWheHDHEKhszwoppl5xs8mcNI8Dz7SRCCzY
	kAqGm4s7/QIxe2Qj9ksRopEHISHLJPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=SVYIM7N9OfbLAjCujcb/K7N7X7RFZ5jssSiXgju7I7NZ878Mj/thgXlignLIOVkvYO5Pru
	xC7jP1Mj2uKaEmCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=xSTgJhIXzLSiuibHPW4pYXFd/u9s/jj08ZTG5dkCAya50kJwjIuH6kUeRPJjHtE7XTNkKY
	+MdhI1k/ObTywr5+SUtd8soD0Cmn1utHhNAMWheHDHEKhszwoppl5xs8mcNI8Dz7SRCCzY
	kAqGm4s7/QIxe2Qj9ksRopEHISHLJPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=SVYIM7N9OfbLAjCujcb/K7N7X7RFZ5jssSiXgju7I7NZ878Mj/thgXlignLIOVkvYO5Pru
	xC7jP1Mj2uKaEmCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8C3A13A31;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNbSLDvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:42 +0200
Subject: [PATCH v6 10/10] maple_tree: use percpu sheaves for
 maple_node_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-10-f0f775a3f73f@suse.cz>
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
X-Stat-Signature: 73nsdt4k4rnwyh6fiq76g8e8xuyiot9o
X-Rspam-User: 
X-Rspamd-Queue-Id: 75F77A0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756283234-957962
X-HE-Meta: U2FsdGVkX1+H9w+E5mTJN2Zr4eGS9o4SqMS3wr+UrQErOlDEybvEl49LHUHETIo0KxeWluzbuhMVu9w1ava4lMiFyehUw2oc8k8YwIF60ONWY/fDuV6yWrYKpoUWRp8UqS3nZLrga/FQl0M/E4GTy6P87FTcV/eelh9O2jNii2W67YXoQX1KPRykMoL6uJ7Vq78XIGAsTmTTkexbxOtQoEFUv7k2Yt+Vl4X6soGwobvYcUhcaNM6ae144Yyw0qllFh3XNFcW192a9i+LYy8VqMi25f/fZ5GE+gLjTGYNNFRAeSwCupzHO+itmfMNcKHKc4h3kuZHzwgEMtx5cGWBZTPf/Mv+uZNUnUfGEOgmGEUWcnldxCwAP9LBhozN8cMqtkqIDlPwX9uM52BiIH3ihihAf+MBuOHnGBrC3B6xqa7eneE/mKwEh/4GAfDu9dBfDuEatrfYXep0A3IbBXHKMMRyAjNwUqc0ZIswdSdyb8o1OHACOG2AkeDMpO4vQiZ20qrCY+NzkUkXf5iTw2ukkLGeC+2T+6BnsFy+OSLtU9GnP/bEXbFUTJ35ddgltukBs/tjlLSvqqAPTwb3ccbYs7lTEIZUsnD3lYbit6pW6Ow3fJ65GYeIRtvwoM4OJCI7Dm1Nw3FjKOWhjILay2MY+m9UT8Y0Ka2cSygPVund9gn0MqgkOPJmSfl9eqIO669j/reigDJPWS5QrGuDKlO/qO8St/WinA4eqt5Aq+C8iY2ufwpUFxcgsiJOAFA6lNgKpRGcD0Ra9MkXagZS+EZg4W5G2mxH9+u9UbIlZKZEsRGSMeRs4EJZckACIYKc68NW/4d8klXxTUvbYzomuP8vdwQer/K3ZwQ3mEAx9BwLw4o254QJaYN2aIkgmwtBNWpgAC/sDsy3r9aIGweJXEF1XnLijmAxs1b2GQC72I5+I9So7kZmqQZrdHG1L4dS2t6ue2zBjG4zT2f7NyIXzdx
 visZtSb2
 B9CqUD55fZfNkc/oOu3cMV8uKLer2wMJLZ3WhNqua2K+nMv718+Pcj+auD+9IOwGmmehTPCoRpRobAHk++AWqEZqVXQrr/ypJtNjvRvC9+u9AdTp4ioD3rOHyZgdJHHFHEqL6V1NlHkmvS8SX4PVmhUnmflSiToPp/ZxKXP7srzHHouMQm3pfJoA4OH0H63fbwPjcWqMhG2umOgK6KuGe2HJuog9zc3Pe9l1k5f1R+Q/93RFNCfYyFi5ja+SgHFGrUJPIoF0oJ9tBeel91sO4zlJoVrHjQufWZD5Pg89y3dRKEdBwAEhjM6Go0rY33+S3s1SN
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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a962ca374467d0533185f2db3d35ff..a0db6bdc63793b8bbd544e246391d99e880dede3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6302,9 +6302,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
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


