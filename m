Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4639ED59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 08:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773326B0006; Mon, 15 Dec 2025 03:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBB96B0007; Mon, 15 Dec 2025 03:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3736B0008; Mon, 15 Dec 2025 03:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486496B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:29:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D77A213C29E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:29:44 +0000 (UTC)
X-FDA: 84221031888.18.F10C1CB
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 090D14000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:29:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cCoFazNb;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765787383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+Rae6Tnr4feXWnwHZ1+C9t7FYdcdoho4X2n1jA93Ws=;
	b=EJdahYrYe15oFwbNKh1FUxDsrNfJJvd9pPJBGYLrX+OyIHdUQaFuJkdpoURwn+th7vrabV
	ybOaIALeWNeO1ygWcR/t5lza3/S3Vzv/VsZRreBPDThHVNbYeDu0uujcwJyttTcFYJRSRS
	Ub13vqXCLSD0NhdTMHx49MuJ6hhfHYw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cCoFazNb;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765787383; a=rsa-sha256;
	cv=none;
	b=I/UAZfel34ItZL7q9C5GA0AFBtfs6orVjy/pv/8V6LspVQx4cSpkQf9NjqiOo06VeGyKGU
	I8ZwzXnDHwgoMuWQnVbBmRDOB+ev99oRstT1lrs38ECJowHvyKjhP/EKW+Mmc91FhiczDu
	tKVawJvLwrZzp8d3c/3v5mNvGNAkFbI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so4974472a12.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765787381; x=1766392181; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+Rae6Tnr4feXWnwHZ1+C9t7FYdcdoho4X2n1jA93Ws=;
        b=cCoFazNbJ96Dk2PEHGWJ1R3nr77X31NDmO1K4YKpa6Y5M5HidBaQmcHUR5vRuX4xa4
         wz1gLkbxXVz+uhm7rObV/zsjIVaRt9Z9KNGkkjb1L3TSccAYH+3Bjhid6UsupSvVgSgx
         uwsqbsM2GBnfMR4v6ow1vyohRUTJYa3ud2JQREuDRBPWqwyBOXcS38yN7tjjsbAtxsnC
         Xwd9thqn+qXzQ2JbaWJqjIe8HeXLfwbwqxGA7jAgOJnCPZq8/D3SVN1MbO6qoTkDF8+p
         JYjfT6xzUvC/k7+MmFXQ1SPil5JwIym+N0aG+Sb7pO/ibhsiSQ4Yfnk8PHIxZZutYgWE
         /PNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765787381; x=1766392181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8+Rae6Tnr4feXWnwHZ1+C9t7FYdcdoho4X2n1jA93Ws=;
        b=d2w5vtID1GySgRuMDp5ZkNOpJp9G54hhyunQyRvv2VtkQ9KAYpJceFCpKwc4WPoI3n
         pWGS9CkH2bzfbLc3UxmE3OQYZiBA7FEJBLCYJ+7lQ/AIGltUPa+kWmHR2TNb+PYRkI32
         28XI5hKfrJSY0DWeAa+dpeZBZ572sDU4Okh+2N8IDbEX1nJj0End14cOsC6jlLPkzFOr
         mzq39hBvBwVBZNAATEejKWNwPLLDKMblM/m1jlxvbsUL4pfgVyb9NOnWqBJQbmiXWlAA
         N0BelP2MpdwUTQfGw/Yapq3A3fW0lf9+NAR8RjHKfTDp/WJF0GyjA12HmQY29lCb5v8L
         I8nQ==
X-Gm-Message-State: AOJu0YybEURJwlL25dQpAtpLEE3WGW3K60ztdE1p3BbT/lBYCz8Vt3kj
	ak22ziWTb79OAI4xhFoUoJtJ8XT06h1NichM5v5f+fKd4uoJQGwm+qldkK7exjrKnMJFQ46Jf9z
	muIdCWF28hSNBBatCIfDfF70VccCjBq8=
