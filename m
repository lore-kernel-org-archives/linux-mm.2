Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1E0606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=akznfBkv
Received: by kanga.kvack.org (Postfix)
	id D5EA86B0A41; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EE56B0A43; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5CF6B0A42; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 930CA6B0A40
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224101C36B0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
X-FDA: 85351853034.03.A202B3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EEACB20009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=akznfBkv;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711695;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ahL4TP/omD5Vlmg3sgYIZkznIxNyj2E4z7Lb7O0L7o=;
	b=Wa5lt4WihtjRisqbiUKzoBnAmjVMG7XVTDcga06hhBhBv6MONnas0oUuicrhYAfqAsxK+f
	P6n4mR21Zi8Rl6DVHlGeLmrrgYD2o6+zx8D3RK5p62LEqfIhgt7QiXlmoIfmFPYPg3q4sw
	HQlDUHBdvlG6iCLR81KjVFOaFCrERaw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=akznfBkv;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711695;
	b=ucSZm7xbN82dCa4hQ+LlcGf4FP0U8EiluiXRPf/Qz0/7/BkyGDKZvZdNq+z4l9Q+v4mZOh
	b1v6/UTEbsMcp+dN1d1HQNUbOrcrC5qbKb6ZxwexAh3PqFOslgj2N42gRnlHKSDZPowGLx
	k4qEfgGKQsQt9yvfAl92umtPdqA298A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ABB14478A;
	Thu, 22 Oct 2026 23:28:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711693;
	b=aQ/2lHoCNowyTs4+qDuz50kZmQGsrjj85kFi0K39nfswxuDu3ocflxFzurouJJMeeScw
	 uzAkxkggNPgKMCDs+OhsYHbxJv8IyQxb3tjNfujJRoujYF0DRuwJIkDcNriOCxdPGYtRt
	 C7QFflyMVdxOKpTd4FSbiGWeMd2fBMx3Pjp/8zjrR8rzX+mAWI04BE7ROnf9ob3ZUzXDa
	 EzHltIu4c+4XdOgHIvQFKeY5oQprcwqGiYmMUR+7e2UOkBerZNv1dx9kEMO/Uo+dU7o2B
	 zN5vp72Jamq0Mpp0IgTvPg54n4qDtvd3zjhVoatAxb81f8uKuQ64y877zp1ZuufH81w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711693;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/ahL4TP/omD5Vlmg3sgYIZkznIxNyj2E4z7Lb7O0L7o=;
	b=WENU9fIDjSZu5lPd+8BlQsV4LXc3b7uaebcrUKHNVz1Pwb0wsReHa4wvlAclYeW/6H8A
	 WK8hrJUVUOT0k1PVbgp41hSMqKLm0No9a7JkdKHax7NwBM9GUb/IvWrbEZ85HIjs9/xu6
	 6GuGW+N9B/JqPU06juQ06aTlPCYbNKr+jNdLRAYVQHJxOFXC1F+nPeUJr4mrew7/kKJFy
	 r8oKD/BCkTj+iBCLM78E3xb7Pe1za3HrOBY+BoJchDx8l7cEFauZuk8vpfLSBzGW4/UjI
	 PqSH6U1QRp0HKshHlOBQKHTx+mAqrpWLM5Zpttt1c7TFP6Wn2kSpeGn1IXqNltKUUSA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8FF561F01180;
	Thu, 22 Oct 2026 23:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711693;
	bh=/ahL4TP/omD5Vlmg3sgYIZkznIxNyj2E4z7Lb7O0L7o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=akznfBkvda1EdCIgc0eTx9SRFSTr4nATaEn74QtSOTL86CsikVlWtlBIQ+Bn9L4Om
	 Drma/nw1sXBRwyXpVLgOPmaxK29E3ZaHlN3TYkz3wYT4d3nWsl7Pm7e91Os/d9ZlMl
	 /bu5e+hCkEjrFgA8ViyBvVwMfWBmNOvsXNgtskfZ9kmlh10uCjuPK9J39Z9i3seTyc
	 JLbh2aW/boGfbP7HWRy+7rJsFcpuLwYBGRv9KTDI/N9utZ+aERyNXEBaOjhZXpyS6r
	 t3fldebW3ujBUfqVScQCQH1pwogeo6N0M9kqsKhXaVk8wmFrD1kK/sqyQIKUJP2put
	 NUb1rZQbHzmjA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BE966420C0;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:03 -0700
