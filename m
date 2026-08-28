Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C615C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E417B6B0088; Fri, 28 Aug 2026 14:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3456B008A; Fri, 28 Aug 2026 14:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09256B008C; Fri, 28 Aug 2026 14:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0D66B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:05:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41811C040F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:05:07 +0000 (UTC)
X-FDA: 85151454654.10.7C64E3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79AC014000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:05:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ODlLoY+x;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787940305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtbaLM+XrnDfc1+8xbhyudXGdgL+W0cYRo+RKPtdj3U=;
	b=5uQ1pAJGUH+F4qvMvRk3uih0P5ZqkVLgNT906l2MOMd5cKurFYyP41ySGVCifNuNgwVJnu
	LqEIqpmvxdnmIIWsn6SplSpJ32Nf2VUtXr9pe0ubaRnHLgT5sWZjJOUWKyuFMcFP172nzS
	WuMEUPS2G4S76f0gNReXnZIhWFNqhjc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ODlLoY+x;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787940305;
	b=ukr3lOV1SveVbj+us8qxQ8V44YGukrOFN76kHAreL8I9+vIh+CmyG7T0Bon8jQxo7l5Fco
	gvVrdqzoD3AvZ6GN/ad/hZIlWwD12D6Mf1441tT8PqZJxg31APDPbQycj43hI9DqzYMKiL
	AbVJ2uokLA1BjeMRoCC1zCNSWj7Qvhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB70A60052;
	Fri, 28 Aug 2026 18:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593B91F000E9;
	Fri, 28 Aug 2026 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787940304;
	bh=BtbaLM+XrnDfc1+8xbhyudXGdgL+W0cYRo+RKPtdj3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ODlLoY+x3oN86nAY7aDfhVrNWgl35SC9NPJouDYUBjPpWN5ymfXrZiul9QOj9WvpY
	 LjxasdXV1/CCPen8FXWYQWKVdl4lvoe4j9owW1RedQLSjTst7x88eh2D3UAK4p1xMl
	 R5SSBJ4PNRFGzhBP5auTzqXCDP3k4diZCsc/Rsbg=
Date: Fri, 28 Aug 2026 11:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Ye Liu <liuye@kylinos.cn>, Dev Jain
 <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-Id: <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
In-Reply-To: <20260828091753.299295-1-ye.liu@linux.dev>
References: <20260828091753.299295-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79AC014000C
X-Stat-Signature: utru58s4y34ogcskud9ter75moyt74im
X-Rspam-User: 
X-HE-Tag: 1787940305-534287
X-HE-Meta: U2FsdGVkX1/zMTgHjYyah/oN72rZFsvoYL8X4OoUulwX1dlzKng2OTPOGowyfFUg51doWRJSHrIWApCXHoTfCEdCs4YSjHYOINI0QE1dvUpJJ5JmL6aKZ/I8J7XbDQJUrXVazWyAJIEZ5Xf8qYH+qeOpwQCBJ1OmWFSQdD14l3fCzazkuPR521hLWcsUY6IdqgqWgpftLRBz5KqTFvzF2JY7hR5u9Uqr6aGm8OBki/hvEhOzQm9kLNMN4U+0CXr1jE06d/ZxPiyJ0YnBetzRR99RGOH6o/d4fE+XKBcW13TkDcI3LDptABbiILpcIA+qkTdRpYHYmfKxFRo0zcTTZODtVgnyN+r8alQJgd49E1Zh7DT+mJkq+7VsDTZA51jG20temUt+aSkHiNPHLMc0jeHqMH3ajuu86yLXsqtWiJBpF3cvvYLx8LeXjQb+RJWOjdlq7+YrvGIDWMHasE407OVTr+XQsYtvm2ZPi2j+Dq03oBPOk0TzWjhMjalD9VZHd5iWW5AD0Vq1ejTOrr97KWKqXTrrzWf7xmAZTA6AFw9Gxc+VoQLqf8TJDoc/Tvtq3cAJ32kOonoizR3zIauuMwCc6lJtTiz8xMRANhYFAibs1Nx3ugltjiu6LrHIWds9tj4Rdv9ZjvC17YpB9PodyAv7/GAkw9jdcw38uUBaL6CoDYNLRz9db2GBDbEIw2Nkd2MlVKsVByfujWhu3U6+npYZoKKQoG2pD3yokx2xUqHZyD2cGRIrwKP1u4lJq6vSMt0ndEOeKN4GLVKTRwU3O7ScDfkeIXyHw8O0UPuF162mzuedI8RmMhsJVIYSut1BclN+jWtk+ERojP3fXCd7dhDlg2rlUuoTz+JnP9578v9CeyfbI51mLsCobTwgLakMntAcDQkA1yK053M+dQXLGvvP2h8E6Kibl1h1NTHpaaRk3eAPmPSrTnWqhvmV+UjURAh76OHEiIzNFxtVTK6
 20LPFK8r
 Gm351Op+8vWBR7XZmSiRCsUpdTBPy802/0kiS/5dbkw5jjnXNquyQITzzgz8MlgYW4DEL9TZSddA8jC1AhPhzVQ/t5F/Dg+WE95e5mlZbdJOlUuSCM+N1+A3A8V3m786XKF526IZtCLvspYwE96Ua/5WlMZMnlGgNz6h4+p5apBotInHFHwBJMm/JxGF8b3zVSUxqDHckLK647WTX2CmI3zI/w4gagpLC+Fe2wrxmFUH7Gdik9VWkTBzlq4wmF8EbreYkzHlgTwqrSD7m3L8ZrXbuymlO/X0Ti0XRvdzzz0E0ogj3jmfl8ZbHB67yeSqpVxETC3epoy/5b3PKcVFFabBidmf/pHvP9nhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> The vmap_purge_lock mutex can be held for an extended period by
> __purge_vmap_area_lazy() which calls flush_work() to wait for
> purge_vmap_node workers while holding the lock.  Under memory
> pressure, those workers may themselves be blocked in direct
> reclaim trying to acquire the same lock via the
> vmap_node_shrink_scan() shrinker callback, creating a circular
> dependency that deadlocks the entire system.
> 
> Two places acquire vmap_purge_lock from paths that can be reached
> during direct reclaim:
> 
> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>    mutex_trylock().  This is a shrinker that only decays the vmap
>    pool and returns SHRINK_STOP without freeing memory; skipping a
>    decay cycle when the lock is contended is harmless and prevents
>    tasks from piling up on the mutex in the direct reclaim path.
> 
> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
>    mutex_trylock().  This is called from the vmalloc allocation
>    overflow path; if trylock fails, another thread is already
>    purging and the allocator's retry will find freed space.  The
>    notifier chain provides a fallback if the retry still fails.
> 
> Both trylock failures break the circular dependency: the lock
> holder's flush_work() can complete because workers are no longer
> blocked on vmap_purge_lock in the direct reclaim path.

Thanks.  AI review expressed a couple of concerns:
	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev


