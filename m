Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F28D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 12:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02A46B0093; Sun, 11 Jan 2026 07:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE40A6B0095; Sun, 11 Jan 2026 07:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11276B0096; Sun, 11 Jan 2026 07:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 938716B0093
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:19:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 341EDBA386
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:54 +0000 (UTC)
X-FDA: 84319589508.14.76E7B3F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45E80180002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:19:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BgM9XsL2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768133992; a=rsa-sha256;
	cv=none;
	b=eJkNvJnmX9c16hnr/irDOHEwcPOv/RlLqYbooRoU86cYMa5o9eo5P/eWasuy8nu6h3iQfv
	vJdfzwNO+Klt+ESZbWIUhl9b7RV8yoHVJSIuGP1NJZOtPvGzYV7lduG2xOFV5R9dZUC7ms
	o9sqZjrRWNOZ8IZg2rcCMHO9qqP+wTc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BgM9XsL2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768133992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzjqHFHsTu/NzGPB+PE+U2CGfVjIazwd87Qrshcmnl0=;
	b=PIEYCbpIEQcv8X0R72sJ0kNQKchgKHPOI0vDmvEMQZ94u0KRGOEX8KihgB7PlW7X5BZRyX
	cIIA49HssspMe62RrYbUqnww4IAnyz477rlJ135j/CxIG+2ySFP7sB66N54AfrOKE2RinY
	WcXSydoqw2VqB7Vgp86Vx17GZ8odOQI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a110548cdeso39684695ad.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133991; x=1768738791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzjqHFHsTu/NzGPB+PE+U2CGfVjIazwd87Qrshcmnl0=;
        b=BgM9XsL2GboXfWtmt5kRrXfXhRK37+pw+l929YWDprj8daFAMVDPIeImG9/tpSTOcE
         4v5JhNUksT7iTnSQvMaL5xA4l0U5Sy4EcJEWj4oe8fWVrOoyDEof3QzRAuVuLvoInxYx
         XaYKkdj+V3YAtb9z65Q1dW/Wtka+a2dtfK6oicF54RIZYu1GF45FP0YjNtZGPyax1I/3
         3a8cbh3NkFcq+zemBaEJ4Jep76eBO1KJINfg/Y8Ez0RQMEoWnNxXOef/IuBWz9UcI0+m
         LrhOCCiaA3DNv8Xmw+6anxMWZJnkebw4HzaG6LWRSVepVGDtRT/YxUp0EOkbl8rQMv0l
         UKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133991; x=1768738791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zzjqHFHsTu/NzGPB+PE+U2CGfVjIazwd87Qrshcmnl0=;
        b=kJ6Q9QCW1yyjWN/AI7MkxXITRZf31G5vUzpsbFCYkf5QJH2ORPgcST58mWYjYqyRpR
         cdSaEQUz8awDHzYg283ejIQ3OooZcwSFSOkDTXACtwFT38smo9Qr67xNTaKJtzlWZBXu
         QmIRMpyl89qvd8z1KSofThlnOovTumhiX9iDpiHm4xUxWoVTXO6xw0wxv1AuekVj0XBX
         zaTuGsZZcqa3TFw923dyjlt4mZM0LPF1XIA0tDAAeqz1M130Y7j3HHriIsBjxZhBTaUo
         3mIm19icjKmpZaMlnlauFx+shCpYkHaZJWbXnWsJnqoYKaiRDDXWtUAFNrWmkEybebeo
         s/IA==
X-Forwarded-Encrypted: i=1; AJvYcCVbRh5OBQ4f9fQiKN1CYeKKv6xRDXdM6TO09BlBvM4pnaFiqPE+27p9yh2m/N8Xsh3XQsncxUlR1A==@kvack.org
X-Gm-Message-State: AOJu0Yy5UmjYI2on2+PXO2rx3P7/Gh/cEHgAet5ycKEeUA6BKPk8cX5j
	ZrZwUshxoXdGvgjRpwJIxnGQvouxFneDqEL34lUsnKiKYAVQwTLqN4yz
X-Gm-Gg: AY/fxX4nuovHbMTR7Ju331vY5w4jVYr870uz+KsFvSfnfOsTdx6l2CFc75ixw8I5PC2
	l1+va7/jxp+f0/s934CA0LWZjbD5mAWk0zFgLdRe+7jpPwblg8UQlAimsibHeglN3SF07V6PChN
	43822zPMpkujO0GTC6Lt3zp6QKWJfL3vSeqee7uJKh1kbDENLd/HFz6o5ISMtVDBDoleLjXM9Rx
	j0T3WeqeoGhFeLTeJwrwqwLdqQQO7l1NXJxmH8UJWe8wO/W87x5RJ4TlLT96klNoasZcBlRJYF8
	PXgbk4rVWcz85xn733r02hitbAlHKqM7QUnFxLdv8u7ho8wuIUU00G0HHjULIxu+R9bW5Mu6VqK
	L3NEOVK7DjYWCPraA0ye8Tpsc+pBUQ2Mi0QwAKBTo/+zms/pwDuuQ5jYJJnJ8Uiu3HF5GzcV5Q1
	cW9vFadiSXM7y0T1A7MmM9b/T0Cn4zzg==
