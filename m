Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98418606A322
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X05obpu0
Received: by kanga.kvack.org (Postfix)
	id 836A46B0353; Mon, 19 Oct 2026 15:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7B26B0354; Mon, 19 Oct 2026 15:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDEB6B0355; Mon, 19 Oct 2026 15:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36F4B6B0353
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:35:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9685DC0751
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:35:43 +0000 (UTC)
X-FDA: 85340380566.28.0DE0D25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DA4A20010
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:35:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X05obpu0;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792438541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjyhhMdU/juj15oJVBCmYzPOqIzW+pggsmwSOSjRyIU=;
	b=EKbaTZCZ3U4+v2yW+H7qKOKmFkMAOO9W5836y7h1pskEYUvdufeUf3NZGgL2XuM4S7XF6H
	twjpcraOPxe7upBVOza28D6Yzm3uWJKmCK3c2v6nM1sPwgjWLhrM/xMd+oKB8gMRrDcdKq
	Pu+qtd1Ht5X7Y3IGf2401u5d/qK0oiM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X05obpu0;
	spf=pass (imf13.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792438541;
	b=tgsZsJm/gKMiFAxyIw5uGYvx8fJRwVi0Hw6aSuTiyVOjTAVdGYHwVnZyhI5BHf4mkiIpRo
	lbMnuF2BzVdHpbUd0EbXXqmuh0SBEt3NA82/Tyb3knjjhe8X3UFCxD/nBdsfGLkmq1E6X+
	SCB7gzlbuWnFMBiFz7Qgz6scuDmGaxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792438540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VjyhhMdU/juj15oJVBCmYzPOqIzW+pggsmwSOSjRyIU=;
	b=X05obpu0W4uTb6sGDB+D+2qcbVWUDJih+Xiwx5R+jFH6zRwnrQp+Od6OSCXybXS+wHfgb3
	YRnw1TR3xOlhG8q/IGNxYNunT5FUB/RvTPD/ahxG292vR7Os7Y7DqLUDQCdGnxb+oV1vJy
	x2HSDv99wlJwTz83WfMBCL4cZHeHdzs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-YY74PiJOOlKz-zqKYJbeLA-1; Mon,
 19 Oct 2026 19:35:34 +0000
X-MC-Unique: YY74PiJOOlKz-zqKYJbeLA-1
X-Mimecast-MFC-AGG-ID: YY74PiJOOlKz-zqKYJbeLA_1792438533
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B830C1955EA7;
	Mon, 19 Oct 2026 19:35:31 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D367D767;
	Mon, 19 Oct 2026 19:35:28 +0000 (UTC)
Date: Mon, 19 Oct 2026 15:35:26 -0400
From: Brian Foster <bfoster@redhat.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of
 pagecache_isize_extended()
Message-ID: <atZw_gtMIIKXgc1q@bfoster>
References: <20261016222721.791785-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261016222721.791785-1-nickolai@csail.mit.edu>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: TrnyjypHgJWyu6oSjp70BPRVBIAgwXqkrq0Vj8kFGHs_1792438533
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DA4A20010
X-Stat-Signature: we3g4ruqca3xx9d55qdisd46k34tfwzu
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792438541-114023
X-HE-Meta: U2FsdGVkX1+BLB30HBoSBBmD0q6LiauhC4JNfnq2ws2qawsDUwQG6vdsHTuIwRT0YuslrYGrhRErTVQCKpGyNI+ZkINPlIS0DSL1V9gFOf7bWiXcKMN1a7dLSx7r+l4YOdVc39t00dh9MJ7iHXk3rO0fPKI6pdytc6RD5GWl75QLEgPONiiOBGe5PKhDzkkNT1nYwiJjCzhrabK1VRh5W0JMtK/xuCSJhmGQEIhmMZDbyMgZ4hdU1WzNTFTbZTWMHAsKWd34/0a+8uqJ1Cy86IVvoDH9bRtLDF8BcOYRoswFNjiIQT4rtajANU4BW+ege7nAr5Pt3KmPwHOuA/vwcsws317LNu4EG1RjBah2NQY7Sc7O1T1OJhwbN/hS2EKvg3xwqhXhXZFETIZLNQwuiDSKhyMGmtX3kvM8bYqjxtkGaobTnB+DzTQPLZ/z/QhKCFtMouWsD6zZSVqgackgF3jN+ZjfM87fp0rEB2qN8+YLLQCwKWHug0oPNvGtS5nLvTd2s0QgY697aoCpJhFo+hsHFVPfjj8No9Q2nBChqAmT6RQY2JpOM7ItD6AlEN9sj2wssk/ER+GSM9/lvwXVtNGP982l0JdmftbQGPQHvCtpoF3kegXJ6y6FufzbNK2FpVycL6163vCI/8UQjfcPYS15uiwswgWdKnEty025Fh+vsQYKK89uE8f8Vl/5Uy/0qEqXkNZ+seKUhoZDDtglygseb4hPy8GlI5xNdERWmOmPZp3f9wX1PrbsP29sJT+8I/jYHQLPlu2Xnqvk40wYL7IUmNbcmez5x+q1aupGbecCf6M0NcVKJ+PzDD0m54LXfifqDh0Jn4/J/1sVWRnKLaeZhYoviCWGfUqQ99B8HpsgKOwgO1Vr1e6thZXOkGMNj8l+uyqq5QnF6NzLhnT3ASK6rf2c7xTe8lWWa+6K2aeQl5eKg/q3SoyWhZtNOvECmax5EoNdgXMNMhQ6PFd
 ZPDg2tY1
 WqwlV0iPQh6zFTrgtq0M5SqQicgrBD4AVCuVaEqjXShe29ufQdvBlbVKkHpG8mBpZkWjxordjO8+rp5GuCGPriu2S0d6NoQPyNkYiNUouTOkyRacPRfJXj7gF0m3q94Ekh7iNz2wxCbB0wEKv3Um9wG5n7zv6jxq0kAuw/oFUpPMminHjVtybY2lVHov3TdH9VsXTnubzV0ayV8jlgAHkwCbMUab2J6BBNOgizZf9dv2SSgvXbmKhSkptwZ0Adoj6TVUOD2uQ3mHYT36y1VJY9WQTFOXUv/2Tu8DNJoRxobaMpCLAl7EtiENeFtytyN0c5SEJrRX84DV+Pyqb8M2sw1NUtidvkgYqBp6Jsq3OpA5qe2CU5nLjgZWHLlQRUtARVBY2WTzEifHD7ZbTiVeQ2BA/trJnbswjoD5N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 06:27:21PM -0400, Nickolai Zeldovich wrote:
> A process that extends a file by 4 GiB or more past a dirty folio, on a
> file system whose block size is smaller than the page size (ext4 with 1k
> blocks), reads back the bytes it wrote through a shared mapping beyond
> the old end of file instead of zeroes, and a later write into that block
> carries them to the disk. With the example of commit 52aecaee1c26 ("mm:
> zero range of eof folio exposed by inode size extension") and the
> truncate taken 4 GiB further (pwrite 2k at 0, mmap the first page and
> write 'X' over [2k, 4k), truncate(2) to 4 GiB + 2k), the read of
> [2k, 4k) returns the 2048 'X' bytes, and a pwrite of 16 bytes at 3k
> followed by fsync() and a remount leaves 1008 'X' bytes on the disk in
> [3k+16, 4k). No privilege is needed, and every size extension of 4 GiB
> or more reaches it: truncate(2)/ftruncate(2) through truncate_setsize(),
> writes beyond the end of file through generic_write_end(), ext4, iomap,
> btrfs, exfat, ntfs, afs and orangefs. Affected since v6.13.
> 
> pagecache_isize_extended() zeroes the part of the dirty folio straddling
> the old end of file that the size extension exposes, from the old size
> to the new size or the end of the folio, whichever comes first:
> 
> 	end = min_t(unsigned int, to - folio_pos(folio), folio_size(folio));
> 
> min_t() converts both operands to unsigned int before comparing, so the
> loff_t difference to - folio_pos(folio) is reduced modulo 2^32 first.
> When the file grows by 4 GiB or more past the folio, end is that residue
> instead of folio_size(folio): below offset nothing is zeroed, above it
> only [offset, end) is. The bytes beyond the old end of file stay in the
> dirty folio and, now inside i_size, are file data.
> 
> Compare in loff_t; the result is at most folio_size(folio) and fits end.
> 
> Found while formally verifying pagecache_isize_extended() against the
> kernel binary.
> 
> Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
> 
...
>  mm/truncate.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..5c444812f37a 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
>  		unsigned int offset, end;
>  
>  		offset = from - folio_pos(folio);
> -		end = min_t(unsigned int, to - folio_pos(folio),
> -			    folio_size(folio));
> +		end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));

Good catch...

folio_size() returns size_t and folio_zero_segment() expects size_t for
the offset params. Perhaps we should that instead of loff_t?

Brian

>  		folio_zero_segment(folio, offset, end);
>  	}
>  
> 
> base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
> -- 
> 2.53.0
> 
> 


