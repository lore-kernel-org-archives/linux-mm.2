Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81154C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27126B0088; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE836B008A; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6C46B0092; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829406B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3CF6803C7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
X-FDA: 85159670484.20.84088C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D31FA40003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/DsBHmA";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135921;
	b=woxt3zEDI1nyJtWcXbNi7+nklZRniW2/5Upu83Xk5/dgBClAxbTSTKl8DlniVqN3WB8q7X
	9NQSnEWlpqj7FpnkQXbJ4nM80sFbu5qiyDbohEzo1FSK0J4/uIeieTrciOhrYjk0JNhazN
	FnF5QauM3dVlDoFmvwyhteOrCaduusg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/DsBHmA";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=13RN7jr6qhJRYMoGLtzVcV8m6A+UWIAbzJBCb43pIS0=;
	b=zH0CTfn4iZd4Q+YVblXPfwPstkw8elUfbI4aC/r4WNOTj4tBYDlNKM1lPk/NH1OYs9ShVx
	WEPAdGYD2akAVHsW9oWAW4bftyk0ZZT4oGlx5LYSS9IoD6PZMZDDlGGqwh4LJhwKhwDzpu
	UcgsEX+OMd/PIVGJ+BeO3jPPhTlGvp0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D5B6434C9;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 689C4C2BCC7;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135919;
	bh=jB3934St+OXWHZBQYrRZ5bx+0JcniUdY+5MQ7UHR2bg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=p/DsBHmACKvCnTUXaQUBvx+B0rhbCevFn3J1wVa41KmY2z/4jwj9NXJSoKVBm8e5t
	 GK+zJXnK2Q8T2MAtuI66FOXMTtH/eKrubu+EGLBpBseRJDNZFMbls+8Fd+9/cJoRfy
	 zAu2gGK+W6zNW+07odNQpNGzeDUbVSM7Fqcu8SHrHViKjIHAf6WO+3Q1c2y5RTu44g
	 jfPuBU/zY+/SSNIxAph0jtre65vyir1ipceRSZokQuMuk2cvxR0ueZuMha4Ng4vmET
	 ZtcT9NRYl4Y3dX4pEMc6JCWScmm3LBoejvxi3ZE//RXFqMA/Rjh9zLF7wcQF8EoSjo
	 DZUnuj3WTkrzA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD07C61DE4;
	Mon, 31 Aug 2026 00:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v12 00/45] guest_memfd: In-place conversion support
Date: Sun, 30 Aug 2026 17:25:01 -0700
Message-Id: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN/JlGoC/33TzW6DMAwA4FepOC9b4pC/nfYe0w4mcShagS50q
 FPVd19oJ9EJwTGR/dmxnEsxUGpoKF53lyLR2AxN3+WDgKdd4ffY1cSakC8K4KA5gGJ1Sy1ruuM
 BPTHfdyOlKYlVgYcqSGeUxCJnHxPF5nyj3z/yucKBWJWw8/vJ+xzbl47Opyl03wynPv3cmhjll
 HAvJ4VcLTdKxpmKXgAaTt66t7rv6wM9+74tpnpj+QCBXofKDFEOi+QUjzEsIDVDJdh1SGUoWM2
 t99EjwALSM6S4WYd0hpzASqGthMNyAZkHCGAdMhmCyCNS6bSSfAHZGdJi42l26iiAU04qY5VcQ
 G6GzNaMXIakig7JA1JYzkjwWbJbQxL89jgvLJEOssIlJR6orQ0QIlMchQoWjXP4n7relznR13f
 +Hqe/jb5efwEgqf/KPAMAAA==
X-Change-ID: 20260225-gmem-inplace-conversion-bd0dbd39753a
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=9254;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jB3934St+OXWHZBQYrRZ5bx+0JcniUdY+5MQ7UHR2bg=;
 b=EvLGdfk9baBRMpq/23qyZcMJi59GXHj122oJ7ORw+P2MUKpHjulgOv6RBjqtNYFuBFt6oURl+
 xrFxovZ3s5dAN25sL5le2Vudaf2xFBkbWh4JMmubAiPQS4r+zIFrKd3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D31FA40003
