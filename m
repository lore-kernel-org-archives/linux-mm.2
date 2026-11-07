Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE1F606A801
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcnwaiGM
Received: by kanga.kvack.org (Postfix)
	id 2A4D16B05DD; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2076E6B05DF; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5856B05E0; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0A476B05DD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91FDBA01DB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
X-FDA: 85406458788.14.2926B7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 951711C0002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcnwaiGM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011832;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGWsnYqelckA5odB4+LLJtGn5PbqWBoisDGGZYMx9/Y=;
	b=l7ODUT/6yvSuMiN4AK/nwnvTcxj+qEtND2L9WZeSZwfx4kQVZ7E6P7ZNbBMmE8v7pQNnlA
	aoobhFhXhCU64D37L2pqK1KKWQkHwkrdchsK6VtRt2aZhs/DyOEEfDPBswv1C7199lOObB
	cJQytdcYzNqGwwkM3I+rpO/2v5sJBkk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcnwaiGM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011832;
	b=sARkO0cdHh64xT5BJBNExFExc5MGa8T9kaAIjLZqRR2ZK81JkTYjAvt0BdHyFMUFmw64vr
	tO0kc9Ps1ml99qwm5fvtLRWhZE5EERa7Vln8s4QOvOgQc1gCH0zSpG83aO5wogMYRkhRpW
	z4bOQfSi9VTBYytoPhJPmZyhjhDM9Ew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D16660E14;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011831;
	b=qOn1fNGq0704KiLx3lCYlu5n/Yc9/q5wUancDecwc3Avhd+aHxdnc2dIRgtWVvsXAF1b
	 auDouWwlaDEvZuJpYzJzTN8IOpslG741XfIHvXWHWXFNEXjhw0NEUBX5XI0eAkWXXTV8t
	 0aB2CK2KBWourXkrWnex7C2mhmEU6LDnTRaV63EPchbcCHOvHC8EX/mB0Gdw6PPlFvUMo
	 NEFmexgPNLgbTEs17pZrFdKBFJbAfrWzj6+Jeln4npTUBMy+8URMEKzwRCMH6dFtDugvw
	 8/7m/Av6S9MEN59queZCRNnvEaSmPf4LCY42O4NwjdMjf38WFOjvEPXdlgYW8ucFHoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011831;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FGWsnYqelckA5odB4+LLJtGn5PbqWBoisDGGZYMx9/Y=;
	b=Q8azgJ0e2dCNjg4tfBx5pbJaLLkcH6WbmS1/idrWRji5HqR4pP0j42aH0nwPtw8RLYBD
	 I8oAWrlKAko+s12+52UZ4GsUpZE1PemOJhfiYTnWaL6sNReS0+0RtJL3M+8svTRPaTg9F
	 kBV2A1RitgN+yR/PggykGi0TRvIPnjfM1Ip6owe4YCzw1TUn0JboVFzbKwD1mwpxrOw9q
	 CzeVAi7JzgGhpD5fZUjvp6KKiS2OZOf095rTwWKYbbi8PHhY2UfAg2eRrzXiohzE1c+qb
	 g/z5/FgWdtb8IZlZ1solbNXZdM71GfPwPP9jvSm0Yc4yKx1vFD6ph8MNuwgC0H1Xarw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1E8CC1F00A06;
	Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011831;
	bh=FGWsnYqelckA5odB4+LLJtGn5PbqWBoisDGGZYMx9/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RcnwaiGMECQc6kht4jjL8l7gHWTkWfvyZu173dA2iVXSLhOfwYdO0JuvLSOxCBJpX
	 a/DjDP+q+aiwFC5LjjXMQ8JbGK+o/ydPU5xAa3+pt/SWFiTP2xkXGMusqtefHXE/pa
	 GUni9bTV0TVIGHCBbHI5n4ZLbOUSUkG/UYYYzmltow0boIEQmh8S7xriyAYbIQzJsK
	 FDt/4y72TEreFc7DKrOYR/PK8Rt4BbfInZwmQNy8TXBkYbciJlLNZ1uJmIWGWQpmhb
	 MBcM2p5CuyzH64nMGS7+RHNJgd7+qxFyfPzXv6OyWHycYK4tLX3Ci4sTFsd8NkJ8Ow
	 Wf0VZha9ElCFg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7698D479DD;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:26 -0800
Subject: [PATCH RFC v3 52/88] KVM: guest_memfd: Support mmap provider
 operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-52-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3134;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=S8Nn9NlzC19FEsDW/4vv5XCK3el09MMI9122tikd9N0=;
 b=qFWCP9ocy+CJAo1wAx8I62v4m4/bwjbD4jcoXy8lKZE5NFzAeR2EgcdTl2MSl1EOSgIt9Z528
 Mu3iaaYc/xFBJic9zQXSjuIt0XgQbALEABnfwb9x54IpphtX+CXdJLk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 951711C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cia1sux31iaeyjf8ewmsn86hsi3man66
