Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC98CC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209516B008C; Wed, 14 Oct 2026 22:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA186B0092; Wed, 14 Oct 2026 22:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9466B0095; Wed, 14 Oct 2026 22:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE9A06B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:11:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78D34405CA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:11:50 +0000 (UTC)
X-FDA: 85323234780.20.C1C8917
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id A159A40004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:11:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=morMn028;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792030308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvIiWBHgt9RJ8Lp49q+d6DWrLq7WNl23wUdd8hsh/fk=;
	b=sw66ZVmmLg0s56PMLoRAcWEXJ6qZm0mxqGHyJpbyLdSlG6VkQZiqCe6gmxIqt2MrN8A/5b
	ec7RcgZjSg4+gKqk5l/8y9XtP78kIFKKgMOPvodFUznpTyce2eCasii9cPhScvGapDkHpt
	T0OCog41DmIq4z4jD4ffyQaBVzaPegI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792030308;
	b=wi9nebEqs1lXuMDt14fqyH4wuItQ0azkISy6ApW8sff5F/0vGdIJqGHYHe8lC7mepVsbHQ
	YWjHDczu6b131i/PQMxi8QkV0rfTlIJCfcfmW77ByCMeZb2c4LZ9quZG4lzZHjcbtlBb2W
	tDFsWGHQVhclOEYcmj2lJWs1Fp3I9A0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=morMn028;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd5e2d696e0so1197929a12.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792030307; x=1792635107; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LvIiWBHgt9RJ8Lp49q+d6DWrLq7WNl23wUdd8hsh/fk=;
        b=morMn028lr//M4g919kwTirK8yFkGNBZE7xVV5KBgtcHvhnK36weIn0BPDKmJ2fr2F
         yZGLns9JjG9mYXAf00AJbXZOaDtAT26ESEMIXZaQrszAMZQtoMV+qTg7emNx7aWC/Wxz
         HGqAwVC1/SblnDMM8fsnTjQ0mNYuKaeYB1Pdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792030307; x=1792635107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LvIiWBHgt9RJ8Lp49q+d6DWrLq7WNl23wUdd8hsh/fk=;
        b=gxeQewVoRbmnHYI0VGwM32LK7nTVU0jMF8Gw9xcmoQiBf5x2shwkf1FTsy6hlkmWXr
         9YbUAwFt1IivAg0LqjjYrtWtDv3/95NnhmeBJA5Lvwx3QrISt+vqbhydOuiSoipVm7iz
         syWu8/kXEwMBNX6bdFqa58PSAQme0i7nCko9lnf4VPWxFYW9iORe/PdDT8a2CgV6AqCo
         wTQ2G+m8OsZDtQe/RZOiBZHym2NaT8eU34tmOqhDKt63PIROs+eKpXk9Up0Jy2EK8WJY
         eJ1y+Sx2EwXZkRInBmulWbxRXNQ152uSk9dNvMjif2U0AYf22WEvrOxnh1uK2tq8ebDg
         Xf8Q==
X-Forwarded-Encrypted: i=1; AKwUvBz+vW4CcgZEZa58tcKJbzs1WSnQvQ8oiK6NVDH0ovIeO3mzxHfyWNDAQCnmv7OCRBfD7CiLwA/MKg==@kvack.org
X-Gm-Message-State: AFq9FYKxvKXA7pu21KYdwAfKsTX0MwVfb4X9+5sP6IF7k1HZybHvwBnR
	xVIuIz/kacTfG02MAKpz31BeM6eWhWQyvkravqxlW5slCAM/wfyWGXh+/6ZOit0tCg==
X-Gm-Gg: AYBFou2cK9kqvXnJ7TD5BnHDvDND/f3tP8xRBsuXXDcljWQfiLAQNN0559sa6Gmw1Pe
	WIj2/61mLTNcFjiGX2Zq/T3kFAWGy6iA7nTe8J4C8Km46lARe/hqJStUut64XMFpDKJCwvhRFi+
	AMLZ2oy+BQzwE1YWrjOGLAKwKUO1NMTAsMlCz6s82UzXStEiVzFqdnn0zSGEsmfRRnJ93rej+6D
	fbq6ZonJEsfgtrRclY+B63CBS6u/Bzm1KcbeCKUADdJIMTJ1oOho1Luoa2AhbyTlb45lh7/0L4c
	aDhwmzI69t1t2zmohMbCVX0Z7kdFGlHr4sh6EhkTU2KQIUQ8NgmbcJmyQko36rvqy4BT5TbLC/W
	h+HJD2YWza1z/7DB42IRhGzDVDKNXHuimza0LR515Ge4dYMFss1MwQ/qeao4WTYLloGbw1nBKpt
	RyVrL7UjWblWpcB5GUAYZM60eUV20+Cx0cgfZdPbuv+8NPP4schF0THoxeMe9dsPXtuAX7IN4bL
	UEeOwUjqbfM2E4GQm275YU+uHwDBwfRpYnmuCc=
