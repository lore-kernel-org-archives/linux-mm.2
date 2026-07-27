Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D236C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453286B00A4; Mon, 27 Jul 2026 05:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A206B00A6; Mon, 27 Jul 2026 05:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367E16B00A7; Mon, 27 Jul 2026 05:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41EA6B00A4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:55:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 905F81A069F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:55:05 +0000 (UTC)
X-FDA: 85034098170.07.9934946
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9CBD40005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:55:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8PrvI/x";
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785146103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S2hz6V8QOq2FoxNPi2D/VAkz7DZY9JJoq6y4/9kAtM=;
	b=QwiV6qXrWD/ukqGGYMUhlPw4lfl20L2oRk20fey3AYikHsD8vpymSVLKKy2sLliDOPRoVT
	Os8pJy3LNy/wfOLXk6WQQb0YUILPSR6dlUERZu9XK+Tql7XgOhUZIQE78ifudjGavh4vbM
	QlQzlBM9SjaZoQN+AQfX7vQc9/ckA6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785146103;
	b=sI8ods7IsmDf3Ca1PEOZvJr3158QHusHlbptj5VNHkLm2erVOJ/9MWXw5ctDDDZqVgys7x
	rt9giwdA5wbcZVx6b6njKAhV/KzzM39a3L7y0hjXS6s3OU2DdnHjPmV2PfiqyiTGhHWnag
	MqO7r/ra5+L5QtdIuIumwTBnCZJtpXQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8PrvI/x";
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785146102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4S2hz6V8QOq2FoxNPi2D/VAkz7DZY9JJoq6y4/9kAtM=;
	b=r8PrvI/xfkIOMDWzLyjbYwMOybQXPbwReqifnm5e4usOGvTfzjWTwFn+6BRKZGFs8MP7Ag
	73gL588KcsHdk3RjF1vXvm2lRz9kGW2YAU453d9xjIz68SLSIFx1IMz1AlGfN4jT/gBp32
	o+TmU35e1u0qUH9uzlNp9u1wXCi56A0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/sysfs-schemes: report the number of tried regions
Date: Mon, 27 Jul 2026 17:54:23 +0800
Message-ID: <20260727095429.143527-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260727095429.143527-1-jiayuan.chen@linux.dev>
References: <20260727095429.143527-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nrcgpaqqe7h7jj5qcxbqzza1kxwjwdqj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9CBD40005
X-HE-Tag: 1785146103-356223
X-HE-Meta: U2FsdGVkX1/oGgvIUUYb66+ZbKGc7a5hyi0+UlRG8VtXb63kkE2p3No0ifdVfN11Mex8lo1idgH9ShjhVaHWE3abcLfJ0F8g/14p1mXYgLRkkvbODP1QZ4ZKnyYMtWtVOKieNfloLqFCX/ugfwnZCrgmSMBNBH/t8UGLzPtXGgEq8uuWeaECFc1hosGm3H+clwQJQmr3t6wR8ZuMsvdU6KdorwmlCzfqqpS/ML5zWltjBANSdj2WCM/ZR8Uu5rNiPa712w1d7f43TPfflHaGW39Kk/Olb+ryM52xwWzBPSintKS8vl9AgGAPQVH9PfP/rh98U3hr+njNwcoeYsVJvUsHym25vqLQo+sO8wjA31LmHHB3dcwmVDag0VQ7oDvhf0bbudI49nVlemK2gDhDzwQGsalFC1misjI9+HC7n/YTAn3gx3X5tzByFpqvXCh/IKQYKpePVFuxqu0FNfGK8CuRwyYnC7tyZ5f9zQrxWlAt+uQZUQedlVpM60Aixhu7CZLK8r9AA5X1G44ukuEK+c9Lmi/BhlnSJhcNrcXf+Anisaw9QaX91y6S5SYMBe01FOSsTgnNqb96x+eyMloUQPYlV6wZb4+KOO5L//vRv2H/cv2g4QExRLtqu4ug0qOiCAMx2rpywxdlwXM6Z70XOZO10eFyD/ZE3NguuA7krK08QF0pg89wTk3WQ3EaxFUh7p8s0I0q7De9gtcTmcKtn0xzrybYGbujzFzwX9+OV0Ysk5b6hSLSKG/anaIyaGQr0qsyujcWN03HFN7+sqX4mAk6c+etzZAsRYwW/KJkh5ceXOOQZHWC89M5lsmPEbTSMhG+Db1wtXU6O94ysvw/UISX3lPlIdBPTfY/x0HFTLRpLpw69qZp1LiF5AHCjGnBzzAFJU/ihqbqlpRtHr4WMJ/X8t4hT2vf7vOcRkH8GLUhwi8zqkG5hlN0yxccSNmiTYi2sh7/ou9YvpLXJtT
 OHZ/Mz+o
 swBvy+J/+qrYEtHk/Ry6z/WEPv5MRqG6314yXUJ3XrFRhf7iPxDhn+YxGF+zEm3Qs7I8f+YUYK1WqhII2vzsTqDAq9dCvkf7r+e2NfOBXN7QrqpRrCePmzbSVwi3NQyzRdnhCdCuKQDVSVwOJTWVvofnmHgTyhZFtmRnlTRnM5FsCJWV6Y2ZHa0oQMPlxivsN4VJ/3hFLOHbvNlsxC0ZMvDdV860SnBIVSnCm7lTpcrRNdDP+cEK1FsJT1Nuei0G8B3C+oq4IyTHuSj3ezHF9nk5+tSCqHIB5r9x0iIzETDYHllKxtm3b7ydujWkwy2zexguS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

