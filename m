Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01D2C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931526B00C1; Mon, 21 Sep 2026 08:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1EA6B00D5; Mon, 21 Sep 2026 08:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1C16B00D7; Mon, 21 Sep 2026 08:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC9B6B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:31:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C57111C0B37
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:36 +0000 (UTC)
X-FDA: 85237705392.19.C5E7A84
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03D79180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ibPXFwr2;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789993895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJyhK/H/cx9UDbk1fQ3qzOg9bJhZWQMaDj6VPrkWrC4=;
	b=tJsVANogmZAbmj+KFJJcbTCnvEvKAz+YIgI6dC0J2qKGnzN68lDgtZ9762fhvuLnWofMkx
	VypPkN2HhdVh/7/BVKs6MKq/54iYb6J+mhxAbNhLe2fhCOG7J5PGrf/qFC7q9ebdtSv2Y7
	RYhSP0xGwdnKnvshM1Yipogcng0PjAY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789993895;
	b=FgWALQj9L6GZF3N0/QZPXsxwpwu9IBDfgYwI4YGqVPga8iaYE1RDpDaIMibSsvRxvlTIFv
	7Ju3NtzHzIrI0QY5/tken3cEqUJKfaKDUq6O8aWjaviJspGgrsYkXBAgX6AeI21YuJgbJN
	yJjpCJZvqoPwN78lQQe5bdnI8fMArO8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ibPXFwr2;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=RJyhK/H/cx9UDbk1fQ3qzOg9bJhZWQMaDj6VPrkWrC4=; b=ibPXFwr2uzqV+04gSCXcVxns3G
	0N6SGj4ckD/GEGj+9xBvm5gc2lUWYpXaO9EGoQeAmTcgwnwUCfKPFP94fpIcoVjB5HywRUgzUF/hR
	P/iU7uXfEp0qRmAKS3eAQ6aObaPREGzcQo9tI0SmP6YEnP+iGJXDv7Q1hknLVeR9C6XLs6hfQgBLE
	+3mx/rYlCOm9+wYr2sw8HXCWia72DJTqwWByVSSY1xcnV/ApUoEcvbM7mhcs7kazjHAaJdOOw8Jp0
	B//KozZRjdxVbA7qQVKd7fWlnpmim48rsTfkOoF+QAkRMVIRN8wB5pDFCjIJ3qV+bNrrolsTKfBUN
	MjyV2gsg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8dBE-002CbX-27;
	Mon, 21 Sep 2026 12:31:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 21 Sep 2026 05:30:26 -0700
Subject: [PATCH 1/2] mm: kmemleak: move the struct page scan into a helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-kmemleak-page-scan-v1-1-fb97d4801b3a@debian.org>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
In-Reply-To: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2538; i=leitao@debian.org;
 h=from:subject:message-id; bh=yc/Zs6xPgQccUGSBvUxKF4tBdDWNVRPWwVRuT71kyJY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqsSOdoIsG5nmdHaB1wUgSXy9i1JwH500pnNE3N
 rKnFnTXCkqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCarEjnQAKCRA1o5Of/Hh3
 bRmPD/43icZSLUGLZ74SsnNFAMz6NWdw+tbqTD/eGO2VlOk2wSFuDubLQq39MsAJzdVK0/DREfb
 LPlqtsuWSvFjBEriJP3QiK+lkfkvsFHaFzK0L6sVRBBN78wBHyBqmE5rznQR8Lqf2B7xlKY9Mul
 HYYi+fdPlKPdsT4A/U2lrniCNziKKwip0EKsnIaJsSSH/7sO4eb9UmDxzXUw1zdYV7ECKjbIlZK
 gSRaXh/kfXQvUFBTnNqNCgLPwOWHnsbQo+N3BYh2YMeAGC7EdsnFMj+xZ6Rcu+GYz7ABCX7kqnM
 yEehZDzKAn4WBLgvV0hFG3lGCpzSzcr8WL9LT1PdWyZGBZRXBrOVu8koVsJwkdmi2mCyWShnq8u
 hHi2LMO6717dMa0FZ9Gg7lYfgpdRowt33o1xgr9fnPko2ob900IojCDijifeCd6BB8To9KLL97J
 1oAqFyDjTQy2kjjPvTkyRdHckfWiRqekTnWUa3lwtPFIjLAsbCGQZnZ+YWWiGMdkfrQUBGSYPJX
 CUNA3HZIQ2lzOaFi3jszMfEbxJMGTM5220SpiVDCvZ4GWFFWZF+Y/DHYFfpUCcwc+/RY8W5PLIF
 8luOvbt0/zosAXojGm6bm0G9Ve5nYHnrmaL/z4ececCrm8AcFv09NDofT1MvH8U71UStfiuDHVF
 NL5ckeoawor7maQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03D79180002
