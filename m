Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F11606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y6E/9qW4
Received: by kanga.kvack.org (Postfix)
	id 3C4E06B05B9; Tue, 17 Nov 2026 06:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3757A6B05BA; Tue, 17 Nov 2026 06:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3416B05BB; Tue, 17 Nov 2026 06:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 107816B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:00:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FA72803EC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:00:46 +0000 (UTC)
X-FDA: 85444318092.05.5B60C04
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE62D8000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:00:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="y6E/9qW4";
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDf0c3k4gQ1q2fbwcAejo0l5m753k7bveaKyF8JgDy0=;
	b=gMxlisdXbAgEf3c/xXgL73zA/Q4EGngSu9LoO/+tZ+AKnSs3dOZNcJQXXV9Ddz4TroM5rl
	2ld5igy0fqzOEreJ47lgewYhtoKB7fDwihKVUXJYk8vzuWH0sL5nXrZ1ZuqyjCFy7qGakP
	Ikg/+Kf2Epe/jkr1TgmyX4rePr6z68I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913244;
	b=FQOVCf5QDbXgi/8SrlS/SWF6071MH9QkFOc6qRG5L16sANT5g8K3ykn5sIIBIbKeUwRPSe
	i+0icq0AKg9hW1I12IJqwIiv/0mwjWjyPXNNeMBxTlSHxExV7YKoFSdAfpA7fA5vuAFhWW
	VqjZGS9IBstGloYpVtVnLDt+uOl0tD0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="y6E/9qW4";
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ed58279115so5223395ad.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913243; x=1795518043; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nDf0c3k4gQ1q2fbwcAejo0l5m753k7bveaKyF8JgDy0=;
        b=y6E/9qW4/eqlpPNKG0s+RShlovMMcyOV78a8Wn9vhvRwmXChuCKTt2ltDSGMeKmy5C
         bNPbHZvdyGyDiTf5yBAIWE0IV1xtOXceXZtCXZLbi4mMywcOxqapFa4KToQ4DppFngj5
         RAfzYiuEezt1tuHlvGHuNQi2g6F+4wk1YXoM8t+bWe/FhJiZSVkcDik6QTgsCGFC91q5
         QxLRNgfwSloDQuibmDVYmgNG40rQcbLCMQ6P92R/B1jbNL+bz6QyOHplwcMpvGR8Uw8p
         /a5GWCY4QJjIiaZScdoD5un0EvIM8Xkyqit+i36qKjqScYCfuGGEH3huMQTvJZKkxVU2
         rjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913243; x=1795518043;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDf0c3k4gQ1q2fbwcAejo0l5m753k7bveaKyF8JgDy0=;
        b=KXA5ToWKAlJ6ySGnEV1Ldf0wSva5adcd1UgPyFz2vCL35zANDTsJ8RMkVJvZRpTf+D
         ThOWThG7pbWtzF/gSG4Mogzjf+zmhTddAWnWTIbzN1h2tskbTx9EQwZ0FMxAyogcBBj5
         zTUVt5p+BPdlm3Dm9VcWueJhmhmtnX8BCO5RxYZJwXFTVLLEawcyykRe2Awxm5kyXJap
         xkDxYc7VvU/AoFuUsq/gTNOZO0QwkyGTcoy24CzyanQQ3usFmPQ6PZrEv+JnlT9wrK+b
         orUskGPOWTtfreaagwwiVyK++V3xu0ple9+q2sscpQd7iTvYn3obIYfmPq6LXS4Wu4mt
         syaw==
X-Forwarded-Encrypted: i=1; AL+hErG7Y3PQxxBp4/ibxOygihZU8w0oqKO3lK4vL2RIcU+A9hI206rOxUHZI4vH1FS+Mdzz0uHY5M4+ag==@kvack.org
X-Gm-Message-State: APuU4Z/HltURJC3/YNd59o6hxbA2OJbFdCK+32VdGSv9kRBYBDSEokjf
	rvWhLp/FaBopsqPUIlNsoJUNsfXpBfdWAM97V0MSj0GN1PiUccyB1bPf
X-Gm-Gg: AZFdTZeNqlfDs/BSs0x3fGyCgUfiP8Ro+MA1qUXnIUE8VrRSQUdhVU7Hqrce/GsBwJw
	dFp+W1r7k0yeYLcbsSPRwK/kS4mOT66fs8p+bgItal0LysRIfXlNfCkeelhMau18LSgt8flR5mb
	jNuikWN3cxVeE3uJ6YGUpyv/GcKP8890Erem3nqGdTrHKyYRHuuP409PSNwPaQIX1S6+VnSRhdo
	lc5GpIS2gnaDfJk9d44Mv8SOMjbw3vNvGr0A9f2JMMa1JaLP/4FCib87DjYyxyUIcZ5+jO2d/v7
	+QpESsITOloGpE9jVW1fPLH9U9DpMXzWfz92oDrtqGicGMDelZhNngKJESNnFH9UqFWI7tP0tXl
	vPYGjeHQAz8iunbK8E4e1aQ6fkDga7IHkHx8nDsOrVYzre8LhVtdUSmXD8nBM1M6Ipeexp5G29Z
	Er+S4eccV79qeAzeS9zYcoCsbMAHOEyavktASEi6k7iMTCjegIXIZ1mUCsIWAuqw+hmVZ8ePlK8
	z0k1Am/lC1Dy/G9qTaUAc8tcKQ2HGncVciF/gjYgikZ/hVooQOYIjwRaROi4aJF2DDZrTN1amfT
	CYofFqOV4ov3fsGbHBox27GlcbFL5svDtCoeMSvdE7ZMZL9+l/jg4SxaRLPGiSPn0yQ=
