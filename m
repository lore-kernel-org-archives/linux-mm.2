Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4846C106F302
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EDB36B0005; Thu, 26 Mar 2026 04:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA656B00A1; Thu, 26 Mar 2026 04:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3D16B00A2; Thu, 26 Mar 2026 04:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 698ED6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:38:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4207613C0B0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:38:08 +0000 (UTC)
X-FDA: 84587561856.26.ACEB14D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65C9F100005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:38:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwFmp4s1;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81i9wdPvvQUJba9O0FvPBNBq65mKICDQrREUxrxqWKc=;
	b=ip7poWAstrBrQGm0x1oezx9szKYOSMAzS5olL5QCjMCFGkrpPiXa31m38JP3nDGZ2aJjOB
	WzQTEW3ANm/yaXNsfOsROEE1KkbhV+4AnSLHVV5TFw80jhYT810CcKB2bVc6WSh7xDKRct
	2hGH2WzeqGvwNvvuLMDw0Zkb93iFgYE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwFmp4s1;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514286; a=rsa-sha256;
	cv=none;
	b=DTjRMFNNK5j86dTtYRGnEcZiQdNT8vjKC48RH4YC4LWM6NK/4T2FRRLZXKjPgKYvlgaEGr
	Kp9/fW6mSKPc94j2fC6AyEDZV3093E29GRCb0ktILWJUQUdYqStGu1MlZchGt7MGwIQLaQ
	GpvEkZFL19ZDJirwS/ezt+1ov8wCw7A=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2addb31945aso5564505ad.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774514285; x=1775119085; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=81i9wdPvvQUJba9O0FvPBNBq65mKICDQrREUxrxqWKc=;
        b=OwFmp4s1pQIRCRwwfoSwrZBOSO8cSY8Mq6ceVe8ssb59afdPiTiNjFzGrfmUVrcwiN
         6ZwARE3P11sLfda7PUoi41iNC99Bgm7jDwxERVwWWBt6FU+WIZo9NQWA7reqoHtb609h
         aPRuCzs9QKJQZh4Uv8grenvYIsmEoMoFAn2E5DMgdnb4MWRTvbNX9M0YL+twNhB9kHGo
         sHuVTe7UBr9STdHsbxQsU2u3eMJBiI66UHlj9wWqgx7RTIHunRNnEqObcOhNC3c8x21E
         Sztm3sMGRWAUjhmGV+WCbKPmoq+6w4l0QC1F6xCt4si7saIe3MTFdHWTSYJiQy+3at2n
         kbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774514285; x=1775119085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81i9wdPvvQUJba9O0FvPBNBq65mKICDQrREUxrxqWKc=;
        b=ZW6EqMK+dnNWwKZr+jQkYNSJziTcNz9S+Aqc4o4pYRqhzv1yE0NQosODtIhYQjCHeA
         feEIiMja+CoIZQFbOMNdic+xKFC8smL/mwQ0CTm5AvtJJ5NU2h/na8QNXzsZYEXSy/L+
         JwF3CbiU0vC8OVU4ZBhyuw5/t6OAk0DonV72esdkzw3D+YEiaS96xK6lK4OT5IE0anzb
         rE37GU3LDc/n6hvyrlAuVsWmG3JlGIAufmnb+cBSSCGGzFo3X+b2zvzI6aTIgxT9ZAuC
         eSHH9fB3o53OISJlWQwbQF9sJ5bPK1861Ad8Ki2AjaQpDmoECfAdMMXgVMdK4oLC7SZe
         P9qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXpuma2h0zHYyjZn7nUWsCcotQr5GbSNWXh3PH+oeMrcL44lvBYV9WlgrzDp/5O/XJsMwvqH+ZvQ==@kvack.org
X-Gm-Message-State: AOJu0YwieYfVS3jn1kcKIFAYv3g2mtjh3NZL7N46hwA4sOjud2qyWHnX
	FdwIipPmiKj2CHPHVAkfzRHin29JtOCE4SWNZzvpoKY9wjb/YtSbyeEJ
