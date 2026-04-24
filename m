Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52AF1FB44C6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A536B008A; Fri, 24 Apr 2026 03:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B8D6B008C; Fri, 24 Apr 2026 03:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAF36B0092; Fri, 24 Apr 2026 03:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCCB6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:41:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B56391A0845
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:41:08 +0000 (UTC)
X-FDA: 84692653416.15.7CC71CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F29DDC0012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:41:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YV3Tm15x;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777016467; a=rsa-sha256;
	cv=none;
	b=au6nMg3vvSVREJD/GAj35P9N9xDGa4Mc0cZ927CwvHnMk+moVHXniC/z/s1vH/jVIAAgiW
	g2QAWgC0RuxUryULgNJsz7W/asfB+rYI82VwJtlWsIm+flXyf9a4bY7UxqLQJlc9M7QMhq
	O4f87RrzdyYGFMLz/VguXIeyojx913s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YV3Tm15x;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777016467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WW/VRMTO/HXi9zp/ZsQrNZQGyu7oJHyH6j5oCCRivzA=;
	b=pC5C9Nf60tqZ34Gvc2x2WL++Jz78BESfZUyfkTt6PY+GeEEkXmdFQYPiMxBxzuhsulHgAL
	iEUwXUnPnMobs3YtOSbzFscOP5Fq7sQfecZXJcBQyxUbAo470pyhvBcj1j1jhtqfjuxlTm
	cDMdmZnEWt8YfbJf0ONo8+X7BBVyClA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 532E160128;
	Fri, 24 Apr 2026 07:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E4C19425;
	Fri, 24 Apr 2026 07:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777016466;
	bh=3rB/wWr7rqw/j1uEBolZQokNV4lOe0WlNZrmBF3V1u8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YV3Tm15xoAmLGQ5bSLY4D5TJxsgXWooz/RG1cwy8Mu542xdrgJGNcZhHvlGnRPwZe
	 MRI3aIQmUCwNiBcr4eDYjtW4I3/GSZi0GXFonATgTBgpVbu93jkMybCexcLCk7cQzJ
	 kaSHLcvscf860Nvfg026aw29iz/1NL2KmlsB5UFp5nf+mzZ+sP0YBHHH+ZFjB5NIBI
	 DlW5CC3pBJYXWDyGFjB/RAx3rS3PQFtDXUBjn/GuN3caJE3PPYshhmuVDoJh4OAatC
	 y6FYrt8dNO/2mU3HYblY8k6nXTDWiJ/jhvaL1dqf0bDeb1oqT71JcuwWkyoDdVhe4O
	 SaEt+0UY2z6nA==
Message-ID: <dfb0e367-894e-4230-98f2-8e5bc554d293@kernel.org>
Date: Fri, 24 Apr 2026 09:41:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill
 support
To: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 akpm@linux-foundation.org, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, timmurray@google.com,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka> <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka> <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka> <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka> <aeagUxlju40rvkYQ@google.com>
 <aenPV9ewKAzRF2Vg@tiehlicka>
 <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
 <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F29DDC0012
