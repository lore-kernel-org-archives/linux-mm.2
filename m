Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A957CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E358E0047; Tue, 19 Aug 2025 09:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7B08E0007; Tue, 19 Aug 2025 09:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8048E0047; Tue, 19 Aug 2025 09:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 690BF8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:45:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3108D5B659
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:38 +0000 (UTC)
X-FDA: 83793629556.28.8761EE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6EA7840002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuiOBsy8;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5DchuEmH6POX8OSi9R3/H3ulGAsujcIoqxqs5qQqIk=;
	b=CgIVTDXGi155/cT/bBbmv0TAde+rizoUhByqMkXAemfKgFRclBJq4MvSaUPbffltr4nYim
	xbCsQgCORiIukhU2WnbMi9IwISbM0dwldBNDQ8Bmk7+GYvObiyBueFsGQr9anoIhSn6oBa
	8lOEWmFwT43HC2KAJI/ESSeFSOXtEd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611136; a=rsa-sha256;
	cv=none;
	b=OxH/Qo6Je1JdDB/KmqEc+99UCyzZIZ1VHL6DwkmXs3n7UUzYSfaQ2qqH0TYCNe9xIpw0Mu
	/cIlxR2Ujn5WiVER1HZm1JBWGlaGfI1Q2PmgOeHQ0eXCydkYIRvGB5rT2GUKixyHU339Py
	/WBx4MSD6go2HbKK8RcOFv4359ZViVc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TuiOBsy8;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5DchuEmH6POX8OSi9R3/H3ulGAsujcIoqxqs5qQqIk=;
	b=TuiOBsy8XQ3A0xR5mVUF9mzcBwFh1Rke/9TetzJcI5JNiFWKoPxDjUOSsasj2PJvYyP5jj
	w1rmx7B2gDk147hJxcG6VCNEqRz3LJm8vMwRLxCTT69zMLpfyhr1HQmYmKVYBVJ0Mgkxmt
	MnwUsp81DBiWRT7djOQ6W+1AvLMllOw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-kyYq5qvsNpunGuM_q3lK-Q-1; Tue,
 19 Aug 2025 09:45:31 -0400
X-MC-Unique: kyYq5qvsNpunGuM_q3lK-Q-1
X-Mimecast-MFC-AGG-ID: kyYq5qvsNpunGuM_q3lK-Q_1755611126
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8979F180034D;
	Tue, 19 Aug 2025 13:45:26 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C00D19560BC;
	Tue, 19 Aug 2025 13:45:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 08/13] khugepaged: avoid unnecessary mTHP collapse attempts
Date: Tue, 19 Aug 2025 07:42:00 -0600
Message-ID: <20250819134205.622806-9-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6EA7840002
X-Stat-Signature: 8qffd5z11mgdgc6981x5x3p8na8d58b3
X-Rspam-User: 
X-HE-Tag: 1755611136-328884
X-HE-Meta: U2FsdGVkX188IY1w6fVfOCMAH4fBM3aLDnycZAtpGo8m1AUy4pqOmxPtgbwJESu1Asjhy3nYnw9wRVqoqVFuPn9n9qUJ8N50RyvLg+1i2hgZm7xYUmhPznPCBCYl7dBp9xc47LmvUchJ6NIylvNdrCNvNdM9+iOTnC1SKrw2AqSVPFoURx3sAg+1t6cCeuxap0VVJMaK2zLhhvv/eMKCEtRIFIXnAxHITDIpbS2y2t70K7Kz44S/EQcJILzfzkM7ZeODBx5L9LvEA9ohA5Uv9GgytvpiC6ZO1X2c0DIGJSBAC8wb6AtkNyXcKgEcb3NhCRdUMsPeOe3bLLvU/6GwvVqZbzPYQys7SuodOB1ZpGFqQQgc5EmLTC5EEyHaGhAPeKopwOLqtOqxItlUde5TS7qZLg2rZOLDAdFV7dgSrD/aZbQc5OjvAcefJwbxqMM6VwA5Vq49d4mlti0lu4mVKzwmg0HMe+W/f7pAub709cfwaIki+kYf5fFhkkSRU8F4OixvnLsHY0d+Ygekj5JD6vLmsXd63HxJieJQJ38WUj5bkfIH5OB1fS/in/WWoj6mjecznfqoHySKptGOAF19HCLUQ27dKIlBicmwW3h9QUZNWNVX4iK5jU33krZjznIM06GhSdfLiquEJe9Lk6miIgIjD8DptRbeEneM5PJNZkRps0NvzydkYcxu5BCVxFyycZ+H0XQ7gW51Gfs1UQwcPyjlaScG2Vx+oS9Z671LwuDaiF4fOLijv5z2Svil2zg6caByUjrcBb//JyLZ+Ea9jde3BKEZ0Fy4EyqMYLoREiNXLou2bQ6oQCKLrOwhs8r3jSZU+2xgxcYxn7t47OfyryZxdMI1LUzDqKm2vWRq1bvBmDM+kmaPdf6/rGKVUh7TBzmyrS+1W8bST7jVyyg7+ZMH4LR5qSft2XgWAHC9t8RZjs2xaeI+i93bslNsoTVgm4jjA7B35+ekicH9F+R
 u01bQYBo
 fIuHl8xYK70o4KzFIjzn3oMdzlouulCLoJLJMr2dMu8thFd0xzxb06GOk1S8Hbpl+qhkFJbxL5oAYlyLgLXHl2nEn3tsfNwFeNeKlA+fdMqoURtaWZRlPNDdSlw/V15MI5eRk97Tr3O13AS9CjrDIWOBlZVlB6hfT812grrFLmC4SbJ02qxsZ2Ka6LLnYt64ENGmy7J9+/LUJv4FFM+O+MUAexw0ywka04DMSvcWgQ2I5Uq4PdLJ9zCsmIvRqGZtLjxJFX5gBa9bxx8N+PC9VH+ZxU0YQj2Hqv4e2/vkIYFITpRzosC61hH8TuONgTyA48EbNnawYOloxqrgNTLfSrGWRiAn6s+AxPGeALCA5rSs0IZZ/q9Dw9hK/hi88pQD3gIOFj5i5reM06+tJQ7sokHLKDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6a4cf7e4a7cc..7d9b5100bea1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1389,10 +1389,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
 			ret = collapse_huge_page(mm, address, referenced, unmapped,
 						 cc, mmap_locked, order,
 						 offset * KHUGEPAGED_MIN_MTHP_NR);
-			if (ret == SCAN_SUCCEED) {
+
+			/*
+			 * Analyze failure reason to determine next action:
+			 * - goto next_order: try smaller orders in same region
+			 * - continue: try other regions at same order
+			 * - break: stop all attempts (system-wide failure)
+			 */
+			switch (ret) {
+			/* Cases were we should continue to the next region */
+			case SCAN_SUCCEED:
 				collapsed += (1 << order);
+			case SCAN_PAGE_RO:
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases were lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_LRU:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				goto next_order;
+			/* All other cases should stop collapse attempts */
+			default:
+				break;
 			}
+			break;
 		}
 
 next_order:
-- 
2.50.1


