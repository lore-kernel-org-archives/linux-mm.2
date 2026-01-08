Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB8FD14886
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89BD6B0088; Wed,  7 Jan 2026 20:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37946B0092; Wed,  7 Jan 2026 20:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A648D6B0093; Wed,  7 Jan 2026 20:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91B596B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:14:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49D0913B4EB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:14:33 +0000 (UTC)
X-FDA: 84307026426.17.610080B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 62630180003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:14:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SI1ZIv8U;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767834871; a=rsa-sha256;
	cv=none;
	b=ezl8R0eU8LsCUVGxdlJCzB3utxGSspEwrzisp3IxKNMSE0Q5KbJP2cG+jbTHoKclfGaTbv
	c+4ytDvxKAlyncy3abzpGNTC+JoTFaDvTGUkanMaSWjExCP9iee6L1FG0/HrL8kUNBvG23
	bTOJtiSU0CyK24RJoIZzOgsRvjOeYH0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SI1ZIv8U;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767834871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Qa5H3YqLWZz/L50NubALjjk+BG1b+DdKoYgOpQUnPY=;
	b=8bSWydAVKb8FxHBcNcZVtpV3V0+eCfcnwLuI+1NUBqsXDI6d7g4VU2krOgXmMe19/xyqZg
	QLhZTTnXRgXlNUKms3DKfw1JS62eMydsNxNpzyQoSV0fzPNpN8IcQHVI9iCmCx/HodAgrw
	V4anDeDU+8vlX5QR7Xm4lexWI7jazdc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0ac29fca1so21090395ad.2
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 17:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767834870; x=1768439670; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Qa5H3YqLWZz/L50NubALjjk+BG1b+DdKoYgOpQUnPY=;
        b=SI1ZIv8UJ9Bdicm/7/uM4lYlpZupUkrcg14XR7mbveYKARG2rFrEcYmHg9/fHd/cpg
         eVQcKOAi8Tua9w24aCd0kYe2HT4BcCejIhYj2DEuwuwYB0LYhuhv730jaToOLUvCP1HJ
         M98/M8iaKgQU8XI5MFyM2zl6q54un/TmFdYM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767834870; x=1768439670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Qa5H3YqLWZz/L50NubALjjk+BG1b+DdKoYgOpQUnPY=;
        b=kbDFiUg6xt1Ancjt2YwQXEpee1y0/y7os2pAoBgVaLLDxqFeGPpec8nccPicU7hzCE
         6pUJJUmiWsylWxiVxCsG8U9QAgl7GH73BRDhSeRCD1Of1oWeDLOI47pAi8Is0LvrGQOx
         5hkARY7AW3UgutOxHih0xaZKdErVw4yysC5/ShG5EnW+UpYddFGGXJ6Q8OnlLNLmhDD8
         S8YAPx20X7vNTeTVxvHvQA52v/UzE6JDQqnNITnE6xSUTGf3TzjBr/BlsIFjkm1MiI86
         lBzomxklXFA4XDbH1G8ieXP+/4Gxf+CydCRu5Sbx63lvTJ2uHnhuj4785LmlmFy1ckrw
         5HJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1+DQLTrBKYdzne+HDHuuQE1P838U29wWBAPLqDOreJDbW20AGeNCB11iLpG7rXHbGQcxF+OLqmQ==@kvack.org
X-Gm-Message-State: AOJu0Yym8HQ2RyDtpm6wbyCNUBpmq/m98SS0MLA4RVYb0XkudrO0s7OZ
	7kKhl+QJ2lAqv/NjsLWX0HqL7n/+gQoI7H1B7kM59IE1ZNQea5p6hutSUaPT0d5AZQ==
X-Gm-Gg: AY/fxX4TzV6EvHESKWc/a1QcU8XMDY7tERCuVkLpk3P6zrN5ig8USt4OpijzUw0KbJ+
	SDv7JzTKylhG2GVzfboYpSgX5DEit9LxHa3HtDcAG4wtUpMhPm5HdGLSbeCoedzMwV9ceto6KlT
	0kakejDElbcDjpG06WRDT7reAqW1Ksj3Km2UJypt5IhS7ttWldAviRHZ+FuANzPuqdgaDn84F4C
	0bGgjc1krUs7eViUbkMmifPOX32XGxvAUunjeyz8tqdYvfGFZ8eiTPZ6eWYLg+JepvxeT+MGIoC
	shwtPz3oPZ90eXlq1sQlL2EmHhJEfSIpB+hvU/641aunJJaz5ixJx2+IgkjJZZX2GNwsCSrsEBu
	KW3Dx1VP69GcLAj1v6ZOjVRhSg43az0uXfCzGC5oSQhcR2rA6SpX4LPvOqlUcDnEabAajvj4O4I
	OGwCm/9kHrNZ/M4F2PHwYtNHNcH2yKJt34EFYI3nAPMvgkTaP1plM=
