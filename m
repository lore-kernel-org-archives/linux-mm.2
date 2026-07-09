Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D0CC44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252936B0088; Wed,  8 Jul 2026 20:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207F56B008A; Wed,  8 Jul 2026 20:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC1C6B008C; Wed,  8 Jul 2026 20:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D42A16B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:06:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57E0E120365
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:06:08 +0000 (UTC)
X-FDA: 84967295616.12.F00EAFC
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 65951100004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:06:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DTcEqEb6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783555566;
	b=6IJ9SytDMbI1m3bcI/gnehTETMLx+5DxZ7ZQHBTVU7Px4QHrJRA+p4hNNcLPu428sfpaBW
	LjmC7piJ2lge0rz//kPppKC3VL6BjLvnHUZqOICvOATm+80SiWjH3f+fBc7q6fw/Awedf4
	LtsyvZ6Wtg9s9WEbMnEv3ma0+Czn4y8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DTcEqEb6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783555566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
	b=RclPuTqCLAzkIxSuE5i0uy4wSrjanTyrLJWtH/vp9FUyMnXOm1ojm40Fl7jZq0Z2Rml28E
	qxC89gNqthMnMjaV9E8SyBKStC0m3gCINJzHr5IB3GNRiyQIwRLpgZWD5zVJXcagBVUkTh
	DtgqRov96nMnlzrJr6ZIflqhjZPIVFY=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c95d0a54ea5so914658a12.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 17:06:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783555565; cv=none;
        d=google.com; s=arc-20260327;
        b=L8GY7OM4a7RYNHaZhl9PwEcR0lG4xLVlz/4CmosFr9D68otXZZultZNy+ZwBb3+4RU
         0HDPX8Wuip5/Wk4U3P+FTjj3+VouVcpooduBDab3q18Q0ZnGHs1Dd+TmtB9b4oTX+t3G
         N1m9K6zmRyMEmrfhmf4qVDLRIQuA5s0DB8P71Wn/0WAqO8tU9BHgyTvsGWu/1RhcLQ4d
         lhA/d/AjSfUsKMPu2neGtv7naFoSkB1qqqPXWF+HZl14QcyCEzp6I8/4O8CEfsyabVq2
         9Gjfibv9oJL+gLAHqppGdkvxCZwHy2vQQwE0+SkK93tXXup8/Cj5wuxnC14PMJM6TP7f
         q+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        fh=pGZ5rQGypxLRU/pVIOqx/4CLY6JyCYJiAzC9fv24zbI=;
        b=XoeYPGkpy8eNrGUCADs03ezhSckaPKaYHbUQDFwwbs0i+qwhcWBHEbK2qNldfHU4Bi
         16dzVhFTtqFDPxy4j6ma59pKy5R6N9KrowkI7V7KIzZHknAU0FxzsOdzQcpQ4WetySj5
         JtsacwgK4Whkpbk+vYQXRh6Bp5vlfd+ycld6equwmWJpDtXoP+3b1yGbaWvr57Mz2W46
         jA2tq5WqoMzymQkEZBusp+f8C+JAvzWFcT4fASfNwmK9wezas86tLxhFH2fsP9bG37XB
         ZLv5v2V8SN0vR+3DXSM4sRAZczXPs6d10eKprh58CTX48ZNua5yXIj5Ylmq9NIMSd9lt
         qScw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783555565; x=1784160365; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=DTcEqEb6NTRq07xzwbeLX90luT1PLLICO3cUBnHm+vJYsiGI+ZLB1O0MybYmlEaAtZ
         mNg0I48Hv+hxaifmJR9f0Pn4qNX7DW6x4HqPMPlPYbkpaNlxS3QropyDfaxTYkOLn5N1
         su5Xo2966iSTtDWKMnKcBsJaa5Kx12GWUbpNXvFXx1cC4Hste+IfuB2KeTPiS3c8qCg4
         +H2rCW+lX4E7IXmo6AQLhdcl1JYMjgnFzcR/QT8JUfPF1b0VZzQjNW6mwsKkz8mAQilA
         1BM6bxn1EmpqhKfp1x3BqYNkZz8W8PixPZFwB9eQ/ZRtvUzsa7Iv+FK1Ez+a4/zN3KDL
         GoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555565; x=1784160365;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=YPvBmszvuaezZNnCMHFzVXZgGq5q/gnCPrrTYIIRG4kNKhVkyajhTi4yskVpjK+Fxj
         1at7pqNSpbyxHm7pEtgZtOYZP2DLySOXmUw+RitmH78Dx9+n2Nzn/v6uRg56xH228YhI
         g4zA2s0OAQekkqw5BvAvGag7Kw7/S9zvgIwdh6UCtoZemzef3yDqoVc5G1wVbiRiFrlu
         +UwmJGkvEHewESvbdOW2wccsbTE4tIpLnreOABjOYRA3qxJZQBKJw7pEyYpHI+8GiSY9
         lRDKDunUfGdsPCU+Dow8Z9mnI8cuAyNJv3NZFMqcEtlQMWf+0g5+42EZdpZ3MOBnBNih
         ucQw==
X-Forwarded-Encrypted: i=1; AHgh+RqjnB/vziwmZWe8n1djZD1jpfAft5CveimEa5DAGpp1BNNsmmhosOykbh/CW6XGg9uwGKI9dB6Jvg==@kvack.org
X-Gm-Message-State: AOJu0Yw8tQg6UxNSKIRLORSA7OTYUmMKryadKsJfdFdsfkc8llAWusEe
	mtw3POa8hATdfS0N5+aeBKfu+mlkX20wxENCA/F0CKHF7bgBtQOBVVVwUDr4JrSygfbrVYZtRlk
	qmN3rA4H/3zkfIIdZ5LZAYoMNC5dol7bnfb7ZR4+w
