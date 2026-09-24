Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80297C9831E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 23:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE15E6B0088; Thu, 24 Sep 2026 19:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92916B008A; Thu, 24 Sep 2026 19:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980F36B008C; Thu, 24 Sep 2026 19:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB7D6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:51:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E27CE1404F0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:51:58 +0000 (UTC)
X-FDA: 85250306316.29.652AE83
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5090E140002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:51:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCcZQ8sH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790293916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2pYiTtM0Z0B62wviFpURkZbYinPZr2jG5aLv47iBa8=;
	b=PCZpVu8Af0jlclXIwTStLYnNDFZK7xV2p4Byo3ojl+ew/NyoPsyHKD4Udb8qbeSJHYPMw0
	2Z06JXpfzOauCeR1MHXROH5sRoaDMM1CYrzgvwyX9eqSXeDwFdHpfkMIgnDTT9qavBWkmc
	hX1XnO4zHFyXsIuGd1eKS3pVHquFFkU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCcZQ8sH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790293916;
	b=iI84AhOpOrmwohxYgNldfQ+CVfHMcNrR3VWa1MZhppT30M485Gwrgq+mFtjVdC6Nlg93Ly
	yxfy5A6vRPhqn2MnTCAadtce/99pHPYgN909cjelVZgFp5rmY/JO7X0W3RE8I7AswrelPG
	2tc8w9RhemqFkjmyUuwj/aZavx0lK7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790293916; x=1821829916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6Uq6wuyjUbyExy01Se/2Jy1Aqebw97lxp1LfmLrA5bs=;
  b=bCcZQ8sHzAvOGZ6yeCdA+De2Nvmb0Jl/vDF1N7BNlsbQKefXU8nw4Hnq
   i4vQUEfCTlWrKOb4Q2ObFthZb1i0FByUplb8i+jlmGkcb+C/4UDYMHNft
   CukczVxCPASFkrLOmKxLF0slsZP2sR0hxcuRGRF+3zlen1g+gNs2Nhqxs
   wZzqqBAeWG7DN/6XQvJI3N7UH4MTtCQmvI8coyzkDNTTq+DSithQQRkjj
   SmjPLUTkriA68jxXuO5ReRuY5+XqFwudEROLq+q42iG0etSzBKZnKSxVP
   sUnbfF/+pwFI0W3+JD8veoXLg99UJUce03LLrxNDVlQRUbPvi0Tj0W87X
   g==;
X-CSE-ConnectionGUID: RRkUK7VBRD+jBZNtnr31Xw==
X-CSE-MsgGUID: CbhZtuf2Ro+fbXVFUpRm4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="90300920"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="90300920"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 16:51:54 -0700
X-CSE-ConnectionGUID: ou+D2gJoThGs7F3ndWMy0g==
X-CSE-MsgGUID: RB+w73acSbe8Xm7tGfItiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="272762319"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.219]) ([10.125.110.219])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 16:51:53 -0700
Message-ID: <67a44daf-feb7-4760-9b68-bfea176b4ab4@intel.com>
Date: Thu, 24 Sep 2026 16:51:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
 linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
 <20260924203915.189167-1-mikhail.v.gavrilov@gmail.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260924203915.189167-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5090E140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: e8qxapu65r8dw5wakrtf4j4y78ruqe54
X-HE-Tag: 1790293916-459342
X-HE-Meta: U2FsdGVkX18USDAuAGkOBQC7BtKzhB0GlnkTUyJXlhU+CQFnkxG0pNrhVAN5PxYy+NYt8sVMAKD/fWwiuE4R1YYEcgXMduivg0Y18wvIiHWZYvo/NNY8UtpMyQEwuxt8uMi7FK43JpHs16aBShx/R+FSwZTS//EBKp7Z6QU8MYrlkZHGsL+keY3xECjmJm3s+c+ceDAv8uZQdp4cBb22t449yNYI1KeagUG4YP9NdFkLoBviV6e6Qnmofk9bLJRfd0RG6X86TPn1sep82pFS7y+nlujN6UbU8DAl6vN9Rv5dWmFaqknYYOrNhnjOquFrLkvUrjTJRLbQSkWWdhMXdtI/Gd7kgzjnfOIQ/21UBCEMGguUn2oMHzqZ4py8IAshNlLK/VruWWJNj8CKDao6VrHA4NzLZU6oK4HX9kdfEUAsIEcqxj0F9VuN/DwFaXIC/QA7XjEQGCO23ki8HaxEkVP1XukC4ZmA52bHWdHH5RWPCZvjLYLDCZEm6/FUuUp5jR2AW9ZUyE5J6IYBKQbpGGBacV0YLfDXPbhOaY/58u54TBff3Z5+6c9/tED8c9jW4LKwC27DWejsh0iDhzRd6coZGI2A9CfDcLbwyUVrVOfPBCleK5z63NG0uokEEwJtFKfjvRWnHRiHvpx6FoiT5WDfg74gFy+ADnFwY5UbkFuGq9cGY8dewnsbJLmhow8SLWjm/GgRZqcePH+LyK+HZf4rabu16LOOLDygS/dEyeJEshaRjp7A/MbwdN3mvUHcY4V6yVJLpMoUgNSkLphg+x6VZBZrDS6iIhMSEWHhA1XecSuEh8mu9SAVe7om1AMSgW0Ux2r3ctY6djkjodsvTQPwqXFw2sb2ysX4Y16A0Chs8BePktuxxPBMtfw+olGjQ96pZb/FT2FjrAu6CWfimeDL896JCBnbwhGwQt0J6+y/YAiuouYdXYThqPg5AznmKmDST2ILPZvS0/dpCRE
 g5piKuI/
 Yu3XIDRtMhZYOtffcCglh21J9OFCGvGU5E6iwYAxd3TaX53LoeQLRX+JIS+QZh8tHfJFbb7N03fTKbp60q8P5uoGJ7GCUt8lFpYA8l9Nnk7VxfUsXnrU/RV1WlXGzU/gsFxFr0sIiWm59c4aW5prv/pdaVYcMd0ObpkwRr6Sz/sSmt+qsI6ofeRy/s6iaEJ+j/e2b4Fs1CWC5zIiIjLT112L713QTA9tVXcPjo5Z6qgiGnejGpCF9u3jOTFdiP9ct4VAMCwEGI0wY3/cCr1gM564RrAnvLDd3XGSE35HefkDxgKXDvYCGwFPIkcNVlZHMNrTQ1VbdOjVuTJnINFwxPN31u9UxvXOrS3Pr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 13:39, Mikhail Gavrilov wrote:
> On 9/24/26 10:21, Dave Hansen wrote:
>> OK, I've got a version of Mikhail's fix with a changelog and comments
>> I've munged a bit:
>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=pmdfree
>>
>> Does that look OK to everyone?
> 
> Looks good to me, thanks.  The code is v2 with your comments and the
> declarations reordered, so the testing done for v2 still applies.
> 
> Two small things, both optional:
> 
>  - "The new mmap_read_lock() is held over a GFP_KERNEL allocation":
>    the lock held over the allocation is the same init_mm lock, but
>    taken in vmap_try_huge_pud(), not the new one in CPA.  Maybe "The
>    huge vmap code holds the same lock over a GFP_KERNEL allocation,
>    which is a no-no now that reclaim can take it."
> 
>  - The kernel-doc lost its "Return:" line while the function still
>    returns int, so kernel-doc -Wreturn will complain about it.

Thanks for those! I've integrated them.

I think we'll hold on to this fix until early next week and then queue
it in the x86/urgent pile.

