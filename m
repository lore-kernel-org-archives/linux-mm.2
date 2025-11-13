Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A131ACD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8ABE8E000A; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ACE8E0003; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29738E000A; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B08D18E0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 616BC1604AD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:39 +0000 (UTC)
X-FDA: 84103650078.23.3DBC80C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id B319E20014
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mry+wbBb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992577; a=rsa-sha256;
	cv=none;
	b=JZaOgmnVHu8kxP0DrxoaM1DPMtDsPZ2vNgBbl7shPEJrWcLMQaJhy3HdmNU+p4XOOxOwsb
	FI+BYVHNmasYCiNJ2asG70cJwNaKgnDQn7WYRyomUF5+Vbng0LlNx7Z8tGUd1Yao/oYxOb
	HenHewJ4D0ORfPSytmKUGawDxNxfTzU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mry+wbBb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Rv8/mXvSM8K0XYdsFjzW9RdHyEewip98MxQa8sbVhw=;
	b=nSL1r7h0KgrFjEsFnitXIgVLF9ydZMoog5fvsEuyiV6PZ2AF4nvEgmM8JXyPG+v1kc+w/Y
	7Wq4Ags4Xxu+Cr17O85iEQOaUXZiEpWV7Vt3R3baPvRT9PJQBhowsAGyf/TVuaByAC2LMv
	tlu499KQ9OW0wbp4Ze7urC/K/NlGFR0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4Rv8/mXvSM8K0XYdsFjzW9RdHyEewip98MxQa8sbVhw=; b=mry+wbBbEVvNeBGh5AR0hl9RY3
	7wcOiEMYfuv8t/IikJWavX90FwQ1K48D8atzoWACmd3H+qk/GzR7x8jjha/hlLnuXZLBj0qusl9ed
	K4ksf5VSGAdTaLNtc8eKGbO6kD98byVsEKOZYzFyul3KegUT+ILl50DL7KFP9F7K2CAues0d3FHeg
	4aWYoqut9rvwdzcCXbGiNc3u0JFnfZTLqYWRBXSnEuisV7Q4wZrMZRKKWXPEQux9r7U+8biAxsqD9
	U6WedzGFbX77zIEADgS+V9TZKtZ7Rtn6UoyhFD6lxEH8hyJpumkcFrOi9pkkJsoYjqqVvxLtMztjV
	lGdUdMCA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fP0-1uZ2;
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
Subject: [PATCH v4 12/16] slab: Remove folio references from kfree_nolock()
Date: Thu, 13 Nov 2025 00:09:26 +0000
Message-ID: <20251113000932.1589073-13-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B319E20014
X-Stat-Signature: af86g4oo1ehry3qws76wwuyswnxydxm4
X-HE-Tag: 1762992577-473653
X-HE-Meta: U2FsdGVkX19K2Yd83wIj05DThHqpCIhS4QuVG0KXwALvLtfZ1TprL6Z/d51l7/08FRgMTTIYlHSO9LvGEOzf0iSuLXENhPldzGb2SxI/6a9mleX8YSlLW6temmNBvjPuzmJ40ofePAehCjmTpfbfRX1OlyQ5mxVSU0GpSpG6XrT2uw+fL3TkuxDuS2x2iSRNg/TooA9vZeNXe3qrZJVel5SyX9dPvt/iVZcNMCRq59wiMsR2G/WeZpnkPbqSrzmp8Uh5CdcFP29gKFXA9bv+oWDOI5IM5j7mlDwvlIqvR7Lc/nSiI5a/oEbVp+8X+6UmR0dpvZHHVvZZkSZXwsJoDC76pMLr2NgqQAw8jJHW8gMI1dcJPID/6c3I+FixO58zCGtbYAS35SS1XCDanH5QhUMU0zhzFRQ7VVnlNR4LP8rL/7d6NrkRNWSesiqkPOSfqLfX9bisjSsRu5sT4YxIc+kfnp1HUuflogBAOsAyQhfEKqy9vErRzkMncuM+vCk8SJZa0NCGxFiZ3uVvh2FVrj85OVdcxh2HwinVnqsgxznBhu9Wy2IXw8evu47O+lkf2rYPM6w03chVgrdPyDGdBc61nvKgypafj7NqMAeBfycFK0FYtT3DLXCl2t7CysJQsolRqlzSNVsGVC43KRXJuwzoIXO1iWtpcZCZlh/qsZXRiWoIMpgWfRL5cNObjihhIj+UVz85wO3aDxWyAYj6MlFjry8DRHeogczSPPPxR4D9BvB5wlG2Y9eRaCCYr4a6L2ssHHcaLap0HcjmQK9RLDMGajWNn7PgxyyeQbtgLMo+a6q6qqElJzinr0B3t0/+xH8wcUPqD4iuTZyHU58qN9L43U+7xdqDO0dFWY2Jaw5RFnp6NS6GMQdS9GEjhrDJTx2Eu2X9ibK3HmmGl+xc0AwplXlZdohI8fUmVNMEyznMPQ3rxhTU3fckSXUTpYC6Ve9skuUUukiG0VTiHYu
 rjIH6ALE
 aSyhMn8tjUCFErxAt6l584vY3kvPkrVP++gHIJnxtVa/mXbdHPKvVatnerY8Pvx7MV6VvP6Qn5IQsedVxkkTJbR+6Nd70xRM+rbZ3tbzgsKL20SBV06pIQShm7aRfEKXKeC+WdGeAT/0KZeMduLTYuvI+lSZ4QzmXKeUtU2yy8jVM+V7KF7QwZ8POEv5bp0feP7xoxTzUTSEJ5BrvayhgxSYwn34PhvbhxQUdZOPdLi2EVs8nL89n58AJZC0ctudoqul6KyYk023V1TBRHDauO5x+cpI8VWQnok7ROB+GL/vrAimIhqqpJ/909A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  Since large
kmalloc objects are not supported here, we can just use virt_to_slab().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 17b456f6fd4e..d79aa826d3e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6899,7 +6899,6 @@ EXPORT_SYMBOL(kfree);
  */
 void kfree_nolock(const void *object)
 {
-	struct folio *folio;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6907,13 +6906,12 @@ void kfree_nolock(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
-	folio = virt_to_folio(object);
-	if (unlikely(!folio_test_slab(folio))) {
+	slab = virt_to_slab(object);
+	if (unlikely(!slab)) {
 		WARN_ONCE(1, "large_kmalloc is not supported by kfree_nolock()");
 		return;
 	}
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
 
 	memcg_slab_free_hook(s, slab, &x, 1);
-- 
2.47.2


