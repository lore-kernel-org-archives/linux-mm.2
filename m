Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C1DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC326B008C; Fri, 10 Jul 2026 10:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DADC56B0093; Fri, 10 Jul 2026 10:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC37D6B009B; Fri, 10 Jul 2026 10:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB236B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:24:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50A5C1A0484
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:24:22 +0000 (UTC)
X-FDA: 84973087164.26.30B4EEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4AACA0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:24:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hvve1BE2;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693460;
	b=hGTqjbi9WWIjCodaGYMilmPKPn5QvpJwHSZwnSQgfoiie4bs42JEtremTEtUSxkLKgphGW
	kwfS5nDU7JcYVZxuncZfN6IA2Yvc7uLjj6qUz90c3WZTvN3b6zY/2uOODzCNxGmoB+Sv7b
	Q0uILyO1BnItF+3rePCa2webyuwNe5c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hvve1BE2;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rUDxcBxSTvUCkBAHloVtxdehX9iYZCWsP8zEYUkkqw=;
	b=e7rqnuHORZYsD5FMPvqc+VvCOz7vcRgqpeDCo2PJeDBrfXfv3cr83F2YHbr2dLLkGXhedT
	WacV5nzU/9hosMh/2jkBt9oi8ZBpiEYJ8pIbwDyfNjpLeXKp7HlmS+5jHxCW+MSM6+6er5
	11PzJHRa710xPq2PQge/Mcu+PpNceyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A2B43833;
	Fri, 10 Jul 2026 14:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466B51F000E9;
	Fri, 10 Jul 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783693459;
	bh=3rUDxcBxSTvUCkBAHloVtxdehX9iYZCWsP8zEYUkkqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hvve1BE2sLwGuVY56H2t3YRIg4JB6/lGKUEcaHRfIRmslgZQM1dWvquBGhjH8LPNG
	 7MAh73cA/ZThpxDisFOVLqJma1hCTpoEQr7x0p3pXY72M4CIrGZE0/nOMElLE42gjB
	 PhQs8w872asSL4tvX2dIqASl+Nh3j8hWlXNHecXaY7KilPkY5UFeIDVTZqhSHTAFeZ
	 wSOb6BLr/KOuXCiZf/0ChdtvZm/TbPEdoCwCzhkLCSH2WNra5AHzdb0AOS/JkyCTj+
	 jwuj34JJwC0SaRmMbRcyqiR51x6NVGF30d0i94LCcjzEu/TMMhilGa1W0iNgbVk+NU
	 QBQaZkEOtekxA==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/4] Docs/ABI/damon: document update_tuned_intervals state command
Date: Fri, 10 Jul 2026 07:24:15 -0700
Message-ID: <20260710142416.25073-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710044737.561102-4-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4AACA0009
X-Stat-Signature: esffgkp39tk896ybrefu7oiprx8e7fi7
X-HE-Tag: 1783693460-265537
X-HE-Meta: U2FsdGVkX1+eLIKBTEGD44wu4KEW0G2nfzdrvYy+Ww6km+rBC5t/izaCnvjshjIb3uOvZcHEUPIhucIP29XpdMHFp3PXEX051UlzUV8MWaHQCP9JrjLHVp8OM6lYRf9q3DdNje+oyhbLV86AcIhanh/8/4bF8br/+Mj/C/a6hFGgAYg/36S/pyrO38xuljsSqbsbIKDqn/niZa6zejujq77s1LMwILgH5XWv0MLTJIdTjaVhYPfCjSriYo9nQgtlGTbL/0+nkEDbHyH4RsJiNla4HdQp2jmK3/1UXGDpzowvnqDeGVfeXiaUaa8IuNnzCe/J7oazJIut7HOAt122WTSxbYctDPLnIpwJRxAHKdpV+K1+2gKvO/mJ0D1g+5R5gc0Tiv4ybk/8Fud0YKJgge/gu3F8FycoaTwxIq+vopD/tjsvBwh8i+0xLg9GlHkSDCbOXcu8TIZKLW4yiZczfcq5PtCUf+ML5X3QB5hLP/aqdJNTRKygUWoDfvKRtfXgyU3uGxqWPU5Ic7eiTkujI1ekvS08z9h4CTy0a+MdgxEROcSkgARCeEHGaLrisNYL7qQTi7dUn44gseGz+kJclJx9YXrO29XQlrWs/NdH6H2DFonRLPMeJRvpimBJFpk5KV8nKvD7KzaBfjl49wE/a7L9JbV/pmYdm2R5aCh7CldWBqzT+29QsvD1nTzWuJ1PTElE1ZS2DkGDrpLNRB/V+27K80hdrdkHYXc3DSgYGFQ7iRP3XJ6h+mgtWCD9M5HAgmC6n0iNjPUH/pVGTtFh2WlShZLpTZMEMd1MCZ7vOXUx25IS0IUgDEACswQRE9szlkytK0F85LmUDPG+ac3FsoOozxbeHfFfJWPfNDoqQ3DnlnhI6X7igEJsq1I2NbLdEaQ6S0vQ0xk/70daGiYreraoESCCz0D8Icq5piYvqHGLI7S5YEa5+fg3EO2LXhy9Hj4dQRJUlcu518ILGLd
 RpcCyvSt
 dMTQ41ce92O4JbyPTKV07AeXn+c9nvWsqWQMRRhKIEo66z+McvjnNfBr9E7cKf+o6iN0um0301DrSQ9LKTcfTeV0m0iXPTz/VFWtMtRh39aBABcPIW4t7K/KLVia27AQVQWH8OeHT5YOdPeZwY6bTTtdNo4/hvd6TujyRgFXE47pyzQ2qdNIkCI+3ljcGmlH2NiabVdASVqFhka+SvxY9uQD558A7N8n64s5Co9bMXOlMyNCfKgBetc8zK7sSLjUTPwJzgvDXYtXr5dqg3EfWZE4aLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 12:47:36 +0800 Song Hu <husong@kylinos.cn> wrote:

> The 'update_tuned_intervals' command of the 'state' file, added in
> commit 1077605396b4 ("mm/damon/sysfs: implement a command to update
> auto-tuned monitoring intervals"), is described in usage.rst but
> missing from the canonical ABI document.  Add it.

I initially thought this information is better to be only in usage document.
But, ABI doc is already describing all the inputs.  So, this looks good to me
now.

> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  Documentation/ABI/testing/sysfs-kernel-mm-damon | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> index 03aecc07a5bd..7e8192527191 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> @@ -36,7 +36,10 @@ Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
>  		kdamond.  Writing 'clear_schemes_tried_regions' to the file
>  		removes contents of the 'tried_regions' directory.  Writing
>  		'update_schemes_effective_quotas' to the file updates
> -		'.../quotas/effective_bytes' files of this kdamond.
> +		'.../quotas/effective_bytes' files of this kdamond.  Writing
> +		'update_tuned_intervals' to the file updates 'sample_us' and
> +		'aggr_us' files under 'monitoring_attrs/intervals' with the
> +		auto-tuned sampling and aggregation intervals.
>  
>  What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
>  Date:		Mar 2022
> -- 
> 2.43.0


Thanks,
SJ

