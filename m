Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B122ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B578E0006; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA53D8E0005; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AD68E0007; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5388E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19775C08C0
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:07:00 +0000 (UTC)
X-FDA: 83947756200.01.7238870
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A14B180005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:06:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2BXvhDl;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759280818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7KDLDg+Dl3qWFtDxuCx7fnLK9u41qYIlWveNKnTJTds=;
	b=q4rajupiu0+oFQm+UVOYArI8aS5pmNbzY0o6d8VUV5iSCB5VPZdhMiFwQYp6QH5q6yl7oo
	JVnzIZgUeIjhz7Zr3z497dAFswcobJtyocg8ZIMkOOxfcWo/IWUhL5CJi6BzXybcS14R8U
	blhh4MWHtxwmN5lwDnnG9cFiEMF+Cgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759280818; a=rsa-sha256;
	cv=none;
	b=7idnjPYicy27AXPfGTRHsbYDNxA+Xc7aO3MoSqA2mPJLNNK8Iz6KPPnlA8PLYfFD4L1oX7
	A9ert1hUm4Vyvis8jDmPnMA+2RMGED49zAmZZ5v+WveFLTilQeDcZAuEgy3pQkvV/W+n1R
	/6HJWuam/FiptJ7jP3xq+WT0VwnakFM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2BXvhDl;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3e9d633b78so117068166b.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759280817; x=1759885617; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7KDLDg+Dl3qWFtDxuCx7fnLK9u41qYIlWveNKnTJTds=;
        b=P2BXvhDlkhQKKES8ONWyOC2CJl/Xcq6wvcZCpAzG0jl5qYBTdE4R+SxhY6UFA6dyVk
         YwokIu1v9raBoCimmLQ7i1AdKcX/cvF+9B5eHF4NX9TQGGm3IvFr8j9kPUwzwAYkPorP
         ahxHEQgy17dTfbZmZwFU+90MMHzGPsmIgUICIyOT3MB3uJP163QyUZr1XYeogq2uoUeP
         8f24DoDGVdMgQWbjdruI+svbT21GLR1PpohOQ8sd8115OqrAANavZJRX7WkKT78GhUBF
         JL46jySFAwSUqD1NBynxBNkGU7eKgrXQ5WV4mck9jPrn7SUgcFmXctB5l3oOONBfKlXp
         pHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759280817; x=1759885617;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7KDLDg+Dl3qWFtDxuCx7fnLK9u41qYIlWveNKnTJTds=;
        b=vxLxuE1bzFEh8IPc85Y0+XdcPkKyw50xiNh/WhGIlckvvY5/naePYronsNbGyhCnON
         3dgmwArn7KM0aBUaeNSv1UiDivWRPfztKiHXTjJQ1kGl7avgG9+wnbvOLXpOUDahIOEx
         KdayS0b7xzMPA1xgGWVboLgUzFnAWl7w/KfGFUHd8HpSAG5zvkomSjjhAnookeMdfvFl
         SGLWxGMrjF+iotrW9806guDVcN7ULvqe8GnYRWWxOo6rIShCE/wveqBn1NAasPluak9Y
         HMUjvjlElT50WhYiII6cmjHo2mqPuhdVKmRAPUjtmk0OmY2b5Q+gKMpw2jmJjGhD80dt
         Nlvg==
X-Gm-Message-State: AOJu0YzkudAXBHq2cnCy191t65c6cXRU0qCg7ESBogon/SqbHALqXK/U
	/s9cRqaf74Yvf14VwUD/dZo9raw6rYwTYRPemKA+XkTnfLARqM2P5sj2
X-Gm-Gg: ASbGncsqGakl4KwrRFXWCtMOhFRpuxC88E2IpYU6Rt+MqGw7FMPZfShf7iKqxUpXTaY
	nkjp8kC4Y10/8tKIXHg0Ci4Cbk+jkfa6zJIl0SKUcdVGQNT1ook4Uq3Ga5HAphb4WFdUAl15XLN
	m23tGZ9n3TNCrz2VC1bGTMaWMWMsxilm6kAm3l6ssxpfMTNY7lqf4z7dbAxoNA57cDLptSNBFj5
	i8HXs23FFdGEifp1HEpudBoSeLiT5oC0SliA3m5jfdyd+US/opuceeaXXl9Bvyiu1vWQlmHQgQc
	PerEur52aMazDrp3xDvMLlvc/7HFMeHOxh2FT0tPJXMZmLCh+gC2ed55QeHraKuaPP5wEc22vgV
	1k4c1KDrPAzgsDdLSKCUeorbgGQKhqNEnBfcSjWmeUc52JP5jbQ==
X-Google-Smtp-Source: AGHT+IEAm+pXXiKYd964wuSo/X8tRj88Tn9PVg1wbxvhKDxwF1x7LCvJcy3hLAzXXalpwnyoBTfCOA==
X-Received: by 2002:a17:907:94c7:b0:b3f:493c:aa with SMTP id a640c23a62f3a-b41356214fcmr739143866b.7.1759280816434;
        Tue, 30 Sep 2025 18:06:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a96977sm1258180066b.93.2025.09.30.18.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Sep 2025 18:06:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [Patch mm-stable-fixup 1/2] mm/ksm: don't call mm_slot_entry() when the slot is NULL
