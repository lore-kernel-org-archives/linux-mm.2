Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C3FCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA2A6B0088; Mon, 12 Oct 2026 10:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B526B008A; Mon, 12 Oct 2026 10:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AF96B008C; Mon, 12 Oct 2026 10:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE9D6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:21:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15D281C48C4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:21:50 +0000 (UTC)
X-FDA: 85314187980.24.981F348
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EC7214000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:21:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2V+awZx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WX2/gaEkBEYMG8ABuo+LESxvmJs+8+1r4PbbT/7xLQ=;
	b=TT3PDQ3tsJiwQTHlugIUF3fOg4j/VUYJTU1z0onHen/K8cDV166kkbqJq4uMhHoDjscrKk
	dAOIesIp2P1mTfAz2lfJBVir+EMnkun0okYgLw/MXpEUMndUa6gce9UTnHruOVUQNJMnbb
	WRkPO3FsBP+jGMXzR4Gc0nllW5HA2Xw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2V+awZx;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791814908;
	b=Fum0lrbI9S9rN8dz1VuFXu3rmwzQlQOLZnWiDvX+RAeYivMInEJAz0DtqYtAdYG/kRp3xg
	l7vfXxGqXc+ibmKkLHAS6+XjKIlIms4cQ0ZdfLJ+DTrOhnfLDVCI6r8CdjZjs6EyaEXyj3
	KRwQY02uYbjbHb+W2tLQDl5ZJzGLwRM=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso22926055e9.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:21:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814906; cv=none;
        d=google.com; s=arc-20260327;
        b=KDodM5gh/DDAkqX+MULdWZyMkjj9/iTgJ0DXol1zQOBQ9o8bNo0yREwvScYvWyKU+n
         8LbEAt5r3uM+b4NEDarIWnx08kbMwlvi10nMOHtPLRwGZ+JD0/ZZ6wK2JFXayzGDfPPv
         95BSFJWdjZ4ZgWxefubHUKmyFfWi4RgvLO52ea1X1Mpl5vqVYcPRnlWhtMvAfcjl8kE9
         p3IaoMHEyo3aNUFlyKX44EtwklVZb8Ogxtl+8gQsu2J57yTOSLNpLVWB+p2r+FivUUXl
         RF2l2m+t2s8NxsT+DLMcGPkEdSL06J86nwXvUsflY9NfcmbT0xgHaDVf2WGHzrb2iPCA
         EjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0WX2/gaEkBEYMG8ABuo+LESxvmJs+8+1r4PbbT/7xLQ=;
        fh=Z7CkVZzAlOPXzk++k4IG6CVSfTf83iyGZ4a3eEZr9ng=;
        b=rD27RT/HBx2wCabmE9f0qTuE8p+r2XGVrz+XS92aT2Hhnl9Ueq7w4gL5su1iZqvuX9
         cn7u5/XZYocdsuLBRpF/Ac84WL0yymaHKaTv3+LBNEirXyCYLybr4SXBtlEVbE4NSL/u
         E9/cBL4oHbOnI+vGRfpAYJMP2Bda7rGTX9qKieVYRSlViogjYG1j/yVBeop3CS0JYkDm
         2LTWLJ7KoNbSfe/qp4ICfm8wY/yKh4e5PYV2zgQ7THedoU/Kov9IRXUpcQk+/FsRyHZz
         qwVE3Hj5ytjiR6CnmXcV/PUqnDYNufx0F4LGXrtP+2VD7eAi+2uZYEhTakXFPWUhCXYL
         uHmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791814906; x=1792419706; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0WX2/gaEkBEYMG8ABuo+LESxvmJs+8+1r4PbbT/7xLQ=;
        b=K2V+awZx4f3VJql3rMr8ZcyXFtB4/ut3eEyjNAdBgeoHvKTVDBvyZpIer3sWRdgT4p
         Y7gLFyXUDS1IwP19HSfzRDbeOQx0hYn5KD1jR7+REag98ojg2IUK1iwv3Gs0zLqjobxX
         HBEm0rAgTvIjHkgW5U8KEfsqk6gn+rFXT9Z/Rl/sONNwiersv7lTC3S9Xq9VjNKUhZbO
         xl/Dmd9kKPNlyv7qma08LFx3dGLIzEa28Xayufm83T3h2odtOoKGodYceFvy3Ytr+WFa
         hhpU4bKUjtV0Qc9KNBljrlKwhlovQJdHvc2f207/idMeSD+cSZeYjnV3hj1duuSgJMEJ
         TIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814906; x=1792419706;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0WX2/gaEkBEYMG8ABuo+LESxvmJs+8+1r4PbbT/7xLQ=;
        b=CPcERarHYBbIGHSfzpgK/7C2fl+iVuH7+zCvoXuNu09fPMbwtnPHUahWNv7i1TRVKA
         FlmrU+Y/vbpGBli7HRI3zBlZX5AxoO8BOxL8gDHrl1JRBxgffNDcfe74F/ESMZjlUdju
         NCwiEWejtrBuF4HeZld61mSYJiUvcd1SG7gCB0yL1k7Vv1Iw8XntHVexKYPuxzh0QvEq
         lj1fFGWfDfw2AfVLOB+ARoUgEjmhg3NdURdsAE2acKVqcZD1Q7A2vJYDtrcHfgKc8p3c
         TpYQuNLwMR2exUmxkgZNCnRBhod5Ov/BagJwlEv4MF4GfbdUFodXfrkWHlRvftdSz8P1
         ugpg==
