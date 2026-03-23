Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BD4FC72CA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AEC6B008A; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4FA6B0096; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5ACA6B0099; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A17F06B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66C75160CF2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:46 +0000 (UTC)
X-FDA: 84578887092.03.9220D23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD3EE1A0010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ng1A37Hw;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=5uKRb1BOumZ0Fs3e5kRFdGqJuHbv86kqO2xifgXn6poJhpcY2rt75Z/UiVW56YcYjLhrtA
	FXx4TcEaUXV7tWFiiSIDrzbypD2G2LBZMq6R+AWI71GbxZpr3JR9sU2iQLh/X6XeitDzre
	DD3tpfBRLQuSZqjxE8o6numE7MKFohU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ng1A37Hw;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307744; a=rsa-sha256;
	cv=none;
	b=XIS0zm0oJTkUrnh5degdWf3DEeVlJKF+0wveEMC/OkoTSIv4NKqfnSyxcKvcMWAT5xyyZp
	HQnt3wDRbbMyQkte8zGGJmz86d0YU21gK/BO20XK2TZl3Hwp0+b7g2ffIStGW3ykuHOpXw
	XMVKnUFMQ494zxbQlVkzH5qrjFvu4Gw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ED756013A;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB4C2BCC6;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307744;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ng1A37Hw6bMYCKJXyLwyQeLILYH5OKdhZtWcrCtlsYIRiJ7U2bKjT9GeIwk66n4XQ
	 of51gtUsdXBfQxFf6V2zKTjgXeht8N/2fnGithcDYPZspea1z3sXPnMnXpm8Q1HP9U
	 VfrZES1lXNQ2uaJtJPkAQ5THrItnE55+2xHp5RSBiUfIoHMIQcqwUY2hEzRztbjgof
	 9d+/tP9qMPZObt65NZeT02xfRCnX6MDqkT3Fq3eUrYp83aGNFktHY13g1CouT/7g2K
	 0F7F2bWfnnIz9KCg8sMuQwarbq+XVeU6hzTwFwT36Vh7Gf0YBtCcDrWhOHqzwaZTdQ
	 QA35PR9uRBEbg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Mon, 23 Mar 2026 16:15:31 -0700
Message-ID: <20260323231538.84452-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD3EE1A0010
X-Stat-Signature: ripmw441zkq35jbruxrb5gx1yiehfyba
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774307744-587737
X-HE-Meta: U2FsdGVkX19nQZdH/Zun9mWqUgDASP8lT1u8xN4sFrzuEtfdRGcp/CjdYTcRYyDA1KwP/5lwDvzpNOAxxFrsTAKguPkb32BEjqWiq02p1L/VVA572dE41DTbs+x9oppbKd/29etiF9TRp9p6wBEXPIpldtDNDXz7H3KANcPfWNkPDrmLuebZ1HcTaFxyLu5S5DkyE31SfIi/M5vpJV5pTnq8TPOJK/qg3i8yHQP1Y5I6zBr9tCQNZivEi+vcDVh2C07I01Cg1S5lo21GLXXxSkzVib4amcNpZ6nzTZx2ZFOmImrPJh5bSXZfo2xqLp2ZmEw8Ej05u681Co2kwv6h0HcbN/3QfK6IcorhVOIaa/GioZSwdVpL9PxU/3XF57YhZhyVyQqzfFTgFYGPyuOilcoRvReIUF1gpNp50IpSh/a9C4PDZRWtiLsCpnJmcdto8fTF3Yph2A3m/vKhgy5FgY4C2+5wj5POgFAqEfs6vTG9drXfvOs34eDaZ31eEbgGJury6esIzDvY5lW/680UUqnDOZVb5Y7RU7DBP82FJBV2ff2p/wAu3xq9fAN/hf5K8AnO1g60t+GpQU8oAarsVRr08LUHKYirJL0Z4EAfk3TO1vLpzgsQtOegneN5mg8EL6v+AQaPlmYTRseOrKrsNnN0pFx/hYLobL0PE/42fgqEM4U6Qd3409A+FMaRnZ3uQPwwNAvxbz7ABw/qbCzfrofS1V1Sar0kACfanlAAgBOIFdCys9+5baQ2F8vmXdtkbA+37fk8VDjAfylnUngHZhv1UryltZ2VX6qV4yNRizsidrevfuxGMO/YD4Ne/tr05T8/t6Mods2bzVaMwzKHSqWqmA/AQhZk3RCLfkUBBMRv4Th4BNvYRJ7CioZWTMBUJ86i0caOBGgWtuWs0DiRllawRvOJHkiZGDIyO2EHXzGlTv9ZDaEpyP1QJyWeEP97+fCygUI7vj0gSUhhZ/B
 IIyTdvHc
 7QTzf6ehI/wYVI8rEBmAdSNpaRaYBpOCMZlkMXs2m2JGZOZiIg20S6x3j40M66fD4/+ea8qLyapBTSYgn3bikQ2Zw6en6A0JQCilnp7vIYRaFjbwxbKOGsqRXf1+TvnmHbWi5uHDVrRMhHO7edHKJtOJV4TEohb5kIo9WJcWWAVviqvQyF76MW8mZzG+KkVx5Td6TQna5TsFh7rNpF7EiNVtPNk+uVrqd8UIkzxeY0grVg5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for commitment of damon_ctx->pause parameter that can
be done using damon_commit_ctx().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb2..0030f682b23b7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1077,6 +1077,10 @@ static void damon_test_commit_ctx(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
 	src->min_region_sz = 4095;
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	src->min_region_sz = 4096;
+	src->pause = true;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	KUNIT_EXPECT_TRUE(test, dst->pause);
 	damon_destroy_ctx(src);
 	damon_destroy_ctx(dst);
 }
-- 
2.47.3

