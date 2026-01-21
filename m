Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95363C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0257B6B00A9; Wed, 21 Jan 2026 11:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15906B00AA; Wed, 21 Jan 2026 11:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF69C6B00AB; Wed, 21 Jan 2026 11:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEA936B00A9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:44:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 750E7C2A2E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:44:23 +0000 (UTC)
X-FDA: 84356544006.24.9F68CAE
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 834D140003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:44:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769013861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=8K6PyvxGfU1AMGKy34QhFpjB02JAayEePw3faIpbm3c=;
	b=AXp9oFutJH8t+i1tlcZij2qTBKVcHPqOEkJbUUhPu+PSNyqhuO3zEpkcuPIF7DHW+Q33sZ
	4+KPxXX+mlgpTF3HadZkZdjvrWnLSfUjVsvweBJeG9XJqrLQUHLYWM8aSLlpe9Yzhn0qej
	TrijnSdgMDufWtTWvR4myfMP/HetsHI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769013861; a=rsa-sha256;
	cv=none;
	b=q7t8UzM87OAdySk92u5epKMFAdbDidFh6ycX9crlKKkItY/ikOiVbqnIJuUcyaTZhsXicC
	+fYKPHL/YB9cw7dsBKs/IfWwSuXUUIWUuZivcMCkYbmgMqwVV3oJtJNzCiQgKg472cG+wm
	DZ4XXaIdf3gnIbr0PJb9PUIfnfHFUMk=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c6af798a83so3326985a.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769013861; x=1769618661;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8K6PyvxGfU1AMGKy34QhFpjB02JAayEePw3faIpbm3c=;
        b=ukxLlcnUOIt3sORr9sBJwiRW2ot8BsC/XiCC3ZGTs97uBwoNhdGU9bBxyj6wbUDVul
         jM5q7XnmNHQzpPSrDUW/ZEBs3eHD7dvAikp1cFItVGZe1FTLc2GGzy2bkF2YVZyTO0dO
         TUpkO7H5r43raS1ma9r3hH/DbO9HZeQvPUnHLuQyHjAQ3S+jnSrJtAac61TV0hQPQKH3
         h0vp8LXJcRydvhV8vWw1VzKNGLAje8uc7uCEGPQgav/ZHy4/GtWkapEHeK824lbKMx5W
         chmp7SGLkvh9fRpDlDPTQiFUjyI0gXwNSQaTDM4ElYTTbmt2nDZrpwawy7bkBcHXaAZe
         xG7A==
X-Forwarded-Encrypted: i=1; AJvYcCV4moTyAOz6qw/a5VYklFFG+8ktJmacqKHBKObgfAaBoutKfxeiOXJ8Ve2piDMmaLAfQGJwQyKwmg==@kvack.org
X-Gm-Message-State: AOJu0YxLW4DlwCDPzsd+UcBNFiUMBjNDQt8M++DRCke8026+/tdUECLv
	TzZi3AQR9Ur1YkvT6RjxMYAL/EfWzSlwVmw+HYXbnhw5zsVsv9jecPjyeOUBdQ==
X-Gm-Gg: AZuq6aKIkr+afLB+4DC7bw+blOK/U64NTbuii/u8L+9r1kpd9qxiZqloecTHpAa2tYl
	kGBvMfIdr/GscpzLY+RtkBs9hKR8hHVA8dZPOmtkWUYwJXZa7FwQMWh51zo9lHdSAVnLfjsrEqX
	b9b6DSATOg+tHXejrQF0jh5AQKM1sYG2FjA2peVtfzHthNH+bJnR04SWx7RQVCbFXq8edSKRt3M
	NacAhmq0GEZ9ofufc5zc8utZQChHJiDi26SEQj7nToHe4eW1/wYJaKjC1c/rBTOggVyH8DVJt7d
	hZUUBIaFrX1xB/fUpHSSn8p1SsgLPgxKy3Whj07cdM14LPYca2cIrnIp3upj0976kVt5MC6GPi9
	9tHYQV5gkGNoIwa55tvu9S0d2hiFQNmAo66lorQQccZOSnl+BF8Jsao8xZ+CVTWBImnJeAm46UV
	8bHg==
