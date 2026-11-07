Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAF3606A83D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvZGsurg
Received: by kanga.kvack.org (Postfix)
	id A460C6B0601; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DB06B0602; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932D66B0604; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62A916B0601
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F9DC160261
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
X-FDA: 85406459166.12.E0AD2FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF89E100007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvZGsurg;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gaFBZx0TRAzN46wa1GnNfQ/jyTlgbskICgy7A9zF2c=;
	b=HKXTvZdJxwS45chi75XiBJ7J/HU6Qypl8mFDiQLZECUeOmHm9ccj91nyJIsFQc9PSgDDkk
	KcdzKIE+DO5ejMi7aD3Bh/W7GlwL4tiSkTk+inG9ukOB/BAD/qtmvHOeT1xp4SOZ9u4dgx
	uiHXEflR82A68tghJ19onJuF4oqFJzA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=4EX1a2Wrg50hnsCXbbHAQ54EJFQ0s6dANbpQT4nTo1XBp2RRmOLEXbfhHLRtH21lKOvibo
	/rHqpdCxwJhxrcC9f9QgCtcmpTDTIhbZntEq1iw11h/pMnJduq53wYaZ1sIQGPMsIX0EjZ
	oeitT+BIoysH18ziGtU4tcPu3qxOMOA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvZGsurg;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA7EB60E1B;
	Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011840;
	b=p2wDhW+bmNDGClGsZDW2GhvWR5YcQpJlAbxJbMTv0KWGcB7V8DPi6PVWROx9EQoe4roQ
	 /7MZongU4i+Pm6R7VEm0J8BmdsrrEzkD3KpL1KIsynx3YrvCvKH4kCSlLSNPw7v6+Ufp6
	 oWSlQJS0qnWxY0vIL+C3laq232xsAIfUbJ1Cy7yiVBzBOR3y9uGJmHYjZpr96PSwGHgZZ
	 3/uBdxM1bSP10uGIC1gPitwTYaDIpCCTrIl+ojYkpxreR4XgoAQNapY0ny7BASi2HdM76
	 uvo7rZbKoKV2D0g6fZuaFxRGlm3q210Uirv2iwzAR8IRlWLeLRCLgcCoFM/gPc2Ih5A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9gaFBZx0TRAzN46wa1GnNfQ/jyTlgbskICgy7A9zF2c=;
	b=X/OJym9ILauqtd3yBSy7ZAcGZWbSGGVkEEoShDdD55lIgK9eSvRrus9pNy936GPhTXrT
	 TbTcd53hDoGQKQQZ8lHDyo9Xo4DE4GWaCrqx7n+j3wGiUXdr17V6WQPRGErDXhioiiQQ4
	 DvZaScM68cy8O11j+7k5opphSxuo3GuMx+jIO1a1mp0IdDcz2JeghAKnr4fW3nXIuStje
	 NI/GzR/gkw05GJdBNDyu8XM3iioFs1L1Awv1PZz4CzBN0wuqNlisCpuzdg6HpAFeOi4zK
	 uVGV8VyHZBniHwnfRNRWHIUaoH0e1d88kDa/soEuRjo7FJhA/8ltkcZZvSBvjVKfVeg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E97821F008A6;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011840;
	bh=9gaFBZx0TRAzN46wa1GnNfQ/jyTlgbskICgy7A9zF2c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CvZGsurgjb3n6a6OGrJb14Ocsm7Jwx1JIZU5OAwGlRK9NtEegSH4tdQoVjqej+70d
	 zUk8kFfCAzEDs3xyMbqLRB8pyAqjcwlQ8t6HKQmSlTNke5QGEdins3TK9Z+p5P18Wt
	 6egNslCflKKtqUPo1OCLHnypKIWouoDUTVHzhYLFjouM8+mbvC09w49QFIg/m8oBMQ
	 XyIs9lPMnbICF31RTEU0wZ95u8P7jFrFHFDAkvAsCHKMJC8lVTli/yl46cKKlwGExK
	 Onwj+IUxPD7hB+hsz/NXtUl4sXDPfOeLdizaXxbWLo3H8UCyuaGgu9702GXPhRBQW4
	 +wfodTqoyGOeg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 66C60479DA;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:25 -0800
