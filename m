Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32798D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 19:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296246B0006; Mon,  8 Dec 2025 14:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FF76B0007; Mon,  8 Dec 2025 14:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9156B0008; Mon,  8 Dec 2025 14:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED2036B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:29:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 801CFC02C4
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:29:27 +0000 (UTC)
X-FDA: 84197292774.15.2F5A4E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4BB214000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:29:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omgaDKgJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765222165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZxRQmbGH4nHaq1XSQ3AQekPFmPu+G4NIvi8PObqIks=;
	b=XToW0ISlKKaWSOE+k6FFiFC6+7QYwXraOVV1pJzHjg201ERJOwm/L2HAubaVxj1k8mu7l6
	VDOjBEjCEORXZw137gCZeufRvwMTOeLkqrZOrmNbrt2Qty1J00jL5mSDw5qaacH9YrThe7
	47cN7+aecRogV0e0vfrXDMdONbXR35A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omgaDKgJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765222165; a=rsa-sha256;
	cv=none;
	b=4QDd2le7MsNbt41Evo3g/+pUvfceSVKEbRaeitv+w13fLibTG+YCj86129jNBTI1m4ZeZY
	efK4qF2TaabvqOaXapmls/58+6Wopg/JJ7TBOWKMKcyRvX+vyDc6HM8BxJMfAQJWW1m0XB
	YL97a7lXdJNdPr9EVP8UjPMR7nBS7QE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACA8A40DCB;
	Mon,  8 Dec 2025 19:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF17C4CEF1;
	Mon,  8 Dec 2025 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765222164;
	bh=vc022swnydaWh/KukuNdQUEaOzu4LoIXqr+Qwn3IWN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=omgaDKgJreyKgJLexcoMHjOwqx1MK/e5dP/JDVQ8JtQ92CSUv32+PjR1ugJgqVXTV
	 7cRH6SFc4bHjO674c8wHy7txXJLVzI+PkxvA5ew5S+KxPUXU/uM0pxQ69d0kpF6I68
	 FWqtuMpw2veFcwIldmiBnTKW0CqWhdWS/EEwfyflg1v1i0abgs33V1gSbh7tywyUSl
	 ompLEcETY+wJOAbmFhWk9GXr3M5Y60o97QZRUfhu16xbWBtC5PsrwDWhIvw9sGEmXs
	 wzSaEz3386mSZozz9ZBpsJx4uBZi4LKdmbCjMMDsDQz27z3HEmWUNj7X2cD0p6spmV
	 R9He2QM6c+D6w==
