Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B873606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IISonUq6
Received: by kanga.kvack.org (Postfix)
	id 1DC816B07CD; Wed, 21 Oct 2026 17:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FF16B07CE; Wed, 21 Oct 2026 17:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E996B07CF; Wed, 21 Oct 2026 17:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB1156B07CD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:55:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B8C91A06C4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:55:25 +0000 (UTC)
X-FDA: 85347990210.26.6271DD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3919140002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:55:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IISonUq6;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792619723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbblKzcGrmO5Ko5Ulj3O9NpL7GMqStGr4Qlbbk//Src=;
	b=JAQ7oTGoaSlmo3QX8rBdCiGApBCWSTPCWolV+cJcFW/LRPeQBtiZaRV9VNeI9IjgNAGmZT
	QASX44y1C3TeLf6JglCW04/cOdlc1TagUxMalSik1O0BKcJKOJ6SLe8jYOqT+QiqN3CuAu
	ekXUcp+0E0H6b5lV5M3yKi2bWaMFUQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792619723;
	b=QaLiSs+g7KDlv3E7h+DSRX8oWrRoJWs0xi5vmj2DrLv8h2PkK3/BDPntoNuqDAdz45Brck
	/6S0gv5ammkT43F80t/893K7+ozKb4iqQJh8eJIz2f17Pw87+rFtCv85GLYjZwvEvuqEyD
	Fz8E0sjWwQZnTI9nJIevbuvSWdusFnw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IISonUq6;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F12EC60A8B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBE11F000CC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619722;
	bh=XbblKzcGrmO5Ko5Ulj3O9NpL7GMqStGr4Qlbbk//Src=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IISonUq6PPuILhouWjN3XrAW4TyXV7DF3zaY8rj73hwsu87lHUbm7/wCuPYWIUUGN
	 8ZftC/Ff2TTDpONhLu53ut7cLLqdIqZXBwzAdvxWQbq47jwrPovWDAE/Tt76Zq3T5R
	 kPm51HL6vRRV7QXn5fQxZSOcFr6oAhKA4BvHrs/R0/8n/liPhhLQ9FR4A3qg67Xchq
	 TZtOu2d0rvMJQZbiV/Zy+ZGvKvlQ2V4IWyIN4Yv+EJeVZ4vZuu+bCZeoooHC41Tdzt
	 WFWQNjX0tLWsmxdqi/N4N/E3qYkmaoctEzucIXURHvImXewhcFnRyuQABNJytfwpLt
	 uefPyP0cEaZZQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93efc0452b5so95570185a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:55:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwPlKTCWXkqdaP1IxBBtm22EyWfaeW78RIqApNDL0WGxDVaLjbOqLap3qS+/yQsYbl8cC4RH0sNOA==@kvack.org
X-Gm-Message-State: AFq9FYIdc6RNwwroiEubGEAzBRP4AHw6V5KubgPyp1/MPHYfLb/2A37Y
	TJop1HUXl+69EA4s4hBP3rhURlSQosdmzmEM/+led7+SyyYmi83B3nZy4RJF0oI8Byda2shH+gu
	PlfsR9DIWLWS+WrynsogDSa/UW5cUQkY=
X-Received: by 2002:a05:620a:4113:b0:93e:48fc:aa88 with SMTP id
 af79cd13be357-93f57f81db1mr689549385a.44.1792619721658; Wed, 21 Oct 2026
 14:55:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com>
 <7f4daafd-a3c5-4ccc-80bd-05a7ac09e4ab@linux.alibaba.com>
