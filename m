Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF31108B8E6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF07F6B0088; Fri, 20 Mar 2026 05:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7D76B0089; Fri, 20 Mar 2026 05:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05826B008A; Fri, 20 Mar 2026 05:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 907BE6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:57:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42D2BB514B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:57:38 +0000 (UTC)
X-FDA: 84565989396.18.9B93D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7FCE1180006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:57:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faRKfegr;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17+bxUnoJSJptwa2pIR2Tg+VQthaMVj0JlP2Z0OrXpQ=;
	b=QaQO0omFkRARPe22yS1ixoXJ62JbI7l4VJg4L9+toKjlWQNB6A/cWWvCgi45O62pUApKzV
	kceQBdm7hNALMbRNTzsTXQxgFnvqdJD274LcRwGh4eE0q9ahFuPbvY1tijBT1xBP+4aZzQ
	iw09gVcc8em+ZtL1uatH1Eyc5JYpu9M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faRKfegr;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000656; a=rsa-sha256;
	cv=none;
	b=5qG/q4ANEDtKp08z2YhgldenX+FZoRRkhtEWYXJ81+fF/Jocu38bnSx6iM5SE93JwbjEvS
	xgkLSx85GJTLmL9ZwctylbT3CgQ9MPl9HDg+YnCCkt3teWmJ7hKAp+pQWUlMn02GTFMl96
	hiNHB+oqL1rg5IpLnJVBS8GfpvoU7As=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88F6F40E27;
	Fri, 20 Mar 2026 09:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD33DC2BC9E;
	Fri, 20 Mar 2026 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000655;
	bh=eQHM0cMk0bk6hcaAsXZf+kEdl02hfFJFbkEBU2evZ80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=faRKfegrvHNFm4Q4XTSWBSPjs/jwEbU7mUZoXm37RPxN6FUsBr7stLh8daDacLzOk
	 yoi1zE8dLo5AQ++0CZIlyGB4C+1+GGyFcIbsSWs6ayX/OTseVRFn4hLgWDSSZy/5TT
	 ie2mSYN6KK6LS8zGqsRF338SBht60LnAH7R/IAq0UdAuHjGWWtZp+NTYaQSyOYXOFb
	 Kcd59Mdkj0APxAQZ/onqPFUanqG/rhJfJzvN3Y9bo4YoxiUNvw83uwbF9EwI1pE4R6
	 UxLwoEojC/mMQ1QrLlOdLvfYaVKRboi+IwgwNM2sHAd96ypdJBl81UL2BtouQDZGIH
	 ZObTJmZCKqn/Q==
Date: Fri, 20 Mar 2026 09:57:32 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	baohua@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
Message-ID: <b5e99cd2-d49c-4653-8d0e-4ccf35b4a288@lucifer.local>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
 <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
 <37a204f2-796d-4d15-b21b-09fd4a9e77c2@kernel.org>
 <f6e30243-8253-444d-9665-9dfa33eda9ce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6e30243-8253-444d-9665-9dfa33eda9ce@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FCE1180006
