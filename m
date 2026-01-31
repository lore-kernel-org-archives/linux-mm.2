Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17B4E6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153816B0088; Fri, 30 Jan 2026 20:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130E06B0089; Fri, 30 Jan 2026 20:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A976B008A; Fri, 30 Jan 2026 20:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9FC16B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:12:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A4211B19BD
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:12:50 +0000 (UTC)
X-FDA: 84390484500.24.6869D83
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F904140003
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:12:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LGGfchQc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769821968; a=rsa-sha256;
	cv=pass;
	b=A+5KaEgWtYcbaRfXiwAJPk+yldHQv4K/aDnlM0zCct6e32r5E/HleHx8TqCzJW1Jik3brR
	dZqYLWa0kbSv/oZmvnoC7YNSGFKTVamovf3ra1s3GNkMGvP+urXLbAcn3XdYY81B3MDzBH
	FSpK7lV6Gfyg4+wbOq4DAlf0tPIxwqA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LGGfchQc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769821968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
	b=OgQrf+qRGLiO12ng8mnMJrnXWxQLIjC5ZGsjqrjLjdRuor3sicCuOmEcbvWbJctVYeHoCr
	nI2UTd8YJWw+LFcA5evg5pCGKy0SNpmWgqTjQ+bkcJEqyOTqlwEVib3XKoPaV3mAChLWTo
	DLTZFtoQ1Aj/DJvN92mWKLgWFJLxl6E=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so2220807f8f.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:12:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769821967; cv=none;
        d=google.com; s=arc-20240605;
        b=dJ+oYv/ul+c80iV8N/te49Fxjr5mbZj4ICc+v7qXaPeERhBnD+JdwI5TL6tn2eaAUp
         k0fE9JQObvhUhnT+HJfa5N+51UVZqgfsPnfh2mlP+9tM0jbf67qboeJQGxydqtogEtSL
         kc5ys7ple2HtyIG4jqrLxlt8YkxqNm1oBEsI1zxsbn/RuBpbu92oTOxhM3B+qEPTohKN
         RshoVv2URnwzSevDWSY43aifJjrXc2xyuSw5NkIwr7QX7d3UQ2FqgLhSoI4ebbWaFsuI
         4AobN6TKHzIokH2Fg4/RXPxvXlEKkQnAC/g4R3C9vy+Y0D4sv4ijcfq7vfHCQAanIeQo
         Klzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        fh=IrzF1plp77Drh8zvmiArZa/LkNViRC6TgDFkSUjCWFs=;
        b=BhfkaDhNUPFMmcoFyoTKeS5BLcUBl8rwlxHfbPg+S5LQfSr6GO9XcZbFazW9Nt57J8
         3Zhv3Qmo1SjLErLzHcrafpb/A8zLLKo983Ss350a6su426cZVE52tPWH4rwLSn7e6rDf
         UQerLs/1+oxmTnUKao3vG1i1rr8jvdARx/mE9shzCkeo5CXA0OONEb26XbzEcISEuudF
         cvtFgbWD4WKK4PolXGaXbMMfcJJZZq+TXkzCGE6ZBQXRJCEyDwz9Em0P2gXpupxxltR5
         d4jKC7sChoc6vnr2ADF4Ni++KgFFPKVWHQe+ELKIRBdgr48F0JPrgXfaCpszw71XDC0d
         waNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769821967; x=1770426767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        b=LGGfchQcxXd1b30vJOJ4+XPNa4QMaaFbgNa2wg5sZRwYiDPIjHJodrI1Ch6Bc9oogM
         +2rprOL3Hu1AwRc8IGyXJmlgOz+d58517nZCoM8+3YaOdaeOxaldY9mFqzuaxFHgLtzr
         sfe7VSvv2lqnFi7VdRCB3Gb/1e2Q/f8C89D9cNBc0QgRGK3VQ/IP9yj94OFtjTym5Naf
         LQsrHk28slTBIDrI4F4v19f0CudtwJojxVgR2kg78bpna6nCessc7zFyTuaQRz2+whoI
         bLMGDrBDEmUe2jPSAzYAfL5dfLSSgZjqmlXDNddRXWtxcK5kCPPqnvg0p/UEM78wPhhj
         A2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769821967; x=1770426767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        b=ExydgvjSsu4Vz/FAb/fW+K3s+wa7tSnsaFBFXqIXh+GrHiwWk3UlA9/5LU/fdrA4pU
         A5HJm0F92Ra9vX4cyw6s51+h0J6XTf5Hz7KFbqgI6Dv1d0+OC91k8zOARP9bUxtRxD/6
         8yt/5ua1oeYpQN8k9V95w14qfFpEqIW7+VZ57RImUugFTnktK7SViNwRLOjnyf3fhiAC
         iyw0/3XpsoVkQh6V9yBHUPXkCZ5dGq0zVP0WPi6dOXjUejH6uPijB+KOY+bd2EhG89HQ
         TL6dAuqiUyikPi141xpTsqLWod866MdXWyZG/uGpv09pBXxu41EWBdRvwy2SdySUhPv2
         vKEg==
