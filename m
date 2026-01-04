Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ABD6C2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EDD56B00A6; Sun,  4 Jan 2026 00:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE8E6B00A7; Sun,  4 Jan 2026 00:42:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0FA6B00A8; Sun,  4 Jan 2026 00:42:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 593936B00A6
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:42:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22B2C1A80CE
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:17 +0000 (UTC)
X-FDA: 84293185914.27.3184278
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4385D40004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8sflPqT;
	spf=pass (imf27.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVZUTb4Qer8ajklVk6CG0+GjbQO/cX8wCCqLg6sFq40=;
	b=4Vh1T1MvacPJ5d6p/H3MOa5UO3pWNLNXie2ppQ3WDMp9lU5yDILbiXDmGqNM6ciHQDfrDu
	nuRHYCtuNegA/H6dYeTyvIUcMu1qVjZOMH0YehgAUpP7+Jy5bfvfOqUwo0Xio4pR7M9AvA
	mStEeXIezhGtq2J5ASMPFtL4JbzV7q8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8sflPqT;
	spf=pass (imf27.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505335; a=rsa-sha256;
	cv=none;
	b=HM1bWC8A62iJf1PnQYqLHVKJi+SZ4WTKWclhoc56IW0OojiWIYWkM9NzH4NfnByLi7fSR9
	XTItNqktVWCAw6BIPz1/jHlJ34OcCosaH0hzZ6kmpzc7UXWEkXsyror6dVMFRs4z60xi6c
	aZBMj8HiZ1SaTrlLyrmlCnOzv7xOzgc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7f651586be1so422656b3a.1
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505334; x=1768110134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVZUTb4Qer8ajklVk6CG0+GjbQO/cX8wCCqLg6sFq40=;
        b=N8sflPqT8aQu5hQbDNgybYayiLf71pk/ldLB5yp+gnD4DsP9p4z6l3GeH6Mw9keFaV
         FEn+2oiu74YQcTUfwTIRo6QCJxYg+BoVkwMYqkfmhdqtWMQLWqGV4gYPYW7+tU3c3DEp
         mwUDGReHCy5Oc8zNkpRV+MtMz29Ic3NYAZLx/DrJDe08JA3RpGkwhhX9qoILX0KfOaja
         Alhl1pxArcKXY6W/oSSQviVbgNWUhmnnsYigb4jXJfZ4SOaLDjXEjEbvtM8Q4D52/4hG
         0dhuCuQe9SBMgqRu6ILvfdb+WL+2Wx81IlRUzT6F1K90aAbhMUzQA0Co4U4PKAoJQz+d
         8N3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505334; x=1768110134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mVZUTb4Qer8ajklVk6CG0+GjbQO/cX8wCCqLg6sFq40=;
        b=E8nct0NLaI1yT0oqeNVsAy8URydDVi+iXrzM8CRK7BwubvFvLRms4qxDMiCQ4g3SCS
         RCcJ+p7Gd/MlsD9CebChJCSl8ScoQibdZSVUUZqZSrCRZfbiPSKcLjEcxnHdwcv0z2Kn
         JBTKLZgFua26ngrowb+55HS/z9Ry8YZTioaep2Sx+NwXbqlgivBKrNVCgAlbF8hjZIJe
         eWsNcGs0Pusn2SuoI3GV6uHtW6SolKXbDSkMJk6jZ3BJuirg1wqFs+acRAZalxCdwt5n
         qTTrWbUfSEZGYNZRyrM4k9x4ETIDFP5XAonBhzVM7rrBZ4+fHLeWHvorfGDXNw65m5JI
         JU8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUjM6U9Rlk6rcmbi1zRdpTD/L/e4uuTILxv9XvFotLwklFPNf8EhhFWN1di7A2KEffzU6DES1/SAA==@kvack.org
X-Gm-Message-State: AOJu0YylMgtUPxPin0IQ3uYDP4H/O3JEEsBd0e/8m4kknNzy0035+04D
	Dbf3IkAmymXTMRkLqJKQH5LGezpLTwY3Vja76wo/UbEVWxWTeHIoq8rD
X-Gm-Gg: AY/fxX6RIorrffwwUd+fLFBlgBP9gKnP1Wg2KUSuzWnaoErHAXatNQpj2hNnQU6SLEZ
	JdR9OGKzzgtd3WgIph9vYJ9NR2riZ84/dC0GjAR/cBM7l56yqcVEpfJI0PXlAsQ/iqp7pv6MDa9
	2K0VR7rko0yLZjamh8wgR2Sguzfh88fwENPGSNYNKQXlIb9tgfJhP7+Gqs5XqFVeOYd1w5cjFyz
	Nk/jsllhyOuLItyNSb0DYiZrgvHqllsALIUy1+Q3ezp2teO/5/vMgEaSK/e1rDVSKXdXV8vqTBu
	zGtRKrxsfXC1koYi6wDLoSvzX83K7XgComlct8d4Z/Oj0YU+8DPsvoNvkSOI9M6tOwsnUGV8i1U
	nN9osRH4gowf55XGyQFdAEEXAKF3aQEwXcFWDMKtuwyC+GFNsByr6fJoX1eruMyOzNPHMEQiI8q
	FEYLN6j7e+gphzBpOwV2WsHvCEh8WJ
X-Google-Smtp-Source: AGHT+IF9unx0Mow5O8mwt5WnoBPeKUfe93MefKFW8YHG9g4srn7KZftNBnfeDA9v9eopBz9E5oLcWQ==
X-Received: by 2002:a05:6a00:a386:b0:7e8:3fcb:bc3c with SMTP id d2e1a72fcca58-8148ac395cdmr3725987b3a.17.1767505334198;
        Sat, 03 Jan 2026 21:42:14 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:42:13 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Sun,  4 Jan 2026 13:41:12 +0800
Message-ID: <20260104054112.4541-7-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k1r5cc8jnrckgi8c1yz5hqyc1cahxqhj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4385D40004
X-HE-Tag: 1767505335-185184
X-HE-Meta: U2FsdGVkX18pZDumjZVpyswWTnaTvQ563rKv3cmvpqPAdAz6AZASKlRT8645wTAgaPGDbnwUFgEq9pdNw9vepIWDJ3ZMGMQLrb4an6nx7DIMhSDMl727+KOcG4msLGUhacfVdsf+e7imor6Ghm8SAstYbsgwSmyyzH7AykWqJkZFe5rFO2lAFSx/rJyGpVOBxOnfbupOSuQFv6vxdEBDVm3nvrz4tyGX6FWijH+iqDSI8dtGtm7k1ebME3Eq3R5HVFIf+5gC1tevfXTzFGOz9YCW6+IhUcIzMtCucu22sMJNxxRlZBitGav8I0sG7zvGyCdNvZnG5+q+IAIIEiiofGZ89ur1WrxI4/lr0yqyuXPDDaJ7UhDrLwJktCDXBWUZMPzWKYv92jwtfHxBWhlVXaCD+cW4O2do8v+bubBK/LyhxqtOxYMrWUJJmVsuSF2cQWhAmYjaFHqw/rlwW07dXw9IHTFa1IeytMGAxl3KvHa8xEUpUNHTh/ecw5Xs55gfu4qdg1YTB+IdvV/FR8eXhY+xFUKcGj4zHYNN3NntzMPgFY0H9SuH0uJezF5X98eOgbZIG9TbpbOaSM0eOU2sVr9GDDj+3aawnX2fcuqgo0UgqYJSFh4uX8n135nBjGLZa8cCFTvbj2juh/NFcSsJo1dTM0v+3pyoUtJKxnqferWdOMp0DaE13lcMJ/+HGNEocLaACt5so/51siaz18AxFuGVzuY5+zxd641C8KMBFg9zQkYYOQs2KaNrF0LifRWdZlO8yfNiJk58Y579nf+YCUIjD7d1YhAoKDOm0YfEkbr+3pX31T9Mg9SHmsMl3W/giY3neBKf2zo0qvvYnyXdJazGfHpMPuDlfSwTUkeFhcFZhh3OKHGqdAWJv4Nkoai80e00LL5fn3d0vdcKt+hIyBxZZhDBqZVDL9+VUGwLxIMC0R9qqJWZk0aivQ2C4Ya8tVaBQGnONyDkHNM3jS0
 +LUNbnSz
 hVp3qmk0gevLxwSLcrdJWcLV3/ovsHy0nInp+b/F06GFtROfi1q0TN9FZdadKApITit/mMaiA9fCbQ55FeM0uLYttW7P4wAL5Q2W26hYt66uQSmxFfskFJEdXpdff4iPWfllE8+Eq8hvSn+ktOit9NV5z+dMpP7FHtZJz/qNQiAIirs4o5bGNEbWz0doV7xqkVWm/1brC7NoQWizpFsOrzM9sOV8bLH6B894hq9GSi8GYlm3oRb6GQluKG2KmDfJXb+AWqWHTIZIUCYCjt3ncWpU/8Wup13uBFpTKjFM6qiro/AAmv7MJ0TMrdZhfix71c2tEyQpjRomSyC7lT+HqkAhg277xefjI8ndwj9ssm+NwHI6FpqSOYD0DbAvn0qwfFkIC+hKBCRkR9YRjmrrZMKpDmEMk128UJOHsQeDMi/mRtF+c7fuE5c261lCavrPCxr7xD/5u6K/ZYPbtMv+47Ha7HOE+VhcPy+NU/mw2Vy5evsNaOQhHrUalmg==
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
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1ca034a5f653..d4ed0f397335 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
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


