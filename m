Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD512606AF87
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUBFs/H/
Received: by kanga.kvack.org (Postfix)
	id A6C116B060B; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A456E6B060C; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933636B060D; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 538666B060B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAD3EA7A02
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
X-FDA: 85406459208.15.C5052DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1371100005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mUBFs/H/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011843;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxZseH1D/U//4ssKZEL6OBhMNAqOusdgqcQCPzcsa1A=;
	b=mrIpyJydoCWdgb4+Bkdg1uNsXthqaclwXURiXZgtN1QsTxHziVt7AjRPk/aR2JR8ckZaRZ
	OVPk44Tkb+b3A/tNkJyz1idOhf9e6mMTXUhw+nNtWhxAOSVFxiEsVeymmqfmw4FFax67eE
	VzfCQlR4tfZDRW8DOdM0D3AQIyH/4CE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mUBFs/H/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011843;
	b=EkCzmaF+FE6mhHkCYpoxWYzyHusz/NnVtzjYMr3fmwo7C+zenPG+zbyG6b4eyzLZyb5//j
	b77z7OPDa6WoJ96sO8SgcDhc05jExA1leJMi8mmBWKzO6eWyXUG34AmUwTmmlIEoUcY76E
	OXmxfpKc3Q3KXhwK8yGmzGvwGLvjHs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B136A41142;
	Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011842;
	b=jzOrZDWUD1p8kRij7cmVHLLe4mumO4XJrdbrb5T92+kjvRJlJX58DBxDoPOMgJbStZV0
	 zUYQWk1qUb62mmo0x+Z66by7GK0AFWNpWx5dQ7rwn+m5yMtMmsDflC6kVIx0UlRVIbdhw
	 NpwjBT5b2SD+3MPRPXbgaJGJY7GxjGANJsNT805PRK+3QAS6bkNPkWgP90smMZ7NN0R5s
	 37anuPvmlYENpYaLPfmKt/2v8IS5EX22MfaJLH9q0vnYAQOJH6XYFRYjkupTswBHb+svS
	 1kaMGgCReRBiB/oUKjerFal58QYnHsF2jHAzgrqMlLe+KrqzE3vZBnE3wpEqnEdUENQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011842;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SxZseH1D/U//4ssKZEL6OBhMNAqOusdgqcQCPzcsa1A=;
	b=Dy+Z+ObJO3FzbV4FOUB+h7rnmNS1gQ8AMaGQxZCHs5oXZGcMl99n7uqOR9sJRAyBzoTH
	 CcoXXdGb2DZdEEzIIEchPKWWIx1FWTtLaKaYBDVx5x8srY9y8bIHXsY7csJjuqyO9mH+P
	 BfUi/zMBB75GslOqpIA7UXudlgN3YKErXkmo7JIOlFe7gbDDGyMoh0fu3y25pIr1B1uup
	 98fymrOignzArdl1iqhHxtcsnaBityb2XvpwqOS845qyfu3p4O+k5QQSS+bRsk4u7tXQU
	 09UCChdjCiJecFSdHlWyX+7RiRsYmmf5b0+1pjNZmIFzgWymHlMfwjg3KF+a4561eug==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0D5AB1F008A4;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011842;
	bh=SxZseH1D/U//4ssKZEL6OBhMNAqOusdgqcQCPzcsa1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mUBFs/H/7OWwoFBVxL4CLWIAEgOJOkKjVNsHtKrGyqlRUKut7S4Hgy/uPK56zo1B1
	 hCYuzouZpkZkjFbKVLdn3ZRjkhftiwdOE0ZRH1Ro8MoBanvvLQW91mro4yeSqM4eD1
	 OwlbCh8IytC02h4XXubQQtfX3FjwzLwf3cKzfbcI1sREobTztwhzr2++avhhOnhm46
	 gJj17sf5PdbMAvLLMs0mK750/ntTjXUOZ2Sbw8CL3sHaMoN6SK+SEAybPmFlPdiuQ6
	 N96KjR1WgCHQQ7BbaUV0x0WSb6B+aLjFEg5d1u/JgohH9qWkbOVDSXYyhreOVr0qKo
	 7NhGXGhma0QcQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EF32A47A37;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:49 -0800
