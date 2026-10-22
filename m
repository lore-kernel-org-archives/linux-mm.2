Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D396E606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bok/gz/f
Received: by kanga.kvack.org (Postfix)
	id AAC4A6B0842; Wed, 21 Oct 2026 22:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A555A6B0844; Wed, 21 Oct 2026 22:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BDB6B0845; Wed, 21 Oct 2026 22:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3DA6B0842
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:22:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0597940740
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:22:15 +0000 (UTC)
X-FDA: 85348662630.12.9DA585E
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 328B940004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:22:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bok/gz/f";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 4ncienth@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
	b=Dsng3ozeyADI58a2JOFaq1GktQs9zCMmFfyVNEAPJ8ZPFIWKJL/tmjWYPbn6ZEUR7xSoG1
	dB3WEFq7DSVXd7JwaaIgd9Mv0vKHHH/gu7GxAP5cx/iN2KLSrgTPbE98IwUBHhC4gAZvN6
	bb3QdqqyM++ZdhK2VPFHS7KT+TaYIFo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bok/gz/f";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 4ncienth@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635733;
	b=K1yikqeIwDhGlTAL2UE4l+In+hoCVKGCheL2ZD5q2s2UIcF7l3WgFrhDs3TfwAFI3b2+bw
	FGBREuaaRthjIbt7cAXcsx7kCkApy8ByQHMAe1BECywHhdxKzUnGATmomnfeIv5yQyXoye
	mEmAenzib3PkbW8gXG5584rrXFKDHg8=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-368581df789so552090eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792635732; x=1793240532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
        b=bok/gz/f3z7bNMlHqjIuqHFviEpx9lneyvHWreHNuhrqmhaiPeh1NxQ4jg4qxLQ55a
         yeZ+9+U8UG4SWe1SA/6dtgRcPftXRz3QSXYY7iomHHm7r7SuMIGuEF/Fl82SC0Z06v9m
         +gtDSTn1A9Pmk1AzfVHypU03gEQJKkgoECCWd49pM5S3EyG2QYR06tOvcv7VbEauiGbB
         Aq+UA4ah5mnzszmMd6GZpUTR/sTbBVCFmU/ORWDK2jz7dlyw9s2n6DNeIdmgRlw2eqyS
         QWg4y/BWuhyNgLyJg6XjFoapu5IT3YgYKw7y3lqpAFKOSjc87kKOxQjtqP8q5oRu7fBh
         4idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792635732; x=1793240532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
        b=0Euq69nCkRVAmgSJspa1R/oYMgfdVVq2BGY26M8qZ7Z76D+eaw/K+ntnqo6MPBStuN
         6LD0Dd7+7TwRVitJI/FyLy9xOINLu940uq1oKM4fKJFmrE3qFFvGxjtlFTTg7N5vJT9O
         oW7Eor9yfWZm49EoCfpCnawbWweGZaD5ytpgMHs2xzza7Vm/8Edm7q+4U+5DlaLaVxmq
         KH+TmF7kiDzyxIkGAfLuKpF3AJmF2GgMQUqsGBDgzTdzNDDCPEVY2vCbT+fXokf8S4x3
         mqM7/OziNuTKvpftoZio/rEqRTNv482N/wS9LtTHO8obQvrUn04eqgldOTzwepHHqjHI
         Fw/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxr3wop5I7GH1BTgJbeZKAnz3LTdSKJ9elwkzULyUFhvcL1DI9alK2s84WCEN9RBEmQq9vyq5+S2g==@kvack.org
X-Gm-Message-State: AFq9FYLK8b7LVB16aaYt+IYzI5PYfh+4sH1JMlpvTa6IzZrz5QEbNFU5
	JwLct6vN3iH/jYIw3O1UkWfOezUYz+xd/So82XDh2/hTQQIMiaBaBgBP
X-Gm-Gg: AYBFou3oGmLkPzzmyJOuv1ilwXfkKozSLdeV5vSielfHmyh22xN0nyDa2yoV2Alay/t
	KL39yVN88DV6OZKB2Fup8bgRj0jPcTyMqIZ+itkQnMBN4W3zzKTYENmoFCHapolk8VdUZdMBl7e
	Omr3WCXg3Nn6cit8RmH+D4Y693PGj1awF99+t4GCUg4PYZF7gYbMrlScIPfXd+rTsAEWlzAweo+
	fRiwYS4WE9HrPHoMqtPgTDP1mVNW0sNG5Q2pcrsH7ApXt1GGqpGXdy0WFbKQKdxRyQmmEyLJ8jf
	9+iFnHS1r2icxhl8oM2T7y1Qh+zrbL+xtkPfLP2BdJxfnIfh8T4X1bOLQZNG/u9Kjkg6nOtVhFd
	W/YXz4vlegUwyAT2/5+Sote/TQBFbGcp0mYbdOmqTbImg6vmzi7O1+//iI2svuSPCfU/sen8Me9
	49Ozm1doXI7aiXz0EAkQt1p/RcOgw2WaiVznlExqrlPGp1GO0EPQY7lljXarWJKfeFP0HJ3ziar
	sdt8PztcSDFqq79bt09it5yej3T/2PqFnfIW8yoXg4EHo/6vbN8mVQkjEEGVvuepuIrMAh49jdv
	ulwU5YLVusqOTQ==
