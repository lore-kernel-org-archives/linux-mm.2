Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8CECCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2092A8E0002; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169368E002F; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF2A8E002A; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9A1D8E0025
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F02D119EA6
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:45 +0000 (UTC)
X-FDA: 84005314890.21.37443E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E08B940013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C+qlOTdg;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSh9O7WjsU29jpUOgA2lbtoq+MW/6K2+8kx0swUoTW8=;
	b=5IcHfAj77DGr3ubhmLsjt9IAaNvJW66mvp1GDBxT2bBtTJxTDIxoarlh6oW/YQfcpmeoBr
	mWON3NUTUdxJ0uryqUVqIxxUF+1LhKUx1B2Gky3gBaM8KYF+bPxeVPg7PALYkR8BInTin/
	yklkJGx9HRrsM8zrZcoxAn9v5TKmsho=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C+qlOTdg;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651264; a=rsa-sha256;
	cv=none;
	b=n+SdKlU6ge2wIqLgzzeiz2iPxhQzUuBTerTwNIiGDxhgRYyu2Vcl4M5RFq6rBE+PKHH+yk
	lgDLzibsKNC9LBYbiFsJZW1cZWnmpaSWJ+jAXLvm/N+7k5e993Qm6bCw3cxDtZdWMkZPWI
	rZZ6XRYUMUUKaGUU1pkvBNszUnpU8D0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F10F54AB94;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2C8C4CEFE;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651262;
	bh=vMZBXyvhJMOl4zotXu1s1K9lxjxFnuvxDMlO/rfX+QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+qlOTdgbh5bDWacdbxWIvxw6RJWy/D5L1w66Mtd4fYbY5YrDn1kUo6D6N6ndZ57B
	 LzfhIvEjiCBhKQXavJWD6QyH5rqegkT9wcNcd+WA7I9rO/0tNgLGllgsVpBEjrKQnU
	 bUJELxc7JiCROnqZhnY7YsgM1rOUUV8AzlIM4KDI6g8JIUQnqhxICysj6/YU9YQeMq
	 jZ/BnJQ+O6XlDMxnGjRfwOfMNmOb/S1VYAUH5s1cR/CntZ9P30cpdpzpa5uu4C0d6T
	 HqOEh3YrLUxiXJDwRFQnhEwLfCST0fhvgGlekr1lwIN3rHE/Rew+CE2gzrd39Yjl6R
	 ujaCfXVAsVjsA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/sysfs: implement obsolete_target file
