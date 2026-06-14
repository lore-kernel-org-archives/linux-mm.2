Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475EECD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 15:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCF46B0005; Sun, 14 Jun 2026 11:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D7F6B008A; Sun, 14 Jun 2026 11:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B596B008C; Sun, 14 Jun 2026 11:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25C4A6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 11:53:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 920E71C2B7B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:53:12 +0000 (UTC)
X-FDA: 84878962224.18.86076BA
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id A43FCA0007
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:53:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILSB2cC7;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781452390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w+UJOJoBBe+Ioti0ucRQt2R3wB5Ht3VBuou/uLsQh/Y=;
	b=2HSQ2xTtPgIc69roGrwdkY+C4RWMXvFjFi3Pc4nB4i8h9vfvUAb7mtCp8dN2URuNFan8HU
	y5eRyAzoxvqOYP1dzblrxF8P+iC1dbirhXrMV8rDZUs8yuxyM4FXiH64sVzY9YaIiFF029
	sjLfMfLkE27Qkxha1rpsWdepkD7DXjw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781452390;
	b=RfEYh0qyl92NKOcjSr0duNt+/eThli7PWlUfIKRlQbdJGKQCZ2AP2OqeI23dD9pzBHt73V
	z5QjjYZ+m9p0EtQ+Vte3+rste+lDUhxiU5OOONF6lh56F55eEmfJ/eJ3TltDaShMywvboS
	VOePi9fovLyDIOAUEfRyYHYm5GXjiIM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILSB2cC7;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa63628d26so2285409e87.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781452389; cv=none;
        d=google.com; s=arc-20240605;
        b=YmdGEhjxl5MNqPNDrBL7gjb0Qu5gVYwPogKsdzHddYONdobOt1JzhuRpOs3cp71Ayu
         SEUv2HmEtOpTvz0MMVK2Jh0wUDnkKiWrBwxO3ZE/qUYBvJxfCvYuwcQU3yHez0Rq9nA9
         n7rzHypjOrXPVhKK+lo/1XsQRmjmUPa6yBw15gsHwaPp5CyqCeJJ2bdot44darHcGz9Z
         47UlmqeoVIrpt5Ordj81KDQXdXEMBbGxxbLbJmKTtpOepqkAhwdUPaX6igJAjOs5uXdo
         OiR1sy8JE0oSSbeUhWlv2c7mqnilihMhyEfxRKsz2jzO16S6kNxWtcCq7M8SQRAL5ahB
         OacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=w+UJOJoBBe+Ioti0ucRQt2R3wB5Ht3VBuou/uLsQh/Y=;
        fh=BBA1iv37qkurayrIcfxUQkEXaBCT7AWGQSqiAnVq8Fc=;
        b=XoA6en47ZvVSUejl9y2498hGzRpll7n7r9LV4h6Ao0kqgPejaxLASK3pi8Bg+nvZUi
         ibpMeyMZ+xCrj09B6I84H/UoVubww5GJ8x1KP77mhj7xtV5O5Wak3lx92lZpLMR9qWkB
         Bf1JmIiG8OWkeN7brWjhA9yLt1ghkPZs6hBv5Xn/wQMmLvoakuR62/rK7qsLh162Gj/U
         kXHU9bAjwl0cKiJ0exH4KMj6jrHvbJzEOkmEJSp3C9jSNDSjVy1QjQ2FZHCU7y2NNSEa
         pNnzZK+Z6blgQgx6hUIF65mxgYXruQeqmDXav8LcbcYMV+Dm4CuL2hmjZ0ifUVY/wWEz
         XU4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781452389; x=1782057189; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w+UJOJoBBe+Ioti0ucRQt2R3wB5Ht3VBuou/uLsQh/Y=;
        b=ILSB2cC78GxrwFtDTcwwkF414fv8Ok9Fc6A4V39bMGKK1G+4Cj4G/NJFh1ExZOROYS
         4Af826Ua3biDWyQPdd+9VJVonx5WyMJndsNUY2Ud/fimTkWenbZXEWVNCjh8XDAqdn1b
         7vsOHCQNO3gekJrMnB/FGaZa3q0Vlx9CQxw250FYEzViAj1uZnSpujYpvz65qzb/zL6t
         cCxLQvySy+sOvOyHE+AjjrB70HXsV9C0ChbgdI9zzOBVcnna2hCTHzRWL78xbTN69Ayz
         NizzgoFr5CR40Oq4shw7YOv4ExT00sZSLfJcFDHCmcaz0+Blv5y80aYEONUW55jUAW1X
         I+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781452389; x=1782057189;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+UJOJoBBe+Ioti0ucRQt2R3wB5Ht3VBuou/uLsQh/Y=;
        b=YYJleZUBSYbnS5xnph5iVhZuGa8v9BX5RFGfL/kAe1AiMiu459oVDMCIqVebT4xVxY
         NZ67ofiWuy8l/xgCIn/7VO3C3L038Gdw+Mb/zGr0HwWm6i88RL68GM3is/T2m8ljjLZr
         vBkWkF4FSV2eKRrEXMCsHc8a3gte8eoaiM0H/znn8hDvvpnsaPu4MT7C7pjexH61DaBE
         XzQBBF9/oXPeYyXXySgF6ghgmUb+m5EzgNWgssF85OfZq6lIDW9MMbR8sS6EN6h+gTz1
         95iHGeUUw12o7DVjblW1iOpultq0ftIJJ1yoW7ZCv+ut0zrAU06MoBS+/XmXjpVVgl+E
         lL4Q==
