Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BBACD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F088C6B009D; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFDD6B009E; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D596C6B009F; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA4176B009D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A240C186D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
X-FDA: 84894784464.14.EE54CF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 13ABE140007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3SanR0Q;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2A+WBOunH4vpi7oXfhRY9rvYRhJZCayAEWeEUI21tc=;
	b=Hd3PiJNQGzNGaIlYNi4NSHhgp73Ys0WTYUbtufgXbLh+WnJoqIm/FY8Nj3NBA2PXcEaHNP
	ii1NSi6O2/M1L8i+Mpt5qSjU8uAwl7aarDGHrYJmoy09z4Ey4TTrrUqsAKleeK0Si1Ok7B
	zZbkNw0DsRo/KyCk8m58OZIkmWiKQSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829110;
	b=ax9hv9l6aNRSLPYbNrbgVHHAhyulT0t5NEXR06dQOTijremqrYtWeAsBtNv1tagMrZ0Z2j
	tc4H58g2q5g5cLg2fDMUQEIa/m9te7xjaQn2Bi/uRgV89y3QX/YNBrNTJQbAmstMTxiVvf
	2u7Gg5NggftjisbBjFb0FQisyQevuUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3SanR0Q;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 312B1601F3;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBBBDC2BCF6;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=evWNadeDhazc6f/ZM29RD4T7kjpvn8rDxzt9AVZdSsw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s3SanR0Q8LMaIkXKGMwNZJ1Mms3kk75IOnz+mkjFDzXcJ11uflQhvFJ3jEPH8SfzA
	 xtbSigirDWIiyVZEex5ZCQhSu4ltLiE1yVQXVTc+a3wYKEUsEbN+fthU8dSwgGQhF/
	 iBVErY47d5S9UqKceBn8y+QapQz6/Yg8fqzh9h7pA+KtnEKcwKQy4Fk65YsPHFNCtZ
	 Nm+UNfxLdm8u3ROI55gfp32M9aB9ZwD/AnXtEy7Sczjyt8CDkJJehEWvZBUzi3zMsK
	 L+axCL6ZC+EQr0MzmaXd1V0EF3fMAxBgVn43CQrqfyzGYy4P5hPMnxd2EH46XnBF7q
	 JY8NB3pmg/FZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBAECD98FA;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:57 -0700
Subject: [PATCH v8 20/46] KVM: guest_memfd: Determine invalidation filter
 from memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-20-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3547;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JFkMjbYYCjSDV01aUNFW6wbludDPAnrpthRKdegpfv0=;
 b=OO4uXerpwNkGX3lnED+sA8fbddORaRefcBZq+K5H30vPr37IqGGBiflXfk8zkfYYDva7oT3VB
 V1K1UrXO5s7D20uK+h5EDSnG88asfABca4vnzhbP39lxOPh6nQaUoHn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13ABE140007
