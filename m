Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B2AC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220AA6B0088; Wed, 14 Oct 2026 13:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1DB6B0092; Wed, 14 Oct 2026 13:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8636B0095; Wed, 14 Oct 2026 13:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B4A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:04:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74BDCA79CC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:04:58 +0000 (UTC)
X-FDA: 85321856676.11.EBE5C4A
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf21.hostedemail.com (Postfix) with ESMTP id B37FE1C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:04:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=qv06QBle;
	spf=pass (imf21.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCjxRI/1UucUHvaeIcUViXUqt5p8iwVPM2SzBLBHxOU=;
	b=Ch54sMEWigkOYnDOR+PwxbbMGC27GzNidDkX2TGUTUNH/DNKWrsd4Xa3RocX+VBxbn+KTZ
	mF1wI6gu5SVXBLB53RfPgBV9Gxk4LsJ6RR13kHmNVNTClSxEdyJ8pbT7fSnqUjS29f1gLN
	xSYCdL6ySDpmEK8iepV+SwlfvFdE7lM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997496;
	b=3CQBOXImsZBlqGZPaikP/HMQ+4w48RErHsmIf52PCAjiWMPSJM3X32s/Ws+iJm+nPg+Z3u
	ggFQF9lwwmXaFy/d9G7fmhuyXKSisTMrz+//kTNBJ2bKoov5dMA99zQrQw6oqiU7i0eju/
	dsEP3/UpwXD2CRIxtqAb6hdjBQV0xIc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=qv06QBle;
	spf=pass (imf21.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3A5F6408FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1791997494; bh=RCjxRI/1UucUHvaeIcUViXUqt5p8iwVPM2SzBLBHxOU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qv06QBleGDAIMEstOLuVTvUNPvAoaZhcuiqKiPrg04DAM3o0TmiEB89KwASpFbZge
	 kEoC0jy1t+h16V4ahw1xi9W+hOooLwfUIJVod4Za5E6+N69nL+NfQTCgRLAWKoZ/OJ
	 Gb/CapkaBBp1Az4RsLAxlMw6IhkVuWtgsjyse7sPHVqp8AN6wF6mmnZ0NKcqUrAA3z
	 2HjSYpKLNwFAxmUbYJegpuEYN31OTm0dJ/NNZGv2MF5BsUJCHPLf2wN9X8VeXWWJ9v
	 5C2L7hfF9GEXsBjddW/70CZ1RvUy0vTfEoLC49zX94saqLwU+Ra/o68d1jJKd2IsQq
	 bmOThBNvn6Grw==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3A5F6408FF;
	Wed, 14 Oct 2026 17:04:54 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] docs: kernel-parameters: don't mix cmdline options &
 build options
In-Reply-To: <20261003213508.96424-1-rdunlap@infradead.org>
References: <20261003213508.96424-1-rdunlap@infradead.org>
Date: Wed, 14 Oct 2026 11:04:53 -0600
Message-ID: <87bj8ww6ve.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B37FE1C0004
X-Rspam-User: 
X-Stat-Signature: zo6f97jeho3tzeqpcq319x7jhpe46h8w
X-HE-Tag: 1791997496-378984
X-HE-Meta: U2FsdGVkX1+466a1byOLRW3MFnVe6NMyBsqYwikP+i1ICr2SiV9a9X8qC7LoHmpUhau+MhWcO8S7xDPI8t3zlKZam4LkzpjDwqdyGoAt/MVfLmtMfJ9eUtehtlPheHFAJGwWlTiCxiEyTXC3ERqP7Gg/TKNvHqNcaOug0scVsX2zY4hDb1fOCzLh3g6ukHmc2uIaV3gKA1rRi79/i5pRh932aLQR++RY4dY81HYb4o51FI9BhCi56v0MzTpFOs0EliVAFfxwN79WpB/MMEjgV0PsPQRG6RQbZOKNhJXmGTyKygvhGZ7EYoJ9d01Pvy0gSWHfAf+JIjWD1PAhtHQXKbY2q9fsVngHDimaHYu7Lrt4iS9gmBY75LHaVRccGrBmRo+aGTieNWEwCVhF9DfWgna5qClbiPdvSC9WBkg+821twkih74+XFjjfKso7x+vTfrGty9sai6dkVwTL1+ve/IXINMn8NhCZ7EYwoXt3Y28EmyaTdfx3H3yfEE9sG/2MNc8pcMCbXzgZRAWCr0GbR2WYP44zQ+I7YiGZOKV3ipfXJzmy9OGhX2dxKE/wBDqXu5CzCEsfnlHp3l5UEKDWJHq0mjN4SmN4ko5uzvQAuecTiVvnBL4q5XLODTmhB36ZN1ts2eyRy3zZUJQZbni6mTnADN9NbEQ0mem0nahhaUwV1UWn04Ja8zh/oBeqy3feI0AEEOJUJbsGG5gVnqcQ/jodWACCM1NsOrNtGw+E1prVSxUxrce9Z9FQ28i+Q59Y5izZN+ZbEvKiK5ZFjYORe4BZahIO9MjWlsozv8M1XGYyylqGpN5+Y+zz3yTHKz7tRZuvhCxkVvJ0DTwsck9qyfZpxQB32wXJ37V2Li8SkjFnOGK3rWsPvejo5fa0bL0gcBlfWGQQlt8fJIUVme/A8oMZidf66RfvHuP4L3JEB2WfucvQR5/KQgvLyzMfFTli28CfQng64LLd2/XBYh8
 EN+O7dEL
 HkGrS30aZVgK977NHwSbGucaLj6xSwT7qgs0RzaiRl3spa+CYyapaRMsVqU4OPSXUU9dGsYulNaSNuROEXN/6XLrotUO1dhhSNhK9W9WhlYdvQks5K+YOe4Gy2zZWwy+fPkUzUaNfKsdLp3Qzd6v8lRD/i3lhmmODGBqs8LhhO90IJ2s3ZkqOw+NiJwQovUvdfQOXgWKGjfmloCVcJ49V09v8anfKLp9DbkqBqckfPZNE3Yg3+wE8ggZ9zsuU/h+E/vPv//umHIxja+vOnrpbIL1GHuSDaVJGlbO0Unym8Cg7gsjQAjK9yTSFEIbtSY3GG3T73XJCMij+S/lMTY5vTTb3QxI0Obh6U6+4H5tpTX8t65cn+XiFrAGqJMjFPqHDV37s72GIU8EIctecEUZCEHKArLM7YhW6beWBjdoHSfVi7CZFK6q959guDVdQGeVvlK+sZwcGmv4JjJZ0LwePXWTiWsAGJ6v0DPGLRXBsgtPdAGoP3g/2QZBFeWe0ZH57utLi7RkE1u4rtDVEX2Ugew6Wx1HZL4sYUiYl10EX/lBFg32BijiEqxqmhyA9f+ZYUhIfdYXM1p3YxfdUCFvXBnQecQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Randy Dunlap <rdunlap@infradead.org> writes:

> Some kernel command line descriptions mix, mingle, or conflate an
> optional part of the command line with the build options that are
> applicable to those command line options.
>
> Specifically, a few command line options that use "KMG" to specify
> a memory size mix that string with build options like "X86,EARLY".
> These should be separate fields although they are both enclosed in
> square brackets, so separate the conflated fields.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: x86@kernel.org
>
>  Documentation/admin-guide/kernel-parameters.txt |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- linux-next-20260930.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux-next-20260930/Documentation/admin-guide/kernel-parameters.txt
> @@ -4080,8 +4080,8 @@ Kernel parameters
>  			like Grub2, otherwise '$' and the following number
>  			will be eaten.
>  
> -	memmap=nn[KMG]!ss[KMG,EARLY]
> -			[KNL,X86] Mark specific memory as protected.
> +	memmap=nn[KMG]!ss[KMG]
> +			[KNL,X86,EARLY] Mark specific memory as protected.
>  			Region of memory to be used, from ss to ss+nn.
>  			The memory region may be marked as e820 type 12 (0xc)
>  			and is NVDIMM or ADR memory.
> @@ -4371,11 +4371,11 @@ Kernel parameters
>  			Enable printing debug information related to MTRR
>  			registers at boot time.
>  
> -	mtrr_chunk_size=nn[KMG,X86,EARLY]
> +	mtrr_chunk_size=nn[KMG]		[X86,EARLY]
>  			used for mtrr cleanup. It is largest continuous chunk
>  			that could hold holes aka. UC entries.
>  
> -	mtrr_gran_size=nn[KMG,X86,EARLY]
> +	mtrr_gran_size=nn[KMG]		[X86,EARLY]
>  			Used for mtrr cleanup. It is granularity of mtrr block.

Applied, thanks.

jon

