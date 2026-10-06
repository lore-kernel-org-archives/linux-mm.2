Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA50CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8106B0095; Tue,  6 Oct 2026 14:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768266B0096; Tue,  6 Oct 2026 14:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631426B0098; Tue,  6 Oct 2026 14:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6CE6B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A1C71A02E3
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:44 +0000 (UTC)
X-FDA: 85293047448.24.B91C88C
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A95740008
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cbnnqiap;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lss7/oAgZrQYIgCLfxnVGXPSE6ZKNx5kDQXlFxiMVks=;
	b=uWosodkZVdpahklFgEiGzyxHzo8hdbeYwGJ/lmsKyDSN7w57mDR6juBWypOmnNOyKXmbON
	kyhETpGCJNEYxROJ20vVobgUsb3lTLrKpXawsk7dkffyEZwE7Ev2gmaA5oPpWzUyhLxPd9
	UgPpoF7iljIic6KrsuUbsxDTcyu0jX8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cbnnqiap;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311562;
	b=S/jtuW2pwpbT2kNsQUVlfpij89Mxt9uWrp55jurL5Uwlhv5JRTNVz+95k+xpwUmJFsmA6b
	P0fWDsGlxsaqmnKQ84Y7G9p+tdps40m4bitYydEnQ93Bm6UjseW67sspxSKUpgFOXJwb5V
	j7ljt2cJWsx+2nsIUVYO3P00Q+gRRmk=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2acc1e170cso149933766b.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311561; x=1791916361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lss7/oAgZrQYIgCLfxnVGXPSE6ZKNx5kDQXlFxiMVks=;
        b=CbnnqiapHEEMQPY3QouJHmMtS01Bk8aSh8YmQ+Rjrja2L3xLkKXQOThQPrxLcYpFgZ
         raXsKT26q6Y0YhHI6gmC0KTXawTk74vwES9k5qbcj+N8O35iAVHV6yMBKl8kEk9hOY5q
         dIjU3oJCWFPyHF2PeUoOYGmOehiJxD1qwRrGroJWNItDL1VRDcOAWdu1US0I50cAcntv
         BqzcQazYOlfSGrPX0/37n0SwuAwLPWtsQQY+xCKzcJNiVO3xjyMluxCKIt+58OgoM7xq
         u26xtczKmsdX0f0Rk03L6blUk0h8wB4dTnbzZ/8ZDnFzGMzCGdsdcz4IKq8n9JCB2oh5
         aG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311561; x=1791916361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lss7/oAgZrQYIgCLfxnVGXPSE6ZKNx5kDQXlFxiMVks=;
        b=UC1M2DED2U69e0o9CM/FviteERFH2kYJCuCF3iETptjtXlH3mM1aBKOLCtzGWUOG+b
         xNSMkzw9TOTizgWMSP2lNQGFktI4cceUOSwwfa0KAe+EE+LepSt7zSqEVmZC5XpkRW2j
         1AGuerp8QreTj8qt4jkM/vmzV5V9L/GcU7c7/XU57YH6lZet4Y+rNEmOx0u9cj0tDsV4
         BPh6qzWojeNO04WkB94X3imtaJwXO26JtVfwsWnlp+FDgDdUGNVIXSHAaXBKamm4VvXm
         5A1HsRWFJ64w1lKvNn3JVed/UKyN+oqTECIn3LOq4HDw5Uw7CSU3+QJzlsRHjbD3TOZZ
         jgfA==
X-Forwarded-Encrypted: i=1; AKwUvBxCHZ2UkletNlb+lVReOK9DNMW2U2MJNTqmR8tTCsEvYSaoudYtOsRfWbU2V5ijdAwx5N+cPD/kNQ==@kvack.org
X-Gm-Message-State: AFuF++nucGW8ttRAXHkZjW+9Rc25ibzZD4cGLV1/GCc/RNzEwfycq4X1
	ms9upQ2Mq9/S+nDIg++kAHrm0fM8rnXrz9pyJczsFzyLb9tT6ErrDzwl
