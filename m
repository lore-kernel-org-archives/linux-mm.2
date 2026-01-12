Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4B1C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154C96B0088; Mon, 12 Jan 2026 09:21:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103096B0089; Mon, 12 Jan 2026 09:21:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19A16B008A; Mon, 12 Jan 2026 09:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCFF06B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:21:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 703C31602C4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:21:23 +0000 (UTC)
X-FDA: 84323524446.02.FD39F36
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C0F7C0014
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:21:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XHG8FOxL;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768227681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u70BhNwJ4UADpInQUk67N2/5xRXcFkwdnBCb21aVvI=;
	b=V1EugW6DQpwciPJmZZrFA2soA4fNXkEgQQodgZnCAm31agH0/8e0YMiZrYrNQalDDfchPd
	DRaB/ALFlFDLdsoAoGioQkVO6lY4xbX00mcOERTxBbTV3GsL0gWd4S6lCX7VfoyNzcV1M/
	t/MvOG/RiKXYXxIwfQQF1lVJfOGbSBg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XHG8FOxL;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768227681; a=rsa-sha256;
	cv=none;
	b=SccjT7PTCEfc8fWJmOK+N4kfXNzE7ZC7ba+zT2eTky3IlOcLfjcPKea8RjLxgJrIKY2/NN
	DgnkU7CUDrgdz6rUJDuBszuwaY0/8uZY3UGp1Dd7AdUcBsfrH2ffJA9G6RvbLHZDFzRXA+
	T1BeRvM8HEJ30APF2ZFGmoCiD/dgnmY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477770019e4so48846875e9.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768227680; x=1768832480; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0u70BhNwJ4UADpInQUk67N2/5xRXcFkwdnBCb21aVvI=;
        b=XHG8FOxL2JzNUuzZQSU6+IJ/ui8EkEmtD1McYk1yxQgUF3tTjogU1sf6njLxCIfQEh
         ZWJgxf2FCgLxZRNaLSx9i3FGi03XZUf3ltHhW+UccovssC1tSAxdkcrpbWEQu+niRsod
         OKoPAnmfJYDlCT3NIHAjFMcC5KtOfVO1Lc0QQqn5/bc1Tei4YVHEPp9luaEDYntlxrmz
         YYWaPWA07b3MYF/zeVsVhCmInSz6m1+MEfuKDw2rM41JyjhSSNidCckiFtk0Dl1IAtLo
         NC5ozNFTmgGqx/NPPeVsNH7wX9jL7RWpUf65Y0mA9Ql9SrR2Gln2xTyIqtGvDyakgXAo
         BfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768227680; x=1768832480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0u70BhNwJ4UADpInQUk67N2/5xRXcFkwdnBCb21aVvI=;
        b=Z0UL82eZXoWzlOXR6L5S8rhmDrnEV+qwfGPZAkRGND4DjqZgp+lFLNPkenhgxE8OYl
         Uui1qo+D4KQF0QjW2Va74BTzOO3wGDDJwyHY+NVfp1h9fEtKkVWQ2tqPNjZQWIaRDI6z
         w6wpv4LA8c4qYotZD95mW7DMQ3YkaT1u/+K1h3a6lsETxDcqbAEEg4mBWuo/gXmTjogg
         TuHhNr65Ch7w4aV6nEp9euPMjJgBTw+iJ9xgOdTFAjkB0L3yU9Jw/ItVFhGpIizRpHbv
         ylF4/UOgrboMzpmtlqdK82XDvvSjk3NFG6Gth28Kb7Wzz/UwQbxG5DO6WQs4osSLPJ7z
         aY7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZhp9Vngc7a9aDQmX/BTeuiT3D5II+5fvRKUQ9b5PqoHje84cxrAFvRCoe4Xh81djbJOgCqohl2Q==@kvack.org
X-Gm-Message-State: AOJu0YwYxyed4w/Nr65yNHpL4ttQ5Sx1PWO5scLw8gjaPaQPZhg9MfXN
	Us2Zkd3jmdEDc0vAHeaMr8RWaxTEklK7iFcOzE37lVC9CeJ7oKFFGFLuAmbH2HEgI1M=
X-Gm-Gg: AY/fxX4Z/5Arm8p0Wurg2/kdxf7/UwmrDPaAkBk9cm6fUUQ3lA7BWYgu8Zg18G3KS67
	m8XptpHCpWbd8jqEgnvfhR9XxJSNaFuKBHLhgY0vDdqP9tNtHQvvOhmXnIsUNgVeCjnn67GJ4q3
	kQycfzvyhtjIHZh+Jpk8fGjWpsCuMMPDD/ZMoBDwpXwGhD4H3SFnoGng+eiuq5tJdN2KcmSFLDB
	OoErR/f0677rxaCAHwPijKMu4Cki/CAq5npUvnCVndTWJmaa9nUDxex/gwQM8AAWY+sg0ocXjQz
	g2JKGEXmbLJZtezvybGiQ8UIr+Lvqn9ZWpHqQKTo4MqnXgzENnyiuof61Yq+NoCMFycqsjPJuaf
	C7o1wrElINK8TvU63Nd4z3/X6saqMnanR8ZbkqFzAtJZKbe4+2Vs+6LyqdrrcfV/fWkzm2OerR7
	f2Kuz2m5lA8AOpog6+YMI0RE+I
