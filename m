Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF67CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73F86B00D3; Tue, 26 May 2026 10:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B9D6B00D6; Tue, 26 May 2026 10:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62576B00D7; Tue, 26 May 2026 10:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9214D6B00D3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42F44161105
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:22 +0000 (UTC)
X-FDA: 84809871804.01.DF8A887
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id 07FF64000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=i0YNxHW3;
	spf=pass (imf04.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807380; a=rsa-sha256;
	cv=none;
	b=Frk2+2VrsjRX6Tk/H9kf1VybNk66R1QvBgXqyhCs5BpNMIsAGKlXTX+iGpDCqVIAbSpedd
	a5BxY5UXqaztN910kVm51WPBsy4E4NAW6wFJlArad1SvTOpNq3tk1RGeNBwPdI73lWLGqC
	wIjy1cM/xCf+8apKQHrXw8RcKr0EuBQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=i0YNxHW3;
	spf=pass (imf04.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEJKj8MrGm98KFDNsLR6hqBdS/9XHG5DFtB7L96xDQw=;
	b=g0XReoSnrCw2qC0X5wMmP8vvEGyG2cwjx3+5s4yt5hIGRyq6KCcuUhEAbEDsxqgaZnKyWp
	DhZkKozQpE1cUSCVwNTEQlQ/TxicDQrXQ7D9n00izB/yD2ZX+6FUDTBHBvPkpcb6sD8eEX
	saEaG9/OPZt6Mj16LTHcs61DyRODH20=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PEJKj8MrGm98KFDNsLR6hqBdS/9XHG5DFtB7L96xDQw=;
	b=i0YNxHW3wq3lFr0pxm1PaJNgAVJTO1vRZUeYUiJLUthZy1rqBkAIdd47b8R+6cAyaooBDq9ga
	Gi+EVanp6M6ViNTwBHbOygCaz+ZLtugXoLZmkLmAljpjW4ksf3jW9FcLRD3EtMD7xBeNQvKhMW1
	e2Prn6nGp6met5Qh5OkxH2g=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gPwbt2RTYz1prmJ;
	Tue, 26 May 2026 22:48:26 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 0107540576;
	Tue, 26 May 2026 22:56:14 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:12 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 3/7] powerpc/mm: use PTE-level pgprot for huge PFN helpers
Date: Tue, 26 May 2026 22:49:59 +0800
Message-ID: <20260526145003.88445-4-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07FF64000D
X-Stat-Signature: w4qy646di31spa9c8a4n96bm1i4o56wm
X-HE-Tag: 1779807379-460366
X-HE-Meta: U2FsdGVkX1+VqUqNNY6yTEwvnWqubxUeLouaCfWC2yeq4f6dNcXVXnAtuEAbpaJtzXrR5B3Gm9G4FbuqEi+Zi0vDH9Erw5HIoFuojVJvJSTvDsiT5uGH5Zu++DIop2t0PeGKDom3k2pBFWx0G09SSNgTWmrQ29RuVa7s8hybGyLBnyvSZQS/N+KHRmCv6t60rVoWruipZBHKmEcudlO6P+gVU5unxw+TzoIBpY7yVE17QeL1jy9OUtZqssFWwAdPrB9PVcwmjYE4yI+zPp2ceh4eTaU0qDwOUnKoZtBaYlygw1iFf2aMPR+4ownmNOxXCcNg8iLKM6SC83/3kW9ir5fy+q561olUiHnSoPksmAV0W5LSmYoEjPEUtcwHK71fDrljwlG8M3vnyembXcTYxwT+GH9wHcjJK1YXYx5XgVivVghxcP93YlON8KwFCxGMJEZKKXZXaFWG1ux/JddqIh34mJpC4/WW8gCK/YHMT72rChFVDDgCvqS0TlQDLhE0BvlyBVdBw2cl/RH8oAFXJbXQf9XZNVPYMRlqr5NgjgAVXDJyNaragz0Ep4QAAj9Z0DAWEotj7Qh/0bO8LuGWEcDLMoovfmdjOgUpA8nshy4JLikXJdeaoYkONZuiLJfrAJVdYuaEu+AftdedBkiJmx5GMogxIf5ojkWo6iObR6jx9cVU3bu+4Xxv3XwUoDe2W6WtS/TQCYVaHoC3yKizsMOuQJmZkCRMaOUVwJotqacwBvBiEIbMMHseONoot/3rIYNOWmzwev+s1TvtNVTzMNW2/eaHVo4+mRAE1uk7dG2gKygM0ZmrRshfvznSpy4lh3zeFKI0f/tCcsJvJsKAHJVvcgui5gkyx2tZTB48kNP5JwG1Upm9+damW0owttsS/4QIsnzVu4Z0N75btLXyuXitVgpupaUtbhp5jCG5r84lvuDuqlRFDloBXVlVS3kcdc9xNBT1rfXELJsWaot
 cTWf2JTQ
 YYCsH0eALPCjthtnfKouurJrvoLl5dnl1QUtFHoi09HD0Nch7Sg84N06Y51/ZAnQHoHrmeeytLlXEJZnuDoFtSlpGxgL41G1ZPJvThnKJ0A80jZ3T+BQ0cK7cZyHRxgtqr81fZOS4k1IuOvn0k7QR4FzPvwmrNvycUBDClh9hEBJyx9EFeFKqxiYApqnZyzdlzqiHDnlSwAoM0rnIu+hzc+cSPFChP2WbikMKYI3D5aH/pQ1aF+Jj6srFnIGBK4rOwhFGY5+wsdwbEigZm8visJ7e00cd5sJexBdxnDrFXdcBgO/S5kon9WQ2yVH9jUHDw8S3YrNkvhiz1oort93ijS4VGtcPBiDEf31rEYesy4oMx4u0e7io6kX7oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make the powerpc PMD PFN helper use PTE-level pgprot_t as the basic
format.

pmd_pgprot() currently derives pgprot_t from the PMD entry through
pte_pgprot(). Some PMD leaf entries can carry H_PAGE_THP_HUGE, which is
specific to huge PMDs and should not be propagated into PTE-level
pgprot_t.

Mask H_PAGE_THP_HUGE out in pmd_pgprot().

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/powerpc/include/asm/pgtable.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index d20ff2ae02f5..0f368ea64b1f 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -67,7 +67,16 @@ static inline pgprot_t pte_pgprot(pte_t pte)
 #define pmd_pgprot pmd_pgprot
 static inline pgprot_t pmd_pgprot(pmd_t pmd)
 {
-	return pte_pgprot(pmd_pte(pmd));
+	pgprot_t prot = pte_pgprot(pmd_pte(pmd));
+
+	/*
+	 * pmd_pgprot() returns PTE-level pgprot_t. H_PAGE_THP_HUGE is specific
+	 * to huge PMDs.
+	 */
+#ifdef H_PAGE_THP_HUGE
+	prot = __pgprot(pgprot_val(prot) & ~H_PAGE_THP_HUGE);
+#endif
+	return prot;
 }
 
 #define pud_pgprot pud_pgprot
-- 
2.43.0


