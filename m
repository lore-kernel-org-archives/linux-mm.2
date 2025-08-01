Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C390C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4BE8E0002; Thu, 31 Jul 2025 20:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EA98E0001; Thu, 31 Jul 2025 20:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16358E0002; Thu, 31 Jul 2025 20:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0C68E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:01:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E8F11148A2
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:01:51 +0000 (UTC)
X-FDA: 83726235222.07.90C7400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id D79CC80002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:01:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bNHy4J7c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754006509; a=rsa-sha256;
	cv=none;
	b=x0QYm9l81fG6h2ZRyaV+Jrvp2dXdOrbIH8jqhsBrnCl0d3Q8fbfgUXssNM37NHtrveR5wP
	CFc5wVI+eIYRK0Tn24kFCMAWoPuZMbFefAgmOIhMvEjZDfgSRO1Mo+ANp1kiGfnnim/qUs
	cC0A8/5Q3DRaMyAK9Rh/mkAAPVEi/D4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bNHy4J7c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754006509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySpoEGAAgT62IgZjG7h3TunT6qx8sRaYDgbb77t0uVk=;
	b=FBe30/FYS8xslWeb0kZSNU4S5IBfWtU9K29fu2K+QXaTi3jFAjQhFxNiDo5Va3en4+hl5G
	MxwFBQ36qbTrCmIUhA+qA042DAe2YOmFv4sjCGKKrd49htINvfRvYezvxVGabt/iihH2Nx
	Vs+rfXj+J51HOj42E0oaBLZRNoy3Qyg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754006509; x=1785542509;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1eMiJ7biR+ze6mCfiSgA6AfqPnXORCkRF7qJ0xrnJ/Y=;
  b=bNHy4J7cokFRCGB+rLw81Bn4tPw4L06/dUcfvLJVmn43ihfU7pCOTcmN
   jDdjaSUm6/ujm5avtssK7fVmjeLot6t6qSZqVFGayQ4ixcwT+2DZzRhHj
   yEhH8DftKqC8kzfJlm+jFqnXE9WrovCVaaiPfCAcqTBLbaPjRiqD/J5/u
   WgNCrylUkw2MIMDBjcBbLkY/dG1GuT2EoZJQZgRNNxz6rlhtFWKMBygFK
   KTaASGYWxr1PjBKKND3o9lcOhKgQczvf9yM9elM8MzIvqGRS5zezYPl7T
   wStvvDznhLJwVQ4rIv9pfLKpH8rmMP0+/eRmIBVFQnZKy6c3yjHTXO3fE
   w==;
X-CSE-ConnectionGUID: RA6XDHwJR+mRX92RyhRvzA==
X-CSE-MsgGUID: AIj0OyjUQR20Aetp25ebLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56043753"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56043753"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 17:01:41 -0700
X-CSE-ConnectionGUID: KF8Fav4TTe+6FIeh6in4Qg==
X-CSE-MsgGUID: QxlgbGzmTCClfHyUq4ajLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="194235490"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.228]) ([10.125.109.228])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 17:01:39 -0700
Message-ID: <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
Date: Thu, 31 Jul 2025 17:01:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 04/16] x86/cpu: Defer CR pinning setup until core
 initcall
To: Sohil Mehta <sohil.mehta@intel.com>, Thomas Gleixner
 <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Kees Cook <kees@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Daniel Sneddon <daniel.sneddon@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
 Breno Leitao <leitao@debian.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Alexei Starovoitov <ast@kernel.org>,
 Hou Tao <houtao1@huawei.com>, Juergen Gross <jgross@suse.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, Eric Biggers
 <ebiggers@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Yuntao Wang <ytcoode@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Tejun Heo <tj@kernel.org>,
 Changbin Du <changbin.du@huawei.com>,
 Huang Shijie <shijie@os.amperecomputing.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Namhyung Kim <namhyung@kernel.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ardb@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Xiongwei Song <xiongwei.song@windriver.com>,
 Xin Li <xin3.li@intel.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>,
 Tony Luck <tony.luck@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 X86-kernel <x86@kernel.org>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
 <20250707080317.3791624-5-kirill.shutemov@linux.intel.com>
 <6075af69-299f-43d2-a3c8-353a2a3b7ee7@intel.com>
 <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D79CC80002
