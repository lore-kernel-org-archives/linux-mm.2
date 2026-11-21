Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4984B606A334
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZaWZkARZ
Received: by kanga.kvack.org (Postfix)
	id 99C526B05C7; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9738D6B05C8; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE796B05CA; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52DE06B05C7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF0BE16057F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
X-FDA: 85460344620.03.811C221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43385A0011
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaWZkARZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294829;
	b=KuOfhGvu9tiGjkwpxTnZCA8iYrQiStwxP2oNO6cdaatHkcy65ib9uZXHDbxlkGOECc8WWA
	QtRiAs+kGf9OOgmzHWRxjQOoi62lGdtJXNIwrby50haQ09rbvSfMp8mnim8x9XHm6Z9ey4
	rP92adPKf7gjY+wBNGrraOBSq9fFJUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	b=mYWZpPhkEQjA51yQpEJHk0JNMi6lFbW7bMNfWOldAyS65L35DNrmKkFrSjf/HrE1D0EOQ5
	uSzz+tVrCZsgVcyxdT+9znRr2ux8Ct2l7wWELnd5mUfLXSS/PCuW2+OHdc7SEP4AE6wlbQ
	G0M8gysnQfWJn2MRZZSJlRGe78iB35I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaWZkARZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86083404C0;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E21F000CF;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294828;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaWZkARZ/HsAd/1YZhKEw78/Dk1rtNNpZCUby5cAAGNxutNEZOOT4xIRhyvLrvAGf
	 FffygDz9LuC1mJR3QHo9lsIo9ESHFFM95CX4fu9M1/xGzK84nbuCln8FZIHln8h5Vf
	 STGIdA5cExVPdfHvHoh6k0mJ5INNG8eNN5Lz9HfuF2YSz3mbg5s++s6jgdVYpa0m1L
	 /xgn5Lh+AlDAuhJBUqz4qPtlMr7+7Aoq25C34SkZGv+i6hCjElnCp4S0wmgQK75QhH
	 jVZV4y3rvAVK/6qhVUU4gP9VDLrpkMq9wsIzUTr7+o7inkDTRXo390rk/MAtmeHWm/
	 zzCV0mM1mPwrA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 21/27] mm/damon/sysfs: add user_report support for report type input
Date: Sat, 21 Nov 2026 13:00:05 -0800
Message-ID: <20261121210013.130397-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43385A0011
X-Stat-Signature: j7sr3unyjw7aytw735jmtwi99qwhtpab
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795294829-877867
X-HE-Meta: U2FsdGVkX19tUdw1gDULwK5/NSPwin9RJUf2MnXh+nrbsCjcYoHWBS0+AQ0z5IZeJG1o6LJ5eT5q4oQHh+auSBgn0oVn53NtRFXPhivTT/bmO93NZDzuQg/sUzttv1OmlcNso4OA1GWMRHX4DpOSt/7zrzzZrUyP+kf3llX/i0sMBCw0OJDhlT3ipqOGqNah8g47LCwJtIzooxYo4Vg8rNywsLnpqay9A/as7cTZkeVAKqWKqLsXeT+N85QhwasYE5k0ltw+Nrrv1btcl809UcOHabEzgmM79vjYUzu/gAyfChGara6cF12gGCaIWrP/q6odE61ueEn32J+0cj57oLd3mZ/8yvMzt3WMjzM0SE3PrSmZRprx1PNAwACY/qr/MGmPyjBSlXRgdE3NEhdiqP41TXlW7Jm5aJq8ria0046XE8yUwv9S8g0tRA2IvRK2vigBeyUGIURaE2IYfOGS8sJGPKst6MRIeKJeQ31dLCuPTG0sFP+P4gnx52AQfPB2sWSEKpU1gNliEYnsg4Oxt6uY9/2srYJ7MiLTUavwA8etxy7z1n/YeI4hhGD+mP0o6M3FOZQALeQMc/aOek5g69aNOshiJ3CS93sEHTySIRrC1qd7tX7FbsM19fDhm7zvmaeSTEByaMcmsq12Ejoud0j9Kdx63emlJdPSkVV56/nztF6HyiXDEGiX5nH8GpZI/xp9Ixv0n9Lvp1MK5TZpJC+WBbvyzi3cRn8PPLGgFxNPZ0F6XNHdYkODb+ZTHxrxoSMcX++fZm6rDmHgKqCgVi9f4i7mJLRG6HBC7BKEQyDittMfOCYmu5hg/Z1KVw+5/hkNq8/ParxyRLTbBA4eXwRoQkUovkyprYIvIqtG3F3ZqMtXtnWw28m8lsZ3Gd5hOZ+BVtZteFZiVZvoEfUBbSWOZ9DYxadnLxWxrjWMfn2gdyj/7NWgYOQbGtOF8FP83lB27HncRn8lf2+yPUc
 4HuAKaRW
 XKjkh2xU7cNlYqg66F+dbbxQMw24+BcZE4Lnmwbv3kWwkhWlYVxl+pwzsb5cyGtrAZZqf/lQBfo2fGPQ6loWdRwDB291LRt7Qdei2YoE8PLTgSP5ird0ZelQ0DnNVU+AQ5lxi7yc1JcV7O1yd2ITnEXm4GOzqAOY+0o0MOTBg3TqvABa/cGARfW+M/rtTKfe9GHtxzwl0iTTzqGRhnk1FbWaW3X3nfnjYWzq4kwAQgBbANQm6nXfqrs2JAlLrAeXqCxmeijFtSKIkS2+BhSw7KgfEFBcXbIJ7mdZoKYY8yM/oRSEo3+7zF+NWjiv1yHch+y22uO1cUlmFTad4+4gVns8Natg4wz4LG9BQ25iKtxRMOfMtPjluxtBKB5sTByw7D6oel0WJrJB/V0sp2GfFiPXuqEfj4ZPUDo3P3q1QBiWKhsAmvEpdS1QpdKmIVVzK+b9me1vRb1cEsJNaLehnDAAQX2F1vx1/CUDTIjGotgyuESO2T8ylWx5zK1DkjG6hmK05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the mapping list for data attribute report types and user
keywords, for the USER_REPORT report type.  Use "user_report" as the
matching user keyword.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1c171af4590a8..b4d898ec0c9f7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1187,6 +1187,10 @@ struct damon_sysfs_report_type_name {
 
 static const struct damon_sysfs_report_type_name
 damon_sysfs_report_type_names[] = {
+	{
+		.type = DAMON_REPORT_TYPE_USER_REPORT,
+		.name = "user_report",
+	},
 };
 
 static ssize_t filter_report_type_show(struct kobject *kobj,
-- 
2.47.3

