Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE84AC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B5D6B008A; Fri, 24 Jul 2026 14:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C866B008C; Fri, 24 Jul 2026 14:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCDC6B0092; Fri, 24 Jul 2026 14:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44F176B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:37:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B95EC120118
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:37:24 +0000 (UTC)
X-FDA: 85024528008.16.81D806D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEB3B140010
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:37:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hpmiRnuU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784918242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xedh6KNk2EDOFluQ+qo8w16I8eWpP1wETZBFHf4d8jo=;
	b=bDf1LYB81iLVKysS7q/GSgmGTmzDKMp/I+XdATAvbg2ZkM7uOL/f/cBE+Gva1IfghnzBOl
	u/NY1tgBF9puG+E6Spag2w1Eky1vfKtwWcojwAX9349K1esRe9FObTcI53TiPDzdNhbhgP
	akYqkY8RD1nWyCjzYx2yzDrtvwqdy5s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hpmiRnuU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784918242;
	b=FgvFGx1HLerZViTEj7lQsdvNpwEsenxREn633vUcUqkLuceV4530iDsAky4jqNeRXnLiUX
	0fqKMEDXu+WEAMA8uxCc+jAXz8h3XBCWYkpY7cXED/NY+hZWLOyoRkmqZUn4OtsRucd3XA
	ysKaatMOi7u636ivhBTeGFMkC4lvRSk=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954c0833b4so6439365e9.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784918241; cv=none;
        d=google.com; s=arc-20260327;
        b=SlYrki9yeuMVi0EYdOveqmIghZ2VNfZkZ3cKW+QGDDiHu/19+OLrM7r7F/eg948VkM
         aZxy0dHH59K7F9gIu9A2xX+hCqi3AlmCMsPsmcvB6qPinyMXry7HHCQNBzTGkDZ1dU0s
         YDzncb5vwB8b68wNeScrwfRR5Re5/Kk+PP2uTFapccfdT+tGiDxvn+E7PorNLplc4iHl
         XNHJ60jwPUGkF9rSAAq5XhEZljhSWU9/Fp7zN1OFunYdha8RWL50muJgHn9WurPq0Kez
         ShFPaoWpTESGdTq0zb+1nWMNwTAPDpXTSxO7HsOi48QJkMKNTPTtplfbuzagx3TtcT2f
         pxgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xedh6KNk2EDOFluQ+qo8w16I8eWpP1wETZBFHf4d8jo=;
        fh=dRAbb5KxU3LMNgQ1Askv5R86OpoIPoqXCeHJtmrRKbA=;
        b=hl+BNMeQTAb5xUZjTVlUUQvu/dZGij3ZAZ4b3xGB1LVD7E9hKsss+smaDXV6FBdOXV
         YP+d9A5qriOQiqVSNxbildKRQwuzwJWgA4B3Gg9bJ6Od9HeBfrcSiG9DUnaLeDmKGbE0
         b4/HWnK9CYXyy5OHt8hB10wiVD4nH+5SfoxKNA3AfsUJ6cDmk0iFIVXhWNVf0GvBM8Ab
         yFwPMaW2ZwncU4kXeZ2EuUDatIl73cYtAO35TOWmoUvOWx4aSLfN5kLLphVfKsrqfsr+
         Brj65YH4O2nKC1VsIbcEcl/xG2qTDzJH1VzFoX5p4An/zyB67KRwckjDU3La0WF+WK/r
         QTLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784918241; x=1785523041; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xedh6KNk2EDOFluQ+qo8w16I8eWpP1wETZBFHf4d8jo=;
        b=hpmiRnuUA4iQCy8Jl97hTxMVRyW60YC6ppwyTgrbMye5FBR8m1RKYr1tUiVRQBLNFL
         a4TiLaD42bsrt1K6GtZVd4PQYvRWRHVrMUOicfEJZndHHmUmTlXJ787wyFllzgLc4vos
         A2bxG3N6hgqLP4k2PK6+VXdUVmMI3nRtn5Vqkb429vWTqE/PdPl4tXiK3NJ+VwQ9aDLF
         L4mFH0q/XEVL2fhz4Wy1UrLIJbUEqXTb5ugBQS4KeQlBvJeQS6RhuSsLcgafidRdh7F4
         IIc7bKSI3Bp+lEW5Prj0SuCocVBBYfZNpVbf0bVtCTrf4CL3T1gRQrcLWABFcX7HlLAA
         yc0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784918241; x=1785523041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xedh6KNk2EDOFluQ+qo8w16I8eWpP1wETZBFHf4d8jo=;
        b=tSlecEVKbPcDqegyC1zJvtSI/CCH3YQhOrOPrA28ahSiLeDXwcQqx7+dTFKhdRPUpF
         bpLgKmzJ9gJlJPkZXomFnm7NoPve6f7+u1cHTNUz4FWkQ88PzKy2xCKf4G/Yd929MtrB
         oVnULuzElyIGYk+yfu0HgoXLwWRCI+plSy8f3Xrjv7OULU1TzavBOUSpjAmLdG0QmgZd
         a5zgOPI+xoRZKyEw1q4t3beGjgpkXyfnLzu5PS6cwl2t8/tuUAOc+19F3Oe8FPLbfbd+
         ul5iiSzzvh263dW074nZAGoS9qwc/zunmzQ3WE5yUfPQkbr9ShxBSZdsl3sPu9a1vxiV
         SUXg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1mcqvPBkmk/okY3E7l5wzeWak0TRh9InXcwIFS+KKqesRWamRdYtG6Y6PbTXqvE0rBXSJloVOtg==@kvack.org
