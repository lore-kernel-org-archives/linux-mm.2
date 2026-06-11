Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7FFCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26E06B00A2; Thu, 11 Jun 2026 13:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE146B00A3; Thu, 11 Jun 2026 13:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B145D6B00A4; Thu, 11 Jun 2026 13:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A19906B00A2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:28:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E3F09110A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:28:52 +0000 (UTC)
X-FDA: 84868316904.10.4080DF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61D89160011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:28:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvfxdP+r;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWs4bm/rOcWxeVbBEoGSUteHdOSPrbhiev/2SBxgXus=;
	b=wB5JLuyqZp9fvtxxDko0UvUa9ig91+377zrOsdSM8iRdsaeGKZ61RXtXqCPPEdTo7tuPsZ
	JO0FtyJhML0cVD6i4jR8EE2vwW+9O5432HV/QCzDpeu5ZLS0dN6yvdLwYXqNSFQwSHh0g2
	XxAaNn9AdVypyv0eqxHiPTLpH/T70lQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198930;
	b=p/6xn/2Ujnxm0rpZjon8fH/9W2lgkgpKa6hHV8G0KCmwG1hre/DxIpFXIMbI6qTVYno68W
	lsxmABjzcirzcN6g9eUl28ouJ5jT+ixGwITg1AHe3pC/6TRbi1TdfcMXzNzSUBGhI7oRFG
	NvAL1o5Dfum+PdZnJSodEA17sIBFgeg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvfxdP+r;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 405884382A;
	Thu, 11 Jun 2026 17:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49561F00893;
	Thu, 11 Jun 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781198929;
	bh=HWs4bm/rOcWxeVbBEoGSUteHdOSPrbhiev/2SBxgXus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DvfxdP+rbImPjs+2h+C21lPzXuRX4C0yT6SLl7vKFldC1J+Q/me6bzhPFwbna8XY3
	 Wyci5XeHeNNTOqp6paVMm2A+/IWjG/m9w+csAwluBo8fpx+SNHtDJKR+y/S8tFk7pS
	 /RfvimMU8vZZVGlXjNHJmA2dqEnmb5/ID0t0v3/37aRvZWaPcKjvg6nni2EPlYvp1c
	 9TBhr7JZVOx1x8epKau7hI9/P/nOz6FIGDskte+RRiFig/yM6H5XLE/zuLf1GZ7PUf
	 6MC9uRz0Fp6s1QQce7hF+NayIFQCsGE4KIcXAPy+jxg2LK1CLwWHruYPM8zwdihy/t
	 Eirz2CaOmdZrw==
Message-ID: <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org>
Date: Thu, 11 Jun 2026 19:28:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
Content-Language: en-US
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61D89160011
X-Stat-Signature: m81tf9nj1edg33u3cui4rohzgjus5ne5
X-HE-Tag: 1781198930-195490
X-HE-Meta: U2FsdGVkX18cDj+DhMUl7EWJTq10YrU+toVxWh6uhtG+r5JfgXSrky4boCORF6sNpataJHyDUI66MYJRiYz7HG82JXZS9ejywdibRqaf/X4J9OXxshrc0xIbrajXtm6xsy75Ay+mfqrH7FG9Wg0LZiGa6rWlhvSUIYMvHSsL7YFcLBhNla2BgAxagjMWa7fyWNvSpi5Q+nyBNDjIwajKI7kaW5Ebl5JLbKTZKf+9i053VpQ/2dcIIFhrH+r/HiEumNe1rCSXHxipQLKeIV2XOA/Xag2HmyHpJ0X27Cuiq1EykX4jpWJrRKEtciFLb0rm+7g2n3P2vz+xfh2rhketvMsYkyLtPeETaXXZnfZ8hEG320xrMTFG7Jiayeg3KMvvz80NGXu0WM/66PRZ/45/yo/jeUE2OtyL+m5/4q79fQrvSLzN1ViW5Uf88zy/PQQtvqmqDbYQiGAOj0CkCMbJuWhpI0Jp3hgo9bDgbwKI0D9Wyl+YQjhZ4X0gRCUqvvHqVj89rEVssIVXyWY1YKrS5mOPuNZu4WFoep2Jia+ZLkBgpkXSSMoIpntwrfybhO8gw/Rq4x5/vLv9azuuueTMLxbAz3r4GyxNvc1ID2huJ1HCdTM2gIWsM4++gERi62ijcB0ZCxkWFqn9scOmfDQqm7EXyob/ih2T6OoaSA5oDSLV5ZF7qyWjjsu5UyMKo9BwnAm3Gavp+0+qcf16phuddXPV/oYtGYHhwjKQInloVMUPGSUb5rwLk0RezK4tTmnx56Kq7AoGITIDDEMW4kgp7iCgt8EzOcoup+x2NIrEGQMib2qhhUYNtHZKzILKyWnESEsM99XtjPmcwr4LMr4sgWfuOw49W0ZH9g5laWfsva9gLr143zob+srBDS4PJsSKN33oNDoDmA2RjVT2yDZ1p5Sugti4sm+ejkht4PQDL71iuqg/3ufnpZ1Rb2ZsMoQ31L0LSwpjrW6t1P5Wyc3
 pE2lWG0u
 HwsA7c7Ub+iFx9NfYaPY/6biHD0cGVC8CKiZ0gS0aXjEtJA6sW40UYsYEaOCFsGSQRPg4X8XuuJaa4aDj1c2sy5rppXm5KJ0cwOhjw9TBmFoWn+LX87O/dtWSmoT5NSrFNc/Q9yntBRGnKYSfw7BAxoBsSsTzqDKj4FFxMkpA8LAmaEsFW3oZRcLbIlZYztcww9PMx0p5rInkyz7HpWSRUGwKG1A9MfkAdU2PD4o5AQZmxZ4IQDOffoCcsxuji8tyK23N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 08:39, Pengpeng Hou wrote:
