Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BE5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1726B00AC; Mon,  6 Jul 2026 04:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9CB6B00AD; Mon,  6 Jul 2026 04:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE7F6B00AE; Mon,  6 Jul 2026 04:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F07B36B00AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 773DB1C2B61
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:24 +0000 (UTC)
X-FDA: 84957715248.15.21402CE
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD646100005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FX7DJmWY;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZH7fYg3BL+IXLhasZWhU5qOs2NRzPPtU/E+Uj4YHFoU=;
	b=im7Tnn1J5t+dqPKCIP/T3GkOFXJtcFXweCqsErf4uIGE2oYcIgq1w9DzI7z4PDigR9tuvu
	PYDKlMuaUDojjwnu5MigvCNn8bsJ49O+Dkd7fG5Z2hifKusQ/ocB8CjcjQ1/RBqpGNcD3/
	jqJOOcsMrOImSxOVEYT11ShsrIT2bEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327462;
	b=aU4544FeuCLdjXq8/nJWeveaiI49RoVbEYG1stsG0b9qb6kNh97yBznV1bfT0Jb2ogUyMe
	iV67Yc0lYlgAMEqXsBhay5PVhUZpbSNJY9VrAPf4NMKaIv86FqaQIbNRNkPWun+oqyvRQf
	g76XrMfzepdMBhaVJ7+1EJhjui5NcvY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FX7DJmWY;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-381ed661712so2319277a91.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327462; x=1783932262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZH7fYg3BL+IXLhasZWhU5qOs2NRzPPtU/E+Uj4YHFoU=;
        b=FX7DJmWYWK1mCG3G8AlgdynsOolM6lRFHQla82xfhgiG+7Nv+0U0B5VCZ1hlDG1akO
         5MxMdJ49lCb4cmGT6VPGz0m1leiYPy+I/d9pC2HWrDrzfZdluruKCUgV8hvWxC0Sn10A
         93K3mXkJf0Xx58iG2Mi99Tkqe9Jz48zs43pvzeYI2bjB+5ExaNHjPeS8HM1vJACflzyW
         RP14PXxM1+rilNWtOelYwVttWEHYrUZvL4Dhk4CLqR2mh4KBq7kPOjkhMGcWU8AvDq1U
         G3IUk4+XGORN7+Dlzc+0yvpmhLG7cCkOKoJdjd3qdwCeDLMqlULisjBNGpFjU99fhZLS
         ZdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327462; x=1783932262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZH7fYg3BL+IXLhasZWhU5qOs2NRzPPtU/E+Uj4YHFoU=;
        b=cgsDx9AcRnj37HrPVK0NXsikuXFGYEdK+bpJCFGLlNfu/gg4KIDIw9fDWbuWaYuWy2
         R1KXGZVEhwpLuSeAK0Oi/+9O1EeOF0V3ncEEJnuetPPxX1y9ylgsX+hz79xUbfrwSEoI
         VO6On4usxswY/xP6Q1Fthe19i8WhMNfTEWha5RQjEsdLCGD50Dclm4VR3OYBFyuKSpQ1
         ooxWc3B6DXarzef9NF/qfRjLMBuHYlzidhh8t4NcwJOWelwtbWN2zXysQ9g4VVIHAt80
         JppqyjQr498OWjAtFxQFrY9SnipputS4WJrofxanIQf9kT1wixm6qLlb/ZRjutUA0a6F
         khaQ==
X-Forwarded-Encrypted: i=1; AHgh+RrNU+ZH0A1N57XddGEGBKVcsMXBItaZ4DWLMTqaVplK1FXDpxy7sSRVfatikM9UE2mmpICeNvwpng==@kvack.org
X-Gm-Message-State: AOJu0Yy26RaWgaVaalRVveyZi6g1hZijAkPZUGGyqPJkU3VBcUCHGfHi
	qeXBm7ia1gP+JTah3jrmntMUb4CoZ1mbhf1h0io5sFW57htVcaavkVCh
X-Gm-Gg: AfdE7cl0D0nHhN0/ASLSI4SqOauhnK6OPULbhmb9hLSykme3pCBRC/payWpvs83XTcT
	hFSJ4/+K2eiCov63Qs9z4SZzNjix+ZRqOMoGOqPrUq+ABdWkIj7ohvO1aS3K/ia/rIXNYFTWA3X
	5btbedNNVj3r7e/uBv5dGAKceA5HdsqPpFcYwVKV42h30oZOY6Fd8rZM+wfYnnsECl3h9hpo3bb
	n7vW/QiKgqgoj4imSHnbhARf1Euem1XwUNUbMn3jj9NE/Ce3XLNWpaf2TWQPYXlgZNQu7rAUE3y
	UPo+z+lV7GhtQjnR/696matPARaRUTVKDFRd/1uiZdfbyQInFvMSg7+3IOch7urVC5AErakD/1d
	F6U11Bh6vgwrZ3Nn8gX/oPMM+hlI9Lj27dh6TgXT/Y7OM6rBWjEPXyzRUfRxIdmNS/fSaRE2mQK
	rbGnDOiwrfD2jn73hACTqqhcstGHGXS78nGXU=
