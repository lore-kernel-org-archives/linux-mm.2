Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E2CCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB2C8E008E; Wed, 29 Oct 2025 11:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B3D8E0045; Wed, 29 Oct 2025 11:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959A18E008E; Wed, 29 Oct 2025 11:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 838B68E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:42:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C13AC072B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:42:09 +0000 (UTC)
X-FDA: 84051567978.03.5610381
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A54C14000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:42:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0LOEd2+;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761752527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL+9rC+YxpnBMbbdWwDa0GICkBdXAJLgAY49rP9akho=;
	b=vCgFaguRk/XmcQmx+xQOX8AnnAUwMqgGeYiBEz0W+n+We/b0AiZxNv7GM9mXs4V2V/0Mqi
	ktZ46PkbQyVmC22Sn1d8FTmdM9R1RuARrCSMDKkiTXid45gGkWtgv9HusmlXipkrqQWm4m
	KSn2MGQjaksRpQiKKsZoMyAE2iH+nXQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0LOEd2+;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761752527; a=rsa-sha256;
	cv=none;
	b=yyXdU1vaGwVkJ7C6JKDv/hiw0A+HN9r5/XL7iYx73KJVaZdBxbrBKIs3tu0GLW68LXKIB/
	UtH6OiZwcl1KP9y3vIVJBdp/L9tgnxoZT0r6ypc5cMeZoszc8sECGQUUL75HPc/A0ordSe
	oR1eQKOK+oPlxc+vySW3Pf9El/9BAIo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63bad3cd668so14519575a12.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761752526; x=1762357326; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL+9rC+YxpnBMbbdWwDa0GICkBdXAJLgAY49rP9akho=;
        b=E0LOEd2+/Cv/ac3F0JItcqQMGq37vQv//n2pxiDIV7XXSTWIcmNnt5fQnuTjWThdEb
         IHdXcKs+BNouaIq4CTmTuvA8VGTwa9An2MZt5ThBDLrSXZvYiQwvE2aFVBPEc1CMMwav
         ai4pcLvvhAj47FwUOTMWse/0REaonK5lFT/KIc7Sdq8uaK8rtLFZ46DKzpNyV3t0Jrge
         Jdu4B3p3zasD9DiJvyAo8u67gLV6QRA0f8M0dVWs3gSzpp9JixcpqtPRQO0xy+uS0PPW
         ZrF4BsOXUS2pPxYxL3YfYwdf/bx+izVCCVpwJUc8mSrbuVRbq6urhTlGEWgJUYW5ws5n
         TJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761752526; x=1762357326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jL+9rC+YxpnBMbbdWwDa0GICkBdXAJLgAY49rP9akho=;
        b=Kml5kb+iHL37/LeFPm/ahGOcp82BoHifsQrTq31ws98R2YXo2ZF6ghZLsNlU/4yoV1
         9Tkp9rtAvomJgWo8hf9t3wXYSAlG1+tCKsf6xn87c+7+0bFtPWUYskbyxbrJVlftt6ZQ
         gVy2NfFbr3HKUz9nAoNjhkHFcm1Hvloxb7IKnCZXdHNRnpjyMJf5xfeiMhl3eIPrtMjA
         cK1Cs6r51WHImi4Tsyw6KvFLa739Pv+BKMF3DNhamDFNUu6ccq9DRXrwGhhFJjhyAVcS
         ALV2ebo6cUj1TEEicgKxs2P+ckdBoG4bM05nz/KtljSQaEQYDH7ofMar3uRaMU04xnl2
         4u7g==
X-Forwarded-Encrypted: i=1; AJvYcCVMWyfOTxvHrwmz1B8BYDC9Woxd5WliRtT22ATn9JnSwLNy+NTjXskuX9mz8BfgFtWI8p1nRQOu4g==@kvack.org
X-Gm-Message-State: AOJu0Yx11bqawWUHKFt/BUh6w+lkb8kLDabmBurGSUnIDOJ3tlUBAcF3
	iYkDog4ev3E1yg7y7hDaKucyVPPYghmBq1ChqvGpLTzIcnNXbJwJL9LTL57stKUlKpIN5VHb6HY
	9THcDt5nGF7DmFfqVuhaIAK5GRrAajhc=
X-Gm-Gg: ASbGncug0x7VEScAdkx2DEysiQDVmS7ZpzHelfqZONFT8sYQIN3Gy8dvBQ2QqFSJucS
	xB28hDeCwd577FDyw5yfPTIHJlIVNlIFxEUFSfxmXhNSuPgyQPpOio7A75SO7qHD1sOSqBuN9Oe
	xIqp0lnb1eSOVsyvb614jpM0qwd5jUA2DKjyfT7wJZ4JXXA4Pg1O3KQyyeugH8rRBP5rm7Mjxrd
	RMnNIqK6AKNQxekbKf9dV3a7YZ7gbZCUhg7a0I3qjsNMWDzpM+VVS2DIiir36wbL9hb6nqa4Lk=
X-Google-Smtp-Source: AGHT+IGEM9ok52WwxAxGgf2sWUliDoEawHwhvsBsK2eoMWNOe3w9EmK2XUE8FaACpeV2thhHtKZZiJZ+xYxopqqJCR4=
X-Received: by 2002:a05:6402:2355:b0:63b:f0b3:76cf with SMTP id
 4fb4d7f45d1cf-640441a7e80mr2675795a12.2.1761752525605; Wed, 29 Oct 2025
 08:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251029085659.2005942-1-youngjun.park@lge.com> <20251029085659.2005942-2-youngjun.park@lge.com>