> SLAB_STORE_USER currently stores one allocation track and one free track
> for an object. This is useful, but it loses part of the previous lifetime
> when the object is reused: the new allocation overwrites the allocation
> track, and a later stale free can overwrite the free track.
> 
> For free-after-reuse bugs, the report can therefore contain the victim
> allocation and the stale free, while the earlier alloc/free pair that
> explains where the stale pointer came from is no longer available.
> 
> This RFC adds an opt-in SLUB debug option to keep one previous completed
> object lifetime. The option is disabled by default, is not part of the
> default debug flags, and only takes effect when user tracking is already
> enabled:

Sounds useful!

>   slab_debug=UH,kmalloc-128
> 
> The series intentionally does not attempt to infer semantic ownership or
> identify the root cause of a use-after-free. It only preserves and prints
> additional track records that SLUB already knows how to collect.

Indeed, it would be generally impossible to infer I think.

> This is sent as RFC because the user-visible interface and the cost/benefit
> tradeoff should be agreed on before this becomes a normal patch series.
> In particular, feedback would be useful on:
> 
> - whether a separate H option is preferable to extending U directly

I think before we converted U to stackdepot, the memory overhead of the
stacks was higher than U+H with stackdepot. So I think it would be
acceptable to extend directly. If a user is willing to pay the current U
overhead to debug something in production, the addition of U+H shouldn't
make it suddenly unacceptable.

> - whether H should require U, as implemented here, or imply U
> - whether the extra per-object metadata is useful enough for this debug path

One could think of scenarios where even longer object history would be
needed to find the culprit. But adding one extra lifetime probably has the
biggest impact.

> Not included yet:
> 
> - KUnit coverage or a standalone reproducer

That would be nice.

> - object-size/order comparison data for representative caches

Could be useful too.

> - runtime benchmark data for slab_debug=U vs slab_debug=UH

This is probably not necessary as we do expect debugging has a performance
cost, and this is not doing anything extra slow, only copying the previous
tracking info? In practice the overhead depends on the workload anyway.

Thanks!

> Those should be added before a non-RFC submission if the direction looks
> acceptable.
> 
> Pengpeng Hou (5):
>   mm/slub: factor user tracking metadata size calculation
>   mm/slub: add optional previous lifetime user tracking
>   mm/slub: print previous object lifetime in debug reports
>   Documentation/mm: document SLUB previous lifetime tracking
>   mm/slub: sanitize previous lifetime tracking flags
> 
>  Documentation/admin-guide/mm/slab.rst |  22 ++++-
>  include/linux/slab.h                  |   3 +
>  mm/slab.h                             |   3 +-
>  mm/slub.c                             | 118 ++++++++++++++++++++++----
>  4 files changed, 128 insertions(+), 18 deletions(-)
> 


