Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF71B606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=bG2aZL9w
Received: by kanga.kvack.org (Postfix)
	id B88356B05B3; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B391D6B05B5; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4EEB6B05B6; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1E06B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAC87A02D7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:46 +0000 (UTC)
X-FDA: 85442962332.03.506F47D
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id D02CC2000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bG2aZL9w;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880965;
	b=4E76EaeRIm+crPHSZR12t3BtMVBV5E2Tp73QykBHDuVVWEegHoOZDoanHC0MNxbNNdo3dm
	YiUuIyGg28zM1sbc3c1HevmqJQdnBODWJO8RbMIGCFkhfzyc5m6SdxeqU6zgmf6n5eNp4n
	HBCeZ82QPK0/LAs3HQSLW2QdbtJ8Exs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bG2aZL9w;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cePgYs30Bcn8pusEQOJP4B1julb/89naq18hmSuJpMg=;
	b=5EuxgYKj5N1qKbRglmjUfnC/1U1vp7T+cJs2LxOjS4vuVrBuMxLRaXYYqoDMx6RJiQBSKM
	uhwx6/vZ9YBDCjzqZngeP9AkvIml2jvJ1UbGMIeM101ojVSU/7Dm7K3kiSeHaJUffQAWrJ
	9JoX+ejATgMOMByfpV1TEeRg5AMC26U=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cePgYs30Bcn8pusEQOJP4B1julb/89naq18hmSuJpMg=;
	b=bG2aZL9wLtwMoR+eH6Ptsaon9AHyEhcKp9zMD6fLo6qLqqM7R/wqIkY1ACQdFPdxlYsVYTnQH
	DwVgjobhKkCZalHRUUoxXCLw6z1PSAe8pMtQ8MNickJe9vcrT9wTnvmfi0UNfvIFqMsHUortU94
	yGy7a9mOWxaNiNQFhlYDycg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jT7Jb6SlNzpSwK;
	Tue, 17 Nov 2026 10:01:51 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C0B040579;
	Tue, 17 Nov 2026 10:02:39 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 10:02:38 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 2/4] arm64: simplify pmd_special and pmd_mkspecial
Date: Tue, 17 Nov 2026 10:02:35 +0800
Message-ID: <20261117020237.4037980-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117020237.4037980-1-tujinjiang@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: D02CC2000D
X-Stat-Signature: ca87a9qu65hiptfksbjx5defbkonq4xu
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794880963-603845
X-HE-Meta: U2FsdGVkX189rrJlPjWebrhtT2YfBDfX/CdpTzmg6EUJKQTU2Ry1qjcY4rGsdh8Pvz4LWCV5AYpZ8arG3Hm7hz+qKMWWYV3GHa0LEzuIWJ8W29gjlyVZ4YZbbCsxIqMPfgA2emwVYlCSCJlClce0pfePORTWNevhE/EFgkthBe86JheFDs49eBmiV1i7IX+llAqea9Suf1QmQzu4+Bq/vhrvjCq7SxRBBQPrglAacn8wTMKvrJDj1nj7WwrGF4bvK8cd9qXuzx4Lq/9z/73YmiiNwxNMPdya/Lp2dY1Friah8D1T8H5xc9c3DWqoQSl9DpJ+r/OIdaudXEuRepzpe9RIS5No+8nruy6WKOkiSsh0MSIXOLTEo45/Njo0xWBh3P6jyvTUkYw1UJo3vg3rFP5bgVxadxsUpZB3Ll3SNpplT/D6y8Y53XBSkr8JUeFxwBSJ2uUYtF9N4MfxQRnir8R3s6KvZVu6EapO98sxflXPGZ9345qrCueLIqykw1Wym2iUvl/Da9+CfZXYQfZ2OM5/8EJtU0vGOCUmkHNwCsvJvYJYu0Iu19lzypN1iT8/BjT3nFLiTFvq2JRfojuiOgIN4Xtkwd41gMiyXiv3vnYZyIETx1Tg94O0qZSmIBV8UdxZyxtq0E7chS1VM9TEc1OTlnT4qgbWofjqFQtVWmecO/+Z4+3jR/i4c86XN173zFy9kB8W2eMpB/njD+rr2czXRfT3NAB3I2P6+RXSOW1BM5vB1/2qLRWGIDLfvAa5vAAqulbhZfJH0RJXtPgHAi+b1CH2AvoH2dXL0IoMfn5UjiVWyX/nLu5Q/zxqqOT+EJ4dvi0lHfiAC8GzxWVkeC7R77VgVVlmH92a9LTsmSPHtHu4mKeOo7XsB+a0gfP9Q/c7cI0nUtzVTVV+bgWh5bCmspSpqmPAzTtchl35Lc9H/wqM6l0RnPLLgM2xsQ1LzsjPM/wLdNhzV+wr3nB
 izHi99q+
 /KsPn5cZSLHtDxeA9B1X32ZR5LLyZTYXt10YoAkjM8Con7mPYcbFhPsTMyf2cFMPN8fDjtMntY9Ftkn+QolQoOOm/6M5Td3flrSz2UJoIjd+F4bkqouB3yfEexbDb8a440q16D5dQqTN7my2GY8POIa7zEDRyXOcvQyBePig8X5XfSEmkzPswaYWIwkqrzmPFXi7hnHXaRB4/n4zwgFLe+gvn/nI5Ygc3mtEGyXDBPQRnAd6Dzwg0/nSP9/q9FEr9V025Qhm97zP+NkUm1ooIH3UlXF40+p1dfProjqJ9jy8Ui5IHkJrLuHRIVe9+6jvvlnJlIS7tW1wyPN8GysXUGRQZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use pte_special() and pte_mkspecial() helper to simplify pmd_special()
and pmd_mkspecial(), and kill unused set_pmd_bit() and clear_pmd_bit()
helper.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485a..a06b0f5c3411 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -240,18 +240,6 @@ static inline pte_t set_pte_bit(pte_t pte, pgprot_t prot)
 	return pte;
 }
 
-static inline pmd_t clear_pmd_bit(pmd_t pmd, pgprot_t prot)
-{
-	pmd_val(pmd) &= ~pgprot_val(prot);
-	return pmd;
-}
-
-static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
-{
-	pmd_val(pmd) |= pgprot_val(prot);
-	return pmd;
-}
-
 static inline pte_t pte_mkwrite_novma(pte_t pte)
 {
 	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
@@ -577,11 +565,8 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
 }
 
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-#define pmd_special(pte)	(!!((pmd_val(pte) & PTE_SPECIAL)))
-static inline pmd_t pmd_mkspecial(pmd_t pmd)
-{
-	return set_pmd_bit(pmd, __pgprot(PTE_SPECIAL));
-}
+#define pmd_special(pmd)	pte_special(pmd_pte(pmd))
+#define pmd_mkspecial(pmd)	pte_pmd(pte_mkspecial(pmd_pte(pmd)))
 #endif
 
 #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
-- 
2.54.0


