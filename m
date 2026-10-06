Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E169FCA5FFF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0476B009F; Tue,  6 Oct 2026 14:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7689C6B00A0; Tue,  6 Oct 2026 14:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60AEE6B00A1; Tue,  6 Oct 2026 14:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3443A6B009F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0A3B1602E2
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:54 +0000 (UTC)
X-FDA: 85293047868.11.C173863
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3F8C1C0007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LfowGpYI;
	spf=pass (imf18.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrJHg4EcIiUcrJStP3IT7dLBVIoFsRs5h14JomE41+A=;
	b=gR/MMASH2oUF80JNTN2f78Y5uyVELiB3loCTUEcuhkqQ6Gr+vT9m1LYJ0+u8jwC1UAVnix
	r+7HgeJDkLVinx7EHwJUzq296ejRO93hphGh9fG1UBLW8LTMK16E2Z0tIYzxkhD3wSFc5a
	5XGOlP0dEpOsA0LVZJ2FwtG7S/VuHGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311572;
	b=G2GBFHzD25CDJB7/58m8wlOB0s3IiWHjUDQT79Z0UjIQjzEBV5TjjHa+yBS7DoArKxnkYd
	QQE1RnEHhqNGXrRHINz6rbMzy4IstVZbUj6GbqwdMxVyivTKpS3GeG0cHgf4FtR4GRzD7P
	8mMnelAPh+gRsE9UmZX6SdKxLGJb9mo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LfowGpYI;
	spf=pass (imf18.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2a832c6554so146048666b.2
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311571; x=1791916371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mrJHg4EcIiUcrJStP3IT7dLBVIoFsRs5h14JomE41+A=;
        b=LfowGpYI0qF5QVQMT09AMvWoZhOtbnyQ4U+8CsfTpxhokyENfGTsLvNyMTH/u+saQ3
         FONkcXOcuUSiG/JaWZyyl8HrEIC4Vy3jsHDQ057qYF8I06YTwiJXRxyg4y1RFq0P344c
         0KEqmg+C0QkcZmILxbIwrFgxva0ioqrttT6RRo4rHKPYph/Yi4q5cg1hHGC6b4/THNYV
         jFYkMs6DB+NZGtI+lpYCqY5KMHz5a5FohDho/vbczzO6DfwsOVU/3gW/vQpnhrMSp0dG
         94YWZ1q5cd9hHZrRzOxuvsmgx4nIxsi+yhfiSUuMIc2DdjWz8IsPXEku3p1Sb2OY+Pyu
         qlxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311571; x=1791916371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mrJHg4EcIiUcrJStP3IT7dLBVIoFsRs5h14JomE41+A=;
        b=mkR0QarYxHtJAqI4bT3O12ZZ/iNjWxOc2d/OsQfgtfxYjhG+NduW8PO7V/KA1L+OES
         LWgAE0ykUJqdUMhKZR4tUSR9A1RrdIU/hRCHdWaAC0HvWy4Na4dRvGePiRNk1YsXzmfJ
         ezV9UxS8fGpuyytUs5wsiEYPHEBggSo/zcvcHa00UYIpkyxWXbUXHy6AGid2411WACeV
         kafUt8Yp1ULlST0fjpgf/LJslYPAaZ/KoLQW3DRsuF8WCRkiM0hMVfd6VzR3T5TrCgqQ
         xa+hWmdy2xpWQ+onfRNZK/REh8YhhDAgMLv+HoJ7GvngsPSVIMhCZA0VicXtu95xgjqE
         dB8Q==
X-Forwarded-Encrypted: i=1; AKwUvBwrQku+uy2agqJdagUn2J0aDw0wz+mb02irZXK6lXJ9dayfDgtEAwzW9NwjtoDRqx/eU9nkYvhXmg==@kvack.org
X-Gm-Message-State: AFuF++mS29Ku9kf9xrLqFKPe7/eo+qZPqrqLZze739ACDioYOGlHOtir
	CK1Zly+GQYwB8jaaD1VfX4kcwtuI2cIvousGqA25coXe2+z181gr+CXx
X-Gm-Gg: AYBFou339nJE26qxiEzS2icjQh+80Riu3INZhjBxhr2m1m8TMZjDVzELaqKed4I+DuW
	80yOYrTAx1Ml8VLQtohlR95bGmDLXBr5l8pWu2lBbopPkJUnk78hP99O12XI0SRrSyjPVK245Yp
	VnuUI7c5b13+aQtIeZKbvV5kpJlLpDIAF5h3jFpL5IYZcfGFm8TTYLm+7rWQKTXmvqo2VMz/ZnK
	wUGZM3AXGSi1VgSSSGGy3WUu2uOlnTysgXfwfKQyAUvaD40FWJbcU2zIh+gwwbvFgY9LwhJ7vxE
	FFZv6YWrxYdrcOt1WWEdIzxlipHQobXwrdHlJAsNo3hfSaGa+VnoXTFtiw+w6Cd82ZA538eUPin
	zf1NC05MApe+X4u/fA1g08Bpkd/9zZ20KM2MT3aSbM4myPlO0QBUhrXckRFyFvVETxMZspFrAcL
	s1XuRiwBp1RHnT2rmmSnUi8JqhQa6wKxyvKseLhlsKNjLMMU2MToQ5QpXgfkEveNpaMusRxD21V
	7AP//Xxs6/5lEfD6C9YNJ2wN7cBIF8J6pdnAOpk8s9iKsJp3sQqs4poMZKXoZCpln9n6hsioQdl
	6wMklpq+5X0FhtHqpT4kWMAangqLQDfHfd4=
X-Received: by 2002:a17:907:3fa3:b0:c31:5e99:6961 with SMTP id a640c23a62f3a-c316a0cd86dmr245698366b.42.1791311571180;
        Tue, 06 Oct 2026 11:32:51 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:50 -0700 (PDT)
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
Subject: [PATCH 9/9] KVM: selftests: Test a memory provider shared by KVM and iommufd
Date: Tue,  6 Oct 2026 18:32:35 +0000
Message-ID: <20261006183235.16576-10-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3F8C1C0007
X-Rspam-User: 
X-Stat-Signature: cdcg5jw98amdzk6ppx4d3xtdsrwytwsk
X-HE-Tag: 1791311572-594363
X-HE-Meta: U2FsdGVkX1927P3jCKfEPkZh5IplFwJa3gGRifVTZYYVFon7ZAiPu8Ueg1oAkmw7v93XQyUHsGeHZj1KukRrKfBMviP7oymGfV5O0YAJNwTUogPtqv565g69s/E8QnRWs4xoMAYk3+lq4aYB0QVr8uwjJhKyr+QWis1Eg9d6H6Plh2/Ggvpxxlpfb5gkAwJaDKNy3BIElqjGfzPdRvSG82zWf0NT66ahT1nRwCsoBwhHPfVTTNluiQ2Gvoo5RF14XY/ugDMPDyg+X2bAZtu9/KY9Ycpduq/tVnqj45mdo8KGa85NtyEmT0NCC6bkqGTTZiMpPEdDh0m667Aw3PhsVPyy4xXr/cFuRQpimNXIFiXajKKYjnBTq8TmGvnR1baHbaKlExE3kN44RFAEiuMoilzo1F653o+/cMBYD/hBZq4gkXP78X0gdvr3yHNHHs5B54oerIzVfdM4bV0R4smJyWYULZcvZPSkr2is4m1Kn8iLr/0mRNuGWpdrhcTqY5hQhEbpaLieJShtDorJIPthjANESrvq5BlC7+8DlI5Bf2WOa0wvVk54O4VXgRgDU90eMPpXghKQ4dHwSAR6UJS1smTFYeAa870s92Hd6uLwsr8mr4c4eToR69N/ifUGYNdX27araDiS5UDrKLdoDtyLkOWP0L1GHFj7SLDebBWRoza6J1Q9dL6Y5IdoZSsHwhfJ3pJzjvxEqSoFixtx8uWsDQcpxnA9eLSEJcy9ViaxPBCw266ZrJ304Ek22nimQbI5zDFlFIbs2M4JMA4YsLgGt0/lsIWnMtue6ZRFIsWCoZ/uCP34OIa6WA9NjSLAdLkSFDrce1TGNPRjVJ6oV7DmdR6HcStqqkO2cLbVX3259pdZ3f/4WXuZy7uWln9vG/Z5tsXzg78AU+KSbtuLl0kNhTpqNVdLor8KoBgGfeNTLH1zdGqfLjcX4bwp8H/AyBMGSjp0fYRv6SkFfW6uoZ6
 5o/FbmlU
 bDrjy/Lu6NWKTX8gITmnBc8z3Q/G79DggA72GbRIhKsJ/A7mY/WsMWv+0SrxIKobzPfumQwgJGWMXrZS+NhibqBOFaK1NsczFus2gPtFTVIK1snC3ASqhecIGgbj3WPtQfmoFFwSp+PUT91G9Px/+OHQu0j9OKKPNPir+LWr72hE92Oj068ynpg0wlY3k1Zuij2g7wfMJliwaUP4mTwIwNagMhFlbN5oVbJZj7ijUdePa9mjH1xc8cFdryuc8TS698+zhEEz5eu9ukfVQ4+ictNbnS2imPOiW8+5gR7FmceWLHlRz03ikfEVKTR3pHHVsaXh4FsnI/yjHpF70GZhtkbZaoi+XxWw5rTSmRKtLmefx0sJyfDEDTO5kvHSUS1dmRJiNn/L+Waf5M0JdByCcZNHb72E18PXTjYMyvZl0UKRcltZzGW6Wl/BSvI20zabBj2ER/6jNLgoQqBRVvR09itGS7zdQQuHBsBRZPjE7ABVsHRN45SCsUVlEhwxsron8xCT/
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

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/mem_provider_test.c     | 582 ++++++++++++++++++
 2 files changed, 583 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/mem_provider_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4d7082448cea..ccee373b4c13 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -84,6 +84,7 @@ TEST_GEN_PROGS_x86 += x86/gmem_provider_revoke_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_readonly_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_iommufd_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_vfio_test
+TEST_GEN_PROGS_x86 += x86/mem_provider_test
 TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
 TEST_GEN_PROGS_x86 += x86/hyperv_clock
 TEST_GEN_PROGS_x86 += x86/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/x86/mem_provider_test.c b/tools/testing/selftests/kvm/x86/mem_provider_test.c
new file mode 100644
index 000000000000..bd7ae44f05d7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/mem_provider_test.c
@@ -0,0 +1,582 @@
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
+#define ROOT_SIZE	(B_OFF + CHILD_SIZE)
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
+/* Give the child file to KVM and to iommufd. */
+static void vmm_attach(struct vmm *v, int child_fd)
+{
+	struct iommu_ioas_alloc alloc = { .size = sizeof(alloc) };
+	struct kvm_create_guest_memfd gm = {
+		.size = CHILD_SIZE,
+		.flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_PROVIDER,
+		.provider_fd = child_fd,
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
+	v->hva = mmap(NULL, CHILD_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+		      v->gmem, 0);
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
+int main(void)
+{
+	struct vmm a = { .name = "A" }, b = { .name = "B" };
+	struct mps_new_child probe = { .offset = ROOT_SIZE - PAGE, .len = PAGE };
+	int fd;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS) &
+		     GUEST_MEMFD_FLAG_USE_PROVIDER);
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
+	close(ctl);
+	pr_info("mem_provider: all scenarios passed\n");
+	return 0;
+}

