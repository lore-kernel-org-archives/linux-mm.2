Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658D7CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BD56B009F; Thu,  7 May 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F126B00A1; Thu,  7 May 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B116B00A2; Thu,  7 May 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96E216B009F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58B7A8D008
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
X-FDA: 84741747594.15.2657966
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 509BD100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA71HU68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185375; a=rsa-sha256;
	cv=none;
	b=3Qjny0Vmr/btsWvvmlhpX3c38LOcTFM9EWhmCaRk8sfmLIN1GeypQPvE48LBGH7/SzYFaC
	zJX9f+ONG0UVIvDG6m/cDf6rULrbTOQJkauXKpIINdlAqNjVScsIEKRElnmKuJ9PQGt+DI
	k2jxGXUTgSw3GjSBMqgISTo6UroUD2Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA71HU68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185375;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijGoCVgWOCYLhKGIHL+VX69UniF29HNbYYv28FP2ijM=;
	b=zcYR+K2fyfDaIaTmenLEz3EljO9dxzeFUbYaxBq5A71H3ufO4IxFwhIOkNDisAyaTFsCbk
	cyGSubFtlJS840B6+MKUCstb9c1v7CzzT4liQVeA8CaJmXvMS8WS5Mu88C0Rhdn5W9tf0W
	aHnj3RmrPyFqSYYY8FfTpchat1g965E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 305E244747;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0627EC2BCC7;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=N5R9oRhQJzT3W0fySZmS/tE/RBQSqt6xZpQf/jxTvVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mA71HU68Fqq043Dg3G3uzdUgSs9zZvLZh3+sEbK/2klQoFnTXmERKQKyQVi4kYpnp
	 FzBAJlY5hhFPmEANZN8gAaN1cm9D/PVdlCmJKaaWvoMLc0qb+sqTrz970mgWgiyaoz
	 6oHOfIeao1HbOUPcpB8b0malnCNXc7XV8AOXY4BuvAIb7rn2XxDRsuvLfrQRh2/VHa
	 r3LptC9AO4t3QR+xTjAo6UIVY47Bjkn5zWd1fe2hWbf4jNMLme2JamPFr5VouA22bK
	 TBEGUujvUPz1z44+k7g8qvApNY0AJuebvE1okJPlUZR72/DFT77qddkdeYTP1BtGPm
	 61nyCc4PLSoMQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC558CD379F;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:32 -0700
Subject: [PATCH v6 13/43] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-13-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2558;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=b2U3rQZtoe13iK85Md2FTyXx66OuI05q1gqdIbbHlSQ=;
 b=UN/8Y1orfcMwyEZH0S6RExPannjH51GfhVxr5vzN7x9jmFkjvni9/PmzSMTOUzMaLZLxQCqVH
 lSEBC+HA0RABt69qVqqsoI+XK5xrvF6Ruy0bRDp9YiSgwEBHz9IOKpv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 6f5yeheyos1q5nqb5j5gjj9bjqy8xaiy
X-Rspam-User: 
X-Rspamd-Queue-Id: 509BD100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778185375-420304
X-HE-Meta: U2FsdGVkX1+5+k82m9ADTsfT4XzQvEg/H4i20P45Gh/4OGr2QSqtWubiytP9UvCT6Hn8IwTC0ijieZJtYgrjn84/5YNOLAG34ME+11/duSw8Xo3cWDmhwEbjhblx/cp3M2x1tsALmn3FBRiFh91nb5Sbt+R5kTdKt0/MhuoidvrO+6yXFZZHAshB6MHnGjq2eXV+5s78632Sjqkp3M3NrBcjzx8/FpxbMJtHpduEqgFq8Vy74NmdOY2x5GoOzhn7ygH51I4Z6Nx5R0L0SLVLfD2VctCt3pgZEEIe7AYNozweZhAARoJ/qleMmREW2hd6/uGkIQkaYBBv0KmP59PAeh5Lwbh5e6iNipF8pUX5jFyWv+i1UlMrT7kQ62SqUD8Z2JtDtMF1mf3SZ/FFp9cbz0UMC5Z7U6/o8PNxklm5RXl6Qn3GCDsBCpE/GaD3XqiF0SgvnPLSi80I5ULR+LuI+pXrJdG8iwEf561BKRtK+hdTGVJ8r5F9G6wS7nNi7L0kCyIUeBKMRLeNGQAuy4yYn89poine3suSoTBhidCgy+EIxCQQXtdSgkNBHbJGkOEe9BbBKXNVdikwy/Ax1AX5r6nYiuPO8quH60jJk8plvzvD1fI7vbLdrL8llacGIG379hV+1zs54KTuhDCiRektcxWK+o6WSebXhgwmeonpfkfsT+LyOsARwA3z9rGaGe9tIqZgp9qtXI3V1IUS+dXURtkfNpxXF2sTF7z8w9mGmSlz91E9aCNzVwAJsWXctHkdFcx44oEhctAVR4IjG5tCMszRYwI3Al/RYzOd+t3R2kJmtc7RamY2KI3MxY91Q/kQ4CBA7mVuByXrrRLy2cj5HRY1dZ9FNOnljCoGYRnbLCU0QXQgWja2OFZSU04lOEyLu3FfJwt+Fc7AqBIK5EWynmfYwBeXYQ8AtXLNoaSM6qEXFHfKVyV2A0bBtmC1C/RaNgPnbLae7anETYSnQ3e
 aoALI2nR
 ApsYTLMZ0vtK+K+ylqaxKakROtOPg16jqpSsuZ03n/sT9EDG2GjQtaGE685XhJu+vpX3BOZkfQAcL8jiJh1K0vzfTgjKKCTcNkE9xWMRiE5mKVESfCieziJzr4BlSXgCXdPXAX9FN4LU8G2n6hxt0GjqTu3pasgHJ43qAQTGaJhTmU9RoEeGZOM7VGoHEQj+ASasg6ykHNBdj6raAwG1L4c0dXWXsSdO9Z4rbB2EgZFRE+AMD4FRssPn2Qr7KQ8wkU+IM6f0yq53PJ3BoaH1zsACluQyBGzeFNAdJuIFaf17rHSFxkg+ofHsMx0PPXux94KsJCgv8iFswCCts8uRMC2kKF3LnJzdZ2CPT6WjFJuW1W8YQdN8Y7TwB0vRJGuohU2TYAGIJrS+KOwowF9EAOGmYjhP8snB3tGGxC6vwav6boVJQ4TqMEH5j1HFAjo82/0F1nwb/dsnw0cXaA3DlnXPA2g==
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index baf4b88dead1f..034b72b4947fb 100644
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
@@ -649,12 +666,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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
@@ -1140,20 +1160,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
-
 	if (vm_memory_attributes)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(&gi->attributes, entry, index, end) {
-		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,

-- 
2.54.0.563.g4f69b47b94-goog



