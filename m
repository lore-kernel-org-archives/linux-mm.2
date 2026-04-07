Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FA2FEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0646B0088; Tue,  7 Apr 2026 10:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7EE6B0089; Tue,  7 Apr 2026 10:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE8C6B008A; Tue,  7 Apr 2026 10:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07C726B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:27:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB2145B341
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:27:36 +0000 (UTC)
X-FDA: 84631988112.03.A462F6E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 916DD100013
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:27:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ACFq/1dg";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ACFq/1dg";
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775572054; a=rsa-sha256;
	cv=pass;
	b=Dpe0ZryXE2q4PynS56jnpjVqwB1S8e7Szo3tv61cKP472tUJ+KGSrovgMSE17KaPOtwjEX
	fuFnrAV1mi9p85kk+wKVh3w+/YktkGopeo4KVmirK09bQWRl6XHOpu1xuUa36v+Gw5ePnJ
	UM6+p+gI7pJAQhPa/WAHY3HMkDx7ZGY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNOtGJ5mB3mUKoAOGcoMBgJ3gFyOO8KPYrhZAmxfGJU=;
	b=P931bzK4gEP6tsRTaQsR1BbqKdXhO6WabIOuWJvH1I4X5UkafxVx4cwDzc0PJYVYq8f3gD
	ohtfz03mVZ4R4UlmhA+tP1rzGioSqLx4kSyCrejPAhLTIwwxM2j2aCFKlaxiG0e0iw9K91
	5ooH74V8iIuMAsWWOPOiGEf0XEAM8QM=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso658670066b.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775572053; cv=none;
        d=google.com; s=arc-20240605;
        b=aX7tBnR+AAA9XcOcBiHclSCf9NHtAunakjZ/nR+hyJbE6HDbdPi5vmfnnkASQ+c9d8
         eFr7spb7qCoANqnDBG+gSuiVlwqIjFl3+0gsSxw6cJBw/4Z3waVvdCJpuUL6ykRukeNf
         B1aAgmk+epp1HVtFNISgtWR6Zss42wCjXBMXaaW+7r90oD7J4yz+VZLcMVn2qt41O/24
         ZnzaHXQ+IgG7OM/p+c4CjdGJlKCPz3i6abrUXZ0H1v/7oSH1NvSO5zaJFj2j8PYaw8o7
         aa3CIDB1c+cPKp8M4XAQpiZ2pvHpbyWfVMYtdOelhso41Udzci1mAKQ2tP937JcuD8mV
         iFxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iNOtGJ5mB3mUKoAOGcoMBgJ3gFyOO8KPYrhZAmxfGJU=;
        fh=hiSrAaIFZKbsCISpNnPTBh4PKoFfHuP1EdFH6Pwx15c=;
        b=NduHDsZr9tFvkYkQnEPt0HW9rbmPnHXdEHrntFFcudhsLzyRZym2zZDFE4I5FDAq0H
         lgWRkpgPfGAi6riWG2Dq9ojSXpG0/fka4KSmH3A+Tp+R/vUfW2+YNec+xhsbu3P4hKQh
         JGT39dVFtmnG6blu//sB8L2Q4VMHmAmorPP2OJMDWn0masaueFXWn0teJdmwDDpJ9k89
         yCul+TaVdd2QN3pUzXDucDBFkUXFWnVG3xUFuA63Z5yK4TRUb93RSbj68/DwiBDq6EJN
         stD4xhYDpRhTvsbJ3AzqJCp5ScglGpsfUtYIWFYY/rDqHcJXgCSOmE5h+ZHo18azsS6b
         J4Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775572053; x=1776176853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNOtGJ5mB3mUKoAOGcoMBgJ3gFyOO8KPYrhZAmxfGJU=;
        b=ACFq/1dgxXBkNzFwVYaQnyTYanz786Qp5XAkiV8v8TiKZ4SlghlTbu3xMbL7S2Rg6p
         rdNJKmOwo1orDWB11U9SJ3nmvIl+76pw2PzcKWWhexR4gFBVyFAbMwlA9AtUyCFjCSrg
         hbXgCnbKN5KtCrbc085roeEiw2cwhhWkOTsOmqbxXLv5tVQTwdeTBhXr4fdYHBq1nXg7
         JDha1Zxx7iHaVi0vOWFSuP+j27b5ABfs7tpBYwaKELAxTHowEj4ktQ832+2KGIY0FSht
         J+bjLxezo8Q656onEY11XTbniDN/p/BUUVZoe28OY79DYWLMZkTgbEIxeaxdGVEEgQbA
         Zw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775572053; x=1776176853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iNOtGJ5mB3mUKoAOGcoMBgJ3gFyOO8KPYrhZAmxfGJU=;
        b=B5hqwcpVnlm1uUh5WjCvpStU1xlIas21uWMl8TpifrG+40p+1EI3SmQh0Gyd/BU/bO
         /iQodReuYGZ9EITLRFTjSqae4xnHM/HgJMEJ3DyTHUnR35rvjQH0AGkgK5SbGUPw7g5f
         3ddm+6iyDrU2SYIWJtM2mnMJ+Gu25J8nVu2ZYm2NfvhSB1I67aIJQHSAeVISkP1MdsBs
         7wF9V/OxZEMCDvxZxTChebZsH/4Vm54m8m4fiNZmtnHKmITfpKz3oNVbN1KjpJp1wn4i
         JODITQRJ8HeFKCZM2FPRTFayL3yc+IdmqsU9O0bsGtCWtBmS0qrCy+5NKF1Rc/ibXVSS
         +NUA==
