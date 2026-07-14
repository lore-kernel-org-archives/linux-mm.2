Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71426C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AE76B00EF; Tue, 14 Jul 2026 11:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F76B00F0; Tue, 14 Jul 2026 11:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6796B6B00F1; Tue, 14 Jul 2026 11:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 390986B00EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:42:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE1284044B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:42:18 +0000 (UTC)
X-FDA: 84987798756.07.4B431A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 02CCD20004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:42:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RCn/6lhz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784043737;
	b=wwTsqggusBiX7kiRZP/Cf86NweAxqiCnp6vqK3o/zBzPGwt7e6WQueNsVWUsN/0wD+oBgZ
	eIGosHER3J6IkAcCnJBwlaqr/eYYqPZ97f47lL7Neg6HyWIw6SY462SUp+U5PXfXZdJ8pv
	7jxOAykrFpTO4CDuNd0r1Edg2L8hOaM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RCn/6lhz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784043737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hw/GZ8sZpK+8U70Cy1Nb/z5CpTUfbrL8cZQu/aoFn14=;
	b=FFGv7t6Kq7bC2Iu5C6Jm0XRxQqM/Ee9+vz3NC0SyLWgdKWM47K4R3VY4vTuzacZhBytHN2
	UqAYPPnYddQff0I+AsVijdZVT6MNJVmeFDjiRF6X1mKmTf/lV+Uf6/ljsfHGbxEAqrizoA
	c4qN0Hi5RhqsWEHknPsakUC484/+T7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB37A41A34;
	Tue, 14 Jul 2026 15:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB9D1F000E9;
	Tue, 14 Jul 2026 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784043735;
	bh=hw/GZ8sZpK+8U70Cy1Nb/z5CpTUfbrL8cZQu/aoFn14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RCn/6lhzugIh3KOvzkWnO7fmMiOJkMPuoc8O5LC40STlvH8RA8BR2h3NhLhJfwAON
	 kiMgkZtg7EYfgTQz/GXzTzXHjTTquIaYTwkMT3jJXYDh4VmBrNW1xvC3wcv2lgfMN0
	 xN/+i1QAN47zqnJK3Mrod5M0XzFdcMUkRDh9QXOYi6BKW0yUGlhcOmfagnlUCa82nA
	 84DFV8yOusVilPmKvx6kOhOlpzgVnSXs1xI5apl7ZO99oRWByskzZHl+kKBuLq6V92
	 1dwDlmXI7TCErdZ4xRmRrqwuJMfJy+HpLDPUOj97gUgvK/UGb7RmJcCe9dfTKsgD3/
	 PSClyydLsCITg==
