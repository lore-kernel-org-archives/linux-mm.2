Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0F5EE6B7C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ABBE6B009F; Sat,  7 Feb 2026 03:16:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156B66B00A0; Sat,  7 Feb 2026 03:16:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063646B00A1; Sat,  7 Feb 2026 03:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E95B96B009F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:16:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD771C1ACB
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:50 +0000 (UTC)
X-FDA: 84416954580.29.9FD287D
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id E24A0120006
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JiPJONsx;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
	b=n14U/c42+XD+qEt7uJikHg8H5YPSxT/p8Yw7cNDMwa8f/y8jlGsZcp/EkETo+ZOXr+DcWe
	dbc3j/ADbruNJcab1xAVzcvu9qmWsP1PipKFy8vLfUCkweOD7xfjCkdAuxPjkibH31jk8J
	kchFdBmu/CbpjqopWTHjVeRopBS/dVk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JiPJONsx;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452209; a=rsa-sha256;
	cv=none;
	b=mXgze2Wc35Zpqxyl2YPb1xI0qtAmDP5T53W3womkevdcbB9PPOYh1Wg3Y0QFPb1Y/5fUB/
	VxcxgAAavnM4kenb73U/oSQfO4WhM+2u5BiaDYssGXKR9l6nxBcFrea3lib0w0bIF1k5uG
	9bzBtJshsvTUciJI1VT0ZQ6haM0QVPE=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-352e2c59264so1927190a91.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452208; x=1771057008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
        b=JiPJONsxysBBBQ0qaCoe6c+U4Kl5UDRaVO7tNLhpuIDY1O+L2DSmHk2w1UD0pC0BJ2
         r6GtlvHNIc/Hz9Ynn6T3s9Pyo+pjR1LQIRCTgg9kishTRXvJJhITa5OKvmT+jToR/Nw8
         ZbiAc+cSXeoxM2ItOPa2TDn/TB0O7KyI4hfq19c8/KZUIqe8fXTlp9LJS2XCwKr3ar4p
         lVPKIptIJD90F4AU1JpoBHvj4Ta45fmS9B9RYnGdfzGbNh1TBCa+q7BJZi28iGLGMfep
         xtSu1hu95/lxYBlFpklOeFIdDA8JW61Qi49dlLvMwLzO8ahWSx+BV1YltHYF/UJ9NiRx
         f9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452208; x=1771057008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3c08OVs7S+JipvsoiksDQinUdwR5RLYJ0JjNcJIizyM=;
        b=fer1cCAGEJ9VlyWtm78fPpDm1pnniSGdrydVAXCUkZr7cuQw8DEgIE4ANLmVcHsGj5
         sJdhBweGN+aYHxnLyrCoJloYxL6VwPlXc739//9jUzC/Bj/V/2HFSf3xiKkKfNnqG++7
         duZGi7j3pQvTLa/O1fJIOvUqs4q1D1nIdFlVyYogX8LIUj3KVEAAyZo830ltnKE9nyOz
         dln2ShCJB4s1Fc4nSwQwHZGfPlnu7OOYpmqa9QGR2G8iDaE4Jubj1FfGzT5b35HoI5ac
         NK9uje1nLA+Io5GxM1nPKXvAey+Uuz03H4+Q9V39O/jl+hrWZwNVjL7Vvu2wbYuQN7yo
         o84g==
X-Forwarded-Encrypted: i=1; AJvYcCUeid88WefWkGC5YHyV9RMOorjVt/Sl9nacTCt6hIDyti8ZBOldWT/MwnbUv8pvVRzyeHAOwVIT3w==@kvack.org
X-Gm-Message-State: AOJu0YxEFB3HeHWb7kJvjd1nvqWg9jgHHwrVyinx+RU/fJiJlCcaJAl3
	wEgmCsVyT48zzNbN7OzDi813SfIlT/MqUIf7tsE5iImZ3Aul8OARYIHd
X-Gm-Gg: AZuq6aKMBhIG2PqBOgU+hLpVD/0ycL1Usy8WOTJnYfrSAjXapyVPrGIw6g74Q19DXhs
	DsTkyVELGOTW1xlkvZGBfPsAd2JAj2B36rWJquY8m4g4jwxKC5zBh9+tXFOSNkdNvsI6SeKMif7
	cHc/LXiRoBWouuI9ffoDBMNw+TuxwmnP/cIT4DZjPMFdImpH0c7XbTeyVjpC84WYjM2jx5IMoxY
	RxHGTgc74PU0pIKEvFQqYH/ibJ3bRtG+XQ3xX1XdT5YbLJXK9JyMxO75vRTAvrjeeI7pQ8I2I6w
	rFm+nr/ePLE+BBJM+zcXa/dKm5yEyXZqYD7Mnh3X7Q9ND637rLpg76AvTPKev/l9ZYpaWFuoRF3
	H5HgpgRj7OqLnUiQ47X14QA661pEI4BbfAdSKtdZGlQTknQ+2HCizK9eIehfrMSeMm83ILhVBPQ
	XDjyggresisOxWMS4ug5HZDBA=
