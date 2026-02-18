Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48381E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 20:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33476B0088; Wed, 18 Feb 2026 15:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0EF6B0089; Wed, 18 Feb 2026 15:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898386B008A; Wed, 18 Feb 2026 15:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 759046B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:27:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2956A8961D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:27:26 +0000 (UTC)
X-FDA: 84458712492.22.D4446BA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5824B140004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:27:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bm5FXaWK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771446444; a=rsa-sha256;
	cv=none;
	b=PBEHudQkVNhikrN/dixvjckkpvV4wEEHNON+F63EWwd7+pah4IxUIbgQSmOZiLnyTRbddN
	ibZFCLBZgo6EmapU+6OYq1lzr2bFHsr3D9hUabx6n10BADeliayASjq8C90tyGbqOziFAF
	/Wx9w2hi0Iuzda4GYsusl7RR8lUrh38=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bm5FXaWK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771446444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8t8EFwMcSBatIwtdwaGv2rN+7NEg2khPD06o4Nx8v8=;
	b=FuB/79JS+UCUaS+4+Dz6gZFQVAf6GrUH1RtM/6WhrmM2oVYo2q44Lv9L0rePFvCcs6Q67Z
	iIYKGGnIp0WvyowmskYxiefi/F/rMCKqAKVRR7aA+VPw6/G/7+Gf+byQI7ELh3Bv1yn3xh
	FxSJzuZvVxWUccCTKRltXvPrLhQdlZk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771446443; x=1802982443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J8t8EFwMcSBatIwtdwaGv2rN+7NEg2khPD06o4Nx8v8=;
  b=bm5FXaWKWmTiEbPuj92XMMfLK4KxETaqzgV65a2YmLA3Qt/rnALUDkUL
   wCpe3UGMicx8HOrMH+GuxfdiEOX4fvUzqFN/b/sBWmEZTpAWq2UOCADBE
   x+1ibkvQD8ufc2fEQ1UYkb73AZzaRkOWLPiA/OoFdE/JzoGDngnwn5aKo
   /o4BftB7ihadNogHRlrw2UcrVnjAitXYMlOFn42ybsEh+W3dFqYpthdvZ
   PhYFWihY1fLfpSD1uIwpAil+AE+sZRPChkUBvOxMjQgpoGMJehjl3dIHA
   DBrvKbH8Q1FMrK2aanRw/OXj1fjtcbBzeimR9wa5wXtR27gUbb+MjtDTZ
   g==;
X-CSE-ConnectionGUID: EuSb4741ROys5iaM5mZF6Q==
X-CSE-MsgGUID: RtCal2n9TaOuJ6jMMQdi8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="83635875"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="83635875"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 12:27:22 -0800
X-CSE-ConnectionGUID: XJ4K+n6mQ9ue8UmLA1LtdQ==
X-CSE-MsgGUID: n4NWEXAPQheED0pv8NXOCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="213045018"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.224]) ([10.125.109.224])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 12:27:21 -0800
Message-ID: <57f9c648-19a7-40c5-a611-fb94efeb7ac3@intel.com>
Date: Wed, 18 Feb 2026 12:27:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, akpm@linux-foundation.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
 <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com> <aY0ALB5yKXLY-M-X@fedora>
 <aY0Z2qA1xiabEafk@fedora>
 <aZYfusoUR69JO1_X@syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aZYfusoUR69JO1_X@syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5824B140004
X-Stat-Signature: r81wqjz6r93d494bfhpjgsxgyedt6guf
X-HE-Tag: 1771446443-188794
X-HE-Meta: U2FsdGVkX1/4vw6XzuXP8xRIamtIWu5OmVNcawQfXggw7f6smVcnVSDNLasMfOkDcQZUvZaIsT2nD+DmvoIyAyKrTk3nLeXwctYxfsU5aNvPXbabJJQeKePVVaEEcpNmgC3yCgyCSveXdSbyqDBqH5dYvyU/Fu22yhhFq+4KORiDSWC2sSL6eHQdqCX74C6Bs/MiytaWcpccHpbPngjBdduWB8u+DB5GbNAgv6NZFfIQUcrewHxXeff3A+ZtCPTJLGNANftyxKBIUdKc1EyFmt2tNNLj5bdKNQQOgEw0O54RsSpJYet0ZZz0hpvtKjY7iJBnCWBxhftVcQ6JzTLhHNe16NB6ltFkXDoaKdzhN2Rt+R/q3XPhYSuaiKxw1bE0UoXu5kcjovuuhCYK4dpl8gLT0jZTE3EwNRllodJ53KbXWi1ALuSrLelleaKwWkWGnQvAxJZqIRUlpssGFLFZwb8jrrpXDbijX4YCFG/Rei+fQl8Q/MJ+MvzPXtJu/onOrUqyu5i92gufEDWGzwWhl4yVe0mI4CwkYglYmUOzFXBupHxyT3HbiLhA89akC2LT23zpes8PQ8sXncuamEvLTbzsZhEq6g9LR3m8dmN8iJS2XS1Zshm8Xi/h/UgxjkYkmlFbyV5CJrSj8+HuyZ0aTheBtzgF88P4gsgjgCqmjRN0X+Zad1HpzdgTvKhLq6M9LeOLWwDX22U/KZTAhQUWwEIT4d1pYamsTAGwh7t7MmFDbpJEcq+nXjMabHEtzgO++IrLnDyN4ZL86Z5ahdrmf+/2bQxCDxuPXMbv0icOnU4zcIcQpzuHNt5zaa63hS/xjhAxtS4JjmBRjfYaXQX2MdOUkn3oAg1FSaZcH2Kao1MqlNzO9y6Nus8MUqll+BjnAO8TfLyZtGrMygzr/Mq5fT6dHwZ4QZvxeowbOHV78Ed9CzMRGOdGUHmBomDCLuyURfUC5BbunSL06psTK1G
 mH15vAOI
 EIwcWnUO2DyWjCNAEkQ7pyUaWskPS+wsEKWRNUtmiPPOCxbfuBaz4v3QiRgYmKMNGO/4GNszZPupCFWBl/gSfPndeKvfExmntASfykQBL+A64RUW6VgBVR6MCpgQsUjh3IDOtWc0N/RlnWAYADyxokgSvcQIXJiKyHLnD0oLws5oEMOaB7rKgZzCUcQBfw9t/j1rj+pdDKQIAJICfAh3lLU0EhXKNMgCPtT1rqksiNO96t3CVkmkNn8yA16EEvMz95YJVWRGG7qb1+OXEPbItaAVzws9fbUEQ6pzf84YneTyORuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 12:23, Vishal Moola (Oracle) wrote:
>> What do you think is a reasonable name for freeing?
>>
>> pgtable_free() is defined for sparc and powerpc. I could rename them
>> prefixed with "__" to get the name since they only have 1-2 internal
>> callers.
> Matthew brought another question to my attention in this particular
> scenario. Should pat/set_memory's alloc_*_page() use pte_alloc_one()
> instead of get_zeroed_page()? Is there any reason not to?

They're not special in any way I can think of. There's no reason I know
of to keep them special and avoid converting them.

