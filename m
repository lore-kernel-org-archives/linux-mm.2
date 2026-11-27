Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56D4606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yU6OFGiL
Received: by kanga.kvack.org (Postfix)
	id 779C96B05D1; Fri, 27 Nov 2026 04:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750886B05D2; Fri, 27 Nov 2026 04:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666AA6B05D3; Fri, 27 Nov 2026 04:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEF36B05D1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:09:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABFD4160278
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:09:14 +0000 (UTC)
X-FDA: 85480325028.08.407C069
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA67EC000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:09:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yU6OFGiL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770552;
	b=D6JQIWqoI9quYSrNR/AE5JduZr7UmsNXx037YnVHdGJjfhFTjFN+1BXT4Qdr01MMatNVzv
	Sd3Tz/RDQDHFvAimoT781JWkH3nrTUtDqu8P2/xO2aujG9bQvLfpiHiAizG+xcfNIxUPkL
	s7aqzs4OJzWTgsSWusl+tUOJOnsmMZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXO/Y/CYrpQIxWyPESy68yxl237JHlY56bkJQSv87LI=;
	b=l4r2JDDsMhz4DhcmhpDM9yPwy8FP+vWdeKovXI3TCDxx1ZvklMU4zq11oCIJhqkRSCw/bK
	Q0lN5DFyl16gxVzGZKL9VrtOxASLB7xh/u/BKfcw+uqh3Gm9QJl4tVTl/k+HK5pdcAj2EI
	dcnUF4Vu6I9Hq6e1HyFp8st5dFctuFw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yU6OFGiL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2f01eb3a7aaso26292525ad.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770551; x=1796375351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXO/Y/CYrpQIxWyPESy68yxl237JHlY56bkJQSv87LI=;
        b=yU6OFGiLGNWuSCFunaffilN1s2jKiIcqlLg3UecYuR3AdAb9PQMHA0DeGT/+3Jjiyt
         ogFOsbBATMsMBXOGotflR9hBxEq1VExi3Y/2lEAU9y3DLIcgVkxXnlCmS4LP4IVk0woE
         qdJ4gD/gIWPFTa99AIU+pyU4XUX/8Ikx4+xJmKGiyIMhhCZl+LYb1RyZcT9AMGdU19Bm
         bOJI0gqBOqZ90DkYcF332B81PEkgpdSTe5BKQj1bMvIg9WZ2JjpAOR2TyECgxj+dO5cd
         e8TXbM5U0joo1MT7yNXtvzEkaNe2LJn1LGe+glNj7EBV/mzEvJ+X6mz7PyznaonETWCZ
         soBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770551; x=1796375351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vXO/Y/CYrpQIxWyPESy68yxl237JHlY56bkJQSv87LI=;
        b=zknNqxBKo90YZD1dB+ZYYisIhAP/QmQrB+KCWqiQ5y1/Ax1yQLZmGyhModXtP89E3E
         6zP6Z8b8BlF5wU/HLVNhHAkf4jd/IsZvR4yp8/wLlu18xfc9MN8gxtQVtfgoTtzDS+Ot
         4bUwMXdNIi4LiwyLjujEhkMW2oE6OV8KDyepesQNSxD1slHYubF85ObN6S4YovW804h+
         6/LawphOHzh7fZlaAllvFL9ma+IdPrXo5sBRzxpqapB8X0Xp9eKU294s0JIQIJRlJwpw
         Avyd/BfssT39LdLMLAYCTxCHXc7PncxEb5jZvtfxmZEsxm7udPYp/zXl31+mC1GTryKn
         UyGw==
X-Forwarded-Encrypted: i=1; AL+hErGII88NeWb4CpkspCexB3L9cRFvgt5l0OFNVrhTSKSFWpU9tNetDauzklZSdENf8R6YQD5I0OI8tw==@kvack.org
X-Gm-Message-State: APuU4Z/GCY1ZHuihNxuFP4251sRKYpVdtaVLo0CbPizH1klcVoUHkFv4
	7zF5PSEEWlkqXF0iYe3MQSvaKG+YC7bOxjnnQRMAxXd9QCCjR7I2omVa
