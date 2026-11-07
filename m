Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD86606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjbO4J1H
Received: by kanga.kvack.org (Postfix)
	id 00CA96B05E1; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F002D6B05E2; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED296B05E3; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD8256B05E2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FC1B8026B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
X-FDA: 85406458830.28.839FABE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3E794180006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjbO4J1H;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011833;
	b=VyWh99OzjI/6qat8r20OPB20DSOvm2cVXENiRDoGh4Hfluypa9Z1M7cZRF5bi0DDN3YoTP
	4LUiVt2ZVmHgoSYU2xt3mVvEE0NT5Qx3oVTbfsFSjRsxP0O7uEFWvjblVMr+WrDfF4grgv
	BuBzzwl9tE63jNFtC5TBD+YiIAzrtNc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjbO4J1H;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuG72beDuEe5UdHqD4ZrNRpVXqBq3yLJ4x0bUfkbdJI=;
	b=VSmOsGpORZwUtW926LiH5kVAVs9Xumx8tj6TG3mMOuHWGCOTlRJwW5MyUFE8N6OqBBrh/L
	fhK/g1zuWinSeMp/dnUzwH3sVqWeESX3P4AAaZ3Diavy/JrlTHjkJRzBNl/q9s3vGkW2jG
	gxQldX+1zMncLo9bAc7eWj4Lf8otSeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12E1941A41;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011833;
	b=u7d8byaFh5Y0xF7InkwfAIfFi19IqSBt44tCxbQt9roZI6loxnqiXxGG+CqCFmPUHAFD
	 LqKghouGoqa2oj9nA4qmgniXoc+4e81jy6O9g1FY+c3Hn8x0Ii6GKalZW5GRpdN1gawwH
	 LVEvui6TS1Ve1B1Zgr5zzCtgaD11vsaXXXvZJ2hHFlFtTSzD27xRam0TlPUjO2g2TTxSh
	 39G4jbg+qjxuuXWhRlKpuwvZ6FYskznPMEa94rBnhm+87kheMQEXyQ9mDjUMTgkL6OxeE
	 Ue31Z/R1MlnVp2v/dunHcByF3ZqMHwXkeKv6sDoGFja1aHKI6NBzS5jtOCGoByBhiBg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YuG72beDuEe5UdHqD4ZrNRpVXqBq3yLJ4x0bUfkbdJI=;
	b=vpSrcfW+POH9MI8AvF4UVPYyqROZ1wo1wEFBK19MBOlbHxdC1LJoP51Pfj/vkULjd+EX
	 38fHjPcMp9tJmwH+tG/AY0Ec9uD7Hlhl24V919ICbTeDYsdT+qxHcw/0RJpoo5Av4GDKI
	 PkTX5CphCEcW+NgbJh7vxROIGrUX/faLd9+dj6WIWm4KN6pvGwGGctUhVdqk/uLiuubTg
	 q+nWxY9b5EmGbov93XUCEScAkdczdANISOnVL13jhA6GcHZKdkZAuPO3uBJSOcqcjH4sa
	 Geaaib+N3o1UQtrLsaV4V1e4DWvseyMbUIr9MdYnEyTLq7TRdI981Wn7hWPD7sV8MDg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 452461F00AC8;
	Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011832;
	bh=YuG72beDuEe5UdHqD4ZrNRpVXqBq3yLJ4x0bUfkbdJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HjbO4J1H1UTK8LZwAXU8emoo6bvJ+08+ujoum7fzwTgzBdvZ7y0Pul8QvdL7AVD5P
	 fl+eMYml8AeE4bW2YG7Un6C9yt7UoNGFG/RofSNf5Y+NeeRnn47eUF3ExTtXJdC1nX
	 pUXgpesVz/CzGaHUaG7BKUtceP3rqofhIFYL+n24iwKZCHPa1A0pSJ9mgKX4r8r+fd
	 azG9r/es0W2uEYtfKzEq2YLNBVhJTEjqO1YrX6hjXjikE3hoPmAys8xHU0IwakQTxk
	 YpNnhkY0K0Rv0oNBHZ6c9Pguc2XixUsksuHdxmnQfVzdtks24zPi3aGE+5u7Y2LNEo
	 oRF/LZ0PJdFFw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1099B47A00;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:35 -0800
Subject: [PATCH RFC v3 61/88] vfio: Implement mmap provider op for
 guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-61-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2752;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NmjUQDJ7kwJoSKxjmguxqr+e/jaq/RcX/cxOk+5qSGo=;
 b=ba5b8oVSqCJBgb8rRqu7kCB3RfRR+uk2t9fQ3KTkROGoJJH8hNBnYw4EeYlCKLYDIRbTG+TqQ
 U//vSQOeCyaAEsC3YXGI+uXDVq6nwov9AsvUY9W6m47Yc0A6asX98wj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zqq1dsimf3xm4sr4imn87tgaprpy47zj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E794180006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011833-777970
