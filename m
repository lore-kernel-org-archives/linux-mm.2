Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590D9606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2RCVqpY
Received: by kanga.kvack.org (Postfix)
	id BCD6F6B05F8; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F2C6B05FD; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6196B05F8; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 782CC6B05F6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17E2E8026C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
X-FDA: 85406459082.21.A5DE4DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01788180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2RCVqpY;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011839;
	b=RezBjMJVIssev5NFMTYLGQWHLckCZRUhJU1enZnCi8gFtJ5zYCmJCt0DcT77MIC2G/Q3ZB
	lAq8js503RxPTNkwTNaJPtHxrYwsq2/i22Y9WLcczcfl+vSlUhz4umBzXdkSCXgrzCd1DT
	gU1kVltH/WLtN9OJlfBvkoMiQjniosg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2RCVqpY;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FI7dlGgiyTT6PAbX8ijOtddOd63Y42N45h2JTeZ+J0=;
	b=cllwA3qiO9olWHtvrMzma6zumDtudgqtRNwoJI0w15Nw92TKX5UFjoPmd5ZKHQexBXM/jQ
	C/uiMUNHKIqMX2Ynk4wTVo1l3li8SbG5T4ZPX5EhftxBP5MEhkF+MtHliM/mnHC0BMjMiq
	GE7nAAdgdvU2aKV/Bps2T3/pCQmmM9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E9544047;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=NgV4L467X+daB4ct6bhwQhynSBLGCdybURTDGDEcnNvhEnyVN6blzC1oMg7HN66/6jaZ
	 cFX1XV1wOpy7ZuBsql6xJj2wDmJPElCqXLE79juyVRqbKSJbJAqO2t1LnzxGxit0y5Vfd
	 7jCK5+EdQmHESQnmwK393ARJay8cpUhW720Jfm+4YCmcHAkQCNqlVZwIpTJWNy6c38r1A
	 JyJ4bXq3KCq1hvyvQEpjv9DRjGfdcSqtMsKo1z+Y77udoJYz0DsGNfTuYqr958s1DS3+m
	 0wA8q9LsP3o5yxQemuPptAZP904nRXyQ7ZV7RoHQEv/pSYsVYFeEqn6JDyGC/XFsSBA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8FI7dlGgiyTT6PAbX8ijOtddOd63Y42N45h2JTeZ+J0=;
	b=y4usqB47yGylU39HH2wG50ZsHv/Jagk9iVndBi9xK5Bc1QZ/NOrlBRywNFGkZ3cuSdk3
	 xPrjtOFl/s9gQsPv6KDe38ROgvZ7UkPN5zy5vyuc4nB+ABRGo56Cocv++VQJ3XSe1dYAq
	 zEYtjJvLlF4Ef2eH+bf0Y1eand2AbfYeuvPoBK7ui8RVyA751FiVwImFtzitYgAfqCjQN
	 qDVSZA/C1fG0E2H+q6+F89oPjslda251DG8CcK3OUs0Y2+/ui2PtegVLV0A7H3hZloaaj
	 sgc+KdJmDWUC2HQt15rRkxo/hGhpnSftpkIK3YvaJYbX1dnldjOQ+Uiezv/M14FWgCg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2908B1F00900;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=8FI7dlGgiyTT6PAbX8ijOtddOd63Y42N45h2JTeZ+J0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=C2RCVqpYvdw5UTGpPtxYrUi6sBxO+V3ux76tMhUupJRLrZC2QHcJnS5dsC/jRh+JI
	 RAe2ZeRW4mmxl4uD8RfUExLlrnhg4j8grvVj3ZgeghENaO2eOjq6kkscgm2v/p7+F1
	 55Zbwnlh6u+8btpD14dEXjjb+MbMuNA9L7w2gtwuKyt8tZNBxgXm2i6iFKYYEM2PvO
	 lz2m7xTMK8VCsVuPaq6XmnRk7E1XPhcqgrWoXBPdATPy5wEq9I9W8Jg6QKpl1qz+ga
	 19e1ioBt7y8TIDVrgg/JnAka7NVpwpMjimErG04oMVScdyfbwBjRnF/geYsPwztawZ
	 +7o4NDULrTe8Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0A89647A3B;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:50 -0800
Subject: [PATCH RFC v3 76/88] KVM: selftests: Verify VFIO MMIO mmap access
 for igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-76-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2223;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jzqW1Jjl/TdHDq92R8GBSwh+0N7VE+Z3IfJio0K3a6M=;
 b=f9okZk6tF+33EEc7SQLegmp34Vb1lvk+kZzlENivyzjPi6JteKmB26YWjXUyVF37IjJG8C0Tk
 2GEFDMEETf7AmUmyoLD2UCbk907cEfoHL0cwp4KYGbpDQEbydtcIKgA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j65zqjsdpekp1nanwzn147f6m8ay88qh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01788180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011838-237575
