Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5833BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45EAE6B00D0; Mon, 27 Jul 2026 08:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436E96B00D1; Mon, 27 Jul 2026 08:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CE76B00D2; Mon, 27 Jul 2026 08:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8F26B00D0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:04:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 892831406E7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:04:58 +0000 (UTC)
X-FDA: 85034425476.27.0975707
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CEE6E40007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:04:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo4Rpc5X;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785153896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/Y4BMKQ7cvWOkrCWMFKBxy8h6yza/pHmvLf8+MWpC0=;
	b=hQHToaSyu3CTOYXGGRCPjzumMWPxDCagq+uJk49RbBWF9toeqKUHerABnTywGY1zdY4Fro
	sTFC0SMB62Mil8lyjGJfA9Jo6J4XUuHIXHtm+kCr/NrswzLSfYNhb7+XJQc3F1cjgQISMu
	eBokzPRFsmzJ5KLdu5+AJEc7KwCnNSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785153896;
	b=D74+EbHq+jsA0XI+z5sQSlqYqT9qNy+fj8e0XFJxUztz82L6oMIZaJ3aVftjBiXs8Oq63Y
	YzJSv0NyT9ZN5p0HhPcXcimHbS0g0cV2z7A2ZkUKNzfuSYASRBxdAyc3D10Vl/HfykwrUE
	UGOF6cqi1qjyIYf9lOLfLbxFRzdIMbs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo4Rpc5X;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E4C141E93;
	Mon, 27 Jul 2026 12:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C13E1F000E9;
	Mon, 27 Jul 2026 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785153896;
	bh=r/Y4BMKQ7cvWOkrCWMFKBxy8h6yza/pHmvLf8+MWpC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fo4Rpc5XZE/gO7ztNgbEH/pgiIOPr/zvBxaoQr4BSg1RSpCdgvR1BqCMiVo1vnn+p
	 BNt2HreMH4K90PYfv2tC8FtD7a050B8K9yKCxsiLzjaRVHw0nq+lioDOLHraXJKj2L
	 gmzEsWNAEN8i8jTiZHhn3ozfLum9UNBed8Tr4PWmgVQRPqIBGLkiVe0qa2G5geMXdT
	 3u2lL4F+vFvb6TDUKi5dMHS7ltztpsh9E1f0rEVvmWwisGnjlpd5cPNxoSPmUql0AN
	 JcIR/yIDKpAm1+4ZcAxz4nlNdlAhQxEW+JzN8k4CM1O58zuRkXFcKpr66D+SgJrzc5
	 ECd0XnkJVmXow==
Date: Mon, 27 Jul 2026 13:04:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
Message-ID: <amdJPSyAEnF8g8qM@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720124812.30e04cc81a56dd6f0346cdf6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720124812.30e04cc81a56dd6f0346cdf6@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CEE6E40007
X-Stat-Signature: aem1fs67bkm3to34w1qz4dxngk4xbjtf
X-Rspam-User: 
X-HE-Tag: 1785153896-215204
X-HE-Meta: U2FsdGVkX19Zr72xpq1gikdNu87LeYRHKhZNmXe+k1fP0bRtPqYNQdqEHpo+O+2E2GvYbL5KBOxOY+W+FX6ElkAyjkBCU4pm1+twhURcJgCUdXBZiiTvemIyxPSlgQvRNwgMG+cxe76r2a4INpFYaCv9SAlRPoU/wIkjzWB/BtMdMkoknGyFbagwhxPL9c2SqKppNYBWYJdlqUVr7eV3JFNPuyQeojSRGZz+GbvI/pPm3l+cDWsISRc05bBEOA9BjqWQUZZyK95TF+UuP6PCWp/MYaSbgUWBndWiMpFw/VTL6gBE9cyBR/h+VPhBmvG7d2tZISR9mPk3shZhV0TLxt6qPpSXyINXFELVD2wez+JpPmqi9SatNMSWfwWvfAMMCZ6asIIkaPZcHBx07ZIQWpCxo2APmqwCNg1DoThVMi3NYnORa1oDSEzSBFtEEVa7Hxot/7RMaMfO4Qik1JLxL+xKIV7uBqjsL3uh/AHcQOamlM7Yi95n2jvqHg9cd3kCdW7RwWt3IOQmq2zg/O/CYsMvmBV0aCvTvGBomJCQTI9Xzmu9jpmroFtdUCys2Y34odUgJQV0P01qfGuA2nROvbANL2UGqCU2Vi7HD5NMefxvpZcKL03/j1XmVYhdhk57wcey7wiQVZmA1ouXgmCHG2kQclJxHGaD43Cic9HHyneQYnkGvzKeuSXYY6AAyHNmhXzRsAzVIa6U/IJ7hf15wB0aSJXrMhUf8mx7CmFBRwDLSp29tF2Q98xiW79c0wqmxCJvaiiSqbyHFC5xQFD6ZLb798VZwnVxleEn9WRxQc5d5FUkHFbBGy23BMvn08wImGsY18V4C0Z3gadZ4t/AY4VDBL/8c//DjouEWqnEfvTErVodmY2BZQKJkc8xwka+NUMGmbw6pPW17oc22k/gYHJ7Rzj/Fx9hT6/xdKGGOVqeFe/tNJ1M3I5jkMTqe/R3JQDfYK+X7bH+upsETDf
 lBOm7o0J
 6vR1iK2b/JB++Y8FW8S0br790d2o9LkdT23f/1FioG/jixvRN1RHijE+vh1eJwrWyRbXxHdl/8bc43hi9S3XyvRQwQl7CCRJJNm+kEYvSWUHD3fEGsyRLgl+dDaXGd64sfH9IDtp5vnH2xbTLGP2awIK7StUVYrvK/vWCLoke1RYpH/6shS7JmR+5Kq5tXBDhd8yLbEDzKhDvkLLIZwfITV+AAHpoJLb3mKASANdbatYTJCeLdU1XNiv1eWRId4dXt28hh5DBdZUJiAhQxMEWG+ilBxqVdIwQgJiZErCQr9K9CaqyIHXcDn/euGmIBBmEGjSYn4pw79scGBQh6z2eYYwS2IMPq37bQI94NxDAnPs48Ude/Ig2w/bg3xUEJrsVpV/RzauWHkvPgeUYZ3HgZvwoTXfNlrSiy3T/cTQrckYnaGHZaNrS6raJLvlpCjWs3YhsbGmArm61gKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 12:48:12PM -0700, Andrew Morton wrote:
> On Mon, 20 Jul 2026 15:38:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > In memory management we've managed to manufacture a great deal of confusion
> > around the concept of anonymous memory. We have:
> >
> > 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
> >    swap-backed (thus for reclaim purposes, treated as anonymous). These are
> >    simple enough.
> >
> > 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
> >    present in the page cache and mapped by an address_space object, but
> >    whose folios are also swap-backed (thus treated as anonymous for reclaim
> >    purposes).
> >
> > 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
> >    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
> >    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
> >    referencing a file, but are in every other sense anonymous, including the
> >    folios.
> >
> > 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
> >    and have file-backed folios until CoW'd, at which point those CoW'd
> >    folios are anonymous.
> >
> > This series fixes issues 3 and 4.
>
> Thanks, I'll add this to mm-new for review-n-test.
>
> AI review seems overloaded at present, might have found a few things:
> 	https://sashiko.dev/#/patchset/20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org
>

Thanks, will have a look through the sashiko stuff and see what's valid.

Cheers, Lorenzo

