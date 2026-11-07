Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CC9606A83C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAglrdYv
Received: by kanga.kvack.org (Postfix)
	id 0A8976B05FD; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080D56B05FE; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0636B05FF; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA33C6B05FD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A1251A027A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.08.D0412D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6324740003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAglrdYv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1WAIjsJ2f6GPnFK9J8tErfe5hVo5E0rwAzvzNh8md8=;
	b=NKk3sxKM0/r3Asnh1dnMh7VRkkyFGP/eyMh4OylSXitYbHppd89yiW9O4iWMEXifyY93N6
	ccwpEACosDCwQMvkU6uBUmFelDySpbtV+G06pc1zdPBvV4w264YvIUYPpu9lXgyd3afqMR
	ikdxFyPaRc3JFV4aGHfbqjzEKH3cJBA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAglrdYv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011840;
	b=Http5w31FzZaeT5Bti6wR4Qlz0pd+VKEUbOkFzqEOSFkViTlCPfutq+372n3tLMfHi8ka7
	zRs1PWm/Bs08Krce42ZrWsjRXV86ci6i/vCIib+xhbrDu0o1WUn5zOMpL/tMNVpx7a/mUO
	RGX1cEBC4jSacKRXOp7Y2rQ5sjaQEZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADC6440BFD;
	Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011839;
	b=aGaBpPuu+/mFZvkAp1rSH7Yasxkx/nnpM4TaXfb2dK0m+wFH13jBhH2fAggftFj/5c6a
	 mGEPTy1zM4zsAX15ZK5kX7K2jJYr95Ub3yz/vRVUdI4H/z6xUnnUGNVwdFh8bKExslELk
	 tqJpstnCgh7RjUMrxK6prnL7cDsdyBVXvUhXQN6OBcfeej341XTqyZIYBYu8/vpADTSkc
	 HW86Bn3m/5fvnbzkvgA05zXHtbM54nQ240b/igXHa1GPbE3RwENTeyVTKg+gJ++0H5hGd
	 KrXsgpax8Uoz4sy9Mm0EVMbX8hrpiDCwv+WuqFRwVNDDMZGJSxclO5dCApIg1k/jGSw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=L1WAIjsJ2f6GPnFK9J8tErfe5hVo5E0rwAzvzNh8md8=;
	b=WFogn1wF4vd50mLOuJIEk39V8ZxNJmY7BZ3IzdASS+OAbsuN3xPTMuwG0oy1wI3TznOi
	 BpuNjiUFZQa70llOCgQOc+pEBVrZr4wmXBFw0aF8F6KiZHiE/lL6sgDwyXx+eezZuqZit
	 QS00s0Buvq6MHhxcd+O8lRhumdoFiQ35rkvNBFDY+4KoE0q+NvAm0d0tNpZrtO2qkBvQ3
	 5u4jOLtVvVFkfQ6z4lExtYp+fDJaIwsxGMjAH8CH/fhOQQqAwpnhgU4HSJIaT3c8InL9v
	 Pvkv24J+wPmQ66gsIRaRGbEhhnp6l3SGNOPekxBR3JJ7DK/9FCS/2NzWWzUXlFmpdtg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6BEEC1F01559;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011839;
	bh=L1WAIjsJ2f6GPnFK9J8tErfe5hVo5E0rwAzvzNh8md8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FAglrdYv+8+AjI1vNIVfyoBykwq94B1Jsxzaaxp8BIhzQAoBm0Np9IlyKyja27FQK
	 QhhEpYPkeujEXOtnZkmLfwjj/VxY3nUaiCCTO/UGKsyGiLBC3fAQ26SatWOphJZCHy
	 T6UeH8ua7lxafC1ICU1pXKxHKsZJ0rIvE1EupfWX7TrVPxkeGpeFLpZWatdbG+O8re
	 NkDWs50HEqN2kaSc1Pq+A/vTWFx4s3f3fq6PqQqRHtQZNnoQv2JilSdWO4dQNP0TCz
	 k7i1F9pmJToF7d7XteR0Eevx+cmXcq+H1in/UFsoUvt2EXY89m9+W+aLeCtF91qLlm
	 96tBRh1msbJcA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3F1EE47A0C;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:38 -0800
Subject: [PATCH RFC v3 64/88] vfio: Add vfio_device_gmem_revoke helper for
 guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-64-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2301;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6gfs4j8uCHpXnOLsBDGwfvIT0AGOBGHhi3wjtxG21zs=;
 b=2H/FjEoqaNY0u61FutI/xynBHktbS1ilj9Dq898KbDy8/638MzV06rs1q4/10qrHH8jGsnUXo
 LfFX9u/SduFC73ybrCdDYFQJgPwbpocGEFiTpmQbgpzVeqgnbOtQGrB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6324740003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3fqpj6xpdc97m8mq8sfhe8h5wx33deic
