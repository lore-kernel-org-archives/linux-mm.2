Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A81ECD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FE36B0005; Wed, 10 Jun 2026 17:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FD16B0088; Wed, 10 Jun 2026 17:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF446B008C; Wed, 10 Jun 2026 17:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3576B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:28:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 256F4A02E4
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:28:04 +0000 (UTC)
X-FDA: 84865290888.17.38AC935
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C8674000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:28:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a29go+UF;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781126882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzwRV5m0lYG2nnm8eCH8HMlLykBf4sYn7ixX7YJrG3E=;
	b=d+9y3G1ZcUkUJdxb2PQ4uTVAVAZhiAEadf3DSNaxXWy82gxI1u42yS4cx/1iQnHyydjb3B
	ByO/UmSbDa+z/ZxxUvxvpCiJxG19OzB4M5SC5AsC51aNByNH0NR5r4u29TkLqYkaG0u4bm
	G9jkuSpsUrKF50lW8aE/dCQHkAkS9oc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781126882;
	b=IatpO/7RIls3yq8LCyaEE6bCJ5yUcBqn8JWfhXq5Nc6WiwvvK0EDOZ1dmoNV+d6/alTJI5
	b4tofG8yfTlS5OQlI229rhwl7mJJ7BFHfz0SzatQK89eonnCB+JKP+860hBelZkznC2EwM
	gsDVG6s0ooxmeK0tezNIXTbcjrq4mHk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a29go+UF;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58BC043E3C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E0A1F0089E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781126881;
	bh=EzwRV5m0lYG2nnm8eCH8HMlLykBf4sYn7ixX7YJrG3E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a29go+UFramhJ2rmMsIIS7Ko4h2wT1YD+1D2QXazqrLFP+9uOlR+tFTew6mr4PlOS
	 4cbXwU0c3iHyfyxVE+wAzzFYj6YsDljqPEmp+Ir/8G3gxLWA34k8XDzE91vQapdS8F
	 lI8lcRovw0NABCizK5ii2NvDmbe8fPPQj/IJqieuk7NY219//yVB1pRDI5pIqnzBKe
	 Z4oWwPk4h6/Bxlb+Bfax+fYc75LG818A9NHtvDANuymCZ/kc3kqXlq8YtLd/5MmDFg
	 bjDjSK6P5SVriHTQgnlMqCtFM05W0j4FOFpYgZo59FolK9b3bbt0hHCt6eIqUzRcLl
	 V6TDbwGnMUkew==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9159f631656so43078085a.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:28:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ81MXCMInQhL00iz48s+W/6/1WKdNoklQW4xUz6WXF2yiBFxARUfspYr0qs9M78NQHHqU9cbcm4ZA==@kvack.org
X-Gm-Message-State: AOJu0Yx3Ju/SgUh3ll9Ta6SkoBUMhZJTekp1ELiLiu8amupJrFwzpVXO
	oLIABVaRm1gpbv414DUB/Vu3vHN7s57zgtdpVsQ/YmxU+A6dT9uoAqemyOdv1e4bWlkLme4F9iT
	Y3Q19/uRDOn5WaOANRDTRVASZxyTgWQ0=
X-Received: by 2002:a05:620a:2943:b0:915:fbc6:7704 with SMTP id
 af79cd13be357-9160752c933mr68231685a.20.1781126880634; Wed, 10 Jun 2026
 14:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
 <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
