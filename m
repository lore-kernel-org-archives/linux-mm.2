Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C13606AF8B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8iF5w9s
Received: by kanga.kvack.org (Postfix)
	id 7619D6B0607; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7372F6B060E; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2746B060D; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31E396B060A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0BFF40288
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
X-FDA: 85406459208.08.B86D25B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD5B140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8iF5w9s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011842;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrapFynDjbkWCcJyxHeJnR+LV5z34UhNLuAEeq9me1s=;
	b=Im9JLm0yNFkTfhvcnpPuFdA8O9jIHoDQzEytjdxM9z7iWgsWq/e0HIpc3UAkAZyQP25LgR
	1C2cly6DNvA0V/RIPgu7O91R408byNypMhy+PSunsNvlmGHHWB3CQrCvhlMnUSJIl5tRRL
	LR6+pZeQdWHK0AW5FF9wcziJh6ru3Wc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8iF5w9s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011842;
	b=S2dE202bXERV5ey7+g0AFyFQ+gwjBIPg2rOp8LxtM9KuiK5NeeF4FTTyWFTULq+f2VvzB2
	iZ+3rxrvwa9yrNddM09ASyyN9m67tYxPOnTkSQ8yMg89opnjbbPgWbBZk883TxclmyrNyh
	fAd9UeXWzmfXI3peWrT2+B2wmBYm6A4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5050D4401C;
	Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011842;
	b=VNfJeK4Ew4KoTwcuSD8lnhsDEWJk+XnDFK3xm88hYcZOqe52dSF2/bFGZZdcdE5IHfrk
	 1dOFVhUyBoqwYaROLFFlYzfW7vM7S2biLgdcU4nxDc+f53RsW2QbwSReolpyYDE91JVB4
	 VuUcNS6ExLa5RoYCMfCYkOgx3II9P664lPbN6yBvwdRb+TYfH+ahCC6JedZ51jytfQZDJ
	 aGYmrtFByI6Epz4s/xOX6POxnt59BZvy/ccO4JgIsWRC3viM/ADVrXlq3kc0eRGnWDymb
	 ROiTWaYJIFBZu3zvDA7Qx7OE0QTpEfYYNPQZwNO2srIw4sk6zE6zWwMvbXeOqUEz1Ig==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011842;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hrapFynDjbkWCcJyxHeJnR+LV5z34UhNLuAEeq9me1s=;
	b=3Sk1Bho5TxomfR2bF/xC/qGsT0NVpxWr3NQedbHWHD/sUENlwvTtrCPp4KZPhJu0aCjF
	 9rmWFlexLTQLVaO2UguowzueJvix2/y5aZgk9s4zsB6dKBxDHFz3NGvpuyalYfDn+NE8T
	 cK9QVYnLDss1gsyegTkIzzojWZhQ+gnOE7Dzh6FxQIrwL4/S6hJt0yILBvgwAdRU9gKQE
	 2tvAfk1cSUj1b9vvWSFmS4fXVRSBS34jTrCVUf3G9x1Cb1lJJuczfh1O7O6He/9EfeM++
	 aINtYiL55+XmGj7JUOKv2TKabgDEBVZjbGp/t8Ru+vevqJBZ14nAUx/PKYzLn65rXUQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0A0B31F0092A;
	Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011842;
	bh=hrapFynDjbkWCcJyxHeJnR+LV5z34UhNLuAEeq9me1s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=R8iF5w9sJ4PegTdRDo7KyNnk8N8q4VmloiVUSpq9CHgUqnXvaL/laX8DGryxyPjER
	 szhcijqMILBRqgclc+OIpV1j19/U0tysieYFNlKXp8JIHyC8QQfCfM/39+mk/x7VlV
	 4bZ1KVAZlcPeaOMTz1izKsG2cM/W8pffydq0qs7eKevg5U6tLfKJYT0oZLqC6UHTZq
	 YEh5z9xzL/heIlREKIl4jrzsbWuJRGxIHb8k5YvdPGPREaJ2itu04s6UuYiYcNr6Mv
	 B7dEE1gawQuC5w4uCysdwTBtn9YevWgI0DI1k1wUSHxDqdp7sJ0GrNX/WTmN8qHB1H
	 ScRR6zZcMl/eQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BAA6F47A67;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:38:02 -0800
