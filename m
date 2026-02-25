Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37513EFD23D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9768B6B00A9; Wed, 25 Feb 2026 06:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942126B00AB; Wed, 25 Feb 2026 06:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A0C6B00AC; Wed, 25 Feb 2026 06:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4806B00A9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12FD513B17D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:01 +0000 (UTC)
X-FDA: 84482696802.08.F658E34
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CB2880003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BPkuKSJy;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIfE69Tr1GqPmumwQezrrcMFO68ntbjafUDqg2qd9K4=;
	b=aRx/V45u4iFNzQH49C1MlvHii94IHuN4C8ambgAZwrS+T7qS8KuzDRUW9YTiLKl7Z8DHOw
	crs2V2Zyb6NQFJGtmRKFFGk6RRZnvmNGfww43VUmhOric1jHVAtdUjTAry75nrGhmOxyhp
	BkM3ZqYq7Cdh3MhTWsJxhKRPEz1f9ic=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BPkuKSJy;
	spf=pass (imf02.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017499; a=rsa-sha256;
	cv=none;
	b=az9gjckDMy7wuXfKd65cAbX2RjjBFYQCwPYeCgGPOijBJgvjWgiucUwMRMxNNu/QL1Aq1D
	oLfLTmW11qIa3Kx7ZRNZiL0MWeiFs66ANCq4CBsYv71JV66ak9HciIpHhn/8orA0cflPHq
	MqT4iqgMgrPgLWOLkYZBzrFtwx4mdkk=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a8fba3f769so29220385ad.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017498; x=1772622298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIfE69Tr1GqPmumwQezrrcMFO68ntbjafUDqg2qd9K4=;
        b=BPkuKSJyh6QsbIyK7qJnH6QmuNWWB/Leacm3CmlQ8kuasQFFUr9WM74I8AWSp3nJo7
         Llz8bc2lhPAudeiZNKVviHcru5x+4PpoduzP6HhOSgc9vXaE+XAKWcetAfCKGRXmYghL
         7PINt9LjqYeLMEOmf2KDLsuI5xGCOO8ZYh38UvvbNlBkhGT5ExAOAYo2JaxR0RIe6A0h
         HJEJuUENEW+vMHipXD3asgkzELLGgKHJIcX2Z2XMD/VkKAfDaG9t4E48rW70QpgjDGE1
         hypvyakexjRQaBfnIjaFf+fLa1ZrojcgvwzKuQsEhopJVkUkMlEyAICgqXOZf2Qb5JCI
         W0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017498; x=1772622298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uIfE69Tr1GqPmumwQezrrcMFO68ntbjafUDqg2qd9K4=;
        b=YjWJtlVLE/1Rl4hu8ELiLmGWwPRjudEhN4yFoOx6gFVpbINDqoa8+/0FZIimAvdWIe
         hMHgrRRA9KioVzNmajwrMLFGadgt2LQApcYckivFlPtZYVA+vowUnP8y6+NPEonY+pr7
         N0OOxlee8czpM5p01zVM34dxCknLUwSeS7zVlUV6ZW0JVlbnoAlcmnV1SlnaAujgpzuM
         48oLm1qqYbvxUDSZuN2iTFK81Twxa5AkSSdICnPYekQEf0abkXbzwZeroAqT0hL0Dhbl
         aXqhcalJgJqfuBz045uJZI1i+xPI3tCbuI4H982FIKJYkK/TUR9zjC9bnKzq2EXZmF/q
         99FQ==
X-Gm-Message-State: AOJu0Yz+om6pNJjBgnmDLmM30MGq73GcWtoDPcVsXHcQE/88ug0ukkE7
	317EJJCrOCk7zs2dwYTjP9DAtMLbUH3hVV96HjhRjjYERiUAVYf4gCLp
X-Gm-Gg: ATEYQzxNwsLELyn3LYB+JvBtAa2iMcc+6RrCR4/5yfEFhteZqGdKJbWUejXbdLpCXNR
	AXvF4IwAaghYndn4xry7PnKZ6R0CD06AQRVNWoa/3fubYyeMV43jK3KtcIpsQcw6tJt8duWvpY3
	sUam6ltaXhYomEqmiVUr4ZcRyiFONeXO+OiKLPrPEZdxx/GGe7EPVLZjbp/dGUaTxCa34CM2TwC
	C3XeuhEK6bdrbvlsrIfdRuZoMKXRCtAhvl31krBwAinsMVjifXFvUX3QrRti14InFn39OsKqIcp
	ls9ozmm2ks+LrOmfBIsTBKT8RE7tflrl1FP0HsDgCmjQA+YqNFdOcBNslEDanSd4Omh5yFelciR
	0vbc2KOL0/wBPij7l54UjUbKV05VeZ2lFbsHPb1PTfL0gsZL7PTl1kWiUIly04qPveKxNtmM++Q
	l3swFUz6kRHFxqy/w1YfdOiex1fn4eno0=
X-Received: by 2002:a17:903:985:b0:2a0:823f:4da6 with SMTP id d9443c01a7336-2ad7456d474mr147228985ad.50.1772017498087;
        Wed, 25 Feb 2026 03:04:58 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:04:57 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 03/10] mm/debug_vm_pgtable.c: Add test to zap THP migration entry