Date: Thu, 16 Oct 2025 14:47:30 -0700
Message-ID: <20251016214736.84286-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016214736.84286-1-sj@kernel.org>
References: <20251016214736.84286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bswtntxdpy9rt1wdxtfjgkt8rw1m19rj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E08B940013
X-HE-Tag: 1760651263-790400
X-HE-Meta: U2FsdGVkX1/fCfBqvixwvxXP4arbCKqTk2g72y/TjWMyposjg4KndOtQatM/fly8C252kzazrPDJefjMylMtyMwXuMk/bOlDNlzrx4++ZRz//oik6wHjtJDc2tFZWl7af7W3IhUnIWnYXyEKuQUlzqwXGxIzumiWw73IeR/D5wsNK091A7AONzsS+/P/EWRvss+QqtMwo7NTnItGbK242TA+tAjuvRT5rdiLMmFhcl1EWzBFKy/e1P6hgsub29wgPKqLGKlkhjuDBiT3oNReLe6CFxoeWwyYIWb+fCV/yyl7IpsyysZQYScZdkcrm5t7LCbzF8RBd6dQjOBjy0ZrN5yqYtd8JyCpdtKcHrw9Ssid7XXAOZT0zahp1jygdiwLuaPUYd3Oj74vz7DU6mR1SKiPoadp1BbToUBHxojGDMTXwkwVp+G9xHGEI16Yaay1jyoZ51GIeg8fw3510+6AtKDFlAh6JOSNX9LF1+/wLjf4NFjc3oh+40w9BISzSyEd1OO1osApcxt53tTBgYzhxXwXV/Twl5zVFfpbEr1a6Z1lkX+6bbNfregFh+3Vpt8K6hkRP/V3o5MNS6zkuAcHPGerDb/lWpYC2m2EhjgokmjJ/RnAGc5umqdoZSWjB90TINtcaBBXR8VWymD+1AUZ0KHCpTsQDF/M0hcB36jQv8hmd4UB8i++UM+DQWFWCYU9msYY+O5Yvjdu//EmlW9GCAqjf17U30WqQlmLa6hh9skMzq6feqUhPQw3Pb4TSXTBQ3l7soitV9D2XLSvu3F/0n3wSbWYsYqoy6YcPt1x7QxQx8D3erRbEI4qtzvgUz66zLTB4zuaVxTxBGXN9g5BwqFRbZJh3mDIHaoiU4Kos/goa5xe1eORlAcWjpISGpWKYei+T0dU/zOzHO7oC1al3h3MYDCsoGGXA/+/5THJCdvctRxBvqwnLC6/a23QZLUgiFAg+pDfvobuUKpf4/q
 R2w0CNlM
 kzYU3AeA/oBNFB3Fybpn8K8fHNpMqukvjm5yA0GVjsEVUBUXv35EMArI1Lrg1o2QKwkZ6414wlwlv1Oik4AGXzg5DKmTXy2Tuwj1YX+9PuvX+JriDJd7S/anZcl2HCX7kXR1ZfUaHtKQPX8a7YTcAqO7sBx47MlU/InKZUQfWHnExMepXQlYN29pWG3W0q+yWyr8m5m/erOXHYkhrhTXZP3iqzVbK2JxQEMH6e0FGYkQkUj57MF15zoyNa0jyD0PsRJ5eY49XdbUgKSx7e/MAo7aABRLDaWn67kGIV4QqFTn8Mkg4fCbVaWmpLO7ni/HcTaMI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no good way to remove DAMON targets in the middle of existing
targets list.  It restricts efficient and flexible DAMON use cases.
Improve the usability by implementing a new DAMON sysfs interface file,
namely obsolete_target, under each target directory.  It is connected to
the obsolete field of parameters commit source targets, so allows
removing arbitrary targets in the middle of existing targets list.

Note that the sysfs files are not automatically updated.  For example,
let's suppose there are three targets in the running context, and a user
removes the third target using this feature.  If the user writes
'commit' to the kdamond 'state' file again, DAMON sysfs interface will
again try to remove the third target.  But because there is no matching
target in the running context, the commit will fail.  It is the user's
responsibility to understand resulting DAMON internal targets list
change, and construct sysfs files (using nr_targets and other sysfs
files) to correctly represent it.

Also note that this is arguably an improvement rather than a fix of a
broken things.

Reported-by: Bijan Tabatabai <bijan311@gmail.com>
Closes: https://github.com/damonitor/damo/issues/36
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6848437b86af..26bc658ad873 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -212,6 +212,7 @@ struct damon_sysfs_target {
 	struct kobject kobj;
 	struct damon_sysfs_regions *regions;
 	int pid;
+	bool obsolete;
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -263,6 +264,29 @@ static ssize_t pid_target_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t obsolete_target_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+
+	return sysfs_emit(buf, "%c\n", target->obsolete ? 'Y' : 'N');
+}
+
+static ssize_t obsolete_target_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	bool obsolete;
+	int err = kstrtobool(buf, &obsolete);
+
+	if (err)
+		return err;
+	target->obsolete = obsolete;
+	return count;
+}
+
 static void damon_sysfs_target_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_target, kobj));
@@ -271,8 +295,12 @@ static void damon_sysfs_target_release(struct kobject *kobj)
 static struct kobj_attribute damon_sysfs_target_pid_attr =
 		__ATTR_RW_MODE(pid_target, 0600);
 
+static struct kobj_attribute damon_sysfs_target_obsolete_attr =
+		__ATTR_RW_MODE(obsolete_target, 0600);
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
+	&damon_sysfs_target_obsolete_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1574,6 +1602,7 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 			/* caller will destroy targets */
 			return -EINVAL;
 	}
+	t->obsolete = sys_target->obsolete;
 	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
 }
 
-- 
2.47.3

