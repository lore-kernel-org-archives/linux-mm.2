Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3629A109C046
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D786B0005; Wed, 25 Mar 2026 12:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7048F6B0092; Wed, 25 Mar 2026 12:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AE86B0093; Wed, 25 Mar 2026 12:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5147B6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:49:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDD931A0873
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:49:28 +0000 (UTC)
X-FDA: 84585171216.01.1BE9B8B
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03C6840015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:49:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LZN6RyHB;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774457367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KHc+LjoEpTOzgKnEsolcMaPHiEs9PP1WuXP2Jldb0w=;
	b=Qv5dCVBiq4PcAbwV5RpGILVm0/SAwsJCIeN1zAUiCM7Kh7qxlJQ9pq3F15c/QEP2s5rXFu
	zTa5cOkhBER1+kiijzeN1XXryZnjcDbf5mOT8Nli2BTNJEpnBgTnpNzBYJBfbHVuHG79Mu
	jUNzpDzvL/V/5XEOeVqG7o/MihbsD20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774457367; a=rsa-sha256;
	cv=none;
	b=lZDDjHRCxD2LdvgEPuNswXo/NFxYjwj2Glv59es64NPtIYX7zYgpB2goLNr1ClKH49Mhlt
	OhxvhY5hb9OtO5JjMNK3tWoKxPboVLwcogx4ckUkvn/kxYTgJ507ryPtNpxLGyF6E/0CIC
	43BLot/Ncpsj10XDbOI8zWs1fTQoZj4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LZN6RyHB;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38a42a0d7f7so9989691fa.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774457365; x=1775062165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0KHc+LjoEpTOzgKnEsolcMaPHiEs9PP1WuXP2Jldb0w=;
        b=LZN6RyHB2lJtUsEh0HUecABNYY08Wa847kc57714Qw/0ntm/lAwQeF3b5/VqvoitW5
         8FZnyUThzJWmmj9pk4/XAGZq+rMZbEVYavDfnkAx5t9ln1DmZm6ntubz2soh+XryKkIL
         Q8b3LDruvU0XijEvhN0EeZIaH5t3X4wSgxiVLHIV8/Ni3Guu9YKW4XbKmmXWlYf88HPo
         7Be3rzLXxM3f/EUGz1giNLT2QI5Newj0LnZitj9dtmXqqDlyXrrshzTUj3pdcSOz9iHY
         olTHJCsRaz99Lu+nc2r7ajLWBH7l9SQ9XLEvnhcJr4FqAbUtrb//8NaDlOqo7CQ+aCLI
         Bd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774457365; x=1775062165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KHc+LjoEpTOzgKnEsolcMaPHiEs9PP1WuXP2Jldb0w=;
        b=TEch7jCej433eoj01FreiFOjTAKSmYXnbYXzgYXsIrj46QIdBhJPCx5i5/W5Jpp2Lh
         yQ8ncImEoHFw3Fptc0ay0kWGb0wpZVACcHXHiWpwzvDiwhWIjWceE+CFf9pPLLQVb8Wi
         Dk7X9cq525ydY0dSQpjGpA9Oi+NHWHfCWBA3N5GO5P6UhulFIC0XcvsFMyO8AhvInUn0
         eBdsPU/Tw0F3jCyBqV6FkVp3wkdqGwA+OCnKx7lb4c5jT+GPTAD3JQcOJT8f/X99Q/zg
         iqzzOcAMg/Ff48f4ZN9VmXfu5Agp/ZNkmZ4yZ+XsGFjbsfXiijQA6Fn+g9ey9J6tWoW+
         rT2g==
X-Forwarded-Encrypted: i=1; AJvYcCWlu9qutBYtLpNIVe/0HQzCSX26D6YLApo3vBcviWVlJpq4MN6mfx53g4qNfaWGTQy7FXVdYeMc8A==@kvack.org
X-Gm-Message-State: AOJu0YxvarZs5Ir/nmk2BQRGsJTpY428KKdzc/py37mPPCKiWJRLAGGR
	075iK6kHTBEMBYoUXyqqREubq9p5vspG+KDWxVbNpuyliG+P6WWLanXg
