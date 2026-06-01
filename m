Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE10CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F3F6B0178; Mon,  1 Jun 2026 03:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9596B0179; Mon,  1 Jun 2026 03:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A11C6B0208; Mon,  1 Jun 2026 03:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85E506B0178
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:18:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50A9F1C09D8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:18:10 +0000 (UTC)
X-FDA: 84830489940.04.7006E5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B72D64000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:18:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nNxmO3Hq;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780298288; a=rsa-sha256;
	cv=none;
	b=a3LI4wusGj/J20tojNpZ52rKMWlpdhJFsm+iw9a3cpDvJoVMBtL+9Y9FHqtFmzrY+qZhOR
	LTeEw6cjStv2KC91f7oY5ZrD1gMo3JWscRdq7BqLgvnY6g6ICsyLzGT5hH10IJ9NQH+aLj
	F8N8uHbiO3mGH7NwC7CL/hUiEqW4oO4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nNxmO3Hq;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780298288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmHe7bfRZ01Zg+Oucf9B7KSnbetVO+5F02Nzg1A6evI=;
	b=w4fsB3J7o4Mr6ktPqM7y0bhzILqVcbFsaO16GlEelAfmIigGieviF1HBqfIy/spO66AJpS
	guW6p2aTQgHEODsaXJ9e6wx4DFyMHqAgszUoteeZ8UnK23t9RoYOk8xMrQqz5MiFsBwQjh
	3v0cVHVrrHDU6d53HNfYPcE+yTk+x4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE2A143BEF;
	Mon,  1 Jun 2026 07:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3111F00893;
	Mon,  1 Jun 2026 07:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780298287;
	bh=AmHe7bfRZ01Zg+Oucf9B7KSnbetVO+5F02Nzg1A6evI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nNxmO3Hqq0Zu8edGd9x+gAbv6cUNN1BM/8haw81IbzVLbSON+ZAZqOG8wncH18fMk
	 g+gOnCAiu0XAkQIDUNnUFyvkfrPYaT1AygaYv0XNHbCkyt8UOv7hgkiurjK4995ynp
	 X6gHxMEnh+6svd8N+8Qtz3J1ACG9hfyrq8u/Iv/vRbkxUDSr4SvwvN37YsHKpexh+M
	 XPC3oJmuYtCt15fTI/jWuNA601V0fRNV1Pr60QTqzYNF1Gj4KVhHdGLFaH8B33gbJO
	 KIN4O3VPJ2WFzdnoY6V9Vy87ZTqRxI5DUZ1aaeRyfQF7jjd6CeQ4z1VzjVjKrduzSy
	 H2onq8dK3Wdlg==
