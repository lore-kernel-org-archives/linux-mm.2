Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51D21125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A116B00A8; Wed, 11 Mar 2026 15:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4485B6B00A9; Wed, 11 Mar 2026 15:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A996B00AA; Wed, 11 Mar 2026 15:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25E726B00A8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:54:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1D0E1403E4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:54:21 +0000 (UTC)
X-FDA: 84534833922.08.929C705
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC16C18000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:54:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cegigHLx;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZZdNzPCNOWhzDGpoOJRtUQiGAcliYP4S9jnnNW7ciA=;
	b=aJwCrwK0PGmtPzha7DWfqqSyAbf5eL9lJKP1fD5n+/JKd2zSwfFI/p8kIYFUMe4HhUySuz
	XXp18LnMhNOkMF/PJR4KeviOf/P6HGgJhKa5xbptT2HRhU7+xZPoGtuERV26lW3b/acuGv
	lesy3a8VhLXU0xJxoBRFuuJXDAW8oNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258860; a=rsa-sha256;
	cv=none;
	b=VHPe3Z/AN9HV0c4NEul1iU1utXr0+UPTO9aDXFptqsHj+MrkaoQudmawe2H8jp79miTuHb
	U20VXYjPAAelhYjx46J0xRTc4q0t4VMEv0QBiLzYCyxMlCYis0IYhIOrh158BjcdV66oNS
	SSkHTBZZzsDOMNBQ/Kn7IzlMhHceaqw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cegigHLx;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d7507327d7so289843a34.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258859; x=1773863659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZZdNzPCNOWhzDGpoOJRtUQiGAcliYP4S9jnnNW7ciA=;
        b=cegigHLx73f8NRVoaraU2BkavC3Cd6KdgfK1wMMF1CERnMuN7DZud4p8qylx0f3PRl
         GMRhQbzESe2bvn+CuF1rSzETDe1rYoVypST33sX5OMFpo+DE6QCWFjXO95iqVXR4EKw0
         JtnCxbnURG+sadBlxyUCIUnpJV+3fvbI1JAbjtDH05Nz9KRXGmqXQjvHjZNC1AMDd0dF
         KrePmxNBZtK+9Fim0LZntnmDi36UkKOP4ShMsrL3fBFILVYVrTB/CgNhbc9H6rpKTovT
         jDeGArsDcYkYAc11UcX1Tt/0Lq97GoeHGVS/W0W3tXA9ihc2uUVYfZ3Fn0N/InPo1qym
         MCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258859; x=1773863659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1ZZdNzPCNOWhzDGpoOJRtUQiGAcliYP4S9jnnNW7ciA=;
        b=si7O+3FZfhXiSxkfZ8NZTmtfMueA8ZYg2zk8Q7v7i8xgR4VbA9Ydj+TagZ2YAMhJ20
         r1QogLfNqOIgBkekQhX/Z8UvixiDYHjg4hMCeU6tIJflC/19xzlzyp3tJu4/cwjuhYs2
         TbCCqEuOOq/FL1kApNSwvUPK8BWelAyuFZAlWwKAqPdwlJr7530zku0hGCDwDWvv6X1W
         3bQty6EmZDUjJ/EDrTrhiNEmfx2enug5hevmE8AJGhfA0K337k3k4iZdPANEdhf8wdjY
         uedQfwDD8pdZN2/E7PX5ZoaLpa4rVfK4HjkuLZ27gbTsziow52IxGJ9FOK/Ka8fi3KcA
         r9Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVgNR4Dy3s2VdULZNtaED4ggUBrvFZ4O2Dbyhq5C5UyswRozBhaF+MwRI1FYxxIHTO6/eBzMx4AOQ==@kvack.org
X-Gm-Message-State: AOJu0YxC5/eavPMuQTBkGCPAcNvSk2X6I+OZkiXDwwbZ5C//NcyXDvZ6
	y//sIJqxianRNw1elZFPPlM1V0xw0eGrUF10KqCYerCKftYL5OVaWUCZ
X-Gm-Gg: ATEYQzwGFd35oHR4TTc8JhbhdrIcJlAcR2NG1+9opPLxg2cFHGx8ttByksBjEuEAd3q
	xisc1h64UUZY6Wik/3OwWnD5PDmb0a4nLh4ufv7QCyYUMgMmsrQeUKW25VRJFjTgfoDCgagaw23
	9hiOaUMgia14/Ag2/vyXjeT92OvOK8EswdsI7S9dNn2Ob3ROgYDOe6ZFYk1kddC/OnqagxnxFPs
	69OZPXDT0oq9vwkFNVH8hj+sExMnzBaz7LFfOctpQgLvmlkKQKP1rkuisqdV9VS9ojMrbe7ERIz
	DpGT00BSeklFTF/BwU7hG5qYzWDoVZcgjy4gQyrnE0glkAPKq0YfO3UUh8yCBPkIo0usH9eUR3Y
	AiFtkOMyjp7GQW2jUqsu9pGmyw37lHbgRJhXEinsa4TyrW91GhF6HMbnQ5170L2qosEeXVCZLZf
	oax0NGtpJV/uhSMqWr9tM5Qw==
X-Received: by 2002:a05:6830:dc9:b0:7d7:5d66:4709 with SMTP id 46e09a7af769-7d76a7a4e59mr2686812a34.14.1773258858976;
        Wed, 11 Mar 2026 12:54:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae68a4bsm2489578a34.19.2026.03.11.12.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:54:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 00/11] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
