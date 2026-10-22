Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE06F606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RIvYO/NQ
Received: by kanga.kvack.org (Postfix)
	id 56F226B02FB; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9E96B02FE; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF9B6B0301; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1147A6B02FC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CACA160351
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
X-FDA: 85351853370.25.5F9D258
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CA611C000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RIvYO/NQ";
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711703;
	b=kNiSFVFHvFw0HswOI5E/9fWZ7zEMB/s9XJ1kxvswFRpZZQmP7S3rnRPlsahZnS2OIggfDh
	loCRNmTg/luS79rTuCZ/OgihGyYtzesslPaEdDg+p/3Z6JuCZ5e/Bufg5q5gkRmMM+mg91
	yOCjhFWggJrFnYLMUS4zySaEJQs7/N0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RIvYO/NQ";
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12G1tUKOcCzdQ+EGKbSED/OM//Ixz2V7HJnGAxW8y2w=;
	b=hvn4UjbPo/UkECULyqKrVJd6QdIsGZp6dMEWHdN6ilsFbzRqG2W80DqMjyfEFrGEzheE1i
	jYSsGMopNi47Ml0bziOw2tDowwVdZpMTUomuvPLqWVhHCddEKuARCgV9wtYsPSThKtrpeX
	+ACXx6O433ckNd7By/wtX5Zx9S0d0QI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FDC360D89;
	Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711703;
	b=Ji2mzA2EOfTPK9jsYhDXohgg/n5DKramxdJ2O/ev6t5WsI71Zrs2oV6kRF5Bqdfz/hO5
	 +Hx1zhbK8BpP5geeIOQJhZHz/tQi35cyPNKL6zfZ115zFmf+CWIu7hF/e0Sb0yPhiiLRd
	 O0As1NHtA/QU6e83y2Aa/PjHkdrpQ/KySGUXokWKVc2ySBprlgaKhFZXZG6U5AtP78QJW
	 1NxL5DkgzQzrshnyqVN8mXMOZzAjvo2QPgxQsymft5DsZTor8FX63W64zGyLNETYTPL3f
	 eDATX8jaTFa8XZNTTxYp4XEEtMdbjORVi+guGOoFQ5ri3AgISN4sxs5GZlr+HkThPig==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711703;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=12G1tUKOcCzdQ+EGKbSED/OM//Ixz2V7HJnGAxW8y2w=;
	b=gQlqOaP7qvMA/DYQW5xK9U6FzSDmYf3IUbG0t7AwqZNGBpSfgK7fLjD0lwWlb/NJBf0u
	 tv2DaNv+D/+9wUaooErcC6wm6lJ7YTnDE1JEqlEX8bZt8E28nSQdczc5/QLWYF+Mkaj90
	 WdU2YLdvchdLgFzNDN4fpH+87ixCuOoo7IJWK6Fg7axaDAfETvaepZSK2IZ/ngiWzIa2V
	 GsJ5+SzVSmLWWmHLZ9hvshpLalNigliR8MHPKeXsZDw9/V2qKPSBoMyZ/lFtVLPIVknSE
	 i/da7ApM5Y/oeaB4Ce1iH+EigAlzcv6iWJBzq/TPuGbl7AixnUdGd5GLFdX+KxG28nA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 27C581F01196;
	Thu, 22 Oct 2026 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711702;
	bh=12G1tUKOcCzdQ+EGKbSED/OM//Ixz2V7HJnGAxW8y2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RIvYO/NQDpufew6XKWfjIrSSeAbZa+sHOsgOgU52oBFjzE0TLk0OhwQtC2jpu0H2S
	 L0zSra+2ZKPg71Gl0CwS1sUNoWCLu04bKFN2CeZRYCriHuNA+qirEyWxW9YyGj0J6S
	 A4awroWwF006oO2mQVVlMXi4SHDojliy2zVe7HYwspVfl6B8vq5LqPROI9/4JYghnz
	 SKKQZ1QbaF1v6uZNYfrT/VxZer4zni5ttGFRhGCI02QyoXY/1NNedjLdczoBLHIEaB
	 mxe9Dv9FubwJ/jnhU3zifq5gBIVRjAKh7bNdnEgbVMiBcWM7k3fl0vxlhNqfbAUDOX
	 6RqHVoukq2XVA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 62D62420F3;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:16 -0700
