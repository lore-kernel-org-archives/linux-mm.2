Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461FFC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 18:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3486B007B; Sat, 18 Jul 2026 14:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164336B0088; Sat, 18 Jul 2026 14:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0535D6B008A; Sat, 18 Jul 2026 14:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF5186B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:31:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84EE0C039F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 18:31:53 +0000 (UTC)
X-FDA: 85002741306.06.0BBA20A
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 98A1C20002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 18:31:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R/opuQ0j";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784399511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9i9uZE1qkS+6UhC86u/qnPvn/vndbhPmzzlidQmoOI=;
	b=kYp/uDweWQ7exmwSuSxS2fLs+1zIOh5GUXKUwHbPZghkSrCPn9Cd7Me5xtdK8h8PwQovg3
	ooeFnSGNrCeBLxFGVkVknD/TYb/SzSStzqQHvNcBkYAyzybC/EVPi5pMeIQWgtjwUSWS0J
	r4YBmSywWgorzFi2p0XEXPZq6dqJ9ds=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R/opuQ0j";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784399511;
	b=SLNcnIrC+Apu+m++v4qRXzZO06XiikO+sOIYkBvU0ugL7oH1VUDpKhCGWu4xFTpaXByUsF
	4EZbcxXIwkOhyaY/fF+QgwUNGd0Xo4EtJJjS+SkVHfL9RKpsjqDvroqqcmv8Rdo5+9KLoK
	8DkQhq28JC2Zb9J8WINVm+FLh/S70zc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1671ec8692so516813666b.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 11:31:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784399510; cv=none;
        d=google.com; s=arc-20260327;
        b=RZVENWxDUGsfqtULKINX6YFWncXnSKHzYHIhRX0wmD9wOBSvMQugzgiY6IR4cd64w/
         ZS4/jyUB389T9v7KeyHhPemIJDpaMHskdBMbQ81yBZiuUXd23FY1JgV2CJsjggJ4CdMc
         Hn/f3utgQEnGpnUYDy6+JVkKrCYBdOwnSVW9ALx3R5BvxDvlDqiaflhyZEt1etcWVKEH
         nt0PrnTJAFREx5wWmHfr7qjLL/+W9ACeGn413awjmf3KwUO96FjBNNvT/rw60uADOb6s
         AqvQu2I1vpkThcfivoWd3LBPa8DHh1jHoYLT2Tov84yqJqTy/u11f3rGQsHzf95jKQQW
         ktnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e9i9uZE1qkS+6UhC86u/qnPvn/vndbhPmzzlidQmoOI=;
        fh=nqq2lB0mDPpx9GPnekvbNXuZA2K0hOjA8LAJKRh3EtU=;
        b=gccQDfDZs5x9ZR3Ez5f3+iiYbs/f3UxPytAkWhvFKVDBH5b8OHacwSJVnFe5u4YBHy
         nGP5U4x+OOlpQ71pmkRMtosUlAP571so/woYflZh5NFnS/80OxhIrGHOt3IjcictEdN8
         EU+h3IZbIpG76WtC9zdawzuNr1Qgd9UO1wt0Ad4zt/QAUQ6ON4ul/PYGbMt8BmEa4sFh
         3QVFkIp9d7awDIP7Om614ovcnVqqHlhtlkwFlsJhi5z9md4rhZRVXPDJdLabF7Ri55I5
         6mZ5QpgyFOooQK09+gDAu0JKo/qRr3+lnoCT+IcQix9MFNo1JZM9AArPYUAJd7JtX1m+
         RalA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784399510; x=1785004310; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e9i9uZE1qkS+6UhC86u/qnPvn/vndbhPmzzlidQmoOI=;
        b=R/opuQ0j2R6mVtb0fS94/O+FltzEAn9U64gsmGtJzLrK1YVhsRVqi+hys5Sf84RI9A
         nyyFZcqlpMv/zEz9dzf39T4joFdAClbluQVsKl0gWd37OyjzG5ID3LRsEKAhL/aRx0g/
         ilt/TwiFXZx8Fb41jZp3oSXvpGQnkyQkZdSVICX4gIkOy9FwMwivRC0ZueX0I3sDwj+D
         TTKGyQ98uPLVyjkpH3o7geG/lOEXrQ5bC956Q3N6cfKJ1b229RND45Bbb0kW6dl5l9Nc
         k6khysGjmbs9shoHPyMRBUwayLoVs1MexQ1JGynzm7C4gzfMt+ON4FL5DTIw4Wn/LGru
         Fy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784399510; x=1785004310;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e9i9uZE1qkS+6UhC86u/qnPvn/vndbhPmzzlidQmoOI=;
        b=P7giKg/8ybuQMsnIVCui9Lji/wKOjmSFUvw6CeTXag8JflwpAQnp3gOOayxGI6J0vq
         ypDf84oeZEKGVcBgTIn8XYv9CMwc1jENbxfn2Ui+Ng/YCbl2hISW2WMEBUPYwk3cILL6
         jqRdaE2Efbc4TDOeRGrbVHPuyTN9pLghVQV/XBTWBRBZvmds/bbRx3lUYvmqbUd63Adf
         8yc9zpExEcoTKSiiBIXsUPJ8sgjrkkp7ar4TBzKSLBBAa7gzaLuw/IiwzbF/Mo72vPVa
         ljJMyLZ47jFoL0/ngYCsodrsJ4KdLkbCNNR4VUQSninRZ0CfTCoJbkxhOGShkc58PfH7
         MnFw==
