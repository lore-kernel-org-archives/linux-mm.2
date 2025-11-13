Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D195CCD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04268E0003; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A288E000E; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F458E0009; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01438E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6387F12E22F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:39 +0000 (UTC)
X-FDA: 84103650078.21.CDB0E88
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id B574EA0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pWraYqWl;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf9e7bj3iEIfzl5FHNdDBGyLJ9g7vgLfDYkp2G8icxs=;
	b=CnJUITu+6fXf2Ax/l81YyvSya4/8XrZ6IE1BRPRkSM1EjbMUWjGwKCPMPyjCiGzQXc0NpK
	GtJA0gxzvsz+dl/E5XHktXvXH6LPtJE8DvpPcbK1Z2qGaWy1pumU5fLm2GQWbADp661tHG
	PHNls81NA5DkI7/alQRDnZGlXF2kCBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992577; a=rsa-sha256;
	cv=none;
	b=0KXVOktZLmQT5RJurjPnbpFRfAOsRt8l0T05guOQTx8Fg9x6sFKZCZB2zn0MLnzl05YhoX
	VDI8hfs16Q/WyrfcQ8AFuI0QlpAGoMU2NhWtxl+EyxVYZwFhLh54l89fGZA3Jgkywo3JuH
	+JUmJ6rkWVh0kpCdbrcvvw67XFqnYmE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pWraYqWl;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Yf9e7bj3iEIfzl5FHNdDBGyLJ9g7vgLfDYkp2G8icxs=; b=pWraYqWlUF+tlK/Ov0ET6SWRkd
	9Wxy1xGu4aBeBqHhnFPUQuVcpPItja0/sn0cddr5OtPjIfGOTrD67aI99NW0xw8Cd1c6zpTMJhMLK
	jJ3aZiAlebTgsfMtRu+pzKwhKSYq3gH4pTtzPzKdS6DNRokSLTopV1IP0wjiN7txaZ5YDjZ3YJyHM
	fBOSOx+KiVawhpT/vbFYCEO+ZmNi4BEEWBS0vtrBs53CkxAedSxreTzEBz3zuqo9c9FdCjHu3ozrQ
	lFQjB5bV4W/i9pvGpwOWtKF9P8/jM4rxnfmFeIkxa6Bd76tVBm3ZGbugaqo131tbpxqSbLa2KsElF
	Vledh0eg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fOi-1ElX;
	Thu, 13 Nov 2025 00:09:35 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 11/16] slab: Remove folio references from kfree_rcu_sheaf()
Date: Thu, 13 Nov 2025 00:09:25 +0000
Message-ID: <20251113000932.1589073-12-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B574EA0007
X-Stat-Signature: eksek7gsdogxbmwtter6nbb7rxkytuqk
X-HE-Tag: 1762992577-230195
X-HE-Meta: U2FsdGVkX1+9hXLq6FyGlEtTTfhBXrGmimmgjBS89YxRRD2QGQYTxNMdTnND2LYbxFxNQjgd+jVyJHUQbaixDLaQjW11EUMqKrX6AibVTwsF0L9Dwf4gzPL7ySUiax27/Gx/3BjjMwrqV2Kiw+WwXwFJb3Ja4+LvaUzY8WJbjSDUco0XZw2p6QCJ5tfbq7WvTc+3MaUTxpA/COFgAoQtWlWzVMrYqctyD5QZ+7aq+QOyz+N8N6rOTFa1K7donJzigoFC5C8XOjBHpnhSOnj7BiyHyKEsrNGgdLsn8THd3xq1jc9LqVqj+CNtLFsv7hOEGnBtXfHbIic9l6GnXc9Vm5JPbDzam7AVap8P1onwtMLvxLbwP/OijOM2MtymshG+Id/ARgsCtx9nb2qrskMxrUGAnVksW5lvYJ977TDDtEG0KCNrTvjWxvnRxqH0TVmXMCV0byD9yJSMt20+s/K3QxGfDKqh3+b/rBkOXzzzl9qtGL2MP0bnFSNlqr3T7Wmvk+Brjaldv8Q6As3EUS/Uy3NcNAwPUDAP02cjjrVLb+XIqAZCIZS93UGaxp4WzX5denf3aHVwxGw4HxEfJ7kaf16ADHZTpAFMldDiRyjNELU79AWzBCNqfpugj0jZXxdX3hq/l/AdsEYvpblhiukIDXDAeQ2ERQnUEDZ4rewvYNrX/su+Qrra7p2kdYHB7Dbnk5ztV09YsMkaoHzw35mu7DOLVYLxlT336Z0uV1O1GfFdeI8P5jxnrUp5+PEyL/PWWkbq16HoHBT1Qfvnl3LgMAbDwNMSj1dl8MgCkzqd2ldQqBQQedHW9g4oJdZUootZPVHCJ4oEcFF3lkNpOB0/qRQaAu0Gp1woClubU5hnJZHC/KksMMO1UgofF3yj+8RFC092LiPwlZOG2BTHnr5C/DXj2GXzLTFYfeC0LdfE47s/LnT0LIipDvu4hv9Con7zxrMMPYuIg6qPTrLvIce
 Ukap1rXp
 AOvE8gMfkHfFHbLGuaD7ChFG0eOsXAXK/4vdGEZLHveivbX4xpTJ9f6AYW6mM1iPcyUg2PSpd6TDJ8ff3HUhBZkNyp2RKJcvFkGQ+HXTOHjFqD0NB6KK3bztXDgTJEvfprWY5Rp16yrewaRxP1byigsjh75CmePfEFo6R768fKI0aK2JWPmlez0QbW7qz7qZoZZg27e+kUlxaflvinNuPYczJTB8P3DIRxj9i3RvEwyiLsOAs30tR3YWq71h6ihWnU+q1kpDMZx7rIU4zMN45AHTv88bykdSgx3DvM8cO5decn7CJeI0IGL+4yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  Since
we don't need to handle large kmalloc objects specially here, we
can just use virt_to_slab().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 236b4e25fce0..b613533b29e7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1615,17 +1615,15 @@ static void kfree_rcu_work(struct work_struct *work)
 static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
-	struct folio *folio;
 	struct slab *slab;
 
 	if (is_vmalloc_addr(obj))
 		return false;
 
-	folio = virt_to_folio(obj);
-	if (unlikely(!folio_test_slab(folio)))
+	slab = virt_to_slab(obj);
+	if (unlikely(!slab))
 		return false;
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
 	if (s->cpu_sheaves) {
 		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
-- 
2.47.2


