Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D02606A74B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3N3derj
Received: by kanga.kvack.org (Postfix)
	id AA0FF6B0A3D; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A012F6B0A40; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740BB6B0A3E; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 417DA6B0A3D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD180C0327
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:10 +0000 (UTC)
X-FDA: 85351852740.06.BFD3C19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82ED31C0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3N3derj;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711688;
	b=omRtF3JE0ICjx8HTTLvs1qm5lYemyqyBBqUHVDrQiOq16m2b6kmE5OS3sxQ3wPgQdkA9FN
	NgwSg648o5NMRbCV1BJ8KI008tEa6TkqEKcyQnkG/s/9iC3uYeC2TlqXKuZgrsEqtV8DZe
	NnFveNYCTcin6q7OlTEAMJ7vYjBWOLI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3N3derj;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YM2ZQ+69NUn4Y+pi9b2aNU37FK5sd+xrIN+PQMthuXw=;
	b=DeaPmQyDy7tY+bqXhquJV1zUstVtQSDhurwoKdT3b2O3aXw+nZPqdjXSaKo3YT65BnmzJa
	Nq4TleCQL7MD6tdg3emhFxuN258SSCXC9f7oR8N9YydH3Z0jZFpw8/7egh03CSGtj3yfq2
	GW/WuE4yHi4TTccy80tJGWZrSMHpaEU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C369044797;
	Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711687;
	b=ti14plLdLVeVx/OeXxaBUHX7U9ljv3yGhvheUqB90DBMie5wL2mjdVjXPXnQgNuKxVeZ
	 HcT+T+Vtbe8K8WQ+4qFOO2tpCnDDtBC4ID3EaYEfigddM5pstACt+NbT6Xd+VsXoPymuE
	 JksYVG4wQjKHNbOeDggnCgeTzS9hWi4Pyp56fLIZt14GZbE4SBvdQDFOqq+GVIl1TUWOe
	 rUISUPX1itS+WQOtSLTH7GBlA5Jz1KqVMiI5MjnRBKNCm9tduk9s/Ohql+2N6Nwpf+XeK
	 XU3+sCs2K2RuH6K9L4OR2TaAHLe7PDqIxQYzfnXN7qFMgY2ncABdpNfxphp5rYFSkOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711687;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YM2ZQ+69NUn4Y+pi9b2aNU37FK5sd+xrIN+PQMthuXw=;
	b=Aw6wHkomNkSX93U1QBtzvpt5xC6l+k8DHz1wmY6UAioK/eCCheJDRi7trCz1/RTdEbad
	 TdBXwBC7xqe6B3nlF4eKIDmEyJtKKWeb4vgFzDAT6fyegYhX4aXfnPJoIf6WNgXxw0LTJ
	 i7nzpqRFnvgHausvEo7xDCDiPYRQldJLYQp2DIz///xMp2NHQZojoE/i0uxrIyT4YMGP1
	 0zFy6Vpudey/XcoRVsD1qIl667bK+pi0FNRjLrVOxwTnlm82k3iyMrza/wMe5WKfq6FCC
	 o+xrCdn4y7HJFI50l/ZxpA/NmJhA0f+dlfSY8bcuiL6KR/vcKoSduuVk0FgbFSxaFzg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 64EC61F01193;
	Thu, 22 Oct 2026 23:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711687;
	bh=YM2ZQ+69NUn4Y+pi9b2aNU37FK5sd+xrIN+PQMthuXw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=e3N3derjbPHJPHCkjXaN8dqXuFVqT2RFgFr4g9ZCHaIvyx5FwJgD0xkNTmPLTZXEw
	 FNUjexHKOdpytaQHA2YFfTCqCRuvheOnb3Y3DHrRCKsyZcn6LunF08iLbQjQaRP9i9
	 XQS0XP50awT6Kbt+tHEP1qfpKpaWW79+stWKzjbOF9RpJM+WDTd6Ub3kdurtsLF5yq
	 G0BkYJfLZCsPFI5EQIGJHPpk/pKyjTp5kzuAMynsVNrUaB5A+4phyfdDUidxoWTF31
	 H2TU2PvtiP4eo/mQQxk2NfBmIwqoxHsD1SfmvU5AefPyLuYzfCy/NyPOCqLKq0Ttc5
	 gH2Dok8MJxc6g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 51EFA4209B;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:54 -0700
