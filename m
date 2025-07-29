Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B52C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839A76B0089; Tue, 29 Jul 2025 14:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811736B008A; Tue, 29 Jul 2025 14:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727996B008C; Tue, 29 Jul 2025 14:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 652116B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:53:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46CB91D86E6
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:14 +0000 (UTC)
X-FDA: 83718199908.17.B5EBD08
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48023180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j57oc76U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of bernard.metzler@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=bernard.metzler@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753815192; a=rsa-sha256;
	cv=none;
	b=KkxxFickWm7XGtc0psXmJPq6XiWI45UvUvO0GZna328LPJsQ0nzop4yPwoitQVLVn4I1UE
	BNS+N3NUsXqlSsmDvC+kDITU5r+Wed2P8Wu4cq2ZKG8JzpKUmDWW4HwgI48Uqh7gGWlCQ8
	i4CjJgLS7fksFFBxfTbQKtbGwT7rNak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j57oc76U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of bernard.metzler@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=bernard.metzler@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753815192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8uizJieSyqW56uosfxUJeKEVQ0kVEbrA+dUYFoOGRs=;
	b=p3VEyZmmorhPgBjPeSXmKEbKJPnq6mYeLlADUllV1TBa7JS8rqRshvj+xXPOuRYuD517kI
	ei7w2h9tv05zAXDesu38H9nVY7/OmDBQ1nV6JRtJD1WBRyXMVgbXOGOG55sm9DFvrnJPlV
	W3+cm+9jb63nGdl489TFZQkoXuUQPGA=
Message-ID: <8fad6c00-9c15-4315-a8c5-b8eac4281757@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753815189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8uizJieSyqW56uosfxUJeKEVQ0kVEbrA+dUYFoOGRs=;
	b=j57oc76UIhZL5Xpcfh4U0tWr8C6enCpVQGbo2hG9G/0MM06fuiCJ8Y9RkLcRYz1x4orT97
	JobdnhYCZ2iemZAIgxqDkCvYrqbLu0Qm1apgcZEDuQd2TzZ6hTyq50I2Vd3GHzTBw1Z8r+
	6U+OU1uUSU0PwvKHE1NHrhjo/vcQR1Y=
Date: Tue, 29 Jul 2025 20:53:02 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
To: Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Kicinski <kuba@kernel.org>, David Howells <dhowells@redhat.com>,
 Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 torvalds@linux-foundation.org, stable@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20250729120348.495568-1-pfalcato@suse.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20250729120348.495568-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 48023180006
X-Stat-Signature: dnxhcjntw4p9ckpiabbkpe71grq13s5g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753815191-923620
X-HE-Meta: U2FsdGVkX1+WlIk9Dz22INuLS1A8uDl1qUSvCqk6npKtkrfaSXifuSCZaK9KHRIHZYSfe2x2/Ipb0ZXn59Fw5/xde7Pj2qsf51er6gIOauDTuncYZpJPoNio7IGimlKoKaUjvZ5it/fzShGFookdpVpyQpRJffyk5C+4hJubqHw6ZXdhVSJQYl97/p4YXtkF0lEkWGgT76Mi74jjdS+GfdNOIo7SqvxqP9SF7qK0akOz/99TYVKQrgkKh54pYTJ3Jtnyai3iZLzS3VckMza/a+PtNZ5ZjVCOqe1QTcwQWzNMOvgzZlLDQXmA4/JNz7KmguHop7wUYXMMxHYixBjJ8Mqcp/V2xPAhu7/mbFzuXblnZk3sAZt7KokUFlGMlKQOQB9N+UvzBA/fIsEICsp8Wug3b0eDmK+kutGssLQkeqUTkFY+JZ6/FnmrTGwRvHVQYHlQCv5GdsNtFUtQd0NTmr5ziMMRrDYqin/rp/eQGBhzPkn24N/KcOGTbdhriDQXuyf4SUsF4o6saF2wBvyj7e+A5z6I3PZgb6UyCjBJCMnqE1qDG2N+PW5YmAe/sMI1jM/P8OLJKlPnf98/C/kMfDl9vSziN4mz2aG66h0Pqn3mCWscPUBZzIWzeQPBYlJJzTXTaFaI1bYw1p+zGAb6KPiUUVrHmYJJ+aSGaChtvKuLnKphiEIvBQ3zey9Bg7IYRnbFAbb1RBK33jxSo5EHNj0YxJ5iWRnhSAirzEU8wd9fKiVueMlb1U6KQSMuiSA7l4wvTDWfoyppEEGt2IAmp+Qf2U40sD1AG8hcSpp3FhN/mzBOP6gw+P+7SBP6tfa19gTL0IM3S4Dbfcc3u+I8v3s7Zi05Ymet5S3fV+PxnCoh/FMdxwZri5hWnABWCceE623pMf4NKNjQGRJZdADb52Hky9pXSn6/WIf9ZVe4Sd4FUzb5gApxUpVCyg62VyeYxlJdhV2sEn2JYCTmm5x
 58uH85o1
 cI/Wn7mALMqOD4okDRGobs365bzRR61z3MHAVxF1DHbRaxDv131jT/UeStI2bfrYOrXVTmaIvrPgzL7QDCWD825omdZBmpBpN9Fzx9gr/eFjA9qiYTwmaG2gqLE6GEm1DLKn0s3Jco5sPsjK+7FNm6J9YU7jYxzBjbn4uNYgq7aQY44iuI7J5KQaX7N4u47E3OYms9PHJVQCg/NMNSV/c8ywbGdjADlM3tiBGNRZCRYRTOPM7I7KIFg/eARu7THWo/lyAto7yU3wKB8NEXtxi76jiK/qWN6DaHBTeG0FbWfMuAOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.07.2025 14:03, Pedro Falcato wrote:
> Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
> we have been doing this:
>
> static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>                               size_t size)
> [...]
>          /* Calculate the number of bytes we need to push, for this page
>           * specifically */
>          size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
>          /* If we can't splice it, then copy it in, as normal */
>          if (!sendpage_ok(page[i]))
>                  msg.msg_flags &= ~MSG_SPLICE_PAGES;
>          /* Set the bvec pointing to the page, with len $bytes */
>          bvec_set_page(&bvec, page[i], bytes, offset);
>          /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
>          iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> try_page_again:
>          lock_sock(sk);
>          /* Sendmsg with $size size (!!!) */
>          rv = tcp_sendmsg_locked(sk, &msg, size);
>
> This means we've been sending oversized iov_iters and tcp_sendmsg calls
> for a while. This has a been a benign bug because sendpage_ok() always
> returned true. With the recent slab allocator changes being slowly
> introduced into next (that disallow sendpage on large kmalloc
> allocations), we have recently hit out-of-bounds crashes, due to slight
> differences in iov_iter behavior between the MSG_SPLICE_PAGES and
> "regular" copy paths:
>
> (MSG_SPLICE_PAGES)
> skb_splice_from_iter
>    iov_iter_extract_pages
>      iov_iter_extract_bvec_pages
>        uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
>    skb_splice_from_iter gets a "short" read
>
> (!MSG_SPLICE_PAGES)
> skb_copy_to_page_nocache copy=iov_iter_count
>   [...]
>     copy_from_iter
>          /* this doesn't help */
>          if (unlikely(iter->count < len))
>                  len = iter->count;
>            iterate_bvec
>              ... and we run off the bvecs
>
> Fix this by properly setting the iov_iter's byte count, plus sending the
> correct byte count to tcp_sendmsg_locked.
>
> Cc: stable@vger.kernel.org
> Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
> Reviewed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>
> v2:
>   - Add David Howells's Rb on the original patch
>   - Remove the offset increment, since it's dead code
>
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index 3a08f57d2211..f7dd32c6e5ba 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -340,18 +340,17 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>   		if (!sendpage_ok(page[i]))
>   			msg.msg_flags &= ~MSG_SPLICE_PAGES;
>   		bvec_set_page(&bvec, page[i], bytes, offset);
> -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
>   
>   try_page_again:
>   		lock_sock(sk);
> -		rv = tcp_sendmsg_locked(sk, &msg, size);
> +		rv = tcp_sendmsg_locked(sk, &msg, bytes)
>   		release_sock(sk);
>   
>   		if (rv > 0) {
>   			size -= rv;
>   			sent += rv;
>   			if (rv != bytes) {
> -				offset += rv;
>   				bytes -= rv;
>   				goto try_page_again;
>   			}

Acked-by: Bernard Metzler <bernard.metzler@linux.dev>


