Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E71FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2046B0093; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835B06B0096; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5739F6B0099; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 350BA6B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E602512025B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
X-FDA: 84705117336.09.7F7B134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DCED710000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JaU0rWeJ;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313226;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1V2rnpHIA80GCbN80UY3IGw20c1NJHMmTQOBHLNXjo=;
	b=EVMOMLVW2ROlcHZ3k1PxJFixkImoC44I0mFGYQYwW/MFthHMzwIktXaDZIUSKZcS13ePpV
	OtU2FpRcCWNUPa0JM0orZe52jUMH8SBIYIfjF0iTdXav31+q/ce6GblQeazYYsdHBwUsdQ
	3+ntjG5uJliGtHzrQoEybyL3ktt4do0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JaU0rWeJ;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313226; a=rsa-sha256;
	cv=none;
	b=frzw7M4Q5REWWX91GTEaXCe0gRaYi80XiCPj2pTlIiTMzzvQDAk/ehqPKKhZ5+Yup6RkIU
	Ig7a/90wOz6XKNRMrnYEIBaOvGBntq1/SApidbtXFU6EMgjvr34D0yUD3k69WGQ8SQWQUz
	JfZDoqPuPh+BMvMk96Lbs6ywEILha5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5920761334;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60160C4DDE6;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=mfCiqor+VVrtAxYwGEGeUEVf/Pi3BKvbjBUnqOQUaPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JaU0rWeJHka/nwMu5j7tPyoiBOJQqs7PHa1ZQwXmorpqFBI/tGgJ/FE50pnT6wju9
	 1zXmb2S0bYAatmAG1NmBNHW+PCUjXswebhSBM/rsmR3RLtnQhhvd2q/1DqanhbS97C
	 sEoK+Vw7zvvGnZvUA/+H7D3xIT8tRePCPkmMfJbwleUWNxRVTiyjY+rAc2l3V7Og2e
	 1/Of3SC27Cn7wkwR+u6tM9lkdY9x2IivbckeKOSnw+3dHBxWPxW9BNw+S0gqfk64JS
	 PrwwLdgky837ZUg/c7B9rbatIJjq9r1bwixSrthptJK0EVWe7NA4HVFt20tqFclVMp
	 M71MNYJAkjt3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543ADFF8868;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:01 +0800
Subject: [PATCH v7 10/15] mm/mglru: use the common routine for
 dirty/writeback reactivation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-10-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=3255;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XRKrUmNoX/1BhqYmqpem5sAID4oP2CHmPQ5jLKoIQdw=;
 b=+HxbLcfJ19SoORyG4Y2OLPDeNrxicgrtnsrc/6FJCgoKX2cLEPX61RNMFPk5HJmQvkHrBNbSr
 u4v9lgVufb7Aek6O+dUkL62DzBR3aENw2GgiNw8QbH0UDfCAUqpgJtM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCED710000B
