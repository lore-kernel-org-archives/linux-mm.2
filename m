Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86F9C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6CF6B00C8; Tue, 14 Jul 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9580D6B00DF; Tue, 14 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAAC6B00E0; Tue, 14 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4311F6B00C8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:47:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0BC6C03BE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 84987661332.05.1743DC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id 204CE20007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:47:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MfyeL+25;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784040464;
	b=b+L11f+Qnsas0CREn/sZDuCTy8zrCN3GEOh6WbJ98C86CmBN6TUfttFBLzReIDZVTaxE7C
	2tfv+kBTgRqT+HbtOo6YM5N0qwRPms1Hjy16ccdS6mb4+cWRLrQmviCTaW8mUCxjQXVV1S
	tV1HmaILjOJLNeMstdipSuW2ENpqd3Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MfyeL+25;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784040464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAm/HZMS/xBBjiRrZcx8fcvalyyS2WIZfJSXFdFgxzg=;
	b=EPDJU76yxskX2/wBD6nOSrqnFndnoMoccCQKuqw6KI0ttxmfSZNmbrKNjjG3mI1SOtA5e3
	eDC8ZMtjIIC6364lvi5ZWqm8yMmhKC9o5C+390G2VmSy2RsNkePL5uPJ0+RjqP84gVV7oz
	9sPDvFlV/6O8G9OEn4Z4uC5wnCb6MYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784040464; x=1815576464;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7jYtKOqMf6Pgdjyp1ryXf3vuWp1YoknSmjWLVoh7LoQ=;
  b=MfyeL+25d9+qbbTNuBfB7lwhfBBwGWjKOC4PF2cyJOr7xGqxNFeYVSle
   fXvuIoBvqGLfuwxS2nXc13pchCx4tCLE3mHKXHzkR6+YlaSGnwi/X0Z/n
   AAB/jmkuS0dTJK1b5YZKo7zN6oVeuceEf1+AsFzoCp+x5Rejp6sSHwFBs
   pRn7z/dMv8Rrxe476CxsEb8BrUNHaNDXeh7v19JWBYLU0LHQgKpUbPPuG
   eQ5Q+CyLSYnd5qaoaOjdVjoI5vqXmYHxUbvejLcxdT/+w5+iYNnU9WTLr
   rm087JDn/ixca8nEB6HIY926c42KO3wuRmsrjwNa2dt8nXcgHkcKqy7mx
   Q==;
X-CSE-ConnectionGUID: MSZe2NgxQVuNqMCvywBNpA==
X-CSE-MsgGUID: o4FF/HyUQyCsJJbw0c3WYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="83786106"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="83786106"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:47:42 -0700
X-CSE-ConnectionGUID: OiCJe9CqT02Oh0NQ/2atrA==
X-CSE-MsgGUID: jVw5jRu8SdCoOkbVGYZT+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="249522242"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.120]) ([10.125.108.120])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:47:40 -0700
Message-ID: <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com>
Date: Tue, 14 Jul 2026 07:47:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 204CE20007
X-Stat-Signature: jyadk1baj44h5y9qjqanrxud5z16g7qc
X-HE-Tag: 1784040463-442852
X-HE-Meta: U2FsdGVkX197i7cNnMwUAvl6z5cXett+tFzqCNxXk7cF+bYjO1TGnDi2E5mYQZa8L/38SdHVfAedvvTGNOXp6FPrWNRDg1k2EVLlj0Ab6tnCetXp5iGYBV/pFsuVSYE/dQEJ2Ici0YnkpnZtO/h0jyCF12nmUeO1Sp4zmR8njy51kO0I+YV//LGfIc3SUkCBO95cPOzWC+sACbNcb0YrHUPqLXSl50L2fCYKEmCs7ohBSBuNnPHD06oQb0hcehVkkZ/gN3M2Ut5y4YqCIcFWSSTzyz8RIyb6wQuzc9PgWNecjxKxez8+eQy/70HSyXQEdljW44nUBcorp5YfIBXITxUN+zHuAKvz/D1M0h1lnRmSB51xrnD5Z61dQYMrisRNaGl1ysDQRX+PnUijHUSaiCH7HNuf066K+pS/r9LLT7kBOtOEZvOmKmXDkN+G0yyN3myDLKnc+jWZqw1rWPid8kvrQ5899p78uLwyxnkjgyv7Cv1wrMrIH9eXccbsLyluWdkwseXoMnmlK6wRW9cCvOkqH5V7kCcboLDkoo9iDI49Ng6JmuZKgvDsFbqwJArDwBV7rvc0AlW00AF5yN6GSUuK7DDdPvzM5A91+ZU5KZpww+RDZeRNFiLQ65twMpYxTxqPteGzNruFFFo5Q0A9JGn/QKe1y5SfCiNMVkCmN3cTwpFEOfe/nlMAlxgVsWFDY09Ot1XUyoseKB3ScelpRBVDLWGsrgaiMJnIxtcw+y9TiSGmnpIkKL54XHMwPcr/Gpy2gObdDV/quYdaOWYH7lzy0njt0QrQYWi/PBA2pZR65BQo4efJxDIQTAhVjhqzhzOQSgwKVhDBDA+rUE65VBWyzdLy0VdRrP3hzM0yaid2yjIyKFtM5siDhOvyLCVb6/ZQGI4K29OOjo/fzHIYXxwoCUQCBrVDWSnt8Mid7sdhRxkBfPPzMUBMnvKyFs01mXoFHeaGkCCmzj1p2Vl
 aTQdpgXd
 nymhL4KGw9Qtvo2D9rYrYtLJ0TbPc03u48Z4tQGdhRHFamLMi1bx/n1DJ94q365NEqKaYD24ZJqubVqNW7RWFMsOvuaVyCv1WzTZ9QQVgMwYhqt93rggh79ZUuwUtqfFDVdOYDhbTyjTFF1TZeKZAmoq/6FCUN5pjPr3C03MSXSVjy/OiZdREHVfvZnyYc+XB5Zi6z/6x1pKaljPrscClxK7W6/ShkX1ESeIZvNKSpXDjQsrLPNPveah8gKZJ80OPZUcwv76ZBtYEOWH3OtL6psxLAUPClGzMtqB4UzRKgIMNlcSV0QGhahkHD1CL9Ndfp5n22SoVYDjnlHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 07:03, Kevin Brodsky wrote:
> +static inline bool mm_is_kernel(const struct mm_struct *mm)
> +{
> +	return mm && mm_flags_test(MMF_KERNEL, mm);
> +}

Could we give this some nice comments explaining what a kernel mm is,
please? Part of the problem with the init_mm checks is that they're
magic and it's not always clear what's special about init_mm.

Maybe start with this list?

1. There's only one of them.
2. All kernel threads share it. tsk->mm is the same for all kernel
   threads.
3. It holds the reference copy of the kernel page tables
4. Userspace can't be entered when it is the current mm
5. It has different TLB flushing rules than userspace mms

I _think_ those are universal across all architectures.

