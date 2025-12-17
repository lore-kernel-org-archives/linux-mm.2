Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636FDD68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C5C6B0005; Wed, 17 Dec 2025 17:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9F26B0089; Wed, 17 Dec 2025 17:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5CE6B008A; Wed, 17 Dec 2025 17:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C78F6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:09:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F3ED1A0888
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:09:01 +0000 (UTC)
X-FDA: 84230354082.23.7B7E52B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1E09B20016
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:08:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=o9ZiR9MK;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODhSbrm9G4h/sMUfLLtuWBTsR2lrD1pFRKPaojZng2g=;
	b=P1/MuvlHqJGwSsopceJZcW2GxZMy/Lh243ZevXqIx3HEK0rD6OTmYdyBP0T5j5K3/biZ1z
	mAR7Hc6BuJhH9zJYHFKh/+M8VeCdPFHv2hjOVHKj9b2ffO2fleE/rk58jTbpuW/4pPQxhS
	orZ8wCOf5OMh34zFLGAuZgaOMuMR4rU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=o9ZiR9MK;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009339; a=rsa-sha256;
	cv=none;
	b=cFQ5KezjIv+ck/Z5l6ZsSRkGfJH1+2pfUB03Ay1rOkvwryMFX+pbO6/+8uxqGv5clOXYAV
	Y0CyWIVXKzOh2/xg7Ay+S7yyN+qHeN/HEhqMwALBIZuInV3y0iC1iixjbkMOqw6f67+nMU
	wC7zFN9MDZuyrNxEi467nEHZvvlla4Y=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4eda057f3c0so58925711cf.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766009338; x=1766614138; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODhSbrm9G4h/sMUfLLtuWBTsR2lrD1pFRKPaojZng2g=;
        b=o9ZiR9MKO8iRfsLT1opPdvc2eDDMt8heYVFo42fAybzXIiqVdiowzHDTNNRLO68Ojy
         qLHQz3rLDo73XyZNz8qof20HWIeUpXvuIQ2SLMuwUs7q1Vtayu04y+SWpX39UrgBA2Nb
         PnTu+gvB1QfrZBA7n6acxReJHTK6F/ciG9Z77ZXwGDsHFK+6SKw0K12Tc0D29Bmz22em
         C2hVq7jflEPnKhzO3W0o0zaohppEEBhRio1iHA6ZLM1X3gK5zl/Y607k9gToonOyWMJU
         psXFe8ZWjm5bNFTY+7U3aP10UDD2C2nC8T/F6TBqGJDC/mgmB+itptm0fm5lxI39PXlj
         ACkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766009338; x=1766614138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODhSbrm9G4h/sMUfLLtuWBTsR2lrD1pFRKPaojZng2g=;
        b=UCB0uZHENVnWyBbEZ9VUdS8R+8BAwbXGZDPKLBMdhVtTe5VfRvXzQP7T4ylxGNd3GU
         VxUSqYTl6AOgTiMrHDvXQDuRrYmSti1sgRNGNOxCJdWp8sSipcsM9vSupsvQXs7zLWyi
         ZCsor+KdLRoc/lEq62V6dP4vQyskeQY8rruoHoA8lxWerzNo+7mIJxP8Mmdl3nR2lgnN
         ZpINR1PLTOTzPwIbSBFARvJhc86Gq9BmmM7QQ0e/qZ0duxk//nT6d7dGIDIOHJ8tmiUk
         kPtKZh/WkSyzr0Gba7XHKIE2OxcNOrD6l2O31XwLxZ+fdJe/b1vCyEu9MkX+5tiO76SB
         xjCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvlZDiaGDG9zprMKSiVcoUmCJHK3428m2YPNruhSq53X+HwFKoTypjTmJ5VNvXDiTYh2haZZf/gQ==@kvack.org
X-Gm-Message-State: AOJu0YxO31biFRLFsJXNACkUYMqlDdZgPv8VdFcXDL8lVqgQkw5FVdQ9
	cQ8kbV+pa0lUN+s+AFJqA7OCTVSIONzFKFAr+Mn0w/jBG0/+EBbut4sLUJGKyCWG41Sg3I8qhf4
	xychh
X-Gm-Gg: AY/fxX7VKoaqqnra75FNlIcbeCGsI+nhWQ3arRNHx4tk9sIyV5bOHK/q83qiVh3pE3q
	We7Ud03/JwvePxsbVcyyRysWW3VXmauDHtKRQdqMLe2gWaAMJ2de6iKcyxgSRdcCTSPLzikuXZP
	/yar8DYqX/Cf5z2tKT38Cm/BVBhi1UHcsiLORmdZT/0dhP6ZEK065WEZS2koB0Cz2cKnrPib84c
	rXnUAlwdTDbH0hUJtjarzbW31nxqNx35ByKg3R0nPJDxUzt4P6nv4ePkLnQaqO5pG2wlrgFRyZz
	tE/qvdywLWzLMjFCeGqove6UIG2/2tJgsSRd96IGnzxqooecGWx+pgJM9F88X3mlsKZftxlCAp5
	WqMCwo9hn0oXSsH7VQDqvV3hwjUQrZ7dWSeMdrEUCIvImhSTlukGjjpmPFRUQpw4bcrd6I8RbwZ
	MSvsXyAAYYfA==
