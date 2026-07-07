Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A54BC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C61E6B009F; Tue,  7 Jul 2026 17:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C906B00A0; Tue,  7 Jul 2026 17:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA766B00A1; Tue,  7 Jul 2026 17:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34B66B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:36:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A0831C3BA0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:36:41 +0000 (UTC)
X-FDA: 84963290202.08.9927B34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 627D840005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:36:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJsOeSIE;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783460199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfvgbak40ISEAt+FEvvSkwOEo6xkg00TCiXxZ1jMDFI=;
	b=xFLaYtETjaMlhaF57q0Az6jYdN2XXUTJg7xlnkPwniPdXBjF7hmqlveGxxpUYBgN3eTayI
	YLDTCURSUWN5EipQxqjeV3Pb5raY1j1DVKEMJKcpGWyk5fvC1+FrYVGNyZX9Ip798PSTum
	ndyg6YRrMIrmNv4lEdLHBl1wnMkHXuk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783460199;
	b=4QST0JPOjUpVHfSaCvrJCRWlsVLx9IfimM97TpCJaAoHLeZrjxXkrs/4BzSPtXKKDJYn0t
	qhD/h6cJOJY8q5tIDSHssVhav7RE3NRNWl5VaDcKlzfGFDEU8QetRNzBxCuIXlUtXR5J0p
	zS5zyi9wsFiD/4mhS+GqXr8vcB1XjUE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJsOeSIE;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8941E435CF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1831F00A3A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783460198;
	bh=mfvgbak40ISEAt+FEvvSkwOEo6xkg00TCiXxZ1jMDFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mJsOeSIEeV2UmBonPeaqEf7COTUt8n6mdPtwegRTmR9V2CL8iymV36hqlrv6mNFwV
	 DjFSroarFd/XqCvyDJtZih2xiXGOPgvmgcSfadydp96b6gvyMEXxGG0qTYdlgJNnsj
	 DdctrHdmyO2thFrusKyz3daNq38RorUr7vPlYVA6NcBPo7b9ehUDZrTps/KzYb/BnL
	 4zyc+9xsXk1ZSHdbhON+t/oOjEkpQoAJs8n9WNOkWb3s5ccjyM6dwaUL1jtqgkF9gR
	 4LhvOxSkw2qomni5RTLX5BJJ/XkBRsVdQpaoHuynohTlfqq4QOGuAvk/uqEq+98j2N
	 LQEqBwDx6TT5Q==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c159f0c902cso287435266b.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:36:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpQLmHzG3pahuXJo2yG200VjpkpSjhvcaAWH2GjZ7erWXHQXTY4i9wFG6O68aflC0Fdf4W+8ptndw==@kvack.org
X-Gm-Message-State: AOJu0YwN3U+A1YcBKbB0ylXUUUhVMP+fhAshNGC0ht5fXe1H84PqIZGR
	pAYY0PxtC3dVdKAZwJjuXXoH7Ahgea/xqUb47NbG7aoCIm/4EMDAb/6j5IOru/3NCKqaSXQ2pqz
	BcHaCjm2k/mo3nXjuARGDzT1I1z8ubQY=
X-Received: by 2002:a17:907:bf06:b0:c12:36ff:6ebb with SMTP id
 a640c23a62f3a-c15a692b12dmr348765966b.44.1783460197298; Tue, 07 Jul 2026
 14:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com> <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
