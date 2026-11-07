Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B538606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B4UFVrbJ
Received: by kanga.kvack.org (Postfix)
	id C1A1E6B05E8; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C6E6B05E9; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43CB6B05EC; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1AA6B05E8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F07F120263
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
X-FDA: 85406458914.16.82A844C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E12C980004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4UFVrbJ;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011835;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJY7JgmUY6kTEuouX8pOKywnDwfciguXt0q9Bu2Yilg=;
	b=1DFSm2BP8N9q8bTN5CnQOwEUmqkXysjOlAZMQnb4waXpe/i7lSJMJQAlI41xgTB1czdV3P
	s/ERRhTOgwO3COL/5YCNwbNFGlo4xggASSEOJSHrIVdK6suU3CbUQxkihMWdZUB3eU8FA3
	8QmyA/CjyNbkfKC1b+QjWcJ25S650G4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011835;
	b=UVJEorbcP1Ol5dNfT+SYAuwYD8ASRBjWjdOASVrr+90gnnk3E6U9SjDeoyjwO0iXnO0PIo
	BxhUyR5fUn7fOPY2L5UiCYvWgs7PZMNICVkF6JrQVMKbr0lTsfx4tA+V1oQ/mfgk4Wz/xE
	OXz+5pvmES84OWKXYTwmXNyHS1qns8E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4UFVrbJ;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD33444037;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011834;
	b=Lzwke8rtQkHzmfm2D5TO1chfrpon9r2wqYJ4RpcLcWqQIcjYD4ckTllnKUEqLVhssww2
	 qeZBBnKDbRV2detZ4sFdoueoFk7+0YW/ugR7RzfyetI7waF8daDXRAr2Ix2EyA3q7vWU9
	 Rm1pzypGp0FI3q4KTSzhOTYFIchqP8hjwyCqqi9GSbwfqfxgpYGw+QgBSjlG6YBAJjOXL
	 vIU8uD7COxakrLlPjfu2wEV9nxWFDSNQH7OyiMQMUwbysVax5E+Y3eaerSkUPfp/MQAwL
	 SZSLvzuXTzHyxXC36wGNEu9JOsUjPtXBGVkbFx5qSf6dE/ABMECJ4KBz2g1Gk7khcYQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zJY7JgmUY6kTEuouX8pOKywnDwfciguXt0q9Bu2Yilg=;
	b=LnEcD9eWp8XVYgQHdK9N4yXq15wtQQah8yS6d86M6W2ib3G3F0NW8qiu2lbCAR2kOQ66
	 jKY5eXKtMIrOriq5XcZgxTZ1VUcGoe8Ns2ra6jmd9RRQTrgXLdvprOnTNWcnMZ24NTb14
	 7eGj0pLiatnLQUq9gS4s4wj33rgOZ/Hb5nuTvG1PRHC9fEZcjdnrqCnvxIxOBoneK2vFc
	 RT21LREcGJCQWb28hCmiLssyFtOYibMmyaFkSTy61vD7DauP7tYzDe5IkkwUa0Ab3CXVy
	 avhcL6rUafzrVe3losZZQW0X19KGMjtTvobEM7XlYsjpgOvAoVlw42vw8O+HqEzfXng==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 019C51F00900;
	Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011834;
	bh=zJY7JgmUY6kTEuouX8pOKywnDwfciguXt0q9Bu2Yilg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=B4UFVrbJvOUKkjPwh59GQzYlHcNAletngx9/LR6/42Ddc87G/AMlfoEjh9/9Lrcob
	 vEj6ePlHz4BzkKPNq46KjizXlxN8tHHbTZ3jjn+6N8KcxPfW1vviujTxBuV6N6G5tO
	 6r4BIZeAOp2Gc3zWAm2MtJ/8cK7mXxEWtffCjZpjVJ8Uty/pZA/u2X+tf7hX6hiZ0D
	 HCpYmRfNKRT167vCF2O47xTaBCs0NMdhLer6GUyC6FHqrj3gRO4syHuEkIAhkp0I28
	 U7jLkVdpf6Kf8UGrEgRqpc9CYqa81NCCpvUxg031q7LVKto77++JivIRpGiCNTbNsy
	 DeVRMZUqNZPLg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 00941479FC;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:34 -0800