X-Stat-Signature: xmsg5ewzxmibe1rxfu5a9eeyfsa85nr6
X-Rspam-User: 
X-HE-Tag: 1788135920-218088
X-HE-Meta: U2FsdGVkX1/L5XD8Vj7vV3JytUHjA+prsr9l68amyXfpA66T1nT+84IYcwUQ3FfJ0TI6R84XyQ1U+Lfyvg8XfblUzJ7r/a8TsSRKNrnna33H+npMdbVaT7WsMoW9Wt6b5FkCZFTTyTiwWFGlGASQp/Yh+pSLrqfEwPKFr1DFdzcLv2vY8ZMLvZWlrv4VUStcyD/IgDO9fpXN4vVkdzzbgHhk42Sf6IBqnAc7FnJcbAQ8wkz+5ig0Rk9BlP52Ma8y4KHA8fQsM0potgEad8rHvZkixo8hIO4luyHixcT3MQ6v4essaAJs8yO88yyHIPQo5D96HwQoDs3ZyjB765CcXAU4U4KeqyFgahZgI4BzA3WOaJzO5IRaExm4U5H+kHczNWumukuczLM00KayoV8WoKPnOHn4Q1Q3W4wv5dsBAXvBBx5H9o98w+jfCc2dLC2FeLfJ7Lc0equgodXAOVFi/8bAn6xixUy3OvLCt22MgeoZu5q396QFqoU1UR427xbk28uVAwZOKRqsyC6QqXB7tfd67PG+iNbnBY573UoLTJ4MHZ1G3RIrgKbnmK/fQ+jpZW7vhQFfYciZgcpf9FgyrD89mZT6LWP8iEffG2u/i4AO3AUmmWgfdwlDWslIKbymAKRZcszaLbjZ8BMbp9lzVPhgYgj6+k3cqxG3uOzbyMVzE0rjSusuZ2UdK7vbN6HcNUQJS1uMkWTQx0O3XKXennVPQuWhHkTEbiRUo7xaZxuaNBOilcoKjJ07Tnut6/u4hUNfbtTP67aCJxlDnJyCgD1f+oieWzhKNbT8cHCQLOgc0FPKrLhCMdpQzUcd45w6LtVsIj8GnmmqGy4/FPLVjtxsNFh790/0J42LlFiXAKqQABndc4h4zSxQbkeu9JB2w6dwqv3S3aBL2vL+nb1vKrItnheo5EB5BNrgn4esgIIfn8D7UGx+kxRbgv0L6JJOh6jMzfDj7iuhWuUktL4
 iY75Ox11
 WOAwZV85lzTB2C6uKg7scpQy1SFIKAxrypfcZBuVXaN6OcXaISXn2mCJEKS5/0R7zmQ90jYz85kVl3kxz3TJR6iUrKOmJy1zMHYoXuoo/QouH8SrevvOitl3jljYHrWN3KvGRJZN2V+eLddrij8Du6AA43E3kxf3OR5/jXeQhnwSq6OwoAa7wyFDgIheIT8iaA9mqeHEV4++t3FhHMeYGk71VyhleVefWsgYJ5a8DukHFIqAgGfSQsZlmmqaDjRmL/GLor/4NWHBq/PNMXv0OnmpGJppqZkD3NPMIjxWPpEnLjyDsXXYe5G//7mV6I9YfslyghdHjw8XF8Z4tOYEzSLRQEDP1jxjMBPo3NREv+afSEvGpSa0sLoxo0AfovPKadvgVwWBCY4GO7r2jbrD7zcQJSln3hRQuoMFvVuTjikjalwCzua/tvYBF6NFVn/0X71uPJZgf/CK8lyTw7b0+7kSG1x0dsZQCdqEHbYEBkhoRIfW4pQsKjg0kbqTuAFg+ZQ2JD4nc+8MqGJ3uSI5mUWjCr/6hmt8wcCCwFl2t/4FGHIGDt/TAu54yBYuhRUHbmWffsSQ+k4gzn9fWeeqjynT+cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's v12. Thanks everyone for the comments and fast responses!  We're now
at ~4 weeks to soft-close at 7.3-rc5.

v12 is based on 7.3-rc1 (contains the mm/ bugfixes). Like v11, v12 is also
dependent on another series [3], which makes kvm_gmem_get_pfn() NOT return
a refcounted page to KVM.

Here's everything stitched together for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v12

This revision resolves the issue on v10/v11 to do with over-zapping of
non-gmem memory because of the requested filters. [1]

The resolution is in a new patch "KVM: guest_memfd: Always fault from
guest_memfd if in-place conversion is enabled". I also updated the
documentation as requested.

Documentation updates are in these patches:

