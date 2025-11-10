Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF49CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CC28E001C; Mon, 10 Nov 2025 07:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CCA8E0002; Mon, 10 Nov 2025 07:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB9B8E001C; Mon, 10 Nov 2025 07:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8F778E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:47:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 400BA140A64
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:47:54 +0000 (UTC)
X-FDA: 84094674468.07.554BE4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B17FB20014
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:47:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IkU2Otl9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762778872; a=rsa-sha256;
	cv=none;
	b=XFoZENMV4OjI2uuyIJ/DvJkhuT+TgbF2pZD8GwDb7q5Ux3r9N6m0v3TRNZySMX/sksMKSD
	ehWIE8depHTuwPTB6lPysILFAT1/ooL9IJpycLJKqZ/QHGqMxadEsibqaTBeJH/kd0fdNy
	rHqAHtTb1+YYZ4gdjQCmfnIxm31Yi3A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IkU2Otl9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762778872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhWDEahHH2dQRnTeY/t1nGCeUgFnz+bovzFSF7V2ocs=;
	b=eYteun9bTcQVk4j9x1hmzawOM9loO24sFE4I37ZGFcyVNR1OzZgNMSKsVc3UDMlgN0ovwL
	ym0kMiswp2pNh9aaZDE8/0jMcJWH9pMgxVNt6gk1JsypQi4rRiqI8ozbTEDw2rJ8muLfiy
	CPItA45y6auSMM1Z8pzs34TlE/6T/S0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D16F6014D;
	Mon, 10 Nov 2025 12:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B6C16AAE;
	Mon, 10 Nov 2025 12:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762778870;
	bh=krQuZhwpzOYT8s7UHP2yOrtuhp6BF8s1XMfmG+rag9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IkU2Otl92+NH6dS6BRxM3Pcwe5qEi0rO36rNDsE5dHY5pkl8emxeUFv5DBGqvn8m+
	 huc6rMZRzf//W1QBka7gMF2VfdmLtp27tgCpcsM67jyG6LgnY1LYqBtBUOP7xbKoF4
	 zbiKt1oAlYsXkoYlxMjROzPvk8bnqMUonRm+QHOV0gcrKvnhdPiCJNeX0MBxx+DssH
	 Y2Frbw3m3Hs/dfpCZeLPel6eYxerTlM93oEv6pFrRKhsAqhA5qXK6p2rINmTh1FmZf
	 KVtV7Rosq7FhkeR+hploLk3pK12+4sDNEwquB7tPTUXL7zFaRlM7on8PMD8r4CYLHO
	 tjU0vnabCYe9g==
Date: Mon, 10 Nov 2025 14:47:26 +0200
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
Subject: Re: [PATCH v5 05/22] liveupdate: kho: when live update add KHO image
 during kexec load
Message-ID: <aRHe3syRvOrCYC9u@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-6-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B17FB20014
X-Stat-Signature: quiez3sfm8jeck4aofskqadg8gujhxm7
X-HE-Tag: 1762778872-508040
X-HE-Meta: U2FsdGVkX1/l0MG0W2rSUbXjEDLFTQnnhrqHUoQoFdT4xGmIvdZbqF6OQbU3/a8VgyjS56DKFJw4kXmgErk+X220mr4W9I/30hHXvbsNTTaBQl1Ug/w+lFi8Jf35Zpq9kjhdNzsLKlji8/kC7lYrfTCqYlaV6I8P8gsr6yxAsgYqRFiYSLzGXHCo2EKI5YHyM7MLbaXcz0GmBuA06Qy6ax2Xqg2CZoksJXep4mrH34gHUmRk0CIqg/qMxKs9vF0yHWtfx4dyKJKC2keh1b2RMbmh0Clp3wRykgS9lR2wcTelEXKzi/b0K0sgVauT0he/jTZrBbvrBYYsB8C76N3ROxEtRbHjOVc4IGrRVyuhgOLeIbwcNyNGqGVHevqZB3lNECCXMlYmJuBVwTkJsRBgRryFZOJVdyVLHcfx6ZR2Mtn0a2KdX2pHK7WGYDxWO6RDWSasZ874de8LP7tJ+AyiYa/ztX6qNaozFXLBq1tE6MWSDyVPrWwfTGm8QDLKyxBI/cl4arhS7Wki4uFP8mWXUYYaDFRr007bW+7sIowcr+Jx5L0Mhr+j3/9PD8aIs4sKeqV0ry1nySDO/ZOLvPfvexQOX4AocPVB13whj4+v8UfqaSQTxT3PD0V7PZQi8sUO9HuHb0y2BTkadONWfJMLKqyWgkHhfCCBONiDZKM/kYYJqCwVbiwcqmPGWnta7sSaVZDgBjfjz/qgx6Bf+DUsmuxhsURkKqnEOnbS68WOhoHEpzZuGb6cwhljuVndeL8tWDZN9VF+OQeZKZIFNPsQbf6y5G2qVqua1GGsAyVRGM0hHGkTRjOe8X43+a6PP0wG46qOzoOKQ9U9hJDYH3LHZnYklFbRtj2Zx/RfDDVgS7BFyV1ma8QNQqKl2Q7tgJXRaTcj05C7v+5MFZUCDYE4L1g+6IYyewYgYPAELJeYpa4lhceCjZhzgNdAdtw99mVt3B6zkaHRDuGa6c2bIm1
 jGhzr4Om
 f5cAlqSUcl7DQpFuvNLBzU+OaFnQrDM0xhSoUd5AL7SYLHqQX/ZQtQt8fxhtb4CmHZxAapxHRXDk4aWKfCdnJBwjxQBN01DsDLeg7w0dJoD+PlT6cylHB3lOf7f1lygqTJbK3r2cJYcXEoFKrdzLJs1DtdUc3IhibtrYEpOCbL8VhfIRw5TZ9w+IYl76fTmU6ExtnuR/+vXcJLPn+i2TOhqJ395qCIoU55OxVpfSX/waZjnBxHPGebJkH4DG44HV7k8kodkdZ93q9NiKkl3XEmX3g/XV+jqrTA0vuoeUbjnXoQy/YfM0/Uj2nDpGQ6goX6ne+vRtGbj0nWCfbqAkrltfjuqipstzY7FXEsYeoDEouJ5Z09VveQlhZjSvaJI6yEZWvnWQfbMw3uXUdUyvuVCJXEUEA9Ie5qXzuCU4v7xDATETe3FzeCM1fVLBjGGXAYMSebf/aaUrC+ow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:03PM -0500, Pasha Tatashin wrote:
> In case KHO is driven from within kernel via live update, finalize will
> always happen during reboot, so add the KHO image unconditionally.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9f0913e101be..b54ca665e005 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -15,6 +15,7 @@
>  #include <linux/kexec_handover.h>
>  #include <linux/libfdt.h>
>  #include <linux/list.h>
> +#include <linux/liveupdate.h>
>  #include <linux/memblock.h>
>  #include <linux/page-isolation.h>
>  #include <linux/vmalloc.h>
> @@ -1489,7 +1490,7 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_out.finalized)
> +	if (!kho_out.finalized && !liveupdate_enabled())
>  		return 0;

This feels backwards, I don't think KHO should call liveupdate methods.
  
>  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

-- 
Sincerely yours,
Mike.

