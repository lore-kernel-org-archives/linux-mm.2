Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7645ED10397
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2346B000C; Wed, 26 Nov 2025 04:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9CC6B000D; Wed, 26 Nov 2025 04:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6F26B000E; Wed, 26 Nov 2025 04:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEDE6B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:42:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8894B89716
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:42:35 +0000 (UTC)
X-FDA: 84152268270.17.FE93A9A
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B410100012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:42:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxFZDr75;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764150153;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqY322QR8ZbJ3HgFYPft0O/nDEFU+vcwPrmSsqV5/J8=;
	b=DLEnwPfb6rUvtkqitwUMc6wsHnaiHQL7/4TIeghyzJxx1Ki4cP3zv1jyV8fynksLMlFaKd
	VVle0AcXPyXOYmE7ShlXVP8SFHXliwZCttsDtH2lIW2NmyQZ/aUgw5H5D7O682z8BDTiT/
	se0l48J79ZHqyI368xqYC4VQe+bB1ZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764150153; a=rsa-sha256;
	cv=none;
	b=NPbvEYwulJa7wd7kJRwnPjaAFfs7wdFly56gwjjgbXd6K155rtMV31LPO/lHo65sRTeXyV
	7CRu1NYOFfJX8eGoLOX4t4A03z990dI2WbGoW4Y9FzzY4BBd1r8qfrEsFJ7fsTizsdsKWO
	I3gqnkd6HMjSkJLPY/Gx2I11aJoU4xU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxFZDr75;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7380f66a8bso973675366b.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 01:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764150152; x=1764754952; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqY322QR8ZbJ3HgFYPft0O/nDEFU+vcwPrmSsqV5/J8=;
        b=CxFZDr75N20DL9xCljChYm/9MIWqcq3gCXDNA3dUFpHx+p+BdgjO7FCmgiFPhYsCiq
         I8KMXfwIVge/HBWUPtrmRf9oRw+cj3FqBnmXsRJzAEQC6B3KvwuJMaUu0R4Hb47hyqqK
         DavqXqzsTZb/w3cTXLb8y1bVGzX3ylXZuUU5j6YHYyzSOtJoNe6uzEVJ4GyIqFP9ij1s
         ol21MzG9ZpGwWaCnVXh9LZFO7VQyszh5JXF3lXdcT0BfcqA+q4pHHGKBsBDlt+NyIrZL
         3FHlGmDX2cy5D4SzkeI5wjizDH/Q6e3efjumJ8ffJx0OmXcJ2CND6j6tT+zPTcS2zMo8
         4FPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764150152; x=1764754952;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqY322QR8ZbJ3HgFYPft0O/nDEFU+vcwPrmSsqV5/J8=;
        b=gOG/z6q1tjMDjXoK4iK6H+sVXSteXsUMFAmlspo1ePaleKVPnx8Y+FF5AG/wMJuuRR
         CAmrqpxZkfjRvbKaxo8Fg7F67DBCSq6pxFcD/duTMe5KDP9Kz+9IneFiXNCmbP7s7fsj
         l6NUWilfwkJwf5LRU6RZrVCOJYzol5VFwBu5dsfU3vj98prIzhtBQ814vjAD5nRa5ujY
         oNW+85E0sJrUq2Alk8KbzFUoCX7zoCEru/6TjAO7h5rupHwOeA6pmB5DMnD4QF9V3Goc
         tq3xPyLLRg/amhf0FS3oVvPUJOuFgZ2QrtYJLobyg9boVgXiTvD3uJJNfHMP6U+WkFXH
         RHDw==
X-Forwarded-Encrypted: i=1; AJvYcCWf8av42HTzpPI2pLXJOX07L8vcwO7bkKAjGQSzYyH0/igS5WSBP0wOGrhDJz0CIlcsgDTjdOYAOA==@kvack.org
X-Gm-Message-State: AOJu0Ywt0w0qeIOLqrvwgdZAvs+4o5kF8p2FNWvH2F+tyta/TiRe6F3f
	CM2TjHXl2vXqBith3uqNvK45nchwrMEicTg4WNpZhI1dW7bAqMIhGyGR
X-Gm-Gg: ASbGncsbT47srbhyH6gFEIm8Qikq4OjDH9XYyaoaanIybhvKLcxkvNz7UhLrDzvRa3w
	6wHXnVln3GGCsIiqer4XvZOPgYLUueLC/Og0WBhLE+gOpJoBSIKYYSdyqhw+R3hwhHQgpX/KfKU
	JnPBJAvhp4AynVp1J7wE/sM6RzzwLF7W58nbhDCNKhJ0HT5ZPDyt8wE6XmIvPZ3la4FcEnoYCcZ
	NZRxDcqSNNCn8Q+9lAgYqA5lIOf++q7k6uFMvQloCO7ZFrMY7NXHq/wNZ4GlkxxqkzzkEPhoZ67
	YsDxWIqW+fYgELeww9mGospFb8ExdvToyd87r5cy4qHKQYp+tBaOftiK7YYbuejWWmNu1h1ni9F
	NLedzzC4X0kLcmCMG42oIP0YDVggI7e5h4j9J/glD0WR2S3t1fwI5aoYssH/ie1HvG17BqelA5i
	3hPjrgihQOv73yb9Gd+nRF
