Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D54CF34A9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F0E6B00A2; Wed, 19 Nov 2025 07:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21016B00B1; Wed, 19 Nov 2025 07:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D686B00B2; Wed, 19 Nov 2025 07:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D608C6B00A2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:50:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5952A140453
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:50:18 +0000 (UTC)
X-FDA: 84127339716.01.336070B
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76F2010000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:50:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XxiU9rg8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763556616; a=rsa-sha256;
	cv=none;
	b=wDuheU9ZcuqUs3Cwch62DYTopzWaai94WXHuHqJgaSXW7jNxfBsYEL4iTXiveFhm5Sca4n
	++tK3ToTkf8aiIByOMuFgktkBOkQHABJiEgw1AbJHBvnFZ8hhpr9JFvJr0snLcynPavPyd
	7mselL90OPtwdgC3BP3pYjQ+M1i+CII=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XxiU9rg8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763556616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA8zvRtoBoSyRCqPXPxIOmMsxnYKcvlkxqlu/5zlfuQ=;
	b=raq82f8i1XMfq8vRqn71Oj++pCVtAeh3+r6KxYCPgC0tpJ96FauV0lHAp1jcJtEU9Gq7q3
	nvREkJ1y1iPVUomOXT10AUkwqm9TQ+TYya8nY4ffOrhIUs61CcUTCT/qA/DwgapUO9M3N4
	qkngD2vHrJOglBa13dGGRvcjF2va5X0=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b2e9ac45aso4326900f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763556615; x=1764161415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nA8zvRtoBoSyRCqPXPxIOmMsxnYKcvlkxqlu/5zlfuQ=;
        b=XxiU9rg83Vk7wZSyORW5BxOWihR7nTK7c0bjJSif61DB94jhixjvUl7QY/mgPCQnIT
         MHbHBmWznKaIFyagL6NiWbqUoStgIw+UxdSspc4JA1Xmbslh7IaqololvaWQrwC/5sho
         xMvvja0azYq7jxmZ/AtUTFsjGzT2u/iZOJa/C1BDKCSwPD4QvOll/ml9AjkT+jjjq5U9
         CmDSbaJP47BAxWG0TZ/OuuILDCawn2A9ZGnpQCwWUqufi3Yw5fIxZ9qIddnU6Do2q9Nj
         TRe0EWjDOz4OcQZVToJbp/Zq8RJwGaDVrAYyuz7cMeZU2dyw/3PbMWBQ3nqnL33r4OVb
         eoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763556615; x=1764161415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nA8zvRtoBoSyRCqPXPxIOmMsxnYKcvlkxqlu/5zlfuQ=;
        b=R7+vxlqT3JmDZaxzEiOwENHlYPKmAUN5FIFjj73aC3a46GK+q5/oskW0qAiEXbZNbF
         rCaYOD5HvDJH5DRo/JYaAKAwpOfrmSgTv2g+9kYBwB2+F20v9VGXfNqqORHYSB2cRgdj
         ff+gUNTmpczNNDU0u0KM5zDMg6w7enN4YXdZ1dYxmItX7cEUZfjqwdcT7k6hYpzSz7d2
         SUwLYnzeD68PFpYgiILChCnkJe73Vx2cpxzYxfV3OT+p5x4h0bjGC7J9llTMog1rnSbZ
         wTNwWIUQ+O2ztRvcZzxn5UrVcmlhx02nV1oI+EE2cJRfV0K3JIZwISgKhGhZKC4/rpGs
         QmhA==
X-Forwarded-Encrypted: i=1; AJvYcCUyKff1HG12ah82BV43gwzsK/qNVGdzWIsYznfrBD7AxQbSbUiGOseQa6//ZlhxWsXNwZaodPmFAg==@kvack.org
X-Gm-Message-State: AOJu0YzwoKymDJ0babsS2n9FVMUPCiDEUmyaQNyfL0XLXqAD0IfQnz0D
	+PxzU9gGQelh23qMYcXOT3oR0MQiHThkt+c7AoLnJn4rJ+MxJwUIYMr/4DnSuvi8taGEcZbxewh
	C0dkjI1Xp3d4h7hsbxuG0kunkmEaCwOw=
X-Gm-Gg: ASbGncu9fNeRzfjwK+Ti7/xEL9IQrPokD9t8mCqSYBQMPBfWQ8dVP94YO+5gzvOVzoe
	zaoLixjcrQ0vpRU+XOqZMG3kSOgjzcr5S6CfFXgluEO39L07QgkUIbNsT1/uyEbuji7C50Pw54h
	TqIj42wvd62i6PTtPU8gVeOpnyvFfTsq4MKnX7sEk6bRH7iA8ZhYzrujeWwnmxqQKWmUHQUEhpy
	bPZYT+W4qGKWmQN91xUnRRu9LCR70w26SZcgRL2+S7xjD4B0ucgMJD3jhCjOECs8NCuwjdkitTL
	sMJpnpDc0Is=