X-Forwarded-Encrypted: i=1; AJvYcCXN1hu70R/Cs08J5WvFwHeeXkoB34LNcXnN/M7BTIAlj88ms+VQRNMbaOULm5f15OdP2I+OyIY3AA==@kvack.org
X-Gm-Message-State: AOJu0YxopjS/9MZkXYSxE+bzLxTmKIhMqHsRaLpKMFKmafauRvlQmWyO
	dhe5MOdPRsh2Qss+7rkJSJfSAl7GvDr4ohNtTvxZ20CC1+lBz2oAZj0ezDavuZas0LrpfiOOpsp
	4RCOG9TbCWjDOOWl48uSrq3rcy5HuiXs=
X-Gm-Gg: AeBDieuHQU9yCeoZYvBPqpZQ6mP4t9AMIk5ySlDvhakByzYJ6jt9J8JpRthiS/25deL
	JhL3MxogJhbn79Jd5OUfLZ2fRKMaPi7mAOsQJi8dPYpLWf1TrXf3VqQD8ci8AtuA9s62kwrj3Zk
	lYm0AmTt97XcSNJIKmkF/t7BKt+Oq3+/2O6xzw7OQWKg0oI0bXfNjH1dRQ7OMRgK4y/YFVWeOY5
	EFGzv6M9fOqdfGgfoqq8YW35kTLq/kkzzbD8n8JktD2WQr/uZuJVDD8t28jj3EVxNLiyERhb9UA
	m+NyRjh6iv3lD1qcpBr/xV0hi8THraV8WKHwvJ/L
X-Received: by 2002:a17:906:2099:b0:b98:155e:609 with SMTP id
 a640c23a62f3a-b9c67b7fbc6mr624392566b.36.1775572052505; Tue, 07 Apr 2026
 07:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 7 Apr 2026 22:26:55 +0800