Date: Mon, 1 Jun 2026 10:17:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <ah0yJzgI8znKJlUQ@kernel.org>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B72D64000E
X-Rspamd-Server: rspam03
X-Stat-Signature: ae7owd3rfenwmzn7dh9uki7wc5gdnry6
X-HE-Tag: 1780298288-980267
X-HE-Meta: U2FsdGVkX19KjbPdeXpfWqevu610kp89zhQ5XH27Zk/w5A/t8XTyVNqk97Lj9mPyb1jdFeILEfsiKLUENWQLMHw7F5l0A9nhaycXNKKmNCZpPomL/SanYtmG8tf26vWrQBjbhPHrjsH88F1xG1ZpS8SU8yKqaR3CKUtCZJxnODimTlt7iTPW63rO8vG7caWK8un0rjNxDrCXHyGcpkD9c7ppDSBnlGyOqYi0F/xdkq8dW+kssG4tz0gYwB0wVYCA4A1DrdSJsDnVVl2mqYB5XLPeXXMUYk1Ym3tuyGo2vyraneYdbsR1/fzREz0hz3cnFPpT22OnIyC0igv0odW37wz6ZSO74lEHn1dnKlIhhF4C1UyD7PgubcXR9r14CKHrnqtztjiDLgcC16gd8mMR7vvFZVyUoodmyul5SxYwq8zrwOtklEjNA59BC+DrRuXrsV616jmV2jwMrEZG0teFozLaw/aRedhWmKetI9w97T8L+e4BSNYICcDTzn1o1BZDGIw0rUl1eqEivSif98oWvJzJIDIj8IEuxgQzUHMc6OhDSkNmTKpwqHFRKKO81E++GM5PJfzNDP35ze0FGO4SCtW8cvz09SuoeOMJiLV6EVqv7CA2YSA/ri6npiwhDwSnFdQkTfIOJ7rfuoO3yoL11DVBhBlTsL8o6X+CQ15Dol+w6lxLsBOwCtuYco9Uz5vKQuDzB1lR2UbaA642gJ7vwnwz2IfZGFDBLIXq0hrdCTTxOVNbbML7h2srsJjOlQ8gQb6aBMN3nB41VmqL/Bf9BrnrVFaciFjfjhLvXv5AdstBtBpUEVWtoiM05qsbaziYAfh0jpu4QUiA7izLDS94zjoCN8eRSFT3knDMTURDaNnmxB6nFwvsuSi5Ykr8r5vwddQuwm3cwGy4atPT7oeK339C7irFZVN3xIbgNjnr6fMc4G7i1f1hz7Z0yJQgXxlE7BKAqxaVJQM4MEF0kcm
 3O27EvwP
 Pwu1FySLGG7LXPREHTNZgE/MJlULysSDp8hPE+hl6kFpkFcnZQxmrf8o2tzglK04dyaV6Bz4UkBjguJBpVMwWFLZEhDTfZ3aM7x/9YA3tHgmP53hKaYP0SECzqYFzFGO1DRcwzKFPreFz9ES4LYaqMsvCggAat8/GwYmLuvPMbTaKWO+FjLh2yM6JxghhejkqE2JclEA2XplvHb1ZNjQWZyFR9DSfKvbguSZLRzufsI8+ZSxZkuCwUiIMvbtlXOazAVB2ZgDI/YNdgjMLBMaDJlrCpU8PlVisUPSOxjlpiIla6S06gB2nE+U8g3nsv8o5hTBwE+Gr23rW+fqI9H5WyOrV+qBPlHY+7QPZK0NluLR2lz+Wuabvu7hQml5EpXksKF/HYhj0a/nJ+sRQhYL8Z0IZckGCd+VHIIIljYgs/iryK7unfOpFim2Qemb8fsSTbkoQ3XAlsBnzdr69JHdxEPmpWwv4luKHsHYsTsk7dZYe6LPAZDJiRvwnGsbSuNz6SsvR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, May 20, 2026 at 05:34:52AM -0400, Yuan Liu wrote:
> This series introduces a pages_with_online_memmap member into struct zone
> to avoid pageblock-by-pageblock scans across the entire zone and improve
> memory hotplug performance.
> 
> For VM hotplug performance data, please refer to Patch 4.
> This series also benefits CXL hotplug. Performance results are as follows
> https://lore.kernel.org/all/20260409023552.GA2807@AE/
> 
> Yuan Liu (5):
>   mm: move mirrored memory overlap checking to the outer loop
>   mm: skip non-mirrored ZONE_NORMAL memory map init when
>     kernelcore=mirror
>   mm: remove the special early-section handling from pfn_valid() and
>     for_each_valid_pfn()
>   mm/memory_hotplug: optimize zone contiguous check when changing pfn
>     range
>   mm/memory_hotplug: improve shrink_zone_span() subsection boundary
>     checks
> 
>  Documentation/mm/physical_memory.rst | 13 +++++
>  drivers/base/memory.c                |  6 ++
>  include/linux/mmzone.h               | 60 +++++++++++++++++---
>  mm/internal.h                        |  8 +--
>  mm/memory_hotplug.c                  | 54 +++++++++---------
>  mm/mm_init.c                         | 83 +++++++++++-----------------
>  mm/sparse-vmemmap.c                  |  4 +-
>  7 files changed, 136 insertions(+), 92 deletions(-)

Sashiko has a few comments:
https://sashiko.dev/#/patchset/20260520093457.3719960-3-yuan1.liu@intel.com

Can you please check them? 

-- 
Sincerely yours,
Mike.

