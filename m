Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE2EAC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94F26B0098; Thu, 17 Sep 2026 22:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D465E6B0099; Thu, 17 Sep 2026 22:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B8E6B009B; Thu, 17 Sep 2026 22:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2E706B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:45:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B0BEC0504
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:45:11 +0000 (UTC)
X-FDA: 85225341222.14.383891B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8385540006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:45:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtO4oQkX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789699509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R14pZAPKTWtI40ZADQt5vUsL+yTt0PnIysZP3xDrxNU=;
	b=2deQlSeJBQMw6e6hTNZ3BXMDt8M9MYgjzW108CCetQXSiqHkUj0HMGvLMUjJhNv//naFnp
	B7AJb5vjiRSfIU9P/KKpJi10/2yzDZbOy5pgNp11FsDB8P857SPkm029gjOf6BaOo57h0x
	oFFFTf3VVTWvlU2PgX146UkR3hYos28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789699509;
	b=wOGk5j/TFCIgT3MhEujGet5TUw7PQvztYsSKVyhq9+khM9OAWK358KxyZTBCCSUuiSxu3K
	PwBCHrGICC4xh0T/CZze1E9hLRvkh550bSmYHXubY5obW9ipiky/YGkKrqRSiv2/Cv61GW
	a63dFVLQxOlhSHJD/NUtbsIxcD9cyeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtO4oQkX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46A46600AA;
	Fri, 18 Sep 2026 02:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955701F000FF;
	Fri, 18 Sep 2026 02:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789699507;
	bh=R14pZAPKTWtI40ZADQt5vUsL+yTt0PnIysZP3xDrxNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtO4oQkXL394zylW82oIJ6NtcnuMCH0GboyXLkcRE82GQ1VqTcxYV0CF+943S/Mdt
	 eM8i0IXyTk/PpqoSKLqaAMirncYISOzlieMlKabxQO6kSXkZ0fixNLYCpra6PK6k2F
	 nLHcn8qwYISLNITyqWoIjKieG6F0PwiixB07KRyeV7oCxI5nu9iX1TOuBwDAGfIZbQ
	 a1TtRotorlZd6hMU0Cdxrn/7JtfdA2m0C480ksgtghAT7oHfVf1mgMD9ShbLrwnDAM
	 0Per22B5/ozytgIPdFZJjUqlaZ49mSwZYbV5RstHHMkopT/uuu8A2gP8FWwHOriT5v
	 ic6D8ajN5ZMJQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Implementation for paused kdamond
