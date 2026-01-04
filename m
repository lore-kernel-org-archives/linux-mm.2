Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B97C2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FB66B009D; Sun,  4 Jan 2026 00:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871866B009E; Sun,  4 Jan 2026 00:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AA16B009F; Sun,  4 Jan 2026 00:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3A56B009D
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:41:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3347EB817E
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:58 +0000 (UTC)
X-FDA: 84293185116.28.FF5DCBB
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E4B220002
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:41:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b+MyifK7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505316; a=rsa-sha256;
	cv=none;
	b=FP9EjIMngd1+j5H80d3KfyhjCQM4vNHSCeowIkAGwddK+t9yRw5mRd5JJaBVC+YY/8Wd2p
	NWmo8RCZQLmPqHRGABPCul7fAnrcMDo/SXlzfYSSLxpbAuTURo7zVMcj2MaU/omUo8QhzW
	Zob8OXF9F5qiTnPSzaeZiwlS0S6AXmo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b+MyifK7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUwkpMJcxEqSkkbLVyH1UfcFj9WYjjkK0bK86vvl/Zk=;
	b=losmDPz9+b1rCd/Spu5C/kgn1qTM/0TgLVA9502X9miHlk4/xCoELNx6bnuuwJkMLLG3U8
	182FTO6K9HzK18Te6a4HqtjZf0uTJm+pVNAie1nsm2WWfNlKFNajSSesn+exndl48YFLu3
	Z/BijH6TiEV1ZVq+EZU3dRWs6sZjMH8=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so16013513b3a.3
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505315; x=1768110115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUwkpMJcxEqSkkbLVyH1UfcFj9WYjjkK0bK86vvl/Zk=;
        b=b+MyifK7jAdPXHngx0e583yMoasOnKV50uZz3cIywYPRPZw4uaSl+10UWFBYc88Py/
         JZxKMbdB08sc+ONNDXCxLb8Eed3kMGu64HCUAUboPXYb83CcV8A5ufWFG374vNQzQ+HL
         fcJshKQ8HmbG6MuwqtOVcgbLG9YTzQj5KxMKBTsXkKiwlL6XL3AvA77nisWLETRIJNPf
         iwSyIA55kI7itY8WLnDWyQcj9HRjITQfC2YN95UxvvAlgQkgwRJpPDh3bjccKVBeZoFG
         0pxL0/DzOddylb2pF1UhejQxWV1HajhdPio/axUh6WngAoHsjgJM1xSEG6G9iJxNguih
         BIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505315; x=1768110115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QUwkpMJcxEqSkkbLVyH1UfcFj9WYjjkK0bK86vvl/Zk=;
        b=S3jvv2QH9hBO2iIn86/qYBjwjP/Rf7r8DdYYSkWkV5G+hKYu+DcYJ1mezMOsNwGjDU
         bmk9lGGukGXnGtJI2uWvczcexemeZMTkC25LNvpaJM0lrnQ9QkK85pT24iUJtnuew6M9
         4FE3RHIEc1wsJTYhePf1Rpbwqn40EwdpCup5shd6Z9ssj6vFzarifagSEKHlkz35yAbK
         0iPdinRYYfECcYNdQK0foVGa89dgLQiTvKoYKzjRSKBi+1Qtyy9Di8OdcDGFt5rUsIBR
         2LD+QRhoan7IPBk+OlSqGCD/SkdXuPaa1xua8cYGWRD+wAyGwkC1jqMZy0hNw04Onx1S
         vi1w==
X-Forwarded-Encrypted: i=1; AJvYcCUFdqUHQKjAeKUDWZaBbk95F2BawaF6RTPp/i1TA42leowNi+xUbMsVFqsXkoyhW75vynIsPwth4g==@kvack.org
X-Gm-Message-State: AOJu0YyjxH204LSrfa7cF73ZdmPuYERng6Ly03GoIKKikEfTVh/uR7x5
	2nrv1KFf/EhuB00n1eQaPAW0/HXMaFUTG2Gnc/Ha4vuNH8Drx3bLbuz9
X-Gm-Gg: AY/fxX4z/E37GXECvdYUx5KQise/kZpL6W4kQjOBQP3Jxs1fGqy5aoQGVbkibOvpeG7
	rQ7WrZ5pQFXOVGDAjgLkHRnJVYh1jm0suuyvCHNdTNvCG4w1XTEA/mECXsFZ9yT+8tUKGjJSOog
	kkkRaRkmTvytMLOk3Chc3xp4YkSqjIPbRBPsPZ80PeQ/mnvmDVmCpj+JTlAV6mDXTOxSvnJVkHx
	AjlNaQ+kQPn/4s0WFkQ/+BISP8Td2DlTZZXujGNM8EYKfch46SkQMmGwMv0aIS1Ft/oLRFJRCbH
	WiUL6sLiryeoHiRLD+cGTRsOOVFqpghlJp7wYZ8flX9tFzKeQzG6PrbI+K9qsvYD73VlX1j4HGh
	f/uBtAxFwfbOEfc0bpdh9IdKdBLgR6Nx6tBhcuEWqaFLKE+l4BN0e0rc4kPVZwugOIG2YwZ/z6z
	VYdPM4pRwBbJv5EYWxGAWao7fGcR7n
