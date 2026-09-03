Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7CAC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319636B00A5; Thu,  3 Sep 2026 05:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0386B00A6; Thu,  3 Sep 2026 05:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFB16B00A7; Thu,  3 Sep 2026 05:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0192B6B00A5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:05:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89DCA140476
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:27 +0000 (UTC)
X-FDA: 85171867494.13.E2892C4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4E6C3160006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="z2O8/tIf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/73vGtRQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x163C71M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bZzzsLE+;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=IHGroa7iYzSz7YAYbcbc7fKRiQioRUEwU/LchTqKutzxTa+M2TzLbv4BZ5fxOjZzofuUqR
	wcqWVePaJuwX1l2+ulufEsskcIaycRSb8xl7qeGyqNPmFlVxzjXqHnxceBVzGSUHJP8r3X
	LJZDGmCxTMlRudOe/fUatWW2+RTGeW4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="z2O8/tIf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/73vGtRQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x163C71M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bZzzsLE+;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426325;
	b=NdNUeqNssG0JQNI+6XVdJu1yGvVM9wdK+6N1+dGZygcLQzBUwl6cLDF2JOamMBsh9Guzx5
	VRWTBTZde0SxYKgTNbZ4C1K9pwaEGaPVAlSt05/vkcVvYB9k+uWTNiYjc8ISvI+DrGSCMC
	69Sbyh1+SbY936E425/dtksvjyKsrss=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A86F31FDFD;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=z2O8/tIf4Pw87wVdS2YoZzNs4EQfI2MSF/cfZBVztrLBjsVUAZ4eqN/3yVBK4CdaiaMYUV
	lrIViQ9WfjhPk6QGEi5TVSdJCgozuJmGoO3e578nKef4Kh6jKzsPHTGLM7Lk6g4FwpWEB6
	fLLXoMQti70DSamDuCTxajAKy+GMvR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=/73vGtRQdesM12rwOuaXY0hu89xLN3d8Mq9aXV4aCI3fGuG0OoVyQDN3T5hH4aJ6Ig9nVk
	gwXj0Np9FwVYaXAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=x163C71Mz5Y0EE6PbP2EtVJVNaUqy4bQHmH7OmrdtIsnTYwCf1T290C+TMWWEMFjsI3yCr
	kVLWyieEC6TPHR5fAVP7D+1kg9BLio4p43MbtgjYUqHchFnf41cY1vqEY9TKEY+Vaf/Nuy
	r1vsIYXqSvdwEoLVSvnfd8j3fi1YjV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=bZzzsLE+EH/ySEZcEvCyx29JDrIeG5HDZ8BDtqV39pyqVB59okaQuJHpVbSGbVEP91iCx8
	xzKGrTVFiNt3C4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8523C13738;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5TGBIEs4mWrETAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E4D5DA13B8; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another filesystem
