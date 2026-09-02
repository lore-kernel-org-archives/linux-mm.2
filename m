Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA7FC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC926B00A2; Wed,  2 Sep 2026 03:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E3D6B00A3; Wed,  2 Sep 2026 03:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5F26B00A4; Wed,  2 Sep 2026 03:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A27276B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:33:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C9C11C25BD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:33 +0000 (UTC)
X-FDA: 85168007106.27.FB8113C
Received: from mail-pz2-f11.google.com (mail-pz2-f11.google.com [74.125.228.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C3E580009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECmanRXc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlegJqwkFPej4fFKCV2MAr7wlJV+QNtxUfZHapDGJcw=;
	b=OSsj76Zj+fyKgXSfYHiqkP3K56lu0dhGQEeA9end4c6121zvHoRAMx65paLLYWA9tQvLPo
	4bWmhRbtT7JLEeQYzWPP8F2e/wPPgwjMDaLLIQexgHQG5XhACK8szKM/PYCAR9v1560S3L
	PnWv50GUUC3tccOOoGs49MlQs9jeaZI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECmanRXc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334411;
	b=QhS7O5eqIlksUlt6FQq2TENk7oTVW9qOnOKtPhIo9TaGz9GFi7D1aPa4SPkqhcyeQcysFS
	nsmDzOVn//e9G4N3cVG3zTCjFERzoQ78fturgRYuUI7xMLfaFT+EJw+hpXYQR8lpg6EKf8
	5pmm10ecfHDpg+IykkZivCdYVVmrX5I=
Received: by mail-pz2-f11.google.com with SMTP id 41be03b00d2f7-cc1c2963c92so225109a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334410; x=1788939210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlegJqwkFPej4fFKCV2MAr7wlJV+QNtxUfZHapDGJcw=;
        b=ECmanRXc4sWaXy4/Fhl7qXMtp/4N1Rb+4NQTkw5e4y/uOXck/31KrIO11EVbrF3JRs
         +41G1CyDWdyz3r17IgZpGIJsFZ/xpDCKrr9KLf5s77HVc3Tr4DkeIwbNHVnt1HQR/kr4
         pNONLvXCSyB5SXh0f1Y6ir042PkyUGcKhxMAllsVEpCtbPtCs/JS8ijBMDB1vX8YoNI6
         8y/K1Z/8HYkHvObUKyGZq0EyXavTByPA1N14qFai2VluDEiSx7a/165hw5WE/VEorBHs
         9wxExH2T/q9UaFU+H7nuy5LvAJmlCFYxA+avNCXznbsQmjLJ7mWprfOOIdpuvC62UhGy
         2d7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334410; x=1788939210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IlegJqwkFPej4fFKCV2MAr7wlJV+QNtxUfZHapDGJcw=;
        b=RwOXkHEZLdLud1fxMMumEVmQXxCC3K3HEYuxXVaBJHTj8hFXsOtxKwncZhTYa+q9h2
         2sV5SGam1qjLNtTtjMS/VQi665iw6OGFqNMdlCArbtCrut0oFXudjGP5JAPUnexwHnRH
         PiPuxfV1Kio8HeATg+noIVU7PtrQJ3OQVXvD7Z36yUA8kUODIlb4TmOzgoIdDhkznO62
         S/DY0wNIHCW0Ujw/H8dEaZ+1TGuL3pV6S0p/8aoVPMH0FeUgU66Lg1YuNYx+At1iFVZu
         h772JOPpOUkCAXNhG0QP42k5LNiptAzFaoTzw/4S6Ca1WQgTtNEOx8gZNEch3hIpPQcQ
         KdJw==
X-Forwarded-Encrypted: i=1; AKwUvBwu6fJFTid4HULAoWe4R8VQnDc1itdo53/k6J1lYgFdswCDvjk++0fBc5dNbvT5AIkUGD7+biAzSA==@kvack.org
X-Gm-Message-State: AFuF++kBUTSrkExsQAuB9nBg2Z4Y1V67APVvZeDG0lkWUFFTlKj4c5Bf
	I8ly2Srz63t4J+MHObMb4M+4sMWnNrntDJ510rE9JVqBXKO4wFSthXlu
X-Gm-Gg: AYBFou3H2hHZCG9Jobx4SnN9bFv4vs6rKiXHpxtO4G0M82DxpxjZkDcGccvEVILsTHF
	Pkh2rCdlHZ6cMKmNAzuMNqxg/dpp429rSylTeigz93t14TNbggQexJSNxmf9613YXgHZnLnqbGX
	xBcEF3PN525lz7Kvp9BaHvJmoUi5DnbzUmWMAxACS3PcLI4egEOdfmaVn2mxRQdEhf8b0jx+byU
	myNNWCawbewecEyZHiw3prXett4UFBltOZ5xqJvaAUthkcOZ685wdXejV2zsZ3g1gMu9yvnBLnQ
	gn38eLkxUKdiMzwWg6/LIMSAEEfpK0MuC4Hx2Ntoeoji2uh1IQnGYw+6+O41YGBkRZjHxbQbZF8
	0wA9Uzndb9J1+DEhvTIeeyupS2KqUS8HM6WYVpVNuz2ve4PNDfujWnwI22TQmGTDEOZOzGINY+b
	asJVzNg5LPKrYF7mYI40he/Rza515T6EXLFX6Iw6f4GKVCK6nGTEkFoy1OcUkKQA4dMEfFMVuD
X-Received: by 2002:a05:6a00:4408:b0:857:4dea:e2fe with SMTP id d2e1a72fcca58-85ed8ed8414mr5132871b3a.13.1788334410213;
        Wed, 02 Sep 2026 00:33:30 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:33:28 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
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
Subject: [PATCH v6 09/10] of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
Date: Wed,  2 Sep 2026 15:31:15 +0800
Message-ID: <20260902073116.802752-10-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nifkwwpahgyqnkhhn8qifogp7qfprmj9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C3E580009
X-Rspam-User: 
X-HE-Tag: 1788334411-829075
X-HE-Meta: U2FsdGVkX181XSZ+P4s7BjYUH6ekXnPRjB0/edRDOJ0GxpjAzYig3pHbA3zXklhDsF0Rb7Ap4kARUnBysZwqdqfZp9D8x2xnmfnY45cpd2LZLx9NdPlOWLiy2WYEIIlSQMSuC5sqiuec8oPuY9XnEApAd9iA7TlAcU6ZQSDFfGpXFMXgxuffa/rud2dt+xuZmkyJd+bSAq6krvNm/gdi5gzaOQ4X9ec1rmIWmvvJMyT2f49cMxsMbRVv1jZBQHaqkTg/Rtw/5b0pztVxJJ1aYPT70+Bt+dau9jLGzS57GOrzyXy7ExJWeT48UKB0LjL1u1ZJX1OrZmfcip5xfveKDRAVHHjL10MJed29+Ub432/0gfBXHC586IB5LkEsXNpCTTgJRQGglgkzFnI9F2sXeulsySV62AJo5P1DoxcvQYdaZUfda7bKtAE2WcAdht7B1onZXqfW9JmxfYqJcI5iyY/9U3P3u+QRsKIGipiwIXWQUUT4/ZgqJs5/C5qMvWeua2jiuPmqnYm5J9IivpiDrWgAXTPRZ2Jd5lfyVRYjtNkT8De3Vv2S+rUyT7YLVymFz2xOKOo+2smQ3M1lUoZaV2FruMrGIWWpd2lV7+U0h1HDkeWUXckM0DxR7gRO8laL47GHVEe4DxDCCAyj1bQKuDrCymHyW6/6qLL5Bz+LsdxKmbDYO38UIcaNSBLrm0JWBC1fP75jvzaMv9LcO7LejLDPygYnyUrqMTG0o/Oige8eC//ofcR2Gc5Y3hh80+FtMK/gTi9rp1QGOaaj2rmXTqwcNDTgMa1aJrWigM+RCijnEApLFfr2AATY5v/Q3Pt8Fafm59KO4YL88cHRKUlSRgmvJjZ4oJaef8TCn/ozHWUuPOEKzU6YOeejSLRUtHtJgGsrR1vmnzvcWXf629PPQsQXoBWifPTwLnRxNdzFyQUWCXzwMR6rl6WJ3j8sUwHfK98GU2jhm1qefEYyksl
 Diz1EhqO
 lo4ytVQzwXDF+HU+AbWHcW8pOsSn/ZTel4aViRUwQlMBTol1reeBFCA1sTCsodOdtewjZWs+uKzTwwFDMAPIdKPEtM2gBjZvxWdAm8pzM4bQZ67JJ07xYoU8wsSfw9xBJSCslmR1jS7YGIq16DJqN50EPutJLADiEjqDGPRpsbAPaN6THcZRYEDmzEGaM31Bdq8YocFfZKG10GIn0KU54iVFqD0WqOKJUj7lUnAgJdP4vbJ7kX2PCQruhtoiPny84c0tok+zE7VDVDX51KJ826kS7iykIAHp5IxoNui9gIWraOVB+LT9j5Mfdjf1UBfFdHJd14Z6R8eBQm214IsiHFJxZSs4bLZMzT3vmyWwoyuGQkdRwC8SuUsTpqq7usZyV2t4T4tdE/V+UqpRXsQs+7jqA5LDLt9uDj3KDBbXQJYv0KRSBKauvPLCu6iWRbnrzPDrdjTG14tWjzju5HfWsFjf8fvJ5zulTMFZQUK1xFACaSekh4sDVPeMe5g==
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