Subject: [PATCH RFC v3 75/88] KVM: selftests: Verify VFIO MMIO read and
 write for igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-75-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3042;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3rXXPklnl0jKOPE29y7ipXm7LsNh6MGUlvgjiF//KXQ=;
 b=xloQFGBoKJ2DqV21AvqSu5E1J/CpqtQbloSW0T3GvaqdUgvm8xoOH8M0ztGaadapQ2nhxCakj
 IhodY//gGI6CJqHf9PiPv1GyWySREMT+8pDpBuxA/6S9HQ3zZS/kyLY
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1371100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 34nj8dxoncntr355gerd3hws9f9exasw
X-HE-Tag: 1794011842-742301
X-HE-Meta: U2FsdGVkX1/Nx//kDQt/YU0i4aGYjuzwL6tnWUH67SKaBsalSGhrDzb0CNRre3LCLb2mWCGh638cyFchHzoV8tYiABoI0hYG5uReQGIjVqTjm4qghK/2QMYvoW6bkGBT/o0LhgGXYgyzI1gidK1twvA06Q37yxJK9xt6zRKbrGE1IW1t3ydGFGmXb0+lWxsh3o/ug5OR0lnd6xHonsL2AaFZQaZsoiynEiWDz8e8z9dvvWkXE/PrUmmgXYryMm+KjLC0eMIJ42KFDacFeNvFZ/S5vFcCRsacG7LV1LrqoKNwrlpfsPKkTLbwfSUou3iK8+XRJmHL1Wr93OKEPeGYbcC5PEweUhTNqq/ipUszMXAKPyjUDQum3zOSQQkP51JSXEgEwEYHEHHvSq+05YHtzk5NGzcApAAogh4U68mY2RrpDSdUzDf98wNYKAPBr+6I99UcvSBx7PE8skE4cI2OIo1+wQrKw1ytxjsCiVw5cm402RTq81fHtvpXKhHeT6WGP8lqe416UfpCFhaSs6l0z0d0TmSfV9Zw1Ved8bPAMLI5Ymx1XNlULDoHP/R65k4uGm+PpIiPlcd0RMXmPAPwtkL9+iQILi2IEBSGo6DKi7OSZ5fmPe3Jja7qqdkZ+UOPo3MmDE003/E/P4z8pS9lBE1+FBzOXsUnusMwEOmOMWazb3/wb8QL2GZpjfkLcM8hPkJ+ToB3rrpyOnyUQ/dmKhej2Z4yaKtq9mjUtndrey9fMqZoviEGP8OQsztmSqkyJosJVA3Rk//GmpVp63xM2kqscIiwSRfHxExJ9vah2sLnBslY8PLCAWg1w54bZmfaqXvEWSfsnrSIVOl6ZRMQENE53Bp7fPh0VDtUxCgyzP85QjQUI7APnpOTyaCphgE9BGXMjx1OMzHv8RAKTvawRkRGP7FivOEDoRhLxShhP4q+C/j5Nj/hLR3FZjq1BZGtcBEUiR1tXkvxRxp0N8p
 6bC6YZ92
 v1ZQ3bes2MdS6UQ57Ip/yn4uLhv/KmRZdI7pB2ZmTtAylbtMuTYLmz0GuwZyOnYuj9RJj64T0RAQrrSjfvGF5lpAPr2AeuQ8gYhle7nRDch9AzTNO9NwDo/JjBaqFsLfZh4Z6Qc+0UUgUw/IV10K70sq+e47aYRCA+fjm7HuL1Qm8AJCPOlqf+cqdKL1BpI6BtYRA48zfB99np6oQV/iz3r7t/LehJr2J4vm67hM4kIwQEOjacLJbxp3h118QcwjvekMwcT/8RMBWa2z+xN6aB3awCtE5cwn/3ryFOQNmNcPYl/Wv9KTnzfGLYp563HlO4bMSEnCriFO+51WJDECBecvQLUF1x9q5VcTjS2xLhy+/dfbpRen/+WzVfuSceULM5kvMdX5c/L61HNIOyQUfC+Vz4pa9UMwMB8XbvZPKJwAyDtonWdYcCk3eP48eVMKfByuAVr4l4YxMWIpflOUEENbCyYqsXW2HIeE4MZLexplKUlPOgeg9gMQ92xsrezkYtwhG41o0Ieqxdt87jTM35HVlt7v/i51kouhNP0wrEqqK6eeI2FU6nWS+OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest verifying direct pread() and pwrite() operations on the
device descriptor targeting BAR0 MMIO space.

Enable memory decoding in the PCI Command register, verify that reading
the device status register returns an accessible value, and verify that
writing and reading back a scratch MAC register (RAL0) succeeds with
expected data.

This validates that kernel-mediated MMIO operations over the VFIO device
descriptor function properly, providing a baseline to compare against
when guest_memfd wraps the BAR.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 58 ++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 6525f392b3930..fa05b7cfb3185 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -236,4 +236,62 @@ TEST_F(guest_memfd_vfio, get_irq_info)
 	}
 }
 
+static void vfio_pci_enable_memory_and_bus_master(struct __test_metadata *_metadata,
+						  int vfio_fd)
+{
+	struct vfio_region_info cfg_info = {};
+	ssize_t ret_bytes;
+	uint16_t cmd;
+	int ret;
+
+	cfg_info.argsz = sizeof(cfg_info);
+	cfg_info.index = VFIO_PCI_CONFIG_REGION_INDEX;
+	ret = ioctl(vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &cfg_info);
+	ASSERT_EQ(0, ret);
+
+	/* Enable Memory Space and Bus Master in PCI Command register */
+	ret_bytes = pread(vfio_fd, &cmd, sizeof(cmd), cfg_info.offset + PCI_COMMAND);
+	ASSERT_EQ(sizeof(cmd), ret_bytes);
+	cmd |= (PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
+	ret_bytes = pwrite(vfio_fd, &cmd, sizeof(cmd), cfg_info.offset + PCI_COMMAND);
+	ASSERT_EQ(sizeof(cmd), ret_bytes);
+}
+
+TEST_F(guest_memfd_vfio, bar_rw)
+{
+	struct vfio_region_info bar0_info = {};
+	ssize_t ret_bytes;
+	uint32_t val;
+	int ret;
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * Read Device Status (E1000_STATUS) via pread() at BAR0 offset.
+	 * Confirm device is readable and does not return 0xFFFFFFFF.
+	 */
+	val = 0;
+	ret_bytes = pread(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_NE(0xFFFFFFFF, val);
+
+	/*
+	 * Write a distinct scratch test pattern to RAL0 via pwrite() and read
+	 * it back via pread().
+	 */
+	val = 0xdeadbeef;
+	ret_bytes = pwrite(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+
+	val = 0;
+	ret_bytes = pread(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0xdeadbeef, val);
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



