Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E19CD98F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92456B0088; Thu, 18 Jun 2026 20:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A906B008A; Thu, 18 Jun 2026 20:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58D46B008C; Thu, 18 Jun 2026 20:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 834156B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:29:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8A181202A9
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:29:10 +0000 (UTC)
X-FDA: 84894777660.14.7BAC8D0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id ECA8A8000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:29:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lemM2EO6;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781828948;
	b=SRQnTVD0pB1qW1G8JUiWO7e3GPg0MAcg+Gb6Fl0EMqYaA6S4AkphfWtTFsBHqPp31uocj0
	M2iDwBbMCnQfdiJnGBqQJ7wcTAm9MdJKP5aw9D8IMUu32javdob3HsWTJvO6qIrSTWKIzm
	X70XOk8X5gtIDQ8DOKFIE8h397cseOQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lemM2EO6;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781828948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puDoKY+8+N13eU7C1V6mGYJRrru4uWCoOX04G9eWlvE=;
	b=APCyQfblXVKr2sq5RYg6Q8/hRW9v5w31GuQbRkT+ZMqPGIEBdIR8UlblsQvye+LeA35/Jw
	n7mfN6HclF/7scsaFTTw6cjaf56k8RgqSZyNOy4ENfTrz5aedv6LjVYGNhL9m24FPg7R1u
	OpPy7b1QhBSaiJTBYfVW+FZ9YsFfuG8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781828948; x=1813364948;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=WPmSPul8vCxi2V5AhWvJO1ewlmEn7LMsWjJ8y9duDmI=;
  b=lemM2EO6+wr7FKMbXCbFR4VlAo56rRD9E+Tu27CrhLZ11ur/ExWRn51E
   wQmSIqISZ5QKORrwLgygjwZSbzl9Huy4IHM0RIfydciml5JtOjgRHaJ27
   U2Yj4LkZNM8dvHDv83+uQY1/Q/yjQcW56a8HB5bvMDN5oNdhhDQ95L5M2
   qeQNr9ZWP+PThJQa8IjV73aeS52wcJgaC1G5XU6u4UBX3uc7SD6n4Sw7b
   okvdDYqp9pRqV3p5Z3jLQtaKq9VhBfCoLBgb4IngZLjm07TVKdVmSvyyA
   eGmrs7cliLwzwpKZnK7nyyLa37/rI6kSweMsHFt+yPBzjn0jE+W01e8dB
   Q==;
