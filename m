Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BC6606AF87
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UoR1VlJm
Received: by kanga.kvack.org (Postfix)
	id 627286B060A; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE096B0607; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDA96B060C; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1414B6B0607
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DD93120263
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
X-FDA: 85406459208.10.DA21D0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6AD8140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoR1VlJm;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011842;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxqsi8+toyrpTaa7l33gT+8/FQLeWRcGY9DZTW0jNlc=;
	b=qcBR2HUEKnHAU4X9X6u94c1YNqQ2rjfyVahaAyOHhbf/yNyRwlZUsmwvSqzENniUcAL1c+
	gzmpt9bVzcjzxknt5p+j7OqI0QWMD/wZo11HaWQY0/mKg33N98B6PPm4m1FOqf0YndiiiP
	rTEI+J4+PbBJP+qV9ydsBibNkEafECI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011842;
	b=wgucMC86/4VA+jQOSlWYpLlH2SbZtPXiVL9VN3jh9Q1ffSRm4UplHnp5+b/uswKjv1XTi8
	vA9qP/gIDreEtJlHltZb1FsWzRQ8n016LwWCOErLm4Dg5rd/npKw/5HMiGiw4zSpKlOeX+
	2GJ9voHSvfMcC6IJcqfsh7s2KCc5zNE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoR1VlJm;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0189D44071;
	Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011841;
	b=qUABWoYQZFC7EY34Kr38ZCoujYBCxmdwpNYmyaAz0Lr4WCX+E+C9elbHuUuY/y2JbbRc
	 TWS1hIE+TEsGuErLP3TN8xy5dMxgUixYZWYPW4VYvkjLTUZrKIjmPHXXZ5C0oGdg/SQ6n
	 mEzEgLLab4XH/7LDfnjtR37BQlcPPHrDrWQzfWbptynK5jo6fE1MXBz/8YdvJIbrx+dP/
	 kdudRrX7jPEPCl5KaIyTJTpUTCcop5It/7pZAAl8+Hlf68AJTzmuu8OKcvgdbK1v4PdTB
	 wvRMdSgwN3lGBCwdIDEBRP9aA61xoa/0zQ6xFBWu3NeSWU6v6khhcXoLEWxyhhQrd/Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011841;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sxqsi8+toyrpTaa7l33gT+8/FQLeWRcGY9DZTW0jNlc=;
	b=Wo0J3QzYBnZlX5hx1iqM3tpVTnFCSreQemxvxBpivmGlT6t8c+DnIXMbyROU2bEg8EGS
	 s3zs8t9Bpysn7PyMuVSbvi9irSK1iUAJmuCU99jIGOmcuQOJkmkW5ceU/R9ia4fU84fYA
	 apkIVqlOKkpwtw1cT/MpkQB3mn9cYf5gAOTp6my6iA8W7yv3ViqAHf+wFP9ZG4VyFRJlw
	 m4ebeCleD7YbAF3ri9Gko5/qp1Q6+ci+TmYBE9YHmN4XTfhc5KB+5hQ7HmYlwOry51xqJ
	 yL4MbPQBoOYPgGa0kPhYOj13ndt2ilVULBbqQR/z4bCvQDt64gtzZXLwLJ7dZwr6Yzw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0AA231F008BF;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011841;
	bh=sxqsi8+toyrpTaa7l33gT+8/FQLeWRcGY9DZTW0jNlc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UoR1VlJmvBnw2565e3nIFjL8HA/IsIFk5h10Dza6vZUgg+EU2aECgR3BBHS90PTDp
	 c1zpA5/n27GNgnKBRXFD9nXm48HUKZ9YiQ1SPU1XMkagsFKf5KHL6TVo6K3WEM8hUe
	 DqNSivmaE0I5tuM1e8KANO6TY9Hwqj+ktBDQZyI7nlUUEcZHaTqNcY+Rvtwy6s+Khp
	 RejGcfGI27rUQ32aFmlKPE7t3qem25R7GU4syFv0pnjsMF7JjYmSqEUoxQw5dd03+9
	 DOv2pOgOZuuTtvTOC76WrnZONO2LjFP8Id0VDlICpcwy2E8Mcz9G/uxwWkzk9ok+2R
	 upJK9KJKo9uzQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 35FE547A46;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:53 -0800
