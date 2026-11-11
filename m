Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CD260A2622
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=cBhDNGAH
Received: by kanga.kvack.org (Postfix)
	id 32D8D6B05BC; Wed, 11 Nov 2026 02:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305356B05BE; Wed, 11 Nov 2026 02:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE886B05BF; Wed, 11 Nov 2026 02:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4B4F6B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76A7BA0228
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:37 +0000 (UTC)
X-FDA: 85422073674.28.BE88C26
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9A9AB20004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=cBhDNGAH;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8ppAZ4kI36SkHC2JSY1XPhx8Cnr7U+W7X/gURi12I4=;
	b=moWYmBmbpSH1CbCM1W/z3gzx5VU78i9CwVBzw2nsjQwD67eSsonj9LGGiik6CHFfoIE//Q
	tHRFa/qo5CLL4VkSQSA3kx3XV0Wl1e04l/XDV3eQB0sGHNpdt8BsJRsdV9f0oDiF2uMCxd
	+s582VF6y6n4apJBnp1nEf70i2IeRaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383615;
	b=50UscCU1u6ffLs4wSS6uSusgwLaD57gNaDnhel7LdCACgEVuCBrKPe2jh/5WNjWADNy+fk
	CxTaA0jiaMmVF5j7AsaxboUkGlPSaIrU5FwR27egKmBNVDOal/1VF9toSaEuFeufAWl0w1
	bCFNSsKQsGRAqQXYg4Npj32SZJl2zF8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=cBhDNGAH;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ea7190aea1so12349055ad.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383614; x=1794988414; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+8ppAZ4kI36SkHC2JSY1XPhx8Cnr7U+W7X/gURi12I4=;
        b=cBhDNGAHe0Z9STF3daKwxIr+zbNzi5K2M1QEHdvM/G8h1JOVXB3xpDHEiCbRrEWnqQ
         DYkzoWWTLu7OSjTacy2g+7+OkXADkNwm8olUwlEJ7fIwa6Js/zfs8xUZ6VhQY6/Qbrd4
         Vgm40hKJ9P3msPB1goiZRnuq8ggISox89M1do=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383614; x=1794988414;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+8ppAZ4kI36SkHC2JSY1XPhx8Cnr7U+W7X/gURi12I4=;
        b=XMw8vd8VGieRmztjco0rEZUXXrjTWd5Pn7Mg9x6l4LNrDadMxRxY0Ro13lSohiJm2I
         px+duyyGHc/5iXUHxC22QTEMEJxVzqh0Ye3NBGmuiQcfn66IdWRtGaPlnNcPVXijjrHG
         Hf2yYRu7d7+XFe8zJerJotA3lHOI01IqvBrWJgPdDcuyLApMef29Zl1jMX5gg1R2ybF+
         PWsz8UOoQEcU6aMVCKECNhuSIYXA9cOcQxs9bw6qU1INSykDyA8NCE+jVRAJP0k4LbdG
         vqJHkt0GhLFHSDsxFW0xm/nBYvL4dayMLaHtXufOv3fEToHQTVWG055nLE837zL8DMFe
         PaZA==
X-Forwarded-Encrypted: i=1; AL+hErEq1YRvLjklxroms0aQIprXXx48jQb6agPw6Ua+QzEZfIoJiAe3nHHNn2Ayf8i1zhl2IquExp6/2A==@kvack.org
X-Gm-Message-State: APuU4Z+bTs+RucShDojYy+XzmlW1ghwpK/Yqd3vuqG1ZbOrcrSVH5c4H
	x1TqicXHfLUwcT68uNk1cdtuiB32qttBWhDX6O3YDfx/3ZG74wvOtPztMKN2KavcUtE=
