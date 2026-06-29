Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D4BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0F66B00E8; Mon, 29 Jun 2026 17:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A18D6B0102; Mon, 29 Jun 2026 17:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B5B6B0104; Mon, 29 Jun 2026 17:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17C4B6B00E8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:13:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8356A1A0233
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:13:43 +0000 (UTC)
X-FDA: 84934201926.09.0654DF2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9AA6640008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:13:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H+P3bqtL;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782767621;
	b=mNprYjcmXp1c55/1VEVLUCwzAQfRORX60mJ1HILpB8TpRq2ajcCR8o0+kX7HipOv9mOcAK
	QiU0ikxiLj7wivJElht15Yz5T5WDbdpQBkRJjz/MWO39a+Fdkq6tuRHUWB+kkE+5lEgOm1
	NfTKEMOdGcRQwhr5V1KZStnJtPExsng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782767621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPJFuUWcQU+d5f+V6qfDM06QyeBYW7nykg1Ux27D4pU=;
	b=YQjZXdPjo4YsFk4W8ko89qLGQVUn7kr3Jk4zHsYX7EzGWau4L9+YY/Xgq+B95Ujwt5Fpct
	1m9R0MFJt0caTBPg2GXAlAK2GM1ZoofMzvzF/PPxnHlg5RtiSSaWNzSZOMkCZ/2ja+loiA
	LD74d/M7b19xUUXbifMDdzIpODDZrKY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H+P3bqtL;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782767621; x=1814303621;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=YPJFuUWcQU+d5f+V6qfDM06QyeBYW7nykg1Ux27D4pU=;
  b=H+P3bqtLEVuAFJJ2fh8n7/m6K/drsa2S/e5yD4a8iM1OYGETN1bx9Kwa
   ygXvoT/KC8X6nNdeuimYSJ4gXcSCZ6zPdfFJurR9X1CXwe/V+ddgCZaI6
   Ddiy1wzJjiix5/vdXLpVk90sb7C5N0iLe8WVv5FI0RuoE5EktE4Px2ZCD
   PW59PUt8qyfe+cG0GY7YiJglg/mv7VgWphr313z5Y0VSzPBQ7xp6rWm39
   ktJu6s89RzHVXnLR3WSQbh0NdETbUW17B8016d0DBEeNrvazaexnXrhgK
   /xAJB3hPHGYWGOF3XEz+8BGIzf0+6YyJC8lcUF48uMzb1xPDeHeblIJOG
   A==;
X-CSE-ConnectionGUID: PgfqneTCTgSSEgj9ORiFrA==
X-CSE-MsgGUID: u1yZyZRMS+ernVbDOGNqNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="82584202"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="82584202"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 14:13:39 -0700
X-CSE-ConnectionGUID: 0IC43yllRgKo6xmh7RFkWw==
X-CSE-MsgGUID: W8O0GIBAQfadXe8sonNMvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="253982300"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 14:13:38 -0700
Message-ID: <3bfc80ef-bea3-4f76-b20d-de2fdb008667@intel.com>
Date: Mon, 29 Jun 2026 14:13:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Zach O'Keefe <zokeefe@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
 <akLS44JGF59hh6aN@casper.infradead.org>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <akLS44JGF59hh6aN@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9AA6640008
X-Rspam-User: 
X-Stat-Signature: 8es6919z75ogm96rc4hr985z58ynggfa
X-HE-Tag: 1782767620-184651
X-HE-Meta: U2FsdGVkX1+mru4rGtvU276a4zX2lZynqbYVfzxt/Xw9yzqKJ/gHsYF+j0iMF7msRQnxvVZENWXPrMHMaIh+UF1AypL+ppaKdkUa2wBt9ZlBg3lwHF3YXJexwwkdnT36AUvw6XrL/5rcjxgx8hhdO0l1q4yU7kAVpVPjzQBJZ6yjlS1X8EaVeQjjnZKuhDWsP+pcxuewplMmTo0IFU0/OZjuyKtukM97Y4S6w/6kNYa6hFisuhaP3p+cKhsQMvXAu0WDEedtnJTMH8QR6Txdhq1noALiUOLQKMOYQrM+dm4U4/1X8kI/g7aPOt8UfYiLgKF0xHSZVQR5W9PA6ntMFy6qETO6dBcNArB2NnqrCjZiZJdqtzpYCT1TYVdymx4EPHr8SfVa/YzWq7ONYg0XsCikgCoUdauqWHKT92Ux3bopAPNKUSP2G91a80yjwwS0woWWWhDp4oDDBQxNjkbFBh4GWevOEGBy7t1xBbo8zFf8Sd2eiFKN8Uy0/31GKHcIajfBkBWr7wveSAAGKIjBNjc0wdnzdRlMwfLQ5eFTb4YN6zY33fGcWgm1XF4Zzb1RuL+VFg0lCczR6MVDKIjlQhBxYx3FDdqiV3LuG6Pd68BHkliFR9/b7LyNG83lNCXhh7C9X7QCNl9FEjQls3NCOm+lBA+Ar4zSU0+WpHX6b2HiGo+nWDr4JQE3X7kHYry5MRNlTX/mH95V62oS4jOt5Y7B2mgRmLOCaX6CkDCycX9TUpzpzSD7ZCGvTdSsVJABSQdrMCCuWJj82JD4pkRrwGmaI0VCu4qngx7uRjozOKSZhkuvn82iACf0LpKiBczUOhKrKHpScjATkA5PMLo7oU9I0zSyyeNnDDmR1V1ZgBEmeJNDyFW7+uGhr/UzAbZX7x5aDurWl5dQhf/LY9greeuOXShKAn4eSat4JGR5U0KgOzBfPntefmgDFVAqRaq5UZT1N14svu3QB0GbEQW
 QbAhKNjK
 LlkGOD2xq70B4ME6/BlrVquRJa5nNyQPInS8lz/bY+93BAyIfjY3IigVXORB7V5GrRku/ytq7pbPeFhtzC5llfhXseVXiCwReBXJkFMbWypDcSffBxEgTFDptwZfXbe7pPszNK+qPS5UCaYk4jZTu94f68oK9Zb/8JxAF+ts6neTsLnZEOMXA7N27Qhe1fem7a8BKUwLjkCoOYfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 13:17, Matthew Wilcox wrote:
> On Mon, Jun 29, 2026 at 09:02:08AM -0700, Dave Hansen wrote:
>> It could be done with really little overhead if the vmalloc()'d stacks
>> set Accessed=0 on their PTEs and then checked them near vfree(). The
>> PTEs are already getting touched there, so the cachelines should be hot
>> anyway.
>>
>> The granularity would only be 4k, but it would be so cheap that we could
>> turn it on universally. It would also be 100% deterministic.
>>
>> There are, of course, more games that could be played with stack depth
>> checks on normal interrupts or NMIs. But those would be less deterministic.
> I mean, if we just memset64() the whole stack to 0x535441434b544f50 and
> then searched the stack for the lowest word that wasn't that value at
> process exit, we'd get a much more granular idea with vanishingly few
> false positives.

What I was going for was some first pass check that would be so
ridiculously cheap that it could be turned on everywhere. Those 4 PTEs
are going to be touched in the exit code path anyway, so there's not
even any additional cache impact.

But, yeah, if it needed to be more more fine-grained than pages, what
you describe could 100% be done. But, at the cost of pulling in more
cachelines. It's similar to what Vlastimil was pointing out: there's a
lot of good info in the bottom of the stack long after it was popped.
There is fine-graned usage data and probably some stack frame remnants
that could point the finger at what code is to blame.

