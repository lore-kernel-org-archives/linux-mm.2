Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AA6CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2A36B008A; Wed, 24 Jun 2026 09:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354356B0092; Wed, 24 Jun 2026 09:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C006B0093; Wed, 24 Jun 2026 09:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5826B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:34:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61A641C5B4F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:34:43 +0000 (UTC)
X-FDA: 84914901246.06.7895A7A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 79F7320004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:34:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gct7EzQR;
	spf=none (imf31.hostedemail.com: domain of BATV+41526429243acde27946+8340+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+41526429243acde27946+8340+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782308081;
	b=Z1g4pPuPpI6JUe4pbdq9GgTYdf0VbsO8UDFPdEF2FaV1XbBxuVBFGlWAdJvAs87rzwULq3
	/i9XTp1QKjptRxgBOMO7xV088OwUb1tylkrUnMiY0qaJPeWEEjMQFmyt0gc4jTzy7R8PYI
	BA0arDn2QFw/LjCNS35rdXQMPAPzDKs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782308081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnIbvnh3iSm52wFeB2rpH5sTTY+sTkta8vjSnNdSMJk=;
	b=7bqBcDWAOzqLKDePhsk8XyU8Mza2SAcztcF9g48jB75bxSTlm9otdH4zFNk3Qs0/sL1yTJ
	AWzDGYXeLMfHdc9mRCYUvS5KiCdarvXkzS3KxusGKkGPhQWXdYxJE70cAqbfMiiRCFzlZl
	30bg0ufTG8giwYwVakBW5vfDfalsFHY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gct7EzQR;
	spf=none (imf31.hostedemail.com: domain of BATV+41526429243acde27946+8340+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+41526429243acde27946+8340+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=WnIbvnh3iSm52wFeB2rpH5sTTY+sTkta8vjSnNdSMJk=; b=gct7EzQRkOA+lmJ8C6JMtmipYW
	m86AxGSJHqWIFyXSiA6QvPytgC/XEKIyi0+SpxESW+nnmk7kxSYAk0t841uEhuSX6zDqOdSvQjGlG
	odylKrJcGOIKgguo2n9ongjsOyEWl4OItBrgl1PZ8NFzVB25Tw7ebpnCkofQrOp8DZQwOAvNt6QWF
	8kPLcphVqLs9hxpanXtsKxN3qm2djkm+LK7vwOCJWFefaBx6VON/juALMmQBMuMqrrXivg7/Ow+Uv
	TfYQnrwYBcHfffJaH1dNz+wNTz+eQT+tPMphVYiw4R/SP9UGDWjMFYbIx1KTWtcMTujZoFUwiwmH2
	s5jjBVbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcNkT-00000007pWy-0VhN;
	Wed, 24 Jun 2026 13:34:37 +0000
Date: Wed, 24 Jun 2026 06:34:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: ritesh.list@gmail.com, willy@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, vbabka@suse.com
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <ajvc7fSDngyx0X5j@infradead.org>
References: <20260527162412.19922-1-dipiets@amazon.it>
 <20260624080639.17100-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260624080639.17100-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: ibsk45zd18rt7gr7wfoyutcjcw9tspqp
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79F7320004
X-HE-Tag: 1782308080-977281
X-HE-Meta: U2FsdGVkX18BUf7ELskleWc8xtvcUsXD3mDSPq5NNeca937aHomFnymbj/cKDx5S9/2NFj0wjsV9RwEXEMZJuR0Ntk1arTFs8O1TxwKTn0N778nPc9ejAMpUciF2Z3sfLQosTyJBYxJK0hRnuUXI4eRcpIngyjQJaB/EYEyKyoAwe/z3cSQ3RXLy42rfpJbaB3dpNZcEvzzP5k5uFGyrSQ0Hou2W+hQSCRQOP60pHZy0XPHp5r7qwvxKc2wU2rWsmuGdgmpXUPboZrmeZK78TmmNrrnAThxVJ3oLegCHoj7kIBIv8VH09eCqVI3Cxr6bjTGR7JJ5x3yr2u4jE3ioBHGDs1UFMZRpYkNri8DwyJniQOcAzT9Grfp7L1iK5tSBnzbHC87k2Ahi0Is54qelc0ou6xiJP/SA/W6LLrAi8HbMduhL9EVGIj+wZmauVGUsH8IAZkKSeG0t8xmFmzPz4Gy3basLWRj6v2GW4TEUEYTHwja4/9BQXjl7dKN42nQ2LyuNMftYSUqNk2SCv+DT6n3iKwdxSSlZuQxx9hHwdV44/2lAAvBmYBTn2Gq5ObhuZWo0B6x84BanzsD5ldWKd+eRdtICcYLpwiw5x2cLbaGX4xuPX9Uk0hbLd9fP1XW1nL8KfB7iO3LcVi6rMJcODhNdEbJO9hyQWFomN0JJJhAoXJIP5yVslu+ydmw2cvwblnHmgH8UK4ok3pSMb5g2uEBSA8vy3/OTJd8aNtZFQthPGJmw336tGd2ALFJy/Qt1mnpBubTNTrZvT1HJD8MxJou4lOwj9zFiFQ8FaHM3RtEasZy4aPYIGBMLLyqvZKekCOtESnj0Bp6mnaeKsCVnBTt/gIqRVexa6E+A+flDMxEcrTRR3nqW50xEC+eiOR9LWpfaJCHg8zapqqfGO/6HV1bQRfOkgnPz4G8PY4Pmqhr/HyDhG+7LREcXs2krRItBeuf41dUrZoMq0pf/u8U
 xyuhHqAW
 OUrxRdpLl9PQqN3SWGeQL98eZ2s2reBGtXJARwPvGB3sZcIf55Swa3x31/zkhbd8oySCHQhkzAh+diyNa/t5UbdLV7s8vTgq0dbus0MopxFttKXcoEq/ELaTzadXBop0M0hWeZhmUyuIZCGu0T1LgFU/6YIhSi23/rv+gsfI6WhD+gtHvmkqTEDl1gxt11iR8RWDQViZUnjyNFMrjUkLHFon4+NTOjN4cj1LBY7zl2NEwyuuJn+1gNWWw+5YhNKWFIddBwaPdCzcoxGJmDTDvUtaOP+mnCHtbuDYyQmiETKVad5GIVltBCdXcaZHOsxfvN7E+/OXFh47WZREYgSvycIKS9GVe5fge4iEV1CfwZB3TO7sDHjwWaji/CYxnXZU3TPwCsRW7WfwvJ07ikzlbeF2RWBYNvVW9UAENc9zrK2wueaw90JgRFJzX3d9ZFxvWIuvJ1YD4jT5eeVdT4aCv4qmde/IuChKfOnLa9aiQC/s1KficbVZpTvzJAU5MZFha+0iJFqZ9Z/0MZYcOiUYWH1fmejaClIV92I9YchMnVAav9py+hRHJQNeB52hXVyIRIO5AT8Y9SkcTDe5V5V6YWnB8+FSVWzseLOy0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 08:06:36AM +0000, Salvatore Dipietro wrote:
> 
> Hi Ritesh, Matthew,
> 
> I wanted to kindly follow up on my summary from May 27th regarding the best path 
> forward for this patch.
> 
> To recap, we benchmarked all proposed variations and shared the results:
> 
> | Patch                          | Change Location        | Avg TPS    | % vs Baseline |
> |--------------------------------|------------------------|------------|:-------------:|
> | Baseline (no patch)            | —                      | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c | 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c           | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c           | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c        | 134,278.47 |    +31.67%    |
> 
> I'd really appreciate any guidance on which direction would be acceptable for a v3 — 
> whether that's the page allocator approach (kcompactd background), one of the filemap.c
> fixes, or something else entirely.

Do you have ointers to the patches for each approach above?