X-Gm-Gg: ATEYQzzGyvXXZReVWG+ErrySGwhVXh+SS0eHEWpy8B85tz5TfpgQN6lTnH7FrDWZEpM
	/jPe1eZxhYz8AnIyXrtPMP0beMELvq5l26l8maHyvKsHGTIWa9NjlupJ8t72umtHCWziNw/Lz/g
	ZTN/QSI06s0vytGZ4w8mJCH/lNgkjftBQBlciXDlcv98hBS4Hq29EtvK9bVnGlvLqU2dOXc1Ac9
	BLNWdnAyC5VnxmpeG8difDW6ccaZUOmh1kkt65Dwrp20mRNCaT3FJ1ZXzqWyhvHyPrzE7TbFCts
	aHw/jUQlDGvWSPZZ/bAS3iBaKJGWiNcBrmKVL4Cy7VroPSBLQ4h+dYzRqJtCryQcY5jbXs8X9SK
	jpaE0z5CeHfrIr6wEXn+48i7ry8OcuYcaUXI4mj+K0BtJtdqHxkqoE377ATtedbY5qLgIBxEL0J
	qsSqE5ooxoN7aEI1tQTMuDLuLLbxxaICeogWfunKxt6wX6MIlkJ9SUEaMHxOOWaEfgCkOT4NEf5
	6BQVmM=
X-Received: by 2002:a17:903:2ac4:b0:2b0:5b4e:370c with SMTP id d9443c01a7336-2b0b0acff88mr77777595ad.32.1774514284992;
        Thu, 26 Mar 2026 01:38:04 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76f1ccsm22844545ad.12.2026.03.26.01.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 01:38:04 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:37:57 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/mglru: restructure the reclaim loop
Message-ID: <acTh7wqHnR0ySp6W@KASONG-MC4>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
 <e85b2d1e-45c9-404a-b973-119061d3f230@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b2d1e-45c9-404a-b973-119061d3f230@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 65C9F100005
