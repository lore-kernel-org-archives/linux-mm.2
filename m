Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345D6606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqexezKr
Received: by kanga.kvack.org (Postfix)
	id D24956B0761; Tue, 24 Nov 2026 10:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE986B0763; Tue, 24 Nov 2026 10:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76B76B0764; Tue, 24 Nov 2026 10:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 931B16B0761
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99896A0BC7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
X-FDA: 85470415422.07.0E882B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 190D540010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqexezKr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534610;
	b=o5X5Xbv428KBrXecDl+jl2LCqhwt/+k449/bbIYqgnC4tZHVhoxlr9LuQdEqh98aQG1+gE
	m1LKzO5+KiO9BGLkEZlRKLKk7TJpRGy6oywu37/J+JqeADDWh5BbTNBSLs23n8dzrSUeFV
	T+Vae67nTi7G1+xn6ZVSMgDo0PCsHNk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Esn01hvGsm300THww7Bwi6euyaSw8hSdi0zfeBrrMo8=;
	b=y1qbgn6WzabLXfXSY6oDGU8MMZQuh1/x46qaCgOhLd2t5ZC5rN8dS15JWGQtzR9TmwIJHR
	rLl25qNZ5Vff1e6vjqS4Rowk3x9RtklnLkijPobrzh1bKwpiGLAnmFpMeAI4lKosAxv7Gz
	FJntsWjoEIcnq9OZiwY7d+ojhye5bK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqexezKr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A67C162719;
	Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E97D1F000D8;
	Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534609;
	bh=Esn01hvGsm300THww7Bwi6euyaSw8hSdi0zfeBrrMo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqexezKry5v9RKTJdbErdeFMxRZsYbu6SutiAqud4X9hU+HWOeAN3o7FWq+2uZbK/
	 ALxTeDWlk8pB1SAm9fKFGyfIaVi7Yc2jFA7EzQM/ESVBQatzq1BcZ7lIlLdke/h+ee
	 jJd1MjLT4eKWcUlDwDcKkT3ilJ1o0WCC/BPj7QGFPQyO/ribYE2JAJxRwN7idORPfr
	 998+WDF9nUPqs0QvTqHizX3bIlzhh11opWTIuYfLSfkbRS1Yr2cXz0GNXQ47QGy2cm
	 A48xQxmTeMFLMciiNpUVFcqK9ltBPSQbCXjAUGyEowmVdJJOxRV6G6ZP/3SPhwcYdn
	 ILvi4dh06VXOA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 07/27] mm/damon/sysfs: implement report producer directory
