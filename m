Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49303C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16736B0101; Mon, 11 Aug 2025 02:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDAE6B0102; Mon, 11 Aug 2025 02:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A033C6B0103; Mon, 11 Aug 2025 02:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFA96B0101
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:44:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05B061A06D7
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:44:07 +0000 (UTC)
X-FDA: 83763536934.28.3A140A7
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 44CD6140003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:44:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=b6N9SLQ1;
	spf=pass (imf09.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bFBd420UAE7CxBgVRf9/TsqxiqblPzn7tE6jkz4N9SE=;
	b=UCtvNORla0qcYdtrJA/0EXiYFjBwE9AFeJpzpU+wB+fIGwAvc97QVttTVxwHr43GqK1zqJ
	XPOqK0miXuooPLatDPLTJczz39QGgRimGmEdnzQgE/h5jl/disVLN5E+iVdu1uiKrOd2V6
	JhZfw5/fe4+AtklTLQ3SLHY7O+fyBlM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894644; a=rsa-sha256;
	cv=none;
	b=6quk48GtRK5XcZ4G3Q2RvBE+8oGcvi2rPtaTA83UA+Kb8rW8NwEswrE3/kS6oQ/d/tbYa5
	0Z134+1qXkDp4hCOtHSKsgbRgUtvd0NHQkFWO6S9P5LRrnj3EV2bbQzYhqM3D6pRM+VCpT
	oHRi4zGdhQ/c8yE65ORzt8w8HwQDpic=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=b6N9SLQ1;
	spf=pass (imf09.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57ALoHsa005177
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=bFBd420UAE7CxBgVRf9/Ts
	qxiqblPzn7tE6jkz4N9SE=; b=b6N9SLQ1NW9erumHBiUHIT0XxytfKNaiotwZ3C
	Nx1niZraa3hNo5hryrX9qoQvHJEmhZm364fThroFjGE+12QxyJ7BSUg+GtJv7AXA
	XqsNivuQd/zW8pPia4UOZ8VgJcgyeBe7KfV+StxQO3S1qqtRdVMorGgI9n6WchX1
	T5fJb/PCR9MyWhocrl6LOe9sjo0ck7haaenPYVBvSvwefLqSwn+PYlOpb56sAhtj
	9Dlu9WMtMuOyXu4UYD2p/BWXX/Y4iIMV3FySZPtACXP14sJb1F1NuFT5KtQzwu2J
	36SilO+c+wE0o4JqjQNLCR21IcpVrPmJ7wsrVivtMTIsytNg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48dygmba01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:44:02 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so3973227a12.1
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754894642; x=1755499442;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFBd420UAE7CxBgVRf9/TsqxiqblPzn7tE6jkz4N9SE=;
        b=w0jJXv2EWEb9ptOUbgK2wa2aczoJK8PL92xbMhh4+TV0pYB9AYy9rQOgmdI+cDGQun
         Ti+VjyzGmFqMoAvLEVKJdHmrr1z+OT+d0tKs1dbdujn2SiV/vWXSEvyN5/84KG1jitSK
         uqHGppVAg3jC9Plwh4L5d7HePgwxkLpARL9jN7xQl9E0srl4geaWWeJSmsuNpD03aG+5
         qN0vom+IVraMLbxOaKFBp+7AL9ljo+t5K3iiiq+TqfWy+g60wZjm2hrVJcQysWyKgG8U
         hRFn8WeZYMccSIQBToSeP0KS9gSP4ncKMP9yJNQTAGVJHaUWW3z0W0gMqRvqttvMldx2
         62qQ==
X-Gm-Message-State: AOJu0Yz9aXsZzx7SQPwSU+mzgewh77kLHLuB7k4wYB/tGl/GKLhTKBB9
	heovma013tLeST28v2iLxrSpXtHbrDoEZMekehZWkB1XD+346DGk6uwy3sKDv5Y3Y8wGc/PUqqg
	9ndNlwjsptAiumXJcxPtY17UHcEOl5Na7+3BKQMkIewTPMUvP8ulD1Q==
X-Gm-Gg: ASbGnct8BeVPvCCMGa/2Nf2ZockBhLPYhhqDeLNoz11NjYqAZz+9I4vkkaJEGunFN6d
	fj6ArUi8GivraAkiRhi3NcNBMyhy3rEEGU/lQLyTM6v3ZEAh7qGxhyHoQ+HwmC+mPaXJzS40mv2
	0W45OiPE8GqwJDaGp6hqAWJLE7tlz3jqSco8QImgp/0U2yYe5OTDTEftcB9ntaxNU2bgU71rWx9
	sddJQdy40eyBA2ceKOBfVci3I43vT5oyxUB3aRf7GJFekDY0+s/S9+6P4iJBL2RuvnC4bRJXpTz
	HdpDI9tjpOChw0RrqJIUOoxjkz2HADAiCKc+c3kOF0I=
X-Received: by 2002:a17:903:3c30:b0:240:86fa:a058 with SMTP id d9443c01a7336-242b060dd8amr256923745ad.7.1754894641927;
        Sun, 10 Aug 2025 23:44:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6lctQcOCf7in+SnIAmNq5lt8hSwjdCO8aLBQuwt02LQOpDXfrzrlYBrmu9dI8CIjvROvR7A==
X-Received: by 2002:a17:903:3c30:b0:240:86fa:a058 with SMTP id d9443c01a7336-242b060dd8amr256923415ad.7.1754894641405;
        Sun, 10 Aug 2025 23:44:01 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89769fasm262632215ad.107.2025.08.10.23.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 23:44:00 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Mon, 11 Aug 2025 12:13:54 +0530
Subject: [PATCH v2] mm/numa_memblks: Use pr_debug instead of
 printk(KERN_DEBUG)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250811-numa-dbg-v2-1-7842aa2d4c41@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIACmRmWgC/22MwQ7CIBAFf6XZszSwWoKe/A/TA4W1JZFSwRJNw
 7+LPXt5ybxMZoNE0VGCS7NBpOySC3MFPDRgJj2PxJytDMix44orNq9eMzuMTKJWA/Izmk5C1Zd
 Id/feU7e+8uTSK8TPXs7i9/6JZMEEQ2utICOPJ62vIaX2ueqHCd63daAvpXwBO8EE3KcAAAA=
X-Change-ID: 20250808-numa-dbg-62a8b2092c56
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754894638; l=1411;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=eXcNlthP7dcrojBLukgQ670kaZ2NUSxXkL5fjwqYTes=;
 b=AgrMEJScKwRgsp0tCJx0v1RMIG9QI8In2fp6iIwqQua7TPixOyY0KmdiW1txqhyoCJCfXi5Ut
 AmelaLjEqu8BEmgO0nsVDXf0y23iqo7B0bZGJk3Tk0E4xHLliOgS99c
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDAzNSBTYWx0ZWRfXxvX6WRdQe+fA
 +QfkjIkWY+wmSSpGBhu/t8qaSkDkf6rz6zTHJi10jp8qWg00j1ZCKDOUHuy1xg1JmZayjMJhW6b
 oaWkTPmHMvXjDQ2PaPIAA+x2qWojbFUgn/ZjvqsWbkaMlRfe+h8qf0E45LsHMcsw3KWrgaoqbfS
 NSgKYlAIZm8Lyl6aUzPM9EznmwRbp8CtUtYCZ/QLH8KfICTAebmqK99Pjz39TXnpoPva4i8Jdqd
 ddeEP1Dw8ZJhU5PF8o1tnbaaYFz5MqRvSao6DcHOLCdZjvH6Ajxr2t2WHUGVkSTHpT8L7emDWQf
 P/2jINrjvSQklHk8RXalt8zY5DLJPHQew5Rqzf5k1Krtsiytgpf8SlzwNeiS4lTMBYcGIhaH9Nl
 Trthj0d+
X-Authority-Analysis: v=2.4 cv=FvMF/3rq c=1 sm=1 tr=0 ts=68999132 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=pGLkceISAAAA:8 a=IjtafaaC1MEc7PSuPL8A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: f_GnNi1SsPJ9ieFvHGcC232Q_fk1ENr2
X-Proofpoint-ORIG-GUID: f_GnNi1SsPJ9ieFvHGcC232Q_fk1ENr2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508090035
X-Rspamd-Queue-Id: 44CD6140003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ucyteurxf1w15k3zcyct9st8y6bi9kcz
X-HE-Tag: 1754894644-298142
X-HE-Meta: U2FsdGVkX19kJUM3JS1mW1WWyL714f7riAHLYrYt3hK/pX4dKzmjoFElP0eiWVb/JYRYrYgtfhmUoDSr9OvjdbMl+D8eeeNLbX0OyqRAR6uBpr7KCaZY4pHdrnxmQI4Ghzv0v612NKYS5qd7iQUEG9FCxYzfqYHtiY20i4ojJCBzTy0wh4jyxf3jhcLF1CGu+RLZtMJwozeEYUDLuSouZ/U3A4ekeeQ3a+/ehWVNlPTjhN3D7s3Lo3Mi6lC5A2dEz9uS8hvvm8jceA9zlRPhudqip6f/SekyFwAvcmOUGAagTXKwLU1UeWXLUWdzEQl/Y45jOneQksUPgeMIasTuGljtz24SdUx3Wdydb3jIFO+hm7YSG4xHa/qEPaSAp18gQ/aIF8rvPvRoSxE/dW0rCKMHEkR0YuqQZdShWab4mB3+Rfq1PUQJ+7v/b/L2wNYHfkw1wu/XzjoR1V+Fy9Ipd/HfhTMJPs1yqpfH5jTnrJ/SSCho2NRZA3a49bidFjbzZFvWxULbe1KiMWwexgEK7aruDGqCHlpgNjXYLYsDNKqmYTSGrIuAukJWD03H+rg8bzCLheE293LN2xe6EXeEiYVRktRVLuMgFHq8TPQs7SAGEPWTHD5tA398iUsWZ3KAbXr4quLCOE67E/nr+Vd7dQekHOhHxDC8MUoeXqhqJcyFXoMTycObVzV2meNUz32HNmjryg8XLMoCRdagxw43RTg+RA4qRYGT5mQYWgKSMp9Lr9wXhuUMZ6+LlIC04BEkn05dkkvPGR+JGJRWcZV6Eo2KZ7bT3UJ74JWod8VPuNkD5lRqRrFbYzWXYKyu0uo3COOzIb55AAxYbofguaiPgUCGGiPeXtBqcOzw1DC06XIaM++B/BpBmQjCoR1HIepq/qf3f8HVkEzdq4QgmJN1dlJN6SZLv7WhCdLjkbDHti5xhKzyOMdNVJEVygRD6YZl/1ZoY+TSS/LteglpFLv
 qbfilJ07
 2+3NLTVIZRXNbzT4ZpIrnM/UIjwDjoCHteTd8dFTDQks3IK/AJgVZqYnO0w6Jy895Y6QcDj4u1mrv4yhp4M8ZCnXiY87Sun3vMFFa43iZLx30pQ3/x/aQBRoIAWECe5AqCVdoZIfggRdnQLSEE6dLRebynN1qwSr/j/9ehgxyqnaNVdFvr609nJFszwTFuK89GCmSaccu42kEixCyipovL8I+RUBsSGbHtmmaAcgsCXOM/a8H9zSTfA4cdRpI7R0che6XRW8YpkS+ZlhLD2CTSlbrMkTzudvasuvxJNgTp2n8MJpSKwPD8h4umG72IDLxZknFmTpeJ7i+cZS3qOF8TYc9HwoWwaMrfsOTmRyhxdVa4/YxlTbjQx2vnYXew1oVGRg3JKcki3BPpokZYgore4weDWm2EoiwjLLfNGcjn54r2zPs0zRA4droBh6D1mSjxe85G2ssI1M6PuY047hjcJkJvkOfhvQTrlvyYjJmDMqPNlVIHc7EIh7eHU6YU5NlM0ISjBKsOI40JN39A0yjsZg+zTLxTLB02GPNAvgZGeEk2SWmSrbPml2K3gZ+kSiQTGdOy9IkS13F6DW7OLeZrdbR9mVnfPtqTV0mW7fpqoDc8huSykwmYnHNQDnf+ngsGXtg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
align with the consistent `pr_*` API usage within the file.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
Changes in v2:
- Removed printk header as suggested by Joshua.
- Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com
---
 mm/numa_memblks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26cd1929551b4ded4a5b 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -2,7 +2,6 @@
 
 #include <linux/array_size.h>
 #include <linux/sort.h>
-#include <linux/printk.h>
 #include <linux/memblock.h>
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
@@ -76,7 +75,7 @@ static int __init numa_alloc_distance(void)
 		for (j = 0; j < cnt; j++)
 			numa_distance[i * cnt + j] = i == j ?
 				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+	pr_debug("NUMA: Initialized distance table, cnt=%d\n", cnt);
 
 	return 0;
 }

---
base-commit: 479058002c32b77acac43e883b92174e22c4be2d
change-id: 20250808-numa-dbg-62a8b2092c56

Best regards,
-- 
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


