Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AD5C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173216B00FC; Tue,  4 Aug 2026 13:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B446B00FF; Tue,  4 Aug 2026 13:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0395E6B0103; Tue,  4 Aug 2026 13:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D20BA6B00FC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:05:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DED7A15C4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:05:10 +0000 (UTC)
X-FDA: 85064212380.29.51D568C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AED7C180004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:05:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhk5V3wk;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785863108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDEfVs0Bi8dTQeWZgvTkiOBxm/ntA3Pj+qKWpGUZhAA=;
	b=dexonCEuKLWS3BRUKIMHQugZSDaEiGBDQzJvpBmAzeiLUYFhAhmCb0/3h3K2ntcNGkYMOT
	H/OJ+TFdyvFVLSttVC0/aR7wyneSV8GGvS0gNjYXTcl8zGuMhPMvAy0a2nebpG5MvClAsg
	qqYpFjzyttRcaXSbBPwumuV6BxxL3AY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhk5V3wk;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785863108;
	b=IYbPxdpRf50yCVNtnXFqfjhkjqfJEmOuP8i6/PUzmZBXqjPWKiSkVDu0Z2b48P6h8jpDfo
	3OEwVu6yzzDAmTNB8xhuTge2GuMb+u/p+lsT+r5kYzbxhwEa8klW1akPwldfOVybgUPJqo
	/MB+MS530gf9wtCL5WF9dOALh1yjT7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C991760A85;
	Tue,  4 Aug 2026 17:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8721F000E9;
	Tue,  4 Aug 2026 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785863107;
	bh=YDEfVs0Bi8dTQeWZgvTkiOBxm/ntA3Pj+qKWpGUZhAA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nhk5V3wkrUDVAWtxPRfrQm3EDSC20ZGWnFbzLCdVbKHLe/kjkLcRVxXiLC/fpqmuT
	 s6oz3TO5LyY54d2/8z3wG2yq1YsXkfUjM7RBP/waiT3/rOvVyIZtbC1EaHLzgih/JQ
	 gCk5ghpFp3q4QJF1UfpTsjMr2MPiKTxtMnVsaUSGQCThWNj03urvT1yTYKe/FFSYOq
	 y8yn1/WasyUfVRfZ65K/xeWPp2lS1Uhrk9AV4iczW2Zub9+WHrkObkv6unPBpqWPr/
	 HeAJHGLUqzCJroT6mK1il32ogZzOLpWkj5eSi/upLIwHqTyE8sJtp2+KRKyZDhia0k
	 NPoyi3CVzMuBA==
Message-ID: <556894de-2e06-424b-9414-36fb0ecd9657@kernel.org>
Date: Tue, 4 Aug 2026 19:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: Andy Lutomirski <luto@amacapital.net>
Cc: Qi Zheng <qi.zheng@linux.dev>, luto@kernel.org, linux-mm@kvack.org,
 Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
References: <3d3aa670-76bc-4df3-9c36-609c14354e9e@kernel.org>
 <0B39A63B-3697-4FEC-B6FF-2F4D5901F7E9@amacapital.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0B39A63B-3697-4FEC-B6FF-2F4D5901F7E9@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AED7C180004