Date: Wed, 25 Feb 2026 16:34:24 +0530
Message-ID: <733f1640590bf927a4cdef854c4656931922416e.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: du4adym8w7hkbyfohcdc971e96fenp4c
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CB2880003
X-Rspamd-Server: rspam01
X-HE-Tag: 1772017499-401354
X-HE-Meta: U2FsdGVkX19DITFRj1QPPLSkzONtnGy95mgxi8GMSshUYhrNm08TqWGC6RPLUf8v95htv8pYGHQOtFSryCkRgrle1LoRHNdYu3asRjUtNasdOM96Qs6a0RT6aY/La0KAxpABOFwq7SbMAWVO3dxJFf1+AWBood28m4Pq9XikHyXytQc9CZlySyUHqK0RbFrKo7Wbrj4h2T5/biCZgPh9FFPq+F5bfTANbDH/X7i+IB9+B1WdCmLdqZvM/WFpfejtlHnbIQD6yH0NeYXH8i3XjZt97aCgguMwbJbRuk0P/35Gnj8D5UdAYbpfA018IoO7FDOd61xLz9nOd5mGdEjw1u4ZnZtUGlsGaeoDiP/l7MPCmvQyYMABfPsueyVty8cIwtXsmyckaTYBtNSk98Zd0X8RFtULjflWASH8N6pzkHttx8fT6G+i3jehaXOsEi09u8YuG+BH4uRw/hExo3E533DmVDnF8XLUy+YfPH7/2gSMysybCKAfmK5ds7zXpklns+KEw8QK1/ibh7p36dpkp/gguBgD8Dpytw9iiHILeLHfef5KdondNwfuK37w/o4XYMLF5JkRi2A0vQ4vd+u4VwBjY/wywuWjMMRXgC7Bf7DICySQEMvVu5Jt1+irp5GFx+nT+pHNglW1p3+f3TykWFqcG95HAwjLu1C99aZwjKmxjXlooferN/onJOaQO5+PX9qjTodYnl+oErJ1Mqmr9TWFjJYteeP79iWaM0J21BQSCPLSYqU3s5qGMvKUHtS57z/woxKqi2nJSUfDdJFaCVYJt46EeiZKgVx2Sz+AUryU/0tIT4HA3mDqtCYT6Mn18lkU1WyPb4N0XQs0eu2iRGkhFPVv4LWAZUL6BTp6FyymQRm/pFsBZf0m2ZJd3sMoejMuv2z3LSycIVS9ldH15sIXeWqe06vsSSViFH7zw/14ieNp9q6BM/v5lvwU5AR4YguAh6rBniOTqjxuOct
 jXFUcU86
 o3itlDQDuBojbHSO+j9fD/F0fi93HmuaRFogNQv5DU/Ifc2bxZvsJj67Jwbv5jXi/ANNWyBgb5qFQuOvFun7bcwBLc02XkprygcR3YSosqHAaiyK/wY8ljPxVz3S1vdb7i9svD6AqrZCUez1uXPnImay2MJR//XQ2aUSTI1S4i8nyxCLUZ14UKTY00NVl1tq8sMdgyZvr+WjB2JJ9lVkgF0gjEhTBQMIX4+XEmXQwBv5jEhNucNyt73WugLSWeG3qphBWXLTeqVG8VpGBGI/cpjzndHF7Z/y/SiKRj3D0DXHAr37Rux1FXdZELAkc9IELWM6N109iBtl7W1wzKMkGvp2dtjEfCvB3gvvIORMRCdDhlZ5nljIvQ50Cox+2pu3phqlLlEjzVVXPAFgbHoladdpTB+TMbjszvj/3RrW3duaPl+27OdFEbvNC9kYD1oh1SFmqN0BfX56wZm+Yw5FFpDUNlGovyvzglk7TIvpO5Lx3W7Oa8m4fBrAc9TqCiMAf7FO3fbMzcVyX0RN+WgtmHiil2eAXaBSXyIZVUHQETg7QDBcXJMA1I7I8jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed in the previous patch, there is a race possible with
zap_huge_pmd() and migrate_pages().
This adds a verification test.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/debug_vm_pgtable.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 83cf07269f13..802f9f03c8ef 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -837,8 +837,45 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
+
+
+static void __init pmd_thp_migration_zap_tests(struct pgtable_debug_args *args)
+{
+	pmd_t pmd;
+	unsigned long vaddr = args->vaddr & HPAGE_PMD_MASK;
+
+	if (!has_transparent_hugepage() || !thp_migration_supported())
+		return;
+
+	pr_debug("Validating PMD zap on THP migration entry\n");
+
+	pmd = swp_entry_to_pmd(args->leaf_entry);
+	pgtable_trans_huge_deposit(args->mm, args->pmdp, args->start_ptep);
+
+	/* Verify that it's a valid migration PMD before we proceed */
+	WARN_ON(!pmd_is_huge(pmd));
+	WARN_ON(!pmd_is_valid_softleaf(pmd));
+	WARN_ON(pmd_present(pmd));
+	WARN_ON(pmd_none(pmd));
+
+	/* Install the migration PMD entry */
+	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
+
+	/*
+	 * THP migration path can race with zap_huge_pmd(), which calls
+	 * pmdp_huge_get_and_clear_full().
+	 */
+	pmd = pmdp_huge_get_and_clear_full(args->vma, vaddr, args->pmdp, 1);
+
+	WARN_ON(!pmd_is_valid_softleaf(pmd));
+	WARN_ON(!pmd_none(pmdp_get(args->pmdp)));
+
+	pgtable_trans_huge_withdraw(args->mm, args->pmdp);
+}
+
 #else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_thp_migration_zap_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
@@ -1348,6 +1385,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_clear_tests(&args);
 	pmd_advanced_tests(&args);
 	pmd_huge_tests(&args);
+	pmd_thp_migration_zap_tests(&args);
 	pmd_populate_tests(&args);
 	spin_unlock(ptl);
 
-- 
2.53.0


