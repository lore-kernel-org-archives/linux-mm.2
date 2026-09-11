Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FD1C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27316B0099; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8206B009B; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED686B009D; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A31AF6B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 311C4120153
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:15 +0000 (UTC)
X-FDA: 85200864630.24.67E3F27
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27C2F120008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yViU6O/y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1ehcPena;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rHMrEGxj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UpMcA5WW;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116733;
	b=F/ZXpQkQAkVyEfZe/NPKM+XMFoLcPT8gYkyLm/t9blz0JMZpOV54GzhoNAZOFgMz4/UaSq
	RRUaQ23hP5XWcp5Y6HEN0igioWWWUSXcj1AP5l7Lil0ZQ0B8hxLiVVrRCUbt8tZrkekJ/o
	Dp0bphXnADtXgr6OtjpNHPnjdTQ8ctw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yViU6O/y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1ehcPena;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rHMrEGxj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UpMcA5WW;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=j5dfG6HuJ9zz2o3ywdviG0BvVdnIztL5dj/Ow2LDfWMJRg/Iie/FDHIS00GyVudQ2z3wKj
	z0ZabpGWEdKUD2wWzeOvJhxHEJK4n4ATMeCzVdLv/eLsUBMA27JIa+F+y6cyzxIRR/28Z6
	C2g8PDX1PhVr0WPQR47UfvUjB5O+p0o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DEA571FEEC;
	Fri, 11 Sep 2026 08:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=yViU6O/yD8U/VQwDOB+KUzonPwdyfXjPw/IOeSpePPTUcMTwpgLoScLbsofZpYLGEmwJsb
	Ev2waLbnevCAnJ2kCnxtAqw9Wo8L2FFRIiu/clcqdyUSo4XHY7caBCXV3ePxoxXL1Hntku
	B7c+pA66PcxoYjyytRFlTMi2BGVOADo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=1ehcPenaQpK85d1ajqQ6I96wC5DIMZ7S8QBzu/IYzP/RFwQD8VuBIEdJwOGSMhdYI/nkg8
	jG6rjb6JTKHkj1Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=rHMrEGxjxHYk5w5vXgE8P+S2Ie2xg5xPJC7wBbQJuyZrzxw9Gl7MgsnLkY6R505a90acDI
	w7SXzpDJGrsb9SoVLEgF1ez1a0wnpSKfWMkcIFKAK1TIUy/aJqJ0luC6ezB0p2eAWyz8ur
	5WQVrag08aXUX6t5djtRDN4I9DwmlBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vi+bzvsD8E4CJNzOzEeUuEWE3GljGIIRGGXMdCc2Rjw=;
	b=UpMcA5WWmIEyeXvu6VJNtJVzRlYIvPo1qfClA25MOPlmwEV+Zb4Vq9CbZRMy4rY3p1tNl2
	2rj8w9kBHYoymnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6301137EC;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DVxbMC7Bo2q4HwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 08:51:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D87E2A13BA; Fri, 11 Sep 2026 10:51:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 5/5] ext4: Defer inode reclaim if it has preallocations
