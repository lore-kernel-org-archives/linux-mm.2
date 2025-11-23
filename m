Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D23DCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 15:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F646B0093; Sun, 23 Nov 2025 10:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777596B009D; Sun, 23 Nov 2025 10:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4226B009E; Sun, 23 Nov 2025 10:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59CE06B0093
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:30:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10F981A0BA9
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:30:14 +0000 (UTC)
X-FDA: 84142257948.22.AF8A15D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48717180012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:30:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ce4qJKQr;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763911812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8KRwK7DvqzlnQNCL0oXtflM2bQPkYQJhpY2t7nau4A=;
	b=BAumt/Y1aFgkf3XtmHZSuhadNtsAH6MGHoyf02dZ5SJzADBI6zffbUsn+hF4kFvfZ+IhCR
	SOilmkLBB37PbNuxCrQpuggcxQXvsKpXf4uqKywry6nEoHb+iCk40n1bAKBPKnFbJh8dLW
	3IF/PcC+WIH5Yakcb1nhNp7oaNZl5iQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ce4qJKQr;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763911812; a=rsa-sha256;
	cv=none;
	b=NZSj19cbUIjcmwHA6sOVsMlHet/IsHTQJ+N5YMsrK0hLVrzBtPrPRMx3Zqfxv1xwe4pvnv
	8zM42pBKEZ2vrmuf8SiH3Pma7I1/lhARXqGnfEqnhKMGSuNQqfCilXKWN/DuqoRi+BRyNF
	hBzNHePuCwDHd/+xAVcAAvzdbGmMQ0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4199E4013A;
	Sun, 23 Nov 2025 15:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75988C113D0;
	Sun, 23 Nov 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763911811;
	bh=sbU7eVp3mgDSt5xPnwvjDRc6ZpRDTkp4dPpqxTd0hY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ce4qJKQrDFTadmY+pK87YrLjQwwpdOXw9MPMemJsv5q6V5VTAgKNpSVXXF1HMX+gW
	 y7ITTZq/qNsL893/WbfpCeXI6PDAv6UpSGA1e2QWGxtfOQ0t+Y0oyBVsChod3uc5X8
	 uHrh0JXcsUDEbg5M0FdHOx19+BgL/yulj++EH4t50HlEz9gHX5HfsO4SthhtH3cz07
	 Lo0dhFZMQmp69FEm+D4zkH9UOhE41QiB+AwudQFj+L5hIZI4O7HTkx/BpGcnc6Z7Hd
	 z8BbYh1Fj7L6Jj+6jcnpKI4TM+UHGJAEuBy6lmziXqPX2tjtUFN2MqVhuraE7EsrDR
	 DLHQ1ynahlaig==
Date: Sun, 23 Nov 2025 17:29:44 +0200
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
Subject: Re: [PATCH v7 09/22] MAINTAINERS: add liveupdate entry
Message-ID: <aSMoaMlYwSh9oJAL@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-10-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48717180012
X-Stat-Signature: 7wtyzy7zcsosk7qmcudsmrdjo9kcw9t3
X-Rspam-User: 
X-HE-Tag: 1763911812-212189
X-HE-Meta: U2FsdGVkX1/h8vPeRjFnstgCmvFOsrwoRDVzdNN3Dp8+uSL/PGn1BkyzInX2YNEPLMO4Tx/6tG3MV4XFaSHEfiKdn0DjFDQhHgcMooEwoMVkQnoij2TNb4Maq0aY+nY+GuvZx+bijPgUKjlGg3WEwkFRbufTPn2qKTqnE6SLFjA/xDIk4QE/Czc4XEaMz6T6X1cYm5UkQXEWLlZ9eCOgYlW3cm769gC42DLBM1f5bR0uvp8Z2ebe+gDOP6+sKq9P16n8td04ABjRA6P8csoksgn6AfVL8VTBsIglcY0ZrA0GFeDZGT132AV9e0l7/SIVqpa1Xjas/9ZYfcpr+wT0r40wt8yd4diLe9QEuwOezOpbd4YU59w2QjjjDxwHauMKu0PZn/YznJ2PgJyyzIHw80j7lX/69hGKOtzZGYFACmy8BfvJ6qFYMCyW3Pt9/Rz4anEqgaLS+aWo4V6/FEDIeKssvZpp3bqtnwslbSFZ2HCaTM0BHxF6p8fdH+NEQsFWf35g7yObm6jCn1+fmybyZGHw3jkHazbEpgRHeirE58ejmxzRs2LjIzuuzS3dpxwSKI6tZ2SBdtJf4eZBu8fTCi1PJleh78cuYcnv0iYOR2bb7A0Pp6RJ1eMN7dPRHFNFP9wXMXuW9MuiugAWbEOQsdmbd5AbMHAmvHCVFtswE5etvsPe/46xJskC1HoEM3VEq+r0vQtCIEpYvXiHoJIVE2kWfITkdcrcaWNWX5l6F/I9vAIY/JdC4YVRs8bQKlX4UW1eDmZxT0G1H9CfzX0sRgyXvA9o9EOrNzNxFe5SfeAurYUDLRg8cUGdGBBW7lCltxC9P4kC/4nnX88XmVlvgW7LGCBb+ia22jp/MDZF4BgVjgABsfkwE/DLJ/wQzm7fd6MuiMSl6HXxsnu36A1GH3/J97evAF9zEz0kBeEwStldtZ3EOD5qMc8Tb2/7XPFkthdzjQggaxURl/ZkdXJ
 cJquXqiW
 yPVtsNVPvNxXbb+lUPKreKmo3URSUL0Zapkv/q0J88uiR3zDGvskI9R00qvvpJGQyBpYuIaZbjYOa0QO9ZnMqIJbmp5f+iqxQ+hBINLzkcn76fTmn6Y/iWczw/mossoaPODttw/NS0czUi37w56TReUc5AR4Z9nQnNStD98L0n+SsCfkq0YmAIDYADEBbvpxcrgUfuMSJhGdXSnZhhWj9l/R1dqwu/KwM+IncTwqdJae4w9hYvg76z2d4Xizb5kwY1RdSMrS92P/2ciOJS7hGPTDAoBmh5U1CnXxlAJjuZx0SZr794RpnXjeXe5DmzBXQvDgY9emnh85y4jvb/XyyLFGv4vZ51S5yQr2VPok+82QI4SHFBUtetHJwlOlHnK5hffy4IdPXbKnJuT8MrTU+ex+5CCtPp0msTo80
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:36PM -0500, Pasha Tatashin wrote:
> Add a MAINTAINERS file entry for the new Live Update Orchestrator
> introduced in previous patches.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b46425e3b4d3..868d3d23fdea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14466,6 +14466,18 @@ F:	kernel/module/livepatch.c
>  F:	samples/livepatch/
>  F:	tools/testing/selftests/livepatch/
>  
> +LIVE UPDATE
> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> +M:	Mike Rapoport <rppt@kernel.org>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/core-api/liveupdate.rst
> +F:	Documentation/userspace-api/liveupdate.rst
> +F:	include/linux/liveupdate.h
> +F:	include/linux/liveupdate/
> +F:	include/uapi/linux/liveupdate.h
> +F:	kernel/liveupdate/
> +
>  LLC (802.2)
>  L:	netdev@vger.kernel.org
>  S:	Odd fixes
> -- 
> 2.52.0.rc2.455.g230fcf2819-goog
> 
> 

-- 
Sincerely yours,
Mike.

