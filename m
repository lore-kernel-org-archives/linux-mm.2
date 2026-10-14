Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5F8CC6B1F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA3C6B00BA; Wed, 14 Oct 2026 05:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0336B00BC; Wed, 14 Oct 2026 05:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9721E6B00BD; Wed, 14 Oct 2026 05:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67BFF6B00BA
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFBE2140447
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:53 +0000 (UTC)
X-FDA: 85320730026.12.5503A2C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25E4AC0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OyQDlQ0Q;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7H7ZE/xa2zi3u4fdcWWpstxxHIkVu+ASPHQYzwGB7qE=;
	b=2uMe2cBjm71rQ388Fw/JWTLPjlmZ2IRlbQe5dynfKUkSzasX6enbP2cdqYbAEeI5OF+b9x
	0w1lFzJ8UVdZx9y/yWfd1mfRFEYJ5ZtrcMZv0qTjWrL4wkfQu9eEsT9+DstLbzhcoLSUts
	iaOZPh6OJEKjEdXvqawqb9HVGLWeT4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970672;
	b=z2ODSdh3GIVSqEXBZSqzJdJDy160QqFP4I8Nax9nicOX7yz7hCilAWCdfsUHMYUHdkGKJ2
	Ddb76SIs+rgFDliEndB5w0OvAP0DD9v9ET3sSqhzIgzaZNkbWg6pBd5Q/HyFJeGePd6jlG
	N5fA9QWpgr0etjm0idEs137sgqLaOwY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OyQDlQ0Q;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d05d51553so4535585e9.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970671; x=1792575471; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7H7ZE/xa2zi3u4fdcWWpstxxHIkVu+ASPHQYzwGB7qE=;
        b=OyQDlQ0QkWV2dEAnuvV2jGg7rsPq+7P1fPrH8ljSuB8i/xnu/DjThGppZF1K4w7O5F
         BhfPi5RgETwtb4eZRIyg+orc5obeQZa5JmBFzj767ohEpBOB6N0tV4ecVrMIMmVlKM0d
         etNozlxMy+8QmqgHs97NY6Q+vBCvuLtZuM+9VJgUgSPibhYxHRJ2MoYYqyIpk83yYmlx
         6V6SXPbR6zH9AazobCz05Ni/B2uU86Po1i9MCkPh1Yxt+fsjZxe/dQM/XoJUDps3jndO
         C+xaFpeHutEZjwj+4CJZTMgkI8pj7OnSFw9PyqmVar91y2At5BMr0H1EfNMlqO5XJyHG
         sDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970671; x=1792575471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7H7ZE/xa2zi3u4fdcWWpstxxHIkVu+ASPHQYzwGB7qE=;
        b=GaoeTJNC2TUTy/fN29sGVCSpWXJjB6LZiPo4ddnTq2dro6jk7a5csQJisG56EMK6/F
         CcP6qiESrIwZEhQivZ2o7XTNJls4CP7DGxM5WKGrXMm8Q10IXDrt6WtBeBBq5I/k4TMK
         coQfJndD3BnA0ZRk8PLX59Wvx/jV0Q84JR9UdGjB4coaYLwdgvyuu4lv5UWoll4Xaeoh
         eUskYV6bIsYS37nRSw4T0LNqDvnLrSzuv3GxZ9dK3dFyK7OGGDffrhyfy/UfTZB/EE02
         Pzpabvg2FgwDcfVYCaxiP29JZpAeZJli3y/UHn/30E49XPbKJLaWQVhVEfeqh4R5SZK7
         mimw==
X-Forwarded-Encrypted: i=1; AKwUvBwjoKR8leYdJfe9u/gF9TXHnUmNdcrGVlx7/BWDOM+BC+wYrZKJATKvmXsGLsWFb4FFzNQqchOI4A==@kvack.org
X-Gm-Message-State: AFq9FYIgypG1kyxzpW01ItJVdZxPVIMy5BQ+8VCQbcYsKEXkFTRBo81H
	QpyKuc1niI3gutQKFHA8SBKSzJMwA+18j0EJpL8QXjt+YfaN6pGaMINq
