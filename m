Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4497AD41C02
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A899E6B000D; Thu, 11 Dec 2025 03:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60C56B0010; Thu, 11 Dec 2025 03:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976F66B0011; Thu, 11 Dec 2025 03:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 890A76B000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:14:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 346005B40D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:14:04 +0000 (UTC)
X-FDA: 84206477208.25.CC4501F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf10.hostedemail.com (Postfix) with ESMTP id 610B0C000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:14:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ffgZQ8Hw;
	spf=pass (imf10.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765440842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJGCV9qJPJBuRBazn5Hd7AYqiLdR0AePhlgsjhsk1+s=;
	b=LJrRxaJwajVkirUQLvLwiVAe5vc7819yUzKq9flQRXRX7MmfWs3k6mhcUOvP8hfQgBJRo2
	N02oEI8kE8rs4ocPlnFFFhVoLR4sg1v85ZGDkVkYW62HbF7coXMWN7DgBn/V7q8mdI04MK
	Ga1oQ6qkWAfKnzt6V5c+2Hk96kyb3AQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ffgZQ8Hw;
	spf=pass (imf10.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765440842; a=rsa-sha256;
	cv=none;
	b=bNM+KB+LrbfZtPFdmO7x/CqnXpr/46p+dtqFrbaQr3lzS6NowSfuZx/FgTkrmT6ix65YN9
	D+Fe3D/uS52WoqFjtBmhXxWk3MAIGdtxZL80ztDYNcZjygNIBCK33/dtPFPi7Z0fS/nvUD
	0+amWBsDTlcNNWkwLP9fa8qIPqTmltI=
Message-ID: <c7eddfa9-9c43-4e17-aa5f-82cb82118cbf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765440840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJGCV9qJPJBuRBazn5Hd7AYqiLdR0AePhlgsjhsk1+s=;
	b=ffgZQ8Hwx5r4cC1sByhp4OSCoSBCGsnfFbfoHGb3AlidbyUFFB+XQyKQuHGT0iwx51Wm19
	hcTBJtb7GBW/1K8UQZKuGAoouXxoSvbR7BVfFl+0CfTAd5q8WrhLZM82LZkRWM4CvSKrzV
	yla0S3AGaIHN97/IUUTrvpGmIfI115I=
Date: Thu, 11 Dec 2025 16:13:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: zswap: delete unused acomp->is_sleepable
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251211025645.820517-1-hannes@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251211025645.820517-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b7dqhuhau3ciik85a9giicwhm355yyuz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 610B0C000A
X-HE-Tag: 1765440842-58613
X-HE-Meta: U2FsdGVkX18ZI3Jp8rrPqRhUicWH5kBAPR+SLZ0ED1dhpPO9kXtdt0NVZNOqwROmpEo0POjhW6GWEG97TRK/bfbCCNd9AkBZpzr2Td/fFHP4LDbzf3Wz2WBhtbXiECLy6WogZNwkv531XO/YII/2QKRzCbD6Fjteu3dGNbD4th6WzVmUUrodXRIx4Sy9kuynOoDD4u7NJ97m64KV9qUEhpUPd65y3u6joinuojBgsCukCXl9ea6TQhsJW5nJhsgM+hWvJCLQs0UACTU0P8R0AJwByqlBXJ10sHjR944keQ6t4QyiydX6l7TeVexkY6wMAc9sxAfUbxfOO06/+zjGfylLLuUZCI0gcGwBjvQI4Rn6U2fkpsn4s29HHykxBGyTq43KoVforSse2jMvL+0cA/Xx6483dBnZL7hx3yE9pn1QrkOs1ZTVCc4mp5bcr4Qr1NLoh5EHaIwqJhE2VOZ3CyJbNUgYOKpv81sTedES9EwgyGxBgnNyEXkHIX2IYzmEsQaOPm+61TJMpb0jhVHAUAUq3p449YR2DRmyo4uISl/dPZ0fzVjsmb2PZYAdsJYCELrrhAdCdfskGfGdyyZXPHDWvzUaom2KSO4TjQTKEepkVbKoSKToc9AvptOhgGG7sf+BynMJh3H9Oh0FzQoxbJ4iS17fwe3a66C4qNOfDI90PsTjr/rlVlxKJB6BvFHxcHDHrE/lIuJOOk1KVSTD0BvY4MWRYStKhrqpTjM18ERNCMD4OWgp4Emiy4Cp0NTVz2Skjl/u8sJ8NycuwMcR7V/QDpGFMlMRyRz8b8TlRiXWijvTDfx0WwugIKclB/6lkLxClg0C8G1Spq4s9zMpJFdxk7gb7+AkrIaiuo5BXPhcMc2Ey2A6rJUBRZIHZYIwu0rd/qir7XUQ51F1TYk9RQnA77LH4b4qTpQBqVXjNObozGKP++4JX1Q3nhpvVOY85j6MJTOQJnysIqLLcCg
 wwcd+OM+
 BSgOwldsawK7it90LshA1/0kJmMA1gOU5iEERxxZ4e0B/jJ8nbKa+ciOreMJ5C/M66CIMs29bDcjF1zM62uq4L0E3rcyTBWFfDxK5bxg42sKIfJD2RO3ra1/iQi3T//S/XNmdZjhOboHU/7KbJoUbLsDmTNFQI01kpehWGzN49PB1V+s7xTsvOhCE1lxwVh7JnjoYjJ4qCgpWzPJjoFkHgR6CJlO1tcAaQ09zP5GBaDS1ULu8tE/TP4r40N9ublknu+tycUZzZUqZylVqZj2c0JaEVwcbeJK/RMplis9SKegMkM12kR1sKLTWBfck1JCaIoDW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/11 10:56, Johannes Weiner wrote:
> This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
> read/write APIs instead of object mapping APIs"). Drop it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks.

> ---
>   mm/zswap.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..84797ed4d3f5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
>   	struct crypto_wait wait;
>   	u8 *buffer;
>   	struct mutex mutex;
> -	bool is_sleepable;
>   };
>   
>   /*
> @@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>   
>   	acomp_ctx->buffer = buffer;
>   	acomp_ctx->acomp = acomp;
> -	acomp_ctx->is_sleepable = acomp_is_async(acomp);
>   	acomp_ctx->req = req;
>   	mutex_unlock(&acomp_ctx->mutex);
>   	return 0;

