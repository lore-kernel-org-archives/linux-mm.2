Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5C5606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQkCpeqt
Received: by kanga.kvack.org (Postfix)
	id 3909A6B05CF; Thu, 19 Nov 2026 03:52:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368496B05D7; Thu, 19 Nov 2026 03:52:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DFC6B05D9; Thu, 19 Nov 2026 03:52:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC536B05CF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:52:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 200541209AE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:43 +0000 (UTC)
X-FDA: 85451253006.18.6840DEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C50640003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQkCpeqt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795078361;
	b=ujsfD2UuXA7QgROrNLcXO6USOEa/c576+klwegpk6nr6obHeOMnMElCryDz/vtnfreqwpd
	g1tIapvF/i+JTNLuj/lVysq3jzgMU/aGAhVAtNR0hy9fYIzGMy8Hsagc279pz/gArf+V4h
	saF21ln9t8eXXKe+EBJHVawrLLB86Nk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795078361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slP12k1/UmuSqVqj4kei7CXwqTFf5wNJ5fzGochv76w=;
	b=BmQ1BdKDJ3bQnZodv9bdwGjejmw3gRhNOlHS9xlAq2k72nDzLpqq63E/4/+fYqmvxx1IEN
	SeEPCQzlOC1ARe3xMLlWI+QcTDbU/6suFv5NfUi4mcC+y/UIRR2EOHS7Ms6IAJWH2MOkW3
	6cRyhZu5Ed7mtgeLJ3hWMi++cePtOm4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQkCpeqt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C9C9403CF;
	Thu, 19 Nov 2026 08:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F741F000C5;
	Thu, 19 Nov 2026 08:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078360;
	bh=slP12k1/UmuSqVqj4kei7CXwqTFf5wNJ5fzGochv76w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AQkCpeqtER/pRkRAMr/L2oDOE2ERxJrbyHH375vGguYu8CugXOzlCmh4jy8w+SA69
	 nxiVYh0Pd2RZq2Y+8m/6KRT/ZMyIBco0fV5jRyZf+cLbEFn4FSS0+OhJVvXDj1C4OY
	 J2DYaVfSdMGNxKaxJT3UTd5u0xOkfStA4kBgZflLhKugqXPXlxrMn0EkOaIqvWySo8
	 yAhl8SVOdu0rGqfS+Gp4BJB2FhDgBt6qBNEfD4kj3ujBCNF/yUlEBKdWvaJpRR2PNS
	 I8PNugYeamptXxk/vL3L1NFXzT8H8wX1B4iHruU9Aq5ouc7CiYZBqWDFH6YJdQV6+S
	 LqamHn8KuBjww==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 09:52:20 +0100
Subject: [PATCH 1/3] alloc_tag: handle a NULL tag in
 alloc_tag_set_inaccurate()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-alloc_tag-v1-1-efcccfd3a9c9@kernel.org>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
In-Reply-To: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2198; i=david@kernel.org;
 h=from:subject:message-id; bh=pQCOEBuVtuHz63BHCaKRIv21JHUplhwXXCn7IFnZRLo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+7Th/8FPU1reKDbNDJlruSM7v6VQ4JH3O3P6fc2h1V
 JKWpsicjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbS9ILhn2JhTcmi67mXXfX2
 KLxMXHRR1tA3pyzhxfp/RY/7XqzXDWb47709PKBozbaH4v5yUs9epYTKLVT0+LeuJ2vlpkpho61
 CnAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: fxq8mct71uccdoni4fo99fm3w63rizjq
