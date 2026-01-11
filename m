Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F115AD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 14:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA3E6B0088; Sun, 11 Jan 2026 09:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB5C6B0089; Sun, 11 Jan 2026 09:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9046B008A; Sun, 11 Jan 2026 09:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF9D6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:50:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE9805B985
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:50:20 +0000 (UTC)
X-FDA: 84319968600.24.3318A36
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id CD6ED20002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:50:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ogz8ajsW;
	spf=pass (imf03.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768143019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3k0f9P6o12I/Wj1ZSwaN2QKUNhSwH+5PojpXHVPsDpI=;
	b=sizQOFyuMMACRSlFWml7cfTDk+8I7iNFPn/MrBmTYie+gYuX/sIxZQZEyO9Xivm2G4+Lbh
	lGMtbWrBU/OduhmPojeOI38apXXhneTeozVME2iTSgTGCQDNYXgobmy/mwcbDJ5ZssKD2h
	bxQ27+ewGt3C4jay/7uZ6znB/7E438M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ogz8ajsW;
	spf=pass (imf03.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768143019; a=rsa-sha256;
	cv=none;
	b=MkPsFWU40sd/vGai5zabZBsG4kxYsEVsM742ef9sTMv4ofNMxiyEEcT+iwT/Dd87hEQYoc
	WWbFp6bC/yk2xxb3IEs6SB6Dw2LHmBGHPm8GtNlf/eLQ4yV4gi1wiJ89CWYDp4haBVgmKF
	26m0QjIXZ53fnOE5rTtjMPD2YZt0xy8=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768143016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3k0f9P6o12I/Wj1ZSwaN2QKUNhSwH+5PojpXHVPsDpI=;
	b=ogz8ajsWj76Y1EcW8pmpV6YOcpuseqfgaEmbwASTVcFr99DG4rpEO61d9x9S3BB1zeSzUa
	VQIEz+lUMwYfZAnBDkW655pA0+vtvLextk5Q1DeFCJKOa/K7SpvhrkInRfgbDl2+UQguSA
	mBsMYFs5RO6dxlAWwsPCZvR0YMLD34Q=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in
 move_to_free_list()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yajun Deng <yajun.deng@linux.dev>
In-Reply-To: <20260111142425.2783953-1-joshua.hahnjy@gmail.com>
Date: Sun, 11 Jan 2026 22:49:56 +0800
Cc: akpm@linux-foundation.org,
 vbabka@suse.cz,
 surenb@google.com,
 mhocko@suse.com,
 jackmanb@google.com,
 hannes@cmpxchg.org,
 ziy@nvidia.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB6743E3-82B4-4212-A03D-34A8A858D54B@linux.dev>
References: <20260111142425.2783953-1-joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CD6ED20002
X-Stat-Signature: 1kzub73bg53bi1dnmtspk8anypx9zsbs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768143018-141652
X-HE-Meta: U2FsdGVkX1/KWlfI4u9jkP1rUDksQuRVE2bOEbxb1OFS3vyxSomfKkQGSj0jPRi5Jm5lpLuNVIbj+tjtU4ARDi6UwM8rJwq4nuARq3pFknNwhTSYHB9cdoFjM+64kIgpOAOYnKvBpL8aVCqm7sEorW3ZOhM5nVJa3JA6NNDdDSYIFxCRm5InJLzRunreZ1Ft06HuZGT0HAyPeHX/N5XBN+b8lVKrQAgFGGLYvhb71UffoRXIGfo8J1tABc7p/ZWkq05IGqiK00WGoXYwbgJi0nipeCvLdYn4AO3Ft5ucg0E3aRA4MrcrLdBfv430kAcrYG+FD9ZNP6r3x3Lt5+LVY5nmDrE2hVJdl5XNPZt60ZEtdKwvSWMT9Dp9Vw4SwlO6GYA+8RYB1KeQTpctCLl8YXGDiSkKqOoILREg/RWxLCLZkCxwsOQaG391ASLBETHo5Zj4wY9KwZtZM+4h0YgMcDg51LEUWR08wLl5PXJN+IRxUy6Nwlgoe16OqeJkH72ajeZq82PLrn+IklXrwoRNI3kaqZMccCZ4F4Tlu0QKckhEOOBt+InaMhCo7PXX7aH9sHw9Ovut0XE0adF/0wwx2CW6CXTd8TySjWxOJakXwLBNUzs25DJWXV88ovp+PRWVnAKQ8X5KLXC3JrceZmngAxllmliXw9b8RVn/i/fj5HBVTs3bnuxiYxSSDxzrSyvOxaDiqqa5jPzEDoOYNapPB0x5LnArWyOdpvpwGzWlDHYpsHatcfD+pk0+1NvJmdSsuptJZIqjGwvZC/Vb9XeRzhU8GBjNwj2Q1UPXxlsys1mmEVc4BXi/90qZNiJ9s35RBE1jqpE75CUOvcZjBFFKFZyShhf+JbGWsLYXJD6cC+NjBTiRvnivZTc4MdLMUC8tPqPHRFAEpMR7ut5wFRgHhWniFIWaiP2SDl4KINeiZer8y4jfrSun3NS893JPdKGsH+MG6k4PucsESZOqsos
 kbUG+/aC
 p2oJhzbdj2Eqxjr68uv7rcpGCGpTuIEv5HIj5iAFA4EUHTYRTyoV2HLGKjhtXfyLQBmP5Ze6VcTpGdwN8JQ7llsFCkoleggR+IXjm2eVGAH87Zw3yjz1VnZKSjo2dwS7lGEkkKLrrcvYZuU0ZCdUktg2rJnG4F99JZ/+IQc3pQLccZviMO9PTl9YTjlGdwCer5c/WN6AK9WxraJZhTsv8BUwKMjBd9MVa+aOO3aHb3bSWfrU70OA/eRcIX9PlmBTaNjfCA4Lw52fKMLtALs6gqnwj8U3FKNGeKKdMaQPL6hdcQ8xMfbx/IzTZJ+uYCCKMEzEvowM6TUIZDCR3IyWbpKFjAsj5mvgev+tUl6nnp3/PyGMOzHIoe4EBBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 2026=E5=B9=B41=E6=9C=8811=E6=97=A5 22:24=EF=BC=8CJoshua Hahn =
<joshua.hahnjy@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sun, 11 Jan 2026 21:47:42 +0800 Yajun Deng <yajun.deng@linux.dev> =
wrote:
>=20
>>=20
>>=20
>>> 2026=E5=B9=B41=E6=9C=8810=E6=97=A5 00:31=EF=BC=8CJoshua Hahn =
<joshua.hahnjy@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> =
wrote:
>>>=20
>>>> In move_to_free_list(), when a page block changes its migration =
type,
>>>> we need to update free page counts for both the old and new types.
>>>> Originally, this was done by two calls to account_freepages(), =
which
>>>> updates NR_FREE_PAGES and also type-specific counters. However, =
this
>>>> causes NR_FREE_PAGES to be updated twice, while the net change is =
zero
>>>> in most cases.
>>>>=20
>>>> This patch introduces a new function account_freepages_both() that
>>>> updates the statistics for both old and new migration types in one =
go.
>>>> It avoids the double update of NR_FREE_PAGES by computing the net =
change
>>>> only when the isolation status changes.
>>>>=20
>>>> The optimization avoid duplicate NR_FREE_PAGES updates in
>>>> move_to_free_list().
>>>=20
>>> Hi Yajun,
>>>=20
>>> I hope you are doing well, thank you for the patch! I was hoping to =
better
>>> understand the motivation behind this patch.
>>>=20
>>> =46rom my perspective, I believe that the current state of the code =
is
>>> not optimal, but it is also not problematic. account_freepages seems =
like
>>> a relatively cheap function (at the core, it's just some atomic =
operations).
>>> Personally I also think that semantically, the code currently makes =
sense;
>>> we are doing the accounting for the old mounttype, then for the new =
mounttype,
>>> in a way that cancels out. And given that there is still some cases =
where
>>> the work doesn't end up canceling out due to one of the mounttypes =
being
>>> MIGRATE_ISOLATE, I think that there is enough purpose in making the =
two
>>> calls to do the accounting twice.
>>>=20
>>> On the other hand I think there is only one place in the codebase =
that
>>> will use account_freepages_both, so it might make the burden to =
understand
>>> the code a bit higher.
>>>=20
>>> What do you think? I don't have a strong stance on whether the =
performance
>>> effects are big here (if this change indeed has a big performance =
implication,
>>> then we should definitely go forth with this!) but I do believe the =
current
>>> code is quite semantically sound and more readable.=20
>>>=20
>> Hey Joshua,
>>=20
>> Thank you for sharing your thoughts.=20
>>=20
>> I currently don=E2=80=99t have any performance data, I just noticed =
from looking at the code
>> that there may be room for optimization.
>> You=E2=80=99re right. The original code is indeed more =
straightforward. I think we can add some
>> comments in the  account_freepages_both to make it easier to =
understand.
>=20
> Hi Yajun, I hope you are doing well!
>=20
> On second thought, I did notice that at the end of move_to_free_list, =
we have
> some additional conditionals that depend on the migratetype of the =
mounttypes.
>=20
> What if we open-code the account_freepages_both, and skip doing the
> isolation checks twice? Your idea to use the ternary operator gave me =
this idea!
>=20
> @@ -869,14 +877,17 @@ static inline void move_to_free_list(struct page =
*page, struct zone *zone,
>=20
>        list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
>=20
> -       account_freepages(zone, -nr_pages, old_mt);
> -       account_freepages(zone, nr_pages, new_mt);
> -
> -       if (order >=3D pageblock_order &&
> -           is_migrate_isolate(old_mt) !=3D =
is_migrate_isolate(new_mt)) {
> -               if (!is_migrate_isolate(old_mt))
> -                       nr_pages =3D -nr_pages;
> -               __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, =
nr_pages);
> +       if (!old_isolated)
> +               account_specific_freepages(zone, -nr_pages, old_mt);
> +       if !(new_isolated)
> +               account_specific_freepages(zone, nr_pages, new_mt);
> +
> +       if (old_isolated !=3D new_isolated) {
> +               nr_pages =3D old_isolated ? nr_pages : -nr_pages;
> +               __mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
> +               if (order >=3D pageblock_order)
> +                       __mod_zone_page_state(zone, =
NR_FREE_PAGES_BLOCKS,
> +                                             nr_pages);
>        }
> }
>=20
> I don't think it matters that we reorder the __mod_zone_page_state to =
be
> after the account_specific_freepages here, so hopefully it is OK here.
>=20
> So we can achieve the best of both worlds by preventing the duplicate =
adjustment
> and also keep the control flow simple! (We can also just include that
> additional check inside your account_freepages_both as well).
>=20
> This is just my small idea : -) Of course, please feel free to ignore =
it if
> you feel that it makes the code more confusing. I think that what is =
"simple"
> is mostly subjective, so this was just my thought.
>=20

I think this is a good idea and I will adopt it.
Thank you

> Thank you for your thoughts, I hope you have a great day!
> Joshua


