Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A66CCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EC68E0007; Mon, 15 Sep 2025 12:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F648E0001; Mon, 15 Sep 2025 12:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF978E0007; Mon, 15 Sep 2025 12:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9209A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:18:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2687EC0630
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:42 +0000 (UTC)
X-FDA: 83891992884.04.A628381
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B76818000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=H7ql8+cs;
	spf=pass (imf06.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7Ihk8dN1OX3rIDkweFMJxbqL33X3cWczmsnQZ84nD0=;
	b=HBw9FrZzMQhv6ttY5Lb/Q6yFBTRqZ7gcR4q4ByrVG+m4chJxBjlDS/PrdqxRcpvsxPFodf
	5+pO5mZzmteZG23PZ/o1aqVzpblyitY3ipdHJD5HgNmWBsHjRyZCn89i8nW/dipNQD1J8S
	+eqeKX2npcpIVBWeY4ol9+Kg8PhW5YI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=H7ql8+cs;
	spf=pass (imf06.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953119; a=rsa-sha256;
	cv=none;
	b=aQ1XaRP4OQLm7nwABl8ILnSr7PF2IytMGwPlqu9BWoVzmVV6hvfxHMWRI9qiukC4Na8C41
	v3z6kZHLaa41IZZKVsCJxfLhH9UT5HD3+UQu2IuuYc3bFHzXH1/MeC+iAWB1JEFzEwCyiy
	JKm9pybYkFHnscK7oWpb3ReOOfSJpss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757953119; x=1789489119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+7Ihk8dN1OX3rIDkweFMJxbqL33X3cWczmsnQZ84nD0=;
  b=H7ql8+csm4OdpmMpg+Q/3AZLcnmOkQMj8cmoHX3WnDSdK2o6uRiL51nR
   IeHOXvalIchLc1xnMEk4OqaQ88/txodrj04HmYwsOewI5XQ4FEW01zJ7/
   dgj5GrOMc8HSXVyjNcQxheh3WWvoJQwqcFvRuBXUsd5gwL82tBMQL5hoo
   giiNLxb9Jy3UnTBhhpCNa0u+UiYUVO0BzT+JipOvdO1rlDa1v9lPHwJGy
   k6qk6FCwhaZPrrGAIuH7+VL4JC1ttmmJijr5NyQl+6gZ4sN0c3qL8W8Nf
   d5a6tzrLxr5rkNB5LbBciSSvtYI1jgBk21LjUyUhc+YRUN4nt/6go98UR
   w==;
X-CSE-ConnectionGUID: FzHRW/IQS9iWkCJBJyujBg==
X-CSE-MsgGUID: qDwG3z9ZTri5JNhH4IsCNQ==
X-IronPort-AV: E=Sophos;i="6.18,266,1751241600"; 
   d="scan'208";a="2037073"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 16:18:29 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:31782]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.39.25:2525] with esmtp (Farcaster)
 id eb035914-eb78-4888-80be-0d4b8f8fa5e0; Mon, 15 Sep 2025 16:18:28 +0000 (UTC)
X-Farcaster-Flow-ID: eb035914-eb78-4888-80be-0d4b8f8fa5e0
Received: from EX19D022EUC001.ant.amazon.com (10.252.51.254) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:28 +0000
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19D022EUC001.ant.amazon.com (10.252.51.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:28 +0000
Received: from EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80]) by
 EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80%3]) with mapi id
 15.02.2562.020; Mon, 15 Sep 2025 16:18:28 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org"
	<brauner@kernel.org>
CC: "peterx@redhat.com" <peterx@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "jthoughton@google.com"
	<jthoughton@google.com>, "tabba@google.com" <tabba@google.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring,
 Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [RFC PATCH v6 1/2] mm: guestmem: introduce guestmem library
