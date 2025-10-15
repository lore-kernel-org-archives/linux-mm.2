Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB1FCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E428E0058; Wed, 15 Oct 2025 12:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE5D8E0005; Wed, 15 Oct 2025 12:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6528E0058; Wed, 15 Oct 2025 12:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 753578E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:52:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37D8A1A01C4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:52:22 +0000 (UTC)
X-FDA: 84000941724.16.DF46549
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99E9480007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:52:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QsWu4GC8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760547140; a=rsa-sha256;
	cv=none;
	b=2Mk5mBZmBOX+wVGWzj6Pv1UDlJy92KiGSWSw61ypd7QFv4jRaoDhPI1YzwAy64QIu8GmS/
	/eKzPM8dSqWvjrTBxL8166wsVBQnwGiov8MYEoqBQzcMV50JjBWoDtoMUCt83kyu3jTRKS
	pxIBIAi+NUEJO6jjONjNRJDljlQniUQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QsWu4GC8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760547140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLJBLO2OLqfrqfeP9ZEBXUzq5811de1uUgkkChiDSjE=;
	b=GGHcRvWOZ/aLv5eWAXAxLIwyh2hNpA9SzYkquMLtt6LTek1VsPFiBqc2A9r4Ls8az73gkb
	dBbulYy72BS5OwCQd043oWWnp8XNf4bSVK2AilU7WkbhdU6J188lSAN0CxUwSAt4xS+Edt
	Jj8yTQaGPuL7JnAHP39w7ISirHzqDJM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760547139; x=1792083139;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S0KxPqiw5HwIE1K7rWHuBlrawAOZSzzBrpSoYH3rAds=;
  b=QsWu4GC8wcVnz5AqxJHQ/PJCERFBSgoRWafmfHvhBeNSHmTJ+T10zRwd
   VpP+dAsM3d/xWKn6pJCmOwg7uRMTdrRAwZsbKN8/aqK03kVtZFTvHxNMA
   xpz03BvTycpWE8TMHX406Rm4pDxltVnr1IQpOBvd0fn6uqmjgU9a5x19J
   EYMzbmXjbYs+JXhrf9PR2QKMz7bwmo0Fgf8NwNhGmP+sjIL1pFEe1iCL8
   z/3GxrDKrxk0opuI7g4xVWfv3znOuHDS/q0JEu8d6Uo4fBaPFkUyg3+O+
   dNqsjPlo9IbK2eD/WSYiKVxy6bzAV7EoODMlQ8bP4MMTKzVFPCLaI7iwR
   g==;
X-CSE-ConnectionGUID: 8734+jNAQD+rtwsSwCi/dw==
X-CSE-MsgGUID: 4hTCrhSrSKe0/aGuddrdSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="73006783"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="73006783"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 09:52:15 -0700
X-CSE-ConnectionGUID: uTxFJgGnRdqZXhWgFrdjDA==
X-CSE-MsgGUID: u7QBuV7aSXy5YlMObe7+LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="181439319"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.202]) ([10.125.111.202])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 09:52:14 -0700
Message-ID: <35d9cf4f-135e-4786-a4e3-fd3a4a18b800@intel.com>
Date: Wed, 15 Oct 2025 09:52:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/13] x86/xen: simplify flush_lazy_mmu()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-3-kevin.brodsky@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251015082727.2395128-3-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xtsakhgqu48nzdq37wr1bb16k6yxaope
X-Rspamd-Queue-Id: 99E9480007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760547137-611013
X-HE-Meta: U2FsdGVkX1/6DPZVad2cb7QW63dApZtxnW8dj6S0oX9lehxTlshMobYibyNjRVpXdFMDqLYhVE695TWZoXHmXffBFH4dbmZUo/X7KlIuctiRHQJy0/LpxLiWcmwVofPEsNz70gfkgnF6W2t5MduPQ1akBkHYzkefBKa5LtPcaBh2SK1l3oDDSVQPU5kI4gxqK0uGbXZY1ERKxgoJsmOib4wZprqQF0bg4eU3/6lDhWREbMpV4MCBJWPWt0xuEBaWXFUz0pGJdfcCXgWhs+SupD2LIFcu0vI8ncpO9pqRrFOEemPLXRHDBkGiroWRqYpfr00b7awjkrsnnVtm7mQBBWlvvrzP7bmniZaD3kmd6EhDzeQsg2mFvnqkRWRtB81PSfcE/NLnA5fpNdEcCQqoZt03vP6kETQA1rP7j/aZQgyPfolYQwfo+aJ/LCJwnCYm0xdK2r5UyggRicogsXno15VKmRecewTHX+ruO0rSjYH2EcB2b3PWKKC0aAnI0JndegshrPwt1pKHmo7+jNKtUxsTQhZNEEwSpm7nOyAD0eh+Ajgh0UkROPUzdp/FtJBfxbaonI3ut3uNmuA48v+pYJUDBkYryP10uSECy49VCBSyJs9rQhQTUj3/X8O8cPdN13luYZ5s7PyeuCQHm8w/YviJApB+PD+xyCykCZEw8y3zq3VFk1D5iTYAnq400feuDLVRf5WveswHMIg6eSBlVYAnjxCT4nLQr1/vbnmGjWV9Mt/mZTHzJQAkFWjfRmrO5urBa9e3UXtO6wG8HCMh22GR/ajTWPX/XNKcHK6yYddC+0+B1kbBZPWeixCj5tjryTuTstbCie6LnXiTw1fRTiXI6oBUg8oPEuBPOP6j9n8DspugVuW5KSJYXAvHAjKQAu6olsWGrJPspi0zYlcbnAgYNao7POW87UR4YwgyOdzdnl5pFO3rk8hZ+4buMoZahxlIi3iQZkMKB5kzNEB
 hEuez4AN
 jD4klkB3Q1Bbgl/VYJyUUV3kXqghWjZNtqvl7ANCaElR5KM8op5YkfaepuacpQUtBhEvDbvY2j94LP4HZAH+JLLJjJfLMa8yb+vmUAXHjqKfz/gil10fzySP4gJ0R2NYksdwJXxKsGV1vUAoDr96E/94/UcTSqWvXDw7Pp/VoxUOqB2UFwRBwM0lzJun3d9mgSaYDEDHg5IN/0lIgyCFBTJQyKHey+a3ROVradvGFpxKR9PJRHcbTmteXPE3+3iYlBE2JXDYqMJVfveXO8Oi6wBsEBwAW64nbO5KI7XtqhjeKg8Si7YF8EeMPZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 01:27, Kevin Brodsky wrote:
> While at it, we can also avoid preempt_disable() if we are not
> in lazy MMU mode - xen_get_lazy_mode() should tolerate preemption.
...
>  static void xen_flush_lazy_mmu(void)
>  {
> -	preempt_disable();
> -
>  	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
> -		arch_leave_lazy_mmu_mode();
> -		arch_enter_lazy_mmu_mode();
> +		preempt_disable();
> +		xen_mc_flush();
> +		preempt_enable();
>  	}

But xen_get_lazy_mode() does:

	this_cpu_read(xen_lazy_mode);

Couldn't preemption end up doing the 'xen_lazy_mode' read and the
xen_mc_flush() on different CPUs?

That seems like a problem. Is there a reason it's safe?

