Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449E4CA9EC3
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 13:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6036B0088; Sat, 10 Oct 2026 09:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957116B008A; Sat, 10 Oct 2026 09:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8455E6B008C; Sat, 10 Oct 2026 09:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A65B6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:05:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E380A1C4247
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:05:54 +0000 (UTC)
X-FDA: 85306739028.06.DC03B20
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 094C71A0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:05:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoswexsZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791637553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUgv8qU2MJmYgliXxK0C5ED2Eb+oFUrhcbBUDF3fTq8=;
	b=IO3+Jeh2YS+t+s60AcuwHJ1FYADfKt19tkLIe44+hXB4cD/R2dZYG0Kxg7xjn7YTSATDw6
	1dLMaRq2a/TmG7MY0egj7kweXpc8cHdCX0DgYCQCCxSyGqhUIzvNZJBrJnUJSD++53K2J2
	hOdh4l5YpNeSzIUsWe5JNyyuTEKkFMs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoswexsZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791637553;
	b=zk2TiYc6sOJqDaKbb8J6RAK9T5zU65Z0eg//nWPYBIBmHdQVw3Gyu1UImBRqE0OsxOFjNR
	wvl0c0YLu5/yneVXYTk6V/b4kMm0fVOpfBxna7LQV6q3jV8tkxETs3E/n2u6TgzutBpJxv
	QuHZZSsLuHxk0RlYdsumRBVUy0KpJEY=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ab8d96d02aso3878607b3.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791637552; cv=none;
        d=google.com; s=arc-20260327;
        b=buftrzkTNifFlfS8e1Xq/xaUuGBF4AMTFjmcDRID3v+glCHYdHVzBFFCuuRoRtUAG9
         k3rqfbc8DJ86xUE/JQMjrZLoSqJcoSUBevcIcp9pJoTado7J9/hN1yph2kXhEolN9Pp5
         9xk1ON3wDrXC4dzAGgo1tQLj6NFUf8VE134NPs0g39lyXE6FFwyhCYxSz4ysSXZANhsN
         6MKp1YyiwHm1PuLSJH3G6lZj32oRA60zmYskvA8wK1LixqX/7TQ+MlZRAaHqFfwNwoxM
         ecpcTtPXsMAfSx6Mfs/k73XNG8YjAYEAF2yrQOpSqFFVFLuvMWHax7gqcjT9tMwjB9hK
         2gpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dUgv8qU2MJmYgliXxK0C5ED2Eb+oFUrhcbBUDF3fTq8=;
        fh=SqHzPS6i4EZzku6oG9nqnwst3rKQEK7PKCfqbe74qw8=;
        b=CenV0CprGd2Rnj8B/eld5hbwpLTS6wRZw5dvIU+nbg2HkiSY2NZ0Gl2W0kKX6k9zSl
         BKbqI+kRFHzPvWwEQq+mTwTqi2nrVw8IBVkBAuc0n8cl7n1ZcJRO77NgOexEM30qZYR5
         b8DSLz0vd3lPF1s7x37fL7FkXNLhqxZGFebExw97FhSkzvYAoD/oW0J4N1ET7DHDzAXq
         OsqpeXEiPByJ1CiDkBjdXOnHqWmDNKxunaZRVJz4JIVvNgRpVQPBRAEWBR7FFmxOzXmd
         n1zey8nkzwHNJP3Pja/g/A081mEG1GuK1wNqyWddeFPABNLN8YXJ1sj0xTfRKNgZ8nfh
         TyVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791637552; x=1792242352; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dUgv8qU2MJmYgliXxK0C5ED2Eb+oFUrhcbBUDF3fTq8=;
        b=DoswexsZ97J2iWFtX/IljI6LrWgVFRqdPXMW9f6qfCWzOAbh2iuKD+BI0bqEshkIMo
         o57ZGdzNQ8gF5foKNuO9z5IQt3lX9gFJYMUN0MebS3l4EWxpEPCvp+6ckoWZ+u5tk/XA
         ekBKtFiVrUjq6i2JQ8Y9UACNbFroVY7GpRoaJHR/aOQzeQcLXyLVzqvxQGwS9d45xy1g
         +csvwhwFiKGjyrzQXdCHSOIa8u9N+t2mp/2krTjyyEdn372Lo0NQ8RQ3gF0szuRjpPXc
         HfF7XsAWWDS8OFBpOvxXyLBjr1S35hfgLB9c7YWoz7HwfbmaCW20bByObbablPUzgAvD
         PQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791637552; x=1792242352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dUgv8qU2MJmYgliXxK0C5ED2Eb+oFUrhcbBUDF3fTq8=;
        b=ll9qI1ti6JyaELkD6dnxK7QlBum8Z6WalHD3I1VHYgZEJsU9CdclWT2oWK/9BtDFEh
         lRRMw8fR3+Esyn1Tw8x6G/7HmTK3EEu3RwQjCW1lpk0+vBDuwx1Zt7qmuHOzyuRd4FJ7
         3xivfdsfnruzsl0IhdOgqINfpcAOADZoceF2V04mfa6ZCHtQK2YusLROrgewunDuvMTz
         jwcNJU4LrDkp0fj6TSTX10Ij0ztXjIrUvQOgv0vaKpq/cRCXn/CBJU7HiuCiuxsTHZLt
         9dyjlDe6LeyYG3Z43tWKjHpHN0VwkV0SwrtUBSvPieRVeVCKhYpm2DJhSLlKVzzP045H
         G+gQ==
