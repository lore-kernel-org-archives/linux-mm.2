Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439E2CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542A56B0088; Fri, 29 May 2026 10:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3916B0092; Fri, 29 May 2026 10:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2566B0095; Fri, 29 May 2026 10:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289AA6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:41:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC01F160B08
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:41:18 +0000 (UTC)
X-FDA: 84820720236.22.E57388F
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA29120004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:41:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZK7aznu;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifCetNsGhGXROpWXdUZu9k5jgo1IT0uJlL0ioftjkf0=;
	b=e4tnyzPuu2dBMJeLG0k2PbT+J46/orqRDDDksk41aTYFoDa54LAWKCBol/1QPjw+XPBsco
	SUPei+EnkAzE7rc4kS9ucin4NutCacsULlCTVvhzZCudb57wimCMlHLoxk8DhdieKSqMsj
	Rw24wjJwIMwahRwA7f0+0nLqFHf5cbQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MZK7aznu;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065676; a=rsa-sha256;
	cv=none;
	b=EcpWRxqVgDrsJlJTLeCEgEwnAb9JgJR9dnLnPVofDpw1tGv7DA+Eye9sdr8eAMFLk//V4S
	uaJ0E0HSO005SBGEs4qfUexhw0f9NFzUJax2UrkC69CkIGCacxy3/c0M6Fu36v8Dh4khKr
	tOV01sqYWsgDGpOQUJt2rqF97VIJWMw=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8354461da74so6556379b3a.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780065675; x=1780670475; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifCetNsGhGXROpWXdUZu9k5jgo1IT0uJlL0ioftjkf0=;
        b=MZK7aznu7Mvj4LEvNk0Iz8REEK4E3UP4X4lAlLIcMAohzTP7iyIbz0gNNgnemevtvt
         EuHWvU1a6Ti0D1/gekmxtaN69AkWv7YZrbw1+1PfZ8Mr1a776R3kUA5lNkunLrD/TPMo
         Q0JjElF9jby5RFcPVNM+rBXccrOvr2+qkaoKBHNGwZbQOukBWva/2qWtIjIKjIdokvBz
         PtiFRAcnPXbQTa9nFi7RMJQI2jB1dM0zX0Sn/PU1GfvjSPyl0GpBvQiNP4NazW0Rsil7
         Af1pLW/OixuD4EUv0FdOayhShgrJBt38YflGlFk45rSAQOwsGdKUYBcdavvksYPs+YEn
         +UDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780065675; x=1780670475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ifCetNsGhGXROpWXdUZu9k5jgo1IT0uJlL0ioftjkf0=;
        b=X34SuBEnHJcF/MQUJ9fzQACBb33VesY077f8YlvBsg+0orupfniATLKf2tUrhUDA2w
         CcjJo+kekYJGbtVFzP0QpKv/S6n93rVWli2+MvZSwjzDfchmrwN4RpsnZ7NHb8GzsYKm
         FtKt0FDHOzasyjpM+OQImzEiFIsukZD/r2la1u8pJw7yu9V6r2VtTYv+F75DJrdICWlL
         DevFi8EGFe+jklBpWrSG3YvpOVLuhUETamNM2W3mvX1+42f+4QW+BDksIpEU2/8KPwr+
         BKZ1w6ygIvUHGp6/UMR4Qgbe+LU68wl15hKDZo0P0FEAXs0xwx4WS/a0Ia8bSQS1mo0N
         7KOA==
X-Forwarded-Encrypted: i=1; AFNElJ83ApUkBdrI+IEQqSsfXGd6rwcpTEt+/v6lTeHUNcxzf9Uqkgtg3RSUN83WCRzqaxLPsfeUY6f23Q==@kvack.org
X-Gm-Message-State: AOJu0YxMw61z1SSwv+6M5hHoIetmOVjoMPsp1HMMkkyUF1DOeVlf7QmX
	kgrj53+NADes9wBoYbvnt1JdnOd2UeyzR6/BW07soGgXcnBsT3AOJMwH
X-Gm-Gg: Acq92OFrmDXQYa/gCf+KnB7Myj2FEoRzgDqWS/oA5dfTzfDK6O6kzjVrPdrD+LyzNEt
	5RMaKJYXsHDT6laWoGQwkZzrnfB7J6lGVD+dDy6h5uZOGfUs0siQlER3K9rlCyuPhIJunyv0vGK
	Ho4nqwcLW6nrIZhk7PK16lkgXxN4SGbaAeLYIRy3FiQmz6A3AWC0IxutZi8Wvg5HVBizEZHPNmz
	l4jBIMR2Y9vJJOII5QzTye95GnO/V4EdarMXGhBT8795rq5Yb0yZDjm4r9xU3WEqCYdkosQdlHn
	LEQMzK+hUUDNjKt6sm/ymkLiYpawDOOlVa1OzSX/ROzI1nSm5YdLamp+cIFJEqX8zD4gStrnEA9
	m3kV+phNYOcdgV7jpbeX5Z/5QadE9/tgKEtQTUpU3e8+1qqMhVV2MsvJJPUFKPbOfUbt2S6D6iy
	yOtUOySxFMp3bhxVXmLG6uvb3nJl3pM2Rif/e7XeM8erL32O6MysoOD0cqWNB8Fm0lbL8tMbjgB
	UzC
