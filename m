Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4A4CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 09:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747E56B000A; Sun, 30 Nov 2025 04:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7EB6B000C; Sun, 30 Nov 2025 04:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E776B000D; Sun, 30 Nov 2025 04:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1C86B000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 04:38:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD2C8ABED
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 09:38:44 +0000 (UTC)
X-FDA: 84166773768.18.D569F4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F6F81A000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 09:38:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AnLPvUs2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764495523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+NtIowsK4i5kGHLi7znAGOYsYaRu8YyoeNGF6qgXJ0=;
	b=QFswrw9P43UsyhmMgCkRJ1eWT14jINTJG9pKunYj9GIpxYK3UHpigF99bPeAH9EHxOfW5g
	ouowdsBogfQ3HAM2F1C6rubZ/RWjuUoMypkl4cUPJbj7V9sdNLGd6O28tCTEa91/HqLAzs
	Y4iVVmxvBetpadbYs1UedAd6FYQRsM8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AnLPvUs2;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764495523; a=rsa-sha256;
	cv=none;
	b=idihBbk6HBxBq0o9cQkQnZWdcPy7vdRjfsi8kYiz7EN9zz1/slWxnio4zfaSqeficsv+5o
	SuE5cBfq+hCuZQRGPG6xEUF54fVuOpxMQYug0MJw+9PPjpnb+0TOXFh4oSWRHL0Bq7cOug
	aT1YCwckpBFLTHxsOpESGXw37HYBxgE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18FC6433F3;
	Sun, 30 Nov 2025 09:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B2C4CEF8;
	Sun, 30 Nov 2025 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764495522;
	bh=1rh+7wkuYPvUcyDDy2EaSXyO9kTi71dd9QiSf+SPeqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AnLPvUs2bfRc5Fet8oP+MqRgbZWzlG7vgETZO9x+3SuSwDE+iesC91KdrglmxTEt7
	 WtRfBJzd3S7U7EICJWfY2f1zdkUJB/J29h5CiJZeyqa31EjL/hW11IUAcyVycLIDs/
	 L6Ew5nCO/PVTQCkKAYCJnTb0rop5KgUIpet5xGfTk/meIRaBG8gJKzETKAUkM/1mLW
	 neIFy1ETOHaqUEF/1hOUg7mRa/pC+eN79T8r34lj8fqHu88nUTjKMwCA7Z70XURdz0
	 ZUy6h81b6gzb8fEu7af7ugkCiJglRmlR6GjkBRq+ih4YJxSf4dkOUlG+D+l/zGlrJW
	 t7NY7+W6HHb1A==
Date: Sun, 30 Nov 2025 11:38:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, dmatlack@google.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: luo_core: fix redundant bound check in
 luo_ioctl()
