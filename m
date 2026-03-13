Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B75106FD98
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 07:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CE06B0005; Fri, 13 Mar 2026 03:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A436B0088; Fri, 13 Mar 2026 03:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC356B0089; Fri, 13 Mar 2026 03:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1037A6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:17:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC6101CEF1
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:17:26 +0000 (UTC)
X-FDA: 84540184092.21.A61C29C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1651160002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:17:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ies67BlC;
	spf=pass (imf08.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773386244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeLGjTj3/SNp/8jfrblTEUJIyAwouu4tbKdrGWTfuik=;
	b=6MwAZxbnSAnoVKGLrgdGfXUmF2+yTQpkLTrMxwTxGpE9t2qMAAlSIc2+4hpHfPNwDIuLAz
	jG9OT+YSi9vV+X/xSFVxk4zYEm38Atr4M3HByDinR2rb32y9miJK/+IhqPt7Q5BOYoo4lo
	NFuPF6U9oB/G/FTUF0fMT+nFq5Uy7n4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ies67BlC;
	spf=pass (imf08.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773386244; a=rsa-sha256;
	cv=none;
	b=RmkvKBi4hfCEYjRP3keYuJKy220qvdRTPDiu3ZM7mPU/frBICjJzIcMIeaQdniMNm6BxcT
	d+enrYDy8qU5qwau3zySmG6nD8Pt4QTap+ZeEsyU/OgZu13o7kPmuDH+G0kZGvp8ZCnC+A
	7Lm4ghGH3QSBJAIRLQ/6q89CYgFCx9g=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso1706738f8f.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773386243; x=1773991043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UeLGjTj3/SNp/8jfrblTEUJIyAwouu4tbKdrGWTfuik=;
        b=ies67BlCr8FUuO3rskMKJMhjC5xyHioSMQZt+7QxEUVXgcE2U/o1BdyocEeHMe3yS5
         LSjpQMf1FtSWS+swG1edHt7RLzayYihO+8zZBrkvrFzYPiOGuz958Q+nL7ueiF4MbCRV
         QFfE9a7mxpsngXV3zN2RoW6/hLmBJ41US6NLElvcY7IiPibWLjcUkhUfwi1CUnsW++Rp
         fBzqPWM+EVRV69L4anuwOJ1+2mdZdxzSR/zZkGVvvt+XN6bfFOcOi/l94HO89rFlBrEk
         6ydGT6QuRZNUZx8vOYnqLlE/2JW8X3wbdcM5Wm+hgJagWUxetUyZz2b8qO2ZgZSIHqwz
         BKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773386243; x=1773991043;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UeLGjTj3/SNp/8jfrblTEUJIyAwouu4tbKdrGWTfuik=;
        b=pjQWaCCSpR/NdDKBVbvFDe4qY09F5d7vDB7XJaO3lpMXvPi5EcPecmaEm+0RLcwW6N
         03As0oaGGcv90hMZs81jh/WpZ7IqJvLVlIaOe7TjEzALEmGzVtlE3VG1dFagJfkBQtbU
         AndDtJzTjEkgzl8pu0p0lU3D258TdHC3WhrJmDkAwxpWkz502IUEU+sObpjbl5MiV9wz
         UpcnnNTXmMI3z8/AHH8ITTMINY1nDy8X8gg92D525yKXQWADihxqPg6xUmmskGC2noQF
         nFsHSqlnA6DIilQj2RfPMRCdcPZFp0zEEgI/TQKLdqLtMdqGSzPWhGvoL8IJWouueUIz
         jz8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWQFhKRpdzyK45Or0lkB2bp8lndpaAhZ6416Qs2UbQ41EZja3G3quKtChdWAaryAmRrsnv2atQMLg==@kvack.org
X-Gm-Message-State: AOJu0YyG87S44m3exmmThXuUCNoNg+AqSloq3P51/Xnecz74M4XKr4cu
	Ch1EinY4AuInrnWq2V+5CW0xYXYyf65CTWmKwttFaD26oIlAnkwjHrgi
X-Gm-Gg: ATEYQzziAgWeiGs4tggbT7p71F28DkWra4TVHvPoN5Aj2Mbr6nC5nJRrGF8imEhzRdu
	c+sWxGW0pzB/MrwbH5xGPt931CDJ+4BtwPwBj1y+NNbjutuZQ7FfrMg9kCjOhXXz5IBsYxhaO64
	YEGV/2x9wbJh3lRePzVF4jpgPcq7k9rDRyXP+ZuPA6mU2PGpHMO4P9Cz09OtiZlrmRuobvoPh3a
	l/v3cn1Zh8yGQRAFIFjGESNoCnjomlb4oqv3v4c1gxxU3shwnyZ9c0Gacgmh2Bsc0HHQ/1JOlrN
	Yezou5a12xXoacuyxyAjF9CiRXHCs0a9LCQSemgvJlaWkSEfSf8pAe8+2KXGb7nln/LULkzz8Qq
	YqYSDdTWCvdZsoqQ/dRWYw9RF0IbcrZp3cU81yFmxGpZDuYFBflUKMGQ/giDMwLhYph83OKprlm
	vl+Zc+Dyr+uhIBf4O+
X-Received: by 2002:a05:6000:2482:b0:439:afcd:b629 with SMTP id ffacd0b85a97d-43a04dcbb44mr3955380f8f.55.1773386242867;
        Fri, 13 Mar 2026 00:17:22 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe19acc6sm15140932f8f.8.2026.03.13.00.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 00:17:21 -0700 (PDT)
Date: Fri, 13 Mar 2026 07:17:17 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <d73c8388-bcb5-4a8a-ad3e-da719b09fc40@gmail.com>
In-Reply-To: <i6tmfotangjjtzek5txtvoiav3xrfvwtw6cppooyja5mvywmz6@2c5rnyxqpgu6>
References: <20260312184054.23481-1-objecting@objecting.org> <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org> <i6tmfotangjjtzek5txtvoiav3xrfvwtw6cppooyja5mvywmz6@2c5rnyxqpgu6>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <d73c8388-bcb5-4a8a-ad3e-da719b09fc40@gmail.com>
X-Rspamd-Queue-Id: B1651160002
X-Stat-Signature: c5s7zaf8ujukhbz5z57awifarhscahn6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773386244-840784
X-HE-Meta: U2FsdGVkX1+K+Gge/7nvQxWfdC8jrtrqgxryMn/R8VjFiCRfxWBxByeaTJb3ndjTwbpWlipAdhvCwizO6ICVRJr0bfFaRpRtBEVQQxb6omQesQ+m5Hm6vWlR3HmiLGQgtUkLcAHjgVUdJSRqXP249/GTCGkBdXxe4lJZwNHAi0z+zCx2871IZ/Z3kc1BZCgdk6WrukmurBxdcAWKBTTfhrfqCrk20kiDuTsVODjIMhiQf0DX69626asQP6busRe2U81VZxaF4OkljGzn0YjsRIy/LGfSlq9KzYxCQl8SfvL+evOgoBp1mEcxkPPYa/VHPe1vL6jEiRK6dsSh5tB3+L1AilZ1iK89vWB3BMXB4Lv92vEb2GneXlEMOy+j58iETDT40oCRdYyRTFW7BOOjQVRsNTuKg4n3QsamBjSD77a86pvS6Hm3tiTI7TVZsY53WlE494bNFDhQkuefMpoP98doaL3KvI4j6ekx8mYGyvncKKuaZHEaEDgrGr9+eNMJPEgCNPeD/+IhRvL+hruGquUV4KA1rnKXbEM+COy6FPygSxYwioePX+LJI5cfa8DeCSocO2zT8h+DjyCwCuh9QD8CW6iWmgtz0Pzse/kw5ntACrNPfyAq9rSGTNgIhb1t6e10osCRFjpOB/sDXpy8YUjBk0TsVNICzEIMp7GHn24FU17cqzpE8w839EGpwMjyRGq9Mvl6Dg7o4fgJP3QNgjO5W21SB644PxhieUudKZ1swTdv6f0LrjjOxmxKMKuUsnzso7KAWAV9xi2HBMkV9vrni9Hn/1spShxV4cj5tQ3+RulHXvzmrk/SoD9Mg02jC9qcqEq5w5YPMVtCQ5cHtN+bNQHmDcKSCAwi+D2oELuLcc9VlKoPJjpYzMKIt3bVwZeG6jdzLRdUr80Gvtl3rjUo2QdcIRPIyy+/959me67ekfICNEKKbjMzZW60lyEyYTYdyzNRDNRkHUZvgT5
 JrA9JWSH
 OZc6FH3QIo1nHE03GfNS2iyFnEvKKQBbdKUZfNHX2rwOqnpDgFdSAnziY3a6Xv483mgpuZEYwh7dBEsQIcTUGlZw/CTslHyiGpLB3TO4Toiq9Y2829LGtgx++QEJLJDZCQ9HJ0TD+DdT3YB0Mq78fbs/2PEwmN2Jy4QJVszOMeR7fzle+nnN9IuCqkEBNKApawUuT/yCs6uPp29tfySoeZ4c97kAEE0dh3DhHL/xhQQrbU3PsYa9d2w5JSOfYMdy6m1SA1jQi4OQuNo4w0C7OIQiJsQMB/dHX+/m95Jj4m7JgeGT95s+/oVpS06GgGVfKOIufvmKrt42kQOyacB54afVmENQiAv6SFrmr8nFCXdoeEe7V6Hp/NCrMMWMDDYQtW11GH4My++2OvR5uY5CUWrtYd9nyMInDAFg17FFn9v+9kYLQn+1nEwymx0+iZGpWOSEum+mt03yN0jJNGu/Is4jLzTw2lGKbAI9GlkR63LEU5/mqRFPWraWbe3fHdrO8yYvNOD5nwucvALnC1fApaT4bv7oTvJxtMrlSt+snwuyMGbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 23:22:48 Pedro Falcato <pfalcato@suse.de>:

> On Thu, Mar 12, 2026 at 01:45:31PM -0700, Andrew Morton wrote:
>> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrot=
e:
>>
>>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
>>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
>>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>>
>> This is such a glaring bug that I wonder if we're missing something.
>
> According to my local copy of lib/maple_tree.c:
>
> mas_pop_node() - Get a previously allocated maple node from the maple sta=
te.
>
> Note the "previously" :) kmem_cache_alloc_from_sheaf() can only fail if y=
ou
> run out of objects in the sheaf.
>
> So yeah, this "bug" looks bogus.
>
> --
> Pedro

Hi Pedro,

I see the comment regarding 'previously allocated' nodes. However,
mas_pop_node() explicitly calls kmem_cache_alloc_from_sheaf() with
GFP_NOWAIT. If there is any path=E2=80=94even an unexpected one=E2=80=94whe=
re the
sheaf is exhausted or the allocator fails, the code immediately
performs a memset on the NULL pointer.

Even if this is a 'should never happen' scenario, returning NULL is
safer than a kernel panic. As Andrew noted, the current structure
allows a fall-through directly into a dereference. My patch ensures
we handle that edge case safely.

