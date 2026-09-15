Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0560FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D1F6B008C; Tue, 15 Sep 2026 17:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EC16B0093; Tue, 15 Sep 2026 17:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D1A6B0095; Tue, 15 Sep 2026 17:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 839636B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:31:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBE37A5AB0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:31:08 +0000 (UTC)
X-FDA: 85217292216.05.57EC0F6
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D7F520003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:31:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BwK/gVp+";
	spf=pass (imf31.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789507867;
	b=WS7XrquirpAg9nXA+U2TH2xlH/YR62j2GHuW0BK40bNRFCsjkX0n9xQQQrNhK5ubqewXCb
	u9ePGwZYO8BaKSyPyn98fbf3RgPOBifi3KwE8UkxxB3CQCrFRmvkuPy4N5L8ul/8tCytsX
	lv419MHBGskJbJH5txuOJA6qow3CYV0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BwK/gVp+";
	spf=pass (imf31.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789507867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f43s6nsHY5Ivj1yPDbhwSaNlMFWcD03sTjXZTf3Cl8Q=;
	b=lT7tplSmFdMK5Q2RbuN2AgBz/1u9QrTzPuhxiriNRMcuWFU8TFWe+lui79XDZClAZGfXir
	kMQ3na1WpNz1m70Zw4tc8L5XpR7ZTOlSfTfbv/78iEwvFDTs5wK3PuRWWOfddxezKq3tU7
	xlVfRwAiw27xiAxQFFPcOci/PlZR14Q=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843172bff4so96823f8f.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789507865; x=1790112665; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f43s6nsHY5Ivj1yPDbhwSaNlMFWcD03sTjXZTf3Cl8Q=;
        b=BwK/gVp+UDkfxKcWpUHzi6v2tTCoK0sFOfLsms6jJftR4/D/JuoVJJhVynYxno9PLS
         NXB0Dek3TDBujCdwqDYFte9xAxPewGdgyE+Utx2exodOF8Z+9zBQBrR8ZnQmFMIK6UH0
         FHdDCDOxloMFSSACv/4f5wHk2UzrLn19hLN3hHPjk/SenG6Ayl5wkvBVQte9GOGguo/m
         Qco5o1EYVFOJL5YfyVCdRJq0rYNB+tvTbgQdtoxlMQ/Sh0fMVyps5jWjJPOuL8KOaulu
         xp3nqOprk+7+zhm+EDW6zusK/8AhLNu0Q1BUwpa3QjIFNX/raX+UQopHzsI9Nz/V360+
         y66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789507865; x=1790112665;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f43s6nsHY5Ivj1yPDbhwSaNlMFWcD03sTjXZTf3Cl8Q=;
        b=gC3VkU96nzdyymkfmdfeHUUtEQUa2ZUpV+RSHUwSsbjye8mQMBS0vSM4V/fBSPbrjc
         dEKE0oUeQZBW+aYwUx4FLmBn7zmaic86sbCmwDSiv9e4t2XeUjoFFmjm9Vc54vvKP5L8
         bSDKlO6TNY8bnP6+GpzUrVQnI3MeYixCLLkhfiMOi0X+AFRcEwFinSlaS8ntBf2U6Af9
         uo9CmFp3aE76S7MCikrhBf4hYv+dKl5D2tPPUx6mKNEB3uDTVIb9HvSs4Q9x06N3DMuN
         dCyDhDZq9kSoDoIrxmJhesQc4n9voK5cihAOLRJ3o0nhwNspJt8qh0Cuu1aiaUmAVJS4
         NT+A==
X-Forwarded-Encrypted: i=1; AKwUvBzdwGylOvOaX9K0ciaCHmrWE/6rK1GJMvlWmQcnxespblR00FXGzVLYBKFCFQIEm1AbIXnT2krD9A==@kvack.org
X-Gm-Message-State: AFuF++nPzwtXcOrOwRKw0NtKgpSEUcN7z/UJDHJL8EK65rWXoKwFT38x
	b/R4LxP63fF/AX6vYmg/wkxn26CDy7afVLhtkiyBcZWuxocJhljcuLY4
X-Gm-Gg: AYBFou39Cc9Cpw/Reb5wfU22686UtwOcqgbL2WvXV3hTTKqMvhZKICsr/U71v5+fVaZ
	cJOTLmD26idgJNhHnhkRHXxqp5SzcWzXl4qN0U/IFUAT1Cb8qtESkjrdsu9n2n042b71vyxObOZ
	c/WoGDjZB+lcyVB/3sYbBdnjrKqpUniuNWOGNTkzKIxDTn6uRC+sAbPzmhFV8l9TMGzhA5aKqfu
	1FzJ4dETh6Lp2cAK6GOc0pnUMM6zJ4w2J6EYSo+/2JIfl6G15w+SMxu0YyE2A4I2NkLHRQHzvxn
	njCPK7oGFJWsVynkh4NtM76GQf1cgaEgpfGMr21FQkgiURcSgSKzbZ85fain+QWYm4JZ2ATaJE4
	PRC7T3xyi1x8AjVLCs1tnskJEcd7Q+TvMsdKsMpKmurlHAloNjP8C39owFagg3OEVQEIi2Aldi7
	4nDISx/PVhOhbTs/ZMAprFjHoqfs9UAuajxHFacgg2xuks4w50VAd6ZoRrQ0miJRmG+EQQ+HS1r
	HrXardiLGaGCzJhiGot9s+xBTRIC0YEFmQZfpVXyP03sPabkgZ+09+4x5SX8FaPXP7Zf46cZxCQ
	kC+1vEJVOLScfmCIiXFpJusCvgTnsnFWwnLsbnC6pxcc5cY63bw7YCL15EfgLh0Jr2LXEoL4
X-Received: by 2002:a05:6000:400c:b0:486:e9ab:2b86 with SMTP id ffacd0b85a97d-4870d0717damr254328f8f.39.1789507865223;
        Tue, 15 Sep 2026 14:31:05 -0700 (PDT)
Received: from MBP-von-Karl (dynamic-2a02-3100-afd5-c801-ec9e-1a2a-2fc8-3f88.310.pool.telefonica.de. [2a02:3100:afd5:c801:ec9e:1a2a:2fc8:3f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf43511sm1713554f8f.33.2026.09.15.14.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:31:04 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:31:02 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: test PSI goal rounds
 under the temporal tuner
Message-ID: <aqm4xSben7Aq1iNO@gmail.com>
References: <20260915060937.3423-1-kmehltretter@gmail.com>
 <20260915060937.3423-3-kmehltretter@gmail.com>
 <CAN_Opa9rS45S_MHbmf63KC0LY9AGAdAC5r=vv_qcYMVAenWosQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN_Opa9rS45S_MHbmf63KC0LY9AGAdAC5r=vv_qcYMVAenWosQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D7F520003
X-Rspam-User: 
X-Stat-Signature: 51owi1nufw4jpq6eok998jdxcnqg4iak
X-HE-Tag: 1789507866-562229
X-HE-Meta: U2FsdGVkX19oRynpAFOZ7B+fp21060ewVvEuxV9cjiddqZBtFSlxfefsp379iecx3qbWzAaVnvJMOQphwShorUe+Al8Mly6JltyVOxseVDrhETDbQbUpIRW0qH+8/hiDPsgzTPCQKUL+r9xO9xJjCSEMkRI6JbnNjWFSctu45/DmhSd4srKASUmgI9dPOGQknlJsEWXk0geM4F3dHTcHzoBTXW3YPbUEegfCOp1DJDzkQwQiM9TZdtQUM93BiCbMibJNdmo7EzbALJT50Wrh2Lv84yVT1DHjcnAblczTjdJZHZlxFS9q3H24xrGTPFR7NDLSyz0k+MkA5hw/3OU/Ah+3xKb3EI7APZA0m55zqRg35Tm2OQAnE4OHuey5ryiwHB/802rrNilzMbIqQmMa4SvK2JxqH++PJqo0IW0pNIWxcCpfprDJBLSEXocTWl5HmLzs+3bRxvvlXwF7NF3+behS/VUd7TDbfPZAscbOAyMPTgAs8t+I2ANWKch5K3E+ZLOtVTVJ11GXFuAV/djFykPBbxvxQAd4dziuxPkzhpqzCtMYniEZIG9pU8AgZGn+hqtZgiGK9j95TAdoq3Z1MUII3N41MVXUEwQ4Y76/AcmAgCy8Rfs/lGOJDTshakAFDKoLVR51QNVoovRFnVJeG31l1TTT+BzAg6ZY+HQ2QxLDA6I/OnEeQMju5qPQTcMXvemizLe4ZnMzczOlHsY/a6XNA9Lfn1WU3RSNFu9NkD6OmNPKfYnkKae4IWE6n6V5wAEDi/Mj0EseXgqsZsxySx+vWKu4nBuyP5n7ZXVQUuyC0MXtrWa9avK/IFVQLiuPK2LJPga4LDIvVkgAHQ5Js7Fqit2hJX+fJ8yg6bo7SJ3Dy74qKvVhaQxH9ttk92tCPWBmAkdUmgXqzvBlQepX0KY1Y+UzS2IsALAr6RpfU4hsvuCl/cTTrdNNZsWD2KmIT8kxvwkrj4Lr4L3Y+bn
 rjJIs07K
 Lx0QDqExpTR8UUJB2WWeKxDIVOgHniD+N3Rm9BEmyKi7uu3ziOlZ3RLrtKWoiHf2lyc4G9jx5AYY0HJJk1vSpOw4d4T35Zs8NB26qz3OwIy04MmJOSYiEgWpPH6zubEMkrK7hVx3YPMXws4/j0mcYZMF5yJ/EOof8fE3oYJ/KjUHf6y9R1yz0ZLFLviHZu+pKD0w0VM3/6FnXJ7CorUILn4rZgMlVpb7JtXb5R5qRjwdZ6BVeRCbLIId298slau0qr/S4ryLifY2OPgQWkoxToxE2ousVvsx/bdUtQSRwuQgfgSuww9rIHJ7e4dJaqjS3UvZFosieaShCZxIgN14mzgsxWhMPyjOEloP2mXc5iz7EsR66wBR531TciiZ/9KJiThHluu160u2tL4y0bsMKCdkXvm0l/gsNWZcAThyGhGYYifYsRsyq3WRQ/RxDhKiUlDouxTVVSroje1zFIjATRv62j2annFB9Z2DsUZOLKxjBhwtpnUIrU1kRjZdq8r5QVNx29QRrldmKLJw+5vDs9di9zX5lLQFTm+6fgi3U3ljOrEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 03:04:06PM +0100, KunWu Chan wrote:
> Could we also check goal->last_psi_total here?
> 
> The first tuning round should consume the U64_MAX sentinel
> and establish the measured state.
> 
> Testing this explicitly would lock in that state transition.
> 

Thanks for the review, good idea! The test only inferred the state
from the effective quota, a direct check of last_psi_total is clearer
and stricter.

It also fits the v2 fix. I plan to keep last_psi_total across a
commit of an existing PSI goal instead of touching the tuners, so
that value is what the test should assert.

For the v2 test I plan to check last_psi_total at each transition:
not U64_MAX after the first round, still the kept sample after a
commit of the same metric, U64_MAX again after a commit that changes
the metric and back. The quota checks stay to cover the tuners.

Karl