X-Gm-Message-State: AOJu0Yyl881eubXpsVMe9BmyzPXQIK70M3sr9/uHQV29G3E3SsK4EEiK
	mixveHDtEBtunQZxaEtG4fLw0WePKAExu76DIwYCXN9eyV1Juj14MIfSE6IEQwhmBVzvcqi4++G
	0e9kZ6jrKiDA8ntY5BXuk7N2x4NUVmdY=
X-Gm-Gg: AR+sD12sTreLfL5nt3rKivYkHuCb4lPfwYhOKKhxaEQXoZJASJ873HYljCjx97hcPtz
	Lcyu3ya0hbSkDHHDzWvrMCPKnXkLiz9EacHQESN2wID4sV9q8qXzBOJ/nQ/8GF16Ho98OMpRMPM
	f2arPr9A4P8/Ku4ytL+aLGgAs7o9begC1fjPI0q6tbfGUQIBTp7NmP/pcpVl44UIzFUoKFBUFVZ
	6bUxpF+sigGk6sMaO7P4+vPP7k2V9d6vzW7VPKBdviK79UjJxeNrZxgtv2Umeejp+3TeW90TaCs
	KveApxbk9SA4QfGYsA==
X-Received: by 2002:a7b:c309:0:b0:493:f6f0:d66b with SMTP id
 5b1f17b1804b1-49573cc2eabmr81103425e9.1.1784918240966; Fri, 24 Jul 2026
 11:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
