Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14130FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D54A6B0088; Mon, 27 Apr 2026 13:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086326B008A; Mon, 27 Apr 2026 13:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE016B008C; Mon, 27 Apr 2026 13:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0F1C6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:07:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A3924014D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:07:34 +0000 (UTC)
X-FDA: 84704967228.16.B5A849D
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71DCB10000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:07:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tn7fdVOy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777309652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MmHCQR7YEWlANzQuL8DvPtYL+oesU9JFoQ7/o//1T8=;
	b=TVLCE83g+mgfwol948oOhzlDuTmuTxwBm4EUesae+2mnj/b9RxwXsdsQSZLvU+VhZRryGG
	Gs7ZRbI0ChY5HwJkzznBKxQHxfnGcJGhrxZ+P2lgpSEyoqsqQzCNfrMfLj3apeZ6D2e9CB
	byUbgO4hWC9tnZAsJusi4AzrAzEQqO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777309652; a=rsa-sha256;
	cv=none;
	b=G3Tf2oWkhMqYN9y7u0EiaD+9g9scj/1/2np3n8Z9aCSWjejrvc6wSEy0/HQd4KcdGjqTvJ
	fTLZ9T2QU/TmMdTVr/EQBaJmvr68a1kh2xVEehSCTa3U2Nr2sLEFfrMKjUW7vDnSQIIA2P
	grx8abJrzFe2Jm5h4UOveX1wN6O8PhQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tn7fdVOy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a3af1b7549so12987009e87.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777309651; x=1777914451; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4MmHCQR7YEWlANzQuL8DvPtYL+oesU9JFoQ7/o//1T8=;
        b=Tn7fdVOyllKM4OL1/slqPO/prU8zlTperwypURoEkQstW0q4Vhk/LTjOMG1YAIiZqF
         K81/qwO2ic88gtDKUAlx39mP5/2gePtYBRuLLItyP8UIdWwxLd6w/QUerpso0f+Vdi+f
         NDaOGCdwezoG4DfISfaBAkJ/jdYTwjYRtPzzVXJWLjJ0w6Kmy2j1/n5MsSkRwgdd7Uwi
         uwVnUx7T88EHasU5ngfK20xwtU53j5ubx9qF9/IRD+taAAWqqoIUdEKzqs9qJWEUiOlD
         IIEUsmZyPMBxiGoHg8SHVQrvpgtraYKxCNmcyiqbBytHoqsgNOb3jY2ldwj2m5iUek53
         WjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777309651; x=1777914451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MmHCQR7YEWlANzQuL8DvPtYL+oesU9JFoQ7/o//1T8=;
        b=GB09PEXt7uqwmJkNJiYkognWErKnH0esKnFTKIkssIxi29KRl9lVZhcZkpaZOZQhZB
         v0F3HoJCnoP/KPwvmgZYNcGvUbqY9EoPkoa+o84S1/NY/wJIB7jSob/a9/oUee30Mol3
         h+kCu882LWmzkoONOmwHtbUEClU6noMYHE4Dh4Atb6/Q3qxDcPnnOcTlnOva7/5uuYOh
         mgvntFzCzJWjBjVv8O09z9BHKOq+lhbAMqMNIJHwwCgGL8sT6Fd5ZactGqO6Fk127qIp
         hfObFWNWRAtBGhttpJItFeoZ+Jk/rK4yDivQ1PAwbcUUByx0JIUz+ruF67eWBOydmpAe
         zxBw==
X-Forwarded-Encrypted: i=1; AFNElJ9xnlb6YozSJgW+w8mDdH26RkfcSmqcL9WJGDiHH6U0hX/EcpDGHXedkn3Q0Phdt125CvmOSenreQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6iMpmwryNYGkqn8KLY9kWR9oApYU560itEH872QMQZk2D9XC9
	j7kEF9s78bBONHVvPk3oAMEeMslDqF6iWMIMPt6iJd9iia+ty/x48dYn
