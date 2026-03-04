Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA27EFCE25
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443276B0005; Wed,  4 Mar 2026 12:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED326B0089; Wed,  4 Mar 2026 12:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFD46B008C; Wed,  4 Mar 2026 12:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 200AE6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:44:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CEA7FBA5DB
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:44:03 +0000 (UTC)
X-FDA: 84509103966.18.9179892
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0580D120012
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:43:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TqkCLRCV;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772646241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiZedPVK3eGxD5MvYK40/L36l5RRYfJLioHzBFqtY9c=;
	b=qzvBsLYzgZQzOjof4bWGCkKbkh9WNQZPxWkdV4B7yFZLwgTkE2SyEYEo7RdZWwZLZa6vcI
	+uEWDEoCNIT4WG6zmG/uZ5oQfEDBMdoIRPPadb8o9va+vPCH+l0KcV1y8KqI2Yi+B8FRR0
	RpuNuXDCap+0q6AXzNzEus7MPIxSkCM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TqkCLRCV;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772646241; a=rsa-sha256;
	cv=none;
	b=8LVwhjnant5Jyps6WJsHPKHINW+JCw2Kgy7ScvRqYpzP3BZK+Y8Ico2xxutd2Y88tLLnUA
	ezgSFIAiQNQL+AIvtN0dv8BtlCme6Pjm1FqV/6vQQ6bc+qohEAcg5oALfPvZxAjOqeHHz9
	PuRTxU/dKUVWpmpVnUtpdVKKpqhcfaY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772646238; x=1804182238;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GiZedPVK3eGxD5MvYK40/L36l5RRYfJLioHzBFqtY9c=;
  b=TqkCLRCV5gyBeukCG76ZI3SUr18FSHugu4q0LPCxD+NxZKsD63WUPXnN
   zHsgQZ11DTM91PbGHeCJurNmIjptdn5WIT2fo4NG4u19XAEgqxOwQq2kb
   uHZfVWZhYcmq3a7dT7F/H/hm50EQHDlFiH1lGKlbf6c3IOX8U88U+WJmm
   KX3ThRsDrgbpZgWXMP7bCVGAaY1Aw9GKSFWqyAYs/ZqiarokrHkS4yw/A
   qlrpONDvC7YRPzcGwSAqX82P1GhguWCToHkml3f2bpq+TgevVVsxgI2ve
   jl8JDkCYo+VNlgcEpmJ/+963GK081xm4L9Wdlqu0CIb65bXxDbEjmVnCg
   A==;
X-CSE-ConnectionGUID: ib4TC/ZxRS6OL4KHoPm0ow==
X-CSE-MsgGUID: E7683YLASq6FhBvhk+svSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="72742184"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="72742184"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 09:43:53 -0800
X-CSE-ConnectionGUID: PbUYxrJgRkCDDGQntkmT0w==
X-CSE-MsgGUID: zE2so6YXSyKOe4BfcJFUtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="248882799"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.205]) ([10.125.108.205])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 09:43:53 -0800
Message-ID: <e3585441-f225-4a60-9c48-aac2753eef36@intel.com>
Date: Wed, 4 Mar 2026 09:44:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
To: Mike Rapoport <rppt@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@kernel.org>,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org
References: <20260225065555.2471844-1-rppt@kernel.org>
 <aafqhcG67FoNrF41@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aafqhcG67FoNrF41@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0580D120012
X-Stat-Signature: htgferc7idfba9tnr5q1ggsbsj4miwau
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772646237-239613
X-HE-Meta: U2FsdGVkX19rp0cHATIxsEb1R4cYMbnT9efkCvq20Rjn32W5mpcyAIhUUgBzza7iHytilfbh4ZZskLVoGMgfM/5v+gm65lHxgKL6vYWY7CFCsUxg/HLn439AA/Iab5DbbGPIqhwULQv4SOrSYq0VIdUKYLeRudrIlzOZAxPictHu6+izkWpNJnFf6V/ZRSlfxu6Zuc+UUeni9Olj1yle/17YbiSs1OvqfGbtQkLiIbELUkIaoHe45kFJ8Qb3PDzs2+3Q5PhKhanGlXA4z1h+xA+gmOXjoRxeBEz4m/c4cAk8Sqj5omhFnOGfpxY+JaIy/KC8XThRe2y5uvaiSFXTn781i93zFHNbbtmJeq+hRettY0c5nZvpESWv5wQ5ljaCEG35Mc7UOPGeSPuKMvPgCdRPHjYK1I+nkMjvzyhQCyeNBvkPdUKnk9jBnnb1mK7hg2XALAwgyWFSoEGa4RTp5kps4OZ7LrL3ZSYNpeKMgfcSXv7LDcSNAuAFQeUC81XdphdWZNjpb/b5bWPMdeVJpDwf9354pyajJAxLb+nCuMscqpQCZJ799HIkWuSxmY/7UnR/DpdkJcFo0M9JvlN6zFDZUELnIi21efN4L/aYwfjoryuhFNIGLpo7VE1V79durWUY6Bh9zSHxefEhUoHNrqoSAqR6ALPPRFo2CeUasQvUkJ1P//NNfTyuVNnzOqTsjZslUaTvPHasrvHzxScMzxq0qckUISrj6qobPenVucGZxjyVoyXKFnUANPL6SFw9cW/+/ipx30UfBWN/RALplbvHE4hO7pGOqpQLaCK/kt0tokINrb4tUbzgUO+OLHPJ4TkOkDDR1Px5NyZKamDgrXms84pvPaVkpN0uO3mCD+yvcUrVZcFIgRLwXrNHVcnPPf+TmIZ8MgssAlDVKQP9E0fC+71SIVqSW47euihLlGcKGibINECUp57RznHW/o5VE1jckg/GkbvYqVC3La2
 dJIE7nPN
 0l+7wAq/a+GkjHF5rnrnd0//VTqTWA515dcqstOpyz/kMxrdo1BA/FwteBsoTe11SxIt4NWdGCMhW83JusAmM9CBOFB5sjHDMiN7NLnhYBpIH8GEuTx3Jn7zBw+XsVMPxpvUhpntsCUipPoy5GknMVCT+uEgFwg1wzuNVQ+PqjeIOuL7xyBwSrV+pPzDGqKoX0Z9k5Yfyq7FzgmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 00:17, Mike Rapoport wrote:
> Gentle ping?

Ard, I _think_ this is one of the efi things in arch/x86 that you
normally wrangle. Are you planning to grab this?

