Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8918CCD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E096B0005; Wed, 10 Jun 2026 16:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF2D6B0088; Wed, 10 Jun 2026 16:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4E46B008C; Wed, 10 Jun 2026 16:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92BE56B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:30:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AEDE16452A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:30:06 +0000 (UTC)
X-FDA: 84865144812.09.9659147
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DBE914000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:30:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y7RNisUK;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781123404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgCn5Wxf+Irho0mKTHH0dDK8u5CVGsf6qFgr8U0oMWw=;
	b=pKze6lkFork1LLNulZhHg+1ZJZgmwRk7OFHAP+xbNAaWD181loBwI6acy8rYprrsyYoqd0
	q80r/7b/LCvAg51bBP4F8H29QhSft5P0C1ibKIKVsM30YBsfJwKp+pBIR5W0Lk1E9LI5oM
	bZGBokkQen82AgklT8cHFgYfRMWDCMU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y7RNisUK;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781123404;
	b=mekC0+PVQtAdTnnSedVSQfDzygh9nj6HUDUpzuT/+oX3tBCSCVwJZhPO651Vc3bwdle7Se
	txHmrYLrO94hLW1bqY27xU6FVGklonx/zZPP/+xZCuSJdtHglsmH80VLxT8t8pBq1DRqxN
	iGKYkFKXyty3IaKRsXMVf3kGcEmcF3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3425D436FE;
	Wed, 10 Jun 2026 20:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883721F00893;
	Wed, 10 Jun 2026 20:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781123403;
	bh=MgCn5Wxf+Irho0mKTHH0dDK8u5CVGsf6qFgr8U0oMWw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=y7RNisUK62V0jAffUfNT+LXxlH8Q2iVR/V5651z4ZI6WJBb+ttUACVits6mh1As9e
	 GwOZGq6p4Vt3g25I3lWlu7fewuV2Ej8AC1bSXL5n0zDTdHOKMR3C9qcprAJbiFA/5D
	 MKfWVZsGnRY+K9LLKotfDh50px1hqVaoXV7iDegM=
Date: Wed, 10 Jun 2026 13:30:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lance Yang
 <lance.yang@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico
 Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail
 folios to LRU