Date: Wed,  1 Oct 2025 01:06:50 +0000
Message-Id: <20251001010651.10543-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251001010651.10543-1-richard.weiyang@gmail.com>
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A14B180005
X-Stat-Signature: spb8b4tuwxbzypgfcfp4q3x8z59awisf
X-Rspam-User: 
X-HE-Tag: 1759280818-424090
X-HE-Meta: U2FsdGVkX1+It4brRtuNvyzSJI31UcHYDZPLU2s9VGZAGEyi4jshTb6i0NDVy55uFRjxCFrXijR3ahPlE7czBzckvX9I4wui0CL/JcSYUk5vCUqNr3ecaXdjkmNfZeduokZE6rwSg5pmsnPUk/WP3Bsxrva/f5+tccZ0tLLhMYQdUklhOwI/UDEvBmrgv8jMTqt3IHvpHDYMH76Tf6VtubZs0NPMID7lmuZ+mkfq06nvqHcJRiML2WP05RMrWGgHgUowOsrBWhRwu59VXiq6EtlnLIsICef/mg/dUA9ye7x0/93s4+Krp6P+1pNf8zZTcj2Xm26px1GC9iF4XCqe+DegolbLdvE4vPd8Zlrn31lI6I8XcVDPUQQT4OVe/BcpMQa3gXBsLWoI2/oa2GX7MDnOJsBbNL61ojo0pT1HOuKB7zb25NJY8hQ/7e8EP+D2gD6f1zNLtz/cSQlVAGn8RMG3xRc0ThaxaTe5sfE+hWu5ly9iOrflU4u0I7gtX7fzJyHClYbwRdMIE1ORgNbiT2/JhOyDXY21Y+FQq1ApZAfjrCF/txl99c7C30zyWijcy4fPdNyywlK46YjacW5JVoH/zvS99h3MhJCBDg6Dm+szI18L1Ryj1ebzPE4oEJn1B6zdK3NfPuS6mWCHI7n5T3PmvANxQpoL8RRJzvnXi/JWKhEBU7TehUWweb0YgHv0HkmScvvloo86L4106NYqVE6kIIv9TDRiZCbuidYhD4eXuVwewVf0cAIXRrvOxN2qCWPEfx4pEZhf3AWYk3ynzjKaQCzQX73LemLkZ38JP+oun2eLH/t+f7Ky/fUMjus2ZucEXmImvoB1tS1sn0kcFxbHwTEFLaUsOQP60SwOJuxUTDqv2KECRG/rg3WELiSw3kJ7/i/Z/O21j+SS5NHf149U7NGfIqJHxuOOfJDjudYJ1KSL4uSYm/j65sXZGXdg/ALTwvL0UAxKwg1Y63c
 torH3Tti
 4rKtu4lmmCNbSP8STknf5lwVj5pb/nbebIb+CKC1/8Uc+vrOmvt0+Gx2EO5LpF1C7n+upAb1sXwQOyo/tZCS57EsSzLf9gWDUjHIlfI/1pwGcXJkbRTbJ0A5aidYmdlyrxMfd6MHfQ1fsGA3KYpcdGSXm7M/jrd1Nf+JGEuYsbaM9dY+roA4p0GHdH0Z9Msw3UVbOl93ysDQlu8InoDw5h0DmL4p+35v/vZrN3teLZXp/6e3PHpgvYL50kqaTL2JMIk9J89BCd1tONXd4FhfDdliBgFFpc+7ylwLwtmlTbn8V9x2XFDMueIbiBklH7Fa/YVcsX01ZS091NbdOCGoSzCnIll+sVw5AalLoc47Mje3lMgrY0fSQzyMuXtZd1q8emBuuNXHePm03Sl6XykEpgQtnHnkxVpGsb2cJsm4yF/dz1tcUPKWhwGmPKcxMzPTaofulNDWKvhuhb24/GrgfkAyVTWy18Y5kZPw7MuZ6Pz3W5mWAFqckB8n/ZeIFTJiqQF44qP0X8bOPANwQbJe6aC9A/Kc2f1s44uflqlOLpM6LWODsRt+uGSv3f7E5YJ4/xV3P8jVZqxvC0cnFtE4cNQkbdeIl6YDhqK7kOehAhm0M5AoPl8//Rvb9UI8X/JXWK5ojOR+ETPEdFdjZhc2qv4MuCUkJHdK2jHCXv9ucotuy99PTXO8WJ+YUJlQZz2lEnI/wCQYBc31Q/IimXaYOjn5RmDqTA1gjE++9RPJuzYjqXCgFE3RmhvsxD75xnqc/O336LYBzytbJDAtivnP6LPnToFiDmOsPtuV2zXQE7RRlx0Yd/VAI2qPvsMdhzN5eR9gPt/4qOMpUtPOOigDwZs4GaKQdgquytGcv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally.
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, only call mm_slot_entry()
when we have a valid slot.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/ksm.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 04019a15b25d..7bc726b50b2f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,19 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	if (slot) {
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		if (ksm_scan.mm_slot != mm_slot) {
-			if (!mm_slot->rmap_list) {
-				hash_del(&slot->hash);
-				list_del(&slot->mm_node);
-				easy_to_free = 1;
-			} else {
-				list_move(&slot->mm_node,
-					  &ksm_scan.mm_slot->slot.mm_node);
-			}
-		}
+	if (!slot)
+		goto unlock;
+	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	if (ksm_scan.mm_slot == mm_slot)
+		goto unlock;
+	if (!mm_slot->rmap_list) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		easy_to_free = 1;
+	} else {
+		list_move(&slot->mm_node,
+			  &ksm_scan.mm_slot->slot.mm_node);
 	}
+unlock:
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
-- 
2.34.1


