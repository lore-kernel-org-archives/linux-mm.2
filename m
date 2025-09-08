Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83676CAC585
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554948E0010; Mon,  8 Sep 2025 16:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C4F8E0001; Mon,  8 Sep 2025 16:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297348E0010; Mon,  8 Sep 2025 16:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4E68E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:15:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBF031DCA70
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:26 +0000 (UTC)
X-FDA: 83867187852.23.B50DC76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47AA4140005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SrBc+wGj;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmFgSdnEvG8z2yYAFDYnhs5CHmFEomC2IpmGbwqOU8Q=;
	b=GuAL5dCbD9oco6cGrQqFdWLNbmc+zHVoQAxYD5N7UvTXKl2OrqjC9U1Dg77mc5yLCMpSfs
	CKJuoAT6vK7r5aUBOmbR7UreoXMleq0emaZvbLl60oKTseL5fXzbNuT3TsAfTBvbsQT26I
	Dov5lZbjLKSzG8eVpcO9BkyOj8F95F4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362525; a=rsa-sha256;
	cv=none;
	b=zRgqrxn/2uAD+/Aaxz6Zy/+PyHuhjFvnUZAu11ZxXhOlTo+Bq2isaSRSfmYsTf2TckV9Es
	XdQjsbx6604S38dFK/B9VguerFa2hLsHHCjNuuNN5kvSFcqAjDu4i372g76646BpyHKQSp
	ce7NTCge2lTH2ceqtRtqPG6uGcx6coA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SrBc+wGj;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5A76601BD;
	Mon,  8 Sep 2025 20:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFA6C4CEF7;
	Mon,  8 Sep 2025 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757362524;
	bh=6l7sUsMc9BUwJH1VJJlKFxxbsFLqRRCzdv+tU76g6rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrBc+wGjdeb3bfhohHg3bEloUhKBNKdHkU9+qFMzkgmwvhaq+OsXq0d/U339DHNoG
	 OELZJYEE674XxT7iaSSL/PdFMr1+uVh3e00VRLGIxqHYfnDkGTgBSVirfszRotWCY8
	 qQX2Ulef6K5E+/MZ4SjGFIw4t2LQNujS3Jxn89vMdZBnJhG5AdbRXoOvAF1dbx5xb+
	 zrSfhxb2UMX2s3MrYElBcVWqMcUy3+Dw3Ds8u8Pb9INtcaz2NOFS8NLjP2ovFIzkDs
	 8HjB6zaPQIq/JD/8Ll98eQYh0svSqH0eHOUCO+2kcJ89qJHc0RY9CFsDhJcRwn6wH4
	 2G4lWdGdaiCzA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
