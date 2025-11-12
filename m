Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0BBCD3420
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 16:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C0B8E000B; Wed, 12 Nov 2025 11:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C118E0002; Wed, 12 Nov 2025 11:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B4A8E000B; Wed, 12 Nov 2025 11:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FABD8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:20:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C4771A058E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:57 +0000 (UTC)
X-FDA: 84102468954.28.EA24491
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4204CC000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Djvyhq2V;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762964455; a=rsa-sha256;
	cv=none;
	b=Uwyk9redvn7Hnja11wej0YI0D8+9VHLBZk8YRovflESIBdUmZPEYMZaItPQ8oAVEPc4eSE
	eRTljggosPjdSLgN9g92Y3lWp2An7oC3IGgpeVq9NuqI5jUk/nVvSZJ7gChnFyeVLl1j4O
	7FONmX+fuXspGdp6HXQmYKx/BySpQcg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Djvyhq2V;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762964455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUnNpzH1K5Q3QUwq8YbkUWhWqv3nPr6h1FM/qan1yhU=;
	b=jaV5S/NAHkqedH27jhGOm5j1iOJt+s3oXl/3+sSkzdsYi3+WB3Poa8lAk7bRll7oy2aXdz
	BoAXcccTzcUxXsc4YMWuVTxYB02PrxkBreTbEo7xJfM1kRVsahVDApQpGEJYLW8wv5f64I
	vXMORSCtrFtfDq4I33TfMfw2ahYX7PI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762964454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUnNpzH1K5Q3QUwq8YbkUWhWqv3nPr6h1FM/qan1yhU=;
	b=Djvyhq2Vv0AntUHqRiznWVRukIELwvO5tov1Gz9HywmmvB7NamOqSMYGvX79zDLS9WO2a5
	u8j2v4RKbI9Ff0Yo+L1ox6F9LzBQiNxA0uUUEkGEtb99vsj0Nr8YzZKz+kU+OMNY9/2fhI
	bCl37kwbqN6dtDsPnRVA5WrhfY+3ZpI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-2lcr0vqwN2GSscYKc966VQ-1; Wed,
 12 Nov 2025 11:20:52 -0500
X-MC-Unique: 2lcr0vqwN2GSscYKc966VQ-1
X-Mimecast-MFC-AGG-ID: 2lcr0vqwN2GSscYKc966VQ_1762964451
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8123119560A7;
	Wed, 12 Nov 2025 16:20:51 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89400196FC99;
	Wed, 12 Nov 2025 16:20:50 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
