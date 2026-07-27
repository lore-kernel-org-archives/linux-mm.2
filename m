Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E102C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCA96B00B8; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55CB6B00B9; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5CA16B00BC; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4FE6B00BA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EEB61C0ED4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
X-FDA: 85034812758.24.30DF0B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C3EB4000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avRc2BTk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHE0coPeOqRqXIJwfVaYEOggVIIzf1bHhvcsS64ZKwU=;
	b=f91iYvGWpR2dy7wPFat2d7RYxDTlt0u3KrdN0KjTWuhHXL/MSpI93q219LGUN3TIv1qABd
	7glY1NLyFYxbSZzySn02PiGn3qVTdxDj5ozDP6bcEYQZN0e87Y5UbpsqeA5Rph36VaEgfd
	KnWYLU8CN8gCv1e+GSuPW6VueoOLw9g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avRc2BTk;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163117;
	b=pIITY+WJpm9jRP0YBHo0Cx1B7r1lG/so3L+csDj/c8puYkg400xPRfUzI6leT2fXXp1R4q
	U31IN7BeYYi/crxSMjz4n8GAl7ubz0NFd/SG9IbzY3bHAI347SXP5Mu/9gluqcOlttEope
	H4y3kjjtSnMCzgehz6iBT4qadcX8w2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C17D3436D4;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818841F00ACA;
	Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163116;
	bh=pHE0coPeOqRqXIJwfVaYEOggVIIzf1bHhvcsS64ZKwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avRc2BTk7qLcWSdhnUZClkn3j6ELaJnVwWq1fAvtLsuKbFCRxd1qBLvESlHYZUviD
	 fPCl7uO+u3M/eV4GeraIVYIN1oQGJBkptEQpRWrPJ7M/FDzCZ5HPCXEOzJtf2tVzky
	 BBHeSul42z/8+EPdwaVmHg/Ci9c/rcI9TX6mc7OVWBROIasNYaP9ps7nbqj+7xuYRv
	 X3NBz28DbIEvSGb9rfdovrMY0O1gnMheKoEeM/3zkqp7J9a8OPzVyf4fKcFYNpt5IL
	 UuPSzeUCrye6cqoJtb2P40M6EiS+h/wT/eUBjeFnxdaXPYrG2SqFHgIDN+LWx4h3tm
	 Qs7r7fPIE+lWw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 12/17] mm/damon/sysfs: implement prep_action file
Date: Mon, 27 Jul 2026 07:38:21 -0700
Message-ID: <20260727143829.86236-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C3EB4000C
X-Stat-Signature: sqxfdx1tbfz9zyatxg796dwbqztxrxbg
X-HE-Tag: 1785163117-917976
X-HE-Meta: U2FsdGVkX1/gct+Gke8nzDkLmKIWnBXzBTCufISSOOuNOZujmTzpyg3ZxwaFHxtcjWHzSxyoddIKY3zVSIbILKQtVj9B7cgehaoGjb66ZGiPskMSEIDLLGGdblBYPHDEhR5YjF5vfRiHzKaPlHi+WHkTNItZWxSSLdaDBMZ3E504BnnZvx7wNg+8BSQvfg0BZ46IT7geBdpZIkGiMyVUnI2MmYbbzBRmaBMuH/sN6IYuQcASLFFLiqF/4pzges+3x0plOgeisRRhuq6DyC6NZW2SkO4BbDZmPzvh20c+uy8Ssro1gdqjKfbQGXuICjTdw8JZ+l7wb4P4MBFI2gwOm/sBtyEkLqPd7Cw7MChAw8ghPC8FL6TIC0GspYn4ozGhRozKi+3m5zwWnAYl1fZ9FA1U5J/VmupRJsS5IGVEv69sab1/TxzrRVcI29b9aH7qln6LNhzMDcTwHWq4qsvfSgSX92cscNaTJvtWv6fNPIfH0Nhx4jAwPFUJ5THx0WVorUV+VLyO//hCVINGhKFfeqtdfkkxBpDaXvfACMzfc4qt/2v6NQuF3e+Fj6aSUuuJw+GIA9DQAmKOtibAZ7IakJrCvSLrSSejH/03h/vVMiR7bm7h+IaWnTo/yRpkW7K2nimcBaBsyl1RONHhlOUu+DMN+NcIUf9jA+7EG6K98DFXLtlGEnCms78FrCAcQVnLIBCSw8IGdFwAJeeRoYex+Dqqc4GpA5He6lpvLcibjysCDA3WoVoD4ZSEW+nuJjJkLcyBriMHbAVH44lcaBBKDlUwLs3q6JtribYSAA0yhRefH0Vm6wd+E7bISerH7TdljcjRvgXfeGe2aEqBtkctJP9rC4XJTjCxY0cLB6iplVAifGqu0ubMA4e5BaEwE2Jyw1h+nXRhZFpeRhel7mit4sWmGR7HihXSZtF1XlSlDi05u3vq1gxWG1DU3MukIKPU4SC9HdGvFtNR+C687OY
 CnA71nNf
 0CIEHk0HrjtoihhTrWl1fLfXQp/gAl3840pp6COFEuZm0gwjURrQ+NuAsL3K6O6AtvfPrssd4fgPNmrtW5yMvj8QlEJuTC71aoWqVlsQmPIX4FfxNbsYHE16qIOYNzKfTyK2djZqXtOTYNMZ4oeyGWlUkrsjGP7u0tOxLm1RKTX6XApG+hemxFyltbhj3Nn4vZE9FrsONy0F663N5231k2Ku3WA9MK+E6j4t9ao3GWSgCCIr90ydvhEUlhdpt3ETdVIGHykEf6+rC8kPjUdReD8VEjA==
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
index 2ec33280a7a83..0173f37fdbf3d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_prep {
 	struct kobject kobj;
+	enum damon_prep_action action;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -765,9 +766,61 @@ static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
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
@@ -776,7 +829,11 @@ static void damon_sysfs_prep_release(struct kobject *kobj)
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