X-Gm-Gg: AY/fxX5SzOXgp7hv2SOg5WuB9ebUALQLIqSi33iZJdIM+wPWpu7z9Rra+OHmnQmUH09
	zURcwJG2QpuLUHIgnUH445RTb/+WnDayCx+ijkZwmFjHnOpsye7UT5H9CEGfyLlSljH35RQo4Bk
	Ihq/rm7V+L5cN9p3Zq0sNxls5ccf0pD87XkON6ZTPwcrHHZGMY94ZRm1+vl3Baoe1+zpUR68Rw2
	XQyvOA8sRaI3PgwZimfAsyu2hWAVrltoLbCh808tobNQ6W0B6hWZm5rI1Ig95/igILJP9WhTdSm
	f1iohbslywI9X7qFaI2iZUUEN28=
X-Google-Smtp-Source: AGHT+IGRqBc8I0NflOBy3oliVc/I9u/bSrqvpBXQ6UEvCCiezx0ILL3u1RZnZngtw+U69waTs51EIwa6S1lhHAPjrOk=
X-Received: by 2002:a05:6402:4407:b0:645:d34b:8166 with SMTP id
 4fb4d7f45d1cf-6499b3009abmr9662602a12.26.1765787381139; Mon, 15 Dec 2025
 00:29:41 -0800 (PST)
MIME-Version: 1.0
References: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com> <3edf7d6a-5e32-45f1-a6fc-ca5ca786551b@huaweicloud.com>
In-Reply-To: <3edf7d6a-5e32-45f1-a6fc-ca5ca786551b@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Dec 2025 16:29:04 +0800
X-Gm-Features: AQt7F2pC9l-pkB50oh7wNbFDZA--Sp8cR3PR99yyO6YmYauKOUVymRwEZdki-V0
Message-ID: <CAMgjq7DVcpdBskYTRMz1U_k9qt4b0Vgrz3Qt5V7kzdj=GJ7CQg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y1z95d8jmaojm4mpf857m1bjk9e3rn51
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 090D14000B
X-HE-Tag: 1765787382-796725
X-HE-Meta: U2FsdGVkX19YmJR2xLW1zQWsTD9Aj52ZDQgKvFAIqulvwfb16Dgp9RODuoHpxY6MGuU8CLGOv6172IRO6Ao+ldEoVHNTvav8sp8m9P7ypJeM7chMkSnSpo94BCRt4/o5AyyqQYCLjVt6f0RzejpApW0Dq8TeH78/ZTNerJWq8WwaokT1Pn20QAoK4ZbQ8NuCezuLQToL1HU0L85uh3hE5RaW7F2nyFJZaITi7xAuCOFQDZ4wtNmY+7bdnZ6welOK39B0MS/hy7uipahLJ/dOb4lDQUJJRQcQN4CEdYzxboukHBI0HA2pUPMd3hhThBKNOOEBXOBAQNVet/RzvHDSBeC3ZXjY7IferOnsz9M0O4iaKTNAgXTyjk2H19FkgFt3M5Ee2BDejXGlIS5KAP3iXiOyuzC7zFCJUPBOwHYLilKD0hzR79UVffGKosQ0whm8s+AsD58Nj/WOcHbm/r9roQykt9H9BdJpnRHVQw65Fl9jwRjLgvwwMjrn+sL3c8cnXgCips3lbH/28EnajSDWsXYKOrEtPCZcMuA4l5csWjdv6cb0s3EpjxLnfNPcXKw86/gTgiG+iaJwbPC/c2PMnY+lT87k1nMxXxSjJMXpagY9LD0NTr0THqhU6KsstEwU75RNrilPoRRIc7UwKjwwByfFje2Kcjl/tEsYsvUUOlQlX/scpWCntaI6kiXqhliVAxEVGPT4Mxw0KWgdJYIHUWZyF0KhIH3CVVYgReswxZi3zH1HwjJ9V6K4Ukbf2Gb/41euNT4nP72Iff/o311fWMtSEjg+7OlYAtkg5P0579Rtqgwi8S45TtNb2LYTrtZwrfDq/ikt1e5cY2GPMjAFJ6hlrGcEf4zjt8t5pgG3P9/Ch0/nnN3ROdsgV++cwuQBmmT2QOzFZ+W5vLfmYasuzQ/EGnqef7Pll0AYb5RiBq7oITKAcj0B5W52CrKK2xO6NSf09U2CmPUmcuJIiR5
 gUI2LHev
 b0GDBzK1JIZuc02s54GIviXPE1O09N4REPYinxH16Uv2KD027BRPh2xpuoKtRnesdf75LYmNpcZ8dyqvRG0OSADwTKKshHf+eSUy4AQzOjYx5hm/slZrDoRwD8Mo5c0Z49ksFyhXvZbTAhNB2R7w7Ir4WU6GAPg5r5naABajF+xVUcefEJK0yB3K6p0FTnfqgvnM5XlUDEc94BbsjUoEtwjJAQaDpRGZRynYZWUgwlWq8BnUVwvW0PPZJnxvO3JgDjvMONGnF55JIvI0O/Jstg60JWH+X1Ur6lEs4gkMiSNEiAcNKTQvIx6znSPBDIbr0qadBWBqNplodrse2qJ2AtdOSs2rMRi4jlkz7C0DCc0st1qpB2Vwv2tm9B67Le4dZCe8NyUneo3j1ASsxPrFbdpSXGpTsIThxA/hAXJgkFnUxA6fl2yb7f6+VkPosaUyaDSL2s3kqJslQVW5W9OXit5bm+pYUlKMx6WJ5w5suSkQJAJ7LsJ1aJVhsjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 3:38=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
