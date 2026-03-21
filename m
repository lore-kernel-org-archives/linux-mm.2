Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30535109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F986B00EF; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403876B00F2; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1186B00F0; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E88266B00EF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE283551FE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:38 +0000 (UTC)
X-FDA: 84570820236.16.990ACF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1609E4000B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCIHzKeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOnYaB2tAwTK08iBhyNP0vgp16q57l/Gx40280DuIm8=;
	b=7S3K4tEFh0QYfmxt+isym4AxDqf1o+im9iCyHGk1TKIm4xdiFYwiQ/4xKT6VPvp7ShHgec
	VveeYLZb3HrwNWnj6R+/DtjQgtYWzcy40Tp6/3HXVx7b2XgREtMiUvaOks4HbLEi8obCHc
	tVdNmJyIgV9kXfxE9mlmsGLxakDW7Vs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCIHzKeX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115677; a=rsa-sha256;
	cv=none;
	b=q+METUvKzrllqk34+Jmmi5hQKDXLKnkthTRtr8FWxbLqxOeShMI8SMD1V9rQCIZMlWiu6U
	H2AjxvqMgr87V70bpGf9XLGehEr6gQSo2fpZb/pVikYgc9QSqZ2ZK/SeGIlmAho5Hj2Egh
	n+Rn3XiRhlkhZWCugB3LnhTX75T0gi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF344457A;
	Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0406CC2BCB1;
	Sat, 21 Mar 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774115676;
	bh=ozaZfolHMPA3TCsXC61RgAmpZFbdf9+Z14L9tHNxdsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCIHzKeX5pvZa/pwEj3y0EPD5StACRN04orUN65Kdv1WXpLao9Dujx/qWb/mXU4+C
	 RVus4wCtn5m7UE7RqBn42VtY5j9UsdYWu1juthqS5tAfl5+UpXVYz7n1nn0uMaqh2L
	 d0G5RwzGCzVI+SAvT6EVzdyKpu7150vdTBnFLBktJ8ZJnh/KP+hZa/jy/ocj33DodK
	 MfA3LgZbo0y5KgbHsEJFWJQZJtbssPudiDvd0u58tn5HsXH1rP+itsnU9dCrSLUdyq
	 tocW0aUsuhxVLw8eshlOWJLk3oKuRZx80ObGUz5H61jxy340nZPrKjLz7h3MRPlEeU
	 qZGrGlBzTQx8g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Law <objecting@objecting.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Sat, 21 Mar 2026 10:54:25 -0700
Message-ID: <20260321175427.86000-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321175427.86000-1-sj@kernel.org>
References: <20260321175427.86000-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1609E4000B
X-Stat-Signature: y4xcojpneh5jkaeg53fk7xpjtiauhpm9
X-Rspam-User: 
X-HE-Tag: 1774115676-187298
X-HE-Meta: U2FsdGVkX18vzHc0tlDVpdO8XUu/8sXxrbNQl0olGI8F7Z2NUm9Bu8/EpSssrPwiDRbsr7bi0bH6DkiT13X5l66WGMnI4JUrYFCCpCRKW0QfpuE1ujkzA8FfjX8wE+rqeKtwL7jY3UkMpoFSlHfLfuPkIlQYUIvL8gulNOuGQ0YLC7oHWv8vPwamSQfim70CZNybnBnfKOtsNSx5RzXN1hPRxSzLP7ZnPXvzPaf8M3xcWa3ACCb2QGa6rC7phLWlJ36FfzE0AVvt9x9U/COYZsZ/kYM96JY7a5ZujiEzkzhxQcb6tpKLRyg1xwTeK/WUbkOZKh5/MZYw2WA1erWmLSqYJ7ARZnKmOl8I6AyNgFmYUPs4ZqHzpMJVhokOgurs//+BHtBwwqh583b1ScDWlOlK8Oh0BJnpc9igjGfiLDJcPDt5ybVZ9kVvviNW3F0foJsIO+ZhInvYOzG8Ws1sLO/XMeK0BU3r5i42NINKP9+CZZYdxqFpI/i8aHki8YsDVRKoRrKvqQEIoOJyEFxWsT2RK7EOKdPC+AYtabAyz2FXoPy39uM7iWk7AZIkVeMtSr4gq638yjADiU0M8dIBMAsKNqSKzdoP1ZvB5OPV/5yUgyax7dcWpmdNtpYXV/erV25m2NP9AU+azMUdbwhCMRSnGU5m9gT7uH70y7yDKZeeFQbzZk1flPQAqSoZ02SHAEkhkIh8/aPH2vJ+c3hNCYc7rGLsXF+4WaCiD9GU1rrJl1xYpL7OS6hLpiUgbdijqS7B28r1EgzNed5Ugcgb3sne9QuOlTBVPJ9mjfDhobtaBS1yeMGPv7HhutFExkdabFSDCMFNEN9vZD9N2SxncmMUIskdjc/lnTCEiz9F3cn1jE+/42VS6vdjna/5dx8n+VVLqRjkza3K14Flrq5NFTrtH7p5FNIDlMmrOa+w3yZByfcHvxURy5wDLSru4zCX3LcTtuz+TtJCzZ2NoOU
 NyiJbtGe
 EGoMEbRbI0tbX81JK8gP16dIFEe+4u2Hu9zqDysFsktXi3SDcM07J82J2SvvBT+PFvxbY6x9uq+SH1gk7yv63dvkB2PjNi3F/KrFFQvHT8Q2K019mXBahV9nDpDU2m6dyPmFlBB7mKu75CyVmA0OILkvfKT4u5rnMsiSA18jpjw7mzmDge/TmkMNdKa3FAo704z/L0g7i5/jlzmKV16mdqVCKA11VUWud7H7kBSKskrijPgjv9qVtCkAmoCdVQptUskyUYp9YeiBDSYPqXsLS989JOOQBlngTnUcDz+9BCmNu8SOuekfKnnWpLGNZ9NT1nuYx9Q/q3+qa64CVKwoEM6LpvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that kdamond->contexts->nr == 1.  A user can set nr_contexts
to 0 via sysfs while DAMON is running, causing NULL pointer
dereferences.

In more detail, the issue can be triggered by privileged users like
below.

First, start DAMON and make contexts directory empty
(kdamond->contexts->nr == 0).

    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/nr_contexts

Then, each of below commands will cause the NULL pointer dereference.

    # echo update_schemes_stats > state
    # echo update_schemes_tried_regions > state
    # echo update_schemes_tried_bytes > state
    # echo update_schemes_effective_quotas > state
    # echo update_tuned_intervals > state

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Cc: <stable@vger.kernel.org>	# 5.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b573b9d607848..ddc30586c0e61 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1749,6 +1749,9 @@ static int damon_sysfs_update_schemes_tried_regions(
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
-- 
2.47.3