X-Gm-Gg: AYBFou3u1+vZs2LTsSw7j0ZiPyUp3vsC8odUfQBvFjCzFklXdPZsN57A9yBaaUxoGrQ
	jbq+UTLMhL75mHAasprHTiWmzhxPW7b+pxAtI/UEZjIDnbvaPdtLZMAq4Q2VB2xo1u8RGSRJA1e
	BU9NqwttSNPci2isGhPkxCUgvuQ+PZ9A2DVByo9jkwEi+48nn0LB0Gh5FCRtNLP6RHqqP1GBVqm
	2Axymnpj8VCcuK727IQ/WMCqxyCtdzDAdae8ykQQJ2aK3vyS34lxZ0+3zL7Nm78Odicf1SRDcNp
	Wtvm0Kqa3n6DT+cltkx6TgFNQlq1IV/VALCZM/qSZ6rdEok8yuTyJNe8eg+zxuNYiZakxP9Rx+I
	FrYSLIIl07BIgYf3MxuaK/drKW0yQ8ondxtYaWSDUhdJxD/MUWrSBWqqFJNaCBVgCZ3Qs8p2CP+
	YJ2co1xbBbg9PdV5ws9i34P6qlgCQWO8SIyQzfZDI2PF2byaCHL70krnvAtPryR3OOady5SCxTq
	xTI/B7GIKgiHp7UqEnkFfCGQaGwdkFWsVzq+mLqiB/TCyx1XFuTYQxUv7i/qQ7uQwmCI8jSbBhc
	W7XzZHtiQ6EBPYvOkVTp2TNu1J9H2SGMlBA=
X-Received: by 2002:a05:600c:4747:b0:4a1:77db:45d9 with SMTP id 5b1f17b1804b1-4a18e47aa9amr317337615e9.6.1791970670603;
        Wed, 14 Oct 2026 02:37:50 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:50 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
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
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 11/11] KVM: selftests: Test a memory provider shared by KVM and iommufd
Date: Wed, 14 Oct 2026 09:37:33 +0000
Message-ID: <20261014093733.90312-12-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25E4AC0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rfmkmbazuces157atryrh8k937auq1pb
X-HE-Tag: 1791970672-786739
X-HE-Meta: U2FsdGVkX1+mkyLbMNVi8qHMl2FGvD6g1DKIYntRautRXu5PJBlYYR+CYFDeO4SkeLvgC/geVsovwl4zDt8Xw+tV9ddpI3GsbnQ8W5/EVnzlrUCR6GL1F5HYuAdpn/fraIyGDVKvp3ogTX6d22wxhWjGVHbYs2Fm9FV0nGzp42vujeQInI7xKPWFyWHa/jAEwELFkwZun9ebc84lnOlhP3aaK/r6GfCxEWr08vddrDCYatgN1ZLqByAtVi1DT3OJw9UHGzpZXy7FCoGwpm/30UViyNe/HX2hvhrI2EzZXAYRlhcfHql5QEFlmDIg2W/7ZyZSzAOiWdm06VeUEEb3YtVMbBJmAnPk7gqqKqORUUNA4SluFCyv8jXvXFYl6LORn07jXa9sL5XPCXISm4wb+9TYktQngIAFEV8img1tC7D9NNacjP6Q4E3Q72iRexVRUb0A1Wh2AFciTpf63Pc71FiZkeCpCEDJ7Veh9ZhXInXpDRsr5o9aGRSoA0HJk9hTqsoKCisP+qA5DDntcXyKfD8TbBr6Hmg5caIE1TJGTf4H/VlzDzT88qGMIY9XAhG2E7eiFgYEE7mQ0Ql/qJtEWbNd7ulpfCkyatVdPFswaa6Dm/tB9d26X4x4K5k4LvEC4Xt/8HrjvFvJeWx5NczbvMd2UezEEbn4pzfPoZbEay6J028aNZ8g+ruq96UMJPU7EU9iKDhah/yjq1TQieNO+XW0qAyhSjEhNoomIQ+F8L4sFNasfeLYzkBduF3OBGDYv1GwpMaFyunpx4XtQa8BdzNJ97pP/PWSxvK7A85iYfg/GTdhoFEwRHT0CJ0tsxbKAeRhmGx2TV6A5ZFoYz4IEmoswhCxoodosuq2sP6agOR1Nkpaun4SKPHZ12kXfLH2erhQh0bQLnfV2TQBjKL3/dIqjS2H2wVRck1VANl4QQRshTWfXjD9MhpGv0gKYVnq6P8eiaUtxwaq50D65Sq
 FcpHSYzW
 fUY0VsptWh88SefmvVzhKCjT44A4TeagOU0UhtDunNvNnLX4YlAOBzV/IejQ7fmLuglnIInG6y31jnbMuavqp9Qop3N1ecIIdtEkA0HWNF/iBSqkB0o7xFRMnLCgjjqsY4Bx/k6iKbE+gyj56+W/I4cTx3kUdT4qjKce0Tq5JwwcB8B5sY8wRNkfd5wt5olsXfndxevY8lWpaRbsLJP6oivRfajgG5vF0o95sjSh24NzSsMUf8pLqcpGb1jWavVxBTJrXTsG0eqFoUarFKRFL9Dyz6nypJmdZgSjLb3pIIL3CWXUUH6NIrr1/3bVfZxWUsJi/G5Xcvf01eC7c3zjs0f7zWTG2HUFSU8qLe4341lbkFyIzvA+GSjHR2819YbtcTXxAQkETyE6pmRfqR49cX1S9ocRwtf35M3yRZSwTHYtnodSM7v3g6YbnE9dYjupowuZINz/zNzMu/kvpPWZHD89rqruzDrQIvYXT4shlQBWOfaNVUJMZ0+wHD9AOhNgsexYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