X-Gm-Gg: AYBFou1xxpi2OW4f4S9W2gv012kHbV6ilfTgsBEiBM/dvJzKtnmOTCUPXxYJcWoB12a
	gk0e7MLD/ZrLexdtIoeFt1brRJNDC10hF3hZCYJQrxYqW38+rEW5vzu3mm3Xy3aHKec7ho47pWI
	Ylv/k8MtqvzVkIf6tUwODMfKL5/6ebEw3DLZEz8OgqxYsNJ839KFGiCs5a/dOk4crhDwJFSynh1
	PH/bcI1axl3Wc/dk34ZO4erk7ZbdP/xj/lACE0pHWLyom+87pQGJLOLcoXU8ewIPou698JTAFt5
	Xp0JpC/7dn1VLtiBDkcq/hYXwt5v6GnTNkLpQlxryTet4h8eNK2/lFu8dfGrYK/90bTiLK+fZQV
	wMRah+li33YyCiK1yJgBmRd3VP43t+SjsVx5AEHT6lfMZ7Dfz7YbKYEzOFa+hw7UqFnepjS8AGj
	dnw98e0JB3wKF1QzEsPTtjyPkEsf+BvO6UbzTGvaGXpdQ0a4H8AL0BoJSHNpftO3lr7NJjoXm85
	vcaJIuiAN9X/247hIhuH3q2G3Dsg1zopOskn+g8N+eqYrNHeg4g9zGjz/xzY0qji2TZtpXX2zEV
	MSlT7UBJtJGxW2jdF1NSWw6xLA+wgW9TYQyZSGZUneYWr9UOfnpipaBSV6L96vHfstxIyAlhPhY
	qKN1SmWa+/QkqaPOfq7ZJSa4jTAJUSVLHFLMAReRsc5eWtoVSpX1ekPfvP+DRahS4fAfrVO8Wsa
	RoSJ0UwFzTeRhSPoXzH8iuoLvfGQuJBeZheVY6amIfEkUaZOn6WOQN
X-Received: by 2002:a17:902:da87:b0:2ed:294c:2b9c with SMTP id d9443c01a7336-2edd7ac1ea6mr21231125ad.51.1794383614325;
        Tue, 10 Nov 2026 23:53:34 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6a3f730sm18051095ad.5.2026.11.10.23.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:33 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:30 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/9] kho: Expose rejected handovers that look like cold boots
Message-ID: <abfe907e8da92802cd5e0c843d8013e4d229aab3.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam06
X-Stat-Signature: t7tr77ztgnugfsk6m6ofxey8i3tziwit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9A9AB20004
X-Rspam-User: 
X-HE-Tag: 1794383615-939936
X-HE-Meta: U2FsdGVkX18XeWdUYdn2Llb7PAjKyjTRVYAa7pmfwqENXEE3LH71J3Qdx+m/np+l4AxttuUVNbepZM88hS3o/K+uVNwTU7siE+mLtJ6JBWkazz4UGcoHZn4dUDmL3Xi/lYgg6/16/S3EO5tpTrFH7QqPbzXR+c1gMu+Kqus7l0XXWAqqJNPxMXV1P8o8HmZ45G0DI2HC9rdTcHMaXvr7f5xwZsSvKKrHZIQYNlQKsk2y3svApbGF+QdpHGj9Tv2MRBcQuGifqGvtoDTPS6In45DBwfNp0e1EnVKH1C4c4Iw3AU19sco6KjwieRyvG/7OKzSTyADyiW48pA8F6GuqQfqxIXTe+9WPLc/r1QpPgOMGI5SUDkfKmCb/mtIyTf74M0d8LR/QwsDPxGH1++SW03CSLhcWlyY990o9Hz79JZI3uaKFLQFJp8y3CcfKJlMhqWafQAfWqsWbiADEiukqIDkDUGy/YJ+prxuNVMUAPiA4ipf35tvflbjgEHFrFpnx42DlAiXjIWStSMrg9IZYtQLSviuJLobt5N4E8tRME0xVNYmU8jVM7O7NiJIAiKpyybUM8M9wZgQhSzbwGYAjx85scww9IhrG33xIgvWLgK/RD7dnQZTD+DvY1Mf3+6kca5u2I2cTcsTeU4CTKXO+iy+je3gaYaHPLOHvCV8YU3EnqRV/r8+fAHyEHYbGo559fDiUbHahWe0OjZJY3Ci4vH99s8J7o5YoS9UJ4TwApP9F8v6Ag8hy0BDKaagC4TmZ4sibpVSIYdkFHZKhJHnTyU/1zHz0pzGHdDrrjzXfU5tFGwCA4cWJE40URzXDIQXY9Bm+cYUoinySTWDtVlhj2vaPRuIrQqxLpZgm3PfiIDYwE/Fkri5jIwdMmBqA18wknU9TqnQD/IyT/qADtrIO4xILifs4jpWZT2h7J3M6xWv4PciwkpcdJxYTHz/Mst4OeQPePhP0utQ7EuHWPEr
 xYm7PNmy
 xzZyuGwN0ruu+pT/BlK1L3hMNBNx/Wixb0D3iqbKeeOkug+U/C6HW65dVNf7Ceo7cMBbr/z/KDSI5pt/v5KggIU8vvAOTKSvYTJ2sLdc0TeGlD8m3GFVWD1V27ScbXHjt7Up5AwAWSyFYf/ywdipzDYI8N+gcze93OrJxx9KR5IBt+Z1R+pHdat8Y0gQC4jc3ps8uZtYAWziouc+X6emyzTUlfk3ooAoj9Tyf/CXbvvZsaVcrHJB6bWbm7STYzAVs+YxPXaxWlJ4pOaeCqtlrE0wL3L7earp3P5mbU+VSB39QBw4FolR8QZHlquR2C5dKVpqRqNXmEyadKImUVQA5b+B9N9C/8BivA677057tkiQ6DBzpa3Yf4IZ+3FxBOrLNRC13DA2wsRnyNV4mgjSBMkgCEAGZskgyxR/cPk8VxwK+FTNDDXLG1aX8YvAhWvrOzN5Gk7xUuvep1glNlm3Lg7HN5eF4Rh8ih4rYiFMg4qJThYIr/LVon2uIqUDGVvYnHKEn5VA6slejfijRbtLpXfjiUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At Meta, our rollout needs to stop if the new kernel rejects the KHO