X-Gm-Features: AQROBzA7rGwe-g8C1Axq71zPgt00Tvht1COp-g4aqx_S-9pNTZiYj7hTCxrgauQ
Message-ID: <CAMgjq7DWkURifMhR8HG4nZRz6=G+Pk7kz9OGdEuL=VvZ7vWDTw@mail.gmail.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	"T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 916DD100013
X-Stat-Signature: 9au3jfd7a1bjuema8xj1osjch6trntd7
X-Rspam-User: 
X-HE-Tag: 1775572054-535064
X-HE-Meta: U2FsdGVkX19sk3Xhi/8J8iK/3CLONSdZPiprjLHmIXi70X1Uj1c1mDPW9zV1hjBN43XYE3yqNSgqQ5DKm+v9SwV6AM5FNIRJqHc6i5bxNEMKxn1zMsyHUhvluV7h9ih8okQCtAyhInTgCszXAJSVr9+x7gyM/hy/7eqTBIP7Z8ci6YoSGOZ6TN6+tr0G+VGUFWWQtY2Srxj12SPN+/HjDEk1vNTu/eBnhQXpQpz7P9hYyTtuMQKUYHCbJ0/7Vt09Dix5g8iA0whwmH1RoM3XLitHmJ2tHA4tJscdZDCskMBLrCTjL7ypgf3wCMUinBhPxn05Lm1QP7DVZDXaBrQxA5zl5pmdilopeZmPPqbpKQiw2p54+6fFk8AiADUOEEk2rUyuRaojJdo8tvVTffsSl4RzUWOdKlgOG735ScMHo+aRzL0PBNoI24ey/zQUA7YuWUeYN2lDzQdibTID0knm0DPzLzjnv9N8NiKfpLmF3UuDDuZUtA6rDA4iYmUBY9ANUsXQqqPxpv8+3mhp0qm1LRFqiZ1sh68xcKk8FFQtD4M/vEGGW09OvDrHPwHYANz7YAwhokfjOo1dbwNfT74yaZpCP0hFBITvQyq/zcWYmD3Cs1IkcQ3UpUAk3+whi/2rNS0diTV850+Qr/8iC1zS7TERKVGZIDVH/rEyQddfFIjtR9h39S07ukSmFYsiSRONv25KG11tgxwyN//al2KzUGyGxB9TS0D1EQ1GhGjc8W7ym+64dySe179F9r9h5+rVcvGTjKk6MwWXPxu4+B19uZGJdkRQLpuiUsoc9JFo51pDxu8efvxnPaRct1fZgEwDeDEeovrSf4p0iXD3gc6Yu2EdWmuqcerUWMlvVNo4lc4CqApaSU5mqwJJQgzmhIX7B2hFYHVLq3NavwKlF+1TyZ75GiWKHZDN2XyVFs/OHOFEr720fwki6ncqQM5u/3772KKOlmLJfyUM6knwWNJ
 sRut7diQ
 HAHO4usakTePQPOJ2HBYr7NaMolEvl/rQ7z3saXBKRg6NSG7mns7rzb2wVW8Xn+XlZiF2ATMSpDyq4+klNXMBgtdJvAa65zDUgBsKy5+2/WcVG8eBL/QP0tMdo0tHnXuUChyNJmBlTbP65hGmadY5u6xWGT22tCrvsr5Jv/tmvjoXRfT1ttEtu4/X7LLUaEOLpzfR5bMek8mMtKtgDrIVjnahc4m1wzuNu8h1RhS9E7HvaCtbavd+yMexhAOkuxQpzWFL+VSQFezU/8NROZ3Rct3chH4EK7A4C01VVg7HTE0XTrwWjtEVhZ7SFaRAHadn26d7pjEuCsGi8t69x31qb8zsHZHPcLElmneIov22hB8fcYPrtqekT+pYMlC1cJh+E9YnlEx5ZoSAz3sOHU5AdzBHS4JH13AC48p3SG9P4Zzb4JCvIJ4psBW4ip4j8/ykY1+hrkA1vNiAbpJ/lUdgVqgPgXdZZds+kq7SOpnkHCAuEIHZNad4BLJlJPfjd5kzd+WpQb9jaXu+jZmMHGBFwh2wS6O7a2gDkoFHVBQVMYbT4rtct12xwTWRwM90kPhsgidvR26O4ZOl4aQ8P6j0Z4YZFbvn8hHoMz3bc7Ub1SmH86fCPyL1ZG6Sgp0lQ4GBn5kzu2ctbWTO3x5pGL8lN5LUKzuGEWpqmu9Gwgec0ncyIsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:17=E2=80=AFAM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Android systems usually use memory.reclaim interface to implement user
> space memory management which expects that the requested reclaim target
> and actually reclaimed amount memory are not diverging by too much. With
> the current MGRLU implementation there is, however, no bail out when the
> reclaim target is reached and this could lead to an excessive reclaim
> that scales with the reclaim hierarchy size.For example, we can get a
> nr_reclaimed=3D394/nr_to_reclaim=3D32 proactive reclaim under a common 1-=
N
> cgroup hierarchy.
> This defect arised from the goal of keeping fairness among memcgs that
> is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need

Hi Zhaoyang,

A nitpick here, this is triggering an error with checkpatch.pl:
./scripts/checkpatch.pl
0001-mm-remove-root_reclaim-checking-in-should_abort_scan.patch
ERROR: Please use git commit description style 'commit <12+ chars of
sha1> ("<title line>")' - ie: 'commit b82b530740b9 ("mm: vmscan:
restore incremental cgroup iteration")'
#23:
under the target memcg.  However after commit b82b530740b9 there is no
total: 1 errors, 0 warnings, 10 lines checked

A lot of auto tools recognize that commit message format and print
warning, Better to follow the rule unless necessary.

> to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
> bail out when the nr_reclaimed achieved.
>
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> Patchv2,v3: update commit message
> ---
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..10f1e7d716ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruve=
c, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> -       /* don't abort memcg reclaim to ensure fairness */
> -       if (!root_reclaim(sc))
> -               return false;
> -

Makes sense to me combined with b82b530740b9. I've been testing on top
of your commit and it seems all good:

Reviewed-by: Kairui Song <kasong@tencent.com>

