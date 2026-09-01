Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E29AC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0BC6B00F3; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BFE6B00F8; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC40C6B00F3; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E85B6B00EF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6A6C120340
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
X-FDA: 85163927142.12.E0E03E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 544E4160002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oM3BnEaq;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237270;
	b=pFSXqY1eG2CdJnbjst9cTaqhqXcNaQPoLlnbFFVVTb6t2HbByCXwvVdGMyrzCCCOJkoygi
	bNv3oHpguxEZiQxF2DhqaztB4iZ9KnoO8y0n0ocl7qMhEAgYmfnnu8holgNpVs+6muby0T
	Vs+F6tTD5LiFv8bfRp5aYZvjbSyInb4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oM3BnEaq;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl5ADA+9J/l2w2quHKWsOoHjOvreI5jvhgmI+c48UlQ=;
	b=reayr8B3tro5GK4I/pXnrjcw+Da6iCV1UfEOmk56E8vR71n+i0N87VWPuKpGYRB7j0LTXf
	0WQKdjfIq+PdRDBJrqlDNvYEAonG1uVfuLg8J/9KnMmW8avGQTBV1mhCCm6xAe58PV2Hsq
	fWjj64OglM++aQKYHRHfDzoPFDq/rms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED6E3602D4;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8159B1F00A3E;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237269;
	bh=Rl5ADA+9J/l2w2quHKWsOoHjOvreI5jvhgmI+c48UlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oM3BnEaqrscKBNF8aZ7Qv4bUFnq1511x+PkpIIIS2REY45nbPMpOv8JEeUgh4zEhC
	 p55twps4xZ2Avb3RNPYl4LpuDOS2MDB54HPkJfmsjNlI3BvGUfs2KkrGa9TEXZUZuZ
	 qSNHp5Pn/0mqEy4Itdm4PnEffr4tg0pa+EyrR/isB/V9XN4YEzyUY4MjgnFPs9j6IN
	 U6dSqTzCDzJH/omWZUKusLgU+laMJp9DTYqQ8N8mkiUiDDwGr2SURXd4ypyUJhdqHb
	 VVVNqZCYxVf8l89sUPc7pXCRDOtNWaB87mxS898ThR5m8oEafUv2I9NERjimMWOcyT
	 RrgqxZIGUbX3A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/17] mm/damon/sysfs: implement prep_action file
Date: Mon, 31 Aug 2026 21:34:08 -0700
Message-ID: <20260901043417.2165-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 544E4160002
X-Stat-Signature: byt6s3b5t8dk1swshycaaanbd8oj9wa9
X-Rspam-User: 
X-HE-Tag: 1788237270-858839
X-HE-Meta: U2FsdGVkX1/nC3NSQRs2jx5/qMfSwDaSP23cILnLllKaL6FyLs8a/xMDRU2NWGro4jAwdjXa4JK5Yr6ypNFXd/qC3AlPB7szeIcyFS8D3bJ9qtyNysYWDNn0mQD4Is6F99va7KXK8tAGELuGONcv5WxiwResgGXsalnK+0FKfZxH59GJRmCTA1EQSlt4iDrZmQyxY9nPCrBM/D286B7oXm+FA/ttukPpPV1Nzyfy7KF/jom0HKkDq1RE3GZrqwuNgFxzFCm1mMv7IYpHdJq82Cqs9PVLENjf+m8q0qIcNjINck7GHBLHWrEVBiynyUzt+v1Z7yD0rcW2P7UelhNWJ0RLbyKp8vL+ld44RnqNH8f1pvR20qpfknDTJf/5jWLZl/JAKnVU00LqC3/gPGCLymq7i4wn8wwCIGh1VonL092fCsEMKbMGFLuJb3+JWe+cOuzgvCgKFR46VGmLTrIKasLpgLbC2F9DY8pa5Y7MQVlRUutw+nLxyvVnx17/2z7471I3PCqI5B9BUS2FI2n5DNfVAmLSYOea+TiqYKT7WQvIzqip5WaOHraEMQw87ptNqdmhNiRYe7RfsF0w7kpvE+ImpR1KRKQlo8ZAQT7C3b7UeOX/g1xcHgOf3IinKvXNiWt16QS8M7Vz2DDxp1SNk68RfLMF7LVe6uZhlnOPujoPCH6p5e7kdZDAQ3wX2riZf7f3LB2wydFNO+ialf0v93s0tHzecfeWE25YmVfjCuQPDBytzfpJ2vkp6VO7CPUbQlNJaif2qPI+lKZ0yweXHB7QudnZxGOjI4nyewU7XGXtKyf9QxpeQo/pLQtfkqSTBg4sFXSBKkxuHV8vYQuCRlmrM5MfMIoXCB2kvFebYLjzPQUOjsrDVLQZDEdeUnj2GZTCTxwMKOo9M65H22v/cW6FdJraLUmdkSK5jGSlzgO9GHQLf0ry3NHGodqO9Q+auYSmRfUFWqtcKlkE/9U
 POvExkPy
 gA/dvR1VDDl+Di63qLmOCOcRmRy9cE370ybJZ7BJzQTPcoCW7H8pvempxBuYlT3RMidVnXhNU4cth30FNGrNq5OC0vfFYScCR4OPZvdsBo3kIbZfIEicK1XolaNEOcTtHFqE7FDmIRSrccL4igV0cTfsmOx2bH5cFDAPtuqDnWMrVggMCFRE+25eJzS6+JgyAq+QIDeD98HojMDoPpkCGuTXYIK3w22dPBxBDKqtHg69CNGEQWl19O8Z/5rbBX4Mn2FakgsohXN2sybOKfFiUFlawSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a file named prep_action under the prep directory.  It represents
the corresponding probe preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3749abb781566..1ecf194f71ddb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -755,6 +755,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_prep {
 	struct kobject kobj;
+	enum damon_prep_action action;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -764,9 +765,61 @@ static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
 	prep = kzalloc_obj(struct damon_sysfs_prep);
 	if (!prep)
 		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
 	return prep;
 }
 
+struct damon_sysfs_prep_action_name {
+	const enum damon_prep_action action;
+	const char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_prep_release(struct kobject *kobj)
 {
 	struct damon_sysfs_prep *prep = container_of(kobj,
@@ -775,7 +828,11 @@ static void damon_sysfs_prep_release(struct kobject *kobj)
 	kfree(prep);
 }
 
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
-- 
2.47.3

