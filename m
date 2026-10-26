Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9D7606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UiY0D2eS
Received: by kanga.kvack.org (Postfix)
	id 0C5576B05C5; Mon, 26 Oct 2026 05:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075EA6B05C9; Mon, 26 Oct 2026 05:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDAF6B05CA; Mon, 26 Oct 2026 05:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5A726B05C5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:56:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B7D8406B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:56:00 +0000 (UTC)
X-FDA: 85364321280.05.AE3FE99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 95C5C1A0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:55:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UiY0D2eS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8im7+ey/5FnzNCNbzYMW8gbmtzOtcHIHPfyk276y0gU=;
	b=VG50vXh0NegYM4KYbkcVj25hl3g+yaRv8SupozBr4cYVf+QPWWkiydWBE/wTkpBw8UovJm
	rMNGL8oDXLj7kSRZDuAFV7Lfle9U4cvR0hr+mEog70fpWVDWWsYUfCEO7NrzZI6diS3gQJ
	cx/M95Xz/g8phelDLN6UcnxGq4wNO6g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UiY0D2eS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008558;
	b=CWlZBbl9nA7khm/Vw57aIuPOxdHdTtuRCDxZfmwVBKELvAum781qvXGBxhNzlpL9eqRAHX
	E9TOuRR9/oliiUIUVzZ7Xg2bEAGf9xy7xhw1l3DvkZdTlX7p1i6KMPY2HytgKmsasAEWZ7
	z9ozr6WzskuraACApQeOGkEgiqnSjGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2316B6024D;
	Mon, 26 Oct 2026 09:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB9C1F01825;
	Mon, 26 Oct 2026 09:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008558;
	bh=8im7+ey/5FnzNCNbzYMW8gbmtzOtcHIHPfyk276y0gU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UiY0D2eS/zDLciz8jMBU34fZpk83Z6KVC2QwvXn96fSYJeb9d7w9P4RqoPp1v60UK
	 fxFbKWz5eT29zmVk9M6+FSI305SzGr67lQYe4zWklHstJQp15SvEPvGugyfIpl/rvY
	 CH7xq96IxVIiwp6WB96Ei1GnyegMhj6IWVAWMhOJE6uqByr0fpheeFAMt6zbv6OJqH
	 fFAqttiuxUfty801NFhA7Xyu3ziO5woaA64HFjQM8WeonkhVM2asDMZc84TIIUcZ4Z
	 xnHtQcnKnP3UEwLI3gDpnwsRp5j+i6t9q65vHiwXaiGoazVlMfX18dbEEx7cG72qUr
	 l1B/QHQxRLAQQ==
Message-ID: <f28b2414-ff07-427c-8e18-e950b492b351@kernel.org>
Date: Mon, 26 Oct 2026 10:55:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>, vbabka@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com,
 wangkefeng.wang@huawei.com, tujinjiang@huawei.com,
 mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95C5C1A0002
