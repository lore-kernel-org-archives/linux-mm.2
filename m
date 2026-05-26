Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B0BCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6646B00B4; Tue, 26 May 2026 07:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE586B00B7; Tue, 26 May 2026 07:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4326B00B8; Tue, 26 May 2026 07:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDCB6B00B4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8272E8DEED
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:28 +0000 (UTC)
X-FDA: 84809322696.19.ACC9694
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B74A9C0009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="f//46ng0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CKL7Kj0ZKCAU5/OJ/IEB4gg5W1BVxeMyN3Ks5LfDco=;
	b=RXfFjJRUNltyLfbi9AQ/S3QnP31vpaS9xKfvnutlp6cfZ5H4wpt3Szse3T5IWkKEIVUVdB
	1ub6uDP1PlSguBwid1jxruOjyS9HyuFgnaALpyA4I7jCny+sJTDAj017JOVHu2V3xtxFts
	QrVrPdEvScbjhXrzzg5AzGUY73s6Qq4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="f//46ng0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794306; a=rsa-sha256;
	cv=none;
	b=bmrXPwEzOT1Kt8U9b783mY5UMinAJE00/XZnBS2CQwZh9BcjGiupWlH3Rmir1NTyf9AupS
	lYBsPYPJHopQV5ug4BnUqEzpM5nG4y0U6BhSa8sCdFeZm2Bepx1jZUhJWxSeLNdD9gUKNf
	5nRNy2jJuPrjewX9Zat83IQPX7vcIYg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E96A2169C;
	Tue, 26 May 2026 04:18:20 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27FF93F7D8;
	Tue, 26 May 2026 04:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794306; bh=Ksvs4ETYtArM4OpjEpTgUeDGNdsc/o015KS8Xfe06BU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f//46ng0yqzXyYbz5KWfhQJnZiDBCx6Rl/sbBf8Rff2ghq58j0APCVuPAndxPLwhu
	 2jLygnKRBglQjL5M/9SLsXH8i6qwBsm7E3JigQ5taE1rvTutuRf5ktw1U6+xar480t
	 apzsdI4JWV3NqrH9OX/RukkpJJV/EsnBlMIaTfUk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:06 +0100
Subject: [PATCH RFC v8 17/24] arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-17-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1216;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=Ksvs4ETYtArM4OpjEpTgUeDGNdsc/o015KS8Xfe06BU=;
 b=HOtK9mBM/YEa1W1AKAgO/LbBhIoiZcz/bGtMqz+cFwafME0nEaGnjIA7ihVVbSs2asa0ZyTDx
 aJfHsBOF6KCCH74QPffHPLJRZ8lklx5Qz5Ia1O7GPTzyisbDFDX3/df
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B74A9C0009
X-Stat-Signature: e8okisjno9oo88fjb38s8e8nan7a1mrf
X-Rspam-User: 
X-HE-Tag: 1779794306-72811
X-HE-Meta: U2FsdGVkX19OIdcUvfg8nMlU4xCaA0c5r7O1bz5iVa3Ckfn3wD3zlKGWR4GpSB4npdtbtpB2fXk0pFmqk9FHDjVTzvKzdgqoIGwke5+NaJSCrIsn/fSn4udLlJrC/yeotDEqdzBH5prkKTGafPwyeYunCao4XxkYpL30Mcc4kOZuQnAogQd8nmxfrCeAhTTVYmJ8ntkd8sBMR2w0PchZ5uih+JYQCyaBZ8ILJc8nUBDFdwyPGeUl2QfIoeOuCYRVwnGnk+yUtLRTJFl3GiTJmF4P1MZ3dNYrBugpJ9V2+/CAeSaDCTIWV7Ado5n1NQ8jxSMsQJUANlN5fIjQPl+/cyW/dfgFYpO9h4i3Dxr1Q/9CYC1l4Y0kLzXTIQeOnmvWU8RPQWODNSYPcnVQkckCIipYzO0DZXdVFe6R4q9YHlhwgeFRi1eXk1guY4D5Uu6Tka9+vJSs1gDQK/e4S2DB3wuLxc3QplcbZC7AJPA/WnfGVWeh0MziwU2l5rkyMXDhIxjnPYK7VeokFDPGp+SoSUHq2vDt2CX0F2JNzP0W4swgQFdshRDp2MASGtwjgObY2M/0coLATAvxxflgHH5ZCkZA3SNkX9Y7y/Oh4w/OJqZIOIQ8c21tXRcjI+vaX0uvQMftR+Oh1cbsFwqSNMSmPMR3wKPF6krjCOVMBDB+TAQxRuz4/fWkPKWPKquOOkCd3D2WUavsEFutmdS22wM2+neDj3hWNhHO/jGzR7K4q976TK5zticT1c7bt3DsLToTICKLDzDQ5M9xunTdWfAeNSI029lDNyilDv1cxPaqFItPzJ2Mbn6faWon/fWs1nOrCWo3TQAqRxoKqC0Ux5hy0uvC4lphFnty0BJTFUlUZ5q5VAkPgCfn38KbOpuSrrRhFLG5yuEaj9JabYlJ3F7X3W2O8UEFzVQxVqVkTkg0SNcVA+ZRux/Z9pn77WzrcaI7Or1dKV1xD3xP6k30Sy1
 aeeS7jHK
 qMGVKtsrA4FrzPlNgilG6se92E1xr/v8kkZsSBQTTlsPXaCfSrCKCigb83UdAZzeOLEtlfitOn/iK29itG5vnEepaw+CkiWcRJMj463VABi256x6p8hqOoHVrJ9vwfnSZHlvmBa7xPmvWeLHfPLxig9UcdXLIEnZ9Hyi5wJnIOMPsDFLAzXHs9spb+35m2gR7KJYkAkxNugUB2lxbkgLsqW0UIoe1xmYRtAwC1reGtbqAH+fiyF197DKHpNUcfElZpXHvm3i3Mtmjmo/OBUTzbKXGm2hbGDYKmZewTYvf5XLvTqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_CTX_PGTABLES, otherwise only grant RO
access.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index fdf3ebe92810..c1daab643195 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -33,6 +34,8 @@ static inline bool arch_supports_kpkeys_early(void)
 static inline u64 por_set_kpkeys_context(u64 por, int ctx)
 {
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     ctx == KPKEYS_CTX_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }

-- 
2.51.2


