Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9724CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119C86B0096; Fri, 22 May 2026 01:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F20A6B0098; Fri, 22 May 2026 01:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0078F6B0099; Fri, 22 May 2026 01:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E101B6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB4721C06F6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:00 +0000 (UTC)
X-FDA: 84793934400.14.304665B
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3BD4C0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:31:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MpuFhxZh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8N+rFVtNdZ51dKl5Chv+doUD+ImVi+kXBB4grpnNGus=;
	b=RdCy3ho7wZdr66qsfSY8zt6rwQwDAOmcsGL1v7RxzSCWRuFAAdcmv4lqkrvMR/7mQaWTYF
	S5EJsnPDYQf3dESO8BZSYpZ/wJHADcjCSQwTfCTmikM4UKbCZC4zQ4+T03lw36mJEcP2fO
	iQLfArAW793gOvaVQZv/CFmQkB7mKWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427918; a=rsa-sha256;
	cv=none;
	b=i40kdcbxxXL2RQ8Mnwv6utIF08pFnCXnlKe/s4uGS7Ul1GqvvDpu5WtBmTN/vZg2YQu38c
	N96ZAUfbQmefZ3otylQXy59eQyb1fi7unCvvMSBOMkU8BzsvQjk4zFnk9iie5dcx5xwY8M
	SYVapzMla5GkpTqgaxicaZCc0uhvJvY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MpuFhxZh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-367c26471f5so4388562a91.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427918; x=1780032718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8N+rFVtNdZ51dKl5Chv+doUD+ImVi+kXBB4grpnNGus=;
        b=MpuFhxZhySsluZkerNSwbq/cvIHexXIKOtf/WnrVJa1+2ywnnh1ZHjCJiH/kex+6Kc
         PVghEbtSVE6QYAW21KhX71lyhQrAewithbY10NnELplkJ6/SXv3tzPUG+UXOur5HumK1
         hprzEOrvRleFV8v8/pVB5Fyj/BWZPs3nNUOVaD7W6FNeqX5Fs7SClUb8+POMftNIPeqr
         GCaF//8/iyKsIc42TMu46kQRYNY8MP7i4bcZAglItlcgVMBwa6kEbtczNphGBzqtzz/Y
         TtLrSdOVquYbPkGhyEatX4/SkcJ5R9dP+E2n8CAz/Q6x1SuoTfNRavH0omaaHfR6YtvD
         Mwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427918; x=1780032718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8N+rFVtNdZ51dKl5Chv+doUD+ImVi+kXBB4grpnNGus=;
        b=Q+SzCEF0CZL/goP+kJWzstnv2vRdloWiBaP6vboPlK+djgtePOc4dKT89vNgkrcjuW
         vM7xS7z95pbSW1LcEAbXWlt+HasCgj9PSj6FFztEjvUIzRoZ7IlvGqIJ4WS/0/IinLsa
         L9YmoguK6czZE792NsC+tmJviJghSD3eZnL81sgo+KvSOAPvrQWm+mT2urG1Kiqd1IQd
         DTgHEqLFCCqzNLQ5XPPe9FFD03fLbMuJpOk/iYI5ZZGrchZQtEtRBwHN7Lg/CR3l0ayY
         iGiSR/bmYqHQGCrVs3AGZk/BxHRYluX1hPHPI7IxL6hcW3Qb0r4e06YAZJXhoONfWQWv
         guhw==
X-Gm-Message-State: AOJu0YxVRCzqIShd5n1i6CyNW1/+e3nKgZc/JACW71lc2v0nhSudvl6t
	zxdmksHiFE+o4bGx8bshi2D71sdcSSXi/BvXrQctjk69iGESHJBzSZBU6p6W3zUR
X-Gm-Gg: Acq92OFDVyjJrq7msuVZbJJxTDad6VdSTcrUm/ghhNcuR2W111NoU6WLyWVeYjjMtj+
	59vE+UHTGm7QzyPgxTkPTxd5C0J3ul9YwyhchiQKLyRB78dCpzuR6+7OIfTZfARg1dSKcxN/OT4
	fjhyWP22S6ekI4HTueIP0RSSen/q8e1ri0Up/HIM64rN1dffEVJb03ZvHOg6wEV5Pl+0MF25k48
	B210gH08952I6VVaOcpPNGL344XV1ekuY3cn6fEH0+eOotlC79OBzYAG9ZccJIrihxMnrs6zrz0
	FtL96L+MeeJJXEOgaD+UpVzmiXQcUwrN5m9syUPUMWQzlrqkRWUBveEuwkmFmHtr9+2dYA4i7dP
	jfe/5Sr3dL4JA0AVE5Dlucm/Rpat0xFcBDzFaEY9aKW7d4ljxDXFFrLBXBXYpDfQ4yIHukTvMo+
	kyKmcyg//qIsNe/rftjccVllqiaDZJ8tuHdu1QEHkLCnTyc4QzJns=
