Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8537460A260D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVjTxzhz
Received: by kanga.kvack.org (Postfix)
	id 543F46B05BE; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCA96B05C1; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CC26B05C0; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 143306B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A47361C3F88
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
X-FDA: 85446641112.03.C5C3D30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 161D580002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVjTxzhz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	b=Zlt8ppx+nsRlo+y651FPfP7sgO/dnUtJ3akBrmywgKxplXLQ1V6arBLIpS008KticcD/c+
	YOM8xrPZzVKnCw4fcDEtbqUtxkw1wG7t+EZNJKKiKxIXy6kWhzMp6OFwfv6IZZTudzkmVs
	/jZuvD5GjbGee2IYaCwtO7eRTDnvWps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968555;
	b=Ea29KIzh4pDn/ij8PeROuhTY1UPshBxDqSMVKjVsq5/OMOZVmIn35nQhJNgL++qB5AKi68
	yAIIoJ1T9k0oENT0V9e5k9DpCZ/gpP3Smum6NcnEGs/h6AeAikLVnpu7iiAzjmRLgbYQLJ
	YHtR91PglcqTFooXWKRDtuX+/EAJ7mQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVjTxzhz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 683EC45BBD;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294EB1F000C9;
	Wed, 18 Nov 2026 02:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968554;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVjTxzhzbtFvwoYZAdRvO/peR73ZJ/y7OYDyK6itHj4eYZstjmtC7u6qF3r+xkVBJ
	 ePkxCsN6b8HVFQT35Z15bgTYAGHcwXlijoh4dR8PlaPTJ7oCOr2AXDzAFhYvTQVhDM
	 RFClRsrwSDbJ3fuiKE51O8x6e+k5/y6BVRgf4FMoCwvT/bzlIrUUU8JKhkHos5xb9V
	 zhJ1zOpTPmxQMM8e9XJzLpRlQfeR62LKg5grSAOjh0u9FBzNQWcIha5k+Bsk7v3oRH
	 elD8RZXnI+HOVfrlNywZp7NJTRduWj4wT07VeFdumpAuvqnOphnhBRpclmEd5MJ6mJ
	 jsRF+DgGZIPhQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/27] mm/damon/sysfs: add reports/producers/ directory
Date: Tue, 17 Nov 2026 18:22:00 -0800
Message-ID: <20261118022225.100659-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 161D580002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mqh7tt4kjsgxpmzmd38xhr1cipccq6uq
X-Rspam-User: 
X-HE-Tag: 1794968554-582884
X-HE-Meta: U2FsdGVkX1/eel22ug3J0P5tLM6c+TmMRqj/R2IJAoMZ3yW1TDi4sM6vFhWP2FrYizB75XWF91EDijhAb8shPDrHNjDQ1tvwHMPTL5NlKdE79Mp45AvW5Lb2Z7VUl3NxV2gPL0H350mrpykqNKRQKNrwt3MHhbZV5ayP2aIZvlfSqiXwEgOOVZP3BHJrvJWSWur5Ym2yGzI5IATSnLaBNEdoalUi3jMiQ7zsOrZ6ij6arThtCr4s98m8R589pr0SuJl2LtTsqNVqLYysQUx8wxtHFGYY/DxU8JNV/U5RG3jRxdq8lFQjgAp8p74fIps8Wmwh7TPjVZ/I/KhJlfYdSqr4z+CGPwI9FMx9wQZPhdgcQ2/I/tycBqp0KSUDxoGb8whWqTAq4cqXlJnkyuTp+KDZ80Lwuk4t1XWvWz+bVRp1EdQoDii9wNTKSb4WCfY0pRiFzyf1qlfvsH93yz0ofFdd+50C9HE7lnEcGHp6WVmICzr0lrTnLF39qe1Ey72EKaH4LzT0ZTfwddaYuusVVfORhebwm3v9P+y/3+2rc+UF7XHq5QcWZKdHJ5Wf5lc+TdckEvSW3vkBHbCd6dZYqNwtbLMVIP60y54m27Guty9XrqDgaCt5xtwO1Q94J278SkPBVZ9sH5gMXFpgCsAzFfhEuCVs0hUoX/5Nl5GDrqUI2684kyOW3/K6z1vGDCFMzpS2e0hq51uZtQaqFB59ctdKwCcoKa/UFgDlMY3KzoFk9sIQ6v1fgwFOlNTP3fgMfGsUt+rAu6FelkyMGO1eMfEVbKEKZGOh2jaJ7YHxLXWUQ1kCBkVvATKMRCoB4seiu6qtanx/JofkoV0dtmHbfudqfRPBv9Z7pMxPjzl2jocObWq0Db2J7o4RU14tReKhstnefc5TvVj4f+E8X+5W94pzcXLlnCoH3ZH1S00vpxrDvF2VWP47+JTac5L7mywvqLXwWSFS6kEKxRJR2ob
 1oobiky5
 isSOMKX5KifoHh8y/N0XUUjL9cstmANIsnJ5ZehQ5Yagoc2Trik8/wcZbebYsfAHNJHkcwLFCqaxO0Nkpt4FGRER1kZPDxj6LZyjxDCZXF4Fb1qCONtXMICF/UtpStdsnMd4oPYBZkHYh3v06NvLY4UQabqYR73LL047JOCNgad55dRo0ZPZ3D1djSP3y9b3V7IjcJIsDaeFq9sdXh76dRwQ86alT6er9AsYZ4gbvjQiIo2M=
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

