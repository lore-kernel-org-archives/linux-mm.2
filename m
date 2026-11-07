Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9039606A808
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJfRbRBs
Received: by kanga.kvack.org (Postfix)
	id 6C3976B0603; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B756B0605; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AD16B0603; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD156B0605
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A192240288
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
X-FDA: 85406459166.06.9F858A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 99D3A40003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJfRbRBs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBhGX9yahIbsDDFoJ77ldQTuDbT5tg0ODdJhu+0F5YI=;
	b=LAjEZuPDq+H1j9yrNVuo86EVMDzoDCVWKYIu4jNz0uZZHFLxu5QAfHD/7a8YYpV/2xlQ0w
	mKmkHaXavX7lL7TY+m+9LHD3kNZ7VxdCw/2nr3iCylkm7flFgTTLw5l4+iRjkWDc8nG1tI
	YX0DTvoW3v/8w3LxsT/AbTFBWfGPFEk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJfRbRBs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=7MkKAsybLlxua+eS6iv9/8ufybEvHq0N2gvuPNcAoY41TSPIA1C7Iv8wNTqSHr88O83prH
	Ja8fZ69AbE1+YPmX+ZbDT8wDMytfZQ3RfpKGRWiLPxMNRq3+SzopjkDgYKoGt7G5ByI+su
	aYIEK3vBJiKK/zURT9VfsNQLElxwbXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73F7060D69;
	Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011841;
	b=IC5lsvDwnO2pljiQ8KRSVTp+eYwcw0v648FfwXl3Cz9Q2ibruvVi9ivr8QOqCsPaMjM6
	 hrb8EFaGVv0h8oanUHMbbvs3ojPRoGqSYFF+9qqo1qZmJiaZghj3jZhRfGGVy6wAt7P52
	 ftOTMfNBqS3rMhZtvCmLPHgBCHE5jNyedeoqePB+DrwJmVRS8f75/kJUaAK2tsCJlOODy
	 HO74dA8K4Jsh54juIFKgszuG+4hD+73kXvG+DH1b8tNlM9HfFS1ZMdUoq6Lt8pwRTZ1PJ
	 59t1yPpTeanny8x5cGOGkXDID5aeAME1jTVFKn5lALF52KbdoGyNuqgpRx4WaaYF1Hw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011841;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KBhGX9yahIbsDDFoJ77ldQTuDbT5tg0ODdJhu+0F5YI=;
	b=g7e/2ed0nT/KRKyjNgSB4IgD69SQO87AmMBpcMFwZSC77+RyS0PVDkf3gHUwt43MtAv9
	 rkzRszeTiYVG9HV8DLWlv8xXZVVqtIsrjCt6+i24cQwIjcp/rofUsyXzCa5g7lSLjViR2
	 FRGvMZT1nz2ZVwQf3txqvJgPoV6h/D9+WF8gJt3dpGwkN4PT4XSB3xP+VLoT6hWqDys+w
	 Hn1tJIuv9AQZHTaVIUEAekBpOs5Ce28SoIRnT7TBUjJpOtlF0UPyZLsCzcvCKRX3jr63q
	 QG1iTt1qtL5FCWIfWlrU+F42hiWhWlf7xUUGxguuRX8pQg1CmLtqQdo4g4l5I+3MZVg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B46E31F008A5;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011841;
	bh=KBhGX9yahIbsDDFoJ77ldQTuDbT5tg0ODdJhu+0F5YI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PJfRbRBsq/zArvX5SSV+AJJfmzGv9LuvVropQ9uVhaGW2UaZraSUeBXfQXme3+Vbi
	 QkUVozbzOKTFF+eAMYVXS6RufAEJjovCp22DfqPvN0nu+2L0CVG7Fv9gDXHN2lRoJg
	 gQ/AUjNegaeg053dDeR5AfM4WDhqVLrYDdNL3ldZILB0L16zLo7+PU+nrT0g71QIiZ
	 8CiEhzow2gzKcPG2jJ3+XSnFwMG79BrvP0XpK8+a/G9VJqOrDhzXsMxv1qsSq8gr0C
	 lfCKfa55VYwYhjPVFr0P7aPAKC1+JXKvEcHPLzy556276iptGc3iO62jeh1a4aKx6y
	 3blMeeEHP0KHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7D8DF47A1C;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:42 -0800
Subject: [PATCH RFC v3 68/88] vfio/pci: Use iov_iter for MMIO read and
 write
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-68-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=6301;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=c4VDLuT5yqC8DJ1fpMzzzVy4zLcf9cySQYtbQA4hk74=;
 b=L5BjRew5q1svkShxrjXUHUJtKZ/8fmvjKLgv7L6S7iOvEcrS/PClvlilzhXkLk+16KWEMf/Ny
 1dJMQc+3f77BIvFJT8Dpz/JuqAKav6jhjhEryI/df80j9npQPqOyeF+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99D3A40003
