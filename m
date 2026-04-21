Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7184F327B2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241546B0092; Tue, 21 Apr 2026 02:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F24B6B0095; Tue, 21 Apr 2026 02:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA176B0096; Tue, 21 Apr 2026 02:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F22676B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:45:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADF0BBD564
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:45:27 +0000 (UTC)
X-FDA: 84681626694.18.94A1C2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 288B380010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:45:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZFVCtUb;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776753926; a=rsa-sha256;
	cv=none;
	b=CGaowCnri09P1v3VVOqnlhtNjgu7t5StyxuIPm5YGBQYdVsqMhCtG5PDRkWT05mUmon8Hv
	SvL8N/mPkVb8DaW/iZkD3NPTL03nFIe8vxrCNU3Xg8vIOjWfbhinmVikPWjXk+5LWwrMCw
	5P9Iwet1uzo2liFxpRLhxK3zndnXBcs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZFVCtUb;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776753926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/G8cWVgB2SZRPE9ycGzMJH+8bQwTvDa8dTHAoPol/bc=;
	b=QFUFf8kF2x3SREyOvsF1bRbRpcRf9OSfRkpqF5q9XMv75DEnTlAxS61NKHcB94xozLXXoa
	RB5OVWhz4erWbfzrT3B3TrdjehFo5JQUf9k7n83YpP1JYEn5bIshd9LzyTmNsDqyZ+6VIR
	0TGmGe03706ioV0LHTwptxCncsePzss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30E3D6001A;
	Tue, 21 Apr 2026 06:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2BCC2BCB0;
	Tue, 21 Apr 2026 06:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776753924;
	bh=dx6qSz9cAbPLai93tke4yY9+hgGMAcqbUzp/yIBIdeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZFVCtUbH3qyg4P3hgbHvXgvoZzOL/sYNfbd8x9MZz5vBbk5B9GAsDIvYLyttGStA
	 N8fNTWJAFFrzqgufzVNG2q7RrLB1n4ue4gd/EiaLKebRwiE/qGabSBQzEwo8WH7Eui
	 Wo781Z+f4WLsDgjkm7Xvny7hh2gBxqgCdGIhCmUOcr0GNsy8hsnanEAFCInyVDKWKK
	 7+Cl8Zs9Px+aYflCxCjxJmlhKGeVnp52yDnPU47nRLt7ZLgGrnThVo/ayi5MwClI+y
	 7endUe9ZfsH3U2fRcoIyemegwT+2ryIhSEozG9uJHvKoXn+Z2exhXICRYRF6MAVd1d
	 IqxXjIafvd1dA==
Date: Tue, 21 Apr 2026 09:45:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
Message-ID: <aecc_TTRh1517J7X@kernel.org>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
X-Rspamd-Queue-Id: 288B380010
X-Stat-Signature: q19ao8a9rc9yaeso4srgy6hfkc79raje
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776753925-163750
X-HE-Meta: U2FsdGVkX1+FHzXTArau0S9oNAnthqgW82y8ZSLpvVLCETKfmS5kqebDm37FyN+/Yf6JpVrHF0OJBUZVzCLVNpB/QZAUCvzAZsyRshjL2lnKSp6Qgh/JAVagDbuXK82Eq9HAL367sUXZNZvuXVMNILyUYj/S9zfH7C/l9NeOZZqDe1XjXkPvCvcuQgnsTHOeiVEhZ7/79wpPplJVxWJ22/CGses13XhslIJ6QKgr0ynpyVM2D6d4UNmkVgDf0pu0YGw1C6fwyVQ2oH4zydmh7GqGsCJKDdMeJLFIHxVQhFqpgw/lIvlRqs7CKuZnPsFCFOYBtl6GYfwnOe52p7HrkigXjrij4ViSU/wQ+dPzpUimx4bmM+AoAAgDTCbj9/p8zdB2ih9EQzjamG5cw+Z8Y8hv5xPLDUdC0eUr4RV70FpIs5qmBZ/A83od56v3Jas++H9CdCQf+4ntJQMq57PhgDOJXRncSjUv4xhjjDEKdU2i0Bq0bSl0zkB3VFiLkB1Lmt6t3Omu2mfebPFy/YySirhAfhHz31ri0+ZBa9uNmbTGwjkJNSxuDKDpY3mRanVODOwuzzSleR9bcBtEkWN09Hi+NGrRLYHoUndY9wEk1PCvv3o71C51+ZSNtxoO0ffjBDmPT9kqFsUfsmHoavAFq+ktct+R53dvwdHp+jSjij5q8R5f4TyWB44RI4k3Yucuq+kO4P0a4KEnnrUTEjRqJCHYVfKJ3tprDbpNlcfw+b6OqMKiyqpkqszZi827LeH/N6MMCUohKfOIo5SEXeP9VgJWCr+viX7x4I+P2Cuoqq4CJeJ0yxsdV/KYFhDoce9UtXPjmCP+T1M4axF4bpor3A6qQJJWQCrMYYC7cLtWY9httyfzcVkuvX5qgQ0fQq306aWJqdIw2O1RIE5Ci7m/OADZOZLo+O6sDd1hEl6McjQ/gd2HxdL3XRGsv15s2nGQ5NS4YWczhVqFrLZCnPC
 m1hfBqvh
 RcbkOUZdSGWeICcubzkN5vAqwdDF4zUDc7NKgOJiXb9jioNUavlYh89Q3jvhW7mtT5fZwM3RwsFeqJ6r0iEvR8DznwOZUFSFh0tb9a9zf9VUR+iY+pmqQgHVjQplNI9jYvD/RSEKoq+w2P3JbtffnnK4gybipBEJDYZfJfpmOEirWp0puZqc2ysIr3BncOaDocxOG5lnkQ5z8sbtdMaC0/Ix3TjlBvPfXBKPhgow2P3Qiy2K7HcUg7PPX+74bIjJmON+ZTz3iVo+SNwagJcbFiyBta3y9LaR0Eec8/uhF1FKhVxoP9ju/owjTdCOhCop4LAkNmijLqgRrejYiBNicB6ojBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:03:16PM +0200, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>  
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>  
> 
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
> 
> Best regards,
> -- 
> David Hildenbrand (Arm) <david@kernel.org>
> 

-- 
Sincerely yours,
Mike.

