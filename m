Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FF1606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Ac7ak5wz
Received: by kanga.kvack.org (Postfix)
	id A53B16B05BA; Sun, 25 Oct 2026 13:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A038B6B05BB; Sun, 25 Oct 2026 13:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DD46B05BC; Sun, 25 Oct 2026 13:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540286B05BA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D481FA8160
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:32 +0000 (UTC)
X-FDA: 85361863104.22.B934E2D
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C7E3100003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ac7ak5wz;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeCPVU+TT7xZWsohIOPLxgTp4DXEQmJIT8fXCzhydds=;
	b=XS9lsX2kmIlS7sfno8l4Niinm7qBuouGohvfvmMLoDG6Z7SB3taMou/jBE3xUnsxGzQKkk
	Xg/gz4+dFF6cvC0MpI6qZryUtcwW8RwldI+HeG4dtzWxs0ieZ7TICjt3sLJIBTbjlPV9pG
	3vK1bXYpKd/a0EyFIpiH4i8/jHzISQ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ac7ak5wz;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950031;
	b=GtvsOQbKeUpgs0LpHiOG/uyZTBkKg3Ub6x4/QvZdlA0N5iw2rM6dClggXB1G+gUK63Wu9v
	9BD5oYSTh4yIUXCBO+q42nX0as+lDit4rz8xm8C5+87ozV3/b9HraBQiOU/mshi+jhILB0
	9ZFQaoGnjjZbhFH4sxL+0+bMUAPnkSM=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so939062e0c.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950030; x=1793554830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QeCPVU+TT7xZWsohIOPLxgTp4DXEQmJIT8fXCzhydds=;
        b=Ac7ak5wz9aIV5NwEhKyOm9I8ssxs3xONz/GbvBUJK3y/rfJLBdN7OY0a28ojWZRa1N
         VUf3O1u99BzdIFBYX3+GQhF9sRmxdokvb6w66QW5scOBvpavMclD8VmV8VofoIGDTGFb
         T2L3onGCMEiqgsPCTg8fmb5DqGeFLRFASpCZMtlVCwIQq/FGgoaBzD8vyK/2OKjTRvoK
         BhKh10CSSrVCDs3GxtffSCl9BVWQ0qK3/VoEdg3x3sue0hmAyo7CZSY4ViO06TBFRWbI
         kHf6uflRu9/tApRSreFsG0uMSdtakpXAguA8DlftcFT8Nthn2W34d9qjE6asDXvmCfVY
         M35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950030; x=1793554830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QeCPVU+TT7xZWsohIOPLxgTp4DXEQmJIT8fXCzhydds=;
        b=fkbgx9yJX08hn7zJWYzdu5s2810VcQ9ZEn0wBVHCQjSZcZ703EjyDqOyeKOA0WcDHt
         kXU+1QMuLKBpq4j1O41xSKFKVmoLdKNlxyzfFFHvzZwi2vy0Mq4YMwPNRI+EXLdnEnQJ
         jtJjMdnbytLHh6eglOZrvI/+/JPhtLVzM8xebI+glppY5E25z6Zhn3gc9LbbMCprk5vv
         OI2xcuK0YHU29tZJE8zowNn09J5STFe7OJ7pTsNt65bJw4wc6asBcADp3rrQ1YuW8xtE
         XUkB06Iko1YPokh/jd51mwFC3tX3kQ7MGR1R78autaiYLQLdZIhnoZ9Dp6Pj3oeom9YR
         rvig==
X-Forwarded-Encrypted: i=1; AKwUvBxs0vQTa+gd9QjHgZFxbIja3crVptEriUX/kvy56SxomPdojXPIOxWZdR2/fPAX8bXTcgWQws2oPg==@kvack.org
X-Gm-Message-State: AFq9FYI+VDjQpDt2DtAvOdKXiVRQv9BgOh7UMQVrvZulNul4VTiumj1D
	WimcFdj6m9x+BLo3y9B37euQNKS36eMDPj6zJS222o1LmzHgzSj0ZMxXwz0hI79+dIQ=
