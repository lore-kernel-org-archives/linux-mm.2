Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5506C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3132C6B00E3; Tue,  4 Aug 2026 16:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBA86B00E5; Tue,  4 Aug 2026 16:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201A36B00E8; Tue,  4 Aug 2026 16:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA6A86B00E3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:08:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5419BA18CD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:08:08 +0000 (UTC)
X-FDA: 85064673456.06.4322ECC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id F25AE40008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:08:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GK1l62VE;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785874086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3WVbx9DjizmWqebKqOWEDE2LbnYDmLdJ6MN0TdoWno=;
	b=u02T8fNObeIab4EPKEaDNw3eGVHEC1UBBcA3WbnAFFZdK7Ss/+QddqjgMYa777K3NpbZS5
	+66SAuBWvBnz4G1aBwYgsqW1r3w9Z/QtOQbUCxlcT+p7Saqfa0X9IWjzJcWf7l7g2k+QaQ
	Q+Ug033HVzoZPXjYbbpCJd3JadvExM8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785874086;
	b=FXUg4xef12J0lVy9h/Rmi7YJlkNE+zsOI3Mk+GInTHynTB7Hb/Pdtl+TE4xecNxgRbBt3u
	fcBYvzjcXeN9KcRC/eBQBsW3MIbekzxCLW61hRhBe6NDgRW8BBXuBd27cHclreURf6iAWT
	srmNsFcknw1eWkpaSkhhM2QsSIebe9Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GK1l62VE;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785874086; x=1817410086;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A6fH+vHOIZ6I29oLKNkELdsCOM1BEX4zSX5AjzmFPqw=;
  b=GK1l62VEuyLoNW/Qh5T06HTDRTrED4VIgqIzfB7SzhlY69h/QxFXddUH
   j6MO3sAU7C1PnAzF+3rLHBBHzsmZy/KX1spXHzNpjBS4GtKa94ShFH/UW
   ubt2GnlYqnVfQMHBsTQ+usAkMPhWwxPrc6xZckPdeZIyHDGc4SCtQhht/
   BPno5nPD1xtOhWeLzgktEXNojkMEKEDsxPqnws5iURd4oD+dJZcTavHoW
   sy4GV2aKQtsZcRFh8BH9y5jV0Q8XQV9Ja2x0TaCnLgnEEfGGN59RIxEEQ
   IdXhKOSeTSh4wLBcDZC5eeCUMciQrV1dVa53Yb4I19zeyYEGdLAaBYL+9
   A==;
X-CSE-ConnectionGUID: cjPSou9dQ0qEd6247hbs8Q==
X-CSE-MsgGUID: lsHlmDw5Qfy38dZG+rrW7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="90112330"
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="90112330"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 13:08:04 -0700
X-CSE-ConnectionGUID: 9//HSCuCRqGyG7LmJWxQJw==
X-CSE-MsgGUID: o2VVLwpiTl6XG//kyLCaDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,205,1779174000"; 
   d="scan'208";a="286238876"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.108.232]) ([10.125.108.232])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 13:08:02 -0700
Message-ID: <5c5df75f-6226-402f-b223-abdcb85acc17@intel.com>
Date: Tue, 4 Aug 2026 13:08:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] x86/mm: DEBUG_PAGEALLOC musings
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-mm@kvack.org, x86@kernel.org
References: <20260729110807.797920433@infradead.org>
 <2ea2881c-7202-40e7-8fa2-f1c649c0d445@intel.com>
 <20260804200134.GK776954@noisy.programming.kicks-ass.net>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260804200134.GK776954@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F25AE40008
X-Stat-Signature: n6m4kakh5n8ugex5cc96bjhh44eitxuq
X-HE-Tag: 1785874084-333010
X-HE-Meta: U2FsdGVkX1+mRlI2cTwxgqjayaZdkoxVsekX1HsEk4zz/KqH/zvxDWVhRTXaS+2PoR9ani4xun6uwQTyNgrRlh43xMJYdry+FYv0rLZ7Mp7hRsPDUMmmnRWAL67JY5TihnAhPiEvrywRqMX7O8AUkkpTCA7RQquB6QrRaYZEHF78tiZsOARUhzcbWyjOnKDY2Kn8FpsIVynrtMvgi/0dxU4ucTEf4D5OrHMgEn/w1QdArduMxHwI0c5nFA2WBgKc+irojmvri6S/rIccKZZv2LJfSqfRe0neaG/HzIkfDYqhKGqBofMc2IZ/aGiKRvb84rW/Cl1IA6+zGLTr8C7X39qW9jyzNILgZ5OJYDMRbFINw3lvBp0w/eTcLnzC/+X5FIz1tuolf3q05/ZU/+3RGubewuiIfXeZOfVkut+O0rDVHP4xhqKNhDhH4FRD0yDz5X6kkvizbLjNy/aGjaYmJM8Z0XimSeTuoxoNm64IFIWSCpsoY+CvmVJynKUaVZEZilhv1gQMeCL7fHrfl2i3WFEE/cNrPmVwjTFFRnHDOxyPHaM25EYnpNDTo1oosHeeVHIim+bnrgex84sG7dsQmuLXcUkUvPihXkqbbvQk6KAMDljNZ6hYdBbENE401XjQ0TOxLxRXlVrR5+aToDU3GnqOpY3YepEh+RA4YWtoOaKCW/vWoZ8fb32oOmrf4bzlhDX4wJIOEUF/i5zQCzsng8/C8j7ws1fNBFQtTsoJEfzr/srbi7nhs5C9JlLT9fFt33zOULKlvQG78JkhWy+x9d81/Jad0H8devif7N5xaHibs1mxRtAFRgo8I+aOagrhJMyfClXC0BwoydTctx48W7xTMV67T4SF9n/KWWc5TFWmPhhrV11+oJPGFWcH3wDBALmIopvUBu8wMKbUf8LuO0t4oIkVluujexnjG8ZwGfFI8feDIde/0oqixVHenpv3a8BQArWRU/KNL/meaAI
 m6Cso4Zy
 ZtbcvAevuvoSqdeGt1TK+gQ3CXKHF3aASbQQJNTNbxrV+z+nv/0zuBtYRz24VCrrLB0zA33C0D/tG37hODBKSh4l+WlSC2oT3DpyuzT5/ums7A/RZqEHmdMo44yT2X7cC0QIX03NBN7Fxwpisl3P/7fXk01j2ONHV7eHPblVAp7LU5mZJKCVXnxN/sphokoDwUlB6Rq9NGoKdjAxMsag2+BiMJV+9HvYOmzye3j31blwvo7BNzCAQNmCnATJf4lbz1XkLoHb+KJew2NlDoQ9nCf+QsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 13:01, Peter Zijlstra wrote:
> On Tue, Aug 04, 2026 at 11:34:36AM -0700, Dave Hansen wrote:
>> On 7/29/26 04:08, Peter Zijlstra wrote:
>>> my take on how we should be 'fixing' this DEBUG_PAGEALLOC thing. It appears to
>>> boot in qemu with debug_pagealloc=on and such things.
>> The approach looks fine to me. The only thing we might want to do is add
>> a warning of some kind in the split/join paths for CPA_DEBUG_PAGEALLOC.
> So if you have lockdep enabled hitting them will scream bloody murder on
> cpa_lock and pgd_lock.
> 
> But if you want I can sprinkle more explicit warns 🙂

That's true. I was thinking of it more for self-documentation than
actually getting it to spit out warnings in practice.

Folks are always copying and pasting stuff and not realizing the context.

