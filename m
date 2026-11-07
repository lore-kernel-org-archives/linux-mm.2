Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAE9606A82F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7DhmpN0
Received: by kanga.kvack.org (Postfix)
	id 600BC6B0600; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFD46B0602; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477A56B0600; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD526B0600
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A452514016A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.23.76E7BA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9982E20009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7DhmpN0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011840;
	b=nKp/7BBiYQSj0N4v1ICA75oJNMii38dhHPo4G7WkCWwsVZs0djelWFH82wfZe+j3WapGpp
	LyNcu5GMeT6VR5J0cCNacM9Te5uRirXdvDmFtIsqrLZzRl/EERyHQtXzOVgMxKgfI9HH0I
	OloCv/tagJDhG0idAMbvOpoFLgxrtYQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUFF8ihBt1kNc/OLwiTGvCS0cCJuPlqdLR52uCLjSi8=;
	b=ueSLCwNqRnc2Mx/Laga5eDn4EOQSHooT8PRFUiqm9nY++yP850wBXEFzvXbNaikD+Zx13N
	eUAD+6REQqgMKqpjfIgXMo80iAt7L/Q9P/X3AnWkV6Ere4aQ9br33UFBwmXg3U2HEgvH34
	WA7GEInsMUDu1OlAGwiatJIlpMZQUYw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7DhmpN0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7008060D62;
	Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011840;
	b=zjdZdRHO+LhMZg6GzotNudaaeL59oliWn1QypSoN1arSS4SJvPq0SF/XuGyoTKS6My53
	 jegL+GhMQCixP6BaSdOhQixt9Q/Cu7VoxF52+FXYZ7KWm6QCycPIchyD48HYoJgTjgZaC
	 utkoAubONlDR5Vgcjf+sIFuuPFvrmmcc+GxKM1siqeV4/05YZv51kktwZYTonWUg0fcu7
	 Hm3RsTl/RlUqus5VW29//oCglNjdzWiJVUdsykOiROGiJUp5uOh0LdOrKM8hPoUGMlWF8
	 8rTHybgW3f+sWuIx1FRRcRMVBS/UuHC9zY8kXqfzxXGOiCE9ftK8hkMDgwrOY49TCiQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iUFF8ihBt1kNc/OLwiTGvCS0cCJuPlqdLR52uCLjSi8=;
	b=TyWdXLqod+8/EI6UXAq5DdkkB6lBVdrRDYkrZ1/uua2QKEHmSIqkgZTHqo1T3jQgmrTD
	 +xWaZB5BxC0h/Mh2FU2KtFO9AbymG7ZTWWJj4eByyvQoZv98mfhDn3IRKIJmA8Ukm6Goz
	 ixNJ3hLJCNfFv8BDDFY6HW8kg5PrTWhrxqEWcf13z1oPtQSPOX/Mx4l9Fpofa7EKQwanR
	 YgOmAx6aKiEH84fdAhqbx3U193PWMl1rvv9xiQsi5/eqILYWdB0ld0ypW8KkC9zoXlMxE
	 mQ322AWAEQX7NRbfuyfuzddK801CXmRL1FpJGILsBOZwj64O36FIqhlS1yZ4AWYsRgg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DAAD01F00A09;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011840;
	bh=iUFF8ihBt1kNc/OLwiTGvCS0cCJuPlqdLR52uCLjSi8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=n7DhmpN0wvb9h4REmbSEt1Lq9D+wPsvxzHDF5tjTk1zufmArJ95TKy/3rg/BdsfeN
	 iszRksMAOZOmnPVWhsF7eUmV0IuVjqR7TyZGhdF+XYrBrQ92cO28MIhe9yrPVe9Y4Y
	 tUyjSQYegUES3MEILRy7TEcVjNOEtzGnTlp0h17NRUz8fGOGeCwJmUUE2PQqJIKWvV
	 fD1J2KxcPa30P0b8bx7YVQ44p1L1JkqJ+M/Id+QPCjYlapksz39/5nqBB5O9U20CyD
	 fROhWzE0xWC1URneQkpRowWJq6u6Iv3PfOfQwTx3Vh0pQOrJFRfloeufhwG7+S0n01
	 +ZczOWdia9tTg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 61A0E47A51;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:56 -0800
