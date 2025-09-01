Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02118CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612648E003C; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C28F8E003B; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9118E003C; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2A08E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF17413AD1E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:15 +0000 (UTC)
X-FDA: 83840409870.08.AB4B850
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8B942000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY0138kq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KhLG1iam;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY0138kq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KhLG1iam;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8oRFcilmtndVzdHD+w9Znk922NjHNSPX4NFgV/7dew=;
	b=8XlgZKjuD6tJCbwtHp3MhnKn3uUzU/EGh/fZtaZJIxq69GXPWv7EdMXQcWIkT7SLaed7TW
	H0EB2/iopHsKZkHSvfPgnS7INgdYLhGnDC5OqHnw01pOuLM9zAtTTV1wxw+29ByV6b8UHB
	3moFOS26Ka9vtMKph7+rLZ9jiFxEJw0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY0138kq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KhLG1iam;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SY0138kq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KhLG1iam;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724954; a=rsa-sha256;
	cv=none;
	b=pfwPhZdi+/wZb3GIPlu4GoQ2wOA/0lpl4a78lF3izzOmuPOZQt8AH+H5aEIkERv+MGR3jk
	3sZF84GwOwA+DtLKOC/Ak3XHIShf6pH9pyTvyRStMGtd1bRLBHdkcHsyj3S7UkGVNe3Pq0
	eDUPU5WVUOT0ejpIJW6Zowx98R6akOo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9B2F121175;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8oRFcilmtndVzdHD+w9Znk922NjHNSPX4NFgV/7dew=;
	b=SY0138kqKl2jJSZVy/q1nixHUQLdDCivifvAbvYeRaYbrQxn9fMuANMGGktM37lJJpVMAX
	q0dtx//6JNCvIN+U16+DdWFD0kfvUydWcWy85FGg4AEQboPWw1mDhXx3iXj9dEOpzeceYR
	wTO12jqPSb+CdQlRAnGv+Yqu2SaLVY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8oRFcilmtndVzdHD+w9Znk922NjHNSPX4NFgV/7dew=;
	b=KhLG1iamkBax+Zxkkl4j8GGek1stlQa1ZBXazOBWDh5BQGF5JwoVHrhdVjyxKnx6OnX6OE
	quAxyiHgfslZxhDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8oRFcilmtndVzdHD+w9Znk922NjHNSPX4NFgV/7dew=;
	b=SY0138kqKl2jJSZVy/q1nixHUQLdDCivifvAbvYeRaYbrQxn9fMuANMGGktM37lJJpVMAX
	q0dtx//6JNCvIN+U16+DdWFD0kfvUydWcWy85FGg4AEQboPWw1mDhXx3iXj9dEOpzeceYR
	wTO12jqPSb+CdQlRAnGv+Yqu2SaLVY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8oRFcilmtndVzdHD+w9Znk922NjHNSPX4NFgV/7dew=;
	b=KhLG1iamkBax+Zxkkl4j8GGek1stlQa1ZBXazOBWDh5BQGF5JwoVHrhdVjyxKnx6OnX6OE
	quAxyiHgfslZxhDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8559013A31;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OBGIMV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:56 +0200
Subject: [PATCH 06/12] testing/radix-tree/maple: Hack around kfree_rcu not
 existing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-6-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8B942000F
