Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A301AC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898686B00C8; Wed,  2 Sep 2026 22:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849C06B00C9; Wed,  2 Sep 2026 22:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786CA6B00CA; Wed,  2 Sep 2026 22:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58B9A6B00C8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:06:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E785C1A0263
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:06:22 +0000 (UTC)
X-FDA: 85170811404.20.24706AA
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id BDEFD20008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:06:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxDnsMke;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788401181;
	b=yfOTzZQW0hzYuOBxrohDqvyDtEGSPGVEPstO+q0/IefQvRhY0+JdAv2QOUW0fG9/nYmvut
	m8AihdyLiiB4gOn16Lai6/e/zx3lWnH02qPgoz0ltnimy0HpKOvmPIPhXJ3tE9e1HgN23O
	HiTg5ZQzs+D6WR4Geez1aNWVUDEenVc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bxDnsMke;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788401181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrBY0v/KlQ53RzUL+AB851i/qq0lROyy3JN3rlCVv6E=;
	b=EdQEUxxnCOJ4fg9esbFlUzHw6yCV1BcmR85iBdIBkmYFeoimkfqLAl3Fhw/aYEi+ry+lvx
	H7QNa+DIRVgrR+a7TBvG/x54zZfDCKghdne+O/kmogT7oSy5LJ4gxVBREMfMXmhr1bESZ1
	675kXj0FNMvrn7ZxZ4UpvB/iYAI+Nic=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sORQMTssCW+DjxRG0tdExe1sK1xpzkmHbXyQlIYY8FA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788401179; v=1; x=1789005979;
 b=bxDnsMketen5hFJagQshfOdgfojgtth0wWo3bx6e3YJs3NvN2we2cl55EUEZLtjh2MvqiJ1A
 tGcPaKaHGtrt2gOelzGNgElMjVuns1Fy7iX248wAbP3OLSJFWxf1rYqQJsrgR/LiOAc2OT1DsxG
 ZutY4rT4lGm2H3y1N3wcbYxM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 484a927a0ec94e73;
	Thu, 03 Sep 2026 02:06:19 +0000
X-Mizu-Trace-ID: 484a927a0ec94e73
X-Migadu-Flow: FLOW_OUT
Message-ID: <767cba8d-1cc2-42e9-a8ac-8cda90d0fc35@linux.dev>
Date: Thu, 3 Sep 2026 10:06:11 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH RESEND mm-stable v5 0/2] mm/vmscan: fix NR_ISOLATED
 accounting and throttle MGLRU eviction
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788339549.git.zhuhui@kylinos.cn>
 <20260902143727.776d04e71eac0e4b1fea6260@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260902143727.776d04e71eac0e4b1fea6260@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDEFD20008
X-Stat-Signature: fayxijgfeass7dhr534yeya453dd6zcq
X-HE-Tag: 1788401180-152383
X-HE-Meta: U2FsdGVkX18wgxJp373ouM4CzPNa6C2wTgyWJMO4yVu7fd2q+CnrIR5nysdR6JM6Tm1A57IIyAvk/+put5gkUmiqXiWjWS+OMP/jTAiTqM8DBJwMdyMpGtUSEs3FVI1M5hD4uYkOlXdg1dAqp7KhwarbaF6G5F4Ok81cSRzQevtJmaNVa1EeBH5IrMHaQW9en+QMha7jOJmVAOOSxZT6UCVJzKvYfRkaRmMcyMoRfTiAn24iWQLegsUEXyoxhAb8laptahRu7oACY5kUFKzOLLSnmA52FyWhQU01v1LP8KUsoaFPfjboqL4z2kRp6I8SsJGUieGwn3cTSsgZfd7ws/PwrSlIyZBnI75v8M6JHn+YTqus7GdTyNQ1aXovIBIS2lNsxce8+eNWSqUPuG4JW7knGzOpuLXUjJDH1Q0VFQ4uUUuwoYHUp14Dds9G8rKbg9SmVQnq3MpnEO0+tZyCmSWwmtQp3oi0xaohiAcFNbuTNnM7lUFGfX/eOZC+sxndf56c2jKK2byDSBgyDDSN7MEGmztXLndJMpK7R1t3NwUbaBOMn8OQpK+yLxnL23ziEryb7R09b73DtwMlm7/SnfIYIYxIP3rwrKOiUhtjMSkVd8Vq81Aol9KH/5aJ3YKaUbnnd2asvplXIw9GKQXvlXEkyaq9q3hHpCst01lge/dUJWqTPSTlMA9VEXUD/eg257H97sgI2yQ5Gb7Rey1iPULQfC2CCbht91tTh1Uer8zkwUR5jnIHuLHVtQc4H1s07KK//bS/c197VvaojdCf/BYXxPrejxW19EWdgkSQGhocHPA2ygI4T2iVYTEjTJXfdSsUuj4beA53Sap/ct+k9WrbMjL0hi8zdPWcH4YwhcN4HBM5d7aj/BhrXhluzaks0sbk18cOVxGHoUoywF+gIsnGLL1SjwXQCcu5R9cXss1obLJ9i2xLjb86W/tiWoWrHrD4BaUu6WZjaj2imiQ
 b0w7mODW
 U2nXVKVDCRaVY3bcywKTfSi0+4fJmuEDagB55rRQxlbigY+kAMkp+1cOqgOOs1UTOLWR2VbSaRnxEjoJY5uy9H+FWQ28eQ8gxh0Z72r4AhJoWQUEuErjtFxSrdBxYT8wWB6FwErgG7NoWN05VfXDxyTrxHN4zmjyVQMyls95gC8c50TAdbMZRMunFhHAF251obWIN6S+WQYdCxCOat/pYg/ov0R7krzfCgfI1KDtWRsigLkDOc0DzEjGQQiyuoorO+zTModVPvcT9N0muFHvS8jklGXaE06hmsTV5hWqJKRYmkMZU9/d5oHw2u+FoRRo4Jo1F57KJJOKqASJkb8oWK1tZ1nvDKLFHCyuqHNZFnN8ssz+us0R7IJPSV97Zs8d2QmMqMxw7OhT4cyxTvVrdiYsLow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Wed,  2 Sep 2026 17:11:24 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>
>> Previously the patch was based on mm-unstable, which caused issues during
>> Sashiko apply.
>> So I rebased it onto mm-stable and resend.
> Sorry, things are moving at a million mph at this stage of the cycle.
> mm-new's isolate_folios() has changed a lot.
>
> So please redo on latest mm-new and let's retry?  That'll be a few
> hours after I hit "send" on this!
>
> Also, Sashiko isn't done yet.
>
> 	https://sashiko.dev/#/patchset/cover.1788339549.git.zhuhui@kylinos.cn
>
> If that's all too painful then I suggest waiting a week or so - I'm close to
> completing processing the backlog (I've got it down to early July).

Thanks for the heads up.

I think we can hold off on this patchset for now. It has a notable
impact on MGLRU performance, and will still need a fair amount of
discussion, testing and revisions.

My apologies — I should have posted this version as an RFC.
Going forward, I’ll submit the whole series as RFCs, and only send
the formal patchset once we have a broadly agreed result.

Best,
Hui