X-Received: by 2002:a17:902:db07:b0:2ba:3e50:e3f5 with SMTP id d9443c01a7336-2beb0634c8amr22954595ad.30.1779427917717;
        Thu, 21 May 2026 22:31:57 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:31:57 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com
Subject: [PATCH v3 1/6] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Fri, 22 May 2026 13:31:41 +0800
Message-Id: <20260522053146.83209-2-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3BD4C0004
X-Stat-Signature: mhac33axoq9wzjw4usy4sye8rxcfzbwa
X-Rspam-User: 
X-HE-Tag: 1779427918-379040
X-HE-Meta: U2FsdGVkX18bYE9SZvnDY+zTglFwi8wFi2e2tnJC8AUEwwlqkm+nuIpi3JRONBXyUDHee919XzdD+R78t6EOWcDg3rosoeZzw/GKPgDrUSCTaqAv9lQS92lc2yhevbAWOV4kNokOgYLyAKVQMmmW4N35ZnIg5HWnshrdGU94y+gyyw6V5XmsbMfRGC3ZAM4q8ICrqYcFoCctpheckXah17d3vCIFPl375RMNgbc/fDnEc9xZ1xuWyGYovlg41F56MxbbBx+hlUDfrgYPGfi/+Nbr6P8+mBl2yrOXxfhljwo1F6VVWK4y9B9HQlHtm+1O5lUwGBGU2yEG0i7DfU/zVlJypidDkc8Z/Vba5t1u2eW+FvaRb5TNgZX35/Qgw4EMyU63ViVo7FcwvFmtWgLFwneCtR5u7pNpamyh6CWJ4qmS8Tg+aG6xsjtqyAcZSuonhLKN1aLbRYA/ywJwa0h23oFM67/ORDX7p2ShFOvz3EezQNwYPUYRF5F9GKRY7D58x+x7l8975Bb5iYMQOCpWSEXZL9l/u9mgVB8jV97ttgw7QM/oI7fEfTnhrUmval25XGyKmr3KI4mOP6UprWnUHJWuTGzPSarss9A3elkNZ+31kgrajbW8Q5swgkM4M2Nnu/zvNFu1gwQIHyvrUCydA1TeYYcYQPmwKavp9HZjnjETTCiMeLAK+q3isC3R5xfbEH907nk4Gii1vc2zDEhN8Zacrw+dcKCkFkR80ig3sZBaK7ob8xXzhMJ+PSXEAx+0iyDhUxGyTtilT2R7+jU2XyuyGKqM12u09AGZmx+/da+6UVd9aoUYGqnwXbEOgZVTvB3PwrhT3OGUedojWOK1ozxb4JcKxINBPFwXqMfUOamanHLHv00xDwuNjZC8IjvDIsIw406tOE0hPVAqch2HJeMR+zHbf+aYwK8mkVWgE3ccOh007bn9Xn0Sa44vuQdcxyV6LeVzIznPJ0PlFb1
 +rnvJFvJ
 FH/DnBN3NskZmFO8f0FvpPS3H8gpYQQg25XU0HcXYjtCjCrf9ndc1Gi7w7LAIPTCKS2RuKNWRIRgb6XgS+Id9WLfKZpZ34aW/XQz6gouAgb2achOuENhJfAiuGotkUY8koBmvk4u5l3FxPY1O/FWzrdQcToYjrWR7Ojk7lgREPGhBfn46Mb2PD6Ti9cNmby9SgNUPlturhl6i/Sc+lgqZD2EFfWr9vWfF4kvY874U1n7lHaPy1FKYacgsLT1iow2k4iDG828xpp2CfXMJeMfBI5zvtLjZT9Ponie6Bhq9f0ROpscMuKSpgdWNppBcA7YufvzhlcMt1hOb+FDG+oIBXz13qHLNqOntxe65VFRdwgc4fngG3PLDpot5kDlaXCjpFR5eEJgUgXcZvGkMBRlgnGLHLpne1pc0YZSRbOA2kpL1TE2ROtCaaeR+Su/05J4is7bxBOZyPPqJi9FG/LutBkCpyXaltD3fMMMTAGv4gqnlAy07S0Jawup3Lb/c4OmAuvHSXOowX9RqZDU+Rv1G44AKHJ7RQOirZt4wtoJaXZyKhZK+vjxTNYWjR5knXuoDxFSFEG1ITb2ifgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
we can batch CONT_PTE settings instead of handling them individually.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index a42c05cf56408..c4d8b226126cb 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 		contig_ptes = CONT_PTES;
 		break;
 	default:
+		if (size > 0 && size < PMD_SIZE &&
+				IS_ALIGNED(size, CONT_PTE_SIZE)) {
+			contig_ptes = size >> PAGE_SHIFT;
+			*pgsize = PAGE_SIZE;
+			break;
+		}
 		WARN_ON(!__hugetlb_valid_size(size));
 	}
 
@@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
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


