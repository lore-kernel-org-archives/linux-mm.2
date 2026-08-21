Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964D6C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A8E6B008C; Thu, 20 Aug 2026 23:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80ABB6B0092; Thu, 20 Aug 2026 23:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7212C6B00A6; Thu, 20 Aug 2026 23:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D05B6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:12:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D641B402F8
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:12:12 +0000 (UTC)
X-FDA: 85123802904.20.E14D291
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3E6024000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:12:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ejv1plkc;
	spf=pass (imf27.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281930;
	b=6/1qT4Vk7ESR+tmdTPQYCIOzJi6jO4fIlJu4Pupb5jYA+PpxcNndSmpgxq0TeL+K8zZtQl
	9q4c5Xi9/Ol6qLAkHRzzkdKC835698YL0E6o4me+c2ts7PhAxHuY2N2sJCne7uQmMJw/+p
	AOm1jx+SAafcO52SqQ/McQQckG+SGM8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ejv1plkc;
	spf=pass (imf27.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4vHuA2oIK6LAfmHV5Z8rX+eB7Kz3WActUUouAIvFjg=;
	b=meBy7X8M0Xkgp4M2oAZV7w75G/9wHolwk85/A/7l0wdipUU8PAXqZvcDRARxTDbt6Jenmw
	Cc8fJJZsp6i3D0SeXGeHVdCsEk/sqD5BjcCqYWQ2GpRkhMxkB2SBMwuqvXAGwmlWtPFxJW
	h+Rpg1/ys45AjgwecIOTVt79/ScGwi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787281930; x=1818817930;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LLdCyUIMvTLvV0Qwwzwy3ePPzmdPaDmUaU/9K8yTvoE=;
  b=Ejv1plkcKprxMp5PUPZ220iVQHY1LzHbsGGKzgRNZnkE2jTSZmfpN8Bt
   aWo0AErY74LmGVIEDugKH44z4fK400U9m99MUOsjIQnXZ6+eovfZvBtd2
   R1DTPaVVZgenS+8uBJCm1JRMq2K6naI3EpAgn4w38fAVhintCxEtvQQjm
   gjt5qTRIQc7YeRolyF6Obf2SmhAOy2UPOnGNuQHneLlpj/PBQh4g7pBE6
   oic5SIzeScrCdmPH8LAW27JBQEhpEg+K1REX/Jr68Uaeylh0+VrCqgYUb
   gZkPNtLmz8cN87KxWZ6ybtqCnVaCvBfqkzt388llY6Pf/WBW5C9BCHOEK
   Q==;
X-CSE-ConnectionGUID: cLIjjd9pRZ+PaFkE8p/ETw==
X-CSE-MsgGUID: HaQL3rncQpWqMGTnAm+wZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="91701109"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="91701109"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:12:09 -0700
X-CSE-ConnectionGUID: NOkWPYcAQ6ua/qZWMjhxVQ==
X-CSE-MsgGUID: OFKp6eRTSFCxoY11hYwwiA==
X-ExtLoop1: 1
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:11:54 -0700
Message-ID: <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com>
Date: Fri, 21 Aug 2026 11:11:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 40/41] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E6024000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ydm6hwqojs1ct1x1zo15eb6jj3yds9u6
X-HE-Tag: 1787281930-753524
X-HE-Meta: U2FsdGVkX1/hkQ3FZF2LMHDviJ481+DVyNn31Z2FD1dR3okqaD4UmXMBCpMlmAqFrOLbCms+lPuAG8IWE23eGhwHCHPWswNGKLWSko04zSY+In2pfSiCTdgqFxK2tL/xKZ4lm8AsrVehbuUPwE1y8/bKhiMaQnLDOumfRR4NK13Fr7kXjoQEmClViu6bpxA1OTVceN660M8+LQPrI1YRSMCdrGFSm4b2MZBrXSbKBy/F8zs3I71je/+YZEUm52Y8DDlz4AAtucgEWNqvi3dJas6kv54llRL4RDcRNq/cjJkW+wblKek5TuZQPFIInTIcW4XeZLx366ILQdth5Ir2WEhaYyWOMt0nKxKYUzUtZf2LaevebfDMjuFQlouZgeqrgrEZ5GYiEt4bVGs1vsNGj7ePDDimn+jrBze4Qq8YTIbk/Ch+QewxMv2Naho3nUKnXx6FaPCH44RrSrEkgHF0qPHFOQWlQ8kTQsLYmEf3Xnle8NL/74j3EGZfFMCksHynmezdCKtVka9Uy1jrZNFua6VrBn8K9aPans6Hp77Wu9A7o1vnQSfFw7Eu0TZDvIfIOqhTJwjpOvlfqM0LX4hUQUel+NHAw4O1TlA6+S5heLffvomdaWqZJVVJctry2bz62nSr9LWlEfs7k4M5tqIsITzIjF5sXyBnkjiLRN1/P2qJ3+ER3TP8vtAzJNw/ley59K1YTpXpZsTg6WQI+g6wYdKORy1ktseoOT0c80iEsuIIJokmBT2fenlrjUgsxpIzMi3O2FoyNmByr4wmhdVZEQUhdBlFuPnrzmH/LU7MoNwVHZn19iRA9Fy/GtRgJOuivIWlfrfx2QPBWjuPf+4IGtI1NSj8rrX1eDFv5NINK4XSbraUD2lm9Yx9yLdBzpEnfIymniybdZaajNoMRYf66XpSEtHRQGbla6ZKB6Iig2fvrHigQBjwZVtz9YB7yFBCp8OisaLMgsgOK8MhXaX
 +MNAiL7H
 UeNq+oMdlh56hfm5yRPgJrxajdLV0NFcT8JZcLZD19QaA2uAKfjuRy5oH1g+oQFMTfeC/pNcZO4RplI5N7wcW3av23eCvJtATK5YVxPMYh/FrYAIpiTbmVGQCFcLwildKOWPASq19WI/rfQG++DNx6Ybuskmp0zL9HNiDcxszD7srnu/anhe5q0LILNXcDdLLigzZk4RbVsJECEvV8BzMRoUoZSypRSSwPTNdEnI7vwbUokKN5IFjpCoiwWAAolHRQ1JSRXFTLFjnU23wqGU6X2l1YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng<ackerleytng@google.com>
> 
> Update the private memory conversions selftest to also test conversions
> that are done "in-place" via per-guest_memfd memory attributes. In-place
> conversions require the host to be able to mmap() the guest_memfd so that
> the host and guest can share the same backing physical memory.
> 
> This includes several updates, that are conditioned on the system
> supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
> 
> 1. Set up guest_memfd requesting MMAP and INIT_SHARED.

If I understand correctly, even with in-place gmem, the model that 
shared memory comes from the userspace_addr and private memory comes 
from gmem can still work without passing GUEST_MEMFD_FLAG_MMAP flag.

Since this model is not prohibited by KVM. I think we should keep the 
testcase for this model to ensure test coverage?