Date: Thu,  3 Sep 2026 11:05:05 +0200
Message-ID: <20260903090508.1360863-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260903090053.13120-1-jack@suse.cz>
References: <20260903090053.13120-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=jack@suse.cz; h=from:subject; bh=yq74qpUyYYBh+XhkRlhY9CvlmFz4Sh7DR+W9lw8EnSI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmThF+qG3OMEVoRa35nSomc6gj9S+ECwWWTQAa k90LvBdJ7uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4RQAKCRCcnaoHP2RA 2VpeB/4vkbXQpBb/RjAWZhBXKbXv3XQRAoEPXAPWZqqvLhMt7xkVwHOvZuZsdTppQm9rx8L7vab Ad+hJE3rXaEpkBdpMG7YUQrrLx+VjprBWZm4dqdGq7HdJ4dm110v8maXi8iGBigbz1ti6RPYE2R Pk/xuUc/cbF1pDB3R5XCBUfmiMrGEFlkzlr3lTCc/S9HA5x47jOylU40JZUxn0XYmK1QA6vZ52T htCSdHJE02646W6HkTA2lch/RtdcMB7nuA6/fKGdjcH+4lpBJVHqYSgPQcEhNJlzHXAFs74XanF MzyxpPVmDeRLE2Ex70OkIc/6C7KsS7apKCAivcOQFEmyuCsD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ytiogb6hziu5d47nyh1weigmn7kfitf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E6C3160006
X-Rspam-User: 
X-HE-Tag: 1788426325-343471
X-HE-Meta: U2FsdGVkX185hzXLpwqlEo76ID2xKQMLhTEwzkI/7ajv5GfdGf3R1fsmZvv9cve07j0udCr6Dxzk0GtQvumO8J1Dp2+8k4T/JNb1nPjpJ9OKZmpRKFGYF+NXpcuvleQiTqC+zxZs8FCLWcGwEW81Si1lzak0KGgr7Zb5ERxvU69s9AaNdzl/t8G8hsntLIkFnff934orHMXz7zwSKcm2j0gZk1FhmKBR3NdawnnI1ny8gEIYB+HTxZew4vH+UCBDTOwUYinFMnJ1nCkN+5FdFGtJr4L2AbulHurLdD2CGNRCf25GrRVsSokp4hRslD78WebjK4oPNKGLL7u0fpE8kK5V7LR4JSdQ7M/Cz6LDvZEDij8AKQGD/29PX9663ieNPcG+Hzjxis+zGbawO+xFmdvDRnVMDx4zgCSnE+vpwJrO2uhWhWYbHDfqjvNI19CvB1rvw/ZaBZ78PSTdE2Iyn+VFfFwTkTzjU/+b5bFZRLX8WQgEpcYPX1NGUEq7ZpGhPlk951oEwQ1IDECFIwYLFwTDYDOw6QI2K+1f72axLLpAQhVsF0AlmyYcs037Hq6DXUPP8FoieGqFxty2/hyOy7UOIgHjrcHwJNT+G+h3AhMI+e5YERnbmda4Bfyy5LFkPioupGyXinRF/FjYMQZ/QRPb6GjWeASzn8o4AQOuHnkiqMNyXEQl/VsUAL2DHTl79kvnNILSHV2+yWSUFylvLgwh8eVGh1orILDEt88zZ4TEDg57V+GyOLRHS7hykhRrTPpxx1g4pxJONQns3CZQ1lUHyyEMV1ikopD3T2AE2ysIeJmXknY2j0bMcfEAD5J7Vx4cuWlEbX+aBgKmYVyiGYi3rcs7lNC9pGQUPTsfBdDu1B3qsihxdgowsHsIHMAueQV5GyAy5trfEykFMFQLPVE5H9hXFvyfOujwk1EK76/4Lqq6OXs8vaIIpKmcBXV0IvC3C89Zl3KcAfw3uDg
 g23t70JX
 tlz81cPRjP2ozZ0q7Tc1NghLHlYYvJF2LCM6te5PfSg8iNYVVh2KGAhhoNYOPxNS4JvthldGUkIwgIt0fD4AlGhIjCL17I7FyqyrN4SZYejBZDLWW7Cxr5SNfr8TCx/XJYO4Jq4u5DyGVqYp0M4HdhOw9JMQKVDEeQ4zULRWDtFYqLueoES0Ns5K50bAuBHgUcXaYuQMb38TPMYga7pBUUgEFom5EbtPAWmpdUEZz1IsQGOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using tmpfs quota format. With suitable
passed arguments this can actually succeed in enabling tmpfs quota
format on top of ext4 filesystem which leads to crashes later in
dquot_acquire().  As tmpfs quota format is intended for tmpfs
filesystems only, verify we are indeed enabling quotas there.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem_quota.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index d0b92d6da50f..a3fa4bd93e75 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/shmem_fs.h>
+#include <linux/magic.h>
 
 #include <linux/quotaops.h>
 #include <linux/quota.h>
@@ -54,6 +55,10 @@ struct quota_id {
 
 static int shmem_check_quota_file(struct super_block *sb, int type)
 {
+	/* Verify enabling happens on tmpfs superblock */
+	if (sb->s_magic != TMPFS_MAGIC)
+		return 0;
+
 	/* There is no real quota file, nothing to do */
 	return 1;
 }
-- 
2.51.0