X-Gm-Gg: AYBFou0b6A22rSjABJUHTT5v2Ph0lwsxsCD9wVt8Ny6f5IBINNC0s5mqUUiBBtfDRqe
	GGyCEM7WFjmzPFweeaVipWsbwcuKjICifFt/39AdxaG2qTZ54RnL9KeBvP3Cp7S+n4T4uvN8PT7
	5spTV6t2dVjHVQXZhnduy5FFBykNt7OQuEgyBxrtoDhABwBXFnpCgX6+yi6kccOrr9gicreX7aG
	DEFfaGedqc7fOtc1VSINfG6zVlUnca7SwFa5FwawKj9P5RqB1fbhcFlsNFpbKfWJmzu4P0w0s+1
	889Tdws2/qusdGXXf2JdBA4IDuxWLch0L7cajLnYWUOQuYm6P1MkP94nlUhpfSIacxOIhPdYGEV
	Y/L/xKq4u4nH7qT+Q7V7yzJ3rw3/jso2KmrmrBhbUY4TVBMy1AgtNvboUva4I9GQJW3d7O2pt7K
	DQdcl9todhpTtq6WCdR2/c6dTiolh1vrTyVlvDAV2RW2+UwbNq7h9C6zkoPnx2cTPtzGHo166cX
	G6S+AB8ge6nCHpY/Wzb0b+vPZryATsiE6fjkPnx+f/7672m5HtBH2met/owPrVqenLZ8yLj/cW0
	8eU65HSJ4h9sqShlLQ4AhZN8qeVogOR7G3w=
X-Received: by 2002:a17:907:1b14:b0:c29:f5d8:9c82 with SMTP id a640c23a62f3a-c316a2785aamr229896566b.49.1791311560551;
        Tue, 06 Oct 2026 11:32:40 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:40 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/9] mm: Add memory providers
Date: Tue,  6 Oct 2026 18:32:28 +0000
Message-ID: <20261006183235.16576-3-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j4b3jopiqke8aw66uwwckuj8c89oiezj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A95740008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791311562-267241
X-HE-Meta: U2FsdGVkX1/3SSyqKjUwVsskQmc+sfjriEJYNc0EHGCvcUdnEuwgimUl09NAqJCp3wOTYpSzv8sQ+anqjI0v47M9E0wC9wm7zVe+IX5pVW7sbGLnhEY0Gf5BT7rVkz7KUmAgMFmAiVnlU4OQOVqTLxfQGXOn5+MRXb/5jPe8oH/VA1G/d5yv+MNI4orEy3d7oUBoEDyEFhzA5neIpOAzUmNFk3szG2lhtEzHLviShiQaXLWnU0RcE/cRBZcJlztlPnsEYaUchBxxF/1tJnefbWKC/u25oCwxhPhH2n+wc4S4lNpku/jyUMtvWpVgVmcjlYQgZYtsHY8Oa8947N9PpXLBlEm9Yw2EldGuyg7DJ+KJ6fLYh3AHu1FljspVmzr/OK2+kALFGtjYWbIfNMF07KfV07PeBUtIBxbaY9zQLiZhsLNN8uhBqT1MLQaRGLjsHG10KKg0sxK3hFU+D3sTOVb5vc/90hxRCrZU0y0fMqv7DMJcKhepccwkcQ0g8p8Hht/UTowiyI69ecgF0AR74ejfLXNxGCnOm42G03FyBg60UpLQ4W5wqvYWBYWw3W8Oms+vqJ8BbZgQOh7xkWMSuHeuB8L0PgyB1raz7jCmoAD49JTXHPGFfIqv6+MOQX5602l8U30Vphr91TasgZRwOB940Z+PyXYMwRHqA17i7UpUgjU6COPLzssdPQsVJLbnigHNGHCDwXK6JNrGFYFMjmpaatp9cAaNEu99alFTsn7tZmfm2i6twV0UgA4ZYtpfMYfgVzRq6vc+AhDkc+/ftuER53S8q9RnbzOxgBJOsPjjtE37cFUGKbGxRvDUY0wNl46zGZkDuYXh8dloAxFd+YFSnaS9uoZQ9DN/7wjRw1exiNcsepjk2ZQew1NkT60ELMXvOkBPHvF6BfieFaU83+YjmPupCCg79Qyr74lBlB9Lozw6UuCYAwXRfNVUZ2VNs1I3mxARFa7CLqqa9hD
 ooz3ewYG
 Kfw2e67d155YW0B44wkGR8KfkaG377LyR2yye/sGGUtZSoJwMZVEVRXxG71U0SyXxOmUsW7pq80jaicJWg+qYgsiQAECCzj3meif+AUZ3UPQAHRsen2CeCahc6JIi9ZfSmavSpDWuGZlpqdqW47HFG19BaOXUCN/zmCiSWdcJwnVJnFbI0Co1Fe+wf0U9ULYtT/EHLzXhTqFFJIuL2Yy2aY2o2SGe6bavuIlH1ks0Cj4iaIX/SE5XvWCqWOGGnFtCkMN6b63//Egq2KP3dODHQamGXTQtsJE78P2YV9EhtfE0zKwyvnX2f1pnIAvg3UCgXMl1SEjAiySARenensCm5wfncjHf6phxYxJfKBMkBmzquHWd7ZZk/Eto4KhPuV+mFlzOaIcUUaAEFGYdMTKTBdhx2NLwgpvHHfQizfXB2jjfjoGbCkAZENz2AqQ5J6/iqdHzkzUT+StxBNlrOtNdt80+xA66le+UzoE72fud1WrObSfkxwBXtRGrbQ0437jLSSTCur001zJs8QC3prX70O8iyEvRDDlSG+KyIoG1MOC0Ql4WamJaXcOB3kP3jPGenxJfgxA1UltqfUXIdrB0W90/QeAYWwCWEqaZJIeQCTKbc4AARy1SCQmbwg3a334C5lpW0Ef+DelosT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

