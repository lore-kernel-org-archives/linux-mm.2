Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CFEC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357036B0095; Wed, 29 Jul 2026 22:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FDB6B0096; Wed, 29 Jul 2026 22:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244ED6B0098; Wed, 29 Jul 2026 22:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27096B0095
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:17:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FFB9A1D74
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:31 +0000 (UTC)
X-FDA: 85043831502.15.44F5435
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id BACBC40003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVugZXWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785377849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTwEzqeF97wumJIcsz5S3t64bdWHEEiMpofbG9ulZh0=;
	b=urWghM77MH5fQ3bAEoz47q1c6G+5mi+2WducG2zJ86dnNfewYGRWcqw4tY/8MMHMZDBplS
	pWQ7qfVJ+kOQBP9gyM7IqWAjNtIhufT41huMBsBXxoPXxSUxNxqJuPROtyKWGb2WfyMP7C
	GcDIdShNFWClnItNGWIpu/SyCgSVKNs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVugZXWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785377849;
	b=XXu/ESZuEX5S5hgQnwBYhB9XLroZmYeF6g6DTHoIld0YyaQ1nJG6Xi4z+6nQpZeGDS6IXZ
	Y8VPOnJvV+esyAkmnrZ0R6uKYZI+KwEslrAbOREx+LA5GWaQGNOLwhMVuAi17oENFD80qc
	YdP7D4fzOGRB6QH47fUyHZ18Aw2ffUs=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c96d7933910so183474a12.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377849; x=1785982649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FTwEzqeF97wumJIcsz5S3t64bdWHEEiMpofbG9ulZh0=;
        b=OVugZXWnNHJL6T2DKb6+jm60aawr04s/cfsE5cQFgS/kGgGHFPLEtH1UXNevzPxj7W
         vnU8RHeZkCWgjM6PTWEstyLG76wzWLlPHgSh6w5syJMb/vrCCUQH+VQnYrTIvHowCwfr
         umSpIvSXBR27ypRXgczsc9cNj/kaOgjIe828t+OzHZC50u/nqJGzLS05kYTNRt0vy3kT
         Y32FJLB5Pqm9a3p5OZUh4Ptm/1YEPI0OBEFOItC63eODK5RmVXz1xS8EOwUFPqWcEDTp
         OxrKGsZ1R1yKKS7sg5IhiuqCM+eeK7FuhNJOTt0GRSKtM6YByX7Q3vmcRWEl2R+yUswt
         0oKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377849; x=1785982649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FTwEzqeF97wumJIcsz5S3t64bdWHEEiMpofbG9ulZh0=;
        b=YBFfP789KJNWuhoXSwlXE/mHMiTxZf8K1b96+8Lyd84t49G3qmplUl/95u6DS2jJLe
         ZvDb54m/Xq2STWa6i7esUn5oXO1Pj25pNuIyL3dqgtLc2A0nLm/mKqUrC9FmJ/dhkG8S
         N1iHU5aUWwXVkOhOvIVirVgXTjHQm7/lnQ8CiJ4f2TKrs/PVHyn9dxi64nD4G5U6wVhX
         TU80q+COgzIWlajUEWMo+3IROVCvVnwud+O4IEkRpXSgpH5n0a4i7FrmS7fXAE8e00Fj
         dLqmGZjOAS/QwgOjzr9pCUBKggoDSpOaeoi9h1xMuBOakRW9YdbV9fYQqPQ/fXtxPy6H
         9Ozw==
X-Forwarded-Encrypted: i=1; AHgh+Rp6jhJ8kJB5YnbkV09PIJilqbSP/MVzsIXcXya9XH85Ti4AYWbkmcPKVE7UBroU1SOegZx3aGnGnw==@kvack.org
X-Gm-Message-State: AOJu0YwzW8KH5JQ0yUaoexC9R09z3EQ5ZH3PGimB6/TV6a+VPRQzlxWF
	SusbSqPY3NuIXDxeCeQoplXRK4B+g671YfZN/NUB+IIFIr7mugetVRlj
X-Gm-Gg: AR+sD11SDO0mw+jYhnTloyzLGpCE4or2BierFwVcwjr11mWn2wnAGWOnoIF7HLHW0oj
	Ogzb+O3+hUpDQmAIuuX7a4l6JB4eZyCnKCXY+kF87Sk5SLX9z8a7dDL1wS1CtcXnZxmLODJ7eWq
	Q8S3Qy4oyPD+sdWscHosMSHEGfSvo68z0COT9EmHrMaQJqVA4Gl+eDual6LpNuPe4luCZLcOx9c
	7T3zb18wm0HQXwqSgAQfMt4Hz7MfiqTHyXMvLbGdSOn8SRfIawTfK3K1kW4YENQn3T4QKfqLPVs
	2QQr59uu53jrcxPV4y+quveKZt2kKUWzFF4Kg3qQMd22bq06jEtxv6XRUiSvxwFuwP0ityufhRq
	gCYknxz5qWNBTURnFc6pLUhbx4UAUpqCjfFOjN6QCoU8rfy9AbibdqAFFMdm3Fbqwc/IzenKITd
	jxSbH/ew704HiVL5UbSGieolBxCm3CGl4RvfMkwIXb1z8VbHKkgt9g/1wovWWLL44P/oNNBkuN4
	z59MNuH6452gbPS9rJDgZUbKdQ0Hix6iCjQ7wPM5eYTT0FTRLId