X-Received: by 2002:a05:6a00:94d1:b0:841:edbf:6424 with SMTP id d2e1a72fcca58-84212c03459mr3360610b3a.13.1780065675248;
        Fri, 29 May 2026 07:41:15 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214b67a11sm1946082b3a.27.2026.05.29.07.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 07:41:14 -0700 (PDT)
Date: Fri, 29 May 2026 07:41:12 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
	leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
	shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
	vbabka@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <ahmliNJiR-R9N4M3@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
 <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
 <ahidV_iSq3E-FtMI@skinsburskii>
 <20260528131115.184c178d03d516e11248a1ae@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528131115.184c178d03d516e11248a1ae@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA29120004
X-Stat-Signature: 1o3yc5h6mc68dc8afbpmgx1t13esugkj
X-HE-Tag: 1780065676-76938
X-HE-Meta: U2FsdGVkX18lT7uIMtyJWp6Nj57A3N0rKuFPksJINZBKgMrehLAFKYu1LY+NzSF9a8gqLb0wJsb95p14rXiZsoRK1EcynPrm5XhWaGnfgCEZ5slH2+t42XeIslX49pxepLgsIdcKRHlMt/GA15SSd1mqn7yK7CKTgYS9Hf8TnXN3hO2w8Y7wVApr9hBRXKALtK2Uf63YpLdomki38GhB89p3GQjrbqTervXJ1OvfVKw1RBCs4bav7i02JWVEDVXGTOr/V/Od7+sxjOlGn9KHPgTJ9j2V8Bil5pm2VQsq8jpGQLKeV76gZEzftAQaR4tCIg24ZEnO/MHPOGLDZwNKA9HqR/8Dz4827CCGTyYfhqoGSiaVfJy83JqwLRDZ6bo3lWYk/WkCVebAFl7B2LS07Go1ugAi8d4wrcyboKZYd42Phwfv6Q+rV7qRkd+JhMFeW27iLMsTJsWk2l0bnP6ppr5TZp51PFxY5uznZ17f+nUhlmmFPS9X7H4Ftpfmda9qDWs2cOaV0KIZgFERFDVpBR1Y25easJhAYyOIOG2neL7thnMXgzmjamp4yilDHMN4K+iNUft+eT/E99LqeIgIFUnsd1Otq3uroPMFX/VoTF5/kOIP3JNlRuJlHEvVPOtnEkPNOFhptjo9C26ZwGHWZKF7XHsv6j0YcvmQF6zSSktlOrsW8tx8/sSi1dSfg1sfaJexQW55qxBd3xBRdrGSW21wwDcUlQhUdKTrC+JsOl/Pn89DDgA4ktdD918aV9ElCk5bCPdaOX/KcsmG96Kysc95tHOfh9qiloOCSAb0pXIp5bPEHZJvaOPBEi7exMBUQm4cKNTlYE0Yh2yGeFA6EEN2zrTMmM1Lm42B10CSfO3oG4gVaevoPKmHUJxid3ici7QZQvzJCzRnYuiIdg0pwdGi7xwtKHXNaSoWq2mtzDpdQ2Kw2H0pTAlP9vywY00ScGjzYvRDTBN49ikcERq
 Z5cCa18r
 iuyjWMatcHH6EsznSIVSKZdcn04aZ1z+xtPxsvt7Jy7amXJmIepLjJ1eijCvyqeVKmVGlJQRGFfxqH4+ucfmHsfZVFD7jjLpIjZoJMon7+LG1FwCH7dJNoqnWoG1MHoPD3MTFzy2t01UhYz6eKjx7slz2s3HhrdUNwOvhrzO8z94EUf4UAXrWpdJsIaX1odNQ1X9oAvUMwlymRAiZz93yiSsSEjy3nCIXgcVzzL/mXCLp0Xb+CcZYl5Y8nXvGVyvoZsflsksWX4N0hR62tKzNmoTJRdi2rjSWZOTUyKn0VEUYErQ3GQMAmAFeVmSgJd1/DRb/UUogV/GAxPUROg2948LVf42Nx1ybVaDOi0JHJC5uVhJU8sygWkmk11ARKmBZY/uRem5TA71I05B/BahMU7C+uFYhzAllY+cmB/3YPSVh5EnmLxb6v6s6cgXaJWcdLj15wTs6bQf7ngUPviDnzSi6hv7MdcDfHDZW08IvE/pU6/rZlENj/4lc21GopflXKoUp5UGn+bMvh1mvrcNk5jheCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 01:11:15PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2026 12:53:59 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > A gentle reminder as requested: do you think this change could be taken into
> > the mm tree?
> > It's beneficial not only for the MSHV driver, but can be used for
> > post-copy live migration of GPU states in future.
> 
> Still no review, alas.  It's not a trivial thing, affecting both hmm
> and userfaultfd.  And we're closing in on -rc6.
> 
> I'd prefer that we revisit in the next cycle, please.  Refresh retest
> and resend after -rc1?
> 

Sure, will do.

Thanks,
Stanislav

