Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE81D65559
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A9B6B0005; Wed, 17 Dec 2025 08:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8836B0089; Wed, 17 Dec 2025 08:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A8D6B008A; Wed, 17 Dec 2025 08:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5A756B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:03:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555401A0A6F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:03:28 +0000 (UTC)
X-FDA: 84228979296.06.555EA9B
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44C15A000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:03:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AgZ4RkxB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765976606; a=rsa-sha256;
	cv=none;
	b=XSpww4Uz3hrSh/0nY532gs8/wytu240BXcuf6hP7hTzSxs4wTuTY6hj7CGdhxoWjqPCwcT
	9RqL7ypEyVwdwxV7l2QgzBsMo0FFpSyipxya4CyZSWrCrxdwzj1UwGokMZEv5MRi4Lymzt
	Qe2YbbfX69l5ic0RuZQ8iQC1CceMLPE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AgZ4RkxB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765976606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OrcXKWdvuAE6N1CLZCeBV2HX5BbxYzxVYTn7sFPcwg=;
	b=IEEto3haADR1dtspqDyG/+R1rYzNO8vdPvBuMnrX+DiRP63qfjErmrhyj2TX/qpoqyXWlW
	YTtwKQ5FynEQ2xvucSUN6QxdF7bcdKM5UDhy/OSh1j8+B0BLDgs3Y+uOTjS/Yjycl8f1BR
	N4TROC6cxgLdQeEJ9IS6tPul3Q9r2Z0=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-787da30c53dso58096237b3.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765976605; x=1766581405; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OrcXKWdvuAE6N1CLZCeBV2HX5BbxYzxVYTn7sFPcwg=;
        b=AgZ4RkxBxWOAkUh9DQ1azLc0jQrZCkLiZwyj+FzQ5oy7/yeYdxoYMivfGFrRHM7IkO
         7O7xV9iyZVl52STR+r0hvFyQNicKz923FA3op471aCwyVmzyioSX0sQWRpaz7/TNGTwS
         WZQhXub1fQV8sOeocwIPcmLBv5UpCcj6NiswsSvCYNYo71aCGtb4S67KYPThpzeng/Z6
         3oIQt7EPMnwVNa8qxp5YKVu3MzpwSlVUOWFTxPvpFP7HNE6LmN142Mngdhe/73NcAy3a
         OZJw3fjfQq/qhgSLHn2EiMWa8nmu1nGrWi7Ik9Kq0D5sJkEN8l5pqryDkGw6c+MzpmH9
         UFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765976605; x=1766581405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3OrcXKWdvuAE6N1CLZCeBV2HX5BbxYzxVYTn7sFPcwg=;
        b=SL22jPSRRvBdcf3CWiyhMKi1/yuEIASHrrXwj7S9jxGWWUCchM/LCsY6+5L0b7YW4e
         H3VpL8+46zxpeIkOWgVhRs3DL/0a+06SumacKKRphFPE6U9InmaN62Febsi9TIuArSJk
         td9YNMJOGcm+t2K8BwbW8KdXsiM3Fiu53RnVekwUeYev6cEwAEMYp7+veVTx7sGbOTn9
         U2XKpUnX9Z0r+DVTwaMYO8SHCEJmdlB7L7KVrffZEjeTfjkmuSIYr6a2kY2Gk4X95yvu
         pD5Qmxy+ZTxN+Ose8geo3GA+OQp6DnG35sF4h93WDMaM++pmI0X+ME+FMygD2MHzuvow
         suog==
X-Forwarded-Encrypted: i=1; AJvYcCWjvOR1CB7GMG8eMj2T0mGTo4idGHN+LnMsytFCwNlkZIxSei5zTTMPX5KNRFiXl+wt6PGdTm8WXw==@kvack.org
X-Gm-Message-State: AOJu0YyOgecCe7IMO0xhWEJlz1DDW/NHPXq0kz3eAjzt1xUQgIdh+Rrj
	R3o0NinUlKt8Xy8t2kayV6NgC9AfDgfNM76SzR2wGWYIV/ae9dYNHPwi
