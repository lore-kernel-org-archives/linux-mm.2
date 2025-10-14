Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EE8CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912D28E00BA; Tue, 14 Oct 2025 00:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3798E0007; Tue, 14 Oct 2025 00:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2208E00BA; Tue, 14 Oct 2025 00:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 659598E0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:31:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C6271406FA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:31:42 +0000 (UTC)
X-FDA: 83995446444.01.35B5447
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 342844000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:31:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ig4+3JHV;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760416300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGqIoZYhEGlF5J9q7UJtMxH13yViEFe+YzUOnnzwEOI=;
	b=Doq5zuKxS/+ILdotM0TGWlI3CCeLIxoO03ldEstJmiyCVPlMOHMmlLdEndw4rV7bbxqcKR
	WLnWREe2Kulkv7X4FHM2PhE/fVAbgLcp+zpdPX7J5tye/1VU0ARClMjaDhm923Nb6AnQag
	sWnuAacYeKbNHoAEB+gNlvwsEBRbPZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760416300; a=rsa-sha256;
	cv=none;
	b=zf7ytDtKNRbkzV+FILWaXPZPIOiu7jESC4JXhJUyOWsXh3phNZr64c3yKERaa11P5k4QFW
	Zhdca/lskJb2mFNIRHKnHKo8wCGtJjRfM6Ll8v3lH9mv349R0b+MxHkoQvyowhaenBxb3n
	tUhl6xYDNS5Ep3qhVIwMNsiscp6G6mw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ig4+3JHV;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-858183680b4so812251485a.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760416299; x=1761021099; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGqIoZYhEGlF5J9q7UJtMxH13yViEFe+YzUOnnzwEOI=;
        b=ig4+3JHVFiunjQjRvyZPCz3yy1LuEiDLxiQErpXHmuMpq6U/85+DuB4oE1e1wg5Zl1
         YpWnlsQmIFsxG1sKz4lRbQacYmXi1pA33mQfqbJgueageM0z4RiFESJZeQXUSEjnpEGB
         m8d55zy4VutDrlmG/xjQJwbia5DN5TmNBDczsEEiNbZpozgIf+sz3yaLuwc3olweAjE5
         0nxCJLPsSRsk6ED5ydTutRVUitFu7urIG3fBYOnBoxFijEABc7xV4uNp+kdAFBeNQc+P
         7yiKGwdEbPg4O0WtIi3hUFHV0ZcgI4kOZKkFFbkAMoxrA/hONfkBFue+ekwAYxl/Jsmx
         tcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760416299; x=1761021099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tGqIoZYhEGlF5J9q7UJtMxH13yViEFe+YzUOnnzwEOI=;
        b=ZVmUmc4ftgyvlH0Kfn3Q07kdW7MJseftqZ8hgL+EJKJ+l13rCAqJi6gjeOXuX18cM6
         Dg2rKBdanF/SgkIX1PS95kyEBNi5nbCIESFeMU0HU4JLU2oi4ORIDG/PpfV7dCQd68ze
         EQ9zbPV+aLvPWDL3Bokj1dQXXHrI88+sikJp9n7fmQ60jFoLchYeoxJl/nTpCcp1U/el
         sutMK85wYCGby18LuoT5hiQgQc4ghc1bP8LiUxPA59XzJpwomBUN5mCHD+6V823PUAgI
         gO9/4hAftDghMj2DlBysfIqueEDHvN5qjwY2yrH/k2moY3b5AOI1L73f8KAopqSfV8/X
         6syg==
X-Forwarded-Encrypted: i=1; AJvYcCWk7bYHLo29i+eDAHGqnycWcpsAlKgLmpp1UZjBuOmDx5QVmtKf2+9LT18QxDR79GPakvTtQVv66A==@kvack.org
X-Gm-Message-State: AOJu0YwHDcZegE3sYOO1I9KkLSGHjObC3jeCD5yN1NWLCw+H/sXzF/s9
	LjkmtEQHUdkLhhdtMqt3gFiQFCMbr+xKjJEglc9A8amwX4ZvCZyPMjlfJbHxDoqmSrv6Ew4tV2Z
	jPXDtIZrrUIDn4/hsd15wcKEL23Fybrc=
