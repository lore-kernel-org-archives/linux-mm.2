Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B54D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AFA6B002E; Wed, 26 Nov 2025 13:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902AD6B002F; Wed, 26 Nov 2025 13:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818606B00A6; Wed, 26 Nov 2025 13:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0006B002E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:23:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FC5412C8A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:23:46 +0000 (UTC)
X-FDA: 84153581652.12.3BF97CC
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1D98FC0017
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:23:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac+mC9Yk;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764181424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRuIsnJjgKoS1qB9z1CzLqIUDAakowpq0VO9vQCJiLo=;
	b=8Rhl1roGKBp5sRIim2g5T01n7tzid/sZUBGI0p9wj1oe9snHoWrVb7xvYHx2/VwovvtRLH
	MK2dUTN10YmQYaLtWpcNJPdAbpQmoTJ6pdnaSpOnv5eZswvkmW1NVgd5Uk1TEMb9+KIC9G
	7MPWw5ODWY45yIlH72Z3p3f3KZCzN54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764181424; a=rsa-sha256;
	cv=none;
	b=2bw16Xk3B2DgHScZk+J5Fy7VtgBOHPLv3nuzTDwyB9u9KgMyJJjyLhk/n04/Ps+CMXyahf
	cKsarppAD09+o4k0Slujy9wBAEW5phBUb+4ndTKsY/oaQq1d1h17sqn1Ebuitkdgb7L9pd
	eYIceawoJEivwN/+0zQjGyaTpLrLcLg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac+mC9Yk;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso254206a12.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764181422; x=1764786222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRuIsnJjgKoS1qB9z1CzLqIUDAakowpq0VO9vQCJiLo=;
        b=Ac+mC9YkEezPwJXcO1Czagq2ZmbSu3xSazQMguFviQMXxNYlN6qD0f5/W7QcUreYX+
         Yg3f7iLi/3sRmNjFb2XkclXGDOqV6TzRYu7QNBVw8PP7z7j2/6PeixsXBEgabyEkjjv1
         v3MOf6YfkjuO+Q/SghOgfqIRZUieN2X5wf00EzLJCXqwPiep01qjjauvcwRxe7B12sHG
         AVu16y2o+7f8s58aNJt2wb0tuRaHt30wD3mJXn08RuHZfT5N1p179zG3i2CyBRowKYkT
         gQj8Vr0hmR3pMpPILl/Dm/H44owDFGmCJnHCFkYAHPijMEnVzExTDlkyzjF+igDeZO/H
         +LVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764181422; x=1764786222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dRuIsnJjgKoS1qB9z1CzLqIUDAakowpq0VO9vQCJiLo=;
        b=KWBrPewNCa2giqloYJTPNuWYXbASlbTF3wntf2uLX5fbEnBI0VLelx57kDNLRnqany
         jF3SzZmU+wDCsdqMU89EPqYnSYxCIpOt5ehXYR2/ruu/5BH1RkSvgBNqFmKBDL2qASkt
         RrZ+CCeLTxEjjp7IqMg54KPJ0tirgpe+vF8dU1ItqWmjPcz6vhba/Tv7B6odeNSLKYug
         lBuryc93C3TopSVWcpROCkvLpCz64Dp6rplKYws3cCH2P/X7dfI6Xk05dj8svDx2e3Y2
         avMc6PiRClgK88P1spEaGEw+aThgHQjqVCk4bDRkwaDTFH+e46UB/tU+Vz4J0gaKtc/c
         lTog==
X-Forwarded-Encrypted: i=1; AJvYcCU9bBy8GlvSr1M/qkXAXxNlKk3uFx/XlvhSxXrMvY489lPkUsCzZGRt7ZgCsZKB8vTsObRoKURLmA==@kvack.org
X-Gm-Message-State: AOJu0YxTYDFGzu/981js0pimaQuy23qdM5shMxoXFbr9Nh5R/g5opd5z
	oJKAtJ9hj/4T66ikp3jc/CKTj2gFisS0JhrvNC6HSPE6fgwAh+EgnPJHgUWOO5CHrOiEDDuO9ln
	GMgK7X95UvRNuBML3WItjWbwKDzmF9jM=
X-Gm-Gg: ASbGncuFXDSfzu7/bTJeZM+SmSbWR0AqDoiWp9gzoFNY+7iye3FHAAh/ck5pRG5Qszm
	VLb8et9QhIuaF0BIf9N+Yp2/5iaEsgy3AvIazmaEEgq/i5x4NAP4sj6VxcNed8eNdTolpmRwDnq
	I4wz3Od0fHIxw9nrMy1tb8ZDxxWzrcOLqKgMH2sVUoWvpFGv49+BA315e4u+cufugK+06yeUHzC
	i/qRQvtoVrJhWGUnILZt30cbtqinhgG34m3krdtgcrpwasVeftnxTKVSgRi3pcG8fxiqmv1Vxqh
	w4vRF6SqJGmWPX5rSj9/gX6mHL14oASLfFQ5Yg==
X-Google-Smtp-Source: AGHT+IHfWId64Bl+r0YOyvlkmE+V3LHeRbvPTT9hn04ORygcq1+Vl/SOPgIbbyCm/q1AOwPJakPkTTkcBXvioHfUPyg=
X-Received: by 2002:a05:6402:51c7:b0:643:c8b:8d30 with SMTP id
 4fb4d7f45d1cf-645546a3a94mr19642124a12.30.1764181422210; Wed, 26 Nov 2025
 10:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20251125163027.4165450-1-youngjun.park@lge.com> <20251125163027.4165450-2-youngjun.park@lge.com>
