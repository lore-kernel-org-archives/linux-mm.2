Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778151088E65
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 02:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BBE6B03B5; Wed, 18 Mar 2026 22:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C495F6B03B6; Wed, 18 Mar 2026 22:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80306B03B7; Wed, 18 Mar 2026 22:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3A346B03B5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:59:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62FBDC164E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:59:18 +0000 (UTC)
X-FDA: 84561306396.14.ED05BF5
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6EEE240009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:59:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nD51bTaW;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773889156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWqXdr13sDo2VgZ2GClp58nX4LNm23y/nrWdjg9tW7E=;
	b=KuUTdULQIo14RwlSL2qKwVIBVKJM0eEwTOZYPOXAebO3SmxzA5i7QWIRFOIy2JewI4e8X7
	0GypjGIqk/a9qd5naIGkKslnsxs7ba+SsIwXEzAHr53wGt/4EYAHzq8NeWJzxWr+HjfRuO
	khvIQLZBop4C9Z40yEP4wgiuqkwf5qk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nD51bTaW;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773889156; a=rsa-sha256;
	cv=none;
	b=ky1AhQHkrEhJrqT3A0qXcnV7/+wxx3myWIot5AXJ+IMZE7xWDd8IJA4LjrQeYikPbpNw6z
	ntIcq5HUHax71KzAhJwOD5grGZxOjANyxr+L/R3EGzCjgK8TvJRin0a6/6mXpLRXie4Nfg
	cXDR5+u9tVvOC3TXDSeDwEvPyY74fpw=
Message-ID: <d8be1de0-1dd4-4449-a5d8-d28b2b81c1e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773889152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWqXdr13sDo2VgZ2GClp58nX4LNm23y/nrWdjg9tW7E=;
	b=nD51bTaWiThhqClTAYPJeuMAWr4G6nJmXjWQc3sRg6r+wdum0aIwe2R9Dn9Jk06tBHd/o2
	dKvIEoiGAyd0BhU6WjxVlQ/LrqcylhXdJ3owTAyHmeR+fl912LsD4L5uKc/61PPBl0wOCy
	bnqqzbFFmAcCriQoFTKFYkW0kCYVPzA=
Date: Thu, 19 Mar 2026 10:58:56 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>,
 david@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 Liam.Howlett@oracle.com, ziy@nvidia.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 dev.jain@arm.com
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
 <cfa40f51-0a39-49e3-adac-48b2709e67c8@linux.dev>
 <e78736dc-b087-49d8-921a-9c3d48d9e4c0@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e78736dc-b087-49d8-921a-9c3d48d9e4c0@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6EEE240009
X-Stat-Signature: fa16nyjxs94giassjmpkzback6pnxjgd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773889156-95912
X-HE-Meta: U2FsdGVkX184hQ7Nw08Uj+bgJ9xQCVX3Jl9FtZRwf2LbVbH2oYq/zP4fmzhMn0bTRJdIJGndmQ9/XSRaPnUO96TGryISjq7pe0zz72reOgyW+hG2cbaSk/E9G4vHZ6EtNsaLVqWsMIT42uLpyiVBKMF4m4zVGnOdmhJnSaJUvoT1sq1kAgQTLj6P26ZN/8BzYxDGfaPQiw10wuSfPsw6m9GbK5Etaw0c3uRNWUkrqxx5pPUbnNJDxdGE0j4x/Q2vBGZ2/3MP4fJiE7dZ5iy7CtRxThdbcUef0CMZLeT3LY7HrekpJyqf8OGqq1dTEOKwGyUIqRwawuVomHuuc+Uo+NcUe0jBMjcu4z4W5TSHOnhAQeYVW3u04ziBPuGiDCC86CuFvGeA83KRvEy9w7mHsXHfYJKdHm5U8dH8EY41EsvpD2cyJvycQWFVb29JrJxGqU4PxiEEnp5FJSzS2Wl6AarjGAaciuL1OcXWKZLbRE9W4u4kzjGKGSvK6b5/pcMrdvoFPZoSBoKIL23g5loyUD4Sn0ut/w+D+EzgWNpub6qGFkmYW8iIhPf+7ET6FblK5KdLTwwBL/eof4nmQ5kS9a1tShy1br4mVO5ouRpKB2d2750dnrwrtp6CVJENtlgaoIiMKi0NpChqP8f0IMK7hjhTTd6aJD/u+tdQPSjG6gXTHkhJZMCWT3eDANwJW3t1asJuEjiHKxY1e/xZiyre8h0NOAcD+pLRQ6XWacxLH/KVOQ91Vvw38T+dOBvagkFmyPf4W46gcy3FrJzT2kkCccgKk7R2eM4TH19Mfsi8sMQ3PjRDu+u4LMNfQIj6AJs74E6ZU01ACP0TMgo0kLdHkifneBzsFUnrjNJRtpIE4aDRlFYhVRmraqIk8NQcbHlmABlPx0aw6xIrvKs4vdtB/fQKMWf9C01TMY9dHmPSdUbhWshV4lb7OKheKkllEu6cDA5j5OWJC/ciD5KWofZ
 Lz33O+70
 Jq5IjJpZcHxZHWnzqjcUooZc2Yrjny23Cag4fNdhOyMVaIKm6huhUxoy2nAvDb/FqpWqD6oxFnjjwrMeWLNl1fOfrtWnNNevAHEQcfs1Hd1PHL+sKVenIROARiFZF9eaFkaym/ccQI1SbBqicJUCOyzFXKlNEyNGyVj+wFTucW0LKOW7+LPkNKgEeFzakuL1kfrsoK77UZc8lcl7dzXr/K+lJkjkf66LQNvnxEKAUDUeqt0j2NIHm7Plgt4o06KIT+mkHpbUqZOnE7re40onMg+Oyp0mn1H57l7xa6hxA6d0Ad2JCXbJQtWBcgIAEVT/BRnnerauCt522tlUHplA40oOM0rECjc+fMl4Vwx0oSPF6Yvl6R1NTORGKsKtafnaY03OWyIOQXwV/VCTbvuaxJK3K/Mz/SVPvnJpNuqCgEVz/6vI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/19 01:35, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 12:53:46AM +0800, Lance Yang wrote:
>> Looks like it hits a general protection fault in zap_huge_pmd() while
>> dereferencing folio->mapping via folio_test_anon() ...
>>
>> zap_huge_pmd() fails to handle non-present, non-none PMD entries that
>> are not valid PMD softleaf entries, leaving folio as NULL and
>> dereferencing it ...
>>
>> For PMD-sized hugetlb mappings like the reproducer above,
>> hugetlb/userfaultfd would make such PMD entries that can be
>> non-present and non-none without being valid PMD softleaf entries?
> 
> Yeah, exactly :) interesting how it gets there though.
> 
> Even after I figured out this was fixed wanted to track it down!
> 
> See
> https://lore.kernel.org/linux-mm/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
> 
>>
>> I'll look into it :)
> 
> As per above, I already did the analysis on this monster, it's fixed already (of
> course!).
> 
> I am going to send a patch to make this bit of the code more robust anyway!

Cool, thanks!

