Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB98F3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629D26B013F; Mon, 16 Mar 2026 02:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601A36B0141; Mon, 16 Mar 2026 02:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E786B0142; Mon, 16 Mar 2026 02:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35CA86B013F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:30:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3FF359C91
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:30:19 +0000 (UTC)
X-FDA: 84550951758.13.EF0E839
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39C428000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:30:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrAO+LMX;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/J7KKo8wB2DZ7x4K0+LdfGP9LsWzwVVFG+7yW3vNEo=;
	b=oHXrIKcowFewJu5cpaFwtcxzQz1quI/mHY/K/rGC738kGLZCiv1+KFYx/dfuM2SDGfxYYH
	m1ab1HCAO12Qsn2QY63Jr7JJYPHWyffEl/BOcX7pQNb/BcrIf+mivRZ2eYzbqEGsU8LtAO
	Joq+ktHw0zH0ay9o/YGwSMfj9GCLcfg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrAO+LMX;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642618; a=rsa-sha256;
	cv=none;
	b=U+hzHquWTRXW2jKQxM2oB2OShzCO00AqAsXBNCDaad4fbpVxACmnwBZYC83TJmWh8XfCHH
	pXJxiddlkjE59qE6up/WtZ2AR0j0086BunMzaUda27y252WUJmHhA2bJBfiivTdVG/KNB3
	H1JcRhp3IIXWwMTPi83YW4Zi8hOXOjM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44B7440273;
	Mon, 16 Mar 2026 06:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7BCC19421;
	Mon, 16 Mar 2026 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773642617;
	bh=BoAh9R2GzWm0J+6HTrGxGxOCOG2wr51zWGNUGEpZehg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KrAO+LMXLmFNA8i12ZwNrpk7GdRAUsDf+a4vK3fq4p42YlFyHT/saU0gROlAzEKZE
	 DnmJq0GG+T+nCaApEM7GEx42dCUaniKigKA31VydRZDVqJIrTzNwa8f92MuB0fhzqW
	 du0TclxXK/qCbTgLDG9cUoUBQSYyZNHWtvVfOOutDP8UAtIqQX2bbNhWGEH1hiljIW
	 3bKcxWK8wHsYTKsgbmOBPMcK7kE1bw79Av0ZmI+Z5kaugNNbJVar+5/f26oHY7BdMI
	 msTWuTlOldO+Wi11E0O9yu/c9+AEp+1iEDrO60RLPr/LpRyDIgC4jHw0HSu/aaKFs4
	 QBe2R/bLqAiig==
Date: Mon, 16 Mar 2026 08:30:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 5/5] selftests/mm: transhuge_stress: skip the test
 when thp not available
Message-ID: <abejb7wggISdsIad@kernel.org>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-6-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316044335.1390608-6-chuhu@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 39C428000E
X-Rspamd-Server: rspam08
X-Stat-Signature: 5gc68gcma3eg7waxdwh6n1cx81byce9g
X-HE-Tag: 1773642618-908446
X-HE-Meta: U2FsdGVkX1/qyIPdFzfoDTO7wLh+e+N+wK2qcRAsbqE+MjR2JAdBVNyimg+8CktDH9C60twa4aTMUuN36rgI7Ukd3JO6SV9md6z4tdyxib2JeoJ3huDotPIP/1OWucRJe7BvM0FpQKuoJwt6/siOWWtSJPew05pn0ziNMN3x0OyPf2FzKZoF1+QaaKZ1YyW5ET9NuatkP75m34KBG4Fm7ldk9bMatNMcn//J9poYuKx7uGJ3UzVIvdcBPqbVu1Y9VwIR5/1UoswKDfScB9cGSUz4+2oMfdt1/2QBTX4g559HnkdvsVyWQ+ksqqrcq/CqJ47fFoUUWJ7BDuJ9KdB7kSsBWB9XYY0sSmIv85yBKThmEXR7E2XP52xvaRkystyEGFeCPbb+7AOViKqgQbtEPjMaMC3moZ7HM2A7M0Iz50F/TgpPstHosrYXlNRup4PggcqkrR/tY5+ExnoEV1YZ5WD7xSsI/YgNdKLIKpOCC6M6629a+PhSl+CCIiyekrW1KNzfxeJQZtBC8epVyBbFb1eV3D/PKb1SVfM4XTY1oQd2G9jnHGM6vF171G7h7jfnlOEgS0kBCgsNREQMfUr67AfgEDCgVYc+0BliNWilr7Zj/9ItiIQBido72ksiS25go4O0eWkXDqMIA2w6nVs3+0k5HZRjSCsKPbMiPxN19t67ptgbZYIaCJkoMQQwKTHgzZs8zqicDzI3CvuKwLbyjButV3MLhysVTazYBnTjmfsdPTVxBiyAcN/GCGd/iOIc68GvwNahqWk/AE13P3bLU5541an2Jwp7zyNocpzr5hdyhnqYcp/ATILlI1MxMvAsEKGyyzJPVJW4h8/Hh8FmVQD/jvfr2Mil62bOTDVVFoDeDBhdo8r11MxJONC5VOiVR+/wtmLD2X+p/Od4MDnV8RzUyiZEnv7pVQ5rLWII72+O/BSe7Qmftf9/pCIypyLmX9o5WN6/r5dOtxPlXGm
 VcjYbtGu
 /0HK4GGi1LjLMqwI10rME0DWycepTB3rrPkE+rZtxhy3WWPNutQASKTHaQXLXbOkns7mM5nr91xu+x3HsjnauTWOib1lb+d4+n6ltAwUa/vdeV9tYNi3hKcIOQsF1s/vN7zGnzfMwwpoRNwe81/JsQ7MQR/P8g3ZWahJKII+0+xrXs3pGovh/5zYtRqSAPk8dzEuUvHLQpc2jo9AA+qimmiP9+OursUkUkp5Tee7yoQITtvDIPv2Sh0vyfEP4iGyR1/FjRK9rTGWnw02Y8bIP0iEHqxOtBkAlNCEFHI4dHqPKcqJsE3cZGcAe1JKL0ze9fD8+Nt3i7+oaXMD9zVoj04aYeGs9QtgYw3qpu8GOqYVVErLXf5zsHoL55w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:43:35PM +0800, Chunyu Hu wrote:
> The test requires thp, skip the test when thp is not available to avoid
> false positive.
> 
> Tested with thp disabled kernel.
> Before the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..1
>   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
>   # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 60 transhuge-stress -d 20 # exit=1
> 
> After the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 5 transhuge-stress -d 20 # SKIP
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

