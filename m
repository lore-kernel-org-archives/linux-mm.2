Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8829606A838
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MnYQ3Z5r
Received: by kanga.kvack.org (Postfix)
	id B2FDC6B05FB; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B070B6B05FC; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A85F6B05FE; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D92C6B05FB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1755C4021D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.24.C50DB81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EAEF1C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MnYQ3Z5r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011840;
	b=0CPdDm+m0dtDdhDVoj0i8hM8o/VIRgi3Bb/Fw+nIXi4pM5Pl6YIjqEmUgcEUZFzVU37JxY
	Cv7wQaxcVc83X7hdiYzv472kJKmtr5XJbeg3By7VXI3t1WYTiKOwcPFqyotGdEbPcocvI8
	nd537F5CjVxG9IehDPm2Mnl8KO1uiS0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSzCvt8WQqpzBuP3J/NQntpezWM4rdwAQRra0I/Idek=;
	b=NBaj1uNwYIXoDWiLambKLHTVUJIsAvUo1GLjP231mu6mvcExTC4DJLTDAy46vMuP0GnsEW
	Eldjdd1YtDeYHKYxYc7gPMrLfk+EonFFN0PC0TdVPhbA/WmthWfgJwZeEh4VIgq2WtX3Kw
	N+W3yxGujFdX6TkHo78yq+7tfU8+Www=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MnYQ3Z5r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3604F4195E;
	Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011839;
	b=KrAYrNLBi7d1PD7L5Q1JOQKJfxAGkuDDQ03hvYRyuH/dYwMdSlr2F9zYbVF/gtm33URB
	 7KkQp/Yqn6yTJ9YFap5Jf0/VQTH78MxLLknvwRnLzuQxXF4InMkl3szTmrgJU8hfBrrYJ
	 v7l4i5JaKMLgcgbHBff1rkmtgRw0jkzBBJGWpvP9YiggLQb2j+M2KtfIFtlJYDymI40gf
	 zeOVsPunl5RPQmAH9jBqB4qvZ9yy81ILv1Y2QSRiFP0gkBvZPlkV3f1FDji2j3ssEguaF
	 pg7WJuAHsUBH632GjLJm48bL28mOzICxYlVRnsRxDHhvrS7+p6oFpFGebHNrt8tz6Ig==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KSzCvt8WQqpzBuP3J/NQntpezWM4rdwAQRra0I/Idek=;
	b=xcLkA3wwlqpaKCyRxPJNMfvK/gkCVUQk6hE0f6nFBFq2b5fUmkbV+I99/LrxQLUg00uV
	 opRfzVKJQDZv4/1VO8s6dUazNshPLGbNRZyB64/B4d+i/eH0tb3nPlrRdOI+6gdOBVgV6
	 e/RHHphClAeMhZoBJElJXC/VYZ+cnRsMG4x5TzwCiUCk3+y2Y1oFpCPJKgpAGqz1GYsoM
	 VVGA6Oede0nTXwsaIm7d/AAqTEkSNvxtHfACjGRK7L0irVANKDWssnhuuapjpGmM3EbLl
	 nJJtWpMABkhLWcVIx0ybqhzypd9wa9mVQXZOnQeZu04A+naE4tF/Bx28AQ4eTRIdc/w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 069831F008A2;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011839;
	bh=KSzCvt8WQqpzBuP3J/NQntpezWM4rdwAQRra0I/Idek=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=MnYQ3Z5rSfWFp59+l0g1SybbhKh9PRW9YHbrIppFTWa/HkXHtR3wvQjIEqPXdrjOs
	 AIs+CKHU5Z0XotS3FubdL6TpFaLONpq/yRrmrCrfu+9I/LlQOtQP2RYKicNgoUPREy
	 061mphxTa9LqIN0g2dhnHNxgBQCFjC9+cajEtxnlkyhwgpvtxCqX0YW+2H/LvcjnzT
	 JQc2IiCSrEXf+juyUlTkkWEJnGlMcCu9UEyrtiMvNSUUQqjsUL6UwK0Smtbl1tY3fa
	 qr1nEXNOjtmov2gh7hce6aNilqD01WW2q4Bcd2/B3/bkJNxtGx5sQzik9X3usSsPx5
	 qA+7MTlEmn1dw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9DFD347A24;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:44 -0800