Thread-Topic: [RFC PATCH v6 1/2] mm: guestmem: introduce guestmem library
Thread-Index: AQHcJlxeAltL5rIkhE6iLHFOGH9QMQ==
Date: Mon, 15 Sep 2025 16:18:27 +0000
Message-ID: <20250915161815.40729-2-kalyazin@amazon.com>
References: <20250915161815.40729-1-kalyazin@amazon.com>
In-Reply-To: <20250915161815.40729-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6B76818000E
X-Rspamd-Server: rspam05
X-Stat-Signature: ndqud4tgyqrxzg9t34t6q3uwph4r16gw
X-Rspam-User: 
X-HE-Tag: 1757953119-619190
X-HE-Meta: U2FsdGVkX1+8xY2wLfXEblAWewgEzTbc4sR1Pj83DO9BkwTm4ypgmcYEEnc7XCeSu7F44lFwXxrwxIFmEUH7sx1L84XFXqFsKLwn18g5Nt4ix29uelR34p6L4i8KHeDbWuyNerRt81afMNqxfjWXdAKhUe7QKuTYBGyr4UiCwe+9sQf7BnUGotPju2xHDfKy8zt3e7ifD4CJ/tVJS7h0XIXPsdnvNHROz/nM7xYui6/ULBMZBSeWVpAteenhfJPN41S0iKS8yTKGkU2mutK3KAjgxbrax9QKT96o50IRgjHcJ+LaEQIpUJlx+3F0Z9vuZ52JYNsV1KEa/obirPu258/lUabI2YYoDYR++MZbrCVAxkGQUHdabdjekOaW3M5GpAKUt2IBT2O7ek+JFqjnYYHYY/HFnERAAp6y/93+XgGhhEzaspYth8emONsiS44vpgu+hkBWEdL5Y1JbbwA2NFyImp1E4VPC5GaDnJqcoJ031dnYCOdUZ/y2XMTuEYkch8Jzi8OmHDExTEOggjgK3qrUv9v98NTdclsbeVP8AW1o+q1d4kp0jNOxgBVC3waLnEajsaO3Us47BQeZbot43mciV43ZJUsSsurjGK0UF9fQpPLEEDb+6CBRj65nc1tEF7S3FJsPTJVXZO4P5761R2F/m4HbohUiQnX09HwJP4K2GP+vty7ruxMYbYb7sP7hDPEYjLgp2m8UaVU/IGKLhMNyIyaO2X/Q3yCo0gag4k7FXNhy/regohlI175lT3GzgpA9pilsSPvh8Zioa3RNvDSQHG3taQBy3DVH3GHwFwrKPMtgUpN5dUEWH2vXNt5K7ymOq31SpO1sXnwLLvjFL5sNCb227Zo80EhPrdxj0dwmlE3kk+tOPXtBQ25cqZ9HB/UC9rvAsaNH1DnGEIIbyQcnCZoqWVw2QofZG+Hq8SmushPZrFoVeazjJgwJN20v+BISxv+H6A1dj6zsmC/
 AG0qreY1
 3P7BUP0QpBszG+LaVF1NQwat9tbjgCX4x0hKWbk56j6usE4FO2VluUxfanubn74HjcGE6VKAHak48eGFxwyNpSvtanr0B+v5GuOacDkLoAHAabx8k4o3o3T5VJ8NeB3EmW8NKdx09gSAbDcFomU3sxVtOfqsmBUM/yL3dFVKUVAlIoTAB0oyRt9KU1+as7raRCl20xjbWbu0ROX+mB+Hz3yk66q5Fp+4Kxzu/HWXTqru3ZUMEp3lfLV4/oYmmWnzkGhV/vTlKC40/Ddkjk1lf6ijpCFY/pfebcY8gGtBG7eoBPi+xJRwWularlOS3fzRJm4Ds6+h8oLR2OCnqDKV76JwkBu8xRSVC88fTGYFnEpManHcKx9dDugWfi51Ji3xlfKcSNNTYxB2z6QHncPUOPqTbLfSv6wALbRytknSDqhLmmok88Rvu+xWd08hg41fElrRz//eBSU8hmPT6hJ1UB/d9nko7jjpHwyxZ8yo3m9TrWY02i4XPKpj29Cm1olnkc4QGr5++xR1kf58CerEU2EQeRHFTvGKRB12qM3vVkCh3bkumYJTH1CJm1V+MsmZD9UmUuHwwosgLuZq6Pn3ucGeHrzOXQR/jku8vVBu/0o9cmvhelLMNhhdW1VXVknjKbaxY+4lnlD3mux27wvWiOhStb6FLVqMV2d2qpxuyzQNTW7wEDh8Ft+f80xfTHO4n/do7xqN0uBJGxnit8ml5idawcZWDXVFxXU8vsdzlgA4gmhYTRz4IIVriEp+4VvN2onhncEJtyqaudlfholpQhAck1BaELqOTjsEA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
Move MM-generic parts of guest_memfd from KVM to MM.  This allows other=0A=
hypervisors to use guestmem code and enables UserfaultFD implementation=0A=
for guest_memfd [1].  Previously it was not possible because KVM (and=0A=
guest_memfd code) might be built as a module.=0A=
=0A=
Based on a patch by Elliot Berman <quic_eberman@quicinc.com> [2].=0A=
=0A=
[1] https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.com=
=0A=
[2] https://lore.kernel.org/kvm/20241122-guestmem-library-v5-2-450e92951a15=
@quicinc.com=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 MAINTAINERS              |   2 +=0A=
 include/linux/guestmem.h |  46 +++++=0A=
 mm/Kconfig               |   3 +=0A=
 mm/Makefile              |   1 +=0A=
 mm/guestmem.c            | 380 +++++++++++++++++++++++++++++++++++++++=0A=
 virt/kvm/Kconfig         |   1 +=0A=
 virt/kvm/guest_memfd.c   | 303 ++++---------------------------=0A=
 7 files changed, 465 insertions(+), 271 deletions(-)=0A=
 create mode 100644 include/linux/guestmem.h=0A=
 create mode 100644 mm/guestmem.c=0A=
=0A=
diff --git a/MAINTAINERS b/MAINTAINERS=0A=
index fed6cd812d79..c468c4847ffd 100644=0A=
--- a/MAINTAINERS=0A=
+++ b/MAINTAINERS=0A=
@@ -15956,6 +15956,7 @@ W:	http://www.linux-mm.org=0A=
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm=0A=
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new=0A=
 F:	mm/=0A=
+F:	mm/guestmem.c=0A=
 F:	tools/mm/=0A=
 =0A=
 MEMORY MANAGEMENT - CORE=0A=
@@ -15973,6 +15974,7 @@ W:	http://www.linux-mm.org=0A=
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm=0A=
 F:	include/linux/gfp.h=0A=
 F:	include/linux/gfp_types.h=0A=
+F:	include/linux/guestmem.h=0A=
 F:	include/linux/highmem.h=0A=
 F:	include/linux/memory.h=0A=
 F:	include/linux/mm.h=0A=
diff --git a/include/linux/guestmem.h b/include/linux/guestmem.h=0A=
new file mode 100644=0A=
index 000000000000..2a173261d32b=0A=
--- /dev/null=0A=
+++ b/include/linux/guestmem.h=0A=
@@ -0,0 +1,46 @@=0A=
+/* SPDX-License-Identifier: GPL-2.0 */=0A=
+#ifndef _LINUX_GUESTMEM_H=0A=
+#define _LINUX_GUESTMEM_H=0A=
+=0A=
+#include <linux/types.h>=0A=
+=0A=
+struct address_space;=0A=
+struct list_head;=0A=
+struct inode;=0A=
+=0A=
+/**=0A=
+ * struct guestmem_ops - Hypervisor-specific maintenance operations=0A=
+ * @release_folio - Try to bring the folio back to fully owned by Linux=0A=
+ *		    for instance: about to free the folio [optional]=0A=
+ * @invalidate_begin - start invalidating mappings between start and end o=
ffsets=0A=
+ * @invalidate_end - paired with ->invalidate_begin() [optional]=0A=
+ * @supports_mmap - return true if the inode supports mmap [optional]=0A=
+ */=0A=
+struct guestmem_ops {=0A=
+	bool (*release_folio)(struct address_space *mapping,=0A=
+			      struct folio *folio);=0A=
+	void (*invalidate_begin)(struct list_head *entry, pgoff_t start,=0A=
+				 pgoff_t end);=0A=
+	void (*invalidate_end)(struct list_head *entry, pgoff_t start,=0A=
+			       pgoff_t end);=0A=
+	bool (*supports_mmap)(struct inode *inode);=0A=
+};=0A=
+=0A=
+int guestmem_attach_mapping(struct address_space *mapping,=0A=
+			    const struct guestmem_ops *const ops,=0A=
+			    struct list_head *data);=0A=
+void guestmem_detach_mapping(struct address_space *mapping,=0A=
+			     struct list_head *data);=0A=
+=0A=
+struct folio *guestmem_grab_folio(struct address_space *mapping, pgoff_t i=
ndex);=0A=
+=0A=
+int guestmem_punch_hole(struct address_space *mapping, loff_t offset,=0A=
+			loff_t len);=0A=
+int guestmem_allocate(struct address_space *mapping, loff_t offset, loff_t=
 len);=0A=
