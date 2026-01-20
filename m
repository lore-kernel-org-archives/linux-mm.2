Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FD5D26280
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88016B0488; Tue, 20 Jan 2026 13:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28836B048A; Tue, 20 Jan 2026 13:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34E76B048B; Tue, 20 Jan 2026 13:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D66D6B0488
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:38:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 118461AF65A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:38:43 +0000 (UTC)
X-FDA: 84353203326.30.F41E49D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3929118000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:38:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="La0i/3GE";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOV934DYRc9ERWmoCuXpOFxaUel0buwbS4A/jVjuySc=;
	b=fGY9/OS9+7Ij8qcIyAyVEIhR3i/u0xVvDN3g/iW1gSlDUtlBqrGwFIVkABaqABZhWwA0w3
	uvBDXmymYgz5wyo5Gkux3NpxsC3jCeFMfxm4BSiyYKHABRRTdna625bIcZ7+Uv7ps43n3P
	Cx0vlYmFUzFQg0IFeibxWfDaXPoR14A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="La0i/3GE";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934321; a=rsa-sha256;
	cv=none;
	b=8nBEImGyrOR96fQN5zqBZ6jI8/Zjp1I4qfLpQ8PNFU31/X8ChLutd1CD1qVy8ZPgAHNKi4
	GULhTDf9Wtv8XOKlcw6gLhbJz/i3pLTF2BWvD/yP6Tc/LFTEx4ooG1Cktvu0YX6K7tpO+I
	kiZ36GUJOpvPQz9JeN+0VooYbAf6i9c=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5014e8a42aeso61252191cf.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768934320; x=1769539120; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOV934DYRc9ERWmoCuXpOFxaUel0buwbS4A/jVjuySc=;
        b=La0i/3GE9bYz/MGmvFHuyb01++i7MJz7tzcWS2W7h165pUk6FE4ldalsiI8nUUyRst
         XldcPRioVYzL3wsnc9r/bny+Ck6cfP/oBnD7KRCRK1PbuSMZG/1Dmf+k0XR+hWnhxeN8
         4zk1e2HIXfPNLHV/o+/Dd2eUW9tJcUtCxt+8TKTXh5fEJDZKIDiiKuXmJf0FAro7thcE
         Cf98mvQHI5YHnyo6QkhZYFq1U4IUQlrlrqCH4rxC8GfkrkL4zn1QCrqNajH5qdW68/oS
         QcxFmPkzxamFTGm4GXkY3wRjCSgu+bFX41qZhS9utYHaEzAfQiVHkREZnd/RlKKMnPAU
         IpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768934320; x=1769539120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOV934DYRc9ERWmoCuXpOFxaUel0buwbS4A/jVjuySc=;
        b=uYbw/yJECxQmXiEa17PCCP1Orbi1QunnYWovFKKLvNr504ughVz6wy+uc/i96Schvt
         A+n3j0DhU6xxfac8Kete7oYR4/rq8ovwel/+zqCnH1Y7GU+mhNx/wjOcHxyhq+xGpLs4
         n1ajkq3VXOgN/zaZpI9lLMFm905ZqWhh8MHhrkwA57/7dV9/SdSHZKwQnJ+suJStC5ny
         WFYgvWuiuXmBoomcGHlUXNWjSjaKLcjhgcHNIHtwYwuESJpnpL2f7A6vKrgggk5ShPKl
         7WG2Io4zHdQVSOp4WR3AGclcoxmBbt6hxokxdGCb4AVb2oENzAmUPAyTSxz+XmiOD5RI
         Zzig==
X-Forwarded-Encrypted: i=1; AJvYcCVD/HyonCxcVus4OIGPlmg5z9vsuPQAkZkd94PfuxQIDf7hEXXSdHlGjjUa4g5ULcfh7drGZo0jhQ==@kvack.org
X-Gm-Message-State: AOJu0YwlHjrEJpyshAkCTx5wEBq1l11odTjbsrnwOIiVgT6sadLq40Nv
	FkPaJ+kjYZEk/JxHuFFezkihW8wVoqcrVooxdC+p/a5WFDJNuWpxGbvtNfomkg5lpTk=
X-Gm-Gg: AY/fxX5t9bj9Mp9NFTYPqz3CWCTh6vVUr7hbHFyBQOImjbz7x7sWmZBkA3sUmNN2mmo
	Es5BklbMf70LxaHwda+W1ijh49iis1U2qi+KGVLwjkgiuEhH3pKHzKTjYpJOovftfOVpXyeKWxN
	1OKu1Bm9+LabiZN5g18xPtqJmOMefucOfmEaqpi63ZSrFCNrcSwkAhzrMkMD4EgiM0amiFDc1C7
	weJtmdmnG+tubG3G6N4ADlFE0qKGv7tauhAQ2Pg+urmLFihnh5/OIjIWL+j/c3FMXEQE/tRpQrG
	3+gR2FwyTlsQKDFDiDylu6VSyOKrk/j4ezzz3/tKb9OJQS02s7wUoktYEJnS03JpIQ8Q1bD724x
	NtqW2znCsv08bvzblEPSZvLqicJvKhZZ0giiQDnMmgYRaxy+Fs6jkKhAQQbunqrKCBrUc8h976a
	Kn6du+P9BuZcQPmvxaADVsAwrECNziBUShZ7R2GHrYYwTswsiuA6UGJS2cKjWt5PLWuo6kyA==
X-Received: by 2002:ac8:7dc2:0:b0:502:9c4f:e284 with SMTP id d75a77b69052e-502d84dee8fmr37431281cf.30.1768934320230;
        Tue, 20 Jan 2026 10:38:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502a1d9f296sm105269001cf.12.2026.01.20.10.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 10:38:39 -0800 (PST)
