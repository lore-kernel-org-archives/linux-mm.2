Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B12C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D92D6B009E; Sun,  5 Jul 2026 22:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A276B009F; Sun,  5 Jul 2026 22:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F516B00A0; Sun,  5 Jul 2026 22:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51A016B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:18:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1CF114025F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:18:18 +0000 (UTC)
X-FDA: 84956742276.17.25E98EB
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id A91E9140008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:18:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTLy58j1;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783304297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNM4IcxFKNqiDM5ljWFmkAzvvwWKz3AlHXSb+fCuWM8=;
	b=Lk2MN7wUCh3LNMUkci5GhVRWNK7Y4Fy/YnmNqyVNVosNXv2WCnBv4FzKRDOCwfczJFh/Qi
	QadftvfKN/CaFcp2xxPcv16wQl9LYvgPT+RyATyFng0Z+xc7ZtQD89xWjuRjOVo/LG0ufC
	tFxpAe5FRUSxOESP85MPNQ8Mz243Nxc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTLy58j1;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783304297;
	b=prbDnLgv6cnon32eQycAqF5DF8mu+JWB2Azw8aK1eahdxMa9yftFBvaJrm52DB4t1Pa5fM
	XZ41jX4h51cLjtGBb6Acm4QDG2p0z+s+amwgriV1DEtBCJwDV2z7Fh7vQe/c5WrrmA5Koc
	Vn9RdtiOp0KlMN9p2KqZ+wbhqxiaB/0=
Message-ID: <eeb3e66a-c140-4347-b86f-c47da2cd9886@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783304294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNM4IcxFKNqiDM5ljWFmkAzvvwWKz3AlHXSb+fCuWM8=;
	b=cTLy58j1EvgFx5vcjFvTMGe0Af738rRAdqG5mFMbavAEG+KGEZx7UB5r1NDq5x64hfV/pY
	Wx8Y956AY9DFRZDeK2F81DpjnG3TlNH9xeHKxaKXUOTmElUspPtFeK77QUnPurG5SphNGp
	ZB79MAuvfm1MqXKxJDv+peE7szuKY10=
Date: Mon, 6 Jul 2026 10:18:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>
Cc: aarcange@redhat.com, ziy@nvidia.com, david@kernel.org,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, ryan.roberts@arm.com,
 npache@redhat.com, ljs@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 sashiko-bot <sashiko-bot@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 riel@surriel.com, liam@infradead.org
References: <20260705131231.1499198-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A91E9140008
X-Stat-Signature: ud7ceysap7ftd3ns37dx77uwx1uyn693
X-HE-Tag: 1783304296-953425
X-HE-Meta: U2FsdGVkX1/DJ8tv3oijTeVbiE0aBe9KnN2h12pbpCQfNPPA3KcWQ28FtFXz+X0qGN2he00IKOLqWhQv/hP7HhtEASV5b6oQzs8L1GK3HI4orM1XM7CxAwKFZwGfyaDwKSmg26JAOqCAhY6BYI1CWVHbQcvd03XVSoGsEe0ZtF4yUuSfox78FQOzv0Cr2oUkclt6qK0Mu/cqZRaoDav0IYNvZfxEsLOTdxlxYSzqxupSIHW3BZHpRT8jAbeyg6Larv//OUQyMfx6VhK9vnfQwV+0tBBsNdrpvP1zxsgsqcGvN6DINxEuA/FZ/c7uJognjque7jqziOsfMyB5MBBmtnCVtO93OYX6jZG/D9Ip4FVPrTZOFo/lpmdhSE/X/441qNFaADsP4y+iQ0JQyKL46c2ZQvTyPNW7cTWr8YGjOR6YqGA4tPG0PQxXhgNTzZ0qzKiNDfmLixsyO5wV90aDBgKDPuaZAx7gEtRmPe5HdxV5+FB/vAMr3ZJsypGgbrp2N6vD0Y2lrF4j27YE7o9gKMyRie2nJ/+0h+rQKqJ4UCazdFipYdhagdzEE0zRrOPUuSyWPvQ1kTl2B46YEuRgsnANaDdglzjlr+D2XGBY+BfNCuzd8A7ZvzvrcsFBXaGIPfrlD+kfnRhXPrvNQrwJL2g1LfKP75l0KyLNbOMvVOFWQn62oCEWEgcBnKbQg5U+AmMt2gcs1ncFUNv1DZR6sbb76WnKSdVbSuEY1TMwFdqaeNHRsNPGfbrMoivN8fZKXJKiyPMKCar/cTKm66k1MwpuCeC/flhe5fqdxEXnDPWJFnygpTAuWgENoe2juu7qJc2lfrkyJB5PlKe4JS6SE+R6TnvAInOOA7KhqM6p86Uk6XyCnwoCjz6zkCnWd0LCKGiXneBfbibYRA6YD4W3KHPX1w2AB1bNytYxIiXRhaIIipJc0sq8OjVzx374ov9nDc8f4lvUIWA75M2jgwe
 x31V9jjY
 xNTCtHPmItDHWqHL8Q0X7SWyhWNV1GO1IBSJkbWBJ5OyWNxPYdsD7Fwa2UQACc+/XIpA34xM19+EgJ1NAmHoNl51F3tRYA2NDl3Fhb8BVsd3fFe35dyv+LZLPZGNdQgPDze4ytJRHceq7mmd0XgopzIqoNnUfWw6YXOrCxhphzdbN1xSl6O2HshHzK+hQzc4GJzwgJ0WvAqi2BN0Mi5ZXXtGdlFvnMukbUAgLsZfpwV+Y4rQPLfpuMjGBczS1ridFO+buBB9Iblt+F4eO7LREaSRjmCfTlZJtoQ3k8GceRPkg/nEEYG1LhqubyxGiJKxi4aViWrah3El3cp9qLb9rrELGFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/5 21:12, Usama Arif wrote:
> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
> 
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock. softleaf_entry_wait_on_locked()

Well spotted!

> then waits without a folio reference, which is safe only while serialized
> against migration-entry removal by the real PT lock.
> 
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

As Andrew and Baolin pointed out, this should go to stable ;)

With that,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

