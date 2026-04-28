Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27870FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911D86B00E0; Tue, 28 Apr 2026 19:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8386B00E1; Tue, 28 Apr 2026 19:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D75A6B00E2; Tue, 28 Apr 2026 19:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBA36B00E0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:30:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485731A15BC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:26 +0000 (UTC)
X-FDA: 84709548252.25.E954A23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 152F5100003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u6xvBNXG;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418724;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2erp8BmoUGkofuTig3RS0cIFn1Mn0SsmdBuPvXnlRrQ=;
	b=jyjtI+gZVCx3LeT/K3zHKSQS5BpQ/G5QDrclsQ8uIr41cwkvwapxmr3ga+EKv6QbITtZFN
	exL3qvv2Du1NPYMJluDMJps0cYUq7IIWOvZlJLVEYwTsEU1ijhuk3LgOsDhrOm4zSCP38Y
	7ZBRoQ1b8SJSylR3PfYe44YU+prjB/U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u6xvBNXG;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418724; a=rsa-sha256;
	cv=none;
	b=cNT3J2M5dDpD7rSbfpH17A6NXaQL9v5gJnS8y8vf2Se9qBjkWfv/jHfIyC1eSX6/WpwZ2+
	kLp71lHbKgm+42E48irEPEzb6utUaNQaOUFW+68nno+8xBd40ea8lDZ6Ex7KtQDV2lxj7Z
	NBvu0KEMk1zj/dWMTC2yhp5NUAYnQAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 685A144971;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1744BC2BCC6;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=9750fpF1nnzw5FMbcwXBFd8+x1vg6XaBTqinHY5QRdA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=u6xvBNXGyL7cfftlbzDjeeSOdAU0lmPudk+DWmikdf6BoR8kwwBUVdYUFXaaWz40z
	 I7wF4vpRPI0IrCoC8DkeRM7/EEAvboOITP0u5BD54fK4Y7e+DQTszGtPdpmAcDBb1A
	 A+CE+UFYjFWPPjmURONblE9BrNpiu/KvbgcItIoC7NMbL9tf+PODmKwFYfWyqb7kTo
	 nEhtgGHYEtpsphe0gz+3bXFo2oqTDXA8ow2EELOPKgeu3KGVmFgqBavd7ghfHntb64
	 Q/Y29xtTY+ZjvHHRixqFJ+rQNiOm3qZgNSQxb7K6xgjyz1yLJQr9WlVxHDB4yIFauz
	 ASz9Z0CSaPxXw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B4EFF885A;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:06 -0700
