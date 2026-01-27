Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D541D2593F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 05:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B494D6B0088; Tue, 27 Jan 2026 00:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6C16B0089; Tue, 27 Jan 2026 00:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0CA16B008A; Tue, 27 Jan 2026 00:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD1F6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28B5A13BDB0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:51:11 +0000 (UTC)
X-FDA: 84376670742.06.8CEC938
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41EF51C0007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:51:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eLVqOXVJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769493069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=An7SHoxFNQVMVrQg+cVoi49+jQE1PDn2o0N/47lH2vw=;
	b=Cay3ApqWoii57tLI2JQF3yfg174YD3gSzx+VqNN0ZJsNiDdrmRzK1lGMHdjqlRC+HYgAtl
	N02dxpazzKUc0fI7UtM5v0VNDHav2VhyXrMbwLctR7P926/rDT4DhGxkckO9CMaiamBf6D
	RMPveoL+rza9FlPaeSTER03pAEPCtyA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769493069; a=rsa-sha256;
	cv=pass;
	b=L1O/P5hkzF0cl9BF1hMrYZlP8GjhXIHKtyWDjZ5MmSzQvKLl2BS+aJgxpHI8zxiAgIxdDC
	pf74jgNNvw3avv1L0OEk9YkAJcM9QwxkASMhpvWXdnvnlay3Z7VZqjuNiqKrafMCaCcR4K
	1qRYL6usJgIIypsJghaqGx5LS2aMzV4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eLVqOXVJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-79430ef54c3so48761637b3.2
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:51:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769493068; cv=none;
        d=google.com; s=arc-20240605;
        b=D1Z6nv61ADuzLMFVkwacM/qKyATA9wOgY1w3oiLkYWRbt/TyiWp3wd0Z3stY1vujnS
         wMhcOv91pGlepUi36SSQ6H1DI4AVyBBQZiDuWSAvOlen03afqAE4eHPFHbWHCDxA9aWg
         zJZ8ZLE2LVSibQNSWSpbHGBItlUYrCMcY7hYjzjJf1qy9sZxw12Q8BlBFu1fEedk3d/k
         quExNJ6Bjxj5eG5ogJL7LuRTSXfjN7DnnVLgWRNsU4G/l4g6rVrnwLj/0gyl3ySsHD1r
         vIErcy2mg2oNQH2tHsoFYf2tx9v7jfB5M60XGO3mmvOMnVByx9JhSR0/ZDvKYUiNdA3N
         2e7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=An7SHoxFNQVMVrQg+cVoi49+jQE1PDn2o0N/47lH2vw=;
        fh=Su+Fib5T1E9b9FuPCMwoMuWAm7uNCzKe+ueD5RrmQw4=;
        b=PuF5HLFxPxu9twxUtv92LPcxCtsCkPkMYsuu0M2xpKgXVB0YK5WrThklE9boZNDYXu
         liXJa8xE1kmmKYqJHstPZKRtghYEZeojJwMXv03qywOcl23regi93KIfqd3yEwFFG39P
         icEFqAx2A6eqkO1ST7qo95nOExZoe5XsiCPMY3jtxHIrB1pTelaAfChYctTU3EMvw7+4
         RoU+MhHXPR7yDBgN8o9yZMek/8WqPFT/Q+u/Qxh32tGFvnox0n7flS1D8BjibzvPf0CK
         xQN6GRgH+NGzv6e70AV9hJ+MvgzlsrmlzF3mIFqTV06kcMz851ZID/qABtvpfGHFEDhY
         y90Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769493068; x=1770097868; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=An7SHoxFNQVMVrQg+cVoi49+jQE1PDn2o0N/47lH2vw=;
        b=eLVqOXVJO+IWvfJi2JLUkhRYlECMPG5yvLpyVwKyHVx/M8C7KVonAu7xlQGhxRP2iS
         aJdsxGDywCilVhCdd3NmZvNBnS+Br8CliW1Az0rtbnYIe1X0WTr8ze7stVGSKl1L7cu5
         habrbOOJAkW2721rfQ9/Ulz0QFnbhFSEppLbVHrkA/5/zAgxFfzp1b34z83AMdMCtt54
         QPhgMAZKzILfwF1yenCZAMrkLEwIpQ0EFl6//WEZUH+cJtZd0DyPv1fShqOOmyRxGRST
         /So821Njt9T6U6z0taYvOgiGYwktbcvjmIMoP+3bAKY/ey+O28sChMHfw+3DCqWeWwx3
         lFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769493068; x=1770097868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=An7SHoxFNQVMVrQg+cVoi49+jQE1PDn2o0N/47lH2vw=;
        b=e9HFeJsKkSuH9hOKKTEqqYscpDHL2b3D6qquSnAJgHzKnYohuWISXCTJFHjfyfrvCm
         b3nVxhoffYzJhjOmVLYnmV6/vnODsFlBg0OvcPyCRUrT6DV9Z45eAuR1HbGxx/vJBArj
         dstM0vZ9QeDe0pWE8HBLQp4imLGQF90SseusGebpZIcOXaT4kWTvSFviLLNDdz8ralPe
         HqG4eSC8aBIt5XjFsQG/EBaJKf2uGIt4+Wyixd5LC14o9T4ttuBsBdxbrZJy6DSPkaXe
         lNEaHcRe8XBCmvoc3RaRFsf1FMxw+iPOq/cEnRyPLq/tVCO/JE1HxJHfUNpyrSBXEKlk
         WquQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjVwjdHAjFCqMHwrPhnJAdjPfw+33664ldiGBDWoKfvpfSnBz6HEeA3YAZuyAUPiJWvp1Bb/6QaQ==@kvack.org
