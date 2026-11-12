Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828CF606A887
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GOCMKkiP
Received: by kanga.kvack.org (Postfix)
	id 95A4D6B00EF; Wed, 11 Nov 2026 20:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9336D6B05B0; Wed, 11 Nov 2026 20:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8480B6B05B1; Wed, 11 Nov 2026 20:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 611856B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:27:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB85B1C3C60
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:27:10 +0000 (UTC)
X-FDA: 85424728620.03.3FD1CFE
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id E733620005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:27:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GOCMKkiP;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794446829;
	b=mQM5k3N5gw1G7sLfLpXInD1nALbRxSvPZzbSiaWyE2NgErE8HU/ZMrF1jB4aC69pQ1Iu1v
	8gwO3IMQ3sHGYbIZ7qRpehj9ynXbf+GTjR4UlZFWM6CSrBpnn7IGDCRSzI3+ax5UeqAf83
	Q6ufXcX6brqyUofk1Vs4EWA9b/eujiE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GOCMKkiP;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794446829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pf+orCI2rLpYXGk3dzBIrPS1HgJeZ6wmt3S+jICR+IQ=;
	b=Jwt3pgVjQBnTLoNvldlSEnRaO1TcaZRH7KYgU29qEDecQhA7PQpm0RSlHXh3SJdtzVTckg
	DrhiBaJ/1ghb4PkKCkn2rXPhiY7zaW7aNowgM9NjoyHxeFAqfRpRcb8gk4L9EClantq1nu
	fK4TiX0EXHPWOJOdUyJ47xzhHNr5+90=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1b3a142c6cfso39554c88.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794446827; x=1795051627; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Pf+orCI2rLpYXGk3dzBIrPS1HgJeZ6wmt3S+jICR+IQ=;
        b=GOCMKkiPenVTxAhCLKqPZ87we+Kvtj4I9reFQ7FCOx+UhsA+d5uNmR4UJS3J7JG2j8
         Yx/B6OPZCEMbOR4ZZXOFmCmUPvJdL4z51TUq1ixo/vt23PHkb2Cj98sh6LQHC8Xz1AGX
         uj2MRtx71r+ON0/v2Z4CSpAIOBlVJkS8r8mraVxA2wniutGKuR1VFKJeBmKOhJ40TgTS
         KWgI76Oj4gUF76fBroVE356c/rqWi+pwj91pJhcwYDORE2OaEiyckNwDSdzXE6WCG99X
         fua7UAtFNt+yvTMJ8HFrB4s9fTSoELn7sDa0IqA/BkjPEBFptiBA+TJZo+msnX08NB48
         sy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794446827; x=1795051627;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pf+orCI2rLpYXGk3dzBIrPS1HgJeZ6wmt3S+jICR+IQ=;
        b=bWImG1NqFoywRi9epvW6kC3Wi9S24ZzvmtxOX/grvtDM9ZcYMsaYD0HW4ZqUqPTPJR
         ERQ15CboZfGKKnj5gPNC6Y9+ZHKsAoT/KP8Dcoa8+4f0sl+pTFuMAXHtMYGInUUCZBRN
         BOYVbbZ9FZPEUhD1EOPYMLeIoR/tyn/PG4qS26TEVPhnf9lKOsgWY8hKT2Nd2Ukkg5T/
         xqqJIPbrSb8jjvCV3Yavnafto8d2sKKt01HQJym3XUtc6eHbD9R5wrOWVLkRQiwwrr9/
         3hS8hbnDkfSE6xqdlesGVFj5xhh2HTpEP3scTsx7VIeEu4I5fhF3qGeUgVTzF46WXC42
         4kzw==
X-Forwarded-Encrypted: i=1; AL+hErHiuCoiVsLkT3ARpVf1DJB8HLY0PtH4yfLRd9SedjGL42p7tziFHj6SJAXBqqRIRhYTeeqAO/I6ag==@kvack.org
X-Gm-Message-State: APuU4Z+tqjgS9JI87h9hIKA+DTeKAv7IBsii302CL9f075gZobyoAUzA
	PFAJXqnvwTlQ65Qt85vKsS9UXtSNa1KdBpOnOaIKxy4FuWI00jflLxlY
