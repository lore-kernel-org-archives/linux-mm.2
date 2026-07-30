Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05120C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6446B0088; Wed, 29 Jul 2026 21:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876DF6B008A; Wed, 29 Jul 2026 21:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C6F6B008C; Wed, 29 Jul 2026 21:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 522026B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:48:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D40A1120857
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:48:19 +0000 (UTC)
X-FDA: 85043757918.10.E3E70C5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3F5F8000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:48:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=snIU8Z+v;
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785376098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2kUWZ0xcdYFc/4dDu905x5nCY+rKqCzP7jv+c5usrE=;
	b=5XOYobDSeL4uUjG1XSmk8bb/1JJPF8xT6qiqmfgOCwj3C+xcwzYtLMbYAKHNpWEpJ8azcY
	Al/3fBgMNO3PAnZ06qzMbjJroIo/+M6Ds1wbPJYnzAqEM+RGXAsXzIxwq/7em9h1tMECEU
	bjICN1dams3Op5EDkTqrPUvrfnxo4us=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785376098;
	b=Bvp27Va0kPe8vyxyNYoQ9xFnTj9ZfakdSBwlGmzfln7TMK104PXbP898hqIyJyreOWWPSJ
	poIvL+V4irr+FpqIhGpsHEqPJJyAJfWe1LTc2vEykgS7x2lLAZYVagjlHxWfwmog6hFhLp
	A1DNUrgjGQ+iciA2bDn5iuxUAC6CqfE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=snIU8Z+v;
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0710df28-5870-4d33-aba1-085756290856@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785376095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2kUWZ0xcdYFc/4dDu905x5nCY+rKqCzP7jv+c5usrE=;
	b=snIU8Z+vX8Ry3ANjvdEYi7mUuak8bA4lZ6UeOPKRCzKxibeH87AGjK/ZyBXsS4tMx9lBNK
	Mzd0mnR5q8KJP5C42BVPKioszvVLq/1wsuvkovqsa7W4tXiAkmPFPsQZAYVC7FxWHp8kRD
	dxlFXpx/Wgw/KKuhdz5ZbSnUHDWHtzs=
Date: Thu, 30 Jul 2026 09:48:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka> <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka> <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
 <ammzjkUIADCxO2mP@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <ammzjkUIADCxO2mP@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B3F5F8000E
X-Stat-Signature: yuhjjwpanriys9wnnrms98zye7d71ite
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785376097-208539
X-HE-Meta: U2FsdGVkX19Z8HtSJvnacCAPoZ5Fw8v4Y56Znhxuqtse6bqyX5d22Gvppw+3Uk3a0thUHES9rObWjCRvPUJSLdxBvDBBrEyB082sUNKiiCQZkfv40eYbdrpX/Sd1XyUjpmC1Z5pSNcNrzHICd/fG0IY5ZRb7Kow7wNi2m5Wi9wDFZarYN6YfVo8dlkaFmtgOTcjE1dNuk3jXF2JvSVJlpfyYr0jJvch8yb+LzX4yZ/9/qrHYHp29co335ojUzbBWp3cQUd/3RAOgYAGGKOkmVzBKhoMvRZfkfGGxp4aZK8R1oXOG4LiDi8HRkEYBY5tt8NAINlIJZ05sy1B8bpcyOyHSCgOxTtEJKDAGlmUqCinGEUvUnwBgvo/E7PZvNTBBnF6Fh8N+FLx7n2MistmxvGT4429P4r6SDTGlfSkCGvub5c+mpZIiq1Iqd/o+NmFiQDO9tAWzWn8jjW/qPDSLIaoI2F2iEngPGa1dy2dPc7vuBvcm6gQSGAsomI1XYu8cTNPw18qnLc0Ubh9OkIT1h33A1HmqfvERTwCFMKJlIcGNsSO73wA2jfj1xc2P1hMgDwSCQwAzqjCXAurWq5UPElk1lVaZOCWjtS2F/w6NXGZLgl36tul8vvWtVPkg0uWxzrGMoVbSd6a57nduWGXkFl3dNYtlrAMf609tZgrPq7GztaShqpU4qhNwlBA5i6p8506z4zetmBahL+Z2moNKkXFckoePZrWRhqSaQrtI6EjIb8NIlx7jKhiIj5DDOc5CzAEXoGJ77NORkTL7gr6/KK8e/Dpzm1K/FFTZqu81Tv8kSE/bn+Oz00SS3eCN26yNghSkrk4AGyAHBtP62Zem7Yhd0qTTNytHBviLM65rk9XBfH8N13xIeK53gzJ0EQcJcGwjQxSbGHAnq0VqRNSQEarbZeO9JSVp0eMTjT8d1+W0wDN4GoqUDQk2mkwni2H1UHueOUrczXRO+hGDbOe
 1K30pd7u
 XCUqU65wmk28zM2WFonujezDjJtBqzbtYayx1+H9uVAYeJLjOdWBzMz8WzXZC2/73KoW6lK9N2axCDSc7XEmd9itmtt3AfBp6QWBcBelYC56TgrejQBGGm5m7OTTP2Jf/Jzw+OvRJyZBn6DrdfWSMgVjjSN2b5ErkmZ4SiCkbbbXgJkIWyVDkc9ft7slWQfR0dxvObcPAPW/9sX/NFTT1ixpuCQuT0eQ/Pcljnp8vSpYw9viUOAmQTVoPF/Dj2PVHxCiJN/VGcHKDUT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/29 16:02, Michal Hocko 写道:
> On Wed 29-07-26 14:15:25, Guopeng Zhang wrote:
>>
>>
>> 在 2026/7/27 21:58, Michal Hocko 写道:
>>> On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
>>>>
>>>>
>>>> 在 2026/7/27 16:16, Michal Hocko 写道:
>>>>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> [...]
>>> Is this trying to replicate any real workload? One would expect that
>>> writers to limit do some sort of coordination otherwise the exact
>>> behavior is not really well defined.
>>>
>>
>> No, this was not motivated by a reported production workload. We found
>> it through automated randomized testing for our cgroup observability
>> work and reduced it to the reproducer above.
> 
> This is an important detail to be mentioned in the changelog. Describing
> motivation for a change is really important, especially if it has direct
> impact in user interface behavior.

Thanks for the guidance. I will take the feedback from this patch into 
account when preparing similar changes in the future.


