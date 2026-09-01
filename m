Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B78C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E2D6B009D; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8296B019F; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FAF6B01A0; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 279C86B009D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAA8B1A0407
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
X-FDA: 85165264842.20.E6370BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 11C4020007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOrgW759;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269120;
	b=oKR26/3ouxWRh6uno49tKSYC3tsMdLUWcFF6mhap1xspzOd2EOxtPAyK5m+BrqxEAZSg5h
	sZNTV2jeGRlCeG0mI4qse4cGUV+2UyaI+G+vG6CI7OuffPhYfaRV5MRm7QDOLvh/zaOybc
	GB81Ml3d7Bs2uaoNjvqY07J7rdsROyQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOrgW759;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RE/sPFQsqSQVWahZ4M/8PaRhoZGY65XXC3Wknf+xORI=;
	b=D5rpJHML4YgPRMDuGw+KcYUYAR5Xt8DUY3+DPammhvAYIVPjUBjm2vtFw4qIT3wuMPKW6C
	scrkCsmh29X8T7nUxOf/qzX3u+cJTzXmZftdN+G9U9r6yvR5C7LfFDAPpAtzjO9dnR8yaC
	cOwYjmtCmmLxPBjAGA43uLIgkeFSGys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 599CB40960;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1947A1F00ADF;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269119;
	bh=RE/sPFQsqSQVWahZ4M/8PaRhoZGY65XXC3Wknf+xORI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOrgW759azzFRbCRSQfSWrETMw2/DvnImVwwQq6h7O2cc9TC3SYnMItZw7jLXx3zl
	 XhE0YDqOhCDH6OsKpjyqfV3Ei+aqYRM/ZvDzwSyAYysHUd/BNXqb9rPm4tOYIGkmf9
	 md+h1oGZhkmpWViTgdDnFpts8QjPpZ9oW0ieyAS/T9D+wyH584q9Ij8WQ2TD5nUeem
	 YN+UH7zUFecWC3749zaTVmhNPycX2Gx0vjAsZurrWOFzCIEcVKoDq7wSaSyDInXLs1
	 75vuKYEHX9HYdhuX2oL30p4o02G9Nvw6TnhO47cmvTT6uBsKMeMHXheoVzxzEj+dnN
	 SOi1RVwA/VdbQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Tue,  1 Sep 2026 06:25:00 -0700
Message-ID: <20260901132506.99243-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oour5ipbt4mazr5zdgkzh7streg5n3uc
X-Rspamd-Queue-Id: 11C4020007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788269119-108382
X-HE-Meta: U2FsdGVkX18pt4LI22o0f/aMYVvg9uMofQc51Mp/sAueABS39+aWbqTHf99i5a+PhjlQqvpFVBgANr0AMagviEjmBXW8qh+NfXQCDdoxEozJYprrc9FKQegkytyQzjq0gj5c/oxqQRne/v5Tq9Cf9VSa4cIFPtCJI64xJ9a57SbVZ4ih1H7KSk4EZ13x8qPnSga27MRk3s+iyJ2yIcTvk1iV6WbJ+T1NCCkH1j435UiF1H5ytS5OSisxluh9mDAOuHBUqNOKJBfbIgu2RRCuSd42YAy+Cz919M/pnUE5xbdBU+sJIq2AEByvVB3jAz2ibd/iOPnbJzwh/M1FgIhN+WsyrZBPa1Wz/NDqJoAry/ArVQ6fhAhJThQ0vanSgpjhitpBi/mQ9NbBGnb78/XZAwxOvowP9dT8Ny+Qa/WmQHEwvXLbpu0YTSYjOR1xhnabQ0PerTy9/B37abCRd+vrX7X0HHIIDQ87lSE3uuTjdvyEHnE/8gHziVYgPEngBu1ONA+Y5Eu0m4EtwEciCfLTkmAJN709QivXpYojgbaIaQ3qjVZEAcxJ3qNF/8pd6V+uoqjmXIBwfo/EA0UHLcXCXStYxUhV0cSZEslSMoV9LDp78GVh2xiH1V0LgPYhq0qwfYdZ7FHYzEzYL1TwJBFpIXqk2djeN6/QT4ohbEdtk3+dsLUjHHWzikI8kWyeuX/zfq60gxdWziXVQy7y2EUFqqNm/mB1ia/mUv/UjdVENNlO+gk3hVwF1KoXtYs5oB4aru7/86XYL/JVbwZPMXprixLyzKN+BHrBHKizbEGizHpRRdmAJG3I5x/bAIbcgnX9nRvOf8mgxMBltYdCPL1lJp8vCRUwUGssZtS/JKZ6CJVT7fPnoRm/p8zTh2B4Peo+p3cwnARLRZ2E+3CJrjsRSbQh6m8DlDucO6BvDpx6ZApTrPWTmj6TEk5cfAZrMgS1ldz4sVnsP0pdcsTFWMZ
 JM/Np9l5
 Fr5wie4qE3IkaMeAv87NpTRfmq/+rbtq6aUOUaBkakoF8ePOAT4E1hscNHXbae0s9OCWLOEor/B+Ow+TbnHfD+P2oMRpa7JQ7oklSvQzfDGxhS1NIrc1U/C6Rw8v/rPPd6vWiq+UyELiE4sEbmSEaf9C0SYqq2sJtPPxE921YCJdJHlPfRwV2dJidT4n39l9LoNZiGcVDavW/48ThFQHdT+Hf8+86z3Ts3ahM8FpfG5Yop8c=
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
 mm/damon/sysfs.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1ecf194f71ddb..7ec14f48d157a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -812,7 +812,10 @@ static ssize_t prep_action_store(struct kobject *kobj,
 
 		action_name = &damon_sysfs_prep_action_names[i];
 		if (sysfs_streq(buf, action_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			prep->action = action_name->action;
+			mutex_unlock(&damon_sysfs_lock);
 			ret = count;
 			break;
 		}
@@ -2176,6 +2179,23 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
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
@@ -2211,7 +2231,15 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
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

