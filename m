Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA6CCD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94AC6B00AB; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B176B00AD; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9036B00AF; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848576B00AB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D436E1A02E6
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
X-FDA: 84894784632.11.C09F5FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA087140002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiXcLSdQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svgoloiggqvvmX5cWO/Lngldnh6WI7BEDvHPnzh6H9k=;
	b=U1EBpZlPYXhigqnWYSf8Q8eGRskeH+7AD4Wo9VUiv5o3blkEPI5p/+LTtt4+eBHMqusef8
	yQkZHvnfnL8Oo7Z3xtNk0VVylnECkEgWSwYxAHmTYnbJ3ei7I3j/yT1Y8ZFQ7pJa1ys/nA
	VTAaJ2iY5Ai2l1uwhTZP+iI2VFDP72w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiXcLSdQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829114;
	b=1tiibsGbYM9DmZJwAEdiw4A6r/OJIr51GjsoLMTa13cQVt8rd/3v1vgRq6xR0eKkGKRp9e
	dNKXfB2U5w90aWbra44wzk0SI2Y0uTYNfGGpEJPQmuURX3KnxZMO/XXBbXLljvZBDz5t8N
	apolJThwYZ0gwiLlDZhtgVCxD7J61cM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 957D244694;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55A88C2BCC7;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=77tno+1BEzOBJ5VyiPmvluDUJLKSOaYf+ccqqrV2opE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jiXcLSdQVJ5yO4ecfWTvDsnDGky5JHVZcLf3y5slRlbHhD2/VGTRFoT8hPXhodcwM
	 fYPLFIF72Y6W7m37/DQiD4xR+Kj/VIGnp08F9Awxk+oN/T7WS6irTQv84K4Ngn9y7L
	 DZp0aDz1fBzQ8Xi2phYIhUN6YzuGfFvcj5j8eO8znmoJcAR6FGMM6FQ9ALCKnoQfe1
	 y3oUws0G8Smc5A9hX3iFwhbl+fspjJRmoOgkFzfzeQdfZ58ks/K9Y283WILEJtmIjs
	 VzbcYzy0+EZ9/5k6IrepB+w1FbZtebPMMfbaiBe/xJ3Fx2zpnKofg6WPX8QnLNk2ec
	 zJ+mOk3sk3gcg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410CDCD98FA;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:53 -0700
Subject: [PATCH v8 16/46] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-16-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2581;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XtB3xaNYZoGgLjv/gUxy02ochDW78D95+vPEFAYFilQ=;
 b=8DN2flcUdZvH8IsUjtTwKQwrPHe3JRoPhgMeWB3OXFnqBo/oCJQj5p5x5PXtVI47Jk7xP3NoS
 AvdvXpAVzJeBJFJ3PPfPlZOPbVNtUoRPW7WV6NpG4Zt7fl73nxNK7BC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA087140002
X-Stat-Signature: bemxr3x7isd3ymw3xd9rsjwk58awc9qu
X-HE-Tag: 1781829114-766359
X-HE-Meta: U2FsdGVkX19UFkdTQA9VurzqZZCkheQbXcQlPwhTiq6jWJXVmSlqV4mH2W4biZM8Rtt/ukUQZhM5FCFlnGFiGliiFLkkn8ChWVdniihS/ch8vY4p39g4gzl52o8MINPymerFeMp2UnL0q9IFCO/3LmBmaU/MwkeSz97j7lvf6dsXU1XPzTleRnPNi2P0aZVK/x2SdUh+wrNMeMG8LVQxicoSEF5f+dThtKT0/VDM7NNarknOEBdRzcSmTNPnQjSmOUWDCgHrc9OkSUgL3d6gAX0OgEMqfC94foquzvEaxdgeAGthofeQay2Mlhx4T2lvnB0gjznPMWTcxNv21U3kFbgoeau3MlaY4DgxAvPg6PaRbqi5KRYqz01SR+teJ7SnFwxv8DExsZOVlahrpu+yIAtXz9jaaaj1a9wQk9d9mSnUbzclPccN0KOwNnx26pJBTSg/0m8QhEsgrI4Ez6KDor7blvd5+3K9PBa6UMTREx9xjU2jfaHj+bVqdHTeQNI2ODtnwqAGye86B+zOxzaSGpWOj0cVwbGaT7vDjBwGbdHz2q9LPv/nSqjyLli0xhQ6eQvANUjl/qfNCApwDz6wXSu4ce6BDDXOAJD48xL1K/lC2sq/s2UqbHx2mrzx8DgPuiv6XTFALf02OVv9aSRBxidt93ODqnHnCFNUH9Nrglch1Xw1IN0uxkH7LI2MGWVSJ6edS/743U5huUWZJ3p4gJWHwMWnx1Ba7v5FhkwEcgqUh8J5RxZgNeUAhSHroRzxQgvrDs3HT44/xmk0K9fhYvJBRTJrcLOZp9tJoVVgtwBVVVhAxJ+BLOcdp31eOf6VWV4U3Vere8ljdNCOh31MEyC68aA1qQ6kN9cTXM9PxJ2qFPBRzrCH73akFhgLqu7a35fdi01BLxNXM8fFqyb+AC445nI3BmHRUubCvNJnyh/xQFQnyECyl/GSHc8au2QlDgDKynSQapBu580yQyA
 c5I8LkVg
 EcvYwo1bKrmozCFs7UFq8MUdWQd4FRKgFYjn5wecNL3rzT1LSvz72XIbHFW73r5kU4Dj2OVRwcxdI046L3T0n32Y/acumRBJOuqtmDeQvGx3yQEdtLlF3+VNqVzL5EUIqee8mDWocmyk2HY0dRhrT18kuoNm6j1QgINar9SVYWG+1aIa2DkNr9FrntvmyrWTzh23QyB3j+xtsAVdKL4vryNIdVrB0cfNsbdruoZEmU+Msl7/ZPje8dEDoUVeJhyw/oznVqYr2Y9cW69VuhWm4Gp6jpuS9x5OhgH2SP8hCBQ8zZfrlnAbWdR6CNRlKTXdjmRb3S0nH7eTpSREnyGr4CRhu9GUA7EQfWsnp2Y2Y0jWWTwGlONbihgVkF75XG90Esd7j/2H5Hi9Bue4BCLArO7D+fL9OP2lPgEy0dlAxEaHPJsXn/3ic+r4n/cYE28Nc2dmqFY8jeRCV3VWThdWYkmoFw0MNUjkZBP82w07YIvZE2a1NRo0h9lsuDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Extract a helper out of kvm_gmem_range_is_private() that checks that a
range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already has the requested attributes.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3c94442bc8131..cec8fa26ece17 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -86,6 +86,23 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -653,12 +670,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {
@@ -1148,19 +1168,14 @@ static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
 	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
 
 	if (!gmem_in_place_conversion)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(mt, entry, index, end) {
-		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-	return true;
+	return kvm_gmem_range_has_attributes(mt, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



