Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24325FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339F56B0088; Tue, 28 Apr 2026 05:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310856B008A; Tue, 28 Apr 2026 05:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D4B6B008C; Tue, 28 Apr 2026 05:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 146B86B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:03:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2087A055B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:03:30 +0000 (UTC)
X-FDA: 84707376180.15.50D8728
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf18.hostedemail.com (Postfix) with ESMTP id A1ECA1C0004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:03:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="jzW+RS/+";
	spf=pass (imf18.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777367009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipahEW+GGYKoUkQjhbzDfkF4W3Q2W6HmS1nNqAHycr8=;
	b=ybSblsgLld7FEFtQmzU/Nof0yOCSvDl6H5L4PcbO8NAB1rQ2grqzAbPS9yjR5n6U2zUviu
	vGikZwXtf39XdglOb62AOhwlccVXUicZo+fueoue/sFbiaQk7jy4Y1naZsjcCfGxi9xZ+/
	qcew2qGfF4MnecjJcqMWpzvCynAu/FQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777367009; a=rsa-sha256;
	cv=none;
	b=2OWEDeFWziqrc4f/ru+LCMY+dvfjcl97gycDeLd5FJkwB8TrdlqFthO0vAX2KLZk3EOXfg
	r/PFPFU7a1E3ErDsDMAU73N6Yb75yUo68mBcGcn1v6iaQUGAsrEi5vg8VbcAGBZtKgyDW0
	foChqb+8qGZEWa5CU8ftqK5P5XJ254A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="jzW+RS/+";
	spf=pass (imf18.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777367003; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ipahEW+GGYKoUkQjhbzDfkF4W3Q2W6HmS1nNqAHycr8=;
	b=jzW+RS/+QPw0ah3ql3B1IYAdfDhIlYIMbniWsHNHMtAL1DiHrUi26oZ1ZCxrENF9xp+Vb8wgW2biALSpYuBxU/VMwyRkMjlSM6c9athnZdfPibh19gB2/eFwMIdRqIaA7Rd+0m5jU95rSpyX6g3i6TBFUdS0DlKIx9Am7s156/0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X1u5t9W_1777367001;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X1u5t9W_1777367001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Apr 2026 17:03:21 +0800
Date: Tue, 28 Apr 2026 17:03:20 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
Message-ID: <afB32MQG9vx_j9NP@U-2FWC9VHC-2323.local>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
 <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1ECA1C0004
X-Rspam-User: 
X-Stat-Signature: efrmj9zec79anjysrg9xjodxz7kgrame
X-HE-Tag: 1777367007-284940
X-HE-Meta: U2FsdGVkX1/e936XwrSfTpT2wzNyZNtTRYtl9j5yQa6pzpIvxeRJp0ksiXykwbsqh0roKyTKQjjD2sTIcd+7DoIsdgYxsDIdYhK6IF9ZSq+yGJnkvEJb4Ud7pV0pgt6lj/r/dC9c48ac5KEMjP8xUI3A+zKVQ4SMCIuepPHELtCcyUdTUhiW1yL9F1TPJp7pvRpXR6I+TTyAd3BxfXkfrfH4MRiOXTRv/woyytbN3Hi8UvmrG2Bo8+7KDYX6HF/mw7W6VlSuP2ElugqidsDHXWS/11VsVhUMmlEwh65pDZLXEOW4F7i0vxKTIfheeBEGmXS+OuffKUdQ60UBD0oqOHhFSCp+SzRbeqsM82KImtu+StDW1HyBZ2ICi4SVdYYjPlaXqThPDZm3x8xq0nJ5xlv1XeW39aOhifD/o9JzDoL4uzn+OoVmfQUOlzU5wAa+bTRx2aVqlgLiAi1zDtbddOp0wVucBXvzUn9ONZhnIPTD9fYfULabFXT6kfoXB7cTS4P3sGFM4psNNcnTz+r2rJiOezIbIdV3h7qD8iWnAGVcj4myZwKSBGioD4ehTLEYK9WrSBpHk2u47MDWK1dqFkWNV6suQdBzN3K9h1CqrjhFQMnHyy08JXuLJpZr4+nwhDy8I3wvK9PvqTENyu55zyeFupqkpqQq1YEgQJR1UHQJ6sAIulKdDDseW0kAg8vi6WkLmJkF8Ag1mqXgDNLR//KHus2iOfIfi6ZB4mf68MJfm53XLyAXIn3zjhLk5v2966VlInbbB/AVnY4qShLMvEUFd1ZWmyvCGWrFA4le72FXk3dWt3hIH1jZkxaO8pX2Ng930yqJ4IT0hBexFhhix0aC2DbC9+DCiJZw5gBvEAwtaiZSm1a9g7Gx+iSDeuPvCLqCcsNYSomxrajF2TJcM71oqsXjBFnAdCrQrBpIzWLd67fsjkZrJ/zOxCm9yv43jmz2BSpES6nbcAjjD+i
 /YjYIbU2
 gm6up6PX3BRh3kOQKoUPbA2dChDJuW3ESkAztrii93b1erQ5rjlEJZgi92Hid/8YhiO6ASOflMus46P+GrxnqqrUyfVEWeLrs/Bgk36CFaaDtSD3hkq7GPPmSPeVNnS2lI6uTXuRDEtGu2G2U+Qm1SbdPPYH4RDtzPZlkeUMlcK8mzxrPNgBRrDJzpvuVosdVwMoUHAIfnHw67BbGMtij7K99yu2FvbxvVF21AhFL7Fud2YzdjDNNHFxDosQ4AvRysPHZFVq7X7VXjHV5wydbeeeZodt7OAFbjZdwk+mfjymnvcanM7xPRq2m+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 04:37:08PM +0800, Feng Tang wrote:
> > >  include/linux/cma.h     |  1 +
> > >  kernel/dma/contiguous.c | 14 ++++++++++++--
> > >  mm/cma.c                | 11 ++++++++++-
> > >  3 files changed, 23 insertions(+), 3 deletions(-)
> [...]
> > > +extern int cma_get_nid(const struct cma *cma)
> > > +{
> > > +	return cma->nid;
> > > +}
> > 
> > Why do you have to store the nid instead of just looking it up from the base_pfn
> > in here?
> 
> My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
> it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
> cma area (cmdline like cma=XXG@YYG could make it on different node)

One interesting thing is about the API to get nid, I initially worked on
6.19 base, and used 'pfn_to_nid()' which worked well, but I got a kernel
panic when rebasing to 7.1. 

It turned out, latest kernel changed the order of default cma reserving to
before the initialization 'struct page' (only tested on arm64), and
pfn_to_page() will return NULL at the reserving time, so I changed to
early_pfn_to_nid(). Storing the 'nid' could save the logic of chosing the
right API in cma_get_nid().

Thanks,
Feng


