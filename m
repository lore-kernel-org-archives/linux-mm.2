Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCABDE63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0E06B010E; Sun, 15 Feb 2026 19:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8896B0130; Sun, 15 Feb 2026 19:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5A76B0131; Sun, 15 Feb 2026 19:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11A086B0130
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:16:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CFDA8C54D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:21:04 +0000 (UTC)
X-FDA: 84448263648.15.590CD11
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA86B40003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:21:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBvPx9RN;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771197662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dSti6qUG4k+SbmTKg26mkaMIh7kMD2KX/t/B9iBo5Y=;
	b=ev7GcOzgF+7uJw+FgBFWmvGsVuQyrhT6mGGhVBp/UndV0wQHiboxiQJQPY7IDsEKEBMKyt
	6wlp4USLK/3vKDkF2RYzj72Xb57DLaJaeJPDj65E96nVgnyFNIjNrQpCL7jC68yZy0f6ub
	GSikysNPUq9OU9xsUDPJqspM1nzqsXY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBvPx9RN;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771197662; a=rsa-sha256;
	cv=pass;
	b=LkfOJwL1E3R/0T5jHcEtIInr86Gql1v9+zGqLOWo0WIRY48g1KSiJmJNQQFlo5CsTNNd9C
	+NNZl+uki/OUURof8r9WkEsp2hytZ4w+vMrRUjpNmETGomaLV3mUixI5uJJAMRfTdJQRqw
	dTy9L9RJLwESIqg8Jw5zHi4+z6yHFb4=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-896f632d206so57306626d6.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:21:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771197662; cv=none;
        d=google.com; s=arc-20240605;
        b=QK1KpBTqMvoqQg3fRpCMIHLkRVJ3eH4RDt+amuhHzvHQIo0RV6UNViwrHfWkryu1hX
         SycTrM07rrj0FxqE348i1aAbwYoAbloELL0xoOAh4hwp5TZUpycuFsWe986xBt9bY5SF
         agBVM8fU7GlsA/aU5zDP/8SNQ6vwRFxBe58vWhRLPe2NHLrOYDEK4ikxFjCTmH6FO3u0
         NPr1+ortfrVZrvSPVrvrQGxLcjOGwFKZz60BJMkgsydUaSTwQZdtEvIlxetyJoOGBS1j
         SM24MWuKxK0yQo7qSKZ+ZZk/E0AV9aAHXIiLPml8o4nc9bjZbnfEQySfOxP9hxmeVGe3
         6x5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9dSti6qUG4k+SbmTKg26mkaMIh7kMD2KX/t/B9iBo5Y=;
        fh=ax0SVDDNj9e0avQJCZXKE/RdhH5t7AkPo7KIZY3RsYk=;
        b=eIWez9f7vBcl6+q0i0koLSfaClTCjOsGkmt/MIZ96TQOEU8upzcrv7wAxREWFhu2pE
         AdKymhyXpMhqBCKlZI24mGwKepVTFUfSQQCmJ3ZLyMJ8DN/+ouNfOB/jbNpZa51kSahf
         9oKYijneS9To3ermEm28RC/LaMXw3OEuIFJbQMukdnJZ+8YKm34dHkjbOL6mC9msskDq
         /YUyc4ZOLYR4WfXDlZM6PQoHPFJdVTEZk1wtx1B/VEKAD+Hx5fVRrtVIfNqDPEDMDdY5
         xYSpWA8XtWSv4Mq0iysl3EJ/0raO5zQZ9i2QVWaRRTFs9XIbDXvAKPTW4KMcsis+84LL
         47Yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771197662; x=1771802462; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9dSti6qUG4k+SbmTKg26mkaMIh7kMD2KX/t/B9iBo5Y=;
        b=aBvPx9RNVolNfzkvLxZ3bVz2gBSE95Ni2A2oyDswCF/B17epv8N8eUEIcEQCcQIt4j
         OX9JPM6HRZ2K2Sc0bOJPICOgidRqQQKmhIdiK3kLFsgE8muizEEcQ2IkBGk1zuv7eyCe
         lT5edcgvK7c3xPRUfs8lSI/64etYASiZOfDxUQG6i93mu+rWFwGLlOdut++I2LZRYYp4
         R6JlJA/cApw3k0hBsdujXuk+HBAkd87kDid1JgysjDeUIN/gtZmjUd8pulFBQHK5Phsq
         LcClJRC4tyG6CNLSurnjqwvaqJyC9fL+IF7OjC4ThL2Iw1QnbVx9y3SJImtM++YRqI17
         8cyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771197662; x=1771802462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9dSti6qUG4k+SbmTKg26mkaMIh7kMD2KX/t/B9iBo5Y=;
        b=lwOcG153hmg/Z6l2jobE9f22hfjoFogH0JIKPX79rTviICBQa9M/qANakbMM3pxefg
         keLGzmupSFrKBgXsqG5ZYa15Dk0VP2pXGQ/CKFX+cuVOjrIh6uLR1YE6pmj6vVm8bTNI
         +oQAvn70BobUKOYPuGiYTd2DuuIYByVC9/5kSUucV4+xOjMr5wcBCZTyjg6utE7OaMM7
         q5DdwFkrwHTf6O/gxCF4KWnpRQ/VASqv/2RL8UO+zGDUkYSlFdUQ1s+WSm+/ZqZlDcmM
         EDNbzfh3xeAYnDKh+JaA50K7UDSzde5pmQiBVFZbUrdmTx5RSS8i374hoSQUEvV971E6
         QpEg==
