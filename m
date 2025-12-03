Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9C8D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 02:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B4B6B0024; Tue,  2 Dec 2025 21:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B9B6B0028; Tue,  2 Dec 2025 21:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A916B0029; Tue,  2 Dec 2025 21:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C32E6B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:54:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DBD7132CC3
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:54:34 +0000 (UTC)
X-FDA: 84176641668.01.F86DDC8
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B491A0008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:54:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d5/eOTCL";
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764730472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgqQ5mB9ifK1q+vTQ66E0Na2/SYOSjNSJXfxIl4Cpj0=;
	b=s1jBlBRZkrhXeOw5P++p6z/omjXSJ56aYQ2zGil9UOBKYA16yGYEi8Sb/a7XYWjwDcVYZg
	lt9mDLFro318jSoyzI577p5uhpx2xyzUQOrVCPt7W4qYNflz3B6kw/RZYi4/paFooI00LP
	TyPLb/fZ2PrLhRYp9nbaXXyqnpAt40w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="d5/eOTCL";
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764730472; a=rsa-sha256;
	cv=none;
	b=lxNeH/HtyAT4fgUyMNchPM+wfT5eKmkmim+0PnaBO+Oxfn7eEzLgUKJ/Y/8l4uHmyfkvvE
	2X7vhsFLxRiau56r5WYKKNmD/gY7BCmLkQeBoo/xR3E+dpLckoM72zdjK1eAaPmFWkIbGk
	JVXqgXUlAl2h12B7+hQrgu0mAhPJhqI=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so3729753a12.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 18:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764730470; x=1765335270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgqQ5mB9ifK1q+vTQ66E0Na2/SYOSjNSJXfxIl4Cpj0=;
        b=d5/eOTCLsqO00DdhYuSDsDdDk8bC0azQYx+SrqUKrTiVY4wDJESwwN6VmLye7bp164
         zaQreY6qKK8Xt15mIiuW1gMFkJ6jk7J6rLZqDoW/5nvzBzyOhLO9mgGtyEwgpc9Eop+K
         ku7l5uMjitOkyOnwFnP9hYecbOxxJONZbi3P6Wo5oicVwlAwoL/ylGaueCg5gUTJPH64
         wgO1b2+0vtGiExufH85uZxlNwV1tUqowZiO4vxTJoVOx29ga6gCMGOXIN0jGTWUTDC+x
         VeHeBIZfplwuSUnefUfFDowunNikexVV+CRu8USnYJCrRNYuDrZRmP3R5fq3vxFeTjFK
         0bkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764730470; x=1765335270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xgqQ5mB9ifK1q+vTQ66E0Na2/SYOSjNSJXfxIl4Cpj0=;
        b=bsXHdrbd/lpZAPm7DG1AxfL0eOyyx8CPidPzfGNmu6j4HHKScV7rML/twGft85tr7Z
         M6UJ58FeVkDn6jsVTijLOVzajoMRawkinC8jZWUCFqIBEqtb6n1Qbqbdc2pWKOrzo1bv
         z+z6AL5xUM7Bo9xt8y7qdoMiYXI1b6zCTJvNojcAU9M5YzsvEeu87rJsH3bwxDi3p+1U
         g25+y6rgpv8QgvlWVkyDDSWMLckhKZ1E3cS4BYUeGameq21SWnI7skrDx7PDDdRmUrnS
         +MFIzAbzLI1AqC8W2g9TCwuE5Hdo6YYSceXLdpq5o4Xy/wj+Kw6EkWDyFscAnG2yhxSd
         ljVA==
X-Forwarded-Encrypted: i=1; AJvYcCUK2+2C1SkqSvAobk9NGBmyJLS+vUOckoeWvHzTPwD0JQzRLa4U74gXkdI/C4IbgVn5SLoG1yAQIA==@kvack.org
X-Gm-Message-State: AOJu0YzAHuFSQXxNtKGTlNnfBP+xcXGi6Iww17BSYRVS1odpiBtY4NZ0
	hEUWIH9AYrJmuMhk1fn5ra0BLRx76kKavw+Qm2qPBIHm7uuRbuefHGsRFPBMPyLbvY9yWD2aPtz
	PUy38MMUS9h/cAfmG/mzpRABcyDo18z0=
X-Gm-Gg: ASbGncv2GzaVtF2iMQEoT0ua218Pc5MCA5o9ZOE9LMyYUECvkJMKM8FnifCLFvSh5CE
	rcCj39EpWhrBYVpY+zDCvJe7DN/A7E99P2gMOX786g/LvWG/uB7OCLyT39kyp/i++CmYszk0nYI
	YwgrP8JOBdwf//bfpYk05T/tMEfvKBHnjoemc+7FOx0KXPC5O0nYaB9qsGZ2x6FmAtsFi/U+am1
	LerVoKwQnkNqZ4uOHmzgGSPJaB/1yEjE6V0fTav70XzwIhrpM0Y78I7PZLAeBmZw//zcW6LJUtK
	19cEkDF8HaTSJsBoN6I1T2w909BACXbJl6aqCQ==
