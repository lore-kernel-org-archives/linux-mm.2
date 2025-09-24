Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231B0CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDC98E0014; Wed, 24 Sep 2025 11:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F148E000E; Wed, 24 Sep 2025 11:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684888E0014; Wed, 24 Sep 2025 11:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5656D8E000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5E25140883
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:52:41 +0000 (UTC)
X-FDA: 83924586522.19.6BC6144
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 916CA2000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:52:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758729160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmLcOFhHx/+IUiC9scG+zMSkX0N5ckidRA2g8Cd6szY=;
	b=ZaU4veMQZuvdX1WRA/n8FRrnEjromdwcrqDksE5EkXtV6OfBNUYTlx95ou3mnzH3G2K/MJ
	zQ1NMO8uzvO0/LYSi3vVVdptHvJ1Ze0QAxT4w7KQ/DGCJQw6cRM2Kk8QHPoMjxmGO5jOw8
	p+skOLzGxKOIF2tGZMdYVJVQKBx9q+Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758729160; a=rsa-sha256;
	cv=none;
	b=3QIiphJUIuoeSY4p+kBkbvk1QMpVarbcRiYU8NBmVDtfi2Yu9PqIimrxXiiOKleqrOqDRs
	YAa2z1zLU4GfxesbRPamIlSQE5eA+n4MEdSkzaU/8Oc+Fn4zS3SITv/r0Tf88YJBPpOcpD
	ACfcZZTvpc1JUj41z6W/JCSy/2VDLNc=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 25 Sep 2025 00:52:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 25 Sep 2025 00:52:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNQTw2JRYfYDcafv@yjaykim-PowerEdge-T330>
References: <20250924091746.146461-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
X-Stat-Signature: ejjgdh49quk1w6h5ybg4psnsnurzoeyp
X-Rspam-User: 
X-Rspamd-Queue-Id: 916CA2000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758729158-334288
X-HE-Meta: U2FsdGVkX19a19B3YZOBBvjYB2qGKcMXqhx98Wo9YXooY/QLyar7xavoB8f//FSg+OZkFriqfCS+16R1iuYiRjL//oQBChFM6+YCAlWmlUaqV5DubpZ+OaQkejR65eXZ1uBy7GdhIebtfZBzL9fFmZyNXjz65V4yrIYZVwtEbx19l0YxpbFeF6XfOGxY6lQWJ4imkv5BG78zeCnOjya73hRZX9NnFuYwppyadBj/PVPmeOVK8EZIehDxQ1CFD/59wdDFgd871ohBD/rSxGarHd7HLw5duOQjMfcOJk5Z2K5hvkzze96HGpwE4lcnnf+fj1WL/FZlPY6btlspiEe5eNm0IgK38gij/4lRT1HeMdn4U1MxH/3z1T1T+pVsUf8tuXfwJ/gU7kO7jIfY0R+yobEkWO5AhXCcbEwlVA74MDXoIidyQyRMU5uuk3Mid7UHaBI2Z8oKchnFyK50x4zlgPBgTiItsYycueSB36PChRPKNjCVaSsy+7dIVaDuKN08An8SEvNsvVG0+jvYmTUOHuA21UZxOo0Lo1TpEgggq6R2Hr8V/HeutFQvIQMI/GeRR3zbCkvT22+sC42iOTVkoIzh7gkmb0JSG+gBw4KJs7ZoItno4V7zCBdLmWV1AUAxmQ0iQOD2I0g3GZUIV9oByMZ9n5i1E/rAemRUibaHhWQaGz7vCNHXC5hiy3WATZfLiaOJ24mufTde+QpjYkJx5BR8iKuMWhhhWNHuGCVrdJPlqkKrEmX2et/iSSI9esPrZ1iRXsFisurbtxGXGNqRdwytt1/TO+UWKKUFNjuZyIUCM4LrzadvLywAh0Jw/tUv92uQS450uk7UiW++B6vtcMChJrUcusvEos6lHwS0t0u/PksL6J7taDazqJOhlpa2PKAlfTjpo7IVhpaSj/Yo4JMtsl3YqQMMnNMwmvXEbctUnkTeYwNhyLy7clgb7F2JdA8+3a2sOsYY6Kcfnka
 +UUAEm1n
 42DeW737x5o7yHpa/iE+m7SR7OEsw/M6wO0TXRun3AbF096wdkTyBaNl9+Auodi/ME/xhNFn9vo+6iDhjvSEdu03Oh1O8IL3wBMBT3Olh64JSD9gDG5zJyt/IIx919e1WrtowY24kvGozJzyDUPReTsQvl3MGv173P6okux6b3Rw1WMfuzQIpFCaI2+cek9FZanMYT3vYg6YQC3B5WadUzk10uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000172, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 05:17:46PM +0800, Baoquan He wrote:
> -		lockdep_assert_held(&si->lock);
> +		//lockdep_assert_held(&si->lock);
>  		si->flags &= ~SWP_WRITEOK;

It seems that the commented line `//lockdep_assert_held(&si->lock);` 
should be removed.

Best regards,  
Youngjun Park

