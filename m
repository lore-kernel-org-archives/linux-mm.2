Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3549D606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vGEoEdY1
Received: by kanga.kvack.org (Postfix)
	id 380786B07ED; Tue, 27 Oct 2026 11:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A776B07EE; Tue, 27 Oct 2026 11:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E4A6B07F0; Tue, 27 Oct 2026 11:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D07266B07ED
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CFEE1C4460
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:21 +0000 (UTC)
X-FDA: 85368835482.07.B09AFCA
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57AB84000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vGEoEdY1;
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116039;
	b=1pcyxA8GFos1tjtYSIXX8yzIJWuOCSLR6DhmPqAgbcgyJfg/CryjVbAHSZH+oa3jvkd5gn
	sA7TC44SEC+UdvBUKZ+nx4v0f/yNzGT6fn96330Vz3Ichivgd4nqKujBPx7G2A7UQ4gSTy
	oobsRq1zMjkwmcJ14xWwLIq21NURawg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vGEoEdY1;
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4B5d9m5IGzIPEeB3GJQ3GiQrHdJ7xnPhjgrZIgnZaI8=;
	b=bt630mWZGMS4hu2DEGFV2Bbxs07EYiUJ82faE61BuQcJTm/Ylv4PZ18JxF2Xw09RHFGAU0
	DwKK+ZkE/xGEY3KblU5ilxxyXL2IUnx0N24A6Arh21R2ygtjkJ2BrHfOSMoFtfya18zHup
	yHnLyX/1AdXf/w8D63NdIt3g50J6msM=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso2651771f8f.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116038; x=1793720838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4B5d9m5IGzIPEeB3GJQ3GiQrHdJ7xnPhjgrZIgnZaI8=;
        b=vGEoEdY1JDn2fBwb9NlAHUyoeN/RG16TZ37CddqXZ563kIgpHrTQsw5WfMDg62b6m6
         Z7H+JsxLiN04N5NcNrll1fyjeimSveMSgCqLIyPLi26d5qL36AaKnMDT63O88fWXDLrp
         hgd4Eq8jrINJAuJG8LDmyaMw7WBGSOarG7ZE7nbHFUQzwkkHyj3U81+0GdAtB0ZfgGyY
         g7KyaJEyRAOH4IY78E/T4ncgSDItS2tm7+o9ezF7UsvHpFH2RGqiA//Xflpf7boS6S+9
         wCdGB9B51E6sSVpSkOMDgDVKShc9x6jKFBpJ15kuTC17M1IWMbKiIQGpeKxrDMEhDVxl
         1/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116038; x=1793720838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4B5d9m5IGzIPEeB3GJQ3GiQrHdJ7xnPhjgrZIgnZaI8=;
        b=kHutEde9w0v5GzV6Lv1GV5D1T1zHF6L11drPhPoXgE2JMt2hxoDHzfIZDMv8esPWuD
         I+bg67rMtEwmjDiEujWz7BqNmnZRTZhvaPbWHAaVincammcvVvf02QfbcsOQdtsPj9w5
         KkT506++ZDRc4K1mORwdNJwJb155K2aKwXoRGGsonA3b9p9YAu3TU6HegT4Tw0hHSM35
         HIUSXivVxscjVlWlgU8n8BJK2IVlFMy22mCwmdn+/o4u/YG0TZDJ2n1SLIMkoJztAnhf
         wxzPzDp36Z73RVj13ixDYfXHtqK+QS+l7Qu4SvvubSmZb1fYgmZmcu8BZGq7m1cF6yRu
         sZZg==
X-Forwarded-Encrypted: i=1; AKwUvBybVraYtzHQOl1qPx3bnKNg+Gew5kciRXgKH02mWXjoIE6tqQIlN0QGkFmdDCjNxarmcaapUHWR+A==@kvack.org
X-Gm-Message-State: AFq9FYLRCVArsftBHWYCbMLmQT4dnpRLgU3CfdNk1wMIEMAoFCXN1ojH
	SCvpi3FACpvM0n+OQGTYDiTwSZAC03RtJmh+KNKIDCbGRKR3mYouPgwh