X-Gm-Gg: ATEYQzwLeP7w1jHpRFnNisnWyq56J+xQRrhbY+NW3MZXMtgvEn+EqALzo1+l4/Y9Jib
	jMm/d3wyiSAqsG8Wa5VnvB5DXGzOOCZIb+2aAY4vlCmz9gROjKX6pHYOfQsmMW524KnR61rK0yp
	LeUYz7fX7pjI3jJK3cGqY4dZZvRT/1lEo+QD9j20z9ex2M68Q+kps9DLK63W6OlEKa3SlvztDDG
	MuXe1UFOoDtPVAMvPduIgOdxFKVRcs4qwmFBl1CSbYOlHZM39NFq9MumZNu8HjDKVx1g7afYVVA
	910FVJDEi9Ia9krW0qBMma273JUPjATJZTIEo8vVUl+soTmbpga3R3VeEnvhLutfTkWNFsLndfJ
	A1OPAOkPEHqOgGuGXSo9EzlALdfl0UUPOHensv08WudM4UTziUJB4EMr84iifVsWJ
X-Received: by 2002:a05:6512:15a9:b0:5a1:3d15:2861 with SMTP id 2adb3069b0e04-5a29b4f8bccmr1758576e87.6.1774457364681;
        Wed, 25 Mar 2026 09:49:24 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2a06892b2sm13867e87.40.2026.03.25.09.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 09:49:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 25 Mar 2026 17:49:22 +0100
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
Message-ID: <acQSEn2ZfF5zEtE6@milan>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com>
 <acOjIcqyIVY9KNn0@milan>
 <a79ff8ba-ed4a-43d0-9c4b-d2883a5c48e8@arm.com>
 <acQKZBqTjpm6-k2f@milan>
 <84f14a13-6236-47ef-afc5-e168d16caeec@arm.com>
 <cbc7c2d7-963e-4630-baf5-287fb127774f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc7c2d7-963e-4630-baf5-287fb127774f@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: u4d1ifguqb9u7nkguw69dcoa7zg6gdqm