X-Gm-Gg: AY/fxX5FQiL6Pp6k+hYVoOWUgWJxMrdxggQGSuWzDYqp+gZZtguw+EqUbCiTsBkJhNe
	vxajd19MiHhBF+4CjvpOPhK/hIZD8FzCLKOMhngixeSmrM9VSOJXVaqFT+AOE2QV9XFYh+Dmlmc
	RWK67NdnYuxykVKs2tTUvAyMzrbfxDuZBjNdoxKyPpJoambp+tssJRY2e21SWnBehHlxuEf20p1
	wqJ9q8LN1P6ZbFIFi3T2CCf/q+pud0u0I8Qah5ZZAMhWKCE81SsVdu16Yj9v+jLEy+fgnt1L4bT
	aURCUn9yi0zY1D4rYds3vIQBNDg2nfdHqs0vCXOx42i580E6MzkRyHWcMXf5IvT+d4o7pt2f2Sv
	mzIGziCwBksZ7IMdE4FDKalAC+JXUcrQhivRVZ7SuJR1LX0wq2PjZE0Xd2Ap5EoCjswrbTorNTl
	56rNI2F5DL7PCmJYxGcr6wJA==
X-Google-Smtp-Source: AGHT+IFFpd8MqeMm8cAUKBinfGXtHNbZPWn3XFitHYBMLyDx8pC7+Lc8XbhhZbINQA9DF5spw70kFw==
X-Received: by 2002:a05:690c:f82:b0:78c:2c2a:fc3e with SMTP id 00721157ae682-78e66d1ed33mr149339407b3.21.1765976604948;
        Wed, 17 Dec 2025 05:03:24 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:51::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e748d26b8sm49501337b3.11.2025.12.17.05.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 05:03:24 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to zone_set_pageset_high_and_batch
Date: Wed, 17 Dec 2025 05:02:52 -0800
Message-ID: <20251217130322.3350377-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1c94600d-47eb-40b6-8c7e-fb2cc39e1e4b@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44C15A000E
X-Stat-Signature: byaf5rquj8nn46swsbgx1annex6jtcqx
X-HE-Tag: 1765976606-62420
X-HE-Meta: U2FsdGVkX1/xzzWmRjHB3LTr/vHf0yLCbbVjKLyoRz7vzFkb79x5ALBn6Ra7eXrA4UwHsYmLIfVtaiQzugNkXlY4N3oKUMOX/aBof1QxxSBlmRAaIsQ2y0HduGs/IhvgMK7yobf6bz6pgDaTBK6+YR1WWpl1fhXAfBvibqX34qI8UlHsP8v9/V5EVfGWUVd7i2uUqBR2eIE8JJrDd9CUddMINZgfEhN5L+WmXRue5gc+QoZVwMdHj9HUsjXMqouupn4bes5uQM53+GSPXIFPC/ScvWn7C6kYkAs5qFjuBnRNFUyuWRqJCJQSG7scVuDyUYQewF8J2YahhV0QPB02u55S57CP846wHSTWPhDSX+w+mBWsoC0eo6/cyVUjoZXZuaTQQnKySL0VIEdKOc0jkTbf2K0X2eOasQKZCHLTgChsDhf3BP6J5Qf1rxa+1Z4iKvB3626ZNXXJkUXYb0VuyoDsLikall1vx7zCm7KAYw1O/538Q8j5vpV1VcUM48gtskO1eI+pmO9CV34PMeNrFT317Dt7xLeFwGqP9kD78k49R/15ynB9t/t7QmYrIYtwz1jgobrkU2wV/NNXEYYeKDDM+d3XsX3+EmIy8334gT28/zomh0bQ8Q1OshQxXmGlubi3P8UGyqsiZ3dhGNenH4qIAGu9sBD3/6zW5PmU2gP/wpKq1dgKvM2uvkoRGDh3V+UrFgoC6JmFwc8AtTGP+vT4JeCtIdvVmeVysDY7b33DdR3Q4AhG5UJtkEHIXARNyc+4Ks5p5tMVpk6RJnGOq+Pt5X1SQVogqXkgbWfVDPU2wwlaS0aHZus9YxxJmIvTx+Ogiesqw6OFD/uxV144eCOGe6pZLqfIfQIyUodwVMlQ9+ZkYT3VysTn3wUHmnUu+v0LevWk0LXFr0nK/h/YTMeUsHG8GfOifoLB+zzVyBSnIKyUR8qeKVkJEBevZ53HleO5aBduvQI9XRYDgHy
 y9OtQJJ9
 sg/DfE/nASnFijKmkAZxOdmN5Mlqzm8BVdGC88lmxVh4oIyXw1JaStpX1oWry4oaM5gmLAZiKv9RjrOYJ4nfeMKjPr1uU6FVg0LJAFvY5Rk8C9u8NA58GOSUyoHBi+T4maw2NzNkmNPWwRh+ffOMFk0rVxAERLzJ1g4iela3diBlX9hoXP7soujwxAAJsz/5CMpYK3VaT5FJhu46BIpSqHlJdALy3RUteo0WFnsKNP+ZfmshXHiM07rxuionzbRkYz/jJHSHXRhxYDkQnE+Rn+ZEWAUxDY6dXVEC1FKrDQdc0RVKqobclqXXQIAJuy5sfZmFMb3jhnuDbidBxknI0reu6RlC5gBkzOn9m7nI7CfsboGpMPk37mgS+riwlYcrCh9zBPxQ+pYebMQAqYJ24bTfyi4btPHzaeJVBH++Nwkcmk2nC+7s8xp4arObZFU23+KyHle5UM00BE0Eb77IlA90mtgYTz0GvKqtabkPrJp84xU1To2Oq4MYMLedS3Nuai8297g5iEd0H4reB5ztww+D3ucKCwc3MhDfetAxmv+yHXNYvwf06yHzaQdB3qSvnEgMS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 12:23:58 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 12/17/25 12:12, Vlastimil Babka wrote:
