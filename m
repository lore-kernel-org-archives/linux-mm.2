Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA2CC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9036B0095; Wed, 16 Sep 2026 02:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9036B00AE; Wed, 16 Sep 2026 02:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00A46B00AF; Wed, 16 Sep 2026 02:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C24856B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:51:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98EEFA5C5E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:51:07 +0000 (UTC)
X-FDA: 85218703374.01.56727EA
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78DD918000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:51:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRekhLHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n5rbrY/01roG/1TlDqdvk5Po6lB1Q7LrGFLCfNfZQw=;
	b=vCEU1DXs+czCGtVxEjQ58i0yeKn4F19vs/GTefpqHjHJtMB5r0dLLgVVSMh5dLyVUEz+8d
	IW8MDWgajzegMaC5UKDbbp9zlDzQvVY4vVccZ2Hzo6yEC7q3rmEBNqvVVfXNs/6DvbyEje
	dWmU86KhMjhZh3hhgWiMoC4oQDSIA4Y=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789541465;
	b=s3UkxOe/ZyRQe1UARrkqZS33y938pdExuuoZImgkjJwhUFxrGKGHYv5G7MimE0YD86vAuZ
	Swga+Mi7hIYf68Zzd62GvfJcHpLH0vSukQbYxRZKC4Kb8wAMz1VhY8uILkNAqmLbn/JssC
	0XzWiPVhk9MNo1xm4YSts4u43C7m1Vw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRekhLHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so2881835e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789541464; cv=none;
        d=google.com; s=arc-20260327;
        b=Xn0RupmutlRG7gwi3mS5kogkoZrlG3c539fOVqM3yhBsq/J6zs+0qbPT3UUm0SS29E
         BP4WNobisQUf4mex8QeTO6aK51ZKKahUTGpp1ETCOKbSJFIZkz5NpmwdlgTkuZ/5/9QS
         UaiUzgn9+RzAvFvx7/btgWMHTAg2XPO/8UbNbZ8GGx/FOk/DpKY2ydmICSzmHxrwQfKc
         OgbSdihEfMkvgEJD5RuuBgdR+KoCTniQfpaZ746tPq34WAK2u66Bgbzxg6rAnD+KLqIS
         QKR7WhsbtXgMIbtfOiu6trkj1IfvfhoQ0esIJJNEJ624lfqFLVNb5aZaZ4rYsxefwtov
         c0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6n5rbrY/01roG/1TlDqdvk5Po6lB1Q7LrGFLCfNfZQw=;
        fh=UdiNr0oAlFf9TFLJF3c9x5w8MiKHlYhRcOGHULlbdoI=;
        b=sxm7QpDlh2QopuuXdThTQm9/9yqq2AjE4AWbcTAhhiCux222nQGgyMnaysGBJRGWga
         t19+bwAPsb2jfzequSMPc2BXvOILY04C8gBL2zu2xNAwd0A33Ktwv+/aZCDr3m5qrwRi
         HEou6muTNtyBriZ71u0bkNP3zxcIFWelp1+6RjreF4aKVUdzVSh3IWW6f+V0PSB+BWG4
         /lAMCIOUdzMvA+kfv7FlSmE7uViL9uLUPyfE1rd5VlSS53tqV4HxRqnlpnCH/O/9SqFv
         emp+RKcTpNxWxlYi40BGnJV4XqZ39pikRCBY4MKHd3FA0QvfxRDD4XGe65UcSbtmY17u
         C52A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789541464; x=1790146264; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6n5rbrY/01roG/1TlDqdvk5Po6lB1Q7LrGFLCfNfZQw=;
        b=RRekhLHFVuLdhZut/0OzXyf/7RfE0d3rOJcwvHOpON3Go6aA6BxLZKxAUS+YdSVcSY
         X7Llzl3q07AedzXm7WigUPAfFC7/26u+WEaahtsLJNxA3Ds781WKF3NBF2O1gei/AHnS
         USVjELsdi10XgruJyXGh3UGZmtAB448WYr1aycrPPvdde/6Q7MGoUBK2LpNPYXKGUAC0
         ACEEjwThXsXL8qNYrVMxC/pF9h4Kl0jidBFHdQyIAbcTdV66ZKAGZ0U2WBiT8634yX4W
         vclApp1zQFKKAHEJG97VzSvksrfJ+jsPP56oRcsL6cbeooZlKgIXHZWVYKRoEWu67oDb
         Gxcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541464; x=1790146264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6n5rbrY/01roG/1TlDqdvk5Po6lB1Q7LrGFLCfNfZQw=;
        b=kpW424OaY8rk+REQEtL8XbA7Ybr3tJOiivo5fq9kzzYAu+sE6fbzrM6y97eUBFO+R9
         ilw6BdPdkk+qI+gcqpStCKuj4hMTZ9EDJNzcI2JG23Ikl2PCbU6cpibFujksjbKCFHHp
         T7uuBjGkVR4+qt2GrScHcnq2K7CDqJcmvOOMVbJVHLRuY1AqJfHLdYlw04AXUOSjBeHw
         ui8pJgVetKdhZUmBATD3M8+vnJcNUrCe7q9FSP2BcdVca/k1LVblStVCtkOlirhqE9ha
         +Q8jNFEGTKrTofW5o1V/o8GJNfu92lbkIFndMmv5r8I9BUDTTzPbNUxiWSTfnWdJMg/s
         ZvmA==