X-Google-Smtp-Source: AGHT+IGIVOzY/cGAUFVZ2fQ9qezTazmo1GKR7XGdOwz+0gwuiBBZTolmYl/t4yWNr8wQgBMrbFb62g==
X-Received: by 2002:a05:600c:4e86:b0:477:9574:d641 with SMTP id 5b1f17b1804b1-47d84b3281fmr206518015e9.22.1768227679644;
        Mon, 12 Jan 2026 06:21:19 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e180csm38011941f8f.10.2026.01.12.06.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:21:19 -0800 (PST)
Date: Mon, 12 Jan 2026 15:21:18 +0100
From: Michal Hocko <mhocko@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <aWUDXtsdnk0gFueK@tiehlicka>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: fehgwybex6od73egzzw6oxfnzm57ji3h
X-Rspamd-Queue-Id: 4C0F7C0014
X-Rspamd-Server: rspam04
X-HE-Tag: 1768227681-597044
X-HE-Meta: U2FsdGVkX1+eTcLYBIU1T3UGMU0Zm4KQWTLcHdWzmJhHjfgRSGKKmszlkjr9LmWVtcDDDp4dIveIt1yWwda3fypE2uCVnVmJ+rktSL94twO2TcndzgsV1R3Nhm0G8YN6dTVsN6FaRL/Un2Fe2+idICip40SM56G0R4x3b+nyb6wLWSLBAUwFQsUu82Nth+SglwaFk/u5q0b+mIqzdFLBIP4EMFVDZwhmRxV0d2yuz63iiG10xD5Y8UWv28/ib2mpU0g2IZNnHJ9gMTk8d7Eu8Q8bdL7fP60QwJCGGYluEFA7amMoUysTYP4BdERFT9LXRYCoxroYdBGPbqIUOzl8IO7jcLVosx0YDYT0Pc1tRU3M5api9MYUcVyBZrB3ZOrMKOAu4qfVpV3MfcH2nx+NXqcUrqdQrEgBWBJ4iNKaY949/XVUhtlEWAGfIJI2CvIh9VbfLZ4cnflnoOY/KSPZhw3vRaCwrmAvMU8yLwBWqBTOhyfpn24geay5tp4MbSWENmh+zRbLuEJIkiY0ZjKuXSeIgrFZ7J6fVPaSQ1AUtdaXc/KvrztnbtX+sTgfdGA2p05BR5IiUnoNbgMZSsoL0epZ1ufKLafgqVt2VMeMCnXspQ0IW98vXsnX6iFc4TYnUYloFdXb387fLWliZ4+Mt4LIYUy+L63foD+EzkbjsGplF4Cah5Bmkpw9xg49vIlqYoc2PMtajLkQq8f3sY+Cc/luCNwhDi9CMieEEyBmiUSoGcNoAheyKi3eWd0yoJVuKYdzdCzJQ1R7ddMuF8Ha9LwcNGOdbNwEpnJtlyTRoPcSiUzhRJaEA75S/juoemGYVsCJrmq4n8pF16LVobPqhigzswi/ychrCSKB33RjzQQk9jHZU4Kwve5zdVUZ8EyJoKWuYX/cqdkq+yKamJ589yw9ckgwQxD8KmYLTt9kCVcwtPuDrINTtDn0O3xlSkqYqP448ytOqDXpcA6p4Bg
 Rbtidtcn
 xkIAjq9QNYMJPly7QScxtULHYaECUk4eMvyznJAL/vrryYnQXuO0lZU/DQuY/3L3j48u+/DBY5km+YV5wn0w+2WgkGjKW1V2/IWvvVZHVI2Zy2a4zKLVAmDC4lHpmalBLSdCeGmahBtNfh0nU68o3EM/lwquWkQJwDO3R7dpcnPvW7t736Sm4k4c3sYvIhi1Mb42E/M+a+jZ2eTROiTEClGgKN1Vn7bCkD9IQJcujzc6B+USTfb8ljFP+CQZdzRExWvtTN92FIOVoUP5eZvI93+0RHxKbl82UU9Ytq3I1crmmoZgULCMiE8yhcT2AhPiQ3pu8Nb3ggseHRyEB2LGROKiO7fvmTWBWcX7um+aPJYqAhIVfIff3qkKx+0wzBPsrWUQTuGD92vQWksZVyQH9n0IqGGxqAuUntKG8Nw+rx4kqUhFg0KkC3/hAR4o0+meazNjh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I can see that Johannes, Shakeel and others have done a review and also
suggested some minor improvements/modifications. Are you planning to
consolidate those and repost anytime soon?

Thanks
-- 
Michal Hocko
SUSE Labs