X-Google-Smtp-Source: AGHT+IF7SO/j32cChYhjgU4Xs4tkHZwOZcvwBvu3/hWlB9NueOn9g2ZOSd1HB0YjPfIoqoeb3McUwg==
X-Received: by 2002:a05:622a:4a89:b0:4ee:1962:dd46 with SMTP id d75a77b69052e-4f1d06320b4mr293520131cf.79.1766009338015;
        Wed, 17 Dec 2025 14:08:58 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c616751b1sm4256836d6.54.2025.12.17.14.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:08:57 -0800 (PST)
Date: Wed, 17 Dec 2025 17:08:53 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 10/28] writeback: prevent memory cgroup release in
 writeback module
Message-ID: <aUMp9cXFGMwgj8Pn@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <d2863fabba49a16572a84163e42cbce64aee27c9.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2863fabba49a16572a84163e42cbce64aee27c9.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E09B20016
X-Stat-Signature: 98brer58ih31otbt13ct5fmb46ss9ys7
X-Rspam-User: 
X-HE-Tag: 1766009338-305396
X-HE-Meta: U2FsdGVkX1+G6yU8CMDmpXSS/KrPiqb8WxZ5sfVLV8sc2+BWpG011XgK/XWKhGCCQ2a3zmqBS4fKKhGUW2P9ANQCGQW7TF3+Ej8NVXZsMfZ805sNVpkVjVGke2IXvjLbmYcdDmHAvqyTyKIOhOXOQgEyYN7vBPnBN18Hm1f+y6IWw3AFK0hQ0GSBFUowwOo8RO3vZl21gfMidIbXdOdwpljaEKQWumpJ36D3OcjOAvboMdlxH337xnFSWSITqaw1VlaIcLyjwQUbQpwkkB2mr+o3g9ajbax/HIw9a8tbQhdwhTAmWewbqLzrLZXKLx6CG9Nx6lLGhbi24wOQ1EOh05iueAgYJqMWUFm75H7QnOVr1gRp63vzOKNR6pyw8xhMDaEGLfq85T74chsPtWng6hHzBmYca1ezikUoig1v2yh+WuEXueXKeh0OCDkx/v0IcA0jecfhfdiONSZx0EsT52+77Q596watrdgUULodZcl7w7AEXpu6RqECuBd1JJioaMysQBzQW2GQkIx1S+EaO7c6no5OZxN6JTlRTBBnzZqmOjgRpGptWX6BMOGafDeWMEyNc7Ex/cezlvlFtEuyFSOQQ3Pk+dt/9Op/eks2DRhIdddOFOVs9z1agNKbMBt9QoXNovz+5Dy7+HEljG8BJYsQz5tcH+dskcX7vOdzUmwzJhbJDf4OyLDDsMuKSciIBDqETAemMdGBkH2atsVEIgklUGqWBwoyW55velvVPmcLa5tt+gks8IZS1HB/jQc06wA4s2TDwTIWiSMcd5t6VdHPiQKA4k6tpOmmKX2MqFtvFrXiDpALQJ6XaJETny1FCHNYyuFbdIRbsCAXqcAyljoJX0pjhlkOeqt3w5QWP+5UHQj8nbh2fCxdHkYQbEDbJyhJM50nOn/LTqY6+l1j0cBTwbZBUdCcDx2MwnEcaMwuzGEC+qX5Ttm/mzhCPvu2A375zB42S1vWdHxh4nX
 84/MeFDU
 +dqCwq4iEN8EUA9h3fslxmtrIj33VOVdHtvPDWiRW6DvfOLKBh65qLi7CYZp493dlbHJetetedLIe2u8jyX7DF/xdJVQiTEsLLY79pCiRtWfCM6y5DZ5v2UdV6eqThjmy3Bt7wKZEGoVFKe6UXDU0XzL++xMfFAwiU6zLzfy+VpZsZPr8F0X86QdDPmn4Qe4UF/QEwEen3l3qwjGejZ5IDXoQH24b9Q6V/ulGkQFV4ABbLcai9O0eI0m6qUaE+WpFURvmElL2j8U2BWh/JZZmk2ybA5OWbgBfpDKdjbjUr67Ly6VIUu7zxfPFCHo+kaIbfCGh+s7DxKpU2a8FJ6gHyu66msS4Y1byizSJYPtRsSsiOMyRgtKSc4kh7bnw4uZMONtbBQAlS6lOgQzcUKVE1xcrouGHQDNXbaADIFgcgLOpkoYbnM5hKjisCT/zgMJu44Vpy1srAaUVFa4mrXtmS0LtI82T43f97Bey
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:34PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the function get_mem_cgroup_css_from_folio()
> and the rcu read lock are employed to safeguard against the release
> of the memory cgroup.
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Looks sane to me.

The roo_mem_cgroup handling in get_mem_cgroup_css_from_folio() is
unusual - usually we do NULL for mem_cgroup_disabled(). But that's a
quirk you're inheriting from the existing writeback code.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