Subject: [PATCH RFC v3 51/88] KVM: guest_memfd: Support reporting PFN
 cacheability
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-51-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=9171;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=GZTQxVn0HjxORiNdxoBtqdA/HiYkhk8lDD2n3VKRLow=;
 b=y38OKIzJH7eiYyPKqj5uQCGyOxtwZlKxg8Qd3cuZA8cWdUQ0l3YXTkA3HzQD+e1zqhN4SOCvP
 0UXrPpAV/oeBBpAYUMPjuenU/9KmhLKmarn9kYJPf1fXNZN0arx3gYl
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qkqhjneqwq5cka86y9891p3qbzyscxmz
X-Rspamd-Queue-Id: EF89E100007
X-Rspam-User: 
X-HE-Tag: 1794011840-965358
X-HE-Meta: U2FsdGVkX1/x+GSObIal8pghkOw3yqwUqVGt1Z6cDa7lb0wVfpZAfUbGXtYVnvj3S2zOtQP5v6db01WtaIS4zP81NosrKRJU6723121ZPSN1BdxHC1nU93G9ASYdMQH+XyTrXQyXAiRd4jJwk6YFdgRjA/yQc/un1/oLWQYQNFKxPzqU4Rsx97Vu5Gt761hhcpLgbLlMgR2lG5lRFNdrJKYxbRMVjbVoq/+uUxe5HACuFkSh15VYJLlZtR0tq8lJDmpKjtIJItsWXNXMoP2dsbNNSTeyqJa4tJrHQH3ohLgBiyjz24uBi9n/4TvXr9up93wOY4mAW31Q7ZE4fySJFrzpHmXjj4BYKk6P4d8XTXk2xac+ZsOXv2yBVds3wQ+jfQErYICbmxHlJrbtg+K/9auCA8/VK4FKcvpgTzV2cKpSrUwSCOC3O64wylRVWgkwnRndZP+25A1EJARDjvO1VlJX3xo5eVBEprf7BzSaqEENq2mvn4j5Y23L/OPRc9Wupm6XF0iiatVigPzCo0i50VWrYlwHIki0V8XaOAkyv+uCDftRVLyoH9+KFZPaH1OG3/rDkSM5b0cnkXZBqR5azz8I4/jUPWKaEDE+uNUkTNCjM2bNfVIFUy8Fy9swzVODeK7vk5EvdHB8dqeiiGiWgUAKYlS+ld4X0FaV2dZWjCA1VK9j+DSiKsw3zatsoloNi7lJmO4fDNq5gA8G7hs4VCSbFAYfmXDbyP1haJFAbX9hFrYil4l7Is5feMRjjrs6m7ZcXuQjEpyzJLfkQZiUNVKXIlZ6oWZXMWcmIvN2cSU7Pcf7WokofKnfrMBGHQUOvKl8dLoJw53MP++FoCadwO+zsiH39AxcUkMnPCLXfsETqn1DE/sRRRP/0S5NlhTxk01AigyaPu49heKMhRT6QaNQH5Z5huH1LXAUVcLlP14ecNLPID8/x4ipVvHv4M7nJjCHp1WN2oUIDRnJPaR
 hnDJr0Zh
 ktnVe3DA7v7bVahczpNOsPDJugznmqTdL8o60EVtC2+a9LF26YbqGIZ2Udg2BTigJWl2A6b1PfjzYTy9dWvITr/rPCYZd3bBR4yw0mpX2hA5UCUcims9L7PajmkuzVcWBBgL1Uuf677VlMQRR4yk90B2neqjmn+pLrnCyJJh8e/kVThczGeGWWpKfa3Sxf87hBw1pzBVl63tiv0rwnyXkfo9SMe37z9kw6U4gasqHqJOKFkqNcaEnQEIpZ8y8t0b/5YtdLcd8HEmCb0Gyg75yiAy1DOsVr/Hq2PebVjPPxWNK+GpZB6WBuxCOGViuP/l9YlaeeT6yQbuuQ/PdRd9yIEsCdfRBYYKchb87mJ/K/+IDbKK8edaOsWVe612vHgSRUkunL60vrVNXNfGplsCWOxKjqnOhij5FFhoGTimQXEi2LV4m5g5kW8qseqm7e0UFcQVtz6+rihdYzYcYAJmFEb0czwtHcKiTw9CUQX7NsJFdZ7j2/ufPUX3yV4qLYIFtIjUbG22RNDVVoOnLGC5HpwGaTRuOKJIYOMKi8yCJy7rMMeum27D4kFz4FqwG9zOjj97URwXAqr1lfeC0fhhr/oiATHZPHERDYnyzqyJ17GYYS0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When memory slots are backed exclusively by guest_memfd without a host