Date: Tue, 24 Nov 2026 07:36:13 -0800
Message-ID: <20261124153636.91854-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mnbo16zxeuwhjzmb48diay7r6xsgiis
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 190D540010
X-HE-Tag: 1795534609-681778
X-HE-Meta: U2FsdGVkX1+AMPkDnsw5wG7ozLdWcz7CmikAnnVM4ekreNoBkgDYsk1we0k0mWeq8MQrmzcwaSYYhj6BvbwHx7PLQlq5kcj5D0XosLqnxe+/JH5E/rwzYzjnspVtHiAJlA39l0WDgARbQZRce/rcAy4RzmjHZDPoe8+eyeuzmNFL2UxuQlkrXOxpoyDtSyC5zrE1lwhKvJ0u9LU9Khp/XZyYbKmjojxp7WTA9VCUYCMPtvVm6ZmTh53QK0ZaEq1232QalXhgEZ6UqTxUOvR+QSxkMZ2ak/AkdsJOhnvJUM9D/gx9aVcG8GvSWdtwhHgIUpBC+oGFnj2EgLoYst7rP3dxzC8mpG2qHeh4W4JOaD2+oPd2GmDhHpB61LuU23GFNqit8VNcGlgFuWlIZLvoG9WxNKZhs6hSBGb2JbgAfAyNDejpbAvBlGl2+712w3L22UZHkC1tVLHFo77dkBTloH8afCiJFtlfQnkWRnglZ6eQces26tBD5rxAs12zXFa/6BEGmmNhAVsrc9egXWTLm+9FwfX+oTPfRVMkBH2ShBnui2GjJR7IrykKz9t1AMeOrnWXOQlt5DoaIuDMnxMkCXU1/gqp6/WIlcU/ldg2z/i1jmwCM17BgweHSF49NIV3DqK0AgDrJSu4ScHOxeX6/Vyy4GNzcsr0w4oUce/opWPJhvc8WptNyatCLkHoMpRXNOo3miCAtFD+aP0LkmmbAx47A1YzRzzYgbkWOfeTBzBuDYqrQIIfavE8HXDDjzujZFYdfVokU9kH1JnG20XrEoZQFFIDRYSrdIbVAd8LcmyfqUL2Njii2T7U9Ui7sRPmFcePiaMzyx4qjksWaiLsFjL6p9v0huLeQI7R7keP9cioPFFKj1JTYv/9AYnCBGkSF5jn1roDoNf0lthzdjNSi8kXWJbFMaJXcYBJ6Yzu1Hu+PcgLt95vqJIE6LKiDtT1V9EN/3Mz3ZWnNolBYxb
 FWqVsuku
 2z4lqiuwWQApVnfdGZw7blITd0NA25LWx1CKlH9z4pI9j0ddssWV3ioW7/M17Smk1N7i8t25Zp23bydcUTxoAYpZcmg9jzfyBozfU4XCZywpRR4Olgz1ivfBBGTDRERgD3gs7zEFIN0KcoOyG/LImvbOydecfxzjgsC2L3PZ65U8Saciwexvd800TfB1jfV6FBM8oEL2NZdaSw+nlUYoETcHv6SoGyWQKSlx33F+sUbu2Z2Xbuc8k3nnq6NTiKKdw+fh0DIbJEMzCdaMUhd1CF+bAV5Dn/ujCc2KFh2q8dtZ/v3ArSqyQE5WjNg4IcEH+FMWf4Kq30OUZzBSLw+2RyfsNIzJENDteFrCgKv7SwNMGyxlpPJw0L6HAwuOwpQbpxYj/jKdyMCR85nyHmyQUjpegrZzCegNbkT6hr5RDp3nq/qLW7jW4tFfKzTwp6TK4FKhzeex2C/9DLZMUQj1hKc0Q1JCddL8rMGs6QydtojsGWUFryP42Rp84eCPKwzvCTIbkmrGAz0VtDe2OjGC3XTaqJlBfIhizrRczBIDG4G/VvH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement a sysfs directory for each report producer.  Create and remove
the directories for reports/producers/nr_producers file writes.  It is a
placeholder for sysfs files that will be used for controlling each
report producer.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d3a7cb170975a..7c6bc30c12125 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,10 +2979,40 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* producer dir */
+
+struct damon_sysfs_producer {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_producer);
+}
+
+static void damon_sysfs_producer_release(struct kobject *kobj)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	kfree(producer);
+}
+
+static struct attribute *damon_sysfs_producer_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_producer);
+
+static const struct kobj_type damon_sysfs_producer_ktype = {
+	.release = damon_sysfs_producer_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_producer_groups,
+};
+
 /* producers dir */
 
 struct damon_sysfs_producers {
 	struct kobject kobj;
+	struct damon_sysfs_producer **producers_arr;
 	int nr;
 };
 
@@ -2994,14 +3024,53 @@ static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
 static void damon_sysfs_producers_rm_dirs(
 		struct damon_sysfs_producers *producers)
 {
+	struct damon_sysfs_producer **producers_arr = producers->producers_arr;
+	int i;
+
+	for (i = 0; i < producers->nr; i++) {
+		kobject_del(&producers_arr[i]->kobj);
+		kobject_put(&producers_arr[i]->kobj);
+	}
 	producers->nr = 0;
+	kfree(producers_arr);
+	producers->producers_arr = NULL;
 }
 
 static int damon_sysfs_producers_add_dirs(
 		struct damon_sysfs_producers *producers, int nr_producers)
 {
+	struct damon_sysfs_producer **producers_arr, *producer;
+	int err, i;
+
 	damon_sysfs_producers_rm_dirs(producers);
-	producers->nr = nr_producers;
+	if (!nr_producers)
+		return 0;
+
+	producers_arr = kmalloc_objs(*producers_arr, nr_producers,
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!producers_arr)
+		return -ENOMEM;
+	producers->producers_arr = producers_arr;
+
+	for (i = 0; i < nr_producers; i++) {
+		producer = damon_sysfs_producer_alloc();
+		if (!producer) {
+			damon_sysfs_producers_rm_dirs(producers);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&producer->kobj,
+				&damon_sysfs_producer_ktype, &producers->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&producer->kobj);
+			damon_sysfs_producers_rm_dirs(producers);
+			return err;
+		}
+
+		producers_arr[i] = producer;
+		producers->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

