Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02343EF070F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535B66B00A0; Mon,  9 Feb 2026 01:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E36D6B00A1; Mon,  9 Feb 2026 01:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A456B00A3; Mon,  9 Feb 2026 01:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E71E6B00A0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:30:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1C71BA972
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:30:26 +0000 (UTC)
X-FDA: 84423944052.05.F603EFE
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD248C000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:30:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770618625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5vi+2BeZGGPaVCeGDvqsKaftHeJQPTSsqdjYXLEa6fQ=;
	b=wd5ZdgPxNh/F67rA9i2gXxsVJlfyIZOF3EBCsYJgfbGRbXkUcD2qbDWvgnS8fkCiWwLMpp
	6PuYuYCugnD9X3KbpIQNV9H5+e3v3Q4rI1bAvaIzvYjecU5KjsDAs1ba1m78aHoZkZSig4
	11UXa+qjJR8/kTxQ6aSj/Wte7SZdMk0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770618625; a=rsa-sha256;
	cv=none;
	b=2dTDRAHcSOOwniCN7dEGC+kVNHujPWa61pJsPtiF8G119s+yzIBVmU+f13+aKp5IrClfIt
	s1PKVV7m6e8snxBQPwfipwPrKN5CHErvywaref8Vu6J6AaKy0kUQZ71h0wVcbu1Wr9cbG9
	HXbxAEQCP3y3UyKxd7q03uULX/U9mgE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA8A168B05; Mon,  9 Feb 2026 07:30:18 +0100 (CET)
Date: Mon, 9 Feb 2026 07:30:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260209063018.GB9021@lst.de>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com> <20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster> <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com> <aXN3EtxKFXX8DEbl@bfoster> <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com> <20260206062527.GA25841@lst.de> <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 758hs7gnayrao6emoateg96638pradn8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD248C000C
X-HE-Tag: 1770618624-532028
X-HE-Meta: U2FsdGVkX18PwCnJ8s2FQlgXggeScd1+Xmtm17EP4kneoXCyqLwZMmVeJrxW0Qkt4vURwdt7iDE5gXbWx/cxJw3HcJn4Qor/LW4DIrnZf21x16Bab9a7IL6vfEjTux+GH0KurKntDnbwYpuk1CDKxJ6hKqmTfcEUVMWKIMLojuX27d52yDUieITdaFHOu68ujk/jEZ15+y7V2Bf5RgvAb9enzobl9OwskZmvoqOUBlSPYrcXiYm3hPMo7UI6VmF7wvwt4jnv/pL9Tzu36oNJZSu1SK2FfOPhY8MvIiSOROHEDw3AMNcxSprZqN80u9YXmJeQgmwLHx7zk8e/lj87fsmIVZh9XdRRbwL6QgxkCWipPEDwlcJD6n5rh7rpK4lbVlXnuGOcoTfKp5H9LJjUUJDp5xBys9TbV62Oaf2jtzYfn80f6y8QP20hyEeCPNF/jVE9lrTl6BinsYgJIHthzarWXn/VS+FrRFxKrQajV02eRy8tAFxVkZaYupZPQKm0AOT+GBIdtKji504V6cYwfvLu6vpCYZkNFqGdDcPajTnpPF7GLGIz3VR53tpHeQJPcwxuyMEnI3HU7jtLeifEqFCyz56y4fq66WuQzgghjHb7rPU4LOdcCsuQ1Kq5Rab87b1ISrYUYpt9b3NfyQNbrrYkzjiwcIPzZ3dz81odgv5ZJXaLqCJ0ibxff0fGC9KchAupINvinTuHr5hBCNvW+Zz5tqN+d3E0Y7bduYvFQ7GYYPo2KNcQ6+vLT8Qb9T2sdG9cwF9aeEUXMYnAei9I8Gz/wi/PtyC4H2AaFmiz3F3c2KiGZTTcRc+a+GVaENCG8TSmQ3nrcOcTk6gzqD4Im5TA6WUdxhtwcDcaSw829WBM+zqFcOgbfmm+0i45SCu8mp9FTyRKXTZ1/D6Qc9fJlZDCDQyUvOi30ngSTCZnPF/8uxCKPy8rqOfS9UMFaj+CreqiTq2ZzdlR3Qx4brl
 FLSZ/rRz
 OEAVLsjqaLnP3q7f1k87vrnyH/lOdyCqAM0nbh6FErDywqfUTrTykr5sryTj6WqIjD3vadbIP1jg3SKfZpL8+SrVRIaCGEjkW/bSWo4icIyrsozqugbj7Qsz6CZfSp6PmksYajEdRY9+zsh9PtQYAwblDPxWTwcbK0zu5G2oizMXRPPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:37:38PM +0530, Kundan Kumar wrote:
> When you say "coarse-grained sharding", do you mean tracking a single
> "home AG" per inode (no per-folio tagging) and using it as a best-effort
> hint for writeback routing?

Yes, but..

> If so, we can align with that and keep the threading model generic by
> relying on bdi writeback contexts. Concretely, XFS would set up a 
> bounded number of bdi wb contexts at mount time, and route each inode to 
> its home shard. Does this align with what you have in mind?

Yes.

> We had implemented a similar approach in earlier versions of this
> series[1]. But the feedback[2] that we got was that mapping high level
> writeback to eventual AG allocation can be sometimes inaccurate (aged
> filesystems, inode spanning accross multiple AGs, etc.), so we moved to
> per folio tagging to make the routing decision closer to the actual IO.
> That said, I agree that the per folio approach is complex.

It is inaccurate, not to say often wrong.  And that's the point I'm
trying to make here:  start with simplifying the allocation policies
so that they make sense in this kind of environment, and then align
that sharding to that.


