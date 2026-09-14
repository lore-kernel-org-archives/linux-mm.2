Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A3EC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E076B0092; Mon, 14 Sep 2026 12:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7E06B0093; Mon, 14 Sep 2026 12:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299076B0095; Mon, 14 Sep 2026 12:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F214C6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:49:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884961C0BA9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:49:54 +0000 (UTC)
X-FDA: 85212954708.28.3D58FC1
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id 831754000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:49:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rs1tIG+Z;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789404592;
	b=pB/9MFofryaqjLjERanZpq/ZPmxnM9XpOY5cklTOxTGtpTE1ir1LWSLf7/KqVqs2AJfUYV
	hqznJAWwXXb84QQqqneSm/RN1NMnJsE17hH7jTt8AG1xIwFLwF0ps6DhIUsTFuNWanHTHq
	C9mQYYfL4Nqk9jPROkNxcoEpz28ZQr4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rs1tIG+Z;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789404592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
	b=RdydCYHN+ehlLhnIz+8i0nCO/b7qop6r6mmfVOsibv+vSjGHDeR0U9T/ZA7UGY7F6BD4sb
	GQyKTaZz2NYi3kLhaeMJBJIebCmjWOtwU8SufVxmKnmXib3K6rUVMGm+iWyaErDtEkBzqP
	7QNKG6CWvBwgAG3RUkgZ/U+qWI/SsP0=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so1224732f8f.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789404591; cv=none;
        d=google.com; s=arc-20260327;
        b=QLL3ccHfxAjIK95iK3bW/z2GFzTXP6Hkh9iRlY5t1J06m9rBQfeNmEwRu61uQXQ+vq
         FVf4Bfd9BiVMndLwNyEC6/TpYWMq+MEVE4SVK4jjC1gg76lVbWz9PrJkTGwaVLrXVfRz
         iSo/3DCdovb9AxDTbpMrJhQyxlcb+DKqYp9uu0uDmhwef68oTlsx2ozoh0eSicRbM22j
         AGpoBmdmyebu0gyt/6cuTFNywIJDeqCD6+AI//1knaPj+NwrU/nih05Oc+mH50oFQoB4
         zNqEH2p9k1niXO30fkWCVwq6Va1y4HYC0V+UhbiLV16F7ppFeCg0hhzS5By3dPvcvseP
         6/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        fh=9+X5cZfK4OvRH6G3xCOuvHYsfsi2T0WB0xpPeJrsC7E=;
        b=M3s5TN4CFjxrUOHG2tXXQ7RlICoJCJrdO27HkdbMh2o8WovL60YECC1ML3aq5/yM47
         AeVrwBEWIzalhUenDPmvzh1cQY3cSXazesGY+0Ys031eytVwGibhcrpyjkLVKsBUGcf3
         GAyggu0Z6ZLdrsyJZQUcL2RFnaDdcBOQTolzznmpNm14eMDUwaN7NT+na1tWacPDIssT
         wkO/NxD3xgyo5TEJOlUev/MqpD/FOLS0GbTVohqmtxoyBuIB/1Nr/2ZFXo/HNHZjmMBf
         YUUCMyJKvmNynmsT+7nV1Z7MEckVb7f6z0IDw7KQmCdMxQfspNEtGSeonsagh4Hkiw7z
         igrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789404591; x=1790009391; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        b=rs1tIG+ZIPj6f8kXV9qjzXx1GVgsSdLhqWz35WexySElWt+p7ld5Q3R08bbpbGRxKH
         4ZyXf9hOgSOPlDJpMpQZhROAuWn3OGuCVTbCBDSuE6VV9emoRDsQ7yoGu5oIHMYpdweJ
         vgU2imlBbELCDn6Zf03TTAT0wiDOYE7WhjHjdpCoN/tchRaCSwbyvT/0Q0xIbvl94fVk
         FtWWJ+Ze0ccGhj+ezrgfdvdfbHFu6fB8xaU2SWK8A+JdHU/JG9uyNPIWrsBA4RGGyf+0
         yiUWa9Ddb+xIMv+eZTOolgig1ym46VhHaFoK5UdOpUvFLxv9+8HYVrhD5I4nbQfotZcZ
         XeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789404591; x=1790009391;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G183+Yxm6/Twsin5qYVqwM95g4Sy/Qck0fET7NLxE+k=;
        b=sE+QmbwcXBO5BcqoxxtqhctOdRwKucLKLIUcuVTV/LPXew9KOxl7JDRIqCGQj8bFAn
         L2kYQTKe8VrkBs2vbd92hltFW5r2wpkf9tPzr7wOijATHnpMFmSg4p1zDlHL6rpe85Yv
         4UfkTka/b/3UAzF+Hlk0zqLPyGsBHaBLrlYpetR3f9/CmMET+mRN1GpJ1YDkNkgF2sSG
         LPX3c3Ghe3pm7CyAZ+YQEVqnmFqoV+LasPsqFrmK8dP84l+ugZU1slKqMRSVg41lfXth
         fCgtY6doAHz0J/YovOC41X2XNd4IAIEmqBeDq/iFzm24Rd26PtTRlj3J+s40FmjQF3e8
         3dYg==
