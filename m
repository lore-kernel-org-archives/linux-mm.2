Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E9FCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267FF6B008C; Tue, 19 May 2026 10:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218766B0092; Tue, 19 May 2026 10:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12ECC6B0093; Tue, 19 May 2026 10:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 016A76B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:28:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B47271C02E8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:28:18 +0000 (UTC)
X-FDA: 84784399476.01.192A911
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAE3240005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:28:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a+oJk/Xu";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779200896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yokC8193KWkpebMQ1az54G0zsxOhiLKOwHw4A+DZb6E=;
	b=pMmyZBP21YkWnrclTeybx6UrdyjCgZSCvOxRBdJ7fHxHbpW8xFmkWquSCk9il0iTTLGATF
	5+t4CYB/WqYPfiyU3PzPixwwxSr98nBxqS4KB4Qm9Oz5FNo5j7zHN6rfBaqtjOy1f8yqLp
	k2zp7bHsVHV61hm8gw4/Lk8AHay7odE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779200896; a=rsa-sha256;
	cv=none;
	b=R1yW8oidpEN4J+Y/m3wyumiUMtNXOFqxGihNUomynEZ+Ul4BWxs7vG+p9mFPMdY8cvHs9Q
	lvznVuCl71bH4I1+VgGPoJx8MPiYr8F/XGn1XPBquSURYLPC7fFBvrbmlX9CojTDICXlGx
	RFmswjb4fKUD7hNrsEBT/wLtI+GbRlw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a+oJk/Xu";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779200896; x=1810736896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gmoE1cqLQYiaRdtOUqn30NI9NnlES0TICUcupWfJ1t8=;
  b=a+oJk/Xu+KmpOZBu0PdF0OagJlMAS7b5prmp9Nog5YFPCnpi1MvdHsQE
   t8pfXTPWQc/U5Mr8pWyIO/aOkERahFZwGrgBMX64/4+c7w+eV0hPDVIe+
   JbjS52qyisyamX9YYB92BK4NKhnVEJrta47SSbydSzZNyupk2qx0FQJGF
   YmTj+kBTPq63rmuKOMVVf1RXYMj5OF92/fRA55MOhpAJS0hbdLeaDM0lo
   4s32YMpSXMBLx/9s6EjIqYZW04CZ7W6mVhegIs5doxiu8a2E9IVFYFjo3
   En1MuJCsGLDGqBooG/DTxdbEvrco2gVzSUoDdCcHRUSsOpIXQZlfywOJ5
   A==;
X-CSE-ConnectionGUID: t3Trj7o7RkqxEnA8lmGqFA==
X-CSE-MsgGUID: VFY8Ha6vQhSS2DxYTzebRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="91185030"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="91185030"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 07:28:14 -0700
X-CSE-ConnectionGUID: gkZiOq+oQT2xUPW5hfvguA==
X-CSE-MsgGUID: Pwhu5yPBQL2jL6Ks26xSxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="263293652"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.111]) ([10.125.109.111])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 07:28:14 -0700
Message-ID: <74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
Date: Tue, 19 May 2026 07:28:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 01/14] mm: Abstract printing of pxd_val()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-2-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260513044547.4128549-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAE3240005
X-Rspam-User: 
X-Stat-Signature: k7qwuf5unqo3mk68g97iukxaskiqg65i
X-HE-Tag: 1779200895-517329
X-HE-Meta: U2FsdGVkX18RgUoiix4DzRj5+dQ3c1ggYkwUTZLO/qAnclRdn2YKidyv+CTVKxSjyE6WY+89CSYkAMvPHGCVGoipuy3087z2oI++VZqWTonc8l9rnQWqkWy0o60AvIKJ7M3GuPK9WUsh4AYK6Ysu1clL4ms28HaqZerf96NjJRx2Gl5ISVADLd2ngbNr3u2a/Zvx5nC9ztcbZvDIR/1z1dr/BqOK69N61tsyyrisijdCkrbdJhSKn1QKDT9l75h5pJS4cwnHQwBCLDXQPfNarn6D/4FeMX/IgV8uUvBr4pjQI9Fa4M0iv1CdTvLqLibV9/nQEQejKYqVwFfbkcxe98ItrirhFkEv3DdQ26BKziBLEzp8ENJBhphO7o37dkskrqaXm+Zp762dLqJ52Lq2GZbhe7p3VcA/m/JXkjcDkzz4Nz+1JC6NUzdcM6+E8Am0HJbFNtaPk317Qi6fWggN3lbJjI3axA+dyPlEOPzwRFqw3vSxhVTeIubyqeoQ5iOb3sfHkKL+SGnDc8elOPgevXXvKzFQFmh7ocDHnn+01hGB48sr5Jdnjs24+lcMesReieToRoZiiFSiXg+R7xsyftF16hGuyDM47s30YVcoiwjdY7J/8QzD30X1XJ64+HKZgB7exzaLVlrkHTearaVYrbxB9usOUjjFyuXJOtSbj0mJAwLLdpWz5pRxbYBdlnqPZE6EO/xLz3CcUSlJM0tccN9aXjTRveZpkLM1BI+W+qaq1icLSCyF39YACX6z8NZBB4KplinRfqPfQXyBDMsq9sbQLt71z5tjT1bj3yeiiw3t9ikGWk9EKmjqLSQEUzaztDId36aYrw7AdwsNyU55hQ3WEEZajrUYNnGjk8A2IGgWXbUNp8D83AW4qDYM5WCzkmY4W68bNJKszjNHWPBcL+EOrydHucsaW7K/BpNTLVxymGh2ZJRnb5IjZDq2k7ukp6I5f5DLm+8H3dgrFFQ
 Ce7Y9bK+
 huaQkpgdXHHEAU5CDi/HX20gfIfSuxJb3zXDH0Ifo1NXwV2q0Oriy1/ut1OHUCnSiwzIRyc8+p5o5eRf69/wZSm388K7F7cArIE0zj0llQS6gteeZZCryUN/GJxMTyQn+itYtjpAkGipqKkOrWgX0DH5FEFAEiOqjT7FCvzw0FysgScS3bhT3DUD5cH2szx0Cfh12+hJFawWj3tD1AcF82eWiPupD2fXUGHeqCWD3yJLJbtVNA9WiWI6gcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 21:45, Anshuman Khandual wrote:
>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> +		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx "\n",
> +			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv));
>  		return;
>  	}

That's not the most readable result. Could a printk() format specifier
make this nicer? Maybe use "%pT"?

	pr_alert("pgd:%pT p4d:%pT\n", &pgd, &p4d);

I _think_ it could even get rid of the p??v variables.

