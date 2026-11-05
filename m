Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FE7606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MngWktor
Received: by kanga.kvack.org (Postfix)
	id 554366B05BD; Thu,  5 Nov 2026 07:21:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505646B05BF; Thu,  5 Nov 2026 07:21:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A8F6B05C0; Thu,  5 Nov 2026 07:21:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 221026B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:21:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB8FA09E1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:21:03 +0000 (UTC)
X-FDA: 85400974806.25.0233487
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA5842000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:21:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MngWktor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ap+BVBtSv6IjQ4LBYxkeU2D8YAVNkXJJZJb8NWf8hc=;
	b=FKYpcZurna8Jg6t9wxuS4vMxk9ETE6XCo7pFNtFPNf/gmUakQHoPAWG2EK2mGSiSc/aLYF
	Ui/4HZvh2xyVUrJHZ9rR9bY7XHtnwZLIfe/2e0M3/84PuhG+SNqgApCEuSb2JthCQOHS6/
	raJr8wRVouOywRvZOHi7COFzQKn/9tA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MngWktor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881261;
	b=TRAKYkwdwPfwSCFLtEr4EHZH9rCN/LmLOhzSfptvPe2ND3YZGH2desEf9vM1+gZHrnlYgM
	TguEjNnZB4Y2879ov1s4s/mvyf7XdaIZzWUYd8R3KCQSflQncYtrNXAMCok+tvjfCtdaN6
	YLRWCau/e6YCqyGYub6/Oz43RW8xXag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35AEA60F28;
	Thu,  5 Nov 2026 12:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A3C1F00A02;
	Thu,  5 Nov 2026 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881260;
	bh=0Ap+BVBtSv6IjQ4LBYxkeU2D8YAVNkXJJZJb8NWf8hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MngWktorsLb+QpwiinftfEsFnkYcDIj8O9IjrW1Kns45zoUxewuGS9ZqcYcRyVvZ/
	 9oApPH7sEZCDzjKypcvMOsdmNoY7QA4VHWvMqFmopuBr4XX0a3W7qyidhrZQBgADf+
	 UJtqN8tFvaaG4BooSvryfr5ZpvwscuLtmQBEIsfa/m4tPsz+oLN8zCZ5z+P807f9ev
	 n5rJQJyRYKp+EPl4vcGCEVia/tPPZBLolfGTul84OAj8/imBMKkQR6O4Q97DbtpQxz
	 48YoBGLP1c8VJKfFk7VpWZmKBA2gSilfUBVPjEaM0hmuBxa44ZYKsdmQJ+WJhy0qBt
	 5zjSz0ISji9MA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 457D41980047;
	Thu,  5 Nov 2026 07:20:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 05 Nov 2026 07:20:58 -0500
X-ME-Sender: <xms:pnTsanpdN5G7OBk3gv4JSvcAikjKs_OFAqOeaduPbKoglydPA58Qjg>
    <xme:pnTsanxMkYgcx3EZtln_9aI47VHYL_YdZEiLAcJ7tNfWA_9eIP02P9nKxhnAc5bik
    ZRRt2cKLWDwqn7SxjVDNTBTYlMSfguWcw2_0ZUvbW5gsIxAdR4q1B0>
X-ME-Received: <xmr:pnTsaquqFoWSACz9EF4p5vP4wMWgChClI-ajkZNADGtSqllsr636WR5F5oA>
X-ME-Proxy-Cause: dmFkZTEcri1lzlfl8U2qBExbf5ho7o2bHZLgRS5Mxug9N2VpILPSf/c7htGMDthkiHP29s
    DtTRUBfN+tiWbQHxqmi03twY1nZokTPSlfgnkicCCcQQ54h/5WVrUVHbhNkoNFLECPaOL2
    bdAIb1Wfbl8czydW/efgpINPxDz/TTIxlfBq7e4DRz5dLjf1GVDtaoQbLZIJt7/UHWzm/5
    7IBPMQq828rNaRqTsd3FvACZv/adMmPp6iPtNSbQnNir6Gr/+rWYfnrVJLvI/6fnm7/e6z
    pPqRIZ22rYJuIfi6lAimiXKwo9bkORyT9VqHcYV74NikmF7yXiieFSoc78OOVsi0pM5uAP
    oCB8WBsoZhC0jthL1mshMU67o6qbuKZqtcsr0qz7IYpM1wg8sKsytENaOXPQXJ3fBRzofl
    5gqsdIkmugciX1e0LYbV2BQ8ffG2D+p9JviRHs3YLnZwAJmGFFca9QfuA+z+qwH1fxsUBj
    t+F7T+0NYvMbgs6xcCJJgaQ+zMQIT8IHdKyPuwpEdGu8w9SfNBya1xVYeoQZ/axtStt1Pw
    TkeOU/uIMncWYYyMKrtpEA4Rd/XK3NvP1R/T+rLWgbhocDBulC0+fvhP3ZrMGAeg0AKTwT
    dscZUWFn1WjGhS4Lctg+NF1Xoec0Rr87sBQUXaPfOnzT04RQZuUdPciSSC7w
