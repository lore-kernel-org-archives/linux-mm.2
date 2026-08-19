Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDB7C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA76B6B009B; Wed, 19 Aug 2026 05:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58D46B009D; Wed, 19 Aug 2026 05:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E946B009E; Wed, 19 Aug 2026 05:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5FC6B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:50:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D182A1402AB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:50:05 +0000 (UTC)
X-FDA: 85117547970.18.46C12FD
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 003ED160003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:50:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTso5g9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
	b=HP7A9u5UQkFJHfrPy51jxdg58lX1AbR9s/s+P5HXUcQPS0UtObzPd7n1af6mt13A+LO0DA
	5kJVdQVaCZCgF0m4PVaXB03RtPw5ApESQlE7a/U9z3b0xYdTVyZnmHmaDNewpPHPIpXlwo
	VizyMc1IPkWk+HLwVpNRJJ0wSGF4VAw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTso5g9o;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787133004;
	b=fl1RawjjzFBfUBShs4tEMoLOId5J0lZdUyvgObgMuhPlZOJwWqhyrtRx7wNQE0HR+VUKDe
	jtUgfsGr1KIldYnEmfh7PdftRNxMmDeJ1AvScajg9uYqeYV2ZNUkYKs0rHzZmWmsRBZt1Y
	OfmRVKnNjkKDpiAOah/SkgYLznl+WWU=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15c42a45adso290605666b.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787133002; cv=none;
        d=google.com; s=arc-20260327;
        b=s9NEjFHogQhOg9lgwf89r3jxwq2GWZdPTxsdWlv3ltWOnVvmCD4skExIlV1y9yIjBz
         vScq9byl9G4GWhKyxqTEIR4zS9keLFe+U6zOHRArXwcShRF38o+am64Ya9+wytscowcR
         mRxcgdzdNITLWw1blkt3EKZAbf5Qo3ZodtSzEUs2TzSvKhnmf1q8TMEdCT4p7FMIkrT7
         wgZoxgUL8cosD0KAKQ6JbBmt4IXbJk+cIKcw1DEgzWTmx+ot54NX/D2az4+MsO8m4fXW
         d1yWI/WNPXxtNryqfzzzTvQd2cM8knlbpVim0JaNL8wrxMliZEbqmmID5msjfVOQdzb7
         mv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        fh=Tegm9b/wb9oeluhlaL11P0PiP4fwGOgkoLy+Bqu40rk=;
        b=sy6WISKv4t5KF+a3vZjD6vQnRWueJIWOo3mPIMz27EYN2eLVjj3n8grzUwpUgV2uao
         guoc65QkcAWvZFhrXJlgK4mh3MUa5Ot70X80pQSMlydV4eC/a+qX4VvohXH8M/rITiE5
         Zj+Ane6Zw3vzDa7sBzlTOTFQj4MZbJzkraFCHRwVg7K8ASL3rHAB7PkL1Zw/iRdvVBlU
         /COQWcRdF+DZjYN+FGtSEqEIf3NiiZZE9VK8zMeVV4g/tHqVucrB4PkorA3VY5N4l45H
         yOI7zi0AIIDlx6X4jiHYsMndwiwQ8BkraBgtB9FzTgnDQ0TLWBi2ThDuM6lr9GcIc9w3
         frbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787133002; x=1787737802; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        b=DTso5g9oeGZjwbdko9FZHvuxsuFacqpL+2Yv24jYmlP5VgFAblJZWpn3CsfyUC541F
         NeOI+QQfTkNrX4JEqnDv5M1iVFMLnDsy9AQj+CYaz3fr1B9ELhl82j5IkokNn2uNNQoZ
         d7l/nm+M+jbZd1e/e9ZyntpIdL6Sim/xkyFWGyu88xK3oj6o5Gbgd/DXW8wUbRBcvnK3
         3vEodA9t8OEHSe4Smh1yMfJ5oD+BDahQw/Lk7MWD4hmS1PEBUFshRD79EaE6x/eEylgm
         /CXPbYJ5dXL331atBLbXCkTDqWRoq7GbFejaZiaHVluWIqBseYJCXNMQl/Jipk8mw9FP
         6yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133002; x=1787737802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JYFAHLPwlY6ScFzK3+Wm2EDzKXa2eWFtHEeFKNFKOzM=;
        b=OZ7l69Yn3+KKIuBNE7LdznAOTYnAWoGbL2kzU9RfPFYS8xiDMxDgDJpfZjAEYmSybJ
         vTvReT61lqxjXAq4LepQH406e/FNOjpeq13Il9poMVCsySS2SeQySHHLMf9QguO2Hl03
         elbIrWPgwY72jbULENvuXQRTEfQHUzwCtBa8cP5VyTHaiIMAYvDptR09rnGZ3uUiJ7Xz
         eKrUrtF/V6Lix8tC71T8+nB8enyENTuJ3YPIDXB5v/k95/XRuQc2oCSv+q2B9uaRMmhp
         lz8YJbDN24Led4Dadp2M4Ls39vDdJec8mCujVxknIEomifBNVb3tNO9qG8vuz3RfgMwx
         glZg==
