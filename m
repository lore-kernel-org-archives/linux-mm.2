Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DA3606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cXw8d48R
Received: by kanga.kvack.org (Postfix)
	id 177576B030B; Thu, 22 Oct 2026 19:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F2D6B030C; Thu, 22 Oct 2026 19:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4796B030F; Thu, 22 Oct 2026 19:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B85BC6B030B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3793780305
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:31 +0000 (UTC)
X-FDA: 85351853622.11.9653BE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1D58540005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXw8d48R;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711709;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oon/Wl0cFVlge01LV4w9rMF/HSDKxefKbLCSBJ1eDxg=;
	b=O6yXKxWMbFjF234x3Af/1kVaKAtvZW3Sl8tFQBnL31cS8S+2HE9LfUCUNRtwRA3CaFaLsP
	TLfdqTlCdP7e2EvuimE17TATQgfMRLXxaz0/NW3x76aGgbmQTbhifUDe1uZqDK6nvrSzl/
	y8CXd8NfXs3IGRxiUbR3YdxhoxdZQoA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711709;
	b=1KvnN++tlN3tUiOCHCEqMZr5hzyJY9GJo53WvRGttt+1leQiQcB1/Hkvd3JWvBN9Dd3wJi
	g/5nNDciod4QDgFKq/TA8LNb3I7wRBwrLfR5KpNrFTC6iwuUTzBysVjFnzDktDZ6NfYERz
	0R8N+Zs/axF7mv7fgVGiG2S7jT1YSHk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXw8d48R;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A181244855;
	Thu, 22 Oct 2026 23:28:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711702;
	b=Qf+87GYkwaSz9PI5zdDr6gb5QiOwqvNXviOjXWyKZfumbggeDaqj8Xg+lhQgJEp7PNnj
	 i02lCx6McjFMaY+aGlLLsJkRB6geUi8UUSMS8HAoLnyKRTbQHEb0cCFXRs3THFIjKjuAk
	 MEu136XbFR0RVH/vIZGOGKZoGFtuI2pO4v15Po6jvnBKa9IZQv/mFVK8OhNDANe5kT3u4
	 T7EFWs5/siUsa9qzKoraMJytpRWldNugZHAgbsNfG/krAVe1Y+kl083R2otGeBzTgVk9G
	 kKhXwXLZvBwRKCSn1oMhCWr82sfNlZqpLh2Ew1Z95BepWVzuMTvuI8l7IrVLfL5XAUw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711702;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Oon/Wl0cFVlge01LV4w9rMF/HSDKxefKbLCSBJ1eDxg=;
	b=RfHcUlGj+pmYJHsGCIK+xoApy7dNrlQDvHKvkM2D7C45B1FBtnT/FTs7Z/H6+KqDjyfv
	 VjNSQzmIYcN/R/sMOsybTcaEcrPxy+VQFP5ZBfgcCpHjINrGzHspSgQu7T7jPC3bw2GBg
	 eTZhfiAK/T7rnkRyua35PSvhf6CueG2w/IKmiH4PPvJrPke3IERkYJKLWHku57M83d5PU
	 bk+cXsVl4btu/XRsuGdKSv8y+zzAamFJae5kBgkSrzQyc5QvTBsk/lNjXOIQmmerky3b4
	 lKCsjAtCOTFFaArmsCFyImTtH438QRjGbsJ5M1vN+Je9Molu/5y3U5hFnvD/+1fyxPQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 78A5C1F01181;
	Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711702;
	bh=Oon/Wl0cFVlge01LV4w9rMF/HSDKxefKbLCSBJ1eDxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cXw8d48RQXw9ldP0ViwpFV2UGDM28sKA4601rRtOakiWKCs4Nr/n6A4xtCLncW8wx
	 Vi06alFuJB0wSefvus1O6L0XjbN1M8A5xvHj+nLARlJPgTJ2vNe3DwyZE5MQtdYRjK
	 2ZAGaJk71XlHyxsfAyNS9KnTZvQdXUNg+jVqcHu99sJt+df9XHwkXSeJ+QpThmD5ec
	 3uoB2fd5bnJ4yhVevHgFQBL2TgNHzhPgT/Uo4TUK9JMNiFptTUhhd1oQ4sMiyHxH35
	 l2eVxCCDpki3EAgzwY79njuIAkHXz+2QVMppWnW2R6tQk6ftL01poXM6JnD2HtWr92
	 mKRwHuEuouPKA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4DF7E420EC;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:14 -0700
