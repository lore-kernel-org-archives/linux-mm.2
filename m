Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DEDBCD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA996B0096; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5F56B0099; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D1E6B0096; Fri, 22 May 2026 20:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4676B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12ABF92B7E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.04.DEE7425
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0FB8F14000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aoBzKc7F;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495486;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80l4HdDZsSEXQAOdxh4y+b57H7s13L2qUhngUsmv9EE=;
	b=miXsLRiPTpAwJSwMgaEJS1FmawShN2AsW6nn6XNevhNQq6xdDpWqE993x9YXl8EJ6pbTV9
	H0sc+8dKqDaSOj3gX5hnRBd44V6r1QL/jHe2VCTkpCl0XJVQu+8MfgRlMh/CA4jRy8z56x
	4kyCt2Jn4zlR/CLHozmHfZ33ch8CnqY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aoBzKc7F;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495486; a=rsa-sha256;
	cv=none;
	b=ZV48fq5R3U30T2Ooc36HWFrFbaManGOpU9QePA92UnynoyX566FicRpF/l7BYf+N4xrDhX
	xgOJFbK1LF1uuXWVTRYZaM4dQlK2QBt2nVhXcvhTSm3nFfWF0zokAMe8ZUXye//AWWm32S
	wcIS5Tgn1HiLUxIUIeHMd8a0G72/K4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6EB760239;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DCFEC4AF0D;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=8TNCIvB+lbzJofkNeGizBD8qsdqMHY1C+2HCbP7Y6bw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aoBzKc7FxuLhjgfUUxJzoq0pzZM+/LttC1WAmH/mWGX6NvZSKD6SacFCnvdmUHlVR
	 PbZrFjaM73KkLL2ozQReYE+61/YIWwfs9+N5t36LZGrckg1+ZNl8HV0+Hwj5PQmgBi
	 UqCc4sEgwApvQkqgV//cpeylEZ0D1ZlNU5NYMu89n1+0PAWbTNQ+zGjarrqJEue53R
	 4WRq+oEOkjiMJ8csD14tEIMeWWs8PvO4tHQOexjX+nUzJ8g2IVYYG42xwAMlmeakf9
	 aiFIUBt1g5Dts2/cRX/SpMJuD5gskhqhX6Ha6yGZA5PecuSZVCynelKXXaDJF2YQzU
	 yZFj4a7HzdS3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F690CD5BBA;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:53 -0700
Subject: [PATCH v7 11/42] KVM: guest_memfd: Call arch invalidate hooks on
 conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-11-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2764;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KKlrH/+vEe/uL6U892opPXNT4vrkNzXgjvBg7IfPYQY=;
 b=Tk1j2vugUg4JNwXyXMDf53PpEXMSRXkL1Gqt+WI8HTzRPPCmiEB30NPCU7IJoT5vXjXsSvwDZ
 jS7wGv24KeVA8GGWNylGpeKsK1fsZtzIRYSKw7Q0ltVIoCKay83MpSH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FB8F14000E
