Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B29BDE8B383
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B8E6B0088; Tue,  3 Feb 2026 19:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D130B6B0089; Tue,  3 Feb 2026 19:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD566B008A; Tue,  3 Feb 2026 19:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2E9E6B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:31:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 776AF1A0636
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:31:04 +0000 (UTC)
X-FDA: 84404894448.20.85F3CDD
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BDAC160006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:31:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ESjziN9S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
	b=GQhOrvrNH41BsCIJyYYfXbi36+fI7SmWpDZAf2lkp0EdnyM/VftKNfkKgIEZyOlm4NmfN4
	IKFikB7dqm3Dlxk/k5kqMF18GG3AkrlG6bPenDmRGQWmpuWDwIp6gkP+vjXm7fw/27tN1I
	2Xh1CGiLw+hXQGFeqfxf4JQWzf91Mng=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770165062; a=rsa-sha256;
	cv=pass;
	b=x6mFZQ4F8XO4/dbvkCw6lgSqJccmqNIjIkLDr/EQ6oiSOAMYsSlFzGCEV8Ju0nuvnqGaL1
	OaRK2suNJ7J+5CoIzdTfnzc7ap58Fg38yPOJhjtRSPxprJDBl3BLpFufI2CjiittqbJfuJ
	Vc2s/66K0Oo7kYDPlTpNC9zARW2h/1Y=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ESjziN9S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4801bc32725so48019055e9.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 16:31:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770165060; cv=none;
        d=google.com; s=arc-20240605;
        b=ErhqBmDYFIP5S6uwql/Kfy/pKbckKYjA/A/q4jlLWjlEagImUQFQDrl/Ovb94ASdhL
         EqlG6bto2G8hdgHaZbZpEUzZLf9NBHeGkmAHf4BddnW94A9v314/3QlUf/3PwRcSOu6m
         UPHgFUnA8mTEymulCuu2zBc/aKMwgHH37yRzK5+2nlenD33B4831K0TgxSuYn2mVKdeX
         ZeQg4G3wGLN0l82KedanurlSQGj4yBhkTkbLCY9XtWkzmOYrO6F6s4GjF1QIGAOpAohH
         6LeMLsRBL0YNRTaTjzjAIYXuaBgePUrRlDADqxEwj8J3PYAMmsPF7mR355EWV7P01MzK
         VtIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        fh=WEy3s0i5q+sBrqTfUML62ObWd+DtfVxK7snbKtZT0Zc=;
        b=b2uQw+2TiHwW3SyRLUDatZf+NleBBQ74jUIlWRM45itCN3ib+75Vggi6m8TNhwRWH0
         5L3J1DAzpVPedxbJvNyjTKIwvwuj53gVMR+U9nHc8dddGz1IWLzlG/GN9RS0I3ksnxOL
         Mgvbpv55xxUlY9fw/4Bo8t1fmFc8jLoFv3LYI1FFE3QLizjLBWtCzx1vLs5UR2kg/Ifx
         O5JXm3+4qVJBJkFjAVaBr/wvoWJ1HGGQ15FhCQ+RhG1h7Cb574dkOv+1llXvlm8BkKsb
         pLoAVYcVMKHJxSJLc8vuak8uOt17or8e7z0QoOfZHNXzkeYIYfudHHUfUcxy0O/I82P8
         /b0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770165060; x=1770769860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        b=ESjziN9S99Ha0ouLKyULJBqo17iq7HWkAL3sc5ft0mkrLGF0cixlOkCmpO1EOYt48N
         IRU6GkCc6lmogOXPIj7S8qH/RKYgDBG4jvv875RMWHO09ejOUfMxrYaLcfSb2QHkTs56
         EXq3IKlv/9BLOmA90YFZWj4sXZfzP2wFXiM8/ffmN6tQZhb9MGBsf0nlBXBL8cB8ywo2
         /dnlpcu0Ugyzp+WYnEgJS4Q5ZYaR/6JqKP4oXD06julJkxpapgRmkoVIES9KBaJUsfwH
         fPql6iSb26m5XV2XxSd1x527uHgAJJVUqb+3J1DcXRQAcyq5xDpNxoIE5j/t3h24+dLX
         2irg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770165060; x=1770769860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        b=ksKfeZM0L6fH1SMAjLZ4bLzJx7Po7MNR9YzSM3OsQQWRKXSdACfLtZiVPA6WgGfzPH
         6WsGze8SXckbNdxNIorC76LwpC6bWDhmndD2w82nq0xodbWRnzSFol7KNmhNVNE5L921
         JmGpl4Ueaj81Xk9jkjbEDaY/qiDoDDiDoS0KCct5PXIRKJSmTqU79uO8E8zxUjMbaxwI
         NXUZc6DKVMCVcZcKbrORTLUCjHtEkY4ljbv9S0Xr95R2LCODQGI+Iey+zZlGaDbWd9Mb
         z7xFXDKnJQJjixNE9z+7r+FkFmDsoQbUfbowov3ts/6AQ0bQhtoJvjHDqdm3Xk9sx3r6
         wPAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVnpjlXfciS0hpZIWIdJ17nDI/DfvOwytc0jTJLWBQt6C4Z7X9T6W7pMLes533Zs6aTSU33qFTUA==@kvack.org
