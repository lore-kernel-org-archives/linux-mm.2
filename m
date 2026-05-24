Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AABCD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 13:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73EEC6B0092; Sun, 24 May 2026 09:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE506B0095; Sun, 24 May 2026 09:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5166B0096; Sun, 24 May 2026 09:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 449E06B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 09:37:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7E581C0B73
	for <linux-mm@kvack.org>; Sun, 24 May 2026 13:37:25 +0000 (UTC)
X-FDA: 84802415250.09.1CF5D96
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5A46C0017
	for <linux-mm@kvack.org>; Sun, 24 May 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BAIZ6fPa;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779629844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOoypwVXiJS7FMQk1ugjy+9q2SWezMLwPiTi1PVsw1c=;
	b=S6s0t3N5RFHITrdEqZFT09gdNmc3SP3prnp1whODzkmR1VbWkcaEelLUFRJMVg4NXhbXLf
	SZyLyNL+zUNzd6jNRKm7kxYMLJPp130LD2dUEQZZWDV0tDWtwj/PdHF2G8IBgm+NR7Nr4I
	iUmcSeYVOyTbxxdu2iiWB55odE4gDUM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BAIZ6fPa;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779629844; a=rsa-sha256;
	cv=none;
	b=NOXwsR5g9Q0ikm6JJnBOE8CIih30ldlsKQqFxiWG0Ne99Nj5S+oNlYCS12YI2xluEOfF0w
	jkL4GVV/PyI4VLLmo8aPmVIyO/k7ydvecZOmjyw9qJUNSwQnGbczbEEV7JdpSZsFEmf1gI
	Dfj71VpNgJKLw1aDa6Mrzd9+vvg9psA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779629841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOoypwVXiJS7FMQk1ugjy+9q2SWezMLwPiTi1PVsw1c=;
	b=BAIZ6fPa9cpaXB+ilch1OPpC99v27Yn87+M8XZZnovqAuZmJZp2BvQRG5QnJDUkFWqIwtb
	eWSqfvWRwzPEManaWLFDBqAbxcjXc14hHmefDC6jcCPwAEDBfuL4PkXPBqgKKL+5Y3Isdl
	IKVkwA90mhMatd+uHBpFD9CgbSHIH68=
From: Lance Yang <lance.yang@linux.dev>
To: mattsva.kernel@gmail.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: fix spelling mistakes in memory management docs
Date: Sun, 24 May 2026 21:37:01 +0800
Message-Id: <20260524133701.3470-1-lance.yang@linux.dev>
In-Reply-To: <20260524124924.405071-1-mattsva.kernel@gmail.com>
References: <20260524124924.405071-1-mattsva.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p7kqdsg39fr9eskpshmw4rwgs9rnhh1n
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5A46C0017
X-HE-Tag: 1779629843-285672
X-HE-Meta: U2FsdGVkX19UXNl1j1qJfNwcy/TAFj+4wgjcxgHSOCl5gtG1wKw3UkniQtlyuuxrfQ/0/uTL9eAy9XU7Es7iqNVL9M4XFmTcsSNrbdUjgwz8d87woHuBhYGbByHBMdZYqdkv/33Y74FqzXE1tSdUhnmB1NCPOk3DrEQlCQovExAySTGPppvgFqAGwrTq/bTmJbbQufOGHCc9a1PBL24o00Pm4/UD/JUQKmo3a+W6oDStOnM6ClZY9StCwUz0b7X0S5GWl8Kg66uYKEn+qtYTKIusOuyutqekTjrgrV73CQj64tTPY/EuvLCn3f7bYpAnuoxI3nwTuScc+qY9UnIy0ktKCKED6Yn8JSdhCBpWcDthHmP6dsVeRzQoTwtDdHoQG3QRzYv3jaxaH0b5tzTjGGiJwh574pDO3Mf9r4ayxUO9oI1bs5/2fZJ4j9TUfsSnMVdH3zq19L6R2dZFaR17augqG/MoIp0NwXxMOfwOdwe0b7Ta4IIBeDdsbqR4xFhJ4Jvt6c3gSaDbSrI81wncfF+LYdZAki/kpGbZfsc3JYI/vQl0+twrjfkIoN/WWM7zOVktu6FyBlV6fqrgy/S+Tj1W2Ufxdi7oJML7gnHkTybPUHKL5/UT3Y2M6ImJE/+RnYGqImbUotfuI9yla5BPfMZWY0Gdf5BKzO9E7bVZxh57kdGKUMBrmKTBVxW8BxCYkZ1HbSdfYF7nIo76MPvUC3Z3p95GkMp+Dj14tRfl8rYhrxsXo2zTG26N0voaqF8NMqdKtFPhw7X/0OjYILbBgsjEMNG5pVhy7ik7SL4huoIuaOj1zq95Wz7h569MGNStil0xBLb0KuNPyaxaPYNvsPfXEdZfL1INZI7tjH4MJhMUhtnoU3us85wNyp1i+8lZabmupBQthzMq4J9htKqDJ+990Rn/DUjGpUAvTlEIsn7lcde+BDe/iKLAWv/PhOr+FGsp13uRHliahXH5wlJ
 Lerg0K6t
 ivG4pGo4l6+xlznBxwJOZRsrt1wawVROS1g59kaiAbH8dfylW6N8gO7aDanQ3nJN2RRRZNvYEDjCLkL7Y4hFHDnOcB8IHJFbyQ6JxTgUwc6/Om7V/U4F1QhqUk/7R5ubmbXNPLQpYzcyssskEmiooA7cMdQTwnM0qQEbcKskWmJe8Bp4o+4DitB4uh6mHHNWSyWaeDakdavptDxKS1XeFc+8iwJofRYWvT5gTz49Ow7X2X4FWTPulRBHGKHEEWya0UjnxrJKU0yUV6bSIH+e5lVAaI/GFXgdosuLOC6GuyrbAMSOsbJEjTk0VLP2QJIXbVC2htoc6Ln/1EK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, May 24, 2026 at 02:49:21PM +0200, mattsva wrote:
