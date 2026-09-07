Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8675FC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7D76B009B; Mon,  7 Sep 2026 00:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497EC6B009D; Mon,  7 Sep 2026 00:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387CC6B009E; Mon,  7 Sep 2026 00:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D22B6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:58:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84FEF80677
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:58:32 +0000 (UTC)
X-FDA: 85185760464.23.AAA650E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E4BF40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:58:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhWAYS+3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788757110;
	b=Rt6MFGFCHEoKeMYL16R1ctZsWSmPFf+0l/tkiI7EGYvRNF63jK5wUpLLCee+U6U+ImCIA/
	62TGu2KqEsABfRTIQQatW6fWQE+V6tCx3C5/okROhoNMPPRBUXqN82nB0AI9nUa81T51VY
	zuycP0fug9WHd43SolzFS/3U1CLR/Pc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhWAYS+3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788757110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuehE0uxyP8QclAP5St77Z5WsLN49LUO0mMCew4emS4=;
	b=WSraXMrYcRuqJQfgEeIOHvYIqqIsTMG7Gdm+YWsAlU1v4ApPiCrppN/vsOTGZOe3u6LS8U
	GNx66uLorYuBKzJ0CsG8Dewm4P/bNMf1Vs9Mr9mcxXxTW/nu78+FSpV4pWhLn5GZF7fQpe
	h/khGFxc3jjQV5XFl6fcLV3UkA5OT14=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2544ff970dso400907566b.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 21:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788757109; cv=none;
        d=google.com; s=arc-20260327;
        b=cfMoE0g8DJ+eq/C1lEHfkckfQJkeDKtCB1Hc1tUTtAagS1JdfSJOAP72eIfkNBpBMV
         D74FCyvifTARn0oM4EhV6gaCKZBqNtJS6ioW4BZOyssRY7Z8P0M5ECFeKqvI+Rs4UkyB
         vwS9Ds2yWgspMk6KSH868WPG8z1GtcF/rn/18kQ3OdQaTjxmtQs4O+uNk5pZoyRKMDNa
         /SchgfwIFXdawiz2zr4hAya1Co+fm81HeRMwXsMQTiJVHQzTpaxWBCY8tXPd+v0fhBA1
         kD+iRDk7WKc0pJp8ehqbbtdocyoSY1F9xfkKX+khkINDyRPj9t+ccFNq9bh2EMF8JKUt
         N/3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tuehE0uxyP8QclAP5St77Z5WsLN49LUO0mMCew4emS4=;
        fh=RRbu6igDyptu/BfVdSytSweFbj6Y8Iy9hfsYwsrYMcI=;
        b=DBdjryKHZnwCjxgL9wS6zDhPjQ9KlMdUgyhaTh9UbD7t1JA+MzRs/7B3ZjeQBRjyVT
         +N+XvZpXyTGiKszZuG+wtx9HtnR5DSbRpDw5k25Pv0p+oO2kGMGMYDlFPBtcbGRfuo4T
         ehF5c/ln0sdgOk4c08WgfnO/yWX3Hx5NUZ4tHYGjzFevOT4kgIt9JE4CJml8vPyiJChY
         zlh+01iOpDU/c9EsM0w5XU12tWDFf2yBU0MUScCgL1/E4P5aMEtejmc8iAsh2sJukbKy
         UCOiXkpO8owQkOVUiuOz/fbl8/xy6K+NVez8nTVt0uyzSCbIJkfNTqvzWKUjcTsXkq/5
         qH1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788757109; x=1789361909; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tuehE0uxyP8QclAP5St77Z5WsLN49LUO0mMCew4emS4=;
        b=RhWAYS+3LoxMZaud8lbm6JrUUjXwd4O3oUL281WSkM/vN7NfYfZyAtPpT27rVc6gec
         VSdNcHItq9/HZUq4ppZkFfg6GtTYv/Qs+/alMozCE8oiyEtiLm7BtPmY0ZxbeJ5zKF5v
         6uV9lNg2q1y8vGTf+D4yjkpA67aKrtc3DR2JZ5/0TbRVbxd6Xw0PyPS7RISidj3NngW6
         C4KqKB7oceJ/FdiUiYExdGpD7/SUXrXMgidlSju5IAdXUKDKmRg5TFhYBrL1QCHhfYWB
         1l/FnOtJ5uVX3AgapZDkCjMoSnXlfvimswcO8E02OqVw9B4Yrpgxa6JgQIgqX5Mr2LhW
         E8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788757109; x=1789361909;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tuehE0uxyP8QclAP5St77Z5WsLN49LUO0mMCew4emS4=;
        b=eyWhYa9utdsiK/yzqEnonTe6gQRL2ARow+eUUYonqroizuiy2ntnxQZY622O+vnreV
         WnpkGUyU4LHW0mAhxdF9iroM4rS/4FuUEXrBlAl8qfR2FlLRH5S0VjMb2JpM79VBfwyo
         zDdgLQxesq7gyHphQdPEAg3seLBgUUeoAuouy4XK4abYrBGMMaefBC1Ef4XSc0XIhVoZ
         RL09t0MHFbz8IH9295FSckNWwCDdboUhF7/wn4dhFZPbVZLQUoV14u5J3CMZ7gk/g7+C
         zz7JElTZDjxxsj6d8QJR/96ZCpp0mnkN1at1pqDe5BVHV5I64JMVK9tRwAGb8T26moyf
         H4Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzYG0AtOWWed8AjG7n8nhgBXJjUehVHWOHK3/avLncQaVC5/Avv5cnY0nJ9B5LHeZSjJSdtAochjA==@kvack.org
