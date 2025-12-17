Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6E0D65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F66A6B0005; Wed, 17 Dec 2025 17:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE096B0089; Wed, 17 Dec 2025 17:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9F46B008A; Wed, 17 Dec 2025 17:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD0F6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:33:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADACB140C04
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:33:15 +0000 (UTC)
X-FDA: 84230415150.07.A533DEA
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B2C3180013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:33:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q4GlKYBL;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010793; a=rsa-sha256;
	cv=none;
	b=a11F3eQCSGY/E67IVFjG8W2L3n/l4wia3umfN6iwZgvEM6ik9xh/p2j0dvIHi9inpVaVXv
	dKxz7lWQqQ3ndy8zvkgunR9HQW1J/PvgGgbclejZcLD++n2oYgxwKXrMk4GIDw48J0TnEl
	wDWV0OB7VKxUB2F/LBAaIqBbKaC9zXY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q4GlKYBL;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/0fSU7byX7H74M3pGZ6ch52/NJ8dJexMYfTnz06pjc=;
	b=wwUy89C+E9lNA//U/AsJuBDah8zvlQ/DWakc3eRxHaOGYsI1/2JtgfY3SUtdwIcxo9alzJ
	2BGn04mHaFH9mjRyk3YTC31U8Xojz+hRMiwcvGcOjp787nzHG+ts1ggxrGRksw2fW5drk3
	TFN1NGtmCy/ENWKnxmZcEbFpMOh4SZY=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b5c81bd953so2716185a.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010792; x=1766615592; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/0fSU7byX7H74M3pGZ6ch52/NJ8dJexMYfTnz06pjc=;
        b=Q4GlKYBLhpKKQOhIsklFIBxbancxreKCx427Y9j/nRR2wXTQG2yHw5StR0k3ECzTyo
         AT00R7ggK1Y/QyNXNSGhTdyirbK06IK/+sxdtDzmseHx1tj+f3xOYP0r5vXcNJ97+j/6
         DAD11eu2AHLTRNqTyfGZmogJNoRgz9TtQMkrChyccTozYpg1/goLbhsRLXYiPu2VB5wr
         ID7VyA4e/O2vNe4W7ZKQAlseMKim8l+EY18dfGTqnLX+1duqGLdW3K6t9O8ZfO/GpZuZ
         Hh/krEbdraizz2pC/k3YUi778gX+RkUbFFGlsSM8cZ7YoJADzBcU7F3QTaXhXzgtdWhY
         u/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010792; x=1766615592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/0fSU7byX7H74M3pGZ6ch52/NJ8dJexMYfTnz06pjc=;
        b=AGj7M5MmcDnzEHpi8YYTeneyhqsGrAwW4wQpioU+4+s78hjnNCW3tZvKb3ra4UDGaL
         Q1yDDM9+yfAEGTZ6hJmj+Y4ViRFw08R5xgBlUCIkMKvcvBPVUKWJ+nf22HhzcHqZOAPe
         zQAaRlAYBTl9s4chYcPC/TxbYJADNXS6dzRdWx6wGXY0iauCYO4qb63mbmGocC7lX7K9
         jEqoH+ca9yUzKMsI1lMzOygUWch/U0AK9gPnoT35Ue2r9qjvcsALilR9UQnTTMQQM0Ui
         LcdC8BBkZYEWERy2fksKjl0QyzxVt3jQF72uYTnmPQuD/KT2iOPO3BxH1m5KzhjU817/
         a4Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUf88+xUJrDrfT2N3kaU8sOlH6RUiDdbaYhDl913nWze1l//Tz4y2j/lqeUdjZgfkooVXHWANNjXw==@kvack.org
X-Gm-Message-State: AOJu0Yx65fUCv/LL7MI9bKEfbfVOplcLfSFtyECSRnztzRgOLM/pW77N
	+aZuQSv77PH7t29Ye88ZNxbdI8CrA104FwGC6n7oCSnNykmWKmNgBqOmwNyRcpEqpFI=
X-Gm-Gg: AY/fxX48GPZ6DeQyLUIf2eJwaQSnJmE9XyKb+3vF3UiVKGhRLqNjuCeos2N0ZXLsS5v
	VVOxDSUlV6FEIxRbmXSLfVbMrrP0HvxRPOPbnnO6CtOIfsa9qnfmmqqkkIYKX5tpfx5fng6MXFp
	blkhu1QKeOEX55iehgmJ/7p6nYOpBvXJHIh2zBL4UrtmOoQDjJIk2494yllcxbfDN3pcviqOW8g
	EDzPmu0+GBp61ZU6bb75ZDbMOvSp8FmjAh6KeJrJXo54Oe/54mfYZa0ZhB8DfoXhiuoIo51Hqzf
	WYdiUROdoCAPtaUaIW39YlrIQ8d58E+Is5StcBZgpChkbMDY6/5JzsfIuIUPluzTiPd3jbF5EbL
	oJmGl/jqjXmVElZpYg5VukpXmJuzqTmVjYqi8DvgkgSkMk/0I+sfi9diYmPoJFivW7VTb+oj2VV
	8e4PVisEMR4Q==
