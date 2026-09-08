Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0564C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889C06B008C; Tue,  8 Sep 2026 03:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A6A6B0096; Tue,  8 Sep 2026 03:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B266B0098; Tue,  8 Sep 2026 03:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 459226B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:39:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C93D61C2352
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:39:30 +0000 (UTC)
X-FDA: 85189794900.13.40F2778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06C5BA0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:39:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcqVrOJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLYb28voNqE4LZdiHYauAGa0BtX5Z8T2H9rGHNsNa40=;
	b=biQk2NcJNI5tB9+YGVBAwBTWhS+m2fkouZJ7e640Ro63N/lewK4LnshYA+PUvJ/KSQRK/N
	+skS3JaLTF1G/LBqf1RZo10I9P6VV0AOq+mpEUWEypQf3Jaxf1EfY9s+/JMHAvDT6phlAL
	EdeeDpcvxXl4zGJ3K/9jOuw3a0yAKVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853169;
	b=ynQsj9OWgBldnDFc+8g42QIh4mSpb6nFRLayENzIiIXeZ57DZ8UJt6r4BwdsybwX/HIrxN
	SK5OGpWi0tRHBTclzpGsp2ybhHN3+PN7YvXJzaV0QaXCPCi0ut7/AcdqOnySZAW2havYai
	vAHfNJPlb97d0WqWxjjYyVG178IqT0k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcqVrOJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3822042AB8;
	Tue,  8 Sep 2026 07:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0E41F00A3D;
	Tue,  8 Sep 2026 07:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853168;
	bh=QLYb28voNqE4LZdiHYauAGa0BtX5Z8T2H9rGHNsNa40=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CcqVrOJwmC9ha+LcDD2dDASPvYOWg5geyouYwMQX3Q/sTX746nqOoFdAceSS/yghh
	 DBCsMjut7ZwO+//bB+iO7adgR1cwN4BghuSUMLzGzbYTHLoSVkWzQ/C0JVO4WoF6NL
	 h3or8xnQrXhsWBMVY2XRUM3tDezZXeuFwuUmv40eSpyHIhoNkPR4MRDk0x/9ge1ZOw
	 Jtm2T4FgjRNtZNIU43RH0w5BdisKGgBj37H1+KYJAeA4oPLaOkG4NPSGxlIIiyp+rf
	 dAarE9cLDKzPX4cA7umL941lyFZn2AQ4HFO2giRaIPqHep2FRnsKupsT6I7OszAbYS
	 YhG/541ohpjag==
Message-ID: <36658bb7-a753-4711-8659-5bca04a5949f@kernel.org>
Date: Tue, 8 Sep 2026 09:39:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
 <20260828055926.346744-2-vernon2gm@gmail.com>
 <53f3afde-b5a7-4c2e-b6b5-8c844d1b6c8e@kernel.org>
 <047c287f-bb00-4672-9ab8-3323cbae8f2e@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <047c287f-bb00-4672-9ab8-3323cbae8f2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06C5BA0002
X-Stat-Signature: 6pbbefgjotph9os7aieqxt8esoz8t8gc
X-Rspam-User: 
X-HE-Tag: 1788853168-892907
X-HE-Meta: U2FsdGVkX1/jT4JkWYJafV/54OAoG05FexeP3N8490YjnlWNuKY/Sr0qBXt3n7o+H6Yrp7ZTNKzktVkULVE8rd/HMzmLWkBcaOKIbyF8hVE+wu/xcXzc5x6WFZyf0IhzP2rb3J+bAPdXXdEQdalrx36URBGLCcn8Kmr8LjoHcw2nBWQsdO2j2u1aZw9I5siDHpdfHImxIRhfbMHD1xkD4ri2n6GPjmob+JeHy9pFHC3SGxPowyrOwNz5HVAi6YC+Fz55Snc9lDJo/NcFbZfQa3XzGD82doyWOo8YYeH8Gw6BQxtNgiZouh4oylCN12RwOb8k7IAujLmHWhYciLItFQL0IOVM/yCzmODPSVFGTE2lNSlXv3cfeKDfTboljUYxu80ImZYlHPwWvZbqBop9l0Vs7gggmq395HUliDSb68pUsvgz9Igomg8gXbMydjoMjJ8ZVs3S/yTzQJZUYuwKpAEmAcSr5HdpjKSyXzXoLM+ttoAZVC1bIVb4dzCUFqSI7prU9HA3qqaP/V+YZYR1YnNOj2MSAlxXxYEh6Av3eWCFbVNEN/QjuWfLpJvxZxQjJa7Tc1TE28mNeE2hmP9lkl38/GpiGwhWW/Wo7AuTiUZrvWvSqpGVj4LxHvvvA9SvHc3l/LdsB49BHGpfEkPa7U5djl0c4m7LhM7ShDu66nEsFVbWWTQuPs0NT4iayHRFCkpzbUKN4GZ4vOBfsFN+GLilxdB/xt08IsbxI5CHU3OoFH+NMLp+x4zTUGr35WEAu5J6DLivH9kxPJ0FH3aLjN0kqsrw70khrf2DIpPU77Muy/6GPlYS/mABQDAIVFPbIYbM8iMePAPxEGZPKb5NZTZ7dui3NbbJGaKjEioHgzgXps5rjREItmK00kJHojhiWbJ0w3HxRTTz0iIdoR3E4bY6xADx4Kny2iq/Wh0VKotcurLhxAmAZMGWp1EHbamPzJmaWTn3ZyDmGweMOiS
 WNq36yub
 G3zWl+m6/uKTr8HH0HLIIMaY0/rPEnmAl9xG2qRKdmT07ne10Mm4Dg9Irfx1kJHSbZXpIvMuY5ig4572Ma6XbUxg8Xopj4OpCj3hXm6f2aYxDcNxOzSsPbJF9pI2HtBTRqsPAfgPG4oivrqax78cG5d2+5/4DQANdFSJr3DHkFQoU7faHczCRzP8Ip/2QnREJOYb5jqFn+c9ItvoPNM5KCEypt+CosAo8IvSpFbMePSQmjmVIyLSdWGcYSNtXwUxpxAIi5WHhMDX+ZBOMujpQ0si9h1b3lGNL4GKYobIIZnS6AzkA0OOglfWYgWyhNN7YVhsq9TwFEUAEl0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> > Yes, this is the approach Lorenzo[1] suggested in the previous version.
> 
> [1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/
> 
>> When result == SCAN_SUCCEED, failed_pfn == -1 no?
> 
> Your understanding is completely correct, and I explained at the time
> that this was redundant.
>

Lorenzo said: "But it's not exactly a show stopper this :)", so I'd assume he'd
be fine with a single trace statement.

I'd say we keep it is simple as possible and use a single trace statement :)

-- 
Cheers,

David

