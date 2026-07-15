Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D88C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23956B00AC; Wed, 15 Jul 2026 09:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAAE6B00AD; Wed, 15 Jul 2026 09:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2C86B00AF; Wed, 15 Jul 2026 09:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7316B00AC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:27:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 720D740158
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:31 +0000 (UTC)
X-FDA: 84990888822.22.E22175D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 736BD20010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oEQo/Btf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etJA2syXRyIgV9yIfYwz42KuGi2MCTWS+UAi0vZeNE4=;
	b=deHpCzUSEdFIBKRcXCkpIzX5lIYR1Kw3ek5kX6A5V+a+/NUGz2Pnhh9RKYTN5DXIdxRzpa
	zbfoMMByTLF0XDhKljbNoRdZ6a0a8QCJS2SPRPJW1My+rB0pD2jX+bNsbpJCPC9S67Q0zR
	+tHJWygPwvWXcL7+r6ewt3Za6URbKMY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oEQo/Btf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117309;
	b=Oy464mPqRvs+2pmgUrVmCc9lINrSaSaEFWOho9qYpfnDCq4dj7VtxQq+S8d8G8K8JKerIq
	r91uXGdUP8AwqJADUfegk9jMEx8qIQI716WP4kgwUPCQjygg3HPgExngyfZPuXlMxsqbWl
	bHHq5TPRid6Q2YelRtcTJCA3294Pl78=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so61728855ad.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117308; x=1784722108; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=etJA2syXRyIgV9yIfYwz42KuGi2MCTWS+UAi0vZeNE4=;
        b=oEQo/BtfkI+wtIETVdo8ZYW8I9JpfXfVfg4bTcPm+1jyZGE/O/7vwsAyauDFygtLs5
         Ssbpvu0wVKjsY+ZSJmcZoHLsGafQUP8J+FT6mfmyC0YXzz3orUtFzmRbV9+bdxWHa25T
         CVMG3Z3E2Yu5xXSogQoQ/Yh37UQghSA8nwtcJbksPsbFf3767Qch9RSC2VtaslGchwDo
         wK/GBw0EtwQ5ChLbNO3A+yMvHR+ol6ZHzSJoNCIfGOuO3J7pOezcu+Z5wgg/G2Q3Hbur
         a7gMqS9JlEL2Q8EW3F41X3jsuQm1ypDzdsDfvPAG0aQkTKdLsLviwF9e7bM50k5LqW8S
         XdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117308; x=1784722108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=etJA2syXRyIgV9yIfYwz42KuGi2MCTWS+UAi0vZeNE4=;
        b=fX2YxodNYLmFesRaSzN/UMvQwMezuXDO1nGG4eyVNgCQtzRcGnoaislrYbZTDZiaeW
         OY96MNev32I9RfoziC2+ddwQPhvtiuhbTE5I2wUtyFFxok+pqqk3L1azK9Be7fgXRHwe
         SkDpmfLZeHnx7GtV3AFN8huc+XdnjVWLsc9u4MR/IuDUb3BAU3nHLAsDiptkrcUk/8tR
         qjJMJKH/k9WOkRScIAkr/TInrQNhecLl4JJhepVpJNeUbBn8h+RutmWvmlmD/qWLEAzO
         mVxLLDD/1k4FWmGWVaElWZfm5gy1wh7QjZDuYs5elLWyk6mA1dPp9cPxkbRq+xfYbOhM
         XTGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrjQ9gewYgtKf/2PcQ8cYXYtjCPNtiW+DS3+HRX6ifLGkAVPOKYvRmECzJbdzkb7vWnkEmkU1pb+g==@kvack.org
X-Gm-Message-State: AOJu0YyV3EZtSI6a05vm4g6syfAOc59O/Irh/p6pXIGYhUwDJJraj4h9
	K7Udvi+VF7obdufGyBSfYlU3aJeXAk++KHvL1GZYeTwaeTkRp2mU62F9
X-Gm-Gg: AfdE7cnAtT0ItjDkvO6ub5O5Ua35SHyuJlDaPwemsfOks8GBHOA+WFaW/5xGBwATWam
	UPG9BSZC3DwP8KwtrRYE4mKKYLNgpSwCmyaD5Ru83ABMP7bJ3n+dWZJGczJVWUXxeTkwU1T4+o2
	CFKF71EXHXUDq2aQYW00ftrhrtHmBCJhLPLlDyl9fYjPdAvQE+LrTTCMOqSXxvo3KE4GYvPmvT8
	Ham12dSY5D4rgoB+nm2FDlMjkUXfjQK2i8IHhp014ja55GrhmpuI8yjcccOUi/EKYPjNhmD5xvf
	o6ZBOblI7rcH25Ah+ZK5lNMvmkSdTMoJvsW/BxlW2xkbJI5L4b7VMnwyQeeoru3duBDbBHaCeu4
	jcqCrXl8I6z2wGSt27614q0xpxtAKYlSKjcFiL7rew4jGzDpw1fECduWdhhGKWOzzjNvxt/IEE7
	rihpnblODpuL05H7XvYd41PXGxLjOppR+ZIQI=
