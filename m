Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC2AC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 02:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D0E6B007B; Sun,  9 Aug 2026 22:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DC16B008A; Sun,  9 Aug 2026 22:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452F76B008C; Sun,  9 Aug 2026 22:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 167766B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:58:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B2CF16062C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:58:45 +0000 (UTC)
X-FDA: 85083852210.13.5B46803
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F0B9120002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:58:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B9mm7QNK;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786330723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXCqoFJf3vzt1oImCMxR6zmmit+AxyUiAUJr9XJhOUs=;
	b=Nw+Zg1kMzBY+bLO24DGG42i7OiFO03jk1Q14h5vwS/H4anOFA2redgzsRFb/CAJ6Mkz9cA
	HZOpQfen741I7ybMtwQUx6oEK2fI0u8lzxqPHkkzs9LLRBcYThD1P6v8PTEuTcEVCt5UWh
	42do2LJaPKHTe2N2bXYLtnnuceVSdSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786330723;
	b=JYbtzGNtkHeuf/npSaK1pZ2CrLSqtp/ZAVNat0bA+jV13uywDXdTlHt6lMi8W4lQNhZ6Yi
	3MknXqVeOEPPJeSp1jRpaF3dhqyIjkGJkMT2yFisNpUvA6ll+8QrpEBM4RjfIPP2zbvzvl
	luxp7GWobFHgA/BveerU07siGx6C++g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B9mm7QNK;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786330720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXCqoFJf3vzt1oImCMxR6zmmit+AxyUiAUJr9XJhOUs=;
	b=B9mm7QNK+NF8m3aikMjvabUf1QLFVjL+JiUZe7E5cZsfAzNPm2RoIgKOzfwhVFGJrK951b
	DF7hseUMQVA+MQEfEepP/3pN9a5HrdRkoJ74CxmW/dqGcL+HN0TzhmAzHb3YgIPtnjZGNq
	MCVx4jiKDFGhtbmUZkeYcEVVDYEM/8k=
Date: Mon, 10 Aug 2026 10:58:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cui.tao@linux.dev,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1F0B9120002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hk5qtx767qafxiigf1tnjfpu8zehsh6h
X-HE-Tag: 1786330721-430987
X-HE-Meta: U2FsdGVkX19nD60160ASyudNCHYCHnEkTUfMUF0y2SQtALVrnO+p25+y7DdPJ8i6NLKOf6Zrm+ZCSYuXYkMFTz45vpZ9zxvcILig60Xta5rpT/0Q9rrK2JEwa9ZG6BuAQLnRzwycC9qwjxcgUCXTb3mwO+4Dy5UcPyGc9XoVxPtqB2R78g/WpwYt0lNP3iYjFVOsO42ACX25qmRaUaF26UJffspShn1IM6mjR1dl1/pqkUNN9OmyYmuVBeQVuw/hRTQZktBDe6AC6zOIaUdfwfFOZTbkEYSQOc5rbswjGAt51X7+0CGbjK4zSyzG99RsFnguyYNS7bkvoSUb8VVEqH0rq9haOBG1jpDlQO7duwyFaToTJlf6JE/MOZxFrkE3nwQXSeDfU/6TpwC6sZETIkqCug8l28g/VtBA5NynvAW4O6sQNUHCh1NXXEzGzC/CEmEFJe16ooBHcrpO/T2eELw6nSmZ0/WeHxPT0Cw8KN9gyoT9i6/g4SDJQqUsAeB7M8XjrPJlqWsAD3MscOQpFcvAdklKQbsjKSAig+haHFmKSxpUH+2aFxB9Oy+nUyGGVM9nOUVuUbJrWCFFeRVT0VLVS9QIjgDxiVz+5qhzvbKbriOEx7V0140AnpJGcyi4/6mPnCFB7zrr4CndJHA0lfQqm2biHHRK8UWKW/8ZnPoCs5B30pWBtI2uJijjZAtNo47S/xYs0oYThNqDJCQkEMUYliuAh6Ec/W98PzhNJpyfdej7e/Nfnd7mFI7V4+iur1Qn4wCS00/iECSIZRwdhfSqz4P2gxA+5YJ1x4wHsaOY72gmvnF+xPpZi4dAGAyyTlNJFOe9KY+YdLbLbGvK5tY354ES85tU3rJdJUlq++0mTVexiO7R2htBJdHMHGdoqFlRQVC4CCDK4FBjrvtL/hCJKuA3LkIdQYvSt5Mzb3Y8x//SrgNM6C2vvjfufn+3DaImmVpy/h70V+cV9g5
 /llJQlb9
 OAte4tvBzDCy58o/OgHK9+QnbXL6g8LFNrm6/kdFA88RXKavE93qwK6LuoJ7YY8l9aeXkCEiTtP/acsHojVWOtJ/Tapsdyx+cl92H6+4AVpE+txxozQPqMCGAqa0a058YixFZoa53km8Bd5rMGUzhy2owRVkQgv0FV6vQWEadEIrgPR9vLwwN1FutYVn+mPJTbr/QOxfPdjfK/tl3qyR/L5u8KGep8eRR/lrL20ynoR2TiyPt+p0DXmNo37ki0ta5BI3sj6mCL1odhERdqxr5LBPlkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/8/2026 4:22 AM, Andrew Morton wrote:
> On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
>> c6f53ed8f213. Each open fd reads back max(its own value, the shared
>> local_watermark), and both bugs live in that scheme.
> 
> Thanks.
> 
> We're missing the preferred description of the worst-case
> userspace-visible effects of the bug.  It appears they're quite minor
> so I'll assume this series is a post-7.2 thing.
> 

Agreed, post-7.2 is fine and neither is stable material.

Worst case for both: a reader of memory.peak (or memory.swap.peak)
gets a value lower than the true peak, so a tool that sizes or bills a
cgroup by peak usage under-reports it.

- Patch 1 (reader side, take peaks_lock in peak_show): a reader that
   races an unrelated reset briefly gets the low value. Transient.

- Patch 2 (writer side, peak_write reset): a reset on one fd stores
   the current usage into the other watchers instead of the old
   watermark, dragging every other fd's peak down.

I'll spell this out in both changelogs in v2.

> Sashiko might have found a similar race on the writer side:
> 	https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev

Yes, that's the writer side that patch 2 fixes;

-- 
Best regards
Ridong


