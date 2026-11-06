Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6A8606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aWF8SOo9
Received: by kanga.kvack.org (Postfix)
	id 07AE16B05B1; Fri,  6 Nov 2026 01:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B686B05B7; Fri,  6 Nov 2026 01:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38256B05B8; Fri,  6 Nov 2026 01:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD3CF6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:05:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDC9840D16
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:05:52 +0000 (UTC)
X-FDA: 85403658144.04.3B1A5C1
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 147F340006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:05:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aWF8SOo9;
	spf=pass (imf11.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793945151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
	b=twlKQhjy56/SN1C3rC0TrMpWaSF1Yds+oFbw1rTjXnF/xVdto3W/ur+c5NBCZEOn5MR+MY
	cpb0S3vRG//tZq/ywGEOn4W2jmHP5KQM6OY/xWzUviKWsJDBNvjMxrARDLaO4DnqdOJOtX
	yN106AxqN4nWHsFGRA0XG6RmEvbPxTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793945151;
	b=frbv3260byoLi5zoIN8culcmCQxPz6Y8yrPbxzQTrmt9vSClxeXqu91ma08kJr82pp4Lof
	tjh2IXy1fDrkPLsTC1By8e2WKeydfbvPTj3erJFqir6u4JWDuMiWvoVel5GPY++Wn30aGo
	oNTgfrmmTNwzrZSrd6DrvglrM+L4RAQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aWF8SOo9;
	spf=pass (imf11.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a070781f63so115197b3a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 22:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793945150; x=1794549950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
        b=aWF8SOo980hHZtDvlVlJxca2Ck4IjDOKYp675uk64kFl1q1My3zRx+QfOqyRWrll4S
         zTOWy2P+cjXLPZCSZhQIb471VXWrlICDbcXlNDUC4pLowfT1JW+Fnn0YVs3q6g21LEhz
         bwPFMvVtEhKEyLl/wpU32G8QKTY4CDmoCHI4VXWPXJ21EUy0zv7Y3C/ItBRzja+iWSrt
         vsSisLkPEy5a7ZjC3gCBMhN7R4aL2L5RtDNUZMACV1W8EI4xsRLkmbeDnBrfmayRP23j
         1UhdLZlYS42tvJf3TOe+q5fuVwvQMxJ3SQdjmVduULiJOOFIuDiDEJSETZKx60ObqwfV
         H6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793945150; x=1794549950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QYzpgT5zWntgfM1mnEHxsXKCCGNOpHFfMxgWgIGdnmY=;
        b=HVpcJNiT7WruurLSk7eWnG/ow8a1f/f9wObSygyRaKAlb1v/YCrBiKXcTx9MomWZvs
         bHy8dZyVD4kZvd6Z9RWANBToHj8ifSqCN7lf91PIVpOssqKWyueP2xZddZH3p2+ZXbLe
         DY2Zshh6F4ZevWIOm2NpvlB6QYBITp+F0WWFpFE3jOsQIpl60YWZLbpum9oX3g6iXVun
         xZkoe2zJnZHrDJ6KFktM+eqVPX8rgcBfBGoY5Laz8XWPUz1cJRghOtzuy14zAaANtj3c
         9Pn48tqN9RgOl9vmdwqfcAChKrI1SpmwAWAbm+EJLj6sivkrxYKmYU8XBmBv/eFEoeJ0
         UtEA==
X-Forwarded-Encrypted: i=1; AKwUvBx780VlxLhALZZRPIgjOpUpGYpW42WteWsykGtYEOMKAraaw6myCJt/UXZXMvzwSPmTfWT4Axr6JQ==@kvack.org
X-Gm-Message-State: APuU4Z/rk/80fc+Sh1XEa9neTG4Rm36GKCF1/WYErAD0Q+9WNFs3Xk+R
	72RQUN6uGFKN9KCorDWCoK+OxA4ApE/fXTBR7FMMkg0pOcnzDmIPyrzP
X-Gm-Gg: AYBFou27eV7odeyhpEoEGlxj6xJb9lbjd23Hd5voWoJRUKwCfyi/a3y0c5CgnZz4mqB
	LSlquydNslpsElB7U5mKx3L7ig4Og1jxwgyLkv1HGEUxy+24Rce9JtvVly6UDQVTxzw8J9HH4Hf
	w1hdtuZF7Kcg5jW+1mBB21CTeb7nKfDVflNjxs3wl15JX424W2p4VEkOPDLubBsLRxnghgrfgfq
	kp+UqjINtS71NVQCMPfuF8G3mN5OhP9NLDnTI6AEgZesMelgzUC126uSCXFsTrnUhbulrPF3QIy
	QaftsYN7ywYtC+YyZVBeOIm/EzPB08yVydBDsasJUpNnXsWfpkaBHWJGFxNB4gWMOUUI7woQfiL
	YM9uaJMqhf9+iDgkxZVYvaRjhdAzemcvHQaZ2iOePm/QbQjE5aHn9HVYpUbvMVntraklcI3a8I+
	MlK5PP5hsRdMln7YxotVfQSjsoiW9WUMRPA1WdWgpdA5vEGtPbBGEdryxmEcy/8Xo0UyFwKQ4Ox
	ie39JuUXJz2jcXQdpjOrK6MFoKvvRfAvhTc7aPp0qTPmsPKSFQ69f2cbfSRk+LadD+TiOzUd0Hi
	Sl9B8w74ZwAN7X/vk/cxyKTBKFL7rMIdFu8Lysi0tg==
X-Received: by 2002:a05:6a20:9e97:b0:3eb:ace1:4b4a with SMTP id adf61e73a8af0-3ebb2addc3cmr1804269637.71.1793945149791;
        Thu, 05 Nov 2026 22:05:49 -0800 (PST)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb70661c74sm241209a12.10.2026.11.05.22.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 22:05:49 -0800 (PST)
From: Daehyeon Ko <4ncienth@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	hongfu.li@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	4ncienth@gmail.com
Subject: [PATCH v2 RESEND] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Fri,  6 Nov 2026 15:03:47 +0900
Message-ID: <20261106060347.637480-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 147F340006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b143f7sfm4atwbkcggkb6ppiu1jencph
X-Rspam-User: 
X-HE-Tag: 1793945150-826260
X-HE-Meta: U2FsdGVkX1+Tym9YxHnJ/bzqa8z2mUBmv3yhTRpm26b6emYk50emxf2mmCSDL/fiL+y1CigqA+UKI0ZJ1hl3xHGexjfAyAUzH+g04U6sxIrTZ8pGb4o9Ab6A27+jnKT++yLLJMfFqJZoYAsCayWS8gFH8h6buBhIywU3NgeshZ3/I6sh14Us6UeHjsviFWH+i0lGqFllbMGAD2E2Gi1IS58GEA6m/OSut9rfedI44fm/qtAyvYWU/MSvwA+lfe5SbihPe6TPowvrAbvt4g77oo+kfzyK5HOi/3efFKd4U1ZE34M63Q3uo/hqQditbKgp6Vthtx5YusJkZwH4x4htCJilcjJ1YciXt2dlv9HmcYBZU2D2VErSjd28TwykqVgwOaEOXnbde7/aJhb4TKJ+HIjhxYmJUgRbxB+cw9G1lJl7J5+PZXietFFXYA+VTs8wjRDjE+cLil6hndoQfmZyPZeZB6+TbxRFZGm+zhSfRJ31ee+umuILvmn2smn0UVm3PaXOAp5wTjr3qkhTltT9oh88Y+s0g8MFkNA2UpQ/oAieYS8FeYymzW3r9j84+LXugBQc/x4vIWE4itesylq//RAluMc1GPtsrct3CcY7WRS3rbV22iU89Ybh+Vyr6nopJ2B+RYw9xG6xhoAWwEGXlL9mgOyZR3lM6oge0l78eKJ0HngLPLN1AaLXv8ksHQct2VuKKHLyp5/YzOu6I3I+lAxUVxiw7NxwTulivbiwVRHEyyEKI6Fif4W9hSgtdxr/ToO/uiJUVQ3u/jYGQD/8tEaCLzM+sjttvb4TUvEFsfeWbgcV6DJjPxvwt/De12W9X7M08wFX0qG3O+PEmDWQvQRHT6t6Fng5N9uzYKPTxHpijgSMXyQzNigrouRxpSfVs1JdF76svnTbCwb7lBm4mC1DqiXbliTLx2qQgA6L6BJbECcJe1VTKlbO7izU3NiFiRefxdhKLX6Ys6SbgnV
 fBFlfPom
 VPYlV9du3i2GQmUCuukLqdkSw45pExpGxPbALw4taPyJRikuPbUxl0lls7GRgxYtGMd8hvFZL+I/qlzCS3qrYnkqevjd/Ipx+uxo11zQH6M814l/+WYqgXMejV3M+BhR4G+iFIkgFiaDcJpJ6/8gPwhDSGkc0abHPyPUSi9SklzYSOh3NsmUIsTy+eylG4Zc/urXVjp1OP1YASfQfBwXHTLS+9FgdJgi+gxAureSlnvvODjPrlCtBxfQ8LsgYjB8PYxfYrNJNVGhqMCCEMjECOfYy35/J15L1RJYrSipUg9iaPfnKpaXRq5VyAZ1StpslYvEMXBD1BZYZUD31IFpXqqcBjDF7fYukPGG5MZvfqUdJbR8s+CkndoTEPlY27yF86tRQqR5NOgV7nhkynHgZY5h20F4zMFPV+5QGxlpYzJki0n647gzfF8y3xBRX2DkdD4PxS6uMtSOSayiChAj4blhof23O0uZuy6sPAanZLmnZmow=
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
V2 RESEND:
- Resend v2 unchanged as a standalone thread for easier tracking, as
  suggested by Hongfu Li.

V1 -> V2:
- Remove the redundant disabled-controller check from uncharge, as requested
  by Andrew Morton.

v2: https://lore.kernel.org/r/20261022022146.506005-1-4ncienth@gmail.com
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

