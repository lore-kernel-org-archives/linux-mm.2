Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F5DC9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E476B00A1; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936D06B00A2; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839CE6B00A3; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C31E6B00A1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BA4114042E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:07 +0000 (UTC)
X-FDA: 84323664894.16.2325CC1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DC441C0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCTJyWwPDFPcWrK4twCzQqUdDfuUWUHIy/bdXFPYDTE=;
	b=A4KObGMwkZD9F3/7htUI6hJEVUQ72+IQ9xJ2Qiho2Xmle6U2MHWwoPUs90E1qkRFrUnJEJ
	XLEQl1AZirhkOBczZjApM50FlwSmxHxa81wHw8G5+M/01+yKdtQSwunR0MtPhIyZmL1KF4
	MZhXaBWT0fNw5akTAZMyy5ZP0522Vvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231025; a=rsa-sha256;
	cv=none;
	b=PY99NhTa/fmjcfcqppmHHKQRUd22zx2BugXkxIjJ3wHQCqNCi3TspHcpoDG26um8RrkgXm
	Sxn8Tq9f1oIvqLJjnFLRjIkZmJ5WHT1UwQBbdXty477p5QEdBwnuRTmNoo7mPcisI+fglt
	jOVKvirtPtlkESpAhAQN5MCmznbXvm0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A16803368A;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 724203EA63;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDpLG2kQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:57 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:16:57 +0100
Subject: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: q3wuyh6jbu66yjtmn18pteaofkhwto49
X-Rspamd-Queue-Id: 6DC441C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768231025-630745
X-HE-Meta: U2FsdGVkX1/6LD0CkONO5VVOU6XJ73S/LYq2Zbe3sKdtk648Prx4c16fRvZblkg+ByzKndvJhz0RoJd6q3lTrhe+/JExlJnG4UsFCzcG7oOSEncfiFVYwywhTJfeZgxWCL0Qyhq/bRfgtV51XwwoPAGAzTczENkkuROg5+5YDUBDWs3YsRgBL+YqxC79Gxleb6rFBLgIesQCXJPMsMW8W7H0+m9xmXj1VPJ2VQBBvVgiUYe4tpY5zPlQDB0RsmUlym75gJ8LiczUSulL3lQ+/rtb+W4pIV3K+bT5VmbQMjBMbf9sOTBRg1D3YIy6s9r2iqz1iJVFaicHmfgMDoSPGDOzeQZTYDv1lLLdRKFOcTEeNgjrk5IKybrH+jsmbtXI8Bo2Pyu8g9fkm0kaQ4fPIY+hYeVq+3ktOHV+ieoQT+V/ZiEG8fvYJrDop+avbs6TEhuoULfqV0UyJBHObH9pGFqC7Zpn/D7r1hGeuE9hkW/KTHQZ9a8n+0loX8sST91fWPg/Lg3aaPlct+4un/ZH6ZJnKbCEZ+cM6zFwXERbE923UN6wRN9Tw7QRbpzCVqPyAax/YB9RW7gG3Rp5BdiHSlDYsn7XqPKToClEHMy5zoDFEPyLJjSvdzLyaArv3nlVSsphdgme1mIU9cms+htk4zOfKmvbOQdNUyqfa4KEw39SOBb0aWVkIIfjqJsOZi72R9QM1XzprskpLXJocRMiOZkd7dVWQ412TKZCqKQ4nt/Rku1yZP+eb5pkyyPXRs0K/bKd3tLZ+9jyZn0nX8+BQfbBcGphomXC+ah6rx1kdVqOibLOQXkYthQs+6ucboHpf7wa1WjCqXizWPqeKX4TZannLhGetsrFoB7B0I2xIFTJBMzAUVuCdQk9I4xMgi9E2EctSeY9S74y6OhoLx7OnpbFbLV9x1t58j7DVSwjMMPl9HeImsyF62Y81VOhTvzPW6tsVJR1tBHc59rcJGY
 tlncCGoF
 XTKTs2Cox1nGSHeOZv7VL6IsyFqCYib75SwjZnMnY8PB/CJwhevHTOSUoTmEMKtYa8z5qAo2URZz+kYn19l8P9DNrUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before enabling sheaves for all caches (with automatically determined
capacity), their enablement should no longer prevent merging of caches.
Limit this merge prevention only to caches that were created with a
specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 52591d9c04f3..54c17dc6d5ec 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -163,9 +163,6 @@ int slab_unmergeable(struct kmem_cache *s)
 		return 1;
 #endif
 
-	if (s->cpu_sheaves)
-		return 1;
-
 	/*
 	 * We may have set a slab to be unmergeable during bootstrap.
 	 */
@@ -190,9 +187,6 @@ static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
 		return NULL;
 
-	if (args->sheaf_capacity)
-		return NULL;
-
 	flags = kmem_cache_flags(flags, name);
 
 	if (flags & SLAB_NEVER_MERGE)
@@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 	flags &= ~SLAB_DEBUG_FLAGS;
 #endif
 
+	/*
+	 * Caches with specific capacity are special enough. It's simpler to
+	 * make them unmergeable.
+	 */
+	if (args->sheaf_capacity)
+		flags |= SLAB_NO_MERGE;
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, object_size);

-- 
2.52.0