Date: Tue, 20 Jan 2026 13:38:07 -0500
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: david.laight.linux@gmail.com, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, dan.j.williams@intel.com,
	dave@stgolabs.net, david@kernel.org, fvdl@google.com,
	joao.m.martins@oracle.com, jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@suse.com, mjguzik@gmail.com,
	muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com,
	wangzhou1@hisilicon.com, zhanjie9@hisilicon.com
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <aW_Lj0q6swLVR8SY@gourry-fedora-PF4VCD3F>
References: <20260120094744.5d92e34a@pumpkin>
 <20260120103949.7673-1-lizhe.67@bytedance.com>
 <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 3929118000B
X-Stat-Signature: ysfphybyetae7zcfouc63ftdntdguapy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768934321-424539
X-HE-Meta: U2FsdGVkX1/PPAHbPX8ENUeGYvk8mSFVR614lKSUAoFYAF3WjF4VWCEpwIn8f4hWtDGq86NVcrfU80KIktabkd5HI/hLH/2Ut0JuPbDZGHNaYdhu+RgvCczz8Q5D/AflTJCQ9kVb3QsdS4921D6F/LGFw/jztxUoYdCe4k3r4pZ9wfmm5+T0HRpt/3YxoV2eN1aDgT+5tFtdaYNsi1/xmE1NvN9RIEZGlhhFU5Pmoik0XtjIj30rgteXIhH2vmC/9Iea35MgRWWmmB39zM6nYfRDe/Eh3PFeeo4kIZXHvsZKfWkFxYesdVD1oq4A9DapNYXYkFMS3uxU4NIsDxyRITt0WjcVMZbAkqrkca4e5RyVDWzf1/VK3294+o2caKFCMgQBN7m4h/rcFvF7+w5NY/Bar5rw5NH8fiacrd9hogTF8tA7WH100iNgev6Z/Moip6FSZro1WqEDEgLblvsYTB+nzhZbM0WvC+m8ugoa9VQ3fZPB0ZeIX+/DrjY5Zt+Wg9srWGq5v7/95VAVbGrpCe/EYnEQ74yWv+XWE42cSFF9Yo+aFmu7Mp6jAUOrPcXRPutaiv9qUQIkDy7hJnuCh+pm0He780DiEolUAwpmMck/UcQ4nXnFAeBz+nhJqnvJNWHOwUHz+/4KKwy/3muudSkbq8/FDETCWij4V9lwRRZMLaU3EamYjxZB0nqm4lCPGSHsWdiLqLIvZ998F4Wq9n6ueww0B2fD0iodU3KncL/ty6kHftSg5qBaXvvDQE1kSBh9MOPREbg+HAWdqyulAy7Ogysu4k27sXcBs0kELzB1PCiQtvp9/5ZbmSbHWZq6iqVV5hF5X5c5OM27ePmilYKatl3KQy6xI/Z5v/zH52dPESc1DT32Q4i32XHr4dUOg0YhX1zed5RxjrLakRKKhQuosuDYkukWg8D8248h9j8l+Ow5bHPlRnRTpK+knXEOzqCf4NxfriDkKWxCU0i
 7fJtDazc
 HQUbUL6bYLoYl9BCafL7UgiI4aB5bj8ZaPicdG5Hl5JfB6gvNZekN/OdTrMCJoSyfam/+0sJnXpquJgJ+CSiMQDlym5Xh2o/vUfsjpI1gpNg9f4pHhiBdf8hYD9HSWw8vyiH0otdHgTF+RLjnitTcSuleEcIdfjb62Dpl+41mH3gdbYXPJ5EMf2J1xcT7mjDh1sNR/vyO7HOHgTTh0J9A+7zYq1jLSomA04w+EG5Kw1Q2wH+RgUlJyU4q2wVjG1FayJAQ57RH722PVlI44sGdl2XTVmCjuECnP2iOf2l9mWcYJToZq18wdxFt6VA/Qb7YK3NIOuSA+NxGx/E/DoZ5yZ4a/w7FcAf1mSzfhbNlOT7iuP/b9XmdizuJymEAUhJespV42VL6UAY8nYqbm5Fq1BB+Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 01:18:19PM -0500, Gregory Price wrote:
> This is a trivial example, but it's unclear zero_on_free actually
> provides a benefit.  You have to know ahead of time what the runtime
> behavior, pre-zeroed count, and allocation pattern (0->10->5->...) would
> be to determine whether there's an actual reduction in startup time.
> 
> But just trivially, starting from the base case of no pages being
> zeroed, you're just injecting an additional zero(X) cost if program_a()
> consumes more hugepages than program_b().
> 
> Long way of saying the shift from alloc to free seems heuristic-y and
> you need stronger analysis / better data to show this change is actually
> beneficial in the general case.
> 

As an addendum to this:  Maybe this is an indication that a global
switch (per-node sysfs entry) is not the best decision, and that maybe
there's a better way to accomplish this with a reduced scope.

hugetlb-only sysfs knob
	- same issue as current proposal, but better placed
	  why would you only apply this on one node?

prctl thingy
	- limits effects to just those opting into alloc-on-free
	- probably still needs hugetlb-internal zeroed-pages tracking
	  but doesn't require the rest of the machinery

do it entirely in userland
	- modify the software to zero before exit
	- use MAP_UNINITIALIZED
	- useful and simple if your hugetlb use case is homogenous

there's probably more oprtions

~Gregory