X-Gm-Message-State: AOJu0Yyp92fvmTwmM00JPz4FSHAEkXcGDJyyIwgzumdweIfxKMUACyPF
	btyH+Nu0LO5nhutXMS+R0b6SBdGXnCdaVl8gLIJiWTv904XYWGWarInfyqSZYvSxk0QOkoClGFD
	WS6I1B7NMxgAyskTaRykzBfcsd3DRpB4=
X-Gm-Gg: AZuq6aIhDDxPTAgpZNywQOUIimTUStD9FE+qlZhdDsNYny0DQFplYxjf9kt1/Q3ej5G
	Si9P44LNP2JMCVd8ExdLm95ZUOZbMzyVAjhrch5VHKkue23e2U/M6StzmvlMa0YoXqLeD13dbDz
	Q3VIl78AElqvK+fBfcNxmpWXBKTEgzPgHo/klvIDDBSEmdm5OOEGgRFbzBuHXShdQfEIA3mh5kn
	wYlxtZqOxoFd287YV48ZiWfeOckpwjdPa0EX+H52fEQSive9l5jvy+wyWfo6EKi/U59qU6N
X-Received: by 2002:a05:690c:6287:b0:78c:3320:9c5d with SMTP id
 00721157ae682-7947abfcb88mr3717107b3.42.1769493068454; Mon, 26 Jan 2026
 21:51:08 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-2-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-2-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 27 Jan 2026 13:50:31 +0800