X-HE-Tag: 1794011832-145373
X-HE-Meta: U2FsdGVkX1/FnTWkmGy4kzInWko3X2lPy8rjebpL+e0XgVwoCNUc67uq4ojPH8lPYKoNJmrJ/VmceMTs58mSgwG4BCaJ0BPyaG6OaXC3TdLXkJRXWbVJ9APSx7GECu6HYvdxBuHpRHDJhFe06a6oaARWdNDZ18GfOYooVxUIDcTn0FzfKFQBy/ZGyvNj0k9HSqGIQCuCBiNElCxvmbjGyl9aurYSp7uLyzyq5aglXfkwIvHGtKj3UQxPxK0AGxcitgIKNrjP6Bgj1Blth37TXwEYJ7Z+y1yWP18dc13i0R8UYz5XlsTytIcce3r5/jlcqQAkz4fonxX5rLy4WK+VE81fHuYPKsHzXxmm4WivVxFFcZcuu91rzSTZtJy58g+qSK+HRaMc/So6/864BOa36KGeB1kI0yQZp5OP1sGA+T2+DPMdxCThjyTuhDXB4DQaZAHl2C98HRr3XqxTSUl/Tu5Hf/9uGjoDrkV5r436xcSPUYpoScSYsKvb7KYPiN2saeRI29iXND14BIaQVn860AiBIKnRtjjwMM6IZfz87oHh226m42e3yIWqgcOp5qei8uQUAifMR7chCGzeXHFb8q1stmcdU2uV/ufQIwAlYc9Sx7aXsijCdiDlvoK1bhon2efSocLiO0gxpCikjHDKb3X8dRVGpaN70CxYDP5rejYiGvZ3hE3bgifhnpvrvzLDjIwC4gAupWFcj0f5jKzcZmtaTS+omB7rMEOHqxQ7vRBNv2VGtNZQ0aUxkDRvydMggwewal4k4FJVmuF//tsPYyOY5DomzSrzFxowbuCoutvdjZ25T2CbRjFDP0cuGTZ2WHSd6mKPhUk8l+XxRjkmpfmLgQrOAIXhUNhigJOWV1OaBxaIa5MVTqaKQdeFs9zjlVTRHfWM+UMQdmehxXrKm7/kGcU/oD0aMg2z2wNAn4+ITKmEboSaYBIppIB3ADtH9bUvbS6YuKi2Bhfuz+D
 DNYmyk+f
 wFBtKJVYW5sZVXSoL/QwSPjMEaMsUKoJ8giL1dledbEoZqrQlXkXPpBit7z5GkebN0ziVCjsMFwKjkb/xCE4LFfBnGUVYilhOSHoVsN8RypaMiDGQqlTI9gxm3YCdmbWk7R9nj97oEogf/I2uzUK8mvEWzkrZeg0zohmIniw1Tn9Fa4N6v2Croa/SxjGfRgx3Ss6n18edAIsA6Kzv1kNOeML19jA/8osrGTALoIo5mY6ND+/pvdrwDeC6MR3Z7y4BrRQOPey7u+EZKVQ+7RlBdXqR0nZKtynHcP4CxUS0orszFTYtdp+mCgUQdet+j46dTcXykN4M7MmGok6qJA/Thiyf6cFd790iRrhc/7zblpju2Z6Y8AI5seOz8agBmMzit7/4jWlFuOu4QwarXtqcka153z0jUVaEd2DVTGdrkBIeeo/kzV2hxPo/zbmE43t0bY+KKEe8IZGzY/GrleupH+EWZ8FVwGFdOrjDJh6L/z9wuLAGeO7vA5KKq9qTfy7wyK7T61a6ZEh3Tb/66SF3FlaFRY+kC2IP+07lU5x/eXNQy3QRc3brk/y+4Z8qCBVWm1GOg6OGUkS4fWaDLvP1Y3LKjN6U57+uU/sDSxQAzM6gtKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Allow memory providers to customize VMA setup when userspace creates a
shared mapping on a guest_memfd file.

Add an optional .mmap callback to struct guest_memfd_provider_operations
and invoke it via gmem_provider_mmap() during mmap handling on
guest_memfd descriptors. If the provider does not define .mmap,
gmem_provider_mmap() simply returns 0.

Invoke the provider callback before setting VM_PFNMAP and guest_memfd
VMA operations so that PFN mode mappings always have VM_PFNMAP set and
remain mediated by guest_memfd fault handling even if the provider omits
the callback or configures its own VMA flags and operations.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h |  4 ++++
 virt/kvm/guest_memfd.c      | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 8cdc334d1c9aa..a2af279cd3c34 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -85,6 +85,9 @@ static inline bool kvm_gmem_pfn_is_cacheable(u64 pfn_attrs)
  *                 available, the provider should skip the unbacked range. Not
  *                 called on kvm_gmem_revoke(). Do not take locks held across
  *                 kvm_gmem_revoke().
+ * @mmap: Optional callback to set up user mappings. Called when userspace calls
+ *        mmap() on guest_memfd. The provider can customize VMA flags, or reject
+ *        the mapping.
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -99,6 +102,7 @@ struct guest_memfd_provider_operations {
 	int (*lookup_pfn_range)(void *provider, pgoff_t index,
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
+	int (*mmap)(void *provider, struct vm_area_struct *vma);
 };
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1fbb719f0e31f..ec908419e5faa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -202,6 +202,14 @@ static void gmem_provider_release(struct gmem_inode *gi)
 		gi->provider_ops->release(gi->provider);
 }
 
+static int gmem_provider_mmap(struct gmem_inode *gi, struct vm_area_struct *vma)
+{
+	if (gi->provider_ops && gi->provider_ops->mmap)
+		return gi->provider_ops->mmap(gi->provider, vma);
+
+	return 0;
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -860,6 +868,7 @@ static const struct vm_operations_struct kvm_gmem_pfn_vm_ops = {
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	int ret;
 
 	if (!kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
@@ -869,6 +878,10 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	ret = gmem_provider_mmap(gi, vma);
+	if (ret)
+		return ret;
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		vm_flags_set(vma, VM_PFNMAP);
 

-- 
2.56.0.455.g6c5a503b38-goog



