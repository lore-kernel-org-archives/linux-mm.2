Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E70CD4F4A
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5536B009D; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3214E6B00A1; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2108F6B00A0; Sat, 16 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B34B6B009D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C78611C02A5
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
X-FDA: 84774141060.17.11D717A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C74E14000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HBfjDveL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MARP1ovOf11dF08doO5hBhw2pjUU6KvEEdltSHocbmg=;
	b=IJIR9RECqdRKmuhgy896h707xALhGa+iKBQO6y6esO0oOVhh6jRdmOFGx9Nr76uPfHS7B5
	bSratjhPL8GPBEl2IO9CBjm5srD0fDCPN8776QBc6gBCWnpHR+n1Xl0n8OZSi5Lr+0UZzp
	VPjyh2lLi5EXa9BMM0uTGtCd2ujaKEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956649; a=rsa-sha256;
	cv=none;
	b=VUnjgrY7zAN7t54CuuuE/5A7x7IJLxE3roxGvKytmWtdkENFZ1Ewj6oumNm3/w6n44pLMN
	mrXulZkH1Jg7BzJZ8VDyoB73auQYp/Y3H+kxIYZj62+/hbu1plDcd4ZlYEv9x5ZsQyciLd
	tqHXKBqxWnMaPqT+3+rStc/JzX4zSms=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HBfjDveL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1594A44610;
	Sat, 16 May 2026 18:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0978C2BCFA;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956648;
	bh=WYmv4bT5UJuMRx71xod34Pd0amao4jaLlWchqRhE7dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBfjDveL8mJyDYDZQuy4FgIoTDXLxwDdX5RmY7qfHqZoBxBzUHtf3nZOwe21OGScB
	 InS3vc5L9fBnSomAQv8on8fE1SM0rR91V0xK7x6qOyzry1/PYlLqYODNiU3OmeL8ib
	 aAW0Ulbt9+GmatqlMsGFcArr10vc9v4FSHXWZ4JN0OIwtZYOxSw6jEKhTNf20inOyg
	 O+WO5KiOpFeD4/uQ40QPZ6o+vLKlK1RWHJeHTXloJAIe9TwJRpOVMY0oZMAq6EeKS1
	 NBNYagYVkW0rZAc8gL1GdIudnWqgEMcQxaYtAcdUBMBgyz7H8p7cLHgX8ch5szRQZI
	 6QmgayJqrIvuQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 10/28] mm/damon/sysfs: implement probe dir
Date: Sat, 16 May 2026 11:36:51 -0700
Message-ID: <20260516183712.81393-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C74E14000B
X-Stat-Signature: abf6bsxhk8c1chzbgpthtmm6u5ys6iqj
X-Rspam-User: 
X-HE-Tag: 1778956648-721473
X-HE-Meta: U2FsdGVkX195Kzobv/YBezZ+McD5M0RtSyk18Vj0dzCXjmgpJC+fdbziy+m5rCVBPoqBtF2C9NoC50bslqE79w80XroPDo9wlmUJabOgap6N1Iv/cZvqiJKd8Sf4+dKQoPRB9/xrxjS2l44bM5mmFja6hhSRIbG/JUkyCYDSIqx/flMnfDkpj1BMtnCaWYQp8MgepnuUp/HSnhsY0SuTXn7Gkdns0TRy4WTUsOFn+a1bWD/0qqr7M74gjjJuLbjpSeJTho1agJnNL8IkdKMqKUcLFmBnCU5iySh5lcwgKRM0bu7dP5zEAxqaQFGMpua1hRnN4LL1whnn/7KEAJV8NGAZs3RAAAjwxwcVvh+JhfKiWaMDSIQ4Vj3aQfHIFZl/nEPlHxF/ltUDlGjcMuzLB8KNrFl7l1gQVdYZceo0qfTu57oNmi8HbnBizqYYVzntFbFPh5n6OYs+SgkeLuaGozCQ4UiAcYfTy33tTuLHGOYltc/zbda7/cngI75b2vGluXml53qnup/Ff5tst4TT3NpwQG0FcJmbZCpTXZv0rfHzM5WQk6wYbQ2iUjmCtk+OYE45ULPWsiIFF+g1d1euVAwpnrdBIZ31NxRL9b4Jd8Fxfdftzr1rU16NT4o7clrwsvoBasTrHGp9aiwI6EoW6zhHuCvpOLgUKRtiaPIDOz270qEDcMXQHXnJrq/ACbVQY+a1sqXip+x1mV6fpKPZd3W1LExEr1nnf0mVBuPAyAZKOCCQF3whA+ZYKnJA4jrkKdEAD5POYIaV0yjmR9K6yXrQPd23pQmxyM+5aFrU1MhabZEzAOU5Vo0UhskDnSNnINNchkuJNpBE/WBc+6YcpyMGuXDet7Psd/axXG/UqKHaaJXHC3BwcbxKWL4WbFMPWe0+hn8wz/as+emyYIgzboa1QzTXvr8wbp6cjE0kodBtgFM0PEcdXvarH6WVUNWRhxHtszoAe8vzVVSvgn7
 rEXeAT6O
 732gostjdVzxfLNozo5e2bMUj4VnxD6ZOkAIqfOgirNZcMacfTWeGduf6l8C5/AA8JN3BFOlvoWRlr3e1nZwWYtj2iUyJH0f7AQe7Ih/fgoMRLb55X8cUYW+aBvv3MTVZp0YTGaayt3hWXPIlmAvVihW4vIN+ArB6grfw4lwGes3Qgy19gSgBPF6+GudAfl++s2n0HQP4X2OMrtOvyG1iqjqlMpbMny1CSbULcykwNALLmbjeU9CTudw7nypMInMmTzSh98Pxg1sFujc=
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
index 5f3b253f50ebf..162d2d55be08e 100644
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
+static const struct kobj_type damon_sysfs_probe_ktype = {
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