X-Forwarded-Encrypted: i=1; AJvYcCUvNX6V4pPsEiyPA9TZ+dXhHqT/TnFY6/ySF5tYIRR6219nMrIwXvh1uZzh4bEcT+lRofVlyJVAKg==@kvack.org
X-Gm-Message-State: AOJu0YyCjnpbNRkMu2e1KKkoSzoGbpPwXQ0iskGb5xsBpU1ZMHKFF+81
	10JbP4haUJlCnwv4qt8P8gINIdYf06vmOuz6Met+YikAeEldWmysSnUYZ9HtZGYhfjGyyQ4r9k9
	AZgSLXmP2rEWvboaccqmca7CJp+9Z++8=
X-Gm-Gg: AZuq6aLpPRhopykTV4ADcArD51E7xpEUCQdGSEh5ozv40zFbAhDcwntgM+wKJnXdtsx
	l9X5L5W4JHg16d2duSkN3YmLGk8z6XV05vkTuY+q+nqsPYQ3f9UnSrQ2NOP0bVFkWjEvRttYE+5
	XHc9SsSMAK8PmIRFWnMpgbFhcaE8tA35TwGI0WWsDFfqJ7e4pnL8MGl8fq3dsp9O8ZorXZcsqWJ
	igJpjtjin9jYRztERW0kbDzXeAeRiRz5qlOQ+1xRsHsQ8gT89fdDUKxCjb4notpKH1DaABCYG6K
	fUgMVAudxI8=
X-Received: by 2002:a05:6000:1786:b0:435:dd81:4f4d with SMTP id
 ffacd0b85a97d-435f3a7bf2fmr7914254f8f.26.1769821966655; Fri, 30 Jan 2026
 17:12:46 -0800 (PST)
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 30 Jan 2026 17:12:35 -0800
X-Gm-Features: AZwV_QjYxdL4I1ZK8ZPI34ugtzfZA8QnQmmf1QCbQU_ZqeQWkHXfgCnIwUe2Q8Y
Message-ID: <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F904140003
X-Stat-Signature: hnkuherdyrwjystkbe7tpr9j4wcgwied
X-HE-Tag: 1769821968-561310
X-HE-Meta: U2FsdGVkX19RiW2Fx+8zyIkjQ7leiMs5Nmp9mqzeId5IjNESe/m392KoQH6gRYZNrIs/7gTDAN9H6EtcLiZE90kBhlFoz3eNA9VqgEbnqm9CZHFYLqdGRuMTSS7Uat26SdxcR2CjzLYsRgA7t2mf/R1LXgCl2/IrBvKU1H7PebC1XPY6Jh4LAcPwhX9fBGDa1TOX/ezc96nna8ABl3cIaqKXtRO71/ABoifYWUvyM1dfNkUF6HdQlkUGLkvxdAwyESB63WK4uqFzj+owNI2C757gcDowdzaF/uJBh8V8b4vgmTld1ugiJZm9wVd29fdUtT9hG1mkfRQr9h+tgZ9XETj8YVh3btNGNj8sYlZC4bY1k/BHJyNwqOJbcmeYx9ZFwj4EtwZRmIRxn5FtpNxyv3+Kg/e/8pXrsMS8GIZUO5OREDaK/2MqxVQB5AajJfnYoN++SIowRpn+wfkOCyP4wLu40D8JMZaPDFKCAzRgP6kFtNusviQDNyMU2LI9EJZQJuPVsn90X8IW6JClyEx9ziqesG8rkXJNQ/7aqqSqrdhNSgikTLQsnEr+wWMczRtKjM3syzO09q1N5s25tlDOMnFWMCGw4l1gEq8ocXlwh7Nq2NYYljo+51V1SqlUbkP0LUGu50dhy8kHM4EkP6fZ0dLOKmll0x8LNybq4dmttPuB0em4Ao3SzDSeIbWZ2YYIQkoXt/X2wAENH06fz6CJ12YGnipppuZ2BidGXUXeKUaD/UcPpjln/VK2VKhQHmmNm71cn/yMLhYYqWlG4R7kzPPaZNqqsDAloyWqKeaS0jRcp2aCHh5aRT7dbwRDPqpfjcliEOTAzSFi2F8Qpd8U/qSg9REc+EcjS/7Hpl+E2TS23yNAp+b8raveYgvqe/CcL7mY4mP2TBsS+J22iNsxjffUCtZw3/avZq2Qsh/8DcRT0uh3EKKamp8ya3Wjh1ZQOKO6p7fhkl+CwXHmuf1
 xNi4MKqi
 0xiKlkqmEGSJFA/1OgP9EPMASyN8VFZlsBzVAzIMo7FFDshzUlvvUdl4mfWE143y/2tmQ4i1XFlHHk67ZAO9GP1oATJMDo68rbyh2saZv5TUelg9crAhnqSv8HOiPDcYOtq6CElT9Q/YinbJX+W2+rpGTopjSH4z6o+DlPloUnhhPy4UGpxXk1z4qNFLsvxM78NYPoH8mwOqTD9mw1filrltwo8GPM6dc2EeMaUZXOMf7PjlqR068ET6AilyFxE+U1UDsp37LYGILOQkZkB1ngsMJ6fPYT3Qp6RJTd1E9OmxG8AfMq62rVhKmZD6qHC1znIxB1OAz8mC+KPado1Vju/j3336mT1P2ujuQP3OqE56skMG9YCeB9zuKm33QWvnieF0I8ixzOs+Gwd6r4NkBT69fww2RsQjBqyPpJR2AbrO6qBAqQCGzQO3R+kqpa7GuE1mvCIiVCVT/oSxXDwtdlxJbyIBhfTwdoY30T9X6Zea8qiWGX5+Ex84Vu8xIGhyHrZc4tp1uvKoDkzXLxNAtM89TlHwVB/vl9cxwWynrmT1PO7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> We introduce a new batching implementation of zswap_compress() for