X-Forwarded-Encrypted: i=1; AKwUvBzLfxYs8VE3qkJ9/SZEGcjq7Q6sCyMjlRmxfutDtGY0VNn0SfZaPL5WkqJ4aqq5eL7c+QHrRpoujA==@kvack.org
X-Gm-Message-State: AFuF++nNldjEbu6CTyQW0tlOhVNSrwvGINyGKnlrj95CvPrRYoZxjuIo
	E3iwDqlO7j1yrk6HJlvzolNfMZVUC9Gx5lxRyN2ee489P9oQEXBYo31+UTYsSLbRPMOzDz0WEdC
	3Qe+CD0r78t0R/OjsfU3tXLjPl0TOW0E=
X-Gm-Gg: AYBFou2ysfaJrLIUfcbc20fiNM2YD4NGLT+evotH1TG6KIh4ZPzIqTZqi2RS1VRzMCt
	d+hg33MPi9fYpnWkqFEm1ob0DkTeWvpMPKF5tfY5a4PAqI6byAPzIrLcubqwWNvfv+qdPH1n1jU
	1P6rd1nTZAy3zDLMGmaCIYICDziItL76B4A641bng20O/PGmuiV+zoYS1aN9r00qO8xB8ytuOjv
	pqEs6rbNHgW8jFS6OI2Jm0UyZ7HryTjG2NFc7qmDmuJYChQuZ72AGarHXSnfVYFgBBa8vFIjrSR
	KrCctSGB5vc9WfTlsHjwkOIoFEd8Zsm8Qj1XnRMKbgWwiKKsgYnFjLkYsfQ7o3gF6IwzW1T1cyb
	dsugZ+o0Y+tO9Zw==
X-Received: by 2002:a05:600c:4505:b0:49c:fc6e:a3e1 with SMTP id
 5b1f17b1804b1-49eb7346118mr12408175e9.32.1789541463728; Tue, 15 Sep 2026
 23:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260916041409.106926-1-sj@kernel.org>
In-Reply-To: <20260916041409.106926-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 16 Sep 2026 14:50:52 +0800
X-Gm-Features: AcwNN1VhHl9-ceP5c4iG_sWBNprIthUHetKIW-a6tK-i7YoEH8Zpfkg8hmrI5R0
Message-ID: <CAN_Opa-Cb2TG0C1bZix7LqFk_LH-0qgNgkj8GU4kUE2FwtA7mQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/damon/core: don't skip damos_adjust_quota()
 while esz is not zero
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 78DD918000B
X-Stat-Signature: yqhdmasdjpsqdjesyfsrsf3ey77q9eiy
X-HE-Tag: 1789541465-170287
X-HE-Meta: U2FsdGVkX19Tg4y2vAdQlSqGY2UXJHL5kCGAuZR8uRL0bQ4PpidSGK52dsAQVkjzfSOfpEaIp0bhU5Rw6phbu3EqxTK0CIXHltJIXoUGiG0bHN83P0fb1D55AL38vLz3Hc+2SUjoRB8UlMYju6iwvVXdm9g0++n+aHgbLgi6esd4G1RgypgyJ91HGh361KV0EfuBW2zJ38PSrbNSuEcb9YTBkW7Obu+PPVPN0otGZ7QmkBqQk8lljWGtYK5PP3YARUM2dkBqnE5XBwv/uP2n6toXihDfzOak4Hk6/cQme9ftdH7VG0+U5t8o+MgNOiwh9TOdfKMHtXoEdTDgbsbfYhJhl4YpLyKKr5/7jk/4ZcipVaxEkU7fGucM14rRblKJ8P/914VewWIZQGyhIQsOzExu5i0zX+s46m7uh3K3QAfj8tLDINUedfGjbMKitZ5q8yTjiCmDGVgfIVm7PWIZxvzS8GejuKNA45lTnSsvTl059GzAS8BSTVYMXjOLAMQUNwpAuYrzBDnB8ZKWMMlUxdeJLK6czUETCwv2PL9FkODUqNJS2e6Ey4GLqJxhLRFZzjJGifNzkxHn/yJirVOCLZLeN1gFd0jId29SrZKnHyujeW0cf6X7L+cxwMuRYvYeiIAgBVi1bncHdDqw6+RdeV6PowDcoZ2VdFdFLMn1v30ncOs1ZYMqNDqtBhQz6bXMoxDBFFEB2Eb01WNnhhAF8IJ8ov7ysfSALHDPn5TTdkwxJJ/ldAAbu+NrxJeE2Aur6UvQar0CF4IbC8JfWskKNstK+JYDcxcBSNk5yWTAeU+SlfTXFdI4XqmRijUgn1luXvOZ3C3mVfMlON2XwVnfwhZmXRkLMbg38zpd+fhwCta175nOctellDI01SnRp8zceRNdk5febjpAR17/FMAl6n9YkEum14kuXGyQHQbV6l2QSKIHoysHz+Lh0YSit/O4k3jizSHrG8j26pyBOtn
 HAwnjR/F
 y5TQhld5CbpBiMUQ3OjKZhHjmFMY69WQeWSq9Bi7dTo8S6zkqu3vZWap6WTZUs/uQKEB8sA028I1wtpejuGv8pB2Hn1o7rYrlSWi6BDvoYd+D7CiAYbkv3jqlxSHjeCcRQXBhJQu8S8O4epfVb7CGuDnjf8/t3I6Vm4AWSdj/v6R9HPj45ivqCWM+IP1eL8BGjBO1cWRSV0V0hS7KK14F431Kkh+rvm3+m98oJ7ApZ1jDHKFL1i6XJcrpYqNAXrqGqyBLlxLmK6Js24scVUwTMY3nMlskZMSr+OiPEgYX5KlkxeHlHzpxTLnpR7XjkdMYeDD/43B8Q2S7OnVpC3IDc+3sQ+cxFmQnP8nufwZYU3CgrxX8zqrJcAH56A2382URbzCqvcjevH453w1ikPZEBG39AEpGTd+/02Tl6HEouuqMAULjOR05D0bV5JNdT+asoW3xhrCcwinB47i0NzMh3xN3mJc4x8RFQYQpuE0Y86w+Er2UAJv2+ymVKH16UoVg/K0kagsHnatQiMtE259f1y0wIIaZsvRuA9lFSNubVdOfvzHwKkS/dm/62G28P3jcsgjz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:14=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> DAMOS could unexpectedly stop working when a user disables quota using