X-Gm-Message-State: AOJu0YyuBBdd4wzlgrW0ty+nb56s/jjoDKK5kvwdmNLk10OQ97LusXCz
	FBLbvHtPijDkqtRlRIRCLIGpyuzX2OJBCNT61ybgrNagfrMnuw4Nr4kaYgF0E/gPGN04YxM+VMj
	cVKz6baf8h9jAG8OwZ52mncfpO/78sEg=
X-Gm-Gg: AR+sD11gYJJnMyP8PTzXGa4IZHwm54UDqm+4J3vifWqSCgzyLr1R9PszQyNbqL+PAd0
	rZBQvW39SvIf0+Ygk1yPI9xoB9wyJLY5jhDXSwuVA96zsne/YsRumbVy6HVCJauJPKOF1Zd/9+B
	/saxqW2UhYj79kgWu1szJWj2zZ4VHOa5u/phyFAIPChOowE4coHig24jxUn4E1q4hdCcSu+MY3m
	wr4GcFoXzds/ncIJEu2yaonOKoFiZsMGjpMNtXKkVo8C/Fb8O628MIX9zRvdptfpfCPlREV8zof
	8VLFFVLko19eIGqNKyQdvsnscSN/uPZGwctoTqkIRydG39T/aI8I2ngPrhlAD9PhA6g6nu2I3ir
	11GqucOKd0GNugA==
X-Received: by 2002:a17:907:7b8f:b0:c12:8a:7d7b with SMTP id
 a640c23a62f3a-c237de42f5cmr223047966b.1.1787133002424; Wed, 19 Aug 2026
 02:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com> <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
 <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
