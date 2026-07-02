Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C189FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931F56B0136; Thu,  2 Jul 2026 20:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3506B0137; Thu,  2 Jul 2026 20:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2036B0139; Thu,  2 Jul 2026 20:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4D26B0136
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:48:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98F7FC0665
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:49 +0000 (UTC)
X-FDA: 84944551818.27.181DF19
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F909180003
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=oKls6MaG;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014047;
	b=NGY+pUNzOw/wVakconYu4XPUL+gG2mWjaXpX5Tm7cVJXraSYlCZ5oMwo0x6MZQd72vcNcL
	ha9+Oud/Sg1vu2RYPazJ15MJ1Hd3Z39BSUk3BDsZsSn+yMoQ5eMJDXJ8UKGrf5CIowaJmK
	HDBXcADD6wAJPRxYQ2LG9cFt8KYPnQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RalHkUMqjXODGCA3necl3G/M5e2tE63FCMjS/RA66vc=;
	b=I7AwmrbwzdKl1PDvL/aKWQ78aSGHkaE3+IE+ay7jWEkXpkJe8KmTGv1OlTt/ZQU1maPhyF
	OspHKEBjBjkt1mv02DCo31DJ3AT+1Gzd030ZnS31sBL57wLOlNpD5NvfwACJGY03cS1dj0
	m+gjsjmkrrBOe5LlvgcgdiQg8669JQw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=oKls6MaG;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014047; x=1814550047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RalHkUMqjXODGCA3necl3G/M5e2tE63FCMjS/RA66vc=;
  b=oKls6MaGESx22lfmEnZeaBNeFc2ky08scIr9iQMlp5k2I5echa9qHTW8
   Qu7u5KtRfBKenCqSiJ0tkKVQRvxijgt4YuoWJCaIKCD8VP8ne6DcIjcY8
   8PrH/h2JpyFDUmxF5IcIMq9XUclWK2bGPzko9Wjc+Em2reLWqXbkdiXsR
   gDK9oQaiRYu4zdhAYjgZH4S1DK2wNlJavF5doMb7VMyaoe2UEOZMo7+Oi
   +ShwEfE4QvzAc+tnlNSk7e5mrgLeXMygC3dWeWb+4H0l7xl/RQLRuyIWE
   mfD4rhAWos5ggplsU/tsBN4X0yXh0/OLiTcsB2cNGsg2zK1a0SQRK/nWM
   A==;
X-CSE-ConnectionGUID: HOUxIlnyT4ypCgsL3Xtcaw==
X-CSE-MsgGUID: A/9DmCBWShOikppfD3tbJw==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22966139"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:40:43 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:7621]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.151:2525] with esmtp (Farcaster)
 id 421bfa08-e878-4364-b145-fd3d813c5a4d; Thu, 2 Jul 2026 17:40:43 +0000 (UTC)