X-Stat-Signature: 84bxkwshodtkccm84xzka39fricur4g4
X-Rspamd-Server: rspam06
X-HE-Tag: 1774514286-495117
X-HE-Meta: U2FsdGVkX19dx+m0H87jtVV4VZ8L31r13fAoqMNQQp22TelziR44EzaEnDQW/vnLC7vmTjZacIb7RpVZTR22+tCn7YU0jdF+SllEBr2pihM4UA9gICQHLw2y8a3a8C+yelvOERVMIk3FY3DwT1R57up1ZPnpMH46GfoX/mPsJ7O48vvJw7JjaC2hf0l51dwYtbNONeXeX7qhTPALkk+2HjpDqnznnNgTL+iT4Or23+qa6FQeOrzWWfDUL2fxIni4LUIdVPQ2OcJbpi2iUHeQ9eoyZf1uKUyxlr4hYuG1jKytox31k3VzAdjPEB+xaqy5/saNQQuSAp978Jq7VA0eamoQz7dpiV9H/TZBWcOVCpWUgHuoTDHXIUIdVy0FSfOxPEmhAbF96oM/90xvvwKHJHRvYPvm8odElBXXMemLK1Kwt5pgAXKUa1p5i3YVp+PA86kLHic8VPyMjU78lzyqmjO3UNhUXyTzbRqddWT1Ous+qgIRNqJLxDcddZ8wX2EDOIWXkrgZ0UglOTka66/BJ5dLWIs3mS92c0fHPpV/k373RRDzzf/DZZZ0mVaBU7jn8lXgal2d9KsDqonnZ1LANE2vUvAPZeEze7Uc50y1wtFkZAgejR3NNd5ZVt9h9IcfZ6R4/xjGdK/COxW3qHFz1pwurkLOk8OgGdl5XODEDIC9yzT8S76YbXjM7IiIt5cRnxkWuWCLlmUu7G1Zrd7EhWl9hscuUod0+ucAruxWLqVkWwlLrQ/4yZ7U5upwe6O/gEt88N4VCzVnqCDB6elkzV50XjptI6U//hDM1dJMN4zGEPecEEJ+MzOT0n2nKMqyCje7VtmNWf5M71zVpgglz9VRTtbveTIahYiiVkjoyNfvqQxu+sffXLRgVcKYOgizkalhzZEJHqe/Q/pugVTeeuwGHTTBR+umY6CSstyaSlfygNjjETS+lFe0xM8WtH1FER9kxKYPSFVmZ5zYaZn
 ODJUv0Vv
 rv5gt4nLauUIYumTZrLlZtNcCr9vo8FdmSASB2IgntUuywZBu5oulOh8/uvGPo/g7h2dtB5frqGD/1l66SXTqr9sup7djr4hogqNNHF5D6SX0HAsKTkTQTPK9XYS971L+R623Po4tupcwp5yMv53qu5swvblny7Lz+1UsEsiR1TazP8EySBq8WI/rVuPC4NLIj8SN8xNtdDLI/uk4aExxr4rpDPy9tIx5iXO6EHVy5T5bdWYebCLujKQ9fwVitY0J4yxfk8VUCFUve0i0ZgBA7cgFEXMGY5MH7KeTTrxYdUcXwERzBdkYfPe44PhHKJvldWhxwL9Gkjs8ecAep/gUXL/4ubX3DMkxlPMolo2nxXEfF7nEQCwBApySkP7HFxs6K3joUAZcsPzi/WFLCv8y6rnVurf7JoA6egq+BKCEW0fL6Xp7fn9p/Vm+P15cvZwkzRiR1FIKgqPrVlU/ClDV2TsvvrmEossN5cePriUrPUHibZu/vECW10vYqCZYwLMmfR9oyTFd/KwN2c3LZ2jUazAAEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:31:43PM +0800, Baolin Wang wrote:
> 
> 
> On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The current loop will calculate the scan number on each iteration. The
> > number of folios to scan is based on the LRU length, with some unclear
> > behaviors, eg, it only shifts the scan number by reclaim priority at the
> > default priority, and it couples the number calculation with aging and
> > rotation.
> > 
> > Adjust, simplify it, and decouple aging and rotation. Just calculate the
> > scan number for once at the beginning of the reclaim, always respect the
> > reclaim priority, and make the aging and rotation more explicit.
> > 
> > This slightly changes how offline memcg aging works: previously, offline
> > memcg wouldn't be aged unless it didn't have any evictable folios. Now,
> > we might age it if it has only 3 generations and the reclaim priority is
> > less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> > might still hold long-term folios, and in fact, a long-existing offline
> > memcg must be pinned by some long-term folios like shmem. These folios
> > might be used by other memcg, so aging them as ordinary memcg doesn't
> > seem wrong. And besides, aging enables further reclaim of an offlined
> > memcg, which will certainly happen if we keep shrinking it. And offline
> > memcg might soon be no longer an issue once reparenting is all ready.
> > 
> > Overall, the memcg LRU rotation, as described in mmzone.h,
> > remains the same.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> 
> Overall, I really like the code cleanup here, and it makes the code much
> more readable. Thanks for your work.

Thanks for the review!

> 
> However, one concern is that you've mixed some functional changes (such as
> the offline memcg aging and shifting the scan number by reclaim priority)
> into these cleanups. This makes the commit difficult to review, though I
> think the functional changes make sense to me.

Right, so I also include very detailed test in the cover letter
for each step. This part of code is kind of coupled together
so by decoupling them, it may get more messy if we try to keep some
of the trivial old behavior.

But will have a try on V2. Already doing some stress testing but
splitting the patch shouldn't effect the final code.