In-Reply-To: <7f4daafd-a3c5-4ccc-80bd-05a7ac09e4ab@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 22 Oct 2026 05:55:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wV8A5snz-XE+5ht931=07SvCs_k4xvUCE1yphKyQd8tw@mail.gmail.com>
X-Gm-Features: AclHuK-Lm3ETeKvlfdxyvGOhePGX8_fdCxCFPiSQfmBetlKnWoeOhvEVMJZjPbw
Message-ID: <CAGsJ_4wV8A5snz-XE+5ht931=07SvCs_k4xvUCE1yphKyQd8tw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3919140002
X-Stat-Signature: oai9xbpne74smqqdpsx1eaenkkg3dwqx
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792619723-506535
X-HE-Meta: U2FsdGVkX1+tdekWxH9CTwcOqNQACTmnHM83LwCQHhz694g7/jr27tPzGhCi1w9CpVHoESz3w6YScJ9WytvWvoIVmMFGENgBtLfmKSPXjbwKDipyQ6bcH8s7Ovhk+C/xlMBd2+NzgL/SdQNuRTQQMmL+A2ECaxHhgJNoAWUY3h4L75eHjVThih5x+0vIBtuvfg86yjEax8D5/q78tjzbkEBO1f/dAZnnh544MtSb6Odm0D76UKg/JCDlM8inWwCS99zV3tBsv94mIiLgrsp1ZlBHWShM7ffkyp9ccGoX2GkQHOlDNEOLC22YxEgDc+NgH0KO/Fmfi1CSk+U8EZQ2PvCvBORHB7Dl3wkDD4JWHgJwx4dEvEMgnNFB6ZFPfauuBHsDIWAcwlSSWrfVyGpi4ciOqjahvdu6z2QJYUXBJ6PpMjblls6hpnEpAJN0CsneN0Rizc32Q67JO2Yu9A4RTSIijasrO1+PcXzF0nrGgNVh6Azk2WO1KKH3SFf7TBm17Ai6u7Wn0njhFiOXUmOV0wpmZIFWCzFHM+LkvuqlW2lbirKYIB0vRpxXwZdwxHsfQCvUY8Nakj9Vz3MJYJbvWHTke2YI07LA2lPKJ6xIZnzcU2mrMmj0oAzSLZY2NfGuIkFp4+lFLQC+wutPQGN6Z7ALXgGta5smwsSIAQfpDKgwvRNFgGchiz7hMbFggrA0CBD+dIUeqiPELP9sNjrJjzm+dFHOeSEmpVM27BmoK8M39JoMsnLm5JHNbmmrGeQIxM9tI6EZShe1nLP4AQ3rZianV9c7D0RQn2B4ppdKImJXqhG+TDrKSub/Hl8Xc34SRXEJ4n4rNy0Agf3+XmYOWeWmwuniG8oYy11GN4ATu6vsBVsyy+xsFvEgUG0029H1LhlVCj5+gr1QnDaBlIUaCpCyJVpLrt8RPQxeDqczVij0Cd73TAVhewY4y7Mv3T9+PUYq8tMIRUdnSDgPngB
 CvUoePLc
 CCr4HAfNnAXosewOc6q90l5ibRqjgoVtINb9bXSoTYqlyxfI2BM4ZZedRWUxFf8q2LdRLg7mZwYO+EOhZVSDlmmdNx8p9C/po/CWc/9eIGDmtJvAth/J0ESmME/KX7+bbIMDCKugaiWKhG+qoXQpwExtnUJQcXj4cIEE7UNIMOv6xbbUW3iP14OOhZVYHIIBz4ZPrYq0KBKXHOR3HbGqKlSuVPPp4CagwGPsJ6X1i8G8zshBbvh4ZTm5MB+RzI6S+46StiYlnzuWmc1boMoHZiCJzjT0DLagXNf2Yz6RCPYSteC817l1t9qknKPTahYhpiz8UHXyiyT/dPcAe3C0wOVwQNBCgfJaCg8u7dlQ71Fdu5T43vEi9Yyzi7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 3:28=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
[...]

> >   static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_cont=
rol *sc)
> >   {
> >       unsigned long total;
> >       int swappiness =3D get_swappiness(lruvec, sc);
> >       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> > +     swappiness =3D get_scan_swappiness(lruvec, sc, swappiness);
> > +
> >       total =3D lruvec_evictable_size(lruvec, swappiness);
> >
> >       /* whether the size is big enough to be helpful */
> > @@ -5249,9 +5265,10 @@ static bool try_to_shrink_lruvec(struct lruvec *=
lruvec, struct scan_control *sc)
> >       bool need_rotate =3D false, should_age =3D false;
> >       long nr_batch, nr_to_scan;
> >       int swappiness =3D get_swappiness(lruvec, sc);
> > +     int scan_swappiness =3D get_scan_swappiness(lruvec, sc, swappines=
s);
>
> IMO, 'swappiness' and 'scan_swappiness' are really confusing. Why move
> this logic into get_swappiness()? In get_swappiness(), we already have
> some similar logic to adjust swappiness when there is no available swap
> space.
>

Yes. It is very confusing. we can't do that in get_swappiness() as otherwis=
e,
we will get cold/hot inversion due to GFP_NOIO. for a real swappiness=3D0,
we allow cold/hot inversion for anon, but for GFP_NOIO, this is not the
case.

static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
{
        ...
        /* For file type, skip the check if swappiness is anon only */
        if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
                goto done;

        /* For anon type, skip the check if swappiness is zero (file only) =
*/
        if (!type && !swappiness)
                goto done;
        ...
}

So the trick here is that Xiang is doing scans by tuned swappiness but does=
 age
by the original swappiness.

IMHO, this is confusing but this is a possible way to fix it before we
land something
like:
mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/commit/?h=
=3Dkairui_scanbalance_0.4

Best Regards
Barry