> > On 12/17/25 07:05, Joshua Hahn wrote:
> >> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> >> moved the error handling (0-handling) of zone_batchsize from its
> >> callers to inside the function. However, the commit left out the error
> >> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> >> 
> >> Since in the NOMMU case the reported-to-user batchsize should still be 0,
> > 
> > Should it? The value is effectively set to 1 despite what zone_batchsize()
> > returns, because of that adjustment this patch reinstates. Also does anyone
> > care, really?
> > 
> >> we would only like the error handling to exist in the callsites that
> >> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
> >> 
> >> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
> >> on NOMMU systems.
> > 
> > I would rather make zone_batchsize() for !CONFIG_MMU return 1 instead of 0.
> 
> Ah looks like you considered it too, initially:
> https://lore.kernel.org/all/20251211225947.822866-1-joshua.hahnjy@gmail.com/
> 
> It makes more sense to me than doing effectively two fixups in the MMU case.

Hi Vlastimil,

Thank you for your review as always.

Yes, I had also considered returning 1 for the !MMU case, since I think it
would make it a lot simpler as well (It would also make my original patch
function as intended).

However, I was unsure if changing this user-facing behavior for one line of
simplification would be worth it. I am not a NOMMU user, so I have very
little experience here, but I imagine that there is someone out there who
looks at zone_batchsize() returning 0 for NOMMU and interpreting it as
"there is no batching" as opposed to "there is batching, and it processes
1 page at a time" (which, actually isn't even true anyways because of the
bitshift). Maybe an option is to just make batchsize not visible
in the NOMMU case in addition to always returning 1 to avoid confusion.

Anyways, back to your original question of "does anyone care". . .

I am not sure : -)

For me, both solutions work, and in fact I prefer the original solution of
always reurning 1 for !NOMMU. Maybe some NOMMU users like Daniel and Guenter
can comment on whether this change really matters?

Thank you again for your review and follow-up. I hope you have a great day!
Joshua