X-Gm-Gg: AYBFou2MaqFjY4ebVB+qHT00NJwo4n1hjMtgnspG6nlHrA5v/Mp6Jzvo27YH++Moxk9
	CcA8MsP2+cH5+6ah7Z/YLPeQit9hrANyCtg5p7eDaiefxCcQtRw7rQM/39olu/Q/B5j6J3NYqev
	ukJv/FFNrlzkzYJ4hH07W2T90iCQejkkVxIRmhjH7EmJgeIfDq8KKR1yJWaq1HNymq5W2/JPQ0i
	ppyPRwi/PT600Izp09z1+YSPRg8jbYKPown3hHBQwkyv+qXQ5TxDaNkiPqFcRtN0q8UCbW5Sv5b
	yoyb3G5qxQ7WNR8Jc/KqXAvDJbZLGOuIVrutmBJ9HeaQqnsCdaY3PFnlU8LpYv7MAPZUMPZ2YqK
	HWpC47VKq4zXmchGfohwPVIcz12DN5pXmqtwGYUXIr5KTrMQG26Hjiu7TVQC5jisBxfGf01lUop
	2uORlhYBTFqVWyMa1nGWsn6C0g0DmN1CzH3toEvEoZgM2Jkhcil2h5Z2HmjV7QVQTW+U/Dr/vwE
	OaNneZGGATO++jlTMAqNs3GnDzoMcKYfxO9RoG92Y9SMOcCR3uF8xh+GLQcht8JA/1Tarvii42t
	0qvWAz62Ioj7lbHRBamw68rjClvx/wk8UJuZ73pi8njXD+nPlyny8yLzHlEg1/YOC6F9FcxOOQP
	fpW7uMqwz8mmCvHKU
X-Received: by 2002:a05:6000:2312:b0:48d:ee59:3a30 with SMTP id ffacd0b85a97d-48e3eb8b4c5mr20222645f8f.22.1793116037586;
        Tue, 27 Oct 2026 08:47:17 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:17 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 10/14] iommufd/selftest: Add mock-domain IOVA queries
