Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88065D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5DE6B0012; Mon, 15 Dec 2025 04:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC716B0022; Mon, 15 Dec 2025 04:06:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2E16B0023; Mon, 15 Dec 2025 04:06:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C99206B0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:06:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 730AF5D952
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:27 +0000 (UTC)
X-FDA: 84221124414.22.7A0CC54
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 753DB1C0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Luzz+Lu6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789585; a=rsa-sha256;
	cv=none;
	b=be/KtI4YAr1i/jTZEvFMkiiSssOwLxqK6ocq2tvnKsT1eH4ZRPIOfDO2/LoPEiHnmhrfVY
	hPIfy3u9nW8irdAtIcyDC4wMRofSUk10uFzzAxe1fE6rBu5CSTuTL+/CKscdVhyUl7FNJ9
	NNg3KzuMTK/NdcDRrmjpLt+hWa+hWKM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Luzz+Lu6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmcIU9qlUpZvwHLYQ6LJ9BQcVZiKr95F6LsU889+bmM=;
	b=m67VZ9aFJzXoxOiijwD8pBo/Bi/qdc8Re39nCWfiRIkvqX/OnMGMiNG9XgNlIRqXe6iSN9
	JMiP6mMZbYJEsP4mT7Hg2Kd8tQfAvwWyvy61nnhzXY5hfHjMrrGuwGNEB+cWxjj4eJi0Ll
	L5tjbKYd4oj1mASln720eCySD0IIWH8=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso3432760b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765789584; x=1766394384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmcIU9qlUpZvwHLYQ6LJ9BQcVZiKr95F6LsU889+bmM=;
        b=Luzz+Lu6rlVUUBaZcKg4C2jzWVYOZnR/LPHgMUsZjCgi7skpTFzQ3f0I5eNVXSWgr+
         S5gqorAGgke7xmDIbWj3+KP2BkVoZq0roBGJFcusZM+zeDO0fyHhhz54YxUtnLkGmIiw
         xVAgXF7mWjLKrEuebtWOhP+hOR6ZVwinzKvq+STYJ03lpYrmJPjSsuxo/wwbplG9JSQO
         QzfaMEJSxhlHD9N5R9AT3BJvhZNg9FTwgyiXPuDkw1KGubqhqRAiPKH9rCUnvwB3qrVZ
         btyHvSsnAiuc9JT5TcylZtswjvjyv1YXLbT1gyW9tLTvGFSgUsOLK5eKJYtkXruSWaFK
         f1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765789584; x=1766394384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NmcIU9qlUpZvwHLYQ6LJ9BQcVZiKr95F6LsU889+bmM=;
        b=e3IYV4Np8Cy+6UwuEBkqL73Jv/WXcfeFTbPwZlOXC7CoDNrDvhpAne7ixE2SvJqpEJ
         75a1V0fU9oqmJgs0S3wG3pvYIICBC+NcMJe74LK+OJmkA7Ad6KEP9QutWjwDvE0oU8He
         JGZHbL/+Jby+vVdgTC6itVeNZ3BNOWCebPfjQCtifa80zwWpBWK0jLC/0e0iebw1U7dq
         Y44GL4C2tIPkzy3ILfSiPUzA5wvolDZ7jBmgl19zX1VjTGva/fgy/Eoifoxanzy3a9F1
         rYf0tPzW7I5czHMFPBIsLPe9brGpeG4PiJAppYqCgn+dRYsmc5lLm8AF7yXGuzl1RtjI
         3Fsw==
X-Forwarded-Encrypted: i=1; AJvYcCXVLmfqHnxBudN6hsKtShu7tbgtzg74ohsNA6et42jkEJEPTNWv1qjWiw6yj2B+G4PKBDvNc8SmOg==@kvack.org
X-Gm-Message-State: AOJu0YyeoMi92g8dsR2/zZWmSt/8Ybjl/MBgpRpIB2470EdX2mayjMAe
	hVc95HNcuIKpCsLP6b7hYpnkh1REiJlv7SgsVZAujs45T9rp3Y8xJzoG
