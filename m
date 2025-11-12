Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B659CD3420
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 16:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE088E0016; Wed, 12 Nov 2025 11:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177408E0002; Wed, 12 Nov 2025 11:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066F88E0016; Wed, 12 Nov 2025 11:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E46AD8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:20:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A354D1A0594
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:59 +0000 (UTC)
X-FDA: 84102469038.30.27856C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 950BD1C000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBw2nQH9;
	spf=pass (imf21.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762964457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6Lo1lVPdrODA2HpZ1AIFuWYBpbvy/PrwzKPErcVbp8=;
	b=FgBM0ERGcR0GvB6zmOy4ZO9NWpTL5fNNI/QGo5BCFEH32b2+mD4rz7DZu70OjUJB4+qPXi
	ks3/mBj54K9C3wiJWkwrZCgRjiBWvIxD7GYhQLQZRYtCWgywGwy5O4CcIADIobiAc88UVI
	4VIWLQmu3bDwNMgkqgG3c+50xoR0iUY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBw2nQH9;
	spf=pass (imf21.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762964457; a=rsa-sha256;
	cv=none;
	b=4oa2sj+yb2nJ5gDt26tpPzrq4tMNn9H7YSC9HkxoCPxoe1+7dhbulqN/dI0e4VEzkl5Wr4
	VbSG9wI2bILa/9ywYtVzzoA7VxI0Q2UxdhIWc6KEUmnmSFGJV1JFUh7V1Z7XcB0mmYCjev
	MVFW6zkSARLtU5uUyPRWn+s6ydRBgfY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762964457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6Lo1lVPdrODA2HpZ1AIFuWYBpbvy/PrwzKPErcVbp8=;
	b=RBw2nQH9Jnkg/ETHJWtNUUv6xEyOmkjUrSMTDHZ0gD/LYZFEK3uS+luUbT96C4uD0J4mow
	dzsctToLlwF6Ue90PcBp5WPDlHPeZ9KnAnCwl8Vai5TiPYNBxM3SuqpH3AF4vTdhi2FMjC
	cl9XdrX8I0yp1chCLyO+BfEq3tVLhoM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-ddLVrbkSMDipGbF8GAQGUg-1; Wed,
 12 Nov 2025 11:20:53 -0500
X-MC-Unique: ddLVrbkSMDipGbF8GAQGUg-1
X-Mimecast-MFC-AGG-ID: ddLVrbkSMDipGbF8GAQGUg_1762964452
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACB43195608E;
	Wed, 12 Nov 2025 16:20:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0DFB1955F1A;
	Wed, 12 Nov 2025 16:20:51 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 2/3] tmpfs: combine !uptodate and post-eof zeroing logic at swapout
Date: Wed, 12 Nov 2025 11:25:21 -0500
Message-ID: <20251112162522.412295-3-bfoster@redhat.com>
In-Reply-To: <20251112162522.412295-1-bfoster@redhat.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iAwzq_dsLL_xc0sQzIr_KLYry1GbkjnS6WKBEjDeF20_1762964452
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 950BD1C000D
X-Stat-Signature: 7pheh4rik3h4tkuqe5xhcuejipnie6td
X-Rspam-User: 
X-HE-Tag: 1762964457-862580
X-HE-Meta: U2FsdGVkX19UeKK+tgY87TxHevtWSvVRnxUROf5qv8+Yqzd6zONuZQdNAQvzZbxrcHXCGGvSgmUF0vYoOm+wczDR5jaqThi/TIMmrl79mfEPHn3PT1OhdR9VIzMWcF9kcN0DC+poLK6uIAiNOxrJCzH3LukxL6SggOaIsMe1hym+byzVonTxJ8Sxv+LODVZg98bBDCRLzjN/Na6mztboGgKaekMGGJYmVCA1xjmrDmmn52BnhL7QJirfPqfV9UwefqBX42LPjdSPuaPi00zkGolwjI2AmaIXzYGgrb4e4awASWQ9FBr+CjZPKKg0rm2TkzobDFuVGxzR01e/a/pd/fOT0xlbfwT0PWpbc5ls0Eh7Z9KgQL3Htz9w8c0mkPqpedsj848Q3/ygBNinOAs7Zju+DNymwCBRH6BVvQwI6YVhmx8T5NGHPFUJE3O7KtBhtisEr92oG5BVQiwZGJ6ybrw08jjMb+a+wz/7OQW3dNYpO/WJOU/aAE/gHjVokY6Ej/H2Jtepmdv6wXdmKaNsV1y8ap+G2iNMzbOIb5nJ7bpEGj3OfuQ0szs4VXbNUnIuwTIdxB95QweAUM2XaEmoZaR0TRQw3c7BVfa6h228K1qhA28F1qILcBGEctLO/27uvwIlzPGTwya6ccjDb1NipK7atHo41GTiD1qEaXDA6+byqvM6WO3s8X7N9sspDEVLYrtsxcY+rwJ34SUJvR5cU74IJPslrHYtzh6IIWsYrTQutMojEjScb5rOUkQc+3Kw/sHxP9mimuV4nV3A/lfvhm0YMZW0WHJhcu0IRObakLK6U5aAVeP59AzaIhafIsy0E8Vjf/ckryEVhONSGGwpoe775u4e/mECrnMxliESvqUmcBQuNPCSTDfvRsEq1iA4DfP1oaFYYPFVtLRvJaPvcMG6KPEg/xvzI9bulGYy7YNX3kLd7y8KjmqCwWrk7FYrKtLmjox/aP+Y9V49s3J
 SqN7aVc/
 O9yb3fS7tPDju28mvuuheTy1NggDogAf3QyFJIyq5ScQEEQfVIcpjZ3tQsq2oW7P38Peqe1ZvmOGNeTkuxDb24EWZyn987RzrUWoV30hBBkABlsQM+wM3ws/fzvN+T380gXjJJdYNcdLESFyGjoa5H+g01nUdPCRLY+neU4xw/giIlxpRxctYb02sd8KPLQttaygszLUdx81PvSWj1cpGZvj7wr2XB8KR0USaDOJaXHFW6CVYZs94tVbrH9ys2G8NkTSxJxUhPBQAn8sJb1BJXWSfdGAs0rL4qIgQJV48RiM8WMIBPfyE1uUJBmQGorjI6cmsSgntd9WZJnA6vf5uN70be5+z2nhnUOXY8BYrYamR5zthxcf8Rs2VnjsX4t0ghwSIkvl31vHZM/e5FhepOtKI/n1cXtFbwl5P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_writeout() zeroes folios that are !uptodate (before marking
them uptodate) or that extend beyond EOF to preserve data integrity
according to POSIX. This is handled in a couple different blocks.
Fold the !uptodate zeroing into the post-eof block so we zero from
one place.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mm/shmem.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5fb3c911894f..7925ced8a05d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1627,25 +1627,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * good idea to continue anyway, once we're pushing into swap.  So
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
-	if (!folio_test_uptodate(folio)) {
-		if (inode->i_private) {
-			struct shmem_falloc *shmem_falloc;
-			spin_lock(&inode->i_lock);
-			shmem_falloc = inode->i_private;
-			if (shmem_falloc &&
-			    !shmem_falloc->waitq &&
-			    index >= shmem_falloc->start &&
-			    index < shmem_falloc->next)
-				shmem_falloc->nr_unswapped += nr_pages;
-			else
-				shmem_falloc = NULL;
-			spin_unlock(&inode->i_lock);
-			if (shmem_falloc)
-				goto redirty;
-		}
-		folio_zero_range(folio, 0, folio_size(folio));
-		flush_dcache_folio(folio);
-		folio_mark_uptodate(folio);
+	if (!folio_test_uptodate(folio) && inode->i_private) {
+		struct shmem_falloc *shmem_falloc;
+		spin_lock(&inode->i_lock);
+		shmem_falloc = inode->i_private;
+		if (shmem_falloc &&
+		    !shmem_falloc->waitq &&
+		    index >= shmem_falloc->start &&
+		    index < shmem_falloc->next)
+			shmem_falloc->nr_unswapped += nr_pages;
+		else
+			shmem_falloc = NULL;
+		spin_unlock(&inode->i_lock);
+		if (shmem_falloc)
+			goto redirty;
 	}
 
 	/*
@@ -1653,11 +1648,14 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * traditional writeback behavior and facilitates zeroing on file size
 	 * changes without having to swap back in.
 	 */
-	if (folio_next_index(folio) >= end_index) {
+	if (!folio_test_uptodate(folio) ||
+	    folio_next_index(folio) >= end_index) {
 		size_t from = offset_in_folio(folio, i_size);
 
-		if (index >= end_index) {
+		if (!folio_test_uptodate(folio) || index >= end_index) {
 			folio_zero_segment(folio, 0, folio_size(folio));
+			flush_dcache_folio(folio);
+			folio_mark_uptodate(folio);
 		} else if (from)
 			folio_zero_segment(folio, from, folio_size(folio));
 	}
-- 
2.51.1


