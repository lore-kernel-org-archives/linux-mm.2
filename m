Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA9B8CAC5AA
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 02:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537B38E0012; Mon, 22 Sep 2025 22:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7E58E0001; Mon, 22 Sep 2025 22:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7178E0012; Mon, 22 Sep 2025 22:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9FB8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:10:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD2851402B5
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:10:47 +0000 (UTC)
X-FDA: 83918886534.21.A028700
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4719A001C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:10:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkPZ7LAV;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758593446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2o3DubClAWsVDJ1BnGOUzNOsvzg6slCDhpRe/M692Y=;
	b=OW/beXrZFK2MGyX9Feod6sm7vm9+CVlr9esfR78ORxiOaGgRfHcsSRMZ82t1tdBsUt3NNE
	N1nto8yBcnweD4/IwEtnAop1mTN0YnHvn+f8CyPMQnypbmXQLfBTYLmax5M72IS689RNZ8
	TXQJmSURpPbWo+eAX+cjHeKsFovgaH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758593446; a=rsa-sha256;
	cv=none;
	b=Cq2SBJQ19l8syWC5dDzk/uWSP6OuGKWA/nV2K1IiCyepyFguOPFAWuYw2CgQqJgbXYaPwl
	4qZfTRt/y42bGo7xg0xgPElajbL1BChnoyVXy3aDwKsar/DlFvlarDuW5QUeWJbJ31U5Bm
	g5J5qlLo+h9+rTSr65udHE43spc/qUk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkPZ7LAV;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62fc89cd68bso7604932a12.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758593444; x=1759198244; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2o3DubClAWsVDJ1BnGOUzNOsvzg6slCDhpRe/M692Y=;
        b=fkPZ7LAVLVZp380jkytAv0gEYAWvHuPmyg/fsbQ19XDe1zTS4vQQJs5fvNtMzhlW7G
         A+ET8HBwvBbd9OZZ8MI+trdZyHI7g9APazA5A2hccUQrWheicb13b0ohVeG68GfpOk53
         nSiHbXt4+sYRSWi8dhLQ9ir5OVCAmB8pLZQcgIepH352o26FmhU/3TDgskkz0mLiCjYs
         uj08TEmWu777+YQr4v/LyTiDDEQUFSb+2DATCz4BaHC/Hr0KrHoz8DydnijKF8MTxXv9
         wQfDlHV0cfg+5fQPhGG6u+A/D2D+zbosiGAG/bZCYSvXEB3ocBDpMxjctqGUpwcSshcq
         zKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758593444; x=1759198244;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A2o3DubClAWsVDJ1BnGOUzNOsvzg6slCDhpRe/M692Y=;
        b=jHnKAFIknQ5V6kZ1lih9kaI1KsUR+vOp8FWcTfhaHr0gzkQsE+CZMhD0XNa7AyNK1L
         NQ/NoMa8pegziFXCGIA7/o1n6XoK2tQQvkpa34xoxlVuF6G3zYyfvh3ad6X4vPltUAGP
         SMyNE7ojZJ8KuKQHesuKm/PrXBxAlxEMrS83haJIDY1Y7TKB/eIU2izExrddJBpUX4sk
         1hgmhH7D1JhoItVMpnKx1X5Z8WvJuZKkIvJ0GGTQ2IxPDltwrYuqIxPoXsiIhvsVbZWS
         /sp+TZ8Q2DlGgvjSh7uN/p/Kzb+nHd2qkt9O2r26Vrcm4Am10t4dihG1NGfGoK9yN3KE
         6xCg==
X-Forwarded-Encrypted: i=1; AJvYcCXXiizpW1G0yOgrfH1uHP++LJlE0qKcZ+Wros0Ynt49DGwPTIiV9YzqGBaBH1Vl7m/DyTNOC39Erw==@kvack.org
X-Gm-Message-State: AOJu0Yxc9fy4+759tlaAP8XISRdIdVMKvfvf92KSqm3/ZwGgtbmF7gXH
	bIPe3v/W/6CRoIVx0wDGmKf3ztN/Uzf4SyQvPrksNu34EyzMvRCMaYyO
X-Gm-Gg: ASbGncsg7zl6G8Hjmd17jMMq/Y7s+3nhJeH6Fw5zAP2KAslZXsiBHH9N4PY+AFn80g0
	VmqTysD7scQbkZnMBzMLyx94G1goHDSjhXpUSNBdo1C2dTWgL7G+dp8CXeqrLWqpNS4m7uVkzdj
	/AGlw4FjkEQLqYzueWDxCBiwG6BzmWv8sUq3BB1i3y+r1q0D77TdvsqVtpvNEV/15dSXRvb5sXp
	Hksbs4LS1OCdcYeEXxSbP0yoIE3cGczRKdE6dpQ78eOfbB8PElc2zDbf47IjIwNqJZURdJt2o9U
	g0Oh52tEeDO497pTUKz3UHY6OR1saRMcyb2xsQ1z+6TW9GktA/8jKaH5WKwim/bnkMhYE/wYJTg
	zw3jcW8b63rPMVklFqJHgpnyUEQxIbsN5M9qmUUpT
X-Google-Smtp-Source: AGHT+IHh1ALlBKynJpngfEEL3Ms5mRjlxZlK1yneebgFCzG1payJHzKI+8XXxoWxK83o13jhnY/w3Q==
X-Received: by 2002:a17:907:6ea0:b0:b0b:f228:25a with SMTP id a640c23a62f3a-b302cccb3e8mr56042366b.64.1758593444044;
        Mon, 22 Sep 2025 19:10:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b28a990f6e1sm658553266b.37.2025.09.22.19.10.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 19:10:43 -0700 (PDT)
