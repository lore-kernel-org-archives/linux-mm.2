Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548FDD4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCBA6B00FD; Sun, 18 Jan 2026 22:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4CD6B00FF; Sun, 18 Jan 2026 22:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7016B0100; Sun, 18 Jan 2026 22:45:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86C896B00FD
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:45:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25401140637
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:45:10 +0000 (UTC)
X-FDA: 84347322780.02.E302941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 555C416000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:45:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gwgkDOqH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768794308; a=rsa-sha256;
	cv=none;
	b=1Omol8UnSIMtA+GIM9I3bgGltFNLSfWht10IO8u5BkU7Ttbvmx0fCKok0WcdhCQgdGJDwZ
	mwp5UWr8/VHpXN3+RSUYMf3ohF5nnk6BhztE0iFxtVtl6MokuygDO6ZyOAdvnTAKiv9v8I
	kCPomVHkgADM9JLY+/fqdVZkKjlFJEY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gwgkDOqH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768794308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE9XSbYM4xPEN9ennPSo5PpDeYGx4uEzQnSoEdoa/Yk=;
	b=qRyW2L12DSql12yLkCyg6Sa9Pxt34hMWCAg13hVecYigV2vGnUnxO41e+AaPRLRw/Uy7dX
	SOX9u/HgAG53NhXr1Dd88UKOgktqtturdetPYzGZSoAaJCd5Ar4FupGr/rUg4IVaK9V7g6
	YUgoqM6S9tpoUcJipTP42eGnLmkULOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2333F43AA0;
	Mon, 19 Jan 2026 03:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E982C116C6;
	Mon, 19 Jan 2026 03:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768794307;
	bh=vJUyFP5PKvIHSLwRcVsSPUqjd7DJy7WczghqOwUYZXk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gwgkDOqHKc7lGnCLYfkUbrhvqX1dmb1qTe4dTwu3+MM8KPgCAaNPunJSCWE/JoOLQ
	 fDMlV6P43pUzQvTyMTN1TnfboXvvZ61u+W6uouCw9AZkESYyONRxo+wtK6aSXuum0+
	 shA/jtt+8T3P2gwFXGm+nyGOFcpziPJjoyorKQqs=
Date: Sun, 18 Jan 2026 19:45:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry
 split
Message-Id: <20260118194505.e798b3ff59d7ee521dc2d58f@linux-foundation.org>
In-Reply-To: <CAMgjq7AA1LoLopoFrmRBh5KiL75VtBORfTaR2Lafq3OttD5cDQ@mail.gmail.com>
References: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
	<20260118113315.b102a7728769f05c5aeec57c@linux-foundation.org>
	<CAMgjq7AA1LoLopoFrmRBh5KiL75VtBORfTaR2Lafq3OttD5cDQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 555C416000A
X-Stat-Signature: qh7icpomjqg1aegtmtt6cyni7gqwkbj6
X-Rspam-User: 
X-HE-Tag: 1768794308-606289
X-HE-Meta: U2FsdGVkX1+ZT2hKVeFn+02+SeD2uwuu7VtVu98+GknZNaBdf/BVuxLQFA6BM4SrCfU9WbJUsmh5//87YLXOegH76dsUE8Wg4V+iJNSxNDiYlLy1MYpRQYSnXO5Ihs65UYhUyoPgH2LOqV9N9/1WfTt/qdxaHi4P35Iu0s+w+zPSyRUO4RsDkwta5hRXGhsCIStxUE461d2S1marP27cWOz7zZLlC60nJtZxGB5LuTFdCVLXmKptXBj4GH1jf2SZCZ6JcMopc/MXCuKxb0738Ki8Gx8sqdQHTA+p+qCYnNpUWwtWj4I6HrBeQaUc1Lcc8hVpXzyD3OODQaHrmqqIvnc8rFBkgeeyhU9cz3vGp9w5zTOcbJ2qgARRsB4AbeMhsXVq83Pzpj3NGnn7ripAU8B8rFeR/+R/e0UvfpbAXsdXBArt10L1aiZHpNC8DxIlB4hlaaoFNDLUkJ/w75IvA+IdTkEBJQQgj5jHK1Fh6WlIGmqzurYC2/6eYT9vAtq2LimRB4sI3Xg5CwQIbDsSfwDiinhmxbDE75qKG63vwn0k9kubYgauLB3KIlPywDcLMhGWr/tplhOW+p+A/4AEZAiYI6fGDvMRBOjdbDNHW5pfDzorplo44bjF+h0hfq5EEqE34B+g6ffwdHO5E2gMAMoXfSgw/QAHPgCPhSWNDDo7DsIImaVErNQG0wxk8c5UKZCd6jTwpRn0H8ljWCKZRbUshRVvxXvuLpIrJLKykEjgjFRy7Fy9uEn/DnIJGeFZCGE2bGbaIWHydrYnY2UiKznwnolxwwMpk6dc4sqMRCfvSg7EV81cmaSgxNg8Wq1IDQtaRxLQe8iLEtSJCtpT2L3a7iYSPxhG/QoZ/9wNtitpnFPuop/BC/UEZFBH040esNsDaDb+uIVpjuQclXv/juvvwKEVliHT17U1GQRtDLv/HElkrfcdFLFBxqKcnRFITwah6upDlhxEo0wm27c
 uwC9U8l3
 Mz2Mmr7mwaX016inbr2R22rW5MitNxFLsX3C8uXFerNlBauTAsDGvTSA93T5FY9od6oiXMXD1a3SbrXAV9WYq7y0bJBmq7eRABvJe3y5XWX1NIsNkVUZ5lWPuYNvZ2CdcBnOSRm7fsgE3ehaWB4CBdhLodAW2+JsSivHy9Ine0TVm+gxODv7keKwRu/bVsoluavlpiOdyVdCWsrDVzo8tbF6QA/qgUa1Ffhi6HwdoXhPxYY9ALzCdiWgwzckaFLy0IujFn/06klgZJMSDGvtOkjLgTXU/LvPtRZOzOsFHN1rAEhk3EEcyRLM0wH27WNpLFs8K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026 10:17:50 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> >
> > What tree was this prepared against?
> >
> > Both Linus mainline and mm.git have
> >
> > : static long shmem_free_swap(struct address_space *mapping,
> > :                           pgoff_t index, void *radswap)
> > : {
> > :       int order = xa_get_order(&mapping->i_pages, index);
> > :       void *old;
> > :
> > :       old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
> > :       if (old != radswap)
> > :               return 0;
> > :       free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
> > :
> > :       return 1 << order;
> > : }
> >
> > but that free_swap_and_cache_nr() call is absent from your tree.
> 
> Oh, I tested and sent this patch based on mm-unstable, because the bug
> was found while I was testing swap table series. This is a 2 year old
> existing bug though. Swapoff during high system pressure is not a very
> common thing, and maybe mTHP for shmem is currently not very commonly
> used either? So maybe that's why no one found this issue.
> 
> free_swap_and_cache_nr is renamed to swap_put_entries_direct in
> mm-unstable, it's irrelevant to this fix or bug. The rename change was
> made here:
> https://lore.kernel.org/linux-mm/20251220-swap-table-p2-v5-14-8862a265a033@tencent.com/
> 
> Should I resend this patch base on the mainline and rebase that
> series? Or should we merge this in mm-unstable first then I can
> send seperate fixes for stable?

I think a clean fix against Linus mainline, please.  Then let's take a
look at what's needed to repair any later problems.


