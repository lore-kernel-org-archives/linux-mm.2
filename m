Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EC6FD374D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 12:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD0F6B0092; Wed, 25 Feb 2026 07:34:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB296B0093; Wed, 25 Feb 2026 07:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BF96B0095; Wed, 25 Feb 2026 07:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74FDE6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:34:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BA32B9F8A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:34:19 +0000 (UTC)
X-FDA: 84482921838.17.C9F81E7
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F2EC18000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:34:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LfQ7rZQu;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772022857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25QvE3/rgXl+aQFhryydLx1P5GAQJfl/r/lT5mBwIWQ=;
	b=xrleNBfN+mBkVAyJJALWZOafvLmoUIPmcScb+wrf6jcj3WvCaV09LomIT0ZFCZhVMTEal0
	/xDPQFBKbxw9bp3WZboqp6fZNWCIt5jKdDiuJoLlLuZzfKnNzH3IS5oUf1COF+wT7aY7Pa
	4iRvyT46m8oJ8C9guC5P6aXWvy9A2iw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LfQ7rZQu;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772022857; a=rsa-sha256;
	cv=pass;
	b=449kmLk2nAo/DBlyWmfURq+sxHgeI4sLNhACck0Xf7Fej+ioAeYH7Dtlzo7GGQV8zlxFKH
	WDazw6n6vrk3PYuCzXHUtbByQZIO6lOSljrP7ylS30HKV53a0qAm0ao05JEhBGslLUcc/V
	GpuBch809wyRvsCcEd/cL6WRrqkIYx8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65baa72399fso8925106a12.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:34:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772022855; cv=none;
        d=google.com; s=arc-20240605;
        b=JoFN1u+IIHkWnfLnx1pkNGtcrBG8ON2Z09l17eNY0wrjZJ5C75W3LT0pISdl5AzB3N
         1bu9rLXakx17VMhzG6sSyZeXb6gM+VqMjwnG5ncGk0x+Yid6BfcMTDJf1+ulMAXGepxR
         O0blbRYo2C3T2SL6Na9a9hwSV1UNzV9L51hNjMJ3k0dRyyBGcPeAHlnPuyaLbcMIXp6Z
         vpdoLvbAHaFQOlUstqcLmEL2vjCPDaJBlvWz/Tn42yz4dUrFDkVmobaOxxAVTShLBUri
         nTkRldAm9XREgZ3640PxElnm4RIWG3kw3uYBwHFlHPWzSea8sQVZHU/jKcnB+U5bLc4X
         wZDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=25QvE3/rgXl+aQFhryydLx1P5GAQJfl/r/lT5mBwIWQ=;
        fh=KGzgL1pCvBrGK7x8LkyKOAFJ45bgTBc6bMw1QtN/EBY=;
        b=ccCbejOjoT7yKd3AM8gH+chrxOOj6AjdImu4jWUp8GEUZdCtWTPti6SmEN9oGHiU/t
         uMsd2zUyZOms0XgSaYiEPCZxodFOQm/BzIkwN4XKffOnIjB5g44SJMwbbgApjsdJzOqN
         Mm+KR+ddSHl3ufJVEizcZ2WFwQde2tdJEyvyxZ+JV1wHdxE/Tvy4H1SvlQeLKHREWO7e
         TklUhOExsoBcpV7p1C5z/VgS5ksQuYFY2Hm8Eig19fw4U6BmhEHrSkyvWrE8omxaIxeH
         ZFOz76G2pTbYqFfIJdaiy8mvFwXR3Iz8pbgz8EglsJJsm1qTfyc0SVGnggnzmNUBKLdd
         PH9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772022855; x=1772627655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25QvE3/rgXl+aQFhryydLx1P5GAQJfl/r/lT5mBwIWQ=;
        b=LfQ7rZQuxlZuaZU183Gojdhfis0C13KGKNUIhfFPj2IZ/zb0LibIJIbV4XNRBTHgdC
         1f/rcWYYVpgV0G9t7dQMcEZYA9L5vpDSfOfhjHUwjRjik5dTj9K7hkVv0MDsGsHmSpRC
         XTyM0vJ/ZOGpp1A9mbf8CJgLJid2oVFF47F6hfySJhtWSYZ4lDn7i5IdjwdhvS+F2Ogu
         s/WlYkKBJ/V6TWj9xf4E0FLP/HN37YBZBIRMTQu5RjYsl/XFNR6oImwJbGvUeL8vef+k
         8mQMLzXtHdSCs7pzzZgxvIhtGWcDBKnbwsUOT2oz4RVKR438d25LWDrC95rSq1K6i+CQ
         jUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772022855; x=1772627655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=25QvE3/rgXl+aQFhryydLx1P5GAQJfl/r/lT5mBwIWQ=;
        b=stxQyUmjI6eDRTYLKT4G0qDjfmoik8Oev8setRiB2Zu0LSjCgtRxDfBdkvFlmTwScK
         87X5iATzNYbU69l5N9KkZuzFJqXRLFapa//U9c7pCJbuzWjfY1wZOGCpcppkXrMaOpvN
         eY4702PFSLIrD+Zd2yn4cCy01r/Tp8WYqGYrRweO0T+xJh3t17a/fLGhHz0ijKZgaX81
         GM1aHnouUMdhDn8Ljh7FmLCsY3FmwOYt0yd0G703Jj2Hs0d9Ip7R1fX6nykaU9nHH9TL
         8FgL/7D+WwcF5tNXcykMAtoUC54+Y9jrpBhi7HqWWeRYFhLpO4ypBYv4HN44CDLcz+27
         tUhg==