A driver that owns memory outside the page allocator, often without
struct page, has no common way to lend it to the code that maps it.
guest_memfd and iommufd each need their own hooks, and the owner must
keep them consistent when it takes memory back.

Add an interface between such an owner, the provider, and its
consumers. A consumer attaches to a provider file, asks for the frame
and attributes behind each page, and makes every mapping itself. When
the provider changes a range, it revokes it, and every consumer of the
file removes its mappings before the revoke returns.

A frame is therefore valid until its revoke returns, and consumers hold
no references. A revoke reaches every consumer of the file, so a
provider cannot take a frame from one consumer while another still maps
it.

A provider is found from its file: its file_operations sit in a struct
mem_provider_fops with the provider's operations, and FOP_MEM_PROVIDER
is set. Each provider file embeds a struct mem_provider_file that holds
its consumers, and the provider revokes through it. The core has no
registry and no global state, and struct file_operations does not grow.

The provider also owns the host memory type of its frames. Memory that
is not System RAM must have its type reserved, or PAT makes it uncached
on x86.

Suggested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 MAINTAINERS                  |   7 ++
 include/linux/fs.h           |   2 +
 include/linux/mem_provider.h | 211 +++++++++++++++++++++++++++++++++++
 mm/Kconfig                   |   7 ++
 mm/Makefile                  |   1 +
 mm/mem_provider.c            | 177 +++++++++++++++++++++++++++++
 6 files changed, 405 insertions(+)
 create mode 100644 include/linux/mem_provider.h
 create mode 100644 mm/mem_provider.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f37a81950e25..6cab075a3ff7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17360,6 +17360,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/uapi/asm-generic/mman-common.h
 F:	mm/madvise.c
 
