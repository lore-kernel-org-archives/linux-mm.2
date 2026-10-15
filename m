Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91693CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3126B009B; Thu, 15 Oct 2026 19:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA0D6B009E; Thu, 15 Oct 2026 19:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7536B009F; Thu, 15 Oct 2026 19:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9966B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:46:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 222C1A023E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:46:35 +0000 (UTC)
X-FDA: 85326497550.25.D387E39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74CCAA0008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:46:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knPQqBoa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107993;
	b=b5L+Ejo172ebpM4xRu2unMwjpo2C8iZlfAzpzy+cCpsL3RRDQzwnLupJo+cVBZwx3NE7J4
	YcR/AlTMbV20VI05sQX7iCIwF/lRA3Cwks3jnOs6RvC+7kIoGZsNsH+1YMSwX+dJsgZbQE
	mPSr1t6AWLp3SWguUANToSvVdnhQ8ds=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knPQqBoa;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEyBJjOxNHoPN44Ocnab3KH7ph4eN7qBE/3bFv4RRfY=;
	b=kaqInUofU0MU0WAN7VOPKEEQdx67AFrBshQk2SNgUKgMduTRqeDcGipiodlRDxNIhS5AsV
	zQmQpajEfRnnWL0e3MiXtPDQcvJhFIpiXChU8NBQIbFFHb6Bjs9kiA4ar0D42hXBrM3XNl
	HFNSJO7CZhYllwLUd6iMxfF2nlp36B4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A062643DBC;
	Thu, 15 Oct 2026 23:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243021F000C4;
	Thu, 15 Oct 2026 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107992;
	bh=KEyBJjOxNHoPN44Ocnab3KH7ph4eN7qBE/3bFv4RRfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knPQqBoaOSqw1cr48QtzRQ/zK7rsfJesZfj99LIFjlhYY5GL4GRM+09iaRBEacJOA
	 PpW4f89PVRrRa1qaJMXKjPxyYChpmVbmMarHlxKL8oubRYUGRHaf4eTi1eoAmfcs/A
	 z+XALiNhJa4Jg7YLKsIC7/UnO+1MLl6GYroHZiMEo7kmvWSJB6qdNAZTnRBI4GuWST
	 qI/h0y3dJZQmFPfrNNM2OP699l8jk4oH+1CaLnhXtKpUprYoaVt+q3h/AEY48e/NUN
	 0e3CjIjs4puKXlP5mldmRCGiUCT3VzCtNW8QX6wleq3YP0pLnIWO2wHU8yHoGXwDbr
	 mH9dRa8rPmzVw==
From: SJ Park <sj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/mempolicy: convert mempolicy refcnt to refcount_t
Date: Thu, 15 Oct 2026 16:46:24 -0700
Message-ID: <20261015234625.113115-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015231322.3392551-1-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74CCAA0008
X-Stat-Signature: 5jehyqzce7btxee1b48iff94t4xq85nw
X-HE-Tag: 1792107993-838120
X-HE-Meta: U2FsdGVkX1/ewPez5/oiI9sUQ3lDMMs+X85AmgEYJkOLFqvvFjsRTJ/jMHfVBrCs2EKYAdIClfhdvzkEnilDTdzs+1wCi3lHC6PJWG9F6sHm+QUyXETIvc1RDkKx9m8dsivrieAq+PSAaWOLg9TLOrjV7jobqfFANu4cyu3W480Td2my670be3WartgqdA+8UKDj3OJvN6MNffnQ0PkLVsUilfg0Blt3rqFpsskuM453siKF3e7ntrmL9I9MXDImwdqHIWU2vC9fmxYnR+yW6fRay5IUZwDBuX/QteOILM1kV+SK9wofsmq911szLpEkALIfo2HtUoJ3tl8bGJ8l42WVZpuFUHJb+qiPkloNfKKYh0wFOaANvFcOfO+Tqz1rRNsDq/NBhAWlBoVqOorjFwg4PiO3TRTbhmp1u1OOyjuPhXsWGs+eFjjAIP0BHZwGIP13tiH6ZSDaXBCgIGNUSGjHO4Un7pBVddgaR39hrSBVRm9U9Kfx11XtabTOvvwmLjgY7Y98sx4xHPPBHxXF+4P62+62YnDc/sfX5Ijel3Hr32VRwoctUpIlPyhx650QwQvi4nInViNzu1DdxsRsPmJql1VWa/WqFWbw/fUmm8AwrPblZaITWJOLvTkflDnoZQI2nlOfDmzILMmETW8IGD0EObXPJRengPcY3ocYA3nCJgYQraHlEhm6Ga9XCq6Iq3qALMGQYQ/emHQx0J54ngeTfhxUlh8YJ757AbW701fDCyFH+wjHtKb6dBu2e4uU/jl/KGFLh2+/BQdM2wQjKXfJolkjuWtaKpjXvz8/IoiUtvi0hh7s/ICLLWmSdQ9QrkBNvj8vBebhAFOMUgYrsCXMsfbWvJ/5MmIEAZTBqAnCm4surLarqZWSNeYycmjHy1PqTmLQ3cwcxdTJ17r8sf9sztdMA+TRSNOIcXYo+5Ja3f/KPZ9rSz/JUodN//rMczlkFjpga+SJXexjXyc
 8H12k22j
 NHqWBtlgqzzANAPmkbhIm9IAe36ssc2PCsgJ3qCiXodxo9bsAuA8LOGB3T07ZUeUTtaTo/zjWKGrR0g2tWJPaFUbjphPqeLrMsmC8AgCmcCZj0k3M4/dbRBKZBzHtB8m7QUjjD85q25ert7x3XbVhCh63BdwIWLBu+Gcsg+i7XHg7r+iTm59Ep2rul1nVRUYxpWqwT2mRKz/YEbTYuqpwmQGwOXUWpxkvcrKOSu6Rk2dYsOQOFi3WoWvGEPI0xM80pBKkddxEfRfRHV1AcDVkgFWboz8k2LJvKnUa+bbrKpn8vD1BYi4smb8Jiqk3rY+ntHHxfP6CGsO0jvMowL/zuzmLFvQMnb3kzClyHSgj7decTsEM9ZOj03j0I6ZeCKrRmmoWwCel/4JtXvaVLxSfjYaz3K1TQVWF4f77ABvh7w/5+mledd6NSkEsQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:13:22 -0400 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> struct mempolicy uses an atomic_t as a pure reference counter.
> 
> Convert it to refcount_t so that overflow and underflow are caught
> by the refcount saturation checks.
> 
> This silences the atomic_as_refcounter.cocci warning, which started
> matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu().
> 
> No functional change for correct callers.

Looks correct to me.

> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp@intel.com/
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

