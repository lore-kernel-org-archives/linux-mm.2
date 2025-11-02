Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFB0CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 16:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF20C8E0006; Sun,  2 Nov 2025 11:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9448E0002; Sun,  2 Nov 2025 11:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06788E0006; Sun,  2 Nov 2025 11:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 907938E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 11:59:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88EE3BC003
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:59:09 +0000 (UTC)
X-FDA: 84066277218.09.7A1117F
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC30140010
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:59:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RHBZg50Y;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762102747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2H8A9cw3kvMs3bkUEbK9NC3MLhUkDdEmf0tI4Urblvg=;
	b=Q1VlCX23cBtSny6MTqCVmNcEt5nBbV5FY/q3K7CCA4DV1rdy6nnKLVkRH3BZx0EWIG+jG2
	9DO/WT4IYaGxs253xEILVoZzin3Fg4evk0Eo8YXkkYGvqxBs3kzDrWHvJ39sTBm8hhZtdR
	pg0qlKeeRFfzf+jJ4hglCqeH2MDQemo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RHBZg50Y;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762102747; a=rsa-sha256;
	cv=none;
	b=b/6L5RctJXZDLISy2M4r/KqJQkpanOtM8nlG0EiBQTqdPSj/Hk6x8eYa5zu5Frf7IasnCg
	fRdxiBd305E/zCjoRLMU4MF0sUck5FYATUjPXNXHfOO7LAxUxi5U2cc048Eg8I6J+CHd1Q
	A0c6gPnyc1mF4urPC6pwvu3TS9gSAnk=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3401314d845so4942320a91.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 08:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762102746; x=1762707546; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2H8A9cw3kvMs3bkUEbK9NC3MLhUkDdEmf0tI4Urblvg=;
        b=RHBZg50YAKebB7jK0IYomlxG5HfuXETLnKellHSFMIhg+DjQTWuDJLjg9emodHMbge
         EllGUG7ilflzwlaEhMIZkBS1S4F0ZP+/x5LpajgUukpHN9wU5hQx/S7/XY9br2e3v4V6
         MGcd5n3nxsA1GnH2Vs2pdiY5IpAJiog9HnX6cMS5fzEo4CrUKYiKrCNk0i95UUkxerWv
         bSCGP7o4UDqXIZCvbbIv6Xa1Xcj2L5FpQ+STAL1QHoS+ZbS0rTVHjVP/ljdHZa6ZTF7o
         Oncn5pjS3Q5DKS/RJxeLrtP/RAr2ZiV690IEKESftkt2WSMYRMpGwzsr3UZRiHFkACPc
         uuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762102746; x=1762707546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2H8A9cw3kvMs3bkUEbK9NC3MLhUkDdEmf0tI4Urblvg=;
        b=TpqEXVk1EQ2PVFmP0Pe3+eZdIQ4A9Y+uj/sAdDuZjfZrV7pSZfZnlNaKoQMQZ82uAg
         J+vtAUUO40Db7ocGLd+xtCGg01GOVDO9OH2/qoA+qGVIFOg5seK4oXnqquF5xV1fJe6A
         haAkd4G7CNsW0Vw905iZtdq6sXUMRXOWIM0a/rfeU9ld6i9o3OHyVTjW3fnoJL8xPR3r
         CRe+uW//MffWOmtQN4VCXO81ygJCodEdZTLPCU9JHv7ZGC3Rd94C50okdsz2P95/7FFe
         yFJ3U4XLqjuAxQIjAMcmlGLtDRV9OnLd0mRH4myuUo4pNb2EzBac9D0b+mTErbL4uptZ
         LrDg==
X-Forwarded-Encrypted: i=1; AJvYcCXagkZMmJQ9KIvQYjVfh+kYh5ikR/IqLUTYegnyrrzZjPgrsbqLkU61zyJPmQCrny3oz2tkpA6iPg==@kvack.org
X-Gm-Message-State: AOJu0YyejoB1hI5BhseUxAT19UdjdNC6V/i5m/nNeE3EdpYM3/9OIUbw
	FBucMlE+OrKyeF6Z+jfg0uwXN68yQUpNNdAgOSyACeUVp04rKWCJqnDPk2owOrgPPWKk36ASWkY
	IKbQn8Q2+r0p0a37jztBzneX/9ejUHhM=
X-Gm-Gg: ASbGnctqZJQ2S66lAzsf/9X3XWDy1fhze00X+mS9HwubJpF6YxpurJh6Y/SRMwhyDjG
	7frby6ab4m4b5Rbywm01YSk4VpUGa9eUbmrLobh8sDy7ipysdwCOFbi9E65zKDj5IZSC79GAMz+
	4jZTTDRn2a0esHyaHZfl05TOqao65SDYy4MSZ/59gViNYSQK6A7bVRYbSKVQYFW2HafYRavAHqI
	Ky7CL+qJP4+RvqIoLvwlucA+A6bwmuBoBXaGWv0kFX1dCN4k8z6kMQJ5ciBWoWMsv9OhJSocwc=
X-Google-Smtp-Source: AGHT+IFjlhqpuH5VGDhb2suMV/zsTD+1QVQkmaCxgbxr/Pp8L/y4CtuYgIYJ6lyEP01I8OaXB9/MAlSGrK0mTOo6Q50=
X-Received: by 2002:a17:90b:314e:b0:340:d511:e15f with SMTP id
 98e67ed59e1d1-340d511e56fmr4995965a91.18.1762102746574; Sun, 02 Nov 2025
 08:59:06 -0800 (PST)
