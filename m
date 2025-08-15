Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2735ECA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB31900226; Fri, 15 Aug 2025 05:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B2D8E0002; Fri, 15 Aug 2025 05:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A3D900226; Fri, 15 Aug 2025 05:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D898E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D6A51408CA
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:19 +0000 (UTC)
X-FDA: 83778395358.26.D852F2C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0F5FC000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WWMyLJjFwfDhUGhjD3NSb7U3rCUdr5sjqOjLOhtLe2M=;
	b=8hxBZNOBYQl396SpOWHliTfdZnKstumz/SBIMjCbnpPo4sFT2L9RkSSXLUH/3qs/Rm+zfv
	IZnKjI7zMlpUUXb/CqBpaRzyITYy8BuFQwRxs1kNVweR5fsdRha6uMBAFDuCTOPLrOvEgD
	bRz8RWimL3PTEdwoN5JujsTxQxpkbNM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248417; a=rsa-sha256;
	cv=none;
	b=lW10iA6n8DByuAa863Jr9fytVKot49/HlISxM4ZFiQ9mC0EgH021BemSzrOWSKKeh3I8g7
	NKYmOi512Yyi777CCESTU1zQ4DN/5xaTh4ZU7qHFxX3aChSLOSGdDy+loz2ZhV1cXcOOh9
	xb84cOytYfv9Da+39iO6a9+5WIdzHc4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C51341E5E;
	Fri, 15 Aug 2025 02:00:08 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EE173F63F;
	Fri, 15 Aug 2025 02:00:12 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 2/8] mm: kpkeys: Introduce unrestricted level
Date: Fri, 15 Aug 2025 09:59:54 +0100
Message-ID: <20250815090000.2182450-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0F5FC000F
X-Stat-Signature: 7nqasikmqzcrzyyiss3buqgxwugn9pxh
X-Rspam-User: 
X-HE-Tag: 1755248417-224225
X-HE-Meta: U2FsdGVkX19MQZHoaRrhm1+zqhYjdce8wD5+6T7OXm+mvPGckjuZrZY0xc+G1TYmsPI7VcslzFOneqJFqSnUOF4Y9n5aNxwvaDAt+Qf5to1C5SSZMky9/Ju8MXjxO6vsistAP6B3yniMe4+3lDcJtggaCPkDNQVIy9SkUuK68AEt567OVZZHcFFuphGZNr4RMOXbdt72i/cZ3xazAh7eE9LE5XmoyhGwPmabUjWmbIt76vL3KfdfI0F2k+BRDl7pvv8+MVmLH12Qp+CgqCzoa9K/NQzo2cXnK8y4YTNQ6S7ew4PO8yLH2+ewDrEcvr9a+fzBp0SyY9cW8V8HZySszKiYdtO3qxfyOfVaa7V887IpbyqMBgVK1BI7EhotJsDxw6Fv5sMIe6MLc8vcID385+yoZ8dYk2eInGy7ULLiUCtg4tvSNnsXdLJTix+sGhxZlio0sBLazWaEDBD1S2T5Dxe3HcM/GCtUUlDhLVAZtM2VVQr2OCWGV5BmBBo0kDxxvI92nswUNgv8PxmqcWTldPX900NGMGGKd4rkDyPpXCFWVR6OGvyFglDN1deICduNRyj4ls5sIvw7P183PVEVmJ4GorLBwrXsfMtML+DyJ70jjzvV/ZKqliM8OIRJb3gwCZN6b/OgbShhNCT+pzAe141twjqihs84F42u8ZEGf0Wge9/j8++/+G4cQFkbNwX+dVWJEd1KD8wCWot8oTvl/JnLfa7Uv/MYucYt+l5CuEd6Ux30HmxpOUpaDwQb6gosMjIU9MI5luC0GpZ6pWV3qFVSIjzVa4rG5wnvz7R9Pn6UgcF45Z2P9be6QdcamvzMFdRfr0AGOjB+RoFMKoroy6/b/sFV75nhUePmTufRwbiGLqyKMCkdTcGO+j0+e+ENtjC6boR6SLJYuA7g9DSDUQHIy/7E7I0hYL/RFw8mtnsPQc1rFQsGOd8vaeQueSaMeeq3NFhHnvkxGcSVsXL
 IW16UN33
 Vwx/ihe58hObpcRj+81jL+SrjVUEKWNLKENDKInd9kCZ/2BxMXMunhpzXwV4ojZEEcxVeUOTdxRFj509KguCrsdU92gPUttHl0zqB3XIYaU0AHnivh+AdvacAF45oZeOWRW/g0GqTQEmQwjhmV+2tzO50Tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Highly privileged components, such as allocators, may require write
access to arbitrary data. To that end, introduce a kpkeys level that
grants write access to all kpkeys.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 4 +++-
 include/linux/kpkeys.h          | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 70e21df84252..ded5d6e988dc 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -28,7 +28,9 @@ static inline u64 por_set_kpkeys_level(u64 por, int level)
 {
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
-				     level == KPKEYS_LVL_PGTABLES ? POE_RW : POE_R);
+				     level == KPKEYS_LVL_PGTABLES ||
+				     level == KPKEYS_LVL_UNRESTRICTED
+				     ? POE_RW : POE_R);
 
 	return por;
 }
diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 5f4b096374ba..48f240bea8e1 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -10,9 +10,10 @@ struct folio;
 
 #define KPKEYS_LVL_DEFAULT	0
 #define KPKEYS_LVL_PGTABLES	1
+#define KPKEYS_LVL_UNRESTRICTED	2
 
 #define KPKEYS_LVL_MIN		KPKEYS_LVL_DEFAULT
-#define KPKEYS_LVL_MAX		KPKEYS_LVL_PGTABLES
+#define KPKEYS_LVL_MAX		KPKEYS_LVL_UNRESTRICTED
 
 #define __KPKEYS_GUARD(name, set_level, restore_pkey_reg, set_arg, ...)	\
 	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
-- 
2.47.0


