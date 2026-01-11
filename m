Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA088D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC356B009D; Sun, 11 Jan 2026 07:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263656B009E; Sun, 11 Jan 2026 07:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FFB6B009F; Sun, 11 Jan 2026 07:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E366B009D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:20:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0151D08C3
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:20:14 +0000 (UTC)
X-FDA: 84319590348.10.45A4601
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id CAE54140002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:20:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BUEkaGlR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768134012; a=rsa-sha256;
	cv=none;
	b=8qESFei3Wvw4hCVQ0v9rBfT1BnCRMQTnCjP7CF8IdiG1tfp5ZCdUI7TiXadjL9nYzlHavA
	VU14wrHQLqkBNIv3nHH8h673lSP7AANJOPVjXpjLuHOtS+IPzt6OBoVne1npdXRfMwXOcM
	SkLRs7MLPcGHmg5mrSpAzaOUiLWAqZM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BUEkaGlR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768134012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WId1gR6GClOcsxtsBz4LovM65cz0Q2hsHXawAMGxngw=;
	b=HaIEeNKrf2ygMVCmifH9gogxnfeFuk6YhZMVXsmVkuyUsrhB+chIT5dge292OEAsDpkZks
	zaRe0tFCWtDA228J9TpAdW4WSDIgADj9euzZG7aa5FROmSaepgwaeB6bdBs1qQh6Ofn+A4
	/d5aoNOcCZURYntcbCVg8lpHRdtgnFI=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34f634dbfd6so3907893a91.2
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768134012; x=1768738812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WId1gR6GClOcsxtsBz4LovM65cz0Q2hsHXawAMGxngw=;
        b=BUEkaGlRRN+lQeJ4XuDcBEypX4somCW0Q+Wr4e617QdUV/703x2/8WgS+JljbNtqvT
         cJmhDKssMR299MfScNHEUV2+718V/JgtREIWC1tZxDqSdbWWWkNOJQQu8SUZ/YdqAVQl
         tABI7J/raiOCQO1NjXKNxEUZQaQlpkr9YytCiS4/jNsHamWYpVWcqgH/VNpzmUnJkFQl
         /fryCNMXe9q+37PoN6dfmBUSoeR3M91FRo8Wl4MvaYBk/0IjHuoYFJ9Kzg4YGMDnwY5X
         rC0+LuqdRny4N3Bn83HhLZksdamgnpt+DKsvwcmlXUY7wdqBIEepZbpbm0+K4FYOy/L9
         EYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768134012; x=1768738812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WId1gR6GClOcsxtsBz4LovM65cz0Q2hsHXawAMGxngw=;
        b=aIsN0YhZSGGFOif562jBW8rLDOUYMe98wgBc0kwBUwwLAXnWhWcaItQh9AsXBAkhTf
         AASLFhbFE16H6XfsAFf6jJ3vkt00n5rpPlZcWpfV9SSiKJ05KeQ3957PbUw/48f5JgYC
         OOiZN7OjW6Fjf+Buwpx9lC4Ep0f92TTEn0QAJUz8ge2s91o/Lzji2Ll3Ue14gdNusTC3
         Mbt2DEYQ0SwuWHxbSqMdpq0RiLKEBA6cFIPrY+AcrOlAN/E37Lc+v5x6QLV1mVhU5blA
         RqL/XuEJo3eaQCGwMbsPVXzdM/aDqcBYV7Y01IVw6OeYEWog8O+m+4kiy+gcK9BTemmi
         QDdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+QWBqBI/mCs18Cr7pIbApZIfE/yToQtKqUN133zjlGDQoGEGqnhkXE9nVJr5uyhVJecRLJ1auPw==@kvack.org
X-Gm-Message-State: AOJu0Yxh8EYo5g/G75dXu7c5YiZxq7lEkAZ7SHOv3R58C5fKg19vZqG3
	syYlGU9nAjANI7whpr7SRrSvBfkE5uIn24mWeeEa+F+KTuYbNkqLhQYN
X-Gm-Gg: AY/fxX4sgXXSy/gR4hA36nsn/iFXscZ7OIHah2WIPAzxfhDDw51uuXXmzYdOrYGCihT
	lb0H/5MDR/7gwyEeo6d6BV/WUDZNNu4GL1m7Ymzq+p9ufZChSdlW9XYJ3VMik44Wvsnvl5eoS7F
	1NvzYvq5adMly0OoRlWvDYFne+S337Ey+E7Hb1g9j/mtVAiC5V1PS+RLEa3tH8DqrSvtpWmgFnL
	JrYszgq8BfChRnbF5uNKHUWGgf9g5sbHpxO8YTPGC3ogeSC/eHOb/FmjgSnI9u0PSU9bvNY/nSr
	LCIO3zrm7guhjPlCoqYCeAlIZHLQ733nVPEFVLtmCd/H9+2N35TKsMcOiZEqeuXgLBvgNuYxI/K
	AEUfHtf3pebJ+Ei2BR3IsvPCgLEqGd2sXUEfhiZe5PrhKjIsSZj3OYc2kDLT5tyDZqKRLcF62rx
	/KtE/mVjHbnYn7s/usALP8Eb7vHyqBMw==
