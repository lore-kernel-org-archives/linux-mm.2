Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883AC606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8
Received: by kanga.kvack.org (Postfix)
	id 96E7F6B05B0; Mon, 26 Oct 2026 17:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8D66B05B1; Mon, 26 Oct 2026 17:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B676B05B2; Mon, 26 Oct 2026 17:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA256B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:49:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF93D16083E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:49:18 +0000 (UTC)
X-FDA: 85366118796.13.2130E1C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52EB7A0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:49:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7Cedkm8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7Cedkm8;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=w/0xDQmEIjh0RjJ+oC/jhtZelFH5dXcq+XcTq2tLDOGTQdK1BdgkDIUx2ZsHWWTd7MTX0y
	esaWElN6fQUiHX55ZwI7qhllbdfmwDCqJBNcNcm5cKrfy8s2yaEPmzhWFYRUg8OWOtfvJm
	4+QUUJVkdQZ6+cCO45jDmqaEBbcd10Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051356;
	b=q+nD/qw8/uvD8HC5KTqqHXZRS2o0xYm84y7aM8jbimphcYriUDh76taeXldw1WcCrrbsbk
	KWljmCQvI1WSSK9IdZHdd9dKFh2evF/vmzQPMfBKFCvCzRbH/eo7DBi8HDxBX0YUZcWXa+
	ul7SspustuFgkr7R8UH7haZipls88+w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7Cedkm8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7Cedkm8;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F2381F395;
	Mon, 26 Oct 2026 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793051354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=eCinZKry9BdBG2Tuub+XI9hK94YcOOBUoAy5NiqDtrxCIfhiDCpKBYosrzHbGoQPdqVcVF
	/qUyW0flh+XLgtYLcWFiEdoa2BT99gfRo3PcAl738bcEs9klDFkXP6z2X4Nbo/EaPFu13F
	/G1VPtqe+OHGGNMTOwe+xOIuqM2+o+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793051354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=c7Cedkm86DrLmBhaRecl63q8E2NQXs91lGx1midza1J1rGGNKflLD0QKxcMpGk83nRyC0X
	IUBu035ZLkrDe3DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793051354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=eCinZKry9BdBG2Tuub+XI9hK94YcOOBUoAy5NiqDtrxCIfhiDCpKBYosrzHbGoQPdqVcVF
	/qUyW0flh+XLgtYLcWFiEdoa2BT99gfRo3PcAl738bcEs9klDFkXP6z2X4Nbo/EaPFu13F
	/G1VPtqe+OHGGNMTOwe+xOIuqM2+o+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793051354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=c7Cedkm86DrLmBhaRecl63q8E2NQXs91lGx1midza1J1rGGNKflLD0QKxcMpGk83nRyC0X
	IUBu035ZLkrDe3DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D9BA13408;
	Mon, 26 Oct 2026 21:49:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eRk0CtrK32pSBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 21:49:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CCA06A1419; Mon, 26 Oct 2026 22:49:09 +0100 (CET)
Date: Mon, 26 Oct 2026 22:49:09 +0100
From: Jan Kara <jack@suse.cz>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iov_iter: take an unsigned long segment count in
 import_iovec()