+=0A=
+bool guestmem_test_no_direct_map(struct inode *inode);=0A=
+void guestmem_mark_prepared(struct folio *folio);=0A=
+int guestmem_mmap(struct file *file, struct vm_area_struct *vma);=0A=
+bool guestmem_vma_is_guestmem(struct vm_area_struct *vma);=0A=
+=0A=
+#endif=0A=
diff --git a/mm/Kconfig b/mm/Kconfig=0A=
index e443fe8cd6cf..a3705099601f 100644=0A=
--- a/mm/Kconfig=0A=
+++ b/mm/Kconfig=0A=
@@ -1254,6 +1254,9 @@ config SECRETMEM=0A=
 	  memory areas visible only in the context of the owning process and=0A=
 	  not mapped to other processes and other kernel page tables.=0A=
 =0A=
+config GUESTMEM=0A=
+	bool=0A=
+=0A=
 config ANON_VMA_NAME=0A=
 	bool "Anonymous VMA name support"=0A=
 	depends on PROC_FS && ADVISE_SYSCALLS && MMU=0A=
diff --git a/mm/Makefile b/mm/Makefile=0A=
index ef54aa615d9d..c92892acd819 100644=0A=
--- a/mm/Makefile=0A=
+++ b/mm/Makefile=0A=
@@ -138,6 +138,7 @@ obj-$(CONFIG_PERCPU_STATS) +=3D percpu-stats.o=0A=
 obj-$(CONFIG_ZONE_DEVICE) +=3D memremap.o=0A=
 obj-$(CONFIG_HMM_MIRROR) +=3D hmm.o=0A=
 obj-$(CONFIG_MEMFD_CREATE) +=3D memfd.o=0A=
+obj-$(CONFIG_GUESTMEM) +=3D guestmem.o=0A=
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) +=3D mapping_dirty_helpers.o=0A=
 obj-$(CONFIG_PTDUMP) +=3D ptdump.o=0A=
 obj-$(CONFIG_PAGE_REPORTING) +=3D page_reporting.o=0A=
