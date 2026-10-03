Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA6CCA5FE8
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603596B00A7; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A216B00A9; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BA16B00AA; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 150896B00A7
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D1141C3BF2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:45 +0000 (UTC)
X-FDA: 85279411770.30.6A30DBB
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC59340006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OVvqKrN0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3lkrAagoKCIkw6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3lkrAagoKCIkw6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htfKz68Uuz6N9IF9mggRs6yYLkAuL8ZW2J7LXlHwfEI=;
	b=4FMTB9OvREkxmuvI7KsuFXWR+FZ5Qdg2nUeDXoyXwIK+yxMTbbW9CXqqKrlGijH5T5j32e
	rJ4ZFBJ0MZ2VB9vGFZE9g/Ttobqma4RGx9PY4yZgNaNancqr8uBDvx3UFMauRxyvdybT6b
	gmeAZfNFPwlx25qIxEZe/IP4NXqZvS8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OVvqKrN0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3lkrAagoKCIkw6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3lkrAagoKCIkw6u17tu610t11tyr.p1zyv07A-zzx8npx.14t@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986903;
	b=GZSuvdrtxjVTXYfqGeiccwrTJFjC/mR4A0hiUuzbTVyvHHBVzeEgkAk1KcfO87AkYu8FBw
	HgMfLmXBx9d7Zl0KusiZ4SQiIimTcVRcmvutAIZoIrF2oR0nZdC3Mvz0ojztdbdl5NRFMe
	bJd7fxPmMifafwxiFd2WwDNkB5m5L0w=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso142811a12.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986903; x=1791591703; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=htfKz68Uuz6N9IF9mggRs6yYLkAuL8ZW2J7LXlHwfEI=;
        b=OVvqKrN0AEedA3C6rDUoxSpRPfOAionEYHSk5vX+Pft0igge+IpeI4H673PB6EDK/5
         SpKi4oUqtoHOHdPbteP4+NybP1EHCKccq6e4UHZIfc4V/0dfeeoQJRTAqJtyfrXA8w7o
         JyrYF2tCuhe2YcnjIGloEnTKkxVrmarN7A0zI1Dru4YVp1rEc7IUcwSFvff5S56BfldK
         w1XoW6TwZxYfZ0dmiGBOIQ3AZCfCn+NYW0ulepCJXWZMQL6kq6BtyvQD4SzPS67aL50/
         7oNnN8wYTcKF4N4mhklyUd+W5ZpIagAOFUPnFwzTj+1Qoa0mYW2YD0II0mVNrGRMKMc1
         ezng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986903; x=1791591703;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=htfKz68Uuz6N9IF9mggRs6yYLkAuL8ZW2J7LXlHwfEI=;
        b=zh+DjrMycJFb6ZQNphikj1oYV40+nj9Fu0jlb8iZ42GCHXtiyrmGp+9tlAW0xTCUvl
         YTdFGS3uw+HEVg6l1xq4isnBggu4/AVcKXz5No0KgPDOfZU7CwUmpyMpFpwi8TXZOUid
         aP1zUWMyB1K7465e4OeAlwmFFdeJ2lFZweKyoznyDaIqASssxy8kQWgdz1T/JwS7gkgW
         brjguX83BempmyuwmP9jm7c3/I9CRD7lBpHXoqVcNQtA+is01CVli2b/Z0HSjkimb8Ep
         F/l1LTTKCZRVNX3VgXWm2z/xBj9EDWRk3iqOayOfrjtMMOt82TgjcEiZe7QTPQHsIGdX
         0vrA==
X-Forwarded-Encrypted: i=1; AKwUvBwjMN5g67z1uOagJGlgwMf9ohCyO/E1JHEJMjQrDkr1uvRbelKX9EQ19WA28uPNw9940tBH/UYRhg==@kvack.org
X-Gm-Message-State: AFuF++lekKWG5zyPASRmc2AhrrWYgJeNv8IUQuf3IdWCdHnYhJOeE6zg
	dLij6bDEQpdH+kUuzdrcjtMTT4g0ukfLCAigiFAdhQKE0JWiBet+LUyGIOiqMTlr5XmlxWuVvfi
	68/jyG27JBAlbOkvQimj2dg==