X-Gm-Message-State: AOJu0Yypp+8zy0c63kDYafuPyL5SLX6gUvUikJhKsOAw04gLjK9NlzZr
	7yE/ca5iSmvLAP0JtdegKu1L/Y1ManWkz/l4nk6Stk6B++nQyDvICtofIEP1zFlD6FTKXN7eKXM
	8fVij6qg/F/2ptLzpsLSjhVBk/ixgChE=
X-Gm-Gg: AZuq6aJekczNQiaPf0MybRKfufz8aFxwMpPvVBZemInk8kaKRGbM+UlEmh1GlZT/yeo
	VRHugwbRZryCyp1k7fUN4Jtkv3SKV0zayWszZg4z7bH5+ThmK9ttKijstVHSEMybDyiStv//hx4
	VGQ77u2UDm0wWYESYDDcb8ALHMwmg89QBuIGizpWdS6Hp3JuG3dSn8ClK/ahD3abwd3Jc43UOHh
	FthgYjJaPiJq/TdSSaoGEWg+QLep3Z37RVvYGfH5gcIC1piMMvLY2mtpAN0HxQ8fgXJvjzhLywo
	d5Lmwi0XeR+YQkJe
X-Received: by 2002:ad4:5be4:0:b0:895:4d3f:b6c with SMTP id
 6a1803df08f44-8973f2fbedemr106347506d6.17.1771197661590; Sun, 15 Feb 2026
 15:21:01 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com> <20260216-hibernate-perf-v3-2-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-2-74e025091145@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 16 Feb 2026 07:20:49 +0800
X-Gm-Features: AaiRm51jPFCewXyj-msKubNXn_1t8hUGFcByOC4NgVnj27CFj7IIHpXYi_25B1Q
Message-ID: <CAGsJ_4ynCA_w4Xcwu1k=2Hw3bMnURBxC2FeZEzN+uzBp+9YJcw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm, swap: reduce indention for hibernate
 allocation helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA86B40003
