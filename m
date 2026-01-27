Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C4BD25948
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20C46B0088; Tue, 27 Jan 2026 01:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1B06B0089; Tue, 27 Jan 2026 01:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3856B008A; Tue, 27 Jan 2026 01:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3116B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:12:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3039A8C602
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:12:56 +0000 (UTC)
X-FDA: 84376725552.28.A9E6A8B
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 323C820004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:12:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YiRp1gSZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769494374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fw77OHCmQi/THnFtNAgXJIoS/IUJlX4GxEekn+APIKU=;
	b=Xa54yhqDeL3uJGv7qa0gZGpLfb441tYRjIVV+R3YyNCDH/7fZ2IxNBjxl9txiLl26IQl+s
	vJgo4vqtfIJToMktWCESunBgZ96knYDvDtW00ILWktN7fFK+SHR1+OY7IatCX+oXtWiy4m
	8QsCpiNNrjEW6ZkxbDg+H431np2nT/4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769494374; a=rsa-sha256;
	cv=pass;
	b=XnkI+FvFHz2uTVBIzR4Ec/kDeYEDI/fKLas+Zv7CezjSXDC/XlWU0DsCV+HAuRz+uVZ5V8
	urdEL1r9X7jxcG05Ia+fdP30bWe75SzJTUksPzajZMoYK9+sYKcX4rj0g5rll2JMadusFR
	XR/DzsNfESR26Y4K9miRthHIldyiH74=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YiRp1gSZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78fba1a1b1eso79549817b3.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:12:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769494373; cv=none;
        d=google.com; s=arc-20240605;
        b=SvXETUJqju4J7SUoynhSbha5rDDD5/RPvnF+BecPHoaOj26yEwSwH2aDH4lyRiXwyI
         ituMWAYhNpgj4NSgJ4OATfZ+glqprUvQGVTjDBr80dYi8H2cmkZPBAjSwDDD2zNt/Wd7
         Dfpu4+TA81SV21/xacybMrLRFAKzagFa3x0QPXM+eQPWlLybpuXHTgpitbOQRO+UHAaj
         I7XHza8tyqOFiKee/geKUbeRYP+jrMLAzsJAvJEQRUTK4BFPHBd1o6spiXdOdJq2bJe8
         kmqmlsbCOqDvWkq6vaBvRGTfOcqkxfZQC8230K5YLiOFSRPvdYbc8PzWW/ym1/VygW4A
         hDUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fw77OHCmQi/THnFtNAgXJIoS/IUJlX4GxEekn+APIKU=;
        fh=8pS/Pph1mDuPl98PI1vr9G2xZSe23M2jkT07Sn9m7Sg=;
        b=VHNZXk3CWQrLDkaNby6QEtSIPiKLNWC3imTrfJnSHXaECHb84BHNA9EuZNo9+1LEFG
         IckKF9Wb5sYvfD05fQTJ+6UGWgd7vCn2khVg3+gkBtJOmTi1+ef2wmKSRxphbLH2B7CR
         vj3fo2w9xPJ+c5F8PZx3ZVz4tJJqqArtsCtZ/vkVHa9re1iICjdBsJf2lObOfzSnc/qk
         UwRlSoktI4X5Ov4Diks4a+aJbflO2qAe24C+B4DrmLrTOusTRRTAtWw9VFucIZzVeJ5O
         Lzi6KP+eVNJLltwTZngusEudrXbVSfyKnELcoP6aYK5QWLS4pbTy4XAj0CUR7Aez+vOJ
         51gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769494373; x=1770099173; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fw77OHCmQi/THnFtNAgXJIoS/IUJlX4GxEekn+APIKU=;
        b=YiRp1gSZf8AQIVifhlQSxrAhWbKuzPtGg7hq/adFE9t8ijRMB0Bw0EqM1VFC1JM6SM
         nYqYq4aCPBIOALTwNkbd/XJMpH+MZAVjlsu7OgYvM4tc2VrBVpVOBNACywSFmHZs1rHG
         Qa+5We8OhNh9vyhyO9IZytkdTyWODdYqdXgWGpIC+YImUbuJwTg/thzdFcFd4OsSQFN1
         nuQJkhTX+ARqVLetKt6fGt100E+oaLZORtbLRzmLtho6VyhTFsLW82DC9s4lbPRTHWw7
         YyUg4aCZiLt/d8GthOS5PCusWB72BcpWAk/LUp191Glrrw19U0mCjOxkPJNu1ael9H8e
         qQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769494373; x=1770099173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fw77OHCmQi/THnFtNAgXJIoS/IUJlX4GxEekn+APIKU=;
        b=wN8SnwZGfTdK7yB2iLpr91bvtCX7KsLTa7cgDwzwX3zHBlMOY9BXX1gpcMFXABciwL
         qbZGk0eDofJby6CpL911arq2yBHwISCONZM7+oyhNXS8RbaLgaUp9rMG01erepq9DVMg
         BQo0HKiFlCGyHTMo1QJGB8TVgtDowioce8Bxih1RbOjFMQ/8rpb64WMuCtjjMVxgxYU7
         faTsa7P8rSyXca3gXlZFcHFO35KuHFQgVDtMJu6Tt1A7Sqb/FDICqgiDShkILvq+dQVW
         znS+Xaapy/4ECgm2vvh5pqyUfg+sOseIQU1wppYttRCfE6MFa9t0mq/uy+eMviJz4Ax+
         KM4g==
