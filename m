Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94FBC83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3636B00CC; Wed, 23 Jul 2025 09:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36766B00CF; Wed, 23 Jul 2025 09:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5E36B00CD; Wed, 23 Jul 2025 09:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784C66B00CB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 165491DA7A0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:08 +0000 (UTC)
X-FDA: 83695625496.05.19B48A7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id E191C14000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLuWcep7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TuOmiLe9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLuWcep7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TuOmiLe9;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n76T5/oLzAKLG/4h3bNpBYSlkM7GH6lXo34OEj/xIig=;
	b=ae9FcFScVJGJTsUrLw6i4fpfG89HwdGJqrKNrfQfNc9pF1cFqhhsif7y6SlAIGtJqmsAtl
	JbY3vQ96XkC+VrM1Nqh/YCW+lhuO3FCkd4Vkq4bKaOBY20/+lyLhSvq6h59wnjkpty72Z6
	kghp52wjz0p9ZOo3K60EDoF/LjyrKEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277706; a=rsa-sha256;
	cv=none;
	b=TdSplyCAWhW6a1J3m5OKOQD6ggNgnWTbNo4BCDX5NVuHxi+x2BMyh0sEDeTx8+UC/DJeIn
	JXfBVJob+zBIQf+0cWzSCej4xQTE1tQp9Jmg/owUhwDC4YoTuaayLdi5wYecy4fwQ3F22e
	Zdl7I3GbioLSxeVCJwJyA8BkEtIqVPg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLuWcep7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TuOmiLe9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLuWcep7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TuOmiLe9;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 684A921748;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n76T5/oLzAKLG/4h3bNpBYSlkM7GH6lXo34OEj/xIig=;
	b=jLuWcep7wvOrM9VfLFU5V7n3h8HO8EdEtMwkILNwBO9fDXDmtD3gUZmxaQDHXaRr0gHOTN
	NoCSvbIy5xzO1RB8xzGSgoKOx0Ic0DgCOYUvQAA3wmqekIAVPV8FtEkxD5usGoxpj+cswT
	JZhwSs9Rp+QZ3U5zQEj4Z9exJh8AXrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n76T5/oLzAKLG/4h3bNpBYSlkM7GH6lXo34OEj/xIig=;
	b=TuOmiLe99Wx9WUds4G4PNGnxwGj5KiApUUhPYuk3GLSl+bKCYO0kBewqM5VVUfyH9XWHhi
	wMuhr1lKd6hTWWCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n76T5/oLzAKLG/4h3bNpBYSlkM7GH6lXo34OEj/xIig=;
	b=jLuWcep7wvOrM9VfLFU5V7n3h8HO8EdEtMwkILNwBO9fDXDmtD3gUZmxaQDHXaRr0gHOTN
	NoCSvbIy5xzO1RB8xzGSgoKOx0Ic0DgCOYUvQAA3wmqekIAVPV8FtEkxD5usGoxpj+cswT
	JZhwSs9Rp+QZ3U5zQEj4Z9exJh8AXrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n76T5/oLzAKLG/4h3bNpBYSlkM7GH6lXo34OEj/xIig=;
	b=TuOmiLe99Wx9WUds4G4PNGnxwGj5KiApUUhPYuk3GLSl+bKCYO0kBewqM5VVUfyH9XWHhi
	wMuhr1lKd6hTWWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5369E13AF2;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QK0XFAjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:40 +0200
Subject: [PATCH v5 07/14] maple_tree: use percpu sheaves for
 maple_node_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-7-b792cd830f5d@suse.cz>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E191C14000A