X-Gm-Gg: AYBFou3kZJuKnz85nC2qu8s9eOZBwb9TxaWFkjkpbjCZtXnTuMEK4eD9O2P1fJZoXY4
	DO+8D+vBuVAnGQ4HYWnONQUjWI4e5jgesZLvbREMOru7bCqs6kBgXoZ4rzUBn4WB78DMykcagUT
	kkylAG+RS/bXHqHig3vtzGlM3dTVyaWRyBn72dZSfu+n1Io8c8+tGrE+jrgUGkXIEoFTK/R5HlZ
	qM28sJ3iZkZ/mVS6Zu8V+yaFm3snu+HIfrKUC9YW2NzjwOclAbr0GmNIY5MCb3zky+h6qD2PPU2
	v1TyRIrefqEE9BojMBUuApu1KM3JlN6jBz0LG9JJpsALcjs6CS+DxOu7O5KAzF+9bpyQhhCICfu
	YduvWG+wNIzJcVelHkcPOcoBG2Nq3Z4EsEnyeUwKcuMdQQvHjzcE2E8QyeujIGnSnLaK0FGb+cG
	ZXAmCsJbHQs62/KKMhWFr1w6A9rzDRFHIqj9so7k9c0a0dl3F0yzCmtsqK4Qhnen+eLle05BLtm
	mRGUe4vUpyrxrFjfBgEMu1Z+uOiGGOHiBsisif8mZk28rKIhw3GjUkIlAfO1MyrFPxnF9//Vo/9
	m1/02Tc+0lLw2r4ldvpqUwdfxbWE/l+o10AUkEHkWlAAatoL4fG4gLI4jArmVfT8K9QLLcakxlX
	b
X-Received: by 2002:a05:6122:3d06:b0:5ea:f1eb:b9e2 with SMTP id 71dfb90a1353d-5ec232a31a4mr1273841e0c.19.1792950030175;
        Sun, 25 Oct 2026 10:40:30 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:29 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 8/9] kho: test: support read-only KHO mode in test_kho
