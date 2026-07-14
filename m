Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FAFC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1345F6B00F9; Tue, 14 Jul 2026 11:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E52A6B00FB; Tue, 14 Jul 2026 11:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC79D6B00FC; Tue, 14 Jul 2026 11:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5A276B00F9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 543FAC03F2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:27 +0000 (UTC)
X-FDA: 84987731094.14.C80CF65
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 952A41C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KmNxr/BP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3jFJWagcKCOMaNUNSXMLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3jFJWagcKCOMaNUNSXMLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKj/zyluhYMMwtYKfEtevhbjKc1OLf8e8hVjMJ10va8=;
	b=F1Sz6SUiqp/HPjOoU/8dh7X0NmLNrUBFjyBGpRCQPf05jJOiOQbIFxoYWPQcZS/5wZ9V6M
	q8nG5ao8QhJhLq4Y2pEJsDuLztjEZH+SjTdk9MK+OO7qMk/sOE238PCAxIk/8b3aAni6Zi
	D2jeJILzmFEUsifRkEOUax93/+Npx+U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KmNxr/BP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3jFJWagcKCOMaNUNSXMLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3jFJWagcKCOMaNUNSXMLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042125;
	b=U9Afwwj03wxVgCxmqxW0bm+IoxmfhDzRyaR7EkVeMernVQrj+eJyTHZ0PETWupXRoslUVW
	gWrkEKQPBGfknXfoyHXrQKg19wytvHomi1kI1jFOb3FP8crEitmxVa/CFpikwG1nHzJDUF
	QZfrvNHP/6vZEi0yIQaGMvOyxwwQlLQ=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-845317fa7e6so8117286b3a.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042124; x=1784646924; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKj/zyluhYMMwtYKfEtevhbjKc1OLf8e8hVjMJ10va8=;
        b=KmNxr/BPFkwykNNuJxC4HicpXtUdfGjPor5hmSQS9H+FkxTeRUnyM7eVS7Lg17hhj+
         oRB436TXQQpZEpkgY9JfJDbl7gulkqtM0Z+SMT7glR+7K5qGvuMxhqIT0fdAG2qtNgx4
         u15iAf9M7hRvgSEP9e+AQkvIAXC0cW52UMmq/OTELGO8U6zzWuwKWPqHItlJB1D2kpea
         7fJVVzxvCyAgun/vtooblZWQd4oIwtINon6fmOPD/96nO304ug5KmBhlloY9mHbGClFy
         8idADXd5/DgZjojTXuzIwszaufh7N1mXw0guvD0To5Svnb7QwEafGNdAy44yBj004t3B
         Ehig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042124; x=1784646924;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gKj/zyluhYMMwtYKfEtevhbjKc1OLf8e8hVjMJ10va8=;
        b=WkBpSZbDazRnJ5SwsBYeyOXqvPD+oXm3WdC3R1m2NF2iLneX2U4WPdNCKI2stF4IOr
         UzMx7BihD57QJ1/6jGW35yDAKuVXFAhE4e0IsTNrXPTPVh+mPFD3AWc8ZqtsIwwsr2F2
         3/ZdUCin9cpUbEwgJkmKozDXtBK+2TqoxdJyaJfhFmDg9lH/cdrcaeyz11Woka4K2ryO
         5gdj9nTsgcx6p9MCkNyO3I40iKuJtyvUN2rnuUo3mWquKu1bJbHrhycjs6quXq1t/gEX
         QVt+4abgkJk1kbuKXt3O8rW8DICo91A0/C3vDcyMsGoevRlCgd/cYHtG/JH//BTrN76L
         VIpg==
