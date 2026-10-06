Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67132CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ABA66B009D; Tue,  6 Oct 2026 14:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483B36B009E; Tue,  6 Oct 2026 14:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D52D6B009F; Tue,  6 Oct 2026 14:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE8196B009D
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 856FC1602E1
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:51 +0000 (UTC)
X-FDA: 85293047742.21.13BE2F8
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id A445B20009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGnrbGg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311569;
	b=8Gy/baRpNOuOYYdbqS+e8zgyuJQRdeHcGo6QJoS9yMKtqosv/5V6TifCrCyBEQYPp8/ZvP
	BcYQ8rzkz8hi7BYtHoAQ0a1fT8is4YMerLZ+bnm2u6umPs7+SJ1XTbwsOywSvTUYWVawBK
	irmz1KctajEQJF+X4xe0wRSjO4eZ0vA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGnrbGg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teKgoAnZutiypdvXjRT5Q8SK6RKAQZGpxaEXQB1IAug=;
	b=ie91z9HHub5YERW02cR/LXNU83wKK2sziIW37SGgN4r3VLj69bQA+dRIx/6nzKPS5fU2n6
	FIXBHUjssXuLDY6IZpzAiV6TAslsJjLsVqHBk2rc1tAylFpxeNSWMA8VcbkUEzFeCwD6L4
	5EPOaTLiZb4ObEkv54omOpuM8PXZ638=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2055573c8cso128701366b.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311568; x=1791916368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=teKgoAnZutiypdvXjRT5Q8SK6RKAQZGpxaEXQB1IAug=;
        b=sGnrbGg+/UDayQOAAdHGVFSKel04anwhkkWX5K1dLt7zIEa8aWvqlgsDQE1yK2xJsW
         EQIsbtSEaUcsYokzb+Twt7YP9pnB3kD7zehbqBVs2cEA6nMHuXUZKaaqUYuTQGYFai4U
         R0d7ZrI7CgBBLM7uwhwdpTVh16VAJdt3Fa0OBS02CzESEtkn1TBsyo8Rk6+5vwXQFaoe
         WFKZNRGwDtUlNJp0ffy6NxGBhvHKkUr2+JyHze3SQqNNhFtKjJHYu8BvOEEslW4ORN/s
         MY2XFhA92n7efxZjRvlx2PtEVLyyg1jVD2N4AjaRRWSAyeZcS6QYfauAx6+vd2KuSErb
         xMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311568; x=1791916368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=teKgoAnZutiypdvXjRT5Q8SK6RKAQZGpxaEXQB1IAug=;
        b=1LR3stFq0ISakJ2XOcJXqfpEPXJAgrKVOjLfoAH5KesUztzzkDfeQIQtmMmfVd19Hs
         z9bvmphalOkMxfqIl5rvsMESKibVS3gE615upzeham6Of3IAfvrX3jNuqoCJbedvq7/8
         vP7sT9MDotv2zS8cEEPO7/EqtMpDxa0SQpobSOXZAPsE7t3GclESFFEYxCZZ3YPL/C24
         Qp1DocwdeH5S8C9AKHMIymfQSuOzcqes/hfYr29knBCC/wxqBBsGdUbwOl4VLmCTmgcX
         loEffX/NNXxpx25mgYxOrZiJquFw1Bh5JabqRYDmoFe7zKFQMyvu9fV16lq2noGlMAur
         4u+g==
X-Forwarded-Encrypted: i=1; AKwUvBxWSFaEsfk4M07HuP3N6HKomybZpks2R98gJsHmUyd5NJJMRmGd585RVYNWbO70tNxiB5WXTsM/+A==@kvack.org
X-Gm-Message-State: AFq9FYKKoWh2CM4qh6RHdwlaT/pgWyL8ogEXPBXKL4tpY+b0KonEwzEJ
	IqaCAZedBIUB2hNTBi8mMB6fiJKAwe+3OPJEl7+lIdd77ALRFWFigx4c
