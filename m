Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F47CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E268E001B; Wed,  1 Oct 2025 05:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D218E0006; Wed,  1 Oct 2025 05:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E84A8E0019; Wed,  1 Oct 2025 05:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC998E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:19:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02B9C13BF6E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:10 +0000 (UTC)
X-FDA: 83948996502.02.DA7AEB6
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3282814000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WdvLzQxO;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759310349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=1eyf5GUCoWvr7xHG54lEojNaJSuQSNkCDuiTnMyvMf4=;
	b=QgPlpivGPm5WG2aMaVHrwktfuBHpYQtOkt3w3l5uu690ZcdiM3gupQatzvycjO0zVCS8EN
	xyDNCmmqYgMlyiy5RGN4o5yYWTt+hZ/nvDPOZi728DfmwR5uljZVe5eO5hqkpIdaVQN9KK
	reFh4b4KPbXt9lPwxakDtp2ktCZuM40=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WdvLzQxO;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759310349; a=rsa-sha256;
	cv=none;
	b=IR0kvJKtIAiegr4SgbupPaVxPIMzdsiloDa4pNn3rMH2o7xP3jnKaGraMk9QU67KuWrIh/
	2oTbpycRlFPqsAjzYB8mO7NFU9VvlT/Ss6LoxAwR7XLMoq72DHqllbSZmfVoGfYAshBFVZ
	iZmM95ymp4a7l1Iv9+mbaqW4emeyUG0=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b256c8ca246so884247966b.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759310348; x=1759915148; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1eyf5GUCoWvr7xHG54lEojNaJSuQSNkCDuiTnMyvMf4=;
        b=WdvLzQxOHEiMGEcK1Agbt2pNXFwMVsLgf/g17vbiuMzbHlvlvC4kuo9PgEvTGQ2OoS
         7tPD9sogqW2KmmvprptoPmY6YIkOdixB9wWsfFBmlFJXT5AeQmBfcP/IfmP0zyZLNyrK
         WuFIyM1TOYhrmpWeuP3tvHzKcYKJX20jbj1v0XUWO12dVDzTQlkYXiQBrTTtGdeXixPq
         zBD1dZ7ri3UjU4au4Z6rbTXC07aSbwEEiEXZjXQkHtC+ExtZKKs0kepmtNmpW9tHwChF
         H6vUkuDf7uDKuoy2+0aFSI7KsfyUoB2KzF8DDamZK24Y/v3dBmmrFI5OaiNlr7uek7ex
         iCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310348; x=1759915148;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1eyf5GUCoWvr7xHG54lEojNaJSuQSNkCDuiTnMyvMf4=;
        b=Uli2H8ttMpUgSVKgXMam6z+SD+jwq9kd+wDBolIMp2nDLHQ45OW5yafLZjuA8ej5qh
         tPoEPdcTs7G1kfOJRAt4BXI1QAgbszJzH92Ar4cwopaTqQoX6fQcf6Oc1+0qGIb9xdvw
         qC5luDTZ2jWaUVL+hh4zFuduxlkus0MBm5J2YtvT5HZBaFWjoud5IuWDBXDKMxOTXrcQ
         /Jd/SoV08f/Y3gHZ1OQkk9PpT0dpOKHPKpIW2CLPfgQ/9AhKW7JYxcfCC6woeOANQRcI
         33WtZxsDOUQdOQ0mNe0Hj6l/j5WRiGgY9T9nBg4T9FTnGv/B6qpo/OJd1cEiGbEVqqkY
         8mYQ==
X-Gm-Message-State: AOJu0Yz3u5wN1wpnxCBk9FXD7d8LtfdDSpEGUg8aL5X0eOpSQejjIRln
	5W1wR8rWFwav4odsMsXNxQpH3/ihgPKkA8gcCO5iEVeEdJGazrowze34
X-Gm-Gg: ASbGncukc30WnbeNdf5fkWJhtQHQZIDRybhUillWkknGJm0eGHUwIEaE51d9XLehpkn
	I1JylJAe8dmoDPzqv2mmg0vaRoqUg+OYHXEXr349pRFtRxjdSvW8ou9cx1LIt5ynm+nKCLf63G+
	x7WimCwne7BR34iITHIL6iGQcuAmwEaCHvSqSBtUxG+2sSeeQ2fyWhVEQPHqGsPP/Eodr38hWDa
	n3AQxghDx8Sd73tOFqIOS4v1+Lh7Rstdjoo9PFJmYwQdLiC0arIbUX4WrsoHFIYRMDahWSOEjcS
	3ly2HA+5F6fnig+OQe98/9gcDut2VnvIQhjfiaWOgtYIWi1+7+uaWmSUZ5KeJ5rNv6uSXmHwnlm
	3gfOBUeG8/UZE5oNqLR8IYgnDCjQuj9k0MNhsq8PrUp0LfowHsg==
X-Google-Smtp-Source: AGHT+IHAuqXvYe3BanR70jF2QN/Qvtd7t+id0iui7f5n0AJCOsVLP8U8s+9r17iSlHZEOP2g/gTfrQ==
X-Received: by 2002:a17:906:c149:b0:b3d:b251:cded with SMTP id a640c23a62f3a-b46e4d79a6fmr355467766b.16.1759310347643;
        Wed, 01 Oct 2025 02:19:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3e60de51c5sm644138666b.15.2025.10.01.02.19.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 02:19:07 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [Patch v2 1/2] mm/ksm: cleanup mm_slot_entry() invocation