handover. For example, if it doesn't recognise the handover FDT's
compatible string, it can boot normally with all the preserved state
lost. LUO's incoming/state reads "none", as on a cold boot. We log
"disabling KHO revival", but our fleet collector reads procfs and sysfs
and can't rely on kernel logs from every host.

Let's add /sys/kernel/kexec/kho_incoming/state so the collector can tell
a rejected handover from an ordinary boot. "revived" means the kernel
accepted the handover and completed the preserved memory map walk. LUO
reports the outcome of restoring sessions separately.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../ABI/testing/sysfs-class-misc-liveupdate   |  3 ++
 .../ABI/testing/sysfs-kernel-kexec-kdump      | 12 +++++++
 Documentation/admin-guide/mm/kho.rst          |  3 ++
 include/linux/kexec_handover.h                |  2 ++
 kernel/kexec_core.c                           | 13 ++++++-
 kernel/liveupdate/kexec_handover.c            | 34 +++++++++++++++++++
 6 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-misc-liveupdate b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
index 25e3b49d7aeb..608f788ef0fa 100644
--- a/Documentation/ABI/testing/sysfs-class-misc-liveupdate
+++ b/Documentation/ABI/testing/sysfs-class-misc-liveupdate
@@ -19,6 +19,9 @@ Description:	read only
 		"deserialized"  The sessions can be retrieved.
 		"failed"        Deserialization failed. Opening
 		                /dev/liveupdate returns -EIO.
+
+		See /sys/kernel/kexec/kho_incoming/state for the status of
+		the underlying KHO handover.
 Users:		system monitoring
 
 What:		/sys/class/misc/liveupdate/incoming/sessions
diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
index 80941a7d8a7c..5636cd060cb2 100644
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -67,3 +67,15 @@ Description:	read only
 		Total size of the KHO bootmem regions in bytes. Returns 0
 		when KHO is disabled.
 User:		system monitoring
