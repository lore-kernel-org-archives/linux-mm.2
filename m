Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B84D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276186B00AB; Tue, 16 Dec 2025 03:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1480C6B00AD; Tue, 16 Dec 2025 03:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0861C6B00AE; Tue, 16 Dec 2025 03:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7BF56B00AB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:02:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A99DB5930F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:05 +0000 (UTC)
X-FDA: 84224591010.08.4358B54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16FE612000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXDV+jGv;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpf344cQbJ5c1fgWiakwIWc4oq8tplDOwyc0S7FQfIM=;
	b=3gQDC56ptLA6G8Zg3YS8S68eJZxb2Qni1x+SXtqgIo1eBE4Dol/xoJgcu0q6w7mtVv3SqC
	bumtWPJoNVF+wlo68LHdTnBxVCfFpBZelRBy5ae61tmrfTN4jukM7M7Niw3zfLPfcFV4CB
	57U4fHIkUZ82akPJ+ZJRDqUxf6L0clw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXDV+jGv;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872124; a=rsa-sha256;
	cv=none;
	b=0FU5gz+xmlbbDZOrIYZlKyzXUr9zqHY039ZvJ6RTTiXlzbkRYaIN5Jk9LH/20xUWUGSFQB
	pB1vwRMKSRf+p+BWGnSkshu39JyTMHDjtJF6g6SBunyJ14n9iBpdD/do5wPigL64qdPViq
	PQDvvVmZ+6n+eHlZCWPQCWmyQgZpMAg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 380B543E02;
	Tue, 16 Dec 2025 08:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E980C4CEF1;
	Tue, 16 Dec 2025 08:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872123;
	bh=Z294j8tQ+uhgFiZieSNAE5/gve3h32Q0RHDWAYvQ4ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXDV+jGvJc0fSESzG5TJkcX3/zacToRGcwhCH9SZbpJO/JarzFRnpNAzE4W69oT4P
	 rPDMGTbNR5NGj1Bfi1wVDq2W7OKRBxbzBKg9HUmwF6BEwLx+ZEvpiMq7Yx4lgPR+2s
	 1bJI+P/K72A8zYTLN/ZPdbO9q4+cX+Ej5dyrNE+HFs23GBUyUWOnTqLwppG/kGdwVw
	 2se9p6L7hOdPoa5v62xJsb0o2cOwytCeq1mjAI9LtpAR/X9s6MGXI2zbqP90vHVVtl
	 4A9k/v/GXc8gjzNuMlB3Gt9shwv/DjfjAxW/CuI3NrW2JAhO6af/CgRy1nQLibasE6
	 fhdsaIfM3mQWA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/12] Docs/ABI/damon: update for max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:24 -0800
Message-ID: <20251216080128.42991-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16FE612000A
X-Stat-Signature: rbishhew8r74smqea9d84pndusxu4z33
X-Rspam-User: 
X-HE-Tag: 1765872123-157815
X-HE-Meta: U2FsdGVkX18m9AUOXtfDMgwaW672qsUHieLFwSEKVDQB2TLsBSkwGXnOYwzRzJe6rHOg5VhZMQBN0wRWOQHzfcWmQ2NCVftDPTvykHFbdXIG6xNIUb+sFg0enD67kDcjkTRhA559SH5PIfFEpWVBzmYDlo0TcPmf3C8yk8BWBBvGBPEt1Kv7gznFYHnhZ5/oHlCJAtWINr79sDfce0QhljXzHu2HNgrLbMVHlPq8ZI8vteyr76JfuDIuS70ELBeJo3I62ND+MIwayiyc2RVm/pq9dkXi3kgCIS6SxlU8yb2pAkz+jvgliWMt/6Zp8BKVfl8MhTcSRgnbqMNYV0waLvDKOV4eT9wXKChhpXntvYpcSKnuUMmFkulcIjRrV4ZsOCv8jk2xZ7TaW7zKSZKfGLdO+LFEHZek8JW5ulxxS8y6nGCZtwPSq7Wq9HB8SQZAbm8m2C5KGxT0K86KErnQwdKHDIyqeHJFYm86DyUs/CoNQ6tRf/H5eF3q0EC0LiGwRfa1643tGz9usHocx1Ie+3aVHRKPrvUENQGs6Z/hrB0oAlNkG02E8YExRF2GKsYbCCd8CoPmk9hflWW49hkGCrBCJU8CfXA/MxlhNM/TycO2Et8HrjzrllU9OLN0yFeDNrPvg3yxJpQW164H6J7gGprfuntJD2/18ezmYWE7Z+2SqFHaZL8Aq42L1LboNIPoFM+PkE1958SiqWPeN2OuUtpfa8ThBrWbrneJB7rzZ94GpSFbNeTVby5msBTYT5GYFoonu1oK8gY7hnUB/iDAI7SYJYOkR/rXIkNYVl7hyQbMNWxRQJV6xvzH9d+545nLevbrT4sZgnexgWANADGXQsRroxNgD+7xZmG2IZP0KBDLhil1An0aA2bEcy7vx7ZV+479xcZaqDyPil9n9oitN8PITEN4tfdj3ex2KfLKn1QUGXvO02E3mdTuM+bNBrBu+fswHdFF1ksEb8YVJ4l
 K8Bh6JUD
 nPh7WHYatZlcLWE2iM6SuuV1koPJ8b/jonbXY2UsB75dK7n2Kf8V0/+3sAGzxFJ6ssoRCBe99oEw1NN4r9B5S5PkH0kg1Qp59lrxlUy6if6EVlQuLIWvvNiMemU20ci2Hd9ucnCKWfMJ5efUGyfMsUWwV15o0YRA8Pyr/FT2hmb+ZtvWziZAzSWLNfbXxZKp933PwCNmxY/Bdp61J0CW20D0YaGUld3MrFeRvt0cHta8p+MfwIX7UOWiQf4Her40BaE201QBbB7494j5G3367tBuO1ClhQQnCCNxOF0WYr/suZu4UvnwZ0q0nCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON sysfs interface
file, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7571aa78b7bb..f2af2ddedd32 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -522,6 +522,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the total number of DAMON snapshots
 		that the scheme has tried to be applied.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/max_nr_snapshots
+Date:		Dec 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number to this file sets the upper limit of
+		nr_snapshots that deactivates the scheme when the limit is
+		reached or exceeded.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