Message-Id: <20260610133002.4ded8d8cdc8e23e434fedf1a@linux-foundation.org>
In-Reply-To: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DBE914000F
X-Stat-Signature: 3jnu1i3b67qqr11943tnhrs5sud9a7n5
X-Rspam-User: 
X-HE-Tag: 1781123404-204313
X-HE-Meta: U2FsdGVkX19xXMwoI7ypiRx/lUwJ7iCEtQsP2FRoCRTnMa5D6DJEPp8C4I40njjTPNIjzz8nFqMaIzOmC7LI5xnraOjHBE96Mnz0KDxSUqmAL67g7NXJVGDsjd360HM16HIZI965C3KoqudzBBNbrnjpa0eQH5N0cS7IwzH6YZk7H15m4/0yLxbxQN4OxeYHrpjONRCXv1gQjufMNIfzny4cnug3GOsZ8Xu1oB/M+xzooBQjOOodj/+J5WdqeLwE+vKxRvp5xM1cW+eLYIo7Idwpr4kSBkueavj5qK8dyXUiQy161KHYDvpWluCcN9GfZqPaZ2+5ZN903LWO5gNCQL856IU486mMmG7aiE4DGdQDImTrgUauYV+3VJ+X1v1dfTb5Fx6Y7z4Oq5fFLGMr5bmTwHG9WcbV66ERzRsBicaGgmf82agg2SHeXUtHNfCym6raVx5x6SXXeZ2sQEOkjkj4Vyl9oj4R7COUI6teUfAeiJuI20bkidNCMdoGZJCuHO9RBHeeBnndhPfz4DGOrhBbgUpj+aXPpzSQBLVOpjF5pStEIYYIU06gRPRhdQhAecSJ0X8/ElHr0AJcay4EZUV36wsW5rXVrGTxF0n2wHTOG9VAq4evk1h3Lf0Yvn6DrGJ1h8xoKhT0mEOqev+zTn94YCdVXnqX+q1z5/tX6SlHhwMJuyMeHWh92zCeS7BflK84MSt1aCvgpokY/QoMz7jXgmLCX4hQmZqNRSykZyJixbHtp4MWTJQx0NloAp4XEjHVzIzwUW+qp+D9QKaw8OfIuiOb3tWosBuQ9OKMqlGOrrpvBtGj9DXBG1wnKCQ21dQydrkBO9maQQ/nksvvx3EM19q3xEkp38HXLRy52i74Pn2PbI63Jpn1wdTtOYYE2yL2pnLpIQenyJy2JVS9kxINvjl+B5CHzoi7VGUmhTGFicFYX/zwVMp1UacbczaBdMlaRtv942CtCg4B6Yx
 TSM526Az
 QOgMnhDh0itusFms39rS4Y1TO9XTqlF3Xx8Gc3sqTMa2Q72evp8PvhHaeDehmhm+SYwQUevWJkSyu1TQDY3mvAS2wpMIx2toBQl/i7xRvrh1WDkPz8guKGfcXK7QkR8s3AzN225447sotGomFYf7+PKNcx+7GufJaVAMwLxDN3XHvpMOOMUsgnTJLZSvWggrS8iU9ECwnpNuatv8T5d2OILdUURz3ISZHI+UIDLBp+j55ekWr5nW7vaNsbVQGZEZqhALyveAsPcOJqj4ZOX+xi4mQGXI79odKQRFzH7Tf/4nQSVuYfhPfrtvgApRB95DI04xpmYC7N/Mx6uM1OKuctCdy64pFL950uNKiXjGN1sr2W4oZGMDeeNjVRNF/roDQpgFUo9HgAM0+bFqAylS0bFnR5zRIbn76ucWM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 20:05:35 +0800 "zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The kernel panics are keeping to be reported especially when the f2fs
> partition get almost full. By investigation, we find that the reason is
> one f2fs page got freed to buddy without being deleted from LRU and the
> root cause is the race happened in [2] which is enrolled by this commit.
> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: remove
> non-uptodate folio from the page cache in move_data_block").
> 
> There are 3 race processes in this scenario, please find below for their
> main activities. However, by further investigation over the code, I
> think there is a common race window for the truncated folios between
> split_folio_to_order and folio_isolate_lru, where the folios lost the
> refcount on page cache and remains the transient one of the split
> caller, under which the folio could enter free path and compete with the
> isolation process. This commit would like to suggest to have the folios
> beyond EOF stay out of LRU.
> 
> Truncate:
> The changed code in move_data_block() lets the GC path evict the tail-end
> folio from the page cache through folio_end_dropbehind().  Once
> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> page-cache references for all pages in the folio are dropped.  The folio
> is then kept alive only by temporary external references, which allows a
> later split to operate on a folio whose subpages are no longer protected
> by page-cache references.
> 
> Split:
> After the page-cache references are gone, split_folio_to_order() can
> split the big folio into individual pages and put the resulting subpages
> back on the LRU.  For tail pages beyond EOF, split removes them from the
> page cache and drops their page-cache references.  A tail page can then
> remain on the LRU with PG_lru set while holding only the split caller's
> temporary reference.  When free_folio_and_swap_cache() drops that final
> reference, the page enters the final folio_put() release path.
> 
> Isolate:
> In parallel, folio_isolate_lru() can observe the same tail page with a
> non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
> reference.  If this races with the final folio_put() from the split path,
> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
> The page is then freed back to the allocator while its lru links are
> still present in the LRU list.  A later LRU operation on a neighboring
> page detects the stale link and reports list corruption.

Thanks.  Sashiko AI review might have found some problems with folio
flags:

	https://sashiko.dev/#/patchset/20260610120535.2370844-1-zhaoyang.huang@unisoc.com


