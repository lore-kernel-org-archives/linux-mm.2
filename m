Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00500606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvXP/Y4d
Received: by kanga.kvack.org (Postfix)
	id 76CAC6B0319; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B1D6B0316; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4046B0318; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 287476B030C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B51BD1C3021
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:33 +0000 (UTC)
X-FDA: 85351853706.16.5B7BB78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 995D140005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nvXP/Y4d";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1HMOdAz18qbwg0tO2I6fGqzkhhCb5kp+U/hSIdt2eQ=;
	b=bjluLxqgScQZaO5UXUp9Zx7nm1Zg6WYDeLX81apbd6N6dRgdSLRLsuWdqC/US65b9uvNzz
	NDVFO5YKy3H0OJ8R+1Dia6e5zpJl/OYhQAArNNph6V0kYX3BvG3qyHI+Cy7p0fF4ymUnHR
	VRv9pWIlGM7qor8POgPGX0Hb0llmpgg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711711;
	b=UMylfTYGTH54H/+NBteiT8khdcdqEh+1geSPLkiA6lMK7haOGKAsf88VaU+80ZefEMdHww
	zJDdrByQZDuAme7DaI39QvLFL1rVIX0z9HnX4ti3BXPs1tMB743Ean/amAOdkc7Sdy67+W
	XpV+f7xJAn/96aguirsj/vVhVDtZBIU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nvXP/Y4d";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40DF4447DC;
	Thu, 22 Oct 2026 23:28:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711704;
	b=CUWMTpXbQWXfgSGK9uCGoAHC7QFgutri0ofH8CE+kcQlKY4SPVczlh6aQQS9cPOaoWh/
	 461K6A0NxKIU8R4qQDskIedqbbCuDSRPQYsl1Wdd+XkafKzBGeoQx2Iw1+TmfcvStl7nM
	 7DIT8EPl6l7jNMKrD6ZGYGfKXA2NApexExiBJEHqc1mzkh3thvzxpVPcYYGKTBWm6me4Q
	 7Oda6+MGP2VXR8ZUkj0G1D/rUHaautS8WxJ0MMOp8FqLUgGyPoYHwJCuDxcDuOTAHBORT
	 3qrHpWfyy7/RQIkcJSUlf/w9lgHrCXRIGoJSqFUDZqaxI+UMZ2srKdLbSIlwFk2Fczw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711704;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=E1HMOdAz18qbwg0tO2I6fGqzkhhCb5kp+U/hSIdt2eQ=;
	b=evlqCetvyoB0nUvRG8M6eekda86/p2yBpvxQAuowQ5F2RqoAZfnChqUJyz2c3uiJ+oO2
	 rsWPYY/iHZgd2JQjSi+rylVrOqlzB6BnZH592CeZfNwjHVZRckxZ4S3UFrW9raK/OAK+5
	 sb+KJbB8uAnq9C9Jif1wYbR535Ak5nt9M8Ti1+8ty6zAaX2eKMa/cK/W7/hrXEkhjdVZF
	 35Uq/0Lyrc4OXsMeL5+9UlUv08bS9qIGWaiDOEAldCn1GK+CQFgVykbU25JjA+bi5uqXv
	 zk9/i+OM9FRGMmrgc4d7eq6kPV+dNgvSlsb0ux9tMja/unk43KTSd52DH9SwOj2/7wg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5AAF41F0119C;
	Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711704;
	bh=E1HMOdAz18qbwg0tO2I6fGqzkhhCb5kp+U/hSIdt2eQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nvXP/Y4duJF29GFYue+2KfSeDcgiezjcdftz5kBaUo2hN+eTNdangssnJp1Vioa/R
	 PmUvwho+9B3bc9h/TNn4YyRyERSz6y7Hro48BO1uZEnRSmGzmSlDhMfFE8wNRCPM6T
	 bO3eDqIwSsbifi6mUc1hxG9WE6X2LR23Nsa0R7H2jWdMWZtjHiaQcdhSYtaLo02Zmc
	 4gdJfAI1aILfH97WyyturYrRkpvJGZE1Y+iv2m8CfUxMZGtpBXvz8dhPVq0uACGIzE
	 xNQ5vLNhcXQP0f0EIhZuxiMPQnfp3A62uBmI9PbwAhc6Q23aoI/rDmciC0SCQr8en/
	 3bQSWJBl7xJUg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8F03142103;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:20 -0700
Subject: [PATCH RFC v2 48/50] samples/kvm: Support dynamic revocation via
 kvm_gmem_revoke
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-48-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=5235;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=osG+hTJkYFtiaTaA4QiAK1hu1UKqffxl7X7AaR/yTpk=;
 b=5mulF18xLe3alMuXjuYUoO2Dhxkx/Mzu3GEllOvbqE9jcwoVUn/Av90F9pyXp//3tVQ3oQysW
 Ncd5XybpfQfDgc3OQPRGAC/8Z879TUN3cCr/VVT0cyw05F9ete937EE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 995D140005
