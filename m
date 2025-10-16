Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC4CCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323FB8E0013; Thu, 16 Oct 2025 07:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D52D8E0003; Thu, 16 Oct 2025 07:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E0E8E0013; Thu, 16 Oct 2025 07:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED3AF8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:33:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B68CB80B0
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:25 +0000 (UTC)
X-FDA: 84003766770.10.8079170
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7040240005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UJGB7Q6V;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760614403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl8wFEk1Rfimj4SuE/d+n0dMIexnSNg7hsR/i17e6MY=;
	b=PhVbVjfxIdvnZSMVdDuBZd/KP/Hsea6Hlx9T6/PzGyLBgf7dAnrgu8GcNo/nvhjNBxsjCG
	pygp5on+3cITKix9ad2xsFe1UuTXG4PJyBCqbl7F5kS16kBcCwcbErBvkiM8BDLJeVtuNZ
	0EAxxMMmeiKsgidodIOzQiwRfptjhqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760614403; a=rsa-sha256;
	cv=none;
	b=7XipLPS7ssMTAd6HxZQJ9MAoxDEQjztOgFeGP65e5XXcA8QIJope1QDTD0GZP3B7r1RjO/
	4crCgzwdf/teZ9odfNeovYsFXfsKWAeI0QR0mvqEw2IWPfXWEzMY/O1VqBfqosM8MZ+zLt
	v+M49Sax09u6BlX056F47l4LAGNB3uE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UJGB7Q6V;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yintirui@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Kl8wFEk1Rfimj4SuE/d+n0dMIexnSNg7hsR/i17e6MY=;
	b=UJGB7Q6ViWGahyodIiBXCAq88T0wmr6s2XW5a8KOiGY2DS43aoyAWx2GYUkD71tQE/3aypdjO
	L02ClGRAWAt0XtsJxALWDX3IfEDdg/P5w6r1gvbBzhE0cv1lFlr6Df+BVX7M8qA7vtcq6lPuOlQ
	MnmG8B5ppm70Ym2pVG5vDPc=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cnQmC5MPzz1T4GB;
	Thu, 16 Oct 2025 19:32:27 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B884C140257;
	Thu, 16 Oct 2025 19:33:13 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 16 Oct
 2025 19:33:12 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <willy@infradead.org>,
	<apopple@nvidia.com>, <samuel.holland@sifive.com>,
	<luxu.kernel@bytedance.com>, <abrestic@rivosinc.com>,
	<yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and riscv
Date: Thu, 16 Oct 2025 19:27:03 +0800
Message-ID: <20251016112704.179280-2-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251016112704.179280-1-yintirui@huawei.com>
References: <20251016112704.179280-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Stat-Signature: snm6pij4op79ig9wxxkdiptpbwwoakd5
X-Rspam-User: 
X-Rspamd-Queue-Id: 7040240005
X-HE-Tag: 1760614401-42871
X-HE-Meta: U2FsdGVkX19gbduOKjgR6ZIejNQEuITyz2tYMxsX3ZI3tTDVFbKzXAM/GMwqzt3RzrnijszcwguawpP+eylLI0WE6zKW8RuifGzRwFBlrfEuvqxbc7qaTq/whR3X8myJK2U2pkhPokA6GZHvKx7LajBUei5MwRSossiHAebGJkAzncsJqUbYf0TtZqJDuys9fVdE3W/VoKTpjKFoz5U4XzOJSdqjOoo6TmVveStbWqOmuSDkpnzS7t3vwAav1evU93qrVyX3vD7Eom+gW4YGC2S/z1GUCUSvRngk1Mt7lZayE3vsmZig9XzydWeWDBTOb0ho2TDpw1CbzVneok5iTKEUYuO1krRH+x/uKWpoSurcK0epFMIS5N93plET0z3yBdmC1eBBHIlH1QjjVV1YpVazwxC2NHa6SxVE0wbKOSjARiwF6Vbyrf1F73R/EAwl5W7k+lWTEIbXUSC+ufIZ7iAUjXEYYx+2GPJ9b2FHLc4vMfYhZXWYVE0ihaUUOMHzcIC/zJp5XsukAG7VtuAdsLkqumcJzz8Xyx3KC585lD3+oVvvDlIOaU4u3sr/VByoAc8UtmDps7tHd4ZZck+Ixyms8nnMWDYtsZuapPY6T+vpbdY8LIzq0TVAuFTaU5YwtXdn6qlOHTY+3cVaA89qcAou1Q9NQgn1XRYhfPjVM55vQrh3wo/odbrZPDTkEXph9oj+g9XyXz5qVnv0NOAoSk4mcc7W02fegCm+rcDtVRhGpCVKGRgAYZkcXIbL4Lu7KO4FEeBG3rzQ2flSPlOW9L6ao48+fAtnHYi/1kWLK6kd3VvOhEbSv/eNVaFNCPYYiyPh1dZylmsJw8aTUD0HGRObFINIieYxnNG3ti140REYqbZGJERy0BzBWrogAr6/95G62W4gJAu7p9Msqw/IjYiL3BsHDIvtwX8c3fJoY1AWLRFp6+MzK9oGwOvwNcdGn2m8DKIgVWRDvIDiY8h
 8XdBvlaV
 vePYpQxxTgTv9nwHrn5Be1PsrceGt8/CgdrbDnASJeCG6AsNIOJGC2Akp56A8Los7sc5HWqxaxjxLoFN8hq2/ADP6WCCrtewZ/myMbupF41QGB7ES5Dv/Xwi4lJKxAdt719CZAIisv57uJXWfGjbOjWJiH7zbxMFpr/m+kZ23GHoNzuPNPduPhbAaqH7v3pwXYyBFI639SuO+aK4iaTdhVAK1+QZyvShZ9XBNNpKVH80MiWgUO5D1NRuO8pvEYLoUHjPSbM5yJyf2CHf1KrDDLpQWPt5N7IHNWs4+MqQLCb1mmwfeysEq8hK9uAQzYeNtFVJF1ORZYGTpdau8V+I7NmndvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pte_clrhuge() helper function for architectures that enable
ARCH_SUPPORTS_HUGE_PFNMAP to clear huge page attributes from PTE
entries.

This function provides the inverse operation of pte_mkhuge() and will
be needed for upcoming huge page splitting, where PTE entries derived
from huge page mappings need to have their huge page attributes cleared.

Future work will refactor pfn_pte() to automatically filter huge bits,
removing the need for pte_clrhuge() across all architectures.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 8 ++++++++
 arch/riscv/include/asm/pgtable.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..244755bad46f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -366,6 +366,14 @@ static inline pte_t pte_mkinvalid(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	pteval_t mask = PTE_TYPE_MASK & ~PTE_VALID;
+	pteval_t val = PTE_TYPE_PAGE & ~PTE_VALID;
+
+	return __pte((pte_val(pte) & ~mask) | val);
+}
+
 static inline pmd_t pmd_mkcont(pmd_t pmd)
 {
 	return __pmd(pmd_val(pmd) | PMD_SECT_CONT);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 815067742939..b0a20ddf780a 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -455,6 +455,11 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	return pte;
+}
+
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define pte_leaf_size(pte)	(pte_napot(pte) ?				\
 					napot_cont_size(napot_cont_order(pte)) :\
-- 
2.43.0


