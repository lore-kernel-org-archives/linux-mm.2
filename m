Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9A1EDF022
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F22B6B0005; Wed, 11 Feb 2026 22:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076506B0089; Wed, 11 Feb 2026 22:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99536B008A; Wed, 11 Feb 2026 22:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D566B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:02:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 632261402C8
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:02:09 +0000 (UTC)
X-FDA: 84434305578.12.E5B38D1
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65E254000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:02:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RMTDmUhd;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770865327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dX3iw5nnT2kebeU8B5JRWqhNSVqrdu73co5/v4+a7sw=;
	b=Q/MeM4eXPN/A8BnzJtH5p/+PF/XJcHMWQpwPehttzaRO1ppC1CGYvj8/258oH7Pni0abBN
	J+PC0KRyrxLOMA8Ep2MzT7HQwKZld/9bEq0AO1BsGvartirCdrdQpbKOiKZBYy1BvmoSeL
	ECyJ+Ecy/zfSmS9yW7JqkyCbWmkKUyc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RMTDmUhd;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770865327; a=rsa-sha256;
	cv=pass;
	b=JEFS2Xv9RdN/NsakP5xOio3gIO6FPH5iF765097GzKH5KiSN5DGXRg/uouTnhpJpV1FKXA
	W2i8Le/K+Lja4DS7OzRyt/8zsA0u3sh+oyIT2NWbyXSVcpqeqjmPAENP7R7ed1jOihUD2f
	UYOuxxSWLOwuksuyKax+SriuTh1kS1M=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59dd34bd84fso976647e87.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:02:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770865325; cv=none;
        d=google.com; s=arc-20240605;
        b=k9uUfRXQqeFxHPlDmfdm8VPf8KMAHgVC1eGXaNPSfhqxqpVND6YnMGtxpexujek9sP
         91KhwGLLukD336D+paJIJ5sGKPQa74ZPp3aB+QsC0QYz2UXss/YygxRNHO+pgBiBXQef
         jM+/xwmSgen9BSvrOwHajjFWBMgPvBZt+c1i4xHkrjaoZhoa/VDyGXhyylWaHpb8CHBx
         NU5dhaJntRfoZv+t5be1GbfrsxjFNNWGK1orxG45CciZOegDN7NuydDcMNjEy8mIGIxG
         7z/LiEv4XgiSufZZ20IR7EAlHvfPfxdNn7TiHOyM0SqPBUkOroU6O5BCrPwvwYUoneSj
         P67w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dX3iw5nnT2kebeU8B5JRWqhNSVqrdu73co5/v4+a7sw=;
        fh=eU2jwQqCVPf6AUxcK/GZxrUx8lcmeFIW3YgWDFE7tG0=;
        b=Um5T78QoxtDaWB0dbOR9c/nBhVAOJ3XbmJl46wKwWiexhrDfF/IRy3jeGYWjbOEH3l
         BJn5XqQD+7+m2TEttfVzX46ebpDrxsoCE2jhZH3HjD6jW8EVyQ3P5j9/WQu9p0r5tz68
         zN7CtkDEEgNsDof0HYe7r77WVUnNPxFvYZlJQ6Wt0QW31YzD+qAD8aIqvLgLXliINGni
         /PKuPbmnSxe7zPQHSIbkXNxQoy8n7H8XW6QCqLGiz7yP3E7ipydExJi0vnVvLv6xOyLC
         91Te4Yi+W/SJiTdDJ+vcZ21hKGmS7uRvMU7btNb983j+bZL4PE6IDfMYgjPfWzdYMG/u
         Wibw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770865325; x=1771470125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dX3iw5nnT2kebeU8B5JRWqhNSVqrdu73co5/v4+a7sw=;
        b=RMTDmUhdkZ0t724TBO2xykRBPL5OcjY/4NgYw8IwYBVi9jjEri9V/CfwXC3Xv73ran
         5Fjwe1gs/YAXJuC4RU7/PJVKx2iYYj9NolDJ6BbLHT1hzuDfkTr0ohMT6e/kiysAUTUV
         U6Mc2O+33lZCkeP7j6CiXaMv3Oo0nd92BLKClKtL4FQqRfEpg5ol0QWmILoVuSCgn77h
         9Z54d8EBBP6YNtFcwOjh8CAHtc4tM2hiWchFjMmOm45udmYhM16BQWnt08qATdrkKy3o
         1Xdv0lXYW9RLUseGUKopRLClnf8mc2YZvYHcCGmrk2eCZS71tQDg9D6uw2t7m4keuynd
         noNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770865325; x=1771470125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dX3iw5nnT2kebeU8B5JRWqhNSVqrdu73co5/v4+a7sw=;
        b=ud8H0YfGwF2aP5TJw0wS5znkmSdgaDfWQ3Y6MPy1PXOFNiSXoCNHb0L4WH+sSMgBb5
         X8pSHTRiKCIZC8LqrlTTp4ZV/4iWXUfVFMYNU4jtfJlHUrSHwr9ACskKt+DcF01NLm4V
         CUycpGp90C5NhDX6nLlqYidtHJBzc0TtNun9ELX95Wwt0wcB7zEA95b/Ho9NiF1Do6vJ
         d44ByFDKHYrJLQPEugIq0tcS+kPNnQVCUSazL7OcDM/U3NdWchn8fSFoNrNH5DOT5mI5
         KardoqRIzPmaUfViCpZIoagciYozoavHywTug96oBcy1Nw6HRySwtdfPio9h/8Pa90Lz
         T+nw==