Message-ID: <aSwQnOF0T64i2ljF@kernel.org>
References: <20251130010919.1488230-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130010919.1488230-1-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 3F6F81A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yn8r93xtnpbq7c8to14ftfqfcq3cj53p
X-HE-Tag: 1764495523-61183
X-HE-Meta: U2FsdGVkX1/Qmir3lUCOwcHDhg2xbLtl8KsAtGz7H4R+w4zMzQNwnELMVnNHeyDQwQ50x5029sRQ68O5S70T6Sieb/l8rGN0Oy3Km2JVmo3uxfSb4vlKks46lkCiSDyjdsUHs9kriK2E9YkrJWx1oyHVGta1j2hC7ONbIyhECb6KjgQlNk3guzpHr1ZLB7ansj9H3kz9FALPjDYwsBCu6GlsJI0EUIKFxSztggoe51ee57xw9HmJeSJYWT9fKnP7Gw092QuGUxSj4alfENh63PklIswqVL2V/QOgd495QLl0VHq2UI4eLqfcFXcYOCBWLz5vExo0hjoEd4jExPdnpC0QxDvfAZHQVqtJdSurA8Y/APMPSp0E8hTlKFaK+GIt6VG0AJy+ofcoL0XS1mpKXQmTh+7cU44Lbf5JiDKpQxF2z1x7JDheqJZqBD7vHYiqAKU3y8Xfn7t4Ps8jYOviJG6cTeKBg2Mo+MOOgSkBELY5yvhqF+lEjMSzP7KQodEZuZ44RWjT42QzH0Aqc7Y18utlak9Zd3UDOt/YDJ4dgqVDr7thGECeR0mTRuLWqbqAfiezi+6DLKzUb6So//XmhgrygNgiC9vB10HuO82Zr3xS6CFPScUilNOOtt26ZL2kQijYEPCxB0/wDe4U63nDJ/o3LAnCo8/Glo3LG8Y6eERL0CX9J9Nr1/fOabIzZInJu2a6BtA8c+mArPIkmQkqId6iyCHCh4Wr/xoE4G9d7H0W/cN4FQJporHK5oL82cwATAKP5EiZcflKG75vZGUPm7f7R7bxGtJYW7cNAUVgvfVWG0jCTNtQ9VSnrItYFbI0v4DQ6Z0DU/rYcu5lokkPDicM7WQlR/OKtN9/+GMyxKQyz76R/vBnNKhZwmkkF55LSi7sGu1imLMv2ygG0nH48rZlGcUp/0kqJfQySa4gSG3V1cO1y7b4bPzxco3b2dJZX46FIO+pTTLv+1Y20Qg
 ol0Sq2nh
 +kCnJ0l3Ot0i63YIcuFkoVh5q5iz8Gziyi3+qrTDJdM3PVvBKg0hu6RQUEIhlN0AcDhmoZYAyxQ64F4+hecmymYkKkpcHp6RKe/fjnX8qGeSCixmqp7gD7dewB2+p8cLWp6FeiO+8sDRzNVLLlASI6v5FqcTJgVa/R7sCteVfCEneerbAyUXXj06fe1sw1qVI8dqtCGYCu7GpBAg9vLt+4tcIbTEoXlM+tc20WPJnH5GnkoTtLVzwl+vhhqfY1OuU7P9jCSvRgGvJ3YhWNqqLjJhv2gmSCnnUme0LgLkjHZrZgAM+VW8lB12SYv7FVJrOe3HJEI9OqNAhZTcLczzDeRSijLBtkjAZRwEai9rjGnXaeJHiD+nuay07WEQfsggytxzwZ8iabwd5LIHIRDYP0bU25g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 08:09:19PM -0500, Pasha Tatashin wrote:
> The kernel test robot reported a Smatch warning:
> kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is
> never less than zero.
> 
> This occurs because 'nr' is unsigned and LIVEUPDATE_CMD_BASE is
> currently defined as 0, making the check (nr < LIVEUPDATE_CMD_BASE)
> always false.
> 
> Remove the explicit lower bound check. The logic remains correct because
> 'nr' is unsigned; if nr is less than LIVEUPDATE_CMD_BASE, the expression
> (nr - LIVEUPDATE_CMD_BASE) will wrap around to a large positive value.
> This will inevitably be larger than ARRAY_SIZE(luo_ioctl_ops) and be
> caught by the upper bound check.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com/
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 69298d82f404..7a9ef16b37d8 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -404,10 +404,8 @@ static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	int err;
>  
>  	nr = _IOC_NR(cmd);
> -	if (nr < LIVEUPDATE_CMD_BASE ||
> -	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
> +	if (nr - LIVEUPDATE_CMD_BASE >= ARRAY_SIZE(luo_ioctl_ops))
>  		return -EINVAL;
> -	}
>  
>  	ucmd.ubuffer = (void __user *)arg;
>  	err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
> 
> base-commit: 7d31f578f3230f3b7b33b0930b08f9afd8429817
> -- 
> 2.52.0.487.g5c8c507ade-goog
> 

-- 
Sincerely yours,
Mike.

