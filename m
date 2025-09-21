Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC781CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E858E0008; Sun, 21 Sep 2025 11:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526248E0001; Sun, 21 Sep 2025 11:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BD28E0008; Sun, 21 Sep 2025 11:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 317778E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:13:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBB2D1A0344
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:13:46 +0000 (UTC)
X-FDA: 83913602052.11.49896D5
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3503380005
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:13:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467624; a=rsa-sha256;
	cv=none;
	b=1CcZWyTZ/UUMJ/6JIMbOKlAFWHDMcycJeGfi4UxuPYeiQwAqHK0y237xp/SJzdDQ4hTqbN
	EPTlprFmt6HDcF6tVmQtKyDIW6zc1GN+/4EsiJcrc48oIlL/E+zYD7z3JGaZqt1uJFCDaR
	BVZnZaER7uTHmcfbyXfflV3msS0Kqto=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyemfZhBtNe82+4N5e7PwQH8dGmUtU/+DQLF+N/oKhM=;
	b=xlWbTjDRycwxxORY3BEjuo2ILtvix5dW+yxVI92tp27yY/3jNN8Yniwmrw2GqrWg9gOGv8
	/Ph/s3dxAUj3M006/2O8pF0pfI61jFnp9qUbPNdLLVKne4S3MapoxZDTv7aRkBVwVhPgfT
	OygKf6hkjjt7NcUxx7p1bTRbpu8zlGk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4cV8rt4Lqfz4xPS7;
	Sun, 21 Sep 2025 23:13:34 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 58LFDV0Z071842;
	Sun, 21 Sep 2025 23:13:31 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:13:34 +0800 (CST)
Date: Sun, 21 Sep 2025 23:13:34 +0800 (CST)
X-Zmail-TransId: 2af968d0161e972-2a4e3
X-Mailer: Zmail v1.0
Message-ID: <20250921231334093OILrn169i655S8Pe0KMUC@zte.com.cn>
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
References: 20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>
Cc: <shakeel.butt@linux.dev>, <hannes@cmpxchg.org>, <mhocko@kernel.org>,
        <roman.gushchin@linux.dev>, <david@redhat.com>,
        <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgNC82XSBrc206IG1ha2Uga3NtX3Byb2Nlc3NfcHJvZml0IGF2YWlsYWJsZSBvbsKgQ09ORklHX1BST0NGUz1u?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58LFDV0Z071842
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 21 Sep 2025 23:13:34 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D0161E.001/4cV8rt4Lqfz4xPS7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3503380005
X-Stat-Signature: rdhoeo19tzzpd3jp8x76k8bktekho17s
X-Rspam-User: 
X-HE-Tag: 1758467623-184199
X-HE-Meta: U2FsdGVkX1/aakRAQy0i6xS81bKFBIVFrmF1DPXkX4YzuaZi25rcflqfcQGArMWT5kVhFHr343iJD80pWETONdDD2QQ6mF/8mGwejlo/bYFzQQe3vmYoQK46EPEJSFMEVhc5gdjYOrHsAM3nZwmYdKiDSe9jNOTuzn0Iy9p+g3c7zRpKEy2rKAxw8wm3QZ36FF3cGTifHEUesL0uL2d/h1fseopY1nWtWHM1TojRTaKTbxP9bcbdX4PBlwuOkWhvcCDYmFYGk2eAbSladaPkvSsZdsX36BL2ii2nJyeUn78S8nBmZ4wk/ej1ntWONxiqAPFAN98M8fS28SNGHx2WTD4v+KhgxXp6IQKxZQ5wI4h+aM+RdLYvOTaXyFCSJtl4lt8vL409yjrdMNingYLbo9ID7fN4UpIHhtl0GBw6wATfHmL8lNeMPPPq06v1yo/2R4m6GO1/JaObuvkbkM5VD/2CUtXrrs4wPoOu6DKQlph/uH5Y0GlnWCiiOTg6xQ9cOm+J92UAy1YwKOgqQcGwThCtgJFrYVwFrWU4qWUSbVDcH97ZoKyWjPUcdjATaslGUbx5hThZF/xhMVInE9s0fmzOZ2ADaZVO67j9no7VM18d8nlmy+DzM7B/BZu9FlB34jIyOik+2HPJ7evCFKM92iBaxdE/xE1eXWyzO5Z/zAvkHKKZlHll3svV9vWdvEZBeXhD0kkXxo3HZSfYvCw+pD3Wco9yqalz81OkiSOQRjSLzujB//SxRv1eBJdbYL9yKCzUJ2aNe9CxfBSOzY+OL/q2DYy/A8OZtOX3G4B+B9Xh2Y8nb8hROPHwvySYwLGUu98tXVpENHcz3aNjGGDSfStJf54xNAWSm+mOsdS6Zfd87x+q4ZUmBXEd7hzJAOKu1QIEayX46s3NLkjn9BXPoO4ZjyBnLbfH+LAVHBBh2x+YAqPkrYvu3jEkxwizzoXLU0PUX0PbYW4GyZxHFaK
 X3F54vXy
 qqGZFd/fe7QtOvR6F6ad3lhprFjbTUWa1E0ow5m9JEa7FD7jyHCm76jIZcTPC5sSH+uef5wQwCcslFpnWxC28ZIAid/S4o6SqBqJKYMK8VA27EBm/DcUI70fHkX56BwEzC6MGwgmM2b+Rzi4TaUyAMXmyK8oiOUKrfg3ZeKcIjYUtTibUsFCh7lgFLeu24UKznuccMsI6I+UU1jWdz+YRhqIAMijqYAMpNxoKQlmfOdKQYQUrr9gU/M7Cx58S+JHaoE1WzVpEL6ziJkPLI7Nemu69HDh65Lm6FJRZLvogtpalhX6a0nyUO/6cxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This remove the restriction CONFIG_PROCFS=y for the heler function
ksm_process_profit(), then we can use it for the later patches on
CONFIG_PROCFS=n.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index e49f4b86ffb0..a68d4b37b503 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3282,7 +3282,6 @@ static void wait_while_offlining(void)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */

-#ifdef CONFIG_PROC_FS
 /*
  * The process is mergeable only if any VMA is currently
  * applicable to KSM.
@@ -3307,7 +3306,6 @@ long ksm_process_profit(struct mm_struct *mm)
 	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
 		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
 }
-#endif /* CONFIG_PROC_FS */

 #ifdef CONFIG_MEMCG
 struct memcg_ksm_stat {
-- 
2.25.1

