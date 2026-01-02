Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E38CFA374B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07836B0092; Fri,  2 Jan 2026 09:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1396B008C; Fri,  2 Jan 2026 09:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81A66B0092; Fri,  2 Jan 2026 09:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACE8A6B008A
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:53:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 748871A8DAB
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:48 +0000 (UTC)
X-FDA: 84287318136.20.36DAFA9
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 80D4A1C000D
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767365626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4jFm0T13XSPTZvu12KUE1F2bt+65MnaHKDG0zzV+nX8=;
	b=ufM6cvqqkMymrpgdVyGMmraei8TzBGhyj93/0Z91BRyvA5xgXurodZhjszYxI3PJT9xpfq
	pbmtgDeAxk2PN6rHBRnzMFJGLVDx0jVvPL0MUjgSJv3RDbbsqjwcx4iCP+8mZP7roVJ4Qs
	Cbc46xtOr9d628BiSs22An5PmqEnqTE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767365626; a=rsa-sha256;
	cv=none;
	b=MQv29Bgjf5zZyhTj6Vfa8YJL5hSKRK4pzRTpXTPpP14hPdI96DvCSF2dq+7lGES5PUJxrG
	fBDXPd+sMrpWvQ38kh+qqUT3NFwNAEeYP3hfrfSEMERt3OIS92vz0qvaXKNWyBzHuElt+e
	8XMNSAlcQrrg0kadl/twEXbum01BWV0=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-455a461ab6eso3648490b6e.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 06:53:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767365625; x=1767970425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4jFm0T13XSPTZvu12KUE1F2bt+65MnaHKDG0zzV+nX8=;
        b=EDi3uZjzFNKEfmAlGCyMkLpNZlUwz7aGe/zL5NXnzon3RBmdFI0GvxAEpMpmyoMX65
         Y9D44vxuCZZEmtFopGFqzH7V8gn2osKvQ/ApmNXXR0mFzt0c6QUa8Z/991bVbJ45BeH4
         wyAnxqq5Gl5LvqpQH28sikKZcved9lbWiYXOkgeLv+vOEG7g0/mLwfqs6AOqr2smEFCJ
         +xuy4JTYJSXwEqrb0vOdRR8rYYN8PHtHGxYziUt+5EgfhFiWGiCltEY5YFSU0JhVoL96
         cEBGX9mALFSrXQkOM2j8WmVGk0k2bugVQkzWJkctimzv+iPIacpN7A0XKWUGBh95uU5G
         ioTA==
X-Forwarded-Encrypted: i=1; AJvYcCUYeSna/b3EZX9YLt4VhKlJDyr83fpGU0pod1gEg8xbWaY1OHz/XXjoXvw3QiIys+ncyRQWTF+54Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0GJHPd/SZnKTp4ygzlYs60D3HOU5NgLIogzzwaDAfeqtF7hsd
	cNXscaHxIv3vgf15uioLM/+7DNfmOojBiwzcKzxUmKcgqsKnDY8NS3DR
X-Gm-Gg: AY/fxX6XflXEG4is/gS1VzgEcWogkJkdIOZkAb3VuiDx1xgjs5PHuOIfZXkfHXoLGxn
	+nw3gnft3UdO4YvV6r/D0wdvf+sfiUCbBPmyjNE0+wTJOyIPKwqIPwAdqWHtDIXP1yEcHx7xJld
	8P22PRJ/4MQz9zvaXvX3HuPTm6qOh1zDFJPvoYjzlz6fCZUtVSBHZY3LbhjWkgYMY1K6vS/sKVU
	vdxIf1mH+Aqi1Rm/OydpuvEI1KYOsxBQY08E0NERzyVtlSSuQ/7EwBD9LXhKHOxEYafiWknwgxo
	9e/IjY7t01HQU3ERBoCVWTTNKigLDA8bWj7TTnPLaEGBodKiC+EZXTFldiGpsi9VNh9SzRRAIJz
	/Q7Ugttz/nSC7fS2NK6Dtzgzkj3BAevGcTQhB2GQbJg13QMimygeRoCVP9f4jiNv0Ia5tXu4Wib
	1hfqrh12z5apLb8w==
X-Google-Smtp-Source: AGHT+IGmJX/gWScL9DW7qlBrngJY3793niWXqd+psddu0novXBDKwZolnXT6vOxbAgd6Px9WJeU2HA==
X-Received: by 2002:a05:6808:1247:b0:450:b3a:539e with SMTP id 5614622812f47-457b1f09e02mr17787125b6e.28.1767365625515;
        Fri, 02 Jan 2026 06:53:45 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-457b3cc0928sm19854424b6e.10.2026.01.02.06.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:53:45 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Fri, 02 Jan 2026 06:53:24 -0800