X-Forwarded-Encrypted: i=1; AHgh+RpuymNbfekdSFyb27IGgSnVzt7hsDwNye0VqFzwSLfGtDBI1bvLcrGu8qyo7xtRvmunFIwT9QPJkQ==@kvack.org
X-Gm-Message-State: AOJu0Yzx+XChEmtAttaHtD308zJ+khTiI3nrlpL/2l8bj+F/O+EH14qM
	MwGTjpnsyOQYO82BfdKT3TTp2DQDzZbwjrM+q+Qzc7OUqjFASb+osPe98L+5Elr7kOfAlGDeOEw
	RVx3ByXLS4Midi61xTtWZXiJaKOxs268=
X-Gm-Gg: AfdE7ck5MHmRQd77CbuFivGP2uSpw9cY7stpiByHqVwWapRLliFPEwNDCRXtDHhRQ7S
	cs/TeHcIBQU4Hwdov4Gmzn3QKyKkfvl2Lp7ZDArSFTeP9D/xvGAYgVUGXXXb2ggAA2FHSS1c+zp
	vIC9wHOEIm1Gvf1S3u5xzJR2cyUhntJjsNcWJvD0Aexpw2tBfY5daDn75e34HlUHg6iPfgiEoZE
	hE92n5o3+YVjZwxKvOlg3DJbH7cBiX2JDM307i/Vcujb3DWgJiWKK7e8EHPAMR4SAV5esPv9wr1
	pfJjHBcKiZ8jAQf8zlg=
X-Received: by 2002:a17:906:f5a1:b0:c16:1227:e3d8 with SMTP id
 a640c23a62f3a-c16b46c4b33mr383446166b.13.1784399509893; Sat, 18 Jul 2026
 11:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com> <b9ef058305d1b5d6b811114830d17dd05980cef2.1784268206.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <b9ef058305d1b5d6b811114830d17dd05980cef2.1784268206.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 19 Jul 2026 02:31:13 +0800