X-Stat-Signature: qmqw3ef87xna1xy3a33i4t1pya4e5919
X-Rspam-User: 
X-HE-Tag: 1789993894-98861
X-HE-Meta: U2FsdGVkX18kWonp81MiwOd63YRTKniNt67Id53imVrQ29Rz2pFXmHc0fHqbmJKcDa+JfnDaRkxoawfXcI/zFCuhuwzw1W9JmR0r0frozFLdm/v9V/SHzjvVuqNbxPqTyEajalA0rPQxNvNa0XlWaeatEpPjqKxC2Z2P/hd2PnrecWfM4DREiM2ev4qr8KoNLWbGAU72KT8a0w+cS+K3rG05ijVAzmvdPsp1Z0FOAYot7BFMhT10n94xljcrURiwq7RimrYASBzgNhowRFmvTshJOBV/wkZ/UNaflJZbiZoA/6kGrBNTwYD1KDCLQ5y1aKSijU2rCef5DkCoiTDSrcY1bJGYhSRAAeEmEvFlkxLXGUlEnFbnufiOVJ5VCidu9cd6TBoRV9R+dyRSW2Bhya5zRTL14uViAWQnZ53wmbzwoDeSOhbYI/0+Bc0VxfJPMCDaV8I49XF9UAg/wpd5YOM60xMVYawZwe1yPxUqQhjrcY8NLdLbGSdB45Y2o+6AbOfFyZxmovLXfyN/yh55hIeuz/b6+fHsuJ0ujgHctqKYghEHn24UIByjwMXJS6/LTz8ddsUGvpAZhRuorfxKoKxtojE3k2yPV79KM52mCqOB1GrLNTMAhZmlWSayToI3dAmhfetgDmF1uMa8V6wC0JlK1m6WsljEcJyeMZeudlB8zzUNGK2u5/JniH45rZxyJU6J5zO8Cv5cDY6CMY/ckkLp06YUdkzO55SCIW+ecmWNr61OZNA1kgy/G11DhGN9dWPeKK0omTf9js86S0BPzVu7uPbIFmNjC0f0NxAi9gXtzUh0kIr7k8UgCObjN/ly+dtggMyPPumC/FCErb5BPsv92JtrzsHABR0lVDUitcYIqbtETBUahiddgLyFJ9Qn/r4fqtaH+/IkZ/NaggVpuTUiVjHaM7A0K1pzAIBkZa2Azm/VeSGDez2WEsY1HkUz96o7gZj8oZ89vWwAx4l
 Pm8+pAAg
 iaS10zZaUQL+65I06kJ2P7GsSKoPqAo06NQGb45u31xGLq2ln8x4CiChrGuTJL+KTWx9ZaOegWPex+2OBkLsEeC8AHcKF7crnmF5jViTbGwf+GakTj3uZQfhvIWBgt8jJd2V0uyxpd4YKlIOtc+5wQnDRqKvkCmZ4Pu25zQE4cI/+3ul+day2lD0NtSJIYBzobg42PlYRG44cbKYQWaufHxAklZokST+jVYbhakDPmEE50fiYzR9tK9jksSXWO4tJPynFGT9Q7VqxDUgmMu70LLb1pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct page scanning loop sits inline in __kmemleak_scan(), nested
three levels deep and sharing the caller's "stop" variable with the
zone walk around it. Move it into scan_zone_pages(), which scans one
zone and returns 1 if scanning should stop.

No functional change; this only makes room for changing how the pages
are handed to scan_block().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 57 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8fa409a4f9fb2..4040547a0af84 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1855,6 +1855,39 @@ static void dedup_flush(struct xarray *dedup)
 	}
 }
 
+/*
+ * Scan the struct pages of a zone, skipping memory holes, pages that belong to
+ * another zone and pages that are not in use. Returns 1 if the scan should be
+ * stopped.
+ */
+static int scan_zone_pages(struct zone *zone)
+{
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone_end_pfn(zone);
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (!(pfn & 63))
+			cond_resched_tasks_rcu_qs();
+
+		if (!page)
+			continue;
+
+		/* only scan pages belonging to this zone */
+		if (page_zone(page) != zone)
+			continue;
+		/* only scan if page is in use */
+		if (page_count(page) == 0)
+			continue;
+		if (scan_block(page, page + 1, NULL))
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
@@ -1928,29 +1961,7 @@ static int __kmemleak_scan(bool full)
 	 */
 	get_online_mems();
 	for_each_populated_zone(zone) {
-		unsigned long start_pfn = zone->zone_start_pfn;
-		unsigned long end_pfn = zone_end_pfn(zone);
-		unsigned long pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-			struct page *page = pfn_to_online_page(pfn);
-
-			if (!(pfn & 63))
-				cond_resched_tasks_rcu_qs();
-
-			if (!page)
-				continue;
-
-			/* only scan pages belonging to this zone */
-			if (page_zone(page) != zone)
-				continue;
-			/* only scan if page is in use */
-			if (page_count(page) == 0)
-				continue;
-			stop = scan_block(page, page + 1, NULL);
-			if (stop)
-				break;
-		}
+		stop = scan_zone_pages(zone);
 		if (stop)
 			break;
 	}

-- 
2.53.0-Meta