X-Rspamd-Server: rspam08
X-Stat-Signature: dpkdypqdnpdowr8b8thgdo6i4rpit818
X-HE-Tag: 1774000656-937751
X-HE-Meta: U2FsdGVkX192jLCSk8Ec8eD9h3K/4iQVBbxywP23RiRrx9iJov42E9Pl8yghNGIs6BSC81hlEe401g9X1zus8rZwZ2bfxdnN4zGFBpkoBj32w0zpSwNrfUWKJdTcAbSnm2ORepLTTpyJsCxAZDVDgu/4u/s1O8XN1WqMNs8LyUKimoJOJHFXGhs8F3CAVpuocQ+qCnLWrVLkJWu0CDjLWi8iq3TkaA33Vq4wxu2DeXRBE8TaCa9XfPuUBv/t6DyLsvYYskAMfCbqtQKeLhqpaNwZHtdtOva/GAE9D0/Uc83AVqYff0CT6PkFXI94eKMfWvLrSTxx1Vim2M6/w4zr/dm4phRTKXoOTjt0hoeEqoVWh8Bvs2ARFyUQo9MjCoVfa1uGPNtHO9SsXOjiWnOALv0LpCFmQHn/tIXwY8EqvEZo+ZYjOkctYBVLJ9EU2rdwyBVU9m9xw6aK/U+N9RY9gdvzN7/LniwMBT09iDk9rEjK0peHyihhnHJUpITBw3jQ6RSK9vSjN3IPeZqFh71O8a1zHK8LHAjFyzStFkUNat3laaVFen0Wlw0jwgPfj4BaMrNFe39Zao9/16yWJQLybpD8AFYvJUpQiZvS+Zyui74JHK6xRYGPh1q8clQNXtGZrHkciCt2iU+I00KtEKTS78B7ym7fyzmLElWkXxacJunXLFLv7/UDGh3mbJ/Hq4vLuARPZXkHPAdX/B/FmcbsPmk33j2VYMS0Y9mQ4f2IVIYYR5pA6Dmm6jdYhDq5td4uhTxdI7qeuALhUdKYdrs4QESADcdwYHcfiVTjq5Mi5sNLU+DZMX1gR4U6/JOQC4y5b2GaQGidscWScZGzpX8g79yQV7ikjz6rXygbrsbMiCgEMtWG7G4aV+fWan/gX++d8kBIaWDInkuunjBDYoX3Qg+1myipnF+2DUOKtir+K5MqrjS8nJLNIvl4kasm9so3csENK9iQ7QOP756217n
 C83NEUTZ
 4EQ3M3JT9eDFl5w7XWhuSD4s2aYDidgg1meAenAT4iWDZM1vGq9pGZJdlOVTV8X2410jUbY5kzb4ws8bfeMf/qVp9+bR1k/Q2VYGaCfEZtTv6WxdI2/38zKlr/406rcTvh53YsH7mtFjVXUhRkS16AH3+SKne/M6wM8XxdlWRpFDYkCEIFGD8/+EcsRzyUcYFWQOLQ7cPJm3TBPHFzHQJnEgXda7fVdw5Lc/T3kv6E5xiwpoQqczQP4+UwzrFpFGXLiasbN72TKSqoxg/OV3x99EGJhy0jADYSa2tNyyAsurMu3iSMNEW7BmZrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:56:57PM +0800, Jinjiang Tu wrote:
>
> 在 2026/3/20 16:10, David Hildenbrand (Arm) 写道:
> > On 3/20/26 02:52, Jinjiang Tu wrote:
> > > 在 2026/3/20 6:51, Andrew Morton 写道:
> > > > On Thu, 19 Mar 2026 09:25:41 +0800 Jinjiang Tu <tujinjiang@huawei.com>
> > > > wrote:
> > > >
> > > > > On arm64 server, we found folio that get from migration entry isn't
> > > > > locked
> > > > > in softleaf_to_folio(). This issue triggers when mTHP splitting and
> > > > > zap_nonpresent_ptes() races, and the root cause is lack of memory
> > > > > barrier
> > > > > in softleaf_to_folio(). The race is as follows:
> > > > >
> > > > >      CPU0                                             CPU1
> > > > >
> > > > > deferred_split_scan()                              zap_nonpresent_ptes()
> > > > >     lock folio
> > > > >     split_folio()
> > > > >       unmap_folio()
> > > > >         change ptes to migration entries
> > > > >       __split_folio_to_order()
> > > > > softleaf_to_folio()
> > > > >         set flags(including PG_locked) for tail pages    folio =
> > > > > pfn_folio(softleaf_to_pfn(entry))
> > > > >         smp_wmb()
> > > > > VM_WARN_ON_ONCE(!folio_test_locked(folio))
> > > > >         prep_compound_page() for tail pages
> > > > >
> > > > > In __split_folio_to_order(), smp_wmb() guarantees page flags of tail
> > > > > pages
> > > > > are visible before the tail page becomes non-compound. smp_wmb() should
> > > > > be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> > > > > result, if zap_nonpresent_ptes() accesses migration entry that stores
> > > > > tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> > > > > page before page->flags.
> > > > Please describe the userspace-visible runtime effects of this bug.
> > > This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio().
> > But the impact is bigger, right, when callers rely on folio_test_anon() etc?
>
> Yes, the impact is unpredictable if CONFIG_DEBUG_VM isn't enabled.
>
> But for stable kernel before v6.19.9, this is a BUG_ON
>
>
>

I think important to note that the asserts are asserting consistency, and not
having consistency is a lot worse than a failed assert :)

I'd say more so that you're solving a race between folio split and
zap_nonpresent_ptes() leading to a folio incorrectly undergoing
modification without a folio lock being held.

Cheers, Lorenzo

