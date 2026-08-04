Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2287FC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29E36B007B; Mon,  3 Aug 2026 22:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDAC56B0088; Mon,  3 Aug 2026 22:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1CA6B008A; Mon,  3 Aug 2026 22:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4F46B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:11:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2413BC0882
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:11:29 +0000 (UTC)
X-FDA: 85061960298.23.43AC079
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id D870818000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:11:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A+oAF8ee;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785809487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/Q8BcsMvD5vcB9uR0g6nP6rv7bgIShwoeJhURxwbjA=;
	b=6pake8c1yc44laHxLOW6ZiC0jHLwe2Vr8vegKiy6NH/uLfrUbCA86lLrEiZuevVmHdwJty
	Qt229SHLhr2thmvS0KyAo+DUoRPSKFZWUiil5wNArv15hBkTyQR/i+GZ6/tQ4Jcq2bfTES
	0XCzoyp8cvcWOjVm3byZttzmvdGsBJ0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A+oAF8ee;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785809487;
	b=RTXoWKjkFAygaPV0fA3qWrLgVCsWDpmAeJmVSrxQn3gGjir5BFrX9bGRWEs3839XK42/3q
	Jq8UJx2Nn9GhYZ7K+H4dw2vB2LUSo0CbV2ziWxoIaBq+QJVY7v/3EG53sH6aU1X3AkajXC
	1Z4GYc1IHooEEhAHmHwnGMKuP2Q2jeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785809486; x=1817345486;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B+nmhdc2wKhIJIpBwW+MwyfYVUtbdARoiSCqxXo6ddg=;
  b=A+oAF8eeBHKrpZaY1LdAkHVb0p5cuNRNYkCA6I6j1+b7Yf1zX1PXq5xC
   CCYLuXyr+5mEDduReFopmvLCEIR6zHbS4fHruNdJiRjUHcaeFheopJiEZ
   ao1RkAhUDfhzFrmsAGZlyIHeeN1c1dEy4Spp/famWMwvqGeoRbY5Io4f2
   qwvET9cFahYkjuX+go+sEVC0YKGPs6WMVlxBLri6KDKvdO5RrFtdry58W
   tBAXZM0ll6ez8pNcmJHUko35kLPwFVYqKtnFK6N/ObtOdPYPq9RZX4NVC
   BWpYAtpvma6v8ABVCF9NJXq/ABgLmLuVJWQ4lN++IIpGccr27mjzOqlxQ
   w==;
