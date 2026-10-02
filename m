Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C14ECA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4CA6B00A1; Fri,  2 Oct 2026 05:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E386B00A2; Fri,  2 Oct 2026 05:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D201C6B00A4; Fri,  2 Oct 2026 05:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3E16B00A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A52AA689D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:57 +0000 (UTC)
X-FDA: 85277116554.01.17448DC
Received: from mail-pj2-f34.google.com (mail-pj2-f34.google.com [74.125.227.162])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A57AC0008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEsFTjpy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.162 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr+lcidngyc0ulTQrlYku4smM8GtiOinATZrrJ6f6Ao=;
	b=eFWc4QOL+PNdn5SrOaCpq+KCbLe7G7lc0GqxlB5VHnXIGn3SWZqblA0Rip08X5ODBTWjFy
	laZmu1xEYf5oZLy90pWdSFzFbedDCxQR8qiSd5WebmX23jnDxtaqcNl5WNalSLt/PbEa7u
	ZjX5nulS3061Ck+qkU31IMq5TjEukm0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEsFTjpy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.162 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932255;
	b=fYexqbX9Sy8DWCCd+gB1nrSqwqeuUgW/8ryv0XnTSrJagPFP9rdtCMVVF0Qhps6JeCpnnL
	J1wYgrquDIgrAYAemEMeIrNZVzpLqh/dAWa50wwcSujb95t8AR2fh9beMdfwQgdIFLJHjQ
	ChXXj+gt44aetALa+TGy+KJbMQewbW0=
Received: by mail-pj2-f34.google.com with SMTP id d9443c01a7336-2d747eb79f7so33798995ad.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932254; x=1791537054; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nr+lcidngyc0ulTQrlYku4smM8GtiOinATZrrJ6f6Ao=;
        b=lEsFTjpys8/FTku6Kl9M2kmZh49t2njeu2N7Uf98/ooX7kScig+oOWcIE70N8zxFBM
         1wO9rct0ZD37ztiW56aS1DgsaN8XVv/jc88pZzHjFLJD5iTXkv6eVtS4NPECJYtS4pCy
         AfjePWXoIR6dHDJlIP23POOwnzEqALd4iK2D7qxk81AKjR1ANAYIIHYxyI8I4ksrQplS
         SWJPG18I91uW27uO9UW6VEfZh904kuI4teSJ9/ixrzM+A4E3gGB68wHregD9QIQySgK1
         ku/Fnqi0nfcGdhqh+q6rTjXUcG/kEUUsW+m6jDcbWKMU1J4othXDadQkk8VEoXgOUQki
         47ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932254; x=1791537054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nr+lcidngyc0ulTQrlYku4smM8GtiOinATZrrJ6f6Ao=;
        b=VatO21OqlSkNAWKHlMHmA7WKuqpmvqM7eBAFYS7VN0par9LO+JqFd3rEIMGqEZkNFX
         bB4balaNWpvkRrtYiopUGArwopc+kqeRmKKNFm+3MnRXTMK9labkwSbKMkFkmt38mnek
         FDGjxl6eU6wKTrbGfkwawC2GBX1Fixpx4ltzrsfkQ9/vUAClqrI5y5T3JForTpN8oOgM
         ws3iXYoNglA/onV2LnhkQK4x8EqDpNvLtv1U6HudBCb3kLqFA494P7ef6Cpa03aS67n1
         4lISE+EUsKY8pmZKn1Ew0ZzpbAwGUzmqTap5isec+th93jhffPX6oWgY3XSJjaPM7J1i
         ZYdQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9oFMzmizVFcpOVEMhVePeol0ioyuGoha2y56eaG/ioB+G6fnT2Iyf6ce8iQdBL2sDiEOJs9OroA==@kvack.org
X-Gm-Message-State: AFq9FYIa/SLWuODzTIJ5obQ1zuX3w5ZZAeoxwuQJJXiU0d5UpzhCd91P
	jofdZN0ygG/Gv3qzZsXCZJfh0Z4jGXoPHZN+kOVz20LXhNXy4ALxIXhMCnDLVVGg
X-Gm-Gg: AYBFou0/whp6G+aIOyRie+uFux8COrJDTiPWVbIktnN08zoM3LBCn4VSK6agqloFQqP
	PHnPWVuYC+XoYAzGLQyRjd1n81I6SH43twp2HY6z3eQ5UdIH5NEZlO6muJoVcZNIEA4/8m1kBfI
	klMOzv+7acsCWR49o039rsARxarsToZfA68ad/4YqieuT8IJtLOu93Fl82t+VVYrOQBdgbkDr88
	eKxegTTwdbOpyEXgSTJttilP39sis+QN/RIm/aQrgQ85ohT8EJYRqMc8AnzQUyznHS9EYgXQTo4
	yWBRQEPREv0ovNsASBHVApvdplQtAGzEO9Dt9Gp+0IuHqaVFGuLLsIpPy3Smsj/rF/qFkYLlpO/
	qK++tpG9jqx6uf07Kj9G9XMyipzHdYC0hTYWOFEJg8hBRT4xbCcJn2jTl4N90jbH1PGP0oqUDmo
	/z7SP4wzGSD1X00Ltyl//6Xc/0jIpvREwS+dF2C2TNp87khKaLgGEse34JLRF6qEx3iTLYSnQ5o
	f2TVmEOHNnKo8InE2r7JpC5GTtVpBXE
