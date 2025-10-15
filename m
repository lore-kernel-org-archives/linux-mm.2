Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F44CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183658E000D; Wed, 15 Oct 2025 03:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B0E8E0002; Wed, 15 Oct 2025 03:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098248E000D; Wed, 15 Oct 2025 03:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFC3B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:32:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BFB3C0B8B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:32:58 +0000 (UTC)
X-FDA: 83999532036.10.1CBF87C
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95F72C000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:32:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru9Gab3b;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513576;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cu/zEiC7ds7XeHZ44gt1r4dEzp1UHt8UKyKXP93tZdc=;
	b=PdxYVh2I/oZHRck7dV+oWMf6iprVRTVRxG2P2ageHE/cUeR/aYdlqPTymfTYVG2m3pCz/I
	kTIoXV3DRfOVRcW/nkZf55DDOyrjbImX6BUI/qyx22KzLK2182R+ysHFPogZvPP1D+Koe2
	zGV8Q33sja5UYsIw+XgR3TQEvyCmCPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513576; a=rsa-sha256;
	cv=none;
	b=3Sm34Ae41rF32KR/viFN8PFSpwafzf12romqP6qC5CCF7fbQeZjtBOtREkh6uXE/Lzpl83
	kKHdV/BrLicJBj6ud1qJ79JWTaTxUMdOIv0cKvo9TmDrlhfKA6HXkFQlwZeiJFz2JkvqyS
	Sjgza0kg1JqAVZkc8sklK+KspxPg3aI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru9Gab3b;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3c2db014easo332173366b.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760513575; x=1761118375; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cu/zEiC7ds7XeHZ44gt1r4dEzp1UHt8UKyKXP93tZdc=;
        b=Ru9Gab3bpiAW5bCvo6fVSuQnzIZxwiiurE3StQdLlT3cGijrB4ZkiLiUTHJa7/DMIM
         MOQ/C2uCt416v7r6dBBFb7FofuWT7E79tKLjjRqJ+pEY4+TjnysHdW0skM7gmsAz7cZc
         4bshtIqGv6agGb38r/iz/KYuf7YaR/lJ+pIJU48WlgfUYYK1QxJPt1LTtTE6ssXyw/Cl
         6RnqhwD6+4urGK3kMus0wCkdpzGjIHUpy2BPWdX82/pjM7cYPUJPnkcZYr7QVpDp5lEl
         Q964C72bidH0cW3sAn6AUYcXYLAPAylykddC0JrhchbjDJ5zBaOUioYbKxPZMGfeExkJ
         l7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760513575; x=1761118375;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cu/zEiC7ds7XeHZ44gt1r4dEzp1UHt8UKyKXP93tZdc=;
        b=W/ZT3fBfPG/GuL+YRoGJAQaJ7CvWbInqMJWDRTOre1FXtrUuEqwtVO0tc3yIN7LWqT
         V+Y6MfpgIVDHg/o5kRXQQoguJOewB2W48Sz1OsRM+GgBCwf1AqSKw1wG0bQNkN3Il6xt
         mVdaY5juj+YPrAkZJ3WNey680PoM9/ewTzetX7FUjQJkt1c+hhJuOQ2N7AFEKVmFku1i
         snRHWjz7yLtprYVEzR07bzoOC7AV8IwoBP5BGjixl6Asj7sj9ELIHb8u6GukOj//gXxF
         4NIahx0YAx9JwmcF+PbzYTtsarEwEKbKkPXUFpekaQ/Ty5swZCqBBwFgZ+oNtOqDrzYg
         vu+A==
X-Forwarded-Encrypted: i=1; AJvYcCXGnus5om6P46wG3ZHl/qAyu0v1MyWOxM8ZEyiUJgc8qKM4UFK1HUpSUycVAZeYDbAvpoKHKdyIUg==@kvack.org
X-Gm-Message-State: AOJu0YwkO9nx9GeIPJZk03eCCdf28+ee8a4kQWehli98Rg2XPM07Z8u2
	gDQuKh2ts4MvLzS14jrLQs/qKCtrMKI6kKH4Zl0RTNZ1bDphjLJ4bj1y
X-Gm-Gg: ASbGnctNrDjE+YHy9QC3dAKXdWdTVkQQSA5FRutb03BXK0giCExOpXkGP6qKaX1bIwO
	SdpbQilbNxOr2Tw47uUgF5FDIFMMOiiRmM3VaDUfeR9ZMXf5aprkJWX1+NAK8lWH0Uvz8+X6kn5
	ZZSbnOwKRt70WT+4qmEh+tc0h5KH8jdnY7v/uwJWGDYo23TCm/n2G0gvKFHVJGtgXD7uDo3/Bkz
	wso8mb+ofJXPkoB24YzW3Z+jKCCQxs7VrHwObwUTJeGUP/Qpx7it3KPga9DofWzVVPSLbxpy/Ww
	EUgV6DGK3RLrla4+rwHIWtQ9oZ4hWXuRx/a1YDMZdzv5o7pzM+f55vh0XT6X8sp6v0BrRGpMR3V
	29lPQNudxGrqrtvxuwkm/ihoCLkE70sbNaNZ1AiZ4