X-Gm-Gg: AYBFou0OJFly7ThQYyoOKS4mcRR1xj2gA8zpFRe4Y0WY86S0yT8xThgN0QRWBf9ilOb
	vNdo66PgKIhMl4HkzP8agqUxL2DLzFet113YFMl5+yLf4uKBAlQHhBPA5zvZnqcGm+XiHWp09fT
	0IgWsD4BBnTY/jh8EsDFI4f6l4PydFj5Zm7iNrQ33XuXI+NZw35shgNvaP/DojjeEvSgz2A+nN3
	jbdn/6ZKylQLTgQVZM1wLi7ckPchF7JxPhi3ABiG1iU5rM8j8wQVkgdN829VHZwHZ/pcTph+oi8
	ecEHINQ1xCc+x+BEiUxIQOGyjieoJF/piBdPEP1uO3zc2cFQhb4mnoMEpAcweED4JDjApgHzUdl
	VwNdtMuyZAr21iMTOqD26+3CE4ODvFWpbpFtnzXu79UpxnR9DHE6XAqH9VgU0XYfbCqLcuH7dOp
	Xrh5R6oSD8T5qSy+GvtyflVlYXAfZXeK8A7C+JfglRNMll7LWh6oDmOPXGZT2QFTnKjnLC0ON/3
	co5nBqGlLX6Iu8NtW0xAfKRxpQzU8n+i0HTw0eTWno3QY1spGfwlulvVEUPjDR5xj5UtzSkpp+W
	al7XlAa+NxU5dCwItzMj+A1kDKDtTN+MzXsqosxNdsntLCfZi9IdTccdv1/CGn0dZnM=
X-Received: by 2002:a05:701b:42c7:20b0:1b2:5884:a039 with SMTP id a92af1059eb24-1b3c0151554mr6228487c88.0.1794446827180;
        Wed, 11 Nov 2026 17:27:07 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2ff3bsm24887181c88.11.2026.11.11.17.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 17:27:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Nhat Pham <nphamcs@gmail.com>
