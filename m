Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE6F606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Z91rqcM1
Received: by kanga.kvack.org (Postfix)
	id F41FB6B0997; Thu, 22 Oct 2026 13:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19B46B0998; Thu, 22 Oct 2026 13:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F466B0999; Thu, 22 Oct 2026 13:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B397C6B0997
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:03:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40D36A01C8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:03:41 +0000 (UTC)
X-FDA: 85350883842.11.CB61F74
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FF5814000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:03:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z91rqcM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792688619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
	b=Q0lbdDeDhqe9ZK4kFLhnLy/kxBO9ifbaVMNrrvYAun8is+L3bRRZlK9ScVYCgps3+7TmMj
	gS4PEeCD/8AjinVazWuAVXgEL3MtnZKUZuaxDQ4IPno9cUIl1SZGMTcGzHRBZOfpc8E+wE
	DEcr62lGzONn5lVlOYigNR26SUn/9Q4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z91rqcM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792688619;
	b=v+GqFAUgU25FPOBmvrdL27C8j8vMGcCbu3HJ6uudJcvuTCKEPt6yJUTV0AP8podeSlAc1p
	0MmQu1bNB2vj9uEsY9MrQ6TMmefbBUKWnmCQXvvetCT8h7+y5r0CujBQRfqhGfttE2iykt
	E3iRedyYnCysNAU5MJLrl/kYk+dYFko=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20b122af8so526925e9.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792688618; cv=none;
        d=google.com; s=arc-20260327;
        b=FYlLedkMl+Hwhc1/o3yq+ioX1XHWYrfRmsXm11xkGRRv9X4Dqa1of4QeMgqCn11b6g
         zJJqO337CBF75mdP1DQku6chjvFwC4zjqHq9L6KBoRKlvCL9sWfP7bgUwITdJ07OKSaF
         LZxVSY9upjygYGP5WTbC9Q3uiMZFNS/czwtYstG3yELKL0Yf82itnlSeZ3WTu0WXtyCZ
         OZ0toltJyciavl7byqf2Vb2TaOnJb+LX//79CVF8RGdnUEqJTGgQPb+b8TL5gm68qycd
         U8Vz6uQW2T6maxrsb1/mBb8624XLB9ZgtpKmKHbfleF6/OXptFUfuPKKQoLMi0GEzM6z
         xajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        fh=cSmmWMJPGYUAwKedHA1vZAtaulmTBDSgyzTdbqV5+/M=;
        b=DXt5tOEycwTeYem8/s8fdm0VXzClM2+A4VxQDoOiyep3ffyluIPt3ujj2Bz1bDDzXk
         9BVxfMbYWnD4HwuGcZY9PkI87auw1J4juXUAiPZDz5SBXHuo5IpBX7nMuVFy35YuRZRz
         jEuF3YGv/vFjBiYIe6tsuuFPLvEzokk/0kzK7Tswp0TJs0GMNPef5Jc2rpZY2KjnsMjg
         QbFPGjASNwBdAAUZRCJFUQ9T+P2odorP/KadOcy+H/Cp+ou3JI/3q7vn5hZ5jd8fHYvL
         0KYb2MxIm9RPJ0dYBlZSgQq3AzoMC6D3i4+yjGTHJ3OHoFPMdyv8sg5T5bcxm7UpWuTj
         J8xQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792688618; x=1793293418; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        b=Z91rqcM1ukB/W7HXSEcjznAlxMGKsUl7HsylA4gmiGwlX/H5GXcbPHA9qzPnTkNpSR
         +ds6hefNYdZcRjQ24eHs2MthYq6lONFyvF2YWQPrEPRqLCx5y6LXUPdyICi87OCEppXO
         Z9EryCjWCfMICocusbNqSJo+N9rvPc0y8TuUK2moV6+M9jDLQozHU0cXblPVSjSdpIPH
         oRrRzaqeXDZNpZMtTOs0mexBkHGnVGON3n/ig0TTiIJTZPy9g9BOsGYUij6kxcMtK407
         uESWziFmP3fazj5Wc4aVdvoXht8lN6kVQg6gPp2K5gLZbugSXfeuTlC3pXkjeqNpKtwO
         ZaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792688618; x=1793293418;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=42ZKTYCAvrM3nzOwxlsBgd+YAojo0q+aV1smVjaq8KU=;
        b=1FqZp5uhfC8btsVPWxdnUncF4Buw9X52Mkebobp0WM79jUa1m2Zmn2Khy6pHPS1UpP
         VgR14HjWPdi8UJy3Td4tTGx04Qlm3W3JzDJquhHE+bqghojWtoFAV3L4z94q9RK0iZxB
         lqzNDdxQo5rBBkr0dXxvcPAqQKq225UHQ7O7/0tljpaSFfynV4kX7Nl0DWjrR7DOfTQI
         P5+y9AYBdpxnBSPhAITL/IGCRBBGmpLi6U9fkSAorDxs11BU4gUByYW4CMFQMdmVXoEL
         1qKc+lU4nGsCA8Xzzr1/oPDJy9//21car+7yiWqKlMWAtrgppZ41QoYYV+Uw/hHAGdxA
         Xbgg==