+MEMORY PROVIDERS
+M:	Fred Griffoul <fgriffo@amazon.co.uk>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/mem_provider.h
+F:	mm/mem_provider.c
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..f459f0e34ca5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1980,6 +1980,8 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* Lends memory to consumers: embedded in a struct mem_provider_fops */
+#define FOP_MEM_PROVIDER	((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
diff --git a/include/linux/mem_provider.h b/include/linux/mem_provider.h
new file mode 100644
index 000000000000..94e9352ebeb0
--- /dev/null
+++ b/include/linux/mem_provider.h
@@ -0,0 +1,211 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEM_PROVIDER_H
+#define _LINUX_MEM_PROVIDER_H
+
+#include <linux/bits.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+
+/*
+ * Memory providers
+ *
+ * A provider owns physical memory that the page allocator does not manage,
+ * and lends it to consumers through files that it hands to userspace.  A
+ * consumer is given such a file, attaches to it, and asks the provider for
+ * the frame behind each page.  The consumer makes every mapping of the
+ * frames itself, including the mappings into userspace; the provider makes
+ * none of them.
+ *
+ * When the frames or attributes behind a range change, the provider revokes
+ * the range.  The core calls every consumer attached to the file, and each
+ * one removes all its mappings of the range before the revoke returns.  A
+ * frame therefore stays valid for a consumer until the revoke that removes
+ * it has returned, and consumers hold no references.
+ *
+ * A consumer must not install a mapping of a frame after the revoke that
+ * removes it has returned.  It either holds a lock across get_page() and
+ * the map that its revoke callback also takes, or detects a revoke that ran
+ * in between and retries, as KVM does with its invalidation sequence.
+ *
+ * A revoke may also change the contents behind the range, for example when
+ * the provider moves a frame from one file to another.  A consumer that
+ * reports the pages written through its mappings, for live migration, must
+ * therefore treat the whole revoked range as written.
+ *
+ * A provider cannot take a frame back from one consumer only: a revoke
+ * reaches every consumer of the file.
+ *
+ * A provider gives its files a struct mem_provider_fops, which holds their
+ * file_operations, with FOP_MEM_PROVIDER and an owner set, and the provider's
+ * operations.  It embeds a struct mem_provider_file in the state of each
+ * file, returns it from attach(), and passes it to mem_provider_revoke().
+ * An attachment holds a reference to the file, so neither the file's state
+ * nor the module can go away while a consumer is attached.  MEM_PROVIDER
+ * has no prompt: a provider selects it, or depends on a consumer that does.
+ */
+
+/*
+ * Memory type of a frame, in the low bits of the attributes.  The provider
+ * makes the host's memory type for its frames match what it reports: for
+ * memory that is not System RAM, it reserves the type of the range, for
+ * example with memremap() or ioremap_wc(), before it hands frames out.  The
+ * architecture otherwise chooses the type of an unknown range, uncached on
+ * x86, and the VMM's mapping of a guest_memfd would differ from the guest's.
+ * On x86 the guest's type also depends on the host: KVM maps a frame uncached
+ * for the guest unless it is RAM in the firmware's E820 map, or a struct-page
+ * frame (DAX, ZONE_DEVICE) that PAT does not force uncached.  So the
+ * reservation matters for the guest too, not only for the VMM's mapping.
+ */
+#define MEM_PROVIDER_ATTR_TYPE		GENMASK(3, 0)
+#define MEM_PROVIDER_TYPE_RAM		0	/* cacheable system memory */
+#define MEM_PROVIDER_TYPE_MMIO		1	/* uncached device memory */
+#define MEM_PROVIDER_TYPE_MMIO_WC	2	/* write-combining device memory */
+						/* 3 to 15 are reserved */
+
+/*
+ * No consumer may map the frame writable: not for a guest, a device or
+ * userspace.
+ */
+#define MEM_PROVIDER_ATTR_READONLY	BIT(4)
+
+/*
+ * No consumer may map the frame into userspace.  Guest and device mappings
+ * are not affected.  The provider decides this for each page.
+ */
+#define MEM_PROVIDER_ATTR_NO_USER_MAP	BIT(5)
+
+#define MEM_PROVIDER_ATTR_VALID		(MEM_PROVIDER_ATTR_TYPE | \
+					 MEM_PROVIDER_ATTR_READONLY | \
+					 MEM_PROVIDER_ATTR_NO_USER_MAP)
+
+static inline unsigned int mem_provider_type(u32 attrs)
+{
+	return attrs & MEM_PROVIDER_ATTR_TYPE;
+}
+
+/*
+ * The provider side of one provider file, embedded in the provider's state
+ * for the file and set up with mem_provider_file_init().  It must stay until
+ * the file is released.  Its fields are private to the core.
+ */
+struct mem_provider_file {
+	struct rw_semaphore lock;
+	struct list_head consumers;
+};
+
+/**
+ * struct mem_provider_ops - What a provider implements.
+ */
+struct mem_provider_ops {
+	/**
+	 * @attach: A consumer starts to use @file.
+	 *
+	 * Called once for each consumer, and possibly for several at once.
+	 *
+	 * @size is the end of the range of the file that the consumer will
+	 * use, from offset 0, as the consumer's user asked for it: the size
+	 * of a guest_memfd, or the end of an iommufd mapping.  Return the
+	 * file's struct mem_provider_file, which is passed to the other
+	 * operations, or an ERR_PTR().  Return ERR_PTR(-EINVAL) if the file
+	 * is smaller than @size, so that the consumer fails the request at
+	 * once.  May sleep.
+	 */
+	struct mem_provider_file *(*attach)(struct file *file, loff_t size);
+
+	/**
+	 * @detach: A consumer is gone.
+	 *
+	 * Called once for each successful attach().  The consumer has removed
+	 * every mapping of the frames, and the core no longer calls its
+	 * revoke callback.  May sleep.
+	 */
+	void (*detach)(struct mem_provider_file *mpf);
+
+	/**
+	 * @get_page: Return the frame behind page @index.
+	 *
+	 * @pfn:       [out] The frame.
+	 * @max_order: [in, out] On entry, the largest order the consumer
+	 *             can use.  On return, the largest order for which the
+	 *             aligned block that contains @index is physically
+	 *             contiguous and has the same attributes.  It must not
+	 *             be larger than on entry.
+	 * @attrs:     [out] MEM_PROVIDER_ATTR_* for the block.
+	 *
+	 * Return 0, -EFAULT if the provider does not back the page now, or
+	 * another negative errno.
+	 *
+	 * May sleep, and may run at the same time as the provider changes
+	 * its state.  A result that is out of date is harmless, because the
+	 * provider revokes the range after the change.  Must not call into
+	 * the consumer, must not call mem_provider_revoke(), and must not take
+	 * a lock that the provider holds across mem_provider_revoke().
+	 */
+	int (*get_page)(struct mem_provider_file *mpf, pgoff_t index,
+			unsigned long *pfn, int *max_order, u32 *attrs);
+};
+
+/*
+ * The file_operations of a provider's files, with FOP_MEM_PROVIDER set in
+ * fops.fop_flags, and the provider's operations.
+ */
+struct mem_provider_fops {
+	struct file_operations fops;
+	const struct mem_provider_ops *ops;
+};
+
+/**
+ * struct mem_provider_attachment - One consumer's attachment to a provider
+ * file.  Embedded in the consumer's object, set by mem_provider_attach() and
+ * owned by the consumer until mem_provider_detach().  @ops must be NULL before
+ * the first mem_provider_attach(), for example by zeroing the attachment, so
+ * that mem_provider_detach() on an attachment that was never made does
+ * nothing.
+ * @ops: The provider's operations.  Read-only to the consumer.
+ * @mpf: The provider's per-file state.  Read-only to the consumer.
+ * @file: The provider file.  Read-only to the consumer.
+ * @size: The end of the range the consumer uses.  Read-only to the consumer.
+ * @revoke: Called when the frames behind a range change; see below.
+ * @node: Private to the core.
+ */
+struct mem_provider_attachment {
+	const struct mem_provider_ops *ops;
+	struct mem_provider_file *mpf;
+	struct file *file;
+	loff_t size;
+
+	/*
+	 * @revoke: The frames behind [@offset, @offset + @len) changed.
+	 *
+	 * The consumer removes every mapping it made of the range and asks
+	 * get_page() again when it next needs a page.  It must not return
+	 * while a mapping of the old frames remains, including one being
+	 * installed from an earlier get_page(): it excludes such a mapping or
+	 * makes it retry.  Revokes of the same file may call this at the same
+	 * time, and may call it before mem_provider_attach() returns.  May
+	 * sleep, and may call get_page().  Must not call
+	 * mem_provider_revoke(), and must not attach or detach any provider.
+	 */
+	void (*revoke)(struct mem_provider_attachment *att, loff_t offset,
+		       loff_t len);
+
+	struct list_head node;
+};
+
+/* Provider side. */
+void mem_provider_file_init(struct mem_provider_file *mpf);
+void mem_provider_revoke(struct mem_provider_file *mpf, loff_t offset,
+			 loff_t len);
+
+/* Consumer side. */
+int mem_provider_attach(struct mem_provider_attachment *att, struct file *file,
+			loff_t size,
+			void (*revoke)(struct mem_provider_attachment *att,
+				       loff_t offset, loff_t len));
+void mem_provider_detach(struct mem_provider_attachment *att);
+int mem_provider_get_page(struct mem_provider_attachment *att, pgoff_t index,
+			  unsigned long *pfn, int *max_order, u32 *attrs);
+
+#endif /* _LINUX_MEM_PROVIDER_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..7085bf6666e5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -774,6 +774,13 @@ config DEFAULT_MMAP_MIN_ADDR
 config ARCH_SUPPORTS_MEMORY_FAILURE
 	bool
 
