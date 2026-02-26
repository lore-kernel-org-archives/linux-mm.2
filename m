Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F21FD45FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781DA6B008A; Wed, 25 Feb 2026 20:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704E26B008C; Wed, 25 Feb 2026 20:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD986B0092; Wed, 25 Feb 2026 20:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 500E46B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:31:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1965F8B8B8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:21 +0000 (UTC)
X-FDA: 84484879962.26.C5A9769
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C5B91C0013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFmG0caR;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvNozlzLA/ebYnDRm1WHGbK4AZV4ReJTtrZzdXy7rIw=;
	b=H8MsYuTF3FBb8M73eYrh9I1hX2+Y7Z5yMulIU/K9EJwVJ+qkE02FuULx4hiiJOQT1f3eRA
	kFDbfURQXsHpOlVj4dYhz5S4SFeyI47nP7aWOHYLQJ8g1kYchWvt7NgiFIloq9hFuI6f9O
	wgbbRiOSuVM37WrbzlM8Wu9MyQCG3i8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFmG0caR;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069479; a=rsa-sha256;
	cv=none;
	b=bBxt8+NaY/FK1YlChaFGHDhUr2OAbVKEy/m0tkEHbY8l/8tEF4iL6C2GyvlnqLQ7rm7O81
	HWwh3ptRD1MpJ/W6CCUfY5n5ttlV5VBNdT3Zgx9UV4DV3lnTz7Ze0/XqpW5aJcytg0hvBx
	ggT6SPmJXg2GFb5tnBeZ4b9auGO2uFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AvNozlzLA/ebYnDRm1WHGbK4AZV4ReJTtrZzdXy7rIw=;
	b=HFmG0caRHXUV6hS7wKeOxnRk6aMrRpa8ADBFNz5kZkmUT512osDq8XT9QYx9lssjxmgwg7
	2UXfHwENLEq06U71hb8oAwRJeeBGynZnm/NtsH60mmqpOoUSHbFfCTJZAeTGoj3R7XZ3PB
	OGn98ezyNg1JI3utlKV1AmRJB4q6uE0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-mNbgZne5N-akG3rrBXDuEA-1; Wed,
 25 Feb 2026 20:31:16 -0500
X-MC-Unique: mNbgZne5N-akG3rrBXDuEA-1
X-Mimecast-MFC-AGG-ID: mNbgZne5N-akG3rrBXDuEA_1772069471
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 582411800464;
	Thu, 26 Feb 2026 01:31:10 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B3803003D8C;
	Thu, 26 Feb 2026 01:30:58 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v2 3/5] mm/khugepaged: define COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Date: Wed, 25 Feb 2026 18:29:27 -0700
Message-ID: <20260226012929.169479-4-npache@redhat.com>
In-Reply-To: <20260226012929.169479-1-npache@redhat.com>
References: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ys_QUBsbMU58KMal58JRLkNAUbpDTz8d8rdf-QG-htc_1772069471
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0C5B91C0013
X-Stat-Signature: w8wbzyu4owewu96ad6z5ergaawyippt7
X-HE-Tag: 1772069478-563992
X-HE-Meta: U2FsdGVkX18+C+BaBO4oE7Hs3FG+Hra2L4I4H5gEDF51/wXCvn2fPe/0Sa2xTdvte0c9NAM174x7qkXJ7SwwaTvRUcdjoLDBUK07Rq27CDVhclkFFMMktI+kwf6U6aIR4qX5cnu2KV3LB7NrmEn1S2brdI+DoM5Ba7Ub5+UpiU+gX5TObeFshBrXldrBPpYh16DQxdCQVCZW1BLXYUY8RMVMY2q0rqNfZToedsTVAsjgIC8rBHMX6EsXYcgJGAjB2OovaSqAZv2ecHSUmRobTIYsvkH6IwS7E3WWXexzCUjLr/1I4tfpHv6g4mhMEuGlybIqIc8kK76j6xV2zc5u0qdNijBwpGV/K9IhIUKOlJ1o8zZwZoF2hpbsS+liJTvdvw/oa+plbtc0mj4zRKWLCIlNeYThk15kaLvcFR6aT01QhBvUswe8pYv556yWW4E6US8aS5ZuJLmXVBfmrImijlyDEL7YRH/UnmrpQWtvdCVJVE5r05/DC6vP+2i6hmZRwcsi0R120mO8tm3avzlSTpnKgXLYjfn0sDeSV7K4+Mq4S0t0YBaSpKrHVkR+FO+Bke8srs09c6GDFQ/BsQ9EcIr4oxF913bZlYJuTp3+eHcWg26PVPRTr1DNQBxspEcEtfITP0RQ60mVM+pBvcDp+suZ9Y7FzbodiGU+YQzFKIDih5eSOUPMoRbV02AjA5U7JgcSDhsBNn1QeG3I7nW6XSFeICjapF3OoUcQ1XK1hHJDebtZYd3J1fEgJ2mTofkjAz1cqj3pRN2Pv1YayQ54at00NTK+CtnJ4Pu7ucpB/6CXlRNq0Ul+bO17Ga058mhe4ekRWXW19szkmgbuzCFuZrr+X2haH4MsMQhK2bKMja/OdDV3DtgMGRszUMJpqus7aZHEPjMlrxlifav0xlabSIrGHNCc3/3xkpCN+ae/yn3n5tXrCMDA1DEN/SZeFPAH4wOVq+3UfIC9hXqBQeC
 twGwCwS2
 F2bg/IwmmRzGDdbtjoefzBANa6ZDhNNNUoWqvTLAXXNdlZHrxIq8dUOgCUyTAdxjA/FmaYMugScjSB7y0IY0Be4gQgIeFeoVK3xB9MLJRdAta6hYhsm11xrBDlHSOleB8HXjrHlno2CT0k9xOaqF8lmJ9uNx20sMQSCV/poceVqT5OVm6F5HoJo2cwI8rrzlDruZQH/cWX/578LEa9L0BFs50jcHM8cP8tMaRHzOYD4oBF7RAMA/xrAdrUToxehulvW5FWg0ZXxS92phdTb3/DX6mHo5cp5ndljsiiXge5SeBaw+df9gEbE04GDm3kEKj1zgazphbFNUecjfiBEHLejlWJblYYFyFI7Gt+PfgmOZY4VL3beV484lB95t/Q7q2B+Xzn5eOUAszTLm3CoBxP/ZYcn6E3Hm1OCigZ7/fGelgwb6XoAQKywXq5GnO47UxLCk7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
signify the limit of the max_ptes_* values. Add a define for this to
increase code readability and reuse.

Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2ef4b972470b..4615f34911d1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
+#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -256,7 +257,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -281,7 +282,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -307,7 +308,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -379,7 +380,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
-- 
2.53.0