X-Gm-Gg: AYBFou0u6IFq6mBPOvDQVxVGSyuMhouPZi/dF8jzxlGZyC7aS+qPG7WXNIwOuL9o3TZ
	N0hRhW7hE/V51/y2eAAkwg+++zSuyZFC4/EthJ7DgoNtOojSLVp0ZToNs8LOEjIsI75VQYIkQVM
	L3f1Il2NuAD4oJLtEl1V9DhY3pLQAWaiUklAFeJtlH5yIvnKB25/Kr1HATrcIiyfDXCSal7QzrY
	zLs2W2IzmZ9uhR82zoDSJNr3VP21zH3qz6wxREUKXWnqMgJDwROyMLWYDhUpT/d2nYv7gULnF1L
	qj6ZihuuAdC4AUP6Pj3kHDKZXbHF/fiECUjheGxyS2TeYo8QSCh5thsrYC7vMBY5e687pulnDJi
	r1pzp00Wly7rjrwM/6P2VQX1u9VT29IL+XMbo8u/t93TR8l0gatebMKUd0LGZadqUZiDZ/eYpIr
	N3lo85q9rW+pB8AEFFOmS7e+UcQOs8YYCvLt8P/BxjpKUnsCwMdiw8iy78N8z2meYVowOdj+Cq/
	WCABDcqOJVHsc0OXlKFNtPMWRiTJPyPpvNl8nlABRCVEXvCEoHsIxcnCA3ctbuTT5sCiMHhECXz
	twOWjOnbuNrKSC4EwrH6CQYWpgOhB9g7+shZt0d+ICWBiA==
X-Received: by 2002:a17:906:c107:b0:c29:f0a4:a4f8 with SMTP id a640c23a62f3a-c317b4bc0b7mr4286266b.0.1791311568135;
        Tue, 06 Oct 2026 11:32:48 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:47 -0700 (PDT)
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
Subject: [PATCH 7/9] iommufd/selftest: Add a mock memory provider
Date: Tue,  6 Oct 2026 18:32:33 +0000
Message-ID: <20261006183235.16576-8-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8fqn8ugw6sufs5groh4qifq41qeqfar4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A445B20009
X-HE-Tag: 1791311569-934419
X-HE-Meta: U2FsdGVkX18xxjbiMTYHPOgrOXmYSbbNIv4vyTOjVvw8c5T3ifIWcQKgZABgfO2fZob6sBWQYqYNOoholmKR/is1/W/5ULWZ4eD8i5izWweoPZdN4ixG+emMb9tYgWypxo/OU/j4Ihvv8n/7P7J/+PmKP7tUSaY1+F8ORdBsQWcLtaHaQjbvihSLoQlyfCTsYD5hIJ4V4ipaPlmDo5gl6v25pavUtUvRAjO1k8I2AxFOmD+c8yPA62r2CTNNCjqfa8DW1vdyvMnih7cXem0ukRxycrOKIAVQW2KJnErq5Xk/TGvJ1/EZbowz5JMiToL3A/X+n3bDReD5f0DAs6vU9H6ze9siAZh/SoVbi+dzZTGf88Nu3DLSo1HuFVS5AEOygpNc4mbO8SUXqsJ+zv2/Es4meU4nIqTWyp5j0K28aU7OY1F7prhyh/dgWzVRhEjR/wxsYQ01NJ+nBI/j1BoSP9AQwlOxHUPidfVWgwi4RxUMDhJw+rlks3aPOpWb2x/1wDMxffRhN/PZ8jZaNo9UFADhamv+nflCKaIQfn3jDR1gXQcmNJSg56Gmg/J2goyU2nTA509D7Tn0O7fOWqB1+B19x5tA0GhNsmqdZdIoZjdU0g4j7Fickm4W266az5sSAfTHEDi9+2UQSwM1zDV3XT49ziQ97A84AApA+sosBgnLk17USeRwMJZKV2QwA9pjt/bgLLmgDviTxf2RUUeoS81VhmoviNTgCT5Rj84CM+tQ5p+t04ePizSYoETufCLOncG9VwXIKQnCf1/gn0+CO3G745PKT2ROoGHCXdqu5SFWWy26lOp2xtIu7ps4WuZUEJDvTkfRjTsCURmr1dBG0Jj8IIN0Tl9Pk7jo3A+m6J/gr6UPFchwIzRc7Z82PIsFCmTYxireeCeAj+AmMZFxTBupRHPZfIrxYurnRpSi0r94tsBpiQzCC0aQNr+/Qyb8l+67w8CnBT1Buv0IYmq
 lFalkNfn
 d5Pc+awly0H45IuYeQs/Xfve4+YdpinPo3bQRJZTUvKuFjeUeSp+72QgJvNq3+7QkANT7ZLMi45PXm3a8Cr8JSEsz2rmEpyh13zzUOz7f5g/Rx5yoYV6WJWwRFaOBGq7YUUq29pZ/mno1T1DGD6flLpGTuS1h8e0zDcGNDLAXpaQbxHFscPrkjbRNhp2jNSFvTVOU2fU7dwd3tQ+4/W5A871n7c+s8fvUJvYR63MB9T4oJ6AadKFF/YgvxDToiHKnC2qVR5NUcCNb9Fwe4N/KlNcLT6E4r2Ry+yeIrPCnaqtKQqO1rjywfsPobHoebLeQgq+pb5TwoZPliZNz9Z5kMVnxT4FVeLRPJeHuF/BcqKIvHJRqo/SJhGEQdSl9AwX6dHKOQ825wL8YaswmzAFVkN26eBhRNKCalAMBUOe+CLlVxXjOGNmruWBRNszN6rViYGQE7apJvkwSq+UTMcOcclODW1FtAva/POZrMP25FOkLotpH1O9N4Z1jnurwmmZcy6+q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

