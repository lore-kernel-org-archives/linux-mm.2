Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A5A9D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F17D6B0088; Thu,  8 Jan 2026 11:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EFF6B0089; Thu,  8 Jan 2026 11:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E256B0092; Thu,  8 Jan 2026 11:41:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 478D26B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:41:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2B00C11A0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:41:24 +0000 (UTC)
X-FDA: 84309362088.05.0ADC3D6
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD5D3180005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:41:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767890482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEKbCl6eHGkX3T8z34Ba8e5S/FDTyu14lC4qmzFFHFA=;
	b=vdLBCBYVXlagPkPjcFzgUIRsm8nlt9eBAlBPFc38TkGTfbyuqFFP3jICrBzQGAcS6aE6hl
	GV2guZSMd5nvpKPClH66eNuBoLKPFsFjfsVe/PM2Kxe7/eRB8F7v++920afoWOscqMsjYH
	BPYDi9PcC8oeetFcmSQkZM9g2fQld6s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767890482; a=rsa-sha256;
	cv=none;
	b=nawRkpiEYsmRGU9W2m83RVIgCW6oDK7cQJNEDMKZTH9EyOTf1AQjCrDElTq1pdbppumjHE
	wLmrrkPYg28rj9i6MHXjAVi+bMeJUlFFve+JIkzknPNuhu9SG9BiivtN6LKlcW3aM162fE
	7otHBl4t6uR1CNpG5GBDshHG8kghFSY=
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-455a461ab6eso1416701b6e.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 08:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767890482; x=1768495282;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eEKbCl6eHGkX3T8z34Ba8e5S/FDTyu14lC4qmzFFHFA=;
        b=XWEJrqih4NrjksfYtNCPty+2ouKYStOj/7PtuH5wmuELbeLPujIMYgqmFYXaCCyocy
         YUqdtR54/C6n0ffU/vyQq4STjlE+6+7SNhID/6ff7/klxuFS5cxfWPNf6n2i4/lY283h
         0CjGtcbeM9caUXuvZVu75uu5Pv/KiMFtNB8xyLTstoeCfwm+FZl7Tdad7roqMlrNmgaB
         ljMyZip4DLSa2JKdEpnUU9VzJQnoM7ilhbknYqRCMRwh5NJiBuov2vsQV+fe6o53w1ql
         Z4iTdQRVB9u1hrZ0QUZCVCoJfv62AHkvt6UB6OSGDXyvGy49lsLTZVrMaxO1rVzpKjZR
         Egrg==
X-Forwarded-Encrypted: i=1; AJvYcCVa8ZZ8LThtfQfTMpXMdg8/wv3p9YrXI4BjThwV07qMnSQXbL7xVX99QcVYJSSzHJM9KPJWIDfHIQ==@kvack.org
X-Gm-Message-State: AOJu0Yxbz5x4OrPO9Eh8nadiJdlCqj8aqwrfOQSBdsFFw5NIp07pLBcZ
	XL79OJzGvfqOLVOfm+kpr+zQNe3VZzVzyNXlfUZWwcmL7U4QaSSgz+EG
X-Gm-Gg: AY/fxX4Odeic4F0tTytp3lZXGuHcTDkNSrkNW+7knjyDjEJ4haXMO6wR+odyYmWs0RH
	bRSmvx1D08VtsVOxAjFuGcxJa4hokCJBL+KFSpBM5u5XOzKrbrv/Cn4qVIhpJHFwbUhc7in3Ryg
	rU2owAzULaRDbCyepaeKQi7fKGC92nHnwUDpScgxMAZjvNi8Sh18uwxrCyhJL1wd5L2zIjZfMk6
	/YSdyWLKW0MBqzK9+ZZ+gB+wKGlWMWElPEjJqS99Wzjxar23vTE7crCM1dBzbv/aFR75+JscuYe
	pje1M2dcWAFnNkfj8TGo//r5/BE5IIcF8Skc8iVa7XFyJsRpV2sEYneLXWwtUEm53yi/YKN9/pw
	dsG2+bOWeLHn8i7JrRewGjgqnPPdpzaF9xaAdn2WOa2yMw7fb7D70fIEHTlBzt0y3jdvyRpTMFW
	cs8A==