> compressors that do and do not support batching. This eliminates code
> duplication and facilitates code maintainability with the introduction
> of compress batching.
>
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
>
> If the compressor does not support batching, each page in the batch is
> compressed and stored sequentially. If the compressor supports batching,
> for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> is compressed in parallel in hardware.
>
> If the batch is compressed without errors, the compressed buffers for
> the batch are stored in zsmalloc. In case of compression errors, the
> current behavior based on whether the folio is enabled for zswap
> writeback, is preserved.
>
> The batched zswap_compress() incorporates Herbert's suggestion for
> SG lists to represent the batch's inputs/outputs to interface with the
> crypto API [1].
>
> Performance data:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> As suggested by Barry, this is the performance data gathered on Intel
> Sapphire Rapids with two workloads:
>
> 1) 30 usemem processes in a 150 GB memory limited cgroup, each
>    allocates 10G, i.e, effectively running at 50% memory pressure.
> 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
>    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.4
>    GiB): data averaged across 10 runs.
>
> To keep comparisons simple, all testing was done without the
> zswap shrinker.
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   IAA                 mm-unstable-1-23-2026             v14
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     zswap compressor            deflate-iaa     deflate-iaa   IAA Batchin=
g
>                                                                   vs.
>                                                             IAA Sequentia=
l
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  usemem30, 64K folios:
>
>     Total throughput (KB/s)       6,226,967      10,551,714       69%
>     Average throughput (KB/s)       207,565         351,723       69%
>     elapsed time (sec)                99.19           67.45      -32%
>     sys time (sec)                 2,356.19        1,580.47      -33%
>
>  usemem30, PMD folios:
>
>     Total throughput (KB/s)       6,347,201      11,315,500       78%
>     Average throughput (KB/s)       211,573         377,183       78%
>     elapsed time (sec)                88.14           63.37      -28%
>     sys time (sec)                 2,025.53        1,455.23      -28%
>
>  kernel_compilation, 64K folios:
>
>     elapsed time (sec)               100.10           98.74     -1.4%
>     sys time (sec)                   308.72          301.23       -2%
>
>  kernel_compilation, PMD folios:
>
>     elapsed time (sec)                95.29           93.44     -1.9%
>     sys time (sec)                   346.21          344.48     -0.5%
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   ZSTD                mm-unstable-1-23-2026             v14
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     zswap compressor                   zstd            zstd     v14 ZSTD
>                                                              Improvement
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  usemem30, 64K folios:
>
>     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
>     Average throughput (KB/s)       201,077         201,581      0.3%
>     elapsed time (sec)                97.52           95.33     -2.2%
>     sys time (sec)                 2,415.40        2,328.38       -4%
>
>  usemem30, PMD folios:
>
>     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
>     Average throughput (KB/s)       219,013         220,798      0.8%
>     elapsed time (sec)                89.17           88.25       -1%
>     sys time (sec)                 2,126.69        2,043.08       -4%
>
>  kernel_compilation, 64K folios:
>
>     elapsed time (sec)               100.89           99.98     -0.9%
>     sys time (sec)                   417.49          414.62     -0.7%
>
>  kernel_compilation, PMD folios:
>
>     elapsed time (sec)                98.26           97.38     -0.9%
>     sys time (sec)                   487.14          473.16     -2.9%
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The rest of the patch changelog (architectural and future
considerations)  can stay in the cover letter. Let's not duplicate
information :)

Keep the patch changelog limited to only the changes in the patch
itself (unless we need some clarifications imminently relevant).

I'll review the remainder of the patch later :)

