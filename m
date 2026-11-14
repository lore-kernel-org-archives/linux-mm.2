Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E7B606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 08:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YcE1Ljt6
Received: by kanga.kvack.org (Postfix)
	id 001976B00EF; Sat, 14 Nov 2026 03:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4C76B05B0; Sat, 14 Nov 2026 03:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B536B05B1; Sat, 14 Nov 2026 03:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5F6A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:28:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6A304028F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:28:05 +0000 (UTC)
X-FDA: 85433046930.06.3DE6E62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D898040002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:28:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcE1Ljt6;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794644884;
	b=CysnHWLN6wIj2BiV/oM72e3BwnpZHn67pAYqz1g55M0Ti3FirfjowPgHz++pq3D2wX0yRC
	ubtI6HSZxzYVNRBDRTEKuYks3A+C1eiu0ySDXsw5aPjohviHr5H2q+vk910YZnhuKTKBy+
	9Py9tODuC7oVM2zMCeSm4AfzwD1HDbg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcE1Ljt6;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794644884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gHCfmiGqQPfU62xPlRfnq+u8RwNgFNlDWZiEFQPyrQ=;
	b=tajQSVar7pi11fj+nHId/0nSxuBpcBK5FfRhlnd4H2E+gXP0rvUcsvOyAaTY+GLUOG9BEK
	z74gh6i6vVG1h4Cy+pOfY0suHlXNM0M4W/rVsl9T7SnV+JbE+pzDGLCoLVawOGZZJwWnMi
	xmiWvoJu3DOqJPseK6x64y/DJBG/fcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72304606F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1A41F000CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794644882;
	bh=8gHCfmiGqQPfU62xPlRfnq+u8RwNgFNlDWZiEFQPyrQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YcE1Ljt6epSgEly5U34/+QR6tkGf0qcgcV6KULQXKWynM3vdfdbKNblapq/CTuGF3
	 ITCXavSOx1maFDdqAWDrLE+9oZr8oqTl+gKVJfYHBAvS86QPq8Qt1iIczzr3mfnlJ6
	 2CVv+I8UHQS/lRWxn1w02tguJPxKHNz1x0MEo2n+ekF0Aw4CrN9GnkBZdq5LDkYcn9
	 fvxndh6iJcVY+q91CO2Z1Rr4AzfWIBazCBIil7zUBXbzPz/PkcUF5zDIa9Wupq0ES/
	 GbDZwZXW9DOYcsPGeCiiRzQkXi7yB9RA9pS/oEcc0Itje2t1TSaW/l8dbuO6orzzY/
	 T74XIdMsYi1Dw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9494d734351so265016685a.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:28:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEm/0heuhUhr8ATJQBngAtBoh+j+1RQMojl7uDqjfzdsAicqRUzCOnEq/76HCtwjbGTrqmWNLShwg==@kvack.org
X-Gm-Message-State: APuU4Z8H9lMcSOYZHrNunsPjO95UR68gtoeEaCg6GvMOBuJpbifgtTzB
	IMKBw5YztuNk+MytkyolIDv7j3V3+rV9OqZbeUUbU7Ljz0gFsnCxYQDNEYR4qsDg28VXcRtouge
	1GQ3rlynTQAkHBjcdJEDcSvoDCH8WJNo=
X-Received: by 2002:a05:620a:444e:b0:93e:c12d:4eca with SMTP id
 af79cd13be357-9493316e8abmr1273094185a.42.1794644881841; Sat, 14 Nov 2026
 00:28:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113185541.70203-1-baohua@kernel.org> <20261113185541.70203-3-baohua@kernel.org>
 <sashiko-outbox-214021@kernel.org> <CAGsJ_4y0KR86ABy5-Qpmk0ws0LMXB3nZTOcnhPL_Orr1_f26-w@mail.gmail.com>