Subject: [PATCH RFC v3 79/88] KVM: selftests: Verify BAR revocation and
 access gating in low power state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-79-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4274;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HXOqCEcn1wMNNgFV4ufgWpq3HP3d5KMTONODuY/LkjQ=;
 b=hfJIou2E40cEogfjGxqpPpOHJzj8+eMJz0hE+mUJsmyO3SWxtyR789XZaiT8+HTKnEdUzJ2If
 Q0v4pcLysRCBmrNVjh3IoBZrnVwu9QVRWFtl+wJj7s9Fai6Pwzf069q
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nx9a95e9jds9oq83zznd33s8iefd9aow
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AD8140004
X-HE-Tag: 1794011842-803577
X-HE-Meta: U2FsdGVkX18uAEBVcovjkxzLzc/o3ar22o41GuxyFD2NhYMCRy8FQssRxYo0X4ViKLpRupIjMKubYuzcSwHAxxOQMwhaq1r7Dnpr9so+C+onN+ZpKO36dTd/IeopJhWDU4b+RjGf0LaNKDO11Bn4ZiLcfD0z3vz1dl5t1x8cbr9pNnlNFnnOwIlLZP3oaDrsGaVtWZyDb5IlG9pDdDArywuDwWdQ3tg9r5Ur6nlYjc8ODJ7aKcDzTNnZqxnV6nv65w+HI20T8iF8wIqq8SIQHRq1JKgjSlp9Ac4NMQPngHeclAptymse5XOS3qrXCSVC6VznFNBEZyLZYHHy4+sHsBTgvRLn1CcGYqrZBhmogZa78Zk7cLOoHemLWb2arEz2otG98fjX3hmgCmSXfHr/fqeeRfzGEoVZJaHmJY8tGLi9FctAi8CNasGhye7wBy1pFXeE+DBVutdqn0LbaqFJHdZ8DpXwWW44hKpwVfiJY53sGvpmQCJqhvSUyRDUYLw+QDS4In0t+aG27E5sO84Fy4qTzprKDdgUV2fKU9EedhTxo7GSqeSAVaUZM9gx3Yi5751A1IO2Xn7farffjmt6J6glUODQGZouEgoRhZ0OvkFNNqjFwIzM+hXQN/yqXboBms12SwsGLy1AjJKWeIIvDSj6Ak5dCU/7JSm7sraFOz+fwuCP3AuQPvI5qu+fpdwal+VvW5Pm4HQrUDFKnW4wdFE07IGw1rAWn4EiVgVv+DG/acBD5TP8PkCUk8SDmd+w52wkY38CRqyC7Ogvm9771aDQYoQIOiXObB3X+RKIvl2RcLwKrammSF+jkawylqXzBVeqWN7J5ocKTgD6H/KTHPBqPzU+5YssLG7oqiFxrcJaBKeUqu2ZQnOYzp79KxblL443E2554QtcgVbfsGiV7YNtsPFld6kAIAlKFr5te6WbwE68Szv7u6b1SrSM1LDdQC/d//1tMLZOC5mnaRi
 2+BPUNTI
 6XBsHZoct9g4Rf7gLjB9uhQZgc39FzdAENqaosK4r/VXheyOTWwVT2mdW6ViPP7cU9XUWsL2lXz6YbUUWK81253sOJaCTBIO3vVERNMt6tcwaRQjXr3mHu2wq7jchlZmpGnbYWyjyI2aaIbL6vdKEsGuFYkMjIzXf0JCsZI1VwzANAxUUCmfxNtkfK2uhgld2rHhpQX0VQRRy8gF6rwms2tKTe7Yfpe22O9vvS86W6aofPT0ThF+eWUf9GpkSBS3SKEhbPsG4hSKqKyr3yBv9OjLb5wz9xmNt55FtB2gqu10F1C3rfpuvVIJB8esB+Nz9tvHRXp5q9ePzje/zis57s+Tp1PBFmq3ggglaarAQqr1hTtfeckDo3Sszd3Qyjcgj9oUOH/ER/PgeYAku2vy4VHUF3PQV7n0VLkijzKr7qbk4Q6camL4DuTAXNWYqSmhrDCrQR+I9qwPpFMmpvRVYpjj0Afe3KuOiBMbCZY/BT1V7otnx1/MI0si7H25A4b7EXrBkk083GqY8w1ODoScmiJwjsblr5XzNJbZbIoPOIO98aDYbfmlqLnZVEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When a device transitions to low power state (D3hot), physical BAR