X-Stat-Signature: 4zhiqtdw4k7dzeqrgu349dkwtuozw9wn
X-HE-Tag: 1754006508-467827
X-HE-Meta: U2FsdGVkX187XQuuoxMXKzsb0auQiylBDgSyB//p91yxCCUsDSn+pjUCkRROf6qDxAdMIvC/nSJXtWTTSl+7p5SP+kPrgZi5gtpalm1TQO6F4Jl7XMCZiE6aexVDq73aiHNCJZVzLByloi1Hmy7M52agSZFvRVN/7/PLzB23c+63HFDt0EHMUM5i/bDLDcId8yBOGL/qC1i5JoVQyaFTKBEdoBGN5VzkxhQxgxLXaKoPvvMx2UMyDncK2sq0CjIrHkwt28dolulyTBzqlfBYI/Jf4o5C0iIb7reM05hP7/5no+4KVq2CyQmTzyHrO7Dzk2JHvuHJ1GHczUPCNoCmUpdxT2BQLOlIvMnZwCoy6GMlwuAjUTOF/EAjB/D1JwS0eZGYX2wsQGYBMaJ8SF4+a7IXs/ZXcGEKhEVlKVKu7NBlT740HDqooOLtzzGVGWUKXw4WJnJv/mmMhIM5vECFC8Qd3w1RAlclh5wP534iPaXBtkNb1Ir5Jc1JWahVo8Z15klILE1TTstbLa5hBNQ1W/0ZNJremku+7njRp/cATBdB6JuORt8WZMdBB+A1Qet8LL0RMMvVYqYSJp5C5KZR4kFulYKnffNbZvRpyhoS1lTFt3l6OmR4utEONUQ+6TFmURmgkw69JaOIs7NEiN/ind5Tz2cfblA8FYzAEAW17tarEBZcqBmHPCZp//9r538ycOxGuMBqKIx9H3OpKHqMP+wOw7Na1jGxYKFrVXOe2iseOEF5MrK6+axoHiW/jyakbk90WKo5HASnL2sYh8ONjCSLVH4QuHo8BUl3HxrSUjLfXk5yiPrzwUkt0boY1D6c97aRJu8mqTSy/nB4XxMOKLQ+3zCkIMZ87iu6/AamL5Y5YzvY5eXwMU0s1yfD7Em6xXgeNAKK0O1iWW/l10/6eerjO94fgFCSBUwCjfYQU4MAflEDoFXiF1iGDjl+0t9fXaXLspl8FF/I7Pepos2
 wpu5Tc5v
 Euxl5U9Uh/chUMkvU++WEqGJlQYN1j8bZkS5NoSV4tfLVp09i+4dNSdt832HslTjGAYo1SAG+/JMj+lwfl8lt8bo6WDnrx49j19rHCQ9gFXPuxwIt9UOI4eyMVolJk5jfCo4VsAgPRANyVibTUjIj7vvejNekJLqihwS8bhSXP0jlXHySXTV3NfQk2sZ1z8G2RzwmDjb143dRW4/M71Yv87KDJlQ8/MBXZZzZK3KucNHgPS7BdXhionvFg412an1f0L+lMifK8iCAcAHXmhyAnw3/eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 16:45, Sohil Mehta wrote:
> On 7/9/2025 10:00 AM, Dave Hansen wrote:
>> On 7/7/25 01:03, Kirill A. Shutemov wrote:
>>> Instead of moving setup_cr_pinning() below efi_enter_virtual_mode() in
>>> arch_cpu_finalize_init(), defer it until core initcall.
>> What are the side effects of this move? Are there other benefits? What
>> are the risks?
>>
> Picking this up from Kirill.. Reevaluating this, core_initcall() seems
> too late for setup_cr_pinning().
> 
> We need to have CR pinning completed, and the associated static key
> enabled before AP bring up. start_secondary()->cr4_init() depends on the
> cr_pinning static key to initialize CR4 for APs.

Sure, if you leave cr4_init() completely as-is.

'cr4_pinned_bits' should be set by the boot CPU. Secondary CPUs should
also read 'cr4_pinned_bits' when setting up their own cr4's,
unconditionally, independent of 'cr_pinning'.

The thing I think we should change is the pinning _enforcement_. The
easiest way to do that is to remove the static_branch_likely() in
cr4_init() and then delay flipping the static branch until just before
userspace starts.

Basically, split up the:

static void __init setup_cr_pinning(void)
{
    cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
    static_key_enable(&cr_pinning.key);
}

code into its two logical pieces:

 1. Populate 'cr4_pinned_bits' from the boot CPU so the secondaries can
    use it
 2. Enable the static key so pinning enforcement is enabled

