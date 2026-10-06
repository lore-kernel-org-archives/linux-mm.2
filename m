Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F91CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48786B009B; Tue,  6 Oct 2026 14:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2036B009D; Tue,  6 Oct 2026 14:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D186B009E; Tue,  6 Oct 2026 14:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6E06B009B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 159B5A0302
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:50 +0000 (UTC)
X-FDA: 85293047700.17.E48A7F9
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41BD118000A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TrmJiA9x;
	spf=pass (imf24.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/DDLaBldS6BCqOPBQL7QwFwyovqmKt8FALCheekTNg=;
	b=6/OsNp2cTPzF3IjHVX52owhnuwuPotSDmbontr6jj14bfJFDoPF8OKNIVn40V5UiGSg7Jb
	eeuCA07aAIUWBU8snObJNfTTHiKv0FkVjrbeHW51B/9LtpLvWowLVq+ushEkHbx2ZOILeO
	HG5Zfoxp41ZcEwstc+Wd/Tg7o6FqVX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311568;
	b=errcLCtxP2gd+W1WpZ0YZ9TC/I7gs2I2IaVfDSjQopt4X1MjkWc0qz7PkWdryqbYOQynXV
	99Ldv3kFAUjEOT6AOJGRZuUCI6UW00w/A01w/AWS8FecDvdFYkGVvOk+HzHYp83/io31pM
	w06IxEeJqVu80Gk62R3LdxhGN/bLvdA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TrmJiA9x;
	spf=pass (imf24.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c315729ad50so134312466b.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311567; x=1791916367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X/DDLaBldS6BCqOPBQL7QwFwyovqmKt8FALCheekTNg=;
        b=TrmJiA9xuQS4hxNI7MvK+5OhlYQ9nN5c30f/KYpA2VkBJLogwqk9niG82w74urCao6
         mPRX+szNe5FBlLyvgZut7fgjP2eg9ASxYTEpRG7//Ztw/rQT0Zp5motS3wA9zTAghy8e
         9TkNT0VjIdz6guA9gGrHOUAT9JAj3azjR8eA54FL5Tf/n9GySY/ProsDMZywHjKmJFSU
         eINtY27omKYvDudef09lb0RvTVbizJzZO36XGhnajyyJwfDmuqE3IQFbRGIk+5S2Jgfp
         iQg+wADNyBQnqxvxyvK2YfOCkSJKk1MzjXnrq5mwosa+BE5kSLUQ8NEhn4bilTzqWwGE
         kh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311567; x=1791916367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X/DDLaBldS6BCqOPBQL7QwFwyovqmKt8FALCheekTNg=;
        b=m0L/vwdrmTenhp1IwMm/zRZAgrdjm70ET+6C7zkbZzt/sEDBPRkNv9/Hg93v0YTdk5
         ebKSmZ6lx6z4hqwnIXni4JBTQH9XA79F+DpITMMmvTProZ14ZSzClSiL5MHBY+h4bz4x
         7sOUJAlDW3PKA35oGpfoQj45tc3dFTnmh/cP/5mf6OwzQPzsep0dUUMT2E/KHtPai/Yo
         oypm7Ko3nDdoOv61WqSV0m8iUWSZkdW78eVqu8TvUQg+nETbjHrIni/SDovnlX4hAs9S
         GAkCV5hAfRgMuNVNkVFhFMQij4Ft/NMlI38fq3Fiuk7xZyqK77HDdbM/15Zeb/Cz5w6f
         6m9A==
X-Forwarded-Encrypted: i=1; AKwUvBzeW1+oCdtTnZ3ImOhWSUW5ErEVbw7VOFtScnzNxpcnc2eB7qsXSax1KYsffxOMBnqs4C+XwLd94g==@kvack.org
X-Gm-Message-State: AFuF++l9eM8lEDH0uYGwW4nzgOB7IG7oqggohX8DAky887pulD/9+ELR
	Ax7L8oODeE5FJ8u12bmFnj/c30Dpy3MgNvT+RUwDVkAhrwrnXcmfpgFN
X-Gm-Gg: AYBFou3/QRAy1XY9vm9sHBrqSxehEa/ZvafTgKbBzwEEwcpadGqNlcl+GnwUI410g5h
	TWi+G9b3ZqXMaEqLt3/6KZ7f87UfRUtgbnlyn0qFfnmXw0PoAIC8Dxf3HxtOqMIec5lMnqfi8JJ
	pwlQ1bYV/eV8TxRqBPFR6VqG5RQ7g4Oud2SMAyONQvSDH/72XjDUhitUgBUhAJ74xknk/somYAA
	LTJLmBBScNazlDfwXOhT/5PkjshEGihTAWsZ+rAyxpuGbviiBWpeYfVWh2y2s+CTR8SwyZkzG5t
	BMKcuKOLSyRGrATp8ZHFHbvUe652GONvRZtk/j/Ffx2ZQ5518uJ779HJswgC5is6lWG1SCm2Up1
	SGpzmIS2cwN56AWUCx0hNqIlKxoyArtl+HDegAkF+Xe7szP2FRfdy9Eg9pTuppcC5lX1aecXxLa
	WRKZg6l3m2wh5bfDiMHF9LIV90oEgqvTGOz5GT0gqehoAQ3NexMqilJv5eGuii03RRdUGd3CdQ8
	OSJQHBRQ8GEYwRLHfr4T3DRMscG0/ysrhoJDs6pWAnX4xddXSrRb9fV4+ScYMVYJ9LidLFsnEy1
	9Rlgq1yT8mE0MXF26qfy7LdNI8R9mU1gJsE=
X-Received: by 2002:a17:907:72d3:b0:c2e:4488:b8a3 with SMTP id a640c23a62f3a-c316a0bb639mr232794566b.33.1791311566749;
        Tue, 06 Oct 2026 11:32:46 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:46 -0700 (PDT)
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
Subject: [PATCH 6/9] iommufd/selftest: Add mock-domain IOVA queries
Date: Tue,  6 Oct 2026 18:32:32 +0000
Message-ID: <20261006183235.16576-7-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41BD118000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fox31yqkaawdrt3m3qkimm7de57i1xnb
X-HE-Tag: 1791311568-110015
X-HE-Meta: U2FsdGVkX1/M/GieKz99kGr1BhHXF2UIPoJ1Jv5P0/kQTJQ5cT6dzovGY14153fEXfzGBqd30ybtrK/SWKdvF3GRIqe3svrA460ael1edvKaB309HePg1Eq2+afudLV0pRf3XaRXRY5csHhZ2cZ3tXERjs/tvNWJKtJSS/WBEZgUqvWjWvQ941j/JCBOsotzpqN54URETb7IPCaOeLwIINwsuAhcgbFtNZF5vBUw6syC2CDUsL8x2OIUWaOSVNsjWLucL8CYZTS5TqbsQzshfkLIy9/KyEhoMQvS8QdS4aa6Y4fYWaUneBU2Kk2/eWvsd6DF1RnlaAFXk4Of4SZi5hl2uJCcjTct5CoeoR3ZuxpW/LDeDRH5GdAfWZwrKx9LovLFp+vgbDe8ur3lSETJFGtdZtaiqS7P+a5tzAxwjLVjUXfMB6aHINWW46MxXFx6jOUbrbROSy+1Rr6/UzCkRG2Qyq0S+6ylUBjUOtNN5WsJd78y9bpCDNDecUo2p8YdgEXupLoYHT/CfflX0TtvnIY4DT+tdSxLHOWlm1/XwEZT+zNRE/iKvJMwvQpRgvGW437enYXcUox7MWYU+vRf/w8dooUeQv0LMehUzT/nj0SleF4I0xjAnYz5GRefSQ7n0NiPTW3XFW+Hn4h9aaaN5wXKeUJDA+zc1yaS/cYM6IxI5M914HE4A8mE3khrFs3sriWRpL7+lgSMc7KOM5OUZS7MoBxDZQr/Tl6+St6QLVOrqRr9tTgfZzO50e3L1GIjiVPck70Qan5ewUkfuDx9IM+k5QAxSEL3AVRseaAjvmx0T2V7kVbrmhnM57Of7BiQYvSXkGDtmgs9C4jhoMn1Dm4qoVoQuD+dNOITX7ivb+BIniIzHBaftgUqaFZEj61CfsOYIzBhPPv8dmTTCrlt8y2Gcm4+C+F4HeTLUZNuuy+QQ/+HCCJKJjGcMs2PeA73J+LAPqDfYhgVar8Ljcm
 Y9idzF1x
 WycJLvVfG6O33OvVadCibrGW6ajn0sTd0cnYADl0CqwhEyaKsywDC5fDXMJ68H6FB77qRCMrdvRPoH7aNfNf6K7t3onMwW+bxUtvwJN3xG5emMM7lKnY5HQmTSiFRA8DKkfZuSJ82qbiBdy+owbbnAv/fzp9luTpPB9XVZec42A6NKZl5fAV/Z5mpzlbMs0wvhmMXfvTiZsX68HN+tkwtu0hkYBGlNbgy3BrBwVxazBozrGVTbbKvOycuj18sn+Yh7azlaPDMEXd1nDCEw7sbihobl5CI5rr/A5FMTxKObxksxJKFsZwtihoRiWF/o8B+8xIPYJLrAkf9UGESHZAQxzXCvLFp/e4uzULjFBnIdaWKLBDnXLdLt0FbZRobVwVreIqBYA2TrwBzCInmkxuDQdTJLlsoGcTYQucBv/0i7EikhDaXna+OvyNgp//jRO/uUZSfdHO8oh8LKHRhYS5m9hI4xqbHb1E1Tnx882zq05ZySap8ljR+gPARCTxFobEQDPEX
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