Message-ID: <yb2p27fkrqamzmzfwqbqjwsxhw7cdlpgjzc26eqtimw2puhxrz@mhrjegarlm5a>
References: <20261026180619.4147910-1-parri.andrea@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026180619.4147910-1-parri.andrea@gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52EB7A0003
X-Stat-Signature: kwttz8oye1k6qqhbdzxyt7m5zrsqepx9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793051356-654506
X-HE-Meta: U2FsdGVkX1+GQFHjGL4t7C/LwSGOESoAB3fHF/Jidm/hhtT3VZpl5A7MFTEGmRqG1QZwyUxnF5FSMVWYoscZNFGwmaIIOjTJ79h3cJ2DvfF3WVx10ZV/7exsh8tQNaXp/pBw9p3JbYk5qQw1uHZS26ufAlUkkcATVIR0MwFtCrZfwgUXPdMQ4Esho6JD1TW8pbpxCMZgUQozghObZkg+epDTm2M5J8gp6pLxNXAhy09+gaE4FRQjfpZ4ohfFlBISRNi7NfBfiLVJ6z2HxiDe9Q0NMRVMvojHzSS8y4gqWsZ+kRep4dSIhPjwyMW+W7UiWx7ZisxR7MUruudsPdLlhOPuBK9zZeF2coR8qxv/GpqIhp1Dd3HMkBIuXEhQmdSr5AZ5cM/RV3BOlCM31luSfu+MAkXnNf0/Xu3Gv8FHOLE78sx/NFPKv+2F7hRAbHvdLq74CYNmGA/fBDBIjs2hja3mNj0Gz0k+B3ixKMtOg75pVD/6TaueagWNIs3u00XFbqUkIEud3Gl3lO0kvBZbNhGc/eBM6aGMfXheavGce/WW6l/xM7gH+rSEUthu8RM2d8ICZOv+uVwZKHjSLj90VOfg/KHiyD+NDbRV4xiv62sw4mr5vpErQCF+1FmU34Q32uIBtIrYVo3Gt7di5CilB79w7dtFoiambhZ5s4lKmsZ7ly9a+rSf/hScbKkSuDCTxDuxrd2dNbnshuiENRl8oTiVheLfdHCnEEmKQmFk9XlMXAMOVTX816iXopGv2LOBrSaPkrdY15JZBET8MPQwF1p4lDrrUvdD2SA9DPff6PxrXn3SS6VkHAJL+X9J8FKVPWLB3Z6mCnjpzQXCLDKJ54PkXWcwv7HDd4rzkIYkpP2t34VLxPUNn2iR5wr6EktMbc71GJKyIj0EiU/XPtkvpd9FvGtoZeXOXGUySFquUpjqSPt6AJU2xdp7Xfz3lKYyUGyFFYhuRI/f0OkARcw
 libPqAiJ
 YqmFev703ZaC3jNXGzZ+6HjDS8b3EvMoQzqB/LV8cA5BioGWdF+ksP4Ih/aF0KeOH3B4MbezFPiC8ttq/WRvvefq5W8J+p24Qvb3Bk0hf3ms+iK1dGFjs522+pAewZ0TTkxpv8RwsNjHYTPaywqq109FYPoYD+jcE/xKSevOPF9Ugc4wSvaC9EXksM+8cK2uW0c4UqCV/NQVLqC9kQmdFd07amaSnJVNO7DWRJpPik1/ClKC2QJb6RrlCKRpEzh4h1leEUYGUNLE4P53EKh92IW+RJX453kBD3qhN5Gyw5Hnlf3ANHeAtCkm0xet828HF72p8YREaL5/IOst7fiS7Yy9Rq8QOOOm9Paw65UjJhJylOMgX0sTXPMejnuVGOwzT03DZx++1XC9ZOBEaqZygXrolSxKbx24idOWZPO2fAS3EpPBHDoc1NvkhvVMq/gr/iiXWukkKttNHXdUek9LVRwc1XgYgOJqTBvZiR4uyo/vzXXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 19:06:18, Andrea Parri wrote:
> readv(), writev() and their positional variants, process_vm_readv(),
> process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
> the btrfs encoded I/O ioctls all take a full-width segment count, and
> all of them hand it to import_iovec() or __import_iovec().  Those take
> an unsigned int count, so on 64-bit kernels the upper 32 bits are
> dropped before iovec_from_user() checks the count against UIO_MAXIOV.
> 
> A count of 0x100000001 is therefore imported as one segment: writev()
> on a pipe writes a byte and readv() reads it back, instead of both
> failing with EINVAL.  A count of 0x100000000 returns 0 as an empty
> vector.
> 
> import_iovec() was added with an unsigned int count, but the helper it
> wrapped, rw_copy_check_uvector(), took an unsigned long, as does
> iovec_from_user() today.  Until v4.1, readv(), writev(), preadv(),
> pwritev(), process_vm_readv(), process_vm_writev() and vectored aio
> therefore failed these counts with EINVAL, as did vmsplice() until
> v4.18.
> 
> Widen nr_segs in both import helpers so the UIO_MAXIOV check sees the
> count the caller passed.  Callers with 32-bit counts are unaffected.
> 
> AI assistance was used to find the bug, develop the fix, and run the
> reproducers.
> 
> Fixes: bc917be81059 ("saner iov_iter initialization primitives")
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Tested on x86_64 with virtme-ng, base 734bef548a96e vs patched:
> readv, writev, preadv, pwritev, preadv2, pwritev2, vectored aio,
> process_madvise, process_vm_readv, process_vm_writev and vmsplice with
> counts 0, 1, 1024, 1025, UINT_MAX, 2^32, 2^32+1, 2^32+1024, 2^32+1025
> and ULONG_MAX (LONG_MAX for aio).  The base kernel accepts 2^32,
> 2^32+1 and 2^32+1024 on every path; the patched kernel rejects every
> count above 1024 with EINVAL.  Also built every caller with
> allmodconfig W=1, and lib/iov_iter.o and the readv, vmsplice and
> process_vm callers with i386 defconfig W=1.
> 
> Reproducer (64-bit userspace):
>   cc -Wall -Wextra -O2 repro.c -o repro
>   ./repro
> 
> // SPDX-License-Identifier: GPL-2.0-only
> #define _GNU_SOURCE
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/uio.h>
> #include <unistd.h>
> 
> int main(void)
> {
> 	char source = 'x', received = '-';
> 	struct iovec wiov = { .iov_base = &source, .iov_len = 1 };
> 	struct iovec riov = { .iov_base = &received, .iov_len = 1 };
> 	const unsigned long count = (1UL << 32) + 1;
> 	long wret, rret;
> 	int pipefd[2], werr;
> 
> 	if (pipe(pipefd)) {
> 		perror("pipe");
> 		return EXIT_FAILURE;
> 	}
> 	errno = 0;
> 	wret = syscall(SYS_writev, pipefd[1], &wiov, count);
> 	werr = errno;
> 	close(pipefd[1]);
> 	errno = 0;
> 	rret = syscall(SYS_readv, pipefd[0], &riov, count);
> 	printf("writev=%ld (%s) readv=%ld (%s) byte=%c\n",
> 	       wret, strerror(werr), rret, strerror(errno), received);
> 	close(pipefd[0]);
> 	return EXIT_SUCCESS;
> }
> 
>  include/linux/uio.h | 8 ++++----
>  lib/iov_iter.c      | 6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index fe2e985d74d24..529c6cd53df7a 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -362,11 +362,11 @@ struct iovec *iovec_from_user(const struct iovec __user *uvector,
>  		unsigned long nr_segs, unsigned long fast_segs,
>  		struct iovec *fast_iov, bool compat);
>  ssize_t import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i);
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i);
>  ssize_t __import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i, bool compat);
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i, bool compat);
>  int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
>  
>  static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 2072c04e99d05..55cf2ff5bfdad 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -1362,8 +1362,8 @@ static ssize_t __import_iovec_ubuf(int type, const struct iovec __user *uvec,
>  }
>  
>  ssize_t __import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i, bool compat)
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i, bool compat)
>  {
>  	ssize_t total_len = 0;
>  	unsigned long seg;
> @@ -1434,7 +1434,7 @@ ssize_t __import_iovec(int type, const struct iovec __user *uvec,
>   * Return: Negative error code on error, bytes imported on success
>   */
>  ssize_t import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs,
> +		 unsigned long nr_segs, unsigned int fast_segs,
>  		 struct iovec **iovp, struct iov_iter *i)
>  {
>  	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

