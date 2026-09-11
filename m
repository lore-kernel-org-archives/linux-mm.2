Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E5BC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACBD6B0095; Fri, 11 Sep 2026 12:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C834D6B0096; Fri, 11 Sep 2026 12:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A2D6B0098; Fri, 11 Sep 2026 12:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 988106B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:57:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE4271C1DBA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:57:08 +0000 (UTC)
X-FDA: 85202086536.30.DB1E906
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3EDA31C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:57:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D+uQTn8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D+uQTn8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145827;
	b=DKiviZQjqx7DYZctUSM9psX5njbl3OOcYKZLZzsWrJcCoqL+TCKodPyy5yCgBPJNfi78/t
	84+CTfh3bVXxZ9hkLsRX4LQcayyiG9GncHNJFVnp567Ugy/Oul+E5s99TiM9BTU5SCy+R9
	38Fs4x0inNzOdZK7nbMkEjj9jknpJeY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCBzYIFfSdzdVkwkMBE3J+K3xos/U3vU+XIg0PSx4Ss=;
	b=KXZPwx/Iic5LLSJtI1omDTThfZSsls+uRoXEoUKOvgaDToD/A1tLo6mG9kN+MHXjbPCcMY
	r6kiT67FhFy7ieRWw1HjKpd0fPXsHUhrtCo+S1+GbhO2jwnDQZZ55QCgJ04UJ9sjgH+Jrp
	8RJ+mtHpozTCIEL/OvJd0wgrO9lIxNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DD7D60008;
	Fri, 11 Sep 2026 16:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D9E1F000FF;
	Fri, 11 Sep 2026 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145826;
	bh=CCBzYIFfSdzdVkwkMBE3J+K3xos/U3vU+XIg0PSx4Ss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D+uQTn8J9UjvWNZ3dExwHHIHJ4paSJPSwyKONrL+rFV1TQvbwEjMm96PwplVEfmEh
	 2iZimrrrHgIEpTaGO3a/lWB2PNSaaybBdP5aIrOg/uazxsHnxzDgQ8Ru7shWDrMD5k
	 UMo3WjqrxmTTDJuKdIimEGrgHJjNJKjo54LvTQoHqaXJuc9Fb5xTt38cJRKuvGHbQS
	 H7nli0AXP86VsDtIa0ojnr03+tmEKdVIjX10wM0PY2qb91LxwPt4NuW7pTW42ooTIL
	 OYnzhhs7Ov0jK521kZjB35o3W9Rooxf3acHi5VL/8T5+nBKxanx8QIXrliZzm6NfOs
	 AAG4S1RYDQRLw==