Subject: [PATCH RFC v2 44/50] KVM: selftests: Test flag dependency of
 PFN_MODE on USE_RESOURCE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-44-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2495;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hW848+QLjOl269a7jTABrUtgNNZFcVVtDQ3JXHLCB+w=;
 b=fU28rqS9xlt6ezgnpahjWog+2P1ewPQlBSE+tyB8TuF5+17PJac6BxJaoiYMYysn333j5bn6N
 TnDkxIkJYU5ALgLLw+3zeLxvcsKbeB38GL6yfutX+0WrdXscM2rsPom
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CA611C000C
X-Stat-Signature: 1zdimr1a18ngeixuijj55n5iqxyjif5x
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711703-791243
X-HE-Meta: U2FsdGVkX19ox1tCyaRZARgU6MfvR4Q4OQp3ksqlhe79MoIgWGRMw9GMAPb27yJNDqWhQR1cC7grCmyZ2/OMYTWqN5QF0Pt4ke7YFO0BXPfGHB6WTLLqV3y37y5MnIgBud6IcqF6g6kDm3PppoalkKmOrvy9z9hFt4D09NzpCEKKI5mVYLaOXjsNAmh4j6IXUy7pty4D0KkfYCm1gIRYipFJB5F5Gp+RyblDrZjS1ClRqYLvI+LHlIrchftbIFPgbTfUf7ppmE/gWwFpAHP+qKeVntP/9u33lEVWT6YI1IFI8+vUGwP7LdZEJkT1ljVMussaXv9icvpE/8cMc5cofndJ/Uk/2j7zk8Gmlgq8KsmF2d3j7M3nRH9k1WKEGLn7sjguCYPbggIpruW4QKO4vS2OXspfDK7icazY2a7g/+fHOHI9gqY7NgEbFJfPV2datFB09u2wZew5qY3opDsd9vq+Jk7c21wICfPkwQpjrJej6DcHX5G4oxUvOSbSLLjGdXOWoCKfI34Xgukym8z0n7l3ZkSgPAn+r5r0FGDWZVyqlU2txBMKZPoVL0/AJQ45Px9VmwbDrMeoF1Z0fFHWdzgXgNHAWr7tr/uWYT9Pn4JV3SkzqLGGdnXJvrzq1i5/ho8+a20h//+mbSED1ca+1Itn2X5aiyq7vLbZXF2yGyQ+ORGhDIN2dnWA32Rszk48FDaBCxMxs+fZTPbO+YPjhXjE0mYTkMhECAaZwGQWOO3270+Vr3kPm3knc/Tc85YXKTn4hGUypG+nuclLL6/Ct7IZTEk6kT4a1pQ/nDQp0jAM+yGg15RKcguKhwsOPUk5XjeW7WAbseZUqWnjLOW+5QOnM0GldH3oQpVFE7rJSVifqBgyomx5FBtsFntBzzkXbXEMeBNZVp4anhB2bo4BhwKkd3+GY5L6myV/RxGSOHk6PEOdkkcdm5VMFp9Z/igtxNnsnpJ79fQbwUaKN0I
 3OVC/mhu
 fc2yZBAUBfzSNZNM/XV4R7rQlIdDFAKDTAW6Z4Jsz0BydRgBUmnDGKwicM7d0Sr7hG57hBQygBkJ2c1Lz4GZAPrspyCyhXxhvmB/d66QRL6nS+kFnF6aE0FWxazQ6D6Q1m53oWCPp71olBI2rbKbMEHX/SCauK7b6fG2ti2IJrasUNYdNcH3EOAWIKZU7wZOGPjgn57a+X9qGMK89twHBg3CzXUP5UVxjLH+Cl+JjA6wRL1G04S4iCR3RPmCTPoSSLOEOJnBMoI2co7ueQaDH1FugZCD0MO2A6ZJoXAp8HoHgCY7CfUXi6R/F4u2z4EXqvZX0r++EuLg+HipCcU5jQs9oXdKE63yZECUcVCTh34Kj2/rr2utQkXY8bvR4heXKwHujeIyQymxmkEO1gITTF2SImbK4AkyqcD0+5ZgBfVj79XBIkQYdMpZvWnJ089yHCI0UllvoUmdARVLU+5byW5stbo/iueUu3M8V+KRkXvDRLeilUFWglqUmhnSLyLZU+9MoQRZh5vXB8+24pzi7NhDUUOkEqSnRohycywCCzPJKJ6nANSSczlv4rB4ozdZPafveWIl1uLspzBjh7lUHJRnM8/s1nWDEq3m/CmGyV7hBok8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Creating a guest_memfd with GUEST_MEMFD_FLAG_PFN_MODE requires
GUEST_MEMFD_FLAG_USE_RESOURCE.

Skip testing GUEST_MEMFD_FLAG_PFN_MODE as an isolated flag in
test_guest_memfd_flags() because creating a guest_memfd with PFN_MODE
alone without USE_RESOURCE is rejected by KVM with EINVAL.

In test_resource_fd_invalid(), verify that attempting to create a
guest_memfd with GUEST_MEMFD_FLAG_PFN_MODE without
GUEST_MEMFD_FLAG_USE_RESOURCE fails with EINVAL.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/include/uapi/linux/kvm.h                 | 1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 66c1f40b50c29..3ef7bc37a7070 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1655,6 +1655,7 @@ struct kvm_memory_attributes {
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 #define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
+#define GUEST_MEMFD_FLAG_PFN_MODE	(1ULL << 3)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cbc2f309664b2..fb9d50be2e3b6 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -407,7 +407,8 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	int fd;
 
 	for (flag = BIT(0); flag; flag <<= 1) {
-		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE)
+		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE ||
+		    flag == GUEST_MEMFD_FLAG_PFN_MODE)
 			continue;
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		if (flag & valid_flags) {
@@ -432,6 +433,11 @@ static void test_resource_fd_invalid(struct kvm_vm *vm)
 	TEST_ASSERT(fd < 0, "guest_memfd with resource_fd but without flag should fail");
 	TEST_ASSERT_EQ(errno, EINVAL);
 
+	/* PFN_MODE without GUEST_MEMFD_FLAG_USE_RESOURCE fails */
+	fd = __vm_create_guest_memfd(vm, page_size, GUEST_MEMFD_FLAG_PFN_MODE);
+	TEST_ASSERT(fd < 0, "guest_memfd with PFN_MODE without USE_RESOURCE should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
 	/* Bad file descriptor with GUEST_MEMFD_FLAG_USE_RESOURCE fails */
 	fd = __vm_create_guest_memfd_resource(vm, page_size,
 					      GUEST_MEMFD_FLAG_USE_RESOURCE, -1);

-- 
2.56.0.257.gf7497c7d27-goog