The 'tried_regions' directory of each DAMON sysfs scheme exposes the memory
regions that the scheme's action has been tried to be applied to, as
per-region subdirectories.  It also has a 'total_bytes' file that reports
the total size of those regions without materializing the per-region
subdirectories, so that users can cheaply retrieve the aggregated result.

The number of the tried regions is another useful aggregated metric.  When
the scheme's access pattern is not restrictive, it approximates the number
of the adaptive monitoring regions of the context, which users may want to
watch, e.g., to see how well the monitoring is refined under a given
max_nr_regions, or to feed fleet wide access pattern dashboards.
Retrieving it currently requires materializing all the per-region
subdirectories (via writing 'update_schemes_tried_regions') and counting
them, which is unnecessarily expensive for users that only need the count.

Add a 'nr_regions' file to the 'tried_regions' directory.  Like
'total_bytes', it is updated by both 'update_schemes_tried_bytes' and
'update_schemes_tried_regions', so it can be read as a lightweight counter
without materializing the per-region subdirectories.

Suggested-by: SeongJae Park <sj@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 10 +++++++
 Documentation/admin-guide/mm/damon/usage.rst  | 27 ++++++++++---------
 mm/damon/sysfs-schemes.c                      | 23 +++++++++++++---
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 786be4537da1..a6e8f5036555 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -622,6 +622,16 @@ Description:	Writing a number to this file sets the upper limit of
 		nr_snapshots that deactivates the scheme when the limit is
 		reached or exceeded.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/nr_regions
+Date:		Aug 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the number of regions that
+		corresponding DAMON-based Operation Scheme's action has tried
+		to be applied.  The number is updated together with
+		'.../tried_regions/total_bytes' by writing 'update_schemes_tried_bytes'
+		or 'update_schemes_tried_regions' to the relevant 'state' file, and
+		hence can be read without materializing the per-region directories.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SJ Park <sj@kernel.org>
diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index f6048fc04263..9152ce09de9d 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -108,7 +108,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
-    │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
+    │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/nr_regions,total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
     │ │ │ │ │ │ │ │ │ │ 0/hits
