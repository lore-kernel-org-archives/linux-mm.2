Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA13606A82F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrBWd6Vu
Received: by kanga.kvack.org (Postfix)
	id 2326B6B0608; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144316B0602; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B746B0605; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEE206B0603
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56FA41A0278
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
X-FDA: 85406459166.10.28A88E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4059840002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrBWd6Vu;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWCXc+dnEMwbKTD43nC4EzRdsnsdpyvJeWlTCArQCRA=;
	b=GQ4WsY5BgOdDadK5x/RV3jL86h2mqGg4JxED9bNK91I8HJsTBObQ2i43+tI9bLXWC47JcC
	DlIptfoLppp7cn9qL8ebbaqMmKdck3fywIYgvqpxN69q8GHIm6MzUJMCLTM7BoCK8u2AXj
	x41kcgo+yl7svWQQ/dDuDIKsV/SfhKw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=h5hrJG0Iww1vp0Yk08usu3gt9EPhRX6SxPDvlkJPAtqaEGBfwYE2nnMam+Tj6eMP73b12I
	s+xiyPa07UYj1Pri5+e51fOkqMumBLu9EFY542GIraADcgxC9y9TXIUUqnR4imncxGWGPA
	FlBBv/rJKQH6s43aqDh5T+YA8qF0w3s=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrBWd6Vu;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C67941FBB;
	Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011840;
	b=um6h63HLeCa8SHiHA8pvn9VyIT5T3n2fRgCDGrhDQJOlBUbYS5TXkJbl/vuuokN8uqa3
	 9RBrimLF6FrqUS2ai4YoWQ/QvynlXSoQ37gm2RXAICftctPes/LzXqOxDxiqAMIzPQJ6v
	 jYUKhKx+aSR6IbsnOdW6qnJqG5R4r0XlWhzIt3dbCvDmM+CCGRs5Ms5Nw+gxrdlZPgbXI
	 To46EC8Q71RU7/nOt3o0vfHmyfvyo9jWcXmMZj3sCLHqnhvTxZzrHTi7ayyT7GsBlyduY
	 DtiuYYZ/AV34729CWjLd7ftNFi0xUpI+Eps/RtbGneUyR8MuDg3eS/EsJSQ7e7QboaA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OWCXc+dnEMwbKTD43nC4EzRdsnsdpyvJeWlTCArQCRA=;
	b=J2E1eUc7RGU35+GCxHOHlXm2bQK53e7bBYieiVp5pvqGOFaAJRtT/3/WOd4JEmYWWLpO
	 BsnqisBeIf2pIQa5KZcgurthYcqHKwkJd9m6WO/GuiDQ1ElizZ68fdLiAn+LIuKfEJglY
	 IVWM6ENkSKHlQsClC4h/LXm+UIzXUy9QTvow76fMMbZoEJO/6jvHD/65VqF5HQYci8Aqs
	 ETd6uXEhn7jL6WfmVdB7PnzCKziB74YSSeHnMgCmkXtOUp7ij49PBr9gR1EwXDtofMFlc
	 limgh9G+xG1bCMudziZPHgelT0jaM/6Y4PCrWHOxWfHBzr79M8iopU3DV0bENqWkFwQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4D0D01F00926;
	Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011840;
	bh=OWCXc+dnEMwbKTD43nC4EzRdsnsdpyvJeWlTCArQCRA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XrBWd6Vu3Moee3w+OGR6e3eLfKy+aBp2gFpBtsgi7DQ5JQo5FFStzw6fKkoDhXSkK
	 7GrMP/nrDKJWCoZUjTynFZ2E9jrbBHF1CF2zQPFblXFOYKhqoyGeQx60p/dSRMHbCq
	 Q1RXnEA4Q3JDBM0TtYCidmnqzGWf32tZxNyDWB7LE/JxMDXkJZRsv6DPlPko06NiJF
	 T9GB4O0IBSntioURmoEYKLfYpDsctSyIDK47aSoD0odmPXaxoR+S8jNKJ4z9a8eRZL
	 m2roxUhYjfKDwumhoggheCgFzmnuLNHxFpo+2N9qNp2G8u7Fwsp6zyvls+B28ICCuv
	 fLJ5Mv9m4aZWg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7ED5147A58;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:58 -0800
Subject: [PATCH RFC v3 84/88] KVM: selftests: Verify memory conversions for
 VFIO BARs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-84-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3071;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mn5g/ezQrSRqlCWnN+nnDw5IsR21Pq9gAvdK+Fhz9Qs=;
 b=i70tv0oqLMTnZRiaorGz0DGcWmezkAmqsVWRLymSSoaq0esH9n1mJOUngKhCcFjJnStDZemCf
 0HxnamsoFriCtQi8zwQet6zCIbYdktgo9xCiTYL76eXOLvQvfBusRFi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 37doraspxm54zx7ufehbiee5meakfyx6