In-Reply-To: <20251029085659.2005942-2-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:41:27 +0800
X-Gm-Features: AWmQ_bnbCdf-O2UlMn7K0q5ZYJ9Bv3LHYasOzBWz7XZ4WJg9MvoBYMdOdfLTxKs
Message-ID: <CAMgjq7BiQ2X5K+Ri+wk2J+QdcfwfDGKjT7WXC1_6b2myFGrXaA@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm, swap: Fix memory leak in setup_clusters() error path
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	gunho.lee@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jp5fcxg15tq6k57tcm9ak1gsgcibys6s
X-Rspamd-Queue-Id: 2A54C14000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761752526-91967
X-HE-Meta: U2FsdGVkX1+aOYM89DGOQcvrzv4kHScEXoRqFTXIORfWye1uG6ftO+c0smu6tPEafhwRF8wERENfQ4NlbpyeLoM0PUDl6Zj1up5toTYpqIT0+VkZxqhAKP6bKVUT/vk97fDz3GXQ4Ej72Y3h4YRvzJUoTeRA6CAGBl/lq5sxIvFS1lEG3ZaFsepAB4P02u/XCLwrwsCgwGw3VPhPQ0iC9Hv8AwEXb9TUxD5ns+oMUfctLc2uzJTO9VdN4Huy9oVrIlvN+LASCCQnD5+kREf2sR09i159FnWjJB8HybbxyAq+VTQ8r8mpCDg/24O41JctAYX6Z4vX6wU/gRq9YKD/6a2YUFhEpholG2MAIms1DNgEwr/noW7PskiRIpeNMUd8gtT0LuxaUpRJgEUy3SVHm3Dh6hHmk5bpayAg8t8dUliMrJdpJx2uhCJ1parn5ACJRovFxGJ0Nvjx5K1uQK+SEoUcuN4PmjX/G/gtJ8aYvsxrxDi5Y0xY0/hgndcDzbnKBY5rHBh+jGefOS6glQNZBKDtFgi7JPQPG8XQwPBcAI+lNGZ5vVbZLQryLg++TwELh3aJRYoKASkmFbP797MC+ImR8KooQgFgHlaSmi1e343feVrrD0VoBq0Bw3GPNHKgNhKC2A5pp/aG3COXEZS2EiN0dcaj3l49mP3DLrr9dsciFrNBCNtg/5TgTJVsu8kC/DBqBOq6AppmWMb/9/kDzkfp7kD6f78OdsjxKjMtycHrOdQto+Y5uewikP/903m35z2zw6LGrWuEEtkE20tw7n9szdtHwB3pzZw/4sL2mFNbuMhXatrfXSdQGerIP65R8AvnlnMiHOa1/eUCgGFxb4Q9yRrvButokuQ7W2ly7cG6mrvcQ2NzD69g0S1C5Tz0EBskXqzCw+Pftuk8pgm9QaXWTf0fwAuDZXZ+nJqTkUr6dNLOqTVG+uZm15cUE2zE48yviLdtClfvS0QkUfW
 93PW+cyd
 p6NHVBl+6XhZwSzTinAfw/aNxzu8a1EazV6pj0+XALuyHCGfEEkkevnrDzHSpuCtGW1sQVoQwhmNMwqyTsRiPEH/FO6/1DCbPhE7GhHWFSliIy7Bc5pX5OHtxrGNh9wLs7/IcKnxAO553UO80+JCy+/RP7kliPieZfSBuOJfQDbESp+bYZFdU5zV6BkqGLVhvxKo5Uo9NRDPOPER2r8PcwUC5esRopHLtuhFittTam1biLIZ7MXwiFGP6gHdtQedMNnog/FYCzMoeJmDwOJWhzW+kBSM2gXascRxCgaesKRybMG5NuZCx/OZEtrUWNLGieALPhh8cckHbFQTAEjfta3soiCgluUrfBxLm16QoS9RdLW+41oL9/JJcgEDEXnxS8BrFX812V18vphJHZjpziGylGpHGUVdDPlc7+QVUD+pyUZTa2FKXr9mvy9RJvNBAoxd9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 8:44=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Some error path neglects to free the allocated 'cluster_info',
> causing a memory leak.
>
> Change the error jumps to the 'err_free' label to ensure proper
> cleanup.
>
> Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap tabl=
e")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c35bb8593f50..6dc0e7a738bc 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3339,7 +3339,7 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>          */
>         err =3D swap_cluster_setup_bad_slot(cluster_info, 0);
>         if (err)
> -               goto err;
> +               goto err_free;
>         for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
>                 unsigned int page_nr =3D swap_header->info.badpages[i];
>
> @@ -3347,12 +3347,12 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>                         continue;
>                 err =3D swap_cluster_setup_bad_slot(cluster_info, page_nr=
);
>                 if (err)
> -                       goto err;
> +                       goto err_free;
>         }
>         for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
>                 err =3D swap_cluster_setup_bad_slot(cluster_info, i);
>                 if (err)
> -                       goto err;
> +                       goto err_free;
>         }
>
>         INIT_LIST_HEAD(&si->free_clusters);
> --
> 2.34.1
>
>

Nice catch.

Maybe it's better to just move free_cluster_info under "err:"? That
might help to avoid more issues like this. free_cluster_info checks if
cluster_info is null already, we just need to initialize *cluster_info
with "=3D NULL".

Just a nit pick, I'm fine either way.

Reviewed-by: Kairui Song <kasong@tencent.com>