Subject: [PATCH v2 2/2] kexec: history: track kexec boot counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
In-Reply-To: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3495; i=leitao@debian.org;
 h=from:subject:message-id; bh=1J/J5ij0+LfyJIZQr+aeQQR9ouWDsomWRVfj1KaYkEk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpV9v1LR8K2jVcyo0Xngo00G/NBInYvKssHASJN
 f9h88ed14OJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaVfb9QAKCRA1o5Of/Hh3
 bUQtD/0brf946ihzUuvEQ6ksdzQPT41UQBAtTG3YPKf+kVRegfC4XfpErJI7CFo0Kwa6aI99E64
 QeEd8RMWgVejsfvhMBPHudOp3prj7N6bM9a23ZykDNrIOlo5wTuBKLu/lfFTdOsfC72nVYRdmMM
 fqm2+ze34QevvPttBHCnFk4vAm0SaZ/szA8A83eg0FCPqVpUl+Ap5e3iCdzH4SWElMiP8+KAUnD
 ByzlQDuSUkVgwEFzeMrQ7qqzOiGJj2ckyLkgOLrHQSEVUiG36OXaUVbRINc0pc9wpAkLth+JSZC
 T4F0eU3f9WbrDTK/2xbI4XhvKiNelMCLSrQfS6SjA+ETWtiOYfDv9uIGhrx8lEBnYHKu70E7PQr
 4DcCoxOCBmYGv/Ig4U77BW/lR5iieC28cSQST8GNaI1v1lELkHGEHZsQHOm2nQ+h+7hs8JYW5tI
 DsjmCSqVe+Ckfp3ZzQ7nfgSKb7quOJ+zrvrlFpwoEVsKns3QWmZES6NYw2pyAVTTiPvpTLn+UGP
 YqG6RQTd0oZinBTrFfcGALM7M4W8wmnBWi1a0DZXYYO6nskdklOAUVBT9knmR1QOZ0qVmpCuLat
 HS/3LWKSyvzIjC6id9lKy8HKxhfEj9+Br2oWjqXim0XVLEN560iWsilfAyty3cw8KvrBZG9pOu1
 MJl+dUxNnXe2YAQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80D4A1C000D
X-Stat-Signature: a3dz5k1se1a17hodya341imx8m5d78ef
X-Rspam-User: 
X-HE-Tag: 1767365626-968645
X-HE-Meta: U2FsdGVkX18Nm9qmr8cN0KGtJDiqwPRcn5++hBhLtorBjoNzMHY/2q71HRF3/YndDplM562+zeop+uhxdcR8KPosouaGD89+cmOMX6AXceQ7nQZDSgZx6F+mIgZUs7fqgMu3ovN/OtNJmpYaYp46zwbIOI8YnBFdulUYjsFpUHx6ORIOH7Q+IjuQs3YAhJ/aJXrrboxsw7zayH1MASXWAUwDb8Lv2UzErhbV8PafM+PRmu8r9JG6Lk396QXAimEas1TanmjVA6CtX/FniB334zyqJjYsESpgFDKBKuR3WhBy+dL03OhlMREH+pwLm+aCUa12PqoYpdvsW4NXy6PoWBx70bW7raAJFrEK4fU8OG1PtreKYPX762K8JAw47+VRcntscO8Slqbi7aDck2pDnQLD18c3V2D9booctCEhYOEI0Ydu5uZ5n7pP69oK0ukejW+LuKsFhivkEVU+Aoiom2BiPacI5iDJ/zknvRVBwMi00TICqpF64fMQLeD/tHJrpqWPDSe8SRaYndVwRlqjjC2XojiPBA8qY+6Pm4ejF33C50oWcFG9m3kkPkM59K34E5hTeGQ648ERFOXVxf3VUEiRt4CjF0OE7j/qzxf3u2zCWOH8eC0LtPgn/E3McG4P1bXHWqufuUhqKkql8HUtTeq02MHchmjWPmacr8avMZHR6B0cBptqoYJbKXa8tHpotRgH9Tm6smp5oyV28h9JUSJTa1N93JK2Hms/mAJPM3dq1+jeJdOvJe5Xpy0+slmySFFOrStpilGt5zvChaVEwr+5golX8wQDZPE5dLmIII1mlgTyLKYtQNuEVBp9a8GmDFVMilsH+oJUwDQFpqUBDI7TdX+PWCJ3nB4cZyJ3PY4totAjwu0zv0pC/Qhd3r3kku5TDaf8zorWk4LPhKo/1KWe1CsjAnGhG5DFDCEQwdsZByyLZq+Dkovrieh6nbyEf/K9IDVwleK9Q26/iyS
 i5SffyS5
 XCapJHYOxQIsVwIJBG7HORQlmFn+uOKEloNVV3xb9ikTJ6dk7Cs1gmyNvpehgsu6umFqq48CFTpsJV5ov12Z+MzVQiE0+Qmi1M2Jd/YXqJ5CkULmvDln0dBvJEY4peqnrao+KnNjoC+FbdvHKpGbFfIjIqvOLPJSjmI0Ub0qIM/ep6gB2FVDf8y5juxW5OV4W7ZYv0jnFur1jQ0tAY+uEhv+VZLQsfYbeOztMTpyo1LDBl14Wbq+v/Qk7QICCLipskWAdKgWHX9YduRnb0jRv1kVisM8FM+lZvSPlym8LJNTOf/wZhPxyCaOU0vJJ6ge22cdu958YiCxbMncAvU3EU2xlAEHP6z0A+IZmGwp0X3eM0ndKR2eVzaVOLX90z0VSJqW8oowLL/eOgcnufct0Kb9X05LV563tUMGLR5RgxqRxC3MfI21y8jF+sPPcisl23WHE3768dtNL4DZ96UhspLgXwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track and display the number of kexec boots since the last cold reboot
