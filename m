Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E615DECD6E8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 20:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3E66B0005; Wed, 11 Feb 2026 15:13:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2846F6B0088; Wed, 11 Feb 2026 15:13:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187986B0089; Wed, 11 Feb 2026 15:13:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5BF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:13:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C10038BFB4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:13:14 +0000 (UTC)
X-FDA: 84433275108.12.62C6702
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4099210000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:13:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ErZ1zPfi;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770840792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHbeHaJkawriZPhofQU6ad/c+sJK4oUU/4eorLzhbks=;
	b=EWuvCHpWjnt1/nuNqKOcKwB9QG7Yc94i0pYvuXVfpJf8ug0K4ruCFqJBjLMGXNpRLfzoI2
	bk6kwQ6P92a4+3B6oWOd9tjvaNdRT30TW+3r6pqLpLvkNOL39rWM2fITAwhlwruqKAmTsk
	bjJprgGgK43+x7dDz58x/nqerAuRx+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ErZ1zPfi;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770840792; a=rsa-sha256;
	cv=none;
	b=DM9lYMELUMBGNo8Je789jyIx4Oluera8hFy7VrRegufkUTVoywJdApKoyZpi/DP8wAkahh
	/ZR7SkqJQTdpbASbsUfy/sO8E/YMdqY8gcw/r/V4GkhoWwkpItf4Jm7zenDaox+dw9Iz9J
	8WFFSdeg2vufLYz8KUR7DThurjUheTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770840792; x=1802376792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4qWoIzqklk5CjRX5mZLDzkQjYyxvVRRXeruY5T7q05s=;
  b=ErZ1zPfiDJKyhhXSJhLz1gGRDrGlTiYpY47WSD111n1y8bIGS55CuTd4
   gctVtTwf1/Q5Tri7LBbncN5gefsvpcoeTB5Nc8KaX94qLQFwZSKS1QrHb
   biaRK8N/L0Ys7IieeFVxCpYi/Z8mDc5jPD3aQxVKeRl1h3iPpMWoJMpLi
   dZCv4uLRplB/6C4ahckNVH3/OmAvVxVAoTY2YskcCZg5WLR5api9VhbQv
   z1tRZykLPJoH/sgpu6Esvte+f2c2gc5OSFaFByoLCvsMKKAttJrmcuZ/J
   xxuYndg8cPlPcxXgc7Lai6cvL79CcabzK/kBR62H1ZnKUbJdI3i8/qq3x
   Q==;
X-CSE-ConnectionGUID: aRKb7JLGR4KRcsEf6x39fw==
X-CSE-MsgGUID: pDeiSp06QgON6k//oNlTRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="97457869"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="97457869"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 12:13:11 -0800
X-CSE-ConnectionGUID: Uc+oAK0ZSuCPNhuMV1vT6g==
X-CSE-MsgGUID: KtgB+QUdQeS/k2R1iMQToQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="212180727"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.146]) ([10.125.108.146])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 12:13:11 -0800
Message-ID: <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
Date: Wed, 11 Feb 2026 12:13:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260211195233.368497-2-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mx7euj8zyuwbsom4u78jro8zawh8zqmq
X-Rspamd-Queue-Id: 4099210000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770840792-670009
X-HE-Meta: U2FsdGVkX18Ku0Z2FZZDHsK+mdMH6bN6gjKDF9/E6YSLs87XrTeqUbpEH3Zcgui3JCpWkX9uy2DqvmVregCgaQusmJKVAcbYFg75wu3WKKgWYKt2FpCjbHDhPssteKoaKH62ZXuCm4VOSJk1oVfHwTtGqwpX3lbpfOawih5FM/K9WbW/6/pSOqUktDQf+2CA4yIp0YRg7aTMFLwEzGR8Cq1WxCANI7kgKU+aSsYjPNob9KPIWYz0l3fiwp9THWlnjoIMLcPOTuDC4si1bZiocpuZ1D5CoC/yZaCd4IG1T6BDAw92jL2tLQjiy1+jdEljd77SSAjSzs9DYcwOfy2i09fl+LxjPz1ZzrgyRtZSc5ejGJ2pbM38ueVVpqWx7bpIZpCdTDffvO8YSmxRe6w6FsaouEulN0OexJS6OSluFPW31jRbeYeI+n6pJ+O/QKvqoYTwVnMhHmhOigQWF4yxNVyoDdSj79L20ekSQSG09Gn5w9syFSFCrYmRlPxT5ZUlIn1pRYHV6krhClj10jNmZRwcN3l99z5JYtdZjVbb926hPfVPsxWjDcyFdjIoL2zqbnVPyFluNEXw6uokUZERgkR380oS/cUjVyeQWRRor3Z823ItstpO+iqTaXe1y1+oRmYbrNFpCQo+RTB9ZZ7tITwntHZHRhPNQo/qA4CY9vRqq7YFfYZ6CtyqFKukpg0qwvtm1iH9a966oFuAgMSEsb6yRQ4mDDNnajgWKqLhcT0cMIZhknj4IOd52b7WiKYjlmZGyM2NxsTpX/bTFWqIK7vSZH+AoE7ySyL5PbhJr31BhNQJ6YYLMLX0cye+2Ube6Z1DkuLhXwIwcwjpd0WtRx+yWWZiGwVqzR0lynEFBP3qPHUbaSS9aMdc9d5MU/zxwpHc0D7A5U8RLhGASWmmpIXcc8pvuyjy5Zf/n4jqUvx697BIkFXzsRfi9Izob6Bgikct1Dc0bdhgjt7GGEs
 wuYzn6Bx
 sUE1V4zSaya22PFQsR4bGJZIklpHFk843dX9g5f9gvrufQ8o2jK5xApb16UmFjOeNNOwgcTLmqYnkj9pFQqYG5bIYNiksaEx8HTZ/MJYIfuc1p8EXl4vz6lt66oeDIAn+os9EQtkIw8PYdEuwSENOD3/s/odr5clccnL1P9mFolnYFveiK+Ttysuao1M3Y0zfDzoRlSqi32h/XQlTlEOlnXtI/FI09hYftiB+vLQoyy8XT4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> +/**
> + * pgtable_alloc_addr - Allocate pagetables to get an address
> + * @gfp:       GFP flags
> + * @order:     desired pagetable order

FWIW, I don't like how pgtable_alloc_addr() looks in practice. It reads
like it is: "allocate a page table address", not "allocate a page
table". I don't have a better suggestion other than having:

	pgtable_alloc()

that returns a page table pointer, a void*, and:

	ptdesc_alloc()

which returns a ptdesc*. But I suspect that would get confusing at the
point that ptdescs _themselves_ start getting allocated.

