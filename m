Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9713606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G31lUkYi
Received: by kanga.kvack.org (Postfix)
	id 112346B05B6; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8CB6B05B7; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F400D6B05B8; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C08AC6B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12CEB1A059A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
X-FDA: 85460344410.07.FCE6198
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B70210000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G31lUkYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294823;
	b=NWA6H2BwVu4njLPuxlSa6mfhQ84Q7Qf+UvXVdHcHQg1XdwAoIhjN3Y3cRVHcggietRyXB+
	NgFdX6q7y4PITasI03yood/1T77Y+W3gPWN4+qLOiyr9TP0YJK/i7E/YPK+mlO7MPUYFiu
	r59C78kyT3SJDQGapIQxP1/kjmh7J1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	b=12SI+Z/txdwKb3WtwNXmCCY68IouxeWQ1pbJHunm3p3HC4e5VpX7IwQC4vlv+mUbZAyPZM
	0R+j5xSEsv4YVKe3w1VdBv5G/Cfb/YmiSssVk3pXrdr++iz6a/RyZQZRsdk+YadH0ohe5S
	py1sNbhx/gx6kRJaJMdE/wMKecByweE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G31lUkYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CEC661CFF;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DBB1F000C6;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294822;
	bh=K0fbCgdlmQEcNgh0aS+DhL0N4RVPNO26toOvZeF/1e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G31lUkYiM7RSguSM5A+wq7uDAC5yYL2rCZeF9Sz3m4NZmjQtyeevALKpDzBWdEBBj
	 hxSG6F/taqg8InowVcMsAmvKZbOPXfgM4hGhHIM2HYse+0/XBrBlu9QTcPR/0CeY6V
	 ZelTFDDoUT/Khp+E6o1KtoJk+UtdR00q5F4rtMnH1tBdKPn7D1/Xb8k5M73RCI56mA
	 mMEFeFQk3+OvPN0Vcslh0jPPVT1Jb6MdMuXWrcEzFyuQTlWKmaxCYAgFOm3dpIdi9G
	 RnCfdngXCEA4Cxupv2nmnFqr2KuzvTw6BKluvHcg+559B8k3hO/9m3ZJYpTAY7kTzr
	 fRtFmsVFyQMkg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 05/27] mm/damon/sysfs: add reports/producers/ directory
Date: Sat, 21 Nov 2026 12:59:49 -0800
Message-ID: <20261121210013.130397-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B70210000B
X-Stat-Signature: o5rikykgwheid1o1sygboq7kxq9fwr3z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795294823-299894
X-HE-Meta: U2FsdGVkX18ltixi/oWqiVmreSgSupMwU5BrXTvsx/arhS7ai3gr9HYBSAo0yikZvAUJrfGntsTt7r1rX5n/6X+aHaALrVShuC4YvTMZ1dQFjDIS2fXP7YNruxYy+tIRGC9HlwVJz7Grjfn5TIqMDZssj8yI5WX1LV4Ks3cIr0v7z4X+JaHWrtiUWkIQCKlrUhHx/WuLpCNwaMKIzMHyZwsViU17DfGkAYxWcJTqusKHpfYGQVFFr+4UJWPi7hj3ubUZSXilS+dgAjcnOgmbVCjnDM2TGdcmEQoWuQ+yqOR7m63Vul2RbESGZ6J8dNFg/NP1gxOhNL+qd8zaSZWUQCQtxs2kY9QUPKdswo+5YsOBF40hTxS8lRUgOgI/SrZDF9iaXipp97qHetj+CBa0gvxZNo8o0jake5She6CK8Q5E1BW17wD94P1it7XErgOB3UiHvZM4wZHghl1vmT4becPkUQ1H7jm11YVfekC+aqhyTUy5MI8a9pZKXu6r9zltM05DDNAYkGcZivaafWrHspMV/x+YYqh1FZ6XfZ+dDGSnZynBlEShBjZxUk4aKu8W6NxZd9u+JVnUb4C4udibJmoYE1C1O3/jmNGS9O6QNkwxiOqZjFKQ041FT+r9ORTiJtaxqJoIURtadZhc3e1RH62GN5XHwTMFalcQ3yjEhL8w0qonSIIdARqbTqUFiCHw7aFv3iWK7gh7IJYKPkMYhH/rl7D+fat+7LJye1/qVW0L6N6DkomjIeg6upMz2gmcYHO78zprPsbyIQaXwMbr+Qxc3pCo6izF7W9mMMSLoEZ9R3qW9ZVnU51G7ZCwMMatF0fjQhAB3q9llkIvPx1187UHVP/f+B+APAaJJO0U6k4/ik0voFtvcwizFw6aHIFn7m85DJfiw7YHSza1LULTemnkd/q0OalM/VUVTLEH2nNQq7fppAUVZZlmmmTaoGaEisttDi949ZrITsy/lUW
 GZPPgMhS
 TyvkGuMNgkaw6f1cts3IIIw7Z21E1/Tccp9ylJhJqcI8KP1egzCgE/uuzuwNqQUObU3EziXUli8ZjTL/HbuVYELfMcHN3xnjBKVnPyqv2J0x35I8/WLpjjs5a1iYZ65chlR4EtsJqoZN7/3GAK05ZBnr8crp+orx2UqLv6C4C+Tk45G2ZH9XM2IWHgxV/pb4HR+cOmNR61MwWr4+G9F+EDcQ7T0IlJf6fWR6xt7BHUxhaA9k8cGg2fhdRgaBnNMGbLwGSjwYOsA7EFyGJgK+oK6H87DG1y/cGYY2kg3n/NZhaF4aHu57vMpD5BsBK7PHYYR/XRyqDX0mGET1dd+rMR1Q0C1gt/qjJhPAymoQU5cT87o4ZhGbus9DW4509iNoGTfRu3JWGMPhsptmHE7BjZoAVn3kx8yjRYEuj8XlBwcQ/UqIeUq2wZLiD/ECED65MQImKn4DhjLINtRQ=
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

