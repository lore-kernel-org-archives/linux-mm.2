Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9A1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8656B009D; Tue,  7 Jul 2026 02:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495CA6B009E; Tue,  7 Jul 2026 02:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB8E6B009F; Tue,  7 Jul 2026 02:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11C976B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:22:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CD72A030C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:22:44 +0000 (UTC)
X-FDA: 84960987048.24.B0E70ED
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65057100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:22:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=009saE9w;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+ccd0aaf8968eba96a6b5+8353+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ccd0aaf8968eba96a6b5+8353+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783405362;
	b=ZbpHJ/tkNO1d7F6Ll6jqa2fbk0vBHB2q+1mkHkKjuCFBEi6Cnj582F7nnTNtFdzT/kW47/
	1+b4/RrEPkeYR+4OySnVAoWzMPwBUgufJr2SP5e9fpbRFZr862a7/cbGguPGk40kHA+ssa
	Rxtc2owbFkl8dwMD5sFP23c2ho2W5z0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=009saE9w;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+ccd0aaf8968eba96a6b5+8353+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ccd0aaf8968eba96a6b5+8353+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783405362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fdRQ940ITSfdxaImPyI+kZnUXdvI5OwT6MhqFhki8Q=;
	b=4aecEYM/QDDPmw5iOq2nmq5jefZqKAwnStB4+5moB16tLjapea3/JiV5L0iV7NCJ2VrkhN
	FnWuwzyK+yFdruw8mPpvedpTGtfQM+yjqGV0F1/kfnbhEB08FKhNDCd24uJmLiCd/O5tKQ
	GfFD9m0xbgzUpCfvNKu1BKA099w/HV8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=4fdRQ940ITSfdxaImPyI+kZnUXdvI5OwT6MhqFhki8Q=; b=009saE9wpY/exxAAfsqMTyCdxv
	X/cb8PjP3ymCT8/GOpLOt3iy4hccFZDXgEWHnezkm8fuLKWINsqt6Vw2lEz0R4cMkjm8Dq4SkSnt3
	qTDRjAWPeV3QLedCumtuvoWzTC4aFifS+qm61kirjk9bmw3UTkna0EcPhB9VY/DryAud2koItS3Rz
	p0mn2R2g+L8PhYJK6FKitrL6XOWnHIun1mxMlHQsj93ROn1H47j4bNEfHLxEJTWCsti7ZtglEF5xY
	d6LiTohoLWgBb4q6jUWFeGDYo1jqy+OYw/suvehQP20ipVpbLNR56rgKnACIivNvvqFkXpC3LVaRP
	IKyE2zSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgzCY-0000000ECcs-0ofk;
	Tue, 07 Jul 2026 06:22:38 +0000
Date: Mon, 6 Jul 2026 23:22:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hch@infradead.org, ritesh.list@gmail.com, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, david@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, stable@vger.kernel.org, vbabka@kernel.org,
	vbabka@suse.com, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <akybLlAsw7Yv1Xmb@infradead.org>
References: <ajvc7fSDngyx0X5j@infradead.org>
 <20260625091039.24501-1-dipiets@amazon.it>
 <aj0bDijqj1-Bjxq1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aj0bDijqj1-Bjxq1@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 65057100006
