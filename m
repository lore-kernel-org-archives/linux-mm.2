Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09AC606B1D7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jipYg2E5
Received: by kanga.kvack.org (Postfix)
	id E57E36B0652; Mon,  2 Nov 2026 10:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08236B0653; Mon,  2 Nov 2026 10:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34056B0654; Mon,  2 Nov 2026 10:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97C586B0652
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FB9B16016C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:22 +0000 (UTC)
X-FDA: 85390583124.11.2AB777F
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8454BA0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jipYg2E5;
	spf=pass (imf25.hostedemail.com: domain of 3L67oagcKCIwBy5y38xw44w1u.s421y3AD-220Bqs0.47w@flex--vipinsh.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3L67oagcKCIwBy5y38xw44w1u.s421y3AD-220Bqs0.47w@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633840;
	b=dGykOkwvXYIAzVQC5FSuurNkwBdvUvHI2efxoPMAND/G4vvnw8Ui3HMfTyk+xptXyTRdiP
	ooYBxMsy9O4lWDqWMhoucg2jeB3455TY5bQOBuHrllB+4qCB8ok064b7Z9kVSbn0ikekeg
	1eTsuokEb+MP1+ydQwFOd4nFbzC4KhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jipYg2E5;
	spf=pass (imf25.hostedemail.com: domain of 3L67oagcKCIwBy5y38xw44w1u.s421y3AD-220Bqs0.47w@flex--vipinsh.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3L67oagcKCIwBy5y38xw44w1u.s421y3AD-220Bqs0.47w@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVnfWSj8ZzZvrderQaZLMWS7UwjUc+ra7btm+XE8Eyg=;
	b=0Oy2MiILgJAYgubhrJUd6KmbxrbrSaClSft9tR9ORxdef7CpEkmfnsYJGtyB+SbfOZ/3Ox
	IhZWGo33QmxD5Lg2qdlhlQy1AXqUmyLGo4TO/fSOwuDJ/S1E5WWaKyDU0u4ettARJOWQ15
	Ab28W4+uWgAerZ49IcOtiwNdOPBZITw=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab67ff8ec3so2145605a91.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633839; x=1794238639; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVnfWSj8ZzZvrderQaZLMWS7UwjUc+ra7btm+XE8Eyg=;
        b=jipYg2E5p2/nfBfcoR6w+XZjZqEUzghN8v2/txmTwiL5BjUPO2PcJMbSgwytWi0pcS
         CYrTJ1Ij8O1+khywCgx+qiPYvgzXufCuIEehBNI6YTGVf0jiDcmDyLKRVPXaKX9hzqjX
         AxfiisKLe6DExI5MxgprdP+gLia8uH4GzMv1mCtCW5vsILa/PGEXCdzwEcE7g7BjGhvC
         ss18GOQW69z2E78cH9JNFleDnXYID6jA/sbsyUsKHMeUu+HlVjFQSh+oyIQkGgAOlwmT
         FoX/Nqy9Rwxlts7DTuTngTQ8WTP0PRgMI4QPX7vH32GTnEElNiKdAtXza+XWgw9OdPow
         YF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633839; x=1794238639;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVnfWSj8ZzZvrderQaZLMWS7UwjUc+ra7btm+XE8Eyg=;
        b=JZeGud13zb1KB2cKja9TWkEcXx8AjXA9nHmUxfRvVY/DflzPk/ikTdwq1nBm+bZxN8
         fpbHupf14Y0enMOnfgjs5n4S8WRTTO9TPWQm9w0x62KQmvhQOHQFS+zQb96D2yKV0JpU
         ug2J8JaQLJmrKlAYyPojf/JPA/hX0nmOB2Fn22ADLZzeCIibe4rFBzizBVfjU5oCm5gv
         iyOv5gfxIHc0Pyi5Cuor8iOB9kBcFazU+1XI5bQMBU5f7Rn9xfK4QCPYxKm8mqdk4iOm
         2PgWvKR8ggu0pYotTVYl9Pq+PWXwdGUisXiyR2BD3CcWkLX1Aj8W4v5MrZtxeYI2dK7Y
         H4/w==
X-Forwarded-Encrypted: i=1; AKwUvByZDroOc2v9HtO/an1+pBt7ujyuyrW+wzjFQoqQY/9jUzBX+dx5mrXo2Nb2YMwvROjEEhlTIlV9uw==@kvack.org
X-Gm-Message-State: APuU4Z+VdSojhfNO7ze41/CHqjvlZJ9jkDVIPFN2oHwU85NhqR0VebC/
	BPh4vqAbgzqQUGZWdvOl6s+eDHYEg7tx28ioqxp28V+B2QNQfnp4I6OCvk8k0/Em9pCLFkRpueW
	uvI3pVfK9gQ==
X-Received: from pjat8.prod.google.com ([2002:a17:90a:d08:b0:3ac:3195:12b4])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5870:b0:3ad:6090:a189
 with SMTP id 98e67ed59e1d1-3ae8983e2f3mr7697277a91.45.1793633839167; Mon, 02
 Nov 2026 07:37:19 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:47 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-19-vipinsh@google.com>
Subject: [PATCH v6 18/27] vfio: selftests: Initialize vfio_pci_device using a
 VFIO cdev FD
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 8454BA0006
X-Stat-Signature: dn8cb7k845fizr8nmqz8yn99f4nmo5z7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633840-730690
X-HE-Meta: U2FsdGVkX19IylHxOYMAvHeD0H4eP/O2k3njGwVNTc6nRlhLdUw0qpMAG9DKb80E6zqRRiNOMb5lyr75mTFlrngcEA+caDK2GngAO/odosaSykCb2Y8b1V2esUBfRye5ypr/CBebPh2ToJ++X5ZBLADaeoKBvHizIc6AmdBh2Ds/lqQqp/NynNIb5QTxqno+/uqjywaJulbeEA0Pnquz9n0bQmZf0x15Az0ZmFueQJiGp5cib+F0mcVSUyydG/V4p/RfIsvgLWg3wpPgE/wdWVGuI/6S2GUOsXUm5uEjnUxxFqWu5smpSk/vFdXPAsSOTFxomvDg9T+pyajcG8cCjCrS8CugYO0DyXjiiIfoEAgmx9CsY06IxUOKz8KSEohl9T/Y8fagOw+2IQBehKygvrgi09O7oQLX03zH+r0lRAwQevm3HKAauP+ikf+/GzY6uVS+yHnbWsqUqx8Zs1rTG3OFPkwgRe0n1wi7h+72JEMtDPhNagwRtSBPRUzPE1O/9GDkFrcRjO55SELbfhzp87Gv4PbXjh1f8kNdLmacYfO+U+d4WiwkGkzoja58OCx54vLINBasnn2G8q4UXmVWuCvHEV1FGYjSfpWNrhgV3IpWi5gw0rRKHxpq0MAAKqeuJFLR1xdsLTPBkycanme3W1Ynn1D+FhmUNXw89Rke7JdAcnymwDaAbCRvW4YRL9Iov/1VTjE/ZRUF0QURsjkRqkxZ/40ROyVtDHQqVcr39g707pbqgSovb868WIGYrtbKuMMys56qhObUJjjoFiBFz5Yk2bq0o0K9DflgrLAzyr8aXuPKjvxjZTm13u5wRmYpW47yKQFbPTlK5Haif6MLHCaY+M0LJpav2bK04snOzzFJ9zIzzFX+AtFN1Sp6h2gV/6gl/RpPzzWvft/U62xBTzh1gCeolhK72U29d1S8udS7UmNQvZjOqD6ARarOkzyOfnIMF18B/ngW85Cef9P
 q08XZwYS
 lPyh/8Dx7UejrAXmlyz76kMfdSaIi/c1st6Y5+vCFMdg7ldK6nxM7VIFs4JICTlSmW6LGWLtAm3eH6sXWaGanbsDfuws1ol7L9xcMUKkFla0MW/eY4BjkjGjP7eH2vOYY2GPVr5TR4MXzGUYt1q6l/fqaBNnhwThAoLzmaEJ1LASFVu9nY1XbHlqiSOD7bbuN5v/kRkzdZtbKyMvY34rdMi/7faHtO/rUlhAtByF2Fgvai5ctq3LJ14AuBgmu07j5cl8OaBz5PBOaHtqQVXw6ns/txuAKHNUYrs17NSjDuF3DO1CWduYpLtEaCUlETklB+5jtrsR51c42+mBRFIDthNOTohuhWnVLhrUY+dnpekVaAIc2akAFJ3XlQsiG/wF/OMSjXC6jGoVQ6NYVno0VXUaxDYR8LfMBq9U+q1t26fq5ZFFA0SJxmx+L1KTgwr9cgpUiRTHqd+rvhkjaIsjR0kn47Juj1t/ZHhg3CBTuoH7XjrEZXCIw0SIS3BAfRZ1GaRxWGMstFvIWXFaoe7VxaOohrzXUFjrer79LA8Sxp0jyjprzSynlXsRIm1zbuyYRGcAqqA9n0CBlX3xh+S7NGkoRI7nB7CfNajhTbo1HErcZnV/28A3ApGNaEolqgXhT/msB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use the given VFIO cdev FD to initialize vfio_pci_device in VFIO
selftests. Add the assertion to make sure that passed cdev FD is not
used with legacy VFIO APIs. If VFIO cdev FD is provided then do not open
the device instead use the FD for any interaction with the device.

This API will allow writing selftests where VFIO device FD is preserved
using liveupdate and retrieved later using liveupdate ioctl after kexec.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  3 +++
 .../selftests/vfio/lib/vfio_pci_device.c      | 25 ++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index e19bd94b8dd2..9a62bfb6b440 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -40,6 +40,9 @@ struct vfio_pci_device {
 
 struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_free(struct vfio_pci_device *device);
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 4063a0e2b3df..af789c859586 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -457,9 +457,13 @@ void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf)
 }
 
 static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
-				   const char *bdf, const char *vf_token)
+				   const char *bdf, int device_fd,
+				   const char *vf_token)
 {
-	vfio_pci_cdev_open(device, bdf);
+	if (device_fd >= 0)
+		device->fd = device_fd;
+	else
+		vfio_pci_cdev_open(device, bdf);
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
@@ -482,16 +486,20 @@ void vfio_pci_device_free(struct vfio_pci_device *device)
 	free(device);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd)
 {
 	struct vfio_pci_device *device;
 
 	device = vfio_pci_device_alloc(bdf, iommu);
 
-	if (iommu->mode->container_path)
+	if (iommu->mode->container_path) {
+		VFIO_ASSERT_EQ(device_fd, -1);
 		vfio_pci_container_setup(device, bdf, NULL);
-	else
-		vfio_pci_iommufd_setup(device, bdf, NULL);
+	} else {
+		vfio_pci_iommufd_setup(device, bdf, device_fd, NULL);
+	}
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
@@ -499,6 +507,11 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	return device;
 }
 
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	return __vfio_pci_device_init(bdf, iommu, /*device_fd=*/-1);
+}
+
 void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
-- 
2.56.0.317.g454f8302e1-goog


