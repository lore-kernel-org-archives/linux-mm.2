Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3B9CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852056B0096; Thu, 18 Jun 2026 11:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826656B0099; Thu, 18 Jun 2026 11:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1DC6B009B; Thu, 18 Jun 2026 11:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 408CC6B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB413120161
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:31 +0000 (UTC)
X-FDA: 84893382462.26.0C87516
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FAD320011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI+RUT9n;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6MPeEDmuSnl5VMNAu0xLTOn+1aNO6rM35POBLTCeUQ=;
	b=NcJWP8Olmk5BZoED7mjB7BylnZv/40DP6dBRRT+4m1AEOze0JPUvnO97fKZXvjtgpxErv+
	+abDLFfrx+sJUgM0S5dhG9xRz9KoZSKn3LvS5fBnuVijOFUT8HgaZz57fNZnlvfnfVHLjD
	ee9l/rPEBP4+ZEaJv0GXtwKdoAHjZfI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI+RUT9n;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795730;
	b=UFdu+0dgbXWGXpycHpbpeLJ4qxq/Zl2COxOV9o01OMYmcqweCr8/x3Y307MGNg8G/MYQO4
	hKpTYiWEH52peE1z7LKL/txxFSo6bvgHqm79vT0vRdP3rwunWbckgISaZRiLOe7LOQ4Wi1
	MhHeak3iwiqevgHk9Wfiq2P8ZeJZ4yc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 963BD60018;
	Thu, 18 Jun 2026 15:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F441F00A3A;
	Thu, 18 Jun 2026 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795729;
	bh=L6MPeEDmuSnl5VMNAu0xLTOn+1aNO6rM35POBLTCeUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dI+RUT9n/kBduhaMUwfp6OoNLIRxDVx5T8EF7kM1soOL/rbfsd6Zn28rFN7/ygolT
	 c1qGMswsswVH5tOv8ABOK9qfTXdByovJvsDl/2xqvfF22lv/d4It+54XKOi6ttF+WL
	 FZUpmghRC+N+cASLC6W94VloT8KsV6XrTEpLrs8atEdCm4HDfr3pllObp8QvDag2Vx
	 Jp8bvBySMQgw2MYmm3YL//7gNLNgC0RN7X0RBOPsIx8Qtbs47M2SjSxrqmRKNugWxA
	 IeU+aFuRZEb5M10P/pHwDKCSY7xTQphMqHjEOmS05cRuZ8djouNmPCR/nuzjPSEwGL
	 VqDf2ca6RX0qQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 01/11] mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
Date: Thu, 18 Jun 2026 08:15:05 -0700
Message-ID: <20260618151517.5366-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1FAD320011
X-Stat-Signature: 3iq9j11mx4tr3bycjre9e5hz6s71fpng
X-HE-Tag: 1781795729-505558
X-HE-Meta: U2FsdGVkX197smm7vGIUxtvlfE7oIG8TbtdiS+bZ5LTB4+jHrBbx1xZKLviOQ9cubkQBGQAV+JJtDw5cxzazL1/cDiLlRs5vIJxHCO4lVCXRb1uKKGLIrNBBTQJj4WOwccvKRPl6vgNEXTtoM/agAi9ekekLfrSGpNvPm5YIRPCOMunPIZjYNbvqvGaCf2CrYD/1TyKNXaRSgF7Wfm7dbTq1rgdmEuUcm7PboyZqBk2YvrLBZN5UGAUxTjPC524R02Z61ON5DrbZ+FHvIeDT4yut6qD8b9sSZZq3cBRCOJGbD8gTwqMPMOyRM1JhjembOgS6m7f7lswNjVhg3+OhW3nQ2aaEJHdpPm/0HAzELLDrwCebLhtkh/3qwBk//79p1t2H+PyIgyqIfGgio33FKl6WZPxAw+Vk9lkTS8tpfQACVKOaLq5VoYVY7+z/3SQwFYYeQsP9V0ag8Xdry0DdBZUzVzp7AksVBzezFGZJgeRaPwoWzM+VzGR+79SF7CkA7X66glgYoisx/cJYJl4mvwSYF931ZiBjSOZ/Y6jniHun9piNmlcBzD150gsOxDQ33nReS89OABRP/Jv/mkJBJzCkkcUjop5JC4PZhFTImPIu6teaL+yerQLOLdBz6X5MbMiLQ51QlC3kFBrT38tLfn79b6rhlrWOQtIgb6e03A+b+e0q58VKzXTOnCv54FDtIFAZjf4/CdB/ZPYw9QwgRUvm/pnZ9GHw7vh8T2jSvzZrj5GIFruUmKgiuOTAtW72ItaghsVf1n11xWwF0OKDzjja3F1SywXEU8E0hMNmVwACvd2uAgx2wUnYYQXBaqh9qYwwJr/j/3wIFHl4luU1JI5DIQ50Hs7SrwKZ4Owezrb0zbpOrnGU0TIWvxYnDuHI5erAzfZuSJsLvtWIZPNAorSHzwBMlAZlmMh6Yoppg0/1acVO0PyMVBZw0tKugt9Ryfq4nNx9e05M1NTAs46
 WglTdrY1
 LWwtWU6696gRAaH8MdP3t5WhoQIoU5a3vT5YK63c6ZjMac6KSraFQkN6j/lZ3y4vBCCsi0Te0MOy38SHJwIXPTkUCdPA8mzQS2tag9RkrrcNdCzy/tNhnpcXolWVXhGT+Q13Q9vw9nxSVvLV7IfJAb0Tefe+KNpBaj/ZzlWixNYVp06d0rtHNMZEL3AC1wyDyl0DUvd5HcbAw0UaLrMqVGEsWOkojVU+ygFYpWi3jbLW9fzP1drJ0+DyPdh2aJgdK5uYg3YBGr7IB08rlLzFTG/W1zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for normal creation paths of target, context and kdamond
directories, and error paths of context and kdamond directories by
adding kobject_del() calls.

Note that this fix for target directories is not complete since it has a
similar issue in the damon_sysfs_targets_add_dirs() error path.  Because
the normal path issue and the error path issue are introduced by
different commits, this commit is fixing only the normal path issue.  A
commit for the error path will be added next.

Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2e95e3bac774d..dba1c67fc188f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -333,6 +333,7 @@ static void damon_sysfs_targets_rm_dirs(struct damon_sysfs_targets *targets)
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1642,6 +1643,7 @@ static void damon_sysfs_contexts_rm_dirs(struct damon_sysfs_contexts *contexts)
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -1680,13 +1682,15 @@ static int damon_sysfs_contexts_add_dirs(struct damon_sysfs_contexts *contexts,
 
 		err = damon_sysfs_context_add_dirs(context);
 		if (err)
-			goto out;
+			goto del_out;
 
 		contexts_arr[i] = context;
 		contexts->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&context->kobj);
 out:
 	damon_sysfs_contexts_rm_dirs(contexts);
 	kobject_put(&context->kobj);
@@ -2501,6 +2505,7 @@ static void damon_sysfs_kdamonds_rm_dirs(struct damon_sysfs_kdamonds *kdamonds)
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
@@ -2555,13 +2560,15 @@ static int damon_sysfs_kdamonds_add_dirs(struct damon_sysfs_kdamonds *kdamonds,
 
 		err = damon_sysfs_kdamond_add_dirs(kdamond);
 		if (err)
-			goto out;
+			goto del_out;
 
 		kdamonds_arr[i] = kdamond;
 		kdamonds->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&kdamond->kobj);
 out:
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	kobject_put(&kdamond->kobj);
-- 
2.47.3

