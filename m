Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5E4C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 02:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3198E0002; Mon, 21 Jul 2025 22:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AD68E0001; Mon, 21 Jul 2025 22:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890718E0002; Mon, 21 Jul 2025 22:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA1C8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:57:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E86A11D9159
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:57:02 +0000 (UTC)
X-FDA: 83690388684.30.F585725
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 382F416000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:57:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cH+vLsrV;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753153021; a=rsa-sha256;
	cv=none;
	b=kxUkx3GUiVomY4T0xAtK0TGetpYpEIXAIoFtk4L1PfQqZaQv1FD76ohc31kdy/pjU/+FKe
	o1L+GkMfoXQUfSapqH4/D5xAaUNw3C4gI3+gzpXB9GnEOatFoyAuIPnMtY3fD85cRC7CNL
	a29YhRhCWIM63ZxdRelGz46Kw0G2TBo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cH+vLsrV;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753153021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGEeXyCf3CtNTU+03DGp5qY+eJpoQMvAf+tPNbLWeqI=;
	b=qKOakUFw0kZheqrcAwKbna+qZWvwkqnyiHtuSWc5JUxQzcSIzhQJ6lez4usBNTq8Y35ojt
	JKSvqULPBJG/A6msOYDpxUxb6UzW4gTEkqfrnUk6tAvdyzj+3OdKziHFHtxhpY4eflTUNb
	ejrW2Uoo0ZhoiTHL2VTvnY2Ne3+HlpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB1B14515E;
	Tue, 22 Jul 2025 02:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD9DC4CEED;
	Tue, 22 Jul 2025 02:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153019;
	bh=G7jQ6vjBrqcdcBX+jOv7jqiqfBiR8qm0tzxZNdDuSaM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cH+vLsrVZoH4KqNu503CPJ9lIkgdrp545L9MHiaJl0W811QxEoe+jKilhKk4mVv4n
	 40cmLnuGhJFlmawaPAhz2jFRLSHh3XGH+QpeEdU61Pw/TzXGj37YgUZsoagBEPQJ9E
	 nc7QPywYP8zhtOHPLDIAUcuxbqkqiioHAQPNIFbY=
Date: Mon, 21 Jul 2025 19:56:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>, Hyeongtak Ji <hyeongtak.ji@sk.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/ops-common: ignore migration request to
 invalid nodes
Message-Id: <20250721195658.935f5e2436045cc311575c9c@linux-foundation.org>
In-Reply-To: <20250720185822.1451-1-sj@kernel.org>
References: <20250720185822.1451-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 382F416000B
X-Stat-Signature: 73kk48raofp6xjfdezrio89kwfof7k3h
X-HE-Tag: 1753153021-445968
X-HE-Meta: U2FsdGVkX19KBVqY7yQau2JdtOpiBtlLi6vvr15ux9OS/ZmRnW6hI1TI9Dvug8xth95iMwed8hsLMtuOU+RDZmq1+K/O4oHEX7fA/ZMGkmD+wzO/F2z85Br4brAlLkmgbWC00MhXhTphm4jwRUTJe7llxnPXEaFqhhnlcSwLqZHRmNUC9xEyETbP+WFKTShl2gtGXChg4TfGJy+YcNO02TfdQ0MmbJ9bSFi39bLVFAq0kCTbqsHGIeD10ywYtIKn+NUPZ6fFRWP9DE4DzxRzxkMlAINWM9um9GVacu2bwyZZa4MfniY2ZQ/H20xxUZETZwBo87K1s9UDSfmUms5Op52Ln3AprNbLLYrJRnWQx1Cqo1xydd++4S7yUOXViZj7ToeUCC4TNNngt2Utk7S9f7sPPpVyef2qBKDJX1s0K0j9SIaSyx7qq/X4AJHd6A+YSMMYSrcrigD61dbqw48rnBFXwnR7QardfPjTKnUnejcZRsewcW7zu5+PQo2CfTE+5dm/pW3kK2ppFv3cSazFqHglKGAPLev3PuwzEbGcElhQrs5MzmBSwl72mi8HQ7Pqprj0AkJlDW3UC8uKb8DzqHwVOqKe32Kuu5Bnl+LDE+fXcepVFFDbe1QkInsSgh5pOPqw34ovi29xFU1xz7QJ/UZuqK8f0ecM3PUuGX0y2eWUDd+RE8bl4rQPU4t/knipnCntbRz5gRbzR7kqG5Je8lXu66+zO5Ifv5UwCjN3Aw/oDCQ6J/b7GkQ5ty4wE1oTh+2hVOKFTVmNZJ0Lj7QCZstKCyVHIZYLZCN0KJIgOLHaFZvzdXSjLI3Dd6nN6YHtrtA0ECHC/r09+xhK5s7CtaXGLkQBg2WGp2mNIhi+vK96Cp1VOm38Lae+m/t2I4Tz7rHeaideozAhm6/MYyZwc+Q206Ao6yw2CGONIMuq0kwilkLYR9qAFpgDO0pq6AM6J29Jt4FuBTG2qov3w3Z
 n5nWb0Ll
 Ie21zlvPAZpiXl7vCPb1I4H70frSscwc810bYaPOMK7UgZZOHtKX2R9FdvZZWEXz2bnoVxFRaUXTxWj2rYTLj2q2OCNC/tr8ivbxoX6fROv5XSjlxToQYbLP/7HlB0HE3ilIs2MXcHh0v9fmC2A07lGu5X8LFgOyYKl1q57FKe2fyzxfmf4v4kxpPUzLAzGXRRerwwnurblw4UrOJc56b9MicN3cQk9TNaG671NfstR4nLiKhWYzADaxd6H5BLYA19OkkK/7cEbgm/t0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Jul 2025 11:58:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> damon_migrate_pages() try migration even if the target node is invalid.
