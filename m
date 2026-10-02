Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D47CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1367E6B008A; Fri,  2 Oct 2026 15:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E79A6B0098; Fri,  2 Oct 2026 15:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0DE6B0099; Fri,  2 Oct 2026 15:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBE906B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:20:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5370C1C39A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:20:09 +0000 (UTC)
X-FDA: 85278651738.27.40630D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8AFCB14000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:20:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CII9ekSh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzFmsSVkeCy97WxyINiQisvIqJaMnwHQuvksDREcAwE=;
	b=qJodSmYFQ7X3OG8ToxOaEVz8a6OsPTT05u/OjVHb0/7YUyvDcxuRPtzAx38hFplKSWYSru
	J8cjq9qMsPZniL0T6DQ31gPXUri+TFmbvd+6Ht9I6YuEN1/EljCoLmcWznMJbQqk2uoN8l
	KsgiuF2aIW3bJEsfDvLCzyxlX3+RyeA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CII9ekSh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968807;
	b=L6pz/LDULrXkQvIyvGZnZ9k5DTZwyH01GjV4YA0wMV19LnlAhG5p272X9c7egqLyQePLRW
	cs0TP1XthebH7hQTi0O553u4HK/xzBmB9WWr/1tAgAiXaEXn68bCduQPzGS4voT35bKFYM
	Mx1mFY0rFV70mFa/Vf+/L6Z8Z1BBNSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB15B60AAF;
	Fri,  2 Oct 2026 19:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D941F000FF;
	Fri,  2 Oct 2026 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968806;
	bh=rzFmsSVkeCy97WxyINiQisvIqJaMnwHQuvksDREcAwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CII9ekSh1Hzs0DATXI7TPU8lfpCl4qGrIZIv7vv08EPDHPME0G6zTDYtXXlct2M3R
	 f44u+Zm6zxptZs3rSqfGuFL6xJbFc0iNfYIoBMLe1+85zzdjPlezGvg/BF/Imb8qxR
	 O3ECp/R+fr58tJ7uLTDfnNKZFlYFUW99JBvkXlnZhQVxfElvfgvzm5MwQnRPXsb0sl
	 sc93cQ+1TJDMeGSUL0CtiiegzlK2TEYVGdQpBRbb5D1cRG+dngL4R9QrRWCXvKv1A4
	 UALDcrHSYRygtm2rJjj9fToOsdzZwrJzGpvpdVLL7B8bLtvJXSrvI2cGAPkfndH7Rn
	 YleleFz1Y6SsQ==
Message-ID: <fd486bd4-c166-4b46-8047-0a777b239d01@kernel.org>
Date: Fri, 2 Oct 2026 21:19:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/14] mm: debug_vm_pgtable: use
 pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <e7edf7e42f88d361c177e1baa7e2138c193f0805.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e7edf7e42f88d361c177e1baa7e2138c193f0805.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: khs3mheit64pudg4wj9o46fh64k3os5c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8AFCB14000A
X-HE-Tag: 1790968807-427397
X-HE-Meta: U2FsdGVkX1/xHl2GGR1i4N/uUWFqvBP7WlAxtR0btcnmWyS/HvCZfVyGgAWvl3m/Nv4k/Ol9jETvdnUrSePJiltLc9WCHktAcYqXNp0F7K3Hirwpe3J+nDiuQWn5phstxclFrd/bySA7mWEcg+4PIdgH+IzOw9VwmSN61R1sbtec6sEsbxspwZwtcpvCTL86OAhYlZOwYuG5knLH10HltrnHp7NO0l4XXwPaznS0dFmLBvPNqtKbor/DN4Rf/T5DX0DKuMt7fblWgSTswj2AyOWguFfB4CChZm680hZRaV3lThKJiKacfYtmSiobIGsc2A7rrTea/yVs+DPv6z+YHCaB6QaTQcj12s5+znE2iz9tbsLUjlRIK+ZBe3xrbxaaMBcmI+bqu0xTFFt9hq0cl6mATxOK3rnHD1k/Kho5W8TSoJj+ajoQPGxfxDgc4lC7vVmKcFVpOmUfxatVUrrdxJ8g/8caAUARLFS+yxXQJFATTEMVIHl4FOi7CGO8IhJD3flnp1f9tJaCzczfkMqAvM/nR32mI/V5p4IjNOJwEZPtGWCja0lGMdi2q+eN+CMGL/RmFqUULwJEuLPIkHJURJf1kJJpEALGHVINCt/vV0hTc4G4nba+MV0Fqadsszh/7LVcGZWTOLLCbVh0coITgRaIPLiofuVhelpMpHK/wlDAC8ge7RJrfkQKGtr2HZPrMvHDm3FJReNeyETer6/OD9xtEen3YFzk5WVGxIPn4vAK/PjPCdfLD+rODod7dZ9GiZmuYSFKp8gfd9owHpNzbdHw167XpPG/CCDQMk1PXL8Ebc5158nVVnyxfYRyaqIFEQari0/7Lc/WF0lQceBojokd/YYwnuOWRwKgXBDnodxkFkOfs7/Hjf6/i/7Bvs4VGt0mTuVml6TAsz/8GGmdzeWfhGDzaTC3Xa3366aFrk+gfGS8YxdKljQHVf58R7GD0PlGL9sV68gQWNpe9sB
 jSscg+p7
 fGwG574hCQKqKBCIdF5HApbzD9g5/QlsgXSKxXz8PVeDDte5G3e1Jk6cVaYyEloIxtKR8xTcQR+uwNug/BbYCOdY+VvWQ+6mOP/Qcyx2vZ3oSbGB6viRSv59ZZEu4YmrGze1w364oRBdIMkryZlAfnCsnGxFMXFV4XfEEd8fpSk1tFte8O+t6lGtgxFvGuVrd4772vqhZQJJraJbwll6BGDxbisj9HN+XK62XzYgR9rf98V9vgvR/R8hSv8pal4LEBBeGtP/nZUJCXnIQvKmmN2VW/gv3G5Y3H/Ved13EPcUIBDl87UEXyQwCJZ9E/Yco+XSxvOqmY5KWhXWIR3SzzSG6KW0V5oFBOzRDJmS+GYITXqlGqa5WdlO9gp2+mg4DD0Ac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
> check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
> instead.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Best to mention in the description that there is no effective change as all
calls to has_transparent_hugepage() are predicated by CONFIG_TRANSPARENT_HUGEPAGE.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