X-Forwarded-Encrypted: i=1; AJvYcCX52avnDKrSiGbLu2xm9Q3GoKZy+xJUbP5Tb/m2zeonmJCdTAi8WA/3GmfiDB1U8sZ3I7Nj7E3y+w==@kvack.org
X-Gm-Message-State: AOJu0Yw3/KS56GNeaV7mSxFQK2PsVfdAwtiFzlC6cdi2cnZi2lCt9mtq
	pmkS+T5enEcYFg2rStCQn+t7mBWd0Joz6DT/0QxkUXRwkLP5YU+pr1vI1NaPUc7H89dGwD/Pcs6
	CYdciO1yyj/7bDAc+MfFpdKxyB0RxLII=
X-Gm-Gg: AZuq6aJAoGHlP6jXBrIGjzNra4jiUVH8f0bdwuiTW1HPW58Dt4S9z6zvArTFU6PJRbw
	5DyLiMuyQyNqqYjNkVDyuPrsadaugjytl7Co0brmFBw0fH8rIqjLUWXYqBD/vgp5XKGj+lSIV7Z
	nAizYFqZBG1clPAQqGdGXkUUid8nXdr+u9Q70YsinKge7+U/ZyqdBUn0OlvcUc75a27F5+Szk+9
	IiR0ZaBiek3CBaFsjx2ohxjfvfQGeqMuXecI6q5bvMvxI8nvoXbqLG8OULEKZoFbUsBy1jL
X-Received: by 2002:a05:690c:62ca:b0:78c:7ed3:f71a with SMTP id
 00721157ae682-7947abd5bb2mr3471687b3.3.1769494373226; Mon, 26 Jan 2026
 22:12:53 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-7-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-7-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 27 Jan 2026 14:12:17 +0800