> If users mistakenly make such invalid requests via
> DAMOS_MIGRATE_{HOT,COLD} action, below kernel BUG can happen.
> 
>     [ 7831.883495] BUG: unable to handle page fault for address: 0000000000001f48
>     [ 7831.884160] #PF: supervisor read access in kernel mode
>     [ 7831.884681] #PF: error_code(0x0000) - not-present page
>     [ 7831.885203] PGD 0 P4D 0
>     [ 7831.885468] Oops: Oops: 0000 [#1] SMP PTI
>     [ 7831.885852] CPU: 31 UID: 0 PID: 94202 Comm: kdamond.0 Not tainted 6.16.0-rc5-mm-new-damon+ #93 PREEMPT(voluntary)
>     [ 7831.886913] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-4.el9 04/01/2014
>     [ 7831.887777] RIP: 0010:__alloc_frozen_pages_noprof (include/linux/mmzone.h:1724 include/linux/mmzone.h:1750 mm/page_alloc.c:4936 mm/page_alloc.c:5137)
>     [...]
>     [ 7831.895953] Call Trace:
>     [ 7831.896195]  <TASK>
>     [ 7831.896397] __folio_alloc_noprof (mm/page_alloc.c:5183 mm/page_alloc.c:5192)
>     [ 7831.896787] migrate_pages_batch (mm/migrate.c:1189 mm/migrate.c:1851)
>     [ 7831.897228] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
>     [ 7831.897735] migrate_pages (mm/migrate.c:2078)
>     [ 7831.898141] ? __pfx_alloc_migration_target (mm/migrate.c:2137)
>     [ 7831.898664] damon_migrate_folio_list (mm/damon/ops-common.c:321 mm/damon/ops-common.c:354)
>     [ 7831.899140] damon_migrate_pages (mm/damon/ops-common.c:405)
>     [...]
> 
> Add a target node validity check in damon_migrate_pages().  The validity
> check is stolen from that of do_pages_move(), which is being used for
> move_pages() system call.
> 
> Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion") # 6.11.x
> Cc: stable@vger.kernel.org
>
> ...
>
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -383,6 +383,10 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>  	if (list_empty(folio_list))
>  		return nr_migrated;
>  
> +	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
> +			!node_state(target_nid, N_MEMORY))
> +		return nr_migrated;
> +
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	nid = folio_nid(lru_to_folio(folio_list));
> 

OK.  damon_migrate_pages() exists only in mm.git thanks to 13dde31db71f
("mm/damon: move migration helpers from paddr to ops-common").  I
assume that you'll send the -stable people a patch which adds this check into
damon_pa_migrate_pages() when called upon to do so.


