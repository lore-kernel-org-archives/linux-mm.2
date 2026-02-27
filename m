Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495F3103FFAC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0216B00B7; Fri, 27 Feb 2026 17:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C82F6B00B8; Fri, 27 Feb 2026 17:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEE16B00BA; Fri, 27 Feb 2026 17:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC5A6B00B7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:19:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28A431CD89
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:19:02 +0000 (UTC)
X-FDA: 84491652924.18.E0CF8CE
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D82EC0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:19:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=htFgB1nn;
	spf=pass (imf22.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772230740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZgn6EROfNCTDjJXVBWH85Hc5zFSfKEyA5xUTLk80M8=;
	b=B4CjQI2o6jo3tr9nxiFK69FWzUcd1zrf1SeJ6uVZlEw/JSECRb7W3MbafQ33XN8rgNy6Mi
	qozx2oAExudB5NsmrcBeq2fa3QO2cbO4P5QnoanCz3/DZbUDVurXsDTdCm8VW6SH9iqj/c
	hIwcfZ12lb5lWkDwNMEYFgbJDYneakw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772230740; a=rsa-sha256;
	cv=none;
	b=zOKxT8ZXU/vKmCLsyJGaqjbB4XbeVsUoHjedt9LTNWL5kJflvp7pnxgl20mZd9fsFF7xEf
	/pfrWV84E4G9X1f+gUwO9sHdFBWNpIncoEf3SkAnjIhIxrbL545z+wnNSXiGczh1PmmlEh
	sVMxmu6KV1LRSllr0+yS58oqDOxus2c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=htFgB1nn;
	spf=pass (imf22.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id C851226F3E;
	Fri, 27 Feb 2026 23:18:58 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id nJdiJIdBHx9I; Fri, 27 Feb 2026 23:18:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772230738; bh=M1kB3xBO0gGt9Cq4a3VvzqYU8hJTnWIcMiuRFk/Dh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htFgB1nn59bHdPVnMCXKo75jFeyJrVAWA/Kmreo7lovpm+aVeeeN6Mu5Y5g2hdYBi
	 GnmuHYUUpYSo9XPHI1NVlaWhJ47TBFzt4x0BTsF/KTnHzuiTUYg8rOrho5MvEe3/O5
	 x2MCK+ZnCLOoKCNYRisqYK7TEVEMJhSHTYF/EXPk2QqUijiteysjSvr512J7hO9gTF
	 v3vg2g62vpHrKpcoOJiHnqg48fU2drGob19wkwNd7Z5aad7LRSj+Tq5U0aS530csuD
	 zPeKKn2z1d6AUonCB0sy9L6w+P5Bz9vI3Si0yjwvu7G0/C81OcADC9z2MIiomrvubG
	 tt8Qz7Jcm3LZg==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH] mm/vmpressure: scale window size based on machine memory and CPU count
Date: Fri, 27 Feb 2026 16:18:31 -0600
Message-ID: <20260227221831.30346-1-mcq@disroot.org>
In-Reply-To: <20260227163333.6394-1-mcq@disroot.org>
References: <20260227163333.6394-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e1bu433obcing18tym9npzbhnmz6unsh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D82EC0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772230740-327948
X-HE-Meta: U2FsdGVkX1+IjQ6Ri+divixCZFaswjQGdEoRRYjF8PwUDb/3iCCd+ZWlVBUWWyKm1WLhwFxLpBqfk9tJnStzxwcu1VCfShdh3TKz400gpaX9h8+UjAgIcO2Mu99QNnJTmq6iH7xurKfgmW3T1LLt6/k9HlQTM240q9YT3nqrWinnizHYKoosKDoVHblFz2yH0vCbvdQh9tAC/DCsdGCeCrVWK9Tnq17xx1InCiZImspA2RJr8iHDxuRnGeNw1+hLQF6VTv1AucbK56D7HM7VtC5B+gKbEipv5Qvr6kWp0eOnPrB42r318Z3xivsPJniRABMjVWCgFROYxbdZIdIaV25R76D2gULGvSTlXIoby3KuCvrxDzXOxlvIjud0of3BNgAxHeMGfF31r8X669HoEP1Xu/tPBXhWKbJX5vAbP2VaZkRGtqSlHbP1mFEZ+oo7b9G0/zdHxPbOX7LbrDHb/LHcF3lj/6onwq9QEQqgCRtyUHU++389FQkl5oDK3BjoaNgeAgnNEIhEc/dYCw1R1DRIEeobtRI4Gp4b3KeVHHQViKAuyMU8zwvMe2xcBQ2K9ymrYknNJ5lb0UFo5iviBKC/iEVgSz2rgH764Gc6SlVc3fY3gxYNjvFV8zu9fmh5ELGwammaSEky7aN8CfIb/FTauQOmCM2EefHHzXetaigWQLb1kjstLgfGg7GWwJq400Nkyo5T4TucSU7MPCOZV4eKEujntX9RYuwNv63Npo3AjxYv5C8XQP3OuA2Osi87nSSNTOKqoYl8agf0cz5qS1p5nWEGuXZqkLcBmEcXlERMLJlzF6w4jY92YKDrvxLrZo0zISXPoV7JN3op/Xcvhn6HyKka9Vn2KRwO7plLfdEbcVkCx4gPXHOeVxE3OoQOg4uFJjtmRJF1CN/6ihZ/orxLEz2+FFRQHRuU+EkexyP+B70fza4+0vDr6Vhhpfi90q8kEWTVeEkT2Nyb61u
 SelyeSLl
 h8f9ZapMno3D4mkS3hAbVjATbkugaT7emjItxuwolNggKu7pHvmYO/0CtjlYsvT7Vt9AyzeJM1AgmVGzS7UU7K8U9pU9jMFkzGPI+Fz68p0kcqKL4Z2W2KYsAqJWb6NwZbFGZZpyYjdDAI/u7lVj4kzOAVm2mWn4EAiYhBJiWV9rx/PAJpsqPUuYsxUQS0zQrw1A1wZUcxdsJ7bA1VUUXOwx3ZjIlB4HmWUv0Yw5+s+I5XB4mrDki6w2k946dt33RL6H2NBxyFuwaUasaEnO06nSaFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

on systems of different sizes, the fixed 512 page window may not
be suitable and cause excessive false positive memory pressure
notifications.

or should window size be capped to avoid excessive notification
delays on very large systems?

v2: better commit msg, also tried to fix the whitespace.

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..925659f28dcb 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,10 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Window size is now scaled based on RAM and CPU size, similarly to how
+ * vmstat checks them.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
+		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.51.0


