Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B83606A838
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EA70c6TG
Received: by kanga.kvack.org (Postfix)
	id C43C46B05FC; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FFF6B05FF; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93186B05FD; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8219F6B05FC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38B681C30A4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.30.EF61323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2881440004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EA70c6TG;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XBnuXdKMW0BYZDb6pFvErPk/W2H/V3bFHID2+HkR8c=;
	b=D1SXEsnamobFt23E+jk6orTg7NMoLepJ29iRJQU2i59jFwOWh8N9k4C2xSQ/W0fMq3Ylwy
	ChGE3/mmfiYWyBsqR0zI682lE6oJU8V3EnwbaxKBsP5sKQcrWG8IqrXuVNQQ3Pl3pMmvkp
	1zFcQ6UiERIhw088fPCZu9OhE8uMA/4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011840;
	b=G76U1MKLt5jtFZUkFuoLDfTRxxP52pqY8hULPU4c6k69q+K4VYrESav5sZ21q/q5PDjq3A
	Y8AGb0ztdhqml3EsO5M8gA03QMIxWznhjpBmiDd9qZtvmDbN1CJymVShVn3ntH7p1KIgyV
	B5ZWC/J+abAPNQI07OjR0jo5IiI/IaI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EA70c6TG;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F7334322C;
	Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011839;
	b=DlFrmn9xrhJ3Psd38lHuPANkdJD3oyuOLN1JkX0mPmWobT0fifbIgtg3bBygJyQUTtnk
	 wld8bal7KL5yOX5TQKe9LDezbONQhdct6Yh20/rAnb8BBdCddq5CmU2S9bjUjjf1B/RuT
	 Z6QLuY2rOu8e2rQtvdwr38s9RREKFk3tG3EWdg3lzaYenHGmvWQd9ofOop9wDXyzzCqlv
	 aSQI+GCMHxfom4OlQT49WodFppHRpsGY4J+XgOWd7/ypKTVY6nzl2N23Z+zEhO8xS/haf
	 baONDRICRzrGXd7wh2R3ZH22P45C9+NNEkZQVghZbr/CEElSQHr0SP1fKfUS6QGHnuA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4XBnuXdKMW0BYZDb6pFvErPk/W2H/V3bFHID2+HkR8c=;
	b=aMzF1Z6MizPSsHA3dwdXn2Lq3e439cV3XqciZjGJwMtf7Sf8Pu8yE5gZZR+UwZiWq71W
	 7E820UtK8Ieyxv0/QrLcN34cBlnEiiXqg9kCWW5uGED7fbkiEd2dGqzdoB88W4MH8lH+i
	 /qNG1vARsEu5enaA7Q6RiH4yeTyXBo2oq8nh6lCeg6ClCHnjb0AVY3VVXMJuTF7+NRoT5
	 8qApZawYuK7PcI2lu7pozfZPliH94x3JfC34C8u/jmjBkHBtMm+MfwvHcp11IMni6NO6u
	 BjzrbmgU3Vzeb67BghMz3mkYu85ymRwRHgdXmdgq05bnOfAE20ZFFydSFC7OAevWHQg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 359C11F00907;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011839;
	bh=4XBnuXdKMW0BYZDb6pFvErPk/W2H/V3bFHID2+HkR8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EA70c6TGizHUa25U7KFl5CVYLjU89Pnisxm9GO1YPcFfQnDXRiTKpidZcecGw1Ab0
	 SZJsQWh9f7mE3KaPkvJGrY7qej3Pzh3XP+cZGn6e2n6wqsIRpz2YqaGsgWGHCxf+yU
	 vHyvRdxgICbgld4AayNeizEcyHt76jL0/d2DAjt7v8x1nqMXjt0iYcqQmk5sTpJNsK
	 GkQfYC6HYKCdxJnl0nxd9grxG5IdQFW5lKD1mFAySzXLvasQDj6DnWs8hnsXBs6iVz
	 fCfq7aZ0ju6bGB6wCHdnCJMRcScYpwr9DF/hdToXYaBPmu8XfptveNhmvZerDvi5A6
	 gqoz5AOM11aJg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AEFCE47A28;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:45 -0800
