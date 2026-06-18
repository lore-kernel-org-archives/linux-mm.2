Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767A0CD98F8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21F16B009E; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9176B009F; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35BC6B00A0; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87B526B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 120D1A0186
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:36 +0000 (UTC)
X-FDA: 84893382672.10.722B63A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66CF580004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBzMCNZ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldrKeyywA9GImftn4PhLnmtfD48DExaqHnJXAUHGEGE=;
	b=0aNNPJPfiW6KYpbCl5MFR90Y2HUQy763oXnXnDs6N3ioNmqAill7UeiLJtHKPR6dv1kH2k
	oBrngMVSy44kPJQ/lj4mFNSwGd2eibfvg9O4EwzOZw4ACgxV6GEzBYZo6krvxleajU2xaW
	beGp5Q1c1i420Ee48GQ9/50sqTgLBxs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBzMCNZ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795734;
	b=BjWPRU1zze888Y/QTut7KRUHVD//eyX8GY25fzIMNQd5d36liBwU21SXz22KSp8fBLcMP9
	QCKGkKHucSymrHyNw9nf57LiBLEawb7sQ8XJhjVaCu5fg2yKVyD6yrm7d6Pq3fv70cQi6v
	lJXmE7UdjIn/bH19zCoxgWoub7Tf7Zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFA6A60137;
	Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201B81F00A3F;
	Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795733;
	bh=ldrKeyywA9GImftn4PhLnmtfD48DExaqHnJXAUHGEGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBzMCNZ6CWhBgtJ8ogg1I0u0bFEXoQG5zXlf9ov+CpM8HRMOrVPfO8uvBIhRtkRB8
	 mF9IynH1WOfs3o9TtVUzpk0APlI8R/eTWPd9dlxV5vztEAob2jA3h7q6MCfHBrWJCv
	 W7N1LACeqUjeEA9RhZ31uegcI4CFirnybLHzv0M3ihs+lnZErFnPNhRlto8wYoFDqJ
	 TG4maXxZ+Jq6qRdwpsjLxPGzDkXgGLHSK99UvBsaL3V21ybWQNRMT+vKSDlOS5ZIfE
	 DSDSwl6Wz5+BkwMYnj/oiAg9n8A+kP6+kKxFVPQ7TnyeXkWz8Jx3onG81ougfKcgUm
	 LvGQd3UXhGngA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 05/11] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Thu, 18 Jun 2026 08:15:09 -0700
Message-ID: <20260618151517.5366-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 66CF580004
X-Stat-Signature: k9xa7utf39adb4sxfeh5o535yxeajaz1
X-Rspam-User: 
X-HE-Tag: 1781795734-107027
X-HE-Meta: U2FsdGVkX18rpKT9WP65ydsazN/GiiohBj2eSntpnGNL3Kwj7kTOowxKFkVsrNBuJeQ6b386svye7Fq45cShE21qIQYHcpVpl+dj9oIVdHqvLoT71lKSG94zcmNzlyzDUp81CvpH2yMC+TvAG3BGTJqrsCkLH6FGefoDMhmbfQhexdkrC15XmTFen7+XK0ntYBb8rjgfD7mFOpzAnsvt1VZDFCaWmEf0aAywa0LkZGVVWnplzt+hHKEB2f4aodp1d4/DyTgr1SQyZt3nAlefrlT3dn/AbxBnI+Mdq6QLq1g8J2iUNw3xYHH6aNJT6GMo68piwPKihFjQ6HvguEWWBKRm6kOcRWE10Fhli3G3+qVSghZSWGolhY7pwtmU92yW2JDKY10u0TF8tnw28SZW0BgZKzJ/8qSHlM9TWAuqSuDjaK0iG1ePpB+260dXl4IH/R/C+qRc29zSrEY7A0XHBT0jKkkrCcPc/eO+XsctnsoqvxkENyvomLOri2BkQXPGCsQDMPRe3jsbVgqwj7tiz4/cwodaMlqIti/yNmond8UjJvZnbYgRrl7GRbZwX2TDrXAZ8/7v7x5sqYGC6w2Z8bKGI7VpXYB2DTyRPq3MWMIreeFgjDLMqgYU/IjX2vqdMhdSAGQc3SwHM8HD+eqqHkqAg4Knaipmz/m0dtxe/+J+DQP6R4j3hDt5UWrlV7dhZhK2Jm0uMu9uFoYAcigWz0GRksbm/SiT9Z3Gzmbjv2Gg+786CJcqJoGLfv8CURKau1/zaM+FMIEO+NB5UuA4kLx5oFkmsakhgChfqADqXrDbNc1Jbb2J+OiOZBSFt3LG+YeHAiSxnKTmqbmnS1CAnc2DRQkbRLS/nn7npqt5dHVRrnQZ292CSTJ9aOY1E3tg6j380ko7ds7nYjVHTnTn4dMhAaAF6rs/H6M1Q4+VZSBTFdg13Yt7wqsRYs6l8lI7WakihYKUyLzfWVKYeLy
 kghdpVEi
 G7VxPqrSvALyoZC4nntopjMn59BtbV/oGps6GUUKTEWwsC1EC6+198ZP6+KKkdRXSgmI4xF4gLhyT83DVV9F/E+pzECwaSd/BDpIRN0BbNhnTpf6O5gYWV96jZRux/W8ybNhf0LpbIU8fun6xs1zJd8fTc6X/yvi/6tnCu0Or3zu4oDbU4Cjo0xT63/VnBk43arNhIGVF0GpW7MfD3695WZCht2tQ4hHSKxt8G7TF46j2bUTm41tSke4c6ItUEdOGXiP7umc7C9n98sGw9LVFl8SS+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme filter directories by adding kobject_del()
calls.

Fixes: 472e2b70eda6 ("mm/damon/sysfs-schemes: connect filter directory and filters directory")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 36a35ad0983eb..2b0a1ac36420c 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -914,8 +914,10 @@ static void damon_sysfs_scheme_filters_rm_dirs(
 	struct damon_sysfs_scheme_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

