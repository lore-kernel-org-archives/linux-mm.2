Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC91CC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 12:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9F46B00A1; Fri,  7 Aug 2026 08:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983A76B00A9; Fri,  7 Aug 2026 08:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BA16B00AA; Fri,  7 Aug 2026 08:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4C06B00A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:13:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EAD71C0049
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:13:00 +0000 (UTC)
X-FDA: 85074362520.28.6C94900
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70507A0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:12:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Twz78wjf;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786104778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylGtr3wTi2UIZ9hml4U3d5jZyhzF4W3bx6zGmARmG4U=;
	b=WMsTGsJR9zXwXsOg5BeOJkqzdwNiahgeDanZp/ZuC2/1A06fReyxEoYNHVE3XOnMoeCoN0
	V41GKttVz0WopIcYDLnYbzOTyLeDDLRvCp0aixS5CbyQYUXrXt5K1Ro4MzzqCMUM6KVeVv
	BMv27xgSq0C9CP+UZJccqH1l4O9XZJI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Twz78wjf;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786104778;
	b=UFd9KLl/NiCmrW3hX4VKUXSpX2SHmzYrRGALrKtN2Dxa4ZRBmJYpTRz9ZTpJJAn2Qsn8GH
	oYakkXbTRGgnvcv41QATAXJO+KM/mLVVzHa+1CxutND8FZZUp+RxO4NYrCbynzkOayIKlb
	AQfgArckojq5UP2PwcjYgRC4yjN+UoE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-381b831d535so3718997a91.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 05:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786104777; x=1786709577; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ylGtr3wTi2UIZ9hml4U3d5jZyhzF4W3bx6zGmARmG4U=;
        b=Twz78wjftCFNWor8STujCn1cn6jMsdhtlU+PSu0Gwrrl+7PypbuGG3ORj7AmV0+o9Q
         6PUXPoiV9oaHZtnXGaiHSct0DuGSeZbYmx5nq46w3UKqiW/6IK1xtR0CMdr+rN92VryC
         7EcfN6mPZQr+Rj26DMnYh6dq5cn63FW6eejyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786104777; x=1786709577;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ylGtr3wTi2UIZ9hml4U3d5jZyhzF4W3bx6zGmARmG4U=;
        b=ebUEJP4zsBdDAKYKr7S1nMBEfkbbOiAq4T1zYmypLqSZVOoKDS7PqCGu/3gmcUedGA
         7ZGk6SLaQmFV60xotUwFMftv3I5whmesLYyxBiyNMwnYXrtuh0xZ3Pgq9GdF+KTtWulD
         T1tKqzEZzzBaYfTwxjYqxpFHGzPq2XY2x54UnIswniXWw+jA5Fg6LFnj4PFvOMKWkC5k
         ETwa894/UEXdJ20jT7fDO4EPoFeP1dcouFMLIdkrsB0v/TocwHjID4yiWL67Hi/X1CL7
         waRDmhEe8DMOoGNcZso46yTP02ku2gaCwPXrub+6w2M4xOhUvYyI+RIhmdUCMT34Eoz6
         mZ1w==
X-Forwarded-Encrypted: i=1; AHgh+RocAvej0A2jasyE+8mWTYGJdD/QokStbSA9ohLpoQDfEyFxXt5YVGp0JJiEVtmL7grQ1UHkCODB5w==@kvack.org
X-Gm-Message-State: AOJu0Yxvdk8BXp2hXJFuEI3LJfY4XZPNgf82CuGro+sbRnSf/1TBw0Np
	zDwPpQp+EhOfxoJule0pSsy7hE4cIdkLRofNCfNThku2BEZvtSqrT86Bblgr1DOwgA==
X-Gm-Gg: AR+sD121Tfwn9b0yzyH6TCxDae0fiCs29XcTG2XCQqsXo1k/Fy7fVW3tGPx4LVIcqr2
	D7f8f1/w7alYcf1/6DGtxOAWc14/R1lS6zgoPp4PRv59Ixypa+eFqunC6fOGlGkv+qFkQncc+e3
	m0vUI4uGiLN2jy8tQJBjvka/SQFJbY8snDvfnL+kNEqk0D+V8qfVkpdfJ7XBxKpWX9Q0IFUOD4j
	vUW/GD5CKxqHHXWIoIs8fH44v4O7Et6Vt4tuWjr3NPo2QNy8rYso3yHgMv6DfIGG7ExQpyAwBkt
	kH12Of4ktEn3zHSyFPAZaNv2qcRuDkkO2lvrWb+0mc6nAhOVtnVzXAlNnqHLJhp6gO5skoh8osJ
	psdgJAwtsoaa1UmH+DndaBSms8lG/6vZm6N7SV+eUPIlC+UZZ6rl7W9CsQLrol1FP40y5ziMk5/
	iLbwZ96gsyOPU3Mg+/9P3tksEaM4fzsJpVRLCJtfDHEZrOw+Qh7sn6PYGvpul1Wc2z+IQSYf5I0
	QbalVktTGBiIIj88Z5wGFi7jym4
X-Received: by 2002:a17:90b:38d2:b0:38e:2f21:3bb5 with SMTP id 98e67ed59e1d1-3926237cd78mr3735642a91.21.1786104777150;
        Fri, 07 Aug 2026 05:12:57 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f4e3:f7a5:b8dd:b3e9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dea04bsm4903670a91.8.2026.08.07.05.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 05:12:56 -0700 (PDT)
