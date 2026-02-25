Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1D7F55425
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099586B0005; Tue, 24 Feb 2026 19:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047046B0089; Tue, 24 Feb 2026 19:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A796B008A; Tue, 24 Feb 2026 19:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1EB56B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:10:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 939D91B6BE4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:10:08 +0000 (UTC)
X-FDA: 84481046496.04.676A4F6
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id B23C9140007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:10:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nh0kkNvm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771978206; a=rsa-sha256;
	cv=none;
	b=B8BfNWvZnu8KHnoSaVxnQ332lWUvqu67pA/KkGxES1Pq4NBSAntQKKqGKuhPdlRk5gN/bJ
	knNlWPuMZPDuv33egA3+Wjrw30lV5sMB/IDMNOSXy3al9KCWJTHIPHP4AX05ZSpbG2mNLO
	J9bUl9zupFKQVx79BNAnzDAn1UtyxKY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nh0kkNvm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771978206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTN9nDYyDw1VitSAoVU8XmQ2K7N+PmzLt6G2wl3/Yas=;
	b=fDAj3qYcn3AsmsbgCuadvrCBHCHRdm2o8RMlLwsSMEQUTmLJwsb14ttebN8FX0nd4CO1SJ
	jW90BeIUd82UHqqaiM30qfpMOxVgyF8XXoKEe3zJUuezyH2DIJEuFoOh4DGFHyjkZHpJEt
	w4616YjhqfssbBqaD6lTTc5q6Z55KF4=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4833115090dso59222225e9.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771978205; x=1772583005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTN9nDYyDw1VitSAoVU8XmQ2K7N+PmzLt6G2wl3/Yas=;
        b=nh0kkNvmHd25Ag4GM2aAmv1rDhvq9L7QLE9WlmkoZpE68/AEkSpXT+NIiO/gLXCs/k
         Phcj179Izior8NBC4yjf90U/WgUC3tXd7nW6DBSj6SOHwegsF+1A1McsaYzirl3lg25y
         qviPk6pZJ1iGumfzCaWqny77tM9y26GYbw+A8XjfC6VDeT/+Xx03RRnlQEEiZO3FZBQG
         gb32fRk++KpdYHOCC2Bb4GGrYTz7h/hrWU5snBUsyRNi77KlMUFfGtm/Aj6PL1ahn+lB
         fuyv40Ktjpc5Uw/9VFuRXWHEaJMs5dnLuT9zN4Cl38ru9ZX72NfNxGJOLkA4czPkjpeH
         +epA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771978205; x=1772583005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dTN9nDYyDw1VitSAoVU8XmQ2K7N+PmzLt6G2wl3/Yas=;
        b=PrTqpfT75AHPwRSdG7x9PRtI8hk9k97vR6xCzR/Ua7XlUy6TuL3sXW6YnsnGUfESmk
         nD1mqXBN5j2V3IKwE7zz+2wKDGgl9xul+CAEasXnWGmSZJ+Q3AC+iUjAzs0T39sLy67L
         Dv051VVrNCd5Pw1eSC+FWxUYuR85BTjXM4kr7LUFaRSe7X/OcR66J87/U3uK69fG7M3u
         z5gnbkvfPjMYerYiWkd7YENqCGIYqLghMKsB4zfpg7cicBRWkIDSYkOj9WeTK2tDTj/n
         i+8xihkoIY9ks7V//DaMsfXAM6UmpWcifWZqCoeD5LP5BNZA8NPhduGYPLMCcz2YtEj3
         oP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWj48Sr3o0HZnL0DZtOpCwlZ8mCzyCdlaI3AUZQ4tGabILNpBXEsshQJGVlARkAwhSoiy6P8R2uDw==@kvack.org
X-Gm-Message-State: AOJu0YxMMTtKljIOQDyngTVPMA48OTKXgJn9m69lO+X188RKDIwCW1bB
	AYTdkrnmJLkuD2MQU+ee6Ke+AEN68o00zafEFBK67dATjUW322ZzumDY
X-Gm-Gg: ATEYQzxXPEB+AoJ/sfOFn70a/yDlDbWJTodONkzQ+pHujqPwG1qX6A6zAmmAV6zRSHH
	JA//pgO//mIOiqx26ryqm4k1vLKhWENfzOtK/NCfVHHXpveCg3DNf+r2QlQ02vNJFYm7BhIGbVj
	xk6vIq/2S/NAyo7r8sx9oWzpuUABpRsMmIdnL3X763gHRecizr6Pj4hCJKB6RlbJ26RIMvY7WIe
	kl65oQkvBk1nuzh8agf4xkAsVnXd813DbVSKRQguISr8cI2oTJV/jfaN1Np1sdIPUMelVUEY7au
	Zw24WEYYPEcogZyBMcWUAN6uemaGZ2X3jSaQ+kiLS5TI963TfjOEj2dZXMPkCBsNS+3Xlf5LMVy
	9M8CDODjUeqzamd1n1zo6FG74y5Mbv9veGS/LM/yb8V9ISoSCLfV0C36OqAOX4VIlVy6Zbk1D7z
	VJwSsBTQ/kTDHqm8dTmgA=