X-Forwarded-Encrypted: i=1; AJvYcCXqtcfJbmnnmPmk3g6jtF4K2EcPXjSQMomBdyouGqtOUP4Sl07QZK3HYTSG6d8+VUVyJgvIItdtCA==@kvack.org
X-Gm-Message-State: AOJu0YzXOxm/+i8nYR+vSeAPoh/f7Q/5BBhn9dnZ3cIXsh2fwQ7VjAgt
	ni4xNMpv1RCPfvMg/KhAhP7kHHPm1vHkmsLxT8b2wo6Jt3wNJjbbbuph36LdFlOUQ+p8oXSSdup
	cpys+iSY64+2lqb22OiBgv+AvIwh55/0=
X-Gm-Gg: AZuq6aLbBTh6osXrwiYHF1VWmqWIHuZ0vFb3IhXGpn1B7Mgj5UmB+E5cECDTNMqvIyw
	kdUeDhGprkAmgKJYIsJhnBA0lZc4/PfequEWXkzLmxJ3S1n1m7ugaq3sBUiVB9puirgIyfWSfBw
	nE6CCku/lDtV5EopuTWpwOcRSpKMi7ovcCXSLlx4yaPJtulxmUbXTV42RUwf76Rpn5rufMExDaK
	i2kJzvgfjEAjV6cvlf+miwlRJ5H+SPC8zuuavoPn/fyVcl03Q3olpWeAYkMmu21Ljadi+yL/P7R
	Sof9Gdi0
X-Received: by 2002:a05:651c:2224:b0:384:9158:6bd6 with SMTP id
 38308e7fff4ca-38710ed92e0mr2078061fa.1.1770865325059; Wed, 11 Feb 2026
 19:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20260210054312.303129-1-zhaoyang.huang@unisoc.com> <CABdmKX1NZJ5jOQH_9cxuxTVmn=CiCkXHK7rNrpvGBTT_+405Rw@mail.gmail.com>
