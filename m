Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61287CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEAC6B0007; Fri, 12 Sep 2025 08:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6B36B000C; Fri, 12 Sep 2025 08:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13846B000D; Fri, 12 Sep 2025 08:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A23F76B0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:31:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F6A7BA7C6
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:25 +0000 (UTC)
X-FDA: 83880533730.01.9C8B7CC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3AD5180008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JZx55i85;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeorsTMJBwQyBoBatjPu7vtGfUn1ybQMr4j+YF0CXLU=;
	b=PwoIdDEs2zCQpIxsSy+WngIKf/+9HTCIctmXDPrEW7pNIK5IgPcPiiMEpYetp4uiHnBVev
	cRcSl4aD8sTp6S2jFpJ7cJZgpobBBgYsd3pLGTwW1FmzMzYvAy+v8K/vX9KZDPz+FLZd4I
	sC8Jt+kuLMdhpdw7bjzd63oIS+PEH8s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JZx55i85;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680283; a=rsa-sha256;
	cv=none;
	b=cjnGf58wUjXwBPDI8/dgPeM+UMvXp56f7uuONkj45ThOGgj36jSqILP48KkM0oscGeV2DI
	BsU101jAS2fsGcr9Z0bgPwCvKLBFoOAqHmggkGf12L/R8u80AipFWL5JvRiAhOxVvUjO3B
	whXf4FAzhwxA2NRBThugw/pheEtd5jg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1757680281;
	bh=+8A4GsCErF68UbEHFv25lzsdwJliaWDufQGZLDYg8ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZx55i85auuE2Dc9gI2kjOxJzaNdpk438dMjZ3qbQL2GxwcMfhkBMIOs40YaadmMV
	 wgdsJrBpoCoUAjRjzNVKUI8eWzTXWHiW+2s4KN3g/fFEV7eI9q9zQXI1mG4OWu0x5V
	 NiIJQ2RICSDnLJEwNqrobsYO/9Z2OuP+82YlfVyRMCQ+4bxTZ4+Rxd49j44ClTM4+g
	 gSkNLKQ+aATw+Jj+2gF5Eym+jKSgw8LUtJxEPJwHQOUGHB4Cs4fDV4AgxKGrieGUja
	 6Md8nHWY87gIN4boh2hKV8fEHJRWIR6pZEDErfvcZ5RtcqJwpUrYZilceHx4IC1Agm
	 gUcUTl0+Ps70g==
Received: from mt.tail9873f4.ts.net (unknown [144.48.130.189])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 26ED517E0927;
	Fri, 12 Sep 2025 14:31:14 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH 2/2] selftests/mm: protection_keys: Fix dead code
Date: Fri, 12 Sep 2025 17:30:22 +0500
Message-ID: <20250912123025.1271051-3-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250912123025.1271051-1-usama.anjum@collabora.com>
References: <20250912123025.1271051-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3AD5180008
X-Rspamd-Server: rspam05
X-Stat-Signature: 15qh6bdr4974ubsq1aipse5rho1a9a5x
X-Rspam-User: 
X-HE-Tag: 1757680283-746433
X-HE-Meta: U2FsdGVkX18ztEODGeQXiizBcBM+YcXWKhYu65NwC2uLBb8m99tz++znCP9qzF/MG7eCfhifTfLhyPiRzrWYSMscL46pnGOjfqL4HtPbd1fMnh3Rr/QH4p9+MmjnMumgqesRmYcoDuetKETSQttHvtR5sJUYNfe5rZZn6CXh4pXMMjUGnh+Z+QnWaMjgG+ByiK36lOPDKDrT+DAQDR6ry84x+m2xN4QC64Uu5QL95GgD+QAOkj3D/wQTseqbHznSgSWptGRZzojzTipc4ssjWUTHEBEdulS6qlEV4E99abwnS9pSuJ8E0K/hHCjJ6nikV2uwWnDb5qtEpn8L0925k5RpFNwf11uO8SbK3V+UxeW91zb0p9mOj0p20NP4W8ROkk4oUwn6fFhllIqIZIrn05EGPPlUsAEgTKDNwB9CSNUxgxli3f+JGqdBNEn+uHj2mXLwEH6g/q9uZBKNRl+LKRGgpvHu10GZ8nd/19kZ3b/IyRvNpqIr9fwfqS7DlTPDUMRFcUvuDFP01lyfkcFK7FVoLPVW8VJiSTxNY+jlaiMReMnXtfWiOrm6RdMOrYBYpIh0c7552LctgFGRzNtXrUTxo0r5vt46HWWMfvkqEZ/7/10c/6WZxZ6Gq/9l/fnBB7SZbijSiPxMzuW7h+iEJ/XIKocNLWxsEdHKUsViPyJ9DUyYZkQuzUddr2DQjUMJLdXHmjjPaMjLcimdDllynwy+XUT/Aa+4e2ebazHvNJ53v2YLBMlF0wQHG9QwqxUlNiFul+M2GY5okhPq7PwTx6gv24lt2nDQVV9s3faqQYM4dwtqJB06jK5+kysqosRYOfhXs8xMKqERCJXMmBuU6Ve/wV3+qm5Cl/OdT5QXZWuDaFsQYV3Mml18EQAitc3FDB+HHoIhJt90FkVVtRSw7c1SddT9xv8nKvmtFpxESB7XJo0wyaFK8Im1Xj4/ZhQMW+bUHYoZN8tXLQo6kQ2
 8kTjGVgk
 zKbevwEGTcTnb3iWeaiq0vteiyrKp1MuqUMFTQOXoYLxVvL62Xw3HBp9d1z3I61BXHin5xujrl2sA8xRKQy9/vG+iyjtah5e/g+r3m0JKw5YNbdkj58skya+szU/6rgg85+WZJ/EpCs+0PqNb5Ly6b9yVejxK3fFbEoJnK51gsJOJsKNUWiNEgngV/fD+catvZG0Qf2y7LMOcFxRQ6yzW3Tv0gl/fMrgO7XCm6FsxsOcZswF11Y01Kyg1oP37Jby1AyVJl+gpBtztwTp8adTD+0urHx1Ul8hAQTQGUrRjFyUqwT8b8utv+rgarSVNu+24yFCZ/sFEZZ8K+/hnbWyJNJj1amfIATcWa92VbQhF4MxUSgkv/xfxa6Kw/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The while loop doesn't execute and following warning gets generated:

protection_keys.c:561:15: warning: code will never be executed
[-Wunreachable-code]
                int rpkey = alloc_random_pkey();

Let's enable the while loop such that it gets executed nr_iterations
times. Simplify the code a bit as well.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/protection_keys.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 23ebec367015f..6281d4c61b50e 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
 	int nr_iterations = random() % 100;
 	int ret;
 
-	while (0) {
+	while (nr_iterations-- >= 0) {
 		int rpkey = alloc_random_pkey();
 		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
 		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 				ptr, size, orig_prot, pkey, ret);
-		if (nr_iterations-- < 0)
-			break;
 
 		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
 			" shadow: 0x%016llx\n",
-- 
2.47.3