X-Gm-Gg: AY/fxX6zlhapRAouQBmfh3lGMEkdmMwgOLc0ZaqUUG4mvwdw2zTtx2N+qCz1dlBG1GZ
	dHXMNK+MlVI17zUB7vkJmBOkMU1ffocZ30qZJMo7QhaPDDfiNZGstx1a3blLaFojzZyptyzwj7W
	5QPfXO2t07MJHiw6c9XcKeCmsYZgvZ7U+qZbhIRqwwfaPYdHT2+POeJ4+RvUHHJMh3LLLhrZszx
	RM8olupkH/KDrkMCON9gNLtqYuK0rrvtzZZCBJRw9FDBk49zrwX2v7jOI5pyOc0TBkWP49bWSb4
	2Mj3INH+gTBeAvCywsol6M4xwFKpEdz8F3reahZZx11JdqNiYROx12ghn8Py1Ptd+0VwZYqZ2MF
	/Lt1z+nGqPpjjyQoPS/SvW72auNSlBshZQDMNJ3chlIA6/LHB0ost9GeTraVlYJB9ycBKTPw7Tu
	9a+zoxEg8ewkEmX0jdWweCl09EHscQpg==
X-Google-Smtp-Source: AGHT+IEPI+nTV1vhiglExDtSpRez29RRQ8Wci1gwL6qRWUlWpm/mQuVAr7V1HihJUsx0PLEtt8CIig==
X-Received: by 2002:a05:6a00:3697:b0:7b2:2d85:ae53 with SMTP id d2e1a72fcca58-7f66744661fmr9423954b3a.8.1765789584199;
        Mon, 15 Dec 2025 01:06:24 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a40sm11993160b3a.46.2025.12.15.01.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:06:23 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	npache@redhat.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
Date: Mon, 15 Dec 2025 17:04:18 +0800
Message-ID: <20251215090419.174418-4-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215090419.174418-1-yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 753DB1C0012
X-Stat-Signature: 76f3nznyj7zk9fx5o1z7ytwahjkg7rgz
X-Rspam-User: 
X-HE-Tag: 1765789585-459578
X-HE-Meta: U2FsdGVkX1/zbRaCMTTate15r86oWM3vBtIbmHLBoOemknWHyQZuXsbZEIAsamAbw0gYpAb1bCnOiAT1+Rv6dl2MnT2fazCoXB+4SS61Pz/5R3T3u/2IxqRfhVfkKbqyJmVAxVL5xWZ6Ql199SrNEl8NRiKflX+zRDKqMVcVevBxsS7taoMJ54dHHDX8BuOuFDD5j3iyLI/QwmZKpuCWF7aPZY9Bbt1c5nP22Y8amAGu0Id8Rl+qPHI4cKmzvAUYUYCdsE0reHhAHZsZ1N68Jh9R0rphOtQwCF150UEdy4JyPh2tSYJ9kryILamDMVsjPuFmo5pKoix/ME3H0UFKYcOM7bgnwYDtiOLxcTyzG93QQsTssRUyDIS5lVJiuk4Lb/C7nwWvdsG6HP886Ur+0CQYsbBl4xfv3cz/lyUbYZjBtnAHPAzXFyBzvNMWPaIDnygoXZxxHj1sPArAudWRsQx8Z/JybvABXgLpNcdVeCeeBnopjohPthsdaaxjA8IeeP1gPQvUleBm6kjQzKFddjmJJHtT0GMK6UBFsv6Rks2DLrSI4PEthXSORegvhtPi3WE2Ngim5JvVFIUM8QiLSAdyIsMcjRtnadmlya+Y29Kdai4hUP9yI/SMsIwyQwb5nCgx5cuHrm2vv2R54lHKePjkf6FC8Ms7uJhb10oxooY6nwKnFmlAn4GTQX74ZkMOT1eJraAwnUpI/W5s/OgSePhlOd+qRqUcs4/mjasM5c/8SHEI7E+A51+cZxPBVOaze6aqXfyq8MdgPFXNaKFGRjwJr0qCzwCIm2gE+Rf8UgfX5I6/RmnH7KBCfBogp71TaImRixb3nZu0xmZoK2+gN/rFFwlCTdrK47HhqGzIR2bgOHzZzP2DSwGrmgyWEVDqEHmOw4jXC/IrEWR66YbvRroM+WTWH9oVF0aelcfltCviHKkJylFtivdfaEaPZX1d1BzK2N6WZqzJJT67EWq
 6WVNnqrj
 8w7WHdghJjhMyNZz+LKquaWAIIvWDH13HOIyV7gSqCsFUZcmmGRL6mJUPWc2P/A0keNElrbopv8UkUX2nNPBdfMqG8xdWKAEfFbt0HOpReUj9R6T8s5DKodUTNAR+q0tvIPnMi9oqiYXWSim5kvySPRWvdiKVa/lsbTKBJ8sBcVW9xMEEntiagSJfDTdkHTIcbdjyQ/VmsSDj5Tv2ySPo6g9zEFXoOf9zQg8MrZUu2KYCrVGBgvVGA1LJ7EqL2mkE1Wgin6oy+WU20djFMCM3hHuI9nEjAiQPjKVk+mH+YgTssqlAntC9JdSaR+oacNLScXYGEhovGQczPxi+BFl+xVAuhc4gXQknlOjAvvKTAFN/coAaHIzIEd1II0C64pYF6DyUi9o3Jor127uutlt6ZpmivpwaRdSyCuMSb6XzghToMwHD0md8//7ij3+eS3RdR59MEO2fdE5lX5DryOtnMsLfnkaOGqR7zUvMvqTcC3ZOdoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

