Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E9BC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 13:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888486B009D; Sat, 18 Jul 2026 09:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FE46B009E; Sat, 18 Jul 2026 09:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775106B009F; Sat, 18 Jul 2026 09:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4C26B009D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:34:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9E8DC0443
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:34:31 +0000 (UTC)
X-FDA: 85001991942.12.677CA5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B604D120010
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:34:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4Nw+Bsf;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784381669;
	b=Xh4aNtOyD4PG41JjSkqQyTjyTaqLIxnpE6n7n6oSJPuZzCJxbrJvvwFIAQY1Fdi+h2OvWQ
	X7TJAgLz7HmBfy649joHJ4Wwb4m6t4+mdAWMfIwK5wCnoUJV+chUiNwx3JrY81XW98rIo8
	L5urCl8geIrE77ItgdbirIwcGlaxUNE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4Nw+Bsf;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784381669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jY4G0Ahue1ntnoL/E+gWWccSs7HGa21qxJSulrBCgk=;
	b=sz+xP3AnB4f9gC3YunqgAnYyVU40+yDAVfAM4XwPq2FHPD10D+3FTMCJv8sLFIsH65msnx
	/WsrVqz7UAeBVwpWcdp452EKk1vLjvvvOrixFeLEVOvdWPV1aLtFzVob6bvZnU2K2+1Aiw
	4/eRqMlOt5p0bt4kaOFHmwCghP3q5/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E401C43EAD
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18461F00ACA
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784381668;
	bh=8jY4G0Ahue1ntnoL/E+gWWccSs7HGa21qxJSulrBCgk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B4Nw+BsfzKJrBtkjYk3lmuFGWjGVBIBHGqTecJsdmW7VW6ai+YVgIt6QyqpKZQLHF
	 AByA49znwvr7mJiAbWqpVG7hlng19rTW7oRVPdWGTJUpG5CJ5HB/GPOVY+V0OrA4un
	 3D3luNiU9nO/CssNImEl2m1n48SCOV85NZ/HALqYd6da5urpKtqll/CPs1ysNp+v6T
	 dxv902JmdbCJ8fSuHn13qiFUw5e1/bVMeHjLpKCTg4qNNJ3GPyPmrHbuk2QHMQqJ/s
	 CDnErz7MWlBj7y+B4Au0dSRGpgTUsGvspKyFjTuYCWtF02rJuDNtQluW3OZLZo5for
	 +xhKCpdiyds6w==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e533aacf2so305042485a.2
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoqZbUaVyNukeKSYCwWqusHxc2VDTCb9eMl6fMckvoQ7ht3R4b/Baz3J0OKPLx+w2L9FXyYrNvWVQ==@kvack.org
X-Gm-Message-State: AOJu0YwSBou2ybnuy4yIYbN2kDZeZjtA+wd8/gmwZ5W8L5hFqX6F0tlR
	Y4Yq1trTdW0LHzR0sw80E4WiWaPf+InETr/dORhbMd9d32d+/nCHPDKMYFXb6IL3ad4jlVGAKLB
	eF0Jy3AS5Hr2+S0s8l9fPGWXnGdeHzig=
X-Received: by 2002:a05:620a:4045:b0:92e:c116:bf01 with SMTP id
 af79cd13be357-930b432cf30mr673900785a.94.1784381668087; Sat, 18 Jul 2026
 06:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-2-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Jul 2026 21:34:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
