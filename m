Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDBDEB28D1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77FDB6B0089; Fri,  6 Feb 2026 01:25:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757756B0092; Fri,  6 Feb 2026 01:25:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656536B0093; Fri,  6 Feb 2026 01:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 54EB46B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:25:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B32DDC2826
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:25:33 +0000 (UTC)
X-FDA: 84413045346.20.E265334
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED51DA0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:25:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSBWeJ8XY4iSjWhLLF8Do3GbPZ2dtez4wgbmFZSWZ6E=;
	b=szvF2xclxyaB9ttwrQ/GvG2QtuENURkJoy/EDjMeuqFtv0MPSva50O2SefA4G1DDnYzxsQ
	jD6cdrWBR4/mtdOaCsebCbSIdxiu/yb16t/wQbd2QzJpiAOVxGY3MtGVSEIiHeYw/rIeVd
	A1VhLv51VZUQGezRxP3m605O6yaNqHc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770359132; a=rsa-sha256;
	cv=none;
	b=le5SmpCHcp1j7lIqvDNQKHyiqsYnDNEAezm6tqlIuf77wP3941BHXZuKqudNAeopqtC69T
	0pkL0eVITGbZBexhH1/sjo9EX0f8hqF2ycnqdthliqLabgUCmMv+cBx/fijJN1b1b14UkS
	6QIs8p5/k2jtE8FbbyoCOa6Tv23JTHc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8033468D0F; Fri,  6 Feb 2026 07:25:27 +0100 (CET)
Date: Fri, 6 Feb 2026 07:25:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260206062527.GA25841@lst.de>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com> <20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster> <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com> <aXN3EtxKFXX8DEbl@bfoster> <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED51DA0006
X-Stat-Signature: 55empucqk17z38mb1mkgyfcft53ckfzn
X-Rspam-User: 
X-HE-Tag: 1770359131-783445
X-HE-Meta: U2FsdGVkX1/HzxG1LC+OXR//Wa9m3DjKw5vLI6xSNHP+yicCwqCNZD8q33SJPtM/dNeXSM0KRLNzQb2u+pFqiHCokv/TxjoRCE6Rwxxp5e4jYdSNOFM12G/aw56BbQYLsO5nE1hmLvlOCUaluxkkLgL0SGxYEctmeoJB3lzvXowXcKJlVLPyVnR1ODEFEl1sLpERbCO+2Jfgd1GvkbBXAyrmRimLc7wfexhmWMNYtHSg0MejtWmSnBEcIjSd5TLMiRY2jHkaHh/FZOYzK7oIGeHWk7BdfCYHz9ctMFJJjSauJK9Uak4E7jzGcbvUNC39ryErf1vHiYYJqVLUNZEMDnFj1wYZegrdqOcjw6yEeBOa1sC7M8Gddz6SKZWTfwueLuPVkwdBsScJnhs2CspV42pmYCoqdk0qj8DGXRoTApEmHYBM9fIfrdszL3vI5gdxIvng4jwmz+R+xO/KvLnWjE3NEglyLU4TqOqHDAhXMA5jPhZQS5Zj9rJ2QaqtlibStIjNkaNNwjW4md2TP2LoD6qpqR/oSRTNYWe8KbXER5nCUGjmtDOLPUh8ipj8NL6/GvECS+ibO4c+JHHQnfPNnsLwvz219cpqNVMIiMPX0N/4BkL7ZAHvuYtZMUNkhorXmtu8DSHSKXLsq1b7eW+wI2KiGOBmQ/bnFySi1q/aPHSifrPQp3GQWot+qE0ivvbLrT4FSbi+n0eX4Ln+OlFuQCTE6Ow4akHcYxOLns5jQ0r+sFp1sQln3ukJpS3Vok6l9lsHU3K2LQeeAzxnfKRyS1XCQYh9FW80NpMZ52HaLkhtx8+C2TLt4z9dZDi07dxOzqVcXagclMTdddUHQQATGvGbCW73zqLIHb/a2sggqaya8AXNRahf2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 11:58:25PM +0530, Kundan Kumar wrote:
> This series is intended to replace the earlier BDI-level approach for
> XFS, not to go alongside it. While BDI-level sharding is the more
> natural generic mechanism, we saw XFS regressions on some setups when
> inodes were affined to wb threads due to completion-side AG contention.
> 
> The goal here is to make concurrency an XFS policy decision by routing
> writeback using AG-aware folio tags, so we avoid inode-affinity
> hotspots and handle cases where a single inode spans multiple AGs on
> aged or fragmented filesystems.
> 
> If this approach does not hold up across workloads and devices, we can
> fall back to the generic BDI sharding model.

I fear we're deep down a rabbit hole solving the wrong problem here.
Traditionally block allocation, in XFS and in general, was about finding
the "best" location to avoid seeks.  With SSDs the seeks themselves are
kinda pointless, although large sequential write streams are still very
useful of course, as is avoiding both freespace and bmap fragmentation.
On the other hand avoiding contention from multiple writers is a good
thing.  (this is discounting the HDD case, where the industry is very
rapidly moving to zoned device, for which zoned XFS has a totally
different allocator)

With multi-threaded writeback this become important for writeback, but
even before this would be useful for direct and uncached I/O.

So I think the first thing I'd look into it to tune the allocator to
avoid that contention, by by spreading different allocation streams from
different core to different AGs, and relax the very sophisticated and
detailed placement done by the XFS allocator.

