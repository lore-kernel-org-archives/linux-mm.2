Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0978CCCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2548019F; Tue, 28 Oct 2025 13:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3525580199; Tue, 28 Oct 2025 13:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2679D8019F; Tue, 28 Oct 2025 13:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08C0180199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:50:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7F02C052B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:49:59 +0000 (UTC)
X-FDA: 84048261318.14.E3A8F3C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0C73140004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:49:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=nl+Mvvq8;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673798; a=rsa-sha256;
	cv=none;
	b=rtj2KYSv/2VnOoiR7bhTY6t28L9yAeD7kg5qe+T/NawwdSaOJyys46SuvAYKvIRGyxy1Ez
	Upv/5eR6T6WCHcIlkfimlrRVkfT/2YmxdB75pq1SozKVOk/uYTJ8Jm103i5TUpPu73tWC+
	gH/T8OgCtk/pd7mAphBzS9Sh4X8aHms=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=nl+Mvvq8;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7TAeOGTyPvQPOj1dnWWA9h27m0pwmAjfFVTIH6M/D2U=;
	b=TyUkXwksd4PNnQ9qFYZPF3u6alH4A4oBBDNpKy4whO8mxuqD71p6jJwiZWPABF84xkYC5o
	B1FA6pNQtbUNI6i1toM9dRbXBD7hRduGeQWSy4SXHDWPK7JFpDYb4XgnZo5iNDCyZ7vN2l
	iQ3Fr2Gsb96iHYhmTmVEm7zRj2Y4oeI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 117A39B03D;
	Tue, 28 Oct 2025 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761673796;
	bh=7TAeOGTyPvQPOj1dnWWA9h27m0pwmAjfFVTIH6M/D2U=;
	h=Date:From:To:Cc:Subject;
	b=nl+Mvvq8qNDSjHEeETFy2KaoRXk8qfM044sEJxCrthmzG1VLoWely/8lApfQKP1gD
	 cEJbd4POjzCvrxMwfNilXK66F3634JASfYzXwG1VqJiq+4jRVveGjQZ5XTAwF16NuU
	 4dVNttwQJ70x4HmJ/myIKUg/f4rFvI/eaf63UAes=
Date: Tue, 28 Oct 2025 17:49:50 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aQECPpjd-fU_TC79@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: qrzb6ey1tdgfho7hcwa4bat8z7zxp9a6
X-Rspamd-Queue-Id: F0C73140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761673797-694639
X-HE-Meta: U2FsdGVkX1//IhOz/JDMXotP14eW8Q/XGby/Qn70eUAwoAG9w+gjHnm0T72vxP9HeKi0hdsKiu+qd8hqZwC094KopLKSl/ZuVUk+hDu2ayWbj0xXVeHYBP3J03E2/bAF5+129NhLhi0OT/sNBibjG7eHNUZ5vpY5yk7dbHpdoz1bdIO62JxN6GaA0wVIzgm9b+ipuxajT+9z3hP9QEKuYsIFp14ZRkiKFqNbYzP04aq6wx1cvoPmxgEB64yxd5FqQKu2qE8W5QvG6E1D24k/BVHqrrXDqwchJQAJgj8IH5IX249hR0TqXGU/BmWhsQkM12Wwdf0AEkvZ6NO13Ns4yTP8v7dZjHEKU7HK1zGU/6B+9bwx3H8TAcX6dt2p8uoepwYzyhq6EYry5W2wdbOviaQ/Ia/OIljQVzQyEg3uydp7E4hXUu0ipQPIYYILjgBrm7bmGCkckrhSlZwd6xcW8JCECDRfLC1jD+/pnuYRk/8PtiIoyh5RbP8svxttxUdTnNvsm3HCK4o8rVVc+j569+qGcxga6BoDa2MFtwjpu/wOuBFKhNfL6ics/hzw1zu9AQZ4A2VXgcaxKc1ITfie+NXRQ8y9YkSMqkD6wLSY9cWgyko2dJ9WDfTxoboBaRG0m8XdyCfoGAigOeBmG4WfSoSBi2N8RVh50sHBvOzMtqNPJ8rmCc/WZVlRczQRA9sMeVS2856Z2D9MxrohjIpxTn3awvi6jgYBl3RXqMh+T63EBaaZ70ioUxU+4gC1guJ16rG8h0uXr7w+XYMQLvB7r2f/LDdnsJtqOgVf3fDxE3dGRQceQVLMHnYedzH8yVo6xRcOY7wUHbt72LcjaDFE/BTF5ZhiQWraDufFXoK+o1LNAuyum8/yZowNNIrm8Jz0MH93CQIkCeCXs+eaxqNXhwVZ1o1aCPV8x3445bZGEaBphhnuRp8oTlIqW78F4O5DH4KstbJrjhKT8jpY6nY
 omdLArC/
 rd1IsNL7kUrfkBs/UKaQg5k6tm/qWsAB7beQ8j1KcOoSbpEbwSPSjwh/Dcw79QcCy/6B6MaJJ0ADFSrGkme1zn7kh7I6cSqqB0MaR/Z2hf/AXgyWmww1sJ3kWrf67murpQ6j1zX7mxB9enrOqn1K4cZNx/QtP8WUJflVD7hQDL/zbbVt45TzVd+eza08etJV8HnykV2GD/uyNEyBfzfgOV/h9FaQ9zH5/PE/Avh6vlhqswi+ErobBMRSgECjOLkGFHVJLb5dpRFBSW553H1Hn09n69NUMbZNYvV/AVCVMiNqIc1iqvhgzgWtbKgFL+6daMTJpXqQ+28lYlH66swZPBo2hXwrZ4UhUiT5nInZpgowrvUVGt2Mkcu03ZYijcqu7d0PJsiTBj4qKPLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow to override defaults for shemem and tmpfs at config time. This is