Subject: [PATCH RFC v5 11/53] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-11-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=4739;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZesJiMcNapcBxIf6x9eHO95YZTcAmRO50d1ZUK3cJ+M=;
 b=HWL17Acz1Eb4pA5qXBnsUBEn6SyzbNUQa+McyqKavL8O5iHQaau0JL6oz/botc9bXTWzmzNot
 jJGdXsm/GCUDE42MsBS0NqMYOiy1mFctd3mo+UQ9FIXhdLizCS44v46
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 152F5100003
X-Rspamd-Server: rspam06
X-Stat-Signature: s716r4yiccp7ux5jb3s143e68spm8jro
X-HE-Tag: 1777418723-495330
X-HE-Meta: U2FsdGVkX1/LD/KrPhkDbJfpf/IeSf3WJk3EnwsxKwNFzcwYQjW4+gFdte2sv72ktwdV03/nNg/QKP9w3IS/Sm5C7UA/Tqm3oNgstkTHnsMLrBozHFJ1a14CDJindOdW1+8cOJluMlWsCJHD7kBWq+XPxoBrZBpj+CBOHtaa4HgNyEDLN1bThXYC3WLlcrmmE4daUN5EDOckLCQA8VvlAxGA1tL5PSA1RaVNvRTrayFHN7MetoWYZRti365RAC21NpBbvtmg/QTDP3f6/xWMr/pk1q1QbsiM2Z6sf+1HhdysHpeHpnh8NfifWNrbQluyzgIAFCZMQAGmE6QRZKrPbZXUTc+ML7Ue/Ed3Ql0ufW0w+4XuBCLSzqTSQV5tW51O34wn9mtaBJ9OrFrXad3xt76wbG0eH1wcXKENSEUTeV3wfOGq95Ca/fVIKX7JQmpe2zq72qBaid/T7qgfytwkolSskbboTfnDbH4lLfmgYbT55wyRU4uZXJRqto6e9hge74qtHGgKBgl5T6T4zMvuCviu6SjElyisC+qBoi3EMAhZ1ucbaz8m2O8ItkkHMb4XLlYFUSSTxc4RdnjOx/X/azbWKbBeT5ka4ho0cZ3QcRW9AHJbA8srvGn1jDc0PfkNN1r+g7wr9p/gjHJ8nhuGnwaXpHE9SkaNY6lxjpXak3GiLLPX+UvoyHSSgK6czqGR6Yj37keoYmoe5wWaABTQLldEgbJREJvMn+U6QwDYjd5c/6Ns33kmTUwZU0ob6Ii7FJRN5hKgmHYqdRC/z4O/kYXxxYzpjFZdbLMk5sCFZp7/U3EDCaeBemr2owz9reV0q6GVPpFuRMnwXxn26tWrqW9aA65yL1dVid7D08cdyliX9FO/LFJO0p6Q6j1qswMTLKRfPl3I+mcaoIxyVrpPOiKpqyP0ceyC1G12JtQyFmNuZFeyHtKBKhbwY8hhgHaejvADPrajPAhFeOBRHWQ
 cx7zGDkB
 tmKYdIE5xXnK5o/aCasU9SEH+MRPLINfRk0gXPk5GHxqyI70usUVjSJR4mossw/8WSv7VD0vvMa9FP8Pix0HYbO94X3INkPnu1Qm/mf2xGPfrurSWf5qF5qnw0AP95V0glB6o+ayZ6lHGbssOX4QHDh45C7nM3bAWesoA7o7zQ0CSVPb4vRALSah5T4S1ZVRfYVZMpN4dZqUIVfLc4iwhOYfAM3Ce50exbMD6SOiEDSCxjQmRK0ms3PS6JnB0Xff/X1vEqbyoVjxqT3bi6dwXRqeQWgRds/ydYhx5/KTFZBAu33dL481Wz3KfRAsXvUhs3Q7D0O1vgGWi5rWiEyXoQLYow763mGcrpoZL26ITM4otSGTter0yFYnZQw4h5ivp4G2JnbFRNQ//Q20Bibr3cqILbjKERqm6W2cXH2PdlSKSdeKxh23fUhG3+GVa+BUZGnJOI4jToYngsiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When converting memory to private in guest_memfd, it is necessary to ensure
that the pages are not currently being accessed by any other part of the
kernel or userspace to avoid any current user writing to guest private
memory.

guest_memfd checks for unexpected refcounts to determine whether a page is
still in use. The only expected refcounts after unmapping the range
requested for conversion are those that are held by guest_memfd itself.

Update the kvm_memory_attributes2 structure to include an error_offset
field. This allows KVM to report the exact offset where a conversion
failed to userspace. If the safety check fails, return -EAGAIN and copy
the error_offset back to userspace so that it can potentially retry the
operation or handle the failure gracefully.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 include/uapi/linux/kvm.h |  3 ++-
 virt/kvm/guest_memfd.c   | 65 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6bbf68a83813..0b55258573d3d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1658,7 +1658,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9a26eca717047..e87a2b72ff802 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -584,9 +584,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
+					    size_t nr_pages, pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	const int filemap_get_folios_refcount = 1;
+	pgoff_t last = start + nr_pages - 1;
+	struct folio_batch fbatch;
+	bool safe = true;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
+
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folio_ref_count(folio) !=
+			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+				safe = false;
+				*err_index = folio->index;
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return safe;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs)
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
 {
+	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
 	struct gmem_inode *gi = GMEM_I(inode);
 	pgoff_t end = start + nr_pages;
@@ -600,8 +633,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r)
+	if (r) {
+		*err_index = start;
 		goto out;
+	}
+
+	if (to_private) {
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
+						     err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
 
 	/*
 	 * From this point on guest_memfd has performed necessary
@@ -621,9 +667,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	struct gmem_file *f = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct kvm_memory_attributes2 attrs;
+	pgoff_t err_index;
 	size_t nr_pages;
 	pgoff_t index;
-	int i;
+	int i, r;
 
 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
 		return -EFAULT;
@@ -647,8 +694,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
 	nr_pages = attrs.size >> PAGE_SHIFT;
 	index = attrs.offset >> PAGE_SHIFT;
-	return __kvm_gmem_set_attributes(inode, index, nr_pages,
-					 attrs.attributes);
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
+
+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
+			return -EFAULT;
+	}
+
+	return r;
 }
 
 static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,

-- 
2.54.0.545.g6539524ca2-goog