Test that guest, host and device mappings of one provider file follow
the provider's changes.

Two VMs get child files of the sample provider, each passed to
guest_memfd and to an iommufd mock domain. The test moves a range
between them, donates and reclaims pages, and makes a page read only.
After each change it checks the guest, a host mapping and the device
mapping. Pages are mapped on the host before a change, so the test
checks that the revoke zaps them.

A third VM, on a child that starts on a 2 MiB boundary, checks that
KVM maps the provider's block with a 2 MiB page, and that donating a
page inside the block takes that mapping away. It skips if the
provider's frames are not aligned.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/mem_provider_test.c     | 653 ++++++++++++++++++
 2 files changed, 654 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/mem_provider_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index d28a057fa6c2..bde312dba7a8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -89,6 +89,7 @@ TEST_GEN_PROGS_x86 += x86/hyperv_tlb_flush
 TEST_GEN_PROGS_x86 += x86/kvm_clock_test
 TEST_GEN_PROGS_x86 += x86/kvm_pv_test
 TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
+TEST_GEN_PROGS_x86 += x86/mem_provider_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
 TEST_GEN_PROGS_x86 += x86/msrs_test
 TEST_GEN_PROGS_x86 += x86/nested_close_kvm_test
diff --git a/tools/testing/selftests/kvm/x86/mem_provider_test.c b/tools/testing/selftests/kvm/x86/mem_provider_test.c
new file mode 100644
index 000000000000..08555dbbfa07
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/mem_provider_test.c
@@ -0,0 +1,653 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mem_provider_test - one memory provider shared by KVM and iommufd.
+ *
+ * A control process and two VMMs, in one process:
+ *
+ *  ctl:  holds /dev/mem_provider_sample, the owner of the memory.  Creates a
+ *        child provider file per VM, moves pages between children, donates
+ *        and reclaims them, and makes them read only.
+ *        Never touches a VM.
+ *  vmm:  holds one child file, one VM and one iommufd IOAS on a mock domain.
+ *        Passes the child file to KVM_CREATE_GUEST_MEMFD and to
+ *        IOMMU_IOAS_MAP_FILE.  Never touches the control device.
+ *
+ * Scenarios:
+ *
+ *  1. Launch:    each guest writes to its memory, the host sees the write,
+ *                and the device mapping covers the pages the child has.
+ *  2. Move:      a range leaves A for B.  A's guest and A's host mapping
+ *                fault on it and A's device loses only that range.  B's
+ *                guest and host read what A wrote, and B's device reaches
+ *                the frame A had.
+ *  3. Donate:    a range leaves A for the root and comes back on reclaim,
+ *                for the guest, the host mapping and the device.
+ *  4. Read only: a guest write to a read-only page exits to the VMM and a
+ *                host write raises SIGBUS; both land once the page is
+ *                writable again.
+ *  5. Window:    a host mapping of the guest_memfd faults after the range it
+ *                covers is donated.
+ *  6. Large:     a third VM, on an aligned child, gets a 2 MiB stage-2
+ *                mapping, which a donation inside the block takes away.
+ *
+ * Requires samples/kvm/mem_provider_sample.ko and CONFIG_IOMMUFD_TEST.
+ */
+#include <fcntl.h>
+#include <errno.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/iommufd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * The iommufd mock domain test interface.  The iommufd selftest helpers
+ * bring their own harness, which does not mix with the KVM selftest library.
+ */
+#include "../../../../../drivers/iommu/iommufd/iommufd_test.h"
+
+/* Mirrors samples/kvm/mem_provider_sample.h */
+#define MPS_FLAG_MMAP_CAPABLE	(1u << 0)
+
+struct mps_new_child { __u32 flags, pad; __u64 offset, len; };
+struct mps_move { __s32 src_fd, dst_fd; __u64 offset, len; };
+struct mps_donate { __s32 fd; __u32 pad; __u64 offset, len; };
+struct mps_ctl_range { __s32 fd; __u32 value; __u64 offset, len; };
+struct mps_stats {
+	__u64 region_offset, region_len, owned_pages, absent_pages, readonly_pages;
+};
+
+#define MPS_NEW_CHILD		_IOW('P', 5, struct mps_new_child)
+#define MPS_MOVE		_IOW('P', 6, struct mps_move)
+#define MPS_DONATE		_IOW('P', 7, struct mps_donate)
+#define MPS_RECLAIM		_IOW('P', 8, struct mps_donate)
+#define MPS_GET_STATS		_IOR('P', 10, struct mps_stats)
+#define MPS_CTL_SET_READONLY	_IOW('P', 11, struct mps_ctl_range)
+
+#define PAGE		0x1000ULL
+#define HPAGE		0x200000ULL		/* 2 MiB */
+#define CHILD_SIZE	0x400000ULL		/* 4 MiB per child */
+#define GPA		(1ULL << 32)		/* each VM maps its child here */
+#define IOVA		(1ULL << 28)		/* inside the mock aperture */
+#define MAGIC_A		0xa11ce000a11ce000ULL
+#define MAGIC_B		0xb0bb0bb0b0bb0bb0ULL
+
+/*
+ * The ranges of A and B in the root overlap on [SHARED_OFF, +SHARED_LEN).
+ * A is created first and has its whole range, B is created second and has
+ * its range without the overlap.  The overlap can then move from A to B.
+ */
+#define A_OFF		0ULL
+#define SHARED_LEN	(4 * PAGE)
+#define B_OFF		(CHILD_SIZE - SHARED_LEN)
+#define SHARED_OFF	B_OFF
+
+/* C, for the large page scenario, starts on a 2 MiB boundary after B. */
+#define C_OFF		((B_OFF + CHILD_SIZE + HPAGE - 1) & ~(HPAGE - 1))
+#define ROOT_SIZE	(C_OFF + CHILD_SIZE)
+
+#define A_SHARED_GPA	(GPA + (SHARED_OFF - A_OFF))
+#define B_SHARED_GPA	(GPA + (SHARED_OFF - B_OFF))
+#define A_SHARED_IOVA	(IOVA + (SHARED_OFF - A_OFF))
+#define B_SHARED_IOVA	(IOVA + (SHARED_OFF - B_OFF))
+
+/* A page of A that never moves. */
+#define RO_OFF		(64 * PAGE)
+#define RO_GPA		(GPA + RO_OFF)
+
+/* Pages of A that are donated and reclaimed. */
+#define DON_OFF		(8 * PAGE)
+#define DON_GPA		(GPA + DON_OFF)
+#define DON_IOVA	(IOVA + DON_OFF)
+
+/* A page that B has from the start. */
+#define B_HOME_OFF	(CHILD_SIZE / 2)
+#define B_HOME_GPA	(GPA + B_HOME_OFF)
+
+struct guest_args {
+	uint64_t write_gpa;	/* 0 to skip */
+	uint64_t write_val;
+	uint64_t read_gpa;	/* 0 to skip; the value goes to GUEST_SYNC */
+};
+
+static void guest_code(struct guest_args *a)
+{
+	if (a->write_gpa)
+		*(volatile uint64_t *)a->write_gpa = a->write_val;
+	if (a->read_gpa)
+		GUEST_SYNC(*(volatile uint64_t *)a->read_gpa);
+	GUEST_DONE();
+}
+
+/* ---- Control process ---------------------------------------------------- */
+
+static int ctl;
+
+static int ctl_new_child(uint64_t off, uint64_t len)
+{
+	struct mps_new_child nc = {
+		.flags = MPS_FLAG_MMAP_CAPABLE,
+		.offset = off, .len = len,
+	};
+	int fd = ioctl(ctl, MPS_NEW_CHILD, &nc);
+
+	TEST_ASSERT(fd >= 0, "NEW_CHILD(%#llx, %#llx) errno=%d",
+		    (unsigned long long)off, (unsigned long long)len, errno);
+	return fd;
+}
+
+static int ctl_move(int src, int dst, uint64_t off, uint64_t len)
+{
+	struct mps_move mv = { .src_fd = src, .dst_fd = dst,
+			       .offset = off, .len = len };
+
+	return ioctl(ctl, MPS_MOVE, &mv) ? -errno : 0;
+}
+
+static void ctl_donate(int fd, uint64_t off, uint64_t len, bool reclaim)
+{
+	struct mps_donate d = { .fd = fd, .offset = off, .len = len };
+
+	TEST_ASSERT(!ioctl(ctl, reclaim ? MPS_RECLAIM : MPS_DONATE, &d),
+		    "%s errno=%d", reclaim ? "RECLAIM" : "DONATE", errno);
+}
+
+static void ctl_readonly(int fd, uint64_t off, bool ro)
+{
+	struct mps_ctl_range cr = { .fd = fd, .value = ro, .offset = off,
+				    .len = PAGE };
+
+	TEST_ASSERT(!ioctl(ctl, MPS_CTL_SET_READONLY, &cr),
+		    "CTL_SET_READONLY errno=%d", errno);
+}
+
+/* ---- VMM ---------------------------------------------------------------- */
+
+struct vmm {
+	const char *name;
+	int child;		/* the provider file */
+	int gmem;		/* the guest_memfd backed by it */
+	int iommufd;
+	uint32_t ioas, stdev, hwpt;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	void *hva;		/* host mapping of the whole guest_memfd */
+	gva_t args_gva;
+};
+
+static void vmm_create(struct vmm *v)
+{
+	v->vm = vm_create_with_one_vcpu(&v->vcpu, guest_code);
+	v->args_gva = vm_alloc_page(v->vm);
+}
+
+static bool vmm_iova_mapped(struct vmm *v, uint64_t iova, uint64_t len,
+			    bool mapped)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_CHECK_MAPPED,
+		.id = v->hwpt,
+		.check_mapped = { .mapped = mapped, .iova = iova,
+				  .length = len },
+	};
+
+	return !ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd);
+}
+
+static uint64_t vmm_iova_phys(struct vmm *v, uint64_t iova)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
+		.id = v->hwpt,
+		.iova_to_phys = { .iova = iova },
+	};
+
+	if (ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd))
+		return 0;
+	return cmd.iova_to_phys.out_phys;
+}
+
+/*
+ * Map the guest_memfd on a 2 MiB boundary: KVM uses large pages only if the
+ * memslot's guest and host addresses are aligned alike.
+ */
+static void *vmm_map_gmem(struct vmm *v)
+{
+	uint8_t *area, *aligned;
+
+	area = mmap(NULL, CHILD_SIZE + HPAGE, PROT_NONE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(area != MAP_FAILED, "%s: mmap(reserve) errno=%d", v->name,
+		    errno);
+	aligned = (uint8_t *)(((uintptr_t)area + HPAGE - 1) & ~(HPAGE - 1));
+	if (aligned > area)
+		munmap(area, aligned - area);
+	munmap(aligned + CHILD_SIZE, area + HPAGE - aligned);
+
+	return mmap(aligned, CHILD_SIZE, PROT_READ | PROT_WRITE,
+		    MAP_SHARED | MAP_FIXED, v->gmem, 0);
+}
+
+/* Give the child file to KVM and to iommufd. */
+static void vmm_attach(struct vmm *v, int child_fd)
+{
+	struct iommu_ioas_alloc alloc = { .size = sizeof(alloc) };
+	struct kvm_create_guest_memfd gm = {
+		.size = CHILD_SIZE,
+		.flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE,
+		.resource_fd = child_fd,
+	};
+	struct iommu_test_cmd mock = {
+		.size = sizeof(mock), .op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	struct iommu_ioas_map_file map = {
+		.size = sizeof(map),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_READABLE |
+			 IOMMU_IOAS_MAP_WRITEABLE,
+		.fd = child_fd, .start = 0, .length = CHILD_SIZE, .iova = IOVA,
+	};
+	int r;
+
+	v->child = child_fd;
+
+	/* KVM: a guest_memfd backed by the child, behind one memslot. */
+	v->gmem = __vm_ioctl(v->vm, KVM_CREATE_GUEST_MEMFD, &gm);
+	TEST_ASSERT(v->gmem >= 0, "%s: KVM_CREATE_GUEST_MEMFD errno=%d",
+		    v->name, errno);
+	v->hva = vmm_map_gmem(v);
+	TEST_ASSERT(v->hva != MAP_FAILED, "%s: mmap(guest_memfd) errno=%d",
+		    v->name, errno);
+	r = __vm_set_user_memory_region2(v->vm, 10, KVM_MEM_GUEST_MEMFD, GPA,
+					 CHILD_SIZE, v->hva, v->gmem, 0);
+	TEST_ASSERT(!r, "%s: SET_USER_MEMORY_REGION2 errno=%d", v->name,
+		    errno);
+	virt_map(v->vm, GPA, GPA, CHILD_SIZE / PAGE);
+
+	/* iommufd: the same child file, in an IOAS on a mock domain. */
+	v->iommufd = open("/dev/iommu", O_RDWR);
+	__TEST_REQUIRE(v->iommufd >= 0, "iommufd unavailable");
+	TEST_ASSERT(!ioctl(v->iommufd, IOMMU_IOAS_ALLOC, &alloc),
+		    "IOAS_ALLOC errno=%d", errno);
+	v->ioas = alloc.out_ioas_id;
+
+	mock.id = v->ioas;
+	__TEST_REQUIRE(!ioctl(v->iommufd, IOMMU_TEST_CMD, &mock),
+		       "no iommufd mock domain (CONFIG_IOMMUFD_TEST?)");
+	v->stdev = mock.mock_domain.out_stdev_id;
+	v->hwpt = mock.mock_domain.out_hwpt_id;
+
+	map.ioas_id = v->ioas;
+	TEST_ASSERT(!ioctl(v->iommufd, IOMMU_IOAS_MAP_FILE, &map),
+		    "%s: IOAS_MAP_FILE(provider) errno=%d", v->name, errno);
+}
+
+/*
+ * Continue the guest.  KVM_RUN fails with EFAULT for KVM_EXIT_MEMORY_FAULT,
+ * which several scenarios expect; the expect_*() helpers check the exit.
+ */
+static void vmm_resume(struct vmm *v)
+{
+	int r = _vcpu_run(v->vcpu);
+
+	TEST_ASSERT(!r || (errno == EFAULT &&
+			   v->vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT),
+		    "%s: KVM_RUN r=%d errno=%d exit=%s", v->name, r, errno,
+		    exit_reason_str(v->vcpu->run->exit_reason));
+}
+
+static void vmm_run(struct vmm *v, uint64_t write_gpa, uint64_t write_val,
+		    uint64_t read_gpa)
+{
+	struct guest_args *a = addr_gva2hva(v->vm, v->args_gva);
+
+	a->write_gpa = write_gpa;
+	a->write_val = write_val;
+	a->read_gpa = read_gpa;
+	vcpu_arch_set_entry_point(v->vcpu, guest_code);
+	vcpu_args_set(v->vcpu, 1, v->args_gva);
+	vmm_resume(v);
+}
+
+static void expect_done(struct vmm *v)
+{
+	struct kvm_run *run = v->vcpu->run;
+	struct ucall uc;
+
+	TEST_ASSERT(run->exit_reason != KVM_EXIT_MEMORY_FAULT,
+		    "%s: unexpected memory fault at gpa %#llx", v->name,
+		    (unsigned long long)run->memory_fault.gpa);
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_DONE, "%s: guest exit %s",
+		    v->name, exit_reason_str(run->exit_reason));
+}
+
+static uint64_t expect_sync_then_done(struct vmm *v)
+{
+	struct ucall uc;
+	uint64_t val;
+
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_SYNC, "%s: guest exit %s",
+		    v->name, exit_reason_str(v->vcpu->run->exit_reason));
+	val = uc.args[1];
+	vmm_resume(v);
+	expect_done(v);
+	return val;
+}
+
+static void expect_memory_fault(struct vmm *v, uint64_t gpa)
+{
+	struct kvm_run *run = v->vcpu->run;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+		    "%s: want KVM_EXIT_MEMORY_FAULT, got %s", v->name,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->memory_fault.gpa == gpa,
+		    "%s: fault at gpa %#llx, want %#llx", v->name,
+		    (unsigned long long)run->memory_fault.gpa,
+		    (unsigned long long)gpa);
+}
+
+static void vmm_stats(struct vmm *v, struct mps_stats *st)
+{
+	TEST_ASSERT(!ioctl(v->child, MPS_GET_STATS, st),
+		    "%s: GET_STATS errno=%d", v->name, errno);
+}
+
+static void vmm_destroy(struct vmm *v)
+{
+	close(v->iommufd);
+	kvm_vm_free(v->vm);
+	munmap(v->hva, CHILD_SIZE);
+	close(v->gmem);
+	close(v->child);
+}
+
+static sigjmp_buf host_jmp;
+
+static void host_sig(int sig)
+{
+	siglongjmp(host_jmp, sig);
+}
+
+/*
+ * Read @addr, or write @val to it, through a host mapping.  Return the
+ * signal that the access raised, or 0.
+ */
+static int host_access(volatile uint64_t *addr, bool write, uint64_t val)
+{
+	struct sigaction sa = { .sa_handler = host_sig }, old_bus, old_segv;
+	int sig;
+
+	sigaction(SIGBUS, &sa, &old_bus);
+	sigaction(SIGSEGV, &sa, &old_segv);
+	sig = sigsetjmp(host_jmp, 1);
+	if (!sig) {
+		if (write)
+			*addr = val;
+		else
+			(void)*addr;
+	}
+	sigaction(SIGBUS, &old_bus, NULL);
+	sigaction(SIGSEGV, &old_segv, NULL);
+	return sig;
+}
+
+#define host_read_faults(p)	(host_access(p, false, 0) == SIGBUS)
+#define host_write_faults(p, v)	(host_access(p, true, v) == SIGBUS)
+
+/* ---- Scenarios ---------------------------------------------------------- */
+
+static void scenario_launch(struct vmm *a, struct vmm *b)
+{
+	pr_info("1. launch\n");
+	vmm_run(a, GPA, MAGIC_A, 0);
+	expect_done(a);
+	vmm_run(b, B_HOME_GPA, MAGIC_B, 0);
+	expect_done(b);
+	TEST_ASSERT(*(volatile uint64_t *)a->hva == MAGIC_A,
+		    "A: the guest write is not visible to the host");
+	TEST_ASSERT(*(volatile uint64_t *)(b->hva + B_HOME_OFF) == MAGIC_B,
+		    "B: the guest write is not visible to the host");
+
+	/* A has its whole range; B lacks the shared window. */
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA, CHILD_SIZE, true),
+		    "A: device mapping incomplete");
+	TEST_ASSERT(vmm_iova_mapped(b, B_SHARED_IOVA, SHARED_LEN, false),
+		    "B: device maps a window that B does not have");
+	TEST_ASSERT(vmm_iova_mapped(b, B_SHARED_IOVA + SHARED_LEN,
+				    CHILD_SIZE - SHARED_LEN, true),
+		    "B: device mapping incomplete");
+}
+
+static void scenario_move(struct vmm *a, struct vmm *b)
+{
+	struct mps_stats st;
+	uint64_t frame;
+	int r;
+
+	pr_info("2. move A -> B\n");
+	vmm_run(a, A_SHARED_GPA, MAGIC_A, 0);
+	expect_done(a);
+	frame = vmm_iova_phys(a, A_SHARED_IOVA);
+	TEST_ASSERT(frame, "A: window not mapped before the move");
+	/* Map the window on the host too, so that the move must zap it. */
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + SHARED_OFF - A_OFF) ==
+		    MAGIC_A, "A: host mapping does not see the guest write");
+
+	/* B does not have the window yet. */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	expect_memory_fault(b, B_SHARED_GPA);
+
+	/* A move outside the destination's range is refused. */
+	r = ctl_move(a->child, b->child, RO_OFF, PAGE);
+	TEST_ASSERT(r == -EINVAL, "MOVE outside B's range returned %d", r);
+
+	r = ctl_move(a->child, b->child, SHARED_OFF, SHARED_LEN);
+	TEST_ASSERT(!r, "MOVE returned %d", r);
+
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE,
+		    "A has %llu pages after the move",
+		    (unsigned long long)st.owned_pages);
+	vmm_stats(b, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE,
+		    "B has %llu pages after the move",
+		    (unsigned long long)st.owned_pages);
+
+	/* A's device lost the window and only the window. */
+	TEST_ASSERT(vmm_iova_mapped(a, A_SHARED_IOVA, SHARED_LEN, false),
+		    "A: moved window still mapped");
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA, CHILD_SIZE - SHARED_LEN, true),
+		    "A: the rest of the mapping went too");
+
+	/* A's guest and A's host mapping fault on the window. */
+	vmm_run(a, 0, 0, A_SHARED_GPA);
+	expect_memory_fault(a, A_SHARED_GPA);
+	TEST_ASSERT(host_read_faults(a->hva + SHARED_OFF - A_OFF),
+		    "A: host mapping of the moved window still readable");
+
+	/* B reads what A wrote, and B's device reaches A's frame. */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	TEST_ASSERT(expect_sync_then_done(b) == MAGIC_A,
+		    "B does not see A's write");
+	TEST_ASSERT(*(volatile uint64_t *)(b->hva + SHARED_OFF - B_OFF) ==
+		    MAGIC_A, "B: host mapping does not see A's write");
+	TEST_ASSERT(vmm_iova_phys(b, B_SHARED_IOVA) == frame,
+		    "B: window is not on the frame A had");
+}
+
+static void scenario_donate(struct vmm *a)
+{
+	struct mps_stats st;
+
+	pr_info("3. donate and reclaim\n");
+	/* Map the page on the host, so that the donation must zap it. */
+	TEST_ASSERT(!host_access(a->hva + DON_OFF, false, 0),
+		    "A: host mapping faults before the donation");
+	ctl_donate(a->child, DON_OFF, 2 * PAGE, false);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE - 2,
+		    "A has %llu pages after the donation",
+		    (unsigned long long)st.owned_pages);
+	TEST_ASSERT(vmm_iova_mapped(a, DON_IOVA, 2 * PAGE, false),
+		    "A: donated pages still mapped for the device");
+	TEST_ASSERT(host_read_faults(a->hva + DON_OFF),
+		    "A: host mapping of a donated page still readable");
+	vmm_run(a, 0, 0, DON_GPA);
+	expect_memory_fault(a, DON_GPA);
+
+	ctl_donate(a->child, DON_OFF, 2 * PAGE, true);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == (CHILD_SIZE - SHARED_LEN) / PAGE,
+		    "A has %llu pages after the reclaim",
+		    (unsigned long long)st.owned_pages);
+	TEST_ASSERT(vmm_iova_mapped(a, DON_IOVA, 2 * PAGE, true),
+		    "A: reclaimed pages not mapped again for the device");
+	TEST_ASSERT(!host_access(a->hva + DON_OFF, false, 0),
+		    "A: host mapping of a reclaimed page faults");
+	vmm_run(a, 0, 0, DON_GPA);
+	expect_sync_then_done(a);
+}
+
+static void scenario_readonly(struct vmm *a)
+{
+	volatile uint64_t *page = (volatile uint64_t *)(a->hva + RO_OFF);
+
+	pr_info("4. read only\n");
+	*page = MAGIC_B;
+
+	ctl_readonly(a->child, RO_OFF, true);
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA + RO_OFF, PAGE, true),
+		    "A: read-only page not mapped for the device");
+
+	vmm_run(a, RO_GPA, MAGIC_A, 0);
+	expect_memory_fault(a, RO_GPA);
+	TEST_ASSERT(host_write_faults(page, MAGIC_A),
+		    "A: host write to a read-only page did not fault");
+	TEST_ASSERT(*page == MAGIC_B, "write to a read-only page landed");
+
+	/* Clear the bit; the guest retries the same write. */
+	ctl_readonly(a->child, RO_OFF, false);
+	vmm_resume(a);
+	expect_done(a);
+	TEST_ASSERT(*page == MAGIC_A, "write after clearing read only lost");
+	TEST_ASSERT(!host_write_faults(page, MAGIC_B),
+		    "A: host write after clearing read only faulted");
+	TEST_ASSERT(*page == MAGIC_B, "host write after clearing read only lost");
+}
+
+static void scenario_window(struct vmm *a)
+{
+	volatile uint64_t *win;
+
+	pr_info("5. host mapping\n");
+	win = mmap(NULL, PAGE, PROT_READ | PROT_WRITE, MAP_SHARED, a->gmem,
+		   DON_OFF);
+	TEST_ASSERT(win != MAP_FAILED, "mmap(guest_memfd, page) errno=%d",
+		    errno);
+	*win = MAGIC_A;
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + DON_OFF) == MAGIC_A,
+		    "the two host mappings disagree");
+
+	ctl_donate(a->child, DON_OFF, PAGE, false);
+
+	TEST_ASSERT(host_read_faults(win),
+		    "host mapping still readable after the donation");
+
+	ctl_donate(a->child, DON_OFF, PAGE, true);
+	TEST_ASSERT(*win == MAGIC_A, "host mapping did not come back");
+	munmap((void *)win, PAGE);
+}
+
+static void scenario_large(void)
+{
+	struct vmm c = { .name = "C" };
+	uint64_t before, after;
+
+	pr_info("6. large pages\n");
+	vmm_create(&c);
+	vmm_attach(&c, ctl_new_child(C_OFF, CHILD_SIZE));
+
+	/* The provider's blocks are aligned only if its frames are. */
+	if (vmm_iova_phys(&c, IOVA) & (HPAGE - 1)) {
+		pr_info("   skipped: the child's frames are not 2 MiB aligned\n");
+		vmm_destroy(&c);
+		return;
+	}
+
+	/* Fault in the guest's code and stack first, then count. */
+	vmm_run(&c, 0, 0, 0);
+	expect_done(&c);
+	before = vm_get_stat(c.vm, pages_2m);
+
+	vmm_run(&c, GPA, MAGIC_A, 0);
+	expect_done(&c);
+	after = vm_get_stat(c.vm, pages_2m);
+	TEST_ASSERT(after == before + 1,
+		    "C: %llu 2 MiB mappings, want %llu",
+		    (unsigned long long)after,
+		    (unsigned long long)before + 1);
+
+	/* A donation inside the block takes the large mapping away. */
+	ctl_donate(c.child, C_OFF + DON_OFF, PAGE, false);
+	TEST_ASSERT(vm_get_stat(c.vm, pages_2m) == before,
+		    "C: the 2 MiB mapping survived a donation inside it");
+	vmm_run(&c, 0, 0, GPA);
+	TEST_ASSERT(expect_sync_then_done(&c) == MAGIC_A,
+		    "C: the rest of the block lost the guest write");
+	TEST_ASSERT(vm_get_stat(c.vm, pages_2m) == before,
+		    "C: a 2 MiB mapping over a block with a hole");
+	vmm_run(&c, 0, 0, DON_GPA);
+	expect_memory_fault(&c, DON_GPA);
+
+	vmm_destroy(&c);
+}
+
+int main(void)
+{
+	struct vmm a = { .name = "A" }, b = { .name = "B" };
+	struct mps_new_child probe = { .offset = ROOT_SIZE - PAGE, .len = PAGE };
+	int fd;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS) &
+		     GUEST_MEMFD_FLAG_USE_RESOURCE);
+
+	ctl = open("/dev/mem_provider_sample", O_RDWR);
+	__TEST_REQUIRE(ctl >= 0, "mem_provider_sample not loaded");
+
+	/*
+	 * Without addr= and len=, the first NEW_CHILD sizes the root, so ask
+	 * for its last page first and give it back.  A fixed root that is too
+	 * small makes the test skip.
+	 */
+	fd = ioctl(ctl, MPS_NEW_CHILD, &probe);
+	__TEST_REQUIRE(fd >= 0, "provider root smaller than %#llx bytes",
+		       (unsigned long long)ROOT_SIZE);
+	close(fd);
+
+	vmm_create(&a);
+	vmm_create(&b);
+	vmm_attach(&a, ctl_new_child(A_OFF, CHILD_SIZE));
+	vmm_attach(&b, ctl_new_child(B_OFF, CHILD_SIZE));
+
+	scenario_launch(&a, &b);
+	scenario_move(&a, &b);
+	scenario_donate(&a);
+	scenario_readonly(&a);
+	scenario_window(&a);
+
+	vmm_destroy(&a);
+	vmm_destroy(&b);
+	scenario_large();
+	close(ctl);
+	pr_info("mem_provider: all scenarios passed\n");
+	return 0;
+}
-- 
2.47.3


