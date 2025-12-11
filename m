Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA6CD3E78C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 04:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726C66B0005; Wed, 10 Dec 2025 23:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D93C6B0007; Wed, 10 Dec 2025 23:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4E36B0008; Wed, 10 Dec 2025 23:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44E2E6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:27:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C80B4140788
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:27:07 +0000 (UTC)
X-FDA: 84205905294.01.99AAB72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 25B9E40006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:27:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzEXc4tx;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765427226; a=rsa-sha256;
	cv=none;
	b=KCf4LRI7X5/ERhpMhhRawoBt54wBew/+wNSssc4J8YKHlSwJfGoPZ60cWQkNamDbXzK6+f
	fzW2Ratw+Sxu3ghB2rBJYsq4Ii4WP+P5M+Nwv2u4cRz8BSYmG4U/MhdOOAwdDKEt9313QT
	EDNnluM0y95+4bptW+xfpPXkBnlB3NA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765427226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eKXTOc/qyTfcN5X1gBtb5g7Xq4iw49a+Kau6321RZIA=;
	b=oYgv1I3ueG93k9Tn0KYG2zAhQqsZ2uMK29qz17Qb+hLw7hknO6HPq0oDk2yAD1kl/sQuZh
	WVCy3HrTMg9c10NsWmC4uuI2jecPiRghtEj3d/U7IN643Nm2iamHsFLx86pWeTMX5HOW32
	DQq61MxCLgZw5rNxsb/hbUc/MXsOcew=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TzEXc4tx;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3C3143E84;
	Thu, 11 Dec 2025 04:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B448EC4CEFB;
	Thu, 11 Dec 2025 04:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765427224;
	bh=xpkKIG9FMryb6P12ow/DNTd5Jc1/Y/mhnvtHiSrrxfc=;
	h=From:To:Cc:Subject:Date:From;
	b=TzEXc4txHsbtptaVuuDDJvsSdK4q9CA+1T++9wgdK60nWiPaodxe5xZuV5yE45TC6
	 LdMueM5iAF+Lx4gkH87EUZmBc/+Czs4gTzcgeX/I15yhBL4njM9duiE2JOpTT3K55v
	 Lv7Ty2KdcASnmjbhnDmIeJzrESlF+VyPQ3cjQ5AS4ELsoSI9VWJutjgmXV0VBmV0qC
	 g91EjdDdlGA1v5EIj+wVhQtl6r0BH/ubL+vyKT2Wh1zTM+C2SURNGc6yDMORqXbSvt
	 bK37cHL0bnYdxlw3vO14L4LQLZnF5X5OUPfnKAL7ttBQZoJJ+1WxzPG1y0NCEXdv9+
	 7o3TjfsdRNHyw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Miu <jasonmiu@google.com>
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH] liveupdate: list all file handler versions in vmlinux section
Date: Thu, 11 Dec 2025 13:26:22 +0900
Message-ID: <20251211042624.175517-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25B9E40006
X-Stat-Signature: m7rmny5iwszj3nn4x6q5mnxxk6i18gw6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765427225-538824
X-HE-Meta: U2FsdGVkX19+8e6891kQLxIw546rAum3wSAJJdu6a+J29AEmJ4HpkQVFKhGSeeqPfGCfd5n8Bnb4mUsgScPJ9vabBUD5602ghTHerQGupJWCd1bNt83DpxDZ5Or5fNuOjLbt2zEtV+i4R5vnKIXLtCNq6JWeMxx4130g5fHSK1yO52+2CmpoPT9QXD84lP6tbK8eUnBoioJBaxpFOvf0dDqlOOJ21WtNGlPSvr5+MJvPU36MaOQFLeUDv34LgykcTbOodQf0amPZNcnHI2ujvzaW9UTjNvNqJwzqPAZ2sA5sXpjEUrjLt6CZzgUQbkk5g1F3t9tb+9a0AraS3NS4NhD6fEyViVZLzqiyg4llVefdGQI52LmhtlrMMH+iY1zU+jfNMCEuFD3y9K/jO3sydARjeEVsutSiVqgS/JCUtC6LC+en6A4CbFQ7S+ec0Db36nDncrG7vqEJpr1A7JgvU8JukbSowUeSyAutXiG57UTKyuoO2M9xm0RcNm09pQgSUemfc1rc5SUe7phjWTycZRgB+8wHUMxVdOrPY0FMDn0AHT7CH8xpWyioaHpg7UcwspbXyxN/J2muCoWHn8lwyWpI1k+dLB0Jk0nvVDfJECURTHwceCdkDDSi0C/bc/9PXdEAYRObsgOSq17/UdgwK6ORvNJ/AFuZuScXFQI0S95CEcbG1cN86XI1HBn84vRyeGON47jvMYC3Lf//fcEFMng2ywgGDNHwez0IgAdsIJfULo264ZAkuIilNjJAqQ02l6uQB9LeOz//JMNsgLfyAvjpjSTSlHq/d1GXrzk+rOA8h3WDutxgrlpgQIyvX6TJNNZTW/8refkccGRMz3Xd4adHdFFWrKqTUod8GaQBUY8zW1pjB1Lg7CwUdbQO8uNGHzLyfCxN+DXZb98GygnVUvTvK2GB7evbrqy5/Y/Xm/2l1gUH8D3Q+MuxAnYRiMeh+u1ETMK+KDZPentvod6
 5MIUJ+Wy
 4qu2XD0tFTRVaZSbBoPbxVQm/08crPyE1mPVdi78nlZID+eigK1lJKsfVf4Rjpx2+DFd0weNVBb7yQUgQmhzkNRzkk2zOsPlmVMduy4IavrSazS2LTkgl1M2SFiN6C/9anO6yMeSTiCn3cB8skJ/jUno9R5abo31Fx4Uj19NJrF6FI5MNCFU5cwZUgONYDaWA10YiTnF1cQOA5WA3DkBQMgHv/9MvxQQFNIoLMcLuRHyBA/yM6mgEbOYtOqPzoG17uNXTqdRyrpAYaBWNTgxnPEb17Z4mIR0SezyRQMaaatUEG8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As live update evolves, there will be a need to update the serialization
