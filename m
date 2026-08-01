Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB0AC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B016B00B0; Sat,  1 Aug 2026 04:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425686B00B1; Sat,  1 Aug 2026 04:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AE06B00B2; Sat,  1 Aug 2026 04:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12ECF6B00B0
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89A10A0263
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:51 +0000 (UTC)
X-FDA: 85052077782.22.28085EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E3668C0006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZzxYM20;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQosUYO4otaOOPBXErhM9wH/IqlhFzgBsL4CwmngTEI=;
	b=stw9dr7YjKL+j+ziPrlrMHEy5PiBOlmnO5k9njdFZNPWSgCsnrDPYS7N/I2VygGL0pT5eK
	vStaxEOxcbusS/tA1WzAM+ItUdIAZBJncItRLwUT4RzZNVzSUfNcGcwZvoWl3itpAX5xwS
	vnqmd1Fc7hNqxztPffH4uVPRi2LDJ78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574190;
	b=SkiRAuUUPYy6d1tpDNzQDbQE0C33KRo7YLE4MSot3BJdMELMr2WfdyWvJTVxY1y/wq24re
	8oo0u1Qtwf1OYZHVnWkptXRXUY7qWb9p5YvTdmjhZ8k/REsjJHaBDv3PNsNvjjnyGSgb0U
	TouOdsijBVont16xyuNzD9mZhmqpe4c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZzxYM20;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D6804008C;
	Sat,  1 Aug 2026 08:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D6F1F00ADE;
	Sat,  1 Aug 2026 08:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574188;
	bh=dQosUYO4otaOOPBXErhM9wH/IqlhFzgBsL4CwmngTEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZzxYM209HdmuQs30ywMfS7hGTM1kcicCg8/+nKZSHT/B4aWmsgh0pYDT4AHJS5sy
	 KLTCnkXYlUorqpNTo+oVGuaRKqhC0IVqxNVDUJzpnjRiXZy2Bid21v1ijonazhLp4p
	 6DQT87sHYkjHrTWG1SDtkXfkxUKQjmOI5AzrFiu8JjBiHxr9HjNkg9quprLHb5xUyg
	 pq2U74ogPuOFHNb2BAHa6BrhDK0uamUN7bRifth+94/EIcA/2GsOqTz8y3s6o3Iz57
	 ZLHT7BsI+r6b7Mf9ZUSvUKO0HHbqQVpjx6XEub7pGkg2S1MRCZjljIf0avZJhJtFQJ
	 a9KawhTP3qkRA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 22/22] kho: exclude hugetlb memory from scratch size calculation
Date: Sat,  1 Aug 2026 10:48:31 +0200
Message-ID: <20260801084833.1897543-23-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3668C0006
X-Stat-Signature: ut4dqke6u5k1r41n6umzzr99basjs89s
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785574189-603053
X-HE-Meta: U2FsdGVkX1/PZ64OAn8nj7wp5DrKLZEr1JXuLa7RdZgUJjm+zlBxECy/oneVUZeqmGVjWcaR36MGHSLM5vD4WP+pPFjIfnvS9Ix4VC1m2Rd3zdbDWb4JxcJJqT/9bgWcEoulohVMB3VjSUGqg6Yrs67pMjO+gvtrInZTKZ4GmPa56g1Mya464MRoIz8z491f7Rbw0JzY1MEtfOVNHOEs+e3McWSSqcTxNSJUvBa0BjTyPca1LF17vOLU+llMjmdH/s+d1ubBMV0j/Uc3VbveDhibrTwTjXbzO0TpVPpeqbNxyuC6J451DkLoSNfxs2gkfArKNWciSCJHik+0QPbcoyScqxz5T1CqnP90x7ENEwaWO3GOUb437bkVSlIAQ8XFkNUwyICHW9OlnedXb7LA7JP0FEVUu0MebPLZ86EyGqkUAgq5lrustHMDbctCKZgsdKGReYnWqT9QHy3mlnaVDUoDK09WwzjjhOdAzZxFGp6KddLvhWiVLqaMVE748V9zUUPaEN8eG7z07z1e6wKYslbxahDGH08MHtOdKkHqPIEHEyULQeG5JFlkXsTLsg8EpPOrViAFinTyd3en5GaTU8xs1aSYm2DnFBSHlGe316INBdnXu+QDZvQlPvEYkMxnFiPfRLCtbnOabesGOBhwHh7qlzsT/JBGTNRexK6qSQKuLlc4nDBOLxvMzk37GORguXJ7wYtBud7EyySNRLYmTBSzJOlbRvbLthxhxLXEztSDQ3eHWU+3Q8WVFUKpOuIy/w1s6pLr/XkW2W17c9CJbmkbvO55hsB4sD/g2TqLiBiooBJbcndTGJQoGnuFfn/jDPbQYL5Vc0HkcLLjYjM8fxDoVGDpoqxOXlRoZh5+KCHh7szTG7DI0hsqb3Z6nlSAGCGfpuyWRlXhUWlj0oE8+gHz/Ox2po/gkVt33feLNXo7eaUz0cOdc+mmwWNLkrLvTcIgMW6cRJDqf+7Nh9F
 r6l6aQfD
 e8eTxSwB0paxHDL89xJAJp5e4aFMpcHELBVm5suPAPmFDk68VsrGleNuWb+m7y7ZKBdc9SWAXAETQl5xcOzw17RD7rOrqG17D5s26KDaGpBcp/AhPjA+2TaQgCHuvGTbUpXXQ50H60L/jBULVJoKvoakdFCksB8f7QGX0KWXDOfX5kZIBEUZpVHGi8PR39p4BAeqvSrC1ltV8X+LEuWXYezXSLJaCE/KKZrxhcPuHwfWFw+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

HugeTLB pages can be preserved memory. So they are never allocated from
scratch. Instead, they are allocated from the memory blocks with no
preserved memory. These areas are detected at runtime on each boot.

But since they are allocated via memblock, they show up as RSRV_KERN,
and blow up the scratch size when scratch scale is in use.

All hugetlb pages are marked RSRV_HUGETLB. Subtract their size from
RSRV_KERN when calculating scratch sizes.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e649e68d861f..861621faa557 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -742,19 +742,24 @@ early_param("kho_scratch", kho_parse_scratch_size);
 static void __init scratch_size_update(void)
 {
 	/*
-	 * If fixed sizes are not provided via command line, calculate them
-	 * now.
+	 * If fixed sizes are not provided via command line, calculate them now.
+	 * Remove HugeTLB allocations from it because they never get allocated
+	 * from scratch.
 	 */
 	if (scratch_scale) {
 		phys_addr_t size;
 
 		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
 						   NUMA_NO_NODE);
+		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
+						       NUMA_NO_NODE);
 		size = size * scratch_scale / 100;
 		scratch_size_lowmem = size;
 
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   NUMA_NO_NODE);
+		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
+						       NUMA_NO_NODE);
 		size = size * scratch_scale / 100 - scratch_size_lowmem;
 		scratch_size_global = size;
 	}
@@ -774,6 +779,9 @@ static phys_addr_t __init scratch_size_node(int nid)
 	if (scratch_scale) {
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   nid);
+		/* Do not count HugeTLB pages. */
+		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
+						       nid);
 		size = size * scratch_scale / 100;
 	} else {
 		size = scratch_size_pernode;
-- 
2.55.0.571.g244d577d93-goog


