Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50627CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23878E0015; Wed, 10 Sep 2025 04:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4B88E0002; Wed, 10 Sep 2025 04:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DDF8E0015; Wed, 10 Sep 2025 04:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B71BB8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B31711AD3E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:42 +0000 (UTC)
X-FDA: 83872596444.02.EB980DB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4632A100013
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XOJHhG2v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bhV8GnZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XOJHhG2v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bhV8GnZN;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjD49SbUXnEu+0JzrLTF+521Hhj3syJQd2OSJQchv9c=;
	b=oA3fHteR/Q/c3XVRY3gfpiSza8dfYjfNgP/0D1SqiIarJ0uYk4QV/WT8NQ/wx+tIkvqiIy
	1H6WKWTJbLltPaKt5JPCmg0qlt6LjydlC5a9HynWIDIYQ7CLniXbTzXXWLD55CzZ9p8F9D
	EOtnuAHywQ3DhRCAa6cbQhDwlW32d0Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XOJHhG2v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bhV8GnZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XOJHhG2v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bhV8GnZN;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491300; a=rsa-sha256;
	cv=none;
	b=4BIGm/ljQg5RtXNs+eSIY66j+clHEXcsAvqI1o4sYs0nJP8Kmef/ob4vDBRk3s+RSxBRqC
	bnxWOj0EBEQXhrMjdsJ3059nizhhUeLUSFcnovPyl9eYt/D8GIqjMHpxfO/h310wraJAnQ
	CwqYpyiQ4BRnl3SnqsV5dXOY1kYLpU4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52F8B34C65;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjD49SbUXnEu+0JzrLTF+521Hhj3syJQd2OSJQchv9c=;
	b=XOJHhG2vZC0MBDIR8MKa611bMkqdlds+kx5f2bVvAK7EafB0g36SkYhXp3kG8oqctrpgSV
	3M3EhLAgK6fqbyKh4Wq9YzldQn3iaG2tc7CXpjIPAlr3rQVNDOT0KH0cdLcWvU8Qdb0vk4
	wEGb4g3fR8/JvKoGU7VZM3eI7L3pjoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjD49SbUXnEu+0JzrLTF+521Hhj3syJQd2OSJQchv9c=;
	b=bhV8GnZNs78mOmK/I+PAZDXMSRDwlJbqkgYKgIw7ozPEpkoL2S+VIXoYn6D9VO0Yo1w2fo
	vR9SeuVIChwey9BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjD49SbUXnEu+0JzrLTF+521Hhj3syJQd2OSJQchv9c=;
	b=XOJHhG2vZC0MBDIR8MKa611bMkqdlds+kx5f2bVvAK7EafB0g36SkYhXp3kG8oqctrpgSV
	3M3EhLAgK6fqbyKh4Wq9YzldQn3iaG2tc7CXpjIPAlr3rQVNDOT0KH0cdLcWvU8Qdb0vk4
	wEGb4g3fR8/JvKoGU7VZM3eI7L3pjoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjD49SbUXnEu+0JzrLTF+521Hhj3syJQd2OSJQchv9c=;
	b=bhV8GnZNs78mOmK/I+PAZDXMSRDwlJbqkgYKgIw7ozPEpkoL2S+VIXoYn6D9VO0Yo1w2fo
	vR9SeuVIChwey9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1185313B06;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gK7/A0MwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:18 +0200
