Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39ECBCAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B00F8E000F; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254278E000D; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057D08E000F; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E05AE6B0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C5F486C49
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:49 +0000 (UTC)
X-FDA: 83871669378.08.91BC102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0D30EA0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqyTv0QW;
	spf=pass (imf25.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gk2EjIlDre2WXjiZJ1PplMIi/LuaheiatLmN//ijG54=;
	b=5aS8N3fYcM5dA16eWk3yEd0pc+3khFovWl8nM6YnkQSBcgZyxj1Hb40AosiyR7CIPfLJXJ
	nQtzeclEWNAfifKEdGu+MK1hDPlqyhB7UL66JnyH1n0VPmxYOa9OxZftdBHQPXDmh1Q9jc
	QX3VGCUnL/LGU4Hr3jAnC63wwYlJbYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469228; a=rsa-sha256;
	cv=none;
	b=bYoTucx8B81wLzxDMK5WBADWOwo3FAtBLR8GD4UBuHENLYjoqYqqCR/QVItvY+hkorD7/h
	gVurWO0wstn95kgiLXf+fJgpc0JoMB7b0kOzXDeDWNvMj89Md6Z7I8bHw+oG+1Omi00Qq9
	Ofi9Sntr4H9yS+kEp+3KNiC+78vTEk8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqyTv0QW;
	spf=pass (imf25.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B5BE60242;
	Wed, 10 Sep 2025 01:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2836C4CEF4;
	Wed, 10 Sep 2025 01:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757469227;
	bh=xUQBKYzzjC0nxS0cqJlNL8bOn1he6gYcCH5JnBuH2oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqyTv0QWl+9Fe+LdVXpfFmnVn+yxqXrlSDhzZv6d1Qc5MQVrhuMaxlCqqW0af+nMO
	 LeHdbn1yFjESD83z3py2N8Gs4OfgfY03OYEwz6hJQ2x9G2hdxSh5LWXXWW4E48IdmM
	 yGWKZ0zM/H0Eb1VAwG0oQBHWy1VkjiTmG796oLOkZ/XdKrQqkhYG+6xtk+i99lk2zC
	 T/+3aLWvm1w7m+PZXWre7+FtmQY3cy/RRHHLIlC/OzKeO4nyqfOf31yBEmW+SlBU5F
	 0D6+/vfJSarCqbuEOtrsAiPWGpg7UIaIRYD8zliPsJIxHNlZkq+2GcOsDWdi/tVBUg
	 jeOtkTN6az62Q==
From: Trond Myklebust <trondmy@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Anna Schumaker <anna@kernel.org>
Subject: [PATCH v5 2/3] filemap: Add a version of folio_end_writeback that ignores dropbehind
Date: Tue,  9 Sep 2025 21:53:43 -0400
Message-ID: <dd70f28822299dd60cdd9b70e606a144724813d3.1757177140.git.trond.myklebust@hammerspace.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757177140.git.trond.myklebust@hammerspace.com>
References: <cover.1755612705.git.trond.myklebust@hammerspace.com> <cover.1757177140.git.trond.myklebust@hammerspace.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8nkb1wa15qab3f7z1nmk1uswj4ne3qwt
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D30EA0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757469227-79772
X-HE-Meta: U2FsdGVkX19kln9EaPIKZ6d7zv4JIpMhWmAGtHDxrgfQNIDH5yOJ4MeNQmTAiB5a3ic3V229ASrAVn9SNSsGBouAxdlamtqPSuSXzQmlTsd4ZQCKopUg+IJqbnzNHO9QfuHrRJTauuyuG4FdBgdHvf42KaNQpZoJ5ro8YEovakrP5XZbnjtw4LvcDJ8NPn7D2XeiZsJc8blpA+rO7Wkseofud3CLN12s8SCF9S+5ZpfGVWdBAf/YnBzgsiMP/nerPveKoF9y+Fk94o3kQ25i72lVSGCyGiWGz0PK1U5QZIq+KTfj4hUWdWgxIM4QGi5j5wgHBWh2Tz7H782RHYLpj+Cc4UenT7yO06QqntBqJb1qoBAz9N2Qd1m4JoM1YWWlRX23dzHyw2id3/ao43JyIc4faqxP+YJa83jEIoE2hzcIwpVH+oweGRQAK5iu8Cqq1Jo4JQJiH3v4t1EV0GwCIswzY5F4SbSZ5I1ax+qtRzy8P1td/y4kuoXROBYtO4Ik1qGqGIk87wiVYdqJUFjST+0ggsznvGkC/Nl+VSHbuWPG96rpPXYkVok6Sf3+ELjTDstLtad1XVtXBAGy6Za1rubR2cevYfw7ecVqT+u/+MFyeihJrPd61ErQdFBrY2CvCK+gSWmzwZg8QZwpyqphcVZBFouSIkYDPOIIKW6QqC1kzBcyPb3rbyLXmrrh/xj0mLp56VHB2QH+aPw8IgiJp0ImKsQ+ZxNcbXMJX+Qkv2UzB79EWgJm80TQjEkUO//JXgoa/dcHrHk+KcXsOWFshmFQjLRgdy9qCyM14PVEH3DtduPzPtnQoQF2Gqj8QEtmwZHe0n8lbnSU5GdGHsctyj1AvQQCq+k2t5E1Qg9VQ9LQO0TCKksNy6nZrBt5BSQF2X7s2oRZ+C8iKmtz57+J4bJXwuTI0iqwMc/J32pwNk2+0WyD6v7f++Io06WV0RB8TJ77ZjKPs5/CvZPuHB1
 +AhN/HHv
 +ht5lTPgWPlH7JRIaQ71ikwqqCtxvGojRuXjq6oJUawcMrXAYBmlfSl8vIewaDjuB4RJjolK8nEiSDwOhoyBS1Kgul6M35DhNo4vE95ovr6mAGcoTxV3c8oFFCIozTQYk0OyU4Nbcn5SGtEOZ7t+4paJc0urBSndwsa0XfiDPwMbSIFjZCMkeLPOegAwPSNOMUC3rG9Zo9EpTsCpvd6ldEvAVEgv5pcEEqsw4q6GJKudDHx9e8Qs5gNrYDT+g+5XpyCzVp7LYEvEofavJ093MY8PUZH7kCCnIhAPqviU83CF/APYHynOHjBah1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

Filesystems such as NFS may need to defer dropbehind until after their
2-stage writes are done. This adds a helper
folio_end_writeback_no_dropbehind() that allows them to release the
writeback flag without immediately dropping the folio.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 201b7c6f6441..5b26465358ce 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1221,6 +1221,7 @@ void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
+void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
diff --git a/mm/filemap.c b/mm/filemap.c
index 66cec689bec4..d12bbb4c9d8a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1628,14 +1628,15 @@ void folio_end_dropbehind(struct folio *folio)
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
 /**
- * folio_end_writeback - End writeback against a folio.
+ * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
  *
  * The folio must actually be under writeback.
+ * This call is intended for filesystems that need to defer dropbehind.
  *
  * Context: May be called from process or interrupt context.
  */
-void folio_end_writeback(struct folio *folio)
+void folio_end_writeback_no_dropbehind(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
@@ -1651,6 +1652,25 @@ void folio_end_writeback(struct folio *folio)
 		folio_rotate_reclaimable(folio);
 	}
 
+	if (__folio_end_writeback(folio))
+		folio_wake_bit(folio, PG_writeback);
+
+	acct_reclaim_writeback(folio);
+}
+EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind);
+
+/**
+ * folio_end_writeback - End writeback against a folio.
+ * @folio: The folio.
+ *
+ * The folio must actually be under writeback.
+ *
+ * Context: May be called from process or interrupt context.
+ */
+void folio_end_writeback(struct folio *folio)
+{
+	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
+
 	/*
 	 * Writeback does not hold a folio reference of its own, relying
 	 * on truncation to wait for the clearing of PG_writeback.
@@ -1658,11 +1678,8 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	if (__folio_end_writeback(folio))
-		folio_wake_bit(folio, PG_writeback);
-
+	folio_end_writeback_no_dropbehind(folio);
 	folio_end_dropbehind(folio);
-	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
-- 
2.51.0


