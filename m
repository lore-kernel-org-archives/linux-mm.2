Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF374C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22CB6B008A; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA6A6B0095; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B346B008C; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 834E96B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA647A03B1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
X-FDA: 85159670484.23.420AB11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8672140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g1VwRCOy;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SK6GhAjcrm+XxsrEs3w3dX7JSKb0VXzPJEqnIgTcNs=;
	b=UhxStE2Re1PHSY4NTN+IF52K3+sU1wMv9M2QOaHALX+rqsJpM5U3UMHvfdj58/cn/swcyp
	LA2LODjf1zFM515uUP4UYEz+whvpQ1wr/dHcBvMHXdP+j0RClVLS+z+WvQf/od1ha1QDvV
	8bZiCafAVFkayiG3mLmMtaLrTQqNDPY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g1VwRCOy;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135921;
	b=115Upgp0j4/DrNxxficj0LLYlSY3Z7tuQN2Q2tK8qcBDRVaF5blT5tQw9LTEnbPAlEqbTY
	ecAWtWjyvLXuBbxtIMBZatFyMF8ejjJ73pQLVIs5rz8bKWuqCxhZsKPsdj73TACHkE8aPK
	QvXUKlScMGPVaJVsiDhyjLHOS0/qfLs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF13943F0A;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C899C2BCFB;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135919;
	bh=3RDuReZQPdnpDhEdbvLR7X6xqKa7H4GlqlpiAhWp0p8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g1VwRCOyedOtGxbdxTdegr8DDWZU6VvjQ3ogxdfRCgtIocveYdghE/0OQCDWp6XZ6
	 rJaKhYTt3GLN2DGn+6EydXUuVUTpRjIdTePNulx7JT01OmNMIdkH3oo5nLuvMW87Is
	 t65Y8a9defMIL0Y50tVPo7s+NIamuBk5pTPUd9C4AVX4XaZG9RJqTy0XdfoKk2LEgY
	 0/89NCMEfqpDZ0EgtTqrfIfuJEfrsPDMVpainkPKbpxxp1eSW3jh4noJIc2WV7R7FD
	 58/j4PMMkF5Skpcj3CRZRR3q68JjBJJVWJ4AGEApPOUfPVRFGqHTDVPWu67OjBEWfE
	 FzaA04lPYtGag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5981FC61DE2;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:02 -0700
