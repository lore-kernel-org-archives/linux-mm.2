Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D20CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346076B0092; Mon, 28 Sep 2026 15:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFA96B009B; Mon, 28 Sep 2026 15:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DFB6B0092; Mon, 28 Sep 2026 15:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA7AA6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 662C116011B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:54 +0000 (UTC)
X-FDA: 85264145988.29.60DB78E
Received: from mail-oi2-f42.google.com (mail-oi2-f42.google.com [74.125.231.234])
	by imf08.hostedemail.com (Postfix) with ESMTP id 960E516000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k3eGGkfi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHveE+gpiQTTbGsR6xfcK57TMqcWcGFoeOvQiQqSmeo=;
	b=pbxMmUN/9E8Vz66qf7wJIMio5P3Tx7hyOQnyj9WqPXKF6WyqNahCW/UNrxhS+egEMP40E9
	V/iIvXSlKiMpES3tdXcyESByXStnQ1CMr6hYZUJpI+kFDRDha4pJk1RgxQG9RruVEqUgRE
	K3WCX0Mh98CjUgMBuRbnQv1RLg26rXs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k3eGGkfi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623432;
	b=OTmLF+Sf6kIq7s2koGI9nsc02c1BSKRMfw3h+khl6x5+ACXYaEh2qJlCErk/ia310Y1/Az
	lgWknOeUPaF+0VWb5WyQx4aSerVxN02hYQ9Htu19dpADQWXYBZvRuQTKjJXbknyeK7nA7l
	rGHU/nUF3MfJk8emwHfKL8eympyOFh8=
Received: by mail-oi2-f42.google.com with SMTP id 5614622812f47-4e7d0e42662so846335b6e.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623431; x=1791228231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WHveE+gpiQTTbGsR6xfcK57TMqcWcGFoeOvQiQqSmeo=;
        b=k3eGGkfirZ8yoTHmiPSoEEfSWv9qaGrqv15eH+GSy3sVWfI2jO4eXY+AUkDJmtqzzi
         olxOBqFcI1+ZBffbc9r0aIomdGMHJaiv1v/nn52A2rMZHv0xeR4kdYGOwaRtt8S71/bJ
         jHeo0r86UFNci45iylY5PV7z/JYVYyM6EM0QMSxm41Eor+XD7DVHZ8yRC+Iz+SCh/zAE
         qJhbCPu6yFSuG/yEuOqNXDkZ8s9NxFkSeV3j4OndXZWdFy+YFgROQ4wqvNw9uYImHr2m
         ELFBEhTnmxPrnBG2OHJYYBI06MZylmj+C56m3vjRKvpiJuRDYu+ytcb2hHvl2KlaWXs2
         PVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623431; x=1791228231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WHveE+gpiQTTbGsR6xfcK57TMqcWcGFoeOvQiQqSmeo=;
        b=FcG7A23HW+ks7HpK3ggmFWeL6VYthdcIKUxDdKKEFmDxzUETrVhDx4sa2L68veKOGN
         2CbWZVSunJtOJJpraBnaVC88Al99dvqM/PD3EQr7kQwsOhMxKnBED8qt/eAjyTztFYXD
         EHSyVwUAePvazrYvcULzTrY+fZJ7rjLqKcKRKrVrEt1+/HsMEkUIcQHZ1JyWAj9GU/hc
         UgmSsYusTnLnEeQXJifLAwamxUoH70T7xi0P2C0GcoA7/1Ah2lv3ZbbMU9fJlzpibkVD
         UFnhDk/ONIo0Lo1zczbNT/4fuuZjfLOdf/WdwRSaPElnSXIkkTcWhdLcKxEkq/TqoBK9
         So0w==
X-Forwarded-Encrypted: i=1; AKwUvBy9biztMjUBONyfD/OiO9jmJW3HQp4nKl/Wa+nR2rB3WyeQoY06ur20S+U/cr8lB1FyxrW+UMKjmw==@kvack.org
X-Gm-Message-State: AFuF++mkCbVxo9gjOROlFik5wnVHdkfNG98YQPoAlYVinWAEkcd9fk6i
	NaXwKNw1SfDWBnWQ8UVCKkrmSxw7wvf0r/e2/QzANxFXn3euVqBdxddI
X-Gm-Gg: AYBFou1rStc/DHsH2LKdV19GaKEnzwOMRQt+OJ2gPiXpYlCfnBgh/W1RB0oiW30brb5
	BSwrsx1Y0dfM+Q6aRfFJDNiwmcozOYYpsPS17c+eU4frbmevLFL56brxQetZVzqM8hrB8ir7jwG
	B8hBS5Y9Q+UEKes91sMWEnVw+mbBuq3e5WLH8YS6xWA7P9OcOQE5dtZb9lGqwq709vjTnXpYnzV
	19M/B7v0T6O3I5aCyyddqKYK1YdOEGWiPHXblpqi2Ucjg7ODOeyXjtxT+1K3Mal6DdvCE1H40fg
	30mjkpgs35GW3xuZwY9F9hmApRzQ7QGmtnAY1c6LWJWjldsGc7BvCzn5LVLLCIPLV252dNeSGue
	SB2iaealTJIDfB01Le2D/AAt3KFoGp2I2wbMH0+d/ax6rkROX6sceY3/FSfK4pKS1NDIdUu3moU
	MZ+uGZPmZ1civGwBKa01sEtvPTdivKD5OAEfcUNYhfQmhdXWpHU6puODdKh1mCymOfJrhJ/eqsU
	UDtIzSXrFX3msaAR/5YuOdX52Yu5w==
