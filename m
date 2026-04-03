Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC40FD7309C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0046B0005; Fri,  3 Apr 2026 01:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490B16B0089; Fri,  3 Apr 2026 01:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6906B008A; Fri,  3 Apr 2026 01:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 226296B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:13:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF3061A04DB
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:13:08 +0000 (UTC)
X-FDA: 84616075656.18.B6C2C69
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5A731A0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:13:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CjcTJNjm;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775193187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN5h5FdNM37VqfSBYSeye0NtBdmBLpRNeMxz+rjKDZ0=;
	b=GpOebaeDGbHI2SNYdFLFBP4U304V7yqMLOfgFM8tceXpU0treKRh3P81UXVgt0eeq9XeA3
	HVjem6+pi5xoMQFyWWFuRH/JqAt2e+9b5dRR//976sZBkw2VzvO9NR/jOToSeljUQwmvt4
	iVKuygybUbWXU5iy4q9iWZd+uEnKO8w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CjcTJNjm;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775193187; a=rsa-sha256;
	cv=none;
	b=CWss3BPiF4BNbffCSwUScsgrCuMXUY2zP/Q/b1X3Vm53uZo43iVpQFiyRbGPhSwcxUGtMF
	T6Ig0QHd1ulN58iF9PHBHCGQgf4LR8LxV27KHeImpDrDQzxH+LBnb6slD0aY/v1uW53zGx
	/OZ4qwoazaFkfyyHRXeoVUI41CzdtWs=
Message-ID: <a0cad1c0-f6dd-46f0-b9f3-f028d7dabe6e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775193185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HN5h5FdNM37VqfSBYSeye0NtBdmBLpRNeMxz+rjKDZ0=;
	b=CjcTJNjm6He+RoQ+Cap9jx/S6dbw7eLv/GAVPkgtzshFWNvryj/kYWMzlE6s/PAeBZjmh3
	tMO1slLwg9W6WCXVihbds49aKI6M7Ejduvzx9IuxppfSHOFEizSejaKHtDBubYiv95LAor
	Xk1TkPZl7Y5u4jZgWoeYx9BGH7LX90E=
Date: Fri, 3 Apr 2026 13:12:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm: huge_memory: refactor defrag_show() to use
 defrag_flags[]
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Barry Song <baohua@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5A731A0005
X-Stat-Signature: 1c8msqdqpzo6t9ebhioh6b586k33fwjm
X-Rspam-User: 
X-HE-Tag: 1775193186-266150
X-HE-Meta: U2FsdGVkX1+zPEYE54JGbkYsoyu/FwhZPJQ8+4e3/2UpHvW5UpXl71FTpQZmfYtAIIwcXIxtJGPbkV1TKHFt7k9hJ+DCXcaQlYyurSLCXMuUaVDr2Nu2AkgTLkQSl11axoTNO1i2byjIso8u7cxxhdhdb5l0wN7k4L6zg3EyVmzMH5XlfUjePxoiL1KaYrFLRVUEMoKqfJTwofu5CTI46tibMJ3K/R6YyWU39IP8DPA7Mb7Mq7EJweqlO6TG3pa+r2fBrZwiKOuiNG/nFurRQ2zOKbYQXoKSJmBYphdTN3q6nqKuYJSKt+dsFO4d9GhFw5MYrUDMVRWxweNyjWi1824+SvWA8PD0S3XPgQOAuOuTX6x+fZGYjUKoSfmAEHBxpkCUBTGklut4PmisQ10Arzik2J/kx6r8tgwla9KdZA97TQkcD4YEfwafcX7bs22GEJuB+GVs46MWhJnywsZQVQhYF2ZdNrX7pXxQXGrHwVcdu44ZNUgR5aH69IiSb/941xtM5fk++XS7k0+POO/bwQTX/NNibI4vBMxl1eEmiMr4FLGvqIq2YoZuyor4FkPyx94Z7+sRtrTwZPRFruyloZzopxCTaIRvANABYn8ufO+8rG7Ok0yePev3VMJm5NMe5j0zi53XM0uAusnGnZ509yz0upDkaa3zN7uL5PG47SKFXRtb/7fCHDjIxF411dgUh3PjqV3l+tSrJ7xVBMYWh9SsugbVziSHiZtHZ3HrGe2g3xVwZlE05S/eb11gxjqkPtXeYaJYx8GFprEy2Iua9WFqkBMm+Aedt64a3ZccgqRm3p1Vh4lxJnKlStLJbVEQsSFqU14iTZHPb+4RHmSSowkP1eK/x8JaN/h8HE+8WHzjIpqEhPmD9daBShUKAemZTHXYG8bOylNIWXWlEatjCjFkFVl7Fk6Lh+Nvdg7LsAWmsszNjtf+qhEPSP30aHCHyPb7Ve8zL3ON/jmzMS+
 yWCwVuqI
 QatPq76IkmHGt55MnoaBrZrzNyB/msIU89veeRfqFhQH7/en6/GFdsddnpEN/wAmOL6eJTJvCIQO30pTxsAVtyXzfp2zyL4F347Lk7+BsYh2ZxP3sw74yjdjFStkcbDUKZk1tD0deCWa67ywk8hlfd9VnW4TVGZCagNv6npt42ozAf+ehmRJ/n32jfXinjNiSUj9Ea84bLjJ2LhxuYTDfpi21I+JTyfBSvHmwjXONuFvxT7aaZbRmH/MteWRmAVgO6qGteatmw9+g5jcUs5Vu4leEvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/21 00:05, Breno Leitao wrote:
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in defrag_show() with a loop over defrag_flags[] and
> defrag_mode_strings[] arrays introduced in the previous commit.
> 
> This makes defrag_show() consistent with defrag_store() and eliminates
> the duplicated mode name strings.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

LGTM.

Tested-by: Lance Yang <lance.yang@linux.dev>

And also,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

