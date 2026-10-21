Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E00F606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WFuZyBQu
Received: by kanga.kvack.org (Postfix)
	id 3AA9B6B0656; Wed, 21 Oct 2026 03:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381E06B0658; Wed, 21 Oct 2026 03:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFC36B0659; Wed, 21 Oct 2026 03:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0065B6B0656
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:43:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFB6880382
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:43:25 +0000 (UTC)
X-FDA: 85345843170.20.FB288CE
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf02.hostedemail.com (Postfix) with ESMTP id A72A880004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:43:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WFuZyBQu;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792568604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqvNx+nSFaoooaGDpoFgXiB2Eh7sDLhcG8Y6WkOQHNE=;
	b=tzx1lNk3mqbc9jXFd8wKXDoVDOi5jzOHjx9VzON+kAx4wB1ZSDHsl03CRVWjJmZPvyhjEm
	ak6kzVOWpMNU9nsU0gkWFz1/nJGL0nqRV45Vvf1k1uEmiKSmTrPV7gQgT+XU8OiQcRssnr
	HdkewwE4rOwb5S07VWE7C+x0emE1wC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792568604;
	b=tSz9q9vHNjHWtw3nsOgVgDVnmZxhg3+zUMjGFapu7hLcsJ3CoNOQAQjn5z32/dAjbUFHPW
	Ihq2jJqD5Ro0UcGI2KU2JRfTOi7mQX/L+tgGN7oe/U3hUx+3PXDppdBsdXCtlhhw37f+Ts
	fK9Mex2wsUTybmBRXG46oULbPrd2+4c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WFuZyBQu;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1tenPNde2ofLPho6d+i0Ie/+UXV53/Rdww8nZpiovVY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792568602; v=1; x=1793173402;
 b=WFuZyBQuxADYHx+rU2yhqPLHRterWXJU0j79yIrNEAtsGpUOF85g1RBApMM1/rucscBbCRPL
 wOAn1tFIo/tgDBpowrOKaItkSGCH1TCkI5tYOFgmjFDEI1cPDCAb2w/IAbEgsNyV3Xzg2eoQZz9
 P/FURSW0ASSldsdaLWX+3GCk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9b75c6eb5203bb55;
	Wed, 21 Oct 2026 07:43:22 +0000
X-Mizu-Trace-ID: 9b75c6eb5203bb55
X-Migadu-Flow: FLOW_OUT
Message-ID: <98855929-df9c-4615-84ea-b90acba8c2ae@linux.dev>
Date: Wed, 21 Oct 2026 15:44:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <cover.1792439751.git.abhishekbapat@google.com>
 <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A72A880004
