Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A51C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28DB6B0088; Wed, 23 Sep 2026 06:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFEC6B0092; Wed, 23 Sep 2026 06:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16986B0096; Wed, 23 Sep 2026 06:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DED56B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:09:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30004140747
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:09:02 +0000 (UTC)
X-FDA: 85244603724.25.EFEE40D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7CABF1C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:09:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n0ZRx/Li";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGe6vvzIfyc+qTIsUGolB9Y+Ruqzy06h15nR/TKjBT4=;
	b=1Fnu5ceejjVRftOddMqbCwPl6OP6m+7jbZeTirKqybdio+1DeqzZJH2YSKgXM1dPUD4+Fj
	NTt73bIj3+Wu3ECNO/wisIKv9g50lXlYqs7gAVcjmwUGEffF/JdSwxW1XwApqKLQLfiLVR
	FUZqziI3sqUASjeO3rdmu4FndbBlbxM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n0ZRx/Li";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158140;
	b=ilxEY5ZHyduLkJoVlzfDfJ1v82K3D+5o8zCRqrNPvcGjrGvj+Axi9ddlZEQK3MW/hDQTPv
	6TbJ2Laoj/NZT0QmZNlhYkv0iLkx1M1pwUnK+kh9QD/33EpKD5GtNesiyf5oD+wDHCV42P
	8dA9tu6gg+Hi4r+yAT3zupcZTqRkF7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3CDC601FB;
	Wed, 23 Sep 2026 10:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7871F000FF;
	Wed, 23 Sep 2026 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158139;
	bh=QGe6vvzIfyc+qTIsUGolB9Y+Ruqzy06h15nR/TKjBT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n0ZRx/LipbJZ5SAr00DgLfPZzjNv8jPGF+5j5UvmTvUzo6akdL1/LImkfNyDOw7xF
	 RHJafK7yuueB/aC2v6kbRe5H+lu9ezIqwzWBmOYcCrJ5TNCm3+DhJtO7DL1y3inadQ
	 OrNacc1+kX0UT/p7W1kldtaP/ywBj28a01+JzTF95EAygFMUz8fzj/YFEWKZLOeML7
	 Ib/0uu0VAlnUHofGNAhMKbSxPwdZ4VIwN83z7PoYNkxGVUzKNb6T9nw3aheg/V4t1p
	 /zA9twf1pUf8jgplT4BmOp/69pKyEedmd1rCr/v0RXdGIiTIYGyCHPRF1DIabkU0bU
	 WDQPAqzpOAhLg==
Message-ID: <c1818134-d2d9-43d5-8de6-5af24d2bfe19@kernel.org>
Date: Wed, 23 Sep 2026 12:08:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] hibernation: make swsusp_page helpers static
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-1-7f7dfae3dbe0@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-hibernation-v1-1-7f7dfae3dbe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d9mi19s4aroqwcobuiryis4eiww7dday
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CABF1C0006
X-HE-Tag: 1790158140-694304
X-HE-Meta: U2FsdGVkX1+iZRIOKWbaHG5JP6/wa2eBXeZTnxwTUR/BLKZWNC+TZqYalaHbj88Z/Tsz536iecU2ZYGz4Bgax7BogKHYQFWH9v7kg1geIjVHSUpuqi0KmYAcexOe5B3XTphqQRLeWfoU5T8qaoMKBQVFHXOqeZqZVK3f5Ql3a1It0ywXtolpV0sd7hnodzJ3GrP/rSEKCZHxoRIhYxgEnHvAXOCoLxEn/Kq58xevoIBM1spigG3j4E0CS83k4575prVevq+T9o2OV/nvXo8xWq3krDuymA0eurXkNWgcHRcemuxdc17J4TdzzFDfA4hDvYLgiPnc6nInFPkkutRGaTpv/59FjW6KPZcX7IRg99vXijn2nagQ1zxDNl7X2U9O04eDQsVRo0HAPd7G3CowJtDeGAFS/QZIn8JBlWBJj8z2KASsAPp8mUUYd0eaktLoZduOUWsnNeAYMN50uvGn7xPYDpP9uNpdLelrAr72GDvKZ99hVLuRurSg9gPUUm0BHAew1XHA0pOPYwIb/2hXLLVquJNjTiYlFhSTSjHYXQk8SEMve1bn8GgeTVAkt13H3WW20M5C8YmVcf7ezAmZrVntnyYlaDWHPueWL1EIXzwytAiXUJ9n7fhijLQxssukblUR9N8kz/lVLsPkOcI35Qkq8nmqi2vHvpX8+EINAAMSbJxvJiIr4iwhohbpitZXLNEezIGE2yWb2SiXIeRGjaFDs7bo9RFw1yFE/J9qoRKAj2FvEKy+6EndNeWabeX0itYTzh2k009IqJXRRGcsB2Rs2OrsCRQsr5wZckVCtgv+a3UMk0vPKfyba6ogs8ZFQ5FjpGDm8szdg2ymAt4ziIpFgHcaKpaEJIFtef3Q1wq7uk5BImqVCdm1FGtZyYefxJ3p+ReSZoaWfQMDHe1Zr419YJ+I7hDrPU3zGj9gnWGN4SLjqN95LhV6cMtI6Hf+UITScgWPajXxa18UwAB
 xmMZfcL9
 +jdEt/1xlDgqXLiEld5RRqLjY+Jk9p4yjBZPTJ0oya4rMpQ1cu4obAKKAv9LfnkvPSwNcYrtuRRh/jBh3/S0Zt6ip0TaHV0+NgPoaHBKfGXcTXmtshT1DCyRWm4XwouiOGOdQ7KknVJzMayGEuas0IHuZiu5flw0wqphWs/vz4dkei8sZXYdlBzT5iWR8x0y67degQftS/TI3nte7bZ9JvWlH7vWfcKj5FLQ523v8seAzflwMtSH0BdwwTqfA3OpDInJ0hAAXRpKofyQ5wYIBhXtXwwdcQTHHLiQSnSpcCohqTqu7gkda+xxj6UYXRsh2hHEh/xkzfPEnSps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> Since commit 31a1b9d7fe768 ("mm: page_alloc: move mark_free_page() into
> snapshot.c") several helpers that set, clear and query free and forbidden
> page status are only used inside kernel/power/snapshot.c
> 
> Make them static and add necessary forward declarations near the existing
> declarations of similar helpers.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