+
+What:		/sys/kernel/kexec/kho_incoming/state
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Status of the incoming KHO handover:
+
+		"none"     No handover was passed to this kernel.
+		"revived"  The kernel accepted the handover and completed
+		           the walk of its preserved memory map.
+		"failed"   The kernel rejected the handover.
+User:		system monitoring
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index c329d720bf25..9d74d4ce18b5 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -88,6 +88,9 @@ sysfs Interfaces
     Total size of the KHO bootmem regions in bytes, or 0 when KHO is
     disabled.
 
+``/sys/kernel/kexec/kho_incoming/state``
+    Status of the incoming KHO handover.
+
 See Documentation/ABI/testing/sysfs-kernel-kexec-kdump for the sysfs ABI.
 
 debugfs Interfaces
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 736d51e79fd2..1f37d2300e26 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -42,6 +42,8 @@ void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t bootmem_phys,
 bool kho_bootmem_overlap(phys_addr_t phys, size_t size);
 phys_addr_t kho_bootmem_size(void);
 
+extern const struct attribute_group kho_incoming_attr_group;
+
 static inline enum migratetype kho_bootmem_migratetype(unsigned long pfn,
 						       enum migratetype mt)
 {
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index ed105e6351eb..c1085a53b7f4 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1372,7 +1372,18 @@ static struct kexec_link_entry kexec_links[] = {
 };
 
 static struct kobject *kexec_kobj;
-ATTRIBUTE_GROUPS(kexec);
+
+static const struct attribute_group kexec_group = {
+	.attrs = kexec_attrs,
+};
+
+static const struct attribute_group *kexec_groups[] = {
+	&kexec_group,
+#ifdef CONFIG_KEXEC_HANDOVER
+	&kho_incoming_attr_group,
+#endif
+	NULL
+};
 
 static int __init init_kexec_sysctl(void)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 21d77e29d2bb..dfd6fa7e4a71 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -19,6 +19,7 @@
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
+#include <linux/kobject.h>
 #include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/kho/abi/kexec_metadata.h>
@@ -97,11 +98,18 @@ static struct kho_out kho_out = {
 	},
 };
 
+enum kho_incoming_state {
+	KHO_INCOMING_NONE,
+	KHO_INCOMING_REVIVED,
+	KHO_INCOMING_FAILED,
+};
+
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t bootmem_phys;
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
+	enum kho_incoming_state state;
 	struct kho_debugfs dbg;
 	struct kho_radix_tree radix_tree;
 };
@@ -957,6 +965,29 @@ phys_addr_t kho_bootmem_size(void)
 	return size;
 }
 
+static const char * const kho_incoming_state_names[] = {
+	[KHO_INCOMING_NONE]	= "none",
+	[KHO_INCOMING_REVIVED]	= "revived",
+	[KHO_INCOMING_FAILED]	= "failed",
+};
+
+static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
+			  char *buf)
+{
+	return sysfs_emit(buf, "%s\n", kho_incoming_state_names[kho_in.state]);
+}
+static struct kobj_attribute state_attr = __ATTR_RO(state);
+
+static struct attribute *kho_incoming_attrs[] = {
+	&state_attr.attr,
+	NULL
+};
+
+const struct attribute_group kho_incoming_attr_group = {
+	.name	= "kho_incoming",
+	.attrs	= kho_incoming_attrs,
+};
+
 /*
  * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
  * with large systems with hundreds of gigabytes of memory. It will work poorly
@@ -1753,6 +1784,7 @@ static void __init kho_mem_retrieve(void)
 	 */
 	kho_in.fdt_phys = 0;
 	kho_in.radix_tree.root = NULL;
+	kho_in.state = KHO_INCOMING_FAILED;
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1992,6 +2024,7 @@ void __init kho_memory_init_early(void)
 	 */
 	kho_in.fdt_phys = 0;
 	kho_in.bootmem_phys = 0;
+	kho_in.state = KHO_INCOMING_FAILED;
 }
 
 void __init kho_memory_init(void)
@@ -2090,6 +2123,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 unmap_fdt:
 	early_memunmap(fdt, fdt_len);
 report:
+	kho_in.state = populated ? KHO_INCOMING_REVIVED : KHO_INCOMING_FAILED;
 	if (!populated)
 		pr_warn("disabling KHO revival\n");
 }
-- 
2.54.0


