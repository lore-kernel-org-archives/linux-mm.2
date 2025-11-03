Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D6ECCFA07
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 05:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDC18E0020; Mon,  3 Nov 2025 00:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E9A8E0015; Mon,  3 Nov 2025 00:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2943F8E0020; Mon,  3 Nov 2025 00:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13DE78E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:30:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE1AB1A0980
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:30:16 +0000 (UTC)
X-FDA: 84068170032.15.84825FA
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id CADA0C0009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:30:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine);
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762147814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h0IjBdFvCe6GDPneRMmh+K7UVDEF3+8TDpaNsFUJXv8=;
	b=3ijNzcyk1Krz3HzSZvyieqW6ttEf5w/jTM11F1dJTECWI01LN7CZ5WezSmTKCNBbBkaT3s
	3hvVYALvJswoKDgTcFMnkWTg69k2ysM2huszN30ICxIf16BE5w7bfFC4A5J4Z4ppJEZjfm
	y8W0mzP30VwTz9dDY3opbSKpMqHsY28=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine);
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762147814; a=rsa-sha256;
	cv=none;
	b=cCUazTwlhkZjmB9Ih26A/vlyCyGAuLto3cKfwLev8RgyN3H070+syQQxRQOo2DUFU31BLy
	GUqvA5hFNwqbOVmIzzrUciiOXqBj+tnV+lkzYGdJMMN3q0GrWRB80XXkQXYnuQ67TIErjI
	JNRGRaIIAt+XEWs7TpB3vQ//svVF06g=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8a074e50b41so555388385a.3
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 21:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762147814; x=1762752614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0IjBdFvCe6GDPneRMmh+K7UVDEF3+8TDpaNsFUJXv8=;
        b=tALnMBsxPlcb/Ihwu8amCd3VmxGSPcVfHPUN/kvdMuR2krz5dwByDvSo7y5wHs00ON
         Rkpais2AEgirtsRhPqEFsP4huONkYCRTzYg9YU+FyAZ4lqVgBFHkS9iVv5uEJtvGyzfm
         HE15q4GGn1KiCjPsV25OGj5yETr+73bz7KBESDkkRt4dx2LpWZmXscA6a0TuMvE3yGGg
         z01BemMYyZeVnx+PGjcTd4UWHPkTvfKppgxsYRhYH39n73eGrBkrZVlYU2DKt0211hnc
         sxzShBA+d/IG8FaiYiT3X7AZLKBBOipjggJiKVHJkRwTLciSToST50BCIzYEwxrcFvs9
         oNJg==
X-Forwarded-Encrypted: i=1; AJvYcCUDg8wqYd6KPFwuAd4QxGAdyCzSs5OiZPRD6ulx+yRfK22tHxpZlh+MVC7nq775Q7K7EmtNTnMbXw==@kvack.org
X-Gm-Message-State: AOJu0YzD9chY7LZGCMGXUxxnGLCKN1vLdxVnOBEJ0Ovo3SAlhbj7JxZ6
	RRKZSBi2/HasN8sTEP3i2IEplTQBeR7EfQdxd5hHuwPN2CQkPCLLyR+Z3rhCPMGlHzq5abcqlHj
	vEy5rRl59OWh8HTTVpczw/AsVK2YKuBc=
X-Gm-Gg: ASbGncvISl3qELhFEh7xYOaWuO4uRN+Ppnbr3OREYwJnROnfyWdAoGr+y5QoybLkLVD
	OyOyuMpG+zj+aMA2H43wiXeli2RXfRHbtfTjiTMkS637Zk2YqQVUq5jxFMYSliJnXXN9V8Si7YK
	YpEiLf2WnfiYBe3QbFjwK4PdO8oX/3+C+7ePCyikOIl9/z/j/gcrxK3mHeEarNSuXXhN5l/uPSP
	ppBLM8kBtz8IRwm5arRJ5byCdqVjo1AoEURp7D42adpnPMpVln/ek3nKbLKBUrXfUmErotXQkqY
	GZEDVU3IZcicnS9O
X-Google-Smtp-Source: AGHT+IHOQo9W0aZf3MnjhclhR3nwlrFk6dppnhp5ayWEimO/qCbezZZnv9jMcOotLi2ysrcz68+yI+jPmrE7PBsoXgg=
X-Received: by 2002:a05:620a:1991:b0:7e8:3fbd:4190 with SMTP id
 af79cd13be357-8ab98eba49amr1317486085a.2.1762147813760; Sun, 02 Nov 2025
 21:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