X-Gm-Gg: AfdE7cknxvrA3Me/eYM0BY+PtRcXIpQ0eVmXBvn1OaA+a9EPArr5fAYuT2ZPm9iKRGI
	QRwnF5MR/kyqvyFlmJtYWDeforeFhACzxc8BX8Hr36v09MsXg5mqMysvQhnv8Pig3v6N9F8lIj+
	WX2J5UckFxUy7Ha6jwz+EtGedrt7Yj0+HXIBxbPKiawLfvJm3mfRX8jn2c4k9gFCwVg4gffrvXi
	Dhdbp1VpC5g4XnpBEeaDkebVOCYhyFHrW1rjJWolfBBNAWG40M9GtcmZxrGXT5fAclpaxkz0l6W
	9HFRYVgRS7aA4oy8Mtwm9ZJdSOzY5PLWPsenQ4KA4KR5+xhDJDdHQzZMKr9Ufd1XIaDouA==
X-Received: by 2002:a05:6a21:7482:b0:3b4:669c:ee32 with SMTP id
 adf61e73a8af0-3c0bcbc1353mr5760887637.37.1783555564841; Wed, 08 Jul 2026
 17:06:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org> <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 17:06:03 -0700
X-Gm-Features: AVVi8Ceg-PSWltTScKU18ZF0mdbBsNHDv0s-VKhIaqzjwQ-q80D6zfZMKk_VWII
Message-ID: <CAEvNRgE-JJAzC0jp+bY8+e1+gYSH+MjT6JqX_DfCcpaxOM-Dtw@mail.gmail.com>
Subject: Re: [PATCH 15/30] mm: introduce and use linear_page_delta()
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>, 
	Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, 
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 65951100004
X-Rspam-User: 
X-Stat-Signature: unhe1tkfmdkbz494bmqjk9epsc9w7ap5
X-Rspamd-Server: rspam03
X-HE-Tag: 1783555566-823450
X-HE-Meta: U2FsdGVkX1/UDbFnHo1v+4f7LblF30oZSTL1OaZFUe/yyx7q69aC3CLVpmjLAo9zIBeFA+jrdby5zvRs2Cme9yqQIw7IvHrAOSIJqvc8sEcOqfJoIlMZ1jB+zrX5B8ZPqfMh6g6qGnhveQMBpeBMJuqd5mwJTMHXz7ZPx9nfJLqGcpDd02lFf7failMUwxN2/R6+bUxyYymHl03Fqw4Tw1FK9QM5XbTCtLm7FBuuEbydA+JY4Bgs4BYs82kXcxYo6YJNqvcjjBfraFRE5Y4liQinAeneSdWC5ULNJPkd8KGJ2Ps2dpdWsd/reTYkyqLE+Sl5uESHXXIZ+6NdBJxi/mgwd57kwSBBy6jEOB/rXZMzyEUcUUYOsJqQdmzwaG4nSaq5VQ3cyNQPpvWnlJ4u/sbRN6JvHpuWCeecDmLZ22/6LtHJmqqqUYap21IkXcmWOt6u5xfXqoWZeBpMq8MbPgtMPd5inrajzrwq8BxdA6UjqggLJVBdVIBb5LwET20aXU9Oo6qZQ0EgxsUesHT2W/jaqIKvaCNSLsY7yciKhiF8CsUtpIZRreCjjzAxkMyM8jK2kAzqGF+uxDdI5B7gYA4Q+A220w6iNKjSVau6T0f2VwP34655ix2+KdcSf6qOVds+UtaMOHt942wXUj93g1VBEID3eNboEeEuXMyCQPyIqnOVLA3tRGL9sgWAA58HAVRu/GYLGCnUaTw3qPHFTQDSDbiKXVlAn2AcxIHWZTYhAL31cF3X34oCYa3G5g12wyGsU3DUEKWwudQ5n8cEKE0zmeGFNBSToimgy/M0kypMLYpvPgARf1QKU0ViTqYRL6sPO1aUsp052zWhHY4TT5BsxwM9EcyBtS4nsHlODMkd1ckOkvyfOvWeppm43Ay2sf6LExbRgmkPQtMOs74/teExRurf+bhjMQQKV2zpXq1HRsYLfo5ZxTmwHYCmJAGBoqMyEQdWVx4V6819vxU
 CPjKYtHM
 ph0+fUTNYQiYn+VJvOXvUrIWmA4E6utGt2pMwoowVmP4TE9ErX5HG7XkXk/ByMTY8XgZ+D6ENppMXBXx2PnsEuXo9Rb52ZvK4Eocw+iuDkFKq/BLq7h0VHsFnvCIZJTpYm2wEQ6T9yrexJZ4JjBjGdP85E6YZ4AXHVTbuPsnOaLpzTn4uSbtCVxrQes1rMSyXEjrRj7KOthd835M8cxl/H0HfdmMgLuTf00PkEI3RuDjWD91guU5k1HhcdZ+F0uwbtRHtSUkaG4mcm86Yo17wl56qoPf2x7ZkRTdy0jTR4kf/MLy0Bmt84MYntCrwsG8znduIhYoNUoaEYZ0OGs01X0jauicUDQulC1MTiLqW+EaNZGa1exH9wovWmYyuPmdjGkhAKF10B93Q34zaYG1PZJR8Z/XJgN/nwhkYEWNYPIVc8q7/3IM17WoPq7Q4s8FeAILuN6025tzgodhEVrVkNjCJxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <ljs@kernel.org> writes:

> It's often useful to obtain the number of pages a given address lies at
> within a VMA.
>
> Add linear_page_delta() to determine this and update linear_page_index() to
> make use of it.
>
> Add comments to describe both linear_page_delta() and linear_page_index().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
> [...snip...]
>

