Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764FDCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 19:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591386B0088; Tue, 23 Jun 2026 15:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569216B008A; Tue, 23 Jun 2026 15:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6336B008C; Tue, 23 Jun 2026 15:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 247806B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:29:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC86640117
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:28:56 +0000 (UTC)
X-FDA: 84912165072.25.E1D458D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6602140017
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:28:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gM0Pmid8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782242935;
	b=gkoXD05+GIbIHuTdnXFtqqp1oofGsr/I3Y9eNnpC1FT/xWKX8PyzgZCWjcoAb0nbp4nyem
	qcsQpm7dNquX4Wbv3LnFqaxgupfbLv7r+PnVgAeCiY2Z+SCKTau6qe5T27PNNjZVquDQE3
	T7yIdkYLYyq1aqcG7p4UYK7m7GA3nSk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782242935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IRZnt1J4nxZEuonqv5vtaLSgoyniAZZwlu6BciFW4pA=;
	b=ZUwfQ0R2QeTbLdNLezlrEcuwFlfYZthWKGUzQXE65ryBVEsc/7baqMhjt33GZAhc9pBUSm
	7gHLdAG4fTIyXHqMydhGvXhNYgn5cJ4l7lkDMBr5etJSE4jkPtkQmFcSGxJ88a/NMcFLh5
	gK3/AIrQmtO7CyBjBbt+El8eu4r7pCo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gM0Pmid8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=IRZnt1J4nxZEuonqv5vtaLSgoyniAZZwlu6BciFW4pA=; b=gM0Pmid8l5tJQIPL6tHC5h7LjZ
	dCZL4xjoJ68d8XxIRw9heRdoezk2kbV9vFYn4See/qPF+pIJ+Y8FVl9KgL9KB4EcGGsE5mp91pjCP
	/xI1JV8BKlYcCFOjKIttl0XZRy+PoIsOKpOVyYLNRHLC35yzARVy5Px+dg2KlqgutIYOnka0sFf5s
	FtcPHClEYFZCgPGz/sStFiTxlSX3UlPmLojHidnO/S0kR8pVaGmj0osDcHyZJ7PebNvmEt42UPSDp
	rQfwWWbMPYEIcf4pL9Fsy8VWvgZ0rtypK9GziM1l3xRq/JG90w2FU8Lmoxmtgda+NNLDuqw68X/AQ
	b+9JC65Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc6nj-00000006hBR-37Kv;
	Tue, 23 Jun 2026 19:28:51 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] fs: Free any excess xarray nodes in clear_inode()
Date: Tue, 23 Jun 2026 20:28:48 +0100
Message-ID: <20260623192850.1595958-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6602140017
X-Stat-Signature: q61ockqmt1ijzcw8fxpqbqyytuadgp88
X-HE-Tag: 1782242934-89023
X-HE-Meta: U2FsdGVkX1/k59DLpGe4oNApcfJ9sCMxff2TQDyUb8rpGt3gLI9RAYR14MJx3UC/Mnvj2YYI3BQa745rLoMELd/W/+xDcZw2niibo4XKIyhQ+HFrIim05Lr1oR+ar8PAbcFnk9hvxLUGpQM9CHUX3CdIK8JawB0Zpmkyua3Rf2vMxg/vuXpj6XwniBZFqvtVG3zn+T8vh+4Lftu2srGozp3MKXbkwkfZ4icLQ24Af6/nT4yYk9QcrddXNeV2DmVC7mTr5No/xEdrl5I3bjJ3OzP205RdS2Q7TfcGSTg/REnIRhYJK9fD6krjkg68aTHZBDy+lRtFZNlrcaJScrnrNQXXP8YogG/xyY5SPg8Yvp6b3c0tlFZcGnztu3mi6DUQK4r2JqTUWVD7bPYaMQBv0dkiHGSJBjjM82wbJ2MKSNeA+6yjoFtaaoR3aTvFTTDCicDXE/uso4NigLpmdiuHPAvtHBBTX1u4Ku3JofU3Wtm6UgnrtP+4QW9gJtRr4ubQ5h7HkmzCYNzPYcpuGQbA2L04SnCbtztKaaixhDucFLrq2PpG2J+b3aRPUdF/3IRXg4tVI/RUw1fJ6k0fuY9DoClEWhcl/JDaw3lqCOsvAN5ihqfndnhZY+Wsa0/0nlGklzyNRlAvoujQrrJ/nvEXmq9M9+bzYYF2i00Jbf6TfpF6FvTFM2kHtQ1vhXGBrBPpd9XhZoDcxEMaqcWCwZH+pyiDLJM4EEXMgaIBbqbPJhK5wHeFGkiRhOWFh3zUIUm4U/LAZk4X4RsBRCk+CVYlc+n100knEdIUE1xu5gBkmSgfeNNdCUkR06AlACai3kzR+AOhIJB8cVZ57FJ8FmDs7S5EtTbNcuW6Htwl9r495dJ4Ta5I6pqUtkLYzvjJoxADqkhvg4JH2W0oaUb7e09LY9h13adLTt4civlaK5/n92aBU6Fq8SHByysaEpk+O3VRkz0zG6CsZsZ7UiO+4kv
 kuj9g3ti
 pTKYzpeVn6JoA7wbPj10mT6FjfuffHtG/S9YdFQpNNJ9nO0FpP0UkBkw7wjRspJk/WUFmWLZF6rKMnUuRlhMEsjwMd7WXKIEUEzmzXkei+0TgO1OylYImy/Sk7lzo0sKcu/yZpHAg8Y2/cOzQYahYK0iu6Y4b+76PfwIR2yaIXU/e0CZKg8eyyAsqk7p50ejClm7n45BxmOprWOCpKRkMn0OFkbvh/ZH6ZVNsFUmmxg7eOoyhD1FmbgPxRL5jC8j5ms1igZylIO3czPr85wJmt+L1rk2z+klH8m+gtpyegKYxOdBB6A+HVXSVEULKijRMwbJcUHsp1pty/bGsvDolgKGoOfFU3+rr2KN6f2dpBqDc5qSfVkUAvsDiD2119XM1sus8XmC6mIuUlwQ63laeTm64ZDgYqwxAGbckKM4jFOtxr89QUlhArZN5tDG/qy2wwtxkpUUoEp7rXXe2HJ0FfOPQ8cNaCRK3UJS88BHk1u4qaBcn+AlFfYEHPNIIqZ2xB64lleug+AR3wSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..4070ff27b318 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -779,21 +779,18 @@ void clear_inode(struct inode *inode)
 		fsverity_cleanup_inode(inode);
 
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
-- 
2.47.3


