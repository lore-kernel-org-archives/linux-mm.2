Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FADAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758566B0098; Thu, 10 Sep 2026 12:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7306A6B0099; Thu, 10 Sep 2026 12:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F1F6B009B; Thu, 10 Sep 2026 12:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 365AC6B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:23:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32E6F1A05D9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:23:07 +0000 (UTC)
X-FDA: 85198372014.02.1E66B50
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AAFDC000F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:23:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mLX0ERxl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mLX0ERxl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789057385;
	b=i3GNFJEDOBaHTV8hjb7ydNxbob0HpGTUoJ5ZW1L3VJte9drBYsDvlrtw85w+ypXKa0QAjt
	LVrVlKxXKtQL5IAeF01GpO1SUeR7QFHqkCarSY9nH/Xxq2KHHeM3+5s2vudCUoF/d959a5
	J3+28fHmDPUarT7labKqLz4IiME7GB8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789057385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
	b=qSqJ3oSFrqyi9WtliF2qq2JGDcOssUEXwp4wq9g8JVqJ6nAglFB+Pys7xX8k5Sb7xuKKzm
	Q7GLIEpHL2Us94trfAxiYmbLI0vl8BkX9h8RqEHq0Mkkqz1Vq4K3xM43KTQC2G4BcJLgMv
	Onevv4idBAL0/+YKTrk+uGujtgBxlwk=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-482e257a23aso4849852f8f.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789057383; cv=none;
        d=google.com; s=arc-20260327;
        b=O4dbl6MXB2bX60qTwTgcqLyhmWM/NiGMAHAUaqlOwkS/OdcZo5E9v7qqh+DOVMwXQD
         qYvhQv7XzYq1qp8rHeik+EkTwxLcqOhFMfglNpGor/hQrwB3XzD7nQyH/IP1EXDeIIZ6
         mL4TxRIIYwmCVA40x25pmaKI0gjz9RYCn5qnRKmobEEjzghULdY8tYOJ+jdbXS0u8Mmy
         Ewkkc/oKYZy3XST4Jg6qKN/ooEE+7ROqp+QTbmLURaP6z436dbBAiZv/OQ63S45D/NSl
         rgBXbw2m6wtkG4K7yZf9Zz3UmNdJ1dFn7szJtkEaKjQVssDGFcujgqnXE2uBgcB4PY+e
         OtfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        fh=lRq66axOD0hM5YUpeJ5lT/r3eSykL18dz9P3rVI9Wso=;
        b=EEBx6BLY2svoQ7u9IBfn7FvuFwzxsyrVlpjgLyEVIAPUeiF1oohsF4Hf2UpLEB/y7E
         ifGIkfe0TQfBvcJkmc6wGTgIC+iVPMDSgmGRGus4wfyPWyKUDwqfDzmeoDV7smOvMoeg
         kSu36x8gM2TFndLw67OTBntmJzEnddBJX7obtnxTN+icR5SoNl7g9urGsmoVfHEtmGKW
         muCpNDqM9SlBsFQW5Gmaj7k+EEm2OIct9c6cO9Hq+ztuO5FnjRffoE2m+dpb4yBgkJdA
         x7qz9CnpTvn8PThwIyQ0ZQOf0F1Sp+pwXNP2XzMPpdlSAJLb9GoKixsa9XVix2F5S1L0
         VmVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789057383; x=1789662183; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        b=mLX0ERxleIzzuRSPrRng8m4Hh2gKFimPuvWi5ZA8fsMUYKcj2FVcC06JeFudfwXxsv
         ahhmRBPSsfck60/rbT3w2uj0n8mO8jgaknGG2wG6Nrmpl6oKBR1zE1wh8Rzim8tK6BnF
         qKgtO/PRJtkEue0TP+0lJ6znfc5mgoqG18tXJK4D0KIp+rb6rqY84V7dklBPwNcrlBNu
         ki4xlTgLNJ+AqH8Ejbp1TQjROMFEJXOT2bUigL6Pul6OXDsxHTq4UfebvLDKRS7oZCJY
         NwSATDzCfc6zJSS+rWGoSDxbZxgn6IKJJjnXE0Jc0Z9ODHzdGP/T+8KUuJejvhy/y42w
         biJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789057383; x=1789662183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        b=JsRjUmbbxnfXJ05PzFsDSNXmG5aeG7UUqCxE2e1oKm2vpUhbg6xY1mxFBbvkZ5xTE9
         nBrRQU52pp3fyFZlPHkmMstQunTZUqNX3N26QPR8oAk80gOJYbTVkL7w2/UiuKxZrfGd
         3RIhXl0HC9t5rUYl7dTM/bJUWMC4bkmmkXwbA+kCSzEl+hNR6XEpNUvcann2PQ8kksw7
         S5JIMFtQdcp2rn03DxWB030GpwMxX2xcMlvXL/CiHj14QtuykKT42HQJ2lkWFhHEISG6
         D9eS4UaNi/1lJKrG7wA8oG7UsplFA9uQmx5L9uAAdpLupaACTFjaBqSbsBH5ip7OxbyY
         KhIA==