Subject: [PATCH RFC v3 71/88] vfio/pci: Implement read and write provider
 ops for guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-71-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4013;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=m9SP1CpmTKvsGoq5eZAgHyb5OpuOEc1QM5jrgJzQxmI=;
 b=IoPXFGcHpHdx3UkOvEWFEMm1Dzaeclszns6ukrwhiM363noCrao70iL5dIJrsqo9NYK4Q0Ok3
 ibey69WXBPFDkrp/2bbZlPPA3FGFWxadq6loOgMcqBRLY3Q25uA+Ycy
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u8cydnnc9eh57ysi7up9e878wsh9p7eu
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2881440004
X-HE-Tag: 1794011840-26385
X-HE-Meta: U2FsdGVkX1/nv9dO3Yoe3heoOiKyum6bTwTER74ZwO881HzxtQh7IVLFzYcL6Eoo4EiZ3a9P9OZIRclYiQ2xgcrYyhRSaQBUSmF7TAWt4jybSOYjbKaBjoqUrvRuXi8V/g3gD7AM3/k9Vto4zP4QKF4JaWBfqmClK3ReECWxJf1XQILYSM+PRRPKhYe2cqnJck46Tor1jfvPnhDs+PYICdLqvzDw/DcIOMs4ZlVAdAT85V4uDjNKAW86G9kRGzVmTI6eAvI1WSekP+saAEme0pC0KFvL/mCmXKS3RBwsTx1OTTcKDSjF6UGylfDb6IP3MovFhgbfLtPVfPFmwOZZ9fKr3LJgBmtKK5ciOGsemBaEmuEQm2i2ZF2aaPJXHy9TNos1/FSmN7OUOxxjph3phDWmZvFfrQ2MOJ5dxVAW5aYNwFmpmnajpv11mpMsHh4jX3Er6PrgTTNskgJIR9JjzAvhWUtS3MLnERAImfN0QGkqhmQkvqO5dBmtBhiyrh+9KiBJjE7hForleCyojnxQUP5C3ZlJs3m9Yl5gZ5k6dAk0VPH/q0zkaWzPMML8XpokWPVCq/0bFYMtOrXdIUWJBGClgmYIaKo+d/g1WXVVIGT+xj5tAXN/ngh9DAd114XBHkn7i5nOL+xoPrMHK3bOsJU4JJbWMLnKC9yJYeM6/Wgypw82UdQshpPcotrbeUdIYcX4g9aQofk82b7FdGuh3UT/l7psWH7m8QWoqrfY2RY0cCbD8gHoKX54HAAuV4sRLCEP7xAfk8nKiW4BsIYaXrASJzYEGEyOLFbit539ALdK90TfYVT+M9QA+HoNjtRp9VRP1fwPtWywdLUgv4d/jB98fV4C9xBe8ZKvINnCd/9x18zA/O76VwSBZZQMEctlkJmDEaL6ZC1M14SG34v1vFUHYcNWdZGVwYSxJvypKXSFl7Dm96XzFzMVNWA+f2hCnBblobcnynKR9TI8wLV
 ff+SlAkT
 7KLarKo9TIetH9sz5KMpBCBB+kEy6CFZ6e5NUdCP6JRWc7dRtnE5ErOistyRoLZHdKqVULgkxCrtC3g5WaMWgBjBYSs3XAW7pf21Z8RfAuYJj4436ALUpieKcQ8x2bFMUZYsaUCUAqHwwtDLwK5EpiUkGsUDQczPidqMJr9kzYC+azUOmH5WCHTzXZjHgRCgNj7uMCKYdWNvbzMxiKNF6zU2t5mtT0jvUf3u0idMRB0fVAHFjqhG0dQrZLgZ674p4RjnJPoP3ZA5O+NtJsH1v9OzyxW5rv2SXv4a+nNTfNpBYq5wruLHHnfZBzXcepw+mPufCCYtsGidbRukvuzY/9AaKG035uViqnNlnjxiuECg/PFjL0HDrZasc1w1B6WpMbQwx/UNT3uD93IunCnlPKbEOlL9/2pPpR20mC0YraNI1nUqVVdu3Vxhm7Of+QExmNdEbhjBWQdWekp5n+xCT7JijIMQEyNPs23MBy4OdfqjpS9W3SsgjCyvHbGJnfTdwMEFZ0b7WRhPGmbNXNxgB+u39mVvWbISFV3w6vDxr6cFFnu9SMzaHuTjoDlpct3PNeNNIewyCidkrJWnqA0uwTLpej2B8HREm8yuLkOu+exSfkiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement the .gmem_read and .gmem_write provider operations in