X-Gm-Message-State: AFuF++l3SyKU++2PfGhFEjBSgUhkapAxdzFVBlkqT6Rq/TXY1nGBmCiM
	g9lNB5Le/i5Mcu2HBqs5oIqG74oWN4U7iOJJZ/RjvtJLpAMpY5ZV4QGw6aCAmXbFl57MQE+3n+6
	J71509w670QowdmYvjOO37fVAE26eMQ0=
X-Gm-Gg: AYBFou18M1CPALD9Gr5rW3zPezMZf2/YOE2lwws5KpSTG8pT4buglMPC5g4It+F2eac
	hUYn+UitvSzzaO3Rlsntcy4l+DoS1hmM7ElXdl3WDUUjhK3NvLnmBPYOnJf5TxwP1cj9qYTEi+I
	dEATkqdxEGdEXBGAU3w6C7FnyU52Nzmbim+ctOnuwoCs7lGvjSb2m2C56+p5pYmDWeMPOdI81zD
	0MpA5ddP742Rfw79J8JVuzvUpsY5l5Ncphz3GL4Aws0RQg1zHqpK74l287JeNT3ftvciKLmBrnW
	EpnTOKll6ZfUGx2BmYf7M9MEiglsODaydpGzd0RrVZvjVocZaNq3opXXpzdVd9Unp5N7Z/L3avC
	B8kVoGGhO5IBB
X-Received: by 2002:a17:906:f591:b0:c20:f529:2d6a with SMTP id
 a640c23a62f3a-c260ca339fdmr717091266b.22.1788757108783; Sun, 06 Sep 2026
 21:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 7 Sep 2026 12:57:52 +0800
