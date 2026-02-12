Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B14EE36AE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29426B0088; Thu, 12 Feb 2026 12:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14896B0089; Thu, 12 Feb 2026 12:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16CE6B008A; Thu, 12 Feb 2026 12:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D340C6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:41:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0FF8140199
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:41:34 +0000 (UTC)
X-FDA: 84436521708.13.26751C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C000FC0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:41:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7gNpwaA;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770918092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjToiVfRxyGFw578ARcPHb+sxNsEdkOEvYYHXzhjx80=;
	b=Cx9pHWDoANJm5BUrwmUwPwYcaJc7gSMXC+FRE1LCbBtb3AYO5hw0yxKpXdOGyNqLPNrBzn
	7aBNfwXx3cCPjpH4u8PfwM/auEiZ9islnQbw6vjCG6RVWCmnF0/EwJXbdFhkzlvCsaAoUz
	7BbI3gZ7GokHYtxmaQiVfLQJuBD5L98=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7gNpwaA;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770918093; a=rsa-sha256;
	cv=none;
	b=XoYZHZ3AOGmrIjoB1LqoRyr79NpWm+oaRRBY8Rq72HBLjbASvG5+fCQA8zW+pBW98vdGh2
	Tpqy3Q+Vc7ddZhF/5tQfMpWcWv72aI8PddB8G72+rDAM/MDzxu820trMYhXRFi/dFC3B2T
	pTMLtmqmLoobwfWZjCOGA3s8CySsft4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 811C143D3E;
	Thu, 12 Feb 2026 17:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319CCC4CEF7;
	Thu, 12 Feb 2026 17:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770918091;
	bh=rThKwuhqeHE6/YX5ZCTM5wYYMYdYPYEz2mRRycqzuJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c7gNpwaAGu3v8V8JKKhdvsnAJ7M3uYF4H+4WYyFcaGrM/e6D5pDKcQ7zv9qubIZ2F
	 E03EaFYFerXfCFN0xVLpHyQE/vHUlKpXF7P98kY7qBsk6UJxT5GVgTAMfHw6ECFTYO
	 yYsCnZz6zhH/3XkAOqHSGbtzee+l2M0lukYIj9Bxk2e3pMoM77KSIDebUYBj3O6Rta
	 YxNcXjaLAQ4ZjmJ8f7HXzpMVRA1YyPqzhb9NUSf38nAa/qXxAzRQV4j3aCgdmGpfpD
	 t8GoxZq3KODybfg6ZUp9/oBTcfiRDQk6KEE0DjoNs8hdRzengcnTxtla1QqWzG0l17
	 hxyw8BO0Rm5Nw==
Message-ID: <3eaa8d64-cc64-4e49-aa80-a3f029d63993@kernel.org>
Date: Thu, 12 Feb 2026 18:41:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
 hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 len.brown@intel.com, chengming.zhou@linux.dev, kasong@tencent.com,
 chrisl@kernel.org, huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
 shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, baohua@kernel.org,
 bhe@redhat.com, osalvador@suse.de, lorenzo.stoakes@oracle.com,
 christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
 joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 rafael@kernel.org, jannh@google.com, pfalcato@suse.de,
 zhengqi.arch@bytedance.com
References: <20260208215839.87595-1-nphamcs@gmail.com>
 <CAKEwX=OvuVPJzQsSQm8F+zsRgJFnbMmW2JMJbGebp=U8+jMRYA@mail.gmail.com>
 <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org>
 <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: zh8i3wnu66sh1aqx8qncmxsdc5brqhki
X-Rspam-User: 
X-Rspamd-Queue-Id: C000FC0007
X-HE-Tag: 1770918092-19426
X-HE-Meta: U2FsdGVkX187YN6TkEWRp4x6KMDwRKaqjczZLlweGCZrtvxUIiEkOWZUzjKLVzZSbKppevk9YYcq2lLEI/avX9+4JPG39p/pfN5ZZj4TWvtdlY3sl4Q2qVDVqY3IcA2azm3DpFo8jkSrDDfR1eqaC9JxpqNjbOdQxhfe98muhbLi8q3SjfTg6706Io/RiYbmVmYav3U397IE0Kcc1FjvivW6Iiv7iKmViBks89S5Z6465JlwjiRQ+2F3mPb/NR5hrf79CqjnZVpUlaL7e3/HlK2vritz9VCyxXG9ZEhhMnsY7DxNWb5W+G8U2V+EnqjFBjMWOv8UXioG3kODAtnvsJLkB1/pp5RH1mQtWbMTM0DEdA8IO06+ZuIxrLhQg0pi6R2a1R48jF1Zdx6J57PZ7ElPWErmneAIEX8CtY/pTrTnzO/4kL4CB1x+3sAxQMn4tox739l5qhgoXlAd4gZym7zPjH6wbKLsuMQ98h7yBAfWHWg3kES61hsUrTanghiKNOkQ0FL9tpC5duuDn21Tb+Tk7EPkC6uuJwSvxKizqGx3Z1SMGMF5/yzjSmaxza7u57Dwn9lOmwyW8xcS+XTXd6c2U+XBOWV1zkIoJVNSfD1MLhAfc0H2duHqYgF11firYQrJm/+Ji738R11eWVNNJgptrSLhRlm0fhZ3UYnLuQ45gAuMAehg8QBFNBn3+tKBXXRys6tiK4jKwibguBoZfw09xUBuupgecZPFz9e+xAYVrkWfiqp+M3wuA6EwvSmG9G25Azz/e/cRNLEvJ4/TGfOcHmCl3BQzhSSW/R7Du/N0I4tdZtzNpB4T0AC4BrnzninIxpTIpTcNuQq1ctcxsXW6noPO0Z/15IqKPzYxq3csoUBOBGjTysexIgWlPqIC7nKV47wSR+9jZRpP1iSYhHq6OOmDi18h7xBwRH0TqjhKub6Ga3CVyvTydyWUlhfqmsX/sXt0ZMtJN0tqKE/
 Vp6wp+df
 sQ/WKG1Hs48DmWxXCYQsaf0R1nRqXU4WDyNiChpB7BgjuQwOD+Nprb+7GeSEOM9iH2pDFx+ikZ9mvlOo0q8y9ehBAVVvthn/LbNQqn1G+y9fXLJdAsHxbR1uDmEdy1tWRKZcf7cCjifIoB6/KTwinI45KprF4pvuWJW0gVHCjYpwg13GNynn8kwFzbrgiYro8SnQHu+b14RErTIUvUbbmupNHylucmUNPtsWelj1x54tYlAo4gHBaaDKGvGXh2nH0LMdI+oJYUnXV7C1e95Upe3eUHCC6RpkmWH5TfJJlFS0V1Azr1Ess2Qi0d8rGesByAAqs2lA/iwxFdsjQqRT2COHxPeDmHP04Srj/wEsBnHdykH4udeMdxIeL44VlcAYESvBc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 18:29, Nhat Pham wrote:
> On Thu, Feb 12, 2026 at 4:23 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>>
>> Are you CCing all maintainers that get_maintainers.pl suggests you to cc?
>>
>> --
>> Cheers,
>>
>> David
> 
> I hope so... did I miss someone? If so, my apologies - I manually add
> them one at a time to be completely honest. The list is huge...
> 

I stumbled over this patch set while scrolling through the mailing list 
after a while (now that my inbox is "mostly" cleaned up) and wondered 
why no revision ended in my inbox :)

> I'll probably use a script to convert that huge output next time into "--cc".

I usually add them as

Cc:

to the cover letter and then use something like "--cc-cover " with git 
send-email.

-- 
Cheers,

David

