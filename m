Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F983103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BA26B008C; Wed, 11 Mar 2026 17:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C3A6B0092; Wed, 11 Mar 2026 17:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716C96B0093; Wed, 11 Mar 2026 17:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8426B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:16:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EED6158D77
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:10 +0000 (UTC)
X-FDA: 84535040100.16.F714EAD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3B44C18000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C7WyEHxJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9OkhhMhk0WCElJt7rKmc4vSI4ikBU1WsoaWMRnU5SA=;
	b=m6mI6qEiMZs9qEmYPISOER5RWIrPy+xMHg10KPxQDUDNset9A5WJ4zpf0mmtquExZ616Dz
	iutL+LXSpu1jaD+VjkuNAoaPvyYRASRX+PmQ9MmryquPcoRgA7UIjnTmeIUb/r+vPQrjkL
	RnYPZ5dofL+f1GMM0HJ0s+okTDkvu7Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C7WyEHxJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263769; a=rsa-sha256;
	cv=none;
	b=XTnPA2Vve+2XesQXjmL8VLyvxOrEdwngiZhBJdcDkZH3RqtOoVUtmNyBhqs28Ba3t9+PYJ
	RzA4Rh8XI1JQOW5yOAoztLq+4raZC5tTyJCfl9cpSeJb2tRCrzMZ7u7Kt9hBCw7UX1JSSs
	gC2uIe5Mf0KEG2U5wyzSbQqVVOPDvcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9OkhhMhk0WCElJt7rKmc4vSI4ikBU1WsoaWMRnU5SA=;
	b=C7WyEHxJDhXC1Wyl3GbsepAthQb0YbomLjwn2tGEz0d2btwpQn9JlQqEPX7lrfZCms7+qR
	23JEhL+laWFtIdOt1wIZCfVhQA6N93uEbTJBA6K7AxHRSk/guxRbpcIKV/v8gsDJItpYW+
	L4/s1nudMagolJa6/ZOWK1nZutFFeis=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-j6bYkQygNNSUGTl-xJbtSg-1; Wed,
 11 Mar 2026 17:16:07 -0400
X-MC-Unique: j6bYkQygNNSUGTl-xJbtSg-1
X-Mimecast-MFC-AGG-ID: j6bYkQygNNSUGTl-xJbtSg_1773263762
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C29D1180034E;
	Wed, 11 Mar 2026 21:16:00 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 19CEC3002D0E;
	Wed, 11 Mar 2026 21:15:49 +0000 (UTC)
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
Subject: [PATCH mm-unstable v3 3/5] mm/khugepaged: define KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Date: Wed, 11 Mar 2026 15:13:13 -0600
Message-ID: <20260311211315.450947-4-npache@redhat.com>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bwK-kQlpVeKAHV7A5dpGQSRgO-VK1xli57zFbVBJlLs_1773263762
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B44C18000F
X-Stat-Signature: f1unwrhurow1ikpmhmkeoxynzuc1s8ew
X-Rspam-User: 
X-HE-Tag: 1773263769-441088
X-HE-Meta: U2FsdGVkX19dY+25shtqH6xPCWCxvxNcQyDUuvrFW19zztBeJYqfC1MIGk1oWFh4frAYA72nA8MJA/cvUMCUHL6dz8/fOSbNM6/tbHIiW2E91XoO1cOmvig6sBReXVpXldqbRJEMwaEUSSUaTessy1EUhHxhj85JQNwT6O1HcQ90v7zhhP9bcXICSwG0dI05yF75OJkMoxcaIHRw/zmm4d0VlMKcwQs/mavHZ8e3f4GD5gZmN4jtaxBXQKPH01AcIq6FrhW/wUgeDHl4Rw9sZPrt/PfqdbEzXgEFdcjwh7VtxD/C1OQBtc6WL3X58tglyrB7J7V5IO/P5veRvKWxVfV+TCuwxOOQ2S1dQhWZGQWsXmA6snhyvTERqWGX+ky8pu7l5X0Hmx2bxnz7x1aHLixjUjjk7nkhAU5Bg5JvyPdde1UlI5kFO6gkA0qj2TPcEho5XgzrPct4UsHW2znrAje0nDtQOYZpFYjU21w81R5sEehsJsU2S0idVawvONZov0T+dFNKU85o/QkgTh0WLeAyL4Hqayu2ExdJQ2xc6TzBh3GlQ2LMqPvLGn78PNvroUG1SixA+M/E0SV4ioieUEN2barQ7L4v56HI5bS9pzK7qCsYmAVSmkhRRpdgTiTksa88w+i+eXHm2686FrxDLNLgGB5uB6VEpErFWTVuZgPU8efF2lxhlaQSybhY6EAfPkX+VmYtvKxjkJbIV2NQTxINAqvtlscaGiLE8ENEXWRzknLDEH2rGIutlGP+TU8ZxKG2CkWcUApejX1Z9nR1DD+1gF0hCGESkarfSyUkGbvl3bytS3Hsu4nyc1XTAZOi5ZVxpW+ieYHchPPcMejw97npnPHixEmzhyMLQjsthsrOo1xdIJh4DZyZSjMcV6yGv67dQo7KMDDrEnDSTVRdkaA9GCE4A2NvDPrguL48pFtBjqRpyB50CNj7OShEvF//KQhu0NeOXyUSRF/ZKG1
 naXMLMVZ
 9pVvtVprREIqFOFP0ipPGA1eYI9rqf4Uql9kXGMiQvr6uNCHMYwnj9EvvpEgdCC5mgJfDXar9r6XV7ExeyO443WQOrftC/q9h8Pf8
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3bdec4ec61b..db77ab5b315e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
+#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -259,7 +260,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -284,7 +285,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -310,7 +311,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -382,7 +383,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
-- 
2.53.0