In-Reply-To: <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 24 Jul 2026 11:37:09 -0700
X-Gm-Features: AUfX_mzApVYg8xjBBKKP9ECVkPTdBjH-zV4-LOXVUdYxXRJlmVsGVskdKCUZFSk
Message-ID: <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BEB3B140010
X-Stat-Signature: ta5dd8dfurrishjezfr3ynmjoufh145w
X-HE-Tag: 1784918242-154997
X-HE-Meta: U2FsdGVkX18mCm4h48Os8XGIqgBUrRNazLjmr3aE/I1Fw3KhE/yiiOarJl7F+RN+daTNF01pBhroUuykKAf01jFlB/i0A8LUyUCqIf0vUDMvjFyF1sF2MLJc7X9SprLXGPu8cRIwq5pIfCgU6SYnpiGQzSsLndOI6gwUMuqKKiyN1kG/X/0Z84le4t7xKXQ7aH0k2KQA938gF7ZXumHSKTodo6Fh5Ag0fX0SNGalSKaV5OWkaZHTpDUDHb86IkFlR6rv01+MWfgdsbIlQad1tlHS3nKtacoGqe7HnPBYYCdb5MeVp66rBIGJwRev7jzDbSdjUfdGYsMAryOkaBFwTAyJ7S90/MUajtodebN96OjHhXPt/5Y2wESmqIjpEnuifmrWD9qlXQM40WHZHr1CY64cBrcazA6g/AYuQ3be2v3TqtlZjkbnsdq4r3+0PDGdpwVtfMoIHB2cakdXUPXnJph3nw8jCkCAPaV6O4cMgOV83ECImdbjSjEXLtN7yeAp1VU/yaOEhHbpRqMt/xcGBcubIXiRBsWD5deFyk87O6H7dSXAN/9DAsocrpW9wPijEv/PsMFq9LS+W8lvQpa24kog4jHuZ1kVNcoMxo3eASViuGkdNdGeg+zD23xGK7mJSLrwcevRsYabCX1AsJj9aZZgnzIztnxUxR/+Brea1qx3YDUlHCAOQp1VS2wOte5o7YN7HXkCNklJ5ZdkcrMHmfBrsUUDnnSGMp9lhAYzhXZ7+joAKS2TW5DgQyjOWRwLcq11vpT2eugspL+7rCZr/29icKKITJrgg+wnG97LbQjEcNKk+6FM0LBQaM5qPKP857pcjHIt6mWLftW0ipmYH3UCQcmcqSThPoQsuyApWsjX8bNsLVZtOjXkoZujUJRe9RWv1Yaj5MUAKq3pQQGIacdRAnN1+E4FkeiMvi2v+haXDC+g1nZ0GXQExLdaJuO+/xDjuRqmrq7GCJ8TMz+
 wZ1lqLiK
 CXOO2gGHQnhHyyviFNLrOAOuudD+gxASjmNJXv6lKYmX21cyaF4VSTBeYNb7RGGFwX1niR2y5qTASeb3lyEituMgOekkmJwoDbh6GF5y28azM9hZMnRcfUCg95vnzjB1jMjKfx/1fCAtF3kszfV2TpGzej+QtjE9pcgNTE89cCaNMz8zeioAGaGpTtSrstAfQ+FGhfoauoGCn8agNxawhmOtzOQLBux4T5nrksxA49g9LZI+4zz48Y27QORCvLnz7ROpAuxi4w0zXY/RBjvaLZlN6LdhORN8wFaYwCw5ClvYuLzEalGan3EGAWwDM5GYnN41gfoZ//DJWfhNG+TaTeaFMHL6A1jI2+6VqDGVwp3U7hk/huCTx+YT0ZnNuoMrqyHxg78Y2LuOrQAbjZtumXVNFtqBtRfW1hWuLSnlfFQQjylOwGZ72A4cZnTkEBlOm7LDCybeKAo6VTcJkMLMD6O2pkryY2RuHGVsFlXbOGBIsvpBfY04i6lrrPmCKent7XBUa+xgoZxjTjAZ7+L+baqvDwsv5giPFfn/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 10:57=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> The numbers generally look good, the store rejection rate is
> decreasing and we are naturally doing more writeback which makes
> sense. The store rejection rate actually increases when the batch size
> increases to 64, maybe aggressive writeback is more likely to fail and
> cause a store rejection, so that also makes sense.
>
> The only part I can't immediately reason about is pswpin. How are we
> reading from physical swap more than we ever wrote to it?

The same page can be swapped out once, and swap in multiple times :)

Unlike zswap, physical swap in is not necessarily exclusive. You load
the page in memory, but if the swapfile is not full, etc. etc. you
don't invalidate the copy of the data on the swapfile. At reclaim
time, we notice the page is not dirty, so we just skip (z)swapout.

