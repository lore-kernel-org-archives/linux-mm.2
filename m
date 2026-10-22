Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D80606C091
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnCPp/Lp
Received: by kanga.kvack.org (Postfix)
	id D69016B0A3A; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35976B0A39; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE586B0A3D; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722736B0A39
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F130B8030D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:09 +0000 (UTC)
X-FDA: 85351852698.14.FC3A8E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8DB240009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DnCPp/Lp";
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711687;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dci0wPclmxm+8+OGw2aN8X5e+pciXrqU2NJ1o9J+5Bg=;
	b=iiIbv0NIfl7Xr12k9fJ+OxlwfuycY7HKywOd+zUqZawUKwb9ofOCCERIWwiupXUEPyJPq/
	fPbsimAfIgRfiiIeTr+AxsVVEvU/QzmzydAESbod2OuPmV/W3ZeF2pvQQqhiAgvJHHIL9w
	bE9kxmhujk6vLInK4hSgwIl/s9SJROg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711687;
	b=UeUfbzHzh+9zhoUIh3YriIHxiQLtY2hLorNnVs8TRtukOPs0e3Robs5LLXsScq4zRyWw24
	HHkR6SOguLITDxp+a15vLOaIwTBfcYxdPKltJ4/eX5TBBGDFJ3g19KDOREqVglTIueAWu4
	lCt2JVasZ7V5K+EEXm2L0rJL3RKfK9A=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DnCPp/Lp";
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E7A960D96;
	Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711687;
	b=mfDAuFQt3zv5J0A8d4jLdfaYuNKF6IzegtJeeodeFjQidu18TDnT5OiMu0fFDx7+NQqi
	 94tDSo73tu7BwwlnWa+BkCrKQRIgerEEiu8Mw0LgIfdBFY/V+VVnXQcCZC77I3LiqraQS
	 87rKtfGWI+N/dOnuq7TyMPBYogPB6EY6i/9qAEX/fk5CFnzrhxjnj4F3hbQMtQ7kuNq91
	 aT97k9iBW8/8V2QC/WdFfJtm0c2mXGrChtdyx1EzzWioEqZe+GB8rgdZxn4wfHm81YZFE
	 /ToDrtFmh5SGgvZjTc9rZ3ZSrWrH2qTLxoWsN29ZTNSz2y0u6ZWXPbfANYJfA15CY0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711687;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Dci0wPclmxm+8+OGw2aN8X5e+pciXrqU2NJ1o9J+5Bg=;
	b=3Co2GXaBKV9JKBgEkGBC47VBYE2X781tEfJFod4jRjPRx9EUUvjRN8NjDIGutXTBiOZr
	 dHrIlwAf+yTed0J04rOHCAMhmpXIkhWDF3S2emLcf6il93DjD8WeofIel+WL270qZFyve
	 ZfJ7DBayaPrsJ2FHxawWMDb3AMxGKukIFtMxs2jhbTcYfMVYpISrEgQv94RJaaNeiPZIJ
	 QkBb41bcFoRiBnDcxHA+qG3BQ5xmisF/WlXuPLdocgpjNtmqNrBDbxJEFPWU9opOnsNDj
	 +jVs4HLFbB4qXX3mOmrVi79OYQxo6Qom8Wba9qHu+HK4sKFE2f6IUhax5lstbezgoGw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 80B611F0118A;
	Thu, 22 Oct 2026 23:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711687;
	bh=Dci0wPclmxm+8+OGw2aN8X5e+pciXrqU2NJ1o9J+5Bg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DnCPp/Lp9fDPomkFyrREFTjds8qN+11rsEjRq/Vm5vx4g+aBL0nXXa1JMeT6xcQem
	 1Li2BaMzzGbU4yGHak8jBGUHYyHWTnsehyIn8y/T4BOhNwXafdin7YQF+P2cvddt94
	 j1MQiSrXnxvlBW2vVBHkoCE/AF7E9emNoxJnYhQEXQ3CFb24kMouQG7Gap7gd1w2i9
	 bRivDTbgC0PVU9GqK06CzLF1Q5H+cgupiZaRLbSPkfnyfQFD0vO1g9hLkLlZi/y7JN
	 8x3zd7r5R0nh4oWynAy9hdtQxUITJiANS4+lbr3VKI1AGdPzjvvDj7BFBrMV5sjWZy
	 Dsnoq8no8v14A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C200E4206F;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:43 -0700
