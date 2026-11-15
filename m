Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAD2606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WI2YaRRX
Received: by kanga.kvack.org (Postfix)
	id 160C56B05C1; Sun, 15 Nov 2026 09:40:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138A26B05C2; Sun, 15 Nov 2026 09:40:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EC26B05C3; Sun, 15 Nov 2026 09:40:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD1186B05C1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:40:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6702B120779
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:20 +0000 (UTC)
X-FDA: 85437613800.05.3B3B76B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id BEE041A0008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WI2YaRRX;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rjawh58rti+jKBLk0/ppPYRHWbAG5yPpw6+MQJTga+8=;
	b=BZtfRHvI/feGxOIAWEpk/D6zhBSCghWKP7jANw4QIkEEgfE5sutyrstWkyr56sd7RkXzlw
	zIM8uXSBkCHIfmLJlGCsE+suXh7qX5EvWWHDK/WsWK/kY0HgcbmyRrymyTVGUDWnhzE/rU
	TSTYXBq2tWBOEZVg7eXRf6KFzXc0AhM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753618;
	b=eLpZBsVFfwJlKpQQ/Yu2MxWPWCQ8N8GuDdpUkj6oRQU/rrX3xO7s95iwEknriDYOPlDnTo
	7EDDbSRrY5Qf9IiMwxr5P2QNG1gVvm+8PRHvFhvVJx01HHYaJEnPkWu6HPmwPfw/DJReal
	ElR934IljAdFlUJCXjQh74yPjfw58s8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WI2YaRRX;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 081DB1476;
	Sun, 15 Nov 2026 06:40:15 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2A3443F85F;
	Sun, 15 Nov 2026 06:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753618; bh=NBPLKK4FA8uDkoZ+Aw6nSyKDd3zpjuVqz60XwsXS1Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI2YaRRX/vEKLYZo0sH/ZvQ67Lxez/RMGHJZPvvcKO0IXlYiRqq6FXCB0FZGHFxzj
	 4J8oibQ4P5hRCHqRjYdaNmAL0QhMGVTU6XuO69HA0Ugliv7AZRToR2Z0fWhL9BYrw1
	 eRdCn5SJhsPNF3/z5oNe2xhseQJpfZqC9kFZ5g60=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 7/9] mm/memory: use set_softleaf_ptes for uffd-wp markers
Date: Sun, 15 Nov 2026 14:39:02 +0000
Message-ID: <20261115143905.3045084-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9yc8ddoie1qriozank3fckxp3xhscs1u
X-Rspamd-Queue-Id: BEE041A0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794753618-997483
X-HE-Meta: U2FsdGVkX1809Q2dL1eJD/dmasyMdS9ohdPyBCx6vbN9/iUEGNe2xzCuUE1TDEkwKd5eKp1pV6icb0+tgcklAPoD73MyjUzYxl4O8FvxBO7MHLJtaFgGVxFtWoDe7WLK7ahxQ0dfmy9SlwM/X9rLF4YsKyd4t44ytBrYgfCtd3UzmmMIIxIRdHPi5+HPpbD6LPfNn2kDK0fvixoxfpComb3ryDW22+QP6yV6eIup06FxHZlSRC9cgbx8zwEd3noSdygiVOlmRBuZuZWLtc0MAvF9o9fjJniqrC6J99xDSAKRjn2oVTqUESVn/QBLi+PRnw+mGi8UBEEr2eR+NBonh2SCY/Z5P4Lgb81VSBwND2tjtYjH/dfalERbzYtaR2hNjhWUswuRr+Iu68G90V7nakTgESvN5JwrD6cFUBuTbYiRJS1IUtS/1I+pDAeEZ+hjjSnExuybt8YG4ZBB/OnO7YPcssBUphu89G8pKA5+0oSYf6ipTbisa/cUFrfs3YGW/MUtcFVr5LwTX9WcYkrxeCeKgkCMNZmkVMWSAGT1dTSNmJe8JRUgoGEDMNo2wtEKhnbcZ0LFbsZe5ueJ+ol+YpYaqXi+uTa/5yaKwFY9BH8T4FQMCvwQG8qmZSiX3MU8iKHzXSHYxlKnmh195O8ktoxWohOB/EiasMjNwluGuAc0nqYRKH6QI0A2DTTpgMfrRFzJ9N/FRrbtI13LUKwptWPl+6w0EI7tkRbzqHu+hMrX04nwmVPnCUuHWIe1EMcHaMHR3PNPQUWMh3sfgY2kwCY9p8qZDqirUTIqWfD3IZIXdW6TZhmT5x/MldFhzAqbh4LSnvJ965PDtRVicHGTXFCMObJ/j8uJsIDIsLCbLhzkWjOEhNtGC3dktqEiA9ZS5aaXBmiSoml9/Qpb1hS/dTjDkCqC33yPX89kHqmiIMC8eAmw4z3cy3HzrjuBwRjK4MC2jxi7oMPWLizMhPr
 YCGeoEe7
 6wKvA04O7PRN7xjWpBe0RWsvY67XZDz+v02NJOUzRWWqZzvJGklTN/oNYNbA0ncd46G1NVNvaAg2S7dpWLyZvTUQ/AjoNFJg/9yHRuUZSOpBC820GgDifzcfgtUXvBdXdN5bS3D03yBoTMz0ENtU4wQKjyZuP10SMImmQyHeNR13781OdzufJMH2xHM32rCTYOPR0cj1YDMAmpGX7tpMgDs4TLVQoS7n0y8I7TYgh4gFc1Lk6oYZEUtoMQv481J7ijNYvMnlILJEPCyjmkJvYEzQN5lXojQGmR/CTIbr3h0qM+5aPNYt2Y1GDLGOI2t+6mx0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use set_softleaf_ptes() to store multiple uffd-wp marker entries instead
of open coding the batched setting.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5645f42c7152d..4a5537b02850b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1698,14 +1698,8 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
 	if (likely(!arm_uffd_pte))
 		return false;
 
-	for (;;) {
-		set_pte_at(vma->vm_mm, addr, ptep,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		if (--nr_ptes == 0)
-			break;
-		ptep++;
-		addr += PAGE_SIZE;
-	}
+	set_softleaf_ptes(vma->vm_mm, addr, ptep,
+			  make_pte_marker(PTE_MARKER_UFFD_WP), nr_ptes);
 
 	return true;
 }
-- 
2.43.0


