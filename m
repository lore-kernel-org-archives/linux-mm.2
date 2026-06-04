Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E1CCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58C26B00A6; Thu,  4 Jun 2026 16:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A099F6B00A7; Thu,  4 Jun 2026 16:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F85F6B00A8; Thu,  4 Jun 2026 16:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 809F16B00A6
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:38:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27D761201E5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:38:52 +0000 (UTC)
X-FDA: 84843394104.02.62BDBCC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0918F40006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:38:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X8VIU0am;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780605530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk9oGJDA0EQYu4fCSnjCmC9aao7J7f5eU8cgGN0cNm0=;
	b=7WMwZudkO/rfA34DQIqZoS4FPrFHp/2/d2RW4frwk3bQWLtmfvT5/aBUomZlQNkTm3Iyhs
	owtgCAt2Y4lVmF4YRqjcNMDUZvjJM8iGfsTcgEVQZEP3v6Er97WsU2RepLhrtMTUZPqRBA
	GcbKajdic2+/upNJiwOxMaszbtNyqUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780605530;
	b=A2Stk+0pyBFhd2GTw1MA+yaVI6TX/R8eXJE0/YlTehw3LjUElbRPcezeiqH+XEkJZSWlZL
	eFrF7pHPKp/K6qtJPMg7daRad6Y0RWS4+ffIwdWdcX99i4KwL2QCk7qoolgEPCx0Ltl4oJ
	s8IDFJF/ihUzTjXywIZCnTfIu6LU8Os=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X8VIU0am;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780605529; x=1812141529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lDpJv4n65K4Es/uES+BPuZ1DzxHogGjpuTXWYjQ7ksE=;
  b=X8VIU0amUKeCxhuA6JXOwOc2Wo5yFxjJ88o9MC/nzao0rxFP6g5oAqTZ
   7AUjdJAF6lX1oO47tNat9M/t1QscHZz2Gfdd5F+TN08ZGsu+jGWHGJq+p
   LL4ERwIJIDegu1YfokNWvFUxZ+d7/U5QtFxEo/zJ0FWoUJJVR59XWOW3I
   aYZbpxVjqSRg6WLfxPpyLDw1ldWqrQVPsnMon/iQNW6ZVQEDKNKT6Trnf
   3dniG3AC4fNkcMN3xjZxKbktZ3Um+YfRYO/retDeGJ26RIRWyrq0NYpZi
   XV/M/IhwVufZcJzmesk+ZPtNKlFZiudK1tYWaAOa57wdH5iefLfML+GAJ
   Q==;
X-CSE-ConnectionGUID: jub5WJluRn230J0sx/oqYQ==
X-CSE-MsgGUID: duDFH8+lSGKm5i/BvMIr4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81624975"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="81624975"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 13:38:48 -0700
X-CSE-ConnectionGUID: x5o45sZxRwS2L9plWh9vHw==
X-CSE-MsgGUID: GC/kVGZjRQSH7+XuwDMGsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="249748999"
Received: from unknown (HELO [10.24.81.183]) ([10.24.81.183])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 13:38:47 -0700
Message-ID: <bae37c0c-f9e8-486b-a1a8-53c9dc0af8e0@intel.com>
Date: Thu, 4 Jun 2026 13:38:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
 Karsten Desler <kdesler@soohrt.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260601125015.216110-1-osalvador@suse.de>
 <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
 <aiGRCdKXdusBu2tU@localhost.localdomain>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aiGRCdKXdusBu2tU@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0918F40006
