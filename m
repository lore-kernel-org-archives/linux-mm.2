Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BFACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA638E0012; Wed, 24 Sep 2025 13:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182888E0001; Wed, 24 Sep 2025 13:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BED38E0012; Wed, 24 Sep 2025 13:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE8988E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:40:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8A53BC1B4
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:52 +0000 (UTC)
X-FDA: 83924859144.18.28B78CE
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F6364000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=poMllSFx;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf11.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735651; a=rsa-sha256;
	cv=none;
	b=CwahBP42xJLV7akO4g/mIWpjZaUACWLrPy/ZGhKSRz/eB+zcf23WVSRTN99X/KWIEsmbQZ
	JJxtyM9PBCg31hj0kSPhe3yxs5EyHtTq0X8wK6XN2YzXRhOCo5Kp0AORAIUhsJ1CIa6Yrt
	bHvCjjHeMWMTG3kBr9oQUekkkAGhFQU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=poMllSFx;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf11.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WORvJmTYWvO70O+J4Bbi/mV+ttGZbGHrOxbkkudcayo=;
	b=qNkyqu4pK6KOJb25fhRrSXEbN2apxenJMPW2hfo6MoyNuo9vK2TYDOj5Z0PWY9j5TsohGt
	rDK399Thbe4dWx41ixYigqUk6Kjwh0XlnE5ZU0SdJvsoo0oO/qAk1Cq3+KFVm/v3fRigqy
	ZB2A51RSbZDRwSvmYEGPz34wMunIpBA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WORvJmTYWvO70O+J4Bbi/mV+ttGZbGHrOxbkkudcayo=; b=poMllSFxyWwaxbRMnhIhvy/7gG
	Vv3kHUhfitXWX5+DCa587KuKpCGAEpvpIp0CidIGTkAPcc9ItXF0YLCIpn8/x4Bhv4m5aLfUdUFRv
	wcJT0kUPPM44BFEAVH18kJo3yMQMybzx0FpN7ETzRq5H/+p9V68me1CkULYvLi/zoUjsHfH9uVTUh
	Y/qu33VahXawv0QuQ6O4a5WSyOLCjckL/B0+MpF5u7oV1gFX8ZlgofNnDiGgzCZ1aj3HOp5+7XFhI
	KbZVf8SFjgdOSSkrN9mtcgSqCUD1DKlSotbEd6ohIRtHoWxq7gMy87EPIhxJ2SN+zqGlHsBTwCHUz
	Iyr2YFmg==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1TTx-00Gz9Z-Dh; Wed, 24 Sep 2025 19:40:46 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH 3/3] mm/page_owner: update Documentation with 'print_handle' and 'print_stack'