X-Rspam-User: 
X-Stat-Signature: pe4tipayu6dabjpggn5qsg4gkn6pofub
X-HE-Tag: 1779495485-895407
X-HE-Meta: U2FsdGVkX19yQncdK8M6d8kGYm961fGJizqKQ3DQw8jPSVcn5Ql1yYAYQrXB5ldapN2dS+3mrVfjYzIc3B70yihZXi70nkenHWQU1ATNwKi42GY9i2npNQnMPovMF+sqPEPz3GG7OveH/+DNsf0QvW8/ge+kXBguyn19jGAUeE+JTrEMZ82SbPxobnZhi02n67PPfN6wK24lzJ2ZM0CtPndLb8rLd2sCD8Wv5HQEouTVAtbf74jPDnbAnQDXA7A3qbuytQVo3nHoLNm5K1tKJolgR3XcZ9HejDOG3hNw4ZG5vjWyq4dnHPA3ojzzLv4v4T8CzCYOJKwrxKXzGI7a6peA+hu7genhTkgg2G/yUv2m8xSViwxo36IsDrwxiDgXFW05K0WuwXU+hYOWCuXVUiiBElaytwdHcp8Kggh+TzQL+g0evnvhbqrgAOIMXbTWQf3z6xEqM/TwMEU+t5deWtFoXgwRZRFjKxgg/renANwtqFC7WINqyTuHWCVsR2w8J7FnMAUlzYzla+Fqvr4rGnMrm/zQwiTxEgRYC5CH/6pntis+6cXxb//aQRNSwXHjRf7QKYv+96s9v1+BcXJ2ZIO8zE70zeKgBYSvcBATAx7CgMR1NFu/aPz8aSc3F3TUysOpwo56HzWZGy7s4BXCt8hlQ15scarFCcLoK+gjprYCnWK3vY/XUUPlfoVoB1OXCZQz+hJYk0B22IcmsYQquiaGljRQOO0pIwzCVPYDSPYmhMVOdvD33OSpqFtb//WX/FIa89cyqmTgenlD2J68uNaKicO20hUkUqXUtjZ1PvsGHNTPkPuHLmjMLUMlosj+fBzQCw2riQteyyW/B7rFBk3jGWxctZBj9d/OxZiWnQnxC3kTXCHWjDSIGtkSFKXwyO0FBanwpolg43mBqeW3CUeL68OooiDXrYaScqfdImc9zlYvFG+a+0Eb0qhlm1Cc7fUZoD1xv80tbIOntZa
 Cr/lyLo5
 tGeNdyxuwwgsl/3mHm5gSl+hgssqPMtbKnd2zAVjrh1eKN5wuVPD0Cydjn1/6UtwJEuXAosK7XM6HVIP+0IlTB+UsS5OgjBA3swatvOuj49Udacr95WoxI4KxCsr5EU3+MicZdqMgFZ+mD2uSIjIBUFISswPz8N3UbMZetpTB0aHyluG7Ux5MzsJKlxwwnJzqGn4LVpxyY5BtSOphOAGCZUrK6ac/7G/j+WhpmrvB4vgJSzvpj0FV40lS4tZ7RmS0swAZPyomsd7ayE0U0/3J+0IFJ0RrtUd56AnE4/eazDNIZdPheNXuEwfGthRJYig7a0OvSB8MNp84wUotoFO9sEQk+0ymqCc1a7Fd2SFqF4k8oM6DoJ3vu2W/c8LXe02bHCYWQqwMj83edtTbr8L1Gqk0HhsdV44rmFqy4H3kvlh1vzrihPTZuoMYy/a/tdxnA++q0Iecnr8aU2yfUpyZeH9yuJHjX0VEp/zxbrLkGTSb7FSd0JA738bMbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When memory in guest_memfd is converted from private to shared, the
platform-specific state associated with the guest-private pages must be
invalidated or cleaned up.

Iterate over the folios in the affected range and call the
kvm_arch_gmem_invalidate() hook for each PFN range. This allows
architectures to perform necessary teardown, such as updating hardware
metadata or encryption states, before the pages are transitioned to the
shared state.

Invoke this helper after indicating to KVM's mmu code that an invalidation
is in progress to stop in-flight page faults from succeeding.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2767992955752..c9c5b9f074baf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -606,6 +606,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	return safe;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			pgoff_t start_index, end_index;
+			kvm_pfn_t start_pfn, end_pfn;
+
+			start_index = max(start, folio->index);
+			end_index = min(end, folio_next_index(folio));
+			/*
+			 * end_index is either in folio or points to
+			 * the first page of the next folio. Hence,
+			 * all pages in range [start_index, end_index)
+			 * are contiguous.
+			 */
+			start_pfn = folio_file_pfn(folio, start_index);
+			end_pfn = start_pfn + end_index - start_index;
+
+			kvm_arch_gmem_invalidate(start_pfn, end_pfn);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -646,7 +682,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	 */
 
 	kvm_gmem_invalidate_begin(inode, start, end);
+
+	if (!to_private)
+		kvm_gmem_invalidate(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.54.0.794.g4f17f83d09-goog



