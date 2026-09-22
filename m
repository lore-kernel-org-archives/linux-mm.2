Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086BAC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9B36B00B0; Tue, 22 Sep 2026 04:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091296B00B1; Tue, 22 Sep 2026 04:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC24C6B00B2; Tue, 22 Sep 2026 04:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6F446B00B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43FA180415
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:53 +0000 (UTC)
X-FDA: 85240762866.25.5154B1B
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf31.hostedemail.com (Postfix) with ESMTP id 778CE20007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EL0msOZU;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066691;
	b=wu+Df8A7Q5nj/pq7I8BNQOssP/qjpxHRhvfEChqtWZnS4zm0T6/Pss4Mb7NRRfyJ/mvuAy
	WS8BCfCijySHH+JmD9FzrMXWYu+Hrmc5FuZ76Hnavi3qLe70yhz+PzSIApjWOqgcL2OoJC
	czReO70TjrNitQSkiMLY1xCWkj0JweA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EL0msOZU;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBMl/FGlqf3qixhPiHBNfiW1ocejNfHGRfKnUu65etA=;
	b=OdOFFSJqNt+fSjP8Z9Gp3Z/2/T2XLEL5NJWHGh1tBO3KI9rWkSaTxtBIj3cZMEczXwp1bU
	2R9mIb45LNP+CxPPUmb6CuKtS0q8zaYQyi++7QxRHMi0EE1Eq0+gQK/A8aoOEFfMI9aEk5
	9raN8afSay/O2bmqoN2YMDJb+K6qaFc=
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3896ccc93b5so1278845a91.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066690; x=1790671490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBMl/FGlqf3qixhPiHBNfiW1ocejNfHGRfKnUu65etA=;
        b=EL0msOZUapYTud2tLEqI41HHbWpbAIxwvcvYN8PXO3IwSwDUpi2X9k50ZMYPWLsPL9
         4+qiWDF7onOzql7POesWCb2YZjKD8gvQyBP3geoZRkDPUV1TlgWeYZ621Fo6x+7cY01X
         cQLe7QLqfmpxXdy93lHpjnsb0dGovBMBwsHoo2mYKRJKl2AFYyqRdJuCGr5NFLJeGCs9
         TjTZM4pKZ3Lf+BEIU/un3hcEs7Y+q5rvgZ+Yx3F0iWA46+0ESzKhsgDJwYEQmjUu6Yfa
         0lMe/6Euk45h2gfrlSiparoQUtrpo5nddBRpgTPZQzG1cVuPr8sfja+i92uPKmxjRTvj
         IgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066690; x=1790671490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dBMl/FGlqf3qixhPiHBNfiW1ocejNfHGRfKnUu65etA=;
        b=AHSg2FEvLlTxgAXo7IjW/4tL9u+XnU4oH7ISoNqjqsQHzRFQZ+29FCd4JXo8laC1Rg
         4cLYuYRbVsK0Ik6p98NtyWFK1CZQv2hooKofAR7XdvCs4eVprmgX/+xzB0w4/yXSmYqc
         ReEP969GW+NY6mDsnCq74eprTlulZjk02NOMhB+5fQG49dNbNybv0tiLjILwKEOkht7k
         XK+dLSHuLd9qEa0XEsqW3kNTo1Z5KO/PHDpLsTdGadIM16hsb2k9xgAYvkdsO0zFPgx6
         o8dDxK6fUrXEZJp2TjtygBP9Q9W7PNUoV+XEbzezbKHIIGzpg3anT++RQPbs9qC9iljt
         YLyA==
X-Forwarded-Encrypted: i=1; AKwUvByN/ucjiVrexd/V9YTQdxoGq4ztt52Dnace+p3Bej3Aj1xmze88nfzo2MA89EylvizydBVMGJ4yVQ==@kvack.org
X-Gm-Message-State: AFuF++kSwfJ5+PG5VieAFZ8rgMfA97BLPHXDRpKy4GatRJqfpXdk6ODp
	+kxbDNAMTeUPoIUsx/HcgA80tikFb6UDxH4U6F1qUdcU0ORPRvaKy75t
