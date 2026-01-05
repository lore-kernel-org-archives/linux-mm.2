Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4F9C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 17:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C7E6B01AE; Mon,  5 Jan 2026 12:08:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9D76B01B1; Mon,  5 Jan 2026 12:08:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6D86B01B3; Mon,  5 Jan 2026 12:08:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3D36B01AE
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:08:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 836271399CC
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:08:21 +0000 (UTC)
X-FDA: 84298543602.25.A95CA18
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81E782000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:08:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XS1TiyVe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632899; a=rsa-sha256;
	cv=none;
	b=WvlgutN2+oufV1SkDMsJgQJbLv6e7d1ToRGIGANqLUJCv/Pure+3jUq0xc44zyoDw0GzlU
	YFz2xHkk1qCq2XI38jX588D0Xia/zrfNCEjMymFAN4sS+Iz/Hf/LSQES5elpFH6+meBa6W
	MDDHq6SP7pJEdvFV8d5GjXpasxQ3v7s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XS1TiyVe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/YCqX8o5v9VD26M3nxmomUHfJaSJn42QMDaxF6W4n0=;
	b=7gc8q61K20+HP8Kz/fbTQS55wPs33c6lRv/JW0xGP2mxBgcLnZ2KnUd/GeME/ZL9uHXJdS
	jHEoWDEwWjOl64sfDRqq4QHQjcKk1jcTIGsNs1e0IgZ489xtgp2G+P33ARmxSj/HCQ1UWY
	kKuhFsww9D+b2QE+Ukz+xI8pBEecr4g=
Date: Mon, 5 Jan 2026 09:08:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767632897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c/YCqX8o5v9VD26M3nxmomUHfJaSJn42QMDaxF6W4n0=;
	b=XS1TiyVeiyIyOlMjdeiI6yjCJrpmqbHF/OZAV12j10f0zr+3z8ozLOYrMzXpi+/oCW8Nmx
	FlqbEY7Cxnl7khT2W/5F7goEBLiGE6jpFL1RYXUZCK12I0NlV+0hl5FIPi6lt4LU7kPX5g
	0MwLWfCr23EzxnQbidln80Cz2RgREQM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hui Zhu <hui.zhu@linux.dev>
Subject: Re: [PATCH v2] mm/memcg: scale memory.high penalty based on refault
 recency
Message-ID: <qlzvksuvo22rrngdihyeepwhphretoenre3gvkako7kgsgw3sy@l775pvzorcdh>
References: <20251229033957.296257-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251229033957.296257-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 81E782000B
X-Stat-Signature: jftdwofj39n9w3ip7s1z5umqcaqku1iz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767632899-657411
X-HE-Meta: U2FsdGVkX1+LPGkxUcE+yNoWw8EqUdblzvD6CkMcio8N9k/Q5AJ3r2C8DK1Z5hVbADj7/kQ8xMlbz4jkXdtb5W7CFsHEECdUzdzAc0gVcV7MJVlT5/NBedNc8ekrTnVJVDZFJHn4+zfDb/sq2CC5EDaxuGZERSDgufmspMtBrQWHv5Q2fGe8gQtPeXa0dvG0WggSeVMt5KPsvjSKunKi7dDn8hyiSdQYaScUczrTzGtCJvMWKmTAP8Lr3L+bNHlmPpE6MWnSnw6OJORRC4TzYYRclm/o2engqf6e4rGb6yrQKCke26vft+CNoZ0UHcdX33L6lsZATZRKexK9bmpZZRBRucKlivw09uRqRu0IUz1Blthb16GXk9LF4YBV4pyXem+UPQcclWXJ6R3kfI9Ma+wPKuKQke6GSuG4Xxvsg2P1j9f91M9AFMKZf6ngh81Amk+MXG3bJecGdhlHaBNR+0dD2+Vuls4e6SacvX5BClT8EcRDkt3UGSgHtLMf+KhKWyFj34epjjsvYH3kUs72rD5Ac1jk5fyvlTu3bvQU2G73yWJckofXhTUWelw8KVrzFhdafoRsgsLKp5H/fRhdtqIvZCDZnrqUlnrTWbFcn9jUs8BAVnhfMbr84ylMrZ3KImatzaNNf0J6PAg+32VOReEVHbRjXQKqwvQnIxhiDhT3555BDbc4Y8RFTGV9rsBhBruYkLl3E7aSXvPjHinLkmU4Y0NCZUtM6c/K7kvR7m3+qciRLljM/+4lSfhWSlNpCA/CCEKzhADbV+yFFrapt+aAvoYpEKhaH3jbiaHqqVBrNXFNY6QJnsukDNN9w22WJLm0xNMrXRonjDsoQTesdp6jS3IpNSMp2+LkXJoh3csf1dMh/PzK6mcH4O67yOOiHHJuC8x45TlnoiXbqGzDGMPradJDdbTjqxt6BifsD64wWK4q+iME2WmCZzxgttuDbvTAOn1pqK3e2trwaIV
 c2ac794H
 PcMhfVBiwAgXYlUhIjVK8jXqrsIhNcbxaHFgPW8lNQMv0j92cgXBHJeuI1GKwJtUdPwP6snZymul1x/JRFPydpJhvlvWMO+B///jcVHfD74MwUiCXzZeGkd6ISVfkCHUzrPbdc+mr8RX8HK2Io3UOgX6JHCK66O/7bjPzN7bUWBzcx9hzqE/uvDTRkBZhW1+fLnf0EiYHchm560/CKcr8UmA5y2OkqC1yv5GW84eqHw2+YmtJagN5kn9iJhfAb8MR7JA89ce3ubpwETVB8D0fc8oifsm+d7aokKNho7O0NqXfdtg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Hui Zhu

Hi Jiayuan,

On Mon, Dec 29, 2025 at 11:39:55AM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Problem
> -------
> We observed an issue in production where a workload continuously
> triggering memory.high also generates massive disk IO READ, causing
> system-wide performance degradation.
> 
> This happens because memory.high penalty is currently based solely on
> the overage amount, not the actual impact of that overage:
> 
> 1. A memcg over memory.high reclaiming cold/unused pages
>    → minimal system impact, light penalty is appropriate
> 
> 2. A memcg over memory.high with hot pages being continuously
>    reclaimed and refaulted → severe IO pressure, needs heavy penalty
> 
> Both cases receive identical penalties today. Users are forced to
> combine memory.high with io.max as a workaround, but this is:
> - The wrong abstraction level (memory policy shouldn't require IO tuning)
> - Hard to configure correctly across different storage devices
> - Unintuitive for users who only want memory control
>

Thanks for raising and reporting this use-case. Overall I am supportive
of making memory.high more useful but instead of adding more more
heuristic in the kernel, I would prefer to make the enforcement of
memory.high more flexible with BPF.

At the moment, Hui Zhu is working on adding BPF support for memcg but it
is very generic and I would prefer to start with specific and real
use-case. I think your use-case is real and will be beneficial to many
other users. Can you please followup on that Hui's RFC to present your
use-case? I will also try to push the effort from the review side.

thanks,
Shakeel