X-Rspamd-Queue-Id: 4059840002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011841-811141
X-HE-Meta: U2FsdGVkX1/MB8wiL/mK9dB19V6mPl8M+UIfmaNdN8ouG9UyosC/cAhMaOgXbRhdwA3qYG6vWUjdWxulolcT73BxxBSHwxijRx++d311wZs6gvsbx8mIVNy6WmDyZKSCNVteDgiiBAZcu+MMdGAE8NVi1Z7QRWRtMaeo0k5TJYtlOA9isSQDsA9zYp/rBOCR9ZYgpGqA5MKnDtXJ7jMM4FdBHRVPt56SGDjySagXh0/RZBZLU1aZb/sb4wdADV/CiDSnUF/I1QwuSiBl5WSkLnq89oLdziZ7ZUEJY067JcLql/AqQYG51dokEEu2/OfjtLhb6If/E5xzW2O7iQ3fpg6BLDemOZznTwkpWydA+mRnHTNm3AETlU80xjlg8W0x6PFMrimq2h5Mwdr+NRus3UtKWy2s4GWN57R1ieWiszdZwahALZVq60lX6lddeC5mHkqnrC8wqxI4cfivZQAN1zPgF398h14dXtw6iu85hgNloikmYCpR9Jzqp9i2URNRUjgSlh+KbBrYTMfp2SwXEwGteaBKhsekbhnADf+TzPQG1SocNFQGXeibvY/gu6yhJxSeYvBdnJ9W13HCMBB8OR1hZxf3dKPQoBwe9VjLo1cEt2jpBshkHYqINo6DJdpzl4L6ZVHCDnu1fg4l9l7y1p/i5nv4qHnypm4nS402N2piq8rvtfxdORqbcps9ad6cXZ8f2aVttt7Z2jfPoShpb3IpCQ57xh9A/5Q7zCumAflt5ShC/pPR3URrs3aPdLYzAh4ywBqgRmznhugMkFvTIUt3Sf3iUCHGPHwadx+QptGAuemNqyP0B0NyC+INhvHffockUeD6zqMTHT/RIS1ABZElJP6iPqOvvGncW0Tlk/5UlJzXpplW6/oCNEhtJ2bQ/eUfQmQRled4koaaErnfaQer3NxoOBiAI7sfZRLxUL5On+wc1IZF8rYRde57EkyMshA9NSK5GfWd7Di7kSr
 j0KuErTP
 oiGgYeOjV02a5q4XXNRYgZQ1RnQj8MOmxXhnXSbKZgj0aGGN10sffTBvDqMSJ4e5vbfMZBf5t6/sPNAf+sHtu+082rR0rOaTmFifCZCoJN9NVdvBcwsJCdTIgEVJamXaQavlEtQczeEu4KauR12kfljMjX2sazUi6q7O3GB5fKsV4OglEy+/WFEn7sPsJ4SFKMMyQIAAJYClbttnvz1nHmw8yGQ7+48w8wVG+ulkxLWlsUSc/hrRIUDOWHXMHWdxUnu+AxM1lZmJfbYUnCtJDIwx02WI4lLlSSx4OCpAdfSaoO9rokOh390l18XszUG8wB/8IEOJEmzc1pXcZrVjPVMRv4opNc8tPbAsE66VS360L9OO29xuS6iVJ2KJdIaxduj9Uoy7QojBF52ojzEWJRhOulwFRhFnWLh7icutnBK2dN3cHfGTl/zri5EMQWJ9eRrHWoU6mhY8h8w47iGr3aBWsxCLixzlZ2Z5Dx2AgHhqL1wzFlfvMh7iecmY9UcjSWi3sJVEeAg+AqB68lJN+vxP8fkyAIHwOgqOmtngRUKuMU3TmGioJRBYa4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify memory attribute conversions on guest_memfd
files backed by a VFIO PCI device.

Verify that memory attribute conversion to private succeeds on
operational register BAR space that does not host an interrupt table.
Verify that converting back to shared also succeeds cleanly.

Verify that converting a BAR that hosts the MSI-X vector table and PBA
to private is rejected with -EINVAL, and that the returned error offset
identifies the start of the invalid range. Host kernel drivers program
MSI-X table entries directly to mask and unmask interrupts, so
converting these pages to private would trigger fatal hardware
protection faults on confidential computing platforms. Verify that
shared conversions on this BAR remain permitted.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index dde249571ebc4..18fab1a39041e 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -764,4 +764,54 @@ TEST_F(guest_memfd_vfio, ioeventfd_creation)
 	close(efd);
 }
 
+TEST_F(guest_memfd_vfio, conversions)
+{
+	struct vfio_region_info bar0_info = {};
+	struct vfio_region_info bar3_info = {};
+	uint64_t err_offset = 0;
+	int ret;
+
+	if (!variant->use_gmem)
+		SKIP(return, "Attribute conversions only apply to guest_memfd");
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+
+	bar3_info.argsz = sizeof(bar3_info);
+	bar3_info.index = VFIO_PCI_BAR3_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar3_info);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * BAR0 is an operational MMIO register space with no MSI-X table.
+	 * Converting its pages to private should succeed.
+	 */
+	ret = __gmem_set_private(self->gmem_fd, bar0_info.offset,
+				 bar0_info.size, &err_offset);
+	ASSERT_EQ(0, ret);
+
+	/* Converting back to shared should succeed. */
+	ret = __gmem_set_shared(self->gmem_fd, bar0_info.offset,
+				bar0_info.size, &err_offset);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * BAR3 contains the MSI-X vector table and PBA. Private conversion
+	 * must be rejected by check_set_attributes to prevent host kernel
+	 * writes to interrupt tables from triggering fatal protection faults.
+	 */
+	ret = __gmem_set_private(self->gmem_fd, bar3_info.offset,
+				 bar3_info.size, &err_offset);
+	ASSERT_LT(ret, 0);
+	ASSERT_EQ(EINVAL, errno);
+	ASSERT_EQ(bar3_info.offset, err_offset);
+
+	/* Shared conversion on BAR3 should be permitted. */
+	ret = __gmem_set_shared(self->gmem_fd, bar3_info.offset,
+				bar3_info.size, &err_offset);
+	ASSERT_EQ(0, ret);
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



