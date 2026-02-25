Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E049FD3773
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22BCD6B00AC; Wed, 25 Feb 2026 11:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2FF6B00AD; Wed, 25 Feb 2026 11:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B07D6B00AE; Wed, 25 Feb 2026 11:14:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCB7D6B00AC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A584759E23
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:20 +0000 (UTC)
X-FDA: 84483476280.03.3A1399E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9630C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+gtLgf5w1Pu79iysL4vKgVbs4fWJy4Zbi8NuaeRCx0=;
	b=4QHIRY92Zr2c9SDc5G2HH+yQIEme6xPKYfyAPl2ByZBWeLhMGQxpW5iRHJOmZSyYQd0NP1
	YmY/UamGzxJ6O8yJOXcDfeUW/c1U9UWT4VrOiWNrz3KPyKhuIdDHsKLKOB4DL/73WZ7tGx
	qIzO12uaJ9rhp0mDwttyhpyqJwcAbn4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036059; a=rsa-sha256;
	cv=none;
	b=1OD5LRTp7CgZIbYjZjvXMgLHZnDKm42E0xmOh+w6sqZUM3Sg8pIHFWhCzQhogJyzXmCvnZ
	YN+IKQu/VygZsCrexRSjIK1OR7gJ+YFu228iSWi9ltnIEDROvEr/U9PWR1ssYORMPUS6VI
	jaZHPIrf4cICUX6yZI7eULm8R78oO/A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A02644391;
	Wed, 25 Feb 2026 16:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D49C2BC9E;
	Wed, 25 Feb 2026 16:14:14 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/5] arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:13:59 +0000
Message-ID: <20260225161404.3157851-3-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ttb8x3fbow6crg6bdawy8o393uh8qcy
X-Rspam-User: 
X-Rspamd-Queue-Id: E9630C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1772036058-67093
X-HE-Meta: U2FsdGVkX188iE10N9QHWeLcLh/MdJG8n3Ay6VAgwCcxvckBbODfKeqCxtguRNbS4ZgBJ5ORTsGocDNf8AVNz9MvuB9k8+xFPNNKiVD7BSzemEEFP41JQC+6T7x5Fh5YWRROswV/BuT1+BwcKtR8yXSoEZ9Me6VlDmjTE3rncARmYMq7zLPJx+tE085bx8r8J4eREABIWA96KWxetXWPW911RKBdaYD8BUDXNRJ0FOdAFx+CU2DSXU7aEd7olRHqIv/uldXogS+s7DJq+2aRWAchondW1cqcks1+EdITlTf74DwEYPwUt1fcKevsd5DRDI25HS7axdNSRUq44ANFR81V6Xvlfr0mEk1UxwIQ3O8s/POWnGb6dskkWvJuWB0FzbdxR/mQClPM7qzGADh5tyTR2Vp/8McRMh8gg3qoBMTBhqw1MmtmnapB5sg0N3cgOrcOdcArS7tMtpz6TXCn9gaF7jF931FewQjcnXSfFbHYBqt6Nzy2lfSSCTXP6DlrBoh6txNJDQS9VsTheAn0DP9UcCYe2YUc8UlxiohQc+kADDFlSfyd/rcpc4yz1qoR655st6qLZ/yioywu/vxJqXGEPuHzDm5Blg2gIqF45aMWGbPX/7A15hv5Us8iZwAt/dzn2LLfKZFfyzOyI0ui7Iv4wWgxoGqHvGA3k2vikt1h44tjJgfTjL/ApHa73VDpPEoVmSHQpcJ8qpiCyB/cLov2KY+HO5m/Tgxu/waZDBBIr+WFdB3zMVrY5g0zcwpYessSzpQ+qv2gL329V039XAh+0WjlVjFb90AiF+MHGNzE6nBeC7oo4nrOcQ7AAnPjrte/zXQ/kOFU0XexkWm3Bz0dgg4cuPGk5sBptD1ORZkswVvtISepr9JXU5oL+Wxv6NgNZBu/4POl86bwLKZ7kEuBcpmhRkJZoudFIHLVyv0HqTtreaD3XYMfd80hcU28dju1ULYS82f62+c6JBH
 Fz+xEpnf
 k0LBLbSmRMcfnRFFOoVJ/yCKK8KrxqPJGp3+KN5YY3GNRbvjyDBvybZGs1Rhx5adTpG9Zah/V8RIRXtVi8W8NgzU69qiHgl1L7m2nXQR8s8zTffApRfjObCN4ETv9sNft6Wm00nUldNtQCzF5c18saWkKrr2KvR9v4k2JSa+z2WgPpdleV0EfBiJThbl1oAyD9lRSKfri77HjcOw10JL+w1Xkvw5PiCTFG/BQ4BvE+YBb3q0E45dGv7TldeBFCiEPkNB4RxA58srbwAjQ2on+swqa5VU2An/1jsWlLhMjYLYjDmCR4alq1pTWtH62NES33rU9d7GDWsRI/FJ1RVxUyrO/yCFgSELW31lB/KPdHPpbv5lVzO0PbmafM87cmGQxvU8KoJo9QOZegQ8WLyRRzWgFzV6pxJVL82Nf9ojLcoPQOxx+eWv3Pr/Xgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the arm64 map_shadow_stack() content with a call to
vm_mmap_shadow_stack(). There is no functional change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/mm/gcs.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm64/mm/gcs.c b/arch/arm64/mm/gcs.c
index 04a23a497f20..680749611a9a 100644
--- a/arch/arm64/mm/gcs.c
+++ b/arch/arm64/mm/gcs.c
@@ -12,19 +12,7 @@
 
 static unsigned long alloc_gcs(unsigned long addr, unsigned long size)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long mapped_addr, unused;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	mapped_addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-			      VM_SHADOW_STACK | VM_WRITE, 0, &unused, NULL);
-	mmap_write_unlock(mm);
-
-	return mapped_addr;
+	return vm_mmap_shadow_stack(addr, size, 0);
 }
 
 static unsigned long gcs_size(unsigned long size)

