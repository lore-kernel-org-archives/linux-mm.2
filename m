Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9C3CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33FD8E000D; Thu, 13 Nov 2025 08:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B6D8E0002; Thu, 13 Nov 2025 08:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948168E000D; Thu, 13 Nov 2025 08:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 846AD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:33:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F28C12E639
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:33:38 +0000 (UTC)
X-FDA: 84105676116.07.34D5B11
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44306180017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:33:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7DarnSW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763040816; a=rsa-sha256;
	cv=none;
	b=iRsq4Z1EC77afLuuqwDzOWF3C/uz76s6lJjvHDggNUfkeFMUnrqcYtp5IzcRKuuP29LVIB
	rDR6rdq++/gI7pPkr0TT1Xu9TxFt/gIx7cPKGjSUkt6GsruhkRIopYSXrpUVVFDDyxFio2
	ZeFXxYUTdS0IUHQuDQkSpGkfha7SnXo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7DarnSW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763040816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhHd/vd5PilZlak+JY6GVryWSDKciGyRf9y3293OwHk=;
	b=GYsYR7IhvX1aFq6PvIcppb183zhiZRBtJp8t6sDwPYVCelBIrzPGix/vZjffBhzOgR0LPY
	7XuxEnTWjV9HPT/ScWbCgsWWk97EWUUrA85DodqAkBF2e8w6OltR03DyefUvCapVzjuZuV
	BoNNW6nE+nmdTsA7W5Qj66cDwYVqGCg=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-595825c8eb3so427054e87.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040814; x=1763645614; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MhHd/vd5PilZlak+JY6GVryWSDKciGyRf9y3293OwHk=;
        b=G7DarnSWxdAlXVXnIZjQnwcUWb4ea3yePTJUMQskr35DFzpUjXMfF/ObwmNuZ6Snm0
         ApzZhe+gko1ahdl58YQthlqn4MxBdjDssD4iHkunEO5JMH7iLJrx3UT0qXnxloSKeWla
         zHmzMU6u+mOAWvr3isBBWnNYkLSLHJaG6+G2yA7QpjZzSur6Dcin5lj8D+nbusFxAs1C
         etGPH7f3GXWM/En38vXaogE7mCYrrUr569dO9MvFpC+NuYM7K5tl4nX+GytHZCszJ5KI
         iyt4GV4tsV1785Qeg796ISMAYvU8uAZtvWZYLZIf/rpp33SsklW4AWSZEybbhrUROsPQ
         Lp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040814; x=1763645614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhHd/vd5PilZlak+JY6GVryWSDKciGyRf9y3293OwHk=;
        b=PhoP/SQJxcnpPB0IMkbqKRjVRPeeVpxnUL3b5TTsUn4DXz7zRWfJyEAqiS3LUAI49Z
         qR2d4A3LJQHupNYKi3JIHVXBCtfdA/sNnSsRF2AcnRpMiX7QrsZJ0hV/UXRgMcFkwCeT
         z9QTyIzGHWRdbDczAmW0cKCMFsQP41u+ycWuM5+qRT6EbPZ1nvjeY0gp0+ZUTYId2+GS
         zAIpCJyBXbWmxGKH/2V9A2COD49reg+iGVNPREZZcvY/RRDAEE2qpsZ5LRGBU9yw5f3I
         E9rP5xz1z7SLosJvgUAcF8CxgVliAWOWT19WS6Jgd1zGUCiMYXP40Nhy5KrZkClo/7qy
         A+bg==
X-Forwarded-Encrypted: i=1; AJvYcCV1S1YceP6/2CScNuQN3JY50eTr6Hgh1jNBjv2F8aA3Cb3NTD1gXoxHBfBKA1P/G0X84LSQOaQuVg==@kvack.org
X-Gm-Message-State: AOJu0YzQMaUWhHIVZAIVF+4l5QUI9nW/C/Iv/k0g/TYCZcjxPgNW4Iaj
	98Nr5qdYx1c2QJL7YOUZPBdMjCRpys9SCkEPbMtz9gsCQQwuPqX5uLql
X-Gm-Gg: ASbGnctOHnkR0bJKqCPzr9w4CB2Pwonyxjm/N9dPDS0/ef0bJAC/8si+BnfWx8fno4y
	SdJ7brslVF7/3e+Q1nQV5s3ohitwcxE34rjWF/knAdAf8eFm29ZCmAQcMPxgTr2evVPdWeu7nTz
	sDwpPDJktP4GrcQAT2YnKRrKPYaI5xt9lVz4Ozpls/Y8GjDriDpMeWu8L+tQRwIMzDrMxvJnApn
	wfvoSlaYKhBU3QGrsPYJygv/h1c+vUuaKfagEJKJM+e6mRI/3Hgbancj8MzooxWBLAnKC+BRyme
	r99e58VhaepqcQvqliDkrG4KwIjsFa4/9PXJeDDCXHSlDxuPe/o/4OBD7U1kqKuHNCFfi8LVyCw
	3Qvk9yRSHRo18XlhqTI0zu2HjHEwcPM/oal2A72CNS44=
