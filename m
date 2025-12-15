Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774D6D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAC76B0024; Mon, 15 Dec 2025 04:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2E86B0026; Mon, 15 Dec 2025 04:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1BF6B0027; Mon, 15 Dec 2025 04:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B61DE6B0024
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:06:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80D825D941
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:30 +0000 (UTC)
X-FDA: 84221124540.22.6AC370E
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E8361C000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DG0Avt6h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789588; a=rsa-sha256;
	cv=none;
	b=6nGrvPIEC/0GzSVjUq7+7QZhggtzvg2cWN4gzdlEbGUkXJCJqG9V6jDPCCv18okGCG7DMc
	rOZVJweOBbwUKDBdlGXkRI+DR1ANFbMcHI2DTIqFtasN0W0iFt83dDnBSqDURXbuEtPsoR
	KKQelLILIhGg8I1ZGlp40qzryPl7QLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DG0Avt6h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHlq5O2U4Y391ivye8Dbi23NfhTsn0lBjEKHffIvPIE=;
	b=2dKeWERyMieSoYQOyKHTif0aNJNej3F6QKbIa37JKjUjEdqwlcoP40JtuWjDGNUHERMSVH
	+sNFjiNNIMmeIAiv4qul4h36Jgwh7X2Lfpp+P5FshzzQb8gLH9UyyoEjJ2Bkf2DmcGHtU0
	IJED2HtGeGqTKw18q3Yyg6r61i3W2oA=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso3992421b3a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765789587; x=1766394387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHlq5O2U4Y391ivye8Dbi23NfhTsn0lBjEKHffIvPIE=;
        b=DG0Avt6hhMgeageBC3K/CDt5koqDJVBaHFuFy47BVF1lxfWjby0KgzibAn+HpdqwZQ
         FFiiRlyV2wVWdMTkl2goKkAbi76la9hkprGgScFBEIFpvWJNQudNvla1rhSnvds2TPXz
         m+5TCvNzStaGfk9vr+b7dcCUC41oqmSg1WgAFiug1emWmpC+bawXJvQQFQi4Xe15Vw9R
         G0giP2zBuHOfCB3+prIKTpfyTGQ7syD0EcU9RQhcTAmVHDE6eq8bSR5yTCFqni5n3NP/
         3hNhRCmB4JKN1zRJl8cLmB1/yqsMdrsBRS+ObkLHVXsUX0P7BaVf9DLZfEvqjG3VaI9q
         oA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765789587; x=1766394387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fHlq5O2U4Y391ivye8Dbi23NfhTsn0lBjEKHffIvPIE=;
        b=H0Dy4Oo8x9GPP82/TkxyEQ4hwFR3O3LrV217CDV8iZv5hPrlHH7CwKo1XuLkXsW2Nv
         0wkOioJJfbdxL2o/ra79a8PI0M+gNHRCvAFW9MYvZ1VnHwRZYFH5XNtE83BAFchZMCeP
         ik7q7wz2jXL4hamPZiLU8kDWDrgz5OOcap8QmplroNq6omxFrOiljg6sXm7Ile/28EK6
         bDFm9DJQRwmVyR6GAlcb2hIwUhsUGjc40rpxAE3r400S1Zx7O/4eczO/JriA2D2GDY+q
         jC2eaQ2LQi/iXc2ND3zaXpm5vPApAxoM1024a4OOTrSUiYn6vBNJ7Jf2vKkTkBLrt479
         uJZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPjnBpLWAm/8Soipu8SHqO+zOVYp3kMq4oOFRuHbsigkAO5fi9IU96lIO1Lj3CoQh4qFiFrrUh3A==@kvack.org
X-Gm-Message-State: AOJu0YxzM0jSAwydFVpdWmhYISZ9QB30xmX3ip2lzrjje1rpwcunqWLE
	zQIBqXn2U2Tmt3zzm2exyc6nwK/dNwOxcJiwp6q2glOhL+ZAJdmIdOA42yYJt/LLWYI=
X-Gm-Gg: AY/fxX4nysZn9NqsQHOGpO73TZvxd0UC+505ypr5cnSsu5660avWj8GOxHAlKAUIpuX
	HY37Pzv+Cf0oBjVPFvRiiS8D3fRkWO74sGyG1R01dxjbmgh4ulH7RdmSebT4TSZOpKnIkhWgcN7
	L9grp5bbRdqNUfRud+BHezhn6VeLho9B67JOEhulr5N5EaigPgeQ9WcB9Z+fxOTWe84q250eLtC
	9udPH4X8lPRGzlumDL5mRU0yrhll51It/nsqjzmYYvD70BY3eQXdvP+CQmDNFXvRVdFRjkK7dQc
	XuAdyw8B40kOx76U35foeFgO+Of6xhIdQME13A0pbaZ3L11oP7ccVDnVD3DO0YUrZZ9E8z1OaPD
	JCt9WGzIiobFzpR0hLGHL0Fh45l8huZAGVadNv2Dh4ZCQg/6HC5KvBACtcUq42QBBnl8VnMb7Ra
	80jumMjrr3JSdPXuuw6EQGyI+/yJ2JcQ==