> the online parameters commit feature.  Fix it by correcting a wrong
> quota unset check in damos_adjust_quota().
>
> DAMON users could disable all quotas by unsetting time and size quotas,
> and removing all quota goals.  The intention of disabling quotas would
> be making DAMOS run at full speed.  When such quota disabled setup is
> detected, damos_adjust_quota() skips all its work.  The skipped works
> include effective size quota (damos_quota->esz) updates and charged
> quota amount (damos_quota->charged_sz) resets.  The intention is to
> avoid doing unnecessary work when quotas are disabled.
>
> However, users could do the setup while effective size quota is
> non-zero, by doing the disabling with the online DAMON parameters commit
> feature.  In this case, because the effective size quota exists, DAMOS
> will keep working with the quota until it is fully charged.  After the
> effective quota is fully charged, the charged quota amount
> (damos_quota->charged_sz) cannot be reset because damos_adjust_quota()
> skips it.  Then, DAMOS stops working until the quota is newly set or
> DAMON is entirely restarted.
>
> The problem happens because damos_adjust_quota() assumes the user setup
> for disabling quota immediately disabled it.  In reality, the quota is
> still working until the effective size quota is also updated to zero.
> Other logic for catching that uses damos_quota_is_set(), which
> understands the fact and therefore checks the effective size quota in
> addition to the user setup.  Fix the issue by using damos_quota_is_set()
> in damos_adjust_quota() to determine if its works should be skipped.
>
> The user impact is a non-deterministic and unexpected DAMOS stop
> behavior.  That is, users would disable quotas using the online
> parameters commit feature, expecting DAMOS will run at full speed.
> However, depending on the timing, the setup can be updated while the
> effective size quota is non-zero.  Due to the above mentioned internal
> mechanism, DAMOS stops working instead of running at full speed.  It is
> unexpected behavior.  It is also non-deterministic because sometimes the
> setup is done when the effective size quota is zero, depending on the
> timing.  It doesn't cause critical issues like crashes or leaks.  Users
> can simply set a reasonable quota again, or restart DAMON.  But
> definitely it is an unexpected and non-deterministic behavior that makes
> it difficult to reliably use.  Also investigating the root cause of the
> behavior would be quite difficult.
>
> Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
> Cc: <stable@vger.kernel.org> # 5.19.x
> Cc: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Thanks, SJ. The commit message captures the full lifecycle precisely.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

> ---
> Changes from RFC
> - RFC: https://lore.kernel.org/20260912200814.145612-5-sj@kernel.org
> - Split out from the cleanup series for taking hotfix path.
> - Describe the real issue.
>
>  mm/damon/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index e0414d2adcb41..89390897a0d8e 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3330,7 +3330,7 @@ static void damos_adjust_quota(struct damon_ctx *c,=
 struct damos *s)
>         unsigned long cumulated_sz, cached_esz;
>         unsigned int score, max_score =3D 0;
>
> -       if (!quota->ms && !quota->sz && list_empty(&quota->goals))
> +       if (!damos_quota_is_set(quota))
>                 return;
>
>         /* First charge window */
>
> base-commit: 191c4a84eef1db85cc7e1a853761e8ce8683afd4
> --
> 2.47.3