X-Received: by 2002:a17:902:ecce:b0:2c9:cf5d:d9b8 with SMTP id d9443c01a7336-2cf03d24104mr22917075ad.33.1784117308327;
        Wed, 15 Jul 2026 05:08:28 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:27 -0700 (PDT)
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
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Wed, 15 Jul 2026 20:08:07 +0800
Message-Id: <20260715120813.3609949-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 736BD20010
X-Stat-Signature: dyo95gp6sy33kc9j966p8k6gy9szchpr
X-HE-Tag: 1784117309-719003
X-HE-Meta: U2FsdGVkX19wTXEATRmC0OByLenGGuaArhDUK7XInrV7VezTdArGlWt/1aS6MQPR4Hmb1jBbCjdQvPDxx3OpNd0okJ4N2KcixsaN6oGSzzPoYYpCsLKbSok1w28R/iT7TPKblzyyAvfRTEpvrEdj5KN3az1lA/PKPiX4CkYMoqLwhH1po8omM1+gzTkAwY2qXgdE8ve2fEjhE0D9kc5OtUMxdIYXzU356gUmDB3fJFEjhcOFYSIbrlQUpeAxu9T3nVNddACQqFCZDFiESadv+9ouZ0vMukMc1F+n/S91Y7BCwZGoRUh8GNxW2bcU3fpmvRhmtr5FQRK6Y4m7s25KRlt2NqFTNtqezi8NODbsP8Tj4oHBSfIyGP+lkPlPWFfLEiEcMaWNvRgKngO5lgUd73iz/dU++k6ryaU8q+VpEMG68/CMe6tKf8H0H+LsfjUF2zzrxUAAbx/ftIyBXt+2b7T896D/6UnYUoRLLzGrGK/VvdxidrlZdD3pVugaTBCLzE3z6gehgNl7YtnffNp0cE3htUpTw5c7e18eVKm6FTQ8dXrUFTDHo5O3QvtBVTiY3/K1CZg2CEqRqKs0omUIu7jraYmqM4GpKXhTEt0y0vBnp7YRt/mqFaXU6/q7TvwMX35LpLl/4o8e9k028mSKDRWqH9wMs/W29eIadZbAe0+JxG7vCBCQ5sD+oMpCx1KiPM7MSCNTrdLx3sJjsB+mRKpW5fxN0GK/La/m9KeKk+XREm/T2P3OY1MLEXVsLYGJulW8lm0SbHV+gXeuqAMbYFwZiV0jbzxowOVeB96rqMVmrhC+v0kr2yCzZXKNanu9GmLUAAWhTAcuDfw8UrkRFTI2zzrm9ZXE1BdeKgnjW4Yjrwq7SFtVxWEgfYXsB9XURpiV8MgiT6VxpbI1MpiKBGXff/MTBsvOaoXc3guiq51fTb4YEqG7W7auNiPiyMgGXethlTJSAI2M19XB8LX
 CgFtpqWx
 783c9qZ7oTzlpYaFBftc6e7kbhNAPNy9xGphH/QejYKR/leGSYymXzt2/t38nBVrH403NBsxn7vMDX45uoU/BkbioHmHdgIORUY98heH9liV5zHBtF2iDhDPzlWFjZyVF4suO5StmdPZIysLVqugjkgiF8D7LYHXX5TlvP5qvAH573zas4NGHGq4BwKi0YsLryN+yM4nhRhR2H5WVihXXtYNV27R8kDn4WZaHIfWh2xWlsu4uAZ3IERaxHlOyRsBmsgePM7k0tCxVRp81wA3C8F7gYFGhuGj9w8Qf8nfEsa7l9wYX06M70UtZcLpO5PRrqSrGxc+3lthGtKUwNxq8JcJTqGzj6ovQQbJq5nkRD6fkobRUCszP9O6FXuiH1724pcNhYxW2bbrvPyCi//P0HnfjFF9YniAr3f9ACE3Fe3AV9PNprAt5etWv1qWE6mR7T/7fQlcxxb2JTV3MvnRQM8DtQT+yoSlUARYINu2USeR/jUnP3XZTx+9B4GDZL5XOV36itLZ9O3NEuFosfAX6OApWHtCFfVlYm0Zp6+AZniuzpRT8jzj+KUoHXwL+PDMNTMJkjOqB4DB4HEDR4iWsHLovT8kSyGhpDQXc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
we can handle CONT_PTE_SIZE groups together.

These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
mm code, not new HugeTLB hstate sizes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index a42c05cf56408..7ce159483a354 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -94,6 +94,11 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
 	return CONT_PTES;
 }

+/*
+ * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can be
+ * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mappings
+ * at the PTE level.
+ */
 static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 {
 	int contig_ptes = 1;
@@ -110,6 +115,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 		contig_ptes = CONT_PTES;
 		break;
 	default:
+		if (size > 0 && size < PMD_SIZE &&
+				IS_ALIGNED(size, CONT_PTE_SIZE)) {
+			*pgsize = PAGE_SIZE;
+			contig_ptes = size >> PAGE_SHIFT;
+			break;
+		}
 		WARN_ON(!__hugetlb_valid_size(size));
 	}

@@ -359,6 +370,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 	case CONT_PTE_SIZE:
 		return pte_mkcont(entry);
 	default:
+		if (pagesize > 0 && pagesize < PMD_SIZE &&
+				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
+			return pte_mkcont(entry);
+
 		break;
 	}
 	pr_warn("%s: unrecognized huge page size 0x%lx\n",
--
2.34.1