X-Google-Smtp-Source: AGHT+IE03KE2pSI4rTJDmqhEodHZuWeu+5M1Rq7LihYajBzN/AObneWDEFvxo2MFDZhDavivsyt/kQ==
X-Received: by 2002:a17:907:d08:b0:b3f:f822:2d9b with SMTP id a640c23a62f3a-b50a9c5b3a4mr2744828166b.9.1760513574611;
        Wed, 15 Oct 2025 00:32:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63bdfd73dcbsm2176899a12.27.2025.10.15.00.32.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 00:32:54 -0700 (PDT)
Date: Wed, 15 Oct 2025 07:32:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: wang lian <lianux.mm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix comment for default scan sleep
 duration
Message-ID: <20251015073253.aqyz6dhgion443hl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251015064333.31274-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015064333.31274-1-lianux.mm@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Stat-Signature: s5w1s78nr4z4ytcwrbtcn14osm6ajqw9
X-Rspam-User: 
X-Rspamd-Queue-Id: 95F72C000B
X-HE-Tag: 1760513576-658288
X-HE-Meta: U2FsdGVkX1/R/0wle5LlVX9xPSpvWjw3acPQTV7ZdixuXdwtiQ00zyLWsYOuM6tUai7QHapSAkdrXZzvLrGY6rKQQADQI40c7ItI+BplodWV0O9FGCKwx8jlD7EXOYIika9u+UZnzXgT3hX1LC0l1ECJbA+m5pLM9ogUgjGFFt8Ojl5c1R2ARe7ieKLVF9wX0wU6fG2QnsHQW/3P4Cl7pKByVRFgRrwRoh1y4Cun74oAJ0ZV8f8tFUJRoyugijKtf6++Hi/RnvB6cjK6Is6cuoriUuS+KMeSBGETy0nLwEwxSz01D4kveOGnp+9tTR8hLwoIPWFMIX7hhKvLbgHKRYS4+LcfsmKH+NX6PWxpMbYZmocg9Ab7HuVNitL4DXN/2iuN0fgKIyoV4f2P9tBndikwMPj+cWYJJwMa0qBXyoOcucvcpOHGnP1TeSijVHxU5N7lg1cv6HSiKbm3A25gVU7yFd7ECIqVprEFsrBAuZI5oZZ7uzsnHROvYVCWbTc0TqkbZUlQsJpo/cWNmuqqcQvV2rVz/VQp8uJ0f+aCzHP8IMHjEWEWR6ZBvEWsusKvH9KQd75JEusFDLtNpIi95gJrvT30TBzh1cR+0CBdIUBBDh1xiB0oNBtl9mxk2mX3Ve0DQIctDQIvkcGess00tEYtwvHGkpnUkmtW1PRlcNHpmbQlGtE7FFzqslv0jPUXH3uj3a3qs7dYXzm3js3vRHn0pOnfngTMsXKksQSmA+lJ0ti6wLhgkWxhKtiT6FffuUqgl/d8jPks/lonIR5g1S2DgD4C/W0ZDT8X2q0XyKEkabKeOvrbMKhenLVQvf6NhqklBTl3xKZG35MiaSitZJMMyiIVCccWAhUUu+KRqusmikg/LaiK6ObCBm+Wngu4Ocjg9sVLSk802STJXYoXE3wRnyR30oWuDm2Zg45xyR2j3pD70+b7zEmnlEX5RHag5fY1Xd/lBlN03IRLgG9
 pCCEn0M7
 c2wvYCNSZUo0o+RxphWTRujtWs2i7b8qvbdIvCKfFbUi307vBdr1RS7lWNftUu/16N6PKXZnqdengQxUGjUjZDpYg2BGrC6V/85zSTcfroTwRb4CakGFbbVTqjujoP+LyWXmYLiZyxripFAsMMGVykadbHCCKcU47qTt4ZnWXn+R+vEpJRqAeyEjjMVQxneax0CT6ph9AaJsKQkkRLdA0xFD2PMJ8VrLiJz47H0LbdN7joFYbfpw7jrQzsMCVFE9d/NK2RQkxVmzoRZm2QafeUnwof4sFL4OLgp36U05hIWKSfN9i5EKuX0B0c9nNgKDsz1NJVuu/Qm3qk/ol2IYFHR9Lfspqr7A/vGQ+8GbGIOtZxUzD3hCwUkW3+Wssr20sWEY5oCxF5DrCJGH6SL9OrbMUxPgElT7XvgxoYjbXppW1LLPu4fnJpqNLbZyEfMzgFg0skaX06S0lRx9GNI93z7TmHiaSIylqu/yk9vAXh/b3ZIQ+O+V+MiS9TUJvO2+1xzNrxelzj5ZxZ6tWMn583XD6IK2VFeShTOolOJpj+JMTtbEyKOF1esLzehWjX1WjAIyrTbgoRnO75JGTkQXDHTKvhsMcNVzAneHgT894nRwwIFTyI5zFqKiYx9/CzNVXDqHaPEv5b9W7mWxx/K7QPZZFGOePASKHb2/V1T4FsfQAqf2RLiHvx4tSz7ZIsUBBnFwDz84Ksk+LyKJQKoQWXNoG3WbxyAdeMDVo2gaxtuQ8LFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 02:43:33PM +0800, wang lian wrote:
>The comment for khugepaged_scan_sleep_millisecs incorrectly states
>the default scan period is 30 seconds. The actual default value in the
>code is 10000ms (10 seconds).
>
>This patch corrects the comment to match the code, preventing potential
>confusion. The incorrect comment has existed since the feature was
>first introduced.
>
>Fixes: ba76149f47d8 ("thp: khugepaged")
>Signed-off-by: wang lian <lianux.mm@gmail.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