X-Google-Smtp-Source: AGHT+IGwHwdxXTQyKxKpW2n1/+t3fWr60BwAf/OcttAH9+pfbFW7cQq89AcUb3EhW+mxdXl3KrSRHA==
X-Received: by 2002:a05:6a00:3385:b0:7e8:43f5:bd1a with SMTP id d2e1a72fcca58-7ff6735e923mr38179784b3a.47.1767505315075;
        Sat, 03 Jan 2026 21:41:55 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:41:54 -0800 (PST)
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
Subject: [PATCH v3 3/6] mm: khugepaged: just skip when the memory has been collapsed
Date: Sun,  4 Jan 2026 13:41:09 +0800
Message-ID: <20260104054112.4541-4-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E4B220002
X-Rspamd-Server: rspam10
X-Stat-Signature: cdkmj1i73ikozjn4fos99zgwrz4wxzur
X-HE-Tag: 1767505316-237058
X-HE-Meta: U2FsdGVkX18sn9WoO9He6HTadqm3r2oXC9ArAwvaO5OWMStRj8Gari9+2RehA3jAuV4vIUF5KiFI2s3s+5QuPl+R/hZUJPqIE48CVWHwOPXM3K4m3hZfUtVvzubD5cupViafcu/b9XLOTyHJDwYuil57dQw+Fj7zHfrB6t2sFml6PzQRy5tryI+nNrH+vS0uGpgb7mOQY84NUfQYyXFv+UN9IO3ICYjfa1mosk5oxgJ95gQZ/dbb4Vq/e+bRSWyVbO6b+y54kMqfheEzMd5nj9p2iAMx75jgeDdNc2MaKu2Sk4/xpzMBvcpJuDh01X4Eor4Ax4pqiw38+hmRPCI1+zbuxCZaVhDCWMjOQb4ZW7LQh7DwsnWklrI/LhO2wVKSIOy9krS8X3rnhAptB6qdlXNsK3FqmAjs3ygxtQyWVhdbc5/hdUDFtrf4CpAQV2XlAQphpu4hOskUPzjF6kmBJX6gqKf4LLU5fcM/avqq0KUNmkWVZvfI+PZd/cyvvzn4+I+zRVVLITeQc0dEClou+kiBKs684SuFVyKHoxMGUewDI4iswCsTujlUAzGqMNKi9NtGyWKu3H9J4eC0R/4w6SC7eZ41EapJZkoNlU/nNi0oK4Qt3qUptXuG1a83H9uTsxN9X3dLSvveslUvevHYGbTQBCoK5QIXxcgEcbR7LUyO+Ikhje3H8cmwNDpeK7xhGKDRJcQWbdUqe9WexCnP+OCE7PXJcJDBNhtjeYDMlMP/ZkhEcRoy8wtinCsTGtbza+sqhuXLv/HtMj1eQcktlGSo+PLjXCfDvf5ML8cHWcsOkcI40zYe/Rqd8ALysOmPFC4cL+fOphJ/wVAtlyeqXyKK9nl9uvVk+fE5uQFE19w4571fT+nsBgryJ9dr31l9YIn8hFOiceyLJBKEWXd7vN/MEWAa9lLZPYsTIeuHbORPY6/FYyCR1D9N4i5/5fi7gB6lzF9a4RnfdZHVlyd
 3bImAwdB
 8CYwctOihL1YtpGwGM7lfRGyRh5MaOsY9UCnX6R9MoMPL5ROPDKNeI0ueqbBggsGZ2rxsNuxRKtqCTJnpDYUHZcHQEYvf/qNmwiomL0jjmmHtyCKUMwmPQyl36hPUGJD8Ks+DaSzeBduAGIr2SxbwA0WYi9LkiN1EhzH0koFk4f0CyyuPusm/2jdRPPFOMRYPMgw4Qdxh4PU4dC6rCIrPF5Wye5XioSm5890VUg0POoYYHX6yXqTs9Us/ZSK/XG8XtyCeWDupiJXRmo0LuhNIzaJU6TWR07P7h0IQ3AcfL3WFxVsY+ReRnitXLX617i9fI5r5N2zV/hbnLxNmxpMmcfGWE96Ydz8gZQ0Y+qHl93AfNcIAP92KVybCAGVoxKNxBfpV3jqHH7IVp8fRjuZFI7I8gDl299c1AeEsC0jQ8o2eWq7ZA5dvvLDfOWUWrm+mEE7iHsw5nSAD7IA=
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
 mm/khugepaged.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b124e854e2e..30786c706c4a 100644
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
@@ -1264,7 +1267,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
-		_progress = HPAGE_PMD_NR;
+		_progress = 1;
 		goto out;
 	}
 
@@ -1272,7 +1275,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-		_progress = HPAGE_PMD_NR;
+		_progress = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
@@ -2336,8 +2339,6 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 			continue;
 		}
 
-		_progress += folio_nr_pages(folio);
-
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2349,9 +2350,12 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 			 * returning.
 			 */
 			folio_put(folio);
+			_progress++;
 			break;
 		}
 
+		_progress += folio_nr_pages(folio);
+
 		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
-- 
2.51.0