X-Stat-Signature: bdjbwkgg4dms1xs5cxch87pfprn6j6iz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711711-364730
X-HE-Meta: U2FsdGVkX19OcyNDobqakJZg6XzTbujFvAY3jlvKh15ZvSWMdBO/SAjE1Tn+5IMGMlB4iJJ1MZ2i6FGf0A9FaUJ5QswRzM8B9qtRueCxPM0p8xkmsBNqMjkvYzaOL6AU7tBnlGBm5VfejNnKPqnl68RUhFPY1SeI6KJDNR4iJXbzEuaAxfM8QNWbW5aL6znO5jIhqwv04Wj+9kypvmesAlV3UbwOL81R51LdQA4ApVa5Q57nB9i4lgNis1PIF/ru8q+kdNe2SCQ7VstYwyPIBj9EirqYQ+j+BP0WEhK0IFQlzp3lGRjt7tIoOzllEE73EF2adtWM7HvfIWCty7PRwBsw26LTMCheOFg/vT1WkwakOr9GWY9wBjSUJf521eTpCUDfZf0M0s0dPH5jHRs3ud97Yj/Sv1EmNZuNt5Qonq4j7Ypgf+OSMParRlYPjUdsYW/ZXWHOInflizfGvqcCDj3V1gIwL8VGfI/FSdrYBaeLsZDsio4uo/FtHLhw4/6dE9WmWLrbk3uJdrgewUjrBjMQGztl3lD6KyryuJWaeyn4U+VyZAojJYVyc+ALmuTOoOf9cE7UY4lP6hvjHyu7z1RTvhcSiYz2G5uwc7BfuI5TKKi1U8M/mqlZ3nqYUE5rxwEEyjrYpuISfxlR53+JyQr1VH4eKW/0SoDhWnlKMvloaE9Bc2yLzBamyg+C0acE146Z9UCN6kfA/fe315gkKlelYAQS3f7zstxDA6yf8vtOG3zgB/77uzAW47eATbueaimProp6sU6AEsuFbaWsRNwD5wSUVtkJtRWKYIZEUynAH57v30FcP5ZkIGNtD1ycrCDACRC6r9eg8qFZN8m4XXE3+cXXRJmxu+QHIOTt2GyxYw39KULvl19NUX34lXnzCOz2wJ+WaFuCd1QYZ8/3fZN49hTEGbTr+mPQWVl4COB5jgP2fpr5GzyFcg/qhCH/kc1SAYc/vRTGHWLxjgh
 /hhKkHNw
 q3dWjANBP5pTH1736ZmBNvuDE+zP2lW7KJX5s8Tp+iajBk2zSUTe1nutH2MpTEoNj59/tuNFNZKb7FvwkDvPKKDQHnuPynxC8j+X+PF1YSkAkAkH76KkukYY25X8FUGANGnakOX+KEGWOyaNEQ0ik5etTQvv9gqdQQOF0NBXwFOywMc/0dPSjsM+1ZefnWCwZNQ4m0moR8rdbRxuHlwyACe7dD1fype3A1Df3ZK/jz7t35UZzqoUONPoDicqUgUBVnHyNdyet8vNbiQdEMntpiahocLgPhZG5gLKsdDksyGSgjjR6Q02dC9DwhZv33AovoJ0svW4++KPbHSBkBHX+eOrxPr58BmFY3j/QyXxy6X2Wmk06PkHHiB25zJcCSo4UggDMX0ZMP2gXEQmylNSumuk6BkDZbVXY2i65m2RyGIVjwTgfMgj7GcqRomH2H0b0BVw2kQYvnFZ6DatAH8dR5kXTKBbxkOch59Uccn437KQoT/KKoKQnRfOk/Tys1EOsZLMGAY8aj/3J2NGkiuVXOFoHBPqwU90hdvrlGa4/WlGbkq4LbwfFYOy8zkbGXK3VSDuqPu6FtndEmURUSifR1/qYjdOTV03x5lysFwfe2UBCj3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Support dynamic revocation in the sample memory provider module by
calling kvm_gmem_revoke() when pages are marked absent via
MPS_SET_PRESENT.

Note down the attaching gmem inode during .attach() and disallow double
attachment to the same provider file.

Clear the revoked pages after kvm_gmem_revoke() using mps_zero_range()
to ensure that stale data is wiped and cannot be observed when pages are
later marked present or reused.

