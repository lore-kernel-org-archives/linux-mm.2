Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC46606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m3G6ZBYO
Received: by kanga.kvack.org (Postfix)
	id 9851F6B00EF; Mon,  2 Nov 2026 01:40:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935F16B05B1; Mon,  2 Nov 2026 01:40:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8248D6B05B2; Mon,  2 Nov 2026 01:40:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 540EC6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:40:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD75540C64
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:40:09 +0000 (UTC)
X-FDA: 85389229338.14.CD64442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2EDD160007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:40:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3G6ZBYO;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793601608;
	b=61ZEPy7CfhU6tQOnK7P2GaWRHgU0dQ54MLieX7PtdlZNAoI4lKTMBUkS7BeDumyySVPFHH
	wTSiGD8SdvHNiI/zEtPZR41w8s5H2luNqzSJ0DmLmfc8xZSt/XBbca4obDYgG5FvumHvIA
	HDTn6M6W4xGpArr3S+45dfUQ3JEPwbw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3G6ZBYO;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793601608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47fs60LXRPRVsAKKNOF0L3fpWdYry5GJUN7TOHqj7vI=;
	b=XHwoE3C4bgcQY4IP6La2rcGjO2L/XEohymlOmXAbwZLzLINs5EYM+oMnudx0uORhbpt9TJ
	1UZeM9gio6ta18ihsLsK6pead6tL5VnHiwWH2BPVIBWCKLngqgC9rh9Rn73ogJY70X4QS2
	p5CnXQ8Hw2KRGd8JppHJNJpOAdCBERo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2031417E6;
	Mon,  2 Nov 2026 06:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC7D1F000C1;
	Mon,  2 Nov 2026 06:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601606;
	bh=47fs60LXRPRVsAKKNOF0L3fpWdYry5GJUN7TOHqj7vI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m3G6ZBYOEGTVvZpwTzcl1ib0RJRbexXPcIAyQK9UxCv2lIo3F7csLlUhVRzgHtZPA
	 8W498j85QbU1Wtk1g/xVygGfDLx2RLFKh6o9sxAz/6OLCUA7Aftd/2xl2NX+hl9Uby
	 tsm1Ov6nBCrdlH+Xy5hpqvInZsnD6Kts+sEHQq429PME2dJiCbBcyEjras7q0pG+ZX
	 GBfdpQ6fmBU/jhGCXDmAo9HVRAk2Vf+wBgktbUExvp4UUqkXiBygz3yNj1aj+DZDcX
	 jP0wjRKKRRUoJaRpzMVJ1A+vQR7P5Dxk4+S9RQeXrMIwGOeZaZkcYsZkuZUjzqxKZm
	 vbO3hJL05Zn+A==
Message-ID: <eb6c0b28-657b-4795-8c96-600964633946@kernel.org>
Date: Mon, 2 Nov 2026 07:40:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
 <4026ed95-62c7-4680-9bee-7507330a4217@kernel.org>
 <9e5333d5-4f56-4308-b990-6aa048d9e907@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9e5333d5-4f56-4308-b990-6aa048d9e907@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D2EDD160007
