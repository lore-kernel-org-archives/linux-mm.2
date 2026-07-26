Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12593C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 16:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EAC16B007B; Sun, 26 Jul 2026 12:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BC46B0088; Sun, 26 Jul 2026 12:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766166B008A; Sun, 26 Jul 2026 12:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3A46B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:50:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4735C120552
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 16:50:16 +0000 (UTC)
X-FDA: 85031515632.01.AFC5108
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C0A14000B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 16:50:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxfOEtrq;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785084614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bihQdyqP8nybmk/Z5jPpiccWyJrZK2FXr9JjFx/kKKY=;
	b=YAxHD+4vPd903Zf6xKOvC4lOIFKHo1WKwW7+7Q2MYWLDzgkZm9QYVP04AKMx4/hSx0AUlX
	EgqVwbPLaZjMYY03GafZCDCd7ggOFxI1f1L/mqBdRID3TlaTSHWHtfPgNgB9mRD1TQ7OBm
	uTZBHBSxaEnZ2DQf4g+RmyH5MRGOCe4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785084614;
	b=5UwqAFXoyx+pM8Aynlr1Dqm4eSmj977sxordJLHI+MSl49wc7q43m9vA0YIeDN5Sj4zzsc
	gZ5xk1BHxvaRGq43ifE1lhjHS9BGTDa9klSGJm2dk4EiJ20RI1zY+wIUfJcKzlA4RE+GYk
	9s44FLDd4uGeoBLDgUuyhbXrUn7hFO0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxfOEtrq;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 548CB400AF;
	Sun, 26 Jul 2026 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD0A1F000E9;
	Sun, 26 Jul 2026 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785084613;
	bh=bihQdyqP8nybmk/Z5jPpiccWyJrZK2FXr9JjFx/kKKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxfOEtrqIoqIK5xImd1RD9szFaJb+642xnsx+4gFfvd/ngO5LzRGs6cxaJhiSR/7X
	 Wo2YCskKacWVCI5E/RJVQJmduIxdk46iUaLiDEx5o5fX7ZeD7cS+hgwnRBWZwU9xAi
	 U6/7XI9b0mH/1TA6xUen/ZnKcDJsthpP175NtyphpPaEBudZf8o49YRdHpS1nziqEq
	 Phr9xdWYresJUuQRSx9LjCyphG1I+2Om4MMLVv4T0ePuk0Ppc/gFdcXAXjG6iGGXRF
	 fTHh+zs6HjGwxDNEH6RlnmTF8ohK8LwV+O3JFniT4OgmtQk0+/pnMSP8KtB1az7JXR
	 q0Y9ArRK2EO0Q==
From: SJ Park <sj@kernel.org>
To: dayou5941@163.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	joshua.hahnjy@gmail.com,
	liyouhong <liyouhong@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Sun, 26 Jul 2026 09:50:05 -0700
Message-ID: <20260726165005.88635-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726014815.1280757-1-dayou5941@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C0A14000B
X-Stat-Signature: i4y3tynijxw4yhs9cmcfefi9xczbsbun
X-HE-Tag: 1785084614-62
X-HE-Meta: U2FsdGVkX1/EDrDJQUnz4RpT4zNaEqHbJYOd3q976FJ2gyHVhnlL3eIJdzLvgr3PJQXdGlP0pmFWY9Jrxix6N0iVzPJX7FbuLnIsoNsg1vGXKDNF/VsKyudIFTEVCn0H6rMgsDS3NFJbWnudScobc4gaiqdMiKNs+rwwwcanReppin+bDLl1G8NaTyiFa0NZnDHOjVArk3Mx6hdT5hbCxIkc7+0Fib5YbJEuVdCvnsuh0aj4agtXd8zHXJs+EINEJkRdMNwVRlAhmp5UyIjm56SoOT0/VXiq7AyqNLQg2YXfXRkykng712UNnu1NpsE9FOF+dgTeghf3ZwBiuqEkQ0VlyFcu0mlGmT43W7RzdATjlZtdIsTQGPe+C5lHs5SGA3q6vQTvb+WeWdLVVpkZdNXU66PaHTH6KE71rVOaf8y976qzUKj+JPcxaNQpzsoBSPVu8Tbk+aUKijXZ6Qrqg9thVE+JAWoMc1WNPnD5S4e0gS+6uBRcLVAGjRxA0WfUsQ6dcrdSgkL+cwlynZWspe3+zkJx4y2K3WKnpU94fZZZHOHlUOF2XDV+1P5R71XFpx52sxMMM1JGf2+KFzx7sjqs3QmmHunDcbK9vNVpWttPPnyACZ2G3IE8sq0Fbe3mWLQhkmKrSErdeRPE8OxRmC54+9ewRgNslRgu6y8j23B9CAk2aUy6fywyTDFgJaGMU18QRkciV03foyNjGjfQxrmM74i9T2UPYzga1AmX+Zr4R4fO5T+IbNYY0cJOi966JDIvzv0SpkwHaYdOVzorJBGQVAbIUSs7Uw8lnkyxTY1Ad/VrvdILD1XfZOl375iuJ9Z7RD2i9bmJ7k1DRfbmPGdAujSgjOu+F5vAJcdiLLjJ3aSkcVvv16xSCkxghpHdrHrSzf8D/TvEfv0iWXIM3xFCkXzKduO2WZZ+S8W9HS+iP6mF1Cgg0/2of9017XnfBek0YKyf6qpKdkx3HuN
 NATeFOrE
 lBDVIuq5wOCvynahIu4BJOUV2pr7+i3KqQ5yermP8AFKbbx8JEm6iriUISmlWLphqXAdZPM+byIDqCkcoxFUvgBxGp4slPEf4IIMcAy1JvNTZ0d0L0lZcUwn58ayaTyiARA/moT07+0z2g4LHSu9+51oO9/D2DXtqcoWj8rB4d1qSwfPKkhibbKhrKQrSQEPgsmfjS/2ODBsgIYnnZHGrObHXzGr3gwKxAsINZOQHef+qNDK8bRnza3RxGvI7G78cInCl9H5lIaAY486Llmolt3ZELW2o+wXoIFUgK4Y8yu0mAGFOH9B+ehM4td5E0h3oZp600EhzqMaCUdCqPVk3cZ7XyzKtl5UA9GLD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Jul 2026 09:48:15 +0800 dayou5941@163.com wrote:

> From: liyouhong <liyouhong@kylinos.cn>
> 
> damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
> and then call damon_migrate_pages().  When target_nid is invalid (including
> the scheme default NUMA_NO_NODE / -1), damon_migrate_pages() returns early
> without putting the folios back to the LRU.
> 
> Callers then discard the list head while those folios remain isolated with
> an extra reference taken by folio_isolate_lru().  The pages stay off the
> LRU for as long as the mapping exists (anon active+inactive counts drop
> while RSS does not), and the leftover references can pin the pages after
> the mapping is gone.
> 
> Put the folios back on the invalid-nid path so ignored migration requests
> still return them to the LRU.

Looks good to me, thank you for catching and fixing this, liyouhong!

Andrew, I think this deserves the hotfix fast track.  The bug can cause memory
pressure, and can be reliably reproduced by the user.  The user should already
have a sysfs write permission, though.  Let me know if you think differently.

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

