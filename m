Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB122C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7836B0005; Wed, 15 Jul 2026 10:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEAB6B0088; Wed, 15 Jul 2026 10:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9548B6B008C; Wed, 15 Jul 2026 10:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0A56B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:08:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04B66401B8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:08:21 +0000 (UTC)
X-FDA: 84991190844.28.CA62762
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id F19BD100010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:08:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r a72+LF";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=it1ZkUkv;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784124500;
	b=kfbyw9x8Vn8Zy+ihsa0ulTY+VVN5gzu+sLcT86ImVXVrVdEmDzuZDvKUYBMyRpGuaflN3Y
	V6egVXpD5LziXxiNuFWpiNLpyRaBc3u9qTc8OJIZN69SUosPUF9fWQ4IaBaMD9o+6fq04v
	CXgZy2pEe3J/1/u+7nNxZEsSdV8zzdY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r a72+LF";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=it1ZkUkv;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4z4v+0DkhPOZ+hMcb2wtvk/RMec06BLgrTqpTtj12FE=;
	b=sFiAwdsQNmTHNMZcPoc7P2Q/TWv57yKq0nakMeD5v+0utbpl/89jtWcQlGbBhZSt43WjxS
	X5OjKz/v0/AeME0q2zc2q7/8NNfW3vcnu2Ys4OEzeHGlyUe6b62LpSW59XXeXyHhEaXtC8
	nLVDPzjUscwRjWjPKOCo3MXyO378+24=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id 48D791300194;
	Wed, 15 Jul 2026 10:08:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 15 Jul 2026 10:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784124498; x=
	1784131698; bh=4z4v+0DkhPOZ+hMcb2wtvk/RMec06BLgrTqpTtj12FE=; b=r
	a72+LF6SF1x0q3s7SvHjPPoURNKMD5wDdFgosU987W+Nnm0JPdApDOZp6fSNa5x6
	nZj09w45rBvINrpqDHMB5p8h/ZC/Rj56Syp6JA+1N7NdDM5fpm+F2uZoIsVS4pTK
	H363tgf88oh1WphUBdLnAu+GKH50fH3bf8O8G1DLvoG09iqBHHL40ommvYOPAYaB
	Iwcg5/xOQMcjeipp/ypJUO9er1nidFfvF5e0Z3EwqZf5ZYiAsCJ73IJQHW/yBks8
	VBYKLGVJ3bw7nRgVEA6c5qIpLuAPwDj8U7gca+eh0pVRtO0eOil/kT7jEk5WQSAX
	lq/wDfCzN0FeNKNEcXIcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784124498; x=1784131698; bh=4z4v+0DkhPOZ+hMcb2wtvk/RMec06BLgrTq
	pTtj12FE=; b=it1ZkUkvhHcu1S/x2SpteV9crdshSbdpsfUwkdNZSvD5V+0N8w+
	i8KX8+gQfJKD5M1SDkw/p0kFPf/zyuvvlwZ8H3e0vtOcnhrql5va8bNcK380N4Xq
	kX7DZYIEZO8fa2Df+PlVNIVrbOb7e//5j8vIELyx0GKTL7jvB/qs9pWZG5Zlnlb5
	FAjAL+1i/0mLXzUBMyz0a5ARmcqIt1W2Vwnm1M4BNBdLAHc2NnaVImtIhW0e5nJK
	x+4hLjXARfSz9dxLnVId2QmS1qSniAxIyFUIRsupSn3IBLuqFr2nfMPSoEfbLWvj
	gQtEHajpLEV4WYfxuZOUrK7jsTVwmKfgQdg==
X-ME-Sender: <xms:UJRXamWn639D9fqtTvAAAVe4WsjqyQHAiiEba8n0Ay-delIOUVYouA>
    <xme:UJRXal7yaA0MsrVlXIgq5CeHwXOZLCSkvznJb1uAWSMQLAgBUuCqStUOrgTRSdead
    EwCkY0LVq5d9oLL6eEOem3OmQFkDRCAnI2v7-Jp_PgtBI-hydoQgItc>
X-ME-Received: <xmr:UJRXaudPTwCiuZEghlXtXE2M96rLN4dT50uSbnX83FqMR_0If-KR8Fc2jjzjGg>
X-ME-Proxy-Cause: dmFkZTEpAbFhk9XT00JjqNpXWGdW8G+fTRJY2oeiXEvO++OR6PQ9/87bVJe4j6SWYcZC/e
    i4UGaPFfCT0wdVcMjwVIyM2eJOqWcmUiCvlHQuvcbDnEzKaVYTefdBC3MBHUATFAK5eTKb
    XQ92tfowyD/1ICcH9GOmDzWoJkE9rPxOvrxfqBumY+rQ6PkaHXgBEd2sWRMrNXO7MTuaCh
    YQi1KrackKrSIaGGhAeBrwya9uraHA3JXDQoQce8cq0RtNS3zRPqRbr3D2idp47SUPioFW
    7iuYs+NN2cd45QAHNphHug6Ec/ERMXeq8YB9uI4djMvSYt7zeJCvnnC/Rv1um9/5aI76L5
    bXlEegLUH4OgRz3aO5ExmKktEQTyQVvlnxf+s05SS1XjuTrxn1gdv8MEC90Hk/tkoQCG79
    My+NGrKX/3QSDiOqFkr8c1+Vx1sRwxDSfON2cLbT63wtA1kX6AIFamNkTtHdjrJn2Kf3Rx
    SyTJf4B45AZyRXUiD2SY0Uh4BMFGocMsu1wn6CGo4Hyn2wpmYMYFLkR45BBzofugEPAtNY
    wMk6mQ/ELff4FVzCOvowUe7XAsMbYjsdGhBBPZkN6sTvxYfXtBC7yhPFUTo3FddPLTE6Ny
    5MuIjeAI4AO9nMieaeCrhLSWbJmdOOtDSqzGS77R2OT5TamMdM8BM65U3cXw
X-ME-Proxy: <xmx:UJRXajvZUZMg6La8pfz2tEENC43ou0_TIBahEcCEiGrH7Y-hdUAwQg>
    <xmx:UJRXamjDPP-6HIGUS06bQplHkoMHItkX1xSEAG69ahBPiPgfcZpUeg>
    <xmx:UJRXak6pIxGhX5vKH9S-70F16mZO8p6isd5x17gxstfoZ5pRd3XO4Q>
    <xmx:UJRXanKeCLp00ZJqZjXo01QFy8BNTseOQRMHJFoz_PVbvhbeWnaAnw>
    <xmx:UpRXahaEQHsu79mPcyQwK2UgNN34vNUq1Mxh5AOeGhomZ-1QXA_Ute4o>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jul 2026 10:08:16 -0400 (EDT)
Date: Wed, 15 Jul 2026 15:08:15 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, usama.anjum@collabora.com, 
	peterx@redhat.com, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for
 PMD holes
Message-ID: <aleT2uw9glPnKiqv@thinkstation>
References: <20260713091710.206548-1-kirill@shutemov.name>
 <f5700c45-9eab-47e1-946c-47d9a531bfeb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5700c45-9eab-47e1-946c-47d9a531bfeb@kernel.org>
