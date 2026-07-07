Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5790CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DE46B00A4; Tue,  7 Jul 2026 11:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF686B00A5; Tue,  7 Jul 2026 11:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED7D6B00A6; Tue,  7 Jul 2026 11:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE3A06B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FF7240474
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:27:19 +0000 (UTC)
X-FDA: 84962359398.24.1781E9C
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 72DA44000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:27:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhv5+cvf;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783438037;
	b=IsGB7gdoCst9qNvsVrZO9aV9pUA5McfX8GOLeJZc+IDTuyl94Fj5aNEuQB80w/pvXtA1ac
	FzQKMCENdbMwsGNBwkPhghrZBdopl5qTaCqpeqPhYpu6bNBKLoTTh/A18A3NrWzrP4MHad
	PPT6UM6YIHKVrqSrNCErbAtcYNG1Xh0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhv5+cvf;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZz4HKSndCmRHtzsB0jXbdIsm1D2owill/PuZjtw1JI=;
	b=wpqzbqp/Nwc0ekP/Zk//rIflP8vDB8oJn2nou4zE3JaU6T3mmLxKR/NJb/hdXCP7bwRklA
	KNT2UK/h8ZltbLYosxJQfElQ8xMB7BfOErV9wyuSsoyW6qDM4UcwVRHcSLzmEbuUTlgnDP
	+EXJlYaRuhf7CXbDQqnC/b10wuhZNfU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c12a1a3cdb9so438576966b.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 08:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783438036; cv=none;
        d=google.com; s=arc-20260327;
        b=pGqjVFHC07NGotVjWHYdranVTR2gEVl4aoDzGd8lwj9FPQFWzRDRr6fGPJ5/CWTjEh
         ZoHqbdKOapTyBECd1yjitrnVHnmYnMa/7H5Hi8GzuCY9gSlp7MM2OUhHOA9K8vuTi2mM
         0mfjm9favPYVGT1LguAc4GSKlTmSiYXuTJtu8LEzSOMxYdN3Cc11MAc34kVWiOpxCIzn
         hLVC1EX1onPzaVlW0/hmehxu8x2eLhatNLO225PJiIv6rc1O1OqGdjo9NT89DLSw2arq
         NIfMdMpYBt34kAmX5XdhLTl9Hs6+lsP9mrdcrIP+I7qsfoh/xpizU8hdL8ObTgUKxljG
         FZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZz4HKSndCmRHtzsB0jXbdIsm1D2owill/PuZjtw1JI=;
        fh=rKYAjFMluoVqpGZiBl7ybqzwQzEYoNITHFjrAofJkDE=;
        b=gNQXLum7JMZOoZh/nmUrtCWR6D7chNi+bS+laLkq79NjNkKhvaHBSlAVFlT4gwE18J
         PH+TpVqEOhaVXsyRFlFlvx5nCA+j7Ww0jolFjuhoTFjteVB8aMS2qYEEPa/05HoU0l7X
         KeHceejVAzmDxumGc7mMgqdOKHsjIfSnU6izVvvAbpmI8XXl5DJKQRBAyx5nfSQmxxsA
         hEXUPz3WtUXj50uKuP72leazO73IGkE+/9XfeNYPjabLnCL1DwvatT3D6DRWYOgyD8eJ
         8Q243pfPXILP2AFDoB1LmyK7PdI2654lDWdYFyEVUhTw3PiU0V58GGpk3E0m4nLdu1n7
         g9ag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783438036; x=1784042836; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GZz4HKSndCmRHtzsB0jXbdIsm1D2owill/PuZjtw1JI=;
        b=lhv5+cvfvKtXzEkPNNMTAmrjvFAx6Cb+nHgDJg76avSmx40jXNfMzNrd+QfN1/Tgca
         H1cniNaklCy56r7o00b3PR5W5t3xqnHBL55N6ngAKQ6jK5gr+amf1pinXxJo7WeayIHN
         3AtEpNESydjY5xWGSSn6vYidJhiqo0zgUXCCqtPwqY9yz17MfrW670gy6NJSEDZ+L1tW
         PFPrxuCHEAOgnIhOOSEVm8RxeDA5bFN7N4iK0Jj4+QGixzXfNN8o+Pk9aiFbrfKX9wuN
         zd/IEdrNXtQnZSidLfWhJ//JL3opopqxvpoupFWUxUNtPeBcYWQOHFY+/lrNSsmSz+sc
         bMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783438036; x=1784042836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GZz4HKSndCmRHtzsB0jXbdIsm1D2owill/PuZjtw1JI=;
        b=hpElLgeqqzkIOuzPIVAxoizSImuWsQXTKoEVjnfjSO05qnBsueLRSkSWAxd8itrfVT
         GmsdglV283zjxsSM0qlU4+wQ+GvB5Ln5SlfpeyvnurNPGqS4MmDoZw3TH4T7KxTAG967
         Cqyh6ndiLoslOXVGuqR1/MkKzTEseuoeaDwKAqFf8UOA/7LGQp5gK67xMAMou8XRW8zC
         EIbcgbuK/etwznbRalVKYHngMYoWallGbBQZ8aoIRko0P2XFJXtmEr3vro9xwm7WK2qN
         49nwoXu0zjXexNGibmFubyll4dGffw+8TQPY5lT9llXXkkZGAkRqeWuYviwO8fvwF0ob
         CCUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/bjdB+cDPoexA2grDF4f8xYYGKxJU1XBm0rMdtIVwVjxkbNdRcvHSFyWWkA0Zm2Uw30tGBJNxYOg==@kvack.org