Date: Tue, 27 Oct 2026 15:46:45 +0000
Message-ID: <20261027154649.91571-11-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57AB84000A
X-Stat-Signature: 8cjb3hgibi9hchqab5k9sacdc69dypoh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793116039-20657
X-HE-Meta: U2FsdGVkX1+k+XvYb/X+PTgkqCvyJnn6aexcK+9GafDWPSCBA2fwtQbRCZnF1z0BiQ8OKHNn4UdeSqu4Yt+jwrU5/DzpfT/M2Lxm+YcgHkyiCtrUHd92xCkoXc2PGvn/gJ9K7KbWS5L2tvEdk89YoQA/mm4YFRoO6sYrcyVwHChW+O9gglUQbquO1eLlr6FjFjfKAJmwH2c99+AySsG5jVtVCDcE78OpCQbdJkKQ0VorYCJKfyPu4VBJ1u/3dejZTlLVxguP7HRrYGehSgGqPRYy+M3jV20uPvO5QVEEAmEDE0jGPG5WQ6EZUP9SC2qLkLmxHtLixxl8P45dWvs7AMA+EOHv3nBT5I64Llip46targ5BPRm+m7DsxpqauLFn6/EO1xpY4GAMq5PVkRfcgB3Ya7PRmJG8ffF03wq21/XjZM0WtWTv9r/v9WkgbKAvXO+A6KcFXwvGXOUAqPokf25ZBJrf+JeCRWOBCocuPJZrz14s27H9adDzyTstZuXgPLSxOUvHWqPSqxL7ZoRKF59xvlzvWA+zjdG9mC+ReAjiZwXeKtgtlk90XqrG2sRCqeZufgX+6hEMevIvCNziTjRc2yysftl7Bq/RYRBtxq6hXImH79f4ukmRE72boPzGigkxqGkOuiQazqwDFSulFUN9EOm6HOKsPD/3WrsCFh01LL8jimckCF2dAkP+pctWH6Urqmp7HqYH8kYw68OV/ktnsoFJjxPflohw9JbmDzU5b3RZM66r7ksF1UHNxG+iLpB8P/MHG5BEdKI7fKYUBPGQnH9vzKkdwi9IRQU4unlrZBVNa1DCi2qq8sKBtSWZI/TN/jirqUzY63v8lp3tWns5UdOYfwZgnC4fkOcoqDbnt+FtA4thuI6w41v6uFyEu+4yta8l/6rKw2XhTEbpkpBAeuKHIFnsTD3aDedEOx0vMNwW2Kcuyf93Axr/tPIV5xVx7GvHtrL39I7Mxsy
 Bo6KV4hO
 DIVJlqtXzMn8bP6uGbYlU6HR9b9SJmxorSmebSQF8U8PhdkKH9O8yD73x2k+5vlicHWesdk1pbggcD2mV5IpD1kCDwvEnK7lcqsVM7s2vJqvXfJU82QCIAxJrryKi3e1CwTLpJ/28hWEX1Ph7GOSSAS9KmAkzeEoi3PkNHxz01QITnxi7LQOVK7LwCnEo2HOEDiEmLMifLgKmDiIjihts9kp8UYo/0zZc8v0L8PCBiBkgFGzLND37qzfP8jNdDELtD0lUAnDGmvUOcvIG6W7UsWpC54zSs5Y7k7WXZIUdB6DMHGlwG9i1dPkpB3CQ2yYNw7S6Y5K8Z4sxsAyhn+QyirXysFAy/SR/k5jrvyeMlYWAYMdgqSeupohGewjKY0DA455FskQAkd76FVzGPlElgBsdHenpe5AMpBtQNJscoeV3uI4AbcvSlXVIMEWiXGsm7HOW2JzZ1KmBpBBw60fU6r/XTrhfqiYCXk0tj+i4p7cHJ8cf1i+ZmXa7vu/pVrIadMZIj8bIM9b8W4sICmPl9j06BBZb6V0UE8PWTmnWl+vbQ+C9q8LfRpPLs2Cuk2051Yy/5LyQtix+4o0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

Tests of guest_memfd mappings cannot know in advance which frame an
IOVA reaches, since a revoke can unmap or replace it, and
IOMMU_TEST_OP_MD_CHECK_MAP only compares a range against a user buffer.

