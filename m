Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FD51088E42
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798166B0345; Wed, 18 Mar 2026 18:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749B46B0346; Wed, 18 Mar 2026 18:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F726B0347; Wed, 18 Mar 2026 18:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 570766B0345
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:06:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D68421394DF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:06:32 +0000 (UTC)
X-FDA: 84560568624.27.1D3E261
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06FF14000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:06:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gP1Ojk9L;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773871591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFK4lKP7mEQHuFtvHtTgGVQETDhDWMoRtUuT1efy7+U=;
	b=Hr1ONmjmKbkUvdhvOGIcDWWn1vBfoSrP7OCq9ZPyjItUa5XvvG/x5dphh5DL7Ach75I3T0
	j24maUsB8Ifm88tyjUlh8Of9+AmQRkY5HFMvjD/GVMCP/oGq90B7Hv3XTV6Eyb+/no2m30
	GAnZvThwOCiR3Jl1DxvZpxNz7bTr5DU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gP1Ojk9L;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773871591; a=rsa-sha256;
	cv=none;
	b=hEoost445JnuS6e4kOIchqnZdScZYoP2dkOiBn+OdbAfMjPBxYWSo3Hzx28MGaA9kCf509
	GSqWB6xYdvjp1Dop4sF+X/jmeUvhDHG2vpoyPkeal7LJTdKwxoLohQ75+RtJchI6qC6vcp
	crVo3PNmt36VBIWBw5kqdynIm0RHrLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E16260121
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8662C19424
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773871589;
	bh=cFK4lKP7mEQHuFtvHtTgGVQETDhDWMoRtUuT1efy7+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gP1Ojk9LpR65XHB+N8M8oRoxDHmaEJ3r/flwNjatVKR2bQFZdBzKG7McD6k/gHceO
	 T34OOqjq78obCmaNS+S+NEXOSey5xRUPQ2jQyM4ZvBroIvxhNQ0BQm+7f59P3+/S9w
	 L/hhmYgJ1+WxoITfoyhmBjXmIhNSXD71QpP4ex+sqLB3+W8f+EKIMFsvo17hcE0v5B
	 p6OJeqKJEjbUpnfeL/a4I1gbJFkxl0i7KkgIn4v43UHCLuCmeWk9ZoFLNW/X2WA2vO
	 g1SjvHR9R82h9DNSuIXuqKLRWnQamTkZgTdbsmyFnZxWQq3OGhc2V1ePfIYfcSu0f6
	 8backj+9upotQ==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6652452d94aso671674a12.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:06:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMPSiU0UwVO7/pDNkQhm1VZTp79NPy5WtqNsA91PR1jKW4ZQP/qDKY0sICGqF/N8pL9mnKyk/ynQ==@kvack.org
X-Gm-Message-State: AOJu0YwtiZnb4vC8l/dIWUBFhwOJnhG38tR9bBioEXoswep0wqoDbuoT
	zo0IvWfZXV6CO+H6RY2N2GZAmc4fiE0B3rvt7skSv8k3uW32ka1qf8PDPTagCxonp2kD61TTopl
	88NLHEa/xmUTp8JPgzMrt3bQPJIEcmxM=
X-Received: by 2002:a17:907:8dcd:b0:b83:95ca:589b with SMTP id
 a640c23a62f3a-b97f48bb814mr321477366b.10.1773871588721; Wed, 18 Mar 2026
 15:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <absRz4U_IMk0ofxl@google.com> <20260318215629.2849052-1-bingjiao@google.com>