Subject: [PATCH RFC v2 31/50] KVM: guest_memfd: Support getting PFNs for
 stage 2 from providers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=6020;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jEkr/nY1nFVQLtsltdN4AJnwp36Iu4m7TarLTGyPZVc=;
 b=vAkluFarmlZI1TwtSGhLOd+jHlS0DLSrWj3cCriODu55Bs8Tz1V4Ot2NifETUEWZCMUMWV2GD
 CtaY4a2NaZCCpOvCQwRHzJ6wEKfOMC4mO8bqs82RiiNQXQnqSLT2A0P
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEACB20009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sztcet9puxbitb8hhqp36uo9qcqmbjni
X-HE-Tag: 1792711694-946507
X-HE-Meta: U2FsdGVkX1+S1TMtYw+j8Dz2eyE88Y0KR7Y052wY+7teiofL4Az8CR7QZx6Y0+f/Kz6+bwexmVe1N6XKv4FX4sRSNH/uHF614VtpRjnjTYua7AdIllDnowoB0e5sVYmkdv4fPikb25r8KcH7ZX4R5zUOnYJjkJnJ8k0/mIyHTH5b79JgIPLQQqSp1lEm22hldOHQ+yHZsMSy+Aw4GdJy7AlgnizTPf5OmqSF0oaE4iOxgUn8uMhYOj57ShpvzyTewRZexcz1Evo6Z3gAkZ6e453wrqeLcgu+ikfpH2fBY7j71brmsm7jkp8AQKa59nCpbQGlghG82JyMzMHMGclBDUB7nwMW0BMqehfI6uFg17UHB2U4jnV8An8owZDT8zoBmbBJZR1wVwpb+y4EYIv5y//gUmte1dqNcQEL1W22WCKPzyz5wVFmy1AZifOIST5pp9S8FifU+PJV6iJix6o3YXc0lm00kHILN9LmCUYzdFthAwTEL9BJuqxP43UQcAM0ytFMVxMiiz7+m21JLVRGmtULYd6Q5kCgRNalKJU61CzkdDdhCyxWFexrIiOnIG6yojX244XmomgxJg4Rlln53WYjgVNPw9B7x1j49G45UQ+PudCuhMNNFtBNz1dry0VcfboOEFkXd7ce/3nBdGUwCI0URbtlMaJDt4Cni0ig1gQFon/02Rb92o9R9ZXoppoxU7U4RB4eEnBx/AmFzufYVwsIcZO/1PCDVNYovRQat4LLZnwQg+xwzv+Bt6qKOfMfjR0kw6zIEm7l77+9RPe4S0r3o0gC5cXIlbJkEMutlbL9oIpwgfZbVFDJkmG6SJMEQdeigBX6IWi2ImCWvXec8S4ZlgAnu67/K4bkhQow2yeyN3eHSceigO1RyPblrJoLTSSJOzBUBr70OvY8gtE+bV2W+wHmFU/UyFmdAmCamuXwmlHSeSDwaumFbg03qfuLAkAlmxrZv3FEJpYtDRo
 TXDGjuCw
 x4JFskw6HJo0glbRVW2L0S2WcFlFKPg65gskbhR1tW6G+t2PhRP+nByHWXqtzIPQbyeJgU62eo9xVKG2YC1uzzUwPqBAk2vjN4IHRypnXFmWcNle3RvGDpzem5uCCUbBXya1suVjmo860eJyCRaQpRnDiykJSsa+DlZbtGRAMWi4FA6BqibuCsLmSiJeu+ZqXfB7d2Ci1IJ91agMJJRbLfEOORv/sWEJHYKYtZf0Es92yadDgpCXiu+N+TgGUEDCZMpJ6oI6vMNHwPXDVuKybEY6elxJxdMFxbgtvgoPiIG4/FPvR5mvvCX/pCa153jtKX0SZ13u/bvYbL3d1aHmwQHcJWuPeToxCfGKwnppryMj3slcKJuMA9r2X+ELcWZeoep60hqiNz7KYsQ12PQ7bFrUXN+9b4rW1c/FCLleL+aHxwoO6BXyRmImeMH9vkYjxngIDN/3b3XLjGKdV6te7UAApHdz9/OFvsaBZT/Y+QhluqdISkT3UAbJvy2UX4V6692+tljhEwkxUVOv7LLF6VR1loBY6NqPSSNj26K6+ZB7RynUNh8OnIc61ZJoLv9TDAGZzkmdtjjCznbrx71S8jGaxxIa38uiZoJrr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add .get_pfn callback to struct guest_memfd_provider_operations to
