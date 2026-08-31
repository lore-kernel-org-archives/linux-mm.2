Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE82AC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D49A6B00A3; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC716B00A4; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A686B00A5; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166D16B00A3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A44A71A03C3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
X-FDA: 85159670694.02.EED2D46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9CD920003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZSTa6ni;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135925;
	b=JIJ6iTJ5O68AiNum7zsazoiKPNEySyIPA8lQ18UlkZQNAc2ECoHFGCIegdCvVx812iXzZG
	mLnKDxRNa8rze2RQISXmjPE82iaAQ/RIeppavmyTeq2rsipa9ICYgmbel68R31+vc1oE2M
	ytOvPBSKdq2jGPIAfm21Sq1FRoivDNA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZSTa6ni;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135925;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZDwRpFSN9wtTWb7St9CiwwoCHPp6Uf4ZMT0TIjklsI=;
	b=y24nS1TqgbaP9AlEOaPxVk50glBHrLF+e37klT8rfaaOrV7MMCMRb2CH0Xp9FYHSRaXefz
	WJG3AUwbWdu9/LTGbpgvGVJLIJj9j2wgOtYaglLtqAjDOqrMo4k+EUnE5aWfVuPaUsfaxT
	P3uGcDlNnBqPDSNIox9QSnODrz70Y3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 059F3447CD;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7FE1C4AF50;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135920;
	bh=pgbQeqwV6IRb5CiPCfNQynStgiWTbolys+BVEEK4H2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mZSTa6ni/SkaGctJC95sGPqw7Ik2tnPRymeXDDfMOLYPN72DoTj7xjt+asjczUfcc
	 bppappQ9c9LUoY9EIPrTqJttmF6zojfgB2nzktvtf8rApIZv0SvZfihCbDJ7S2JB+U
	 d2/XrY+rsOxIGTJBaYDtZG5LP6cIBB2pJ2qRa9UKxdruov3qKzP8mQef1N6WDnGvJq
	 iquSBeuh+UxlIfCqyP9i9gNWfg2YJ2L3PtnNIH5ztsr+EKIfJsKR1SAlgX64MCzz1y
	 Lj7ej/FBYV/ydqd5HKGBSe1XV3FH0KVEHGF0Fta3/DEHiovgEKvHNC77PH9HmfRubV
	 e6ronKXVy4p8g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971A0C61DFF;
	Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:13 -0700
Subject: [PATCH v12 12/45] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=4450;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=X0oHuYGMuEMc+mIS2D25NifHLJhyfzoCyNVUkFKAoCE=;
 b=EtQxw+QEVWJoZlS70xZzAwu5ZPYmJaQfBkoC/h5utIHwFISWqanhlhfA/RfJ33NDQYkw7Y4kT
 x0KHakJQKe3CW/InZ0fVH/Fv/TtLlWGt56gk9mRZgklUQUp8zSa/3yP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9CD920003
