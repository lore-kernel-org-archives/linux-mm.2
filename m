Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80293EDF17D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DB26B0088; Fri, 13 Feb 2026 11:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB7D6B008A; Fri, 13 Feb 2026 11:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD506B008C; Fri, 13 Feb 2026 11:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACB4D6B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:47:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 524688BFA4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:47:00 +0000 (UTC)
X-FDA: 84440013000.02.28036B2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79CC51C000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:46:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XRjHyziF;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771001218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gK+IGPsKClSzMrR9bBTM29/mXlJAO442P4BAUhU/mcc=;
	b=ZOJM9arU+x923ni7ywBT3WumqlX6V0KE/l62vBWOhCK3ev4h78gn1cboC/YaaP0Zau/bzt
	gdni9Q4SH/BBqeycUzkNEwt5URh5pDO4rddlKIFLVGHJNB2x79sl3TYQm0Hc52LSEQz3x/
	XZeaw96ajLn0b77g+/LwIV5jKmleowo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XRjHyziF;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771001218; a=rsa-sha256;
	cv=none;
	b=1j/m8k+zWItcOrADoGzON0nr29mC2dClso59uBdL7FiJxV6NyUMktyJe87KdKGYAQnKtiJ
	rRSKrTFk4gC5/XQxIvy680aLrt7f/KCrZQzcZnlMGdKhuAA8kcc7ult5RAkV1oaQ/f+19+
	OCaFF+oJbSznAO+PlkyQz2POy/roACk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771001218; x=1802537218;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gK+IGPsKClSzMrR9bBTM29/mXlJAO442P4BAUhU/mcc=;
  b=XRjHyziFZsLke210QtLXsp+8PRhYhRGDeQ/jhvAmUIGQbUtp9c7j1oFs
   7juX2GKXQr12j2wHdHB6IOhmuxGrL/Ko/8jZJ8Rp7X5vSgmCCqxS8SbZ2
   BeUe1QjBiG90u/gD03G8LhI01rVE4S5FhimaDE3uykT3zdB5um3vHUvU3
   SN2CsanRn3MUssScxAgQBNiRPsHHOcqXzTmFNmt/LvCQjSgkREa5ql63v
   R5K9C4l/ZoYZoHgeOa3MXjjuNZ7eKY6XqSpG0hcsp+I2vKQk7rlV3UiaQ
   jg+behlBzxyrVuunXL8ZrPBvM8phlUhdqVfAoGqCJz0tzfOHuSUJ8Ox6x
   w==;
X-CSE-ConnectionGUID: ye+5W0S2Qwigoxh1DGGJeQ==
X-CSE-MsgGUID: RQHVkZViTdOuFWn856OMSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="72363688"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="72363688"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:46:57 -0800
X-CSE-ConnectionGUID: 1FgC5MfoRoCr1JF3/IGVDg==
X-CSE-MsgGUID: G5hjvY7rQH24nVpK+B85qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="213068569"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.109.3]) ([10.125.109.3])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:46:56 -0800
Message-ID: <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
Date: Fri, 13 Feb 2026 08:46:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Moritz Sanft <ms@edgeless.systems>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aY9Mf8oZODGiDoXp@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79CC51C000E
X-Stat-Signature: 3dhwqdpo43nd5unkkaeghyhpg338s6k6
X-Rspam-User: 
X-HE-Tag: 1771001217-532327
X-HE-Meta: U2FsdGVkX19MSLPqrWwzM9kx52hDB0+hgftfgzJo6zd2Vaz/+12xOClWNfxDU8yba7/NkJvhA1XstpULjOw4PpErs/cJ8vsf9s3HNgV/7h8V1pqn7hae6783RD5Za3ssjRr6qgRJprAsvJE8H4OwxHegEG9871/Lq8Lsxhr+ANNixqZ+PLEJp+GiaYxQi4OBdQzG9igmqU1g3Xm4JhiP8L5Hoh46pjRa7eilQAijgP10PI8JpFFLs97R1XfeoZdYgEh+PFCF37t5F0ejRPQADALzTD1uiNkjE4tjCHWhcAbTByiYH20fvAW4XyR8ssk0nECHzzeMfrR8WQfwxR5l+lt1RhSbjO3zNkUTjnd7EMiNP51D9XFTjl2ZW0bGiK673T7BmypLblPUTN/j93YSjBPFMOIpNgTneB2C7f0Fth8C08si/xdLSw+TpWMMzoiBZtX9KQQsIpM8knMyLPI/M30ONY4liNlD1gKjQK49XxtE7mcNNWawIxNn+2qqLhQWU/FnhzXH5WZPX6DNbzqNK/COlPbSp5Z3R2jmHGxm52rMBbRaUbXUDi0wJBTM1OZa1wGTqFp9ck0M+nUmiQT8NLaoiVYXkTFmX3V6OxaZNKDBqwnr6Cwbk3RoKpDWewdS/jcwJev/N77QIW5mxAKXc98Ze1CztUdmg3GNty8/RKqZMikkLEXuxwaSfJwwGQ+3vhYQP9wCunSRe0oue9L7gYTw2DYHon4FmilkfbauZdGDf9xqCi9M1hCouDqdshwWIe4RhAGqbZ/UfSji+N42pib07pnCHhvACKVSACoZSJcUnl7hSvMT8ON5bGPwoTMwfFKP8JVVQ0wb4ni/dV+7AgauPNlAr3sP44wMYUmvTNzYzoRV09xQQ+kHCCMLWwHIq+CwtySB12609SXHqtppkOJP09F/PCimxWNsmAiCTux+kkWS2hp7kjfZOCrIEy9QhBRRA8V0PYsptAU7J55
 KUirCnxa
 VevS6LsKAfqmloobipnpeQN5hpRR73cjrCW98Dpms5kfgdjfOEmGLFPX7OtebuKNH+rieYKHgUZt+2lAeuyeAhK3FeCssKfPR24eh6MrRhjSe2QmzhsQd2u94/RuA08GwFuZzkvLuw5Z/1S1BpQi44uTSmR2k9uAMq6eKwHhJGwRDfXiZt7QVlSYrDjl/7r1ZKorpYiNxJvtcW/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 08:14, Kiryl Shutsemau wrote:
>> The memblock code seems to be able to handle arbitrary alignment just fine.
> Memblock will track it, but, as the comment says, anything smaller than
> page size will not be mapped, but we need the table to be accessible by
> kernel.

That seems really, really fragile.

We should first make sure this is intentional memblock behavior and not
a bug before we go add more hacks on top of it.

Why would you even present a byte-level reservation interface if it is
free to just silently ignore some of the ranges by rounding them off later?