X-Received: from pgip23.prod.google.com ([2002:a63:c157:0:b0:cc7:6138:fe1b])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1bc6:b0:3cc:ebeb:3efe with SMTP id adf61e73a8af0-3e0d68c7030mr953918637.9.1790986902363;
 Fri, 02 Oct 2026 17:21:42 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:12 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-10-jthoughton@google.com>
Subject: [PATCH v2 09/20] hugetlb_vmemmap: Allow architectures to make HVO
 enablement boot-time only
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DC59340006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: f69tue1jxpcermhbji8fgmyj8kiz1uu1
X-HE-Tag: 1790986903-683517
X-HE-Meta: U2FsdGVkX1/emSDLrDb/2pKDfGDxeH94GVoG2TMmHe0mzT81qVqfwdeX8zwQGDmi9p2/XZmJUDJEorBlD7bF8n0yYPtZ5Yh/8aB3PwP/UAVJPTREQME/0nl+5eQ0lsRNGH7Ckl9ZJzBhpga6vKuUQrye5P11z37L7XrNqrYn5WVHvf68ATsObNh/GoLL2O9ycFipWlbIGAnFs2RVJnJrJe90kO2MMmahc/wKaq2Ons9Og54hrsT4cdWUVaaa/Lyj7hvNaKJvaA+eOqLGL/pMeXdlELl94CVo+dBz+qKhIaPYeBeyK7IOq4GXnLvRLdRXOhSyRhiEr0dr5YB09waEon+wkSzBtekvV6QL5e8OsovZ3GMYAMhVg2rQn3phoEwQdeasU80sMckn3tvuUC3aqq4E2b6tc/nf524XR64aGpN65LxurQ8lsE17Sd2UsBY3iSRjz1o7L9cCiuZKV8PewLFULnSnEjLDvD1AlzRkfsyc/h3Ydat2ldTzrpnoVqwbLihN9Ebb6bd8AkcNe3HKuusM1jDsncO8JoxNLVCErnZOeaxiKaHkuGNwHMxGyF2/eCBClaMDtqj6vXUcJ53LVSUnJb30irIP8QJ6oouArqV495yo2qL1Tt4LTgtC1B/6Q05LaE0uFYhtaYbbwuVyJA1NgNIGxeGR3JsoUklFelPBw5xZMt470ccmUYtBm1pwgrXYdq8UpdLRzIELxnXTJ97ld0kCWY7FGoZuraqrSEqIgaXXjTcLV25P1amoKBcK3uVjAn9nEMrD0lk4rjDy0eOH12hrdWp35ce5lTftQaN/lzUXh8P0K5k7aYXX1ElINlIUagGWhzJUkEBtIePf0MR7KOqRfomHlUEVsjOm/STV2ep6YClqApnicAE3YOS3+06AzxcFSXxpiGe7oxXCUHE+39TKoGbAl33dxQ0bPPbT/r1vMBcjS+okogyYloTyIZn+NmJPslTrmMRPzjY
 sfZVB/So
 Rztx4bUQmknro2941PC5iXbPo+/0ZZ8c5AgZVcEzzKF9rr7uz+mWGvMW1fbsd9jrBvt2y92dNZz+w8edXYS0dOMG5ikhg8FxIny/sll4BXiRNqjFbY3+Jt7fEvFVL2A48HlIdYhA7KXPnvvQLHyYhXIcf4tu+gvrEnfZT/l82WCSLBB5e/6Fu9jraAYWbf/JSO0RDJG/oENGXMYfKCXp1tqvXxLs7XNo55WWf1H4Ow9Jxl9RY0AplLSWm9wwJHmWbyTSu4vwG6HNjO5LcoK0pZFV+MGs3jtj6VYTvQ+lTa4n4AVaI30pPppIGbKGxgv95/H1bkqmke55XqSkegx15VeaeQJMsVAC4xlTWr13VckrhZQ8IKaeXVeNH54Yx0/OgO8kAKTyilh6/3IP/Cc1qFOpfaPYw1DocxUbaiKrD/DxOLwuecDzBOYGoTEhD7SPdgtCrdU87BnWCnV4PAX+S/aVlVJ3T2Dj9axHS/Jl2iOuAks1QVAl4vVrzkA4Wars8xaJ6KdZQ7Ynfl5zTL5CDP/DPzu/gDb673lpaPEf7WeALKi+oYDuMA+FAu01QN86Ns6+VLBeySPJCd2J4GunESPya/ddtNllkjXzAhY/CJin+frxCZHp3GZsDQyKEg6Q4AULzBYsoRBUR9Syso8ctu4/NvdmysJGHuHYz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arm64 needs all CPUs to support hardware updates of the access flag to