Subject: [PATCH RFC v3 70/88] vfio/pci: Introduce vfio_pci_bar_rw_kbuf for
 kernel buffer MMIO access
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-70-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3928;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UIlkF+Cr22G3+Xr2iBhEh8LcRpc3sGqQkL185U7r+lA=;
 b=+kFt+aQv22Fzn/rAHsafa1OuVqSafNgWyqhLjRHbRfa9pHHNKcUImie1vu/kp7shzbDEOq5Ui
 o/cvz/JgZIMB7fndBfMPCP9FpzvLu83/5upSc1Qy9/oaTWLV4373+Kc
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAEF1C0006
X-Stat-Signature: cwymwzer13jr8zzxw7bxcmnnrh5aeg3k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011839-671376
X-HE-Meta: U2FsdGVkX192hz7LMXQOMx/mfqSSlm0ieBKt1+swu2m2G3KRD0Gu1TEhiYzSxE3VBDIiI1ZY3INcvSpEoWXqSx5Xw52LCUsRnsVT1RO/zH4OuTvBrp4U2XBAkWKBCYYEboMXq5Z5yLIkb/kN8snW4ysPI/l9jQSW0gWdrD03Ywysf0rQubqMzduOQYKToj4XUULJJzBszhary+OdvO5tzLhsFBOO5M3tdBiRKtDPVY8a+IVrsx4uL5FeBsnwSmvLMGLdLwSVp9SOZIQljRsb58NyHyBB1wrSh/wARg5Hc1uO4vwUS4VbDMHMV627qMR61984YyemEynwxM/wiz+/UAIWvFSpHMIgPVxdwVo6AbEf4+F3Ad1kDnRg6d80F74l3PL5I/0VLM9q0fEa+CgdRg3/h9N5hhHh1WjQSG1DAMn+RO7YHbGo37lz+z2HGjeqXjj0nrK/5MDEKJ1vYyzW/AE6FKXoRzAdmV4G3SJXL6JzQsc0LRy0XS5OXxwK6O0PzuQ09hMvbBPdfhM1KwY6eDMo69d5RMtpFehm4kuT0oWMpeas1+OucyJ69nfnHj3tdU1mLFYpbIp7AXgulFTsQFNkvYZmc9nacZapzHJQyJYyABJG4QMz0AwVxKeyd9c+C/p4So3M1Gwr0i4hqOidmza8xgnc2kVyedu0/uQ37wOZcvQj8U3z+vi/mV+ComdmpmYRT03N8aFkOCko8NlXu7K4m3qgsa7MOSKU5tsV4IsYew3d1dmY3uare2fOTsw2NF2NMb6cAyWuEdwl0Fuy+N3NhL9Y9j/4IeZGyYK0jA0Ux1hs1CLpsmQ0FDru4JWubzMHswxLCy2IfM9lPJaKVBh6yUvHszj7N7P9Kh2I2kdOhNGKA2oWal53rmIfsisRU8XGHnRd/LB0JDwK6AJU/tzlHGGLWlRbWlzB20RAtsnxtyU6HKbYlsMqsM+fIS9NuSVqdbeR9V4D8RW7zcD
 3YxAskEp
 WUF2o42txjq5G49n6iucNcQHFbYbe5KnpaJwzGj94tAO8sIQa3HpRJpylSV9gPQ79qwjoLjd6q2R8owp2Nxy0H0hHvAqf0vy9Y7FBeS7NjPnkt9o/RK60KpXgFKXRRqdflbTQ4tP/Xjb5BqwC8cmHUk75eVNOJRTYaHwkPZhqjIIyIiQPYSzG/5JkUrlPBl9DnmiK7+DYRCPIq/oiJj5pc90xZjHtShrGh7B2FuRF/m2FdIA2lHppTBYy7CRCkBw7mpZE3o24I5rMeeY0clDwGkr3EdMwRYcEDeCv9L3u4XJ/XscfK+N5PU2xY+Mb+hdlLNzln5GUK0kbDGyesGy/T3HsYE8ZaMwuSoDfBcelRNk3zBidTFN888cTnh4lSEvkHbkKz0Fp+Wizp3Q5hWociNKGyX+XVJVtxz+Sy4ja/mCY2siiJrKc01sWHQW9RCKhKq6yfADVCrmN3gwjlneGp/ikFRWdRahDqimcUpNxZGWmsxYvoDj4Vmc9e3RwpwIDgjcbX1yFOx1/73jLNzWZueqfb3mQv+Yb5PTIe+Uufp4l9r6wcHLee3dYXDHZHTiccjr634p64SZ4BvbGnKb2hQienockwQpg5URd16qU1n6bFWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Refactor BAR read and write handling to separate the core MMIO logic