X-Forwarded-Encrypted: i=1; AKwUvBy15yx+D9z/zxv0YPsYButM8+zZU+dgQvDEmLRTZzoEaHfYgNDJPv3j8hv0PV6BdcDkRoxRAMbRSA==@kvack.org
X-Gm-Message-State: AFq9FYJuuGjv7sAXR8WzsInQNQOsldCTuJs3/5FUrp1DYYvLbfkyeIBx
	eWSs0Ce/lddq/i5JCM1298kUtnbL0ELxMEIAnIcN8u2hunni725OPGXGCkEtG4lOA5Udp38zrra
	op5s9G7b4TyJQE2b1yXi7kCuKLuu1K2U=
X-Gm-Gg: AYBFou2EtAjVj+GXxkh9HObawWZtvTTiIPLhF/oXUaBzxfrX7OG3Ax6jRXTse35HsJR
	sKD5WpWNcumF7qc1zlJrEEC5cYyfGTtj7bw7z6rqpv9cUD3AbmTNRgOKr2PlDWMqeqfH4JnDhIe
	i+r8AeCSq8KeliKA4ByC8f3fnuNqlcR4Dj3dXSH7b+k4Y756r0jiaTLeuJVvoojkTnMh1guHkUA
	YaX661qiX5qp+EP9jl2aDzel3XbWwoXTFItTwuxZYqkj/wfsdOcmhJGBOC5hAu/XVC7Qls6tx4g
	LJ24TNf9MO647YSO7VDH7n4GY/A9Hd4BbqWrozARcD6lKoYiQzHE/R4lvB83kYadPTVuB/qgZZp
	Xy5mLWz5HsmrdhWJI2ywlATqFlptSQvqCMVRFxRbIeC5+WDFlu7KW1XA2eKY3Esy2xufVEhs=
X-Received: by 2002:a05:600c:a404:b0:4a1:9945:98a7 with SMTP id
 5b1f17b1804b1-4a1994598ddmr77983055e9.0.1791814906228; Mon, 12 Oct 2026
 07:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
 <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
 <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com> <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 12 Oct 2026 07:21:34 -0700