X-Stat-Signature: h6cqqgbey1nu3te3yskj9xryxnzuf98y
X-Rspam-User: 
X-HE-Tag: 1756724953-922140
X-HE-Meta: U2FsdGVkX19oWpMjVX5MeVf17QoTopCKcSilwyU8YOqCZpSP43I99Rysw1oM5T+I8TwtlA4929NRN4CNlxnQksfz2yiWYWTEyR93H+us9OOmnE9XxcFx5E2COegy9iof00kfrpIiMGE7xNgmP0pk3pXKOnbPU1CspwpBow/xUe3rDtwIipY77VZ3rx8aAFOgpl9wdXU/gofg/flHIs8wwh2QHJSiNFDgTzzCz8SyDQshGtM9614bU2wZjLPvzXu8zsR4zeWhYPc5039VUv/xHGlr5aPpdOtbR9fE5fJVckkxunfdq0l3KFYYL7Ks0HxDQrfzwHQfK976/olOOM5HksoeVCIur8LTcqHowTKNa4luqaX/Rfs9R2YtKiET4qg/QGncIsp1Hs0y0Q3mYq/UTkGYofsyLfVlPA4HoN8eLjvu6jmhGJwnbmoOOURiQftdS7Iviq/eZsABRxDVr+6qBqV5AdtotGUCQ14KRxxxR+ewuq3FMg0OOczuSRSATIxZRcqXXLL7T3F/j82ioFNGcG4VVL2JB0jgM7hr/vaue93y+4L3t966URqjnhzjaPAmrJ+LQXVk/1UfXcyR9JZntCPoRu4ScoLk0mjvi2l58gPPBTHQPBkQAfq2a+tCE9qavTkFfXG99jbR1il1Sv7DzAvZhVBcjM5SiZ+lS4xsT7he71drezlpEF8hoqWA/Qfflucmwp9GoFQcImHpKZc+VNBsEmRpqVPKv12fG3Oes/Vvg6xABXIEkqttPsZEtFTfilmsXj57TTn5mde8hClugo9R13P4wa8aF7xqUFwwep5p+Q/KinYU04VhaCx8H1xBzZutmc7vhOwwcXGnD7OQQkqPGoEx1D9juqLl6gk8NuKfuSGvOp6osmQSpt5yq1VyVz7jo0UVGVGKVcm3G7H6BlvvpvdUWnuUhmSmukEPbv0f7zhACtSbl7e4QrioyQvYxaicVoodJVVbrrdj0bQ
 S3l4TXy9
 2MVwnH33mtaPrAaHMvN7D5NcDYIQCCGMyXfeKRK9dCB6gGFK6p4sm3WWYhYimBSE/bHNAIJJLQv6hsHc+RYWHO3aImny5/M0kXvoJ6KLLGD5Zq9KyWaW7G3TGR3ihNbD5g9AAF6aVr5xxumhijHhtWOYhDa9r+OYq7SiEADhRrv1Ys2eGbF43baDfrzr0ZFGnot8HJsDQwFUC11jMrPmtFjZSDSlkLvY6Ax5aplRpxx21WYgu48gvSCr4OYNNPSFd4UzV8hw5TTGNptdLdij4tW5hwJOfN/LMe0fydFZYP8KVhxZlLfomkTTZJqDmtVcWZ+UNT9cSQZsHuzqWG69Ac/plzNBQDa0FVk13
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
can hack around it in a trivial fashion, by adding a wrapper.

The wrapper only works for maple_nodes because we cannot get the
kmem_cache pointer any other way in the test code.

Link: https://lore.kernel.org/all/20250812162124.59417-1-pfalcato@suse.de/
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c    |  3 +--
 tools/testing/shared/maple-shared.h | 11 +++++++++++
 tools/testing/shared/maple-shim.c   |  6 ++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 18db97a916f039bf72046c3ec3e7faffaeb5b755..7fe91f24849b35723ec6aadbe45ec7d2abedcc11 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -15,10 +15,9 @@
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
-#include "maple-shared.h"
 #include "test.h"
 
-#include "../../../lib/maple_tree.c"
+#include "../shared/maple-shim.c"
 #include "../../../lib/test_maple_tree.c"
 
 #define RCU_RANGE_COUNT 1000
diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index dc4d30f3860b9bd23b4177c7d7926ac686887815..2a1e9a8594a2834326cd9374738b2a2c7c3f9f7c 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -10,4 +10,15 @@
 #include <time.h>
 #include "linux/init.h"
 
+void maple_rcu_cb(struct rcu_head *head);
+#define rcu_cb		maple_rcu_cb
+
+#define kfree_rcu(_struct, _memb)		\
+do {                                            \
+    typeof(_struct) _p_struct = (_struct);      \
+                                                \
+    call_rcu(&((_p_struct)->_memb), rcu_cb);    \
+} while(0);
+
+
 #endif /* __MAPLE_SHARED_H__ */
diff --git a/tools/testing/shared/maple-shim.c b/tools/testing/shared/maple-shim.c
index 9d7b743415660305416e972fa75b56824211b0eb..16252ee616c0489c80490ff25b8d255427bf9fdc 100644
--- a/tools/testing/shared/maple-shim.c
+++ b/tools/testing/shared/maple-shim.c
@@ -6,3 +6,9 @@
 #include <linux/slab.h>
 
 #include "../../../lib/maple_tree.c"
+
+void maple_rcu_cb(struct rcu_head *head) {
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	kmem_cache_free(maple_node_cache, node);
+}

-- 
2.51.0