Subject: [PATCH RFC v3 82/88] KVM: selftests: Verify VFIO dmabuf creation
 for igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-82-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3911;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MbD33+QhDIw1sC8OkTEtVrBZ+IoL3RD4qfhKhPg8oKQ=;
 b=7iVZ9xRpmIAg6xpTbf7wls4Z/04O441wO1Vwt3NgTl0XIJAE2iswEYKcjFie8IMkCRGxXqAKQ
 8/ywYYSClSZASYJSFTxZ80gUqe3p+BNGG16CJqQEWTaXedsT8K4Umdm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9982E20009
X-Stat-Signature: ze5es4b7x6rp49n51z1d6hhg9saoa3mw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011840-754433
X-HE-Meta: U2FsdGVkX1/+ZYj4TNA00BYBOaAoqJI6GZzfooeUya+tc5A1oX9uhx/qQT63IGThc0IDBmuM3SWBROJ5Ypb6Id6xQml69vq2/lDw4mi/RpxCLDB5ayYWUSMbiLvYCyMlxjowFS1piPVlNU2l36wk8ou8lgwl8NY2vY3mMT9hS/UafzD75GD3bfOLQTmy8VUowWQ/wpXxSX7tF8FAfEuJwMcjCe4Nvj2L5Z67JnQMS/vlHKHGVrJvrWt3rjT+ACr1ZGzFPQE9ks1A78UbCcLIj7xHAUQLJqD14EE5nrbNeiz1Y7gasq2Z4XiAHP4lrfL7/eaXxuqtxR6LFK4MK6HiZ1DKOVopMzCwPWRrLkLOBnLB+zqksmj8an8x04jwYkodPEEa0Cm5QTCYKjUm073pV5fm3nNAXDWnTg+yzLRnM9iGsiV8ZvorMyMCQ1mwePXd9Fhfg2YtqdHui1sYZBt9tEDu3NApFCVnyyLL+akIwcdHm42ZvXxjM//Pgwy3hKpTVLWsFpv3thbtRIW5SwULNi5KsL21aiKaGPHxTkrXyCEFYLOahr7z3UL/iY6QjWJzldzyHwaCQr+ITupdHuqpIgQDPQowpXO1OL2qNk+wB2B9MAS4FsBfPqUeKzfwN3Q8ms55khPJRPC8b6tec6uiLkNbiktVz8CXj2A4i9pc86027/qlQR/2i0BKQmP4cDWqthLMscA8WYbqlnlqu06uHg3+j4OgDQa5d0avnHBinFmdNuKjsHZKJtcTwqSlzAfcDoV2RNL1qA6d/6rpPucma9O9ROildasGK7bm38HtUzfdHXilovQ0Cpt/91jGY4ymDbcVRiKI+B7akWOYyeNUu3U55afbHp15E255+8YzdQYBGt4ZSFzMKtcjIJfomjjJRiGwLD3sa2x/X/eQ5/Jk82hFOJGe8G8HpDHeRpUhcYLeAw1U/aOdfYH3qT4YOn8x1BB3eEQq+KYS5RF5Gas
 kaKWH1RY
 gqQrIj0WmW1xQB5KifFkhD0DhyT8LfSvw7voaLuyc5UJeSnC4vTBGWQNhC6MkqSm8IzDU4kUcsF0swHTnMqsrKEFaUSEwX+PQoShjqmNM0QFq2riqorZA9h8Z0XAX0oP2T4x1Aj3EsogbDI4OgiLTsCr3yHsALPHY3XamSVTfb6hbzJwcg/bYRCLzash2K7HI7ar0qtfREZjj/husm9/cYRO0QCGOSYtcwRylYjPCZwhzbdOEaLcQPBAAA+i3p8BKfFb+Bva0PVY9nA5xc953Hd8tVippmQ9RBfNqG8cgo3suY33r7GKz3QkhW3hhEJ4wVLMg388ceR8dr+jHqImtv3Te+sb2iRt39ARM9CZs6SogcwYI9rILDq4Kd3O3bsP6zPvxwNELZhvYovLnAyFwSrqgP/lF+bY41Xo1GO2XFAHvJ/hczRE/Wx3nD/seqql+S9segq2TNgBnllHpagcA7WarVJ7QKQuBdcn0C1a4bnjOODdRxUys5I9ycZTPmwD0FBdeh2ZGoHk57XIqSWhfmE66G1jg0e5E/eZScKK2Db7bQKojK4+3SaCsrTvKQdb76v6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify dmabuf export via VFIO_DEVICE_FEATURE_DMA_BUF.