X-Stat-Signature: azbwiintg5ybqsfpmc9jkcjkd6oomqco
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011841-909759
X-HE-Meta: U2FsdGVkX1/Fa5UG+4Z++p+ucfBS+IGC502dq1+6AynyJ5ROq56+GuR7OMuBZfGORSWsQV2mzem2j3ozoIEmSx1G9DbwwRFcspbfxCegeYE/Kz+qlfXCVfoMuQRHL2YLws7AWsN8fO+o6gifuQy4TdXgY8GJGfvGG/j3nefc3kAScYMwNpnNWDZeW6gE7pmmDcs8WM7xYXxsGn6VESdhuWtSZvvNriVrAnevxgL9x3+KdlzmQQZuSJ8eyILHu1KAHOtouWmuVY0Oe7C524Zk2fxzdfI9dH8D7vvRukpwmyLteHEc/8xppC63bb6DSvdkKc2FRpoZWnDIXQu+mY+OpzFTjDh6TsNe22LqenCWj1O9ft5dbC4pGO0fekszoYAKK5O9S7LSd8dstzj47xywYD7V1zA65ZGLlrBCMrXXwuUC1qi+A3gTdrfDu2nZufrXQNkIEDdq+h7faW2xHxfLjsBCw7/ZYMzBw4c8DCu140Oa9pRRAPtSbh2neIdrzVvckRrSk2j9a8OUjESPz54tmD0NVEANIE0eXeKkVbIzUwmp6XXJRd0LHuBLwZxkfNNDuhbIy90h+BxvJj28bP5C1jXkBjn1679UIrv9VNXWKp25izHeXO3v/epaFGHuOSWoJuKOPdemPMwliucr62m6jwSzvGili1LZu6qUK4NLiReAvN9IejrKFr17CA2tfClvKInYy3hXMCwRBZu214J2JWKHbMx38NMYpYuYcYMM+AjuU+7kPbifrV8+cMFWkUI/FMbxptcTMITFMmEWZefzg9opnoqBe/PPqzPKViSdV1DGv2qs6nvt7xzpf1lgzA3+lDLQF6vxKuOrX1DevxTdPe2MsSldf4pm1Fj/JyV9LmUjpxJ5t0mujmR5wwH+5Eb6MM2hY6IIQMRUK65cf/5lGj9bUVteWG+Fh0WmdzuUe9rmGUphgT01uyh8tbzopd4I3eCvABquEoexitjyiRm
 MRbYYsiA
 KTF1lgRUOhIqncXlOuIY/hmsW1WiPcUa4rFfG49r+YXhm3JxKtBC8lbwKV46RAqmXRuYpcV6IhTF95NP++JVOrOlPZQjsPePu8yPynzzXzPnV1hb2kT3u6QL2kX3peDuPkos+JEgfxBAx4AwfR3PkIBw9686ZGgNduInl6CyJetT76XQ9rTZq/OyV530nj4lK204psf16D0qKQnZlsNzVJ+XkTLVGkLvmINK41I0Yl1I08aTKa95l3HGxmN3ZyUUx0+6OXvNaNB6BfgyjBfgwP9WBWlrMox7kDAMvV1H6T7LLFI7LIx3/mYUe8ekIrimx4E2xBGLWA/hkK+uQ36T654K23IXC0RrLr5mgsVXcSchurJKA0c+AkyjGJuKUTCCc1iN+0TlMJVKZJLMahm5B19O4SLWn8taHTtnSpxpQgQ7PvV9dlthzur1i3SmPfjo0xSwaIhveCZAr44afF9LJ2CzaRIILhY92uDQx6KZYpvlZTnEVH28qp0Q1XR/knGPDGCKtaJwtlNASMGURKn5l0wy5eRZKnFQUKtUQljuq5EkBr9MReSwmJPxUp2q0MUccTsjwI0ypZwMDIWyW8a5wJ8k3OSLIImp70pvuN5HEZcZDGrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Refactor the internal MMIO read and write helpers in vfio_pci_rdwr to
operate on struct iov_iter rather than directly calling copy_to_user
and copy_from_user with user pointers.

Keep the existing vfio_pci_core_do_io_rw interface unchanged by
importing user buffers into an iov_iter via import_ubuf before calling
the internal implementation. The overhead of initializing the iov_iter
on userspace accesses is negligible compared to PCIe bus cycle latency.

This decouples low-level PCI MMIO access from userspace copy semantics,
allowing in-kernel callers to service I/O using kernel buffers (such
as ITER_KVEC) without user copy overhead or page fault recursion.

For delegation of read/write() to guest_memfd, this helps avoid AB-BA
deadlocks between mapping.invalidate_lock and mm->mmap_lock when MMIO read
and write operations are invoked under filemap invalidation locks.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 107 ++++++++++++++++++++++++---------------
 1 file changed, 65 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e5f1f60513709..cc64722d1ab9a 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -91,34 +91,34 @@ VFIO_IOREAD(32)
 VFIO_IOREAD(64)
 
 #define VFIO_IORDWR(size)						\
