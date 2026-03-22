Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFA6FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC24F6B00B4; Sun, 22 Mar 2026 12:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D996A6B00B5; Sun, 22 Mar 2026 12:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF686B00B6; Sun, 22 Mar 2026 12:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7CFB6B00B4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:22:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55D5D8C53D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:22:51 +0000 (UTC)
X-FDA: 84574217742.30.6EE3EA7
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2857A100003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:22:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkdoFP81;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774196569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/fgnHv7cmiSWJyVHldjkhI+zLeriXyoZRc5XctuGN8=;
	b=1sEoQ8KdJDoL4/3Fj69SFiM+tWW6RgSfcZPpAM9xc+dCjYHn3yjdxGt6dE7AYssvzXctTc
	0cUEFGJ8ndJTsowKCHaRcnnVDbvmvufALLizic50tHaoCBpjOJkRUurczXzzfXfjq79G/Z
	HnkhspAqNd8n9xJ4YVY3mqx1+X11egU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774196569; a=rsa-sha256;
	cv=pass;
	b=lG2p24eJFe7VFAlD4XC0hMSTug0uwxBwgBGUJqWgkufyuD2AxPWo2dp7pGMYJJ4ViEEvWI
	DPf2U/Du/LAwl/d5mHm+kmQvbKCJUkeYw590+Xw4+upJIeK5cfoHEWK0+q/W86bV1znxXb
	Q0W9fJwnTFAiCiOXBDlGT03kAtWpO3U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkdoFP81;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6697c7ffa98so976222a12.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774196568; cv=none;
        d=google.com; s=arc-20240605;
        b=NgTeJavYv8k3T/s3Wk9U8y7hs7epJpwIfGj9S5ogX49DRZ1dExITTeBy3EQ+1FOtV7
         2bVZBuNgyIJ6KQPrMoEjjsmODAn9HJFVVb2nV3kdMRkcOtqEGHJgqhxkghNhk8yk8gT3
         xWPphZEjLETK0+3lgbHzfZuKCJTjGKa95Ip1lk3eakY3zo/bRTNVGZiDwBI1dhkRdL5c
         wgaNKrZEcSyJq0w6AivC0UNtYgr6Y5PH8nhejR4mglVJstfIzMofLDknv9UicyODN4lc
         5MKUjeRuQcDzsE43j56q/Rd89IXR6TyB3PEGEpHSvJQRLsaZCoTiFJslY9OjvxA2tzC7
         FkzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I/fgnHv7cmiSWJyVHldjkhI+zLeriXyoZRc5XctuGN8=;
        fh=PDkWHDPYrUH4Rv3G6SlipcAJYCmVeJ5HojcdeLfJRmE=;
        b=cFbSPnBFmNOnLTcfBcmpAnonjXpvoR6PUje6EoEBSy7ywdtXV32eccfglfWxryNx4P
         1g0WyRnUP2cwDsByL3xpUiEQXAyvai86h3VMFokHq5FMqUCCyLYL8kqUj9Dg08xl4b2S
         t3LArjLdlzmTZ/jL6lckefdFNgalMtN3lCU+SP73DhqDgZWSEqqqdoxBd5GN27tLkO0h
         dI2426fv8/7sN93QvaZwez6om5EUZPU/0PA71/FhYbxWGK6s1KJPEngFt68USWJvQk7x
         0fg2Iyf5ao0i/+eySFUNUa9qh0gIQ38lzCnxjknBRltGWfSunP8/WE3ERvbcZ7UuWEdH
         l/sQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774196568; x=1774801368; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/fgnHv7cmiSWJyVHldjkhI+zLeriXyoZRc5XctuGN8=;
        b=KkdoFP810cPxuvUx9GqZnYehWyNcjqJCLwfyZnJqCjMyXaX78ldA6X9iHbzHkIOrSh
         5uQarf9dgg2/yZyidpnXR+430uhrCMDcmEa5161XJmbAosMs9ml75o6VSC8DfWjL8R+4
         ndQnyRhklXVBx2myJrgHHoI3faL2ax2HoMX34mN5iNN2Nfyu2Pqwtf0Dbo4G+V0ZR64L
         CikiVfm0kPFhMh8UQRqbd+GeXbL+96LfG2Z5kHIqqZIEVUIgQ2MZhe8l3w0lKitIPop2
         L4MfgMr+0p+FZHWjVgxdX7QpdpH6tJHygD2R9/UJSXvtQDppbCWuO4E/mG2Bf843+mpo
         yIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774196568; x=1774801368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I/fgnHv7cmiSWJyVHldjkhI+zLeriXyoZRc5XctuGN8=;
        b=W2EODpSUonSqXLecwkcvk9+9IdlWIGwzYsNWUZc50xNTgGiLTEY6mH1TN+8SHEC3Hv
         bLHgwPpUSyv++cCnVy7AI8hOghFW++RiR3W/LIefBRiXOvtEMpA1iFK2gmed83PPBrE4
         4zoFn9BGNZZ6bPoMgTYanft5sdILTTRVyelfnO2hur2fqz8lp0QrYxIKamqJUtMg40y7
         Z6w8s13FzEvO5VFMHJWt46THzcDxMPeprSdkQi6UhvZTKC0aiuLMgdXwjVgvGTCYRd0+
         d43W0DY5KgZhLbBvHQCTEqMP5d03rXjEV/msQuTvJJVMGUynXA7HWvR3fRZlaqzd8S8R
         ocPg==