Regarding locking and ordering:
- In mps_set_present(), mark the absent bitmap first before revoking so
  any concurrent page fault immediately sees the page as absent and
  rejects the lookup with -EFAULT.
- kvm_gmem_revoke() is called under info->lock to fully serialize
  MPS_SET_PRESENT operations against each other and prevent races
  between marking pages absent and present.
- The PFN passed to kvm_gmem_revoke() is derived from info->base_pfn +
  start. The mapping between page index and physical PFN is static and
  immutable for the lifetime of the provider file, ensuring that the
  pfn mapping remains completely stable across the revoke call.
- Passing pfn directly to kvm_gmem_revoke() allows guest_memfd to
  reclaim the physical range directly without calling back into the
  provider. This keeps the lock hierarchy strictly top-down (info->lock
  -> filemap_invalidate_lock -> mmu_lock) with no callbacks or deadlocks.

For now, nothing needs to be done when setting a page present, since users
should (re-)fault and (re-)obtain the PFN via .get_pfn(), to be added in a
later patch.

For users that don't support faulting, like the IOMMU, the counterpart to
kvm_gmem_revoke() will be made available for the first user to indicate
that the memory is now available. guest_memfd should then do the page table
mappings as necessary, based on the shared/private status.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/Kconfig                   |  2 +-
 samples/kvm/mem_provider_sample.c | 42 +++++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 29a0efe49ac3a..1b227eec8bb6d 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -328,7 +328,7 @@ source "samples/damon/Kconfig"
 
 config SAMPLE_KVM_MEM_PROVIDER
 	tristate "Build sample memory provider -- loadable module only"
-	depends on CONTIG_ALLOC && X86_64 && m
+	depends on CONTIG_ALLOC && X86_64 && m && KVM_GUEST_MEMFD
 	help
 	  This builds a sample memory provider.
 	  Its files can back a guest_memfd and be mapped by iommufd.
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index dee15179959b2..3fa0d1a4335b5 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -39,13 +39,13 @@ struct mps_info {
 	struct page *cma_pages;		/* from alloc_contig_pages() */
 
 	unsigned long *absent;		/* taken away by MPS_SET_PRESENT */
+
+	struct inode *gmem_inode;
 };
 
-static void mps_gmem_put_pfn_range(void *provider, pgoff_t index,
-				   size_t nr_pages)
+static void mps_zero_range(struct mps_info *info, pgoff_t index,
+			    size_t nr_pages)
 {
-	struct file *resource_file = provider;
-	struct mps_info *info = resource_file->private_data;
 	size_t i;
 
 	if (index >= info->npages)
@@ -56,6 +56,14 @@ static void mps_gmem_put_pfn_range(void *provider, pgoff_t index,
 		clear_highpage(info->cma_pages + index + i);
 }
 
+static void mps_gmem_put_pfn_range(void *provider, pgoff_t index,
+				   size_t nr_pages)
+{
+	struct file *resource_file = provider;
+
+	mps_zero_range(resource_file->private_data, index, nr_pages);
+}
+
 /* Byte range [offset, offset + len) of @info as page indices. */
 static int mps_range(struct mps_info *info, u64 offset, u64 len,
 		     unsigned long *start, unsigned long *end)
@@ -73,10 +81,17 @@ static void mps_set_present(struct mps_info *info, unsigned long start,
 			    unsigned long end, bool present)
 {
 	mutex_lock(&info->lock);
-	if (present)
+	if (present) {
 		bitmap_clear(info->absent, start, end - start);
-	else
+	} else {
 		bitmap_set(info->absent, start, end - start);
+		if (info->gmem_inode) {
+			unsigned long pfn = info->base_pfn + start;
+
+			kvm_gmem_revoke(info->gmem_inode, start, end - start, &pfn);
+			mps_zero_range(info, start, end - start);
+		}
+	}
 	mutex_unlock(&info->lock);
 }
 
@@ -138,12 +153,27 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 static void *mps_gmem_attach(struct inode *gmem_inode,
 			     struct file *resource_file)
 {
+	struct mps_info *info = resource_file->private_data;
+
+	mutex_lock(&info->lock);
+	if (info->gmem_inode) {
+		mutex_unlock(&info->lock);
+		return ERR_PTR(-EBUSY);
+	}
+	info->gmem_inode = gmem_inode;
+	mutex_unlock(&info->lock);
+
 	return get_file(resource_file);
 }
 
 static void mps_gmem_release(void *provider)
 {
 	struct file *resource_file = provider;
+	struct mps_info *info = resource_file->private_data;
+
+	mutex_lock(&info->lock);
+	info->gmem_inode = NULL;
+	mutex_unlock(&info->lock);
 
 	fput(resource_file);
 }

-- 
2.56.0.257.gf7497c7d27-goog



