Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6ACCCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEED58E000B; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EFB8E0011; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906E88E000B; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE448E000E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23A724A767
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
X-FDA: 84062853966.17.154A52B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 878842000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p55R7JFT;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gacXftrQmgQtpWH4iog5qmDwK/yt8m74MBRyNqAwylw=;
	b=byzxL3EjfPjPm8yDrJKK1M0xkdOBOhL3k9Cxd7zi0D8jd/xcPV+q6cpwOuRDteVk8JFWlK
	g5fh4FOnCyvHkSqQ25vlDjpAlyKPn9rFZ/Bm22FjYuPOv4T9+dXtTNdzMSPKlMqwq2OmF/
	2ey2o35gVs6DC6SIoKoRoFkaS70HtVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021241; a=rsa-sha256;
	cv=none;
	b=gs8JFIrqheE3Ac/RSCPd+UV7O24cVYXKGwR3uhGze+9N6w/0l38+7V2tA28ZerZIhw2Zug
	HO5BYrw0MN3WKLgBc1kFfvdebrNdTxfypOhqw5tp8iVL4DsYUk3lswpMBQwc2EW2xe7zmi
	mNc1GztSKahDkXur9YKlVVX+/JnqpJI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p55R7JFT;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FEF640ACA;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109F6C113D0;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021240;
	bh=aL/KESmFEPfvW+PugHkjq38nxTmwTmF3JMfeWbPs6P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p55R7JFTxkg/I9BBaVkwXTv2pes8Vjux58YMHOKp3lMhyu7/gdCsDsR1qfujtGGO/
	 463oNbe4vlLVpBLDse+CTlABK1OKgjJQH4w0hpj5rts961V61Ed3u/JSleneL/UmwB
	 7d0FO0j67wS83+q/hyeveCIZ7nfdWVRBCV5OLnPG5kC86fx+tv46AG97vK1o3yfBeV
	 RYfNa7CpCyVo+jp0fPhzUYx/OYWh4+OmC83YU6M1tr76KithJk1Gf306JjqCbOwh0/
	 T8RzYxGEtD2y7JfX1UQQB29Ey3EOSdntbcZ7k2FBeXs2tU8K2OeqPYhufJGUcCjBWw
	 iNk+Yq9qZbQ2A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 6 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/22] mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()
Date: Sat,  1 Nov 2025 11:20:07 -0700
Message-ID: <20251101182021.74868-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: adpjgiy5tsb4s3yfptkbi9j9yp49qxim
X-Rspam-User: 
X-Rspamd-Queue-Id: 878842000D
X-HE-Tag: 1762021241-622016
X-HE-Meta: U2FsdGVkX1+2vZtFeP+w2CXNncAffFSlZCFjiXQ/8QIKrk76o08DVBo1TX3x5ZxXqkMfYU3Hoxtm6MuDONwSlUG388Gv7YytRFOFArRMNgkHNrmIdmtoNxTxgKrmbp3R7Hc2uSxfU8dfxrsoh4cUfSHUP3ZDgRMDJjtjb0kXZMk6nQ4MxmDYsBCfuRaPiTZwq7aHuoWJPwpwezWIxplpFbf2zeVdL+2epekjt5dlX3MyI3Jb/pn9ltfoegr64+gMHTqHlHAc28e4hiXBGGtbps2UjXmtsa21zGasCbi8MUWE6mZWrWgSR20Vma3Za2d9ORfM257BcNpbZhSJ44knFewyh9AH5pTcgQzG1oZfxaKKAP6Cw7Sv6v/8i1yWMiaHAToVyi6y+V6qRfkmWuTgKn1WdLy4WDrMnypInkpu63WNB8iT40OGV3kD5wx2v3/TkLQouesgFsXt+g9fo9pjYosO73jnTnUOBUP1fyCOtGr9AQR8GsES4u4OCEMKf7snzb5Uut7SZ32Zk6aib0irztqquQtmUhn1KnIRkLWB7Sqm8PvHTi4V1j30XKvqP3eOz93NLIaDeWyHK8nvzdhFEivh19Cc1yPM2zJ3Yatt8o8zy2nRbR6x/iT97IWuo57pDiWGzRn6vSuNAqg2p3J3KhYpU5VK8+WDVf/D4mlVcsUkehmK1hHgDmzNYd3IUpYFToHS92LCAKZEuaZFl+jPrHhvuYOmrZ0DPJz54To5b+pYpXrGLm0jMMt1UvtyZyD7SGRApoxD4/CpJyR1G8TwxvncBnJVtle0U7/GaaOXVtnOVVsj7fJBL3Z8PtUPIQWP64EBS1nxYKePJjtO1xCqS0YBVZK69Ew3uCxsm59Gbi7u1bOU0BalRU5o+IoF+f7GZtTt0JrvGXrzGoC5hTVSSKL87lvsG7Ck3UMx2aHFwVZL4cQbVaFbvzVx29etq3SIS0bvm8O9AsvDDiHUIRC
 yaS6cR52
 CgBTOAuU9JqDVtFVfgtgSwWzG0FmrJeHLuRmD/0rqS34xzPWQhCDWMkwOZ9fMdfR4HFFZ+KV0z3bHLEZXxVRdbuWbOLrg7U0wTPTLQQlpi5fPN5pGq+4lyXQu4vbeYEtkdhvSgj9pbhQfMoZZPflKOHlip7wWzE/5Weop/cg5nC+22OaGqTk7KVDbEML2xRIZu9O/ArpVUS6khmZKxOa8nQtKhg3duMfpFQ7a1X5V5blAB/i1GvlviY2poc7kTIVTPL0p0UW77kfHyUuh5MLDdoQrW1WjgMvYILoD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_new_filter() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 2a158e956b98 ("mm/damon/core-test: add a test for damos_new_filter()")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index b9bd69a57e62..03c7ac31db5c 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -505,6 +505,8 @@ static void damos_test_new_filter(struct kunit *test)
 	struct damos_filter *filter;
 
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
+	if (!filter)
+		kunit_skip(test, "filter alloc fail");
 	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
 	KUNIT_EXPECT_EQ(test, filter->matching, true);
 	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);
-- 
2.47.3

