Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95DECDB466
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 23:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330F76B0005; Sat, 20 Jun 2026 19:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0236B008A; Sat, 20 Jun 2026 19:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7A66B008C; Sat, 20 Jun 2026 19:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAACF6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:22:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BA28A01FB
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:22:15 +0000 (UTC)
X-FDA: 84901866630.19.6C0EDB9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 123A940005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:22:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Liv3WiJJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781997733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ0mr+rFQvJKpeRxvX78/JFB2wfZAT1XsONvn3adIec=;
	b=hZY08sGfKmi/Vfm9RfDHnj8pUJiaPFoQXPuzI031zKDYvYEGsjR9q2K+yp1yI+vIaYg+KC
	XNmzk33Rxbg6GmANQ8CptyRDzeV3r+REAtiB/JZYjXt1TCXlY68zjqXhD1VbYsNM2n5dws
	Ani1nuwPri5Kg1B5U+1X/VZX2xUXDVE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Liv3WiJJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781997733;
	b=I8kQz87X/0sSC6oE3FczOmGoFL5d4jHe01e1xkoNUifwGbrOUeFRWE8XGw5suRqpqkljhg
	/ptjxzAKEiMfIOYWlvOIdRJB8cFrDDb4YfWIflU1Gn78aDIzM40RT809sA14SgZ3/p8hQT
	WBrtu0UVECh+2cEQGha/4xWJNH893O0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781997732; x=1813533732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UBQiCIS4KzF11WJXpYS8kxFeC1ovqtTd4EQUa5c3Ti0=;
  b=Liv3WiJJKRPLZmtcqiluCcTGmv7JSUBJ99/MROLymBZZqtp75U2Xuled
   buvSH2NlzeOu1XHsmywFYwj1NSLXG0YN/LEaiFy0DbC9CYzhs+mk1tKSm
   0K1N8W/nWmbHJ4x9w4/VA9wTlVT/ueDygVbe0LPZtMeLxhlrzZD5DApN6
   s8/1/4sSTZiWYJ0gZzWBG95Q0+XLNBb3L7A7a9LvvWNrsCbSvd5X0Z89+
   sUEhHVp4o2snnu/gZCQHiFV7yluG0xHXCVWDJ0RSOHWd2ZCJLbL0Fj2ze
   Su4oUB4t15aL3nhCbGdnI42HFDPuahM3SYYZz76Zj6sISUOEk7rtoaJvN
   w==;
X-CSE-ConnectionGUID: UCDOmRaKSF+15q723vSAeA==
X-CSE-MsgGUID: yetYefVDRL2SjVjI7eHQaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11823"; a="93895008"
X-IronPort-AV: E=Sophos;i="6.24,216,1774335600"; 
   d="scan'208";a="93895008"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2026 16:22:10 -0700
X-CSE-ConnectionGUID: z45jdFzCQfmBV1vJGU5lCg==
X-CSE-MsgGUID: Dd04u8/KSZC3AypRa+4J2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,216,1774335600"; 
   d="scan'208";a="272589504"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.108.51]) ([10.125.108.51])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2026 16:22:09 -0700
Message-ID: <ecd980ee-bba6-4183-94fa-ae4cee630841@intel.com>
Date: Sat, 20 Jun 2026 16:22:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: David Stevens <stevensd@google.com>
Cc: David Laight <david.laight.linux@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com> <aevhw9xqz1pWA2Ow@plex>
 <20260424232637.054f15dd@pumpkin>
 <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
 <CAOiLmNE8okatb6RSonemyMT+BGVGg2h3=i_Epg5zppfp1Ks54g@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAOiLmNE8okatb6RSonemyMT+BGVGg2h3=i_Epg5zppfp1Ks54g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 123A940005
