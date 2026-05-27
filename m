Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E5DACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BE26B0005; Wed, 27 May 2026 03:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3C16B008A; Wed, 27 May 2026 03:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FFF6B008C; Wed, 27 May 2026 03:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A42CD6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:10:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A43F160E32
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:10:10 +0000 (UTC)
X-FDA: 84812325780.26.DC74422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 654CA18000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:10:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epFmn6n3;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779865808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KT/HSNqeN04rDLWmc+opukkZEkW2mU5kUE+yfkxNc6k=;
	b=F3L+gG7pHkQtrKPyLDcEyOucN9ILxpXCcjXMU5NmH+HM59fjKcJq5iPoduNfNZKYk3Yiii
	atkqzu3yRcPgFR9YgYLRr0wECDXlpb4bZCZAFfjo9znEtyVn1cjeviRlfFF+PRUapfdvsc
	1xWASaOMVyzdXJ6V60HvEk66glmJ7f4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epFmn6n3;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779865808; a=rsa-sha256;
	cv=none;
	b=ME3QWXI3IR+aNBJiYfVKBTdw9xhaGlJMxg7xVFZlbh051Mexi9R5qZ1gGoJo+O261kiOPE
	BDWfyDv4RQDK0sVga17TuA57zSl0O2T6MnRQeEfjhr0AQAbNXisRwRSL3JB4C0cXu0W+LI
	RuVn8ee8RHf3ihE23vHrRt5eIOKY4kQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74E9840628;
	Wed, 27 May 2026 07:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B36F1F00A3A;
	Wed, 27 May 2026 07:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779865807;
	bh=KT/HSNqeN04rDLWmc+opukkZEkW2mU5kUE+yfkxNc6k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=epFmn6n3ZXHR9c5VL03xP1O19FQvIUFoMFxe1xgkJLC5YM53dN+0fY6A5bVunFWzf
	 Gfn0t/PzREz/t84NTlgR3qE1+sMAfnW4lSx4cVQ79YgxVpSHNX8XwtyA9KvT0cDY73
	 QltxynWz+qOQTYmPGm+KTmYTGbOsHJPhxRyhC4v6f21Vwg8lFEyYq39EZ4Aat5d2ej
	 jAWoDQjwqhDG7NJtZuYzTYWPL3mMIuX/WRzN03iiwRpqaZCLOp0aVFf3K4HnFPivWp
	 qf4pz5/oqA539Jxv9qrYdw6yrI1nSYVA7bgp/kAbgMLdPlgvh1cauWP5B8LOSwHVc/
	 dBA8iPGVFPxpw==
Message-ID: <38681cef-4855-49c0-b317-47357190e2f5@kernel.org>
Date: Wed, 27 May 2026 09:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260520122228.201550-1-d@ilvokhin.com>
 <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
 <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
 <2aedfd17-17e6-4dfe-8ae5-c7342ead708b@kernel.org>
 <ahXdrP2eNYw1jc0P@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ahXdrP2eNYw1jc0P@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zime8scdyrpaxesbri6kff6hs6dwn55u
X-Rspamd-Queue-Id: 654CA18000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779865808-617913
X-HE-Meta: U2FsdGVkX19G/YEuX5krJjXSCBsYWxZnEIExISehXrzGNQjoFlMFnMi4FYSIGtAmzl3/+wk9lb5qJz9gyMWQWyDRoEKcgqgeigX/ONGxCBJ4pycVsaexbHEMWiu0xTWkVmz1SY7MpmI+je8aPN5ELPZIR4Mhf+jxAUlNKojQT1lYtrp8oQ1AGvyr9p3Mg+KZvzTkMrRw0a35nU69DOl5YnTB8Mcl15sX3YnBcune1jK9br8mTNek9gTvTHyNuCQV8CRqLcTQtxFOnkY8M6yvvhNzxrub4YO9acLJdfMPwBqmSK1Jx8klRifc2EXYbTAEZxr5s66JZ8HPv59OhzpcKCX6RAKdC6AJNqJnIalQFszmO2vDyKGT43cIgDaObRqevwTYoIYCt+PgSeLS8FOfSFCo959ZWg/1YoHqYU14ozeiSaFf+axLw4EkI92BWNb6c0DegpXU1u3kg54dqC9C8O+MzbU1GB7kw+f6miyj2eb9RCafFNvVJ85s/W+jlYgxdx0Q82lvpy/uKNZe0dFm1VkRWEtTinG84aYbjb/xfm0tYrj2Ybv7B+Mk3z9uLAOs/h9Ufx4lGwj4N2EUtyTF/ozS8yUUhYqwuWIc0KmZD8NLuzqOwXal9R+M2U9zOzVEaJAM5XVW8RM8WLrvtmPd+SgDLRDPc5uWV2blekJQyCiytxAc/xpliSzocQ0gIscZzYVkhdPmQe1wWmYwRx3nRFi0+RR3U6C87JgVRC3mXxnCwLRUZe6GmJA//IfTuuKl7b843INuK9YvDymGNS8kopDsWSqf43FqxiD7P/XckPnMFJF6GwMeUMKYZoDpCOvO+yo4KDrXQqiOGKXtrG1+lpUAqwJnlVrG+Bntl27RrlImbaP2UCT6ORiFwHuW9OhOk/V61FJuLlk09ffkYn8yw/jMkjhwTgPCxF1jKOzcnvG0ywFZfVa4wC3N97H0lXMYWgalGi5AaBuDRYYFHM+
 d7+F3gV+
 D44jkyaXmTCRo5ehFcT4SScVO0/miXhWt55RQYaO0xBPr0OHmq6eya8t4WEQg7dtKqPiUbh1YFtn75xwIOAfwYVLJQH/dawF+1S50mQbMy8/xRLGCgS1mR09GUJcjvX2agNELHpiXZueAGb0ANoZoY83OMmg7a5HXXHR8k9llJnoC6VCc7Y4Js0UHjuA92okQZqd6VjUoS9tJCtHjdvyf2lNRlk/FcWiMR60V1VKJH/NFlwIPQhjrO2gtuRZKNJksocoXJeza1w/9zzrw9l5fp91hEeTqTaYOpG4F1D6w8WC25vDyCE3w3q0Nvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 19:51, Johannes Weiner wrote:
> On Tue, May 26, 2026 at 03:13:09PM +0200, Vlastimil Babka (SUSE) wrote:
> 
> As you may remember it was developed to help with higher order / THP
> success rates under pressure.
> 
> The impetus for actually deploying it was that we saw issues with
> avalanches of large page cache folios vacuuming up the higher-order
> chunks; this (ironically) also led to failures on the network side.
> 
> It's kind of a structural problem. We have real preproduction buffers
> for order-0 pages through the watermarks. But for higher orders we
> only ensure there is at least one page. That easily fails under even
> mild competition.
> 
> Since we wanted to roll defrag_mode for THP in multi-tenant systems
> anyway, we figured we might as well take the plunge now and battle
> test the feature this way.

Great!

> defrag_mode fixes *that* issue, by preproducing watermark buffers in
> contiguous pageblocks - making everything up to that order more
> readily available. I'm still hoping to make it the default eventually,
> which was the plan with the original huge page allocator series. As we
> keep leaning into higher order requests more and more, and especially
> grow the non-optional ones, we kind of need non-optional preproduction
> guarantees for higher orders as well.
> 
> But there are bugs like this one, and we're still figuring out some
> overreclaim issues with it in production as well. So I'm glad it's
> optional for the time being ;-)

Right :) thanks for sharing!

