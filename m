Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B448F606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+iMV+Tl
Received: by kanga.kvack.org (Postfix)
	id AFA596B02FE; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4C06B0309; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3096B0301; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5598B6B0301
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF54AC0329
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:27 +0000 (UTC)
X-FDA: 85351853454.01.E96BAD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD0BF20006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+iMV+Tl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711705;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CAsspFacI74tIRNd6wHkIQKFznmSOkNFeqBDDMzIpo=;
	b=Ly+KMhGyiNe48Vg+CEVMdgCTFDXdSGG8WUVHUVyS2FpiOezlxzBZuX/Cziskb+DTI5rRWw
	PeHp+fzMz/EmrVmez2EZrf6j5q9oeUnlMKAP3FMqz10BHsbmss+YiF3UEVGhcQQt6n1nGy
	qtGWrxPNUvkDkbv0xhfJ2iY46ck88Lk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+iMV+Tl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711705;
	b=7qcj9V0gD4+ZWQWAMNIxtgSXf52d02ACHea4mZo8gTyoXbIHP7tjCJ6ncF0xU8kZO/JIhQ
	UDTxcpMfxIcAkzoMYD2Ack8rzYWdSeH/Zl8y+zSyjds4IlxkTw4p9B8fBDGi3/vk2vDelb
	7CnXmVkixw4z1+haLjdtKLGT5clki4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 541AB60DA3;
	Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711705;
	b=EJWlkWKmtAD3sxbmMiy9Lrhjh7+TXBO8IA0GDnVxoTVdbCB8I2A7r2xBVnBIilr8IfS/
	 l8zYMkZg4paabBcL/thrw8FjI0JltfcDwPRUhFVeQ3auR+FidrBu/woJYx1BksXX23hsJ
	 fO7x2XnTMoub+nLHJH8HHAkHInNEeSn0MStaGj5XUIKqFeFDUBWLuhkJLI3p/jQW9CBcO
	 VdXvWEsbypW1rKT7oWSsZTZRqbK8UEaE61ae7A+/vnZU/37/9sx+innhwimdwO/7uIO8+
	 qjdJjThNlfzTmHCPzXqbI/Fq6p1HpPoJkSlkd1jS6Qlm4hd456du+Pvx1DCG5tB0JZw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5CAsspFacI74tIRNd6wHkIQKFznmSOkNFeqBDDMzIpo=;
	b=XGwHZXrCPPUnWvslAM429Kk2JLVqlAFN17eUeNlGjolC0ya+eozrCw4o3tvFZFPE5Ozr
	 xhMFO3GYtiakYfXtWcXgebkZHT67FhFBa1VFA0ANkFy81R9cfam5Q8H6LHYnkjMscmIZo
	 wQmV1vuJyI9zAAUfbsf4BOolLuG93Zju5zTqZHGjbzDTyZ0WYoAVSPk+/ZaxhnC5J14vC
	 8FobtJIgqU/fshgcpEfNNSBy6vdTcfIAa0JVKUXeDKg7y3Ci9KlQg+Cj2DbkgwKpiGngF
	 iRxgLlFW0y7UewXa6QiVpk5Z/YDrCSOEUcEHyviZvK8U0yYwp/1yMbACRYepZp+CFwg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C3F071F011AA;
	Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711705;
	bh=5CAsspFacI74tIRNd6wHkIQKFznmSOkNFeqBDDMzIpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=h+iMV+TloPo27vdnRshYBnjzGiRui2RgjmT58nuXdqtvRRsg8zIzOVgyRPpV1lirA
	 774vzBkvJEwcqo/kaRb8CJNmNxO3q3jIR0lrDo0hD9IS9+wjJGVLmEv95vBR36sWmM
	 d3TwfG0ChfoNlYbvwLo3riXCiTCAiA0la910HGhJbLKBDzPOgFeQoYvoi1naXyLM9G
	 L2AU60rZuyMRR342+8t50wu+QhPA7OV6k6mGHhOV7tbRUadzxGRjv8kYXAlE1mFG1C
	 rJIGxCXYVJCKE6MTVZ/brQdGTFMPxMAJMmGrhphOTt9MnfKZmzmQKytt31pwes5D9l
	 BCLvA2pREAinA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 58565420EF;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:15 -0700
