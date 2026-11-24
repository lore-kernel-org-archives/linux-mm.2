Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52ABC606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fiigvl55
Received: by kanga.kvack.org (Postfix)
	id 24F506B075B; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA3F6B0760; Tue, 24 Nov 2026 10:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6666B075B; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABF976B075D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DD26140BF9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:50 +0000 (UTC)
X-FDA: 85470415380.25.45632A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9321512000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fiigvl55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534608;
	b=BFuidXU3Orn0Cwf+3E2dQ1QJT84MUamOXZWr0qTctDgtJg1G8wgtb9Bumxl2IRxQtQOnCb
	W0c/ncrM1AOQB5OdiuVSAT9DaCfTI4ZO/Ff9XLFWkbuDtM66I/ub+A0sE633SNoQMCCtqj
	eJrehXoEb2vyXMBR9H2RXHJfYreJHl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jluGUFf39U7y2mDECHz3t0tayGa6/18eFwFEuC7VXRM=;
	b=ex2a5d6P6rnnDcRL9EnEw0aTDyW0P+jaBhk1KGQbTJaYE2H7aeJ09qcYaagWvk7G4Afq5/
	vN4HtgaqB7iuopVu70qKSP/HE86OuX865eL0oTwP7zfRnI7JsCYptlEW96JapeLtiAlhEv
	93R3Rcc2YSACj9QliYp598HBgxxzM4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fiigvl55;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45A61624AB;
	Tue, 24 Nov 2026 15:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C05B1F000C6;
	Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534607;
	bh=jluGUFf39U7y2mDECHz3t0tayGa6/18eFwFEuC7VXRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fiigvl55OzJtZ4ml30yEPa6qu8WqYEuwNGgSxJaXRGioXJB9PIcfnU4+qsrfeXdNy
	 YCvXl0KUwu5Ah6Sy4824M5AmBQvbJCzz8TpjQHJpEVeO2TVWUglMobwFVSnSE/5K+H
	 ReEcWPGkpGpYJ6XhQFnT2KtBLtd7ao8qSzLwIzLy8y9vlkmmo3WB3acwfb/TN+XuTV
	 DY6ZDUEx484nf7F+o0+Ny+U5LcY8b91t6d1z9YQSLcZxVVJ1+VtFCQIiyVHwcFLz/0
	 CckPlCFqtGtoyyV28nou3dbkfmXNvKKmMw4TLRpAfYSF3qzoaLF1DGH2Mz1UA4eA9k
	 lys4s4d5t9nlQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 05/27] mm/damon/sysfs: add reports/producers/ directory
