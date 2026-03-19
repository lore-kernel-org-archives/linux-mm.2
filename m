Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA639107526C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B50A6B040C; Thu, 19 Mar 2026 03:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EE76B040E; Thu, 19 Mar 2026 03:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006BA6B040F; Thu, 19 Mar 2026 03:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCBA16B040C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:13:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A148616040C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:13:50 +0000 (UTC)
X-FDA: 84561947820.10.85CB713
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3BD81C0010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:13:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=bl6C6JqH;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UT1ydfwXPd3Q3RW4yJjBz4iIolylIWtotzA2B7Dbsus=;
	b=ZE/Ymmq3EdRdiGwpYcNKzrNsTv4oiy/eZZHMJ1bLsoKCHquoExEnFiSgChqv7IJ85q8qzF
	tys8yloFnvlxLy4zsYPdGdUeKFhp/ga56W2GAzVLMjXAqxpZ7x66R8oR6Bdc9vkq5AJHg6
	Oa6PQx3jzeYTPX32NfDwUx00DopvhPU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=bl6C6JqH;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773904429; a=rsa-sha256;
	cv=pass;
	b=NKG//RrSlTyeHS1hJCY150CT85jCdq37IrOQ0BLiv3FRZw0Zs5UDtc0eytF4ULo+OLdoWh
	5OTrM5LO0b89oluZayRrKIHTspnudcKcw0oxDf6uQLM6w/KNg/KCAhaF8YCMGu1W2Itycr
	SPgdQ/xFG0IxDyPNIbGMmIOkYdNm6ys=
ARC-Seal: i=1; a=rsa-sha256; t=1773904417; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Ad24VfB+MUKu68AZvMRzCGH/b1nuGKsakSv5Zjpi3xe68he7O2d6BLkLfZ1sGp6uinu3v/5ISQxx2oEvY5yRifV3MN2WH9+9aWCqaeEQE6+Y+VdozjdEKKddjyoiTg5N6c7de3oiShy/4nstmqWGdOsT4DN+PYSSokxIsjUeyPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773904417; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UT1ydfwXPd3Q3RW4yJjBz4iIolylIWtotzA2B7Dbsus=; 
	b=YBpcU24zmCm6mEIKMoLUWbA8ULRd5XcRSaIG5cS1awEWccyQq0E3F3I/HnOqxVAq2vfLeYpzUtj+rnKTRkJijQpFfY4G74zeUg5UT9V0ZxtArv8bQch7PENwvxNo+zP94kFxsfnlFdq5eGKV8DTHS2Mgn57sQr5LhlVGYGjnzik=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773904417;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
	bh=UT1ydfwXPd3Q3RW4yJjBz4iIolylIWtotzA2B7Dbsus=;
	b=bl6C6JqH07NsBSuzRUhUCG6GznJhwrYkjPgFUwaK3Tb9gf+a/A1mhDRN4vy+ZaXj
	tsBgfIOHPNww0ZqEe35xb57GueeZ5LTlA0W5Qzd1tmgFuQAfqSZJZBmctQFkUNKlvG1
	DI7zpjBdVTX1flAHOIWvJFiIx81RA4CnjdyFFBTg=
Received: by mx.zoho.eu with SMTPS id 1773904415172769.0909205214978;
	Thu, 19 Mar 2026 08:13:35 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: document damos_commit_dests() failure semantics