X-Stat-Signature: zn3bfn5arc9pc8zmndd5qowsjfc6mbu8
X-Rspam-User: 
X-HE-Tag: 1771197662-119466
X-HE-Meta: U2FsdGVkX18s6UqqnixMmrcG/YLaaM3IVsAcReF+/ltLDtEVP+FSvIUzyLIfSPcDUkZvIBAR6bDxL6xOzYR5/e2/13jwxrL84vd70pj1EYoupqZ7+0jRhQ+FdtBvTYQuCQZfvqsmF9v4PpPChcHeGu3xBOTBC0d26NRQxlT6aQDyzi6+Zfc3OXNOaOIq7+YJpKwx5lNDaNXJz0YQYMefyoNN/+kdDctDoEjiumoreqwQzq3RFqDAt6pgB2Q+8fFz3KxqjiV/DFnqUyjTTLCnJ6Zjs0IC5h/+ezlBUo6CtCGebmqQjCU0C8KJbqLnBZ4Zt8Y+9M1ma6EIQuwDXrpo39LqIyEq1HK/EMwJSILTzBod1PqwaWxEaCKdVqNNVtbZP+DFEHJzCem4uAhA+rcllL0XpO98bcPETVqMBLtUgWT8x3oOy3lo4C1ybA/5YM5MKKhxZnFUcYx0/NMvHCiDmDz8e4L5Ha7bJTarYMQovGrCLaXi/PB1pjqtqw7cWF8nxopOjg8vTM2aBUtU5qIL+DCm2NzACE6PQjOtFzhaYxpNoYQQ2aSou4iW5+PYz8RsSnCkBtBCB7zjNSKM87tjGv2+wx+2czT9/iJdgX4MWwMGESkQd5wlh1LftHyiNRt19k9wouoRzRAgjQGsxK8fO06rzeYTxY9birbO16Vff1WIxAtmvjcraoU2S7GhvgMX5GVOFaqKKbneIzPIr3yDqlWCihmqf0m53jfhivZ7edJRaIPshLdATDJ9+F/ufkFm9Trsqk080oDUfFj9aRRgjnpKhpxgWPSeq6RTE8JgOIzPui8XQjI3abioqiL4gZ1oT+cKtfibx+qm8ObHyJ3rGEJ65rTEQaEjEZ9Oh8Wo9vr1gAmZW8dK6vUfZB5dlqSj7a6JtIEOevKueANlnziP2yFXxUHQkINjYvLcYYrGjgEX50RwKvFWKkB/zspkxa5ARPS+8NIXP3FDkcaZrxo
 cAkxrISa
 d4K+kh3QV0MrZf6B0p96+TVF3mvSbzJjwxNOExc/3tngVsB4Whav/p1KD3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 3:00=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> It doesn't have to check the device flag, as the allocator will also
> check the device flag and refuse to allocate if the device is not
> writable. This might cause a trivial waste of CPU cycles of hibernate
> allocation raced with swapoff, but that is very unlikely to happen.
> Removing the check on the common path should be more helpful.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 38 ++++++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 32e0e7545ab8..0d1b17c99221 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1936,27 +1936,25 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>
>         /* This is called for allocating swap entry, not cache */
>         if (get_swap_device_info(si)) {


I guess we could further reduce indentation by doing:
if (!get_swap_device_info(si))
    goto fail;


> -               if (si->flags & SWP_WRITEOK) {
> -                       /*
> -                        * Try the local cluster first if it matches the =
device. If
> -                        * not, try grab a new cluster and override local=
 cluster.
> -                        */
> -                       local_lock(&percpu_swap_cluster.lock);
> -                       pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0=
]);
> -                       pcp_offset =3D this_cpu_read(percpu_swap_cluster.=
offset[0]);
> -                       if (pcp_si =3D=3D si && pcp_offset) {
> -                               ci =3D swap_cluster_lock(si, pcp_offset);
> -                               if (cluster_is_usable(ci, 0))
> -                                       offset =3D alloc_swap_scan_cluste=
r(si, ci, NULL, pcp_offset);
> -                               else
> -                                       swap_cluster_unlock(ci);
> -                       }
> -                       if (!offset)
> -                               offset =3D cluster_alloc_swap_entry(si, N=
ULL);
> -                       local_unlock(&percpu_swap_cluster.lock);
> -                       if (offset)
> -                               entry =3D swp_entry(si->type, offset);
> +               /*
> +                * Try the local cluster first if it matches the device. =
If
> +                * not, try grab a new cluster and override local cluster=
.
> +                */
> +               local_lock(&percpu_swap_cluster.lock);
> +               pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0]);
> +               pcp_offset =3D this_cpu_read(percpu_swap_cluster.offset[0=
]);
> +               if (pcp_si =3D=3D si && pcp_offset) {
> +                       ci =3D swap_cluster_lock(si, pcp_offset);
> +                       if (cluster_is_usable(ci, 0))
> +                               offset =3D alloc_swap_scan_cluster(si, ci=
, NULL, pcp_offset);
> +                       else
> +                               swap_cluster_unlock(ci);
>                 }
> +               if (!offset)
> +                       offset =3D cluster_alloc_swap_entry(si, NULL);
> +               local_unlock(&percpu_swap_cluster.lock);
> +               if (offset)
> +                       entry =3D swp_entry(si->type, offset);
>                 put_swap_device(si);
>         }
>  fail:
>
> --
> 2.52.0
>
>

Thanks
Barry

