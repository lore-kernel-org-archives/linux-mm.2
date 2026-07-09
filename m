Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5538FC44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2625F6B00A3; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2122C6B00A4; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1019B6B00A5; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4A186B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2609EA015C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:11 +0000 (UTC)
X-FDA: 84969412542.15.BB17041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90CFDC0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hL5oqmRF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605969;
	b=32H1Qf7BAbiEqSlI/L5Cz/mg1FOVa3hhc9mhM0wlG2x3hevLssSLJ8FX2yS4gAuTd7V9Mr
	j3A2zvLKb9PG/lE4wzRzwLUTPLgm0nwgSxXwwur8W5VaTXdXOFkSGxm+AgC5Ix2wz1zdAe
	/NPKlI1Y23FKQl/eVJhdbBhHjl7db44=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hL5oqmRF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	b=NzGO8SvCus8l6ikebsCfEBRKW1wFdSbd+MlDitNF5Yl4hDrwiPpcYSR5NwEywCcrs8XbkN
	v163ouiPIxdSQkkcMFZSqT/jEVOy2USQZYIQmGvPtMleZzd2u13HHM/bqJW/ss+QMgyFJ/
	ma+lunOKscuFSI4OZeHpYv+i6cLsQ1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 646B5600C3;
	Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F511F00ACA;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605969;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hL5oqmRF8LzkkynQfdce6wbeYQWSDjpL6UswnKc8fc6G9J/HeoLInPWbIJB9ZikM/
	 ZXDvIJDC/ngOO3yqCFJr+ephAwzS2oy3Cga8BGZZErFkDCzrhS5N1N0DgrBfIjSmOG
	 WYf6KInPrH2uRuWCksJBNd/fTIKDyX6jRU2sTtNr0wgjPiSRDEOepGRmm+1eNL+ZB0
	 a12wi/QRvOGNUtAu+SXzH5OFuXkNhSWCFPEROU6xn+lj298NTSKDcVPQ6RpUAov7Vl
	 Nm7TWgaHERszU1Z5+6YX2aOoUa8pnb3Gqhxu5lKqpIJgqrYBcXOZzn6M6xhsWHDo6M
	 M9Oa/JMhiKcsA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 16/19] mm/damon/sysfs: implement probe/weight file
Date: Thu,  9 Jul 2026 07:05:54 -0700
Message-ID: <20260709140600.90950-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90CFDC0006
X-Stat-Signature: j4ypebcfab1duay3wfbm8kbcmojxqj6i
X-HE-Tag: 1783605969-401878
X-HE-Meta: U2FsdGVkX194r/uDGeJ9PzQ2Zd3hFdFNKTyd5F/1laHN2ucsg7ioCntXcVZIbQqew/16GkFrWSCYW5Yox3cQFJGFoI+Ml4A4p3U2E3Fcks8XTJ6/ZglsRWvHSlCY+zLityPPshB90w614K+TuKPgqDnXGc5dEekmXSg+W782aapymYe+ok46vNGxjOWXT4tdOO7cJXNS23/GmJ+d3IVzzzAMjTRZigLZoDlukydUOhPwSGKNJTzY8VxydpJQgG2w9HPOqZV/EK4Fb8AHbJ8Y+Wpyl0X5bl3PhLuRTqIUDXLnKkaJFjO4Em9MzK2x2gyzFBUSj8+I6/JjfwM1d5A4cSt5B1/E5Myshi82UebcSyGqTNmChpJTgN4TSMEzPcXRmHZNyw3esY2Nj8+9GURWkJ+TLze2bPV7Wb2Sn45mFtidY0DhuZeVMmpVB27KvqjyDyBoazQktZSvwcy+aGXCDGOgKEoSlKOQS4SbN2C/nqYmbaATC1kCis4VyNuwAqbGcE7CcVtZaKj9bP1ne2Xp883l/xEgAAmwm+fAbDdyFk0NrmK7ARZJ5TZ4qY0bVxhx0WW6PX88XRVw78T5gsPM4hmfzNd7BC98lR+JbKGz7kA4h2LB65n5fqTuhQKDJrqhrLBHUZSt1qhmV+VCY8mgx9tHYvrZWsqt1CxrRHJ1jTapfYPMIQui6NB1vwJfQ8m05Sf8zO9SwDUNyfwX9cwt8oppyS8Bfi2Dgn0lcP6dBmVLceP8zAhu+5NvJSszZinEspznOWIQDpiaitt+uDtFGEqvbxV6QaLb6CP2AUnJjHmjNSKCyH+qZZEYeHRCa4e8reT5OfDHKQmpJC9B+vvITUZxYtuNgybrZGcVuMap+yrZX5X83mOunz7ePYYIATFNK/1Pd4rcpgb/llRoxyeIxUvGBC/YuMvCiJAwHA4g1+zB4Av4vDnEAasR+qMsWKNd92O8EU2iQfZyf/yrQ/G
 jKPAPz4J
 Avj7nsRwtvndEv/Wb/SSyf1SAgjhJrmzNT7BmctiWfbYCRM2Ufnv9h+PQXsw72k7SVb+M4HS0I09ydDn77Li6vFkX/Holf1KsPcvgPBrWiEr+bejfKfLUdnrQzuLKU1ZIwkSml/IAD9XJZkDXUWcEVMLvWmoL5B6ShaFj7p3xJ3I8AkYzTHzqT0p+2dA40ozJyxo8iGBWpxbbvnA9zimiWq8taZck7Fshrfb85F9ZHVaWK40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new sysfs file, 'weight', under probe directory.  Users will
be able to set the probe weight and enable the attributes only
monitoring using it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d7e36c9e509d..b5fe036f78015 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1065,6 +1065,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	unsigned int weight;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1100,12 +1101,35 @@ static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 	}
 }
 
+static ssize_t weight_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%u\n", probe->weight);
+}
+
+static ssize_t weight_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+	int err = kstrtouint(buf, 0, &probe->weight);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probe_weight_attr =
+		__ATTR_RW_MODE(weight, 0600);
+
 static struct attribute *damon_sysfs_probe_attrs[] = {
+	&damon_sysfs_probe_weight_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probe);
@@ -1965,6 +1989,7 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 			return -ENOMEM;
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
+		p->weight = sys_probe->weight;
 		err = damon_sysfs_set_probe(p, sys_probe);
 		if (err)
 			return err;
-- 
2.47.3