Date: Wed,  1 Oct 2025 09:18:59 +0000
Message-Id: <20251001091900.20041-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251001091900.20041-1-richard.weiyang@gmail.com>
References: <20251001091900.20041-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 3282814000B
X-Stat-Signature: phri7wnbg7w6ffuenx6ifm4suht8gtza
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759310348-112158
X-HE-Meta: U2FsdGVkX1/qddpNPPHLCUZIYQhsr0ZqkAvBjNUohUhT1FTQNUhvje7PXcID1fFsLMnScT7U4Ef6JO/mi8DIGNi5HJJSf4iFP9ghj7qE2QD8zMx7wKIHSHCVvjgjDDi6G7vqgyKrz0g6ZgCEvrSgLJZ65nQ5msDMb4q/2sw02tAKRiec/q6hoD+pqRMITvqVlf+qRYEAbJFUyumoW7dXkO6rQgSJeBxI/rB9yHgldGFF+tCgNXWyByp/xxUa27FqhiiKtqWYBRQPTlUItgu82w2RNpISktnu3o8K1tYWjj9q8DP9Xpyx5GbcaGImNeDpg/jSQeHokR/jFZB/CY1eFEvVkb7q5+108+3iSuK4vMLRvIBjUACMmFvDaFn3L/Ao4TXQC/rpiQFnC1ZPhYO27E8fyLcm8kWhEcH1tuS55lnJlQufsAQM6OBaoYCcyzmyRhGVYRdN5vVja93ogbTZf6pEpukcsr7Hs/pnfB97WQEoOT/ekHorEJfcL4sJ2HSWGXsxC3NnO2bWpEAeprUxcMmj2p8T7STdOeicPEi1I8oq3KbnpYH0nH6Zh2+A/Y2in6wMVcTjZhtNGbHihWBD6I7t9l/fBIg4bxMkX7kGxugMOC0ZYGSkoxJXHBWDAlZmDEfTAb7jrcTsZCaalTCtf79E9qdkob9fZX21ib7uqIl2bNFTs9FzjDAczp3KVwT3U1pDsNPRpgAnQGnWd6NSWS2mYEh6ufZlpNocrzVmZw23ASWMPeF9c0e2nZktf9FWg1t74uMAezr2ooLjXvxhvc0+PsuwegIh6FfG0bNekhpUnmYUeYw5x+0GuqLnnKgvLu1M9nA2X5LkZAWldH3XI4kyMbtS0jded/PXtcbIrAxBbzM6tqTeGtfbkicDAEGw720hfrrgS6jkygv2wo61k5nUYgySJ8x/KGwnPT8MW5l38fzv2vCpcq5e1IvpI1U+I37gTpvwAIvb3smVRIV
 ylMdMfQt
 J2mYzZC94ccftZ7XjwxUt9AaX2NkAujAsxmI1vK+n5ABSHphegmXR4BLw6KWTFYQ2f38FitkMcyj/5t4XOI6nzfZ6pNuqCeEcMzEBjvUiMflA6EQNMsv3hjQ08A0RAbQ9s/CIQbcSa2b/wvzr7EFLyMpUzJMTSTMNJ76BUOVY+SljYWl7FvEKiGrF3ria7BGy8Zt34q+srabbLq48tT2UomPoXPRsR+MUkssvNJ9rlcQJNA0tooso7rfIRdJWBofS4tNJ1De9HbLZD9iZgKhidZ9qGnEBVDoZJc0ecHmcZWrTHBnf9uaCJAwKG4mGdMdl5DzsY5iwUGjBRtYv6OtNQj/FGVuGPoHMB89X6BKmSZozlcZ3+lwc4Bst7nB/yU2/9EeZBeJwkebRYOM9la+HEY+kOd5Lp7g7GAZhSjLppuL3M/9ZS5bHz9NFNDviJcfm/n09bX7Anx7M5ywN6/avvrtobhgD99fiIrXhMP+/Ky9LOqf5pNpTrWZABucbE+ie6Et3ptYfPekS2JlsTBpeRKeieNP1Sku8meai35LzMZeP0NisrmnHqDuu9b+WicurGiN09R7gypOpB6QuHxRc/fiVyXoUk825rVbqc+ce2vvbsI6yIPRsNA9IZqBvn2IlSCUWjVkOs/wG1tnsdsLT6CuSK0qqoj9JFO3wE7hB2+dVkR+Jsp8iNgXJQw09vgc0E3cFQGa6c9BSIMK4M+zxoAG8/cgm9NFIqpEDFYaXBllEgJ4rGDAzwDc+dhBOHfjrVyKKh+TV2bcdtjP4wSDnYIngTtnINLNOZOJM7u1IMe0LvkRrGl58y09dBoXiFxMamecHkIB+rxOrs+KFCR89wA6VuhAvXuwALvTe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We got some late review commits during review of commit 08498be43ee6
("mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL"). Let's
reduce the indentation level and make the code easier to follow by
using gotos to a new label.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/ksm.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 04019a15b25d..7bc726b50b2f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,19 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	if (slot) {
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		if (ksm_scan.mm_slot != mm_slot) {
-			if (!mm_slot->rmap_list) {
-				hash_del(&slot->hash);
-				list_del(&slot->mm_node);
-				easy_to_free = 1;
-			} else {
-				list_move(&slot->mm_node,
-					  &ksm_scan.mm_slot->slot.mm_node);
-			}
-		}
+	if (!slot)
+		goto unlock;
+	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	if (ksm_scan.mm_slot == mm_slot)
+		goto unlock;
+	if (!mm_slot->rmap_list) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		easy_to_free = 1;
+	} else {
+		list_move(&slot->mm_node,
+			  &ksm_scan.mm_slot->slot.mm_node);
 	}
+unlock:
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
-- 
2.34.1


