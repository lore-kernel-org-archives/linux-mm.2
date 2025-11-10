Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48587CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21A48E001C; Mon, 10 Nov 2025 06:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D20D8E0002; Mon, 10 Nov 2025 06:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0C38E001C; Mon, 10 Nov 2025 06:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7405D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:37:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21A375D493
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:43 +0000 (UTC)
X-FDA: 84094497606.23.1484BB2
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4175118000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDr6WkNb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762774661; a=rsa-sha256;
	cv=none;
	b=FpUlUOa1PuP9s6/+ugxZU2zxs59Wv3xBmY/wYzfsubIwZRV/jl+FsQbe14zRVGiSpt5F2K
	Qs4DIyS7ypB791HunyTzXyivY27DVYGfzoT3vhFj75gr1drsjqY3XMplvn6nLvqh1o1CCR
	f+m6YaqBITtskhuov0z/C7erT0JcGXI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDr6WkNb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLlD7ajwlaj6jb6Z6UcGg3eD8sukiXTCecz3SZYTV1c=;
	b=XgFxNk2SRkNXpMyRtBC+Xf5O8aHZkpz2nluAKk84jOQkCwNx21o6NowpGKONTGDV1RsTVu
	um6sCw1OKSzpL+UYMfkUF7Rw6ElCb9N/9/7qRrva7r1JiYaYVKszpL7hmnXGtZdwbDPccz
	2O05GTLZP0zPc+KCla/aMLwujq+Q7CM=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-343514c7854so2630618a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762774660; x=1763379460; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLlD7ajwlaj6jb6Z6UcGg3eD8sukiXTCecz3SZYTV1c=;
        b=ZDr6WkNb5LLfde/4z9PudVv2R1+rlbhTd0rLGp27aBWteQwlMn8HG90k3EYLdg/ust
         Lo5TOKNQRLVgZV3IsZGp1c3FpwhHY7iN+hB98Gknouvn7+qQPbmxT7Tx37775kQU+een
         Q9S4gdd6psMBVZBSa3poslAEoU52ZP+urVS8w3kkf3ThrD6QWQ2XVpj2ghoTwb2STacY
         DA3QIezFFkeBI9/8Ev5tIdyu2cp3TEiudL53yvxEZvvkpcff3aaSUGzzTdc35P4f2uf3
         6quQ/EncfJbaZr3np4jqwRV0m2UtNUHFKcfvWSLCYeH0p17QPGkQcwjP56Vz9DXjXT3r
         v8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762774660; x=1763379460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lLlD7ajwlaj6jb6Z6UcGg3eD8sukiXTCecz3SZYTV1c=;
        b=fdUH/qmd8s6CaueLGgWj2b3qs5l+N9gf8xSzcV+ddndqVUmUxB1zv8LAn0ufG0aamx
         +5myoS1We9RkGqZo/c+rPtF61g1rsXq/zl3XWonGaFBWSleDfR3j/tI9BhnFwnlIOoDB
         4Goh/oCn9cM/drKb3BYESfqaW1Thk5PpPBXbZljjiVm1MZhMvyzPiOzWewdwJu+dm6N9
         FbbfdRDmUtfEeLudbetNf2+0o+KN3749lDL6WEzMNDyDNtQdPTWuhlUrrP5GaabBaMaM
         ibBv9WWooVYLC+uF6/o3EEUIPjO2Ya8JTgu6dk7CD2AqQ8msf5niQOve4XQ6flKRW2mf
         4VHA==
X-Forwarded-Encrypted: i=1; AJvYcCUuTc4076HPuu02M3mOjMyE4fDnmWqKLzQ5g43ZpObH5JG59D0wBOuQfMvs23yOXkxLKd/4M5x2HQ==@kvack.org
X-Gm-Message-State: AOJu0YxhdX4T4Q7Zqut741LYAvK9vi/Y1J7BdUszDxbod/TtryaebeTJ
	LNrLSLppcUgcGcizOOtK+8A2mcAlGC53r5JLPOwuLkcQwiWSQxcKiLsmgyODZzeobmexcFri1CJ
	ZzCsYdu6HS3slJTbmKJQ/U7jw3KY4Cks=
X-Gm-Gg: ASbGncsAvVwW99f+kmxMmN9vono0Gw/jSFdFqoUq43KPeLeneGV+PRR5z59RlLcS5vQ
	/LD9uK3JJ1xyH74rkzq/BIKMzjrNFbHi7iQT+OiFIYG1TfGNoAmnP89PoaYH5xPT2ma/RK8I4cT
	bbvqDBFhuX4dAi7k6U0gXKOrQ1WuInH2F1CHadsF2+nqE4mnj3NM5Kjqca88hxbmtah9p6PlZKu
	liIK2dauLle6h73s6eicIvuHpIQkNbol3c0vyks7z7F4TSrU2TywCzhGBaHRPDrRinZcw==