X-Forwarded-Encrypted: i=1; AFNElJ8R8adurwiBjizPYWgoHTyebKQLnuUOcT/xuGmVtsXmk68lyj1yxmodorEjDwMVlHqWRTAkBnVhMg==@kvack.org
X-Gm-Message-State: AOJu0YzSXcaz+hpRaYXqeC8ABYz2EMxonLaYh9vCsFL8TW4MCWSqPozy
	cghj0kqkLEvdnfrLnDv0oAQRmwWQYrudHvr7BsAuA2xZeyy/BdOv1DlrbxIRcOo3vZ6+HJP+LCp
	Km3RtzTKKOlu1NnR4Zvsckm3Y3C0CqVU=
X-Gm-Gg: Acq92OEaRuezWde07aQL2r+6+a0xpxrlDLe1wS0dtyu16tvHHNMkqmhc0RC2gbTM5Dl
	qSADkejxh2SiADd8WTC/OgQqV4hrHThKU12B00P1dqT8lNxBN8UaI8B99UYB1jIVaOGh4fX6veo
	0Q+HgrLq+WNpz8ySlE1Ta7FW0xJxz3e6EorPp38QXX541eTcb20Kgb9PupO1Sxe9DT+rAz2hdx0
	RbkwsbsuJ4bW/0wy0BnxJ/3mfkODi711/PepUDFcj6h4FGcjT5ex+loTKIqQcAMwd2w01HcgqYP
	5Lt18QhnNDqAySv1BT9MN3WpfwzjLPWv4t7V/A==
X-Received: by 2002:a05:6512:6205:b0:5aa:7363:8219 with SMTP id
 2adb3069b0e04-5ad30da18b2mr1538771e87.17.1781452388462; Sun, 14 Jun 2026
 08:53:08 -0700 (PDT)