In-Reply-To: <20260318215629.2849052-1-bingjiao@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 18 Mar 2026 15:06:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPL280HjM=LxRgKN7ChN-_aQk8Vaz_07NDY=XLCH+V-Lg@mail.gmail.com>
X-Gm-Features: AaiRm52IjfioOvk3BGqHIFAwmrD--TIsnh06TQDXNhYfJ9e9PpW9-OOH3NLiEKI
Message-ID: <CAO9r8zPL280HjM=LxRgKN7ChN-_aQk8Vaz_07NDY=XLCH+V-Lg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	rientjes@google.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, youngjun.park@lge.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 06FF14000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 553zjdxdwhwwqjofutcx9ckeswsgp6nf
X-Rspam-User: 
X-HE-Tag: 1773871590-472488
X-HE-Meta: U2FsdGVkX19DNG4dribKelXJk5fYTZkefkNPySYBGTig6fkLEbT68lReHs293eMr4gzau9LRvAazIj0RzOvGshVzSfD489aMI0Rhp8U/iezhIm4/rSDftpPYsCiH0IzE7M0LwWZHOXpTnazYWmobB+ilr2dvlywxoP7w4iwg6fxEJIS1yPkZzX/IZWlWkvowxqfLcNhEeHHqBl+X486crAa3QFzjukHIlOb7Z3B1LFjc0Lk8LkwQlO0PBsJS3fx0kJzl2DkMcYpAW7t/9TgtwlegvV+VmN6HA5FSB74lX01M2HXRltp2McpCuWk9W1RtagOgyuMGu5TRGk8P3ST/OKTmAxu0QUTK8Mm7BUuKxJTCSVavEO/t7ekfPP2yM6AQdXy5BgjWouuyu1UDhQ8rl0dBHSwRqxeSVrdL4qIP0cq8ZDIspqVlATS7DI5Ds8F606MZSnZYJpmdMPciL2CVsYt/PEC+NxUYZCFL5GwpHqxtl/oa2WAvWgymY8s6NY9JP2EkYo8jJoZbanZ9SU2XtZjgQvHidRsb3zVbAaY4ixdegEPOsZ1KpxhSg2uIHDpw7XrB+jVTD+3mvYyxiBx5flai84om7cc5kTJnU29b60h8o7abNRWmG/34kLKwUy0KpaHGa6qgixlWJm9T2e1130gjUwVFxKLZRFLk9sFaDyMctULygkghMFc+xYVnyg5pirQSumdVouu+QQoJHtdkzS/WbrRE8pwCaPJV8ylLtjZDwbWBQVExVHnODyIUy1I8Rr73Go0vQUFAk+ef9NWsfmlxBCnLAdOLbbOmziWC8UpiUJ0d9+GYd2eXZ52F9kVrFsusV/mP5ARqKA2eVzrgjUBU0s3gIb+gdQ5I4U7VRnWQPAUoyS0K8GmXN9a0Ncy60amG9bOH/0nkxYCs4OEev88GVR2xMdE4Y3z6Ac0xLWH2a7FGAh7kDfkPYqB5mc8ZZhAVDiRhFdimQrlfFjJ
 x1UCtoos
 HLhZ6KatmhcUpJ//8H4Uhn0ozZ1hzicx2Bg4mKI9uRh5j3/BBdWD5w2bgnzRF8cV671bVo8k4XufwSNUA2dD98OATwuJ/A1JVU3Et41N3Y8B4OAoLRIw64Mfmb4W7cjja6Ow8AZ98IIeEHH8Mksj5GEaKgtDGAbI4Z+jeFN/Wqc+6e3ZIZ50KLIpsGdbZYPGZqFuyDHFcDysQrdOKxwThG11IQB8ksj1S+NjvC1Ig5WUTFGiNWNPx9EDpSEqO9Gjg8RvlxdF4Q0ojHpq+nGVg5d0LRwauEup4jF+pCicZ2MxFWSOEjD1wjgxQTpPvLUCDBVhhNIvGljcSAIuCzatdbNJz9KzWXD4jQQXphmU8ymRQ5b3bQL8g5VUUE8q8l/I8SWU+avYdvNfDIuxvjv1A9zpWPYkYhRCOxNDnXX+MnClM9Mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 2:56=E2=80=AFPM Bing Jiao <bingjiao@google.com> wro=
te:
>
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
>
> This leads to incorrect reclaim behavior. Specifically,
> MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> is reached. After reclaimation attemps, a subsequent retry may
> successfully charge memcg->memsw but fail on the memcg->memory charge.
> In this case, swapping should be permitted, but the carried-over state
> prevents it.
>
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
>
> Fixes: 73b73bac90d9 ("mm: vmpressure: don't count proactive reclaim in vm=
pressure")

The Fixes tag is still wrong, see my previous reply.

