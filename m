Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69B2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506F86B00D1; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7A36B00D4; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380646B00D2; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F026B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73CAB8DD36
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
X-FDA: 84958527444.30.21E2EAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D1FE740013
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmTaSjlS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	b=43jkGeGsBq6TA7MF3zJS4Bao8/p4ag1MFpbrb/pr3BaQuRDeCEdttBxhxNz2PsXKqgD6l5
	rTZHyTq6Vb4oGVidmcwoDpduTnZAov9Gbov+WOU05W4BDFHoDF4EBv4aPNbQFcVfN4G+Xk
	xW/tWHrMG+EjP6v8Lwg46e1Q2mi7zXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZmTaSjlS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346800;
	b=0h4YIocovvasH6MwAS8k0OfSkM1Dw7thXKKcPOQ5nRcLhRwel9JNKritIzz8LD7s11KIn9
	0qJsf9FEzYzxAsa8k4CHILCK+bTH9KC4YQL5gjCA8HWaKygvWCASjsKlRVyklecSy6AYD4
	dNIJw3Dvw3nIaQ/BLz+vhiwpfbcOv7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEA95439E8;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD681F000E9;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346799;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmTaSjlSkck3iwEj9gVhrXicm+CzO9c1+gq57cboB9Ajg0W51Uf3h5owdMfar2Een
	 WOYIrjkcbGNC328qPCH664pe+E6ekkiWWQJs9dvTDSkf5Us26DOzKc4RhzIIDFnbxc
	 TW1TFqHIFn9hBdcE2hQR6PcDBqceZ+vo8DlI7lS4hqmKQ143JGP0+bBNw8xuEAA7aT
	 nk+GTzqEvQ3pbqGGXpQzdQoR9wVZVx2266sYuayl+dTTyJt4xwW5P0XJvMKh5q/DBU
	 timar1zT08KGl2y5qS61Cp+JPb21i/9qt5AfMsDA3V2xF2H17ZwUF7EjS66h6z6V0K
	 M0v9b7ajjXV4Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/11] mm/damon/reclaaim: ignore damon_stop() return value
Date: Mon,  6 Jul 2026 07:06:20 -0700
Message-ID: <20260706140628.87414-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1FE740013
X-Stat-Signature: 1k91ekf1xnk1tspezx5be7kmp4w436r5
X-HE-Tag: 1783346800-357316
X-HE-Meta: U2FsdGVkX1/9yjRukVlgTNf17yw1mMKLYjFoz2s5O8p4wZE4aOoHNl54j3zm9Z6/+RTODsPidm+hsSJ7tBoFw0CBE8mIonmrjNXeI3+T9Khwsy9PovP3WK6XHmZr8OPsqYftUcHB+OR1JdA5zSPaSn6D1bBUPk2EtMRkZVXvRs1noS6yCOhxGsueZAN1rjiAqjUeel492gtWr0n2fhi0E1uSUO1Jy96Yv8PETv3xOGKI4yMQ348eu4wHWP9BYqgIpi6IgUMxm9zGbQjo/ARadLWuM1D/O38LTIFO/SqN8i7EmooXNFRlmQlzE7hNzhVzOB8g4ldnu6jYvteksa0FPvBzT+Bl6pMzYpZdj5mNpMEWk01bJkwY5bG6kWlglqdTbqCjIl+ioFrnMb7ZyxEsTyjgq0gfIdazjGgJslfOB2kM6wpQAASxDIY6G9eTg3jXu/jvmDmxJsHLkrkEBcnvcGgKPOaczrGNhf/yuMYFpxUFyKDLhNxc96/vobrrwgtDYgx2TGHu+f+eQdFwaZEcTx94q0FnMGha6+dpnXbXNAGyOUWjtmJLSXrWgGnGd9PkoDzZblsn8HQdnoj4M5xpb8YLbCRWQu5lgJoDmFlT7nIQgunDQ2wuYdHdxiF0i7cIlgIB9tXgTXTvCiyDDXnFgdqZSZ4v3jR8WqFRfsXqEDNn038TVYWxPOFMJHZrOw+KJZfF6oCbLO3N2P46/42CEJL0UuarecVKQqRohdEG4+asu/YczU0ZZVRgyyb4dJSTqO2Lo/1/b1IsdmC16eHa3Petq+IJaz8hfDFZ6V+zrQtzKShXzl63hhColWIPlZ2ZlRXajIvNj10VgkhRq5HOfhKN0/5z8zVvmcyKlnih7oQAKq+K5tyLpMJg3ujgOzW+oaDy+sUAgaxfojM+FpkD/10OQOrsK2IINtipgpC12P/6MpKlYWOOfFvMPDyKv+ZLJE6eWervyMfbB6go3LJ
 UI9ZQY0q
 rNvXCZLWlS3eigPFyXZ7vUGGp49kRhuFH8UUgCJr4gllQLSiaXEkS0wbetLwDkjGOH/RuHdE+gF1/KYTty6nafloOuEYSAKULxht0IG6nwQ6HAmb6b8uuZjg1NWvQcQacad0xC5Uxw+J3oPr7g8HfYN2TmVYCJz9KhVMQDlWREIOeSgmdC8tUb9Z7WhHkmEvxwX/T6CvUSVlLpK5r7gZHVa/ohYryHPvwHLGItQ4S8+Xz1DwWzp/x7xCbzT6CikIPqjf7jbGdwMLk4FH0z4oyS7YDmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 6469b25cc34f9..09e941d75f67d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -332,8 +332,10 @@ static int damon_reclaim_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
-- 
2.47.3