X-Rspam-User: 
X-Stat-Signature: 5s5s6eu835a7pgapqcuw9jheygragdna
X-Rspamd-Server: rspam03
X-HE-Tag: 1783405361-907929
X-HE-Meta: U2FsdGVkX1/sSi526VmgmBQPin9NGGRk3AaL6IuOmJH0iLoudLgBoKgcg6C8XDsHNIidGJLGrdPYMWOfStev6dxWqTBZ5t4a03p5cQnVRvfsZZkDOpLFvjqreGg59P4Ciof19ltTrDgcne5e+hXCoFaKGOInpAObDyeAcCZA+dNE3KbOzPirJTYzx14FSwTHOlR2oPCZt20X55jufju82P4zif+DfhbqB/UsFEsaVCKu+Fv+jTKZv1QkSW7IvvnLCk2jmBtBEU3ztE7t0GNNcBXFZ5NfPVO286yqMSVA0q7E3Nqgc7WqNWPb0jFeZLQd4t1+Kq1YXtHK2mjoRc39LqVZaSztBi8ZoNzf+iQsvl3gg0goHPiM5oSfo5B8ibQ9Qd03IVnMdjGvTuuLn9dFfsbqmVLziA+zu4YdCpGY9WiSj4s6xRVdNANAF8HsEFqMYWMbwDG7Gpg9rwwRqbAx6ms9o7CoExdgRra+b9PWEpntCfPquqSxOMbJxf/UZ7kDGPYmDDc18ZPBhg1WexZAOSYn7X4Oxm9VqXkRh1Oi2A3aDO2QIoYN8hCu4NX9y3K5oEiC9+usYKlcqArnfQYFceMn61sir3UJT5MdNT+kc8Nbu7VEUrY5M83hW5nMp7iVHz1U2M2eKP+Vag3h46tQw1gMT6t9Ww9MMNUKs+21nugDfkl4uHiIVQtCbVTtkA7k7ivTT5sLea6ybwAH+WxwSw/L7H0kXP46OabfhEKyhmtbRjX3tFRPDTPbG3oRft1GvAnYrc2m6RYAKZkYI3gnE8BxSHeerWZea836gXTqgbMNMESJBSPi0glMkvFRASmVctQlRnV5/Gxi6mvhDQs7i8J40Qfv0NGBVBOJLu6plBW3XucktQ5yUwxfB2LkUgkOQqlTRSkPM1hjpOgCgDsAPsr07h+wVDQyz5mHqwLTc195HjDblhBs0gQclQjzZDOyvfU1bomPHTWl8Jlw5ST
 hcFG3fls
 TJijTpbMeB3slIa5KffiJfOemsvpAUvYujgoiz4hcyFEiJAqW+2i/HyBIQRJaWMQNGIyN7RhExAi+4agRHChoT2fyKTffn0M3gHmHR5TLAQ6PqFj0MN0tDNcMhOnYao1N/34fh3rWzGuNG/WRt9nhjc64jGxYBbgrVEAJ8iiIKDB66WB3A0DsL1tG8mA603PWeJcPIvqN+Jl55WLoEejeLAt60ynUsqGL8/EvUdFQxVPv51oPmUzBKyRCKMwLiDjs1bVV+iPC0hK1pUSJ+mVhUUx0EU7e3nvWgeihUxp4v7cLuqyXqHUikPSbQEsAWgZUjCkwP0D0zjnPRaZcQy9ZqQ+nUiWRvRCUcjBb6Tfu+F3zN9DMJ17xmHLS/X2Xxn8EhcVf+XsO46lbumQT1wSRt6ZqdBgjQ0YoUko0tqXknzw6+DvgTjLc/Z3ZAnUW0+rQ4KV/LHzuaJWbnUqMa1wF+dLryRBYP2seW4PePZ8IgqsZbAasiNKG8mJsYLvD30M1oMdA0pm+IZhv+OPrFXrdo9P5ljYSngk/I3wyJr3EHmHrXYnA7ceBhstn02H95jMRtFId4OdFv/CeNjogVSnXZ4CO59L6cL2jhCjs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 05:11:58AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 09:10:37AM +0000, Salvatore Dipietro wrote:
> > Yes — all the patches in the result table are shared within this thread:
> > 
> > v1 (original, iomap caller): The original PATCH 1/1 in this series
> > Ritesh's suggestion (mm/filemap.c): Shared in Ritesh's reply on May 3rd [1]
> > Matthew's suggestion (mm/filemap.c): Shared in Matthew's reply on April 4th [2]
> > kcompactd background (mm/page_alloc.c): Shared in my reply on May 6th [3]
> 
> The page_alloc.c change definitively seems like the right thing to do from
> the high-level POV.  It would also be nice to find a way to centralize
> the logic for which flags to set in a central place as we have quite a
> few other places that want to allocate large folios optimistically.

Can you submit a formal patch for this?  I.e. proper commit log,
fixes tag, separate thread, etc.