Subject: [PATCH RFC v2 43/50] KVM: guest_memfd: Export kvm_gmem_revoke for
 provider-driven revocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-43-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=6495;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hV27o4dOKADJOBUsB7Zz8/cT/cHzwJnpPOhSKk352LI=;
 b=4E+0DU5MfmUTG1hQwn7ACZlFI+aTYH7wks1B6nXtVQ3pWafKFTMBo9Mjy6qKdycEe7OVKp8HY
 LiHgjjinaImDtSQUqTE85dXAF4QL/Tb+eK+zVjZ97MxpL/inN+lsKCX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BD0BF20006
X-Stat-Signature: iyf6ryuoas1egc57b1bwdxdj4xj1pszj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711705-51011
X-HE-Meta: U2FsdGVkX1/7iwSUPCzVeuqzzDGSsvUGvi8MXdY83tw1Juo+hDJpP0GowYV/zTA9kAgWIyDM69e+68IMdnxN2PFYuWVXSpd5yqVbiDc+AWaIZmpLLO1Oz0rOWV8hRnWrQb+r9P7WanU/JW4yHw0D4zjxMoW6FTMHTnHv7wxSbxiy5P8ShfEzKV59TF2Qn8sGeStMMl4FWecqKoERhQu3OWASyc/HGADgm5Mjz82FaM0a9og3Myeo0S4s95OZ7STaV82k/PNj+sh+a1wtL/q1sMt2OEd+PVyMafZYehuAzJEqRM1fcKzwgS1qFy3PTWtHWNceoEIDSYekbpvcVloT5WJMW6Swd63oRp6uEZo1qE4XhuU+OLQYuqUIVs7E9yWhV2e2/VJWUK0IGsj3lR+eq0v961iNKtGnttDH03U2iHYoVe7vdopBhafaOVLtTU49EqBGmy2A8/8y3UqztYfXHmTN1WYS3hT8S9OQCQ1cD8RSe0ptX/16COn7G6Qa6pljMo1s5nsPz11nHWEyJIV5ul0envWBBvCfdls+z4xet9gsbmiaUGgoI05ronfWkwudiFC2fe2LkHBrh0nY9X0dLmeMeAfb0FovcJVgTsDXQwqIa6qRdjcj/6UqQs3GsZeRuZ3R1MZHFFsu5GYTlGrm3wkLNiQY+fAhLjTgP47rHMxr5k4TcgB7p6nlp0PBTveMESn6cg0SW8IAgcqrb1DwW8mZ88jN1MMUxB92Bvlmjhn6d3rrSfWApZboHfPwTOIirDtgP9q1fHgk09f2Z9wxy7wiu842ND2DF9EM/rDS08kZ6pusBpQSJSyT9AV54zDkTjkfBzDeulVRkhXIaXWDBw78a8Z4l3fFOgzehnvbHZd6yyWm7nX0aL3OGBIM334YfNTrubmceT1EBHDQfFGurHfc1zlmp3opLVgsQ0Rw0nlmzLoSr3axpiyUbQRfg6r8rADglTX7qk53g9t+mG9
 P5AjDML/
 +hUFSLJ6pj+kT9r9OiIMQ4uLRWR4/38Vx3sbeeN28ZjAIr9xoDhfyKItOooqTFb41EyiMAPDxV/KkSg44jeYIxOwUHW88OD46B8MynMd4CZ+S1N7VqgpxZP1komXhwO1i+73qh5X6JQALDjVuoEV6XT7Pcel89wksfJoviGqscHUV+ssm8m/+ka+pJ4FDDhMLBL8rokSh47pJAyJUPdsE3qZ4TcgE6/A2Fkye5XhsbdKYAHMt0pmIYDg66eXOev4u6vLWpJVL0s0x6y6bkAPEsV9z2ayWO1kw9k+xyQtwSwHuk4A/SdFELte4v5RuuqqkSqeazOObqNTn0rJcvkVolEmOOf7hgVRgS+eYrZBkR/ZdD9VY+cwLuJiWLHUEBsjyS8WcOHqMR7X4Tyj7QRJvrXVTPn1MvzrTklw4QscZm/r3eIi19MSNplVcvO9dzmY5JIjrd9jxxPFHscCRTKaxqFIeyPQKJtBcft6CmVhT9B9j1qzGCNGHvEpMLKQoqzNZP8jpl872GqF1PCmAYjHJez9l3VH5IerT2uFySG7OCumKvXeZilNhOcEbYpDdX+BSNLfHYTxeds1wZIR9gepv40XTcdcuC3b5v7ZucFANklV4DZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Providers may dynamically revoke physical memory ranges (e.g., dynamic
page removal or device teardown) and need a mechanism to sever guest and
host mappings and reclaim confidential architecture state.

