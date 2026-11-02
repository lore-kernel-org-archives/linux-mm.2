Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33357606EE89
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vd2jCMsG
Received: by kanga.kvack.org (Postfix)
	id 2FF886B00EF; Mon,  2 Nov 2026 15:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0926B05B1; Mon,  2 Nov 2026 15:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7A06B05B2; Mon,  2 Nov 2026 15:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDF2E6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E849D1A0277
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:24:51 +0000 (UTC)
X-FDA: 85391307582.22.14E100A
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3692B18000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:24:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Vd2jCMsG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3kPHoagwKCHUVakblpblXfTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3kPHoagwKCHUVakblpblXfTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--chriswiseman.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793651090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1SeODRoO7yM05Fi9Ezs7mCvp430XVHwDnUStx58P80=;
	b=TToqrLnDb3dhVHmmHz/4ptd804zgdK3sKC2JzYm38PPFQbzzS4y+3cWOI2IwzKiCl43pK4
	w1+kLjv/SYOilEtiFoWbeVpUAYryu6FvCCiPxqFNFWoMjq4V2q4/bzo04ZqqAxbd9sYhLv
	76XFwNVpiNzfFaYSX752YgRgurp+GAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793651090;
	b=eh3oKTdKmvsJGbOO42tc3MGYUYasS4O1jKlCAPA2o+y64viAzOcIopM3nwznEEO6nAFnm4
	P5RG1V4JX3vE8YyFFsXAxP+4HpUbAAYVTTPD5cEcbRqPvCdBYTkXFl7YVJeLapEozhR/2Q
	ZnPzGHFuCqO/GypViRub2O/Ul0Ntzq0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Vd2jCMsG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3kPHoagwKCHUVakblpblXfTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3kPHoagwKCHUVakblpblXfTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--chriswiseman.bounces.google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a223755e4so13944473eec.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 12:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793651089; x=1794255889; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x1SeODRoO7yM05Fi9Ezs7mCvp430XVHwDnUStx58P80=;
        b=Vd2jCMsGD57+NOKlAxDxOf1IsfilvI1BArh1XLLR/QAisvezS4ZTWdFsorxOljoKbM
         0J1QuJ/MWv85tn15U4U6D1IFqX9utATN669LOPZ5Fgi0TXrZiecJcjd1Nh78qDFohVhO
         fRTmqBTvJWdk8jJIKQWXe61JkkB0LH6mMWVJ6WB4kTbW5x2whqIH/KTG6XXfIVT5VozP
         b+oyoiBxy5RwxLMrEFvwYYom+m1/nyWebOUcsSHNzkGJZgEIgJW7NL8zo4S78PRit9Lm
         r9Go+QgRWgatxTpAk7akQ1A4C+DEic0cKWC2QhHNKlbevP9hAozxyQ3mqx8SkiPfvazN
         Tg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793651089; x=1794255889;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x1SeODRoO7yM05Fi9Ezs7mCvp430XVHwDnUStx58P80=;
        b=XA4kYVagAK2Ex/iuzzYk7UXwbFcE9axTcqhMy54EyhB7EwgGILiTHVADWwNfr4gvoz
         Mo/nzUIn/ZrEl2uWNIkBAiRDq76d+DEQVime7CMXLUzD8SR4KmEbg2rAh8LVOaWs75cS
         MNaGxkvTPc3TlUgDio2Dqwem517R8f1MmpeM0JMMoRcwWhdhLprB3kGHvo9tOMIzLg9y
         fqC38tZH7H51WvhZcdaO1/4jLlUB5V5YLrqjczP3oKSZ5MkfzYBbagV2NMEsQSRreEY6
         tDfMnj1QfgnIvrgbGLyYwFvmgzwH8Lw96FN2tWnWYlyxF1XZ4ZzawCKHDZuyY4IuKyoG
         26Jw==