X-Forwarded-Encrypted: i=1; AKwUvBzE7dpzJKx61CUUTdTed2LuXS9Rz6H+HKasfzAsrCTA3mK25k09ab7FzUI3PjmC4AXW7DJi/C9bBQ==@kvack.org
X-Gm-Message-State: AFuF++kBM8G1tfT0Eo29mAtiPQJRpH76CefUWU/Q/GRdElXevfvFS1eH
	TpmlSGNVn8LrnwcGJgtPj0NqRNLtAbAW9IDrDeJ7rJmsokshR7y3FGyeGFNvuRjTDiZ3UliV+Qz
	uRxW7XyXcsTDF2qz3Iiup0xmxQWtNISA=
X-Gm-Gg: AYBFou1AVL+wwHCiBLB+YMZQs7uvK04QTfHREZT4W/gi8VneGa2PTgALNnkezVz2Bxy
	9j+HBo2GU519Sl4xjGEQ0iq966WQP+j9YVRdAV+3imuAhIXDsrusoiA5GsW226wi1s8mGhzvvu+
	Tg3TGE+MVjFjiT8OigwJIhWvV8E7J4Ief40zqLbtc2SkakjG4Zcs/DCeKxupgreHp0SaYG5znSr
	1WLs0hX8ZFCUrbHiUfPdj9/X7KzE3cMW/7j3KVhade4VyWjt+J/32p+UlF3yyGhaGhvwBWw8Fg3
	in4Eqz1Tqw92xq0K/TQVit2UF9O3QOwc6yKTOcm/U5/dK1L88XUbC5i4cMAJtJxal0KmTg+x2QU
	N7V54HMWmeMGb22eASkAPcQ==
X-Received: by 2002:a5d:6f0a:0:b0:485:95b7:fe8 with SMTP id
 ffacd0b85a97d-48595b7116emr40680885f8f.25.1789057383303; Thu, 10 Sep 2026
 09:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
