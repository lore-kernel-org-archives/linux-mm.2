Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B6EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDDE6B00A5; Tue, 28 Apr 2026 19:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4546B00A7; Tue, 28 Apr 2026 19:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3D56B00A8; Tue, 28 Apr 2026 19:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C29176B00A5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:25:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBA89140CC7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:25 +0000 (UTC)
X-FDA: 84709548210.10.C8F5C6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A11B14000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6SinTGx;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418723;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvSDdsZo7c1O2iXNtJvJtdvPnkZFu6pfqgjtuerWkus=;
	b=V5SeH7u3Y1NHLqxtpdu4xUJYO9y+Dbete/KMCXe/77Anwx7XWbDdH6a5Bzeqc29CNLZpJK
	qPYqT8jo9J6lnYOOMlHnfu7FyFgdW4E0v7E5hndxUv+1rnz/RfOqoqKpMhSXkemgwTMpQH
	6Te+KoOGvSCtOrHr+1+Y49ztytrX+mY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6SinTGx;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418723; a=rsa-sha256;
	cv=none;
	b=BuuKcz9Q31O3R5C900NTXvhTFReVY8jnc/N4IpjGsaxuSrJ3NFjMGzKlmZV2LpemkfWQAe
	X5I8P8BiwaIjFyNdr1FqgDFiDSwgOzreaTylj7JHQZu3mAscS+Kvqnm0LQqSQtKI8Joc0Q
	h1umTNxDwcrfkimPI2wAUCgR7G52Tuw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 688F844973;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 254C9C4AF54;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=iJZiLnKh5j71DDrFz6egf458dsQEYwwMP5dds4+D/y0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M6SinTGx0g7MFmTe7R6QcU6RcvSwjFksWzs6GrX2b7I46sz6+OLV+EC+fNulkDKlN
	 rNgXWZaqV/rpFEPG6DHLFA1mKtSDzZN2rm+Hv8GFWiPrQ2GK8k7aTP4Z90CZJTBeVs
	 sYmWYanDsQ22WtW2AW6T79t5ahzJyHoOalBlwFXKjZJnlllhGjIW5rZM/SdDF1d1yj
	 6D7YYOyjGsjy64FxfNrzUUtXb594mu2M4yj4IVGt1KIcoXCMQfdykGQu5ciMYe5PdA
	 dNPRQa6mKGGgfmAJZDJJYz9FslS1iVd1Y87NBYdLCSIYFV8S+f4XaIPoyjc04i0957
	 Bw9+Zm++SJpTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA64FF8877;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:07 -0700
Subject: [PATCH RFC v5 12/53] KVM: guest_memfd: Call arch invalidate hooks
 on conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-12-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2720;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UsLRLh3AIJ5cVwTgy5fboswwtwHuPjBmzdL4rLOt238=;
 b=4jHyEI752ecM5CTcqDblAk9LFt1tl5dB2MC/7dEAS40eW5wd6PuSEj1Sj6Qddy+65ypyXOOx8
 ZQ2bxZ3At6JC/k3AP/41lDarPCPuqNaQ6DYcaIaLZS/RqW/ekh/abb3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: os4dk6pzfn8aagw4fo5imm5mqqjq7gqc
X-Rspamd-Queue-Id: A11B14000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418723-392450
X-HE-Meta: U2FsdGVkX19a4utnK3jWuLkRnz4qhca4+eb+uGEsV+z1UPFRUkMj9te0Odqkt7o727/R0x6UzgunvrOpaAtc8yMFrFnjioU0tBDz4uiRmx6SSygmw6fwrv5gayP7d7SvSxnLJgCtag9NzjsDjZq/zOQWtL80ooQ4gUhTlPW0XCiosX0tHNTX8XXiNN1+MlwhyUZJTYU4tqak1RpaatB3Dapr1Ky7wt5yvmenbQ0psa5TcPNSBqvckhMv/ACUv1HX7JLzQl7ABvUEj2w1fCCUxr9gLxeA8Le5Dt0wOBeUM7UBMzDbLdgdq7/6sdIDh89nwJDoH36yuzAOnWMw2V7SfKuHq/N1/g1K7OQDQiTqT0p7WwEW0eCbtlTn9PWo+CzYnWqL+91LZUOcKXt2S8bruFZlxmM9cJU6PHdjVpcwOZp5R7lZp4QOMuzS0jpu6bPrY2NifI+jQ/ponPy21bAWyPHXzOkkdmz+tpYhLC8n1BfKQq9r/1kDn1FrFdTdpEW4FmO8SEVn7Mns83N3H6KxJbwzuMeHo87cQdb8ZoeU0GhEvJOKoqJVJjgRD7JOzILEwrfqm/ervgG4ZV97BTn6yYnonApph7r8CpS87VajROcp6GcSwhfvFtZNaWah0aiBOqBa+GsNII3UbufYMhW/M1L4Gbh8cMCRpS00XlO5U8jXQ2lUv+aOXG4a6IzBwrc8oy/gs5octx/nk6hZLQt4PtixfDMuY01rKWh3fGrUtq7YEzC3GmFG5pQCElrnaWsx3jGMqmmPmuEcikrQpqaucS0ng2rqWIRTHsKWukto95T1CspY8n1OD54p5sqkWQmYRjRn12y3GRV/uDpp4Wf4iY12JBNnbIoNXLrXg8vpdhlczhf1+AySBWxgabzKOHSQAVV5o6kRmHU81wS3WzP3xHuKHAShEF0JtvfjRIR0cPtqFIQVHRK5kdb+RHQrr21oT8ziwGgV7PwxUouPYaQ
 RP71/4kv
 9iIWTKkqmagfGjX5v/fZhr3te6wnQbvukTO93JyndMZpgcr7VZudsIfYOKq9y79zfCCrt1twomsu0amy1V0J4Fw2Xnfv4s3ukSshzI+hBogIGQ5vivdFydKM3oB+sOOV8PAN72UZLMvlhGnf1v50iVsA3YzGG4ZoNmoZrn4p1ZynQ+v7pwQhFCmGcDEPS+1sAbbb4v43hxZDWV4gks3Teg7KX2Gg4cL8fCOm3SGiZnzCG9GKGvszOSVQ7Q2hEMDPEgwJVAkP29I3oHI7wVpTFRnu4wPv/fHgsMrQj4giif4ZozVvsQQB6+8+bwqKRVCugxpa/cEDwFWf2E3tXWXOEbs4uILrqYrM6iV1SfDHQIQ4aOaodS9xCz0pT4EzOQi+XAOEDH16wC7N6IqDS+76AxFNcRv+nbRkFPYz2LWHPU7Gh71Z56GpAUsXGCY86vNJyy1Q3PxrWHkwhyocRxVL6Wx4wAaEx3h4Zk2KSWT4mRT/+LAHC4yuYxLeBmg==
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e87a2b72ff802..d563d80d4accb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -615,6 +615,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
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
@@ -655,7 +691,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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
2.54.0.545.g6539524ca2-goog



