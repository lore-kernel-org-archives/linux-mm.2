Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9189CC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 20:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2406B007B; Thu, 31 Jul 2025 16:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081766B0089; Thu, 31 Jul 2025 16:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8CC6B008A; Thu, 31 Jul 2025 16:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC2E16B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:36:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1030114C7D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:20:10 +0000 (UTC)
X-FDA: 83725676580.08.C54A1E5
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id A539418000E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:20:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r+B7kxPr;
	spf=pass (imf16.hostedemail.com: domain of bernard.metzler@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=bernard.metzler@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753993209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N/Zzs9sQW4KIe9YYyHArbjN2w5AkIlMqy06wqviZAk=;
	b=HEcM0Pf/9awJQ0FdklJqg9it/mHOMAlUOuTaC6CAPfk0h/MY95LyG8yxLTkxKRENUi+lqb
	ZUH5a77C2BnZzVogAdFIB6v+u/R01DKKKvWTYNsgvWpKcZsQSGVGtX13P5TZ/2M8R7Pi1P
	eJFtNNd4KpXWQjJJk8sDj3+BvdQcKBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753993209; a=rsa-sha256;
	cv=none;
	b=s4NOLzQvU3EYXIfrYfOcWzV8G42Urc2wgbtoD6nq4vpTes6FRu8oiJUUAb0NvxWrp7Nmaa
	sJqc7jypMgOQZQ2ELIgqcqz19IbgoOAls0/shdA/Uv7fIEOuetw6MPP+7EBKUvG6dAbCPb
	ekfn49ud22US786QTbgHNc5I+aLBYJg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r+B7kxPr;
	spf=pass (imf16.hostedemail.com: domain of bernard.metzler@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=bernard.metzler@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <631a1251-5bbc-484d-9bd9-167c5e7cb69f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753993206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N/Zzs9sQW4KIe9YYyHArbjN2w5AkIlMqy06wqviZAk=;
	b=r+B7kxPr2Nbf13zeA7/xZqmltlK03ecVgTUdnlAAYQkAgEhI7ndwcqXZkJ4LLOO4TbARLW
	wwJ7qUidPXIw+FS7mZPExq6awE96cWZzYHI4mrh21TIpC5fG17ogMRKji7T4rPsIGSs4fR
	rQituKvDAcJNTmf+y9hpdAL0R0CBXQ0=
Date: Thu, 31 Jul 2025 22:19:57 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>,
 David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, torvalds@linux-foundation.org, stable@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20250729120348.495568-1-pfalcato@suse.de>
 <8fad6c00-9c15-4315-a8c5-b8eac4281757@linux.dev>
 <x43xlqzuher54k3j4iwkos36jz5qkhtgxw4zh52j5cz6l2spzw@yips5h4liqbi>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <x43xlqzuher54k3j4iwkos36jz5qkhtgxw4zh52j5cz6l2spzw@yips5h4liqbi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A539418000E
X-Stat-Signature: 1ydt5jea8pz5dgkqecict5j3r84cmr7x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753993208-911496
X-HE-Meta: U2FsdGVkX1/oSFoLQrY1PArG5jQYqJt4/wF9Mv2WKA0rhqLzVvCBnclZDdKx4YMf7vKM+OuoBRtRDP/jm9ICugynaYedya3TnXkwriBIVYWcWNcByVESI7tc39ssB1ZV70f4shQSsxjV5oEtjgUI+ddz75G3Nmcg2U2FQXQBH8yCihW2B7YuZcdXv8WhD8OMw7/lnlAqMJfhn+86goeYJ9o+9Q3Dfr7QTwjAAxH5bZ6gZQv9690AikE13nYmcgUBLVrIdRtUCng3GFmi56p0FcbKNU6ow+yW5xVJMcR/7cN4my+lXCuOFO/ecWfaZiumGlrIDtTB2WaHpbf8Eyv5jEECBAOvWsT6Ph9tpPYQPYah6rqWtX0lpA45zsN/441+PNrY00m894RefOHCIR3q2TRsYBBNQBq9Uf8WJWdQPAH0SSO8Q98y5G0QKPrs19v3ZNvcnOUZXmi1OFbKaCzipqbLM5aca0XbMVGpO37b79UOOMzp/EAJOzsPOxsFJG7X8p+Z9Qx718qHSmF45tySVULsVIizB1gsXEj6ROm+e+Xk5PTIaAxpzmBxaSg/08ZNqZzbK/8K9cbfl1mZN//K2HmFAlBS+VBmJP+aYxuR7hAorlT/4Bypr3kNGq1TSVuwcuGDcK4eS6KhwTKQTfnxYg78AGl83tzlrcCfsCpLRO1I/hyhduJ/d3UGgWgoG1JTYGipwDi6H5oshYaAZsamHqnYxkdetIotzLB2QXVv3xUKa7kLO01I9onsIgCvP6oJkuasvMrekHzhimK7yED05Z3JxT3HW2HxvTbXhdRHlGR9YzdCM/OroNgoqIpVDsqrBF0nc0ySA99Ml7EzzhOqFeVbxN8gKpYQxyPXDlwVK1lQa1iGIM7a3ZkRUltmxceD49DDqvAPtj5XHHwKo7dxevoRQiaiPhKUI/XuM5BvZeu/KEsIAFcfJMp3JBCcGWFx3jmLYpTIoL0X4uX9z6a
 7QgEcrQV
 fR2dD10VcqqOhSF5B4k85OA6mbt1WLaVeS6OCPSbYaJ+34kY0gi8qvvzaM3K4aP+tCnxHK+VgWZFinPAnT5R444rVduk+RpeSUDJ1RC4wPEfFYMvPE2ePQGRpjb+mUE+Cw/st8GL9ydRKHhp813k/5frGXwhulvPpNiA0JulVx0fjDNSJXKjzTnRJu4eRCv4oFoY/BSNId4uvzZZtPYnr4F0c/uxCLdT9lGIgU/jMQXLLGzn5Irz9wfLPMRhu/BpKlG4un8keRyzwcJ8FyvGDbTtvmgid2DOS6vzShv5H9+XR4CVmf6aae48XveOX4ki7bl3UFgEH8f2JGs8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.2025 11:26, Pedro Falcato wrote:
> On Tue, Jul 29, 2025 at 08:53:02PM +0200, Bernard Metzler wrote:
>> On 29.07.2025 14:03, Pedro Falcato wrote:
>>> Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
>>> we have been doing this:
>>>
>>> static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>>>                                size_t size)
>>> [...]
>>>           /* Calculate the number of bytes we need to push, for this page
>>>            * specifically */
>>>           size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
>>>           /* If we can't splice it, then copy it in, as normal */
>>>           if (!sendpage_ok(page[i]))
>>>                   msg.msg_flags &= ~MSG_SPLICE_PAGES;
>>>           /* Set the bvec pointing to the page, with len $bytes */
>>>           bvec_set_page(&bvec, page[i], bytes, offset);
>>>           /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
>>>           iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
>>> try_page_again:
>>>           lock_sock(sk);
>>>           /* Sendmsg with $size size (!!!) */
>>>           rv = tcp_sendmsg_locked(sk, &msg, size);
>>>
>>> This means we've been sending oversized iov_iters and tcp_sendmsg calls
>>> for a while. This has a been a benign bug because sendpage_ok() always
>>> returned true. With the recent slab allocator changes being slowly
>>> introduced into next (that disallow sendpage on large kmalloc
>>> allocations), we have recently hit out-of-bounds crashes, due to slight
>>> differences in iov_iter behavior between the MSG_SPLICE_PAGES and
>>> "regular" copy paths:
>>>
>>> (MSG_SPLICE_PAGES)
>>> skb_splice_from_iter
>>>     iov_iter_extract_pages
>>>       iov_iter_extract_bvec_pages
>>>         uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
>>>     skb_splice_from_iter gets a "short" read
>>>
>>> (!MSG_SPLICE_PAGES)
>>> skb_copy_to_page_nocache copy=iov_iter_count
>>>    [...]
>>>      copy_from_iter
>>>           /* this doesn't help */
>>>           if (unlikely(iter->count < len))
>>>                   len = iter->count;
>>>             iterate_bvec
>>>               ... and we run off the bvecs
>>>
>>> Fix this by properly setting the iov_iter's byte count, plus sending the
>>> correct byte count to tcp_sendmsg_locked.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
>>> Reported-by: kernel test robot <oliver.sang@intel.com>
>>> Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
>>> Reviewed-by: David Howells <dhowells@redhat.com>
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>
>>> v2:
>>>    - Add David Howells's Rb on the original patch
>>>    - Remove the offset increment, since it's dead code
>>>
>>>    drivers/infiniband/sw/siw/siw_qp_tx.c | 5 ++---
>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
>>> index 3a08f57d2211..f7dd32c6e5ba 100644
>>> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
>>> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
>>> @@ -340,18 +340,17 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>>>    		if (!sendpage_ok(page[i]))
>>>    			msg.msg_flags &= ~MSG_SPLICE_PAGES;
>>>    		bvec_set_page(&bvec, page[i], bytes, offset);
>>> -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
>>> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
>>>    try_page_again:
>>>    		lock_sock(sk);
>>> -		rv = tcp_sendmsg_locked(sk, &msg, size);
>>> +		rv = tcp_sendmsg_locked(sk, &msg, bytes)
>>>    		release_sock(sk);
>>>    		if (rv > 0) {
>>>    			size -= rv;
>>>    			sent += rv;
>>>    			if (rv != bytes) {
>>> -				offset += rv;
>>>    				bytes -= rv;
>>>    				goto try_page_again;
>>>    			}
>> Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
>
> Thanks!
>
> Do you want to take the fix through your tree? Otherwise I suspect Vlastimil
> could simply take it (and possibly resubmit the SLAB PR, which hasn't been
> merged yet).
>
Thanks Pedro. Having Vlastimil taking care sounds good to me.

I am currently without development infrastructure (small village

in the mountains thing). And fixing the SLAB PR in the

first place would be even better.


Best,

Bernard.