X-Google-Smtp-Source: AGHT+IGZPr3xARA+SSffhvwMckbZFHDMqc3wMCnmhn1Y/ESS4DoaMHMGv640C4e4rdbes7Vs3G1Cdw==
X-Received: by 2002:a17:90b:3d08:b0:33b:be31:8194 with SMTP id 98e67ed59e1d1-34f68cea72fmr14573218a91.34.1768134011656;
        Sun, 11 Jan 2026 04:20:11 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:20:11 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v4 6/6] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Sun, 11 Jan 2026 20:19:09 +0800
Message-ID: <20260111121909.8410-7-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAE54140002
X-Rspamd-Server: rspam06
X-Stat-Signature: u8cppt1kozy9rw6j7d67y6nsci41otpo
X-Rspam-User: 
X-HE-Tag: 1768134012-729150
X-HE-Meta: U2FsdGVkX1/CuwALsqoG7vYBA3HTunrN+UNNrkuP0liu/CdVUq1G3BJY2SX4w4kjTNF3f2GZWZo5Yu+Ci8M/iT9Hidw1kZwFuSmbXv4Vp4Z8rNtUkspBvcYzoDUreZ7Y8SEh9suHeeRYS91IjEcexQcDAAma4k58NpEccs4ILt47quBDrLU7A3UbL8/soD7VwdU21n15BpMIIBCkgKfvDB33jzxwkUbMRTOfZdHc1+qJ3lUYw/K/BuYcoi1KHxgXBYRUpp2yQGzcghPBU/nnpQLe1HXj1YrH5OICJaRO1B34C5m5POCXN8kXHnYgMn1XKFneKzQiQq2UxnMW/rUWBd1Sd7n3SzjmNhBTX9C72hIDvF0kmg1pNxV+hicdh9/NNHCS+Ott7RAN8NjKqmABgHP98Ame9HiFP3ZI1nNrkFBYuSwXym82pioMLO6nDsipu2YW1M40/Y/U3KmcIeAD3ZY7Gut+YWvkXJjAX9SPVHOfQBmFLEQzvNwwGnOS4q6WtjceCxkiSnDBIbwc/jEFY8RM02t4rnKroJ7KWV6qaVfrfCN0PeFoNbW+V3cLs51CGV5xE6TCBI7hNAakjGiinLLAQwDy2FVdO8AcyITG6Jql4JnwCaBVep+1bzAEx1luI59q4GDbkMCT9dy70o/u3q45uXT7vLjKspPm4ZHlH18AZ5ET0/H7ztfKGbDh3qeLU9cObv5WvJsO63JLC53lnKKGk5iJTFDWC2F1A+FfKSTTRuHmnO4XjvRCLGpc3o+WOf+/xSwp8GnW7fq/+53iXxdJrdo9hJgwlvt2vu3T87eKO9gJc5odBQUqBULPrmM7CWJUTsn4B/CE8GYdlSoljk8cs+3dzJL38TdDxHu7+i69ptadStPxnVuyccIc0Sxw+8QCn/Qzbij8ILWCHI+SH2fSmcC13hIPcz880n09BTk10/94nRXjDwBhdLE+Vm0ND2RZPfnZ9PaAZ6mER8m
 eFcHC5W4
 ilutDacRTUo+tJun+lT6bZMcwUopNxY0ZxsxYU8rX5DBx2gj8sg+jEsQJ4mvJf5FHpRGJAFozTyn89IbQQDuBF0f0EE38Qv6t9Z1hXx1gjDfzaOGaOuc1P6Lj/iJl0CpEOdFfvgui8dER2f6oCiBEUuDRXvVF/+ZY1z60DQrxsULWWPUO5roieSHXM8kaGp3qmiLCuM2mxPuCTSDHNV7quo3jI/scojc1wvMBm8+i3wZ4XJ+1f7zC/UwbpuRUUcq3BCuoE/k1KsR5ol3hdb/llqtr5DqHaD3O8bFYkHGcn/NA2tAYEmdajKnGD2C9rgOqNGUsLh+dDj3SayBU+X2CZHaJdBFmhHUfKrU0RvM9Puz1BXk=
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

Without this patch, entering khugepaged_scan_mm_slot() next time, we
will set khugepaged_scan.mm_slot to the next mm_slot.

With this patch, we will directly set khugepaged_scan.mm_slot to the
next mm_slot.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8a7008760566..4c055d6c2717 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2566,7 +2566,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.51.0


