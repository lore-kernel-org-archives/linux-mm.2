Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87231C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED816B00A6; Wed, 23 Sep 2026 02:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6770C6B00A7; Wed, 23 Sep 2026 02:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A886B00A9; Wed, 23 Sep 2026 02:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2932F6B00A6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF584A0716
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:40 +0000 (UTC)
X-FDA: 85244050920.20.A679DFB
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id D37571C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZgTvx0e;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz31YaIUZL0HkPkLOInD8YA56WfSRIuJpUh6x60MqwE=;
	b=g7jd2uffquGnvq7OAgWz2MIJpRoPbo8zUAwZ52VKTfz8BMTAEt2LQX+G5Ie9kvK/hkY0fx
	8p5FWp+BkOcPwMkbERyfwZEnJ/uXCLoQqF2hhFLmULp+fPoPb1lVRP+2aEqtI53yQhrpdd
	qwr+33vguhbfC3hKTQf5RobsGVtkLFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZgTvx0e;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144978;
	b=uquuUHVDl7x/bwjRj58CTCMh39+OBo+SXIRRffH2TXKHM+CCQmEhyieVNFiBIUI+L3Zcbk
	X7fdcRXXKtEn9+122CxgSiX9i9tufWA42jsdjrsfPxOK54nW+JzFfhC++FXdA4s8z2qqan
	jGx1CxS9pYIhn6/GvsXHPTKyN54/+8I=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2db1ca069c8so2800605ad.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144978; x=1790749778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qz31YaIUZL0HkPkLOInD8YA56WfSRIuJpUh6x60MqwE=;
        b=BZgTvx0e+4dacMloD9Ydva2DYtd2lPx2ozr5smv6UsjFkLvVa1NCm7NFG3xNhK1Lc8
         +HZBubkn0PbDj6KCrPLALjVSUG5AdBChplo/Kk5srtTlQZemQpiebGR9sI3VV9IlPZ4j
         Dx//x9AbuLTzP7+UeXrHkSSSvQ8A7A4kyg5N9Dz7LKU2JVuiRUpTcNkvk9Yjt6NDzv0p
         NwJeVez29Is66AQH3HQwtxkPef79n+DIldazhOp7BgLmf4r2my2djRgz68nxGSot4OTx
         hPECDFsTz1JFm5OrP1fNDfYL77/DLkwWJQwYSJpGElcbhmpgFMNrK7taySDHt6NYEvlN
         itMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144978; x=1790749778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qz31YaIUZL0HkPkLOInD8YA56WfSRIuJpUh6x60MqwE=;
        b=sY0vlNOIRujdbqX6qW9jblw/kjE78xJvVtBLXip68vicTnm+6I+nK94beO5Elh8bG2
         frjVOQrnTX9AqkmQwJL4depNVeqmC6HMY738Y6vJWC6v6zuHnS4N4UFVNW7RaYkVvDXE
         xgpT0QwCenWoSAld8INPzifREUm2dH32//wNZAXj7ET3z0sAc2d7DEf131NELln5G5ZH
         CzWyHNPxkkDc54vNMGDDgBUjiWWBSH+oVA+CAdxg4RnN1sb5HxEGiVm6MZkk/dYJovef
         vR32veru3f8waYlZIKP8Pv9Dncgxz3bxc42qQThFs7f2EGpQPSY4CGMUIW+0v0auBSGM
         zXYQ==
X-Forwarded-Encrypted: i=1; AKwUvByINSc7kU7vK0refdDcPbMhnCVHPxJcNR4MERxY/Dcazx7TVUYGiwu8NPtgqQHqyRFFlIR4LoG4iw==@kvack.org
X-Gm-Message-State: AFuF++nsm1fL3zdGceVjCIvHOM535YpM+0xgJfI8gF+dJKex1tN0EhMa
	k7KJj3L1ZvLt6W1eDgChyfljZ7AfDeK/6qRfxXB9XB60om6Nw89YXCRELkSGd/UF
X-Gm-Gg: AYBFou3Pd5WnEkByeIo7++JyhoDDuxbqD7Ni5hiAbIsAIJLgue7XJv9lrYkfW6xXfik
	jJmbIJpaIz0lx9p4Yg+eVHYURzkdyp9jLsyvjzkk95svma7INExB9PRRU1tfrHi6tEa5GriyOns
	4QI7u/JYwBudWOJebH7TehR5b9VkEY1XZJwEgt4glJLZBlTvRLia2/Urbre4PXOKq+/jG7dToXn
	wbywOrwMBOxiySHkm7OrDcenloGk21eJ0b3WVJWcOnmqpIu5yf/bZeS0g5ay8RhARHRFerNrRP7
	0jO07/mVTGMANHeX4VZCfe3ySLlpZPUvBPgRARPdGrWzwsKCOjpn55tFlzYC34VrvExBw037KSP
	K9hHf66FPw7ZxraLfxvGilhwJ/tGWqly0XV5VoFrW0Oj7Rx0MYuuy4QFVWQAQPyMaR+ilAgb81X
	oAKnVOJa1I1m15c257nillU/zTWmusRQPqRLZOEty4HrH51nfb5MgqBSUWsP5xG30mqbB40LU+O
	F134RH0P3IWrhrBErOHGA==