X-Google-Smtp-Source: AGHT+IHYADMjuET4kHZxSorC57UbvUxdSQ8+E3XkBJFAdBGpGyt2UvW855XokwZ+T543AobCcPohQA==
X-Received: by 2002:a05:6a00:a381:b0:7f6:2b06:7134 with SMTP id d2e1a72fcca58-7f6694aa6dfmr7999408b3a.32.1765789587269;
        Mon, 15 Dec 2025 01:06:27 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a40sm11993160b3a.46.2025.12.15.01.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:06:26 -0800 (PST)
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
Subject: [PATCH 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Mon, 15 Dec 2025 17:04:19 +0800
Message-ID: <20251215090419.174418-5-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215090419.174418-1-yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E8361C000E
X-Stat-Signature: 7merztguh9qa1kffnae4kknj9jm9e4w9
X-HE-Tag: 1765789588-455233
X-HE-Meta: U2FsdGVkX1/LiR/mYbeQKUxBsV8eXAdIHKEbBbDdD5XNj4OO5Y5YRnhPDpyimYce/xhk3wVOmCh6WWrKk/dHocSiZsZJsaSga/tKUO/1TfGRaLnkN7E1aGUaO3lNoDE0mdJ8GJQcQC9CvgihuiYs4te6YYna/glnnFesTj2b0WcBWABeUHGh2/GJIKg/T7mSAPcUqY6YrJSikQ5YTHZbG8L9QaOkUpoEDxa6gz615FMIUph0LuGmjmwpSzkYgoTND/7AieT/Shn6i5QqZ4jxocKRR2XTlqGdrPVA/x6gEU+fxTXZePtO5wzi9DDvUO3T0jnL1m0VyE1wIHWnfXS6oa/NV8LMKBKlpeofj0UQA9urVOKpy2+x0AWx9iGB/7hlI14gpKx0Uon2gGNAj3gox7o0RKeoccnatMlUueqXMz6dSXSvR+5k9iLsckS1xAOxhgrMbRpLiXwQmie17MAvtcqaZt2Zx7GgvtW3DpEcULxWYm7DolJogYNa+aWH3JX+BMl3Of/xl1kScFnHPEb+9wr0mUlBSicbnhZANBiNOoyghMB1q3WAer1P6BaefmYHKtAaz3H+x2n+c2E5bUse+SKTbCyASy8kqPPEAWFD6ozi8oLc+8+EAiJJBwToN0Ykkcha8dPH1Ck7QivcOr/zacvxSu5iPYkqntG2MFN631dNNGgRRqKzBRXprkuQAkB1XPRhNkSO/nLT708/ookQG+5bC7MWuGTWN3TU7s0Kdu9Z5fU0uvcy8aDOUTNrF23qjjtc4OuP6z1+IeDzCb0zsLU6DCc5fHyRn3tU5XfLPdMZ3LuRaAXNhA1ce+SFZV33CaUfJUcgTZmlyUHq0WtsMLK6AE1xCnQ+SOGWX5BrxKMXJdQTh7+y73sOTB2itz7++AWIsRwlK9ggCdr9ptK3iYZh29bws9zoLA76NjcxnhG7Zx4RpGqG3wHREmUZ6Q2WukrZfIKCH5PdGqMyGDx
 jZZzX5OK
 B1uW0DbI/YOk0OUFIUw75n4PSBqz4VPgb3cXvbRl3k85sDaCMXghzvYSieIwTcgih2ky1LZK/36qSORcAhs64VfZ7+0R2I2jqwWAoyzDjeNEdmuIiS/bqOB+YCgIg1AqbrqWceVnPsKBO8SgH10UzPL+WgEmRWdleroCNLEGcF89fau8ZCN/Y0zRCSEQHYDZYu89DmVmdo1d7U1+dSmAfnqid4NO7PleRgHx1riBZQcfNTbobqqNbdTKfGDsQphtySU4yqLFfxFEmYdUcpQAIeX3Ii/3Ps2Cx1tDNtqyg6Y2K1zSB4pOIZ5a9QplpQDIMpan9XJMF0Z3bsxkJUt5hBrULc8ls3xA5cWTF8LdDmc/xnr2caYLQ8nwcSegxs6Ec2O40BgLceckh1bgyJsc8JeAHO1+v/kJMPSPFKP0VUzlpO2kkjsIYYWJSAOmBMC67eFlNFok9nZCMw8i+hJcG0eCTFkGwQhwLuCIx0r76L6QkBrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
reduce redundant operation.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 91836dda2015..a8723eea12f1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2432,6 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
 		cond_resched();
 		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+			vma = NULL;
 			progress++;
 			break;
 		}
@@ -2452,8 +2453,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+				vma = NULL;
 				goto breakouterloop;
+			}
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
@@ -2470,8 +2473,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (hpage_collapse_test_exit_or_disable(mm)) {
+						vma = NULL;
 						goto breakouterloop;
+					}
 					*result = collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
-- 
2.51.0