X-Received: by 2002:a05:7300:d407:b0:362:2e2f:c261 with SMTP id 5a478bee46e88-368b15180d8mr1246173eec.27.1792635731887;
        Wed, 21 Oct 2026 19:22:11 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367411bd27dsm12328555eec.17.2026.10.21.19.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:22:11 -0700 (PDT)
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
Subject: [PATCH v2] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Thu, 22 Oct 2026 11:21:46 +0900
Message-ID: <20261022022146.506005-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
References: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 328B940004
X-Rspam-User: 
X-Stat-Signature: iu7m8yc6p3zjo8c4eyqurj396z49uoi4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792635733-861404
X-HE-Meta: U2FsdGVkX1+yMItApWdFKEenDLl7o4m0bd77EppvOtpwk6DnKeuPneu223OkgSZwV0ZgJE0eLGsTU0nNGGXjqFQC6151JEPu0xLzI8O/0wiNWzPzkEKfWHrzpy7AD3onSnx5Q4f0/xr20ACopDAbxExqeeFO0iHV8Q1e3jVj0FuJI/GTD959A9x/7BJqJrVUIkqgI44VLcAYFjL21jujgLsri6O0Q3jc1MddTE08+SkEmB5AvxDvn2fm955zalkGrNrz98o5mIDKD2UBGFjh6aQ/U8a6XUZOgZw0024jVedxaOuXlHejgrJf+S15YDP1O2OwOwAPKGe4JOmWdDf334opxcoa31ed0bVDRuYgR5+gq2VRL+Etb1nX6RicOzYkmr0pZfU6LssFtKpvBxNY/fiLrt3g7IyjE3G7l22kazrJrJidQw3C/hB4lXPDTSlgKyVSuPRVSZoMvUMfVqp2kXyAooVAe+MXhpjufLecWPuMSAG+KFDEABqtRua7yXZ5HUMK0SWbBVUBYm67yhr+hxoqpc4AaedAoghw9JUel7bU1XpOo5BVpy5cJ+bMWY8RmGbsizuQyyBHHt3Qes0QecCtCGAK/DQJA5mTSGb5v7GidW0+EL4w287f4JfUZMJkBcJ+zt3De9WPrEmrL9BICJYiX8DfiyI1UpXyfQhAtSHTIqCqsCxEzhbacmE3I5LZEDxeiZJFkbRw4zXn27Dmxjp6ItNwLeCZ+PPAuMIYZdg8bF7QIjJOyeKBuH+G9EyU+6wcq1yAF1JW9+3SiLMwmijHUJpI1SuZmKI6px/1BikBJs6G5vssoqRsQyu3wgiszyNn4HAdK7+uyCmQswZx1h6floz0IQbuTlH4CLRAjFs7rDVPP34Z2oksSSWlCuDVVpUqGeY4aGitfUPotCevz49J98S2FUYwkPamqCMeEqytxDXQQLzn9tUBrb9wRGM2id7d7CMrrr14U2hVILf
 oIU4pl0+
 alXUzo5eW6eI5RBmXLIiVT+Ttc37nctJzAso2KZXGQQPkO0eOkqSiaPv3OHFuuPyMx/uTtjnBeq66JKny8Mq4tS2/DnmBU6Rdp7MIcjwwV7WAzJ1ACYJIhdFGnLYU0UthLTVx446PMJdkPVcMY6O992rXb9r7mfO5KUkUZo7h8l09rb3vo9SH9zINX6SALKpP6CAFK0QN5syg815a7oJGhljdzTDaw8eoQuKg/BLGMtFY73WzA6zWJw6GlNFHfokBdWsaCw6yN2+Na7R9PWbiuiELYjdlx6bgAUYUx0lJK3s/B5qbOYcoKIdfAFCi5EKOn4HRIBAVIalFpOjV3PPhM8uMTAcnVcRsXKcNjfBPnpdKs0HMT1HxHKfpyhMQ1TbQVWwtg+ICB/YCQKwimY+pfNZai6v9QP/ptux/3uLYjSh5ipkMHXH2aKfXM8AAiJ0Ca4RV4QYr5Gz9ZzhU2qrjM189v1VaaCN9nYbd
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
with over 1 million successful faults and 2,000 controller-disable rounds
with over 1.6 million successful faults completed without KASAN, LOCKDEP,
page-counter, or refcount reports.

AI-assisted source review was used to identify the race and to help draft
the reproducer and fix.  The interleaving and the resulting allocation,
free, and use-after-free stacks were verified with tracefs and KASAN.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
V1 -> V2:
- Remove the redundant disabled-controller check from uncharge, as requested
  by Andrew Morton.

v1: https://lore.kernel.org/r/20261020100345.1677643-1-4ncienth@gmail.com

 mm/hugetlb_cgroup.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7dc..6921b185726662 100644
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
@@ -419,15 +438,14 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					     struct hugetlb_cgroup *h_cg,
 					     bool rsvd)
 {
-	if (hugetlb_cgroup_disabled() || !h_cg)
+	if (!h_cg)
 		return;
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
 			      nr_pages);
 
-	if (rsvd)
-		css_put(&h_cg->css);
+	css_put(&h_cg->css);
 }
 
 void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,

