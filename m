Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA39FD45E4
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A626B0089; Wed, 25 Feb 2026 14:53:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4806B008A; Wed, 25 Feb 2026 14:53:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6826B008C; Wed, 25 Feb 2026 14:53:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 283B16B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:53:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCC6D13B2E1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:53:17 +0000 (UTC)
X-FDA: 84484028034.06.1AEF645
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDDF8A000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:53:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vbFdo0jn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772049195; a=rsa-sha256;
	cv=pass;
	b=l8js5ffAPD3Dwy7eo4776ABY/UsStjjU25i2Q9/A7seQTVYyKAh5C7uDl3IvApSmnNFdlY
	BbUBZnfqhsI0SJLqOXIpYun5i9t/pXJgdr7WQ35B3sXjOUiqaVQmrttRI9SMoHvWLjAqze
	c9Lm42Ta/Y1JhcjPV7CBGeQCcesUAP8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vbFdo0jn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772049195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hACZJJD++mSXl52TK006Yejdc4mpWUq5FI/WaqBAg/g=;
	b=U1kDkH2QyQTXoKxx31f/iXYQOWFbYmIJ9QTcTYw+/kIVABIFG/LzqXD+sVN8ml5co7LLZ1
	q9IER6ixDGBGLeVyMZQwWmpEbkVCfv3vj/tpFwdaeZhSJ3AmGKM6Pto7zCSmntq/3Und4k
	r2Km2ngmLFsPLxgol8jr+RiArcQ/v0I=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48371d2f661so12325e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:53:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772049194; cv=none;
        d=google.com; s=arc-20240605;
        b=P1RpZD/vhDj+/yve5oEfg5TtnB7p9AjM0fWZw4jfMsjYq84fNi0hxR3MdbyXjSYnDY
         zN8TTzITfUbBDifPF+i8ExOEZ1S6AkQC/mzH7ahmXg8iopLGj3uij05O2sfRq87bCEch
         K2yLM5QJmwJsz7cK9VbtgjHkg30QbQlx1ZiOQu1iFKbGMhoXJoGVjjzWS4l7JUW9usiw
         d2CZL7DNGF3IFHwhkHmySSwdAPAw5gkn6I/yj4q943r+9ee5WtRSa1JWZ4JSTdmhFh+d
         LjhcOJI7n1mb2RtAxdczJ2xQGExj4NWzn3Z0pRlDA6CH2hNgpmkYSmx77NoM5YvwKRvn
         2XeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hACZJJD++mSXl52TK006Yejdc4mpWUq5FI/WaqBAg/g=;
        fh=octhpxRr+M+YTXlhyDaGAc/Jl4LXeBgmGICVYNSb6JU=;
        b=O9guyUycLNbO34CqysZNusgLISci27pLhMMsPSAsibhsnNsAfi9Paf7uk/bYnIkAyJ
         AZGsApGIbYln7o9AeAufz9qwfEMb7QpxO1R349xlXga+scncxhO1Y13kchZ5kv/g5ZAY
         Wq0dHoYZqYYFdplLS15hWr2t3iAKqXKUgKSNP3vYSiB/m9CtxdKXJOVa69WjRjTti3nE
         qbMMzjMQYFncNsrMSluSyzOfOt/Qx5JAXfFZt+5kAv+fmKMoW67zAOVgqn29OqLBA4TQ
         DywjqvxKzoRVdeECCrsifF7hmHpgki1J1AwBgD+++o990qumqidHUmUSFQAEcsecKrjq
         4LpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049194; x=1772653994; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hACZJJD++mSXl52TK006Yejdc4mpWUq5FI/WaqBAg/g=;
        b=vbFdo0jniFldgVLy7twWB+ifRmRnyVEVUWiE+R2VUeFnVTd1qMojWHVsIi+Izaa/+G
         4NDIFthpDOonqWDg5B3AEA0WUaqLBKtR/K9zjL3LWW/yI4F86cIg4QGjqqgfmLEOIb+3
         ARirrgILwAUOs6v2mt8AJvd5qt2RMpWu0BhdbrY6R39fs0Z3aenQNdluMmifKsV8Ip1A
         KSVmiNLYmaO+p7IRCY5HEkj/oXJ2U5b44w/c9BhcsnhFzK0aDT5ScLWZW3OSrebR9Iox
         eNWIymLBMIKkDZR2XNjjuO4arzgAZufRGrlMXsMHHGBeLvPwwWLTFF262u8gMY3fpF5x
         xMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049194; x=1772653994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hACZJJD++mSXl52TK006Yejdc4mpWUq5FI/WaqBAg/g=;
        b=gKRY/OPK52RKDfhGCAh2ePID76yZlo8MPYVgR7u4Yh/DSp+S0hvr1eGVCZC01X3XLd
         G9zQB4CbNG3XFRADj29ahm26iELF8nvcZ3vKtrXQU5bskJOdkMSxjhYX9YjTriH1xjQH
         ZVOsVpmGV44SCE62eeF2nCFw7+oIQ99J4t3x+/eaS30d4Ikul0iAML9n/IqUDqvunNnA
         /LJHOnKxCMOVgfOqPPcyvj4cV0A2Cot+p+XhV60aCGa87cwB5CUS+SwjyOaUssvhAbnS
         uptTFMXh7Crl3RmsfCybSBlWJoAt4mtwpRj3Z8Zl7SNnkrTgxtM8bXnKyU4RmCIuYx0q
         Ox4A==
