Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D801FFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB476B0005; Wed, 29 Apr 2026 14:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BE16B0088; Wed, 29 Apr 2026 14:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3DF6B008A; Wed, 29 Apr 2026 14:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBDFF6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:01:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B7061603D2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:17 +0000 (UTC)
X-FDA: 84712360194.07.2439316
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE9934000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777485675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fj8+qvXItnBkVkXJYHA9NywplHOU0WgsdiLEtDYPXsE=;
	b=Cv1qQ69y2oVtXwSuhH9PF/GeLWxSunp0ERkniaphDPV8njDD4BMIc4cVeGyKe+YRydboSl
	g5NcuNwIssPcisp/kVfsiW88yypJRGJ/Difdyd7Kwl+vxnoTWKrlnVjngARltTO8DYPUZy
	2z10Z6wkoZlrUltcf/WtSguI5zBwVJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777485675; a=rsa-sha256;
	cv=none;
	b=ZZcC2SC6dwHoagt90v9nL/ZKg/52GsVImLBhOM0iX3vI5Lx411vCfW30IblMxBgjFVOzQo
	sxBOY/EpeLKU+FSEuxtQqrBkz1J31BHHmV69klxrOg1ZtAcBdF1dsfpwl+QhV2T7AQm1KP
	fKPUWbOnNZBIPfuvyqBmaZXC8ZFtl1U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 263476A814;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14292593B4;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SGvmBGlH8mnaOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Apr 2026 18:01:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C9075A0B79; Wed, 29 Apr 2026 20:01:04 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Defer inode reclaim if it has preallocations
Date: Wed, 29 Apr 2026 20:00:54 +0200
Message-ID: <20260429180056.29598-8-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260429174850.18223-1-jack@suse.cz>
References: <20260429174850.18223-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1087; i=jack@suse.cz; h=from:subject; bh=mzpKH1ZB3Qh3QKLqTq5A8f4/hEciqaohMILgVC0QH+A=; b=kA0DAAgBnJ2qBz9kQNkByyZiAGnyR1qgiHH9eRNVeK9FTxZcxGOSjM3n0qP/bIUSdV0vN1SUq YkBMwQAAQgAHRYhBKtZ0SvWnjKKtVUoHJydqgc/ZEDZBQJp8kdaAAoJEJydqgc/ZEDZGX0H/iFk 4CSpD4Rr7/0/SHiPEtHqczHLQ32NLfDTbdDiekMaIsfCup32NxFJX93uPoUlku7SixlLBhbWUN9 pfxN3CV0G7UonsQw3/tMeJ72ILPPGrNVN95JAlBz8YqUM0bbbS9JSX7Bsl7w+WK2XUkNaknbx1D v9h6w3RBHE3QeNtox3omQK0QA7eAo6JxLp725+2BRaMjtTRQkU5oYotWJzC1Fa9SkoQvI9LQy6D GjZjqq0bEWuCudzYeVRPoMVOG4jktvaJ2aXYvpPACf0oIREEfeZrxdtWhW0pO2UhPzC4Dc2x3ui 8FIEmXr+ictBMOcfAqv/LqpS07sqSt4NTky+YfQ=
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE9934000E
X-Stat-Signature: eihpimahb3jc4u9o5fye73f7zrnyk4wg
X-Rspam-User: 
X-HE-Tag: 1777485674-980609
X-HE-Meta: U2FsdGVkX1+jDWrePg4OPUA6qJXU2gDGuM5dRHXDdgsWZZtggF1XqlpZ9t2jzR6myXmm+WG0UsOq5kpoQ4pcaACOrjyhyN7SJlJWlcr+fC4Aw/kJC5RJ350XcUlTzwAyjKRqQWONqybq4vv2kH/EpaVlZ25iurNkPw8RovvSex8ZEGneap5zyjsR2rC6oNxXoWDfc1dVI6kpiexueP76vZX3OT9T6oVznfbt++2Bs5zGWjr2UInGejglujDjRnxKMJMtSwoMpD1VDD5Vnq2pWHxzgsetWu/y6Skblj7sipcb0nodOjSCGa1MOB6KGGiORdr7F7Mk68seuWkTQJLI7pqiOmy+KW3KfTI1xLinS0JhdCcz4zgKSqfCVANtcR0P4g1kFW2tTr5WGgmNPpIcwRyQLVXtUgKcndrvFwKTo/1RfqjnUmmCkvPENd8sTPfDZJlEKEyKcTS+4LtzGIiGFqf39K59KeS9Lo2LX4HMbJEmuNn/7V/lCaxWS6bb4QRdkGJRdRINCHt1+V3xkkIbMlPK+nNS5oVj2ObYNcUqTg4X5vSgAzS0pCwOt4fnZsjXhj8YTLaBvFfqeWkC/MxNknRCU+6zR6hO42rDTwAAWqpp1/RUnX5UiAiuY74qqbT8hr/V3XJz3UokCa8CCmYDNL8gybqs2pEFZMARkZe/8Ra2NOV/pFfusKGfeluDCLUpCWXakFeEO8UF/jFnWnLrjghgghvV16MoD5hb1xAmrv1iPu/S/RncMLCx095LJ6z9zBRpi7JgW75T1Pe68LY4sj3vcYXUHSKdnHU4uSUjlsGKL1g1ox6aGCX9XeOY0Mnt+4Fx3mPLf1GZITsDV00iywTztQBBh5UInxiEQ1EzWXcjZZ+xNEjgmX+TWWyrPr2XDnv8IvevFOTKkJwKl8zzjIQxt/vTg/jsNIuMIE3mKdcSUzLS0mK4q+O0sMpT/5VNMIQPUwJVTV/X2Zffdxh
 24V1YVUo
 ZrUoDhinldfwatSIGCjc8mXHTykrkdw29pYlQX01oIFXv5dshslbatZenu8r6q+R5knnIpbkgHxXL/3s=
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
index ed1bd00e11cd..4de3cfa4e648 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3114,6 +3114,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
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


