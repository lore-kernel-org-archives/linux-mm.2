Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95EB7C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A476B0088; Wed, 16 Sep 2026 00:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CC66B008C; Wed, 16 Sep 2026 00:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA5C6B0092; Wed, 16 Sep 2026 00:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257136B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:14:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CA9614052C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:14:21 +0000 (UTC)
X-FDA: 85218308322.06.BF9B6AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 850ECA0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:14:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BZJRom/D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789532059;
	b=na0xM1aU05FwHuWf3fAYt0hxOg8NsV87qIMMTXjBWPmVxv2/RolUrDo4/aj3nwNsAyOoDR
	QTgcAPlbQX2ppWs4QpAMkq1n23wAbFIfxc8mnJSSBHj/BU1QqXgeCwPe/9d3RlFitmAogH
	4C7nF2gWquKSTOI2AoXvQ/8HXZX+AT0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BZJRom/D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789532059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ngB0o9g4kbXSDf2BCTzrsj2PffWjgQlLeBpYdVht6aM=;
	b=ET1B0bzCDlZmibCEL8vgg5h9djIgvSjorvaVAxYv/jLfAG4z073O3S7tCs+c3bN0MCXqZs
	5e4Nv8NFzJ/PclYaa9ryc1C9RYp6ovEHba6+sUdjUi1VnWKpWe4ebvjrfwjdp8gihjtqPE
	HvKMtX5jM5/ExgbtIsV4Xp9qDOHETgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DE51405DF;
	Wed, 16 Sep 2026 04:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFC21F000FF;
	Wed, 16 Sep 2026 04:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789532058;
	bh=ngB0o9g4kbXSDf2BCTzrsj2PffWjgQlLeBpYdVht6aM=;
	h=From:To:Cc:Subject:Date;
	b=BZJRom/DI/Ux21V7gINb+PGv8pXlzoM2t/8vwmUySYk3k0Pun6FbVEkoOZ1vo/7YD
	 0fT0RQu9+lG6ss92glHjyMRe1kTS6qGyssu8H3UArPTWLgL6jqC3KX6mgKckwmvKqD
	 5xnhHRVAlFy36W0a1IE31g8DVwSuEl9pbnBuRx/gAaZ4GtSydqOKTglV7LhI/pQvij
	 lxl89iGXEPbcmw7V5d2Tp18Zbe9tswws24i8UURFW+BPUy3/3qdHgZCKbIQR9MmRAw
	 SaULT/+OeNAStLDv/W/EFKt4H7XPfHWjzEwgN8yP9M+wjMU2bl7ySj54xaR0FCnHji
	 hDwW7v9YpWHaw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2] mm/damon/core: don't skip damos_adjust_quota() while esz is not zero
