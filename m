Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90426CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB41E8E003F; Mon, 13 Oct 2025 08:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BFD8E000F; Mon, 13 Oct 2025 08:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA14E8E003F; Mon, 13 Oct 2025 08:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9EEC8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:52:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8084DB91D1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:52:58 +0000 (UTC)
X-FDA: 83993080836.09.272FAC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17112C000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:52:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MtH0JWQx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E75IyfOrfv/qI6QxAkHeeYyyj4EABdZeTn6ZKKMMo8A=;
	b=Shv0fkjmrBwiqZpw1YiefTI+L9BmZHYdqHjzspjbPFS0VuXYkZut/TrAkF1raLLoLRLEVy
	U+B6b/fBJsq5yf7O3Jad7o7VcsfMh9qxfzGeVfCNaVlJPJnSZwmyxTLXvHWtRetZXJrv92
	F6jCj+1XfSN70AM2KUBFIcxSnOhmjQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359976; a=rsa-sha256;
	cv=none;
	b=PASYkr5oHjdBvdUubz9UpjRB7GsK5pqcUt+srKzCECqV2BvT4c2rzTxS6Qj8yedQ2+6kCU
	aCWfhp2X+7LCIMwaSdsWjQQNijTsMtGRA8E6PMblVWxYElhymXOJVMqfHN1y05Xp/ILrqX
	coXLNBVVv1vEQm6vMIIT3MvqPvSjArg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MtH0JWQx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E75IyfOrfv/qI6QxAkHeeYyyj4EABdZeTn6ZKKMMo8A=;
	b=MtH0JWQxOsm5XzmDAJqNQHkMaYWINIFKT5nxtOdytNTmkRF/fPToWZ+TqQmEdW5jEuhjHk
	gae64TCpF44mkMOr4QfbO4GRiQCjju+rJub5lEa6zIvof/pWnVr+cZvPA+zKGujnIWkWqx
	LJfV57xM2dC6KNHXWJIIc0kW0QXJjVk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-Mh4IWzqSPdSb8wc7lvmYeg-1; Mon, 13 Oct 2025 08:52:54 -0400
X-MC-Unique: Mh4IWzqSPdSb8wc7lvmYeg-1
X-Mimecast-MFC-AGG-ID: Mh4IWzqSPdSb8wc7lvmYeg_1760359973
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e32eb4798so21206015e9.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359973; x=1760964773;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E75IyfOrfv/qI6QxAkHeeYyyj4EABdZeTn6ZKKMMo8A=;
        b=kdhRU/80uoPuCgrnW28Y7yEGDufc64rJ4jkwuuJZS10n82ajGcXEpbNjcw7cawGvab
         BtRCJ8JQZ0KMLgjBPLnSZK36O6YumR9BS8GKph8MEF4I3Oiu7rdzmv8OHR7lzLRWV7et
         BoLlEqMpXq48aeXMbRxTmCBjqI8+ulxDH6wCzwKJcq+/Aez5VNiN75s0chDEEeaRJAbz
         oISCoejA2caZ2ugh6QmfBKiGL7D4DfGvLyiMcjelgtXwCv5ymbP1MkLihY6ZoFCIJ//K
         U0xdbCSkZDRbY6ahQWLk/4ZD2c8FYrAh3fLw100dA2ofC0TlNVQhfFzumnzr4oJxCWga
         tyEw==
X-Gm-Message-State: AOJu0YzX759KSKXlJ9CxGLlcIXTMnvccqL+gcOjx8f5GDG+EIv4nW2bk
	ta1iNuelES3nZRrDXBUdeC24aVWHLvDLIEWdVtu8Xx9vkACQaIW3GQxWnkDyAOG24TKKIVweAkQ
	wb5pvyWLBE3cfV0V4Lykevr1MipTcXLI7s9clrw7Kh1p4aVZ++bSq
X-Gm-Gg: ASbGncvYa1ZEiv0CRZTM6EgL4wP8KU4tltgShtadcRaTdilDgAgEmppK4NyiZls2EPq
	FLd4fyZj/+5onvHs3++4wHPQY2s33SGfiGY17AqQZh1qzBNy7qVlJDadERSsZFoXmaB45MBISoL
	I+NzRpFIPHGvo/2RZ5w/JgAZDEtiwE6eVRMzx1Hex4As5hn0zko6T+16l+AQ7QPpGHLRZanNmSN
	3DxJgzlTvbK4vK84Q4gGSCR26fhLq0Fz/+cim80zKJa6bj7p9YA2oLm9d8hOZjYcgOV7ZzW8f2M
	locLS6EgQkg/4Jd2cLDppXAmeHOCv3IPpFQSGtJndIkuaLLMgdleFwW53PqEAQ1+Zxu++07fS3D
	H2W4=
X-Received: by 2002:a05:600d:42a4:b0:46f:b327:31ef with SMTP id 5b1f17b1804b1-46fb327388emr70124635e9.12.1760359972814;
        Mon, 13 Oct 2025 05:52:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkw2x7jJr9BqXparB0Wt92xBThff0Y9tXK+wrZzQTIxxhdwOYBJnpRxdbd5+QsFxw0PVSRBg==
