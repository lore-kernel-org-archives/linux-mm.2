Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5CDCEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36C56B009E; Tue, 18 Nov 2025 13:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE68C6B00A0; Tue, 18 Nov 2025 13:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC3D6B00A1; Tue, 18 Nov 2025 13:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAA7A6B009E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:10:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AEFB56500
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:10:54 +0000 (UTC)
X-FDA: 84124518828.17.D19280A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id ABB6310000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:10:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KGRhe/9V";
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763489452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qn+AjTDGoUktBthzjiX+VXPZpfCo/hGYtUUP0NyEVEo=;
	b=j1rhkZ0yvR9C6bwYS/R2Jhi0lAyCYzx+izj275XL9KQ6NbouaQh4g3y0Z6Y0SeJ0YeFx/T
	judDW1uwPNWp8H5u2CQR/O9TXGmBTt24t4VVFlb59i53ttYLk9YMnbYdYQDpHWs/0Uq2KV
	YW0AtoaAYSyUqzjBG5Lb5qbHSQ+CkvA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KGRhe/9V";
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763489452; a=rsa-sha256;
	cv=none;
	b=ZC/LDSS3mgBPrAG8yjxz/MKxWXGmH2d9GgNBWtDjh6JfIXY9IdpyorghmJjVJ3Ph9VGTsg
	LXyH9LEqz6AnVhKVQr3p5e3wN+I7/NzRKMDM796eVIghmW12y+lXuQ/yboxZ9WnnzWtzqi
	Rb6LY3+SUIxCiFKD7yAhsdOUmqquqEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11B456020B;
	Tue, 18 Nov 2025 18:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D838AC4CEFB;
	Tue, 18 Nov 2025 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763489451;
	bh=fOpeaPbF1C83S+AnriTWnUlfDJdmGqoTy8hMXQsnkJE=;
	h=From:To:Cc:Subject:Date:From;
	b=KGRhe/9VTVaNtHgMudCOU5AifM3JUAT8EBLPPuwbH0NsbWJas3sUy6iQkmuBxZ8Z3
	 rLqAm4yN59fr5UDfbN5AV5nyfzOc4bKV7PjwQc18uDy7+OlaeZVxmXjE7gwP+tA+XN
	 aYzJ9nGU65SSzcfzjf3PoFjz2Mh9Q3kfT9ZrU2RtvE9Pvegq/Qo6XGzJ+GiL1Zggi1
	 tMf8mb8g2CsnrTg2c5xan9f7UKsRyfD2hcNoWcL0FUtURxz/pQHXKN5lIz2XJldTG+
	 QVDZIvnvltc9exEtGnCkUaNCCL88dfNX8RURa5valgM46ZPSq25EkjDkU84BiDVD0T
	 Cmg/Zb1UfCEcA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] test_kho: always print restore status
Date: Tue, 18 Nov 2025 19:10:45 +0100
Message-ID: <20251118181046.23321-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABB6310000E
X-Stat-Signature: bzcnkqy1ik3mbwcnoiu19gom734o895b
X-Rspam-User: 
X-HE-Tag: 1763489452-160330
X-HE-Meta: U2FsdGVkX1+oW6ZDpyaOsYvFaN/Ci/kaDHZ/AvGZqu2S/wCkzJD8tiBEi8n/ru6JA8gPb6RWQdsustDqV6cJrfRzWpLx+cnlKzkShXNhKp90V8gl+8jZeyDxk4xjku9WZ2k91JLjsxEU32EvfjHWhPApVVTIQDMmIrxkNLZdeTH7c1gkl67My+WNK1xT0VZZOtj/uUdI/5GB0U71K+Taert/3LFyq4AqtwfOGB+dWZ83DPdB2QcrtM8Q352+RXfHG0w0DXvCiom7BNJ7WjqXRKqGozhLzAwVtXXI5+wpAegSXrjLiXt03HOtBdHpNXP6NPLR2AU4PNdIHqPcv5GHKybzX+c/pvg8PmSGlSS4rSrOXlMG2fVEKTiAgkv7Cl5d1bYUaKiepVxVCJ70EbxQg3Xd2fSJpZXSE0OqqZFR0P1spaFTuW3TilpVBJ50iKPeiTUxVUOYdOKGhxEZkA0DZnHd5F6CZTyumHV/XPxyl2lMLAloI6O1zFWT1zdTVLSmsGNiNtoIhqGR5Bsy0EfnlABmXCFBorT3CZPh7qGx5SJdDKknRk/kOMyHDpDa2GcSUQ31nxmN8JFKB6xTcgvYUsdjtQFxZT1VbYQw/aBxjJPXqKn8H4p5nl6H4YP8w87FJIQfzPiY/Un7TrYMPe7NkJ9aMEHSGGXsr56Bxps6k+C6t7g7hT97I21yg0A2yF5w1xmCkDj8jcxejgfYkrSHoWnKZQ2NbMqdvw9rb6x1tiLwcSeh1+3pdwH0I/2IHIhAS04IRDqYSNo76HChfbQlnJFOmbLypYnomEMuEcKsKB45qWj6xtIBi7yIqeJrvoe6yd1qfk4IXq6NUROZyAvO70pgSomqGzt2nNK6Gm7NGU4LQXGIgiqtAo3J87LkhqLyiVfWMOp5QHtMECWiyqrwWD0jNM/mA2eMpuHNTNdAeDpsYTr+ctoNADozmWeMdul8hg5KqU5onrCq5GjhDyl
 T4/TqAxY
 afiV74OM5ZHEyYhvDHL1wKoEGfwSw7mxDF114ETMAIYhWpRD9pqMDORpRD2U/4u0NIaXA2Gq2JQCygpPpFYFMYsgx8Aj0c6yotFdMD2+5fQDjCXUVKY1n6h76BXNVDi9K7q6fUjnU6T1pM0BUU0mYNsFptkOGUfctvYpoSEjogSnIPVpcn6FkbssOpaFRqKBmVTi2qyiRLq4Wh424l7MVMrQ1+iF8Q3hnWKLUCO6qC7SGd6bV8en88mi9TI52MpQpmXiWAUC1rqv0Zy8dg0LZ83JK3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the KHO test only prints a message on success, and remains
silent on failure. This makes it difficult to notice a failing test. A
failing test is usually more interesting than a successful one.

Always print the test status after attempting restore.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 lib/test_kho.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index 85b60d87a50ad..47de562807955 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -306,7 +306,6 @@ static int kho_test_restore(phys_addr_t fdt_phys)
 	if (err)
 		return err;
 
-	pr_info("KHO restore succeeded\n");
 	return 0;
 }
 
@@ -319,8 +318,15 @@ static int __init kho_test_init(void)
 		return 0;
 
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
-	if (!err)
-		return kho_test_restore(fdt_phys);
+	if (!err) {
+		err = kho_test_restore(fdt_phys);
+		if (err)
+			pr_err("KHO restore failed\n");
+		else
+			pr_info("KHO restore succeeded\n");
+
+		return err;
+	}
 
 	if (err != -ENOENT) {
 		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);

base-commit: f0bfdc2b69f5c600b88ee484c01b213712c63d94
-- 
2.47.3


