Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25303C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C506B00D8; Mon,  6 Jul 2026 04:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D0B6B00D9; Mon,  6 Jul 2026 04:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EAC6B00DB; Mon,  6 Jul 2026 04:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDEA16B00D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:43:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 412EB1402C2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:43:59 +0000 (UTC)
X-FDA: 84957714198.05.26BB910
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64526A0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:43:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d/x2u2AP";
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zqVWFIRUuTBbYnsOMemyEgk7HMcsRAnM3YRqML3I4s=;
	b=c2QRHYHA9F4DKrkvClwY+LxPtz0SAyOt1gHlVng+MN5voT5vGzARsP+SgCboVHB+5AaLO6
	jLI49S432eFWu4NEbMNGUPs0MECaBgBzDt5W/N/af+YK0f5kSTQdlSt8z1qYMhy8QGxkP4
	Q9i3Nl/TmyVN/zV4s0obvn5bLH9cikM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d/x2u2AP";
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327437;
	b=hyULQXRCLxVX8vqX06CM/Kl0rBX3sD5AigLmVVPVxKkauq7KLv1e53vdFIUQrqcI6PYGOC
	aANHB/eAfiaaJfRQdhDK9y07gY5bBrkFIWeRkh7ZsNxxK7ZhkMRLC/7FIi7GlMpglmovEm
	SuGZLXhyG9XFGClFRV7KNNBdxe9eo2E=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3811e59df58so1575266a91.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327436; x=1783932236; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zqVWFIRUuTBbYnsOMemyEgk7HMcsRAnM3YRqML3I4s=;
        b=d/x2u2APqYtz8/NtfUHo4erDj1IldEOsvcvzkIJqLOWEs91ptr+NWnqE31A75kBlMP
         Y9tNKzN2SrUaTxeioF1rr9U6iCgspPXvqmXdOnPNuaSwkV09eSOt59yLcGx4VFCl7tfw
         6MkJVv4WfTXfXp3L6f2yXybSPdnuXM8CFVAsYb5arMbw5ZAPpNgA1KIZXLuO06lPx2l5
         EmjKAsETsJ3+Rr9Mv3G0zb+hNZBrjWnX3+FZqRXm62ndb57liC9/G72ICzw7BiQUf8yV
         0232zFFmvrWMNBrVV2Gi0Ygrp52ih1GrlL6wFKAeYEcSXi8zpCo2Q8L0sZvSPaCJdEs5
         dCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327436; x=1783932236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7zqVWFIRUuTBbYnsOMemyEgk7HMcsRAnM3YRqML3I4s=;
        b=EV2ArEQpOfg+tIiOWkdqXuAQG+wYxSYzvEMX+Pz5mH5w2HQIZx2dPMVbeqJgYlMRAQ
         DaK4sAKcjJiIKmdOutm+/EaxIN31mqpHm5FOUWqKoLGWjQ+PcmxUMu4gawweVM5Skn0+
         JVEURcDNQR0TuwNS/7FyN+fC2bmxtMbiHSyIFDiuAv47EUHl5ItPyv7hSDGnmX+KJ48h
         CdK2tAkanTUsBys9f6CYowldeYJRbujNeFkaNN7yzDY521S25t17q0oy9Ysmd1/Q+e5Q
         KT3lbs6iAFbguYesDxL8lOmMRFZ0po5i2csYEnfR20c4uR5OAzKhAUq2Y4idAo+9wHOL
         i2dQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpgp6FHYmhZtrlGfTCq92maLEManZj/D+mHi7Cbf41reIuKyjV9ZMsrrAGSieSgyA5TYvFuef4HOA==@kvack.org
X-Gm-Message-State: AOJu0Yxsnfj1zVWbl6FBG+gufbJ9WnroFixUnNZ9q+K8FJau/cEExNhq
	by4cLN16kfzYWgGnVjIEM4L03fKpmY5ukR5RgVYunmMsfBL1ECOa0Y2F
X-Gm-Gg: AfdE7cnHcPcq9dqaHHEFQTTSih4tTxxN29NCej7/6Ll211PrWsZIz6r2nqndykue3Z9
	kOoaLJ3mtyPHLQ8PelV4yyveWkYKwxPEBGbqLmQSAqboesRMqOIv4FUelpAFDqpb4VqfBD+1kH1
	5DpVOH2rz9UsGfVkDsAZV0VcnNot++QTPd3PafkEHNrbHCiyrkZPfC8lwdJrWlJ5Qe8iIVv93jj
	++5FYXd1zMXcThEVtUvr0jTOPe3jXM7ns8a1s6oOdETaJV/Y8GUXh/RQsnRs6ug4ykIRbNvWRQp
	A9lKinVwpcnzw7QhQN7mVveCvtst7LLy1FUGQ+uWIoWxbESuLUv9LZRGqVnGR72fXaLkFMASfsX
	MdyudR7n4Qg4aqYJqliyUf12E3GAK8eZAOy3pGyYFwE9xatUjK1xBYaLpJT8OG0W7XuFV1Buqil
	FsGsyWwbPSTHR0NZSBhW6naxzY1L/Kc0V11aY=
