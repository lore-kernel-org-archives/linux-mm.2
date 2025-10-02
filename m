Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84178CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73928E0002; Thu,  2 Oct 2025 13:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B158E0001; Thu,  2 Oct 2025 13:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60DC8E0002; Thu,  2 Oct 2025 13:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A27C58E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:01:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 368F0160569
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:01:52 +0000 (UTC)
X-FDA: 83953791264.21.4E9EFA2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FD56100006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:01:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FgKAeZ3R;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759424510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iuIUC+VY1GMv4SLL7Y28QqMS321wqy+40IWyKeOZfeM=;
	b=hBPvHtNTahkq4begIjzdpGN9aL+d9wq8NnJRrbIGaa6/Mhh+zN4Hn8aDolSTYsabdSh3T+
	PqweJpspKOOfKMVyjLVR0vMvC42GCUiy+fdOiKNf3AeWwzG2B1OrLuacHxQ5gvFKHSfpcA
	9CwDpLmxPKr1+53UjFU6vZxnis4iBbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759424510; a=rsa-sha256;
	cv=none;
	b=ti7xh21L1DFI0y8+N8TDPBdnf/pStMRX+ifjvlQvesXmQfpqW8o1/oPO/R/NIMPrIjCdXo
	OtUPv1Z5nYXecBNf9NIRLYoYbSS1SprIC8Ytt/w1aDy2FrgoQmMRoVTOOU3ILxSJbMXDl6
	QDKevYqf0sum7Uua1xWt3kd4AH613jI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FgKAeZ3R;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759424510; x=1790960510;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EG3tAjYWJ38iOOYRzre7Myv72iJJkZHas6whYQSUN2E=;
  b=FgKAeZ3R/yMqLUWDSAJxX0OL0i6kWBF8CUz1qaMF/nNKb6zPYbZ64AK9
   zVPABFOagSjgzerj/zaYYc5qpLTjog5fXWmJRovytbwEGLXk4wE6KQz8T
   e90y+g0A+KtYApzTkAgrYmx3pU/BZP1ovoIZE2pfMSFfJJYiScBwmuqxw
   DVopC/DTJe7HLU9XGjKIgJjbH3RTjjoMo9JvyYVl1ERqVxh0OS5F/ltKk
   HeXUs5j8wP4BkXlOoNJeA7zbEFX5yWLyTS+7TP2y7nebsQ3IVPRRLcrdG
   OtFyyU+XnZuALGRT74DPLa3YSgccIevI3c9Ezj82D41maLugggMpPVLBT
   g==;
X-CSE-ConnectionGUID: Fv4dpuppTqaMOodUA3Kqyw==
X-CSE-MsgGUID: u4Gpfd+/RQyglrc3S4h9Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65538975"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65538975"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:01:49 -0700
X-CSE-ConnectionGUID: TCJZkbNMRPuIM9rdVvt0jA==
X-CSE-MsgGUID: iRKvdYBnQFOB/Gf81gnSLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="178720624"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.249]) ([10.125.109.249])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:01:45 -0700
Message-ID: <6a97031d-33d4-4710-ab5a-7d8947936038@intel.com>
Date: Thu, 2 Oct 2025 10:01:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
 <DD7SQLDVNSRL.XJ8PUCH6GYR1@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <DD7SQLDVNSRL.XJ8PUCH6GYR1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9FD56100006