Date: Tue, 24 Nov 2026 07:36:11 -0800
Message-ID: <20261124153636.91854-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 9321512000D
X-Stat-Signature: ewn1syqzrh59w8d1jzssaotjtrh1uund
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534608-758296
X-HE-Meta: U2FsdGVkX1+xQ25yyQhxBGUsbPzZ3aJ09AlkNgDGe7TE3TrS3VCmoOio2W6O/dzWqfmgRg+MEI7KDqgfSwv/OjwRfWctSnUgWa4gmVse2Xr+1VhKuaPCioZIq3FdUaz/WAetQSf5Afsql+4oi/vHvXZR0urkLZH3im0x5N0SbA63EceJK749fFjCPvWlWXU9d3TsoFIQJFIOJcGXZNaxCIXkxHwRQKGTgI6JJgxnVDtFDc2pKJf9IAo8vLHNqEuMCbCVWp9YK8pBHFmL3RbA5KfHRu7e5t9hdZrJxQ+bAnJCC8ZEl53NxnUCtwBClYu1Njh4U57pPGMcQTZCKr4L5qNnAH+T/GmVfMpkTkft4WavN9tQ139Iplj9QTCNO45eVNXdnMzO7qpgB8rFeIwETS3V1eqJ+Me7pn3TLyfWSawKFmmjeu00YQWFvf/rBQNPVW6vcolSeDMvFpxRt9B0Vfl6sr9c3MX/GZIRix0bEYOz0hllmxOXZXdvkfge09sSHRUDgFOLrVTK1iB7HacDj0ZZb7UQ0SuUDvNMvDrOHSPeoCLkHa1e8XAT9yuoNyAKKTh4/6M5uYgFKt2JTHNjMxZkLS5TeEJM/r4QwMZyroXZeVP3ndfgDzTPrJpArkX46JL+X/3AyS3YEuh06A6J2Kalt6nmWB0QxQFPEcDCoSI0I9Ttmf33KZNEXjekLuAYmnokE6uI5rx6zR7iLS6xwknYpPllO3VryHmljfdBg6ieviE5ymZsklskzvXccsKcV8g8aOr5Wg8Vh41qyVUkRAtTLx+1GgU/rSCHefKM4Kfc/Jy1AqKb9JbZP7hAHc33/BEBCIYSLhA9wkf+hzy/gOk5mKIc/kt+xPyHITUNOF6If1B0k3TzGIIApUdKyDH0sWFvrcoZSIei28DtFLMneeaLrgjTFjWnZFhd9PhGW9iWJBybEB7zJQAcUJE2uZC2dh0yN6palscTdOIAroh
 ttM8Mr/c
 tBgTO+xsHHGBrob7gBTXSS8HF15Jsb3o/Y6QFnsclOAQM0+NzpudrcJnRVJjmCkV1T0WtTHFoAnB8bVe2uogL8akTeazzqibuRhL3GsTG14NBbkqx3D2odw4hE27jv44mOHRO3Kdtz136n2+7M+tWknjHS9KyIh9YYeVS1gEF3ujrRg+VPd49vhnLzy9UaAeO9YkaVVGL0/Z6zw209352+0Z3bwUWm1pW0QDWIU4AS6hiq04+JmHj3T/QM7/OoMISEotn35hfqfe5VfqdCgJEYbxw3fj7tfFVT971iauCGUlGZiYCnR8Nln+2nmZIDGkzZ5iIwNpTrgEZe3GMR0otc66k90dntyHlsA2RNUyKBw0h+8EikplWrTYrYV6+H6rt2eF7ogTFKgkGO59pHacbIWwoXnI8GrA3ZY00iWeJQ4uCCeiwmsYdQXcfj/vTHDTQi5IHFkeDCNc9OZW9FepbHJ1wZicle1H+syixAIC6nbc2dQDaZ9s0N79m9nrQw3hvvg9crRIJb4zjS9/PBnvLUtbtwqgLmp2EwhS/0RvFyJ+mwqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new sysfs directory, producers/, under reports/ directory.  It is
a placeholder for files that will be used for controlling DAMON report
producers.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 76850a4b5b5a7..75701ed662222 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,10 +2979,38 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* producers dir */
+
+struct damon_sysfs_producers {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_producers);
+}
+
+static void damon_sysfs_producers_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_producers, kobj));
+}
+
+static struct attribute *damon_sysfs_producers_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_producers);
+
+static const struct kobj_type damon_sysfs_producers_ktype = {
+	.release = damon_sysfs_producers_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_producers_groups,
+};
+
 /* reports dir */
 
 struct damon_sysfs_reports {
 	struct kobject kobj;
+	struct damon_sysfs_producers *producers;
 };
 
 static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
@@ -2992,7 +3020,25 @@ static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
 
 static int damon_sysfs_reports_add_dirs(struct damon_sysfs_reports *reports)
 {
-	return 0;
+	struct damon_sysfs_producers *producers;
+	int err;
+
+	producers = damon_sysfs_producers_alloc();
+	if (!producers)
+		return -ENOMEM;
+	reports->producers = producers;
+
+	err = kobject_init_and_add(&producers->kobj,
+			&damon_sysfs_producers_ktype, &reports->kobj,
+			"producers");
+	if (err)
+		goto put_producers_out;
+	return err;
+
+put_producers_out:
+	kobject_put(&producers->kobj);
+	reports->producers = NULL;
+	return err;
 }
 
 static void damon_sysfs_reports_release(struct kobject *kobj)
-- 
2.47.3

