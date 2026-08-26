Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7D8C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9506B0088; Tue, 25 Aug 2026 22:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3693C6B008A; Tue, 25 Aug 2026 22:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258336B008C; Tue, 25 Aug 2026 22:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0C1E6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:29:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45BE1C024E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:29:18 +0000 (UTC)
X-FDA: 85141838796.11.8FE1970
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09BAD180003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:29:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H8qLg0cJ;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787711356;
	b=7N+EQ7Rrs8HBzo+HA61OetK2YXynFv3Z8q9SyycrfAQEtI1Psso5y62hEeK0B95MXUVzbi
	VKCi4ClVi2XlPd6KRaq0eq6rvVXTNqZbAFIGypK7mjcyPs6Ax6kdFNPqgGTfSJEG7rzLTo
	ryMAgHMKuAW9vG9AgqDOrs2KLSitINk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H8qLg0cJ;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787711356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLu6KO4iZxtds3XXhQbT4Gn+QVv3HYnF8KgEkuwfTrk=;
	b=HQq1ZL0EH/vynMgrDgHdNnEA1PFBDCBEjfd4MQ/2YsIfxbst6UwTPtxhtPfI8XAnP7NnYR
	Dv0fOojJXLlSqx4kiqHIwQRlKABsivc/g9BWMdeKE761JnJnJRKRTvwg6Bwt0jBxAB7vHL
	gwvjzhNBs6+BAu3tfuSMMrLn7zwYXjs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787711355; x=1819247355;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jytyOnxKug/0HATBzAcgvdrubIDuZNK62vbz3KdkDXw=;
  b=H8qLg0cJFOeoPPAoeKtI7/NUvYpHXCuOvhAlMqCtuZ20MI3GbDOTe3Rl
   V4SGLVDtc/Kp0ZAWonZPWTj9RZmT8yTtJCt+PmL6GrUy8XE7WHqz952bi
   mN+/mXyMKeyPernt+ockrlPfmFIIr2N89QGrIG5lv5dgASwXcOXcwnPKM
   EMkQkE8to602+OPiIegnG4YcMly2D5kaaiUh26/DGG73EAEssVcwf53R6
   kT5W3GIhTnbNrXH+bscJMKh+y9RkKGCuuS5EshT2tt98rQSdylUYQFhGv
   +cWBZPmtDn7v6Kx/w9E3qzd+vf2o5gvlRd2UQBW5nTIAJik9XHnMp+M0S
   g==;
X-CSE-ConnectionGUID: 01eTsg1uSa+x0KQ1kPD9Bg==
X-CSE-MsgGUID: dmkNYnufSuaiXvLNX3Qj9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="98522526"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="98522526"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 19:29:13 -0700
X-CSE-ConnectionGUID: Kq9+eMnnQVKhBINXbsGToA==
X-CSE-MsgGUID: f17Ncq3BQG6gkWw4k95B4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="266865838"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 19:28:59 -0700
Message-ID: <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
Date: Wed, 26 Aug 2026 10:28:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Sean Christopherson <seanjc@google.com>,
 Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
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
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
 <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com>
 <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
 <ao3lOu8-wpGTs2wd@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ao3lOu8-wpGTs2wd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wb44tdub6dxzms8t7p7hdxki8wi4414r
