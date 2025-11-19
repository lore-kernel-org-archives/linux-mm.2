Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7555BCF34A1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F936B002F; Wed, 19 Nov 2025 08:02:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07C86B0062; Wed, 19 Nov 2025 08:02:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CEB6B007B; Wed, 19 Nov 2025 08:02:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826356B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:02:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0CA012A97
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:02:56 +0000 (UTC)
X-FDA: 84127371552.26.542D95D
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id B255B140006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:02:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/N1bCXA";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763557374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfCv+7spIJY519bM1k5W2z0pC85PPBJbvMLUrN+U3eo=;
	b=HQdyHsjOJbKMm1Ni7AXu4Zpa+D1k9AnQLZT6fO7SASqBO1+J/7w+lVLHSf68d4KNqKQUhg
	k5VHlKnknept+zV5FsixrdTyGDJ/1xQO2bQRzX/51Fn4Rw17/RPbjo1zUgGBjIF8Br5T/2
	Mvrga/AAfw4uQMojilOBvMwFvIewIkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763557374; a=rsa-sha256;
	cv=none;
	b=ZPxPRFXOmmh2T7djr7X7c31CjqtTjUUSwVfyjPof5FFfYlDUBFXXW91MtYs9G98NW3ICtd
	pHrFJPL4mcbQbnTZsPcW5PZMxYzEyelIIfQq9kkLE3dMh7FGvWWAleITCkQn08txUPf44x
	UpP/+Iiih/tCG6Cnwz+dyidn5QcuLBE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/N1bCXA";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-297ef378069so62737805ad.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763557373; x=1764162173; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfCv+7spIJY519bM1k5W2z0pC85PPBJbvMLUrN+U3eo=;
        b=e/N1bCXA5AAFmM17KHRwIZNAeRHieraUoqgBKc7Uaoi9Y59mcm2RGbr5xpleQTC0lz
         dw5agJxkwauf131qc66i0171ZtkRniqvODzb/YKVLjgNf7/BNKHBRdFQlXGFbLPumKpm
         WPSlKdO8McmSb58Wy4HEuEO4jvXYsfY2lySw3h9P5nhXDEW4t6KkIjMivs/APa8JZWp6
         CoNk7aXFkAR7RFwEZnRsf09kEueVWXsFDMxL5xgp6lJACWGujBIJ8ZDi81fkEIFkMILu
         1C5Q5io7cIY+mdwqDhw3KtPlV2dDDD9vBfLbE0LURI8xNNqeVk6KiJ4oUNLErNj3PcAh
         SSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763557373; x=1764162173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UfCv+7spIJY519bM1k5W2z0pC85PPBJbvMLUrN+U3eo=;
        b=wkeO57giktxZcIBmczyMHD00x5+zuVM2nIdm4gjGqgYmZpCOecNkynC4/uOFoWoG/T
         XWOD8GYvJfY2VN8Wu2RparefB3lib5bqu9pF6K3xmf9zSC3sk684EzOQUskj48+DAglb
         QeTbCO1PvIU+QP52LJjapY+Z2JDrZVG3t1Is+4rNNNPAOfKvUMukRLZgKvfyLyJpixEW
         QSiNfiKqG9Gt66qI/SOQbPQlCIv2pOAXIESZqcjnZwfoEKX+IECfQg2tqkWkXmgc5rra
         aAMOEji89vmh6K/7aB8DnavW4HUFNpoDrrJBt8gY+MLiTvEDfXt2D4u97LTw+nwn2seC
         FfuA==
X-Forwarded-Encrypted: i=1; AJvYcCUhAUMIoZIAqBtBnJXdyQU6qJa3ujD0CzxocAMefEX9lPOqdFuRdbHhwUeOzmsYmzDSt7J/M4reIw==@kvack.org
X-Gm-Message-State: AOJu0Yz5vpscCcAiuUtcXaUEF4OffjIVerR8mK5mxC2zOUbMzT7anXCX
	snwSG6RfUtXArfflGY3DY4YcgmK8sBlHEYUj8xvdIbG4mDJsqMCgUBdrFvz0jItCw4yidyeV8rR
	aEkMM7LdRXyB9DaOTSjsJBLCrRMgkrpQ=
X-Gm-Gg: ASbGncs2d1xwwcAvTSvWsfHKa2yp4t/iamLlU7WGN2PBHj4jcCvIlZJhtH3BIDc6mcF
	R0oKs7GExFoTXrgzASbET8pPPK7Df3hgncbIT3eIHRLEu0Qbc+kwIvoyxeXPOOA243FM4W6h8lG
	SAjVAlOXKgD5BMNKbbceu4aLLW4Sh11aZKDVdTtNhBDonWB7TAgmr+f8hx76qi5hRhNiHGyjpGT
	nwfUvZEHCatqZhiHB9Hfmcjrd863CIBs1vxCjl5iKHTYyP3/s7uhn5ClQAsopEprMmnsL+kXLdc
	O6ZM+V4yhh/Uwejcj39mY34zZcMWSvbKitOW2uyeRg==
