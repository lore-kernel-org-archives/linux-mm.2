Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED5CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7DF6B0088; Tue, 26 May 2026 07:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258DF6B00C9; Tue, 26 May 2026 07:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F2C6B00CB; Tue, 26 May 2026 07:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 075576B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:43:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A878F1C16E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:43:08 +0000 (UTC)
X-FDA: 84809384856.26.42A3B0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id F275418000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:43:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GE2giss5;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795787; a=rsa-sha256;
	cv=none;
	b=H6vjanCvj+I55LPu44d/adz5CwC0+Mpd4iwsaQG/hpJIOMSJzz+I0DA+M2ZY1/fkkk675/
	krC3yIZwDYhzb17cjJokVIF6/rsKz0oPm+l8gFlOPZJQNS/ucvS4UQEG8tdaxqlRGoqCw2
	jZhezGEyHnFj/zi04azKh/IEws24ye8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GE2giss5;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8VRGHC3tlORPtYqg7Va/I23aYVh/vTeo/wVK1CMwWM=;
	b=Yv+/14iy2bAXcLjgA1cojZhZ20G1a/dajEG5zaSzJvptJO4lLbRvrbsowlTn9X6K4pJkfT
	1y1xWnSy7jQCrcQaiiA4kwObvL0rqjSwmAtpfDqviI23VESkh7Kuh1jPq5PVcnKNRHz4NA
	Dwt15ycgBk7wUn3o6ju58Qh43xygnis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5E860018;
	Tue, 26 May 2026 11:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98FC1F000E9;
	Tue, 26 May 2026 11:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779795786;
	bh=Q8VRGHC3tlORPtYqg7Va/I23aYVh/vTeo/wVK1CMwWM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GE2giss5Wh8rI35Y9swTlRcBFd7qNiQZn7r+ZMH2GbiPpbq2NdEkd4G1PcVRtApQJ
	 xu5rCcF/LR6ZtObpquLEgLYBm4uxIkuCd+g8LdI2pcZc5adlAaiJ0+lIU1cPq9fTy6
	 dHQfbHr3VD+fQ6JbwaVk1sfMQ06ySY9fytPVfY1+r1PYxKZZcOCFFbI+/uT0dGio7c
	 ARlkqc8NA1rXBPEwjuHjGjKHMoI5aPxjzM/0hZsSFZooIcqDLQ+eFBdUPdx7yj//Gv
	 cVPVSUxyMafe0na01QbuzDMAIOzI4ySvR3t0KsVvpy9O/PEmTIftQ+OL2yl1NAL1L2
	 Ces755QZ58l2A==
Message-ID: <f34abf19-d552-465b-bf03-660c80b4c7a7@kernel.org>
Date: Tue, 26 May 2026 13:43:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: document that alloc_pages_nolock() uses
 RCU
To: Brendan Jackman <brendan.jackman@linux.dev>, Harry Yoo
 <harry@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com>
 <6c089de3-34d9-4dd9-9646-f51328c77497@kernel.org>
 <DISJ221L3QED.5TA2KTWHG9CY@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <DISJ221L3QED.5TA2KTWHG9CY@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F275418000A