X-Forwarded-Encrypted: i=1; AKwUvByKb7JlI4vd/sD8YcFwi/AydWBDxGjeB6+izQF/XORw0T9klx/Zsi3Wo9cZLfkEx0HyCM7XwJ26UQ==@kvack.org
X-Gm-Message-State: AFq9FYKwp/SiWnq222yQVWHO3btXnpNbzdZQ+pmE12HiSBGUeBK9YYmd
	8LHyhLfRLGlfG4r3os/tIlKTESh1QbuoF7CyR3T2xZi0kHYPH8nzNGlgDXVqfTDYX/SQTucEBgF
	2zxoEi1Z8FjOYlUdZGkEhyXaUCx3L9oc=
X-Gm-Gg: AYBFou1XhjxFGWLn/e/99IjfNniOtUZLHWbTTPIYnzfh+KmlE2iRAcst/7O/oduMjMk
	0kwGlY2QlBaR9dB1evhXaiKTyp0ZAcoo5UxlbqHzNUWYdEgJU1rryqlaSP02TE5PPLfQ2gjw1Ie
	GvBPErGHo/u2ymRlqtWggarx9luhCuwuUyuh8xCamU3PmOkAHkMYRSAz0xrZSys4XH8D3uMMPb+
	v6eUdN4FZtRmb+dx2UGSpP2qqjQ1CpbX9h2EJzSUWWME3PUngq7yYK3M0iRU/3i0ZpW8C9VSdrl
	R1+sRorxpQEC8s+kE1nv53IxhJTf769zI2PmXXQQIz5Xhhu9+SUpslw4
X-Received: by 2002:a05:690c:85:b0:882:31:3af9 with SMTP id
 00721157ae682-8b07ebe12aamr14950917b3.9.1791637552107; Sat, 10 Oct 2026
 06:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Sat, 10 Oct 2026 15:05:40 +0200
