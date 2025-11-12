Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F160DCD37BD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A51B8E0017; Wed, 12 Nov 2025 15:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C5D8E0011; Wed, 12 Nov 2025 15:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9B18E0017; Wed, 12 Nov 2025 15:24:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE548E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:24:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10EBB160620
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:24:26 +0000 (UTC)
X-FDA: 84103082532.28.2019939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45882160010
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:24:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQbgQLw9;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJO5Mlv5L3YO1HhnW49gfBbXtzg4tozwhai+dggc8pU=;
	b=GERDO674+WZ+7ppgL6HXIQ1C4tScg7Gaqat+VlGkPQ80csr0ifrERCU+GMgjCw3yUTwXT3
	UopU6436mDOOHOjg3VZ/HDBZx7hxS+2pP6NRkYPgvpPA0ALcIU8rmXTkzga2R3IVTsAqUa
	LlY9ShBCQa9CmfvaCtDK4eTExv+d/ZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979064; a=rsa-sha256;
	cv=none;
	b=fUCS6/mEH+TqMuwvqDe3cRfN1VefJTk0J5Q2a3Na6WSwxEGV8jQeJqPrqlVyOevoiJuYIC
	xXPi7fp4Lx1a2baKqLALKLislxRsvkHbdYgwIdt3V/f948X5ekfoEnVJ+724T9+tlUNqJb
	XBHuHv6Arm1IEAFh/Ln2uL/DnR49NEc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WQbgQLw9;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0147B4169E;
	Wed, 12 Nov 2025 20:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09228C4CEF1;
	Wed, 12 Nov 2025 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762979062;
	bh=mwcUjonCzzMfZYdyYUdmDpwyU/fnuOYn/CICWev1Wls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQbgQLw9P6lFKBibAUmbYpSG8Kc0wXxdq6DEPV4fot9A8Q1oC6lf/tQLmW3FpXmzf
	 qPCka0jwkKlO0iXyomcWRkBkvtD8Vbh6IeUouYmzxc4zjLlXFrIDKw+zN9TcibDmA3
	 kKrDOOClHAVnPGzZD8sm2BtDGLYh6R8Ah/qLCCyr4KqWYmJNVn+BTx7p58HNu7zK+u
	 osS1a4WSO0TQ/dDij7iWmGThiI+x15CS5wutDKmEuCHdJVOaHz0R9BWvwqk/W/34C2
	 YF+3vFzxZBtnxFH1djMCfeY6S+cWfnL61EpWx0F2ygcbKJEmGW2ZqapHGLcxWwkLsa
	 yrAZl3wZLOt7w==
Date: Wed, 12 Nov 2025 22:23:57 +0200
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v5 22/22] tests/liveupdate: Add in-kernel liveupdate test
Message-ID: <aRTs3ZouoL1CGHst@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-23-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-23-pasha.tatashin@soleen.com>
X-Stat-Signature: iugxoz678m8m9ztzipzbsqo9yiygdisx
X-Rspam-User: 
X-Rspamd-Queue-Id: 45882160010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762979064-166982
X-HE-Meta: U2FsdGVkX19XeP4UlMXLnKA33ZOQ/p4iBj6t6rzbHe1yE1mDh3LquDqMKedxZue0x/sstDGIVQvUXx9Qj/3Fyx6WdMmmu8a8QXYH6SzJPxHPcNj1VpvquZbi2n/imtVhcfJ5bLY5Cb8jePlvcTwHcRdA5ytvPrGjsSUekamlLz+0w02RiJVWHvchNeLjz7sLW05cYuJm7RZgyTEwnfo5Aiwt0b20+4Z1uKNDBc6eak+qRpjrBcOAfsjn7zAG1reIk3ClDOyYw4gsUN8/oYU1aBwCdV54+rNwkS3mvgQ1IqyRlYUH6mNeaZFar9xYOowL3w2Dj3RSltFLc6UoB+LYffBoF0azIuFctq6fEMrgCSHdVg+9euUQngypfQ64DS6/h+v2lVyGWkkppjSBf+s5pTiIZnvQLPgpJVDlPRY/XtkBXQu3MddwbB7a8vGiGGBP38R4J1X3mEQOjgtME3VTJIlprk7fSsN4hwq15zrhc8MgjFaeDd7VVfagBQklLj+LV+6y+31it7fDS8vCrkbSZ2cjBy5Z5hH2eQ1kPgCbwABzTSf161l9TRRdfxIiHHuMjFnJo2nK/9xGGnd/0HEbuVDz+5dgWwvMbLjca/Fr9XKI3GTHBInsF8tzdSkyKhJKpzFz0HodaXpL/B/7ixZkeAo07xpALmFMM0vTgpS2gwwJ+aK5v6XFbwOtzQI5RXoL5EsPBiVcngeIsjPZlKNGUQnchCe1aSea/6i02nTtmkZDT85xQlENkKgkEX0GbUA8YNZ+IXZgEylV3M91hLV6KZohwCyIdTyCQRO9q6856IxjO9Of4ANR9L5jPNOAedF3HiFu9s6UiA3J1+lOvTAwZMq90UbPAoKaA1aM6bZATEuZpDnQxM3bUSzeadf8FhSddfQEMgsin+Tsv0c4koDNV/Vq8rxtz80cmnJa7SLW42BzcOKWRxS/nnHIE25WqgyfwmdcYfK4IK0Rg0qMPAM
 THUWqmBJ
 tlIlMmlcj1wjaxRzjRzdAYC7SCcftEXj1f2GK5v0w/cW2WHHj1qrBXKVVETYpmIsG7TruBjiDOmxPrFhXks7sp0jzDDd7gFKQOolhrXaVQaFXks9WRAgrQw9AqkAL+tOD8W3xYcE5ZDU60IfetaB1SyFoIoyH23qZgYY15o0w77aCKundo3/gQCk7RvRGccuPIjVxUL4pptScsmWmAq4qjZtn6DKRQLdSQbXqwoMPpiSP5DzgaMPl2S+gtF5kDK7pFLYgI72OMvD+RX2ie9egT+11nI1T+K7gq22hfgHla4eihq0otnYhX6FyMVgYLhji0gKYHR8BBTKXGdAPBJd9DQH0JoiDD84IGZm40nmlBIMI1zUhkymOBGoJdJrYWTVnH/yb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:20PM -0500, Pasha Tatashin wrote:
> Introduce an in-kernel test module to validate the core logic of the
> Live Update Orchestrator's File-Lifecycle-Bound feature. This
> provides a low-level, controlled environment to test FLB registration
> and callback invocation without requiring userspace interaction or
> actual kexec reboots.
> 
> The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c     |   2 +
>  kernel/liveupdate/luo_internal.h |   8 ++
>  lib/Kconfig.debug                |  23 ++++++
>  lib/tests/Makefile               |   1 +
>  lib/tests/liveupdate.c           | 130 +++++++++++++++++++++++++++++++
>  5 files changed, 164 insertions(+)
>  create mode 100644 lib/tests/liveupdate.c
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 713069b96278..4c0a75918f3d 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -829,6 +829,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
>  	INIT_LIST_HEAD(&fh->flb_list);
>  	list_add_tail(&fh->list, &luo_file_handler_list);
>  
> +	liveupdate_test_register(fh);
> +

Do it mean that every flb user will be added here?

>  	return 0;
>  }
>  

-- 
Sincerely yours,
Mike.

