Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA009C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A4B6B00A9; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD0F6B00BB; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8657C6B00A9; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5FD6B00A9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7DB48076D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
X-FDA: 85034812716.19.0A64F7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6AB25100012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASIfN2Hm;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IJAHoEq/HxxwTqavkeHm1rK87WzNS/lOqxmVc4kOBQ=;
	b=2ozcQAehiVX/awm37uT3YYPT1iH/tBR7LrBljaIeoH89oKxKYOukxDHGZNswyUG4BinXFI
	QbuEZiLrmlUtd4EIUINP/VfthvVIPI/CiAOb5AS0KBs3ujhLKuHw2mTH0giodoYs8dMQWf
	SXCoLkgowh7Pwy6DlgcB8afjM+VW/fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163117;
	b=wXAHDcGRGL8pYsseFcrjrv/SldvaxzVsMughAzqjUU4E+vhqSNopPR/gEH+gBMBUsKIqcm
	/rE1vX0MBNraaBPM7LuLdCGGFdqKJeienomQTgDLhALkpyiwZNbzil3yIiQd72A+LcQtWT
	EeRLn5EIXOSo0pIw2xE6EGTXZ74pc2A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASIfN2Hm;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4621460A65;
	Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4A81F00AC4;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163117;
	bh=3IJAHoEq/HxxwTqavkeHm1rK87WzNS/lOqxmVc4kOBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASIfN2HmzFDLPKauEvk+aTbeOju5g2NHdiFiUPIwsEy3Ru14mfA+g5ArrLP9D1glA
	 Y+uZU6bkNK+KsesYculdkRdAEBJzfJ3eqkfKwEaUiEaN54hMn8LS6NwgJJfSd/Izn5
	 vGyWbcPFGSZL2W/KTNMrS1VSLSqzs7UHQnGkMrKbOHIPEi0WTgha5gmiQrBvnv62LL
	 4EmNnxdvNKWqqqOS0c58zsapG6MRN1WasFzTguqsx8nIStsuk6YDTDNAKozQbNwX0p
	 5H4qnCHiTSiGbiQnypLNNVeaAe0eXJEsdEaGcaJ5CN5D7YgMKpN5h1QcVpOd2Dx2+Z
	 YCjrVisD9D6FQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Mon, 27 Jul 2026 07:38:22 -0700
Message-ID: <20260727143829.86236-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6AB25100012
X-Stat-Signature: zw4w6up7purjq3f1qxjsgm5183ynwzod
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785163117-758139
X-HE-Meta: U2FsdGVkX1/I5bGHxj+xBVobYuTA5zA8NfnSU/iAbV8JyLNnUq9REiI2J3xOo3zGCu3ggKcpdlWlcPsrpEs+z/VtGlXJwmcfeXenk3cCjGuLieSq+3A+Rc4v/R/7e9eBvy1R7z9TtZsAjYD+Di5aut7xY3DwxfcmRRbJAbuR0Yv70uSHMcJWpzxoxP75Z7TdYRAvLI6rPuQ4g7nmq6PSXWQDNKQfgz8NTEzE8+WHXXI54WCABwXjAASGqgxQLAiR/+b+4WBq20TtKqVw6hOw3SxVcJzwSikf3/+lGXNnLFj1b7HdjKtWN3CGAFMIvIJ/j7+vVnb56tUntWIZp3hPoTfkNiRyegLd/OA3ri/mWjm+ZjST50v8azK3yT7bYyR+9/xJJPu+mEMiYhT3JguQItxlQpSFVi1pkoG4NyJDg6dzGqVbR+vTu85Ca4+Po2x0NEyAuxXDZYBdWh1eT0K0uRD/Uy6x0qtNfl9SgUoUT5u+HVzHZiUj9mSTROMIV/Hz7SVT4pNOvSzzanqGw9h6NR3SNK98RUOGvBeYRwsTr3BzGymwLC136/qPc7VTVeTkEg+x21jlVHiRmPN2DT+GFQdj3FqOY2Aeym5Ynv2tNlBJDcQD0IgS4D6F4NYLGLuTxFDASEQYkvDzzPCcsxMbsw35dC3jUbbrm2jCsWYvGjY0gOFOuKXbdNtQO4caagRGXG5sZ5Oi8OE9EtUrHSkuj5M0vFsiQKstYuOuYy2R7153l9Q8IiifhK31Bal0PfN6hGgfO9fuestzlzSB2d8fCPyvkKvT5RKzOmyblYB4wB7/gsridQyl/1MQjfN9wvSNGkaaNoqqNEz/fqTGzfNtDoL0MHPkl2UAZcsUH0mEbUeqWR3pwXRdn2GrPX69rdopYSqPgD71jd2CRC+pcxE09f/xA1ICYaF2wEoNMFHQGTk3WxZRZ3reW4h7ExOri4sYq1iFtjRv4664kFcSOF9
 7U555kOu
 ZEKFg8484153r84x+5NTliM+SYG6lJk2ObabTxLDqsshm67LarGcAXYRT2puLqmxXa92s8H6w1RwtfyCrugamTv/MiHCc5IjieY431IYxSw8GT5/i0Hh26ba2KnuVxoZYSTXunhHvwNI9h+auo2uJV1NMfRIPt3Gyn55DcmOIkXsMeUebb1xBV9AZ/2Y8R9Rdj2/AMf/UqYP1m5VeuetKXAo98maE9OuuqW0ojq2b+kH0wMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides the files for setting DAMON probe preps.
But the underlying code is not really passing the user-set values to
DAMON core.  Pass those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0173f37fdbf3d..3ef6b07cdb5fa 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2174,6 +2174,23 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_preps(struct damon_probe *probe,
+		struct damon_sysfs_preps *sys_preps)
+{
+	int i;
+
+	for (i = 0; i < sys_preps->nr; i++) {
+		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
+		struct damon_prep *prep;
+
+		prep = damon_new_prep(sys_prep->action);
+		if (!prep)
+			return -ENOMEM;
+		damon_add_prep(probe, prep);
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_filters(struct damon_probe *probe,
 		struct damon_sysfs_filters *sys_filters)
 {
@@ -2209,7 +2226,15 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 		struct damon_sysfs_probe *sys_probe)
 {
 	struct damon_sysfs_filters *sys_filters;
+	struct damon_sysfs_preps *sys_preps;
+	int err;
 
+	sys_preps = sys_probe->preps;
+	if (sys_preps) {
+		err = damon_sysfs_set_preps(probe, sys_preps);
+		if (err)
+			return err;
+	}
 	sys_filters = sys_probe->filters;
 	if (!sys_filters)
 		return 0;
-- 
2.47.3

