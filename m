Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C95BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9C26B0095; Tue, 18 Aug 2026 18:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143BD6B0096; Tue, 18 Aug 2026 18:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0595D6B0098; Tue, 18 Aug 2026 18:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D99B06B0095
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:59:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F781120140
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:33 +0000 (UTC)
X-FDA: 85115908626.20.8FEE3CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9ECB2A0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHZPBPs2;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787093971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1x0THuwlQHV75X2L7TyoBUXAkoOlg2uj72r2UXh84o=;
	b=agZOwRaJoyXy6jyC5dbWB1peto4EJbxVIHw6MW1xYxR/3Yj7Vx8KCTRR93Xn5CVknQHF2F
	vKgqVvruOIIlx0TxoDOd5IVeX1CPKIip2AEFzBs+JWfRJBTeeT0NsIiv1OOAI7MUk/RFJK
	ijBmDwgFQ75k7nUtn+w2XXb8D9hhFIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787093971;
	b=kx0O+qRQecpXFMH98tkKgjAWv+O28mOE4cH/YdBxLHyxz4YujHlGZ1T1aLfZ4m/aIe+BgG
	e2YOp23JJZHYUzigMR+Ctf1wKxl4TPtWVdk4ZrLLqGkWwF4h/wckjtqhXUMABQecePLlHZ
	lEL6GuFlpdvMSy6RVP9IyagRrtrB+9c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHZPBPs2;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1F4C43ADF;
	Tue, 18 Aug 2026 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1621F00A3E;
	Tue, 18 Aug 2026 22:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093970;
	bh=B1x0THuwlQHV75X2L7TyoBUXAkoOlg2uj72r2UXh84o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHZPBPs2ZsXHZEEPdxNKFFIHv6g+omPTLAwrOnfk72DZKY4Rvl+/XwHk4K9ZBE0K3
	 bu10OqjJC2CTYjB+W+qX+mpQEQSwwn6KIViALPI91C+W4hUADJ+7LiM709GGQRBC0G
	 h340onceStKr9OqWRfQtIyxXWApPymKH1q9HxBoDZg1Qt/M+F/qxUfi/hgMTuJfonE
	 t0ycSOZ71tG/jTdwzkS56JNJEfp9SIB7qezvxJIuY64jIXCLdXN9LOOXhM38MhrKNp
	 5Evhw3EXpr3vP2BtRHRxIT1FLeeHt/OCp8lvaUybSRv7qUdHVNEtchkfVKv9wC2WB5
	 bNuoBEuGb+Rww==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 3/4] mm: drain LRU cache if necessary for splitting large folios
Date: Wed, 19 Aug 2026 06:59:03 +0800
Message-Id: <20260818225904.55236-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818225904.55236-1-baohua@kernel.org>
References: <20260818225904.55236-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6kz6hh4zexjercrra4ixn7fpkn5yjamt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9ECB2A0004
X-HE-Tag: 1787093971-681686
X-HE-Meta: U2FsdGVkX1/5qpguHxjos2RjAzUktMrZ9Z2NklD7n8RHVqPHaivzpdwxWK0cIRUxwgEr5jEIId+v6ooHWGmwVqLDSH1IAvkIuhPdXixLAbgP4aHtwjD1qpfGVTNMa0b6vSZ3YXjGTpw3nRxTrrKjNDTFsMX9j02DE5jmhr/sQ8B35K1QsbUQ+Ve1jxPf+DqI4OTVVyfRK+yl8TxpMbCN5sv16bzTtfXBuoC/Zx7MsAv3JampOChqxtPnionwaV95fPvWzwOP5DFnnDY7lDZBDUy5UMLLsSfca5aTWODbnxUIJVkX4LNxesxaC124kn4o5EaQfcsXKyNi5aj+33+aaAih3Unyoasw6ZAWbkMGCrpdCYTGa3d80J4NPzThUiFJLqtMh3Cp45v0tgM/IKiKsVTKH0M2uJYBeRSKKmBFNwdiFAPBs4Qp3prqu022ir7547RReRa0fB1IHxq1WFZqTJ9NHf0pHlrQewCWyTlk11LtvbFyQ2Tk0nWRlkznqJQG6+BTy7cVo+XU3laUtJR8m+e6LrOi3tUdGIUyUebznAogluHECqXBxx6+V3vLZwXlBG+46ag8TnO8m0xAcmpWpKjHcleqWTumYOdReFQHZiT77+mlKH2mUXfmaG+MKxsmXIX0Ni8sbuqsig1Yy7Bbn/pgdhTkknL0FRZf4T5/fbvhxFvC2XdhZ3JI/5V0I5CBooZ1KoleRNJM2SvwP6CzZjRWJcAaHE+c00fQqgFcBn8JotBNoJD7mWGj1kEinyLmogmUtSWSRU0WTamXJTPbv/ZOCcjQ1NLbOjlRvQG2+wEfJnQ2c8/PIFG23JtfcJ5AcBGNJjc+E2C4p2i/FHnROa1tseBzBi9ACbKw1tyD7JlBFdw/aAR8J8qKwul7rHPIOLVieAUpyNyV+Fw4/+r9uYS+aDg55lIBCq0xvp6IMJSpBxjEaZBDumgbwYMP613GajntK6cZ/PVSK7RFXFI
 bXxrI+HQ
 yDng/b+kge3iYv2wGx+GjDUbjVQnVsU2XLYiF6Fa8t+7ncBkl2VxLKVUUnsSWpHqH/eqZL91pGTzW8YFZlnYFNtvslh7jCGBEElVWvvuEzx5mc0idYZK5aaiOS4dK8dHpiHTGTQ/VFe6uMlXnBJwFsEd7R7Z8GFdNua4rUBd4RYQPP8iPdH/F4UpLx20vlyYbIzjTqdKJtsgZfu9hMgewuuQhXJhtuL1qD+GGmx5u6fOX5b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Smaller large folios might now be present in the LRU cache. Use David's
new lru_cache_drain_for_folio() helper to drain the LRU cache before
splitting a folio, ensuring that the folio can be split successfully.

Also, we only perform the drain when it may actually help, assuming
that the lru_cache holds an extra reference.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..263ef9b6949d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4201,6 +4201,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (shmem_mapping(mapping))
 			end = shmem_fallocend(mapping->host, end);
 	}
+	if (folio_ref_count(folio) == folio_expected_ref_count(folio) + 1 +
+	    folio_may_be_lru_cached(folio))
+		lru_cache_drain_for_folio(folio, 1, NULL);
 
 	/*
 	 * Racy check if we can split the page, before unmap_folio() will
@@ -4325,6 +4328,9 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
+	if (folio_ref_count(folio) == folio_expected_ref_count(folio) + 1 +
+	    folio_may_be_lru_cached(folio))
+		lru_cache_drain_for_folio(folio, 1, NULL);
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
@@ -4805,6 +4811,10 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 			goto next;
 
 		total++;
+
+		if (folio_ref_count(folio) == folio_expected_ref_count(folio) +
+		    folio_may_be_lru_cached(folio))
+			lru_cache_drain_for_folio(folio, 0, NULL);
 		/*
 		 * For folios with private, split_huge_page_to_list_to_order()
 		 * will try to drop it before split and then check if the folio
-- 
2.34.1


