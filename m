Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0199C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9C08E0037; Thu, 28 Aug 2025 13:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5815D8E0032; Thu, 28 Aug 2025 13:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF008E0037; Thu, 28 Aug 2025 13:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFED8E0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:14:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12077C02C7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:14:07 +0000 (UTC)
X-FDA: 83826814134.11.C5A67C9
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E2C6C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:14:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnpwbDJR;
	spf=pass (imf22.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFf6Y+kZ5qDzWQbTvOGNXX5jgmWUdsOKV0pU+ZaksJQ=;
	b=19rATm18XrVmVUn7xMSalkbG2mCG8NU0Xzs6SMuz/0kiZCmeUOoDoX3ZUfyJLlEDxv6lBN
	MetUfYhZQOHAqayBx198zxH5vxkZT7NHh9RpHQWJFaYGy+Q5AO80ZmtTsorA4bE/GEiV0C
	d1+a5jvFHqr4WclojEm2E0Iwf6MDtag=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnpwbDJR;
	spf=pass (imf22.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401245; a=rsa-sha256;
	cv=none;
	b=e3Sp0JSa6lyQzt2LCDMtEN1Qsaq1W3FeoLHHlEQWlmB8C5ph9WWorcZySujP05FX0J1gz6
	N30rTVnmqOGoHa3homk41BoK3wXuzP6Rcys8GZvFghMVdBRpN6mJaCapHYQs54vhGuNhAL
	gMcVReYfqbxBS2VqcIQBZyzLbzseBtc=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso1084379a12.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756401244; x=1757006044; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFf6Y+kZ5qDzWQbTvOGNXX5jgmWUdsOKV0pU+ZaksJQ=;
        b=lnpwbDJRe2c80h0+TU9ITJ8ZO0BIFC4Vy/h17sY6wo4Z7Dt7NR7DWrqggX/5UgoTAQ
         NwprwBjcYK6DQbl9D+wlCDYPmd4Jq+nVYWeS9K7Bmx+u121vW7ci0lo9JSdb/CY6taq2
         Xxn9RPGukuy4HGPrMXvfH+rLUQhtle5wz+cVi7Ybz5PtxH6RKK+Nuk+MDaW8EgoaanDh
         NLe59JMOgsw7iDwRAPnnbg0K1YJNAYfWJZt9WHwSj1S/WpD55vUF4fOz4KIl7nQtl+aU
         SH/V5lxOZ+sVzOyhUYQxL6mbuSyorRAMUa4AasCJA95zZAsmCK6HF5zJaEAHNt5n++qZ
         ub5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756401244; x=1757006044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFf6Y+kZ5qDzWQbTvOGNXX5jgmWUdsOKV0pU+ZaksJQ=;
        b=gyl2tWTxIly39efFZAnuP2Yc2d1hRXnZxi6Ew4M8Hv5RtHS+Lx0EhKMFdAurnxHwBz
         RGW4odDQG30ZQO2SY4WMMDhzTLjH+2hzW/5F7MnG9UDkoRmouCBmCzFE2FtjeUtj3gcs
         0j+a+y+4ChIU4OwPkQDrJ+xv+p6FCFzJLjRROLhcEJg5NSbsYd/ovaRlgMzcxgOZ/3qd
         947lHIZNuxVxnq/GZZUV9hEBmDnmxj6I/Uik3JAM8JFYqUQ3zy025jJija9SkjjmBrTx
         jBTighbsUhyAqFHRoCx+eo4c7ItGrWUksyjRClra7fea7pZo+xc7vHNStOR1MjWiBJcB
         /eow==
X-Forwarded-Encrypted: i=1; AJvYcCXWojTKLzw9Wj38ETte7sa1afJ0Jqr2KYr9iQrpwxkmdTFjVzVwR+vnmx9I83/Gbl2j763qWNyK+Q==@kvack.org
X-Gm-Message-State: AOJu0Yz1fqZqRRMvl/XCuePY57S+BBuklp4giV1riDt8yxAhPgK2K1tb
	p66JcBkoYGjYYnTM7UvH7YrdiZfIuyKS3/iINnzRtOPamCOJkzM580XP4sVNNgMx
X-Gm-Gg: ASbGnct3bIGIlRU8rj9CcVmXf8dK/I606+ab4MUAA+aYR3wALvr7AbhCdoilmesx2pp
	iq1/52F/l7n8f5NOEbbkYyITB/w96nUsoXMLRdaitFUU8bnEKZ6iXEroFo/f8aveeBSr5Shkg1S
	eFMa+ti6aMA/kgeJl8G9u2h0nnUAnyv5xOk7/Crx8R5fYwlDUeVMxyaz79EgIyowi0Y4Tf6MXRp
	yVv5TRLbCivOd1l+mKBWRmm/dkK67C7BEvxFcM0xSNqIh1cBTo5oRPb7QyHrNAb2pBIsYwvP/Hy
	lPssbIu69yl6SorX49bVDRDb+l8sQ+h5YtV65cgdtgUUgi5hXyQbTvoUqKmCCY23hryJfkl1DHK
	9WHeW6iqZb2q983xR5nKrNeaAKmuegcvnOAOPAI4B4lBOmQWlb9TJLnLj5JEk8aRQdblhUEI=
X-Google-Smtp-Source: AGHT+IGTAmc9IupZXzbfxYJAl1mMm5d8+llf0Cd4P4qOL3CGSr38IgDE3agkuRUZsGBinXlT0DgVBQ==
X-Received: by 2002:a17:903:3c2b:b0:242:bba6:fc85 with SMTP id d9443c01a7336-2462ef4a02fmr346186855ad.56.1756401243950;
        Thu, 28 Aug 2025 10:14:03 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e71a8sm212401a91.15.2025.08.28.10.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 10:14:03 -0700 (PDT)
Date: Fri, 29 Aug 2025 01:13:58 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	glittao@gmail.com, jserv@ccns.ncku.edu.tw, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>, chuang@cs.nycu.edu.tw,
	cfmc.cs13@nycu.edu.tw, jhcheng.cs13@nycu.edu.tw,
	c.yuanhaur@wustl.edu
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Message-ID: <aLCOVoshch9phL5M@visitorckw-System-Product-Name>
References: <20250825013419.240278-1-visitorckw@gmail.com>
 <20250825013419.240278-2-visitorckw@gmail.com>
 <eb2fa38c-d963-4466-8702-e7017557e718@suse.cz>
 <aKyjaTUneWQgwsV5@visitorckw-System-Product-Name>
 <aK1n_t-V1AlN86JR@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK1n_t-V1AlN86JR@hyeyoo>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E2C6C000B
X-Stat-Signature: 7pistz44ue7i5jayd9hoytk34hskcf3r
X-Rspam-User: 
X-HE-Tag: 1756401245-189572
X-HE-Meta: U2FsdGVkX1+zNyrTlfBu6KQbmHzz8/9E+oNw2tU2ex/4eq3zVugFfULReOmMZJcfB9C8qhM5po3KUCFhBifnU4wsRE908/JVlqRrHA6vIMj3pXjwpLsKFFQL59JTrI6T8AezMtN5X1GfFK42vdrJI2nXJik+LTCOPXT8OhxOj7qCZmYwXo2fMiGceaXf83Zh2SlRu0eM1JPH6s+nE+k34sGe9C12D/9c3zpMUcEILmtqjlW3w7NQ/CMRqn5XwrYTU1Tt9EjfaECi+muNqifcWYEiS4C1FYNLf34ImLunUnZxLtd9v62Dvcj8ToxPSUGryZzsjfgNPiYx+pejTHbb/6K4hGqavdgZ1VGJy05YYLYHAf7E60tlrcH3FysUl+g4VRDZFSLtsf7onKd7JZfYHhHZwibFjLrc4Oib3c1feRX3LzIFWVHkoreMO7d8jsGGCjzlMvs1wZxyHG6BmfFs1IAHbYAFVILq3PlohVP0jM+03n0sXkvD3jHyc3qN5MxfAxbBhafzSc2PVR5XPFy5awV8WVmXeCitOTPYtn9BOocNmvWUcGLBxReQApt7igOkMaKkMvjJhcWbvEEE7/PU7syOEJqzayFhgSejKSTY76nw3M7d2Cm1xyqXx7y5Jiz1wFgxR2vZMvjLLZ0l98s9+JK2ND+EQF14p2l2CZ3zvUVZ/Yxr+VE27hbETRCHHvVqoEjP3Vec1OhgM8Q+KfVPBkDz2SUKCqxzll/Cu7JVjE+5WUyV1MVaWy1Tnse09QRtJY3kuTP/eLC7JualhAKtzTTnseiwnU93ebFxU69yK4QUzuY8rVlAz+Sltc5STG0JUHOTf/WvrNP335UiOhGWb14t82nxkNu9sSBID4orV9BzJsSklpw293US1eGyNGZVu7afYstL51QwdxERBKdCoPL3pLQsyaHu8Ow9rhazOzEvtRh5M5oqnFqPb/phro52suVve2USRlbmKp9RMbM
 0KmJIjha
 9QDz8GqQsSF4ZR4gTHb/kTAG/PCN16eBmIHFXAaCZ6TMw4dkBdYOQaZ3beOVTdc3NUvlrnJ4BSrkOFNP3PTmVLqhmOz1GwnNd/IvaCURmu/W8fFVUdk2CJL/E9/bUn8yMqCB7Yw0J9x0cMVs69z7bN9notDiMwuJP0PFwY/hTEdt9G+8Qm03koF4BWm0H9Jz+OKiSulpbGVmEv8+YRA3+KuN99zJ5gUZu+Av9ERyopsb27UH1PCbltvNnWW+yIfphs/w3xG9YUwzL6rZkj/1cRXhySddvOqXHpjXBhtrkbR9We+paJmVn/1lF3JVGq6KMztrWl4R0pb1S2ppX+wT+gnVcfTc1C210L6iJrS0ymM/4T7u0ijrhvvlHA0v8uqshLKMoD27QsYCU3vYNBF1/yJ8jK6ZUA/tEvMjIRS1UTo69ZRdtEWfuiyM/LgRM2KJK0xoqMrX0uW8A1Eck12SxcLhFOkMAD80ipcR83o+ru3PG4PwNqdfgqmtCgqHKVvpalbnawYdGYXvSvl0UpiUD/neoY3vWJoT8izMbb3HJv0nZuPyGNOPfcpLyEW3HPxZ9rtzDjQvq+FtfSFOdBt3O5faHrDQinYk96dx1h/P1I9qOzjVOG1uh+Ir2lGaFtEYio0HK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 04:53:34PM +0900, Harry Yoo wrote:
> On Tue, Aug 26, 2025 at 01:54:49AM +0800, Kuan-Wei Chiu wrote:
> > Hi Vlastimil,
> > 
> > On Mon, Aug 25, 2025 at 07:28:17PM +0200, Vlastimil Babka wrote:
> > > On 8/25/25 03:34, Kuan-Wei Chiu wrote:
> > > > The comparison function cmp_loc_by_count() used for sorting stack trace
> > > > locations in debugfs currently returns -1 if a->count > b->count and 1
> > > > otherwise. This breaks the antisymmetry property required by sort(),
> > > > because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> > > > 1.
> > > 
> > > Good catch.
> > > 
> > > > This can lead to undefined or incorrect ordering results. Fix it by
> > > 
> > > Wonder if it can really affect anything in practice other than swapping
> > > needlessly some records with an equal count?
> > > 
> > It could result in some elements being incorrectly ordered, similar to
> > what happened before in ACPI causing issues with s2idle [1][2]. But in
> > this case, the worst impact is just the display order not matching the
> > count, so it's not too critical.
> 
> Could you give an example where the previous cmp_loc_by_count() code
> produces an incorrectly sorted array?
> 
Sorry for the late reply.

I tried generating random arrays to find a concrete example where the
old cmp_loc_by_count() causes a wrong ordering, but I couldn't
reproduce one. So I would like to withdraw my earlier claim that it
definitely leads to incorrect results, since I cannot demonstrate a
failing case.

The complexity of the sort() implementation also makes it hard to
reason precisely whether such inputs exist.

That said, I still believe the patch should be merged, because sort()
only guarantees correct behavior if the comparison function satisfies
antisymmetry and transitivity. When those are violated, correctness
depends on implementation details, and future changes (e.g., switching
to a different sorting algorithm) could potentially break the ordering.

Regards,
Kuan-Wei

> > [1]: https://lore.kernel.org/lkml/70674dc7-5586-4183-8953-8095567e73df@gmail.com
> > [2]: https://lore.kernel.org/lkml/20240701205639.117194-1-visitorckw@gmail.com
> > 
> > > > explicitly returning 0 when the counts are equal, ensuring that the
> > > > comparison function follows the expected mathematical properties.
> > > 
> > > Agreed with the cmp_int() suggestion for a v2.
> > > 
> > I'll make that change in v2.
> 
> -- 
> Cheers,
> Harry / Hyeonggon

