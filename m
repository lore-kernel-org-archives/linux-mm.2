Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5337CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7F78E0019; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF958E0015; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7A28E0018; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D24C78E0016
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AF87140375
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:44 +0000 (UTC)
X-FDA: 84062854008.22.5618FB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EE5414000F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dd5Ed5BV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z16cqNT6GYsghEzlETVl7KVDTNk4c9xSne1h4N0ymDM=;
	b=tOnu9xWVwF9iI19LgoXU98PPQKH1YT0S9pEaC42Vg78s0wiWeI3NoTb9rkTDTLPjKR7rBC
	nVRXqF1zrSiQ8SepEW67+8sPXPbdhyv9kjLsXGykzmUqJ1VeDCJghdelEb0+lvp4L0tY4D
	Z493XJiO6IXQC6dGFTdPNsIMDn4NEPY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dd5Ed5BV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021243; a=rsa-sha256;
	cv=none;
	b=8jwPJ3BvHGjkGoOmrr9OKd8fv3AK9UpME1FUmoNtCHcXDC6Bgr1gbtNxNavJ+nTsRiAZjZ
	9Sw7ofnBzUEa1MpATil0Sk8eE5Ia7/KxNRJT4Mt6w2xACh17owIcyYhWUgH5SiYqE4iwiE
	d4uiyomCEG3gjOKplnW7zZd9ChzNX+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FF4F4405C;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B07C113D0;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021241;
	bh=dn7Te6QsD/vqr21yqQqDCBMBy4CNhY/OvT08906eNi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd5Ed5BVesnLrVSQvAtYBMZfXXw32oZl1EOX5c3pKiV3gC7DlIlyUGCM58LPxLqam
	 NWGqb58KNK4zc3zJPipj+r6qXsyPwLvRNLAYpvpXFlV7OCkQ/vysBBcMzhptz2dkem
	 UXZOYypCXYYyuCx4tJyJHI7EI98sSFYWnPMtJvH/URMGgwKtMXjMus8cEXk40LEy0H
	 A9AA2U7idxN3Duzxc0GhiI3JaTZNtqcx/b4FGJMDwnys85e/N6IYgDepoqf8xdC56A
	 Sgls6IeIucaNB6roBKnKHeaCc8uG6JfjEsQziDoiGiCqe1XmtrLHRdq/le0K6LorwT
	 sGAGvw+0CqNAg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/22] mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()
Date: Sat,  1 Nov 2025 11:20:10 -0700
Message-ID: <20251101182021.74868-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE5414000F
X-Rspamd-Server: rspam03
X-Stat-Signature: r7b974boeiqj7fagaew5djstu4esixoy
X-HE-Tag: 1762021242-677862
X-HE-Meta: U2FsdGVkX19xK0biVXv7oAJEqM0+hxrNJH192NaRS9PxwGQR9sRHIBvKV4SY5lGMv/la6txNDZctgRPwyLxd1ueRoObCZlSKOPexvhp3ekSyhxm5zZMUqzdLbMaf00i9gudpH3vSa2+7Ie5MGexUJDbBP3TOzDg8sAyV720bJNCNn/lNTBUj8wPkq64e3HhSvRfas2PTsqP7SekKBX7/00km4hshA9jlQxTH6Y7UF2dBY1bFs6SytoQ4ke+Cug4mcJMMP/GfkDH30P835uXYxdk1ItCGu0MrGQRxxaH9aED70w5lJGduMjcx4DT2ej9TnZyE/QpooTtwSBMQqsXhjt1lc/TRLzrVr3HOFcdt5mI+RgIQTLjtiXTfIINSx5l2U1KeYakQ05irzfv8X/Vqcr8Tir8chkzCe5UOqLZkWDw4HaFsfP06cbM1aHX3hDMc3X1zsRJHfdzG3BRobklVHqjrkh/alvNZUEei0d6rfmfK4LL/4KM0TMkAuUAEOoIRzikMafxBrFxxmD8ob0NiXQtVQBf2KoJN8xdJ4eAHdZH4pgn7LnQi5O5JU3tAVJWJsr/EJsBepJBSIxi4B1oHfiljojugxeE9oXgFV1QQWNu7vOH+ZHpIcRha9eyJfZxMvSQO4z0zsnwQe9pSIoXdBAJpCeJOWPE1BNZsMzh5zKMM2HP/ex6pjnv0Z/+eEKtll4s9/mr+0Olw5bRNyvSRebazvoktk1H/BMPI7zO0yLW5HgKFE0Yoy1vpG8EyvwYDSLAdYKL4plM0imVoBrsPhZ7fAd1jPU9zhU+e9gvt3JH4ygZ5Wof5vwJmsOrA7xWDjoLgV0on3ueCWMgnW1NAWmcEbf6U4zSdmVQHe43vp1bx5OrbWoIo4GIwx9Vk2disH/qfiwNAmPCB8Eh9122guvWpTM5ZAHi0eLty4DOr1whSSLq9r58qTXW3LMes07xHnn3ibIhkohZxwmEMR3F
 8NjHj/P/
 3HwUJpODtih9vIOe4U4A+u3Tvw5csm65JU480zsnU/jQlFe5WeJycuxHWewG2xNwTBpFSAhXWm9cw/GMIWMKehu5LVKLViZlsozoZq/7FNGyiArErv/jKU3t4JJdL+yTMGnej/gbBjiLTxisNSgWMRaNpE3cA3Mjr12LDCt0Z2DCYpX821yWQCvv7ugj0BosLfDk3cd5CFARraP/pmRsX7W/afjuchGFAnxrhrQuT7gQXpy3JImFtVvHTTQp8mBzI2CMO1LkP0T3WU1mG/A3yXtGgv5pc8LUPxmCq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_filters_default_reject() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a03ae9ddd88a..a91d798caa70 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -659,6 +659,8 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	target_filter = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	if (!target_filter)
+		kunit_skip(test, "filter alloc fail");
 	damos_add_filter(&scheme, target_filter);
 	damos_set_filters_default_reject(&scheme);
 	/*
@@ -684,6 +686,10 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	anon_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	if (!anon_filter) {
+		damos_free_filter(target_filter);
+		kunit_skip(test, "anon_filter alloc fail");
+	}
 	damos_add_filter(&scheme, anon_filter);
 
 	damos_set_filters_default_reject(&scheme);
-- 
2.47.3

