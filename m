Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA62EC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86BD6B008C; Thu,  3 Sep 2026 10:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E246B0092; Thu,  3 Sep 2026 10:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D1A6B0096; Thu,  3 Sep 2026 10:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EDCE6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:18:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 358124055E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:18:59 +0000 (UTC)
X-FDA: 85172657598.22.EFE5BCB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7539A140006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:18:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NgHtiH7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Df6wQI322WnpykRrSt4Fv9AID2btuHB6UG33G9SZ59o=;
	b=IAgd1vrw8H8+firNPe3Wcfq95N47tsBrjlHEpVVMxI9urrF4apMVDXEr3bI5T/K0EalJg5
	bMCBYBi3cNHXAl6OFDtlKnQlyw0C+jO7WfUE9OiYyVEBv/ZZXfmHgtwjoHtr+6mmF2kYNT
	lYjzZjRHDSOllik+l+rnOJje84JZSLw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445137;
	b=DB5ixf66LSeNdlTt3JPXsXVQ0mJyPULrIsKgimUpumZav/J+9eC4/60+y/hN18nw5D1or8
	Hxn6za81KsISVueHEQl/Z1kkoOnrTk5ccgVlJoZdjSTMT/jX9knRuEHGOzYY+0DnWhrd1M
	bX7WGbr1h+wL2KuhjjMa1PiK83n+H/w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NgHtiH7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788445136; x=1819981136;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gvv3xws9lDSoCUycNPBtoGcVCIGgjwwMxk9617wb79M=;
  b=NgHtiH7R8MACbgD2c5DKYmugJFceYnaC38PhKS1bs5NAkTgScziGo0nq
   W3f+B1y36k4oERQ+iFR47QMSv5JPKq279LeEff/QfB8n2p8VfTo3g/55c
   940nruuoUMEBr2IfVxfOoLKaHflnxFKwlGyqKvYv6K7LwUII0XMqzEJca
   iOrz9k0F/sKsh+QgkxmXPR/2wwbE0zpM6bwka52TFoucdt0ncT1Q6U3Kt
   NCze+Q/wG7Nh+iuHZDcyew4lNFfNp/NFWGkN1jKNDBYc2xWZr7lv5BVnC
   5Fi/Vj7hm5IbA8TIZCUkAU2XYmtKNQQX8sX2rIgIziubqqQav2ywvk/JN
   w==;
X-CSE-ConnectionGUID: L7Lf56btRIifTqgPiHFp3g==
X-CSE-MsgGUID: NZbt7S+cRb2ix0/8T4gxoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="111702626"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="111702626"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 07:18:55 -0700
X-CSE-ConnectionGUID: wVQ2ynyeR8qedvMnTrUv+A==
X-CSE-MsgGUID: u5dzNVK0Q4uW1v/b4op80w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="269732715"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.172]) ([10.125.110.172])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 07:18:55 -0700
Message-ID: <314f11c1-ce5e-4b36-b296-0ab742550851@intel.com>
Date: Thu, 3 Sep 2026 07:18:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
To: Kiryl Shutsemau <kas@kernel.org>, Vernon Yang <vernon2gm@gmail.com>,
 rick.p.edgecombe@intel.com
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, akpm@linux-foundation.org, david@kernel.org,
 hpa@zytor.com, rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au,
 pasha.tatashin@soleen.com, tj@kernel.org, rppt@kernel.org,
 yu-cheng.yu@intel.com, orsonpeters@gmail.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>,
 stable@vger.kernel.org
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
 <aplfcTfjeQUgnrvH@thinkstation>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aplfcTfjeQUgnrvH@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7539A140006