MIME-Version: 1.0
References: <20251102082456.79807-1-youngjun.park@lge.com>
In-Reply-To: <20251102082456.79807-1-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 3 Nov 2025 00:58:25 +0800
X-Gm-Features: AWmQ_bkcGo-PpbWMfhxdt3eXO4V0cB_Au_-2jF3It7BqxZY_Pu4fYLIIF6egW60
Message-ID: <CAMgjq7BENujWdD_7htQ6WmvP70sZUTSvLu8vV0YGapEjkvpVxg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages decrement
 in get_swap_page_of_type()
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC30140010
X-Stat-Signature: 8ncbq4d8g3jwhsp63h8br1t5871fa9g1
X-Rspam-User: 
X-HE-Tag: 1762102747-109350
X-HE-Meta: U2FsdGVkX1+db2WjMm4a7OVljDeHfAJDghYcOLrJ6W37hiQiNjSP/IypzUXdDfAQFb/e1w8V8WLWnJH2GO5+CDYKRJ6xGhJSAGLQRH6NV9KBhtNRrTk24pIIO+NvrTeQ/qehoWSJq52UvIB5VWD9I7SK+7LIiCDpUPQK5Ub5+wudQ8cvufJ0tULI++7PwlClN+eZPg2KKIjzJnFRYY1bjDcENh4wsm8w3Ek1f8RiMOGWk91frJs/Xr4KpGj6vAypHu++2JpW5heMpeJjwCxfzp7SC78+nUtQq1vi3jNey1VaZVhoq9x/biwF/QyOl/LlEJcgPMKPr0ZLMl9oDtASeSrXI0b/btiRqESO9WrlqkzZIIaFKVde+NvIs7mvQTwDT1xeLSeSTBxY0yrBnBf0lr2h+oLHKvI84Hwg74+bCmehhqWp53N1qE1/lom/jR9zg0H/8T2+Oke+jOQ8cCH/xOc1IyL2c/otUsNrrwH09VA/+sJI1q2gKiVcCWqiLGGVaJ8Up7FTLHJhw4bbr4XFZDKKfs3kb1PjPD0xumx7+wvoSORoVyS+fHuUx4vAoSiO8ztATf7kSQ1fIjN0Z0CnDDpMCwER3TfvT3CUW+a4VrYvKQQEQLCcYF7nMQZDQIdDo2BBGDI7+Z4Ei4FtMdSKOEACCCP0DfXy3HdFbQ4qBoJjF7lCJIMvaFIZa1+9AIkStHPWUU39BH30ihgd4OaprXpjB0GosslFd/Jw105sjAXJLJIILki1YO9Hhp6IKdBZRneXnMpcuIb0CI+gD7TQ+rbeoD6frFq4wmM14ZOhqqydHG8IstkB1YP+2bxcgFGQaHPWeWPEvYXeJSfkCU7yZ045BBeyl5+8Hjqh43MtgglVpsfpaGng9XXy+e/3ODoG1k8daz3M4sZ40DFRIYRTuA/sz1d7ayjSezPnyCF56rO6mGmWFohNKnHVj4FgYs+LcmgP3uMGCzDqOX1k+OZ
 vmg9qnXb
 Mz13Eokw1nMux+mFs195sSpYKwRk1wsUAfHlEFHY1O8evDe0Rxt1SXDsmcTjF5PPtBxqLuxVqGkRAxrwveMc9waAfHLk4neopFdWCCtoOePwloYtG8m3z2vHY4CTD508E2DwN6Ys9EGSAtOogl8/Bc61g+XX7QWreBYZGwUdWPnE6Vw0yIejZAwHDjQOBW01KSBOn+vIWIPI5+Sh34KwVelJa1XsVY3qHtrQqfenpZfqtUEVgNoKp/8RWJXluvg/X8txvR0+CE0rci8p78UX7mmDS0OMJVA6cKKVkNPY8NmdkwMwZJejWlmpYcQPz30Y+e0Oe1KSFa81FjvqNuYFjDfQPEBd4zbePMvWrHespX9TVaPSPrGWMfuEDkShWL/j1GmDE9KkdMpw98rlBIcseU4/Lfml3boWDJYvSgoXuytrpWqKiNBytHpPFMLMDrirV0HXOJy/t5uD4Fj4x2Md2lREwvn3D0hA1hwQN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 4:36=E2=80=AFPM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> After commit 4f78252da887, nr_swap_pages is decremented in
> swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> causes double-decrementing.
>
> Remove the duplicate decrement.
>
> Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from=
 folio_alloc_swap() to swap_range_alloc()")
> Cc: stable@vger.kernel.org # v6.17-rc1
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
> v1 -> v2:
>  - Collect Acked-by from Chris - thank you!
>  - Collect Reviewed-by from Barry - thank you!
>  - Link to v1: https://lore.kernel.org/linux-mm/20251101134158.69908-1-yo=
ungjun.park@lge.com/
>
>  mm/swapfile.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 543f303f101d..66a502cd747b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2020,10 +2020,8 @@ swp_entry_t get_swap_page_of_type(int type)
>                         local_lock(&percpu_swap_cluster.lock);
>                         offset =3D cluster_alloc_swap_entry(si, 0, 1);
>                         local_unlock(&percpu_swap_cluster.lock);
> -                       if (offset) {
> +                       if (offset)
>                                 entry =3D swp_entry(si->type, offset);
> -                               atomic_long_dec(&nr_swap_pages);
> -                       }
>                 }
>                 put_swap_device(si);
>         }
> --
> 2.34.1

Thanks.

Reviewed-by: Kairui Song <kasong@tencent.com>