X-Rspamd-Queue-Id: F19BD100010
X-Rspam-User: 
X-Stat-Signature: 7p8owu4qyz5hhzi5k5mxm39pcx7qs4wq
X-Rspamd-Server: rspam03
X-HE-Tag: 1784124499-310197
X-HE-Meta: U2FsdGVkX19pXwhvTx0vJjBETHy6rMlOJDxS03TMwb8Hbu1OdUItmtbwHn2ta/6GBrGPxbivQoWErCFX95FJhhuTbFQ+S3bjxL/fsKVMJgKzEjwt5Hh7WjLYZOgS0CpQfGkbwPNeM4wDPCQImr2kqmS7DRMhMGTmzuyoEy53QlPMaPL/3ou2PEmnzgsgz6y/QDW5xrSFO53RzdP1F79u2DV2nWpQuze0MEjzCbdqFaWDy3INB0rJmxOUDLW3XNIdQN9FDBPtHuTq+ZpFg4fAGP8Te8ffN1bJ8W2gS4yk8wwgA725OCAsBcNnNTo2oDrVvfx/v0nGYXJItwtHenDpLKsFpwbIt3pqAgGOphcFsE+c/xRe6ettTmFMQROYCNMCCJ2KeKZwhc/q/PbOt2VVCHzhKRqG+1ktpvLZvA0uQhOW2XE/+18f6Tym/1CZvo1jhujHJ2+frzIuJaXqe50/RaFYdYG6Y+PJyyaykMKBZRusfO9NG+KlbVU6wTh1ShxLawbYMoroUNwZVyPIZGMbovuufd9zweww316bChtTPC8zZJdzO/sa9z8n7ctpWVQ1ZvEic3P2jswlvMJGe+3AGMyklGOuDiJRtErA50clpuOYHDMFJoadzZir9kCYUl3Lj7jXsuF2ObQQe09fDCsN3FzNRIoTBYZJxh9nQy4WBE1QATONeF9CNQwTEm4a97ZvXXYxSDG3faLL/Na05mbaB10lphIRmBd43FJkMFPfdMnfohGwyEb+rCYZ6U2MFuE70mMWAnH/joryNZ4NCGbeobWCI+sjloR8UIRyzxrL9uy5M08AMWOXq5zE6ydYj8g876uvrGWoQc/lmT+TBW8SFQr76xLDLZ4gLNsU8gqDOVS+/8pBHh5nUOlPLQ3ViQvdttZki4H/Q3P49bgxRMuvEGNtPSAcPFncRgP7v5M7yfDtWB88n1z7bg3QzdAdyarWwlOB2WBg5I1cq1mOAM3
 afTT1MPA
 rd9xGoGwVhUdW+8kEEx875LdURu6CCse6jYbUDRULmeACFNRtOkvukpNsJuo5TuoMh0oY50PNN57QfexmNZKsW1FO/sDb3XPDpGdrQbkoowYPvcU8MiEE2L3Lk1T444/tDAdoTIbuIBIWUN0FvLTuqJ8UVLRQToVtHCZ0IvXRdgwq0giKw2fYs+SNpwoEd7yQDj5abqJ6q4BB7rV7sAhTdHbkjG6MVI2OWhrQMX16nPSrHezlwtrF7kdPhSygj4luKQRaFOdtwZf3YZ+tV0tphN7m7fn9LwarI/eTEOsBlPkl/FFjWVf+6923zW5z30D8JC1B1Bu63qSrMJlSgXgCaMk6ULDpGZXdlgSLnbUcgdGSJEgKGRSntvQg0T0de/jA4bIiNLyPAxf2Z8V3g/6A9xEs4NBpwBYNXwXCztino9fySJQ0htuveEk1XvdIazE+nncUMnV6r+3sWUnb43C/QtrwH6atGIkyWEmV/cyedyyZpjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 03:47:00PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > MADV_DONTNEED has fill-with-zeros semantics: it changes the contents of
> > the range to zeroes (a subsequent read maps the zero page), which write
> 
> Only in MAP_PRIVATE | MAP_ANON mappings.

Right, I'll scope the fill-with-zeros wording to MAP_PRIVATE|MAP_ANON.

The fix itself isn't anon-specific -- it covers any non-hugetlb uffd-wp
VMA (anon and shmem); the invariant is just "unpopulated => written",
matching pte_none in pagemap_page_category(). I'll spell that out, along
with the WP_UNPOPULATED marker mechanism (a missing marker == the range
was MADV_DONTNEED'd).

> Do we really want to backport a test case? Usually we split them from the actual
> fix.

Agreed -- v5 will split it.

The rest goes into v5: your shorter comment, reuse of
unpopulated_scan_test()'s sequence, recover instead of ksft_exit on the
mmap failure, and rename to unpopulated_thp_scan_test().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