safely update the vmemmap in place, and it will need to refuse to online
CPUs that lack it, but only if HVO may be used. This only works if HVO
cannot be dynamically enabled, otherwise incompatible CPUs may have
already been onlined at enable time.

Add CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT for architectures to
select. When selected, vmemmap_optimize_enabled is __ro_after_init, so
it can only be set with the hugetlb_free_vmemmap= kernel command line
parameter, and the sysctl is made read-only.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  3 +++
 fs/Kconfig                              |  3 ++-
 mm/Kconfig                              |  9 +++++++++
 mm/hugetlb_vmemmap.c                    | 17 +++++++++++++++--
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17aa4b..d962d563cfd4 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -692,6 +692,9 @@ pages.  So, those surplus pages are still optimized until they are no longer
 in use.  You would need to wait for those surplus pages to be released before
 there are no optimized pages in the system.
 
+On some architectures, this knob is read-only, and HVO can only be enabled or
+disabled with the hugetlb_free_vmemmap= kernel command line parameter.
+
 
 nr_hugepages_mempolicy
 ======================
diff --git a/fs/Kconfig b/fs/Kconfig
index 1454b7fe9641..4222db17ba02 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -267,7 +267,8 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
 	help
 	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
-	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+	  (boot command line) or hugetlb_optimize_vmemmap (sysctl, if the
+	  architecture allows changing it at runtime).
 endif # HUGETLBFS
 
 config HUGETLB_PAGE
diff --git a/mm/Kconfig b/mm/Kconfig
index acefc994d9a8..ad313fddc9da 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -475,6 +475,15 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
+#
+# Select this config option from the architecture Kconfig if HugeTLB vmemmap
+# optimization may only be enabled or disabled on the kernel command line, e.g.
+# because the architecture configures the system at boot based on whether it
+# is enabled. This makes the hugetlb_optimize_vmemmap sysctl read-only.
+#
+config ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
+	bool
+
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 817ce39d4cf3..de4148a8aabf 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -428,7 +428,20 @@ static int vmemmap_remap_alloc(const struct hstate *h, struct folio *folio,
 	return ret;
 }
 
-static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
+/*
+ * Architectures selecting CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT rely on
+ * HVO only being enabled or disabled on the kernel command line.
+ */
+#ifdef CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
+#define __vmemmap_optimize_enabled_attr	__ro_after_init
+#define HUGETLB_VMEMMAP_SYSCTL_MODE	0444
+#else
+#define __vmemmap_optimize_enabled_attr
+#define HUGETLB_VMEMMAP_SYSCTL_MODE	0644
+#endif
+
+static bool vmemmap_optimize_enabled __vmemmap_optimize_enabled_attr =
+	IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
 	return kstrtobool(buf, &vmemmap_optimize_enabled);
@@ -751,7 +764,7 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 		.procname	= "hugetlb_optimize_vmemmap",
 		.data		= &vmemmap_optimize_enabled,
 		.maxlen		= sizeof(vmemmap_optimize_enabled),
-		.mode		= 0644,
+		.mode		= HUGETLB_VMEMMAP_SYSCTL_MODE,
 		.proc_handler	= proc_dobool,
 	},
 };
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


