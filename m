Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1283E606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OUMYWHe8
Received: by kanga.kvack.org (Postfix)
	id 6324B6B0A35; Thu, 22 Oct 2026 19:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608E76B0A36; Thu, 22 Oct 2026 19:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BE56B0A37; Thu, 22 Oct 2026 19:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1081A6B0A35
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85F07160352
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:06 +0000 (UTC)
X-FDA: 85351852572.17.EF2F7A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FCD8180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUMYWHe8;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1gbyJWrq7gNMYi3d97cDgWKmm9v1VUHIwBQSaU0vFg=;
	b=YYxLGnM2V4ctD524ViWD4mC++poLLgbMdIYWD2H4qlUeXqN1tadM1tKVwtGH++K+OKU9yD
	jgXOIr4dHel3EsDdDc5W9KGx+ZVaTJoRCC80yuXcqA8Rhcsb+LCyRT7HsIldDKyMFsgqks
	UYk+eCZ2BzxqhKoeyow9sRXtJQUGf34=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUMYWHe8;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711684;
	b=7ifk5kctCIUBMjfi7w1mC1jtGzaNQ+wLQb41EDCzDjRw77MKHpXocsbSP6//edLkXo/MiP
	9mEjiFGO4RISK4XcXlBEeh7fm19SIex5ONAkfZVa8y3Lm287ED2UbgTdES7DU2dPhQcFzu
	7iIvbDHUD3L1PNo7VMh+G34k6JZu6z0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A181447B5;
	Thu, 22 Oct 2026 23:28:03 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711683;
	b=VsXUrsvAdrYvgXrUid1BFa1AUY9lFMOooANRmU47N6rhhiTPnzyVu0zVPIhGZrhgt3QL
	 hjIQfg/W5MX7yo37gTpw8TQEDSUxr63ituQBpSY29dTRPaRmt8S/rQWJSXpo7n/drZail
	 v4JZ1Bf1ZAB5xHGJ53C4bBVOtmOlYozgqo398o3lB0XLJkRV1PHUPR/Nr9fdasb0kENW1
	 z0qzdXEFGwRTpqwChVg5X8fam4x/kieg7MtznC2/l9Q/t5IqIeRlr3hRr01t9Cf31kHqq
	 z0AoXLqVIcSGccr/v9CERlgN4hpp4rZAdSzhTtbiu2joE61/8XT3mN9DM3iinqIwghQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711683;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=o1gbyJWrq7gNMYi3d97cDgWKmm9v1VUHIwBQSaU0vFg=;
	b=ojJV6Ym/u2e4WqgeLdYHHH3HymmE9Y6ysCeGWndwTUjTs+kuiIuyyM9zvTYjNUzGLt7h
	 CnlsNjdibSc23zGwrF50dtqHvI/S9bVHqDVXIKtSUtRzzVdaj78mrX7lDXsOnB01C8KW4
	 Lh2dzn8zJYvtQlZv4vS6W2BXfNjdBX2PUbsvI3Dry+HX8+lQDcCii9lzOK4E1ooHYXayZ
	 dvVAj3yYvLWDta9hboFabCoOX/YrDfLoRXPRsX2gWe5WsX8o04fT5uzzsK/PUJBk+B5Aw
	 QIY0X5zve014kevmy9JmXFjNsm4jSxa9Zn2G5WUnZeE1tSqYT4KvrO7xL05q/byZ/cA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2D0791F0118D;
	Thu, 22 Oct 2026 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711683;
	bh=o1gbyJWrq7gNMYi3d97cDgWKmm9v1VUHIwBQSaU0vFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OUMYWHe8UnjROSfgKl348zSMR/d9YabpRnkRf6sJ0plRyyLN1wL069ESKgJO7An0h
	 nygWWHdTUG+pV+WAgPjnEEZvGTZht5udWIbOMFoA6TQBJqoTVbx0CwMvvgXrft9SG2
	 G3BYFVsyEWlXgjR+Qr0KzDMjk5mZzGA1RrOo6B3E1ezQAkze+701Qm08TDnLoN7pPM
	 LMWIjYAoZ0UjawSW9HUXYL1RHTyypvDfwuZK1lN9lWVrFCNfM/vTnJQtx235ADOmJK
	 K9p1vgdKdyras8RwjJD6fr1pYxc76UecYp8crXIpvsao192lVC+96k0pBiXo4IWNEd
	 9rOgS4TrdcB4Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D926F42077;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:45 -0700
Subject: [PATCH RFC v2 13/50] KVM: selftests: Test guest_memfd with tmpfs
 resource pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-13-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2627;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YbcH78A2PggvmgIHyLc+FvDnM+c8ZNEhltr6vRYx48I=;
 b=3tHe0p96whxRdNNyX/r+KpHPSvLRTqYyqnIWCP8R+a0C5FAForRtXgxX3rTpW+B9mcxCieVzj
 d7PIu77lFIPDjzb3OfhoEdtqC1oPeBW3BEXI9o3cm6P/lHqLHMwabS9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FCD8180002