vfio-pci to service read and write accesses forwarded by guest_memfd.

When guest_memfd delegates BAR access, it already holds the shared
filemap invalidation lock and serializes against memory attribute
conversions and hardware revocations.

Restrict guest_memfd reads and writes strictly to mappable MMIO BARs
(indices < PCI_STD_NUM_BARS with bar_mmap_supported[index] set),
rejecting all other regions with -EINVAL.

Verify locklessly that BARs are available via bars_available before
accessing MMIO space. Forward to vfio_pci_bar_rw_kbuf with test_mem
set to false to skip acquiring memory_lock and runtime PM, preventing
AB-BA deadlocks against concurrent revocations during resets, power
state transitions, or memory decoding disablement.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci.c      |  2 ++
 drivers/vfio/pci/vfio_pci_core.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  5 +++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6f28f1ffbad0e..e5e2dbca152ec 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -174,6 +174,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.gmem_get_pfn		= vfio_pci_core_gmem_get_pfn,
 	.gmem_lookup_pfn_range	= vfio_pci_core_gmem_lookup_pfn_range,
 	.gmem_check_set_attributes = vfio_pci_core_gmem_check_set_attributes,
+	.gmem_read		= vfio_pci_core_gmem_read,
+	.gmem_write		= vfio_pci_core_gmem_write,
 #endif
 };
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a9274d95e9066..c976574782663 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2871,6 +2871,42 @@ int vfio_pci_core_gmem_lookup_pfn_range(struct vfio_device *core_vdev,
 	return -ENOENT;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_lookup_pfn_range);
+
+static ssize_t vfio_pci_core_gmem_rw(struct vfio_device *core_vdev,
+				     void *kbuf, size_t count,
+				     loff_t *ppos, bool iswrite)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	if (!count)
+		return 0;
+
+	if (index >= PCI_STD_NUM_BARS || !vdev->bar_mmap_supported[index])
+		return -EINVAL;
+
+	/* Lockless check on availability of BARs. */
+	if (!vfio_pci_get_bars_available(vdev))
+		return -EIO;
+
+	return vfio_pci_bar_rw_kbuf(vdev, kbuf, count, ppos, iswrite, false);
+}
+
+ssize_t vfio_pci_core_gmem_read(struct vfio_device *core_vdev, void *buf,
+				size_t count, loff_t *ppos)
+{
+	return vfio_pci_core_gmem_rw(core_vdev, buf, count, ppos, false);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_read);
+
+ssize_t vfio_pci_core_gmem_write(struct vfio_device *core_vdev,
+				 const void *buf, size_t count,
+				 loff_t *ppos)
+{
+	return vfio_pci_core_gmem_rw(core_vdev, (void *)buf, count, ppos, true);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_write);
 #endif
 
 module_init(vfio_pci_core_init);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index b6e2fb93f9500..03cb0b41855dd 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -181,6 +181,11 @@ int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
 int vfio_pci_core_gmem_lookup_pfn_range(struct vfio_device *core_vdev,
 					pgoff_t index, unsigned long *pfn,
 					size_t *nr_pages);
+ssize_t vfio_pci_core_gmem_read(struct vfio_device *core_vdev, void *buf,
+				size_t count, loff_t *ppos);
+ssize_t vfio_pci_core_gmem_write(struct vfio_device *core_vdev,
+				 const void *buf, size_t count,
+				 loff_t *ppos);
 static inline void vfio_pci_set_bars_available(struct vfio_pci_core_device *vdev,
 					       bool available)
 {

-- 
2.56.0.455.g6c5a503b38-goog



