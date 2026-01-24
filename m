Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D2DD715C1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 05:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30D06B058E; Sat, 24 Jan 2026 00:33:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1516B0590; Sat, 24 Jan 2026 00:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90AFA6B0591; Sat, 24 Jan 2026 00:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77E956B058E
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:33:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FF4C1A01EE
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:33:12 +0000 (UTC)
X-FDA: 84365739024.03.350FA53
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 12DD0180007
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:33:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Za5VYFKl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769232790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/JivesScLSX/6kToyIOb3NROMvUUsHuu+t7pWBHgDg=;
	b=fZJE2dv4M94TMd65AWpygX7jz6JJzjFDYegRGCjYzaMljGAb0fJhedQcH400bDLNkmQXDn
	zQgaGRRxNN6eWX9WhPNjlfL+4CKm5007gQrFIyrNcih5Mbg0PeMIU0fmN7RgZhFPdod8Hd
	Kl39qXEt6jyztKJMNB3YYjoFYBsGLiM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769232790; a=rsa-sha256;
	cv=pass;
	b=VWE97JFwmVec78jdVnbC8gt05Ley9JkOLaULcar5XjBdxAmRDwC1pSV3HMzvy9nXUGEti3
	iNdnTQ40plBPeahZRyhQSivEaa5jfHK71mtVmabXwUIBisz9K05BH1GBh4eSdk0cYXhsg/
	k1NQHes0vyapuK93hgGHGur44pETMMs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Za5VYFKl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so17605e9.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 21:33:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769232789; cv=none;
        d=google.com; s=arc-20240605;
        b=CNL/PG3Igvh0ZMn+1+K4khLyRt9NHOrFnLHR/u9ZxSIXdQJRH8e6zFLbgq9anx5fLE
         DiXuD57NPaauA4MN7wjjQgd//D/TbQZR11aXEmyblq75KvdxAIKj4DnaDo8NWqWuCj7G
         PZLPEQ6pHcH7G9zcR8/3lV4iLw80K5FufRE5xyrXGBiAGAohw36esYi6azmmbTm2qtut
         v5T6ooo6xgfWqJoRsQPH2yrVzJioszd76PAY4bPAKxjwY7JH0W3wRp46muLAzwLb9cMH
         Qq3Ceq/FnnZubdxklzFq1bNkpZBWmnThaEG70sQ94dbLGUdp9E7JUxEvQkvjAG96kot8
         L/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+/JivesScLSX/6kToyIOb3NROMvUUsHuu+t7pWBHgDg=;
        fh=ruurHQOUecHddA5dZBd2SQBB+mODMlyhm81hLCcttZ8=;
        b=UxDVEm/KFqpGOE6HezZP8+xRCvI/KqjnyPtddIhRBrJwbi4fjt+A2khnClzcFu1q63
         eHnOzVej4qiZ1hfOncfsn4T5xeA17cYVyrH/RZu9FGVttfe2XIjyoQiFf/ZsBT2rjImG
         p4BwlIeQ9PEorDs5jTdGCj7FPCzg1AoWOVFLypjEIVMvCE1wdbZkoxCw1GWLmUEddDPp
         27M2H7pxne/RCZDzam116/yMgqtg9pZ1z4TTDifovf+zABsYhkeed2OfCsVokGKh58vA
         YHnyyL4aAft7QRIYEV/s7CzIDHNgcl5/o0j77SUG3ReB/LY9o7vDWFW1J0HrDS4cNFAT
         2xEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769232789; x=1769837589; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/JivesScLSX/6kToyIOb3NROMvUUsHuu+t7pWBHgDg=;
        b=Za5VYFKl8WimXDq2v5w8k7WMQheXIbV7ShJZV8/EvjFe+SZH8+WxL0BHdNV0AZI4Jj
         /nXpjr0I4bjnOxqzgy0x7ilcvw6AUEFBzqkH5QT1P8wSRMbtEH86naLq/lFYeTqZa5Uj
         eVCVHenn2xyagsehYdIpZnsEvcUiUlsLOkhp5rLveqpMDBeuYdoRAqR2Vp+KLOzWOZAL
         xnjyqpcAY8kv57ahvMHqYHnKQ0MT5Hs5mBUx1+SpN/n9vsv6MBh5RxqfMWWtTn+PGlsm
         rIiINviI2IQ2VEo0kN7q+Vl8dQbks5w2bNA+00CNWssLpbZXayTShwszZG4wyHvN5KeX
         Gq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769232789; x=1769837589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+/JivesScLSX/6kToyIOb3NROMvUUsHuu+t7pWBHgDg=;
        b=HWxvHIBAiiCD06BoC1fWoe3VhNtYb1huZDweJKX7D4qeyFImMkX6AGYngmOUaJVV1F
         KOiO2DUhyLZOSygaITvxy6NwRDSszUk8ngxQKsoRaiVi4kSvmtONbZuFCCoyOwnmnnEq
         0EtzgXTxYabbs+p6sup3g5D+u8Fv19rWl3BAVyyIe7Ei/9/c6rZw59o+SQ+m2tWP1v9G
         dL/q2iMtydY++1pPGqjI0NIJi6sdZdBeEwgrxr8p5s8JovrlxpHGyW6/yGxA5PggRxr0
         D4T9NMmirNF44C8gjQpl8r48lfxoe0une9/wX/bJUaXHBxpqOOQV7gqEKg4/6PHNZsM1
         0UuA==