X-Forwarded-Encrypted: i=1; AKwUvBwESLacat/odOjJbhztohKSowZVt/8HSK2nNajyfERDmBZdFtGieSy1JsvOR8HYYArdi9GSTsgssg==@kvack.org
X-Gm-Message-State: AFuF++lg4ndw17Hp7ahcf9OHZwyBKnIGlvsjif1o2rLxHVCpGwmgVjFD
	TWCNrw8df0NUde9e8dEkJvD42maWEieXZQqfGJv5eWa89ZaerAGBR4c9xsnJq3Wg+Wo3gMHOSbs
	BVsm+nypSgJz/fjRHnOBFYd/XEAuRh6w=
X-Gm-Gg: AYBFou23VXl/6m6BVRe6SHQfeAiZqk0ZcPVazPfWdnwcnNrVAkkP4oA5+2TqIw3IQj6
	6Ygs8dVfbh6djujJ5pEznISPqEPK4eN2xy6xDvpFNmRQvV6PkYT8sQG3cVV3Ey1BpyJAB9PqZfp
	1fqS+DvFDjaPruxiRYg9i+cYdyoqlbTM/I8LBUIEE+LGuc9DK0+oXFf8IdQvDNvi8jY19FXdx4Q
	Svtf4IMWH6Pmf/iBekpfWE8tSCmSZQ+knLpYXwnGNeXNhuLgP8svQ7VKz9OCzPgvR+6tubwO76r
	c0B7k3uW9K2dPISPZwqTlv7Qt7wQ54QOXXuKqlNN4hTDE+rHJzSbfMj/iruX3L4urIdOvWjNZQT
	vA1Cid7rFunO2
X-Received: by 2002:a05:6000:27c8:b0:487:4ba:97f0 with SMTP id
 ffacd0b85a97d-48704ba998fmr1121463f8f.23.1789404590535; Mon, 14 Sep 2026
 09:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
 <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
 <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
 <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com> <CAMgjq7D40KGRjwpFMH4x4fhJ18OQyZwPtovhc8Hm3Y7+__d4Lw@mail.gmail.com>
In-Reply-To: <CAMgjq7D40KGRjwpFMH4x4fhJ18OQyZwPtovhc8Hm3Y7+__d4Lw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 14 Sep 2026 09:49:38 -0700
X-Gm-Features: AcwNN1WO51K14Fm2T1tur-3vx3APS3D8nhOV3AEZCzJzOrHll5YjpThxvhcytDE
Message-ID: <CAKEwX=NvHj-Py22-QuR10gynfRk0g5y8g6Cs2+L-hbuAyfmXFw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 831754000B
X-Rspam-User: 
X-Stat-Signature: ai4jdo9hj19g6up4z53qsawar8dffxci
X-HE-Tag: 1789404592-778667
X-HE-Meta: U2FsdGVkX1+IbZBY+VDgQ/dspRfq9aFgvENEgXmLPyYABnzg5VHNMj725YTIbFTpDd5pP8n3D25cno4oDHv5wrmuXXOtfic03allIhb3Ja7m0ujVEdqrXDDmVXSu3vNZIr8NmXHm0voPYrmxh+Fxfp20MJc/GhWRnHjE8hvjiSZccyQq+WC7dPdG9+lV5mjB8TdtZDzc+k/hOMTHpZS02tR3tmrx5qUDvpZrf8kzKSIfucpkL4AQO/JiAFsNGGUOnSvkibN4ML1Y+GNjPQ/dtO2+CDaktu3kZMOkZdq3SfBVUHN3/oMjkqwOSpt59GYbeZnYOQpC3uMnWJzrAj7ZdEA51oBn8evd70wfQcqsgbmSXAcwCR/BhpgimgdobS7hTFeRT2IYIR1gqtXoOGz6+eIqg8TtPslV6gao0sOi6FQo3T4LKkxWvEXbSvfG4aBF6audXCXTYiT5lA/ViUn3GPCMaT1PTPcnTA6WmYFTyBdI1jGFGUysOmFmfSt3cjjBar+gtTTieTw/Iv5XLsHMOUuZdo5kaEf3BirFJH6crDtlrXMsjB1Tj3DSKwQHadGEjoRMVDZyXnEDiF/00Ww59sA6eorjdxuIpGPlojutPIWjmS50mlKwGL25WNGKItuVrGxVbuky5PFHc3gqc43HmCz3oQVxptf4ZaKN3l5JTFXLIlxwy2U3Y1+J1ajwhApP31YEef+hcaEPbaRF+UD/rAeCIyXSuw9VWnGQcNBfGrNf9n26TYCAd7FTqiFxJBfV56GaRfpCZ5XXFIT0Icp2+EvUcX7fJQDiJsW82LsyCGzOswS9UPA43Alr079TKmT2gtx2LJZMERAzIKRkechNLR/aw16dx3+r7KxIFjH5MXnGsj8hbAM4MdBtvomT04xVG7xl3rAVpjgejCmWmGIkIoPCL4zp+GEdEKY2hMb5ZwACFuNR/Sgqn9xqa4A0YeLQiBHQYyK12pgDn+AXbrg
 8kChICun
 cQGzLXQeSC1MziRaS/Ij7639V/JO/DA/snS0tthaC5ahbJUO5RURLlvNjDPrT9TL2eebY+9z9n/SyGVvnFVJYcrUnCTPHY8SKvb1klKEzHToceiBge4/bmP55lFbLwrx73Sj63NlPmCmnhn2m/Atm+hgBJ6KMIoH+MH+FHipFcJgq+6El6haB20LucG+c5pu6SRiZXhYyMqxRPYZqZRJWh60mmr3zi3kU8yycmsuExDPkizxySM0sCePPcbwDayHjreZW01fAPa8G71G89IjLpmE6lXnOMlyX9xgZfz6RQQGlbG81FGOs94+DhttfvQTC7No+YadydpS9rL1YlVQ2ykL8xCwcyiV8h7aD7CYU2gFrayq6zXpHBpFrKkg1M7jZPzr/PZiVuvRzwylLhHcn1xU9WLwMPjevaX40hTlhjCW50KiTqrgBFG8yd5J5u6yHXxQyAZxtVpRtPdwzbEaSvFRxVOq+X4BHcL6XK0RvjZ9D/+jkKBGC/+ZF0bHZ0cPfPff83Crc4lLOqE1nBj8z4NLB92p0sPKOJWxyyDlqS8Of+Xc9HVymKpERTbojuAWeRYONMKoX6Wpz6l55p6EGQyDTBsTOCGOWIX1+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 1:48=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Sep 12, 2026 at 3:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Fri, Sep 11, 2026 at 11:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > > Would something like this fix it for you? ZRAM users will not get