X-Stat-Signature: dgsbzqbbjyjxug4hb5ctw63xrf7bkzx8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793601607-79971
X-HE-Meta: U2FsdGVkX199+aymvAkzfGfu4NGszksXoJ2AkA/8tHU33S+/sXv9SV2eXiDryMi7mYumg7Vu1JjOdL9lyz0KXV9sixVrEjKCcyq+97acY6hWn0NCr2HMwKKrh87gM9BoGuWydynGL7I0uEDLsrQRKaSUXTPoBHIPOy4CLpLluqYLrsLQlB6WUVyOWnM86uxvYovqzmbpSt/G8VyWDDOhreH0cVOubCAZ+kXvSxVjJbYM6WOtLNTeRGdKRC9QA8eUNV0SfDjHelM0gMs2AeFPIe3B6dfmWT0sXpm9hE22+GYVNF6fNjtcbTgTZ+NbEH+UqD8YQxpXpBMUExcjfZUVITMd8ES3CzAR5YUYTdwGrc4F4F3foadbtcXLT/QQkRWK3QIN8HJpuKf+NAF2Kaffap/fvCTFHqK8v/y7OL0aThcAlVA6ofV1Arn4UUA77tSC9irMHA8zUruJ7qOR3F3kcPyyMQRG4alcn5WmsY1zjRr/bhgFTCN12Sq6fhUpLmbj9fu4bc7wNwbmyM/gaGq5Ze2mJAV1oJp7GFUpLSZ3PmxFLM7A9K9mU+zPjewLhn0qF16q8nW8sbXXNxfiFGUOl4HBMVdJLSmQ4XuL6Bi5HbzMIi1qQdCPDcmsMPwIwxjltswfGvJvWW4xDOPinRu8tEChp3mXNjFzFr1YlHibQQ2VyvRpikWtg3FeLvFz12DzBdnSBDME9Jnm5U6SR46sPtdxoAfhMHF0r1OgXg6UaEphMQCJV6kpCFu8DVrRX1iqOtE3DwIyOTINeMWHlhj5xOHAJdHk08DjXnhWhOjkOfm6LySCu/SS/MfTU0eicNRqvXULlPCGbY3Ez0F934iTXrGt35BbjJ0O0I01QSKX2+ndcleWNYQxBmtv1r7vBU3b07tk3SZwRPoYKOfIdxzTd5aNnvc13DRmFhWPeS/5pTxhp8cW/BihAMQJvw5PVwrUJIJVzFEhxS2+bMCNa78
 E0iVgPTB
 BgNNaYgrgpRgA8+wDJSPMvOOAsfWOzHNllcSQAuVYLNFs8a3lO2ERZA3HWF7jsNC6M0tsnmWcTmYoJP24AwNbPNdeoGLoETjMnAcByww6m8ND0z90+bCkJ57aQ2WBIENu6RZqpzW0ltYElr3oysxKBCkG+W6xgM+ITlIIs217AAA74z57Le+rclM3KYOHKMJ23Ntm4Ba4JJn7rtMUt1VUhz0p2xcyKO5RIuW950M89hwNwZMiYi3IZVxtHTxJhY/BkEkFpSXx/I9iaky1dsMZfw4jyqAoOp7w/OzCjmYTSinW3PHrxboCFp0oGL1+dPqaA2VDJ1/Ygk1rcqnc+XXaWvka+/tjSHVPZNMVa5hIGFISPLH1eirOZjQUAboH90CcDS7HQMvWZuEfjcQDeT2F8P1xFcjqW+BhvukbPVdanz36aEjSblr8/eGxMiNAVzWd5vBcYD+DvepOCclZm3C6qGHBp3+ZXpfk5DX7Xlsg3YEhD4yVWxIe84JeCZZtKdilfj1MtfsBo35VFKEpJZa7KTkmC+OKN1BzvgbRuu9mONrGMxQ7OgqmwPxfEKl0sKSPGUhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 19:59, Vlastimil Babka (SUSE) wrote:
> On 11/1/26 19:01, David Hildenbrand (Arm) wrote:
>> On 11/1/26 17:34, Vlastimil Babka (SUSE) wrote:
>>> Johannes is a long-time expert and reviewer for the page allocator and
>>> has agreed to step up to a co-maintainer role, so do that. Thanks!
>>>
>>> Additionally, page allocator is joining the MM transition, following the
>>> MM core updates from David [1].
>>>
>>> Patches will be collected in the mm/page_alloc git tree and integrated
>>> via the mm/linux integration tree. To signify the change from Andrew's
>>> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
>>> on most patches via the catch-all MM entry. David prefers not being
>>> added for mail volume reasons.
>>>
>>> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
>>>
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> ---
>>>  MAINTAINERS | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index b68bc3626709..d7cfb28a9029 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -17720,15 +17720,15 @@ F:	include/uapi/linux/oom.h
>>>  F:	mm/oom_kill.c
>>>  
>>>  MEMORY MANAGEMENT - PAGE ALLOCATOR
>>> -M:	Andrew Morton <akpm@linux-foundation.org>
>>>  M:	Vlastimil Babka <vbabka@kernel.org>
>>> +M:	Johannes Weiner <hannes@cmpxchg.org>
>>>  R:	Suren Baghdasaryan <surenb@google.com>
>>>  R:	Michal Hocko <mhocko@suse.com>
>>>  R:	Brendan Jackman <brendan.jackman@linux.dev>
>>> -R:	Johannes Weiner <hannes@cmpxchg.org>
>>>  R:	Zi Yan <ziy@nvidia.com>
>>>  L:	linux-mm@kvack.org
>>
>> Want to remove that one as well like I did?
> 
> I think you meant the website and this is the mail list, so it stays.
> 

Ugh, don't review patches on Sunday evening I guess. :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

