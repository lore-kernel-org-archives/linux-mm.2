Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BB5606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Se4qA6/1
Received: by kanga.kvack.org (Postfix)
	id 29DB26B0779; Tue, 24 Nov 2026 10:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DEB6B077B; Tue, 24 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163F26B077C; Tue, 24 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E73456B0779
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83C5D160BB4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
X-FDA: 85470415842.05.81638E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE54E20004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Se4qA6/1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534620;
	b=fHXWVAe8TgVjli7eJaNeFzD/Hl4KoKju0ekXLKj3JqNPhXpuYUY6/vWMhnH5ITgPYf3ceI
	HFPJmzxCrJgIYUMqXgHtwrDL/d5EaW/fwArrSdeEgItAa6kyW7yDAffKSY3RaR9j8i9kIS
	0BMgEdlt09bIru8fra5/cQzFfvoaZug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyKk+lwXs/oM322dL7s73a7m8XTJBc6Hdzh0EajUah0=;
	b=Gx4LSKxjNUZE4a2wVT06j9idzviYJJnubt0CtdbN5vDJHaPNT9r34QV8QttpEgH/P5UefQ
	9L1V65gA4EiGAHGwShJzCQvvR224/oouXOaNrWv7N4JpOrew/x7ktz1Uuz912lNBi4wMAl
	TG/F+FXtqcPD2LxCeENtwT+4bWTFSxM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Se4qA6/1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 385DB40369;
	Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C861F000CA;
	Tue, 24 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534618;
	bh=xyKk+lwXs/oM322dL7s73a7m8XTJBc6Hdzh0EajUah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Se4qA6/1wIQAd9itRWEClMIA5gqCifzwXUYzX6n8sW6lQuEyulH9abK+8aj/IWiL8
	 SoVZ7GXpmTME2hGzrCvDVw/sZKjW4EDUOd5hrNMpSxUfMe07HQ6u8FebCiRM03AMBk
	 jgi1WctP/gREyVO8KpuH6UH32vMBoA3wI07pikumvok7I3e6jCjfTTwB2JayF9Om8K
	 LVYGhX75IywdOuzVaFzumdAffWfyPJU1he8iMwUruJJVZxPa8Vo27/ewLQKV1mGink
	 AWFTOCtRyxOsgJI83E7SvAubTbGFrgk+MjqYWKmqlkYnmdS0gG4NRuY0UtAQ+TPQui
	 wVVNtR53UfySQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 19/27] Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Tue, 24 Nov 2026 07:36:25 -0800
Message-ID: <20261124153636.91854-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE54E20004
X-Stat-Signature: 8j5yb6xrwfkkns7zk5q3ecxxmnqfnfp9
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534619-991377
X-HE-Meta: U2FsdGVkX1/qsEYOckh1phvllK0xlZ40lZ/sxCXFdwuzn0q/qpJKQ5iKy6TIBzzqdba7+GX2Y5Ryuz88RZocrOYSNd6DzR7oRcAlXgSPKpGAwwGb2AbwNJQcixXNQVHTO0dHlBRKa6Cl6aLV10ZJ+UYki6tdw1mXK9vrKd0fLpA4Axq3+L1ovSncgc45qNUH7UIW1hsXbR791G2lsOjJnKyT+7oW9CiSdUKvpwJCguZqGeVGzH9MrtDniBh0gTtNS9gWFeb2uLM15GFcL924Bu+cLjD+9u6kqlxoK1UzJ9eQjLS1sYWfDfL5a+wS96F5lOH5vlxJMPC9u0R2gdIcPg3miJx3GLf/IsfNklLhueje8Kz7w2dCgXJL+uVZ/igIpcgYP0BBblHO6Z4NYRr2cQ4a+5u0IxKvhDVGTUKwuvR5M3suqDBuJ0NTl0hXvgphKTelCXvaTUwsUnIlZdN5U01JDKb9bEBzwaeTryo8t2yRfmQEB12CrDz7C92svDGJsl6oH2pxSo9FOVWX6hV3+MItLMq7TfEJ/CYb2X1KVFxnndZtRwnPyL5PnQYt3Jl0cyngvhzR5VBNg8Rrt6qiG46UmIcHok6go5exRgh5ZdLN/G1XpGufaOpP1zgbj0eMFqyXeJAtOUYJUKuoY8lpEGMxDiJYUIe3qpRLh3P5njXdyJcrNf8nGRLyxN3cY+UnbP8WK06E9LDh05W/kZpU9fvBduAu7r2ZVpWF4WYlZupjUixIX8dmly+pAxp1oJmAO+PcDiuTEDnvZw7uc4ZQXg1r5RprcRhl6OGR0s2GRdw1hXR21y3uSjr2Ll/8NkkRuu32vLgikunmE/8GKUNXQb0DWgDU1QnEF8wrzTdqtwag6OzHich11pa2NC1E+1sU18nWXaB1HiPh98gGoq+oyAaFWTs7miy0HSkx65rdXqX8d9qfr3ZMrWcFOoqxksNCycVcqvu7z6FTHbabSHy
 G4tzjFoj
 8BkXzFBtjMCrXgSu25VuEIU6EmIuJIWHfPmKZUb3x0JdxCwfspszGofVZOdi0n5xbg/v8HhTno+BV1/9dAeneXyer0TEUPTB3JB59blDad9nZ0/cehIjhHpBVN2XX743Mn7eQRUM6I6R969YriXpNXn8fxn8/BcWd3NcSWrBkk+NeNusEuhrfZTLV2jNCD3Qt9G9kxh9ueJVZ0ZEleGlvZGEuO1Uf5n5LsGJ0f3hmSCbqAifMOZQMVY2oC4LJiIEyg8vD0ZkVIaShV2Jc1SdJiLTZ8G8kWcumQCIe0B03c3q7J3UYfBHnZD5bIoOGAkk9viZWTkWi/5EIptx1V4jd2xP0W114P/JNBaiaLse5zjv9ot9aL4kcKw47xRgn4w7R4vgBVuAds2XXzuYD1NYmUVmJRFicBQuXIrQFoBcxUVjerdG4STXq6z9lwxFdcloxenniX/CUjgZkWPmKOHyhpGkEpDfETnXI3YwDUsMUOLCxZnJgnJcE1SpxeJCS9p0EEEAm3xmurFt5izz9sqL2jAouRFDaOd4nMEqLNAKo9h8naAtLb2HPCY3cM6gb2VqdXRwaeuL01VIj80RfQ6jrCvHNzl0wTpkomn7I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added REPORT_MADE type probe
filter support.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b5e5004ec9fb7..692827674a773 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -233,6 +233,13 @@ Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		hitting the probe for the memory that satisfies the 'type' and
 		the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/filter_report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'report_made' is written to the 'type' file, writing to and
+		reading from this file sets and gets the 'report_type' of the
+		reports that this filter is working for.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

