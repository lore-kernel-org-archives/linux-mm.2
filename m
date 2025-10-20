Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A44D5CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3768E000E; Mon, 20 Oct 2025 10:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0841E8E0002; Mon, 20 Oct 2025 10:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC6A8E000E; Mon, 20 Oct 2025 10:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAB248E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:59:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A595D1401EA
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:59:12 +0000 (UTC)
X-FDA: 84018800544.28.CCABB7F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DA3214000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:59:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gp41J2Nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=docrPGLeWwfEDBF/7JprhY10nMkkvgXOdF2vgxv0F28=;
	b=3/yIcBDD3w+yvh5eSWCwH72GN3mGxNTo8AAVwDd1F+3jUngrhUn3Bvfdw3w4j9qoSk9h0R
	gFklTlVcgIYOWv15soEHpMVxfRgnBX5/sel01S5bWDGkEikUNOc4vtWDuARBjXfalWqyLx
	c3IU1IYaPu5t3edTO0mDGwOJKRG9Be8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gp41J2Nl;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972351; a=rsa-sha256;
	cv=none;
	b=GvsF1GKdNV5H+i4DlgwdYEIpJsqHxegxKCh+yEguTQ/OG/PuLSpz90rDbFDFbLRFVBawqj
	DJ9/lFU8k4wJz9n/3pr8H2D1RVHIvSVwwyu59uoZuTfC69elI8oFrDZPv3BYvF3dzLCL+q
	CiqLuBqqmqmvZu+6SNLGQThPPxGNpUo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=docrPGLeWwfEDBF/7JprhY10nMkkvgXOdF2vgxv0F28=; b=gp41J2Nl+5HhU+fdHp9Yi14Y10
	O+WveHEJqqkdtliUeqgcfJlNF9GA6kcB4bP6KiSqF0eVVTz0r9MKVqzJ5nDn8Vu5EhNP8NBvynYIh
	YJuqpPuI6Nm94OsbkraF6eQMRMrK2+7gXazXperZn+Tu1ZauOlrYnuf5mpUZxviHFKueyb8bUpjeQ
	s1J+EUNuWGPcRi3g30hlygtR2hrsetRCJOGV/2B1PbxadPiIYqcs3p3YjLSmIhpvE4vjATnh5ErcT
	ijmIPZNipvE6DO/3hM3czpQpRmdinq2h1pcKGcx/2zvaMZD0SHd3z8kIS70GvoHQ7Nbk/h3gPDhqT
	ljKHEkIA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vArLn-0000000AW7d-3SBA;
	Mon, 20 Oct 2025 14:59:07 +0000
Date: Mon, 20 Oct 2025 15:59:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPZOO3dFv61blHBz@casper.infradead.org>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DA3214000D
X-Rspamd-Server: rspam03
X-Stat-Signature: cnhyq69fqrrnhbsnwkcxgrbq46ux4d58
X-HE-Tag: 1760972350-285449
X-HE-Meta: U2FsdGVkX18dd5Pu0b+VaAxViI1qWN4wPxkuNgdCz+WAnoYUN/ezt+BkAeQg6s2DWgtXqIhe6+GcyIGCU9PSfDT26GwnsjZIBL92vMLUUt0oIyr4eq0rHROBq/h5dV0KCemBPQnjLKySOoa2t9dm6yfu68IidEzS4ju3sm+25sVtM51nZAEeruQZdMmFveZlcLpwwvSjpX6mvodGbc4H1l2EaKc1Y0x8KwblmuE7hjbNp1Rs2LjNmea4WEG0FuQbMyMLH1k9KQs7zA68RzoLM17MBFkwrRKOCdq4LrvFVEf8YpX0SBevh7S9j1SSKk/mFc/+AB2Zyu6VIzs9zBQ0AT7JHI4rVpSXtB9tzXSXeLaxMEucZJF+xetNgY42lCoXEBvLU+Nn6bOHh3+ZH0P1sn2DCKy8cKGBXkBjtevECa2eJ+fFMEsddk5oPUC9mHRuNiOyKOD+TWn1YPH5he3oPf4nk36z7i8W7CMOTcFFadbTQdJv4h/19hIRjrATz6AdVQJ6rLcmx0g2CrZCeu0mJTCNNruGisQXu/m+FipQu99vWXL0T2eyVqn463+FbeNLiayAY0uvFYQhtOaVgvwo+JMg9njrJGChl4xbOl7X2P0Ce51fYuOUdzmZIPID/bRMwWHapqW/SPBDWX1X2g2UbyGAEVfBH+vg8wO+QCqG2w9n3Zo2xL97uR+cgupX/2lefZkmdGODygGu2CcqDn+aVJFdHQEk16vTZLnQeWJjGCjNbCvORSDleoPEtKukYHRmgZTFx7mhNb8GqcAphh4QucP12Y3x2YfpdGaoy+dsPp3C/Waf6cNJjRFOv+oa+dd5Ang208M6o/nVE6tCMTX7C/8EWbqcaCQGgp5PKqAFx2hgDkqTi0LRG5l1eCkkytVyqijd9ir774QJzux8XrIqCUBhBCqcuT85pUVv+kFJUL+hLmH2GQ+EI7afx3lzraedQEIAwYDcvFzeIVi3dqv
 ri6wQlOZ
 YWSYIoxaHDFLnCdf5aUUDP/o7K06Vn6noZfShEbrVBuwm82ux+I1QJXu2qJL4x+6So5AKu+c9emP0DuDa4KbWLrjWDJDleidKl/dTQFhGiGBsIW/mOzktlRuAuaiTdkEDPdC58CINXqxE6gmfFRD2lSeJNoT71eUzftqE4jDMGmBHfw2wbNIwT2KOrjpXSr14CA3V3icZ3vl9zKnCly4zPscmfTxKK3DvIobs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
> The idea was to bounce buffer the page we are writing back in case we spot
> a long-term pin we cannot just wait for - hence bouncing should be rare.
> But in this more general setting it is challenging to not bounce buffer for
> every IO (in which case you'd be basically at performance of RWF_DONTCACHE
> IO or perhaps worse so why bother?). Essentially if you hand out the real
> page underlying the buffer for the IO, all other attemps to do IO to that
> page have to block - bouncing is no longer an option because even with
> bouncing the second IO we could still corrupt data of the first IO once we
> copy to the final buffer. And if we'd block waiting for the first IO to
> complete, userspace could construct deadlock cycles - like racing IO to
> pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
> of this...

There isn't one.  We might have DMA-mapped this page earlier, and so a
device could write to it at any time.  Even if we remove PTE write
permissions ...

