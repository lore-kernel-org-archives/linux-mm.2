Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2F2EA4FCF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC626B0005; Mon, 23 Feb 2026 10:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3536B0089; Mon, 23 Feb 2026 10:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5E36B008A; Mon, 23 Feb 2026 10:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77B3C6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:14:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 131BA1BF99
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:14:45 +0000 (UTC)
X-FDA: 84476068530.16.7366A91
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB488A0018
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:14:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cAi9MoJr;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771859682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNGpgP5w5m3pkn8x0/Cj77PQ5NYjiWM0uMgsqT82pOA=;
	b=Wdtickza3rTd2FvfMsWxPt4iGfx77HUR/HX7UfsMeVUEzAvxumuxu0JLHlmc5/I8J4h5pJ
	YCmotV4wbxX+q7QcD3DYD7Rh/JqcnGPdQ0TtEhKq+zTBM4S7hlzspJcINQvrnmJ5kDAvia
	0TyGGiWMjsdxjAVZ+v3DOKytAtCk4u8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cAi9MoJr;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771859682; a=rsa-sha256;
	cv=none;
	b=uFYFsl1ZTJszIy21iEse1TbVRjo1k1jn4v6IXuP7XxpjNgV/eMHrIURLPtQiNfNCmAuf8h
	TNwJJF/1wW8S/uRTDN8qUC1iEPKSgBNPchIqGYt7e+33w9zr2VjLJF+etB+VunM6xceAL9
	11FYHZRj2N29j6TU0wNfEjmec7cUzsw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771859681; x=1803395681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=foG7iHqEXE3wb1GNTWnX+N/uPXbexmQZX4/CBrLJtJM=;
  b=cAi9MoJrNYvYUVoS2LbfSKpDgbMFHNylFT/SbBAuu4UTZlVqBJz313yb
   MIbr15OQbywS0uGcWk76pqBOQv1wBW4W6hqGAi5bhyeM9ILYt0vJNBtsw
   Pj5Ht+2uZmitTo+zTgjsilY7RRqdFCrlikJT4p2XAid1Oc8uSCf0WAknW
   dDaAaAxQxv9nfsUzyJThP+A1apFbELvflR0kL1+2bpbDeGhqpED5YSK5D
   rG9XbqylxkGpCswoUakjpvXVrOhSoytggtmyPR/KZClAPuxinEGJw0tSv
   uc6X4AQwzHcFO/HjtCw2mIegHKtu1S7aWOz/Ys10UYwoC7QaK4GpgCBbA
   Q==;
X-CSE-ConnectionGUID: 2xBVhnLCQPetJ/ekSZ8atA==
X-CSE-MsgGUID: 1tD6/0msR567h0s9TQWFaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="73033696"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="73033696"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:14:38 -0800
X-CSE-ConnectionGUID: MhcAawFkStKVj0i8RE9eUA==
X-CSE-MsgGUID: s9Gimh/uTLOeVQcaO6VHaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="215611874"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.205]) ([10.125.110.205])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:14:38 -0800
Message-ID: <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
Date: Mon, 23 Feb 2026 07:14:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: px9wzsauks8krqok8qri69rqaa7rizas
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AB488A0018
X-HE-Tag: 1771859680-823040
X-HE-Meta: U2FsdGVkX195gIPe289mDLu4RpsiFEd0CFyqz8rvxIgXEipiAp6a9GASMVGk1w9ZlPX3TGU8O8SB0N2WTFQroICb4uMSgaUYLilNgmIechWF3eYrlGdyA2oqfgy+YuQmBPHYmleLPcYb+5S3b1ole39Bli5BlxVqokeU/+TnngqLJhHXzLsk6qyDU48748XoqvCynnsyqFJbun15ZAQkue/Y6FhkXeWSolpDoNb480hovTR6szFMGk9EL/MA2GUzx8fKa4kSG6fSEWMe6pGo9TveHLS5OoQDAXAp4yWs/U7M27IspjvYNcDGLv/b+CTrc+Oz8LUqyEeVMJPPFFqO5oaWRL+//BKVjg5IqzkQfMWFSdz709zp5OhfEhqHQRV4R3SalxnkaPzj2csS/tQekUKtVpA/TIWxXoVAln8csQ7JnmlAkA3zLcs2Uj73p2wtenXHnwGKNCJ41WueNFE+fTeGcuLDJfzeSKqx7ZR8dkExOs/bScXDNxrF2Ri+/0kvWa+6K5XKMQvdNlH+3fPhtj7IzjFUL9IcEGug3NpTtXahqzjReEcZLizXzCVaMzxja9R0RpLe6hHwlx53UA6L5AVCqFxNLEuH46m1WqEPU3DxiEqYxaka98PTNwQnCjc04Gg7BIFyQy8eP/tnxK/W1fVKTTlBjZdRjmyDhiCPAv1gY8rJ+B9OyngOgXBlpkMQv94hjZUEzheVcCbxdX7Q7ivQ4mAfUg0eQNoTN4bmGvbCPHqOa7jQxVkrtpP7GENfK5hUlRTO5CbMATUm+mlZlnkIJxKc+s1ucaWw4UPBJN66bClvSMGQwqNzfOkjbSAXZ8kyLjWFaejKJK009CLRFAbdvKOYMPqOgS2xSpx1nr+EGwtW7JlfEEz09zoB8Uthds5CFDndwRLk+aUxey2INjcYmHzjM0cVNhrPBXPyJxaKVnGpfVfoxeRAz/1Zxl2oW5HVvJfiaFUjoljBUr0
 YORQWxOZ
 fm3Oen3fL3MEDGIopv8c7yWq1EpCAhu4M1+Ee33UaGTNHeRpsEcfPL5VrtMt5GtWV1sXgzqpXWSpLdI3tAwTTAyS88w9GEi7uZhdqjJwwlCKJtP0cMH8mAES+Z2ErezY56wJluCuyqfvau8Nq8XjHArBrxg9E4h6ojZ4Fwj+wjOHKKM7yx4/WCNixYytilo5W4XW5aFLrn/wcpizx1lH4fph265JuWnMWs9v3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 03:27, David Hildenbrand (Arm) wrote:
...
>> BTW, x86-64 SysV ABI allows for 64k page size:
>>
>>     Systems are permitted to use any power-of-two page size between
>>     4KB and 64KB, inclusive.
>>
>> But it doesn't work in practice.
> 
> Even in well controlled environments you would run in a hyperscaler?

I think what Kirill is trying to say is that "it breaks userspace". ;)

A hyperscaler (or other "embedded" environment) might be willing or able
to go fix up userspace breakage. I would suspect our high frequency
trading friends would be all over this if it shaved a microsecond off
their receive times.

The more important question is what it breaks and how badly it breaks
things. 5-level paging, for instance, broke some JITs that historically
used the new (>48) upper virtual address bits for metadata. The gains
from 5-level paging were big enough and the userspace breakage was
confined and fixable enough that 5-level paging was viable.

I'm not sure which side a larger base page side will fall on, though. Is
it going to be an out-of-tree hack that a few folks use, or will it be
more like 5-level paging and be good enough that it goes into mainline?