Add IOMMU_TEST_OP_MD_CHECK_MAPPED, which checks that a range of a mock
domain is all mapped or all unmapped, and IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
which returns the physical address behind an IOVA. They hold
domains_rwsem for writing, so that a userspace unmap cannot free a
page-table level during the walk; they are not safe against a
concurrent guest_memfd update or dma-buf revoke, which the selftests do
not do.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/iommufd_test.h |  18 ++++
 drivers/iommu/iommufd/selftest.c     | 125 +++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 52b78cbcc920..3fffcb2b20d7 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -31,6 +31,8 @@ enum {
 	IOMMU_TEST_OP_PASID_CHECK_HWPT,
 	IOMMU_TEST_OP_DMABUF_GET,
 	IOMMU_TEST_OP_DMABUF_REVOKE,
+	IOMMU_TEST_OP_MD_CHECK_MAPPED,
+	IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
 };
 
 enum {
@@ -193,6 +195,22 @@ struct iommu_test_cmd {
 			__s32 dmabuf_fd;
 			__u32 revoked;
 		} dmabuf_revoke;
+		struct {
+			/*
+			 * 1: every page in [iova, iova+length) must be mapped;
+			 * 0: none of them may be. Any page in the other state
+			 * fails with -ENOENT. Any other value, or a non-zero
+			 * __reserved, is -EINVAL.
+			 */
+			__u32 mapped;
+			__u32 __reserved;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+		} check_mapped;
+		struct {
+			__aligned_u64 iova;
+			__aligned_u64 out_phys;	/* 0 if unmapped */
+		} iova_to_phys;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index ee706f18f7e9..378d7c46327e 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2068,6 +2068,122 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+/*
+ * True if [iova, iova + length) lies inside the domain's aperture.  An IOVA
+ * that the domain cannot map would read as unmapped, so the queries refuse
+ * it rather than report it as such.
+ */
+static bool mock_domain_covers(struct mock_iommu_domain *mock,
+			       unsigned long iova, size_t length)
+{
+	struct iommu_domain_geometry *geo = &mock->domain.geometry;
+	unsigned long last;
+
+	if (check_add_overflow(iova, length - 1, &last))
+		return false;
+	return iova >= geo->aperture_start && last <= geo->aperture_end;
+}
+
+/*
+ * iova_to_phys() walks the page table, so it must not run while an unmap
+ * frees a level of it.  A userspace unmap holds the IOAS domains_rwsem for
+ * reading while it unmaps the domains, so holding it for writing keeps such
+ * unmaps away.  A guest_memfd update, e.g. on a conversion or a punch hole,
+ * and a dma-buf revoke unmap under their pages mutex only, so tests must not
+ * run these queries while one is in progress.  A range can cross several
+ * areas and holes, so the queries take one IOAS-wide lock rather than the
+ * pages mutex of each area.
+ */
+static struct rw_semaphore *
+mock_domain_unmap_lock(struct iommufd_hw_pagetable *hwpt)
+{
+	return &to_hwpt_paging(hwpt)->ioas->iopt.domains_rwsem;
+}
+
+/*
+ * Report the physical address the mock domain resolves @iova to, or 0 if
+ * it is unmapped.  Lets a test check that two IOVAs share one frame, or that
+ * an IOVA moved to another frame, without knowing the frames in advance.
+ * Not safe against a concurrent guest_memfd update or dma-buf revoke; see
+ * mock_domain_unmap_lock().
+ */
+static int iommufd_test_md_iova_to_phys(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size || !mock_domain_covers(mock, iova, page_size)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+	down_write(mock_domain_unmap_lock(hwpt));
+	cmd->iova_to_phys.out_phys =
+		mock->domain.ops->iova_to_phys(&mock->domain, iova);
+	up_write(mock_domain_unmap_lock(hwpt));
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
+/*
+ * Check that [@iova, @iova + @length) is fully mapped or fully unmapped.  Not
+ * safe against a concurrent guest_memfd update or dma-buf revoke; see
+ * mock_domain_unmap_lock().
+ */
+static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova, size_t length,
+					u32 mapped, u32 reserved)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc = 0;
+
+	if (mapped > 1 || reserved)
+		return -EINVAL;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size || length % page_size || !length ||
+	    !mock_domain_covers(mock, iova, length)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
+	down_write(mock_domain_unmap_lock(hwpt));
+	for (; length; length -= page_size, iova += page_size) {
+		bool is_mapped =
+			mock->domain.ops->iova_to_phys(&mock->domain, iova) != 0;
+
+		if (is_mapped != mapped) {
+			rc = -ENOENT;
+			break;
+		}
+		/* A huge-page mock domain spans 2^38 bytes. */
+		cond_resched();
+	}
+	up_write(mock_domain_unmap_lock(hwpt));
+
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
 static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 				      bool revoked)
 {
@@ -2180,6 +2296,15 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 		return iommufd_test_dmabuf_revoke(ucmd,
 						  cmd->dmabuf_revoke.dmabuf_fd,
 						  cmd->dmabuf_revoke.revoked);
+	case IOMMU_TEST_OP_MD_CHECK_MAPPED:
+		return iommufd_test_md_check_mapped(ucmd, cmd->id,
+						    cmd->check_mapped.iova,
+						    cmd->check_mapped.length,
+						    cmd->check_mapped.mapped,
+						    cmd->check_mapped.__reserved);
+	case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
+		return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
+						    cmd->iova_to_phys.iova);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.47.3