X-Google-Smtp-Source: AGHT+IHwg85rGQHbkPrcqt1aBeanOarcVUdF/YJuRLIGyTivBFmbrsvMl5+YqDe216QHSew4Eycetw==
X-Received: by 2002:a05:6808:1188:b0:455:7da6:44d5 with SMTP id 5614622812f47-45a6bdaf691mr2406341b6e.27.1767890481759;
        Thu, 08 Jan 2026 08:41:21 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa5161468sm5298579fac.22.2026.01.08.08.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 08:41:21 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Thu, 08 Jan 2026 08:40:58 -0800
Subject: [PATCH v3 1/2] kho: history: track previous kernel version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-kho-v3-1-b1d6b7a89342@debian.org>
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
In-Reply-To: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3243; i=leitao@debian.org;
 h=from:subject:message-id; bh=lVq1FcOCQMqfHOK5DcXTIKEzb9rwsZ/ITwXUKRT+mew=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpX94v0uvNnwH22s6hbp7/tiFmZZwZTGwvXKop4
 GrcufIuHBmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaV/eLwAKCRA1o5Of/Hh3
 bYjfD/4q44IGNvMydiP1wiCUgQyjvqTCiWLge5E7NW/ndXZiqkKPAyOKxtqhbRpe3c4oYG93YXX
 hY1pBWYWitOmAEIXiasAf7f/hD7fCvP3WLdm+BV+gHCkPrEBOny3qIUyZg2srW6xhWOMsnGMXuY
 qG5+RTcUmpRnD6HISAobniQawTfwhu85aUGn8ip5IUZ0YNvAGX/bVHCIqnhPSmItE7H/F7uuenO
 xoXJhbw4VkkHdtk1ybE9RSKp3K0lOV3aqNgwUD3K/yLWx+jibQ2XyLRYDyCYMEaQjToqlSe+NMN
 aBaWk66cmepQT1SWPJqAxVe2DgTJ0bJvcFPCRvnJabEIIrCZCZ3uH0AFNaSJnNsDDjocfjxNwX4
 Tq2CC+Dffe67p72GupDlMCgZBT/Dy4oK3gj2FEZkfgaF0ydlnL5m+E6b9akv0RLs1gaQlXWZ4j1
 xeW6PoYuOwmnzxkN64Wa7WKVg+Uh0LRfqU+a/NJgpJwybc4apdsa3iCTRKx3vXqANCwwctaGjbi
 nK8CZoIV+z5kL8EpHAIKd7NnO7XLIvJOCCfaDyAlIS3gmHIMegwdKiWFlGCZUA5lel0kIgshnLS
 34ZfVxSXBK7smuJX22xF2pphNI9HjIPTgiyH52WyWLw3Ov9QQuyvAj2xn8u4jB8MV8oEOAY2S3C
 wIxZp7CPi87gccw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Stat-Signature: 4rt6qezwuiiswowoaofn3ksod5xn5ybo
