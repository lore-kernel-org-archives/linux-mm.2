Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65528EE6B45
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32FE6B0092; Fri,  6 Feb 2026 12:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5CD6B0096; Fri,  6 Feb 2026 12:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2546B0099; Fri,  6 Feb 2026 12:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A49B6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:52:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52E0D1402EB
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:52:53 +0000 (UTC)
X-FDA: 84414777426.25.6A9BC10
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5B2FA18000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:52:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNOcaFy2;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770400371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iglojX4sGUyAtQslTyBLFp6CalS9+S4aj8OW0MG/LxI=;
	b=NzaukscKR8sZhnaax8jXMdWfEK/DTQNQTXYM5Afh/azvjdtUlb12VDLmhieCOsscbul/p/
	gMw1n37fPMV74928AKysvPT1jnLhhR6yQ//I541ztViq09D+5LXjO7hpmPbfOH5UU4NnaA
	I31BURqd+oeGQjeKQZ+dIYpLxxR7B50=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNOcaFy2;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770400371; a=rsa-sha256;
	cv=none;
	b=tSpIFewCOjNo0PNBiUSCngWMNSDFcVsdwBzkZl70mVSxwn04ImPabWZi2YFKtUX00dKl/0
	R8RI8mfUw6iPHBNioKm4d7zIQTpv0srLsUFeU1Ev0iKfjfoBXg1hHWSjcmbx3CdFEXf3LT
	XLr48LeJNNxelKMrkA1UaQzrylNz7e4=
Date: Fri, 6 Feb 2026 09:52:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770400369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iglojX4sGUyAtQslTyBLFp6CalS9+S4aj8OW0MG/LxI=;
	b=NNOcaFy2R2zTQsGUVb+84nFaFJk+vqlHDL7Z3ZTYWxk4WpcnHwDLyQW0yB6ehur4GHdHOU
	ZfLbAOGmvNb0kDL+ELwCJ3W8PD3zO4+OBRsoqUhpmdyCiiTYsDsGp+P1kFPc23CWTJJgCa
	sX7Mt5vlWWf+lNfPNbUX+XoboaSYV/M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Nhat Pham <nphamcs@gmail.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: zswap: add per-memcg stat for incompressible
 pages
Message-ID: <aYYqT6Z3R3phADu_@linux.dev>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
 <20260206072220.144008-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206072220.144008-2-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B2FA18000A
X-Stat-Signature: c5tqa6a99mkn5y8rn8ayfzz4nh11bah1
X-Rspam-User: 
X-HE-Tag: 1770400371-101793
X-HE-Meta: U2FsdGVkX1/PnS8m01w5yYIgjoNAxDz8Qkuo6We9aQNfiBeWG06wzYT/I4c04oDdbFMWX2lx2grEeeE6BsV5vaKq7x0GLeBLnCCAp2L/cgT7Nj2dg41DdK1IaOD+/rhu/rAt4J71hlF9K13G/zC19Ofei3yhMLdhXG1/+k1CvB5Ek8Lod8AY818hvMelW8GO7BFhBg7EgYq0Sk4cKhmOMZzxv2h6XGBkgziocnlIXtrM9wfOiJrN/4TT414zm4q0otDEH50CQmyxsCiCdU+gTv5slizSgpRWXVTD6va7b6by6bR6NuKWwXyxQwOOqJhJpVFSxHq6eAVDGgzCbyC5j6L3EfbFBweMN2YH2KqIhcK9MhE8Tf8ITr6jYCvm08VZ2DtpZMXp8d2qvS9WM+6LQBFGiDFfPHkFdWruEVS1cthvX2M70MbFu/FBMIKJOStFXwtEstwVZrHj++1dZTnM1PZJrTnpnHTDkFyzBckXxtlXuBm86C0v2SC6tEnmyrh3Ry2UfgA1jup0oJ0dyke14WXJxtECZzTHKdnaSyLiCe310zl4ArfBs5WrRCWxidcam1yEFNH1j9vvXxuW0Km2hKi5TF2VCw4dwl/B8t0IUADojJOteLHDAcu8jKIGOuTqA65DZl8Li0O2BHO2LF7R6W4msaiuEP6kisojJxr1/pOF4jbMNUPCHlve7ZWhbjyulPaVKHxZMe83oS1fNHc17DXlULBwoGAQr4x7Mr/IreujaL2qJyKFYWJCRsEoBtAJVg/X9MYpZXKgSd2ufeNyqpB+6reIFLXSYfuzsBNP5n8jlPKQB9GNurAojXNgTnBGvL+kB8JYT5LWC0feCAmeZfAVPFbWI5TE1UX6tpCvqQwqCn/JztxMQNHbZXcNqLk+zbaJdJVqldHR8ysfyA0R1+J1JdjLJriIC/TfceV3C6OV1D3OeMFGPiPomzo7Hx2iFKYBEV6y1LATKX/nkO+
 ipacdwTn
 Ot/0I6Lq/APgmX1CIim1GE3M6ZYu2COOqzKemK4XH/jKG8t/BaHvV6fSVLqnt4kaW1ZlYq434uW1OrN6Y5WaGqcJFgekDqZdxK7uclrljEyaaT6L6SekA6VLqGTqL3NkaC4tI3HEIjfZHb1svwvIpqF3JVPUsS+NI7qbqr7R5KKEJ0SVyNYniuFhvrNhyDPBOeW/8+q332eeptMv3slzl5XuOysCg5Beu2l9lXzK54/oVuMZjfg1YHofj5MXZjnkHkp9O2j3fTfglBP5MXdcldblOk8ql72XWJWekNYztlhLHe/tZ0copYv4crSXw3OCIJV3x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:22:15PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management [1].
> 
> Add a new memcg stat 'zswap_incomp' to track incompressible pages per
> cgroup. This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
> 
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswap_incomp stat provides
> direct visibility into the latter case.
> 
> [1]: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

