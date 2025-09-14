Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC70CA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CC28E0008; Sun, 14 Sep 2025 10:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDDB8E0001; Sun, 14 Sep 2025 10:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC508E0008; Sun, 14 Sep 2025 10:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A78A48E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:38:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4275B58876
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:14 +0000 (UTC)
X-FDA: 83888110908.07.4147AB2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4BCDA140007
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757860692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dc2ToHGvqgetretFJ5TWWHKSy1o0O/m6boNyeBXRweQ=;
	b=WKZa9lTPc+tWaU28dnHS20Z/E52J8cGzskLZidG0zEdYDrVcX0ouPXKbXxyjJMjKFDdF/J
	azKE2xHxaKf1c3XiFOWCVcqBVDwJiwP0B2hsmvcKouN0ljTC3aJx/inXYhyE1SdYM9DA1E
	mK9Iu1JXLl1UzlyU5Rqkqxo4socShjI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757860692; a=rsa-sha256;
	cv=none;
	b=uRF0qXBuycEe1aLRjvS5mrepu0A+w3e4RikE/wT/FSWQDvmEQHi2neMnDqWPiTXMUJcddx
	LTgkUCUQpKHur2OolYYrEOpRPWdbTDicjCDmKMotFBgymUAK8OfVXZQlAaqC53jJbRP55j
	nbt6s229K58wA+XQxUmIeUFJRw3KlmY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24cb39fbd90so28446475ad.3
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757860691; x=1758465491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc2ToHGvqgetretFJ5TWWHKSy1o0O/m6boNyeBXRweQ=;
        b=D8PR17WxFa2M5irz33l/Q2ua5ZyMrtvhDU7dUOe+P29Z2QQoM4Q/Td0fuExGv5onHu
         lUAD8DjPaa26BaUzSII+mPClc2BjTJS4PNJQUPI6HHwY7DfAXhi7PIJW1ITDBFFmftFB
         e6bRMoDSJdFkMwRON8y/5eD9kQSA7gDJhSyt+V9tKhY3MvFZ7QpJzyz+tAJ6QA9st3CN
         elDYAKc4YmgFP1zzp9B85+tyMRw4u3P1CzhEKMKqYkXdU9zc0u57xtMg1GS7FHikTrLP
         HXiLT6pG/65soTOF6Eb6P5jRvtgKeAP61QzBjPm+oprOBTWkp0cCoSZvFdE4Lkd3NoeU
         zhDg==
X-Forwarded-Encrypted: i=1; AJvYcCVLo71KPuBZtB3wvM5nsPT0pOPByHSrwajCX9TVS8Q+OvNcwstV8sf4YovtXmopzO5Amr3w61fbZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9j9X0m9VG170Ptdhs8oTWQtv1y92m9tpUpUQtiMYdoXNt0dHc
	swR1fif3o2nOPKlbHfN42VEBmtl3uQac9rm9xulSOnL0AEJ/YTjR5SGF
X-Gm-Gg: ASbGncu+tW+SNNUhQr3/Rvv7UJfn2dV7dcfw1L61a4ZFXwlzQNd0rW3BkbC41qERExh
	S00wAeBjWBimWbHyZjOIWqWwR+kf0/hdcYujQmifydacAz3hG7iQHtWfgX0GZq4EImKpDTWH2TY
	+/IGmHYHdva19sSriF54ZHJOdgNZuj/8PhkphWWR7TQA5IJCc+VH+s2QiCikeiXz0X6ralk0JIF
	xs6WJP7nUJCDIb3QdvBxnUZ2cwkIU6ULcWli2mpkdih24OOKTm1KZv6RQa5PBbASeibv2ha/V3Z
	+F9UgIKUf4Jqr0oBygvTjH5+r8TSsMAYJ5kWjbm90M/N9e1rgPJEAlkeHbKuLlBkqm9ntnH02cH
	wL0lysSCyWmQ=
X-Google-Smtp-Source: AGHT+IEr2DMCdCdoOyIsL92HGAQ+R3HSje6j05Zrq3wRDfxpMSO6h+wpKjwZO7jrA4WHFzd1zkhsiQ==
X-Received: by 2002:a17:902:ce90:b0:264:4e4a:904e with SMTP id d9443c01a7336-2644e4a928bmr38635145ad.23.1757860691127;
        Sun, 14 Sep 2025 07:38:11 -0700 (PDT)
