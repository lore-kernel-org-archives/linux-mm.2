Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42AF4CF34B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE936B00A8; Wed, 19 Nov 2025 09:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F036B00AA; Wed, 19 Nov 2025 09:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4C56B00C3; Wed, 19 Nov 2025 09:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5886B00A8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:08:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4D82160368
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:08:35 +0000 (UTC)
X-FDA: 84127536990.03.FCE49F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 713BB1C0015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:08:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fz2a2sSn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763561313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Yg19b3C0A9RgvXwEm9q22h/mHwyzJvPVT/d/nPBkXI=;
	b=rVVVjJfymGacl5H6B8ui9plxVMCaWbCT9p0winq0A0IQu9f3rLqQX+sRHAEBD3JKRxepH+
	SAxCunl6RSRD2Na4jepOv3WvxbZ4bE/IyA9m8ICvtHoqRI75ruKZe91fZRcRBRhAnTGq+6
	1IenXTvPvrTHuABolTfk5ndz68xzZpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763561313; a=rsa-sha256;
	cv=none;
	b=umwCuU9yEw584dOyXdlW2sHnNLXKK3BlhZf4g5ciYzcc8HyIRTg/VltNH/OjCi86rD6Ihw
	WxIrS/hM7aUh9HdkLONC9ElBcYYSa7jjpKyVlwT85tjEjeCLX9fv9yg+beAf40Ap49Swv0
	npVlDlhJo8WiYsMUv0uLcuCkDd6f6g0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fz2a2sSn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763561312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Yg19b3C0A9RgvXwEm9q22h/mHwyzJvPVT/d/nPBkXI=;
	b=Fz2a2sSnkSL0ab9QJe8UxI3XJWX0MF5iUmle/tNjEwFX3fbe3PsoetKdvp8khLub/B40hE
	aWB5tCJZ7Ma8E8PULdbwK7HnlS71N8+fom9E1SgvJOfOVtuKJHPAwNSzFeT4CfA/TnITQc
	sCscR29cHwE4aV96IehanF3q1Y8DAVQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-JwJzTWP2O7aaSa9fWhiWnA-1; Wed,
 19 Nov 2025 09:08:30 -0500
X-MC-Unique: JwJzTWP2O7aaSa9fWhiWnA-1
X-Mimecast-MFC-AGG-ID: JwJzTWP2O7aaSa9fWhiWnA_1763561310
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8A75180034D;
	Wed, 19 Nov 2025 14:08:29 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C44DA195608E;
	Wed, 19 Nov 2025 14:08:28 +0000 (UTC)
Date: Wed, 19 Nov 2025 09:08:26 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
Message-ID: <aR3PWnNFhOckoHvc@bfoster>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
 <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
 <aRyFOsUk--AtbEGM@bfoster>
 <9e696091-9c40-46cf-91b9-c95e1d38a1a8@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <9e696091-9c40-46cf-91b9-c95e1d38a1a8@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FgBcDXXAm5mg80VkTpfLgPdvNadvP-M-m47hlG6tsrg_1763561310
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ux44qwenntbhndcamnz6dw3ccxgc3qji
X-Rspam-User: 
X-Rspamd-Queue-Id: 713BB1C0015
X-Rspamd-Server: rspam10
X-HE-Tag: 1763561313-790691
X-HE-Meta: U2FsdGVkX1+5cm2YJsHvD4i5oD0cJpgSFUGWdv4WJHJNEAYMjNBRc6HPoDg29yZRu0speRwKY/z98QfunzarIbZHWjV2pWGylr7m5mu8eS+qWgnaw9hThiRZjmC5G4KlDD+J2o2uTlK/eZVztDdPl0bFrJQGMm2OuTho24jS9EkA1gcloHgnf2JvOoTTa5iJfpnuJ2OMW6J5whGj1Z2Z/rESKjfbWwm11g/PSxe+MzaPBS0S+4xeXXb/9b7LRjr+SezKSp9azFGevyoyQkwr5XYsRCoVs2FZICmmmOLw4ByEv9K8qboaBzWVhDxykZRnsVeKxhDuspsLZa7EquBJtYx8F9NRid6VP3o1XPX9Qj6X7jVht289LsffTHFo7qgxL8K11uE0lsTiTkknLf69QC3b0AeCQOEL/WTi+oueyVBAmfDhmYau/AFkhcKBA7JSBLvL96VVeTtoW3P8cE0QpBEAGi4IQyllI6Hg9wZSQ/dj3LLLR6yWVCs+Ml81XhJO0eV5Bbb9JtQ90c0ho3RDS6snk+iR8oludG+ZGvfMm25Vz0kEGxPWwzUTSrkAYBYRhCKSy5RFIAIxzDAEXqpLNSZ9oTEL2kLs5D+ZHNnNJyPYeVHfW0nxGoWBiOMnqOz55ncuwff/17kHZ0jLc3q2KpLCUtf0dqOQwgVq12Jg7wK1Ip1UeDddf9IyaTBM8Gdm53hW5HsefzwV4Gnv4vPUft0MHRZPFCk5k8w8726QR16+OBa9k7zazU9L6CtgiBln2bTSU6KFcTDdGeEPMC03mbJfX/97LE4OJrMfUiLbJssZEwtC7RNXANDirE+/qFGBx+cLDjnzRUBYDWDmHZxLoDOBGixKmK0qR5uNPmV4fplxbDgt8m311+TXVEoTltFM1oT0OdX5ZB0/N2EkFdOz+asqy7EjJ1zWZem9Yqe0hzO/eAc9qLr4QuMD5rJFRfIETxqwjAl7Qtdk2YYh0F+
 eGTZ3jTw
 X+HGhOo8bae0s1jxl+ubVW+bmLV5pvV9DJZ6lkPhGIlf2ZB5bBTmZlo88S9WpAqyEiIMe0OjnoWeDNjJ53NY1sHdZwcryOdpxXKDeQoAiCpRw2remZDNuF2GzCyZh4kS9wyj6d5O3WTHW2uJ3AUY/msSj+VLlvxEsH4dCpUxk3XIu1NP9B2X7r+I12olAvTC1WsQ141SmG8SVrzdFUYsDyEsnmZXq7ure1q9iZmOkveKVEHMpAhbP3VUnEy1cbK98CJ0yF02veoyrvh8cyCNqlxZ4CzgYxhK2M+KV2v+IjpgQ251Mw/lE/YY0p/PTnWp/xKZTs+HgjYUrDoLzDEh36NcAdAwiJdGJrcabPE4RulEd2sXKvlu2oZcirt1N2zDnGtYyiomtFhNLywX7i8WUIoWaETxA3HEUC/4AVbNBtELyJ+pXXrc+jDHQX+Vhlebysf32ukRUzPQFj5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 11:53:41AM +0800, Baolin Wang wrote:
> 
> 
> On 2025/11/18 22:39, Brian Foster wrote:
> > On Tue, Nov 18, 2025 at 10:33:44AM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 2025/11/13 00:25, Brian Foster wrote:
> > > > As a first step to facilitate efficient post-eof zeroing in tmpfs,
> > > > zero post-eof uptodate folios at swap out time. This ensures that
> > > > post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
> > > > pagecache writeback) and facilitates zeroing on file size changes by
> > > > allowing it to not have to swap in.
> > > > 
> > > > Note that shmem_writeout() already zeroes !uptodate folios so this
> > > > introduces some duplicate logic. We'll clean this up in the next
> > > > patch.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >    mm/shmem.c | 19 +++++++++++++++++--
> > > >    1 file changed, 17 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > > index 0a25ee095b86..5fb3c911894f 100644
> > > > --- a/mm/shmem.c
> > > > +++ b/mm/shmem.c
> > > > @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > >    	struct inode *inode = mapping->host;
> > > >    	struct shmem_inode_info *info = SHMEM_I(inode);
> > > >    	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> > > > +	loff_t i_size = i_size_read(inode);
> > > > +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
> > > >    	pgoff_t index;
> > > >    	int nr_pages;
> > > >    	bool split = false;
> > > > @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > >    	 * (unless fallocate has been used to preallocate beyond EOF).
> > > >    	 */
> > > >    	if (folio_test_large(folio)) {
> > > > -		index = shmem_fallocend(inode,
> > > > -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
> > > > +		index = shmem_fallocend(inode, end_index);
> > > >    		if ((index > folio->index && index < folio_next_index(folio)) ||
> > > >    		    !IS_ENABLED(CONFIG_THP_SWAP))
> > > >    			split = true;
> > > > @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > >    		folio_mark_uptodate(folio);
> > > >    	}
> > > > +	/*
> > > > +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> > > > +	 * traditional writeback behavior and facilitates zeroing on file size
> > > > +	 * changes without having to swap back in.
> > > > +	 */
> > > > +	if (folio_next_index(folio) >= end_index) {
> > > > +		size_t from = offset_in_folio(folio, i_size);
> > > > +
> > > > +		if (index >= end_index) {
> > > > +			folio_zero_segment(folio, 0, folio_size(folio));
> > > > +		} else if (from)
> > > > +			folio_zero_segment(folio, from, folio_size(folio));
> > > > +	}
> > > 
> > > As I mentioned before[1], if a large folio is beyond EOF, it will be split
> > > in shmem_writeout(), and those small folios beyond EOF will be dropped and
> > > freed in __folio_split(). Of course, there's another special case as Hugh
> > > mentioned: when there's a 'fallocend' beyond i_size (e.g., fallocate()), it
> > > will keep the pages allocated beyond EOF after the split. However, your
> > > 'end_index' here does not consider 'fallocend,' so it seems to me that this
> > > portion of the code doesn't actually take effect.
> > > 
> > 
> > Hi Boalin,
> 
> s/Boalin/Baolin :)
> 

Sorry, Baolin! ;)