X-Google-Smtp-Source: AGHT+IHNAkrB/GSc8cS1WfrA8x66u+CjIWzmcyJiNnXpfv9ltCVLKpm+P+31x3LgsVQlKeBnyEkOdw==
X-Received: by 2002:a17:906:fd86:b0:b73:8f33:eee6 with SMTP id a640c23a62f3a-b76715ac4a4mr2063285966b.23.1764150151509;
        Wed, 26 Nov 2025 01:42:31 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdab19sm1931130966b.10.2025.11.26.01.42.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Nov 2025 01:42:31 -0800 (PST)
Date: Wed, 26 Nov 2025 09:42:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use standard page table accessors
Message-ID: <20251126094230.24awteiuhvj65i5v@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B410100012
X-Stat-Signature: udj3cdpm3d1uuqbbhp1c14xszmnw3xa7
X-Rspam-User: 
X-HE-Tag: 1764150153-435241
X-HE-Meta: U2FsdGVkX1+AAHzJhpmxTJMDHwcNJj83gXGZt18fkoMLKicpTARLUAnveo+XPd4v7iRmTubsWKXegqywXwp0OCUVwQLeR59ztGMoSCgk7ZOyt3IiIijyRsrf0e2015oq9gDhFLBF4HbcSK4sLwpCq4/u4qZUDxpVq0HxLj13kC5yBmkXlmbu+FJTnnEwV7zfsQiQmqML1jCUhvR516C5cn6hZvwbL207SdQ4vchB6YKmKjpNTyuUwnAmh9MgfaV9INkGHr0HVIBikUQWsmek+OZT9ahWGpVUfws3H3bHw9CKvL09S1NUOnTzkPCgP4/shYYDhzmmR4yRBQvT++7INSkRkAOA3YBSqV5MAdKSAx+WR273dQdPM4BDo7ETVFfdbdDCoK2ug1JX6xW9qGjp1sDxb8JIyUMwMI99fF3GyhLAZbSZZu+eXj1V1PDZrUlbU81zwO/k1riXVGhj+UPcu6VqLQJbZHARbt7gkBjVwa7hqDvHbUjrnQBgOud25y33Yv/BV0eLITl0mZ5NjD78+Yr7CVNJ4ZLo2SPobkrh0U46dfKl21SStI23siSZkoiuQfOXB6OAcQUsoFeg26tMuTEacE7N9wQoXXaIvvOB5S/Nx7Xv8+otoyAiwkyAZHwKM9bHLFEUbQivHTa95TktldWWoJhOqDSOOU9Wam3pcUJXOvyR5Rea9vQ3oZu1xVWoQgXrmunJBZyXA+1WTbfFDEvvttFSqzdq43hxNTK+SLctPdCAC0N96119WF71zmGkZOPD8FAyzamVy/E/MUsfIiriUG/ovyxyG3QbsWGiTsW2s8Il7JV1s7/donqorDeVxyEo/JF9EutivSGFUQiCT+0Mq/3x9buSVocbRcUsZ0USI13QwMy3xlQWFZ5fFLIcEJb9O+S8OPeM7oRn+d0tgHZz4kYbfRC75LPtWcuuq1Z092+NHEqiRUFMIWX+fDtkSM/IxDAQvBf7MsVHDWD
 eOsaqXzt
 V51zXcwHonaNzAt3tRdbyDtFoNMln0p8eY3oshx3GR/ehzb25Jh49sla0B7uaJio7+nqibwn0EQf2oY1hkFZU/ziOTNWdZCzVTUBTC+Gx9ztgEeJDCcjxvCngAcz2cH9OYb2tY5tAAF3kA6xxchQiEVQioCY1VEyp70PBA9WNh+CbcWdio0TAjukY33uNm6G1DbJ04WOMtAOcH4hp6WmaQqlYuq2kHklM0If9cWpWdPWLLz+3y97Eyt6/HyN/VERKPIwmVFOVRDlCpjcZGyB3cNqYPFmqMp6zs99Txv06aQBOAU1awUPwddMcIiOLY0ttEmfOyIpLL816Pe23WjBwv8XBiind4dp/AGa7Vj0oKoc1ndditCQsw8r6z9jmLhxqeLQH4B31G2FwAnZKDi2xzOM0WbAjGKO0xZQIPTTUl+Y0JBaTTPd+y79/tZQyt7XxX/GS2ENFTD16ahjQes85BT4Oku8Q4J0SBCR7oY9dsaR17pvoQcMclTprJGGN7FsuVvAsv0XFq86pldnFye0OWCbfMmz9EpzNYalG9UZ5swYXJg+kcDddic1pqDcBAflQ48Yt2+K5BdCc04w6LB2HgLR7itz8f8g4OvlN74at1jClQWec1HdAMS/huiF9WsrQP74wdvDWg42bxwmX8RT4bkhTog4tWyJVlhmebhutQd8U2QQcJilLopcXtP+Yq7Te8oMPpqXBF/nIfaCcdBm3tZR6DZ80dP/S2r7A0qjb05pzHFGHB2PFc78EVf6nMcS4ipU4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 10:09:20AM +0100, David Hildenbrand (Red Hat) wrote:
>On 11/26/25 07:47, Wei Yang wrote:
>> Use standard page table accessors i.e pxdp_get() to get the value of
>> pxdp.
>> 
>
>Isn't this covered by
>
>https://lkml.kernel.org/r/20251113014656.2605447-1-samuel.holland@sifive.com
>
>In particular
>
>https://lkml.kernel.org/r/20251113014656.2605447-7-samuel.holland@sifive.com
>
>?
>

You are right, just see it.


-- 
Wei Yang
Help you, Help me