Date: Thu, 19 Mar 2026 07:13:32 +0000
Message-Id: <20260319071332.114595-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: A3BD81C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: 6pwfz4szygykoxnbyrhb6h4ew37ih6sf
X-Rspam-User: 
X-HE-Tag: 1773904428-219233
X-HE-Meta: U2FsdGVkX19z4J3AEQ73yq0fQsNna5asJl0fGt0DD6CplQKl1KTfn09t/73c1V/tzNDiYhEe6zIdAIuGKgPqDN1kRZvZZSE5nC7G26NFfDU5WrwDmn7jo7afVz8ifHLV+ea8iNJrEYvPTp9YT/vTEV4rTUmExVC3l2e6mDg/nbUc9XgRc1I+OIG1cjyMdlVUHJB57zTCsZB6Hebrc9W+cgytq/czgKVKx9PirOOo3Cc68Ht6q5z85krBgBE5HcG/B5kE2jFWYeRMdQgNtmBhUWjFdCpTAaH9uuRDqiHlqH8FsnKDCcr0W0bkOXwnl01VJc3J+sF7d6tUd9g6nE6lFeqWlMCXzJWjLzTTUMOpuu3qsTZcZa7q9mSt4WWx5nN+pV9ZJ/wXIKGEdhBge8+XufGPGqWerZBGfIYa+Z7cvJ+6nxgAg4wT/WYQlAtBjGuYP0bcjNb2pMxFQ0HRSzVgB6T6LmRY7rqm8oR3m4s9fotZjWsIBcgYcWy/CSDTXbPQYPINi2LwI3XDENpgAFpRrt3OIA31nrj967mYQoEgfxOkW178FFNAdfjx/8dWIG/6evmfSYS8HzBa+itOiWJO6rSrr4lAWkvuCysW96xT/kcGD0lUsqYFvhmjBb9R55avhrxu8keJrDAOoVH4ZzlrPXb9HmtopQa1boiuZEgC1INBjUk/K/nt0Z1c4lnC6+rSQsUinvN3ENfpraE0sKtzJbgSkkIF9BnnkHNi11ErN2I1+I0rbPBPKINAT8e7JqqHEcSwUb80kxdGBQwe74tnRcvxG67QJV4gnUGXTrhc0TKOIYjTcJJRVoujPbNfdXcPWfXWi5ioEE3XeciUZQkpJzcxXDHtjz9+Vum++UCSJB3MyOfkU0Z5R9AkM3PiV5ewNofvRfxT5cSwc3bw0l81rXLSdWSNlDlPAG6o88rU1tZG6vc8M85eRY57lcGng7la4Hqj6kwnGs1pgLkqn7A
 t6HvaEPF
 KpoupH5wCH9zTFOmYotqN7ORYiB9GUFGexOvpwOHdw7xiecMCW6XGaIzwhA3KO/1tgx1zsNj9hWDTJsZ/ow0H72gWe1Met4hvp7e+lK3GNWteB9sx0qEgEMRC34/Ffy8lzEb+TUBWN1xJ7yu/WZ0AvnbeBk8QO2CJ7i+xyeg6dk81CYMAx/9yEcAFv2EMUvpJQHhVJyJnKeS/MgP5bILG56PgMRsAR3nn8FOoeAGVk4Kbip40izaJdseErILS7C7i0cV5AxFL9+1hz0TQUdi0FYGxYEimv8W6JXWdkiwbkLh+LZTmU887Lyw5+SvnYM7ng4ly1wwSDn635dsQ/f8Qbxfrq1NuYTLuIuPR4BJE1rezE+hkEHX8kVMTL4v9TNH33k28mk1pnZQqS1Xy8FIp2MS/TceyAhBUoBe5mQY9Hoel3Q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kernel-doc comment to damos_commit_dests() documenting its
allocation failure contract: on -ENOMEM, the destination structure is
left in a partially torn-down state that is safe to deallocate via
damon_destroy_scheme(), but must not be reused for further commits.

This was unclear from the code alone and led to a separate patch
attempting to reset nr_dests on failure.  Make the intended usage
explicit so future readers do not repeat the confusion.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e233eb84a2d5..c884bb31c9b8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1054,6 +1054,23 @@ static void damos_set_filters_default_reject(struct damos *s)
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+/**
+ * damos_commit_dests() - Copy migration destinations from @src to @dst.
+ * @dst:	Destination structure to update.
+ * @src:	Source structure to copy from.
+ *
+ * If the number of destinations has changed, the old arrays in @dst are freed
+ * and new ones are allocated.  On success, @dst contains a full copy of
+ * @src's arrays and count.
+ *
+ * On allocation failure, @dst is left in a partially torn-down state: its
+ * arrays may be NULL and @nr_dests may not reflect the actual allocation
+ * sizes.  The structure remains safe to deallocate via damon_destroy_scheme(),
+ * but callers must not reuse @dst for further commits — it should be
+ * discarded.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
 static int damos_commit_dests(struct damos_migrate_dests *dst,
 		struct damos_migrate_dests *src)
 {
-- 
2.34.1