X-Received: by 2002:a17:90b:568b:b0:3a6:e61f:749d with SMTP id 98e67ed59e1d1-3b1b0815b27mr21198226a91.1.1794913242798;
        Tue, 17 Nov 2026 03:00:42 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac255634sm3583538a91.5.2026.11.17.03.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:00:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 11/11] zsmalloc: populate new zspage outside
 class->lock in zs_store()
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, Yosry Ahmed <yosry@kernel.org>
In-Reply-To: <20261111064707.2568433-12-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
 <20261111064707.2568433-12-senozhatsky@chromium.org>
Date: Tue, 17 Nov 2026 19:00:33 +0800
Message-Id: <179491323381.964041.11173076535030687661.b4-review@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: inwcu9ktq4qzhdeqxyeusyng4p94tkc3
X-Rspam-User: 
X-Rspamd-Queue-Id: AE62D8000D
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794913244-959260
X-HE-Meta: U2FsdGVkX1+LSOB6IAvowwI9hvmf2Mnd4UJC8fzHtVJiSNS5/FXkBdTJA6vlvz1iLpFjNbcjj6M9L//IelulzalaejSNGaAZ6Mu2ojYC4QOZHENmax4QbUQFldU2xhwjgRpMPw7wCMcoeBdq6ffKbYAqca3/nIjEIndV5u/j5hFS2stvHTK6NOLuFQ/5+Z31hTO8jgbSA+9ubuvcfZi5LP2ZDQVuaLiW3UseDmgBAVxG/GDRcp67mDGxccRmm3Xk6clm+YTVHJz1nf97iqFLALyhkBlUdBX1aqz1LgNy1UPWkgELLW0HxkBcYUmHQ9NfJuawD8qpR6TKhWTfwDs6xo20BWVC/bZkJyYpz09sOdSnVUQZmNldUQK543XJQk5hoJZh1WbB8w6sc0V9B2HePrPhfszWVHIj26rsix905rdNzYZtlNqcZXcONZehMGAACi+YZhtdP1nOoZ6S27j1U7JhXx+gIn8RuRKC7i3EeGyU/cMC93fFnX6Ip8VM2xjFmuFtr7NX/nTdZ1uB60zJxCOtJguQRSndm0ujZ1/FMTA2b5V2u1IpR6x8XripFoXynN2V/37bWuqao6rKPHWQtOfBQgb8HhwowX7vi2PyLmH7Cmjr2arwGvnETLMidtaJX0RrsAf39egrqc0FwzqoInjgjwOEp1OJNnpIvtNZsr33t31aPsJ4aWuPH1LiGSynd9yQeW5eksO1y/K2jnhjlqTYFeCNfl8bOX9TJBB2EzqDHZVemV3mOYg6p9huOiAHg395BJMfI/VuDVHam1nK9Fvd4OdoRfBTdvC/6NnLOgD2B6x1SRXnOrWtcJ+LwiJ1Lw6izJliiiB10/XYD6hys9BrFoed8tXVUIQc47cizG0YAD3/+21nQIDbBOj7x5oN+hlLBPct9vRda6hAwMgsSNEIOD7MS/t2ZiP1r+xl6kBSRoJITR3DzRHARB95wDAW8Wv9KIV5a5haWn9YoVi
 ivew/r0k
 vivabzKlBHBjiLjuXUWn8aJyUrpE2ZekHEa2/CR4542DQFZ9U8TX3unFo2Pf2Y25Aef6XUBKWCdGgUr1QZ6Uc0nLLZk03brJTL4sO+BMosw/VzN8Wyiar7jd7hfIQ3Cur89q0NJ0tAO2/w7eDEDRxub9jWKMd3ccaIA/E3fIW9rvA07lsARa3iXXgVpc0/LpxP5n7Pm+ShQYTOBUMRLz6GkimpR5pONzUF+loaWFt1/gT3w+ca/7fdhK/Nb6vO6BYiqFPPNLsVi8Fgn/v+idmF3ZtntezboLxe+KbVoI6bwJeZ+jmBYMBgbKPAdKLTATIQUxjKE0e/sE2zHhJ+52xmXkL+am/WJ7AMDpZp5As2pcnybJD3qCg6Vd628yUhze9yk2Hnp/DTJ59k3S2jl5076ODaMLt4mZKHslD/MYg6lBpAXRhM0tiD/t7GJiKrPGwVl+YmKFzWfvbkjFMdLJw/249nPGBrxGdR9b6OZX4DeXiU/O7rbWK4NA6H1HJVrZrrylJU7+vLZsXh/o/u5Wr2m/fBGCk1lk/tMdQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 15:46:34 +0900, Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> A new zspage is not on class fullness lists and is not movable until
> zs_store() calls insert_zspage() and SetZsPageMovable(), so neither
> other zs_store() callers nor compaction and page migration can see it.
> Nobody else has the handle yet either.
> 
> So for a new zspage allocate the object and copy the data before we
> take class->lock, and don't take zspage read lock.  This makes
> class->lock critical section shorter and saves a zspage lock/unlock.
> 
> [...]

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

-- 
Best regards,
Xueyuan


