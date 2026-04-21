Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B177F94CB7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B7B6B0005; Tue, 21 Apr 2026 19:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D57A6B0088; Tue, 21 Apr 2026 19:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3696B0089; Tue, 21 Apr 2026 19:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381776B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:26:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4F5D1A1059
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:26:28 +0000 (UTC)
X-FDA: 84684149256.05.D592998
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 56F9A180003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:26:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6RLxjiS;
	spf=pass (imf24.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776813987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgLAbKUsjyL598uT9cpCsbi7VPzdRTqvVv8AUtzu0YY=;
	b=F7EzsSaaUiiqvcVwNr6ERR7LSzwWji/ojyG44XuP1rPOY/OFOcy2q8H57wUVQ73z8VdGIQ
	S1GgXRz2g9JOY3kvdjv+gKRb1ma3QWD47zh4VCe7GQ6+SG/vWBLua8JKFDpxFeXS4mj4Ip
	Tknlb8GaZRPC03EIcS3Sywk6mAOHDTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776813987; a=rsa-sha256;
	cv=none;
	b=j2HTgOgZQS0bi8KqM4j5qjCAhPrDvoqdfyUYdDUr8X42nhE173z7wz4dcCPBKWg1CWacAc
	iMxIjeh7ybr8yahIll74PdITgV7PPFpOaTwsjDZnHe/27gGAyueKdXlAe807ekc0LM0n9Q
	iEEl5QISJ4XN4XOmkOpTdKNPT5EydWM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6RLxjiS;
	spf=pass (imf24.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A95DC600AE;
	Tue, 21 Apr 2026 23:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF70C2BCB0;
	Tue, 21 Apr 2026 23:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776813986;
	bh=/let+R26XmDoHPbQeUMhH4onx0DaQ8ZuXi5VStvneik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T6RLxjiS4o6mjnOCVvD4kMntKjEJOCJSOR1JKi4YoU6DfFE4cBpr0+umxWHiEzO8U
	 7oaCcoTHU+TfRcSC4vqI86VffL3oZcXhodcB7zgLkmxdmxEfa0BUM89/b2FkWNLpY1
	 sLBO+4MUONxrbuqjhMwua7meya1xHf6vgEioxbqY4tiU3lzsi/cB0OqL55DUx/MKAQ
	 vuYUVx5zTyHiZoOeQwZw8KiWvsHHUx0zCbvUx7Lz4yayLmTcL9XsDamnMzgAM/VIvZ
	 vMo9GsTxVDb0MogpB0D42zJ7SDnTkv1bAoBgOG0dgolerIxM7G0X6x9nWdhPTH1S2y
	 HusNDsV6E19HA==
Date: Tue, 21 Apr 2026 16:26:24 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v3 1/3] percpu: Fix wrong chunk hints update
Message-ID: <aegHoF2_GE3hL4cv@palisades.local>
References: <20260410174417.1450834-1-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410174417.1450834-1-joonwonkang@google.com>
X-Stat-Signature: hyceyznt3bqrrzwq8k5yxu8eerzqbufu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56F9A180003
X-Rspam-User: 
X-HE-Tag: 1776813987-558235
X-HE-Meta: U2FsdGVkX19v2enNiOOCU6ZlRjEaElMO7VzdiN7MSuOTSLSYlWnVatcEDbcR3agsfFysP5stqipuBufX3IUwJlb7YULEubY31jGIbgHKmaiifx5iXSPhzb7xTlONvwfQfow2ZyY0PIA8ztT0mYsgsuIjXwRx7vdwhUx7lMoqr/4UBF1rEusd1Mtp8mOaOLRQ8MO+cjlKkZb3IJYJYKmbj8MTBzw8xI2CUygefI2Idlm7foi+z8XDbx/QtUweKUFUrFbFP94omFwtgF1G2HrkOLZxCB66uqsYrsnBBvPkJl7e/EB2hUzjVClAf2Ay4yazzeMPbOaeK9mdM5iqgctc574SlIhT2prRBWEhGPvtVi3tnGqwT7oy7NNx4G0eq9Pen5iOM2UwBdo1zqiGXs/HABsKjZC/NmoM9aAe2elc7l9YrEr4bt910uiw9XcIeu4L3XZHUv6EpL/fNaHXtfsJbLH+kybYhVtr8b0nUYsBMyIx0yMWVEayYrJBucebPxKLfw377HlFv+Nu3kN6FBSsEmD1GRoV4fPBbRMnKb3RQHQQLECeBW1YsyTSidnljJP9MqVDRPmablLq9gQKHqz28MKeTFdIdQuLQqk4cks/TlHutNZnMF4N4IpEnHUokxl8PcKbsoWJmcP6GX2/4+6ePaKsewFpDx6FYdVIT284iI/d2+XPjjeIpgO2TnJPhcXGxWQ6/ETxw6Zrx3lT34SnbXtuIDppV+vfUOJ7k7HR0hkGuifvlOAi6qvFT3dsEL4THTy33mJmCO7+YZp9Z8GuEotJdHL6Uv2m1LBXW63yeMHdW7rk9uwYsMTHfRFkrv2+/7O2Vvnh6+8mho6zAT5mVt7o91+g8DeGqkl448o29re9mquGf39/RnBwmNDTwNM5b2AORHwVdssAqKBMNB6P+Lk0eYqJjPfHyuXC3QjLDXBZqfbVTGKpg8Mzf2YrXktHq6g5WyQvvOrU+IPY7pV
 v/6GmrbU
 U1ERef1VLIiKAzgScR+XUuB9jc7N4Uimef13Ek0ZuaJ1mAsIhSpJLnU3pxpa+TqdUaGWWaFJ0DHF4pZWTAKG4R1P4ShaQOA5oAlQC43u6vHCINlA0sbuQBNeph38v29av14B7GTEC4C9gWF2LcY0gxaVYFOkTVM2gh9P20l3GTRUhh370jPrzJ7utU3TMVmA5PUEgLuy+NSzgH5V4hjlzSaG0aFHaBH4pXYnTfpxMcDDSIT66IDnLnsNpDj/U5grO6rXV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Apr 10, 2026 at 05:44:15PM +0000, Joonwon Kang wrote:
> Chunk end offset was set to a block end offset, which could prevent
> chunk hints from being updated correctly. It was observed that the chunk
> free size gets minus or shorter than the actual free size due to this.
> This commit fixes it.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v3: Initial version.
> 
>  mm/percpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 81462ce5866e..3ecd86096641 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
>  	else
>  		pcpu_block_update(&chunk->chunk_md,
>  				  pcpu_block_off_to_off(s_index, start),
> -				  end);
> +				  pcpu_block_off_to_off(e_index, end));
>  }

This needs a fixes tag for:

Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")

Reviewed-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis

>  
>  /**
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 

