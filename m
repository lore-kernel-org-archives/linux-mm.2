Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EA5CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D476B0088; Thu, 14 May 2026 05:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3DEF6B008A; Thu, 14 May 2026 05:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D0A6B008C; Thu, 14 May 2026 05:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3AE6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:13:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6491B1C0E30
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:13:40 +0000 (UTC)
X-FDA: 84765462600.05.17A5E3C
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E85EA0003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:13:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLNFRT+s;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778750018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbuPzwpDrGD5qRtFoBY7gLw9d4RHmDm8yrKE2duWsOs=;
	b=WQXvwkHv/8roUdK6J3QQf0U2AVedpF4p4XSqbTg6EOwItn5Y11YcXUW7CTJ78ZpNduJmxT
	/6Z1Wsvdy0UJGDSjvEZmfGkaqwjzL5HmjiEu21RexAh5/XP2S1/nzmDlAxWp7k8uDvn7re
	y90c5E2jinXFfgjC5gduMGlbfph05fM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLNFRT+s;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778750018; a=rsa-sha256;
	cv=none;
	b=bjbbtSeeu4ZWefSX0I2iIEHf2Ixp6RwwwQFeyHNy/92YVkXvy98Bco5L44TMvlmbbpmqUY
	L1OzIMb/FZQk4JP9OHEIwmIoOFsqSyHym/xEKdGQda5F0CINZIfbKK58ysxif/ths3yrP/
	2w0M8O7mGwfiiPrLGLdBgYnEVz/+2vU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778750016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XbuPzwpDrGD5qRtFoBY7gLw9d4RHmDm8yrKE2duWsOs=;
	b=WLNFRT+sSjl7HYycGm0Zu9mjheejdUvJL3CBrAbnQL0yawyMdCtbjxl0YOE84PJw4v7Tq1
	Z7K2Zc52ghFu4skhYoyqdP6c7rAJJleSpt/OfaZNk7CxYeBta7GFglsjedV52ZsBXP+afh
	ke8bOWKQjz1N1g93KJMo/VdNfG3fKwA=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: linmiaohe@huawei.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	nao.horiguchi@gmail.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	liam@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v7 1/6] mm/memory-failure: drop dead error_states[] entry for reserved pages
