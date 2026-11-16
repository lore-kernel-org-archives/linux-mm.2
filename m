Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF6E606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YN6vXP2/
Received: by kanga.kvack.org (Postfix)
	id CEA006B05C2; Mon, 16 Nov 2026 07:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1786B05C3; Mon, 16 Nov 2026 07:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0276B05C4; Mon, 16 Nov 2026 07:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7D16B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 307BB1608DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:45 +0000 (UTC)
X-FDA: 85440963930.07.939E387
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 83CB54000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YN6vXP2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833383;
	b=cGrxZ5pdolSlgB4vba8xNe66IDv/b5AN207wMxZSUyHLryew+O+1CBpJOxnfpnkG6O85Oy
	3/xyhIpgpDpv5Y+uXaiKLxfWJGhbohOeFEdaUOeuUmlfLp79QXr28rklrP2dO6r5hHH8Bn
	00nXc3V1vGuBbAoxztnprPpkdu9TyBQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkKlFLJh0bHRqw2u6qo7FKqMD2VqM3GiEa/4Vt9PFN8=;
	b=xk7DItuTP5VPGFNZKvuyRVg7fmVpAVHCCwYHSNi8ZmiL8nE2FXRwmn/9/hAlbbTWIPqMte
	yj0c784BQp677N66O5S+hr4FqqniNVync/6aNV2TjEJnsBGGcj64vieNn1oqh1bOtIV9ae
	BiC50/W7Qfl5CtxxnLXeWfBEOiwufao=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YN6vXP2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D84A84472D;
	Mon, 16 Nov 2026 12:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7A81F000C4;
	Mon, 16 Nov 2026 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833382;
	bh=SkKlFLJh0bHRqw2u6qo7FKqMD2VqM3GiEa/4Vt9PFN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YN6vXP2/30cO412t3zjUajzb81yQ99gS8AJH9uEGiLmyUcS+qgSf/HMMiYqZRaboR
	 ZUFcOr5HG9bo2sXqK49utjfTBexB9GVMo4s30Q88My/RcnmlqYraEayTKRWAaUPYBv
	 gJD87jCCGbOS1fLcEpdk6WBb9etOKPgjDOEYZ83r/ZxRTQUrtiQYy4ZjKVlbAQ0+AG
	 gOt7Oq3YkH4zTVirFjUmewxyf0ab6ZbbxAwI2IJ2lwpk9XMrXjGusor5THb7GEcBg7
	 cbyEw+CgHbue8NDj72vH/de54rhuF8daoE/kSNW/EKSHRf3CGYKQi/RoPfiBxBVMN6
	 r2cGCwk/VJD7A==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 10/10] mm: print pte in __print_bad_page_map_pgtable()
