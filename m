Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68887D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE92F6B00A9; Thu, 15 Jan 2026 04:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA066B00AB; Thu, 15 Jan 2026 04:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDFC6B00AC; Thu, 15 Jan 2026 04:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF4196B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A94013A1F7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:56 +0000 (UTC)
X-FDA: 84333656232.27.B593450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 97E9218000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRoEkz+a;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsYt/P0o5L0xs0uU5Gzrwbqk2KvXVihUUdnO/Y4Bfmc=;
	b=tLHMjyQPfN7wwrD+8qEktU8NgRLWPPvXiINxXw8nnCzE7+mu1DzDkQwIhw7EXsNh1vv3zk
	CpuuQNNbHcHo/ECGclMzP1pfm3ChpPtbyol+wrUwRAzt/6C1zvkYDPxBWh/UZ0sXIZKOJh
	qPJjGEtnEDxGh/pfMsKxz7F09o50ghs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRoEkz+a;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468914; a=rsa-sha256;
	cv=none;
	b=zZXfr773as8CcCRn4Ul2sv2yvN1pPIjQMp3aQa9k3rsVXJVH6mtRF4+f/4PEuaVjzvms92
	252hwSJMLpadt90jZc2uGP3i0UAcH9uRcg7ouPx5B3QrPFwkYValPCcpOginCk5y+1zhdX
	UYVEWrou0KmgAPClgyPzneDrhVqPAfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F3B24174F;
	Thu, 15 Jan 2026 09:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4188CC116D0;
	Thu, 15 Jan 2026 09:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468913;
	bh=plBsJJDsOVKU21GBNZQ0Y8RZZjUVLRU39NQAtNsDJJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRoEkz+axwnx4uvOCDJzNCaEEpypD+Or2qirVm812qm0RODJPsAre4QcDoHRFY5vA
	 VvzJNNVDMVeOZ6M0jX2zENDqjSJgKmq3oifv1Lk3etoFnUduMtCuUDCWdad/m0rnth
	 UnuLcfh3utfedo46BP5h6OyQngyqEhhAbE2Klhz/a95rbb9AT3GYON8iv7QnS6qRu4
	 G+T4YFdkhIO2gvjUSbyHvhwkF4qJtcMlxNTDtkxSYXkZAcUrkfDBJFnNlGgn4/p/ar
	 9SlBNZXOdFDnUFDs+pp4AAM2r7MeE4fv/JvsPM8gm+cbiSWlt4pF5pLkt0vvE04HUX
	 IuUAF6cCw2KaQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 13/23] mm/balloon_compaction: fold balloon_mapping_gfp_mask() into balloon_page_alloc()
Date: Thu, 15 Jan 2026 10:20:03 +0100
Message-ID: <20260115092015.3928975-14-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xcjs66yh8o31fjhfj1uh1rpz7uxi1we9
X-Rspam-User: 
X-Rspamd-Queue-Id: 97E9218000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468914-764592
X-HE-Meta: U2FsdGVkX18M/ptTsxRcc+lB25f/mOt38y7lPCd1ojjtvrrgXUQrFZ9RQ8fzt1xkfY6Mx6GjJ3k1lKO2gFYVn1JkZ/eDiSoZNqDjKluKfZBqbD2qmqHp7jl0qYv/b0ABl5HqND6Z9Sskw7Bu1KyfnTgVQVZx1qFe0Oux7Ud85bHCOIEpsrTpRsA47Q8SGQzs7mX3HSFU2fKMUNjPl6zsn3EMkbTtnpzjnMFs9OVihkWqw9wAqN1mJOA65g5QLRRoT2IaBMoAtpHn+3IIipLH+qBezjVD5BmoZkjRKb2bwvRLyx1iHmE2qjsQXENK34ay1iXq2mq3PNlQLIkZb2G2QJb1FN8XU258l+Mmzl+DspkyrgxZUjQDXVuAiwEnRCvwDcGYNqO3a6Herf5z6atB5PhcdiD/LULqU/mAbl6mHGt57RLatB5U/3SWRI2VBiUo25mJTCZlITfUC/zQkN5TN/9hnzurURQUeRwBisSWJ4kFsJ/tYLxKBL4VGvoI1lrnu/aQ/JjCPoJoHlEWi9xgEG+Ls9CvAwNgbyRsGQAP4jCZr2MW0nfh3+pymBpX1yMNGf7wRWjwFOPYflthc5+XUWcslyoCTLTUt0gIq9Rag1hI+zns5oFY4+TYR1wqgZu5vjCQYM3FMYxHK1CP91C2BpaU30BtlERf8/QXUC5JhiCG8HwCt2NLE4pG1rv8mC8a0rse8KOUg1CYhBYb8DNEY8T0/KgEnpG3wqdQBg0xlO32t5RCxlah3Kz17HtTfRFwA9oOxCgIMdK/c+J6ZL9mFUoe60injQ+3pS6qgDwWSIyUjUDw3H4OU8EWSYZqGx5nDYwT7Hc9N7gm2CNtVD65PpwjPC3/RIyfZyzCNvUged6QabnJ0Jc7/wOrPXv4V0FckEk/8HSVzjrYCeXmtKnNjnMYGW8gJ580rg6eByzQNLgPRf9IRlRVgufmI5/q0lLqw6nz/GUR+/4EvLBnpFl
 vd5mK33F
 NSgEbbaBfIToXLrqGU8fv5C6vZDxb4mTrTBs0FBYTgThWza902RzXo/Z+rbW9cu16wsMU+Qb/hF/nez0VkJRFvsNi5OAemPZvdD+gQ+QjzCrIsvAEfUtvhUXQFESiYh0M7IGn2u6R1/W0xzvMklJo/IMSl1z5wIPIuh8uHG5SbYRhzklnUx+S64hL8ak5Y2FADF/2l7b7csYQUB8PpmbeFsVMfqlGapjVUVKSLFvUyEH4+r+17SYX+fxnAg1ooBpe90W9llsNI6ZTdABj4e8mjTs42ZLObZsGixX8hxim2t+v/Lgxj91/ysiNDGz7zgoqdc0Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's just remove balloon_mapping_gfp_mask().

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h |  7 -------
 mm/balloon_compaction.c            | 12 ++++++++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index e5451cf1f6589..d1d4739398978 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -106,13 +106,6 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-static inline gfp_t balloon_mapping_gfp_mask(void)
-{
-	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
-		return GFP_HIGHUSER_MOVABLE;
-	return GFP_HIGHUSER;
-}
-
 /*
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 90b2d61a593b7..709c57c00b481 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -112,10 +112,14 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
  */
 struct page *balloon_page_alloc(void)
 {
-	struct page *page = alloc_page(balloon_mapping_gfp_mask() |
-				       __GFP_NOMEMALLOC | __GFP_NORETRY |
-				       __GFP_NOWARN);
-	return page;
+	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		gfp_flags |= GFP_HIGHUSER_MOVABLE;
+	else
+		gfp_flags |= GFP_HIGHUSER;
+
+	return alloc_page(gfp_flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-- 
2.52.0