Date: Thu, 14 May 2026 17:12:33 +0800
Message-Id: <20260514091233.58243-1-lance.yang@linux.dev>
In-Reply-To: <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E85EA0003
X-Rspam-User: 
X-Stat-Signature: 3ic6y85sqfpgna7orb4efepep6ssi81f
X-HE-Tag: 1778750018-918365
X-HE-Meta: U2FsdGVkX1/5kXHOQZelkzZhsDDvRhSSoXGjf8NA88mfaR7Pz8AHCdQuQjxQQBoqn1b4AfAwK8P+cH5Lojf7D3P5sJn1lw/jfBFxzsj06I4L8Sa++Qtsf+63ckHAzMdnJ9ktR3Yb8EsPWFCHYcGBrFpu3Cp81rfdWqD2iMP46XskwB3jMpIoUe9JReP8DqjFSuMOPI/92ZOnCK6rlP8KboxT2IwT59J9UymVO/XNuAnDZTuR/LDVehUZl6IHVEUOP6rmzFPiRXbPn9+ksascxdlvH1Xt1k4PBzfD+8fBE81Jmb7Bu+PJu1xQMUaMnuq6niMtL0zzc8Yq6gWOOHWbOMJS5rgp1vPYsOZYaVZ1jj8lD4CtKlF7ELb0nZOaEJOvHa3BHHZdHY1+dxBLtXn8fDdYWAR4bow+R8JUnjW96TckEWiDxgEI3QCS4Zr44CB4ZTTHFcHlJdOKTQG6aBOEzaEFPs8N1NmX8KA2dC6hgkexAtyJQWOXTB2BN7AO+cL9Shgd/Hyjnff8HBFw7DQbMBxI2INRVAAzHYB3C2TLatNnzEs42jSaxThfpRO51SMn47paBScOL0NHIt7OSUGVOWiLCABbNjFltZ8lqtZo2iX0L0PS43pC8S+3I1ERbZF+0KzNtsklxvKegRtcyj8lrPN8bydRI5m5acdJXOX1Ci5T2H7NW6kwzuOhV6l/xWTSc6HmBPos0YUyVIgproZJkESWjLIHyFiA+2cWoO1SFLID6OyBlcNxojen3iJuNNJJcj3lv1PJ5LQJ0oXnkP/kNmtlXiWEc5CSlA4PDRDS8CdFr8o6j6a4HpcBWqbBuRMVYgXRqSGVQW+0naQOICcywv90zYOTb5YN9SrI2eCmbl5z3/QMLUQb6+AGr37nc+l5szsgv9UiC2/bh6IRPnCjvBeH4qsH9ZrfGfvhbl1k9+yvRnCa7sQVo3Gd89uQIjbq2vx0ZKJMGyB7z87Pi/Q
 2bH2JPP/
 ukpQotRUn+u0I1fR3wz5Xg3BtfYAkGdzxqy6v3h2qHQdU+2PLG1jPlRQuuDeP3ioTBWAL83600uqOuERJ/MfteyYaF4dPMcfjxvwuX69QenyBV4VMBOE/xbmHbsKHxKoGF9YWvkP6+L5pxFxGNA9mIPxnpogSopbf8sldS87HF0pYzKx9U0kVOoIokqLKADbyfba7OIlyBCfomXhSNymwQFpbqcBIratQBCeCAZu7gA0MHGkKYe+NuT4ibUqrN24MhrFQFL4kid7YsAtPmFs7xSZKrsxD8vhu4CaBCvcRBvHOFX1e1OPgq5dlR/8oRzlU/aBH2kZ0pAEJp5nmMtWrSlH7+Kw+MGYeMhqmqHS+QyYWplEGb3jOAlfUuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 13, 2026 at 08:39:32AM -0700, Breno Leitao wrote:
>The first entry of error_states[],
>
>	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
>
>is unreachable.  identify_page_state() has two callers, and neither
>one can dispatch a PG_reserved page to me_kernel():
>
>  * memory_failure() reaches identify_page_state() only after
>    get_hwpoison_page() returned 1.  get_any_page() reaches that
>    return only via __get_hwpoison_page(), which gates the refcount
>    on HWPoisonHandlable().  HWPoisonHandlable() rejects PG_reserved
>    pages, so they fail with -EBUSY/-EIO long before
>    identify_page_state() runs.

HWPoisonHandlable() does not test PG_reserved directly; it only lets
LRU or free buddy pages through:

return PageLRU(page) || is_free_buddy_page(page);

So this really relies on PG_reserved not being combined with either of
those states. I would not expect that to happen, though.

>
>  * try_memory_failure_hugetlb() reaches identify_page_state() on
>    the MF_HUGETLB_IN_USED branch, but the page is necessarily a
>    hugetlb folio there.  The first table entry that matches a
>    hugetlb folio is { head, head, MF_MSG_HUGE, me_huge_page }, so
>    they dispatch to me_huge_page() before the (now-removed)
>    reserved entry would have matched, regardless of whether
>    PG_reserved happens to be set on the head page.

As David pointed out, hugetlb setup clears PG_reserved before setting
PG_head. See hugetlb_folio_init_vmemmap():

	__folio_clear_reserved(folio);
	__folio_set_head(folio);

>
>me_kernel() never executes and the entry exists only to be matched
>against by code that cannot see it.

identify_page_state() is reached only when get_hwpoison_page()
returns 1, but a PG_reserved page would not get that far, IIUC :)

>
>Drop the entry, the me_kernel() helper, and the now-unused
>"reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
>remains part of the tracepoint and pr_err() string tables, and
>follow-on work to classify unrecoverable kernel pages can reuse it
>without churning the user-visible enum.
>
>No functional change.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>---

With David's comments addressed, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