Subject: [PATCH RFC v3 88/88] KVM: selftests: Verify shared and private
 pread and pwrite for VFIO BARs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-88-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=6284;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1zioOYnFzNTxpR7A0+7PoY30sl5nwpjzxC/1lW8AftM=;
 b=nb7C5koXUc0MibxX3u3xtZiyucnhH0jKaUaY3p2yk+i00QV7XkYLX8bgHiHUcBKnmJ0BMIExc
 bN5UY/TmbqBCspJMlH/ycgJCUazHR4ByTAP+dVGyqKh/42/RGYjwqaC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD5B140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3f8i89e9eby3dsucrit8bqgssadrydtw
X-HE-Tag: 1794011842-495304
X-HE-Meta: U2FsdGVkX18rqF+WC6Kj95zszM8NoWd0h55ET3cNxjEBWkxyKB+pCYttRh2L0kxRQjU+Q2PzHcfv3rS6bj/t02jW8n2jsFKj88V7VdImkyHcPFouwm+TY1JN7iMeDxFx2o2J/Uz27x8ayIGBtQ/avxCiXmm7T+2eWhzEj2NQe33cAAHrvwe5lWnwnWMNJCWgHO+M+FVmrnv8NissqN8UCmYDQoii6u7zVscquwP2w/rJ8KYRKzohaoNoIL0wqfBbtyz+RIpmUQLkqpAP9Fqq+lX6Epe4J8sxd7HtKJsTlanlrtfS7vbOmqMibx3/CL6z73Hn9VruZuzd7I5tBdFAPJ/pJy5rM/zZodCxQk/dYyCWQfBy4IoXCJ0HVsBUlTV6gFH2pMsduL74TcHKHUkRF/YEPazg8LJFQLbCZbcOjm4Z6B9RyiEljO2VNDxNw4BK7Vcfh9tZG0rNI/nodFb/Bgww0OxNKxZpvyvf7SG+j1WiwwJidU7pWfgou5053RKnEYdI/Uum4vD3MgHwztneZRHlDuUAySQ2jGV6UrHhGDicet8era8uQquDxWp3z/MnIZae4MhwyqFg9+nZsuMIV/oBZZJiXhsJFJjQWP6XSslnmQlLYDjc0Y5QbTul+7qYz8Ak1l5Ejr0OCb4KNoXR3+HClHmenkOSe/kTryBY3kc8GN8KqXEKcHilUXAayTtrUV4MBlnTnaas74O4DrE90BSN52BNwP2h7DD9eQ6laVogaYgpTpGq5dIs8/l6qDPi05gBwBa6cWfSmXLBRHcwCF0prCejq4GF61uWJdK6uDtw7BA7ULuV+743v4xIXtAHQlXrXbLQsSGDzCg0KKjaV32EAmlJaMKW3EeHjnddEKrL4ylWCxZM0t9NkgfiQJntzk6s72p9YEavT7TCijrp3a7e8LAgCQqtMvLy7SXSkd0cuhXUT/ViWrBCTzAJP9nkN7gBY9d5cCD5Y8842wJ
 gI1+2VBH
 AtmVJ3iJbmGdUtRza5KleZP2y5y8h9iM8GVg5gUhC2jZJnaGOw3oxpw/4lwpsWaV1N0331TEwWKSiyJS0BG+YLuNQrqpzyjEJVepjw2BXoPCH0MEygdiaZqBFTQLRnBp4Xq4ousWPAWGKFrjWGibhaGqMEQf6JHjD3iX4X3rqeiHdFQEXWkH+6Gxa8FuOGJ8HxkknQpbf+ZlnBn6NsHXufRzQ/rTVDwmk6xYDUv88AnTXljvbWQFfD+FKYgmLwJCbqjNceEpMtRX7Z7RukyyleLVDk83E1zSybnIJp/ztTeW0Jbqq3b0dWyjIqZIEy5K6pcH2jVe1ZjJGeKC5PvRuXdyKTr6yWg7R7A0DsAQXb65fpalizzr0krEy/THu7mz2dTNzGLLBZeMHezsTI+m6GAfQXFFbE6YiIJRITg+UP+eR2H39faTAfesI0Dizg0xxht0Oiuzt29H+MgxAUWPsX0S6oqa+4bL38JC1TeqWC9y4RY+gOyfrgsnwrdWwVgPsEjrCse905fVQAIb5It1trPn4S1JqkpGVLPmSH32qxsgKFWr/AbJTAjo7JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify read and write operations on guest memory files
