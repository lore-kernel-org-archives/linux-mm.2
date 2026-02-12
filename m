Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0679EB270C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428446B008C; Wed, 11 Feb 2026 21:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E92A6B0092; Wed, 11 Feb 2026 21:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5496B0093; Wed, 11 Feb 2026 21:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6776B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:19:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CB9A8C355
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:33 +0000 (UTC)
X-FDA: 84434198226.10.B0BB6B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3EBA1C0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KSAJ8p/h";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770862771; a=rsa-sha256;
	cv=none;
	b=quvCcQ9Zny55D3Q+6N1F8xxfh/0zPCVb/ZMZ86oly0k2nQq1hg/3Of2IreqE5LiEhZvWmd
	NEW5dcu7IMwDGbOsO69iRBxJsLwSNjtpUxOysohzmZBJBfsXSW3RxUDiGHocjAWcXTxWhi
	wNxqheOGxmql67//IhlOEvBn0LfmFaI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KSAJ8p/h";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjtR0F+sNTw1I9L2+TY8dc3ujo+lVzKZ7PJHcSSnNDA=;
	b=ALnj0xinCZr1qnUaSrOvLSql64ozpr96ChFaoGT6jAsh94+dAoSKaQPSg0ypWzfLotIwh9
	MJVfVpgNDaso0r5hGFTBCQG9ljwavMbvncMEQaf9UMPp+HAWlUe8yy/YmTKwk01mjuuR4O
	hbzDFtC0OuOIx7yIOF9ONS2jPD631yk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770862771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BjtR0F+sNTw1I9L2+TY8dc3ujo+lVzKZ7PJHcSSnNDA=;
	b=KSAJ8p/haQ8pBGz8zfXTWotojrw78zOgF6XirAkXBXiWG8QMWiLAxuw+8yTGsnCrDkwQYQ
	CI76D9w1i1cISLzaVdEo47gNLnEMhH/aDwezNJDcS9/ADZxrBVfCYYYTunSBkZVcoqKvDL
	Usw1WPJODWq9Wlitw8qEkSxdtdhKdbY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-59j7nV9jOsq6xjjhlTix9w-1; Wed,
 11 Feb 2026 21:19:28 -0500
X-MC-Unique: 59j7nV9jOsq6xjjhlTix9w-1
X-Mimecast-MFC-AGG-ID: 59j7nV9jOsq6xjjhlTix9w_1770862763
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DAF41800370;
	Thu, 12 Feb 2026 02:19:22 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0EDA01956056;
	Thu, 12 Feb 2026 02:19:12 +0000 (UTC)
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
Subject: [PATCH mm-unstable v1 3/5] mm/khugepaged: define COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Date: Wed, 11 Feb 2026 19:18:33 -0700
Message-ID: <20260212021835.17755-4-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Yj8wspLBP1IwG2zGgKrVRgLhwrmsnLkh62BTE_34qVY_1770862763
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3EBA1C0008
X-Stat-Signature: oxueo8o69c8neox9mxhz7za3d57a3irm
X-HE-Tag: 1770862771-367755
X-HE-Meta: U2FsdGVkX18CbMoymt/u1B24gpZpQmibO/xkkXSR2nUv5E6ZyESj7jV69VX2ZXRVnCEYv5Kxskg5X7TbeWP592vGMgiLFa4q4YgRMKneRGveHAA5OzbbyJWq2vRa38zPi0eYfF0eazD1OwQO+pyE7S1+rYczV1/bxh4n14ONQ/SKJELOg47WHH2bM0VKppPV25bu6bwanFwdu5CD1fALsuVrVyO243Q97acqZl5+qQdMyJzpKonsx7RcgCncOPGsT888GLZ2064ZVWw+a/U7OuXoffFZrvgkRvy3/nmMnuz6NS/TQkxdty/aeIuVG/WifXSNd8bRcnkrYEuTCyRj8YC4xG0qTq3qUbOS9aUjOwL0I4Ic50A9kq0zPJ+clG8JBx/xwEKCb5YGnG9PbvRrF+SrKluPHsmBeHGhaLNngwr3c2zh78yTq7LyCxHk0Vgy8862tzjQUJyV/Slza9arSRujCEbhkzMkk7dlYr8FrIprTyb6HmjSXIjn6IBKQo/eEk7aC2WDEHFvhXJNEsbRXDBcALCb5X5wjNwjAFpJHKYxGFQHZQDCT571kZQrfWVg3IweCMXnbAV/QVyxtY6ORLq2CCY+EaHYY6VmyvDhd6OrImV8Hl5bzhOOwRzVlFl5YDAx8vgwlmgDRIMKxncjUBp0VW1AA2EGa5ngkD3hnFfSwlgALBsbBHvkryIYCG+TYIXNnG5TLCBimaBc71Mam/WxKR6NTAxF/BgrL4q10ZqES0ojcZr+/u+rtM3ZlyBVdH7dZqY/KA85uqTmuVJfJa2p3Y7bussjIJS4BknxJKSNqlsWjLS36BD9tWzS53HnioUxMeiCp+10T0ips5QtwOviSIQwAVLZ/ZsNwIto3mZ0GFlS4xCEL4y8ffmmaGwL8EoLepC6ryBHwJK9xilF0XcXj/qUb+DLgUSbSD+ydRMG4KHg1J6qs5lqNUb++IDlxa9nTn9tXDfEPgvEzBp
 8Ko4GACa
 YTOquPCpKJM347Jmscqx/aCgLJyW55yEgun29M0OJl4Aev12HwfyoeIL6P7lZxGQR0ULbQcFlCHCTDPw/XymiU3NzF/AoSE91dUDbJ5M8n1u7Hk5ZnH3dJcduMFd8lV4m+9zZ9vN8KYqDl1UbxccMoe+P+FMjnq5BmYdHd8SepIXVlsQc56r5Q8uyRudyvKYVebXG7Xl9CEeSdxqbiGY9YtoW/afcuto14Zh5HEj7ZF3grZI6h83BLLNHZzv6PJRmgfZQq/OpOynJPgNgBXP1n4AtNynWPoHKPAlaKfovIqVAn9veY8BAazyX8stcmPc6QVnmW7D5qmb7J97N45ibb9cezOoa1D/NYckazeEZrAcW/ToZbCYSoas8IWMgZbr79C8N9ltzab9ibVNGbjIVAU2c+QrkJzbEVONJYeysJ7ZDhCXevwBAkFgU5lysDpGYm+KxIxKC4J0KdRU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
signify the limit of the max_ptes_* values. Add a define for this to
increase code readability and reuse.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c362b3b2e08a..3dcce6018f20 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
+#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -384,7 +385,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
@@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
@@ -2209,7 +2210,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * unwritten page.
 	 */
 	folio_mark_uptodate(new_folio);
-	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
+	folio_ref_add(new_folio, COLLAPSE_MAX_PTES_LIMIT);
 
 	if (is_shmem)
 		folio_mark_dirty(new_folio);
@@ -2303,7 +2304,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	rcu_read_lock();
-	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
+	xas_for_each(&xas, folio, start + COLLAPSE_MAX_PTES_LIMIT) {
 		if (xas_retry(&xas, folio))
 			continue;
 
-- 
2.53.0