Subject: [PATCH v12 01/45] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=3210;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KU5lBT3XbWircUdxqmS0fnCYMooY3DNtiddyAdBDhH4=;
 b=wRmS6WFV25eBLlkWhcNyTW8umJE+UPeg3uo0+Q/XM+JU1xnLi6JSPz7bg3Lq5iuNlI20eGVdN
 DspTez7dVYLAdbPlQJTf6Vo6/pxxxjuYSdhZdAGOK71ZI1A0hl3fCXc
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: zoskhf473aiqu3jgdcfrpwor6pb41xe1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8672140003
X-Rspam-User: 
X-HE-Tag: 1788135920-640825
X-HE-Meta: U2FsdGVkX1/5kPjFuss0nS35dgwOj7R9b4bGHwmnBwfHZFkKgcC63ultqiUvylBUEQpFwf1dhZ5x2Df1RpYbBGPSQlO8asuVXp0jdjfNTbvIAiKVqXqylTLxPYf9OUG5TgN/Hv2SYA8OTRXfuRPMiJ0xcbz5y7de+llyJ8AsXFcyZHp3ShMhRhTtPOedCc2x4EOPPDtKMBzXXSBG3CGgX2yEw0zcfbX4F+IMwVqO5o0kOyaGoLL1bvuPLMozxkZcqlNKHMPFF+MxjWcK1L6NPP0uL9HJ5Cd6v42YlodaRP5SXCX/RHuB5wB0k9EDhJ7A9B6haP4JOEJkJMLuVNPj94juI+TCTd/jkpOja45d+Pw14ZFJt67jEgpdS7oBzpiO+WJPdIjrthyigGYoOoKyEBOmapXZot3UEXorGClI/ShrvgIBiLJYwGOb+T/6eO6Kl10fH36swIoscO+MxIozySErVQFxu1xDElHHO5eOnR7RfJgpb2jZEq2c3Bh/WSNQc8WNWUXQyjalOEEa/oDEE66jtz/enF57rX0gZVqXkhxcsW5X4APF4jnTXAIa7B8aDsKBVnzU3TJjhzwooFc6y1PtuzJToS2U2E6KFSltBIjzE97gfNUrnyERc93Q4eQxD1KoQ9Wyjboy84iivvz4ewrmLIjtRtoF8YQGMa3aVuv5gGCkDXR0hBLrmtYBix8smXmpCZh8e5CLH0qXFD5maSadOEQKQ5OeLKz5a1iNniM0tHne1QX7gCTMH3tnkIPBrJCNBeSsurr62rr0phisFYLZxm0pTmeedr59u4gjs2x591Bj/99GnU/jhl0E0b3UIN5ucF4fkIIoCM/AVrkMzhZpuAciTDW88iW8ryVLRq138g5m4H5xj9vIuKKgu/NGpcV/5/ZMd5n0pVi/VreHYSoOy0u5VlRRh5+f5YkAHiUKsOpSV9Eep3qYMqWWaOE4LYq/CY2O+hOKRi+gWzs
 991Zy7BW
 R0tJVgIoYXX3XPjqCjBqgogoeT47vxjUG5yTvC879wH4udxmmPl0m2+aBkRTvsGahy6IwUo8SeI7er9fOJXMslk8qFCh5QpBY365eeKE/lXNq8gC9gV19liCqnRhYYOQLvBQC6yOMoqeuXPtEBgi8vgLR4GdaQ9o63/H4b43Z243cvRlAOMoBUF0c+kkxJHYSByrZGcNXoM/BoW6KHURGgz10beRp54cOQ7E2e73tu6sXMlUDYcpGFZgeW+DUs6SFj3Tq68rGt7TMEFSvmIqOMLnijBEijlrm0zaBdr80SbVAX6I/6oDtTU18VbdYjRZGmiH7QjfOEnURxQRAR8XUEF1O5Br3hQhr02Yf5gRru3drJdk05OOeaM//nzuQS8/MjfgDeHHE9ikMHIdzXO13+495jvtKwWTHn/Bv7sdw0Y+57zAESkzkAGGHH1VS9H8xzw2EMxwxqRDAS/pv3p2WTqtjMYyKMuRz0GMy2Qp3JCoJjh2hah8bBKHHUolakFjEyeXT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
of arch hooks related to converting memory between private and shared, as
only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
pure overhead for TDX).  At this exact moment, the overhead is negligible,
but that will change when in-place conversion comes along, at which point
to-shared conversions will "need" to find all affected folios prior to
calling into arch code.  In quotes because very technically that work could
be pushed to arch code, but that would bleed guest_memfd details into arch
code and would be far worse than adding yet another kvm_arch_has... hook.

Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
rely on dead-code elimination to eliminate the call to non-existent code
when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 include/linux/kvm_host.h        | 3 ++-
 virt/kvm/guest_memfd.c          | 5 ++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 683bb8bf43a94..6beddd8a0c749 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,6 +1854,9 @@ enum kvm_intr_type {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
+#endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 502465119ca0c..b7516e19ef419 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2597,9 +2597,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() false
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 798d91df69537..2190e4d6b6bea 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -772,11 +772,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-	if (kvm_gmem_is_private_mem(file_inode(file), index))
+	if (kvm_arch_has_gmem_convert() &&
+	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
-#endif
 
 	folio_unlock(folio);
 	folio_put(folio);

-- 
2.55.0.897.gb25b4bd76c-goog



