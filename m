Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9369CFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0878B6B00F0; Tue, 28 Apr 2026 19:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038B76B00F4; Tue, 28 Apr 2026 19:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69346B00F5; Tue, 28 Apr 2026 19:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8E7D6B00F0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:32:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0141C1A143A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:50 +0000 (UTC)
X-FDA: 84709549302.24.189810D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B33171C000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lJ8G/bxG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418748;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj0nkI1AmyFdYhtHV+1IGlrrD9oUNgV1k/yGyMvbGxQ=;
	b=6qImzrPWtC/QlNFi9UUOGtNCLmN5g0aMP0oSt8NQ0g7W9OhI1OyNmZcepZkalatguHLnXX
	ORnbBUf+YwC0SfJCmdxoBY93XcLBu+QQMgobnv6LAmn5neR6PN4NHaqM+57s6Ws3gZ6d+l
	HRIU+9Y8/MO+bDM9ezpI0VEAp84Fs5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418748; a=rsa-sha256;
	cv=none;
	b=RwUQLtxJJSIugWtSZ6kvGcRNpYinTlKiQODIMSBwQ2xul/ayn8TnwVrzqS6eQEdlPjuK2t
	8UQNLGseaW7wJlJaV9s4HkwOsBTWW3Kz4oNuLaXWowIvtd327+xKlyt0YMx5AdKijYuVmn
	KrGLHiPeZIvJpxAwQvCHQLkEyeCEMsg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lJ8G/bxG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBB5544C05;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1469C2BCF7;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=1pO/RwNh5wQk+ZD1fBh8GeZ3xS7KCNyMnhgrVWmKjmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lJ8G/bxGMXtsy6qw6slVl66aTE5rar9RS9YRdS+nkDhAJz9lR464fV7FoVhKj7fvV
	 wva1Domejffnb8zLs+JXEPfyTN8bv+XCF/eYrTtjSjaNXvw4tIlEOCwHhC2E6faDAw
	 MSR9ETiv/D8nQK8wm000gzKkjFQnMhs5rYdWoiWCDNe79O3WyWs9iR7O+gocpqQkEg
	 oyQ1WxK0RsU+1+JScpNgw+h1jGtOoodTMG+vDuVHUJPFqT1tBzCqdMAHJ2a8WmFn7m
	 IGEwGrs82VDZB7KpCicPSxXqeqcbWhLVM4LEr40MHLxEMV+ppsWkRT67glQbP1qhel
	 iLG6lwTQEyVzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97965CCF9E3;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:47 -0700
Subject: [PATCH RFC v5 52/53] KVM: selftests: Update pre-fault test to work
 with per-guest_memfd attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-52-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1278;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KB4IvfKWRwfFkGKiLiHfBqqzvyesxU1uqyWNUwL9kS0=;
 b=VVjhgfPquk64xczj3ZQLm8Vp5HQ7/Qfqw5eSlPrR4TxDyAPdMjJw7EUrKTN/v8GzsZdZ0LfEq
 mlypjrBZuRIAFMpNquDNHC/yzj95hd4pTNKOE17WZgH6fbVQ0n2fESs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B33171C000F
X-Stat-Signature: yry4g1nbt8batzyc6yadkawsatq8hspw
X-Rspam-User: 
X-HE-Tag: 1777418748-304320
X-HE-Meta: U2FsdGVkX1/guHjHRMSDv0UJeS3Y6Kq6FiOQyiWxD+wkQCpYWSymFi73NnIz7VUodyhA8dA5zHhyj+Nr+/FPvUhYWQqgqjFDADXHmDSYLLIoU51bOXM44F+E3GyXB2caHlA1JEPVsMwDRK7/uIoLJvKWKzTp+aB/wgKIx8S03UsddrHdRI1SSv/zz4Wi8Z5Z7ltOGYlzWAPRIPWGjODyXpHIa5XKNsJRl1IkQxKYCTFcqQPaoCsrwgO3joqnWU45coXXlNBH3JmiVtOyFnUFsmadko9jBihdl/OjifkRhLy4V81BiBTKhNTyB5fbr9i9SsTPUvv0DvYPhnN5H5blq1XqxGUZbHtH91DrWEaJgLJyzZY0FLaJFlFqMK8vDJTNgGgPnhd2Sr0at8zbMwauAIcrvaB2aQoWr990k0GIAT2e70nWyqBDrhuuFAExCww/pmMeopUq2y6J3gUEnmFBh7YakVrWbQ9OU1JO4cus/WFpGY2Os63+CoCtVZjO/2Le/Lhy9cYpX87TIvlPe7wMmpYJ83/b3ClEw3V8ROfNXGh2vO8vhDgA3t6JwalT38hBce6rjcCwFpIIDlhAtbllG2hYF9BKsePXuwDQUYRWUonkN3E7cOg7ETeyZkadG91gLFBqLTXNCukkCb+1ZuzVuY1I7pI0Hu80MUR0X9PqkGIf4t+y2Mk98Sc3TDc9i2M/kkc9zl9iPz8fsU59ia6dn2xEOED27QyknyywHJiWva14AT9sS67LSyZvdsNSaRZ3Y0RJtvGINv9BF8pYSdfALnTqdAcbxEYnPLudlXTZ7QnysILert0S7eOTonG3oX28TU8IuT8OV49M19Od4rmUOTAqjOunTYvS/Z52gKUrdMWsacPiYjUNq2hAPArOoLNO/GMKDj2NNf9UjSjW69lIKKNc9NRPXvCnePHiEMBpadBew350DWqvQvhYHZ9WY6pb5YvSn3jxuNQtQqrNtSr
 5JGpRj1m
 4WcJ9P0SIjTJZdSSm2ZnDb0cgjCj00oxoU3v8mLwEXK8Z4Qtp87bcQI0hGAWJDA8boPoth4HOi6qHPWxGTmBQymiIpxnF5GZ6XCJoPJfBeXwhxIIkucHu8R5wSk58JLeAu/xRdT6pH7Emvqh7PIB9s9LlCW5GXMfKv9hziWz76/J2nUIm4kkdzjzmiIBuuTzfq6PL3C7zmNYxh8dNHDlPzCTBOrKLTYuoi1ft0yYNvX4Lby4leBZhKMMyKoGtjUUGmrieMqmC8L2OHc+imXMHCI9ZQcg8vd4KKfMer1wMJ2pDsGfVmOSuwOKh3fsY6Lb62webnJs+UP4Wzorhhf3h62+lRLd5crR+7JzxiV3rk6wfDpPB3Bbye/CduW+g8xl9Jj0BtbbNd9u+4Lq19lA/xB/4ODl14vFL0xdcjFz4bMFQltB+tpucM6q47vFLIhjLis8SHmjBospU+5qo681RYHPE9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the pre-fault memory test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/pre_fault_memory_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 9d16a277696ce..742bbbca9deea 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -183,7 +183,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 				    TEST_NPAGES, private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
-	if (private)
+	if (!kvm_has_gmem_attributes && private)
 		vm_mem_set_private(vm, gpa, TEST_SIZE, 0);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);

-- 
2.54.0.545.g6539524ca2-goog