X-Received: by 2002:a05:6808:10d6:b0:4d6:9232:b3c0 with SMTP id 5614622812f47-4d72cd363ccmr16423959b6e.55.1790623431516;
        Mon, 28 Sep 2026 12:23:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ebbc7b7acesm2515978b6e.11.2026.09.28.12.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 RESEND 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Mon, 28 Sep 2026 12:23:44 -0700
Message-ID: <20260928192349.3432886-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xumuiudc4o3ir6te5a8qd397gqbp6kwe
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 960E516000D
X-HE-Tag: 1790623432-498984
X-HE-Meta: U2FsdGVkX19Q5dxTJpXGa7EzAzncONrzr0WgM/OHtvrSgIi6krjixTMfosukCRiCCMblBG3NGUcO77o3FhDjn+4subzhI6L5fEU/s8uzDh2KMhk8mYIRQ/zTIRJ9ibM+OPiqEaH9SucBBznVSxsJMRq81Tq97X/h+aPbW/RFpOMp/kzBmch3CntwxdJXi3Gc6uNHKhCXK2rx7g/bbWGboSAu4xh4pTHCtSm8+9oAZO3WQoG+64VzqRF6QkeKHbkeWO+NTVwokQqqoKN37KAUFeVtnLOTMAxh5Hg73yFVFi6lF+hBJiioRNT6leuXohRHHbHnZFTKOXSanW/RVZJpHeZNqLr2xmsNUOUjQppL5IxFryKBH5xKkrE9Si7TVssac22QyUidSd0n/Cwm1UWaahkM79PmBTolXATtYjgm6uk82uL71ibtRxhGA6QaCigJbP9LVwA7aaOmBzz8tuaYm0OxyZC4vdRMdhHKiEHTgFWCUq/h3cS9gsrHBjC2inmxCMynYwVTK3G0HVm5jJgBx5uqfIDT4ET8Si8jbyH6HS0eo3BILbA60h4yRynLa3jRd9piMB9G05A2bdR5ZZgK4gO8+pPV2rjuD+EG/6UCuhPXtgHPAYntoGwb3haBwhEPvBIubvlyFl3rc70AmXI1EETZzNrryy25DhHzToWeSL7HD3nKXFcUcA/1IE4qf8juAMjkvtsI3WEQlrP6+cgPbA9whEPRwWqkSCP850JqLus7DmoHocsybtbRvki7u4/SkLkUHR+7CUDGnDaA/wk8fbnDmaSRYc9BtYkCo151MHpUNohgBnkkYp5QyBr994hEoCc8XAn3bWFKqjkQS9IMrrX1YfXfWdsfAS2b+njld80Jd1xD6SL8iTdJd8jZFoEBkWXsex0kjDy3iyLPoUDYRTlJNQEVm+KE5QI1R4ou7xM/85AKQI0s9CBeiogsSrr/FmXPZU9DzAu0NlpQjVM
 1zHDYzUc
 EZ4ScPGISCsuA79G0RqAUDNxmdjdGJMSfMcJTnfXRnwUFPTwK2OoueTF4azvncKlPVvQ8upknnowe6lXFCBU8WEQwD1hmIn3k2jzT3EOhj5eavlbfgO4QTM1pm+Y+xp4wiU5sL2NQ0idzKUvsp/vYOLLJ5hj/ebSAPbhDFqbY9QvxrsKeJ0nN3BUh+WVerUtURkOMLUoGtlCx2SBOJJq7E145qbIhb8kTUDb6TIkQ8ZPie36LQ3fNUEMDgVXWSRRyN/jyefguVQmlEQWVFfaFatAMABj2R9d823yw5Hds16U+XokDiC+Zyu6wfOeSoEd0BWYn3RDFYbb8UFhhW0IZGG/tzQFSC3O9m3mqVIGp6K4tRXJw6ZVh1uWLyVmOAaT3u70z13MS0ohddeoxkPX30BYuRjTr2ePZB46wQCh7RGo5DlE+EjT+ImP6Ab0Qa+uWcRe8R3qxQnMQFe8HeQvK0eWpp1vtHKgC/0ewBLvrJzHfHMWvvHVhfRW4X/Do+ymR2GyGtz+rnorJ4chD1uIjPTFC466G4wAi5Uq3Quf1AqO0HJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd65..edb2da5a326c5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2721,18 +2721,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