from the buffer source.

Extract the core BAR read and write implementation into a static helper
that operates on an iov_iter and accepts a test_mem parameter controlling
whether memory decoding and power state should be validated under
memory_lock. Retain the userspace interface, importing the user buffer
into an iov_iter with test_mem enabled.

Introduce a counterpart helper taking a kernel buffer and setting up
an ITER_KVEC iov_iter, allowing callers with kernel buffers to read
and write to PCI BARs without userspace pointer conversion or copy
overhead, and to specify whether memory testing is required.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci_priv.h |  3 +++
 drivers/vfio/pci/vfio_pci_rdwr.c | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 607a33270aca1..48a068e68aab8 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -53,6 +53,9 @@ ssize_t vfio_pci_config_rw_single(struct vfio_pci_core_device *vdev,
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite);
+ssize_t vfio_pci_bar_rw_kbuf(struct vfio_pci_core_device *vdev, void *kbuf,
+			     size_t count, loff_t *ppos, bool iswrite,
+			     bool test_mem);
 
 #ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index cc64722d1ab9a..c44c78e48e6aa 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -221,8 +221,9 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 
-ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			size_t count, loff_t *ppos, bool iswrite)
+static ssize_t __vfio_pci_bar_rw(struct vfio_pci_core_device *vdev,
+				 struct iov_iter *iter, size_t count,
+				 loff_t *ppos, bool iswrite, bool test_mem)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
@@ -284,8 +285,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-				      count, x_start, x_end, iswrite, max_width);
+	done = __vfio_pci_core_do_io_rw(vdev, test_mem && (res->flags & IORESOURCE_MEM),
+					io, iter, pos, count, x_start, x_end,
+					iswrite, max_width);
 
 	if (done >= 0)
 		*ppos += done;
@@ -301,6 +303,30 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return done;
 }
 
+ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite)
+{
+	struct iov_iter iter;
+	int ret;
+
+	ret = import_ubuf(iswrite ? ITER_SOURCE : ITER_DEST, buf, count, &iter);
+	if (ret)
+		return ret;
+
+	return __vfio_pci_bar_rw(vdev, &iter, count, ppos, iswrite, true);
+}
+
+ssize_t vfio_pci_bar_rw_kbuf(struct vfio_pci_core_device *vdev, void *kbuf,
+			     size_t count, loff_t *ppos, bool iswrite,
+			     bool test_mem)
+{
+	struct kvec kvec = { .iov_base = kbuf, .iov_len = count };
+	struct iov_iter iter;
+
+	iov_iter_kvec(&iter, iswrite ? ITER_SOURCE : ITER_DEST, &kvec, 1, count);
+	return __vfio_pci_bar_rw(vdev, &iter, count, ppos, iswrite, test_mem);
+}
+
 #ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)

-- 
2.56.0.455.g6c5a503b38-goog



