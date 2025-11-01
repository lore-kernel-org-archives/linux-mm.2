Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CBFCCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671308E0013; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBB08E0011; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B9B8E0013; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4D88E0012
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFF8412BB94
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
X-FDA: 84062853966.20.1E6ED5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76DB5140005
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWBnC0IS;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7P7QDWOc6AagHAoW9cQ73mzw1i/V9oG1P3I0AOD1UA=;
	b=itlVoPCiHOrkj17FOBUNDEWqFgw1FVgBssy5rzD551k4c5rCl4IGRVICwORVhi1zBbCJue
	v5bsGX4utzpT//n9jjxDZcjTW73O1yerAX1nzCUwZWxHvXvAXQHJ2+gqawsWRnXjLBSWQW
	RNhMUHSypAGIak7jOCRQO4fNNJwDkvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021242; a=rsa-sha256;
	cv=none;
	b=r3XSyY2ApP++uahk+gU45fVm9hx7YW6VzzWhnmdkWngXcgKJt/YQmMGUlOy+x+y2KQhHtg
	h7LU7ZrmF4OeZPb+0VFliWjd2h9Yv2naI0hbbzzasUlAEO21dPXPGXSuvmNjV4r9heuVVX
	PgHsUPsuq/QNXA9a50TB4mGLYwMDfBA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWBnC0IS;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC465601EF;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A9CC19422;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021241;
	bh=rTI/a9CS5rBMyRZ+VKSmerz3wZX4dc/X6jh4k0lkn/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWBnC0ISE0B1RTenw+hmlIwbxoWWP1X0IWWsO8ttUS+7VTzsHuapAIIN103WKdPEd
	 v/qrdO11LEOa1TK55su6gBeYsPG9OtP+PcINpY8h7PT1YJ6uV/LSPvjMpyNB9ElR/o
	 bBTaRMOEf39uh6OR7qUy7csJcHryjca23v+pxfj2vbZ4bil7yvN2kPzGVCauAcEy5U
	 RbNdvzY10Nla27CkGcssDBB6shJtbHx4sszd1VTAE0bskQHWAORyYHKNGuUGKtgleB
	 bbsja4C5YAhRUXzrFLvrCcmXsBSkypaW0Ii407YasC8hA88pFsCbzYNv7vtyFu9WqQ
	 AKC2B35af2Gmw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/22] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
Date: Sat,  1 Nov 2025 11:20:11 -0700
Message-ID: <20251101182021.74868-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: opzgy8jedgwj4tpe4kia5hbmhpdr1gec
X-Rspam-User: 
X-Rspamd-Queue-Id: 76DB5140005
X-HE-Tag: 1762021242-807213
X-HE-Meta: U2FsdGVkX193Jc8gia8TyuGej7j7CW6grgKufW/f3lfVWCDDwcqAXq1octPVqIOL5CTzlqJwhPG1y++sEyQJd4kbTqYO3+DuTvwfhON46OV4MvVtqOcjWG6N3pcV4JNz26oA1qGs1wOFaqE3fvJjgnCtzz9RL+az+5+JZGnt50UmPktxXL59KuHx35uQl/v25RaLOrqvrs3XQ8EIbIdqXBkWpHFdZAwHOzO/dlMNW9Hctc7+NJSVsQUHlUOauHo0bMU6ceNDRFnW1lBtiIQWBGWr/He5TURw2xKLeTXxgQn6rOhdU6SWvJdbMql9ar/a7KiCSd+ZZRULki/wfdGovemKfSgStsZYrDLRO4AyyKPuMNzEgzROgfhA3LQAKQbq3+Vaxzl+SBVSejiQgOpaKtz0RhHNFPhB4xhEwIcQhQxc3/NylyUqy5XBHXW0jW/f0KMRXMHc0U8RzjMx4+5oUzHpoQK+1Vw8Afpjhhk1DfPx3O3uNmQyghjm+VMJrdzz/Nvr8vCUpytACoO5kWB68wivLbih5bA2D0emdjYjR0IZdk8E+jwNSLPlk7TxpJfO43xPYKysda22omDLQmqUmkuCDv/I/3kbgHWFCDEEYHhWMy2GNngI938BTZLnBsTWN8rktfjS2RxHmw/4iUw33rwsMe1oIkGn9G20XcB21/eT8R4CFGzTbbtHYKlajPv4vb8h+q6i4CERhizwdSZN1DXYqG0TNWdqAeRsqaUlP/YEjl3XIBojucw6ZR0mvPYpUMecgNt1IoiPhUsRjF/GGVPOG7XEUVFXAOh+9+IhQ7pccmsP+xiojlRJE4+EIc4OotYCwX2DaZ9huC030njcS7KinnZuhR8hU2P/sOR2bhLGODSA4Ex4HGjQRoBKSuD58oTXwRV1ekv0O2zHaDqSJNsPpId0VLVZqqB2wfeXXVcix2oArcLZAxnH4GZunx+c3W/N9+gkY0BmFrwL0T9
 h3ttcaCg
 DwJROXzI7aYJC5ThVpNnedCYmvxGQC3RovyRNq3rT19D46N0YH8gcFj0vWrlGlRMuZTcxUWmqvFXu6C/yxY8h5Y0maeFEwOhpnFWOVWIHYeBz2ppGdspIdECmVfniLv3Q32IC3F9I6A7E5O2do/NOYcH6Jj0pOrFgg+Hm4CgVgqTwdNRyGmcw9R2AsjIVSnvF5PFBoXsuqHyiaBdUoA0Qd2yFBQ5KEEutAYQLIZZqnQ2hmcQB1PN8XxJElQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_do_test_apply_three_regions() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index fce38dd53cf8..484223f19545 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -136,8 +136,14 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < nr_regions / 2; i++) {
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
+		if (!r) {
+			damon_destroy_target(t, NULL);
+			kunit_skip(test, "region alloc fail");
+		}
 		damon_add_region(r, t);
 	}
 
-- 
2.47.3