X-HE-Tag: 1794011840-458355
X-HE-Meta: U2FsdGVkX18DYATN6BROiyjUIn+PBepoWSoiD041bXy3ythDZupmEFYbPIZDKEVG0QD9TzGH3zc1vlL2GT9o+HoqMzhnBE4Nfun2AdgmxXRNvUuEdZ4TAPj1n8eOiLL7h3V8jxgMLNZMrsGp/6ytUr601Dh/5ppH4hysPV8Sf1LWxs9GFGqqGcbp2hq18H3vkWHRJrgKjRnJRZyi6oONDMQV2I07iGh7dn8G1KpzJfBx4ex+Zz23ag+5IIVc21vOx3LE5ZMCbSwR+a43el1l/gWqrHSoktN7uSQpwPibZor2qJm2oBOgxEun480cH91PKf2v86FMgZdl81Jai8z+7eMS+07GWc1MZdqge7lRlzc1J4npgI1fQJERQSLUFeSxgi9xzNEflhnWGt8OPyCTWt36i4pZAD1atpZyMd0Wbp9iCWPJrCI8hdCYxTG6iaR0Av3IJdGWmQywC0xx3o82Ju/VywvThp3UwZUEoM4MIic6lQx5921Ms803kqrgu2aULpWU9Gq3y3Xk98wX3q7rvy4GzAPzgMA2MVXSJJgK2V8xrZl4JtI7zVp5w/n2e83FFPZko2AdlufvDfT9oorFKYLyN0CUscwL3slsOWGb7PgJvHr/wZ6txcF7HAGqR5JIb1X+alkCjOFSvBiyuZL14gM0oiTsaGoAGlT57ZUF69HofsBvfAUz/cbDPFB8IhaoQ7ILWRlJhARl+0shSegvDbjCvOFEwYv0U0GCAhx/Ny4fHiC+IYheYDsEy9so6qTn2nolOvDQPPcgqFntvAMWAfkaFj3FvedJ8xodizN20chSOVRmorXPGNwTJQfj+lmvwCYuFdUd0FYSKLn1ZtxzJ6VYFhcBsXhHZjQczmm1u4WqaTFQx68A8gOcqsLDfiq4zOce9dgmanWJcUblA8S/xRKAMNpoPSvh4v5zFSbGuU62shYIchiqeFybETw/X+S26wukfJozx2gLStnTTXf
 hiH8ZsPV
 1X3qQ60j1SXPH8SeUYDSNgrFnzlFXE9nhXQIYTJ7mZ9cpdV0TS8UdtJIR6IBr+KcN7hkRCQYy6V5Vw0npSAfX6MVlNVeO8xdiMC5zEKWeO5FBV171WUZx6lMV6AOcRIoT0gSc2h9woC3EcHZlN8cck//g5ZXlA2wXpJ3hXvJUHJD2uj2Hx62MPPBkYxuwX2kw0ffRAo3JtElyNx9OO/k0y7pu/6HNill5Ni2P0RDPnEfJvLO/a1QtOC9yVF4KdXb47otLZYLjNEXh1K8IyXyK/1g6ybt+yN71gzx1JWG8edmjy1gLhVCSjmOmEpxUMczOW+mPRUDui8QPrixBtx1YroviaNDMgE3ulpJX0vah6LCZyyxL9j/N5rziFUCo1n1qzzsrW11p3JMdHTYlRtL7bY6PodSntGE13i6bTzSHttZgx569eBeXSLt0/6YK9xFaw9apY5byN3fcTu3yt8Fe5N9IuVUE7kZdlYAs8IpUJcNSL/3c8jgNwHxV2dMTfm8ttaKRzPx9EiHdklXwbXi6BCjNWzY4GNhY2vDh6Ac7q4w+YyTYAb8iJcJGy4Zr/oRpAHqabokbqnLv4Wl+xDazz+21KVioenytW/j5XydxXklyiQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When physical device regions backing guest_memfd memory must be revoked
due to hardware reset, power state transitions, or memory decode state
changes, the bus driver must revoke and reclaim the memory ranges from
guest_memfd before modifying hardware state.

Add a vfio_device_gmem_revoke() helper in VFIO core that queries whether
the device is attached to a guest_memfd instance and invokes
kvm_gmem_revoke() with the specified range and physical frame address.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 10 ++++++++++
 include/linux/vfio.h     | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e4e7bfe77d03b..fd5f71dfc44b7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1643,6 +1643,16 @@ static const struct guest_memfd_provider_operations vfio_device_gmem_provider_op
 	.mmap                 = vfio_device_gmem_mmap,
 	.check_set_attributes = vfio_device_gmem_check_set_attributes,
 };
+
+int vfio_device_gmem_revoke(struct vfio_device *device, pgoff_t start,
+			    size_t nr_pages, const unsigned long *pfn)
+{
+	if (!device->gmem_inode)
+		return 0;
+
+	return kvm_gmem_revoke(device->gmem_inode, start, nr_pages, pfn);
+}
+EXPORT_SYMBOL_GPL(vfio_device_gmem_revoke);
 #endif
 
 const struct file_operations vfio_device_fops = {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ffb01e655735f..aade091a91fe8 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -394,6 +394,18 @@ bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *vfio_file, struct file *kvm);
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+int vfio_device_gmem_revoke(struct vfio_device *device, pgoff_t start,
+			    size_t nr_pages, const unsigned long *pfn);
+#else
+static inline int vfio_device_gmem_revoke(struct vfio_device *device,
+					  pgoff_t start, size_t nr_pages,
+					  const unsigned long *pfn)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,

-- 
2.56.0.455.g6c5a503b38-goog



