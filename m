Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E655DCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BF86B00A8; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544366B00AA; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD316B00A9; Thu, 18 Jun 2026 20:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0243F6B00A6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 622D81202DC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:55 +0000 (UTC)
X-FDA: 84894784590.17.27C07F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D61C20008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBb2VVy0;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zG16sH/C5nTPf4S8oaPOHjQaqB9+4VmLPZv21P+brcY=;
	b=f2Nygf2e3/khZj+dghzKllNe6NCjHIitHuYAnOsJ0w6ifDoFYZWrcb0Yj9xJYkjHz1Qmzc
	PQ7BlrJnFb2eQp8DfeUgVROgSM9Z2ORex3geNVZ9hpbPI7qW2fT6tVGcZkt60MCUG9Uiyy
	kNAQ7OHotX1T/AGXdSdTga2RpNkNLxo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBb2VVy0;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829113;
	b=uFnEXFWcu4fvqI+Ch7mGi6iE5SQBuL7vcQklkcn7ePfYj5GzhzzLQJvSNxyyIzDgsLuvwg
	6rAHaFk6GM6iJv2oBaN+g8OGXdmdM+fOS8lY3mLVyXBptotlISzRf9X3UgaxwZ0zyPeeph
	UGxT+QAIRM3caRpVOGhtmpAC3yvzzUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D49C44681;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16DACC4DDF3;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=gdcHZTBmWC0GE9kXuSoOy7/1OqB47UL/h9o3M8aS0RE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iBb2VVy0p19tGk+W+EmeyRC6sjg+4TfhvrU5pcx2CboOzxGS0CXVtcrDbDMr1Yao2
	 FBurPzoegikqi1zaBGeo7TxUgnJnjzN7sA7mcpy5HLdxMZo94RTeMSj8JOynKt7EAa
	 MatnkQzbhtFQ53+9gQV6CrGVuwkdVHP/Du8LxI4+W8PPNSmefU8O/ovVra0S9Z34Cr
	 g9bTOqDmY1f2QDKlY/AI9i9kkPCAv4knQruCQzXd9XNoii1Irsw9/n1kMFg8372GFU
	 HygwvS85kUKG7pinG9o6b47STeaR59rCZw5yJO6ohxJMVzq4ubcrCcpcMnfwFdXYTX
	 efJFOep1RPpxg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FD4CD98FE;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:51 -0700
Subject: [PATCH v8 14/46] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-14-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=4835;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KBHEGQKuWpDe+njfLl+lpw15mu536qAG0wzEXp3jt9s=;
 b=v0wfXRaz/JzEqQAReRMEm6V1S/nL+U2ZG9xnhsKZvjeiujH0MEyKBRtCKPzgVc/HQcTX2fmKi
 lbSB0khyyz9BBYCKpl+J2MsjoQ8cnmjFnD/bldnwQ7x+oelEw/7km2R
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D61C20008
X-Rspam-User: 
X-Stat-Signature: 7zegn9tyf6i8gai7yn9s548eixqk77iu
X-HE-Tag: 1781829113-962806
X-HE-Meta: U2FsdGVkX1+G/GALdJoB+D3oUtymICfgHroB9zHV1fGjXKwYj7xFJCANJXOuwMZy/VDoBEGDgFxMiYul2JmgPGVuudh2zsxaFVlM9AX/sOZJzYHp8Y6wP6muawV3PP1NrUTgFHlab95VARwzhod7iYGDnJqUKD8y+vYvQMZ/lixElQk+ACVaVGoWSuDMenGMHFJwTHOVtvMeQjlSEUl/JqBzu8b07sNmrbW9YqAcWur6QV/4xPsc7MURrcnMG3Km0/Fe3tKGexknOF2TTIcznE+3JZgG9hxKRUTkJAiR1WTcetBd56KpiVXHMojLXocyHa9m84+WL6jsrbdjZLmkoBYVQYZVIdGKWmO1usrRRE5d/jIlYj+5zolI21MXdZWwsnUk6Cjo9YthYvACEDPv5yUmVfFk2Btt7k0IOz9q+CQ1ZolUe/NlXJuaR7bfqzlMlQIhrrtar2TlW/oNexbynzjn3Nqz+LcQ8I5C/nWLCsIcZwCtcgCoRSMAgxVDFwNcePJsywDaSkx+641nhHL853JenGD6BGbNL64xxiHX5ewDTAQzqkWaO/T6SzbtkWic4kTZxJa9qu6z/gZjNp0N8MgGZ+L0+QZ5ZEh3KIpi3qAYh8fnrJ7OCYLetIG+fKYeTapG8xGv7zY6Fg5cGdY/+FJwjehItUQDbjCmVycQC0RNb7wr0sm0HrIB8m9NSi3uxb6pBkQRGnTXmAUKCLoJQajV2vowVQJcw+xS6GZ5ji+D5PZ9ec4HPOgkaEBJuA+9tOaXV3HjgjGztEf9by1vdtNkXOAdnaatGkayQBK7OfFBrqqcMj3KbQz5+Dnf4p86UUjxlti1fjsgNYOvUD0773p+2dXZksZJUEbtu7Rwsg/vhbUtvnoGA5bDK/qdLJI1BwM8JpLSffOcs5zKajBfWIrNqT3X7FBmI5eF86WLudAGAsWkAPS33jQ/2ZN9wrpc9UmwCzFKQEwvBT6XEUr
 wQ5WMjkD
 IKqd+lFzNxdImtjTK+6XqFdRdK7cYjCCvykrX2BoN81SJh/FMSss/UA776M6EcLdtwC7xlw0q1uMoXrVvfZo1t1wlyQhSmy3vFsofcX3X1V90YZPjpOluuz1xaMH8yd7vu7KYaHu5YNMKttNpuz5+756LvFnsWq/7tOIUAV1XMFEjcDZhPzEzK8MM7/dnwPB7LETsSKHFS4fr6rFg6RpHp0SdK7wsufWQe0EgizfQJZHlKjN+AY802U9Ra4qrkUIBKZ39p9Szj22ReG5q7c38U2B2UFv6BvVtCxiqoKVmxsgDzBAc0gSk6yIT3cy7QUzocmCoZF8ibFJ558BUB0nnZ2NmlCL/oRpS2mpEtSyJRs7AiQEDwY0rwARKILp8C8+em4kJIPfDR0IoSpJYfD2MUIeM3cIOOlvPSL1ZdmgCBXp9s0aw4h1dWvgwNuA9q1z3LXqHe58GK9jSPiQPcM9eKQeUIjIeZXzm6iSlNkflq8PFwvE=
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
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/kvm.h |  3 ++-
 virt/kvm/guest_memfd.c   | 68 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 956877a6aab05..876c0429f9d4e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1659,7 +1659,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0d14548c1ed22..433f79047b9d1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -573,9 +573,45 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
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
+	pgoff_t next;
+	int i;
+
+	folio_batch_init(&fbatch);
+
+	next = start;
+	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
+
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folio_ref_count(folio) !=
+			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+				safe = false;
+				*err_index = max(start, folio->index);
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
@@ -589,8 +625,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
@@ -610,9 +659,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
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
@@ -638,8 +688,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



