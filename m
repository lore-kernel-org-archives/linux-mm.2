Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D59DFA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0CD6B0092; Wed, 15 Apr 2026 02:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1B96B0093; Wed, 15 Apr 2026 02:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7706B0095; Wed, 15 Apr 2026 02:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE5596B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:00:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C6F513A998
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:00:43 +0000 (UTC)
X-FDA: 84659741166.15.5370357
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF6231A0011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:00:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PG+gdCpn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3upfb8bDKI5gt7cAdR60JSKcY9WrN7j/DIf1ViFEcP4=;
	b=NIjiHniKALho2wnFSrfmi59amoRmZ6ZkZqxYeDRrXLF1G3Gk3Cu3KhcbWWM6F3dJZtYAtD
	Rw3cIScprip8IMOW+oePnp+GOOFsZ2FQ9b6sHB+6gn+INjH6+XmUtX+Qa+ZrdvONXRs7b0
	Cmj8QTuO6T0F83voeB5QfEebiPD/2Vc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PG+gdCpn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232841; a=rsa-sha256;
	cv=none;
	b=eV9K00dllGB9f3AJSTdpC/6pBUrUJaK4zVRun1K4Cm5eIdfuv9UH687Drs/XwjuABjAJEx
	qp4jHisC64o1v6eM+uakn3qaKmsjMKEgNgc88yuDIIgvU+rLj4+DM+bcqARMVSAW02tIlT
	2dQCPgTpN80SqBw8sby+0N71MZ7TLl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F633444AC;
	Wed, 15 Apr 2026 06:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7675AC2BCB0;
	Wed, 15 Apr 2026 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776232840;
	bh=YpO2tJR55GH2ObkpqG7bQmAtIKqR5Kp4eMXaU9peBC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PG+gdCpnhZU2mWNHnWjDbccaSYpzW5DWa7oI/L1CZa12jlDWtuuhVgVMvXBSieI5W
	 1mTKkTaPWJLD/7YPLme69oHfx+SqSdka5UJJLQ1JSEj8G/fwR1vKDIL4j9tCnJeXEk
	 SY2pobBl6jNteh8KlrO6WT//yIZHk6KAXt2Hjp0Di+VZncSOHveFrxLquCp41i6EWA
	 RiByggS2Z38tgRf1kBnidx8U6FCVMAdQB7BsauFIhoL+0oihLsQ1YPfGeZkVU1PHNM
	 TOZxYTnx2E6Ox33hogCr348RU1StshzU5rhoFZrFbiLu1YjSVNVJeZVHHWutt2BZy8
	 ipURrYufRW9Lg==
Date: Wed, 15 Apr 2026 09:00:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
Message-ID: <ad8pf_wawwRYDW1l@kernel.org>
References: <20260415044509.579428-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415044509.579428-1-dev.jain@arm.com>
X-Stat-Signature: iro7d5kx33h9adx9d3xt9ctpt748c1gj
X-Rspamd-Queue-Id: BF6231A0011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776232841-236562
X-HE-Meta: U2FsdGVkX1/Y9b0lhhxgmYBjrAzsJWF7FQh5L2HviB+YFgnC4lZ5FmgjioG95Qcg/FBsrA0vpPBtE4oMRMsdmBbkR6GNA/i//yFO66IhQ7d3TQ1dgr3A8h3usZRWmrnn3XSZX7z1XtxmUn87yYPSyogbBX4pU4qWWxFcghyV1vGHqZyC/q8XmECuWym7nyRFLTAIsdfAmQiAFvKZQeMZDTHeEfH4SrFZh42wKaD/hpT0ZI/iDdF6okgzVMTMF2S/QcSDQfToM64DD8X4RXJboyo4xjriGtsXB1EEZZcBp6HtnPqDhAczi+MdYJld/pKlO32zp1SbUCbHGA4zDk21sn/TfjUg4mAg1LmJ8UmVC7iwYNdoS1ab3JZ62Qh2h3Vx7CwqqmH35+bRE5Ra0y5rUsE1muX6fmoCF7DFHTEXkBWF7YGZQJSa9MeigUULXcj+ySpCSTKfLv8A5mTxzR+5iNz+UL3GQP8wQz/6v06wyjMbFiUrGm7ulHW76sX3F6jqpA7YLNi6IStqvkNKeVYPT1MAt0p+PDvlD6+425naYp9lWrQ8+/kv3WIRoHClJ6GtdCCGS0pyZr1x4Jj/ju0T4xQINRE4D2uVpREqKwIeImTeEgcxHGoR/KaentwvJVpVajZ7Hiu3/ytYpsICRXm7nPX4L6cJOzQz0wlOlJ0VmH5uW+9009DvkGHE7RFpDXc7h1ALgtWEy3qgKjNgvrG/8kGj2WBT8WFqpLYbkNznX2sGke+jPJ4GuyeBpnRlXXcfcucdUhgWO4zDas6STErmeooTdBuIu2WmNlB1VnltN7GZ26SZKPnlSKKeU0nIkVMHANAfg4TSSswsntLFrMgFL3wNXVl99eaygw6gh+MEMzpVQrjz+APsq0zOyIlj+rQqLGxqUvN0H+E3dz+GBdnrPoW8M81rwcOyEi/ULaFUrIJrYJjQuDDAF/Vm7gZDMxifIHjeHJaIxMfN33sKYOY
 0iRcpENq
 ErMaxbDGLN9upK8/fd55F2dhx6mGtWZhcneAzHv/ln/js5qFYb0FreeU2at/9jUH7h7vaaxXCvDTzx3RnHYLsYZKaJ8qP2Lzz75NnmGs/xUD9p4ksUiVdKRLaKTfvI9mrhdBtEnarejtpa6lYWURdkxOz3uwWxYyssw83OP8F0ailXXrv0FGOt6voyhH5NBwEPKY4vQ0l9D1DrQ1U816nFsuKqUKRi6AvUjSraBuT7acfoZ6gCs88Dd6OICjEnyzZkIh8JQdrgrdIzwN4mVXCAKmToO+8b0L54CQ95sR5iUZWP8sG0kazmj9gaKlqX5R89QwlBoehsN0pVl0eBEN4DPp45WhaPzy1ZdGrAU2Ksz/xKVG3680OVBh6ua8YOCTH0VAJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 10:15:09AM +0530, Dev Jain wrote:
> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> mremap tests") validated remapped contents byte-by-byte and printed a
> mismatch index in case the bytes streams didn't match. That was rather
> inefficient, especially also if the test passed.
> 
> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> execution time from minutes to seconds using chunkwise memcmp") used
> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
> the problematic index only if it discovered a problem.
> 
> However, the implementation is overly complicated (e.g., get_sqrt() is
> currently not optimal) and we don't really have to report the exact
> index: whoever debugs the failing test can figure that out.
> 
> Let's simplify by just comparing both byte streams with memcmp() and not
> detecting the exact failed index.
> 
> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Applies on mm-unstable.
> 
> v1->v2:
>  - Simplify patch description
> 
> v1:
>  - https://lore.kernel.org/all/20260410143031.148173-1-dev.jain@arm.com/
> 
>  tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
>  1 file changed, 10 insertions(+), 99 deletions(-)

I like it :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