Subject: [PATCH RFC v2 42/50] KVM: guest_memfd: Allow attaching PFN-backed
 providers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-42-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=4433;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=r3G1b25ALBM6wMvd/747hMYIZj3YhFu10RpViIKjcDI=;
 b=phriq14m4e3ftQWqFrQ9MdA+RUzt4d9nkf6dKgnaAJqUM0tUNoHYFn8im4Gnk+KwoH5t5m21o
 yzR4Z7NE8XKCFh2KG8R8DtYhwaFiNI2lgxJeBk6l6kYqJN4+yJpVdFf
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D58540005
X-Stat-Signature: 8bdejg3wqrrjw9bs53o3etzkp1dqtp37
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711709-651705
X-HE-Meta: U2FsdGVkX18eEQQKZ8iLg46SzPTeDl77naZhBnELW8X8LssHYcodTpMLqtw00leAW3kMJLr28QSoY1QQIbBzWk8Vw8ntpiCLeTAYj5TYZphXtOtz7UfC6FZpPKCFY21WFhycIPhHsMyVgqICbhLYzuPjGfcpLTQEvgxNa5sN+JTfGia0S1STFieoI/NQds3f0QMrDayqhQCE99L44JHRFgp7PgNaJt0lW9iawqW0nQk9yHwWDaWlUXSechRjP8h8mfX0OSYnPNEect9PqhSDoCA1fu/IlJNzwHPDZjzR9o9gfgLrR0Jknx5AXPJCCc2f50nYgW9SaYbpYnWrj56Knpci3GxnkQNa5AdGil6mMVdIXzEafCSizhOeRTqHt0L/kYJZOHRbzdgAZwjI1o9gzC2BUenGg4toZbuh97+J90m0EIRnuE7JtGjDutN2HoCzL0rxlY5PONbnCA2QH0LPlf36D8dIvh1SWAsYDPPIIeEfFmalU0BxA7YfqCEZ2iy47DRev2dS+pVyn1UFF7jn8imkxGoQLB0A2rFxUvsp9ym2wvwzqHXAbPT2K87PRHyJbTV54dR0MabMd3SWvq00WUwrto1z8pWSsgTigEyQntEDNvipWEMBdUDB+HUfDGlRsWpkVXL28+FyNoE1yXObzqlk2/5FIcZx+KhGVHCJXFHVD/4TbZ/dtDJiggzIkRNZkPGoMR8XH0JVTQ66EbL8X7EedSSAzG6Z+U7qagt0o65hFqJfgmsogwb06k4HwQIS3Hw4KAltzGKSmEBrGK9CCyIrTe8noVxiTQnmLy6tNplGmMF5cEf+sxiZPrHIhuKT5efqTwzstqNOWQTPmXfS8Dzq6WJgABqBK3OMkGjqmELLJNgbqMvpe5Wsg6xWEnj7t5D+B3niLT39AqqzNGE4WnBSKD5Nro//d1LTDdJFE4IbEOUglvGFITCw7YyM3OP5jIR/yohqeuNPteQ9rY3
 H3YVAlvI
 AoNe/sTrtxcB2i/QYn2OEkMQlCx9IqPgZPXF2txbr4TRUIq8I+ghTcPeg+cpq6KLHOZV7VeDC2ywfmer1ZuTmfGkLOQpOjgmce1zHQFnKe1dOqVMNzygnxnrMbG036OyZkkNrTqxbIxnNk9CWiABSGhGmauQTXn407xZV7tXrManojEjlhIgcwrmk4xOZ9mCrGbl3Gq8G6B+2R7el3/BLkhcUa1B1H33xGILRhbCvvsoS64xKy7Lo0N40ss3eJaTZ077An04VG6Z1MeguDDbFynaE1u/E1fRsxs5L1MxbDjagNXG4CWD9aI1PXCur3yWIi0CfdquDFoqaInQLnz0mS6mpWADQ8dKQs3K38APVdhpSAWYzZ8gk9nxMOwI0oA3igzMcCh0cFzfqXJ/nMSa+kiA0+0SJQyzMKScwMMhj4eZw3dCkoAfyMhlIU767gspk8eCdMzoFxSjuNE0AEsh/HObRUYKiHxG9lsqtEic/IumsnF8tInKPblocgaqNq070F4onemo3nOaRKnOn1iri4Ko7/DuIFxFXFz3m63ihnprd9lNgAwCiHsS08mai/ybllJOEmOSAIBofWJ0WEgoXzmb1PFINgfHUNct46uUdbKl/rmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Expose GUEST_MEMFD_FLAG_PFN_MODE in supported flags to allow userspace