X-Gm-Features: AcwNN1WCmWRL6i_U62NrDST-CssECUSdn5YmF0MTFdEu-IgtpYwqDrGnPkSmwFE
Message-ID: <CAMgjq7Cf2ZjkW0JxtHnm06NECHA0+wCXAxd4tkbtCLhC+qA0ZA@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nf8biykzyo3d4ffch5zfqzc7juqfbz5d
X-Rspamd-Queue-Id: 8E4BF40003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788757110-715858
X-HE-Meta: U2FsdGVkX19suelAL78SeuBPXiTXbFv9Jg2kmFcT6XY9sxROiMPQ46zgKzjFrevPytb36ya0XAKtGtH9sPEeRI57nBJ7bu8npZ7LPy1DH0nfYclpj0T8aVuMY1uJoBJKx0wFNPzP7fTp//eboxMkf0at0hDZvuvxBWCQfFjwOIcmTN1KFtYrfIXsjSDmIDLey6lMo8eLnrTrf0TSGpgAVz8zi7ua1oVb0trkjUSK/U+BYDuceANjMNhzQVHxBcp33Q3nwPTJD0MwTH43XcVll/oPPY7Wn5BLw6i9481A0SDBTY7rGnuiVd7GZGnQPjNY2xd4dqkt/fARFTE3ZjEmJOaejy8utkxjuD+V5BnHIdFNo61N5c1XgizcwV8gLuNJl5F0KKZla4Z8CZGNmQEkl5QdViuAKfzut8SFlnjSWBWobLnCXZ89w/O83Q7lKvZAwVmSyKkLQ8IPx4XNT9kOuxrD4dsCnAqD7sZCoGJWEkjGLcyLDeNXa22MwczpoQXnEBnzfSNPWkblt09Ow8AqN/XnLBi6Aa2XFBQlMB/ROqVRiA5TjjZxIC8bMr2t8bVz/UIqFrP24lQz2s3JxCbnn8hjCQlwmktIsN5IsfT2fDJtBdzrIiNKGrnA7nLQILFokTcHk21dLSkNds+HHtkTpwT/1I2aVktj++jyLW5+tvi1WEP3VsROHJwr3tRrlgzTLw9R7LuIF7e9jEc+/8N0wLRRNvyEOwge8gH4c/hqPirEDZMFS7G6myr2rGA55icuZIR4uij3hHnmMFbVsAiLu9ehDBnpAYqZVSN9qS272QIwVnkjKE5n0urQ2IYm50dp+AfX+/vqJTuDrkGS2E35MbZTIZq0gq1nHnoySbHXuRzGdBdqT812vEZuPkeWiKtZJv0xrl5Qk1hBZsCFQaWmnGiA3+Ww2qW76SHzQa4G0LftY0U63n//uMHRS9WHVHVL/Nuti/y1pcB6toj0P7E
 gJUUkGBH
 KF8irN1gPv1hTkXfwNdmAM1Sd5I/HUNsAXoRsQ074IbpHifnlCFgRkWlsAWh802son1u8plKUyu+n/YSX2S7AGgp0PUtY7hMq/47wzZ3CmC6wlaDzEz3+xjgUdNCg0UR2Qy7Z65Eg7GYLsD/wuWw6WOF9fA3z0ihEeWXPMyf5yRZVg5Zaqs6XwbQ6A8ETgwqrM9G7HtJ1Z85uabacuYzCMmelI0xZzRfuNdu1U4BatkC8ZSE/5H1JWGZA6N1nf6B09auTRRssydnBOgg0nffdSiPxGj0GBpPp0Nr5md9afDeFUzkBSYv4wui2lgdlfgdib+Rq5B652vb9fNJQyYuv/qJYxkKoEPsX7J3kBpbg26eRD9t96OwB+SqG9/KgB1mHywTt0zVv0jw3sKb98rwhBK+RRdI9+fGlSLv8qwqsGaepSco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 11:29=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted t=
o
> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
> counter can start over.
>
> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
> set the PG_active flag if the rejected folio is planned to be put back to
> the oldest generation. That's fine.
>
> But for those that are not put back to the oldest generation (which can
> be treated as a promotion), we do not clear LRU_REFS_FLAGS, which can
> violate the promotion mechanism. This means the rejected folio enters the
> new generation with stale, inflated tier bits, which can inflate referenc=
e
> counts and distort eviction statistics for these rejected folios.
>
> Fix this by clearing LRU_REFS_FLAGS for rejected folios, and also do some
> measurement. On my 32-core Arm machine, with the memcg limit set to 3G,
> running 'make -j32' to build the kernel showed a small improvement in sys
> time when using either a zram or NVMe swap device (averaged over 2 runs w=
ith
> no significant variance).
>
> zram swap:
>                 w/o patch       w/ patch
> sys time:       1666.5s         1589.5s
>
> NVMe swap:
>                 w/o patch       w/patch
> sys time:       760s            741.5s

Hi Baolin,

Thanks for the patch, it makes sense and I like the idea!

However, I find it interesting that your test setup shows such a
significant benefit with several recent changes when I can't observe a
performance gain on any of my setups. I'm a bit worried this (not only
this patch) might be overfitting into to the kernel build test on
specific setups.

I did try this optimization before and found no gain, maybe it is
somehow tangled with some other recent upstream changes?

For example a few recently landed MGLRU optimizations sped up the ZRAM
kernel build test on your setup, but slowed down many other cases.

I still think this is mergable, but before that, do you have the
LRU_REFS_WIDTH data from your kernel build? Or lru_gen_full output? In
some cases it shrinks to only 1 or 0 bits, leading to very different
performance readings.

