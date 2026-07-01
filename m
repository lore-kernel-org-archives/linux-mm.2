Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9C7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA59B6B00A8; Wed,  1 Jul 2026 04:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E566B00A9; Wed,  1 Jul 2026 04:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EE76B00AB; Wed,  1 Jul 2026 04:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955346B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:05:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14BD61C4FA6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:05:42 +0000 (UTC)
X-FDA: 84939473724.02.DBF4036
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 413DFC0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:05:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FQnMfZY0;
	spf=pass (imf22.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893139;
	b=PlLXZhx2rsBG59zeVn7HmFpCNl4sUt2tG7EqPQ3LIpnhXbfYDyjVNe8teZLx/EF/KThg7V
	jacXBhnubRQL9o2DfF6HexWa22KvDMTb0EdCb4TB/G+JjjrCWUtieZWYvJDWbSgGBxVbNk
	XDF89lvv4qQ3D0IcA50kO2NSZwrZG5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piR5VRMnb6+1lDNmppfh1ItQACJyCjxUS4jFcghb/bY=;
	b=X/ArhHomCGWDSilqKLUbyPfjmD70VkZgE3yAd0cDlrz0QX2EyUJ3s6lyVHmZ8oMqpsD8te
	Jq2NJTQ6DgVj8NxUh7PixegjsXhJDif5fzih0ndHTko+oVYEIOliGFWcYzwd6zahhJPo+W
	YRrOVrCrf3BqUoVeuSlGjqaY+w4ejhA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FQnMfZY0;
	spf=pass (imf22.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782893139; x=1814429139;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DP0eg4B0OM8TO8XnS8C6gHlWxSavTjQl03mk/DOj9RE=;
  b=FQnMfZY00VYPxz8UpUgTtZallSt5HLZjXvQLkIj4CZE9Xhaj6rSkI5e5
   lvSBLjLLeDzMpZcP/8RaPMx1reZKbmKqxCH4QmCOcyM3WNzRKZUzBc1i+
   IWNo1OIo0QXVyHQnVEayNSfOIg+cp/5Bxn2NNcqSQnpAwLCaMWmugIdvu
   HRP0kNWN+3qiU5D+6h2lejaHT8Hf0eiBIP8Vwj6AZ0bavlZR/NOHmcmok
   q/c5JnE1/PWTJid4Bj8sAVi5A8/gOx+DkmgCX5tg1O96fizfOVNbvReFa
   KlMckIPpFNf92j7LsSH+1zoR35IorV2anSD1/iscz8HnJqIjyPS1n+rsO
   A==;
X-CSE-ConnectionGUID: AAQIipfpQxuf5f3pptCdgQ==
X-CSE-MsgGUID: tyfDSfNYQ/aL3MZ7DWODTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="94217865"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="94217865"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 01:05:26 -0700
X-CSE-ConnectionGUID: lVWuAtoZRb+S8bw6cD6rzw==
X-CSE-MsgGUID: G3cj1NKaRzaUjG0LX4qnIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="257401196"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 01:05:04 -0700
Message-ID: <3b64e897-93a8-4f9c-88a9-f416ff44b09d@intel.com>
Date: Wed, 1 Jul 2026 16:05:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/46] KVM: guest_memfd: Only prepare folios for
 private pages
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-12-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-12-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kr7qoqc6b1fc7suf7piqn8fazxuycsup
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 413DFC0009
X-HE-Tag: 1782893139-662021
X-HE-Meta: U2FsdGVkX1/bqBSdM4xjfDUI1vfSD0McNyJ5+kRqtccPmVccSnkJ9d26dI+pYq2MHMHvKrvOTCZEDM0CteDsN5LvqBpGxMlHkxew0jo7uL98+mQxBumDiYjP9BXwzpLHbJB7C1gf4ZvRHX1HxGc4SqyJVqAK1adoN0az+jBP0jCpgH2ugvF8GQVC9icSf6A3pogRYwV4GHqkzw3a+N3CzEUf+6hIPae45U918Fz24Xhd84dt0rJI+mhzDny2B0EwZuGlpvDE02Am4AAD+C4ORE1yHnW6Aea723OpuDonhE/gOFHMxhD+tGmzQLouKE6G7OIPErdfZtQ8APW0GuW5d4W8C4QNUBrNsLY9YIiY5xa5occ9HshuNw2wb7SFVu+ub5shvo550ZDXhpaG5BhiUMBvqRXCrOMYbQokSZBnAI3MWM94gP68o59WwCtbxwWrxDTEm38ta7gDPq09rsQvuVK9VCf76hjCENWr+Qo5CdJeO4HMWi0RsX6jnx5Ok26SOjhamqv1JLvy+4Ed1LF7Zn1hp9p2phGbEUvF+is00Ugr22FeOAIpIwpeq3NRDFpFLHTQ2Qe2XMLTC7NXBaRfZn858zhGlMCt7EhqgRnyYhUzufswbyjVpAkETn2LoQxQ85FGqmXd9WbY1FWNNJZLNGsF8UKV3Ui0uEAnGIdsc7w5XNNu7M0k0vrLMrt9259smv8TMJx/N7GlxOHnfkEjHupSzLNhVS2dAPQskr1mkKw3pjzqjIqVqzXi/1TnjEIeFrNk6pWiAcPVVNk8+XUQ0zMyQy4Fgh82Ii8vTL1zcLCqUN/stKZWPTW4tDW3FZo6nCg3T/GSuBmdY4qPsY/boVfmuSYYdxRPjGsUeq0S0F/U6Yk4QKzbmCT753G807mPY/LidZa64x711GX1d/IoJAB/y+WEqj45dIqgyWDSnvEcyIiXuiC47wwwrb5s1iB6R187ed6WjISO3Z47BSc
 zlyDrLsU
 rucbNM9WG6Z8AVKJOYPSZ9F7vC2nE3JbpuFteZXPYgZNiqbJ4AHRaTNQtP2TKydm+uENkOkMKkYlvtLSNYVX8oxYRYu6KuGQPCxU/h8D6lKaJNh6HAN3zYmns6KhhiSHVLAiyQCKr0Uvz3NrB/jim3I3+PfsO8i8YJ3O9JdsK1qBbV5mr5V8tF+CXlpJqiWsBgzBR6eC8Woqy5QnOV8vJw32gedqibWXV8R0usko+Qj5jM2SHpxCmh1T5CZV6KIc+ZbqoXYGCHxkfrNcs+rf9VjgrXk91Hj3uQSIolU3J91tf7yPSqZblaPvAcbR/hD0TGPJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> All-shared guest_memfd used to be only supported for non-CoCo VMs where
> preparation doesn't apply. INIT_SHARED is about to be supported for CoCo
> VMs in a later patch in this series.
> 
> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
> guest_memfd in a later patch in this series.
> 
> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
> shared folio for a CoCo VM where preparation applies.

I don't get it clear why preparation isn't needed or should not be 
performed for shared folio.

Before this patch, userspace VMM can create the gmem with FLAG_MMAP and 
FLAG_INIT_SHARED. And KVM always faultin the pfn from gmem. In this 
case, the gmem is always shared, and kvm_gmem_prepare_folio() is always 
called when faultin from gmem. So it's OK to call preparation for shared 
folio, right? Then what is the actual reason we cannot do it now?