X-Gm-Message-State: AOJu0Ywo0LxJQrafoLUCu9ZLA6Z3LX1al+65kiLaLL+7NkYPCMXlEYrW
	vXDhSK+ywCjjP5xAFb3pHcCEiMlr3xXTCqCmXOGSOVyAT3b0gxl1BK5bKSwUn3R2PrqMhLU0KW7
	9JIovKj7LJCyzZ0Ozy/9ruyp1sdXpJiI=
X-Gm-Gg: AfdE7ckpBbRPN6dNzkXf6EJ/SZILAawoqCyH5FZn8hLluFHzdT/BnM8UkdAoRvn2UFe
	/An0/k7ygfsDGFgCRjmlC3qCZKzm3/znT8Ix9QE0n86l6v0m2Gly0UxGVls2cdbs+zLenXf/erE
	WNjGCVOP8ipseBkOAHkfDgvwW/2alzBFwuBKdWdBGC5pa1Tsa0V/UCs0wOnKoAJofz2Yd1imkDK
	/zUDptIdo6LB8wnJLojZTyNBIxAd/EswmXRfUKvB3ozOcsQUPWMtzXLDTFqiNccQV1CnLMH3LAl
	Or/jiQgYyb29BLM/E1GvuUaWoT9znQ==
X-Received: by 2002:a17:907:a709:b0:c12:b226:27 with SMTP id
 a640c23a62f3a-c15a676c737mr320267066b.11.1783438035696; Tue, 07 Jul 2026
 08:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260701235955.36126-1-baohua@kernel.org> <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org> <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
In-Reply-To: <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 7 Jul 2026 23:26:38 +0800
X-Gm-Features: AVVi8Ce1sZV_FRHc2RBl4wTNhMs0DBoD49jai_XzcTGB1zWlrQwEmwJfmSnzrDg
Message-ID: <CAMgjq7AT7ddzbTcg1QCOOP2-gDmtt=8nZbDb8pKSfFCG7Y2U+Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, baoquan.he@linux.dev, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, chrisl@kernel.org, 
	jp.kobryn@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72DA44000D
