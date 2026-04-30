Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734AECD3424
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 23:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F046B0088; Thu, 30 Apr 2026 19:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFDE6B008A; Thu, 30 Apr 2026 19:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5A56B008C; Thu, 30 Apr 2026 19:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77F266B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:01:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23B5C1C064D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 23:01:10 +0000 (UTC)
X-FDA: 84716744700.15.286E3C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C860180002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 23:01:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GeiddE3O;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777590068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14BMtKOjelmNfYIrFayt5y5RQfjdMqIuvTdr5QLKrl0=;
	b=G1Xpctx08EdtmpGktaR3esoPLsRTu4Lz1DAy5woRl9VS2TzuIfDPSsGjvU/d+q8s3vAOTy
	ATEOcTn6KRSCd61LmpRcJ/zteTn0mazBp1+pMdF1aa39tsMQQMcMmC09qCgJ95JByFwXMb
	pfl6/XuxY1jo2SHsD3qjHW84YAkCTwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777590068; a=rsa-sha256;
	cv=none;
	b=Y8obb+DTteNUFfl/V2i84kte7tiTA9ub4dLznXfeiURJZpf8Znkz+6bpLk05Lh1R6yGAxr
	CMDmh579CNK+XZff815+fkXI1OkC//2a+RW6jaSLSu+TB3xsZXJGx51icKG5+Q9fjfi1QA
	r7kWZkO53q8roQ3MSN48vGACoJYkWQk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GeiddE3O;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CBC060142;
	Thu, 30 Apr 2026 23:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04EEC2BCB3;
	Thu, 30 Apr 2026 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777590067;
	bh=PTULIpfRpRHkz0qopelU8YTdmvf6BncDc8+Oy6+/FfU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GeiddE3O5PYXm17s8GY+whOzMH+r8aSqPUcTTBGpfl5yEsELOtc1RBsuQmCU4XAAv
	 G2xQ2oifD6lJM0tEBXagW1Yy5u8RbsAOaeRTgyhKNydcQaSZIu8uBQJ2fbrPzhoFlz
	 u4ekfPkgl811pE2YyrckBnbbyWZMzpKVOwggUM/A=
Date: Thu, 30 Apr 2026 16:01:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Tvrtko
 Ursulin <tvrtko.ursulin@igalia.com>, Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=
 <thomas.hellstrom@linux.intel.com>, Carlos Santa <carlos.santa@intel.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Daniel Colascione <dancol@dancol.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction
 loops under fragmentation
Message-Id: <20260430160105.a3b74ec3bb316bbfbf8f9808@linux-foundation.org>
In-Reply-To: <20260430191809.2142544-1-matthew.brost@intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C860180002
X-Rspamd-Server: rspam04
X-Stat-Signature: qiui3bkiq61ez9g5sgsexdr4s6h1ymci
X-HE-Tag: 1777590068-134491
X-HE-Meta: U2FsdGVkX1/fBlHQR1wZ6CzJQ24AaXyWLVRaKKHnSNtWsSoEj51RvJwNqJkhR2f99fAoNMXliP12XOqgUFWsc6FuUBEDsosHwLI44q5pmZCUiGvDVy/uVSkuRM/TAfmCFhbQWJaS2C+wRQ2Qu3CeiC7+MtsB3SHwhRusqt0Q7N13pXdGb+KXs0jYCi/gh4pV3PyteKBTIe6gr6Tq+wtkLsNrxlOhhQhdBXHBAhqs/A2K3HaNdbnCCu3E/RGZ56iM63gbiNkcElAj1Xd3LYlzV7BEGKf74iFOfe+du2vmRouKNmKJOd+fbIPvk2ItmHinNtUP/zbRWoruEbvwkQ2igtoAa/IavqNuJhf4duAWzupydpoDBAhRgOUZlkNByNxIw4V62cFCyZDY8jsKS9qZoxtOlCDXE/NzWIjMwwKsnTp/HgL6XIlKN41dvPZnF0WhtjVhdev8iliDaEkQF2OsvPiXY48D3BnP6yx9Yk2m3uqlUYUmlqkK7zUWxNk2UnYlLqygwODr+Hp8hbXpC+hc2aA5/zKfv6CgK5uDLjcxqlTyE+8msXwGUrZF+ES/yfahOi8EpYpxJUz/+RBJmudTITp1EZocO4eflGD1B/s4ko6RVYNVtS5/h82oktcPq/Jr4Ih4IfHAEOodH+CLO9sOzlGL3V2aI74z+qtNDKC3nFFi1JOfkre4ZTPpErKh8GDPSkI+Y8MmoUNkFu9aWsrQwxwBkJENk7htihH5P+GeedP0MraoBb6cE9OxeJrIuIYoF/YcJ1BuYWHtU8QN54Adh5/Cvk7Pg4NdNIR7EWGAYkXJK2WKH9gwzm828r32s6CF2NCSqpHa9ETezGG1kS2F4McTd1um3/m3cjd4GaKsG4OTlSDxsZPTLOe+FyBdLUoNoJNPEets/O4UPQD89864aqsmHhtpnwRPqvqh9lM3ehGwK5ema+DrbADnEqKvMZ05c+qTTr/fCPLRWJBAAYC
 8zFZQjUC
 ygHOBI+/8xlVBs57pQ76R3LvgCFwpyr7zrNsCJkccFEFilAb36cOvVLoeT5Rhim+vccVc+sokbHaYnTz80F4MCaST1oIihV9zZM7JFyodq3zJgFyO3OJPaFHNR8GfbHx4cPuLg/gCE1fpQnNqqnTeGp3/xZPpcmcFRXIn7QH6y01RjGCdq1jU+c0RTk9DVnofTfVZrgHKYM67n44QmPvB+CgRB5cxKlWBM9zwTpvEej1YYhzntC2vS7DAeRVew56n9Jiom2kIcaJTor2j0LLzBRlQo9uFIHkjndys7FGsaX5NvePS3EwMPK/nFDB0hKzDKzsl6RWWZ/X8kTLj8NKS9vpRo83aPrZfozS2JTLH3vtRFWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 12:18:03 -0700 Matthew Brost <matthew.brost@intel.com> wrote:

> TTM allocations at higher orders can drive Xe into a pathological
> reclaim loop when memory is fragmented:
> 
> kswapd → shrinker → eviction → rebind (exec ioctl) → repeat
> 
> In this state, reclaim is triggered despite substantial free memory,
> but fails to produce contiguous higher-order pages. The Xe shrinker then
> evicts active buffer objects, increasing faulting and rebind activity
> and further feeding the loop. The result is high CPU overhead and poor
> GPU forward progress.
> 
> ...
>
> This series addresses the issue in two ways:
> 
> TTM: Restrict direct reclaim to beneficial_order. Larger allocations
> use __GFP_NORETRY to fail quickly rather than triggering reclaim.
> 
> Xe: Introduce a heuristic in the shrinker to avoid eviction when
> running under kswapd and the system appears memory-rich but
> fragmented.

Please cc everyone on all the patches?  It's kind of annoying to have
to hunt around to find out how these proposed changes will be used. 
Personal preference, anyway.

AI review flagged a few possible issues:
	https://sashiko.dev/#/patchset/20260430191809.2142544-1-matthew.brost@intel.com