Date: Thu, 17 Sep 2026 19:45:06 -0700
Message-ID: <20260918024506.13715-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917153238.76020-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gsn5eia5on153zupoq1k4wkrnom6g5ac
X-Rspam-User: 
X-Rspamd-Queue-Id: 8385540006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789699509-921714
X-HE-Meta: U2FsdGVkX18QNta5Im5mF4IPU/CXha6b0402gm0x0TLVq4ZZLmKBq9DojL97zZUgmGJ0/QoWezBg+WODwcLTGObfqeTex4Jx8CxEczcQ05zwiOvvG1614yYJJEw0uEDOyggpOw0KbWtNSRT1M5pIm15PvJLMXYdWfPUTANhRF4dV9BivdgTmE0SNHZveBR83oGFe79mpizRA8KiQSK1Y03LSCYrgHuGpmgLwUSHFrTGajDEv4ll2E07cATH7unrsLMFgKkfxtVsSMpRf3d2SnoBPJEL/steGeQdnsP+2524l5jodeyT/hwmMAKOl3IEu+1c502G5c9szg55rxDc/Se0K1kGXkYMjaT5vrsQEHJ1Rk98M+/p4V/FzbMK/aj7bHvu2igrBXkih0xP0ervHBMMjL7nXHq1ejGMvuO7zmRtmdn/MhG7SG2dkE2EdtUqlQ8WypoG+vDC7VRZk6IcZgM6t1Rf3UYJ3qQ3C/B43YTkPFEExkXsXVPxI8fDbrkm+w47yglW20FqbMcgMVCpOspziPdOePBMU1Av3ORCPcEndXyvvnlYQWQHQeKU4OLZGxcbB2puIcQZEgF2qTJx5MHaboLBML7hdPIjwibqmsFNtTmDvLWsREjJhqIq9TKF4jobr21Sq1WmQ+Ja2tMK8yHExA8GiCcroX1LeR8pqGmZQ630pK1dCbUrvwii0KF9QpdkrwPS/QI0PFup07qk4+6o6cfQLWgvJeP97kqY9xRZmD7WQ29Yb6q0iyZdvk0AFbPLTkNrztLT4/AGb3OpewiNf7Ssol9Kw5OURDIMQ6SVI2+nKRKvla4HydcpANkS5E5ACdlHYI2HBn7GnX/lwrrqp7PfYMhbhk5QBd8aB4QrB0Ixhv5MeG6tAB0cNVFyX8Dk6DmSle9cylSCIIKsJ9uzZtpduCIZip25lPYY78iAdycRgiu8F4TP5MyIKmlx5Ic2tisgaK7ea+wP/gM4
 4XoQwuOj
 bwI6snkseQjSv1ZaHQLKDLxsZMWRbqQmyf1XKY/d8u4cAGyDA++ANbLH60TUH36CXr+FKi+R/HHnlIEmsbcnJVU2EhpskqtlZYHWKUuLUE7IjiellDlgBFnceHTOMaEaRRQGG0AGGSbBhDLee61w5tg0QIzneRgEVSc2jWjsQbK+XrJNAC/fjondzn9qUVG05ZX6nlYXwobOrGPvWr5Mjt3pbMNhHldc4u4QOZxoIxM7t45jjNtpaTIVaz4GqVGlUta2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 23:31:53 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Mon, 14 Sep 2026 17:28:35 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Mon, 14 Sep 2026 23:35:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Hi SJ,
> > > 
> > > I noticed that the current implementation for paused kdamond is
> > > periodically applies online parameter updates by kdamond_usleep().
> > > 
> > > I'd like to know if we should change it to waitqueue to achieve a lower
> > > power consumption?
> > 
> > I'd like to make a data driven decision :)
> > 
> > > 
> > > Previous Discussion
> > > ===================
> > > 
> > > I noticed that when you introduced ctx->pause [1], Sashiko asked the
> > > same question, and your response at the time was:
> > > 
> > >     "sample internval is 5ms by default and recommended auto-tuning
> > >     setup makes it hundreds of milliseconds.  So I don't think such
> > >     change is required."
> > > 
> > > I'm curious that, did you think it wasn't neccessary to change it to
> > > waitqueue when it was introduced, or it wasn't neccessary to do so even
> > > after it had been introduced?
> > 
> > I guess I thought so when the quiestion is raised.
> > 
> > > 
> > > Asussmption
> > > ===========
> > > 
> > > This is just my assumption, not a real use case I knew:  When 'pause' is
> > > set on an Android device, user might want DAMON to stop running
> > > completely when the screen is off, thereby reducing the load on the CPU
> > > without losing important information such as regions and age.
> > > 
> > > The current polling may make it harder for the phone to enter idle mode,
> > > resulting in some unnecessary power consumption.
> > > 
> > > However, pause feature is only present in the stable version v7.2 or
> > > higher, and since the latest Android kernel is 6.18, this highly
> > > unlikely will affect any Android users.
> > 
> > If whoever comes with a data that require changes, we can discuss.
> 
> Thank you for your clarify.
> 
> I recently backported the pause feature to my phone.  However, due to
> Android's screen-off mechanisms, I wasn't able to obtain any valid data
> during testing.
> 
> Since we haven't identified any practical issues with the existing pause
> feature, switching to waitqueue isn't neccessary at this time.

Thank you for checking this.  I agree.

> 
> Regarding the documentation, should we explicitly explain the
> relationship between 'pause' and sample_interval in the documentation?
> That way, users can adjust the sample_interval value when using pause
> feature based on their specific use case.

I think that is too much detail for normal users, unless we find a problem from
the lack of the documentation.


Thanks,
SJ

[...]