consistent with how transparent hugepages can be configured.

Same results can be achieved with the existing
'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
in the kernel command line, but it is more convenient to define basic
settings at config time instead of changing kernel command line later.

Defaults for shmem and tmpfs were not changed. They are remained the
same as before: 'never' for both cases. Options 'deny' and 'force' are
omitted intentionally since these are special values and supposed to be
used for emergencies or testing and are not expected to be permanent
ones.

Primary motivation for adding config option is to enable policy
enforcement at build time. In large-scale production environments
(Meta's for example), the kernel configuration is often maintained
centrally close to the kernel code itself and owned by the kernel
engineers, while boot parameters are managed independently (e.g.  by
provisioning systems).  In such setups, the kernel build defines the
supported and expected behavior in a single place, but there is no
reliable or uniform control over the kernel command line options.

A build-time default allows kernel integrators to enforce a predictable
hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
behavior and avoiding configuration drift caused by possible boot-time
differences.

In short, primary benefit is mostly operational: it provides a way to
codify preferred policy in the kernel configuration, which is versioned,
reviewed, and tested as part of the kernel build process, rather than
depending on potentially variable boot parameters.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
Changes v2:
- Mentioned Kconfig options in Documentation/admin-guide/mm/transhuge.rst. 
  Didn't list all of them intentionally to avoid duplication and possible 
  content drift in the future.
- Expanded commit message with rationale behind the change. Mentioned Meta
  explicitly.

 Documentation/admin-guide/mm/transhuge.rst |  5 ++
 mm/Kconfig                                 | 91 ++++++++++++++++++++++
 mm/shmem.c                                 | 33 +++++++-
 3 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..5fbc3d89bb07 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -381,6 +381,11 @@ hugepage allocation policy for the tmpfs mount by using the kernel parameter
 four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
 ``never``). The tmpfs mount default policy is ``never``.
 
+Additionally, Kconfig options are available to set the default hugepage
+policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
+(``CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_*``) at build time. Refer to the
+Kconfig help for more details.
+
 In the same manner as ``thp_anon`` controls each supported anonymous THP
 size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
 has the same format as ``thp_anon``, but also supports the policy
diff --git a/mm/Kconfig b/mm/Kconfig
index e47321051d76..5ceea38edbe1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -853,6 +853,97 @@ choice
 	  enabled at runtime via sysfs.
 endchoice
 
+choice
+	prompt "Shmem hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the internal shmem mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_shmem=' option.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for shmem mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_shmem=' option or at runtime via sysfs
+	  knob. Note that madvise(MADV_COLLAPSE) can still cause
+	  transparent huge pages to be obtained even if this mode is
+	  specified.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for shmem mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for shmem mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the shmem mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
+choice
+	prompt "Tmpfs hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the tmpfs mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_tmpfs=' option.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for tmpfs mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_tmpfs=' option. Note that
+	  madvise(MADV_COLLAPSE) can still cause transparent huge pages
+	  to be obtained even if this mode is specified.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for tmpfs mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for tmpfs mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the tmpfs mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
 config THP_SWAP
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
diff --git a/mm/shmem.c b/mm/shmem.c
index eb8161136a7f..a411d7fb6e5a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -570,8 +570,37 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
-static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
-static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int shmem_huge __read_mostly = SHMEM_HUGE_DEFAULT;
+
+#undef SHMEM_HUGE_DEFAULT
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int tmpfs_huge __read_mostly = TMPFS_HUGE_DEFAULT;
+
+#undef TMPFS_HUGE_DEFAULT
 
 static unsigned int shmem_get_orders_within_size(struct inode *inode,
 		unsigned long within_size_orders, pgoff_t index,
-- 
2.47.3