support physical memory providers (e.g. devices, DAX, or pre-allocated
ranges) that supply PFNs directly without folio allocation or page cache
insertion.

Define GUEST_MEMFD_FLAG_PFN_MODE in uapi/linux/kvm.h and define
kvm_gmem_is_pfn_mode() to check for this flag in gi->flags.

In __kvm_gmem_get_pfn(), query .get_pfn() directly when in PFN mode
and return NULL on success (instead of a struct folio *).

Note that .alloc_folio is still required by kvm_gmem_attach_resource() and
GUEST_MEMFD_FLAG_PFN_MODE is not yet enabled for userspace.  Subsequent
patches will update the rest of guest_memfd (e.g. mmap, fallocate,
truncation, and attributes) to support PFN mode before enabling the flag
and allowing external PFN-backed providers to be attached.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h |  8 ++++++++
 include/uapi/linux/kvm.h    |  1 +
 virt/kvm/guest_memfd.c      | 42 +++++++++++++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index f3e6077c39ac3..10c48f41a6d7e 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -18,6 +18,12 @@ struct mempolicy;
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
  * @invalidate_folio: Notify provider that a folio has been invalidated.
+ * @get_pfn: Obtain a PFN for a given index. The provider must ensure backing
+ *           memory is present and is responsible for its contents, such as
+ *           zeroing if necessary. On success, return 0 with the physical frame
+ *           number in @pfn and, if @max_order is non-NULL, the maximum page
+ *           order of contiguous backing memory containing @pfn. Returns a
+ *           negative error code on failure.
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -27,6 +33,8 @@ struct guest_memfd_provider_operations {
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
+	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
+		       int *max_order);
 };
 
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f4108bf7e3192..6798056f50e32 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1675,6 +1675,7 @@ struct kvm_memory_attributes2 {
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 #define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
+#define GUEST_MEMFD_FLAG_PFN_MODE	(1ULL << 3)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 84877beed6701..3d89bc76f3867 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -54,6 +54,11 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
+{
+	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
+}
+
 static void *gmem_native_attach(struct inode *gmem_inode,
 				struct file *resource_file)
 {
@@ -124,6 +129,20 @@ static struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static int gmem_provider_get_pfn(struct gmem_inode *gi, pgoff_t index,
+				 kvm_pfn_t *pfn, int *max_order)
+{
+	unsigned long raw_pfn;
+	int r;
+
+	r = gi->provider_ops->get_pfn(gi->provider, index, &raw_pfn, max_order);
+	if (r)
+		return r;
+
+	*pfn = raw_pfn;
+	return 0;
+}
+
 static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
 					   struct folio *folio)
 {
@@ -1270,15 +1289,17 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
-/* Returns a locked folio on success.  */
+/* On success, return a locked folio in folio mode and NULL in PFN mode. */
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
 					int *max_order)
 {
 	struct file *slot_file = READ_ONCE(slot->gmem.file);
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
 	struct gmem_file *f = file->private_data;
 	struct folio *folio;
+	int r;
 
 	if (file != slot_file) {
 		WARN_ON_ONCE(slot_file);
@@ -1290,6 +1311,13 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EIO);
 	}
 
+	if (kvm_gmem_is_pfn_mode(gi)) {
+		r = gmem_provider_get_pfn(gi, index, pfn, max_order);
+		if (r)
+			return ERR_PTR(r);
+		return NULL;
+	}
+
 	folio = kvm_gmem_get_folio(file_inode(file), index);
 	if (IS_ERR(folio))
 		return folio;
@@ -1338,8 +1366,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
 
-	folio_unlock(folio);
-	folio_put(folio);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 
 out:
 	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
@@ -1366,7 +1396,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_unlock;
 	}
 
-	folio_unlock(folio);
+	if (folio)
+		folio_unlock(folio);
 
 	if (!kvm_is_private_gfn(kvm, gfn)) {
 		ret = -EINVAL;
@@ -1376,7 +1407,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
 
 out_put_folio:
-	folio_put(folio);
+	if (folio)
+		folio_put(folio);
 out_unlock:
 	filemap_invalidate_unlock(file->f_mapping);
 	return ret;

-- 
2.56.0.257.gf7497c7d27-goog