The provider path of IOMMU_IOAS_MAP_FILE needs a provider to test
against.

Add a mock provider whose pages can be made holes, read only, MMIO or
another shared frame, with a revoke after each change. Test that holes
stay unmapped, that a revoke changes only its range, that new domains
see the current state, and that provider pages and dirty tracking
domains cannot share an IOAS.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/iommufd_test.h          |  20 ++
 drivers/iommu/iommufd/selftest.c              | 177 ++++++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 119 ++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h |  64 +++++++
 4 files changed, 380 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 28fd9c43edc4..5e5023dc8070 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -33,6 +33,17 @@ enum {
 	IOMMU_TEST_OP_DMABUF_REVOKE,
 	IOMMU_TEST_OP_MD_CHECK_MAPPED,
 	IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
+	IOMMU_TEST_OP_PROVIDER_GET,
+	IOMMU_TEST_OP_PROVIDER_SET,
+};
+
+/* Page states of the mock memory provider, IOMMU_TEST_OP_PROVIDER_SET */
+enum {
+	MOCK_PROVIDER_BACKED = 0,
+	MOCK_PROVIDER_HOLE,
+	MOCK_PROVIDER_READONLY,
+	MOCK_PROVIDER_OTHER,
+	MOCK_PROVIDER_MMIO,
 };
 
 enum {
@@ -209,6 +220,15 @@ struct iommu_test_cmd {
 			__aligned_u64 iova;
 			__aligned_u64 out_phys;	/* 0 if unmapped */
 		} iova_to_phys;
+		struct {
+			__u32 length;
+		} provider_get;
+		struct {
+			__s32 fd;
+			__u32 state;
+			__aligned_u64 offset;
+			__aligned_u64 length;
+		} provider_set;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 1f5cd2d00fda..270c41e6dd77 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -10,6 +10,7 @@
 #include <linux/fault-inject.h>
 #include <linux/file.h>
 #include <linux/iommu.h>
+#include <linux/mem_provider.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
@@ -2132,6 +2133,174 @@ static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+/*
+ * A mock memory provider.  Each page of the file is backed by its own page of
+ * RAM, or is a hole, read only, the one page that every page in the OTHER
+ * state shares, or reported as MMIO.
+ * IOMMU_TEST_OP_PROVIDER_SET changes the state of a range and revokes it.
+ */
+struct iommufd_test_provider {
+	struct mem_provider_file mpf;
+	size_t npages;
+	struct page **pages;
+	struct page *other;
+	u8 *state;
+};
+
+static void iommufd_test_provider_free(struct iommufd_test_provider *tp)
+{
+	size_t i;
+
+	for (i = 0; i != tp->npages; i++)
+		if (tp->pages[i])
+			__free_page(tp->pages[i]);
+	if (tp->other)
+		__free_page(tp->other);
+	kfree(tp->state);
+	kfree(tp->pages);
+	kfree(tp);
+}
+
+static int iommufd_test_provider_release(struct inode *inode,
+					 struct file *file)
+{
+	iommufd_test_provider_free(file->private_data);
+	return 0;
+}
+
+static struct mem_provider_file *
+iommufd_test_provider_attach(struct file *file, loff_t size)
+{
+	struct iommufd_test_provider *tp = file->private_data;
+
+	if (size > (loff_t)tp->npages * PAGE_SIZE)
+		return ERR_PTR(-EINVAL);
+	return &tp->mpf;
+}
+
+static void iommufd_test_provider_detach(struct mem_provider_file *mpf)
+{
+}
+
+static int iommufd_test_provider_get_page(struct mem_provider_file *mpf,
+					  pgoff_t index, unsigned long *pfn,
+					  int *max_order, u32 *attrs)
+{
+	struct iommufd_test_provider *tp =
+		container_of(mpf, struct iommufd_test_provider, mpf);
+
+	*max_order = 0;
+	switch (READ_ONCE(tp->state[index])) {
+	case MOCK_PROVIDER_HOLE:
+		return -EFAULT;
+	case MOCK_PROVIDER_READONLY:
+		*attrs = MEM_PROVIDER_ATTR_READONLY;
+		break;
+	case MOCK_PROVIDER_OTHER:
+		*pfn = page_to_pfn(tp->other);
+		return 0;
+	case MOCK_PROVIDER_MMIO:
+		*attrs = MEM_PROVIDER_TYPE_MMIO;
+		break;
+	}
+	*pfn = page_to_pfn(tp->pages[index]);
+	return 0;
+}
+
+static const struct mem_provider_ops iommufd_test_provider_ops = {
+	.attach = iommufd_test_provider_attach,
+	.detach = iommufd_test_provider_detach,
+	.get_page = iommufd_test_provider_get_page,
+};
+
+static const struct mem_provider_fops iommufd_test_provider_fops = {
+	.fops = {
+		.owner = THIS_MODULE,
+		.fop_flags = FOP_MEM_PROVIDER,
+		.release = iommufd_test_provider_release,
+	},
+	.ops = &iommufd_test_provider_ops,
+};
+
+static int iommufd_test_provider_get(struct iommufd_ucmd *ucmd, size_t len)
+{
+	struct iommufd_test_provider *tp;
+	struct file *file;
+	size_t i;
+	int fd, rc;
+
+	len = ALIGN(len, PAGE_SIZE);
+	if (len == 0 || len > PAGE_SIZE * 512)
+		return -EINVAL;
+
+	tp = kzalloc_obj(*tp);
+	if (!tp)
+		return -ENOMEM;
+	mem_provider_file_init(&tp->mpf);
+	tp->npages = len / PAGE_SIZE;
+	tp->pages = kcalloc(tp->npages, sizeof(*tp->pages), GFP_KERNEL);
+	tp->state = kcalloc(tp->npages, sizeof(*tp->state), GFP_KERNEL);
+	tp->other = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!tp->pages || !tp->state || !tp->other) {
+		rc = -ENOMEM;
+		goto err_free;
+	}
+	for (i = 0; i != tp->npages; i++) {
+		tp->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!tp->pages[i]) {
+			rc = -ENOMEM;
+			goto err_free;
+		}
+	}
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		rc = fd;
+		goto err_free;
+	}
+	file = anon_inode_getfile("[iommufd-test-provider]",
+				  &iommufd_test_provider_fops.fops, tp, O_RDWR);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		rc = PTR_ERR(file);
+		goto err_free;
+	}
+	fd_install(fd, file);
+	return fd;
+
+err_free:
+	iommufd_test_provider_free(tp);
+	return rc;
+}
+
+static int iommufd_test_provider_set(struct iommufd_ucmd *ucmd, int fd,
+				     unsigned int state, u64 offset, u64 length)
+{
+	struct iommufd_test_provider *tp;
+	u64 end;
+	size_t i;
+
+	if (state > MOCK_PROVIDER_MMIO)
+		return -EINVAL;
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+	if (fd_file(f)->f_op != &iommufd_test_provider_fops.fops)
+		return -EINVAL;
+	tp = fd_file(f)->private_data;
+
+	if (!length || check_add_overflow(offset, length, &end) ||
+	    !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(length) ||
+	    end > (u64)tp->npages * PAGE_SIZE)
+		return -EINVAL;
+
+	for (i = offset / PAGE_SIZE; i != end / PAGE_SIZE; i++)
+		WRITE_ONCE(tp->state[i], state);
+	mem_provider_revoke(&tp->mpf, offset, length);
+	return 0;
+}
+
 static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 				      bool revoked)
 {
@@ -2252,6 +2421,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 	case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
 		return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
 						    cmd->iova_to_phys.iova);