X-Rspamd-Queue-Id: 4C50640003
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795078361-211671
X-HE-Meta: U2FsdGVkX1/KT4fZc5iMLquWrz72qRwXd9HVBE1QsUEve9IR1eLu7gKLdl3EZ6K74c4f2B9BPgkNA+fDrAWK4s4mtN/Yw+ctFY6aULzRgbDUXvnL0lPYsElwQMewrkxUFqs2ICQmQfWPNKvakEmC5dsXj82/Pp7dcmOtoWBkiWrYpXc37Cq77wd0rB+Nu0X4gsdltkW9e8Um7x819qMaMNc5WR+Ih8hCThmBdDbL+p/Kw9OkL0MzNFTfBqVr8oYWCl9fIfKPa7YlWZitIUKh8Tg44DKgZVJNdOcK1DCIvWivltCe+/qfqoItdRENIJXl8m1ZvssF2Opi1uOt7jvC044evA/xuCF2Dzyifj6kw6W2iRc2716hxEmn/7lRFQbLZNjnV1eNWlhLo1Zd6mFDAzvJTO9pJV/IP5PADTLrdLFtha9Vub/uFAO1IEqrQuw3qKb9k8KpAXk+LFWcfmaq/6wpZ12Y7Kn6j+Cu16NVGpCUjPlW/iOB+KEDKru+i9SKcMaQwIQ2Rp1zWlVaREeaIoSjoV54q7T35v8WPVgp6NkcNZ3jHuWvPEWTFIZ0l9qHxxUiJ0/NZHvqpYxN7zpe30IiG+YkNXnPmW3OmU7F1n0RFSHupbeWotug615nVjBdo28aUNOc6+6XYKgbGulCPCuSb4+S6zT/SNyCTYDTj1J975y14GjeFO4FxKsscAuvqmBi8Lxl0tIqdo8Sxyr3tRLyFau2j5w1D7oyo+45FOdwyo2fOOvtNkLJoH8jir5p51fQxKFWIEQNE0stBwTRTo5N6O24EEabTXLcuJKRFmU9siwaNMI8G8A0pM3d0l+s3XnNB6vzymqxoD7OHAZfCJfiJzeKKNmkVONwxMBIq+dDKa/4OfdYmdv//Dt7vgJ1IXiChH5WSHyyr6HEaI1E0MC1eBf9th7wMD9CupWyTgj2QAmLGhxKoLubC1kznFEHP84yxxsSPCcoGDPz5KY
 SW3OeKu5
 OjSIE8hdLExzuEUZUq4DQFzGvz7diPdOQ3IObllVWKkyAI3FBeUmiPEzNfJeMfK25NkaFTB0H6ZU0qfgG4L+U/10v7PdPCoOjKZ16rO5eJjB9zzgSwU72bkT8Jov9ts4zG8Ixw7LuJCYtnxzl1/sAqzahD79zzt3AnUtheuVMRkiAxkzDOB17xGhYSHfeN4WVDw0HavfXoSSPfUGQ4vh65qD08s4l/YL5WqSHDt93MAtHyLHKnBgNXLS+Hv3QQ0tqUiB+vcf/UqPDmVdwq0bPHqA6UIr8bbAWQ8d9tP0SqIQa4jt7ShbfqMm6yfN7KMJZWDqTEIDJtNsJ8ggzzwuMNXsbA4k4BVWsVTNNASv/sARa0E3SsdNwp2HD1TFMBgwl3PfxllSFgH3iLhkMQaFzHiGZcuAYYYxIU7Faa+9bNHW6KdDyrHNHOUTuWQyaFxFg8jo2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With memory allocation profiling enabled after boot, a slab allocation
can dereference a NULL pointer if current->alloc_tag is not set and
allocating the slab object extensions fails:
__alloc_tagging_slab_alloc_hook() passes current->alloc_tag to
alloc_tag_set_inaccurate(), which does not handle a NULL tag currently.

One way to trigger it is through rhashtable: rhashtable_init() records
current->alloc_tag in ht->alloc_tag, which is NULL while profiling is
disabled. Once profiling gets enabled, alloc_hooks_tag() sets
current->alloc_tag to that NULL tag when allocating a bucket table.

Fix it by handling NULL tags in alloc_tag_set_inaccurate(), just
like alloc_tag_add() and alloc_tag_sub() already do, and drop the now
unnecessary check in __pgalloc_tag_add().

This has low urgency.

Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/alloc_tag.h | 3 ++-
 mm/page_alloc.c           | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 7f2d80a597924..0f9909c6701a7 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -227,7 +227,8 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 
 static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
 {
-	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
+	if (tag)
+		tag->ct.flags |= CODETAG_FLAG_INACCURATE;
 }
 
 static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fef4092c913c..0b76923145456 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1262,8 +1262,7 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 		 * clear the tag ref later when page_ext is initialized.
 		 */
 		alloc_tag_add_early_pfn(page_to_pfn(page), alloc_flags);
-		if (task->alloc_tag)
-			alloc_tag_set_inaccurate(task->alloc_tag);
+		alloc_tag_set_inaccurate(task->alloc_tag);
 	}
 }
 

-- 
2.56.1


