Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEFBCD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D846B00B6; Fri, 22 May 2026 20:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036466B00B8; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7AE06B00B6; Fri, 22 May 2026 20:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7BAB6B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 892321C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:15 +0000 (UTC)
X-FDA: 84796772550.08.508BD60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94BA2140003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aztCcMSh;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495493; a=rsa-sha256;
	cv=none;
	b=PDn5teKMpYDUL9Ga7bgirezcmdklIM9a53QT67M7qzRpsLVuwKeZS3z+bXMwCoHUHpKMKn
	ZgTovIPv1IcRmGN6hyLPEZoFscpnjqWSo6i6bDSV3UQp9KFntXBADfOmPVhmqQIhEBGQOk
	201Co6jTlPq6Sk6hYvoy6dpotErjYjA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aztCcMSh;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495493;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20rVSE4IrZqx4mVvdQ5hK9XoyukBcBSnvtlmMW8DaMk=;
	b=IZ26C1p39GvuFAnx2L0IkO3eyqZqC6LgSQHe6WhRPl/6yeaoHplRIyXLm3QaTw3zuaiM6g
	gpU5ZUh8Mjh2jWuPMtDSGBCuU+y62Xk/Wyao+PrlbA4baGM9xvbOUxMbz02emgeAHR+QvM
	thNSiChDduO+D1eDojYjG0irk7VX1V8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91B12417A9;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 311A8C2BD00;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=7qp4zMrNzIsThD9ZhrN6U3AlyQDi6Rwj4KkahGCg/Ik=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aztCcMShnbOOutZHbeaSEQDmvr1SMIIcBH9mnD6hpPoyzCYCgehy03ZesIBGkFy2B
	 AbBRiHidQxalC934yMBSltkTZL+JRachPfgM0Ue/3a++KxzO5rQPMQNW5qzd7AKHWP
	 TAK+CQn+bEC7ZUZpJVb+y9iHbrzyvYUJawmVX/aiW4GGkzfN8d5q6Mb8lh1MVXlNoh
	 DgqtTCU4n7DM2yTXwV7fTgozbv8pmYInaXYJR4spbMPRmwIbdT+m2rCTAQDAJ1TfN0
	 QrHJ37SPGmJCIpqMrPpJEvz5H4zXSrIkU3xYnwgo4OtARWTdrSW8+JwZeUSlW0g0Ui
	 L7LMB3yNcIvtA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E00CD4F3D;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:04 -0700
Subject: [PATCH v7 22/42] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-22-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2867;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RNvMuyEG81zAjIH6ngsYAi4wtfdbjpEfP2b7U2HhIp8=;
 b=Jkl9z/IG9o3DTV9dsZ1c0XCWBPN8lK8b08doDKG38G29qtueGYT0i4yhJbhA9PDnyvpYXt1dF
 2X/Mz2S7AlXA96lZ8ff9rqUSTNiD0eDrguT2M4eDnCgNoD6EA9kW+lE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 94BA2140003
X-Rspamd-Server: rspam03
X-Stat-Signature: embimmya8hnxtf8itsa897ntsdfwndps
X-HE-Tag: 1779495493-815429
X-HE-Meta: U2FsdGVkX1+BbzMvCgmL5rD5kEyecUrJVEkD75Bh6JiXOSKMfOkUgT+EEqiDl2zW9ClslvemDO54l8BysNMpYazMSd8n4ZfJDaqkzAfMMq3l+YFWF5GugveFpOuo0A0nFf1CxSO49uPRCDS1WIWLuHsbYbuoBaHxpQB4Io0C/AMeRcZyLXpI7laeSaO+t9xFPfZBMpDwUBLs2YAPBD0kwjvDFFmchlrvpiWiTa+M+XJn/wLk2xHepzjYj80XdQ/msK9oH/qah476r3b+NNoQCTDZXkcjIQ6FhEDQzx7OZp6LCouppXZX44G7y8DjFx4F9igZHHlH8ANfXfZ+cH/k8+YwX63NAaDJ6RCbZNAXZvuSWksyqxDRTfhPsHMixJ/699ngsht2O2QHUGRKyATrjuMMVgp//AI+byQIRxb8fDXXhSSJvDTs0huw5z10ft57ZynA1S3sN4xHx5nfadWyEU71Q+lcqdMXZ3zXgOxo2OEhelGExiZfAOhXI7Ib0gW6PIFNtSXedv+r8J9zBdc7z4y7I6NSO48s9af1fJB8YWw6MrTgZ+PIumAI5jFUZksDblPR7rZN1ZrCTYxzvVEsWaTRFt0DPW8Yk6wOds+h1vcMmJseZWMaaaZGlOOxuk82VmVYlMUsrVx3nIyEujAGUGCkRPMErXnSbJkmyX5fYQONM/n2Zs1heufcGWRqvIDfCh3Voq2Wj9Yg6xbatmzPKG4fdDBlU7q3p3jm5m+VNfL7YcdvCdorGhdWYu1a9s5DMWqvnlZQ0nG1ERMJZt2VahqmzLEWLJs/YMSsDTAKRed3jGBG+705T4GWhD3cUJ3ByZqCNQ6GEuXlHIKz3d884yeRipA7dY5kHj04CisA5iKfBbQl3F0ujK1bYKzAOvsVYa2Grw2anSrFAcPKBqoWf38PDKBNPxW2kJmX9+GBhXMJqwWK2KumuK3K/ocFMwkRh1zabXk/4mlGMUJnh5v
 EIAs85fq
 oMr770cellQt8QEyBanCXOAnAj8yw0jaDXN1/mOr11KylU7XQQOiUmhsSryGm7390kvELW5cs1nw8V4YxVhUQCdGWbg8HZTORUTgd/2PJmnEk0Qacs574oHb5+afngJDMxAqBkWJAQUQhdgcy50y6su1EgmSTa2zzb4hAU3m7LQi9PDBNzGmLkMwAhruHryflguzO8ECb0K6pyWF/KdZ0IwL/IQbUs4kJ1o6Oc/YxmpkgPTnzuDMV0wA9KraYnf3ggRjqEOo65/q6Ub0QF+JScKOgdBXPnpxBGgV7JXPA1wCuxKdOdbq3bf5qSADxpE8+Jh5ZjbmI+qoaJLcL6V6ifK3KkLVulKntCnAthLtJvCRDSQnXlI4lpQfi645hPz4xmvDHIA8Wiq5JOpBZp0On+CZO9+c4Hm9uBiqZ
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2a76eca7029d3..df73b23a4c66a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1054,6 +1054,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1083,28 +1106,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
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
2.54.0.794.g4f17f83d09-goog



