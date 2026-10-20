Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5672606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D4MT/KgP
Received: by kanga.kvack.org (Postfix)
	id A90446B04E2; Tue, 20 Oct 2026 10:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19376B04E5; Tue, 20 Oct 2026 10:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910086B04E2; Tue, 20 Oct 2026 10:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0036B04E2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:47:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFF39A021C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:39 +0000 (UTC)
X-FDA: 85343283438.08.5D90B7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 473F2C0010
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D4MT/KgP";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792507658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8KLZGYnTaZZfWo0UwCu1ph7Ozc8pVIN7vRMc1zsSV1g=;
	b=V7ZoIVKVU9kJfTLvmM6dMNR3sOCBk/Ixw0VafxRrHaAo56UlaTHhIqvJkGgev6P0uzSFid
	R1fTVGGC9odXqScYE8s1tDN7+Tzas1kRpbBmYMp3YwcuxIZ8L+v19vEn+AVvKoZqfWE5cu
	ughsNHGLaHzFye9fsOpZLnK/bYWkt3o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D4MT/KgP";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792507658;
	b=6wSZjxCaXac+6i5HTY5zXDwe2tE1I8QB1DyuGMRF3H15T8qaBxA0kNzY/cbXWRl996T5Kn
	bdjbPqcCA6cIV7q0+Np+Et4LNniU/1aRxbVyLP0Uyp+6lCZhlLGTbv03hkSrmDJP4KLwaj
	XDO6GKXMkqWVfq8edhybOAjia71LofQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39D6743A9B;
	Tue, 20 Oct 2026 14:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48FA1F000C4;
	Tue, 20 Oct 2026 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792507657;
	bh=8KLZGYnTaZZfWo0UwCu1ph7Ozc8pVIN7vRMc1zsSV1g=;
	h=From:To:Cc:Subject:Date;
	b=D4MT/KgPVeIyRqW9ieO8UoVRz48J1VsRFefiD3x9nDNdAu62Mkrvbh9F4WY8uzk1L
	 t+zUAqjuIjRc8S4m425jmJFCAUoXO10wl8OCTqVtBc5LE7WvffRUYcLQwFwBMKaoZx
	 1QIzJx7T1LS5Jq9dWWJO3igUYuhuFvob6iZ6y+EJa7Wwgaxi9RDKsv/f2xDWbmaEkI
	 1AIkuUwrmE9zqQHCQboXcQ8ic2izEQoKZB99XWR/yfXW0Ny8Yzvbt6nKL5fLRjJsdl
	 +JyjHbO7FAA+nFX+djkxpiYKUjzE5C0Jck79FdHXf2VEXBo9svXkGJDY7mXLdbbM+N
	 daaI6ENhhxiPA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()