Message-ID: <245e6969-f45b-4d00-bf34-83da529cd3c1@kernel.org>
Date: Mon, 8 Dec 2025 20:29:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Aboorva Devarajan <aboorvad@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, gourry@gourry.net, mhocko@suse.com
Cc: vbabka@suse.cz, surenb@google.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ijgbetqbdhx6n1wh7fgb85cky41oihms
X-Rspamd-Queue-Id: A4BB214000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765222165-706563
X-HE-Meta: U2FsdGVkX19MwrzdrOIRdAN27bvUr3xIedbEk20YpckSrhyQbXgYmaLxeqw1lgOdBWyTnSq0ipeCL7oEXOi2yNWOfM8K8/rt2OyvrOYcyw4jpviRpi0iKJZj9L188TTsoVrpJL3CIDxjCsVudcvisPx1brjXIDLmSJHeuR+g25YrZfuO2CvIxZ+t3SLQXozVG528hn3ANvqWbizwFiYedUGKnpM5jMEgqD9J568vSrCxRvGq3ww8ByWew3UNHMTbs4c2cxvD8fYu38p2ETnLxG8e8kd1s25uU9Nekyt3piB/XRHOhcu0RW3Ody/7fIsTfH3q2oQuoa4doD7UqIUfvXoRfo5Q8ehN80kp97mUUrFBElLh/E5o2ddW0T/5jwsRjZX9pMbIZ8FpFS5jKtC9XW+qi9fhZ6DWjJsWDrHb+BN+F1N0PjSUbvxqZMGV/uHunneCULXDvg3DfsfaBsP/hn8UvaytzAzYgRQ9/iYXmnWPzfr4C+Y82TidvXSVPFjM+49sjfg0Gn+Gkcqt94pzAXHo0jDhQLVqluaX4gx0BD41nXOkaAC7wK0QfDGpWcmvmJ59U+WLz0wiECLnUYm9oty9VnuqK+I3yIHpnumkWgWootOS19bxE7aa+LaIlXuigQ1NdT8Uw0eHan5z8axqkp52eb2Mrrxy2ypSoAgLxDCNwTMQGcu/pWKhzffAPbR5Z697S6in8+nUTyq9kTulHMGflg9D0bA52KCdD7QnE+DNrvfsGDAgFzNTlVLOOA1Zd/tnEF2Z9F/q8LeBIffTXekALSwXRgFQP4RiwfilNmImH6d/tVDLeTdG05jPnyosmGkZwN0pnfpUPGBT6XdBpsuEDzFZkMLlvLEQeegFJtiES8TC22suWKHNHslp0BQY6h17m8/iXQss1RLLeMxiKKPg6wDZ0fUUlIJNkdbi2RDdVgEfeasfG9V6XzPi5+Fdqgg9Sp4rkGLNuToBZNw
 vrKSent0
 TLcyIKi2PtHp5tBA1Aytd7pNpfba79IfhNIyd1NLG7sky2sN67MXHWSpqU8vtaEJJmauYEQzXBCy0Ppxx2p7GfqpQFD609nDDIBGQGl/G1vk+0SBEMG1n2o/m9xVNF0pw3UISwWGbfCad8ZfM8HRronlWJ3KuO581FD4zN+tN55IRKIlt9j5ZRSVOSdB4qpplPWDOYcLSCqItLWfds+B6TXib5DG90aDJtJUZWwG69/8pI4j5o89u5vss8kYvlmpeb/tQQKnz8adWw2p6ugLRl5pXVnavxD1a1+Hv+IxBmxpU9ZsFUTELAUQisYucmnVbYB5WKJstBaDEc0/ddYE1JSTQmKqHh7o5uiix
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 18:30, Aboorva Devarajan wrote:
> On Mon, 2025-12-01 at 09:41 -0800, Andrew Morton wrote:
>> On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
>>
>>> When page isolation loops indefinitely during memory offline, reading
>>> /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
>>> causing hung task warnings.
>>
>> That's pretty bad behavior.
>>
>> I wonder if there are other problems which can be caused by this
>> lengthy hold time.
>>
>> It would be better to address the lengthy hold time rather that having
>> to work around it in one impacted site.
> 
> 
> Sorry for the delayed response, I spent some time recreating this issue.
> 
> 
> I've encountered this lengthy hold time several times during memory hot-unplug, with
> operations hanging indefinitely (20+ hours). It occurs intermittently, and it has
> different failure signatures, here's one example where isolation fails on a single
> slab page continuously:
> 
> ..
> [83310.373699] page dumped because: isolation failed
> [83310.373704] failed to isolate pfn 4dc68
> [83310.373708] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83310.373714] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83310.373722] page_type: f5(slab)
> [83310.373727] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83310.373735] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83310.373741] page dumped because: isolation failed
> [83310.373749] failed to isolate pfn 4dc68
> [83310.373753] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83310.373760] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83310.373767] page_type: f5(slab)
> [83310.373770] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83310.373774] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83310.373778] page dumped because: isolation failed
> [83310.373788] failed to isolate pfn 4dc68
> [83310.373791] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83310.373794] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83310.373797] page_type: f5(slab)
> [83310.373799] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83310.373803] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83310.373809] page dumped because: isolation failed
> [83315.383370] do_migrate_range: 1098409 callbacks suppressed
> [83315.383377] failed to isolate pfn 4dc68
> [83315.383406] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83315.383411] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83315.383416] page_type: f5(slab)
> [83315.383420] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83315.383423] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83315.383426] page dumped because: isolation failed
> [83315.383431] failed to isolate pfn 4dc68
> [83315.383433] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83315.383442] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83315.383448] page_type: f5(slab)
> [83315.383454] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83315.383462] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83315.383470] page dumped because: isolation failed

When starting memory offlining we do a racy check whether memory 
offlining will succeed in has_unmovable_pages().

It's racy because briefly after the check, a kernel page could get 
allocated, before we isolate all the free pages.

I assume that's what happened here.

But even performing another has_unmovable_pages() check after isolating 
the free pages will not catch all cases: in particular movable pages 
that are longterm-pinned.

-- 
Cheers

David

