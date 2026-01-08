Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF174D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8166B0089; Thu,  8 Jan 2026 11:41:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3C56B0092; Thu,  8 Jan 2026 11:41:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340DA6B0093; Thu,  8 Jan 2026 11:41:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11D8D6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:41:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE5441AA5C8
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:41:25 +0000 (UTC)
X-FDA: 84309362130.26.EF45EBD
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC57A80010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:41:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767890483; a=rsa-sha256;
	cv=none;
	b=piDWfq7cNy8hvV9r25nw+bKIPp2fVVxHOiPA7oFCOPQ28xoQ8K8TNZ41xf1n/otyG5ygee
	YnLjXALkAzPVTv8F2ZCsBrmU6kRaByIxcmY+80hnwk0QIgCJjRUROTKixRbD+H+8+RjxfC
	cCRn6y4rrGmvOWVKwxSJybWz30r+Dak=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767890483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZ8umbGJ/p+Drr1QM9elVdtntyBO93C2g1yduoenlV8=;
	b=0EAqRMXdxeK5vkX6qjCL6LAX2XonVWfQWgP86jFPuHrgEJdJBzZY+BtOJ2hb8IYpOCjXrs
	4C+2nbly99LbN5E0NRFB5jruzSrF0uHNeac2bOw3h4wBrMb9RWJVy5K/x45LV5bCnSuScy
	I11ukg0KikuduPZ9zeiH93nV2Tmp1jM=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7c6d3676455so1772233a34.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 08:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767890483; x=1768495283;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iZ8umbGJ/p+Drr1QM9elVdtntyBO93C2g1yduoenlV8=;
        b=mbOXKNWUMjD8DU7qY+Gb1BCWXYDmbkOLlF6BRFcwwd5KbHL3cdG1sw8n+ydT8Mo07h
         A/6jBob3hnUqQRWEzWPuuaqY1Dbf8339I80qcPjLCrRKi/+0JYRSCI8fX4rLLye9kTX4
         bz8zkMmYrthSGHqTvRRUs95ImIOraY+J9I02sdbuqX2lSa5Mkyu//6X3zPlcIlIs1+77
         i8YaqwAfKJ1xKqczR7VZCJO95WSw0Mvl34qSU51KxZkLG0FlXHfAz9KAqLO0sXYaX4MC
         DDdk7x0cTXbJWhC677Tmha3f4PXC6BmlH2DeAU6X3q8+AIdkkPLqtUME1O4/rUB6W0DJ
         2MOg==
X-Forwarded-Encrypted: i=1; AJvYcCXzhhcjzV9phG2CAunPd2Htb5otfxpI/XFWYMWIX+wFZUltnZsUIXq0luIjfLGumVoBQ7JALGiBxg==@kvack.org
X-Gm-Message-State: AOJu0YzSaU9A9h7mL/6m2SEgb3UfWbmvRnpCm6jHKiU0FNj6KhyCGuKG
	xdZwJJ85ImPE8eWodRyPSYiZZ8oEsITIM1zSnwN+y9TfRFNGCSVUSiTh
X-Gm-Gg: AY/fxX4MOeX7DrUn4cT92x5kr8En7p7hBWT56H1DmPkhSbjZujHZZtYJKwoeLCXzUQ/
	EXE9Qk+HGCZPEkSCMrWau8uvYVTIbGzvsIZnrl7b5BnjHZPa94stuALFYL3Lpv3M9gN41JWqL2T
	kfcI9nL4/7iAeYdoHZ+HV74Jl2tJ30zvJYUi8RrMlEW8/LXqDzPZ4pVYV01d9YbXEnXH8LeTBPq
	pZ4pVNLQtUZRBO5LDnWUBGZvCgFFjBqA4u+Fdcf4ivZ3vcIb4KgWpoXdf41v3MAySVWCkdRGrR3
	Qebatnne0pEQOPHyezon8CNzm4Vi8ZqeuDqEOzShQMVQOA4kGysofTRckZB08jFeWquAN0g3vF7
	4ixJxpoG9dCQf7JEk3eVl8i2PQeUBxsQs/FZt3oXQmem+1JDSpdvMATcmEuFqp4bc/XZItUMSic
	iEJA==
X-Google-Smtp-Source: AGHT+IHCIuadUBoGbDl8lPNAk2Neo0/wiZHMcJrJn3lIxd7Vxi/rrb+Y2bIjsKx5NXNgYjuC3j6EEw==
X-Received: by 2002:a05:6830:1cc2:b0:7c5:3045:6c6f with SMTP id 46e09a7af769-7ce50a28c93mr3497087a34.20.1767890482801;
        Thu, 08 Jan 2026 08:41:22 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478af8besm5595632a34.14.2026.01.08.08.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 08:41:22 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Thu, 08 Jan 2026 08:40:59 -0800