X-Gm-Message-State: AOJu0YxVWt0CYvXpihxq/+SnrCcc1sILWOXSLPdsTBfmG6vd9V+kDTxx
	pwpdksrfXJtUojPTkqZciQsd5pg5F95KlPsscoOPh28FS7GLN47AwSbt6M03juS12kddy7IUK2I
	d3a7MRu+MdcNXP0bhG13WM0WzusOkmN8=
X-Gm-Gg: ATEYQzyZ/ij0ffW4E2klYXlHvNhtUDhYBHkPJ9UM+ZPXxV6YBXjhHTSU2wMw2pifMQg
	r0QbxyiBXzTIcIeyjkug4qDXfwbM5b8B+C5mjAqwuRBiYrBMPqkXqUZK7XVt+DzU6t0nYkW74Lg
	M9PPp70ZC94zzo7qDG/JNjzPCueoxlGSLCmnMEBpsAXSf3OGwkEnvQlW8gjH1tWKRgFwL9yX+H1
	stWs/hDosenZu3I6EsdpTSJz98wfUZqgeoDJqYXeFGtIL/r/fp9qXJRP48GaW5Xkjeolt4OoC2j
	/X4D3OvOz6DmLtcLAwCIdRr6W6Rc64xgdtoTMkFZ
X-Received: by 2002:a17:907:1604:b0:b98:1b18:7840 with SMTP id
 a640c23a62f3a-b982f0bae96mr678618066b.11.1774196567567; Sun, 22 Mar 2026
 09:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com> <CAJHvVcg4=rU+mqcc3eOPg+Lsz08dGf=LMzBgx3bk6JDg3Xy6gQ@mail.gmail.com>
In-Reply-To: <CAJHvVcg4=rU+mqcc3eOPg+Lsz08dGf=LMzBgx3bk6JDg3Xy6gQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 23 Mar 2026 00:22:10 +0800
X-Gm-Features: AQROBzDVcrs1K5JkpZJCQG6sVobtfz0KcErcx4j4U4fhcnmq19fxIuJCJadHAqs
Message-ID: <CAMgjq7Bqma=AWBzbi5VJCrRqgiC88ukYGaD8WviqWcXJXyaMqg@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback handling
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2857A100003
X-Stat-Signature: o5gsshmy68gcuwxkrhux7oo9f7jg31k4
X-Rspam-User: 
X-HE-Tag: 1774196568-381277
X-HE-Meta: U2FsdGVkX18s4GJTPbIrCTDuyqb9UoCHYL+Q9gqGlIOXXIkEhS2AIL/y8OMzFKCvZF/uiQjgmtQ8lZbplc6oGPpB0FCY0EpjktE4vkMxfUDRlIWbaj5C7af+DzfgueGFpvDA5M6bhrd1zHcWO3jwOVFSCZLdajccTLJkdk8y10D/ermMI267N1gD/WhAFQ5jYbgTmj2h3AVBYeB3V0BKQYgKBlacaNKAUN16GiRYRT3RCY6lS8eHZFg2BG4MVbzNnv8AMdyupVgXuOAJGAdY5gUjK/4DwSalHbJ8ETkKJMNr4zMnC24r23Wm3ZLK0Ix08NGlluu3YwzuvINSxgQENVGA3bG4g0HmLe4gE17wMU2FhALSOmLBz7ey1MNZ6UHP8JMbCvgIzr3V96Zqa28B3cIu1gP1NzN1mZkxRdJpIJY6BYWLMH0D0euvY+AHYUCXYB45UHXWTf8GU35ZguaCI6JHONALd13P5QOKcD23cNknLPBV/ZrItSHYjWYum0K4UdVzyTWqMyd1h3iMktIsf1avIVHY/FqQsXRnBh4EBAtcUh1PJp2uO+gvi3fETvrDoJq2faiti0mjLBDnqKY0HSG4BRFKdd06gaFClwkOqB3SBOb8A8jFHHNASq3tg0Efvd5cSpJfCqkTWioKW1BD5FvEHx8xpuBmbhBWnAvfDzOxu9oa0HIjSTzPGxJ3bMWhKPRpIIhwOqj8d0AFcdu9Uzk1jqD7vlN2xFrmBRhS1Sc9cmqmeQXMoih3qX/qiGMBG+UtK+XX7MrZ+aTHo6TVNS0NpQy8Q4wbum9/LndsIcznRh+jopFEE7DidWnth4OC6+2mgIU0MFKN5jg0Te8P5TgaSDwi/OvYKk9jAlSHwrqwnl7kxw4FwIS6x812zMQe7mHoJ09v+IuvfzRBjnTrMiv4QPW1e1mj0vtiHg7tItoqRtzTJWpYPEM7Eyqy/Mkk/bZLeHRi87rqDj96sxH
 L94nkL2w
 A7PenBTXUrsh541Zkc3+acAVxqBNgoA0eIpPPBAFl2wHsLavRVhAm5SfDArKti+cx+uj2n4RjgwlbVJaIM3lIuyjQ9TNaoFnfZWGA1cECiQbhIseGvgP5n6VwAK9n1KJnFBAkUh6KVW+muDQ08BGOe0qXJJVnNmRDrcIM/kmQ0VIgepcErJA+8k7mDoYgnyj8uoZf6hHBgibz9xJZ9EImNeo3AIeFesg8X72JgCjbvmKcVuQBai3po7YvIhx+Voub8KSQNzwHCQkJ7z2Gfuy9G6BYAdsKJiBJe3uuA/jXrZX+FSi1TT+yUiQFgyahxf7oDkCSjpp6xM69A9vFbLIHoOnCOziuAdx0EhszX1uXOgXNtcx8xnHEmahM907+8o8GanOtNWaTgkWMxaiejhudWCKMnkhIj4MH2/FizkW7b542mWwXSU6nzvHf+dH8+foLL+JpkQk1K+ivvQjmvJfQYsJVzDVIsEX4I8hhJXIyxd+WgTzdjoIkApC3rqsYb24+XC7wRmlV3RFwq9s5H4/BXD+Cd4PAlXk2m+UrLEOcjtBGgATx33Fegwm+RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 5:24=E2=80=AFAM Axel Rasmussen <axelrasmussen@googl=
