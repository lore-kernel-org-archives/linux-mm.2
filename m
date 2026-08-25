Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5360C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062A46B0088; Tue, 25 Aug 2026 12:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012AC6B008A; Tue, 25 Aug 2026 12:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44156B008C; Tue, 25 Aug 2026 12:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BABEF6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:29:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C0791403DF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:29:09 +0000 (UTC)
X-FDA: 85140326418.19.1E686A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8FD34140009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:29:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FSpx435a;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787675347;
	b=E3Gz2eVj2H32FDFXCVLhGFuDmIz0k9FTLuVY2ijOZU0KwWN+aGt0nj37GzEh5jGmah4Yss
	4bw99+1DCLTq7Y6TudqBEf2ZCCFTyq5qborcHJhdkMofAnHrQtHQo0Lzb1sCHrs6aZseY5
	O1HKbXR16h9mYNuQhkPelLrmRwQPRk4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787675347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPF62IxZADGIv1P9+ugh9nyQhM+lMxKjUy6ZDt1btX0=;
	b=AKTcy97DRBni/CSgzHCNrkkyyKyyLTnFKgtkPJhwutpYAYExeC3f4f9XJY1FeV6Gl0cDpD
	oM+WGX/vXCllNGZ7viBuLR64Uim/dUbpXjNzCEAdIvzWU68dhDUgOBFXGnitpxngTJPc2V
	lHPKFWsPYnptopEEIc0EikdkCVx9HnE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FSpx435a;
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787675347; x=1819211347;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/WjOL5L4u8K3zXnAIx7WDdWMkQydRGxOy9xPF2tkCxo=;
  b=FSpx435ay/ue8MEiOojY4AdKi3EscWHmw7UXnA4R8ooI5JegInMOgKzY
   FvRtH5/dPEqcXE+1Ax5i0X0cHnKSB6GGo+kqM/WyyTAvGIJqHZ501GlUN
   bZLD5awYyu8RiUffHknx7LVKt5tx/8HYtf4d44qhgJ0fTFHu2z43sgFVF
   bF/VoygtwXVCA2hlBMrhzyL/J6ApoaGOdDLCPsKATWWOPtw/iPyBvdiQ7
   mgSHxo0hp04lgJmEk+UO6Epe2i9c4oO2ssqHGNjb0gQHn1MFnNfQ6nwkI
   In+35d7UJQ6Z94CGeSEx/UUwG8oWnKFVOzducoryG6tQJ/ioSeCiyq9ik
   A==;
X-CSE-ConnectionGUID: s2096rSVRc+QY9jMXt4Qvw==
X-CSE-MsgGUID: ArfXyWC/S5SQcUMbK9a75g==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="105528265"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="105528265"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:29:05 -0700
X-CSE-ConnectionGUID: mgNl+wbvT/KI+p85qn1Kbw==
X-CSE-MsgGUID: DSYkTyNNRuScATp1o+CtlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="264069086"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.12]) ([10.125.109.12])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:29:04 -0700
Message-ID: <3663d64f-7376-4bd1-b8ab-401825579d42@intel.com>
Date: Tue, 25 Aug 2026 09:29:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, usama.arif@linux.dev,
 catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-2-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260730090647.2401252-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FD34140009
X-Stat-Signature: 8w3fcs1ipeann1xugqeddjad51i1bdpp
X-HE-Tag: 1787675346-814653
X-HE-Meta: U2FsdGVkX18vFiIUzFlKKSMUKI64Kk+tNvZrG8KjmZlOWS1fYuggYx9yS+K5N0Gz1nYWvaVuzY9p5HqDVJQ0/UXkpgu3lqselQMgze3Na5Ughg3rOMYqxrKXDuNukOjIYal36nBtug7XQy2BqiHZO7eZhPrFi2PsHT7JSVo8F8pUJAtcBzBIrVB7SCPN2oeKiywLoBrcDMdyRwMuOYkMPYTMtDe7HedemexCzHH3bkM1IZqk33PgCmsqTxorsx6hyX6qmudqGDnY2dU/JjUKn+ohmMOdnisYxtx+VfAf4dwwAUpAR0Bihh4GEioKh6JdIcJg+2PLj2bf0SR9UlZZx4YbBVBzWBj3wo1kczyWVEuLdfRxGAjIGGvZ/k4x8RMSimRGBaQYTs0uiVCETXHeNlv9IgWs0YNOpi/Wbc/P0rxEdn5rdMKHNe1YHAZLHCbdMPaXnnyDRbcnNoKqNwbaWOCfGZmaHtB4TAlwZv8nSbmeAf6jizzA5PJr2oHZZrNkoUBr9tZxbmgURMYccoAdojWxs80MC4by6JsHRoy0uwu4QaewhsqIFowEjM69OMkJs1c2BJY/Z9Y5EdaDuue46C2+UD6coYL1kas780BhIj6H3BzKRTm8PfeyMvWqEBbNw38u4T+SJZf1PK7L8IATHFt5ySc+3mbazp03IzxUeTMhMYD+9s9V6nsx8BT9uYNHK7sRRbfSCjHG43iQ9uGtw2tb9EdwkZMBwPlgTBDMtDRxQcZ5We54q+0OGt+AGFnCfOpL+089OZf8yw7wnBI4p5ArKHrukO1R2rxKCOeLyDrYwxYY5T/XQCh+Yi+ll/nZgjhWPs3/UpAPSWW9JNrGiIhLVT3DYNdkt52gotNLP5n6F8IE6N6bScK2EJRwy5Sh+N2dxHj3wDOZSgy+AczRe3Z9cvVStp1Sc1zG6NALnvlWzveI87e3gtV/Jui5sLH5di4/m8+/OeOhR7AwmtZ
 hG4tNXPX
 3+DqsL8QRqSCuG/T7j+jj/I0tnir8jgUVBjLnFAHDJW1PGVGHLOhnLWL9Jfy06rd4zCgtQQSToTmM0Q1SEzVBHNBiKX2uS10Zv5LXKmetT6B7Mh4DazBuucZP2qLL+Xyg/EQypAyBJ/2SZk619IAiafR8NF0qYnH1m6c501YhpzHEV5WH10UVUfxAwkKn5tFUaWN9ZSjZkbGQXSusn+Sz5oLJcPbxW52xPtseM6pezTO/AUCXWnKPR0+4lBppi0xHS334DFtV/ATzzKcMfYdPP3nkGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 02:06, Xueyuan Chen wrote:
> + * Return: 0 on success or when direct-map permission changes are unsupported,
> + * or a negative errno on failure.
> + */
> +static inline int set_direct_map_ro_noflush(const void *addr,
> +					    unsigned long nr_pages)
> +{
> +	return 0;
> +}

I think this is probably not the best API. First, it isn't consistent
with the other set_direct_map*() functions. Second, it's unusable for
things that matter. This would be a buggy function:

int this_must_succeed_for_security(unsigned long addr)
{
	return set_direct_map_ro_noflush(addr, 1);
}

... despite looking just fine.

The best thing, IMNHO, is to return an actual error when the stub gets
used and have the callers deal with it (or not deal with it if they
don't care).