X-Stat-Signature: o8bun5n885cn3swgdzd1j4deoj96t8jz
X-HE-Tag: 1783438037-822343
X-HE-Meta: U2FsdGVkX186kBcZBAR/TNGPKP01jYeYGZ60HIkmPC1AhZ2y0tqrzk+lX7ffFUbtbDhcxZDSGzPgHHBqTfJSlXEnjxisCPnQD33kqXPJCUUmkSNiPoSXQkGRjBL8mlG+L9aT3vwHkj/Ki6zbWE9vUIsuBaji8xcW9u69UP66TYy12t0q7tGgZWjB1FIftFfWYVU0dc0RNNeaOQXidqs86QxaxMg/G0yhueeZEwgT/G4xIYZXBCit5iqwVjAe1xbuVCy6auFNMozna0K4TEs/dAW/BWTTwY1hN/PmFZUsadOTwNRjIhPSn66xkgbuS1aMz699y+1g6wxcpLgK0hu9RaUTk9SVtUCiyYYlwDtnERFbL1+NM9gX4z+XwXSqar25BlgJBQIKQiKBIkGWE826pWPtM6QNyTPQ/x0BIiPc5U3DJBpM5MUnQT6aOY+qQmWOOrqCg+HyI5kMbRn4MrwTi4QkEnJKVcCU0Q+oR43pndvWkx2YKMXNDcISIg+aUqnqnxkYubpgoEHQjtNCkE4nil94XrPTyIhC8yKZpyyAutkjt5oFW6D66h82VM7r2QpgpZD3RFKNwc/x6gZLB+syiPBaOVEuoVtRgM9fc525yq8TmLpekphtmV3xr0IdORLVHC0aDOk3jiMozMzPk1nbzaooZsBhhuUiY7O7NroofvQ+XSMC8eTJLUYnZ+eJLffMgDFCWjsuFDg5QJxB/n5VBWXDWidxwFuYdkfcqLXEyErVY0bHrf1BhqZbGOLd3rPd5WUJpyV9D2K6rcDP//njxCoBbiDlSZhq3IVm/TmuMZ2+twSLQzQ8MDf6wQn6OJnqC6i+nRbZ/hHdpSJE8khrLScQoPD1cPPPK6ziAhTS1z2AJN5DKe+yKsKYipFrqCIDKPM5yFeTKE1/8WwCp+VWiEEMQ126b7lVWPt0GADwyyldVo1xtEITyk6CXoraGicMcNykhoBIfWTMtzydcHw
 /MnPr6Q/
 xsJ8zxpSgJswG9pem3JSJnYXO1/8dq0bZEnabOCr1LxDFDO5Khos3ibquEJpzSgykZAhiOJy3u0bfUCDezWkpemYTvxmhX4fXBP2YPJyJwuxcLfd7f4wIxUdVjAMj0D4FZTVWSS2GiyNFctb5dWf/cX0ROBMb+L0nZkaLdefQt2A2hD5jnBbZ3aMj9uPqsuscuS/A/lFNycyZy3XBeYRb9Q+YGAfjWoGOtEV1S0TI/RXA7pzzGiPfqN6k7cKMl7MkIxHwdzBN0yf8wDg5rT8Z/dpzhbbvcs4E50mqH2JgkHlJm4TmV893zBBFBACVWucZU/pa+CdTqflxntORkFTah84KdWEfPOedt+/i9w7s0mft9X9/Wj6PnJK2N23QJddf1PNjOpLtPP+o7Kjp++WdnlrWBCyy5AZJmRNkqsNsovrkACC04XXQHiWd7a/ZxgLbT23bnqujlc97Rsecn167ZFzcZQXDQG8jq8JM4FX1mQHEFRdVLOeJF3Kbsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 4:54=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Thu, Jul 2, 2026 at 4:05=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > > There is a case where `folio_ref_count(folio) =3D=3D 3` and
> > > `!folio_test_swapcache(folio)`. In that case, both
> > > `folio_ref_count(folio) > 3` and
> > > `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> > > false, causing an unnecessary local LRU drain.
> > >
> > > During an Ubuntu boot, I observed over 5,000 redundant local LRU
> > > drains. For a kernel build with a minimal configuration, I observed
> > > more than 20,000 redundant drains.
> > >
> > > Fix this by checking against: `1 + in_swapcache + in_lrucache`
> > > instead of hardcoding `folio_ref_count(folio) > 3`.
> > >
> > > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Reviewed-by: Kairui Song <kasong@tencent.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > The other folks should probably re-review this patch that changed quite=
 a bit :)
> >
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Thanks!
>
> Hi Baoquan, Shakeel, and Kairui,
>
> Would you like to re-review the patches so I can re-collect your
> tags? If not, are you okay with me removing your tags when I
> send v4?

Sure, no problem.

The only complain from me, and a trivial one is that `in_lru_cache =3D
!folio_test_lru(folio)` looks a bit odd. !folio_test_lru only means
the folio is not on the lru. Could it be off the lru due to isolation or
other reason? In this context it just indicates that we should try
to flush lru cache and attempt release the ref. It's trivial, just hope
people won't be confused by this. The code is correct and sound
though, so:

Reviewed-by: Kairui Song <kasong@tencent.com>

