Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F8D5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EB36B0005; Fri, 10 Jul 2026 13:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FD56B0088; Fri, 10 Jul 2026 13:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7C46B008A; Fri, 10 Jul 2026 13:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB2C6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:30:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD03B1C3CD9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:30:44 +0000 (UTC)
X-FDA: 84973556808.25.E10CF98
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5EA6C0011
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:30:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KICbRxHX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783704642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
	b=guxnU7vqUx8B5ncZiqQGWdrCipl81OH+ELvwLCDmhz3ZR3ydQVK/EUbJeN6/wndn2DD0Pd
	kQTWcRYy2LOU07zrnOwQ4WjjFX+X3R15efWwgYL/mu7LliNA5zFKPd3BbZI7MTk3hesMg6
	gi/8ST1R6AvjobnConV6f6+wOo5Rc/A=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KICbRxHX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783704642;
	b=pP6OzjNUtjPswxbLt89X6v8BVlRRvT/AUP+7VmryupS3hORGDTjDiPu/8XH1xMdWYfRD7g
	ajJVa3AicAU97+uw8GgtjzszBBMPWflYx++VmIqswsOJ8eOW/uHAL60egREvJ8jO7tPURD
	Q5BmwDj+vf3qi1JDkAfb+29ZgCSVfxU=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso768193f8f.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783704641; cv=none;
        d=google.com; s=arc-20260327;
        b=lT4RtN4il3cuJZCVDvFuiasHUL3ALa8GUYEFhEAFTgb6W50fpr9Q/Hz6GDPhDVnG6q
         EFFGsH4h1jlUjZ9ukpwC03iWdhvD5KavTdqjoFAPOMg3bRAUl7Bh/Gkv8iiPTDdgwwng
         iTq7+KiGne3HOP676DE5vdgMo1+78LX/LpFeSid/Mfms4HMLBDf4k5ZiYTVaK7DggOOm
         wGNiwquyqEUNSOj+9hiaaz6xKXwOiuMTIEqU5CyZCgWQ3optHQ/NP4KI7cfEW4oCiYtK
         MQfJdBKZFpn9iGPNw1Y0dWQVSk0SNY/7hNymoEOeTbWE+NUdxmbK4KkuGxQ8328zXSb5
         4rqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        fh=0G2DMdbDoNu+tPLpYbVcvwYK4uZHGHlAR2ivVVXVYLw=;
        b=HmTnQzLz6DaGkP4saf7cgKOZcEIhXhbQMygEJqqrevLiparkbtizZH+XvsU2uyhu0I
         KpIUBHs7tyMqoJ7AHRDtos/0y3s7fhvMn3RHIdZck7qnqz1+w/txquBCKQ9fNmkHuy/o
         Lv5p8ODEMbfFsaO0pQqJGvKGWdH1Wuj4dybEv9g/UaSx9ubePHtErKz3xl4LZM9gdV+F
         dGJWwUlyadDy9OT8EVfVWulkCXemobxA0lgKPghoGG94/wDVqQPlZZjRNTsdXz9u9CY3
         op3gLWXsCuMOkoWPalcdYJi4ZhJkX/JXNIYj07yC+NL1fkYqEsPqoQ0sW5IwqUVi8m9u
         VPeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783704641; x=1784309441; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        b=KICbRxHXWv8StSdERh+3VBEWLT+9fwAsJXLwB0wb12L3zTj8FR5Rb6LvAv2p2w7HpZ
         IABVMAk27hM1fulrClfQ7GncenhwDz/UEaPjNZFWNvgkdb8ObByrPDldIWEFITJs2Um/
         St4Vvw7ol3muRk0b7pGhO4DqSkQpNk+vY3ITegSGXect6HAK7dzmKMHbDbwKgHuXBCr/
         hUwlxSdwmRjiNIx/df4YVbIYZVUXAAbOBerjtmLpQgez5qlaYMXiEKvVbJCiQPAx4CoX
         CB6juiCJw0vQesPFKQ9BFj8jl4qO95mgPClZrXdH/g79jyFodVTIJvTYvTjTQkIrgidL
         vG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783704641; x=1784309441;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        b=KmObEDutVKzFBPKf1do6M9DmgJB4vuDogrN8eHhSefYrt1F4aMuIi6rQjAfJMgsz2E
         8uxPavtsEhGGMdOb0bNkI8b135W3/zWlgNZ/wBaNc448HuouYoFT/TbRgaUB/bN0KMO2
         dXRWoXqJoc+FfrTvQsvG7lckCpqhgdL6xBJ+OgnYRpEP+INGcXvn+9YUAYNW3/WFJcaG
         DMp+A2P6vApS2paL9tWLBrh1lOC+a/1DkM0Ry2zYvNTXOdwZwsPXAEDppkpsphjtMFh5
         GWlU4RLIemEwKAurT1OA6HLC87l40hjRNHR635m/eeANSilmMkzWbIBOjJyskljFxiXl
         TKDA==