X-Received: by 2002:a17:902:d98c:b0:2dd:5363:3219 with SMTP id d9443c01a7336-2e49b4e303cmr20733295ad.20.1790932254082;
        Fri, 02 Oct 2026 02:10:54 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:53 -0700 (PDT)
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
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v10 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Fri,  2 Oct 2026 17:09:47 +0800
Message-Id: <20261002090947.869220-11-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ugowa56578asmh3xqu9bh8hmc3copht
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A57AC0008
X-HE-Tag: 1790932255-320740
X-HE-Meta: U2FsdGVkX1/p+u4i7HO7AjQiMMdIip0i+BClg31ECrIgH9EExJNO/oQzQUtmSehg/1bDDuPnZgatdJ8cXcPO/xogg60mLy6eobxBi49RfoXnRfWgojH4N3LCRb3vpiDPwpJ1wmAKvkCwfYI8FEBIoxafyRbHTr3W3Nwdo5h1TBhh7FurieCg7m9quBRZIr4ESIK3SikknkF1h0NyBBmtpLVl2HtLF6IvQWnnj8gY51xnWf4QJ5rAMj2yinrU4hDk9non2ROJlfuhz0GxO7IqP2PmgDYCpxN9TwGPDmLQkSV3MSkixrKQUeg+C9/0AumsPOLvZyDPdRiUzRh8UGD1SJsRwv+CxGaWRwl1PTyo+o5gA7DkAZQseIWEAQiUEX1DM2AimFQ5jnfYT85LLlIQGCmckfwtMYXk371Js7zQZB8TLQHaed1OWaUvwyh1QEsmQo5eQl89SFbET//kYHDO8gi3FSu/JPDosVGSa6FUS5BvFCDO1PVen5KsJZYcS6fzKxC9LSI+ddaMAnptp9vVT3iau2BA/rmeyyYo1TLVYc9ahHcApdpKuo7RNwLLuKCXrxxTCjKr8zSzexQ9bscH2ipCYq5kIvlbRYiRW6MaRs6siqMiVy3muMn8g/vwHu05sRmwJZWB3vvRPlzMEWNDkkfqGn6xr6SsdGQF/3BujsuwBnnWPzm4KWtQe61Co3anJa6blJdrTrLaK0av0NbKWyQYdJp8Mb37yomuI6jYzCKuGx2TZydVuD1EQgTK2MRlgwOumYlm7qdkz88aoj8jZudtVRWxUvH+fTNcKcwJIoJ47kuzv/piVlF9WtqcaBhJCsuDpM2BEO9m4gC/Qw8iIsiig0pGFiysXastdj92mqQGzl4+AXZTNxDSyJooUEaeZNmCzCjVsouJvXdT9jJUJ1mDKgUqus/y6uAX6RtFbE9lmLjFEsUg++y7xT4utfVXvIThdsIrVrz2bf9rQVC
 oiYMshlR
 1WLO6Sn5jCS/h7S4A5OzTeHDZvZIgvfgXx+M8mzu5NHlCGlTMvDnWZSUrtfe017CwN6uXlIK+jXEPCtZTFIjlJWpWxB0Vmd3rSQlvVMf1uDTTCUYGSmos8Mt+sYDpNdiHzPxVbcDOzHyyVdzIFG/eWANJRxNJDKAPnZylVOQjQZoZXkrxapdg7hG7cFWTQ1m4PCZ0MYR4k+RwfKm1YSh/DducPKTNFjT1NWcuL1P2Ofdnmxh/cRvpwvZhzYHHuBIbAcGZiYIbZOHFGTURSAgageipxvz3Z/riLBSC9kyKHqBBeJ4woilEG7bcg7kHBHOyiFDcOGPz64VbmGAANKIp3t8sTiV9mV4LS/YSZ2qc6JFQNSGn68+kY6PIsjv5yztr/JeBTCTnDB4frYqw+rsOV+IJ88AyqkIozfbPF0U4YhCfxZ8CBKRHs1YRAcpJWZ5GLJBDbgHazDZD+ikk10JQSMgVo5GD/zOx+9qk2QiV9gCJF2GCFThc9uY0i97Ij8J8jMk9JetVgffvk/gxtfk5eo4NUoX71xZiSlWgGJs9EKjeNL/eX1GH3fegtDlfniaLJ5FsFTmmuRuJ5EfTLEWTOvT2bWxHmvQsIZaH
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4acd1ec27604b..3555dc3794e4c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3328,6 +3328,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
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
@@ -3655,6 +3663,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
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
@@ -3693,7 +3725,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