X-Received: by 2002:a05:6820:1798:b0:659:9a49:8fef with SMTP id 006d021491bc7-6611796ece0mr9284384eaf.28.1769007054264;
        Wed, 21 Jan 2026 06:50:54 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662b6c3ec82sm1497158eaf.17.2026.01.21.06.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:50:53 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Wed, 21 Jan 2026 06:50:38 -0800
Subject: [PATCH v4] kho: kexec-metadata: track previous kernel chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
X-B4-Tracking: v=1; b=H4sIAL7ncGkC/2XNwarCMBCF4VcJs3YkM4lN25XvIS4SM9rcC60kW
 hTpu0stguJy4Hz/PKBITlKgVQ/IMqaShh5aZVcKDp3vT4IpQquANW+Ijcb/bkDntJPasxxJYKX
 gnOWYbq/Kbr/c5Rr+5HCZ6bzoUrkM+f56M9K8+y6OhIQ2umbj2UbfyDZKSL5fD/kEc3LkN6o0a
 V4Qo0Zy1gXyxlOsfpD5RPWCDGoMFKvgfN0Yy19omqYngDDDgBMBAAA=
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, kernel-team@meta.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=7440; i=leitao@debian.org;
 h=from:subject:message-id; bh=hUYPRcba9zfyDjZaQs2u9sw+0GVuFqBCoC/amy5CRqs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpcOfNxE5Gja7tEx8/C45TJeRXvSRq4Q5AukReO
 pNqlM55YuSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXDnzQAKCRA1o5Of/Hh3
 bZ87D/9s8Zqi9foS429xPJJzR8//2drUdxcbvNbh85j9cvjJxmV1E9CFsRUC/Y/udMVEFTqkgxl
 YCkEPWKpnhFsbIdCKyabGr/EdbLYtPc9tlvgU3ruuCi/iApEAOvrouuiKVDCi2nOvdeWfnrAOKR
 NvmUZBmCj3VCoT1n+u6LmG7JlSTVN9o233+ZIG6W6mwt/hIabdYCKiOPE+NN5cU5sz4vmQJdryE
 CxTzXPkIAdcN9y9mj2Cnj7tGXmBZSy5zF8bxoEI7QllAPGtX48AiwPdqrtC+wg9gkDqWqBq8qZH
 MQLof7I8jy+GBF9gXXER6XYpDOnd4xlhgQmw6I4jl5m7vGBMCq2VLcqBY1OuiZEfJI9mOTgdhqN
 TzCoJKJOZlqJ6QJUy0Xj/Ia6vykQQ0skSF2t05ho71PrqktUDwfrb6L+mPWqYQz8I0NCLz5jyGK
 p5wJfDl4SSUj70wwSy6Ysw6GbKKyiedImTix1Pv/aqpMQ5aorwvdqWCTvEjcTEJ5FaKwd9y02fe
 bzKaZ8Nvoil2ZOdKd9I0miNiImNk2YBtI0iLSzrpPqyhE3jL7Y3vEzDlVLwHO/a4v08tcq3V6Ha
 HjAHVlGE/tHS5RrNR6r17nTHSh6V5S5D4ftTu9Gms4jTo/JDmJy2XMQ5tBqyfON+VxNqI7a8pkG
 yE73YjhXdQx6OEA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 834D140003
