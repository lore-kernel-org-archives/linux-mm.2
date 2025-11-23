Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E12CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 13:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2B76B00AE; Sun, 23 Nov 2025 08:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53956B00AF; Sun, 23 Nov 2025 08:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69576B00B0; Sun, 23 Nov 2025 08:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9116E6B00AE
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 08:28:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D70913C14C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:28:09 +0000 (UTC)
X-FDA: 84141950298.23.59418FD
Received: from sender3-of-o55.zoho.com (sender3-of-o55.zoho.com [136.143.184.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 438BE140004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:28:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b="ECX/9Qks";
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763904487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z4sx3QAQovEdKwkSldY/iP/zggzig89C+MwICVRnPPA=;
	b=2d9pru55pqzlnrg656UHuaUyi6Q5zr2lLs1ExSb5mzEhoSZSS5Ip3O6iRrxmHwiIDB2TfF
	UxyrOerRBDWSH44Z9zx+/FeZpi3G92KIFELTrMZz1hYZGe4/q2Km21WlyevEGCaLQ0+Lyx
	UTSY0WUAsawyd9qYDEfiI6+llQXg+eM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b="ECX/9Qks";
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763904487; a=rsa-sha256;
	cv=pass;
	b=1mBQutsyfDKk9xBAnWSSY/y9YdAMVz6Kx+zNlE8yJTbYL2F2lNINgA/TIaKE0m/EiUeZOG
	kuyLwmyxTXvHH5w4+1sfmHtBUgSJYvM0SESMIv0P33771IfKolLCVvc9OySmPEwwcRNNHF
	u+OypszCevXDEXlK5s0MWEYtJKIscyI=
ARC-Seal: i=1; a=rsa-sha256; t=1763904459; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dKCZOky5DTPQCCdJmO4uJEd2D87LxCHbV1Hj1niOq4imoazWQYETiXyBH3CUItguPbNZoLycTM7tUE6dRi8zRqJl8cBCaZpl0UafY/TP/d9IdgfIR0u9+aqdxRa3eQ8A4y6Qv5eazgz7ZbjLqAW8HCT3r3W5dthQC11J0+a4P40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1763904459; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=z4sx3QAQovEdKwkSldY/iP/zggzig89C+MwICVRnPPA=; 
	b=CSLznKNllvidbFG5M6hSuImdprxL7CQOuA7zc7O3izqXlBAok/4ig7XYCQnag3b3ln1qBuIZn6kR511XX89Wz2IjQAXtM4Irysw4D8kX3g37oZIOz8oyv8i1HWI8tvNAYf6U9keBTwkA3BY2EkK+Zp02/Cd76ReTPQu+dBI7pWo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1763904459;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=z4sx3QAQovEdKwkSldY/iP/zggzig89C+MwICVRnPPA=;
	b=ECX/9Qks5EKECsuvXHwYYXd+vwCjZd5mYkEf+kQ9SO0kLT42zhKvWjPeqktrHoAD
	ERl53Aa/+Zt4Pa3V8pebSeWbDZouQaUZmp25HoE43vOzQQDgugxl+u4U62Jhb1wOdTA
	v6QZmjhyfPVj9MxEBtyBh/zYAaVMCkvTRSNEKCjE=
Received: by mx.zohomail.com with SMTPS id 1763904457627667.1956568921231;
	Sun, 23 Nov 2025 05:27:37 -0800 (PST)
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: shardulsb08@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	janak@mpiricsoftware.com,
	shardul.b@mpiricsoftware.com
Subject: [PATCH] mm: khugepaged: fix memory leak in collapse_file rollback path
Date: Sun, 23 Nov 2025 18:57:27 +0530
Message-Id: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 438BE140004
X-Stat-Signature: arwwm7dqp1cjsejsgbpu57s7gkbwpa68
X-Rspam-User: 
X-HE-Tag: 1763904487-114718
X-HE-Meta: U2FsdGVkX19uFw89HWCKG2idMfSPnqV2fRaRqu4qKzWz2MfW25DTAfbhN/LB3jSflBKxz8E9qu0MOOcRKzNnS9ZPssAD+OiCjUTqSHRsGqLX7MMtSMtnlCNZ3X3j33WbySvnPYP+23sI8ZLGXToG6jJ/ghjTFWIVH7jcR3otW9ZknTPiOvNI01/gGUng7SgDqFj/YrTUeKYSnD4aeeOeqzU2WBOdjLsGcBf23wBZ2+gXECaOeNwD9GANGhPYbXIlT5PQiS0D6PQXbWpHg2Mpk5T17bKJCb+XGiCVJuzABgJPWkuhXNZs6QUZzoS9X+jpzv/lkaA5M8UsiTWAGisF1Oh9ykmJ81qy3WIxToRjRF6P8kqPLx7ZBe8FRBGjTHiQB5jTyIgrkpNwPfvi7cXL1uZskWSNcB2B1BTIoeVuReTUtRqQKp2NcUaeHIwgyp/X+LzE8xJfel/JBN/E4xExtLKWSjdXGHPFNh49QegVHBA9xjwYnttqcWOjqR/xh409En0TugTeZRtqpElgyY6QJCqRbB1YZ3lEUt2I/7wo+xFq8WqfnP0nTXovHHM81X1CeneVIgwdl9lMQC0mnAAmNpQby7tV/QIrOAuTtKYjTc0B6hSgN2TX6Lrp7cPjnpch/jSPU1sHPEp+6s9QshuNDEW+u+/NaqqzXswa8+iLXnxXb7DOATVy4ufgp/3LqgjFMvfFRSPvqu4AWmnPiHpc9OhXtWtC8mI7G9r8HrrEpXmnLr/M/i1ks9Fo+0JBC8Yp4oVtUgp46L/huVBTKqsYPsVYtsMCc9Gxd1Jl7Klk0KTft/VhPS//enbXjrOSGkHEa3TbOgoeHfmChJXVWvl+RoJ9JuZLSxFBXgYqkDcHLxg7KhFMLSyDDRvDU0YlrAkoqsQp2MDOBsl27lq9BaiS9CunrA9QLvLjlWcZ75tJOBU3MZ/WKNcOn5mzI6nJ90+eh+mxRCPYuLh2BcIz9lj
 vF5hjodT
 OjXrST9gPSZHObAVpSBspyrlD6MvY/kzy+PsZatfC4aKFVtiibIHvXcYFOIEtL386aMlmDGWi/r1oAeqFTZUksfC+L/W7MmnvxkDhd947NxTVuT8RF7bxLR5KUtc28aW6NoMno6Yrirwa2Au/uXh6GB3SM6bPTOtlA1CZm/0QwW9wO9NyrxVFvPWQ69+4K+KoYbrweCXNn9ZDc7Kf6L3HnD0wDvhyiMACuKpK5riX5/DEUJBAU9f9ETwi3dJFoQXy2SjyRn4omzEtZ/xLNDlnBacxS9SzcW4zz1GubcDmLmAH4ybKJBNqE6W7Ig9fn2rhwjppRzzKtDiHn+cNj/YIUso0Jdj1wDHsmo47cPG3Drw7T5MRSfEnMofFSqQbOD5Mkl3pHC+ZZcTQjqdMVVDaFpTRoQelpyZpItcSigi9OhneDg25lnQS+MxDQzbZiyyaHgFpYrdru1dmmHtEGPMuXNKSVOuNvnaa4Tf+u6CUFaY2jxCzbTKXURBLA6t/pobATM7X7P5MdWX7qoGwUNOJNS1Mrmj6PYy9nAjnvHgjxBLlCPnukftTP62DuSz5K87ZtWLv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse_file() fails after xas_create_range() succeeds, the
rollback path does not clean up pre-allocated XArray nodes stored in
xas->xa_alloc. These nodes are allocated by xas_nomem() when
xas_create() fails with GFP_NOWAIT and need to be freed.

The leak occurs because:
1. xas_create_range() may call xas_nomem() which allocates a node
   and stores it in xas->xa_alloc
2. If the collapse operation fails later, the rollback path jumps
   to the 'rollback:' label
3. The rollback path cleans up folios but does not call xas_destroy()
   to free the pre-allocated nodes in xas->xa_alloc

Fix this by calling xas_destroy(&xas) at the beginning of the rollback
path to free any pre-allocated nodes. This is safe because xas_destroy()
only frees nodes in xas->xa_alloc that were never inserted into the
XArray tree.

Note: This fixes the leak of pre-allocated nodes. A separate fix will
be needed to clean up empty nodes that were inserted into the tree by
xas_create_range() but never populated.

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
---
 mm/khugepaged.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..f2fe7924afa0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2230,6 +2230,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	goto out;
 
 rollback:
+	xas_destroy(&xas);
 	/* Something went wrong: roll back page cache changes */
 	if (nr_none) {
 		xas_lock_irq(&xas);
-- 
2.34.1