Date: Wed, 11 Mar 2026 12:54:16 -0700
Message-ID: <20260311195416.4050026-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h854ssaf64c7kqeffkko5wsup45pc1fy
X-Rspamd-Queue-Id: EC16C18000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773258859-475495
X-HE-Meta: U2FsdGVkX19AoJtZcOOv63sj2m3yq+j0xM8CjWG8eeZassBSwK7gD5XxZ0tkyBBGzsjD/goh0JhXQ+APsZkG5UFMIe/BPalLxQTCbU/IkwGQRWPY315GeKKbPi9qEyEiknELkQiIwIs38ucJ8nGKxp2F5q6BUJ3Baz+aO8cVJVlapvjldiGaeoDNAQcPavL/24fIBL0Y3TJBmXe+ObIi69EUCUU49O1MrOQOfRTnzn7lzEArhxGmwk06ybSispZw4177DAL65kp2+q6DA6gpNPalbR6tE5lMd4Ds8oQmiKm0YUvS27aiAzXZ3E+bdyAsdIA3eIQOU54XXNZKiZUWtWvEyrijhHDcJ1OvHgfNWFx6/ETkZ6b7NOVyIQ1YuJ48ZWBETrmnScivvMD8hR5dNfXoA4VwbP0ukFvD07zRphEzhy1np/WVHrHBqvnwdv4VmKKwZMRY3VfIXXl4i3ZVQKfdrNUZy17mrOUY0crAehQl2LckYsHTEYYKEc2U7/92SDhJ1z5LqmxInj6ntAAr21N785LyN+opfUadXnF6Ta8HP6TfKtW3TJb0Px8JX9qUUqPuccCbsSCh3ZnGj9C0pa6v9LC4oYDpd+aFMaz6/ev2Uib5cml6KV43e8V99l0AYCwKXjzUJHZyLHxgz5z2iP6t0NjaN7QuvienzM7krbCsT0cRXskdRg/3Iujhdh5ZEo91hu36msbmiZmdjG2IlNbwxb1kF+04LhGwB6FBftpw2sBp6sGSR0hhPc+ZrdSMzMZAt21tNW8/VwF515PNuZShVSSSRwOSJocPJYW+G/6rXEP5TxQk4iRKZfNKzzSudOwKUZkRLrnM09kWbBewO3yB7pMsy1ce7hswp6NsPkTSJGOhG30SyM5hTvv+nRFZKWOmOjBw6BMzwYUtrFz7u3y3T3ZBTQgJEv7oVHgbqzr7zeHbTw3YQcJHMyFzY8GjJb0Ohl5i1WzQbCD3YR9
 Xd5oTxpd
 Qhvlv9u/OhCdk7ixv3T3l3IozmeJcsT4bikBT1+V37NjCu34Qz6WXFrGiUvzbHuaAptrOnKrG7dgT27YgOfoHLeLJlvRIu/WUc4Nl65Gx0a8g4o0GXzX9r00J7N0cM1oU+6GDKbkk0clV9oi88qzqElLDMc/+zsUh6aoC0uNQnuOzc55KC9LbAPzvspjNL20JB/cg9CAM6rkd/VUU+qCVBmGh+BLssNgYwB6MM3WBpdt2nZMrAhNPx2heZvUjP9KeyxJ2kZXHpDzrgEscf0E4BjbGNTNdS0vClYJeCY5KvUtQDTf9xwNZVhInmaTSj46VRyxBkUcSN1T2VqdxaeB4SKtK8VN+moXRj/SisNVhRKWpXHlz/GvPfUiReAJNb2cpUMtNZYaHzDaSH6+4eXZVkQuhFw/D7ntXwYOnL15gBl44fONonvXqFLFTFN9EYRq8jv0UAdP4ItAuu/YASzG7ysIIG/OZf6gaHXOwfNcFI8vRXt1a5EdMepNuHVESmA67FXisrmoWsSXp/0c6VKH3Tiu/zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 12:51:37 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Ouch, immediately after sending these out I realized that I forgot to
add a "V2" indicator in the subjects of all of these patches.

I apologize for the noise.

> Joshua Hahn (11):
>   mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
>   mm/zsmalloc: Make all obj_idx unsigned ints
>   mm/zsmalloc: Introduce conditional memcg awareness to zs_pool
>   mm/zsmalloc: Introduce objcgs pointer in struct zspage
>   mm/zsmalloc: Store obj_cgroup pointer in zspage
>   mm/zsmalloc, zswap: Redirect zswap_entry->objcg to zspage
>   mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
>   mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
>   mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
>   mm/zsmalloc: Handle single object charge migration in migrate_zspage
>   mm/zsmalloc: Handle charge migration in zpdesc substitution
> 
>  drivers/block/zram/zram_drv.c |  10 +-
>  include/linux/memcontrol.h    |  20 +-
>  include/linux/mmzone.h        |   2 +
>  include/linux/zsmalloc.h      |   9 +-
>  mm/memcontrol.c               |  75 ++-----
>  mm/vmstat.c                   |   2 +
>  mm/zsmalloc.c                 | 381 ++++++++++++++++++++++++++++++++--
>  mm/zswap.c                    |  66 +++---
>  8 files changed, 431 insertions(+), 134 deletions(-)
> 
> -- 
> 2.52.0

