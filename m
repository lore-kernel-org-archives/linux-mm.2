Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B413C44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE21C6B00A0; Thu,  9 Jul 2026 03:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA4C6B00A1; Thu,  9 Jul 2026 03:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF9E6B00A2; Thu,  9 Jul 2026 03:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E33E6B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:39:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CE51A0408
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:11 +0000 (UTC)
X-FDA: 84968437302.01.F82CFB1
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 50EA8140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:39:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OBzS1Z0h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClBPAUdo6N5oJZIf4ypP10hp87KU/iyoMuoMwuvEL3A=;
	b=iWuYFDJ9iK/YmAOh/AViH7yLd0SVcnHorXwP/X03xbC8Gcx84ESnslAa3x3kd1tdxaxn0G
	xxzQc2ri63IC8MO8RFXlFXhkU/3r9Npg6TXHyZiPWW414wzU4tBk3Puy/HhYJ1a+d0aeC2
	9VXrAskgBGodpThx9ecDqsLHJCqshWc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OBzS1Z0h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582749;
	b=Gd23Slg4q9J2z2Q817ek6vPzm+JAlSSWw01zW8HjoaWiYMl53b7YyJYBx0uS9w1reNV9TP
	N9nGHGaRFUvMlw+2CwydcU/VtPopKlGSBzvFkSwQ7aiakmgFanlNJBnw9Za3r+QyYtOU4e
	k56Tp8Mbi9PC/ahDItm1jTSkxp+zv1g=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84347ad88edso2127993b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582748; x=1784187548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ClBPAUdo6N5oJZIf4ypP10hp87KU/iyoMuoMwuvEL3A=;
        b=OBzS1Z0hdgBazX9T/P2d3CdDlJ/oOslTIEdRr8VotIxQC5dUF+5s9LPGlZgXBSL9jb
         cq5ZBznaBk1xqfoHRMi0KuJbx7GtI2+NNRtJLwWBcjjOasF5+QyasVS57VtEHYh0dkFr
         grT6vnZ4+EjhHx06wyMq09AQDCue8Tf7F9C7drTwStcziCB8gAClT6rfxTKnubgMabAm
         iShV0tpkuAH3kHKPWksD2Um9C0A3b5nQa5TLaCOHK2+4czUNdJRHRH89nYkmTQsR2rQO
         5M1VQSdqC9Amr5MPMQuhgdn0efFkIGNtRAclpzRWfCvg609Lt517FKORxSwg9fLYuQnX
         8d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582748; x=1784187548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ClBPAUdo6N5oJZIf4ypP10hp87KU/iyoMuoMwuvEL3A=;
        b=ZHXkz1nIdp0MBODjjpnY8YJqLNuXtWLTMTY60PYzBtCbZfYYy6Ga8+A/ArGaEZ4lKT
         SFywm81lJqA9FAEeVkxDuLFhbuaTU0rzGeIWQnhSTFWLmZ0ubAso0r2JdBGkXuKHH1xa
         dKQaq4A2OUnNYAJNykcLeUIFQJiKCVQ4TBrBXxjnWzsN2VZvkfbfniQ6DAW9PeLC13Dn
         aEnWbx0S0r6yJebGdzKzLEd8+opHBBTWtOnuF0rSD+gR83G9mxpswm+FkvjlQOMLVw0F
         kkZm3J2QjZlyQRAOP81ySwVuT+2VyMsAI9+jIIJ6NhzuzvlibNQQBGQ0pYkhDlyL8qd+
         jTiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpMnPm80XIXdr/7rBlGIzmPicbRBKOhSPKgp9708XcBGyPgn5/TyGOYjeaNIlHF7Ho1dCLvFBlhCQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0ezG9XTuEr7oT05EGTbZZ7G1VEgVUSgUmyNRLcVB+rqyPPExV
	7ikOa88op9R9K/I81GnCpE52r7V73+ol+tdRfLaKKjrpEikWsEfy08sN
X-Gm-Gg: AfdE7cmK/SkQYQmhNBEUuLjaPl4iRkPPqVjqcBZrJ36+qct4yatXeB8bL76FmA/qhV5
	ZKeRFVieZXX4EOU+0hmWl43Xx0fhqz3mf/CeEjKyltatMuMPZyGDcWyWlKi2oyJQ7s6yQWV91gk
	+KfQ94p+e3d/fBKXwsImdv79+dhRNl0axp9WSoYzb1PtQ/V5XnemLI2mZHSdyGcDAiNXcnuAgYE
	wF0o4eZ0od/oQfuqLjDoyLEfbWooQTRx2O42dOI3aW7qUAdk1n2gv1PkkMPcSFylxQbvRQ4cUL6
	1PC8GCpVeP1eQc/bXh0tcUDBPbwuDxo+9fcT4iDAjdN5y9a0Y0iXeKdi6tK+zJO+Mw+yUVFV5Dy
	cwQbEwbYL2iAM6rftMBnTY7vIDT3za/Y2GpcaNwsuzGDtwHI35bLB8PPVf9rfpAhOgCQ9eze9bP
	s0yv89yEc2/SxpxRlm4468ch9dxjz5gxKSiZM=
