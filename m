Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8766AE9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9F06B0088; Thu, 19 Feb 2026 17:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A82B6B0089; Thu, 19 Feb 2026 17:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3C46B008A; Thu, 19 Feb 2026 17:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75BDC6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:11:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE9905BA99
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:11:32 +0000 (UTC)
X-FDA: 84462603624.11.612290F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0429C0008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:11:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qwegiPAq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771539091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b73ZWEqI0vmbfTDYlPhe7doHG8cFIwPeTUbMXe3oCjo=;
	b=ky2+GpuPT5xetiyypSEU6C4hgXgzvQ82lc8lcdkt0lo2H7bshXUb0/rjOT7iZ2f1cmDrp7
	1EV+RXKJUfFtPTA68pe7DugQXADyRgtrSn7Nvqz/TGcqR96hvAMoTOY/1d84BIRc649sk0
	xU/7isNO4OLAa5uZ3nSrw++1dFQv44E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771539091; a=rsa-sha256;
	cv=none;
	b=zAH62a5Zi8ZhOQxiH3F/cTRsGmYd6Ylt5tyim+HSD5JCw0sZVe0nCl2ojJvLLfLJKTDK2P
	fkQHiXTGb4HIQupjvbUwhyzoQC2YWJHWaGloDJvust767WlvAD1ba6AUM/lB0pKIxEhhZc
	YC7pjGGIIK9YXizhUhM6F5ekTq3Wr+I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qwegiPAq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DED244823;
	Thu, 19 Feb 2026 22:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE27AC4CEF7;
	Thu, 19 Feb 2026 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771539077;
	bh=wE6B5pfGJl7+M7vk6Rh46loycKwAEMc4Jo3tZxvBpq8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qwegiPAqBJDHYdki9GckTC9d7DjFqcn6bwJyeMrOWH6ucPzALpHv4kIGOQG3ON3tI
	 2V2vvyklZV3XS1uak1yyTOgaE76TnfdGvrzIX1/OL1MUtqLFAJyx4IlqiQwWaO6HE2
	 OGrVzVjW/+9xv1zJaH5hEhJfUj2KXqwpz5kOSGl0=
Date: Thu, 19 Feb 2026 14:11:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
Subject: Re: [PATCH v4] mm: move pgscan, pgsteal, pgrefill to node stats
Message-Id: <20260219141116.2cebbc75f4d79f06813d83a5@linux-foundation.org>
In-Reply-To: <20260219171124.19053-1-jp.kobryn@linux.dev>
References: <20260219171124.19053-1-jp.kobryn@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8wkdsirrsie5p45paraq96ar5zshimm3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0429C0008
X-HE-Tag: 1771539090-913466
X-HE-Meta: U2FsdGVkX182CA3zavAB70jk4N5ENRfdN2Ef1MaNMIP20ssRPxO/EgRhEbLMJVeQCYlHti70CtzFr03VVutqQ+sqG6wJjCB5dZ/Ow1Z+OFMAQMV+SXoOyf7C+qYPiU0VsiIZAfMp6AeOk9c9srko81rTDeEWrK9m2la0bm/3hcWdnFDvYLQdCqlNalaIv+NpddPuU4GlTpQrAvrefKajT+p8ECPLtvnmy8O8hWHkIm0O27DzPihaaiQiXYiMT3BP02IrlUMi2wYLEdXHuGzVhMxm+vPt6xtP4gklAeH9YvsMe+tHwkg/LHM8UCgv81R6jF0VQX9ufSaSael5O0pNDHh5T8KbuqjIAfKuA2XLS4M4S/swA/a/zrWWKufRUz1XysMWkWPFEH4SSsnhQc3VFK+M5l9dIRX8aiB7GEDcrYnXsVZq5qZKUyhG3TSh1SBvu2DD7CGZQ66jcEkAi9LGBMF5b8Jx7WXzsZBUqgPoZJDeUCxauMx29Q/JErDC+BBR6elBS71sbjfsVrkH1itNPGicEiEIAaJomF4B0hlAghbY6CMIucsZb86UEFyRFGLjeA9g+sgrSOySJkZofMfODmtrjGXxdHEI23jU5kO0oOo7R/cq6cEWzNxvo42fWXVAXO+xq8JuHgo/+WgiZc0/Chp4Xq2Vsv3XURm4qik7XiaCx6ufCdWmqR6D59KydSBIuX7KOGc/JjGuWZIraqJd5xErAWo16HoLSS/9IJa7s0fTRAbC8hFsL3jPQAh/v3KlP2kvpVP/GUr03aFa/raxXiUrvLklHriZ9PZTp6xS6nD7pOUaIRdtvl03n/tw/8cCi8InIkuS2ygfdn4fbtVJXyUlpOSm+12VCJG2F5HkfTZCm+9I4Am5kSg50wK5+a393lNUr/rTL4S41GNIne9l5rykvZWDdDRDH90u/l3HUQdqbcYpv1B025mYQF2iyq9J/khHi9i+av8wtcgeAp5
 OuZv9Iv4
 RIKL8Lkpg4YIpXihHEeXxFJbPYNTV8uFOjXpBKmFr3SA2wuYGOxtHk8bAgn+27Q+0o2yvYCbVrvyoQmjFO9qyOKCX6dxrMS33e8B5QR5+KCquU4wbeOgyT50rohYtqqmIbr6ha5bOIBjmOe88k9HS54t3Vwk5XBlSV0UFYguQ0fpm6tRwemMBR6IprhTBoQ07jCxSs9Wwoa1MbQ4IDJO1pwzto2CUiQEtsSENXncEIUuShcS7PSL3NEudhBIsgv/3MdL4G5Ywv+nT8vU8gyIS4W6LBrqGfHZo4iRmwRIB7/g/3AdqDDDp8aQFhrSFVuB7AzYiaRJ2LnctYcAU47kXdcF71PXWzMrTeuiysF+mRginTY8uVuTpXoboxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Feb 2026 09:11:24 -0800 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.

This runs afoul of
https://lkml.kernel.org/r/20260123150108.43443-2-wujianyue000@gmail.com.
Please redo against mm.git's mm-new branch?