+	case IOMMU_TEST_OP_PROVIDER_GET:
+		return iommufd_test_provider_get(ucmd,
+						 cmd->provider_get.length);
+	case IOMMU_TEST_OP_PROVIDER_SET:
+		return iommufd_test_provider_set(ucmd, cmd->provider_set.fd,
+						 cmd->provider_set.state,
+						 cmd->provider_set.offset,
+						 cmd->provider_set.length);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index d44b34b05757..ebf81ca3af18 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1627,6 +1627,125 @@ TEST_F(iommufd_ioas, dmabuf_revoke)
 	close(dfd);
 }
 
+TEST_F(iommufd_ioas, provider_simple)
+{
+	size_t buf_size = PAGE_SIZE * 4;
+	__u64 iova;
+	int pfd;
+
+	test_cmd_get_provider(buf_size, &pfd);
+	test_err_ioctl_ioas_map_file(EINVAL, pfd, 0, 0, &iova);
+	test_err_ioctl_ioas_map_file(EINVAL, pfd, 0, buf_size + PAGE_SIZE,
+				     &iova);
+	test_err_ioctl_ioas_map_file(EINVAL, pfd, 1, PAGE_SIZE, &iova);
+	test_ioctl_ioas_map_file(pfd, 0, buf_size, &iova);
+	if (variant->mock_domains)
+		test_cmd_md_check_mapped(self->hwpt_id, iova, buf_size, true);
+
+	/* The mapping keeps the provider file alive */
+	close(pfd);
+	if (variant->mock_domains)
+		test_cmd_md_check_mapped(self->hwpt_id, iova, buf_size, true);
+	test_ioctl_ioas_unmap(iova, buf_size);
+}
+
+TEST_F(iommufd_ioas, provider_revoke)
+{
+	size_t buf_size = PAGE_SIZE * 8;
+	__u64 phys0, phys1;
+	__u32 hwpt_id;
+	__u64 iova;
+	int pfd;
+
+	if (!variant->mock_domains)
+		SKIP(return, "Needs a mock domain");
+
+	test_cmd_get_provider(buf_size, &pfd);
+
+	/* A page that is a hole when the file is mapped stays unmapped */
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_HOLE, PAGE_SIZE, PAGE_SIZE);
+	test_ioctl_ioas_map_file(pfd, 0, buf_size, &iova);
+	test_cmd_md_check_mapped(self->hwpt_id, iova, PAGE_SIZE, true);
+	test_cmd_md_check_mapped(self->hwpt_id, iova + PAGE_SIZE, PAGE_SIZE,
+				 false);
+	test_cmd_md_check_mapped(self->hwpt_id, iova + 2 * PAGE_SIZE,
+				 buf_size - 2 * PAGE_SIZE, true);
+
+	/* Give the page back */
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_BACKED, PAGE_SIZE, PAGE_SIZE);
+	test_cmd_md_check_mapped(self->hwpt_id, iova, buf_size, true);
+
+	/* Take back the middle, and only the middle goes */
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_HOLE, 2 * PAGE_SIZE,
+			      4 * PAGE_SIZE);
+	test_cmd_md_check_mapped(self->hwpt_id, iova, 2 * PAGE_SIZE, true);
+	test_cmd_md_check_mapped(self->hwpt_id, iova + 2 * PAGE_SIZE,
+				 4 * PAGE_SIZE, false);
+	test_cmd_md_check_mapped(self->hwpt_id, iova + 6 * PAGE_SIZE,
+				 2 * PAGE_SIZE, true);
+
+	/* A domain added now sees the same holes */
+	test_cmd_hwpt_alloc(self->device_id, self->ioas_id, 0, &hwpt_id);
+	test_cmd_md_check_mapped(hwpt_id, iova, 2 * PAGE_SIZE, true);
+	test_cmd_md_check_mapped(hwpt_id, iova + 2 * PAGE_SIZE, 4 * PAGE_SIZE,
+				 false);
+	test_cmd_md_check_mapped(hwpt_id, iova + 6 * PAGE_SIZE, 2 * PAGE_SIZE,
+				 true);
+	test_ioctl_destroy(hwpt_id);
+
+	/* Put the same other frame behind two pages */
+	phys0 = test_cmd_md_iova_to_phys(self->hwpt_id, iova);
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_OTHER, 0, 2 * PAGE_SIZE);
+	phys1 = test_cmd_md_iova_to_phys(self->hwpt_id, iova);
+	ASSERT_NE(0, phys1);
+	ASSERT_NE(phys0, phys1);
+	ASSERT_EQ(phys1,
+		  test_cmd_md_iova_to_phys(self->hwpt_id, iova + PAGE_SIZE));
+
+	/* Read-only and MMIO pages stay mapped */
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_READONLY, 0, buf_size / 2);
+	test_cmd_provider_set(pfd, MOCK_PROVIDER_MMIO, buf_size / 2,
+			      buf_size / 2);
+	test_cmd_md_check_mapped(self->hwpt_id, iova, buf_size, true);
+
+	/* A change past the end of the file is refused */
+	EXPECT_ERRNO(EINVAL, _test_cmd_provider_set(self->fd, pfd,
+						    MOCK_PROVIDER_HOLE,
+						    buf_size, PAGE_SIZE));
+
+	test_ioctl_ioas_unmap(iova, buf_size);
+	close(pfd);
+}
+
+TEST_F(iommufd_ioas, provider_dirty_tracking)
+{
+	size_t buf_size = PAGE_SIZE * 4;
+	__u32 hwpt_id;
+	__u64 iova;
+	int pfd;
+
+	if (!variant->mock_domains)
+		SKIP(return, "Needs a mock domain");
+
+	test_cmd_get_provider(buf_size, &pfd);
+
+	/* No dirty tracking domain over provider pages ... */
+	test_ioctl_ioas_map_file(pfd, 0, buf_size, &iova);
+	test_err_hwpt_alloc(EOPNOTSUPP, self->device_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_ioctl_ioas_unmap(iova, buf_size);
+
+	/* ... and no provider pages under a dirty tracking domain. */
+	test_cmd_hwpt_alloc(self->device_id, self->ioas_id,
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING, &hwpt_id);
+	test_err_ioctl_ioas_map_file(EOPNOTSUPP, pfd, 0, buf_size, &iova);
+	test_ioctl_destroy(hwpt_id);
+
+	test_ioctl_ioas_map_file(pfd, 0, buf_size, &iova);
+	test_ioctl_ioas_unmap(iova, buf_size);
+	close(pfd);
+}
+
 FIXTURE(iommufd_mock_domain)
 {
 	int fd;
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index b4928cbd4d9c..d1bd0a283db2 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -593,6 +593,70 @@ static int _test_cmd_revoke_dmabuf(int fd, int dmabuf_fd, bool revoked)
 #define test_cmd_revoke_dmabuf(dmabuf_fd, revoke) \
 	ASSERT_EQ(0, _test_cmd_revoke_dmabuf(self->fd, dmabuf_fd, revoke))
 
+static int _test_cmd_get_provider(int fd, size_t len, int *out_fd)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_PROVIDER_GET,
+		.provider_get = { .length = len },
+	};
+
+	*out_fd = ioctl(fd, IOMMU_TEST_CMD, &cmd);
+	if (*out_fd < 0)
+		return -1;
+	return 0;
+}
+#define test_cmd_get_provider(len, out_fd) \
+	ASSERT_EQ(0, _test_cmd_get_provider(self->fd, len, out_fd))
+
+static int _test_cmd_provider_set(int fd, int pfd, unsigned int state,
+				  __u64 offset, __u64 length)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_PROVIDER_SET,
+		.provider_set = { .fd = pfd, .state = state,
+				  .offset = offset, .length = length },
+	};
+
+	return ioctl(fd, IOMMU_TEST_CMD, &cmd);
+}
+#define test_cmd_provider_set(pfd, state, offset, length) \
+	ASSERT_EQ(0, _test_cmd_provider_set(self->fd, pfd, state, offset, length))
+
+static int _test_cmd_md_check_mapped(int fd, __u32 hwpt_id, __u64 iova,
+				     __u64 length, bool mapped)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_MD_CHECK_MAPPED,
+		.id = hwpt_id,
+		.check_mapped = { .mapped = mapped, .iova = iova,
+				  .length = length },
+	};
+
+	return ioctl(fd, IOMMU_TEST_CMD, &cmd);
+}
+#define test_cmd_md_check_mapped(hwpt_id, iova, length, mapped)		\
+	ASSERT_EQ(0, _test_cmd_md_check_mapped(self->fd, hwpt_id, iova,	\
+					       length, mapped))
+
+static __u64 _test_cmd_md_iova_to_phys(int fd, __u32 hwpt_id, __u64 iova)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
+		.id = hwpt_id,
+		.iova_to_phys = { .iova = iova },
+	};
+
+	if (ioctl(fd, IOMMU_TEST_CMD, &cmd))
+		return -1;
+	return cmd.iova_to_phys.out_phys;
+}
+#define test_cmd_md_iova_to_phys(hwpt_id, iova) \
+	_test_cmd_md_iova_to_phys(self->fd, hwpt_id, iova)
+
 static int _test_ioctl_destroy(int fd, unsigned int id)
 {
 	struct iommu_destroy cmd = {