X-Google-Smtp-Source: AGHT+IHTguIiHquwsDWY+79OedOt9HQKo0mp/t8Ev2XHHW+BWzgfIoUuwYbZRUwbIMYycRiIsrTWcS+UGzxVQ2WRxLk=
X-Received: by 2002:a17:90b:4f4c:b0:343:a298:90ac with SMTP id
 98e67ed59e1d1-343a29893d3mr3232942a91.0.1762774660033; Mon, 10 Nov 2025
 03:37:40 -0800 (PST)
MIME-Version: 1.0
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
 <875xbiodl2.fsf@DESKTOP-5N7EMDA> <CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
 <877bvymaau.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <877bvymaau.fsf@DESKTOP-5N7EMDA>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 10 Nov 2025 19:37:01 +0800
X-Gm-Features: AWmQ_bkjqdnK8Cy3B0Xx0uCR5RCBhqT3UBp_P6dSxB7W8VE0ScC_scO1hHX9q-4
Message-ID: <CAMgjq7BsnGFDCVGRQoa+evBdOposnAKM3yKpf5gGykefUvq-mg@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4175118000A
X-Rspamd-Server: rspam07
X-Stat-Signature: jkpesg7cpmiepqx7rtfiy1tt38gyqbx1
X-Rspam-User: 
X-HE-Tag: 1762774661-395178
X-HE-Meta: U2FsdGVkX1+3ns65HGPNUuK/8dDkR7deolKHx1pRI6A10r835kTCB3FIvipP9/hIRNKByOOJ/OrC6RZ/3iz/z0xEq2h8DHYyiLmPKtZuikhC6ULPYtyaUXmO6qW5GtDcdgET9fNvO/nasXy9RAdkOh+7xzM5A7eHJSByUPV3ueCCBNSQuv6aWyC2WqH0K/iCTS232hGsTCjCyh1jilJqv6uMQBdJIGylTQHsHG58ZMzDdeZRRkgjQiYgE/nIEh49apKBO3xN1bfSOPK0VZeQIuaP/CbOgv6cQKSALRa4/V9niv7SRlVWXQHO3OjYw+hzs7EaRrOPCELLfpTZUFNKH+3SA26we2VfpdSwIPoubnYf5DpuF7eGQ8BBqSb3YadEJDHAwvX2Y0P6NguhEcQGjB2ty7RODUVxEnXVU4Lw/SgrcicZ4+YPGsNFv0pxluv1UobSfTTqcqH8QdoP0yqRF+QabAzk28vB86VKa9boP2Ovep2AeE5y17ng+kxOPWTCxzFE/M0V1Ogxc6zltuP60hEFZ82bl/HKN/xZZiD6I+eNUb6TSCXcbkqK4B1w/eRG1lOITdgJJ88XDQ/nQzJzYOZrwq99FrecjL2OhUcOZ4YPI1sZVP6yAkvVg2IPKNw9LqjBSjQBDK7qdFhVwAJaPbHaSR/nAwz0hsRimYu/ZAQaEn5Zgpq05cF/AYxP97d0ks6aXNe6/z2J3Yw9ByoRABETGDsuZOps/f1cMB42tyIhVkz9w0y2RN19qH5pASdlwm+Mw6B+EY/XfR34SIo3/RhWzs03U9pH2YiRFoo4ArK89SozL+0leXa+DzquUEzuEFruTDgjzVudRrXH89C+SPi9Ia/P++Wfpe4CoKSNm+wHbubsZq1wgFX5H6E06PLlvGU69yUVc75B+Df8F4QF0vh8v5+CQBZlZejLpUAUrf5+OuyCfScJm0pTrFG91LM59CLDf0B8tzgBoJ8ddBR
 Pi7az5WX
 I9ObuNRLNZNYoqZRxSw8PLqBeM4alicOKm7ImGxRWIwjoFmOKtiYLxvjt9EJITAqWXsJE8HhxONq+3gJ4eN+yF38WhWQMYBvrcjUJopTJP4UMh+QjvGmcn8Bom8rNg+05gYHcYrghVPCFds2cWV5VnlWbjdyHhWKfF9qTdzS75NCDEOW9DaA25+OZxpKuYYVJB0gYyXG09WOTQR4pdCePYexaWQPyp4JTYDzWwLOS5RFNW1IYLzI9OBYUe98W9wbuVEjZi4CmB4HaNNB3v6YYbRZPD6G5U2Zo+b8SBgGl6Lee+Syop6MCUPDmRULb9ZNuhMFwtSBbEMrX6ANJ1PbKDs3joXFhiv8nmLKoaaOc2fY+s/lNK9OtjxAk+t3RjSibipEPHveJ92fo2FkxLDpEouewNrHOgXUbG7AS+2iq78Ud97LZi8Y3qt+aNjASGd/7X48MomG9j0fhq+djSAtICyS6vCO9eLzhsqnEjX5xWE0PC3EwXaWFaHNghwiqKh4b0WQreuAkx/L4opI4/81c2tZXDGf2faqvLqF5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 6:50=E2=80=AFPM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:
