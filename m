Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313A0CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7876E6B009E; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6983B6B00A3; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A7A6B00A1; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382AB6B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04CEE1C03A0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
X-FDA: 84759019968.27.CD0D3D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 551422000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0sv3yot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596622; a=rsa-sha256;
	cv=none;
	b=yISGS8JfkLfDCYSAx5+nFUyOJN4lKSLvO351eH9HdotHLzYzywdz/XvIGbGecSOGfDuc6D
	FDkEasqghTSb/WdHLvFlBfiU87HD6FQ7YgthDy6ouitVS/2PO0I5YpXRrntQgAwskvTKbL
	ffkZVZAWVEDlsuQEpesV1Zpf0KUl4dU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0sv3yot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH6giCxdh124Zq3I+dXuH1/1rU/xZgVOnEr3DNyTuh4=;
	b=qpiFzy9oR91b4V5VJTTtJUYJs98iDClVAKvN0ov36o13qwSRYCDgLkPh61cDlV6v/OBrji
	TzGVl4wpvlHju4JtPLxt+7teIPHcQ3JeJTmH4uB6/MqeT02lc7dVNDJA53KnklNixzMdg/
	XaE+znUvNzu1MKscAxb/p5NXzOGSk30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82EE744AB4;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E078C2BCF6;
	Tue, 12 May 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596621;
	bh=SZZB/8Y34d4c5OpPrN0Tt1+a+YDiqj7LFYZQ5Lka3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0sv3yotRwx8KtFM5xZjeSoYNFJ9drE6c6th8ir9S7Hu8QUHVRSv3C8r2Oxn+YvHN
	 zg8+3L3byobrA6gvR/9ueyY5xOnJafXXNmAaDlSF2cGWkhaiq6SH6atl1yP0BD8pmA
	 oSNNrVmA2BDyo0ZHfLqCTabMFwxmRyVS/TDQWIfP4AovGDX3m/U81OhKmGaNUdN73l
	 oRNUHQG7ziEGukWVB6egNVPlp5ZY2/oKMMYx5XmQzbUf8ogdvTK58Swefojd5z3a8c
	 Se2OwcYPYYDNwxw3rQg0QVMZb5EQp8eCH6SdkDEqXQADPaJHd8q+9swl98yNVQNwQM
	 Fpxm3Gxti3xnw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/28] mm/damon/sysfs: implement probe dir
