Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9424BEB3634
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BF46B0113; Mon,  2 Mar 2026 15:41:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3AB6B0115; Mon,  2 Mar 2026 15:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF99D6B0116; Mon,  2 Mar 2026 15:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D16576B0113
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:41:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8393F58646
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:51 +0000 (UTC)
X-FDA: 84502294422.06.382B6C4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06A874000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:41:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dm0Uzzdm;
	spf=pass (imf27.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xkLVD9Ooj0gMBoqLLGvoTuO+EHSfpXFWxt9t3i3BQw=;
	b=PzIoYUfT0JmMkqJIBlKZw5V/D8OL+6/D5YtFzQWKYvRuRY+N4BuxWKJclP0SBFbDtqo3p/
	heTE2DEC8Vr/aEJDNz1G5910oxvQRgy5d5/H41yDz+tfP0uPctKpcKJu5BvaA16NX+pu6b
	Lbr2tvkx6EV0nKE7Uc8m8C3YU96OM+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484109; a=rsa-sha256;
	cv=none;
	b=NSsnjiCXEOA4kLqeb1UjkUjasUISjGupMH6HbEdqa5Ath/53mCFnyOFBOIPNjLbgOm/bnK
	bZ1ENV92kk9+p1B43wSpqfC9NKrdzXwTcsJKFbZ9fgEdkwSN/Fto236UNX9+98erLc6Yqc
	UXPxkhYvfN3cQZxaI76xu2XFJORa/gw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dm0Uzzdm;
	spf=pass (imf27.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772484106; x=1804020106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yvpNHRlUYodbfv46UlMBTxoh/VbFZYZZY1cGyb/DuEc=;
  b=dm0UzzdmTBTi3vzYMs8FLi6hzFKet5IGN8ENNGfGgNqB992jiOUmijkk
   Nq8R84VEQjHS3m/8x6Rcrvo9yTVZE019ud+KvTsuX/AUZ1wM+VAz9y6PV
   NrDmuopVHDFjvI0gIVvTKEsaM2sXGScibDGfR6p03LPftw+H3ZPZdFU4o
   un6JIwAgWvlVN7ktCk2schFQqAO/Y6WS1nHjbBaFGxI6OvdEGI6jPGUgd
   8rNZ0Mxhxg2KtP/2QR61GvHtpF+QmqNgBCBTQKANTls/hwtzbAVIOzvw+
   n7ziQUHB+AaL3raTG+PSAPwWKr3l9uaFW9qxycszQBqmsEj7/bA9HGvy5
   w==;
X-CSE-ConnectionGUID: kZ+nRXjZTuK9QiGuGMc4/w==
X-CSE-MsgGUID: aA0gQcMzSW2IG+AgHnyxGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="77117892"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="77117892"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:41:45 -0800
X-CSE-ConnectionGUID: WbD1REStTuCT62IY9+nDDw==
X-CSE-MsgGUID: SVumj7vnTv+se+DQkecwEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="221930032"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:41:44 -0800
Date: Mon, 2 Mar 2026 12:41:43 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aaX2B9Efh0dBed6c@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
X-Stat-Signature: s369c7rgq35ou7a6c8j64mo5knkpaspf
X-Rspam-User: 
X-Rspamd-Queue-Id: 06A874000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772484105-241035
X-HE-Meta: U2FsdGVkX1/dOS/0W3K9ABkaSuzdtcuS+cSvctWzMjEpZl6aLzK+l0K68DRRy3VE/O0K0fwC6Z3lYpXZ+OIr4+6HnM6vfu6tsdbf+RcC6dJM1wbkU43UvClEOBE425PMtr0aFQZFc8HjgIoNr7HnXqKX1DviIVNnNehNKBrhlvsvgYSNJbVRPUsEcUsE1zglLbJwCSexCq8rUxCYGKZytQqXO47DFAEXUwlZORW2QIKZaO+NscWY9GIQv9YZ2t4bv22GLxTieP3ufTkg+AX4dzQgdITTokcxGdO/cvZNG2iqXC9Ak6lmLnbaU5n9hxJ2v0WeBocyzgpiBfKgrOeAt0DkSjhclhNqWBvRudnzTrnxoHnP1u1XyfuilY2WTRCvYkQyBtxoq479tnknf5ZkRSsrSVBLhLJT7i/uuAM5fKEPIhWFVYJMo/H2KLgNiXc4kqwrYqkeMIVuTgB6B5YTv/kqMHnfiLJdARnQHWgWNeOhosxIUG42A+T4E3IVyy1auuC15his2cjZ6Ah96N0pZh0PedAtGbKYi3Wy/G3U9cKH60XZCnsL9C9A2Fhro7U2sfDVSwqJVPZuSiERXE+nmD8J1XGsI1r4j4od9jlIukH0x86Z+6nMfpSSy1DgR0UA5xlmFJjrO2DVcPj4QxWnL7MvSN0+p7WIK7B7sBsyZOHQYmZ2/iTMTXRxTyXvvGZLK50ohr30sVm60o0y/LJkGbH5k6spuq6S0by8aw9mkMlwl3DFld+sL6zv1/2cjbsntfLHN/hmF/RJ+OIjHkrb2n29DNMqXcmoqUe8ap5YWz36m2G3cO0NvJ62avTCtzuIYAktlMYfvE72bVdzguwwKPD6uJs7NYfj89dpg+R1K7Eo1GItXb+Cnb+miDGs0jztrH9trUPdON3IVEfAyagaSTuHIcQlE3PParpC3vBvVWQdQ6/E5vNfjxkpI9IWVzQFjIrYLp67n0a4wX8+Zjq
 Q18n0XMk
 0KS0syS2C7loj9wvCYo11aWGCTF+aADa0rBdTVqA0VaqRzjtXv04hPYhwOFC85EyWCMSfdY7A9ruXCKiqyqG1wLdXKBpOcPBo9j3c4MH+0wB/LRKptSlmX9RjkhBpP8k1EiGeaDJ8YNCN0gX+n+C6ycQss1jsjBsmZSWgqXdq3918+jWd8NloE5cW+a+e7y3qLBRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Especially after reading 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c I
> ended up with he following conclusion:
> 
> "KernelPageSize" tells you in which granularity we can mmap()/munmap()
> etc. Simple.
> 
> "MMUPageSize" tells us how this granularity is implemented (or emulated)
> under the hood.
> 
> The case we care about is when MMUPageSize < KernelPageSize. A process
> might have to know that detail even when nothing is currently/yet
> faulted in.
> 
> Assume a process would perform an atomic that would cross MMUPageSize,
> but not KernelPageSize. Depending on the architecture, atomics would not
> work as expected in that case.

I thought most architectures don't support atomics crossing pages
anyways. x86 supports it, but it's discouraged.

> 
> I'd expect other cases where an architecture might have to care about
> the actual, smallest possible MMUPageSize it might be executed on while
> running the program.

That's fine, they can use the min, or just the first match
(which is always the smallest)

> 
> It's a shame we had to add MMUPageSize, but maybe it might resurface if
> we ever support emulating 64K/16K user pagesizes on 4K MMUs.

Okay, so if I follow that correctly you're suggesting 
to change KernelPageSize, not MMUPageSize. I can do that change.

> Adding more confusion with this MMUPageSize extension is not an option.
> We should likely clarify what MMUPageSize really means.

That would be an orthogonal documentation patch.


Thanks,
-Andi