X-Forwarded-Encrypted: i=1; AHgh+RqphMt7KYLEoO125VULHStr0yJA2xr//uhzCaIeQ6nTLUIQJerI33LqZ4Fx0XhP8/Ask5782kkxeA==@kvack.org
X-Gm-Message-State: AOJu0Yxz7A2W6czSChgGxeMCKURAtyNEs92ZNXhIfyj1i1KEH49vlBgN
	IoE68/EqZIfreIFkHSNMS8x8BazrCCtYcrxUbgLDW5dUqKlen2gQy5wVjELXU+j200P1PKhPBgT
	fla2+v70byg==
X-Received: from pfbhx15.prod.google.com ([2002:a05:6a00:898f:b0:845:e683:1287])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b50:b0:848:6698:2d5a
 with SMTP id d2e1a72fcca58-84889659202mr12144241b3a.20.1784042124125; Tue, 14
 Jul 2026 08:15:24 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:59 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-15-vipinsh@google.com>
Subject: [PATCH v5 14/20] vfio: selftests: Add vfio_pci_liveupdate_uapi_test
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 952A41C0004
X-Stat-Signature: 65o87rti97cy4o5kuuuw776hc9wqm4h4
X-HE-Tag: 1784042125-391132
X-HE-Meta: U2FsdGVkX1/mTLmY6j8iDqKUaVyUe3Xj1ayORq5M4J/CVGwomXafs4aIdKUhD/tR2xAiYtCO8J6UIC9oGjeUVlJbZ69EyIIrkifS+lYwefzjyVfiF0CskdX18AGRp/8v4mhhV5rgw2GOZiVBDjDQrj5E5QUrawqO1ZZGVK37rbs6rkgLfOt7kNE66PpNER7nVHDuL2Pykf8yayualpKmDYMw+t4pJm6XQUq6QhmOhC4YbbLn4MhXQkhOnGAW/agqoq3RuIK1coBRdhEvqSCRHhRwXCZyXqBwbXK54XlfzzUolq3pXvK6O5+FcKx7e+IJdX8jvzT7qroj3ha40BMnqNNijFiLoaKfYJs5VBzQ2N8uNFlo7nhCj5vRbEG61jOEQDJyWibpzNvehIqhgpwj4zmzmf90cyQ7Kx9FczILiNVK16NupYH4wYqolbvSFQfX/QMbKwA6xCRHd0o+/pSwwxUJy292B3Pgwy0Ilu8md+cFV+5GU1WtPViko3Dfj1n0VSQIGg9CecOg5TRLFrvqfWwo7VPgsURvR6AA+IkcaE6DWwxdxQJ25tymGdSTT6S+2FbpgdDShT59nEPk+kipka7aIv86vzowL5PXq6sf1/pdexKzoRb9tWtsl13NnjDbGetmBaEeYgY4sIpUO6a5EAeYqF4G3OKkjjJUWv10yihhkHIG6xJMqA410dzAaKAgyvV1T8DqM4zmGOd2xEANM6cSyuCcbN0UWxwFBp+ELU5enWWPU8dqk5K0IvhZ/U3CtiNzU2hG/Ku14b94Yny/VFL0gUpkXF6iN+Vh6bgUIhnCEOh0wyUlhldLAE/58jI9ZIZUv9zQ6BuYnG5qwcYUp8ihcFi+cczY7gDN7fphxZ9GGvsNiBmh2Gsa5+S/fVDmVYBktXQtbKT0v8vlAOaVmjlhyRW/70Ubao2Z7BjJGREGspGuBpTtf2UaOmvgszNysJjWCNviFzBEApx3x5P
 FRst1jPR
 JWt4/gpcYjZgD3LjyrD3dQFMfgUVaUUcbaycbstnNvcKSFGEqOQruUl4w42iFreF8Cbiuyts6Z0ydTrPdBt6ljckPHgNs6Uewi+fq0EmKRJo4sorpNduFc9JdomcyNvzJpuBNgEyF0ruMiqzvHYmb4vMRRBmlARXhwvU/MXBjdJvAk7R1SPijGepZmJi+STKSWEzqQi6djzxaulfRRInmyYO1Rd1CX2s1AeeM0oXMcK347o0srnuATwyt2lw/YZSiq7dPE4bc4nPOiGBc0jZwKSikeZNtin+9+IuBDFm6PspyLmnWwW+W8IM+k2JrSUznDGd4xj3qXmoztowCQaaVCmZ0ZUEmI5AhHODjdybWM0xOKXnNO9Rkbe2kSPt/zo3YfJQIpmSvU4J0HSjDwLh79r0HHZi9p5isRRV+MuSI9HJ9BkuX8gQ9/pAufhlNYiqNZ2pmBuzdcZ9qkGgEQIhDv8i69alFx6bSyVjHaoCBb7yDWv71D7ffiQc94QLchhZGmYJOlQMQ4FelbhWzpBcOO0heVpX9zPZekGwdmknQizL1sthzuzMOkhXRXpTaRA42r3nvRCGdDhm8iLQkE3o43kyZMH+egZiR5hWdv7lOrN8cOIy5WWqNOjnudjkIYJZEyIQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Add a selftest to exercise preserving various VFIO files through