Date: Fri, 7 Aug 2026 21:12:52 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen@vivo.com>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <anXJ-5_vO7-toSe1@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
X-Stat-Signature: 6jgfmjx53gfijch9om8sbtkmujyxuhd4
X-Rspamd-Queue-Id: 70507A0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786104778-66606
X-HE-Meta: U2FsdGVkX19He0yB88SNu+DLnhTY4KuICBEJyrtg2lcksfoRGOjLWZ1wgZ9Rb47l1ouIlK/JljB+Zff4XgAtyPyLs5sUHBmXpmXfA9zJGbzaYV6NkWjPFpWWkCXGYO8vMn8KN7REo9PsacpE7GZeabcYnzwjx2IFNdMf5TEtKi6Mv1vqAHXjLsFlhVrXaEI2/ZDn6cKpaGsSy+rNTKIXbtMAGL7kP1MipK9S/q94+LY8g13h1L5pC6KtCohiZBkawL4qjMge2UyFhoEWdmpgIqnzJ46DuAyQ1O368FoIWNglhRIy+ThJY133GqYmFEnmt2c4lTsi/3ILV6q+3TemX6yl5lEfm7ZELX9uVKJltnk0aOw7Lejw2/y5c2K0rqmXJoQqOcoea3RacskPopHamwB2LDpM20Vcm3FxxKP/YHUeQo51CAWkmdiXNJeFFShPbBDG573xcFTkY+bqm8GEaCk5cVsZBbFXhIr4sbqxdbdKffB+/AOWMxCBFzGME8Mdoir/0d+8//5PxX7157iVGK/MvqsMXiR7tgUqJ5p9NeD+LRZjZBfhN7ZNXABXVheyFXDEnik6FJSKLzRgaR9qHFtyziVApm8Hs5hQyYCXrDVhWvlYo3hpv74YXu+Jgo+IGam5nOI3GeCvj1gjolhZXY+6ktqZvCfL7YXPBQb3dGHuw9qYusqPCxkMa8Xo83O9s6F9i49I882yehlmCgBZWJI/JOixhGPYfz/dQVyUSzFYRu5MI6+rkACZ/WsqO40sx4phVljLv3ZQjoeypdsxjzlkfcwwq+9aN9TLkv1Pm+dSEsk7wK34+3yOapkyix3k4n0K7KqewoDnsC2ANo2NuLqKScp16I0IW5gA61OeBAZrhe+4fUn1y7DXa83Rkfqo2JI+VJPWSgATfSeDVbzO9lwqSxmh/fM6eFI2Pz2eZBr7f+afZqM+IqmRa33uzjCL4uc3jMrfo70jX01kDXn
 r61GQXVg
 Y2q9SFF0sKQA7qPPG6vSXDrVrXmHDAhlnMFtj30q8AQoVS/OWf+6sgaS34P+VoTmt+ld5p2xHOTJ80e/Vwf/Kinm2CGdYVPz4kQO4N84T0LNn64lfSRAHCtNuTZJoJvNNLCmGDP8t2hakQySYKL/sv49HNer6lvYZd+wu5fnceb3SUqSVv4lJOy9qZlaF/7k/A4RGnZDdA0+fiJYkhoUk0L8/3IBX/T4G10gX4KAsAvwwnqWjsTdOrp0IGYAdjTbwLP3GkWTWvBzl7KkafNrBaIktWDPGqeBdpOzygs+cDpS4AtgpIm4y4udj2J9SpbYGxriMpwlF/r95wMBnVUT8cUdNW+oK0iqOfWtZHrYQlbZz4A1dXVX1WxgOa+9037OxeAcyXKX8eF6D1b4Vr7BSuFV5xoDDVcweoL18VRlzVfiv+bksreSCL6AOscIGg8mX6qVneY0Xv3MEP6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/07 18:57), Xueyuan Chen wrote:
> Hi Sergey,
> 
> Here is some additional data:
> 
> I used the following definitions:
>   compactable ratio = freeable_pages / total_pages
>   memory reclaimed  = pages_freed * PAGE_SIZE
> 
> freeable_pages is the estimate before compaction, based on the same
> calculation as zs_shrinker_count(), while pages_freed is the actual
> number of backing pages released.
> 
> There were 264 callbacks in the trace:
>   callback elapsed time:
>     median:    5.77 ms
>     p95:      55.82 ms
>     maximum: 271.36 ms
> 
>   compactable ratio before compaction:
>     median:   0.32%
>     p95:      2.86%
>     maximum:  8.33%
> 
>   memory reclaimed per callback:
>     median:    3.80 MiB
>     p95:      30.45 MiB
>     maximum:  92.73 MiB
> 
> The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
> and it released 7,650 pages, or about 29.88 MiB.
> 
> There was also a 241.91 ms callback (with 30 schedule-outs) with a
> compactable ratio of 0.44%. It released 1,019 pages, or about
> 3.98 MiB.
> 
> Based on this data, it seems better to remove the shrinker.
> 
> Would you prefer that I change v2 to remove the zsmalloc shrinker
> callbacks directly?

Let's bring in heavy artillery to this discussion, in addition to Andrew
and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).

Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
I don't think those buy us much apart from memcpy-s and lock
contention.  Systems that want to compact zsmalloc have a sysfs
knob (and API) to do so (based on zram mm_stat numbers).

Any thoughts?