-static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
-				bool iswrite, bool test_mem,		\
-				void __iomem *io, char __user *buf,	\
-				loff_t off, size_t *filled)		\
-{									\
-	u##size val;							\
-	int ret;							\
-									\
-	if (iswrite) {							\
-		if (copy_from_user(&val, buf, sizeof(val)))		\
-			return -EFAULT;					\
-									\
-		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
-						  val, io + off);	\
-		if (ret)						\
-			return ret;					\
-	} else {							\
-		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
-						 &val, io + off);	\
-		if (ret)						\
-			return ret;					\
-									\
-		if (copy_to_user(buf, &val, sizeof(val)))		\
-			return -EFAULT;					\
-	}								\
-									\
-	*filled = sizeof(val);						\
-	return 0;							\
+static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,		\
+				bool iswrite, bool test_mem,			\
+				void __iomem *io, struct iov_iter *iter,	\
+				loff_t off, size_t *filled)			\
+{										\
+	u##size val;								\
+	int ret;								\
+										\
+	if (iswrite) {								\
+		if (!copy_from_iter_full(&val, sizeof(val), iter))		\
+			return -EFAULT;						\
+										\
+		ret = vfio_pci_core_iowrite##size(vdev, test_mem,		\
+						  val, io + off);		\
+		if (ret)							\
+			return ret;						\
+	} else {								\
+		ret = vfio_pci_core_ioread##size(vdev, test_mem,		\
+						 &val, io + off);		\
+		if (ret)							\
+			return ret;						\
+										\
+		if (!copy_to_iter_full(&val, sizeof(val), iter))		\
+			return -EFAULT;						\
+	}									\
+										\
+	*filled = sizeof(val);							\
+	return 0;								\
 }									\
 
 VFIO_IORDWR(8)
@@ -132,11 +132,12 @@ VFIO_IORDWR(64)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
-			       void __iomem *io, char __user *buf,
-			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite,
-			       enum vfio_pci_io_width max_width)
+static ssize_t __vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev,
+					bool test_mem, void __iomem *io,
+					struct iov_iter *iter, loff_t off,
+					size_t count, size_t x_start,
+					size_t x_end, bool iswrite,
+					enum vfio_pci_io_width max_width)
 {
 	ssize_t done = 0;
 	int ret;
@@ -153,25 +154,25 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 
 		if (fillable >= 8 && !(off % 8) && max_width >= 8) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
-						io, buf, off, &filled);
+						io, iter, off, &filled);
 			if (ret)
 				return ret;
 
 		} else if (fillable >= 4 && !(off % 4) && max_width >= 4) {
 			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
-						io, buf, off, &filled);
+						io, iter, off, &filled);
 			if (ret)
 				return ret;
 
 		} else if (fillable >= 2 && !(off % 2) && max_width >= 2) {
 			ret = vfio_pci_iordwr16(vdev, iswrite, test_mem,
-						io, buf, off, &filled);
+						io, iter, off, &filled);
 			if (ret)
 				return ret;
 
 		} else if (fillable) {
 			ret = vfio_pci_iordwr8(vdev, iswrite, test_mem,
-					       io, buf, off, &filled);
+					       io, iter, off, &filled);
 			if (ret)
 				return ret;
 
@@ -179,23 +180,45 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			/* Fill reads with -1, drop writes */
 			filled = min(count, (size_t)(x_end - off));
 			if (!iswrite) {
-				u8 val = 0xFF;
-				size_t i;
+				static const u8 ff_buf[64] = { [0 ... 63] = 0xFF };
+				size_t cur = filled;
+
+				while (cur) {
+					size_t step = min(cur, sizeof(ff_buf));
 
-				for (i = 0; i < filled; i++)
-					if (copy_to_user(buf + i, &val, 1))
+					if (!copy_to_iter_full(ff_buf, step, iter))
 						return -EFAULT;
+					cur -= step;
+				}
+			} else {
+				iov_iter_advance(iter, filled);
 			}
 		}
 
 		count -= filled;
 		done += filled;
 		off += filled;
-		buf += filled;
 	}
 
 	return done;
 }
+
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite,
+			       enum vfio_pci_io_width max_width)
+{
+	struct iov_iter iter;
+	int ret;
+
+	ret = import_ubuf(iswrite ? ITER_SOURCE : ITER_DEST, buf, count, &iter);
+	if (ret)
+		return ret;
+
+	return __vfio_pci_core_do_io_rw(vdev, test_mem, io, &iter, off, count,
+					x_start, x_end, iswrite, max_width);
+}
 EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,

-- 
2.56.0.455.g6c5a503b38-goog



