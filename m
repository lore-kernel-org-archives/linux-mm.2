Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63C3C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687556B0088; Fri,  1 Aug 2025 10:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F276B0092; Fri,  1 Aug 2025 10:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5748F6B0098; Fri,  1 Aug 2025 10:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 499F66B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:22:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E12F2140210
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:22:51 +0000 (UTC)
X-FDA: 83728404942.05.B632731
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBE7FA000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:22:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F74/a2Go";
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754058169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrKvqOTTeDmmlK2wPlGTzcr6zzrYd71zNNQRYkXXFHg=;
	b=PPwos2YtEmigNZtRqoHkGx5MwpmCLpmGCIionQjnIqb0m4SK51hphMII+oDMerJJTj7VYp
	fly/xCw5R2PlQW1QLrrwCTb831bmeAeKfI87nY3XmpWwr8lm1ezMdRiTjSNxqxBilbsVwq
	qUz7PtXTFTBaAjy2/TQ020CO27rnxRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754058169; a=rsa-sha256;
	cv=none;
	b=Lv2J1h8W9W5zrsb3pCuA6iN/Sfd/SZTLgGjnzP7HV4cA662s7v+qk5E1AWZ2VMTZh7zOMm
	ScLnT/YGuWwpnyoqF37mZglxt5XWYy0jey9hlzcIuKrzTVpPm8Op+5OmDAZsjHtULlh9Zf
	u0h0Vay/T2hrJJyB2uU2JxXqtAMCmrY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F74/a2Go";
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754058168; x=1785594168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R8gdx/rlUEZmt+RtRpsjUtcCGgtiXFr2+h4yEpIqmpA=;
  b=F74/a2GogSaAksiewwbi8/IIHb1gf3zoVIYbhVG5YyYQYEXQ0BdklRRG
   hsmYf9x78m1hQpJVOHmj8tgsqO3XX6OpXPWxFitkIDfu2ChvjoaoTNaWf
   MVxhGvOeqtV5tBc3++GQqaEl0OCcUPwarM3DCkA2Nc1e/Dt4VLgtu3OPs
   eLE2RQvLjrYiJ4VAbQYU16eWQO8NP1G+NCkVgGhaKLqlU02pSN6KKllhH
   IZorr8G7N2iY+Qp3uYaQW0kc+iH5ufG7t1VDkQxxUJ33QKS16+mFjwOdn
   rv7CceIy8Y/vkH05seT4t+D1RBHUDyhh4HNqrdNl8yFWK2MXSb57t6rPy
   w==;
X-CSE-ConnectionGUID: ZSotWJwlTF+sMwmL3ilEng==
X-CSE-MsgGUID: Ob5my1v2Qh6v8VQ/GJr24g==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="60223926"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="60223926"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 07:22:47 -0700
X-CSE-ConnectionGUID: 6hznr9LGQhKITDFl+xzaWg==
X-CSE-MsgGUID: rkSxHCIaQDaZGP+fdThzoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163949374"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.249]) ([10.125.109.249])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 07:22:45 -0700
Message-ID: <c59aa7ac-62a6-45ec-b626-de518b25f7d9@intel.com>
Date: Fri, 1 Aug 2025 07:22:44 -0700
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
 <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
 <1c42680f-c962-4a75-998f-031008dd8343@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <1c42680f-c962-4a75-998f-031008dd8343@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CBE7FA000B