access is invalidated. The kernel revokes existing memory mappings and
marks the BARs unavailable.

Add a subtest to verify BAR revocation upon entering low power state.
Populate BAR0 mappings, write a test pattern, and enter low power mode.
Confirm that host mmap access to the revoked region raises SIGBUS and
that pread and pwrite on the BAR descriptor fail with -EIO while in low
power mode.

Exit low power state back to D0 and confirm that host mmap access and
pread/pwrite operations are restored and succeed again.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 86 ++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 03c324f7f618d..cf2d46a365504 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -443,4 +443,90 @@ TEST_F(guest_memfd_vfio, device_reset)
 	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
 }
 
+TEST_F(guest_memfd_vfio, low_power_bar_revocation)
+{
+	struct vfio_device_feature feat = {};
+	struct vfio_region_info bar0_info = {};
+	ssize_t ret_bytes;
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
+		    self->bar_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0);
+
+	/* Probe support for VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY */
+	feat.argsz = sizeof(feat);
+	feat.flags = VFIO_DEVICE_FEATURE_PROBE |
+		     VFIO_DEVICE_FEATURE_SET |
+		     VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, &feat);
+	if (ret != 0) {
+		ASSERT_EQ(0, munmap(bar0, bar0_info.size));
+		SKIP(return, "LOW_POWER_ENTRY feature not supported on device");
+	}
+
+	/* Populate mapping and write test pattern to scratch register */
+	WRITE_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0), 0xdeadbeef);
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0));
+	ASSERT_EQ(0xdeadbeef, val);
+
+	/* Enter low-power D3hot state */
+	feat.argsz = sizeof(feat);
+	feat.flags = VFIO_DEVICE_FEATURE_SET |
+		     VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, &feat);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * In low-power state, BARs are marked unavailable and mappings are
+	 * revoked.
+	 *
+	 * - Host mmap accesses trigger SIGBUS because page tables were zapped
+	 *   and get_pfn fails with -EFAULT while in low power state.
+	 * - Host pread() and pwrite() on the BAR descriptor fail with -EIO.
+	 */
+	TEST_EXPECT_SIGBUS((void)READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0)));
+	TEST_EXPECT_SIGBUS(WRITE_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0), 0x12345678));
+
+	val = 0;
+	ret_bytes = pread(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(-1, ret_bytes);
+	ASSERT_EQ(EIO, errno);
+
+	val = 0x12345678;
+	ret_bytes = pwrite(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
+	ASSERT_EQ(-1, ret_bytes);
+	ASSERT_EQ(EIO, errno);
+
+	/* Exit low-power state back to D0 */
+	feat.argsz = sizeof(feat);
+	feat.flags = VFIO_DEVICE_FEATURE_SET |
+		     VFIO_DEVICE_FEATURE_LOW_POWER_EXIT;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, &feat);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * Access must succeed again after returning to active D0.
+	 */
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0));
+	ASSERT_EQ(0xdeadbeef, val);
+
+	val = 0;
+	ret_bytes = pread(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_STATUS);
+	ASSERT_EQ(sizeof(val), ret_bytes);
+	ASSERT_NE(0xFFFFFFFF, val);
+
+	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