X-Forwarded-Encrypted: i=1; AJvYcCXK82/8ln5ZdRloNZZ7hzdSamd4opld/zSJIuMAcao42M4cc/IQ2TFly2nL/QH4uZL35ZGUbv6sGg==@kvack.org
X-Gm-Message-State: AOJu0YxOtCEnhlpmpJg/6voLxANaJdXYmubJgaAT5ZkNzUVxTeBD9EF2
	k1znjia4e1xCs0bDaLDpIfm2HWwHdFnIYHaCvdd2/FFbdTJh+1MyHjsxPQA8XJUgX0fWfosw1sN
	VRxuOGbDUqbg/VlCxerEqNLqqK0cEnpUCXJ7m2CaC
X-Gm-Gg: AZuq6aJDHBKCqLvOk0fdQW6OOAM+WOrvmNOyf3wHDvjB3de9085DfJRYstKTLavp3td
	CN1uIrqu7Z7NRZhwWsq6ZbPKDEb86lo+OBH/y5k52Ht2mnHtdO4PDUeMgkPiaYSMPFTLOBRrjw7
	3GSzTIdZuz2Nta21vxskhXoP0iOXIUbJJS8wdSUu4iq8xqvgAEajjUgREueBjL3YufB2f4IB+SL
	5RJxaZkeicBewGjEiH6ADQUZu1RufjIfNfsvDqzL8jUrZUb9juI15Q5HlVHzGJFldoyP4a9Zfqq
	GZz/eM/rm9H5kvYuSgvgD7xEg7k=
X-Received: by 2002:a7b:cd17:0:b0:47a:80ec:b2f7 with SMTP id
 5b1f17b1804b1-48054530914mr346175e9.14.1769232788305; Fri, 23 Jan 2026
 21:33:08 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-3-jiaqiyan@google.com>
 <671528cf-6fe8-464d-8028-ecd5822f9053@kernel.org>
In-Reply-To: <671528cf-6fe8-464d-8028-ecd5822f9053@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 23 Jan 2026 21:32:56 -0800
X-Gm-Features: AZwV_QjZfcZ1GYzD-Lb4B4cgJdYgCpVpO7C2yeroG8wrQ4ZMnTT0VoRLq2IJhwQ
Message-ID: <CACw3F50WiPm-N4Bwh7=L5P6s1trpK75wZFTLKMYAEAJPbjwtHQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linmiaohe@huawei.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, william.roche@oracle.com
Cc: jackmanb@google.com, hannes@cmpxchg.org, willy@infradead.org, 
	nao.horiguchi@gmail.com, lorenzo.stoakes@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 12DD0180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7yzjju6j5sbbx9aa9pyb881szeanu5i5