In-Reply-To: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Nov 2025 13:30:02 +0800
X-Gm-Features: AWmQ_bnMUWkq9T95a6Uuq6ry1hDCnCtzRCM38-pLN__26i5yO5lc68dIeHd6alg
Message-ID: <CAGsJ_4ybtsP=ObDrWHZVN0htoGSWy-RMkRuiWWw6B9+Xaq_4YQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Chris and Kairui as the swap maintainer
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Rspamd-Queue-Id: CADA0C0009
X-Stat-Signature: fmjr59gu1wdc8poj1cgjpg1x4imko7jo
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1762147814-477261
X-HE-Meta: U2FsdGVkX187q1mR3P3s+6srUQQURAvQbfvo7WMID3rUPiTVgln3lLiZBgBtU0pt0iyetAllmyhLlNe9tEZZvOheZBd/hAiBCj5K1D4T15hMD5fzyTERbFzZFcMoBWISBi9MBdHQ/K4n+JPHyd/RnCdibMyrtcpMb2zJBo2QRYUoP5yW9Z+lQUbPEL6KYBNMtOQjpwzRHfyBmz1pJ+I8xdtosqjSD8wpXAcECOOcIABBM+8pWCz02v14nPe6MOnfAU9Q/4LbPLf2erume9z5KR2wxc7vRznLADmJFfhZ38TYfJ3AVHu5jjEAj+w6Q/kO1Kt5SLZr/WGJRTQEEU5DYVrD5Gf+yrk2Lv34C/JoPghQSP6MpT54iKjIyyJd092WCIoPzXUD0PGBhfbXma+d4HgxyaHZ3sjxKC4IsRjuzZPGI+5m8p0iGqkIbphllFIs81xuJQYtTmE1pszAoAl7mJYKZgkGYOTTy0Hx4Y2ycrL4FmsjePKAt252IqaFaiHYO5jD3VVw43cubhoVSLGPRIH+FGvSKAfx4mBvPucvX2m1PO0PG1S4L3sRFnT5E5HAhx5sAKr6XsLn+iB+F2lIhhOAPuWRZ2IgVv4byy6W1EC0Nz9J6pbx6ALFmRxT0jAgDNhNP95wLpa6EG6vewJyWwVRNvks//LVBHuopBbi+pDxla1uE3fsH/gvIsXh1GwhFRdSnsvWl50+SrqIRs7o+bP9NWt/d9U0h/VIEiJBogLZS30QNZHonoWuJXsegxcS8fmHC2zDPsxJlQ96GM4X3dxXGJbTomYDac/xaIkr0momacBiYzXvUQW7WhqzP6Pu8DK7o0FqeQDGC2Ec0aUJ3oLh5n0WEXfkSOEW/9gBxtnuXJwiCNz6/FHHGyZS3mxjz5uQR0Ec9gV0wc2uuV7pcs9b0nqwMx3cg/F9Jkj2kz33ioxRRGPll5M3QsN6OJig1eTK1EFonO0r7Hy94/+
 Fa0yULTT
 jw9g1+fzPYfluLKX9Fksw7Ylm8WEOYd4yQZ2jFcFooPX+62ayCsS+gnP+4ONF6/P8D71cnvW7EFwOkmAUMhxiiOq8943H5bb27QBGlRWD38/F8kSWgmpIzsvYF+bx6hRPlFMm5lwSvs9wbAnLP85MRo86JxvP/u+gV9obmh3HMyq+xboq8J/BTl473Hzj/jjt3LxsYV5ObyKeZp3Rq3k9FhT3xdiMkSGmm39RjZ8iYH/fDGKPcZof7qTL9rWNqC42lPdvBcAM/qQ3c/vooCqM5yHJj1DXKdbsQh+ZDBPrTDENQY1jNDKJPTDu3k32gHDmuOsi04nL+7KZCR9DbF/fV7Pyk90Z8i1hsE4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 11:11=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> We have been collaborating on a systematic effort to clean up and improve
> the Linux swap system, and might as well take responsibility for it.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---

This is very welcome! Thanks for all your efforts in improving swap across =
both
architectures and performance.

Acked-by: Barry Song <baohua@kernel.org>

