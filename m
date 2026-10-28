Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C49606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ibg1b62N
Received: by kanga.kvack.org (Postfix)
	id 7F2DA6B05B3; Wed, 28 Oct 2026 08:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAD16B05B4; Wed, 28 Oct 2026 08:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559C06B05B5; Wed, 28 Oct 2026 08:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4036B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:14:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6F2AA8AD3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:21 +0000 (UTC)
X-FDA: 85371927522.10.6FBD642
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf15.hostedemail.com (Postfix) with ESMTP id 186C5A000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ibg1b62N;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7sQA5h1RfSHGS0NHZy4TWtxwdMVPvDcI5QmYb5ui1c=;
	b=RBSDe6nslSuYbOGoNUbfdC65dn8wVqYZ7CbOSwHzsnRdi4GKD+EMu1QgmLbK5+qr6QYpsY
	dOkQM8Oy+pQK0qBK0+Dv+0zjhZWPsSHLNp9lVkvrqgkxfMCTr7VO2poIfYbi60Vhbl9Xpn
	GCOJ3FizQVpye+3B9kbul4ybbd51d9U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ibg1b62N;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189660;
	b=xPCpWyAKpab/vzkJvO4MlLeDKIqaatTQ2MsY6sQZjYY1VMThMcaXPsRhrQ1CkaF1htMtOU
	c/e6jqa1dvPe/vW7TA2sUK1UFFhbDJA1UkMm5OxvChCrmP2CVXIqxJAX6bjMzO+1weYARp
	s4WjNTrrHdwJMTq3NsPfBCc9iNIqvRU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=I7sQA5h1RfSHGS0NHZy4TWtxwdMVPvDcI5QmYb5ui1c=;
	b=Ibg1b62N2pywqipya4gZp1G4UFzwD7XyQCFTjn1wYiEN5dIJwvTpF9CA01WGMQiFuGCGtpbwh
	gQ0J4wqkiFCBSvcQFIxjsJ299Q0SLuyfhvup52gPQ3WmhtJNCXGQrocubxJIG2sDAY35RNo0qfc
	JF63sPXxBZzG5Rz3JhKwlm4=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jF5r81KvpzmV6J;
	Wed, 28 Oct 2026 20:14:00 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 96F2E40572;
	Wed, 28 Oct 2026 20:14:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 20:14:05 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH RESEND 2/3] arm64: simplify pmd_special and pmd_mkspecial
Date: Wed, 28 Oct 2026 20:14:03 +0800
Message-ID: <20261028121404.853944-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028121404.853944-1-tujinjiang@huawei.com>
References: <20261028121404.853944-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 186C5A000D
X-Stat-Signature: ixknbnzacgbku4zakxh56c1owozjrp74
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793189658-305905
X-HE-Meta: U2FsdGVkX18PZgF+zORo+O6OUvRSR4hXIMnE0K7jjctNOQTBNY11PQa/NuDptStnl494tITAg0/aRN0Tp3KdTat+ACuntdrBTZ1Q7RWQxYjJVG0HxQO41Itp73Opi6KNpubDNwAw4dVyt9apDGszj0ecQDwYGAIx+IXAUzd38HI4T/j8JQhzMLQWXvpy6HGKruzLBjL1CzjYD4FKCx8xoVW1azaMrA41jlHKJoynYi0Trmud1pG0Sqa3tj7rIIksIwdKZjdicOCsBEZyFb/isrNgcWKxHvSpQyIQMu90MwSMdKPqeoRH+AATD/saOVslarIC0drBuA8w0rwPhPCRuX25EBMP1MIJqwry5wX8mBNJZOG4IpWLkQcrEsVEh6qHTEInXXotZzdXooN40brSL0g/UPveUoVkErzJmUSd7Qo8AOCRNsx1/Xvm9lFDfwszugOhXraSY36aIdvOpDYfLXnJP27wpLTDX5Lc4ny8oMEBwQUyWOkTnAxvtkvlXmGs4IBldOYKkHhx5xhyAs+f4qCBzhfOyfZiD/CDGNEZjV8gYUkj1IxNoCxTA3uXrnUVqXZB5Q7o594CQzKqzNLftiHLEVlaM1lx7mV8XNBA3aYsJhG7UtQh5yj3c3PgKozPOaH6yHXRYRqLkyKkd+6O7oiQQqeOquKzYLmq/QWPdrfMCFTBIszM3Q0R8I4Bj1U7nMwKau4CDf2G/Myd4QLxTSBnGfK39bM0VsIsyuzusGEifj4d/1dB/grAWfgwy9pimX/P3W0dR6uxFyKkQpXQrJ+ZMAifwaK/7hSeqcoxbPoNydaKq7HzLtNMzYtMNiERHAC7zvkk8YiD1kZiDjYOO3bwjiRQpBTuE12g2Fhy9naUy8Co84OzED4qobtGpLcbGpwYjQfoQUOyVLmI+ngCjbo8RA7Ms00zNyWJDveyCle54fZjK0tecKL9ZlsHEMSCORn6qUadb4SxzE+1sXx
 DaEpbFPd
 UAT8c9/PvukXnE+kn6bQhafKI/09wZc2G5SCXT1bH2wnGDi1kX/eunkMj9kMze/GKjyP7p3EIblLgW/BXNgRiUAoq2C2FlB/BbLhDl+U6yHVLHRFXCmB7pXZMxTqYF42VgQPx8PjidIgOlNg8ZMw8EiwSjBSgvsyUbW2rfgcwLRCj0in6VBSFysFRZ8O7/ER9uE2d6Cfu6vkVHScHcLrBx+jpJfU3lMsOZU6t4/RBnLAtUSuhn7Er9RzcEt8Xq+DsHtV9IfYmyIjNaIQsQkMG56k7fvcgfokMSlXQBhyctg+ftB8GsoyPgU02lCL1JDtj8JzE0Z4LQHB6COKrWyOxUbC6EA==
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
index 763c5a411d64..7de2487e4d35 100644
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
2.43.0


