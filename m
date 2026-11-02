Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBF4606B1C8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bxpu0glf
Received: by kanga.kvack.org (Postfix)
	id 1868C6B0655; Mon,  2 Nov 2026 10:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137406B0656; Mon,  2 Nov 2026 10:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2E26B0657; Mon,  2 Nov 2026 10:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C769F6B0655
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E77C1C1ED8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:24 +0000 (UTC)
X-FDA: 85390583208.16.8C1D4C8
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf19.hostedemail.com (Postfix) with ESMTP id B59701A0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bxpu0glf;
	spf=pass (imf19.hostedemail.com: domain of 3Ma7oagcKCI4D0705Azy66y3w.u64305CF-442Dsu2.69y@flex--vipinsh.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3Ma7oagcKCI4D0705Azy66y3w.u64305CF-442Dsu2.69y@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAmKs654GCi6VXGTIXtG/L5qz01wzAI854D1tv9w8Xg=;
	b=CS4H9RZ2tmme1Zf0NrYhPIKwuoUh/aSS7l2BZRkXlJrZwhpmMbP/hTGXuFuh0+8EHmfPyT
	xvLWqjAkyuZyIXZfrAmCE2NKLwq38gtvPm6cIG1bQLBfFMeJJvVIVFAi2Gf1gMzyV2HH3L
	WucKGgh9/9e1uHmFGeqc0crj0GSnXsg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633842;
	b=Dz3BWBJao1cmN9SbklcTXccbuNvZPXpnEJsj72phdWvN3Fme6tNYdNOUnqkioMW/YRuW8/
	DJdc7fSP+aCnADKB81V1gJm4Vs51i8gifjRaAjHyhwY6sOAfM3E+UKH/Pv0mu0odBhbSC6
	Syr9HStbnc5bZjEdmNQlrJG9uTYMVac=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bxpu0glf;
	spf=pass (imf19.hostedemail.com: domain of 3Ma7oagcKCI4D0705Azy66y3w.u64305CF-442Dsu2.69y@flex--vipinsh.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3Ma7oagcKCI4D0705Azy66y3w.u64305CF-442Dsu2.69y@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so4606467a91.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633841; x=1794238641; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KAmKs654GCi6VXGTIXtG/L5qz01wzAI854D1tv9w8Xg=;
        b=bxpu0glf8n/rx4kE/nDRxYJED3Suz8KwLoqyfHSCAkJUJ4ZxpyEdpH/55S/uIlifj9
         bqlpsLN2U2InPzgzjOi7DV0bcCD7SfRo/7yCGmqjLq/lLsCEUy7atMIW2J/Pg53yR4gU
         6MwU1oGbqym1By+bKfIOsJyRZ0kVHR785EkP8x9nLI6zjMMC0Wokzsjj0711aJrao93C
         yUdHDQg4fixcdIjvng/QQqKrAAsj3SLl3jbGic4Z4i3KyCDMKIvIKG1wtRPm5Yjs0V+C
         /CdFirEjGFggaHhFoUa+u6suUV4jfhgA3JjQzHLOfvCP8J0zkoN0o7Ba+kFbS20ltQ7P
         9XAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633841; x=1794238641;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KAmKs654GCi6VXGTIXtG/L5qz01wzAI854D1tv9w8Xg=;
        b=b7xJxIBKZoKZ5m6PwapxvKk4mIS8mo9qvRFgIkZvWjIGqSQLURb4F/28ukPgeXVAmI
         pNiRceMNgTbGvX6O9pZA8hCjAQPBtWaB10TkBkaxVDDevYTEIyJNT+JqNNDBLHxhxlz1
         oHRGQweXyeuXMoL5c+wZj2wqs0tmjMKMOyRbrbqy3YFrqjlk2NbUvLHufArXTFOPFh+W
         6gmXQJ856Md/qyoWzWU45z0jw96rUBGEABY/PV7KRUmA+MBRMUOZfPMOtCavrhx663WC
         +WAxthyY05FClTRQlFkTSvu+z9WZ/Nqc7iV42oOw1cwMW7qvSB8BaJ3H0l1QD3XgsBtW
         rGww==
X-Forwarded-Encrypted: i=1; AKwUvBw8WNRgMVSjrOrCjpQhoXWFztzNNCTvwbtNL61sIWSDf4T+bihhWsBM5EKfl/TfBGrxf+etjkJ/mw==@kvack.org
X-Gm-Message-State: APuU4Z8/jcdjGAMX1EiXy6T3g8OZ9ozmoGzOM10T1nXXzmcjQj24LOtU
	x9KSUDFUYGvMbDd1S7xOySqrBTp5R9PG5BxACU35wgC9twtWNKgJKeNlJ0lICqeqlc+PK0oyIQJ
	41csE2Lew4w==
X-Received: from pjqc8.prod.google.com ([2002:a17:90a:a608:b0:3ae:5572:c4d3])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e88:b0:3ac:85be:cd52
 with SMTP id 98e67ed59e1d1-3ae89867829mr8253650a91.59.1793633841328; Mon, 02
 Nov 2026 07:37:21 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:49 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-21-vipinsh@google.com>
Subject: [PATCH v6 20/27] vfio: selftests: Add iommufd noiommu mode
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B59701A0008
X-Stat-Signature: a465zt5zwam1zg5ufncp1pgmrxyhr1u5
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633842-883427
X-HE-Meta: U2FsdGVkX1912uNkCh9JN8r0snFw18Ezikw0iMVV9jwKkU+uE0I+mvCGKL43yJjBocJ+EUaUVeZWJl7T9vmztX0Pk5DZShT4Ia3o9PiMOL0GOHg1Kzn6NuOjosltZXGKubu7d7RMOdZ4T0/Cn0ttN32dVrs/iuMfrLMqe3TAs+s/Kf3VvsaqVdUOZsIk9jIlQVuudSFsBFbRLrOR2VBJ9f7L/LCSUYLaKdc9cLpytCg0kfyhFHSdOTdy60dy1qF/iFBWE/dGOPZ6CVG+lt9wQ5dSiszHPn656fP9jYVy1Vf80f05gPPWEW9qp7e97+ETfXUGi5NwYyqvVkrp7a2arFN0/FrPVJIKVEWQcMHwO0+pW0B0+yjQPb+5N8JftmmL53z4SaanN7QZlePmjGge/Kybb3gzv1sc13//dhGTtlQ5ZIDOYVNGID8abiIOmwJc08jMjQjx3+cfpyiYYwXK5GVjv0P5sL6qjH7xPhwRt/4GauNEBUVDMOl0I0yg29l6LEKbUu64PjDHPjKhxrtZtU42pXECzrv9YgklQ/6KT80aKuwNACytuiDOdv8XqLkC9x7zQcWpW8yTUUEUNs5IJXQ2860H3WxOwSv76j89s/OK5tTzRWcou0aTFgBugZvV/okXAbLX4taHNh2Yf2YImxKjwOuqK58m96EuwuqVA5Yt9WKep701k+HUVAGZwWHYojPXSeJsrjmHsF1xbDKXfExsN1LjrjkBUd5nXiAtyPsHRtwAq4jo9Aspcu0TNyzpRc/GxTRdxncoTLCXyvbgmd6kney/FQXFGLcC/L2ndYjItnO6bGrrs2GKY2vbWdIt3nC/CCSTUnYUe+/XE8jgK7d2wB0UDj5C7dRetsjiIVmdIF+4SA8N7yAupLiwJytkksJKazDW3cb9JZC/UQ3YXq1n2k3qW31B9GrLtDyNC4cFnWe9ODv3uiIu0HHVmKZ3iul9fVAJAOo7tACNpHs
 qPtRR6aa
 LJvAqvlwkyBriKgBcLnoA/Avt2vgZ0bYNeFDZ9dtEwJO3FCzDOZMsGGJ2yLdh+vdnyQwr4rEFNZI6EpcW4bzi1fXgsdvqEVBXWyTweIHXBYtgg7ymCo2O09/Ove+6MFG6th8diODSjpFJpKVWFQRYii4xRfztaKw7t+OxfWW3r6YM+St400SKihKf2XzWQQg9qhhRliI3q0/+kJ7TL4Ri6x8O6Ff79Vd7HMYYjefxfu/EieSdg+rZEdsrtn1Tpvg5N9TgPVKNWGQbL/VF+12/kUVi0AptyBJ9R+KHNgh9CP4G6Jq7DAcIFQ8ci8y7uS3VhMshwh+NocG6hWNjU6eDr0zKstx+4a17ctu1/iCvI4yh4Dbkg9aprm2kWKb4PJwNYJW9Hq5nggIvynJ3RBrZABBhsUZ+7f575Bee7qRb3g6WsEqr5pzLPzWFYQ26DmOuEU1p7bYkP2yiskmHLLQPA7r94sabgVYVNSh5CSFRzVDMMOqHYVvRrxpJXxQQj9tmR2MaPcoxV0yM4K48w9H0wjpwqeKTzPz/RbFxt9yjwpRBlVuGX50ofWNPwL2I7GsyjP7WkUzGP4KZeYew/mySvrmNMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add an opt-in iommufd_noiommu mode (MODE_IOMMUFD_NOIOMMU) for devices
bound to vfio-pci in noiommu mode. When a device is in noiommu mode, its
VFIO character device is named /dev/vfio/devices/noiommu-vfioX (opening
it requires CAP_SYS_RAWIO), and binding and attaching to an iommufd IOAS
use a software page table.

Add __vfio_pci_get_cdev_path(bdf, noiommu) to look up either the regular
or the noiommu cdev path and return NULL when none is present, and make
vfio_pci_cdev_open() select the cdev based on mode->noiommu.

Because a device in noiommu mode DMAs directly to physical addresses,
tests that program arbitrary or unmapped IOVAs would corrupt memory.
Keep MODE_IOMMUFD_NOIOMMU out of FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES()
so that only noiommu-aware tests opt into it.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/lib/include/libvfio/iommu.h          | 17 ++++++++++
 .../lib/include/libvfio/vfio_pci_device.h     |  7 +++++
 tools/testing/selftests/vfio/lib/iommu.c      |  9 +++++-
 .../selftests/vfio/lib/vfio_pci_device.c      | 31 +++++++++++++------
 4 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index e9a3386a4719..e652b8caf5bb 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -13,6 +13,12 @@ struct iommu_mode {
 	const char *name;
 	const char *container_path;
 	unsigned long iommu_type;
+	/*
+	 * For devices bound to vfio-pci in noiommu mode, i.e. not behind an
+	 * IOMMU. Such devices DMA to the addresses programmed into them as
+	 * physical addresses.
+	 */
+	bool noiommu;
 };
 
 extern const char *default_iommu_mode;
@@ -67,6 +73,17 @@ struct iommu_iova_range *iommu_iova_ranges(struct iommu *iommu, u32 *nranges);
 #define MODE_IOMMUFD_COMPAT_TYPE1V2 "iommufd_compat_type1v2"
 #define MODE_IOMMUFD "iommufd"
 
+/*
+ * iommufd with a device bound to vfio-pci in noiommu mode
+ * (vfio.enable_unsafe_noiommu_mode=1 and CONFIG_IOMMUFD_NOIOMMU), whose cdev
+ * is /dev/vfio/devices/noiommu-vfioX. Opening it requires CAP_SYS_RAWIO.
+ *
+ * Not part of FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(): tests must opt in, since
+ * the device DMAs to IOVAs as physical addresses, and tests that DMA to
+ * arbitrary or unmapped IOVAs would corrupt memory.
+ */
+#define MODE_IOMMUFD_NOIOMMU "iommufd_noiommu"
+
 /*
  * Generator for VFIO selftests fixture variants that replicate across all
  * possible IOMMU modes. Tests must define FIXTURE_VARIANT_ADD_IOMMU_MODE()
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 9a62bfb6b440..bfadeb362723 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -154,6 +154,13 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
 }
 
+/*
+ * Return the path of the VFIO cdev of @bdf, or NULL if there is none. The cdev
+ * of a device bound to vfio-pci in noiommu mode is named noiommu-vfioX rather
+ * than vfioX, and @noiommu selects which of the two to look for. Free with
+ * free().
+ */
+const char *__vfio_pci_get_cdev_path(const char *bdf, bool noiommu);
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
 void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf);
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index b6f3c5c84e01..0df49646d016 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -22,7 +22,10 @@
 
 const char *default_iommu_mode = MODE_IOMMUFD;
 
-/* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
+/*
+ * Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(), which
+ * deliberately leaves out the noiommu modes.
+ */
 static const struct iommu_mode iommu_modes[] = {
 	{
 		.name = MODE_VFIO_TYPE1_IOMMU,
@@ -47,6 +50,10 @@ static const struct iommu_mode iommu_modes[] = {
 	{
 		.name = MODE_IOMMUFD,
 	},
+	{
+		.name = MODE_IOMMUFD_NOIOMMU,
+		.noiommu = true,
+	},
 };
 
 static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index af789c859586..b0deef2b0e3f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -380,35 +380,42 @@ static void vfio_pci_device_setup(struct vfio_pci_device *device)
 		device->msi_eventfds[i] = -1;
 }
 
-const char *vfio_pci_get_cdev_path(const char *bdf)
+const char *__vfio_pci_get_cdev_path(const char *bdf, bool noiommu)
 {
+	const char *prefix = noiommu ? "noiommu-vfio" : "vfio";
 	char dir_path[PATH_MAX];
 	struct dirent *entry;
-	char *cdev_path;
+	char *cdev_path = NULL;
 	DIR *dir;
 
-	cdev_path = calloc_assert(PATH_MAX, 1);
-
 	snprintf_assert(dir_path, sizeof(dir_path), "/sys/bus/pci/devices/%s/vfio-dev/", bdf);
 
 	dir = opendir(dir_path);
-	VFIO_ASSERT_NOT_NULL(dir, "Failed to open directory %s\n", dir_path);
+	if (!dir)
+		return NULL;
 
 	while ((entry = readdir(dir)) != NULL) {
-		/* Find the file that starts with "vfio" */
-		if (strncmp("vfio", entry->d_name, 4))
+		if (strncmp(prefix, entry->d_name, strlen(prefix)))
 			continue;
 
+		cdev_path = calloc_assert(PATH_MAX, 1);
 		snprintf_assert(cdev_path, PATH_MAX, "/dev/vfio/devices/%s", entry->d_name);
 		break;
 	}
 
-	VFIO_ASSERT_NE(cdev_path[0], 0, "Failed to find vfio cdev file.\n");
 	VFIO_ASSERT_EQ(closedir(dir), 0);
 
 	return cdev_path;
 }
 
+const char *vfio_pci_get_cdev_path(const char *bdf)
+{
+	const char *cdev_path = __vfio_pci_get_cdev_path(bdf, false);
+
+	VFIO_ASSERT_NOT_NULL(cdev_path, "Failed to find vfio cdev file for %s\n", bdf);
+	return cdev_path;
+}
+
 int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
 {
 	struct vfio_device_bind_iommufd args = {
@@ -449,10 +456,14 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 
 void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf)
 {
-	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
+	bool noiommu = device->iommu->mode->noiommu;
+	const char *cdev_path = __vfio_pci_get_cdev_path(bdf, noiommu);
+
+	VFIO_ASSERT_NOT_NULL(cdev_path, "Failed to find %svfio cdev file for %s\n",
+			     noiommu ? "noiommu-" : "", bdf);
 
 	device->fd = open(cdev_path, O_RDWR);
-	VFIO_ASSERT_GE(device->fd, 0);
+	VFIO_ASSERT_GE(device->fd, 0, "open(%s) failed\n", cdev_path);
 	free((void *)cdev_path);
 }
 
-- 
2.56.0.317.g454f8302e1-goog