Date: Tue, 12 May 2026 07:36:25 -0700
Message-ID: <20260512143645.113201-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujapqp8nai7p8pggbu8kxt6jyfqa4uuj
X-Rspam-User: 
X-Rspamd-Queue-Id: 551422000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778596622-408675
X-HE-Meta: U2FsdGVkX19iLzq0JJde+RE+UYQXHljCPijWo9FSxxgggJHHD+BAhxtJ5u4T8rbHrrqm6g8IX0XuIGTm9bBzcKOsbyWvYadlmfF+InkE/x0ZLH7ApTGYQ9k8/x9auoXEBDJx4ilDhO8m8S5TCwJFdz9RUoWfqxpl41zIJ4Ygx40nCbSzqHBiL7wiJ25xTsvtvxUJE/aG/aPG6u264B3fxa9RXUfnq1EFKHY7g2sOonvsW8M+2BPb7xNDI8F05tOFsxnxvdAtFN9SLtOVTzKWeksqbkoP3547qPc5oXZvOhapjGaSfr92KCXDhvEJrzGFvNd6gzLV3v+fIViSHNmCbi3TEnKjh48FZwtbe0704ZkqANlPBZQf6WyBKJnuoclhsbSoHjeOidXpUKwMzbRE85ftMNTTKpfVp1Q9KNgMQL3F35K1SVg8z1skSvsapyNq0HE2oLhcfHG9B28ReJzj5nJZH74PZMdQVQHzUIM/8ULAx7sLCs92T7xPeYEZjswlckQy30qnUjcbtV3lyWhq8d6G9c7JCSl/vi89TLatkObxKYtLyUiQQA2DA3mugjktZQK3JH8+cR3zyN9QXTnmcBnWiwrmjcY1PCiLn4vIXzzhbCCIoBJV1UJ/ZGup6GAhuoiB3yGbJP+T2/nV/ln6Ojvx6WTcf2MLwXmGXbcEZnlhQ1e8qlLQ6KwdCQ2FOwOV9vc2MaoNCuV0wT1TgJUWqUmn+RCqCSQ3bhq2SnyaMC1/V/Iq/ia+NQJUpz1YFPaw4Q1KjPEvpcCZGV8pHOA9AFGpJffXo/9ub87SAx1OFOYISu7khkSr/+e/oe1iYIQWMNxvAtQJdPLXBgpJwon/j1i3pOCo5XzVRq3ghCpSOgSHD3P4rdRnVXNDEw93ScZp4OYevPj24nUbC8sUuY+yzUKi0vXcYbcoD7aO42VeMlJtwmnf/YXJYXFoYUG/MkT7OgmrGjnzqsjvFA4tGsx
 K+YJrG4D
 DHzlOuVukxvPcTDU75NitYGUvEw5fPzmaWae870cNcplHhnzfvmDz7jzb6tCfvm0G83jL11+rxD6wVV+IZm+Vb5ut2v6055wF8Gh7a2HfcYQHLRP/vM6lA979Sd5CeLEQSOzg7ax3kg0nVFh79RnB9T9DU907l68hGjRyCNRgQ5GIX+Bbiz8oOue+HOah+2Yfnf+f9NXF7dGiZMModMxvWHGDH2X3RlDMMMxJR1Z5TEcSn3HVSYHON+cb9OGqK1DNhu21WheAqkufiyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory for letting users install each data probe.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ccd19fc062f31..fac4e37aa2851 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,43 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probe directory
+ */
+
+struct damon_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probe);
+}
+
+static void damon_sysfs_probe_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
+}
+
+static struct attribute *damon_sysfs_probe_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probe);
+
+const struct kobj_type damon_sysfs_probe_ktype = {
+	.release = damon_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probe_groups,
+};
+
 /*
  * probes directory
  */
 
 struct damon_sysfs_probes {
 	struct kobject kobj;
+	struct damon_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
@@ -760,12 +791,99 @@ static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probes);
 }
 
+static void damon_sysfs_probes_rm_dirs(
+		struct damon_sysfs_probes *probes)
+{
+	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damon_sysfs_probes_add_dirs(
+		struct damon_sysfs_probes *probes, int nr_probes)
+{
+	struct damon_sysfs_probe **probes_arr, *probe;
+	int err, i;
+
+	damon_sysfs_probes_rm_dirs(probes);
+	if (!nr_probes)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, nr_probes,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	for (i = 0; i < nr_probes; i++) {
+		probe = damon_sysfs_probe_alloc();
+		if (!probe) {
+			damon_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&probe->kobj,
+				&damon_sysfs_probe_ktype, &probes->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
+		probes_arr[i] = probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_probes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_probes *probes = container_of(kobj,
+			struct damon_sysfs_probes, kobj);
+
+	return sysfs_emit(buf, "%d\n", probes->nr);
+}
+
+static ssize_t nr_probes_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probes *probes;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0 || nr > DAMON_MAX_PROBES)
+		return -EINVAL;
+
+	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_probes_add_dirs(probes, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_probes_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probes_nr_probes =
+		__ATTR_RW_MODE(nr_probes, 0600);
+
 static struct attribute *damon_sysfs_probes_attrs[] = {
+	&damon_sysfs_probes_nr_probes.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probes);
@@ -862,6 +980,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	damon_sysfs_probes_rm_dirs(attrs->probes);
 	kobject_put(&attrs->probes->kobj);
 }
 
-- 
2.47.3