X-Forwarded-Encrypted: i=1; AJvYcCWXFW/EkxMfK6aIHBuq68fFZ2DrLSEUm2fREEMI0TaDcMwtkzzHHDCF8LTXrgK9Ya8Fq0vp3Z+bHQ==@kvack.org
X-Gm-Message-State: AOJu0YwjVjqiF5bEydyaQ/XzPoKwA5s76RaKJfk5dXYd5lfQtUOvrS4u
	aJWlpgKJOkhrmQyuQxBqOpX9iTXYvUxeU0E8cuA2YoN2/plUIPsvFjgeBIBEWhiwE5qJvWXZxWy
	ZvBHKx6Lv3pkoDr9dohkcQHYuNwU4lQkiTobCp+xz
X-Gm-Gg: ATEYQzxHGZqD+YGBAaBl5uZAYSM14bqJbQndycCp227XEbutBGw/MGgbpVOhglzuxce
	cQ1MMlWDtXZXsDA7at2Ml/ggnXDJrWgcy4gcxigNq12CnDGbWtmJjAGHdwW9RAsFRH4TPBL93Tz
	jjgsqQQI5KQLyxBSyhG8+WUWqrbkzih7Q7kppDLJJv/aDjnaBv23i9P45ktxDGrueql9KjOYzsp
	rhtwPTlKTY/NESk162bYw0dxC672lgccozCcbesPE5fJK1/uq+uDTWT3vM03dmhdIuEHglfwf5p
	oe1EtVDpT8XQ0R3RUf0cXP55NAg63jVQSEFxqIwkAClzMx0GVEtvvdoQyUK0ydOBUPkvxQ==
X-Received: by 2002:a05:600c:214:b0:480:683f:743d with SMTP id
 5b1f17b1804b1-483c318c6b5mr64755e9.14.1772049193912; Wed, 25 Feb 2026
 11:53:13 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-5-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-5-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:53:01 -0800
X-Gm-Features: AaiRm53o2gSjT2_weYbg6Rd6sN6ASK7REyXNCnGoEQl1VXmkJdy1tVVm-ZBs7YY
Message-ID: <CABdmKX2KfL6q2nNAkZJ3r-Pp5JPq-sj2VpQp5bU5Hct68bedwg@mail.gmail.com>
Subject: Re: [PATCH 5/7] dma-buf: heaps: Export mem_accounting parameter
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDDF8A000A
X-Stat-Signature: ob1yyawchbz9uty9ec1pgy7sx3in81kb
X-HE-Tag: 1772049195-850277
X-HE-Meta: U2FsdGVkX19ECkkHfS1xmbQHmxDPmNwJAdnNaKQ9PuodQRMJkyuP/DVpj3WmEh32M0tCuliu/eB0WtZu1XRK/xa00i7EDTklkSfVsd1GcUzmhS/V4/15p0sXL/0UTV2Ta/6NplMUSj/hHvigKduccjUEdF2yhpxkjH38GOiuTIZBkKnQPhuTryFVF0GPGxZGDOWHjgJtmQgRgYxiNww2v65LfEy8e0NTL2rXRNETzmHYQcJWtwFEGaOiHLLoqL2t8+M/lKhPmiurU5U/KPThpvLGG6aIXYsvYJLFB0L9cbTZuFkXo/tIh40qG0Jn8o/9dy5QeJ4Kl+Gi416DsM68fvn/XeghYVIzrfWrwUMf48toKglXymbBgDmbkE7PeCj/efBKwYtMOGBUqkpwuHZAier0Qy9vrcVHzEQ4fRAYWElkW5pjemS0f1UJ0WtNTnBA2G8MAn4j1c01OFsuPy4w9cHTO8cNIv4fV9zUE/KXrkP2yz09HR9MnMN1O9cw9tqFHXAo2qD3EssLf05Kz1mtx5s/laz0EvNM0Z4dTBvCHeKfIUGZ0lsyg8ZmYkcJC9kTizsBcsZjCdkCLAddD1ca+Wil5GdP5ut0BPatIHZYcpNYMQbaWlKCqcSDVi8KzmNE/unAkWvSsLY4UTQr8Pg/x7O0jX9wVc1kj8mVreZAMeAlb6N/RJZnZKUtZl7YqVGBM7T8nqU4pmi0as3Xkne2RHpwewXETd+KQeLlxUSkUYVD4YaYuxCjVswkYr7C8D1oGnRyqvMLiY6YVVhHU1zmr1CsuFAEBqoyoOmCpsGJKKK8JT1VR4kb0E/XYBJQ6JCzlrXTnnT7cWhdjXTXI0GGND/dGpgdrDM9rANTGfpdL3vSHPPuVuCzFg19qgWqx93Bcfhg37quF/mges7a4LYh5mUxjtaTBl5Lub10RASHcIip2IudYcwo3oNlWCA0g/74MB2palRLX9tRW1bQbH3
 JmruEYZe
 PqZKqi65WiWsb9XnB8otgsVdG6XgQahyTnoJDWCKUZHgurcXa57wpeFmIbvyNfagdefkwqgTVSlocCBv/bXu9OA9zdX29py1Yj9SIaANBa81GMAKljaE0ItESxWpgRTVMV8pqJ9L6Rvtx1/OqoXl2Muj+SzZO/VPNJ8VAAh1+T+0ejJVrOfTDDzGQTGkvf3L8MWpoPfYlA91FBH69IteWFQKLsriRTmlMMxZJ3+rREhlLjP7eQLZ7a6Ty5aswFL6r93XcCgsLTBAWcCGW1lNBWGHrW4/EKwM7EfUhniMvC9lXR7afexI6pAi4UtNDimEOzJh9585Kw06U+VeAogV/qUuto8ATWtQ0Y24ld8wv5B3d7Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The mem_accounting kernel parameter is used by heaps to know if they
> should account allocations in their respective cgroup controllers.
>
> Since we're going to allow heaps to compile as modules, we need to
> export that variable.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