X-HE-Meta: U2FsdGVkX18HAvYAQPtP9JL3kJQ/4CeBWgBHspOdz9NVrDXXIBZWrVMP4WqLb8asw0zwwusrDZTTmkaZOtKwbhlzWvou6r/d4GB4ypLMOb5cht+FumFizss9baoL1/+cwXV7zuG9+ZeTLMhB+8DuFmwIRrUSpwbOEdN1L0pRf2Br/mU0NaVPMoNLZfGnM2RRMDF3BtJwKuVPFUMrVsUJeMzXVyjJIqALlGt/y0LSVrZflN8J9PY4Rja+ZzPmEOUSuLazUQ5eR4AGAlglaRnVX7ZQEuKCKJLuPeDE/Nsds7N9PfGyOn+ZjBJ0F/30v9AsK4+V/xJrJWAi2DnjUXhbgjDOJmxTDvemknK2H96ZRlS/bnZQNq6j+7ZKHgeAGkD4y/2jXLHJHyWtjfE2SdwldVgHL2xohx2fqxzR/8ECzSO8+4D1QnQxdes0LKZktkVEN5q1EC6+rnEX4ELJvmXyFExQ13b/TxwS04c9Y6j7YifJfgoCCFvb02LuEi5uRMhryLZkJD6Gk5/RRlNr8sVvIYSGzOc3O6mM163J9brKafET9rC+Kmzu6VDR4zJFN7+JPuOe5TCgutLSdFMNuIZzWA8HUnIX61Hf98tigPCBR2i4V+qnR94fRfafyEddXeio+UUAneSIH4xfO8Zrh/INc1yDbhCvjkvxb/s2/RI6h380/Xqtbli3RtQfhVDMcu4jlrdvQXzKurCD4ggbKw5KBo7vJSAM07zvNpEA1tCDdqkxKAY9UQzl/YKV8Tt21M8on0VEBN5ZwMgC/WsO+Pp4hiE/wZ8PxduIHuU+/NwRL74uHXnaRZYhQPzMOZCSZ2C68nXom84sfFJmYrGDnCfQMzomTFwn8WGnsbDcqtDk8T7ZaUaQX2lTq7dnCmAM7o+nkXzPH5WLVde6qP/bPeJPIFF+tRSF2B0SdoueK9fWmhGLwuhTiveNKgK6obinLD2DUNKdKDrMq+6C2e+UJIC
 SwTUmV/N
 mKRuQOY77gR1Pk/q65b2pNJ/NzxQJqCC8PsC6y/no6vZ4uaHgGeJ6nmrcSK5kAzpJC8i+e+1syxqdr3C6NDFYykJItC00FZm4Ico2w6H01Tj7Mr/I9pof4ej/XNzfE0mIQaNyIgE76pghyzdkVDHD3O2HD8BTZeipOt5CZwS6hGNOdElUBnvMRx0S5EfX4grc9VJsUFfrXTY5vfMeRgfDSrq7tpYC4iExe7mX7enzsVBRUXk8Y0Kn7596RDudtenJYGAoZa1VGciVcPIzqo3KHGxnPK2V4YdWjTbg5hptjkl0wztt80Gxbv30XD3vISlM1Bz3Jha51ESp5EsQCJ9T83iXim8E0UFdxV3Z+435slEeiSzHjVR3M95n+I8iG3RYe+kCXdfSO4jvacOGQ3Ehbma9U6HxILTaOaqgTIF9rHF8YHU2LUweeknL/hIu/1XzDNZfdux8ieZIXLUpO7sTMEMhSgiGSQ+pG3lADLhokooSKwl3PXgGaA5CIubvKym2CMlJhpbS7LCJyIaJCcs66x2OWeGTjMTsKpFFZSba7eMwTEr65Zd8DH/s/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest verifying memory-mapped I/O (mmap) access to BAR0.

Map BAR0 into userspace address space, read the device status register
using a pointer dereference to confirm device responsiveness, and write
and read back a scratch test pattern on RAL0.

This validates that direct CPU page table mappings to device MMIO via
VFIO function properly, establishing an access baseline before wrapping
the BAR inside guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index fa05b7cfb3185..4d5211b6acf79 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -294,4 +294,41 @@ TEST_F(guest_memfd_vfio, bar_rw)
 	ASSERT_EQ(0xdeadbeef, val);
 }
 
+TEST_F(guest_memfd_vfio, bar_mmap)
+{
+	struct vfio_region_info bar0_info = {};
+	uint32_t val;
+	void *bar0;
+	int ret;
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
+
+	bar0 = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE, MAP_SHARED,
+		    self->vfio_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0);
+
+	/*
+	 * Read Device Status (E1000_STATUS) via mapped pointer. Confirm device
+	 * is readable and does not return 0xFFFFFFFF.
+	 */
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_STATUS));
+	ASSERT_NE(0xFFFFFFFF, val);
+
+	/*
+	 * Write a distinct scratch test pattern to RAL0 via mapped pointer and
+	 * read it back.
+	 */
+	WRITE_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0), 0xdeadbeef);
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0));
+	ASSERT_EQ(0xdeadbeef, val);
+
+	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