In-Reply-To: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 10 Sep 2026 09:22:51 -0700
X-Gm-Features: AcwNN1UnDVpavQ1PWarBG8W2VruLfKxk4ncIecF52ch3SJz533v-zrDp7ETfpYo
Message-ID: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AAFDC000F
X-Stat-Signature: oorzbmbjtqr35xa5d3otiab6jugcp6zx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789057385-208931
X-HE-Meta: U2FsdGVkX19GlZ93iexkpdxjoKo9dUlBQBEH8LoxmVBgUUPKKRYNj3diY2L78kf5m1T/h2y2hoOIJVtppijnbFWojzsQ85mxe6kPF4C5HeSfrJsyegdV4UPdQt9edy2mv+GspwXmik7gg+3qm5hTi1LUYaxB3GO3GElZLso1skoo047WBxvkBGKEllyC7Mr/tzC6dALGCMRxYo8BIf6zeNIaa7F+Sei3sO9mxKausGjwfF1MKf3ykU5/deJDXLROS9Slu9CZ1EOAiMV2odKfRriJHXlDoYik3Kx4l1sv0r0lyjv+o2mUGjGwGin0gTXfiJ5hw9a/OVXeeWgEVCtqLpYKz0R6xrbSbY8kCEzCTqaME4ZPUHc19YNkPpVUmtE1HbuWRVOLxR+y53cPVytDEaCBUL6JBumKklJkj5jvC/plRL+TirpD0pPCb/GJ8x2BKlK87r5mBAhVHFVFBbg9RFRqOMVEoyPuxp/Bwy0PbAOGTvpkS1hOY4h39u7vCRibbh5S79rzgHRRospqKh612caKV4FQxYf1heXDrHMrPA+hIf8rOfz2ZR0lc1Sj/PJWP1CTT9KmBwg7w5GO8oUa9GYDYGf5U9tyzszOiW0RPnSihZiN3GXfSepqZZxqu/Eg2qn2Q2WRSEgg7fqHGQr4QezX49wLz71lInfQVdxSUYIl1Pm0IPWR/FmtDbacoyBvuXssBLprs1tE0ucleY5kUg9SP+WNILYqrAbnm25P6LhxfLhe6cKU3UfQTVwEWsSNelbPFhcDhb9C6FMJFBkjjLbt0Z2nTeZaa2DTsqmjNZ5pshJaQBivb1V+JdaH1JpJ0ni9wHnU7mblAgGTHTf1sHZfcjmNUmuGx4NOBsG3PcB/pAF5Yhy3Ziea4ycD3OH8RbVj2jaLhaq0bxtn8Mp7VE5wetuoV4hQOis86z6YbP7xFPYsHoR0M6KJ7SpxCW6DuXRe1QYr+Zgun7DdnUF
 QaimS/Y9
 CZLpVy1MP02od3AkRmpJJr74LaQibQI8387rOBowPwtACJ4/Mw2PSXC/3+Gj44KSw3vROlteMUlOoXQSlhyiiGP/dfcOQeOhGTv7oSsLbPk70nLP3jR2z62ZScHZBfgfCmN0v795y6+v6wqWUDAFjTDzlnYlDRth5vyz8bUods2/qNVCMsBhsi6YYtdLM7jNSIlmmCCzlth5fPLL9oiBP5VgxKkGSp/tmnKWdRgw7K4DdZkV5k1trTdcgDZRFdYyrXAZ9z7mIp3ZcHJGNE+u4bhrwCPlycvFO/UFCZTVC3ZumkXneXIHKjyUbxvJxU32bVSZXqhJ/m0dukX7tHo9GWnkTFc297J+15FjqsZtmy6/IGMcLiUtrUy98wzhAQBcFCmulIe5m0TpKjmf5uu9/t4TAWobH68dzDWBXWNIMOGSWkeUQGPXisIM++kyeMcYe1EiD1Ww0i3OMAVkB7f+jxo+dy8e6hpxzSDkDRYem//lDHYiv7/Y49QG+s7GKJ6IujDhMKjmdf9UNO9KSHSZCLI0Ji80WDgGk7E6h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 3:57=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/8/26 18:45, Nhat Pham wrote:
> > On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 9/4/26 23:14, Nhat Pham wrote:
> >>
> >> Hi,
> >>
> >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap f=
olks -
> >>> I need some help here.
> >>
> >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we ha=
ve quite
> >> some swap experts around :)
> >>
> >> Reading below, I do wonder if the swap subsystem needs some more coord=
ination
> >> and collaboration?
> >>
> >> For example, maybe having bi-weekly/monthly meetings to get everybody =
aligned
> >> and uptodate could be something reasonable?
> >>
> >> This approach has proven fairly helpful in areas where (1) multiple co=
mpanies
> >> are involved (2) many concurrent development is happening, and (3) peo=
ple have
> >> different priorities and requirements.
> >>
> >> Is there already something like that to organize development? Should w=
e get
> >> started with that?
> >
> > Hi David!
>
> Hi!
>
> >
> > Thank you for your suggestions :) More collaboration and communication
> > is definitely needed here. Conference is a good place for this, but
> > it's not something we can do very frequently, and many folks could not
> > attend (visa issues, etc.).
>
> Right, and conferences usually don't have the capacity to squeeze too man=
y
> swap-related topics in, so it would have to be side discussions or BOFs.
>
> >
> > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > contributors are very spread out (China, NorAm, Europe, etc.), so
> > coordination will be tricky, but let us figure out something.
>
> Yes, that's an issue. I'd suggest swap maintainers take care of that if t=
hey
> agree. I could try as well, but it's rather tricky right now on my end ..=
.
>
> As an alternative, we could also use on/two/ ... slots in the bi-weekly M=
M
> alignment session to talk about swap. (I'd be happy to learn more about a=
ll this
> as well)

That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
PDT Wednesday, usually right? That works for me of course, but Baoquan
and Kairui (and other swap folks) - would this time be convenient for
you?


>
> --
> Cheers,
>
> David