X-Forwarded-Encrypted: i=1; AHgh+RoKvAsS4EUl7rLSxfcifgeUhNg/NX6KNpKR5ojQdFnK9VGUp282fxngRe7guCLfF0bfeE+k/OiuDg==@kvack.org
X-Gm-Message-State: AOJu0YyDPR9leEH20Fss/d4FH8N2upT75Dl+fYGLLinAj4RP+X/RhrX0
	dGMXIWg8oP+XxY3fJCwwRDevJHkLvT2HO1hMTKxrfJnyh7J0yFsnCXhmwJoyCrNim2wdBS2orVl
	lWx1MMyouZHafCvX1m9H7BFp41Ovyi3g=
X-Gm-Gg: AfdE7ckB5PgTV02fvjePFfagpVwfCL+bb7yH3bHMjcNORNzecCM4FUQuFhRwkiia2o4
	P+DHqeQSOXYymi632f2zfxliB3fJiGgRlvUXgmh08/xpS6TBgnXardhEDGGGK7+RJq2oLYGE4jr
	sAHDhMZ9HbPF4JpPT559YzXemZEzcNpoSQSCdOZVa8rJR/HDs+WQLD0k5yE/dgDf8bBivz8H66Z
	ph3/Q9tipwqo11a806svoHayZDu8B3Fr8Y9g5hPn1LsdjYdouKaikCNI4N6+76BQj88UXtSsHeT
	AgygGZxSzOep5FuBmf62FRONBLJvIsqZvqeY8BM=
X-Received: by 2002:a5d:64c8:0:b0:47f:2bce:6f38 with SMTP id
 ffacd0b85a97d-47f2bce71f2mr1605932f8f.28.1783704641136; Fri, 10 Jul 2026
 10:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
 <ak6c2TaOlcGxZ2Ih@localhost.localdomain> <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
