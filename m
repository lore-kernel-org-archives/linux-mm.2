Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA2E606A336
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n//9uE/L
Received: by kanga.kvack.org (Postfix)
	id 5B6C36B05B2; Wed,  4 Nov 2026 11:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567D16B05B3; Wed,  4 Nov 2026 11:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CC76B05B4; Wed,  4 Nov 2026 11:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 281D56B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:24:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5F6312076C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:24:34 +0000 (UTC)
X-FDA: 85397959668.02.9F0A18F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 051B414000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:24:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n//9uE/L";
	spf=pass (imf26.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793809473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JRqUizjEpje7QENpLEZU+9mQGGXBD071wudl9Jtl/K4=;
	b=JdMP+3h0LWdnQhdz+ArL6lPaWdVwyMZ3ZLsOueBRIpVJdwozj26ChIwc8hjsE5P8BR8pdW
	DFHwVDJsLazlgcDhqBdgfmQmZzDfTRP+vesThAOgvU5b5OsHu7nq8B3uBCGggT+Z07Olez
	iAgP6DqYU3slGCdC2RFV74Z8zSd7Qsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793809473;
	b=RbRWcl7zqbLzTfU1v4DOaawNuqcTS90bMMZEzFUpiSoybsw8CwQDUfdeRE+b3sk4//tGeo
	iFiwNLpJkKTX4HdwKo5rCtqk/OpoSFRalqZWbmZfxlY3Bi1HZOp1cVYlmXmGmorK78B2OH
	4I9MspiFy2SFDqsISOUifS0g2e9vQdY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n//9uE/L";
	spf=pass (imf26.hostedemail.com: domain of blum@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=blum@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 181AA4050F;
	Wed,  4 Nov 2026 16:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4F21F00919;
	Wed,  4 Nov 2026 16:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793809472;
	bh=JRqUizjEpje7QENpLEZU+9mQGGXBD071wudl9Jtl/K4=;
	h=From:To:Cc:Subject:Date;
	b=n//9uE/LLh/XK+fni480r6cjyWYb7TawE+lJ+nlMCdKpTyZVWsyzuyi9q4dJ3a0f+
	 FSaZK19iz7N2ZTdqnnALa3Tq8GzwmpV9o+woIneY+hEQsVTMmNuMl2XbnDVunPV/mu
	 QIX7XP6AKzt6uxXGaZ0+ScBNIRv6Hifni0Ty4DM3oCbzUAmipAMNoVnQ3BzgxP6YdT
	 58oBYpOvPGVfbMePIccUJSrQ0EiCN/HAsLCtbieDkI2qhKGDq6x/j3CXxjGD+ctDCI
	 LRMjNyXSzBceNF2jnZ5+4dPhi9kfcNpslVLBo6S9ls7wJ78JiXfzKUTZc+j/6wsKnU
	 IIGuOjvE9TVDQ==
From: Thorsten Blum <blum@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Thorsten Blum <blum@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] kho: Remove redundant 0x prefixes
Date: Wed,  4 Nov 2026 17:23:53 +0100
Message-ID: <20261104162352.140836-3-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1480; i=blum@kernel.org; h=from:subject; bh=Qk9hkzySWCprpSeEAqGuirPu9rol4ZAWn2j8lvg6CwU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvYyQeFTc565/p2DvLqztdPTfhf6XmBhsuwXN+6qsWT VPLiGXsKGVhEONikBVTZHkw68cM39Kayk0mETth5rAygQxh4OIUgImYBTH8jykpKDcz62y7q3BS Wj1pjn5WxF+GH+VRpktiF+lWsH5rYfhf/K0qlZVxe+qeGbw7fOc++HkzOmnZlg6NvitTV4ooXd/ LDQA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ekf67e1cezh6jdcnz7q6br9jw186c7qa
X-Rspamd-Queue-Id: 051B414000E
X-Rspam-User: 
X-HE-Tag: 1793809472-31683
X-HE-Meta: U2FsdGVkX18DU7fsILpRJLd2FszlRwVJ2UMrS14d/8ZMXL7d5oJDe36KX1tJsUfPP7UnVq1HUkeKDkIvZs6958zK+lyU3uEtjcajXuXGKk+S7sLEoaN6cdYYKrlujCh6Mgx3IuiT0D8IrLt4MdVbVOh0AoPUxBfVsupW9EeI4bC7rKWsiXEZnqnHJifNheTQcDxGdWB44Vh3nbVP5IGaiNx+6jS0HMSf3+LcOTMK4Z17CtHBkwO7yzBtm5gLviSCOQuaPZVDbYeUZeD0YgYxAIIBoqD5UCBUydLXcuGK6cw+4QVt53g9Js9d14wY0crY+y38IohgRora1akzvqzvi8ijj2Vcf84TXymcZACxNoJtXmpXGxyQH30xG7L2sXY6FdTp1bCyBCLn53sbPKlvfv3ByExJPq0CxFh9V85BOSyxXZrpC4BQv/CNvuTrt4mDLB0TAVEdo7gptJQXoNG0YD/xE1HMSSjhnM81hLxWzLW8q6H/uOqGufUHWMfceHQesOgMSJbSn1wwSgrAWSr+WnsIIWN+Qr+17mQ/yrkKZG5oZ9MMHekZYGnHfvpw+Aqwn267X7a9eCfL8uGWtwZPYvGPqHRTXZT0s1PLmPxxJl2ZqwJgtnVNVl/m03pkDZdnDDuA+WJtgmdZCW43TQ+2gvXGAi1qP/d027Y9KuCphRiIT0mXK8Y3o84w6fzscioLJwN+0wo1A+0mWEmelkV/V5OWaYlXD1rA251jvggkFBk0VCd3swS2LGRGO0WIth/+GA1fqrj3fuVa8kNQEPOxxnCTNvWy0MHHZ7Un3Oqnojex8sn3ZBzNE1tbgoA0Xilmol6+CBkvtDqF9P9dnEnMfpzDmfyoN4KAt7P7ro4qQsAcHM7L0BIfpZhDlT2uUomIWbYnXhfmQAZrvYggw7qv+e/vfA3YpAZt2vXNI7PhUtDyek4QTZw3NtcIXMKA7w++6p+17iR9mhjrFuRS++F
 NvjY2BaV
 kG0N1uAkaT6Ncq6Ux0y1RGGSxPktvlrMi1JMw/InfypQi8PCZd0b7slC1Qm3b4C1nIm6Ul4zbTuf4NIFXOSFNcQ/a/7+WPeXax5TIvJ298F9evVDPwHgKpEF+dC3q8n0yfLvX8aIODr3p87dfwYx+RwUDyJ0DPGxnUn7OfTQm93ji1E9vhHW9rV1dttOnPNg516CI/CQRNEovgrNgt0/kjQnfSmdpxRKlinE8KbFw2bmjE/5mSvDIL1q+tacMhtBoOfRbtoaupPsgTbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The %pa format specifier already includes the 0x prefix. Remove the
redundant prefixes to avoid printing 0x0x.

Use phys_addr_t for size to match the expected type.

Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
Changes in v2:
- Use phys_addr_t for size as suggested by Arnd (thanks!)
- v1: https://lore.kernel.org/r/20261104160931.137174-3-blum@kernel.org/

 kernel/liveupdate/kexec_handover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..6a7600a0a7d5 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -2010,16 +2010,16 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	 */
 	for (int i = 0; i < bootmem_cnt; i++) {
 		struct kho_bootmem *area = &bootmem[i];
-		u64 size = area->size;
+		phys_addr_t size = area->size;
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_noprsrv(area->addr, size);
 		if (err) {
-			pr_warn("failed to mark the bootmem region 0x%pa+0x%pa: %pe",
+			pr_warn("failed to mark the bootmem region %pa+%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto unmap_bootmem;
 		}
-		pr_debug("Marked 0x%pa+0x%pa as bootmem", &area->addr, &size);
+		pr_debug("Marked %pa+%pa as bootmem", &area->addr, &size);
 	}
 
 	memblock_reserve(bootmem_phys, bootmem_len);

