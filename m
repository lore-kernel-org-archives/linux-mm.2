Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2362AC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FFE6B008C; Fri, 18 Sep 2026 02:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F906B0092; Fri, 18 Sep 2026 02:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E6E6B0095; Fri, 18 Sep 2026 02:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9DED6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:49:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1050405D6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:49:36 +0000 (UTC)
X-FDA: 85225957152.11.EF8215A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E2F100002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:49:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kEY6r5vk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789714175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1rGWO8Lp9kfZSkh3gid4VThVknWU+YNI6kHCo0afc/8=;
	b=7/4nfuh7TdHCDRCP6OsOgiyXHFGAaliKzy4SJ2e9gSVQYEOzxO+hY267nvCanV9nIhsqwp
	66vLh1QPcSF7ZajE5baCPUzf4ruXTt/abY6Mo+HuhfXKLaFEaEyhDuJGdpRPbjA9zJu1+W
	juPFiE93QzSCnIthoZn7OAZIZtOfVFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789714175;
	b=Cs5U0dRuLbc3mgheqgeOwBCm/Tz0q6zR2JPDkmRrLUIyWkDs+NAiAZpf5vvWvu8KMQNpLq
	YtCYO5T+OEat5MjjW+UCEVo5g2F3WaD3bxk2kygHKn5XZXyTV4W5b91ruEiLYp3W7nfIGN
	ZHeRep7ZouSDo7SpfAyS/1bXqaoZ5OA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kEY6r5vk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77F3E168F;
	Thu, 17 Sep 2026 23:49:30 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 509543F86F;
	Thu, 17 Sep 2026 23:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789714174; bh=ZFnRB/ALKf9PhoJD8/OJ2xaBBdzDNWPLgcoOEc91zs4=;
	h=From:To:Cc:Subject:Date:From;
	b=kEY6r5vkmWKUNDIpDyr2erwlyN6mIyLWgr3Oxcy6Z4hhq7Go8JXT483Y9iGmBSjFJ
	 Kw0hCbtygsgTI96bcdhUEGrJbgr9/10dAz6flqQdmmm1scG/r6rFbFURz5MLycy9jv
	 9n2t6rWnTRu8Oi1WbVxNwdxeENyzYeOF74lJk9no=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Constify arguments in default pxdp_get()
Date: Fri, 18 Sep 2026 12:19:28 +0530
Message-ID: <20260918064928.793742-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 22E2F100002
X-Stat-Signature: xk5qm7sbz3gfzwyrnws8nk6uz96gchyz
X-HE-Tag: 1789714174-530129
X-HE-Meta: U2FsdGVkX1+TCstuyXYCsdjQT0OJQHHyYZnBee3Uf89njLgy7WyQHIihEne59nnH28XXjueP9FGroLK04RYSFHj1qaxsnmn3EUfUQ9lWb4lC3FOJfwRMU2sIqvCfOv4kpQub0dWw/vmKRpPRtP2YXFroaPTkpZ6BqtCkBzFyq5slN6jFLvr25tI4S4ECpa5YPchuLfF5G4w5vgVsg7n6T/Oo2gtLLDmmfd2ZH9zwKBJ9GWoug+JJtGALDz6LYEqMb2RPaMFoN64Au0dWt4z6o7J3tOVMN/gwxkmq+Bvpg03SGAlU0HQSmMZUxRCPIplJyKMDPhYsIsJmDwg1ERqb75SnWrxN8pM4o+E8Iw+e1NBIkgPK/81I6JJ02nYqZEs3DHpYc7XTD+u/lYaJTQOJc1id54QJ98wQZBgFT067IO4uz7V/FO9u5lcEX2koY/+n0vqD/Z7GYU14bJdoU7I6c1l9HyIUTdjTFXj04/grS7NPWGz7RffsusWlsU4o0vOQhmtIcx+cr6Rl0NVLOlXH8YravFQ3H6HuBmKwkleuWTBec960F+7ADWJQTJYh06PuCDHacksvXm51p2f9rya6d3c0TlUgNS4z3UBeREPkSgeCLhjwhJCywKri9TlRzEsu9np9IOc9ulZYpoaWTtsx6VYAAEoVJY17FTGmKCBwBLazkox9PTSGnJ9xjuGASwCk8AsN6a2xkg3DgPY+jLeNp+G1hT+o0g5YOrCp7/PkLZTcypVbUQyBva8t06O2qfhTZfeaG2xkLXgnObczQ5YrfQ2o7F0Gn4OjkZ4ucB6BWZRzhN4znTLqoipT3H9iKtBeNQ6sR9gPZFwqexTK6LohJD1qPD9AZGGghDvq31/kTKeJtCmWxsDYNxD1oBwI+U+1pDFMnCDtw8iSrZXCJGxe8X7XBBJq3hDEk6Ng/7ACWBYUvnKRnsDs7M2Cgb8RFY0O2WjvWMvby8RgmTTIA7i
 c1EvDEHF
 ZA7Jt5+G+jYpKaYUC4Kgq2vuD1pT/D0LRHiEc1+O2S1mJUl5CbkBt0/WZF9nJhOfdrjoef37+6RdVFRwppF4ImNsJzIUC6hUEfcq7MPhrFlT3wWx/VCxwFusGthe3QGXJl7ArssBhD/lSXJ+4GJ4ByoD8Hj0h0JgsuLcbKojQEqSNJX/PczzErRZEOzhGyghKVynX/IkSgUJSdGYdkiAus/rHsMAu+eyMhRn3X/CeX6zrz1G3R16BIobb51jLg4nQUb7VGM1aykDnDxCd+/ZYXf1LVWtf8CWZlQCQvSoRfKjvXEsOWSIQFYKhtYRp/NpFp6BbnqcetceGp+2H++HlmYOekmqYGDo03a/pDP8OCLU2uM5yr57sgQCZAcIyf9K88VJMCXg70nI1xqymgnf7npu2oOPh2F+tzkuB2NqTgL8fSaDKSXUSajnxPeIJ55oiJox8tlijbCwZgzCedeafBoMYY1HWL4xIRruo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic MM default pxdp_get() helpers fetch the values contained in pgtable
entries via READ_ONCE() without modifying them. Just make their arguments
explicitly 'const' for some additional protection.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.2-rc3 and builds on many platforms. Some earlier
discussion could be found here. Platorm implementations for these helpers
could convert into these "const" format later if required.

https://lore.kernel.org/all/yjqldpl7il6uqfoqrszaopchqthhlffssprmlqjkljvpkbpwkt@zetb5hyvllsl/

 include/linux/pgtable.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2981e386da7b3..f09a91ff5833b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -490,35 +490,35 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
 #endif
 
 #ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
+static inline pmd_t pmdp_get(const pmd_t *pmdp)
 {
 	return READ_ONCE(*pmdp);
 }
 #endif
 
 #ifndef pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
+static inline pud_t pudp_get(const pud_t *pudp)
 {
 	return READ_ONCE(*pudp);
 }
 #endif
 
 #ifndef p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
+static inline p4d_t p4dp_get(const p4d_t *p4dp)
 {
 	return READ_ONCE(*p4dp);
 }
 #endif
 
 #ifndef pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
+static inline pgd_t pgdp_get(const pgd_t *pgdp)
 {
 	return READ_ONCE(*pgdp);
 }
-- 
2.43.0