>Signed-off-by: mattsva <mattsva.kernel@gmail.com>

Missing changelog ... and Signed-off-by should use your real identity,
not a handle :)

checkpatch.pl is your friend, please run it next time :)

>---
> Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
> Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
> Documentation/admin-guide/mm/transhuge.rst      | 2 +-
> 3 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
>index 14cc6b2db897..25e2f042a383 100644
>--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
>+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
>@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
> 
> Input parameters that updated while DAMON_LRU_SORT is running are not applied
> by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
>-of parametrs except ``enabled`` again.  Once the re-reading is done, this
>+of parameters except ``enabled`` again.  Once the re-reading is done, this
> parameter is set as ``N``.  If invalid parameters are found while the
> re-reading, DAMON_LRU_SORT will be disabled.
> 
>diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
>index d7a0225b4950..01a34c215b66 100644
>--- a/Documentation/admin-guide/mm/damon/reclaim.rst
>+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
>@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
> 
> Input parameters that updated while DAMON_RECLAIM is running are not applied
> by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
>-of parametrs except ``enabled`` again.  Once the re-reading is done, this
>+of parameters except ``enabled`` again.  Once the re-reading is done, this
> parameter is set as ``N``.  If invalid parameters are found while the
> re-reading, DAMON_RECLAIM will be disabled.

Already fixed in mm-new:

https://lore.kernel.org/20260426231619.107231-3-sj@kernel.org

>diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>index 5fbc3d89bb07..5d08a2a1c15f 100644
>--- a/Documentation/admin-guide/mm/transhuge.rst
>+++ b/Documentation/admin-guide/mm/transhuge.rst
>@@ -210,7 +210,7 @@ PMD-mappable transparent hugepage::
> 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
> 
> All THPs at fault and collapse time will be added to _deferred_list,
>-and will therefore be split under memory presure if they are considered
>+and will therefore be split under memory pressure if they are considered

This one as well:

https://lore.kernel.org/20260520051751.74396-1-leon.hwang@linux.dev

> "underused". A THP is underused if the number of zero-filled pages in
> the THP is above max_ptes_none (see below). It is possible to disable
> this behaviour by writing 0 to shrink_underused, and enable it by writing
>-- 

So this patch is stale now: all three hunks are already covered in
mm-new.

Thanks, Lance