X-Forwarded-Encrypted: i=1; AKwUvBz8nYGQh3QTTbTY4Pf4H8+JB3ODnKuN6zxvyxzpOfT5PeHFooyHJkY//ZDX7A4nCLTybW5a8B4dMg==@kvack.org
X-Gm-Message-State: AFq9FYJGE5nV9O8dN2YXmBG4KCS2Acg8nLRSxZeMTX/22yVVFtvhD9+h
	um74W2hPHFfllxcdCKn4/tscAhNb0JmnO67QoZHJlowN+VvPnT5zA/0rlra73joU4p6JtA/zxqM
	F0PL3lqme9yFj48YLeHt04y60Gx5PsTc=
X-Gm-Gg: AYBFou2lekc/2SsiZYjuP1j2lCQwi5IlAwm/JWy8n59IEMaeT+7hUrE/wWkfWCG/pr8
	YwPOjpXPbUOyiaknESk87A3bVJ71K8z1JuENSih2+4ymgBe0dPymjEps7AOG5SHfu0VXmblCKMc
	jOgBgRjIQF8CPyd6Xhi8ChTm2emOFhurNyZ7Vi1/NzMygtydNmE1QwYigWoj4XPLmMs+z+qYQk+
	ccD2JJnTxV1y9En6dhCyOJTXPx0DUfD9aXkJ2RaFoVSAZ2FcOXRnBd4o35ozaMywBMh8t1kdiG1
	Vb3v+xKgt083e1TtFfH01MIWM0pTQtAU5jgBCldeWEnE0GHS9rhv7NjBDaeT2v2abtq/0UwveAE
	JW8nL7VoCZwc7ATVPqcjivbvlcrGf9M+MDY7Oh1xz0Kk6JJCA4maz2n+/KVuEqGTPeG90C1hVfe
	1/DI+6jgTQpH9ANJaCVSIaoPvc6lydGpW1QuPVDXQQymI0WDx4ZQHt
X-Received: by 2002:a05:600c:3e15:b0:4a1:e11f:b2d5 with SMTP id
 5b1f17b1804b1-4a1fd8a85bfmr107503165e9.2.1792688617341; Thu, 22 Oct 2026
 10:03:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021060323.553433-1-nphamcs@gmail.com> <179263657717.2549665.11401372071846447074.b4-reply@b4>
