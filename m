Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F84F506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBAC6B0294; Mon, 16 Mar 2026 10:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2EF6B029B; Mon, 16 Mar 2026 10:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFCA6B029C; Mon, 16 Mar 2026 10:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBC916B0294
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:01:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8655914026E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:01:27 +0000 (UTC)
X-FDA: 84552088614.01.6AC4E69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E40DC80027
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:01:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C42kNjB+;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n6/CVwrBIrBRn312Lc89iD/Rji1uqlv4KD0/v5cXcqY=;
	b=wS/yDX4OwQdcfnZCnEDhg0qeLk5oVhoCqqJnHgReytVoZXliHEclCSFXhebkEOcVBmWKc0
	zcuX7PPvkMhzad3fUipoCBdm3D3wzSzj4d/StQQlQU0LbnkxT+3ilLRD6XRk2TA9mkoFp/
	PtrD9/cbUJPRM5W8FkjDHbM3O5lBQzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669686; a=rsa-sha256;
	cv=none;
	b=zzy8a/GruTcs290/OLO3A8sBbJyU8gXW+J0TabFD7+eT0+kUSZxWhXWRDW2x75U0CPVlz5
	WfUryBKz9xyvqPqHHxocqXxIeqJHK19xKRh8vU1Zk5EqOw4DKPE/dYAmRskysMAsScYzB6
	WtWEx+TWePo6uRp0ZFPD/rIr65MEc44=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C42kNjB+;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C8B43A9C;
	Mon, 16 Mar 2026 14:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4476BC19421;
	Mon, 16 Mar 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773669684;
	bh=8V3rRaEbinASkU1E4LwT5DYCKUX2xJLJs2DXJrkSqHE=;
	h=From:To:Cc:Subject:Date:From;
	b=C42kNjB+DOlpOn9IPsKKhkHGUEXdC3RsDDG1Dmr7sd2Xo5PAAsfKntUKVQRSey5we
	 MPaE41pWSq0BQzeaF6lyHQ7RlYTfYede6wdIhRLXoL7pSbirxezLtxKbDoL8ufLEsU
	 Mp4DJZRpaw2UCIJxHhQ+ciXr/H0/RkBa1Da6FudBvWYa/kdd9Fn9QQBKgDm5pIzoys
	 A/4n/8SRMgk7+wc+stfHF/jkcbR/iZRuHpmTi3WgqAxmUUiRMRAD7ekoJwanLFxRvz
	 UE5H58jBt/EqRgVvdJ46JHVC9i1ufQtoJw6KRq35RAmb6MduHhI2fT4GE37+ju/vi0
	 hAhjND180Z2Pw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Date: Mon, 16 Mar 2026 14:01:22 +0000
Message-ID: <20260316140122.339697-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E40DC80027
X-Stat-Signature: ruo93zd1btw179h8jqqh9j95kqxdiuyw
X-HE-Tag: 1773669685-569012
X-HE-Meta: U2FsdGVkX1/7jf+zS7oQZk68pVgNHV1tGbDclgKoIfzqPaukiTpUUWYRxKfEkO4Ytqi+bKDJIhy/kfr9rNcN44xlGBHXgs8aN8gPbxeIDa/y4EeV0MsCJbsfktKlQLvXRokaAsowPpqg5EWJ2Aly6+bOzAXV4EorqcUqB0UF//3tlV1QNvfdaZXB3RXa7yOy6+W9xo6r7Ki4/3g4ryVo4v6bggc8NSPWooWsUgjCFrmiOxKcLHUx1c+IiPp5ulYhvwEUF9DdD5p/FRgyNgmY79kYQXxtSOKf7HkPBtWKDPxbqdIz85jeykDDg5krVgWmnbtUczyBKxa2DgAxyYkhs0xVNf/P3eA/+g32lL5mZZT8AnAAzdIMjnQMx7vpa0g905u1b4Wv5qoxGne5Ed+9QuIunKZUdo0iFrHKBAcVnNo1BNzkGDNc0uUA5P3h/AlYc5Ig3AAaOZe+K2d+EipSaSgxSlRb//QHLUHwIEg08dDmk9JJVggpGf4DFFnDbh7pgD5XXmUpUyMvft42pUh8wfi19ZYzQZQnKCEVBNNbrr/jiLdMTpEr5B+5gM8Ar8NWouRgCIowIdgR8OsS49/Q8f8U1k8fnToLXLnpK9PYHS2NFxXhzhY/a6axagxu7mJJ2O/zy/uc0xPnrulZOH1KY7gn+2WjN+3+1z49eDhjYUh+c95JEVhEVlx4NgnW0lrtWPjoUOjLs0hc8khj4u4XbfGehacj6ZYNGB5sk3WWM7SB3MvWTx5ZH4OYN8gFDeav5zyZgrclHIT7763JC5RsdJaHyS16Mat/Bas14wYD/xdWk/UT0YpaZq/iBVYkOU2KAJm5bXbs34eh/GbVUlFyVDkRBxKttYkwBE81Xxyw+pr/BY57lKbUdBnycvWsR2LWygy6D4ORkho7KKuCOSj3JQIRFX/OVidoLDKph1u+KEnKY3xQgwvvuinjo4rkco3NHBqafgrH3NhlNh9FQtN
 fw6ueUJL
 hw3dR13Mtr3THdarjflppMd0TKUhdKZK+EuvNw+ZpANKaWVWSck6WYJQveZaBY3jRWZDAA48n95y1dowdpx3A4RBxtByToij9DUz9sxMtlxZF9w+rzwMtrcyuLKyWckmhCB3nzsFYPKCTZztM1FX+lnaKUghDrNaLjRkgGVMjhS7jp8Wbah0Up3nk4DjnWmW3xFRWkTxqbdk5+3g/TVQeo1VUapqpoepga745TN6XD6hYscVU6bSLb0QJrbTp269YiZWOGO3+P0dgH0ihMCc+9gqb1FDQVPv4+B06rdqDu2DV1Aj7l63QxLoX2t+Sl8IA6A93VfRWMBgK/NU7bUHYWxrcwfEe6CLxNHJsaplyL/SEH4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
data for uncompressed pages.

In doing so, it mapped kernel memory locally for 32-bit kernels using
kmap_local_folio(), however it never unmapped this memory.

This resulted in the linked syzbot report where a BUG_ON() is triggered due
to leaking the kmap slot.

This patch fixes the issue by explicitly unmapping the established kmap.

Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/zswap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e6ec3295bdb0..499520f65ff0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -942,9 +942,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)

 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
+		void *dst;
+
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
-		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+
+		dst = kmap_local_folio(folio, 0);
+		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
+		kunmap_local(dst);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
--
2.53.0