X-Rspamd-Server: rspam03
X-Stat-Signature: qi74m3dnnay6nbjgrwojx7itotaz7hxt
X-HE-Tag: 1779795786-172671
X-HE-Meta: U2FsdGVkX1+Y6/2AVnuv4+5s0pggDIICoCXL5YdtthA3r7m7g8qiKDldwsSpBgvSBQxUROCzNtsuXn23wzOHGHJCyme7M54yu5YyqaBRfzPeXmSVtHqIAf57W9OxPd8FUXfYRQiUdwrJcuZdsS6K4R2q3lXazcaHaEk91NrbTNz7q0e4s9OeOOsvl55GGzyamyOoj4bQNx6Ge7Kc8flksGaCK67W1fVA9nL91iw26Chxxvd+Lyk6WvORqedxHbjI79gvbNIT9kxBnIUXMTzM83a3uNaVqdYbL2TAIU4VuL7oh7UcpTsSgFRLDD0YW+d0nv7terqnL+nC3N+02HLk6mkOJvn+FQAUzau4O9+6Jq4ncD/vC69IdZ/CssynQ1/3izga7XWD70Yq8tFxSmdFYVChtBL05dgkDHp2ORhgH1y3Vo8XsVWSAf2+uJbbx5l4OM2wa9MK6+9oTJIvTdMnnmFDS5DKshMSkqBmB+j+i+NJsx0mFQM/dBkKkst3JTEQZ5NI6pJyZFvusA3tqI93Ce2mPpxfZ94bZbuvIDTEnC4apZ23WeDLVcDzLCDPAwpVHREGki63dBl+4WWm+opvCVsErQONtojmKGe7JNu90GwxjKE7AjClqTvVHObVJeHEE6wqswHIXFJ54m6cSrwoDrg66n6gj9rahMq+Fvddx4cDUXCOLH4bZw/Vdq6dywQ67MLRTX/MzfCa7jPt5lP1lwmpqHlWKeUjvRXLeZ8gLx/ynh5LOGQjaFbPbVSgiDH/CoJnIaexCbZLP3JNMqCBIif/Q4KrIH0wPN9Nm/jN8CP25U08G4RFBDtNh4EQkhax6XQ0XS7d2rN/8IhmbRMo92frlyqiTIJgjlOPlre5cW21zHwJoKQChpuKu1gzqkgP0Kcu+1KKf2cgDDVYvJJaENvQynDh0g1jdwXDkSceKbg6Ya3jtON8CtRYvDK6xauZcllaElMFzX1F8EjwRcb
 O0QrIsMp
 sNMrfmbdsNsKuCaFTobp+MTyCUStb3ODzsJ9iSS8BlCnKevitje6GybDjM0jaZV+1lWDxjeEVe+eEG63oV9l52ljJvW8MMoL/8Mx/q47E739rPby8JljgCEuN8dTHSZ1gEyBS7/nQPrtnalg18JlM3/ThXMs40HIQPbHjUFuE5JK8xhPlhG+JIdHIeokJobOJarYcCYh/P6DEzm20W3gn16Vji1efqsWId5Sj3Iv1G/xW/IzxpZ8xfc+kHRwu0BOzmETVqc/aXzR7l64IHxgwiY6/mFwLO/IU09dR2BH3csYLTbVB4ehUL8yHIHi2qiRTqT+llMdMPv01t8dm21hVi7GmdDpy6nntdh5X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 12:14 PM, Brendan Jackman wrote:
> On Wed May 20, 2026 at 5:16 AM CEST, Harry Yoo wrote:
>>  > (I don't think there is even> any documentation of what noinstr means 
>> at all, let alone the connection
>>> with RCU).
>>
>> *flips through the documentation*
>> Oh, perhaps Documentation/core-api/entry.rst?
> 
> Oh, you're right. The situation is way better than I thought, and now
> I realise I have read this and it's probably where I learned about
> this in the first place (I thought I learned it all from Junaid). I
> apologise to the Documentation/ tree for my slander.
> 
>>> Note this is not claiming that any cgroup code called from the allocator
>>> would actually break if this restriction was violated, it could very
>>> well be that there's no real way for the allocator to act on a cgroup
>>> that can disappear concurrently. But, since it's likely nobody has
>>> verified this one way or another, better to just be safe and declare
>>> that RCU is required. Allocating from an RCU-unsafe context seems a bit
>>> crazy anyway.
>>>
>>> Suggested-by: Junaid Shahid <jackmanb@google.com>
>>
>> The email should be junaids@google.com, not jackmanb@google.com? ;)
> 
> Damn. It looks like this already went into mm-unstable but I guess
> it's not a huge deal.

Things in mm-unstable can be fixed up. That's why "unstable".

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