MIME-Version: 1.0
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 14 Jun 2026 23:52:57 +0800
X-Gm-Features: AVVi8CeVgfHevIgNPvAN7PddPAI5UkDrATei_6WurcDIB-aR24p1b6DtZg5IXY0
Message-ID: <CAJxJ_jhwywNDv_1N-9KLpNN-cxH=MifD9krGXqvd8diATff9cA@mail.gmail.com>
Subject: Re: better block swap batching and a different take on swap_ops v2
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, usama.arif@linux.dev, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A43FCA0007
X-Stat-Signature: m6cszrqqt3gh9isgwiam7rash5rsu3fk
X-HE-Tag: 1781452390-878265
X-HE-Meta: U2FsdGVkX19qrBlySvWlHUkl4uTDkIroVcRCizhtr9MJHI96+sVy8EgAzMxsmzvizkfjymVVI8aafvJce0kuOg1gB6cStYOLfW1jHyf4bYjac+TdCo5u3SkP+9ugehqiI/gLdhpky9I+lx2lSbBxbfjkqkys+HXxzUk/8HMHqelJEbQH6Lk8gMPUOsJrn1KQ3Jm62HBJ33zI/P+az6xvBB7zsOwxoBuVVsJ6BCnZPoqJ7DVQUHlrAjuzx/aVUJCf33/rREcisdq5Nix8exKRH79xo7d2o8WqHbHIduJTWGcn7+imOMz3o30B9cO7wPVgAnzvkCUgelCoYLEVqcOlLMSnA6BQLHm2nTmL2YfTrpPS68yi1SIdEX/dLmy2grsPXDUqH1JPe2p0Eoc8AI+NJpjzWN9fuL1cHp9Yblrm1PucAYeYgQ/zHJHhvzxOsTYD1quEZ1eG9WBnCGZCUOsuwQ9JjkHhALeVjz3ri8a2w5wPuhgiJD1e5RSJK86TqVwoRxHYCVim3vjnVNGesAl3VQBR51qC2kqEhx7LqLrClXsuIFuFCMiY9dBuyiAY7LHxwAzjajNB5s3fe1YE2HBeJsglR45P5rELLfxrrSQa5pEmOWsNfk6yuN/5wsfIzYs5Goi8pvR3Ch8H4CthbmNqsT3VI9Vs1GffGq/YbzTjQsU3XfVpuny3VMx7kmnmlimMpgaT803AChARcmMWdovjh5JgPkmdFnUbv1hWokGFhCBfeMvh5nhbJMvxd5nZkaehSBG0LHCidYpgSzewOgRHNnlKeek+WV2dBf/bkjHuGPXNdVP+mSskZxyu4TnLcpymPB/Olj/QR3JqOX9blzuuFHFBXlPczpfZ3vkX1/zg67lFVp/pmxzYk+DVrmaPOpbRw0xDY1T+wmaOEiWHMQC6yL3CWdUA1RnmCByHIudC95JaG9ebju8vSq3XWQJUcS6gwxXfJqyXpoBgrWdiHH5
 nXZj9tZB
 Yuxm+hCkcKmoiAJ4qLpuw9e5tVG1eEXGh1IY4NDCXNGaSBD5I7/8F4h9aUFVJuINTwQGTEahX9lF9mHtfL4jb79vm+bdioGWRYclo8/t/M4NjyV4GNEYWsHv3rANWiSClzWelDrusm0I11Jyoj6/q4C2D5pxJqZFCQN+ZIQTM7/iCnQ+RnWfSDidWqhiDPb6LtsZdf0dT3EKuG+bwPgnsmNXWuQSrwks76+nGc/6uECUb+XxeSeuIn0cTm9YvCJPzuoDQHSoIZAoLSdp4K5s49pKOR/3/WOO2buulwd7xBDA2TkdLXIrfEVYiY+5tbGvLp3CnTqzZwOhm8Aco8YuSaorlDZ/G3DNmStXYutGXEHeN/C0JtAu2l3cNNGOoxgfGO6UwTJRIwOY3RC1xD38oJA2/eOqDUlbyxJc6QmSjl2xBVWArXPJwGp0ObUl5Xvu74nViNKFQMzsuP0wTQYNVLSo0Dh9IM3a8EDibtmPXUZkd3WwGb8NHMuWApWjwuvTnxfgZWOqauPC29+Kb6AFBOju1QvSKFJkK8llEdiGhx3VmLCaVt4PLXhKasFXNrFwTLlZnxPvq7tK+eXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

FYI, I posted a small follow-up series on top of your swap_iocb /
swap_ops rework:

  [PATCH v1 0/3] mm/zram: route block swap I/O through swap_ops

Link: https://lore.kernel.org/linux-mm/20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com/T/

It does three things:
  - Add swap_register_block_ops() so a block driver can install custom
    submit_read/submit_write handlers at swapon time.
  - Wire zram through those hooks instead of building one bio per page.
  - Move slot_free_notify into swap_ops next to the other zram callbacks.

Happy to rebase if your series changes before it lands.

Thanks,
Jianyue