X-Stat-Signature: uptjm7wch51haekw68poessc6wqy7yma
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793008558-166120
X-HE-Meta: U2FsdGVkX1/nF0wZCYsYolzzw1Ez4KglD9QMUmSreG2zuCsby9jLpaFgOXG4/y2WlmXQB8txfnA1qpX7mMsQnz5ayXU69pH5HDc2JidF1E/RQrHBmocrnoEGd8KT3eb/D+bnm5s/NYcqyeKQHePaTgsVClZ4CL3jcGnkA1uPvzJEWdXJ6KdEtC9HGrzyK1N1RtT2DfUFWIHbzdmyXRuvl2R30wbGcrESI8waiO4GW9SgZHSUWjUtMURxGvgg7k21hl8YXFQ4JjuDxSwfyqzT28FP3TtNYSlz13JKx6MjdxiA1lc6duMQJhtcQWfeziNrC5nIPQ+yKFNKEzBt0KHgEJ6zau3KT9V9oJqqiNqFRPpJ9ru2idMteoI/3xwUPG/8nAoRtxcqZ/vdCbp+2EploA1ebbjm/2Ag7DE2HJcCe+l5yK2U2QFj2lEOwBNrp1jvNliEjkqru9mjEVUNGM3UetDupAoCCTVtSi2ARvATEfXs9J4EEfQxFb9S40MOUhh6WoKF0qMljvKt2qP1IlAl21DUm86ayiNIlJ8StsPDNEFcZ4oGmRjPricEmhKW4XFAb3rqfQdTgb3C+6QTtVOsSWlJsRDtkhOQwjPtI15pD3t7fQZVy/yfEFskavkXNOLdIPJQFmL42QRV3zZrQDRnc+zx/CQeDc59PPt4nIzuMkSwv1/Fh94HIQ2ZIxdsaPamldaHJedcTASPevyN8I/18/7fgmzWtvbxG1wKHco9Kw8xvte2ilN0zEfO9ddATZSsIuUVFGz/mOJKwjd1AZFdzgMTPW5nilYsXTlPcgVAW4FkhkvPllkV10w9vuDMwSOnRrctywucBS3h3gtRdmVCzbdegxfS1qhypi6VI5GU7W0Y6Gf8WRCJpYyCe0dTha3fygvDwZMHg6ZniNJPBN1sLVNl4P7Nc35wft5I39BiRlgcxI9gNTTLFrkazdDHU0wCMsOM4vztoHZWu0SEFwN
 LcIcgewR
 UBRf3Q6VvOqsVz60F1dJke2EQbYhFdqYMIcKVmBxRX9aOzbBNsAERMQpQ1GBB9cqmQfVskJWehNyq3+MPf8teHumsB5XSkxwPDpnYOmyMQ/bwqfSbo+WKBZacOhO1kx8PeXiDUrL7PCE+ZnbtuC1Gh9pu1EC+SUmgNmFyq/QYhBR34Nfp27EFffB5DWOBCPDOVp83wFKuI8Z3VIfFLPICwJ8/rYqOVxDmzKHeGrOzQ6QdUVucOsInEr6L5RONEEm+mIkbFgEObv3fVwGvqbGbRxSitVQzxKGBiUBcpybdeINa7MAFwc1SWBcAkXyaAIKs/9/xAcoQdGYwRRDVnMVRGTC8dxYbAU5IpAr3P+w8zGm2mAlCsGhWAhcG7eif6NHFdLy29t2SYpfSMDJBKuHSshoxHkOvdJllmQcILhjCK+Zy3rbYEPyomq5C4Wncw1kwK0K7mF6f+sseAIvr1/DDS+WJpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 03:57, Yuanhe Shu wrote:
> Where copy_mc_to_kernel is defined, copy_mc_user_highpage() and
> copy_mc_highpage() stop at a hardware error during the copy, report
> the not-copied bytes and queue the source page for memory_failure().
> The !copy_mc fallbacks return 0 after a plain copy instead.  With
> PG_hwpoison set while the data stays readable - software-injected
> poison (MADV_HWPOISON, the debugfs corrupt-pfn injector) or a
> transient hardware error - there is no fault to recover from: the
> copy completes, the destination folio carries no poison marker, and
> the poison is consumed silently, the same poison consumption
> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
> THP") refused to risk on the split path.
> 
> Check the source folio with folio_contain_hwpoisoned_page() in both
> fallbacks and return PAGE_SIZE, the not-copied-bytes convention of
> the real copy_mc paths, so the callers take their existing error
> paths: the COW and fork paths fail with -EHWPOISON, KSM and
> khugepaged abort, and folio_mc_copy() propagates to the migration
> core, where this composes with the separate migration-side checks.
> On archs with copy_mc this code does not compile.
> 
> The check runs after the copy: a check before it would leave open
> the window between itself and the copy.  A flag set before or during
> the copy is caught, whatever state the data is in.  A late software
> injection cannot have corrupted the completed copy, and a synchronous
> hardware error takes an arch without copy_mc down at the access; the
> residue no flag check, before or after, can catch is corruption whose
> hardware report lands after the last check.  Closing that would need
> architecture support, as discussed.
> 
> The fallbacks do not queue memory_failure() on refusal: the flag is
> already set, and memory failure either knows about the page or has
> abandoned it.

There must be a way to shorten this description.

> 
> Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
> ---
>  include/linux/highmem.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..f90f0c6204a4 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -474,12 +474,21 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
>  					unsigned long vaddr, struct vm_area_struct *vma)
>  {
>  	copy_user_highpage(to, from, vaddr, vma);
> +	/*
> +	 * The flag can be set while the copy runs, so check after it;
> +	 * a flag landing later can no longer have corrupted this copy.
> +	 */
> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;
>  	return 0;
>  }
>  
>  static inline int copy_mc_highpage(struct page *to, struct page *from)
>  {
>  	copy_highpage(to, from);
> +	/* Same reasoning as in copy_mc_user_highpage(). */
> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;
>  	return 0;
>  }
>  #endif


As I said in the other thread, how is copying data that was already poisoned
(and might trigger another MCE) reasonable?

I can understand why you would want to maintain the second check (although I do
wonder about memory barriers ... hmmm).

-- 
Cheers,

David