@@ -671,21 +671,24 @@ relevant ``kdamonds/<N>/state`` file.  Refer to :ref:`kdamond directory
 schemes/<N>/tried_regions/
 --------------------------
 
-This directory initially has one file, ``total_bytes``.
+This directory initially has two files, ``nr_regions`` and ``total_bytes``.
 
 When a special keyword, ``update_schemes_tried_regions``, is written to the
-relevant ``kdamonds/<N>/state`` file, DAMON updates the ``total_bytes`` file so
-that reading it returns the total size of the scheme tried regions, and creates
-directories named integer starting from ``0`` under this directory.  Each
-directory contains files exposing detailed information about each of the memory
-region that the corresponding scheme's ``action`` has tried to be applied under
-this directory, during next :ref:`apply interval <damon_design_damos>` of the
-corresponding scheme.  The information includes address range, ``nr_accesses``,
-and ``age`` of the region.
+relevant ``kdamonds/<N>/state`` file, DAMON updates the ``nr_regions`` and
+``total_bytes`` files so that reading them returns the number and the total size
+of the scheme tried regions, respectively, and creates directories named
+integer starting from ``0`` under this directory.  Each directory contains files
+exposing detailed information about each of the memory region that the
+corresponding scheme's ``action`` has tried to be applied under this directory,
+during next :ref:`apply interval <damon_design_damos>` of the corresponding
+scheme.  The information includes address range, ``nr_accesses``, and ``age`` of
+the region.
 
 Writing ``update_schemes_tried_bytes`` to the relevant ``kdamonds/<N>/state``
-file will only update the ``total_bytes`` file, and will not create the
-subdirectories.
+file will only update the ``nr_regions`` and ``total_bytes`` files, and will not
+create the subdirectories.  Hence ``nr_regions`` can be used as a lightweight way
+to read the number of the scheme tried regions without materializing the
+per-region subdirectories.
 
 The directories will be removed when another special keyword,
 ``clear_schemes_tried_regions``, is written to the relevant
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 54ff196f8e24..b1df9f21c267 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -297,6 +297,7 @@ static const struct kobj_type damon_sysfs_scheme_region_ktype = {
 struct damon_sysfs_scheme_regions {
 	struct kobject kobj;
 	struct list_head regions_list;
+	int nr_region_dirs;
 	int nr_regions;
 	unsigned long total_bytes;
 };
@@ -311,11 +312,21 @@ damon_sysfs_scheme_regions_alloc(void)
 
 	regions->kobj = (struct kobject){};
 	INIT_LIST_HEAD(&regions->regions_list);
+	regions->nr_region_dirs = 0;
 	regions->nr_regions = 0;
 	regions->total_bytes = 0;
 	return regions;
 }
 
+static ssize_t nr_regions_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_regions *regions = container_of(kobj,
+			struct damon_sysfs_scheme_regions, kobj);
+
+	return sysfs_emit(buf, "%d\n", regions->nr_regions);
+}
+
 static ssize_t total_bytes_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -335,7 +346,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 		list_del(&r->list);
 		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
-		regions->nr_regions--;
+		regions->nr_region_dirs--;
 	}
 }
 
@@ -344,10 +355,14 @@ static void damon_sysfs_scheme_regions_release(struct kobject *kobj)
 	kfree(container_of(kobj, struct damon_sysfs_scheme_regions, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_scheme_regions_nr_regions_attr =
+		__ATTR_RO_MODE(nr_regions, 0400);
+
 static struct kobj_attribute damon_sysfs_scheme_regions_total_bytes_attr =
 		__ATTR_RO_MODE(total_bytes, 0400);
 
 static struct attribute *damon_sysfs_scheme_regions_attrs[] = {
+	&damon_sysfs_scheme_regions_nr_regions_attr.attr,
 	&damon_sysfs_scheme_regions_total_bytes_attr.attr,
 	NULL,
 };
@@ -3133,6 +3148,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 		return;
 
 	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
+	sysfs_regions->nr_regions++;
 	sysfs_regions->total_bytes += r->ar.end - r->ar.start;
 	if (total_bytes_only)
 		return;
@@ -3144,13 +3160,13 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions))
+				sysfs_regions->nr_region_dirs))
 		goto out;
 	if (damos_sysfs_region_add_dirs(region, ctx, r))
 		goto del_out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
+	sysfs_regions->nr_region_dirs++;
 	return;
 
 del_out:
@@ -3170,6 +3186,7 @@ int damon_sysfs_schemes_clear_regions(
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		damon_sysfs_scheme_regions_rm_dirs(
 				sysfs_scheme->tried_regions);
+		sysfs_scheme->tried_regions->nr_regions = 0;
 		sysfs_scheme->tried_regions->total_bytes = 0;
 	}
 	return 0;
-- 
2.43.0


