Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D210DC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30C36B008A; Fri, 24 Jul 2026 03:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A095F6B008C; Fri, 24 Jul 2026 03:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9486D6B0092; Fri, 24 Jul 2026 03:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8856B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:41:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2DCB1A02E0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:41:42 +0000 (UTC)
X-FDA: 85022875644.13.ECD5F27
Received: from stargate.chelsio.com (unknown [12.32.117.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FC0F80004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:41:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=chelsio.com;
	spf=pass (imf30.hostedemail.com: domain of bharat@chelsio.com designates 12.32.117.8 as permitted sender) smtp.mailfrom=bharat@chelsio.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784878901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgs1xAKh3q47RSOi9eKppqB31z+EeS7ZlWquzpwBui4=;
	b=3PNnCmUkvCOfxLbg+Z2opDmA2ATMAf+l62prndkE+ifHhnHMmdyRsomVPfvhWvEZLqYrOs
	/vQ2sYcDOJ+/Cw88NtFAQNfrDPN3Bv6QlIvKlXVVhqg96lkq02pG0WlvpKV5iNRXRUeXll
	pl0TflGB6ZV22vCnnVmqQB/ln5El+Iw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=chelsio.com;
	spf=pass (imf30.hostedemail.com: domain of bharat@chelsio.com designates 12.32.117.8 as permitted sender) smtp.mailfrom=bharat@chelsio.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784878901;
	b=OgJ+Gqj+WdcpmLi682kYA/w1S+CrGwhjYeq7MaWdK+oVK4wohCuGQoYUPh39S7UySZa2YP
	/Oaw1rbFxyy/W+9KxWpFozBJMwU6qIphLQfv5qI7F3v3z74GKmKztiUlrfVmrIe0BcsSnw
	xNaE3J+Ih1p2JgI2ULae52qSBc6qWxg=
Received: from localhost (praveen-pc.asicdesigners.com [10.193.191.60] (may be forged))
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 66O7YKls001771;
	Fri, 24 Jul 2026 00:34:20 -0700
Date: Fri, 24 Jul 2026 13:04:03 +0530
From: Potnuri Bharat Teja <bharat@chelsio.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
        chleroy@kernel.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, jgg@ziepe.ca, leon@kernel.org,
        akpm@linux-foundation.org, namcao@linutronix.de, ynorov@nvidia.com,
        sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 6/6] RDMA/cxgb4: remove dead NULL checks after
 GFP_NOFAIL allocations
Message-ID: <amMVa/hvQndWud1I@chelsio.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-7-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724022851.466017-7-gouhao@uniontech.com>
X-Rspamd-Queue-Id: 1FC0F80004
X-Rspam-User: 
X-Stat-Signature: swmci17m9gdo1aoxscdgp5tts9xx5qb8
X-Rspamd-Server: rspam04
X-HE-Tag: 1784878900-957612
X-HE-Meta: U2FsdGVkX19w0syhgELt1/uiZVnw8HsA55BTVYyWZJlJcnGhL1KOy170eYTQURhat0hhHiUHiOXI69c1zhNNwcREfqrp/IWrHE/43w8X4LEi1Tau+d9LtpagK63XuIk/qE4WW4JK0nRiMH3nMaiKW1kVfWJBYTsBZJrFV0dyGrvjaYtDt5ZetiNcgpn4OcKRqk49crphMCqZW9NGnwMGDwIF8WhB7tRNXkWIBy1KCUUJClQY6qvJsDCZAdlf/6urDAHnA0obMMA7Ljn5VoXrnmPsqWuWl+N7411lMmReCB60BAU+AQ41zO0sY40uNkd0yVnEhTEQ9izfyH0hzvMvm6K33rJwjyNkjBAAugF9Nt0jocbe1BFA20yd8njrLZJYM7aAQVzBqClunpgOfwJwldxqukSE9iN/VzYDigUWC9feuQlWYWFMy+pIiD3Njr6Vb3d4H3Chwz5B+ba/KL2yY5n48UUoqvIza+wSBi2ewL2HHflfUnKUesnf9hqXzK+hS0lT7R+FLP4IEYBLhTNPzv68+WXYpXqjUswQM4+cJDRIN72BJq4fQYB8eaNsSOPU3JqPgO0KAyXiOWYKITANlPgs8ArEwnbe+l4AMKHlCf4qIMFo0BH3G04tQrZvTN/sydBSse7nJWY4bZQiisO2aP/C0m/u2rD2W1YbyUyuOnlOBYlkP28XX43jQNMmosnBJS71QvzONG686zt9ArBguY2WKiYk/Eg+8vo+k3vGbdVvS1DI2sXb69WIjccySjN9qu30Rnm3WJWym4mKDJzt9aFLS+iPcJmV3gbh2x3qJk3EiHcx6djUVj2bY19wgTwok7uxQ2zn6F6fD6GgH6p0MD5qWLucrfjDRT40bva6c782V9V2m73VfWI8NGIEbfQ1RY+TEHgZAjZCfIhZEvPfzWVmn4NLhT0N/wS+OC7nFZXEDufZdarmmkgm/wunj01x9bQOUJVHStwWxntd+Ai
 dpBKs7u+
 O4Lk7ZZ9RaqhkEdq2vEAKJH3IMsB+hOftnX/kmKa7GDN1AskdV8P4yt5eiAA2eeCjLVCBlJF6nGyBDZfI1SotV1LZ60ciVHIJN8ls/+elpUvejOaIZMxXzFLauWY3M6dF5xt4W/MjRpgSiKVtXyBy32s32RDXhj90n7tfZseTmUOagZ6PV3Udu6YFGH3xel4tdZeqUNVltl/rZhnmrDyI/mm5rEe81/E3NGV2uY0H6JNYMiTTXq3rKg7KvFMIb/csNwiknVuJtb5eulGN86SR8159f0XCWJtxVfJ2+/JhEI5FDOBMwYS9olQJ4JPFk4gXUeV78pNxRLjOtU0cvJUyCbdyeh2DgE3c9XwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Friday, July 07/24/26, 2026 at 10:28:51 +0800, Gou Hao wrote:
> alloc_skb() with the __GFP_NOFAIL flag will never return NULL,
> so the subsequent NULL checks and error handling are unreachable
> dead code. Remove them.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  drivers/infiniband/hw/cxgb4/mem.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
> index cd1b010141984..08631de17c0a3 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
>  		c4iw_init_wr_wait(wr_waitp);
>  	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
>  
> -	if (!skb) {
> +	if (!skb)
>  		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
> -		if (!skb)
> -			return -ENOMEM;
> -	}
>  	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
>  
>  	req = __skb_put_zero(skb, wr_len);
> @@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
>  					 roundup(copy_len, T4_ULPTX_MIN_IO),
>  				 16);
>  
> -		if (!skb) {
> +		if (!skb)
>  			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
> -			if (!skb)
> -				return -ENOMEM;
> -		}

Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>

>  		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
>  
>  		req = __skb_put_zero(skb, wr_len);
> -- 
> 2.20.1
> 

