Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A88C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 22:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7632F6B00A6; Sun,  5 Jul 2026 18:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713E16B00AA; Sun,  5 Jul 2026 18:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A6F6B00AB; Sun,  5 Jul 2026 18:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 358B86B00A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:10:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A75E08C7C5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:10:21 +0000 (UTC)
X-FDA: 84956117442.26.72E0097
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E55A40005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:10:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ykhVL8NC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783289420;
	b=EUpc/o/ihFxmFjsjfuiEs4TLeXRuMpt7nuVYcGY/E83SiLxE1raOh24qn+rCp1vyuJs1fQ
	o1F4/3a9QuC5ynmb3lAL1+M3+M2VHS949NX6vEY3ox1QsyiZmkaSWQ4K7vX0HjPMxgKaP+
	xG/eqhnTl6u1uqwaz8s0OL1EPDNgKyw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ykhVL8NC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783289420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MtM3xYRcPk6bh6LwwTUvA72moN3dLn1E91W34Wze1Q=;
	b=MT99c5Mu5mXv4leM96+odnVsnGij38AQ9DEz48H4p49SXvuFTUXB7bOq33ecTIfu6l8MAf
	t4KLYAuIAa9sYnbY3KdNGum9gXpFjrj5GpwucodnJJ1Mh/xOGnGQjim3nGwM89YOQJKxdV
	8xJrEBcvtciAxsCVaqiCH7edBJQ/DBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 205BB417FF;
	Sun,  5 Jul 2026 22:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8A91F000E9;
	Sun,  5 Jul 2026 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783289418;
	bh=7MtM3xYRcPk6bh6LwwTUvA72moN3dLn1E91W34Wze1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ykhVL8NC7ByyCydpaQ8r7N3xU4M6Bfsyy5iiI1KqefXcAdTRQvdX1PqkTp2crVSO0
	 U9Anilwp261479Llfh2JRYgSKY3DoUfmK6QkcI+oxTW1UdjGBz37cjaHnGixsyY3cN
	 1BNWeutJJHigYUYT8cyw3IHMvkUwSeJwJLHpTDns=
Date: Sun, 5 Jul 2026 15:10:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: add sysctl_max_map_count() check for
 do_mmap()
Message-Id: <20260705151017.289ed34630b503cdc1def407@linux-foundation.org>
In-Reply-To: <20260702012830.667205-1-thehajime@gmail.com>
References: <20260702012830.667205-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E55A40005
X-Stat-Signature: q3iihs46njd4cw933eirwj9yuu51hzgj
X-HE-Tag: 1783289419-468473
X-HE-Meta: U2FsdGVkX180dqsu1YFSddVTxoJ+C6Hs6oi7gfOgRIuY6JkPdvuWjGxw6C1FI9dpFDOSam03b8orYofZ7d/k6nfevjXIYCUhWxZOfWxa1cYSrrhelqU9h83yZyEWyUlE6XVwdBld9gcYxul2DpNtbyUrPKOvwsekN/D/VupwGwyu+W9KJvzEPXDoCvCxOAEka4bwCsKNt1IZKCLLnyxJ4GYG2VA3WgEBePndpToh6o6lsfHQjK9k3Wd/2C2tutnBMweHOAWA2BfBXwUIV/2FnpaVu4eEko7Cw+wIl5yF4n9R9SGT4EnVE+hqmm9A9Sjwr4ix4SDqkuY54g0apf/YaM1e/kzdp3FitSl82h5xAagn+dVac8xwu7A2LftxNi4tfWp66wQ8tCuwnQTzCvjIwMfwLV4rQvihCYwDZWgyW9Q5YXL9FW75kP5k6kKnY+EUsfi0fDwni7Td8dmd9pvDl3zWS2LWaQgjbfLWC7Y4CQn77UhcMzR87mYDFNzAeB0LfF9jy4kEB6DlgEeapxpRz2ZHn/ALxoNi86qOH5rlkiRpBf+TtwuB3mI8ANSnWxvkxb9oU9L6s9tqdbxhgNbmLVHTaXW3yrJQ07mnkqdeUR94NL+yk5JXMW5+OCQwS+2Z9u6Lkc6EsOZFWVUXzpMvOKWXlJeuM6jm5clo/NM+chZKQjfkmT7wEpQOfy+We8wCds/JR4nv59+yAs4rS17b4pSKrnzw9eXT4moMketP9rT4gH4FbzoRdO0PWVZe9IHUID8eefUgbTOUiCBq5qOHtbId5PwIwSrq0lwIl+adxA8XOWVZBzbu0oBfXov/ZMNYCtIsJsLxSyXvFX5ex07QlDNU+4RPUXTsi651YJSko7OjGavP867j1fhuHKgKlDm4/EJ+7MpvN5I+Pe1/YfgYWIFE6lZzvyU83Ja19mtTDbfsCYUJpuXNglYSx+D3g9ft6Of1Wwr4rXwIjYaPWgr
 N3mJdcsc
 /9OcsK5mKh3OBak8JM5HOzAJzQhTPpcRTcVyZlTRbsHoKjmJAI8PT+dV6Od6UPVgdFCn8i4cl7b9kjwq/L6FYOJGcPVDyaCEumeN0Gkgx6q+eho1YiHZbVgqfFJoJSyTKG10MHwy+FHdjIHEh/dHrmOLBu9f1foIv2At6A6rQY/HMUYTaIiPOnLx8lOBUXDHys28+dHmTtBs+2ycqRe8Sk+cxE6M1Sz1W1ByWYGbK7DtrH8FPFLxwcKAj1gLGWdesEicT8a7oJw8IHxmTVY20IrWk9c4MaAVh9ncWzG4mt4ePpD780/XFuCD/AyBrC1Ntb8mL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 10:28:30 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> The sysctl variable vm.max_map_count (sysctl_max_map_count) is not
> expose under !MMU case but used it wit the default vaule
> DEFAULT_MAX_MAP_COUNT as a limit of count.

This sounds like an oversight.  I see no reason why nommu users cannot
alter max_map_count.

> This is currently used when
> a vma entry is split into two chunks (split_vma()) but not used when
> allocated (do_mmap()).  As a result, even if users request a large
> number of allocate memory, it will keep allocating until OOM happens.
> 
> This commit introduces a check at the begining of do_mmap in nommu.c to
> prevent this situation.
> 
> ...
>
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1035,6 +1035,9 @@ unsigned long do_mmap(struct file *file,
>  	if (ret < 0)
>  		return ret;
>  
> +	if (current->mm->map_count >= get_sysctl_max_map_count())
> +		return -ENOMEM;
> +
>  	/* we ignore the address hint */
>  	addr = 0;
>  	len = PAGE_ALIGN(len);

Seems sensible, thanks.  That's what the !NOMMU code does.