X-Received: by 2002:a05:600d:42a4:b0:46f:b327:31ef with SMTP id 5b1f17b1804b1-46fb327388emr70124495e9.12.1760359972387;
        Mon, 13 Oct 2025 05:52:52 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab633cdasm126476575e9.9.2025.10.13.05.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:52:51 -0700 (PDT)
Message-ID: <97793125-1d05-4891-ae38-56e3994d4f66@redhat.com>
Date: Mon, 13 Oct 2025 14:52:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove the BOUNCE config option
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
 John Garry <john.g.garry@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20251013095620.1111061-1-chenhuacai@loongson.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013095620.1111061-1-chenhuacai@loongson.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rwi-ACUOYv4ieAUoe51aoHDEhN_V0Jq4YYSWlxgV1cc_1760359973
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17112C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 6d33z3d9be9w4n84wag6ag1bpcmpug7r
X-HE-Tag: 1760359975-219812
X-HE-Meta: U2FsdGVkX1+sqKQfE97CCYI8JZi/ZHb2U691sezdOE73AUYNaSViH2fWzbnUshP2hpg02Wo7Rp2yGNm1nzNjN9G4fxMAb663ChQIYPvKHvIN3c0eTpvTx1AKSRtZd1BwXpurb3SbpfENe7c0FC2Z/FqYE6LCNTkf+WypSPziAN7rIq/nUrDk9lZupA9DIWoBgzjSgStbCtZjYi4Xrgal7QZAqqtGh7tK5j5FMD+nqo1K9pxXrFPnpEJSwKQ0EJtTxrQFO87cIWleAb9zECpf8/20R6npLE/YVENW/nPc/u9a3Rj0ptM+xWLZZNZ9Bm4RRxmN8VJL+GhupFPeqQRlzJNqPykpINkMkKwpVsk/hzZI3K7sUp/MS4EXpy0DzyvTrZ395YP/Bc9WPhLkZpjgBaKoTvhRA0vvQBx+42qB1FCcB9B/UU03eKu2uxonD1+M/OYfuaGcx/v8P56ZR/FBHcqODFU/N85FjVmS/y9sSznA78V6FdM0lTPN5XjHHRihm8CmV4YFzeUJvfWzTfJE+nJKekNSSpLsUW6V59uwj5XeZpJebW7H0CPVyLfM+xMdAyviR4tkwmv9j3M9/1nvkGkt2KaFVeX+XPzBAX0yzicsiNCxJzJr+oGrs9ffjPNqNnZ0VNHaPGu1r26uZ6snTWgCn1I709V+ydU86cV1RvHi5bs7FYDOLvaIUc1nSnCicAZIx7Zlp7R7suH3Q2Co+aoFozwt+sc80J0mZr+QQVw3pXexvR6JRfbUibt/TN2n8LhSgEOxQfWiNezygW+0PPzMBJM5xihQR3/fk2oXbLSJP+xmh/e1fB9/tYs2pYYhtUp/tnAdx9OOkEL36kgcdPR74g/t3mQEvZuveajjBmO2eLNEEAqytM1w7ZHQKJd9lVnRgcHUxf6VVNsznFS/Y4ilr++iOyid4Dv9s76LfPVLebNAgcmny98F/JLVJCt2ITrDA2CIBP6MAAkKuA2
 2zI6UXJV
 JlPNUQKrxXtwgWfcrahSGIxlYJdOSqErm/zM+OULtf45JR3w/LlkONKF4zchwaiGglFmAsBOZfg8oeCLSHz8x43wUUX0pjQoZbxcRLIz/nWBijLlgVyjXeqkDh13MiWGfc+BcbrSGDU4t7LnMIjmsKVyjdqAI14KGAt3c3r1eXxP3hy+0N+h4WKQwxmCOil3x4QL1rs9v5tqoIucC9/ymXfG2D2nr0XxysTEWTHdfzTog9unYjkFXS/+cT6RBjoFeVvcCksB18WWFAvI0swwVCrJpgbdKD5XOA6qHihnPGgxppsnpogZtj2eq1vddcd/SCQRG2MzUIjnheXpJ5xBZFzQL2aJLeJpuskfswPzBGx3j+QBbOj3Hca1VZz2j3JjnLSDU5EPPm2T1UVDLq2QzatqlG3n8N6go7Ufpk7TE6H2Q5Morh/Wd2+7kkq2XEHyXbrBFDIQKzzAAwSUJed9KHIYyyenMauoOVTX6He25l0F+5LR6R7Ag5lNvKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 11:56, Huacai Chen wrote:
> Commit eeadd68e2a5f6bfe0bf10 ("block: remove bounce buffering support")
> remove block/bounce.c but left the BOUNCE config option. Now this option
> has no users, so remove it.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---

LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