Date: Mon, 16 Nov 2026 13:48:32 +0100
Message-ID: <20261116124832.662455-11-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 83CB54000D
X-Rspamd-Server: rspam12
X-Stat-Signature: 43xcxg1hif9hm3q1frx4aee6zc4pg856
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833383-97754
X-HE-Meta: U2FsdGVkX18WEFu4MWG99mVlFt787g6YkA0dzcsbCm5+K0O2DKOXgyRt7bTCN3u8gfSfFnbc3GOzHug/BqYNvOCPog1XSAjH8FaeMiThrBqgWagIxS1OnnjZ7a+ae74zY4Nw8AUw5Sq+6isnhfZ0DTNC883qw5ujU3PZ1h++ISvKaKxntDHN2jRbuFiC62+BMh5LkejhbkjGp8gq+htTAzkgJq8TX2n2F8kesd3EUPmQ+rSxa1+CV2IUriWVgL7pdUdrvIUSUmtQwuPoZNQ7w3Irg1EN8N9u+03LpQHp+lhuRmSz4nHMcmuzZTzCaN8HqQMXDgZNv/SmnWsgJqSEBKSVGJXGkbat2OXJ7TrkRkIgjwpRSlGerGpjSE4e4PncApt7L9Mv+LkRsQFj29UB2URbTpKbOiIO70SPo+XeCsUZnd4JMdORzijxeeOk4TMCnOZO3IxH5prFACPAiFo7970XFHpU4eKdBpZjvSvEBEcI3y4bWioDG4th+F+E2Rqv1Rru1YNAxx2JOn1DOyl47MZ85eWi8CMbQg6iU68tvGjka+af5fF0FhIxvzSYbIxlff3qPEBs+my9vYm90dQap8IcnfdmkAy9pl9NOGDmPga9Gy0sqAw+YfIT5DIN1solGD13NXbD6s9eoQmCT8BLWNP3pIJBu1oe46hAzfY+FUl/fn8bJ+3zVQBHSfmr9yGaeN+OuJ6nWvnrW49U0vBodNgoHbkk9n/GMavz4AwQ/ZT3y5kFXqjL/fCJeE72gqcc2H2wt66WCEJb2tUpCfdsH0x2DtW3aBry2pmULTVehbIewYM75orxPooQPFrLsZGgT2Ogre6DFJRZ1ZsFcuGMGU0rISa2RAz+sx08bKBRVOUFuwrEgwviX6inFbTeLMxNQsc7anU0YtBCgASDoaeNpf1LK52Ox84QpQVfACKQUFFaRJfhn6ynH9f/zlo8+xS6++/DEThWtIJgBNWrLIh
 l/kf9BfN
 jPcrJGOcptp1ql4EOvFbgi1/dhtPsQlRHtx8Cg9IEjqsP9O1QQ6JFPAlDIJ/H+beVXZ1eES2Clq3c1aGb0aGrd6+GVTNQxqc4z8IRYQN1fZ3oqYuROQHsL8jXVClL8dDqmgCYQkna9ctHTDpzJOZEH0OOI8vwqVx7CskOr/aCJI7WMOyzFlLuhLxAn+LvzvBfIBV4ymO21FYDZ17xuc77dHSEuU5qM+jR0HxNzTpQv6+8zDS+4oQLLsBOURo1fDubp2C4KCtStn6N5KZah9I8umlkdxjSD8ZQTfdk2O4K5OOo7ycRMhb40IVR7hq8kvW3lqUOlozkJrf1gQlggbylZlNS1AXZLvz5M0F4UG0z4NAzj388zYzpwjXJ3JCfAKC+Z2cQtqSIvNieF6d7MzCbYD2xNjTOLl8PfHQE9sXP1YSkpHl5yiMn7KCcIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

HIGHPTE support is gone now, so it's easy enough to print the
PTE here along with the upper level entries.

Acked-by: "David Hildenbrand (Arm)" <david@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/memory.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..6404bb447d9c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -528,9 +528,11 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	char p4d_str[PTVAL_STR_MAX];
 	char pud_str[PTVAL_STR_MAX];
 	char pmd_str[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
+	pte_t pte, *ptep;
 	pgd_t *pgdp;
 
 	/*
@@ -567,13 +569,18 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	pmd = pmdp_get(pmdp);
 	ptval_to_str(pmd_str, pmd_val(pmd));
 
-	/*
-	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
-	 * because the table should already be mapped by the caller and
-	 * doing another map would be bad. print_bad_page_map() should
-	 * already take care of printing the PTE.
-	 */
-	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pmd_str);
+	if (!pmd_present(pmd) || pmd_leaf(pmd)) {
+		pr_alert("pgd:%s p4d:%s pud:%s pmd: %s\n",
+			 pgd_str, p4d_str, pud_str, pmd_str);
+		return;
+	}
+
+	ptep = pte_offset_kernel(pmdp, addr);
+	pte = ptep_get(ptep);
+	ptval_to_str(pte_str, pte_val(pte));
+
+	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s pte:%s\n",
+		 pgd_str, p4d_str, pud_str, pmd_str, pte_str);
 }
 
 /*
-- 
2.53.0