+config MEM_PROVIDER
+	bool
+	help
+	  An interface that lets a driver lend memory that the page allocator
+	  does not manage to consumers such as guest_memfd and iommufd, and
+	  take it back.  See include/linux/mem_provider.h.
+
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..35420b587f89 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
+obj-$(CONFIG_MEM_PROVIDER) += mem_provider.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_RODATA_TEST) += rodata_test.o
diff --git a/mm/mem_provider.c b/mm/mem_provider.c
new file mode 100644
index 000000000000..5a2984afde10
--- /dev/null
+++ b/mm/mem_provider.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory providers: lend memory that the page allocator does not manage to
+ * consumers that map it.  See include/linux/mem_provider.h.
+ *
+ * Locking: the @lock of a struct mem_provider_file protects its list of
+ * consumers.  mem_provider_revoke() holds it for reading while it calls the
+ * consumers, so a consumer cannot detach until every revoke of its file has
+ * returned.  It follows that a revoke callback must not attach, detach or
+ * revoke, and that a consumer must not detach while it holds a lock that its
+ * revoke callback takes.  A revoke callback may call get_page(), which takes
+ * no lock of the core.
+ */
+#include <linux/export.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mem_provider.h>
+#include <linux/mm.h>
+#include <linux/rwsem.h>
+
+/**
+ * mem_provider_file_init() - Set up the provider side of a provider file.
+ * @mpf: Embedded in the provider's state for the file.
+ */
+void mem_provider_file_init(struct mem_provider_file *mpf)
+{
+	init_rwsem(&mpf->lock);
+	INIT_LIST_HEAD(&mpf->consumers);
+}
+EXPORT_SYMBOL_GPL(mem_provider_file_init);
+
+/**
+ * mem_provider_attach() - Attach a consumer to a provider file.
+ * @att: The consumer's attachment, filled in on success.
+ * @file: A file handed out by a provider.
+ * @size: The end of the range of @file that the consumer will use, in bytes
+ *        from offset 0.  The provider refuses a file that is smaller.
+ * @revoke: Called when the frames behind a range of @file change.
+ *
+ * Holds a reference to @file, and so to the provider's module, until
+ * mem_provider_detach().
+ *
+ * Return: 0, -EINVAL if @size or @revoke is invalid or the provider lacks an
+ * operation, -ENODEV if @file is not a provider file, or the error returned
+ * by the provider.
+ */
+int mem_provider_attach(struct mem_provider_attachment *att, struct file *file,
+			loff_t size,
+			void (*revoke)(struct mem_provider_attachment *att,
+				       loff_t offset, loff_t len))
+{
+	const struct mem_provider_ops *ops;
+	struct mem_provider_file *mpf;
+
+	if (size <= 0 || !revoke)
+		return -EINVAL;
+
+	if (!(file->f_op->fop_flags & FOP_MEM_PROVIDER))
+		return -ENODEV;
+	ops = container_of(file->f_op, struct mem_provider_fops, fops)->ops;
+	if (WARN_ON_ONCE(!ops->attach || !ops->detach || !ops->get_page))
+		return -EINVAL;
+
+	mpf = ops->attach(file, size);
+	if (IS_ERR(mpf))
+		return PTR_ERR(mpf);
+
+	att->ops = ops;
+	att->mpf = mpf;
+	att->file = get_file(file);
+	att->size = size;
+	att->revoke = revoke;
+
+	down_write(&mpf->lock);
+	list_add_tail(&att->node, &mpf->consumers);
+	up_write(&mpf->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mem_provider_attach);
+
+/**
+ * mem_provider_detach() - Detach a consumer from a provider file.
+ * @att: An attachment from mem_provider_attach().
+ *
+ * The consumer must have removed every mapping of the provider's frames.
+ * Waits for revokes of the file that are in progress.  Does nothing if @att
+ * is not attached.
+ */
+void mem_provider_detach(struct mem_provider_attachment *att)
+{
+	struct mem_provider_file *mpf = att->mpf;
+
+	if (!att->ops)
+		return;
+
+	down_write(&mpf->lock);
+	list_del(&att->node);
+	up_write(&mpf->lock);
+
+	att->ops->detach(mpf);
+	fput(att->file);
+
+	att->ops = NULL;
+	att->mpf = NULL;
+	att->file = NULL;
+}
+EXPORT_SYMBOL_GPL(mem_provider_detach);
+
+/**
+ * mem_provider_get_page() - Get the frame behind a page of an attachment.
+ * @att: The attachment.
+ * @index: The page, in units of PAGE_SIZE from offset 0.
+ * @pfn: [out] The frame.
+ * @max_order: [in, out] See &mem_provider_ops.get_page.
+ * @attrs: [out] MEM_PROVIDER_ATTR_* for the frame.
+ *
+ * On return, @max_order is also limited so that the block is aligned in
+ * physical memory.  The frame stays valid until the consumer's revoke
+ * callback for the page has returned.
+ *
+ * Return: 0, -EFAULT if the provider does not back the page now, -EINVAL if
+ * @index is beyond the attachment, -EIO if the provider returned an invalid
+ * result, or another negative errno from the provider.
+ */
+int mem_provider_get_page(struct mem_provider_attachment *att, pgoff_t index,
+			  unsigned long *pfn, int *max_order, u32 *attrs)
+{
+	int order = *max_order;
+	int ret;
+
+	if (index >= DIV_ROUND_UP(att->size, PAGE_SIZE))
+		return -EINVAL;
+
+	*attrs = 0;
+	ret = att->ops->get_page(att->mpf, index, pfn, max_order, attrs);
+	if (ret)
+		return ret;
+
+	if (WARN_ON_ONCE(*max_order < 0 || *max_order > order ||
+			 (*attrs & ~MEM_PROVIDER_ATTR_VALID) ||
+			 mem_provider_type(*attrs) > MEM_PROVIDER_TYPE_MMIO_WC))
+		return -EIO;
+
+	/* A large mapping also needs the first frame of the block aligned. */
+	if (*max_order && ((*pfn ^ index) & ((1UL << *max_order) - 1)))
+		*max_order = __ffs(*pfn ^ index);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mem_provider_get_page);
+
+/**
+ * mem_provider_revoke() - Tell the consumers that frames changed.
+ * @mpf: The provider side of the file.
+ * @offset: The start of the range, in bytes.
+ * @len: The length of the range, in bytes.
+ *
+ * Call this after the provider has changed the frames or attributes behind
+ * the range.  Returns when every consumer of the file has removed its
+ * mappings of the range.  The provider must not hold a lock that its
+ * get_page() takes, because a consumer may call get_page() before it
+ * returns.  May sleep.
+ */
+void mem_provider_revoke(struct mem_provider_file *mpf, loff_t offset,
+			 loff_t len)
+{
+	struct mem_provider_attachment *att;
+
+	might_sleep();
+	if (len <= 0)
+		return;
+
+	down_read(&mpf->lock);
+	list_for_each_entry(att, &mpf->consumers, node)
+		att->revoke(att, offset, len);
+	up_read(&mpf->lock);
+}
+EXPORT_SYMBOL_GPL(mem_provider_revoke);