Message-ID: <ba47a92a-417a-4ea6-94cd-dafd5d33ac4a@kernel.org>
Date: Tue, 14 Jul 2026 17:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02CCD20004
X-Rspam-User: 
X-Stat-Signature: zo48g8x1dsiaiafota8cep4y766aseo9
X-Rspamd-Server: rspam03
X-HE-Tag: 1784043736-631141
X-HE-Meta: U2FsdGVkX19R3YVDbpOKvk9nyBKLJW5uQl146zDieBYAgnDo1RrzR4vmTsY4rQc/8HxJyalEPhutnoL8kaR7brQbTjXez3SVE7OvBrZnvyRU1QciBd4oOXZZtdJ8xd8MDaA9lKP9BVBFdjAyVbgNaBSJtIT10ijJ2qxOEIxdWWfkpqTRJMe2f4dKPwfR6AQMCDywokCtGpKOdoB/x5Ycs0dqFPxL2ntmRIxLSl45EiEimRnUIfmUqUqDEk0wLnQuYhgwA6z5HvlET2LaNH0+78qVeXkoOBOhv1z7nCfNeAjdqV5Iu6WRCcGMFuoxnIaSD/MbLafwMYnz7jj2e+nf4ZJ6P4TlQy3CYBMYQEOannC6m3Sd2+2vU1j4Xj9h4nqaPqL1pxo0nFym7lVbZwqFCALQrtwrYxd3uuO8TKfD4oP9uPfCRlBnyi4/hELtjezxb4JTQtnYUrFWznpai9x8SkNx9+aaJIfmlE7t4YN57v7yWwgDAkKLRjE7t6lOhHJWmqqiJSfwN2uVSvaOWib6aC099sgWautZxS6Up1AdsU+JLhiWHSrssFT0snoekwHh88Q/VuRVLEnkdgx6hGW60OL5LYOF9GhpLNWdcqDXIkEqEVTB48l/BVRJExmWgWdur4jRm+aoC37N5cR7UvcIMsj9XGmPiDhOds14eiFmihslAm7bnkJgJTZf/Vn1YIbvKm2/t2sqVHn0+Uw/u91Sj9YvFfrfgjm8JNKjysNOPfsQxfQMt1Ncj/qvygL0dTfcPhgfbmfVJSa+Kp7cOa/5I5ohOlivyLdPgJPO7N112UcBq/lOvP8D62Fpph+s3cdXfKjFDkhZCJ7DR0Rznl4cKmr+lVo49gykPqGLPFcnHHFBjoPxlgjuIE3TR4wI6sOGjUJnZCYD6TQodJBQdp+uj1x9bOFDz/fo5j/ITy4ukmS9d1aGG/RQq8McsLLGOpMD+0zKfOTTQBD/W2acL0X
 VL0UMAFP
 +H5xQagcONJkq1E14phVIHwQZueLSrQioZ8fxn2xgI0bg7vIi9eWF+LkgS08DgLICx7bIYtvfcHYRUGqzVR1P6Jw3Y1Ax1Zd8PbG6WtXyA1kj13QRgCK6v5HwIivEDoh+x9vMnQ+uFcwD70ZC7NpesIfOIVbasirh0trBBJ0/LmHKRXOXb7AT9mzwNb1zfHdhZ/1oircJvXG93GlqXzxMrUn3DLP7hWnqueTR6FJ7GS6oSizMs6NTfX94Wlzz1qQUbmJxSl5loDHPDmYbxAUSDw6hjIifPaH8PEVjF6SD9WecdSdmdmJkPGXMKlrifUQaz5yWVBF7d4fo1L76NkmCS0Pdit6e9PjyK+O/IL/XhH+jpvQA4FqmEUU7k5JuEJxjlO2yoY2tw5IDvPAQYqguxNGegeRII0vuNJhk8pa7kITBnC+AFN74Tv+tdA0xFPrrlo0E0sRx/i25u1xT17rXmbxcVAlAriI6tTTlmceYK1yApWMdfLEKvbS9/pwntIjso1pXHR/soi18C4C5s9LNrDHvp8TiNxnAKozThmFAHCFamzarlhlxw2aITK50i4Aa2J9ICAFEWOGYxquq9T9+enUDUrvoyY9T0+Mp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 16:28, Harry Yoo (Oracle) wrote:
> This is a follow-up fix after the recent discussion [1].
> See patch 4 for the detailed description on the bug.
> 
> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
> git.kernel.org [2].
> 
> Instead preventing cycles by bumping up the allocation size of obj_exts
> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
> disallow formation of cycles between kmalloc types when allocating
> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
> obj_exts arrays are served from normal kmalloc caches.
> 
> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
> sheaves for those caches. So I introduced a new slab alloc flag
> SLAB_ALLOC_NO_OBJ_EXT.
> 
> To avoid huge confusion, I had to decouple "disallowing sheaves"
> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
> 
> While this cannot be directly backported to v6.18 and v6.12 due to lack
> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
> particularily challenging to backport it. Instead of a new slab alloc
> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
> kmalloc caches don't have sheaves in v6.18 anyway.
> 
> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
> 
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v3r1
> 
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Hao Li <hao.li@linux.dev>
> To: Christoph Lameter <cl@gentwo.org>
> To: David Rientjes <rientjes@google.com>
> To: Roman Gushchin <roman.gushchin@linux.dev>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Hao Ge <hao.ge@linux.dev>
> To: Kees Cook <kees@kernel.org>
> To: Pedro Falcato <pfalcato@suse.de>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Danielle Constantino <dcostantino@meta.com>
> To: Liam R. Howlett <liam@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Added to slab/for-next-fixes, thanks!

I've removed Fixes: and Cc: stable from patches 2 and 3 as I don't believe
it's the way to handle the dependencies.


