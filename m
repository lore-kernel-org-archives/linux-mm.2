Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD99DCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 14:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9546B0023; Sun, 23 Nov 2025 09:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1436B00A3; Sun, 23 Nov 2025 09:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DE46B00A5; Sun, 23 Nov 2025 09:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9B356B0023
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:20:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E9AFB669F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:20:09 +0000 (UTC)
X-FDA: 84142081338.05.744046A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 930C0180008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:20:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbj1LkgM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763907607; a=rsa-sha256;
	cv=none;
	b=UpSG30pKBxqTvQqThW7PUUqH7Ew9zAVzYJyK0KnjXcjLqQwZydv46BI5Q1FXSgjeoU/3UP
	L9C0MK4rzlpySnqLSBwUk8+Fj+5f6v+5B/u99uRGuLgbLj24SJemHKKL5Z8zkgmODqW/gF
	TCARNh1EuidOhKdwQ528cNfVV6D6/rA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbj1LkgM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763907607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kd+i/y4lRUeEe2vX993cUaAI51T+sV9btiar22RIqj4=;
	b=a4bslcE9eCezhi4eGvZUeYkASX/plgLRnqfCMpQrOIsbknw3VYgcrfL38nfEdowtS9jvYC
	QLeHfH2ObQTxmF5cZqfTE1qr1u3vhCCTcipEH0lp1cNlzi0pv6VPJemqENGciNGfpYtSRv
	wBC44+8gu99z5lJEyWlEvzef3/d4tGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E1E841B33;
	Sun, 23 Nov 2025 14:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6C9C19421;
	Sun, 23 Nov 2025 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763907606;
	bh=64qKRjSfixLK9vi0MfPfl4EUkAb/R9lG3NziOFUwlpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbj1LkgM3jpINAAlPHZASq9E3rN1aUM0DEUqlztUnBTcbaIhVD5eucAidAB4gfABc
	 Ib/eR9Q8tzeGw6sDgEvkL2B2/zkTWfjhmqk+7ZyH68Xbb1DS+tynJuS9mqdEBbbf4v
	 av9ekCTiogcXBDCTmLSZPjlqmBa4qJFxmIprQYnor2Dfd/5TFyU9KRunnRPopVmGeG
	 gpb1oBc8XkSK+NB6gJ+nJP8Gdawd4HCTlf+VbyUAsMpmj9ASWyh46Zc3etlr+NodPZ
	 l0wLWZ7K50Y+YCRxWSjcr3VMVTEDGNMIUiWFXJGScmfzRyWPEnqc1rEJTmIEt++v8u
	 nNVmbuEVxqR+A==
Date: Sun, 23 Nov 2025 16:19:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 05/22] liveupdate: luo_core: add user interface
Message-ID: <aSMX_pnUShilO_sj@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-6-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 930C0180008
X-Stat-Signature: tun6mq9yn4coa3h9j959ixduhwhagumr
X-HE-Tag: 1763907607-329619
X-HE-Meta: U2FsdGVkX1+QQvel8xiEGW6WS2VFSNx1Gub9/ujLrgd3GM9a/WUY8T7omHVyn2H0PnZ+2hHRZcDSOouP1+n1KK1z/BEpOQl0kNMNxcCETnvXbqAsdrYcdxcupGEHtxWEbgiGijH6QCEhGojd4XozxRcguIPfWWxaUFowbk27Lcdzpj4nzknJpHIgql9aBV+dESCvEVJwBQvW5gRnvhr+R/p3+laxsdWGUfbhJXGjeGc1VGupNwVU7mKRtBZ74W5/knBKK3fVJLXdwIQUQMKm5R4PLyL+eDmVPVraxUgGt7JxRdyrs84V9Ux6Do2r/FoSW2Ji1YgRxmd2WXKjvnxNu/edfqWKcTkbUszPwOjLeAlDjm4za3TjL0Y9tCZkHoUBASd+mGZsIRnNpgY+zC9lg5mO1ScNbqS9tNVTl4UdG9lEH7vksxBXKNnMybsCyo5481jk2oNHkVLrPw6bIgP3QEX6jl9LhIpSW4QR76b1fdaExSY+BE0iFa+vZK+4WNNRBVRUFLa5Ftao1Hp1K6v8zl/eMzNMGNOf5jN7UEdjpaklbmzA/nU2Sglhg+ZlVvez3VqaS9ZOSvmC9fcw0iPJVSbDz9oap+LQww2WGpWgFhNScYBvKUjkKpWAqq0ZNbLH3WASXRJdJ8GapB8DH/6Z87uxiNuxFOiSDqfZlOn2SQkoMhtMVBeqRYUbuMorZJY/0W5YeaKwECeDBpCYM18T8JJZQKAy0BGLwPm66aDlOLIIv3CSEjiSSU8BLv/qP+jlaI0Lj/JBmPL+0ntj58RVnUj6qaNys/EY5NebP3zRlkSzwUSJlgbDyddb6U5NvQeNG8seeMNo1BynAU8PbHiC2sG2URTNUgDboNMINJRNsAk++CZyHeBnqKzRSdz5vSoYBzGVK4LBiz7Ihgw/tiWStQJH87Cummow2yT5q3LOCpMTJbX5K7dxZywunB99Uy+Eh18dWTDtm/hBSSceW3A
 LUTYP0hC
 XNzG+R+6QazWP4j3dUQ/9XFxOcEJqAeS4EIs/wZVbJU8yhFINehb49CjSLW5QlWcHFZ1gfeArpFZ5IdMOQSOezv9w+ze/W/49iDliNpmLMRQ4Pv+IXkZ8HlgisDUxeZXAPx364uo6wpH3EojVRJZzOS45dJiJOTZ1ueOBusNHYvgWU3Vy7kYRR2WQpeTocIPEgbihYN4TcpVjxHV616ffmYow+J8bGIyjx7Vy0WlVXjm0JkYJykOktYPday+kkV8WXBFQoc/mOKNWcVzJ7O5y5HVRT2/rw9MIAs72cLv84c2s70VAQC1/PPUBVqOZCn0bPw1XzUQ9o+e/Z7tiDe+4g9nMjYamUCIL70P7U1ik6umBYCnpmSCoiVXLrEU59wKjNMae+PdVY6VoAkKwejr2TvpRnZck+LnERVgs+R/fz3l99PF6sxLsBXNtWtatPgF3XPLjdUnwQXBM+p8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:32PM -0500, Pasha Tatashin wrote:
> Introduce the user-space interface for the Live Update Orchestrator
> via ioctl commands, enabling external control over the live update
> process and management of preserved resources.
> 
> The idea is that there is going to be a single userspace agent driving
> the live update, therefore, only a single process can ever hold this
> device opened at a time.
> 
> The following ioctl commands are introduced:
> 
> LIVEUPDATE_IOCTL_CREATE_SESSION
> Provides a way for userspace to create a named session for grouping file
> descriptors that need to be preserved. It returns a new file descriptor
> representing the session.
> 
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> Allows the userspace agent in the new kernel to reclaim a preserved
> session by its name, receiving a new file descriptor to manage the
> restored resources.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/uapi/linux/liveupdate.h  |  64 +++++++++++
>  kernel/liveupdate/luo_core.c     | 179 ++++++++++++++++++++++++++++++-
>  kernel/liveupdate/luo_internal.h |  21 ++++
>  3 files changed, 263 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