X-ME-Proxy: <xmx:pnTsak7iOHgz2nFKF9lhowUWk_KaVb7l2PzBzALx1FodhJAA2Y-1eA>
    <xmx:pnTsaqiOeWKSnxFj486Kae_feVMSPM591KvVTlVtwTDobjqBE0mCIw>
    <xmx:pnTsamIWQJv9Mqrjggo3TJtFmQkG8pepjyLtDFgvFvGK_choOaBGMQ>
    <xmx:pnTsaoc6a9_xz0ZJNUb08YItXfGToT6QrEbh-DhxkI1cgQMs7JOy4g>
    <xmx:pnTsauMlRMDdsUUlo9mQRnuXKrGYb86YuBnGfXvH-JzSiZyaiDXJFoaM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:20:54 -0500 (EST)
Date: Thu, 5 Nov 2026 12:20:53 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the
 folio size
Message-ID: <aux0jQpRttwcSz6u@thinkstation>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-2-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103212004.1356327-2-joannelkoong@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA5842000F
X-Stat-Signature: fa4mwq7jog589hwd1jqhb4w45is64kzh
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793881261-454871
X-HE-Meta: U2FsdGVkX18cNpJXfpzLIRxSFjaGklBXPMYV7pFtRJNUn2/Vchh9AJeKyvFPmNNalIvm0XpO0TlVTwbIaYA70xH6Amg11P488c1RT3hP9q/3guAuL5NNQr5MFeaw7zmdwXKC02Mxgkd64hYvM9e9k5Jb5eDVBCiIRjnYoNGCBABY0VxW4D1f3ZLcO5bnnADYOJ+drFnIEqc4J7qII/pBg2Bsn1gs9Tbe0gLa/ZUgy9YV1mX2qSz9pGsT3D2DHx4BbXjdrkF/F+bpBb0Xdndl8kfvR00y14f2gO3qHnyKwTAkH3Vy+ppH0dQ5b33uDl18WdiImt64MVeH353nWEcFrM2Az6pypUmU0dj0hg/BDCvVqq6OWgsyV3+Gy/zKIQYjfLroUDgxEZBIjJu6BSwL6XCzDKn3eN8R4mNwEaYHFI+Y7ntXORvTnp+7LZk7hsYO9DMSc7MpAiITpmiuGC2QR7aj3+iwO72Uw2h1jGUn86HoS1a5EuJO00mq95LpHK3dfZkYJ0uUbrlAk7rBrQzuL45PcH8RMRTN/hgcq0mqe0dmFgd5/g0IMMAphe+qaaGvG7LByfZwBYmF0V2zWLKB/ORXF333mU34AGZSqGL+c7bIf87zMfSTx/5jz9c19GgcCyqIaR9JTaSEx7ERHY2h4UaacM+GTeBUFlbS7E1TiH6vu/tOeZGNHxg7UywckQdSbVePWC3+KNUi7LVLuK+UUKRgwzRzXrEqpcCw/ORtlEivlG9Hah6czZBYwv5QZm4uckyrXDRwos7EwJGo6BqXORbZ1c30sQ80zRa/NnzqObZNGeZRDR8a7falVDCyzIDXnLehkChvvyZGH2RPoQz/d3if5PvhrAYB6FI+1EqDxwA7+AgYCFZkpfb6N8lKif4tXRtncNLU1PcRDbyX1D4fmpw3lQ0Wc0+06pPfK9nStfZhCRKcoCNRDCn4034u23Rt7WmRlaG4t4V814Ln2RU
 DcYnWY5b
 w4jX6JiBVqiztOOK5s3KkU/WmXG1kS6Gmpjh0DkWyvAkn/eCT+DVJ5EhiLiqtTVq2c7IB36YzNngySq6+UiVEa8DCePfANdBXBFWQyfBT70MbtTs76SkceSrXPC0Af0tYUFyAGCxfbXm6OiYJQG6m+1ONNP9v+IzC/t/9h8njKP4J29iF9EBjZu6BDb7X/BzMOugBBpYCDzR7qWWwspJ2fRCNfZhvVWfUIXcMQD6ybFy344M092wXycZ3B3yyaNIJh1Cy8/3gfEuuCfbdXL0UJOWKVeEUFa/+Nkuqq/gGqwaahi/Yb5ZRVeLcoqyxuroxMAUhfMyb96vNFMsfVUVUJ3UHZuXTZg/TA+nZVmZ3pSwNZx3QiWhKcrK3hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:20:01PM -0800, Joanne Koong wrote:
> thp_underused() decides whether a large folio on the deferred split list
> is underused and should be split so that its zero-filled subpages can be
> reclaimed.
> 
> Today it only ever runs on PMD-sized folios, so it assumes that the
> folio has HPAGE_PMD_NR pages and compares the zero-filled page count
> directly against khugepaged_max_ptes_none. A later patch will queue
> anonymous mTHP folios onto the deferred split list as well, at which
> point that assumption will no longer hold.
> 
> Make thp_underused() folio-size-aware, and scale
> khugepaged_max_ptes_none proportionally to the number of pages in the
> folio (eg every folio tolerates the same fraction of zero-filled pages
> the user configured for a PMD-sized folio).
> 
> khugepaged deliberately doesn't scale intermediate values when
> collapsing to mTHP orders (to avoid the memory footprint creeping up
> through repeated collapses), but if/when collapse later gains support
> for intermediate values, a folio that khugepaged collapses won't then be
> split right back by the shrinker (and vice versa) since both collapse
> and split would use the same threshold for a given folio size.
> 
> There is no functional change for PMD-sized folios, as for those,
> nr_pages is HPAGE_PMD_NR.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

