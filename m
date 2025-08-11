Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9540CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 20:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336AF8E0093; Mon, 11 Aug 2025 16:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E76E8E0091; Mon, 11 Aug 2025 16:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6108E0093; Mon, 11 Aug 2025 16:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 093908E0091
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:08:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB38657A78
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:08:35 +0000 (UTC)
X-FDA: 83765564190.15.90B95BA
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 914B6A0009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:08:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YYLOBnGk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754942913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLEUl1LU8Wd86Kf0RO2n3/0VCWmQgPXXz614kfQpHU0=;
	b=YdxG6YDvXrQNAq+IT+43mQxM747DuuOD/axCdGq8ERTQxJcq9L3jldxF0q9CDVFYFGsS9w
	oCPOgjGsLwRnqs0lmr0C20iShSsbmWMK9PX+xa7xHU4ioW8snoUBATKffSRwytq8yhN3vZ
	f7x+RJYBjac+jL51w4xYy3q5ujl0zb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754942913; a=rsa-sha256;
	cv=none;
	b=3zoKG4NkGHwiqsg4rz0MXGeKgNpht1QXaxGR/VYCb1s4dQzGPvIbZ7TqBh2LBwR4CR2nuy
	WmHogRS0oI+gSJY2t7p0KQZYGuErUNFDUgbwn0NmphfVtUNjtNB/1NHHH3H7V3z3Y6qDON
	yC0jGaeWRob27R90YKlN3mSOfTacNdk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YYLOBnGk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4245235a77so4011099a12.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754942912; x=1755547712; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nLEUl1LU8Wd86Kf0RO2n3/0VCWmQgPXXz614kfQpHU0=;
        b=YYLOBnGkzKFFQauWu3msk9YiiMvV168rTtzyjyOlNH0KNWfhR2ET9N435ng0DOsdUf
         lYN/0WR4UnbwOPpzh8FSRmX+7JgkbiI2fWWrzEZ3n0qUlljFBdewxabRI95WUpqvULXF
         xrDwmhwX0N6JUuWtnvSqV+O67b4PoXkHfT/kXSIGOAkvsHbhY5j9s/4fERALbsBgCk9V
         6t1hCQKzOOZPezMXQu6Zq28C8u5styXYGO+XE7H3E4GAIRA7Wr5gM2NGMkgC09MWaRk5
         aC2RHWSj5O01VkW2EFWh6f9/fevsdkpPJQrtITUPqb3unNx0F4i0q24GR4NccmA85Tx0
         OOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754942912; x=1755547712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLEUl1LU8Wd86Kf0RO2n3/0VCWmQgPXXz614kfQpHU0=;
        b=ECAnp/DnZcUwG3CGD1d6vt8KovbEY5IkRP1ZYUxDtz/ryMDZwYwFJn45eTdSzNQWim
         62XuyyOPpEUD1jBdv69MjWuxxKSQrIidiKaynLBgTpf3oN3kXF27Qfw8xMDpGummY5aL
         UmlHGfpZ2P6sisHlRvMLRRSXc8WiDgeIqU/oX8ftZM/0FiYH3K8NFvwzZOVAICtM3PJK
         WlLDzmdSIwHdA3aC1Mz75FGInu0qBpD5SvpTaPuiQnGGqQTFxPE7Ug+38UHKc0rOZMcO
         04yXRh5sp3fUfpEz126RAUsYoG6neDcTUUn9jSXMZytgcVX6vXApwcDaEShV0kv7fRq5
         i8PA==
X-Forwarded-Encrypted: i=1; AJvYcCXXiiJRjhhHoXOmLiQ6jbMFK/ViYPfNjaF8YUwSGZhfb346P1aL+SSnh1dAQkuZAMZgmp6T3wr0FQ==@kvack.org
X-Gm-Message-State: AOJu0YzISg46LbeBjnnpajcf8n5QAXnI2D6elnQyvnecCCImFldcSk/o
	wwCJM2Vp5bzH7kYDCpsuhBsWGMHqG9lySpaXWok11ZnCRIxIKA1X70MZ
X-Gm-Gg: ASbGncs+bcFZ9866j10ARwnpGy41cJoIjirfF8FJ/NNVcA8qD9zhiRLbK36Id2+hp9c
	64RRsphhdYtGiX/aZzELEAmyZABlh+qD6wbRW1I8+t+gWSRjPPacjw2FmjmSyRjAirlcnRGLngQ
	KjlTZoMQPatU2FKxwqKcFbMbwi4JuAYDoh3wA0+hcLFhMKW6yB2Rga1rlXoVSzEubv+oM8VrxXl
	1094LtZdlOrmjIw0QTclaur+M2Wrex/ZTea69PE7ebmUccLSDokSUp7CgkIHlIB9klO03084nlZ
	wWqF0ZQhJxm/Cg9vq4IMKIuetOBO04UmkCLhilo+8c3cEJTdt5gM7G1Q2TCy1k/vTWe5WPKQzsy
	R3oszR+EFOGBzNfdMYV2PtyitTa9BcoTuyGoo1Q+SoSewqDhBXRxR4A==
