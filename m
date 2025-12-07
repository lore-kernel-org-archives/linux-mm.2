Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82797D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 06:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E4E6B0005; Sun,  7 Dec 2025 01:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE3F6B0006; Sun,  7 Dec 2025 01:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC7D6B0008; Sun,  7 Dec 2025 01:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 665AA6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 01:32:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D944A140735
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:32:28 +0000 (UTC)
X-FDA: 84191705976.28.FCA1479
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08BED1A0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:32:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYzcRg8l;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765089147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uh1QRLvc4hJJVNYEZOqAncpH60gQ9ZPT3pLZxcKM5p0=;
	b=jq31FKSsvIEwH4moitVneUHu/h/TONgvIxkdjJ4mvzwT3k3TCT0SQZ0WsYW8+5za3dap/c
	crx91GNfU2tke63nBJvh5KAPZdkmTHy+KeFxbDcPiH21DPxkjRJQxUgU6C70llHk+8fdiD
	NCwuun0yK//7nZdfp1o2dPurhDfL91A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYzcRg8l;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765089147; a=rsa-sha256;
	cv=none;
	b=qjY23HmzTq0lwhdknOcaX1+Gr8jpxg97d6i98d3FeSosKnXJYzIEbHfMX6TV5riu4mxFkA
	Oc33dMnejrIROOkIGjxUpn2U0+X1NCwQOwHyQPbRvPDWCWyIdydM87FEMi9qipQNQiw6Dr
	wYvldZ4EvArOZNBlSYS0pAdhMIAMKCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 644E260156
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95C5C2BC9E
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765089145;
	bh=oVDf81uUg/OAWaJGuGO0EY1SE34eHvqeotGjJ6KkTjU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sYzcRg8lpX1rLqJKe8r51xBpI/GhIwB+o4FuxyRgmcezIHSFxXzIJyS+7xyPZCaTt
	 AxVNX33X2o+EJIwxOYlVcJ+0bTdk2vn/CQBxLVpLjvPqNJ1IWs4pxvcLPhwIc/pK50
	 +okg7bxig1bSvlplQIkHqcFdTp+NULHDzXwv2ssJxc1a8dx1jE8En6m6DssmjNQBT/
	 6eoF4FNXsolKtuDjL3AmakPvVhSSvjAAE+6+nYnOZ5Tr8kKy3PDBJ5W65xmYD34Jwy
	 HXy34LgqO2AFDVjGoLT3P5jlYJ83WtkAHcLB1Q3kf0K8s9Z38+NDI49dRr3XBwIp+O
	 Nf4XQyzvd+zDg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-787df0d729dso33915627b3.3
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 22:32:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW65AVdT2V7TuYVxWp3BGt6aUYsn89UEaM8gsLQtbsuIe4uxcAzX0ORaKtkMP5Sqg4lQoIi43ufUA==@kvack.org
X-Gm-Message-State: AOJu0YyhBl7/tz8J6FAwaBehaxPBZdwzk+win4TwK2fG7XOua/+2+d69
	h0uCkXfPSnxmcLs8JUqQRj0T2hleq0VHJnXeqLGLFHg5mjGGK6EsROop6itkc7VzwMBQWloPwlY
	yVI3UJIvXy8S4k97KJlPiLkCXSe/6LVw5Rg9XiyuFfA==
X-Google-Smtp-Source: AGHT+IHr/codLrahErtYZ2jcVQv/AzDWdVQ61zWXAZeYaGUOGfU1JBV774W+OPzvLmLFz0IpfYUNGVrgkC3YHMlwQT0=
X-Received: by 2002:a05:690c:6d12:b0:787:d13f:4b49 with SMTP id
 00721157ae682-78c33afcca4mr34860437b3.12.1765089145087; Sat, 06 Dec 2025
 22:32:25 -0800 (PST)
MIME-Version: 1.0
References: <20251201093741.730884-1-kartikey406@gmail.com>
 <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com>
 <CADhLXY73pZGTvV_2wmCB0WUOecAtrcwOBoBJQc42CQ8MOBMjJA@mail.gmail.com>
 <CAMgjq7B7+=_hfo+BZr-cyYayUCUhVQWRDsC7FGpMKAXdvY5_wQ@mail.gmail.com> <CADhLXY6FgG3sdZ1CSSp5X8huFPhyKQ+LKNkd0rbo_-=gV40RoA@mail.gmail.com>