X-Gm-Gg: AZFdTZeJWr8kCLA3a6HW/Jxct1VBaNXsK5ktbOE+V19pVgIhvFknz6MT9m/84bAXuv9
	1N4W9C2/cncYOQH7lShh+q7l1xRsDhx/vnZRbVbCTGsXCjUgQ9k9ePdEQ6zeCLQv4nPpkHbJ+58
	DyVJ7LERwB0b/ER5rJqfzGCoZICALbE1fHj8Ph8MwvctLNv03P8BMV7d0KAwhQYvrmodPrk12cT
	cZPFM7tA1m5JfXsOjbtkK+bjC7cs4zd8aUfT6II+I1Qf5O/l15QZQhcigqu0iOm1E38iNi1QuMq
	k4GZBeUYOuBtiGRK7CZlM6IT7V+hIDGBx5s0mi6+tJtBcIxieVWdIj3cxytnURn5ZGdVqyWPA4E
	Jf2zllmaPR2ZOXiImDgTtGNMb68nvT2G/V4RFAmh7ZKg6DuDYPAr2w8uGM+y54iRHO/IGI35MA2
	9ncnchdrpjROZwQhFF/VNaipPZb7DMkElTGF8i+bhkXdQ9zuPSVk9TLKpWhz89tqA0/HWadLV1f
	Oqhb/k5/2HNTpPpM+ff1veHYY2N1MBWT+NITfB2+p/uf5o3c5ASKfsUJCm4Py+4kS3avo4BrXy+
	z77KAZrpoWuWBTabu9KLeN83ExZl8SQEWxL1OrH/TH0=
X-Received: by 2002:a17:90b:5907:b0:3b5:29e:11b4 with SMTP id 98e67ed59e1d1-3b5029e1464mr6516552a91.44.1795770551516;
        Fri, 27 Nov 2026 01:09:11 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:09:10 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 7/8] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Fri, 27 Nov 2026 17:07:22 +0800
Message-ID: <20261127090723.741253-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA67EC000C
X-Stat-Signature: ykprec4huo3jt4t1q4gqed4mrqqe31wp
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795770552-665849
X-HE-Meta: U2FsdGVkX18L5ljhVJiP/jlNMCAx6o3pwG1Jh1Lv+MHNgfo9XNju5TZuRbCe4lH8U3vB2O5r7w6QNJa7OWeAFTCfmNllYkxyBXM0xQ0sd4c8YafgDtMqJIVOawZssfPpobLq/9Y4Oru0s+DJjy/0Z6nKmihjFjj6Kaiwe4XHTBxoUdYmCTLddMEA5vu0hblO78oytdMd9bMfSYwNzHVlydBUdGH18CjvN1EaifuDEeyNGx0tg5CKLz9NHec6YTpeb/gi9LyA4osCzO74ElTw1WgpZLTwPMBTqcogTl+rmQRV44D+zhO0CjizPPa/TrwPMpU/+vlQ6Ijay4Z7G8gb/acgrJ4GvxAb2xZuL0IY6wEAm4h6ra0DDIHczAyaMo8OlhoqcwTPSbLE2thqL52fUSElAm5vkE/SQR4C3g6yjtDnE24DH728MAvgIOz8gxSmbAaS/X4focq6Q3KJWp4Bby24T0e8BIPBbaZcoOsux0cHfEZtiKB9hD7Q25QBCazrsC0PWdVlcrqzERUmEo9V8UL1+OgRH2n9pYMyUemlzyq+WMou5QGQwQILBjvg7B6KEkS6VvA78Plx27ZP9gQ6HLyPu1btKdNRhRjV/+OeoglLxVNzE13tflr0SaeioPVhyVcE7gVnu7pFBmlzyQ5h8C6tNp0FBQ/wMmm4p6RtzSf8cCm1RXZJNLYrZxu542ZHVp0iUVWSruledx0vWtX1Et2Gq967j5Y5x3frhT43p6d7VPmNY1MUP6MCrm8pVX/5N3gX3QCgC3nd1GfawxGwhxwYBNEIsfDNyMn1hSLMFTUkOXTmk20Znm+dN1bykxakq6oYKFUwrAiE4fITXw2vdqSPGfrUUtorDN/KgXastv8lZbiVCuHsjhMd/K9agYdNRQ5x7aZgLK3mD+clfOj8Ezjs5xqKLauQ17ohFqTrSgLOwTgm6+bb9554JY/O6VbDzh1CACfj65c3FQ+zR37
 ytN9qCrT
 pW6yiPiLl1jhx/InQs7L6G+MG1QHHCNWv3StOFRRU+LNrR1X4mFPOl5HE1+dHPy4sq34pp6/x59uGXHQLsW9oepMCfBzvvWkRgaqZcbmVduksFWNzWicVCpi4PQVW6pQQvQP74Ba6/CVl+XD3qllOszdPmcGCuBd8pS0o41Cc5xRb9Jr5ComdbOvPBF9BF6s2myVb1AMbPJpYc22NTZBMOTM6JWg4Z2Jx66yKQjXVA2lB/T4Z8TKX2Jla2HE6QZWNfxywv9IODB1wdhdhQhFihvmEsIMdLbZMl5Z7qNimTNqk7g6XA+ym4EpEelsHMdlGAdW6sgKQP8SRQ5Qd6Rarkd6ExIkPzJVJ6jIOAaiXFQnQaa1fZ/y/z8lmdvwWaZ7WjtKZkjrQKI7QLZfkIgY317U6juX0f/9yekYR3xrX3j6R+LK4I7m0kQ1AgMWo8AJc2qPfbAa3JX1n2eOVLC++BvBDqzvNQ3X3zpifhyCvg9zq8+nSzXXCRTubvUCb1HLxigP/xybyqPXINJXXgSaDAfC5hsiP69b1nQae8v4jZuaL7VShBnVn0eG472yHGBJEyUHn6mk2l03MUGQRmiCNm9eNJ+7OYoVkwmr9a4hY/0R7dx6hwO1Y3ugVll4guKlS0KLwgPv53wTOrMgzpq1EcW6Lsr2ZLTQu7AD/Y43d5impnIvFKj3YdkZcx7dODjh2ljUatEWrWD9eVhd/Q9v3ol5wZsaAvCQTKUoaP2AgiyzYDWY7gZ7z4MaMswsfcadGiKle/nVX0q/4ue66OpnOIenKxU2RyGpJ36q3ujry3HlSdNjXeQwuqXaF0pG5jfmGpquu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