X-Google-Smtp-Source: AGHT+IHQP/gjpkgtgU9oCrE6WZy0pPW8gkPGtnayycj3g78Wo6JoWQFhXmjRrQT2ghZKKT8uPm2P7Q==
X-Received: by 2002:a17:90b:280e:b0:313:62ee:45a with SMTP id 98e67ed59e1d1-321839f2b35mr20590862a91.13.1754942912368;
        Mon, 11 Aug 2025 13:08:32 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3216128ac08sm15547043a91.30.2025.08.11.13.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 13:08:31 -0700 (PDT)
Date: Mon, 11 Aug 2025 13:08:29 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-ID: <aJpNvb4ehfyk55Um@fedora>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809194209.30484-1-richard.weiyang@gmail.com>
X-Stat-Signature: i9ybyxr9ymnee364bj7wcmae83jtstgu
X-Rspamd-Queue-Id: 914B6A0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754942913-588400
X-HE-Meta: U2FsdGVkX1/W8/PUytdunWb+4vwF+6FDSDckDcA1ZSOZqGi3FEP1fVCZjGRsqSXKgApKwwVyrv2iz7caFTgXTigyPQS5tTBjWLfJDkyje5rAr1MDt4qUhUknrk95kHtE9LlFFM5AdaXtu+W+dGwtY3IrVHY5s/8nkINdf8Q4r0XFx6a/qnpXqlQ9NfSUgfyW19Ex3XeCyLuTgXOD17J5+epFAzZFy6puDLJFWFWR7gMG4ICaHZjAljh8gV+WNuX8qhUDt3sb8a6nIqgqPL+R/yB4t60KnT2sVdJKe7YPF7AHSWp8vge/k+e5GyYBGHurUxHftnCR9Dbf0xRAN5kDExuess/L1SzHQOq76q0pVbylAP7y4KemEuXYkqauZBMSV+20s2WAOAGDLCToOU+dyktLdduIw8rJKJVPjHbmkQZu9irPW8hhF8YHQsSqcBjLmLmDH0I4iMdsWr8MjurjH5biRmzkOMifrKqBodRzhnqI0A2/HfGNJEdEJrANxy+RbmVz6hX1ngf0W+0sA2Amz4J+7yDV7bzreThoEvnWgjDAU/n+3/rvxD683321IRkYC7jV2v8DCj/uJ0iYjv5oV5mjYgObXVl7fJ4udZMcxlIN3g2+GY0EVOPERSzrjMtkKVHenaopjHFPRY3BAMInDvYgjv98js4T3rLwBjm1szVcVcXSfJV2gliaOSAUGAnJFWty4pMKnbKkegJfcqh74zradvqSnOP+7uBwmu1UBTRalfz6dkkidA0dVCG9Tr+dLm1/2DgrlzbjUHTtaXEEqbXxmp7lr1DJTlZjjFn9uyQ0ECKMP7ITSVEIK7L3PcHeJ20vLgOKvkZoF9lKkWqM7a6oFDto5R1s/flefzvmtNjyz7ZKkGKopKnZQTVKi+ZS2HvRq6TeskKDeYvCA7D/oWRdVsIG+SFX1NliqCqeMP4SfTOjrQLjJ1fZ+X4yOBKmmG5N26DR/O86QO/VXI6
 ZvLF8OF7
 WvvGrmU2josckKi9wIiZmAO7kB2kYYspz6Q7H4NpsgWvf02fj04GEXsG3pfFoHZ8b8TEjNwIZPxxIFO2C8kMqIR7m3//5JwyjDV5OSrJ5x0HdCzWIOt4YC8cO8TUCb3AdBKpe5zK5wE7a8NAZlvr1NnKQZK01JfvV9RKoaYKi+kwKPFluaUr6HTllJMPmHYNzaSOPjUZNfDca0qwYWdG+u3b0Udn92x9LFsIcH8/VCB6tdXFAN636Gz7ct8WW5QYdrr9alidioTGNmlhiSw6Vww6CBhYI61DUqIYeYUL0mgni3n0HUg4taO6H5vl9dbGBPJvUcYLon0XDJgHp0UIFdjJxLApEjBqp7K9qt1lynE5Mst37MyyOzujwUI5EWeLhtBZM6Z1x6yU9GBLeRElm/vzG8hlsqJiTVvC6KakEftHbMyB9+IzZytYKZ4OLLM1lyzth+kNTgHfHl+RQk7gGR9cigXP/din9Ov2LB+wbi57R9Tg7oyzdwyBbi9dIQeqKN8nO08k56I36SRxgH0+cCtFs05PFR5n38UmLq+dM3L+I3qr2zb1Vy4hv/YlUD1QuVO88KTrrKBz9zRcwzyVslF6uMMaq3x1tcMa2ZeyKMeCK79i5bOko0aNx3aEVQzfUCxlFUPBnfXE3SYnPNqxSWBU1PkZpD9k6KeMxs0plwqWGi7J1Jr3oiHcF5BeK+4cygCjkzXONjG1Ley7mg2Jjax+4KyoRe1eYr8DCJP2P+YBNPGXXb+EDfjesML8NHnSbBZ1l3AE4CgM68bWV+iPWGZOibg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 07:42:09PM +0000, Wei Yang wrote:
> Currently it hard codes the number of hugepage to check for
> check_huge_anon(), but it would be more reasonable to do the check based
> on a number passed in.
> 
> Pass in the hugepage number and do the check based on it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> 
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

