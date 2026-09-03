Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB1FC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136916B008A; Thu,  3 Sep 2026 14:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E706B008C; Thu,  3 Sep 2026 14:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FB16B00A0; Thu,  3 Sep 2026 14:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C76A06B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:01:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4ADC9140608
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:01:11 +0000 (UTC)
X-FDA: 85173217542.15.15A47C4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84616100010
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:01:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jp6GiZA6;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788458469;
	b=kToS5PmG7ibBlg9Ywl3b9LPU0OrjaEMqVz4Yh8SWRihIhuV4ZKaJWYVrwtd/c59DAXBidc
	sn5Os7/df1XzJISqd5Gwtv+8D8WJ4YgvaFh0Gt5SznEzT2cYNqNMEJqWJbdxC5NpEOgnNq
	8Z8QYJGts6VAdXtdBuIgLXg2r/lcMlM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788458469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myw9lum/wtXW47OZZ78rbnHjpSuH4H0DVNUt5/i1wH8=;
	b=Qb38sRsx5yfRT+9v+uoXMReEbf3F78TC+b03N0g7dmd9SBTvHfVt/lOZ/gxNrCuAFeL2CA
	jhiXHEvJiS+6RCI4B6/IG8guGhTuF44c7qXgl7ERidJc+aj+rOx3g3LPmTv846o1ai3zNX
	7331lKOqs5DAw1fISCI45IOLoZ/P4Qc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jp6GiZA6;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788458467; x=1819994467;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=myw9lum/wtXW47OZZ78rbnHjpSuH4H0DVNUt5/i1wH8=;
  b=Jp6GiZA6ubEk8t2I9yrdCCV6Zo9b/FfT+eqIgjDUN4/VzfnAPblawZwP
   TsO4cYW1zb05UBiyLG3QA9YjNzxcnwUEA4aCOtsOTjc1rqmdMgmFABAlq
   63sp7+PXgMnT+7CQUtztCp5LzPVMqD6HpsOKZ/JSQO6+C8JDPs5qAbF+4
   QuH8FYWy/5PM/3txPxg1RBj+v3UaXWqX/i+NEm7yNWQFCnW7AQGKJbIEt
   kpcE2Ds1aCXnV6S8NqEoUb3dqCpzKd8ZMo3sQjV1j5rBCP6+b29DUXcN8
   J+ZlA8MhHj+HS/oer/FnZDWORROOxUNXfpaNJ5SR5GhDV0G5edO8tD/y7
   g==;
X-CSE-ConnectionGUID: bjGrVTrkSjWt5q0CezF33g==
X-CSE-MsgGUID: O4Xwuk4QR3WQRsgS/5f89w==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100311105"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100311105"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 11:01:05 -0700
X-CSE-ConnectionGUID: cr/tNbkQRX+qB83RA4fr3g==
X-CSE-MsgGUID: 3pkmEssaRpu8jSjByM2iuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="263612036"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.172]) ([10.125.110.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 11:01:06 -0700
Message-ID: <0b084321-0898-44fe-8c69-7aeb171eb8af@intel.com>
Date: Thu, 3 Sep 2026 11:01:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "vernon2gm@gmail.com" <vernon2gm@gmail.com>, "kas@kernel.org"
 <kas@kernel.org>
Cc: "andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
 "yanglincheng@kylinos.cn" <yanglincheng@kylinos.cn>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "david@kernel.org" <david@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "tj@kernel.org" <tj@kernel.org>,
 "orsonpeters@gmail.com" <orsonpeters@gmail.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>,
 "rmclure@linux.ibm.com" <rmclure@linux.ibm.com>, "bp@alien8.de"
 <bp@alien8.de>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
 <aplfcTfjeQUgnrvH@thinkstation>
 <314f11c1-ce5e-4b36-b296-0ab742550851@intel.com>
 <c15c2b17e110782d966751dbf3c487a6db837a87.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c15c2b17e110782d966751dbf3c487a6db837a87.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84616100010
X-Stat-Signature: 78jo31d7ctbnr4tbm135wc7f6fp5dsdg
X-HE-Tag: 1788458468-245473
X-HE-Meta: U2FsdGVkX181u0ByhvlZQO74rxGMVz19oIqHvzOzy5mk7mOP0tTzhEN1RBrNmJutk555nPVrrtugEKYpalwtKfmAvtkVWh9Ra2A066ljv23gj99urp2FagShd3ui0pdyISusBZD9pC7EBndzrjvXbiYW/81Lu8CZAfdA5lurntadlVBFXQTArcRljY7bNcnK+zm97vSzJvHngAtoTvXZnt2tF3DmrIMI+ZllZBY36s5dxINjdeZ77DaiCfM0OUWn2Ciqgtj5vLL2QarDp8R5dNBQkY7oyvrdMnc+OkBvZ4qh7OTrsDfczxQePs0j1uv1KY7Ew5iBzJqQ+c6xEC+1TB7cxmHBDvbN/dBx63DdoSmUUq38J/2PLw9HwbhtsysO/IAa23P1sp+EK07+j3ibflgcNC9CBUM3MVBEIT2W7KclhsdnIh2k+SiIa9TBiaRg6xTaEChhMZ17odQV5LEI5iHrZieWHGdzFwzmwpsUuHfPEvUfedwb8FoZZIdeAxkQaNi2Kj79r34paegDTX9MS6YMLPlvkk0uGiINf0DbJZrwKhmy4DArD0ciLYVIAqT5h/ul14zhP0mu/SegbhTcBVukWBpLE3GqM5hAyv8qq+tbCQbBUXZljowy/lQx9eL8wohx7ppBpNmE/ROnYdSsXTgrQb3FSCS2sqBIb6rszJfyDZm9ecWNj045GmzGBaps2pG+h5T5DcyXOxBv5zF3YnDGY2We0v2TPJueXjpGkevu3PhMexbysYOSJbGtDLocCvUKTr2HzFbF1a9GJJAf2fPicoHWPpN3Z5vqTh7atJl+dHf5/l9vaLaYrDp2bA0at7PJM7LcHl/ipcwVr96fs3VHBu7wncUjS2EamUDtygZCR1x2v4ynll0y+ggZgQy5AncyvkD3OcVgiLLOhKrnmu/hSnVi6r6jNZ7DyOqejilRTbxwqTwHeCk8I/zWJ/myERBpaOUbtrgod2Uciee
 LMt3F08+
 FJuvDYqE7s5N98Q6PERibpOIyvOF9wSeUwrpi0Y1i1L/zDjmue/Zp/+HCJy+fIs0NWrKsPZ7cytr2dIaiT3B90+mRSuqCbroG9hSFA3D943YK0pXQPRvW0NarwlHiTMhZrYYUDaT6aSep17ld/OtnQnH3nPiwkgumpUFf9XKpj/mlJ0m2GouIYfco84crbflmkJHSfcJTk5lpqVeKlraGk0X1BUM+65jgrx7Zd6ByARTcYItrKVVuakCWwTlx65fC0XLscGAvnpSuuMLC4opivdW+lIJwLM1W51F4c1V9yWGypxa0OQDvhMZ7dDgeviIJSIZRwkhbK9iORJp39tDz9bI76IzUprsKeJd5Z78RvQ2GpQQx8jc6yiQyQsT60MOPDwtscUFzYXvSyQeXnkzJWGsDuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 10:58, Edgecombe, Rick P wrote:
> I can't find anything back then that would have prevented it. The bug cause and
> fix looks correct to me.

Is that a Reviewed-by? ;)

