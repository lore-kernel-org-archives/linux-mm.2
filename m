Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68A2606B753
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRq/YxWq
Received: by kanga.kvack.org (Postfix)
	id 00C196B05D3; Fri,  6 Nov 2026 19:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F259E6B05D4; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3ADF6B05D5; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9FF26B05D4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 624881C30B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
X-FDA: 85406458662.28.75DBA50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D6F880004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KRq/YxWq";
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUz/9/mzTQxdlLDonugfv3iNeHSXtbV/yXh8/jks3ro=;
	b=1mrbMVHEtqkjdNXfdOOFF/Tuqt3jmg3cFcWvbYSbElfDNHGkp4XU4WNphsqK+zpWU7wNTA
	zsP9kUqw0M4cAxU2Nmre90TpkrxlijaQvxOCB1wsC2rRGHnHsFqtryunBmXnaAwuDfHi+K
	cphzKch8+9JUZib34l6tdvHC2kmbdjY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011829;
	b=ivLXwhk/vZOYmbNNnMNAuh8aVE9eJpKjDiw3ujQGdc/lm71NtNmBdR6iR4cyqnX+A5dsC/
	jzxCsZ/nXgtxAscPIBecUU4NjnLMcNbAyEptvxtVy1yddNTbbNo8o23rHZyP1oARn8rsT/
	yOHKPnhbIF2AtBJUVsnxqguBlQzRRlc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KRq/YxWq";
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C23844014;
	Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011828;
	b=dV4FWwyl+0Vq+Wu/eBzRC0Ibq9+BROc8wa3Odl6K8YHl6aCSeh93m9pClo5hDpG0DYhW
	 HZ4QEjw8Nw3+G/eMc9rU1cBKzIn1Bwku4+1RcJA3oFN/b8+KR+yZhglN/zY2DSNxfD8/5
	 EPkduY9Xp/hC0Xqstm3riyTyHZKexsS4F2HRRR4CWDbAAD/usq3hyCKnoDBz4j/MTYhLI
	 6zTMQUqAxDfJ1wLCPxwXB/20rfwFqDWRjm+gNdBvTUF/r0oZRWSC8pM9NaNkB5m79/BST
	 SmPwcS4Z6cgsMLAR0oKgftu//h24VAtHcL9P6ZfCzP1Dch0s2jB6vHC4gk1eK3PZC/A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011828;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GUz/9/mzTQxdlLDonugfv3iNeHSXtbV/yXh8/jks3ro=;
	b=b/LEMy9QK2pS/AWbk3BsoPZQJAZtGIt/puD1beexrwd1mPo7nE0gNohY3bImwkHEbHrc
	 UlOw1/A7+9rcgBw5T5ar8X20hm6sXUElLD5eV/0Wx9oUp5qnG9C1i1VHWCEQQHndWvNVr
	 SNUOXpWuQPoUS3pNZ+ooYxuhXGrh2pYo17Ms08nvJid5ASK94Np5aFh+yxNwM2N5Pj8Ek
	 FuAYPNYmcgzGioyg81IaFMeWzhfIcOdoFGyG48tY4LJq+7D8wY6CgaFvpABhju/DvGriP
	 eki2MulVxnliHSS8bpeD7OTD8fskofvD+C6HZQ+fh5JM8QbTTsgmbezTaBSB9JZPZJQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D70701F00ACD;
	Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011828;
	bh=GUz/9/mzTQxdlLDonugfv3iNeHSXtbV/yXh8/jks3ro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KRq/YxWqhzVfhoEeV4pTcwbmxTbXaS8qOIqIjlpPgO9zlIAxX9K65hVrIst7qdEYK
	 ULvQIv5FoWsVzI/7yaErAsNDx5y6f42kHfcfbFl5O1R0aNB+85auducp1nN4iBTs2b
	 LbD/9QDiZeI6JTobHnDWzHTbxLRKxnpQ3qRQixK9kAHMdJTTgKM2c4JyC5xU23P5Ry
	 z6vXsLMKlnSMciuH9cQCyiRVW349zJR075vNNano7TxUbhS+po9zV5lfJMRHZzrAMF
	 h/xtHRrlxCQ9LvyO9xE/FX29RlcQWnAMkEsdQxVAAWkmXGv/vNBmTAkdNdhl+0cUew
	 qGmuQf3YFmuiA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BA07D479B4;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:15 -0800