X-Stat-Signature: ngw1iqiy4zk7q73usghcufz9ywzfsmem
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777016466-70143
X-HE-Meta: U2FsdGVkX1+3enCBLzewUyimmUo1eylh2CdxpOM8e5Olj7Hkr3lPXgHrgWbdeBCLu04UudTEobwF3FDt5VZNsqboza1bFJUYIM2uGnNLPJ+eu5ru2Oh7pD2GBxr/vsP/blLHdppUcwM91thjInnYbwJXZb6pSYAa+M7GDcunqpNe9aRCDhH3Vr43BrAEzZB/zXiOk9jEBCZzR2q7dOA+GkwAaHgnbA9pANg4xkBH8fWQKbGScU8zRKnuGA3zJEQuoC2w43Pkaa3tb9O1CiqOxx4NqAUjm4KNYizNfkDBsRFtehi3TKhRLsNBGw2rW8zxekikVBmv39B9PxYmqaLzfRSmVT2nQYEjk8DiGYehdpjRPCCuDAZTN1Ota0y+d6AJRgxqh0+Qwh8sQftUgmXfuIsxt9wBqg8mSLVbNtpk4FQ0/1j3N4VLEifImkAIqzk3F4gLDm1nzWTq3l2wS1frr1I5cE4YKovTwsxtmzjhKLCfq+WRVgfPTv49sJV0e0p/7tjeok5Erenygb3c7t+MgjdZ6XrFry3KzrHDlPIvA68e7i7KCxRUxX2rwyGJd3KZZgfai8zs4k8dhDo3Lp0vlEQKrg64PUwX06wM3gJ5zoOIFpA9TP4cwTqqvz/KTJMY1xCkqZKJD/+n81GT272Cd05b1Gm9lohO0GyOB3bDS2OuA4r/FSdK6MVxAcZZwDwX/va63f5YzAhZ6b/k6B5XnWDgjzxAVo2M0yhyI/m8VbbBajjcYaCn3JoSGOcUMki+eloNg/AVgr5v5EKMdSC2Ob0WRf+43WdZTFgY2wA17oIp1cwBNQKDrxLiwR3XvkFoTigJTMCXUuXQB/6Kphu8+DPcreHIuCkHCJTvKzBORxkiOkxav0O/34rXBI8qPw8wg/MnAgRf2wGnlzKAhBHS360UVdVUiG7BIauCYcaJgIdtbYlCsm/AqjokcrNgv5aMSbesFBGkw4jVefQy2j1
 /XJOyBum
 Mcm0neCRyAU5glpnqiwimjvWP12z29D/Gt7sV0qctamEMMqhVMV5vcdRJ3Zoyx3nbhdf5KHLVIFnhrzNDUTEO46oNiNeo5rmy++k+6OUGW8Tq+DZTQkbRqAB20LV4VsdnTps0aPNWHuXiSGxx1VkRwQsl+9aCc7gnalJZ4+duYEhF1f5oOotQbFboS1IfnsVF1FqO0KxqqH4RyA6oPPF1y55N9kDCDuxY09kkFwJ0LYVQkqpb5V+u1AN0AhaBZlqPXWajIXMSI1zy4A7jplVGTEcOD9DN03fRMfq3YIKouVArrf8i7Dl9eHBrQca9Vhx8F4CkVIoyX2BreLVe3/o2B+WQidjDdFAmG+t0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 00:36, Suren Baghdasaryan wrote:
> On Thu, Apr 23, 2026 at 2:50 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/23/26 09:50, Michal Hocko wrote:
>>> [...]
>>>
>>> This is a very creative/disruptive way to do a memory reclaim. From a
>>> user POV I would much rather see clean page cache reclaimed before my
>>> apps start to disappear. But this is obviously your call and your users
>>> that will care.
>>>
>>> Anyway, I still maintain my position. I do not think it is a good
>>> idea to drop clean page cache as you do not know whether there are other
>>> users.
> 
> I'm very much familiar with these issues in Android and really want to
> find a good solution for them. IIUC, this RFC tries to address 2
> things at once:
> 1. handling clean private page cache when reaping memory of a kill victim;
> 2. addressing a race between kill() and process_release() when
> process_release() can't happen before the kill() but if it happens too
> late after the victim passed its exit_mm() then process_release()
> fails to find the mm to reap. This defeats the purpose of
> process_release() call because the actual memory (released by
> exit_mmap()) might not yet be free and a successful process_release()
> would be very beneficial.
> 
> I see these two as separate issues and I'm not sure combining them
> into a single discussion is a good idea.
> 
>>
>> IIRC, Johannes raised in the past the we cannot predict the future.
>>
>> For example, if an app gets OOM-killed, wouldn't we usually try restarting it,
>> re-consuming the clean pagecache pages we would be evicting here?
> 
> Sure, we can't predict which app the user will use next, so when
> killing we usually kill the least recently used one. That's a
> reasonable strategy in most cases.

That makes sense. As long as other apps you open next won't need the same
libraries etc that you just evicted.

-- 
Cheers,

David