Date: Mon,  8 Sep 2025 13:15:13 -0700
Message-Id: <20250908201513.60802-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908201513.60802-1-sj@kernel.org>
References: <20250908201513.60802-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47AA4140005
X-Stat-Signature: qgyi4suzd1rng8yp57wbgkt7wttzkxef
X-Rspam-User: 
X-HE-Tag: 1757362525-156550
X-HE-Meta: U2FsdGVkX19CZgZhexwP3IIyOOlq4AnKSbg2LwjXv0ADKK7U+ECEzZ61noH3AYV9E/URnhl+b46PQSDuJUj0Nq1tFaug70sgBPQsqkke/UyNqRCVIRRPRQVnFCzueUNC8Uzv8sxjZNUPLtZn4FoNEWbSP0uQ268pcX8u6a9ThGpbdD79/ehFjS+uQ4nc4n+4KSiaWLxtQBWtGAjBBbvl+Y8k2LtEt66v55UX07+1r5iKJUCiZnTA0YbJ/CpPXVXEHS0hkVDuwYI+nabBzYD7CrEK1EtfEvdgUJUnaH+kqsMtrvl3irL0hxAfA32+/vj7Le3Mdp3WoudxNzIkm+Pey/MSp//yPZvTIVyrOAJJA3lbRUv58CHTlY8xHYFI9hnX6TZpqqLBWJTYL11Tlx/XWc3J+d1Er4LvJ01EC3Q1/PDo0LZ2Q7NLeIdMG1LJrovQg1wGV5iNzDPe4iP0elQml8hZsbtHhxqcHcvqvUCEykrQyeH+XoqhWz9XkAmocPo/USbkgcWXJbP4s/NRI8xQgOeg0d5bokakYcXT4sU9Yd3zzyta5hXmi/opxbDImbzFHDstp8ooQfX3e89Ojeeo55zDR0mDqmaG9OlDjT27RbckHkn79jb8yN6Gaebc8EzGNe0isnm5LtuB8ejwQ0O5VuuTWuLkn6RZY8dLwHd7tzbOGr8QHNXWLeQRDKOti3xgNOVOix19oc3jH33R/csH8zLal0O3plGkZVHTQs35gEQjTcjq9yJQBXw4C5f34TUNUOTcJlnT33158F3jSZaqyfff+TJ5uSKl3ZdIKeEb6tf9msWLCHXENF6EdRtQ2nfNbZEJ2Hbxjb6hTftwYCSbhcFJ0WqWgSW4fvhP0mEsUl3BjWRDalQ3f72lqPgCLsN1w7RcuOQ8xFSRqcBpZNzaBJuI85b0o56NQMfKfuxTUQbJFA1b9/Z78bD6Os3ywqxb62J/qp0fr3Jfks0jt8P
 LJpb2nhW
 +z1+w49hjC9NxMwPv4yJOt4Hifld899gTaGnIftGvJgHH33TbPdd9E/ny8PvVSS8xT2uX5ylxfCjuhCIUIUYf0MaFmwqHN8zbZL3BhsfSfTiUeO514MPXa5su0RBd/YictNp2FQn2rkVdT90h45G7APjirgIceYiCA4ngD6Nx4PuUOFk5fRqwg4ArK8XcAUyPk2yzkEn7xeh8VRQ+pcI6aEAt5bH3qsw67jmV2j3MK3UFkrzXsA6Z58rU66cj58rPhOEnZwNk6rlCSr6++W1uJFIH3eqTUZ79Ob8O/MrYWFulek0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is using a single global repeat mode
damon_call_control variable for refresh_ms handling, for all DAMON
contexts.  As a result, when there are more than one context, the single
global damon_call_control is unexpectedly over-written (corrupted).
Particularly the ->link field is overwritten by the multiple contexts
and this can cause a user hangup, and/or a kernel crash.  Fix it by
using dynamically allocated damon_call_control object per DAMON context.

Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work") # v6.17-rc1
Reported-by: Yunjeong Mun <yunjeong.mun@sk.com>
Closes: https://lore.kernel.org/20250904011738.930-1-yunjeong.mun@sk.com
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6625fb718195..fe4e73d0ebbb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1569,14 +1569,10 @@ static int damon_sysfs_repeat_call_fn(void *data)
 	return 0;
 }
 
-static struct damon_call_control damon_sysfs_repeat_call_control = {
-	.fn = damon_sysfs_repeat_call_fn,
-	.repeat = true,
-};
-
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
+	struct damon_call_control *repeat_call_control;
 	int err;
 
 	if (damon_sysfs_kdamond_running(kdamond))
@@ -1589,18 +1585,29 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		damon_destroy_ctx(kdamond->damon_ctx);
 	kdamond->damon_ctx = NULL;
 
+	repeat_call_control = kmalloc(sizeof(*repeat_call_control),
+			GFP_KERNEL);
+	if (!repeat_call_control)
+		return -ENOMEM;
+
 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		kfree(repeat_call_control);
 		return PTR_ERR(ctx);
+	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		kfree(repeat_call_control);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_repeat_call_control.data = kdamond;
-	damon_call(ctx, &damon_sysfs_repeat_call_control);
+	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
+	repeat_call_control->data = kdamond;
+	repeat_call_control->repeat = true;
+	repeat_call_control->dealloc_on_cancel = true;
+	damon_call(ctx, repeat_call_control);
 	return err;
 }
 
-- 
2.39.5