X-Stat-Signature: zxdm9f9e49ps916mm1cbj8dsjo3n3pqb
X-Rspam-User: 
X-HE-Tag: 1788445136-145279
X-HE-Meta: U2FsdGVkX1+yZKQASnN2+be+3U9YSf2q+hu3tM6HR3p9pyIo5vlC3K7MF5BFYoAfbS/42RdSLM7u5bZcYrsq39emDpz/0UTnODP4FaIb1fo+h99WqgB+6aF4SA4faM2+Znr6CtCUeRnstfiDrFXTH2FI90kf9vUxlDAnpo10GopdPiP1iWC+oeBy3DedRTa39ZbUnwu1S61UQuLvjmwML2ZLzXIGn/oDN2VEJ9u+qOaC0slqi74UgmR9m2OopmHG6t/TTEAl+8RQXjLtrY2qEvG4KDxogJ2WJEXka1c3c54hatl+Q0W/eOxtguPpPfVATnTrZWu4oqyPLAberJM8YYZY4DgasnBUaXJWfjWaPt+cOboY2vPLMUh42TdtmckVMAH75rqvcTHDub4KFoOP2Z6obkkGWFFtqI3zqjX+UyefwspXytsO0421oFlx3xI7YD1xkdny3TS/ZPHSXmN1RSlVo+Z/Moo9Fd1OIjxWL9hTnVUiSiynrCImKDpWc0vEHtp0twsXCIfD7jtKB4HA1bitleG4yrHR+wjDwl0Qr8rWrXoyt33o5fCVk/GZxfHtaNfNb+FmVpJkiTo7rGAEZZFkDuXBzUWGS69cQvFQfYyr6oZ/7Ue8P18krBYyCXW5qdFtyPppeFcML/9wnSxFr46ZgSHs2mY0T8sM89w4sx/A5jlanC+3KtaPZMh8pK3+uLslp7oveEpLhW8nv3mkUO/WPmLIjPGTNEjFgj4Hoc46Cn3RpLD7sfd0CY4XBcEkHITnsIWct009eGSaNA8NKojncJWTCdDQ5Lgobps75N2ZRWpWzDYQXy8xKuZiVkgGCvpXx6U67TSJXEGZqYa7uFWXeP3s1lTnfpjHgVIkxNcj5WJijyO6yeovR7H8T60rUloyOptCa/UfdeHbgZKLqEw2pj7dn/eh/r5NegJIvzozhWQ3f3HHa0FblipZeM0N1awbUDw8a+riJYtNFzq
 As3mg1c9
 kPwV92eP9H7SPUY0Y17vjheyQQyXEFbvhnM5sasf9AWO4xKahep4BlA7pOCAgviuqp/z86W/AQRH5vnO8x3S+SIg5rYElo697G1mV5FXHZtVI4DkZIgkQqPtG3nvvGh9l3X7oVJmsRGY3H7wkOVcGFyYIaVHfGs1iVuvd1sksMTdU4gwpGPrz4CNjvojR011AUuQaevBGl/izY0TKXICBMsTaasAu+Du/yexaSkERItLy1CEdEdS0CnMO9UEm1eMMfzW8aZYZVBOQH3D6p30lCP7hIu8A16IbncHWroz4mt0MxWa0n2LpyTkSexo2hhNYiYSwDH0UT0m4BkzqzMnKQ8fPjdpbVDsnZwtbBDNrqgtylJKZGFikOBP4w6oiHNybDaYgfkDPil+JXQZfnyrGSAqPy0+560uHen8j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 04:54, Kiryl Shutsemau wrote:
>> Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
>> Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
> Hm. I don't understand why would this commit explicitly exclude
> _PAGE_DIRTY from the mask:
> 
> -       val &= _HPAGE_CHG_MASK;
> +       val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);
> 
> Rick, could you comment? It doesn't look like a typo.

My guess is that it's some remnant from an earlier version of the patch.
The asymmetry with pte_modify() vs. pmd_modify() just can't be explained
any other way. It _might_ have been some attempt to say, "Hey
_PAGE_DIRTY is now a part of the pgprot_t since it's part of the
'permissions' of a shadow stack PTE" that got abandoned.

But I don't see anything wrong with the fix at all.

It does give me pause that this has been losing user data for so long,
but it must just be a weird combination of features that few folks use
together (huge pages + MADV_FREE).