Date: Tue, 23 Sep 2025 02:10:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
	Liam.Howlett@oracle.com, catalin.marinas@arm.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <20250923021043.nx2k4ftzle6e2jht@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922021458.68123-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 7epd9hmmsrfb4on16cy3n1af77dohds6
X-Rspam-User: 
X-Rspamd-Queue-Id: D4719A001C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758593445-827185
X-HE-Meta: U2FsdGVkX18FDJ77PfOr/tPPnn0v8q1PnQZxDE+rz7YPVsTNQIFsfIkhRBYMrvzyrk8qk9OLITgpb375qgFWPVOEhDIvbxtNJ0IsahOOhgnfpkLSJjQEnPkj47kTEYwyQ49HwMh5aLbvvaATRHs0aI/JKi/6OJBdMVIoWpV8DNZHpMASj+F8LoSfmU6Vw6112Ii/GjPN3Piw6uGb+nTmgCG06tZjZMqPF5xg8Ct6qTp6UZcgkYJDYopNaOK1fL8owRKERrH7hgkGmdqGlo0rgGu3kSyIkd29wPLbDs6qpalIxpqqPeYKuwXs7fcDWd7LYn0hoIP76cS7aO6FcwyJsUvKzOEw9r10Bq1uqma4oUptDpo3gw2C4abb/dpLZhYr7jl/ClE1B2d5UNhQlTX6epGbOQ57IErlc7skDlEMuIjPk/Mq3NVvHcOEYCQqvHL2FbOkaDA3mO9KyCvFtgO7nslmTN/lYDPPdAo8wDCkZgi4oE7u8/UUb6DsoXo3TYg/MDE+asZ6PBTi34ijOEQbiTu5ecipIr6nI5+z2v1PgXY/ulYfjgVTnXDtb3veqAQ91q6CCn/QTRvN80AEExQLxaQiLA/Zut4LEornnZv1yKqOuGIbY0F/tGAR1z48VUuDLuAllhadG0ij22KtmHxD7uC52D3boJ/9F31QpFu1O5zzIJRpjUJZ7hNyx5Kj6rrYWiu/bbY/iswiFjbl9VvseOgrK+gQG4uIhpIfULhFK4cES6MXEq7Xw0b3ntRf5yBB8N7fCu/tPjfuKpdBwpKHqzKx+06joVrbU5uJDsK+dOivJONJUOlwNvs6CDIpGGEjm8OQx2KnZzhl642dnDaFecIxQfp71k7M5af5SDBjDqglnYpSwPlQqfVl19ZNfvAbf0MVq9pi2Agw2nLPi9jr10DZD5gDtF5qVVq+V0xDx8xiQB8bTxT1lvHB4bZCscSikDcBjU4Yf8UvzwPFO45
 U6kcIcUF
 lwEZxb/HVSOleXOZY6N+IntSh1zFMYmnRpS1DSSybrJFrFnJIvNbUkpjXPWvnwAAtivY5Vc068JI5IE80Zs8nVPOsZgLJjZjpEIqHNOaN4S9pIyH/ja8R3xYY8+6+TK2J5BuzuhxbIXAWtwAGFLvP9vk87n3i95LMEhRKvvyvzj4IzvavoaN29V16d0L9M8HfeCDfeJkaJPrLsPypZ0YkKIgRk16WZPTRTpNx6P6Xw8i4pmCzp0QBGX1EpvfYvbsGtHhuEWBoWjNGrSI0lQkQhOe5gANvtDttVUPDKjgTi2zAop+pmKi51HzlVilsYVrhI8vJPp+piLLVbWbP0vVFG+tRHtKQ089DFhDd0U07/SIut5CZlUi8FYx1jVwxl0W3hVfer72wLfgbBkysDYDNfBe4UYSE7jctRrhd6GpHgztWqAl56U49Q/fCEg5qoRpIi+aDmdyIN7MwUm9PCiJs5WcXCedXKltleGyyx/P7XRt297UGB6fgcJ5YWlVxT4FL/1jUr6WdTfwf1e4Dvx9HzmkliQKt8u5a0vIGXPasqjmV+86Umbgj07mDsCpi6+NwWKFrcoGD5sUkuAa7ZQpBPPXZkeVF9ruKSY40nTLDZKoayG2WMPuzmGAn2WtLABcgKySb6K8K8ifq8cIg153XIzXd65Xm6dqtMmREJ3dF1OSDWXz6sEwEzOmvkVX1Jr0Q6e19xisRjPfcN84xePE9OUl6tI9PwCgLikzlPm7WEfObgvkz6cpkUM+WrupBIZr6noauatE+LlQr8ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>When both THP and MTE are enabled, splitting a THP and replacing its
>zero-filled subpages with the shared zeropage can cause MTE tag mismatch
>faults in userspace.
>
>Remapping zero-filled subpages to the shared zeropage is unsafe, as the
>zeropage has a fixed tag of zero, which may not match the tag expected by
>the userspace pointer.
>
>KSM already avoids this problem by using memcmp_pages(), which on arm64
>intentionally reports MTE-tagged pages as non-identical to prevent unsafe
>merging.
>
>As suggested by David[1], this patch adopts the same pattern, replacing the
>memchr_inv() byte-level check with a call to pages_identical(). This
>leverages existing architecture-specific logic to determine if a page is
>truly identical to the shared zeropage.
>
>Having both the THP shrinker and KSM rely on pages_identical() makes the
>design more future-proof, IMO. Instead of handling quirks in generic code,
>we just let the architecture decide what makes two pages identical.
>
>[1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
>
>Cc: <stable@vger.kernel.org>
>Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
>Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
>Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>

Nice catch.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

