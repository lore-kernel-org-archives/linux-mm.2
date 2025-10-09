Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEF3CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D686C8E002A; Thu,  9 Oct 2025 11:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DBC8E0008; Thu,  9 Oct 2025 11:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C554F8E002A; Thu,  9 Oct 2025 11:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B23638E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:32:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AC19461F6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:32:41 +0000 (UTC)
X-FDA: 83978968122.02.B440792
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7EF7820014
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:32:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dvObJYKt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760023959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ar5DXhZwopHAzrQe7Nhnw3uLFpeXIHyKZmHhawwMIWU=;
	b=ysuWnn0cE2iGdFzhw4C073PaNuSJGLJgRWORORSi9GAHtmutrv0jNIKYhqexSQ4AErhyqp
	lHCOyOayFqhY8fG8GykVIJFFLS2p4NBMa4ICpLMyN2hWT0fD9nK9olJSrxCXfoE1h49TbE
	iOQ72kWLaabEd92FRmtouVFID6aYFWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760023959; a=rsa-sha256;
	cv=none;
	b=ndgvxKw6Y5EcoZsvi5u8JQoUQcxe44hkYBpHwGGV27fLZ3xkqtYvGzHUZ16UzXd+lXhLiB
	M6b1xV4nr0887vj8yMfVueFC7zvPb2N+UHgwRKMViOY6BprRn+hxU04iZ2kz/fx/010Tqu
	gBzq4nWGIbZNeKGwYZkyeB2Qg4TY4CM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dvObJYKt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760023956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ar5DXhZwopHAzrQe7Nhnw3uLFpeXIHyKZmHhawwMIWU=;
	b=dvObJYKtcK1ChPuL5tvzQaR6EnoAGGZhmQEEIEXoDr/1yYtpNAnUnCYHxMgj38b6l9mov0
	LsbZFVNDM3eH35oGiLpDApraYsWmRU3XCc57vv+oSVGixLEZfYcF5MsvgamAAkCTEWEGEP
	cZ4KuIePH+I1bi6kYe6Dsh5rGPJDA3s=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni
 <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,  Jonathan Corbet
 <corbet@lwn.net>,  Neal Cardwell <ncardwell@google.com>,  Kuniyuki
 Iwashima <kuniyu@google.com>,  David Ahern <dsahern@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Yosry Ahmed <yosry.ahmed@linux.dev>,
  linux-mm@kvack.org,  netdev@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  cgroups@vger.kernel.org,  Tejun Heo
 <tj@kernel.org>,  Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
  Matyas Hurtik
 <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
In-Reply-To: <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com> (Daniel Sedlak's
	message of "Thu, 9 Oct 2025 16:44:04 +0200")
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
	<87qzvdqkyh.fsf@linux.dev>
	<13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
