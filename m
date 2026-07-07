Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7D2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150B56B00A3; Tue,  7 Jul 2026 07:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101626B00A4; Tue,  7 Jul 2026 07:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31FF6B00A5; Tue,  7 Jul 2026 07:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C09FE6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:11:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E5898DC65
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:11:14 +0000 (UTC)
X-FDA: 84961714068.19.35DF245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7A27C000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:11:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCONi7YL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783422672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTtyFBKpC/9Rr+IQFQF1FMdSFl6tkNhkuc41pgWUwKU=;
	b=cEGxvgSRQSotcLvAMPIvXTLOIg0xRO3Zl13K1ywzlWbpB3WRmtMPCWB54RUBdcwf2s8hzK
	ISwxF6xyjJUIuTRIZvzxDadfJBJSpdOwysnd2dFbgm0SQSWys7+LhZ6f64pYQVvM9M9vxC
	QGq/iuCUCbm85wMDqa30OEzsfuUNeCo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCONi7YL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783422672;
	b=rQ5aYkenE7E1SApOGwoBCR1UwatfgGVWIxOmH2snYaDN4juVdG+LZDQIodyfn5sKxcSRik
	fQnNMyirMq0xxz21T8hhPi0uAnjKxZipoVKaQhz7fGeQ4aqxCpai1YHl0CA/Ot0cK/z6dx
	4eoFxuKCNsQjWeKzrswlKSXGnwgGohQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20C3E618AC;
	Tue,  7 Jul 2026 11:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2678F1F000E9;
	Tue,  7 Jul 2026 11:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783422671;
	bh=iTtyFBKpC/9Rr+IQFQF1FMdSFl6tkNhkuc41pgWUwKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KCONi7YLJsHj83vwhEYusXcFZ1TyfVSY7LLadiJL59mR77UUle7xHU4OxBOPBYKMS
	 pgX65zNxXjhU3NIXPyRVMZOel1/3ooHBaL4eNPsZDAz1r8XfcTcohuvR/Now9vC7EY
	 HxS1gOol+eYn3y5HF9jZ5C20QgqBkGj2JTJwt87fZcthWOlWp5cnMnj9fZOd7ounwy
	 0sbCcjho8L+ai42lDB5Mhdp8hSjjnD3onbqbCJ5chwncEVh19RyZxk4iUV2gHYSHgd
	 iGJ3zKFfYkC0BEtHH+eaaepZH5C+tDY50+uoRgZnrwx82/slD617CeeIQoFqY00Dr2
	 WTuqa7U6gESpg==
Date: Tue, 7 Jul 2026 12:11:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/kconfig: Drop redundant memory hotplug dependencies
Message-ID: <akzecADgdyQjiDXW@lucifer>
References: <20260707090331.52971-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707090331.52971-1-kaitao.cheng@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7A27C000E
X-Stat-Signature: h38adfn5bzgbgac49t5tcc1qtm5pg7gj
X-Rspam-User: 
X-HE-Tag: 1783422672-317136
X-HE-Meta: U2FsdGVkX18sm4XsIH3SFUfBWajBqJkXtzvlhjen8aN+ek9AGDhg21RNGm6e3ZsFwTnJooybGOnG7ClNv48yHkmYCA/QX0EGxnCN6YbkVwUPrHWRdcOTJWUsCyE2SmQ+Pc0/O2zP+q5v6LvnF2V4xrBI6Qog5BIZpySQOSlphAcoxN9le2yg8+IRT0D5dISXTikEN74GifehKCRGUAz7STg1OY/LrRZUPeJCVL3uynh5ZzTEO1AvbpqalOlpLS8JgT7BuK9FTZZ2fXXB+Bqk3biko1JBGRgh3+Rqj5nTPsK3nn1s70OCi2d0tq5Bj2ITEaPLO6R1VZLgHaiBACrCHlICM3JLirdS2sDfIn5VShYt+7d3e/bYrqWR5XotYG3ZHjOsqStlBE1rOiqgHahPzGZTuT6q3swYbhzYqM1Bl2SsXdbk1cb4YyREGtNsMFQ1IMf8kgdodFRhzBHHZVBAT7Rj08ag4ET8HkDCDZk/OyPvqQN42xwKAMcFqPyafnbwFBvaHwzhPzkcNcyDmVvZfqVks+QOipVnPo7FLoLWpSn54HgwRtMqVe5DrkKLeYi8TzrzqQXUpGJoh3brA9BSUi0vRXfXBW+36Hjlj2E8Htpdc6kwTUf7W04erRjCMYMb6FXpv+ujvdJnDZghv5+kU93IJQkhBUCegcCpN6aVi0Nnaxp4BCRkb4qT/HlVgMonXPiWI9ml+FkJCHtWQtesmG6bVBbsHd9tC9ehIxIojeuaJWyK7Fio9ew/MWmil4BMRax6c6f/4SDHTmuY22L+uGtGWErY9jlykxqxwU6JkVCRRs0oJR1Y7t+QAO2p2DCEikm9Q/isLl9jZ/7ViugeoUS88oAkJ5RVR6T73dR+ZAyd15QNN0w5TTPnK7BKYETDHjpDR4OxhOMiJggtIJzi0TAEYmy8jcUR9HpwjJ7Dap+mWFobUZEu7HwTGK6c7jSs5O/GzryeuTqS4s4Q9Pe
 r6XKc3Ow
 HtCzXOs3mTtD4OQllbWWTDSv8JnzglUc2AVQyS42XLuRTsnejTKvQbvJfQPFMQQk2pzVLOsrJZT39klN/oHjYyWLoprFkL2MlAlhBCZ4kDcr3Pj0XrVHuTTanz11rocyNklzUtGT1E+sL5dE02M/LQoSQvBIZwUVZhztFepjA8H5JFFvcH0Md0BeNpshHQga/rEviqQLeIlASHCw/lbfKZt5wUJRBjzp110WR6hHRjpabuDyxjM8L03Mo6AxrdKilWXGpv5KI983YFmuL7mBZvfOK8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 05:03:31PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
> MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP. Keep the explicit
> MEMORY_HOTPLUG dependency for local readability, but drop the redundant
> SPARSEMEM_VMEMMAP dependency.
>
> ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG.
> MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP. Drop the direct
> MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.
>
> This does not change the set of valid configurations.
>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 04fe5171bb8c..ff29f770d10a 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -596,7 +596,7 @@ config MEMORY_HOTREMOVE
>
>  config MHP_MEMMAP_ON_MEMORY
>  	def_bool y
> -	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
> +	depends on MEMORY_HOTPLUG
>  	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
>
>  endif # MEMORY_HOTPLUG
> @@ -1235,9 +1235,7 @@ config ZONE_DMA32
>
>  config ZONE_DEVICE
>  	bool "Device memory (pmem, HMM, etc...) hotplug support"
> -	depends on MEMORY_HOTPLUG
>  	depends on MEMORY_HOTREMOVE
> -	depends on SPARSEMEM_VMEMMAP
>  	select XARRAY_MULTI
>
>  	help
> --
> 2.50.1 (Apple Git-155)
>

Cheers, Lorenzo