X-Rspam-User: 
X-Stat-Signature: aerx1daro498acax9f3qast3be8ah15b
X-HE-Tag: 1781829109-887157
X-HE-Meta: U2FsdGVkX1+kxUx/kMlJtOmmGyAZIm+d/0/0lRq9Tyjpm8ksv0QcAO/dYZ3i/VXyh4Ps8S4CEe78ScqBmdrsr1aGCBln5gG7hbzMzUxpM+6ci68DpUaiXNNjbadYqns3xEGPsXKUNwk8vWAAasbtttPTuSfrlBNdUPODC1Xx6DuDWg+hCMQ+tSLk70rW8XZRvBsV3rMx3n5oQXFL/+DgTTVpro/FOWPcLlj4PitDChboHtciFZmLcWgjVC6WqYlAEoyXuF671piRNe/EYBi+mC9vLL/LeF1iatRhEgkJvYuImKN27F8HN3zKHoKYkYoTaRciaoh2L3yFQXJVidSKuPTMAuAXA/o40AHXz4b4OADtXf6FChBBkEEYOk5DWqQ/ZVMSGYv530ZBAsWU9kwnTTWxRNsPpXVxEJwrVeXR3IUc9K0jw+kUSqWMXA/36DwGL6BI6n/Y3b6JjlaWxClJ896ko9PV2rzH5UjDdJIgfI1JshqN+wPiDsFWUKn8mMakik5MIWSOln3m4IDpnxV38ptBYt7pGp8va4y0t9e79zmQ396KAI/yKd/lTPv9OjiSGcXKW7bYEbjBzrFBDKFuK+xQbNuONXg0XpkXFMz3+3PMf5i3xUUrMJLAs/oOcmb/fX9r7ATdXQgAD/dFUFjILMTRz0ac9knJ6YkEz0SB9kZd6GmgdU+QLhzOOLMYNiu9y9AY01MLYX8XRT6mhUUklh0kUwi0tk3jTEbebhMcLHrQV7OBNO1LsTNfqsWaf3W5bGeldt8VUZauHkAO+Q07IMOlv3oIn1rEEW6kCJlkPhGYXQ2i0rlGQ1vh0sj1fM0IO+7wGLUU3XS7nf07yp5I5kBnx3j5KsCYjFmf9KGslSm+IWHnXsMi8rfmoF9H8X7muLJq6NrsCKu5HVjC1CdYpGUO/gmjERr9MJCrSfNrW7t9K1hKm2ET8am097WBm7l+t7YhxkZVWwBLHmgS/pK
 yGaXi8ZO
 EDHGM9KoLSfwmkXBVHTptqOnXWdzXAyhyMf8rsNFw/MoqVC1v/HcOzxWtR+vI2rDuBhyBE0pU3ewhKTIBPKGlrWOMCPCJOw1SdwiB1McA2DHNGUnXwolEsj9qQPmMO4+1CwmE8vYl9zOHvauIhKSbhjO1Ka0ws7mrDO/49PNtY2qxjO8w/D47v4r4o4pbuiGnuvlcM9DSu9xe+oMQ8Gzog6bUqUrT/FhCkHWVN9FEQuHKFMahJitEzoF2+Wfk+4JoRHDWuuN/m54c08O1GuGvZXxke1c1u7YD0s9JcB/k9i/+gX5h+9+z9qcE0u2AmNlo1FGeD9WBuPMpoz9Kpo7dr6pqTHo5zcxa9Dm1NszuSPqXjevEuhu+yYW2DcAf44N0lLjyTyfVtIVefthRn7BgysEfyUudakqRA4Q+C3yGOEcA7NPYANFjXz9NTywolmupkzQNOdi6IUkiBOBQvhesif7T4RfGiPWRo7MqGMggrz1nXq5+1c9RejdZnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Before conversion, the range filter doesn't really matter:

+ For non-CoCo VMs that use guest_memfd, they have no mirrored tdp, so
  KVM_DIRECT_ROOTS would have been invalidated anyway.
+ CoCo VMs could not use INIT_SHARED, and there's no conversion support, so
  always using KVM_FILTER_PRIVATE would have worked.

Now with conversion support, update kvm_gmem_get_invalidate_filter to
inspect the memory attributes maple tree for a given range.

Instead of determining the invalidation filter based on static inode
flags, iterate through the attributes maple tree for the specific range
being invalidated. This allows KVM to identify if the range contains
private pages, shared pages, or both, and set the filter bits
accordingly.

Update kvm_gmem_invalidate_begin and kvm_gmem_release to pass the range
parameters to the filter helper to ensure invalidation accurately
targets the memory types present in the affected range.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d72ecbfcc3144..90bc1a26512b6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -193,12 +193,24 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
+static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(
+		struct inode *inode, pgoff_t start, pgoff_t end)
 {
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
+	struct gmem_inode *gi = GMEM_I(inode);
+	enum kvm_gfn_range_filter filter = 0;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(&gi->attributes));
+
+	mt_for_each(&gi->attributes, entry, start, end - 1) {
+		filter |= (xa_to_value(entry) & KVM_MEMORY_ATTRIBUTE_PRIVATE) ?
+			  KVM_FILTER_PRIVATE : KVM_FILTER_SHARED;
+
+		if (filter == (KVM_FILTER_PRIVATE | KVM_FILTER_SHARED))
+			break;
+	}
 
-	return KVM_FILTER_PRIVATE;
+	return filter;
 }
 
 static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
@@ -244,7 +256,7 @@ static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
+	attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
 
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
@@ -368,6 +380,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	pgoff_t end = i_size_read(inode) >> PAGE_SHIFT;
 	struct gmem_file *f = file->private_data;
+	enum kvm_gfn_range_filter filter;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
@@ -397,8 +410,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_start(f, 0, end,
-				    kvm_gmem_get_invalidate_filter(inode));
+	filter = kvm_gmem_get_invalidate_filter(inode, 0, end);
+	__kvm_gmem_invalidate_start(f, 0, end, filter);
 	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



