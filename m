Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C4CC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0F46B039E; Sun, 16 Aug 2026 05:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781CC6B03A2; Sun, 16 Aug 2026 05:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697C96B03A3; Sun, 16 Aug 2026 05:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 436626B039E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:03:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 265AD1C17E7
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:03:19 +0000 (UTC)
X-FDA: 85106543718.12.08DC0A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7ADAD140008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:03:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhlJuTsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786870997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dRSSX2JAQZgwWhR5q7ZovzbG0pw2Sc7JhH34Ynua1Y=;
	b=qpBO8clTt3pYDA0H7/NwggCWL1FxQEKc0Vw5ciJ7HMbKaJYdLwDCxcP31BXoIk+hlEF9By
	50o6HVWIqEtyVxniBQfy0AMq7FU+2T9XNilkXBglmDaGFKQ2C6xKsCCh+XT70xWTT/5qPF
	cclTNEM49y6ogLCRZbyUrL/WEQF+WSY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhlJuTsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786870997;
	b=YkbToHGTTq0Rny2EZ4sIKwSjGsTLUW4pNNZ8jJiZNAGGM7NBRg/cirew5kKmwJHlQGmszb
	PPgBzR0zq4svuKFo82i6vT5oQhZMWgks82BcVu0Sa19ujFCqKzTRml1tQXYHSHKqpkGamU
	BED1um7JOcWIby7/OiweUSOgXCxNluM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0C5D40962;
	Sun, 16 Aug 2026 09:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC681F00A3A;
	Sun, 16 Aug 2026 09:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786870995;
	bh=8dRSSX2JAQZgwWhR5q7ZovzbG0pw2Sc7JhH34Ynua1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HhlJuTsS9etJriQhma1EQG8iRFbEildqNTcjp8UrZmjCy1Y5uyZVhxDqZ2UN7jX45
	 /UmEPju6KkW9SBS0sH5Ao29HbZ3Z10Qj2m51ct1m2ZQdSxr52E1SOmc/9PSmIZ5wDb
	 yRgDcOXTgeBylHjxFIR/piJvlU9UmKKSX6aYLaeKITrReJxEZvEgDvnzqphs8kRwS0
	 J7NCjjOaJ6NbSIM4WTO4+qJMk8FkR0qvpthCeYfRt3PDxuOPZj/PgdnKVEsnwEj/7z
	 pMUB8xnDnnAlObV5tuwZEQrEkq71yXpl+HpnF+51DEptXpjFV4NruVV3/cD2WR1Cbl
	 43c1uP2lb/vHg==
Date: Sun, 16 Aug 2026 12:03:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Maxi Saparov <maxi.saparov@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sdimitropoulos@coreweave.com,
	Maxi Saparov <masaparov@coreweave.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] kho: do not reserve scratch memory in the kdump kernel
Message-ID: <aoF8zPXiKpjt2Nsv@kernel.org>
References: <20260803193938.8778-1-maxi.saparov@gmail.com>
 <20260811161857.3096-1-maxi.saparov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811161857.3096-1-maxi.saparov@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8639p6j1rnth5tizpjrgf3bh3rpsejf4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7ADAD140008