Date: Sun, 25 Oct 2026 13:40:15 -0400
Message-ID: <20261025174017.3870481-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C7E3100003
X-Stat-Signature: 1yyuaafq3mfxhpeworcsqzo1dyb86gg3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792950030-834684
X-HE-Meta: U2FsdGVkX195VQGgMmKo5sQnKL7W1IWBVwXkNP8vmM1y+l92AwH5KwTRul3trksjrjya3YA97goCnavRB7wWu661/QaNQswWBAFbiAl6hGjlQKBdlRWn1kcs3sfGkkFeLUiqEmuPG3qDING47Nmzhd5y2cuhRD8oML51d7aDD13HSzkgmD+hfJ++H+YBwTJVlCvYgpUFzDjhk+3tLn0pamDx26hxn0HOSdLk/WsL3a2H0YDRNGrOxPuZfwoJ9CiRpCZn0GrML9L61114KOKZN4lAreHRG/0jiOvXscfKwdavgmahQ18j6+nT0vowrX2fwiGuo7TGpChdcU3kvQoYeBoYYkJgSw6UJwnKD63aNmVmqGkXR7vbt+nirlwpK0Ua7x9m1Sld4fxEqOup0DfBQYGZpDCsYwWpN3fRHwKP9315II8Zt38JNS6R/13RXyIXKVPcDXQj+Tvs2uoBvxHKNFjEqgdGi88Zy3QAEhwrXcYUi+U4nTB59lsxlsM3/DPubEQNYxAuSrjomcs9kXyNy1Dm1QrykZuZx7duLT7yoYn+5JN79wLiJAh2ulJA8y1XvSUM9T00LIW/8IiU/+CKdknJKM5wsA8jwGi9UtlLoUFXQpee0VD4LZY/20UeVUjJRJBim4/gMjsydLZngCIxi2hyD3EdD26Nzx90JDGLGkGt4+Mhevuy4P45g67lWg//T6fhEpiiJPP1FqaQzG+gyR1eCqCm6CCN+fbCm+y90er2rhIrEei7NGQq5aFXBuYzzxK3WygXxLqLmsocwuF36XeL3j3bSp1OOb55NXPadImo1XYGY0oK68OsCSSYFIEizAZuFvtqrF81A6ZI5TgvPjBCWniquS6HR6XliNqVWQTN/8ZIiwbsAiARIyaQQKOK8A0BkNATemvcpFT0IDEa1SpwfT6AJeO1Rtg4wJ+JJ3U++NjBN3lR7m0RVoALAEAplCD04CZ1rAXfa7c5Ks/
 3pWJiREF
 PufvhcV6VJWU+u4JhWv9sCmjlOiwdlSU+cxmamcZUYI6SIsTMURpywKgZMTdNCWwC7TG0nYHs4bp9zwb2rvCbPCAU+Dd4nxO6BcXutaV8DFZs0F2+DUt9ST++0kXYa1KA8q1Iq1D4QgKAqXBrnOvLD62+LmWBY5VX1nGHkLLMqyNcJ1RHmNfyDq9UnXJ5JBFWbouqJQSwc6vGwCtGHYk9RTmMweIC5f68kdGDWqwMrauGGAGGOONKsR/eeQSRwJixALMaS+djMqh62KCYGyxNmIwHrkW775jhbe0KJOBzgnFSRN4bVgfbSWqNrHvWwoo3GbeFcZ+OZuCd8STbBelCms1xdQuSvdOQ6aDkSb+TpptyvVrkE3HoMXDtXl++wdI+Wg7F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

test_kho currently depends on CONFIG_KEXEC_HANDOVER and restores
preserved folios via phys_to_virt() and kho_restore_folio(), which
prevents testing preserved KHO state when booted in read-only KHO mode.

Allow CONFIG_TEST_KEXEC_HANDOVER to be enabled with
CONFIG_KEXEC_HANDOVER_READONLY and update test_kho to verify preserved
state when kho_is_ro() is active. In read-only mode, retrieve the test
FDT subtree, map the FDT folio via kho_ro_map_folio(...,
PAGE_KERNEL_RO), map the preserved vmalloc folio descriptor array via
kho_ro_map_vmalloc(), verify each folio's preserved order in the KHO
radix tree via kho_ro_lookup_folio_order(), map each folio via
kho_ro_map_folio(), and verify the checksum over all preserved pages.
Also guard kho_test_exit() when no outgoing test FDT was allocated.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 lib/Kconfig.debug |  2 +-
 lib/test_kho.c    | 71 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..74223ef8bd1c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3381,7 +3381,7 @@ config TEST_OBJPOOL
 config TEST_KEXEC_HANDOVER
 	bool "Test for Kexec HandOver"
 	default n
-	depends on KEXEC_HANDOVER
+	depends on KEXEC_HANDOVER || KEXEC_HANDOVER_READONLY
 	help
 	  This option enables test for Kexec HandOver (KHO).
 	  The test consists of two parts: saving kernel data before kexec and
diff --git a/lib/test_kho.c b/lib/test_kho.c
index aa6a0956bb8b..29029dcf5815 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -236,10 +236,10 @@ static int kho_test_restore_data(const void *fdt, int node)
 {
 	const struct kho_vmalloc *folios_info_phys;
 	const unsigned int *nr_folios;
-	phys_addr_t *folios_info;
+	const phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
-	int len;
+	int len, i;
 
 	node = fdt_path_offset(fdt, "/data");
 
@@ -255,15 +255,34 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!folios_info_phys || len != sizeof(*folios_info_phys))
 		return -EINVAL;
 