X-Google-Smtp-Source: AGHT+IEoqWK3ugDB7/VD7wzPQM66g18mZY1tdzLq1qScr45zyMjWbfKXpi/m32xd7/USrBdm6hou+g==
X-Received: by 2002:a17:902:c402:b0:2a0:97d2:a265 with SMTP id d9443c01a7336-2a3ee452277mr138508085ad.14.1768133991082;
        Sun, 11 Jan 2026 04:19:51 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b07029fsm4877954a91.2.2026.01.11.04.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 04:19:50 -0800 (PST)
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
Subject: [PATCH mm-new v4 3/6] mm: khugepaged: just skip when the memory has been collapsed
Date: Sun, 11 Jan 2026 20:19:06 +0800
Message-ID: <20260111121909.8410-4-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111121909.8410-1-yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45E80180002
X-Stat-Signature: iqr5eyy3t3nue9xiop41u78t1pq1httg
X-Rspam-User: 
X-HE-Tag: 1768133992-342601
X-HE-Meta: U2FsdGVkX1+jB5we3mnke7OLc5j7ULH5pBixWuH+SdBtLNuWZ6S+uwibn+1n4IER5EbNU9rPPwV8vBXR8WNUEonHrVYniX5SzVmkNd3t8MBCz9hlU3dbiE4QU9NqlYjX2gbBUy5HLFxTqAPm2L9PLKFRbC/q1fi+ZOcqqQnaXouxZqQmn/hugIVCu1mWNUCU9V9JcapI68meE/qGwuKCY5Gn10bPpFhOB8QVyRqHFeJMS4cFxHXJrMdjrtssKruVTAIYYxOzWaejRrkgnOGN9/sdNO7NYrojoGCKlvJ0J5o/NKV2+gdHMcVXbYZyK+IjK3qSH08FvS1ImeOaanVAMIwxSJb3wMIZ+/XaY73MjKMYBN9u6+5y2lbd/y3IjWHJHQf0fw2r4yT1sKqJmRZR38gjgh6kVmknT+XdK0rERjdCpwOGTwnHGt1kc3DA6xiVYa40S4UI1b8cvNBnVcuPwzbiRx6HlRg8ew+G/tGlVY0qqLxIq7po8ej5BehQ6Rr10S6SYfYy88Jfxxu95j090YuhlJH7ZCmwnJUpv3gqpJrQO7nFtPd7fqxrVw+XV53t3q6Ewzj6CihFlYpikww72Fh9skT1WWSA83LgNvTwiTnbsbURkfE3POkiqsIGZtaflIJPnA1d6QW+QdeyoSlGldde2tpccK/VQ+5iZwVnN9zFuECP41tCuHqiFe6y8CgyJyXuHHWfTM/peI+LrzoTlUrsx42q7iRKlaAGhsMUrqfd7Rb2yDyn6n/Pav59mOEgeVEOYYMBy7cDtqL1hZIaQAj5bSjtVb0XTlzaNZ2oOQC8/qKvXsUuXDh+u/JjW4ZX1SBG8BFn6X08OrMH6J41nf6sQS5cVSyIpteIzaFxFx1rCYEM0yui2pUpPqx4Uzj4UsMtVwyImWi8l57nNAPXbFzPB+fsTW9S1miKwTRuZNnpCVIK2jeq+SGw+ln1VgevzVJ7U76oJ0TPogvmOVz
 a+VPXQOF
 heMThe+Iu62cl/rFvpp2IFGm0bsYw67ZZganzNJz1o5USoijq/xPETAEnwbZmd/H4jWOXq15fFVkML4Qjmq2bAsPJdwZCkLEqjxNWHS4xJAShp6Off+UMlm4C1FVlgac+JUFa/fqjcnsTN8NQ/10/LBMhbpsDeRS4ii0e5OkK5cXkluxA5ZsArYHoZkuZJ80WHbY4pwkAYitrTFA6Kt05JGSheCpAAZ5ldF5oewAI/EPBEu1VioAijWIWQm8EKpPe4weHovfdWHcCWVyeakM/DZGxeQh/0A2h2mRNuMyQCwlTU7dLz+sjV+nceQ/F7POtNHBLZ+pCAsM6SkRmW19pgKF7t3gGSvDWD2Zzs0sFxzWdvhj3bHXA2D+CY9S4RAhh3Cfy
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
 mm/khugepaged.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5c6015ac7b5e..6df2857d94c6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
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
@@ -1267,7 +1270,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		if (cur_progress)
-			*cur_progress = HPAGE_PMD_NR;
+			*cur_progress = 1;
 		goto out;
 	}
 
@@ -1276,7 +1279,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		if (cur_progress)
-			*cur_progress = HPAGE_PMD_NR;
+			*cur_progress = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
@@ -2347,9 +2350,6 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			continue;
 		}
 
-		if (cur_progress)
-			*cur_progress += folio_nr_pages(folio);
-
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2361,9 +2361,14 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			 * returning.
 			 */
 			folio_put(folio);
+			if (cur_progress)
+				*cur_progress += 1;
 			break;
 		}
 
+		if (cur_progress)
+			*cur_progress += folio_nr_pages(folio);
+
 		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
-- 
2.51.0


