Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DEC3C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C3C6B0096; Mon, 28 Sep 2026 04:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8232F6B0098; Mon, 28 Sep 2026 04:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761266B0099; Mon, 28 Sep 2026 04:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF046B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:48:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8D801A0135
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:23 +0000 (UTC)
X-FDA: 85262544486.13.048CF1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57634160006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHumC8vX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NBdiz7HaIMQ0kv1HYgvd7Hd/nQ/wzhey31vNxMDWYvY=;
	b=uLfi5Y0Iajgta4FYGky77dvcY2axLeL715+huO7aKc6V0dWPOdl6mY+2tjM9mJgdhjOjy3
	5VEwWK+Q4dUF94sfby0x3xuvjEpFHLtghwhRWGrjdw9ubM9JJrkxEaHkW3VaZmKwVSILFx
	+lee/VFUCYSozloH40Dv4pBIKuDVJiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585302;
	b=Kz2YqQ0evol8U8xgtTIl63XhWFrR7im4S/U28vVXhZfQ+4z2YAvlSt26S6Ee9OBt1VLAHp
	U2jAPKfDZmhdo9KBHD9e23g7GO/2GHDlFJdBoYtcVYuAqrUSWJHCUuxOSySiNnEF9X87wd
	jWUdH8iPz2CHsp3CTeD316YKiEEm7vo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHumC8vX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F90B411A9;
	Mon, 28 Sep 2026 08:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E21F000FF;
	Mon, 28 Sep 2026 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585301;
	bh=NBdiz7HaIMQ0kv1HYgvd7Hd/nQ/wzhey31vNxMDWYvY=;
	h=From:To:Cc:Subject:Date;
	b=ZHumC8vXAhibmcN/uapBiw/qdKiYPrCEPDB59apHbTjT1y4+gdEUwpI0g/KuA/TX/
	 8nP6OHJNlHhwI4O9/fg69dqQyLa5cgfawO19hUkbhOrYFQn910zW7/KcFIhIVhDFSt
	 QgI7nvhie651Okgyb58Hg/LV0zXyzubmkSAXhWmFO8Y/5ocJn3HwTfud4+G7nsG5Xh
	 tPlzeyrWbXjXtksnFY2M5eIOG6BIdG3eR1bVR6l3WUfIz9CIIlk0/zrrA5JXHFihiI
	 sVNNxy3rs9d1eD+Sdu1nkWOuVvGOCVHzhE45A5A289T2yW4Pe6A4595QhorQdrrQeK
	 NWJWvJF281HxQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Mon, 28 Sep 2026 01:48:13 -0700
Message-ID: <20260928084816.5575-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57634160006
X-Stat-Signature: jeq7hh83oosqgmkq8zqe1a7ewtp4rki8
X-Rspam-User: 
X-HE-Tag: 1790585302-595504
X-HE-Meta: U2FsdGVkX1+NYIdol4eCPz+eFk37fUqurGS94I2uND09wCaBzs3R6EkAqy80eAXoF5dOIvr2m49VzujXcIJMzPK/4HLUlVNsVC7a8xNSkiVHmgEU3dTvuV1gUWy7Spr1fokVF1MGZDhHVSnllVrAUFVjmv+4a/RF+fYe93Wolv0Hr6R++J/VOV9GxpnLvkyT2m+OEFNIe1OZHMw6vM8KXEJnwWTLJA2+gVYg+0pLB+kB2ODO/8z06R6ajIs97LBV8ic4Ei8eAXxY+MHYUbJ+tJtPB1N+QxfcqOjtjfttQiw2xgryUeBjAhNj5t08fE26jGw02467fNtpDlGoCrlGUPDrOStE7mTETnIgENuSaKeG4HCTPBhtweB/Op0R+GLSdxy//E1fSDSziWP50C7CPFtOrZy7MXWYg5N65/VavbY7rnIhBWF+GjBr6OL8rU9Mi9UjnV2SYO64o+7t9JFPPY9eQFVtwMKXA9diLrKGmcQQKf1GcQMdfbFST2gEAbfU1nlOaqncceB1dcjb68IISmYKv2nAK2jE+vQFSIBUQfyUwhF4SWid7aoKY+fcwfxS+0Ri7DvHQECG5lavHdInwAu/+/f5IAGXpDEZAaq5zQSweqAEZX2JdwwL3wVoq+XzdQmO9oalVQxiQ0Wm8eMZwYIwHAKz1u/uJIv8wvExr5h/okzBPtlbl3RVOp+S7aHRteyEJZyH8k0UkeDlD74AIZhIh8CBJJ3/wzmFSwcsM2wTLqRVJXKjDXL7HYmILJ6uw0513oTZ7RLI6iNjgbinPODWxobxbYZa+Ty2otd3s+t1TGIR8Js8GaYNeIYOlTLpabKAvAnW4oOReC7b5OL2KhUwsbOMM6H4jJ6YTyuaN1fevyN3CdAtlEcrbVchfF58xgGXAtU+CtqFCcLyqYzY0Kp+V2wtvCbhlaTJZEtazLLGL4aUYwwrHcIunHPXscOXTIpmgsW8N52GkhE5h10
 NwnUYnKb
 dNY2gydF8O4NtzUo8AOxBeTRaAwUmeKY7vXjcE2L08gtJgfzgr9o0TzNz3cLtqIfV+50E8ppes1OrtVblxi5QaV0cFHTNiH9xSKcUhazDFfjmnL8JhHam10mK+1ja98irhYdN16YqM4SfNsH8EUZRsifnyCHsZEjeeiGXwJwTaJtM4Wbza78P4+IZ4Su1lAJGRK9J3KWSHIz8oEdGBP6Wneo1jBiPbufmcCIu5xCBcoUolCRO2TXjudeiX/1LBuzd0Uo3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and
the multiply that gets it there is unchecked.  On 32-bit it wraps above
429496 bytes, and a wrapped product below 10000 divides to a zero
effective quota.  damos_quota_is_full() is then true on the first test
of every charge window, so the scheme makes no progress for as long as
the goal is unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
kunit suite, where the new test would fail without patch 1 on any word
size.

Changes in v5
- v4: https://lore.kernel.org/20260923002600.1825448-1-donggeunyoo.kernel@gmail.com
- Collec R-b: from SJ for patch 1.
- Rebase to the latest mm-new.
Changes in v4, from SJ Park's review of v2; the code is unchanged:
- patch 1: drop the 256 MiB mention
- patch 1: say what the user sees before saying the setup is unlikely
- patch 1: cut the closing paragraph to "Bound the multiply."
- patch 2: unchanged, and carries the Reviewed-by
v3: https://lore.kernel.org/damon/20260920122411.610213-1-donggeunyoo.kernel@gmail.com/
v2: https://lore.kernel.org/damon/20260920023111.2466265-1-donggeunyoo.kernel@gmail.com/

v3 was posted before the discussion on v2 had finished.  My mistake;
this version was held until the thread settled.

DAMON kunit on x86_64: 39 tests, all passing with both patches; 38
passing and damos_test_esz_goal_temporal failing with patch 2 alone.

Donggeun Yoo (2):
  mm/damon/core: prevent size quota overflow in the temporal goal tuner
  mm/damon/tests/core-kunit: test the temporal tuner's size quota
    conversion

 mm/damon/core.c             |  2 +-
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)


base-commit: 2fbc36fcb37d79b22b904066065952050a7ea307
-- 
2.47.3

