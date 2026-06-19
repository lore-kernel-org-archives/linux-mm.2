Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3695CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831CA6B00B3; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802B06B00B4; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAC56B00B5; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 199AB6B00B3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 748728CE17
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:00 +0000 (UTC)
X-FDA: 84894784800.25.B55D6DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 838D2180007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lFKn0YTm;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS3iem/FM/b6PM2PXqUDsTfGdq+CPUMW7ielmV/hp/0=;
	b=uCpUon3oLd8nADAZFHvhFBzi0w3n746I0sJINqqXuGTpIMQwM7+gbqga2BQ82SKzG3xxnn
	Vpmy4DuBNuH459W5Wen0FmTDdLi86bvEd8YHHKXI8xpA6fwwBrXc4MzQNBL77XC3/KYCXs
	fBEKoxoSLddRLIMdtRCxv9YqjPxvQD4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lFKn0YTm;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829118;
	b=IBydDj7wnhQUzuzd6RkkeYVZAk4A/scjDEyhdCPvotnQB9tJ4h6qIgNJdATBDKP+35LjjX
	ccP3bVHV2Y7W+hGjjPm/J8hjLghOobFva9we0BOvKJJo8A1N+f24zrDSuGc8w3MugL7RBW
	a8tSf05lY0eKKDrX0ez4lfNvMZMDyKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AADAE40C1B;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B949C2BCFB;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=4B41Gq9z5GJ5gzZwdCvhqwAN2+eMj5Ra81dZUasqm9M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lFKn0YTmhMKdwc+hh1hX1Qafa8ZXfsab3D1dDEBi03HpdcEGbttuCK5h1PBgde6l6
	 BpP5xmAkNxgdrdq8wlbdcg96t9TxIYVXW9Qd2ERHNLUGKOonJaHLYBDpXyIBQSfWuu
	 GfmU0/D8AxTJrtXykhBcd+CmuvaoTfxiSeHEMcNF4mR8fyYfBAawt9c8rZHwy5gQlx
	 eB1kBNAw/Nw1Qe+CGXNHRi+9pp/+iawqYEuIEjRTdeyqbon3AVZQti5iGR9TE0qxtX
	 Tja5vXACqkfHeudYIfHXcICNp/yMIx44ZD6ynmvFFWtNHdeGqiuI+xp4Fkx1lfgphm
	 KeoCgMpaq6nXA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F865CDB461;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:03 -0700
Subject: [PATCH v8 26/46] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-26-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2871;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=u/faAwg/gNf9llxTp9BbQap8+LhOjxvOfmQ4/JSne5U=;
 b=EgABgBpqSShGa4xs2ZQ+A43GOhaxJpm+niiYduLQfx/dXpu/gb08L+GxHQ75DRMFpH7SUp6TB
 tlF8/i5KSrABwd4LqM5Fr55TD5me3rkDxJHUaFswvNCq85CYukne4HK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 838D2180007
X-Rspam-User: 
X-Stat-Signature: a78sk9w8pknh9mg133mi3bbphwk7jgsp
X-HE-Tag: 1781829118-263040
X-HE-Meta: U2FsdGVkX19Ogsr8gGe3tAOggBKOvhvKZeE8jb8JkH9gaRGyz+7OV19vsrScD+T6HQP6jhufwVOsSukFmglhJE5wJWuDXrIBSY/UdiG1uJLK4Aqx9KVxxqltUP4QfBIuSlQww4DWbh+fbZ56vSp78s6OanAZVgnJMDBN+qRBaa9YwEwQUET9DuHHQnRI6XBE3dt9xsK6ER4b2VQ0u/BZVtC8ur4ZKVSID5PUAQcB7PqRXWLNHnsyH9RL49slwlcncsGEXaf/xh4ckbdcaJ/c2NvlYS1dmbeOsxUnWoYgfvdFO1NYffElStFPXVjTwuJVE/EW+zDV9JKChGXG0Knp+DHsiFi1k3SFqmUPdEUKutMK2Y5y/VKda8u4sq6TJ8OHgjocPLaeqxU5ZIlyKyw5MnGf+evJRVrFcRBJIuCF1aAjXm3OceUiMmqMO7e6ro3Ustj/aZbilzezAQLas7obvIvBr8lJXsfKqPSoifslPJXUn5zB3HdawmSyIEJJGxHD/oB/VQiAR52RAo9CjsljO6KAmb1e4Ln3WOh2Unhzy9hSSghMmPxYDJOU474ll4Vz3CnzvIb5eTHPJmrNIRcVpHBg1iJPDdtnp++JoWVjO5HF59FvfGV1pt3+JgaWASDhJM53ZFg2aRoyn72SsRCHrB4tlxpjjxk5/p7+yhvjagf8RKnj3gB5LLYBtVQRyBgvs6eL4d2JbslToNueEUtqUwi/5X3f3Uy4QAEodmVkFFdyZzDI7KsHZfiqj4qa024jgIQWeKc44zU9yGiKAaw3CRfEbGzQIiEQ5MLhQgP3SJz6Lj/vo9IQb+/LQPj6R1E0dLfaoo0g5XG47Ei+JSIsxKFta3d/ZcCLK6H4uqVZ8sHUQXqXkkVEoCpjQB9tC5dCGqzofj7klYol6fQdk10jHjwo37DREXP7r6r1ef/dwZCIZs+iZhkmN1YT/3n/pjVyjC3rmn1R36p+/OrOxMk
 6zrh0OPU
 sn9YyP2PzHaYnBHD7zVB7VVuCAgEyqwJn0tjOMIu+Z4mDyxATARxRtC+xqr0C9UITt0ZbLZjTgQl50R89fGZvPCbCQP5VAY/WLBUpizqk0ODuP+1GmtIv05NyT85GbZuNAAo3jir506ix4/V5cWF7anrkrK6keZf3t/71tubuDMi5ujicaZ2HgWpoyxnnPjSXhFgqQZkW3y1BV2uM7t+dyiCeCEbxbRlSVWmOaj3wXPN50oimoQdISAatPgGk4IH2wT7foVEYBQRMsB+caVDsVqffsrgFLg9/Xbrycgd5EpzrYvMBppkJX+it24osFtMp7V15f00G6aYrbjUzoFppXek8+hEthPMXTDw4my4iGfBhhf1HuC9kh8JAfIUZi4uVEe2TjJaSHsbfkWvgCylaXKvfwyuzlfOnVFl61amxHeiy4SwLTlE6FHzVzIuiOX91tzUzGZPfKClkSLw=
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
index 195f3fdae1e39..2dd87c903ede6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1053,6 +1053,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1082,28 +1105,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



