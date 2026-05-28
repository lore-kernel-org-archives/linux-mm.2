Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE120CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06F16B0005; Thu, 28 May 2026 05:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7EC6B0088; Thu, 28 May 2026 05:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD7C6B008A; Thu, 28 May 2026 05:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A986C6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:11:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E389161E89
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:11:51 +0000 (UTC)
X-FDA: 84816261222.13.71406D4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id 33D5F140005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:11:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Vrh/3qbI";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779959509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FY8h7kXdRWrCKGwmIoPrgohMdQYzOStayEPWsBK1NQs=;
	b=hCIMSx7vd5PtGZXgg78iNWn4VPsc5bSJ9LrfzZobSSMJoXAEITYsB3kbQWKUuwlhnxj929
	O9/0P7u32MYkRnwpX63eCICQXpYiFFVbA+yZrrNiuyKPsyhMWUG61jGNP9BevMUd9tgv06
	WPaYINSPK66UAB9q3Y//yMfYQ7sypII=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Vrh/3qbI";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779959509; a=rsa-sha256;
	cv=none;
	b=bgW4VnntQlVkC7Ox998kp8Lv5tEnXDC4x82e++XV1ZQMvaAL78ifcDyrZGf5BuipLhT/Oh
	mQ+6RJaCwYHFSgBiQDedpfafKMZh4SnHm/EzNMm5MBS1HQzA+J5P/CefC2O4csrhqlG9Vb
	DS2ZmpDnSzkp9cSjekZrxqZo6j0Q1/Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1779959506;
	bh=p83yMS4+TIpBazfoCslnvC+pbsWKviEG8NJxRj91Z5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Vrh/3qbIeHhF0LcNWK4VFxyuYOLGXyBFmXNpXP5E2EQpByekeO8ScSpLmzIXU8LYp
	 DLs+GcuNc6I6sA/9/QMRRTCKJWj6cp/aNJjss0GuLYSZtjUC5iFkS91BSh1d6uWfTS
	 JHZwCOQLm0jgadq4oU55MgzkCq7GXY3pLGcIB7yabxnPW/iV1d1a+FHgL80ejNoahf
	 CUV1BNmeRqShjT2Q29buW5bKmlIdmJ3AfTXPrqXEf6epPXGnt1uN/j2fIjwVCDqg86
	 dPHiL6qPngF28vyJiCK/ueZY3HqUaF8g9l9duaJqy5aQjEvkaYwpWCQIrVdZkGP9+4
	 EvhH4LQvE8piA==
Received: from fedora (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0E0E317E0157;
	Thu, 28 May 2026 11:11:46 +0200 (CEST)
Date: Thu, 28 May 2026 11:11:40 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Igor Torrente <igor.torrente@collabora.com>,
 loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260528111140.2d9535b7@fedora>
In-Reply-To: <4a00d72c-9b87-4511-9da0-bcb40fae4d74@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
	<d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
	<850e8355-7884-405c-a70a-986ce032c019@suse.de>
	<831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
	<67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
	<20260527121832.7264f0db@fedora>
	<4a00d72c-9b87-4511-9da0-bcb40fae4d74@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33D5F140005
X-Stat-Signature: mmeiarn45w5qzxuhm71ntragyiu314eb
X-Rspam-User: 
X-HE-Tag: 1779959509-61558
X-HE-Meta: U2FsdGVkX1/52nlY7saa8Ap3KAVkQZz+L2ostwzK04x+1VhWtqVMO9zBrKMpmzhlkDPlff5QVsSnEs03s0FVuDaUaKxn+uO9bgVPaC4+GJD8HR406+GIqwEE2V6qAuY1+NHeWR1JFGLZG81N+pFRiYbqG+5rpQgdTJiRCycie9/RXTa85bE59a3HpMrlY5k2VD91AQdCordfc9+vPHmP3aLTfbiZS4xd3petEIqm2X/Eagr77UIkhi9gPfOpxkZjWX7thWjKg48tX/zyq6G7wsg6lIrTvS35YwelanDxLJGgsYI1azUr0gIJ6vm7q74SneTELcq2+WF7dagHUQJdmG/TkijYZQm21QkZqsDPU/n76fFILWS4QXUweUX8SJHMkMZ5FCnunHlclBEe4YR3fahjuUzhbaygqM/PhE+XHSRekOwiKksqVWS1x7d9jv/MWpqiWKA5qpRXChojRjAhiNGQzi9OTbqjb9Py6NgAPhrIkTYMIxZzx/bSwWitA+FLYlEp4JdZx34eETluC8ZMGHzMSeiTdhJRd3fpyCSTtCKgrxs+fOg63DMQYJ93dK67Eeu/tGGABXCCf7vLZ83H3MtbJjR8i/i79570jvH1GxuKm9FTMR9rN94b/VkbmLHRdBtpiyqK4cthewiNZKXyG8d+NftAnX6bnyYfHl3gAqRbJAvUetqrmQ2Ng9nOZ7BO2KYGMGiu82gXqX/NNraAKcPBTetCN4hn2Vwd6uyETwew0d68XJq2A9FovrjdpdKE73AuPvbgUzejJWkW57VE83UcVlXmuvgC2FXQCjAZVxejb6fbnlQ+n8jKeiqfmvFfc1m7BF3A+4D7k9Rm5BuY0iycCCNnzm+iZQKvtNS2BDqwYE74bulBnvktUK54NL4ca+RlzabTjuEjQFuRf/4aGj/E+dxgjVDhEA0zcZvTUzJNtSB1pnjtN+yuItW4NHq71FmfBdfDwN0Tuq5LlfF
 qDYRqWal
 +SRKELvFdAIbBoSj7tZ5vcE8motHKIw4BiUj6ZAg5qiWIq22MOaNK5h0N73M3OWPwle3LCdExrJSPXwPsz2j6haFuTEiTcl1UVV74W8z/pOaUGkPVXak5XyJeAcN5lvVNrIHpiK9P1haEHJ3nM1LjXtkJC6M0xpOc8/tob6BfSZJKt0pPAnkWZbMWUbpuJ0SBfZ3OfvMtEBS9wPW/E4wFTPdjgpzq+wbni9jDp5maQv7yI6NqVzGheg+2SYSVqcfAnm/XjvksfTiRah50CFUqKNcGNGqSpGA1qX0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 09:20:16 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
> 
> Am 27.05.26 um 12:18 schrieb Boris Brezillon:
> [...]
> >> -			return ret;
> >> +			return vmf_insert_pfn_pmd(vmf, pfn,
> >> +						  vmf->flags & FAULT_FLAG_WRITE);  
> > I believe we can go back to
> >
> > 			return vmf_insert_pfn_pmd(vmf, pfn, false);
> >
> > if the mappings are no longer adjusted to catch write accesses.  
> 
> If we don't install it as writable now, won't the kernel not split it up 
> into 4KiB pages when the actual write happens?

It will be installed as writeable right away, regardless of the write
parameter, because if pfn_mkwrite is not implemented, vma->vm_page_prot
won't be lowered to read-only in the first place, or at least that's
what I remember from the previous debugging session I've done.

