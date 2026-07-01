Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C366AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BD86B00AB; Wed,  1 Jul 2026 11:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E8F6B00AD; Wed,  1 Jul 2026 11:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FB36B00AE; Wed,  1 Jul 2026 11:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1BE96B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:25:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59CF6403D3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:25:35 +0000 (UTC)
X-FDA: 84940582230.26.13E245A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBB0B1C0008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:25:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sjCG3GIb;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782919533;
	b=KFxYKFeulvq6OCJGUafsIrumi7NYCAj0NKVqYDryG/ZUBJL6zDlISanuDZmONbCMw7tcrd
	IB9yL2x8c2O+6itfsTFoUSPvD/GSXs8NvxMg+vlTdYkj7jstpvg2HjGY/6E5cB87Z+44ox
	RDUc6E7OhAHypsWuFUaRwwRtEuOs4DQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782919533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7i2gxVfdyLMw0EmDv5vkqlxZHu7upnqw28TbwSHmLg=;
	b=WgCIBsESOWHI6uGoCS8o4XRuWZ5r+jEMDzFit8XY/+IG8WW+AlyXm49kT8lmVo8WVLj07g
	D4xW2wvn8MVpLGc5dH0e675hk4CEZ9sTCEi5Z7zJja0in2dfOz8BSCOLdcgUtFsb1Twf4K
	K8yXuAIOFsTZSHG0bVEFYi0p8CnfJE0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sjCG3GIb;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782919530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7i2gxVfdyLMw0EmDv5vkqlxZHu7upnqw28TbwSHmLg=;
	b=sjCG3GIbFnGZzS/i7r3lSRl+vIlTgGaZZaQyALM04jublH7FiI6uvxqzlgaoCSbxGTug8Q
	A6MH6TB6uDQgqhlaLT+z+xdj5MLy0+FyZQohT/e6aaw6ezoAuMrLA9vFENdJ7el94AplnS
	b4Q19qp1+xp63ebDSC0U5B2Wc3Ymjm0=
From: Lance Yang <lance.yang@linux.dev>
To: riel@surriel.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
Date: Wed,  1 Jul 2026 23:24:57 +0800
Message-Id: <20260701152457.29836-1-lance.yang@linux.dev>
In-Reply-To: <20260701134622.3152896-1-riel@surriel.com>
References: <20260701134622.3152896-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBB0B1C0008
X-Stat-Signature: hgkiy14c5u7mrgoame7b3ffxdf58yxxd
X-HE-Tag: 1782919532-964101
X-HE-Meta: U2FsdGVkX19nj1V+ftdToH7qbsYLISY7+h76hOFpTa2tqJFSAVPcPwzGXybGAj4fbS9PEGf+93RInTGB/j90ThBEHBShGPnL+TIn1RnPAUuUJA4u70KiDdAaA6PDJBXZqBiMtMXKUQOcnLhq5ivTDMGQHD+AqOz6bXbeh+CFqxkzwXhBrFIGuzNRnVbH90SCSI20WLhaRyH74qsrMlHx8rAmAeRGs9dzuf+4ZBuFktaO+7woMQNniapSefuzFj2dr49w90eVuGJpwTbbftq9+aLzmGwVYw/FQ9mwNkizJDok+/rAwPoWPaGVDt/LsLcVQGpEkh7f9ChLMQUNZ2MDfgOJ7NEtayoX6KqGVJ307c8MsIFaY8ex+tkya7Ym3l5P2VlhApeVkglo/hNV6e/AqXINSafuOslaE9C815OypfPkf0Khjcg6ClDqsdW97w/akdtNcXl63Wls+jEGzKproYpJWRoIwVNVug26s69R/h1fUepEizvxwpARtFRSv+itbWrqEXP8ZWaqCFxDhoY3bqVUMeQksIyqNlEVGLoSe9eYghVFVOX8VhRwgNIMSkVm5+0/NFb/R06e4W0Ay2W143Q4erazZeHxnX+cO1wRbeuu7gjYXJ037D1z5thRmtYrPwaXfN+KehobYJA6UvwEvhe/fhxwn2/MjRcbUKeWEQbW+pwpEbuF9lhs3xxbBXxh5u0mTPBMfCPbqo7/aXWXmIT0HRL3gHBBU96/LT7/uYOtAYQnS72aypiaz/dtd0Jcn3Kdl3+q3m95zmON3azedtgmHvRSlwV12vGrfb7h0l8QYRYsmW6NuMX+JL/dPJkRb1Xe7YCSJj5XnBA0Iej+W9XnwU+g3WKTLV6lbh625RUheVewD9eC4ax+6XXdts+W9WspMtZAx64We6UQrno7tTN4hSOIyANapbj89CuYxVe+KAvLOQbTYHGPClV5edkH+FamW1dRb4fi4Y+K0u0
 CWP76pwz
 SU9OuDAz3SaO/gq4i9JVuwg+wl0rt26Yb2QLvmdenRMfNsjSNa6RSlLKs5ux8/0m4HipfEalEnN8s3nv+5wDEPXgEry/xV3XU+D/5UWMA6B+61JfPi47mAHK3XPv1I0WK1J9x+9HNO1wsUeL57ZYd6dov1rjZkVPF/DGaBXpwBdZJhz0GBn9byTsYURvY0az0zC3DUHjrx1i6P2uvwdZu+VlryW4EOBMIVwPsfFhKjz9ngEndWqPzJHuhqQvatO9LdYEJYyGLKaz0Bd4aqXhTvf95TwnyTYKA1nLr3UF8tOnZG/mHIgvxM23iEsWQEz10VOBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 01, 2026 at 09:46:22AM -0400, Rik van Riel wrote:
>__split_folio_to_order() copies the hwpoison state onto each new
>sub-folio while splitting a folio to a non-zero order.  It did so via
>
>	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
>		folio_set_has_hwpoisoned(new_folio);
>
>*before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
>turn @new_head from a tail page into a proper folio head.
>
>PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
>resolves to folio_flags(folio, 1).  With the new compound_info-based
>page-flags layout, folio_flags() asserts the page is not a tail:
>
>	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
>	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
>
>At the original call site @new_head still has the tail marker
>(compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
>this hits:
>
>  kernel BUG at include/linux/page-flags.h:354
>  folio_flags+0x82
>  folio_set_has_hwpoisoned
>  __split_folio_to_order
>  __split_unmapped_folio
>  __folio_split
>  truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)
>
>Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
>folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
>splits the partial folio to a non-zero order.

Hmm, a bit weird ... for shmem, hwpoison-inject should call
try_to_split_thp_page(..., 0), i.e. a uniform split to order-0, no?

So MADV_REMOVE should no longer see a large poisoned folio. Am I missing
something, or is there a syzkaller link? 

>Move the folio_set_has_hwpoisoned() call to after
>clear_compound_head()/prep_compound_page(), where @new_folio is a real
>order-new_order head folio (handle_hwpoison implies new_order != 0, so a
>second page always exists).  The flag still lands on the same struct page
>(page[1] of the new folio); only the ordering relative to compound-head
>setup changes, satisfying the FOLIO_SECOND_PAGE precondition.
>
>Signed-off-by: Rik van Riel <riel@surriel.com>
>Assisted-by: Claude:claude-opus-4-8
>Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
>---

Anyway, I used a local split_huge_pages_pid() hack to create this exact
situation: a large shmem folio with PG_has_hwpoisoned set and a poisoned
subpage before the non-uniform split. The BUG is gone with this patch :)

Tested-by: Lance Yang <lance.yang@linux.dev>