So if the user has explicitly informed us via MADV_COLD/FREE that this
memory is cold or will be freed, it is appropriate for khugepaged to
scan it only at the latest possible moment, thereby avoiding unnecessary
scan and collapse operations to reducing CPU wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
| cycles per access   |  4.91         |  2.07         | -57.84% |
| Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
| dTLB-load-misses    |  288966432    |  1292908      | -99.55% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.23         |  2.12         | -70.68% |
| Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
| dTLB-load-misses    |  237406497    |  3189194      | -98.66% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/linux/khugepaged.h |  1 +
 mm/khugepaged.c            | 14 ++++++++++++++
 mm/madvise.c               |  3 +++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..726e99de84e9 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -15,6 +15,7 @@ extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
+void khugepaged_move_tail(struct mm_struct *mm);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1ec1af5be3c8..91836dda2015 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -468,6 +468,20 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 	}
 }
 
+void khugepaged_move_tail(struct mm_struct *mm)
+{
+	struct mm_slot *slot;
+
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, mm))
+		return;
+
+	spin_lock(&khugepaged_mm_lock);
+	slot = mm_slot_lookup(mm_slots_hash, mm);
+	if (slot && khugepaged_scan.mm_slot != slot)
+		list_move_tail(&slot->mm_node, &khugepaged_scan.mm_head);
+	spin_unlock(&khugepaged_mm_lock);
+}
+
 void __khugepaged_exit(struct mm_struct *mm)
 {
 	struct mm_slot *slot;
diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..3f9ca7af2c82 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -608,6 +608,8 @@ static long madvise_cold(struct madvise_behavior *madv_behavior)
 	madvise_cold_page_range(&tlb, madv_behavior);
 	tlb_finish_mmu(&tlb);
 
+	khugepaged_move_tail(vma->vm_mm);
+
 	return 0;
 }
 
@@ -835,6 +837,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 			&walk_ops, tlb);
 	tlb_end_vma(tlb, vma);
 	mmu_notifier_invalidate_range_end(&range);
+	khugepaged_move_tail(mm);
 	return 0;
 }
 
-- 
2.51.0


