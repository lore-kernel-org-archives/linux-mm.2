Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3A8CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430F48E0001; Sat,  6 Sep 2025 02:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408596B0011; Sat,  6 Sep 2025 02:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345C38E0001; Sat,  6 Sep 2025 02:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22CB46B0010
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:30:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C432911A259
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:30:49 +0000 (UTC)
X-FDA: 83857852218.27.8A0E685
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id E70574000A
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:30:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VvrLPkx5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757140248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hgm+0YA0z6mbFwEems0niRCwk7XlVPMqnLGOikUXY8=;
	b=A9tVGdChI4dazeTWplzmiDnEqCVpsEuXdFj/DkAUX1AtLJd/5QUcPqXJoyAgOY09LIhd35
	ReqSKe8LCkLI4GGby0S/Q7kkuRfqPZH4dq1y/d46PygOwEGArkWzIdjiMOlQmpNWWBCrfK
	wSsvFbZpi6iJKUD9n0FN8ezF6cioRuY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VvrLPkx5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757140248; a=rsa-sha256;
	cv=none;
	b=KVBDYdTZ0RNsFhjtXS7vdTiGahc+4CcGjKALvRrx5cANPe/WzLRdSWoCL/BBklxL3NDSIN
	+3Au33D1z7hnqCCE2sMZGqoGZ51RvNqXUfqHqAdzdSno6rpIVH2drgeHBFnKKBhbs+nW2Q
	qisZJehjEEVLaqEAupTuEIfL3NCwguo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-62598fcf41aso182848a12.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 23:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757140246; x=1757745046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hgm+0YA0z6mbFwEems0niRCwk7XlVPMqnLGOikUXY8=;
        b=VvrLPkx5Vu0hGaU8eMa5IfpkLBX3xJb17fI+VXQFJAhM9dAhTWzvZpNnWNHEayAup/
         +Cg6oJrxfx5oPtiayNM1lY6vysdrWP+FmNGHuFaupUGNFpyzV9DDNFnQO661Is5bq5KH
         oTJHSXJgzVdhQQROXOTrZHfhVikjqEqp8Ktkh3ts3TqJ0GK8SbMrcRB1Cu7yGC4PEz+1
         8jBLDFaJ2c9b0SvICiBdoKGVP+N8g+Q9usACl1stM0po1JmgC24RVcWhvQp0DR3ouM95
         fXm55X+NLSQH2a19AluVXLWpY/JY5kDeRxcAhbO/XY5LNOA1ZnNDQUjbJaZjpaPijfa9
         t9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757140246; x=1757745046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9hgm+0YA0z6mbFwEems0niRCwk7XlVPMqnLGOikUXY8=;
        b=O5jzUh0o5W2IYOIBDAZE1xxh/Ui5eJgyOAnbspK0gWHJEENuAky0ipar7su+SSaq4E
         LxJjBHlz04sVuBUdNjBjmo7QpiE7LhZAEoLtoZ8UFGLwb6imHcLHcj7eOaVVnh1MDJPM
         iOLi2R+45Yh6q58AoiovwEZEZRIi1O333P4rrE6HjqOdpkvhVSX8RwShzr7DR9Ci2oih
         LKGuKs5L2kW60BPzJrXu1j81iS1nK7RvhW0va+YKfjoWbaOt1Um63uRtNVNvV30lnV+W
         xZTqayGU4hosyAfVH6vehuABU8HOw7empgVeQYA2GXVNKWXDj9PI9PYhaOJrywrEM0Dz
         3CRw==
X-Gm-Message-State: AOJu0YzxmfXh0WshPY3SBJxOvDzNG5HdnDnKo8RVqbrm5zH1mAUFErbA
	Ay3cFd6nouWxgYpO4hWEmtyeBcQcZdRYN9o27JW1UG/VpMsBRaBlXxCXhyB1CK3jSKwbc0deGTn
	ymS5fqAp4L4s6P2HJjDNjVPj9ziS2vj0=
X-Gm-Gg: ASbGncuf0FVzIYX6y8+mxvaylb5IaGlTIGTmssUmrtrfIqqm4TrOWPS8IUONqyMcCgI
	5QYbmR84J9d9A0XxTX7+OQb3QsUiR7xHcTefz6Z6E+KMLu9IajpsxFy7TakQsx00IhYE3iE4uUw
	vFA+8yl/xzr63VIb4D0BqhmaFGfzmCScpVKXRnREIB+MOMnDYL7noa/gCC/zQWzt2IlbV3DGytN
	h8kP+lznLU=
X-Google-Smtp-Source: AGHT+IHhUnwWV/6zRC6eqYsx73YcW7log9eFIO8h0gMt9YTfpgMzF0rm5rD3hP044v+LRbf+Ll4g7zZUUItZBNI7sHE=
X-Received: by 2002:a05:6402:34d3:b0:61c:7e11:109b with SMTP id
 4fb4d7f45d1cf-62373276269mr1131671a12.9.1757140246489; Fri, 05 Sep 2025
 23:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-4-ryncsn@gmail.com>
 <CAKEwX=Ndtbsy7UoGhwcd+by6bz2gt82o6EPOkiXbqNv=uPb8wg@mail.gmail.com>
