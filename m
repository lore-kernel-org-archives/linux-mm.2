Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417CAE81BD9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7848F6B0093; Mon,  9 Feb 2026 10:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7324B6B0096; Mon,  9 Feb 2026 10:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9D06B0099; Mon,  9 Feb 2026 10:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8E86B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:20:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42694C092A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:20:23 +0000 (UTC)
X-FDA: 84425279526.05.C7D3727
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00E984000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:20:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O93hsMQz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770650421; a=rsa-sha256;
	cv=none;
	b=slgHaLknEyITofBgKrziF+GWpMtSexzID744b1/3GMvNafMn6LAPndCfh00hMAPEqAK3fR
	IU1vpHw3l8dw6Um/2OuOcw3d89i1X+aN72OtfECWDwanGz4IZjpYwUEgDt5tZLcRBuCxBS
	YefNmOL+mwjl7AChKjctqw7vQXRvoxU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O93hsMQz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770650421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfWUO9yG8BlHLu68q98grtGVw1mlSq+oAV/ahBZOjng=;
	b=WxOZdFZ+F5oZg0tgsM0wD8sOTaPVz8nz+yd2TqcKiHojjHIW/Quq6tW9kGBv+puEbIg9uu
	/Q0DnrVCCw+OeMt0k/Z6lYiIcSiawbDSmWz2sRjrbq1bIF1ufb8/J552lMPvIOqdd54VuL
	XmKB5e0Gj4mJ0UOKirjaW09eK5WWETs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770650420; x=1802186420;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nmXJ+jWEo/z81w9oyX9ApAZJkh48iDrBFf9GYDPqlyQ=;
  b=O93hsMQz1VaFcEUVSnwKQQCuByirORcpGahKIwk6WVHCdCcegGAX9fQ5
   g/HRycb63pWoKPJjOg+oM9XVxoW827f754zRtU5irDCzlvm8HKLxge8SX
   /5eRUv65aBnldxWdn3JlkWawBiy7Zyfnh/xmHe+u/AlKRjfEkkAUHpUJB
   fMzfMW0AcqLv1EqRyO/N/P361fB4MKDhj/fTTlwbph/2RQjnOLrp9SIe8
   ocsUP04sGQkNQOhu8KhAxdPMpn43TpRhJMckLI7p+P3g6B4HFcTb1HacZ
   SnQUHLsca1MICK0QlVPtzU1w1/bDGBm1lha6VFwlWuS2uWugFIPgp1Q4Q
   g==;
X-CSE-ConnectionGUID: ufBCyubAR8OV7LSrfW+GJA==
X-CSE-MsgGUID: yjGTN942TT+IAuY5V7LiDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="70778606"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="70778606"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 07:20:11 -0800
X-CSE-ConnectionGUID: 582YU2ENSaqF3h08Xvh3Lw==
X-CSE-MsgGUID: 4CBRhAj3Qym7tVxCsKPGyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="216136252"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.111.231]) ([10.125.111.231])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 07:20:10 -0800
Message-ID: <8224204a-42f5-4b83-b4c2-ee976f711d18@intel.com>
Date: Mon, 9 Feb 2026 07:20:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-4-rppt@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260209144058.2092871-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00E984000B
X-Stat-Signature: pihyo1m7exa9due5o5mdnpcugwbjwgq8
X-HE-Tag: 1770650419-69391
X-HE-Meta: U2FsdGVkX19H+rnQYVjcKVhrZV3OoWLPepLfT52ZBQDxjUi7xiLwCQpeSOybl73Ncul2nlPPAY1w5Uuj+TGL94VHT9ml5wJIrz8p8fa5hKZgpKySh6S8E27ZmBX50o6Ra6+fHoQKYiQl7k3IFrQOJPAQcBEyORWXz7ipIz7FD85lB+JoCv0kCUzxPtUXB7wBo7hsocgMiRaQwrriSDuQB5wRz6pnOAgiFamfZViAXjp4dPOusAlg2ie/6TYGeidWmlMc+hX43cEdBpdFzc4FTz2H+SMF4M7KErwkXBa/8TbO5Jxbu42EbuXea8WqSt3BzCXScQO9TYBZmCXKJ4ZNGwT7kX7o85Z5krnwUs5KJI/UR5Lx9V21Diols8N7f5QnzdtNWwA1XusXQSkT0dsrWZPuK9i2pCAiMg63EQ0gNRib5MpdNrN7ttp5f+Y9sTSV9Wteor2CaU0GAbVOIQLgl333+SCDI4jz3RE3oYehRxHtENB1e8+iI3Z4KHHXh8jtVBMaf7aaT3wCliQUl1AjYJZeAH1JUi99a7uJgyAP64puOo2Te8fdss8ZEX4mZoygruDncoHuXQSHWjEATdQnCET6iPZku5BhBHMzQrVEwUZ/mUUxJDAilak7V6uqU5AC4JDembBpTdJs6Qd/8I9W4zKpxvOYMgXQKk1Kvf1XrgO3LYswPLl0dEObi4IWekYwZC8vueez2Lfekwo9e6eYL6noZHgkA9kAVwNnTg7WOR1H2uvpDdcV586Nci0cspgrUDjgbbgV/twRNrwMJNwlmqIap3uuabLYtqS9VKTW2Zz1N80Klx3J1e3Gctmt6xM71XE2kbPslWsPjv+sUbLV8wOPT7a9lZb7AGJ8uYiSRXZX7FUZth941cT4xM+PfN7g7KyhPj2G9DwM3/sj66cOnq9JrgkdAxyoAJ64cLoMmUzpJe0UFy4RWjip8x5e4Hqk/enRpO5n0pU9qUe9l27
 9SSa2eRy
 ZXgYzgAK3BEKdne1WWVjENUbDLvQsIEk6GrWHIYdhFtxBWoDunzoX3kWy2lIfyZV4VXi8x+LnrshRo2iF7YLrZk4pfi2gZgY3r+chv1pmMAvvZ78y/SRIRBiXL2uwW/kdZA9Wo9i0pcf9qU3tydKQRTYlYhwwU4FMT6Kf+ZQCBqtPAYT0Qq+dS+efrMuuKRfAgfENSOWKV4AN+BxDs6mNu+tqaPtw6cEO4UQKtWFjwtqVQiZXAb6fqWDwNdS8yigu2gYReTDmEQ/+xjT3eVU/C8+jDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 06:40, Mike Rapoport wrote:
>  arch/x86/include/asm/pgtable.h            |  8 --------
>  arch/x86/kernel/head_32.S                 |  4 ----
>  arch/x86/kernel/head_64.S                 |  7 -------

Thanks for doing this, Mike. This is definitely one of those cross-arch
warts that's been there forever. It's great to see it cleaned up.

For the x86 bits:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

