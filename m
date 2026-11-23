Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750FD606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XGkwHIL8
Received: by kanga.kvack.org (Postfix)
	id 324B76B05C3; Mon, 23 Nov 2026 00:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB646B05C4; Mon, 23 Nov 2026 00:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127556B05C5; Mon, 23 Nov 2026 00:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97796B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5ADB180767
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:50 +0000 (UTC)
X-FDA: 85465274580.17.DC5005B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id B79981C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XGkwHIL8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412208;
	b=b26rnXNlvVp5t8pjQ6CcOIfM/Ne07dQ2KlKlmeqKudgcHrk+mKDAYzVDqHvhW8MAqfs0KC
	FbLtVcgWurFRL3EHeO+Dk/at7rlLTJaTInaCDr15GvJVSxFILZ4485mNTnoGuUPE2ORs7W
	PKOPPqsVsJBRXA+NiFvT8LatzMa6n8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/63FrM6KPsryujpsP2D74ezLIo0Qrz4H+ARme6USNI=;
	b=vo6Sbnh2LgD522QpCkecqX/pQHtKBDM5Kdg7D/lkBrHT1JCLiRiFxdSGTp8oUaaVoKrFKe
	OhsaA073+UCHv59gbTjpQeN39ftN0w4Havxjvre5hj9+z2vBJO0jhBOl3CC1Vt7eITP6VO
	4V+DerrwDFVDIt2VznBmRCqF9rNN0Vg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XGkwHIL8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA6C6176A;
	Sun, 22 Nov 2026 21:36:44 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 21E143F632;
	Sun, 22 Nov 2026 21:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412207; bh=ySAiaCIFku47qOMFRwBe/TwyM5GOsN8gN8bQGYZF/8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGkwHIL8j8HY6ogCuDw9Rq0sCIGAUDLwkbDN+nAti05+RpmEuDionVWkePLvITOws
	 mzALjszvwJg9Hqg7IcERcVJB9KteeOC2/mFUssCHSzpb0sTZi8mrD33uRfoOXu3REb
	 HE8vAtoxridjEyw1xVFmDiL6/qgy83wD1RfH+ghM=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
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
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 7/8] mm/memory: use set_softleaf_ptes for uffd-wp markers
Date: Mon, 23 Nov 2026 05:35:41 +0000
Message-ID: <20261123053543.295467-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B79981C0008
X-Stat-Signature: a1otszausa11wrpztgenk1k57s99u97c
X-HE-Tag: 1795412208-946074
X-HE-Meta: U2FsdGVkX1/vJretqnho+7Kyb+iwz63R59Se4djra6WgyNsSSv7wMmI4+eoHFITDRYl7d3rUwj+MpIFfcKQO8p/pjX6yh1F2vgvFVy+agqkSAYkF51pdgpcfvMpV1rpY+Ox202aMhQ/6RQjBJPDQV+uhKCDBhwQJ4PWgOuz/k4N7xFg9TdAT3GZuYNsoVTmKow2iYXG5kUx6euqxVs1CuAwD0eByaWoParw123hx4AW+mPr+GWWg2HOskIDeE7yhtx/13hiwcnwuEv4eJjyv/9/yp99nzRAIjrBwD79ZkZR70vv3uR2nfBi/dWF+yiYRP+IeFmjiky4ebdYtA+OZjFo8ls6A0/vvdT+GHN97LumuvJiPhYDYWNvbktKooqcv3sCyX4TuVrGwuv1260tQPuNVEEaOEjrYg9FjTBT0Qcrc/ErsiuZ/2iQ1HdTmmikv80W/cK2kHfvYRF/BLwd3yUG8h/T1DJWEIV7gfBLe2kwI4LWe5xJYGWk7NYjhJixqY2ORyWKBTXAf7ULN7l3a3IKCBs8aY74+Qw+ikhIKHnp653Pye+LNACnG6jt9D4zU4JFpkjKki7VyZxu5MzTE62NQVEOW/FpUdPdA8xoiTw51yzWqz1PkkuLLiBLXX5UzK/Mkd7NTH/u+sur1d+iDMzZbXmwldCfuQbPtDOW2qcRftbA45Ce21sY/XODLRnWtyBeJXySmQLOv3XLlDC30N5apaxZwXKq3ylVVtRm67n5FMwBh82gMLX9wD5JhnOW3kXEaM7G/O/Th9sqvavicwVI5tZH8T0XGZMzAyogenS5nRe6aindG8g031+e/NJbFlBeS/iPxN2QGgkpN4c46Hnwgvzugag+JBZx/XzBYsS3mey62RiPTkiN4ZSp4hw1hLgH+M1o7bb4LwcvzHm9SaxhmsxF+v/pdxs1zSpTGzMFbC/ns849E5iZ/krk8NiGB7h6b7UBfup3SLN9HHiw
 grT6Vmlf
 pCDCZJ8HFK1fBxil6hS4d5Vgav2v+/Yj3vGxWnx2MMR5YQrBfXFB59B3NuZgRYljRwJo65Ojlh9VGPtZ5ucAl37CInFNthSzMZwusFqqwDL1pYAWPlC8WrAzCE0BamZWMw8OpeYKXbescKtpGqcwt63LpOC7iunZ+9mJNuAZmzhMQKcFZB93CyQWQlsLIoT7FUAuHeDJt446ZeGo+tfpCHwNZVSv6ZFnIvOd3lRuQRAw5lPLPNvIR/221PRYMmICZLbCa20+Hz4jKlUES6erUzwpP/ERSosfJlyhWt4J6gSsf37eUcFYiE+f8H2Wmk/+FBKhxg6SkzJLmX82Jsk9tZEZO3TQxB7jutaNCXN+UBwI5NfHU67WCQwCX8n3VhpThXWOekhZWirEQGTbRetVRVLQdpi3ScAX9XN9rvUvzKnhSzEyXVHTTLlzxSpAPiIUrirCfP4Hi1qJZx2yXPTmCsJI9xQ==
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
index a9a729d55fa7..7ca277687f4a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1715,14 +1715,8 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
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


