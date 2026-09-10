Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24807C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271306B00B8; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6AB6B00BB; Thu, 10 Sep 2026 19:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E775C6B00B8; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49C66B00B9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 083EF1405DA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:45 +0000 (UTC)
X-FDA: 85199512650.25.7495411
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 078E740004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3WFyrqF;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084543;
	b=mCojI+tNWoD+i2jP2pMBg7bm71Zz4XZjBw/f5t99UJP6aeCN35HJSdhguHkQKGubF00m3m
	ISmXleS3PX1tf5eioYvrkzeL2haNm9WbjeAi4Y4UznuzhGHIwHFVBUUmm0FSjdLl7uwlAY
	jPLdbY1wrZH6oMR+FQWVhS0yJ+tPt1c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3WFyrqF;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084543;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uelba80KDbGS0Q/yL8lt3XYUXYLg7qLFdiJHtbqGddI=;
	b=gO0IANB3OX58stlKrUknLjNxLXpn3XNPgBPTjOcoJlf4yAuqSHvVDvXCrlOQAaUb3esxLO
	iL0K5um8t7xCJQ0cC2aD1b1IQXdDAOV5g854iSNBAhkMemUvHoOSyUZtf3xAWIk8PaXzJf
	wHlSEnb/RK2jhRu0H2mL4WivXUoe75A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05469444FB;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C384BC2BD01;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=hbL6e23MivHLBA3qI7N5pZhF/az0b2+KjLphjqv8C2Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R3WFyrqFl2ZYfuq+yD55mnCIeB8PXqRnHUgHh5wdk7BIr6jGaOSuM23rociOxQ7nZ
	 jtkTbvfFMrthxJylX9JYiTk5QMqaGBMUQ/DZEUCDprOYLeE5YG0X8ajj+GiGazWr7J
	 oVzq7YHAZ8YYjyWwKj21luUw8NYjqVS7LcOM+bMUhh0r68QZ6eiOYLD39vdZquKd6C
	 7cbnQOOamqrQOIXAIh7LwsOuNnTtyTqXFu2yjrLONY2idBvMkgViWT2QyoTncjS4vi
	 Tfp+rHwn3KPr3BuDJJtYZ0HqszOkmIxwfvmOUOmX5OxyVkHOXOSS0SIqXFjc+4FHhI
	 pDMX/DEWavswQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA185C88E41;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:38 -0700
Subject: [PATCH v13 12/44] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-12-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=4606;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+WBdIWJC64hu8Hv2GEhpz7fsUgnbUjGHHH+Q9r+ACN4=;
 b=usjQGlypHSjCPwZTCoDIDlRGkN0v482L+z0wWA2+6lIPU5dTk9O03KS69230OC8njTRx9lUiY
 SH18HCX0W2IBGpCWM1wMQF93AhSh1p1qfzD7ctVmGfFjWTIhYMsV8lK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 078E740004
X-Stat-Signature: jxx86rp8urdjx67y31er3wwj9ibmp4zt
X-HE-Tag: 1789084542-927184
X-HE-Meta: U2FsdGVkX198XCTiz8RPo7cNvXTD3dPz1qGYc6JfzO5ha0x0QlY4NJuuoT1ufy4TiQxrkMvnHGr15F8np3GCZiaIV8tiul7fg9eYhVZfzAVh0FaZZCCpBbT+l7+r5buhnR/79jhdhyf802V7T+VsEKjaA075/mNkFZcznerzZu9z7VtrlrDP5jOiFPfz0jrzGD7lfTN6A3OVmHQSUuUQAq86qzmpn+TyosfrNn+HNU8JkCd1+0PcOThTAwI3C3kXNFFG93NxIV8Z/4rtmZLGG/bNExxQUpG5YbZkYjoxpjQ78+3rAJvMF8NxP1l8YPhmcMVodfjrUoSP8NGDnsgV5U27+r1F3E6tXHYv9xTI4xC6P76KvxtFzls00sWHFhsiba3aA3PrleAkA/U6N2QF32CqH1DPiscasRqCGjORH8pyUqiYj0fsqnY9sUy12iANIHYhZ6kZwdKCyHfY0+HtRDB7IzWAB3gyR28qxX/REYa1Qgf8GaOqgjsrprDlA7T3+QOVpk3S5d2/oOgtgN5czQwtaWrTPfSViS7Y0QKXZHE68ob39X3/9BhUPGeCSCXLDDwE91nVXpCGrh9wPu8oyG+N4Q1l/ezBIT+e619t6JWM13j0jpCFrNL0ZPpbYZto+PngCingC5wDCLQAAPkuT5UtAaqj6qd3I9npptJRlWw6eg+q7v2XsnUz652Kl8sPwM5F96s9GfTbVdOWrvgzvKgRvqW/xmdzs7T5PBdYh7R5aPmP/R2apBwjt3J3u+4pgO5rwOKRzZjX88VkFb0CnbHKNTLciKqyrHwmJ00mVrOkD2iia+oRcWZwJLn8/8t/DfNlZMs5+d8BYjJed9YnXrKNNeKTFPbZTFYjARmRsT2EGxH4Kp19EDgZ2AI7SAxiWlles/nDRhTYl6f0qAblrNbSG38ZAp/AI0rAPlBfHx3DzMUeR4/+2XfaVIc4ZVipLFHDkbqCqs90e497y9A
 jqDEJviv
 1dZwDoMklrhGuJEMiJrFPy9UfTulUZdP8DVxh7d7WhQIHHKvQGmk5ieiEHfJTl3ZchrAIUqmYieVOL4GOr/l5k16MLWRounb7E75xpJG3BYC6mNosCSKIBApjy2nMG0HQujS/PHaM3CB/RLdB+cQprE26mX+Qxzv0ouFo3wQ4xN266XgpxfSLtvzclF1N0jB12UzjMjmcQRG1Ia16TA3Nl5QFihwEsjfUpSsrWI+F/+Rba8jiAlZUF8ZQEAfWi/jAGofsHdY9mtt8izkiCXRaUzEageixjIKEhYM+sAUk1r/IB87AYF4+ZWAma6QclRSUbAAgf6TiNGs27LAp+NgXsZSCvtfD/g9PA0d0luWajyVveVcBwe+A7FwmjSoLp+ab5iLeQ0Fvrb3HDJT78a1TEmmpwqlCqqePu+nuSBK2PKCQTuSd5G81CPZU2REsZ5rACPcY9ZAGlab7GHqKsMtCaP1FjLgxmYs2QnBTmgq0fvS0RQbCv86MNvbtHIafhVwpz8dmISkpb8wrLQ4=
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/virt/kvm/api.rst | 22 ++++++++++++++--------
 virt/kvm/guest_memfd.c         |  2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 09967e0308031..35d94c51cc56a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6381,10 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
 KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
 on-demand.
 
-When mapping a gfn into the guest, KVM selects shared vs. private, i.e. consumes
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
 
 If in-place conversion is disabled, KVM selects shared vs. private based on the
 gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE state.  At VM creation time, all memory is
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
2.55.0.1007.g17ff1f9808-goog



