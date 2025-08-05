Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB073C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3406B00AB; Tue,  5 Aug 2025 10:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783A86B00AD; Tue,  5 Aug 2025 10:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6728E6B00AE; Tue,  5 Aug 2025 10:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 512556B00AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:35:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03ACEC02B3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:35:06 +0000 (UTC)
X-FDA: 83742951054.24.AF86539
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0B0A8180010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:35:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UsKFkoWI;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404505; a=rsa-sha256;
	cv=none;
	b=LLMHtq6p/mmhEz64/8vJOZX8SjmvasiN1Mq51Hz96jQ83XRECL98GRxhMlIgLR8hYkZMco
	jXx3x+XSBltX70qkoRc940ZMVSgKg1N6vwrGrKuobPqTHRK0/DB1ZsRahU5YCJgHaZ8BnZ
	iAzge7Jk4B1OvqODkIOBsyHHScJkDjo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UsKFkoWI;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBToXdvc7vhVURp+VSgDGT8CNn/O/Lx3N4Cacd9QC+s=;
	b=JRih5M+MZFAIPRRHoBr2mHIQkqXrytnKRw97dXmAjHlWhU4aYjkEhxGYuVbyonpW/B5Ped
	pBlE9LcggI1ZgY07HtNR4+vrV8G0CxADV3POZ5lbTSm8W8BxQUd1hHaJSFJFr/g+mN2s65
	fztDIuIpZ5RtoITp80E61kEmMfGM95k=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e2c1dc6567so275338085a.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754404504; x=1755009304; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RBToXdvc7vhVURp+VSgDGT8CNn/O/Lx3N4Cacd9QC+s=;
        b=UsKFkoWIUSKsGIiRgHuELiNhFCA5Z+1Ngm0+UhDaoqRHcTy+VpeQwayQgMKgwsEHgC
         mgxfLY1fplS0QOnMt2Iq9/Zj9xYpw4pP9sZaYY1/yEacOL674D5V6b82K7RGbJJ7NQ1d
         7bPStHlHcbaRKxQnNeSX4IXL/ePHCTl9qNJmWGtXKwGqjaVn+GDfN4WwJDy+QgDW2nw6
         weANhJca6yPK8wvSXbl6E+2LbGYcyy4QlP4rsfFhOYLpulXDVXlvsU1khwWR1N6Nj1ZI
         Ako5c7GexrUQ46vWravSkbrczSgXdFxamajqqVxUEklRZ1dvtxiBBSNZ8WuDnUBIZ2S7
         Es2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404504; x=1755009304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBToXdvc7vhVURp+VSgDGT8CNn/O/Lx3N4Cacd9QC+s=;
        b=i6Om0QCVXc6lH/3YMueoe74f/jlhit44jY2zlwcoBHFZJaWx9s3m9DWwBci81mWv5f
         E8pPeG2YJYuuX5ALllW0GL4jA78ympfy1+4+l6sX4KDbUPRJd3on+ZBkOugKouAvjoRi
         NePFY3RgzWbui4hv7b/2mh0MKosoeGQCKVj1jYIOcN2aszzXfpmXEgHw3ymqaeQU0n0E
         3boz1noxlyap6qY/PAjzkG7AdjmZgA6BD0rgyHJ3EgfTBkG5nHAcGIc6fomLwHTzuSHL
         cE7TGXCID5PU7pA4sln4AmpEGkDJmjR0cr/jzMODF78GSm+ZwtbkZXFdtoIfHWHw7xGE
         VAmg==
X-Forwarded-Encrypted: i=1; AJvYcCVpG9seDBUEY6YPdt/u300n3q67dxBeRNy3XNhZjcS9M6XH8GN0s9mUr2Aa1baMXz2GiJjT+ZmD1A==@kvack.org
X-Gm-Message-State: AOJu0Yz11RrDNr+xf4oTljRdWWIvGjHDaDJQzcHSSLslLUgSHBmxvKQy
	Tku/SDMlTVKcMtgI30Rkb8Q6+8k362BGtQa+FBzLE/4qhCzp1eoMr35Or2JSl/hR8Ok=
X-Gm-Gg: ASbGncs/32UTl7x+6iwkt25XZ+U8dPI8DSI+zlzkmiXIgA8Y+KJwiipI0B8Iq/TOwbJ
	hbQHI1bKwRiX4YfKWpkIkEexe7vFMdUsnOXVCv5D/T61sM1seH7kVrJAjiGdBaA4gd8Gxtk9cTM
	J+xrccYajup8+Kul83u1pNhHWME14xcBz4kxHJyFBrRhx4RRc8yKqykV7LMA2XuqLSrXarapHdV
	vXmzltuhrrFJgzp6D6or9X/o73ZeiKVTHLCAzH24cIqy2j8mKU9FRGl4snRlYKvv0zHEmIJ3gOX
	apWBBLC2fc4bCniVdKoI/QIjKcnFPtnTO6FOk/q8VijkCIiWi8TO8kqeMz07jnKxMqdXM42rQO5
	RLQJLjdDFSev9A4KRAHhSEmIvWtw2TEaSIU+nCT4HkvsZ2436YwMHQB4uqJ1JsfSW2Jmp7J64Ju
	7RIf4=