X-Rspam-User: 
X-Stat-Signature: iayiurtahshxrrsswk7wei1ms17faptm
X-Rspamd-Server: rspam08
X-HE-Tag: 1780605528-132257
X-HE-Meta: U2FsdGVkX1/cSfhzIS1eucj7ldP+HtkR4Tb2vY6xm5mo/cV0STVIsP8Rfvjmbd+LdZSmBMM/X/K17jLwDstkVUOrXLUC+YcYLe4q6uFcr803i3eBz1d0e/xUD28v7qfAMQUv3520QVhv1Ft4Jr+E+A44KmqU6Es9F/gsKTVQNULdMg+C2Q1zxzMQtCnM9tG07yAm2UylDJnEvBveJ5bi541wvkASL06U1OjANk/RGFIpJe/o5nCRCPwg64R0ULRWLVAD5CWXUcbGwyBP1HOyCJVZI8i9OXu/re3vGxEdV+hBGc9k3/ZOcLCDTG8drsWNckrk1nwXIAZM+VngZ4XyJY08/9+93p5XJCngesvqRHeNQhteyiOLLcKvpwnA4Blr84cHHTQStFU4WYoONAhS+ugPGrP+9kdGlaZBg1wT4SmjstEnCFl1u5n/udiZy81DlDfbbmvbu98Yw171wBPFWxXsBBCyj4/HBtfDwxJcA17qo88E75ANpArZf841RZN1i9VD4Q+fmnxSa5ek799aWyqFTnI7XIGK+d9g1he5i0IFQszcJTUoG1E4MLh5YGsv6ZxOw/2ZRC8QKLzKtqGxMtZYbzDcGaKwtdgvKHELiPq9AME4ZSzw1H4XV1tRdmd4xQCZB4tDjZc5o4tyG7U9hZXsfy0zXNNSQlY8o6IS9qiP++CLAGio15kTK+qHGI5LAXY9iQM2Uotynmye0VDvrTDFlwXSsxp4UZ15zb3SDmNjC/hbDZwGdIoxql3c+wKsGaubHM5pVOHQ16AZG0F16S2ne5HHHGRzQbUlew9VP5rpLlNrS/TV1OpujDsiNIzY9Gzz2V/x8ZjXBXcFQPuDOTZ+/mIJVNahM7MBUripg6CWLi3w8eTPO5+XIK6O53yc5iU122UMO76Q/X+CSebdAy26WobM4EMKC9ZBxzVU04df1Vpg+FcRA3UcjQnfVJ8XrTJ0NQU6+OTu+OuHrH9
 ym1lP6qw
 b+ss2Fys8RoHm2vcRjTyAuX+NwHt8R6qKGyFM1yv3eXE4gTsYewYQiWOVTV9Pr/94LRbbeub59Z3gf8AkUpzQir140YZdSqa75LdYHs8mfC9iiQ67Q0YaZPPkbk7p9vMQRLj7Uq6T14Hn867D83pmZQstDNYsTkz+EUeUHTQDZHKhGvwiptw5nOe/awVhbzZR3X5ELfe3hzFHJivkrvRMdaEZZ3m5Ws68FOvIovTPM/ycZU7o5LSlMjfdUv7DMDz7FIqTJDJ9q5axlvUr59ojL5sXnTNW580x/cdkrQJtQwOMThu2lljNenbCIPqctajxO9R2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 07:51, Oscar Salvador (SUSE) wrote:
> On Mon, Jun 01, 2026 at 01:25:12PM -0700, Dave Hansen wrote:
>> Oscar, even if the real fix involves a couple of patches, can we please
>> see that, first? Then, we can go back and make an informed decision
>> about hacks versus proper fixes.
> Fix sits here [1].
> It is quite straightforward, is arch-agnostic and I can confirm it fixes
> the AMD regression.
> It is part of a 8-patch series [2] (#1 is the fix and follow up are
> cleanups).

So it does appear that the x86 workaround wasn't the best direction.

That patch looks fine. I find it a bit hard to parse. I'd probably say
something more along the lines of:

	/*
	 * hugetlb mappings need to be huge page aligned.
	 * mm_get_unmapped_area_vmflags() only gives back PAGE_SIZE
	 * aligned areas.
	 *
	 * Extend the requested unmapped area for the worse case
	 * scenario: the address comes back and needs to be aligned
	 * up by one small page short of a large page.
	 */
	len += huge_page_size(h) - PAGE_SIZE;

Also, wouldn't it be more clear to just talk about the length in terms
of page sizes, not masks?

Also, do you even need this if()?

	if (addr0 & ~huge_page_mask(h))

So the code looks like this:
	
	pgoff = 0;
	addr0 = mm_get_unmapped_area_vmflags(file, addr0,...
	/* Align the address to the next huge_page_size boundary */
	addr0 = ALIGN(addr0, huge_page_size(h));

If it's aligned, it won't do anything.

But I'm 100% ok with the approach. I *believe* the code you have is OK,
although I'm not feeling super confident that I've read the mask
calculations correctly.

So while I'd like some improvements, I'm OK with this:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

