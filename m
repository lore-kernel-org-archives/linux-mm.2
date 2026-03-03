Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA92BEDEBFA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 22:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A93D6B0088; Tue,  3 Mar 2026 17:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156CF6B0089; Tue,  3 Mar 2026 17:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0596F6B008A; Tue,  3 Mar 2026 17:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8F4F6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:18:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 969391A0129
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:18:27 +0000 (UTC)
X-FDA: 84506166654.23.87079DD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0656C0009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:18:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TDgirRMe;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772576305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BP2R36w3xYUknyVVM5sNFE0Pq2fJT7cuN70tvl8P0F8=;
	b=thIkiMEksAhI+g32XsqnWuAcCE1gd03Hb8z+I9vr0AMSmH9LZhqcWlR6VCHYB1dyeFnJev
	39U5X/8f/LFHNCIl/XRXdHli+OZSnomTTwnY5Nk1VkTrrE+EiHmNaly4CRI7gDRpwGh0OM
	lL9GvKx82QHJz+tu6HIDB7OZP2jUBB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772576305; a=rsa-sha256;
	cv=none;
	b=g8N77zpjVWu88pakbleMCHssWjWlShwx8cmUn41aXr6VUo0TX+da8Q0Fh+PTM2Y/JnXXz5
	38ljgUc6PGlikEEz8dNf5DTYS14v2ZNawMy021dw4N5xf7G1FoVB62H7LE3yO98TujQi0O
	q4YCl4bWBpAKna56RqhhrqK23wp9bXA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TDgirRMe;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=BP2R36w3xYUknyVVM5sNFE0Pq2fJT7cuN70tvl8P0F8=; b=TDgirRMe9e/+WYFoYTAQq7tOTs
	n3lhPxA0uC4xXUHSKUoGdyS0FUEYdY1lsPT5yDeY3Jl04CutcDvjaJ6+Q3Vu/fL9sBAb+wTfurQgf
	t0li1gR28N452WXjgi643PV+t5nUfSdHHLUCcr3US0LAE29SxoPZgIT3T8W3ga9RKqK18QBz4wp7R
	LnCMIGqtRLRdW0teAYWqC/dxqac2YaDztPOn03I+oybc/z62V2MBEnsBSiG2HCMj9yv9s2/SIP6Mh
	lL5pqNxRI3v1TIuIBG7viDAXylqbpfoKmluG3AcOeO3K2fvSOBBIkl7YyUDTo+enLV1giDl9ay39o
	o2wr4APw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxY46-0000000CJPp-2JLA;
	Tue, 03 Mar 2026 22:18:06 +0000
Date: Tue, 3 Mar 2026 22:18:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
	jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <aadeHiMqhHF0EQkt@casper.infradead.org>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: mcmxwyk5ctgu1cam6qpo83zs6mmdqs7y
X-Rspamd-Queue-Id: C0656C0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772576304-262199
X-HE-Meta: U2FsdGVkX1/XWqxT39XxTQviakRYEOAPhok/CGbV1WlORUbaHd/TSLTRWR+na3Tu1koiZCFr5UAv/61DD9KPDgFs0F7hXu76TPfp3hEtVTLmjMDIhM2MdhY9BLEMIjGLCKkKhcDtNuArs6cycSuWKiyoq7TW/81XEuf7kziix5qbwNVt+HRYz+82WLuM9BevJc7UYY4JwQ0Enzg72A22PIKuzw8BcWfxrbrgLO0XlrSrW0b8YQbOxnDykBunCCqAjQ9GXbzT49ehdA+VFdcYRDipJRYJYbX0XIHXbHRuoaXia1i4d8XcN+c5OHvF6etKy4/7SmdQ8NhseKxTSZFxJhKry07eKWO/lHdISbOGcGRcMLIHXZm/YAuqIrLEdkbTX7h9vJumkho9A658mLHqnE2nVBNNZYUT1vYc/fl5eJWoNtBKrQVVAb5Sh6GJds29ZePLNhwsymaYJUHtp1Ccg6vCmjgjcsTVygym+MsKPdknsFcymTdA8opPG3cnxIjajtL8MKe7FwBAOBcQAjKd4ke4/Pykfvkq6re6BQzfPxtJZoRhF5N8BVkbz85iieVammIktEXZEUl5nGBpg7yJbjHKNQZy0IoM0joUB+USiJsUTZr9a2u+v4Qx8y4xMoyLlUSwPXViA0QSizHgHrBGFiMlUHGMd9ovjXpreKM+M/F6Cmo4DHxPtDg5nDyAheDHjiKu6wXxUvru4xp+SyAtjQXFq4tEIBIyCjhCqKSgSCULQ2jLB1Rt44FAuEAO8wmqAtbgJPUtE6HQkKzNOdJ8+6XkkVi7oOsps/2RAzwFSnbDtA+MLHIHtho3dyf9nBFp2jm6BFYsguLrSBac6vJMisCdIya9imjRCCkWeFTlWiF4BeiXYlEQrT7b7ewlj9dUupCt1mZNWGp7vbuKJ7hSAfKo5i0uJ56pGUI7Mk20DVxYXhLuvLp7hvVAJPL24Ndzwor53Xnb5wyWXT01Uy9
 5NQYv2a1
 Ef/BLQdF3FYJhKObxS04mxx3cVisF0RcY9F+OH039Qo0WMh6YxrBSxLpepvmuieG0Kqn6TRayGwisITZh7H3A9qW9EFCzJRdOeWAG8F6tPdEt/BS4N70XgLgtdUSPQyRB90OJcCoeuI/qGFlqABpUK5rCoIE+S48+1OEgEGLp+tfSo5NU2Vb0eOVGyL8qMBcDaxi1E9rvPg1ZIBmEwYelLUlybZt44wUkA+dP/78yftjSp9oR4Y0H3vGG+Mvb/lKa1qiJsExwNtlJoBrQcs7hWLuCSKeIesHMFLtMK1JjvndTuxwJJNVD0Hi+1qUXLsA/04DlgP/8l0O/kKz2kbcAlTOwGODcEbVSs0ev+TV1uTRNKyNOL809owS5XFnc1pxSHvHQ5acp6BXjszPbwkd4rx4fOpnyP5BrVIwK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> On Mon, Mar 2, 2026 at 6:53 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > Overall I'm a little concerned about whether callers can handle -EINTR in all
> > cases, have you checked? Might we cause some weirdness in userspace if a syscall
> > suddenly returns -EINTR when before it didn't?
> 
> I did check the kernel users and put the patchset through AI reviews.
> I haven't checked if any of the affected syscalls do not advertise
> -EINTR as a possible error. Adding that to my todo list for the next
> respin.

This only allows interruption by *fatal* signals.  ie there's no way
that userspace will see -EINTR because it's dead before the syscall
returns to userspace.  That was the whole point of killable instead of
interruptible.

