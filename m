Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7214E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B626B0092; Mon, 29 Dec 2025 00:52:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC1E6B0093; Mon, 29 Dec 2025 00:52:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8676B0095; Mon, 29 Dec 2025 00:52:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C56FC6B0092
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F9491A0ABA
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:22 +0000 (UTC)
X-FDA: 84271438524.09.A0C6D0A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A675A180003
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kCZwRbMG;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EARtjTW69X1feehvRUMcsBqUnG2mKJGDqG3MBoLBks0=;
	b=59ODMuLBt+8vtx2a6iFQI+67j/GqzCseYM/dJfy5HzWX8geKWjgSFZNVpC+wtmE0ZWtv1q
	mshL6CmsWk0T6M3l32NLigcHUPy+Eg7ilUt1FQ5vBxzkD9SqT94zZMQvHvfJ2Gj5g8elBm
	LTwyoJqwnS6R5Pd13pWYX06d93zGEV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987540; a=rsa-sha256;
	cv=none;
	b=ALpizQFuV0oc/brjczTx8moLNeVhnCWmXNudH48QaEyAsxNRpTex9srW4fdCW9A/pTDl7e
	cvFzimEC2naYuwIwxxgtU4RWHKclko2PKl3e+YgnczDXDmdtGnOY58yF+tiOEAnh2H9BOe
	HZvv4duaCFlI/1z7Jb5yQ4FbCeq2SPQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kCZwRbMG;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7ade456b6abso7097028b3a.3
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766987539; x=1767592339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EARtjTW69X1feehvRUMcsBqUnG2mKJGDqG3MBoLBks0=;
        b=kCZwRbMGn93k8QzWZywIc/6n5wVrmlSOLJ7J92uSkN0pBJkCwfQWAs3ehChvtuoA+S
         tuPVC9wjhSAGfg3Mv0PKGGIOE4M0ea7j6k2zWbSAJT7E48D/AraXJCb3cC3R+801GNpi
         hWmLTGTuZJlewRsONAiNdNz+cBNzyFkHaxFeJUdl8oM5IBoD2sKB4THSfyXfM9xwacH2
         UGi8YgemolSzk8aSIF5jyZJZxB6a1IkaO0ynVEaEf9bAABXJI6CpgBYcpRBjEW9sxcSk
         eUPONw6sYxmD7AbWABmnirzT0BMRleJAmar4ZCTAb6phoiDMB9LxuQeAx8jM4AGAqWs2
         PCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766987539; x=1767592339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EARtjTW69X1feehvRUMcsBqUnG2mKJGDqG3MBoLBks0=;
        b=hdvPqGWOYhL27pEEamvaK05G9kPerutpxW6XIbrmKE9TcjNCElOy99IO5PWa4Rt/oe
         lGbts9IIKmxTu7cbiAi83WrIrdkmqrXqiFLnYSeO0+G6tZYW4VIaX9fc4vWyNKpXd4Sv
         Q7lNwpbMr6rRZK5ihHZisgY3cMPmZbprPhCQtJrHaHzHe3wVucT3Trb6FEOILwUrKl3Q
         ymGTVEsZP1iIRb2oalvp2s9nUKyEWQc4h+hqIdQ5vuBJu/9Ci2YP28y9222yZ89n2j7h
         J6YVN9kDeVVcfHOBGuqfD3dHle/roWxiIN4xzm365bp1CN2n5PzTznzR80cpvdyBHfHX
         nDJA==
X-Forwarded-Encrypted: i=1; AJvYcCXMV0mCpO+Chb1ZPpQkxX/bdFiRU3qDB3aUPUbGi5PS1skqol0tQQhrazUys3wEEc/U8SaPaGYgQw==@kvack.org
X-Gm-Message-State: AOJu0Yw+jjhjU2IcwdEaDgLBdzH86SEXJPeoFq5pdbHIo1ALFPZSgBF0
	5RaLd2RD3hbTzhc4XnuzIJMrkp8rYNhN4ICQ6WtXvx5Vr+aa1YfJHwo3
X-Gm-Gg: AY/fxX42BoQdVhp9SNhD8vvirwp8bHAQl/jpraOIOwh5HMSo+QmNtTH8Zt6U6rzpeZc
	1qabYZetpEg9tOVdPURlxIdzbXNu55w7zgCCVe4+NAZlI/isSLkHjhbUJ0OpLFfSSv56Z6nQuBH
	b6/ezIhKN/s6ZpTbGUmUo4+rPTt9EOdAgy/WbJp2YeaEAtvZqvyzD+jt+4vfzPPbSEiTsl7Gzkm
	gq/7ny/Tsx+tiuUs7SFehgTAMYVmBvyCHCKaKWJpw1u3+TaXQNyEJMtnbrVBxzM4EwX2hl79931
	Z8KaSf0VmKgynE88UxGFaKYEb2so4tXLsKheidvR1nkkOEP3R9NgYDCm08PlPPLEJ7i3S7szSHz
	TsX8xmMSt/0sfgF7B/BmC6895KF/J/LWp+nk6C7l+pOwthblaN9UWt+Az+ufaLTxNh9mIYulpBz
	/LxonFC1g1Q98HO24nABcF8mqlCkLb
