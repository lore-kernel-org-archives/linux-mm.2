Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C51C3C43602
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B9A6B00AF; Sun, 28 Jun 2026 18:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8344F6B00B1; Sun, 28 Jun 2026 18:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3626B00B2; Sun, 28 Jun 2026 18:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8E26B00AF
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6E538E3B4
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:32 +0000 (UTC)
X-FDA: 84930693624.04.9D1CC22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2A87EC0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsJUW92c;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684091;
	b=7dbYnExRSe13rHWe5K8XzhvLXmMfzJjboOS4XqyClYc0QQ8CtWD+1kP4PSoKBxKpWh/MDq
	XjQPdvgQynyr9Dkr1BdqNNH04vQ/htRR5pkxOnyNCjFFj/CNMhv1Omk/W/CRQR0uA9VmvE
	9kV/VnlDKRt1afMa5EEqU0VURu4Fzgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGvHa5tYAkEF4rEB2p2YMvPKhuvQYixaBRxfKvPf83g=;
	b=kdbgZzMbUq52qlEPRM/0nRe+gryo5JITSd5YiKcBaEKiTkNemRDecvhx89WSLMYzvm9Nre
	BoocmBVs2rxj76g5NW10rhQxvV5Ehbt4P4887vmuaAOUN7WDLvrxZTk8UKiM27nOI9J8bY
	rHFJsLD/A5mQW+MdyrjziSiT+aYDvbY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsJUW92c;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 781F843D5C;
	Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339DB1F00A3A;
	Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684090;
	bh=hGvHa5tYAkEF4rEB2p2YMvPKhuvQYixaBRxfKvPf83g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsJUW92cGcgXzmfE5Cl1tSjzny41PlHDmRuN+PtYodY46D8cHIVHe0C5VL9WO6Qi3
	 LOfS8C/HodvSXQkndzhRImzWg9X2v13W6Gy6DEiSYaYPn+YioEc8BxTgh0mz29bAMR
	 c4JxnIOjXJOswqok3QcLOpFNbujsBEjrxrfEno3HkLRvnubkEWXaP11d8kU/PnTZrF
	 Pm6HO9a8WdwfXRYF30NaIPSOgXcaAPNMiSJ7rK1K/PrgMr6zakhtKOx0kFmw6U6oHZ
	 CQsJNhSXDmVHdzz+ks6i7cQHPvPxsI0kS7PeWkazYCIUM6aJGR1vagMs9T4Kn+3JQ7
	 YkxKf0Khk4Jig==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] mm/damon/sysfs-schemes: kobject_del() region for populate_region error
Date: Sun, 28 Jun 2026 15:01:20 -0700
Message-ID: <20260628220121.97360-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r15us39dk6ur6xbx1us9yd1zzy649oqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A87EC0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782684090-702508
X-HE-Meta: U2FsdGVkX182LUJ/kjn9Sw9x/22fpLgKIBvLG+pLnAAinskxDkQVKZzjTJoCJb+8WeME0VPGVFZHxNaKGK4S6EIiGjfVYaE517vLM7Av5SIK2uraNgoih+cztgjz4SHd/1swwHzZEfzYmqsuFnEaeDlGXHfoms8SV4VHilsk4d1sz8gFe1xa/COS8eIPyUysVVFknKnDjlNs2bxGBBEnDBaLPkkbFx2wjH6VlK988a5k2jwEBm4sLkAm8yvcU9bPVrZZDQvDLYRnPx6njYoGoRQueIrybXEfAAjtpFpdOy3fXRtc5IKJWF6LKFA3T/TJw8rguL2q1lvgQKPXE4cwh89/SxlXfcVxGxAkVailWLPu39FVCxkwG/jgPiy0n84tkqe8kRdEYggU0j7Ul90zfQoWY01gfzfwHgz9freuvkXWvv+2a8DL2gVLA4MICcg9lVNEFaG1a/e4noZqDrCofNVdt+IS88sRBNvYlTOUIiqOSy2M8DxhMUMPB3M+6xHSrW48GBiORxCZSgMCPWtnOHRy/6CRlxl1Jqw5WYL27vLlgml4mppN4us3kNnw5VFGO+sXY2zDz0JMC9G+E08BskPB/AOR5QoeQOkZDxjJYFhN+pN5ySPLz0t32ECyyFZOmBJxxiDfB5FQa607uE+tG7egLnDRUg2oUgQcHakhReXCK4HQJ+7EKxco9TbcqZciXPNPChxWvAfQdQc3fMxGlgu3owvERYnufHYJjaJlumJhcBn88iWv4swlOGu6AJvZmfvPpxlJUUueXyGof2gZAlocqS4h5AN/63FhVuedHKeA66dm1WAF6g2rYnswdPGCfkXMBAU8reTmb7/UpEecr+eDHGp/5JkqhAt96jdC/HcGXjIWl5MJwjfSVVImjkMcy0UkvG1SNImcAwyHlFhmY8q72IxmP4QngBrEPThiVnWZBjBnaluiBDhQzxcJS2dj82vgibaVHcSwh+JpJeN
 8RA3jx3G
 4hhn0tKXCKF8N72i+Pu2tIFoFmsQO+8UFYoE0L+/lBx2D16U3ijUEcx5YYEJ6Sj6e5oOp0u+Y2t+UQZdiIT/SPdnhAT8armg4QNI+DqBqXnOqolruDC4T6/hIbWSxnwQytHlQO0t9S5zRrygFJCjGTGq7Dpa6ZWJ5K/MtVTmBCBGkM4IUPtByAVvVSdrVYKUk+JJKQEM+GvKDvGWaRDwQ/BFPcTuzKHNwdFyUwcKzrCKFULo3iLyGPrOnKXKiC7vpu9Bfql6Mz9AJ9ayPN2K3mcPrGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for tried region directories in the error handling path of
damon_sysfs_populate_region_dir() by adding a kobject_del() call.

Fixes: b574a82d10de ("mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/")
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index e2c8716be6c9c..41f93a1823bf1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -3132,12 +3132,14 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				sysfs_regions->nr_regions))
 		goto out;
 	if (damos_sysfs_region_add_dirs(region, ctx, r))
-		goto out;
+		goto del_out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	return;
 
+del_out:
+	kobject_del(&region->kobj);
 out:
 	kobject_put(&region->kobj);
 }
-- 
2.47.3

