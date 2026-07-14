Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2DAC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90F26B0096; Tue, 14 Jul 2026 10:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68DE6B0098; Tue, 14 Jul 2026 10:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E146B009B; Tue, 14 Jul 2026 10:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A72F96B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A14AC03B7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:30 +0000 (UTC)
X-FDA: 84987544740.01.7EA9ED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3167C40028
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpXX+MXd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/jz9927dvpD5avqF3TGJEv1UpRwfeRrTrpzU9XDfBE=;
	b=g83qEcss+9/nwlm7Hal6/RUAJNnAeJpkkTABt0FBYRldZUiR/+Dj5ocKXX1vcNXt9LA8RF
	zUXNzhwLyywR1hOBzp44oQup66QHv7OlUyX39l09Ksk4bg4p6olhTn2OsfoPUZFLRxwPUS
	3QH1KC9xouGQ4waeNrwKPpshA6qHZco=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpXX+MXd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037688;
	b=n71lf+aZ89lOYKAWpX2upaFz8gXSdqsKvxfHQc5QJ8uLnk4INkVwIDcinVGC+ynnl0xMu4
	xeMpEgjuebiAoXXKalxKqrawN3gzPAisEINtVVTyMhFQ7KUhsGHlOpci4k2mUnJObmaZOp
	d3KyM7iH0irulQaNZqTfxdik89xftVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51486419C2;
	Tue, 14 Jul 2026 14:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A1C1F00A3A;
	Tue, 14 Jul 2026 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037687;
	bh=S/jz9927dvpD5avqF3TGJEv1UpRwfeRrTrpzU9XDfBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpXX+MXdKkQe71SzGUVmEz4k5XIIG0ZX3M3umvXkQ0LjXr9yBzoEptFInp71ay5Oy
	 87h1faAOXLoUVfhxjjaQxnFbPAjprhMRqqqbj2XC1KNz6kJAz//9BBc5xt7/wQJhRP
	 9oMpQTkGk8/oMIYz59RfEBzsBvcZ720SxhVnqvV7PaatzwR63v5xoJ8n4GG7w9PrQg
	 gviVPEDbq1QQo0emxb/k8duZhNQSEpZ3Jb8EuNdfQAHX8wunwWE5JVupUvN06MW6uG
	 wFOdYUFcZ5jwDGcnF4tcQR9Z9YiTWBMT1KMGfTA016d6lsaLn83XYU4iApGCthInsj
	 dsX8Fcky9J44A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/4] Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Tue, 14 Jul 2026 07:01:13 -0700
Message-ID: <20260714140117.94147-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714140117.94147-1-sj@kernel.org>
References: <20260714140117.94147-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e8ujjn9wy4bdcnwbhqsmhcxwkxdbdqqd
X-Rspamd-Queue-Id: 3167C40028
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784037688-701631
X-HE-Meta: U2FsdGVkX191Gy5/8XISPU+KONFkacwNKVGAwPAdocjZ20AgF/0ul0D4BLUz2TCtzNvDCVErhXxSAvfuG9P1tr7oThgWPxyHJVt73YB05jPvoVzICBp8Bdr0ukCDbEjpKoR526jsbhNIAUpjiF/2g+jpyTFQAmQ/Y9RNOmyCYKCWme74sYjHzSmcG8RKnWZSK5K9YlYTCpogu91huK/LlXF2yrppoDS2Uju6nuJtkPP4iqTiV8Ltw/SrZM24Z9LbpxSQHH4oFsTg4myGWsi/gjLaFvUpe+sU7bqjCxgeOsWZXiI9Avc3reB/a9BFPi82fhOsJcEygG4LAg/nY6FBJvdoLw5B5TwBmKYMswCzkSk81yB4pHPTRUnPhczb2aBWpM4RNcsmKvBCzxYLEAogwaCW2paJfY+dyXr41UjU2VSf8BVQ5+3fa9/ZfnePlCmUJop5J1IuG7YF7/Hl9AWqdj4LBwmAoPVUCWdMQB/i0bUcoMGjQpY/EGBcFOOmDpEyB99X5NmVOtLZUN9XpE+17SbF1gHoW7qzROo5F3f3fkvpdQCRj59HyrobQZFKWa4n9iDyf1py6225vBGgxzQOlhCGeoH04zO90AkAXbZHUlu943pJAFHDKW+Qc8fKUJgq/QcrSEOyIT6V9rnvzD8yMKfVWfZw5j225+WJSV19RWgObf5W0v+rWxn5+84Cw2dzLEIjaotwtSnvzklU/lcea0rJGFnUKJ5433Vk3GAmFWH54CVk3uy9oY/tycyPtEjbFUwIG5CvXCd9LbQ2uNsJ/mjBdTNrR8FJsa3tvYXzFWno/cDlk7CKuAOSjASPrf8xotFJeXITcM8j1b6vuR1arTZRZMnmLU/dZvl3rOy+1CUAaoycy+WQ6mYpVqfPk+HCWsR50eqI+fiD/c0YGv/NoN8qh8XMUC7AXl3q77LIsQvvRt63RQtCSOBHPmheftDzIhHdb+dG0dARaH14qOR
 EvXtfmli
 yDPn8Q1K2MnSfTkAnKHfHdPl1dwwc1bdCcDYtrsL0JUXzlBnpujJsuPuFYvhWeckQyDXpVvxF7oc0Z5mV9mEF63QxWN0uYfBDXeI6PKw0uPYSm/sjhu4soOcjPyiTnRLIKwwCzcnkqx/aZE7qUhqI0jHrswArpaCuKVkSx/eer/wyWljuSKUn/cpDIECAx+Aob6IQFyKcsl/dhS9xSNRVSVhowu53PMpsY/7pXtMfqi4eudI6kpkjg2gRVdIYJNlaBtFThkCw50ceyBjEnoMwuVdk0BbK8RDb9fbZQYd1gdcDyi8vrTBvs6hkjbKqNZiDj/+1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The ABI document spells the DAMON sysfs directory as "intrvals_goal"
(missing 'e') in four What: entries, but the kernel creates it as
"intervals_goal" (mm/damon/sysfs.c).  Following the documented path
therefore yields a non-existent directory.

Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
Cc: stable@vger.kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 907a504fb64c5..a8269123b4231 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -112,7 +112,7 @@ Description:	Writing a value to this file sets the update interval of the
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/access_bp
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
@@ -120,7 +120,7 @@ Description:	Writing a value to this file sets the monitoring intervals
 		the given time interval (aggrs in same directory), in bp
 		(1/10,000).  Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/aggrs
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
@@ -128,14 +128,14 @@ Description:	Writing a value to this file sets the time interval to achieve
 		access events ratio (access_bp in same directory) within.
 		Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/min_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/max_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of
-- 
2.47.3

