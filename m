Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F35C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 02:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF396B0099; Tue, 22 Jul 2025 22:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6E76B009E; Tue, 22 Jul 2025 22:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC7F6B009F; Tue, 22 Jul 2025 22:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1716B0099
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:01:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB48F80574
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:01:37 +0000 (UTC)
X-FDA: 83693877834.02.B433B74
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F7FDC0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:01:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YqivYWZb;
	spf=pass (imf22.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753236096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2nfG3RkGyxdRtCt7H1YeFfE0JMtVWxt8Y8WJZYyZq4=;
	b=zsinbGKv1nyxs6VD6HZKe3T03dcFu7GdzMd2OHEgMy3kzpJJOkr8LHProLXOySWh2xMKnA
	4AuEexWVQA/VH80JYNt8HYmNdCS1c9yEbxbdte7Vl9UX58WLiPVGwGIKsFkrXhvNnYPStp
	njWRmFamEdbmq5AWNCA+eDIfDCzw1Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753236096; a=rsa-sha256;
	cv=none;
	b=Hm3ikK85nVyKexq9JSWOARtAdEvDOSol7W9ZlSei/eCfJ3+1hrt8KQ1AN6I4QUE4DOrBt6
	HvqFapR1Jh1slCAb6jJ8c3AgS5bF8t//YLZ1pY5scfTXRSdYJpxX8t+KkDMYv8h0S2IME9
	IkIlZN8U8/y/FzTY6Hr9jrumeYnbauU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YqivYWZb;
	spf=pass (imf22.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23649faf69fso50210585ad.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753236094; x=1753840894; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2nfG3RkGyxdRtCt7H1YeFfE0JMtVWxt8Y8WJZYyZq4=;
        b=YqivYWZbz7Pv3lNtC9M1mO3COsXSmsPYx8z57un1RoGZhzFbdHIWXM+DPqRWlaXnv7
         gN6kRqL9urvSF2bjurPjodK817az3z441gEfrr/4jk0rq0n8+ZIMVKAsUhmcgOXPkBY4
         DkjLmkIafZA1RKTKx79gnh2lYKwO9d21y7LTp1WzSK6U26H1hHXNZNS7t1wpmpzlZjIU
         1R5k9mOmUOxyjqsQRXvKyRS+ODt/nSZyaChlBBucpW411vAH28eSiOjzbMU/yiKJieQt
         j1imgwAZ8qHmfBmLujWegDAmTTJjY/Q7W5/cBg7xPpkvZJuEoTyS2MSTA5aNNvrDi2PC
         78tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753236094; x=1753840894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k2nfG3RkGyxdRtCt7H1YeFfE0JMtVWxt8Y8WJZYyZq4=;
        b=YBaMprB2W+RepX2SpD90M1gs2kJTteilU4ssHmM32u83h6VhYbN+fsDMvFQUiqFvsR
         1wKSiuW7/cDSyuZ4GhjNMfCvbkGsmmscHZLrM0ryYIBo4jnUDqZ02wSKXpzPH93C+zku
         XkGu1DXmhkg65KI7LGc9yACUg89MrDHoK2rbbeu7yYWl3gt2d1VLgUdFP/yr8MqgGSbV
         dNqWAYj60r5Ejbo5HnnnIIxBC4GJ58w7Azew0882bdDWYntv3qZi0608ALshJ3qIxeSt
         B1xGfcc3P4BToxpBYcItyYDZE/T+ztGT5OzeizfuIfbgoXO3iHpa9hEXS45WhrVLSL/V
         jeaQ==
X-Gm-Message-State: AOJu0YzHkuGhy2j2NG4WiiUhHUN9mIqFQkir+kgEG6e2rkzJMNTCm0sr
	hu3/DyCRxQvJVqqr2XKnJhFBPlHPOQ7lTQ/Nr9dTV5s8zgxu6j5eMzLWDx7jYCDCO2M=
X-Gm-Gg: ASbGncuChANrXpAIcw4283DFBg4ne2IcVTWiqqShEMYEcw3Nmw7Uis/RC7TDRoRpdeG
	YH7AZEs1n/qEMA/R6AZs+JOhp91RqHfWA5vca8YWEotNsFQyGfssBECSXtzeOvSQCt0aY9AYyYE
	tRvEuzx5tQuMU7YXS6pzJ/jZJeUVMSuVITapTA+U/b05OrGV6MW4/cqbxS0++6x8kbg67gXWs6L
	Gcy09FJRvnLYEwD+WeeDa141+oh52d4hPvGLu/BrE2KGeS+qsRjTkjNarnuuiN0HLHQcL5d6CsW
	5MW38mZ3ThnAh+z29WbFBQ+wuH1Kessbcc2rV5DELNu5twLjoHJ1cyyVcTvDfIeX7rvfJL5d3YY
	9Jf0qzj7MxQit2FQnPGSt2dHcZV90qzVjYHJFtln9gFeXI0zBDQ==
X-Google-Smtp-Source: AGHT+IF5FolGDxDjCz3RXfjkcoB2iOMBLaRYveOOGPG9BhEe2BtnMh/TZbx4CEOAC4Vp2PiQhFQuxw==
X-Received: by 2002:a17:903:240f:b0:234:d7b2:2ab9 with SMTP id d9443c01a7336-23f9814af72mr19875125ad.12.1753236093834;
        Tue, 22 Jul 2025 19:01:33 -0700 (PDT)
Received: from [10.254.226.168] ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b611f85sm85414335ad.64.2025.07.22.19.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 19:01:33 -0700 (PDT)
Message-ID: <2a6ae560-6e7a-4a78-8022-e205cf274cdf@bytedance.com>
Date: Wed, 23 Jul 2025 10:01:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing shrinker files
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>
References: <20250722173436.145526-1-lorenzo.stoakes@oracle.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20250722173436.145526-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F7FDC0002
X-Stat-Signature: bsfpdj47cro158eun67uzq4gweitnwdk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753236095-561061
X-HE-Meta: U2FsdGVkX1852IYPh1mAiv6qwsBFZeWWFiYImQKiNSlbnZsSGQWIwRuNX2fs8HpJyHntv2KRX6LsNe5dsL+2zwbTH7pzMe55qMhnG4g2CdC/NMoegyWvjUKV9r6TzWUIzUGLkMqAuVP4L9ys+Hq0f0e7DP6kXbLwNE35VJw8QoIS+umt9cwyw9lzs/AjPOKilPig1cfw7bY0jQbYxdOpc1mBPNCG9Ss/FTFf5VMXgYjuqdGXiHSEWjRLhSbTDCbuHduZQJBE7EvOXU0cfFcM+/gMisjghURUPBeJODsG/FikFIR06MXQiNfpsA2X06j8WKB4Up0tSvCW/MCanRtT7NJqmh9zHnlnLoL8DZYzyeRc/pmfdtRl7Ot02nd0/ktyoVzA2Y9HaUuGdRsafPnjk3DgVEnFPdYd5gkKfrtJsEbMaYdLFiCXx40YzoZpufgGsLRiGR2VgPm493aW8BaXG4V+oTll/E33UM2GF+Xg0V9ftLuyCT3OM9MDx6ufGuYt/n9RwjRCZ4K/ahFMjlm170SsL3J2L2I5P8HCzi0MmrMJsmLZSVoC8g1tfja0uv7oDjTZFQIvBjzJMeeoomqyXAfhedh8qvk/O9gkkjzk1g7Djs0zuk3aPjV/yKV7+7GWc63A904VrvuE31J3tbLYNirEA5gJ3fKNUorxkfBQHDeVa0KMxpM/85r57+pQyzA+00sWs7pvGWM1gfbc8a7OYSkKERWv91uanQvthA8TuRcaksO5Tr5L9vGXhClFKq2zFVytC4CGmeRsMWW8alOWoxMzq36Wa5uJaYaBuafeJ+nTcdQhXWwPl7nBceHCch+vFoFKZsICaN0UsEL4d2vAYYpzbAoz07F+dyf7qZdfvB+BwKM0yVu5CChhDUQlmAbc+UvawPwgOx89tF7MXlzrKfvFN9nXfHBn1kqjkUTse6wvuQ+rSHobGu+Z0hZEKF4UZwp+nJo+Vm5Sd5g81Zv
 nN9Hvr0X
 eV6eIU0vPmyxwj0mJEaugDlLg8hybRKAl+i7JHKoCKZbM4GdpKEXas7374GvW4VUeu+n07dy6OapO3/+1VTps7DE44Nf0euBMUFY+t5bDRLRLSup0jgQg0LEKGnInWqIvFIE21MJHkbardsgzFElYCax1M3vUgfIUcwNGlC/LZZbXcmw235nbF+u9q5FvxOcMaQD5JvVQeTjixyez2Rgd3JVgtm/wBczgKCQEYWr/XA92nZIlgfVTmk48c+/MTYyEnhv5u8AxccWpaV92A0VrqfExG3uLWncgtFR76sSMewGAlABEg6+zxc5/8LLY24JQpZOT5Me+QCJlx46dF9MVDKcvFsa+JTJO8bp4XtHCqhxqr/9pHe7LWQB6pMm29E359SSPBTlolWUTxZo1ckXOLH4VB3HdKQCxk1fDwQxor2/pOjQYzZI6Z6O7Exf1jhc4qZ9ClsNMm1IHHWm5YRZkF8wg9Ipk+K90pK6d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/23/25 1:34 AM, Lorenzo Stoakes wrote:
> The mm/list_lru.[ch] files implement a shrinker-specific data structure so
> seem most suited to the SHRINKER section.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..d1878165f2de 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22631,7 +22631,9 @@ R:	Muchun Song <muchun.song@linux.dev>
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
> +F:	include/linux/list_lru.h
>   F:	include/linux/shrinker.h
> +F:	mm/list_lru.c
>   F:	mm/shrinker.c
>   F:	mm/shrinker_debug.c

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks.

>   


