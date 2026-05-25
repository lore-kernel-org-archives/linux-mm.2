Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EADCD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5856B0095; Mon, 25 May 2026 02:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD756B0096; Mon, 25 May 2026 02:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAE36B0098; Mon, 25 May 2026 02:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5066B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:57:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E37F1A0175
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:57:50 +0000 (UTC)
X-FDA: 84805037100.13.1429953
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0980B40008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:57:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QUI4ZzFw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779692268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5p3AvS0xdML2EzDjatAHJdIboLFfBJpjK7i1jwoXuM=;
	b=KteXbwA3B/1KGmhg3nT1qsHBdwiJ/psUHuZHN6ia12RIjTd9Fs65bqjWfXDX/8W2Fk0qEH
	DDDRgKzN104pnA20a56IenbZu2Y320uPKzHuI+d9iXonJKNGbha/+Yb+y4lATQOhxV2aZ6
	Iy5W6fmIuJ9e6Nnnp+ETIU7XpGI/Zgc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QUI4ZzFw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779692268; a=rsa-sha256;
	cv=none;
	b=Zdgut7UqHpEq74vfv0lMKBb5cI/xr7meBwqQPVNuMFgCWQbibPRjGfvmvbO37zy/9JoaTF
	HcedIry1BkVhuHH322iBOGvQYJtIam+JbrUpOtWZKjt6lbTgr+wh4LRV/7oMxoY0/FTcd4
	yLGZnqAeW+nE0+7892Nyr6oTbYJ1O+g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W5p3AvS0xdML2EzDjatAHJdIboLFfBJpjK7i1jwoXuM=; b=QUI4ZzFwVqog0cjI4lGEZLbGmo
	uitDcKoLRwLqqTIeFDbo6xgSetgUCp6z0TeJkYv5hq3Q9aJ+MoMj8caLbPuj4BlRlGOnOLgQSzEi7
	e0R4FWCAEMeBlO0OvDn+VpgOLTEAz8E1/bfzC2I0RW0FpKPSLu3trSCps7qFs0whiFgYzGjtuAoht
	+d1Wtew9q80JGg80Kq8mjESGGXbSsy8oVhVzaKrqoVHGh2S7cViZhMiEp+uo7AQJnzC6kgMIPG/7m
	eA7YO0K23m90+GR0pz3Jxm6lE9JorQExRX2ZIfBihgRR75gbbPT9bZuOmGMu1aXqQuyIStIHJgyZx
	RZ/AkIEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPFu-0000000GThS-18DE;
	Mon, 25 May 2026 06:57:42 +0000
Date: Sun, 24 May 2026 23:57:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>, dsterba@suse.cz,
	Boris Burkov <boris@bur.io>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, linux-mm@kvack.org, david@kernel.org,
	surenb@google.com, hannes@cmpxchg.org, ljs@kernel.org,
	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
	Chris Mason <clm@meta.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <ahPy5sZfkqwkB1FT@infradead.org>
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
 <20260523155859.GF183694@suse.cz>
 <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
 <ahNYjY1aQlgOehlm@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahNYjY1aQlgOehlm@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0980B40008