formats for the different file types. This could be for adding new
features, for supporting a change in behaviour, or to fix bugs.

If the current kernel does not understand the same set of versions as
the next kernel, live update will inevitably fail. The next kernel will
be unable to understand the handed over data and will be unable to
restore memory, devices, IOMMU page tables, etc.

List the set of versions the kernel understands in a section in vmlinux.
This can then be used by userspace tooling to make sure the set of file
descriptors it uses have the same version between both kernels. If there
is a mismatch, the tooling can catch this early and abort live update
before it is too late.

The versions are listed in a section called ".liveupdate_versions". The
section has a header that contains a magic number and the version of the
data format. The list of version strings directly follow this header.
Only the version strings are listed, and it is up to userspace to map
them to file descriptor types.

The format of the section has the same ABI rules as the rest of LUO ABI.

Introduce a LIVEUPDATE_FILE_HANDLER macro that makes it easy to define a
file handler while also adding its version string to the right section.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    I also wrote a small tool [0] to parse this section and list all the
    versions it contains to demonstrate how it can be used.
    
    This topic will also be discussed at an upcoming session at the Linux
    Plumbers Conference 2025 [1].
    
    [0] https://github.com/prati0100/luo_section_parser
    [1] https://lpc.events/event/19/contributions/2049/

 include/asm-generic/vmlinux.lds.h | 12 +++++++++++
 include/linux/kho/abi/luo.h       | 34 +++++++++++++++++++++++++++++++
 include/linux/liveupdate.h        | 23 +++++++++++++++++++++
 kernel/liveupdate/luo_core.c      | 14 +++++++++++++
 mm/memfd_luo.c                    |  6 ++----
 5 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e04d56a5332e..a474c9529a5f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -342,6 +342,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 #define THERMAL_TABLE(name)
 #endif
 
+#ifdef CONFIG_LIVEUPDATE
+#define LIVEUPDATE_VERSIONS						\
+	. = ALIGN(8);							\
+	.liveupdate_versions : AT(ADDR(.liveupdate_versions) - LOAD_OFFSET) {	\
+		KEEP(*(.liveupdate_sec_hdr))				\
+		KEEP(*(.liveupdate_versions))				\
+	}
+#else
+#define LIVEUPDATE_VERSIONS
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	__dtb_start = .;						\
@@ -544,6 +555,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	RO_EXCEPTION_TABLE						\
 	NOTES								\
 	BTF								\
