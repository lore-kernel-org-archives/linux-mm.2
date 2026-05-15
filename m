Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92A6CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE136B00A9; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E786B00AA; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AEA6B00AB; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3686B00A9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C11BD1402BC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:59 +0000 (UTC)
X-FDA: 84767809518.03.4741E39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 312FE180002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDPdurHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805898; a=rsa-sha256;
	cv=none;
	b=hvbdmzFhwIp+/9micqf1c29r0kJ66sODQeqb/OyGauYtPAAYjoVCu9lrNdPyyWCHSv6/IE
	/HFNvQ4ErmvPOqSFhHGz1zCS19upvol69kt07yXmfIY8NZTX+6Nq++I6i5mKE/UlgIrS5C
	ONdLsjlXkNHg9s0iHCAfEKAB2njK19w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDPdurHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5eAj9wwVoDS12iy6pBA6daUI8NQ5yEaZG+G53Po5HA=;
	b=pmAPod/GRMmUNQFnHq/copIaT4a1bCxK5xM69jNfTshzqj2sH4mnJ4qKw4glJw3Gfgv1SE
	IOYcpXjo/5bWAZYUpR8eYXDaeweXoJMPtRPqUR3nZYzcUfnd/Zf2vMHZFiq5G/Fvsbsz9B
	N84fvSVW3wnE58NWo1/oNMHvDvoBxUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFE9661330;
	Fri, 15 May 2026 00:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D18C2BCB3;
	Fri, 15 May 2026 00:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805897;
	bh=QS528f5qGHKkLem/jUjppq70/JVfZ3peF0nYrxU0kzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDPdurHSjutJ362yDbz+dXhc8XJvA4E1AtHqu09JI4XdGIRN9ZWztD2nZ4Do5zCfD
	 Aoz0SHMxTikFe2G6L6jLLT0t3UgbPSAgeJMBglHAew+CbVPpgeUEc7D6GLDUOH4JaG
	 +e0kmFtH9kfc/WSG1dBmX3m26ZRLYntLGzDanoKmMwZ/PhbVQ59FM7qKwvIh1ieuTG
	 2k7zsypQeT5P2u9mbjzTX0vMx7k8rP965f2CiedpCFgWkv534jkGwKy0gNUBh0/Vmb
	 fA7YY9ahYAwOEkIpHkrAMzPLyoVDNHDGqHQ0mW/qfQIHjoc5Kb5ySnP3Ko2omUMmNq
	 44D8y9cMjqezQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 24/28] mm/damon/sysfs: add filters/<F>/path file
Date: Thu, 14 May 2026 17:44:25 -0700
Message-ID: <20260515004433.128933-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hxz19w9rqg3u51khkuosn1ohn9c7k3od
X-Rspam-User: 
X-Rspamd-Queue-Id: 312FE180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778805898-821436
X-HE-Meta: U2FsdGVkX1/Xzj1z6vRXKBL7F0mz9bJsqJ64vQbXOOTElB9u4ZAUngTupw2DKEzWUwKtBZJ9inTd+e4BviXj28YcFTU47T1uVy7xQnWDRPnx4wilmue/y8ss+D15E5oiMbNaRa1viT67NgWn7epU4tTaqkrH6LYy0RZp8oD4X+gymHQpq7No6kil5T7QvZMSecRPH7AkDFmj2hZNhn8nLRrRuT9QyAsXpWoYj9cNWAmrA4PwPXGVFhpJQUGHZNuJJdebgA6Ib8sHnzOgHYCuSIQEUsRBO5m3bCZlFYi/EQ96jVVUNhOvRBVWGo5b8HVUjlN98q+z0y04RSufTTO27+eUs8ErojlLdiYaLmMdQNuVn4UfX8su9QB6G8Hgf8wDcTMKjNdpbT11H3KPwBQw0Lze1kBx+C+1fszdcBrWMrMt4WQsUKiPQKvY3r9km24k3W8cnbuCyv5ZtrWaK8L9gSiV9FHZQlhdQIRJR5yUuuGuLRMoGsObhUdUMwZ+w18mmSWulwB7zY6JOAh4h9eLGi/Kc0bk4spvjvIXV/R33OgCfhU0ScASQvaWgCtP9VJG3FyTuZcSEDTIRbQNgiVBH0jMZeSIwhks7Ndf3bhddjC4BhUhOBIgAXAL7F1OwBGpsHVeZ9IqJu6+UhkHP18K/+fAaPvsBU1779QZZ8k0P/I6nAFIxuP96SoTB4NmFBcA+outs6ZR6PiaXKMC+kEbPtHtLPioW6B+PW732s9Yx3cpeb1/yYoxj6ndVSyiVPb7N4Ye4eGtkH82LVHOAlj4eu9fVmLcYAGfy9Wg0N6zE8BkD0eBy1c1SSmyE392xb6gyE7G8qLIm491cVyFVnF8UOH6YFkijm+oyudigXHc/+vTzELEUn1X9pV0eHcnuGc6r3pL7u70Z0PNgp9oT5o+ezLdTlj1mL+OMrFCYk5Hfm2SGU+o4ovmRmyaBwjmpVu65wKDIJk6/4c2owJibq2
 8NLvo6Ru
 QOBmfg3fxcTcKijR83SsGcmKiroYT+mjHnwYqNEawU0DE76OUlp7osaWVPIxxqyxciODocRIALt6q6kfk6C9EaEeO3L/Yfb0lFjvcEfhSl7I4Jtfx1FSfti2tz1ylKuOujJ4LHQsDHVs1gT7QVmmj+5ss8TCLQW0/fyELl1RnhBzLI192rJomXsjQVirkIJR4yfi8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON sysfs file for letting users setup the target
memory cgroup of the belonging memory cgroup attribute monitoring.  The
file is named 'filter', located under the probe filter directory.  Users
can set the target memory cgroup by writing the path to the memory
cgroup from the cgroup mount point to the file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index c2c172aeae149..21f89f2976ca5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -756,6 +756,7 @@ struct damon_sysfs_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	char *path;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -774,6 +775,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ANON,
 		.name = "anon",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -862,11 +867,46 @@ static ssize_t allow_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int len;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", filter->path ? filter->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	char *path = kmalloc_objs(*path, size_add(count, 1));
+
+	if (!path)
+		return -ENOMEM;
+	strscpy(path, buf, size_add(count, 1));
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
+	kfree(filter->path);
+	filter->path = path;
+	mutex_unlock(&damon_sysfs_lock);
+	return count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
 			struct damon_sysfs_filter, kobj);
 
+	kfree(filter->path);
 	kfree(filter);
 }
 
@@ -879,10 +919,14 @@ static struct kobj_attribute damon_sysfs_filter_matching_attr =
 static struct kobj_attribute damon_sysfs_filter_allow_attr =
 		__ATTR_RW_MODE(allow, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
+	&damon_sysfs_filter_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