Date: Fri, 11 Sep 2026 10:51:41 +0200
Message-ID: <20260911085142.1774803-10-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
References: <20260911081309.14137-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1087; i=jack@suse.cz; h=from:subject; bh=doSl7XwBgbwlZmLOj7HhzP4E5NF4QH+660GbTlfCOcI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqo8EiIqTi8A+6iwev57YKHpZUBj+QsAzBktcnM fhmESSEi3yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaqPBIgAKCRCcnaoHP2RA 2XQdB/oDHdqiVn0eFdzdcMFgMSrbsCTdzi5nYnqnBqLWUSGM5jTQkbeSIwgbVNy0vy/X8RjKEVg E6b0ARhfUTQ+rCPzYCj0PNaWPHyqlqXQnFNdwT2irgefL6nIT89h2JGwYU2Fc5M7VdsxjQXUdXf oxm2ORYuWORNtAAR9zT+1m4zwQpieUeEXpjllpGWxYuI8Rboyit8EEyBbWM7lRoLaoHvhY9uaf+ 2ZsV3GIn1qyaGfudxUcwW92NIE+yVTvQbtoR9pJxo0ErzwTrfK47g9htP2GEt7iM1za7lH+5Hnr upLH3TY8I4rNJ8pfFNYCsVbpTN8/cx1vFo1jHgbs+IxvthG1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27C2F120008
X-Stat-Signature: z8soitm98fq4gyrxx77fikug5kypdbm7
X-Rspam-User: 
X-HE-Tag: 1789116733-319672
X-HE-Meta: U2FsdGVkX1+QikZyecFnahbkPHGASMHhD9fhnAfYGTSTiIxUDgEpb9NZesw138lu4knKPSN5CtGHWDuPFtTlKRfoRgZYZIcPVpiW/WyokzRFun6P0xuZYVYPXSt2zXZZOu61Simxyb54rMp6MlKXVBsI69+4jVkQ7B+OPjPElN6Pgqu9KEzMPoz47x7AjSNMliZ940r8i/d4bBn/vQ1udHXTQlaQFcPz7HQGzmggYQ06Qad9YL1xjMiH82HeGQ9Zullw00LOR0yyAOX2ZSqeDwkyzEQbQYCd6/PhkMBGjGLdB7y30NM5LuV4GbrCpyM57Rth+FAQd6F+gwxxayS5VA22t0taRzLpVSIE+Pl7N6+WZtW3PiDIko1sL640h7lUoZqWWOqV25zf1SB6Ap9HB9k8YFurKQ8dTEbrsDHdk5H7XEW/CD5hmtwnPjxiPHN0mLa6eJZr5txqEgVu14ssVRttswymoXLFPrfER1ZAEjj+r9IN/OFTc3IB36CKWaiY0uoHq7X/nhABdBvHP8y1dP4RF9X65glqZpDojlxOFgxY62cpB5FwBjKSiLvCcjEL6B5PszltCDeAQqq01lggmCJZTsxyi50lSUTFE0cD/q+/k6dPHgREOcQdNMnTzQpKjS3nSolY103pKgcgnvEvKRIPl4oX7fD1cq2zPhU/X1UOQwr2JK7pVVyIxR89qnzy0W+N0XF6IrJK615fv5Dnb038dPwm+ChtqHpL/Es/rF8d7FKKwYhjThAqFHkgpJbwNvPRhly47p8oRkU4wMuqk1tp8rl/N6BsSjP/hqPcE5y0IC41F46Y1jmCSP3ufNSkCfbFvkkwiCDcsZ+iZZxgPMyZ4HmPMBFawvUR4PMIw8eaHlUAxdg9aIIbiUA0wUQNZ4xcSYR24UlNcfJ3w3PBiBVpYeI2N5pBP7IzSB9oV+2bt3Ctp2RtW9Dk6/u82/+aVfNEZg1JlUh34LiFx9b
 vp0FU1IP
 rbdkoDeIz4xuaD2e3TQaYIFufTC0QIA/LoxA8OJnZa8vQ3WcHXiyEZJWIujp3JMKgbPFFOE1BjqTtnMJnYY4A0Kjnvvz74AeFobyt2HrWwJplEoP1OBr8auYWw3eggTBtjuPEjSX9GoFWyTW0rtLM+U3qqPx5PRCXv6U25WM65FmKxQYfXRZuZ8e+248550s7+nZ/NFpqLkNgoQwdHG9YhUro++zyh9inq3JVvTwAsV/ozP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we have to free preallocations during inode eviction, we need to
load block bitmaps and run transaction to modify them. This takes time
and also requires GFP_NOFAIL allocations. Mark inodes with preallocated
blocks as needing offloading of inode reclaim to a workqueue so that we
don't block reclaim for long and potentially deadlock MM subsystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06171a11db12..4891f252105e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3115,6 +3115,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (ac->ac_prefetch_nr)
 		ext4_mb_prefetch_fini(sb, ac->ac_prefetch_grp, ac->ac_prefetch_nr);
 
+	/*
+	 * Freeing preallocations requires loading bitmaps and running
+	 * transactions. Defer inode reclaim to a workqueue.
+	 */
+	if (!RB_EMPTY_ROOT(&EXT4_I(ac->ac_inode)->i_prealloc_node))
+		mark_inode_reclaim_deferred(ac->ac_inode);
+
 	return err;
 }
 
-- 
2.51.0