X-Stat-Signature: bxq4t4krwh7ibnnfu5ephgcgccy3x33b
X-Rspam-User: 
X-HE-Tag: 1769013861-300035
X-HE-Meta: U2FsdGVkX1+QRuWbiOoFRRCbohv6ZOBZRQPZges/SHs7sYbgF509hRqqRt1GVUm5Tqs6dRb4TNk+PKH+iEgNXxAFfjo2C2L/+ZMYXyP5QXqiyAKTf2DXeuG1vViKgp/esggN5FAn/tC13nxK8WIKGet0bpJP/RmwBz4fRnTdupAtU7gtB0+SkUPSRqR55uF5ocu5sOlryQ1ZSVgpkKWeE0dvjYMJH8fDkN6kKJy+Ii9u4cx5ofTMAU8SmRx2jBtPMjIdZ9xiC6OaPlFdqfu95FjFGXyJecCEDzpTmYyL8sA5o88R7zzcx2FyAWUUUVDE1Ipt1cr/k6AieG1M0wx3cxTC8pJ03E8WbH0PnCsXGGKzJ96243jpaXWkOd9FD0e2LkzaJPCPX29JD9F2qUOfLzKv6epRElBWsvwpdwEz7s2+EJob+333zrds6R8k8e9wIAsb2RUHZRsNjOma6p/fuZTUsRRZ+K1W6QVUzPDirzz4e56HpznX5XZq6Z+VZQw0WPrcv8sthigy32T6xCFkmPYB0cDTv3fdTUlA7vmrsbX47E8JvsWztqncEMLOri8JUdHYJI0j3AFHnqm7E4SGgGMRaV3YF9PFVt5WWkhZfpgpC9Lc0SVe+vlG1s0JFZ2eVJV+XzK+fIwEhLiiBDgKuOyN3dJZFr+gtC044hcEUStyblUr/RMGbFpUP2omvl1xf2TG7AfNu4NmrYeX+6bpTD9vgckQzJDPWZsW0yaaO8Olfu1lM4HWlgfNCw81njkwafIFoQjVBguJ1hdvG7Gr0406MBJbWyIKtPeMWdJauehzD8PTOKLs1kSMC1K70MbDLqZWlYP4hxqhuuaIZa/I/ZZt55tOkb/pzrse0+Og0Uday6CUGm+6ZOgQEuV4XZdZ/39iXuVpUd3VwcCdBCPz7ZZSsoP5L06uQpwUGKDUALC8C1wpdD4w/kgU3tsYpVw1JIqqYGW7PpOTLJCyQqL
 cjFxLLMh
 Qso8YRgidoezvXmJTC7/ITPo2pxYI5Ws8Y4QpVwiphwvrTX3wx++Koq4bUVUApODmVLx61ITBwYIu5sfHGJCPdMqGq7rXzrndNen0CY5CCIno2TUzxU01v6iXjvkd19FGT+wMbWnHBXbro1ssoGhWBhQi/WqCIZvhz9esrLsiZJbgXDPoyElFNKey1FJIZ2/TXUVyZdMpQQKi2iZRho0GDUUlTegrzUOjUvXj38rf6ewVR+TlN11tZh/rM0oC+fOhH1udRYBK3riXvW2juFedmHMuie+0dB0GsKgQEUKERuR3NrG/XnzLiiyVapFvmJUVoSdjlKE6t5IJdpt+fvLSYJgbL2BjdqdglMi50qjAJJq60wzh34MD2iLyuXBCAFGfTpSS81EOodH5Woi/CiNUCmGf+gFzxShIAX1iYstV3x2Y1jm8Nj25hIbp0o2iOSO70/xHZMUU/xJmsWCnXU/0A9NADV/khjAuZt38QIiNjIWf04GVWj2Yq1x+RDWDpwLOAhHNG9EkDYLNVqvK0y5Ak4vIClEQ9BOWjkzS4WX+qU0R3l+q7KvwfRCbxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Kexec Handover (KHO) to pass the previous kernel's version string
and the number of kexec reboots since the last cold boot to the next
kernel, and print it at boot time.

Example output:
    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include the following commits:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently. At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only
occur in specific transition scenarios.

Implementation
==============

The kexec metadata is stored as a plain C struct (struct kho_kexec_metadata)
rather than FDT format, for simplicity and direct field access. It is
registered via kho_add_subtree() as a separate subtree, keeping it
independent from the core KHO ABI. This design choice:

 - Keeps the core KHO ABI minimal and stable
 - Allows the metadata format to evolve independently
 - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
   when the metadata format changes

The struct kho_metadata contains two fields:
 - previous_release: The kernel version that initiated the kexec
 - kexec_count: Number of kexec boots since last cold boot

