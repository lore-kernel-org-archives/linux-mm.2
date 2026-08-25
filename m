Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0662DC61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A14F6B008C; Tue, 25 Aug 2026 06:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2522F6B009B; Tue, 25 Aug 2026 06:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119EC6B009D; Tue, 25 Aug 2026 06:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF7866B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:06:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 458AEA3647
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:06:45 +0000 (UTC)
X-FDA: 85139362770.07.2CC7FD4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id A435840003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:06:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C7jilkaT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehB4p7iSUg9LQXjKa5JoQygZfm4ZuQakVVXN2OSb7C4=;
	b=YfmLh4Zkq3ZFcZdEYXu6BXQxIHm6SYf5ls0dRoJhTXa1Q7EQh9AcX5fevb3QQOogElvHXi
	mVabj23zboFMZR7xE2P5QcaSXgjWRWzGw1F0HZUMn2nKZvFgCLvkQjaTkaSoHm0GIEKOMV
	V8+zaKNeFXyeUwKz470JeLLyAVwfpCo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C7jilkaT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652403;
	b=o72lX4dQCE1tt8AdWku95PUZlAY79IlfDs4p7Vb/kcdPRDgNukjmTwhUQxZQhZvyQ2nsuJ
	FzBGJDSWqHVl5zhXNmFEVOojLgCZvp2mdwWbWv25dx83ZypXfZMdWBmaESDOzylgQMmdJZ
	RMwjCeyDIW+qNLUUNQl9hE11LRfhcb4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787652403; x=1819188403;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M9Fm4+dnvq+XgKw9yfXTQV+zqDAuw6hKxuh72y1d/p4=;
  b=C7jilkaT7PA6u27NLvGxTUv9JHE0Gy7tlU4N9LBef0NgcSaY5NGjWIa+
   pYp3iSH9jbXw4M0h6FcOoNkgXHTk2tKurWV4QifXJBwUiG/EHmrGb0Q54
   GIJrFKlzgE2fCgiT798ia+78emrjpFPM5weVX1Kwy7o02Yqd0BwIHKAwy
   ny5oEijdjg87kjv4JAJlAXkLqrYA0VUoPYn46w4uNk32ht2CU5b3/gzjN
   WdotuPcJAEter5uPjP2jUCmIGfsa3vAbgHwzNq/xOl6qS4EcWWdDYTwud
   jBwygOUCgwZZI5wlvo5rTvWaQM7fvwgEe4CCkEfA7mHrxXpuKjGCyngIl
   w==;
X-CSE-ConnectionGUID: gWEm5T10RbOpoaUcKZ+OdA==
X-CSE-MsgGUID: 5ZFTQxrDS2mNSIyxHA/RoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="91797078"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="91797078"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 03:06:42 -0700
X-CSE-ConnectionGUID: T+xKrRR4SkK84ruPBSE65Q==
X-CSE-MsgGUID: shDtClh4RZWx8bZXjoSkTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="266698413"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 03:06:28 -0700
Message-ID: <9feadfea-c41c-4105-963a-a3d98421e1c3@intel.com>
Date: Tue, 25 Aug 2026 18:06:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 40/41] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
 <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com>
 <aohEz_1JFVDtlSnE@google.com>
 <CAEvNRgF8XE2Xsn-g3qzPxcdfLdvJEc1FZw9LQ+deeXsFpdZsOg@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAEvNRgF8XE2Xsn-g3qzPxcdfLdvJEc1FZw9LQ+deeXsFpdZsOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A435840003
X-Rspamd-Server: rspam07
X-Stat-Signature: 6f8miebh4m4a4r4am61w494674517p38
X-HE-Tag: 1787652402-695375
X-HE-Meta: U2FsdGVkX19x8j3cGL+YvnTU3vDQdEnJ1iuNdNWapPTdiyoO8+aaehCO5u+q2oa939w7uhSLrRPoJPFGjTeTd0baxOhUC/Ua2Q0fgQklZkZ704tIhAIFT5Zn0W6cT6bL28kEXaM0Ja9M7seA1dDwwenW5OUtcOjZO1OVdZkndB0hHJ37FxICnNfwILYMmzL2CBkZIuT00BDV4Tlzr6ngmiaB7YeucHYbjNX0HskzN+F64+2IZOYt3xDkH7NE3n+7jP4ZCJQ5wIP5Zdsl35khr5nEZMFVyQ/tEX7B+VglWxqSC0AdwRdIHUkuKdR1I8nnH8xqwzsKC5QLkbb/ttvY5hvEa0N5Ap7smCuQ5BP9rMa451dc9bx+snbgLou8uRRYFpx1l9BI2aWLbEW3L7vXxV4KpvzWF1wotln/I4kcfxloA9nhcDE+UjwweOOsd+vc/OyQY97+MVAitZVkhYa/byzBZX8Pa02GGRYjYd54aSfH4I4c4UQzXbDJZ93uqg0IPB3qxpsoQz/KWrZgvNjnqCPFG64lu2hFOYg3zNR8SECOxL9ky55MdThYWnaoZGIas4bwK9BK5wrNnl2s2pQaG7lrJzjQP5dJkund4qN3a6usWaYiDx04zK9LEcXn/MwawDolxAhx+h8JGq7kvWouefBsW75TQJ67DqkwWKdZ4kUMfa7D+FSvL35o45WJNgnIlkyFhXM/AwJX+qFKUkPQLI1ttStFLSFwRgdigbNrX1YLdLvShKpczOiWHjRJ5HQHo1VHkSMo6/3/zpd+BiyTa2qtCuX26aQipaLZXqfcLO609MLQs2Eeeb5DOON1/qJ46MSyXkSKGiccf/8iCehVACY1IA6yJO60qoYrk/78rsNzcBLtTQZdooGbXhMVTXiSOj5s3rsUNg8N3avwQhVHtEBihkZgXGiDiMklYgYO2oE1opRzwvrszg2odQj1ywLQjFZsCHEKlHECm2IXFw6
 gExTRiKt
 N1+8U7ld+fSKjHejgWgiETcPT7V7l2TWuXq2oKVoaJ5z7uc3feqZNr/G+tDgefeXIp21bFD175dXHDvLapMyWju+uEu7fcQs/2SK3bj21Y0GN5vGgPOyJJdt9T9t41n8PR3bQwUkQgN5b4hCkvCvDZCja35759UlbIpDKcZdOUb7DDDyeJrabdhWWlsSUB6hSfmaj07zus2zxaeVinXaa5Nf1YPKzzSifdansdqVJrzYAYysC7HmaaAbO1QDCPV7nxCIL0W3fU4p6Sr/BwSgnQcdD0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/2026 5:32 PM, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Fri, Aug 21, 2026, Xiaoyao Li wrote:
