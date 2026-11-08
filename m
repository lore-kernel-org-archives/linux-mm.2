Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA003606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNRuJY05
Received: by kanga.kvack.org (Postfix)
	id F3B936B05B1; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11796B05B2; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00B46B05B3; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE0596B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E1621404C3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:26 +0000 (UTC)
X-FDA: 85412907972.04.F17B4A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id ABC55C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNRuJY05;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kafHwu6q55LG1XprWuU0JCx4heKZt+x43kKCH82bMRw=;
	b=u4uXeeHaoZD19eum3P6Xp3Lcnz8+LSbmyycN6hWriyEjJRBOmOx4+mpQBEnq3wCFhYMtLj
	RZMWHol4itf/cgwC/BH58U7b2CqPpZCkO3f70+DebHI2cYfQzUBT5rhwMdtqOb6nwIQo7v
	YQDYYgLaDvptE9olCOS82DMx2KAFnMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165384;
	b=4dNl78lB3I/WsNrImMT5YlULCehRkNUVaOxzq8qwIlQi6zgyNixdIpT8JjjmrdWnsd2ziI
	PUsXt85JI/629Ef5D+0UZYufXmqOP5nR0jJ+/fNSArzy6B73chvWSLhCqSUwE49B+C/urA
	7vdeyj+o8huVyZDdnAy6Vu+lyB0FYZQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNRuJY05;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A35F643A9D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6801D1F008A2;
	Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165383;
	bh=kafHwu6q55LG1XprWuU0JCx4heKZt+x43kKCH82bMRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNRuJY05Khbnu6awMwIH8DQxPOvF7hltgBdnzqfCPDwjAuw/+YR2We/qbQPiKk2wI
	 w2XYdYDTjQtv7zNCnhrYw1vkUtoCb3YrDnpHO4F44oljuLkkCNF+lmJ2Af0+gxWpXT
	 6vWMdhiyEOM40eNyIDcv9EdgqUyv9C1cZREheNOXQW0Gr8KblCpY29G5J7mY9ANEHc
	 7DQETo4d5eStxj9bW8ZgyRK+eKIzl8h/wak/fZ1LeagjAGXNYmw+dMBMBXnzyIxi+A
	 eitvdeRw1Kxfrfzvaimj22YwyLGOFTOvMpBRpRfJUeb31Hie5J2j/OwOCPE+fCZS57
	 0JOMNge7Q2Bug==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
Date: Sun,  8 Nov 2026 11:16:11 -0800
Message-ID: <20261108191615.113362-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108191615.113362-1-sj@kernel.org>
References: <20261108191615.113362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kug38tss6xu7cg6z6tu9fzdr8ca6jnno
X-Rspamd-Queue-Id: ABC55C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794165384-177687
X-HE-Meta: U2FsdGVkX19jt2LwRTWA22Q9eqRquD+ZcuUQQQRmZFYRaV+n3trW/PnJx41bI3mKcAhUjYjDeJGVZe7Qf8FlI1Hg3B9k4Em/QB03yLCgWpCphHahwGCZK/txgHw9milu1jSC50ETkbHh/Sm51TFipdu64yD41q4tIghDz8CepWDty2SqskfLwnv8zeXmLpk29Yazy6RpZ8PNou7L37hn+isUKXvmG008W9DcEAiHwrVFJin/EKuuYnN1R0jGLXZ6eN3rf2WmTDiffzF+C/LU0dTiMMyrpCK29MvwCv7mriGdL8tuGJDJjM7/UHEzCvcXOFkl5+MsuZITExlhupJCcHQ7fKuQLarY6lqwZkDFPsn6pySJ4hBQiSyVBJX74b+Anc6p9qB3ubwX2qA7XhHWbxESz4ikn8Wa18cacVPZUlyRf4j01uI8gH79WWN99a44Bjyeu4Eo29X0G89EEf6ZGZTuJymKvKrHdWtj++WIWlRbiNoN27/k9ZOs5sUla2YLYWvpW7V/T6H17RBNfrjqkE3kbaXenH4Li01jJof9+GNmn+noDfmlzeZ28aZZ0JRmh3TYbRQY1CVhxf25Se+lWz2MEKTw0cKDKu4/mOutbHGPMrPH0uYapNfYPYkj9jYPVYLo8ZImOB08iS/2bJYLF8Y0EoceYLxO1tBMaekgujcOWZBzBx3dJ8ziaIhpfM6CpABpyzi9ram3Q+YNtsHpGKQIwuKBaHKfg4SEINLMCkVem5iCzykGqXgBffeI2r+j7A1Pd7urde6YuFSHTTIXVtVwUT7uWIEdQbRQyPGCROkUZkXP4Q7go4jW48PNzwLO1+39MeQ5taMFfg4epmo9MpH1BhKw27tfm+VerdvVJw/foIMgRKWvidcXVosMXjxG7fZN2YWEu1PoWYebt2qeG7le5u7A8c42sDaTO0Aup/d+kh75MTxsrk2iJ1cTagk1FRkZpBAw0i5F489Q0ci
 wNEjmQ+2
 PxT9TNhuj9cH6uB04FmbfSvYu+/earo/Lf0lLCxiQUMxYa6fjCQZZ9CZOu036JP5roG8SS72PTQ2yEdvwGD+TKRSG8IR9pd/XgHuGsJr49CoYzB9nxtvt204K7vW2frGhr/WZ1bBSrHpHYJ3O/g0JYdCW9e8Lwkt+eN7jm19nAYnyWOp9qntJrzciRkdRjJntGQ0Pi6FqaFK5t8caA1T03YImX+304RQ/fHsVrFCDgjecS06ViXdiavkMUxIyg1vvBAwlQuGcrLQ8jgLJeK7NF+9sPgmkpWUWmVFmtWUg5+QYdgm3ce5C0CIinZXMfTHEY+km5HR/e/pPPpPxO/548NP/A89zuzoxfPtw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Knowing which memory is on Active LRU lists is useful for understanding
and optimally operating systems.  Extend the DAMON core layer to be
ready for support of that.  For that, define a new damon_filter_type,
DAMON_FILTER_TYPE_ACTIVE.  It has no additional arguments and therefore
no additional change in the core layer is needed.  Testing if a given
memory is on an LRU list for the type of filter should be implemented in
the operation set layer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1302ffb6f0bcb..858b4c6900fde 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -780,6 +780,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
+ * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -787,6 +788,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+	DAMON_FILTER_TYPE_ACTIVE,
 };
 
 /**
-- 
2.47.3