X-Gm-Features: AUfX_mytKhDH9njF7QrqmrtJtAD552UzWoGbBe3CRShys2dNXvdYAE8eKkUyexE
Message-ID: <CAMgjq7DdNrGXkKsM1KeLSf7AK9O6Cc-hTgguzxPu4A0yqHz3Cw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: vmscan: convert folio_referenced() to use vma_flags_t
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98A1C20002
X-Stat-Signature: 3871x5xhi7tcs7rb7gj8puq1683s7ybp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784399511-146809
X-HE-Meta: U2FsdGVkX19HRbbEqwZaIzEr4jz+FURm70QH2vCBowBa3pKXb+txG8JVihzdG+09Aox4vDsrDjgYjsJ+afOSPCG7w+ANJW+ZVgAl6hN7nMHGk8YSBq1bBzbNqZ6arb5/uX5KeOSyQCThXDhymGawBzA5SLNk4lHPjGQ1oPikbm1HQCncdE1KGTN0146mBCRbVyE/MJWsRUZMzGpJf6/s0oiKV1eMRypEp4BYa4qPBxidKI1Oeim/Znb8A6WZo4mSiIa+NuETIlZC+lRPLvrrKcSQ2NRllS2Fn83bymBT2Vdbjdv+w2uz+ik26VRBpsOmZyYKO3LcO0/srG6gv8Q6bb8khkepQeJOvHqHukxRJYO1FF7O+JMwlCP70q8y8tznyH39FlXzL+x/t/xJr7mQ1OgI9YxHu+/29T0wn5VkmGw8CgbCIGU5bHsbRPw8Vt29z0U6etVmaGjBVmOsDC3IYGvQvwUm5QOT1Qm2Fk2izpcxHWZvLcGyz0YHu1H7G4lj99nsD345E/+KRBoDrsF8JxGNDSFASADtjUi86KEv+LylpMpkO2ot23JfLGUzpZjmUX/P4EQJDIi0NE1/25kTv+gv8Zm/oQNspX78wOjvFmIvNKDEZF2OhAZvNERSXBk52UgenU9qltlQ7tKuteP3VpotCyHqZ8KxR8+ll0l9436MrmaeZe2pPxN/xfKYPwMxNqxKfRI6y0LUFpd93CiXfrdTNeb0rez0FEQYX3/NlFu+4Pc+EAGkvX7QALs52LUZ15h3WmfsMjypyv0jzOabiXyVfdPpdg3vV/GY/3Nw3jQuzOMPQyBrzWgMohoSe51lB9+pnUMxBuZ4R0G+bJiTaWiJeh79bnjkFLZKWirmTdT3gT6ajdHnqDYOIWAuHV61P8QiJMZzx1bODu9404azzRxT7qJ+Zabkf0JiVIaIYWAD76iMHDpjBjK7s2kOpp+wkD7QI9oGXl0PkfKUX+2
 6oFJrs3Z
 7n/s+xKODDDu6fj8u6EwZeZVLe6fdTUf1cBZ0+F9GTYI3DYgVWX447jwqZ3Wgx3k4maIJfl0k6RYtW9JFes6BxLC4Ba2kroiD54IkvIrbLTmP9z4aNvtLX8hyiTt5f1/JMBA9RCr9KXD5sBD10EY1A1wMSuesqFcDZvpI1jQJQZzAaMiw3kgqZXSnNDDbrCuTAQWYAoCA/6bz4Zpp9DJmnrPu6k4wAmgVbgLF7yIzm0iUbXf8LjTRWN6kIMygJcQuta3iMEq7j4bd4+KpjS+zgqdwadBRdsk9QvP9yaILM1IC5Fch3hVwMUcI+b8nzNpbztk3LrFMW8t7GxnOHn5YJff2nC0a2jP8hqY2pVXPCxsKJbq0HVh6RGVeqif1pQZpwMbqb81Y9/Zt5rMQyc/fRRDqTtSJJDGluOZ+pdIWy0pDlN8NphJWfLcmhfYTOEZEXHWcIN34C9GcMbA1BmWmVPBchYN3v7XTZrNnGCj3hiLSJyhw/KeNU26/MQOQ7q5a19pLcnpzm4gATLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:11=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Replace use of the legacy vm_flags_t flags with vma_flags_t values for
> folio_referenced() and related logic. This is also a preparation for the
> following changes.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/rmap.h |  7 +++----
>  mm/rmap.c            | 19 +++++++++++--------
>  mm/vmscan.c          | 14 +++++++-------
>  3 files changed, 21 insertions(+), 19 deletions(-)
>

Reviewed-by: Kairui Song <kasong@tencent.com>