X-Google-Smtp-Source: AGHT+IF+3kfrwzrTgPnPbgiihuZwD781MauBUX6H7jY1e1xn+FzW3NhXvH6UtxUPt9nNb/NESu2wng==
X-Received: by 2002:a05:620a:a483:b0:7e6:7e39:be55 with SMTP id af79cd13be357-7e696269e7amr1410178785a.2.1754404503789;
        Tue, 05 Aug 2025 07:35:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5bee91sm681707485a.32.2025.08.05.07.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:35:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujIko-00000001Y5w-2i8N;
	Tue, 05 Aug 2025 11:35:02 -0300
Date: Tue, 5 Aug 2025 11:35:02 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Jakub Kicinski <kuba@kernel.org>,
	David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, torvalds@linux-foundation.org,
	stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
Message-ID: <20250805143502.GQ26511@ziepe.ca>
References: <20250729120348.495568-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729120348.495568-1-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B0A8180010
X-Stat-Signature: kdrqgx14uj4wd398oyxkxme5jm835uqk
X-HE-Tag: 1754404504-80509
X-HE-Meta: U2FsdGVkX19Fsk0rbVBCTO9fZM0Ear9hnUfnagXoC+tBo3r3gMA40JG/gRuJkuQQ+QNAyKetIoYPNTuoIcDfhya8nrFhZG6U3C7N4ka1b5y/V16Cq97+lCECy4O6jW5/TmqjTcicNCYUr11v0HtX8XERwXHzGbZhY0uH9zBq70JkNyCZTq82fYdbBSVlRGGvXzgb1EJfvG0JboMMpzxWoFhAZddEFbJ36g7xBxdWVxa+jVo74Tjop2MIQa77dZpXgpBMdoL289UsrMG1QB98vFVzDgE2jYjoaDXO2YrbjRV7ScRgleoF6EelbF/bmublMrU9XirYopXdWjW0DdvoaIeY+vrLf3C6mfnEzGepFqpQKxxMxg3h9u/SX8/6668gWn+hNhWW/51ZmMPxBnl2UxjCkF45Q39QZ41ySHKtw0l0zJ5GzRdL+4D5HDNGlVYBFfLeOnf+1ktRATefSUDHASLsUBszXgJLNyRzWKtkxGMZNaBVMnSL2mRI1+mabDNnnEm8Up8B2LwgzxYSEywDfz0l3Op0yoK5jHSIrW8bM4H4/cjCr9K1CZKrqjxnokl0Lzn3QItJOIKc589QgSj/A2ePXxB7dw1MXh9JiH/YBe0/U8wNbrlHqysHPSikxLq1Gy9UnihscTQoAzCAHg7ZbzctnqowL/9ZCzPoEioOkvR7hJflwoKyb+R8LDxGB7A5AFiFcuj5+wRDpGz1dPrTI9khC2Ww9Xyx4NVcTzoUqymVw/1IzArnm78NxW1uM8wxQAmRPMPowBCI+vApq4Li+VoBKe75pBcJZhU/MMLqeOjNlkuFp3Zm5q+O1zetUkZKkD3ojBvPO8EJOZIktoQz/ykrpHNyxroa2IhW7fFj2aYD2L+rRcw/8Sswj7I6LaExb8nOEcpq1rTVIwbTkF6t2OwHZBIvnZCLujdkyc1mK+4U5MHtBGM8wRdTGK7FsIhN6cwvYPo1i+ZoE8iEl9o
 U5Kg2ilH
 RWKE61LF3OQOtGhtVpD2MN/j7hwyi9H8Vmm2djU5COQG9oataSf3RpO658YuyxJ7gK0Y/ILVPWEeC0y54YKbqtCGufGXN2pO2LUeYiZ+VN0M6vG8nsechksytnKfcLNF28pYxw71lVzENoAr3663aKZaIlhJOkVTPIxYXZcu2MDncnESCtITFwo1BHaMbWmIKiB+iBb3pzRGsz65FXHdYcTnWHXWYg34l1Hq1edci1Y+T9HYVHyni3n8AuBTvFg0YSaj7YOWVIX6Ih+T92W4cZCYBbzWe30ipfyV2vWQ9cSlXks7zybX9mYxob2ZbtupKOYajpzQcoM44ZD4L59Zz3Q2T+VC5fBSTAeYIrWfWBzZTF32CEVO93qD4N+/IihIlk7TAz/8XozBO+ZuAds+AXMsC2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 01:03:48PM +0100, Pedro Falcato wrote:
> Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
> we have been doing this:
> 
> static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>                              size_t size)
> [...]
>         /* Calculate the number of bytes we need to push, for this page
>          * specifically */
>         size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
>         /* If we can't splice it, then copy it in, as normal */
>         if (!sendpage_ok(page[i]))
>                 msg.msg_flags &= ~MSG_SPLICE_PAGES;
>         /* Set the bvec pointing to the page, with len $bytes */
>         bvec_set_page(&bvec, page[i], bytes, offset);
>         /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
>         iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> try_page_again:
>         lock_sock(sk);
>         /* Sendmsg with $size size (!!!) */
>         rv = tcp_sendmsg_locked(sk, &msg, size);
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
>   iov_iter_extract_pages
>     iov_iter_extract_bvec_pages
>       uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
>   skb_splice_from_iter gets a "short" read
> 
> (!MSG_SPLICE_PAGES)
> skb_copy_to_page_nocache copy=iov_iter_count
>  [...]
>    copy_from_iter
>         /* this doesn't help */
>         if (unlikely(iter->count < len))
>                 len = iter->count;
>           iterate_bvec
>             ... and we run off the bvecs
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

Applied thanks,

Jason

