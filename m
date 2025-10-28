Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0FCCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C7B80168; Tue, 28 Oct 2025 10:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A2C8013F; Tue, 28 Oct 2025 10:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A511580168; Tue, 28 Oct 2025 10:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95A258013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:19:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5308849264
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:19:26 +0000 (UTC)
X-FDA: 84047730732.19.FB448C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC73B100016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:19:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQqLNS2F;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761661164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbR5fdZgiIDx4/bfudBTcucxAhOIzA4A4Z7RuLr8e7I=;
	b=2LS2t2RrSdZsrE2QcCI0L07k6EPacwBrqQqErLAvC1+LSH0B+VBsRULZPesuzY7bD7UqCS
	90N6vzIwYD+kUhy7uCHRlKuh7/GIBqfVocHvER6DmzWhyPmiB9JF0ADOJU2o1XB74JE5Kx
	Elc16AgoTIRl2TlvoBXH91sGq0pKqKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQqLNS2F;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761661164; a=rsa-sha256;
	cv=none;
	b=fz+EhwZpCO9zs8QaGDQ89n0j42LbCpfpWX9fZBboZZDtDdxEbjuNnEB4hayKgkaEfVDq/Q
	2OaaIfkA5Rpjx7otgkD2lrQ7bZHUuX+C35Em3uQgjlwpmOQS5i1yRDnpPxPmrpC+Kz+x4S
	YaqvFZpdyXneDCOzXeAnmZKn4KU2QPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDFEE6000A;
	Tue, 28 Oct 2025 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766FDC4CEF7;
	Tue, 28 Oct 2025 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761661163;
	bh=N7sqXu/YPYOQkrbkKQmvopRhYdbD+uh6iTOl+OZens4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQqLNS2F1BrctVycOmZfPXF8RU8+BhtweqoXmHoDpmq7M5ySp0o5vaD1jVrWzRjFL
	 F44wZVDedxfNFqd+Mzlyi5aTtNsSm1G7RCl//3iN7FYVimQf1MKYotncuadkC+6uNw
	 NdMnRpaed4nIswY0m2ltRx0QCFaDDAF1sImMYAqEP40VdGW4Eky2CrjvM/IJ4v0WDu
	 obHXZwnDx7U1Nj6+j6Za7OqYM7pIOcU3NurV1QHhrXc4PY/e/GGqcRzMO7k4emw63L
	 bPcprgQan8qNEuohr/ZZNaIeR8omNj82FNRBZjCFFw4+yK7yyYyvep7CRNT9NS0d3H
	 QmKqgvjS9MnXg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at startup
Date: Tue, 28 Oct 2025 07:19:14 -0700
Message-ID: <20251028141915.49989-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028061927.1378746-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC73B100016
X-Stat-Signature: u3r9x1xpqhm513hi4xc9yk7g417tqdg9
X-Rspam-User: 
X-HE-Tag: 1761661164-805915
X-HE-Meta: U2FsdGVkX18jXp6d9TLmB6aOGVQ43t4hlqdebIfPgGKqKdQpdgJpADo9a4+KV/UD6hmA87GjITXvNlZrZ2taTajwI0UVpAV3iMCZTlSxQPOo3YNIyAcZX+kC32KBis+fwbwjFNZAuic+dL3n7/yTpI6v14fONq8ETKqJPGTTrbgtYWXgiLlSdbYy78CF26Vxi53SAP47QeMrsAaHPjli32QINFrBDhJNOb+60ovmSF6Dm14NZGCS/M07MDktkII1QlSyA6gh/0W+1ANIZ4ZknnMT3FXXeR/c0LnUDSyE3NkrXzTNwKHPwYRLrTzUlhTtUfZmJmi+hEsG/eobQDOvmxlu/nQfNqSAHL0Os1HUAPeAGh4PCVZyBF7VL/cDj2z60qs4s4wLTGSpFYfNhmE/kQ6TTY0ysPKcqIZDp2EwXEFfryoA/pfOQ91hCEdmffmmn+on1uqqVP7TejvKTUxYS23kWQ+IcOQkyxNHV0/VZoOg6VAzucdUaOi2C4YJTsHdmIkoWmTPL07Y1B68qCkWD4wSPaO4ZKZRnt93WQD+n3eY3njnrQ6DxBlFeK/2Q3ImzEMx+UWineiYtGA512/NxmVIN/vKIfzWFkXl8sPpVzM10gHdpI/JlS8IQV53YtBbKwZXWeYW/2RlL0fn9dFTEkAkzXWpyAWkEHL3ktS5ZWMdyhyAmQgYe5goM1FPNToC0KoLePlXM43URr1BORsdx5WS8ge3ULQjs0w5sJSPkD1w+seewv4LJQO+HtAKisNjqLAH9ZuBZ6YIiT9aj2Ch4UXpMipW1T4O5U64FLYfbw2GN42PmxtpYqh2YZrM32DdxRBLI6QqAY+jev7nOgMdOSbbGWy/9dJixEh7ZmP3dy2Oovcs719CLPdBSBkykuuAJaemZVwX+eZhV/GK855OWg/aupotsoYcVb/IFOtvQUUxvbSGnIxwxR81FA0K2i95FI1wtDG9Tr5yHiowVYO
 xB/aPKFX
 vzrOqis5zt5znmvFeyDp7ObIlG61ljmRWonNNcmE5l0UIyPin6EuFlnrvax1uZTNDHlNEcHSYciSP1VmqIkwkzDQk588aZTjEMK3q7PmzyYzcDLcHI7ZBcV35TysWMR5VHvYZuru6Hudens0ExvYQwZXA4KOXpH7/PWVB0g0SD0Dz96oZwdhrz5QnzzWoO42qPcmAseuwOHBC92laYhAq/0PshJB/ArKwIxUUT5HlhtHiZHCtYSINa0nAUFEP8+huOfXv2d3kvpuib+YM9RsBMHjjP4sR8dYpjNmVVcmM6RaZY5RR55O8jUV2AP+PfJtfCScv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 14:19:27 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
> avoid unnecessarily frequent stat update.
> 
> On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
> jiffies wrap bugs appear earlier. However, this causes time_before_eq()
> in DAMON_STAT to unexpectedly return true during the first 5 minutes
> after boot on 32-bit systems (see [1] for more explanation, which fixes
> another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
> update any monitoring results during that period, which can be more
> confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
> 
> Fix it by setting last_refresh_jiffies to jiffies at startup.

Nice catch, thank you for this patch!

> 
> [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
> 
> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  mm/damon/stat.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index 6c4503d2aee3..6dc3e18de910 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
>  	struct damon_ctx *c = data;
>  	static unsigned long last_refresh_jiffies;
>  
> +	if (unlikely(!last_refresh_jiffies))
> +		last_refresh_jiffies = jiffies;
> +

How about doing the initialization together with the declaration?  E.g.,

 static int damon_stat_damon_call_fn(void *data)
 {
        struct damon_ctx *c = data;
-       static unsigned long last_refresh_jiffies;
+       static unsigned long last_refresh_jiffies = jiffies;



Thanks,
SJ

[...]