X-Stat-Signature: gqyxnb5anepextkfxnpqqef5tpom1sja
X-Rspam-User: 
X-HE-Tag: 1759424509-194024
X-HE-Meta: U2FsdGVkX1+TZebE6t3Yn9UyvjvGUACe325N48pR5s7L9tn6nE7pgI4NocoxaaB5v9RnxGJp/Wi3FCWv61NczxAMmJ+uIdvgd4z/TmURO0JgOS6CK6JcMwRWsC0J82OSaMoo/WuN7bgKlyfy1QIErGjeZbQre8A3Pqv6Mv6r0BP5G2HCfB8O92gygxffR075vyxj8blq0egt/gI7rQiVaXLBR32aDKxODZwyp1vI/bMOxQmGf3ARAeOIPQvGNEZWhDrGUMCeISshoaz+P2wvB+uV9oN6R7CxK8ANR9N2i+Owb+FIfMxCcKfGia1cT/+dy2gw1iUU7KSbsv7YaLsaTHBtGI9THuec5PzOPJbpwG9/SI4slDZnQGWHc7pmD37osWxgeMPkqNCCUJZO4yK57R1KS9X5PqxK8lo8Fuuppg5HZC7AJeNZtq8EwQVpU/Ac9QU7p+oTogZmGw9LzbjP5gf2fvhxSzBbC/jqaNKzlEKfOBe8zTyzYoSDoOKyEdF/dl9OtTN705Rv5/JExmY22PefSDl7FXwhONdDcMLalh77ycOrAyLslCf/YV687CZguluy7ndQWChAs7RHPvBB/VvsbAD9s1wU2NGnMfL6K05NS8M4Ya51alXcB+PHHzT9zWU4Yl97g4nI2kSaQiarE5ZFOdwkSfCQHZMoC95OhfRAUVZKo0htGuvg22NR/EgGX92NHjh4/Piuv3dw7RCbauczXXAK0UcRTBMDA9kARt0EupIdHBa2/+WNkEVpm1OKq1EstEnh0/0twACi0CgrKAAFrfwF5bDo6f9kIJ//1T7vQnnJF7FCU1+UbsmH4HSJKj71YxTqKRAXcz4Xg8e0o0DJblE5bZWZyWOZp23eMQTu/0YlpRjSi/sDTA/6E2Le
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 04:23, Brendan Jackman wrote:
...
> [Well, I'm assuming there that we include the actual security flushes in
> series 2, maybe that would be more like "2b"...]
> 
> To get to the more interesting cases where it's faster than the current
> default, I think is not that far away for KVM usecases. I think the
> branch I posted in my [Discuss] thread[0] gets competitive with existing
> KVM usecases well before it devolves into the really hacky prototype
> stuff.
> 
> To get to the actual goal, where ASI can become the global default (i.e.
> it's still fast when you sandbox native tasks as well as KVM guests), is
> further since we need to figure out the details on something like what I
> called the "ephmap" in [0].
> 
> There are competing tensions here - we would prefer not to merge code
> that "doesn't do anything", but on the other hand I don't think anyone
> wants to find themselves receiving [PATCH v34 19/40] next July... so
> I've tried to strike a balance here. Something like:
> 
> 1. Develop a consensus that "we probably want ASI and it's worth trying"
> 
> 2. Start working towards it in-tree, by breaking it down into smaller
>    chunks.

Just to be clear: we don't merge code that doesn't do anything
functional. The bar for inclusion is that it has to do something
practical and useful for end users. It can't be purely infrastructure or
preparatory.

Protection keys is a good example. It was a big, gnarly series that
could be roughly divided into two pieces: one that did all the page
table gunk, and all the new ABI bits around exposing pkeys to apps. But
we found a way to do all the page table gunk with no new ABI and that
also gave security folks something they wanted: execute_only_pkey().

So we merged all the page table and internal gunk first, and then the
new ABI a release or two later.

But the important part was that it had _some_ functionality from day one
when it was merged. It wasn't purely infrastructure.

> Do you think it would help if I started also maintaining an asi-next
> branch with the next few things all queued up and benchmarked, so we can
> get a look at the "goal state" while also keeping an eye on the here and
> now? Or do you have other suggestions for the strategy here?

Yes, I think that would be useful.

For instance, imagine you'd had that series sitting around:
6.16-asi-next. Then, all of a sudden you see the vmscape series[1] show
up. Ideally, you'd take your 6.16-asi-next branch and show us how much
simpler and faster it is to mitigate vmscape with ASI instead of the
IBPB silliness that we ended up with.

Basically, use your asi-next branch to bludgeon us each time we _should_
have been using it.

It's also not too late. You could still go back and do that analysis for
vmscape. It's fresh enough in our minds to matter.

1.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=223ba8ee0a3986718c874b66ed24e7f87f6b8124