kdump can omit them from the vmcore.

The marking is guarded by CONFIG_CRASH_DUMP and either CONFIG_KEXEC_FILE
or CONFIG_CRASH_HOTPLUG, so kernels that do not build or update crash
ELF headers do not pay the cost of splitting memblock.memory entries
at NODUMP boundaries.

Clamp the marked range to page boundaries, since a sub-page split
would leave fragments that cannot be represented as valid System
RAM resources [1].

Link: https://sashiko.dev/#/message/sashiko-outbox-181183@kernel.org [1]
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/of/fdt.c             |  2 ++
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 30 ++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index a58efdcbac7f..f3a766310d11 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1283,6 +1283,8 @@ void __init unflatten_device_tree(void)
 {
 	void *fdt = initial_boot_params;
 
+	fdt_mark_reserve_mem_nodump();
+
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
 		fdt = (void *) __dtb_empty_root_begin;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 895f868b4cfa..00f776819dab 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -185,6 +185,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 #endif
 
 int fdt_scan_reserved_mem(void);
+void __init fdt_mark_reserve_mem_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index a5cd8c2fffc3..cef444d4c1a3 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -610,6 +610,36 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 	reserved_mem_count++;
 }
 
+void __init fdt_mark_reserve_mem_nodump(void)
+{
+	struct reserved_mem *rmem;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_FILE) && !IS_ENABLED(CONFIG_CRASH_HOTPLUG))
+		return;
+
+	if (reserved_mem_reserve_failed)
+		return;
+
+	for (i = 0; i < reserved_mem_count; i++) {
+		phys_addr_t base, end;
+
+		rmem = &reserved_mem[i];
+		if (!rmem->size || rmem->dumpable)
+			continue;
+
+		base = round_up(rmem->base, PAGE_SIZE);
+		end = round_down(rmem->base + rmem->size, PAGE_SIZE);
+		if (base >= end)
+			continue;
+
+		memblock_mark_nodump(base, end - base);
+	}
+}
+
 struct rmem_assigned_device {
 	struct device *dev;
 	struct reserved_mem *rmem;
-- 
2.43.0