to explicitly request PFN mode when creating a guest_memfd instance with
GUEST_MEMFD_FLAG_USE_RESOURCE.

PFN mode is only valid when backed by an external resource provider, as
native guest_memfd relies on the page cache and manages memory as folios.
Reject creation if PFN mode is requested without an external resource.

While guest_memfd could try to infer PFN mode from whether PFN lookup
callbacks exist, an explicit creation flag ensures userspace selects the
operating mode directly, allowing providers to support both modes.

Validate the requested operating mode against the provider operations
when attaching a resource:
- In PFN mode, the provider must implement both .get_pfn and
  .lookup_pfn_range.
- In folio mode, the provider must implement .alloc_folio.

Document the new flag and its requirements in the KVM API documentation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 include/linux/kvm_host.h       |  3 ++-
 virt/kvm/guest_memfd.c         | 18 +++++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f5313d405d9c..bb550e4f11cd8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6524,6 +6524,12 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
                                 must be a supported resource (e.g. tmpfs mount
                                 root directory). Currently, tmpfs resource pools
                                 require noswap and huge=never mount options.
+  GUEST_MEMFD_FLAG_PFN_MODE     Request PFN mode for guest_memfd backed
+                                by an external resource provider. When set,
+                                GUEST_MEMFD_FLAG_USE_RESOURCE must also be set,
+                                and the provider must support PFN lookup
+                                (.get_pfn and .lookup_pfn_range) rather than
+                                folio allocation (.alloc_folio).
   ============================= ================================================
 
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d820afac49252..345f97b110fa6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2618,7 +2618,8 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
-	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE;
+	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE |
+		    GUEST_MEMFD_FLAG_PFN_MODE;
 
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c89df77df7146..a4519f3b9eadb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -85,6 +85,18 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.alloc_folio = gmem_native_alloc_folio,
 };
 
+static bool gmem_provider_ops_valid(struct gmem_inode *gi,
+				     const struct guest_memfd_provider_operations *ops)
+{
+	if (!ops || !ops->attach)
+		return false;
+
+	if (kvm_gmem_is_pfn_mode(gi))
+		return ops->get_pfn && ops->lookup_pfn_range;
+
+	return ops->alloc_folio != NULL;
+}
+
 #define GMEM_RESOURCE_FD_NATIVE (-1)
 
 static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
@@ -104,7 +116,7 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 			ops = resource_file->f_op->gmem_provider_ops;
 	}
 
-	if (ops && ops->attach && ops->alloc_folio)
+	if (gmem_provider_ops_valid(GMEM_I(inode), ops))
 		provider = ops->attach(inode, resource_file);
 
 	if (resource_file)
@@ -1291,6 +1303,10 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
+	if (flags & GUEST_MEMFD_FLAG_PFN_MODE &&
+	    !(flags & GUEST_MEMFD_FLAG_USE_RESOURCE))
+		return -EINVAL;
+
 	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
 		if (args->resource_fd < 0)
 			return -EBADF;

-- 
2.56.0.257.gf7497c7d27-goog