diff --git a/mm/guestmem.c b/mm/guestmem.c=0A=
new file mode 100644=0A=
index 000000000000..110087aff7e8=0A=
--- /dev/null=0A=
+++ b/mm/guestmem.c=0A=
@@ -0,0 +1,380 @@=0A=
+// SPDX-License-Identifier: GPL-2.0=0A=
+#include <linux/fs.h>=0A=
+#include <linux/guestmem.h>=0A=
+#include <linux/mm.h>=0A=
+#include <linux/pagemap.h>=0A=
+#include <linux/set_memory.h>=0A=
+#include <linux/userfaultfd_k.h>=0A=
+=0A=
+struct guestmem {=0A=
+	const struct guestmem_ops *ops;=0A=
+};=0A=
+=0A=
+static inline bool __guestmem_release_folio(struct address_space *mapping,=
=0A=
+					    struct folio *folio)=0A=
+{=0A=
+	struct guestmem *gmem =3D mapping->i_private_data;=0A=
+=0A=
+	if (gmem->ops->release_folio) {=0A=
+		if (!gmem->ops->release_folio(mapping, folio))=0A=
+			return false;=0A=
+	}=0A=
+=0A=
+	return true;=0A=
+}=0A=
+=0A=
+static inline void=0A=
+__guestmem_invalidate_begin(struct address_space *const mapping, pgoff_t s=
tart,=0A=
+			    pgoff_t end)=0A=
+{=0A=
+	struct guestmem *gmem =3D mapping->i_private_data;=0A=
+	struct list_head *entry;=0A=
+=0A=
+	list_for_each(entry, &mapping->i_private_list)=0A=
+		gmem->ops->invalidate_begin(entry, start, end);=0A=
+}=0A=
+=0A=
+static inline void=0A=
+__guestmem_invalidate_end(struct address_space *const mapping, pgoff_t sta=
rt,=0A=
+			  pgoff_t end)=0A=
+{=0A=
+	struct guestmem *gmem =3D mapping->i_private_data;=0A=
+	struct list_head *entry;=0A=
+=0A=
+	if (gmem->ops->invalidate_end) {=0A=
+		list_for_each(entry, &mapping->i_private_list)=0A=
+			gmem->ops->invalidate_end(entry, start, end);=0A=
+	}=0A=
+}=0A=
+=0A=
+static int guestmem_write_begin(const struct kiocb *kiocb,=0A=
+				struct address_space *mapping,=0A=
+				loff_t pos, unsigned int len,=0A=
+				struct folio **foliop,=0A=
+				void **fsdata)=0A=
+{=0A=
+	struct file *file =3D kiocb->ki_filp;=0A=
+	pgoff_t index =3D pos >> PAGE_SHIFT;=0A=
+	struct folio *folio;=0A=
+=0A=
+	if (!PAGE_ALIGNED(pos) || len !=3D PAGE_SIZE)=0A=
+		return -EINVAL;=0A=
+=0A=
+	if (pos + len > i_size_read(file_inode(file)))=0A=
+		return -EINVAL;=0A=
+=0A=
+	folio =3D guestmem_grab_folio(file_inode(file)->i_mapping, index);=0A=
+	if (IS_ERR(folio))=0A=
+		return -EFAULT;=0A=
+=0A=
+	if (WARN_ON_ONCE(folio_test_large(folio))) {=0A=
+		folio_unlock(folio);=0A=
+		folio_put(folio);=0A=
+		return -EFAULT;=0A=
+	}=0A=
+=0A=
+	if (folio_test_uptodate(folio)) {=0A=
+		folio_unlock(folio);=0A=
+		folio_put(folio);=0A=
+		return -ENOSPC;=0A=
+	}=0A=
+=0A=
+	*foliop =3D folio;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int guestmem_write_end(const struct kiocb *kiocb,=0A=
+			      struct address_space *mapping,=0A=
+			      loff_t pos, unsigned int len, unsigned int copied,=0A=
+			      struct folio *folio, void *fsdata)=0A=
+{=0A=
+	if (copied) {=0A=
+		if (copied < len) {=0A=
+			unsigned int from =3D pos & (PAGE_SIZE - 1);=0A=
+=0A=
+			folio_zero_range(folio, from + copied, len - copied);=0A=
+		}=0A=
+		guestmem_mark_prepared(folio);=0A=
+	}=0A=
+=0A=
+	folio_unlock(folio);=0A=
+	folio_put(folio);=0A=
+=0A=
+	return copied;=0A=
+}=0A=
+=0A=
+static void guestmem_free_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
+{=0A=
+	WARN_ON_ONCE(!__guestmem_release_folio(mapping, folio));=0A=
+}=0A=
+=0A=
+static int guestmem_error_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
+{=0A=
+	pgoff_t start, end;=0A=
+=0A=
+	filemap_invalidate_lock_shared(mapping);=0A=
+=0A=
+	start =3D folio->index;=0A=
+	end =3D start + folio_nr_pages(folio);=0A=
+=0A=
+	__guestmem_invalidate_begin(mapping, start, end);=0A=
+=0A=
+	/*=0A=
+	 * Do not truncate the range, what action is taken in response to the=0A=
+	 * error is userspace's decision (assuming the architecture supports=0A=
+	 * gracefully handling memory errors).  If/when the guest attempts to=0A=
+	 * access a poisoned page, kvm_gmem_get_pfn() will return -EHWPOISON,=0A=
+	 * at which point KVM can either terminate the VM or propagate the=0A=
+	 * error to userspace.=0A=
+	 */=0A=
+=0A=
+	__guestmem_invalidate_end(mapping, start, end);=0A=
+=0A=
+	filemap_invalidate_unlock_shared(mapping);=0A=
+	return MF_FAILED;=0A=
+}=0A=
+=0A=
+static int guestmem_migrate_folio(struct address_space *mapping,=0A=
+				  struct folio *dst, struct folio *src,=0A=
+				  enum migrate_mode mode)=0A=
+{=0A=
+	WARN_ON_ONCE(1);=0A=
+	return -EINVAL;=0A=
+}=0A=
+=0A=
+static const struct address_space_operations guestmem_aops =3D {=0A=
+	.dirty_folio =3D noop_dirty_folio,=0A=
+	.write_begin =3D guestmem_write_begin,=0A=
+	.write_end =3D guestmem_write_end,=0A=
+	.free_folio =3D guestmem_free_folio,=0A=
+	.error_remove_folio =3D guestmem_error_folio,=0A=
+	.migrate_folio =3D guestmem_migrate_folio,=0A=
+};=0A=
+=0A=
+int guestmem_attach_mapping(struct address_space *mapping,=0A=
+			    const struct guestmem_ops *const ops,=0A=
+			    struct list_head *data)=0A=
+{=0A=
+	struct guestmem *gmem;=0A=
+=0A=
+	if (mapping->a_ops =3D=3D &guestmem_aops) {=0A=
+		gmem =3D mapping->i_private_data;=0A=
+		if (gmem->ops !=3D ops)=0A=
+			return -EINVAL;=0A=
+=0A=
+		goto add;=0A=
+	}=0A=
+=0A=
+	gmem =3D kzalloc(sizeof(*gmem), GFP_KERNEL);=0A=
+	if (!gmem)=0A=
+		return -ENOMEM;=0A=
+=0A=
+	gmem->ops =3D ops;=0A=
+=0A=
+	mapping->a_ops =3D &guestmem_aops;=0A=
+	mapping->i_private_data =3D gmem;=0A=
+=0A=
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER);=0A=
+	mapping_set_inaccessible(mapping);=0A=
+	/* Unmovable mappings are supposed to be marked unevictable as well. */=
=0A=
+	WARN_ON_ONCE(!mapping_unevictable(mapping));=0A=
+=0A=
+add:=0A=
+	list_add(data, &mapping->i_private_list);=0A=
+	return 0;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_attach_mapping);=0A=
+=0A=
+void guestmem_detach_mapping(struct address_space *mapping,=0A=
+			     struct list_head *data)=0A=
+{=0A=
+	list_del(data);=0A=
+=0A=
+	if (list_empty(&mapping->i_private_list)) {=0A=
+		/**=0A=
+		 * Ensures we call ->free_folio() for any allocated folios.=0A=
+		 * Any folios allocated after this point are assumed not to be=0A=
+		 * accessed by the guest, so we don't need to worry about=0A=
+		 * guestmem ops not being called on them.=0A=
+		 */=0A=
+		truncate_inode_pages(mapping, 0);=0A=
+=0A=
+		kfree(mapping->i_private_data);=0A=
+		mapping->i_private_data =3D NULL;=0A=
+		mapping->a_ops =3D &empty_aops;=0A=
+	}=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_detach_mapping);=0A=
+=0A=
+struct folio *guestmem_grab_folio(struct address_space *mapping, pgoff_t i=
ndex)=0A=
+{=0A=
+	/* TODO: Support huge pages. */=0A=
+	return filemap_grab_folio(mapping, index);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_grab_folio);=0A=
+=0A=
+int guestmem_punch_hole(struct address_space *mapping, loff_t offset,=0A=
+			loff_t len)=0A=
+{=0A=
+	pgoff_t start =3D offset >> PAGE_SHIFT;=0A=
+	pgoff_t end =3D (offset + len) >> PAGE_SHIFT;=0A=
+=0A=
+	filemap_invalidate_lock(mapping);=0A=
+	__guestmem_invalidate_begin(mapping, start, end);=0A=
+=0A=
+	truncate_inode_pages_range(mapping, offset, offset + len - 1);=0A=
+=0A=
+	__guestmem_invalidate_end(mapping, start, end);=0A=
+	filemap_invalidate_unlock(mapping);=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_punch_hole);=0A=
+=0A=
+int guestmem_allocate(struct address_space *mapping, loff_t offset, loff_t=
 len)=0A=