X-Received: by 2002:a17:90b:5544:b0:37e:1c8f:3dff with SMTP id 98e67ed59e1d1-382808b3fd5mr9240351a91.11.1783327461600;
        Mon, 06 Jul 2026 01:44:21 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:44:21 -0700 (PDT)
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
	baohua@kernel.org,
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v5 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Mon,  6 Jul 2026 16:42:32 +0800
Message-Id: <20260706084232.177786-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD646100005
X-Stat-Signature: 734zbu4ogd9hqozh8x8pyyt84m6nkaru
X-HE-Tag: 1783327462-631958
X-HE-Meta: U2FsdGVkX19SvGXQBsV3NihJeFI6D1jR99Mhp0xhX701zlQ+bO2vVAN7vQ+Px58USM76TcTNXtPsZZSg7n9PBK55NiKV0CzOSfYN5xUK2CuK6x2WPMetdt6VSuUOVlK6/w8ktM5hLmlwEVtxvJPWEhonqvZEjQ/W/wbnAWDkuxusTL4tY2DCIk8phn27IaZxH5K8aqPaaLSNj4iOe4wJPTeIfCnZ6XlTue3nwss2b+Kq8A2+iO7FmE1RxGbkH15GtE7Bz4WBhGss7Pk42DEsF1VFuX1x3DA9izTqz2QGjG2iHyHwgANBG3VhpnN95LRSGcYFH9m4h4vNhRAruEXPBgutZJAx1F9p+73NfEfOMDizBk8/hK7t9agunGFPBfjNBWZuWy1uc9iOI8gRPqwV715ewj9z+KeM2u08tWPeP8eYe0JEBiVyXkfixRScym1EGP2Ihxg7cUsa02Qdqg/io+MLqaPceyq6iDnqkB3HkFNUp5sufYtVe+tPptqN1zIlAODFe4FMwaNjeOE4uWv1XZ2uZAIxr/dem1PGXFPJeMnAsRYxkrGdM8LufcT/4IGhNjTV7RgmxYnP/MYphJxcH9kHCzkPirz2bK4zo4ZivAhw+Rmi46wQon6zVBkj6aKCEuY134oJA78/DrDRYJGuEJ2G/SA4jXkBPug0VDUvJIdCCtqZ2iqRQodDEVcAPkgUbyYv/LHm5seJY4/PKOVnmkcPI/n7cHg2hK06XlzbvWAHp14Kzlbr06qZwiLkEhDc/Es1XNeOtgfLpMT4s0u203GXWICUYt83y+hoboIS0k3gHUhmGWj7VFOoebSZ09BGfLrBrewWMNBOBnqfrnZWe2XgfqbumrAJYuaQHiv1C96utf8jQESvMUuAL6gFfSwcaINklHZe6bI0OobYH5OOYqaAVB6jgksjoMNzO2z6CexTbMaeybRuMo4PAgcYSVwSX+8iF7+kTffYqfEGasW
 IhOPiIJT
 t1H+EroQpKOIFFtPphvZjc+YT7SYm7fINZTgpv9eDpvIGTyF0EBZpLtnsDohXVEGkhFgkWUbAX9xpiTRlf7qpU1t6eDKk7Vt1dIAFfhJWjcKLb5moGFMWU+p+638KSG16hKx6ndRCww1GFEHdFX02zeULdHLjszoW247vVQ55q3ZfL6G3vDcgha868Qlox38m7Vss4dLhVJGbkyPEXFfVIgl50Bv3XJ6kCic68YfMbTGBhLkeCfdp06do0H9H8zrt4qFRMFU8Pn6LN1aDP3xmJJrdQeYsPUSV/E9DwQRbFLjNOOmMkVP58ByMy93XbSS75GYmgcaBNibHCqqIghTpER3ltkuwRmt+tmyBLEQLUBy/NNJsz8nbtbpVO0vLwN28dnUNkdXNwQ7HPsXdcRqtwfWmN0e3LyfXA46oJCxwieJE67gC4zkCO1NMeKDq6V/cn4YzHiJiXze4EA2pCFNaLYPlQf8UeLZkFfJGm2jq9UJiGnuLlHMSaB3khAU52MJor3a4fEALk4pRknBUEiOX8RCnhc70+SbCgG1t
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