Subject: [PATCH RFC v2 22/50] samples/kvm: Remove readonly support from
 sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-22-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=7719;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KmuNfE164jdZmg6x8NSbkgPNCkgJMfiXBEIOVKni6Sw=;
 b=NL8RHxzlaCihqsS2rYaBHXsTcQILZKtBgbc3euu5fec8+gL9zqbjfaRemzqOwNdyAhjq8IGUg
 6gC107g7fskDQKFCsZTkog+JKUugHvc0npKmSYNKVZ/XAJMRqHoC1fo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 82ED31C0007
X-Stat-Signature: gddnoreutyodg7kskrnhqod5otkjm4ok
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711688-383980
X-HE-Meta: U2FsdGVkX19EzjASg5bi1EGL8TATTH81KM0xwbGUdh2BNQXD8XoODn85uCRAsnPWAR0E6dw0K0joCm3HubREPm86d3hVv+2kBpA6es79zjV0jHaGnwqus5VCXkaFgCWcMA7o7qeHVxzdr/Ils2GNSjoW2AMOSMG0dklMpHQfmkS5EXGJMj0Ryy2BAfIy77d8d3aoLOzs6knhDjPb8AeGWwIROC1336c+W2aSSu1dhyIABF4nDN6kN4CnUDWVDGQS2Om3L4rvwqFJ9EDzZeV4KgjnpU8bV6n6gTu3SjYIAQ76N9G/4ex9F8WQs9WlI86WuNlK/r+rFkX0CVZAwl42+bgGp+lbChzNYFOa0n5WLX3s6QQtdhZ6yJ5722Ep+VQJ3jvha68ZsVUK3tz16ctqU1th6fQ6gJPX/61TXbV55saUqbvu4p1mGopiDxZf51jf6f1kqR0c7oLiuPleaSbeMJkuUgFHBB9fPGX+fxlkxy+/d66+AUZMkNwiuRHpSgZHR3OrpmDNOxL2nztJZfPweLOANvloCDISy7w3KqlGslGUilvPSAw2v8sGDS3L2f8mRUj9i4PKqya/USfF5doHFakoWfZebCTZD37KxX7Zw+iMXyVu5GgnUNabndEjwFuhnltD/g71GJP+ZnIkoYDuBCiJIOJFeh97oiosObfxZVfZVrN9gH1L3loMY+Vkuht8Fy9o6tNCiPLgP0gygWK1VtDglGhMtzExPr0rr5gEOReZbXMaGdbH8A88ZVKPEO7sfQccyinCF5rdwrHkE83NwmDDN8yfcpFooiQIt+uwDjNz/BfSgRNSnjzeW4WrjA4QKzKA7GAPr0jaHA/VhqN+dMCtayATbT12Lj0sIrXkfKD9KtKyLVhndZ2CSu3T7cHEm7FSHrloyWiOs93ZShKu7WN/+8lWcxl0gx4aMAy/etPLoCSIIhRyCPnlkHiZzI2yDJi/q8vYdUfb3aHvkny
 /GedUUYU
 XvFW/X6KwoLJnS9TNUcOIMiJi9IXJyVaZaBMNcYZDRUoti5ZInrETNiYcAVmeJuYgVQJZ3GC8pxrsAlcFuCNWCsjkiMvFkXP4Rben3szbbE1A2mD3QbBwsbVFKSUX1yUMq5Ao+DlbqpNBQJnZA4skO1VEVXhfzHh4BgyMOV/gLeK7w4nbW6GsXD9EFxJ5zaQWwsryIP66fT+aCIuXUKLU5zGV38oKOVET51CMVGPWEg09Feg9H7Ac3WYDZT7Fyrkx9yiJ/xnf3Js8XGSO2C4G9qa18bBj9byC843l5pQbc/4y4kJunlyrY23MDGmncwBF/He8pemzkoimkTREp6HKqcV5Znh5sfZUGZ2F0qKnWrMt346zdTVV10UECwliPIDV7Z9hqMJ3r8OxY8VWMVtUR0R8ltqh/1TVVja9kW/AneKQZs79mpu+fHoCx+9b9pr2ZnjdZNgJ0r6ceIcIZNVs+dHYJRHU90QWHon2I7BiOJG3AN5i6y+UoIOupZQOHQrFmdP8h13aFBe23pbM6rcUjScPTXqn2vT54CUEItYES3mgULnIh2taQJHL+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove the MPS_CTL_SET_READONLY ioctl, MEM_PROVIDER_ATTR_READONLY
