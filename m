Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AE1D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 12:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00826B0005; Sat,  6 Dec 2025 07:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1356B0006; Sat,  6 Dec 2025 07:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6C16B0007; Sat,  6 Dec 2025 07:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86D826B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:52:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27F60133D47
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:52:46 +0000 (UTC)
X-FDA: 84189035532.06.9400CE5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51D56A000D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:52:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDTttdSV;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765025564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mdIdRGmGgmF50KJMgs3fRDNqKfdLumTX4KIFEo0UUo=;
	b=PT6QLlNCyDX3qAh/2zE+P520MXPPEO8PpBy9H1/zuPIVRqJnyGSiinRZ6vMqH/G77nu44o
	2yzJ+C+Q1iRt3MTK2HO9YKpry63P+MpmAnohDxTlBj2LSW/QKxGbL9VGBVVsTEXPjQAUeq
	7+qXCnZHArf2y1noCtNm1KYa8Bztpkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765025564; a=rsa-sha256;
	cv=none;
	b=sEl+gZ4iJ1pdguHPfwtV5DHr4U/W1bw6m0rKA9F7igGK6WxCT+A1HXDv9i9QAnQ9F3VUnH
	J/aFKPyzJmeRBTxEw83b3bOX8PYSxnXuAeATIoswTso6csAFabR6TOzQ9Ch51XfvB0/eMG
	Mb47JXFUN/EU5J8wWnAOOUzM1PeXDMw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VDTttdSV;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=+mdIdRGmGgmF50KJMgs3fRDNqKfdLumTX4KIFEo0UUo=; b=VDTttdSVbSgb+REcQzD5Fsh15A
	qhRaA3qvutQzHNRVsH8tbtpbbcOk77jrTKWBpAAamzI5HuQGlwzRipfwomCjla+EKCjMoQV3YV/yH
	5ZBa/jk9LXGBQ21Fgne9d+RvbEkG7r8hCkdG6dRAATCgnvgOuvyKtUqXLwbYK2ny+NDNodbgAcB8L
	QxsMEOlRqsX7JLRNPW6sBv3A/xzpfzDea+8aWgPE+kdHKEYUdyT18+AgozL7aPL2e+SGU+Bj00hky
	2zOFUXrmLMbO38v6F1DYHQ7CIxgWPNzLpetlgCR1PutN79QA65PzY5kdwcaGsI8QKpVIM3+e9+rcV
	Yg45ITrw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRrm9-00000007BhE-1GZr;
	Sat, 06 Dec 2025 12:52:37 +0000