X-Stat-Signature: 7fm41s4hfryxs7h1aa48gpae763j539w
X-HE-Tag: 1788135925-203517
X-HE-Meta: U2FsdGVkX1/RA1q3f/4XXj+Nkl03wfY+YMPKc2NDztNrGt8sdpdhtTwBkjCtGB7Fig9ce9A6dO6q3GtkjGn7yPGODyTtl+dXaGCysLKxzHxsSEAOIemmaY4uwz0ZdevbgBBNj5iMlfRprB+3iNSBI+SwzicI4kFPowZlfBG78DlBbSuGwSaip/+a1zh2j3U2qFT56Bh+900zMoHKyrobRx74VzkE6UlsV9XjIL9pVNNL53MgoQaeQwnV/Hynx0CZe8j6lUyRKS3gBqCLBw9GnjH/5eiITYp0CDcxFOAfDuzdc++J4wGIdDBpwxJLvvXQWYoD3iK6xwc08PNG+viq1swuNu7z8tPhqpeZHktjKkMYR8xWEazZ0vUUG49ZJJgouBeMU7jUmN9knR32JsOPmbBNEpIjFo+mg3ZHlWWtAv+5t4ndceB8+xNQXWHQ5IVVmjWGontBaix7ElLRhq2pLdL6eaET7C8/Ab8SDdqpnpccUclICEuoI1eCbzGepTTLuS43eN1TIeN/MMI1tdVhNhuBYVdWdb5UhCANjBCfMTuCpymZTRv4pyzA4m47uEH3Fk1L1EOGBfLiw2so9Xe5ZKSueom2DMpIGevnEQjMl/QoRLUHbzQjfyiYLYRHnD0rewhHTJALYsbVB1XnJWCUN1gfk45tipr0QKFl7uVUexdZMPmqIjXF06RzRc9Uz30S8+SQamUohd6/fDG6R3vMuAh77NomLr24bV88sVz6hnvn87epWLWNRRLdtyDmJnyNo4MaxI/bHkQHqaQZF4TKYebBcY83IgviCQXcmE0Duf4ws7cahoCGz40Roq98rpWb8Uk+Xzk/i9G9eJzMHw8/jaue4nncYQH+xGeg8bCT14+cgygIQ2tuei2Uwm/ctEOYZg6mglX+14S37fWSvAAO0bPHMWYY9jyLsLvGUNNgNIG+4QWnjmrFaD8AM24039dyHXpKeEzk8a1A6SJPzN4
 t2kTMgV9
 UNcd2HHCyQ3+oy9S+Lzyi0G28BSdIW33DoGX1EAZ4adSnlzB4x+1nocH/IdAypRsTyaYEZxhtLhwnI2TWGP1RFi7ImVk2GoWaUr4PA0az/vthZIif9FM9nC5zdhEEu38zo7yMUaBaN2cu9Uzh9iSPlcPC94OzEMAHzpwb7208K5FGuRq0Tk1cradp44Z/OWtMYESD2Ml0/B16rjTxKxqzo2kkFmjnJfIJfPjSKvvpzMutvJ311svBhktAMK4rXaSxKzS6Ka+1iXuvA7DvNt3e9uoZsaAb0R1rBPbYHxOPafa8GrmkLraM3veV1iljQ/5jTnU1KlGNSKBDzaVR/l/4ekOIeJTwEuE8qv7gamrSBtIfH+rSBlgdruRyjIXfJkgVx3zdIkc35kJRPSXq6YnUoGR7yELcf55HHU16EIjA6b4qMGU8ujpFwsP8g3/hSxxqlVxz5Bhrgp5Ne3JggkAX72FB2q9XrXXkFLQ2RkmbM/GPwFDjgA1cLZ0lPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

If a guest_memfd memslot is created but the guest_memfd does not have the
GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
memslot's userspace_addr.

Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
guest_memfd's memory will be used for both shared and private memory. With
in-place conversion, guest_memfd will be the only backing memory for the
memslot.

No validation is performed to require userspace_addr to be a mapping from
the associated guest_memfd because even after validation, userspace is free
to remap something else at the provided userspace_addr.

userspace_addr will still be used by functions like kvm_read_guest(), and
if userspace_addr does not match up with the corresponding memory in the
memslot's guest_memfd (whether userspace_addr points to the wrong offset or
some non-guest_memfd memory, etc), that is a user error.

Requiring both shared and private memory to come from the only associated
guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
operation on a guest_memfd, the invalidation is now guaranteed to be
invalidating only memory mapped from the given guest_memfd.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 22 ++++++++++++++--------
 virt/kvm/guest_memfd.c         |  2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 90a29424c54c8..668886f50024d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6381,10 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
 KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
 on-demand.
 
-When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
-userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
-sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
-to find out more about the creation-time shared/private status.
+When mapping a gfn into the guest, guest faults are always serviced from
+guest_memfd regardless of whether memory is shared or private.  KVM determines
+shared vs. private based on the state in guest_memfd, which is the sole
+authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD` to
+find out more about the creation-time shared/private status.
+
+userspace_addr is expected to be the mmap()-ed address corresponding to the
+right offset within the guest_memfd. Any mismatch between userspace_addr and
+guest_memfd is not validated and is a user error. userspace_addr is only used
+for host-side guest accesses such as kvm_read_guest().
 
 If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
 userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
@@ -6490,10 +6496,10 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
                                page tables. Private memory cannot.
   ============================ ================================================
 
-When the KVM MMU performs a PFN lookup to service a guest fault and the backing
-guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
-consumed from guest_memfd, regardless of whether it is a shared or a private
-fault.
+When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
+always be consumed from guest_memfd, regardless of whether it is a shared or a
+private fault (unless in-place conversion is disabled and the backing
+guest_memfd does not have the GUEST_MEMFD_FLAG_MMAP flag set).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0afe1468d2d9d..e41802944756b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -746,7 +746,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
-	if (kvm_gmem_supports_mmap(inode))
+	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);

-- 
2.55.0.897.gb25b4bd76c-goog