X-HE-Meta: U2FsdGVkX18X5yCvdQ73qVNQvgLWgiO+ARZLKBkv51TOiCfSyaK+8q2zL6hDTLNdk1iHHBS9zdW/t+nL/ltPBNVpc6RLwhEhkmMZJMcjhOoILFIyA3moMh7XjMLwCzfVHXjyLe0dtdF5jQPXqKGHksBaYkj60qaeYI4PvR0ZSj/K0wo9dEaggYbTCR5t3ynRYdr1zNiFZBPrqjMQ696v/pzbq0PEAJ4SUxVXNGHk0efg5CnllRMHI1lDSHDv7+35NM/18XscXZZ5KZCc5MSqlGvnSAyquCgKDW6dTL9mh/KUSAEgHN8UMrcL4Se36Nq8WzCW7za5XoUaXN9V9OXRuj5LpFsJoRllyLVN15A7EOapGOVeZpQqPIiqySgzAitCQxaoklYfDxA2TxVgIeiag8yAIpmPRW5aSr6nW01E43p/+mdpLUjClxXAEz+mvxqoaPPzPqltYVANAPELvdLsAElm1lenkM3eXEOhMYq4ugm/aMMye0YgyICO323ONbpcqBBLOqFygI6hGki+VaICgXynSzLNOhvEVtPtepBZ0Gn6MPpRjKxJXJfab8wqOPVbNVq5pyVD7RRd/DOV39X1dwL+nrg4GuF1yd3ATUneRPhlnakCHTkyb1FtWSYsQ0uZ9XuNliNhebxCqCgJ+vveAUctu9ngPPcq7WAHDmxHqZTiVLIRNJ6UcM10MR0kl54luoe5axBjFi7ZKXK9f6TzshrPUZ2aKuzdMMta3BQ2xJCAQLp3Zu422Vk+dXxm+NY2j9aduAG/EWPK7g0g96Iqq/JfGRHjyIajdvwlrqLdQfrLCOs4dRT148glKwEzqi9MCIYe9CF3a3HCBDU5l5/PlnNyEM/tlrKUbSoo6TtGELDLh1LigLGHhOz3aXbPmGIZLxRkkBbrh+XsXXsXIyWMXUvdtHku16qrVkp5Z1S16ONrdE2RTF6VKXlpsVPkWXp35nAHcmvFmaVfLbUCJQV
 MC+ovMz/
 1LaTkhhCpS7Z6mCvjg+NyPlqLHMVS2ruE2Ce98CSsDkeHNYfV3omD0uzZbWzCMPVO/SvplGcDJkTfM6nBd6PYqMJzaPN31KXgaoPRTbyXBSuDwGQ3qMH2AMpl1TJ24UWlSga7U91mRxiiPIC6jmPSlMc/l84xu9ZO9kKqELilX72urgNf0OnzwwhUOcTu6dS6mnxHMWS4IYCIyXS80zDmdWI0UNsHZk9v5G7LwUfDmOFw+DQVaAhiFTd1HehxH2Yas4+o3NnEReC+ZAVeIL98KNoQjZ9VgKND2ZN4aRzJqKEnIrJ8p6HX7psVzBnBoqfqqdyU417gG1yf9TvAFf3z64RCXLM2Z1zeZDKwaf+c2r3N/iQy9RgAQIixyYmknAiqpedxoCehtU7HuGQOD0oVDr0+UxpiP8I37d/2X2LkFNIAc2qgJFQFPNSLy/nk6S04keGxIN2VGczAnx9H3W0FMibMEidvNR6GthlO8g9yVApTv8mvvZi0ywiRBvbn30NZA91cdbW5oLv8wHjVM28bcLUMecVPPTL8UpvOqAjGiLfw9VhSqWGSXdjiaEpXXDbFFtmlRQZbEMZKz65sDopcvTyK8n+baUlXZMys1fGLNcZBBzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When userspace creates a shared mapping on a guest_memfd file backed by
a VFIO device descriptor, guest_memfd invokes the .mmap provider
operation to allow the provider to configure the VMA.

Implement .mmap on vfio_device_gmem_provider_ops by forwarding directly
to the bus driver's existing .mmap callback on struct vfio_device_ops.
This reuses existing driver mapping setup and region boundary
validation, such as PCI BAR checking and VMA flag configuration in
vfio-pci, without requiring bus drivers to duplicate mapping logic for
guest_memfd.

While the bus driver's mapping handler sets its own virtual memory
operations on the VMA, guest_memfd overrides them with its own PFN
virtual memory operations upon return, ensuring fault handling remains
mediated by guest_memfd attribute checks.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 93bd0a200ad22..979ed69c5ebf7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1503,20 +1503,25 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	return device->ops->write(device, buf, count, ppos);
 }
 
+static int vfio_device_mmap(struct vfio_device *device,
+			    struct vm_area_struct *vma)
+{
+	if (unlikely(!device->ops->mmap))
+		return -EOPNOTSUPP;
+
+	return device->ops->mmap(device, vma);
+}
+
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device_file *df = filep->private_data;
-	struct vfio_device *device = df->device;
 	int ret;
 
 	ret = vfio_df_check_full_access(df);
 	if (ret)
 		return ret;
 
-	if (unlikely(!device->ops->mmap))
-		return -EINVAL;
-
-	return device->ops->mmap(device, vma);
+	return vfio_device_mmap(df->device, vma);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -1604,10 +1609,23 @@ static int vfio_device_gmem_get_pfn(void *provider, pgoff_t index,
 					 pfn_attrs);
 }
 
+static int vfio_device_gmem_mmap(void *provider, struct vm_area_struct *vma)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+
+	/*
+	 * No control- vs. data-plane filtering is required because
+	 * vfio_device_mmap() already only allows mmap-ing the data plane.
+	 */
+	return vfio_device_mmap(df->device, vma);
+}
+
 static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
 	.attach  = vfio_device_gmem_attach,
 	.release = vfio_device_gmem_release,
 	.get_pfn = vfio_device_gmem_get_pfn,
+	.mmap    = vfio_device_gmem_mmap,
 };
 #endif
 

-- 
2.56.0.455.g6c5a503b38-goog