In-Reply-To: <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 14:36:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
X-Gm-Features: AVVi8Cda2GhPqDSknVsY53Q6TlEfuCwJntD2kTQUNKYn1iwv3Wq_3XPV_UqjD2Q
Message-ID: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 627D840005
X-Stat-Signature: e6ixx9krn3g5siwiz1ff6rbygp7k5kf1
X-HE-Tag: 1783460199-801507
X-HE-Meta: U2FsdGVkX186+0NDlmEs8KaIksVvaFKEsfN29DutAVzsDlLU3QU5TAJipDd629HVF4GNJp9lPv9KOMxaxPt+0/NOmF1LqeBKBRhRjaYwC2c2Wp/MERyuqUL24HFYML387S7kttTzN/4DFSiSO0V9DdbFkST5AIVHXqaN39UMoAtGk48L9pn5M0ft/s+fBOPWBxM+piWFNbjrC31y4VaLWAmefv2E7zsvxvw89V8D2u01FIBHxYdfEUfwCvQG+R6jwWE7R7NXBP5Cpoi7tyIkptv3cUtrA+XlrYS+4BGPhdW+5lZqybjVk8SZLHUcpsleSEEY9XayGmci9adjmd7q7MEPHQzQ0iNJRfNmhh4/tHT0gFO60xBSU7s0sdWd8RG8Ld4TaavO5U7suj/kg4ExZk0JczpaLAfBT1cGVpkHcDt4K8EJ6/bZiAPf+YoT8pXsa34nqJJZ50wzY/fTBnst3xz69t1MIgbOVYr4fqjLb6xd4aDDI0t3lQyi3vKgi7yijstfPGjsn2xpYpj/5zyLPi9RTxd1IHoylSQuBRlWmdSyUtj0vq/KuQxvZMUdYxSg4iebAoN3skJH1EIdIWzt8VCj/iIhcWGscHBl0Trinlv1472tRG8mGZJ2GChnUtYgZEWozvHPuMVLwUz3blH6XgrmbpEjIIhQww4jQzQR5WpXYYZF3Ci2yAcyNx+KunxGFcfPyFegmsvfsrIvqzDk+fc9nSHlTpS7+8YRuGIgtj1jNMGzzaVnwFb86CWgC9iaUHWjI78psXBsNiV/zyuFU0zNE8dWOWepx4jd8mXCrgj9GMQyVOR3C0iVQ/nsFxAMxSGaHgQ3mFF+ryGm6aKGgsDUCm94PteFkAkEVytE2B4t5FbyWDULISmQE4yB5KNC0GZ2k6tbsGipoyEWTdg1EfLQrYmnjTpNy3U0aTMD0vOfZk8soPgxj1llK3BCZ4mzvENIu/IAXhRZ0Neh0/T
 JUPtGFja
 H2YSqfbRMHBv3e3/BeXLSpZSbtjAPsWEm2LW8GAAfVX6n6e6KJtDKQmiatAzGZmPezf9yfluLL0Nna4fpkgZhZXYPakSSgLlQ+eg3J0KkKR2gcZjiy/GoiScAeQ53ETt0O6KSldWtiNAuHGypuAk2RFQRKyr2vYsus5VJ3myvuCKcSAggkTjFs4dMxpbSrL2gy2LtyGNqgsHu/1my6OgnnspA0DzVS/Dy00fKKOsqfOD2z45jX920C81+CYWNCsnGZobbLsFvpS42J1DqGFsr3njk4Ogdgxhvg+09pExqVbf4fW2ui74eD8Hd8k5rq3d/9hE4ytXpMUc2teuliPg757vbXMI6eWVHg3433va8cqL9W1zlSUoRKJpeyF09I952xJCr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev=
> wrote:
> >
> > We were discussing a way for userspace to explicitly trigger a flush
> > before, which would come in handy for testing. However, we decided not
> > to expose flushing as a concept to userspace.
> >
> > Unfortunately I think the only way to "fix" the test is to allocate
> > more memory, enough to trigger a flush on most interesting setups.
> > Perhaps we should scale the amount of memory with the number of CPUs
> > so that we don't have to keep playing whack-a-mole.
>
> I don't have a good idea for writeback, but for zswap out, would
> MADV_PAGEOUT work here?

I don't think the reclaim mechanism is the problem, but the fact that
we don't have enough pending updates to flush the stats. Am I missing
something?