In-Reply-To: <CAKEwX=Ndtbsy7UoGhwcd+by6bz2gt82o6EPOkiXbqNv=uPb8wg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 6 Sep 2025 14:30:09 +0800
X-Gm-Features: Ac12FXzOaVsHaMPwVPiClF7_Kcrhu6nsidLKJMyyXTFAAREjhqJM8WaHCJQ3Hps
Message-ID: <CAMgjq7BTVCc0yY8PunYZnCjnuybAEZMWvJ8+89Wb_EjXnuC78g@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E70574000A
X-Stat-Signature: 8u7cxqz9uqm31f8hkdk78iq7nkguwj57
X-Rspam-User: 
X-HE-Tag: 1757140247-803264
X-HE-Meta: U2FsdGVkX18x/EaCd0CamYCjf8OsE0zP7Upp/ZdPS2HtNSK+br21H1X/33fw8JKWXON6hwNl9IvgErwaEgsx5vMuTvMqLDjztL7MoX6e1yJ0SKZQ69lxcKP5V9je7kcdJ4QQ5Ae5yS7AhSsV24a3hEnzfGBhFhJl2o9UyXctEbv+sU5bPnOn6KP6kF0dw6HDbmrmAcr2LxkTC1e8m8RbM8IvuE4WELayesTOq87WPjGQ1qUTW1Uu9LvUGZdwPqcF0Gg+0NEZX+b637tZ26G0dlJMrvi84XM49lCF6RswtdxUQu9ra9WyHGKZeXwGYHZblBhqsfdeZq1tjniMPS/TmK4+FwuGGuSzpYMr8No0Zo/+8u/lc7F4z1O3RX4Ir6Oz+0VR+U+bCBmCNlyQAN88Pj1PpglAhpfxiRSO/JkrEUwksonjL8zlLyi6Rp1qFn/4ptZVjoWuvU51TMtLdQfwMnjhsMgQrm+ByH4IehNMbKIUyu6l9XxEALBETt0WI0GC0kvM0f6es1TmoanKzo4bF5PpX/NXsXE9m/ckX9iBbR1aWVCAjJAegUa0Fb2Q8djXgy2stHNHYlvb25IsXuT5gYIOuji3rTjXVzY1rGYMd4TGALqu5II5MeeC80R+FqrFZ5Hxq53V4FAduqFp9oCcRxWCZG5n34BEhlPlfyuDoc0V0O6BlzTk1tbnCztHul9eY1qvjf1pRo9ePUgJabh/S5VqdIKZ0TWAK/AdgNn01dz2PWYQAhw5M6zKvPM77TsvHQZKNzbmSYoVCCvRYswWthhHl6p/EsCHmBl5SBs+Pxr62Ysa0b4UpIdUNlON9iCyQs3ff+q2GQObFpQ0jaqi5vVabuf8kTihJlOoHXDvcXqiT/qjCjXAIViEzB/HbQYjqmC8vK22NZZ7idFm9AbK6lopuwJAkHRlmYARIcFE6SK+VuZPm4TIoHLrjqzciKmmptH9P0PKqjuRJk2KVCl
 7oR5TqFz
 0iK14OAp0f1OMD6UEeign8IAoXadjnuL3qn0YFSleNKpceZv4c5/P2V6qS3955u9gWdYUeNMlwifc+dNuBGBN0J35K9Ga+BhCkR5RS3fBaR6ZPeTa7hl7p36X11MkudsdCTf89S5i3ya+ORPBkj3Ghpuq+Ev3gn3+OxoN8fn8u6RnqLIDVZ/apve+IcnLcJqxUFe8laeMyhDRsNwAeet9dZXzAiuYPBy0vkPKjmU5MRU2Zupkjbaxaccnr4rYE8e+LmwpwRrvJQVfOptizTvUWBYpBD+ipqdw3umS8PtqPCQtBk3EMyDTTCH9AXbbGkUbXXks6by9TnQ27BPNZRTJrZvfyIAYnh6PcL+TobkpAYLwpTs8AV1d+GCvWRKXERySMda9u+QKSA5iX6w7OTKXJ54l1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 7:12=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The allocator will reclaim cached slots while scanning. Currently, it
> > will try again if the reclaim found a folio that is already removed fro=
m
> > the swap cache due to a race. But the following lookup will be using th=
e
> > wrong index. It won't cause any OOB issue since the swap cache index is
> > truncated upon lookup, but it may lead to reclaiming of an irrelevant
>
> I mean if there is a race, folio->swap could literally be anything
> right? Can the following happen: between the filemap_get_folio()
> lookup and the locking, the folio can have its swap slot freed up,
> then obtain a new swap slot, potentially from an entirely different
> swapfile (i.e different swp_type(folio->swap)).
>
> It is very unlikely, and in many setups you only have one swapfile. Still=
...

Yeah, but fortunately nothing under
the `again:` will touch the address_space, here so a random value only
causes a random lookup offset in a valid addresss_space, which is
completely fine.



>
> > folio.
> >
> > This should not cause a measurable issue, but we should fix it.
> >
> > Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache=
")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Yeah that's pretty nuanced lol. It is unlikely to cause any issue
> indeed - we're just occasionally swap-cache-reclaim some rando folio
> haha.
>
> Anyway, FWIW:
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Thanks.

