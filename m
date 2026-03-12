Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A7E106ACD5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606F16B0005; Thu, 12 Mar 2026 13:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B14C6B0088; Thu, 12 Mar 2026 13:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3D76B0089; Thu, 12 Mar 2026 13:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFE76B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:47:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30191C42C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:31 +0000 (UTC)
X-FDA: 84538143102.02.3C6DC67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3CFD320013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=2B9kvyD0;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773337650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25cZDt32uGgylAEA7eJVzMgKIHpSK0avVW8XiOOJqdQ=;
	b=jjIuUcAonhZ+3hbk5lEIy0gT696yaaV5xSN403QpahboWJNYACGuKPED3wK7bWMEKxdUgm
	SFzq+Fsr9ARB9Voc1ia6DBTFGyAj4KpYl8BSVlcXFEteO/2JLxJx3MGPaFOrgDNWFLoOy9
	KsK6tk6F2OyxquKDdLZIqRC88RE6K/M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=2B9kvyD0;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773337650; a=rsa-sha256;
	cv=none;
	b=BbKooMvVFwzGo46M9RHOricnFRRwO3gF2ftsvCx5w0LcoslueZZLfnv5EUVT/iTwQD/JXy
	gV50pCKkBzB4LnJ8krjDn6ak1b8LzsGCruMQD8dWBtzSAc7My+ZDlyya3tDNLcSuLMO6ho
	kkb+uniGMsyhyQvRJsnLAgDYZ16TKyM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B8C644023;
	Thu, 12 Mar 2026 17:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499C1C4CEF7;
	Thu, 12 Mar 2026 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773337648;
	bh=ehJUvxvid3t2rmAdiav8+vgSkMWongK0fp+rm1Z3YEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2B9kvyD03M4iobzfw738CUb7Zo4v0G+8mlyNeM7oGWz9mNoWZb0zBB184KYis6Zf9
	 HyXFlcgGxfAn233Swf9N3op49P3VbypAZmdQxxGquhTZSIXAR0H3yimNZQw3lJpJgk
	 9mqp242HYiSqz1BWDbPouiQ+EDsYYebthrgMVBVI=
Date: Thu, 12 Mar 2026 18:47:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org, Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
Message-ID: <2026031222-vacation-cramp-6fdb@gregkh>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
 <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
X-Rspamd-Queue-Id: 3CFD320013
X-Stat-Signature: fg8ybyoi3r1pqw3ozdaik89fetknn1uz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773337650-917147
X-HE-Meta: U2FsdGVkX1+s17u4BQYbY2C+gQ70cWpJjo7SNGFDM+0ozbQhgC21yH7i6MT+yZgh0rVDBLmKBJ2L16NcOsIju7Jk4OznlavWPAHlCbbvRn2KagOK0M65Ukq4nIYS/UeNYYciXrJEHtjuzbYka8nE7GtC2M7VB5H5A0J9wLRh+32GusuQRgV21NqK6Ys//ndhRj+KDLxRP49wdScwDZ1iPjeu1gdpkPTrmPdXY0cFb51T73P/z+43AKvwqwHBO1FuccXHHS73QV4DRWEZH7FOrAOhqLKPjTWUGgJTZPK4h7HFLbL7aDpBkIwuYmEjCRYj7+pU3Q1lSveSYom0Yntj8ZL6CmyojOJ2lODbSazJ1xjOYJitRFXbzNHqbNWIW7+vcTLrk9pJt/4gioTHhzK09tbC+yUItINPV2kb1VrpesaSc3nkgQjRiNXC2HfMkoIY2aLnw+q8Cj7VIztUlzHNZJvHJ/1v8s6LiU7rDLb+jiBFvsbcRYIxETTM3LYhd1Px6f6n4eifbPdFYT/Yql13c1GcL3mKe4iIdlKiP2qZuwZab986+tYLfPXa6Bq0jNkf+mnWwbQ/0/k9ce4LonLN1TOhJCkJ22GRIzr17rrYC4DSw2HG6n841H9ktmBGf24WSXIiudN5pekA3/4FGoZPF1WUI3K/vwujKSJnwLs/sJW4EMNF+hRiYYqFH5LjEOFlhkp7w/6I9RIm61sPBVWxvh5b9c2oq0u6n/yMdp2b9pnt5u/6T2Zr9OE+scM/jmm3JK/xWGemE/HYd8gbq9hJJrzzkoA+OA4RLqoBsrrZOftMlxdIo0xes5P3avEC9EYuPsmlT+OojNOAY9hbUQBoRUuQgDBsA2JuP25PyqlW6Aj6xd2s77FF7bzKdBNfvqdN4jGlyRjoYFanjiniqdrTA/JX9x2duMybqtNOyFGVoaambYx+3Vw3Uzf9FzilE8NhetVKJPQ4QJfJUNcighv
 xSUaH+K/
 l3IFs8qYYlqTFd5N4XC89iOpBZkm8h3ofHPsEMnLoBMKXJVQk0kNjOedF0zywnMppia04U9V3TpHCGhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 05:42:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Hi,
> 
> This series was sent a ~month ago, is anything holding this up? The underlying
> issue is causing a really serious regression so it's quite urgent to get this
> pulled ASAP :)

I see 70+ pending 5.15 patches that people have backported that need to
be queued up as well as the pending upstream patches.  During the -rc1
cycle the stable trees get flooded, so the older kernels take a while to
get released as they are on the bottom of our priority list.

We'll get to them "soon", they aren't lost.

thanks,

greg k-h