X-Gm-Gg: AYBFou3bMeZ6F4Gvu1In9EyVeR1WpXMtauTmXRyFgf8qXFcIDVab3r5RFF7Gic6d0GL
	8OeNe3zkkyL2y8bgNdA1knlAR6Xi1PtFvd9juZgx7SfQZ0HJV7Y3h6EGitrrEJz+CN6IFGptKJ+
	HqxX31z8LRPyCrI8v5gmdoppWqbOv8qWZJiT/N11SQnP6udmAmWbtZr+9wZ0bmqnSty0HDUqclx
	X+GV6NN+bpaUfzAMPktseZEjarsJ0SbgCp1vffgM0haQYsK7UaLUgdaKliKRHkG62/9xyofxmke
	oHgc+eNNeLbkbF/CgZB2OxAubeJzZqrr7awtGJkrFLG8mjRAlRcylv5GI6s/+aoN6w/5wrdAAcJ
	0iz97i36A/t8yQ3G0G84D4g04XgnWJPNqzqb5jDi7ItV+a0FcR6uiBL0ULLX7F0hXgLHn2lSj2Q
	CCYBNQPGGaMejPom59ukmbUGei3zY4owNs/0u/8xpKtnlmQzP4PJmSpw775Lv+mDfIGgyPhN5Y3
	7zDnTiV3Nb/RfZQHACD2A==
X-Received: by 2002:a17:90b:35c5:b0:39e:6a80:dd9b with SMTP id 98e67ed59e1d1-3a0731f9793mr479077a91.34.1790066690219;
        Tue, 22 Sep 2026 01:44:50 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:44:49 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
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
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v7 8/9] of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
Date: Tue, 22 Sep 2026 16:42:55 +0800
Message-ID: <20260922084256.1515554-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 778CE20007
X-Stat-Signature: s9ca3nmtrw4croqntw1zgetyg8dp6yry
X-Rspam-User: 
X-HE-Tag: 1790066691-632481
X-HE-Meta: U2FsdGVkX18OuU8kSQANJM5IKoaKtE8WPdyq2Y3YH60xNHPwjOH3u8OuCIzkQltbQOw/UkCOOCA66OlA6MTtvyN1u71tXmf6WwnKXZxdMyNxjqFZKKpGLCbsLAesVV+8zJzqHCVtb2saZjA0QuuAoaiaTKPCjSwCupU6KrxxBYHBOzJp8Y9da8dW5Z9Gl4nNJlB6sZyTF0NoJs+KGiVw+maGOE7Znvs16eAQItrSQxS+QWcq65KJZGwfinLT69a6oJB1FxMEKJKhwJTjAuFJl2c4KlqJqmQWvgJwUzx8tsfWeVZRzDMdb14TrVQTFBvP3WigAcY+eGVJz48CaT5RU0ORmiwBXpm9VexAqwKQjQ9+/VzPnH0+ZRxvIgyntJ/wxk/VTn1IfE/2YMrLuyITsvN1VZ3vRyaj5eTduWKpaf88wsnaUNRNGPuuPxH4BT2Rzk2KwV1aQeI5n+o8ty574ZJuTFjf2+e2RjwwMz4rWuU9KGk1pIZ8NfSpL3nifkb3qwfbR67i4Dhy/t9HmSM05yy2mK9hnfTZ35iKexd6+FJz2kvAt4kGEhiJyNU5VGKsGN4hZYrhhIFI5Y+C/lnp2Wxn0x0FtTZ5s3zXdddaO8yiT+riKg+K3My4qABynOqo5hEzLONejdZSbFsX+Do+cN2v9CrIWcP2F3jLREWSmyjbOFCJjZSRofYrLzdPbVjXMYg7Gq6YYU23mA3JaohWOJWAOjtjj5JWTY9T841820xHisOh1DPnUgM0kNRoE9kiQMQbfzBZ6eT/jFL08+nM82/6126C3pWYage6Qphgf9rzX35f9bii6/0PHuzZbXR4HLJmkuFNsTt0XyZu5wXGh1fbglyxRkWNKuFSINK6s8qgh5JH8M3wwyRuJdYTN1thu2MgC99KUyIahZz71ViF9fmRaoDUxW679AoGdH61GhrmZBGU2z68K7iimUWAvbdKlsR5AnAVGyGKou1Azyz
 bBnq1wpH
 XjfPifCN/Utko8Hfazo18MqlTNSWEtUxktFV0h2xe/Z16IVvoSUmPZx+DtYogOISPC4lX4R2hipO+pCoNPGAkPrpUb/J/ipBIEYys1DZ2pOhaImPdWRrLmq2XDZn0L9VdIPEsPc9UP292A1wIVgOdYBKk3lYLVpR4NfK+d3hCa9fqYCUBRzZOZ22i6V2ukdk0OLXeukkVECxEl5PF/tCwpLtNcH776H4JxjdLJuKPXodkkZnHDyvcq4TvrA4mv7th6gmwf0+TSyhEoJ/f2pSQqvViaI4yH5+AvIFAsKOr/7BKgw41YXW3ak9bKfQlJt1knVIfTvo/W3TESmXn5EvKYBpUg2oYM0WyjYLBTw2O8Nclp/Pzm+qjHfFh5K+Agj88tg28c4RlPidK5m6xrmof3MOBfzWrFude0VcUqYcH2wWEIoBjr1loNG6VsmOmULJfRw2i3pX9Q6+wtvvn3kBD82AQu86pYS29+hZxTl7q2ZXdytNBf8ui+cvyIRv8Du/eIkNArRo0QTyxeY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