X-Received: by 2002:a17:90a:e7ca:b0:3ab:36c4:b500 with SMTP id 98e67ed59e1d1-3ab3a39f232mr15295954a91.5.1792030307388;
        Wed, 14 Oct 2026 19:11:47 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac937f2d3bsm1227191a91.4.2026.10.14.19.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:11:46 -0700 (PDT)
Date: Thu, 15 Oct 2026 11:11:42 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, baohua@kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atA2JznFm8zLIMIb@google.com>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
 <20261014153603.1365617-1-zhangbo56@xiaomi.com>
 <atAj9o5IgrAeiGiW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atAj9o5IgrAeiGiW@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A159A40004
X-Rspam-User: 
X-Stat-Signature: 3q46kq68tjwwnea1arhjbpchcxe8ippm
X-HE-Tag: 1792030308-141093
X-HE-Meta: U2FsdGVkX18ETgrvywSPLVNpEHLzTvG8ksoP8+9U5Cg+WawZeBAv8kko+c8RcUFLw0NU0BKyEZh4Qt353bG7SEE91ZrCrRwdVvGRbaPqkx1YkZ7lAqQ9OpjhBfmovAlXKz144LYhGip+dq+cZW/RMyOYtXZSdUoyxdlL6wkU0s1ki5dYDE6Ch7zBXagFV1SJDy/CUh4IiGeyx79nsRctBgakzks/tC3n28gV/qphwTQmkNncp5uXO/50rPdQeuY0JjssGTjRWA0Y4KClbnyPm2TkYypEGmiLc7omd2JWRx2s5o3U21Aa95hNC1/ajd6AZWpj3TEi0VYSKMkN20Zqz8txwY6FoHgumPppaq+hXhSIHd5HxL4EB3gMoUJDh93HD07MrgmEeC9MkJ/7e/ONmwH6F4WVBNF3oQWUxJgC8xy8LUsV1HyToC29/W9i9GrI0Maa8h/qcmsiZu5adbb0XvR5QjGpTGHGD20FxoHPQyHgkJnpfKEuUoHJ3cef5bVytORz9/olOLhc/zLBX08QYEaQgjx8lE94I94Y6amcU4DH4IKifgFFArtcEF+tyje2LWJ7FgDGCcDnXS0euREmkSihOpRk59omdvmRjL5bAdY3r0Od0OZ9D2Bfp5qoxyuZMZQe2xPx5DOstrZt+jtxrRx9mWhMFJiq3FOpbzavMCrIrbSytR+p7Usk9gW0ilCR7z0ARWNPcfXmTO37al4w4RCrnns3EbPu3/F8vcnoMz1Uvx/uHBhJ8jJUYdmneOgszXskSlcxPo/f9eDh7228ojUM0QeG4lg29Rf7sZFJUreDQJy48ZT8XDSCIDFCDz5AmGsChKLbdxJ5uHNx656KPnB3Iej5MC8OIwxKrGKLfk7vgmKDLQO3HYA0TT9xz6MA7hooTsFycGuarVw9bCC1ppyBftBz1DNZFOrSE+zu9npkOzN1RsrC7AIvXKgWxPeRZO5gRxK6pL8iEcrlSzr
 u8/0MQ8T
 iDogsvOrbW6OP/P3r4IxUecN11Bpvznj2shEV6gSQxhK2qE7iHwh+PDMg/sKlAmTsT2/4H+0m4+TgWQh8gFB+eE+mlP1umRqb/lKtjMN3n+zPaERKlBPVhCcT1tQK8qr2Td1Fn0zbWEFIICAMOpoJnxfBhHeChkS543tpbTuea8GC5+th3G7UVxDNRT4byinJL/idVgrIAAatCn0fRHsuos4YHvaC77AdgC5e4BR9mhq6aTNYUNhay2lNuPfqm1hgC++jn0UjF2j4Sfu+op/mqdp8SMeDcEDF0ogpOvYQ+CR4QRrO2KVJzC/NeXYQADDImu3tgqbR6R9XPOlwfzEmnfnU5/aRTgV19CMY1oU1xGkxqK6R6XScKW8AwCxi7tW3ZrM3Gb+vjcNdVrUD69AK6LwFkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 10:41), Sergey Senozhatsky wrote:
[..]
> +	if (zcomp_shared_decomp(comp)) {
> +		struct page *pages[2];
> +		unsigned int flags;
> +
> +		pages[0] = sg_page(sg);
> +		pages[1] = sg_page(sg_next(sg));
> +
> +		flags = memalloc_noreclaim_save();
			^^^
			memalloc noio

> +		src = vm_map_ram(pages, 2, NUMA_NO_NODE);
> +		memalloc_noreclaim_restore(flags);
		^^^
		memalloc noio

