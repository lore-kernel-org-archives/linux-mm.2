Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F730ECD6FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DD66B0089; Wed, 11 Feb 2026 19:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683116B008A; Wed, 11 Feb 2026 19:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571D46B008C; Wed, 11 Feb 2026 19:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43CAE6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 078F31B3A1B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:31 +0000 (UTC)
X-FDA: 84433941102.18.92A8AFC
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37ACC120006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GC+zlI9J;
	spf=pass (imf29.hostedemail.com: domain of 3xyCNaQsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xyCNaQsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JnA227LuyuHWxtahECJXUZ4BvkZ1hdR9r/VpPR8oGw=;
	b=TPWYA9IkD3AaXXDtFrDGaWjjl3DwrwSNGgWlHiqndSc39xRYe2t57JZjddXsUUGZf8jwRS
	sKmHT4iHCr2DnhbawJwh5imAao79dN9KGxfGwV9y2V4Jvl6CqgBSaYcSY6w1mbrfUV+99k
	CzGqaohme/D27iRNhIi3mWjFSW+saHQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GC+zlI9J;
	spf=pass (imf29.hostedemail.com: domain of 3xyCNaQsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xyCNaQsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856649; a=rsa-sha256;
	cv=none;
	b=hUPW/NveCNjZvhnEV7CEj4G/hUC5CRjQkL1PMnPBobk3YH26zQVmCkuHMGIzkJz8ymhaM4
	kcI1Z+qiZbBAylzSis3KTvARetY0VNAqE/4mJii1L7AbpGjOJ09jRwUiY4jmbZGJJ1Sryz
	e5YdSyGxYEkc9O+o8tIyImLte2KGS48=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354bc535546so5660731a91.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856648; x=1771461448; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2JnA227LuyuHWxtahECJXUZ4BvkZ1hdR9r/VpPR8oGw=;
        b=GC+zlI9JKhabj/9dXB/TXklJmEBRvOjZuLvJQ2npgjB1/Zid2YnlO/WeNC/PD0ju8z
         AMbt0zRrAUIDP4dEU6CBhYJ8U6Qtuyv258YlnHVc/n64g9LPVSfZ8cMMBezs0/aEIEBb
         uOfeONpLAxu5pTzgCIA3DcKfP728FLfZX5F+zNCRv3R3bPf/VBpS5pXLrZvb4JRK+L8H
         zhq3cJJ84dMB5YgdJ+gQ0kvvxcec4FDdlurr5dEmlZa1Yrh92pFXGi3aUfsQUK5ICpkY
         fmxJ5/L4CMpdlJCyVahfbt66XaQGbKgy0qJoLvxOB1O/FdkctoCy7Hgwj7NTDhTPvfNT
         RtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856648; x=1771461448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2JnA227LuyuHWxtahECJXUZ4BvkZ1hdR9r/VpPR8oGw=;
        b=o42LVPdoaaS8ipYUGTZRPY84KbONdgN35kkXE5WhNBuRbRfUArNv0hr2CF8QVM5JOd
         2MikiezBgCHV04HQIuRX2WMJtozE61wVDpSA4a7koNvPcEdVDu9K0/4urgW6ILrARdDM
         MlZGU+cC39bXYWFH4IDA/e2QWUl7Ii/LTCPRn2RwM/Vv7hDGQtz77zgFdgTWe+Brpn6W
         JbIXRzm6dq9PeXV8EX4qe/u28Im+Lvaj0AElBxH+FdTTpyxMHTBvoIwKCTE8P/u9XWEt
         QRQvUvZ7IBTsKE6k3fkHymZxI0fIihGr6onMt8v941qi0cs3NNu2KIVzc/ZRce7Pa7BQ
         m44w==
X-Forwarded-Encrypted: i=1; AJvYcCUMdQX595LpSJ8UQA3MxYXbw4OKcBKThBQQfEhhpJl9J71W8Hky/qRweFd7GdxWH5/rqiy+bfMz8g==@kvack.org
X-Gm-Message-State: AOJu0Yzmy700fJidxRfLsokzAoKHAqpW7StPurYNTFD1sViQ/e1KIxaS
	RBAznTiCbL3qEijXoJJi8theVGQOXWXhFEMrXyy+RxFFcJt+E39JSCiQ47TuQ30jG0g974Z69Lf
	3eVGbXejejlKLjgg1Kx70h9GGQw==
X-Received: from pgbdo14.prod.google.com ([2002:a05:6a02:e8e:b0:c6c:9940:fac3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:495:b0:38d:ebdc:3546 with SMTP id adf61e73a8af0-39448477cb9mr923997637.6.1770856647927;
 Wed, 11 Feb 2026 16:37:27 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:12 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <fa4172f57caf8fd3013d13d96211de6bb8cf6d38.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 1/7] mm: hugetlb: Consolidate interpretation of gbl_chg
 within alloc_hugetlb_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6hkcnnb8kuxhdshrrwrzk47odhbu41mx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37ACC120006
X-HE-Tag: 1770856648-691606
X-HE-Meta: U2FsdGVkX1/ExQCK79cahmtpqjHnVcB8M8RX6TPKmg5RvhvfkiBA+6WcizmzUSoStfNykjjEVo25W/St0lD8K2SX19UnIT1WWA8PiEVnOO/GrP1DwdL7eT/N1DOSj7+z98i177IyBrEakXHAvcDvM8eHx4gWMqRcsWNe6c/dYLDGbgow6BP8Do4VMjjA4zIMYEkxzTWGuYDNYK7tIz0ON/wCJKMk70xVjIEMp+KJ3XRm2NvtaLeVDYrHBdW/qp60vtU4+T+S/DWPYwq8x6BZf9aDr0j5GkKo+02wqUa8ouTsPTj52JWvLgIuywlJPPEd7PFmmz/awW9qqJkQF1PbJzeToHRQYBpwFBlc1CxNe3uOsBqlovGP9qImMeCgg1tg/I+n9mWfUNJ+eK6dy+BAeN7YiEGjZHUyVRcbvdzMfhe5n9cFuiCMCaglsHyWKO9YYeQnQwFhNnqATXvI2VLOhaKWOd9KlrWKQR/taVBYjziU+1haSEfcxE1GdzZHT46DkOPaxvnqgAraJfJoQky7myDZdhY7Mmfseh0L6wZ4jds3MdQZzUDeZITpQ1vLjgr/mXIhqmQ8nvCXVSjqH5I+AmtEYAJCUGh32W9lQWiWxHSo0RU0qR686cb/CzoErNQWaZS+SQnV/PKM0ydOKxWRWu2f6BI/7AZx8CwlsvNI/RZVUDSkNMss5nz6VEM4aoD3DiuTzYOhDhOberGv3h2OxbykneobcqfSHPlV3ILFmna4t3E7bm3u+XUrUYDKEk2BjFf1EzJ0mSVGwlS2SW8mXiozQapqlIRY92UCHbl8Vehr7lw8qcbacrOlRN7+DOjtYWevpR61xnL9m3vM4yJ1Jpn6osYr5quIevzwOTtUe/mxmKAfwnuEUGSiaIYdjZAUzAFDvELYlLAT3uqekELE1yElY7D+Ms6ejcaHfv0kephgTN2LvxYlG+IEuknswXrMFIjuN8U50slVvzAz6UG
 TX7q1FJd
 HUTqEGjQlXyGXoO9C21Y8fWxaeWovjKr3/rwTLYqq7ThjGMIA3NULmxzTkjd1qikG1aYL8Wd8TS1/ROTao1MjmYy78iHeG/y9gjpE+nvphyZvWueM6AiDO+SEcx9r/VBHwKxu+ivfC572wEjeWjPxRROlV3K2bAvuM+hqsT10eKHcVusV4pRat3Le5bZk8mZrISXyRecUHLtcifoTle0PWmRfcR3r/JE3eYnGnDC2qhqzmTXundAxM+NbkQiBJOJmRPHVOgZGS9hq5Xeei4jYNH8FiJYBGu+TPEb+5HhDyMmhcm2Vkff/lnSP5nSVNVTmgbsAvCoUpNRxKOM5yXAM7e0/+7LwQoyooILHcFvAaAXbReDD61yH2HJvVy8iGBDZaWqcXAxJH0ojcn6gEENUPUqiTI4gia9bP59VR+chLrjMyi8XC+EPFG8Zyqc+5VRPY3Gt1K09D8oTloiCusZsvxc9zMdpmRa2qSV9icu5JSaK+otoSzDmvmgdpdiWWwkZcwYSJ1PyGJCYqqPa4IVhEIXhGqCtpvX5nAq2XEsVHl73QFSkkZIsWEueuPhgkDVNoYTQU43mAWQx94jCCe35DO3NiwT2p62+n6Bb9HPOE3w3LJrN1hkWMufL+5IQuQU699l8wcFZJsBxY282V6JrxEnDvx/AOBwyQzKWBs6igt9gtEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, gbl_chg was passed from alloc_hugetlb_folio() into
dequeue_hugetlb_folio_vma(), leaking the concept of gbl_chg into
dequeue_hugetlb_folio_vma().

This patch consolidates the interpretation of gbl_chg into
alloc_hugetlb_folio(), also renaming dequeue_hugetlb_folio_vma() to
dequeue_hugetlb_folio() so dequeue_hugetlb_folio() can just focus on
dequeuing a folio.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1832da0f6236..fd067bd394ee0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1380,7 +1380,7 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long gbl_chg)
+				unsigned long address)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1388,13 +1388,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	int nid;
 
-	/*
-	 * gbl_chg==1 means the allocation requires a new page that was not
-	 * reserved before.  Making sure there's at least one free page.
-	 */
-	if (gbl_chg && !available_huge_pages(h))
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1412,9 +1405,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 	mpol_cond_put(mpol);
 	return folio;
-
-err:
-	return NULL;
 }
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
@@ -2962,12 +2952,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_uncharge_cgroup_reservation;
 
 	spin_lock_irq(&hugetlb_lock);
+
 	/*
-	 * glb_chg is passed to indicate whether or not a page must be taken
-	 * from the global free pool (global change).  gbl_chg == 0 indicates
-	 * a reservation exists for the allocation.
+	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
+	 * try dequeuing a page. If there are available_huge_pages(), try using
+	 * them!
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = NULL;
+	if (!gbl_chg || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
-- 
2.53.0.310.g728cabbaf7-goog