The /memreserve/ entries are memory reservations made by the bootloader
or firmware, their contents are not needed for kernel crash analysis,
so mark them MEMBLOCK_NODUMP to have kdump omit them from the vmcore.

Entries that overlap a dumpable region (such as CMA) are left unmarked,
because the pages of a dumpable region may carry crash-relevant data.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/fdt.c             |  1 +
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 286fd4db6312..9a727941b5af 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1286,6 +1286,7 @@ void __init unflatten_device_tree(void)
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_late();
 	fdt_mark_reserve_mem_nodump();
+	fdt_mark_memreserve_nodump();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 505735732c13..6497404ec751 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -188,6 +188,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 int fdt_scan_reserved_mem(void);
 void __init fdt_scan_reserved_mem_late(void);
 void __init fdt_mark_reserve_mem_nodump(void);
+void __init fdt_mark_memreserve_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f29a07e8fb23..a42cf6eac55b 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -251,6 +251,39 @@ static void __init __rmem_check_for_overlap(void)
 	}
 }
 
+void __init fdt_mark_memreserve_nodump(void)
+{
+	u64 base, size;
+	int n;
+	const void *fdt = initial_boot_params;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	if (!fdt)
+		return;
+
+	for (n = 0; ; n++) {
+		int i;
+
+		if (fdt_get_mem_rsv(fdt, n, &base, &size))
+			break;
+		if (!size)
+			break;
+
+		for (i = 0; i < reserved_mem_count; i++) {
+			struct reserved_mem *rmem = &reserved_mem[i];
+
+			if (rmem->dumpable &&
+			    base < (u64)rmem->base + (u64)rmem->size &&
+			    (u64)rmem->base < base + size)
+				break;
+		}
+		if (i == reserved_mem_count)
+			memblock_mark_nodump(base, size);
+	}
+}
+
 /**
  * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
  * memory regions.
-- 
2.43.0


