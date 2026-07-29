Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CB1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51ED6B00B1; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A1C6B00B3; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF18B6B00B4; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C77C6B00B1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21489120474
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:20 +0000 (UTC)
X-FDA: 85039945200.07.06FD52F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3982140005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pnrB/S3q";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285318;
	b=6s3nmjhDDNtVg/3sqapD9AAzBqVkuVk6bs49Hs2Iye2O83fx/oCE40taW4+yEgq/fxUwzS
	g4GPwdFobeMNcQtP2wG0KjrnH/iFASBdazDqk6+UiFSr6lsLlRm5buCd5O39k0W0p62pi0
	txEFt2bwKcuwWJpavG5PBQA2aEJ5sBs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pnrB/S3q";
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285318;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAQLreLAKaexC04d7AT2PTQegJq4PMuNHa9g9QE51mo=;
	b=4ZTB4pZ94cKXVpfkcTVmK4MaLauuRVADbhXHHewPQt5x01y3Q/qlqbx/wUWcBmIGVPJecD
	ZqrJtRc+eC/3YWLla81kvVywRS6yRR+4lzdzWBJxCojjda36qtSuknd0fUiBWJeXMBWekr
	AfAXPdvoCygzw0nK/R8hXlowtGqB08Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 288C54524F;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90688C4AF14;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=5l7ZdRN6nZWAdsQqiadKWiYBnzm7msp+h6C1StnZBJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pnrB/S3qylfBYO2MW4qZm2D0GReoJWsjWZIMxwScdar4zuGo+DLWIWjTmxSaFQlDx
	 4IuOajXNRMv7CzPGMsfCxlfLQ1Bm29wLNQ6hkvmZLTFZqbtlor/I8KEuOjsH8ecnod
	 0RJ2cItmPK9ry2BEZ2vnKHzQUo6fep4vHLF978oO6hN6WO1wv3G4sPfKwl9DnjXhNt
	 oCaRgRVtSOTPBi5E3FnkZkOGfSORHzbI22kesuqsbX0+MNOmj/bU9wxJCiaw3StFUS
	 wdUgAHAMeTbZcGK7Nx4xSQDzLECmWntxOq0/FxO/3oM0Lroegn1jV0NAugmrlPkD8E
	 iDDKxuuotPI6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B2AC54F57;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:21 -0700