In-Reply-To: <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Aug 2026 17:49:25 +0800
X-Gm-Features: AcwNN1Xs-TTQ0U_BUnPy2CfQrpwZu5AEUHFSzTyLXWH--Hmcn3YTArEldekCBFU
Message-ID: <CAMgjq7At=z9dAJxM2MZcb0UKmVCfd+DRi9EbC3h0wYaUP-0wzg@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 003ED160003
X-Stat-Signature: rq1k8iksyq71wodn35aby3uaza9yzac4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787133003-130109
X-HE-Meta: U2FsdGVkX198h6jnzWdadp2Zjlr227RVIRm515tv9b+HtGEmPPB0tIh01daxdSSBhXWytGB6BohX3mjYTpKPnE+En6s4A2hK4bgf0QSsqadK3kykzsdE2/1/EPM+1yh14oV9DIYaqUH9P+VNHFYjrCbhnXJB9lL2iC4x99XGSsCDcx5YV/WNhOWeI0RkVcAsJrmUsdIh4t/2DvHR1LDoT8pbccTNiVyIr00HYPWAPqX3T9298M9IzV91JSsP9+179WE/NqOjpPHzYHkN0PHug1J0ZsDDPIfxJw+2NSxxEV9i40RWL10B3i07YMiMa9gZ99Xc9hIBkZCzklKotPi99d891+C9DkQTzf9cwJdOOkC7MAI5DPh9/lh+EcDpm/fWzV2qe7BZZq+5nnd4GE3a4bg3uPu/be7/xs0u8PTbUrVBMaejePnUf63KSj0Uk0IQM7WC1PGplkfLj7WIO8geJ/gltT/XlsNBaYm+CCyMDh9KoTQ6Rf2t2Yg5Js/MWyJ5kcWIRb3hxdnz4FLKLFoGBNPz0tProbxtm/1lYVDpzU7w1j+6CxN0mAJlI0HflpcXD/zBQavljg0tfB57bCj8k3xsXzVaExYNhThhanFVFZ1/WB+rYAnqK/Wq1uMLJlTpmgbaNVfFwfjGrXqDbXoUMrL+4clUYRO8iNAeilegpi62ju4a22nrMmS0d06VyQ5Bz68H70XFLJxEsU67NZxF0g2CaRSMlWVsDy4wAa8Pg9ciMCyxrGwDTgYZKihtNg/Nf+3Zh7CWTiMsEDcSqH1o0xJV2LqymSL/tl2hNYfTxfziIAhcmzZA5m5tuTA3iP9+sed8/VRjp2zrw7RXDYgXmelvXh7N5wNur//8uYc88TmT9NGZZ8TIax3Q+QuZrGOwLfGokfREWcwY8GI3BW4T+sD4E1zpzDcW4AGE31fB84SOy5Vvbt+8EbIoxpdO8MRmckfwfVsfEW4eIPG8Ej0
 vaapXK+u
 XP3Tf+ge942BY0/BAC1trBk9vQzLuD0Gui9RNP4G5d/nMS18QD+eIOKhH3gzvBzDrKH6+yrYyCyx97Hsfsjrs04ZPtXjjKg8gDpwlGUlPjHKU5KN4czcww0luIPHX3espZOX8T+SP7aa5w9YksCbnss8J5/jLYlzurUddKlimqNNy/jOFmhqd18JuEwqurnMHUvFJTM4II2Eivq/wr+HQVrOQnUEBJxdkQ6VL6Ytn9c/HJtucQwRYxDSYQ/RvdutTHlYBeRDaVbK70JuOyZRMyrzBTHcZ2tts5ROAlr2Rbz/tzF5MncCqWnFaHpdXbjc73rcl5Y2RdLScFsXg1J2c2EJ6abofEw9wDkrNt5F8cxwzQq3Sgj1VKuKQ/5VWnheehT1vqjlIqQxbjZ2AwbZ/L/YVtttoH9Hxo1bH+2ZN1czkaP7+lA0L+y2/N9lcAeuwDaJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 5:46=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/19/26 5:37 PM, Kairui Song wrote:
> > On Wed, Aug 19, 2026 at 5:03=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Instead of doing bit ops on folio->flags.f, introduce helpers for
> >>> adjusting folio's refs and gen info, make the code easier to debug an=
d
> >>> understand.
> >>>
> >>> No functional change is intended: some combined atomic operations are
> >>> split into two, which only creates harmless transient states.
> >>>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>
> >> Thanks for the cleanups. One comment below.
> >>
> >
> > Thanks for the review!
> >
> >>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>> index 94f9c3ff5416..32d9354a754f 100644
> >>> --- a/include/linux/mmzone.h
> >>> +++ b/include/linux/mmzone.h
> >>> @@ -496,7 +496,9 @@ enum lruvec_flags {
> >>>    #ifndef __GENERATING_BOUNDS_H
> >>>
> >>>    #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << L=
RU_GEN_PGOFF)
> >>> +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
> >>
> >> There are still many places using MAX_NR_GENS to compare gen counters,
> >> so I'm concerned that introducing a new macro would make the use of th=
e
> >> max gen counter even more confusing.
> >
> > I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
> > users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
> > bit hard to follow for me since:
> >
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> > set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
> > set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> > set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
> > new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> > new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
> >
> > Things like this are everywhere and I found it really hard to follow
> > what is actually going on. And adding more operations to refs/gen
> > looks ugly and painful to do, and, it's impossible to add any sanity
> > check. With proper gen and refs helpers, we can ensure every time
> > gen/refs is modified, the value is valid (in debug builds).
>
> I agree LRU_GEN_MASK and LRU_REFS_MASK can be cleaned up further.
>
> >
> > Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to under=
stand.
> >
> > Oh and this LRU_GEN_MAX is only used for sanity check for now.
>
> But my point is that people may not know when to use LRU_GEN_MAX vs.
> MAX_NR_GENS, since they seem to have the same semantics.

Right, I think let me just drop LRU_GEN_MAX then, there is no real
user, it's just sanity check macro.

