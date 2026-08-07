Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42F5C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D255E6B00EC; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5596B00EF; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB066B00F0; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9027B6B00EC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 226F01401DC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:09 +0000 (UTC)
X-FDA: 85075824498.24.9B842C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2FB92A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVtJqcmq;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139587;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCqFbkaT6XV51W7ATozIi9SGPKzZ95yB6L69eKn1bu8=;
	b=EaTcoaz8qigMeLjrR/2+yuBFCLH3khMC34HwzKurexl2wsVfvZwUMFKAbuOlQ92mKd8sLS
	doFW5Tqq5dZj8ZaMyvtjU9hNqLuXX+u5jbRHDpjI8vA1Ced43mDskEs5cO20Lqx2pSIhJ+
	8iHPsmaiFxUUtc3lOwOs94FK/JV3NQA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVtJqcmq;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139587;
	b=KBuYocJwvjK1QApaUpeXrOtI1sIShCp2vnMnjqdXGPFrjNTgbq3gniTDL2KnqV+iEwue2x
	auJ1N2WTP6m0SercTo1ADf8Z9LW8X6E3tWb1Pkl+tRmRpKwJgiAEIZPKL/4GPFzLn/21Qq
	mdW92bL0tBRnsnX9Bn80QJbWyECuDNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFAF1452D8;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 979CBC2BD00;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=YFbrmMd/qfinectFQbLr654cT8Cy/bdXVL7tUQSmXeI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rVtJqcmq9bkLtwzs/sbn/drAeHqIHXm3CgG9CyTMP5Htt3mSfq15S1I8PqmB9vKEo
	 Ow1dzTWcEpu0Cr5nMM6bLigDgaGC0RaanxxJpiVq50/OWCDhu7jk+3xSCyEImxYtdY
	 NXFTIv6GqtiLzIWSnuz+znl9AqxYXTj1HOw29Ie39gRIYM/MDwegThP7KcaZM7JXXy
	 48dSv30S0hi9PUO6zUhtd/VLAIIxddakQTZgeMACI3fKAWj8Kq79Jtb+PncEmq2/L5
	 ppGGiLD076WwT6/+CyVWPSM7grVQHZDfDapH3qmrSca0DOmoryB/03OJpCH1hNIlp1
	 HO8EwfmRbuOLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B97DC5AD2C;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:17 -0700
