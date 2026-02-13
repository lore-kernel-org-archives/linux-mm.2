Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1FCEF99E0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 21:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC65C6B0005; Fri, 13 Feb 2026 16:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73D46B0088; Fri, 13 Feb 2026 16:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85996B008A; Fri, 13 Feb 2026 16:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A327E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:43:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FCCD8BFB3
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 21:43:18 +0000 (UTC)
X-FDA: 84440759676.14.CD5726F
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com [209.85.160.194])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4557CC000A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 21:43:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDTSzBzd;
	spf=pass (imf10.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.160.194 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771018996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr4En5251tETgtYzeFZ5nnuFAQ7w2oyqC71nR7DQ8Wk=;
	b=AxTpX8fpzWsmiE9h863Bz7RwGlBGBwrJ2tA26F31IdiC9MZbeBphxLFCKPUqXUA3oF81F7
	pEGEVcMMwsoDCeu0d+jEa2tsZYDNPB/FKGVvrVHqDP0nflTaDWQmDvea3Vr5XbntZvZPcH
	YZBXhbCodC8HFagSlAuVRVJKiiGE2Vk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDTSzBzd;
	spf=pass (imf10.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.160.194 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771018996; a=rsa-sha256;
	cv=none;
	b=mvASj1Qzd+OWjG0kKqAMPT/zIMJWt+re97bx+x24O46awuWacWejPk1+fjSVJalO8XjIBY
	5ziybszroztAumOCrFsC6yTVWOc0zLF6jNenB1qyg7tj8aAx7/PWnggCE84MRhCyGKG++i
	UAlRZN/yOsjgNMmBScJmgE0Oyjw/jVo=
Received: by mail-qt1-f194.google.com with SMTP id d75a77b69052e-506a8eb4886so8710541cf.3
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771018995; x=1771623795; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yr4En5251tETgtYzeFZ5nnuFAQ7w2oyqC71nR7DQ8Wk=;
        b=MDTSzBzd24bksC8M5WEH4iT9BV9PY8Abt2npzAFuBiNpeHFyJfZ1Re6F0mt50Q2ni9
         8CDdbgYS12Nk1ZQjH+HnqbbmgLepLnOVgWBzMbTi+f09PQp/d5EPMSLaxCjcE4CPht8f
         xAQR/enO0QkuAAxJvwVDI+8CJ8kMtXX2UnTIrpu7Igbgbk6V5VZqVJBrk81Eg6kAbhcN
         Isf/UyLsWJurKpBAgK5CB14cSZfMDgPet7woAFe7S0Cfj9ecrks0p+lCYLd2okFobynS
         hjavF1SSHjVrxSuS84mVZh3NYqhKOsOLSV/jZESj1wp+c27eAd5W1KhRQFporlLlvZ+n
         2Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771018995; x=1771623795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yr4En5251tETgtYzeFZ5nnuFAQ7w2oyqC71nR7DQ8Wk=;
        b=NP+HeFHNhdp0sKLtfS8vOsLY/JYMNbMThZ7Bd3GMR5kKQ7QSEM7ZID0EtzJTvqry1T
         4Gr9WTh8m4xB++8UznlPa99Nt2Ad/yEuh49difzV8RHI3pcF/BhP2c7TtY2zjKbRiRYr
         F6jlVLezZixWWpfStsHJNaeIwWgDK5eg/IeN/M79JRRMtueqzR7U8u/ZIs88ApRlRBlD
         g8aMmRATJZI955Cta/OEJogV0lgL3dmgWpOP0t6A4OGW5A9OjydcnQ0czX+qGHTG4N+1
         C7xegAwq5PTBgRkxNc6QeUPQ+rRjx8QtBs7PBGwOoeEacTddj6jWW5cvcspnOesYhLmV
         1Rtw==
X-Forwarded-Encrypted: i=1; AJvYcCUI07DUSN4vpG5TCWB+molrReQA86Tgap1gxhEL7UUSX+h4aohmLj46nBJHTIez2gxxOMYF/VLkQQ==@kvack.org
X-Gm-Message-State: AOJu0Yx62z0idURWx1qgk0KQnATMgQFUDfYwe5kY/c2DIDxkUMm4glMw
	IBGVBKBztmGDitBVTpR8rcLIQxGSnsgVFRiXvLp0xiS1wL2VV2KaBjJ3Q5mjhmY+
X-Gm-Gg: AZuq6aItCNsnCIHLtLyck2ie8Vdq3LTf9MB9c3tnYrAjdGVu0Hg0Qfykx3rE72XzmiG
	2QasS6CClnr/aJRtVkS9SAldY4lflR4a5y1J7rimlG8wGXgP7iSE0TzVdn2QAdVW/03agXmMQei
	znoZvEEpykpXE/BMmbrgnkiskNOSoHkLhujeVcYgNsY+sZTgWVslJPWrMC9caxrgZGkjwiAkoWw
	ctiiFAILkcOGBneXcAuhW6QAKhFhgQAlXoG8B1DyVLMys5j5rFDJTjnqPui/GxTE6yWDk9IcNCy
	FQzwznvnO7qu5LUIew3YMXJxhzkWxgG1eC3ran1Xf6QywRgNap9cfpAXAyqF5/j6jZsKTdpqe5a
	g9j8SMvBgWtrJ4W8bm3oVOaj+H31lTNtag+sYkmQFuvMnQy1JRACGomiRauMrS/9hKMTw3xsxVx
	tUy4Uxbzy1fMdQVamRGNg9vLBid7P2A27f
X-Received: by 2002:a05:7022:618e:b0:11a:f5e0:dc8 with SMTP id a92af1059eb24-1273ae30dbemr1295141c88.28.1771012577689;
        Fri, 13 Feb 2026 11:56:17 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a69cc93sm8742855c88.6.2026.02.13.11.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 11:56:17 -0800 (PST)
Message-ID: <fd56ae2c-64ac-46bd-bcb2-503df995a6a1@gmail.com>
Date: Fri, 13 Feb 2026 11:56:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <96b63efb-551f-4dd5-b4a2-ac67da577431@suse.cz>
 <b5927ae8-3108-4d65-bee9-be306fb697b4@gmail.com>
 <d52066f1-c83e-4406-adca-5a403adb4f44@suse.cz>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <d52066f1-c83e-4406-adca-5a403adb4f44@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: gbiumypfi91jikhnyt3e8q65ww4euzmt
X-Rspamd-Queue-Id: 4557CC000A
X-Rspam-User: 
X-HE-Tag: 1771018996-9826
X-HE-Meta: U2FsdGVkX182Cn8dOR13Xk+NwpKSZ9fS4cXaqfjme8igW320DpPt7/7p2YPGflkmr/5qm+iPJA0GOBSX22KRxLoC79NVZoZyNUoYgTajtR97CmRFvsv+cbv5pbyHQYqA9OkM3NX4guKW62BLwklR8Yj/bxmsd1ry5A39z3npRJN8AP+ODVPuqAZk7eNWeQuu4kOF3XCRzy9tSUh1KAbA/qLy0vc+eJY9Sspzbx1rOZGALoOD6u3DjDOV5b+j6fMdfoAVPXtetIk05nDBtmZ12YL64giMDKsP8H95S7Jn+H6UIcvUM7nJXquH07C+lXh/qDcvyviG7d7rbvlQvCPlv54I31eo/DeJBXFgvSFWqpSIfVNZ0pPWVvRtve7+oDCe2q8WMwM7SgHiRnijRXM2r4TKn4D2R39t19zOg2B3thnzLZP9fd4ZRrGPz9NuG+DGtDTK5crPvxK7OyPEZBucobAt4BvCWmNLnrnUZkZnh1pe1/aVxldaIyyEoa9e3A/P1v4rLE66ukA/zMWs4tNqcOIc6nbiXXy4MQ4NVAP/0Ijp+zjmkr9xpXbD7TPmTTTxisoOVCMLsJ1e8Eyo6iQMBoLCLwCHw4/26nP3YGe/x4BreTtDUfsxomiYZ5StCDkL77KOStpu3w2x8XViFm1+mVJiGJ+ZWIUjaWpUe8ssc71kLmQzoQVGxIfxGEzWJsgaghZqPsHnlFGC9+1A6Si0CzDBW9bdjpHQWmT2XjBV8D9Bvm8ddYN04qy3/YTf0+BMk66YRuUfMJVs7rvOPCyK2L/jAnKTTFBT23BWvTdzBHSjPyievBD83ddULDSuj0v/50zaLhHebRCTIR3awiEyv4BP2GKo4xZdunTW7EA8bS8ptE7hkSZcCC4EMuUyJlmjOgLPFuMKfFf2/ogM+NPXjQcuOaoqgenHsRD4Tmzu06AdCBZNL1bYa2ejmkTiNldC0LnoaLicjiKpFYeDp1Z
 HaYtgTqh
 8+svq7lDNUdZl8Ind+/8VXL2QrfBtbs4ZTzBhT1WIey18l0eK3zxL4fXLNRBWT2jkJm12b6lMs7lkSqiu/7l8vK1PImblJELrxip3OPZRBsLsxPVGPvR3QliAFS3heKCvy3R5DRUgZKRPvL84tvFdFmlNDGZ/FPAiecF98U/BT7YAfAKHUIXfP1vXDYg6onfG2tVZ5m7O6+ht/5wOdrAvbZ6eKx/w/Tf3BQ4d1NHlu8lnLsCFcZVDJ8uOvSclGfwlgGbzCrgWfZ2diwamZOOybAgfHZok2Ftp3gxVGlMOPQxMTNvWf3BnqeDk4wYsQFhWSJSY7YTlm37QYJcFyOo/hpp4hUFclOyxWkRF5QCeRMsoxTE3fnUjIrZlKpiGpi3p05jaU6Sj3TCm20LeBju82iG9zvfSg+WweXanJC5UyyJMM7E+3U0SWbn/L0o9nwixoMDaYxOb5B0ZLjweEpxrRVWgjT64vv/bp7nuFQKHCNR3jm6pq0tdx4HOsAK1ybzKmT1Rhjlswaa7H93vFqu0bAqsoWhL2zBq+fY+QL1lSPHRaeNJPBhjpv6L2WLyUBL5MPZg/OUnMN6ICpq7QDs3acsEqSeYGwFTHr4gksvlbvg+hig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 12:54 AM, Vlastimil Babka wrote:
> On 2/12/26 22:25, JP Kobryn wrote:
>> On 2/12/26 7:24 AM, Vlastimil Babka wrote:
>>> On 2/12/26 05:51, JP Kobryn wrote:
>>>> It would be useful to see a breakdown of allocations to understand which
>>>> NUMA policies are driving them. For example, when investigating memory
>>>> pressure, having policy-specific counts could show that allocations were
>>>> bound to the affected node (via MPOL_BIND).
>>>>
>>>> Add per-policy page allocation counters as new node stat items. These
>>>> counters can provide correlation between a mempolicy and pressure on a
>>>> given node.
>>>>
>>>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>>
>>> Are the numa_{hit,miss,etc.} counters insufficient? Could they be extended
>>> in a way that would capture any missing important details? A counter per
>>> policy type seems exhaustive, but then on one hand it might be not important
>>> to distinguish beetween some of them, and on the other hand it doesn't track
>>> the nodemask anyway.
>>
>> The two patches of the series should complement each other. When
>> investigating memory pressure, we could identify the affected nodes
>> (patch 2). Then we can cross-reference the policy-specific stats to find
>> any correlation (this patch).
>>
>> I think extending numa_* counters would call for more permutations to
>> account for the numa stat per policy. I think distinguishing between
>> MPOL_DEFAULT and MPOL_BIND is meaningful, for example. Am I
> 
> Are there other useful examples or would it be enough to add e.g. a
> numa_bind counter to the numa_hit/miss/etc?

Aside from bind, it's worth emphasizing that with default policy
tracking we could see if the local node is the source of pressure. In
the interleave case, we would be able to see if the loads are being
balanced or, in the weighted case, being distributed properly.

On extending the numa stats instead, I looked into this some more. I'm
not sure if they're a good fit. They seem more about whether the
allocator succeeded at placement rather than which policy drove the
allocation. Thoughts?

> What I'm trying to say the level of detail you are trying to add to the
> always-on counters seems like more suitable for tracepoints. The counters
> should be limited to what's known to be useful and not "everything we are
> able to track and possibly could need one day".
In a triage scenario, having the stats collected up to the time of the
reported issue would be better. We make use of the tool called below[0].
It periodically samples the system and allows us to view the
historical state prior to the issue. If we started at the time of the
incident and attached tracepoints it would be too late.

The triage workflow would look like this:
1) Pressure/OOMs reported while system-wide memory is free.
2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
down node(s) under pressure.
3) Check per-policy allocation counters (this patch) on that node to
find what policy was driving it.

[0] https://github.com/facebookincubator/below

