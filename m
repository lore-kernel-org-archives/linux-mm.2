Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C3CCD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D5A6B04C1; Mon,  1 Jun 2026 16:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349DF6B04C3; Mon,  1 Jun 2026 16:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A306B04C4; Mon,  1 Jun 2026 16:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17C946B04C1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF47A1C0D0F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:25:20 +0000 (UTC)
X-FDA: 84832473600.10.5B22C78
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 44C3A4000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:25:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jHA8eCOc;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780345518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gaJx6/Kjwz/xj8GFMUKhScvJlSSTXn1h6XS/yJcB9o=;
	b=aA7dvomoyK7cIycaDTpUfI9D8IJY7ubuIIPLZd+hZ2ngHZIcCK7mFtZSXzjgEOtZcp1DQW
	vCyKGHFcSQuJUND/Xdg+kPzUbBNzFkmKRqmPZKxQ+pvR9moZ3ZzPeAgVHgdLcyrBEkjj7C
	jgjka54Egai+a82WrPaw07Tu2j/a640=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jHA8eCOc;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780345518;
	b=rPubn1NYHGzRcZAcF3nYNZfJDUeatJqIGCa7jn4MtPUgHbmA5djPqKJyc1LcQHWhpvbfBS
	D8IwSvYCwggRjbipuoNpY5Co0owAbGcuiThatth6bVnEpLrDOFUv6Gt0cfnmu6kDb1Ed43
	AqvosZ6orIkGpelKxE4Ulf/bc2p+jas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780345517; x=1811881517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1gaJx6/Kjwz/xj8GFMUKhScvJlSSTXn1h6XS/yJcB9o=;
  b=jHA8eCOcrcMRdjjvHrTv9fbxYDAeB/PhQBtYzTaaiUXSjthR2tnhL7HD
   tVcEvwbZiS6s3ep8EtbXsMzc60o1ui+OE7LUeN9CsFoUY3d0G0LCn5JzI
   KxyI9tbZmx9BQ1XTTTLlaPcQuEdIKi9fvzinIuobrYQZ9QS6BqQhGt6Hr
   xCMVD0MXICCAzYRaqkdNDuDeh40VgJ04mQOOyDULte2e+lNizvO8Y+3n3
   TfgLBj1mQtrBaxf+z8YOv5uyJtjR6XlseF/hScMNFQ2j60VSFGHHqZv7M
   HdVf8WPNKsiOHewDUATFGD/pc5Lai+qgfd/aDx3PvsvEsi/ETeneZKarG
   w==;
X-CSE-ConnectionGUID: 3npbsiA7Q26ye0a0xSwUgg==
X-CSE-MsgGUID: jKiOAtTKRdCdTQjhWBPnig==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="85002828"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="85002828"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 13:25:15 -0700
X-CSE-ConnectionGUID: hQ2f19pNTPm8IvPDw4EXnQ==
X-CSE-MsgGUID: ma2HkNjqSdCRWye5Mr8ahQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="243519500"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.108.20]) ([10.125.108.20])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 13:25:14 -0700
Message-ID: <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
Date: Mon, 1 Jun 2026 13:25:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
To: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov
 <bp@alien8.de>, Karsten Desler <kdesler@soohrt.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260601125015.216110-1-osalvador@suse.de>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260601125015.216110-1-osalvador@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44C3A4000D
X-Stat-Signature: wqsqen38w3nboi81fg97xrhktztnowwr
X-Rspam-User: 
X-HE-Tag: 1780345516-934797
X-HE-Meta: U2FsdGVkX19EcLapPsyNclu3BuNbqP5QOF1fAtssyOrgUTXFAGQ/4FUDsWL8sR0JpFTr4cO0Jh3R9RMxcKyqobGnBoOiG1VSy5My2qiw+sFJe6QKC8iJhhhk4XEPWR7yatyX7aGQpkQarUf15IJBQfklLeeChJlc5Xp4gifu+MUnVG/wHpZRhQ+L6m05yVw3+0ri2qS/aFMidEfNjphHjjpU7TjJFEXLAgNbmVY9U4t4zRobitge/4p43F8RrQrYekT/VcCx0OJS/6WoG3doh0dwmQ4Y6sq0lC/96X5OA8Af8kgMw949X1dSUEgF1/XnjtWrsmh20A4433054brlSkgqhBX50Mho4aimHjBZsXDdKof86Py16j5NDhJMlnriDJeElkYR254ujgiwLTgJ6cAOx5WKnfyLjVaxqWCFgzG5BUo+LVU77elOwVeYhiWYaNMQF1A6oY7smuiu83RHIpkbjD2EYhXRaUJ+e9navk7Tnyeuh7GsNEhaakR3+MUd+Pt9es8mQMudHyyNr3lPVDw1wls+QQouRYLbfjsk/QhZjoE3hkRSU5DUGmkGjKluqfyJmS4C95n4fT2iOTc7E1heHawLay8ctb1k4PaqRVYZq4H+lXMXWw52MoUGYVENfP53OKmOK0sPiEbWXhONFaai/TqrSUHc74sY3bPQsxSVCBqMMKmZcVeip80XGBwy5vLkYHLFDJ1OtYFic0Wi7rTHERFTKn95rxP3vzXxk/u1efFhNDDouGADUZFjfEvkf85jJpmP+KKzF3PuZY07EP438VLvYNjnTJX0mF/AIcxmJ4Tb9n5UOgFECN7BE/a/Eg43jK84ybCeYunhesbE0lYfvwrhkpTsbT8lFlXp0BzpbsF1aLWaJXtRzQDBJ4R/PdJJbo9Zb4WxBd59IvRlRbluHFVJTyMOgSTWsdLylU3XwILFnmGWgSRGqhHejsWDmrnDRYqQ/K7pJBxvrev
 PtAs1Q+H
 dTnjMV6+bHlRZMen/r3sFHmLISEnLI9kklTpgX7n0q0fQBO2vttPowSr7isEHG9qx5NQzP8BNx5sv3vtpLKLnE/mh10KO6Q90RQ1XN9GPIjzU8hR1R2C4qsYncS9xqn1I+GZq+pumeoPHXzc6gxVAgVt5ANa0aOGvc1Sb6+oG1sgkGoh010iflRO67SXiEdR9kYSAh02KL4Jrz+GQVAT4GZn7MjogUHDACTO7f8JrbvhZclOGaIb3OkfBeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 05:50, Oscar Salvador wrote:
> On x86, arch_get_unmapped_area{_topdown} set align_offset in order to avoid
> cache aliasing on I$ on AMD family 15h when 'align_va_addr' is enabled.

I'm sorry, but this is a big NAK from the x86 side, without at _least_ a
substantially improved changelog and evidence that x86 is both the only
place to reasonably fix this _and_ evidence that no other arch is affected.

Why?

x86 is not the only architecture that uses .align_offset.

The bug was introduced in a generic, non-x86 commit (7bd3f1e1a9ae)

The real fix is almost surely in arch-generic code.

So my fear is that we'll apply the x86 thing. Four other architectures
will come along and have to add their own fixes. Then (if we're lucky)
someone will stick around and fix it properly, than all the
architectures will have to remove their hacks.

Worst-case, we end up with a latent bug, just without any testing
coverage because x86 testing is the most broad.

Oscar, even if the real fix involves a couple of patches, can we please
see that, first? Then, we can go back and make an informed decision
about hacks versus proper fixes.

Second, if there's a hack to be had, it should probably be to back out
the AMD optimization. That's absolutely an x86-only thing.

Third, I have zero issues with distros adding and carrying the x86
align_offset hack. That's what kernel distros are *for*.