+	LIVEUPDATE_VERSIONS						\
 									\
 	. = ALIGN((align));						\
 	__end_rodata = .;
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 4a1cc6a5f3f8..57ef75695f62 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -244,4 +244,38 @@ struct luo_flb_ser {
 #define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
 #endif
 
+#define LIVEUPDATE_VER_HDR_MAGIC 0x4c565550 /* 'LVUP' */
+#define LIVEUPDATE_VER_HDR_VER   1
+
+/**
+ * struct liveupdate_ver_hdr - Header of vmlinux section with version lists
+ * @magic:     Magic number.
+ * @version:   Version of the header format.
+ *
+ * This struct is the header for the vmlinux section ".liveupdate_versions". The
+ * section contains the list of file handler versions that the kernel can
+ * support.
+ */
+struct liveupdate_ver_hdr {
+	u32 magic;
+	u32 version;
+};
+
+/**
+ * struct liveupdate_ver_table - Table of file handler versions that the kernel
+ * can support.
+ *
+ * @hdr:        Table header.
+ * @versions:   List of versions the kernel supports. The strings ate
+ *              NUL-terminated, but to keep the format simpler always take up
+ *              LIVEUPDATE_HNDL_COMPAT_LENGTH bytes.
+ *
+ * The list of versions immediately follows the header. The number of versions
+ * are determined by section length.
+ */
+struct liveupdate_ver_table {
+	struct liveupdate_ver_hdr hdr;
+	char versions[][LIVEUPDATE_HNDL_COMPAT_LENGTH];
+};
+
 #endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index ed81e7b31a9f..5a8305595fe5 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -212,6 +212,29 @@ struct liveupdate_flb {
 	struct luo_flb_private __private private;
 };
 
+#define LIVEUPDATE_SEC_VERSION(_name, _ver)				\
+	static const char __ ## _name ## _vers[LIVEUPDATE_HNDL_COMPAT_LENGTH] \
+	__used __section(".liveupdate_versions")			\
+	__aligned(1) = _ver
+
+/**
+ * LIVEUPDATE_FILE_HANDLER - Define a live update file handler.
+ * @_name:        The name for the variable.
+ * @_compatible:  The compatible string for the file handler.
+ * @ops:          The file handler operations.
+ *
+ * Defines a struct liveupdate_file_handler called _name. It also makes sure the
+ * compatible of the handler gets added to the liveupdate versions section. All
+ * file handler must be defined using this macro.
+ */
+#define LIVEUPDATE_FILE_HANDLER(_name, _compatible, _ops)		\
+	static struct liveupdate_file_handler _name = {\
+		.compatible = _compatible,				\
+		.ops = _ops,						\
+	};								\
+									\
+	LIVEUPDATE_SEC_VERSION(_name, _compatible)
+
 #ifdef CONFIG_LIVEUPDATE
 
 /* Return true if live update orchestrator is enabled */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 7a9ef16b37d8..f44ed6019367 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -62,6 +62,20 @@
 #include "kexec_handover_internal.h"
 #include "luo_internal.h"
 
+/*
+ * This is the header for the ".liveupdate_versions" section in vmlinux. See
+ * struct liveupdate_ver_table for more info. The linker makes sure that the
+ * this header precedes the compatibles added by LIVEUPDATE_FILE_HANDLER().
+ */
+static const struct liveupdate_ver_hdr ver_hdr
+	__used __section(".liveupdate_sec_hdr") __aligned(8) = {
+	.magic = LIVEUPDATE_VER_HDR_MAGIC,
+	.version = LIVEUPDATE_VER_HDR_VER,
+};
+
+/* Also list the LUO core version. */
+LIVEUPDATE_SEC_VERSION(luo_ver, LUO_FDT_COMPATIBLE);
+
 static struct {
 	bool enabled;
 	void *fdt_out;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 4f6ba63b4310..23c7f1dd7d8e 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -495,10 +495,8 @@ static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.owner = THIS_MODULE,
 };
 
-static struct liveupdate_file_handler memfd_luo_handler = {
-	.ops = &memfd_luo_file_ops,
-	.compatible = MEMFD_LUO_FH_COMPATIBLE,
-};
+LIVEUPDATE_FILE_HANDLER(memfd_luo_handler, MEMFD_LUO_FH_COMPATIBLE,
+			&memfd_luo_file_ops);
 
 static int __init memfd_luo_init(void)
 {
-- 
2.43.0