X-Google-Smtp-Source: AGHT+IF7/FSEL/FL21mefzRD0FNnIqW4z7GJgpKznrwLCEpqc+nHhV1if9CL8B9ObJ8hxVZ+Dp1jnQ==
X-Received: by 2002:a05:622a:146:b0:4ec:f697:2c00 with SMTP id d75a77b69052e-4f1d059e3f9mr279660781cf.42.1766010792438;
        Wed, 17 Dec 2025 14:33:12 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f35fcb439csm3688841cf.15.2025.12.17.14.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:33:11 -0800 (PST)
Date: Wed, 17 Dec 2025 17:33:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 20/28] mm: zswap: prevent lruvec release in
 zswap_folio_swapin()
Message-ID: <aUMvp5WzDp6dZCVr@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B2C3180013
X-Stat-Signature: rru6q4ms9xd37uj9m395madqpoo7i4i5
X-Rspam-User: 
X-HE-Tag: 1766010793-330948
X-HE-Meta: U2FsdGVkX19rIUvuLtCnLjwqHZieM4j9N4EHWgpZnIzXQZr0dw925SXx/kpuI0AaFnVkLIkBczoAoRZJ5pdBfRPzzbYTf4hIcSIZzMiyTZXhv8nDg+Sjd3Q579ikTfyXFMFWyQz1FlvKRccPC+e2n8yRF4B1oV8YZbzd0fmMS9z1FK1+N2WIC+s0hPNWCpFDWvXt2piailUtkcUAGS+N/pk0jS2GmI+CkDrnXtIAB7hY1T6+jj+5gUa9T+CysAX1dwmMQ9UrO91ILOT7OZJxnjSRV8Vc9CUrScEvej95c4IKetYPtHVURVorvKKNDczzcpCYwK86ZVh4QdmWQZwnG39VfIBGGCTo9AOJhu7OulxcUa0Iuh9ZXYMLUGAf+aHzkzXMKeWyRISWd7GhYZN3KXbkmqWagknb0Vqa1FKwmqXt/qP+iFKmJ+XfZsMDwgOFKUzXlwc7tgjWuUVU9O4R77VspT5RZ/uS7e42vloZoxU+Jj2YaC6fhJm4h3pMyZcK2Xrzj+s6tkQQE7sUvMv4VziGRiUxmY8IKJ0TYCdimLvTp9lO3npkSYYfamdI4q0BJtfvm5x0QBcvMIZo4pqm5xlUSG3+CrpFx4oaG3LXabpNW2Or4ogYyFdaDiTHHtsjA22eYVZ95yZGqA3KyfWLvNmMc0i/s49tfCa4x3/goqVEjIUcpzbP5J2uO7zXNPwdOTKqsnD8T9jFF3f3lmOHd57MM4vVm0EEK3dfQGPwOKfCP7MucsvsQQWaLau8FsoAGAVgbOKyLr18zjYavKe1S7cXm7O5paFO5+zaHYC5Sj50wfheg24GmFT/Etro1CaaMvfiO/w0WkibTlo2AAk7yR3/SNbhk9DO5Fw30TO1dZx2c/7Kxn7So1iR5AJ+ablin/wMlQDrTc7KFgTpQdYieEjqJo5wgYqVg6L31ZY0YrSGAJXfhGOm34IMERG4/OhTflPxfFo3xZpWL3kXCdd
 HNRNpkG8
 H1p/w0oO7D+tzAa8xfRiyaSdjOcHl2+seMODuZPyAV7mvrMmh+IXWSrbfnmZJR99f9TNZ1pOIdBHA267BzpcgTTp9dEgYOWguXG74VyRVwxo4vHt12EW+3/GbyBe8tEy6BMGAhji21QDTx24pCaYmJiCgsfTtK2aQYTMy/NldipFBf0URqfo04pJVuk0/JCwuQZTznKL6jREAXDotgiMXHmuozOEZkJLC6qxOFuskLWivH8GeBp+jiMteJenhnquOabcMXYP5z12iq0jWVk0NNiiM8yfUA3rqrl1xuM4xWrUY/gv789EmkO5TVVKx+/NyZ7Qmy1duFuSPwvWA5C6t8yRoBxNNRPQgJqYkAtFd2lip8qOwgBQRZVMi7ndbuF+x3VHzp/gtut+/dldc9ozPYRM7dgjkcTgx+8GvkhXFJrQWgmmEnS4phqkCsRrmVsKFN6Be6kyRdc2iwmxcOt37iztvbK36K7dBcqSoHzvS2M8dZ5ne1q/brfv9CHKrjkswoMCGyWTwZHQt0w2IxofvG+NWjs59ZbtiYNy7I/+LhLTDJeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:44PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in zswap_folio_swapin().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Btw, it would make the series shorter if you combined the changes to
workingset.c, zswap.c etc. It should still be easy to review as long
as you just stick to making folio_memcg(), folio_lruvec() calls safe.