X-Farcaster-Flow-ID: 421bfa08-e878-4364-b145-fd3d813c5a4d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:40:43 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:40:40 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 02/14] sysfs: add existence-check helpers for lazy populate races
Date: Thu, 2 Jul 2026 19:40:21 +0200
Message-ID: <20260702174033.32116-3-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702174033.32116-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 65a6umz6gzsgf57njf8m94eqps5e3qyy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F909180003
X-HE-Tag: 1783014047-818822
X-HE-Meta: U2FsdGVkX18HSzndqUsAB+Sa33rvBdoo3sFdtTb1z+7R9PHN3gTeAjbjBoGoylAxtauX/cgLh2MMLNtvcacPmxQvpMVB8TPcGueBKQ5g4SqeISFU60lK+XImwG35a5xjZdUzUssPWcOYOl6G9nVzuQjZ2t0XxAgkwCBicOAB0jBM1enjA8ddtgStFv8cMnYBqaGGSf0cVSW4hGMO/AXZRyMY4oTy9c/yA2vFHXFfy/m4pw2EzFzJS8ffuhjeWvdHiw6rGxlf1OV0NAbL18Nf6A41JH13OhjQE8brFOgdtMPb+l0x3otiu49kRf3FD8z4sgQkDUWux8WsnPE4DIuzEaPTAdrMJ8XJRh93N/fgKj9pap/ZU1pcnIJAmQWDH2bozSMftq7c3G6EzYOpmbMyA8nCQceAHhJE6ajK8S5OsZcw89rSqSUrVFqKYJ/7j4dR0BgL8yydTpIO7nipmtgf7MkbHFlFuOdxfu1MfzmxRTrVaBhn2khdOSYtOzNjzfK6l41P5lsm//Dv7FlIFr91G1uvn+bDWOQri9Tv3R81qkmn1QE44VIUw6HI5wNc0gsGLytBLgWGraLI32UVhRKCqqpZm7MjQQw9CHTePNGnhhtUc5BMYl4FPGC90ym7W9a74+dc6f7PlWt56PqaBO2Ee3I64Q4E8KuLGM5oAexRp1ZZVz7A2uWcdr88VC/XbLs9rPza3xkiOkGy1SewRcUhZzSAgT/1biW6qSNwPj4cGUUhrw78PAYspr2vSaxxGebeCjroG91ST43v64Bxvp5DdBn/LcGCtgu1Rpo7ts0/T1Ay56PNLJb4Q5CoAYDPZ0uXpgq5IOE0JpqHBbU52QiDI4CFFENfGwsI4k8v/tNwnDPak3Ji39clio8gWtiYBjCJzSl7t98N1AX+cDXrTUFx9lKunlAeC71RWO7zqMOfFa50/HEtbv5VUwLb4NcSA6uAtbS4GtWFdespidRJioZ
 WrhtrPrD
 wmNkTh/lYdmFBnRS4m3Tzouihi8ZTtA42USxVRlPD3+1OUL/kD1If7oek4ZWKYvQvY8sk94fcjLPZYl+porIM40UHdu7SorENE6Es4vRjzw7fAIhTnv7LwUOrQV/eiDkEHQT24fG84tYTZoSLqye1vL9K86y3ekjrqDxxiu49iNhi90KUY8bzo5FEwVwShM8Lg5hWk4CYSpne3KGFCONToxIob276TiARKJJjYAury1/ETMp+nwEmgBBs1EEkU8MfG0cidx3g2wwynyTjq9mbd+PY8hwr7TGM2MYMPU9GvgrOZYqh8pmkZTC5xEvh4ikDu+FmgXtJ/LhkL+gKz6oKi33akjKZVjXHTAnzx7tYSP1GQgkIyKxlN2ycbPN8xBxa2tGS6pNN4jTctIAJVAT1OekbkDI8jfWxNMQRCmG+gU/EEAHFXqpJnbRWw9jC/XMD4AzOZ3HHdeVCdrv9L5Z6Jj7CXitv3ooXtwsgQYxZGza98k1PEMj43ekgx8h9p5U2kuOJ1dsGTCUbEIGHJ+DIJyIj9MRTErJnEO6k5/3GTckh/EJq+kqnc3uqx8TJks0ED4DBgSixzhn/7xU/wiU2uT6DxvtP/ZOl6mgP4Aiym2+sZZSFOZK6Pgl1bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lazy populate paths (introduced in subsequent commits) acquire a
per-device lock and may walk a table of create callbacks.
A populate_one("X") and populate_all() racing on the same device
serialize through that lock, but each create callback must verify
the entry doesn't already exist before calling sysfs_create_*().
Otherwise the second caller hits __kernfs_create_* which fires
sysfs_warn_dup() before the create callback can absorb -EEXIST.

Add two read-only helpers that wrap kernfs_find_and_get() so
create callbacks can perform the existence check under the same
lock that excludes other lazy create paths. Pairing exists() with
create() under lock makes the check-and-act atomic with respect
to all lazy populate paths on the device, and eager paths are
temporally separated (eager creates run during device_add, before
lazy is enabled).

  - sysfs_kn_exists(kobj, name): true iff @kobj has a child kernfs
    node named @name (any type).

  - sysfs_group_exists(kobj, grp):
    * grp->name != NULL: true iff a KERNFS_DIR child named
      grp->name exists under @kobj->sd (per-attribute presence is
      not inspected; mirrors how internal_create_group()
      short-circuits on -EEXIST).
    * grp->name == NULL: true iff every visible attribute in
      grp->attrs and grp->bin_attrs is present; a partially
      populated unnamed group returns false so a follow-up create
      pass can fill the missing entries.

Both take kernfs_rwsem(read) briefly via kernfs_find_and_get and
return false on bad input or non-existent name; sysfs_group_exists
additionally returns false on a node-type mismatch.

This commit only adds the helpers; subsequent commits convert
create callbacks to use them.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 fs/sysfs/dir.c        | 25 ++++++++++++++++
 fs/sysfs/file.c       |  2 ++
 fs/sysfs/group.c      | 70 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 15 ++++++++++
 4 files changed, 112 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ffdcd4153c584..ae97ab7e41939 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -159,3 +159,28 @@ void sysfs_remove_mount_point(struct kobject *parent_kobj, const char *name)
 	kernfs_remove_by_name_ns(parent, name, NULL);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_mount_point);