In-Reply-To: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 10 Jul 2026 10:30:28 -0700
X-Gm-Features: AUfX_mwd51QhDhOxXEqljZbVmcwLnRoGIaPgZBSLTfEB8WOHhjbjcuIKoDcPaYY
Message-ID: <CAKEwX=PLauANTu8nDLbDmViQ6u9gvh7HbKffUAzUXuBa6Jes=g@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Yosry Ahmed <yosry@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8hg1jnngh4fr688p5euj13azf6osxstu
X-Rspamd-Queue-Id: E5EA6C0011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783704642-394164
X-HE-Meta: U2FsdGVkX18BVpoAyziEv4XoRcswEfvg7HiEsYw0ZcAsufQhTFumtqbjN+rG4nJ4ndfbVp7HbcCFkm3Ck8VGuqTKGXK9WCkucIwrr2FCSpghljHMRvvdvyEl9EeYtd0PEHNnj4sXiq7ywerSaj1J8/Km1plmRHGFwNswOYO9Zednh1PQSUkKa6MHfzmEqH2c0bDnv6vYcYk1FjamQSuLtaXMWHlTAGuvvASXKcR/dDMUg9S2BYYiCxvKl81VaqWn1xTsrhMmzdRkD2VpEFyrfpPtzrF2o43MHNcWxSfIpvWZoejh3udja1wURCjvoN3I3JNhFnMjqvlVjReYZUYtKDxJL+Bs7SNF95KpWCP0GTBZfzJqrn0r/iB43aDV2FazpIX5r+/JWjH7v2k6R+i3S/3D3+Ua0sKlBz4tSMO+obqKb7KcI0nmSdeFGMAXbbMlmW6qeZAdCrHIXRnAGNqe7Zhljt5gsdPTPZuOifWuCanuLE+wqKN27O1dFEGBSPpPVYfYTSku0hpOnQQL0oFzdIPv8Q0WvhNEalNxnIRf5cAaKz19utQiYBK+Zf9S/ZaiNB34aQw5KyhpGtRNkQCuk4otM6sZMTPDRyes/wxYGym/lMvh484gxC3/N8/tF229MUdReSn97Q3SFiVBehpN3WXjy6EAKdtLX7l5geef7tV2T4bUfEXzx0ld8PbKaBpmSu2qBOOPmwXb+fU9W5ZieAnPjkJnQjrsTwc+weXdEw0FYJKyA8yIpqGSmIjqX5ajLs6YnYCr0LM029nv7P6pFKMq+tfAiCZpDmmSLZkWRrzUwUvRp1qcvS0uQNZEyuw1YpOUYYk5mcbh6kW8lXa0QyO06ofNLLN7O4aZMYLnyTm6pzoCEisNBWTABrNm0UuqttMlsRy857zrXlyN1ULgTGEWbu5SkTS4efUT+JDb0lLsi6gzmg9+mP0rO2sCsTswLntk/366oF6JNw0fSeJ
 /Kye0RaN
 AJpt65IZBDBRRo/d5O8Yqvm2oCzoXoUf6fbtVycTvOPS3pnlwlePHY1rYMMyrlt/bnPbFnJEKz2oCwnhcK6+wlDLHDpBvGK6XRzDDidE37QeP4W6zNWtS1/sQBA/CSTx/+kfdId7h7xbBHn22uVbR9Mi2Y2Znxp1i8kASLJPGMnu0PxArWhlTdxfplFRJvhDU+5yPWk9UKrxYcH4twzcjHokriL7DBNcL0dEZ/XJyzoCta9nz3lWH+B+vTfWDjn0JFJBk4kCQvv4m5sqiFlH1CUxPC7iL6gg+kLa9666P66MPuatKHSs7tcSKK/DbXnulPQ8Kn1hrotK465LU5wxHRSilc2OFARq01JFjuvWBL9bgskrsNgttIJB2yp+peqaGF4FLQhRz+J4fl6Y80fRKER6bBfxBe3SQ2b7f4wNUDDVaSxpLKCHb/ifR39AUaUSbOs9IcZXTM0Qdtxvf4tZSlqyvLPPJYvEg+heWNAbqrG/BD7ohHvU50J+REClZcppcqMlngLwyfH+CY/pwq8JfVncf5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:08=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.=
com> wrote:
> >
> > On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > I would honestly rather use more memory. I think there might be cases
> > > where the flusher is delayed. The flush being slightly delayed is not
> > > technically a bug that we want to see a failure for, but if a large
> > > stats change is not visible that's a user-noticeable behavior that we
> > > want a failure for.
> > >
> > > WDYT?
> >
> > There's already the (recent) page size-based scaling, so the idea with
> > nr_cpus scaling could make the selftest useful on wider range of setups
> > (even page size can be considered as a slight implementation detail
> > leak, thus the justification of nr_cpus dependency).
> >
> > Also, I still think that internally the threshold should be changed to
> > the "harmonic" formula [1] but the selftest can go with the linear
> > dependency for more pronounced effects.
>
> Yeah I agree the threshold formula can be improved, but we need to
> make sure performance doesn't regress.

Yeah that's a separate discussion indeed. For now I'm fine with fixing
the selftests by using more memory.

Is there a good generic formula for this? I understand there will be
hardcode values, but at least making it scalable (by how much memory
we have, page size, # of cpus) if possible? :)