X-Gm-Features: AUfX_my5tHBjfvDkVN5ZhsZWqM30OA3hOcQhNH9Fi_Y1IzFfwLVSH0Kg-u_41EE
Message-ID: <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B604D120010
X-Stat-Signature: rtk5bip8afb9dg6b1setthja59b8s36g
X-HE-Tag: 1784381669-124995
X-HE-Meta: U2FsdGVkX1/1Vo9xkgKvbfJ3PezZ56fwhfOuaw4v1v19lH+bqYITwUzUdyjcWofAqqQ4rJBWW7VIwAaT4tnG89iVsUQ5I4mNXDxujYtUOFV9mHSYhaO0UUZsXPJVsi2H7QIiUfhhkJWoSTVF7D+X2i3mZKSrAl+sGnUgBuBc0QpCImwfvLa+jqj2wJ3Qs5PuyJ/9BtpOoqiMKfcVQytL7LkdcQCvDwwxl2X016YmZ0U0YwMl4AnjjEYFoeadDSUF+OzIkFT6SRwUyqYQRgmSvLd2qxEPknmj97uP5DEBKJLYPml6hUb789ymAni3+Vn+KhyZjFpCaZP36sEFSCd0onheKtZlIyCF3ik/5aThe9hfNrIy3iB10l9tNLWSg+myO1mn23hwTE/nV7gTaPu0rriqA66gLSJDDGK/9LBFTQpJ2j72M92uB81U+WnETvpyRCbDqekkqeOFzr9lVzSicPGBQYWJaL00OjZYLjF6V5m6lj4c9/ayEiTzmbZSTnAWAk3yszcJaJk2k8a110oio1xKv0fSkc5mDDIO5piM3jAoG6CwPzmHmZXK6G1K3pXqORYicJnUmk9Dr1EIEz1icDpdzeRJ3eKxVexveUFJxRM2Ix7dZJAHM7MeKRd3kz0WVNRisgGhLGjBW+atBF5QRCD3cXtetN1q/89UBcAZjbwAcNn4L3XmwK8SBNudLo43rr0TbTUdNgnkKG/WwZapKmmrm2Cuvb9QKNYvW8c47yvhCssQZBY2kL8xlgg1lHnBGQ32yevboOpjctyKmvOWhG3+lsZMGcFR2jrr4/Li59iLVcaAulIJTLiKZF1HZAODWg3nssglJcXtfMH7M/EP8JB8DQ6CTVd8v1fiE4/mcW3FsxWBlPV3paAKEwW4919UBhlOkmq1X+MfXDyFhT+Ztd4aIWmbklXaYYpoPSmaqCOzT7hjKkmwDQfg3IbcrDbPQYx8XxFgQMUWHoDJPH2
 6Rxcu/Cb
 Qp3zFz/BO//sQReuP/cEdqzn5M0XZWhWyzwX/fWDWXzrmQY2yvlhXY3rnXzjZYk2XQa1N6/ZEsSGz66YjfrgU0BXUbCZLNWBj2cdXAKxA84/q8jcVcTENq4shlAWKffm7pZS+YvcnbrPplx5AcUirzFNs33JwWM1naJeWKdB64BBqAxQ0+5ji6xwJSGklxbulzGCFONWYgH9Sj0IIN56eHQzjtyeH1Hvc+8WTqmnkUw/IpWSfZX5cp3MRezJJYz8QVLk7+zTZajt15k27yfIZwoLkMgu6X6KdpXue3nJDz8Dmk49+gy2nm61MqDF0N5DDBWvGqvXIXsn+u3Vq7GKyIkLk9iB5B4RKAjwDfeSJ3Vra92C/T/koH141JGmAijUUNVxA0Iop7FxPnEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 5:54=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> As Qi mentioned [1], when swappiness=3Dmax (SWAPPINESS_ANON_ONLY) is set,
> the reclaim logic is expected to reclaim anonymous pages exclusively.
> However, due to the current ordering of checks in get_scan_count(),
> file pages may still be evicted if can_reclaim_anon_pages() returns
> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
>
> Reproducer in a cgroup holding 64M of file cache, with no swap configured=
:
>
>   Before (file cache is wrongly evicted):
>     # cat memory.stat
>     anon 196608
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=3Dmax" > memory.reclaim
>     # cat memory.stat
>     anon 208896
>     file 4096                 <- page cache evicted
>     pgsteal_proactive 16400
>     pgscan_proactive 16400
>
>   After (file cache is left intact):
>     # cat memory.stat
>     anon 200704
>     file 67178496
>     pgscan_proactive 0
>     # echo "64M swappiness=3Dmax" > memory.reclaim
>     -bash: echo: write error: Resource temporarily unavailable
>     # cat memory.stat
>     anon 208896
>     file 67178496             <- page cache untouched
>     pgsteal_proactive 0
>     pgscan_proactive 0
>
> Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> anonymous pages are reclaimable, before falling back to file reclaim.
>
> [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@=
linux.dev/
>
> Fixes: 68a1436bde00 ("mm: add swappiness=3Dmax arg to memory.reclaim for =
only anon reclaim")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/vmscan.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..d6b383d96a0c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruvec, =
struct scan_control *sc,
>         enum scan_balance scan_balance;
>         enum lru_list lru;
>
> +       /* Proactive reclaim initiated by userspace for anonymous memory =
only */
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> +               WARN_ON_ONCE(!sc->proactive);

I feel it's a bit odd that the WARN_ON_ONCE() is placed here. Maybe
adding a short comment would make the intent clearer. For example:
"SWAPPINESS_ANON_ONLY is only allowed for proactive reclaim."

I'm not sure whether it would be better to issue this warning earlier,
for example in try_to_free_mem_cgroup_pages(). That said, I don't
feel strongly about this.

