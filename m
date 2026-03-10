Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC604FCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F16E6B0088; Tue, 10 Mar 2026 04:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2750B6B008A; Tue, 10 Mar 2026 04:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1811A6B008C; Tue, 10 Mar 2026 04:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 089CD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:39:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD8E2B973C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:39:40 +0000 (UTC)
X-FDA: 84529504920.10.9DFFE54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1191040006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:39:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IgV+/w8O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvTuI5e/v4ITnyizhqNfbGVqo3AxDWqnzY3yfyFe6Wc=;
	b=0Ccwn/mL+L/CUMZsiSht6B4eWgbfKuzPhaKcz+8wp8GRUAugLDCpf4BhxbI4NK9qu+vCzg
	q/QU/Fsjd51tBCBiLRf5XFjbk/3ITlu+FsF521TUN1q7qbA0yR4+wYqB4tX4fX8h9bFQGO
	f3B4/9e/dhs48MMlzhZvQsitgOCgD9Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IgV+/w8O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773131979; a=rsa-sha256;
	cv=none;
	b=jmSJUp9vVVnxCKDCLOsYvgDw7u53/ZY0kyMml2f7eG6qMq63KR7u8rVo/7erYdCub8CM+s
	HOlrzWISzpBPZh4b0ml//vdYUNPCT5P5bt4AnXt+zUChyPsMhXCfDOXWXMh8ai1GYnfnVy
	mbFR1QT2YOf3j6xLkKxkJ77+3dr4OX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 166B544358;
	Tue, 10 Mar 2026 08:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6993C19423;
	Tue, 10 Mar 2026 08:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773131977;
	bh=OvTuI5e/v4ITnyizhqNfbGVqo3AxDWqnzY3yfyFe6Wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgV+/w8O3GgzKq1ABNb2HtKj+DPFzHORrYG7fSDM5JH2L4g+/YjmwxspHj4bGvWye
	 Wm+Wdd9OMD0rRKj+w3kWRJ7DcGkBZtcYVi2Ktc2uVsgpF9PcX+qikwgomItdNULvRV
	 3z+nI4yxFcfkqd4Z5HexyUGCuxH3V14QP99d5fOpWh2dZh8t45Q0ISXUx3rW/sPlOC
	 8xZwrKSqhlBHXweI2UYLq9iP4SS9vgTO0EzdZxs5IHdRMH30xnVgQEkWIqw++7VdR2
	 yuyOBV88edQ77ZwIs2PdOnKD9hGhsMwBSqqHCfgKzH+KgGaOV7j6OskXyknCanh3nK
	 fB9S7PV8r/NrA==
Date: Tue, 10 Mar 2026 08:39:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 2/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
Message-ID: <b8f4ae76-7e96-4579-9b08-9913734262fb@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-3-dev.jain@arm.com>
 <92b8f168-b135-4c2b-a0be-36c8f8079684@lucifer.local>
 <58b3878a-24fe-4ed1-a870-604b44da71f7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b3878a-24fe-4ed1-a870-604b44da71f7@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1191040006