X-Gm-Features: AZwV_QjGmr9RumY3gWub6eVfLg0tOiVjCPC6kXyGcnKB2ouGmo-C9UpBzlDTXJU
Message-ID: <CALOAHbBt8Gf0ObNiBRcC2_7rx=Lo2ZytLmqk-J0=9bg1hsOskA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/17] bpf: move bpf_struct_ops_link into bpf.h
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41EF51C0007
X-Stat-Signature: dt59m1nf31w6opjxy5fmsewkjcym9kgg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769493069-6819
X-HE-Meta: U2FsdGVkX18jN8gw6NSZhD0PMF4Ljbc5su6OzXg/rUGH1tcNBRkmvVRMaCP6BGqBVZQaq/+OQ8JDLsEOMWrH2pRUNvsDiNnGc+jfXtgKQjKLu8LxfKyqVsrUS0ctlcp8hp0HXl+W3ib9Z/SgVKoBFfHR/D5Q/v3D8jh7J+rfgQCZHdELXj/Z4+ROwLdx+Mls/KaiXE/a1ufkPDMgyNSNbcP1vxVeLekCspc9jqrZMRYQigKO3PVSPXmf+FwsO0UPYeYRJm6x/OYRswLPM9u6jL9+xbLmH5AFedDT7FfXl5LtoJskpE0ZNKrhskCVquuW8M1mZ/ZNG/L0Sb/9sq5N8tnZ0+NsNr05mK6VmLH0699qJB5242i/YP11du/j8roTRgVQ+Jd9pMyqPgHuloeqIq35Kbb0YZ30et5eZOFZM8MlWO6accka9dDoJKLEQem+FbUbYbKWnIbiN+m2jVTXzKLuG4RctOPWNu6GmjUNQpzMkaaRNYdJHAFG8Zmitfzb3qFka2rC7yiFnWxjxibWc7n6vTu+3ph8s8s6QRfVHW8UxKxww9HxMveuwTUVwUf258zZar16ZmpGOjl3xMwesUW0u5bUd5FNjOQWHE93HM3q0m9mxwQYRUF5tNxUWIaD/7lRhflrRLUrcWD9UJAaEfjFFxYdzDFDg+BIzJ6fy5LVjTWET1lEYawhEg97Yb3tySQOvgwGaBJL+grKZ6CHJxG27WNH3rTPKNafwsNu71kh3QqkbqO0NJsNH/h3PBDdJA3GP1zOAR8Q5LwAHbpfRhZrTD/h+JfYeGgn38/68Q2300qOhsDwVd6yMeDO/2kzduBujxk0HkV+82D0rEjEUPgR81U9m6a/G3PJr/6oTeS/Bj+UGb8yR9e4HwKD9V3cMh9zMuiIwioadIm49y5XLW2Ec9/FkjuavWudK/skkGVmUT4w2Jdl631rGpLj8fzWRvAp5n7oNR1YFdoWwy8
 sou+piQU
 uRbcTDJD8X7AHhjFS70wNk2XrUIfQ9w4llLArFTU9Zf3Oha8POxOkFV/KnEorFSjbDm06b92954y/ZwgSSAQiUDoaXS9kv/FQtTVV+FAsUwvogCDONGjifAISYCwDeBmRnxFmPPRB9VxMdv4f+wthezH5lE2kcLqQ6PWtcKaxWJS6AZ1jaZO6Y/xydNOS8aJJLrGCD8tAVzjMw0lmMe3TvJFnDBZ6JOzTR7D/w/EDdjpRBFYb7qmljUxS08F0AZbbQuFPqIzOUDnvVN8TQKfGHJcBtCW3Tq3b4cwCGW9dHoahE+RG7h28ZfbO2Gp0bG4e2hv9eo0wD10Z397hALUTCEdYcre/Fi0blFAHNjCO6BaISw+GlzC5sgS6ETbv0pSiZ9U9H7HiKIMDELao/yno8nc8T5PL5m7YCaywnsSsKOfAoip26orpmdubBUiO3xvIHUdQSit8Ntk0WBZIER+ILOeMsTIPdJebi+AjibRcyvhHEw4m3cgkcaljqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:46=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Move struct bpf_struct_ops_link's definition into bpf.h,
> where other custom bpf links definitions are.
>
> It's necessary to access its members from outside of generic
> bpf_struct_ops implementation, which will be done by following
> patches in the series.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Feel free to add:

Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  include/linux/bpf.h         | 6 ++++++
>  kernel/bpf/bpf_struct_ops.c | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4427c6e98331..899dd911dc82 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1891,6 +1891,12 @@ struct bpf_raw_tp_link {
>         u64 cookie;
>  };
>
> +struct bpf_struct_ops_link {
> +       struct bpf_link link;
> +       struct bpf_map __rcu *map;
> +       wait_queue_head_t wait_hup;
> +};
> +
>  struct bpf_link_primer {
>         struct bpf_link *link;
>         struct file *file;
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index c43346cb3d76..de01cf3025b3 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -55,12 +55,6 @@ struct bpf_struct_ops_map {
>         struct bpf_struct_ops_value kvalue;
>  };
>
> -struct bpf_struct_ops_link {
> -       struct bpf_link link;
> -       struct bpf_map __rcu *map;
> -       wait_queue_head_t wait_hup;
> -};
> -
>  static DEFINE_MUTEX(update_mutex);
>
>  #define VALUE_PREFIX "bpf_struct_ops_"
> --
> 2.52.0
>
>


--=20
Regards
Yafang

