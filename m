Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD00AF8E48C
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABC56B0088; Thu, 16 Apr 2026 19:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C776B0089; Thu, 16 Apr 2026 19:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A725C6B008A; Thu, 16 Apr 2026 19:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 911D36B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:19:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10393BC22A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:19:13 +0000 (UTC)
X-FDA: 84665986986.24.32B07CD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id D70D0100006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:19:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vzzNXBK/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776381551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbDwlLe42AmGusr0cf84jHOYtQ4ie+L/QWXt3+eZ4dA=;
	b=Pd94HljyrfowC1ZJZ2FwHay9Vea/Azl2u72YhoWVHUnEV+WPy24tUpAObRguhlGjRQkzaP
	7Hvqekdyt4HXlP5cgSCN5Yv7QyqyLU9q3Mrlmgqz738+ftqQ4GMzqVJ3h3CWRg/WXgpTKH
	lGxxGfH/wsioO/b+E8agq30jBx2Q5b8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vzzNXBK/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776381551; a=rsa-sha256;
	cv=none;
	b=2Dt4Vx8lsLVMYEMsuQNQy9Kxc0fNzeJGN8ORuN21VgQ+jLm+jbU/PTpJvPnG/kUmEOF5Fe
	KApqS1xyKOTvuXJJnhnHyowdPe3bOIwfXXjlsm3iXqDgCqslT/OgwxueRLGbCou1AsLQof
	gTZtCTUI7644PMQTfYM4OgiPzyQvjtc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LbDwlLe42AmGusr0cf84jHOYtQ4ie+L/QWXt3+eZ4dA=; b=vzzNXBK/cwBZcUU94k42xjXl3g
	7FP19PdJepuq/KbbrLIer3W1aoNnS27ieGHHSIDysm91QTi6pJZZMwKH6Pmt4xJZj5+LCTK1zTXKR
	o037/feipA4Zv6w/XTYwvmazrNqnmysOS9ut9v5O6OXxGIt3oXBSKChcmReTmeeE5wtJZ1Nh1RFPV
	JelWOysoVml2Q+lRio5rYYEOomUxH1MRir5s6f85VprG68lp+y1MvZo1/0Rshr/My1WTlSLKInsES
	2lDSmAcSqYFKUa8mNSn17KE6NvlQgH+KFhS297dIbBBsGoukp6pWI1Od9jGt+qSLZR7qlD2HCdgri
	OCMY8mzw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDVzH-00000002NYT-0KRk;
	Thu, 16 Apr 2026 23:19:07 +0000
Date: Fri, 17 Apr 2026 00:19:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nikolay Amiantov <ab@fmap.me>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
Message-ID: <aeFuarTL7xBbut0F@casper.infradead.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D70D0100006
X-Stat-Signature: 3nfmxhynhzy8oqbjwmygqm69om4zwonf
X-HE-Tag: 1776381550-7219
X-HE-Meta: U2FsdGVkX1+vsfYVnlij/uhuCeIuNdv3iuXtlTKBz5giHvuBclRj8q2m26xC8wR7MdrQXPaV09mm3EpiBYvb4cu3ImL8fPBpZ7XkMYtlcd+cugzQTGvq47jV0o0EZIP4EFb6WlRDdS9CgeXgwGPYUTetWIYBW1LtYg8UuOKBSzPag6geygu3OY/eHGDnyPklUTBzNrj6UmhZ+Jdfz7m5eP4e964j5yfqpOlrmxo6eOn1XGA7XRedO+XbuQLj8JvsD0cfPPfiVoyAkEmwN2F/I45hu0zYseQkIY8enZ3brsYb9Oq2nrXy+zXzg7y9YZO9od+FmTok7JjVm3qkfkwyWv0SlW7QeQSbzdNoI22Cmetq2qYW1qS/bmrhzdBS3q4xKhCBOPXf8jldW6yt0AF12m2ACOsLSo/2mjkt7H5QVmYXTYTmBymHq1mxvZ/ca/yrmT0pTOAgyro+doAQQS88DKx62/Oo/aSPe5B0IcP9YqF/k5ScG31prsmSdNTKqBoHx/cGNjhBx+2cTmbcQcelvYCCAp6dMHSIB1wqdi88vv5KkdWjUono7+wO14h5fMLhyQcfB24+sLnrWdD5FPx2Q+JKFNKHtqcefRXUHy6GZwsayyyKWyfWdsEVztbopA3+NTgl54K5TIbl8Vl2KW3yf2yByGkPqEc+zZkF9vymG47Q55IsE9HiQ/aReiguEKX/D6p/eX6nRcVrtTUQbuucerZrpJXSan6ie+zsYUEquSfc+aeUaA+rkW7RowxHhNWIeyTV5WNUmUZrKaUdslx9TWKFwD6Ja3Xt7DQyJ5zxoEh9mTbLuOIZ9S5ZogD6lHyrMz7gPCw6+SVPZAtMyC7HbgsEiDe44/KIknjo/lC9ej5OMm4utitrYO/evkH1C0kDJNOfRSFJhP2XjonucXh06Os6stf8LhN7NK8LEaF+ivCdMJUTkdB0EfC+jwDGv7ZtRWiO8sCKi+y7O2vjc6c
 w5Z+dLG5
 Q+4CxUshowMsON22h+SPWmXVlp35u6CN2L0CXX3iUMdJkJjEF2kHSZE/uz6hzX8gOANGmnEKTDy+aW2XyugVWpJIcIlQf6EFb5UZYAkUnSmvNRyJ56Q/Czfi9wS/KUNcJgDpxv25bqcbzScaVUOyFbC207tLTU/nn+odmfjNG3HBFWvDYuakDgkMMggkhfRvrwU/12B6zk2yl3dmmHlHWolNIU8WupVTg2/q/H+dxj6yLQn493D+DdxSd3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:41:37PM +0700, Nikolay Amiantov wrote:
> +++ b/fs/fuse/inode.c
> @@ -334,10 +334,42 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>  	 * extend local i_size without keeping userspace server in sync. So,
>  	 * attr->size coming from server can be stale. We cannot trust it.
>  	 */
> -	if (!(cache_mask & STATX_SIZE))
> -		i_size_write(inode, attr->size);
> +	if (!(cache_mask & STATX_SIZE)) {
> +		if (S_ISREG(inode->i_mode) && attr->size > oldsize) {
> +			struct folio *folio;
> +			pgoff_t index = oldsize >> PAGE_SHIFT;
> +
> +			spin_unlock(&fi->lock);
> +			folio = __filemap_get_folio(inode->i_mapping, index,
> +						    FGP_LOCK | FGP_CREAT,
> +						    mapping_gfp_mask(inode->i_mapping));
> +			if (!IS_ERR(folio)) {
> +				spin_lock(&fi->lock);
> +				if (!test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
> +					folio_clear_uptodate(folio);
> +					i_size_write(inode, attr->size);
> +				}
> +				spin_unlock(&fi->lock);
> +
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				goto size_updated;

Yes, at this point, you've left the folio in an error state.  I'm sure you
didn't mean to do that, but the VFS interprets unlocked && !uptodate as
"an error happened" (there is a minor exception to this involving failed
readahead, but let's set that aside).

What you could do, rather than unlock the folio here is to initiate a
read of the folio and allow the read to unlock the folio.  But I don't
think this is a good idea, I like the idea of invalidating the folio
much better.