X-Gm-Message-State: AOJu0Yxc292lWke3rXGkp4MIbFezdrLFbGC8+KSXrr84fhGtKd1E/0/F
	xbDcxwuJ4yXQqW5u2NAGcPvfnBcxjDm1FWKIjhejipO156nlRCQwd8g1lVM8qyYNyO9tqhQnVvo
	AFH5klrSEk43axINfQCqhlYvmxxMjkog=
X-Gm-Gg: AZuq6aKzs8fYkCN3Y2oleX6tcjFNcz7jsDl3ZfstcL0t8YGK5BRW86hilYOCbm/eo2s
	wD+n2gUGss8MToe1ZAKNMeELGp+FLiN5Ts330vSQQvtEYy+XHZECATZmy8ZSShjYIZ7r0OvBv5Q
	kgDz4jQY76HOfp6YhHXS2YPGZ6P701OfUqN2J2wJ6DmIFQojswBi+WbRJlq2aVCSKVwUwoQunBh
	T2WpXvs+UroQItaSTFYgIjtK4CI9JkPg+3LkZLBJxP7YZfHJkHyXXM26zbUKJVnjOgwZhXYju4I
	Ynpx7RAGjb6NQQsa+QUKIOrC7wzgrV2FbEVXqsud6sA=
X-Received: by 2002:a05:600c:608a:b0:480:1c2f:b003 with SMTP id
 5b1f17b1804b1-4830e98607dmr15919085e9.20.1770165059835; Tue, 03 Feb 2026
 16:30:59 -0800 (PST)
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Feb 2026 16:30:48 -0800
X-Gm-Features: AZwV_QinecwTwjS7ZtoR1qbAef5xnGG7aR5i9DJ793lYmiWYAme_FwqdZZcbA3w
Message-ID: <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
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
X-Rspamd-Queue-Id: 3BDAC160006
X-Stat-Signature: 3jn8f11etyno96tt17d48r9yz7erq915
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770165061-424037
X-HE-Meta: U2FsdGVkX18jhUOEQIGfIUtXSoHJHE80u9+I82/BQq1HlzbXCLgMyJpLC7S1dUZlXPIHy5uQFm0sdz7xPusv3wpK9hiivvyLQevD9f3zsIzoMHsreKoD6Dvl8YsUxcOArSHkPcKN2PJxnvMvN/07a1BYszfEV4cYQ/IJ3vvT9Y2pOizd77QNjghv6dhgPdeMb4JRFlKLu23cpXE5ZaBM8MMlwsKpjkzJonSAYtSoiHs5v01SVbj5LgOZ4XtZ5bAq8XrsIVZI+3LYheM4H1euNSYUDMnJC3500wTrJ9C2KGUIC4gX0CvKId3EYcJuq/yiiAiU4VvNs9pKXu1YyjvAlsWTdhfl8U6jjUz/l3tyKCu9YrPrY2oSzUFGISEFB/rEEfK/fxgMbisQGjT5jYVhowuWnRRCv05oJQZsNgEADE32yP1CNYr8Z1h4GzwPfMPwEn+s/7l3nar+U/e05zJ1/Gpzsu/q4URoccoG/c9BjakiCOh14G8FtKKOPGSlZf6jDjqLu823FcuEQb671zE9dIIEmljD30XfD0vVbZj5o00P/lDS/hfnFa4yHuicnotZeuz3hTMJCt3RoDRtX6VHkhWMIKZHWMTgiX/VEKRIRtXbsLxSpIaj1TbJJHl4rr/rCLXZWP9iz+FXX2mlziZ4w7AhYdKnMlQQh3DNJsbnn/lGRULJ0lClo5KnshrFyIfoya/6VFoLt3GufpRxQRvFCLS4XETNsDNAirhwr1oN8sImd+g5MBqmi00WwByUDmBYvGL9csbR1xxn8+v4hkrYvZjgtzOw+sf5zEyEo3kEw0XAScfV26pT8V3bnT1mWajKGHeyT2o7LJR9jm3FC5qAPLj78BnCNkR7kUvDlaNksWOF+ijQJw2bBJyyRtMlrNBwim0enmoDQvezoDlZsLf2iOTBPVXTphHEgQ4YqfeCqkryTiikBPrMtqKyPu+eHqG3dMOrNzyeJJGlBTwGpXz
 APum5P8F
 BnMvSZ1ZfNFRcH+AbKgxwV9o8XyiAXrax2Fw3KqS4eokgSnZTC5J6VTEeNbET1LQJLiwY4tRz9fBr5+EyuFVfP/mGUpD/M8Dyi3JMl0HC5YrxipyTjo41rM2PjblT4/G7KOpcDLGTXixQhYukX1d5Qk3oJFJlhPjR6MghZ3Svg9R5yuWGjxkEQUAJeOrdtCDxM47pbpjoOu30OkjRg4+Asnd1CUthPeTJ9v7a1j8LklMpX0bxGL9/hyC6MPAI5PHsBr8vmBYMwovOsHNSbroHQNPJZs8i0a3ikJPQSXBQE2PYutb3N2GQZXrZpdzte5qng6oq/Ix032bZyzzjJPHd1YkpKA7BH1mg9rFesoqmyk5yQLqhJee51XrBlxoYyObitqRZVdiY4y723TuofoYovOEE/v3WzZi9dFOEhxeKQaKgmCqH10JFmr2bCdPrbX8Sj9+vbFFwx38oTBEK1o8eFMhur1MBqlo64evUkyQWdd9K7gZDN/jJ7AXIaX93S3NbfpxRAfBVrcacRUe5aey54ML2l/Qzm1shQc0+Sv6Dmx6L3U4=
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
>
> Architectural considerations for the zswap batching framework:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> We have designed the zswap batching framework to be
> hardware-agnostic. It has no dependencies on Intel-specific features and
> can be leveraged by any hardware accelerator or software-based
> compressor. In other words, the framework is open and inclusive by
> design.
>
> Potential future clients of the batching framework:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> This patch-series demonstrates the performance benefits of compression
> batching when used in zswap_store() of large folios. Compression
> batching can be used for other use cases such as batching compression in
> zram, batch compression of different folios during reclaim, kcompressd,
> file systems, etc. Decompression batching can be used to improve
> efficiency of zswap writeback (Thanks Nhat for this idea), batching
> decompressions in zram, etc.
>
> Experiments with kernel_compilation "allmodconfig" that combine zswap
> compress batching, folio reclaim batching, and writeback batching show
> that 0 pages are written back with deflate-iaa and zstd. For comparison,
> the baselines for these compressors see 200K-800K pages written to disk.
> Reclaim batching relieves memory pressure faster than reclaiming one
> folio at a time, hence alleviates the need to scan slab memory for
> writeback.
>
> [1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#=
m99aea2ce3d284e6c5a3253061d97b08c4752a798
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 260 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 190 insertions(+), 70 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6a22add63220..399112af2c54 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
>         struct acomp_req *req;
>         struct crypto_wait wait;
>         u8 **buffers;
> +       struct sg_table *sg_table;
>         struct mutex mutex;
>  };
>
> @@ -272,6 +273,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ct=
x *acomp_ctx, u8 nr_buffers)
>                         kfree(acomp_ctx->buffers[i]);
>                 kfree(acomp_ctx->buffers);
>         }
> +
> +       if (acomp_ctx->sg_table) {
> +               sg_free_table(acomp_ctx->sg_table);
> +               kfree(acomp_ctx->sg_table);
> +       }
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -834,6 +840,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>         int nid =3D cpu_to_node(cpu);
> +       struct scatterlist *sg;
>         int ret =3D -ENOMEM;
>         u8 i;
>
> @@ -880,6 +887,22 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>                         goto fail;
>         }
>
> +       acomp_ctx->sg_table =3D kmalloc(sizeof(*acomp_ctx->sg_table),
> +                                       GFP_KERNEL);
> +       if (!acomp_ctx->sg_table)
> +               goto fail;
> +
> +       if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
> +                          GFP_KERNEL))
> +               goto fail;
> +
> +       /*
> +        * Statically map the per-CPU destination buffers to the per-CPU
> +        * SG lists.
> +        */
> +       for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size,=
 i)