>
> Kairui Song <ryncsn@gmail.com> writes:
>
> > On Mon, Nov 10, 2025 at 9:56=E2=80=AFAM Huang, Ying
> > <ying.huang@linux.alibaba.com> wrote:
> >>
> >> Hi, Kairui,
> >>
> >> Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> write=
s:
> >>
> >> > From: Kairui Song <kasong@tencent.com>
> >> >
> >> > This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
> >> >
> >> > While reviewing recent leaf entry changes, I noticed that commit
> >> > 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> >> > correct. It's true that most all callers of __read_swap_cache_async =
are
> >> > already holding a swap entry reference, so the repeated swap device
> >> > pinning isn't needed on the same swap device, but it is possible tha=
t
> >> > VMA readahead (swap_vma_readahead()) may encounter swap entries from=
 a
> >> > different swap device when there are multiple swap devices, and call
> >> > __read_swap_cache_async without holding a reference to that swap dev=
ice.
> >> >
> >> > So it is possible to cause a UAF if swapoff of device A raced with
> >> > swapin on device B, and VMA readahead tries to read swap entries fro=
m
> >> > device A. It's not easy to trigger but in theory possible to cause r=
eal
> >> > issues. And besides, that commit made swap more vulnerable to issues
> >> > like corrupted page tables.
> >> >
> >> > Just revert it. __read_swap_cache_async isn't that sensitive to
> >> > performance after all, as it's mostly used for SSD/HDD swap devices =
with
> >> > readahead. SYNCHRONOUS_IO devices may fallback onto it for swap coun=
t >
> >> > 1 entries, but very soon we will have a new helper and routine for
> >> > such devices, so they will never touch this helper or have redundant
> >> > swap device reference overhead.
> >>
> >> Is it better to add get_swap_device() in swap_vma_readahead()?  Whenev=
er
> >> we get a swap entry, the first thing we need to do is call
> >> get_swap_device() to check the validity of the swap entry and prevent
> >> the backing swap device from going under us.  This helps us to avoid
> >> checking the validity of the swap entry in every swap function.  Does
> >> this sound reasonable?
> >
> > Hi Ying, thanks for the suggestion!
> >
> > Yes, that's also a feasible approach.
> >
> > What I was thinking is that, currently except the readahead path, all
> > swapin entry goes through the get_swap_device() helper, that helper
> > also helps to mitigate swap entry corruption that may causes OOB or
> > NULL deref. Although I think it's really not that helpful at all to
> > mitigate page table corruption from the kernel side, but seems not a
> > really bad idea to have.
> >
> > And the code is simpler this way, and seems more suitable for a stable
> > & mainline fix. If we want  to add get_swap_device() in
> > swap_vma_readahead(), we need to do that for every entry that doesn't
> > match the target entry's swap device. The reference overhead is
> > trivial compared to readhead and bio layer, and only non
> > SYNCHRONOUS_IO devices use this helper (madvise is a special case, we
> > may optimize that later). ZRAM may fallback to the readahead path but
> > this fallback will be eliminated very soon in swap table p2.
>
> We have 2 choices in general.
>
> 1. Add get/put_swap_device() in every swap function.
>
> 2. Add get/put_swap_device() in every caller of the swap functions.
>
> Personally, I prefer 2.  It works better in situations like calling
> multiple swap functions.  It can reduce duplicated references.  It helps
> improve code reasoning and readability.

Totally agree, that's exactly what the recently added kerneldoc is
suggesting, caller of the swap function will need to use refcount or
lock to protect the swap device.

I'm not suggesting to add get/put in every function, just thinking
that maybe reverting it can have some nice side effects.

But anyway, this fix should also be good:

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3f85a1c4cfd9..4cca4865627f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -747,6 +747,7 @@ static struct folio
*swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,

        blk_start_plug(&plug);
        for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
+               struct swap_info_struct *si =3D NULL;
                leaf_entry_t entry;

                if (!pte++) {
@@ -761,8 +762,12 @@ static struct folio
*swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
                        continue;
                pte_unmap(pte);
                pte =3D NULL;
+               if (swp_type(entry) !=3D swp_type(targ_entry))
+                       si =3D get_swap_device(entry);
                folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, il=
x,
                                                &page_allocated, false);
+               if (si)
+                       put_swap_device(si);
                if (!folio)
                        continue;
                if (page_allocated) {

I'll post a patch if it looks ok.