In-Reply-To: <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 11 Jun 2026 05:27:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
X-Gm-Features: AVVi8Cdp0a68L8hWrPQ4U20qfRbApCoKQe79lx-Lsu-jHmfVp3tfQZwu-eMIfwo
Message-ID: <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C8674000B
X-Stat-Signature: gqku9ypg3j98qiuyiy1p6nnp7qng6wf9
X-HE-Tag: 1781126882-445465
X-HE-Meta: U2FsdGVkX1+z2addWFobOyafRnBZ1XpRh6sn8b7eNgT9iJ7Ndld2WYxJj/I95EX/mlKrFP153CiMugPTLOgiMiJiUwrYAOZfD1MYqLVpSHaa2QGi0eGk/1uzV5PF01QR8XguWuRfwDAEn5vIrcJrBHyvae5w7PCrJJDbwiwD5IoQLAoUFR2nOIaPuDpnI2ojwObrx4OmMjIRTOzlhER36v1LqATgvL0cFYF3xZEb1wvI/si+lt94bF1qF0Nc/EupGy3AIrYcK5qxw100rE4mvbgcVqEYxTMlvlDjg6G7NX6gbNLiZu5ppupXAKFhskM/d9HCH1npc0+Yx/Yul4N0XN+igSQyTgHumXDEDm7nYQMW0ReU/nO16n1QfoDh8/M0jiPiu/R44eHc/praXwBE5a+2PjMPXTa/4zr1wBL7ApMQOVWurRAwhLU50ms0Mtp4YQYP7YxhV5Zv2Amun1S2V6GpMVk71p7Xp+WVFys8Vv85WxFgBhNHLeamn8QrL9jUpO/BsQTs4o8AczqaEdL6KSzTO/6a6i2SwGmjE5FX8QR9G5J4uO82Wj870t/iY9FuLxG+2QoGVWUZjoZYUR5tyWWho+8m3eYTV3tF8ndkuZdyuBiGCB8ZVf+2e/dLBi1fbEzk9j6k2SF58Hy1oifvevTWIcfgRM/ZiD4oZVL9qS5w4QZRCJKekgjEo7JMQTAjS6Z4PjX8U15Ev2Hgt8vfz0LXCWbtFpYr+f7BOQmXPy6KX50DlTz+IyB0Exnd6sdB2cDnvrjk7S+X21tw11yTNJsO7wO/Ycj011hpiUZtjc4Gn8TKFvwO788XEOW5XI/QpZKEcrs3PBdcvfnLaCfxtvkffOGV33EYxyQVyo3YqUV/lF7189uuL8oPEVXsBFYLx8MWZ/CKBKKb4zF+nnFWFm3eca9xpjgmwdI+zB+J3m1KRgkqYyeL6PCwksVPzHieZi9yL2K8UAaCS/1/wDQ
 hT0wbSM7
 rmDhOfpNodW+dhPSTw3MtWxBtnwGhqcn/9UjmdX2z3vdT8fDxRFNeyQ1URW7/lozb0IAmDWn6LW8GssokoBO6KleXB5h7dnHYD4Bi82msSxk/vVXC5GBUyEb8MWVASLAhHEWOlMKupnhW1FJG10KdJHvYMHy/Bo5HbCj4faasqyAZUIThzNi0LB3Eiq/HDRDNuA+tmk1xxaRiEqUPzsAs//UL4lfZAamBS74E1p2qOxaJe1offVwVWBu1SuMSM+CXeVA7n9cTFiqgJ7poHs2JRQIDpY8nTY4/Lo4PCKjc2VpiSOdfab4yifWFbE+ilrWS0fUwbwWy/pYvvp+VMZb1gbNN6XE63COwaWZsK8QSOBSVf8D/3UI2cRIIoucsy1oic1wG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 11:18=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
[...]
>
> The "_LOG2" suffix names the math but hides the intent.  How about
> renaming them as:
>
>   ZS_CHAIN_LOG2            -> ZS_MAX_BITS_PAGES_PER_ZSPAGE
>   ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_MAX_BITS_OBJS_PER_PAGE
>   ZS_OBJ_IDX_DENSE_BITS    -> ZS_MAX_BITS_OBJS_PER_ZSPAGE
>

Do we need MAX_ while everybody just uses _BITS? e.g.

#if defined(MAX_POSSIBLE_PHYSMEM_BITS)
#define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
#elif defined(MAX_PHYSMEM_BITS)
#define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
#else
#define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
#endif

Best Regards
Barry

