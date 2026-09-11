Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA48C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3BA6B008A; Fri, 11 Sep 2026 05:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A44A6B0092; Fri, 11 Sep 2026 05:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492B66B0093; Fri, 11 Sep 2026 05:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFE16B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:18:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B88E21A0162
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:18:15 +0000 (UTC)
X-FDA: 85200930150.19.6B8F43B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA4B420004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:18:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k9HWteiA;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118293;
	b=sIUc/NDWz8p2Vwq1u+bN3dMwJ7dgO97KdStJxT2mCvLDxcngjz/xlHd8zV4lunabtuV/kq
	JGOmp9DF2TWwgDNTPz401Z1kicCU7G8ZzkUhs1EfGW8omtLerrq4onHt9m3E8bflnbbbTW
	oGh4FTD9HGfDWjamNRH65sLMqNVx/no=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k9HWteiA;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwnxyWUILP9LXBY/r851SWT48O9DuzWEaEOe9ghctCU=;
	b=7U9FzDBKM7LjshucVDL0LuHQ7iN2EYNfyb71VQjowDwm+Z10Ch6oZ2yBLrR8nrFupU7B7Y
	EvhAPZa5yyo0HHJ+Wzk8JCp037uQyVQZm6yWXwmgrg3lO97ipAGKzl0t7MeAcqvfBJJUdj
	E4HLi/+bHBTPs7aFcGo4U8mF8nHOTrw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789118293; x=1820654293;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F4gYdBbmajqkyCINPzu7zVwcdxrJlsDCWKhr3p++93k=;
  b=k9HWteiAo8+/USe7Fsm2hgaQGTLyPiVgre/3QwGlv363Ljhv72yN7qzB
   qRraC0/ttt28Yrx6qZUjij0yA021GNNIJToU4V5Zq7ysPhFy1/HtRRQS9
   aqzI+3j1fG5fCsoWAH611D/RGWk1izr1WH9T4tnaxcUPbfOc8/ZJ5a6Xs
   ecjuMo5UoS6SAldE7tRuokukX3Sv8sAPhmLC5qfq3plNYH0x/uHos9Pqf
   roPpRkpBv208wJRlt5tO8pZh17UC6rY8yEGgKmhLpwXwjlj8ha6xZuJzj
   JtMwtlTgcmc0Ve8V0/79f3+ZwR5dzQ4XFvH+PhON1UJ8H2baL14g/BfPS
   g==;
X-CSE-ConnectionGUID: 2cUCyCMNR6O7o42J/U6z7g==
X-CSE-MsgGUID: 3+Iht4LHR/WUhH96KUsVbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89450922"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="89450922"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:18:11 -0700
X-CSE-ConnectionGUID: LGX/EWeHSPeVzgyLApP5NA==
X-CSE-MsgGUID: IuTtAxozTIW46d9/CqObww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="238127"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:17:54 -0700
Message-ID: <9eee9ca8-3818-435f-ae09-78b241050e9e@intel.com>
Date: Fri, 11 Sep 2026 17:17:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 01/44] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, willy@infradead.org,
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
 <20260910-gmem-inplace-conversion-v13-1-dd6fbf94f4e1@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-1-dd6fbf94f4e1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA4B420004
X-Rspam-User: 
X-Stat-Signature: su4ppf355sbud51hmpjrqnm5jzue4utq
X-HE-Tag: 1789118292-423897
X-HE-Meta: U2FsdGVkX1+L9EV1nrszeMIyLI+Gh7nD/HTfOLFne5GFBCcdkVYhsVmpj+32eHyAlfd+IXhuqmtH8zQYXxFIaveMY8Blh25ZCj8L1iX6LeHFBVJbn48kyjQKvAR9/hv2o7S7RXqHq5VKmfdwCnjEYZYwS33Hy3/fR5uKXfjln2Qklbn6K+VrY1i5Vz6IFA/bWZm9gLVh4t4IFmw4R0o7PchCwlAWD82zoDfTRYw/Me9oP7+eZnaFEYx6O3VXVzeMjP4omAVldZKwaw1DXrnBOgd5Tc9lH06f0SpE1XLfxv2ER2VaXOnacD/lQLzsu5jnqAlHG5ukQGfw8Z+J3W3pzemUXOLDKIt9VjsShe30h1P3f08bfFTHnaYY7AUr5UnSJED6F1vSh7A3ac/o49fqqfpqvZwYM/30cAYWcfwDN6V2K/nj3CcVP1t+q57sFVX8KvzdID3UCty4SZLNtrPrmBZdc9OgLBQXXUgS7QXxxxlbgOMHRqPZTO5bSQ+mFYodJJYQHFh+kQmJCSeUEx+JjIjmaV5k0AMVE7kR09PAEP71UYF87krThogGdBCEovKlyeBseUpRqktARS46yKMzgFdXvkys2xTf7oYYoHUW9FY2SAeoD8R/V9+dmwr5mTFrRoUNH9kOk8KK2DZbx6gT4VnFwJjEhgGS8ZsQ0jw54z+ZCiem+Uis5Kz217rDzBCXvBkrFkr5oPmHEQ/Zdy+sZqvJZG1lgptxFBAMEWWiwru0Hj9hQghZdLKx9hW9K8j1nkyikbgKplWcprOiJ2etpW6/SAgO6902yxPPLL2OMAVT0DrHnrTiEDtVu73mM65Z9xY7TXIt4T7bwl/hEulawEWAwHlJ6fxAbebGSZFVg+OZ587DahMlgjzl7J5BPL27Ew8/4/mOyOVQdcjyfQLYN9TgZpQXoDwvsXc4hDqtpa5Fw8BUavMGHf0h6C1ZDOfF5gMzwKc75MAKTolh5Ri
 duJ+qycP
 vhtidhfgT4nZLtMi6+XAfXz8nso36Ijzm0SwAKpvQTcHqpu/RvuyzoevdDwoxuh1eSr9SpmzHqRcoPMNjzKoEaXMEX3sCUBXQXwba8XS3xYsKtilDjrE81mTUKycoFaM9X+335meNjD0DIWdAkTZNwdByGvQ3XSyeP/oYQE94p62yqyj+ZbDDp5h93KX4h8AW9yuU4LSEQsEI98E+1l1jQ+swePw36N0An9hMEwgODmAluiwidWQybmLDWJoA7FBwSMwla0fLs5WPuzPRzhLL72WJsydRu1wNMqAD1kZsBIt6ba4C16Wj+y545SUfX34mDeaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/2026 7:55 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
> of arch hooks related to converting memory between private and shared, as
> only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
> pure overhead for TDX).  At this exact moment, the overhead is negligible,
> but that will change when in-place conversion comes along, at which point
> to-shared conversions will "need" to find all affected folios prior to
> calling into arch code.  In quotes because very technically that work could
> be pushed to arch code, but that would bleed guest_memfd details into arch
> code and would be far worse than adding yet another kvm_arch_has... hook.
> 
> Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
> rely on dead-code elimination to eliminate the call to non-existent code
> when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.
> 
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

