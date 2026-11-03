Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C509C606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wb1hWT1d
Received: by kanga.kvack.org (Postfix)
	id D61116B05B2; Tue,  3 Nov 2026 14:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9B46B05B3; Tue,  3 Nov 2026 14:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0816B05B4; Tue,  3 Nov 2026 14:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96A8F6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:41:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3592D14052B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:41:45 +0000 (UTC)
X-FDA: 85394827770.28.FA7566C
Received: from mail-dl2-f3.google.com (mail-dl2-f3.google.com [74.125.229.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7748140003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:41:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wb1hWT1d;
	spf=pass (imf11.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xezF0fn8IDQBSoJVFqpD27Lisy+bsjzUf+Sl1jGurIk=;
	b=byQ4AgAc67Vs1AE7LkcnXj1Vt6Sly/pcjRpS3+9JtKHJEhaNMP3sHeCZafrBv6NBXgji/X
	eO4JBg0i+lWy1+jt+enAi2VWIUW8iBovxwyjQ5vD1A865aVECxLvPqAGknbhj0emuUUQI5
	YQUuGcOPBa1C4xiCSVYSnIhyGO6thkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793734903;
	b=ZiI0FS29lJ6GLZuLFCBKLUhU/7Frk8ffpl4nexWmuBWSSCnt8BNZG4z9Ghpc9Nx6wd3p50
	WyCCumT8FxNojsMGTKZu2GV+/bbzjSX5MLeDXQKLfGbu6ohAJS62dRWXv6zM0p6oIZQGk9
	X20i5iYdo4N2Hpe+ATGB1sq2Tn1Lztc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wb1hWT1d;
	spf=pass (imf11.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.131 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl2-f3.google.com with SMTP id a92af1059eb24-1afb6473195so145c88.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734902; x=1794339702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xezF0fn8IDQBSoJVFqpD27Lisy+bsjzUf+Sl1jGurIk=;
        b=wb1hWT1dFsQ7ycvimhsIHGDYRggsDUAZE3ULzv3xvzv+9NvjB/yR8azp7Nuqbmx47T
         wfnfMg6+VEucz3QVrSfS3NpWJmp4U0r/C9YDN7NRY4MMEd3rtQEKzVDYa/ZeFzkQvLjD
         IPml9E8+uhndmRstIzjVrZOfSHG4T5/2KpmroWSHlJVJ62FRpsbdno6XpVD74/Hyc9qQ
         2PTDZ7z7uWyKfFPeMyxfpFIFExTxP1m5+UQquiMOKeL2ozJBv/iNpZ49Y3Fuu88T3qPk
         TP8SVdwzn0xfAJvD+MQL1nqVS6AKJUZE4N37ayV1pkfLd0DFBBHpYdGcLZwumFooohW0
         obeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734902; x=1794339702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xezF0fn8IDQBSoJVFqpD27Lisy+bsjzUf+Sl1jGurIk=;
        b=cRH9tQXAMWPq5nxgMB1CtyaZjzcGlwj4Lle3Pz+o8+RcSUEWmJZ1SLmpQRrKW1rr6h
         EbxYYkEJs+sX6jtj+ShKNaFZmiVPFw9OxnFyaA9hEbAy0Ti+MtwO1GHWSpndkAUm6QhJ
         Y5TlFmo0BA1NQynXfDIxNvmVjxjNGyP8XNz/ceCuPD8PjCdApqbMW/LLBKBXfz9oiBpp
         HbkuePPY0QrfHLh/9htBwZKSI5PkWIZIzbgqdvelxr0zY80/ytWRa3Gp82vHSRz8tsD+
         qYwWB1npF9jSBZVZpye0wP8T6+oLPDaiN9iBxNpWawDGDFuiHNAQEq1TAyQ5B5j5XB+M
         3f4A==
X-Forwarded-Encrypted: i=1; AKwUvBwj6+c71scv1yQAY8b3vY7X4/cPdl6iIC16ugQntUCs7WFrfPDDTcjeIRtfMfObinL8jGRZw+L3KQ==@kvack.org
X-Gm-Message-State: APuU4Z/zt618wX6Z+ejx3+e1NOKRnhyqRq4UwwmmVdgEiBCyOnmIx+pZ
	laPRTMUew9eqKo+Z62yzRONFMcDozYpgk2vcsJjn1KBWeZgmEzIGZKa2
X-Gm-Gg: AYBFou3cD5MmOJY0VAGHczVDUzMIi33S4Ts36km/FZaaQE8cpuJ+WrOF7mTdXG3td6t
	AFNbOQKJ9554R4PfyAoTUcyOsOyCPEaefALK7FOcwcr3Up/jYMyyphFpl+Dd2tU65Prn/h8oszN
	VpPhheaaCGZK3RficGLI25AJUX2iFdfwy+SmEPU14czIwfYOLQn1B7YJA9hWAoUf+Ov5AxK8aWv
	EUeHfKsiC93V+9f/mZC3bC1xcznazrTgCBfQfBjHDaQh5EjPGDVfRJXmf6sFc4O2CeZMcyWZ7d4
	c7UHOF1jMgYCT2eY8D2Ftau0REmw1G7aeZlaRVSvineWv4rk7x5We2vmX0tuetHacg4M9VZZJIa
	Us0ZGK5T2Hd/0NXwM+thwSTM51bpiBGaOjfbP632cAC9ms/NLbCph1FjzINnV6JdT5M+tvyitvT
	sgdb5mYYyc9ESu/xYI5wTQBzFsgS7KWa/LdKBuizUaCNZJyxOg9Gz9aOK+ryYfD/LNUYBon4qHY
	2Gcba+z4qhY2z3haxItUNVhQA4TMPMd6qoZseY/zH53ocwR91azti1zW7a7xCCqkPYjiUm8Dte/
	BFDnSo0sCFjB0ljNc4czXAL3X8b9mCld0cuGG1dLpuySoLQQOWgMe110
X-Received: by 2002:a05:7022:1402:b0:193:9568:b42a with SMTP id a92af1059eb24-1ac5c45fd35mr19813397c88.8.1793734901021;
        Tue, 03 Nov 2026 11:41:41 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm304564eec.4.2026.11.03.11.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:41:40 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org,
	jack@suse.cz,
	shr@devkernel.io,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] mm/page-writeback: avoid overflow when reporting BDI byte limits
Date: Tue,  3 Nov 2026 19:36:26 +0000
Message-ID: <20261103193627.71959-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7748140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hetesq3otbzsg6qmf5epspppawktg7s9
X-Rspam-User: 
X-HE-Tag: 1793734903-146193
X-HE-Meta: U2FsdGVkX19HRcHfZkWjBisMGKKeWzI4i5Wx0HZm4Bd1g/VrWjdHNHE0RxnDbCPjm1dgxOqUG0JR/C8YdO1MO2wTChu9LaKXwOHBSyySZZTiBd3Wy9e9tPX/vvxg/uXE81YcGv20UFMptd2OKZ4WFhfAZ3sj3Avh5uqR4aK+zUwS3wv8q5AemZdRzlpoxkUuScIg7CTCKyko07lQj3HMtKOSlURHQZd65v3p95JQL7a2Zx7rPFbvH0fjPo7myZNc7iDCEWRa7Vx2Jhj3i7tzdLqpeAv/cQ1uANXPqndNv3L1jcpkypYpC6MRcUZbbRznoyGh9h3yPr4gjSJOyxGGCxGEU15X8Xp9zKvU//FiAlIAeB/FMj4Ul1dksltWe+MgrZB6NWDnndJto3lO3yifB/4gmEDXHlqsn88Q3pO8ax/nfpTe3tZq9Czb7o3oQZsLxIVYTJV5OJFiyMCf57LkRC7lJTPd/+L85zsRBkmEdIcXTpLHMKmWQUkL25L8brz0D4LKe8I6BAmqzF4HBNRz0Wp3JlEGcObJbECAqJIh3Fiv3mdKwtCXXSr+DqR1ppKKgB/NiKeUFzbawI01Sxn2vf2H283bY6JC9L6lvvpypNn1jJ2wiq5NluhXJUHXEsHM9z8ERkujbEZzP17ZLwvRLih5mRBIEYtkWW4xBfaaXS/UrGLp1Z9RZTDbkjRP4Dk6rHEe8jMhohgZIdRVeXEal2JlN9bzAungTePh79Fk9WQDvvZLYRxo6EO9HeU+eGFFQccmDn2JEBlZvXkVXTd+Vr04CQKtxXjnBcqsNsEov7cihYerg74IVa/jjTkjiysQh53nklUQcmwUEAG9G440RJxo5X5GxeWCMisoqAPNpITPF8VlmwYqmg7oPbG4frBgRcA+dipIq5RV/NmIxaH3pSUN/yAf5e9oISb4ShsymTVDMnmfSyuKlpMysTCu4DCVzpVkCmSIHnze8C72NTA
 FChJ+G5a
 NZK207isNWzB/fJ8JJUVaDjxik/Rt0pDQtR3mvJK9VVF8aZbSiJ90zHaaZ4yz+peG+KtdbVFnLUvEJ46REi2sZI3AA9MPikHMHlRbITyW4FC9fPykqaOmiYEwfjyBqfE41h4uJ3H6rhsiQE5T4+Dau1/dQaKqZoIP3fCSGgaVf+D/UeA9mzk7c3bDeLRIw6byxdjndlxpmesFUKcNrpBF5wnSQH3NV3P+Bbgq6wt+ZGYM0y8sPZ6rZo4ypCBnmmqWmDfdvInO0me38uCdqpdcS8aLyIZ3kkxjMvvujq72dojFikI43zLJWyinrNKhBFA3+dk+PLEWF9EB/WWglGGdzHRa4s23tKDvQ6R1uv/EaWAXo7QFC7BtNIcTP5nlOc3gGMR5hq5EmKX/fO/KG6AqOpfTvCqMAdIo3gtBERTdekIriE47R/r3tOVJ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

bdi_get_bytes() multiplies unsigned long operands before assigning the
result to u64. On 32-bit kernels, the intermediate product wraps and
min_bytes and max_bytes report incorrect limits. For example, with
vm.dirty_bytes set to 104857600 and max_ratio set to 100, max_bytes
reports 268 instead of 104857600.

Convert the page count to bytes in u64 and use mul_u64_u32_div() to avoid
overflow in the subsequent multiplication. This also handles large dirty
limits on systems with larger pages. Combining the two divisions keeps
the existing rounding behavior.

Fixes: 00df7d51263b ("mm: add bdi_get_max_bytes() function")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/page-writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 499a35473e4f..ddebec79d8d9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -665,7 +665,8 @@ static u64 bdi_get_bytes(unsigned int ratio)
 	u64 bytes;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
-	bytes = (dirty_thresh * PAGE_SIZE * ratio) / BDI_RATIO_SCALE / 100;
+	bytes = mul_u64_u32_div((u64)dirty_thresh << PAGE_SHIFT, ratio,
+				100 * BDI_RATIO_SCALE);
 
 	return bytes;
 }
-- 
2.43.0


