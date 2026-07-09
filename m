Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3389BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD83B6B00A6; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88DA6B00A7; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8566B00A9; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086996B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42BA01C82A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:28 +0000 (UTC)
X-FDA: 84969950016.22.4BED334
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97D2A4000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uc5holxa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo6vG8Fck92Ec2ICF08h9HWgylgcmuoyS4qHd/4tb4k=;
	b=ERX9ZNDYZvFHzcbzWv3eYadC3jvfTRZWPd3Fp7veWkEi3DrLqDsMO/e2bunu94XXW2ecI5
	+en+K4TKiwwo29wuFiDKPWot+L0PZ5PcTO95uUn12ry33MKbi40A44lGACgDd3YkG4w8sv
	7XKoynbjniQ0QtOiZXBQ2JHD/qgYqik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uc5holxa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618766;
	b=4jUJvuPSFz1lvTlKezP5e7xZVBPitrx4UnGLtBkZ8CD0J+zTCHcD42Yq5CMCQBzB+DD3Jn
	cYr4+ikg2V20uWHXi2bgc4iQ/1DuG1Wy9TrYEsvxGNPUVoi5gs4sWc81ARhgpxiPQAojaC
	WMy08VzmnNMY1akJ/2ribMcbNOgNTvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8FAE42E1B;
	Thu,  9 Jul 2026 17:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70881F00A3D;
	Thu,  9 Jul 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618765;
	bh=Jo6vG8Fck92Ec2ICF08h9HWgylgcmuoyS4qHd/4tb4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc5holxavp4JQIp7OghW6d0zZ/963AZ+EpsBk1yFU1Od1tM2H46v8cfDKe5Y/1b7a
	 zPE+Jce/p0bDpwIpMAO+1TNlNXAM+3aOHUK6MvXSfJDwrqzKOh164kDbHktkLBbm+p
	 uRIeolRBn7n6PqIoyLDfxFWUWoJw4SCHffrXva6IJV314NFnGKEQ9r7jnm3SReA++R
	 He/+e8OXxBI5iiy5LFPHG5Rt4eb80rcmRcILB6xzCJY7T2/wZ7WVbVFLWFm8+btt2x
	 UXyNXG6EoAwJXHWTKr1OZEuEIbAL9+HY410UK9qfnlU7sC++R2yFAwiv8cu+cuYR3E
	 XQPAq4T1QQlAw==
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
Subject: [PATCH v3 21/21] kho: exclude hugetlb memory from scratch size calculation
Date: Thu,  9 Jul 2026 19:38:10 +0200
Message-ID: <20260709173821.429921-22-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97D2A4000D
X-Stat-Signature: hq49ho7uxxcukapydenqcb14yhs4obbr
X-HE-Tag: 1783618766-52970
X-HE-Meta: U2FsdGVkX1/yU42xWwFgsWx8luIscyk3K5ZlejFe3KO5FLoTxR57NUzELHOGKy6ihRLtQ5d50OMV4IBb2ZeDioI7a463qcJxBZ5+LTRo/+V3+qaoxBNzO7OV/thV3jodXcNVPKpbhI0FwN/xliziibZSANw30tUMxbAFIHaJ43P4dDq0DdJSGnOOCJ9A+uljF4tyW/SFfYIOHUfxP0BxJ/s8kVewyblqXnZW7fNVkcnG5sI0amFBfDlmJ1nf+PqACy2wg/ldKURL1DZgiEz4c7KUKwP5IyP0r8d8qHUS3WLJD7xVsnJCLgXzclhfXAzxncbeOqqU4xZaKbAeKfMrmdWifTuJb2fTVt33QrQvW+ccdHOqE2595jclwjLGp5lSh6SMyej8R/jLz3j6ht6aWkB31kppgniXvHOdoKpNKD6CWbe6Msq6TnOzu7xWIZnvXLeWCubN8X9BKm2wBF4LaE0hYqc6qRE4r0EqKkapMDgLiJ5ogdgKZn4JcQcObc5TA3UHDawWC9KKuY1yAxKP4+uWRiE/fI3w2NFTSdCEY16cZaSMyyZC0Gt4Fus6DCwWmfnW078t0fPpejwqmZJPx2sPSgl4vBPQ6vcTw0ropJlcYBiSdzkU+JXeUSSMb2BzqADqFU2405LfmMGVzwJ2bv6xAld6b3Jrd2FMOovUQ1vxlNv319FXUSNDOKa8Xi9HSff1YTRjm21ygKgB1IyNiWuJc+CCwYdc5ZJZ8OmykK5x9iz09YkXsOBmz98q4ZFeoImq7oTrk/DY+ZTnA/c4bNdtPAhdeG5H4JXAs9tA2VP8cSrxl2awq6Djira3eBGyzyeEqUFlczaC5zT2Q2W1oDBfmOMPLDCyoiQe1uDWC00HwpboLzn5/lAEUhvTauAlPw9hCo6vxCm2dKnCkRfyI0V/Wo3wb02QlHDywTx1ZavmwiJj4ayp6mYS1OXeOxST0HgZasYlI28REciVkWh
 PxMI56gM
 6ndcNFITIjg8RedXM4POSvtMuNk1uiaA/MTlmrlHIWVMRHZPEbP3ahVoDRwHkwmzmv1x5fZtiJK3mA7hmY1e+eY3AIBv3oqSn+Df+afCBk1kyKlCdgsUB9A7EH6LkFbQ1D9eaA2OpC9N1lnI/agH1SjZ+heU034psSps94o3WLhQXenCEYQ2JPxk/7lN+h4zAkhZP+MpVtqZd6uGj42ApFEH82WdWutk/tEX3L3KKpyL6i6Y=
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
index 2c4848874629..9dc79b7103bd 100644
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
2.55.0.141.g00534a21ce-goog