Date: Wed, 24 Sep 2025 14:40:23 -0300
Message-ID: <20250924174023.261125-4-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250924174023.261125-1-mfo@igalia.com>
References: <20250924174023.261125-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F6364000A
X-Stat-Signature: 1zwxyuk8mpyge3jqxsbfjuq3rpg9oud3
X-Rspam-User: 
X-HE-Tag: 1758735650-229084
X-HE-Meta: U2FsdGVkX1+YdQWJ2tVMUYiNLck0ieH4a0Jr+54hWHmkKBqoPE4LutoXYyKcHGhgxuIS/mtfl4NnJb2Kh8Ev9sHhM8gLlqkM2iD4i9B0sVCrwTRIzCrigePJObzlp7EeciNR9Ia6knBTrWKctTmF0d/XCULzf02G4Sez/tbyEd8Dit2xMkjRoAy7rTdQ1VKWJkq6DBTVEaHZh85ru1HAB6w13OOOXiCzj3n0LhwLF8A3F9HGP3x+fN/xiHcXOZ33l6tL2YgahKtZbAhbhoi/Xx8+gESJQ/DYzsTp1elK4rScUn7nDpowefMOqF2dY+Tjx9hHHYVqpTT7mJgmwmeecgkJybPB57t9x8ig5W8kW9lRsNgLXBmLvWJU3Ti8+HKrq2Xywqfb/RklBZArMItrLTGtSOIi4pAZznSi6ZnsuI5gXXWLUfgRMS4861xmj9RtqOBHaC5naQYA9kfRgJ1VjIy9psKers33o0NfuDARmT96InpZfzx3vzw5avvMJsRxqUOIJ3Z0DjXSYGwrzkRE1PvAz+Rnz70e5FKyO8MkdmqpLDkT6NRz23JOZ4TkVxK815ZbPDMU4V3QziGtlR689i669I4qf6IsPpiwzhRXX3PtwFdfQ1PCdgGBdmHjUA1/BOGFPny0V+YK1A0E8+u4YKn4r/TyQZXW74jE+it1nll02IB8imZjPFJFsbHi3yJzSlZtd3xPnZRb1WJCy23xMEtS8KToLYxcgrLGCzhw7zNtzL6z6LsY6kR2nfOw5RUCMCOVqXZ2y4Lb9FVp0uaiVfVtasbvH3T7PZ03xwHI90MvQRrO2AfDZlm5KLleJc7TsAlOjRebo21hWYOPLhzxxro7i7uL4jva5jciiyxDgGOSNWdvW51pLkOrgZMpTivUK9pHjXUFVLArbrG0phLsNr8wOKo1TaN8c2IWETPB7rMlyByuV9gInnsbWZU6lFv+ja1TQpbX2TEre1Rmop3
 9VuvS49d
 MRmhNoDv7v6wumQRM8l+l68DsZ5+2rhGtlIS2X9KDfmZz4VOelZocDSOgaGGok4OD5WQOsDXmnf6wrQTPeygSRRDMF0NZgdA0ehQnsUGXaa+QCWqVwVEJuXa8y1J2wuX8hgRlS7pDfsvPrGYmJfn5iCVbFBviJ/ASjNDdywKkUdbHBvBKiwRwy5Bb9JncMhiliwLugnfATuWpaeI2e7X1Uo1Cs8+d+GTmaPIzooggMGpdzz0gEQ72lh1xzaJf/skLbZOuz8EwPDdMG7DX1OKGlzB/mUhXpt64besflqi63StYNw/GhF/xROMFpw5Nt9yPo+vb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe and provide examples for 'print_handle' and 'print_stack'.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 Documentation/mm/page_owner.rst | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 3a45a20fc05a..fac14ff2e4a5 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -27,7 +27,10 @@ enabled. Other usages are more than welcome.
 It can also be used to show all the stacks and their current number of
 allocated base pages, which gives us a quick overview of where the memory
 is going without the need to screen through all the pages and match the
-allocation and free operation.
+allocation and free operation. It's also possible to show only a numeric
+identifier of all the stacks (without stack traces) and their number of
+allocated base pages (faster to read and parse, eg, for monitoring) that
+can be matched with stacks later (options print_handle and print_stack).
 
 page owner is disabled by default. So, if you'd like to use it, you need
 to add "page_owner=on" to your boot cmdline. If the kernel is built
@@ -95,6 +98,7 @@ Usage
 	...
 	...
 	echo 7000 > /sys/kernel/debug/page_owner_stacks/count_threshold
+	echo 1 > /sys/kernel/debug/page_owner_stacks/print_handle
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks> stacks_7000.txt
 	cat stacks_7000.txt
 	 post_alloc_hook+0x177/0x1a0
@@ -113,6 +117,15 @@ Usage
 	 __do_sys_finit_module+0x381/0x730
 	 do_syscall_64+0x8d/0x150
 	 entry_SYSCALL_64_after_hwframe+0x62/0x6a
+	handle: 42
+	nr_base_pages: 20824
+	...
+
+	echo 1 > /sys/kernel/debug/page_owner_stacks/print_handle
+	echo 0 > /sys/kernel/debug/page_owner_stacks/print_stack
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks > handles_7000.txt
+	cat handles_7000.txt
+	handle: 42
 	nr_base_pages: 20824
 	...
 
-- 
2.48.1


