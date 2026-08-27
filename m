Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6D0C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81ED6B0095; Thu, 27 Aug 2026 00:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32896B0096; Thu, 27 Aug 2026 00:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9201A6B0098; Thu, 27 Aug 2026 00:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638146B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:34:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E19F21C16ED
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:34:32 +0000 (UTC)
X-FDA: 85145783184.29.4173EB5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D730100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:34:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meCw09th;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787805270;
	b=4+VHJJgp6NPZetZf8zf55ZERe2ZAQ//7hThRr34fe/FXLRWYLjfTecyL7mVKjuwm6gTwWS
	05cTSlqVuSxkhPYi0U5GtAzCvc5L8bibzERQV07pfiEIyxm/bfDNdskC/VqEHCmXTz3jsG
	FEeSd+//c7lJmuJH+VmUqdBY5baTYzo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meCw09th;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787805270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCt/djAZ1UxldwHWbFpqYpmkFfoG7lpSZm8yjpzs7yE=;
	b=IPQvDvc0phgVZZcaMGQu7THGbu5qtHnleY1wzXPGQU4rk/NwH0vArL00INnv+fZAaJH7s4
	E/GIdfGMB8HksTFZBIyuyYJaMAm7q09emJmfp92Gk+6iy/IXRZFI9agbj4iGtzON5Alijt
	V0hAJZgVn2zzLIHFaXBWV5T4Ds3HIEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787805270; x=1819341270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xr2YAmCQGQtyvAfz5tyUYMYX/2JBvSP9WNi2BFs0z+o=;
  b=meCw09thLe8tpZwZ74giYRGtyeGLzWIFmxWi/MeHwZTUX5KfT+vH/a1D
   1JUiaxVVTS0qVpwdgmiYjjtsYZ/juXNYkT+HQtAR6brKmV8LbquQq6cBZ
   XIwXt6oNCsXO0vLyXMmqqMpB4flpMaU29WQelopK4HQJn2SPKS9bvlDz5
   ruAKISVF3N84rzN0HtgbxfdWVP4WNeQOK1ny/dx6oMPDU2OuODljr0x06
   //hxR3FLRsu5/3G3kAdwy8AjMYzdthRIj5ErvXIv40OUe1PAWHA9OTwLo
   t7XjyHL5ERXLFgjr0qOoC8D39Gj1k33RApePoX6xleR+t1JRwMfb+KY7R
   g==;
X-CSE-ConnectionGUID: zJtaUR/oQuqDzdsl4TrvVA==
X-CSE-MsgGUID: 12byxQ6zQyaBQ3984MavyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="75839234"
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="75839234"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 21:34:28 -0700
X-CSE-ConnectionGUID: rV3cStscS/aNLMyWraRS+w==
X-CSE-MsgGUID: WvkBd7g8TtuwCi4hAeOL8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="269701976"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 21:34:14 -0700
Message-ID: <a151b52d-0afb-4b32-a871-4da67210f416@intel.com>
Date: Thu, 27 Aug 2026 12:34:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: Michael Roth <michael.roth@amd.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
 <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com>
 <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
 <ao3lOu8-wpGTs2wd@google.com>
 <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
 <CAEvNRgFXJbV78ktsg=b4srFp1OFjtQWQGuNPjr_MmWD-wOvjgw@mail.gmail.com>
 <ao7vwx3nMqCjCHZU@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ao7vwx3nMqCjCHZU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D730100004