X-Received: by 2002:a17:90b:50d0:b0:354:a05d:9dc2 with SMTP id 98e67ed59e1d1-354b3bc1a64mr4635025a91.9.1770452207842;
        Sat, 07 Feb 2026 00:16:47 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:16:47 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
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
Subject: [PATCH mm-new v7 3/5] mm: add folio_test_lazyfree helper
Date: Sat,  7 Feb 2026 16:16:11 +0800
Message-ID: <20260207081613.588598-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081613.588598-1-vernon2gm@gmail.com>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sse3s1sux9m6qt56kh7aewuywtpny7iu
X-Rspamd-Queue-Id: E24A0120006
X-Rspam-User: 
X-HE-Tag: 1770452208-152311
X-HE-Meta: U2FsdGVkX18h1FtAfpXtUnnkDKj5TIFW0C3wbDZcSBCykonje4/jZm7xszMQS/lY4J3CmRtS38kdTs8LG//KPrZD05puE/qAya0KvaV+hVELuiH8kB+5DX+ILBRoAeFjpyTVKaUoACSHoEHwCjgnp4tvFNaGyTFowMrWDeY+93g02Qur+i4+nHF894snO/lJyvc//G6xLi6DDDwqO6zDa2gn3qPq80tzDxHhOWsvuRWXQTP03pxErw1gcF2iYO2dJL7VaCK+mshiuLQupgP8mXz5ML43DC1l85izErAcblk1HGZEjYu8rYR3U66hKJ7tkPzd9My+pIfHl7Vh6/BPpE0s04hPag2UTPI8Zgi2C/w0rMciwE/oUgfhi6yeRa44N94safgUH3CwyddN9cwdoKApnEbCOoXQWBTC0/PK+il+1kA1dxszF2wQeEYvCMEVe0WknWY2cmHEH5xTRzlwAvXflatEgoePTdrQeMPaFVM84vrEIOvLEGBIIuIo7Ab9yr7105CMOKIvT5R1Bba3aPpZXOhOL9zKZzLWHYs1s59R1nH4X29ghYzi5EHCqL3O1imMRL3NQ82UJvHjiH/4Clpv7uA56PRXNFX8+MW9Yn3XcP0RTo5qsBwrGeZWWtO6PiiOtqsyw493h8XMOu4ghhFQK48VJWkwMHGpxymbKLhL1U4fA0F5I0RdiPfCKfj6BA6nkyh5RqZqZnqj80kpwA32+mmxcP4sKyP2e37Sy1u9nMQOAlbs1201G0PCGeNRMd7+bFDkD0ZVuFh3WZU/MMnYhSDrfUPxDOEZRbh3xIPjUVE0XH+yykeipe1WAzJ17NLou13+pv/9oP4xBSPWbRTZUf940bRScQk8Furou6xCraCM3MusyNp/ZBbWMzpTeAWh9WRXkX0z0cGG61/msye9wkrjEGfOcZeBZsn6A+L6YMnbRws6eEHmRM55MxSZvuGpO1eCvSdC9M863RO
 Tce2mzet
 iCJGTTAbeQOgIMURMVNwTbNjmv/nPMsejew7Pt+7HQZ0YaoQO6QvWpl5BV2LCrMHCWUCJY1jOdKJfRAgUmJ/1/CV4kRxfc9kwQPtN2uk6ocGFR0a8CczbRdfGQJKrRdrDmUWsr8F0Ot+lwlhPF3cXLkQ2zs4BVUHLV9F6GqqgERN6MkV4lNZ6IxhvHPvGBweBr7t51lOE3brwICbT+w8JffheccSRJawq2zuM+HRLIQ8V8+XTSgGS9jR5WG6SBXe4ORCIYmJstPKDG79jPhEjbovgIzChrGXerk2UXDyCPgYNvZmmpeg+hIAQBZvN3Heb3wJHMd3E6GU3IBMwrDybkU8QzCydtYx1rLfE3opO1rqnIrH/Ka7xeVFR31GupKgt01uA9d/oIWJwdLOzh2WptMm4E5e+KZLfC3swl6G3cbJSG+fH9w5l/Np6ishGndYiFaYC3bvI+RYFL18uDFrg4a2GjcF2AZ4IfStEhe4P2a6c65a1BJ0lDSinH7UvfbtxWsVSn8dmbaJP4XYfoklDj8z56aFd0Tn7xl3/IFevnqXAF6KIWsq+dSMzCF6xnl+0hCQVRHaljtmwB04gstzeRGKxuKAW02ezI/YByQAxetocs1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/page-flags.h | 5 +++++
 mm/rmap.c                  | 2 +-
 mm/vmscan.c                | 5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..415e9f2ef616 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_anon(const struct folio *folio)
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
diff --git a/mm/rmap.c b/mm/rmap.c
index c67a374bb1a3..e3f799c99057 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2049,7 +2049,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 44e4fcd6463c..02b522b8c66c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


