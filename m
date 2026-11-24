Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0030F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PD2N07i4
Received: by kanga.kvack.org (Postfix)
	id 0B0866B0745; Tue, 24 Nov 2026 10:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039E86B0747; Tue, 24 Nov 2026 10:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92D66B0748; Tue, 24 Nov 2026 10:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3FCE6B0745
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:26:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B8F2140849
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:26:25 +0000 (UTC)
X-FDA: 85470389130.23.7200F99
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EDF516000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:26:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PD2N07i4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533983;
	b=jSFO7oxCdW8Eh0XqQbIYAdJxZ8TQis8wypIUyOR/gt22F2wqlFjs011aQ+qICVn7dAisCP
	mBiIo7LN+N5bcagFqy8xCIJ6Z772ri86IZJBJ61qlZ7RbeVP/pEHAEnC1DjX0VkdgFRAGR
	kzZretiIUIiBM3RlXaV4/v/76CcT+X8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYvYFivkhMSGgLZ9Z/6lp6JqgsZ5tsHXQICYdELcDz8=;
	b=3jYbVMcrHP0ayUqN52NfmzGaXDheYpK7acAbHoVAo0aBVPhVXbzgNzXh887tYz5ryTq4t0
	PhQyDiS5WW61YUXVywOIppVGBgk89x61nYfuOHEl3mD/tAV2j0m8SFq3fV/sY9GtNdzNl9
	7zgbHD3fUZCdx8hVBogJH7HAIuc8gO0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PD2N07i4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795533982; x=1827069982;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tYvYFivkhMSGgLZ9Z/6lp6JqgsZ5tsHXQICYdELcDz8=;
  b=PD2N07i47bUO86aur8uCAN5AQnsymfmu1f7l1VM1GSi4S8Uvw2XpL7zp
   uC8cXXejREtqoy87jDNtLzpCOQ8AfRxFkKPpfZ0zn8ZI/xyZXIWfQgS3C
   li+JtSdACYrWGrOr9w4bLgNUG4kkm4nyUPL75r8AP+ODs/TUpy4qDbQ8a
   mPZeT2pFS+qXrtiMOCvf0gOIpNnn4RpRUBhGA1aXjTkTV/JCb0UGnBBkp
   2MXzrN2ApIbbjAPkBY9hsncoK8lDsEN9FPjAo89yh+m1OUFimhsKajAFc
   aLz7ZgNW0+LsEKU1xS0rp2WybiaM3O/r0Ns7E247ir487koR2E+NzEHB5
   A==;
X-CSE-ConnectionGUID: wz2bMXqUREGT6q/x5LXWKw==
X-CSE-MsgGUID: BpfN2V3fTjOSNIiUYkuKHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4401691"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4401691"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:13:26 -0800
X-CSE-ConnectionGUID: Qa/1HRaiQmePlyH13PIKTw==
X-CSE-MsgGUID: MA/px6TYTcqdq7oX817u1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="12023784"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:09:45 -0800
Message-ID: <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
Date: Tue, 24 Nov 2026 07:09:42 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261124133241.221719-1-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y6ybdaia9y9kyy8qfkcd753uh9y74res
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7EDF516000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1795533982-649354
X-HE-Meta: U2FsdGVkX18E4+ILXF8O8D3INXkDt78fEVhf5n6sZVsjq50nDCIOAfBiZauyDC+rBXOmxB51JF4l3BEUUsOfyJAALsaD8YD32aQuQ21dCgD8PzGAjC3R8FizaN051QTYbwr+woZQUIn6wn0zenICQl97+zz3cOtrS1NTDspcXXKnf7RXVTsRK87DU8K6noIMFkTfC9zc5p847G8cVp8j12yHxEV02PZdhoEwQJ5zpo+rtHCnDoY5xgqKJ5wjLDigHcEBzTwEdh2hR57n/uWYCs+1+N9axqc1+iVTs21Tepfbo0WGCArK3JsdUhQh+FsXRgY8ELjLfRMjycYhBbuI8A8hx8DbvmEbmp40Y0eYEdimh9RmGplSqMJJch8G3RVyVXzPyn8gxNugLPoDFoyOn0+Ly7CDTnDb77KPqpl5WzKgDRslSpFaDjZzCVUgvd0B2LntJP2DQwHUkIfiJQpYzZfV8XEasc4WUtslY4voSjPPhWjHhcDXr3DsUY1ivG9Cx5ChGVerJ0N8/36QoFlkQnflg6nzTTtXfk6B9lx199Is9jqNuKP3j0ko2Md2H/WfaBXKKMSDOwPSORyDWZXLQ/ZVU3PdtX5YhXwOxbZ3IrQvpWHyr3mP7rNu+eP1Ao7BgYJDrxIgIMFYXURpzhtk6lDxbrkVBMo/VAOB7+xOXNJccDhuStVzI8uXij5qDQT22BRZp7gbtINNRWNsnKLOCtznmmk/1W0oYPwCx6FTOkjAeFrIqrSC6C1/bXZmZfgjSKn+CnNpFg6h+t6z48Cuwsf0+TnI/zoYvxFHHoACUPjRVXkGR4IjG48qJDjprSIyQwodEGcFe5hemRpTLKDFySqCeikyHxFRIjkZyc38XFbDE4b2grvRYlcOjmpDQre6WiCxl5Vc/jTTmgdxRdfly3Qzcsm4a3CXI9ZsdQPcdUGPjlCpJ1eKM7xPOQwKp7o+ia1wowM4p9XrLfqouG3
 9oxgyFi8
 ZSkLXQIxEOfolYwZ2yaCJvwz8YtAFpUaF52nsgQ+dJJTkjGwqh1CTQBjWmq+CfwpFm1/fbfMDEbhlEL7kipdjw7dan6JZ0jcVgg34EMS3pvvVnGDy9KzD9hWK5AV7NdqDpSi/rTFfexCkZSQXDSOIgdozBn15X/JoLjaxOcr+N0d1G/KYbkNAIxpHVztisghUvNDc73LL8E9pZDDdkkMSj+XKIc3BYURj/bG+G80HP13lDvbiiYuvhy0hTSN0vqoQh6Vhrx56ehhM7gqwJH7idOvpB8B//zjAhfM+B+5AraGRWEOrJux/0duys79zAjKljNaz2uExPrdf2kuItwV9LUrD37OrDom7c5PrA1dy/FT2Hg1lvL/cFpHbQE2EUHatUW8EVxtJsZWbdkhLpRkmBqajrMJERBk7up151bbWZBHBeQYwvSH+gIBV8tr3UnAbiAmM8WfxqScAYQS1h4+YyQh+/UkqwGvRFB+kWD92WiTHnurTQo+5s9luSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 05:32, Pankaj Gupta wrote:
> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
> memory bitmap before the command line is parsed. memmap= and mem= edit
> e820_table only afterwards.

memmap= and mem= are debugging tools, right? If you use them, you get to
keep the pieces. Why add complexity for this?

