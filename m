Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE6CC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2715F6B00B2; Thu, 23 Jul 2026 03:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247D86B00B3; Thu, 23 Jul 2026 03:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184F56B00B4; Thu, 23 Jul 2026 03:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB4C46B00B2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:10:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75F54160115
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:06 +0000 (UTC)
X-FDA: 85019167212.02.ABD1DEE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBB9B40008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Df0v163s;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVv4eTHF09dh+DyrxrBJ0rQnudw/gXTTi2KW3j9JoH4=;
	b=q8EG155mKsqhonI9gSCFx53/SsnPLnT6cWHYCxPNWlWjiTrlIR8BAZgMe5w7Dr3kjOHPOP
	1cgeqWPCoKHITgusp6uGZ3W1vYMFIZCk7cK60hJzOG0fDP/SQeeIFskYoIlkx3UQOcok9Y
	PBUduhgikyrCj7L4bmc7deYkjw5bi8M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Df0v163s;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790604;
	b=bp+ye+ouqxPdqsaraR8QAowSlDVSy1E/doIqabFjiadzFAPQGamqrnht7+rIzMBkL9ED21
	AILPK1jQkztcsXLsgJ+/tiv0IwjjSqTyXQ9li0AueWUyBBIcGU0emoZkwxK7tD+dV5g74S
	BgwcL5VoqUu+D46FMgPMkzLFxoAdtVg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F40B7176B;
	Thu, 23 Jul 2026 00:09:59 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3D3543F66F;
	Thu, 23 Jul 2026 00:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790604; bh=pY9C/DKaRJlgJaTT58SvSufvI+KYK9kZxpw9s7MRd4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Df0v163sTfjthlVtPX1e0oHG+EvL4hIc2Q/cV6ZcHREfJdT5mzGdOsbvHPIIc4PnP
	 pGklRbixeXi3TdT+QVNX3htoEoO5rfsLlBZssYbmhYLCi979b5o84eFFojU0OC34mP
	 azHaztnrNvRke+ae4jz0+xS1/32gf8sh0p7JAFOU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
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
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 6/8] mm/memory: use set_softleaf_ptes for uffd-wp markers
Date: Thu, 23 Jul 2026 07:09:02 +0000
Message-ID: <20260723070905.3422276-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBB9B40008
X-Stat-Signature: ufez4edq7mgynntaddro7q4w5rfiw677
X-HE-Tag: 1784790604-455931
X-HE-Meta: U2FsdGVkX19UFF5VmNWUNS8gw/yOo5Pq2OmrPE60Ecpv9754Bp8bijA7TQVe31HLFmKYE7s2EETnmv4+DFc5r9nf6+1G52cjdiD1s+l3vm+TIxPat3dCEZjT6Sd7Qysc8BP786G7Mqg4YWC9bwXFtx+dGsi/fFLqPOmYdINZsSlpXn5fziVsionlOkgq5kfrLwp610aN70zWwc0gQtIdoKM+Bo5D04jOKHDPxz3y9Wwkge0EF94X70dtZoKBH3Bj3/oGo/LH0kpqFnUnN3q9II03WqH4dflnBFtv9uec/UmmFMJ/1yMnBcclYcROTC75yEEfDWqHD/bUxDZUejDoe9IkDAxg5jr2C4AXt65lZhuEvrwxwRlRsI8hOnNNIXAozLbbw90Wa7PQNyPIrQaXLMRy7uzV2pu8H/z+bANKxgLI12tMxgaw+bZTu1GvDzReVOF9aD45DJXk3Xmhuy487tNx457pFjZVtJXpS20/oqbxBRuDOltA/WYNKTZ47rFSWiypdqRDdxKn+T9XViAsozNuZdHYWIILJVz9OZ4Tb4pTitVF1xnls9pQCDRa7pEk7Xqd6n2abjdt0jqS+B/lra8+1rBVhW6aGnM35FT2g3J8RYL+Sv5s5jxUySbJxGXD++q1Hh2i7d03F8oKGmoyzu43i0s3RpJ/hzDM/vt1eNiI9GitvXuteMkzZQBCPYGAaXtGvUdjUCxUrcE83NFxxjyOtHnQ0I+nsJIXYAWcxu885Xs0uLbXOusEj46QNhasGNglxt83Kv/HMSC2pLrh4oeZb+bo/LHG6B7Z55gFVBySOIsRLk3VvUhfgWcpN7O19VM+DxuGcFm7fJL/bggUD2FqE3WhoM2h5itLOCN94g4jJiIhj7T9mtWpeWaCvkSkp5aCZ1zqkM3RprFo0bw0VNvjdbUkZWAIBgsibknXT/tr4ASoWfeQjBDSiZnFMAqTNsRSPg7v3/kATME0FWt
 WAvpGT/X
 +B5+zcM8MdAD+9IDB7ZvPeq9PaQAqE24PHew7srpZfhm/qqLtFOcc0zPzigSvOCrqkBQXBdtdVpRY/QfMQYTK41Tyq8nccXZ+uCzggjPnLO8yxKuIXw33iHATaEuajC5VNwAH5G95sVRNx94tolf3efU3W48Ikfv2LNarH/pv8e67N4tsEU55grF4WAvwtPeJ38ccnhWuNt3xn63kYvT+/K8t66g0H9Q2uzDckkyCyUxxBMSVG+1+SSPMk9drkYmSP/DSHiPcAaEvOoCpyAcnVSekijCK4h5EHeXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use set_softleaf_ptes() to store multiple uffd-wp marker entries instead
of open coding the batched setting.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7a8442fda0b51..390ea3aefbccb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1733,14 +1733,8 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
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