X-Rspamd-Queue-Id: 03C6840015
X-Rspam-User: 
X-HE-Tag: 1774457366-4217
X-HE-Meta: U2FsdGVkX1+mZVhW3wrvR/OyVT0mAehddAvfR5/m2jTPJ2hpfneA2edN9TA4Nwmfrhf8tfD8d7fE5vtlFc/j/WiLatCYgonvuI92R+hZ7eDnBK/j7K1XwAJDv7hqrCbGzjpaDDPP91SSj+HG3tYXaswxVbD6tAaBnBXh28BcfNUAB6ZqaFM2qggOUdefp2IfMt5Vl4KlvBwGLgw3C2rj3Bu61CBSj+OiaviDFLDEEwVqMRM8hg3kWhACyv05zixmeR/EbaTqKC4v1wMTGvq1OeW+G3/Hm0anH7zuz5ZcS2PU+y6iPLk62xYV3JQLXJD3oSPIi34oMGYG9ugx60WNyaB4JyCe48qH9ExBfEmyssxnnMV6cfz4WtmwdM8c4wmx4gb7kbUXglm7Ik+/JpHS8AntE11MwdaK1Ily5ffU+uF3tq1MieJA1efkGvJ5cXMeGz7N4lkaoZq2DvdOIOyK6JUk61hwl99vdwgUc7rb5etEE6V7pAEqvSt/Ug+HFfWBHS+DILqe7bMLHzH5wI9I2bLYB2UL29wyPRaL0lgJe8xm+ifYKH0m5xgzyp3cdf2xw7crwoQXkbXDs1/3R77Uss4YODHAUrqeE86QEo8SLNu63lqnTr2IEKepKHrms/FbLx12eO/rL4ieyq5BbvsKOcwOkymDknGH8jNuFMIGqUb7eXuzC/fum/WgCz9KaqSUaqvIhK4l2BWe1nJWu6UQIvkd0SQEG47j+PGAjNs1fEkxrfk6k6LZCzHnskVZ+LubnSm6frVm7v4iSwcehtvpYEd1/S/b6lpCfqyzJDFERvbQVVEOzbA6L2UWoSyRJFu4wKUScA1jhmKakwxG0vTI6dNJHyRCNoM7oX9lICWloo/b5wqlj/boH9pIOQH0Y5rfwf5snxkNdSHkbSjkaWWQwz9KR/F68xxlrSLozFlNMLESsD1a6rSQnNexTAN9f2CU/GmCDxwkqUxMGnGX8aZ
 GN9lXFsy
 PWFItd8VMh5/C8m53jsdUxAMNF7eY6WS5hZKPqZzYFNWKE6CQZvvs3vFNclEo17Bdq1f0r8w3UnLvo6mtDJ2xH1U8rFxVTl916wHs22eL0VbREMnouiPJu0x4bI85IGfgKH3HAfLzBacRmvivsgvMU8vi6ashM6yBVwZhFlnJm1Xxfum++ijbyc7MSz3QrzfBPbV6QpXKssKqyme6YaUZTyInDLFpx0A7G58Q5xYDhUq1mr9p+wd2oUs9Xn2B08VdwCH8jrYabL4i5zkVlOgms7+y+cL3uRx+YESRmqDWGFCnfDn4FJVy7xD2jTM8zL36n+laFNELfPeekjhsDl5EjOR+xwfRQLtd3H4aRwQkFhsSbXXvTS0GUp9ErpmGxB3dhdrFutof71C4IViriiF6hLzSw/zj8QKQrwaSdfuc8Zled6Iq2hlBOJAJoeH82cTeUCsOA717Jdr8+JophqpdQcwiI85CGMMIBa4U9C1qsnbqPNVKOvFvLHGcHVRu0aMXrjMYkg5Ry62ZsrH0y95RbNePmej/jksKFwT9lf9S8iMZ2C0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:34:08PM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 17:25, Muhammad Usama Anjum wrote:
> > On 25/03/2026 4:16 pm, Uladzislau Rezki wrote:
> >> On Wed, Mar 25, 2026 at 03:02:14PM +0000, Muhammad Usama Anjum wrote:
> >>> Sorry, I didn't get it. How does having cond_resched() in this function
> >>> affects __free_contig_range()?
> >>>
> >> It is not. What i am asking is about:
> >>
> >> <snip>
> >> spin_lock();
> >> free_pages_bulk()
> >> ...
> >> <snip>
> >>
> >> so this is not allowed because there is cond_resched() call. We
> >> can remove it and make it possible to invoke free_pages_bulk() under
> >> spin-lock, __but__ only if for example other calls do not sleep:
> >>
> >> __free_contig_range()
> >> memdesc_section()
> >> free_prepared_contig_range()
> >> ...
> >>
> >>>
> >>> The current user of this function is only vfree() which is sleepable.
> >>>
> >> I know. But this function can be used by others soon or later.
> >>
> >> Another option is add a comment, saying that it is only for sleepable
> >> contexts.
> > Thank you for detailed response. I can move cond_resched() to vfree() and make
> > free_pages_bulk() allowed to be called form sleepable context. But I feel the
> > current implementation is better to avoid latency spikes. I'll put explicit
> > comment that this function can only be called from sleepable contexts.
> 
Sounds good!

> That's probably good enough for now. It can accept arbitrarily large
> areas, so the cond_resched() in there is the right thing to do. :)
> 
I agree, since it will be available for other callers, adding the
comment is a right way, so people know :)

--
Uladzislau Rezki