X-Rspamd-Queue-Id: 09BAD180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787711354-725122
X-HE-Meta: U2FsdGVkX1/TMj4gK+1GaKJ6SN8FB5W4roZEdoycnZYT3/nM8HLc5edwdyXWe9+c0B8mrcwU+RuvZ95tQiwIaJ1qNF8RLnoNg+NPpsZ/yQ3/3ZJI9YXLZVXUGHYF6IxSWrUlGHSHgtRVBqW2U+C9Qh+TNsyMbT37VQtAzMK8KdpWelm1vbiSUGzvNuMZzF4OB1eXKL+3cjn1cFcvh8qHc+DxQttVj/55LtzgMgsIWKQjWhN4YdgCbQXYiZoVpzuHhUaOac0rNKWwDrqiDx4W3n9Y/sTNZOPlx+BQ/UDIyGIw1qbqKjcKWuWC5QkxMVrKCrnccOkzhvNUaRiHKuJELtV4j8aO0rKK+AtWAHY8q7Cm3YT67CsQzcu8pTpqsA5+BLGhpJtnCqZW4gdUL1/WQNY3c2aod3Wrchof65gyB/bWzJ8hc8wOZo2f/U0Ax2hd762wFpNmII6MKUq2nYXwPcqmKZCmta0QnJZlYQVtTcLHZ1qII9xPfXNGRgxowabOWvlnO1NAd7ddbq2AXvKiRQqPu+ZTcdJIlVjUIlbJtaysv0tVG75v0ig3aFiQ87exO6LM7Yh8Qlfgbrz+vRw1SkF+91HjJyuLO0DDzRBXLaPQsPg3R9x4/Rk5RXxM4u9HXjDdyX3ks83R0YBMD03LZuRCifClrXf4m1Ww9ROuzqCyt6hleeWrOGXaa7VNjT7MEtq8GlYAfBCuXFBsYGPaargiL214rD/1uudmfdGFtaxbdXMNVLhJq8SmICow7yN4LBuvpqgrZhHHx7FdE46KwCPAUU9eZds96yWQilIAVQ3aefHbNnlBPqtQdD5ui7Cq263l7YWKe292rsZ/VlVDwurRtPr5D2CpXrlnLUaSm1gU2juBTFX800Ab0nKNMwqFOiNmS/nNm58GucPrF11vOeYRl585Bsr/ETiEixfFVSGdjwZoEUHLEIe0exoaTOnYKNwuUmjTSWMMpHG0hZI
 kwIHoUe3
 5zREJQBDED9mI9xsO5AnPwSis2/aosi9g3U2Ns//MgScIb1LnG2fvvzpwnYXr4l+apNLLhKPtqyanrbb2y0m9BcTHqW5utHbWaFPZGsud3ExbVCCAtYwbg5BYQCwlyToRXqbCGguwlOnxf0YjAl5D4Ye4lGGdFZnjC6ylpUzFKqHbNdpt11a90pUvpZhqyLwdQNby4mJKJ11XLeMzsPrP4GAI+FsmGBEl5Ol36qGx9zAwCqpfrK/jwB4QYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/2026 2:55 AM, Sean Christopherson wrote:
> On Tue, Aug 25, 2026, Michael Roth wrote:
>> On Wed, Aug 26, 2026 at 12:13:47AM +0800, Xiaoyao Li wrote:
>>> On 8/20/2026 9:32 AM, Sean Christopherson wrote:
>>>> And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
>>>> using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
>>>> PRIVATE mappings (of a different gmem instance).
>>>
>>> I'm wondering now how this could happen.
>>>
>>> the requirement for PUNCH_HOLE on gmem to trigger mapping invalidation is
>>> the gmem is bound with the memslot. But how can a memslot bound with two
>>> gmem instances?
>>
>> I think this is for when userspace uses an mmap'able guest_memfd instance
>> to handle shared memory, and a 'normal' guest_memfd instance for private
>> memory. Each instance is bound to the same memslot/GPA range, and
>> KVM_SET_MEMORY_ATTRIBUTES handles switching between the 2.

What I didn't figure out is exactly how the two gmem instances are bound 
to the same memslot.

The case I can imagine is

1. create gmem1 with GUEST_MEMFD_FLAG_MMAP and 
GUEST_MEMFD_FLAG_INIT_SHARED, and get fd1. mmap the returned fd1 to get 
a hva.

2. create gmem2 to get a fd2.

3. call KVM_SET_USER_MEMORY_REGION2 with KVM_MEM_GUEST_MEMFD flag. Pass 
the @hva from 1) to 'userspace_addr' field and pass the gmem fd2 to 
'guest_memfd' field.

However, with this case, only gmem2 is bound to the memslot while gmem1 
is not. Following PUNCH_HOLE on gmem1 doesn't invalidate any mappings 
because the f->bindings of it is empty.

Do I miss anything?


