Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4CF6CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D798E0020; Wed,  3 Sep 2025 09:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8768E001A; Wed,  3 Sep 2025 09:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0928E0020; Wed,  3 Sep 2025 09:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2A638E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81E7159D81
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:19 +0000 (UTC)
X-FDA: 83847949878.11.0BEF5C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 64AFA1C0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UpE5aYpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yG8ZP+1F;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UpE5aYpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yG8ZP+1F;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL+qCDJGk4s8FKjAhsD7S3UX8bYd+2rVoRHmfBRAuDU=;
	b=o0r5NIr24evsPSzfNX3Wc5oU/jZbbJnhjSlqRvMFZpXHNp6AO0VGvB09k4ZEVBRi/ykjXs
	dMg6WAdI8P95/QoU/EtrgrMhc6HwARM8oqwABb9cVO6E4EqhOmmXnHlit/0E98T4bz/UfI
	H2jh876Z2yJubjDOTm9YBWhOXyUy4wU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UpE5aYpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yG8ZP+1F;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UpE5aYpx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yG8ZP+1F;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904477; a=rsa-sha256;
	cv=none;
	b=eHXYJ2Fwg2eima+IgMySP7s/vMGI/iH6iQuf5rFhr1i1goItbX6XA1of1kp5ENJ1mkpPc7
	Y+pUK39HexMLcPfDDDl2PBin8iWD8awzxyFbxFz60NkVsTAQ2vPuT2oHpneFTrFDhquAHW
	gOIiikLBpx6ZcoMVmovhTR25MoSNeRg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4CB52122B;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sL+qCDJGk4s8FKjAhsD7S3UX8bYd+2rVoRHmfBRAuDU=;
	b=UpE5aYpxnGAKCt1S0hrkBGoX0L860Cndg8O68gwLbljC5cpsm/uC7eKulYMEDJBOkwSt2e
	53g0APA9BXG6d149lzRi8S4oovaympDBz+GmQgHUqH4qkHbBotvbKmp05sxz6ERVZxUlJA
	0kZ/p2X06oWqU7MOOQIsmqhzAQ4oCkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sL+qCDJGk4s8FKjAhsD7S3UX8bYd+2rVoRHmfBRAuDU=;
	b=yG8ZP+1Fyl9iMw/IHXxgYX7BycvqdDO7RoSq2Beb8b1hmkpVGljEWuqK/WkC+IDrWxnFM+
	7najWcdnMm7jqWCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sL+qCDJGk4s8FKjAhsD7S3UX8bYd+2rVoRHmfBRAuDU=;
	b=UpE5aYpxnGAKCt1S0hrkBGoX0L860Cndg8O68gwLbljC5cpsm/uC7eKulYMEDJBOkwSt2e
	53g0APA9BXG6d149lzRi8S4oovaympDBz+GmQgHUqH4qkHbBotvbKmp05sxz6ERVZxUlJA
	0kZ/p2X06oWqU7MOOQIsmqhzAQ4oCkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sL+qCDJGk4s8FKjAhsD7S3UX8bYd+2rVoRHmfBRAuDU=;
	b=yG8ZP+1Fyl9iMw/IHXxgYX7BycvqdDO7RoSq2Beb8b1hmkpVGljEWuqK/WkC+IDrWxnFM+
	7najWcdnMm7jqWCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D9A913B07;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8BjFDto7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:56 +0200
Subject: [PATCH v7 14/21] tools/testing: include maple-shim.c in maple.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-14-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
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
X-Rspamd-Queue-Id: 64AFA1C0013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nax5qroj67bgayteuzejjpu34iiy8jf5
X-HE-Tag: 1756904477-416503
X-HE-Meta: U2FsdGVkX1/wtmRvB3JBRcfkqgKy4sadmGBVKGjoRSR3snM0ccB5bXiIihM0xNTtLvR+4ENCD655wNRtFlNXyonNmjwudf2DqaEXQ9ycQFv2aW+zkFOdYN+Fwk5RcMvSQ8tnOF7FUoskKPYbzaX9UvZ54z/cK+d5neW/p7wboVyNmU7Eb2ZBvfBMJlRXVTTdeNxokAnAdFgBJJpHC77fXzueMzyKOj/RVkB1Yr7ZcaBOqeodwWYhQ8SPMrVuVjDqhy7AyuJS18xT9ijJ7qVLK+wvgI8PRSA14SJxkFRWcTFIGSRToZj8C6sQOv17W4NZte1/J7P9A4kZ0GynpMVKzkblEDnQ3N2ThNmte2yPhZ4WzIUYSzOoMkFeP8KSWRKHo4xMp94D/0CVmVcKEbbHmUkaaJHVGw3z5S43Gz1dw5nP/E41t3WywMLNVIOYDRuxaPRp4Yis6GXMH2KJFcJWLuAJ/DeXllrPRhSEjIAn0q1VruPksXXtRHYvkrFFYsc/ATYstRsfnMWH/0pjRb1FliwSpzzHttJgzs/BdwUJV1PyjwIqxt1DABx0DNt2ZYOF8AvAR4ZtkDudRUUg0MxGk+FaKVfalYJg5FV6N+5w5zXgsom5iTpItr9+vn+2JAsiHj54G9g+5bUW5PaUaAofJ6RB/YvkvxuSfdHCZuy8fjh22jItKW8BkJvcEEYG0QhGWzm6n3RmJ/RqKDnlKzmg8kdx44ea2dwjxnAolDM89eB4Dh5LeGYfJ94OUOTwPEAlJEks4H1LLe38Nk6SVTJcX+PMc07yc3uv4LG4NfoPJBW6by3N9OPH7IyxqjUQnBitnc55/iPZEXPy6PoilekTBbzmUwLmaRyEvJvoD8X5f3yC/d+gpbRvnEY0u6JopPawglOQ69dvnmYCoJBZ8C3LUQ==
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
index 159d5307b30a4b37e6cf2941848b8718e1b891d9..7fe91f24849b35723ec6aadbe45ec7d2abedcc11 100644
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


