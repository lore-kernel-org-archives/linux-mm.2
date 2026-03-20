Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B231099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24E26B0099; Fri, 20 Mar 2026 14:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCB66B00A1; Fri, 20 Mar 2026 14:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB3E6B00A5; Fri, 20 Mar 2026 14:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F75F6B0099
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 220C9B8431
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:47 +0000 (UTC)
X-FDA: 84567224574.21.FB11C60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F8764000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o543Rz+D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehQfIjrMKdWAnhiYvJkx3eAZAA0XBOvPoQs5eqk+SiA=;
	b=TINRS4nYRp5arv2wC9L+XgksZYe7z4UWrnVArgchr8la7xZLFzSEaqE+eJNx6TJHhPrm7n
	7mUY4fmCG+/irgh95L+nOjVW9qEV2f2o8iqmnxBjkBx9m7eXCY6yyxkxt7+Dq9ceFVjoci
	kZfiJDqipIFeRvK/jaGv5t04NMecN3w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o543Rz+D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030065; a=rsa-sha256;
	cv=none;
	b=au1/LgGbgjR2smHBi5it1B84YdHJ0IigTc4skKujT3NIVcHfU5lpm88JDsDlV0s9HE+KA7
	MnsURZz5m6LlHIxkTcnTyqcEp61fd9cjxcAvnzbjCK8rCV/D6ybV53a6Kd0HS9eks6k5Yx
	gWpbVRht0qDpcNlOuDY9r0fngucYg7M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0F4360154;
	Fri, 20 Mar 2026 18:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C17C4CEF7;
	Fri, 20 Mar 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030064;
	bh=P/GkKotdiAAJ2kX5xJff0/9NvIiAuzmB7tSLtVtZQAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o543Rz+D7ParciZZN7bePd2+jTsesQ1AAogXkuQEnh94ViHNNdl9C/HFmhtEWlTiC
	 6is621MtqtrcF4n7LgGlSFi3az1wNbjNAZKYi2tAidldig9W1CMu45cTG1LymocEt9
	 BUg2ByHHoeocuPZwRwK12NwYbfl3w+7VnzEs8hw+leX9pG2LK2JKwcry+uT+MRd1Z/
	 hQZWZbonItH2M+1/tMMmyRP8FqWhQFpUdyNgflQLkRTe+M+h6qkBIwq685RrJZ2Vpq
	 79Jx7LwqDasiej2INE4C0KrL3HVeAis18BBVu59+9RUJB8FGHjBN6y3Oc6DnI66pU4
	 zHtkYfTlkPgDg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/13] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:21 +0000
Message-ID: <fcf1f6de84a2ace188b6bf103fa15dde695f1ed8.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F8764000F
X-Stat-Signature: bgrpt34ked8gd6i45zdcm3pcc74y35af
X-Rspam-User: 
X-HE-Tag: 1774030065-860991
X-HE-Meta: U2FsdGVkX18ipR+jDGY20VUrBtyqHQr9MJJBWZN8SQve8fCu9A2z6EP6Dr+//7qv5bfwOObd85ehNCPsTCaStWaB2VN0qEQzXrJh5PhuOExViUhhqc4BrWFqm6HzSZUdfsr8nYYhpeLB8SgZycz43zInOa/RUlQbRQVWuZoZ8ICQaEtPPEgQvbI+U7xYElKicNsZgS9xgNKtUV5UzTG7P600x1HimEp9zw+9nbbEtFfpECkhyN/L65Yg8J14yW4/sR1M6flHLIogktj2MLFd4IpoCD/3dodup0K1irSvFsYmCd1B7BQAC/0UmjHTH2iOL86z4hX+ipNthdbrTf4jegxiRAzDdh9+vambutzLHo3VH0xVp2hNhEAXSGsziuLIouRZQGhorBH+L4ZvShqm2S068/bkI2bz7DRzlYCkZ7/sNzQz3DPgYbonahJLIFQ+uAWNUOkqAhqOVjwM8Mcr0xWyiaMHlHh4WYBbpTxxy3GNXmUFsH4C76YJC1uZVvNtO5+i1qiAaji9JIy0jp/TeC983djZVLOwaUT1CdwRii1DIgwLzPtjRR6pzdsORWmnvfzNPTpxkKW3rsbImpcMmXlXL36JglRQBdlR5DUwdtwqebSXzUgk28+wBHXIBGl/ftoO2cNC5aIUtHwGEXLvLqnLYVTHb1qqaLE9ECplwtEncJG9Ctr317vRArA3n0ezRIBjAlLnFHjH1eKZmpLuZICsQBCtLvOnX2claqZa2/pnWu+12sD/olrs0nOAWLXRAMbGTMu3gms9C0gOD7udi8oft3TUeZvxKLo9SAOGpSHFZUo1YS0ZnyfOKEwNLlLr1G6H/BOPHDG6ADZiFOYagSKXYr+ZEduJqijL4peYS7g0424k1avwDx2/wfMpYjbPIoKPr2zvLeAeTseE/gLbP/NFVkbqCewRXFB7Irnj/pRs2Ld1Ys07GSXkQw642MASWdqXGEiwq9y4j4NlTeX
 2w+URVg+
 6e4L0tABfaia53G22tqsYOLaFpkxy8KUjsnNf8qoinBKP6enmHKxcUutKkPRZpFWNnl0ATz+p3GN+StO+xp1YHTWUrHEMys6mhe+/aUYDvEOvDOvq1WKK2LF8HdpTLitOm4AsuayCYw/XNR5iND0wSf5waelg9J4opbJOmaIj1Z1KX6Vq+9I1iwxY4xPotbC0ZIjBxYXcQzXaxXhlq276yKeHWfVgIZgX7pkYHExZyK1MyH7FY7d52091BFdQ34Q/NRZYla2Hg1aNtWYpaZTNqRZbNWXZ6ZZnTL/v6HDqjIlV+0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A recent bug I analysed managed to, through a bug in the userfaultfd
implementation, reach an invalid point in the zap_huge_pmd() code where
the PMD was none of:

- A non-DAX, PFN or mixed map.
- The huge zero folio
- A present PMD entry
- A softleaf entry

The code at this point calls folio_test_anon() on a known-NULL folio.
Having logic like this explicitly NULL dereference in the code is hard to
understand, and makes debugging potentially more difficult.

Add an else branch to handle this case and WARN().

No functional change intended.

Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3c9e2ebaacfa..0056ac27ec9a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2385,6 +2385,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	} else {
+		WARN_ON_ONCE(true);
+		spin_unlock(ptl);
+		return true;
 	}
 
 	if (folio_test_anon(folio)) {
-- 
2.53.0