X-Stat-Signature: z76kukfpbpw589oibj7tc5nuyipij1a9
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792568603-431438
X-HE-Meta: U2FsdGVkX19L9mDXYm9yVXjT+fPFB9YjGUfcj8ticpSglT1WFoafG5U8Xhzjz2LkGT6Nz/nlH1VWvRYo6AEorhQWw1Na5natYMgw2uI2OFxb3mnw4HrFSjVOuXc8JqCOvgl1eG9ymcfckfWPOf9f867nP03zzCFkguyd1ensx5hwliFIC2xkOHgAcucYavt7vMn9bxSIPPHrsh5zntiV0phAaqBLbZ+TAzygpREVk3CJBf18yiP13QpgUnNqG5R4Sr447SWmV5hhW3mLsbaArVU7bm4+nY1V3KpoSLg7E+3iSGxhxu2QyYsMKy0/aOKeW51XEAiEZk4aeWzOFro7IxrimqbfEIHli8GoQQovVoWXWfJDq19hpfNh3cBsulQi7FpIePwlbIgO3U5VPjJHCFsZzACKSFatkHChUPDbrLLexw6X/fJcFZpZZwN3w3oFiWfWMQXS4pBTh1oqQikqOhHIz1Zlm90LcmMci+N20yRsEdcM1QjD2MiWghq3R6876FiM48ZSTUjuavszb0q7uT6XeXrawYS3qXHnGx3n8Fn+1cBRP9MBQqD+qcudsBWnJA56lHG5IP7uNRBCpKoo62VaE1EYsH5Jk4nIPykfCYXumyNLMStzci4kll+9oQ29t8sPE92aGwvuxmoyLt9u9ryzudgpyfaOETkgJ7Ax8ChO3HEjrsTgRo3ArjgL+uUXeIBsEvihP2DKC7esv6Eg9J7THigy7FuQ9WKgzdv0T4sdKP9IWTFmgo5p2sYGfDZOvuONHno0eQJ0ZFMOuU8UxWshSPJPkSBbBemZbgHbJA1GLdlCuLAYAtmFkVXMkNtPoQKT8Bp7npL1UQ8mOOf1d6l8dIRmVJyre/QR5IeNGIZvnLRbQIr0Nj0RRmqpzKd7E6qNFOoTMQtFkSRAY3ZI7dw1d8ug97b9Hn6z1/MGMcp7LBTurMIVgDiQl76Ej1NMWaAHWneWDuQhi7PM+VZ
 2u9AdOv9
 ni8O1NHTaoZJrzvlnvx90ED4Y7/9cziThWkqTt8KY2IYUgTavLl8OkoePAGA7rfJYNvAohEBr0F7jjjyV9Z+xyApAHNS9xuG90P4QJd0hGBbijyX4Fe1u2KnvbCTYyEOA3qHCvbPHUuYBLTARZQhnZYklgGFl8vulJevmJffrSJvgccVkGx6WvcFSh1T2oA5yDQRtSUka8aNuBDvA9RZ3d6EfQsHpsm/PW4EqozWANgQdLFC5kqJYbPP2fzFAk4THKD3Q/28fbfK75ePBxFPCOvoYd999vJCQz1x2eT2rUfI5tFfoefcMIYEQGVqF5XujTGafdNI9Y3sn9YmguJwOk9iV7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/20 04:00, Abhishek Bapat wrote:
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on their trace state.
> 
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> Acked-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Hao Ge <hao.ge@linux.dev>

> ---
>  include/uapi/linux/alloc_tag.h | 8 ++++++--
>  mm/alloc_tag.c                 | 8 ++++++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index dafcba2f7e2c..a96054ac2237 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,7 +38,8 @@ struct allocinfo_counter {
>  	__u64 bytes;
>  	__u64 calls;
>  	__u8 accurate;
> -	__u8 pad[7];
> +	__u8 trace_on;
> +	__u8 pad[6];
>  } __attribute__((aligned(8)));
>  
>  struct allocinfo_tag_data {
> @@ -54,7 +55,8 @@ enum {
>  	ALLOCINFO_FILTER_INACCURATE,
>  	ALLOCINFO_FILTER_MIN_SIZE,
>  	ALLOCINFO_FILTER_MAX_SIZE,
> -	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
> +	ALLOCINFO_FILTER_TRACE_ON,
> +	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_TRACE_ON
>  };
>  
>  #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
> @@ -64,6 +66,7 @@ enum {
>  #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
>  #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
>  #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
> +#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
>  
>  #define ALLOCINFO_FILTER_MASKS \
>  	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> @@ -75,6 +78,7 @@ struct allocinfo_filter {
>  	__u64 max_size;
>  	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
>  	__u64 inaccurate;
> +	__u64 tracing;
>  };
>  
>  struct allocinfo_get_at {
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 9ff9dd04d692..0d4d267c065f 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
>  	data->counter.bytes = counters->bytes;
>  	data->counter.calls = counters->calls;
>  	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
> +	data->counter.trace_on = alloc_tag_is_traced(ct_to_alloc_tag(ct));
>  }
>  
>  /*
> @@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>  			return false;
>  	}
>  
> +	if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
> +		bool tracing = alloc_tag_is_traced(ct_to_alloc_tag(ct));
> +
> +		if (tracing != !!(filter->tracing))

I recall Suren had a small nit on this hunk in the previous version.
I don't see this change here, did I miss something?

> +			return false;
> +	}
> +
>  	return true;
>  }
>  