>
> On 2025/12/15 14:45, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> > introduced a sanity check to catch memcg counter underflow, which is
> > more like a workaround for another bug: lru_zone_size is unsigned, so
> > underflow will wrap it around and return an enormously large number,
> > then the memcg shrinker will loop almost forever as the calculated
> > number of folios to shrink is huge. That commit also checks if a zero
> > value matches the empty LRU list, so we have to hold the LRU lock, and
> > do the counter adding differently depending on whether the nr_pages is
> > negative.
> >
> > But later commit b4536f0c829c ("mm, memcg: fix the active list aging fo=
r
> > lowmem requests when memcg is enabled") already removed the LRU
> > emptiness check, doing the adding differently is meaningless now. And i=
f
>
> Agree.
>
> I did submit a patch to address that, but it was not accepted.
>
> For reference, here is the link to the discussion:
> https://lore.kernel.org/lkml/CAOUHufbCCkOBGcSPZqNY+FXcrH8+U7_nRvftzOzKUBS=
4hn+kuQ@mail.gmail.com/
>

Thanks for letting me know, I wasn't aware that you noticed this too.

From my side I'm noticing that, lru_zone_size has only one reader:
shrink_lruvec -> get_scan_count -> lruvec_lru_size, while the updater
is every folio on LRU.

The oldest commit introduced this was trying to catch an underflow,
with extra sanity check to catch LRU emptiness mis-match. A later
commit removed the LRU emptiness mis-match, and the only thing left
here is the underflow check.

LRU counter leak (if there are) may happen anytime due to different
reasons, and I think the time an updater sees an underflowed value is
not unlikely to be the time the actual leak happens. (e.g. A folio was
removed without updating the counter minutes ago while there are other
folios still on the LRU, then an updater will trigger the WARN much
later). So the major issue here is the underflow mitigation.

Turning it into an atomic long should help mitigate both underflow,
and race (e.g. forgot to put the counter update inside LRU lock).
Overflow is really unlikely to happen IMO, and if that's corruption,
corruption could happen anywhere.

The reason I sent this patch is trying to move
mem_cgroup_update_lru_size out of lru lock scope in another series for
some other feature, just to gather some comments for this particular
sanity check, it seems a valid clean up and micro optimization on its
own.

