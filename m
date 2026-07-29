Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A334FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235316B00AC; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEE36B00AD; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE5E6B00AE; Tue, 28 Jul 2026 20:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8E846B00AC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DC9880514
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:17 +0000 (UTC)
X-FDA: 85039945074.18.C26B4B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 61AC240005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jnOJWZi/";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285315;
	b=pToerqa/TPF955pN5UsXb8LRtEOdTyk62O1bCnAf+nYVcGVZsCeo1/6ImlO3/ZXeF4KYkz
	z9jKCNXz9GjKbmtYbLq2DXSkslp2xm9s68T1aghzkOQoRSdWDuuVlZVrEQp3oX0RYTBR4U
	7sP31D4VPOh+0bcO/Y3/NTee/OqsqVQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jnOJWZi/";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285315;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXXKr24NXJL5xFWQVgIosjIw8Ad2MctOUNmFKvnH49k=;
	b=Ke8EDbhFvVeeHUPS2Co8JQr3bY3y9cXZpnSiMkuDxLbsKiciyd2UP2vpcJpcRgW055+rHe
	I/rarStFsV5muxbF+25kHJrMnLYT//Qn7gnbBn42YzaJcZWvSO5sP68naWZ3vjz1ty/HAG
	lCmmNwoXFLDtqArEif0CKUlAiC8dYnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB47451DE;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC121C4AF1C;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=VQp8VV/1HjrBbDW4b7xKHc9A6fUmeLHK+Zex8LeUIVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jnOJWZi/9QLghdeWe2qz4BxRG9alTAk6I30prSokkS2sxGT9Ijf8o2sLSnbaKGdp2
	 iYoi2Wq9/B3skmLwrZowOO7pgj4wpkpSMIMJbLTirBI+mDRUDsRbRxkUDq15mJnL3a
	 yQxA3NOhN4OcZJQgMopEJchHQRqJXLlYHuCEThTH2Eje9+IYxTq/M+6JrXcFqnwrWm
	 Jd8y9ZRI6Wjy76njxU54xPkqUIo7Tul7GY1TxTRuZKil+aoB0PITHIAtc8dYXqi/eq
	 MysJ2xnLIeHlC2y+ngqyjyn7oVoaRHsu9UeLbCjvduoJg/vEdfKM8z3B1WPTXL5Spw
	 dgNZgqaxT+/tg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D15C54F5C;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:12 -0700
Subject: [PATCH v9 13/41] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-13-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2782;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VCw8XceJPrjTLah5c+6aK9kQo6IEla8VXHadDNB1FcI=;
 b=dcBMZOr0ZBpW+kNZxueejs5pg+E2UIMJT+1ewBhICvI6Vm083tE0K24FdLuoGexaDLE8ccRD+
 CED+onKhmkZCsGNLk6P9uXKblDRgo65C2kzAuAT5L5xLYT5Ht370hxA
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61AC240005
X-Stat-Signature: 88xsojpqdogyi4eosyuand4gwg9e3wpe
X-Rspam-User: 
X-HE-Tag: 1785285315-12431
X-HE-Meta: U2FsdGVkX1+l3GdS91zh0QcTTplxX/wzTw3fIIQfVTJrRIosmTHU9amSfH01cdFvv4DMP0DquHjY4ACDXmOl74pPO91Jdu0sCQhOPbF60vfsmzRu9eNELm6sTbaaqvqcp6DdT42b05dDVBOcua9mGA4KoN/qwuecP9hFLIivsmWkAscdY2i/Jrhhc7EMwGAvlvjBmjapZJ9VvPbNpPDEWjp6unxgt5O89RuUdNcGC4tbz615s2gRx+7MBgSEmk0Tsln/o6wcFteI7B0Lz2NXtbRqqsCg1IrtRClCz5+g4fXysjWKBhEPg6TJPa+XAfCpLQ6NW/zrDamYT1oBlnZ2OLjvqH0uk+T8yofgU7LSl4hGta24LwKme6vumNSTgA5OR5Rr1oXutORHLowGeP57yN2pQpQ2x/KqXct749KwnG4KD6UV+xe3p4PyzXN/tt93bGrExfw/RrX9T7dUaih7+GZogj1OfwbZ5UkQ/9916wC/sFmXnHW7tE4GdNs+9Tk2TIzTtJSt6jMRa7IBd5eyrBXRFJMPSAagR7syi5Tp7xZZvVU19obbo9syeuSkeFP4Zw+zlHTfDmjkQ5KFG80qfoznIqiG9FcaA2nJIQGTz7OHri92A/YRxSmzCfz1yocwImG91a2wJ+lMp44RCksNtCt4D/NpVKWUZPg8t/hl//r7228Yid0qZTTGACiWGMtHrDHgUjE/7EFaCtZyX1cE1SvQ0JBAljszjsriuzEBbiRhfsIqbuk5yV4msGJ4BMclheyORpvy+cNbVNHrEa30ZzYZwjpAIsHovzg5bBP1yZmUdyiXsbnv4P8pmdvdDwRNBRM6JDSej2xb4iuZqIHwX5Xl8dVod/2DqykjbLOlwZsIgRqA4CR1yE2dKEZC+gWD9js23ysO7ggllFx+uVBT3zMBfJOyKnDcTo2nGSlsjPYqREz65zj/V8Fifbzrp886adidlIOu2T4NM/FsshX
 Uz1KvI0H
 /fQC0jOVIUhxKX0aeb7AkIW4gdKNdgAraPrszJJRCbXJfsH/9yrjIsGDhDcaOh94StiWd3jpe7C/cgKDpheEEz5opf2DG17DajKBpRkbDbW5GQXycVldsTXrxVGO5gSRE3vLB6bqBPGv7lzNJvu0zCbGJ0DTrO/GpjGhu35ZIarQ46AKFJ9XdrogvQ5OJMhvq8PXjse8gtlHZIS6MqW6BWh4EwL/K4frvt1pxpAzVaOjHH+wtYc9O1Gn/MjPZTPn+AHj14qsfL1HXOCG9oucUGDQug2it5ECWGNx5v5Dmv2Vcl/lMpost2X4J+YJpv8UV/SSze4fLFKk6i5l5AVlCoBNgzzKTLLciIP7z50HqwzUOZJCfzybyQPUFvli2s6Vi7m9c2/Iof560fP2vvaZjl0v6If86005pO4FLXnIX7yacOA3sMbNcOqpmXUVavsltQoniNyj6vBIu3BUUQzE7Ry6mCSZTMf3u+8/W/iiDlivH2Ci8QLB1wkU5qZdXv7o9tZu9oLp3X+sT6aGoLRGaIz4ZlvXG+pIZV0tGrmrHrv+3C6dKag6HO9kuHB5bXsi0JryJ
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
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 612fcde4ae8ea..928fc7f4a01e4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -94,6 +94,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct inode *inode,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (kvm_gmem_interpret_entry(inode, entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -611,12 +629,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {
@@ -1107,22 +1128,14 @@ static bool kvm_range_is_private(struct file *file, pgoff_t index,
 				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
 	struct inode *inode = file_inode(file);
-	pgoff_t last = index + nr_pages - 1;
-	struct maple_tree *mt;
-	void *entry;
 
 	if (!gmem_in_place_conversion)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt = &GMEM_I(inode)->attributes;
-	mt_for_each(mt, entry, index, last) {
-		if (kvm_gmem_interpret_entry(inode, entry) !=
-		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-	return true;
+	return kvm_gmem_range_has_attributes(inode, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,

-- 
2.55.0.508.g3f0d502094-goog