X-Google-Smtp-Source: AGHT+IEuLmkCW6WLkdCGrl0dyhrbyCbnPoXRWPI1R7FCwlyHZKWiiFv7P5d8hnuAxg6Q1Toy6zNvk2VmP8U7VQgC6Xs=
X-Received: by 2002:a17:903:380b:b0:295:6427:87d4 with SMTP id
 d9443c01a7336-2986a752b52mr202565505ad.50.1763557372953; Wed, 19 Nov 2025
 05:02:52 -0800 (PST)
MIME-Version: 1.0
References: <20251119114136.594108-1-youngjun.park@lge.com>
In-Reply-To: <20251119114136.594108-1-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Nov 2025 21:02:14 +0800
X-Gm-Features: AWmQ_blF1iugi86bOkigtXFfrFOTpNbQS7gQ6nAVInZSG7pRJ9-iKq0sF_LAXi4
Message-ID: <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B255B140006
X-Stat-Signature: a4qgtfc5k9jyu9k6douigd998y55kcxj
X-HE-Tag: 1763557374-890959
X-HE-Meta: U2FsdGVkX19d8BHnOcGD6h5uA1c4qvdkzX3wt6G52pV8FAEdpNTtObyffFdj0sD12sEEfyS95kKQhSySNwtyNVvUHC5jZ2PEXSqe+xMB/UtE9eyASaM/yggLSUy5hu56IMZh6BIkTDl2ol1uf64+3YCu9gYxJxx0vn9BzMwKex9ZEAsvZTx+rie9vvnPisamqiYpU31o3lhDgs6l75QMfYiCNjcpqHHRXeivp5lL2AILUKKj2VV/gzjIyf8JxE7RHW0VwjpUuFTekbsaADbxazAO9/UqkY70TCU7FG9wp68MFi5tdz830Rrjyup2VPK/8oZDFM3MU41TL0+4m9OT7sBbyCTBIkyK1pzYEXmSHwUqc3VJZz3d22Y5TzXJYCaHTcS0Oc8Ad0W+1D+cXMroZ7ZPimb/b7i/rdWCNIstMsGPVWo9ePjDuswz7kUy4cW1tesFSfpnCFGSxirRsFXBuld21U680OGPJ/jYVEnOWsOUWe62Y2goZCMaWmYFImdyt8YWI78/aN8XNv5WNlsWCbMAgoaFj0IK/AhU97N3GD05r6VXrvtGkJQ2pai59H0TmJ8JWlJxr3R5Fv1sYpqy9JqXlHrN3tCG84GnPGcapt6M3cr62wuft2LTjDAFXBZa5Efez/4wPX0OlRVTkRN+n7ukbmWcyjyOX8DOLJs7wIRJovlnBE/ZazTEMpmiuNjPqXVg3nTncEwM/BhMFN3E1l/W2cyHPmkcjk1Z5t8LQIhmpCMPcBydAb2GxU0IGFDWHe9xorJSYp0EPTCEqHege4lI3+Sl/HsHwbnb8narb5ASCCeN2+EHvGtr96CYKipKX7SRLfXW/z5HxMUGOLpYXJS+Ks1U/zqAIPYQ+X9uy26xMW2oX4CEiqNKAIV8hjS2Co3/9jOvTwyzaej5Q6Oufn4Axin8aoZ5t549sat7idpugg4VGCQIDJKwsVt4M7/3nWhc3HEDR2Cgw7Ra0dP
 py4XrX1+
 Su9lAMMwXQErsRNW6GM1M4U3KfEzXX/eeey4YVoED/0a+sOqpfN5t/WeCyC7UW1DxGCCpsjmt9kum8YAepa1qJMmAU1FVVw4R5aS2YurQS1h232Y+zlw8s0SXj5NdV9oSmnMj7Go8J3HOuZGHExKglf7gIFyDql/GTqlxMfwVaBfZj5Q+6WjdzCTFrSjlmLGCOllPCMRMSDyLn5KRjnZSZ3DeXqzYAYXyqdtInuqy48usZ7hZs9IqVOrHQen4p02vZ9uOaFO3ZIQGs10b5BrpXZYootfZs8qr2strx+SRhfoSBJ1yN/Zl7wPkDSaGr319PGm/vH2hJTt5IJQYu5XZlcdxQvM+M18ErtZYvO9duY2GKebAiD7TOIdr8sN6Za2B4PhYINtYK+IXvFDxdrqwM4PEjjzVGmHvEoy1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 7:56=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> swap_alloc_slow() was checking `si->avail_list` instead of `next->avail_l=
ist`
> when verifying if the next swap device is still in the list, which could =
cause
> unnecessary restarts during allocation.
>
> Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according to nu=
ma node")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94e0f0c54168..cf780fefaf7d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1374,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>                  * still in the swap_avail_head list then try it, otherwi=
se
>                  * start over if we have not gotten any slots.
>                  */
> -               if (plist_node_empty(&si->avail_list))
> +               if (plist_node_empty(&next->avail_list))
>                         goto start_over;
>         }
>         spin_unlock(&swap_avail_lock);
> --
> 2.34.1

Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

BTW I noticed the comment here needs update too. And the plist usage
here seems can also be simplified? We never use a lower priority
device when there is any higher priority device in the list, as
devices are removed from the list when they are full.  And the first
thing we do here is plist_requeue. So we can just keep trying the
head, until the whole list is empty, seems good enough?