X-Stat-Signature: siw1qmia6qgmbzybrnaf96rpau966ij1
X-Rspam-User: 
X-HE-Tag: 1753277705-734729
X-HE-Meta: U2FsdGVkX1+kUXyadmZHmq3tGVU/qVZyM5lj2f0pWrI+JAegrjpLIzmC8W3aildunVShlXUM48VbDiL+O4HoPpxHiu0huKAt7oRfZ1y2jnZw10wk3H2Brr3Per+/Hbjf3l9VAOvhxKmqwvXn2KUlpCASROgDFztvU1a3VD1wgystwMcIfQ8V+KtqL1GlI0ZVv+4BTURUnSyYUprjE7CZqkWUiVjObEMJnmS8P/2E43Tva9bmCb1t9wDhhaRz601ThtsGpkP2pd7rCx91IYDUp5bY2VU2e/dLgB1KlPfsPbQrd7xwQkjrURJL5wqOWIrHpEkvmb9CS8BTpHOVyH2b88qYQoTbuyMYQKFJ9mpEUaeqmcQ0zSiQ8IQQFFpt/c1rJ/3IbQ96Cn0WJqsQrt0/SG3bJjuQbLJLtBHXpNYisDCAfC57IIiTMg56npSNo3U9sWoM3zqN/tLwQsykQhjo4+KVXQ5ph4ls2U7pPyBn1+vjMmKtr0WVluWCjQ4FLcVpmTovp+Wz6DC2e1yiV8sTS9tM4zJ0G23bGAJXJBjN+1oI4i10oCu8gQNrxbcSQICCZRxPeWS6zxkhITDB70lcZBYh/Rlq7UtK+dyDEcyZC7GXWZnPT01c2hqtzvSMVWpgetGokuNVPpZmgKseA3CC2H2322R7nbFBOeCieu4/ZtiAdNNN73qDlWoF7Ydcp7/CCSs1YW3MlgzbgJnI61+RlzULgVUIEhjCTAnpkhl6ZrPiQh/HidybVOa4LqfnWmdrCLDO1zg2SnENi+yaZoT8x521VILd9I8A3aIxihpn0zB7YzC9mNbjbH600KSULbc3ppZMbp1njHSd6/6+ngYOoZPElBl34pFaBSUyCc0d7Pvqv6SebppTDWpeJ7NUg5UhC7KK+yxv0u5HXjgcCQtzTAuntqb1RtCKq7JiV0eRDWkjTjvmtZCrlWW8vgAkowkxoeLOs+5YVSIME6DsJW9
 hP/xJDXE
 XSNLEQsEHll+KnrZvOZruzmoDKues8PiwEjR2vcP38SNxukaHie2tTXxTMIDk9dgv8LBERszl/a9QRG2CW+dIxxVaEsNWLnhRXRJjdZ2gzcViYe48qrszT752GqsvSCCuh+2qRX/oGuiSy92CQezLnCedprLdH02daxSWVgguUItoLm7dflPQ8RJrmYTap5YEdVyJSfWR4YZPEzgVQnZAq6U5TfwxZF6eSJTxD1ZlnKuYtnppZUOstgQ7+UhFaCzjqxRTOSDzX78KkKyczNsur1tR9qBYhAGIl0fpvLfcmZdnoVfop6VgmCWg+NSRN2hqsPP8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
improve its performance. Change the single node rcu freeing in
ma_free_rcu() to use kfree_rcu() instead of the custom callback, which
allows the rcu_free sheaf batching to be used. Note there are other
users of mt_free_rcu() where larger parts of maple tree are submitted to
call_rcu() as a whole, and that cannot use the rcu_free sheaf. But it's
still possible for maple nodes freed this way to be reused via the barn,
even if only some cpus are allowed to process rcu callbacks.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/maple_tree.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index affe979bd14d30b96f8e012ff03dfd2fda6eec0b..82f39fe29a462aa3c779789a28efdd6cdef64c79 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -208,7 +208,7 @@ static void mt_free_rcu(struct rcu_head *head)
 static void ma_free_rcu(struct maple_node *node)
 {
 	WARN_ON(node->parent != ma_parent_ptr(node));
-	call_rcu(&node->rcu, mt_free_rcu);
+	kfree_rcu(node, rcu);
 }
 
 static void mt_set_height(struct maple_tree *mt, unsigned char height)
@@ -6285,9 +6285,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
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
2.50.1


