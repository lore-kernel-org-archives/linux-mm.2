Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08799CCF9E9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B553A8E010D; Fri, 24 Oct 2025 16:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90B28E010C; Fri, 24 Oct 2025 16:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956A88E010D; Fri, 24 Oct 2025 16:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD578E010C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16A6EBE74C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:52 +0000 (UTC)
X-FDA: 84034186824.10.7EF90F7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7EB884000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jyCTuL+P
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338690; a=rsa-sha256;
	cv=none;
	b=rGt4zz30ehlu/Shl2oU4PEGQM+1apQL+I6H4rJY5DEpFkLwylUdae2Mmtv24JYP/iPDgP7
	/Qh+/gLLbL8WdE+refeaOXg8ltFWhbKNhnDqbxhdDO7pWAKuo7YNOw8WWILlSTjTnUQ7HX
	++r0f+u+G4YiYqErV1ihECV24tM4UKA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jyCTuL+P;
	dmarc=none;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIzuKEq8QJj+jc9qp5f7R/PcpFDyjKKCRAthoZxd1Do=;
	b=QeyCzpbpDc6V/wK+2LJAQ1xjLoLc/xKjvREYZYVcbhj7wq752oBPJ0wnoGuaos+ZS+mZZN
	D4bnBjcCtpEMGBPZmN6uJAiHIis6y9QcrMSB+lNF8WzVleOw74Xmxtz/eT9bPfa179Py9x
	Wg2Q7MQ/lV7BRJ6Ue+s8gnP7iyvMBqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VIzuKEq8QJj+jc9qp5f7R/PcpFDyjKKCRAthoZxd1Do=; b=jyCTuL+PzLGXnB9GRyp+rBhwVX
	wTNuhfN0JVbbZMKhnVsvS5a1b5YuGv8yO7McfPRTAlrjc7/ygfWJ0CaaAgLiqpBp2O7cyMiyfWvm9
	/NnzaTg7Du6GiHWDpDQ7WiyvYva+dnxMlSJ+Dt+Xx9Ua3ftEjDRzLuaTTjlf0tDc8ArNRafMEopxR
	ST3f5bt/CuqMBILTbcznskOJ2S0EBbKh8PZXL/g2amppbGfn+Wy53Ir53FwKEGsVGO7nvsWcNyOKZ
	2ZAfNavf9GMIQlIgQPoWKA0OHqNzx87fcN3eq+Stk8xHhJIUhJNAO4g/Z0hsgRrf5hLwtYqlQrNAF
	9KDZh6PQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKTu-1sIn;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 13/17] slab: Remove folio references from kfree_nolock()
Date: Fri, 24 Oct 2025 21:44:28 +0100
Message-ID: <20251024204434.2461319-14-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mf17h317nuot8uoceh313qfjjdsguk8
X-Rspamd-Queue-Id: 7EB884000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761338690-563098
X-HE-Meta: U2FsdGVkX1+2nbjd236phjHzVVIEvDC5sGjwQnbru5vQT+v2MQwO4hNKJr4Emqur7wKDTnZkMdkJnJ5FAa2t6x2I3aUOC4IaRpsQ9x3YyZL+yLKc7v6nh8ZjbOKZc9z1sSyPfx9d90FPVYy+LMtwsnC18/jHoPX7NabdlnspTBGdv1eU7H1WC2hJvy2EKi+bMQeDn2KaSRare1LZdZS8W+moEihYKocYc7x8ZrsDywxohdU91RlZNuvfqZyxckzx3Lu4ooAmqu/jawg7u76j7+U759zlqh30FYdV8wewiFbug2ly3kV491B8+HY9OFWfh+Vv4jsxXabFRkGMbGU5bpuTHq5wmSiI4pt2ue5krD3eD1eaGciNDBUKi28nz+HwicvbF1oRbddpcKLy0MYVIo06aF5+5cEcLhSehv3Svig1MjVxCLxKU0MYrKqqpqOs6u+H/rS6V0c8GaE/kczdmAnzvkbw7wQBgwkKpLkcodj7wMfDxq3CQXuIOOwwIkiCCc7eFclWWqZ25xZBaSzgHuW8Uin8HWlVJyMVIF9AMBONg9+HwbEcIgTFC3OkbEtT0PAKiS9SMV9yLucCGVoXeNLYd8DAu5LcEugdQEq/urv9V1i4n0bT2ZtZtMQBqBm40xPfvAx4hkI17J1autf+t+8nnX/9sxTRHr+zLfXtzaUIW9vd2DKlmLaH8B7M+YeiUdhefG670Vajo35ALjjabF53l65bFR69LW7Hn9M3O9ELcEvrlrUp3ZkWtSotsbw1m9W1zG0DNqZmhEZKWVdK8sY0m9Hy7sXs2ZkhTm5lx1P+kbW8M7JpvQiwuaqLotdxZftvmfYAuQgcB8uNOnclM5z6azCKMfhPtQ8DasqAupkD+9qpUC9gqP8aajXxjn64qb8enZQ4Z/15CDC0A46XrK13yFwhmEe5ymaX5E/kabLSXp+rpNcc1+gluiYyvmRv0HBgS3CeLUCoiyNl5wk
 jSx/lsoA
 CwJekGMdB8w2KElxyEPlDqQhTxD+lOot6HUvST69rVY9rtoi+ZBRfFv6O+fS0rm+EFhZM4lGWiQRop03uHikDU/hpieBx+almw0mor8+GhAR4zPlQ6Kt/ePo6G2qDA9Q6Gwpjqg9nTipq/D1fqF4DhCvRMuSziP7DVXUG1CtMyopLlOx2IGp18NdDdsw1+jlF6zaYRm8l2tXhy9IrB4KsEDCgNFghMgcIWq8cKI8L3J6KE+k=
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
index e37f584352f2..39a26a970018 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6837,7 +6837,6 @@ EXPORT_SYMBOL(kfree);
  */
 void kfree_nolock(const void *object)
 {
-	struct folio *folio;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6845,13 +6844,12 @@ void kfree_nolock(const void *object)
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