In-Reply-To: <CADhLXY6FgG3sdZ1CSSp5X8huFPhyKQ+LKNkd0rbo_-=gV40RoA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 7 Dec 2025 10:32:14 +0400
X-Gmail-Original-Message-ID: <CACePvbVOPBW64FNjaf5+sjWM9Y4BgzkHyB5NcWG7G-kUhEOpAg@mail.gmail.com>
X-Gm-Features: AQt7F2qL0U84T3yC-mIrM6bereYbjbNUNHM0whyYI_NlF_X4_LYLcX6qRqiDkN8
Message-ID: <CACePvbVOPBW64FNjaf5+sjWM9Y4BgzkHyB5NcWG7G-kUhEOpAg@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, YoungJun Park <youngjun.park@lge.com>, 
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3cjtnxhpnssqa68d1f8rp83xxp7bi58z
X-Rspamd-Queue-Id: 08BED1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765089146-917530
X-HE-Meta: U2FsdGVkX19T1bryWqW/ksTJ0WIleIWf6zvDoJAY4HVzfok4BDQcY/dOxvZwV2QP/RQtXOP0Li1ALx1OQU2iJudOxfZUz/gUsRV/XlTdXoZQuJ5O8v40t6ZORagEW2sWMgJixQqbEO4g0xSi7Rr6CRUC9wTrvDga862IbfIfzju3Vwm88S0XH/BisH4nG1LRs0bn53peoOAoYgJ3CgnFDHG24xPFYRvZTcwCnFuDR2u4Ro6lFt3doDlp5JlldOdVHueevnZDzxkN87cHK2klzBBItQ8ifaZ9yo2BZunbLm8kmPB1a3AP5EVtuxB0tDFywVFUe0yihiyHj5pa8x6mnbsZ438UGsxAaP2ZlLf+1mSjkVxOpx4ngzfjoThO7b/Zs4wnV4woi1lbct3jRj2HPXGmsEgpxPP6LB2zVQdZoUGp25CHFUoxGojwV75rSHjz1vBjCQkTnTyTrQY9TyCGGcUVzOuK/dbiyoHvrerux1iMOK4PdBkOYwYHzoVwtObYHgU0Kr5GBcsQy6FAsq5pkxi5TrLhm5/4AbIXRwb+rl0op1q+B/YpRr6mV2wLDly6Ds9RdpwzKYsXMLtuNSi84N6RyEGUD5bj9YskWqKnqZ24WRwh1qyRBvnip7LAO8IC+07cgJoTYpbEeLRQr9ClD4yJyKZcZYvF3xYDzsGerMz5Ejs7tSAG7y4Y0uIt1vf8YDNhkEESvIZKkGfVviWw1Jku0dIPqJjULNHG2/QcZacxwNJLGL9ip17mh1wdZniByONqq4gZFA1XATdGjLhcJYmVMScOGpTh5HPnw/90PmCI03aW/MG011dJjO65KnNLrYMjYwUDrurVVOO3Y88ACHsq9b0StGze3BrLUUVNuEGDgSZ1J1qJ6K3GDcEnwEYwNHDoW+Ya43gLm50yVa4FTI22FT2FwlTD5pg8HCnZFiMfI6nHoQeMya1y+q6MhUeXjKV+DAMj5MNE/W3XKcW
 JL3VwCHX
 /rai+Id6euJIYhqyWOKVReDjFgbT+HC6Wc8ZFmPaZg7dPogwVtB/w6QEI627gcOOAvUR4MimhWdEqWWYx5hVGI9aCV625YOJdgFXD1mIPh0uEpQe/f1/cf/Tvf+fVJNC/7PXfo3zJVE+Ca2I6iDyNvxbxxB44wW8L/+zcf54rOypfBf7w4WiXU1QZPrwmiEMy76/InUCeTlLXdIbQqCUSoY1Qc2iKOSQ5bZ4ZKLPKrXkBQ7IHfW0s4VQ1cp4qCxIBlDVYkd9SzSK1wVR2s0lTFn4GxQXY379oO19I9J3j50yPhnTTKvuC6QMQ6dXRECm6Wg8nFwuSMnB4IvSmN+Puj4Dzu8cjfItlJj9RYWSuVgOBLiDl5lDx5fp6PRZGN6zAYe9agy6JGrTj5sy4zPaqfiAWlt7lEP5KPcl/DxYFCsaMouXH9pl2toipyGTfeP5fXDOf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 4:28=E2=80=AFPM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> On Wed, Dec 3, 2025 at 8:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> > > If softleaf v3 has fixed the underlying issue, I can withdraw this
> > > patch. Or if you think a defensive sanity check still has value, I ca=
n
> > > update the commit message to reflect that it is defensive hardening
> > > rather than a fix for an active bug.
> >
> > A sanity check here is acceptable since swapoff is cold and the
> > overhead is hardly visible. No strong opinion on this one.
>
> Hi Kairui,
>
> Thank you for the link and clarification!

Thanks for working on this.

>
> I'll study Lorenzo's fix to understand the root cause better.
>
> Since you mentioned a sanity check is acceptable here, should I update
> the commit message to frame this as defensive hardening rather than a
> bug fix? Something like:
>
>     mm/swapfile: add defensive bounds check in unuse_pte_range()
>
>     Add a sanity check to validate the swap offset is within bounds
>     before using it. While there is no known code path that can
>     trigger an out-of-bounds offset, this provides defense against
>     potential edge cases or memory corruption.

Adding a defensive hardening is justified. Basically, the kernel
shouldn't put an invalid swap entry in the pte. If the swap entry read
back from the pte is invalid (out of range). That means there is some
kind of bug that might be able to cause data corruption. Bail out and
add a WARN_ONCE or the preferred equivalent version if triggered to
expose the possible data corruption.

I understand there is some opinion about avoiding using WARN. I will
leave other comments on what is the best way to notify the possible
data corruption. Because it is possible data corruption we are talking
about,  silently skipping over the possible data corruption bug is
worse.

That is just my take on this.

>
>     The overhead is negligible since swapoff is a cold path.

Ack.

Chris

