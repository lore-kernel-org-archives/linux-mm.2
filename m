Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35EEFCD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40BB6B00AD; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CA86B00AE; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90F46B00AF; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0C5F6B00AD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78A0E4077F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
X-FDA: 84796772424.18.63B70D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FE6414000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F0aFyTz+;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnYDGU+hNQb8n+nc2WHBXsQm8X8YrFidUIUmMFwGR10=;
	b=x2eC0CuQ2P5E+3ZQAxQioXRub//KxCGcHACzFCiTIb7TcbgDmM76KHBb537lD8UzYCkxAq
	eQsASEPvtyC3AvUfzBiOt9VXeEPnPyU1tIL9aW94+i3L9amYhfJAAmUPdkIau+nr0Fqct0
	Kwj/QtVyXo8kxjoDTGTpNzVuPjx7PhE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F0aFyTz+;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495490; a=rsa-sha256;
	cv=none;
	b=G/Q/p6rBU5vacoI6g1vDxRg1TClWmE1jPFr7PKTq1Fy7ReNHVkniDN6PcBIx25wsfTRpQL
	GG9zqiPh9+DsvMDEzxpjlAXLcPYHkpCHrWBjkYCGiBXGaAd0mUidZlD6NxbiG4Jc73b20+
	vHO7rt/EaSxQsRX+l3LrOo8yJG3sAf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A7A446AB;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82EF3C4AF16;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=C5/TPxlirT8Z4pUUUU6ZBkl62oZFFAbWfwbAqmNR+1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F0aFyTz+ER8xcIW/laLPtfEr3hrkQGVWf+rkomHL3AqCBTnGLivWpqWSQECM+3W/y
	 OuOZ4eI9oMxmqwqu8RPuJhOWGAW94NcdoV0x7e0q2r6k+HJKiB9bUH8gddjpKJ7FE/
	 /QqbQHvFdPP5DOwoJKZ25KSL0j5QCkF7rOFh9aHdKXSsLStGf0kQFIyodEtH1LaYtg
	 5SgKFYRXWlZ/U3AthfWxOoNNe7QPCrWYak6UmTTNv+HvkxdcmMmnO5JQ6JnNE3v24g
	 eBr2uMo5Py7PO5WjlYZBtMw1YbUM1zTNsYanIGScgXQDrSNBR3I2ialyTRscMo6B5d
	 M075U90BRQvDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7444CCD5BBF;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:58 -0700
Subject: [PATCH v7 16/42] KVM: guest_memfd: Determine invalidation filter
 from memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-16-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3542;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WKNyam0WfsXF7704BkJ6Yhxn0VKMH7okmBD8uVfoM5Y=;
 b=7XgIFwfTHLmASpN2NfT4ZLO3vFCUf27e0n/OrizBCmEaacnh/LZlaUDFAFJ0zHSZGfJ//Q7Yk
 1rEqSPFv0YPCA7mxH/bLILGmkZa33RuM646L4SHQPYrT3EDWYRHQz34
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ipfwpxua8otew3amq9pwdxif6dwzibpx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FE6414000E
X-HE-Tag: 1779495490-393671
X-HE-Meta: U2FsdGVkX18oHICcOAhMVMpPZFcwlzT0A3n1f59s3bwpkzI/HYG/w5qxT6TKMRuWFkdaOQUYOLCMnizU6qAZSMdbpH2/clmcCs1t7anep1JKWg7Ud3gl9HuEOOpFSOozeWcvUjxr4m/TQgBGOcEeIhmQYRgjkQ4DGp3VPtJ+awSjBgqmvSOOYLf8RfSQFUcKcen4XZR4eXnlRoM8VDV/QEMI14iTgqGKuYj+Smg/9bNgO8+G04JzLZ8YF8eUxLq5tvk2bOGA7L37f8BGayD38gT3SnRNFa3j5jqFRGQquJQD/0UDeDJDluBygEoxlrgXu17co2bnBUv3r80SjTJLnOXdq6kEw6FWgknZQsDIJgJqE44NELgR/E5sR3dTR8NkEOXFu03Yu7FbdHMmr9gyGl6bPDgXmNysQIuq9CGTEMfl2rn0WzPFDXmveO1/XpFEpPUTe8YugmQ/tOqzmAoWjqHv4mHwnPAEW77k+5n3vD3sMeW9G23AO2/oq/h7NtPXRZr7R+w7D7tLcC/T+Q5uAo7V4A59/mD/1FeVlX1CbwR98DvlBUzxlJoImYOn4Qar/EFG3YY6z/f9ERWYQ0Wx44YY3zvB0LThizAqZbBEWOJsD6wa58HfqrbCLpaKpgM9LXntZ9bzuTmwh3w4oCjTE9Jb819U7u8zc2npInAjtzYLssXnGVSmE7vCkr3mWot5yYS5J2hESBTd5ZOXDzGXM7Pz6kxyLMCc3HvAW68SyyMfg8Thb4JVRtPVaxtYbrNIMj3urF/adkiuT9wE+coXBaBIsCwvbkfN8nED8BwCSP91RQcvyHsdeaBVu2j1xvzZ8xunV/ouQ72Agw8uKoew3IDF1yH7pM3SZn9O9AKkNDaX0MpJMVdOKkgdZYFi9/sXe3yOk4GuHgdUCMMRJlUehXBLYkS+Vb5IcjVYJCZbiAT8K3I+m3V4PhYTTuBL2D6nE6FhFLrXM/tIftRTPyj
 cxWLFju0
 lky0vSIBTM7fzEIjr5/zyyaNMIIU7ZAi4RVux1bmLEv8sXpi8FifvAqgJjh8dY6oD0w8lzRVXhF8rNBgQHxXOg3pWf4JYmvMjcu3D2UDKGUc5MULFLMSIJpCBiEIHqwYNHD/o16/wQkAcu0TZGfHHOD2NdZAwiCW3kIAgPtjeWgfubgI1kFjuz5Z40EG+9xVEuRzYRhtD2QK+0cTJI3FWo7Rs/bn/o+/hL02YzYHD/fYosgvujwwFU/SrzQTOwZKxFf0KVUHXria/F95VG0pdXOuBUG0J+v9XmOagSTvZBCoNcbpe/R7tub+cLDx6cjAk7bYyfgCTd5DTfoIbWeDf1Ym5CLvV9/jxzLjXHYw4v+oylI5lJ2KKDKcsSKImYqhe5ZJ81YEH51hLv6M97UJBpoJADzYrFNQk1smx9HKOTTCS0GsP2lasYsH+MMjAOTcwJS6nX7uGcBQWZ1A=
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
index 38b24f79ec223..2a719faebed8a 100644
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
 
 static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
@@ -244,7 +256,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
+	attr_filter = kvm_gmem_get_invalidate_filter(inode, start, end);
 
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
@@ -367,6 +379,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct gmem_file *f = file->private_data;
+	enum kvm_gfn_range_filter filter;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
@@ -398,8 +411,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	end = i_size_read(inode) >> PAGE_SHIFT;
-	__kvm_gmem_invalidate_begin(f, 0, end,
-				    kvm_gmem_get_invalidate_filter(inode));
+	filter = kvm_gmem_get_invalidate_filter(inode, 0, end);
+	__kvm_gmem_invalidate_begin(f, 0, end, filter);
 	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);

-- 
2.54.0.794.g4f17f83d09-goog