> +               sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
> +
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> @@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
>         return ret;
>  }
>
> -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -                          struct zswap_pool *pool, bool wb_enabled)
> +/*
> + * zswap_compress() batching implementation for sequential and batching
> + * compressors.
> + *
> + * Description:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * Compress multiple @nr_pages in @folio starting from the @folio_start =
index in
> + * batches of @nr_batch_pages.
> + *
> + * It is assumed that @nr_pages <=3D ZSWAP_MAX_BATCH_SIZE. zswap_store()=
 makes
> + * sure of this by design and zswap_store_pages() warns if this is not t=
rue.
> + *
> + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor =
does not
> + * support batching.
> + *
> + * If @nr_batch_pages is 1, each page is processed sequentially.
> + *
> + * If @nr_batch_pages is > 1, compression batching is invoked within
> + * the algorithm's driver, except if @nr_pages is 1: if so, the driver c=
an
> + * choose to call it's sequential/non-batching compress routine.

Hmm, I'm a bit confused by this documentation.

Why is there extra explanation about nr_batch_pages > 1 and nr_pages
=3D=3D 1? That cannot happen, no?

nr_batch_pages is already determined by the time we enter
zswap_compress() (the computation is done at its callsite, and already
takes into account nr_pages, since it is the min of nr_pages, and the
compressor batch size).

I find this batching (for store), then sub-batching (for compression),
confusing, even if I understand it's to maintain/improve performance
for the software compressors... It makes indices in zswap_compress()
very convoluted.

Yosry and Johannes - any thoughts on this?

> + *
> + * In both cases, if all compressions are successful, the compressed buf=
fers
> + * are stored in zsmalloc.
> + *
> + * Design notes for batching compressors:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * Traversing SG lists when @nr_batch_pages is > 1 is expensive, and
> + * impacts batching performance if repeated:
> + *   - to map destination buffers to each SG list in @acomp_ctx->sg_tabl=
e.
> + *   - to initialize each output @sg->length to PAGE_SIZE.
> + *
> + * Design choices made to optimize batching with SG lists:
> + *
> + * 1) The source folio pages in the batch are directly submitted to
> + *    crypto_acomp via acomp_request_set_src_folio().
> + *
> + * 2) The per-CPU @acomp_ctx->sg_table scatterlists are statically mappe=
d
> + *    to the per-CPU dst @buffers at pool creation time.
> + *
> + * 3) zswap_compress() sets the output SG list length to PAGE_SIZE for
> + *    non-batching compressors. The batching compressor's driver should =
do this
> + *    as part of iterating through the dst SG lists for batch compressio=
n setup.
> + *
> + * Considerations for non-batching and batching compressors:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * For each output SG list in @acomp_ctx->req->sg_table->sgl, the @sg->l=
ength
> + * should be set to either the page's compressed length (success), or it=
's
> + * compression error value.
> + */
> +static bool zswap_compress(struct folio *folio,
> +                          long folio_start,
> +                          u8 nr_pages,
> +                          u8 nr_batch_pages,
> +                          struct zswap_entry *entries[],
> +                          struct zs_pool *zs_pool,
> +                          struct crypto_acomp_ctx *acomp_ctx,
> +                          int nid,
> +                          bool wb_enabled)
>  {
> -       struct crypto_acomp_ctx *acomp_ctx;
> -       struct scatterlist input, output;
> -       int comp_ret =3D 0, alloc_ret =3D 0;
> -       unsigned int dlen =3D PAGE_SIZE;
> +       gfp_t gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_=
MOVABLE;
> +       unsigned int slen =3D nr_batch_pages * PAGE_SIZE;
> +       u8 batch_start, batch_iter, compr_batch_size_iter;
> +       struct scatterlist *sg;
>         unsigned long handle;
> -       gfp_t gfp;
> -       u8 *dst;
> -       bool mapped =3D false;
> -
> -       acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> -       mutex_lock(&acomp_ctx->mutex);
> -
> -       dst =3D acomp_ctx->buffers[0];
> -       sg_init_table(&input, 1);
> -       sg_set_page(&input, page, PAGE_SIZE, 0);
> -
> -       sg_init_one(&output, dst, PAGE_SIZE);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       int err, dlen;
> +       void *dst;
>
>         /*
> -        * it maybe looks a little bit silly that we send an asynchronous=
 request,
> -        * then wait for its completion synchronously. This makes the pro=
cess look
> -        * synchronous in fact.
> -        * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> -        * acomp instance, then get those requests done simultaneously. b=
ut in this
> -        * case, zswap actually does store and load page by page, there i=
s no
> -        * existing method to send the second page before the first page =
is done
> -        * in one thread doing zswap.
> -        * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> +        * Locking the acomp_ctx mutex once per store batch results in be=
tter
> +        * performance as compared to locking per compress batch.
>          */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> +       mutex_lock(&acomp_ctx->mutex);
>
>         /*
> -        * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> -        * save the content as is without a compression, to keep the LRU =
order
> -        * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> -        * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> -        * to the active LRU list in the case.
> +        * Compress the @nr_pages in @folio starting at index @folio_star=
t
> +        * in batches of @nr_batch_pages.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> -               if (!wb_enabled) {
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> -                       goto unlock;
> -               }
> -               comp_ret =3D 0;
> -               dlen =3D PAGE_SIZE;
> -               dst =3D kmap_local_page(page);
> -               mapped =3D true;
> -       }
> +       for (batch_start =3D 0; batch_start < nr_pages;
> +            batch_start +=3D nr_batch_pages) {
> +               /*
> +                * Send @nr_batch_pages to crypto_acomp for compression:
> +                *
> +                * These pages are in @folio's range of indices in the in=
terval
> +                *     [@folio_start + @batch_start,
> +                *      @folio_start + @batch_start + @nr_batch_pages).
> +                *
> +                * @slen indicates the total source length bytes for @nr_=
batch_pages.
> +                *
> +                * The pool's compressor batch size is at least @nr_batch=
_pages,
> +                * hence the acomp_ctx has at least @nr_batch_pages dst @=
buffers.
> +                */
> +               acomp_request_set_src_folio(acomp_ctx->req, folio,
> +                                           (folio_start + batch_start) *=
 PAGE_SIZE,
> +                                           slen);
> +
> +               acomp_ctx->sg_table->sgl->length =3D slen;
> +
> +               acomp_request_set_dst_sg(acomp_ctx->req,
> +                                        acomp_ctx->sg_table->sgl,
> +                                        slen);
> +
> +               err =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->=
req),
> +                                     &acomp_ctx->wait);
> +
> +               /*
> +                * If a page cannot be compressed into a size smaller tha=
n
> +                * PAGE_SIZE, save the content as is without a compressio=
n, to
> +                * keep the LRU order of writebacks.  If writeback is dis=
abled,
> +                * reject the page since it only adds metadata overhead.
> +                * swap_writeout() will put the page back to the active L=
RU list
> +                * in the case.
> +                *
> +                * It is assumed that any compressor that sets the output=
 length
> +                * to 0 or a value >=3D PAGE_SIZE will also return a nega=
tive
> +                * error status in @err; i.e, will not return a successfu=
l
> +                * compression status in @err in this case.
> +                */
> +               if (unlikely(err && !wb_enabled))
> +                       goto compress_error;
> +
> +               for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +                           compr_batch_size_iter) {
> +                       batch_iter =3D batch_start + compr_batch_size_ite=
r;
> +                       dst =3D acomp_ctx->buffers[compr_batch_size_iter]=
;
> +                       dlen =3D sg->length;
> +
> +                       if (dlen < 0) {
> +                               dlen =3D PAGE_SIZE;
> +                               dst =3D kmap_local_page(folio_page(folio,
> +                                                     folio_start + batch=
_iter));
> +                       }
> +
> +                       handle =3D zs_malloc(zs_pool, dlen, gfp, nid);
> +
> +                       if (unlikely(IS_ERR_VALUE(handle))) {
> +                               if (PTR_ERR((void *)handle) =3D=3D -ENOSP=
C)
> +                                       zswap_reject_compress_poor++;
> +                               else
> +                                       zswap_reject_alloc_fail++;
>
> -       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> -       handle =3D zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page))=
;
> -       if (IS_ERR_VALUE(handle)) {
> -               alloc_ret =3D PTR_ERR((void *)handle);
> -               goto unlock;
> +                               goto err_unlock;
> +                       }
> +
> +                       zs_obj_write(zs_pool, handle, dst, dlen);
> +                       entries[batch_iter]->handle =3D handle;
> +                       entries[batch_iter]->length =3D dlen;
> +                       if (dst !=3D acomp_ctx->buffers[compr_batch_size_=
iter])
> +                               kunmap_local(dst);
> +               }
>         }
>
> -       zs_obj_write(pool->zs_pool, handle, dst, dlen);
> -       entry->handle =3D handle;
> -       entry->length =3D dlen;
> +       mutex_unlock(&acomp_ctx->mutex);
> +       return true;
>
> -unlock:
> -       if (mapped)
> -               kunmap_local(dst);
> -       if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> -               zswap_reject_compress_poor++;
> -       else if (comp_ret)
> -               zswap_reject_compress_fail++;
> -       else if (alloc_ret)
> -               zswap_reject_alloc_fail++;
> +compress_error:
> +       for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +                   compr_batch_size_iter) {
> +               if ((int)sg->length < 0) {
> +                       if ((int)sg->length =3D=3D -ENOSPC)
> +                               zswap_reject_compress_poor++;
> +                       else
> +                               zswap_reject_compress_fail++;
> +               }
> +       }
>
> +err_unlock:
>         mutex_unlock(&acomp_ctx->mutex);
> -       return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> +       return false;
>  }
>
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
> @@ -1499,12 +1615,16 @@ static bool zswap_store_pages(struct folio *folio=
,
>                 INIT_LIST_HEAD(&entries[i]->lru);
>         }
>
> -       for (i =3D 0; i < nr_pages; ++i) {
> -               struct page *page =3D folio_page(folio, start + i);
> -
> -               if (!zswap_compress(page, entries[i], pool, wb_enabled))
> -                       goto store_pages_failed;
> -       }
> +       if (unlikely(!zswap_compress(folio,
> +                                    start,
> +                                    nr_pages,
> +                                    min(nr_pages, pool->compr_batch_size=
),

Hmm this is a bit confusing. There seems to be multiples kinds of "batch si=
ze".

Am I understanding this correctly:

zswap_store(folio)
    -> zswap_store_pages() - handle a batch of nr_pages from start to
end (exclusive)
        -> zswap_compress() - compress a batch of
min(compr_batch_size, nr_pages)

where:
* compr_batch_size is the batch size prescribed by compressor (1 for
zstd, potentially more for IAA).
* nr_pages is the "store batch size", which can be more than 1, even
for zstd (to take advantage of cache locality in zswap_store_pages).

> +                                    entries,
> +                                    pool->zs_pool,
> +                                    acomp_ctx,
> +                                    nid,
> +                                    wb_enabled)))
> +               goto store_pages_failed;
>
>         for (i =3D 0; i < nr_pages; ++i) {
>                 struct zswap_entry *old, *entry =3D entries[i];
> --
> 2.27.0
>

The rest looks OK to me, but 80% of this patch is using the new crypto
API, so I'll wait for Herbert's Acked on the first half of the patch
series :)