X-Stat-Signature: 61ig6atn6zbq31fr5fas3xq1noy1fbf3
X-Rspam-User: 
X-HE-Tag: 1779692267-647563
X-HE-Meta: U2FsdGVkX181Mk2kiSqn6Ngd1x62Pn4xVJXof+YCgaP78LT37LHJy+nt5uloGy8jWB64AouS+lhp+g2LWq82Y/6BJGK2IGm4nvIS5G4NYel/a7pbeHI5dMU7WfCtvi9Lt+0A4zk2nPM4Qpw35yWr1BkCoFIGEV0AUcA8JMwKrF+iy7+kJX7dnQDrGqhkrXG5duqNFRzfll+CoJXPG2SG2ccYLSwMMobvbdoCYBgi0frPfTJA2q/JgPVMB/vYjLnRgYUnDF4qp4kF1s2KzZSfgf/aLm5OFNJRZHS5EtRNz9FGk2iL6gcjrHanG5sNzCMuf/uvDg8Mk90S3Q4/7aCa/W2oXXVTcqYY7hmm1Q+jkDScPXmvY7vjN1PjgCevpUOOL2y32h7RHWMJVB7x4wR3s3Jp/tHuiiWHt6F0BR0+v4kyCBnBd+hxMUKEXe+lLo+7qC4hwU4ihBbNowI3S1jRI2ukP2wNzOf/EYO9WZUNUD2dT92jlY3IU4Xt8p+k7AJF8MkIfh3u8t7B+UsO0w618vVg2azoFSi6zLeUc0BJxq5twvG61xzuAmOzLRkIsFs1+L3k6kW882hK9WzK9KKlZzbABs/QUgrJjQf1DZyJKN/MzBCI3ITNAYpiztB33uwKvM14sFI2NxSO8Lr5W+zr7J1ZpDgcphEe9r0drYmVph24SQL6io0SNuN4Dg2aG1mymK15hXGvrNsp5UP4R2k2eV/hO1AJUR6MxOx5eafbGWOPnrSTtB+w7ept8LA9yUOpxgyTaQeB76jnaQD4exv9l7V0R/71PTNOrxHg/aWxhuad+06sAKvkSi1Js4W4xuBthcgzNJ8o6t9oDdXdf+ggqwaaKSvTiIEG+U2X9FiNdDm9NY1j6dyOzZu8VXQkW1zZ6RAR9xvgtutXgAeEECD5eQnmr7DM2MESo3Pn4gcgRzus/UOROYxRTlPAuOSMoaEkyXzjexS0bU0tjLgf4Py
 r1+a0f8W
 Qx+Nnez42eVSgIzyjaxAufsUanVplpwN8g85mRmZ/YrdsBuRDq/a8YY1zwIqDYLMDyZy4j8zgMY1hcjVMGsNQsdEQ1FxUzodaNB2ynAebWlloJaHOh/+4jmY8e9pLy6T2VuqwxbXOyN6IqO274FM2avbvnDa0OUx2H39p2dMHBOSMQyL/lCoIYHoQieuM1CtibWYGRl2Cv6onBfo+6gvZSs9DPXp9xYqwSc2g+WjzoPTVa4gmltG943T0162goVXuBtmKpCGOwrlqApwF3vnusygmmvKElgnyg8fGIJ/7yTXXTqjYA/WIwO0tTDydw3D3mpg2Uz3Va48TT8t6q9T8dQ8gZcUdUhUhEEPD/zE8VFrhaOfYZTrESxAUyv6NMkraNH+j3SfJvGIhufKRqp895EDRn5Oa/dpFAC3Zn7GkzRcgbg/m00ZiMDoU3vEP4oRda0zNN21f4qva3BPaRIRTLs5SDqW2kjObTdltHUNCNQwUfS4puCKSZzFBMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 08:59:09PM +0100, Matthew Wilcox wrote:
> Every use of GFP_NOFS is a bad code smell.  Filesystems should be using
> memalloc_nofs_save/restore.  The problem is that it takes deep filesystem
> knowledge to understand where the memalloc_nofs_save() should start.
> It would be good to lift the GFP_NOFS to the callers of this function as
> it gets us slightly closer to being able to replace it with GFP_KERNEL
> in the places it's not actually needed.
> 
> ie what I'm asking for is, please don't do the 'extra_gfp' thing.
> Just pass in gfp from the callers and make them all pass in GFP_NOFS |
> __GFP_MOVABLE (or a plain GFP_NOFS) for now.  Someone can come along
> later and change them to GFP_KERNEL later where warranted.

Note that is should be pretty trivial to just bubble it up a layer
for changes like this.  This will naturally gravitate to more useful
places.  To make it fully correct it will need manual intervention,
but generally bubbling up should improve the situation.

Same for GFP_NOIO.