Subject: [PATCH RFC v2 11/50] KVM: selftests: Test rejection of hugepage
 tmpfs mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-11-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1589;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JA1MihG8a76panBsgJH2/DfbsHkeEvZvWVfKdTgL9JI=;
 b=iJ5fp192jMyuWSk2nXWZee1YbU3q0R9er4XqE5mpTv5Y9PAj2Rg8h15b6HVxsHLXaWToEXRrT
 ReSqtF41diUDWMytwKAFYk4UoXmkEoKJ95mQfSclCG3Z8bGt3kpFmNj
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8DB240009
X-Stat-Signature: oiwqs5hdy7gg8dh14ajcwqmbigdkhjer
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711687-223453
X-HE-Meta: U2FsdGVkX18ITVuBi7kzw/PFGCu1dOGYOJF15G4fvqFi5C9N4e/8EiFGaH4xfkWflv5g0T2i0zcx7ctY68xmFjNdFq6ATfI/xT4KN5oVeKbvdOcAnE8I+J7Dp1B8xwnGJyum/mwT459xkG8GzVaVX6Pjkt9Hl1mTn9N+vbZzhb0tNKWbW8viv1groQxEH0AWDOFtWy1Cyu2/Ue6CDtrD1HesA1Zj7WmeCdygCjqYuGZhCnSAOeCE+SJ6Urg8ueN+ZeMZ1QcWY0EkdegEaen5S4SgfKyGzzUXrXvtZfC3SpENmZqLZPtHVsvCmk9cUqpRk3/9YN0/HND8XitCRfxDvsNYsOH7QQhd0AeACfhZs57yAC8IQ7SMuxj950YNRkD+HOKmAbpTAmuAOcHXGJ2qvdn6WJkvunjg8vS4FQjT7xtv8rkFuze0lWLH69DQQ0kDIg7bTo7O/QyPOLN5yM4307LYJPjv/30QRrNKPvbcAZbWo0wbDcmz5D1kJb+xeb5wHgqHi5+guOW9E3qi9WMBkMH9nSMoUksQyPwOMYZXUX2QDVuj6HCUcFgAne+6rk/FcfIkdqFY3VwPcArOYbtKPpkBoTdh7v7fjmufZixniFiIXkcxhHcsk6Pf5sqXNFYuXYw8e29085/qEghbtvXTVSBww7EwZv4gPi8sIIo/cFh50+jSuP9LPtKsQQ+3R/a22ZiqNtFP2pQeEOBfxjUe0B6Y2fBkhoUr2J2UM4AmNeQS3eJH/6HfB6KCdChStAX/861tEFrHSYPU16sNSEznAD0rkzdoeMDqrWeE2B/s153VnwAFiLRWekCsxGwbgC+7JcqKAE1RVcQdA9xTdsy/avHjNppVtfg8aKKwmrRR38IoPLMuzFmQYJZrjW301YS36yvmZSLMQe+TBMxyAG0z0LQeQIb9PYDSgpScGs7toZAe/nM+R82j3bHe6OJMmtsXGKi39D3R5VShIQnbPxO
 PbFDkbxJ
 bSgD9Ov4xUd33yeA1wGDPVfCNnuvaUwQ4FxmMpMaUlmtEyIcoEPzQVWYdJDGrRkCTM/VF99YTxEpBHrZhRF+ItsWZAZ288GMOUcjp+ZAoCjkXar6Wds0DXZ0NJ9A0YOfyoLvHPgaAhDecHvnd8fUOXV3DxLxOQ/srincqGjoCziV7n01q/gdYz9wTZug/wQFWLptmusVbQyHgScTHcC+EMb8xe+W79v70e+0kj4O+G2NWkAJDqStL9+e53+jpFclEDT7beay/mB2dawpCtjuJS6tcDYlnIz3fM4SkJ6ST1ojTJoSHkgObDxLcgB1ccp5ALmUdoZ/YTIzBPPsvYhz0GaLX5/ispdlkMlZWyLlrlRUqjo0f+X4c9BDS3ojhrLPMO9ff27sUOHSBxmAchYmB3ujiQYq+M6hPxWeaRREeEZA0xeJPWwr9utmWGNPUnL9KEISkMjqjK/RbK5tJDrFfspBKs39OUm3vWaznGaBdDPFfCikUkGN/9qO9Pu86WGNGjWWPFJ04XvVQOa2ZfevqmOSWarrUj9NFWnXbQpI77gvQF0NmsOzxG1TjrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Ensure that guest_memfd creation fails with -EINVAL when passed a tmpfs
resource pool mount descriptor that has huge pages enabled, as required
by the tmpfs guest_memfd provider implementation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 205f822e10c6c..541d8cdd0bbf7 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -547,6 +547,21 @@ static void test_resource_fd_tmpfs_swap(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
+{
+	int pool_fd, fd;
+
+	pool_fd = create_tmpfs_pool_fd("always", true, page_size);
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      pool_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with huge-enabled tmpfs should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -609,6 +624,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_memfd(vm);
 	test_resource_fd_tmpfs_swap(vm);
+	test_resource_fd_tmpfs_huge(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.257.gf7497c7d27-goog