Message-ID: <89356640-183d-4138-880b-332a05f93f10@kernel.org>
Date: Fri, 11 Sep 2026 18:56:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, David Rientjes <rientjes@google.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EDA31C0003
X-Stat-Signature: o4knyio6rd6tfxspr69gdho4p1phz8et
X-Rspamd-Server: rspam01
X-HE-Tag: 1789145827-912074
X-HE-Meta: U2FsdGVkX19FAd0ERSQqXeRQsgITlv/TLVGLWWCD9U4YYBkzGuS0GAxAO4lvPoouHHncZkLi9QgEfgyJFFxYoXVYb6QOtM+AqmMg/P+k9zKv1NdAAyPDAao/PI5cpgLeYP7ROgjfwWurIeeVEk37YG0CW+mE1NoDGapCNQH7g6tE5KsQ2y7RjSmsbJFvjj8ZhZZLmvsztgV+dXPzs9lzLbEfOcn9yYIsPfRRuGhuzhN73lYKzA1XW8hK8I95gMDj484iuZs1F+IWHZ/zUHw9QP/mzppHby+kSQ2xkaVJzlIYj4sTRQ/JJdC/B8B57NWHUHuzaCQUP/ScCw/0lyJEAJDBPc8yc7soO/Y8YKT1xkO5NRI6OKhF2ysdunThoP8D03Zlrjcz2ZrUX2az27WuoJIlhlKukGMat2uK2VY1gTUl3KGV8BjThwYVBQka+GaWJN6BT5O9fmcrbxwgto0F7SxD7o2tbDgtH49nX4cOa2+DUg9xk3PfhpQnmZdfG4lqRRt/dVoc5ty0A8hb6dH8I9Ghq/adUxP5fEr8U/V8sIw7e8HOzVpFzPkWLZ07RFS+XXUCaTqCe1FUVpjVxMTSQnrP3YxlU/ESuW4S6ojNNXKrUMO7px8t75BIgeZjnETewCFyAIJmkkki3tqFR1aDMz5UT2cH0DCBAUVywjSBS0DbEq2M1km2nN3Plhuy3LW+mzFH8b9+gcBpkjWqXPOVqh78zgeIWWq+N12xTIufxH1WgaJmRWbKirJz+2AhqS7baFXrO9pVdikr3nkvL2Xw+2dPoD7mYRWpWd42tSmymuvrlLw5aJcyakZhLbAZ6GTUUbDvBnpwgDmrlJXzLIG2p+LvZEQZXg3iC/tBMmvlwmXnHehDUwEdEIO3KN9rcgKNb7wqjiiET08eKDNuPtGn3x+goTGf47lNoL6ZFtM/UAyMxNFEx7n3skfuQQB3gpE7IZOZgLO8s+/MPC7H9/b
 40uY2hJD
 zLIYB7EKlSoIl1sQqBNBGE7MW8XGn/PBxf8RQwWuwZKC/rKzHzJwwZW4X9r17+XZOi9Eqt0d0nsiWO6Mnt2lWaSnx5WfYdLg+Dvh60MGDcAbJKOe52hkMNbplGP8a5IUzlKW3aiu0lsQV0wPM/WrzNCE8zMvERkEspKUknJDmRC/RhtmubOltP5SN8pmJ0rbHP/BJaXwmbCSWhQl/iPORJsOzqbhK75oVlJ0oHv/9AtvWttw6eakREzfkpnj1TBndvXozWCwRo0nsUjwB9rjEUhY9X/wbV4QiTOcSwWgil1pZ0mYtpQx41XqyFk2l0C9CF9Q4TsZGrBIbhqszUzfW1VFJyo0olmhHxUeclLCRSIaEEIoh/pKIUojDXShlRacaLjwrKC0H3wtM96jsmoaZZOmmIi6/AXR+wmwYhefzBZIcGj+FukGJhUdtuEi+B44sLFjM415k49iMxRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 18:20, Kairui Song wrote:
> On Fri, Sep 11, 2026 at 12:23 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>
>> On Thu, Sep 10, 2026 at 3:57 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> Hi!
>>>
>>>
>>> Right, and conferences usually don't have the capacity to squeeze too many
>>> swap-related topics in, so it would have to be side discussions or BOFs.
>>>
>>>
>>> Yes, that's an issue. I'd suggest swap maintainers take care of that if they
>>> agree. I could try as well, but it's rather tricky right now on my end ...
>>>
>>> As an alternative, we could also use on/two/ ... slots in the bi-weekly MM
>>> alignment session to talk about swap. (I'd be happy to learn more about all this
>>> as well)
>>
>> That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
>> PDT Wednesday, usually right? That works for me of course, but Baoquan
>> and Kairui (and other swap folks) - would this time be convenient for
>> you?
>>
> 
> Thanks for setting this up!
> 
> Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> UTC+8 folks.
> 
> The time is still fine for me, though, I tend to stay up quite late
> anyway ;) so that time works fine on my end if the slot is fixed.
> 
> Is there a calendar invite or something, please send me one, I'm happy
> to do a swap sync discussion there.

Let's get David R. involved.

@David, we'd like to use a meeting slot for a high-level discussion on the next
steps / future for swap. When would the next be available?

-- 
Cheers,

David