X-Rspam-User: 
X-Rspamd-Queue-Id: CD5D3180005
X-Rspamd-Server: rspam08
X-HE-Tag: 1767890482-628201
X-HE-Meta: U2FsdGVkX18IaHCKjTBafT4sBL3vskAeJWBwMClI8Hsvefvk1aAPZXMu2Uclo5sbKmW1loKtKxwQvWwXRH9ZCtS6HLriiTGOW5QYapA/FvV4M8/MiCJ25/2WB/W10XpENccdBgNw6YexRFfAncuvKU5FQpDFMK7W1jE3dz2jz99QVaDXO53hYEeDe/MiLyTOJ8r4/SgnX9Ch4Nk+t3KWbjYLRvXxaw8dstEp6sgEKCoiE92aE5cz13LdUaDlG29hwjlEpc90VAxDCg8/JjfB2/1kgDvWzwpgFJMxA0uxWYpd0ArTHnMD/KS6zsjyRXXk0UaT2pjSf43oUf9abVVK7oy/ZLdlHtCOXjglMkmA5VOWjt8+uas1H/ZE9fEI1HYc6P/RdMbxumNVuoBcBOhcvOJbNLMIdnYA5jEECuOz0dDA51QhWqPRujYRwYaghqNJuOvn+LWyllcqIwpkWM8Sk4liau2GwvTBhxl+f9Tx/rtdu042vIrC5XKvfaKc7aEPO1n7oCszaBu4qgjEQKGcFNhpcVqDYMCkqSoLZmYnG+E7h9Kp35kD8yu9lV3Ye5XZG94CErAmrlCmph+A50278/wlZUtl+wti001ahxPczznfuMioBZpT0MskW01VHfAKo/CD5mUZ0P4K4IDvhta9e0P/kGIfgLNyDCe+aBYaFdsIxCm3kIYLZJe/smUQCXDfLW4Y74hM25LG0UM7sf7fLp10qhP+a9egCUlFLegHC/lasQfURpljU8ne/AMi88Gx785cz4yj63SIkzz/CJLK9jThCcw19LsKWqTvRaHZyFxLY0bglSctrEvDh3jJUMIoOPYmeUoUslV3I9KFI7UM+WsJWzCpdhj80fFcQy9yGgeNS66mmjnrvHSC085XNHotBsEkSnOc6RLdd51P5nOpTOCm6F6gL4/mnAn5AoHiNDkjOrUrDXSSKLiHf5PoTCz2SBPozMJYzYljGua+fs2
 4t3xqSbE
 hOQPxtx65FuGNypPJS1GlSxlgWbPbUD8jePZzwx7W+QOjR4DpBwZUJTPlh7dpOdnu4KTr4ZDxuyhnOQCNW29tyOZVCCQCLWVEgRRdw3yWrpwMd9vfTXUp1DlqH5bdVGxj9Dw7LNGrJK7Ha1n1e1spjsJUzVKZG4TcxgSn6npzE4uXiVwzpDhtGjauhiNFTuE7bXdnLwZjPq+zzI0c/89cGsswb08tnUBNPvk7bxJu4lOg7d4pj6Syh2UYs9QKOQux3RbGNLurECAEQqYuKkJBs4WKH64fc8CTXnO9znrQQW0EXr81S7g5pTytk2KowwLtN3NRhsf/x5BdGSGPNGjUAbd9l/rnQgbfM1d2IZKDBits3AEJnd/h4HwllETMTJw6xqxH1BhodiNV2TNZrleeQ7Gp8mDoQzuffKlVnBFCUfccb1P2AIqfrpzeeD4BGWCY1FN7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Store and display the kernel version from the previous kexec boot.

The current kernel's release string is saved to the "previous-release"
property in the KHO FDT before kexec. On the next boot, if this property
exists, the previous kernel version is retrieved and printed during
early boot.

This helps diagnose bugs that only manifest when kexecing from specific
kernel versions, making it easier to correlate crashes with the kernel
that initiated the kexec.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kho/abi/kexec_handover.h |  3 +++
 kernel/liveupdate/kexec_handover.c     | 25 ++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 285eda8a36e4..f4f31e8f575b 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -84,6 +84,9 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
+/* The FDT property to track previous kernel (kexec caller) */
+#define KHO_PROP_PREVIOUS_RELEASE "previous-release"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3cf2dc6840c9..b2d57868d22f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -22,6 +22,7 @@
 #include <linux/page-isolation.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
+#include <linux/utsname.h>
 
 #include <asm/early_ioremap.h>
 
@@ -1246,6 +1247,7 @@ struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
 	struct kho_debugfs dbg;
 };
 
@@ -1325,6 +1327,8 @@ static __init int kho_out_fdt_setup(void)
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
 	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
 			    sizeof(empty_mem_map));
+	err |= fdt_property_string(root, KHO_PROP_PREVIOUS_RELEASE,
+				   init_uts_ns.name.release);
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
 
@@ -1436,6 +1440,22 @@ void __init kho_memory_init(void)
 	}
 }
 
+static int __init kho_print_previous_kernel(const void *fdt)
+{
+	const char *prev_release;
+	int len;
+
+	prev_release = fdt_getprop(fdt, 0, KHO_PROP_PREVIOUS_RELEASE, &len);
+	if (!prev_release || len <= 0)
+		return -ENOENT;
+
+	strscpy(kho_in.previous_release, prev_release,
+		sizeof(kho_in.previous_release));
+	pr_info("exec from: %s\n", kho_in.previous_release);
+
+	return 0;
+}
+
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
@@ -1513,7 +1533,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
+
+	if (kho_print_previous_kernel(fdt))
+		/* Fallback message when previous kernel info unavailable */
+		pr_info("found kexec handover data.\n");
 
 out:
 	if (fdt)

-- 
2.47.3