X-Gm-Gg: AeBDievPvsWPcDa1stUozJ7LGM0qbfbzyZCmf8GVi/JOqOSq8xE4JTds+YOa6cc/+Gl
	bQoXKnZA8/YXB51lqD1IeqBC9tRHGwgu7/EP/YoB63Ha8APlN41fHi/TAqc3lgzQRjd2Dbs0pje
	rlG4jYVH0OoD+7X7ZfZZbOLw2uvdydU47A3iufZazxcZeZNOIoqNZbd0VSKYJ7cps07wnGr5QY6
	zriPixsA8Qct2uFCbVPtKEcd9LyxwpH1RpCp6F+lXrQzKP8urCS2usRRex8CCLhoZoScxf/IbCt
	NHaPwDQxHRBwRrktQjxRn5UWwYaTet62QGJYu5T3WE98IkUGiXziQykqOEAZuUzawlhzDljKiqY
	62t/0sd6Cuuu5DL2pZ//jLjqrlSyrBercm81HxRy1l7yu7Oc4dEn9w9wVm79jt8HRwJWKnW2a6n
	o=
X-Received: by 2002:a05:6512:10c4:b0:5a2:b59a:5e99 with SMTP id 2adb3069b0e04-5a745f55728mr36284e87.22.1777309650322;
        Mon, 27 Apr 2026 10:07:30 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185c8a33sm8502814e87.36.2026.04.27.10.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 10:07:29 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 27 Apr 2026 19:07:28 +0200
To: Fujunjie <fujunjie1@qq.com>, shivamkalra98@zohomail.in
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	shivamkalra98@zohomail.in
Subject: Re: [RFC PATCH 0/1] mm/vmalloc: reclaim tail resources on large
 vrealloc() shrink
Message-ID: <ae-X0MTt6GtCssA2@milan>
References: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
 <ae-O3URyANS-mkoV@milan>
 <tencent_54339C62C9BCA8C7ED48DB0D91451157FB06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_54339C62C9BCA8C7ED48DB0D91451157FB06@qq.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 71DCB10000E
X-Rspamd-Server: rspam04
X-Stat-Signature: g1j6p35m7w4nqaiyaocig1zzoqyf8agu
X-HE-Tag: 1777309652-438548
X-HE-Meta: U2FsdGVkX1/TPVcRXeN+bluNmt4iJbladRdwuxZrUhWwgM7LzdOFDBpUcIeml2xYI26fDKogHl2IefN3gsBWl+k9o5AQAkw/RRNSZjGVDUCbcXhBx6tt6mJsu7AqsHFFNtrnFmYKsHGqtIcHiEOSRC5swyO+IpucwXdiDAT4nR23x5iX/2zZOiUiGml7ZC9vas6D6zXavTzbCJKpCgt2IhcuJW0JKivNgymRtAV5SpvQqRGa++fAkq+YDmGVnOsRIlMGR8PYRyw0KLK8wKgmAk4iIZUra6U4c6zbt23R8EFK+5IFFRh9Urnti+7CN6nTAiGL5YtcCsid1D+BM3H62H90jBWmFBtZsUG2ujfnmtKOkSUM62wFGUrt66/kCKp6D0qUYJEjd0h4MGCdKqhqYttnKQ0Gc8acQN9GP+fTEM9Tnv7yDhAPm/GKKfsu+H24MlXMDj/f2B4ct56NbXUhzAygiA37tZzx8pabMvlfq1QY0RKrjeXpLps9rrDe41xrNVsq1Dzka4aOgXiuxFeOdIWanLXVwhoJITSBhnBiEeeLeXMYgC07atDyCXaVJwXOOH67t3bGQkMm+Lx695roOu6H5Kd0fAc0VN2d1XUp/GowRW7bogeDgWxzjrUkN2lyis8igShAORoqd2AZr3MnFHTKbEVyVgpyplAqN0RjE5S4pWbpybtdWYWLYSktkYAL+wJjHioUBtF1X6fbU8K6y/Zo3QDakwHX6uP5xHKjoExJ+5qas5yCFtGjcmqbtyxkaj6K9y93Lhk0/eAFvE1yzwFKNn1q0lqa3gR8OUXm406XIRYII+BogzVeszjG2Ufddk33vQwYxDpJObCyvPBRi9gFqCo792cTZfqbHVEJj1UeLbrz2X5bCDCGkUeHpJ2ZJ+DioEXrt+Ht13nAgAc6oQtXpXUirMXBVA9Ia2UbiOAPFPVraOg8kMx85XXQHAoNSRo4AQM4lU+02vIixWo
 gvhOSoh0
 +kWNdRpJJS+Xij+Pxe/H1aJAfLH99BcG4Ds+K8780Aq4Zp88CnAiMMuYms4kxnDYfo/+b498l6SWe+lD4c+7ED+ghZiWFY0XyMSbo6lMtm2ymDHH5GUkIiBYBewBrTwWtZD5skgzQDgbtnPLqQj4fvXUmvSMZiTCTb72FA1gxOglKajS/Z5QtdKLDTadDzAci0F6WuS+dXi39Gt9LRxLfrpMoQ0Wyf5ShG4uMzfbmWCvLIomfZiHI8RIHiaNcf+dR3fiSTaxob024xYe33jt8anZ7WUc2c6dcREHHxMSYnTksTzD0OGTLwxoQRt061R3P9bXYqy3DurzyVvtg2hdktE4hMsZHfBYmZ37QumT+Ek4wLhU2eRLeaGYZc9iDTSK4oZT8EHcYak4mUNzEDBc6+MlcA56BBsdTHoJejQTP+25NnY3wZtBrVCuM9Bhb5PrnZazCY48/Qs/oKxxjm592MgoSh3tjruxJDKokuZAIgeVVknxQy57jdf6jGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 12:38:59AM +0800, Fujunjie wrote:
> 
> 
> On Tue, Apr 28, 2026 at 00:29, Uladzislau Rezki wrote:
> > On Sun, Apr 26, 2026 at 05:28:56AM +0000, fujunjie wrote:
> >> Hi,
> >>
> >> This RFC explores closing the resource retention gap in the vmalloc-backed
> >> shrink path of vrealloc().
> >>
> >> Today, when a vmalloc-backed allocation is shrunk, vrealloc() updates the
> >> requested size but can keep most of the old vmalloc mapping and backing pages
> >> alive. For sufficiently large shrink operations, this can retain a large amount
> >> of tail resources even though the logical object became much smaller.
> >>
> >> This first RFC keeps the scope intentionally conservative:
> >>
> >> - only ordinary VM_ALLOC areas
> >> - only page_order == 0 allocations
> >> - skip more complex vmalloc object types
> >> - only reclaim tail resources when the retained waste is at least PMD_SIZE
> >>
> >> The current evidence supports this as a resource reclamation fix rather than a
> >> workload-tuned performance optimization. Local validation currently covers:
> >>
> >> - synthetic large shrink correctness
> >> - shrink-then-grow regression
> >> - threshold boundary correctness for the current heuristic
> >> - KASAN run-rootfs vmalloc_oob regression coverage
> >>
> >> I would especially appreciate feedback on:
> >>
> >> 1. whether this shrink direction is desirable upstream at all
> >> 2. whether the initial object-type restrictions are reasonable
> >> 3. whether a conservative PMD_SIZE threshold is an acceptable first heuristic
> >> 4. what kind of in-tree regression test would be preferred
> >>
> > Could you please have a look at this work:
> > https://lore.kernel.org/all/20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in/
> > 
> > Shivam is working on the same feature. Could you please check?
> > 
> > --
> > Uladzislau Rezki
> 
> Thanks for the pointer, and sorry for missing Shivam's series before sending this RFC.
> 
> I will read through it first and avoid duplicating the effort.
>
Thank you!

Maybe Shivam can also have a look at your work. I put him into To.

--
Uladzislau Rezki