X-Stat-Signature: 9zwiik4a131fgx4hh9pikiqxaaxqucg3
X-HE-Tag: 1785863108-677740
X-HE-Meta: U2FsdGVkX1+5elqJXYE6BxZ/M+tfyFzyPsqhpJUNiKzd5UqYKPJ6ashI97D6Xrwoc7HyNBYNdEmmsJdvHhznmH8kk468dADcwcflMkDWQ248xFLqPk4MbF8v/tNv6UA3096xURfdkvr8/OoPOtPozmrfka7iiggOwLi75pZa6CoNathgAloVtek/FuICEzoG36zZU1i7mRIB4CSKBlMcEfzlvy7WsxkkMdbUvokqaomqjb3qa97sJ7RIyMxIl4MtcEE7PnZ82B0uJ7utODIDalD6hGLDwD22G1ckhNJRKXoF/LUiBM/qGakjkyuvLN17Od9nOCQ7Lxt5U0gDvNPyt13IXcdBC8cHdEuVwk74SMBwO13BYzlV5U680uBjRB6zjV9LaxKeVdlDp209uh4Yb3P0fiqzH/OLXdXInEX2LBrQSEcrI8hEqMtERGeB/oCMlgBpvdXZln2Q1UwR2j0d1ImiUnBtaaNaOaB0EhHTX0gWVTvCDgx9xW6wBeZknVsO5ikzIAYGY4WftMSzuuhTp6UAA3gATBIlTW/LxGS3o+GmfYRgs3bWXHURqSWatWnAzp6K1T+TlrJuB13wZdWlrXldZPrLYRzETMv0LDNYf3ZeICLwPdKk8J+9mlWQD6rPuYg5evjXNhE2iRMZvQgraFfpC+TXZHjiHmvlgoVvh9RTsxiXIa16fretxlpc+92THuOUjvCMIPu0VZR/sM0CSSYYBx/fu3dBJIATQh/oR0nWcb2Gr/KVw2231NHxma0sZzLkj0ufaffDJDhZy8yciKEv3HRr9vDu+174xxcOmzh+NMilVyXj4GdTNdvawIFCIk2QfxzQ12dVr3bCqd8Rhh2iKcZdvehkxQNRXEBgU5whL21Sp/+Ab6cBsWsuUm/VRIK666mlbp7Gwyhhx6hqqRfMcMicnxN0ZZHs+n9TUA1ihfhWJbTz72FUMDxR3shl4udsa6CGIVsOyZRv13e
 4QVIKwYx
 f8LRBCbzRD+tvZOJM12Db2vhzVVhCXAvfwck+PWIxVUf61TPGIYe4gk3Lg2wrjPULkg9ry5m0+lgDTbCYEtwNxFebxdsQ90N9LTZKKAbVOMgqKBd6NLX2xGR6b/JU7+5GkwV+NwKd3dkTMSj2BHWvFp19cAjkqiXkpuGfA0cof8JwOoMKF0ot94jti6fnlafSHZvFzUfmq+AVpfNqK8YWkYGwr5QIeO0lzV0btuZHRijYRk11hqXFzpTmH2MFiWdpg3UTXG7soBkFSTLq+Uri7/D2IB/Eacz8qA2s0oDLYB8JfBqTyodPBjDLtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 15:43, Andy Lutomirski wrote:
> 
>> On Aug 4, 2026, at 2:34 AM, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> ﻿On 8/4/26 11:25, Qi Zheng wrote:
>>>
>>>
>>>
>>> We backported the PT_RECLAIM to our internal tree a while ago (excluding
>>> the rework patch being fixed here), and it has been running stably ever
>>> since.
>>
>> I'm wondering whether we should have a selftest that triggers this exact scenario:
>>
>> (a) Populate page table(s)
>> (b) MADV_DONTNEED to reclaim the page table(s)
>> (c) Allocate plenty of pages for another purpose (draining PCP where the page
>>    table likely ended up) and fill them with some data that looks like present page
>>    table entries.
>> (d) Re-access the reclaimed VA space, expecting re-population of anonymous
>>    pages.
>>
> 
> If you want a better chance of hitting this bug, you could try:
> 
> - First DONTNEED the range in multiple calls so none of them reclaim the table.

Not required. If MADV_DONTNEED spans the full page table we always reclaim if it
is empty after MADV_DONTNEED (there are some oddities around uffd-wp handling,
which wouldn't apply here).

> 
> - Then PREFETCH the range (or use your favorite speculative read gadget or even do a real read and ignore the signal).  Maybe also do this from multiple CPUs.
> 

Not sure if that's required, but if that's required to trigger it that certainly
makes it less elegant.

> - Trigger reclaim

Also not sure if that one would really help.

> 
> Then do c and d.
> 
> The result might be so specialized that it would be of dubious value.
> 

Right, if we cannot easily trigger it then it's way to special.

-- 
Cheers,

David