X-Stat-Signature: ippij4nese57pbrfwzh3neu9933mc5h3
X-Rspam-User: 
X-HE-Tag: 1781997731-829020
X-HE-Meta: U2FsdGVkX1+WSBANdXBYSp5TBDoEz3VJZ6iSU8dxUIi850wRO8v5H9aozn5vwpR5MjqIGYCUPLIao1hPyXic8ywmGjPD2a5SP7QsswrvKFf8L97IYSHeQqMkTJ30n3Qd6uTbHqf1cSJGq0jyA1VtCafLb9pzgSBBJ3b/rjEgvU4e5ox2JCZmbi1MyNijRIzVjFjVzEBqtLergC6zXb5bsUdA/y34aN4qV6Mbn5a4P7qNnWsZs+1W0VVzTSfo7/moguz4GImZkUbIcYmJM0jh6mgpBmN4NRRO0qvUb0W8F8GhwNNXjUhfY4HSEmmzfhBmA8iN567SrQRJ41CwyLyYNtmCJ+vCGOpZ2cW11fS1BsEAo9IuvDR9mOOfEpf7no3ddl85soI9tVGzFHSgL62gIVGKrXqQgs6j7epswQaHu9rPdjZmf6Ob61GmgINAFXcU+WOUbZi2MK/qS9dpPHx0nIME+ZqeuUPgQYz0I1ssdM/Hk4XyQ8mnvlPCHBTUTXL7dWkEeitXk6hVZ/zPWj5EDKvYSRsS8PBR69Th7ch4cggPfnelrzMUNY1I/W0A3Fh/qgCnU5Me/HJ+RnfA5ASPOZ9UIr8Qy0+xIuJRf9mbhWdqq7SnNr/woIdLDy7ofMf5o/stlzon604HzBUUMvpi7ICdpmcg91nvXSV5CbOpTQI8AA9oG1nD22NJISS33PQakb4D82npN8ma1S5PcrwbojfiayzBFfEoocjNADILPZHLoKWE6GZ2ya+iWColM4CbbQlPzNFzDwvX5Nk6smT89BF5yJ1f8EebCz6KZsoWNFivDgQJkN/rn+QiEXWtJzOb8rtdpNZ+XRyVf76G7JBYh3lLHH/SF4le+wh9UAG/d1w5JvM2BbwSxyFYK2m094CVgBd5xbAcIeDVXeJHi0qfIX2XHPGcLoPozI1v7oHxc93pLNktZYW/sM0NDv8hAjvwmOzXwIJmmAeDG1O9Uj2
 mdThWPGC
 IpG36LEe9/tzg84OL+qQ4WHY4gtySSqszF0vFPddVWB6GF/nokhvgUjj8Iaa6CsHtylyrMPcIPeZ3KwQol8uO1nETvy76mCyDhXoNlkBiUkDy9JuZTTm4vKTSUwxBa/my1GRSXBAqCJU21pYLIKoOR6sh0R37lVZQo5rRqEbGaV81iXT3yTg/ROK3eGBPD2Up618JS7kaxPIL0zjRo1Z90HWfjhmENRzKVOgnjI1Dr/KSX7/kwUTpu8NGKynBFdcfOjCAaDkLLmZSnlp38z5Q298H7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 22:25, David Stevens wrote:
>> Needing memory in the middle of schedule() is generally a no-go. But its
>> a lot better than not being able to continue _execution_ of a kernel
>> thread at *ALL*, possibly in a non-preemptible context, like when you do
>> it in a #PF.
> I don't think this is different from the current proposal from a
> memory allocation standpoint. Both proposals effectively maintain a
> pool of preallocated pages used to fill the current thread's stack.
> They vary substantially in when the pages are put into the page
> tables, but both need to allocate during schedule().

I think you're saying: "Dave, you didn't solve all of our problems for
us." I'd definitely agree. ;)

I thought I wrote it somewhere, but I either deleted it or it got
ignored. I'll repeat: this PoC series has two big, big sticking points:

 1. It requires allocation in very sticky contexts. It's theoretically
    any code that pushes on the stack. That's a *LOT* of the kernel.
    An allocation failure pretty much means the CPU thread is stuck.
 2. Because those pushes happen almost anywhere, a #PF can happen almost
    anywhere, which widens the places #PF needs to be handled. Thus, the
    angst from the x86 maintainers.

I think I've at least hand-waved a potential path to getting rid of
sticking point #2 in its entirety, and reducing the x86 maintainer angst.

My hand waving also reduces the scope of #1. It removes the need to
allocate memory in some crazy interrupt-disabled region in the I/O
driver interrupt handler holding a bunch of locks when a #MC happens
during an NMI while kswapd was running.

So, yeah "both need to allocate during schedule()" is factually correct.
But this PoC needs to allocate successfully *EVERYWHERE*. Virtually all
kernel code paths, modulo some very very special areas.

Are you saying that as an engineering principle you see needing to
guarantee allocation success of 12k at "virtually all kernel code paths"
and "schedule()" as equivalent barriers to solving the problem at hand
because they're both non-zero in size?

I suspect not. But it's kinda coming off that way. A bit of coaching for
dealing with grumpy time-constrained maintainers: if they take their
time to help you solve their problem, don't spend undue effort pointing
out the engineering compromises in their proposals. Take more time to
consider the engineering tradeoffs as opposed to simply arguing a lack
of utter perfection.

But, really, my big takeaway from this thread is that the folks pushing
dynamic kernel stacks have a very limited understanding of upstream or
what its priorities are. Probably the single biggest obstacle here is
going to be proving to the long-term maintainers that this isn't another
dump and run operation. I suspect the x86 folks are going to be a bit
more amenable in that territory than our mm friends. <cough>MGLRU<cough>

Either way, welcome to the party! If you want to come help upstream,
there are always patches to review and always bugs to fix.

