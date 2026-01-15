Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D129D3CC9E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 01:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B496B0005; Wed, 14 Jan 2026 20:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8DE6B0089; Wed, 14 Jan 2026 20:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7C96B008A; Wed, 14 Jan 2026 20:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66C746B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:27:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CABCF56338
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:27:45 +0000 (UTC)
X-FDA: 84332461290.10.28783CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3FEC040009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:27:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WaCZwQ2l;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768440464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nFOQdtCY5WT4xucC+l+5Wmqy1J150GYREjDqaA3sxY=;
	b=sLiNDvG/lPuNG5a9ouTnFrKlvyz7wvmlnVba8vDJclxtB79XbnnmJXL640yRWeDn9d3FYq
	xSYTXrWbgMxzfPPp3Hl2fUijxgJIlPSLXt4mS75sic+AflAQ6V/6w1xxgel3Cj4Gt8IFbN
	oFQAlydK3DMwSPSft1Lnt26e7UeHA0s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WaCZwQ2l;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768440464; a=rsa-sha256;
	cv=none;
	b=W3DlcrCNEg0AYHX1J8jFnlQ4OJmpzS58OdvWpXf6jJwMUCbxQG/dEnFV5aPrflFGHfIsCm
	bApa2IYQvSY2nrr+sIPT59lPj7zYYzxol5F/ksYIZWC3nb2Oh/1jF7hXQAiGwPrQG9vcDR
	EgOyJ/NJcoklJkFxqnfqD8g5lBxnMII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74B3060008;
	Thu, 15 Jan 2026 01:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902FAC4CEF7;
	Thu, 15 Jan 2026 01:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768440463;
	bh=pQ8j9Tn71UcjHmJ1kXhLWOF2qZTGUivD/SECa9XZwOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WaCZwQ2lpVB23m9mvRB7P1BdVy4CxTZrspTarWWH7iC1Y7Vm/y2UnRmacHj8EcHAi
	 ILBqqksvYmtDVXZ3XjC5q4/lRdA6RQISezqaHVwQig0DO+PKG9cDjQodE6vsbkLH2g
	 IIRxd/QP6TbOPmU3cW4acl9BGtSbgdbu/uCwtsCg=
Date: Wed, 14 Jan 2026 17:27:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <robin.kuo@mediatek.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthias Brugger
 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, <wsd_upstream@mediatek.com>,
 <casper.li@mediatek.com>, <chinwen.chang@mediatek.com>,
 <Andrew.Yang@mediatek.com>, <Qun-wei.Lin@mediatek.com>,
 <oliver.sang@intel.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 1/1] Restore swap_space attr aviod krn panic
Message-Id: <20260114172741.b8b6cb9aae39a5ae7a199eed@linux-foundation.org>
In-Reply-To: <20260115001405.3513440-1-robin.kuo@mediatek.com>
References: <20260115001405.3513440-1-robin.kuo@mediatek.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FEC040009
X-Stat-Signature: yc4j4ompxd1uw3whiqubwfswugxdncby
X-HE-Tag: 1768440464-617379
X-HE-Meta: U2FsdGVkX1/lYggZ3myUhLtV/MrEZ5rgNZXETSWZUWPzgKR3YT/+AHQQ+MaxFu/DcYmQc2GGXGskjpHxv93OJSzQO/+Qmen7+bKadceBN1KdxUA/rPuMnS5jPfAPVDLLFGAqPGW7280zAGc3z7GPvDnCREVY+q5vuq/j1AbJ1frZNyXd0bcs6fdov5MwRhJtmPZ5+k0A8AZgweX78meEqPxZ3Qb7XY7uNKxUF3ZmViJGx6z+8xMsn4V63SaOiCwC8DJSOoUHU/5N3Q/um9pH21DxEbmt53XZahZXCFT4hL6rxTHztBHPnbiRxuz7wsELV6uyO+uGqd0I4H/LJFUYATVkrTHSiRQH3DU+4zn5+nZ0RoRFUlZu0LngqIX6FEJFPaTTmlfbfzlqhA/hgfs4GM1e6qkGzcGaRp8JGs46rqi8aq+s9bRGXttbRmlPRj7vxj1CmweukkBXq1GFU+YtC95Nbg/GqwEV22iz1+WTF9roaKtZsua3Y8jGl1RyfUtADySZU2jYifMySsZmSEEFo0c/4WTO/TArGdyrZAWuzV+6m32Mf+EAnsMwF+6RpGJdNmeqBoRJVjGNjhZh17j6ITbEJsE8oSwW4BKQQAog70ax8FcT+8HW6vwzmcumvrxGwQCze9cvquyLF0BvvwuSpq0/qu4LWZJZJfbV58huFiFEWnHu0DuUXIQ+sOlqRJviYl8i1/53QfrbylB1Utw4Cbn8lC+0bmRqBOtUQa99cWr+bfix4H2vFeybONOrEj9Lz/p8G/4/yNiqhTgNb/EdZGM05hVOFFQhEkt5KMD6qtaqk/foPBO5QSuq+0RMRvukvq1ZDT7l0ZAeakuC3jibb2MWEGNHzAKq/QZnOCCGNA/sPjto+g971DpfjPznIdsjZcYrrwVITbnG38O4xUEigMNWdje0KdFkrEXr8x2Bhg00jmUXOVStuBvahlinB0ioI09V+xpbr+B7LsryAdZ
 4q7eFwMu
 Hu3iLhUY42y0NGoWN3nx/lh1dcOo1WaDEudFhouH+nM2b6+qTvkx3BiL3yMH4p4vaJHr2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 08:13:43 +0800 <robin.kuo@mediatek.com> wrote:

> From: "robin.kuo" <robin.kuo@mediatek.com>
> 
> Restore swap_space attr avoid krn panic

Thanks, and welcome to Linux ;)

> Commit 8b47299a411a ('mm, swap: mark swap address space ro and add
> context debug check') made the swap address space read-only.
> It may lead to kernel panic if arch_prepare_to_swap returns a failure 
> under heavy memory pressure as follows,
> 
> el1_abort+0x40/0x64
> el1h_64_sync_handler+0x48/0xcc
> el1h_64_sync+0x84/0x88
> errseq_set+0x4c/0xb8 (P)
> __filemap_set_wb_err+0x20/0xd0
> shrink_folio_list+0xc20/0x11cc
> evict_folios+0x1520/0x1be4
> try_to_shrink_lruvec+0x27c/0x3dc
> shrink_one+0x9c/0x228
> shrink_node+0xb3c/0xeac
> do_try_to_free_pages+0x170/0x4f0
> try_to_free_pages+0x334/0x534
> __alloc_pages_direct_reclaim+0x90/0x158
> __alloc_pages_slowpath+0x334/0x588
> __alloc_frozen_pages_noprof+0x224/0x2fc
> __folio_alloc_noprof+0x14/0x64
> vma_alloc_zeroed_movable_folio+0x34/0x44
> do_pte_missing+0xad4/0x1040
> handle_mm_fault+0x4a4/0x790
> do_page_fault+0x288/0x5f8
> do_translation_fault+0x38/0x54
> do_mem_abort+0x54/0xa8
> 
> Restore swap address space as not ro to avoid the panic.

Well damn.  We have checking tools which should be able to detect this:
we referenced something which was dropped from kernel memory in the
calling function's context.  i don't know who I should report this to.

I shall add cc:stable to this patch, to help ensure that it is
backported into 6.18.x.