+{=0A=
+	pgoff_t start, index, end;=0A=
+	int r;=0A=
+=0A=
+	/* Dedicated guest is immutable by default. */=0A=
+	if (offset + len > i_size_read(mapping->host))=0A=
+		return -EINVAL;=0A=
+=0A=
+	filemap_invalidate_lock_shared(mapping);=0A=
+=0A=
+	start =3D offset >> PAGE_SHIFT;=0A=
+	end =3D (offset + len) >> PAGE_SHIFT;=0A=
+=0A=
+	r =3D 0;=0A=
+	for (index =3D start; index < end; ) {=0A=
+		struct folio *folio;=0A=
+=0A=
+		if (signal_pending(current)) {=0A=
+			r =3D -EINTR;=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		folio =3D guestmem_grab_folio(mapping, index);=0A=
+		if (IS_ERR(folio)) {=0A=
+			r =3D PTR_ERR(folio);=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		index =3D folio_next_index(folio);=0A=
+=0A=
+		folio_unlock(folio);=0A=
+		folio_put(folio);=0A=
+=0A=
+		/* 64-bit only, wrapping the index should be impossible. */=0A=
+		if (WARN_ON_ONCE(!index))=0A=
+			break;=0A=
+=0A=
+		cond_resched();=0A=
+	}=0A=
+=0A=
+	filemap_invalidate_unlock_shared(mapping);=0A=
+=0A=
+	return r;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_allocate);=0A=
+=0A=
+bool guestmem_test_no_direct_map(struct inode *inode)=0A=
+{=0A=
+	return mapping_no_direct_map(inode->i_mapping);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_test_no_direct_map);=0A=
+=0A=
+void guestmem_mark_prepared(struct folio *folio)=0A=
+{=0A=
+	struct inode *inode =3D folio_inode(folio);=0A=
+=0A=
+	if (guestmem_test_no_direct_map(inode))=0A=
+		set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio)=
, false);=0A=
+=0A=
+	folio_mark_uptodate(folio);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_mark_prepared);=0A=
+=0A=
+static vm_fault_t guestmem_fault_user_mapping(struct vm_fault *vmf)=0A=
+{=0A=
+	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
+	struct folio *folio;=0A=
+	vm_fault_t ret =3D VM_FAULT_LOCKED;=0A=
+=0A=
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))=0A=
+		return VM_FAULT_SIGBUS;=0A=
+=0A=
+	folio =3D guestmem_grab_folio(inode->i_mapping, vmf->pgoff);=0A=
+	if (IS_ERR(folio)) {=0A=
+		int err =3D PTR_ERR(folio);=0A=
+=0A=
+		if (err =3D=3D -EAGAIN)=0A=
+			return VM_FAULT_RETRY;=0A=
+=0A=
+		return vmf_error(err);=0A=
+	}=0A=
+=0A=
+	if (WARN_ON_ONCE(folio_test_large(folio))) {=0A=
+		ret =3D VM_FAULT_SIGBUS;=0A=
+		goto out_folio;=0A=
+	}=0A=
+=0A=
+	if (!folio_test_uptodate(folio)) {=0A=
+		clear_highpage(folio_page(folio, 0));=0A=
+		guestmem_mark_prepared(folio);=0A=
+	}=0A=
+=0A=
+	if (userfaultfd_minor(vmf->vma)) {=0A=
+		folio_unlock(folio);=0A=
+		return handle_userfault(vmf, VM_UFFD_MINOR);=0A=
+	}=0A=
+=0A=
+	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
+=0A=
+out_folio:=0A=
+	if (ret !=3D VM_FAULT_LOCKED) {=0A=
+		folio_unlock(folio);=0A=
+		folio_put(folio);=0A=
+	}=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static const struct vm_operations_struct guestmem_vm_ops =3D {=0A=
+	.fault =3D guestmem_fault_user_mapping,=0A=
+};=0A=
+=0A=
+int guestmem_mmap(struct file *file, struct vm_area_struct *vma)=0A=
+{=0A=
+	struct address_space *mapping =3D file_inode(file)->i_mapping;=0A=
+	struct guestmem *gmem =3D mapping->i_private_data;=0A=
+=0A=
+	if (!gmem->ops->supports_mmap || !gmem->ops->supports_mmap(file_inode(fil=
e)))=0A=
+		return -ENODEV;=0A=
+=0A=
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D=0A=
+	    (VM_SHARED | VM_MAYSHARE)) {=0A=
+		return -EINVAL;=0A=
+	}=0A=
+=0A=
+	vma->vm_ops =3D &guestmem_vm_ops;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(guestmem_mmap);=0A=
+=0A=
+bool guestmem_vma_is_guestmem(struct vm_area_struct *vma)=0A=
+{=0A=
+	struct inode *inode;=0A=
+=0A=
+	if (!vma->vm_file)=0A=
+		return false;=0A=
+=0A=
+	inode =3D file_inode(vma->vm_file);=0A=
+	if (!inode || !inode->i_mapping || !inode->i_mapping->i_private_data)=0A=
+		return false;=0A=
+=0A=
+	return inode->i_mapping->a_ops =3D=3D &guestmem_aops;=0A=
+}=0A=
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig=0A=
index 1b7d5be0b6c4..41e26ad33c1b 100644=0A=
--- a/virt/kvm/Kconfig=0A=
+++ b/virt/kvm/Kconfig=0A=
@@ -114,6 +114,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES=0A=
 =0A=
 config KVM_GUEST_MEMFD=0A=
        select XARRAY_MULTI=0A=
