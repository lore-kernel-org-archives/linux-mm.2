Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E20FCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB3E8E0035; Thu, 23 Oct 2025 09:53:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6AF28E0002; Thu, 23 Oct 2025 09:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9337A8E0035; Thu, 23 Oct 2025 09:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1708E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3143B140B22
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:30 +0000 (UTC)
X-FDA: 84029521380.24.E5A6BDC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5C03140004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227608; a=rsa-sha256;
	cv=none;
	b=11XaRa+MH5o4c7CHjv4klRpIkwq/SLbrfQRzHAtuP04UjzIWxBsu4LnNOFFxuJeEkgcsPj
	BjS6zD4B4mAellbSbrjEfCcga1qdL1CG/vpBu+A0Hnl136gVLkzcjO98qoDANwPlE0HKyH
	k5/Mbp8LDRwQfBYb9W8EZtgnZ7Gz+Po=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrlFHykmUtdWxWD3YL+aFPlZh2N+eP7cnHN9uFKsaCA=;
	b=8EjsDZ81/xJZAavMBKwCobbiS9ql/TwiTlz6QYGlWbsUNKmrIYmGcbHLO3wozP+ppRctyw
	r56tTEX+PG+Nqt6VrNip5Tq3TOITuybUweNBQS1kRRrylWE0bS10pIs9up6eoZT48kXSZw
	MvQpZ+uck/KWMM7Ip+ANvYPzU4lTwIM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA61721279;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED1B413B11;
	Thu, 23 Oct 2025 13:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OMeeOTYz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:41 +0200
Subject: [PATCH RFC 19/19] slab: remove frozen slab checks from
 __slab_free()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-19-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
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
X-Rspam-User: 
X-Stat-Signature: j9cdbysuhk9ecsffy9fe6dr1p1uegkyd
X-Rspamd-Queue-Id: D5C03140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761227607-354111
X-HE-Meta: U2FsdGVkX19HzsAAly0notaTjDulGMRXtPIOKa4tfrGfrasNifPIf0D3DN2/buC6aluwAYLCKhnT2dJGwiHvVn4JKGaIGo3lOYLBGw/SjD/P+ACzF6M3iXV1JLOFT5fmQgKSOAOmfXzhkhDkvURLO1N3VRbtSlKO7L0y+MKgFDOvSbZDU7AFYYWGMlidpGXVRPNVf7HJJL9JeaoGndrQP4hmJXAPoDy8QGVVquCDmAkPS5vr3aMxjq5Bil6uHAsZpJsgF0zyzP+TKx4xDOFVe6VEDB1JyMnsCO+4IHZbfYsnGm6zU/0pZUm72GuFem6sQWne61OowXjDRFSCh+H7Z5Av5a/THpuH08ntWX71AXrS9nTMV6PJ0o6QzvvIq5HJYHnKL+n4Y8RKEQzR8KHcDeGLZK7zVjtOEsLbcJXs/LR45iClXG5pnNfywsQ2/lHna29dWnAcr20UO64NbwnYZRtVPKqE1a+f3OxbFrx1ttLhZQ4xbbtRdpi4quv693pMhsjehd0SoWMsw5aNz5i0recvUSUatpnvjk0DZBiH9H4v2SmyJtHFrVdujrBZANw2nhgaQAVq7ycF/pmcZxacezm0oFmnhpDqIx7kUwfuRsB92tVzZPu29QspF8CELpPTMJjqgkNJ/PTd/JDbmqmmjTQM7+f5wXwWDe1ywQhiCJnav1neZvIRtnS8BnFcMjM8dOxQZxDWu9PKxQdh0b8VtWVXe9H43G76ekQvOKBs3e45Ayz6l6AhBD68oaWltJ7OSvWyikilrZtcOtCL09vSIBHbq6IjimRHD60D3pNW3SDmXju0DJoZD654lRd4feuYPwyzONKfJruspip2IOfWsXoh6mZzzZYrXROMOENCNDqh8POPwrGd8oCzynGTMZIP+ClqgZDozlzhFcqb0QSwo4tpHlrsoH32Cegn0tCH5NhsuncIc/1baibjYTvR0rZVuokGYGEgCTjSw09ZkRF
 qcaOHsKk
 migrefZUeu+exmcqmOzduGdqVTG4BM7N+AexSD6bS04rZ+ZJUs8mHKnk6gB+JkihxMfzobSZMCvI3hdukiAv7FQbbqPjAF6PEtNMCB4EBBeRrpN+tb/EMoB9AWTrjTBQe5kgv+AvJOkOADJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently slabs are only frozen after consistency checks failed. This
can happen only in caches with debugging enabled, and those use
free_to_partial_list() for freeing. The non-debug operation of
__slab_free() can thus stop considering the frozen field, and we can
remove the FREE_FROZEN stat.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 515a2b59cb52..9b551c48c2eb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -336,7 +336,6 @@ enum stat_item {
 	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
 	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
-	FREE_FROZEN,		/* Freeing to frozen slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
 	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
 	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from node partial list */
@@ -5036,7 +5035,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 
 {
 	void *prior;
-	int was_frozen;
 	struct slab new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
@@ -5059,9 +5057,8 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		counters = slab->counters;
 		set_freepointer(s, tail, prior);
 		new.counters = counters;
-		was_frozen = new.frozen;
 		new.inuse -= cnt;
-		if ((!new.inuse || !prior) && !was_frozen) {
+		if (!new.inuse || !prior) {
 			/* Needs to be taken off a list */
 			n = get_node(s, slab_nid(slab));
 			/*
@@ -5083,15 +5080,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		"__slab_free"));
 
 	if (likely(!n)) {
-
-		if (likely(was_frozen)) {
-			/*
-			 * The list lock was not taken therefore no list
-			 * activity can be necessary.
-			 */
-			stat(s, FREE_FROZEN);
-		}
-
+		/*
+		 * The list lock was not taken therefore no list activity can be
+		 * necessary.
+		 */
 		return;
 	}
 
@@ -8648,7 +8640,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
-STAT_ATTR(FREE_FROZEN, free_frozen);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
@@ -8753,7 +8744,6 @@ static struct attribute *slab_attrs[] = {
 	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
-	&free_frozen_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
 	&alloc_from_partial_attr.attr,

-- 
2.51.1