X-Received: by 2002:a17:90b:3808:b0:37f:9ce0:af31 with SMTP id 98e67ed59e1d1-3829f4e6e58mr9178683a91.28.1783327434882;
        Mon, 06 Jul 2026 01:43:54 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:43:54 -0700 (PDT)
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
Subject: [PATCH v5 1/6] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Mon,  6 Jul 2026 16:42:27 +0800
Message-Id: <20260706084232.177786-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64526A0009
X-Stat-Signature: tujkf9coeo8ganeyd7xfi3nnyoybsy3q
X-HE-Tag: 1783327437-648158
X-HE-Meta: U2FsdGVkX1/2ed0tCYYf12N+cvJDbKaggQ+PrA5fCzh7NphoYKbTMh3aGQLafrkMDx0sQKlHgoBSBhk+1HfnBmunlwFTGapYCQc1QSNOQw2lX4FkvDgtXbm9c8UIFPPL6hhMJYXtHSdL14m6ZAa5hV5dAKQSPA5Pa4qWCPyhJGcSwon43R709x8j7q3RgstzniJuY21QcbsYBNZX1MB3SPyVseSKTbx6fJg+RKqelKZ7nWPEXRL/75QFu8IC3kTKALsYYvAr/DYoiOzlD/9HIiBn/Af3+oGow5Z3hXnJnrxb+JG2G/0o1PL2tAPm1K9ZFZ6krFiLyA5pm8UD9K1bdyhoLBaUCnpZ7enqcIF9i/6QCrpKL91Hrjwy217kWNEfqsdSMD4tkwxesK6YVm9LgmXSaBohAcDXU9iM7wSPtF/9PnEMgR0ldFUUEuWAEWewqo939/cpTOLwKR/4aa6ha/O4CeR8WERspwlcR84wLjq6+CzTHL1LaD6oUroE9vbuiMI9PHuUNzxVYPo3ZxuAYnhbwoTTmOycAeJiqWEjR4zUx8JQ6HaFHyi1Hv2NR3iucDj+LCX30b57DCVBRYdoVqmuXC2CHww2u0ovY1Vxp/PkyDA+/36hcdkE6pdVrFtpIV4MqpfKRQ5Tm+AtiqfofrRU6DkoXC+MRsyG2qPtSgU20a8r4Zs82x21ghoe/9nrgLqcmbV53Oojr5kPHbNzfbw48LeG/T8I8Ds+1crDtI1rBjP0YjVaHLqDIAHFBZEIEfZnLkTqrKupo1KJ8kXBCOwgrMaXZytH/qC/w0+cT8remdzNUh7o0w1rSgm2WPsrzl4/JGCnGSqnD9YV0n0KtzDFxBqZo+BEZXzm1+Dszr7q/ZCdROLd2eAW6iWjQnvSya2XKD4u0S6OKZQUfFUAVAVT4BPNSinK7Ntql7vKAV41tlGaDJj8itGVryyRCn0vOWzAfqF0mbHgvx7cf0a
 ddMieuB5
 a1zrit/jCcWIVpAVItgKRS3GS8Frp1qNUbBSv6MqioObpAa9vYexm2fVo3aITuo8oAo+evDzXzIXsZ7GqFTEHq9g/VCZguC3OQKVP23ydhOzQFvUKQ5ANAtZn3qWWNL8nFupc773LNqIXdhpSol5GhYV7Nnk31VjDmYsWHdz1/m7kK8vXPx9HFZklGx7NsFz0QZ5gXzS3oGV5tbphX06d7rNTLkuTsz3JVSGxRuJhHd3Ir1ibmSI+5PSipBV0iLPuZJbnMlc55VBBiFtqdRYUB8zODYU2cVTmxIwaigcwWcQmvS+b4CmhWPDROxqAHVHIcBoMstFdw3ePG4Vp5Dskw0wBKP0oSDIUh/E5R3LM39IqSnIWlttqqGbM+aB/Rw5Id6L2gHTokiSATqUQy27skV6sZdtQKLMiZ5pb/BJD+1Lr+yB7DsW3X1hzGUp+hmjDuu1MEmFPASScLCVG6h3s6cICt9unPMrbpUPOJ0RQsnbDPijoTSaakFGHBBeHxfTfOITRLw413YatzPP0vLV9BAYQmzG6NOFiU6IB
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