Date: Wed, 12 Nov 2025 11:25:20 -0500
Message-ID: <20251112162522.412295-2-bfoster@redhat.com>
In-Reply-To: <20251112162522.412295-1-bfoster@redhat.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VQfAm9v7kCHJMtdLsusUHcm-YCbAQj0wELMIuxyzHtI_1762964451
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4204CC000B
X-Rspamd-Server: rspam07
X-Stat-Signature: ppeoto55dou8wo7qptktsk1jg4wg6p3r
X-Rspam-User: 
X-HE-Tag: 1762964455-665651
X-HE-Meta: U2FsdGVkX1+pTkfGXSNNT1oxMCxMGzvPVKn9YKIndZRnTC72dhElE2hRBpMnVaxMrbnHIX0QrIvTV+fWxg+kP5dd9SeTIrK7djaZv/qSBVA3TjLXdhKZfVLXESFotjVTrSQZSTNcnypvz8ntwuDNTNCyyHykoDAbac4mQq9BHv2Gkfm+qpxx0UE03iVwMgkHhRhi7nDNpSxesNriGyhEqX+lm5TXcZ6Gq6Xf0iePCkehfbKHhz9S18VHwaYl+mBvh4oVA9IVKED350C6MKNQu/We2I5B+IyssL0YOt92ozABYKq55SiL3bVTFHyk/MmgraEVCRIi2G27eqZzSkBCuTjM89whEgNKR7U5doo2rEUwTu1dItLD4DhJq2tWnbjXrircr+HivjAmewyMEfp6b/1OwkMYXiiSu3xctOVe0q+k0bO0MygL+807gfv7vFu69tDBA9Ad0ODuHqY5iTgmZrPYf7FadhyBW7Lc55EWL9ZWm8+O+LOrA0lBsDxdD1RUriNzsEe/FIxOqrEYFmr4fKSdEyvc9iICV2MNb63SFQBZnW0ny8/8KZ+FPjH4L85wSjY0TfQB/UuZCt4qjnHOXn4M87DBSRrjTN0SopoUCcnTolNxLp/gMui/xMq2012tUISiuvXs7Tdm2tL4Ehg+4iJ4cNqXJwXzBA5VSlYaS4fEFnyvl4kpDzbTkvKRqBG5REdkedVAClyBAHL96c9+lWGSmHUDXF/Xd7gr/ZrWqxUHJuxRwD+hPHln7os20viRGaeY8vNQRFhrgkC7/G8aNSHRC8Ekc1HXoGj5OUgPvxSxvzEdG7t6y1WQqLlRTC+7zJaY484SYcj3aL386RneznC1p/Ut7ws4IAsGFLWPuwBB6gV8FxRrhYc69wybLfK7+H59CQT0sdYeSurKXragD/ae+CaFzVziDKVqnf6MS88iCREhACKLtaGq2MpENlvHMi2Ht958tTl0v5wRcID
 S2K/bk6n
 ksoIWr5MUuORX3DryZxwgQUUfJeSRQTLWIPy1gbDfO/MO42a5d7B74crXw2yUecvbGrOMU1ixy4Dpn9PmkzGcZgWYc2wNVSLOoBQo+0MWmcljjanz/KPQ6DQUBBCF67lCDk9SrcN/4OPby2Jg9S4dQEIbO+T+RcX5zCwoYBSC/CDLI41c1NBG0HE/XJjCGHXNEpV8D3aUkCuGjTXW2PkiaK/4v4o/VTxKUn428PAWhSMJp8+SlOgjN5q82MGALA+mq4Q3vG3vv823QrqgXYYCOMUpBlpDsDhdU3mbJiTIOFr4Z5CH3AxjFHRUzZAvv2g1bbodP2z6EVwdvjRL2kV3xBNy7pwfB4ZZgF6GTCUMELzARp6aI+r1PuxibQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a first step to facilitate efficient post-eof zeroing in tmpfs,
zero post-eof uptodate folios at swap out time. This ensures that
post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
pagecache writeback) and facilitates zeroing on file size changes by
allowing it to not have to swap in.

Note that shmem_writeout() already zeroes !uptodate folios so this
introduces some duplicate logic. We'll clean this up in the next
patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mm/shmem.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0a25ee095b86..5fb3c911894f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
 	pgoff_t index;
 	int nr_pages;
 	bool split = false;
@@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * (unless fallocate has been used to preallocate beyond EOF).
 	 */
 	if (folio_test_large(folio)) {
-		index = shmem_fallocend(inode,
-			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
+		index = shmem_fallocend(inode, end_index);
 		if ((index > folio->index && index < folio_next_index(folio)) ||
 		    !IS_ENABLED(CONFIG_THP_SWAP))
 			split = true;
@@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		folio_mark_uptodate(folio);
 	}
 
+	/*
+	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
+	 * traditional writeback behavior and facilitates zeroing on file size
+	 * changes without having to swap back in.
+	 */
+	if (folio_next_index(folio) >= end_index) {
+		size_t from = offset_in_folio(folio, i_size);
+
+		if (index >= end_index) {
+			folio_zero_segment(folio, 0, folio_size(folio));
+		} else if (from)
+			folio_zero_segment(folio, from, folio_size(folio));
+	}
+
 	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
-- 
2.51.1