Probe device feature support using VFIO_DEVICE_FEATURE_PROBE, skipping
the test cleanly when kernel dmabuf support is absent
(CONFIG_VFIO_PCI_DMABUF or CONFIG_PCI_P2PDMA disabled).

Allocate and configure a vfio_device_feature request covering BAR0,
requesting a dma_buf file descriptor export via
VFIO_DEVICE_FEATURE_GET.

Verify that in direct mode a valid file descriptor is returned, confirm
that attempting to mmap the resulting dmabuf fd fails with -EINVAL (as
VFIO PCI dmabufs provide peer-to-peer kernel DMA rather than userspace
CPU mappings), and verify clean closure and resource release.
In guest_memfd mode, verify that dmabuf creation is rejected with
-EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 0339794fb6dd3..46d325228bda3 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -651,4 +651,78 @@ TEST_F(guest_memfd_vfio, guest_mapping)
 	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
 }
 
+TEST_F(guest_memfd_vfio, dmabuf_creation)
+{
+	struct vfio_device_feature_dma_buf *dmabuf_feature;
+	struct vfio_device_feature probe_feat = {};
+	struct vfio_region_info bar0_info = {};
+	struct vfio_device_feature *feat;
+	size_t feat_size;
+	int dmabuf_fd;
+	int ret;
+
+	/*
+	 * Probe support for VFIO_DEVICE_FEATURE_DMA_BUF. This requires kernel
+	 * support for CONFIG_VFIO_PCI_DMABUF (CONFIG_PCI_P2PDMA). In guest_memfd
+	 * mode, VFIO_DEVICE_BIND_FLAG_CTRL_ONLY is active, so the probe itself
+	 * is rejected with -EOPNOTSUPP by the control-only allowlist.
+	 */
+	probe_feat.argsz = sizeof(probe_feat);
+	probe_feat.flags = VFIO_DEVICE_FEATURE_PROBE |
+			   VFIO_DEVICE_FEATURE_GET |
+			   VFIO_DEVICE_FEATURE_DMA_BUF;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, &probe_feat);
+	if (variant->use_gmem) {
+		ASSERT_LT(ret, 0);
+		ASSERT_EQ(EOPNOTSUPP, errno);
+	} else if (ret != 0) {
+		SKIP(return, "Kernel lacks CONFIG_VFIO_PCI_DMABUF support\n");
+	}
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * Allocate vfio_device_feature with trailing vfio_device_feature_dma_buf
+	 * containing one dma_range covering BAR0.
+	 */
+	feat_size = sizeof(*feat) + sizeof(*dmabuf_feature) +
+		    sizeof(struct vfio_region_dma_range);
+	feat = calloc(1, feat_size);
+	ASSERT_NE(NULL, feat);
+
+	feat->argsz = feat_size;
+	feat->flags = VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_DMA_BUF;
+
+	dmabuf_feature = (struct vfio_device_feature_dma_buf *)feat->data;
+	dmabuf_feature->region_index = VFIO_PCI_BAR0_REGION_INDEX;
+	dmabuf_feature->open_flags = O_RDWR | O_CLOEXEC;
+	dmabuf_feature->nr_ranges = 1;
+	dmabuf_feature->dma_ranges[0].offset = 0;
+	dmabuf_feature->dma_ranges[0].length = bar0_info.size;
+
+	dmabuf_fd = ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, feat);
+	if (variant->use_gmem) {
+		ASSERT_LT(dmabuf_fd, 0);
+		ASSERT_EQ(EOPNOTSUPP, errno);
+	} else {
+		ASSERT_GE(dmabuf_fd, 0);
+
+		/*
+		 * VFIO PCI dmabufs are intended for peer-to-peer kernel DMA and
+		 * do not implement mmap or read operations. Verify mmap returns
+		 * -EINVAL.
+		 */
+		ASSERT_EQ(MAP_FAILED, mmap(NULL, bar0_info.size,
+					   PROT_READ | PROT_WRITE,
+					   MAP_SHARED, dmabuf_fd, 0));
+		ASSERT_EQ(EINVAL, errno);
+		close(dmabuf_fd);
+	}
+
+	free(feat);
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



