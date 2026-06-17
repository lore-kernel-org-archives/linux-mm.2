Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C621CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E910E6B008C; Wed, 17 Jun 2026 09:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19F56B0092; Wed, 17 Jun 2026 09:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57DE6B0093; Wed, 17 Jun 2026 09:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABC816B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:56:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34B0A8DCF2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:27 +0000 (UTC)
X-FDA: 84889554414.14.A492AD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 97E3E100014
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVk4GCzT;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781704585;
	b=WhAdB0oJg+4uvgftnlmcfww1mOHytE2mtCZPD+QSx4RYOGuVWzo8LQmps7mo+HlNl++oFZ
	K4WdgVEbbF7wnKU9ExP8Js0qSCbL9okhjSeHGkUVINSl3K2IgdVfF+TziytUurOwGSQSbs
	uP1llvnq7wv/WShWK8Ubt0AUk8ZwSg4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVk4GCzT;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vj1ysZXTzQEftM04gbB5WCu/uXQrIziK86sFp/rbmQE=;
	b=Svk61n4Jr0VKZwFJChqY2HTUIeQTrwJN413ENU3rwgxvuzVLERYDBhQ8waJeRrwdAwzv9Y
	AzVqvnQNarA/kGK0YUyhhoxhPaqDGzaZK4ir1jeNrDS73B0Rj3AnplKbqZFqtc6cBIxOk5
	1v3OzFegA4MY2GF3umEmVqjznVy4+Ik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3911E600BB;
	Wed, 17 Jun 2026 13:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F41F000E9;
	Wed, 17 Jun 2026 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781704584;
	bh=vj1ysZXTzQEftM04gbB5WCu/uXQrIziK86sFp/rbmQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVk4GCzTydE/VLXFS5zavJfEcO6uZLU2RKW/qhmY52zZCbEorj0GM+0/Vud/iv/PI
	 LPbrfX9J8N84b7NgCyNa6wB/kJVW3Ab6DHBo8/YQ7+HHircHPDZottMoq9go0iphnt
	 fUcTic3wlW+OUwlLI0qJYDGvEPMiIrE9NB+zzYjNk2r+pcf8deMyFVde1dYpa7HTwN
	 0LOuiX8U916o4spNlKBTeENGx60RiowdiyXDG1FYTW2SjeKO/txFrI2p5MvYwQHjRe
	 km88rPO5Od7bX0RJ95nhn3ETVF/vLTWZGRtMu1zTmSK6ArfAPUoozGPv8NGTqlArr1
	 vge2G+TQPiDTA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/2] mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Wed, 17 Jun 2026 06:55:49 -0700
Message-ID: <20260617135551.86013-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617135551.86013-1-sj@kernel.org>
References: <20260617135551.86013-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97E3E100014
X-Rspam-User: 
X-Stat-Signature: dm34gfxi7789zf6dqt34s7ofxan1qctf
X-HE-Tag: 1781704585-897319
X-HE-Meta: U2FsdGVkX18zuIqVMtzaDiDQHHb1dT4OwrISyZAql8+e6lwlfcKUVyTe5xdXABfxO+81iD2zU28v/xZRZ8tAimAxAeDYia00j0qGeCY2u7EG5VlI3AE8QVLVvX7jp3ZWTLc3xSijljedaM9FWUZCv8fjCIlFDihDg1MG96NZszGU4yOsqkEjaBdOwluLT89jbn2ekpbrxJnPdFYmqqpm/qVtKk3teXcJo0VKOvSi3qcoxf1QSbGAn8SP7XaQ5z8Lf/EH+qaPKRUJV99YbMfpvXGWgcOfMrHwYaCyhHF9AWLAEyT3El9LILcj7Jckm0s+NBFAWBtuXUt60j5o8ALvDsN1fEQktwDkAjO8RakfrFjXKq4hyoL2tGLmQ+EpZjVb8fSRviPMLovoSStmiLH3uhthFA2G1gfN3wY3Uc2mEZ7u5nnJfTLk/1NOxEZGoMyLDU7TyuDxVjnWLrxYIZ4P1TMYXQCpSP3VauyJf9lop5AC6EDLwhfrpUfVhfxKzz0dIIeEnvVrexv8E1p6PiviRx9mNigSctgM4OgSxl8zlXzM5Z28+AV8nFtliiKKREK5akxE6KXi5qkKXGGpcD+80NWd7eOfACO3NVdxJ07I9IFwKY9giV79gdyRHSAkwnZc5gvnFE1GDghdIqidte37BOQRK54dcvubDNRHgFJz8A7nXmyh9Xd+ETHi6f0/VitgOpF50k+MpcEpPJMwxT/ZLxqfp18hGkfnm/+XK6LKrzWaCQAtreMgoDSNEpD2FWhA59Y6Z1Pxkza46oGjq0qODMs16hD2YhQaY0jsI1qsrHaa2XRoHDyzqlwvasjxh88fom/gE/jyTyCq8Ed4Jaj8h9u0EsQH92euXfIhhFdTfp8XW08DN/POaW+qZcKjY9EN279lO1DcvOiU1npX8SYHPd3BzgNx+iUsC3FleSifxu7Lfqf6TXkOZLcvi2k0IzC1sFEp2ZckiLEyBzub12V
 A7dcqo7m
 QhnhKsLPkRKgpPjcosRnZHLw/ze/JV+IHouMg+bHEwDfUojaLsoLNUhCx6kfeL87HcQ6jmngX0iPI/9FMXLAzSFHAaXK3Vw/+UCmRhtFujsWA12KWWbZEGBHT4h7I0tPbBa1iWs47Sm/9XwDH6V18a1BHSghSLoU6k8qpL4YSaoAs0B8BOmYvDclapu94SmLcCLJjnl4lgPjNvn1Vxt1TZzdxjYAbE23IuqKX6f4oTnTDxwZsvUP5LGzeibLFb/yB8XcxmQJs0bNrla/b8yn6KQaRNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after
the stats directory setup is completed.  When the tried_regions
directory setup is failed, the setup function ensures the reference for
the tried regions directory is released.  Hence the error path should
put references on setup succeeded directory objects, starting from the
stats directory.  However, the error path is putting the tried_regions
directory instead of the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation,
the scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org

Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 7c00aa78b2f50..0134111c3c1ff 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2513,12 +2513,12 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;
-- 
2.47.3