X-Received: by 2002:a05:6a00:2e07:b0:847:7f38:27ad with SMTP id d2e1a72fcca58-848438a7e6amr5640848b3a.53.1783582748319;
        Thu, 09 Jul 2026 00:39:08 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:39:07 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v6 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Thu,  9 Jul 2026 15:38:23 +0800
Message-Id: <20260709073823.6643-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50EA8140009
X-Stat-Signature: i1y5hp1ixrni3k78m1rd1p57hgf6afk3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783582749-90087
X-HE-Meta: U2FsdGVkX18qsOYEhWVT9hQtYY2qPwHqArnuVRexrxGHyFoMJveWr/ta3XCXvQA4UW5N46J6iQpL3K9novRmFO/6k5szKw6lffBSvxLIWFskF9MgczCL2EAE4gt4MOywBsI9RZb8HKbIGapGQ+zritCLWINYWbKFsVVR+C7ye9n9vxjs45+q1NR7foEku3PCUH0VqW97JTJd6iRobLdOOPrljXqbGIYZ2fv2VTIHojFtwAGfQ/PGVJ7lGeCXotq4piKZYJTvq4QDYzCpuzzcu5nzKZVLUkQ3z8APn6W6YeOErFFEETIu5ChJS+bRyg7vPr2jvFcFAGU9HNCxKFPC1JBtMd5+zFMlbxSEE8NENuB+MSFdshYUGIGJMS8Az/njXtG4LfYkzhxMvNWrwQkODuHYmlPpcNfIiDw61bd7WJmAae9KqhgOkoLD60Zjy9Fu3u07geDiHD2VLFsfymBSp+4HIoGybDEWruAYRg1w0i2Ea+89NuDzY70CHDmfTT7tfk8epMmPG+1uBHYpVSDJ+QWf/zyDPwXYE8NSwSLqsGQleFycFcbDefB+eJLBbcGF8bfQo2vicosPHyx5L6ZgaNHRNwgq62CVLCm4qOSljrI5E2NA/nBAfZTxQvdtJywvWxT3Q3GVZjGeJRiJQLdiP9wibvcp0h/3KxFldJ5DSbVIhW47Ytn9XP48dQHUdRDIPeHVCN8ynPIxKHZ50hj9LslCWp6+ETDn/3fJZoAS4D143/iPWrYodGlQLHOAzlHE+H1TvcAFK7C8r/tz95osOb0uvk37q/09wAlao3oEoMLcJG32JMkDgB6nhJCFd7tPX05DNV2I0qRu7ZfDswdM73GdcSeE0aXA54kMUnR/uAxlge7xbKCD9owNIVOPSni5lkZZU3Mkfka3iGDiqGdFPOMLuA9y0QTq7K2x+KXidbS10jDA2cNKFQI+fWV6DlKofKRUrkTFS1ks9UHCeNQ
 X/Owr3QN
 2GVBGIgyCMC9pzQCqfsDmHgaxBPpJnOsnxOAJSwaeTaKwHVw5I5gUproZhscTiohIalcd5eLcHx1Vd+pd7WxpzGcv3txtfnriI6SABLCQ+uO9Jsti2nmGwrifg0b9k5iKjqg8zLEo3Oyiz9zj8saXH8mSKWS0Y0rlT/+i2m+3Met4tUyX8fdRtNK6+PKhRepbADP2CpdEqdsXCvm4NK9nkNYmsv4ZgNhWvQlYtRkT3v3FNlRB3o+C2rzWYK+CTw1kFSdVfvEGTaEvga2lwCslTxooZExYwzPiB7oTL8sEx2+ePm0w0pDi7IUNi2RAm8u4/w99Kq1gshSNBnTLW7f50bWn5YW7N3TqTGeQwSuQ61iJDKX3UyBClaiNgW1R/x3NBc96BKFd8z+M9pYo/haT+oGyYkoZ494wl4oIFgn3Hp7ty+Naj4My2kMlW4QiuNkuyDhWMGc+KTK/HeN8iQcUTgw/R4hLkfmfpwoYUhF4ixwz0YEroxW6Dp4HzEJc01QrLQQQYAYZrM6cbRyt7sla+0ma1JjidBVjdOe71dOGSnysJi2JK8hPi4LZkeWG+sXi9CHGsYJSqxzpNZXlEY/VKDUw1HQLhbxCKTPQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries. We do not expect any significant overhead for
this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index db0492151ad08..2ac805cdf18ad 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3314,6 +3314,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
@@ -3626,6 +3634,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, pgprot_t prot, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3664,7 +3696,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


