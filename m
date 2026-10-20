Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20457606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NJMlwJi3
Received: by kanga.kvack.org (Postfix)
	id 3755D6B046D; Tue, 20 Oct 2026 06:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325C36B046E; Tue, 20 Oct 2026 06:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE0D6B046F; Tue, 20 Oct 2026 06:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEE206B046D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:04:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8294E160960
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:04:03 +0000 (UTC)
X-FDA: 85342568766.26.AB04E57
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7591100009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:04:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJMlwJi3;
	spf=pass (imf14.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792490641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
	b=ZvM8sVN/2hDBT43Rni3UeBEnxiAEK2hmUVnBXXSUJvoJhDxefmQ7R8TgAGdz616zdvctTN
	KWluMPlVghAvLAy/hxZPrUAc+tK0FwbEQyZXBjTks7plvbFP6kJaCoXjBea9x9h3gCxJgx
	QRNw+MzZX+jGsOIlglHgR1k7/0P3uKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792490641;
	b=vsNV/3Lmd2TM1cNluf6FJFHxNPFJgfsHK0FbVRHpBmfF7K6Fhxg3O2Ei74qAlAFG6k1f7y
	VP7ZL8Vow5NqDYRohmqIStNwgMWkiDNjq9tt/d/QgZqjPfiUXYtizSWb+HrBj5EnEUaaPD
	WSh6fkFUT8qd/yZhj4SseVUwTynIjJM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJMlwJi3;
	spf=pass (imf14.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso1175057a12.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792490640; x=1793095440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
        b=NJMlwJi3a5bqpu2HTDnpXWWJLpNufI03QMJgzMu8w97R+ad7Xlm6UaYF4vzD/Pgqvs
         sSuM0w0QSQ/qXP0ML5ZXI8Kdjg/JWAFQz0tPw9QZZGxTHSmhykTWHEkY2rthLIRA/cOI
         aqnoL/6BEtM0tZgx4Gx7CI/oTEUQOwxPDdWb1UHgm3041Wln5p1xv3xHvNnBs3WBNDF2
         Z0y/9bwnftrVS5zhz9HsJ/sU3Us0AZkjtwUMpsamHQTMEz/0DNtkZJdglhQgL5XnOauh
         mmjWuOH0uMzlEDF4yk+j9zM5aQUtca3+URKZB1M2p+FHyQM+qvAYovK1USfrgfaYMF5+
         yrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792490640; x=1793095440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
        b=UJq9LuQMR+eVap+KeD4PibicD1M1m98jxykAzqgL4rnuVZ8Hv6pSlTbvicQuJbZwfp
         DUm1FEfyDAgxugWbpKnOXGNEoo595eLc7z+5iiEbqUXNspz209ikn4p7NYJ7WMVqeQE3
         nbvMmpDyqRgv992dxXIm4saTxEfEqxeGKoPMJ5KnYobA4RsUv53G0CG6g8eK+myOwf/Y
         ZEZrWUJ51g8oC3Fh6Lf6SqihSPxRQx6uiyymzcM2YJ5BlPP+omJEPqGbx44LQfzm5dp3
         N9NxCtmcM+adboFxKOe+vxThzm5EnEG9MQJrkgR/lYpeYTUlxPBxXMjxMS+W27XFiUgP
         7SFQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJLizdmWNQBlPeTWvKP2UGuYn67ZyBBC/QFl/ctr96j6CxhCeSABWmmiPz5bK7itHHcnA3nkL0+g==@kvack.org
X-Gm-Message-State: AFq9FYK3jk4ZlzBsVol3o9Wb1t81+1XsgPtjsSvPJNifMtJLV9qoc2J4
	bf1b46CTBEVBk+5G+EYy87Uznp5maoa/m8BsWL/NotJVC9pPCVQAmKeD
X-Gm-Gg: AYBFou2mxKn+xfRR6Yqa9JIhrrZUXyYLFhIETo/AH3c5zShsFvDBfwl+Lvnw2hsnYm4
	zexa7cpPJZl4rPVsPLODe1cFSSm2hKlKD0rYm1PhQG1RalzF/a12slfranZ88TvtSjLfEbL6HjW
	V9/427XBUzWbnEaQh2E/SqhRGTk3oLYIZTSbZTGjVMPV5qE1SI3HttnpuwFjVBqxhS3HDs494Jy
	MHPsEp6k8Aai1oCvt12749JKWH8mHRtcZ+rkKqb4InvqQ3Y1Fk4Oy6tmf8U3BmLOS0zkLossdkD
	dXNT+dvTQDkAzV258vrECgUUdSU0lzNDAhZEeruvsG7PctBb5MdGJk1C3SA8I2JaspKWuu+hQP6
	hbYPvan196udPd84S/KNv1cgHWeWa4eW80Af5vgz+2HGQedMc90YlyZ48JeqMbdvTN1Lu5+Y3HE
	MZWIvdxixt1umSn085wIg/aedxasMkuEzBBTU2IZhs+NQuEEJW4YEpryJeiYpUtVUGD8GJ7FB3P
	S9kG1ifML4=
X-Received: by 2002:a17:90b:582d:b0:3ab:c674:cad9 with SMTP id 98e67ed59e1d1-3acef519dddmr9226879a91.54.1792490640339;
        Tue, 20 Oct 2026 03:04:00 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5c72df56sm3203446a91.0.2026.10.20.03.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 03:03:59 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Tue, 20 Oct 2026 19:03:45 +0900
Message-ID: <20261020100345.1677643-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B7591100009
X-Stat-Signature: y5c5apdzxbxxc663un7awneborei6cqp
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792490641-37585
X-HE-Meta: U2FsdGVkX1/Oy27AXoUQU+++kZCCGSLqhgi4/C+fzcge7+kuKmQm4QV9vUiI3uLh+RhRjWcUT62oIKMmdRwGWCyc3wvyFbtytPNPe8HqrmVjxxiq2NY5h69TD850FTDrAahFKMcBO2EUiLDkCx1DNc8PweLkHFBmGBhBvofNtqQe8A3OwgNck2cUNJhgMUm5bUPgas3MozRVq4xidAkJ665MPZcuMlEzuUqeBqfpr+3lHcbCRleh6iRlLJHmxG4iUN1V6mnr5SugAhUNZBKkjUIQFbqSUypD+Kd2Mrsi1J863SesGeM57vKF/RB/Cc/MmD9pCGbhptASK37ZnUmBttktT0KDqD0Uma3mcSNAm7KHsfjyQ3xoFTP4dncmthz0phwUspcxPB0mxQUuFCQgleB6F05iN70aqTw3sRmVwFV6tFDWpYOW9P+ZWTSX3wYd/lo85nBLqYkLNJRLVexqulDfr2YNdginYhbvdx4nD9d2f6LjoLDHpgeupbA2/KltZgYwjMXTr50eNIeNevYVVaKnZFrpppt8kuSonruViygz6XBxkKesYbVQ0pGaf4yIHvHxde8YCuhOB1li4AqWZfeljUcpyAnFQNzr19GbRYWQ1VwJl4uXZjJVUPJRVLlr4PjOLuDM216hjRW6r17Bjvagx74DAHWepBt9TvXHYn8Qs7Y/YQNJHwsnoAt5TEOlHfKx2UM6CdIEoMX4Q6rxGx6YWZsdMRKVMBtgdHtlOcvQV8bHFgTJXya7GaTZWLUsEP90KI7xBZhTaso1R6X7rb/4ShM9JU/N6Bj0U/1dBHmVyWOxEh3tv9BH0VYSQWCdQFTQoWYJT0JN/pXvOjPaG1vb43CZtIgelXSsD3lAazzTQ6zFWCy5i+gtdY71EMlDXX01YHfbee4O9zkeb5lf/upq6mxkTSgpT0tbMeAnVSSodO1px/wxFhpp99pkQ4CsHBLsFD0DWk937HAuTIK
 uQznkmNe
 qmVRujM1lvbJBonOSB5YA1YuOYjeHHDchslSGsoX1yjAZmyc5waTyCYCzk5ry2XRYYwFegWVozCG/O+iC8Mcan/1eHPbtsC3nz+mzOFqZU+WW1ejRTUV1QsJ9BQWqIRfdqJr/3vTzcqaK/6MzcKH3B1hb7sSwX8VX8+shKhRLh7rxIySnkYdLc2XvLbQaE4AXY/pyODEzS9gcpKtXB8bgxqt4elQNYzUzjXX2dswbfolCQdAROtf3pDY0tt9jYodDRytNFCG+Rb+E0KUTnRmPTmBfHQqyZjpK+egeTrnUtS/BnvU1uCU0RQcRsi8oX/EfOGeBz9mO/dmIAoSp/kYm5ufN2UaDkQFpQ21wlMQ9SP4zzQILHlY9R4bpxyvD64WQNOWj4HiSBBSYcKlsptZlBSOSB49ZBURjYlLs9xlXsCHTjCCADB+m45ceVjO5vf4nddWG9mq+qm/E0uabzW/mQggtcbt+38C1tTfYMZwZB//GFEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A normal hugetlb charge obtains the current task's hugetlb cgroup with
css_tryget(), charges its page counter, and drops the CSS reference before
the folio is committed under hugetlb_lock.

The task can be migrated while the allocation is in progress.  If the old
CSS is then offlined, its final active-folio scan can finish before the
charge becomes visible.  The allocation can subsequently charge that dying
CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
the folio accesses the freed hugetlb_cgroup, including its page counter and
per-node usage.

Keep the reference acquired by the charge until commit or cancellation.  At
commit time, while holding hugetlb_lock, move an uncommitted charge out of
each dying CSS to the first live ancestor.  The hierarchical charge already
includes every ancestor, so moving it only requires canceling each dying
CSS's local count.

This orders commit against the offline active-folio scan: either the scan
runs after commit and reparents the folio, or commit observes the dying CSS
after the scan and selects a live ancestor.  The retained reference also
keeps the originally selected hugetlb_cgroup alive through this decision.
Reservation charges retain their existing CSS lifetime and are not
reparented.

On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
capability-free uid 1000 allocator racing administrator rmdir reproduced
KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
disable reproduced the same fault.  With this change, 5,000 rmdir rounds
with 1,075,055 successful faults and 2,000 controller-disable rounds with
1,707,348 successful faults completed without KASAN, LOCKDEP, page-counter,
or refcount reports.

AI-assisted source review was used to identify the race and to help draft
the reproducer and fix.  The interleaving and the resulting allocation,
free, and use-after-free stacks were verified with tracefs and KASAN.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 mm/hugetlb_cgroup.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7d..1e0dec070b05f 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -310,11 +310,10 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 		css_put(&h_cg->css);
 		goto done;
 	}
-	/* Reservations take a reference to the css because they do not get
-	 * reparented.
+	/*
+	 * Hold the CSS reference until commit. Reservations keep it longer
+	 * because they are not reparented.
 	 */
-	if (!rsvd)
-		css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
 	return ret;
@@ -337,9 +336,26 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg,
 					   struct folio *folio, bool rsvd)
 {
+	struct hugetlb_cgroup *charged_h_cg = h_cg;
+
 	if (hugetlb_cgroup_disabled() || !h_cg)
-		return;
+		goto out;
 	lockdep_assert_held(&hugetlb_lock);
+
+	/*
+	 * A task can be migrated after selecting h_cg. Once offlining starts,
+	 * redirect the uncommitted charge to a live ancestor. hugetlb_lock
+	 * serializes this decision with the offline scan, which reparents
+	 * earlier commits.
+	 */
+	if (!rsvd) {
+		while (css_is_dying(&h_cg->css)) {
+			page_counter_cancel(&h_cg->hugepage[idx], nr_pages);
+			/* The root CSS never dies. */
+			h_cg = parent_hugetlb_cgroup(h_cg);
+		}
+	}
+
 	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
@@ -352,6 +368,9 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage + nr_pages);
 	}
+out:
+	if (!rsvd && charged_h_cg)
+		css_put(&charged_h_cg->css);
 }
 
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
@@ -419,15 +438,17 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					     struct hugetlb_cgroup *h_cg,
 					     bool rsvd)
 {
-	if (hugetlb_cgroup_disabled() || !h_cg)
+	if (!h_cg)
 		return;
 
-	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
-								   rsvd),
-			      nr_pages);
+	if (!hugetlb_cgroup_disabled()) {
+		struct page_counter *counter;
 
-	if (rsvd)
-		css_put(&h_cg->css);
+		counter = __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd);
+		page_counter_uncharge(counter, nr_pages);
+	}
+
+	css_put(&h_cg->css);
 }
 
 void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,