Date: Tue, 15 Sep 2026 21:14:08 -0700
Message-ID: <20260916041409.106926-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 850ECA0004
X-Stat-Signature: jhhran4ss1sosdareccfcr94j8db8sxf
X-HE-Tag: 1789532059-557337
X-HE-Meta: U2FsdGVkX18N5v9+7qa2ml6ZAnlyBbaG+x7hMMXWXGdXCectP1ZEuqZfO+53twiH0J20KUCtW4bHZyyotugziWQ5b8nKQRQTS7nDZeQOaoDPM75/HEmAWl70Sx20BNGER1S9P36HqnkWNBKdzWI+LlbgdR1l2ZYj+5VHCqO84bzQDZzoj65gBky8I7XcXvBVj2RprfntBVfSQpgTTiweGTKTB1Qubl1HtukCh361uVxMIswyWbsayVhT9lXp5RlSEoFLkKzpAyMkduf/oktICqT1oQfmUwtb8GZnUkd0jWubv/QNIvcF1gEtSO6k1knDD6Au7VloYEeSdaGNtQnxz1dT7p4jrQhga6IjXkeyWjzS6Om1XTeX2GScafyB+VLs7uW0I+sTsAE3kOMpI8GrD2qTV9XjvPPCpV9rLVv60xVH3bif86X9Bh/wMXuKnAhB5y3OaUDrTVbyNj7Hrn1gH2JFJjRGTsg6+8pn4ybLz5Divtp9SDPKQpcyRy0PYd84Mvds05KZM6a/8n3m7/7sfFl/9srH32yP+MwcQdG9S4uhgrf0q9Cigdew9d2jvjUuHg539qq4vnf4BcLXZVsE8affnniXsnSJVc7/CfZzqxKeAIfAGqBw6jroFkkgtCIh/60mvHSfnXiYRdQdbq5qgUmqzEkRDn0vCLPXUTosEYKi/G4qtBvY8smbY7FGwwm3liYUvRt0EAuEAZ0pa4ipRaQYQ/rTePxFwWsETWipyLkYMhteR3B/J4epAT0evFYSr8QMdrDTHpjBkVKkE8dqAslud9WQ4g60VKypHNnEW8+tHS1nUQ1/yBq7c9JsgP0mUGbeqz3wk6mvNCeA8c8yMxD1GHhXDq7TybxQPCMz3zqaKtACGHguBNtMhMljBjfoE1mTLMeXkv/TnuLCbHE0KTOLYFWk8Z0guzb61Lhc6Jf0QSqFOrsuHfw7vxUD6OaxbrEZ+l+Ja8nyq6rBPlL
 4oJ3p4FS
 zKbkeCrUIKoxdGnIByVIMKKr9dwephpUIGMuNqFjeplI7Wwzoric+CNo1w+JoEZ8zVnbi5tx/yC5vTKxtqtrrqRqMMkBKP6oGP6J8SIx0quz+jJB9foDdiYrsZNOBvln/2tXGyxd1tMD+Q3izOV57vMKfzlPJrzwGsU7feALS1GzP3at7/vOkJnslrWrVsVzBb1ZBFdzHjlmsG/TIHNm3i5+u93Ps7VAJ6T4kTYg+ItwxN+YyXUTIqDONjXkXXDbYAYoSwck9OcTjxbaGBxKHxWhFv58hUvJ6/UgddHCfsS105pgxjAnY7BSRsB17j9uY3zCMGJHvFPmq2anyaMUJJknxEwmvTx+NFX0lLZjCji5+SYuByMQo4KKdcNsRrLTvEARx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS could unexpectedly stop working when a user disables quota using
the online parameters commit feature.  Fix it by correcting a wrong
quota unset check in damos_adjust_quota().

DAMON users could disable all quotas by unsetting time and size quotas,
and removing all quota goals.  The intention of disabling quotas would
be making DAMOS run at full speed.  When such quota disabled setup is
detected, damos_adjust_quota() skips all its work.  The skipped works
include effective size quota (damos_quota->esz) updates and charged
quota amount (damos_quota->charged_sz) resets.  The intention is to
avoid doing unnecessary work when quotas are disabled.

However, users could do the setup while effective size quota is
non-zero, by doing the disabling with the online DAMON parameters commit
feature.  In this case, because the effective size quota exists, DAMOS
will keep working with the quota until it is fully charged.  After the
effective quota is fully charged, the charged quota amount
(damos_quota->charged_sz) cannot be reset because damos_adjust_quota()
skips it.  Then, DAMOS stops working until the quota is newly set or
DAMON is entirely restarted.

The problem happens because damos_adjust_quota() assumes the user setup
for disabling quota immediately disabled it.  In reality, the quota is
still working until the effective size quota is also updated to zero.
Other logic for catching that uses damos_quota_is_set(), which
understands the fact and therefore checks the effective size quota in
addition to the user setup.  Fix the issue by using damos_quota_is_set()
in damos_adjust_quota() to determine if its works should be skipped.

The user impact is a non-deterministic and unexpected DAMOS stop
behavior.  That is, users would disable quotas using the online
parameters commit feature, expecting DAMOS will run at full speed.
However, depending on the timing, the setup can be updated while the
effective size quota is non-zero.  Due to the above mentioned internal
mechanism, DAMOS stops working instead of running at full speed.  It is
unexpected behavior.  It is also non-deterministic because sometimes the
setup is done when the effective size quota is zero, depending on the
timing.  It doesn't cause critical issues like crashes or leaks.  Users
can simply set a reasonable quota again, or restart DAMON.  But
definitely it is an unexpected and non-deterministic behavior that makes
it difficult to reliably use.  Also investigating the root cause of the
behavior would be quite difficult.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20260912200814.145612-5-sj@kernel.org
- Split out from the cleanup series for taking hotfix path.
- Describe the real issue.

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e0414d2adcb41..89390897a0d8e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3330,7 +3330,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	unsigned long cumulated_sz, cached_esz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
+	if (!damos_quota_is_set(quota))
 		return;
 
 	/* First charge window */

base-commit: 191c4a84eef1db85cc7e1a853761e8ce8683afd4
-- 
2.47.3