X-HE-Tag: 1786870997-888352
X-HE-Meta: U2FsdGVkX18ser4P4XLIuQNeZiFnuwrDZlcg0rbqicV+GxV7E8e4CqHpmIdEJIo3xfP0TAf/l/eV8KQcpJ6/5F98tFO2yk6HAwcXMQiUGqdqd/u87yV3Ro3Uhn1KQtwW/R67MO1H0mAfOgZngZlJDBOcB8ga/Ey7Yt5tth79+2tE0tW+KnekrX4/C6U5uov6wNB6vxU8K9xVroZQZvKeB1lEoA7LzgwrQ5an+OT9b7QqgRlpLOa+n9SZ05j2MjJfbeHb7zhArqvn3kFndiN/HdcYDGm47CIbmk7J2AUBJ4BU/MGadodTZw46Ede/3ugmOAq8pMy1qben2LubTj06TqJHNVBnyqhByb3RuIBZia0t66BdbpCQAZGdrf4ajEzYj9QOGR6EVYr/msEwmQ6j6r5DdSGVmJiEtRihnLZgkSng0zIodafo6BasWopjSD+vBx/hjAEF5zLSI/f6mOsxYnKQ6eVOntWl8Z7CcWTO5YJ8roV26j7OVzQLyflDqRjii6Z884wwLhe2dQSWltL9FWh8JAC3TrXZMxFvhFf6Svrrm4Bmko6Zy+zdge2Ltm2VcqnUIAaeN8l2Mcm/SmRn2cfoDN5CynCAp4FDMMGZgsfk2dobx6kO+ecBp9az4K2U94J4ZZqx8rhT100+1H6DJ9O87Rb4GAmAEQ5205hcCAJ6CqkJSayLME24zdn1SNP9BeWch0D4dVGyj2/COpE3BOpc3PZkJqK2fKgU1z26+5BGtCehZ5XdCYrFLFBoAUmLkDVsAVHHnR7sb4ifwCmybT3Sdz26h/HjUkLNKTJO4wPpW9sjA8n9vJNPNyYy2V2SdiIlw2Eh04u2S+KCJz3V4fqXZ6Z/n5uxKSkVI1jbdi3kvK80N7xd5ocmW5JjUDLrLN+D3eOHfKpfkjCH7PKwMctRM3HbtBfF0hWknjO0kIPVb92uJpvbnDePI8ImlUwFCMeeLlprGO3rkcZsY0m
 waKDLUAZ
 gANS6DZfDCgZ3NHv60GhNhOxKV8dLTHVqDrNOdqiYP9MfNAAMMPZcn+SQh6obnOU1Fab5nf3J4yl76PjkIUJLnR7MFjue49Ob0JmbMw6F7LTTLlEnb0cdd2kt9YZBqw7MU9PXNiJqXSaqz8UwGhIBh+XVEcZyrPtKBBXrgKnXqaENgbC5rxdcY30Ve0/mevKEmSKr9jtKmijiuG4w1nA/Ej98/O4qdcwupSzOr1ushBIIu3yducpQSrUWFfUCuVQGMD1nKTx/H0VbMNnlArwwS6Q1CiRLAC7J/fYeCDdQ9aW0Epasf9OelUomk9ZxQAoOHNhjvdA6hRNqThgzvr/r6ZmveT6BmYEVA3DSdkGHOPgUP5zD/7a8MS4I5ZpZRk5e/0needIBCMCOiIvAgTK8/wAfZFj/rlkYhZln4SMG42sx597htE2gnw9+Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please don't send vN+1 as a reply to vN next time.

On Tue, Aug 11, 2026 at 12:18:57PM -0400, Maxi Saparov wrote:
> From: Maxi Saparov <masaparov@coreweave.com>
> 
> If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
> does not receive a handover FDT, it reserves KHO scratch memory in
> kho_reserve_scratch().
> 
> The kdump kernel always takes this path. Since commit a6715d7ec472
> ("kho: skip KHO for crash kernel"), the kernel does not add KHO
> metadata to the crash kimage. As a result, the kdump kernel never
> receives a handover FDT and always reserves scratch memory.
> 
> The kdump kernel boots in the small crashkernel= memory reservation.
> On our x86 hosts, the kernel and initramfs make approximately 176 MB
> of early reservations. The scratch areas then use approximately
> 650 MB more of the crashkernel memory. When a large early allocation
> fails, the kdump kernel panics:
> 
>   bio: can't create integrity buf pool
> 
> A kdump kernel has nothing to hand over: its only task is to dump the
> memory of the old kernel and reboot. Fix is to disable KHO at the top of
> kho_memory_init() so that the kdump kernel does not reserve scratch
> memory.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxi Saparov <masaparov@coreweave.com>

I queued this patch for v7.4, it'll appear in the liveupdate tree after the
merge window.

> ---
> v2: Move the kdump check to the top of kho_memory_init() as an early return.
> v1: https://lore.kernel.org/all/20260803193938.8778-1-maxi.saparov@gmail.com/
> 
>  kernel/liveupdate/kexec_handover.c | 7 +++++++
>  1 file changed, 7 insertions(+)

-- 
Sincerely yours,
Mike.