X-Stat-Signature: y1z5bmhq7kpymuznmweyjfatmn8emyqd
X-HE-Tag: 1787805270-915281
X-HE-Meta: U2FsdGVkX1/COLI1cwextcJnXMwaeefR3tvZqo52OLWYgM2FccUCmg3DcgSHg+BUXa8hz2EQdeZJ/YC2c6M+n358evGCsq9gCI79TODyYGiFbF++6zRBXdTROsfhPsvt+bymEZqiqcWWq3WM09ZVZwQANPveMr9HmXW7BbhK/NT1VzsXPknrySdRgyqK8T/J1I4oLIKEgnlJsnYvHZ38knK4624vcghgJYp33rT8Pokow3iImGW9V7H+JyDFnxtla43h+3dNOfkwgZEHsnYv8hJs6ryDAAjBBsUV4WGd1ffBUnrkAAAmTEzWpMYzjIqJ/f9FH3rwdEmOhprQLiylludQUvK2RWTJHpdj5u2bzAeo1ghuOCBp8bUgPeslsybQFkl/jfrkfKdcvCs9xvqcMFdMWx6/XlryjCLmOM2c69lGIasSgvwlXXLmQEjXyLUttJLVhCKQ9H9s1VCnT+ElU/FBbgn9Zb+8YoFqiNanIWgQXJjUMUrtipCIs5iAtppLaPg+YUV75JQ8LTYz+U8UbqWIVUgn7m4K+qf06S8xuCj7RNMXcxn7V3anhiN/me182Kmdje+yYR1MUAtNFyoX/kf0zId2awBn81EVdo8Xig01xj9SWVVm+4wA+gUayE0lQf1fegZqnghQjiTb7x7D+GHGwOcQbuJmQvWdWNq9K7ibN2l5rG10ErXVcYFvjXV0mro12GPJf+Un7fuftmV8V3seglVUGhGbbB+rTEPNhmf8erlYrRTS39o3OlQN0VfDDJZCVm413oLMutYYyPEgs1y1TPh/jRUjmegSnZzo3LWT7FCv22j6N5L4V44+YJAk8T4m98oZjx+nBYCLsOeuOSU497Mczignl22cdCDzA8NhL4fQc8f5dWHhCYT7dU4b8EzSDNV1O+MkLAvUpWojzHx9dWo8Ggj/deUcsrPIqWp29nDGTUqJ3rfg2prQE9hAU+rkDm/TacB0fYd+N35
 /JshcEaF
 miXl1ld/yFRBmp+5z2JrD4KobvSlL91vkbc6WEfo6/3SKIixp04M1ox4Nwb1mZok6mez5e28iETBz4CgKCfXni1LUcqM+6KI90acdxX1EYw/eM/zGvMNyp63l0KWoSt99MnPM+eRjMZzfjWpdBmI8zh9/cwJQqC24j8qFHPty8a8RLIpZ/vD9SsazWd6vTqb0IKB/lGDIQnADvd9mmhQ5VwWU7wi6oECJzqpn39es377PjxnlYh/RvjX39hT2/884yhGHF+4v2JI9BPswUEROnDb58X+MDDnxgDpaYlAvkAhzldE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/2026 9:53 PM, Sean Christopherson wrote:
<snip>
>> Is this just a case of user error? That with gmem_in_place_conversion,
>> userspace should not use userspace_addr from something other than the
>> gmem for the same memslot?
> 
> Yes.  It's not just invalidations that will go sideways, 

> KVM accesses to guest
> memory won't hit the same physical page as actual guest accesses.

Side topic.

If KVM enforces KVM_MEMSLOT_GMEM_ONLY when gmem_in_place_conversion is 
true like below proposal, should we update KVM's guest memory accessors 
to access gmem directly?  If still use the existing code of accessing 
userspace_addr of the memslot, I think KVM needs to document clearly 
that when KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is enumerated, if 
configuring the guest_memfd for a memslot, the userspace_addr passed in 
needs to be the mmaped address of the guest_memfd.

> Huh.  But that isn't strictly guaranteed, because userspace could bind to a
> memslot that isn't configured with GUEST_MEMFD_FLAG_MMAP, in which case SHARED
> faults will go through the VMA, not kvm_mmu_faultin_pfn_gmem().  It's a bit early
> in the morning, but off the top of my head, I can't think of any reason we need
> to support such a setup.  If userspace really, really wants to use a separate
> mapping, they could DELETE+CREATE an equivalent memslot without the guest_memfd
> file descriptor.
> 
> So I think we should do this?
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9c2d52bdf25e..86f53e53a136 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1013,7 +1013,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	 */
>   	WRITE_ONCE(slot->gmem.file, file);
>   	slot->gmem.pgoff = start;
> -	if (kvm_gmem_supports_mmap(inode))
> +	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
>   		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;

I like this idea. It makes gmem_in_place_conversion a step closer to 
what its name implies, though in-place conversion is not truly 100% 
guaranteed[*].

[*] https://lore.kernel.org/all/akUbz_kJvYulaboo@google.com/
>   	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
> 
> Regardless, the key aspect of all this is that in-place conversion is brand new
> functionality, so we don't have to ensure backwards compatibility.


