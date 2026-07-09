Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17EDBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E09C6B0093; Thu,  9 Jul 2026 03:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE096B0095; Thu,  9 Jul 2026 03:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5096B0096; Thu,  9 Jul 2026 03:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE88E6B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:38:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7225B1C386B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:43 +0000 (UTC)
X-FDA: 84968436126.25.FC5F2B3
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9049C1C0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:38:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rhJeATmh;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRIH/DXqtVKHJcgPpKlveFGh9fP942OgvH3RGS2tsDs=;
	b=79+Ba3IYE59AfjVC2WK6zyiEtSgUHOOt8HNnBrKg6yQ0hXXfNOAPkn32yG2fFrTC8W1Bj/
	OO7TCu5hIu8WjHbCqUNfdSgMsJKO7WvDi979G2bsbnikpFotJ338c63gsxGCTdzerPg+Xb
	DswEYISe+I0OEc1LjELnQZ/7yK17Pco=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rhJeATmh;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582721;
	b=agQ+cMMVlP3+FvtNjbuNPzG2gph2SWMfhuWyBhIU6/n0VeSZuF9N1HOsNn2dw8gO8Ad6uS
	lwwE/burdNpvqiE8ZnsXC0iy+oi1elznBjY74Wn/XLFRuZ8r1NoOeLjrV/+0nfHJ8+QgVa
	l4WtzbYN67vYmXPDQhqaLiCkaRi1GRs=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso915096a12.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783582720; x=1784187520; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MRIH/DXqtVKHJcgPpKlveFGh9fP942OgvH3RGS2tsDs=;
        b=rhJeATmhKFnzaFC4Jk9rD3EBpJFCw9/zQnlX5Ncu/tPg4rST5H5Tgt7kbk99hfcfaw
         6l0STiYkRYT7xKtgW3DuM+AMhj5+vSX5oo72h4ka8A/SNnkyFXs7aA9Mxm8hiW6kdoge
         5EnEFepkCwiUiFhuC9tuDcP3dZrC1oALUFqU+VyFgkgQtkCcbOpKa8uigFD6/XGXiDPG
         FHP3qUtq+MAyXsEOve+Vz1NeL51APN21N9D2/uGKS63naeLTN3lELSGc1lY5GKGaYevm
         mogbLwiL2vsjq+d3fhq0ggHoveysOnPxM8cB04dLsSpUQ/lqL2kz+0/KA8ghf+HH+h/S
         rr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783582720; x=1784187520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MRIH/DXqtVKHJcgPpKlveFGh9fP942OgvH3RGS2tsDs=;
        b=Sd039uupfmN6bkRRtW7HreXf/+Ddf9410UWyj78sWsHSKGimpyqiC6lH7KwHmGWIMX
         loGCvF4+mj1bIX2A91fM8zAzONF7m2ZNk01IsuXAssa9+9R/zk2Zd3eC7EaApNawQ12w
         kVODO04HHYjTuJcHDFmG7MOPmrDtfSPAMrl24dis3FXFyhte3BkSMu8QLEIndzV5uK/T
         4zFpVHOj13KoxSRjS7tc4QRHzGKkwzYL7mX5f19H4V6ZNJTeNo6Evp1fJTgZWjOlmTcX
         /VEq0mWIpERUjIL90WbaXp8VvfwRea7pZV+XYtZdD+DKs8VdToTKI70VYKqQIhQ/bl4O
         QcSg==
X-Forwarded-Encrypted: i=1; AHgh+RoXmD1VBX5AVOQ7bJ+bcea/LvvghaNc6yufDWC5V/xAwvi1duuGvLeCFibR5w/yqwEo3R1pgdnf/A==@kvack.org
X-Gm-Message-State: AOJu0YzY2Hfisenp3lCSAMsntwgC3wltLnMTxFhTy6A7UDhhRVqLPdzS
	yHPGiQ7/MN7XOJ//nCSY0E8+cNxQYypIAJGwBYoMiXLqh+d2o9Pdkxv1MsoY9g==
X-Gm-Gg: AfdE7cmwBS6ky6XLa6Nfute+Umpv4nL0ZMtItMB7ZB5Gwwkb0QfwIAqONjPTSejFcRy
	RIwjAdxRqyisB02cYj6WLisJKxSzicKuPx9TcJQzvgjzaatmCLBMjog0Jn/oj1UYd4+gSOLD6oC
	oEumZS1b6P4C7UYih/ZCv9nUtgiu5payzDXqypxQELyfEm6NlL88siELf12NEGy+j3eaA37tZjU
	uBsHayi5RJrs7TgnpxRgqESc7kwPyxq4CQkirfGY3rwPX2G9tBtOCj3XzkUKmV+FwvvC6ssFOtS
	J91ymKcg8tByuoYJKSsBX//9iNeBIg5uDqMdWy6suOh2cUQtwrOCnsm56WK2SErcQKrd6HxwUaz
	U7hpHgc2O5TwVxTODHf17+4eJKUPsrotp9b+5aqWt1ev+3mh4lc2k/I71OIGyXEtK4Wv/xv7KEb
	0di4Mnptl1Qy2J9bvKdT6GCbXBY2jH9zqtC2k=