X-Stat-Signature: aw6k3uwxsndoottrd1azf47ets958zmg
X-Rspam-User: 
X-HE-Tag: 1754058168-857173
X-HE-Meta: U2FsdGVkX1+D/YUCsEqnbGFLpk8DySbznhDFlUkg7fLXroYyAYlhoiCmTW5i0hg/v9BKxJlLxd9JiVv6bTruMidiTxydK2DYuH6Qk3GWrLwIX88NYOBNdYQFhcZ4WQ0hOQVXybaOaptzq//mDhaWtJiUD7n+HjOFwNbaCo378AXl11qyzKIxWo0o+bjiRWkQSBotdMmiiBfwS/nn/toi2/adD8Rcm3Yic1dvhiDEYY0oZzcni2LrBdmXx/IyY3HPOCJYVgBQPexp1XAImaShAQCjmyQq2STvNPwbC6i18A8eru9qbhkdxDrjZPb+V4WqLPnlwEw8wJtVTT90QK701kVnsVEvgqII+jiy7vB4wMGcJyLxehxrHWN4q5aFGrvXQ8AIGCtEHKq2eWmwcjFrWyb048TC7rTgFpvpb90B0dlLhj7/9juY6rxlmx8EHIDkW9YfrkGvQA70q8oelBndrDo1tlUvKbswAMcDdMZZnqjHlaWZE3DktOOblHNKphhfN+RtObEwRMWIoIxQcLiNHcz5IeyLF0YUj/zfYEAtQ5qf1mbSLyMdrs4rnL3vG3RCGxeYDnXiBP8zhZm/c/1uaax2cnkHjnVaPRiTklLmzLCye4ft3i39S+EHFrSNM2NDzjP3TKux4aAJlXBbXXG028sJr6VAMh1jyAGe2Soa3lUAie9NeOuuB3js5YR2O7K5rTg8RJVrenFtzcRwFkXNJVZx5s2++7cM+8oh1lD6rJMEb1ygtqmQnEQ1hACQBoC27626dMbDnuH55cWPRUFqBUXl50ErbkmKqI1axpNLYHw5+5UILwPIpBBKuxG05M7UVl8FIyjVI/valA73Ni+TD4fnCQvoTBdTSknPjl7j0xlFBokpbqH5ReiHOEFR6hNvkia3Gh8YfiViQui7i7Y7cARtLaGD/O46Ax4aEMrB9SBX/rwx+AMyHTM42I4C5VkMQ6lgd+eQVFawMavCYyP
 H8e2n2Oh
 eYAFYJFjpqUXv0n+32I3wfY5Tog/ayt0UyFTKKMoUEU9raKJRPSjqu/zGK1SJ4us0wksAuO4wEicIYvNMB07pitCuS80IRZZJHidb+0QLBis7Mj6/44+PoqwXxszn2BF/N07VBXeH6liKhKVCAEWqEkMTAINO5M3oNcLm1rUfgeO54cmKKK9wkVJm0TPhvcMHigod049ukUppawPDfS1BKizwKFkAjlSFvdRn+WDhIzfHskOkQ2+2VtPFZ8yCaJAnBgu+DYWMZ/k0q2YF4EzVx0I4mHnxSts12ecV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 21:43, Sohil Mehta wrote:
...
> Could deferring enforcement lead to a scenario where we end up with
> different CR4 values on different CPUs? Maybe I am misinterpreting this
> and protecting against in-kernel errors is not a goal.

Sure, theoretically.

But if that's a concern, it can be checked at the time that enforcement
starts:

	for_each_online_cpu(cpu) {
		unsigned long cr4 = per_cpu(cpu_tlbstate.cr4, cpu);
		if ((cr4 & cr4_pinned_mask) == cr4_pinned_bits))
			continue;
		WARN("blah blah");
	}

Or use smp_call_function() to check each CPU's CR4 directly.

Or, the next time that CPU does a TLB flush that toggles X86_CR4_PGE,
it'll get the warning from the regular pinning path.

So, sure, this does widen the window during boot where a secondary CPU
might get a bad CR4 value, and it would make it harder to track down
where it happened. We _could_ print a pr_debug() message when the bit
gets cleared but not enforce things if anyone is super worried about this.

> In general, you want to delay the CR pinning enforcement until
> absolutely needed. I am curious about the motivation. I understand we
> should avoid doing it at arbitrary points in the boot. But,
> arch_cpu_finalize_init() and early_initcall() seem to be decent
> mileposts to me.
> 
> Are you anticipating that we would need to move setup_cr_pinning() again
> when another user similar to EFI shows up?
Yep.