X-Gm-Features: AclHuK_nMiNg-coFWoNQF0rahc9ryTutIxgwCK51zZOJ8W2ehwbLARYTQuobrow
Message-ID: <CAKEwX=NrMD1jpU=Kfh367mGArw_ju_8ku=Rh_v8TiLumx3+S3g@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0EC7214000B
X-Rspam-User: 
X-Stat-Signature: 7nayhkja3ybdx49a3bdf9p6rsty3nwrw
X-HE-Tag: 1791814907-741918
X-HE-Meta: U2FsdGVkX192tgcFcjW+l3UnmriPEHWwcsjVVEFSVqsqn7n/BncGmnuQqLClpOjLXebCPIqO9jquSFvbRQ4sb6lUuPdqSbQLgFVAZEPW1js5+/B7e6nX+eJvJuwvOw9EZR/icg2/6p+Gt3pzmt1RpC953bECc6oMO28rOOAHfkKXxKLjHX6ZeiZEYHMwB1BiQFJPzuyYAGRX50jxsilzzIlVTD3WFEhd1Dq8/rPpwJdZtRsUXEVah51Wu/1iDs/ot5qr1iqBuea191lHOx8cbUz6UEMi1BBOFEbfllh183EojDFJzza77hwluo1uPEoC69B5G4tuxP80G8ueTIqXYUm2UGFn1o+5UaeacpAw4x24yvXrlHaL0fE03d96AfFtzvdYkfSQfyFQ2N+CaCVqEj6Gq3sgMFAAycu+cLXrAT6grO9jTR6lOlAjs12AClGJ2GmjreplKyYSWcTjet0wdZ+d/jk9hJuICwm079Tty2qPQ0mnh5RX8P5uPh9SUy6a9bG7024FEr0sj5tEzaLu/GOAKQEo7wA1Y37+NePEGBHdIjE4O8ArhyjoShzlVtBmGUhkZoMjrmh/ib7kmIIk0m2cwC0B1tiRmwK+2xCKm/su0lpO3WAdnWsoo/Vdn8OeaEBy5DqWWp05yf8jGvtUydv8WCa/neo7J8wuIRtwW1YfRk34urGnLdKJ57uk9SXenzBwZ+awZHfFtoKLvKhNYuz1MmnEsI6Gb6Z3TGPu299irU9aKHHnjeLhy2UGI6Tzb2H8Ml67G343jcV0TbqlIFrn1Tr8COiqMy032+2bgydKyhJLFnXplhom66hz0YisQL7DgtA6Y2KDxNQrqu2qOlIbWLOrXrhRL/h8DTALD788Y7XWGYCH53qFLKgRR5grIgo7dQkelqrnn2Y9nuO6WJZqRs6t0aWSDjjkvlfaFT9oE8fYA5x/W1Qj9hxzeIqpDGRj6rYUrqlZ2Up8Un/
 tfSVbOJM
 gR4eMAO4Nv8trp/+4RD73QAVsZFOJLJ3vUQtAv2ClMz21Bu7Giv8A47WP7t02+NFW5exQlakOxN1bj39VfvEbAc2Ue+KNoQMI+Dxw4FDu5NUFgPebSjFw5+hUe1r2axRiZDqEWDOnjQyrtFcRIuVs6BVFH3cHMj2GA6KlGHHJ6isl+Xrci6AlAUYRjxQdgqnSrpF3gvB0vae2awoiZH57pVlPHXvr12zgfj1E8OiWY/t1R94gP/xsK+Pb5LCGT7rbLl9E1YuySEmk0J8Q6C8sSCrB3w8PPVHLPX/UsXIEAwv0yCNVsGRVCd+m/5rBjECIqR35Y4AOdNvv6ebaTMAi0C5537GukaudKqfdnIjiuIjnyEJ/UZ9m8rfOLDv4ffYmOjU+ifIYPpI+TjStyao5lVKBByTSkEDDD4OkycGmT4IwIRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 1:01=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
>
> Thanks! This seems to be a strong indication that setting
> `page-cluster =3D 0` can also resolve your problem, even without your
> patch. :-)

If every tenants use zswap, yes. But we have tenants with different
kinds of swap backend in the same host (some using compressed
synchronous swap backend, some async IO swap backend).

>
> But I'm still glad to see your auto-tuning patch!

I think we need some smarter readahead work, for sure. I'm just not
quite sure what it'd look like in the end, though.

Doing synchronous readahead work in page fault feels wrong. I chatted
very briefly with Kairui about this. Kairui is trying to come up with
smarter readahead heuristics, but I don't know - even if it's 100%
hitrate, we're concentrating work of multiple pagefaults into a single
pagefault. That sounds off to me?

Crazy idea time - what if instead of skipping readahead for
zswap/zram, we offload it to asynchronous worker (only synchronously
loading the target page)? That'll cancel out the latency issue at
least...?

>
> Best Regards
> Barry