backed by a VFIO PCI device across shared and private states using
file descriptors directly via pread and pwrite.

Verify that in shared state, host userspace can read device status and
perform read and write verification on device registers through pread
and pwrite on the guest memory file descriptor, and that updates made by
a guest virtual CPU in shared mode are visible to host pread.

Convert the memory to private. Verify that host pread and pwrite
operations to private guest memory are rejected with -EFAULT, while the
guest virtual CPU continues to have full read and write access to the
private registers.

Convert the memory back to shared. Verify that host pread and pwrite
access is restored, that host reads observe updates made by the guest
while private, and that guest operations continue normally.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 143 +++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 325d5e0c66026..eb3a2ce0e6ed6 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -946,4 +946,147 @@ TEST_F(guest_memfd_vfio, mmap_shared_private_rw)
 	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
 }
 
+TEST_F(guest_memfd_vfio, rw_shared_private)
+{
+	struct vfio_region_info bar0_info = {};
+	uint64_t bar_gpa = 0xc0000000;
+	struct kvm_vcpu *vcpu;
+	void *bar0_mmap;
+	ssize_t ret_bytes;
+	uint32_t val;
+	int ret;
+
+	if (!variant->use_gmem)
+		SKIP(return, "Shared and private attribute rw test only applies to guest_memfd");
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
+
+	/* mmap the VFIO BAR through guest_memfd descriptor for memslot setup */
+	bar0_mmap = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED, self->bar_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0_mmap);
+
+	/* Configure KVM guest memslot backed by guest_memfd */
+	vcpu = vm_vcpu_add(self->vm, 0, guest_rw_test_code);
+	vm_set_user_memory_region2(self->vm, 1, KVM_MEM_GUEST_MEMFD, bar_gpa,
+				   bar0_info.size, bar0_mmap, self->gmem_fd,
+				   bar0_info.offset);
+	virt_map(self->vm, bar_gpa, bar_gpa,
+		 bar0_info.size >> self->vm->page_shift);
+
+	/*
+	 * Phase 1: Shared memory pread and pwrite access from Host and Guest.
+	 * Initially, the entire guest_memfd resource is shared.
+	 */
+	/* Host read from STATUS and write/read-back to RAL0 via pread/pwrite */
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_NE(0xFFFFFFFF, val);
+
+	val = 0x11223344;
+	ret_bytes = pwrite(self->gmem_fd, &val, sizeof(val),
+			   bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0x11223344, val);
+
+	/* Guest read/write to shared BAR memory */
+	vcpu_args_set(vcpu, 1, bar_gpa);
+	guest_write_val = 0xaabbccdd;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	/* Verify host pread sees the value written by guest in shared mode */
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0xaabbccdd, val);
+
+	/*
+	 * Phase 2: Convert BAR0 memory to Private.
+	 */
+	gmem_set_private(self->gmem_fd, bar0_info.offset, bar0_info.size);
+
+	/*
+	 * Host pread and pwrite to private guest_memfd memory must fail with -EFAULT.
+	 */
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(-1, ret_bytes);
+	ASSERT_EQ(EFAULT, errno);
+
+	val = 0x12345678;
+	ret_bytes = pwrite(self->gmem_fd, &val, sizeof(val),
+			   bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(-1, ret_bytes);
+	ASSERT_EQ(EFAULT, errno);
+
+	/*
+	 * Guest read and write access to private BAR memory must succeed.
+	 */
+	guest_write_val = 0x55667788;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	/*
+	 * Phase 3: Convert BAR0 memory back to Shared.
+	 */
+	gmem_set_shared(self->gmem_fd, bar0_info.offset, bar0_info.size);
+
+	/* Host pread and pwrite access must now succeed again */
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_NE(0xFFFFFFFF, val);
+
+	/* Host sees the value written by the guest while private */
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0x55667788, val);
+
+	val = 0x99aabbcc;
+	ret_bytes = pwrite(self->gmem_fd, &val, sizeof(val),
+			   bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0x99aabbcc, val);
+
+	/* Guest read/write access continues to succeed in shared mode */
+	guest_write_val = 0xdeedbeef;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	val = 0;
+	ret_bytes = pread(self->gmem_fd, &val, sizeof(val),
+			  bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_EQ(0xdeedbeef, val);
+
+	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