Subject: [PATCH v3 2/2] kho: history: track kexec boot counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-kho-v3-2-b1d6b7a89342@debian.org>
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
In-Reply-To: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3603; i=leitao@debian.org;
 h=from:subject:message-id; bh=EGjW1NDVm9NCUZnt/TocKG3VnYx6DZQuPLEer3uoR8g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpX94vFhyv1+q5nq7d3U4aG09l2a2v9OVLjM38M
 Alw0viiRZ2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaV/eLwAKCRA1o5Of/Hh3
 bYQwD/9eHb6ErCrxXzsTuDNHlKgULxd03DOyrKRfmQu7kTOUtZlqSCyZ4P2EeLCfbluUpJnnESG
 UAVFWIxNs7YXzhUNd7cWqmoZH+mBLVOby7T8HD+MeG+8z6VuUQXpE9mQVEsS0N5g0L6+FWWFgAd
 VqezYtxXpJeV32vXCpcmBEcZpUE3od+8MAIK1LqWcUbsCKLy/0kXXemulGMzLks31aLqX86ni/i
 X+9lZpg99/gVXF8Jz3lqX+hNi9TIRsXWGaU281XTD1tF3BgTcXXCyHE8m15DjbelamQimU3chBg
 DMteI6JOK4sjOWjTLtutUHeHuUwcuuUpiTc2Zk+pvF6X4ij24/VQcoCVl9QLiHL4EjTlbYaXGMK
 eh6yLVMjs32YEVhnOxY850v6dWpXovo5PFQUd3ECljjlvTmrD6aLrQh1g92CX7sPIoJYTOEIl8x
 81RtpCzW+Gky6ezAfpzbZfnGAJrQi2XvgB6Y7xvZEiDsGTKtnNKeHZ4uZDf2xt0EBZmbk8aP4Rd
 IQ/tPzLyEsBSAJTjlPDAIaeEFRFmBwoI1s/vu1zCB0DiRnm6/tnremV8GX/ewBSbiyaDWX2+8zH
 AzQ0hXXhX98UteCdW/+vC7v/59qftT+spmlGWRF8WqkY9v/ZZwZ3kMESQjBGioYQXj3Q3+SR7BB
 FQswweva+CDz0Zg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspam-User: 
X-Stat-Signature: zrd41sumtjaxjg9x95pk9fht1qkmx8qf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC57A80010
X-HE-Tag: 1767890483-664629
X-HE-Meta: U2FsdGVkX19KjqBa2GLWl9ehpxwPu8cGqjVoRGQS4sYHVfO/X2S+j6yAgUztN32XA8OeiwYnxQyUM1E89fmGEzBZ3pGVJ5hUw1c5JGnqCsVYj95nCUDU88bWVgM3YcfQoKmlx8nzwKtAFWXDazTtlt4y7DDEa7CGLgCFd+JR0fenhqZpZeLldVLarIsPW3Swqq1FDAKMDMT6pLCoXPCM+oBhP+14hf/jXPEprc0tMUxjpKqJzLGLNDoG7S6YvRKOnR5vsvR4kDfOmUGdPdMIMnkyJykgZWLTvAd3o/cUcRhJCTkhQFrhcvUDKmmHKi0Gkx+uHuWMfkWlbZkdaqJk9c2c7jB718H2VQLfpD+FbWTiL4Khq9N4HYecrxzZxm3peePy3Nk8nr8sJ9RfyOjJ4sI1mloFID5fHvuKXfzoeFccb45L5qseN8eKWVXlX1Nao65N+p4Ec5Jh6aQpg7FcbRE/bQOB8K2Ds7EhgI2tRZYgk2Udju2wEmChNq9VcF/IwEDbAYjrXIqBidA5ikaN7A3r7dVa6tx/kfpRnnxFoVa2e+0uRMvdEpdkSY2WkMJXtPpACmWF7OtcJn28ONzSHmII6ZkTNXuIi4Ke6mi3zjlQpTblx0YVs/mGYKyY+ZaEUzjErVV8EhCY38NkmD/QNu07Gyze5F9N8qCY+qm6YVx2y71GeT4k7wGxlXIRuAS0X+x4WwHaC+Sx7q56H0q7zmpUrmdIAbJp1DF8CdVx1si+DGuhTbl/Nm1YydDTQWZVsoljuR2QoAYB6/5NY1/qrCLTLV0N7lfI29EWY2R3xZq4V0U5sTnLfFt4W4RBsgdedEL7yPfulAy9d8m0h2VJgEgW3Ep5hboT7fG9GQXL1KHbEsGjG/PPZHNzHbbvXkAAGldGKpU0qtvO/vG+JOUhTh2uBvUGOfutsN8brEMS1LJTH+MCQbaj36AGeqwVJv5nPkm68aNPqJneUsfda7m
 MJNEYzAl
 tBRwDEgf6IdsMVkmUjcEtvxHdXzlco/6fMJ9UKR6NEXUw8KxTCPDhactK/WteO0cAAsuD9NvpkG7yPC9hLUdRpXy0MeZ8uZRr3+S4gOit2/Gz5zFou59gyCnJ+AGPRpWbQsqAR0GA/193m7hTT12veH4037fECC+SdLOHJJxkFbZl0f/TxJHh79b3Ynmge2Y0tOQr1SeasVV1lCPsDyViy5AcAUboj3gRbDBPwMMJ/zfuK7C0hMRQ1cQ7QYtMGbJttLrYpxSzHAQeX3rgKxmdYDDA3XtNRGSW5XhtP+vAvmrzEPcdGIoC++mkSogzp/NeD+hthdg2EWaXugoW6Y3yn90UtFB8sugMXONjXiAZRvAjxle1FSpH6GR/87ZB/ymbPGQABkOJ/kE74xjYSGx1T0pEIrKEXTF3bGh3qoa/YirkR5ty4ocDh/5ZTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track and display the number of kexec boots since the last cold reboot.