userspace VMA, KVM cannot inspect VMA flags or page protections to
determine the caching requirements of the backing physical frames. Even
when a VMA exists, external PFN providers such as device drivers may
expose multiple regions with distinct caching properties within a single
provider instance.

Extend PFN attributes with a cacheability field whose zero value
represents normal write-back cacheable memory so existing RAM providers
require no changes. Distinguish three non-cacheable modes alongside
normal cacheable memory: strict uncached MMIO where guest
write-combining could trigger uncontained host faults, uncached MMIO on
buses such as PCIe where stage-2 can safely permit guest write-combining
while host mappings remain uncached, and write-combining memory.

Handle the reported cacheability in stage-2 fault paths:

- On arm64, select Device or Normal Non-Cacheable stage-2 attributes for
  non-cacheable frames, forbid instruction fetches on non-cacheable
  mappings, verify hardware cacheability support for non-linear-mapped
  cacheable frames, and reject non-cacheable frames for nested VNCR
  mappings which require cacheable host kernel mappings.
- On x86, stage-2 PTE construction already derives MMIO status from host
  PAT and E820 tables (and couples that status with host memory
  encryption bits), so warn once with a TODO if the provider-reported
  cacheability disagrees with x86's host MMIO detection.

Preserve confidential RAM invariants by rejecting non-cacheable frames
during initial payload population, and during SEV-SNP VMSA reloading or
RMP fault handling.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/arm64/kvm/mmu.c        | 30 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/nested.c     |  5 +++++
 arch/x86/kvm/mmu/mmu.c      |  8 ++++++++
 arch/x86/kvm/mmu/spte.c     |  2 +-
 arch/x86/kvm/mmu/spte.h     |  1 +
 arch/x86/kvm/svm/sev.c      |  9 ++++++++-
 include/linux/guest_memfd.h | 29 ++++++++++++++++++++++++++++-
 virt/kvm/guest_memfd.c      |  8 ++++++--
 8 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8f0217185973c..71fc823ed2076 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1789,14 +1789,40 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 		return ret ?: -EFAULT;
 	}
 
+	if (!kvm_gmem_pfn_is_cacheable(pfn_attrs) && exec_fault) {
+		kfree(mapping);
+		return -ENOEXEC;
+	}
+
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
 		prot = adjust_nested_fault_perms(s2fd->nested, prot);
 
-	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
-		prot |= KVM_PGTABLE_PROT_X;
+	switch (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_CACHE_MASK) {
+	case GUEST_MEMFD_PFN_ATTRS_CACHE_WB:
+		if (!pfn_is_map_memory(s2vi.pfn) &&
+		    !kvm_supports_cacheable_pfnmap()) {
+			if (!result)
+				kvm_prepare_memory_fault_exit(
+					s2fd->vcpu, gfn_to_gpa(canonical_gfn),
+					s2vi.vma_pagesize, write_fault,
+					exec_fault, false);
+			kfree(mapping);
+			return -EFAULT;
+		}
+		if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+			prot |= KVM_PGTABLE_PROT_X;
+		break;
+	case GUEST_MEMFD_PFN_ATTRS_CACHE_UC:
+		prot |= KVM_PGTABLE_PROT_DEVICE;
+		break;
+	case GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC:
+	case GUEST_MEMFD_PFN_ATTRS_CACHE_WC:
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		break;
+	}
 
 	if (s2fd->nested)
 		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4519e92d89d66..a3818ece5c753 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1633,6 +1633,11 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 						      true, false, false);
 			return -EFAULT;
 		}
