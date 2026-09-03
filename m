Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEFAC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 22:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34766B0088; Thu,  3 Sep 2026 18:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5BD6B008A; Thu,  3 Sep 2026 18:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD47C6B008C; Thu,  3 Sep 2026 18:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0426B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:25:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04AF180640
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:25:17 +0000 (UTC)
X-FDA: 85173883116.19.6E43386
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D54C14000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:25:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S32d/KSY";
	spf=pass (imf09.hostedemail.com: domain of handyhandyman.adam@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=handyhandyman.adam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788474316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dtFnDKCreodGov5AKdOQxevoRQVqgWybZUxL28h1qP8=;
	b=N6qQ7+HBm3MmDb9krsa8pwVkUDZaHXHYOhsQE70in45QXHYImZpysvKXGkisUwd1eMajU5
	QFRTqaHVk08ac2BBQUKeoSumycBFblpIcQMJ12Ma8nKhcYZ9fm7LI1Cp9ianCHW12AZhut
	DcyJAiYA/hneU/1SRcTHrSNdzs/O1E4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788474316;
	b=sWEmh949PbtwinoK8+QaoFep4lNf2A3HG2XdelRFOIHCNYW7WNHIn+u43a7T8f+NhJfpoo
	9Ba4qZNsIh6BpLPgtIlpYIiNKevmKaUD9Vqj+NnZoQVqUi4vENWycg0fuooqgt5BpXRb7u
	kJWtTzcRkQjbhgNMMG8tPIe/8JS3a8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S32d/KSY";
	spf=pass (imf09.hostedemail.com: domain of handyhandyman.adam@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=handyhandyman.adam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e6b5737bb2so409869a34.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 15:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788474315; x=1789079115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dtFnDKCreodGov5AKdOQxevoRQVqgWybZUxL28h1qP8=;
        b=S32d/KSY9QFxKizPHDMhe63Nx8Uga7iL7DNI3yl1ktoPc/q0071imQYEkr/nvqf+I1
         fuVD0yqHOjWSaYiUhVilw3R9OxZduMcmsKUvLvcIxgoHQRUTFNFCo/W2delSD/Pu4iGn
         R0+DkSP61ASrhpsyiu5rnZtmu/GJu5d9LDhnV5hIoFJQ8sTBD/uxQV+yZDvStUeLwjnu
         orJr0ZwbE+F17M83fnb/hCtjBn2g5DH62Rpu71v3hFTbQ8qMZ1HSJdVNRcwLvphRDlJV
         oJllVSIuIr9jEuELMat/4+/T7gMPno/4yLxu3Si7BtSYw7bBshMGCLFq1BOhemGzL5yK
         xZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788474315; x=1789079115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dtFnDKCreodGov5AKdOQxevoRQVqgWybZUxL28h1qP8=;
        b=MwqKM8nthiJSHAXYq97tp7eGbIim+DUoG8UCD2KxxF3pj6c2yGlfSRIHkiN55S00A+
         P6jTJvlquropMe107tvClhu4rn/njRNHS903jjSeV5IypJHb2i9V0wpWxY6p1mgQiJ84
         GGTjLwgBsoEBiZJrziZXsZiUFheM9zLB0V9n731yEd/tmNkJime0dVshgIlEdGFh6P3E
         68QiN4OjJqpNYUhoSJwR6kLdICIlRxnHWk8Vq4nRU6o5veccDM/vQ6fgs3FQDDzXFYQQ
         d2bHPqPeBTSith7QurcrzHJW0/dhrA8FxuT5C2bP7duuTwHvGqQw1KdANn8zrLW0OYgZ
         Vt9g==
X-Forwarded-Encrypted: i=1; AKwUvBxEMmRbz54oMHrHl3WGxYUp3kkY8y7RlPwHKeidcXC0CZEqW43O0xxAsDSSm7ctiG1zAzhj6Ds/dQ==@kvack.org
X-Gm-Message-State: AFuF++kZC6nox4jQNRTbsTm/gGpdQc8frTj5EPxvIbz9xXnQy2cHQRNe
	svrhZriVJhZEUrePAFzAG3UZc2Eq8JDeAnnTOYd9qOAyEbKMimdDCEM=
X-Gm-Gg: AYBFou0gaUaGpiCSwi9pFmH9jik4Gi0T5QMou4ZoHtgTr81ja2wmCQiXbz2zk/WaAtP
	Mhhz2JlWQLj0LowE2ZVrH+JJgMBbWHFJd1vz6FqJ0zlyCsw3CLv0jvSoMABJF9z9l+cbm2nJYh4
	M2YUtTqVHBey7N1/fTMEnK4H4XJv4vROCHryqL+tZ73IhD2oErrFtjkHVlpEpu0eCk66tWm0r3w
	0uw7HTuElcPJro+r2HWt+twlcDzZQTZwpAw5Pv7ZIZwoNG+3dWNjJYQtJA9LFEx5lCG7Kgx+BSL
	baMW3hnIq04SAScK7EiBdKzjR1gtS6hrzwnQU6pGFjwVETTdYv6LwJ3IKkg/QoDU6qSSxLHHPsu
	JxHx1s6/kM5mrXLxNXVwfkS3fN6omQi0NFxDDUHO7YfrZy8ZzomGpz9PiVmD6JoBEEP1DhKTmPT
	fM4asQTX3VMOmoDZxaYSPFonAquuCIEV83kkOZD7CpCvYbi4Pmt45AG3M68C0K56YK/IM5mCLYC
	n2Id1mg2s0/KSK2
X-Received: by 2002:a05:6830:6385:b0:7f4:daae:401d with SMTP id 46e09a7af769-7fa1e7d967cmr1737779a34.8.1788474315101;
        Thu, 03 Sep 2026 15:25:15 -0700 (PDT)
Received: from localhost-live.home.local ([209.73.104.88])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f6793f5fsm1417581a34.8.2026.09.03.15.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:25:14 -0700 (PDT)
From: Adam Harshbarger <handyhandyman.adam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: I Hsin Cheng <richard120310@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] lib/plist: fix plist_requeue() corrupting order in the last bucket
Date: Thu,  3 Sep 2026 17:24:56 -0500
Message-ID: <20260903222456.1881786-1-handyhandyman.adam@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D54C14000C
X-Stat-Signature: y749yzyryfsao1subfj55eqs1p3hk3dy
X-HE-Tag: 1788474316-337743
X-HE-Meta: U2FsdGVkX1+Oef2UtiTwGr5cAAdWQGQvTOXUoww8Gq8xmK20RxLbGSfmfT7+YDGg1OYNGONnWyrKq8njsvjeUC+YNWSNGaCwtoyR+sPcvxah7Lkqlb/XANa9WORa3gaV0dfN0iK1NCaeko58LBziU9N4tIpZPYN9/s80i/ENHVyn6cMjXAjUBppG2wGwlhARXQtOekQb8Ky21NGTwEuRdivq7oY+mA8wx2gIva2Rn/NXan2rxE8piZtZ/+RDPqXIJVTRYvTgr6SPsR1tpTvkzlH+awjB/S9CO8qXr7xTfC3xoEhVx2TB8pm+/6tSbEto8ynElHQoC2nCg2VrAgSt+/Nn9cQBd8heTHtDBC09aSGRi7RbQviWSgUNRf4aThu8Q01vjdts2VsZxu6oe1T6yn6jMclQw3ulo1M6PlGxKd0MihKg72zev9W8y6nPtkzluO4Od2Hz79AUqv7/nwa8TSPZkoexATkCE3krVbim93En6hpQV0I1owsOhivhKHVBJeSBsTDnP4DzLXBKzf15Csw4zX69w9KeFahI2EtnYpKGa81kjyTCzcs1Lrka4cHwAOCdo5ZykgqSAxqY+4umCXpdO7HxFHVDQw3tTSzkTzDl1c5ylUPTitbY7OMjSffJ9BaaH939HymVPd//RVc+4k/UyXrW3U54w04aNqzYJwx1ZGSWD60a4hwM6B2EKAbAZGQMJiFpRdqzI3+ISS1L77glVtjSnHBp6I1BeyKdv7LtQp1xaF6vMFOaUlNFn/gRYq6lmX6aHvKHqGPYDs9uNJJ16qjjrPzNhUu3g8VeCRU4/4d6K10SCQkDi234OofWYzfYLBFhqzE26UcQtixc5mXQvRpH4T0L12jsX8O+G/4sk+vc+j/ROY0YZOpLZNfNOCFPgPeac+TB+o535SrZBubd7sEvsEg+cYovBN9rp2XxrAYu4PfCXeLhMtwEg3KYCTChrOAc3fmq/uRWlfH
 KVSZ/Q8V
 Ko1T1lCb5OsbrnOjlPfImIOlBauyPNgn6/pj7TqhwG04YTU/v5907vATAoRECFtS3JR2A1cA7QTjEbMPuR/32WqGuQ9YKKkq48cMk1IRvi3JLekZNAD3L1h8+jbHnPgFV6jUJdHtfOh/f3ca0kRx2CgcyHR+uWBET7YDKU0R9MQRfuI/kzI+mVne5CVbOHXXI9/UuEoRHQ8kdTps7nmU5zLsN80DzpX+AQ1Xq+6WF2ZIZ2xDxFPmvAzsUy/BEzZ/GenH1RMlmPHiRT7DSTPppTQtY/JDW3GURPdQBepO5wRiumKuOLURMXr3naofa8fe4Odqsx0K9NbUsxPqkL8In4qgOBwQqGVB2b8TvxCbVXhaXN5ntZFAgy42V8ohtq/yyWFvMQ3FfO0xbXo3MCNnekfCKqe1ktGtsywkf2eABnD7lPhjt/Fm5xqrS4sMEJTY9YVSgsbtjs2xGfOEpeoZaHML03iBXMy0f3UaaDAy9JO62HmTyG89QdLJOsrIXOK4BJCp5gVNvc9/GyqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

plist_requeue() is meant to move a node to the end of its own priority
run.  When the node heads the *last* priority bucket it is instead placed
at the head of the whole list, leaving the plist unsorted:

  built:      A(prio 0) B(prio 1) C(prio 1)
  requeue(B): B(prio 1) A(prio 0) C(prio 1)
  expected:   A(prio 0) C(prio 1) B(prio 1)

prio_list is a *headless* circular ring of the nodes that lead each
priority bucket.  The shortcut added by commit 95d4b3450ebe ("lib/plist.c:
add shortcut for plist_requeue()") takes

	iter = list_entry(iter->prio_list.next, struct plist_node,
			  prio_list);
	node_next = &iter->node_list;

which from the last bucket wraps round to the *first* bucket, so
node_next ends up pointing at the head of the list rather than at its
end.  The plist_for_each_continue() loop immediately below it computes
the correct answer (&head->node_list) for that case.

With any bucket after it the shortcut is correct, which is why this went
unnoticed: the benchmark in that commit measured elapsed time and never
checked the resulting order.

Keep the shortcut -- it is a real win -- but exclude the case where
iter's bucket is the last one, which is exactly when its ring successor
is the first bucket again.

Reachable from mm/swapfile.c, which rotates swap_avail_heads[] with
plist_requeue().  It takes three or more swap devices: at least two
distinct priorities, so that a later bucket exists for the ring to wrap
round from, and two or more devices sharing the lowest priority, so that
plist_requeue() does not return early.  One device per priority returns
early at the node->prio != iter->prio test.  A single priority is also
safe, but for a different reason worth stating: with one bucket no node
is ever linked onto prio_list at all -- plist_add() skips it for the
first node and for every node whose predecessor shares its priority --
so list_empty(&iter->prio_list) holds and the shortcut is never entered.

Tested by driving three implementations -- the pre-95d4b3450ebe code,
current mainline, and this patch -- through 1,084,492 identical random
add/del/requeue operations over 24 nodes and 1..5 distinct priorities,
comparing the resulting node_list node for node after every operation:

  variant             differs from pre-95d4b3450ebe  left list unsorted
  pre-95d4b3450ebe    -- (reference)                                  0
  mainline                                  289,297             276,660
  this patch                                      0                   0

Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
Cc: stable@vger.kernel.org # v6.15+
Assisted-by: Claude:claude-opus-5
Signed-off-by: Adam Harshbarger <handyhandyman.adam@gmail.com>
---
The bug was found and this fix was written with the assistance of a large
language model, per Documentation/process/coding-assistants.rst.  The
Signed-off-by is mine and the DCO certification is mine.

What was and was not done, per that document's step 8:

  Verified: the bug reproduces against lib/plist.c taken from torvalds/master
  at the time of writing.  Three variants -- the pre-95d4b3450ebe code,
  current mainline, and this patch -- were driven through 1,084,492 identical
  random add/del/requeue operations over 24 nodes and 1..5 distinct
  priorities, comparing node_list node for node after every operation.  The
  patched variant matches the pre-shortcut reference exactly and never leaves
  the list unsorted.  checkpatch.pl --strict reports 0 errors, 0 warnings,
  0 checks.

  NOT done: this was verified in userspace only.  The patch has not been
  compiled into a kernel and has not been booted, and no swap configuration
  was exercised on real hardware -- the reachability argument via
  mm/swapfile.c is from reading the code, not from observing a stall.  If you
  would like the userspace reproducer it is available on request; it fetches
  lib/plist.c from your tree at run time and vendors nothing.

  An alternative patch reverting 95d4b3450ebe outright is available if you
  would prefer that for stable.

 lib/plist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/plist.c b/lib/plist.c
index a5bef38..b027353 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -174,8 +174,15 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
 	/*
 	 * After plist_del(), iter is the replacement of the node.  If the node
 	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 *
+	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
+	 * round to the first one; in that case node_next is the list head.
 	 */
 	if (!list_empty(&iter->prio_list)) {
+		struct plist_node *first = plist_first(head);
+
+		if (iter->prio_list.next == &first->prio_list)
+			goto queue;
 		iter = list_entry(iter->prio_list.next, struct plist_node,
 				  prio_list);
 		node_next = &iter->node_list;