In-Reply-To: <a7b1d671-18b0-44e8-b112-ab66893b3bf4@infradead.org>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <a7b1d671-18b0-44e8-b112-ab66893b3bf4@infradead.org>
Date: Thu, 12 Nov 2026 09:26:55 +0800
Message-Id: <179444681565.2553194.6533752746321637708.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: cqs83tei6ctc8dnu5ee8p7u5g19jeeug
X-Rspamd-Queue-Id: E733620005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794446828-70601
X-HE-Meta: U2FsdGVkX18xSL1At9cI5b2/pR4RdaoaEvMXP/nlI3uXEkBjGglq/pYk2igQur7uFtZe7jyGnDaVe6iAgLbuw0bAdKX9g+0DglDcAXcAxzFRuS2z76bTzaSu16i9LzcS/Vmi9JVylobBCJZmF4C90XX9wFQCHw9/MlQFTWDckvlXNPjBc13RYadgCrn24/REJu1hQVOJMhfkhoN4nJS9Z8qLsOZs3y8V+diGKsHHCGeM+aXQP3CAi/kkhb7iJycrlQX29vG9gUQ/ayeoAO3SggE0TnA/AHIu8UHap7F+wB59SS9G8UsNvvuMvmHhK06m2aKyRjgqychwAszQ847/mpUqhLHxs4AJwG8wkOjS7UENNhZoXPDuXk7ER+QUzhwM4G471ogRQxICaZuVD1srYLgxnuqv6DZ0dOb+S1j9ESa++KB/xAQiDbGwohj1zjqDht6IgDQeNZF7DtTbknRvclf6DQCIBCEiNd6KAXLSco9WHeGwhBWSp6ujFXT7PsEfgaGOo72OyNr2eQdkGHo+8N001d/my5dFukq6RZ+gKMDocuWLq+LKueafnPvj3U/LR2alQB3oO5e0btlR5HGM7s9rGKQ3yjoWUB4qI8e/P6MYZbQDlrR7QUlyy8HwqIqA4LixDbbIuOmNC2bn7wdWo7C2ol+EbPo7mMp/ixV9iCSqQujHtiJoF5tr+wWCZOAPP6E3LPZwJLR6euwSpwS+e+nM6G7tOs39vY2y/shG9dnxs0SuTDu2JwMjV0czWJ46beNhDvCkdAyiuzLa5ehpF5+czRKBAHIEk5BUIwmEMLP4sdX0lsNPkWtqD2Pc1XU6qvetXRopXFwW1uYgycyXaLPOboZxjv1VXqG55gAqm4mfx2x1EwZ3qwlJh0NspVz0y0/MubiJJQLUifnaBKYQS+FfxQ7zAkqz5cS59quvbUWBbMdY1MgV5ztK6HJ3BtPIGy1drpudODcp0PHInPG
 BcWAPAZN
 lFLQ7kyRsKsuun7MWAx6asxVoZoNYSGyqOud/X0fdbiVJp7j0RILUL+KDs/Aw8NLutmPboPj6OyHKU2TcLlOPHT2hvlgxyaBxmJE/i06VeAnN5OLjbMvW/TNBzv/zlQIQlzjlEuPn5ig6OqrP37TPIWKGmNGjWCc699mQ1bVxU8QutRKkp/8C0zWV+I739iUU4PVMEKkD+vTOGwMEaS1VK6ygrqprOxbfJfAxKkAofixQ2g9gc8A0SWggdF4ut3/X+xnOzL+S3N++e+skcB84iUa9DYUd0CNYQlKuUPUm02b3X8LKhivgjALfoLp51Mc7UVWhLaMH5gCSR8aVb3q4wohgD+Q26ZN5PU292/3a0RGbjtQYKgi4oeNbeR33lXxIE2ly98koYa1SzpmgRh4QCvIUTQ/kjj81oEcxgHcfuXM1typdlqRZ61DT7zXaqhHy2yIEKOotiPkHy+prqlbvJonKJ8rY4cA/vTUUUvU11yMXNMoUoMi2MQtKy4CI0mTpXZW999kMO1kP1oKyQbiF7JEvqPVF9fo3UdA+vZxhzUBF5BymwJd8j+VN9+BGb/io382ynjkk9/4lUnU3uOCodGFtpcjYQAUWrQ0WkZjtTCyIp6kmbEXg+kY5riK9crDPPMn4CRlq9ux/Xya5SoopJRuNZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 16:26 -0800, Randy Dunlap wrote:
> 
> 
> On 11/11/26 4:41 AM, Xueyuan Chen wrote:
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> > 
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> > 
> > Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> > documentation to match, and clarify the pool name in the debugfs path.
> > 
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks!
> Thanks.
> 
> > ---
> > Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
> > option only controls the debugfs interface, while the class counters are
> > updated unconditionally. Removing it simplifies the code.
> > 
> > Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
> > the existing debugfs API stubs when CONFIG_DEBUG_FS=n.
> > ---
> > Changes in v3:
> > - Squash the three patches into one (Nhat, Sergey).
> > - Add Nhat's Reviewed-by.
> > - Update the documentation wording.
> > - Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com
> > 
> > Changes in v2:
> > - Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
> > - Update configuration files and documentation.
> > - Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
> > ---
> >  Documentation/mm/zsmalloc.rst                    |  4 +--
> >  Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
> >  arch/s390/configs/debug_defconfig                |  2 +-
> >  arch/s390/configs/defconfig                      |  2 +-
> >  drivers/gpu/drm/ci/arm.config                    |  2 +-
> >  drivers/gpu/drm/ci/arm64.config                  |  2 +-
> >  drivers/gpu/drm/ci/x86_64.config                 |  2 +-
> >  mm/Kconfig                                       |  9 -------
> >  mm/zsmalloc.c                                    | 33 ++----------------------
> >  9 files changed, 10 insertions(+), 48 deletions(-)
> 
> 
> -- 
> ~Randy
> 
> 



