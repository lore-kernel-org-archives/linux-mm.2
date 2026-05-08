Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68485CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B7B6B029C; Fri,  8 May 2026 17:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C846B029D; Fri,  8 May 2026 17:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832EA6B029E; Fri,  8 May 2026 17:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 756B66B029C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:29:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17C0D1A0328
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:29:05 +0000 (UTC)
X-FDA: 84745543050.02.F683D52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2E4F0140009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:29:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VHWNPYj7;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778275743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiN5YjZcVPTGD9h1RCBndvayjoOrIDRETTHDABtjuwk=;
	b=t02+bqkclvN3F3RLeyt+6LwJYXrGUfde42Ux/HX3BN9z3ocaSsIrxb3Ab9Gvj27U28wFhz
	34uGBp6ac6tTSDFBQgHonjBbKVQ0z/3u1zflnkPSA08Js6wXXOCMD53/TWLpzqHOMfnSNM
	qaOerhsmMUoySahvGIdytwcA6c1ILEI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VHWNPYj7;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778275743; a=rsa-sha256;
	cv=none;
	b=VOL2eg4nBdMYU2JcJR1SHRAvmvpURGHYK9Etx+MzbCDDEDLj268RIC1l0PmN+gmK+13rDg
	IgDQiX0zSKvAeG6KY+PuIdW2ouf+dn3TiOBufAvRn9RRcoFbH3lN/5ZBdzDAwvwVxeYt6D
	SOCA8Q8qabhbhFI6vP9lB9PGC8fVXeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0984F401D2;
	Fri,  8 May 2026 21:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58B4C2BCB0;
	Fri,  8 May 2026 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778275741;
	bh=oNedQrJHmLVEJFgwwCUXpr+vmM5dJ5kX6pbkVZnGRCg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VHWNPYj7QgL8/ZVnBCPuJmD6OO1osngwzvCsA3dDrPjsUkHZs4p6iOtI7bagw6TXB
	 NXf5y/CC7aklD183LB5aOOWTrnzIjFqxsXjLKn/4rRl/fLcvi0aWXauUuRSZhpRcUk
	 iHSHtJv1YVs2Yu/iY8uV7GWR63p2vHt+NRVCkSCA=
Date: Fri, 8 May 2026 14:29:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zijiang Huang <huangzjsmile@gmail.com>
Cc: baoquan.he@linux.dev, albinwyang@tencent.com, bhe@redhat.com,
 flyingpeng@tencent.com, kasong@tencent.com, kerayhuang@tencent.com,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swap: Add cond_resched() in
 swap_reclaim_full_clusters to prevent softlockup
Message-Id: <20260508142901.aaad5a82acf270a37f302330@linux-foundation.org>
In-Reply-To: <20260506130919.2298807-1-kerayhuang@tencent.com>
References: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv>
	<20260506130919.2298807-1-kerayhuang@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dsrh8wrdwrjzkbqzf9iud64k35j4gf1n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E4F0140009
X-Rspam-User: 
X-HE-Tag: 1778275742-879653
X-HE-Meta: U2FsdGVkX181EvnFKk9cp/oqgKKLfYSqyubd9x7frhxDdCyI2KyPh6rVsPp0wmmvdTTpaC/5Og6Tsoev1zfmT2PZJIbUHm2y59bI5NT4xCznNVFN45VKdMcBHePt2f+wQBWnqz9z/hfjJF1ogkJsR85T7M0FudzL6kz6VZog+nAgyb/tllTUWVV5NlFt15oo0eGe3jRuPooecpu6KH2XwBgPVd9XEjvB1ASVtE4Jlp8CuJ57rDf+y0XUTA0giYiBSL65/RboJunLlCWMCl2IzQcFmC+gq5wbznjREpjwxpM+aktklDJJw8LJDGAflSaQgGlD2cEG6nGlOVea5YFZOlT8yowuBsogUVcD14kCDcz+BZaWWoiWUYig1pnEv7W24iYSyb5Kh+JQ3V7KDrOgAroLQiQPmKo9ztrnBD49lblrPYcywhu4bP1X8f//45IIx8MQIqVLpd2glnHKR1UsOk+IMcRS27qR+HvPg4ZuBANH4x3b/FZhNNmLQi9urfPYfsWIb6A8RzFrP072g8MijSfHne0YmjIKFo41bMP0hC/GSBbgR/sLIQVTJX5KxLRgehWk0g2udKIGFKwlGoVqvtC1iDASdWorPFw/5qXzbXZWquyC2E+wTYqyNrpVypJ8p2MXcgvgvDZMvBHr9OzFjhTZjkolecjnOSwfRQBuB2lHGQ3EcIQ2ZYxS7CCJho1tt99ttTDY4AQna8f534CHEmvz73NIqLm+iHaptcE2Zwck/80YgMp3tUXpKVimH8BQ9qUAlMB1uMSs1jXfzWIJEIpcnxABta9B/PMumtf8oE5YxOyL49b4dUV+hXzP9kh59YMotGyMhqteaBw0BPUosaDU1vkFyVGs63HyDV/dgTAi03EPlQMyjXugPUjZU/m+3gNY0KGjrqJJghwYygvp1nLDIu3jFwO/N7o7bgHvgtWn6ZD1ia3Qpl0UDZeAopVJv5nTVoLDnmV37cGmKB3
 NIcz6Uj9
 NzqMn8B132ob5ZN6zaT5TQ0LOp3kaH8HFryOsEeluRizHj/xpFGhKb0ntJyseYeFtyjZ8PWSkOegy8OlU8V2YeDJLu2LIkUe93g051CNwDCeiO0C1u8cBxIfMnMtHBNa1GOGIFX2NlXA6hwaBlGhQoPHZwXUvUlQ3GAZ4Ttde4eE7E00wi3DZB4AXUfyYynWkhjbPKUFxUHAxTiTOWxdRYEPY9IWqTbyUQAp1GEbjGr+nFt7C6VxwU9FztZRQBiUD+wdxg5n97omhSi/3/hCpxs2nxzGiKqAfm4hQUi6y3LH3vtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 21:09:19 +0800 Zijiang Huang <huangzjsmile@gmail.com> wrote:

> We hit a real softlockup in an internal stress test environment.
> The workload was LTP memory/swap stress on a large arm64 machine,
> with 320 CPUs, about 1TB memory and an 8.6GB swap device.
> The system was under heavy load and the swap device had a large
> number of full clusters. The softlockup was triggered during
> a stress test after about 3 days.
> 
> So, add periodic cond_resched() calls during large full_clusters
> reclaim operations to prevent softlockup issues.
> 
> Detailed call trace as follow:
> 
> PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
>    #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
>    #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
>    #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
>    ...
>   #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
>   #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
>   #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
>   #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
>   #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
>   #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
>   #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c

Thanks.

> Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")

I'll add a cc:stable to this to help ensure that earlier kernels don't
hit this.

> Signed-off-by: Zijiang Huang <kerayhuang@tencent.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: albinwyang <albinwyang@tencent.com>

