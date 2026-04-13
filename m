Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0399CEBFD1C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3E16B0089; Mon, 13 Apr 2026 05:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574D66B008A; Mon, 13 Apr 2026 05:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B676B0092; Mon, 13 Apr 2026 05:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 372F56B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:05:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C506FC3ADF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:05:49 +0000 (UTC)
X-FDA: 84652950018.27.41E6932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8E7F40008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:05:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YK3lsYXR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpgtCve8hjL3xPoMoNJJ+LKmFLt5HxDZ1V/Mo/P88z8=;
	b=7xlzNQpK8wvMftz1NyzOqd8GDxlRyx0RER8w6NX+O/OQZm3svyMGXM7738IiTuZJiL3ZaA
	AqikR93v/zPTwjbAGqTVMPT/5LAulJ9gL1mlMewtOJpmRzUntHxrqsizZ/YqWEmbwNE8Zk
	Sb2mqnZIzfsgzniVECEIwR4+rrUohZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YK3lsYXR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071148; a=rsa-sha256;
	cv=none;
	b=ldNPk2zW8XVUL/j3BUVAYX2GxJ7NCLFp6E3vyZssWPXiWSB5EdUuXZ4fxh5JH8hWn7/6LJ
	4Ypvql4YPx2luAlp+b42j/RcQTd4+BapvwwtrMeiw19DCnXKlKMGzPrW33OMB7rp3KfC00
	MmVg/FBjy8zAUo7H0B1LWvs3D9A/eRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85F98443D6;
	Mon, 13 Apr 2026 09:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232E3C116C6;
	Mon, 13 Apr 2026 09:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776071146;
	bh=DQqFduPAamuKZKGO2jW+RQdIobu5fatzN8LsyfP2WlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YK3lsYXR2ffn0X3oipV+P/4GaP4TKY3098suUlWm0+GNU2Hd8dfhdYgreIoEOhZxL
	 lVjERpp2u07zM72v1CRseBQTDiWjYnpk/lyXOVdstFHd7hRHYxFrd6o+lvl60jbfQ4
	 6HG/d5hKnntx2hTje7g0AN7+PGtAvtScYDen839zgq0CUAAspL2FKQyOSoiAHZ984N
	 PyYgRu/zwdbvj5A8qhtRQRCR+zVKdI9/ur6VAL4sUiylnzLvQwBzCdj/ICvqjAswOu
	 kYaU5arJTxfaNphn94DUPKb55SbsH34/zW0sLmKAcno/5uRDGJfXVtiiGHiiqukCeW
	 UK+huuMhDvFzQ==
Message-ID: <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
Date: Mon, 13 Apr 2026 11:05:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E8E7F40008
X-Stat-Signature: irb7697xkkmnw544d7gqx1r4gkxjx4py
X-Rspamd-Server: rspam06
X-HE-Tag: 1776071147-61126
X-HE-Meta: U2FsdGVkX1+QEROhLQ3RQON6EveKvUZuXdJAaQl3g0Hj6Uaq2UQGwVK8foP7gB7KgG0jrydDHrweogKHxpj/hyxaXKN8MjIYomeuyE11nH5REkOHZpL2MOb06URzFjIH6NdZutDtG66zua+jb41YsHW1uFk7k+fsXNhCoguC4R1xIX2jJ+CSuR6Qa1S68fK/ELvaEvGEBX2pzbE3TX92Hm8sq5vhatidUvR92tvP/RlexOs0+c+ohM+TO/wjU/slt0FogZe1dQY8ykJw9ug7fRkUc7qGbM7DYzPQ1FV+YBvqwfZXwffIs0R4zJU84N/3BsHRji/BzhEpPnn7b5pg9GQc9ac/5Y7XDLALirEcTxEo9WFC61tAFxMHLBdwziCATmmgQqLF+ajMqzR1UNLfJuVdEbi0V+8d+8e7GXkXwp7zAwHp4MX3XmvFoQSH4RRoDyuYziLVXO5PCMfdlUUCPhzppKRP7NFpuTUBBnDXEz0hLCnjsCDt/5Zo3iuXDoYUxEtD0oAEjsZcbntnOGhW7ZZUSegTwt9sj70ZMQcV+yc/+gJgdMLUnZKEp0Ks5LIYoluEc8LAOz295nE9gvCWdS6kOcN6UJ4bDsBNkAG6MM++Wp9MWmFRamSiek+oe1SyrUjzQ+xY7xhgZRwP+Lupu3KCjHciHyRZ+7v5ccEpvaoAHkwAa7ePODQOqsWdrh72eDweY6539noOL3ys1XsVYlO6TfHjDoAEvfDuT0ooFrI2jGnAexOE4imyyjlKpH+q4Q5IouJ7YFV9Y8yflLHLJZA8fJWFoI5BpxjXUAX7pYgNUe41ZUrgvHbaXEyRydVavHeOZMNOJA+ckV6C6qzEkpkuEt1f53nLGZQUGTf5t5BxTlKWb45x/ntdbC2vHFnXZXezMLovQQBu5ckmUgqlhPbvNJxDcTZKZk93ENOCcjdbsoldNgyKJVshmSxZekhJRxavB2ivzpl3nUuiXCG
 PhlDL0Xg
 sFLSYT8SxL14FGUoD0tUmf5lEpHhb+QIPPEyVqKMLzdXCk1F+tKj9Oz1o9cky5pASWND+cmMW27BlSxreVJxfyjz6heccE0XiQtJg3v7aXy5aegPFa/2Tqu0YrSzmcZyG3LBV9DQleMksffjkBU931r8vQJzkGpt0ZewoPgEt3gFifipNMkaRxXYG71h7X7MFsoe7EcBFAngb/63AZW2b4pfzOSr+797kLa22PeLypng/ijveUZCybolIALykY/DZnFH5Z9obbPts4sHNyD7Kfe6IfWAPZVQjUSadihDrVI/3hHvdHFVvai6Veg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 00:50, Michael S. Tsirkin wrote:
> The previous patch skips zeroing in post_alloc_hook() when
> __GFP_ZERO is used.  However, several page allocation paths
> zero pages via folio_zero_user() or clear_user_highpage() after
> allocation, not via __GFP_ZERO.
> 
> Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
> preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
> caller can detect pre-zeroed pages and skip its own zeroing.
> Add folio_test_clear_prezeroed() helper to check and clear
> the sentinel.

I really don't like __GFP_PREZEROED, and wonder how we can avoid it.


What you want is, allocate a folio (well, actually a page that becomes
a folio) and know whether zeroing for that folio (once we establish it
from a page) is still required.

Or you just allocate a folio, specify GFP_ZERO, and let the folio
allocation code deal with that.


I think we have two options:

(1) Use an indication that can be sticky for callers that do not care.

Assuming we would use a page flag that is only ever used on folios, all
we'd have to do is make sure that we clear the flag once we convert
the to a folio.

For example, PG_dropbehind is only ever set on folios in the pagecache. 

Paths that allocate folios would have to clear the flag. For non-hugetlb
folios that happens through page_rmappable_folio().

I'm not super-happy about that, but it would be doable.


(2) Use a dedicated allocation interface for user pages in the buddy.

I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.

It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
all that.


For example, vma_alloc_folio() already gets passed the address in.

Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
folio_alloc_noprof() use a buddy interface that can handle it.

Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
do what folio_zero_user() does, and only if really required.

The whole user_alloc_needs_zeroing() could go away and you could just handle the
pre-zeroed optimization internally.

-- 
Cheers,

David

