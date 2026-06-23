Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E67CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576CD6B0096; Tue, 23 Jun 2026 02:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5009A6B0098; Tue, 23 Jun 2026 02:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8546B0099; Tue, 23 Jun 2026 02:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 093E86B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:20:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 779A7403D0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:20:22 +0000 (UTC)
X-FDA: 84910177884.24.39C9421
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6E83100007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:20:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m2BM3w9M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of imnotamilkglass@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=imnotamilkglass@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782195620;
	b=zSJ9kSbNytstNn8dxr2vVYU6PkRt8dK9yGslIXvO/Dh0uJgPdN81Aw6/MbZ9TfXO1hP0ah
	uNhciMl0fpftZHdg0y8ipny5TJDd+fMAgKLXhC3TEnk+qYTLbflwoSIEc3NJU+WyKu+JQc
	Ifk+roS05F/C+NBMEdqzw7dOOZlsik8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782195620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=11Q18joXZirXmCzPw0aVBqfPmaFFMvws43nEK3ke8us=;
	b=eMH6BnF0jI5YkZ4XwoMOR8mNE8YdglHJ40PrITImAcANorDUHYLIg7wqmMaXxsABuozpwf
	pKLNq1xpPnfhNiizi3elrJre/73y1Sy3fgnhYm6lk7h/zdz2vSo+BqMuS9bROHvrN1EIDI
	auRaLhpIJjL551SfMTv7Cpej/CQySdA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m2BM3w9M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of imnotamilkglass@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=imnotamilkglass@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8454c5a280aso334275b3a.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782195619; x=1782800419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=11Q18joXZirXmCzPw0aVBqfPmaFFMvws43nEK3ke8us=;
        b=m2BM3w9McQNY3GtL5PJ66KZKQ39SfbvrctKLAfcRwjfPKuWZCj/wXrWiH6uMo3OCYc
         E5SOt3Kor9A2ckUhAgHo9lxhbGfUB6mkiphj5HqCbw7/Tn9eyOnCdS7CjZp/beu7QJD2
         VdkHS2Pa7tBVIBNS0vYCRdUAFarmCvN5V04mz6BfxOIZJCIWqQDQZPT+OkZmSKFT3e5Q
         Ahun3UA2X0lB3wiPI7kqfpsNab8pWo8kK2nUF0P9BKc5hLVzpsWLg3DOak/n+YJ0pISg
         EGxwA1F3S+kQHmZR96FOiltfh/h9blLLyJZ8Htoxwzn+XTHh5o1sA1zQYFeH/VYi8UA4
         NK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782195619; x=1782800419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11Q18joXZirXmCzPw0aVBqfPmaFFMvws43nEK3ke8us=;
        b=TB2uOsT04XYrhVd8DJahFN3qDSdwT9C3B/4jXszyUFdlNYgyjfiASKs8NmK/N9Akwh
         DvWIRkK+221AjrvHoRCfh4Kk4nBnaXujTeH1qjNIwq7QEXSdgCdJooJoa46Z6EAqmzNy
         zSIbE6mPdHwQHtEC1KKk03choXs0vWEgaGawq8Gd1llJCej2C6RtBU/MHp0iCDejJAxI
         couewJS/2KZ2pHf24kLkQx83VfOgfNq/PYaV1v0tNV29ICfGu/+9w/DVtp+JhaVe/JRZ
         O5ysVW3yiXAd6hT1x9z24XujVZoGQCvrkEG6/8hYHF9XYzHR5AKhSyaJ/X9G8t6Tf7UU
         xMBQ==
X-Gm-Message-State: AOJu0YxEJiGVVtnPsBHkBsayvUaLD3NHAc4K83/1SSEkS6wMz22oM/tE
	kbeeSKBHs690xdmRtPLnzgcWV6+P7/hdF6//YgGnTd4CZbx8MYMpRaOHrUCVlUYnzFk=
X-Gm-Gg: AfdE7cmqHiwuAe4TjZiwCSlvdXTaGLVD5X9Dt+9GZSnIfawhcWQFNN3adRJ1VvQ1wBm
	SEmY8Z+RwqSfWhHxqUvMzEyyIPjJvKPkTT+2BRmoEchTMntNug4Z9ckSZb5i5W7JmldNrj9nMQe
	oKcrdMnFt1dXB27I2RUHkulqJFCqAGZlmXWDfdZkz7qyVcLrQUUg0VfbqBaetEcwHcd2oQm3nxl
	tRcoYwWDNXfKW38xI4lsULN63vWCFpD7sC+ai2SgfJ0hhaU0dyxyjSj2t28lZUcCuaFT/YN26GU
	MvWmstWsQlE90W7J2mfCJz7DCVs9QvrBF/dd+6gjh3VNwDowegXURDaAcjvMAQHKk8QiPkUyNGJ
	9NhCyLmeP50x6H3xe/oUAebNoMjAgq4egQkONn/PphJmwoAyHorpH9SUlLgi2+LVBNtF//ALcm+
	5dcxipWz3NiMUfaTTKF4XUrT8Cggk=
X-Received: by 2002:a05:6a00:94f7:b0:842:446a:4cb5 with SMTP id d2e1a72fcca58-84591a0e8e7mr2131312b3a.0.1782195619270;
        Mon, 22 Jun 2026 23:20:19 -0700 (PDT)