Date: Sat, 6 Dec 2025 12:52:37 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: enforce the immutable flag on open files
Message-ID: <aTQnFQIc3ylSci1u@casper.infradead.org>
References: <znhu3eyffewvvhleewehuvod2wrf4tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <znhu3eyffewvvhleewehuvod2wrf4tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 51D56A000D
X-Stat-Signature: m6xnp5pgkq4jmcbtf41j8b98761ibhgz
X-Rspam-User: 
X-HE-Tag: 1765025563-563079
X-HE-Meta: U2FsdGVkX19TcoqHmJuzgIqFVdYCtS4vvBlf7XbjUzPZ6hZKQziv4CaiFD8B0kbaD3B3HVgb8eaOImSuX54OACzV1kyjVAPsbYQVTe0690B/SN/Npdv8DjSijsGgnzBV1kGyhDWD6FzTeuPYp0LudHJwwwpll4GeRAy2OvnVGlCIkoYLzpFoZaPQQJYQ3OyKqGvCBTwcMrs6mM/Oj1EMForJE1At+DXBMf3Ww8FB84qXkWvlO6gbH0q4bsUub4GQGyPJDH+DrLwj68ZSiRXhqto7Vhruyfyih7oeG6f+0QbJXohxU06buQYig8G3DNqMxYbs0qDEY1SsYwM6wvQLpXstN29twmz/ZRGskmNHQQ4sKdbRXXwb16Gj79MxbjUr3pZtQmbBHeqgvOaBtuJwcl4SuIIzjKj8xbASZoPyPGlLGEYas9glFcZ7PWh0fxGTlThlFz9Uo/4yYUTIZcIjkDZ+cF8ztbLWrjoMetWU8aATDyT2i+XERqU5/ur9VgCmp8Uu9x99okxHXxw0ikI9bW2w5ORhz9b/+cBNDuJCp5XFE9WyjXCkmKvU+Tz2c9OW3ss0pvdFpqGC7ZetMODYN6vWzV9s54Pvl+MBe2ZelHvu3aannlNVveg82zaTPtHMAfApNrmRVeqfogbVs9iuixXsKYzmT98GVR7PCnaqCA+GP8a1RS6c0wKo42BeYK+XzqZ3MpiymufBKKtm6ksvNiOvN/Lqa16YNTIHxUQbfjTJV5AN0dsj8yY448CIjLZRMprzIhr3WBZt6BqjsCDzM9+LVvRX7qP2VvDMPIKR0C9cmLrzMpx7dfSbCWOtrgaCYYkyI8hghnj3xVMwAyEp0pVEdq+hCbg8G7W/CjO5Ie/ex5+5vowdm6UgD05J2CuovwuP/yhg41ptuHMXofMxoBg4e1pSaDatzC1NBA3mKezVQvi6umQWfL4dYyEGsT/UnmJOeJat86uuxgnl15K
 eIkKdmgU
 cPFaQGW0anQ0yXFziN9jXr9wlJm+3wLSBYevFjOoATUunvbHFmtH3Sw0pcxty1WXPxRGvQJ3XtSXNSuvfUTQKHaiV1yFQkl0GCziDWYyBfjmitgzUMZ4KinYy5GnBJkwSFl7hyalVBa7r0gS8YNZ55fIOLlwflkueOLuCPjm1L9GgXf+PiWVm1zP+RZ2RnJqSvLcfPr/rwM4GIYoAnf1tBnfjTUGqYJqc3FYXho/jdx0T/F9ud+TJJSpmM4C1FqNMrmwlg09zTR+QVxhmt6P0dGNprA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 01:03:35PM +0100, Ahelenia Ziemiańska wrote:
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..0b0d5cfbcd44 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3945,12 +3945,18 @@ EXPORT_SYMBOL(filemap_map_pages);
>  
>  vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
>  {
> -	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	struct file *file = vmf->vma->vm_file;
> +	struct address_space *mapping = file->f_mapping;
>  	struct folio *folio = page_folio(vmf->page);
>  	vm_fault_t ret = VM_FAULT_LOCKED;
>  
> +	if (unlikely(IS_IMMUTABLE(file_inode(file)))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out;

I don't believe you tested this code path.  It contains a rather obvious
bug.

> +	}
> +
>  	sb_start_pagefault(mapping->host->i_sb);
> -	file_update_time(vmf->vma->vm_file);
> +	file_update_time(file);
>  	folio_lock(folio);
>  	if (folio->mapping != mapping) {
>  		folio_unlock(folio);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d578d8e765d7..5d3fbf4efb3d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1294,6 +1294,14 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  	bool update_mtime = false;
>  	bool update_ctime = true;
>  
> +	if (unlikely(IS_IMMUTABLE(inode)))
> +		return -EPERM;
> +
> +	if (unlikely(IS_APPEND(inode) &&
> +		     (attr->ia_valid & (ATTR_MODE | ATTR_UID |
> +					ATTR_GID | ATTR_TIMES_SET))))
> +		return -EPERM;
> +
>  	error = setattr_prepare(idmap, dentry, attr);
>  	if (error)
>  		return error;
> @@ -3475,6 +3483,10 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ret = generic_write_checks(iocb, from);
>  	if (ret <= 0)
>  		goto unlock;
> +	if (unlikely(IS_IMMUTABLE(inode))) {
> +		ret = -EPERM;
> +		goto unlock;
> +	}
>  	ret = file_remove_privs(file);
>  	if (ret)
>  		goto unlock;
> -- 
> 2.39.5