Date: Thu, 09 Oct 2025 08:32:27 -0700
Message-ID: <87o6qgnl9w.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EF7820014
X-Rspamd-Server: rspam02
X-Stat-Signature: j7aesyyhfbex3jti7jsfx5inawerjdnn
X-HE-Tag: 1760023959-792467
X-HE-Meta: U2FsdGVkX1+Yti80rpULGYkIhDR1fPRBPTn9w+ScoA7JATeyR2Kd4kqfQOUbUGioyWACdJ9r4VuYPnE3yi8Mii+xKizuAmavXDWkANb5uBk6qhTgA8M7BhtqbcUOlMZ4KA5rY611WGWxltICaCFbzrSN81mDgfc7FK11qfFEkG3AZzkhc1lxKTGII86ZxSOcyctTFtR7xeYqCLrgLtpbl95qP22OYEkL4SFtJcPaIVI4y6UU+bDsatspPePZBPzCVtMGS0jo9lNpn+7sldtnj/kW9XIChLCEqnL9UUDFe7bsT5GYQGUEMSqUQ89YYHwdY2kgoaPibBjKigjni66hNPwrzqzxA064W/1NVmT6LYkfrjppFsS1q5sTre9F40ewRd3cMbHqmBe9c3hvvzN/kmgKxtmDgW/FpFUYv3taIufdCHSSCEZPeDsvz7cBz0zdICJYiixppxJUuXJu81cMwdDhlUXHsk4P+au7LLHM0lSbbxf3uvSaaeM8rf3yzVKItExFhu+ctwIpPgJ6H92GSURw6KzQ8cLZDRo1BWUvWpVlHlH2WGz/vL3cKGYlJXCzjoLw1FY+jZA1qP4n0WgFybYFAKjzcf30OUidm/IugcKrBatkF2d/Y59Non64qGl+sjBGMuMdkI9A0iGupMCuC3scUlX1gczoqH83EyOGBK1OhMDPbAMsI88/mG0PRomqMfOUrK9kQJrLx3m/8tgeW7eoPMa2Sn8E87Bw5ok0tAbpVH3UqUzJDmxPipJF+U7Mc2awJImYkD+sDAJGH4v24T5necTeES9GoJasna26e420XDo6dPHXpEPj7djflcHkA0AUvnJvQbMqNTM6YtmhshUZaOAPk5WZT+QNHdzmVnDYGMYvLVfo7GSV0YM7XrPTr9cflzsgHbsRRktx+oc3nvX3l2RhaWcMUmRQ8HSsDbagZ9oQrGeIDU2ZsssuFReIBCXE3K3Hg92O1BY8uwW
 10DYBC5D
 9AGTCLLdk9YIa0ntmLl7yDa9ffkLLSfDogAwTnax1OOkq5sRJRjIwsGzEeKzEem/43W4Vv4ek29IVHU3XMZ4XmaKbTGFBCldiVq67REnCpt9DhguLl5VzWC3A8V/n9cMAU5E7OsI4Sc80oYB3nmbIPZd5Gcsqc3OW6R5zVe9/l91PuuReG7GyyTo/FObc3AY+l4c6g+olyPXuPqttm2SI5N6Gs/thCPE50WxZsK76xWXGetAvAbID9it2bnWzvNNCyAxsWjl2ZoxOW03X8vMFzUoN5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Sedlak <daniel.sedlak@cdn77.com> writes:

> Hi Roman,
>
> On 10/8/25 8:58 PM, Roman Gushchin wrote:
>>> This patch exposes a new file for each cgroup in sysfs which is a
>>> read-only single value file showing how many microseconds this cgroup
>>> contributed to throttling the throughput of network sockets. The file is
>>> accessible in the following path.
>>>
>>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>> Hi Daniel!
>> How this value is going to be used? In other words, do you need an
>> exact number or something like memory.events::net_throttled would be
>> enough for your case?
>
> Just incrementing a counter each time the vmpressure() happens IMO
> provides bad semantics of what is actually happening, because it can
> hide important details, mainly the _time_ for how long the network
> traffic was slowed down.
>
> For example, when memory.events::net_throttled=1000, it can mean that
> the network was slowed down for 1 second or 1000 seconds or something
> between, and the memory.net.throttled_usec proposed by this patch
> disambiguates it.
>
> In addition, v1/v2 of this series started that way, then from v3 we
> rewrote it to calculate the duration instead, which proved to be
> better information for debugging, as it is easier to understand
> implications.

But how are you planning to use this information? Is this just
"networking is under pressure for non-trivial amount of time ->
raise the memcg limit" or something more complicated?

I am bit concerned about making this metric the part of cgroup API
simple because it's too implementation-defined and in my opinion
lack the fundamental meaning.

Vmpressure is calculated based on scanned/reclaimed ratio (which is
also not always the best proxy for the memory pressure level), then
if it reaches some level we basically throttle networking for 1s.
So it's all very arbitrary.

I totally get it from the debugging perspective, but not sure about
usefulness of it as a permanent metric. This is why I'm asking if there
are lighter alternatives, e.g. memory.events or maybe even tracepoints.

Thanks!