Subject: [PATCH RFC v3 60/88] vfio/pci: Implement get_pfn provider op for
 guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-60-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3886;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=csbHfwVQmJAIvOL3JkXMdnFfqy9AUj2CCzhFEzRs5Ek=;
 b=WOkAJg7cFMQRQZBPquFwhsiqfmQ+MJXo+8XyVeu5y9SUxzhSHcejH5/SogBd1YAcut6NsIkjq
 Wb9r8OuGmI2CKiK9HL0TQjRmrP6IA+Y54RW+x0R/lWeRZxEsEgvr07e
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E12C980004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9ham4f6twagtgfkg9j6m7xab5k3be7zj
X-Rspam-User: 
X-HE-Tag: 1794011834-678598
X-HE-Meta: U2FsdGVkX18CV+2iKQN6IVey1st9mQr1A1koHrkS6jN0ppuUR9LJ//clWnuKzXWxV1qof9eib3su9AOmWHGS9Eshs4pkTwco42h6/ksHvGiJX9jGq8t2hK+PVswS9TW12w6fnd5XFH8ASx13OlEhCwtcpoL9X6RbQimGXICCa+2KJhOVn/o/jIjLMwP0dJ6fVRM09rGTu6Nxxf7gLKxWkJHukc12mSlKhJuG035ZyTC1C8IWP0fUEWgR2JgxiKfEXLTlBRKmUZjMW/n6+yXMWKIBPXtVMdhKL3MUZ2JO9+OizZ1H8kmPfUXv5PL9j7ig/Q3+7LF0Z3CjVfRlhgzIWVk2iS/YSmLLZyY2T+YbvrW512/z3qjy+MgZ9hAjMkbHlLCMUtEgXLGvkuvQCj6aCxozDY6NozOUWO/6MjyvYBT65AyAWqz5vG+iRWzLA7bBm/6c/9MhC1H0/WuSNPS/tMiNwJxk0zEYH6W9qZzwrZUwLGZQ5Cl/X6k/5u9zSxIzF46TE2TnM8v5Y6JiemQcesyagHabJCEVlHnqC6nUOW8Edvm08PJqlzOMFkMhTgAwZb/L4YSLW1ZEVlPb9TD6ECOP+RPhZDVHMYRCJzufjW55OP0vy0YYDZ9kw/Y66Lw3pJ9DWFfN7Ya6KhEy0hwua0dtM9pD+exM5NtYfTi/yITG96+3hFKAOZDLtUx45b7povH3mORlsigyXlRcLibExQtYCLM1COpyjUHaCXjcdpSOSkiedYjHtGGT015J6bcHIGDdtUHfUa+lddNiRkCXrp7ezK0OMe5I5I/DOnttASizxDaDOs18otAR/pHKtYS/DDA/pEkAzTYfSEoAncu5VJbFQcbMmmafkXNVy8cHtsMnSn5x/M5WCBIBZo7WQVbjVoWzGaWM4VaJ1dVyH/O4a9/WA9gH9XmnQEFSNEzsHTBXen3auxVl3pIquLFyyYsPfjR9tOcW1onGyl01B1+
 3pG92/kQ
 BqhB9iMr+qXJGgdA9D36gxwva1tZ3gDj4Roca0k4ez8FTjmO1M/kT3nRKIN2gbuW6F93eAOc+YNLiWLJQS2oc1HrGij9cRQ8IkwW1zNzFxabHcUjPpQq4M332J/p/nD+w0/w48HrTMA3a+1E29aktby6JPcgGZQqVLv5lmvxMQdfGfHh47w4U7eto9JKA7d8AoEnzRFCUgWqzWKgtnMBkW/sXcz8I3qutvcMNdON5MulMGhbLY2hWVkQdOO7q4ucPDcoub/VN+sDgX/cYz18o6o0dFGr08cpwNnJz/4+SL02EXJMd5P37lmuB1MoQFzMrDiAMV14GNeONir+ez35LQOyI+y1kXbhoHpw2Q10AoEf68ynFH+LydKYx2b5lWB1T+N8DZ6JB1Mkwc1CExQKeB7GY6QAO8d9iV5BuFRjNe2Xdm2Y0Nt0uG1EXt0Pmjmxsr9/tE5fQEC+GXS6MVye44S6MXmfmUFoG7RrUGizseslzPcjZBS4bslKaATIpEOzRSwxUmE5X8atrHGlwNnfITqWI9SmnxyMtL+M/fUWVatyXumheUJCUxt72FQTNGJYKgpbXvCTpd8LNmovQMQMxV8pt5A+y8xubMQtfNo5H5KkvIcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the .get_pfn provider operation in the generic PCI VFIO bus
