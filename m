Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29139D2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5CD6B0329; Mon, 19 Jan 2026 18:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8965E6B032B; Mon, 19 Jan 2026 18:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD056B032C; Mon, 19 Jan 2026 18:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2D06B0329
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25ADD1AEBC9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:43 +0000 (UTC)
X-FDA: 84350242326.01.B50465E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6557540010
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CbR4/Q8M";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863821; a=rsa-sha256;
	cv=none;
	b=M6oFu92dlWj28yqcE5+7rzLXjiZKwyk/B+d2jRhJfW1cY4o9YeVwYJ0KoyeDU/tQpy2YXT
	Pq/mq6eJ9iB7RGw3k/CUfcCx8goswKug4hBOiqy7zfg2NwfjdLUlcTgbsqmOAIxtGowA4A
	nt/J7rEhujNqta9EYpA/EFHjulIOO9s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CbR4/Q8M";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF2IZ+oOLCz+3/l7EvHWjlQAoVworhvz1pqKriwtOWM=;
	b=vCsdng+GJFFapLyhAYvzheW/erTBVpLG2/xuhr+6G8fU2jH72+ZQt1izuvaD+hVR4S731d
	Cm+np4MCyj0XPco2AQOWPy6H2z8ZrkZnjfp8Lz3TTo6EXo9ONV2x3Dd4L7LRUrCytMhTZt
	kEzSsLSP8E4KIFHkCrTh6J3uSOe8mBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F1854178C;
	Mon, 19 Jan 2026 23:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09188C116C6;
	Mon, 19 Jan 2026 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863820;
	bh=U0Kl+wiD7v3bKS5MxUETuhXKt1l6XvM+u7VYx7CD0wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbR4/Q8MGKn20B7dYkI0WERNBQpNiLPadHF0o6WRRYBGXVaXdkKG1IUYpLM7yKpns
	 JP+Gs7INtEgWBX37ODz55WyATkn4jClfJ8stBh4Y9ShJGBnGTn/nPjL327uPgsExHP
	 GqyvyFar2f8t7jcmtiuIMMHpf5k6jdG/rZ3vJ8DjwlquaT+nBx0+kbrD86o6MaPmFp
	 dWU+tCcNAmu5BrfUdCmxyNRWZ1A7xCj9lZTV1WQwMDApWozkQVGBw8pvMAlsNeTFep
	 GLoKngx/33AtVqUW/1pR9pcY5a8xX5eB9BiZPrjq1Vlic4cr+9WEjxqRCD+y8uMdVO
	 149k+T2c2kT9Q==
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
Subject: [PATCH v3 17/24] mm/balloon_compaction: mark remaining functions for having proper kerneldoc
Date: Tue, 20 Jan 2026 00:01:25 +0100
Message-ID: <20260119230133.3551867-18-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6557540010
X-Stat-Signature: 8jctpjqykt4z7965bywho1cc7yzht73w
X-Rspam-User: 
X-HE-Tag: 1768863821-157492
X-HE-Meta: U2FsdGVkX1/rfzJuklt9k1fO+t5RRkPJS8RSAZ+Ryx8Lu5q25MFNGFBUVweLGQkrJANC9jQ04NR02BVq3npi2603HKlwAEoW6oCED6y56LzOoVT72DvXJrVSmA/wnSPUurTrTwTWgpmQXQ2pZFJ/MbVjDWV89KOFquwnAow9c2mf1S2BI7zS+SNqNFirr8sRNsPO9HIlcPWSLg342J/XZs8hRyKHNWamJMGN6rcsEy9TR0CWzaq0uEJW+PR852txX022pwIP1Za9qUGHQrudHCRmK/Nn47d0xkYwQjsG6JWu19jLJJjVuhSnRRBwhRPjICPNAQfa+xim1QLDUt+1iQu1P9K2X9LPpcQkIX6ZUQSCriCJbtJdnhSJmemf6G+o2Obkj3Ca3epkZbOzThaWcEQyNo1XZ50JNRbUrYZW4eNzLdjMcLvQ6ym0MW3yJPK0+ShO4fhqNVe77UGBL2E0tELs08Mn2Bn79ltz0tkOZ3FDHHe8IuPTyZ9TGdboiwaf16m4S74416Pn0nh0JpZeAtn8tGGlpq5vpFbhcH9mRq1X2/2+dVNiWPohN81i3qCQliOtxWRbZytTB/ebGQl4MDPvC+SPRYpKUYff2x5RpBWn9ssMUYtfdC3KMJm+4dTqA2cggg+gxwdrLRw1oCqqZ1yklozoyxF3qOWfwfUSMjEaxLa25SiGUuocNufOnkk+VHzZVncdDbP0AC9Uupz2lK1B2hlYL/k9WGZ1/x8hZ0ArxhGAGTynUmrW4V+NopVowwkoaag6e17lbHAf1sPELKhvlpX8PvWV/n5ut8VFa/7lXmVGF6nGK9uVnTfeEGz8tMw7cClNBYpF3YQNnpGS0CHdsPJCr3OR0nFDFIatS+MZtlE1DfR2SeiF0Q+6WJYnq12timwMW/Hkg1QO7e9/VM2mOdw/A1n/acnBQRzDyA011jy2ZfGzLQvWx7O4hRMPHo4eSretFShwXtcvgou
 Zh05axeE
 ANWyUQSwfqXTr6ajmLd92Eo3w8HSHYKSiAWdglLv+jseQ2DNRijALsHVBvBw9KkjmpdeTvbU9Nm4JpFg0wJSls0ZMcbYSxpQ/1G6COlxlIMUHlZhg2FQttO8zg+lxRGbGodexiPlXKQoVg9MqFrx9x0GLaVvEo4iXU0ILpcq47yezHZZi5kQAzP1zmNhjkOYJ4+zLkSGWCSNJcJriTJwct7j0B9vle34ATsr/5UUjq2mhwzUaMlaxK+IfZFLO8stlfrVfnhbeitrR2FOUxaoGVx/TCZLJT6I7nW5GABUlIZp6DageD18moMNFmC+BXzjb0lbQ889PzDLQ7Y4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks like all we are missing for proper kerneldoc is another "*".

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/balloon_compaction.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index bb2e5ec2cab36..bed30c6c1a487 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -22,7 +22,7 @@ static struct balloon_dev_info *balloon_page_device(struct page *page)
 	return (struct balloon_dev_info *)page_private(page);
 }
 
-/*
+/**
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
  * @balloon : pointer to balloon device
@@ -42,7 +42,7 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-/*
+/**
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
@@ -140,7 +140,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
-/*
+/**
  * balloon_page_alloc - allocates a new page for insertion into the balloon
  *			page list.
  *
@@ -163,7 +163,7 @@ struct page *balloon_page_alloc(void)
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-/*
+/**
  * balloon_page_enqueue - inserts a new page into the balloon page list.
  *
  * @b_dev_info: balloon device descriptor where we will insert a new page
@@ -186,7 +186,7 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
-/*
+/**
  * balloon_page_dequeue - removes a page from balloon's page list and returns
  *			  its address to allow the driver to release the page.
  * @b_dev_info: balloon device descriptor where we will grab a page from.
-- 
2.52.0