Subject: [PATCH RFC v3 41/88] KVM: guest_memfd: Allow attaching PFN-backed
 providers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-41-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4433;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Zyei1BsCtk1SKBl4SzbsXS5lXr+1x+5G2OuzpP6di+4=;
 b=5boitYkkCw52klJJrXhH/jnyR3Ns54W1YY+lNGd0RYbvbVCX0Kz6fAJI1mx39EqN/pgBUwFAP
 mYtcc7lB6lgB2ZqDJNxeET7odVTl6gVkAsT/2Te9XBbMqdo690wRtvz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D6F880004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5t6hbjfs7ij8npt7jjbr6a6yqd31r7it
X-Rspam-User: 
X-HE-Tag: 1794011829-334973
X-HE-Meta: U2FsdGVkX18+5PpVBH7sXBmj7x/3ac65B/2GMqNeKRugizarLIpSukjkowBFzD6YaJOx7eFbfSo5CEWyiKEyx8QTNSlr0NoakcXWvkC9xkTgNtVD1a1g6t7zyjiRnZX1fVpCijNDxEe32mWe6Oe35sOfk/g9C45GYdVPgJsarqcs6NhnAKuM/XIw3wkfQpMkXyX99EEiRxc4YxUuA7jdlR7K2GUwu1G+Ad4NBF7W+oui0QVDp/UVWepffTsfzHQj6noIkRtOhOX8hnceZDfJlq56xD4tDuKNYjNbB7RCdQSU4fEVwKCX0/lct+fqoAHu1zVJVDutrqMpyobD/WKeIsDwCSoclrwYzJyQHwQDp99bshcsaCmR4maAjH6pRP5szj1ggvbwVqUzVZFhOD5sGDXYmQjLmMHLm23aAY7qhmcTe/7J4iCwAoSGAFealMjfG/+TtvV5wstq8wSyAqKMF+1jld13HF+2Fawaup4eaIieDdT7xdrPsflZ3WU6j0BjXtS+1la9Pph7LDNDZ2sWiXogv94UWMdf+KVBo+SWffCC1oH/05rGaVQTZ5YLTn0tBTRLPmT9UIg8EvxELhCLAtac7X8mIdcGpAfxNQ4OdYgGoNH0m6S+vrDg42Of1VOl6oyYEtAZ6vl8LQxXX+l3tDS9sllqE4GWSs98dBI2MB90I4OPH918CnENgmFEed/4EMcwH+sTWsar+Z5y4r7vhdk5KcL2XDgJjuKiybLbPfu+Zq0Glj3bVRu/DHtQveNxkV2v7lVy8Ufge1/SpkW2JjBikYgItgI1mSBHNZoSEvHskRpsw6Z2JHnqRZ5lEUqsICqNLHnVS366Zd9XoqwuALRRhJZNBeo5VAzjAxywA6VuoeaG6XSVVqrPAViccm9+kvNuQ0E44Hu7SXaHAFmTm0+Z+sm+pQzavQBXoEsCyAtjujaM44E4QQbFnMNScGwa849vtGD9j9YetRfmL3C
 oahHTt+Q
 NnxYbIlghOoymE7FUH6nU1IMcMpWCIuQaTXj+N7h379oaSPIIwlvhwyeBimIb0rJzuEg3GNisCj3Pjbd+ECA20kLDq0c5tiXAiRF4HboF0S971awOEmTtThIYfA/AP1ZlqsJvs0CZthiEqVqSw21I55NRpN3cfxE78tPRsDk7PwIxhTpx/yp604UpnWwHYywEY1NzNRQRm6pZ4n4V603rY4UCYoIiwzBn12gIABiRKB9uyTeHAU1+cW6lZ3C0B8tfu/MevBHTZtPqqJVT9lU4K4Rg6dO0GCtcbW9Vhk5l3IFHfJT6DE9cG+90q6iqS8N7OL/QWgfGYt7wxTQKaV6LKMWBBDuGFThHw861/AUL5iJFz2JrrGHJ6foQKfYgU5HkE38tqnfDCmhe1kyvi71W+yCLbzj79jx31XoxIVqjjsvpzIWTZ0TVnG9r+hX4QK6RjPcbCJg6gnNWNIjYrcCIk+qSUoUK/eLvs+huDGg0iEwYkLrudvPsZc0dMXjqPlqk3YZFjtmcAhxharz4ZHTJ4UP7/j2ig0XzuhbwZKHMeRR1r9aCrXcKL8+90bKtf3R0HSyeG5czTJ/WWO0ugIK08Al9p2BH2qVqnV5QrDeBu0aHzLQ=
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
index cf679efcf3260..980ce85cf7239 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2619,7 +2619,8 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
-	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE;
+	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_RESOURCE |
+		    GUEST_MEMFD_FLAG_PFN_MODE;
 
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffe1508985d61..1b6fc44ba00bb 100644
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
@@ -1350,6 +1362,10 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
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
2.56.0.455.g6c5a503b38-goog



