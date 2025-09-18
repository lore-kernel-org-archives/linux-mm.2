Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1121CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DEFB8E00B1; Thu, 18 Sep 2025 01:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5598E0093; Thu, 18 Sep 2025 01:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB7D8E00B1; Thu, 18 Sep 2025 01:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDC18E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:04:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B270E1603F0
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:48 +0000 (UTC)
X-FDA: 83901181056.19.E4FB15D
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id DAC991A0002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aO4ZLiBPFlHh7Ygo8g3PnYlJq/wmpc5eSQsMTQaitaI=;
	b=tsGBHIm12nCc20ws/M1QfiJInFWwDWrrAFvwN9kblF92bNiCxAmIYaDW6lISF6/7yKhCcv
	FcrH7DvDpC3/2+pHHltBoXgNIbqpPJNa915qmqdEh0Fyrky/5M2zLeNXK0Q7xbov7ejM4B
	CpLJDQcFv7wuxoNdppJ8BWyVAmFp6To=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171887; a=rsa-sha256;
	cv=none;
	b=PvqkruNPhNPQidXU6WjioMvw9NkLprbMXhZ3DZwbLmD9Wvjc9R7BCI4f6LcMlbfnKHvu/0
	N5sXp3WeTqxGuR7Ji/WjRXrf4VPPgFh0dNiGXbq5OJXqHDjtZJRgvn8a4L7MS6MeEAZo5K
	mzhRDMc8KXjxQmQblaGanLG4IkqACcI=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ec4d6ba0cdso328199f8f.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758171885; x=1758776685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aO4ZLiBPFlHh7Ygo8g3PnYlJq/wmpc5eSQsMTQaitaI=;
        b=IeAhdel54jVXbXlJ8QI7L1P6oZtvhT7P+vkz17+EW96J03hZl2LFRjOftXmdAg5Eej
         /F7/p7QmoSyazJVCnBC80s/ocmdNIKg0eO0GfrcZAzQ7KBW+u5E04HuY/eDIFEDny3Tj
         jgb5QQu6Q6vu1WfPLkjMA5KVty7sQuqZ73ITeFyaZx8TXMeE+FxjJOnlC2cDdyZROYPA
         Kqa6El+KabVMDVgn7CgzXBSel7kqaXSQtI7qrp+ZYjK5zigkw3YFPa6bKEwpeiFO5gAc
         HBRpNRwLel1x4nU1OOJAbapgjoJlb1YTu2uVksAlZGtRc0WNQKLPfjR6LAC8h27KV4hO
         pxGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlzsPLpZTx11Dx4tviBUcYVszQP6qd4M8/8dAmI4uCZ/IPD2taUkLhjv+jKbGLaekirFTrbKVYvw==@kvack.org
X-Gm-Message-State: AOJu0YxEGac/iZEjR66iIYxZLJLoURASxWxjb5bCHis4mks51t69OriW
	/rWJu6jLjdACQwlU8S5JXgFnoRw7R+apzR4XeviBbbucMfPQVanvRYQI
X-Gm-Gg: ASbGnctBXEfHLpwe3CH8Q/+5T/5hNtx6Q+vBZXxNfNRskDIihg2KAQNo4/zYPGlC107
	FyXodALjOsnDveDDVTRHwL2VIofYuoKxr2pl7xhFSKXPHvYedhWNdT5BsMBnFn0BVbW74zFxMao
	1hvTMjjJV+SNXyZqWlzB7MLPlNbBa6wQ/N+8/MRm4t1rHsFyR5Rt6/Ut5BNudhTVAXNJ0PhOThB
	7LQ5CUkZlIj2i7fXvVVX89c/1HHSBPCZm1UEGH5jPuOMTKLRVTemyPUwxLvAMlzGYsvdo9flMTN
	jeqAn940ZiVEflU2jS+zUyzccgjivVCjWi3CxwZbvad31KbQyQHTKq9wxbJzbPofuStrJbGdVhP
	8rYpO7/FQ1mlYnlXkw0G65Ai1p6OkwdaSehjlyg==
X-Google-Smtp-Source: AGHT+IFdC514onBUMagLeO2d/t3qyVfivw2gBfhVFamlNKWcdrfcQDzJVUxOlBsSi0KZGLvniYQVcw==
X-Received: by 2002:a05:6000:26cf:b0:3e7:45c7:828e with SMTP id ffacd0b85a97d-3ecdfa079f7mr4188775f8f.33.1758171885260;
        Wed, 17 Sep 2025 22:04:45 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407aebsm1994409f8f.14.2025.09.17.22.04.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Sep 2025 22:04:45 -0700 (PDT)
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
	kirill@shutemov.name,
	hughd@google.com,
	mpenttil@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 1/2] mm: make is_guard_pte_marker() available for hugepage collapse
