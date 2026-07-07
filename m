Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C44C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6DD6B00B7; Tue,  7 Jul 2026 04:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467096B00B9; Tue,  7 Jul 2026 04:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355EE6B00BA; Tue,  7 Jul 2026 04:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083B36B00B7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91BC81A0395
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:53 +0000 (UTC)
X-FDA: 84961302426.12.1118CF6
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf31.hostedemail.com (Postfix) with ESMTP id C5BBB20004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMajsTlQ;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412872;
	b=A35g+YInUh/TQP3D2mR2mygN1bNT7QwlpwInN3s4Op3KHJCeu02r6ei85MgXdRdFwcvmO1
	cA2Q5Q5/ZFA3tYN5UiSAAPq2LDhMuK56FcbNm5lWRU11g1dK+8DxdvxMIQ3HuTTG8+hsmH
	jCAZXwiuutEIuwJ4xaBrtAEdmQKtJ9w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMajsTlQ;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ru8WYn++oZvGMNoRs83TkPNucu4BwEx3PldacFtQlM=;
	b=dtvsNOG7qlFoY1HecmfYmyQHBT0QAXAa3RRjPz94hPcWINR1qIUPugXboOzZ3iZ6bsEA0N
	NLDGcM+q/ODwn4LLNFtuPiUNDJXOMnc1IusSU2MNTG4YMe3Wu3sL7aOcJf7TabSFDfgH+w
	5i2/tT0W7XqPWItQc9qtwzM1h4S7Wzw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Ru8WYn++oZvGMNoRs83TkPNucu4BwEx3PldacFtQlM=;
	b=sMajsTlQ6ayjpEYZPr+c5Aj8FZXE7p4tuArgzE3ffPxvDivEqnRksJ+z9zZJrtQ+NBr/7l
	ETGTcNULDqxG7qKa3pl0K9iyMDqoarCSJnGxtKkNQdcO/wpXaBBJRnaZaOmPxDAYLHI8ym
	7QZhmJvYdnmFlRhN5vxwZVN24ZWoF14=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 10/10] mm/swapfile: add sysfs interface for ghost swap extension
Date: Tue,  7 Jul 2026 16:26:12 +0800
Message-ID: <20260707082614.95030-11-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5BBB20004
X-Stat-Signature: amr1anfjtakqfz7ox7i754kr19ohn34m
X-HE-Tag: 1783412871-100350
X-HE-Meta: U2FsdGVkX1/sXoE2R+s8ek7INvazUqx1gwpHHJguLot2+Nyd04kfbVurc+SFcBhDWUiDL5yZKwzw3x5AktdfeBKNjtldQjmh4z4ArncxfnTt/z2aWz13zHHavy1zVmV7rGlhKRG7tKwDQzLSdnG0u4ybo0lD22H1YiZBI1RBKQwng7T8ZAP+aOLVGU0MP6WMrApn2gUZ30zL6wz5TUZauF5883u3Omrtoz98guoYlJSAB22iPYKuk8h1YNm594ezd7PH42PhzmoIEvmtn/Msa8f8ykM26B6wQMqiVB/ZO3CeFB+2CnSwmg97WexwbtIIvdoi3aXfxTUjlkm2MQT/G5CjoTvTTGDJFeHxh2O1pN4gjyrG+l8R5Jwx7SL5qgsDXG2Ovw4EX+at6k5s2kap7Xvycta0gm5qkyGihv3iJAo5CjF1F3nJ0rlig9yFvSSHKGUrX6+qPod0RC4r8NEINL1DBVdktBJ36k7XM0Z8wCG+507MPl1MX5Jl/rF2u7zhNWMtqPJJApIKFvMwZ4yYfSyK503ao4ZBtDRZUCee6JFqRhhkCoQBQzZzKizVmVF6xRAu4Fy84Vv7nCs2XR/IhQaVJRVAsOPT4zFIKjUFTQW5DBBZ7zfYfTNMBtcrFASgXq8J3k0JSJdrjonZsW1uWk+NZbUJxuBGlbf6iCwrXBAlj5LbPtgeA0+YBS2whTd/r1GdtFxiWE2LycKZfcO5AF4k49p9EmxHwcu+isJJI1rIEtOCPSuKXEaPcR6n69hPAnza0I7ypPB8z/riZSxPRcCccf1viPf54LtA9l92KClD6d0aO9XV9Zk4df609135LW4ziz+Q8u2R9ZlfSNzQHcNkjXybyztOiBqaKw6ZtZmKW9l6+sA1v0C/RhyMa1jaj1zphN2Kz4DY6f0tQT+2ZnAv+zM8EBwqRFtUekUjw7cHC2doKxQaxLCnAMsgmOzOozauCNZsxqyJLorRsL2
 0SGW0bwz
 FUy9mEaKpmSIweHBK0YF2i/aamYtoPFO7fsCtMyd8Y2SDCdP+/ViVYSRTRoSBuYztIn+ZyP7v88/62SXW3Vx5gimdJWRevVyyn5D15JwB1eT4q6CBsTrzSIuUwwIZCrUffCFuWN3O2yhFoJ7wHoCSN2J+zupMDq5yqN+eHlFGHKv5waDHXTahRhJjcvxUhbnVYy5GrRY6uaqMilJElmmtR7hkdLyYMqx0hagdpv7iA7bhaBIMHDwlbJmADfmpXXTSof5NosGDtWMxofZ4ygWuTxQrFApEHs8snhtIHHFzYCVqJBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add per-device attributes under /sys/kernel/mm/ghost_swap/ghost_<N>/:
  path (RO) — dentry basename
  max  (RW) — current max pages; write to trigger swap_ghost_extend_max()

