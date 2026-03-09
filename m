Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9A5EFCD9C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2556B0088; Mon,  9 Mar 2026 07:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FF66B0089; Mon,  9 Mar 2026 07:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082686B008A; Mon,  9 Mar 2026 07:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E95DD6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:50:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82E5A1BEAD
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:50:51 +0000 (UTC)
X-FDA: 84526357902.28.870E0A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B28AF80004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:50:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=doD57pDQ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYvkVpf+IuARLiG1oqR6FUltSosrn34oLN70fxLT9Nw=;
	b=RrqiZzAGyESufQLl2DhBYO1t4hky+BgUEg+8gBpgi9MZmHSccrDnvP3FTzURx0Sd2OZR0j
	2E7wbG0sffzCFafWghD8WeltA1ZSAeeaXWqsdm1ZlmY+gDJokbk7neSOTb2z7w3z9hit94
	HKYflmCof2pY+n0AKjdrW0wl7Ky2fhU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=doD57pDQ;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057049; a=rsa-sha256;
	cv=none;
	b=rD+ibR78V6IEcCKV795pfA89n2HVjmFyYz9p9cd6RZOIF3SsiafTkqtGgxT7Iy7/dh2t/0
	sSGuaYvmN9OeC4wTLiPrRV30zRGQF3ZOg70tlxToLKJE49eZMrcK0CPbI56E+xFfroCUuA
	ZzGoY0Ek2GdOzCY3xpHsQDUWPy/jlHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F3AF4414C;
	Mon,  9 Mar 2026 11:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42C9C4CEF7;
	Mon,  9 Mar 2026 11:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057048;
	bh=MKDoMhatF/8bmNy6+4wMS5v8ebUxjWldeMUyNsD//UI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=doD57pDQPBLH+3BvqxHLNZmaR1BBbeo4If0RPfIqWfW5Z9lEi02liWOf9Tv5JUrie
	 ufUKiMb9aOonEeLiXnITDfuCrjFo2knisrJoDRPa2HHhr6g8Q34rbFcr5+o53EhB8M
	 16h/9igRBjHnzQ2hS7sn2zNZnATj63YIOQZ9kLADwIU6Gp/u4v3jiTIak7wA7mfvvN
	 H7N6uwroorzCmuYVAqpQkgzQ1JId2xSIUTWrqXr+DUUMeugtAo2SA2Td2567bFhNnl
	 1sq4SYFMELF9394s1kh9A7kMe7MT5K7PVP5Tgmp8NnZFRSLsW3fP9GfdtSjasR6HXT
	 Cf1PYT7f1gP3A==
Message-ID: <577c4725-7eda-4693-a55a-413572541161@kernel.org>
Date: Mon, 9 Mar 2026 12:50:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory
 allocated on inode
To: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com,
 vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com,
 pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com,
 tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B28AF80004
X-Stat-Signature: kfthhb6bkuybx8qif3ywg1isrrhqe3ow
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773057049-549264
X-HE-Meta: U2FsdGVkX19xBrQ44H4lqT0CkZS+30Jfr0JNlwrCR5XSRWj5Ad3b25e3KEJwc/Y7geFOXW0XsBG2tVziHiuQKcxi0wldaUY0EGr8tkdG+BDya7HLHuV6uq5EIUhE9Sz/EvBOeLP5s69cM/zJ1JiOqCDEEMRdp7vxN/F0g1AkDopMhQgqeM/dEIVCNkvb8NdURCqu8xVvj7Zv1hhdEfHku77Vnuel5U4bs0IuqbZ1cyRBr0rahqyPDGh2fv2j+w4DvNYaw2k5BgfSoQRtwet/mjo6sNXk8uUeFKwhv/UWuJesYSf4R3Lr3O6uPibJNuWkvGjhFgnP0ZVStulj/04/81DIinuf/I+uG3XBnUj9NJKY52F9soF1FX6Bx3ROZEbf3tVnwhbz2mahZ20KQKw+dvL7fj8kUyPOl8Y+N32W46WtqA/AhIDAnIKJDjPCJMlSwx1u/ILEHbq5SqLUtQET7KpdlSvkk2w1lfuyQn3Ke+tr75CsCI0R4pXxG0KFz8ylur7Boqc45A2mfq/4JbX9PEtXfov6WW4DhR9Pe0jz//UP9jop6zt13JJmmU7q9MVjQXXUUy8+nK+dw2cBtLVuDZ5wvIIo1tmis88h1/qqwT9lRrn0BcwXG+u824HZE+PSYylRI/wwL7c+EWGRPhWkRNFznVqQMSKM/0y/mLlYuoyRy74dRDDJxf5V7W1mAVI2jZqGMejQbb9EpJBL1CWTdj2duT59rUscRduCiFIjzTUr4t/564htAqsVA6XdcGjHV85jRIbwtsG/1P+pawMW2YmsUORjN+Rq6pByIPTnKmVgs4GBbBFq7DvU2/QLjf+FNyUmrcbaQz0mmSa4q8ez8RXp4xHKc/crrI/SDHrmfjtsNzxFRQ/AfYJzc69VnshzLYizFOrLNoY1SBSodzmXhhvnowkK7uQ+6OsTU9Hr6IGCRxVav7GiqbHidvUU15dW2RyX1+Lq0vUoxUSAItO
 Z8flRqhP
 lJ3qCIKBJBwkKUK9xyw6uCmm8tOVHl4xcE1HTyNarfhV5QLTdvRIEy9+txG6mDw6FXL58s8wXiLSMNTG/1SBCepU5XMUZ4cN08BIg/INhe5s8fPclpOZVVa9AlS+uxcJkh7TYrOuepaRxLfXGG/0MWZLT8wawvEZf+G6/e7UFgk3RSJpqf7/vy38NPJ9sm3lv2IN25b8IKsk+Aarddk3GBueDLGEpt/wB7GRS74T6tbBIupnu8emkbIsVrUyGFtxN78hIkVLy7gRK4AGdOiBChW/U3TwZeylnrq++QA8jHKaa4aYDMjwB37fKvSyCA6p1Rh18qT8pJVCL4hU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 10:53, Ackerley Tng wrote:
> The guest memfd currently does not update the inode's i_blocks and i_bytes
> count when memory is allocated or freed. Hence, st_blocks returned from
> fstat() is always 0.
> 
> Introduce byte accounting for guest memfd inodes.  When a new folio is
> added to the filemap, add the folio's size.  Use the .invalidate_folio()
> callback to subtract the folio's size from inode fields when folios are
> truncated and removed from the filemap.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 462c5c5cb602a..77219551056a7 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  					 mapping_gfp_mask(inode->i_mapping), policy);
>  	mpol_cond_put(policy);
>  
> +	if (!IS_ERR(folio))
> +		inode_add_bytes(inode, folio_size(folio));
> +

Can't we have two concurrent calls to __filemap_get_folio_mpol(), and we
don't really know whether our call allocated the folio or simply found
one (the other caller allocated) in the pagecache?

-- 
Cheers,

David