X-Received: by 2002:a05:6a20:ad98:b0:3ba:cd5b:3dd1 with SMTP id adf61e73a8af0-3c0bcf5d7f4mr7000339637.33.1783582720482;
        Thu, 09 Jul 2026 00:38:40 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm3334902a12.15.2026.07.09.00.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:38:40 -0700 (PDT)
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
Subject: [PATCH v6 1/6] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Thu,  9 Jul 2026 15:38:18 +0800
Message-Id: <20260709073823.6643-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9049C1C0006
X-Stat-Signature: b9asg5zbwsm9e1hhsy3dp4jocdceyuou
X-HE-Tag: 1783582721-634974
X-HE-Meta: U2FsdGVkX1+ipILuGhs5KP5fGXXPJRe61uNT0O8ZIKrF290wYDyuRD4gO2vutcuxi8hEGfi8hpNC8sEwivRlbHs6un0ID49xaB5RCSctm3O7zBfDaXrWYX4SFdW3pHXU8d+L4OsnyDPuC+k0cIAhqrAv7cs6rjqcLu5r0YiUaDao0UL0n2cPsPUrI1R0ePOKfEGggv58TUWVe1jWmDdwlXaZqJsLNCdcNtkLx4Vyl52f0jSUdfE6SAppwHrjBeHEdvl30CFrEY+f6pXQkfWY8SUVAtf6zhMNaVJxhl0sAqEoNxWz+DymrS4rCjoyca0BgKwyPb9CekIr7oZ9q4u5kLrZ2nZhECgWec/R5YDfu3LzCLfPO94NmuMvY1cRI/bkL3n7P6Yhkhg5PEkpx67Wr14BU8goIPlZL5WAjSGimlq+KS1szptDjooV6gf3fIeAlti5HTJ+vaqkBP15ztAZR8uv9lh4YvJzRY3IsFLnQk1MGIA484/8rupyBGzcpmLUcIZQnEtV4beGahuIa5BODHZ1vCr/31IuGwn3iyWE6xIxS3y+5drqJ4FPiB3CrFLCi75bnAkTwX4e4MVi0vryw/0C8+Hyk5vPx7IHnoS/KSuOTU7EeGmE94il9VbDzmByt8bI3TA7SLcwtgD48Kdk2MoX3+IIdFDhLFo4z1SXzfcDFEP8YyReY0TW33O1wEPW8tWI4mHSbTaVOW61oFl6QaBZHioD8djUsmaWOU0fpEYYLcdtSRxO/xV0fX0snL/PL9D58VuoC+mRoqHOoGo2psXWrBXoAJ3BPvTpIVcs2Jr62RpHemT7uCmAiozDL7/pO9+TcXYHgMnCDoinDl2H5ZMozhSSaAbJ07e09gWzvIk9B5tLdRADcq3653cSdpUpo/iIgbWi245kPmBmX0lMvEhg+UYAo3p0aN6VVdf/zlvudITXzeZCs+9OZqqXH23Lel+YnTrIPpQILxKjLjS
 5+T3qpcG
 wsLHwfINLboJGUyESf4HmBMEHd19gQ+xPk9tIbYG7OcTKfY5dSrRzzxy+094YEs7RPQGcS9HKyxS6Kw5WAKn7fTioWh5i+lM18K96jFwiFKMuMoVGSpFAU72qw+L3pWnY9vdmTbRL+y0A32aE+5D9niZZS8JifhkGym1UBdzDyO8aUVNC86kMgApA5T9C8wRmp3wroKVuIPSf7WKnNSdklkMzHJXNccj8znZoMVtbUZDYwAjQhnYd0NzQe+RlPtmHKczsDnausDoL82w1lpx1Ho3uOb0SgkJLHhP6e1iF1nWSF50LBMk6R0S4iXo9B2o2iKHoO5KhmgPKxIgh9aFigCr3SkweYe9V2uIPSKaDCHQAsAgAxlgQxiVoLWWIFGyB5WxHY4CmyU3jiMkXCwqf21/W2/X92oude3lM34/iKI1vRM8s9iFQ53eYFdCsjj/Yby4ljXBUjBRUD0tKZTAD15cMsPMDG6/HQe7fl4V5avY6IaYQtF4gI5xsHGfj3kPp1PShsEcf0ob7o416Vge5plXtq9zS6EkHJsOx1YLuMOY1IOTSfsTFkDEc/uNHUVrXjb/DnGxBLf0Ac961X+g/r/85fHlruJVmdcbu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
we can handle CONT_PTE_SIZE groups together.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index a42c05cf56408..0da746f729388 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
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