driver to translate guest_memfd page offsets to physical BAR frames.

Check the BAR availability flag locklessly via smp_load_acquire() to
avoid acquiring the device memory lock on the fault path, returning
-EFAULT if memory decoding is disabled or the device is in low-power D3.

Decode the 40-bit VFIO region offset to identify the targeted BAR and
offset within the BAR, validating that the BAR is a standard memory BAR,
supports memory mapping, and the offset falls within the resource size.

Compute the physical frame number from the PCI resource start address
and report GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC as the frame's
caching attribute so stage-2 mappings permit guest write-combining while
host userspace mappings remain uncached.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 3 files changed, 42 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 96f438671db29..9bc8009a9e766 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -171,6 +171,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 #ifdef CONFIG_KVM_GUEST_MEMFD
 	.gmem_attach	= vfio_pci_core_gmem_attach,
 	.gmem_release	= vfio_pci_core_gmem_release,
+	.gmem_get_pfn	= vfio_pci_core_gmem_get_pfn,
 #endif
 };
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c7b67fbce4cae..9551a067b5689 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2731,6 +2731,44 @@ void vfio_pci_core_gmem_release(struct vfio_device *core_vdev)
 	up_write(&vdev->memory_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_release);
+
+int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
+			       unsigned long *pfn, int *max_order,
+			       u64 *pfn_attrs)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned int bar;
+	u64 pgoff;
+
+	/*
+	 * Lockless check: if memory decoding is disabled or the device is in
+	 * low-power D3, fail immediately without blocking on memory_lock.
+	 */
+	if (!smp_load_acquire(&vdev->bars_available))
+		return -EFAULT;
+
+	bar = index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	pgoff = index & ((1ULL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (bar >= PCI_STD_NUM_BARS || !vdev->bar_mmap_supported[bar])
+		return -EINVAL;
+
+	if (pgoff >= (pci_resource_len(pdev, bar) >> PAGE_SHIFT))
+		return -EINVAL;
+
+	*pfn = (pci_resource_start(pdev, bar) >> PAGE_SHIFT) + pgoff;
+
+	if (max_order)
+		*max_order = 0;
+
+	if (pfn_attrs)
+		*pfn_attrs = GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_get_pfn);
 #endif
 
 module_init(vfio_pci_core_init);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index c3c16459e14f4..3a6d039454472 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -172,6 +172,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int vfio_pci_core_gmem_attach(struct vfio_device *core_vdev);
 void vfio_pci_core_gmem_release(struct vfio_device *core_vdev);
+int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
+			       unsigned long *pfn, int *max_order,
+			       u64 *pfn_attrs);
 #endif
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,

-- 
2.56.0.455.g6c5a503b38-goog