In-Reply-To: <20251125163027.4165450-2-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Nov 2025 02:23:05 +0800
X-Gm-Features: AWmQ_bk5_D9gT8Ce1YgLQS9O3714SdAy6SVNypJn_b9Dshar6lWuqwbdvjARYe4
Message-ID: <CAMgjq7C0BVx8OVhEgJu3sVTAgTMrh_-vs9OrmwQhyFX6xC_LKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mez3zkobq9hu6m78izndyd1p96xqu9ni
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D98FC0017
X-HE-Tag: 1764181423-165339
X-HE-Meta: U2FsdGVkX1/yq6mwPpDn2ciAWMNX572g7LvSefh2BS5ZYpeRXnq3V5gm+pjkf1MCCMBQ0AB6HUmXTFYsAq87Lss8DSsFiiHMqrcDjysf0KwYVqDN0hvCgre9kdm0NJjDe+I5rZmRQaFv3MQIzGdL7h66qj5q+VJlb/qneupXp1jlGoVS9U8AKS6QM/T2IC+zQMA9JYNa+1lrZwv4dJQXPodqVICOi3++BMdWb7pDs2uWRXxFUkcPmHz6POo6qotQnq1xpECmFxMdCR0otpgH9qfpANIspwYwXffI4U4PFidO/co04L1gAHdeurwx65orkXOsCzHWypGErXtzOkhlNm70zbBnJWe2RSmPqan4Sg9JpQdFgus9vCYkNN5vucsDJCINB+JMVi4q/0zjJGqVOvHw2lurFnsFEkbGAttB0p6GbBn6wUphbe3UGFe5F6C2l0jgSoBgntXs8h/arq2mxU9YaBmhJBb7Q67G73OdZ3CfrcZfzPJ5YHQLq5X8NJIjDAXJpVY862dvSZJ+pdIvJ9gr4tRF9zBM0WNwhEaeszBZ1Ulj3C/qltd37FSWUh+4kwaPRIMdmvHI5OMNZT+4fuxnM8YFPPiH+VK7jX7p8bR/Ii83bJ4MFQGHx9unL7ehUnxuPfjs0TYkD2z//RjBytznkvBegRVBi/40MSe5yhoPJUSXXOWE8xD+fjL2Aqgi87tVQB2SCfds4b9U8ZoCFqQ88219owG8kletZXUBu6kNmQiur0/rZ2/LYIoFeD3QLT5pN92SDDX/x1Yob7l+OfX0dtOBx/jVjveRqK5PwhI3kcYZWpr0a38zYuo9Wla5+vcjufX1rjlFQvu7BmUF6YRh4x1xIunfBoqMYJt0etjCFxfRDvSXuF8heH/vaSIZ80Mn5BxhPekpYutN9AR0LItQRNuXubVaejB9OLxUSi/3jWF3QUnrWe/Kvt5hZv0ZO95+9LToF6IpN1oKzGI
 K6Xlm/o6
 4zzEARxf5S3Yz6UhtauLJPvx2te4cH/nKEa93zA5VBGu77zAla4gbJgjE9DgcbI1R9pD066QUuP6dQMv1DTs5Rk71Yg3aXcS+JIFoSZLqH5ssu+4Ed0VwoSYfV8/7JqihcUtCZCqsg6i4n3CsMcC9oWMS4ya3Qb5A766zsP2pBsrPm6pofS4TwssgM1mNgdcsV6XTV091CNqm7yDpk+CK4VaIzzUj6FWZoD+hCUyTFEcvNxa/fIMoPjUuWm14NRYuuQZT/S2gj+Sk/1fQaPo7iMfHS+U0LIMnKFDshfMBUedklHIrwID8Jj4PEnHenBCVvfnNBErexo+69HUHnp5ROQ/kWPq73IYCXDy9wT06yTnHoIPcMUXBXmPxLcYL+Buy0KI/nQVqO0OhOFA5e+ZXXqC5XrmZ0eJp6PTrgKwjIjhGhWmOLn4zw9WaVlHdOJkiufK5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 12:31=E2=80=AFAM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> swap_sync_discard() has an issue where if the next device becomes full
> and is removed from the plist during iteration, the operation fails
> even when other swap devices with pending discard entries remain
> available.
>
> Fix by checking plist_node_empty(&next->list) and restarting iteration
> when the next node is removed during discard operations.
>
> Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> swap_active_head. This means the iteration is only affected by swapoff
> operations rather than frequent availability changes, reducing
> exceptional condition checks and lock contention.
>
> Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during=
 allocation")
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d12332423a06..998271aa09c3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
>         bool ret =3D false;
>         struct swap_info_struct *si, *next;
>
> -       spin_lock(&swap_avail_lock);
> -       plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list)=
 {
> -               spin_unlock(&swap_avail_lock);
> +       spin_lock(&swap_lock);
> +start_over:
> +       plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> +               spin_unlock(&swap_lock);
>                 if (get_swap_device_info(si)) {
>                         if (si->flags & SWP_PAGE_DISCARD)
>                                 ret =3D swap_do_scheduled_discard(si);
>                         put_swap_device(si);
>                 }
>                 if (ret)
> -                       return true;
> -               spin_lock(&swap_avail_lock);
> +                       return ret;

Nit: I'd prefer to avoid unnecessary changes like this, `return true`
is the same thing. No need to send an update for this though, a really
trivial issue.

> +
> +               spin_lock(&swap_lock);
> +               if (plist_node_empty(&next->list))
> +                       goto start_over;
>         }
> -       spin_unlock(&swap_avail_lock);
> +       spin_unlock(&swap_lock);
>
> -       return false;
> +       return ret;
>  }
>
>  /**
> --
> 2.34.1

Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