X-Google-Smtp-Source: AGHT+IEZnHyU6IpuWDfQCNM9gEOaMQRtzw7RiaFjLr1oEl9F8E82Iw7MIqW6rMI1Oa7JVPuoQ1jRrreMwmJSgud525c=
X-Received: by 2002:a05:6402:3490:b0:645:dc63:d467 with SMTP id
 4fb4d7f45d1cf-6479c4d07f2mr469396a12.31.1764730470434; Tue, 02 Dec 2025
 18:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20251201093741.730884-1-kartikey406@gmail.com>
 <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com> <CADhLXY73pZGTvV_2wmCB0WUOecAtrcwOBoBJQc42CQ8MOBMjJA@mail.gmail.com>
In-Reply-To: <CADhLXY73pZGTvV_2wmCB0WUOecAtrcwOBoBJQc42CQ8MOBMjJA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Dec 2025 10:53:51 +0800
X-Gm-Features: AWmQ_bnv2awiqXpmXi1Dz3y0QimTJ-oGJaFqHbWRPMt-fFTe3-SPeHzkO4KAVWI
Message-ID: <CAMgjq7B7+=_hfo+BZr-cyYayUCUhVQWRDsC7FGpMKAXdvY5_wQ@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, YoungJun Park <youngjun.park@lge.com>, 
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4B491A0008
X-Rspamd-Server: rspam02
X-Stat-Signature: osntci44mnbgfgc87n9w1uqmic4iuhzi
X-Rspam-User: 
X-HE-Tag: 1764730472-183488
X-HE-Meta: U2FsdGVkX1+yK5BSOsEqZZNYD54xsG/wUO3XPPD0BisVw5IHuuvVISeZIZ2xjQE6GYlrbwnzF1oEP+hMUFvXqL7hNkTixCigWaDd6EDnOWYjBBPf1NydWzVKwhLxfwdVUNdeIMpfz9HvJ1014iPCyjH4o/9Ppl8rFazpsLfOBOWYf8u5ik6cYIinpc80A2EYR7bUvLBGgtOv3XTsw5HR7iC9JXxJYDsCDy/fTZx99PogVsWJjIJfHf7MjKNH1vLPjYOn1J1uXgyyDrjk2CJJr+F9zVLpcH/eUl2x3wTJOxM6ErUIdvoDThFw/U24+l4nFH5dX9ECXDVEVyFTY1zPZBVlRs+7+IlSCGWTYynTLEwn/WL/VbWYCmxrC5OUVy27Z2Kaa8OTArgrg3CWJ7b9fFS9lkWN7kJpe0jQd+DJ6suxEdM2SVtgUN+CwCzqFE5pbNAMPljkdRfiwpKjeE/tSura3kOuw8naburgXIa+cWDpRHGa05PdwP+QML3UQmqdpxJBa3/nZ0JlrgDp93kyD/lsbA0mCdit+9ltRV58D2KVsSiQDIpGoaw2Q/ZXLwHQOERlnd8jB4zxmKAm4QATlFtimvR9hTgKzoGTL84hJfIhCUsz+gwWSX1QGIS6Tadd5tgtqMr3Ck96YVQ7EXURWfS/aUipWtcFQU4yBJtyKNkBWm2qjkEf/9OHMCnBTJnyDbeRxnEAwSXZMmWUlAVcTn4spnnf98SuP0VfkO7AJAGqcpO9AofqvMXfy0ck0X6r2RFYtsaLQar1YFEHzLxlAKr18kL1KxCEeWvjOzcbAB5bD3fpnzM0hNupcu8U3WOWfeCwgRXR+37tpMs3kB7XLHj2MXpu20cP+YbC7RJacjiRavv9QGsDQo8OJ0wli6RBN+7ZoPUO7RwycrwxRwLkwxO0BcS3RgZMwNizD70pRQw9nLsPE1b5DPifdkACUwwx2n4JSU/Ff3OXHcOpTWp
 BdSZaKjA
 sxVxD5WCvb9kRPk3MLpJ9uskBb2yWxhNgGDGSJF8m0PJDpRFmndbZlAy13GA7/vycdaIu5AgbphlO+DOXFeKFbio7mHhfgoecKQfHtdLfp67YRc0Uz7udxxUo7E+rhEM6Ib5IN81nm8dMw4ehp1POq1yVmPAdVrQa+A1I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 6:48=E2=80=AFPM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> Hi Kairui,
>
> Thank you for the detailed feedback!

You are welcome :),

> > But it seems the report is no longer triggering after the softleaf v3
> > change right? Checking the syzbot link, last reproduce was 11/11
>
> You're right - I should have checked the syzbot status more carefully.
> If softleaf v3 has already fixed this, then this patch may not be
> needed.
>
> Could you point me to which specific change in softleaf v3 fixed it?
> I'd like to understand the root cause better.

This one, I think Lorenzo included it or a similar fix along with
another fix in swapfile.c:
https://lore.kernel.org/all/CAMgjq7AP383YfU3L5ZxJ9U3x-vRPnEkEUtmnPdXD29HiNC=
8OrA@mail.gmail.com/

>
> > What kind of race will lead to a invalid swap entry in the page table?
>
> You make a good point. I was speculating about possible causes without
> concrete evidence.
>
> > I'm not against a sanity check like this though, just want to double
> > check before we process.
>
> If softleaf v3 has fixed the underlying issue, I can withdraw this
> patch. Or if you think a defensive sanity check still has value, I can
> update the commit message to reflect that it is defensive hardening
> rather than a fix for an active bug.

A sanity check here is acceptable since swapoff is cold and the
overhead is hardly visible. No strong opinion on this one.