X-Received: by 2002:a05:6a00:2193:b0:842:732c:569a with SMTP id d2e1a72fcca58-84ebc3d1c4cmr1021107b3a.2.1785377848496;
        Wed, 29 Jul 2026 19:17:28 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:28 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 30 Jul 2026 10:16:29 +0800
Message-ID: <20260730021630.2235914-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BACBC40003
X-Rspam-User: 
X-Stat-Signature: mqdwb8qsdntaac5szp7gdkuhn4a7wx6g
X-HE-Tag: 1785377849-747635
X-HE-Meta: U2FsdGVkX1/j8yr/uJQe1DI2RtwV5YZCWyl75y1JH7TMFldYjvamjwd7F/nQrtJqi56Am1NbEVWJCMwZ8COjjU+/YPADH88CGBdO3BzW0uIbMUnFsmWyyC0Kkp3vmbm48yrzOJVdIeyVosqbAQDhB6M/5LxJVniqtx5qp65HzU7ieJIz+Vmd1fopivfTi7V1sM4ATXbG8LqGo5mb98mkM0cRfkkTdLOd2UeB5iPX2dD0Isjq5t+vQBUsK0beE9NgHcRdua8IcIaOseUeXqwJetPkjFl4JohXF/1hdE5FL18FVKHtl1uiTRykkkrNmGrxF/YzC9spk1UQTx99aMHMArhz16aCf8QY2bvcZC7aW9WnWjLzH5I7z1AloUrZtzpGsBQwU2+v9r/AhbJf3bYa4aaLQd+WpDzxPkE/QMMp+HvJ9DWwRkA8VzGy7UIuporPn54RDP8yQ7BobkGvM+LFd9j2k62oMby+D+lT9aQYtcMHB2hWoMdmNvBcQhgioWRvC5RDIf+nAj60V8lcApbtCsgVrZ1Jyk5ARtMHgvVKryc8RH98mXtCCwspvRFEmaiD8s44g7kMChi2XoZ7Pr+C5wMXo+0A6H6+Hx/N/rOFR5Z2eKmneWFe/V9Tj2ZqFAzlcjUjhae3CcmJenYgOqTAhbXJEf/GAhUrQSo6MHtgpQctulDBQjAsUGZiBIuedhvoWf7qJ0qm/AXKfSdGw9plZJ1xnFoxpKtCwx3Z+3nueCPQuW4rL/VjPauUvr9ywB4boGSMHB0IBsbEjxRHx4Dd64kyImskppfUYystNb5jeAqLnv3IUsUJ3bmT5dfnasaThP+EQT8JmAchLsnqdPP52csZH51qcttEuxMGMeZccEJxdLJD9Ccu9EwnRb1D3us0Cbs8+gm/FzBL9vknC6ZKxBjN3FzVuYrpUYO1JMvwSxOR/TqWJKR5Onbd6qnOFdQxOG7SGs3gYWBA3QzQwrA
 7gTnsgym
 y3fsKjBBcUR+AJZAJi+sUv1G0Ab2oaXRbMqUFiLrObzQ5deOcXQoPzazicqX2q79J8DuwttCRcbxNMs55XvPRsEJcGeaeIx2B1ewnZ7I/6EfBWa7+ZcLu3FSP/EbwFBfxbk6fLCu+sWbFjS3EGxFi04Z3wYoNLCxupnQddiMdlPoQ8EhyzfVQ8xE8fC9250TS7987CTEj0IwQC9nhkyx7WhouuWRTqyjqasxiYGRSp79mxprhMm09ggQ8dSgai4uVeb1POfujTMYZ2DVDBaI0L1O4FphIJVvsfD7ZflSWH/1AovdQyIvw0xIfi6GMaHQT780//hn/4qTUseEgge15JlfDzjyq1GirqoUbvWnRGuaATnH5oNrXQZpK8f6k5vJs8l/3y0XBntVJvEETR61+UQgQs1Vv2T8EdkfAP5hGdEhPRSlXDd4GbFkDog8+IQTn8I7C66MdE5mwnOK7vBEiZcnfJlh9K8zRG1mTrL0VLYaG9ilWfT7Z+fZlSTzOtxX2CfcyE3S15tgm6cWTPGno0ZUuNMJzNfrSOq0X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26df81e773ff..e9110afad29f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.47.3


