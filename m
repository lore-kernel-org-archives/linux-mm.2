Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30147EE6B49
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AA36B0089; Fri,  6 Feb 2026 13:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3511A6B0092; Fri,  6 Feb 2026 13:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27ABD6B0093; Fri,  6 Feb 2026 13:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 176EA6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:21:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B03C81B273D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:21:49 +0000 (UTC)
X-FDA: 84414850338.30.726A734
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF4E840013
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:21:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WaXNDMcX;
	spf=pass (imf07.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770402107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1xMJV1RX8usJkOhUgCSFWhXH1p1NkF7tpRo8hVA3gw=;
	b=XXczh6GVQ7enXipo7SWDd+PArCuRxEzK65zPuphcjeIcgCAY7hfCCbA3lDnQ91Kg576FfH
	aE3k7w6ftX5kk9oFUHyUaQ5Xv5QyAG+zN4Ntr1tIiGYDlzq7Ech91ebLdAylJ3FQUjGCuM
	NVxhbJEg+ds9dFw2uTQV9IRQYlihH9o=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WaXNDMcX;
	spf=pass (imf07.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770402107; a=rsa-sha256;
	cv=pass;
	b=CAB/V9Ui2BQAvrjlget42dT1VGPLGxUoLLcONXbkt9ghLt9GGX+piMKzOHuxYGVy6vgsuO
	n58VDlbQQtWYL2a7dqFYj9I1J5SlaLfcKYGKWYYYi8BA5ZcSL30yVxrXMtMPnS17JMDg5T
	d8pQ4Vy3AaUdva5LrJxW6a9jcXjwqLU=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d1959ba05cso1136590a34.2
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 10:21:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770402107; cv=none;
        d=google.com; s=arc-20240605;
        b=LKDHf07hAvk0kehIOzwDCm3euu+zT8igF/VrOOkRAnG4onjNgeGA82cae2rlNBk1oD
         fSC+vw2+pjiexJJcUGkO+SSKVU6ObZt0iKgPxzfH+OYl5HumcS5ojbcz+8/ctVlOIMy1
         2Jsiw+WKg20n/hCG7Q4Lc9fyvtuyYvdXL4ogda6ahy8m6I1h6yqQzIeUtoppn79IqGFG
         w2w7g2HdpdnDZpRtdUsybK10iNOkVaLO4+7F2CjGUe/6hBEa0jw0vH5cvn8up1xPPSVC
         VVCwvukKiPlftuyCdso/vHJhAzh8Ur62TJyMzqcVJhTU/xhutmkF1dzihzzkw3MaXqwa
         SW2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P1xMJV1RX8usJkOhUgCSFWhXH1p1NkF7tpRo8hVA3gw=;
        fh=Yr+gqzcUx3oZ7rz5qYtISWaUuvb/s9YKUG8f1Bym5rU=;
        b=jn56bX6lWncvtKBb+ukUd6efvpSj5pxkzAB3N44B8d/ErVFMWouXoYQH91hBeE2AnY
         JgLq4NSJV20RV729C3C7yzTmBYU9pxeNZzwRika572WgGanH+DvguryykvwWbaJcQdRh
         BGXuQGPbzA2qAzRSsXc4T5JsFR/qNCxLb1mdXDspqXJsIk0wDxXdCx8gDRUuio/o8lWP
         3D5f+j7z6EmthN4xIwTAJuelLKU0b5BhVyneJQdq0UIo9DEdoz3jgMzU7feYWwuMwzag
         RspOD9jKnIPEStUV8o6rlJLPi4VEvWgOkdJQld8jzaUDADO2pVO9HEZNNKYLMZf5pU5a
         Ms9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770402107; x=1771006907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1xMJV1RX8usJkOhUgCSFWhXH1p1NkF7tpRo8hVA3gw=;
        b=WaXNDMcXubR+9L/s3qpvuFQyyZXQ9MeOWO34gJmcglncG8V4vkw8e8Vh0lWwdIzFHh
         IVlmib5o/XgCXSUIqQgKEmN1H8YSFXcZhRbhZv5VFwM6sN7bbGWZqz2gWyte9LACBFt4
         402euwcLkLCXLwbXmCG1lqRODwR2yGLX+WTKINjbVN9UsOkJVbI87VjJxwbOtKSv+lTq
         ygsZLt3ddbtUW7Y9soyq+abJ4oKybrPQs042q0450WZY6NTQDNy6KRlls7ezHhKqlg7b
         sBn7zPy16BxrNBxOQzz/mCAyadk6cOVdG4PWTCTzVNLxeFFZMGXfrDsB7OIlb8B3DXFh
         xBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770402107; x=1771006907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P1xMJV1RX8usJkOhUgCSFWhXH1p1NkF7tpRo8hVA3gw=;
        b=UhNSe/RbSHZURSUZR5M+MlgGcHpZzs1flHk4sDifjQ3JFkoQiA5a6Ppu/JX4GJcNWi
         hXvZxvIJ0DzWejtt54/LWRejK0cx4fif04vnVc4pJxO1l1YHQHEngGcC4+yzEjnounev
         jNhO5+HQW1AMaQfbB5R3gDxxfrQePZHwk+bNKOcqnJhDIQ8AkI4xEMgFQm6Fuv56XsvK
         odqcgKaVlL21SX9GcFzeh4/oF5eeECdTvIlVk5JEeuQ5XTehaS+E8VWykQq4oHu5Z68d
         LqBgK2fe13mHvXq5j22s9SwhqciL4B0OhSvmoVpYsJZ1I/c/1WZgzJmbwzU1O4Ju38/f
         itBw==
X-Gm-Message-State: AOJu0YxMO9iqalDqMxjM70E9zdSZBzIRK2Q0n2sR9BVwxwR5S8dcxZMz
	QUYFaObqlUMN9MNCJcOq1L0xkeQth1KL8FERDMpBizjuwp8xMDQw2NcwLpthZZ47XSrZv3eC6Sq
	bg52e+2s543PitxUL5FUkK+TXRPjPzx0=
X-Gm-Gg: AZuq6aLlZQ0gs3bVxeBWdJbjtTKEGEkxrotiHw9OHe2C45mHK5vVt3J1wrgEzYm9oI0
	54OTqyaWi2eV2Ofdx6qXlbBMSTrm9Dk6du8b5p+TJpbosjeqV3/yB8lG7iX2nh9eW1ZD+7EbOsa
	TzXEgu5WWkybzUX4Of3Wr3hAJX4LLkPAxZG5PrdBUXnzQ4HQUhPmcfVg+h1D6W73L2CfZMWOBkc
	VzGTRN3/P2B3YfjwojuqQQsuu9xswwKFipHQqVI5d/RoCtTqg2v6ycHXy4QtJGN9jInOLEXHw==
X-Received: by 2002:a05:6830:3c88:b0:7cf:ddb7:8823 with SMTP id
 46e09a7af769-7d4643f2cacmr2508175a34.11.1770402106721; Fri, 06 Feb 2026
 10:21:46 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
In-Reply-To: <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 6 Feb 2026 23:21:34 +0500
X-Gm-Features: AZwV_Qgne92Nuw9ugbsrMJv72AiexOG9tkvmf158F-E6lOhbaFGhB4UAL2p1RZM
Message-ID: <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz, 
	chrisl@kernel.org, kasong@tencent.com, hughd@google.com, ryncsn@gmail.com, 
	stable@vger.kernel.org, David Hildenbrand <david@kernel.org>, surenb@google.com, 
	Matthew Wilcox <willy@infradead.org>, mhocko@suse.com, hannes@cmpxchg.org, 
	jackmanb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF4E840013
X-Stat-Signature: wto96uecpqtccif14g8cqproesnurgt4
X-Rspam-User: 
X-HE-Tag: 1770402107-292108
X-HE-Meta: U2FsdGVkX1/CtYvV6vF+ioHdH06xM3frgI3PeoRCYCJ0Cr9J+B08XBKc8abcP5nLCR3A5K2Y4wybsFiK0xxtGDFJtwdp9nTVy867kr+kV7zhm7PlzTeuBcHG9AVvqOfyGgZE+ckB1+WHi1DkI7mz1QaqNonho7+Vv4+VMq+bExZ3mbkOWn12z0NmPYb2hbZS1o4fBbfIiXClihgXg/g9d0FlI6omgeOLn43Fn015ckq9M+nvU0Qd7yVbX7Drdku0nuggpaw0d/yfWBNJrvUv3GbVRoLlPEcq2oP35ja0Z5dNhmd7vcpoVAZVWSGRq8CAy2+U2UK0SAqKXDmTvrlw+NqOnqirTXsMNkq/PK2EfxadOa/OeFSPQ25LIVKrmUvz+VwY4Eev3sc5uewpTdMvMcb0TFfcwjVeMJGPfNbN/HFHrH8FlwoRRIc630BW9GWcFINXTDhjmg5kovZEo+li/vCUSPjTD5ykGAXzYEMP9SbgZ8vX71dKik5x2V6HTNC+bQ6bWqIfiFfW29VRx4FGLDFCeRO92U9Ned3HUrBQsFMZlgiTeC4ZRZrve/eV2IpIYJOjHGXwIOkiSn6ZkAOZ082axwKuoCAqs8/1+RfL2dm9gMWQXicPkYJELvUqQbvTkopoXK2rQA2AVutPGOXbAVCWJGpHcxhCOYCcYPNVCXaQVoXEnncy18HoKcfitC+V0Ku0ns7WMPyRmOkH0i5ij9NEiA5id8nSlbGNdXL7TugwytEzerW0KVSoh46qjm2RfMNpFVQnJ2IsOXmpU0c2oDzsdsKbmFzhCwYgU25SFuUXubHRg/ldWsEs7wQpN/7VWc3pm0lJE63+NTRoUs3jfD5eS/R3nnmntD4isHYBOdT8asvSAr1UradaWtboySLA1cEHt6RbEAaY7DyVRDosNz9odicTEDJmcFOPTi+2Z1h4gm2/CFO1M6UbSCbqbgKFDgcmtAPW/jREfVv7K+U
 90NbpwrK
 0MpztbPZ70B9a46rKK4AIXm83Y/cJYcq0VH2dfNP1UZ+If0eUqDvrSBICj+ZoiHJaTe8pOZVbBRhCriFTP0Z/e+PrfjxlEuZhZfWR5+RtJjAcIdiIGq4kWXMXdr5f96z2eBoCUE1p1Jto1/vJTJ6VfeZ672jMcEVUublhgOh55uRhnU+KeWA4xw3J6zivftZAYhKUQ2XSXr3ywP1nZ/mI3o4lHW8avHNX/6+gQyzox0rGr5E+Kj2t68NLaAYB0PqRwIaa3TMSjPdmodexMXbuTmVC8KT/ivu7uZo1YjdTi5gMCf1CVRxx73hxqmdWqxS2nwTfYi6NZfBOpWjMeTqBNyay6VvKCmyPa50v8lTTbdvTlfLx+BwX+8TgeqmRyIdbwaDFutmaTUpio1SIXie2tXX2Gghr5n4RmXcme8BjIpI9M29uriKS/iUUY369CNpdYGLOqkbSCkeIzX3OdWGc/iMPoLm6/oxKxSKRT+MH/n3VdFiPjShtDXAMWRsfAcjIlZsnxCqIrL0EFGsSHgVqfxTbTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Yan

On Fri, Feb 6, 2026 at 11:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> Do you have a reproducer for this issue?

Yes, I have a stress test that reliably reproduces the crash.
It cycles swapon/swapoff on 8GB zram under memory pressure:
https://gist.github.com/NTMan/4ed363793ebd36bd702a39283f06cee1

> Last time I checked page->private usage, I find users clears ->private be=
fore free a page.
> I wonder which one I was missing.

The issue is not about freeing - it's about allocation.
When buddy allocator merges/splits pages, it uses page->private to store or=
der.
When a high-order page is later allocated and split via split_page(),
tail pages still have their old page->private values.
The path is:
1. Page freed =E2=86=92 free_pages_prepare() does NOT clear page->private
2. Page goes to buddy allocator =E2=86=92 buddy uses page->private for orde=
r
3. Page allocated as high-order =E2=86=92 post_alloc_hook() only clears hea=
d
page's private
4. split_page() called =E2=86=92 tail pages keep stale page->private

> Clearing ->private in split_page() looks like a hack instead of a fix.

I discussed this with Kairui Song earlier in the thread. We considered:

1. Fix in post_alloc_hook() - would need to clear all pages, not just head
2. Fix in swapfile.c - doesn't work because stale value could
accidentally equal SWP_CONTINUED
3. Fix in split_page() - ensures pages are properly initialized for
independent use

The comment in vmalloc.c says split pages should be usable
independently ("some use page->mapping, page->lru, etc."), so
split_page() initializing the pages seems appropriate.

But I agree post_alloc_hook() might be a cleaner place. Would you
prefer a patch there instead?

--=20
Best Regards,
Mike Gavrilov.

