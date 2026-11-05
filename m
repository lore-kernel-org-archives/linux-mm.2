Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51853606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNDQeP7f
Received: by kanga.kvack.org (Postfix)
	id 5C0C76B05B3; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580956B05BB; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338F16B05B8; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA6836B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 875F61C429E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:46 +0000 (UTC)
X-FDA: 85399824972.28.FD72B28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3552920005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNDQeP7f;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91rtiUe/bcG4k5Xjc7nZyZOJQYuQ+APASrUv58d3YCo=;
	b=pt4NjXyX9CZBO/TP8WYHsD0u5IZZcNIV4Oi0BXJTNveTfI0tfJw+wi2jTDKovWXgUsDNvM
	uULEEKqDBYjFvBJWGurb6ZWc0KRlCbf4sUNWQBh6Jubh26om3UxMYecCyD39fE6kA4tEhy
	K6FbNyhhaWr98weL4RPVLisycq0Z14E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNDQeP7f;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853885;
	b=JixTwaexBXa21vvTlCKvyklHcBuPvF3PN97/DsuQC/YoD2RLvCcW0ttCYx1J/Kc5oj4NgF
	sGX5bjpiedb9WEAYEi3C+oEwUC7vUNE37Sb3O57rRhG7QCiAg2CM6Iu/CoBnx6iZQ1PnkR
	08vn8EX/Bi3ZJgtEOwQvtpGz04ESyZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FB45439F1;
	Thu,  5 Nov 2026 04:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EC81F00A15;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853884;
	bh=91rtiUe/bcG4k5Xjc7nZyZOJQYuQ+APASrUv58d3YCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNDQeP7fFkkIn1uN0pJ1N0tE3fxgJcOYDJzvCmWM4EnaCSgAyUlOi/Eld719LQ1iy
	 25SqhIwrtOqdGcPpejzqSnuY1aeMsTvQ60lRBsxbZhRs5y0YHo3Uo2JY8xR3vWHkoD
	 yb6bEoBWYPkJPrNU/AOae/bbK0SAOhllxeDzsmIMulIDpUWWPU1+2fpI9qLhpktAxw
	 B9by1ghtewDcjxEX/BtNQD5s0zr9Lz7hvOBQ4nfMHIpqqG9bU/zbpwm4RHOo6nON80
	 +oy9AtCrol82Wlx6KVKm52hRLE6h//bBaAuZRHcJlqGlinqtR73KqWHp8tEfFqFftM
	 Rs5qxbAeQZ9jQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/4] Docs/mm/damon/design: update for age_ms damos core filter type
Date: Wed,  4 Nov 2026 20:44:23 -0800
Message-ID: <20261105044425.87142-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105044425.87142-1-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ds5u6progqroe4mcdyzpi46ehi7tnuwc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3552920005
X-HE-Tag: 1793853886-518115
X-HE-Meta: U2FsdGVkX1/hsEilMLrEoFwt2Il5Op1xdQnFlFrLaVAJiO6hazx3BWtBy5pc4SD6tQxC4x7cmdpVZRQXKK0JbwpuD9lCSGHxGVch7PL7ULPFmxjMld8kn2SoKd2c+zU9i+XcrdKzUNaIjTktLwtBSfrenDIdtr2QFPPM1fyR2lGBAo8o5JnYVOYV1U9Jmsv3k1bS7DnZiBj5ZWCR0MY+W69s7WUabQ55EFOXw/BmPT0rAwjpHrU82FIUJHzFCDYyeYs43M6BO+Z3urfUUl2sWnTursY9+hHzL06bJs5CpNZRCAdWWk/hOU7EYei/SxzgmOU+UdU+WWTJu9j10zd27qEedjgt2FMofFGWB18tFMVL8hnjU1T4HnU3AmGKtbfcLfYTrdsLihhI3rxg1motkA/E7PhqkNxhNa3TRUiIuQURj8pMlrQCzhs7nlUm/k/kxfAiNNwtHnD0guRBl1YuDGTUSBucmbFqxqn19cTVkQQQatOgfTyeEITOTwKpiL1LK5R/qFl1HS6v9uALWyCAWoq5ZE3Z6FZta9fDfLVLvrG9MoKsAlWcjNy2htqtKn4R/N6yUxIOFCotfMT0ZdxMgtzk10WRu9UQ0hdpddD6CTiLtBPTs8xGMZwitLJ/kbr+mYQ2mOdjKaiTKeyuvMmpRmOyI7sfciDzX3XU7mCJ1Zqikm2lGAdDeJ5oaMbA3CHHGsGR014HEWaPoQAb+ZZ1QU4UxdIlv2hiCVhkGRG+/5SZ/44xMct4Xl6guOtshHwHvnROv5/ZYz5SaxV2MNrBJ5LUMABoq6S/4T35claYT8woYO7qXcTKfHwl90boL9v+KpN9EB8lYCebwY8chEFu49pOdH2qcqkJsxbrDyKg7U70qyXJUUJh/dZ3enjivjSjKAk7NtKqseQhroQEyOFmiU4DzeyHqUo7/zOZFWzokXpxOMU8nYAezcS5uzTzesl8EbXRMfQWavYvcI9roPD
 ibkb8zu2
 +LYUE2m3oeOzFLW9WDYifTj8Til+zinsEmqte+Yy++HHwn5xU9VjA4bkZRGjPI09FFGy22gr6P2gkU4xWtmt5sceh68iggPO+q3O2q/iuwrpQ7Fj6A7E1Pfe+1IhLfTrfNGxU+V1ZmXfPrLD4i8moIVWFItJxCrGVJvS8Vzc9N4Y0W5xZEwD8cxeL6Aa/Di4tSy6xvkboh15miiEdeN9KktvfN+4i92aLBw4gMApxQUyjbggx5+mhYZp5UT6H06lsqfCdPMTuNUQ0vV57FIIiOwWftuszQygCR1W+abJOAfw+6aLLfZn9kVzzXE7L/qrogrv5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added age_ms DAMOS core
filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0689fd48446dc..8440c4954090e 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -838,6 +838,9 @@ Below ``type`` of filters are currently supported.
     - probe_hits_wsum
         - Matches to monitoring regions having a given range of :ref:`probe
           hits weighted sum <damon_design_attrs_only_monitoring>` value.
+    - age_ms
+        - Matces to monitoring regions having a given range of :ref:`age
+          <damon_design_age_tracking>` value in milliseconds.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that contain data that are not stored in files.
-- 
2.47.3