> > > > vswap indirection overhead at all, because it would bypass vswap :)
> > > > Down the line we can revisit this decision - for e.g, if there is a
> > > > use case for vswap-on-top-of-swapfile. There might be other interfa=
ce
> > > > that makes more sense.
> > >
> > > Hmm, this interface looks confusing though. you mean tangles vswap
> > > with zswap through the cgroup's zswap limit? I originally expected
> > > this to be a problem solved by tiering, skipping certain tiers seems
> > > much more intuitive. Maybe Youngjun have some idea here?
> >
> > It wouldn't be confusing if this is something users don't have to
> > think about at all :) My point is that we don't have a use case where
> > we need userspace input on vswap-enablement on a per-cgroup basis yet,
>
> Ha, you really can't assume that for everyone :), we even have
> workloads working at different compression levels, and the tiering
> series shows different cgroups working on different devices, there has
> been pathes enabling per-cgroup swap device a decade ago.

I still don't think you're getting my points.

Compression levels have nothing to do with vswap selection. It has to
do with *zswap* (i.e compressed swapping) selection (or the algorithm
being selected). Vswap is just the transparent mechanism underneath.

Once you HAVE selected zswap, then the question of "do you want vswap
or not" is easier to answer:

1. Overhead: rather minimal with vswap (at least based on the testing
I have done so far).

2. Usability: vswap buys you the decoupling of swap space from
physical swapfile.

I struggle to see why you would not enable vswap if you enable zswap.
And more accurately, a scenario where you want vswap in some cgroups
with zswap, but not others.

Taking a step back from all of this - we're arguing about the
participation of vswap/xswap in an interface that has not even been
merged yet. None of us can say for sure how it will look, or if it
will be merged in the first place. I think that making sure vswap can
participate in that interface is already more than reasonable. Once
that interface is in, AND the usecase that necessitates per-cgroup
vswap selection presents itself, then we can expose vswap later.

>
> > > > Potentially, but we have many users at Meta. There's a huge diversi=
ty
> > > > of machine types, workingset size, access patterns (both frequency =
and
> > > > file:anon split), compressibility, etc.
> > >
> > > You can just set the number as 8PB? :)
> >
> > Sure, but with the vmalloc-array approach, there is more metadata
> > overhead even if we have not allocated the backing page of the
> > clusters yet. This will be annoying on the smaller size machines
> > (O(dozen of GB)) to also pay the overhead of 8PB-swap space metadata
> > reservation.
>
> Not al all? With VM_SPARSE, you literally have zero overhead, unless
> you really use these slots.
>
> And even if you really use these slots, the overhead in both CPU and
> memory is lower than Xarray, if I did the math right. I just ran a
> quick test with Baoquan's Xswap, forcing it to start with 8PB on boot;
> it was smooth as batter on a 1GB box and still worked fine after heavy
> anon memory pressure.
>
> See below (8PB xswap device with almost no metadata overhead, the only
> overhead comes from zswap so I reduced the tree number but that can be
> easily merged into clusters as we discussed before):
>
> ### Before XSWAP
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         405         756           1         544     =
   1058
