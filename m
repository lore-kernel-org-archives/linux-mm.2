Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CC0C44533
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952E66B0095; Tue, 21 Jul 2026 11:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904576B0098; Tue, 21 Jul 2026 11:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7567F6B0099; Tue, 21 Jul 2026 11:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5BC6B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:56:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4777140198
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:56:51 +0000 (UTC)
X-FDA: 85013237022.15.415CA53
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id D7C7340006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:56:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVmiWiCx;
	spf=pass (imf01.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784649409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDbYzkykPvbgdcYCtYPgUAJoDDOjTvDIgLuAOwgatzg=;
	b=67ZiJTNAQyQK3OvGANop7LApzZ6rjy/keK0bPg4ZU3jV3x3XkqTaU2l9SFGCcm4v5GtCr8
	w1LOvon/c54yApPhgrGsTQm1qPkgqbbDnWgXhLQqGvShECp12wOxlCvN5Dp9iaVpaCqi73
	vospOx0rKVBYc/PfQ8dhTHSb/vNhIVo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784649409;
	b=o2PC237lTloNNj026qfRHqfzrIis6x6rvyra6qgDP0bVS5y3llAQCu/UFb+Sz3H/NzqK3L
	oyLmUQi5Fk0P4whVMOHRiJA3Z4FCVNnsYZaj3oJnRu5WSbFfZMTs/hJ1dWJNnUFV+zXqqF
	8m1NV+MkKtesDLNUyQKDbSO4MGJBxtI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVmiWiCx;
	spf=pass (imf01.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf50c6f235so36051345ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784649409; x=1785254209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dDbYzkykPvbgdcYCtYPgUAJoDDOjTvDIgLuAOwgatzg=;
        b=AVmiWiCx6xfzVMZb+rlP16RLYw5ryGUyZucUELLK61R86coBHW15kF1y/a7Ijyd+uf
         6mNqw1IVPjXVpY/uSXSyzZmRnCiYCh5+iPOYvHfWE/k3cI9Y6dsPNDeemjX5iBoODufT
         WZOChIaBVaCxDOCSpCwpkKFnUQP+NoI2ZDfxaGpDvuWgHkcRKMv0DL0fR38gy5AOXWsh
         PsGcGGLOKeOvonQiDH7fuLfQV00aM1V20fA06vzDt4VnPKQhYvKnMTpeszrVAUUjvVNc
         G9dYEnJXj1g9SirCJi17sQfVs/goVo4qHLM6LjWjDTxnHaRAanxgk+OWhLDT9znNiK/n
         ZM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784649409; x=1785254209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dDbYzkykPvbgdcYCtYPgUAJoDDOjTvDIgLuAOwgatzg=;
        b=kQ8z1OX1f02RL+KeEpOTKOjg4ZSrsBgnRCetR77UatrqY2YVN6KADzHOroCptEpN85
         6+Fav5MIkN/LgqMzxRPs2ARS2Fqu+6qlnMrPXnXxllWcFigOaV0GRFntCiW2p5c8vM+l
         623hDc/dqVo0ocL9nCfIs3xmta1OPa0nRvFaVh5MmWKBAbXRisp0d2EC4QaqnFaWXuXA
         raQeuv7azDK4eR1yvPhsDlSgXLPpFXwifozHgZOYwJb1Tm2dyxMkv5wXJu7QJHqJIJgQ
         Lgj5okF1n24Q/6hrXA69nJVI830flmlOKUIGoyx/k8UaGO/w2UlgLtJhJ17vCwXJzt9s
         2QgA==
X-Gm-Message-State: AOJu0Ywyt6FyrKdg1uBpQAIYgG+9ymEyNoj8cp74H/04b2OLgQqgN41M
	tFsFfcexkTP32wSykY680CZ5Dq6QafneBZpHglPX1BVERiTicfHKeRYQZZZp2NLt
X-Gm-Gg: AR+sD10nO2o1OpWhGRcvvW6oXRbVH+9hu7cVYlD2q3SFPy9P82ros35MOezLPWgO/cw
	5vyAgPELnLwELBJNcEcvuxu+gbChyp2XnzRI3BmSNREKpLuvJpkqBmUYnZT7TfXBHa0xmX0E0fg
	uFclwcoaxar69utkxqtAugE/Hba6Vk0RQhhFsWcEcmuOYpCsb88tAZamReYlhvJ+YFWT+cci8ZP
	6921+4Q2wQgTJhII/bGpfiIX3ZBkTBDchM2ognuzro/SHHteZjqfmacFJIrEIgBgWLGbHCZv0uu
	9jybExTt2Y66bIZHMZOrWIOHAvZ+2Se64upT8hTqcs9s9LLscjF78U7olJjWcowu2asdv1WsNMD
	PLfUL6RABj61byVYgIkqYp1qlJ9Zm++r97saYJPOW9FYxEpFrEJfACkFVH+gRhtIV61EG0uh2yI
	0QZxoPUGBe64TFYBy0eg==
X-Received: by 2002:a17:902:f549:b0:2cc:9e99:55c9 with SMTP id d9443c01a7336-2cf3495fe8emr222049575ad.26.1784649408780;
        Tue, 21 Jul 2026 08:56:48 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([144.48.80.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf345111d5sm78494075ad.37.2026.07.21.08.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 08:56:48 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	roxy520tt@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH v2 1/1] mm/page_table_check: skip zero pages
Date: Tue, 21 Jul 2026 23:56:38 +0800
Message-ID: <1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784645969.git.roxy520tt@gmail.com>
References: <cover.1784645969.git.roxy520tt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ymodn4wy51c6wpy5kexi1uqi1jj7iria
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7C7340006
X-HE-Tag: 1784649409-922672
X-HE-Meta: U2FsdGVkX18gP3vejA2V/Rv0gUQD6uqSIXSFDSGcjaci+Hnf4TlfNsM849u5zNievwMi8xKTHrSqLqFk6eArrBCUY9CMdoNsZa1OSPzWoAoZofULyCL5wzZKWy/l5uHKhiuER22gw46PqSHipMKagUngUO3bLp1V4wxPA4+jwdNSATljCXg8U6MmnzrbGXOEJ2dLKBpAJONcE2nG8V78wbCejut0T4WKhoGRmdR1DDWnCrfsggvp9scxopCibcuuMLI2WrqiCl5jbgzxVe519uQaTJFNRTOaO4MJC8j7XnhZdWMIza8oADrb0SKzk8tm1mk0vdgf7IpjcoleaBLlriDRod3ILuoW/0WyKhSp4BVIG2EeqLYOppz0flJll+uZrdKoOFZohXG8DhB5txBghLO3FXwz85qRKLZpzzwi5NnY2ZdDQ3SJDPRm9DOT9GPgG0rQb77q1cyTZeepfIh7V6ot/4uej+i1yFeVSWJuEJS5hSeqOiprfaCeLpdtkpG3az+L1m32SoF4bK/gpdDgPa6vaicF1cmXQuwvVanWpN0Iatpg9Ix1tQQF9Nf9LH8fuijHXWtClYMMO+BdgnvzpRQcvH8TH0266zNR+W85ePc84L2ot/lNQmzWqLlGGLc7BGeraZtEZlRB4vrajdobnE/NnClGsrch8vLYXB77n9FdYPH+fmLGHodmCTEuCCcy2WLjUGSxHnOnbLp5twdPoXZ3KpD2uJL84pI5xqp9bQoiMuMkMjQ0CMW+XvI4BIxM/LrpaoIAOYOsTaJmLnnGd9fHWV9McJDjcP5P1iBS5F4BTnMxfATm/CrhHznnh6pYwyb/kL+VtdAFdIZE2hgL6L4i2FGbRNcPowOosTmc2oKvtOS1ts3Z6r5k8482fKw8ZkjXSHjliCe0gvGJLQ+rgtKSmAwrmdgOu3fGKtZlo/4LBpTVKmkr+wJ+nztkrH6SiKm6cx1NX4TsUrnFojI
 VJykjDEW
 N4EVSwt1cvQN07Bqvsbs7+n/MCiJOFerE8EpF4My6SrKoMYPi+XNCuWgsasoqjH1+FjeshEPwT6Y1Y6BrPtOrZRpK59P8riiLehQS9DAgFEq4Tm2D5hn4Nf8EVBXn9H1/72D8Zy3hcEsbumo6Zlg3oXnn7O0haM/01ru4LCjHn1xCYj0W5BGKNyam7u60NoYjKwKla14tIngcpD45bT+iab5cPN7mF+BNkaPZbChhL2thNfZhOiu+jzaONEai4GD0hLpm00i/EkKSCb73OImYEY2pwK65b5wXKHpRu5JhyGtKNwvHJ6Xw7m83XhqBB61wVZcxGpYj0phvd1vwq3PTO2/4OgCtHwizGWQKdos+OOl98xW5PUZ0SkeAESxZvEw/0DpgDQ2CQmPdk+NqhdlxTnxMVGRW6n40Wkcd6PfJcQn8keO2yygyoLOtZw5KvN84h2xGM5iVwcrRDcDeGQovIxgmy2hNv9QqOUPNopgh8EVfb1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <roxy520tt@gmail.com>

page_table_check_set() accounts pages by whether they are PageAnon().
The shared zero page is a special page, not an ordinary file-backed
page. Read faults on private anonymous mappings can install many
read-only PTEs that point at the zero page, but page_table_check
currently accounts them in file_map_count.

That lets an unprivileged process populate enough zero-page mappings to
overflow file_map_count and trip the BUG_ON() in page_table_check_set().

Skip zero pages in page_table_check accounting. They do not need the
anonymous/file mapping conflict checks that page_table_check performs for
ordinary pages, and this keeps the existing counter size and page_ext
layout unchanged.

Fixes: df4e817b7108 ("mm: page table check")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
changes in v2:
- Handle zero and huge zero pages as special cases instead of widening
  page_table_check counters.
- Keep page_ext storage and ordinary page map-count checks unchanged.
- v1 Link: https://lore.kernel.org/all/b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com/
 mm/page_table_check.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 53a8997ec043..1914902aaf30 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -67,7 +67,7 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -102,7 +102,7 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
-- 
2.43.0

