Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0299CA0FE9
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3658E001E; Mon, 25 Aug 2025 08:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94818E0001; Mon, 25 Aug 2025 08:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA078E001E; Mon, 25 Aug 2025 08:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7A858E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:40:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61F7E1DD7CA
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:40:21 +0000 (UTC)
X-FDA: 83815237842.24.EB22680
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D67D14000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:40:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FS/r42Ov"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SV07zR4F1l/OSOnyqjvj3Wbmda/ishTOLR/wNk9yGwA=;
	b=NACIwBqYRzDGQ6P7DWKuQtQfIBMjr02pavgX0Rf/GbwWIP/M1vfPUjbDei2bKWhnbbcG81
	tW1Yaj2Hol1Ip1PSavSvCeEGd6ebOmxXiSCPOjr28ocETibFsexHSNzyCpJLu5qdh0gBqO
	tbBhVc/E4X7yIvdFYfH2l9oHXYwUbkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756125620; a=rsa-sha256;
	cv=none;
	b=MLGda2awiHZZuRkf7ict91Mm4TeDOrEGFmm877RqEOh/Qbeb7rn6WlHPvWQPh/LtY1cAJC
	x5mAp+5Wmc5wCFYr+/MYOdZMkss6yZ3FXWerbjjztaXJ8mH7o4yTJEV8/NvZ8tg3I67r2e
	BrhpDw/7KgtFznTAGUNrNMDaiik4ElQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FS/r42Ov";
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SV07zR4F1l/OSOnyqjvj3Wbmda/ishTOLR/wNk9yGwA=; b=FS/r42OvitRP7F7YpcelzC+BCl
	A0kN2vM014Ycmx6Vcazxtd8GKa0pMdQ0vjix6z9aenEjIU46o1CHDekhl21Am4ZciyjNJXdmo8hvw
	JhBf+48BDzDCRT/1lGsgYh1SLVkhIykBEiTPgVJtFC2VxLtbF5hwDKaiA0PAg/prvnS2xeqU2e2gr
	XMc6RlozPj5jQ4y/HV3LwAIN3X+RGR7SuYU6amyXISkN49xSxcljtvUItZzcAJQ6fpNE+6pHHzyOm
	NRYhk0zMcvtkbK6KO5vsFwGrLyT7RhcTLqnyPY/p5IpW+yJJxTukercU/ogHDo+YnBkW1wx/ij2v2
	fj6m861Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqWUZ-0000000DqjD-1and;
	Mon, 25 Aug 2025 12:40:07 +0000
Date: Mon, 25 Aug 2025 13:40:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: yangshiguang1011@163.com
Cc: harry.yoo@oracle.com, vbabka@suse.cz, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: slub: avoid wake up kswapd in set_track_prepare
Message-ID: <aKxZp_GgYVzp8Uvt@casper.infradead.org>
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825121737.2535732-1-yangshiguang1011@163.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D67D14000C
X-Stat-Signature: uz49ow3q3rzjmmx5rssskyfemo1xsqh8
X-Rspam-User: 
X-HE-Tag: 1756125618-421308
X-HE-Meta: U2FsdGVkX188V6X4YAXoX/mjE4IugiLC+cJQuQmyzG8Xt8wbv/2CQ4mpwmdr48G9JThpXm4lVpbqZuKLQ4AtUxbsanKOMSzbB975q0bauEKRrKJnAlvsx9uEEXHr+/3dWVFkJHaJB2n6DzIrNkWf3rg92drCzBGcl4/xmyalpcl+Uz9rsEST5jUpqt6Sgb7lN6p4/P71hlotPeOsddcmT4p0jcCWmRmCaOVhXtCKCcOtnZ+tqOrXfeo+2SzZpbL7X4docGZD/XGRZ/24erItm/3x5IqZOCcL2H3pgxkR/19zpi1Dc70qs4BzPqekQsrIiRIvZ/J+KgUZV3tvNwpOZrPsQfeF95jSBKP0Ue7R0c9SxBqvmsycUf1Eq76MRnJlD8FrgEKFceFZ5D6ZQSX3anrGeVFHwe8DMeNUStygLXMXOdZL3SNdzTP4olcLSAAX9O9faVScLs3qPvLqTR3nTKJJts5QvTLiw6fM0xfhUvBFpok5CJq9XFcbAF5uf5dMMZN9AOuEERA3Hsn3fsmy4BQ7PA3nmr7HeC++k66ShNVCc7dMl+FlKbyY4AtORi6MxXSWMYGxwbQkE0huir2UFccDTvnVTojxkB44jT/HHBasxxRJfTM/gydOySIznmCyjSy+ORBIcr8VPCQGaZh+1ZNwgxwtWCDAb8Ucn5D3t7wiYBFh3hwgcapSXLsOBLS46oL67Yj9CmSl7Z+EUVIuUex+1/3zkgH7xAP0Sb+1X+1LQKWfevqY4D+/7i8IvK4hh+hgT6kPqoR5LVFDDGTDTqPlxNxvyQ6C8U8Qubmmohh9NF2f5ehmN0GVyymxmipHWiTxlDRSNIVJQi+VH40tFRF9QU/6d7xeN7CRi3bj1mw9dMuDsDjD10wpiv+LSMtDOC7JEADf6U7wf1l1m/XR+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 08:17:37PM +0800, yangshiguang1011@163.com wrote:
> Avoid deadlock caused by implicitly waking up kswapd by
> passing in allocation flags.
[...]
> +	/* Preemption is disabled in ___slab_alloc() */
> +	gfp_flags &= ~(__GFP_DIRECT_RECLAIM);

If you don't mean __GFP_KSWAPD_RECLAIM here, the explanation needs to
be better.

