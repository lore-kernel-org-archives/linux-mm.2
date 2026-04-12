Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648C7E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70C76B00A2; Sun, 12 Apr 2026 13:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B210E6B00A4; Sun, 12 Apr 2026 13:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37156B00A6; Sun, 12 Apr 2026 13:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944396B00A2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:59:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 387CB1601D6
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:59:44 +0000 (UTC)
X-FDA: 84650666688.24.D69A03F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 67CC12000A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:59:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vX5UrLSP;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776016782; a=rsa-sha256;
	cv=none;
	b=nIB6BPGk1zNLHjuBnLO0WDkPzJvsUPlzTEwYbrWrGfBfd0UXjjiQmG2v25dX7EDKJ/Qf4L
	cIQIeXQqRPM3/7bZXq3UepEO3mAzm1CUsZaf8IA+BfRxRvRkZztMPaZ7QhuE9L7ieMXwTy
	qTvKcN0hgFZmES0TWfO2hcQb8CuTE5k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vX5UrLSP;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776016782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1MPRWzkT95WpXQC1Lc5RKfgzZLFOTFAC6n/9Ffw4/0=;
	b=idlcJUBMsxFwvpm3gwI5iJQ8+rXoqAyU45LdCjLWHepLV9Kyy+zL1ZBZjMNwvazYYEjhDo
	yn+PzEqqTOD9MMI8VSNqk7SzsFETa9R8gdGGeSTdVDwnphfcMGZ2gbKNxWqktUNC1ioH6K
	rTVrb6/RPRxIQPJmKTillZxh8glQzOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02A7B44114;
	Sun, 12 Apr 2026 17:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA4C19424;
	Sun, 12 Apr 2026 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776016780;
	bh=exVNphoftEq/DGXatpQR/6gB/O9CtE8L96Kx+D2XufI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vX5UrLSPnARMXIX/mQM4uvVK8eB3MjSMjjqX7C0qIf7l5+GlOdecSGatxLiVysej4
	 UiFvVcaKGLgtzPXekd868HrxInxdfvChWUWJ1uQg7G5aBmNOCYUAFTKXj5RpDsQiCC
	 HXWEYedmXBXK+9QGKMUNHwqteybGaznIrdeox5kI=
Date: Sun, 12 Apr 2026 10:59:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, lgs201920130244@gmail.com,
 david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error
 path
Message-Id: <20260412105934.50892a9988df0403c209c886@linux-foundation.org>
In-Reply-To: <75F536FE-6710-4AE7-B6DB-2997D846237E@nvidia.com>
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
	<20260411142858.85496-1-lance.yang@linux.dev>
	<848180C7-F98C-44B2-AB1F-579BF9EEA28E@nvidia.com>
	<3e688ea1-05ba-4e75-9d92-2751ff6f3b7b@linux.dev>
	<75F536FE-6710-4AE7-B6DB-2997D846237E@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67CC12000A
X-Stat-Signature: pb51wedcd4b5jhywbsta9xydmm7mpn8y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776016782-29007
X-HE-Meta: U2FsdGVkX1+9xmwBb5q0YCtNEbq1ylEySEN7fd1MBK+od83xGhZw+ThfIfydbe1zpOg66dimoSce3ie0Q7tzrnU6pasNE+AtPO5p27V58Byu/bFb4PgnZJAcGvmV/nY0klJShh2DzCdn4D3bjl7Wbg/8Zyl0G5EjfZzmCEt9wz5ZkMB02g7u7r/7X4soCjJQe/f/hFcwNndP9YLb/QvzLKcgRD83NaFAK42ZKwt9Jhr4PCyisb1E+6alm0frrqgqfOFfxBAACtwQUF+cd3GAJHlxzCnWzqFTLfODBNXIVZ3Ceu6PhJ0TEFM59/JbkG43vWg+1JnkmipRbMbBwZM225PAqcYZQDxD/idmDgSFRRTBCc9k/Anl+ydUd7vbxRhiZZT9EF6EiMpC7P8wB2QjIFctISf8neEUttcrr5QihtbLj/Wer08W2aVce2CDGhWXIDu2S+JXNbJmOTuHe7nCYmRUtlMzRT8IfW+BG7p7bsMMGwIOXtG5epjpKtXjDnLjvZL2OB3f3PTw+LaMpkla9xMi5hNRhvJsd37FZl0OCgax23TnpJ4PCozNGTO5gWqMvlwSG6tXClJNlU5WfVS0OW6kmKSwW5ZdEXySsOQdhtrCFqC2Bx59UlhCg3LLgjXB1Au1s9kAM2abnbbSdEI8qO91H7jeJnQjFe7Yn6//Kaji3xwg3Q6SynoiNYHhGhTvb//DBQhUoKBizJj/okc3eRmzmVxhopRu6J6pULZbSr+rh1x1rmY8+S2zFSMAUA4yEWNfoS3GLr5jD7rhnicfMuUo30Ql/LKd4fqSJYQXIDtdyuYPQXiTrPaiJUBc96/+wG+S9mWl8Y21hTyJBzh93Yjh7OfCcXb7dEAYNbjtrX8TBXOVbhzxoI90xCVSrlOi5WKKPtKvFMPRYwFtvHOdK/jdD9JfPPR6sU0JzcUVIhAEamrMrB7xGfIiuO1isbiE7wIIjXWEMRE5xp/roQ+
 bhDUViga
 GJROwqjtgAndhkkeUBP6+S7GkmtCIJU/Rpez/HUmj2qA8oBeRi25B2AzQjk+1uAa5Z/OaMMILPQy3Y89w4vEpqJiAnbIZ67+k7n0tc/gurE6jBZYD/M2lD8UN706lloWVcfTV5o2XIPW389OuaQ4dbvvala78Q/rNUxfKcnZHF9iG0SeuE7LZuAOS/Nrd9B5IX/4rjPmezYc9meGhNPHP9RzbU6/WEfIcx9Icf8iVMwTLtjXecx/vOBQ22OeI7T+P0kEQH7RR7lJs7MuidCPjB+OA2nj6jSCxDk+YEBF6pxVuOAt3O7MrwIgLYRaBMmdK8kjK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Apr 2026 09:33:29 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > wording, especially:
> >
> > "resulting in a refcount leak and potentially leading to a use-after-free"
> >
> > The old code does skip the required kobject cleanup path, but is
> > a UAF actually possible there?
> 
> That is my question too. The original code might not cause any real issue.
> 
> Guangshuo, let us know if we get it wrong. Thanks.

Thanks, all.  I queued this for testing and added a note that a
changlog update is expected.