> > 
> > So I get that split post-eof folios can fall off depending on fallocate
> > status. I'm not sure what you mean by considering fallocend, however.
> > ISTM that fallocend contributes to the boundary where we decide to split
> > and/or preserve, but i_size is what is relevant for zeroing. It's not
> > clear to me if you're suggesting the logic is potentially spurious, or
> > this might not actually be zeroing correctly due to falloc interactions.
> > Can you clarify the concern please? Thanks.
> 
> Sorry for not being clear enough (for my quick response yesterday). After
> thinking more, I want to divide this into 3 cases to clearly explain the
> logic here:
> 

No worries. Thanks for breaking it down. Much easier to discuss this
way.

> 1. Without fallocate(), if a large folio is beyond EOF (i.e. i_size), it
> will be split in shmem_writeout(), and those small folios beyond EOF will be
> dropped and freed in __folio_split(). So, your changes should also have no
> impact, because after the split, ‘folio_next_index(folio)’ is definitely <=
> ‘end_index’. So the logic is correct.
> 

Ack, but we still want to zero any post-eof portion of a small folio
straddling i_size...

> 2. With fallocate(), If a large folio is beyond EOF (i.e. i_size) but
> smaller than 'fallocend', the folio will not be split. So, we should zero
> the post-EOF part. Because 'index' (now representing 'fallocend') is greater
> than 'end_index', you are zeroing the entire large folio, which does not
> seem correct to me.
> 

Unless CONFIG_THP_SWAP is disabled (no idea how likely that is, seems
like an arch thing), in which case it seems we always split (and then
the split path will still use fallocend to determine whether to toss or
preserve).

But otherwise yes, partial zeroing should be the same for the large
folio across EOF case, it just happens to be a larger folio size...

> if (index >= end_index) {
> 	folio_zero_segment(folio, 0, folio_size(folio));
> } else if ...
> 
> I think you should only zero the range from 'from' to 'folio_size(folio)' of
> this large folio in this case. Right?
> 

However index is folio->index here, not fallocend. index is reassigned a
bit further down the function just after the block try_split: lands in:

        index = folio->index;
        nr_pages = folio_nr_pages(folio);

This wasn't introduced by this patch, FWIW, but I suppose we could make
the fallocend block use a local for clarity.

So given that, the logic is effectively if the folio starts at or beyond
the first page size index beyond EOF, zero the whole thing. That seems
pretty straightforward to me, so I'm not clear on why we'd need to
consider whether the folio is large or not at this point.

> 3. With fallocate(), If a large folio is beyond EOF (i.e. i_size) and also
> beyond 'fallocend', the large folio will be split to small folios. If we
> continue attempting to write out these small folios beyond EOF, we need to
> zero the entire mall folios at this point. So, the logic looks correct
> (because 'index' > 'end_index').
> 

Ack..

> Based on the above analysis, I believe the logic should be:
> 
> if (folio_next_index(folio) >= end_index) {
> 	size_t from = offset_in_folio(folio, i_size);
> 
> 	if (!folio_test_large(folio) && index >= end_index)
> 		folio_zero_segment(folio, 0, folio_size(folio));
> 	else if (from)
> 		folio_zero_segment(folio, from, folio_size(folio));
> }
> 
> The logic here is a bit complex, please correct me if I misunderstood you.
> 

Hmm.. so I'm not really sure about the large folio check. Have you
reviewed the next patch, by chance? It occurs to me that I probably
split these two up wrongly. I probably should have split off the
existing !uptodate zeroing into a separate hunk in patch 1 (i.e. as a
non functional change, refactoring patch) and then introduce the
functional change in patch 2. I'll try that for v3.

But in the meantime, this is the logic after patch 2:

	/*
	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
	 * traditional writeback behavior and facilitates zeroing on file size
	 * changes without having to swap back in.
	 */
	if (!folio_test_uptodate(folio) ||
	    folio_next_index(folio) >= end_index) {
		size_t from = offset_in_folio(folio, i_size);

		if (!folio_test_uptodate(folio) || index >= end_index) {
			folio_zero_segment(folio, 0, folio_size(folio));
			flush_dcache_folio(folio);
			folio_mark_uptodate(folio);
		} else if (from)
			folio_zero_segment(folio, from, folio_size(folio));
	}

So factoring out the preexisting uptodate logic, this looks mostly
equivalent to what you posted above with the exception of the large
folio check. I could be wrong, but it kind of sounds like that is maybe
due to confusion over the index value.. hm?

In any event, I'm trying to make this logic as simple and clear as
possible. The idea here is basically that any folio being written out
that is either !uptodate or at least partially beyond EOF needs zeroing.

The split logic earlier in the function simply dictates what folios make
it to this point (to be written out vs. tossed) or not, and otherwise we
don't really have to care about state wrt zeroing post-eof folio ranges
(particularly if any of that splitting logic happens to change in the
future). Let me know if I'm missing something. Thanks again.

Brian