Date: Thu, 18 Sep 2025 13:04:30 +0800
Message-ID: <20250918050431.36855-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250918050431.36855-1-lance.yang@linux.dev>
References: <20250918050431.36855-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: schh9ko4pokg8k1dd4k3ywdt9gp4ki8u
X-Rspam-User: 
X-Rspamd-Queue-Id: DAC991A0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758171886-263786
X-HE-Meta: U2FsdGVkX18nxNYNt8L9qWSH4vKnN/tN8cXuINqU6IA6wD1W4x7TD2v9kkGPoDBiOg7YHKL1AjWBmQ0yeayHNTKOHGlcXwQ0icxWbYzZ9Tw+LpZ/n1dCoVbZig4vMz0haLXwmHjnyWdj/GbR4auPEHxMSoCjJW77d2bxC+CnUd1ECW/TAovM6GOQIurX1WnWBvsGa3ES2a0Mx4Mhq0YwjIhOkqGb6tuE57lDIItn/L07zCbjPW5zeVwKFQtvWEpsgnTmuAfuUzww2BKljsHt620KHKP4x33ZMy+B53hIl/EjaHO5WCzh8TWCka7jz1cjM1VwADJFEz4nHN/l39Ua1Ce2UZZS1s08z2H5YNrE+2egfIfcUs1SdYXcqVMICy9CQ4xKh5dbGCiyTGxGtUKv1x2FDityskX0MLPNJMvVqsRLaq8i6q6TOZkO/7oQtJdKyIpQKK7TuGmObqfH2jsU+suLHDaSgSPPdxfeD8ctTsDjfnKdtRT/0uMOQWBGoLH55+2KTT8aX9xITBycnQTlKXRcVMHoGV8JvEEM9b6W32o3989OpkeIx2on7Ndba138QW3lXYdZPakn3x/JA0f2KhcBAqscM9S39+Z45bPLc43hnRkPACTzXohsP2AQ9P6UL/bCNXLl3fvqDW2NJdKbohBz0g4ZdTmDViWPFg1ZllwI3wYnL2QDL/Jdf8CZVYxFdf/0yphQsRhXzBUKBnsi7RFHUvu0lv6Tqbj+luLDF4vUHp52JyJuq1du4JB4Zt8gJzWkIAp3Jz1ZsCcpzpyaBlLrUiNCtrba0yppNV63prAZJeej78jOowbQo/ZRUqsq4pWi3V3pTFGtzvwTVvk9SYov29RWMZ21RGRu356d2SptcJIDiMztcN7Snf9l5SqRCWjhx5lBOXMw48od0jrUbBuUiXYrC8wsPnkSIGDinUSNCJN8FeLeEXtdUazNN6Y9KSUuUZoxDIrqmWcMNUc
 Or+6h59y
 nXxZOh0zvKnj+EdP8rZqY6D64m7oxHAptC+MjAORruevhNJf0fpy/CQt8fx2ds/7FG2FcysVa0qSUyLJGB5xIfyth+d3QUaaEJyS3tje/vGzmdvIxlzgnDVq49sQnjkAjejw96hz7cC+4T63NThrnaj/x6je+Rsl7IfZigykfE9Vrs2o2SRV8Bo5h4zMWSkvsuYaEx8ut05oPuC2QYSBLYN2wTfmWOikDIOYbBODK4S63RW7HiuzdXNyqvZrwH/ZzGNsjbtno2w7xJcwXK3l2njukOMoYdCJTciXpWXbdVoQNbqf3qjB7r0kG7FoUj+FxLdkuQ9sUI9jpYW29Z5w7GUt168XTEtI56Ipkxl+NxJVbtwg9R1/J2QdTGxQy1YfM4vT6Gf40BVgyX2u0eC+Om30UlpYECJLAuxsJR3zfEGKHTFPZSkccweHH7sNm2Wn5DGGSY7kduyCep/xGwjY7Zi4NRgl17mZ+8yD2G6HrggSlAB5+knDV057OBjlsV6hQcpagDko4sfNi+ygP2MCw93HdQkDDNUisLfU2wcSM/Pmw5IZ//Lhqj3dqH1DdIQQgJZmqPfl/X0PoEL0YQ+Ism25sL3o1ElI/Dif/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The hugepage collapsing code needs is_guard_pte_marker() to correctly
handle PTE guard markers. Move the helper to a shared header and expose
it.

While at it, simplify the implementation. The current code is redundant
as it effectively expands to:

  is_swap_pte(pte) &&
  is_pte_marker_entry(...) && // from is_pte_marker()
  is_pte_marker_entry(...)    // from is_guard_swp_entry()

While a modern compiler could likely optimize this away, let's have clean
code and not rely on it.

Cc: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/swapops.h | 6 ++++++
 mm/madvise.c            | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..7475324c7757 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
 		(pte_marker_get(entry) & PTE_MARKER_GUARD);
 }
 
+static inline bool is_guard_pte_marker(pte_t ptent)
+{
+	return is_swap_pte(ptent) &&
+	       is_guard_swp_entry(pte_to_swp_entry(ptent));
+}
+
 /*
  * This is a special version to check pte_none() just to cover the case when
  * the pte is a pte marker.  It existed because in many cases the pte marker
diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c5..bd46e6788fac 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
 	return !(vma->vm_flags & disallowed);
 }
 
-static bool is_guard_pte_marker(pte_t ptent)
-{
-	return is_pte_marker(ptent) &&
-		is_guard_swp_entry(pte_to_swp_entry(ptent));
-}
-
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
 				   unsigned long next, struct mm_walk *walk)
 {
-- 
2.49.0