X-Stat-Signature: rzsug8gaitg9g9odmqjd7mutptt5c9y5
X-HE-Tag: 1777313226-783673
X-HE-Meta: U2FsdGVkX1+K4GPW6PoAz5rYJWncMtBVOju/jlrn+gL0r5dsRHs6fm702vio7JQi3O02zY+vnrP1GKmj31zdzBkl9NY9/rGHDM2P9WL25acXCEu1bNdh4LgofKKybJYiQsBxWKRgoAHmmB3UX+ziKckUOdgnR32ZjiYDQRVNGhme4G+9cxzFBRcqddl/SwAkMw+ssp1xueLDbD52tv9ZiG2Hyd13YjGZ8wNaSAuT5m/d9nqNx2NarjkNUsS7dOLf8TkmaCEaaAa03+IGBUdN5NOBiK+mBN4W9/H6zIfTl5vsu7bKubyO69uQrGgNC0BthAyNUy0mEGIyQOSsLaHbVxOuIWWBGP/6QFeOqHWqgMc+LKJ+0Jht71hylLRRsdkEh/Nyktb4fF1pqVHJyEg3jwborbHzS66+4dCk6rhm06L4GbAEiMCK4l9UOpLnINrRqABDgEvo7t4KesFZMQ3brhBaUd8UdU2fYNUu45y927Mq9OkZlVeMIpEeVHAFkKFApAyWdqs8vOeBLXs6DnYDT73ANHeXv9CYFjfVbj57Av3YarDuaxscwrdXHKCLJx2uMIjgL0PSgKIGcQAcDrJBLMvc4ZXNZZxmvGtRP2s/4al03zPk5vz+ZY34fEZdFxPtmxVVWG1YNJ1dqvXEjtGFMATeu62vPg+QPhLoVGzsSsunVoRshAMMg/q7sdWD6d1XfJK5HvGZUfS2NoAxXylbhwWDJOg+wso+JaOwzB0tyuSCzRbXZpwXlVbgdg6U0GfOuXRrv4zJG5A2UVoqPR7Sj6rBbAVN49em415EtK/tTHy4nSGhoKkHitCsaTh7BzzGlU/p5s3/Oq2ceqOzAuZB8dyRhHI34rbWav6Ut+QvxoXUfuoCW8Wm/MGdqN80EXx0XVmxGXn2cFUmdGJJKeQTmNCmMVjJZ7x/PiejWVkN9a+hhEc2FX/OJ8+x/jjRq7I9htlz4AHF/1YHeWMjEe9
 vXfQ5Umu
 h2GqIgJwWWuMT/fcsGcAxncKNAVzH/Fkg5ESdh3uVuR+wyXrCiDtDxw8cMF9RFHAPnfwfOXEEm88buwb8POJZu+fGGGdgHDBbnM/qRf3pGzrOgtL7oo9z3zdcfbWs0Su7uZknayx2PFxkNU5/mQgFWQS7rApNG5QOpUmuiVvfBaRzwV/ZP8NsRCdS2uJCuW/1iPMtV/WNTxF0IjSLqhvHShHcLrpWQh/bI11cL56crC6diZkWTgshNuZ8iNGu1B/z2xKNqAivEwTbJwITj3yHI+7bbe+t/5qFDPM2YE9euBx8w8T0N2W4LhOsSWtkbdn2YieMyqf4gRaLtnmJu65NMeCe/yia98aKVLqOdL12Zh4xVmDinG1+L00EkQVSu/Dmns6Ngma3QnS0KzaVzK+shq96LPSbcAsQ6KZ+qLe5nMKDXbYGXeGQcOTPNroCvS8zQNc8dqzzO0ptQMrdhC+rIr3LO6YrxmV+0/8CMgBe0T4gHSfGdpU7KlJ15e/i/5eLo8EU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU will move the dirty writeback folios to the second oldest
gen instead of reactivate them like the classical LRU.  This might help to
reduce the LRU contention as it skipped the isolation.  But as a result we
will see these folios at the LRU tail more frequently leading to
inefficient reclaim.

Besides, the dirty / writeback check after isolation in shrink_folio_list
is more accurate and covers more cases.  So instead, just drop the special
handling for dirty writeback, use the common routine and re-activate it
like the classical LRU.

This should in theory improve the scan efficiency.  These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion.  And now each reclaim loop will have a higher success
rate.  This also prepares for unifying the writeback and throttling
mechanism with classical LRU, we keep these folios far from tail so
detecting the tail batch will have a similar pattern with classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine.  Compared to IO and writeback
cost, the isolation overhead is trivial.

And using the common routine also keeps the folio's referenced bits (tier
bits), which could improve metrics in the long term.  Also no more need to
clean reclaim bit as the common routine will make use of it.

Note the common routine updates a few throttling and writeback counters,
which are not used, and never have been for the MGLRU case.  We will start
making use of these in later commits.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ea86297b604c..bb7e2cecf48e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4578,7 +4578,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4664,9 +4648,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 

-- 
2.54.0