+ KVM: guest_memfd: Stub in ability to enable in-place shared<=>private conversion
+ KVM: guest_memfd: Always fault from guest_memfd if in-place conversion is enabled
+ KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2

The documentation update in v10's "KVM: Let userspace disable per-VM mem
attributes, enable per-gmem attributes" was misplaced imo so I folded it
conceptually into the patches above.

private_mem_conversions_test was updated in v11 to test dual backing, and
that's meaningless now since with gmem_in_place_conversions, we're now
always faulting from guest_memfd, and the userspace_addr not being from the
gmem associated with the memslot is considered a user error.

I now only have 1 patch "KVM: selftests: Update
private_mem_conversions_test for in-place conversions" instead of 2 in v11.

Resolves discussion at [2].

Here's v12 with tests:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-coco-selftests-v12

Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:

+ tools/testing/selftests/kvm/guest_memfd_test.c
+ tools/testing/selftests/kvm/pre_fault_memory_test.c
+ tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c

[1] https://lore.kernel.org/all/apCLFSbj8sq2biJp@google.com/
[2] https://lore.kernel.org/all/apCj6gz8x24Dkle8@google.com/
[3] https://lore.kernel.org/all/20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com/

v11: https://patch.msgid.link/20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com
v10: https://lore.kernel.org/r/20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com
v9: https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com
v8: https://lore.kernel.org/r/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com
v7: https://lore.kernel.org/r/20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com
v6: https://lore.kernel.org/r/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com
RFC v5: https://lore.kernel.org/r/20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com
RFC v4: https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
RFC v3: https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
RFC v2: https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
RFC v1: https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/

Previous versions of this feature, part of other series, are available at:

+ https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
+ https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
+ https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (23):
      KVM: Rename kvm_mem_is_private() to kvm_is_private_gfn()
      KVM: guest_memfd: Always fault from guest_memfd if in-place conversion is enabled
      KVM: guest_memfd: Pass mapping type filter to invalidation helper
      KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Ensure pages are not in use before conversion
      KVM: guest_memfd: Call arch make_shared callback for to-shared conversion
      KVM: guest_memfd: Return early if range already has requested attributes
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Zero page while getting pfn
      KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
      KVM: selftests: Test basic single-page conversion flow
      KVM: selftests: Test conversion flow when INIT_SHARED
      KVM: selftests: Test conversion precision in guest_memfd
      KVM: selftests: Test conversion before allocation
      KVM: selftests: Convert with allocated folios in different layouts
      KVM: selftests: Test that truncation does not change shared/private status
      KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
      KVM: selftests: Test conversion with elevated page refcount
      KVM: selftests: Reset shared memory after hole-punching
      KVM: selftests: Provide function to look up guest_memfd details from gpa
      KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
      KVM: selftests: Set up page size and alignment independently for guest_memfd
      KVM: selftests: Update private_mem_conversions_test for in-place conversions

Michael Roth (1):
      KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE

Sean Christopherson (21):
      KVM: guest_memfd: Optimize away conversion overheads via dead-code elimination
      KVM: guest_memfd: Use kvm_mem_is_private() when populating guest_memfd memory
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
      KVM: Provide generic interface for checking memory private/shared status
      KVM: guest_memfd: Stub in ability to enable in-place shared<=>private conversion
      KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
      KVM: guest_memfd: Invalidate both SHARED and PRIVATE mappings for in-place conversions
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/admin-guide/kernel-parameters.txt    |  25 +
 Documentation/virt/kvm/api.rst                     | 107 ++++-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  14 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |  28 +-
 arch/x86/kvm/svm/sev.c                             |  13 +-
 arch/x86/kvm/vmx/tdx.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |  20 +-
 include/linux/kvm_host.h                           |  83 ++--
 include/trace/events/kvm.h                         |   6 +-
 include/uapi/linux/kvm.h                           |  16 +
 mm/folio.c                                         |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     | 139 +++++-
 tools/testing/selftests/kvm/include/test_util.h    |  34 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 222 +++++----
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 .../kvm/x86/guest_memfd_conversions_test.c         | 512 +++++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c         |  66 ++-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  36 +-
 virt/kvm/Kconfig                                   |   3 -
 virt/kvm/guest_memfd.c                             | 469 +++++++++++++++++--
 virt/kvm/kvm_main.c                                |  92 ++--
 26 files changed, 1646 insertions(+), 287 deletions(-)
---
base-commit: a0c789941a3d705d00c018b3c9348b4b930c0c74
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