X-Gm-Features: AclHuK_ZZxWO5VOmv-dijVsfp5Dirw-cleU_Ss5a_ua-hVf2p2vv9lQol9MPm7Y
Message-ID: <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed service
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: jianghaoran@kylinos.cn, avagin@openvz.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 094C71A0004
X-Rspam-User: 
X-Stat-Signature: 9u6ynuhs95azxc4mt81ymiiw1qfmjmoo
X-HE-Tag: 1791637552-372901
X-HE-Meta: U2FsdGVkX1/F5yox7axLpihYNcNTftwt5JgnELsfeYdIWEn8Ua2MkjqprTN8kOp9EEOjEmnQbDhW2kDhU0tGx2qS00ZBv7xF7AMQF/XdguiKIaK8edek2J7cfkFkQSEPRxryQnEFGg9hT4tLuBA4JIfKlwJFG7OQ9MtOXlrVdm3mAr/jOa0gzRrchvtfU1P4xHPCTKgzwP+FMSbUoJnhqD+fUkG7uAuu3D5BDPy8QtySY3oKmtsFPJd+neOFgG831J6B6EEDIZpQYQv5SpneCC6ndhkuEV8hbq+q0m5EQ3Zzrtes4Bo9NlgUgujx7ddlQ0Scnaw3h3g83YBk4tFM0Ce0xMo7zxIylptLupqzrVbQKUO7LR/28AU48hwjV6LPRv8end2lxxdjQvkIi10hQyr+mlqpcBSTC6qwqzN1VFosTAtatgrtduxypmF1LmFPsp1IVsvoMeqy8Kc7SO2nXsM+d6/Eth/G2BgDB/KvtWE2yYyuICzyxscdv1W/L3WzMDPLDjtaHdXO+vy2YFb9aSLpUVn8rk4iI97Kh1vvDkUt9dZMW4nMOJH/8vSFgVNyFEm28p4wKM02Hqb012hjIn1g9R14kR2+EagtcnmydfYddTD5JB69GzYcIWpV3HjmKYIGk9/BroouTcU8RqVitchhg7tQnoJFCMXYH41BMYPnb29k5p4Cdb0RM/lxIJ5JLjaDh+Ese7NBPElpkYlyNSCTj2SLIo/C1vuJhtXsnsGJ/FzMx+EH8WcSO1HHuMF7u4GSG7CT9zWHgl6yXgtFyss7ltl1FHudSo+dEotba3v9vQGOPPfGKx3sZTxuUrGVrR69PJe17+JBap1+F+IaOKjtcvRg8HPu6wcVY7D1ZptHlhAKXzGYWDDB1Ps6h2vK97umaGtbfwPuqKsbL0raWyqsu5JtwVlznigGnKAfEXnt91aTDzqB4pdSbGFgs/iXbcm4kXRbTBrCMzGiQD9
 86Jz77IG
 olSbrtz+Vf+AsrB4Q6WgIA65PUhcGCFcFWsRCVBFufoTklcFs5uYAaubajesysx2KMoIi3Qqr5QGkmG+XN+eFTwt1giLTiXL8zxkzOYdhnZLz2bJmPuEQjxN8DR1LF/I0Abw34hbryaRGd+d6uvJ8tKF/4WjRuk7o8dwP01Wt8isaCBiZ4fbcAOPktunql9jff3AWioaLystvyznKLpyChvI3c5DSky1Hn6GSwYXL/cxhTzArVkEztGfE8169SaQup0QT+jfQQzB+TqMt+e6Bn6PACZgR3kGaBtOJAycYfzDPrdGABLddHcU21x5/OHoX6mNQeVMCrd3/CUZiJCQvUErDDRYj3653R8V/fakrEY3iBuNpnIS8R4ZRYgmZDk16hYLxXf2eYlGNRW9WxHM0pCGIYcqUplVJokDlvgG61MqATKQEfa0KV7BqnuTVphn95Ck/92hAGIurSLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.cn> wrote=
:
>
> Hi Luca,
>
> I watched your excellent presentation from the LPC conference in Prague.
>
> I have a question I=E2=80=99d like to consult with you.
>
> I am currently working on the `memfd_luo` feature in CRIU. My goal is to
> leverage the LUO capability to store checkpoint images inside memfds.
> After a kexec reboot, the image data will be retrieved directly from
> memory instead of from disk.
>
> Here is my pull request on the CRIU GitHub repository:
> https://github.com/checkpoint-restore/criu/pull/3152
>
> In the PR discussion, avagin suggested using systemd as the CRIU daemon
> to centrally manage LUO sessions and access to `/dev/liveupdate`. I have
> watched your talk and read parts of the systemd source code.
>
> From my understanding, systemd currently provides a unit=E2=80=91based so=
lution
> where child processes can inherit LUO session file descriptors. However,
> this approach requires the target service to run as a child of a systemd
> unit. As far as I know, CRIU does not run as a systemd=E2=80=91managed se=
rvice.
>
> So my question is: for services such as CRIU that are **not systemd=E2=80=
=91managed
> child services**, how can they obtain LUO=E2=80=91session=E2=80=91related=
 file descriptors
> managed by systemd?
>
> Thank you very much for reading this email. My knowledge of systemd is st=
ill
> limited, so please feel free to correct me if I have misunderstood anythi=
ng.
>
> Thanks & best regards,
> Chenghao Duan <duanchenghao@kylinos.cn>

Hi,

At some point up in the stack, everything runs as a systemd unit, so
it's only a question of figuring out in your setup how to pass the
FD(s) up and down the stack.