+
+
+/**
+ * sysfs_kn_exists - check whether any sysfs entry with @name exists
+ * @kobj: kobject under which to look
+ * @name: name to look up
+ *
+ * Existence probe under per-device sysfs_lazy_state.lock; lets a
+ * caller skip a redundant sysfs_create_*() and the resulting
+ * sysfs_warn_dup() WARN.
+ *
+ * Return: true if a kernfs node of any type with @name exists.
+ */
+bool sysfs_kn_exists(struct kobject *kobj, const char *name)
+{
+	struct kernfs_node *kn;
+
+	if (!kobj || !kobj->sd || !name)
+		return false;
+	kn = kernfs_find_and_get(kobj->sd, name);
+	if (!kn)
+		return false;
+	kernfs_put(kn);
+	return true;
+}
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5709cede1d756..5f3144e52ab72 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -816,3 +816,5 @@ ssize_t sysfs_bin_attr_simple_read(struct file *file, struct kobject *kobj,
 	return count;
 }
 EXPORT_SYMBOL_GPL(sysfs_bin_attr_simple_read);
+
+
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 182e54e575ee9..d6b2034cc22c9 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -636,3 +636,73 @@ int sysfs_groups_change_owner(struct kobject *kobj,
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_groups_change_owner);
+
+
+/**
+ * sysfs_group_exists - check whether an attribute_group is materialised
+ * @kobj: kobject under which to look
+ * @grp: attribute_group descriptor (may NOT be NULL)
+ *
+ * Read-only existence probe used by lazy populate paths.
+ *
+ * Two shapes:
+ *  - @grp->name != NULL: the group owns its own subdirectory.
+ *    Returns true iff a child kernfs_node of type KERNFS_DIR named
+ *    @grp->name exists under @kobj->sd. Per-attribute presence inside
+ *    the subdirectory is NOT inspected - once the subdir exists the
+ *    create path treats the named group as already materialised
+ *    (consistent with how internal_create_group() short-circuits its
+ *    create on -EEXIST).
+ *  - @grp->name == NULL: the group's attributes live directly under
+ *    @kobj->sd. Returns true iff every visible attribute in
+ *    @grp->attrs and @grp->bin_attrs is already present. A partially-
+ *    populated unnamed group returns false so a follow-up create
+ *    pass can fill the missing entries.
+ *
+ * Locking expectations: see sysfs_kn_exists().
+ *
+ * Return: true if the group is fully present per the rules above,
+ * false otherwise (including @grp == NULL).
+ */
+bool sysfs_group_exists(struct kobject *kobj, const struct attribute_group *grp)
+{
+	struct attribute *const *a;
+	const struct bin_attribute *const *ba;
+	struct kernfs_node *kn;
+	bool exists;
+	int i;
+
+	if (!kobj || !kobj->sd || !grp)
+		return false;
+
+	if (grp->name) {
+		kn = kernfs_find_and_get(kobj->sd, grp->name);
+		if (!kn)
+			return false;
+		exists = kernfs_type(kn) == KERNFS_DIR;
+		kernfs_put(kn);
+		return exists;
+	}
+
+	if (grp->attrs) {
+		for (i = 0, a = grp->attrs; *a; i++, a++) {
+			if (grp->is_visible && !grp->is_visible(kobj, *a, i))
+				continue;
+			kn = kernfs_find_and_get(kobj->sd, (*a)->name);
+			if (!kn)
+				return false;
+			kernfs_put(kn);
+		}
+	}
+	if (grp->bin_attrs) {
+		for (i = 0, ba = grp->bin_attrs; *ba; i++, ba++) {
+			if (grp->is_bin_visible && !grp->is_bin_visible(kobj, *ba, i))
+				continue;
+			kn = kernfs_find_and_get(kobj->sd, (*ba)->attr.name);
+			if (!kn)
+				return false;
+			kernfs_put(kn);
+		}
+	}
+	return true;
+}
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index b1a3a1e6ad09c..de211563f3dec 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -428,6 +428,8 @@ int __must_check sysfs_create_bin_file(struct kobject *kobj,
 void sysfs_remove_bin_file(struct kobject *kobj,
 			   const struct bin_attribute *attr);
 
+bool sysfs_kn_exists(struct kobject *kobj, const char *name);
+
 int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
 				   const char *name);
 int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
@@ -454,6 +456,8 @@ void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp);
 void sysfs_remove_groups(struct kobject *kobj,
 			 const struct attribute_group *const *groups);
+bool sysfs_group_exists(struct kobject *kobj,
+			const struct attribute_group *grp);
 int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
@@ -593,6 +597,11 @@ static inline void sysfs_remove_bin_file(struct kobject *kobj,
 {
 }
 
+static inline bool sysfs_kn_exists(struct kobject *kobj, const char *name)
+{
+	return false;
+}
+
 static inline int sysfs_create_link(struct kobject *kobj,
 				    struct kobject *target, const char *name)
 {
@@ -656,6 +665,12 @@ static inline void sysfs_remove_groups(struct kobject *kobj,
 {
 }
 
+static inline bool sysfs_group_exists(struct kobject *kobj,
+				      const struct attribute_group *grp)
+{
+	return false;
+}
+
 static inline int sysfs_add_file_to_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