In-Reply-To: <CABdmKX1NZJ5jOQH_9cxuxTVmn=CiCkXHK7rNrpvGBTT_+405Rw@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 12 Feb 2026 11:01:52 +0800
X-Gm-Features: AZwV_Qimv4YPJNpwN4YCAXWisMStWYWD6Mxr9UwBtZVgOyVzSH8eZVuEk8I45Pk
Message-ID: <CAGWkznHGm5LnNbp9pS0ru1_QPpoD968HYMhxzc2Uix6+t8XXAw@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
To: "T.J. Mercier" <tjmercier@google.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Yu Zhao <yuzhao@google.com>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: kwkecjjwnb96fjtro6y8bs5935cbx5mm
X-Rspamd-Queue-Id: 65E254000C
X-Rspam-User: 
X-HE-Tag: 1770865327-280425
X-HE-Meta: U2FsdGVkX18Qi4C4mia9VGzkprPtdyH8kIvOh1JHsZn2H3vaQjzxv+ao0XbQNXJsmIyP1AhkEwpcW8SXKyj8Y01qrp78xarYJBaSRmGfZcZKd1i9rqMAwGEmofyk9L4XmiGQuafgI8csW75D/JcH3fdzZxgIe+yLMNC60+4g1pg0Up6Z5K39OUG4/gRDFdxs/6F7446iqa+/GCPPJzW6VQe5q143jgAWxKEMgdmz8sKQ2IY6NVfmB6ZcBnZWbvC58O5nqsrAs4I+WMo3eQeAwFosDTESZT3eAC9LupwydK4/ZXRmNpHkkklF1yA7oblOVwEyNEp67L4/kiA6TZb+3oSMv2IcRh8erbKQ+YJGfIRTbg5OY0gL4TLFufLgJ3sAlXO2eI5u6qFON0t62Q8N+ztEqa/SltdhM2+8UBPo4qVSneCMG6e5eUYu1jM7GHG4IWP6kTCeRjaLSdyQcqvDidtNFALUQeJCJ9i5Y4v9nfNC0J1HkMdjrICLOxf3MzJypjChgu+yZZuDXIgS7reGK+XWF7R0auxR7acMTCit3IS6WMC4Nt5yT6Hd3PAoEYHQZq/gw7XKkbBXlWjJsO3aACb1YZkCV707rChmc2IEeI0LQC+7nS9bTsju7y5IbBONq3VOjyRM/BYqvbmsYtYbofxkcMDj2xuKkXS7KZJ4YFQsGAKm75dpIzQ20bGhAHi+AsjK8ZbkGvmndJVb1KYGXhsb1dLMx1fDafsujRkQD85PSnj83ACMAvQvhGQ+6HNSUoCQ5nYmM8aVzHj6Zv0Q77GJ2Iiyuhdl3yZk3LXfAMTTYk1YPQIN2hFFWT9BUlaMmZzep31IO1PvtimvUQyY9GExpjoCfWUxHWLIYZ/6JlpFv1tissAguxng50J5KqGkb7Hc03/Vynn7XsX1/028CxOS12VAY4GOXdgsbWYCKVEeqH0KIHG3aC8u3hjmQ8W+vN770cKX+TYw/i0+0WK
 k5dpw1nl
 MEHS4QPnrW88p/6yk+3+nmAW6XJbkEisNrmCZiC/0lhQvGVCOjvHObYt1eHszRvkUJnMUiQ8LZVrTCSQ5seBaKDywRggsOSbXsYu0v2IDXuZ8a7PlQ8Z6xQsDaRdR/Un2Ko332rFDOF4j56jtiHGkYHdK3O+E1S6ZkVbhDiasCoRoXgDsFOQvP+Cia7ej1oBBWUveNXHh+jt4TpDDkCV8FogZM6YGA1Q30v9qlbzBzXELK2pgJRl0JftZ9pFub4yNguhpNeR0pNbfKl+iITQ/DNbGlSqs7evoK2FFKsn+OTJVJR/L4aArIZca4XQ6ykr89HyFCvh/WD48IPsEao2Zd47Of+WHZFzeLMkJTwslgGM/StFET6JIU5+OeXq+q/oYWVdADHqaLhS+BWCJVsMER23Kz4ZbWWNmURMmfaCjiOgfBII6ANgp1f2wCEnCbYu5wVHBilf3SFcrtVhU1J+7T1HaWqj8KCVTwJ2zf5pvdZJzsAdNTifPQ/T0aycNQEeo+tJnVaBbj5cBbOsGRecgcmEpng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 6:13=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Mon, Feb 9, 2026 at 9:44=E2=80=AFPM zhaoyang.huang <zhaoyang.huang@uni=
soc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Hi Zhaoyang,
>
> > Nowadays, ANDROID system replaces madivse with memory.reclaim to implem=
ent
> > user space memory management which desires to reclaim a certain amount =
of
> > memcg's memory. However, oversized reclaiming and high latency are obse=
rved
> > as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> > when MGLRU enabled. Besides, this could also affect all none root_recla=
im
> > such as reclaim_high etc.
> > The commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> > iteration") introduces sc->memcg_full_walk to limit the walk range of
> > mem_cgroup_iter. This commit would like to make single memcg's scanning
> > more precised by judging if nr_reclaimed reached when sc->memcg_full_wa=
lk
> > not set.
> >
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  mm/vmscan.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 670fe9fae5ba..03bda1094621 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
> >         int i;
> >         enum zone_watermarks mark;
> >
> > -       /* don't abort memcg reclaim to ensure fairness */
> > -       if (!root_reclaim(sc))
> > +       /* don't abort full walk memcg reclaim to ensure fairness */
> > +       if (!root_reclaim(sc) && sc->memcg_full_walk)
> >                 return false;
>
> Can't we just get rid of this if (!root_reclaim(sc)) check entirely
> now that commit 'b82b530740b9' ("mm: vmscan: restore incremental
> cgroup
> iteration") provides eventual fairness for the proactive reclaim case?
> That wasn't true when this check was added initially.
Thanks for the suggestion which works, I will resend the patch.
>
> Thanks,
> T.J.

