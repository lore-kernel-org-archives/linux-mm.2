Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0B2C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE986B0098; Wed,  9 Sep 2026 05:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84A16B009B; Wed,  9 Sep 2026 05:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08D26B0098; Wed,  9 Sep 2026 05:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9026B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:28:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E003D1A015D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:34 +0000 (UTC)
X-FDA: 85193698548.17.BFF2E19
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9AE19180009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fqO8rMb3;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9lkQQXf5XYtCcdnsfgeCGlKVAE7OhiLAhG9JfwG3Lk=;
	b=VBM8Q38LShmN2SgMdB7/nhyIjNAEHbKpUguRf/COlf1GCqFoYcyK0ItDTl+HpgNmHAmZPH
	EBx1ihZLucDF3qPnaekA1VhdK6uMhrRbenxNm0Zhy0ZsZPpHWluWjqvMIHIJccUlJn472l
	2vhoCC1ng4KxOw4TUKRNawn7xiDpwhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946113;
	b=ydej+6AWyeDbNihWrnSZekoquwEi6e+hs3PCHF4YGzCBemNiuNwEZFImhYNy8rRor8IP7+
	t+12xUde4BJ6LiznrT5EWwbHKER97cV1NTzBAZfI9sc0pVxyZ+/SGglVUr+z0HuAurpBd9
	TCyCz6sDHsrqF5bMC3WzX446MdpF9A0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fqO8rMb3;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=F9lkQQXf5XYtCcdnsfgeCGlKVAE7OhiLAhG9JfwG3Lk=;
	b=fqO8rMb3HlVD+32HaLHoJ8RBkcSU2TDanLzf76vQO2uJlP70eaN2O1NtS+oKrG2yJa9OVZQpU
	jjtGxV/XWUiIa/xsFV7hgOV3ubrj8bgGYCq4MD7j5TCLNk3nLPbbOiDPUJsOx+sRgChW8z2NApD
	jtx1eUHX7kp1Vu9J/r6mCqI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hfwF34pMrz1prQs;
	Wed,  9 Sep 2026 17:17:27 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 921854056E;
	Wed,  9 Sep 2026 17:28:23 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 9 Sep
 2026 17:28:22 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 2/3] arm64: simplify pmd_special and pmd_mkspecial
Date: Wed, 9 Sep 2026 17:00:17 +0800
Message-ID: <20260909090018.1991485-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909090018.1991485-1-tujinjiang@huawei.com>
References: <20260909090018.1991485-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AE19180009
X-Stat-Signature: 46odzisuo41wqk1ajaxcfkyum1mdxsmz
X-Rspam-User: 
X-HE-Tag: 1788946112-625812
X-HE-Meta: U2FsdGVkX1/hhfmewNIm6i/phhRvsjqFIYZoJB01/TU/jstfsJfA9H1RvVl3Tlry+U6GKHyjntyx9YtwjFFmmvwM+ElZuhNwsefFJQatztrV9gW9bMqkSBc4+ym7Ata2vrXFbxfw0J24v7QODF1GG3WjvEiQ5qZaB4p32NC7MDG79t7s/gCpmVkr3aUiOLH1dD6MaOJ21XOgcBb8EKkhIZrZ4td8sHbLUOVknWVmvN/Jvf+RTFRZtQhfFuJa8FeO9lN4IXNiMqONUdwAqZ3taCIXkiEFAJ5o1Yu9I5KxQcGMeJYo5Z8yKEI9bMwrvw+7Ac3sxsVcFtO9VgtGc0Tyebq91fCQMp89Is6kE46Orj0TNlGl6hpwG6vdGWkeQUge0aGXF77EawrNGxfVsutJea8ECZXofOyEJgv+yAXy0Ro4KyDxtXyMfecmyX4/W845f43avwJijHBGn/LTGaw+f/ErQL2tIXT1STXl3Z2Ne6+LeX+qP082hBJRdCZiXc5IBmMvALZSMsB+eph039iUsIz6JPjK+9EvRHOFz152Lf7HQM9AjiSMNTGsbMj4rXvkb5ZRHPkQ+lEDHdtlF4gXXasz2+SrVCfo5qp+hAqjjObZ/nz24mVf7TeELXDrGtPKO0OwOv/Kzm+M2VTMA35GbR3t0B+B282NqC3o9sd+hPIqSURXqyNE0LbyJzrHvbR1HrdJwffKfVzuPa2natT4bRrImbezG/7OTRyuTuc3kddtD0DdKbY2CjyoSJICUFtKvq9fzeQJpvCybO/qdjvE5U5nl15FyavTevyaQgOIyD7485+6lpeqvq3QyFGYt0+68XRhu0EnYL9rZ/Xr+NQDqrvQRFvSo4AG6M0TF+IjGcliEv4k33V+rtfcI6/MmirE9h+Vpgbkgb9F9OR/PB/xMafi5vobcx33Rb5IqZRS/+Nc0c5doxOBWQu8YTWA7Sg7PI9wGDT6biR99WKNJ00
 faTik4fy
 4AGaoW+Gu2WfDYGqG5E1GFF1+djRjY3VG5XBW+Q30eIaN8EOw3Ygt4YIMePwJWjbHflo5m3YLe+tlc4Hb29YEpP3Dmbl5NgCNhdtP5I5gCiR9jv2k+daUtfcKeTfMYmLab8QIzNl3Tm8qw/GnBfNBqpO51dW0gM8qC35nWmojWIp7KkLmbNNVbHioxIyTemOl7QAv+W/lu+YH6/cpDYMwl/iAZPizPKlw9CA6wbvih4f+oBYIRUKuw1GesuhMeEIY8xoMWr4GO6byS7JqdyYp7MrroQ19ftBIbW9alumkmYsLeURf6Nrpyhv1d9DnX1/+44Lf8z3i5hr23YWXLmVe7+SNog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pte_special() and pte_mkspecial() helper to simplify pmd_special()
and pmd_mkspecial(), and kill unused set_pmd_bit() and clear_pmd_bit()
helper.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2e86..427ea3d2bac7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -243,18 +243,6 @@ static inline pte_t set_pte_bit(pte_t pte, pgprot_t prot)
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
@@ -619,11 +607,8 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
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