On cold boot, kexec_count starts at 0 and increments with each kexec.
The count helps identify issues that only manifest after multiple
consecutive kexec reboots.

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
Changes in v4:
- Squashed everything in a single commit
- Moved from FDT to C structs (Pratyush)
- Usage of subtress intead of FDT directly (Pratyush)
- Renamed a bunch of variables and functions.
- Link to v3: https://patch.msgid.link/20260108-kho-v3-0-b1d6b7a89342@debian.org

Changes in v3:
- Remove the extra CONFIG for this feature.
- Reworded some identifiers, properties and printks.
- Better documented the questions raised during v2.
- Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org

Changes from v2 to v1 (RFC)
- Track the number of kexecs since cold boot (Pasha)
- Change the printk() order compared to KHO
- Rewording of the commit summary
- Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org
---
 include/linux/kho/abi/kexec_handover.h | 29 +++++++++++++++
 kernel/liveupdate/kexec_handover.c     | 65 ++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 285eda8a36e45..e18022a4e664d 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -11,6 +11,7 @@
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
 #include <linux/types.h>
+#include <linux/utsname.h>
 
 /**
  * DOC: Kexec Handover ABI
@@ -84,6 +85,34 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
+/**
+ * DOC: Kexec Metadata ABI
+ *
+ * The "kexec-metadata" subtree stores optional metadata about the kexec chain.
+ * It is registered via kho_add_subtree(), keeping it independent from the core
+ * KHO ABI. This allows the metadata format to evolve without affecting other
+ * KHO consumers.
+ *
+ * The metadata is stored as a plain C struct rather than FDT format for
+ * simplicity and direct field access.
+ */
+
+/**
+ * struct kho_kexec_metadata - Kexec metadata passed between kernels
+ * @previous_release: Kernel version string that initiated the kexec
+ * @kexec_count: Number of kexec boots since last cold boot
+ *
+ * This structure is preserved across kexec and allows the new kernel to
+ * identify which kernel it was booted from and how many kexec reboots
+ * have occurred.
+ */
+struct kho_kexec_metadata {
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
+} __packed;
+
+#define KHO_METADATA_NODE_NAME "kexec-metadata"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3cf2dc6840c92..3130444e183b3 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -1246,6 +1247,8 @@ struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1331,6 +1334,59 @@ static __init int kho_out_fdt_setup(void)
 	return err;
 }
 
+static void __init kho_process_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	phys_addr_t metadata_phys;
+	int err;
+
+	err = kho_retrieve_subtree(KHO_METADATA_NODE_NAME, &metadata_phys);
+	if (err)
+		/* This is fine, previous kernel didn't export metadata */
+		return;
+
+	metadata = phys_to_virt(metadata_phys);
+
+	/*
+	 * Copy data to the kernel structure that will persist during
+	 * kernel lifetime.
+	 */
+	kho_in.kexec_count = metadata->kexec_count;
+	strscpy(kho_in.previous_release, metadata->previous_release,
+		sizeof(kho_in.previous_release));
+
+	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
+					      kho_in.kexec_count);
+}
+
+/*
+ * Create kexec metadata to pass kernel version and boot count to the
+ * next kernel. This keeps the core KHO ABI minimal and allows the
+ * metadata format to evolve independently.
+ */
+static __init int kho_populate_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	int err;
+
+	metadata = kho_alloc_preserve(sizeof(*metadata));
+	if (IS_ERR(metadata))
+		return PTR_ERR(metadata);
+
+	strscpy(metadata->previous_release, init_uts_ns.name.release,
+		sizeof(metadata->previous_release));
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	metadata->kexec_count = kho_in.kexec_count + 1;
+
+	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata);
+	if (err) {
+		kho_unpreserve_free(metadata);
+		return err;
+	}
+
+	return 0;
+}
+
 static __init int kho_init(void)
 {
 	const void *fdt = kho_get_fdt();
@@ -1357,6 +1413,15 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	if (fdt)
+		kho_process_kexec_metadata();
+
+	/* Populate kexec metadata for the possible next kexec */
+	err = kho_populate_kexec_metadata();
+	if (err)
+		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
+			err);
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;

---
base-commit: 5eec2b2e1f37acff8b926d2494eadaeef59be279
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