X-Received: by 2002:a05:600c:37cc:b0:483:54cc:cd89 with SMTP id 5b1f17b1804b1-483a95bec82mr255382725e9.9.1771978204745;
        Tue, 24 Feb 2026 16:10:04 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483bd72bd66sm28594105e9.11.2026.02.24.16.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 16:10:04 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: cgroups@vger.kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
Date: Wed, 25 Feb 2026 03:09:17 +0300
Message-ID: <20260225000952.2778156-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yye8yt55uhtq19fphfm1dpy9pfnd8kxj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B23C9140007
X-HE-Tag: 1771978206-583620
X-HE-Meta: U2FsdGVkX1+GOleF/ffm6loXMRy8dfrncqLE2piP4tG+WKpB7r3B4CKDhovkO85rhpuaCVPnekWpd6Z7dq04mMk479H5CDz95dytHtSkCbJgWTtiIGuCrrGrD+IozSBjEkpdiaD9TZvafJOXOLGaRejrbYpZLB1MhAdEHxvwZu35YfknE5xAz1xQ8yc3ti6Yp83CWXBaPdXkuJabUp3Mjw+MMZHKOy43KOkFNcG/HYX1oePUwEGg2HDDbnyLBDGOmp4SM9YNtlhsruYZo8cFqzgBn8lXgdBwbQsXXoKeQV8KsHbhQ5D0zTtQfeSSrw0ATy0Eo03ytcHGSYtolT+eoldYoVbT8GpBRXj4gfR4n1p/PYBhpJe4pyIXwv+FTiK9xuJjUuuflockDYXEyp/8JEIIchUvQYLdjlNK2D7SphqJrG/jB32vGtSLRKdbemSor4UPvYVqbbQbhRDrnT7wU9DIezjYnbC2+J50aN5as+bhByodCVBcA27YsEp1LQ0fEnnE5osUdJFeR9wJeJ9Jx7EVQpzB9X7qR4KcRWDBwoaWagogdDoOCo3+H0QckQR1qX4sVHyVvBWhSzV3A+xgld01+HZcdr+UeNsuGtPgjBwzxRgN3iWGlN/ImQ6n2QmO7FONXbMCclPCDhSCYhcRkbrx5RDBv42RB/+jCGIba6U4SdSNxkQKMdZYOYN5IUOx2oQPaQ2x24UymW8Qi6fx2cAjJzWKJrKvsSQwlqJoptmv9EvFe9K8qh2+aVwLS2l/bkarCTcJ7uBDktus0C7fqoBUBbXFwb/hBH2P2XB68ldfZNlLK4cSeXY52XP/S1M2BpkIpcCwCSGOM3auMs7cK2hYCYymmNGHXlLHJuEP5Ot5Bq//io0GEkxIwGWwfgSTRsXsxCEdssuj8z9G4CZevGas3ZGMHPYNhqR6K3EuoyymDBfh8FbICdiyWHcsYxa9g59YMp46uDcLiZxBS8Q
 XS0F5oUL
 ilpVmFZnlRpvno/gf0oLF2wUSOGWTdm/PwoTiXEjTHMi9FkwVmsCnm5urvC/C97/ykIHohBx+RUvtlAulRklcotmW7XYHAgBrWM0XAX1X9pHW0T3alIpH2WsylGynO7MO1CmEQs6AnwD65QgCRBZdemrzFLlPmPXShhZGYpPaWbHIVlUyHZPIFCMdyh71Si6QoLm/lbaAZF1drkOX7UfOn+XpnvhkWSWdnymIpvEdO86+hiHt5uBgQWbB9q9P7WRwVlFTQNjZG5WInFJE88HhmmSLwlu5OKstIpFKTLP31VB/vZUN4UHmxein69q2+lNSuuiLWmUvYIqUQitVbkJ2UT0BJqNhecl2tj2WIuDX5O931Nlvcz6xt4VQrkJPk9yCw0+jSWBVNrbdjUkiRA+Wz+mqGzGOHDhe/Kp87z4KlADVcofLPIDG7qmMc93pDAGfMW+O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nhat Pham <nphamcs@gmail.com>:
> only tackles that same problem, but also achieve the dyamicization of

I think there is a typo in "dyamicization"

-- 
Askar Safin