Date: Tue, 20 Oct 2026 07:47:25 -0700
Message-ID: <20261020144726.88978-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 473F2C0010
X-Stat-Signature: kayuodh9xcp7gz9wu837mwparopye638
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792507658-834802
X-HE-Meta: U2FsdGVkX1/eEiLxEnALWfqHF6mPY4qiqwZui7sGzijkCKjU41r+gBDLRW2alDXvaegcTNbYootlTBw4UyL+Du9RZG7xYL5hG20cV2N5K/IGV7o4huh2jKWW3JqJC4MD1tuxFkYdpQCKDD0dlEjvHF3NeqTwW5utcIu/Thb74VIMnl51w+31RZVkQzP5CGK0RJevAAdl3Rve9McBR8OmcAJae6gJ6sfaDxgoRqU7UsL+Ry8KCAPeZOmjkLg0uigXBGS/y0adgCiWBGXZye2yNx1C45flf3GiFDxtzHQqCwhBhEkNUebd+7LRtRgCyDbC7oE4wrnm02vOWn3kyVMDs95IcwU79C1sk7jO27+cLvJOsQU+bbs2gjvCeBrh/F0u1Stb54SNalZ55kq4gSGkv0Kncz5bqNROoRP08Z7MnmUk+7WbZDE66vSZ4yQA7wl/fG8xj0haFwkr3NNDivGkFdBqXt2smcviRCRT9A9usuQMrMV1advNrPrPl6YFvCOehH5QZ6PZF0ASiadVgXZhs3K5woWT7eK5Pj6vkpMMrGuLXgBX8DiX++MzKwwBrde+01Mvpsz1ZfRwBM3gEsWRonPr6CY6mCVjhI5mwv44GrFGv77a8Y/IFXJr3zMqA7Yjgu0hbWP1dhPRizYKJArBaup0biamXkugaVz9ROVIxCtjNMA/fBYi8J0Kt2Wqbyrz3b9wSxHWIxWBa3VNg8SpBgpRmoFzgNbgXC8LfF7ccjVXslgO+f//x0acY3np5tGYdbmw07dDgtSY2DdtMZO/QEgso+LPhB2UUoeJw1K29vI5TrrFJam8SgfJCkMvxtFEtu0sDAb67ZPv6HvT7hansvt7lcPWqTCvWJ8Q1I/C6ppbEJXNFzoJ6VAToGEaiIKXxz6SBHmJ2zFqRSp+uN3kBxo8yl9YnbuTUhlLCnDhP5aqfVDNHFGjDy1gY3OSFRGbuNXEIjMqM3kFpDv6QSA
 an555ta9
 mi19/sz18zBcmb1ADvCcmgVHile7HE6IADlgY0TSyyHqpJxEWi1/DCBcj0RpcIsPVfWvSGpcjartc0BpLLDlKiyyqNHlgAM6yh58GNMQ6V8SHT5C3r96xIfc2kEBG38yNRGt9+kdZApsOsL/pCcATSJrh6zs70fxebNKQHUnuKRtSYJ89PWg9jjzzEDBrW949odJ2NUpcNm+HJWp+rkVosjDLquFk2ymQ0bGyDdV3Fk+tNJkefzCAbO2ztPT8gVAuNoc/3erytePVpcmcGjeEG+SayGLzI+QabOvYTwpHfSi2gZZ7CqWjPu8iimidSUDaptZm9zZb3dCEGaD2sTeClVyTmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove a race condition under certain use cases that can trigger
divide-by-zero.

damon_sysfs_add_quota_score() setup damos quota goal as user configured
and pass to the core layer.  Because it could have a race with
damos_sysfs_quota_goals_rm_dirs(), which destructs the files that carry
user configuration, both are called under damon_sysfs_lock protection.

The damos quota goal setup disallows zero target_value parameter because
it can be used as a denominator later in the core layer function,
damos_quota_score().  Otherwise, divide-by-zero can happen.

For the zero value check and final assignment,
damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->target_value
twice.  And user can update damos_sysfs_quota_goal->target_value via
target_value_store(), which doesn't hold damon_sysfs_lock.  As a result,
a time-of-check-to time-of-use (toctou) race can happen.  If the user
sets the value to zero between the zero value check and final
target_value assignment, zero target_value is passed to the core layer
and results in divide-by-zero.

Fix by holding damon_sysfs_lock in target_value_store() while saving the
value.  The read side, damon_sysfs_add_quota_score(), is already called
while holding the same mutex lock, so it avoids the race.

Users could reproduce the race by writing zero to the target_value sysfs
file while DAMON is starting, or online parameters update is ongoing.
The issue will only rarely happen in the real use cases.  It requires
sysfs write permission.  The race window is short.  Sane users wouldn't
write zero target_value.  Especially, they wouldn't do that while DAMON
enablement and/or online parameters update is ongoing.  That said, the
probability is not zero, and the consequence (divide-by-zero) is quite
bad.

Closes: https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
Fixes: 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS")
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8f083611741fd..55298a17b653a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1355,7 +1355,13 @@ static ssize_t target_value_store(struct kobject *kobj,
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);
-	int err = kstrtoul(buf, 0, &goal->target_value);
+	unsigned long target_value;
+	int err = kstrtoul(buf, 0, &target_value);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	goal->target_value = target_value;
+	mutex_unlock(&damon_sysfs_lock);
 
 	return err ? err : count;
 }

base-commit: 33560dfbb2df9b2d1525fd51ceeca3c1167431e3
-- 
2.47.3

