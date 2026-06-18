Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F63CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7306B00A8; Thu, 18 Jun 2026 04:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487986B00AB; Thu, 18 Jun 2026 04:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4E46B00AC; Thu, 18 Jun 2026 04:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17E326B00A8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D086C2C49
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:42 +0000 (UTC)
X-FDA: 84892405164.16.400E68E
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 92C8B100012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Eaps/B7h";
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2WEu3pL2331FUekzYMzPgYnW/t+6wHKRR7Q73nVowU=;
	b=cYHy4Nb8YZM6Z+f/DKpXzbAetaEmOCEuTMP66emauGbHaebogziPnFjiRFN5kIBUxrq+XL
	MqqW5orXJ3PGkyxH1N4RWE0Vy7q/uqJrpd43p+Fb95JRCSw/ndL6Y0pgvdwKJwKRE0vflR
	bukxjRYZjiGce8qqDGx43YBOPbwfGtk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Eaps/B7h";
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772460;
	b=g3QQvNElvlljIUNtA4EveUX5AZxukN+Q2sBkQbMSO4kVGluPgTndJxTmgdI5K+7vBNSyL9
	y51D919ptCno6yEbG2E3uXvd6KApCYFClp/RGQXhTiSXw6P+xJGEF1tooyy5aWpYyCWfph
	K/JpEXym8qB7HyUvWsKIOWQbDCJkZ7o=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36b900f350fso770651a91.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772459; x=1782377259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2WEu3pL2331FUekzYMzPgYnW/t+6wHKRR7Q73nVowU=;
        b=Eaps/B7hMCgzlSrfDuu9dWeY4J2GHwAU+9Iv9ADHQmND9NxoGpC+dtwNTRBxuejueM
         gQqHic/+E0MejToG8oF/wtmwMocyJzQqiVANdSIcLB2GMyyRYmXqICt9PUleJiB7VnLE
         eGH1TI1GOJ6CVhUlEJjiGb8DG4Bh5u+lSgpEYf83JEiSs1dXwOD4v2NsHrjxtPr6JrF/
         /ZUvRmsf8MGWqLsGR32yFtc5YYS7HYLmaj2rITc7IMvpUeRsoFrjcEiSZRZYQrCh+5Ya
         nR7UezWEdvRe9qZYiKJG158q4mEVYhJ+tklFhvRM2Xb3Cuc1BIydnUGSegtCDaldjLy6
         9Wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772459; x=1782377259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u2WEu3pL2331FUekzYMzPgYnW/t+6wHKRR7Q73nVowU=;
        b=nXGFqojKssPcSQFfJcqWknOkrbIzvt0u9Dzw1SWgYVAwE3Znv/FOfNF9C+7639/6lU
         Gq4QI9zRp/hcSDZ8vrPYjeXpZ3VzjRkx20UpwsLc33hUcXjIgBFzSoIQou3fE7nIrn0o
         imFF98XG4lxddMVBDLCATZMw5KHPyBnZlqcm2xw8UWJlhEBFUPhr4lT3OisgeHKEfOZF
         nWZKBlHG3ffK8GDWY7K/4h+iaAukGGaoZMNiXvoZl7v4EjDmpD33Nntn/kxgtjs8XbZL
         ywF+eC2VhH77b27El2yfTleVIl7ETzOlilqmiaWpnd35YwFu/On7mwDAOLw/8YlqWBap
         sGxQ==
X-Gm-Message-State: AOJu0YwF7XUsJ/SwLogAJbdSYsHxM1UDWnC0bRmqwdm1KOO57s+2fGQR
	V6KXASgMEVxnn18p9YzSrXCBx8T+DktFpKuQNUj8ea6JllCPeeNeP8AhTsLyYw==
X-Gm-Gg: AfdE7ckSErX5mZSZWI9/GP4RTiS6acvuaXWtLa/SPRx8JqVFt5tM8hnhv1g9iH6LAx0
	Wqivb9uPm4rrQowHVzgRh35taKuandFkOUfYSxWNSt4rkUIfv1iiQe/pGhalReIuKNMvK/kH6nH
	XzptSzgJVCBh+0a3i/zkvwzfHtPQXvaA+EW8AYhyFDvstV+JerQiFminujiJSBh31rbwvqXsD7j
	AKVMKodO7vpfjS0/Yq4XFfPU4ix9j1jRbOh6b4pc5IFFdHKjYQjSGwwUigGO3SyioCyjDQjMxLw
	AdfyT1EQUDz0KzsfzvSLziJq5b6C9PMP8iCkgeRAxkL92zh4AoKoyJS6SJNAE4x10tDoTcwLnEw
	S5OPgCDGSReTeB25efsaeqa8ABhury8wLi/Hi59r0fgslYqz4e7dW5QkHm5yfSwFjgyT1A08kX5
	z5AYFD6ibczZ7MYkrOhxElet/YCB7uzoFCeoI=