Received: from localhost.localdomain ([2a11:3:200::10b2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b0219f9sm102571545ad.123.2025.09.14.07.38.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Sep 2025 07:38:10 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in khugepaged_scan_mm_slot()
Date: Sun, 14 Sep 2025 22:35:45 +0800
Message-ID: <20250914143547.27687-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250914143547.27687-1-lance.yang@linux.dev>
References: <20250914143547.27687-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BCDA140007
X-Stat-Signature: k8rf3h8kqbgceuq7niddsx7zfogmcqcn
X-HE-Tag: 1757860692-314158
X-HE-Meta: U2FsdGVkX1+J9Ldrhu5bxOafjTVgreLgDb1W9sTwJIKP9aPpIye0wuSQXOdiphQjqgEnCUHoeP/9f2RR++r8rLCrIdDJmDjykUil5bz23VI5vPPpY7YCq3y1nUEnL7gyZoFQdlmbZiaBPwJrXpFNkcnDfLTyCbj606KXJnPFrJqxZS5xjWe0YHvDHIV/FaYMu1i3/Yw9Y9M7ZMMJEOswVCJeY4oNHS3yos3j6GxtvJFGFOxX5K98A/RWS8CuOXYbHcTotL9v51GY4pxKP5+WA3Gw6kzHd+Dfjeyx4LtYM2nSTeVhm0XUne5zX/8YDyz6s5Yo62RrmuMelRnx2t8xTbBmbIjlZmM30ZCQjFj8o5+FU2L3crNmxpsxUD4XMSH/8d25JPBXdoaal49MwMVxAxsinKNo3/gDQqOBw/FGuzaGlUmeWQ/NU9QXluCMyOmKjXX5u0OW5/JIUibk3uT6A9Mir+ipCw6pTozDiJ7o32ANsifgbjZ334MxBHAs7o79daWZaiSYKnTpQ6T0x6YSe9c5MM5TApuMDaKZUpfDN2A9kMVvynqGg7uOuDkZaHZV36FHjxd5azrPVYnD9mm8VaUvY9+FYnJrh7GiP+jTHuovaYYp3v+lQr/67lTn0hKrGsi41qbevG6VTYHLm36iG9i/k6vw2ffSzmmonjq+9BAKXL2QWFy+HJN3jaebznnHifJ5UczqbWeToEl9v7DvfBwBLD8QUgp/9PopNV1+x7Aap7SqEITdNL8iOx/1Fd7Aa2Y/afIPflQta1xchy3HRCApG1PmskHmUN97E/SMleZsD8ji1/ax+CA4Bdkqvo8VBd6fC1U69L2CCfw3Nm7wr1oVdVkOOl+A0J0zSs0diTkRvSHtt3hEB8OdxxkSGZLLGjJLWj3XSUSshUVN7ZrLEdv1fweW5KsZiHjJl775X9R3YrkUNVBudAoXQMWZsV+Y7W49aGjfxXvYYWf97vQ
 RpPZ9yY+
 /mp202bS0IWgtifyq9rwHYiAYnO/+m7daE1ubrlj72RiBsCPy9WBMBPXnFJiuOs/nHCaxAIoKWdZexTfNmj8bEP4xcWJG5oINGcwlTftO4HTyzRUkG4UlBeUk2JjEJnc3DVE0e00bWck2iPxQeP6QQdykl4gV7qCypsYBjUdvkx+5S3XvIJuX8Sh9qGwc0pTkDxOqggBoiopbjDqcawap03607poKo94GXilmYNueX859GpwMM0O/Ofh+rQi/e0Mcf5mPWFwLvRrQjeVW9uFGHG/hXzHxmPaUueBKl9UPh4iu4Yz8/CwOFtbCjU1775x/3OtU3AiXIP4LJKTYynUa72IYGwjMGSnvLuoKQkWBrjmGhSnC4enEtrbZxGm51Y8L3P8hO0YzbfRVh150UngjbUzXphJK8lyopUDdAxBfiovts/O3yfeb95hn3R/dORezIHSKybGjXMVFmTv0HPeRb/sNSPsHuHx4Tb/GfUOsM3P2ZV8rqzJTNyntdK0edxClRoTmfhuzQzYTYtrwD6ymDf1snQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
mlocked VMAs should not be touched.

Note that the only other user of the VM_NO_KHUGEPAGED mask is
 __thp_vma_allowable_orders(), which is also used by the MADV_COLLAPSE
path. Since MADV_COLLAPSE has different rules (e.g., for mlocked VMAs), we
cannot simply make the shared mask stricter as that would break it.

So, we also introduce a new VM_NO_THP_COLLAPSE mask for that helper,
leaving the stricter checks to be applied only within the khugepaged path
itself.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/mm.h |  6 +++++-
 mm/huge_memory.c   |  2 +-
 mm/khugepaged.c    | 14 +++++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index be3e6fb4d0db..cb54d94b2343 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -505,7 +505,11 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
 
 /* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
+#define VM_NO_KHUGEPAGED \
+	(VM_SPECIAL | VM_HUGETLB | VM_LOCKED_MASK | VM_NOHUGEPAGE)
+
+/* This mask prevents VMA from being collapsed by any THP path */
+#define VM_NO_THP_COLLAPSE	(VM_SPECIAL | VM_HUGETLB)
 
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d6fc669e11c1..2e91526a037f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -134,7 +134,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * Must be checked after dax since some dax mappings may have
 	 * VM_MIXEDMAP set.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && (vm_flags & VM_NO_THP_COLLAPSE))
 		return 0;
 
 	/*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7c5ff1b23e93..e54f99bb0b57 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -345,6 +345,17 @@ struct attribute_group khugepaged_attr_group = {
 };
 #endif /* CONFIG_SYSFS */
 
+/**
+ * khugepaged_should_scan_vma - check if a VMA is a candidate for collapse
+ * @vm_flags: The flags of the VMA to check.
+ *
+ * Returns: true if the VMA should be scanned by khugepaged, false otherwise.
+ */
+static inline bool khugepaged_should_scan_vma(vm_flags_t vm_flags)
+{
+	return !(vm_flags & VM_NO_KHUGEPAGED);
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -2443,7 +2454,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!khugepaged_should_scan_vma(vma->vm_flags) ||
+		    !thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
-- 
2.49.0


