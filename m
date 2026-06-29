Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338A2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96E76B00BC; Mon, 29 Jun 2026 19:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FA26B00BD; Mon, 29 Jun 2026 19:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DC36B00BF; Mon, 29 Jun 2026 19:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 897826B00BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:37:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B39D31202D7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:37:41 +0000 (UTC)
X-FDA: 84934564722.10.EE529E3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9EC5320005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:37:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a2R/qEvC";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782776259;
	b=Emdty6x2mzt3ryv4PTOFAQZ2WbVlBK1vscea5vE6IuPhhSHXAl1/Aa+AyQMzrAvbdVkhLx
	FrNTcmxS238QZ52KFPVognixuyKsfr307XytLWEtCV37XAMmUJ07zbr+VR79gIzeZAqnqA
	jLKHY0xdzcJNV5W1/gP8CM2KsZpcTH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782776259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCKiPiGUjLmcSZK2aV7ZaEE7EwPMTrTvC+TkPBa45zo=;
	b=CwB73KOsyh+5CF9GNXs2UtkqS7XAcBn8VsVYZqP+705EqknNtTzlcFWhGTYQCYE0iu6HVL
	PLhINqMNT8pSKUWi2rgr4NuhsFxqsviXVBjfh7rj8rm+tl5eESDDaVeoACbU6mjSzksbHt
	isNIkdsLu98/753zpw+wndJpXsM+WTs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a2R/qEvC";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782776259; x=1814312259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XCKiPiGUjLmcSZK2aV7ZaEE7EwPMTrTvC+TkPBa45zo=;
  b=a2R/qEvCF9B9PFEy5q9go+EDI7OVFVB2vG5mRL4OM3Pl2oH7m//DLZmn
   KnU91yVZJiJqVpTTEB4W5ia2dU1T6GBRhsIWW+k034gPYszF5FvGa3O+Q
   DL0oDxvtHhDygPNfuE6TY/kyOXNvoGlXLGhIEBdloiRIQdUUAA3cdlZDy
   brQkw8tRIFYoURj5HmpftrQaZWkPllGxJguRrQ5Z3JRd26sEO/VuAgNpg
   OXyX+z9T7HtfkoAcsUHzyccldvOGsI0gFM3QirII1c2Qh+S9iuVWtKnpj
   mPgsTZ5DFlmdkUIdhTGoFXht4vcRxW3CdSGkKdzqmsUxOR70JhX6drPT9
   g==;
X-CSE-ConnectionGUID: fO+ttXCUQbGZW5+Y5w+MEA==
X-CSE-MsgGUID: EWyVKJuyT4SysEEBj2x4Pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="83619273"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="83619273"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 16:37:37 -0700
X-CSE-ConnectionGUID: 1/nr50kQSm+JClKUdLMWRA==
X-CSE-MsgGUID: TJzMXWYBTUag71+NpzLDcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="247643176"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 16:37:36 -0700
Message-ID: <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
Date: Mon, 29 Jun 2026 16:37:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, linux-hardening@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
 Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
 Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
 Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9EC5320005
X-Rspam-User: 
X-Stat-Signature: shfb5qauura8mwmgj38xyadsjiu6btws
X-HE-Tag: 1782776258-577169
X-HE-Meta: U2FsdGVkX18RQ1fOMZhykt1ylXW0vn3/mtSPK8cDql5F51GNlVJNtYMtn0brXq3Vwd02ZyFceRuCKoNgdYE61IaaI9b+3j04AUMdbOVQ5eQo1WMJsqhvhvbq9BeGaL5IOC9Q6j23bPF2TslToj3f8yCWVGu3mvzhUBt8o6fiB1XjgRgrA01It4f8aH3e823riV12Rxn+BxomsWQDUOgOH/NTp1h2lKyPTSPX4abEoFoO3I7nsiKaUxtpdyHKuAfFFR6lM8UHGctS9tJX8HVoys34e9Z75vRCdyLWSfpHv5mu/HVeignalmoKj2v4FnIc3ntGX1vzmZxb4bxNlWEb4TPR2SNnwVdwCo4ckXcXKv8LtFLTnBSTU9DKWRbchLV4IzBvmnnj+FCER3/62IdqDSXdSIoDTyy3GXjSlnWMBfQSzzEFqIXGzPiacyehrUHVa3KYPmt6AS2vZguiyprNDH0adT9Xki75TCWDWWQaBdWEsjVlpfwgUGw8W6f5MwWwLZOL3WeSxDXk5NLiB8Sz3/GjMNmfCI2dw53hpqlDvYfNJfKPlR4RFlLZdbopeHHhVmjvIlAnsKdgY7HNDbObp0Ds3rxeYHhMs1Xcrlsj4e4RQ7uWCQYCHFnWCcNMNkkbbljZUzxylxDkjfyJ4kumIR6EJiWv+8DJhUtP8/7+/gt5iEP03pUZ/4eQT2R/O4cseaUjY1k57IfT7UFTjBdZRmo/bqLuauJ0KUmnca3GC1AqURkqfUBN270EZ+sBWrO7zAPgoRDVpwmttAOrfF35w26BRStfVTRJbHv6hTR2YVDIMN4TyQwqOu9iZ0/CY/xXOkv9sabJ8nNeKF5avTO09GUJBH06Lx+B+ebri5xQtWaSeU2T3fUVMjBDnmOl5+aBcL409wxovrsCG5a0kdc23kYhKJIeLe6BI7YJNa/rejEX9mecWPCOzGSBo6XYBv+pFZGuJYchdI6YihUUY5g
 aGQfkdkl
 jBcOCY8JrtZcUFForeeoiV9ZRpqV9VL94FQvDuxBeIpbiW1FyTGTWMc+B14akRbUOe8c6PPOojLqweJ+Es8nC3gznvT2foWh20p0zOlI6yD58C/lYqQeFXJ9zxh8YPeTwOgGZfZ9PHSjTQ2aukjWhwSvCQxGzl57maOudcv9gejFwy+0OVJgy2LtayWvTr6+PEURoYrb9SYXH1bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 16:28, Xiang Mei wrote:
>>> That is more than enough to step off the current stack, across the
>>> one-page guard, and into the adjacent sprayed pages. When those pages
>>> contain a return sled feeding a ROP chain, reaching any ENTER gadget
>>> (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
>>> control-flow hijack into full ROP execution without any register control
>>> at the hijack site, making it a one-gadget-style primitive that
>>> significantly eases exploitation. The pivot happens after the control
>>> transfer, so it is not constrained by CFI (kCFI/FineIBT).
>> This all sounds super theoretical.
>>
>> I don't think we should mess with any of this without there being some
>> sign that this is an actual, practical juicy exploit target.
>>
> Yes, I am sorry to reuse some incorrect comments I copied from v1.
> I'll remove the CFI-related content since we assume we already have
> control flow hijacking.

I think you missed the main point: this all sounds *SUPER* theoretical.
In other words, no real attacker would ever need to use ENTER like. Only
make-believe attackers in imaginary academic papers. Those imagined
attackers' only goal is to help mint PhD's.

Upstream, we're concerned with practical attacks, not theoretical ones.

You've done virtually nothing here to show that this is a practical
attack that someone might use in the real world, outside of the
PhD-minting industry.

Please don't even try to send a v3 without addressing this.