> Swap:              0           0           0
>
> ### Create a XSWAP device, I hardcoded the max size in code to 8PB,
> ### and use fewer ZSWAP trees:
> # echo 0 > /sys/kernel/mm/xswap/create
> [  140.289280] xswap: adding extendable swap type 0 (prio -1, init 733
> clusters =3D 375295 pages, max 2199023255552 pages)
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         407         755           1         545     =
   1057
> Swap:           1465           0        1465
>
> ### Lift the ceiling to 8PB:
> # echo 4294967296 > /sys/kernel/debug/xswap/type0_cluster_limit
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         403         756           1         547     =
   1060
> Swap:     8589934591           0  8589934591
>
> ### Run memhog:
> # time memhog 12G
> ...
> ________________________________________________________
> Executed in    4.36 secs    fish           external
>    usr time    0.46 secs    0.00 millis    0.46 secs
>    sys time    3.77 secs    3.80 millis    3.76 secs
>
> ### After memhog:
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1464         336        1136           0         222     =
   1127
> Swap:     8589934591          31  8589934560
>
> The only different from vswap now is that you just hides everything :)
> (writeback is not hard to add)

Ah I see hmmm. I probably messed up my napkin math.

Regardless, I think we have strayed far from my original ask. It's a
good idea, but with significantly less exposure to correctness and
performance testing. Baoquan himself said it:

"Throughput is within ~2-3% of plain swap+zswap on a 64G/64-thread
swapout, so it is dominated by zswap compression, not the cluster table."

I've even tried to show that that if we are to want it, replacing the
xarray with vmalloc is simple, conceptually.

Why are we throwing away all of the testing, validation, design work?

Let's recap the arguments so far:

1. We began with: it's more performant/less overhead. Which
intuitively makes sense, but the numbers have not played out yet. And
as I have said, we still keep the old code in tact. Optimizations can
be done on top after the main use cases have been landed - it in fact
gives us a testing grounds for optimizations.

2. Now we have moved on to "it's simpler". My apologies, but I have to
push back on this, because the comparison so far is so unfair it's
farcical.

With xswap, we're rolling a custom-written extensible array. It
requires a 1000+LoC patch series to implement.

With vswap, we're using a data structure that work out-of-the-box
(xarray), with well-understood API and concurrency model. Yes, it
involves more null checks and interactions with RCU, but with vmalloc
we're adding a workqueue to support only tail-shrink, and have to
invoke vmalloc API, which includes nasty surprises such as sleepable
allocations, which can cause deadlocks in lock section.

If we're comparing LoC, the first 2 patches of vswap, which enables
writeback-less swap virtualization, is "+440 / -37" and "+456 / -29",
respectively (including places where I have to set things up for
writeback, detailed documentation of the encodings, etc.).

I don't think vmalloc is significantly simpler. It *looks* simpler,
because the interface looks like plain array access, but unlike the
xarray we're in charge of maintaining the entire data structure
itself, not just using it, so we have to take into account the data
structure's implementation in the complexity equations.

3. Userspace API - there's more to argue here, but I will note that
vswap can be runtime-enabled and sized too. I just don't think there's
a good use case for it yet (but we're discussing this in other
threads).

>
> > https://lore.kernel.org/all/CAKEwX=3DNYoMH8pTKeCvA=3DXHFmmNVMeDz3mxbhp5=
q6-PxSTJ5wOg@mail.gmail.com/
>
> Right I saw that, but 64 bit of private id will make shadows really
> awkward, not for SWAP but for file folios and file mappings, swap
> table is actully fine since memcg_table is standaone, and we can
> workaround the hieratical refault distance issue in other ways (e.g.
> record the reclaim level instead of memcgid direct). I think 24 bit is
> good for now? As I've never see anyone ran into issues
> with even 16 bits in production.

I think you misunderstood me. I'm not proposing raising the private id
- I'm proposing we raise the size of the refcnt field. That's the
thing that gets saturated.

Technically I think you can reproduce it with baseline - if my napkin
math is correct, if a cgroup has more than 8TB worth of swap entries
(4k size), then the refcnt will be saturated. You can already create
an 8TB swapfile today, IIUC (even without vswap).

Anyway that can be fixed as the independently from swap
virtualization. One thing at a time.

