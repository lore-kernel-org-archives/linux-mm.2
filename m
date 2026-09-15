Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACCAC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DC96B0095; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492806B009E; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380D36B0093; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07BA46B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EBCAA423C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
X-FDA: 85214365404.19.291B749
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A59164000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hiyb8acw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438180;
	b=WIM1TgL+r/aomXvUNQwXTTKjHONWtboeWyzRs8V8t2T5V6WZXZZhKv8zmKuyhapJo5zw5R
	/R03DaktRK41SZYH+GrrGAGTbIdEstiAUQKR0PACEwoSSQ7li4qVeFB9eQdIysGE2cUELA
	p/Znuq3X71g+apxUksuycpW1h955AZw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hiyb8acw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	b=TskeEpqsku/+roV6/9SQb/JXJ3rI0Owey4b1Ob+On1RAeRP9rpaj5UL7Hon9/AlsYYnlOP
	fUomTVjKywm1zHWmK2fSGK4OQj2q09+VzlwhtTH7uBLv2+0ECWWJpp6Yzc0anXnJspAVhX
	UwCt55j+IfyPVF9GRuTyBJgIu97zCHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03DCD43F9F;
	Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD51F0089A;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438179;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hiyb8acwXAgqxym9KzuWX0MDr2xlqwBXaRVpzjPy+RObadhlgphPAVk3CXx2xBKgS
	 4TocPLG1FHRPYCvsShf4QeSoF21GhvYnqDTW4HqRkOPL/2nKwZ9+krR6p2chCztSqK
	 92TUv82mRYZcUdsDm1c871fRyaUM2/PJ9xReSRwaoo8ZCM0usYTXmkuzI8PT5FV47y
	 4qJP3WMB+gkeNlQxlO98c/NgHWKFtIGSwqKcuoPQqgUjiBiiWeL13QWsU4Q/J7Cgnp
	 iNLf5R57XyJwdt8aocOMHJ1RrlWij0nDLcIqXfGj9Apu98dAw/4rpsz7QGu6BHUTHo
	 JbGkI8CgQ+eyQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 5/8] mm/damon/sysfs: support hugepage_size probe filter
Date: Mon, 14 Sep 2026 19:09:24 -0700
Message-ID: <20260915020929.102953-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A59164000A
X-Stat-Signature: fiigg4w5rnb7nn8cp3r86d9tcqqw64wn
X-Rspam-User: 
X-HE-Tag: 1789438180-837648
X-HE-Meta: U2FsdGVkX1/YwPnn5hZOgWYvnAtzQBUcsK4F/DW9zM9thNpG3Cfjq3wX0HBAQqr3cbLTKOMPT6En5OoZuAgq8AznblTpJikwN+2uvcUGik9wJjnie+TYxj4v/oMxJ2fEosg1wvOJNoj/+97/I/kJgSyg2ya0zgt06y0vZWEGJrSjOAL9jKSNo/4z0oE3n20fY8v5kw/bY5LAjNATiqNrt16iKqAiIzXyPBIv6Q9UE0tFpO40vtnxWwChFGSNXHeax5+8KNktTVgy+ycAcQkQokFFlQdM2oxyET6WTwFNgAofp6XsdlTP1AZVJ0HxbXcs7vpPz+mQSYK9gYuCJH8f3+I/jI3HgAzVGL8uMJnocEDgZKVLv7AJUAOr6FupzQy6TQLrBLHjqQgqeZLEe8zWYrPqS4T/dhuE0gniDIU0xtxvvLANzmSe3b8e03S0KLxyXdy9UUprTPyXUc/74Vh56ka7QN3YSPq/9pGnIGfbTZ87aHNj521Gux1uUehPTCJDyu6nyTQClEziO3coAbdBeAZbSWilNSvmrk3PDt3hX01wxfRmFgoP+ZvZA06DeVAAgiw18MUp27JIVHHuKo01zmjG3/sndzPHKkkDG01mLZyDeZuWLO20+OSPbiCtOL4+fmYSs7CXkZaI9S3VCuuT7CboQCes6nMeXNMgKt/VptyyOpm+KNEjzfOcuqJvxYvztn3aWqe4b50RCFzaR0DV1fIIe3KYX3zldSlYULEGm46SYqtaemcYuz1+GOZvnVe+XoNChfogaGwI7RDzREX7YiEOO1a2mwQR2eZIkNRSsY6lc/c7/qMscRq4spDGxnacfCBLF2NTUwFCFm9vpflaViydS7di5hDK3CcET+NLn4UukDB2mIZJDGSeE/qi/vYySNubAgv0kiloq8hD/X/q8jA/lh4lYt6G5Uqe8JK8xh77GkB4AeqHtv7kSLVD+SD1aQ6g+zjhhePamJnp5Cl
 lyfuxD7i
 dtsGVbg9bq3KHWhuywCdmHitWSXYmC3qyyiBrQClbVefA4CkVHhV+9xA1kfTGdHFsKFOjuu7tUzhbffzsc8wOYQ0OlQo07t/3yu9WZKDtj6kMjok512ZMimJWmS3CYmH+iZR3Gs6g8811SdQMeSG7+pgdWeCwCppi1XJ4/Mgj/M4hEKM+V5lukrejhqDiyhukEPpZBx2U4QCincNke+kkJ/Om62ewQXEUheZbBYW8j2OY4uH3dMazlyIJi6bwJUSuQ1PgBEv4rad8jdpIQKvOzQfinA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support hugepage_size probe filter.
Allows hugepage_size user string input to the filter type file.  Pass
the size range argument that users set via min/max files under the probe
filter directory to the DAMON core.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 8e8d89b8ed981..43519afb9eb7f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1007,6 +1007,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
 		.name = "pgidle_set",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2273,6 +2277,9 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 				damon_destroy_filter(filter);
 				return err;
 			}
+		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
+			filter->range_min = sys_filter->range_min;
+			filter->range_max = sys_filter->range_max;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