+
+		if (!kvm_gmem_pfn_is_cacheable(pfn_attrs)) {
+			fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
+			return -EINVAL;
+		}
 	}
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87deeeffd9919..23feb737c755b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4695,6 +4695,14 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
+
+	/*
+	 * TODO: Perhaps resolve stage-2 cacheability from pfn_attrs instead of
+	 * relying on host MMIO PFN heuristics when constructing SPTEs?
+	 */
+	WARN_ON_ONCE(__kvm_is_mmio_pfn(fault->pfn) !=
+		     !kvm_gmem_pfn_is_cacheable(pfn_attrs));
+
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 5fc27e9733b38..fd119ac2fad94 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -106,7 +106,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	return spte;
 }
 
-static bool __kvm_is_mmio_pfn(kvm_pfn_t pfn)
+bool __kvm_is_mmio_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e730717824b38..05c7bffa5d2ed 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -557,6 +557,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
+bool __kvm_is_mmio_pfn(kvm_pfn_t pfn);
 bool spte_needs_atomic_update(u64 spte);
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5e37ea4bc7937..526f2a457cfe0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4100,7 +4100,8 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL, &pfn_attrs))
 		return;
 
-	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)
+	if ((pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) ||
+	    !kvm_gmem_pfn_is_cacheable(pfn_attrs))
 		return;
 
 	read_lock(&kvm->mmu_lock);
@@ -5110,6 +5111,12 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
+	if (!kvm_gmem_pfn_is_cacheable(pfn_attrs)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-cacheable backing page for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
 	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
 	if (ret || !assigned) {
 		guard(read_lock)(&kvm->mmu_lock);
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index fb2279a001ebf..8cdc334d1c9aa 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_GUEST_MEMFD_H
 #define _LINUX_GUEST_MEMFD_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 struct file;
@@ -9,7 +10,33 @@ struct folio;
 struct inode;
 struct mempolicy;
 
-#define GUEST_MEMFD_PFN_ATTRS_READONLY	(1ULL << 0)
+#define GUEST_MEMFD_PFN_ATTRS_READONLY		(1ULL << 0)
+
+/*
+ * Cacheability attributes for physical frames returned by providers
+ * (columns show x86 / arm64 memory types):
+ *
+ * Attribute                               | Host PTE       | Stage-2 PTE
+ * ----------------------------------------+----------------+---------------
+ * GUEST_MEMFD_PFN_ATTRS_CACHE_WB          | WB / Normal    | WB / Normal
+ * GUEST_MEMFD_PFN_ATTRS_CACHE_UC          | UC / Device    | UC / Device
+ * GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC | UC / Device    | UC / Normal-NC
+ * GUEST_MEMFD_PFN_ATTRS_CACHE_WC          | WC / Normal-NC | UC / Normal-NC
+ *
+ * GUEST_MEMFD_PFN_ATTRS_CACHE_WB is 0 so normal cacheable memory is the
+ * default when no cacheability bits are set.
+ */
+#define GUEST_MEMFD_PFN_ATTRS_CACHE_MASK	GENMASK_ULL(2, 1)
+#define GUEST_MEMFD_PFN_ATTRS_CACHE_WB		(0ULL << 1)
+#define GUEST_MEMFD_PFN_ATTRS_CACHE_UC		(1ULL << 1)
+#define GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC	(2ULL << 1)
+#define GUEST_MEMFD_PFN_ATTRS_CACHE_WC		(3ULL << 1)
+
+static inline bool kvm_gmem_pfn_is_cacheable(u64 pfn_attrs)
+{
+	return (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_CACHE_MASK) ==
+	       GUEST_MEMFD_PFN_ATTRS_CACHE_WB;
+}
 
 /**
  * struct guest_memfd_provider_operations - Operations for external memory providers
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 023bf095340be..1fbb719f0e31f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1678,8 +1678,12 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (folio)
 		folio_unlock(folio);
 
-	/* Populating pages initializes private memory, which cannot be read-only. */
-	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) {
+	/*
+	 * Populating pages initializes private memory, which cannot be
+	 * read-only or non-cacheable.
+	 */
+	if ((pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) ||
+	    !kvm_gmem_pfn_is_cacheable(pfn_attrs)) {
 		ret = -EPERM;
 		goto out_put_folio;
 	}

-- 
2.56.0.455.g6c5a503b38-goog