Introduce __kvm_gmem_revoke() to share the core invalidation and
reclamation path between kvm_gmem_punch_hole() and kvm_gmem_revoke().

Introduce boolean to control whether to call .put_pfn_range().
.put_pfn_range() must not be called when revoke is used by a provider,
because the provider already initiated the revocation and calling back into
the provider could lead to self-deadlock or re-entrancy on provider locks.

Export kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
const unsigned long *pfn) via EXPORT_SYMBOL_GPL. Providers must pass
both start and pfn.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Makefile       |  3 ++-
 include/linux/guest_memfd.h | 14 +++++++++-
 virt/kvm/guest_memfd.c      | 63 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c6bf463f50327..5fd01bd19d1c4 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -61,7 +61,8 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
 				-e kvm_page_track_unregister_notifier \
 				-e kvm_write_track_add_gfn \
 				-e kvm_write_track_remove_gfn \
-				-e kvm_file_to_kvm_fn
+				-e kvm_file_to_kvm_fn \
+				-e kvm_gmem_revoke
 
 # Force grep to emit a goofy group separator that can in turn be replaced with
 # the above newline macro (newlines in Make are a nightmare).  Note, grep only
diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 3c0cc35f748bc..3e2c0714ca33e 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -36,7 +36,8 @@ struct mempolicy;
  * @put_pfn_range: Release a range of PFNs previously obtained for a given
  *                 index.  The provider does not need to ensure that backing
  *                 memory is present. If backing memory is not available, the
- *                 provider should skip the unbacked range.
+ *                 provider should skip the unbacked range. Not called on
+ *                 kvm_gmem_revoke().
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -53,4 +54,15 @@ struct guest_memfd_provider_operations {
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 };
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+		    const unsigned long *pfn);
+#else
+static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+				  const unsigned long *pfn)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a4519f3b9eadb..3c4bedceccfc2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -421,18 +421,25 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
 static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
 #endif
 
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
+			      size_t nr_pages, const unsigned long *pfn,
+			      bool put_pfn_range)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
-	loff_t size = i_size_read(inode);
-	pgoff_t start, end;
+	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
+	loff_t offset, len;
+	pgoff_t end;
 
-	if (offset >= size)
+	if (start >= max_pages)
 		return 0;
 
-	len = min(len, size - offset);
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
+	nr_pages = min_t(size_t, nr_pages, max_pages - start);
+	if (!nr_pages)
+		return 0;
+
+	offset = (loff_t)start << PAGE_SHIFT;
+	len = (loff_t)nr_pages << PAGE_SHIFT;
+	end = start + nr_pages;
 
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end
@@ -444,8 +451,14 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
 		unmap_mapping_range(inode->i_mapping, offset, len, 0);
-		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
-		gmem_provider_put_pfn_range(GMEM_I(inode), start, end - start);
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+		if (pfn)
+			kvm_arch_gmem_reclaim(*pfn, nr_pages);
+		else
+			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+#endif
+		if (put_pfn_range)
+			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
 	} else {
 		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 	}
@@ -457,6 +470,38 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	return 0;
 }
 
+static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+{
+	return __kvm_gmem_revoke(inode, offset >> PAGE_SHIFT, len >> PAGE_SHIFT,
+				 NULL, true);
+}
+
+/**
+ * kvm_gmem_revoke - Revoke and reclaim a range of memory in guest_memfd.
+ * @inode:    The guest_memfd inode.
+ * @start:    Starting page index within the file.
+ * @nr_pages: Number of pages to revoke.
+ * @pfn:      The physical address / frame number being revoked. Directly
+ *            reclaims this physical range without querying the provider's
+ *            .lookup_pfn_range().
+ *
+ * guest_memfd will do everything to make sure the range revoked is no longer in
+ * use across guest and host mappings, as well as reclaim any confidential
+ * architecture state.
+ *
+ * Must be called before accessing memory contents. Keeping the mapping from
+ * @start to @pfn constant is the responsibility of the caller.
+ * .put_pfn_range() will not be called.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
+		    const unsigned long *pfn)
+{
+	return __kvm_gmem_revoke(inode, start, nr_pages, pfn, false);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
+
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;

-- 
2.56.0.257.gf7497c7d27-goog



