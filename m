Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84495C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3206B00C6; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA4F6B00C7; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0456B00C8; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403516B00C6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B97D016058B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85199512818.09.D9E1830
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3C0F100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+ytrVOu;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084547;
	b=8g3EvHa/3xFWS9DQvT/TceeLwlQ5LQ3SPY2LStcP2qD22WmZqjXlGnypXUjcho1okxAJIM
	PZEg85X1kOzXaFDYj62dzBmgLfh+OvxQzfxm3OM6ZiswhZEzygD7aoYbHC1V2Zp1UkQ+9C
	uy9LGs+M9G97ZfzPqLoL5ELx336hknw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+ytrVOu;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084547;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov0m+KKGj/P+p3IoZZaDDEB/dlfSsWic3c3gRLqEjA0=;
	b=HHIogPkJ8m+OFCmF+edD9ZJFpijqLPwuZZ094SKiIH/gCZFPdVi9/kBt83lq16dYdkFWfQ
	gRl6wA3F74UxKAi7AfuMQovVgLz+9Q7Azh6pB5+6owtOnDHoe7YSnRItLBCWFuWxYeb7sE
	n8XBgx8wqWMMbYy1OAmgMQFHdJ1SqIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 517A0447F2;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28338C32781;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=vya4ZPqPq74ayNLhpTa2Zdy+9NyJaXlzKZO6DgnRbXw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=S+ytrVOulDODaku3ctI4U1cazEtNWPNz9VVIzHg4uVuazMz9yU4dn7aX4Ffw4lAsX
	 1JaITpmvTKhkCt+Ok8Pw2D0zyUBvxk0ciq33S4PNxCw+f3eoyvf41Z2XRAUhCIdczb
	 FdTmk2ShjClWM7J4cT9OGURB6STWFVAP4PaNbdGxJxEuogIvtFUihbgB14IYszOofc
	 dwLwSUySuWqeMNTVqikkxL5+/UGpr5hdmamy6ojps7S0l1VpbXZLAjeoF4SHWIffPj
	 7AEMlC8ph0epEcfdaeT8ucDXuKWZxiw66KoNS35xrE1/abL/MGV9XwAVwdqN0YLdpe
	 8DWnW4wTHxesg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12116C88E4D;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:50 -0700
Subject: [PATCH v13 24/44] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-24-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2917;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=yuo0H9xyytnsBhPo3BqkP0S3lHbAtGwhW120jUYvILc=;
 b=5cbxQXbw5zX+yBqH0E1ynEpJ7K59uWZGR369dS0fqInADnt0wxMIjSDoGwCft/hG3xWHSWexh
 hLF8NFnsBaQBVfl2eTMW1qDk7wgR631Eu7cfTQX5VPQ32y/WRbCDa/6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3C0F100003
X-Stat-Signature: 91bo35khm7t96fmr447ewut6fbs8qow5
X-HE-Tag: 1789084547-717913
X-HE-Meta: U2FsdGVkX189ajdxgVl98JSAj9jgSZVSFiPwnxc/ffqsjObCTe+tExYdxyK/HuG8r4ubZcRy8BRZNxkNs3+bOgtKCjKAkcZKsf8aipHsvncNQ0XdgosNqs63+eT+zYcpWOsm5sar8tUe3dmA1Gm16orGQq9ZT3wiWmZq1wWo2n6idVmNrZFzQtmK4WpBIYfd8GNSbeNa2iBlW0S8S/LQESbAqMGLmFzrzWQaE+VZpzzPWpsulfeZNjwJFaayS1prRCXLN7vqrVorjK0+4lw2JodRkrDqZ51NvJaY5ZhAKqZeAAwjHKUKjhZhLtiZYNbjsyoaUiL/DtU616sL7ItrgSABOOfr5mYFUUNRVRDNmGk3iFC88sOiD9AsuAeQLvA0s8P48PrWQxC4WbLwr536VLced99RYwDaB2IJ4BTvkS+c5K2ubg9BZHqv9Z7spmzOUTfr2fQbB+u74SaN0j5vkkpFdG2VQ7Z62E/h2bgGsLnBAALwCAkX9t8vt2beAc0xyQNwyFxGRWnY9yrFiJljLyIjfB+veqIbDofgDNGFHANhfUv798tMjwEitxiO79nDtUh82kuREyARBl/p3XMGvar8NpUIZ4Qz0oyVUuzVszEcvBrCJgZX9uAI3lJV+RiXQ7sulPCOuSAL3dWrkzIzJbN0s9NMCEW02r/IsTKNPkWmJ58ytvPlrLdxgQhoT94B3MqrzBfXlD2aLoE1eYBbIcmbwJUj4J0LLm2iWVxop4XoiZ8SHlb9gbCpfAeaCY35noNLlrtIxsMwLvcIIYXpnBfVO5iga2fRSrlINRKhu98T2/HN1zMRLXxiGkpDiKC2dHWjZEn8KmJCRvSlMvvSWYJwWAYs938fhCVeuksHjPk/HQ9KxKCBu60KuHAwA0jgajuAlHyNE8W3wUXAfwai5P7H+UfisEBZ1wBFbANkYACvPS+kmgH8iQejzfd1SMGYg+j/7lcITK/0OfVF5gB
 iBeWMp/y
 iDWgYK0P8OrbBHq3gA7oPSp1AmGYSXi0Ou0omf1sYoEaSu4VUCm9VT5Rq0eQn9rFNLZC4rC+NDK0ZYpQTB0UFPv3/buTo5Ky85eVTcqGPx4Mhv/P9cGB2te4y8vBFwsMVitOh+sM0rW1V2qAb57Ojsc10xCp3hauTlQ9K+3yC0yCJ1MUztSK6Cr49zCylrK06fAC1L9CyUgZFh6LqBpzxnXbEK1jmEIkZAR3ad09IPSap6MKkxnqPfic1Qfkvr47cgLEr9wzZx781kLchMUi5DogcwWjPkKhemOWMx85mvqigw14br4QO+yI0/ZQtew5vlnll0yt8jQYBCledGUz7A4iqIK3CqYfICU5ax2Pp62QKY5+X1Wx5efh2C/N/yHHhoUzN+1z0zMN+12aS1r8DcV5rpR6UTr2ffhhDyKkDNNjlPGp2rTZWhGpndsezeIG54XeFbANiXdw9ITp7PRuJ8BKl8oEUA61Phd9X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated with a guest_memfd instance, create/dup
the guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ddc047d5c275..3413d45e34faf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1077,6 +1077,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
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
@@ -1106,28 +1129,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
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
2.55.0.1007.g17ff1f9808-goog