e.com> wrote:
>
> On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current handling of dirty writeback folios is not working well for
> > file page heavy workloads: Dirty folios are protected and move to next
> > gen upon isolation of getting throttled or reactivated upon pageout
> > (shrink_folio_list).
> >
> > This might help to reduce the LRU lock contention slightly, but as a
> > result, the ping-pong effect of folios between head and tail of last tw=
o
> > gens is serious as the shrinker will run into protected dirty writeback
> > folios more frequently compared to activation. The dirty flush wakeup
> > condition is also much more passive compared to active/inactive LRU.
> > Active / inactve LRU wakes the flusher if one batch of folios passed to
> > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > instead has to check this after the whole reclaim loop is done, and the=
n
> > count the isolation protection number compared to the total reclaim
> > number.
> >
> > And we previously saw OOM problems with it, too, which were fixed but
> > still not perfect [1].
> >
> > So instead, just drop the special handling for dirty writeback, just
> > re-activate it like active / inactive LRU. And also move the dirty flus=
h
> > wake up check right after shrink_folio_list. This should improve both
> > throttling and performance.
> >
> > Test with YCSB workloadb showed a major performance improvement:
> >
> > Before this series:
> > Throughput(ops/sec): 61642.78008938203
> > AverageLatency(us):  507.11127774145166
> > pgpgin 158190589
> > pgpgout 5880616
> > workingset_refault 7262988
> >
> > After this commit:
> > Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> > AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> > pgpgin 101871227                        (-35.6%, lower is better)
> > pgpgout 5770028
> > workingset_refault 3418186              (-52.9%, lower is better)
> >
> > The refault rate is 50% lower, and throughput is 30% higher, which is a
> > huge gain. We also observed significant performance gain for other
> > real-world workloads.
> >
> > We were concerned that the dirty flush could cause more wear for SSD:
> > that should not be the problem here, since the wakeup condition is when
> > the dirty folios have been pushed to the tail of LRU, which indicates
> > that memory pressure is so high that writeback is blocking the workload
> > already.
>
> This looks reasonable to me overall. I unfortunately don't have a fast
> way of reproducing the results under production workloads. At least
> under basic functional testing, this seems to work as advertised.
>
> Besides one small clean-up:
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
>
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxia=
ngzeng.cas@gmail.com/ [1]
> > ---
> >  mm/vmscan.c | 44 +++++++++++++-------------------------------
> >  1 file changed, 13 insertions(+), 31 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index b26959d90850..e11d0f1a8b68 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4577,7 +4577,6 @@ static bool sort_folio(struct lruvec *lruvec, str=
uct folio *folio, struct scan_c
> >                        int tier_idx)
> >  {
> >         bool success;
> > -       bool dirty, writeback;
> >         int gen =3D folio_lru_gen(folio);
> >         int type =3D folio_is_file_lru(folio);
> >         int zone =3D folio_zonenum(folio);
> > @@ -4627,21 +4626,6 @@ static bool sort_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct scan_c
> >                 return true;
> >         }
> >
> > -       dirty =3D folio_test_dirty(folio);
> > -       writeback =3D folio_test_writeback(folio);
> > -       if (type =3D=3D LRU_GEN_FILE && dirty) {
> > -               sc->nr.file_taken +=3D delta;
> > -               if (!writeback)
> > -                       sc->nr.unqueued_dirty +=3D delta;
>
> A grep says that after this commit, nobody is left *reading* from
> `unqueued_dirty`, so can we remove that field and the couple of
> remaining places that modify it?
>
> In `struct scan_control` I mean, we do still use this field in `struct
> reclaim_stat`.
>

Thanks for the review! Yeah, I cleaned one of the unused variables in
the next patch, but there is still one :)