X-Stat-Signature: 8sk4fxoi9kk1mpxnqdztsbci6huf5x1y
X-Rspam-User: 
X-HE-Tag: 1773131978-317801
X-HE-Meta: U2FsdGVkX1+i3Fbw4+nXbib6jUXkRNxyIxSDBF52aRUTYHjafURFdaoohvAHt8WZqDa5T4DvolDawIV/Bmc3vHpcHQmZ4o6M2Y0nG/6v08r73DXBgBFKPgtEFlMVpXeSAC83c60Gm5gxuVaL+MZQjobH+Zc4PwVMjOTplCtMEMPnqy3Y+R8BWIkFNLd0FYnP0OrvPG94f/TxmQZnvYbBoUvVNpm8Bz9rgiIJdUQwns4dEx+LbhSn0sHCwFIRVU+iacHfWy0lbmM5lCQyhrWORyKQ0pZHC2oLEf+S9fW93AoqKxegPmXBc9An4uz2gGe7fVmPCeJ60eegstwzd4W7EJN+GG7br0b9ggNEpQquFmcDfVrG37E2jI2/SFXnporAyhgjZSbgCKxDApDyLUQwjhllD3uAzj+9mSf5aI5QwA7NFcz1V67boiq+TVJF+0SC5f03dkV1dwynXuVsDr6g3pHO1pYCEcpfsydNSzflWXG37gMhHBFqGK5vUir+pIRc4c65a74ipGLjeyDqn/kHjDem9OCVVGfCAR7BdqRPjCA391XxNQQXhdClbeeptADzKisH4SF13kwhd+TYAuiu4cUQvHtZ1bs+W5a44doBREfCBd+WWKSAVFrlYyxR4w62v3pqYpOX0ZUlTR6NXUsWJDnK2sRzvojc6ouRl2b+yncmeZKbNXggv7KpOvW5lG9wX+EY1GTRhznF/Y1Z/6mMon4GZ4T1PIamDI3li7WXU5yPy9+SOXOd0djL0QLyaUC1tMYqi2LWYRU7TTQyQSyGktcV3QiSPNaATzgN8oh3bakyMOqsXIywsqI0mO+/03msjBJ19wm8AqUN7aDAL6H9aDdKbYEfE/HFctjfUq6tZZEiVPpD3arxKDmUDIUGsw2NTNOBewzNGBeWc7dfJ/p5G7uMDkmWW3hnSO86kCRiMP9I+m7ktAabD1BbK9LKgsJIGPlhc8pyfX5PS8H+ACn
 ruNw+bvY
 NYdubwVr6kDK+rjEf+M5yOci/Lhyu7zLbmt9pA7aCj+A3YThkRZ+iLdGIfDIRd5gaRF5Z3rObV25qkvUp/0GdXpi1g/yRGN5DE11AONOEunmMhF89Q1bzoSwiIm9WEfSIq2yTq27drsemQTRaOhCYcryKOUVVRfx3Jz6dvBj8HdBfFNC3tyCzqNiFW25GvC30BLbCjRwKlTarNd5oOSpAveE15ZUj+KZn4Y8+yap8uyLkwtBwBzyQUISW8OuAqGkC/QoGDPn6rkTeFuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 02:01:44PM +0530, Dev Jain wrote:
>
>
> On 10/03/26 1:40 pm, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 10, 2026 at 01:00:06PM +0530, Dev Jain wrote:
> >> Initialize nr_pages to 1 at the start of the loop, similar to what is being
> >> done in folio_referenced_one(). It may happen that the nr_pages computed
> >> from a previous call to folio_unmap_pte_batch gets reused without again
> >> going through folio_unmap_pte_batch, messing up things. Although, I don't
> >> think there is any bug right now; a bug would have been there, if in the
> >> same instance of a call to try_to_unmap_one, we end up in the
> >> pte_present(pteval) branch, then in the else branch doing pte_clear() for
> >> device-exclusive ptes. This means that a lazyfree folio has some present
> >> entries and some device entries mapping it. Since a pte being
> >> device-exclusive means that a GUP reference on the underlying folio is
> >> held, the lazyfree unmapping path upon witnessing this will abort
> >> try_to_unmap_one.
> >
> > Dude, paragraphs. PARAGRAPHS :) this is one dense set of words.
> >
> > It's also a very compressed 'stream of consciousness' hard-to-read block here.
>
> Sure :) I'll try to break this down.
>
> >
> > I'm not sure it's really worth having this as a separate commit either, it's
> > pretty trivial.
>
> Hmm...well, as I explain above, it's not trivial for me :) it is difficult
> for me to reason here whether nr_pages can be reused without a reset in
> a future iteration.

OK you can have it be separate, let's just really clean up the commit message
then please :)

Thanks, Lorenzo