Received: from Louie360.grammar.local ([138.44.161.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564ed9516sm9467654b3a.57.2026.06.22.23.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 23:20:18 -0700 (PDT)
From: Watson Wheeler <imnotamilkglass@gmail.com>
X-Google-Original-From: Watson Wheeler <git@tazy.dev>
To: linux-mm@kvack.org
Cc: Watson Wheeler <git@tazy.dev>
Subject: [PATCH] lib/maple_tree: add missing spaces after switch keyword
Date: Tue, 23 Jun 2026 16:17:12 +1000
Message-ID: <20260623061730.2024-1-git@tazy.dev>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6E83100007
X-Rspam-User: 
X-Stat-Signature: ygwx1zqw86bdhf4zi1aoiq536hjijisd
X-HE-Tag: 1782195620-103097
X-HE-Meta: U2FsdGVkX1/y5Z1PIjb3IFTYRYbAmw9sf1NGvFzNYO5+8nBxvEiph8x0hXamtiFdy4JXkbtmODk2WJO8e61PWjAoNz8uNv4RCXwoF8MyM2mMTZCbDBEh2XPMoqeLBujclw6pWNkYz9TFPYPlx7+aAQice0c+6TqVmrjBeL9qBRXFdKFKH6nTM8eJfEbBJuvJqYq9KkmcWnBu5AGFQDV8MJk2ASfeUQByQ7PRbmUS1BzBBQDlUomRLMOlwazDL2/TNjoIs31gFsPP1DRlb+h/JcCBlbZFH6SeVQtO1SztCT3vm7yKxKPzQkN5UlcnCy9lcK5BYGZ5GWtzs8cWXXlzMGI+ZAUSkhKzrblmXgNu5d9eNir55tAqgxjO5+GYGL7HQ/q/uQtDwFF6iOnnru0QCalZYeEmbvuDjN6eYqc3DOqK+ZUJsQbI+sWRkMDpE3s+lfE29lvb+HKvUGsKWeB6eCVWlby+6aPih55SA6iJKs+1jNg4p6F5/akaNRhlKUlCAVtTMlFpaMeK+R+j7Sq0tqRGuVnFF/7Ud92kBpPjsYPu3J9VtmMLHnTqqEMQKxLvsNGwDtnhj+hWaa3pHds0Yar22a7Yb/al0XlASh3TCZCnu22r3Gmlk8S//LTUH4FEEDGnefVM8IEN3sefnH797u9SRDWONimig4MW7gwzK6+vbIJ5vzHuZ3w82AUm9BMKengEP+GtCPV6g4cRDiGd/YpfHOBN2EmYLVGSiCtEkt4viSg38DE8cRwUsOriS4ptkX7uB163mXL9x4RVwWiLpuPsq/sGlQ9DJ0aaA/TsILPhcKY0vUIyOCugtzDjVILt1AMhGRgcOBak9LgFo9TDmBLChZe0m5V44Lx2awWsZcgdJDLoZpo0XqmkfYOhbaslvdnXXeU+4fLkifstsJ01+uYSs7+Oezs/721xDVXitTsH9aGcZEMdDve5qhtIURD04l5ndrdZXLxjnyvQ3+Q
 U99FLbyk
 tDMzH7Fj9JXcG0h3kGU/36V9bV3UA+/s9+ZETfyHtYu1RXWAMBXlEWJlUW2so4vsXjZtd3s+rvk+yZjVzgmBg5rtYd2X6yJT2qvL123zb6HHUjvqQ6lWh1mfg9g/h1lb6R67JahGYDae4PpdIyD6rAEl7yUxcr6sKebeh6/tR4KxaXDlxP7DKn9+FBsQiB8lXNzOLdmYvkiEqZNOUhogdIXZtTrY9hZbnqRyUuiGgxuow20j2ycuoMc9mOE4vzhujrH4+uuJt0ePmegN09IhjSykAbE1GMYMK8nwgV0u7w5PH2f8hB9ZJvB2FJcDG+pUVIudYnH+7xTF6yykS0GFKpITcVjYtxsxZMJgnR4U/SFka0ybYylrrSvAp/jrz0INmvSnmXNbw48R5kkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the required space before the opening parenthesis in
switch statements to conform to kernel coding style.

Signed-off-by: Watson Wheeler <git@tazy.dev>
---
 lib/maple_tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e52876435b77..529acc056e55 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6447,7 +6447,7 @@ static void mt_dump_range(unsigned long min, unsigned long max,
 {
 	static const char spaces[] = "                                ";
 
-	switch(format) {
+	switch (format) {
 	case mt_dump_hex:
 		if (min == max)
 			pr_info("%.*s%lx: ", depth * 2, spaces, min);
@@ -6489,7 +6489,7 @@ static void mt_dump_range64(const struct maple_tree *mt, void *entry,
 
 	pr_cont(" contents: ");
 	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++) {
-		switch(format) {
+		switch (format) {
 		case mt_dump_hex:
 			pr_cont(PTR_FMT " %lX ", node->slot[i], node->pivot[i]);
 			break;
@@ -6517,7 +6517,7 @@ static void mt_dump_range64(const struct maple_tree *mt, void *entry,
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
@@ -6576,7 +6576,7 @@ static void mt_dump_arange64(const struct maple_tree *mt, void *entry,
 		if (last == max)
 			break;
 		if (last > max) {
-			switch(format) {
+			switch (format) {
 			case mt_dump_hex:
 				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
-- 
2.47.3