attribute, and readonly tracking bitmap from the sample memory provider.

Keeping only the present versus absent control interface focuses
attention on the essential interface design for page backing and
revocation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 52 ++++++++-------------------------------
 samples/kvm/mem_provider_sample.h | 13 ++++------
 2 files changed, 15 insertions(+), 50 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 5afc433dce6e8..37538dce40cf8 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -66,7 +66,6 @@ struct mps_info {
 	bool fixed_wb;			/* holds a ref on the fixed-region WB alias */
 
 	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
-	unsigned long *readonly;
 
 	/*
 	 * A child of the root: its first page in the root, and the pages it
@@ -146,7 +145,7 @@ static bool mps_page_present(struct mps_info *info, unsigned long index)
 
 /*
  * The length of the run from @index of pages with the same state as @index:
- * present, and the same read-only bit.
+ * present.
  */
 static unsigned long mps_run(struct mps_info *info, unsigned long index)
 {
@@ -156,12 +155,6 @@ static unsigned long mps_run(struct mps_info *info, unsigned long index)
 	if (info->owned)
 		end = min(end, find_next_zero_bit(info->owned, info->npages,
 						  index + 1));
-	if (test_bit(index, info->readonly))
-		end = min(end, find_next_zero_bit(info->readonly, info->npages,
-						  index + 1));
-	else
-		end = min(end, find_next_bit(info->readonly, info->npages,
-					     index + 1));
 	return end - index;
 }
 
@@ -211,8 +204,6 @@ static int mps_mp_get_page(struct mem_provider_file *mpf, pgoff_t index,
 	}
 
 	*pfn = info->base_pfn + index;
-	if (test_bit(index, info->readonly))
-		*attrs |= MEM_PROVIDER_ATTR_READONLY;
 	/* The creator of the file decides whether the host may map it. */
 	if (!info->mmap_capable)
 		*attrs |= MEM_PROVIDER_ATTR_NO_USER_MAP;
@@ -249,18 +240,6 @@ static int mps_range(struct mps_info *info, u64 offset, u64 len,
 	return 0;
 }
 
-static void mps_set_readonly(struct mps_info *info, unsigned long start,
-			     unsigned long end, bool readonly)
-{
-	mutex_lock(&info->lock);
-	if (readonly)
-		bitmap_set(info->readonly, start, end - start);
-	else
-		bitmap_clear(info->readonly, start, end - start);
-	mps_revoke(info, start, end);
-	mutex_unlock(&info->lock);
-}
-
 static void mps_set_present(struct mps_info *info, unsigned long start,
 			    unsigned long end, bool present)
 {
@@ -283,7 +262,6 @@ static long mps_get_stats(struct mps_info *info, void __user *uarg)
 	st.owned_pages = info->owned ?
 		bitmap_weight(info->owned, info->npages) : info->npages;
 	st.absent_pages = bitmap_weight(info->absent, info->npages);
-	st.readonly_pages = bitmap_weight(info->readonly, info->npages);
 	mutex_unlock(&info->lock);
 
 	return copy_to_user(uarg, &st, sizeof(st)) ? -EFAULT : 0;
@@ -291,8 +269,8 @@ static long mps_get_stats(struct mps_info *info, void __user *uarg)
 
 /*
  * A child fd is read-only to its holder: only GET_STATS.  The owner changes a
- * child's pages through the control device (MPS_CTL_SET_PRESENT and
- * MPS_CTL_SET_READONLY), so a VMM that holds a child cannot.
+ * child's pages through the control device (MPS_CTL_SET_PRESENT), so a VMM
+ * that holds a child cannot.
  */
 static long mps_file_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
@@ -335,7 +313,6 @@ static int mps_file_release(struct inode *inode, struct file *file)
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
 	bitmap_free(info->absent);
-	bitmap_free(info->readonly);
 	kfree(info);
 	return 0;
 }
@@ -372,8 +349,7 @@ static int mps_new_file(unsigned long base_pfn, unsigned long npages,
 	info->npages = npages;
 	info->mmap_capable = flags & MPS_FLAG_MMAP_CAPABLE;
 	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
-	info->readonly = bitmap_zalloc(npages, GFP_KERNEL);
-	if (!info->absent || !info->readonly) {
+	if (!info->absent) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
@@ -398,7 +374,6 @@ static int mps_new_file(unsigned long base_pfn, unsigned long npages,
 
 err_free:
 	bitmap_free(info->absent);
-	bitmap_free(info->readonly);
 	kfree(info);
 	return ret;
 }
@@ -675,11 +650,10 @@ static bool mps_child_owns(struct mps_info *info, unsigned long first,
 }
 
 /*
- * CTL_SET_READONLY and CTL_SET_PRESENT change a child's pages, by the owner on
- * the control device.  A VMM that holds the child fd cannot, so it cannot undo
- * them.
+ * CTL_SET_PRESENT changes a child's pages, by the owner on the control device.
+ * A VMM that holds the child fd cannot, so it cannot undo them.
  */
-static long mps_ctl_set_range(void __user *uarg, bool readonly)
+static long mps_ctl_set_present(void __user *uarg)
 {
 	struct mps_ctl_range cr;
 	unsigned long start, end;
@@ -695,12 +669,8 @@ static long mps_ctl_set_range(void __user *uarg, bool readonly)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ret = mps_range(info, cr.offset, cr.len, &start, &end);
-	if (!ret) {
-		if (readonly)
-			mps_set_readonly(info, start, end, cr.value);
-		else
-			mps_set_present(info, start, end, cr.value);
-	}
+	if (!ret)
+		mps_set_present(info, start, end, cr.value);
 	fput(file);
 	return ret;
 }
@@ -715,10 +685,8 @@ static long mps_ctl_ioctl(struct file *file, unsigned int cmd,
 		return mps_ctl_setup(uarg);
 	case MPS_NEW_CHILD:
 		return mps_ctl_new_child(uarg);
-	case MPS_CTL_SET_READONLY:
-		return mps_ctl_set_range(uarg, true);
 	case MPS_CTL_SET_PRESENT:
-		return mps_ctl_set_range(uarg, false);
+		return mps_ctl_set_present(uarg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index acff5785099b5..5955c1c0fbf80 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -48,8 +48,8 @@ struct mps_setup {
  * RECLAIM them.  Each change revokes the range, so KVM and iommufd follow.
  *
  * The owner changes a child's pages through the control device
- * (CTL_SET_READONLY, CTL_SET_PRESENT).  A child fd is read-only to its
- * holder: a VMM can only GET_STATS, never change the memory.
+ * (CTL_SET_PRESENT).  A child fd is read-only to its holder: a VMM can
+ * only GET_STATS, never change the memory.
  */
 
 /*
@@ -74,16 +74,15 @@ struct mps_stats {
 	__u64 region_len;
 	__u64 owned_pages;	/* pages the child has */
 	__u64 absent_pages;	/* pages taken away by CTL_SET_PRESENT */
-	__u64 readonly_pages;
 };
 
 #define MPS_GET_STATS \
 	_IOR(MPS_IOCTL_BASE, 10, struct mps_stats)
 
 /*
- * ioctls on /dev/mem_provider_sample: CTL_SET_READONLY or CTL_SET_PRESENT on
- * child @fd, by the owner.  @value is the readonly or present value, and
- * @offset and @len are a byte range within the child, page aligned.
+ * ioctl on /dev/mem_provider_sample: CTL_SET_PRESENT on child @fd, by the
+ * owner. @value is the present value (1 = present, 0 = absent), and @offset
+ * and @len are a byte range within the child, page aligned.
  */
 struct mps_ctl_range {
 	__s32 fd;
@@ -92,8 +91,6 @@ struct mps_ctl_range {
 	__u64 len;	/* bytes, page aligned */
 };
 
-#define MPS_CTL_SET_READONLY \
-	_IOW(MPS_IOCTL_BASE, 11, struct mps_ctl_range)
 #define MPS_CTL_SET_PRESENT \
 	_IOW(MPS_IOCTL_BASE, 12, struct mps_ctl_range)
 

-- 
2.56.0.257.gf7497c7d27-goog



