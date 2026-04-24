Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A9BFE51EE
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F50F6B008A; Fri, 24 Apr 2026 05:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6866B008C; Fri, 24 Apr 2026 05:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1947F6B0092; Fri, 24 Apr 2026 05:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 054E76B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:11:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9AC61607CB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:11:56 +0000 (UTC)
X-FDA: 84692882232.07.FF66AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 218A01C0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:11:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Su1jyHjF;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777021915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0S9EV25mhlv+RfkyJC3SADA/Hq4CXD18D0UhyZP3nWs=;
	b=eZOVe+DGyhs9FSov5mYvENwgepe6dR2VanQJxAAnxgYMiccZBHhD0l6IfqCXPFx12zg/zN
	0fClDoJ1bG8G6dNgKWTXLgDBnAo+sxsgAA80fFwPs4BUJNx/75qeDidelfcDcCfyflQMFq
	kDB+fhRbkLmXPzFb1d/Tp8AkY8Gs42Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Su1jyHjF;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777021915; a=rsa-sha256;
	cv=none;
	b=Q6FgPeX8EQrlzPWyj4rG1REnhTijZhjLquN2NiAYM4Dz0D4SQQsPxG6vGiwGlsQq4yhPh6
	MipDLN1yjytdKQTzXx2PGdZjvqvjibKab3QC2Wo1MheWnJPUL3ZeVq6zU8LI5oYLBSuQe9
	+6I9juWhVOiaL/w/ZUS+FEnCUZr+h6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32684600AE;
	Fri, 24 Apr 2026 09:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C07C19425;
	Fri, 24 Apr 2026 09:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777021913;
	bh=SsqSo4+zjog+NkLRTA0Kn233Cxw/eENvVArd9TQ7CcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Su1jyHjFu/8YsS48wDh711n00szcy8RRRx8P4BZ+dQyykIbYmeeE9RTMf8ATgJBsJ
	 jCQHZ4bj09apvjrQpVki8eBjYYIiLVXFTEfekDI/YJsEsigdOWyqc5nEHmK/O7azzw
	 QU6u8C25RMKPE+YqRBm12lfEW6MHkhInS6brKvL1XEEzhxgYEGdXwVtkwaESEH7eoT
	 JKGgUB+mnHGanzv0cifDp5Bjq87FKWg63zEiKjoD8iOqA/Q53kdAIY+BAauVSSkHfo
	 MBu7Bgg9iyCY0xvNfHK8lISptO8ffBRbj2VO3lQNmVpb6iJ4hopu2byxyx3pDpX5El
	 H+Z5ortWjUULg==
Date: Fri, 24 Apr 2026 12:11:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 16/53] selftests/mm: protection_keys: use kselftest
 framework
Message-ID: <aeszy67Qrb8Q-Xw_@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-17-rppt@kernel.org>
 <f8495e44-a34a-4289-90f8-0faa71bf1a71@sirena.org.uk>
 <aeczFjEs6sqRPy0w@kernel.org>
 <bf3133c3-ae12-45ac-a3d1-5e58b849f817@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf3133c3-ae12-45ac-a3d1-5e58b849f817@sirena.org.uk>
X-Stat-Signature: g996scomwtzchu93c3d5x5ituwwf9uq9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 218A01C0005
X-HE-Tag: 1777021915-416414
X-HE-Meta: U2FsdGVkX189nh7w/7jaioKykxEu2TBl/p6Hapu1RQjF1YB1Qt5iVVxJ0nfuyD6gBnB1ZPtwNmRA3aUMQBhNxK8Vj1NOMnPz7BC57uwbprB/p2auIULXdnglJzypMpqLPiR34dEl4VcSHmR2EDdHD3lhgA5XLoBawwY9tSHfBpcxXbOrMZuqNd64SdDS3IYuEtxo0UrHO98umSl9asvAwXpbR9Xf+yUZlCcNsGIQG12Stm108brjarw3Uu+7rlLd3YRdgmZwFTCNzkx6m30aoxf50+/yc0QqztK+Q3t2YoSR7cPnpIvg1GPhOX1lMNuz1VXEsq5BQQ8O8Hocu0fQkzCrxCBr1uzM9TOxNyOxIYLCYSQI7Rr+MVcOYSNjHdQPdDKoZWQPN9f/MsciPl9l0GfI//h1K4TIonrLuHV0/03PWf7XruZi5EZyH6vR3w4MGUt+/2COZqyPvYbZARloCnCIE9jygiAdBoktt8cLy579PiQ3iwQmrMuvFV00V7UVOZS/tsn2dNk2W9HBIDrB+C69f8XJghxRVXoW2W+D0hIe6L6BuNX2dmGwGFcCV3/Im0pqbAqdhj0E14hl6IaDoFBGmmEJe2sFxyAZq2JhZItHV0jobZ2TWO4dq7I80+HR+omewS5XRxuUTxCgeaTmHfYn80Miu8evImBNEy/oxe0k+UspIXdxAnaDRMzHNdwBZJ2BNWkZjk2QrB/fOxIKc3SDc76uL8GqUbRsAuTyZ+XPPCuCHytTN0+jsg3xhKY4ZVvfZrjyc0kOj8ujJ0x/iHnRMgAjo82DJkeEW5ZZYMNIhg+4SftCPysJEA9gSomJEEt9wzk8HKwj9YeLytg4eCslyuw03AM+tqO13BByBN9e7sZrtxRXBxe6wcfE4Vse3fvC5URCW7DAXXDX8Xgg45L6i8JjprSkkIMGCek5w/RmhDfuY2zW4K728knTk6DJCnwpBK6/t6LvUWO6bXO
 pfJ2ojGo
 n6wjiqOaZFX5Zd0DcSxKGN/E075E4xnfPjeiGBYRPi7e8JzDgAzYZZNQUqzR+JTyB7wa28GAmKTLjg8mpyNjnuIlQZLcY+X4GLAA91wod4jIaQIet8cP93rm0Gni9imU86pyR09PwqpgWLYkogC2w0Hf8gi2jJQf1ZTqpf0w1nBMhidEX2zUbs+f6ZLfKbt42AYW5gYdWhI8s51CgZgHyZ9fC0+m1cxFZm9Kko4UK7jSKoeieQKjD6Kgw4eovdPaDtbgi4/8lwUPGhGv+Ih1NvPLP0YxNcHuLKX2oeN9G0KzSwdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 01:59:21PM +0100, Mark Brown wrote:
> On Tue, Apr 21, 2026 at 11:19:34AM +0300, Mike Rapoport wrote:
> > On Mon, Apr 20, 2026 at 06:54:31PM +0100, Mark Brown wrote:
> 
> > > If that fflush() is needed it should go into the helper, particularly
> > > since ksft_finshed() calls exit() so the fflush() will never be reachd.
> 
> > Looks like I'm missing prints because of something in my environment, I'll
> > just drop the fflush().
> 
> Interesting.  Usually the culprit would be calls to _exit() that bypass
> the libc cleanup but I'm not seeing any right now...

Interesting indeed :)

My observations up till now that if I run the test on the host, it prints
everything (without fflush()) changes at all). If I run the same test in a
VM either using virtio-ng or ssh'ing into a debian VM, only the first part
of prints is displayed. However if I run protection_keys_64 | tee in the
same VM everything is printed.

I'll just drop the fflush() from this patch and will investigate later.

-- 
Sincerely yours,
Mike.

