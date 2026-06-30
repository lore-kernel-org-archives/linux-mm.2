Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136A2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455386B00B6; Tue, 30 Jun 2026 06:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF1A6B00B8; Tue, 30 Jun 2026 06:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6BE6B00B9; Tue, 30 Jun 2026 06:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA2DE6B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CE2F1403A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:47 +0000 (UTC)
X-FDA: 84936265974.21.CC8A771
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8F465180009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGNFYGn4;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816765;
	b=MB7AwyQlJ9uqbJzz5j6OgAfcS4rRjMndBWPWcCa1mTgxt0eCrZ+Pb8QvHZpTyBThB84HQk
	cB3mfhDx5WBeYpzr47g4tShNsNcTc4RJ7lR5mwvSqmJXNmszpyxzF+25hPFLCGD7x2kwfb
	RYRUX9BPEMeEoZhjCGMdY6st8vKMcgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hwd078SfSbWqZ8yo3wjpm66Fjg9WDFy+fTRvcAm+UkM=;
	b=AeHzbD4jRZhWxU/VOsjtNhSSREAywiz0PwEhZoRJXPVWYmYMFmd7QEx+IVVuVjJZ+H9GMm
	v1UZTLpdtIUQiDXqyP1flMszxt9E1c+jvN13RefXCTmDYQHcVQsEUejr9S/YH3xhpWAath
	R7Pv+zA8HjsLA9AfKGwIzuWjS3dLdlc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGNFYGn4;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4ADB43F0C;
	Tue, 30 Jun 2026 10:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254991F000E9;
	Tue, 30 Jun 2026 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816764;
	bh=Hwd078SfSbWqZ8yo3wjpm66Fjg9WDFy+fTRvcAm+UkM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RGNFYGn4CtkTg1zqvbtwpm2QX2akkhLXZUldJcQh/wY6BJIcZyWcOuEOJYmNcq5Lj
	 Uj6Bh+yCkzkhs31qbnmwB/PtXdrbvnMqxlvi6wknmB/78qy1R/PukrrJGqmOB69yGp
	 Iedr10mzuTFMWuNNp+qNCDQiG7xROGfltWMA1ONZfMbFYa0qXUFzGxqjRCfwFEP6z7
	 vh4O3pxi/BJb0+UedVdyG6n1f4hyrZzKDVL+WNrdwRrlRNF0r6evBD/7tKTdhNwzMF
	 RJ8vOKlRXWraalDy2C6grQ5T2M1hKnbvVmrkDw6wWipuGgJ8dcKGY7we8g6o5YZhgo
	 Kudt8R1xEuw7w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:33 +0300
Subject: [PATCH 5/5] IB/rdmavt: use kzalloc() to allocate QPN-map pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-5-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F465180009
X-Stat-Signature: puqade4thumgujeprkpdryin9xp7azst
X-HE-Tag: 1782816765-683610
X-HE-Meta: U2FsdGVkX1/a4LAFBx0ckNCr7qHaA/v1wPLoPwC2Y8IZ/Ps9oezL5jkSsxkIKO8UI1jdnAp/HT7wSKI4Nhlt+URreXsD5eh8h0U1FvSk/UgcnkbZc3JrO96wIwkCUOiudTCfAlTQQBn5IT+pdhy0wAq2qFgQgzk15QdcAJ90+ryTo57UbFFGsXn7CsM50ED0af6Pwq2TVYMa2+iBR4xhrNI2xwHHdd65OiCEGwDloghvy0PKvU7vu0tWXqZQMlAjsxjjxk5ycoBlaBPEwtGqayEH4hsGhptocCeeYX9nHFd4i4cyUD8VBhMOJnrtGct+HbHbsymWsp7mUUhHsT+/6RFez3Are09e2AjfeziB+Xez5cuKuy44znmhFvzFW382Q6wswxHMnMd8bBDJgkJcmO1h38h1FuAO1DkKIr9CGm+n8uVJeMFTlP8Yw1FxG5Rkegm9ZamTewjz45Hz0cCig7Cl6PSfDsaxLgbxlB4JveMRL/P5qWt5XKYwwopU82ZR1qP8Ew7hMMkxTphj+0MrX4YvczyZBtQ5/X/NXIGDDT8sDN7JCutJDdwT6Cb/LKy3ipfsAigb15NBmEbGimUYrkXZJGr8uFhfULS/9JRhTOAZadTO1y5V5WhHt3gBd1FyuGig26JDEL6QzBPNNRl7ELgmgp4kk5aSy/nsGYNv/B83mv9HY4WljZDTZulR5DRj4Wtvr004n4s4B63tIX/2BfIgYmKiPQIiT5XuV8vvzI32Nbu41Pjp1MnOt+ceq2pQ8zZdz4MZZG4WAWB7bmIxniSGW5Bbpnr2mfQm+pQ9UzUCB2M+q2LyARBes8FKx7f8bnTzpdNsooXHJRhdJgKrxFVb8Su8Cc9c8jm0VnIp74mCO4HDYZOT6wMOdgYoU6ZN2IaRe+weMN1iERBOwKfhqqp6T0iDn/y0aVZAWH7VkcgmkFPicDUuhGq7iPhZzwWybb0FCQdoso9oM0xWDgu
 owTQfuv7
 8I7UNMwXO/YUANCzOUjXKw0wtCa3D5oIB8T3BQoUJuqewpGBKcsl2qVP95oXnDh7h9hT8hz/tGMlEpitR3XWlV96jKysE3qIfLNLIJS1K46PNHVhbsFA9YTDVa0kYGZJ/jYwnjxPF1DP3Zb+CSUtsLnqe0J7vw6wOFjqQIu+1jSSHCB4o7ZG3BHoEljLz/H2RLUyBsCFVjOVb+8vUE2Z4YhEQ2jKlGxlceN+iRZu/JCICf6OnpN0+arOdvfi4hbhPELDfLsZadqAsTJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_map_page() allocates bitmap pages using get_zeroed_page().

The bitmaps can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 70e7d08fdce6..c40cce69e945 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -263,7 +263,7 @@ static inline bool wss_exceeds_threshold(struct rvt_wss *wss)
 static void get_map_page(struct rvt_qpn_table *qpt,
 			 struct rvt_qpn_map *map)
 {
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	/*
 	 * Free the page if someone raced with us installing it.
@@ -271,9 +271,9 @@ static void get_map_page(struct rvt_qpn_table *qpt,
 
 	spin_lock(&qpt->lock);
 	if (map->page)
-		free_page(page);
+		kfree(page);
 	else
-		map->page = (void *)page;
+		map->page = page;
 	spin_unlock(&qpt->lock);
 }
 
@@ -343,7 +343,7 @@ static void free_qpn_table(struct rvt_qpn_table *qpt)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
-		free_page((unsigned long)qpt->map[i].page);
+		kfree(qpt->map[i].page);
 }
 
 /**

-- 
2.53.0


