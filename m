Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A903BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F96C6B00B4; Wed, 14 Oct 2026 05:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0C96B00B6; Wed, 14 Oct 2026 05:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEAC6B00B7; Wed, 14 Oct 2026 05:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5136B00B4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B7C2A04AE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:49 +0000 (UTC)
X-FDA: 85320729858.11.FE1C0E9
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94D66A0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VxYlq+Ln;
	spf=pass (imf25.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XH1DvjtQ4kSOTYVjVn8rMjarIlp6Ws3f/rSFMl2hKxs=;
	b=IFnh64DuguDygMA2VHLg9Cs7lqXW2ag8m7zzcdGzH1gCMq7QbkfGHhs+1581nmTRYhjrWS
	d71RyinwY/+6eEzjtIeSG2V0C0feAU+BuxtOpplyJQ/WFQEPYT8BCuhE8hFIbri9LrTiHv
	8/HdlVg3ayoOPinYk9GfeOAKhRc1fsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970667;
	b=wQ5WI+O5HLtOljcVWqD4v1GsMoch+P+lQkgIEdJcV5lV+WQh60711/8ZcA8JVczk/EoMY3
	NbeIARgKcdBlUGz1pnMHZ81DbrCTAnZBuJju3mHuAlXb6Nh9Xipmj4zoey23rHG4X1sFqc
	Xhitxf/Pke9UwHz1cAgYFd1yDlkeCus=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VxYlq+Ln;
	spf=pass (imf25.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b060ec084so2529348f8f.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970666; x=1792575466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XH1DvjtQ4kSOTYVjVn8rMjarIlp6Ws3f/rSFMl2hKxs=;
        b=VxYlq+Lnej/SU+i4NS/F4MEg028rmR3iNdmFX+9m6F60Cn/y2KoHYPLdiXGjpxCZK3
         7uNeYKRKnfrTkvjU2dp4QOXaH5CrX/vCNo9S0E+8hqEO9xEBSfw+aLqmTkkVEygVuboK
         OlVz2aLZvHQmgROvbRHY7y3rj4Z8TDPeBSZhkcASguv3elqch8FKOcs0hIgf3Qw7DhQU
         LgWoyZYyxJmQ8hXwp4noHYouATTeyL0PRmxwGeY1RPn+ycH9Oj+MBmU0NGHIXUbGwC5o
         XeS2YE7P1lafn/J/lNKsPeoNTmA598CPijxZIivGMrqGD112cofwrldoAWWV8RmfolbJ
         m7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970666; x=1792575466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XH1DvjtQ4kSOTYVjVn8rMjarIlp6Ws3f/rSFMl2hKxs=;
        b=ClhmqWZb9amNchIulc1ARDCEwYB2m3EaYWyYHNo4Lw0Nt1lct2e67/Y7u+qWpnEXeU
         lGUlFBHXRjYqckbeGaA9iPZnc6EosDhOlc4wyXXDv8p9UDuN8YcTrwhzRzpDNYHZv8in
         Mybhn2aMBEsD/EJDvSmF145NUU9G3fakrktUDnt9lQPIrEzVHek2vaqB/X9G88wHl8T0
         TzjYJc2qjtxfiOWQptziWHuYHn/VEIIV0i64osDZDaTYoYNRDm6EpC+EI5GWSMOoJpeh
         CpTt+oACix/VJkjgYd/kT//btbmzk5wKT+fRD8171Up+jjyIjCeBPR7MT4u+7Rp8nXOf
         bZsQ==
X-Forwarded-Encrypted: i=1; AKwUvByPocXQSi3aB1HtrJiepGmJMIqQNREdtDCR4UBsX/vO+24iPZ1X8823hvn4y4O3r08Eg7lsb6GUOg==@kvack.org
X-Gm-Message-State: AFq9FYKiaS0oC0dV9kt3W9G536wTh6zgqFUbvpR3zuwPwgo13fCTeIqR
	QsipLWr+gYibKiCAC5jQKRkU32Zl1WPG7CFcW2tYKOSkU6jrP0U4emjk
X-Gm-Gg: AYBFou16dLkC8cbgEQwZHTxdHpCZDSIdrNkyVa8pRpDfOF36s/SnzeMmWKluc0EF1bI
	PnO0MOolQrLYCnA9WnEkyLP1Q57S1pLdXdzR1T8lOJZFlNsDJdygdYP6oahi3cwyMmD6jjAmzVy
	tcBIAr397UHDw25ZpZKq9UvihAbn46K54X2acd9x34tM34tE4P77p/O8KAc8x6FKAePhbgMi7XS
	0LEQBVFdz0yZxvzLjLinHE+wsA4XCAUTD+WCAdz7JeORo2Foy8LPdIjyFbzgZF3U3oPzU7H/6HS
	6iavxE8IXUVIIhRVusepKwoOLwOL8Wqc9PyNkZh3piD4oxVEt1AIXmwtUAmJPLONtLldntse56g
	7bTg2ZAlnhgsJr9cdXXHM3flAcKxpzyalLy6IZ3FVqiXqYGvcJvqVvYpeVpMJdfRb9faA/odPI7
	tenhzkUL3Ezw9rqOzqawiP0eQTFT9RNcDUvNUUFaI6r7pTMUIGDCgHQ4VsbqUrfM3oQ8aO0wuRd
	RD7wCPli7h65q0ZfzmgdfEQJ7nmiXhOQ9Xjc17IOzFEZhkXzYe1iqq1RrEo+QXK9SrqIvsCh0jp
	83pq+ZLVh3mQ3m/BIKOVPqYEn6RPAcwI+Qk7
X-Received: by 2002:adf:e001:0:20b0:48b:efb:4a66 with SMTP id ffacd0b85a97d-48dba7b405bmr21828342f8f.6.1791970666161;
        Wed, 14 Oct 2026 02:37:46 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:45 -0700 (PDT)
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
Subject: [RFC PATCH v2 08/11] iommufd/selftest: Add mock-domain IOVA queries
Date: Wed, 14 Oct 2026 09:37:30 +0000
Message-ID: <20261014093733.90312-9-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94D66A0003
X-Stat-Signature: n9hiyy4s3iiwudow38gs4w3whggxbkzg
X-HE-Tag: 1791970667-483775
X-HE-Meta: U2FsdGVkX19M4w7VAaSxnFK6ifvhee66J+oqmjzunoG2EeC7dqttM2LySyHraEhv/OvJbgClpXRGQ6b3UpnHZFM7NLUi2ACSXsA2oQNE/jC2yEEgEzNhAl3F+EF/sxlOS3fu4Ejs09bBgiyrP+HOxHTwdFLpJEVWomhWm3m+cP6sMm7yAhOmMv345zFJYZaXgDeHdvTUw7KMz5psQB/bieeh6AxB3RJo4pNjEeHVXo4KL5oPASpr+gTlMJ5cLQDnJg45G1rpeTZV7yxVCJ2tCQO1/1W7TdXctO5WAc/rJA5KsyV+Khie8Ewp82RsUvT0dwYO72qTvzOucV4qzk8KAzQ4C6lJCcV99wVSgqNJeDNwdH5EZPhuoM6xTHyQDnEwE8IUAH+pm58X49hz1y04CMEvuFAry1h4vjMy3VXdEw0UhAi10IjcKHCzqYvVXp74j9XPUuEwcQPL/KaeSI6FtCbC+oZudcyAyBIoE76O7usA69kKU5eIZpmXs8Y5X2JADFp9kcjHqJRRg8TDcMUsnjkhgFafh5m+2/ZF1r6EQ1p7dBaB0G8BtuIB/qfOCHVDvs853Q+v2Fb/H1FA3dOaNvkXJ1Pw3sXSiCBNH/nALB84/t5qETDXNhjfgEwzPG7cVMx2zWcbKVMktmdlme1LSLoMr7OUI6cwrHqeEC0HS9NLVL9HDQt1xlTGrVhz1zskvV8wRa2xjLUmVgja9pWc/unfopPOAeLMvebHfOnPf1vO0QTTNDCVelNEcOIrId8n0BGrSLZ036fGw8OWbodTswmcHyFBSB4Y/w8luadS5cmuSOBeRz8Zma3KHkpvpPaDd/yIhb6h6Rmg7h/1yfNc5A14SbY86Wajd2RmhsCu3bXdHuCNtk0/h2CQhee3LemWPyl+HDo2Crx0GnqRoZl+/atAjxmLCXHddfbmj2SU9Ba7v4DNjagwQXrdPuB0YyfctSOiScRmsvf1nUJ/sHu
 AFsbzO/w
 rXmRKydygu5Oesy2XxMPP7FUpHMFqMVHEKDoK5DW9Y6/+l9SAXUfXTN/iiRLfFalHlUVouRZHrwOJhUrv3Fix4GMBRXcyIRmVbsKv35ZoYzmUZcKgWKBCKfuvzbE+DnvdjsDwGFd8EGSZjA/qs47cqw7en0q+it7i2oCQvwMyftI8g8vVbWU1JXrwQWWw0kJkjCDLgZkHjtdyadHFNptvxhPiHtf2wDFCorV3Z2yl4Rqsjcqlj3L613DRdO0z4Z3CvNQjUOAGIp7BTe5dYaiAXmyBre+zMHqEjDMIf+FKRHc0xrkTKl2KoK8Toh2gK90MKPJBoBDQZLsLKNwiWdeGSvMHlfetjp1TUA1MRkKZ5sW/AXIcK95Ay+RVNjKvR80qW1AY2QRshpbelkSEKGRZUH19c4tYIyqIWaqU6vnjCXH6F1QI7HvTmpy9M7bU9OR4FwUt9SXUiQGfLLv3gwAmcHiD3uKbBk7382WOba/Lc7C6JTcg+YIdd0MotEBeqlhL7xd9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

A test of memory that can be taken back or replaced does not know in
advance which frame a device reaches. IOMMU_TEST_OP_MD_CHECK_MAP only
compares against a known buffer.

Add MD_CHECK_MAPPED, which checks that a range is fully mapped or fully
unmapped, and MD_IOVA_TO_PHYS, which returns the frame behind an IOVA,
or 0 if it is unmapped. Both refuse an IOVA outside the domain's
aperture.

Both hold domains_rwsem for writing so that a userspace unmap cannot
free a page-table level during the walk.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/iommufd_test.h |  16 ++++
 drivers/iommu/iommufd/selftest.c     | 109 +++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 52b78cbcc920..28fd9c43edc4 100644
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
@@ -193,6 +195,20 @@ struct iommu_test_cmd {
 			__s32 dmabuf_fd;
 			__u32 revoked;
 		} dmabuf_revoke;
+		struct {
+			/*
+			 * 1: every page in [iova, iova+length) must be mapped;
+			 * 0: none of them may be. Mixed is an error.
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
index af07c642a526..1f5cd2d00fda 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2031,6 +2031,107 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+/*
+ * True if [iova, iova + length) lies inside the domain's aperture.  Outside
+ * it the page table returns an error code from iova_to_phys(), not 0.
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
+ * unmaps away.  A memory provider or dma-buf revoke unmaps under its pages
+ * mutex only, so tests must not run these queries while a revoke of the
+ * range is in progress.
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
+static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova, size_t length,
+					bool mapped)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc = 0;
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
@@ -2143,6 +2244,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 		return iommufd_test_dmabuf_revoke(ucmd,
 						  cmd->dmabuf_revoke.dmabuf_fd,
 						  cmd->dmabuf_revoke.revoked);
+	case IOMMU_TEST_OP_MD_CHECK_MAPPED:
+		return iommufd_test_md_check_mapped(ucmd, cmd->id,
+						    cmd->check_mapped.iova,
+						    cmd->check_mapped.length,
+						    cmd->check_mapped.mapped);
+	case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
+		return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
+						    cmd->iova_to_phys.iova);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.47.3