The ghost_kobj field ties each ghost device to its sysfs directory,
created at swapon and removed at swapoff.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 111 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b87688b7d4ba..d9ae2a9e33cc 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -283,6 +283,7 @@ struct swap_info_struct {
 	struct xarray redirect_xa;	/* ghost offset → phys swp_entry_t */
 	struct vm_struct *cluster_vm;	/* ghost: sparse vm_area for cluster_info */
 	char *ghost_name;		/* ghost: dentry name for sysfs */
+	struct kobject *ghost_kobj;	/* ghost: sysfs per-device directory */
 #endif
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8bf336678887..ede10539156a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -31,6 +31,8 @@
 #include <linux/security.h>
 #include <linux/backing-dev.h>
 #include <linux/mutex.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
 #include <linux/capability.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
@@ -60,6 +62,8 @@ static void move_cluster(struct swap_info_struct *si,
 #define GHOST_MAX_CLUSTER_BYTES (64UL * 1024 * 1024)
 static int swap_ghost_extend_max(struct swap_info_struct *si,
 				 unsigned int new_maxpages);
+static int ghost_sysfs_register(struct swap_info_struct *si);
+static void ghost_sysfs_unregister(struct swap_info_struct *si);
 #endif
 
 /*
@@ -3250,6 +3254,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	maxpages = p->max;
 	if (p->flags & SWP_GHOST) {
+		ghost_sysfs_unregister(p);
 		p->max = 0;
 		cluster_info = NULL;
 	} else {
@@ -4010,6 +4015,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
+	if (si->flags & SWP_GHOST) {
+		error = ghost_sysfs_register(si);
+		if (error)
+			pr_warn("swapon: ghost sysfs register failed: %d\n",
+				error);
+	}
+
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -4357,6 +4369,105 @@ static int swap_ghost_extend_max(struct swap_info_struct *si,
 	spin_unlock(&swap_lock);
 	return 0;
 }
+
+/* ─── Ghost swap sysfs interface ─── */
+
+static struct kobject *ghost_swap_kobj;
+
+static struct swap_info_struct *ghost_kobj_to_si(struct kobject *kobj)
+{
+	int type;
+
+	for (type = 0; type < MAX_SWAPFILES; type++) {
+		struct swap_info_struct *si = READ_ONCE(swap_info[type]);
+
+		if (si && si->ghost_kobj == kobj && (si->flags & SWP_USED))
+			return si;
+	}
+	return NULL;
+}
+
+#define GHOST_ATTR_RO(_n) \
+	static ssize_t _n##_show(struct kobject *k, struct kobj_attribute *a, char *b)
+#define GHOST_ATTR_WO(_n) \
+	static ssize_t _n##_store(struct kobject *k, struct kobj_attribute *a, \
+				  const char *b, size_t n)
+
+GHOST_ATTR_RO(path)
+{
+	struct swap_info_struct *si = ghost_kobj_to_si(k);
+
+	if (!si || !si->ghost_name)
+		return -ENODEV;
+	return sysfs_emit(b, "%s\n", si->ghost_name);
+}
+
+GHOST_ATTR_RO(max)
+{
+	struct swap_info_struct *si = ghost_kobj_to_si(k);
+
+	if (!si)
+		return -ENODEV;
+	return sysfs_emit(b, "%u\n", si->max);
+}
+
+GHOST_ATTR_WO(max)
+{
+	struct swap_info_struct *si = ghost_kobj_to_si(k);
+	unsigned long val;
+	int ret;
+
+	if (!si)
+		return -ENODEV;
+	ret = kstrtoul(b, 10, &val);
+	if (ret)
+		return ret;
+	if (mutex_lock_interruptible(&swapon_mutex))
+		return -ERESTARTSYS;
+	ret = swap_ghost_extend_max(si, (unsigned int)val);
+	mutex_unlock(&swapon_mutex);
+	return ret ? ret : n;
+}
+
+static struct kobj_attribute ghost_attr_path = __ATTR_RO(path);
+static struct kobj_attribute ghost_attr_max  = __ATTR_RW(max);
+static struct attribute *ghost_attrs[] = {
+	&ghost_attr_path.attr,
+	&ghost_attr_max.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(ghost);
+
+static int ghost_sysfs_register(struct swap_info_struct *si)
+{
+	char name[32];
+	int ret;
+
+	if (!ghost_swap_kobj) {
+		ghost_swap_kobj = kobject_create_and_add("ghost_swap", mm_kobj);
+		if (!ghost_swap_kobj)
+			return -ENOMEM;
+	}
+	snprintf(name, sizeof(name), "ghost_%d", si->type);
+	si->ghost_kobj = kobject_create_and_add(name, ghost_swap_kobj);
+	if (!si->ghost_kobj)
+		return -ENOMEM;
+	ret = sysfs_create_groups(si->ghost_kobj, ghost_groups);
+	if (ret) {
+		kobject_put(si->ghost_kobj);
+		si->ghost_kobj = NULL;
+	}
+	return ret;
+}
+
+static void ghost_sysfs_unregister(struct swap_info_struct *si)
+{
+	if (!si->ghost_kobj)
+		return;
+	sysfs_remove_groups(si->ghost_kobj, ghost_groups);
+	kobject_put(si->ghost_kobj);
+	si->ghost_kobj = NULL;
+}
 #endif /* CONFIG_ZSWAP */
 
 static int __init swapfile_init(void)
-- 
2.54.0


