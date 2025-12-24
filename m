Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F1C7E6B270
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA106B0005; Tue, 23 Dec 2025 22:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757AA6B0088; Tue, 23 Dec 2025 22:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6636A6B008A; Tue, 23 Dec 2025 22:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 529716B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:41:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E94DA138731
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:41:48 +0000 (UTC)
X-FDA: 84252965496.30.B5C13BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31767180003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:41:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EjR5qxQD;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf24.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766547707; a=rsa-sha256;
	cv=none;
	b=SbQcrdJ3rMv9oeszcEgIydi9xXKAYGqTMk0NRfe5FgXj24HspigwksWms/gLyERUPIlQF/
	uib8p4FECPh4oXeegOB0firlbPFeATw9yPzKgini90HF5VTaHmQt+qGjQtKrMYiKwfknfK
	7Cp3XREwi16e7RaiNUe+gQuvaMbCQss=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EjR5qxQD;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf24.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766547707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZTyEQbr5jUviYb2EwPbxpL10mEgT9fTrCuoxpdxOpA=;
	b=gntH5To4l/19pmGSc3oO7tWfPT3kLoDCJHauVAesRgbFCOy0d8KF+Bbv5IrVG4ppjui+pZ
	1TnjKD3GM2LhxAYj4u2XiXHaz+SJO09OU5k5FuHcW+zrzVbtD+8gEJD2uf5bgkwGh/8q8V
	gYslAEQgJJ7fd8M6G/Du/NWZ9hpUYLY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D72A740450;
	Wed, 24 Dec 2025 03:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85034C4CEFB;
	Wed, 24 Dec 2025 03:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766547705;
	bh=20KI9PwmKkeJtGHt2+Ga5SqcfLaOGJS1ES7ElwLbA68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EjR5qxQDtuAqdXT5FN7AhCbNukbExxsarCxKfXBvKG++ruBXOseReHM8aLlIdruJ5
	 9d3kkJCgc8l1l9BswJuTnZRjpAEKrJOWzT4O3X1TmMh3TegaX42Sa0hIN6grqAGrzT
	 FRHOkvc77N6mHpGnliGwWRMC3c+IvwYm1TGxc5yc=
Date: Tue, 23 Dec 2025 22:41:41 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
Message-ID: <20251223-snake-of-stimulating-genius-ff4cbf@lemur>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <CAADnVQLAFav8czDjCYPyjDK6Bj7X_L70WQ0eSFTwvsxxEXDzCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQLAFav8czDjCYPyjDK6Bj7X_L70WQ0eSFTwvsxxEXDzCw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31767180003
X-Stat-Signature: 56a8swqp4wag5dhmbtcwp5icitcscqxi
X-Rspam-User: 
X-HE-Tag: 1766547706-189476
X-HE-Meta: U2FsdGVkX19sdXJwMpow7TrV1Ofk5TpW4oTyQdxjkM6anA/JUCb3fdBTpd8bIB3LW8/tmaVFC+Atm4B9YZW6uWuQ9cr87Z4DsvRMu5Xx5icybdSA3/c+kOuDkP8cEPL+kcnOwo6952FQI1+ckD71uOhP8IGtSUAnytthZkJVddJ3Yte/XLaPfPp6P48POQ8djqUgkzz6NzqFg/KWmv+G5y4B7wafJzQmpAq+NHJYZrMVoEQS8Lzkrfh0F3b0IP0gF2u9Izx6kB94LKEaIpzIa9fO+zPiv1QRMZk7EOncgXZ4IAuUAS/yJUej/Ycfta6Sv4vidZlxjvMWaRC9MqDNT6MGfZXT/Z0BIuIrfbPxEuGzIUlLAMh8w921MzFpRNc0jgWAWRsTS5MPS8Wbz1RuNYqi7KZmmBnskTKhu6bgYzHpYdY6R1XPA58Fe1uSGxDalZ9jJWCOZM9J0A1MfJh8noXgr6yv0vWULV456Mc/i0b1+M1KZ1yiofLSdmcDXL6Dzrt7KGOYZhBd4cl7ofwZuGTq4QrZVh+SZvKvDOLqrMpPvPuR1UIE5LqoET2vCK7D6DCAYeXxxHF4E1TXSHCG1pI3Ze5qSiRzxjOIMqXF4KAQAzfDcDsqGeTRGLM0y5b88FIxAyYGQ0AZb6ytPbLmwQGLY/8plsZlT2gZMqHNhhfy6kXt0PIkv3YZGlfWiMc0pJR/8lT985aOgSrp0xo2VqajqT7dG16M5sdGSJuutGnjLjk2n4sxmdg3EcRxvCKYpsD/cYVQiwn24yAR5BbR3k75d1jxkp0HrOT/3LNmNaqWMt8+bSblc8UeFmKNYi7uvMX1LkJIPoXJ1MNc1fcjnaXVkvcffj2d5n9nBWp0//bscHOOl9kvLsGcMxc+0qbENt2jIp/jsmOwtHNCFiy9lj+Ua5u7g8YPw+L2aJgK82cb2FWNbGOgy5JXO6xoX5yi3N8OI9JEJ/x0EU4Z7NW
 DwJ7ILSw
 qGDwEjEY0m4UauHIpSP0mJSpTIeHiIPhDTNi88ff3zQ1r/qsDpnxhC62tKlcgo1Fgfgn1uE32m2+vn+ITGq2DpcA9lvRc28mGyp900s4tUmTrCbz02e2EwhO9v5Mb4ZCj4c9Fxnk5dxG/iiXyTFTo4B3dmTdqK9bhe7lkYUtMyF2jJ3Yx01uwrzJpIGurfZsPo+0P1dyff2Kf2/suAiv/IHzdAn+w1OjJUahRH7iHkBy0vMjiAOgeUwIHP+0ivEz2FXdxWAmmKe83TTxhQKWuL6kaLgQzHY1+qcMx9/xvroIsC7qUv9r4g6J8SfxM14IF8/Q42gWRyUWvYY1oTzmtyHAHkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 09:25:35AM -1000, Alexei Starovoitov wrote:
> > v4:
> >   - refactored memcg vm event and stat item idx checks (by Alexei)
> 
> Applied yesterday.
> 
> pw-bot seems to be completely broken. No notifications for the last few days.

It was postfix, actually, but it managed to fail in a way that didn't show up
on monitoring. It should be in a happier place now. Thanks for the heads-up.

-K

