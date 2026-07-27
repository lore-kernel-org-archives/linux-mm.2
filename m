Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD443C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B9A6B00B2; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5016B00B3; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10046B00B4; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAAE6B00B3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA6A68076E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
X-FDA: 85034812590.14.5586578
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C583C000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tsy8hw1D;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	b=AA8TvduNgVV7DcU84u7j1FCvQlfpGYx7pbZoxYqnCTs+sVuP4RSr5CqZElRA2e11398KuG
	0vb4cMf9zrljMl5A6VBAmDvydEoTvzsF+7VYYY/PcseSfEutYUiCwsKJKyV7kbRjKp8kE7
	Yvo+758/SfjYO3dqfi5BeexyqaCtQy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163114;
	b=XsGmHSvZ6o6C57Zgf+C8ovxD5MU297s4qMTzi62CiyQCiXtCx4abN3K4puyS4frFdK/S1T
	9ZvaUkvsTmjm7HwAsVCGm1XaVhCHs0BmcgTt+rJdxr//cKjVtNuaNu0ysRFU9RacMfecmg
	VCZbwj/z9+9wx53gLTGALx4nu/UwvdA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tsy8hw1D;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A795436D4;
	Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DA01F00A3F;
	Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163113;
	bh=cAfIlLPcU4sckuDrbS7eOEg3BQtpmGkcQ7Y936FLtiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tsy8hw1DgDSNspr/lcSPF7lu2IsPLyJViuxRiMuF7F2IGrO9X4AuZQG7Z1iAs3x9t
	 Jgx6tzvfT3XemjNww+5whkyC63EG7Wwfep7e3uVEdF+y3wpqwFzoT0rsCwqe8e2sWG
	 gSDwVZbg4w4z5bSd5fm5xkjb15EUyKSIrTPnazmCKnEinNyLk30trRcz9cl0OyXEzJ
	 ugVtr1binJO60JzkdPMier+r2rvHZk1pwKMS2C/qfOCDqu8PIgIK3TS4UL6rsZV1Mm
	 jMJWpd+lbTbNS1XlgHllEfF907q3BLKcuyxR9x4OaKR9AtGg3wqhtjXgzekQApcnXF
	 HsFUXjSPt374A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Mon, 27 Jul 2026 07:38:12 -0700
Message-ID: <20260727143829.86236-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ribr5ry9nod99xaqgo7hkxnduhp8ar1o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C583C000D
X-HE-Tag: 1785163114-81334
X-HE-Meta: U2FsdGVkX195QbcalZY3/TJ96IfF57m8dv8YGbeAi8Lcj7w6tWZ0lLUbNyZt2jXUESUkfPqRDsQ19HMopVLZKQ2zRS/hl2F3lKXysRdvX/fKesIWv0nHmtjLXUIVh7FA1iUSq5bzN8VdYqUUrNk/IRVhOvJi+DSu14c3rT5A5gsLUZ19Xa8Io9iloej8Cv31njrtCR/NDsWSjNp20V1cfllJ0Mr7+5mdtwCdUyEpQbcbAl40wyWXKaw6I+4Axrf5XwX5qOwAGD/RsBc4VT0bPwxY/ps+QUQy3et9fdu4k0lkWO7nANx7rVyx8/Rvu0j4MMrvf66Uid7eewSV5z7nRGWoyI4M4ygCquJvrfPfNm2s66/kHVPRYLySElM31+s4tHbxDLd6iqsQKDjBkqxqL3LgLv0r5SjXyDep7r2m/ESEah5r+nMHNh62+psKGOhy2JO9BXmYYRE+P/6xT619YdDBsuyjXsoTqnTcGvhQAqBmbw7+zsOyknICygPBnOlijYrS75D9uNI14usWEinudO9V4YBu4LaYcxkHt5Y7v5l6jPHUbj4mLurXq6V3pei2J8qjRWkytn1BjDqoQPHMRJ12q3gdwMmphFZaQ3RFwhHGhBM99IFQWOhp4S0AENqcWHNbD3PTtZ2noMtH2KyKj4t0E6auD9G5U+TWNHvNih1nwFz6u6P7dd4NxNgq1Zm6B46BfIEbEo524Sn5IaGI/tdFwpfUrhs7moyW3R9vy+ej+ZYS64ZlwZEwFoA8Y7CVMWrNoAWYtKtfwGqS3yil4OGlOf9Pf96lcX3Snvcph0WSFa2bjy8FL0BDr8EQyUjwB1TOkcOzZn5JW5t3SxKsZJpKt9eKchKsezqIyyAVJztxsTdAdktgGmKV4uFdSdujSlAuUNgCjoVlnWb+YiGTV0WUNe6/mlAPAmT8PBOC/gCooAoRIVTqX2W2+1Pda3JkkoYvFWHN8V9y6XcCD2u
 5V8fzOAd
 907M8Dh9lWrGd4Rvx36l6IoXUVp5N/qK0K9a3HxX3m4xChCGuRUDMe5jgqlKMueinmDsSG/7NuFactzSQhlagQIgMf9b3axvlDAfBID80svU6JESyZMxoYHmHTMRs85rcr6LvVZTEotS9oenqvWKD8lZNUusnvRE8jtmmqMgPvy3tZabTjAR/1ZgBO66UlM7qutKoxU74MX0uS0xqdQCwUe1dpBH/fzN8UE+XxKvoJfFDo4t/zT3onon0I66sYFQIg8G1WIWTlTOA+rOGwZ4DNr9jBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to allow users to set
DAMON_FILTER_TYPE_PGIDLE_UNSET by writing 'pgidle_unset' to the probe
filter type file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 053ba2e53b969..376c6ecbd4bf3 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -782,6 +782,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_MEMCG,
 		.name = "memcg",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
+		.name = "pgidle_unset",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

