Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACC1CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8327A8E0144; Tue,  4 Nov 2025 09:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3918E0124; Tue,  4 Nov 2025 09:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D19D8E0144; Tue,  4 Nov 2025 09:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4C28E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:27:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07231160563
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:27:02 +0000 (UTC)
X-FDA: 84073151526.28.9482539
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4368740005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:27:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VKytzpOF;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762266420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQucRIHTAGsPEJrAbsErWDwNHN4Eq8M6bys8HrGkEOc=;
	b=JN7BcihcEGftD5Im195FWebRQJcSkYDeeiySoLgTv+FwXfiEY67olJpLJMV+jvGvJh+FTw
	T5m9fxadGho7/lwWzuAvXmStPg9x0OWVUhoFfP1pqcNSM3iGqNqPS50KtnXjMUYhZdWzeo
	kKpzZEZ7HfAIFh3h6XaXobq+UEObDLY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VKytzpOF;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762266420; a=rsa-sha256;
	cv=none;
	b=jfTfsFuq/xtVXixNSubysrhJscA0pCpDCb4W3Nvfl3b54GrYnhQ1sgyzNQ0uqXAD3xcfeZ
	jS4AKFf/NCyUZERVXrWUD71wtSkBA932FCFgdiRmzIdc8EwQY5Zfw8yv200dQdP6s54qIk
	m763r2BUNckYdPmQs+ut/RgOjRYMUZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762266419; x=1793802419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IDwF3Uy+dHAw2yHyo8OlsKhLSef6SFWeAYInQaGIgug=;
  b=VKytzpOF306QcqH7Xu5/rHFMNuLkobRcgtRiNQvnrPADoYtp1ON5vxc3
   QwmMaPMCMXSQADcA7SlzgadnWxcS51k7+EGsPN6AZ9nLlfN8iMf2lKwJi
   JoRyPzDcqIm372R9m7CG0dEzBBzt9u7IsEG7ag/5vHjdYS13ItV2a16Pc
   craPmfxYLwCquEtn3WfA2Ej3FSRHclOl7AYqV012nxiUvuZESxHUzYOj5
   5moLMFPpAF+FPRVYWsaZRQhblsF1Ai2201Yr7Y689oRHbqptoAOQK/ppP
   HoCPkWEBBm1vu3Ffpoqg23CwaT5QM8LiCFqGIWFtipYM2WrjvbhIxME5A
   g==;
X-CSE-ConnectionGUID: ZCI5DP/FRH2cc9UPel6mPQ==
X-CSE-MsgGUID: Otijgpr0R5WePw17vs9zvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64245830"
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="64245830"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 06:26:58 -0800
X-CSE-ConnectionGUID: D7xvNA+0R76wWmLtoIviIw==
X-CSE-MsgGUID: U6CJ0f+XSuGRaR1jIIer7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="186857506"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.166]) ([10.125.110.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 06:26:58 -0800
Message-ID: <47b3e8ba-bc95-41ce-be0a-ddfd1323bab3@intel.com>
Date: Tue, 4 Nov 2025 06:26:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, david@redhat.com, bp@alien8.de,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 luto@kernel.org, peterz@infradead.org, tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20251104072306.100738-1-xieyuanbin1@huawei.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251104072306.100738-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4368740005
X-Stat-Signature: d759zreqh5xokxhao4i3dym8kpiosof3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762266420-881091
X-HE-Meta: U2FsdGVkX1/in0AhVueT+xjunciRikDQ/myfnD5WPTw4Dxz1IvzHMJzax/qgQB0aDqmIsm0tQL+oMuntx2I+RN9wimmu9DTTRBKzHeCSckbrMCRd+qp8DqiNUDwGQPh+LbL0mUAGz6R1qHc2etUq5FZuumjWnuD7tQ1FQra40pb2scp6BchXVhvmcRiitP5G6OCxPkMvQ1ss/8qg90NnP0EbRg4DgLCY9Is/z33tMu9V/6XohJQkjzaohuAbFj6sfL1pmSriva/U+z58fBf7vW7pjch3r2qUT2eYpRLRtpIJApPxkn+QgiIJc1v+HndqN1nlWD8mebQiLdBkrFox4MaiqHhaUSC8QEWIiaT/3GWgT41UMhngi9ztpQJOqdNDirZEQL6pgYdqoGHXaVJmwDnQv3sH1NimYVvrErwaUbMT1CFhYFlJXuB2bKf9VNcZBrncZavfIlaOjYOPCuiQlokW7/83Rl0k0pbHKoXgJpgNZ8lYxvrQm2trlanXlNzNk5rwBDSqejLq9affa5LpoVFWOT8FMdgrkxS+BbUqmea0/DeWgDQhYmAuTk6lYasjU/Q3FkDBLbiqPIIXO+NLVVef+lw13xyWfywwGB6qscTNU8xfdeVlYPkISUKtb6ruFBc2TOMH1rlNqqC9nBTdBJQoJlFX4H18ZHtdBA9tMmZFb8gYAyGYIZW4rBnS0NRlahYn9j/lQuNO+gzROVoT79n8MFzDFoaprTbAj5o6Gu4itljxzRxDaDSeVHHLfkt1MTc8PK5bvNaBVJZ0hVJfgkR5pqJj5rKBBF6BQYGhn6cN86kT3fs2UUMtLDD+TbTo9u1kw2ZOykd7CBYXj0i3lif6nHe7OJfCdLrMaYc+IeMUENtMB7BhK1G4fOAnKxs8J9mQqeoQuFv61Ga8lB3uNZm8fVYCZf6yDldTluLQQEaA3IpSatyr41X/cpw8voXIVmhIQw1xj6shCoh4Hs+
 hB9jUkF3
 C+LJREfRIyoImmJCdokDleYMY18/Td8cK0/Hg/gIY7R4iAiPAn4VKdyCDLNRz1iKqX57jCXEy8bP1xglRSBAzVaE1lrArJ0Sj3Kl6yRzVT+Rj4b0BFEaNNFOTdXSDfyx5sD3zsTCIRO+88tJLwgMw4bPzAVNzkVdKg1DaH1nvUY0e/MV+NBRPO0EIw56V0wwOnK++v8ykGYgEqgCzKjPiEIWQcj/xUoMeF+X37Ik3jHZHUY7BOT2p6N9K5ZsPsGlpyb6v+0gkg7wjQa1lsvCe2rFUAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 23:23, Xie Yuanbin wrote:
> Memory bit flips are among the most common hardware errors in the server
> and embedded fields, many hardware components have memory verification
> mechanisms, for example ECC. When an error is detected, some hardware or
> architectures report the information to software (OS/BIOS), for example,
> the MCE (Machine Check Exception) on x86.
> 
> Common errors include CE (Correctable Errors) and UE (Uncorrectable
> Errors). When the kernel receives memory error information, if it has the
> memory-failure feature, it can better handle memory errors without reboot.
> For example, kernel can attempt to offline the affected memory by
> migrating it or killing the process. Therefore, this feature is widely
> used in servers and embedded fields.
> 
> For historical versions, memory-failure cannot be enabled with x86_32 &&
> SPARSEMEM because the number of page-flags are insufficient. However, this
> issue has been resolved in the current version, and this patch will allow
> SPARSEMEM and memory-failure to be enabled together on x86_32.
> 
> By the way, due to increased demand, DRAM prices have recently
> skyrocketed, making memory-failure potentially even more valuable in the
> coming years.

Which LLM generated that for you, btw?

I wanted to know _specifically_ what kind of hardware or 32-bit
environment you wanted to support with this series, though.


