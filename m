Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDABCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 09:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6C56B0088; Wed,  7 Oct 2026 05:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEA26B008C; Wed,  7 Oct 2026 05:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFAF06B0093; Wed,  7 Oct 2026 05:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 844A56B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:32:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04EC6A015A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:32:50 +0000 (UTC)
X-FDA: 85295315742.30.7173C84
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id E65DFA000B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:32:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JhLCfMNa;
	spf=pass (imf15.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791365569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFaMuiKpPNp0Pyieos+Acm5B+wr1ERFeUv2RGXc7h1c=;
	b=uV3tHqfvW80aznnR9aqWDv8hXMtflYMSiHNQXHlgjfCvP6c2PsKNibxJ1Z41wailTTA3th
	Qg/E0UH4KO2wPecSyxcL4mtMjErP6/Dmzif1P8cj/6cAzPQ7J+OV2YDqFDGrHsmlq60naF
	R7zklTBqDyI1RE0lP/BfXBCVgbnrUd4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791365569;
	b=EXvdI+th0O/F4KWLTYK5hv6W0P8S8ap/tPkXc+Z8u+FI12JX8eqoCvZGVglnRPDoyoJkRa
	RH7hylOe0LqFN8RGSnPlzm+y3YMlz0IT0yZmHVTto1Ir+ohAZ9w0HDd3uInlu3L59VrdfJ
	Oo0C9MiRrWzYnFo40AZXcl7IRSWaLkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JhLCfMNa;
	spf=pass (imf15.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rp4xtoKq14kvi6mCZhjkc+uj21SFRhqayBCWLQcZ6pw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791365567; v=1; x=1791970367;
 b=JhLCfMNapF4DoBIkAE4LhDJXI5yPnuHFADOEN9QFY7BoONhlUq620V4LkVAQ16vgHYCnka2P
 cn8K6bzV0W/BL9Gpl46pi1xE5t+pIFrxt8wDReyOZ2C2h3PGefO6jrwOyDlmdWYMDsQsxFiY004
 4ovm1JQvoTm366DEAXwA58y0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f254123b51092fc3;
	Wed, 07 Oct 2026 09:32:47 +0000
X-Mizu-Trace-ID: f254123b51092fc3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 7 Oct 2026 11:32:36 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andres Freund <andres@anarazel.de>, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <asYOJs4PYv326KNe@quentin>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E65DFA000B
X-Rspam-User: 
X-Stat-Signature: 5gcnp8cjzfzed8dhdiduoqymwuzk96ja
X-HE-Tag: 1791365568-588770
X-HE-Meta: U2FsdGVkX19W1gsnWe3VU3h0j/2Wl3+RNBldSoGxmARhAbJYcuS9JrP2BttC8fOUnaRxNu97QajKNjvoV37lqHD+rLMCmPPFbziNwmgU0SWnOlMi80YsSVaBJcxmvGQw8qkqbwHBaFCgzHKxFcxT5OVT+ze4XyaHutDuKDHlZ3hIM4Xr2MQ2bpAlBsla2TEiaYcbrCqzEyUxA8ypzR/yxnp3++FQGDhrBcC7TE6CVUHyJP3plM61kb7bGuMFN40fyNkOThYpxo5knrEvdXB7CUtJyGXfhI+dvpwNFKSK1nqdftarJ+k1REejkl98h/mirquC7ChfOhrgRlWJZ5vXLO7PxoEod3mHLEf5jD9O8/FThU141ySacj/SbJUmAt/rafsHecoCZ/g/V+Vu90R/gUntTlN1IKAnmkkyR9BgORZNO3DYKCfWh2REmp544r7wo2XaSu0Aq783wksfIaUNakut6akJADSACQiK54fFSefJDxKYf6d4ulwtXFH14AOgdN9tsql77bNbt83w4CtLJTWIEwmiygGj95J/PJrcgZkNwXxudPRG5yrMUCXHbdksS7WI5KBvshOsPwcXnJhr0AS0P/4KyckA5rkfhjPyMqKh0yeDo+D+QWXqzauAiT3hDBS3vfzaFivAGh4k1KtFnAYkxRPJyVfGCc4iYwpMoHEy0SgmT721B+pqSaK1miqAMWOzmMqy1fLd0yGTzlHc6wknpJbOhztX5RL06A92BAyZHr8of9mcVZb50I8UrkhimBnn/6CJFVA6RAI4JkWppI1cIhn8CqbiDSibyTcjI3gXttr7T4H6EN1Kybn56Iopm60pJ9+1zo8nQ5HTN7DjJSE18a4YJZXLHyu3j2TKs65uCTkf8dyGdUfWZ7NdAoT0sEhHSkK3HnIWH9MOK5Vfo4G5bDtkmUdzgQYPgnOtu6ecXs1dGpdvYXs1pIVggnP2mouldNIL/n4vHbHz8SJ
 bH+Oh246
 hyua17tiehWs43M8Dcqfr1KLBObTuSrmC73FihDGLdQKdzHDzRQzG1Nl0XjpmJ9Y6cPVRQdt/7u8ueE5TpbgIB02mtxVkCETKSEy3SWl8KxAPHY910dkq6B5vNaUgwleaAZp25DbPbGSpGztuxkWRLt9/QPv8RApVcAm+C0gF2S/MyjinMLjn6p5vAxwBF0BQ1gQoL0SNqlvVMZw7J16UBtAgaDATgruh25vn/6NXWphlNMHw/WrDs2+PxRTFVqLuE4Lsa+jMSowgNFRStsAZzWh8vRiTpS5NQN6BZWGTcvoIRU4w4Jetcg3aHtU1mgy9oInBizUT5EVMiTa1ZhNoMHrPcgPkGyKiEjpiEHhipL9b1MDg4Y3mHaQoua36jUt1V+ZL3O0NFrgj5cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One general comment, all your commit headers are starting with
uppercase.

iomap: Add initial support for buffered RWF_WRITETHROUGH

s/Add/add

Overall this looks good to me. I will run some tests via fio. Do you
have a branch with WRITETHROUGH by any chance?

On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0, pending = 0;
> +	loff_t submit_start_pos;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on how DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)
> +		wt_ctx->flags |= IOMAP_DIO_COW;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	/*
> +	 * IOMAP_INLINE mappings have NULL bdev and would cause
> +	 * iomap_sector() to dereference invalid memory. Reject them.
> +	 */

Nit:
I noticed that gfs2 sets the bdev even for IOMAP_INLINE. A better
filesystem agnostic comment might be something like this?

/*
 * Inline data lives in the inode's metadata buffer, so it cannot be
 * written via a bio built from the folio.
 */

> +	if (iter->iomap.type == IOMAP_INLINE)
> +		return -EINVAL;
> +
> +	do {
> +		 * blocks in the bvec again.
> +		 */
> +		if (wt_ctx->nr_bvecs && prev_pos + prev_len > pos_aligned) {
> +			size_t delta = prev_pos + prev_len - pos_aligned;
> +
> +			/* Everything already added to bvec, nothing to do */
> +			if (delta >= len_aligned)
> +				goto put_folio;
> +
> +			pos_aligned += delta;
> +			off_aligned += delta;
> +			len_aligned -= delta;
> +		}
> +
> +		prev_pos = off_aligned;

I think this is a mistake?
prev_pos = pos_aligned; ?

> +		prev_len = len_aligned;
> +
> +		iomap_folio_prepare_writethrough(folio, off_aligned,
> +						 len_aligned);
> +
> +		if (!wt_ctx->nr_bvecs) {
> +			wt_ctx->bio_pos = round_down(pos, bs);

We could reuse pos_aligned variable here instead of recalculating?

> +			submit_start_pos = pos;
> +ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
> +				      const struct iomap_writethrough_ops *wt_ops,
> +				      void *private)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(i),
> +		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
> +		.private	= private,
> +	};
> +	struct iomap_writethrough_ctx *wt_ctx;
> +	unsigned int max_bvecs;
> +	ssize_t ret;
> +	struct blk_plug plug;
> +	size_t min_folio_bytes = PAGE_SIZE
> +				 << mapping_min_folio_order(inode->i_mapping);

min_folio_nr_bytes could be used here.
> +
> +	/*
> +	 * For now we don't support any other flag with WRITETHROUGH
> +	 */
> +	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +		return -EINVAL;
> +	if (iocb->ki_flags & (IOCB_DONTCACHE))
> +		return -EINVAL;
> +	if (iocb_is_dsync(iocb))
> +		/* D_SYNC support not implemented yet */
> +		return -EOPNOTSUPP;
> +	if (!is_sync_kiocb(iocb))
> +		/* aio support not implemented yet */
> +		return -EOPNOTSUPP;
> +

-- 
Pankaj

