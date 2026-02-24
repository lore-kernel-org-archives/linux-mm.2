Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF29F4BB6D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9B76B0089; Tue, 24 Feb 2026 13:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DE46B008C; Tue, 24 Feb 2026 13:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAEC6B0092; Tue, 24 Feb 2026 13:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57B0E6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:30:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28B3E16029D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:30:26 +0000 (UTC)
X-FDA: 84480190452.23.40D7413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E1501C0014
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:30:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QzewLFPn;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771957824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94dHBgPUUePVak/rdKND5FHtTqnQ1dk37LGw+ZurhKA=;
	b=T+9qYuvDYtkf2tevBE9UM9LwypARrnQ7d65qaIEcl9QIHzrYw8Hn5hlKob7tdw5bcabqW7
	CXWBrtAJebqcyFk6tKVLjFsAW9vA1QxYSHdEyTsWjy69kewBcvBJUlSHmBEK4AJAgm2TX0
	VUs0iXPObyOHgEBWLzAdZEyJ0bJsisM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QzewLFPn;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771957824; a=rsa-sha256;
	cv=none;
	b=lsJ4UnrokW/4/r6u1PYsUL/IjibXS/AAqWqL1nw7Vmr8X2c86BCG0S6rXaGVzuicHZEUpj
	ktazSlo9/37dr5QO0BYEADXbu3O7EosK3g77XlrGW88rvU9Jbh6s3evFM/6cHBPKEcOQjz
	jycSPfaGgIkJc/9N/qOgx0S2lhrvGNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DB5A405CB;
	Tue, 24 Feb 2026 18:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60B9C116D0;
	Tue, 24 Feb 2026 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771957823;
	bh=03PWhkdD8XDT0HwrAZ3Kruf1L2fD8kllDVsuQ4ULThU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QzewLFPnkpX7XAGPNb46J/oYeLhg5Sbv+ZU8d9yddomnEJo9fjEr5oS+/uBoPGdbY
	 Lj49QjcIUmAeMDTIvDm/o5GnhotGNYBku3on7Y6MDic3ueaVl+AzkGOgdckoqtM/Hl
	 0/vSzVPpaatfu/u2upS2JH4WXD2WWiBfogTyTue0=
Date: Tue, 24 Feb 2026 10:30:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, Pratyush
 Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] kho: make preserved pages compatible with
 deferred struct page init
Message-Id: <20260224103022.37b8b6d1cd11e11aef192c87@linux-foundation.org>
In-Reply-To: <20260220165203.3213375-3-mclapinski@google.com>
References: <20260220165203.3213375-1-mclapinski@google.com>
	<20260220165203.3213375-3-mclapinski@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n16mpdiaw136adtsrufks1scyubzya4i
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E1501C0014
X-Rspamd-Server: rspam01
X-HE-Tag: 1771957824-66298
X-HE-Meta: U2FsdGVkX19OGWB9fOU8ZnKab0j26ZW07ciwFl38vDipMvTp8GonSdbKpwYgxbdYipy4SpDeMWxxidT4JuSAI8iNBdOAwSTnzsr8y/JLo/Tw3kexjM//eJzWm1FiYFmgydBkNMcEqsQmLD6Y2x1MQxGaHTMIjoLDfuMq+YQ8jzjrca7lPOkhNGOO70I7US+v+ylMLDpsviUvjogfzljbBDgz+dCuH466yGHDR8WMuKZNFTbLIu9Xbm8pj7VweBl1c0ADKV0ftN4J+Il/MixqA4XGVP6g2bO1NXuBSKo4CDz+bBzpxm4gAs0DdFoFQxppFEX6S+43miDaGEry94aK1Dikdn+dOc2m4Tzunxv0q+hZDxAC+15RIQY6ZqzJykfKDlAvkXYuCt4+K7vJk628fJRdSCpxbEuvMk8UkMJBCNzkP09rb9PVeZmGLlDm186nWUekZIKGLDdaxPU2xA/1W9VFKvXk8Hz4d0lfaK4d697Cl8T99IIy9nVqQEba3fFCw4PSk2zM7S7q3XJy8jqco11ITdOWMU+MezsC3qTDiA8+iLTKfkANgS/G2KhOcNnJD1yWjHlxUgCq1DPb+Cn5XvVj+k5LohP9LaowZl92sZ67vjzN5NV5XvT0NR6/HQVjVbm6YbAFwdWEJp3Uiibcgl1Tl4b3L0i3+/5XD/EA19U8LmmjRQPg8la7N+Q0ZOfBDU76x9FmxsOH6CdIwKMA0yBJuDf2/bQkAtx7DYzR2mUfs4C0TiwDVWFceXedsdMf8QEw9/tKPFO8FiVaijvznqw4r0/pwzyYqPJrkn7fwu/GTAQXZZ3jyWZRRPcPCvUX171I+QJPZ6TQNg4yRDSiKzTT5rg4uPh4+L43JO7HfFFUiYGriUK13HE4+xVM6W04FqGOiau/owAcJkHqVjPKOfHjdZfjdwi9i74/+H/FznQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026 17:52:03 +0100 Michal Clapinski <mclapinski@google.com> wrote:

> From: Evangelos Petrongonas <epetron@amazon.de>
> 
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
> 
> During KHO restoration, deserialize_bitmap() writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> BUG: unable to handle page fault for address: ...
> 
> Fix this by introducing kho_get_preserved_page(),  which ensures
> all struct pages in a preserved region are initialized by calling
> init_deferred_page() which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
> 
> ...
>
>  static void __init deserialize_bitmap(unsigned int order,
>  				      struct khoser_mem_bitmap_ptr *elm)
>  {

Doesn't exist any more!

Can you please rework, retest and resend against mm.git's mm-new
branch?

	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Thanks.