Subject: [PATCH v9 22/41] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-22-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2911;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6y05+ITrnBeClNJYAyMDsMqjEvyElgnG7ndfbM+LDTU=;
 b=FvO6M+SkBwo02hmHDBV4TBNLQyGe07vF5ARK8agucKjTgT6+y+h0/kI/w8hsLgP1cI/hHVShz
 l7w1e0BDmovBQf9BJIvKnNYBminD0wN/y/ARAQPyR/PTNThxkF3wh5L
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3982140005
X-Stat-Signature: 1s7xjwek7ebr71khb7fx4kzypk7qb35s
X-Rspam-User: 
X-HE-Tag: 1785285318-566375
X-HE-Meta: U2FsdGVkX1/mxrL3ataItiFCkWeUxhRfgcb6qf7qaG1VXPOS3TSnEdRJQR1cfwoOkhDkEpUVYGHdUrT1PRlvm6aWV8SkgDPqUSFEzk7qJmC+swujQlZfG8L9h7HV6xAAQ9EtKwI9TFqGQ+P010koEJTT9nTZRhNNujKZBCtHCnLjqia0OGaRyBV8HEpeIKbWAQAyYMEeSNV8Po4VWbV5xFSGpdOaYcGajZ47OwKsiNkil5MLaEriskf7nkaxYjVv9dmy3oe4dzeMUnUKcD/gjEI4oltqDOifjIJkTz0EMJxZU7Sl5FSBzemNt0vipRSVpDgxo5itWOc3LsvHMMsyU8XG187mcxiBQ0uz5qdn3wDBhCMO9tKFcKW6MrgEk0Dd8nIYiPLZhhksFMQgY50CY96HnJgApZODfLby6jn2IVo0pOIwDxFsfmX9lYl1oiM5Cdlu/Umobi2lI0oeFLtxdNZEFVuDrx93xn9/DcBGdfaPVJ8f5mkCa0VSMBC0SkmkLqF3TCMOoXcBJD7HmsfL0RDyPDanFx817RZ4W18lLiLlHYB23oPea1v9UlFxx6zlZVLZAGKh+Or8NUhu+U+7hYGGouyOgMkmrZ8tQLj6in5Omr9oGfTsy0NIkNDDMPmbGiV6ZOYysNhf4A/eRgBD/jMIZpY+sK+/YAWuiY8F3F4aPqpJxlmPJfVeV6ZvZc4j9L2HGzYjvvDfa5hulx9BTni0KkCqdOVSmdQN9XZSsZrKQlCGXXm17C/QzYseQUdw1j3d0XMI52mvBWT6D100dqPvk8bxwafhPRgF3Tj3zw7TgOltYpiNd5C+bAVGySOYkAzgi5ID9KLzUvKn7PvwX1sCwYRRgLYzMlJfGMvEdLig21l8YiLlUyjwk3QAZ39KB6vUnIx/ZFlvPI4uSB1H5//xd5X9oiMGIq+ufnGQB79j7voycIHF+FrpfoorDTSDs1sFsYmJhm3DhOQHfdW
 BRhJQspy
 +YLchTLQ4jRMnPnWNOO+wDh3v4MW/uMAtetmWzKVm+dk8M8o560vj/NfcRY9LLUd3Kz1YQr3GMXCgsCpVzfUE3ljTiOjSzt2dE3Im8XNmny1VQzObZoOKC819S3XKxXezvAHkpPnG9oL1UGght62G6XYZWlnRKqj4yLKNILKQztygcuWGp88V/g+vaiBXJ6onzaTsm2Q1U+v+TBgL3+GZlo7s6fq3AP7gVUV6ajGYcjZe1UomJHxsVrY93rPTC0UiXr6lWZOQAP45aSgdv7uBQMsdETNJlVqoaVGiKeXuHQDJ5fomSXjp2+s6N29HBAu0mq7FBPT9tfcZ2/hA986K3S+MpBRoqkyScUzCHuLZxrFJBYasaoRTbzcSTJ/DIekGAiOt5hEOoYi1jIj28zZTSOokpMKQ0Zoz5jCYPOHLTN0IU9pQe4wXwGlH76rvsHEkmAU+zNLMZtjECigM0udYIdRpARI+caAxCxGqcoouca4flIDRsDQo2tVzY5+QMnFN5YDQZ0mj+/ncI/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated a guest_memfd instance, create/dup the
guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3794575d2ca0c..8522511c99558 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1079,6 +1079,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			u32 guest_memfd_flags = 0;
+
+			TEST_ASSERT(!guest_memfd_offset,
+				    "Offset must be zero when creating new guest_memfd");
+			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+		} else {
+			/*
+			 * Install a unique fd for each memslot so that the fd
+			 * can be closed when the region is deleted without
+			 * needing to track if the fd is owned by the framework
+			 * or by the caller.
+			 */
+			guest_memfd = kvm_dup(guest_memfd);
+		}
+
+		region->region.guest_memfd = guest_memfd;
+		region->region.guest_memfd_offset = guest_memfd_offset;
+	} else {
+		region->region.guest_memfd = -1;
+	}
+
 	region->fd = -1;
 	if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
@@ -1108,28 +1131,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			u32 guest_memfd_flags = 0;
-			TEST_ASSERT(!guest_memfd_offset,
-				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
-		} else {
-			/*
-			 * Install a unique fd for each memslot so that the fd
-			 * can be closed when the region is deleted without
-			 * needing to track if the fd is owned by the framework
-			 * or by the caller.
-			 */
-			guest_memfd = kvm_dup(guest_memfd);
-		}
-
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
-	} else {
-		region->region.guest_memfd = -1;
-	}
-
 	region->unused_phy_pages = sparsebit_alloc();
 	if (vm_arch_has_protected_memory(vm))
 		region->protected_phy_pages = sparsebit_alloc();

-- 
2.55.0.508.g3f0d502094-goog