Subject: [PATCH v8 16/23] tools/testing: include maple-shim.c in maple.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-16-ca3099d8352c@suse.cz>
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
X-Rspamd-Queue-Id: 4632A100013
X-Stat-Signature: zzgqcb8z38x86tcxprozaar6i74w1554
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757491300-762119
X-HE-Meta: U2FsdGVkX18Lxp6zbX0MVIDN/hPvI92MzaLYH2H0y8suF0fkYEcUNLRwzQEVlZAjtdUM2lot0M/unaiX8oLGitEN7DgjL/eUQVtKUYaBNvMLpbxByBew8TcJr0XUVzmzHwQp3FMmBIWH9BdreNn0FhudFlyHCQ4UYgCNPRliD3vBNI+Fn1yMLK62mQ9GPKYKZklCQF6b2JERGVYMLP2isBlwPcRoc3zoyVQ5KEvkZBVV0Dfs9MEWAAdskGvVcaiuItWvlZS6/m0dtsSHY8/jS5jJj78TRurN9TakUbSsC89hgaYzI4htnqm5j24ASAQv6aOv7QXIjyHcm3Qw76DA8PZ4GvP2SVnU32kpkaltfn65bkhOr2v6W2ykd+zXbEpTxQzylOuInuc5h+FMvhRPl9yY5tLmwoozN6NK3HRo2xFmaZ6ODFtQwS7aCjxJbVUn7aFarMRa3y4ocBqhxK2/yMDKHLyOr7CiQeF65Oo8AzrNT9SLGsUKzGLokEQyvF2YAofBROTMSWrnr+VbamGKujXkZybF3QnBTtN3RK061VlMNjOfYKfUlA8zwLygEp0wzinWWDmbrd2XW9jX5zPURzkNqOPG7f2cg6EXPvXrhbCk3JRAP1hhz6JogwjttClGyVEKvFciLt6MqPvBucAH3Iu5kbUL2Ev4tYwr1SfnyFVC4aFi6WDtlbSn+XK8P/lt4V8R0qjBhI56mk/YnlGxOr2Y09sfXPPLXXAWvK3QnG+kzo0HPSOrkJwjQFVp9WCBSXWB5KbNAxn0F0AEwk1Cs9+6Hp3sx+7yFAsYxRsiQgEKgGm7oycnYHxVOr3if9HLlgV+LZzcnklZnMNXOCzbWKRLZP5nqXXY5cOtLQM4aEQC1+g2DGbT9APNlDcwWrPj0txuuDqK2yIFhpkW/F22YR9tdMk2q9PGuqDuehrTEE6HOXtIuKOtNH0YnjxCW8ZfuzfTNev0alTKchahC1U
 Hiy8yEoO
 m4KTPzLvyK9ubX6w2PxavRaQs8mgsJ9Wswy+VYL2G6mT7ofuz1K+Y7YnTJJ0SPYR6q4J8GIvIqusCItjpkKYY/7DorPk+y/RjNrT+hUfI6MGUOV8KhKfVPSXzJIV+VsH2D7HyCiEbvgmyGNhqMZ3aD8NBymGGXgI8zjlf2SHZSzTnhln80Cu/g5FotY958bqP0JwYub1+SdB9XaMUbxYt9OESrcA2ytirE8qTHH2mkWlUiAwd2nGA6nuIBnYNXbWu9jYxBY+CGSUsvTG4a/r92A1IwdC/QzFJsrzvCN7qmNZ+m2dhuMEpjk2Whg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's some duplicated code and we are about to add more functionality
in maple-shared.h that we will need in the userspace maple test to be
available, so include it via maple-shim.c

Co-developed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index c0543060dae2510477963331fb0ccdffd78ea965..4a35e1e7c64b7ce347cbd1693beeaacb0c4c330e 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -8,14 +8,6 @@
  * difficult to handle in kernel tests.
  */
 
-#define CONFIG_DEBUG_MAPLE_TREE
-#define CONFIG_MAPLE_SEARCH
-#define MAPLE_32BIT (MAPLE_NODE_SLOTS > 31)
-#include "test.h"
-#include <stdlib.h>
-#include <time.h>
-#include <linux/init.h>
-
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
@@ -23,7 +15,9 @@
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
-#include "../../../lib/maple_tree.c"
+#include "test.h"
+
+#include "../shared/maple-shim.c"
 #include "../../../lib/test_maple_tree.c"
 
 #define RCU_RANGE_COUNT 1000

-- 
2.51.0