This extends the previous kernel release tracking by adding a counter
that increments with each kexec boot. The counter provides visibility
into the kexec chain depth, which is useful for understanding boot
history in production environments.

Add a new property "kexec-count" in KHO FDT alongside the existing
"previous-release" property. The counter is:

 - Initialized to 0 on cold boot (when kho_in is first instantiated)
 - Incremented by 1 on each subsequent kexec
 - Printed alongside the previous kernel release version

The counter is stored as a 32-bit unsigned integer in FDT format.

This is different than counter for LUO, given KHO can be used
independently from LUO.

Also WARN() if KHO_PROP_PREVIOUS_RELEASE doesn't exist, because it
must exist if KHO_PROP_PREVIOUS_RELEASE exists.

Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/kexec_handover.h |  3 +++
 kernel/liveupdate/kexec_handover.c     | 16 +++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index f4f31e8f575b..9c4fc4c6a212 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -87,6 +87,9 @@
 /* The FDT property to track previous kernel (kexec caller) */
 #define KHO_PROP_PREVIOUS_RELEASE "previous-release"
 
+/* The FDT property to track number of kexec counts so far */
+#define KHO_PROP_KEXEC_COUNT "kexec-count"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b2d57868d22f..34cfc98076b8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1248,6 +1248,7 @@ struct kho_in {
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
 	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1319,6 +1320,7 @@ static __init int kho_out_fdt_setup(void)
 {
 	void *root = kho_out.fdt;
 	u64 empty_mem_map = 0;
+	u32 kexec_count;
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
@@ -1329,6 +1331,10 @@ static __init int kho_out_fdt_setup(void)
 			    sizeof(empty_mem_map));
 	err |= fdt_property_string(root, KHO_PROP_PREVIOUS_RELEASE,
 				   init_uts_ns.name.release);
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	kexec_count = kho_in.kexec_count + 1;
+	err |= fdt_property(root, KHO_PROP_KEXEC_COUNT, &kexec_count,
+			    sizeof(kexec_count));
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
 
@@ -1443,15 +1449,23 @@ void __init kho_memory_init(void)
 static int __init kho_print_previous_kernel(const void *fdt)
 {
 	const char *prev_release;
+	const u32 *count_ptr;
 	int len;
 
 	prev_release = fdt_getprop(fdt, 0, KHO_PROP_PREVIOUS_RELEASE, &len);
 	if (!prev_release || len <= 0)
 		return -ENOENT;
 
+	/* Read the kexec count from the previous kernel */
+	count_ptr = fdt_getprop(fdt, 0, KHO_PROP_KEXEC_COUNT, &len);
+	if (WARN_ON(!count_ptr || len != sizeof(u32)))
+		return -ENOENT;
+	kho_in.kexec_count = *count_ptr;
+
 	strscpy(kho_in.previous_release, prev_release,
 		sizeof(kho_in.previous_release));
-	pr_info("exec from: %s\n", kho_in.previous_release);
+	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
+					      kho_in.kexec_count);
 
 	return 0;
 }

-- 
2.47.3