X-Gm-Message-State: AOJu0Ywr9TGUFdPPQ/kdxtPMH0cNkkxdX0tlM//8V5QVwRF+0VG6cstE
	Qt8FLxcyJ0h2/ArTjWnQLmgxNX7x4bOAZbwqYrWZ8YxkVI34xOsZ6UkXESp9M+6CbZdLj7zTzVz
	KkdO9nmbjLSgtsXKoWOyfl2JApxwbcRA=
X-Gm-Gg: ATEYQzy8VnL/XLFSNYVdwH0rzsPwE0JOlp63wFiVcDgjfuNM7xav0VdEfz1I9FHQMxF
	i4qGSkg6JGIOkM8hZ3cWPIDR+y4bQG1yk/XHW79Gvr23QJJM/rgSTWAt4BOMUc+H3LOnbcF0tJl
	L2dvI3Sb3ygWSovL1p37HNVZqlH7rjbBPRoSNNYOwLY2XA77exn2JLR8zmQ5DthmkRH3DvByYN0
	/9hv2FY0UaBznZ5kzdywCvojkx4gi7HniP5zVAQ8UUcrmluWfU9ZEJiJ/CIHe4NXRZA3Re7u9MH
	ooxQW2+N60UeB4I6+83q6tJ3ZP/35emNXfhowjes5kaqILiQofQ=
X-Received: by 2002:a17:907:d2de:b0:b88:775c:bd68 with SMTP id
 a640c23a62f3a-b93517377c4mr3516366b.28.1772022855187; Wed, 25 Feb 2026
 04:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-12-104795d19815@tencent.com> <CAGsJ_4yv31utMTsZcRf5adeUzC7NnE0DfMKRFi3v1iCxfdXbdw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yv31utMTsZcRf5adeUzC7NnE0DfMKRFi3v1iCxfdXbdw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Feb 2026 20:33:36 +0800
