Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FE3C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54056B00B2; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C159C6B00B4; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BB76B00B5; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 803FB6B00B2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E72A0327
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:35 +0000 (UTC)
X-FDA: 85159671030.02.2012C6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D275620006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMKT7i65;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135933;
	b=slIXfP3aGKUooYZMhLLROLuXZgBEV7I+JX66T5yuAFcPd/eHElby77pVkFOtXzM7pWYTYQ
	tp3NPqqLIKhs2bm6iJLxRqTxfB3hobA/7EWemjRN8ruJUl5X+5jrLWidLz8YBBlN2LeTN6
	bF60JYmoaVu8cY4AKzKz+qAd0ZlmGu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMKT7i65;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135933;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUTZf5GbQa801yFUuZwSFC6XEeJuab+R67ygJwsyi0A=;
	b=PxiWcf5Es/z+VOUgJsNFB0w9UfwOGZEM9eOASNTqKVTE6kNOUWg3hmKX0QWBgN7kzwD+LY
	LyY03udoyKUgC6S4Z6CYPQT0/Fa1yrFkl7re1w0Jc+NkP9roo5iVlLQCpoPwwFU3lznG+A
	3a91ieGbB8WSKkJg0lGhZTFPf/AWZI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47AB3448A8;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2210FC32781;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=wJ0HFZ639XCyCJUINstQYMk/aJO14np7PyBQNhcLW4c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KMKT7i65k/WsFlmyDROAB+p2TxV5AT2YqWmFO8F/kkNy+psOVgqFQSuMVDQHUCcAE
	 w0nRpVO0OuvNRxZrMB3QmECirZwuZ3H+MC4v0aobw5RjZLjg+Bv/g5qhF7Zh/cU5t3
	 UIgreUwECiomF/jxbrlJG+RRoY/xRBph+8P9LUa6CIUjFE+LlrNf10vRtCO5XDw3xd
	 EvbMRfxV1gdAxI5Fpvediv6wX3A3jMwyXM8emEwHhQalNJmBTvSa3HDwDSZGayOozW
	 PTMwxI0E81BxWaAJe9HYOVGjm9hS0y+21MLEWR/pD+I3v4RXbJTsV4IpguLH/6JQUD
	 YKpwUpDff+pew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC78C61DE2;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:26 -0700
Subject: [PATCH v12 25/45] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-25-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=2916;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=FzqOYqjoRqio5Tf5GMzyqkhVO+XY7bfbFLlkq3H6LaQ=;
 b=JKi9QkjIbWgmEZutF4Q114HPVnpKdnnCJthVjkvj3BeW4MpXotZ/Lfvs9fsNMGSQfuVR1qof0
 Ju2ph/EWKJQAF3XVOFrleCZghv14OwSSWO0BT/UqKjcOhAk++RFTpts
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D275620006
X-Stat-Signature: kmcpbj6nmdosoy7m4o14cshtqtyg6n4a
X-HE-Tag: 1788135933-450329
X-HE-Meta: U2FsdGVkX18BWzyq+RPPs/7VHFX6hJ15oFe1kRwbLiEV8mr5pM9B+EJZwRQXjx0mqspvdQfflsX7oXiKrTOLs+8kAmbjEGci9s+qpSHQHoBK0inew5DGql9P0v8h18FFekgJzdE/HZeKZVXztKajnBee/puIp1Tq8Nb6qfP0bQD90MilMJaWaFgQh3rZRtlSSbxaeXS63envmo++c1jjx+8mpsmcjn63DddioKXh0xLNei2T6o1XZ5kKKL9I+5HEDRev/jNbi/oQRd8YdS5zMcmdzYmTcCPXkrdmxjrppogOuiCQ/4f33aIv0sj0ADBDW/v6YdPlmbF7LDzCKloTLhpLLyXEIN9i9OWzHGbtemHpDEhFDsnR7RdQC5DS4XTx127DJshtW13+bb+NPxyz4XsGu9F3sgpaqI+ETineKmBKtN3AC5CHUIlIW5k/rSNscI+L6XXPy42lVD7V/q7lUWDcYlSULdVR0LlfdsLKeiPwitLrNMkxYFUjjYZb68T+sfv9/pJknge2+lROOZSJV26eeZpQsQgzyd6vpUxnGG5JImsSEXTE1BvUWhGqBvC1VcWr1NZkh0OoEcucxL3MXNyMG1kVPqWWAMMlFIxhgKc9pAHiAcM2Z7Qhc+pzq3U4wDBU2YYhQxoS1D5X9bAGrLAO7n8wqj0cJty0Dan9K/gPM2huKrf4q6FW+kAQHnnHenMyqoHvwmz2/CZwF53WWub/XkxftICcot1VnkKNGZECj2p2denIrScuoXnaAeCop+WOnhGIUTw9clhTckgZ/1PDIPeY1R3Xpg0oJBMI4z6YNShmy52+gew6EUyWcDXUvRMpBBbVPSw9lJn3dgJmARehXBnkJOXQ263HnGBqo8PONvJQwtIbaBgIUWPZesqDhfGmRzTqdpeGI7XJBuVNFuPGCqizqLnDI3FWZmnuObNb8SHROnfRCejADZoL+WnjlpWtcx8meiE2hyB+nza
 iSWcFii+
 F2B1eI3gFwKTN/l6yqsoBAOgeIMoX5m3sdV6zqNfMeD6AZjb99UlaTzcZJrlfTC8BYAGno0IebjGfBgcT3MAALMof7rnDHYb+hfR6iAqsUkwYioChve3L9DENul2DeUb7cDKvazc6iU8UsMz4CTLngTp8QgzokMf2U4+8dKlr/HW9UQh628IBp3Zygksd5arzxnA/oruAqC0K4vbNdbqQjeNAfhIF4pbfENZ+fY/xDUCWZn8u32DQLsZU9WgTG0MHFrHrTCZ2Z7dxtaF2ORln5u/z3sxWbew025OvFndYWPE5QS//notl5T2WLeqt8atKENPsKPAdQKN23nBuWcCD6O6iyXPhPHHw3Ajysxtv/J3KMBAv4xPwnjeJDYocy+QTG1dRxY3cy2FypXnE5oN5Rn7dwe3eGPQlxi88sYKyHrb9wDG4BciEhGNXN45m32vqFOZacNmIPrrIxFS2yeBS0dv8UNINuR3+U7a+
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.897.gb25b4bd76c-goog