>>> On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
>>>> From: Ackerley Tng<ackerleytng@google.com>
>>>>
>>>> Update the private memory conversions selftest to also test conversions
>>>> that are done "in-place" via per-guest_memfd memory attributes. In-place
>>>> conversions require the host to be able to mmap() the guest_memfd so that
>>>> the host and guest can share the same backing physical memory.
>>>>
>>>> This includes several updates, that are conditioned on the system
>>>> supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
>>>>
>>>> 1. Set up guest_memfd requesting MMAP and INIT_SHARED.
>>>
>>> If I understand correctly, even with in-place gmem, the model that shared
>>> memory comes from the userspace_addr and private memory comes from gmem can
>>> still work without passing GUEST_MEMFD_FLAG_MMAP flag.
>>>
>>> Since this model is not prohibited by KVM. I think we should keep the
>>> testcase for this model to ensure test coverage?
>>
>> +1.  Deprecated doesn't mean unsupported.
> 
> The original test case was for non-in-place conversion, which wasn't
> removed, it still passes.

It only passes when

   /sys/module/kvm/parameters/gmem_in_place_conversion=n

It fails as below when gmem_in_place_conversion=y

./tools/testing/selftests/kvm/x86/private_mem_conversions_test
Random seed: 0x7eace343

==== Test Assertion Failure ====
   x86/private_mem_conversions_test.c:46: mem[i] == pattern
   pid=288745 tid=288747 errno=4 - Interrupted system call
      1	0x000000000040426a: memcmp_h at private_mem_conversions_test.c:46
      2	 (inlined by) __test_mem_conversions at 
private_mem_conversions_test.c:356
      3	0x00007f2ea2c89c01: ?? ??:0
      4	0x00007f2ea2d0ec3f: ?? ??:0
   Host expected 0xaa at gpa 0x100000000, got 0x0

> Is the ask to also test, under kvm_has_gmem_attributes aka
> gmem_in_place_conversion, to have guest_memfd used as purely for private
> memory and have shared memory taken from somewhere else completely?
> 
> I can rephrase the changelog and change the code to clarify that this
> patch is meant to specifically test in-place conversion with MMAP, the
> intended usage of in-place conversions.
> 
> The ask to test gmem for private and something else for shared seems
> like a different test that can be added separately, perhaps in a
> follow-up series?

I see it as the fix for existing testcase, not another new test. And the 
fix is simple:
1. change to use vm_mem_set_memory_attributes() to set memory attribute.
2. pass GUEST_MEMFD_FLAG_INIT_SHARED to create the gmem because this 
test expects the initial state of the gfn is shared.

---8<----
diff --git 
a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c 
b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index cf50e9a332c5..fbd6c63d21cf 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -307,7 +307,7 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
                 vm_guest_mem_fallocate(vm, gpa, size, map_shared);

         if (set_attributes)
-               vm_set_memory_attributes(vm, gpa, size,
+               vm_mem_set_memory_attributes(vm, gpa, size,
                                          map_shared ? 0 : 
KVM_MEMORY_ATTRIBUTE_PRIVATE);
         run->hypercall.ret = 0;
  }
@@ -382,6 +382,7 @@ static void test_mem_conversions(enum 
vm_mem_backing_src_type src_type, u32 nr_v
         const size_t slot_size = memfd_size / nr_memslots;
         struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
         pthread_t threads[KVM_MAX_VCPUS];
+       u64 gmem_flags = 0;
         struct kvm_vm *vm;
         int memfd, i;

@@ -397,7 +398,10 @@ static void test_mem_conversions(enum 
vm_mem_backing_src_type src_type, u32 nr_v

         vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << 
KVM_HC_MAP_GPA_RANGE));

-       memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+       if (kvm_has_gmem_attributes)
+               gmem_flags = GUEST_MEMFD_FLAG_INIT_SHARED;
+
+       memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);

         for (i = 0; i < nr_memslots; i++)
                 vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,

