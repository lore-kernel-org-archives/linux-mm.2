Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BCFCC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9ED6B0088; Thu,  2 Apr 2026 00:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AD26B0089; Thu,  2 Apr 2026 00:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90876B008A; Thu,  2 Apr 2026 00:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB40C6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:11:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5797FC1ACB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:11:47 +0000 (UTC)
X-FDA: 84612292254.12.6E98BB9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0CDAA40013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:11:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cy90xzIh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103106; a=rsa-sha256;
	cv=none;
	b=6y4bRKsfh6+3xDgUXnqR8y7JcgD2KvSMycOOjoLuXZrbpLmnmY1U/mWDEkU+3P5B9XOXgv
	rReoGyMuZbrHhxih4IDlTMu03FTTb+LMJ/5B1ufUsKd9dSg0dW41BB4cUlTIymP1eT69K0
	UMCG6SLNgjME69q0Gj1njHDr81eiQBE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cy90xzIh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjN6IPgIWc9pLcP7hLhiuTVm/LCpSc0jwe3SrPuO8QE=;
	b=w5Vir9zSZdKDkHK+9sTzXpBPFf8yeZUBzm+Z0Kd/wU4ag7zFh9Yq19YnnFvC2tc90uKwRY
	gfR985tP+QThzMz/4gttb2KP1MueulzEyNW06ASsn7JQ5nE2WviyLqRfM8goMc/MYkRL50
	/0gvVt5ASfjaM92c550te1Ox9WwtbeY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gjN6IPgIWc9pLcP7hLhiuTVm/LCpSc0jwe3SrPuO8QE=; b=Cy90xzIhfidaefZ3g7xz0/UTnC
	wFQ3ETt2ilQ9TJjGIysb64yV7cu/DWdIujOZ4I4+1yUxK8t0FS6ogeGNNS94HoymPGIlq5IjoOKep
	XixJKYms5xZ+/vf1DuYKVtS0Bd9NggGGYNHLWavxeIJVV7RMdkZiywQ8b/gOT9MIqfaYeyPAg8+6Y
	e+EESsgBVQy93/Ez+a2vs8hoM8MYthikBKYUdPUq90F+DL8s8eOgMy0T6G8TCAZwD41GR3dOC8BKV
	/xvVege9scxNVgghIvKQrRsT5EMiVsMlJTKoFt3Gca9ZlfcYXwoKT+evyHSjmHxWgWsUUw6BtncIk
	hj7PM+qQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w89Ot-0000000BYOc-18Az;
	Thu, 02 Apr 2026 04:11:23 +0000
Date: Thu, 2 Apr 2026 05:11:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Carlier <devnexen@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in
 sio_read_complete()
Message-ID: <ac3sa2GB79LGADpY@casper.infradead.org>
References: <20260330071229.14614-1-devnexen@gmail.com>
 <20260401074753.238053-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401074753.238053-1-devnexen@gmail.com>
X-Stat-Signature: qcisz4w1aur31ykh1zngy5f3f1yus3sp
X-Rspamd-Queue-Id: 0CDAA40013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775103104-886336
X-HE-Meta: U2FsdGVkX19X+GczlE1SLKQTCo5oW9SbA901a5OXAbPOy/MnNJBPtBB6mSEvFewrlIOkNGwnz2AbJiEYX/2dN6ROAc3dHixILYWDaolWp+HlOG/D/1o9mePS/DvfDhDBMVF+TDs773xdOks4YLV+H/y0M4ss+6OyDCdXi0TOKSsRNnnefMO02zJ7YQ6ryNu5Pim6DygUrYn9nDPrAZYysVpE6DbcyeOQbLnqgUIvE8/eraA/9af+WNz2EJtnpFJ1i6cVUBTfkSQyNwRoyjrs6GdctZroV4oZ79OnYslutTSGnyeHJnoUXQ2KwiV9d3AL8JEGWrPhkwiV4uu57zlzJ3215ojvczOlAPDgkYVuE1Fnt+hSuSVMPg+Zc7DdwKMvMnyTXKNW/TPPiD0YLKCfd69QnDhndl+71edUMxoBjFb9FF346sWBxm5RldVcL/EwlHfijHfwzOC5iwR6Yue4CpSokj5b6T1t6b7b4nC/hYmwSJebduB/yoEfl5aM02L3FG3RiZONxK54YWQL+FQeUd/JFePMlmji0zyFHvm1Zw5B6Fzjy11xqifeRHu6Ly1+bVGzyFBNfD+ZJAGpC652GBEtFHKLuG9SRLHyB/4kpClQIVTdivCed2OBfa89Gkn0lBRzfFQ7K4aC7aDI0F/zBKlRyFwyfZMSM6yYPApq0+p1SjLd9lbxQ1c+RVEHffEo/c5kS0NVHGrZa7W3si22X6BF5OMSuee+NHtvz4eRTHtkDyVeUxxKgxSmPbnE7FImc3R1tMKMwDg+Vnlym69MmmVJ7hzffTv3+cFFEkw+dfAxQagfo292WOXs5LukpMMB+dOfBZYMLFoYjFSyFpsjtqSlXA01PnmHfWeVXUkaxldJBxeE0JW5goOJCdSunV/fXqgzQPYpgoTsHrKXO0gj3o6SgIAb5nZxihnV2JoLOz3LKD5/ljzZUf9ZhL//NEz5UHzb4p7OU96EMRZ1uFI
 XXVTzSfA
 Ep4FS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 08:47:53AM +0100, David Carlier wrote:
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages.

Since you're messing with this file anyway, do you want to submit a
third patch to rename swap_iocb->pages to ->bvecs?

