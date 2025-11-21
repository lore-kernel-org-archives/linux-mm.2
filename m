Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E199ECFC283
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA4C6B008A; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDC46B0093; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992A26B008C; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABA46B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:22:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7CF114027E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:57 +0000 (UTC)
X-FDA: 84134981994.11.0D9D442
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F7F940011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NqiaGcos;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763738575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrO7whhuhcU7UtzGJbs17AJe+nHtGirb5odxFjKJkrw=;
	b=Y5jnHNVk+Leoe9LTMKujUYBipnsQSihZAVVQ9Dw+8typ+XHAcBpDR+BkK25ADJ5InSFt6a
	trOvW6gdy0/tHhhbk5utcWhK6UmkGQT/0yWWY05koRmKdRedZ3aT3HPXwH8iIz0XssbMVk
	aumAsTLQEz1W4PiLvRjDGzCKxNIx9Bo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NqiaGcos;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763738575; a=rsa-sha256;
	cv=none;
	b=KH/mVtOEWjNRzIvAETojuhgQmUUPmVY462c2J7Y3VHSM7A1I66DOzoV68PHhX/Y5mdkcr5
	b5bUa2KUsGRmBTDZIwcePNGIt7yPIRD+Z/uEv9xQdqIcHFy6D6L/g5BMtxT7Jz6BN4d8tb
	3YNzFStAhm+fjjVmxvuYbe0XSA/nWNU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763738575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrO7whhuhcU7UtzGJbs17AJe+nHtGirb5odxFjKJkrw=;
	b=NqiaGcosqL9kVC6FQQWLZsoI8wfom9IDoPKLt/AUlSg+GKYb7v0q3Q8YumP5fQ0lyY0dmY
	8iD4jt1iOxnd4bkwWEvIb0bI4yTzmKA7kHCSNuOfoLENBGyufBvAfUI+hFFqg80bwh6FT5
	fu+yUCwu0+Tep41kYB4TCgjYVPkxCZw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-kZIv6_VVNnmgixYAooItzQ-1; Fri,
 21 Nov 2025 10:22:49 -0500
X-MC-Unique: kZIv6_VVNnmgixYAooItzQ-1
X-Mimecast-MFC-AGG-ID: kZIv6_VVNnmgixYAooItzQ_1763738568
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A87A1954B06;
	Fri, 21 Nov 2025 15:22:48 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2A43180087B;
	Fri, 21 Nov 2025 15:22:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v3 1/3] tmpfs: factor out folio zeroing logic at writeout time
Date: Fri, 21 Nov 2025 10:22:44 -0500
Message-ID: <20251121152246.1023918-2-bfoster@redhat.com>
In-Reply-To: <20251121152246.1023918-1-bfoster@redhat.com>
References: <20251121152246.1023918-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v8BxiZPW0Y-kWFwuK-1l_4yr6Kf8njf3jim_mbolt9U_1763738568
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9F7F940011
X-Stat-Signature: 6ngmkg4e9uktccxmntycxwhqje3q64ed
X-Rspam-User: 
X-HE-Tag: 1763738575-277404
X-HE-Meta: U2FsdGVkX18YTvtUj2Oey1uJUZVQLlzoRW+yh5UcL4xDoftN9AJP3eArLz+8z2URA3vgh+GIebR+8mGucuBazeZNOujTXwVxnWBVbInOGFv/XzBanFmk6xYCH4yALKo64rVJdzDx6XAnDuAejT6ikkbHzr8MzRrm3ALqh/N2qf4dwF1VIF7VndWmQggdDG/pW3G4mU3hNB1sESDLK9XdX9FonPdz7q3ESn+/0GOqOwnQdkiYp6O5yX70rWyAB1srICNLz4xhtfwKExI4yPzQJhcKGtv/G+Nzwh1mD5BbW91sJSU75aoHJH5CGIBk3N4VNU762kyMLVh2qgsJAXJuivqBDyS+uKhVVa45jZFzbF4WpWhet484iSIZ+pieAd61/ozhA0rkqhQgOuIx10ZUSHi/X6x/IDBRqAI90bXIMhHWD/mBfSX2tpPaMostGDNslaiz2ZHlmFPsJrNYPpsJ1une2MnbvoUbLfMZLu70Xo4/KmP4/QY2zX0iT5XhXpSWceDKk4gFwDfPYJF9CeGPyJt24+TBxjUsvNSiANvV8DwoUaJVPa5zLIuEdtkVWz4xtHkzCvUP/r+R4Ht7htfXRD2kE3QWe0u/GCr6EF3e5Ew69NLbkIgDDv/T2NEz97+8fGHOM0PPU7ipqdRzuy4IShZYcgDFSFp8Z1JI99QO5GIqqYSK9ZOvtLp34EPmuWaICFPKrhDgQoJ717zqhKOeeXMczdZeC2mFUHjvrb1cUU0yK0F8y61rhCnjCzrTkjSXdvle4ZXt3ONRkMLLo4CDPORBuYLo7QHXcK62osRafMXvun4lhDnEEXKiUpm/RDEck0e05BXM95fW+xGljkHYf9SnqFHljPDwogklamTdT5SJWKxgAkskecsjosbjxFaAkunzM9q/SdLcm6j89MZZZPDZ0Ydk5SiEgTYm2bIAKkci1Q7KGNGw2/Kpv/7L78Nq9blXXGqVkTSBqCpngnc
 1MTFFbC7
 9XLJyg/DMq/PAv3QdTx18sukSqF4wjZjmHzm8N36P31i2OSmhdJMjtxGY6xY873z1rJPnyGJVeosau88ThWDnCh4Vvyn00G69mOX2urGVWGcjl2LMLj98V6G7NjNsxANSKGTCLGcjmgu0zjnR252q2m6TU7n1/oZ/CFbnooB2NNAghtrJ14x7HDxVwGBFOQi31YSW1FG8JoSSxz5XUoIjyk/hXFlY9GRpJYdwdXkimdrB2lxM3cQYJk5J5OIsSYfXTUZoFYpKkkVi9dbHqj+RGNR0s7ml3MGOs/Pefh00jNsaJqWEEu351rTL62HF5zJgs9mfSH/Cw+/xhLc4ztWIh1CQnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tmpfs currently zeroes !uptodate folios at shmem_writeout() time to
ensure they are zeroed in swap. We want to expand this behavior to zero
post-eof ranges to better abide POSIX file extension requirements. As a
first step, split out the existing zeroing code into a separate block.
No functional changes in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mm/shmem.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0a25ee095b86..651602460770 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1626,22 +1626,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * good idea to continue anyway, once we're pushing into swap.  So
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
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
+	}
+
 	if (!folio_test_uptodate(folio)) {
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
 		folio_zero_range(folio, 0, folio_size(folio));
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
-- 
2.51.1