/dev/liveupdate. Ensure that VFIO cdev device files can be preserved and
everything else (group-based device files, group files, and container
files) all fail.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile         |  1 +
 .../vfio/vfio_pci_liveupdate_uapi_test.c      | 97 +++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 4c8a30f950c4..dc06fddcf855 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -13,6 +13,7 @@ TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
 TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
+TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
new file mode 100644
index 000000000000..f81c8ab21db3
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <libliveupdate.h>
+#include <libvfio.h>
+#include <kselftest_harness.h>
+
+static const char *device_bdf;
+
+FIXTURE(vfio_pci_liveupdate_uapi_test) {
+	int luo_fd;
+	int session_fd;
+	struct iommu *iommu;
+	struct vfio_pci_device *device;
+};
+
+FIXTURE_VARIANT(vfio_pci_liveupdate_uapi_test) {
+	const char *iommu_mode;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode)			\
+FIXTURE_VARIANT_ADD(vfio_pci_liveupdate_uapi_test, _iommu_mode) {	\
+	.iommu_mode = #_iommu_mode,					\
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
+#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
+
+FIXTURE_SETUP(vfio_pci_liveupdate_uapi_test)
+{
+	self->luo_fd = luo_open_device();
+	ASSERT_GT(self->luo_fd, 0);
+
+	self->session_fd = luo_create_session(self->luo_fd, "session");
+	ASSERT_GT(self->session_fd, 0);
+
+	self->iommu = iommu_init(variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, self->iommu);
+}
+
+FIXTURE_TEARDOWN(vfio_pci_liveupdate_uapi_test)
+{
+	if (self->device)
+		vfio_pci_device_cleanup(self->device);
+	if (self->iommu)
+		iommu_cleanup(self->iommu);
+	if (self->session_fd > 0)
+		close(self->session_fd);
+	if (self->luo_fd > 0)
+		close(self->luo_fd);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
+{
+	int ret;
+
+	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
+
+	/* Preservation should only be supported for VFIO cdev files. */
+	ASSERT_EQ(ret, self->iommu->iommufd ? 0 : -ENOENT);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
+{
+	int ret;
+
+	if (self->iommu->iommufd)
+		SKIP(return, "iommufd-mode does not have group files");
+
+	ret = luo_session_preserve_fd(self->session_fd, self->device->group_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_container_fails)
+{
+	int ret;
+
+	if (self->iommu->iommufd)
+		SKIP(return, "iommufd-mode does not have container files");
+
+	ret = luo_session_preserve_fd(self->session_fd, self->iommu->container_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+
+	fd = luo_open_device();
+	if (fd < 0)
+		ksft_exit_skip("open(%s) failed: %s, skipping\n",
+			       LUO_DEVICE, strerror(errno));
+
+	close(fd);
+
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.55.0.795.g602f6c329a-goog