X-Received: by 2002:a17:90b:2812:b0:368:341a:a925 with SMTP id 98e67ed59e1d1-37ce46d8c8bmr2750204a91.23.1781772459491;
        Thu, 18 Jun 2026 01:47:39 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:38 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 1/6] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Thu, 18 Jun 2026 16:47:21 +0800
Message-Id: <20260618084726.1070022-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92C8B100012
X-Stat-Signature: k7j5pko6bh7it869d4d74d8j5j8wbeum
X-Rspam-User: 
X-HE-Tag: 1781772460-254438
X-HE-Meta: U2FsdGVkX1/309JIBQO+bCyL3UIrvJnKblxcQmlqOsuOUpNKqDyQwYEPmYyUg0p1w/7bg2nadhr4xbcmqegnihYjXaFOTDJN7VYJ3YnxGiDHpah1G2XQY47hu7RyI9QcUgQmwqF0D3YI8h3vLIsLq57oBpBSJr/4gBN+Th9cUQmBDPRK0cCQ0AO5g6bvzO0zbjs+Z2Wz7yRuAQUh8kzIuWH0ygKxkhvkYnioX5ndlYKad2V/7NLQjgGIrWpxrZFKX0JFqvwT/FuTrCxSjauUAmviUMxwQgNXRT7LNNlEPjC+0fSm2ZaQnjACV4l5mlgqK1uyw5JTbLZ9sQeTyC3PaCXN7BrbRJQiWrtfWDVv6fvpRgtPP805L9H8uSiiCmhnDxCMTkpV1FY143/ESPbbHN0rjhKD/Atuj8FfejG1EDiiU8sijGnnO8gdtFuM7Sh3RWQiu6y5qt1Zi3638pSlKQzofCB50Jcl4ZHmZBEVCupq4SpIAr1XUtKgehJhccxfIiHvbagF26n1KFImwyY+DbRLFurRSyhNc7k/f9SLfLbusGP6nanTPIVwwZnL5PZ4y+9jSpJXaNqOJC+kqMG/IzW+iWZ+w+tCN48LmKYJeNCV9pcBcUjgY2+kLQlFUnMBa+58msHNK7gw21I1C0H7Eg4hDvJlKck79t/nw0CBA5f3QPBYrvT8jqHN/JBBnuB0cH/+aBKsQ3Wcpm9h2qQeBjgEofanUix/q+vkbvDEw9XUtJ7JhBxePGW8fc2zFCBag37ZXKpdgbh13B+XkeWgFkEeclpsiWbxRgeemZpHvlwvE9R2k3C0QFbA4qlP+Yvut0Cv4MuBHrLKWzmMhAX5nPF3myFks6XxbJ2qeUJKxW7OGrlYJFCpbFjkO17JHUNkdqcxG+G6yIgyDxpHItu0lC8YpzY9RtPwSRV4vHy2yo/TSHSKxC/zlJJpexWlyO9ZewPGVCoxrd8GbJUCygw
 jPNMMxmE
 Mw1cDlxB+mQKssp25IgC9+T+OMERGG6EuDHjmqO6Hm6QUsW7QM1Pg+S57fSy6VXISKTChgfq0B7f9EVTRiLyWoACT4tZK0qjA6pnHI0fS/m2Bu++fnXKs81vArGqerOMdP9iQRTEwuaKGiZvt7M+bCX5+4eEJ9gp3oebM+t3jqEgoFQ9BBcgX88kgGcrnJQWMBKcHZPm9+wXQ8MTVwV6V+NPREsv21bFuhNM7InwPIGcS39x9Fme5esbPxHERF3+MBYUNIT613LAO0MnaoBBvwcanXOE9MhRbIWBidu9IDKkMNFM4r7RcprS01Dpv++nPEig5Qbr2lLb7nns/q6udYMthFCei+s/Tuy0efyb9tlSP43McZCMaNTvpo8hx1Kt1Yhirta4WWMCTQADQYKuZTu7L64viP9RsH8hICDpEI5mczoPhM0f/XVU9T24udCXozoguPGtaoZkLw4Vs4XFLUUb9lEhW1GwVgmf5dL4jx8qsvANLaHDpRju+N/zEKW/eVC00PvgBFiSsmYKjG/KxOtFGsQIarHWEvea+
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