In-Reply-To: <CAGsJ_4y0KR86ABy5-Qpmk0ws0LMXB3nZTOcnhPL_Orr1_f26-w@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 14 Nov 2026 16:27:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbDy8Qy=5yqmn+59jfxPm3WOgAH7zX9gwhJyO-6fiT6A@mail.gmail.com>
X-Gm-Features: AclHuK-HHm0r3_yTuBm_b7NDYPGgc43xeC8btPUPpzMn0jANzlAyNSjN0s2JVcw
Message-ID: <CAGsJ_4xbDy8Qy=5yqmn+59jfxPm3WOgAH7zX9gwhJyO-6fiT6A@mail.gmail.com>
Subject: Re: [PATCH v8 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D898040002
X-Stat-Signature: e6ntx3sycyptrtyj8dxbj4571thp34f7
X-Rspam-User: 
X-HE-Tag: 1794644883-307810
X-HE-Meta: U2FsdGVkX1851j5RdiFOtiWA3h9pgj2gkYGyGTxB30HHia+o41tWDFhcwHStZvrszxlNcEjdusolOnjEdzt7OI7ihxp11as3exhxkrx+ONceBLCkcZXTMFydpxhsFUHHXhGqb8Bl13+UHhsZQ9GQ0QcidGhFFKPqvo2HZLBQKnONCwS4G/gRcalP5H0u23jT5Beb0C8D7QTCfdsoJVYJu3G0aSENPaxKvDZ+w0pRKIJpXKHPVcyA1jJSy1ZmT+FI1ImccI9qwZnPUc9rmFWgXzNQ387mah57SKmNDKC0zlwiAfgzbQyUPFRnbMwWceXym2CtMjzNP64CkCND5AJW3d7cNdQQzZzYrcv1+ByxShXYRS6aO8/NUdv2g9/uIdwREdL4mmGiqr0AvXnJS6xAKPiJZrbOYPIjzvZtGhI2YP8S6xZPnRNIj0sJR0lGRkIOwJC6erCScz5z//ccDhSXoNXf1p1UpPfVvB0tugpffpJQ9WdPzPZDinjN40PXK4WB666mYpFlgFZZKxfwguE0OmAA+xaX6qpYzVEwLcGtiGgU0Ebauu75fu3QIa0bd+bhxfAZR19WFTfL9hz/kB/vXoFlZT2kKGwIgjIaBqFFW9XFPDYtQ7yVeo6oxsgFDQLERRVTzeefLyaQEDSQBhVnsL/ia3KIWH4Oayqr5kovjXzPbiGZHDtbA3HpnBw1iXLcpEmsxun0HHz7eyrpAZC0ZbbC2Hy3RxQSLSU5y3CsIpywiz2tyjUyRkEp+k6nyKe/2ExH7d2a3fTY9vn47PQ6W/CXzO1aF0XZhfSH1/Lej1lJdc2svLD+CFC++xoWZLPggUSg05VBlo78Zo37hn8JsFk+xtsqoxOWrarLzWOVOSAXUShGCCUEVSHrhat0xT5VBTyKupIwPhjOvVWee9rlEHp+7oouFezNg7jEdTRf1SoSLyH0WCclJvpTIEvM0KToKnvYHXJ048PdQfX7Biw
 kn6stYpQ
 s6gn/CuYfueUHs2ewXDoX+54RdrqcRWWE/UxKJV+oQgXbzXgjR/RyGBd7WM/F99v5pfpe3MKnz1FD0+/ZpVRYOlz9BktTHEeuvvl5mV183CpKkMBFhRePH1gQl4D0StsUC1/yHDt6f/6TA4BqPnGqJH/t3aM0M8KZATy1eNSamO1/NoM2uOBwJyzmPYC32H8zRWb6H6gbivKPznCvxGdcyeqMWaJNMBQ2ti4zL3/joFxTRMRAf/PPQ5HA0rDZQKM5ajSL+aJBTkMctURYlHP7VsUwFtrBcZUTHsvpVvvDmf7xymWROe5MPcNmxsjy00wre9/epOuZxj2lcByQ28eOj1BOU3fWfQ0As/aF8ofixRk1TEofVniCq7ihR+nWaHuA7BHoK7mBhMVpaZTIQT8knExn7/p64crjRomb+LWZ5eYLTYUafW1Y6GWk2jUBnUFffe8CdAX/xjdhVayqQxn/FEQ/rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:27=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
[...]
>
> it seems you are suggesting the below:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 18a3332c71e9..307a7cbf5bc2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3995,7 +3995,7 @@ static unsigned long
> lruvec_populated_min_seq(struct lruvec *lruvec, int type,
>         lockdep_assert_held(&lruvec->lru_lock);
>
>         min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> -       while (min_seq <=3D max_seq) {
> +       while (min_seq < max_seq) {

Discussed with kairui, we'd like to change this line only
as it might save one iteration.

>                 gen =3D lru_gen_from_seq(min_seq);
>                 for (zone =3D 0; zone < zone_limit; zone++) {
>                         if (!list_empty(&lrugen->folios[gen][type][zone])=
)
> @@ -4004,7 +4004,7 @@ static unsigned long
> lruvec_populated_min_seq(struct lruvec *lruvec, int type,
>                 min_seq++;
>         }
>
> -       return max_seq;
> +       return min_seq;

for this, we won't change as we'd bound by the given max_seq so the search
never goes beyond it.

>  }
>
>
> it seems to be simpler than the current code. let me give it a try.
>

Thanks,
Barry

