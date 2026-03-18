Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46FD5103E175
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 13:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738A06B01F7; Wed, 18 Mar 2026 09:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710936B01F9; Wed, 18 Mar 2026 09:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CF26B01FA; Wed, 18 Mar 2026 09:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 570196B01F7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:03:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DC9413B929
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:03:35 +0000 (UTC)
X-FDA: 84559200390.18.92537C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB4EA140017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:03:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="orw/IVxJ";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773839013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/TNkLNVflSOd4V/aBtqTR5dqVUy/HZWk3OeSXZXouI=;
	b=QW/qUUhSSVAUWUGYo95h8EmY0BeKld7NShszWCRTt9L0NKQmhxRPk3OvBo+WPWfoEfbDiJ
	2RShDrfAUPqJegDmdNW4pLLMmd5oNWLKxjvumq/scXw2dVyRDmeDrGDXUkLenGRfZyluaZ
	i0GREZKnx2imnG9G/NHplnk84USf4/M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="orw/IVxJ";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773839013; a=rsa-sha256;
	cv=none;
	b=MkHlwYpXQce2lcfOIG3ut0b+9NY21apA6R4Dff9W/IRuk1Ihf/eQUY1z5eyVEm8C7pWMHI
	uAjPfFJVuvUGvF1ga37fRHlAR+xIkYxzyxzcUk7tJWGywsPnnmGDQQGiq+dv1RSsVhhQEl
	II6e8sysxzc+wSZDl0GOGlROjdgOPms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38035600AE;
	Wed, 18 Mar 2026 13:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4723AC19421;
	Wed, 18 Mar 2026 13:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773839012;
	bh=eonjOcMWk3Gw+Ml9AMDyqJOoLWtXmhPnNQ5RAGU2Y98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=orw/IVxJqus17hoDRUQQr1TmOap3CmKo0i4Ed5AAYqTA0zfTOCI6JYrz1kA74ZDvp
	 PdGpF4g1x2wzbWlHVY2IfqI4Aw1C8IqVlYaZCzEN8tDg3TvTPl2j44yJpmR94khS++
	 pzqhAGV8VtGFq9sggku+7LOscbHn7uDqJJGvuXaRU51H/nJ6o9PxSdIPTOxalIoi4k
	 DFjO06YN/u9YeDdidNVFizXo/yslY8Hj4fWzMo9Upj9fgYbA4W0UVg3RFm+/OihLai
	 XlQF/jSSjCmVjNFd/0ds7RzeU1DjKtQreN6AinEbE42/Zx7sYwqahHmCRboWyGofpi
	 yf0Vj7nH3aGcQ==
Date: Wed, 18 Mar 2026 13:03:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Sasha Levin <sashal@kernel.org>, Jiakai Xu <jiakaipeanut@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Message-ID: <d1ae6b20-ffe0-43f5-aa8a-9f6056b5ec51@lucifer.local>
References: <20260318122632.63404-1-ljs@kernel.org>
 <e71acbdc-f46e-4dac-a88d-5b297f518dd3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e71acbdc-f46e-4dac-a88d-5b297f518dd3@kernel.org>
X-Rspamd-Queue-Id: DB4EA140017
X-Rspamd-Server: rspam07
X-Stat-Signature: pw39euw64h67dnpyng1pqydf1481ho76
X-Rspam-User: 
X-HE-Tag: 1773839013-507369
X-HE-Meta: U2FsdGVkX1+OqD1Cj/O+VUH7CdqR2Oge7V07vqOa50ztn152EP76z53rmx8SdZn50hVELeV4+X9/3Il37Prbr+DTSLnfrZ6oD3zCFwj5pp8oGXITY50hxQ9gr/CPEbz9po31neI94sv2Qg/3pn6lTaYh7SEohK1amss+eFCvyXu4qtwvQdndLyHixSfHF2tzpvQJLyBUlnaSrVcZ8d79m98ABIE3Ak6XvKF2H9o2vg7+t6IZSjUYEfxX3bVwWICc2NrqKh5Y4iUvhOiZTLGX1UzksnZ5mitY2ghnhN4srlr0RWKFAH6x7dPRu5TfP1SMhO1ka/+UKgrJkkdzQwt1D3dx+bTs1fRdJ4g5R4OhSe0oBdeNO+ip/xgjK+M2D2bW0EFPOGXJrmbwavaos4d3ui2mhkTtXUCf3jVmNp+erhjNrHJ01lo2QdKRgRcaxtVsI93cwhJ9T8pMNH+EXSCde0JIGqEAM0f/qjYBD6B0KO8NHyc24jjSOeIxBjf9/Iiqyt1INe3kGWZ1addbxIZje0Zf6SUxWcvN6G7gba0FqmRfkWuDFJ3S7G6OXPFWMaaIm1+NYvNQzok5vbwn080FkxBbyhFm3pbFB/BRC/9me//Wct5aJdhfpidOoReJLOFunGE3N5zPc2Iok7bZ9/gamcJgpDgWiblg31dhh3VInTkOXR7OsnJAuT8k7qdKFq3F5m5yqEl8zUfTo1SpDjXNoEGaiSfTerN6tiEi6T8yQE52MkIX5xqvE423ZWpBIdlj0vM5UbWrES+XHDZ6O9PO5fPuDmxPJMwddyDlmHVpy8Ifqz0TfyZG1airBMuAhbW71h18mhjeL+kIWDc6NDMaGX+oPB6n8bHfKqNOyBF9QffkVW5imuDtZ0hpr3ATIYiLwPJhsj2QpbrtfsyyxIexPAWYAEMeuKejqnbXEDEvlQHy8UjJh6Z85DsjJlhW3lF/VYIVhMfqneZuaoFeJAX
 cbVDyc/m
 +QCtRg649ST8q0OcEYUJmq+2XX2+YLbt6w1Z013p7WHJk9CJDHxAAXzFt55k4RwM/1co1p+ZPwm/m4YwoUVTv568UxKpjI/uwODdwjNvOherW2XLpGOJXB8yGHuSp3ncDGlYifwvCkJLo3/EHsmP8wy4JdxsZd+JBoYTjNYfxyDpi8rPldpQpeNs1H6o7xpn3WDICNdoM+TmIyhlOfSm95BCBc7Ol6GHLWTNRB/Lptn+bxBZD0UfWH8f4G6NXJ+J6yS3/MDHeHbhdKaIslZ0WrKbcjJj9RkUlcMYJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:52:44PM +0100, David Hildenbrand (Arm) wrote:
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

Thanks!

> LGTM. I was wondering whether anon_vma_clone() should take care of
> setting up dst->anon_vma. It looks a bit odd in dup_anon_vma.

Well in the fork case we don't want to set vma->anon_vma, as we use
vma->anon_vma to denote whether or not we reused another anon_vma. For
split + remap, we already duplicated it via vm_area_dup() ->
vm_area_init_from().

But... now we have enum vma_operation threaded through here, we can just do
that there like:

	/* dst is unfaulted, so inherit src's anon_vma. */
	if (operation == VMA_OP_MERGE_UNFAULTED)
		dst->anon_vma = src->anon_vma;

?

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