Subject: [PATCH v10 38/41] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-38-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2853;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xdN4ZWQbdwlWeMCPJmORdL69HRo7nJ3JUs6mr0GsFGA=;
 b=J3yaYIhg2jIJJRWFKdwmOsIyDJ+SH+Kn8SuUKsMZFCpJw3ZimQOG+05L/TtwXsEHYGOsRTh0N
 J7xNFvIddtEDnXye5qlJSO8GpoSBijHGfw80dk1AxzUzj6TG56zbHlY
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FB92A000B
X-Stat-Signature: gbxy7y16y9gpzsmyz4rzs1cikm37gybw
X-HE-Tag: 1786139587-652731
X-HE-Meta: U2FsdGVkX1/C9EJcblFGJMSbQpRYv9WbE3ryGZkK5Ta0UEfJ1+4ei8Jtca5ShkO/Ox274ijyTAEp5y1IYdJFGSEv3xBu5/H6aEaUW5N74yZ7V+pnifH8ooZxoWaWRAUs4g7ea5+kl7S9S5JOGh9q4shqF5Re+DhCNjCRH6ipSNkgMYNZ3tVMVh7OqxJ7jkeINQQtH1Q0Jl62omAJAPCjCK3lGS8W+CUYQ1nDpfUnLMdoEOLBfxfx0zu2rajdwTXRURRmdA3yt73ldBi24xomv94j9fk7zhP+kV08J/DrmWIved6GcZCHPJC6lJD0p6BCkxbrhbQ7w6SllFEk0x86lHTWQQWHMuaVXX37IKOm88VzvVM6n3OTTsFmOfDNBHSW0ilTfINnTaJgydTC4j2odoYJ19TRHGDtDrC8Tnss2btke1RGOLkA27Sj+o77CGfTJkpBRSVNm6LWW4OjQnx3qxagEaKBo0mVZHMdwqIJEj1XxAKqcs+USNfU+esRXCSCiVdDShbchqAPMuEaK+Jw4XOSIeIfViIy9nQbMQN6xtT3JPPV9RhYCSgseRVovDFNJqM1vI6bqFo+ekD+Har/reeRhGDT/gzab4YPIgLlwDCinmFApf3HVnre78eGRfJl61IptO+IngaHCW9iU7EOEzC7ILLkI7zakupbTejRw5daFL/yGw9NFOB2ug3uhAAraSolyX+un8vrOZvZEQiw6fwvw19yC1FYaw9v/sGUPNCknF1JvGZ8f8206/IAkLt1y4/eDx8g2boQD3y9XZNMLIAkY6yn7/2oe6jRhklROIiMXWFvr3bESEpfafcO94Fr/E9EUGgdR/PBitSjzVrA1G4RsDH27YAw8F04F79MYRTNchlwd2fZ32xiKqbNH/Id/ibzeUDY6oEw++zef46y+25ifKikKSk3646w1c8N7j6jvvZqpQ4AVBWwHl1ZTvI9//boLtXh32SHD/n3gVI
 CaP5DtKi
 oNX3hJPR1w7Tu0oLJCAthdeFVD6rKm3VHqyuOSk85Nph7wd8bvap4ubMamqHfJCg/HwRowKxOXdBgmJWPiTJ4vJOSuOoryIIFgUFnQ2Z9/mcELdFQYRimnjJmL7iazZZIt0OGQtB4kcD6G+hHaQfIvDvnRA7vn6S0u0l/rjlvvRVJoC9wW26uN78AJnRdoVqcgkOs7pkEPop+pxkgaw4yP1/BfY/WA96n4zVlxlXLZVjRvqJ2nlFDNHVvYAkdTWvKeAqe7uu/Gv/IMBgaou7b+H3ZwKajUBlQhgM7v2hV2PsQQ8p3U7c0QWUGqTGkBLc/YE/yX+NTZ8BGP5nM4oX8CayP5OYIkTq1pLjAwCw39r1BddawPgLFojQt1hZc4LBirNw23VNM37ROirndBJqiUs4HnB3rU3yr/zzYbCjMlcbUqpkD+QgjH7FDLucCJN1SUnZyj0QfveNBNqOb3cVxskjYo3l1LSRtYGaF4TnkjryIUqff7XPDoxoUvKA1+N+KsRzt0HcMKzBaun4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce vm_mem_set_memory_attributes(), which handles setting of memory
attributes for a range of guest physical addresses, regardless of whether
the attributes should be set via guest_memfd or via the memory attributes
at the VM level.

Refactor existing vm_mem_set_{shared,private} functions to use the new
function. Opportunistically update the size parameter to use size_t instead
of u64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 46 +++++++++++++++++++-------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 795c9eb311071..777fa3dbf88d6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -454,18 +454,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
-				      u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
-				     u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, u64 offset,
 					       size_t size, u64 attributes,
 					       u64 *error_offset)
@@ -532,6 +520,40 @@ static inline void gmem_set_shared(int fd, u64 offset, size_t size)
 	gmem_set_memory_attributes(fd, offset, size, 0);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
+						size_t size, u64 attrs)
+{
+	if (kvm_has_gmem_attributes) {
+		gpa_t end = gpa + size;
+		off_t fd_offset;
+		gpa_t addr;
+		size_t len;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs);
+		}
+	} else {
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
+				      size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size,
+				     KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
+				     size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.55.0.654.g21b8a5bc05-goog