X-HE-Tag: 1769232789-616416
X-HE-Meta: U2FsdGVkX19rXEqPjemvRBrPLcgmqncqbu5lR3SAPz+vc920Htb5GhDtSQNiRYbR5T6emyunqo3RtQwQmbsvMCzGQm1cKWxcnhK5LJj2SxU3fGuHd4MAGrxkBunifgdgnsQC0rzENliyB4JDDW7klslRW99cRmmElaaugnHUEf3kKcveaRV9sp48UTr0PRoWUTgCsmVUQogh5aKLZbLxYlvncZn/UdV8vImeJArvhVA4WYz8VBzTwv3/avq2U8p1uy+gaGvGTam7KJFxWHA3F08ev2kM0P0VsFYtLE393az2r+RgxG3c6bNJvzkfGoyZmKzfr0ryR+i0vVxy7gQGXKuHRbg/2wGXpkV7SrIKJ5NMA9MuDZz50YT4HN5w9RtBgV+gznsejOxMp9UvWrGjpYvkrT+3uA9ietssLFwkLiGpq8NFtvqMffHGf4e0g/1mwGi3J7e38vnDeZYGA8q5Mw2FGQ4iMEkJdA3uU/J//RdtHKLOXROAdcw4ikZUr3Lx3q45hTh7wC3LROAIJ4xU99QYpa/4HU1zA0iG9O6DjxEA6uRmmwWWSJc1+9pQM/IypyCvzdNAnVZh3B+nvdRN/jXw5c88nxsrhs5zR/uZu5sSwJrw9EBd6yi+9QEPqGxZZwlkiJQUQBGPrp9nNSwAgDKM55EjSUCcptpY3Su7/+Ise4JHd06kVtV6nDHmQ9WT9xLRrJiLKWr4MOmRZy7tGVOdYSfOVpbiQBIAyJf63LuPiBg1LMMfx6mA0koqmItyZd86pH+h1DO/Hdb7aYuN1/UopvNKKftHrJxcLqwfJBZBqD8V7WBB50dXLfqRabnWoIK3qMnnb0XPthfQuW7ZPQyMZtj1Q0LAo6L+B6WIanL938OX3ucRG3iGqmrQmYe7CaHvfZPmn9knFTH7rBzPm+g6xudaFg5r+Tkx773mQz6XK+zMTBvuTLNcFRJg+77C1pgAiyj6HsDOrJYKAkA
 fsStPOdC
 eAvnyrBwSRIk6myo0ziZ+/QwHyQ6qe2IRPLd2TsWHt4aKRXEMiR2SHV3Ps1qRQjK9L9qjRxkD8rYOQllNPK5ICsgQn9nESfNbc8JrssniCyxqMjCxCwcDO7n9jzaLXVSaPrKIeyo8yhG++ip0XZUB5QiUSer9xDxefZYZkPtDgXMAxsZnb6o9DKx1P5q9Us9EJTWkK1IPEXN5HMOvS7UgiXVdGISYAtMDFg0hWCy2Jyh16RJ5yp+HyCd+MDU4h+eCXbuBMhdnnU+UMcBjgykf+XkN/ZvN4wZwczw+yLNg0DGN8NI3eKq7G5ntxlZZ1pagzVWKgXUCxf2EhFH+v3QUuml6X3tqifwQylMWvFzNXXZv3YkGfueDNc6ff0amk1gn6VfZea2FawsSf5z0PFymZf9gB1svM+DQIgrQXlY8lkLYVPJiYD3wNL3WLGbd6sPDeP/5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the late reply, Harry, Zi, Miaohe, and David. I was occupied
by some other duty in the past two weeks.

On Thu, Jan 15, 2026 at 12:43=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/12/26 01:49, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> > becomes non-HugeTLB, and it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
>
>
> Do we really have to have all that complexity in free_frozen_pages().
>
> Can't we hook into __update_and_free_hugetlb_folio() and just free the
> chunks there?

I don't know but I imagine to get chunks you will need the ability to
split a in-use (not free_huge_folio()-ed) hugetlb folio like splitting
a THP folio? Won't that be more complicated and very specific to
hugetlb? This solution is implemented in free_frozen_pages() to avoid
heavylifing splitting.

Also, doing in __update_and_free_hugetlb_folio() definitely won't help
with [1]: to handle a previously split-failed and now to be freed
PG_has_hwpoisoned THP. This solution works.

[1] https://lore.kernel.org/linux-mm/CACw3F529=3DPC-pwXOX0gbNrnS7HTwXq93oVT=
=3DV74J4FHLqcZ-ug@mail.gmail.com/T/#m202f91883b9b70c0346c3076db5b341d02d3f3=
48

>
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio(). However, there is always a time
> > window between dissolve_free_hugetlb_folio() frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
>
> I wonder whether marking the pageblock as isolated before freeing it
> could work?

Maybe... but where can the pageblock be isolated? Is there an existing
candidate, or inventing a scribble pad to stash it?

And then who and when should un-isolate the pageblock, if we don't
want to leak it?

>
> In that case, nobody will be able to allocate the page before we
> un-isolate it.
>
> Just a thought: but when you are dealing with a possible race, you can
> avoid that race by prohibiting the intermediate allocation from
> happening in the first place.
>
>
> Also, this is a lot of complexity. Was this issue already hit in the
> past or is it purely theoretical?

Theoretical for now. But when I work on [2] with William and Harry,
the issue can be reproduced fairly easily [3].

[2] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@goog=
le.com/T/#m87c95ddf0b9397b409a9f8fac4e772ecc9abf209
[3] https://lore.kernel.org/linux-mm/20250919155832.1084091-1-william.roche=
@oracle.com


>
> --
> Cheers
>
> David