-	folios_info = kho_restore_vmalloc(folios_info_phys);
+	if (kho_is_ro())
+		folios_info = kho_ro_map_vmalloc(folios_info_phys);
+	else
+		folios_info = kho_restore_vmalloc(folios_info_phys);
 	if (!folios_info)
 		return -EINVAL;
 
-	for (int i = 0; i < *nr_folios; i++) {
+	for (i = 0; i < *nr_folios; i++) {
 		unsigned int order = folios_info[i] & ~PAGE_MASK;
 		phys_addr_t phys = folios_info[i] & PAGE_MASK;
-		unsigned int size = PAGE_SIZE << order;
 		struct folio *folio;
+		size_t size;
+
+		if (order > MAX_PAGE_ORDER)
+			break;
+		size = PAGE_SIZE << order;
+
+		if (kho_is_ro()) {
+			void *addr;
+
+			if (kho_ro_lookup_folio_order(phys) != order)
+				break;
+			addr = kho_ro_map_folio(phys, PAGE_KERNEL_RO);
+			if (!addr)
+				break;
+			csum = csum_partial(addr, size, csum);
+			continue;
+		}
 
 		folio = kho_restore_folio(phys);
 		if (!folio)
@@ -276,19 +295,33 @@ static int kho_test_restore_data(const void *fdt, int node)
 		folio_put(folio);
 	}
 
-	vfree(folios_info);
+	if (!kho_is_ro())
+		vfree(folios_info);
 
-	if (csum != *old_csum)
+	if (i != *nr_folios || csum != *old_csum)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int kho_test_restore(phys_addr_t fdt_phys)
+static int kho_test_restore(phys_addr_t fdt_phys, size_t fdt_size)
 {
-	void *fdt = phys_to_virt(fdt_phys);
 	const unsigned int *magic;
-	int node, len, err;
+	int node, len;
+	void *fdt;
+
+	if (!fdt_size)
+		return -EINVAL;
+
+	if (kho_is_ro()) {
+		if (kho_ro_lookup_folio_order(fdt_phys) < get_order(fdt_size))
+			return -EINVAL;
+		fdt = kho_ro_map_folio(fdt_phys, PAGE_KERNEL_RO);
+		if (!fdt)
+			return -EINVAL;
+	} else {
+		fdt = phys_to_virt(fdt_phys);
+	}
 
 	node = fdt_path_offset(fdt, "/");
 	if (node < 0)
@@ -304,24 +337,21 @@ static int kho_test_restore(phys_addr_t fdt_phys)
 	if (*magic != KHO_TEST_MAGIC)
 		return -EINVAL;
 
-	err = kho_test_restore_data(fdt, node);
-	if (err)
-		return err;
-
-	return 0;
+	return kho_test_restore_data(fdt, node);
 }
 
 static int __init kho_test_init(void)
 {
 	phys_addr_t fdt_phys;
+	size_t fdt_size;
 	int err;
 
-	if (!kho_is_enabled())
+	if (!kho_is_enabled() && !kho_is_ro())
 		return 0;
 
-	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, NULL);
+	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, &fdt_size);
 	if (!err) {
-		err = kho_test_restore(fdt_phys);
+		err = kho_test_restore(fdt_phys, fdt_size);
 		if (err)
 			pr_err("KHO restore failed\n");
 		else
@@ -330,7 +360,7 @@ static int __init kho_test_init(void)
 		return err;
 	}
 
-	if (err != -ENOENT) {
+	if (err != -ENOENT || kho_is_ro()) {
 		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
 		return err;
 	}
@@ -355,6 +385,9 @@ static void kho_test_cleanup(void)
 
 static void __exit kho_test_exit(void)
 {
+	if (!kho_test_state.fdt)
+		return;
+
 	kho_remove_subtree(folio_address(kho_test_state.fdt));
 	kho_test_cleanup();
 }
-- 
2.56.0.307.g5fe7bd680c-goog