when CONFIG_KEXEC_HISTORY is enabled.

This extends the previous kernel release tracking feature by adding
a counter that increments with each kexec boot. The counter provides
visibility into the kexec chain depth, which is useful for understanding
boot history in production environments.

Add a new property, "kexec-count" in KHO FDT alongside the existing
"previous-release" property. The counter is:

 - Initialized to 0 when kho_in is instantiated.
 - Incremented by 1 on each subsequent kexec.
 - Printed alongside the previous kernel release version.

The counter is stored as a 32-bit unsigned integer in FDT format and is
only active when CONFIG_KEXEC_HISTORY is enabled.

Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 06d99627bb3c..fe5a2c5c4c86 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -38,6 +38,7 @@
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
 #define PROP_PREVIOUS_RELEASE "previous-release"
+#define PROP_KEXEC_COUNT "kexec-count"
 
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
@@ -1257,6 +1258,7 @@ struct kho_in {
 	phys_addr_t scratch_phys;
 #ifdef CONFIG_KEXEC_HISTORY
 	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 #endif
 	struct kho_debugfs dbg;
 };
@@ -1330,6 +1332,9 @@ static __init int kho_out_fdt_setup(void)
 	void *root = kho_out.fdt;
 	u64 empty_mem_map = 0;
 	int err;
+#ifdef CONFIG_KEXEC_HISTORY
+	u32 kexec_count;
+#endif
 
 	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
@@ -1340,6 +1345,10 @@ static __init int kho_out_fdt_setup(void)
 #ifdef CONFIG_KEXEC_HISTORY
 	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
 				   init_uts_ns.name.release);
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	kexec_count = cpu_to_fdt32(kho_in.kexec_count + 1);
+	err |= fdt_property(root, PROP_KEXEC_COUNT, &kexec_count,
+			    sizeof(kexec_count));
 #endif
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
@@ -1468,6 +1477,7 @@ void __init kho_memory_init(void)
 static void __init kho_print_previous_kernel(const void *fdt)
 {
 	const char *prev_release;
+	const u32 *count_ptr;
 	int len;
 
 	prev_release = fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len);
@@ -1476,8 +1486,19 @@ static void __init kho_print_previous_kernel(const void *fdt)
 
 	strscpy(kho_in.previous_release, prev_release,
 		sizeof(kho_in.previous_release));
-	pr_info("This kernel was kexec'ed from kernel release: %s\n",
-		kho_in.previous_release);
+
+	/* Read the kexec count from the previous kernel */
+	count_ptr = fdt_getprop(fdt, 0, PROP_KEXEC_COUNT, &len);
+	if (WARN_ON_ONCE(!count_ptr || len <= 0))
+		/*
+		 * PROP_KEXEC_COUNT should exist if PROP_PREVIOUS_RELEASE
+		 * exists.
+		 */
+		return;
+	kho_in.kexec_count = fdt32_to_cpu(*count_ptr);
+
+	pr_info("This kernel was kexec'ed from kernel release: %s (kexec count: %u)\n",
+		kho_in.previous_release, kho_in.kexec_count);
 }
 #else
 static void __init kho_print_previous_kernel(const void *fdt) { }

-- 
2.47.3