+       select GUESTMEM=0A=
        bool=0A=
 =0A=
 config HAVE_KVM_ARCH_GMEM_PREPARE=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 6989362c056c..15ab13bf6d40 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -1,6 +1,7 @@=0A=
 // SPDX-License-Identifier: GPL-2.0=0A=
 #include <linux/backing-dev.h>=0A=
 #include <linux/falloc.h>=0A=
+#include <linux/guestmem.h>=0A=
 #include <linux/kvm_host.h>=0A=
 #include <linux/pagemap.h>=0A=
 #include <linux/anon_inodes.h>=0A=
@@ -43,26 +44,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, str=
uct kvm_memory_slot *slo=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static bool kvm_gmem_test_no_direct_map(struct inode *inode)=0A=
-{=0A=
-	return ((unsigned long) inode->i_private) & GUEST_MEMFD_FLAG_NO_DIRECT_MA=
P;=0A=
-}=0A=
-=0A=
-static inline int kvm_gmem_mark_prepared(struct folio *folio)=0A=
-{=0A=
-	struct inode *inode =3D folio_inode(folio);=0A=
-	int r =3D 0;=0A=
-=0A=
-	if (kvm_gmem_test_no_direct_map(inode))=0A=
-		r =3D set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(=
folio),=0A=
-						 false);=0A=
-=0A=
-	if (!r)=0A=
-		folio_mark_uptodate(folio);=0A=
-=0A=
-	return r;=0A=
-}=0A=
-=0A=
 /*=0A=
  * Process @folio, which contains @gfn, so that the guest can use it.=0A=
  * The folio must be locked and the gfn must be contained in @slot.=0A=
@@ -98,7 +79,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct=
 kvm_memory_slot *slot,=0A=
 	index =3D ALIGN_DOWN(index, 1 << folio_order(folio));=0A=
 	r =3D __kvm_gmem_prepare_folio(kvm, slot, index, folio);=0A=
 	if (!r)=0A=
-		r =3D kvm_gmem_mark_prepared(folio);=0A=
+		guestmem_mark_prepared(folio);=0A=
 =0A=
 	return r;=0A=
 }=0A=
@@ -114,8 +95,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struc=
t kvm_memory_slot *slot,=0A=
  */=0A=
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index=
)=0A=
 {=0A=
-	/* TODO: Support huge pages. */=0A=
-	return filemap_grab_folio(inode->i_mapping, index);=0A=
+	return guestmem_grab_folio(inode->i_mapping, index);=0A=
 }=0A=
 =0A=
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start=
,=0A=
@@ -167,79 +147,6 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *g=
mem, pgoff_t start,=0A=
 	}=0A=
 }=0A=
 =0A=
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t=
 len)=0A=
-{=0A=
-	struct list_head *gmem_list =3D &inode->i_mapping->i_private_list;=0A=
-	pgoff_t start =3D offset >> PAGE_SHIFT;=0A=
-	pgoff_t end =3D (offset + len) >> PAGE_SHIFT;=0A=
-	struct kvm_gmem *gmem;=0A=
-=0A=
-	/*=0A=
-	 * Bindings must be stable across invalidation to ensure the start+end=0A=
-	 * are balanced.=0A=
-	 */=0A=
-	filemap_invalidate_lock(inode->i_mapping);=0A=
-=0A=
-	list_for_each_entry(gmem, gmem_list, entry)=0A=
-		kvm_gmem_invalidate_begin(gmem, start, end);=0A=
-=0A=
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);=
=0A=
-=0A=
-	list_for_each_entry(gmem, gmem_list, entry)=0A=
-		kvm_gmem_invalidate_end(gmem, start, end);=0A=
-=0A=
-	filemap_invalidate_unlock(inode->i_mapping);=0A=
-=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t l=
en)=0A=
-{=0A=
-	struct address_space *mapping =3D inode->i_mapping;=0A=
-	pgoff_t start, index, end;=0A=
-	int r;=0A=
-=0A=
-	/* Dedicated guest is immutable by default. */=0A=
-	if (offset + len > i_size_read(inode))=0A=
-		return -EINVAL;=0A=
-=0A=
-	filemap_invalidate_lock_shared(mapping);=0A=
-=0A=
-	start =3D offset >> PAGE_SHIFT;=0A=
-	end =3D (offset + len) >> PAGE_SHIFT;=0A=
-=0A=
-	r =3D 0;=0A=
-	for (index =3D start; index < end; ) {=0A=
-		struct folio *folio;=0A=
-=0A=
-		if (signal_pending(current)) {=0A=
-			r =3D -EINTR;=0A=
-			break;=0A=
-		}=0A=
-=0A=
-		folio =3D kvm_gmem_get_folio(inode, index);=0A=
-		if (IS_ERR(folio)) {=0A=
-			r =3D PTR_ERR(folio);=0A=
-			break;=0A=
-		}=0A=
-=0A=
-		index =3D folio_next_index(folio);=0A=
-=0A=
-		folio_unlock(folio);=0A=
-		folio_put(folio);=0A=
-=0A=
-		/* 64-bit only, wrapping the index should be impossible. */=0A=
-		if (WARN_ON_ONCE(!index))=0A=
-			break;=0A=
-=0A=
-		cond_resched();=0A=
-	}=0A=
-=0A=
-	filemap_invalidate_unlock_shared(mapping);=0A=
-=0A=
-	return r;=0A=
-}=0A=
-=0A=
 static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,=
