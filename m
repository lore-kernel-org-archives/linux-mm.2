Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F84CF8862
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E52F6B008C; Thu, 20 Nov 2025 09:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCDE6B0092; Thu, 20 Nov 2025 09:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3016B0095; Thu, 20 Nov 2025 09:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C03A6B008C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:21:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF7CD138337
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:21:55 +0000 (UTC)
X-FDA: 84131199390.03.DBE892B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA604C000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:21:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZUUuqCM;
	spf=pass (imf22.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763648513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDhKBCTzj6AqeH9HAzTjfweiVBgi4fyQwtPfs4U1LG8=;
	b=4UPrr0eF1ujxqcRfjjM8SlvQ8Xo4x2cPtEEYNgUTW9QzObf2ekA1LJ2ARqTPmzRzw1Obpw
	hOhWGxCtXjEYtTxOolQB0HZ4XqLmUJ5mkCYj+BAWI3rtIAO9NkUjRICOlpK51vmgYZRRXE
	tzOSoAVTt3B+L8JqNUYYiLw9QvKuePI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZUUuqCM;
	spf=pass (imf22.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763648513; a=rsa-sha256;
	cv=none;
	b=oAoXquKvZgAltFIfx11sttU8clpZsxDWcOpzLsNVUsU0VpwQ8u22SCkTAtHX7RSyNm+Mc/
	3jx/nEblfQdHVbtOuhm86xKq3c4y3HqwzuIFHFZPZQ33Vlx1flFX8Nj0k1jRkCz2UCAEk4
	2Y0c7fV3kcsZmKoyrJu4XT0ykdV9/SM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763648513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDhKBCTzj6AqeH9HAzTjfweiVBgi4fyQwtPfs4U1LG8=;
	b=HZUUuqCMAagI9iC9dLuo1134FuWtYkUV2zS3h/x9085VG88IVvmJV93CfbKjYnrwqAj8ef
	oaQIXkmsPpe8iZ1DTILjjhjiPWKk6+yr8N766DU1uLTa9vMK1bAt5LVGbIoSwlr9VYHRT5
	JLPCy++iovkTEZ4m2o6oWZwyP9XT4JU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-WwfXnGa3Pp6M4F2JDMHYng-1; Thu,
 20 Nov 2025 09:21:49 -0500
X-MC-Unique: WwfXnGa3Pp6M4F2JDMHYng-1
X-Mimecast-MFC-AGG-ID: WwfXnGa3Pp6M4F2JDMHYng_1763648508
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF3BA1954B06;
	Thu, 20 Nov 2025 14:21:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14DF93001E83;
	Thu, 20 Nov 2025 14:21:47 +0000 (UTC)
Date: Thu, 20 Nov 2025 09:21:45 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 3/3] tmpfs: zero post-eof ranges on file extension
Message-ID: <aR8j-XoeA9VpcuWD@bfoster>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-4-bfoster@redhat.com>
 <0a24875d-4f42-4f2f-b1e3-9c3187052e18@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <0a24875d-4f42-4f2f-b1e3-9c3187052e18@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3cdYX2fI1nzTA_8wm3qyH1XWPl-pb3t6ejYSYo_fuWI_1763648508
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA604C000D
X-Stat-Signature: zxqgtdkwxr913yd7f31gt351kwo6xnd8
X-Rspam-User: 
X-HE-Tag: 1763648513-553795
X-HE-Meta: U2FsdGVkX1+0KWP2iP/32WX8MZUvdxqifGeFPv0Ov5bVItCtwViyhK9x1zQ3RyyXdcZjSi4GwhPeXZA2zvEpBP31xvEg+EFGcgbugYn7BJJi5Q3nd6ubzyPaSPHMCtAw/SbEkHh32EzF98ItBtVLD6o22MU8wbM3iE7x5WyrNI742nIo5VqUh3JwTdE1ZfaQvU898l5b1gjA8mKhFwCMI3LQOWXwoEli6bHqAUlQeW6l/Tv+9HUFg0CQtY9/PyjYkWvSAzcVYf1VVmgqR3R7lnVTnauaa269gjjBHqbP7YaPsr/pb8U1PByyKpZXB97JhB5/xfnO5JvnfeTGfeavUdlf/ngz9u2AJZoaqdUHl9sNA1bdXkWarwqKC17PEx9Wirh8MNSwjlt3j54rC5yzD/4m3DtyCuYR4deC35ukDFhLZbHj2CrAQ4R++cI17FsTuBVTZDqdhY38T/IwtfiUAIBeEI+Eln0OYtf5oPkWT5XuRwzB/urmC1aTHj/4j9ZhEWqCToQ3SxwVeVt0HZLjmsaijdwLx30gn3fwMA3iQpAzHWjDW5LmWNmCUiMnWXDF5UUMrkqBGb1BVHhQV34WI3soh8wYZjoc0H0oQOoQM07a8NVMX1DcA7jPaEi9BcYPtW6AP4SJ5X1rMEZQ/hv8V1oDRClc5Hicl3/R9F2LeWvZ3mvbWj2R32675m1c/mr++bWb5ZvfFv2saB7FS0QOwIf19lt2kpV/r2NYEbtwp6e0O+m963pm4MR9hCTvqPWIpxscyp1tpnfmMZ3mOe8f6IgZIxzEs34Jbe585q4jZa6xpgVe5HxMdQqMGqJjbbH85LWf8WpQ8jmAmGjUR5Ua4+qZSMLUdPi4f2FBNZbHgfLUsKkzZ9V9ao5e+1f84lu0lq5yBUh5lurCNXZ+RdBg6M2UIypthHMdszN3MfbCcECp68QduUopqYnu54NXAazWYy8vuXxhWBYr3dIzDWA
 gpCsmnLS
 qDKwgkfa2aq4lmMnRDFR9H9GdRqVuhY0Oo6pJDfcwuJX7KIIo+0+n+WyOq4vGIkfmj3bUdb7mjNKnTFbwN0EU2fU0rjB+s3Q+ghHBQp2nKOF3m9iyJtnl4EQJLhs5X2mAgVD/+vDiSZ0CQSH6h+qHD+3hzWc2JtzbE/ZWK/5yqEKcJrX5i5humQ57F8vocKFyUh6b+P7LgMwcu1DYZ8WZ0yeJItlR0TSoWGosiAOyGhk2HeH5im4IqKc55MmxVKs9d89H4d4fZriu1M3UD24InaycvHu1WEI54Ralp1epR7KkqgO2rnOi+cZPyhC9VoYy34rb35rJ47TwyxlQ1SXs8o8etJBgCwtrRVNQdO6/J0mwAG97PXonjQEkZolV9C91notrhxyrS4vOCtxxVUIi6vi3SeHE8A18dTE6wNou/imYcpIMjeCPKLz7WISbklml+3dEIJra921UjUY849WQY/m8RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 01:57:48PM +0800, Baolin Wang wrote:
> 
> 
> On 2025/11/13 00:25, Brian Foster wrote:
> > POSIX requires that "If the file size is increased, the extended area
> > shall appear as if it were zero-filled". It is possible to use mmap to
> > write past EOF and that data will become visible instead of zeroes. This
> > behavior is reproduced by fstests test generic/363.
> > 
> > Most traditional filesystems zero any post-eof portion of a folio at
> > writeback time or when the file size is extended by truncate or
> > extending writes. This ensures that the previously post-eof range of the
> > folio is zeroed before it is exposed to the file.
> > 
> > The tmpfs writeout path has been updated to zero post-eof folio
> > ranges similar to traditional writeback. This ensures post-eof
> > ranges are zeroed "on disk" and allows size extension zeroing to
> > skip over swap entries as they are already appropriately zeroed.
> > 
> > To that end, introduce a new zeroing helper for proper zeroing on
> > file extending operations. This looks up resident folios between the
> > original and new eof and for those that are uptodate, zeroes them
> > before the associated ranges are exposed to the file. This preserves
> > POSIX semantics and allows generic/363 to pass on tmpfs.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   mm/shmem.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 79 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 7925ced8a05d..a4aceb474377 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1101,6 +1101,78 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
> >   	return folio;
> >   }
> > +/*
> > + * Zero a post-EOF range about to be exposed by size extension. Zero from the
> > + * current i_size through lend, the latter of which typically refers to the
> > + * start offset of an extending operation. Skip swap entries because associated
> > + * folios were zeroed at swapout time.
> > + */
> > +static void shmem_zero_eof(struct inode *inode, loff_t lend)
> > +{
> > +	struct address_space *mapping = inode->i_mapping;
> > +	loff_t lstart = i_size_read(inode);
> > +	pgoff_t index = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	pgoff_t end = lend >> PAGE_SHIFT;
> > +	struct folio_batch fbatch;
> > +	struct folio *folio;
> > +	int i;
> > +	bool same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
> > +
> > +	folio = filemap_lock_folio(mapping, lstart >> PAGE_SHIFT);
> > +	if (!IS_ERR(folio)) {
> > +		same_folio = lend < folio_next_pos(folio);
> > +		index = folio_next_index(folio);
> > +
> > +		if (folio_test_uptodate(folio)) {
> > +			size_t from = offset_in_folio(folio, lstart);
> > +			size_t len = min_t(loff_t, folio_size(folio) - from,
> > +					   lend - lstart);
> > +
> > +			folio_zero_range(folio, from, len);
> > +		}
> > +
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +	}
> > +
> > +	if (!same_folio) {
> > +		folio = filemap_lock_folio(mapping, lend >> PAGE_SHIFT);
> > +		if (!IS_ERR(folio)) {
> > +			end = folio->index;
> > +
> > +			if (folio_test_uptodate(folio)) {
> > +				size_t len = lend - folio_pos(folio);
> > +				folio_zero_range(folio, 0, len);
> 
> I am curious why not zero the whole folio? Since the folio corresponding to
> the 'lend' is also beyond EOF, no? Otherwise look good to me.
> 

In practice I suspect we could do something like that since the entire
range is presumed beyond EOF, but I suppose it's just semantics. The end
offset will typically correspond to something like the start of a write,
so that would be unnecessary zeroing in some cases.

I don't love the prospect of having a function with a byte granular end
offset that doesn't really honor the offset in the way one would expect.
I suspect that means I'd have to change this to have a pgoff end index
or something to make the zeroing granularity more clear, and ultimately
I'm not really sure that helps anything functionally.

So really I'd say this is mainly just because this is modeled after
typical fs zeroing behavior for these sorts of size extension
situations. It is a context specific implementation of course, but the
interface/behavior seemed the most natural and consistent to me.

Thanks again for the feedback on these patches..

Brian

> > +			}
> > +
> > +			folio_unlock(folio);
> > +			folio_put(folio);
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Zero uptodate folios fully within the target range. Uptodate folios
> > +	 * beyond EOF are generally unexpected, but can exist if a larger
> > +	 * falloc'd and uptodate EOF folio is split.
> > +	 */
> > +	folio_batch_init(&fbatch);
> > +	while (index < end) {
> > +		if (!filemap_get_folios(mapping, &index, end - 1, &fbatch))
> > +			break;
> > +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> > +			folio = fbatch.folios[i];
> > +
> > +			folio_lock(folio);
> > +			if (folio_test_uptodate(folio) &&
> > +			    folio->mapping == mapping) {
> > +				folio_zero_segment(folio, 0, folio_size(folio));
> > +			}
> > +			folio_unlock(folio);
> > +		}
> > +		folio_batch_release(&fbatch);
> > +	}
> > +}
> > +
> >   /*
> >    * Remove range of pages and swap entries from page cache, and free them.
> >    * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
> > @@ -1331,6 +1403,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
> >   					oldsize, newsize);
> >   			if (error)
> >   				return error;
> > +			if (newsize > oldsize)
> > +				shmem_zero_eof(inode, newsize);
> >   			i_size_write(inode, newsize);
> >   			update_mtime = true;
> >   		} else {
> > @@ -3512,6 +3586,8 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >   	ret = file_update_time(file);
> >   	if (ret)
> >   		goto unlock;
> > +	if (iocb->ki_pos > i_size_read(inode))
> > +		shmem_zero_eof(inode, iocb->ki_pos);
> >   	ret = generic_perform_write(iocb, from);
> >   unlock:
> >   	inode_unlock(inode);
> > @@ -3844,8 +3920,10 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
> >   		cond_resched();
> >   	}
> > -	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
> > +	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size) {
> > +		shmem_zero_eof(inode, offset + len);
> >   		i_size_write(inode, offset + len);
> > +	}
> >   undone:
> >   	spin_lock(&inode->i_lock);
> >   	inode->i_private = NULL;
> 