X-Gm-Features: AaiRm52wg9w_3BfTdgSOtfcWZyY1DPjmMXW72_qSQNgpW2ho1KBhQdHip6tdXo0
Message-ID: <CAMgjq7AMOuLYRX_A-y8aUuQq-yTPhvj05QbNrLWDQgy+H9MsNA@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] mm, swap: merge zeromap into swap table
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F2EC18000E
X-Stat-Signature: 9g7dpe6psfnf4g4fp64fmm3bqdub9ata
X-Rspam-User: 
X-HE-Tag: 1772022856-903907
X-HE-Meta: U2FsdGVkX19HBPVNABc7bNj3usypzp3FPoRBzn/+YS6+YJQt5sg+UjpuifsMnl1OXHjnCoL0XjQl78tOlTT/g8lUv5BWHyAIb4U/uBblokrq6YeVHObxGUqtqM9FpHshhDJ/OR5py37dEy7XiWqzxDyTrZhmoB9wHoDCmRpBjMqLocN55TuAk9SpUuUr6ywhJJEQnGopLqQXl5wOdDeSPQ4jXZ1RlpGc51cEDnOK/bSmXBB9LykpqcvqguWfxr+bWdSbTwfR0Ca9gaoUTJ8C2b0i3V2xprLZlyYtVQUl8yxv8RrQhabth3R+E7/GRnAzERnDg6cuu5IK19EtoWbvODVXUQcFKUyryfjImuq/3OHlEmOD72tzNqmAiV9wpqUL/QXuIddgg5d16kc5Hcbk1Oi3B3Cq4H5e92dWcsP530tXom92/+z84uWc5cNaZVXUW9NbzWwaFmk350S7NSjBx3b0IphDRDw+MJInmzRxIJuvErcyx21jIZdD4YhBB6Y0ciEmpiO1Lcaz59LG9amvGdmhMoESxxOPqgFgAAbXG4RN8jCpVxqd+t+UrxB1Onb0avfqsLcEk9X5QDKJbtC3BiwTCZOnM7ct3ikft2PZ2SR7N1R5+A1yeLNaLvRiB8B/4ao3yI0PTB5Oz9fAK5Q6qtNKYzID8/wVR0/AkYpcAasqnTFJYTLRlQnlTrZegHUuRS3+sDuDu6rNtu7LfT8b9DNnxWtKdxqhpZM6beBnaMWsPp/KLa9EjgiBX52d072/qgOAVctPSZDUEtF8F4u6wpcqcRKRBzoW53eGpj7r2XpSo3JABhH6+T4qx2GKIhqeP3fJT9dCpIGBYjnP8xkkl0O7yzWGMDqI6QO6l8FGIla197yCeksvB8HnTjRt6KlbL0xJlDsmxX9gV+7IlPwvIUGrsPLj4V/N23Zmnaghsbbqh6Gk3uKfYU/O8GKLsYv61fEYZZWf3WcwzZYmw8Z
 IbNQMo/A
 dDq+op6YwzAZmhABZcX/hgnpdOrEWFYsERf94vU0tzy+pXXp2h+RMvaTLWyqDNYOfa8Ai+7K463Diw9eN5E36i0ieDvkqAaz2ElwaK+3IrxuupQJZoOM3EJI18SrDh7n/o7sEOIbYfS5KDt7uwA6xnveKLwLFPzueBabpPDTiU6WogSL+xMHLJy7jLOVqIM+92uS4bmG0pPu4Js9cNx3DOYIsWk68ca1fgYoJbKsQd2S4HnjlUuu9XJIhTeFUFAPdr0Ez8w7X+zknub7fixkFuSe8Od9GyWU+tGzvp3IxjFh7QcRvuzkyPARZ3m+wQ3gvWbJAHVhQ7RiI1cXhpevB0RVhsbiPtuFlCW10Z9m8AVd/OODmN2uMWHnAJW59AFN60CLXaQ1hdrmDnOo1KOBo+lt13ZexRWvJEKJ7VnKQ+mCUwxzgkLzvdzLMJY7Cbd4bdgFXrdSqaoIzy7NqM5KS45To4z6OcuYQtQoK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:19=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > By reserving one bit for the counting part, we can easily merge the
> > zeromap into the swap table.
>
>
> Hi Kairui,
>
> I know you're saving space by removing the zeromap memory,
> but do you think a bitmap can sometimes be faster
> than iterating over multiple data points to set or get bits?
> Or is the performance difference too small to notice?
>
> Thanks
> Barry
>

Hi Barry,

It might be even faster this way. Swap table / swap cache is the same
core data and must be touched upon swapout / swapin, if the bit is
also in the swap table, then it could save a cache miss.
Also slightly reduce memory pressure.

For swapin, __swap_cache_check_batch now checks the bit with things
like memcg info in the same place, and everyinfo is in the swap table.
Currently it uses two loops in this RFC version but can be merged into
one loop. Even with two loops it should be more cache friendly.

And "clear_bit(offset + i, si->zeromap)" is just gone, because
setting the NULL entry also clears the bit.

Page io accesses the bit in the swap table separately, but the timing
is close to swap table update so probably it's also beneficial to the
cache.

So I think it might be even faster, or at least the performance
difference is too trivial to notice, I did some tests, and didn't
observe any difference.