=0A=
 			       loff_t len)=0A=
 {=0A=
@@ -255,9 +162,9 @@ static long kvm_gmem_fallocate(struct file *file, int m=
ode, loff_t offset,=0A=
 		return -EINVAL;=0A=
 =0A=
 	if (mode & FALLOC_FL_PUNCH_HOLE)=0A=
-		ret =3D kvm_gmem_punch_hole(file_inode(file), offset, len);=0A=
+		ret =3D guestmem_punch_hole(file_inode(file)->i_mapping, offset, len);=
=0A=
 	else=0A=
-		ret =3D kvm_gmem_allocate(file_inode(file), offset, len);=0A=
+		ret =3D guestmem_allocate(file_inode(file)->i_mapping, offset, len);=0A=
 =0A=
 	if (!ret)=0A=
 		file_modified(file);=0A=
@@ -299,7 +206,7 @@ static int kvm_gmem_release(struct inode *inode, struct=
 file *file)=0A=
 	kvm_gmem_invalidate_begin(gmem, 0, -1ul);=0A=
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);=0A=
 =0A=
-	list_del(&gmem->entry);=0A=
+	guestmem_detach_mapping(inode->i_mapping, &gmem->entry);=0A=
 =0A=
 	filemap_invalidate_unlock(inode->i_mapping);=0A=
 =0A=
@@ -335,74 +242,8 @@ static bool kvm_gmem_supports_mmap(struct inode *inode=
)=0A=
 	return flags & GUEST_MEMFD_FLAG_MMAP;=0A=
 }=0A=
 =0A=
-static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)=0A=
-{=0A=
-	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
-	struct folio *folio;=0A=
-	vm_fault_t ret =3D VM_FAULT_LOCKED;=0A=
-=0A=
-	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))=0A=
-		return VM_FAULT_SIGBUS;=0A=
-=0A=
-	folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);=0A=
-	if (IS_ERR(folio)) {=0A=
-		int err =3D PTR_ERR(folio);=0A=
-=0A=
-		if (err =3D=3D -EAGAIN)=0A=
-			return VM_FAULT_RETRY;=0A=
-=0A=
-		return vmf_error(err);=0A=
-	}=0A=
-=0A=
-	if (WARN_ON_ONCE(folio_test_large(folio))) {=0A=
-		ret =3D VM_FAULT_SIGBUS;=0A=
-		goto out_folio;=0A=
-	}=0A=
-=0A=
-	if (!folio_test_uptodate(folio)) {=0A=
-		int err =3D 0;=0A=
-=0A=
-		clear_highpage(folio_page(folio, 0));=0A=
-		err =3D kvm_gmem_mark_prepared(folio);=0A=
-=0A=
-		if (err) {=0A=
-			ret =3D vmf_error(err);=0A=
-			goto out_folio;=0A=
-		}=0A=
-	}=0A=
-=0A=
-	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
-=0A=
-out_folio:=0A=
-	if (ret !=3D VM_FAULT_LOCKED) {=0A=
-		folio_unlock(folio);=0A=
-		folio_put(folio);=0A=
-	}=0A=
-=0A=
-	return ret;=0A=
-}=0A=
-=0A=
-static const struct vm_operations_struct kvm_gmem_vm_ops =3D {=0A=
-	.fault =3D kvm_gmem_fault_user_mapping,=0A=
-};=0A=
-=0A=
-static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)=0A=
-{=0A=
-	if (!kvm_gmem_supports_mmap(file_inode(file)))=0A=
-		return -ENODEV;=0A=
-=0A=
-	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D=0A=
-	    (VM_SHARED | VM_MAYSHARE)) {=0A=
-		return -EINVAL;=0A=
-	}=0A=
-=0A=
-	vma->vm_ops =3D &kvm_gmem_vm_ops;=0A=
-=0A=
-	return 0;=0A=
-}=0A=
-=0A=
 static struct file_operations kvm_gmem_fops =3D {=0A=
-	.mmap           =3D kvm_gmem_mmap,=0A=
+	.mmap           =3D guestmem_mmap,=0A=
 	.llseek         =3D default_llseek,=0A=
 	.write_iter     =3D generic_perform_write,=0A=
 	.open		=3D generic_file_open,=0A=
@@ -415,104 +256,24 @@ void kvm_gmem_init(struct module *module)=0A=
 	kvm_gmem_fops.owner =3D module;=0A=
 }=0A=
 =0A=
