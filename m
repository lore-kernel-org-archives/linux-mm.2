Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CF4FCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8006B008C; Tue, 10 Mar 2026 03:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84FE6B0092; Tue, 10 Mar 2026 03:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB0D6B0093; Tue, 10 Mar 2026 03:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3F86B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:30:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 621B41C607
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:30:58 +0000 (UTC)
X-FDA: 84529331796.21.7306199
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C395F180006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:30:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZecdbAWVaScHzfXhmt2Lrf9nOd5m4QJ36dVQjPMVAo0=;
	b=7IVsiMGttxZ5P6erMvOe4IXV38xI4b8FoKpdZeN/tj4FwieOdXNF+ElSNsQTQsqbZr9c01
	GAn88XeI6bkDNmjGHbPbJ9D4/0iFXzDM1IsZu7M43V4nSKCQqLrbVQYVWJ70Cu3txcnNk6
	ybXKWPcnkUK1MX5+95TwpiaooYQ4knc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127856; a=rsa-sha256;
	cv=none;
	b=xJLGfsASXjdrP4prTaSLKjjWltxUCwSro2Ija/O7CeZyZ0+pB/aWREB0Dy4d3g6cKEvN/k
	lf6BFPOpI+qtx6Pxjgq4GwzUvKB2EadIuYP4JIs1zbd1KcGJOqPnDdaU86xmCCT7f8hHPW
	rS1AGN4AdHRVbLOM841Ni7YoyS1HTS0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 721DF152B;
	Tue, 10 Mar 2026 00:30:49 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BE6DA3F73B;
	Tue, 10 Mar 2026 00:30:46 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
Date: Tue, 10 Mar 2026 13:00:05 +0530
Message-Id: <20260310073013.4069309-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C395F180006
X-Stat-Signature: xwfkodsc11opbab68hwhpuka6pk66rm1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773127856-400274
X-HE-Meta: U2FsdGVkX1+p2FIfilk87X1DLKnKbIhseeD4qr0mRH2vj+OEPG8HvTOIgd6u/QMB6R+tZ/n3+hW7EHtDHcWHhAjAbcgaDIHn3lvheGK30bLJ3cO/Yz9/4ZNH2sqETi6ofzEEl9zrEU1fYQjP2iz4dPGV//R6Zf5Xx1GfuiiImKofN+gN2lyNqSCXK7S/6ruMednA+0Tp1eRI2oiJgbPcQDjlixwH9gxSO/Peg5jwdT8u9mMLaGSLaqVzRUlM28uKtVHtfn5IMLFTSDPkXBlMn3ixcPwutbAwMW0MYBl/yKiTS80KE8wkhBkiesmYPuucizQB5zuDCuir9mlbsOppzyXr/9uWMXlMYAbLAOhzQPAqluIWUqmOaHgy595hGExr+xWIrF8Aw1sv1+KcS7yxtem+mnDuOCxxvEysNfQRQsQ2KgODzEwJnHB6accKyEVaqP0k6EO/hA7vDWtt2heBY1G0op7b6fE1TD/IreQWUuuvyl85ihlte+LCHw7zM+weGf4j+v8QvcprK9Emh2Zbg0R/oTIG/+Q/5MEYzVYeL5+v09V/xIL70/HkWVS0kE8+JELaLvMgRYK9/C81Oq+/oYEWeizvDiRCgVHRk32QLOZ8vdr7LD/4Eq7TOTdPzOocig3+FwPs6CpWLHUD0PjzpSGJPYoCoZYXm8HeVnc9bDE/hQPQ0gn6iEkNw0NeQU2OrFSrmBJc/yh2IHy535ASmtaqqO1aixDEUDGSaxIvXAnDDQsr5xt4kACKhfDpbVdlQP9N0KHRzz7WUan0yvzy0Ex5RJWGqQ3iVawi1qcclJFyo6WGvXOa4IKpaKeW70oqtZZUNeh/9d3pVVcVPlRUXhJrMM71qpP5/keIJmnfd+Vx+zzQmr35RJISyRKAchIi7r/T1vExx3+NrXn5GmhlA5CYZ74+CTxJlsi0DmuLikb4/PhiOx5QBOh5AVD8oIEjGZV8KYluKcNyReOB7Bi
 JyEPsypd
 bCBxC4tNMRbhTPwWXgzvLufkiB+3m3yqDh2QcBhe1iFrQWSS95JzHKNAAnmAZR9Rbd/Bl2SiGG7uWU5WE6yO3xkTNsV/I7lVairJKTXAbwFn0e7IGKDcRKIP1g9q21DHjkHVLAelNQyWmx6F/1nq5HUr3irzegLwjhLgsiUhKlRWjKk1Q2kTFV8nKps/BSJAHshoxybXg4kYIr3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, nr_pages is defined as unsigned long. We use nr_pages to
manipulate mm rss counters for lazyfree folios as follows:

	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);

Suppose nr_pages = 3. -nr_pages underflows and becomes ULONG_MAX - 2. Then,
since add_mm_counter() uses this -nr_pages as a long, ULONG_MAX - 2 does
not fit into the positive range of long, and is converted to -3. Eventually
all of this works out, but for keeping things simple, declare nr_pages as
a signed variable.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6398d7eef393f..087c9f5b884fe 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1979,9 +1979,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	struct page *subpage;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
-	unsigned long nr_pages = 1, end_addr;
+	unsigned long end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	long nr_pages = 1;
 	int ptes = 0;
 
 	/*
-- 
2.34.1