X-CSE-ConnectionGUID: PrErOsPyROWKOcYZ8Zsv2g==
X-CSE-MsgGUID: MZb0mbMfS4CSNWjZ6N4xfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="82458663"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="82458663"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 17:29:07 -0700
X-CSE-ConnectionGUID: Tktuk9LrStCg2JOj3fC/rQ==
X-CSE-MsgGUID: dN2KD4aVRQKuxH2QPkka4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="252828741"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.222]) ([10.125.111.222])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 17:29:06 -0700
Message-ID: <85f19b94-18c6-471d-88f5-c05a2f10199b@intel.com>
Date: Thu, 18 Jun 2026 17:29:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: David Laight <david.laight.linux@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Stevens <stevensd@google.com>,
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
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260424232637.054f15dd@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jomnqj9jrj36fsbataehyg4k6ob9c58b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ECA8A8000A
X-HE-Tag: 1781828947-703979
X-HE-Meta: U2FsdGVkX19HCc+p9cMnkGlJU690hRLgMRAi0YhDeBmb3u9qEg9Egf3SOGOsJKO8F/NiaXG6AyvrqzQ5FZTYe+YkXUHir0ia+Jfwmu71bV1nh3GeUYn/VOdNhoH/U9OnBOC8jnfP1zxyxN8unSF8gtKFODYc5X0LWHrGzbxYkfM4Dg5ARPZfYc3LoRVCAgsnOgrf87UrXcETeiDwzcIshEI9L3b3ojSWeu+Hy4OZ5xqSV1SFyPt5TS7buZ10VD2WICd0oagIDKOH3p5R9T/9yK+NXn90egWc9+CPysSk6F41zcXBCvPxTC43IjjpgJm3L2iowFMA8dBB0R1xDVcdiSLx0JhdAQnqumPDPYFgZcXO2jNOcKReNdM4oIGSuon0JaMzH7266kQzjzNyk34jZw/sQfBeK41JFVIbFoQy9dPVgQkGk9jyEmbC1HztYRyqbWADIj9CtXZY40oCozXdx6y57IzsFUZ44zY3W01uB4Ea8/iBi1GW9LHnIRZn4Kdz+B9Vv40t73XKnouJ3GUFnbZy+mJg8YdJ09P3Ve9wodgNlPcMGBbkIGoOQ+1vSkU+UiPVrdb2P9Dok4McaboP1H9+18J+gt1Ke7S3Weiy+7gVWFoUSfi61ncfq2Exi4yXRamF6SMr990LBBcpMCZZUcKc/85rH3fciutWZdiR0mSDkYrSiu/83mlmgxqfY74VFlrQDH/JL2Dj7wK5/qRuGaSja81WtgsIcl3+UwXAODzWMnY0J5JJFIVXALelLafiCPp2ughQbRBXH5Oe4rlyWocJg45CjWkbzrijfFraHDe3kO6AtMOKzs631K+9TxlKUVt1GQbN4un2+diBlqvutUz6yfo2K1qHVud63HIm3PTsOgdGpV70pQjU668T1cz3A6AojiDRjY3ktKO8X+aST4CMTN87DQ7NBKMXw5Wrk0oosFHGJilg2Ke2MlDXDTNZbF+BOivhyUKWju/9cXI
 5IFzlmpI
 uokydfKE41zINesFf4UZAHWR/49ALW3sgZjzDIhboDYOwZJd7ypClY6a+ji5JM1P/f9H5NfWGrI9+5Jcnx2rrY5EeAhxjKoQDurYquMbKrIvI2h8pPbLxn9+pHLsukLQzqKp5xIMLVKLln8z3ujY6W/+3FLPrWJ92ZG9e4TH22flJz//Q0zetFvRSM/ol2WBvu8COCCz9Uln7708r6vGAAjwrcc/jl2DE/Tk9NFlsYXe1fOeO2aTzo/kiCiInZHeqzL8XGi/gnpXRBPk2V2gz0E+JDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 15:26, David Laight wrote:
>> This true until, in a fleet of millions of machines, you encounter a 
>> one-in-a-billion chance of a stack overflow. You are then forced to 
>> double the statically allocated kernel stacks on every machine, paying a 
>> memory tax even though 99.999..% of threads never exceed 4K. This 
>> overhead accumulates to petabytes of wasted capacity.
> And then you hit a stack fault in some path where you can't sleep and
> there isn't any available kernel memory.
> 
> An alternative idea is to arrange for some system calls to sleep in
> userspace, so when the thread is woken it re-executes the system call.
> It then makes sense to assign the kernel stack to the process when
> it enters the kernel.

There are probably other ways to do this without handling exceptions.

For instance, let's say you always *map* 16k of stack for each process.
But, after context switching out, you take a look at 4x8b pte_t's that
were mapping the kernel stack. If the _PAGE_ACCESSED bit is clear, you
can just clear _PAGE_PRESENT and reclaim the page.

If you don't want the overhead in the normal context switch path, you
reclaim in a shrinker, at the cost of needing locking to coordinate with
the scheduler.

A simple rule would be: a thread that ever accesses a page gets to keep
it forever. They're never reclaimed after being accessed, only before.

For that, the worst case is that you go to schedule a new thread and
can't allocate memory fill in the 4 pte_t's. You can't run it until you
or some other CPU goes and does some reclaim.

Needing memory in the middle of schedule() is generally a no-go. But its
a lot better than not being able to continue _execution_ of a kernel
thread at *ALL*, possibly in a non-preemptible context, like when you do
it in a #PF.

Basically, I think there's a way to do this that limits the kernel blast
radius to _mostly_ being a core mm problem.

What else has been considered before the #PF-based mechanism?

