Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDE71088E7E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2449F6B03EC; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221706B03ED; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1122B6B03EF; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1C126B03ED
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9817B1C21C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:12 +0000 (UTC)
X-FDA: 84561666504.03.E9B564F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05B01A0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgLxCuk9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=xFDFxKP5k2r6vz4Q08OgADZZ7gwRWlI8aSL0ib5u9JOFQ4UuvdSNmxkuL4A1eBrJyz+y06
	ptCybbES46T4SQe4FXyGJJmZ1CwJiIfzojICGCram+QcwEj2O/GZtWaD/BJxJ0dUQv8Dz0
	h/QgWH8x9cIrBQR9CwB9/Vos9OAyQKo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897731; a=rsa-sha256;
	cv=none;
	b=QuO/zPE98OLlROKwv3jiXSD/JICj5EOTfEoTfLnBOUo680yAlv51hhG6iYVz5OifIZKL7+
	a40O/28ql5mK6IlISJV7Lw/ss2werZko/29PlpZMrNN44CZJE4gRls2FRsRS5I7xZ4gCFv
	8Uqih9Y+t0g+KkJ4xwZXbQRisrB/YQE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgLxCuk9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB36944722;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB54BC2BC9E;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897728;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgLxCuk91/AfmruwTg8iwYOcOr7M5FuG8Vnd6YLTo08UqUEKMb5tuFkxeWxOwILJB
	 hAy9NibPiGesX0iPpBBAmVubQFPJ1Y0s1tNO8NpzP5tLDTm5XI3Ed9k6vZ9jq/DB9B
	 Ug5vf7clHmxTNk8qDI+Ov7UY/T83TmVRp8OJWBxCs+vqNzCfZ6zN+GRHMBszydy0/1
	 lSz+/SEpD1mhK3iSM10/7ukQseSehDtJ53dlZXVxTJHn63pie68h4c6jYaIA5Wi/ZB
	 yDntw1hMgeeDjnQ0rtJ7YIsblivjAotOanGSAT7Cc2vkw2e0/MZ6plm1D1llz2sOvC
	 PYxotwruumhgA==
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
Subject: [RFC PATCH v2 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Wed, 18 Mar 2026 22:21:49 -0700
Message-ID: <20260319052157.99433-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05B01A0005
X-Stat-Signature: r3eop95jbeq15eahfujqaign4i6h3pp3
X-Rspam-User: 
X-HE-Tag: 1773897730-372076
X-HE-Meta: U2FsdGVkX1+WxUtuwXVfZJ5b5Si8dIheMSmWDFte6BaljuMwmGJXfXSfqt3sTkPKvJkNL5ytxGdwGwJv+PX4GGUMyQlL6+11DfDSPWK/szEsBCPYrhKGcXaCxX2fVQpDdBsKEoQyPiWSBhtgNMzgpEiX+BjfkVSn7oD/8Digj9RNHYsvAw6St5hCIMd/wymnsoBp9zE2Soe2+EAUfeqw58J/wy6R1RQHnyyIsz7VlfWrq3cL2bMNOwyO0KBNXLzuENoVc9JYd7x/LO5sCTT8KVH/enHuMMKGOpZyp/V8vlgBrYZzrPCkGd86ZcXBExTFSw0cC3W7Rvwqyixx0EZBDFtz5G6a540SycpG0IJuDxN7vyeuajSuuZ1VbNup5rY5ALIXS7VGA2+P1gGgNi2cSlxSgbl9QWcZ6E5GJB+SVCfsJzzLsHGiNbxp4NeSHEgraD3hNl3ysXeWwNE4N0HO0UUdmcU5gEuH/g7iWgRld7/jxYQ1QLCEdOCPEdymdIarJUkmwCMzQDJc929vqGwyPv2qcCdKe/pJL8Ho0bK3BdVwwOtkcfHtRGxKzY5NagS5Ec5gnEXR1SlifY8RWb2J9f52hAmVYXVt9SAiityeQs0iV3k3JWQu2qXxVP5vviv00Tvxvy0D/C6uh3oGuP0urNL264vHncJ8XEFqpfgRfA93DMHp8q8ybFxVKkTrNX+VjoV4UBk1Smrn8c9Ey3ibYV9fKvKLmrElH6XLLxR3Xj6UnvmJm2Vxmkrq2z9YnXUm+fyaLR6pI5KdZYvO5BbZARmyt8/ZJ5KQokk6g8HatRCxmbwYZwIB6lsBi8cx6FBc3qp0rsJejwuINk/3YPTe9vrLSL4klILOpua6cNwsUwJM05ugv33hS+FsTVmyWSdSZgAF6YvXoUrKzzquKAjSlIMFi9gY+IZCJdGP/Oiiq/mApaY0riwyI8ninrqeruT52JC7cX6fCX/SC+j9GiB
 np2qTE1T
 sEg+azfxwyVEs+/RW0YPvdtLpN3wdliD5mDwKgYL5/XhkCBjWLmFN1RnpKSRNx5vVhDCjmVWrd7vKo7m2en2TaXVwWUrTFkFCT1XgmtDa01bhmVVamIBCqaVqbsMzk2dYxz6Szkq/2bqaCnl8MG1Co4Q0+u3QW0V/dyKJbRzqc+pNaT4DXQZYAoaSyIlGv8WAPQk0ABvweKHWGO6H9/ksKgIvHhYSMtDPnwiaz5hx8Pc7Ico=
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

