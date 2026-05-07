Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 087D8CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AA16B009E; Thu,  7 May 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3266B009F; Thu,  7 May 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308576B00A0; Thu,  7 May 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7FE6B009E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3A411A0208
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:56 +0000 (UTC)
X-FDA: 84741747552.05.8164A45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BE8DB100002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=krDqN9qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185374;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCl18OlTaSoKfmETR2WE9R/XljD2XYaP9uQQNZ328bc=;
	b=hozoDQY/3mIb1Tu44+aI4gcBXqXwbSli15bVBzYywCUlPmt//9LCqP09HvQjDCHWamQAbj
	xQxkXZBxgFRP492ZuuuSxkBnB4GL6qtcKVneEZh3OtXR6/pABLiL3AVJDPsapkuaiWTa5u
	6S00w2A4tO1zrfdWSqGr9x4ZA/znKZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185374; a=rsa-sha256;
	cv=none;
	b=rPuTN0IOi7a0py5pMQdXo9eyaedGBt5H5WL6MFKOr6pZvn/g9ryRF3rdaT5VoEdwPYckji
	87p0lbj8t8R9pPpSk+us3axJOEyt0QWey1Vunr2eeYrbMNxTK6SCiyYJXchJYczvC8uuJR
	Jp1zejV8BmuwXDA4SlHx6fqvaQNEM3k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=krDqN9qh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3C0544731;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDFB2C2BCC7;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=Tdn9rJscCtXRzSNFMiX4EAKXKjAyw4JTRnv+5+lT81I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=krDqN9qhZasfAJeTvERItwNdtL3GR+yq+YzVcxWfJJdlers/lnxjhxK1quAbjILcc
	 rNWSbHzvLlgjXMJXPYAAJgBl/FSiqz4RKA/vnjU1bqR8E5jMelCdo1qlKD3O4zmhp5
	 Yz/09pFVmWUmp+ts+MY5JbNJIfOJ+lvUPSeApZyXjWQxGFFCAonQeUGFYgknDAdrVW
	 Tx7RR4EBLl81sW5em2132GrFNosKZTIFXMHkG5B7pt5127xRGEx7mKgKj1Lf5pzJTz
	 fJVM81k6YixubIBctQzlwhmlxSeCivihRn7jDugCY5mtJoX8KuKJezWdAsnupAl1Up
	 C0edj2eA7PAzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B046ECD379F;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:30 -0700
Subject: [PATCH v6 11/43] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=4739;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LBujDOwbQ9NSSLbeIZY0UWUpuCkb8Siu6Wf3I+L9ork=;
 b=lif/zoZg8T5T7hPNcrmKSniwLj5J40SUlyia1CiviWEghgTdF6fRQzyysO1M/luWOA+tHeazy
 bqcQdw3R5VaA+O+hozT8LmGR90p3ctdzTzfy/rGMa1P/zbZAvp7KI1Y
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE8DB100002
X-Stat-Signature: dezs6o67f3rom8nmpm41fsyagngrq4g8
X-Rspam-User: 
X-HE-Tag: 1778185374-226605
X-HE-Meta: U2FsdGVkX1/v7QugPyWN02gEdwHLiLAI+uQUe/rxMfILvWZWzp+i6Kr1/hzNxuRFEhZM2Lz+9RcHIA9tELqvrqFBCg4xaDc0u22u0NOUq+KLggxqq/X6Kbp78kL8r/B2kJFfwlKodRK2Jk5gzZMhheSLGpW41HtxpyqykTsEUMGfp3yQ2BbBHIfAvXtE+ZHxLl2ADRl6xpTgqK0SfNjzoFVVEKt32OxBIfQe7/MHyDFdfLSg/iWQiCb6ljP9xNJCIvtGBa8cIMS1Wu4r+62EkdZ+m2p+RckwVQyDZ1g88UzzpQ9MVzCIMbYlXJw1PAZf31IyjmeBoEg8nEdstudPfUZbJlBIk0jS/F3ouqxT54LZTWrTe7mfeq8em7DRprE/3FPFblSIfKMqZCMroavIfDjSR8zsASmd2lJNoAx3fIwMi6SSC18iKhYRtd7jFExAZ8n2U+G3s6BtsXySaq2XgzTj3G6D8iwJ3eLC9G9jZ720sF4vcuxdr3oNc7elwLv6OgJkbwOGmxK5w3lPKK1Wug8wW45ZBmdSr5TEzCsa1nvQTytYZwt+VDAf+kfl2uZBnRF3Eh/mpGJSSb1RfGqRdHtlOSWPOl7+QGGHPjj7GXMcDdPNJKrQMJKPQBywq72MZN2ylrTu0o8alERKDa/U9En6zq+UiDKMIK1ndAaHOFsuYxB8mXXRrs/TTR238LWl3SBDrezh/C5Fl/nRJRFkB9QVSIhKbQ3lMC6b0p2bf8c2Q+gytd6dVYw1ANl3umlPUCS0dR5XNnALknybHzRlVmw0wMPDr09XyBvvEBtwyYJlDg1viYKG931Aveg9046Yi3RU2dIKw6ccqS/0w96z/Efkjix/dtEgTn1ILCTmRAJDls7lBXYDU+hjuhO10IFyMsn9VOLWj9evx39WbF9jiyimN6GhbloZLMFSd60PtOznQ413Jv3FCycQaRiTXQy20TDI2WV5c/cN6l/K3hS
 n1zxBXdT
 gnYVA98NMBVIZnaz29f6Y/AAPGz6ySXn12YxDNke2tbsX1BfsaVw7Wzyri9DuM/P2gzoeeqeB9J0J4VBPgNNPjr8Cz1VIrW8rcJhcOjv/thelWr2IQBFZZUPS+XfzA0uYcfrs1wTfFRTKDI2JWRuJOTssNooj+W1iHrOen8cT7njhLQsJgR1RBEN+99Qrgp6hzX4kXO+x8MNmIUty9FATOG7rtzQ/tKMu0X24p5WpGTIJloSVvd9vIGa5EkSapxdonnTtmVMgRx/Dxh03RXBhYuBhsrWOWjLMU3DM67eQ2PkzCfD5Qyz5v9QPQu/b17lyfA60s4h0qnr8yGbfQzchzIR9TquVGWXqT2ZF08EWA/au76ypWEuF1S18zxLc8TfGYcM+Jiwyfs9QtTsBI7/Hqd0yZTmGzPy16bZyrGfAJmj59Z4nB1c46/TlYlMPb57B7riZ
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
index 91e89b188f583..9d82642a025e9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -572,9 +572,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
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
@@ -588,8 +621,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
@@ -609,9 +655,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
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
@@ -635,8 +682,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
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
2.54.0.563.g4f69b47b94-goog



