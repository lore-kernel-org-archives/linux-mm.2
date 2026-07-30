Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596B8C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6DD6B008A; Thu, 30 Jul 2026 16:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDE06B008C; Thu, 30 Jul 2026 16:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFDE6B0092; Thu, 30 Jul 2026 16:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0D276B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:48:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76F791A0281
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:48:17 +0000 (UTC)
X-FDA: 85046630634.06.E956388
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 49C202000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:48:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4606yV6;
	spf=pass (imf03.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785444494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M5BxE/t23ijz33IZ7iaZiV0IxU7JLoT1VOJQBQHoWO0=;
	b=hZuMNfK66mQZ4K5hvdipNDOSnUPDCeM/1ZLTAl00T0Pv4Zpw69/dMD87VWLlm++iNepRGs
	zBhdU1WtboJSSpvfyEIoXYBO31Aq0EL9mzpBc0+CtHz8pkFOCjlbwBkZZ1ToWBV9WH5Thb
	gEFL0VXXbgkTXetqSHEPLhYs/Ubjrug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785444494;
	b=iTmy9/80KORIqq11IMrqgdH0LIdv6Gp1uNWCXMlYs0ATGus8RP+F/Pw3hcBAGokahM9t2c
	8kUIUz+8FZPCPs91zQeWt3VgYEunDUdkp1p2m231PSgsJ11eNarM89/dI5KBROjtSQQz6D
	hJvyAJiU7r95JS7jYZNaDgflzt/aNB4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4606yV6;
	spf=pass (imf03.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so1724845e9.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785444493; x=1786049293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M5BxE/t23ijz33IZ7iaZiV0IxU7JLoT1VOJQBQHoWO0=;
        b=N4606yV6EAcAGcnC8/ej4HOeulr/L8u5iawJCwgp1iiLclnPO4PbKY+QGcSizH8wBH
         HF66/gSuGwpbJ+rbcpmrNIxxAJWNmwQSIQOzZiabRa9bYS+68UQcIrZvHq2d0spzuBST
         5lKOPrrWz1r+El9A5LUjYr1OdySlzcwRZwu2SeA6hkhbE2VDY7h7pvGOJ7ItL4UcGlff
         m/U6Ga92HXW9Nas1l5Mj+ZTMB0tIz/jpIKlV2G/l2RbuvqHwktgTr+aWWXWvrTeeUGbj
         0vQhkrrfAbRGokfgi2OCh+32IsB+bgX3SVZbt+MSUZIPYAhv7MudZwH+CZJvljK2bhRN
         UIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444493; x=1786049293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M5BxE/t23ijz33IZ7iaZiV0IxU7JLoT1VOJQBQHoWO0=;
        b=asRRGD/dJ3QSGkoHn+q6bJjC0uLc0BjsAX6gWdBneCayILmnea2OrCXeFaHpRpE2n+
         G0evGrnGTQr6ZvBvvto2+/LNvpZL/TUJPztMF0R4CxFxfnBUnthGMVYdxA4tt3qoT/R8
         IQPEhf+gDKnLVMLEhs6S76hkp+m7zCkGLdQWFSnggQIylDeIZ5YhkQqLxPZd5iNgn+ZT
         z+v4u8dXXbEiocolvZ3kU+ddlgUx7oC9my7CGZ4KxHt1xJl6NEq8GnFxj/jH9UYikOay
         v2zHhMJawfxpbDsU6fwQ3FHL0Y91NtweNg4VYbx+UlC90TytQ8qBNn/2cHTJ9s7J1gw/
         U20A==
X-Gm-Message-State: AOJu0YyitbAln3UDB1pt8VFPGChXI77VkFMqSrU9aPZo9csr0wTlmHLT
	pM2W+idMd0RMfVoH2iiNrKPZLkowTcYM9/E96bCyf8eoeBojV5Uy+ekGKqpiOl0=
X-Gm-Gg: AR+sD11zhHxvEKPozdiJ5JKOlGsLk3rQxcxpKQgMJ6plR+JiIpRy+Q0dVHgkCSHqEH9
	RPI/F1xFK2kgoxwSazMUebMiyHoYe4HQA1Y988TsGIzotVsXH+rJejNYInB8hwphDDia7mcoy4P
	XapxIzjeXj2W1wcLfz2PnK6IXfVRRtvMd7CThbI8TFWFaIGoNIB/4aO3vtjLfh+eeMjtdj/hRix
	JKqMTv7UkQmnvtGqk2mpM3PwV5yIooNxegHZLHc6dwFHTMdJ4PWcBopXr3G74fEe4nZHPHIrxmJ
	oMVkNFUStydzU/ebeMk1Ly9hpIqMqo2DMTrAPjb/dY0x0vBJQkl+THItjNy5dHsE7OQBx3UgGgV
	eCYP3FqHcDHc38viydyOltt8bK3plf5aNWDBQ/WehVltBZyDXkFDTitCz5Kv8HzOBowaZPYr6oT
	RkFZEHTPSVqfQKV4qJ6lY9ONHCe7/RD0r+NMdTdcBS1v83jFi5RfVxziCWTR/MQKgPmCkPFDJAZ
	7WpKxjSMPAWk/a5Qr8RTejNw2iEsRtA7OCO5Yp2kxdG7PQMXciJ2sq08Bmg8kupwSVcVk77/rtp
	JE+RCjtznKB8Vz4=
X-Received: by 2002:a05:600c:19cc:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-49800e93cbfmr57370965e9.10.1785444492686;
        Thu, 30 Jul 2026 13:48:12 -0700 (PDT)
Received: from archtop.localdomain (92-242-248-69.broadband.mtnet.hr. [92.242.248.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-498010aaceasm85398185e9.12.2026.07.30.13.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:48:12 -0700 (PDT)
From: Jakov Novak <jakovnovak30@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"\\  Liam R . Howlett \\ " <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakov Novak <jakovnovak30@gmail.com>
Subject: [PATCH v3] mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
Date: Thu, 30 Jul 2026 22:47:24 +0200
Message-ID: <20260730204724.16912-1-jakovnovak30@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49C202000B
X-Stat-Signature: qixdycrhbnsk139oajt7fm6ps76qqdn7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785444494-315439
X-HE-Meta: U2FsdGVkX18VW++BUMi+iUbKyBdp5ksiC51lpDlBoVlsHSrJrUrXgPIBnOvgGXxEU4UpbDhIEYFuPP/BRXRLzQsQ5ss0TIwJqCKfnVTUpkBQnk0IwcbpOKhauWuau4088kuFMk7mhrTPm4LVKakJZptNFMxYUWgCqb3GEhhdIqZEAPSjnh0K1aUC52N/aEePhdEAEVB6nR234ZIEoJClGISzGpNAJHK/Tr5fIdSW7+ld1pQaJHNTZ6CDIr4hyqwOckwfWfTrGKtMfnN3/ubXoCE/i+i0Jd3ooQigGMnDBaGWG8sCkq2kHNpV++FFh/A9H9Cay1EWv5urDFv8QBpQe2p4Otdz8V/WM8lvCJjWvDy2tykKzH1eCUz5ThvYUJlqmZfjY41xl+x0GvcvKJZ3hQc4+hutNidtZc9MBw8qKvaP6qRXxg86FAzGu0FNKoJoYCnpDisSpgFvmU8n/bDdeRp2nAcVseDQKuge1T4jgD2LMZu04lsci51mO4mLuHlovAH+fK0adsqEzvckIgYEACKWSN8UuJvShLcvkLP6WeSJPjlZhJ3oqdsRgkhbgu0mCi/U6QaagO+w8dZnwI71qOQW+Kq2mGk3DRWV0HkFELmBUJryvU2DO9ahRp6l+jIKgSfEHRAFEToBzOeDB5xOeTch3kMV5jWc86Q/khrJdFD0aSSeTZm0AMEacfpOEslBKxaaM8VytCadaYvKM1md26kvrpg/aHOMGaGeTsD4Zy+RzxlotAJ3SkmIe5tCLttB//Ht3atWg+lRpPxzzw2n52qmVIxTvhbobYh5A8PrK/5oIzusDdJwymu8p/DYK1gJQpY2fnaSxHB0uYCP2Ztxk1xzCBY/3qOHUxhC/gNhCzGb3dkBX0XMwYmdxszeHpmWbXi6eO15/NjXNK/TdETI9bbwTrwwmqmxsEQxtPwPdwCrC7Ch6JuTqYwvf+X7NV3mxwvZcLBgFErqX+62vUr
 5hREoZpJ
 3zDUmQTvzpa0GsdTxfpIj6q8APF7nvr5Yjk277/TEzOU9ak6e1Oh/N/Ygu0fXfMF2HAy2/FkEV2NZRUhLkji9ZK5npHL8MMyidYtZbo2T6AvcBwYCLF/PrHAF6kONIPbeTjdBgOq6ScrAIG4xn/HQp3Z/0VC/vUJekCgprpsWrPgJFcOMgeq++kMiUvGzIGTULxlAFeW06jgndqydWxZikwgNVmx1qqqIiOM1hbcMT9/cOfOssNkF9uw8rflKsuDG6HkbPRdOoxCWYSXJbh+0rpjC5VCOkHG4tkTK8Z7+/nCaQfZY7GF75R1iD4hi/H4gHQhJdyqHXv5UVJTtavAWI7A0sRlq+ReCw4s1o9QksJRcubGZukP1DYepsJChMZkI09VuWOtlLpGCRmYaPQMmEbVcyj1w2eiGW3Jfv29RmidOKgLrlMKxgZsgfAuY0wq6FDuNVPP4vdITRngR3jySR/wyQBTTsODP5n/Ty/USDGgs+85z8ARBxibah/52V0k+xLmELPXQFVpfod7sVO16d1iWPxsSOl3tcSnO4kAvnyFr5p3ZsTDNwmwO0oSccXVetbtHOAqvRGbLwmxt1khio7E06RbJ2meBzEetgKObb/yxlFWJ8gIonZ4PgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, khugepaged locks the khugepaged_mutex in two functions:
start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
mutex_lock/mutex_unlock usage in these functions and replace it with the
guard macro. This makes the code more readable (removing a goto statement)
and makes it harder to introduce bugs in the future.
No functional changes introduced.

Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
v2:
  - Added #include <linux/cleanup.h> to the includes at the top of the file
  - Moved err declaration to the scope where it's used in
    start_stop_khugepaged
  - Made default case return 0 instead of err in start_stop_khugepaged
v3:
  - Moved new thread creation logic inside if (!khugepaged_thread) block
    in start_stop_khugepaged
  - Removed suboptimal err variable

 mm/khugepaged.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..97f61a050f7c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3111,18 +3112,19 @@ void set_recommended_min_free_kbytes(void)
 
 int start_stop_khugepaged(void)
 {
-	int err = 0;
-
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
-		if (!khugepaged_thread)
-			khugepaged_thread = kthread_run(khugepaged, NULL,
-							"khugepaged");
-		if (IS_ERR(khugepaged_thread)) {
-			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
-			err = PTR_ERR(khugepaged_thread);
-			khugepaged_thread = NULL;
-			goto fail;
+		if (!khugepaged_thread) {
+			struct task_struct *new_thread = kthread_run(khugepaged,
+								     NULL,
+								     "khugepaged");
+
+			if (IS_ERR(new_thread)) {
+				pr_err("khugepaged: kthread_run(khugepaged) failed\n");
+				return PTR_ERR(new_thread);
+			}
+
+			khugepaged_thread = new_thread;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -3132,17 +3134,14 @@ int start_stop_khugepaged(void)
 		khugepaged_thread = NULL;
 	}
 	set_recommended_min_free_kbytes();
-fail:
-	mutex_unlock(&khugepaged_mutex);
-	return err;
+	return 0;
 }
 
 void khugepaged_min_free_kbytes_update(void)
 {
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
-	mutex_unlock(&khugepaged_mutex);
 }
 
 bool current_is_khugepaged(void)
-- 
2.55.0