X-Stat-Signature: c4tcwukco7mihzkexfwdq886c3wbwedd
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711684-80623
X-HE-Meta: U2FsdGVkX1+GLDId9pwK5UhbvFHPsBKCkYkWkW+ckIot2lZmJtoGMTQ2TyNSX91YI8eNfvDhH7emb2tQJMzqLAqMI630OqaE7SAMyKAuoOwfNrIa3uZDWQ76klPjeZuLt1C5AqWBrdS129uLJS/A6WrMcgqS/Xo9ccfu1xpcOKAyMTQrQZc4YSwUnNUQmy93iwom0+LNFxp1uGw1Zk4XxpZ5ZtJSym9AzU5Z9U9fO2bRhVDuW4SLGFXXYP/e76ZL91wBh+KMF8avnF4M2MPWMyVUvjfMSzRSti+FcemyXedg9KFbn6FXWaaKgPoYpbNT5pMQENclfcx2x/kDJrmsqHvCD/lmKvJlGSovX0G/lUc0LpZSPE3eSkvk0GmIjDHPX5BsvjP3su+wfkDtsjnCNjhLicqejZVoEhXxvOikFcA9lZuRChCJLZvMmE543D9ChwTLPrXB6dtwR3b9DRcVl3TrsqB7Eaj5U9xC1x8vJQFaH9EIdnbxBntMPpgZBBbZAUv4AF9Fh2z9u1AI5TggtJ7XVpyeiWkmM/RFC7ZC3Yh0JYdKR9LTnghZwrUEqcnTDVcY3r2kCXLEq087znkRueu1hIU6idvGq4MOtjDxTxKgzrUXg/XnPFQx1snCLudvmcrtwSUehOquSij3o1gNIz4ljyysjVjFs66ghLkkjUJ41TvKlamDFJV1O5bc1cz9JZqPNUGDhE19xOJRSc7oVbyxcHIHQ18aqs7KBWI7BEZ23yb2/YXZoMM5fU9CJMkoZWGKCOO2qu9mEoDHpjw96QVv5t5h9dFpgtknr/h1yuwp/3qxYuk061+3pEhuSS6cPJu5choLW0kUzjTnKNBfLaL5lGBTF+mOICZ0VXdzFQLMIuEmaEtxCjx4M4Ot66QciDphvIpCmWX/7VUVgC+pToqH0FNFqC3DuWvKus/HDnQz+QqX0SoMTujYLgXqyQieCOqLwwNJjmKWbJ3XH6f
 z9Gsdw5s
 hkvDhArf2C+gRbhmNVfMhdh2Rmrn84CuPYzVQVpDTsLemk2+TnSEnXyFQTJsfrJcsWYltujSzEt+ZDRbgejs9ExmMaZEUwcIBbDVwSXv4zMIbQqLBlDu9DXROJEymOtsHhKgrJWmZZf7TzqkbBu6NmpWZQqzQsM4NDKjHzLedGM1wyfv3TbMGSRYsk339Fu9NFDE8I+jcXnFk2MShHdClj/Dl1/03qsqOf7syIcpuCPkCSzlJIyhDJX1Lrdlzfboaecl4JL+1Tc3cy/VXFGcYbLhTaz9eGqLi0e3rawPedaq5LTp2/ha6y933fIuIG9jYxTZHzrQUxAViO7+c+rPPoOBIG1X90rCfLj+nmdWMK6dtqejWm8oQkbs1EPASCrhxjON/6GNvd9Ne1HaflbqxLUj5VrcJxsMM42rZR24OypHrNxAwXIwhacFbvqYUi4eO3ySCXyHQ0/d1uk8b0KqiqJlXLGNUWBxiYFsZWaO3m4ZalAwMeMpPn+ZCm+rxe3jYWcsry0ayoNQWmPI4mqebWC71YzNjbWvA4/zYwMSSzhD3cHdeq6ziIjzUsBexmrHi7YO2VxjSA4z29w9tI66EV318nSlyuSPP3YnE96V+rqNH9No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that creating a guest_memfd backed by a
tmpfs resource pool directory succeeds across all guest_memfd subtests
and flag combinations, and reports the requested file size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 35 ++++++++++++++++++++------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index bef1acead4a6d..2250c3e9a583f 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -562,12 +562,23 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
-#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
-do {									\
-	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
-									\
-	test_##__test(args);						\
-	close(fd);							\
+#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
+do {										\
+	int pool_fd = -1;							\
+	int fd;									\
+										\
+	if ((__flags) & GUEST_MEMFD_FLAG_USE_RESOURCE) {			\
+		pool_fd = create_tmpfs_pool_fd("never", true, __gmem_size);	\
+		fd = vm_create_guest_memfd_resource(__vm, __gmem_size,		\
+						    __flags, pool_fd);		\
+	} else {								\
+		fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
+	}									\
+										\
+	test_##__test(args);							\
+	close(fd);								\
+	if (pool_fd >= 0)							\
+		close(pool_fd);							\
 } while (0)
 
 #define __gmem_test(__test, __vm, __flags, __gmem_size)			\
@@ -647,15 +658,23 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_regular_file(vm);
 
 	__test_guest_memfd(vm, 0);
+	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
-	if (flags & GUEST_MEMFD_FLAG_MMAP)
+	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	/* MMAP should always be supported if INIT_SHARED is supported. */
-	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_INIT_SHARED |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	kvm_vm_free(vm);
 }

-- 
2.56.0.257.gf7497c7d27-goog