X-Google-Smtp-Source: AGHT+IGUL4qC6K+DHAMyAznh1nPqOVVG3vBedGscK4G1HhCq8iWh/Gjrhh8TEulXo726uPx2/aO9Jg==
X-Received: by 2002:a05:6512:b85:b0:594:34b9:a817 with SMTP id 2adb3069b0e04-59576e19be4mr2460400e87.33.1763040813955;
        Thu, 13 Nov 2025 05:33:33 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595804128c6sm394619e87.111.2025.11.13.05.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 05:33:33 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 13 Nov 2025 14:33:31 +0100
To: vishal.moola@gmail.com
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, hch@infradead.org,
	hch@lst.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	urezki@gmail.com, vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRXeK_C44xGb3ovg@milan>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44306180017
X-Stat-Signature: 55teukosgo1q8hb4be7qkxat7t4wpw74
X-HE-Tag: 1763040816-713198
X-HE-Meta: U2FsdGVkX19GkRD6G702CoDs1mNpWkCQSItmEU0RvyL784twNv01K1GpufSJPfqvddf+iUVUnCh137p8/kCeLH2mwsEc6AuzaKcdURcgdn6rMwHjXFswCPpP/AEx/yRqkFzKbDqks96bmAXhnOAG1Q7NBcnSuM8yhF0OLKXu6FHB6plyrQWFEbMTbTp/DVCPKq7XZRRivtJXVpDUVfQDZRsCk9lYYPLHHu1OOExCky+yw1rQKMnWSCgHg9dCtS5fmCcrxkaaU6k/3UI3286Rx0poEq9ClJIDS+pT0W5XuUj+A7WB3PmpebP/ZJhOIVPwgVZfW6fKoBs9zxbrO3J24qrw0nISDo4a73V/lT87H5DMsuUalWPniBGNleD54WmHCeEg+e6FQTrzw2o65yuQeRzPtPLZBQB7i2WRqlRddKw4ft+EdXU2www1LA5CYf68KGm+o4J8/pNgV2971kR16qE7vWD6txwLHY08GZrCzOJnU89De7BIqA/eMhbLXvjEhacg+CSw4APT7zX46yi3zhJ2wzHuDbePqfdzNm9TMlRXtUWeSHs5rsWs85q2DkH9qzO+lDMol87RMUS2KghxhtZXSXYzxa8A7cb4ndmwf/WNc/MzsmKFStx7toNKu/ya2YzYLggR8HxbKxuEnfJwu92Kj5xYVAlFIvdY1zEWwOx+lBnmi866olCQU7Hw4Pe8q5r+vRlD7pFE4JwZDYVkoN6m2yFlyApqVg0CRq+rgnJGisAChDWOsOK6/9rxiCJWDNiTUF2zJHcbwA7T3rXAp+0IE4KXhyJonIopSG5LY89jKnC9BpXlQDwHTXckGjFLsYI6ud5dMSD+za+ICe3kyTmL6TU58rGYO3PPw3HkHiFmy80tSGFEWpiQqZxT9yQagAn35JGRwMaaaSe5qXH2LGjg1YwAEXXBplxbW/4yRHHrh6W1nQ61IjdKiUmcH/r5g0tcncz2dvLnZKh24Zw
 XfUPJY3g
 3k5/ck61QMRV3vZGAETcMZzI58iyxM3e65hSqwK5kBEoLCFaCjXnz1wEko7e12G+zGjLmmYaofSSUnmLyqzECeKO+ou6sLgdkovzUjKaCqH6YhlkOqRpNHpUv5dnEl3tyyCNQm5I02z5uVXdjBdXUN3NKxBIhJlTnZgNK0LJuw2EQ7qyJFmILStD0uFzlhmKHAYxPXdLBEsW2hTEmERaCEgHw18Zm4+BaFPNBiwtXsNvNMh9e+FDGvq9q63xToMid7ZO1QVTg817eam8ydLtHArXlRtVufqhZrEP/cUYc1AQ+xAlNqPEslMRHbry7e6zGuo5QcfgfZ4bs2Ng1gYfW1cjcTwzQnZ/ikd5gYA1SyCOD769Ah2lJDq8wOgXPIDZ+sxGHrM0DYZOsMuRx06Wt+x8er6ZOtSB1mQ1rRdNGQh1grL3EvZZDqNKsPCWXK5DgwDHe13aKnap/gyEG6x+r5lfOih9eIAkdIQH9AAElm0542MzPLP2JQS8Ujc/vz8VQjjfezmdyzTdPo2IOy56R//0zVL2D98b+FuOCPydkWjZFwXq2qqaCLpVzencJLGL0rVyXFeGbSFRYX0/Cv7173TE2fT/6v6wDHY/vGb/vP6uUB47UY130kmDODwbLqsp+M72A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] make vmalloc gfp flags usage more apparent
> https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> 
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> Full report is available here:
> https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> 
> ***
> 
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> 
> ------------[ cut here ]------------
> Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> Modules linked in:
>
Again bpf :)

GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
IMO it is worth to replace it by "high level flag", which is GFP_USER.

--
Uladzislau Rezki