X-Google-Smtp-Source: AGHT+IE1bMSpJX3dDjhml2fgLA+99h09J/MLfcj/Q7PcWlglaVsT76Srzn+b7bbnCIv/UodQXX3LOQ==
X-Received: by 2002:a17:902:c942:b0:2a0:9fc8:a98b with SMTP id d9443c01a7336-2a3ee4bfbcbmr37936235ad.40.1767834870156;
        Wed, 07 Jan 2026 17:14:30 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7bef:7c13:79b4:e9de])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c5ceeasm60358825ad.45.2026.01.07.17.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 17:14:29 -0800 (PST)
Date: Thu, 8 Jan 2026 10:14:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCHv2 2/2] zsmalloc: simplify read begin/end logic
Message-ID: <vean7s7lfhcdnbs72efar2lt4isklhz4kt337kdbx7k2r4qbzn@rf7acedppq3v>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
 <20260107052145.3586917-2-senozhatsky@chromium.org>
 <20260107101705.0469e87ffc60120120500e76@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107101705.0469e87ffc60120120500e76@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 62630180003
X-Rspamd-Server: rspam10
X-Stat-Signature: 4bqy88ftp8qfky7c7pxs9wawzyqmfg6n
X-HE-Tag: 1767834871-697417
X-HE-Meta: U2FsdGVkX1+1At02WzelX13PS5mnb2a9ZORe32qOrt7/cMmBsivbAL2lvBEOpcFqfZlO39Ka3uGqzpkAd16ywwItitdRAPs1Vvuqm1qNumQoR5Yb8Op6nMALsguTG0cV2R/0BqFeRhhfKFMP0IT2ZFHEmQWR+UVVG/idDy4tCkoI0s1sjZH0SwBcm8wNGfFXcb3vIGrag1AVxkS9AiWHoird34FUl76+VtvXSC72Hn85cgHfeVoevtprxNDeTaDH17Ug4aU9mlJCVGLgVLDdlxbliOMrEaN/cYVLpv/jF4cByST0E0Si8T0wLPxG/pylroO1cvSZKUFNqu9c3n8MQaDMQ/xGwsPdZPecWz9KAtawTNhU2kh8TjtEYkhqcTw8hm0bHWRSaNHVmIpId+e56msOoK+mWxfCfZhJ/zhFyi+9OIVczjoPV4J+iUJ2It7HbxRVHWs1Rc4z1xTFSGvlXC84cDu96zJeC/HtkDWoEkEz9YQSGNAkv8a2SafAp9wCk44lA4sYXVem7KNxKzHhv+Rl9w6iFwZXgFU18Evnb1nJwm8+Z+hc3a6oLJYzxjbwGQRsQnnP996bHDEMG7/1R7pIQ28Px0pKJTMmvTce/mVQNRuNASqBPFR3s8YK/M1Or7u0geWY5oq1H4gba2dzvLqFugz9fM3wJTxX7SBnPTZbm7M5CO8lDJ5XFZBs2jk32WwJDi8GNkpkYn4diTQuoVaiUT46xkxRnbvbADwU4O2LP/W4+37epOu27qBv03mZl5aRpZnTjbVSQgNsCaxYoxjh4/FHfjhwybzvS6w+I+LBdOBPA771IdMuqUw5OsFdL3l6JnQ+s/IAX/7XN62hddu/tHusRCuAbNO2yc93R2GXwF8bbp3YO8VqvbTVIeqFHenbi82kYaOD5rrtXItS9wR8WtLA0OIxJXW3m9J3ZPX1YTfc2YBPfidhcleKn7+09jDCmcVVsSNsT83i/wO
 tP5HHtNb
 dALcFKCDYUGx4DVEu3g9mQ/6LOAGmsRLxn59VNl6/S1hQc5StL8BO0ya0LJOWAqWZwSQAlSlxsPQEQwqqsB814CO2YenayC4/1lBw6W+1129y6m0wUX/hvWHzGu0Mx1h9zcToGczszavKvxZMIvjyS67eoiW3l++FE92kGvYOtnP1wV31fH3H+qR/1tFltyzO9VDKN+vuSQ/p9flMOQrmxFxzXEHHGRY5IMuYAE57nAnB3D/LBc7MyhpTmABF2WCgjVmKoSVdyUr3W0Qi+12ginEr4YS4m9kZI4HCOj/Bzykf75sHP2gob9+fdBStY0g3Y71pQeDVEMQPgPVt/I/WDdpOGHguMZnoCglWgymXbtA5ncY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 10:17), Andrew Morton wrote:
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > 
> > When we switched from using class->size (for spans detection)
> > to actual compressed object size, we had to compensate for
> > the fact that class->size implicitly took inlined handle
> > into consideration.  In fact, instead of adjusting the size
> > of compressed object (adding handle offset for non-huge size
> > classes), we can move some lines around and simplify the
> > code: there are already paths in read_begin/end that compensate
> > for inlined object handle offset.
> 
> Updated, thanks.
> 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> 
> This patch should have had your Signed-off-by: also, as you were on the
> delivery path.  I have made that change to the mm.gt copy.

Thanks!