-static int kvm_kmem_gmem_write_begin(const struct kiocb *kiocb,=0A=
-				     struct address_space *mapping,=0A=
-				     loff_t pos, unsigned int len,=0A=
-				     struct folio **foliop,=0A=
-				     void **fsdata)=0A=
-{=0A=
-	struct file *file =3D kiocb->ki_filp;=0A=
-	pgoff_t index =3D pos >> PAGE_SHIFT;=0A=
-	struct folio *folio;=0A=
-=0A=
-	if (!PAGE_ALIGNED(pos) || len !=3D PAGE_SIZE)=0A=
-		return -EINVAL;=0A=
-=0A=
-	if (pos + len > i_size_read(file_inode(file)))=0A=
-		return -EINVAL;=0A=
-=0A=
-	folio =3D kvm_gmem_get_folio(file_inode(file), index);=0A=
-	if (IS_ERR(folio))=0A=
-		return -EFAULT;=0A=
-=0A=
-	if (WARN_ON_ONCE(folio_test_large(folio))) {=0A=
-		folio_unlock(folio);=0A=
-		folio_put(folio);=0A=
-		return -EFAULT;=0A=
-	}=0A=
-=0A=
-	if (folio_test_uptodate(folio)) {=0A=
-		folio_unlock(folio);=0A=
-		folio_put(folio);=0A=
-		return -ENOSPC;=0A=
-	}=0A=
-=0A=
-	*foliop =3D folio;=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-static int kvm_kmem_gmem_write_end(const struct kiocb *kiocb,=0A=
-				   struct address_space *mapping,=0A=
-				   loff_t pos, unsigned int len,=0A=
-				   unsigned int copied,=0A=
-				   struct folio *folio, void *fsdata)=0A=
+static void kvm_guestmem_invalidate_begin(struct list_head *entry, pgoff_t=
 start,=0A=
+					 pgoff_t end)=0A=
 {=0A=
-	if (copied) {=0A=
-		if (copied < len) {=0A=
-			unsigned int from =3D pos & (PAGE_SIZE - 1);=0A=
-=0A=
-			folio_zero_range(folio, from + copied, len - copied);=0A=
-		}=0A=
-		kvm_gmem_mark_prepared(folio);=0A=
-	}=0A=
-=0A=
-	folio_unlock(folio);=0A=
-	folio_put(folio);=0A=
-=0A=
-	return copied;=0A=
-}=0A=
+	struct kvm_gmem *gmem =3D container_of(entry, struct kvm_gmem, entry);=0A=
 =0A=
-static int kvm_gmem_migrate_folio(struct address_space *mapping,=0A=
-				  struct folio *dst, struct folio *src,=0A=
-				  enum migrate_mode mode)=0A=
-{=0A=
-	WARN_ON_ONCE(1);=0A=
-	return -EINVAL;=0A=
+	kvm_gmem_invalidate_begin(gmem, start, end);=0A=
 }=0A=
 =0A=
-static int kvm_gmem_error_folio(struct address_space *mapping, struct foli=
o *folio)=0A=
+static void kvm_guestmem_invalidate_end(struct list_head *entry, pgoff_t s=
tart,=0A=
+					pgoff_t end)=0A=
 {=0A=
-	struct list_head *gmem_list =3D &mapping->i_private_list;=0A=
-	struct kvm_gmem *gmem;=0A=
-	pgoff_t start, end;=0A=
-=0A=
-	filemap_invalidate_lock_shared(mapping);=0A=
-=0A=
-	start =3D folio->index;=0A=
-	end =3D start + folio_nr_pages(folio);=0A=
-=0A=
-	list_for_each_entry(gmem, gmem_list, entry)=0A=
-		kvm_gmem_invalidate_begin(gmem, start, end);=0A=
+	struct kvm_gmem *gmem =3D container_of(entry, struct kvm_gmem, entry);=0A=
 =0A=
-	/*=0A=
-	 * Do not truncate the range, what action is taken in response to the=0A=
-	 * error is userspace's decision (assuming the architecture supports=0A=
-	 * gracefully handling memory errors).  If/when the guest attempts to=0A=
-	 * access a poisoned page, kvm_gmem_get_pfn() will return -EHWPOISON,=0A=
-	 * at which point KVM can either terminate the VM or propagate the=0A=
-	 * error to userspace.=0A=
-	 */=0A=
-=0A=
-	list_for_each_entry(gmem, gmem_list, entry)=0A=
-		kvm_gmem_invalidate_end(gmem, start, end);=0A=
-=0A=
-	filemap_invalidate_unlock_shared(mapping);=0A=
-=0A=
-	return MF_DELAYED;=0A=
+	kvm_gmem_invalidate_end(gmem, start, end);=0A=
 }=0A=
 =0A=
-static void kvm_gmem_free_folio(struct address_space *mapping,=0A=
-				struct folio *folio)=0A=
+static bool kvm_gmem_release_folio(struct address_space *mapping,=0A=
+				   struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
@@ -525,19 +286,19 @@ static void kvm_gmem_free_folio(struct address_space =
*mapping,=0A=
 	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_mark_prepared=
().=0A=
 	 * Thus set_direct_map_valid_noflush() here only updates prot bits.=0A=
 	 */=0A=
-	if (kvm_gmem_test_no_direct_map(mapping->host))=0A=
+	if (guestmem_test_no_direct_map(mapping->host))=0A=
 		set_direct_map_valid_noflush(page, folio_nr_pages(folio), true);=0A=
 =0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
+=0A=
+	return true;=0A=
 }=0A=
 =0A=
-static const struct address_space_operations kvm_gmem_aops =3D {=0A=
-	.dirty_folio =3D noop_dirty_folio,=0A=
-	.write_begin =3D kvm_kmem_gmem_write_begin,=0A=
-	.write_end =3D kvm_kmem_gmem_write_end,=0A=
-	.migrate_folio	=3D kvm_gmem_migrate_folio,=0A=
-	.error_remove_folio =3D kvm_gmem_error_folio,=0A=
-	.free_folio =3D kvm_gmem_free_folio,=0A=
+static const struct guestmem_ops kvm_guestmem_ops =3D {=0A=
+	.invalidate_begin =3D kvm_guestmem_invalidate_begin,=0A=
+	.invalidate_end =3D kvm_guestmem_invalidate_end,=0A=
+	.release_folio =3D kvm_gmem_release_folio,=0A=
+	.supports_mmap =3D kvm_gmem_supports_mmap,=0A=
 };=0A=
 =0A=
 static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry=
,=0A=
@@ -587,13 +348,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t =
size, u64 flags)=0A=
 =0A=
 	inode->i_private =3D (void *)(unsigned long)flags;=0A=
 	inode->i_op =3D &kvm_gmem_iops;=0A=
-	inode->i_mapping->a_ops =3D &kvm_gmem_aops;=0A=
 	inode->i_mode |=3D S_IFREG;=0A=
 	inode->i_size =3D size;=0A=
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);=0A=
-	mapping_set_inaccessible(inode->i_mapping);=0A=
-	/* Unmovable mappings are supposed to be marked unevictable as well. */=
=0A=
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));=0A=
+	err =3D guestmem_attach_mapping(inode->i_mapping, &kvm_guestmem_ops,=0A=
+				      &gmem->entry);=0A=
+	if (err)=0A=
+		goto err_putfile;=0A=
 =0A=
 	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)=0A=
 		mapping_set_no_direct_map(inode->i_mapping);=0A=
@@ -601,11 +361,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t =
size, u64 flags)=0A=
 	kvm_get_kvm(kvm);=0A=
 	gmem->kvm =3D kvm;=0A=
 	xa_init(&gmem->bindings);=0A=
-	list_add(&gmem->entry, &inode->i_mapping->i_private_list);=0A=
 =0A=
 	fd_install(fd, file);=0A=
 	return fd;=0A=
 =0A=
+err_putfile:=0A=
+	fput(file);=0A=
 err_gmem:=0A=
 	kfree(gmem);=0A=
 err_fd:=0A=
@@ -869,7 +630,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn=
, void __user *src, long=0A=
 		p =3D src ? src + i * PAGE_SIZE : NULL;=0A=
 		ret =3D post_populate(kvm, gfn, pfn, p, max_order, opaque);=0A=
 		if (!ret)=0A=
-			ret =3D kvm_gmem_mark_prepared(folio);=0A=
+			guestmem_mark_prepared(folio);=0A=
 =0A=
 put_folio_and_exit:=0A=
 		folio_put(folio);=0A=
-- =0A=
2.50.1=0A=
=0A=

