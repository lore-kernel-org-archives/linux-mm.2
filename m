Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9245606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqR0yZBG
Received: by kanga.kvack.org (Postfix)
	id 22F8E6B05E5; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208326B05E7; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032A26B05E6; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE8366B05E5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 658F11C3083
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
X-FDA: 85406458872.22.659102F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B79220009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqR0yZBG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011834;
	b=SJVaKNw2D2Qy7YPNCjwi1LYMU/0NcQxCet/rKtWhnR9T3rtUTjxuOfnHyY9Y421DfL8Op7
	l1NNFkg28tV1pT6LfzG4eIovLPEzogjRujd5qkfRBk5Nw+cInOrpMvTwk1o1mneuJ/jLJA
	/dAEby91f4UEsRXqm2eF/pW99PxpuHA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wUojUUQbhfKIFXbbfP6LPWOjX5Iaf2r3UNVYHxBruY=;
	b=BiE8y3Xjfls4J7Q4eAe1bCmPhveXcKQGkwEw0s7wh27BVhBZW5NYOFF8CO3KuA6NeLzkX9
	oAx3XLrpH6cZr6B32ks0yYfns8H/zj/uR1qzTRlgbv9t6vUHt8/KvIavduohsS4oyW9n7a
	yJERtUG/h6mOgH2SpDL7VHr+R6pjHsY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqR0yZBG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB65F60E1F;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011833;
	b=oLWrvkI4tuefU+4aBCp6uGE+iRdA/QNsyBsNrWtRTbycHgvStlWL8yzI48DO+l5eGL7F
	 jO8mqNeZiilZExpaP5xkquM0cYEWkF22j/PUPkxgYVOjDo8xudxe6UlPuG9yWQbQm8M4c
	 4RPKR5LMyrMFxXsDe7LfLMYDc3l2KYvhVRsTs6clpoa38A6UviHLGPsycPORCxKsKSNvz
	 6W9CbU1U/fKY66aZoBfocvmb6wgvYAz+zh6yyqog8aKOlLoWy0Ao76ipYbebjXkdO9mPA
	 MsZ97whmAgNQdtkBsxYvkBXIC18S/O6OgF5XOQy30fZxAbLBWKBJ3mMWwqPyzibqbLA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8wUojUUQbhfKIFXbbfP6LPWOjX5Iaf2r3UNVYHxBruY=;
	b=C5mH2h6/sMtWYqK3QUFQShBVbzRq6fBQQnZKqoLris3RcGu/rttN4v4wgM0WDKFddOEH
	 Sp4G24XJ6c4cFoiH75qE95eEdg3qfRfsBE4VoGRGCr4UIuGvYBiqcxUkmi757qLrwiTHO
	 Pcj1kTib8rea5iC14ro6dqjI+kW92ZKH5wca2ZvZzACvETE33UTeH4RCnAuGRl/aA3rZn
	 EYjWGQlAVOa6NJJENlQeyslEhxVDD1bN6COs7+bXZOLApquOiy7s7aTxoWsTiIpIFlmi7
	 3prhmY1V+9zvDbCck3fUvvIgdASCtGVcsZ458Dd1Nd4i8ihtGmlf1M9J1GnzBcDM8TA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 187CA1F00A0E;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011833;
	bh=8wUojUUQbhfKIFXbbfP6LPWOjX5Iaf2r3UNVYHxBruY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iqR0yZBGWzgyjp+HYhCfGxAhrs+PJbiGs+QiA4n6lTpvdeMsOo9AhwbEjWNIDcSV0
	 gwrnIBMm4oKX4IcsmVbVx7xfsFgFonHycwzyImkvW/k5P9envjsL1kToym/4CQLUpQ
	 BTV4NYjqpxQUiCdDs6BNG4wVqI3lag+3wsdjrtqD3U8jNKxaSbiVu6N398jP3ss8f8
	 GUSSTPagfzJoEZYMVBCDC59uwvjBgTpFAL45zWvp4iczXi9G4+3Ag2tSO7fyIyvWOx
	 vJTcaijlR0nSshDR22w+pqH8Bjs5iXcKzGhT8SgOmuOgvhDxZtJ3zlXtH2FEQTByXq
	 o2TtG8u6ZVasg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2FE4147A08;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:37 -0800