X-Google-Smtp-Source: AGHT+IHgI8c5EOUSWvct2QTLF6ALLCIFF35FaJQ0wPKqs10z4jdJK17oJcLT82pnXv6Ky0T65HBvEgA6AxWBL3Gflrs=
X-Received: by 2002:a05:6000:3106:b0:42b:3b4c:f411 with SMTP id
 ffacd0b85a97d-42b5938a9e3mr19800054f8f.36.1763556614641; Wed, 19 Nov 2025
 04:50:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763227530.git.chandna.sahil@gmail.com> <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
In-Reply-To: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 19 Nov 2025 12:50:01 +0000
X-Gm-Features: AWmQ_bmSZULykPVYd54GY9VvK4VU0qyx_L46OwyDJ8e9pkQ4KYdSwqgYQ1ro6bU
Message-ID: <CAKEwX=MfUM1PvxxL7dFQRSr+bEfm-P-5nzoCO9M_55tY=A2sjQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, 
	Liam.Howlett@oracle.com, weixugc@google.com, axelrasmussen@google.com, 
	yuanchu@google.com, yosry.ahmed@linux.dev, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 76F2010000A
X-Rspamd-Server: rspam07
X-Stat-Signature: xszh9d4x9yg636fms7udqnq4q95mz5h1
X-Rspam-User: 
X-HE-Tag: 1763556616-852614
X-HE-Meta: U2FsdGVkX1+wNsbmGh3WD7ZEe/Tw9N7q2u2IJ6g/66ZrBiPEbzACT2Y64NIoJ5I/puUaHwqLrwoqs7nKC5zhUYS7FdWUdKdUQHKuiNaZgwAAO2js6hy/MDEe1l3i4moMMpl2dZDLpphZ9OVpQvNZ96EdB7Q51+6QxtTFJ9vD7+dVtsVS4isiT8rOS8oTxA1cugxFIsWJbDHtW5HPVXxTyhAE5zaciQh5Y6LyRo9ui+pySjAoWkX8hCDSYl9o6sx1M7gbzy66QsZWpQfOl5IqMZfZltSA0ztKfb7QUMHn7HPwTjpfonrlKH4v4/MYg2tksY7NEypxGGWzOMnjV8eLLuQ+Le4scCcHUcYcI1GD1Blszz3TfytsLWRY04hAsz6zIwL44shNspzqJiTsBoYC1TEYrGgTIt59aLWM9/m5B6mlUM4nO8qVSAbpmqRqmZ+WkBNZm8rXbBxU6+Wl/X0TaXfCeHTh7vkh/J99u2EeWjSguR1P9BXct+U5sd6BSpWvlElc5uqtykzUpARYNAMYoWKiPuClTsrEhhvWJcqwyZHUq46YVOWNLJrDqZ9GDp6KEhQX7qeunoBj/hAAjztd3pr0jAKR5CYFl+NzPXDarZfHONofB0IeSKE+E8s9GUbvwJSPV73G9UcEjzKH7p2oaXm+TXCUqnOszifY7upQf1O6UfIPnWWCEWNG3A9qbdtPmj2TWVwXvrnKzG7AWXVllWj9ziOmzyJ1OjVcrqITxFQ4jHXDFIvUEtBqBUw8x4yeNWV6khOrBXgLyANyJXafVHJvpVsdwjhEXZTs3yM4Ot91DHpHydhScOZ7R14LufVdL20laFsZuhu2dHfdeowMwLvi2zHXOqRAQKE1KTq3YsguM2CDs9+UVHpJuWCtk/yaSaIED/rfMiKQmfWG9Uln/C0BwLvGmOyKNqDuufussk9AHQ2ZqC4haeVGLnAm09U7wWJychcoSVub58fUkAk
 lOSh3e84
 89R7BB4fABh0eRRsYGf2kAeheO93G+5ILSUgSbRnacxuTZbkqkR1+M+0fGTYpTVM7ax1swCfKnPCPbAnxlZd5VRk7MVbzdhGpGp4p77g9wVSKtunnm4oA1fUiz7Vx7L5/2kMcIz3tzuv2y83XLItj9MIeRJzsO5EaBcZ17+Pjc7ZM/5nSPdoz48pgafweiPwP9qC6dCgWA7i9ulXQGdfm/cCliab7DKhDLYWjptBXwXc9Cr2CaMmn3yHYaI7uXjL5iggkz6qjKvAGv+RcEbXP+K6vs0vCFDpqPuCNa6BCcy5eZjsXJwx0cR4yikHqaY1QwxHEFL0crA4ojZeGiBTDZqjEozM93Pm6WwICCJ69LP6fvqf+yQoY6xga2NjA0CMMQfwhKX/mT7UHTpRU01c1qXJx+L1dO6III25t+C0ksKHoEWVu7R5P3JQxuyWwnxcNXAF2DkxMty7Jl6rUKdAhNg6uRtGHSzyB4JMK40cwDJNnx8SSCuQ+jhZJLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 6:09=E2=80=AFAM Sahil Chandna <chandna.sahil@gmail.=
com> wrote:
>
> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
>
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
>
> Found by: make coccicheck MODE=3Dreport M=3Dmm/
> No functional change intended.
>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