X-Gm-Features: AZwV_Qjjzszi0Mx9DzI_P6xCYJ0ZjBXRqXPfR5mshB_NJEXLUa8A6Gcf5JTSmA8
Message-ID: <CALOAHbAkxp-wvXpk7uM+y6Q46U6g44Z+SauPtCpY_otL=a-vrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] mm: define mem_cgroup_get_from_ino()
 outside of CONFIG_SHRINKER_DEBUG
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 323C820004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ob6ua47tr4xugm99wd5zfcaxnm8dgpeo
X-HE-Tag: 1769494373-29427
X-HE-Meta: U2FsdGVkX18cOT2yPxiH28ULcWP+qEAeq5f1nCNze0723W6nKB5x5lyWs13qmOnDsQgzeqYStqfeX2VOoEHk+DJOAonX5V1+7muECCTEmeRUR3MyH/ew07fQoFCaFBNZ5+a1hRQKXui0pVbJ0l9+kgPp+hsL8sC/L6M300NvQy4pJtGeV6Svv/uTEm/9pS9v4XFXv9UFdc+RtucfZUbdNM7teKr9vcHW9Fy6hOl9WT9BpHjKvvyuqFynfgP8Fdf2hi9+RSO5KcIox54mDT1nimilV+vgITHA7VJMPIXofJJ+9CK4RtH6PvuCYwMG2JXBz4n9KmHUyggJo6atiHMwUJKh/o1kfvs0WoCjNuKoal4gLTT00rtZZp8lIUlrDi+Bx8E211+iEhgKHsKdyL7k1L0z+Qf57Iat87IpB773bYcLXooCsXcCLzxC78uMBYQhpWNYPI3TQNCmv0Exx+Ef1XB8bqlwxoRcAmpBLR66YBVChHglyxuSkWm8ateyuktasrqHAwTdVtqqA6o770eXIr7ClKxJtCdmvpB+rQrn35GOWQUTKhiZUjZzyik6aBNzye1YBvvEsyCIg9Xjrv/s3gO7/eCIKu6fXPdlHjb/hsc7+rEhWHqlsCVcmljVU5KOGJF2afD87+NvV+LvPTv2rtzP8ojBnKqRVYiM4W7FYeywXYkkSmefCYurTe2tw+yqP68LDF+P8QcjVdo8X0YStnVW1fYv8iCgJAf3WlKkaiDa2C/FAtwaURFofCFgFgt0Ibkk8T/yjcg1XsFm4FC8iM6GR9zhwT+3uaRuDiPO1U7KzjnrQZCl9YEgXG09ls5utDtaDAzDiNk94eRW2LHUDlSXzFW+aJwIoneox2YTuii4ELKq7ShGaFbyn7fyg7W0csKxpSMxZdopw5DBnkEMgar3rJNpEiles67AqSewdo089maUg1vqm/OgfYzaaIWROxV9KE6ahV5Ve8NmPmz
 yIp75NhR
 fklntAd6RGc29mBG5Hn7AOezIl0bpH36lgfn8p1JZXexolLeRPMlqNdU2wcTaji35IYQvlHkubSVIrNz9/SmC1BYxM28SQCicWdkF/MMlAif+3gZNW7GIxvFq+ndaDdkdmXiYJ4GPn5DdwiNRgYISPmqvjUTpiE7yh2dzV9tFT5O2LeYvTikm30Lyv7KQrVSW8rOFpVFigwGX2J+NKUehV4pPMn0myutY2yOB5G4Spdc3PUcD75VrmeiSCgHPpg3tzYzlIJtMmsJUaQhipTmPdJZ3x+GJ/qKJW1+CSuPz0EZsaki8Nypy7BV2Y0Flniqyg3gSxxKImC6djHzL6xRho060y2G5cwxvG5eyOd1j0oe03w9MuR/ih5a1QUGWXeOaRwhCCUtjDtQ+juGN6rI1cjU1LQ2nxyzs7B/EMmToWfr9J87YL+MJEqzLo9b2n+QHB+n8iYzWsfuzt+QdVZ11fpkyrKHCqL3b7SzwPjPBYSi6If3aOZWWlvHINZ+Krg4kxw5Ib9yeHx7PRFMl1PIZBJ7qnis/c8GJrDmfo3mRoQkd6sUmSc++yAO0JS8+X8eC0NU+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:49=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
> but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/memcontrol.c            | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 229ac9835adb..f3b8c71870d8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -833,9 +833,9 @@ static inline unsigned long mem_cgroup_ino(struct mem=
_cgroup *memcg)
>  {
>         return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
>  }
> +#endif
>
>  struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
> -#endif
>
>  static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
>  {
> @@ -1298,12 +1298,12 @@ static inline unsigned long mem_cgroup_ino(struct=
 mem_cgroup *memcg)
>  {
>         return 0;
>  }
> +#endif

Given that mem_cgroup_ino() pairs with mem_cgroup_get_from_ino(),
should we also define mem_cgroup_ino() outside CONFIG_SHRINKER_DEBUG?

>
>  static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long i=
no)
>  {
>         return NULL;
>  }
> -#endif

--=20
Regards
Yafang