Subject: [PATCH RFC v3 63/88] vfio/pci: Implement check_set_attributes
 provider op for guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-63-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=5833;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=TMwTUp5cqKcj2kTekFr4TruFvpaWuzNv14YEyWz6eMk=;
 b=UbZOzxtTC0NPZ+730r8uhK3++yIyJUWwAWmy+/W4WSFvCFPEUZshY+F2FUPkeQ5iFwFW9Lu4Q
 PXLtOpflYs0DIUR68SWBUFmgEcb08Fk5N8T/UABlrAzf2Oaz48/TkDa
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B79220009
X-Stat-Signature: p8ng4y8shn1966uiy4e74jtxtq8mjkiq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011834-768882
X-HE-Meta: U2FsdGVkX19qP764O55cf+EK/zT1E7FGd4gNCMB+dXnTAahtF/EbCFOivhr1SDLDqQ7I2ga+r/FihcPLr9oZ/FfIpFbTcxCq1UzXp1PnU8p+bySc3IUUWKwXWZyUYdPTAfhqzHpAOySSpEq8cMeBv0TtLFFFL43sH9CGKnWmTJF9QXu++dAql6Oh8RxAzwHCv1i3uuba0KW2bjW+nyIviSdEYebTgoG2HXdo3TTHx5B2UYnGdrjNyscXIvdAs8ZgDpUVPjw8SzHGHmm6L2r4UwR+kKKLScqAfPqta494Jg2TpaOel8sn/4BY2rWirFe2yB8v+TV0DoiQsMlHjIIH/HAbYl5su7Y8YBLFkpDSIS0Cmb4XNBex8N3CV7qXXRnKsPMwGTHZMP50LaOZfQ2Jk2558fvPyInTsV4rSoKJayIH5jkV7+4AqZeekUDcPUGUAZpGVX+bcw64ffjtTpxQYK8+gvUioS5vpmlXbCB3arjSMFPCxu9VD83knyD9N2yh9jriiX1t6Nabdas+r/ZxuKSUaBEjlYdgRo2OZcqLLwpjH8NQ93l8Vs4oIaRBFn7HrnT3mV+PaF+/TqzCwlMs0Ogs/z0WJxkuPSv/t1Arnhs/f0rdueBateZpdhuuKxEK7d2FO3eCWDubsF10UPNlyU1znjJB9eK8g7FmjqjpdCtrdSWN6Gr7Q1nFOLbY5oapZ/Dyv9f5SduELfJ/sDtasMk6PoYqtNJFMsAup2wKRGSGflKhrPomnSLdz7I3R7gNP0F7LMVVS4NLK6LfBhTaFf8TscRmUFMRSvSlLkgIhzhbw1pH98v8GvOWAg+vWlJ3LuzcbUZFT4X24t14CypH2X0eEcFMTvgobIjMBxkQH+c3XHRtu+cOkHXK81/A5CGEWj1GURuCEnknos+YpDhx+fWWFfvpIKhiGmYoB3rI5O40MqaKVLTI3kxEWJ8P1BLxaIaSPqXVCdO7mdoHqkP
 jA/ZaZIG
 e0ms0WyAKoH3we3JPS5YFTPseLLzMsNWo/A8R0lNVWK35/LgyDa/qNqG8rfpytBaW0Hlo6xwofGmfCGiioDqhF8Kvv+Pkknqw7ixzJ3e22PuAkT4i6gURzHbLivX8tb90hTeY44+hLNX8seSC7MraE6iVvw3I2JfFx5ghb3wdDm1qBSgeqFcgZJO1bqMmVx383S3L9gJsLkjL8Ayv394+IFv0dVIao/iZgp2f6PFKx0tZvyQkRzwvtQKv/OINkO1g/S8QygvoB6zRqeKRl+UVdSiE83WhsB4k0r8LMM1SC+cegHVfCOtRQNNDXBZcMz0K4HTc3WhFyn2R0k2/TTxxWUpAPo31ANJDlbRfNvIB/9bzdIa6hHCC5FHf9FyDGNoSxwJf5h7sE5l0kEobVyJ5RR5zp+PEcTCXGvG/kPm0sj5LBD61dLFyM23xX45SKEm2sojyW20iNXL61/XLUrmj7VC/XeZpCwzjDrdMM6GTV/qNKyrAdI/xwA/ZgEfGirnhZQ9zo+3vp0O/3fTeeKK7RmC1qL46i+LdY7LoS6xkLOO/nUEwsZzDdoTBQtxYEZKb6ZjOH7ekhIPTfiqUrYKbTGShktP23Gb7Hff189zAUqEJKrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the .check_set_attributes provider operation in the generic