X-Gm-Gg: ASbGncvuqGPgbrq38qThloT8UHBOe1frg/JAFMjTPucxcp5FDv6cZNGr6H76WjgacvC
	cqUQJWJ07XM3X32IgLTI3DGX2Ej1AeXN4SzHrGo3/8oXqAlfgJnrOO9Y7q4a+E8hvx4y5Tz25M6
	zl9Mpm11BWwTsBLHzlbbbiLpvOMsPQ1MJ/QV/UWnTZeKpndyYSIhu6KHFtKCgNn5Et83luFHlOn
	C07uoj18vJvrJtVfk/Aqoo3BYce0oGiDCDN5YcZmaN+SYDGSuBUAOrxIvHCmrNK+npY
X-Google-Smtp-Source: AGHT+IEK1Vpz9Egp/lLu8aNOuk9sM4DTRSkzqirUw9B9yuBpU63FECc4XYXC1vijYJUmRARwxWevuR/ubJlXoWz0e5E=
X-Received: by 2002:a05:620a:a119:b0:88b:72c0:aaec with SMTP id
 af79cd13be357-88b72c0b574mr135616185a.88.1760416299121; Mon, 13 Oct 2025
 21:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <877bwyxvvl.fsf@linux.dev>
In-Reply-To: <877bwyxvvl.fsf@linux.dev>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 12:31:26 +0800
X-Gm-Features: AS18NWBKX6vcaZdIWLrNvH9v8Z7LxGQUtWG9jfBGvwWNdS5B-18jtKFOlQNZSPg
Message-ID: <CAGsJ_4xpSG1D+nkFUMe-XvmKPGR-CdEi_G881snG-QgZBiFozw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Harry Yoo <harry.yoo@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 7irksoit4z5otm7immkzaomr1dweixfc
X-Rspam-User: 
X-Rspamd-Queue-Id: 342844000F
X-HE-Tag: 1760416300-69016
X-HE-Meta: U2FsdGVkX1/b+XYaszMCGk9J3nE7mUeXCQ911HijPnTUFc53NZ/rGcjTwFaHV9AJG+pLEhj8MNF0c9EQiOV0ji2iH2XO8ifWPPaGwwepDAPcbI+bMxL9WkkADR0nOZkCqDv3WE7EObjNoN3mY96HUaO+Z/ocS0DgR27OsQwqh6sKo8m0ZUdNrXpROEA6SOepNptNQGU8Mnew96AyHdKlafoAx3pNhzIZJueRMDk+1bOGagm34/dqMCNixIBKDLnygswZ3OMyzMLQypb4QPJSXB4HH6ZZQK4lYP6CW/AfQKhxa3pkG0qz1sxGFjBGuPTOtZRuUasBLnJO0rM61IC2sg1pAfKzXzSHvaOtRODfr8+IK29aSj3TfmDiDd0XGr2FfYT4DKYYN1z0V7FAgarxsqBmWvifLDmkpmmBHLGOdzBCsZhdigX6BhBtYAMhIQkVYx0LLNIsnGPPI8cIWvFH2hbqvUKZTyXuKpYZgs4dczVMN4UaiK/M5dhM1WG/QYF7hFuXyE589oQzppB/7md5Zacta56ZmYpYMljadwW28bDAHXhUZbL/wy4+0EFMpB9RL5sy8PoV/ThQcDnK5SLlBYAmYF79901EVacZnnzaZ0vY6yTFbCRqQ3SeRYQ/PZiGWyzdBroMpsxyH2Aql1eHWm9pf3tt8r9BqW8tjRcTjeywKjZyz3Ka55p8F/Xk2V50kDH25GbMvT11I0aZy+u14BnOlvA3Czxg0GlUgDMDPeXkUhut3tk2ZRN7W5chqe2wfidQySM5C4d50C4FeN6XHBnDcUaQjnRVrT9k6p+mMwRojHJe8929Dky7N4wdkBY8wZ422qqNGG4Ta3c2r4TsFhXfwlrLm0ds6TgPJB1UqYtxK1iwSMOzp4R4LtA1g91Hzzo0RCRBz7WukNIuH+ePU9rJmya6o/+9DtHlKiusKkX1Oivyqso2RnPe8KCqAubaPlggj0L4+WU9hFqvY1N
 5LGeNrgc
 Tj6dqd3kzlARO3nQYQongknnSJ3pWouOJAdT8of3Z+sev6Lv1H4LdIAQnYY9qSFdbxtZUwGp46X5cnyPuBZdZm6TNaZEMZ2HbGTJE1CFGzOc8bUWOLjb6S//MjFSrylw8GddSb66KAfS1VEva37uhgguPadkbt4eLOl4eaQGoC7p8zWiGRkaB0PUWdlMJ5xaWPMN/b34aSlCAU/KvZEkn05Y1POYn0zr1sRghCPGd0yT18R5YqFnS9i/+gKcTUDgSUcZSNExYCgxM495kBMP/R/Dd0kOEjjc9GBlICjUfIRPKQ/3aaV9gczUKkGvlriGlLrFC/d9ibgmRnvho0JA375lOm90VldJsxegwYNSlzHNT0Xo8Cxa02FZ31KYOrHnNZBPDqi7igicihyaY8FKIpRmr7gXbGIE3vaIyRUxEzOFKSM5TCOGw//pE3OkyzDtzJvKMAVD3h65y69qB4+4SeJQOehuPOTXwar8M9IoQ4bVYnId9txu9zU2yzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 6:47=E2=80=AFAM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Vlastimil Babka <vbabka@suse.cz> writes:
>
> > On 10/13/25 12:16, Barry Song wrote:
> >> From: Barry Song <v-songbaohua@oppo.com>
> >>
> >> On phones, we have observed significant phone heating when running app=
s
> >> with high network bandwidth. This is caused by the network stack frequ=
ently
> >> waking kswapd for order-3 allocations. As a result, memory reclamation=
 becomes
> >> constantly active, even though plenty of memory is still available for=
 network
> >> allocations which can fall back to order-0.
> >>
> >> Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static =
key")
> >> introduced high_order_alloc_disable for the transmit (TX) path
> >> (skb_page_frag_refill()) to mitigate some memory reclamation issues,
> >> allowing the TX path to fall back to order-0 immediately, while leavin=
g the
> >> receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
> >> generally unaware of the sysctl and cannot easily adjust it for specif=
ic use
> >> cases. Enabling high_order_alloc_disable also completely disables the
> >> benefit of order-3 allocations. Additionally, the sysctl does not appl=
y to the
> >> RX path.
> >>
> >> An alternative approach is to disable kswapd for these frequent
> >> allocations and provide best-effort order-3 service for both TX and RX=
 paths,
> >> while removing the sysctl entirely.
>
> I'm not sure this is the right path long-term. There are significant
> benefits associated with using larger pages, so making the kernel fall
> back to order-0 pages easier and sooner feels wrong, tbh. Without kswapd
> trying to defragment memory, the only other option is to force tasks
> into the direct compaction and it's known to be problematic.

I guess the benefits depend on the hardware: for loopback, they might be
significant, while for slower network devices, order-3 memory may provide
much smaller gains?

On the other hand, I wonder if we could make kcompactd more active when
kswapd is woken for order-3 allocations, instead of reclaiming
order-0 pages to form order-3.

>
> I wonder if instead we should look into optimizing kswapd to be less
> power-hungry?

People have been working on this for years, yet reclaiming a folio still
requires a lot of effort, including folio_referenced, try_to_unmap_one,
and compressing folios to swap out to zRAM.

>
> And if you still prefer to disable kswapd for this purpose, at least it
> should be conditional to vm.laptop_mode. But again, I don't think it's
> the right long-term approach.

My point is that phones generally have much slower network hardware
compared to PCs, and far slower hardware compared to servers, so they
are likely not very sensitive to whether memory is order-3 or order-0. On
the other hand, phones are highly sensitive to power consumption. As a
result, the power cost of creating order-3 pages is likely to outweigh any
benefit that order-3 memory might offer for network performance.

It might be worth extending the existing net_high_order_alloc_disable_key
to the RX path, as I mentioned in my reply to Eric[1], allowing users to
decide whether network or power consumption is more important?

[1]  https://lore.kernel.org/linux-mm/20251014035846.1519-1-21cnbao@gmail.c=
om/

Thanks
Barry

