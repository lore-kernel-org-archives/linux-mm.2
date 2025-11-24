Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0879CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F196B0008; Mon, 24 Nov 2025 00:20:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16246B0023; Mon, 24 Nov 2025 00:20:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52F16B0024; Mon, 24 Nov 2025 00:20:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D562B6B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:20:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99D7E12A50
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:20:44 +0000 (UTC)
X-FDA: 84144350808.08.9313DBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1883B180007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:20:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pAAUK8xI;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763961643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOm2KRjabHlOqV+D7WB62N+3oqxL2ho21u+fomjC1h0=;
	b=MYBt4bPb+Q8gFyL1mvx+SN4FGxJnVhdcdp8TRJ7cmPVm11qoAOZM5E06qUTWsYCVGQmBIl
	1wsi4o2MwvprYK7l5Vf5I6mPDDcL4piRXqTV9yeDXElM3Zq+ZBauvEXw4riom1rxWFYUfy
	zSggrNzau8riZYQP2zKm/hO9iWzn8dk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pAAUK8xI;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763961643; a=rsa-sha256;
	cv=none;
	b=My9i6NhgutXK/82sCTF0ogXTEUipWDC84U7GKoRsOB60R8QkBeiiL/FrfaynRArHVfPDFl
	gj8tMGGMqTxUE9lZHVjkMg4DVbUFNfJJPuf6lVorv0TX//PYJ/WX38VLw7ED5wNn0bRb++
	l45mm5ldgHtbyEVTKkDsnWthxNR/o1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8AC060132;
	Mon, 24 Nov 2025 05:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE65CC4CEF1;
	Mon, 24 Nov 2025 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763961641;
	bh=orSAmTMGafLHYjEKKYaHreeHKsJFj4UJH1WnVx2XGfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAAUK8xIBrTLmZBWd7jWub9Eap+4labhYwFwPFXrHKfjYH58DE+TRQrdbYgYf0sG9
	 vuXD2dHLbZhjnFdAILj2MFTo/QhcZJSZ0r25L4dIJSd3l7Ke4AwadVC2q0Z6STvsRV
	 c7NRkaxj8qCllb3oSoQlHonVjwSzWpYNIvhIRlzujuLmsdulFw/5nVgk2qyUOSW1J4
	 vi7BQiIv6DA4zo/yrl/jKef8QbfKTnchHJ6HEhnzrQChxJ6JTR+/7txs6cPFeS1nQc
	 i4LZU+J2ZmQIQ7aSUaCe4g2/C1mwDfygX30A8AGOqmFyPwYkRLh1xYPiyq1JIozgTC
	 8lNdE2YwlIBJg==
Date: Mon, 24 Nov 2025 07:20:17 +0200
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
Subject: Re: [PATCH v7 07/22] liveupdate: luo_session: Add ioctls for file
 preservation
Message-ID: <aSPrEfxdj8aqNsyw@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-8-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 1883B180007
X-Stat-Signature: y1nzggmottfrq73uqszc599i4qyu71ut
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763961642-354930
X-HE-Meta: U2FsdGVkX1+BUU+reedV2onvL/jiHXA4AymX0+/1iblMPIAFeaEK3zMkbNy29tGGouYY+Yr6NvmkAhbtmsLPEj+j42vGQw+jEFGMRED7lnh9KLtq3lWCjeZdiMPXjs7P8jiN0a9zXbDUGLotLEH+GyWHSr9FbVgeJRpveKmXyQ/j3lcKGGCjj/kDnr16ShfaZT+LK9WTrOX9LRPD8EP5ow1cxlKR6a++8Y8Jw/vIb98lg/Dmxl+RZUWQCU0d06F9Z7eIWvYDLVdpYi03q5F0BaYHwhHueICQD3Fpah3Lcee2adG3FkY3bAOVAnEn491xUiKqhM3aVigzrMPiZKWkxxJSy5SJr5s3ZSyxqdCGKlHaLfZsZD2qnW9O/M66T9yGj/WaFiK2B/nhlZlVVPE0R6Uksx3yFM5lFLIo6AHbEvJKNG/EIwk0Wcl4NPRtDv8TER+msJQWBdlLxX5teqwCM0GCBQTkXDJSEqw+MpmbBov7khDLGflI1QBkPh3YDc7dl0MGq5763J3Wt9EmjYUtLuOYdYIIghG7uZL6X3s5VsoPg9iPpBVG9x9N+55lvlqgQUNq2f/mc4PWPE3/fGAaJrFy8ljYCkTcWrl6RBYmIPhS1uncuY6O5DZ2ztxac/nMwtquQzodobb/wLLixHZXH3FZCHewsPac4woW8RkJXyQm3faEBL1PHvdX2fyVSG09y//XS15ZpT/5TpeY+1521FQPImD/OQamFG6ypNCRdlYtlTNxP5xPVP7kimK6JyYKoamddGrnM7UN8w9+fjAQZz3/P2K1J0aRgEmwCSpijLFboA2jOfW+UNFbC6qJcWVYBD3qHC6Z9DP9l/DJlBqRkECrWzVVwsnze/AYR2y4nN6gBKx0mOe6pi3zEMLqCwQ0A/Uaf27jINxo9ZITVFixjaicgpsGEmNf59F03nvsypUJLqrSEWFmLKzDHsqgBtnpwQOLQu3JDfQsQ/gjWig
 xzZeP/ii
 BJKsFCJ6f3C05w/XXaumzJM1Uq9iaQhoeR6xezUlD2Qz0cyIIKoq9ALnLPS2ugrieOFjlBZByls7dLwR+X2hRficz6GY5TgctVU56l37Z3HtghKQD/keaCLRzzLK1hwuoN66CAT7WIq5s6GdxJA1wZF+dfD3rMd6d3gj3/qrXdeRPD12gaZA280BOzOhDB6VixpjvhyWVxk+s1TxCJaencA/bST5CtxIRyGgrl0Gtow7ISktkFztbvFzM2mtZiM8W7k0M301YrpFVEq4wwvoI+7ORxF/siY3Wj0W9MPyJ55vQZBwbEmIpzLVVvu896Qh8lkLJs22KPRlAqVHs0n2dkzHTJVJVdycMfBBVvvWMCIiqpYlYASL+f96cJfLc3DQSR1Ffb5pyx9CGNqGqF0HAcUFB2gosp2rdBiA0x8OQVJuyeTBQTXgcjL3KmFHy/j7Pky56/6xothT0hBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:34PM -0500, Pasha Tatashin wrote:
> Introducing the userspace interface and internal logic required to
> manage the lifecycle of file descriptors within a session. Previously, a
> session was merely a container; this change makes it a functional
> management unit.
> 
> The following capabilities are added:
> 
> A new set of ioctl commands are added, which operate on the file
> descriptor returned by CREATE_SESSION. This allows userspace to:
> - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
>   to be preserved across the live update.
> - LIVEUPDATE_SESSION_RETRIEVE_FD: Retrieve a preserved file in the
>   new kernel using its unique token.
> - LIVEUPDATE_SESSION_FINISH: finish session
> 
> The session's .release handler is enhanced to be state-aware. When a
> session's file descriptor is closed, it correctly unpreserves
> the session based on its current state before freeing all
> associated file resources.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/uapi/linux/liveupdate.h | 103 ++++++++++++++++++
>  kernel/liveupdate/luo_session.c | 187 +++++++++++++++++++++++++++++++-
>  2 files changed, 288 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