PCI VFIO bus driver to validate attribute conversion requests on
guest_memfd files backed by a VFIO PCI device.

When converting to private, decode the 40-bit VFIO region offset to
verify that the targeted BAR is a standard memory BAR and that the range
does not exceed the BAR's physical resource size.

Prevent private conversion of pages overlapping the device's MSI-X
vector table. The host kernel accesses MSI-X table entries directly to
configure and mask device interrupts; converting these pages to private
would cause subsequent host kernel interrupt operations to trigger fatal
hardware protection faults (such as RMP or GPT violations) on
confidential computing platforms.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci.c      |  7 ++++---
 drivers/vfio/pci/vfio_pci_core.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h | 10 ++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c |  4 +---
 include/linux/vfio_pci_core.h    |  3 +++
 5 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9bc8009a9e766..f42422c1b7bc5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -169,9 +169,10 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
 	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
 #ifdef CONFIG_KVM_GUEST_MEMFD
-	.gmem_attach	= vfio_pci_core_gmem_attach,
-	.gmem_release	= vfio_pci_core_gmem_release,
-	.gmem_get_pfn	= vfio_pci_core_gmem_get_pfn,
+	.gmem_attach		= vfio_pci_core_gmem_attach,
+	.gmem_release		= vfio_pci_core_gmem_release,
+	.gmem_get_pfn		= vfio_pci_core_gmem_get_pfn,
+	.gmem_check_set_attributes = vfio_pci_core_gmem_check_set_attributes,
 #endif
 };
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9551a067b5689..894b1332f8a0c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -16,6 +16,7 @@
 #include <linux/eventfd.h>
 #include <linux/file.h>
 #include <linux/guest_memfd.h>
+#include <linux/kvm_host.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
@@ -2769,6 +2770,39 @@ int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_get_pfn);
+
+int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
+					    pgoff_t index, size_t nr_pages,
+					    u64 attributes)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	pgoff_t bar_pgoff;
+	size_t size;
+	loff_t pos;
+	int bar;
+
+	if (!(attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE))
+		return 0;
+
+	/*
+	 * Prevent private conversion of pages containing the MSI-X vector
+	 * table. The host kernel directly programs MSI-X table entries to
+	 * configure and mask interrupts; converting these pages to private
+	 * would cause host kernel writes to trigger fatal hardware protection
+	 * faults (e.g. RMP or GPT violations) on confidential compute platforms.
+	 */
+	bar = index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	bar_pgoff = index & ((1ULL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	pos = (loff_t)bar_pgoff << PAGE_SHIFT;
+	size = nr_pages << PAGE_SHIFT;
+
+	if (vfio_pci_range_overlaps_msix(vdev, bar, pos, size))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_check_set_attributes);
 #endif
 
 module_init(vfio_pci_core_init);
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 4e7162234a2eb..607a33270aca1 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -23,6 +23,16 @@ struct vfio_pci_ioeventfd {
 	bool			test_mem;
 };
 
+static inline bool vfio_pci_range_overlaps_msix(struct vfio_pci_core_device *vdev,
+						int bar, loff_t pos, size_t count)
+{
+	if (vdev->msix_bar == 0xFF || bar != vdev->msix_bar)
+		return false;
+
+	return !(pos + count <= vdev->msix_offset ||
+		 pos >= vdev->msix_offset + vdev->msix_size);
+}
+
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 7f14dd46de17a..e5f1f60513709 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -418,9 +418,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 
 	/* Disallow ioeventfds working around MSI-X table writes */
-	if (bar == vdev->msix_bar &&
-	    !(pos + count <= vdev->msix_offset ||
-	      pos >= vdev->msix_offset + vdev->msix_size))
+	if (vfio_pci_range_overlaps_msix(vdev, bar, pos, count))
 		return -EINVAL;
 
 	if (count == 8)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3a6d039454472..6ff67e38eaf84 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -175,6 +175,9 @@ void vfio_pci_core_gmem_release(struct vfio_device *core_vdev);
 int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
 			       unsigned long *pfn, int *max_order,
 			       u64 *pfn_attrs);
+int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
+					    pgoff_t index, size_t nr_pages,
+					    u64 attributes);
 #endif
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,

-- 
2.56.0.455.g6c5a503b38-goog



