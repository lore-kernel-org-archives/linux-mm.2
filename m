Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05112CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEA96B00DB; Mon, 11 May 2026 15:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5BC6B00DD; Mon, 11 May 2026 15:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBD96B00EC; Mon, 11 May 2026 15:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BACF6B00DB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:02:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0948214027B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:19 +0000 (UTC)
X-FDA: 84756059598.28.20DBCEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 198B11A0015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=can6E3ML;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33YAZlSHpHnNwLuGSUuxV1b2dD2oTv9L1+FP8VMMxkY=;
	b=qoyxYReh4KVMmK8mv5di36CbSOot1NvPP0nTj5dTPwkukFOZvSD4JJjoIVDsUoC/RY3KFi
	jaUXG/zh8FxuizwtbOe021YZWjICjVKiQnm0jaCPOpVTRsFfGFJexpY4ZvhbaiXrLC4hy9
	N1xmHem8M6Ez+1uemDksv15GKzyx01s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526137; a=rsa-sha256;
	cv=none;
	b=38pHMC+hoMSGhBa9wuie2eC2zwXj858nB74LqbD9j+rnRK9IJ5+Pn+HN9tYPihZmqbFVhS
	CsFAMo5aRaQ5jnQY9TNTfud/au0jOm5D09S6qFPl3/NVBPRZL9xuutGPaIbxgoPOrLSvfZ
	3iq4G4HJlycOs70TXMa4UKps11gOH1I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=can6E3ML;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33YAZlSHpHnNwLuGSUuxV1b2dD2oTv9L1+FP8VMMxkY=;
	b=can6E3MLr4/PfHWZDnHtwSs/nRzoF1amTvrNQ1RXeOIc4yAkGkKx4lgl7P7b+bPM+8G4hg
	c5nAMGY2mpbtt190mFxropxYqv5VK6h4jTRl4AjZNRYfWKdC5ihnloSSrAVXPvGyhXVWE1
	L7PGTv+E5HFP1/YGslOy2cBIyA8j0CE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452--rfupRzhMoekn7dhM4iIqw-1; Mon,
 11 May 2026 15:02:12 -0400
X-MC-Unique: -rfupRzhMoekn7dhM4iIqw-1
X-Mimecast-MFC-AGG-ID: -rfupRzhMoekn7dhM4iIqw_1778526126
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 549BC19560A2;
	Mon, 11 May 2026 19:02:06 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C5A173002D31;
	Mon, 11 May 2026 19:01:46 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
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
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
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
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v17 12/14] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Mon, 11 May 2026 12:58:12 -0600
Message-ID: <20260511185817.686831-13-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lwztv8aJO472s_ABodiJsTJIC_ieV7buZk9liHx5AmU_1778526126
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 198B11A0015
X-Rspam-User: 
X-Stat-Signature: t8anfhx4qanu4bgzi8petijr4w91qg8t
X-HE-Tag: 1778526136-663311
X-HE-Meta: U2FsdGVkX189tvuw03IVl6NYjby4Oii6KA0Yvi74wo+EB9h9duZZParEcmWHrhDn9TPfSkvH+zdX+EUnYUvZx7HBIhDcDRQMTQBZMy2DhfqcVU5kbCuxnnN2ase/L7y6pKQ6nmjlEEvsu1B0rEUF40GxSP3i5Td7J2Z81/0A5ZkWREIyIsDAJMWBbAbLWGK53EO9T/r7uV4b2PDL+bzK2/EOscpY47p4uIdxwHFVIHMFIsdexhmCpl/vBhs+8dueHcWSyfc9Jna456ifNYrYC0sijFubPQYnX3SoUp2IFtFwZf/H5yRBSKxaRepagwB4drzoz4qkI3M606AGO2u/k153Ul0N7O+/HfrUu+VD00Vz9EV2cHOq3sdqBhTByP4ku/Bk+7BpQrK5MCyYaOVYF6xOuD0kY20XjomtKPItQ4BrZ4xibYrAbH2sxWM9cPe7zz8hArHVM3gjYY3smwq2BN8Pa1V8W5VYWgEJrZOL4yZrYjshjuKUi4ccpFARf6zph0pfi8Y7C7hlLsPXIrRk53eJQN+XIv3sfKP3zEzKQMtCAO1gPdOtcovZORxzfnM8swK21v6B+9URi4gxYjsAybUF2q4D3HJC3nxBFiWXgInDVdr2NRjmxYLRpM9s2uY0+Eqi/hReaZUK+Ed/tIy7hXV1FhOpYFqDXMeV7UHz+AGMkuk37pkFNFBYeShXZlEOt59SnA6VV0Vn7xdxQQoChCJkhZXkHCdTSH5xU+wAZ6DoGVBZxUX5A1698/0D32Nxgzid6L2WkHFS9SUE0dEhnpOAma5/7gcKDquMGHgGU7nI3WIS+lgwD/BDYlT5sjcOfhjAPmNq36+2oJoAeLAiZ4nI+ZVWJ2ftV3ud+/398UWBBO1VFOtWjxkEszVaJa3+lZj5lwbSTD2arS5w2UuQ1D9C5Dkm/wkV75oLKyZ1l2HJncjhjGg2qiq6LryXsGosGQ+AJR3dusfhtkq3G56
 v0Qgj9xE
 gLtNipePiu3rNGSVe+ghlizasAPtlF+hk5IoaP0DdE6QceTKirqGxnrD00Zmc4L2mxJYCTzfoo6WNcv1zL/BPHi3u44j+fhwqowdP0mjbOwL9rBN5kQv+8zBdpnSHxHtmzVCeHuQuvdY6VnkQCHjrqtzLHmwveP/rrKyiAr+A4qGXhC83lY/LsrK4V6XnKli3eySoWDt+nDJtCJ5F9zq9yo8jYMXoihWiu5wlqpe9A0gUFeM9Y5oLk4SD6ECBJG6wnZz1dGLQaYDMcH/0BHy1jR1IJQG51JUpHyrnK9LbbpNgnnQtxl1ApB20EW7Nw7JQRYvE2wL3FImDV6Itg+r9mDPfikDXIrd1u/yvKEI1ddUJxOBf6UTYpa+9UaUpBQUmjn4DLQlg0OaKovY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 39bf7ea8a6e8..f0ae02936638 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1531,9 +1531,31 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases where lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+			case SCAN_PAGE_LAZYFREE:
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			default:
+				return collapsed;
 			}
 		}
 
-- 
2.54.0