In-Reply-To: <179263657717.2549665.11401372071846447074.b4-reply@b4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 22 Oct 2026 10:03:25 -0700
X-Gm-Features: AclHuK-KHka98G0XQ9c1yETjfsOpMIxaCbqOu01mqGiSr3S8GqcFL1s8QG2fmng
Message-ID: <CAKEwX=Po0J7KsR93YnP4SyXkpqZqjrg7HxyT=17gVD-fNtRHdA@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] Virtual Swap Space (Swap Table Edition)
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FF5814000C
X-Stat-Signature: hfmtq3t771jc16ogfiq338czb6ss6drx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792688619-340716
X-HE-Meta: U2FsdGVkX1+dwxiIDmX1g2POLe9tg5IWmfZEl59G3VP0PhD35d40mI55owcspZIiKWpjUCZ2mxtxtTCfQtWBGDfvURG/j+PunqdFe65X5zZ8zEiJDU6s6BBMXB9fajZ1xv7+80Wp5KuXhqiCxn/37cbjgDZ7hFmQJclow85akgFZIBMIuyEGfr5B8+/hzaR+yXBL1rkJukkl6TjfwsGMywvbX3kze+12NVGagvf18jSav4W5sJKQHRVnbg3pqmaL5YHf4/P+dOmF/I3Zva2kIvEe5tnmkHqRHpHRL1ob11dMexJ75MavjrARnwOVJh+TCTOKyki4BA/6O2wSgABgYKXnXUmcWCxc59rz9FjFxnOCw+AHeX/rvDlRwsbb3rQdRvjFipEqfZM2uv8EPoW1Z9CqVL9yu8jLgtUeR6VVy/PH7KotC9ckKUo1kc3R6+9N5h/aK4jx1NzMs1TAH6j85xnBiV1aTNKFToOHgGpR3bg8RKoTAZlyC6XeGh+lGA5xrGOIkRmhlQds9787+2cV/Y3emQh35jnoxnbdgqblhPZ9cBHbcKF/4oIVaUBVzTxUOtLGNH1VivbksGd6rmAPWLUTMXQHq0aI32pyyGayo8eg/2ZSU6LSW1C3dGYMLcby/Wlj+G0/gmclUnNoa+ELdI+hRksTWNiLW62jf+4ZM9t/mgpjRZwG+QEUtgl4UlclM/Ma1VCEUQyRymn/DYmwAViEeDMdcRx1bYlhLpV2+cft2IlbDdEzVSNkE01heBKY4TOX6dkYfbsmY6T06InHf0bPMqc99IuqWULojvFuWNcaOF5H/UG/iK6DVHxSuzu4O8N4dwEseDRUr218v6chGIiRCvQODNDR5vrnwUqHWaFqR7cgFwb5FdrXx/bRQ+ewnpn1jrhc04UoqeY4GKOIIBdGg1EgTd/D5VOOpYCmQ5XpQ6Vf2/GBOL0qYkkL34OuLI4OVR5v4IpyXcTDEd2
 caalPChw
 jJWxuN6/+l83HnHs9cPd5+D9NAkqC0CZB1P6b1VEWj90aeP50CXBK8JCPdaBifWuLov2d3ZUanFQnssudCRN2/5GGJOQ9b2QkwEJNoWL2/XsyCmRcANsngpj3jKOmn+0FFI2XZHl1H+URMz1ptnC66VMJB0uBBT4STrpAAXDdW3+9v65NbsT6U6TikiCTSZ8c0rU6O8ZPn9iIl11Na2s2Z8gKxqV0Wd3Kk9Gq+RMz7s4zYI/VO3AXKsm5U04G39hyha6Qt7qGnPYw8ydyf2YofFynoCjEounsrNQtjrHSvCiuO9o4wFbgzpvEdyw6dNUWj42EtJm68D6Y3hvXYiX++3nwBdJrZSgBcrQ13NbQBPBOiwUiF2IRi/oG5lpmx42PjXq0SnvWZI7iK8mV4gpSdcRa5E00qHN9S+erQOFUXSQ5x2bYoMnIXtwHX6mIhOfVTmG7f4dkubsV6T2TtupB74j7Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:36=E2=80=AFPM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> On 2026-10-20 23:03 -0700, Nhat Pham wrote:
> > B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > All values are mean +/- standard deviation across rounds.
> >
> > Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> > Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> > focus on zswap here because it is the motivating use case for vswap.
> >
>
> I get that the motivation is zswap, but it would be nice to have
> disk-swap performance numbers here as well right in the cover.
>
> If only because...

I probably should test it regardless, but likely there will be no
difference in performance numbers. Right now for straight disk
swapping we incur 0 overhead, because I just bypass the virtualization
layer :) There just isn't any feature for me to entertain vswap+disk
swap quite yet (it might come soon-ish though).

Vswap's physical swapfile backend is only used for cgroups that
support zswap (for zswap writeback and fallback if vswap fails to
allocate or zswap rejects the page etc.).

For the older version, I put vswap in front of all swap backends. Disk
swap sees no regression, but Kairui found some regression with fast
in-memory swapfile (pmem). I reproduced it with zram, and I think I
closed that gap in my own testing, but Kairui did not test the fixed
version AFAICT, and I also don't have his full suite, only the ones he
quoted.

(Btw, Kairui, could you publish your full suite, or at least the full
set of testing parameters? I would like to hammer the thing myself to
expose bugs etc.).

>
> > For each benchmark, we test 3 kernels:
> > * Baseline: mm-unstable, no vswap patches.
> > * VSS off: vswap series applied, vswap=3Doff, to verify that there is n=
o
> >   regression to existing swap paths when we disable vswap.
> > * VSS on: vswap series applied, vswap=3Don.
> >
>
> If the numbers you presented carry through, I'm left wondering why this
> is a boot option and not a build option.  I rather dislike the boot
> option compromise in general - but other reasoning aside, if there's no
> performance impact, then I don't see why it shouldn't be the default.

That's a good point yeah. Lemme think about it. I added the boot param
before I decided to bypass vswap for physical swapfile by default...

>
> ~Gregory
>
> --
> Gregory Price (Meta) <gourry@gourry.net>