X-CSE-ConnectionGUID: fCEe3JI2RPKORTBhvdLSwg==
X-CSE-MsgGUID: 9Cf/Wl4wRxW2EFsVMeDnBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86121611"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86121611"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 19:11:25 -0700
X-CSE-ConnectionGUID: KUMwzY9FTRiSU0SR1Bn47g==
X-CSE-MsgGUID: U8Dg8g26SGOUT5Pc2eda4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="266494953"
Received: from fuxiaogu-mobl1.ccr.corp.intel.com (HELO [10.238.208.47]) ([10.238.208.47])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 19:11:07 -0700
Message-ID: <aaaa3463-87b7-4e01-9f0e-8ff1b732d260@intel.com>
Date: Tue, 4 Aug 2026 10:11:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
 <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
 <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
 <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com>
 <amzMtg4K6qEEsudx@google.com>
 <25ab36cf-888a-4547-b3f7-5bd4e057c1d0@intel.com>
 <anC0uuZIrbxlGubN@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <anC0uuZIrbxlGubN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h55qbfzy4jgpp19dsfscr36c1a8csucg
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D870818000A
X-Rspam-User: 
X-HE-Tag: 1785809485-376916
X-HE-Meta: U2FsdGVkX1+KfyldyPCKB+A4S5HsA5cWznGek/5nhZ6M1bw7QMZegxU7/ZZJX0aGeiZRL8d0NpsPY3IPkPK46QD7CPu3gSIB/gG1ibP4vWczZ8xU+JUgn9AhQPZk7BMp7xxxZTCJIiMmUUe+C5QHz/+14floIaYK58naR4KY2dPc3o0SKRgUt8g3SKHhI0N3mrFy1PtrWbb0uRP4Cq1RRAU5fuImY7Q5pjtwSOWl26qW4NqQRq7hWxnM6sJh2/pyrjI3zJHNln0ZcotVFtEMnLgN8+//yyHxYKsEhLkAYlHqzVeFxpOLiqsdj9Qphe8+IZBxn9zZbzmq0JPOdAB+7LcL5zbgW6wT7fG47qH4CiM9ZwL9O42+ALfCGaWBtfjFLkr4561igu2ih0pusHHq+L8/Tc/f9QgoS16jJrChKHxOzr/eUeU4bk1Mh8OX8kPCh9zo7Oly2FeXoqmL+K0IkcXfESiTIV7m0VY3RWpqLyLUoSEnpHdBnDYJGQuIz6w/gD640yqEou6T1BFj5McFB2nZGR8G66iN4YWxnjxUDtqRerAAJmrRMTmRarbSz4u94H0VIsP0Y17hQYZ5jB1EMG6nZWdkPylmTBG83IdqIUYY4R9+yltoR/l8dkFE4BIsKK8GhS3DKm9JJGG0sStR4tfMOJY/n0Xvwv/m4Wu+1QMQJszOO77L1sb/XKh99blM35XsOszINax0mJXarq6V5fVv0A4r424x+oZ2E2F2eCT/unSReMFDDPB8egTjQXipgO8LYPS3o3nKvjaAVhsNKTu0hEVKvlnJlEBsf21ZeAzt83rHenT+MzF8DhcLDJh8SunaLRALGAP8yoLL5tbz2p/14IPMVFzu9orpWloLT+h4cENYXpFguS7Vv1W4NQ5JS2XjgaTzdaV3bJENIE+GtrQB01ECZMzV91vZeGwJNy7I1T5O5B1ZmNlGme8HcbdfOqNtgfwNMHrSH4KZp4u
 eAqxen2+
 /bO5xV0xbNUmvIzkm2wf+UrGxIL33aUfrUaeDo8eqG/40pvscvtOHPdXzrqR2tIPknlnY+682lTGPUJfIN3TQjl7zvucVFDqFcBQjIReXZfqwK8DVvdkP6AlYo/XRW2aoquzscpyrNj5l8t6ST3R/BZuicevxa/kacw7WTog0iwLI4TZKPmr1zesBY2jEcwNvkSeX7JXYKzFMUuFxXzAW1YAfYlz1MiDdaK+cmrlWsxIp7cfy5+6MW+/iZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/2026 11:33 PM, Sean Christopherson wrote:
> On Mon, Aug 03, 2026, Xiaoyao Li wrote:
>> On 8/1/2026 12:26 AM, Sean Christopherson wrote:
>>> On Fri, Jul 31, 2026, Xiaoyao Li wrote:
>>>> On 7/31/2026 4:42 AM, Ackerley Tng wrote:
>>>> If kvm_range_is_private() is useful/required by huge page support, then let
>>>> the huge page series to introduce it. It has nothing to do with the in-place
>>>> conversion series.
>>>
>>> If it weren't for the fact that the range-based search is used later in this
>>> series, I would 100% agree with Xiaoyao.
>>> But since the core logic is used and needed elsewhere,
>>
>> I don't see it a problem. Without introducing kvm_range_is_private() in this
>> patch, the core logic of range-based search on gmem can still be introduced
>> as kvm_gmem_range_has_attributes() directly in patch 10 or in a separate
>> patch.
>>
>>> and because kvm_range_has_vm_memory_attributes() takes a range, my vote is
>>> to provide the plumbing now, even though a small portion of it isn't
>>> strictly necessary.
>>
>> So my initial feedback was "we can just use kvm_mem_is_private(kvm, gfn)".
>> It makes code simpler.
> 
> My apologies, I hadn't actually applied v9 to look at the full context.  I agree,
> providing kvm_range_is_private() is completely unnecessary.  It's not even really
> a problem with this patch, it's a pre-existing issue that can and should be
> addressed with a prep patch.

yea, that's why I said "it seems can be a separate patch. "

>> And as a bonus, the logic to choose between gmem-based attribute query and
>> vm-based attribute query is hidden from the static call.
> 
> I don't follow.  What do you mean by "hidden from the static call?"  The whole
> point of using a static call is to select between gmem-based and vm-based private
> memory.  Or are you saying the populate() flow doesn't need to manually check
> gmem_in_place_conversion?

yea. By using kvm_mem_is_private(), we don't need the 
kvm_range_is_private() introduced by this patch, which has the 
gmem_in_place_conversion check.

>> The second bonus of dropping kvm_range_is_private() is that we can eliminate
>> one more chunk in patch 20.
> 
> Ya.
> 
> Untested, but unless I'm missing something, patches 6 and 7 of this series can
> be replaced with the attached patches (6 and 7 should be squashed together no
> matter what).

The attached patches are just what I wanted. They look good!

