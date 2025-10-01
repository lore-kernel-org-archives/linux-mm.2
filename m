Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F80CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722B98E0007; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3AC8E0002; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1988E0008; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A59D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1018E1A01DF
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:30 +0000 (UTC)
X-FDA: 83950300140.17.4A3290E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D0C4140003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JQDFI9If;
	spf=pass (imf09.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJLopUjdg6abKCdBvFBz2DgGEx0e5f4MfKDCPhNtEqM=;
	b=PVMsziNNc8JA/b/f3fUmE3uPZPBBDVVSZryJ1NZV9bpBNdTWvjiL+0QgN08866mxCgM5ol
	vK3xJZgqnSIwC9kS6jnggUqAwM8WdHhaTUkB+0Ku9ufLAxfyAVAIsjxxG9THCQjGrzImTi
	YDlfvhD/2KaK8lEmVvYfrV9eVg6iVK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341388; a=rsa-sha256;
	cv=none;
	b=l7pPFGEhgbB+HOOg2rK4DzxYXEvNhATyL6lFTVKr1Kyx5ruzCIcAPLn54PgkRYseMKNx99
	kCH+yG42Grh9lGAuCOBwkuGRiUTZTDv07CJoZDIK06PZYpi1xpWQuYvGSMtUxkBMinNHD6
	O6uBQnO9HEF0MDOcXn8NW6zzfRuZd9o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JQDFI9If;
	spf=pass (imf09.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aJLopUjdg6abKCdBvFBz2DgGEx0e5f4MfKDCPhNtEqM=; b=JQDFI9IfVzCldlJpfK4bDQaE2h
	QPZss9dMFj0eA7iTfB27+w6qVnSPeygo5lxNEtyUrgPhoiaOlidBrxoosMvgoF3FO/bI2rtzmdfip
	3udzdqkBWoOX/Y+ZMYGBGH2DwwYHgA5zlhvSEtFEzfGf/cMc/tJfbtv6bWWGvimPOFA7Kz5NV5AdK
	CxDZx7EX7SLzc8HPsfwez15Np4eY4ZG9wPb7wVKCP1RVEyWxtzXu9Wzk+LQ25EvOl0vf/0pJ3N6tZ
	VP2qp4U09BusUl12XBDA1JMhjkfyIK3S8x9Gw0HLPq5bJPNkNuW6Kmjz+Kvs8Fu1PsZKx0+ejvSk8
	3HZjscww==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v413v-002xd4-Lk; Wed, 01 Oct 2025 19:56:24 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 1/5] mm/page_owner: introduce struct stack_print_ctx
Date: Wed,  1 Oct 2025 14:56:07 -0300
Message-ID: <20251001175611.575861-2-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D0C4140003
X-Stat-Signature: 7n7au5s5yxm34r7s4zagyzsan315ju73
X-Rspam-User: 
X-HE-Tag: 1759341388-44557
X-HE-Meta: U2FsdGVkX1+Vb/RDiFEHH7ZiS7plrmdrkoVeIMjiZ+RVlEicwYybEw3HEsSPfgl3aucaQqagdJ+uJo80i0YkO+kOZzMhLs0r12zMeHWhcfNGdXcahrl8aXwShwc51Ub/x0/BI63xkaqg4VdHaJBpfNJ8OvYOxpnM6Dol96tTBKOp8ask8soHOAd0R4fbUGyorR3KqFwouhyxi6uRhvftC1hFfmKWJJ+aRmnNI0lF2/2xMQapVD1zfZycsL/lJICGr7JWulw1LuxoiNXWTW5mQSUGQlDx8d4QsKyGp7DtWY2SLV5gVCtuYAl37CRwggNRogFOAEW9xY3AW+cEz6ZjI0GdNVpcxqWMEhs2t+VuRITiuvi+TpC1KxeIy/GuhjVdilesxuOjgGxNJ5poLG96Z8ucUHz4RqbWKqjZ8GiCkqnhebcrYhYEQf9O+mdmMrCmx+dAXcW0Qe0IZcBlXbFSygCvTCCsd2Ih7Mn49znV8Dl+4V2w30VYr4ANpPY4xQhqMkRsXNtb3KfEi7DhNzRqoDjB2PqCbVsEBpkeQm6tsEIpAaW1HzYtyVyniY/AgHLCDv9WMEMEMhULwwsveuxKbGpW3/VYeHimSZ09TwWxX/JnhoVHHPOqHEWdvIUXvj8Rd/tUN3U9zrFymO6jCPLo+DaHhXaYhxN104X8epWRib6u7tjjaHaE1KVc70d+QgM25Wy2beg3QnbowMIGfLxzWRA9HG494S2qVPcIGGaTnI9/qI2NfN60hQ06FaG5fKi1Y6p9ac5kk4npXubjNRvg4ZIhvznITJ4RJ8rHgahtP2ZYQo/3RS+Lhj87keApwo3CG2ZUDNh85/BgH7NWqYvwEOUEYVDIfC8Yc3W165/24lQFF9grLKOnUZkkyHOxwlZd6XE4Zg53CN20OWT2b+w253QhWobqKFG13ip8s6HJQ4b+W+j2hbMNV0Qh7Nj7XFyJuNb9eIbkqebyMn0ZeeZ
 eysBvtn/
 ujjTC1UJEBWFZOPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, struct seq_file.private is used as an iterator in stack_list
by stack_start|next(), for stack_print().

Create a context struct for this, in order to add another field next.

No behavior change intended.

P.S.: page_owner_stack_open() is expanded with separate statements for
variable definition and return just in preparation for the next patch.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c3ca21132c2c..c1a7d7afe945 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -45,6 +45,10 @@ static struct stack failure_stack;
 static struct stack *stack_list;
 static DEFINE_SPINLOCK(stack_list_lock);
 
+struct stack_print_ctx {
+	struct stack *stack;
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -856,6 +860,7 @@ static const struct file_operations proc_page_owner_operations = {
 static void *stack_start(struct seq_file *m, loff_t *ppos)
 {
 	struct stack *stack;
+	struct stack_print_ctx *ctx = m->private;
 
 	if (*ppos == -1UL)
 		return NULL;
@@ -867,9 +872,9 @@ static void *stack_start(struct seq_file *m, loff_t *ppos)
 		 * value of stack_list.
 		 */
 		stack = smp_load_acquire(&stack_list);
-		m->private = stack;
+		ctx->stack = stack;
 	} else {
-		stack = m->private;
+		stack = ctx->stack;
 	}
 
 	return stack;
@@ -878,10 +883,11 @@ static void *stack_start(struct seq_file *m, loff_t *ppos)
 static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
 {
 	struct stack *stack = v;
+	struct stack_print_ctx *ctx = m->private;
 
 	stack = stack->next;
 	*ppos = stack ? *ppos + 1 : -1UL;
-	m->private = stack;
+	ctx->stack = stack;
 
 	return stack;
 }
@@ -926,7 +932,10 @@ static const struct seq_operations page_owner_stack_op = {
 
 static int page_owner_stack_open(struct inode *inode, struct file *file)
 {
-	return seq_open_private(file, &page_owner_stack_op, 0);
+	int ret = seq_open_private(file, &page_owner_stack_op,
+				   sizeof(struct stack_print_ctx));
+
+	return ret;
 }
 
 static const struct file_operations page_owner_stack_operations = {
-- 
2.48.1


