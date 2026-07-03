Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE590C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8736D6B0190; Thu,  2 Jul 2026 21:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB456B0191; Thu,  2 Jul 2026 21:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7114A6B0198; Thu,  2 Jul 2026 21:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 412056B0190
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:18:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF41A8CEEF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:18:58 +0000 (UTC)
X-FDA: 84945706356.07.E7C6A32
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB3B1C0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:18:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ud5qXez2;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783041536;
	b=nKHRFKZ82s4wxCwhJFTuYvp45HZkyq7G9yUMm3ZVTnkCNiBZ+PQmbZEsI/lqY9F25F7nht
	l7K3Ts4quiv9gorNWPLUQZn7sWKhhgEDzHOopxyjVIZkimb9EHZLH+KNJqDOGa/2F5Jvib
	Kv5Uo2xHiltJoZArdb6PdFcbCWNXEXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783041536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlaYEmM5yHWyRftqrh5OqWf6FKrbWtq0+ONz8K/Op2E=;
	b=ZhOKpeGhf0nWhZdAr7x28VTdMu4SEp4XYTQ/2E86jSmCr7U/wAvEX7uDXojfcZeNRSw6w8
	27B31PoohNu+4j3HLtoDdfOk5DurePw2uO/Dnk2DOycYNQxGvMvOXnCnweYCovFMzAEPT3
	RA1K2lUbybSOHR2W6n7d9sxr95zoqQY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ud5qXez2;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783041532; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vlaYEmM5yHWyRftqrh5OqWf6FKrbWtq0+ONz8K/Op2E=;
	b=ud5qXez2mSTZPv6BZHW5vKeX9VZW2UXE+TW38m08kXt7ATiUaFsO2LSMx3cvXYg9cR8IcM4xl0NUoagIflJAbuZGCGv3vzDWuhPgf7AXd7dzLG3IXtRDIdGcFC9i54eG6Ue3p0q7aDEsC/YtguUN8W3Gh8QrEx/xWFvl6oRHjSs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X6GuTEm_1783041530;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6GuTEm_1783041530 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 09:18:50 +0800
Message-ID: <918c72ae-dd3a-41e9-84ca-164f2e0e6d01@linux.alibaba.com>
Date: Fri, 3 Jul 2026 09:18:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com,
 stable@vger.kernel.org
References: <20260701174235.3173401-1-riel@surriel.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260701174235.3173401-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oddaffthkcy57xraiscnuubnt1q4w9kw
X-Rspam-User: 
X-Rspamd-Queue-Id: BB3B1C0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1783041535-773157
X-HE-Meta: U2FsdGVkX19fEhLImDItgAdifHKWG05gAIVFkUM+ixO6U9tjjzOfcgYWhx4IsnLKqv7Dn4gJ65D4gn/7MprXvg7urwdoQehhQvc2i3GDrIE81BItzNKLjQ+77cZQpkkqEA6fvqZEaw/kyUPHHqm7wbkQe7YJ7YpX1ZuLCYvdVGB6Mo5ObjB8J6YwBkfYXW3M2pNtuIXQgRsXR7Tdfg5sxHMwLgKis5AVurC41EstVXBuk3iQk3cl5yuQAcwzrzHa23+mU0JmC6kF9DXM5fTb2BXAxPN7v5Ue9FPJI+baN3CZ6TxRbfYj23GCwdgiQNV9OEjke/cuVoKPmdvgTkSIVtulCeO9t2Cr2eqSqZzQ0YNdKlg89+jp6C4Uui+9jo0398Bs3phrp74KWeh+xYm0guS324wxN4aO1lbPD31BKVadS4eEID8QwKPVUcifIFR2bwBf2L+0lavB3qUMl5/w1Thvbn6xZmLgZ+io4OdIppZukB+fhMvKaXVIgU94zhPg4qBjjwiYUgC58A0VvfPV837PiPGWYchvD0RB0AmJtgN5jacJgcm5j+CNdpnKI4Km0dqbwlyb43H0QKQmPqtKDdPfzyki2IRJW30XzyLHaaZLo/vL0+JskNDwaMsesv8LtDwaUhTrwJbqUfH8jTJeeqtWhdCpA0WrJCe+EyBg+ILYIj8LQAsobdMvpM845RD2kGcxxnbjhlA5LtGDRGh7MVJDBAq9/gCVHptQ2qASNlQUOXMcKw8jnCRy5I1TnUuBX2VbgTGhpMcEBdAXQQytqM6JeVj4ZV9zr24GPv9FWLq+V0U3c1ZD/mDykhqqObOErPtxHzN8QbGsHTCnRjVSVq2fKGfNI3g/4ZTq6kiwyHEK24fR2jigCGutTk7IMRsroGdiF7bgoc7+hw1lk8etOtspQ/MQpbtbRqlXeV7sv+/i33ZQjhKLc2yl+VeU9G51o9LQgCU6nT1lXgJdcu7
 v7TCYYTd
 w5ptygnImlhMYHs1+FIg6qx79bXFwGyIIqr/EKneEg79/tgDCSQMiFbi2zHJYdRch2Y9PrJTIlB2V7FzZpm/aoTbNbXxsimXNJA5K5o+fqhh71aemUATMAx9iYVnPx/c6aLRnNCRlaxSA5CEL3MaPjIue4zkpZplL3NitNCQrqqh5BPWg+bXU+ds/iXqT2AUvKrV0g0ZSF/yBXYjxduYZN/bb68HgerGDe2rNZ8CcUcg/4jf3nt/HQYqZF13ZOi2CWE0LOIy2Xc9oAeQjC1UWZMn039NOlTds4EQD1PyH1T6jrMlnCJSdlmn44AvOw263WIxoGgbzuvJFur6naDTZv2QZD0KH30SQy6rzlcSM832PnLmOBLVLwp5CLGIaXp27RzhDr9k5XJPV0kxoutWcwezANdmXl18dBEwABjRm56SZkxL5GRLzKXdYX9OmQPXWpTW4mRPu/Xh6rsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/2/26 1:42 AM, Rik van Riel wrote:
> __split_folio_to_order() copies the hwpoison state onto each new
> sub-folio while splitting a folio to a non-zero order.  It does so via
> 
> 	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
> 		folio_set_has_hwpoisoned(new_folio);
> 
> *before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
> turns @new_head from a tail page into a proper folio head.
> 
> PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
> resolves to folio_flags(folio, 1).  With the new compound_info-based
> page-flags layout, folio_flags() asserts the page is not a tail:
> 
> 	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
> 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
> 
> At the current call site @new_head still has the tail marker
> (compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
> this hits:
> 
>    kernel BUG at include/linux/page-flags.h:354
>    folio_flags+0x82
>    folio_set_has_hwpoisoned
>    __split_folio_to_order
>    __split_unmapped_folio
>    __folio_split
>    truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)
> 
> Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
> folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
> splits the partial folio to a non-zero order.
> 
> memory_failure() tries to split the poisoned folio to order 0 first, but
> that split is best-effort; when it fails the folio is left large with
> PG_has_hwpoisoned set, the case fa5a06170036 added this hwpoison copying
> for.
> 
> Move the folio_set_has_hwpoisoned() call to after
> clear_compound_head()/prep_compound_page(), where @new_folio is a real
> order-new_order head folio (handle_hwpoison implies new_order != 0, so a
> second page always exists).  The flag still lands on the same struct page
> (page[1] of the new folio); only the ordering relative to compound-head
> setup changes, satisfying the FOLIO_SECOND_PAGE precondition.
> 
> Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4-8
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Cc: stable@vger.kernel.org
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