X-Forwarded-Encrypted: i=1; AKwUvBzfV688FLN5jf8ihX9bmXlh7fzNxYYpMQVDKaZcfVB/FnBYsj/KqP89+gHPJIVg9GBESXsbunNjHw==@kvack.org
X-Gm-Message-State: APuU4Z+1jIl7TZgyXnmS91PGf0c668UIuBy6Dhffvn55z+Yfut6b7Niv
	BRyJUJW5GfDeeDbeX7h0/oqsNfZ9pLjtJ1eJogyOzsSm7UhrbbKt/BWc4zAbLRXdBPwabn7tC1N
	ooGL6lhgn2RpVd+rJSD0njqnzuGMk6g==
X-Received: from dycui21.prod.google.com ([2002:a05:693c:6015:b0:358:2c8e:30e3])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:895a:20b0:366:c497:610c with SMTP id 5a478bee46e88-36a423fd087mr17250916eec.33.1793651088420;
 Mon, 02 Nov 2026 12:24:48 -0800 (PST)
Date: Mon, 02 Nov 2026 20:24:47 GMT
In-Reply-To: <aufPMirl4cD7tz0X@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
Message-ID: <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com, 
	Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: br7niwm4jqkeayc5axxrr7wiox5s4bfk
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3692B18000A
X-HE-Tag: 1793651090-135912
X-HE-Meta: U2FsdGVkX1/wbnieoNUUKTAnD4Lrtws/xvdTEW8nsmx9gWY6pVYO+wyym2mUnb99guw5aM0Vhz2yYrkxCz85c/IcPa4iK7SLC+Kyp/guzCqXk+hTs912DmtWZDpTVKfNEzaUEj15YEAgL1PIp4S52WAOrRgPF7M5z+VMiRerpLXRZHtLVD/JA2fAzMaIqvpNyIChEB4SwZVcRDQyh59BngHrKNUliRCy3wV1SeYS44EBntqZQri1biR8tDVXj5kBc2pWBJuWQSo1FlhvCkUyUet3YvMuoNHJ3I6q6QHWFaQE9vY5XfLYekSGdL7K9vr6sq4yEEb3Qga5QFAP+lqGBDm6JEel/ZJwMN52nzukSxlr0LEw2fMfFV1xecgE2NTihhHMr6ubff1gelAQeDIUIokp/yDLGXaOU48Jlm6UjOxDSXrcXQiZVwc4ZKvFzpCDgbYjnZmcQaQgtEJh/CEHJ99tddLc/RkvtfXvIb9WpexmT3IL0GccEut5kWs6+otqzmp8SxvMPADiLdVSbI7L4Up1GRtbsGvpi6co1QCRfQjbAGMT317rY0HHND/yCn+sDXniR/prCdePLdL5dMmvUaUXQEeLE/pdZgDyATPpeTIQBWjn6b0nl3swML6XprjWjpN84YjA34qtwbQQQf0UVbxhHliS83YMAdLZBa5KFgwWbOskxcQVtHuB2Li0pI3KaSRSCptfGjJK3yyDJgN3mTskB8R+Ns9e34PYQr89Z0UZLkQMTpbvXgyNlvsREd0BMlvxbdn9ZY/GLVBczmKJjw2CgvUgwdLF2R7c+nEJDW73gwgWgRw6DkoS/x2soY5+NV8Ee75XumBmqH76kVEDEiRqulazv311PBotGlNb8+iJdrU0EvcEKE/8cCSsT6fqfqB8QJfbSnRWOCIdKZ4P9pclLOAgXgt8YkqozGSJBXrW0bEdMugDEky4eajLusTjZmBn7mVGwrZjV8oDeBj
 kNaURBee
 Hg7+WALr002uwNvJw3tIKlqTG/JeSKSrz4qlNIvFWkB9nt+wmorxrdDYFUjRr4i55NSmIEJHWRiAhPUjYngd4yz/7fLxILcKZ/7pmOw2iXIVzEH5zdV7UmfBjcJjzFU7C7jJuQFLJyOR7PUts9zOikNV/hNOjl4xgwP3Z+QiZpDP4JtK+3iYmCieHjlgBu78HuwIcmcxDySK1cJXBg+wWBKk7pDIzYRri3MLyE9/EXiEAyOWaFD/jwI0am+Shzv4yTHv0NrZa5q9+dKALRE/O4eapLjL1SMR0nYnJJJ96v/iMmzJYeBDczAvOGJFvIQ7511iYVsaivYiMinFS7ACzhiz64CXUhRhRWSHw6N0kKs1FmH24U1FowYyMJa6WDJpTso6dOdYMAK+6ObJFNbnzyFvPI0VFKgTXQmLw8+IrK660eJsX8qbrKVBTrCqr49RE2Oph6h23o8L4HNnu0QZoZ3IC1iXmUcbHxpHPeSg5ICuXSYJvYv2m9LcwQ11O37FfVuqqVC2ucEBoFAI9xe/OU5bTM1LN5GhBR+n0zQpsK6eT87eNQGdHaBOlKcHuzIuYEThVHRpV6TcI/ZjDWgWv1Idok2tQm+fPlwq7C3Eu+ly9ZzxkjOZSmGFuY6IA4dlpHU1CcRxmqLCXvDXplGU68HCr/icYA4Q0Jb+hmcUPuLAh612Q2GsXB+JyR1LGomf/bm00NYiei5ALavM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/02 08:47), Sergey Senozhatsky wrote:
> Adding Chris for visibility

Thanks for looping me in, Sergey.

I tested your CONFIG_ZSMALLOC_SHRINKER=n patch in ARM64 QEMU (7.3.0+, 16
boots per arm) by fragmenting zram0, triggering a manual compaction pass
at pressure onset via /sys/block/zram0/compact, driving ~240 MB of
swap-outs under memory pressure, and running a post-swap manual
compaction pass.

Your theory holds up: with the shrinker enabled, the kernel compacted
2,218 pages (~9 MB) in the middle of the swap-out, only for incoming
swap-outs to immediately reuse those pages.  With
CONFIG_ZSMALLOC_SHRINKER=n, mid-swap compaction dropped to 0 and zram
pool memory was identical both during the swap-out (120.9 MB vs
121.0 MB) and after manual compaction (110.9 MB vs 111.2 MB).

I also tested adding the unlocked zs_can_compact() pre-check in
__zs_compact() on top of CONFIG_ZSMALLOC_SHRINKER=n, which cuts each
userspace /sys/block/zram0/compact scan from 97 us to 27 us:

                                  Shrinker ON   Shrinker OFF   Shrinker OFF + pre-check
  -------------------------------------------------------------------------------------
  Pages compacted mid-swap              2,218              0                          0
  zram mem_used_total (mid-swap)     121.0 MB       120.9 MB                   121.1 MB
  zram mem_used_total (post-compact) 111.2 MB       110.9 MB                   111.1 MB
  /sys/block/zram0/compact scan time    96 us          97 us                      27 us

Representative /sys/block/zram0/mm_stat snapshots:

BASE (CONFIG_ZSMALLOC_SHRINKER=y)
  pre_onset:         184553472  58747279   82350080  0   82374656  0      0   0   0
  onset_compact:     184553472  58747279   60456960  0   82374656  0   5345   0   0
  after_swap_out:    334196736 107289761  120946688  0  120946688  0   7570  29  29
  post_compact:      334749696 107472834  110907392  0  120946688  0  10016  29  29

PATCHED (CONFIG_ZSMALLOC_SHRINKER=n)
  pre_onset:         184553472  58747279   82350080  0   82374656  0      0   0   0
  onset_compact:     184553472  58747279   60456960  0   82374656  0   5345   0   0
  after_swap_out:    334372864 107347183  120922112  0  120922112  0   5345  29  29
  post_compact:      334995456 107550158  111009792  0  120922112  0   7767  29  29