X-Google-Smtp-Source: AGHT+IHVi3ccRtDHsngBuCENxg/OidCCTnf3ExwP3w2v4XiSKIa9g0fHlTh7h+pojj04ZQfQ+6JjDw==
X-Received: by 2002:a05:6a20:6a08:b0:366:14b0:4b04 with SMTP id adf61e73a8af0-376aa5008c5mr23752758637.64.1766987539272;
        Sun, 28 Dec 2025 21:52:19 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e920c9a7csm26164019a91.0.2025.12.28.21.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 21:52:17 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been collapsed
Date: Mon, 29 Dec 2025 13:51:49 +0800
Message-ID: <20251229055151.54887-3-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4o9a8ok1woneaxyi6p8o3om63hh1yf6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A675A180003
X-Rspam-User: 
X-HE-Tag: 1766987540-64158
X-HE-Meta: U2FsdGVkX18WcknCixUI03McJjDyTVAdYPORPPv90GggvGoJeGpxTwTQacqhhzG+v54qTFPERKmeE1okIg11+4LgwmRbBf5PhfI+4MRus08NXFO2lZwRx3qy4YA25bOGQAxzKbY/oIbj2YYTp4WEaXTUeeAbd+RuH5L/Oe/lx9c8w6QohRkrbX/Wbtm252fmPIz2v791lHc6DR0QVot87/NrRirdgH5jZOB3vz7Lk9zUZld/2D5W1f8L8XbtqukW1fiSKAJ2lAwYJAH9we4IR9+X+tv0rimNHf4qtVWOovhzl+TjuwOlo1iCMuo+IJC4dJ7uBoVlKZ/oRknLkozpU7Ce0RPkrkEnDl0zgWvWATjE+FNIa0jUQkFI6XIgM4PTjxph5yptbn28UaP3IdORAj1XPa6pYODhRL25F0aSmqAaptj5oZho9vdJGbIsv39PhpWOdBy30sw0tjiaVbMFHrusB8fUPQhadxfoY8ywNIz/DL2dnROupSZo1EoP5jHovIh1yl5IMC2zsnvsJrV8CV90lh2UH6tReCrwTM2910yFTT0r3qGZ1AnK+zAUYTbJ4D9J8+scR69AwcI0nEHS1TySK0By0mGXUiCAXapQEsBDj3Hh/ZxyIH3+hy+V7tAo1Frg11bB7/aIwT5Y6asbm9dJWVYx01tdcXgFocOrzmF4/q3gO3g9ZmSOGmO4GkFOBL0zynW8m+eN7d/G5CeQxP2oEUqkyunpDMnNRyMmpyJvI/5f6NXzmcLqhxwToO1v9cheeVNKmwrxR7AtSLDrejvi3sjs+sCdbvncrb6txqk62yDo5Nnkslfwsgkjs+lAnSJCXZNlb0PJgA3aGCY8w0iEPrblXCMnm6oKZdgirMknP+5UkGT8jAmfYTSS+KfA0v4am2GwAQGApwD/IySrxKzfFXnnTaL/A4PY8dtMNQptC+2bwl3wioFvY5yROdL4FwFGPt5Mm9cFPJc3NYr
 lG1yH62h
 bo5e/KzfjYFCPhif5eGsivvlqP3/BO3Sf4Yvm2PAcmx+wDktVRvHn21YAVctOuOQ5wAey5uKu+Angbo8XaCb1NNDi03kO4YOmFCr55yzH6WK+ectpDm0JC5P0A0GlHnRW7a4XZeIBkltAdCL6dx9Y636BNZj+4v3T2xLQ7vnNn2dV2eBlmJaSDU9tm+g0a0nQikH7+4ISmoUeWskA6bjiHkX9zeepuRSh/64jxIss7JLCImCIXzCinfGjQA7M5KQLsAL4kE3q1UejWNkV9DtYQffCugTXm0ob2vn3RmxIhOP34g0O5EOqV46SBMBYX5VvAWlOPRXtGD9dLWWvud6wqX2CpNnfcs/TVb4epR0NxTs8KwOX2QQfyLhMVz3KFhleDYAf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following data is traced by bpftrace on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
by khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
@scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
@scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
total progress size: 674 MB
Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged_scan list save all task that support collapse into hugepage,
as long as the task is not destroyed, khugepaged will not remove it from
the khugepaged_scan list. This exist a phenomenon where task has already
collapsed all memory regions into hugepage, but khugepaged continues to
scan it, which wastes CPU time and invalid, and due to
khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
scanning a large number of invalid task, so scanning really valid task
is later.

After applying this patch, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it, as follow:

@scan_pmd_status[6]: 2
@scan_pmd_status[3]: 147
@scan_pmd_status[2]: 173
total progress size: 45 MB
Total time         : 20 seconds

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f99f61689f8..2b3685b195f5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,7 +66,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
+ * every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -2487,12 +2490,22 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
-
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+
+			switch (*result) {
+			case SCAN_NO_PTE_TABLE:
+			case SCAN_PMD_MAPPED:
+			case SCAN_PTE_MAPPED_HUGEPAGE:
+				progress++;
+				break;
+			case SCAN_SUCCEED:
+				++khugepaged_pages_collapsed;
+				fallthrough;
+			default:
+				progress += HPAGE_PMD_NR;
+			}
+
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
-- 
2.51.0


