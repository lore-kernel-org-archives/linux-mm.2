Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80128C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098C96B0191; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022056B03AC; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79F06B03AD; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17E76B0191
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64D82A2AE9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:45 +0000 (UTC)
X-FDA: 85095156930.10.6B4DB9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C984140002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0wAvhD2;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599883;
	b=1/YnGzTB+i6MIkzXdQSPH+zKCNXfJvB3UWN9TX0savBl/iDVGXQrbC8OcbsKdZ93A43gNv
	7iQ+s9sQORkmWRs5XzXTEzqf/BjNynr/N3aDdDQkK1K/8mORHhgZSa4g/0gfkzu2L2QeTj
	I/L9bE8Us/ZrlrDGTMs5g9S+aE/OUxI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0wAvhD2;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SsJPfKsekeE5VptqHXgsGnvsq0lAUhbBGf4TqY9ku8=;
	b=u3Tvh/UNhl9qow3j26H3qaXCAM61tQWVLgL3vVa8h0kagu5es45AV8DlAuFgUsmSMW1Uzv
	7WB2WL8BvvYdes9FOaDbKLmZEWiYts6v+VJJRr26lXC1EUCNpzm72bDopxuTjRh0wp5wKa
	gJPaMGjt3Hdt8hK0eV/aD9sc5Xjv6Jc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DCCC43CD9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57AD1F00A3F;
	Thu, 13 Aug 2026 05:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786599883;
	bh=4SsJPfKsekeE5VptqHXgsGnvsq0lAUhbBGf4TqY9ku8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0wAvhD2+L6konNr9qCBUej2g8rzvAzHBd+qRn+PbrtFg4Wu1TUMr4xqr1qP/mvCK
	 mKYzllSCsR5bxeCz3Ptd2hFxfB7pxhbXVhzmXZIBpgnj6oYG1c59NeV1srNnsRP1LI
	 7NYe8Aj0PvjgqK2NAYCKvKN6AN8nGz9Ok2uraob5AZ7/7YdVrlix0Fi5LbJMGMsiN3
	 2ptE/rpll7lRuXJ9LCvNE2vkBAr2vTbPa0Qsg5jGxv7zbl+I8bI8XovmpSz/Ypniqr
	 zKSGqgx9/WgXQX2CJBYpQwyH3NTH8e8+kAzeGNTqRR0qZ+7PbuegewHNdt3CL/0gm6
	 cjddfudU9hQaA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/3] Revert "samples/damon/mtier: error out for zero quota goal target values"
Date: Wed, 12 Aug 2026 22:44:30 -0700
Message-ID: <20260813054432.101197-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813054432.101197-1-sj@kernel.org>
References: <20260813054432.101197-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C984140002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: it4dhatosteku3w18rb1mpez3qq77hyc
X-HE-Tag: 1786599883-571722
X-HE-Meta: U2FsdGVkX19SdS1WmIBXvqSbuOu82h2IgrXQTWoOTGk8HwRCsOIXHPxxIo7TGAowkQztsEh8Xf2J9LUuTodaDY95mND4FL5cv3SygqKdhgaS3+c/0jEN0zUioWS4Nz6ndSVfleWftPt9kxZ/JHuBqKdMCr0whBRPy+37N+gQgRNBBmIdoqsWwRa3jCoXnv0tz2xAjkV53e2yxbSJhh2/1nuzMBF37VmF3HcKYImBu/wUr/WnjKwmv+Et3zMxwTnO1tTe80wW9e24nyw4aYbzZYFUZTTcpPuJEfMXd014JTQ1aXzFOEa+Ec/GQ+nCiiBZ4cAbVx0jHSJgCQu4ZqtrtJ4/c9v0Ii3KUs1lsq9hWQwtsYs6ca68P8+KbHDSGGbmt4GN6fydBnrJXZ+3FyD6/tEzSjjVWVQBiJUiTT2NEoH7ykRuZ3NYl7ub4ADosgdnCRd5SFwt3tO1zc4PbrkJESHn0H9SV0oUKYZOMiJPYEenmVQPha4MQjZ/o4yrdJlw+2t0nNPBpvqMVJjQCNr02+fOr0Q5TXQDHPi/hhJXyerrJ6rBoxEqgdZUqnJwmE86E2vpG+TTjflVUWOO+n3mCuyuVMUbeGo6hlm/Ns72KpaXqQdSgsh5Tusyexoo7vMR4MOAS2wneB+vUHCA2RNUXhoDU3C5jbWmTJo4/14yQ6y3RrwyP7NkS/a1l/YFp9HtUgpfsCRtPTizMoyZ2MnyNNYyQbV5LQyO22yhq93LNypqs7+YXGvNC+GIKJ0/4BipCZMy7y17lKdEQYBzOEKqBPFohnYY0nkA326zJn4C9A3mjuodvxqhwfxgvfELDG7k9MrQj71wdz0yKVNKGxucklzlbLcp/dHKols/KnrfahoBj4A3D81TUrjh+wDqnIwuzbHHu9AH+4VATbWHVmSXrD5tvtkGPYLs6IuhJG9MOUgpWEprfPCdAvnYa3WI9xS2UPASzx9J2kKyXc9tlbt
 4gHJhDUA
 ARW8hGOf4Ez7OIEnJoLPkg3B6BmMcmIUezWrhOJ15beq1SOqVt/zayQTla3HsyU8MV/jIyfFpzVueeQxQYFXhnJiii4JE5zzDZ35shyHLvNU6oQBJLFMncKbPhdLZGLDN4KedkymHPATqJX+YpKolXlco1TJtoaN8GDNKVuI3EqQ+/ElGOMCcpg8GWsQYpdREFzbUbyq2lqfNXcBYaJVKhr2EkUPWwfkxshVxoLMi4IlHkvzg6BhBRkTn3m/P3LFSvXdcEpPgJ3gl6ay6KFjSZG/48xIqkGaKWOZ4xR7c38I/Zqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit a16fd3ad9d89b05475864da97327870464611736.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero
target_value.  The corner case handling in DAMON_SAMPLE_MTIER is hence
no more needed.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index bea45c87cc9be..27dc88bdf7a0e 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -161,9 +161,6 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
-	/* zero target value causes division by zero in damos_quota_store() */
-	if (!node0_mem_used_bp || !node0_mem_free_bp)
-		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
-- 
2.47.3