X-Received: by 2002:a17:902:d483:b0:2dd:c053:c20b with SMTP id d9443c01a7336-2df69ddf0cbmr15391165ad.39.1790144977728;
        Tue, 22 Sep 2026 23:29:37 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:37 -0700 (PDT)
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
Subject: [PATCH v9 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Wed, 23 Sep 2026 14:28:32 +0800
Message-Id: <20260923062832.479455-11-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D37571C0004
X-Rspam-User: 
X-Stat-Signature: amta98qox8mamx7kwfb9awyxoifgzmx4
X-HE-Tag: 1790144978-671976
X-HE-Meta: U2FsdGVkX18u7+Hrq/utlH7dwZbnD6LbPZyoHKj4n/gTv1miqqL6kadhMUavsBySoV2E3p+drECJeFjEp9mA/plU4e6y49SyTpblwp7osLg0/cNOXJUbIUbSNVUr2ge6HvFEw/nug3y6vd9k67AFIz357jQdjFztFivGLXpChW/xw2NF1ceqa9Mg9zjaWE8HmDzyMPGaGXXGTomxisPrnc25srn3+1TvuxT/DVwAoqpHGw6BCNTAjX8eaHc82FZk9sCK4JbeOOCmsGrbYeyxjC3IfF0DqNXq7LdNfU6pysix8G0Qs4DetLayrQandgokt+a5W5+LiJK/5QBD07fBu3cYhNU84+THaTemdu1cyePtB3t19XUnH6LaUSsTXSHSH4DJQg+7eIWK9mAhVZkNVqxJQmzmo3n+Gf9UF1VBf67hP7+dizyeTYfCIVcxVA6VIl+jNbQTzTgmS/RnvCocm2nnipnN9tpSSTZQMMta48TWQehLJ9YGwlTyn4yb3KXSkSeZHmeiXv7GcGYYk1K9ruAOygv85zWcsCfGhi2kOJuthxgLkJsxxDF7v9QUq3yAp6uQYOc2bZNaLgzDmu9/YrCNvtZwVe3sYvr8Pbd3L/31u+BWAxrMbFK4/RvpR40YvMof5NLXnzSSIEXAqwTHZPpCcf6O38BS4b8vIOx6of8pXT/tsVQYzIJ4SWOd0BVxmi/m5IJM0BaS02NRtP9tQyFbQOQnKUhuw2+yg/IaS+L4/2tGoODu3dfIIRQ/UJiEDMbMoW9wVQUAHinU2HQHxKvUxr8kmhwQZ12jt21cwiDb858JHNhAAfv+7TrClzNbaVneeHUE3FeZV19b50swAQpxDtUYRWbrOEODJgRouxGLRrdxaLMBHqykRLpEx/aY6SS3BnZAtsUhjv60GmsJpN84xgkvuX05BPwjgQBPn6jqhsYsuQR67E60V/r0iVbwYznuDvqi1gbo0i5oVh5
 AualpP2e
 I+iI3jsz7TnwyuWl/nD4LWsIsq6yefoHgrNydMEl8Sqkb0Bwe0meaNeVETJkJd5FkdVh9iQoKLnYSmEKzx+tszOZnPg1Z+t0ZVbGtWnKiFdsqXTUVzkbERAGmPmoq7gWKaOT7bgenTrKNq3PYlkD43TxMRE7wcYOj6Zb930hGmW03uQ2FhsilVojE7+d8XFzzBbVSsigXmY3nGPR1x/QMy3zNUvex50L6Bfplx2R3ezoxeKaaQ2P2fua1HxJYSp8hLvuSnBzGGc6WrqfgRdQITEP2QgpeuzUqdAnaztQ705DrysoUHp9BGtoDRQMtMCCV0Np/KqfCLDh+P+BMqCwF3Iw6v0+DZb+MiBtNIX/x0omWSC1DCogf44tcchnLvaB+KS4zBJh3B6uWUxCJDR2E8NfL5v13PTSgEq28mTw2QKZZ8v8GLajTL3sgxSh/7VuSHv+Ga9iLmbZf0gLbfX3zAjLN8lmUKhVUN8aj+97vv6S4zM9mWgbI1SWyHhFcfQa0fT78rxLvxKIiD8ptWizzXBWaCf9dDFO00rEYeqFzjl2xtNKGsRNyzfN6bn5J0bk0y2UwqEuQKHqzdFUYadvJQv7HqZmq4btvpLhR
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
index 37cddb7f45a4f..1a3b191885024 100644
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


