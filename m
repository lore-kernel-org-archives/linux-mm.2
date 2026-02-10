Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315ECEA8130
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDDE6B0005; Tue, 10 Feb 2026 10:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6819D6B0089; Tue, 10 Feb 2026 10:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D706B008A; Tue, 10 Feb 2026 10:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4783D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:39:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAD3959742
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:39:01 +0000 (UTC)
X-FDA: 84428955282.21.AF75163
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 024CC1C0006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:38:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770737940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h9BOkWtvgTvRTmNeQqi90JUw63So8RnIFY/BIVnov08=;
	b=OTHrh+J5KNnVB5mQjYd61tqaseAGHhSTUWfrH7SRBRhCJIdigm2Ithm28su0uiSTQuHUQ+
	mQwIpBpLlXBmGhIBxnplbvIES/x7HXYvOAGTocdbTiwHlb3k08NY64XZxSSWLwe41eWj15
	SPLE3XDpTIw2A+L48Cnd69THfG/DeVI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770737940; a=rsa-sha256;
	cv=none;
	b=kRKhUTelK1OnPUEqxFxOh0mzJnvHKeefgJnvN+Tg/jfKxxItTlz6QeQQXV4Y03XXQRXPIG
	i+WC6wh5VqjRiyf0yOpVUp4Rw5NTro2DuRyYiVVcjw1E7WNNFVj26dlwvKVte3Kn+brGXp
	PwlcnjQIZsG0zJ9dyfoROj2mjG05qoY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3B9468CFE; Tue, 10 Feb 2026 16:38:54 +0100 (CET)
Date: Tue, 10 Feb 2026 16:38:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260210153854.GA2484@lst.de>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com> <20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster> <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com> <aXN3EtxKFXX8DEbl@bfoster> <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com> <20260206062527.GA25841@lst.de> <5b11145d-15e2-485c-a978-365b58854371@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b11145d-15e2-485c-a978-365b58854371@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 024CC1C0006
X-Stat-Signature: gbtn9jyeh55mm9bpyy5gyiiumjych4r5
X-Rspam-User: 
X-HE-Tag: 1770737939-110684
X-HE-Meta: U2FsdGVkX19mz4a395kOcRdEI4mIqBuPnVN/abps8qVb0ob+6lcb0MOAZ0ZbsCg+5EhalhOQ9UMi62BD9Dme7pymyb6phYHDLvPxd+omMJpcLQrO6uUXCVw/KB28iYp+zK+ikJ1cKhtSTiMIG2HxCposFJAVFIdpQEb9F33+JDElrmZG7kQNZIGZ2DQCp9EoqW43wHPoz1/d22Hc5E1RCaQwPVTvIJd++asxKH40KWJ+DvAmK1qmtxpBfVTBckLlrWHqKMyquooImOXndFCL0yUoGZ5FFvzs7VjDQB5K1Le6IrtnsyFET6yttt4bbOaG4TSRZtBd+wzpFU7R1OzNMSwB8oes99nmUeaCRcGbfASF/U33SN6RznXKS7nwQZV1tAQKtSKKPKfopm8bFAhZPKpIehoahGsmMYvHHEsSXKxXTd1ttyOsqgrsYVgG2yqM3ZP2eOVzK0Tp1ShZ8hfLvUrfgipEbX5lUvY1S1gR7Iy3JmOfwAc7vjJcOzCziZMqaGrMGoomiQy5SmFVnsNqr29JZ7lMXucvr7C9kUa3qdQRLckfjQD/9Ev8zxRvLnNchku4VGQPvEucvpbiN76j+rJRyvo/Sn2S1KXJuJKmKdqqggYPx7GSyDkUUvNCYNb5cUjGyAtj7sl8L5cqro6on0q7evnRlhZezGPzIikdVF4Nok5BZ/FENPvee3853bwAm3witG7WBJxJ0JE+ExueleMchJw3INIEsnZ79Z9cwPD9kl9rpzfNTYaAzDcFv+f77If8bIc6PZWjzJg3XConrpCTXklDeAQvMMoYPPYoplGfTpBtoB/cFBPwTX8fXc3C8qgQM4YRUclINQY9aAztlNtkPK53zc4vhJFC2l1YhZNA/L1KCLgGQzhm8RmDh9U3acOdnQEuAn70CiZ2ROd2Q16YjIQUxgRKqKmmbtO4Avs+hVg9dvCXvLqmcvRou9NAb7r0ZO6ejXfC9DxOLjC
 /kRfo+Fq
 XEMfk78RGoIymwWFCi4llQWJzObPLquAoiN9sMCrZ2PKDhfDpVTyOYnT7TVOmp6sIHikrcD15mdMIgY5IdVXAfUdPPmuwETEVMBVEMLagFnCStNjFuP6kxBYNy5ngmO54SeFBGmFki4NI5UzlRaMKxWsjQXVk2DTFEztlfmsvRpYcarzaVmP97E5BvkIPbS1JYdF/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 09:24:49PM +0530, Kundan Kumar wrote:
> - Create a bounded number of bdi wb contexts at mount time (capped,
> e.g. ≤ agcount).

Yeah.  And then optimally map them to CPU cores, similar to the
blk-mq cpumap.

> - Store a per-inode stream/shard id (no per-folio state).

Yes.

> - Assign the stream id once and use it to select the wb context for
> writeback.

Yes.

> - In the delalloc allocator, bias AG selection from the stream id by
> partitioning AG space into per-stream "bands" and rotating the start
> AG within that band; fall back to the existing allocator when
> allocation can't be satisfied.

Yes.

We might also need something that falls back to less helpers if
the free space is distributed unevently, but probably not for the
first prototype.


