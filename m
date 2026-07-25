Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735DFC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 04:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B106B007B; Sat, 25 Jul 2026 00:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534136B0088; Sat, 25 Jul 2026 00:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B116B008A; Sat, 25 Jul 2026 00:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2289A6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:43:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 832141A0278
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:43:11 +0000 (UTC)
X-FDA: 85026054582.16.7D8A481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 484CDC0002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:43:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YYLVcaSB;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784954589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1u/LUYrvJduI+Esv/eZmDncR/EueSm9YSJbi69UyDUo=;
	b=KJrAw7AWIhpk9ddlp3XtYabLqW9bdOkVPOQsjjdJ4fYqAGV9b44iIfqYWNVckiA7fbAutU
	w4nGMaUVosHDYipNeWIR2CgXRZH8FKdFp770iFYyHkUfN4hVTHSvY5+wo/+m7ZNHbb0vEG
	Ps73NgrK1CMRcbHKXQzY2aF64uoiyrw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YYLVcaSB;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784954589;
	b=PWldI9m7RB26pg2TKyBlvkRrrt8i9TCBZ/8rFK9ZC0ki+iaEQLJDpaF2ZUAYHs4pjGmuyN
	ejczMiPA9WUW9MxDTLBQuMUXtbC/gpbsZWJZQkUR5u0A3N9ilbgER5Q8M7BoX1hg+EUa8C
	zg37D2brT6ygGyuLeA10lQ9N/RqINSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6167540D9D;
	Sat, 25 Jul 2026 04:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE541F000E9;
	Sat, 25 Jul 2026 04:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784954588;
	bh=1u/LUYrvJduI+Esv/eZmDncR/EueSm9YSJbi69UyDUo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YYLVcaSBRG4xJEz/Rj5RCArRccKxu5I83sxBKYg3SUXDyDQhQTIBKKyXfAHw3V+wK
	 dccoYnxI9aXpX9Y0V18K+LBC60yXhl4bgOYwB9RefCtlhO2bnYg3P8SZaUnldUjzqb
	 fuboSj9kpm3xEEKLqoDRmbXzubxavL0mWbSzVfnc=
Date: Fri, 24 Jul 2026 21:43:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arvind Yadav <arvind.yadav@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, ziy@nvidia.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, Balbir Singh
 <balbirs@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Message-Id: <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
In-Reply-To: <20260724082702.2531024-1-arvind.yadav@intel.com>
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 484CDC0002
X-Rspam-User: 
X-Stat-Signature: 7y66uip1nn3z5c594w3hxtfkhiixdpzm
X-Rspamd-Server: rspam04
X-HE-Tag: 1784954589-36672
X-HE-Meta: U2FsdGVkX1+5AkwoRXCiHzu6HEpra2gVeS2DLPglIm+DJjq/nQjMD04Br/tUJdOwtcwLr/oP2rWoVIQmpUiHNSuc+JR+pku4M5tuP++zpnVpD2hv34WTDUr6114M6UDb97dtvc/sv9vIzH+ww3O3U8oVm9+x4SAW3XP6ShD4YsbM7a2FEkIcLdNKNuVufdbNRnpajwIp/Tk/CA2zCSllWzrcddZIR75Zt7fy10U7Ncomju0zKZFeXPkl6m8Qpr0j6/+S1xlEGBrNo6rf7Fw+uHymzmb2VznGgm1IH7I4HQz024PeqxbPna8OxDDRLD7JeAXrec4ViP5vnTiQ6adcF/YjcrLbrtlbIXrO347xfictcDqlSqulzsYCNbOpRMPKdI4StWYMdVvuI/t8y9Kx4ZAe5dozkYn8W9DExFyACavOim5OyaMuQmSofvwLDmO98t2nDLyIF0sIh5Sm9ktG7pss8SirHQMlVggTcK/lwU9NR0lPhKt4wqAIGdPOCMzrFk3uWPWTCYJ4Ky0KldDOMCsdGM2eYBGwSyvvT3by31p3AgY+eqYgIB4hUhpgs8A+BRCOhZA+3t5g4hd/3b56+HEAIBRZSNLeXLY1sBk7s3vAl4J47HQ1p2OET94jgol5CYCth524ZLBwFlua84HwFiO/KKr+s1/KnlWJ2NwEAld4TsE8hl0kaFYVs+rKru//guv8IY94NvacrsNNKpXcRB56VDAVAah1L6UQNQdik5bWazEYxS2qkHvwTKy355ateIqSHrBXJ12Rq9kVbwwstxSu0qHo5zPyvA183JUAbExKO8/qzHdY8Sg2i7QsouyuYrfb6S92wjLqTdS3zPpnlK9KfkV4GArMpIs5+cyERu4w97k3Vmx+OoMRVIbyjTMfX8eKcr5rVEFO0OpTwhCrQWa5nTqMfvS62OOi7KBYAS9Xqf9IAjpfuivK2OCqCVednJ8Dy/voRFKtdHQ3rN4
 lRpOeYVX
 d8TkclcdfAkktMXbuD0tjp20u9RoUkSjFhbhKr+UcYn/M98pSpZ6p8ghxCFgwUxYSWZ/c20oTt+Er0Js6QAoMdO9bWi1kUlpz3Zk07CGFqaKTdiCp5pg8WSSbydbTO+5QUgDPwd7QHg5LHSWIHIV40YFld07SoiASCCPNg1xMq3R4yoCkbdNtjx3H/QhGsMSynJWDJyANf58VtDHi0ydJwMQ2BaOg1qRgRu8IrldOQLP/TSGEQzZJ6MO7dCSnZLYWnk0MS7OGVQiNe+7l7IFHJMK7mlQyDG0Lhl/1fK7uEOs3CcBN0GY7vP8KmYL6D4ay0zS0eyzMIKeYA3vSdxMCpT7bHXjPdlo6Vf3m6nJkzQS66xmx1T0R/lHOdqCwlM0DjHkypUTz9p8qQfIR5/9bUWke1BSZTq4prvV1Tw/6GXsdavHdsIBdis1xuA9jAoM3dfgrnOpnH9ho68bGVtdeZ1leJwW9QgKSjeXx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com> wrote:

> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
> 
> Passing the stale mapping to folio_migrate_mapping() makes it take the
> mapped-folio path after the swapcache reference has been dropped. This can
> cause an invalid swap_space lock access followed by a folio reference
> count BUG.
> 
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
> 

Thanks.  AI review might have found an issue with this.  And one
possible pre-existing issue in the code which Alistair and Balbir
worked on.

	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@intel.com

