Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869EA108B8E6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16066B0005; Fri, 20 Mar 2026 06:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7A16B0088; Fri, 20 Mar 2026 06:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5806B0089; Fri, 20 Mar 2026 06:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC856B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:21:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 266F91B4F92
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:21:34 +0000 (UTC)
X-FDA: 84566049708.12.8347E07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 641E71A0014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:21:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BhYBAgDC;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZkHeUQI4eWHjoY+CGNf1Vsk38qiYnAlfNTNcGWeAAk=;
	b=sRcsYJbdxA20QKYDLsDgDa8GvNqUAO8QhtiTtjirKCmuR4h5Ht0OqOhKEOhXqxpTMtaJSO
	BcFdeVPkbs+CA1PaLKJ5qiOp2uUQruQDWIe/0hEKovtSNY6a49V66vAsJ32jgFYCbPmchL
	mF6KqvL3QIUDeHxDLOzJ+/xCpu+iRtU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BhYBAgDC;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002092; a=rsa-sha256;
	cv=none;
	b=5y1pOHUuNC19cfiDzd2mivumE515SKJ7lrSuwvVR8zUlKj+GSHGWpTOpTlvBYKZ9RjSAvD
	LlT10kkPoM6dNeMsF6qa1xoFOrsmcc78wmthsqftHWxOajSWSwHLWH3tF5Sga+kp0wr71h
	XeE6VIq2eJufkD6VSy7Tw7FACpJ6FMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B903560128;
	Fri, 20 Mar 2026 10:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54262C4CEF7;
	Fri, 20 Mar 2026 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774002091;
	bh=QhiRRqpCEk8EKFOsRJ2iHKNYV8P+TxzDlDjkmaSZZxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BhYBAgDCWYS29GsN0hlzlbqgsR24TNfgW2Ohn7CwJxe2V85a/cfM3o7jq/GKKYoNB
	 +ARqyu68UZi+97zmVK1cfjDwJJJqReG14/9AJ+cirHzftkLRQrSTYDTCWr31YBv3rA
	 XqiJsD9DX223NHnEZRkHR40kpoxXkOOSVK01zsNAKhgh4eoQXjHAmXzHmEcobDKFSO
	 a079qFOtHbsMT22NFt0bDd8Cx7rl63q3sz6y6dap7qfVR4x7FU3hV1rR3LU0QdLWhE
	 e0+eFqu42BBLb8Wo7uELoa0ZzJUZ0UcWGTbX4PQgOk100ayqUTWvIp8T7da1oq+dIj
	 m5kdfqlT+2aLQ==
Message-ID: <c1a2a49b-8141-418f-b239-167ef031451b@kernel.org>
Date: Fri, 20 Mar 2026 11:21:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 641E71A0014
X-Rspamd-Server: rspam08
X-Stat-Signature: r67z79sk6dgu5zzhkwdfp55azccwt3ag
X-HE-Tag: 1774002092-761072
X-HE-Meta: U2FsdGVkX19pZAcv+e4tIY6AgtLxpRfFkdXAuZDPUTJmwnAik666Ibm69Op2zr02pYdQSat5mohhYk7Ji+m2AL1M1w1aRlgXs1jMbbwjUzuykhHVFkFZ0/tPhNCFt88x17VH8SAZdcdILHfZJjdtCNCqbdcPpf+eZMT4ASUuX2hL513JYsuJOPjECiluB/HdZHRa8PhndP26SQknlNtYlWD9+hQ1R9i/ggrgJ9SG+OWrBco2zf+cVN9FU1bhkovFwXiT8npQi50owescrqs195bI3apEWb/149brR4dQR8HKLwbDU0owMJGTGVupfuMbwzuAP+Os1It1XDxSJ37rCuYf/3E8FKJpHBXI4UYMPKnXCHkPi7/IPox4jmiy6AouGzqQP0QGcOjIQFi1DF/RRXQfcihLsSvo13/cPmOviaXqjNT5YMdg9t5D4zxcgEIGXNplTKd3JAED1dsW9nHGJIzQ1rVTRHlUQJxcoxou4FyyoFxKiw8RKG9FGacCYbBB7oEjQ+jLKC9npSJA0l/fDWysG9EwZ/C14QqsQbs8kSVDp8idDbHgbkxNh54k0C4KN3gJJ+Rdsq4yGV8X/oAxol1pf/Ym5R0OjzF89XyhYeXrcWfLi9ldsrCUpzBKkJxgblnLdg0LKYNQnYrSWC9HzDCIdz2mHSJTsWsO8l0E6IL1sUWTCQgU7I4fNGJ5nRDUjPYYjzLhcdtThm1enmfxg8TCa7JsAamPr6LD0LuHax31BuQ3QgoUL5T00Ih0zJjaFDsf7C/bIgbw4yr8rDPBoE7o2BHXan0kDzUSf95oMiIryQKZZRgHYFCIVzfZINTE8C/D41danRafZ8AEWJw33drBR+UoebO/jUm/d2xp6sybw9fmMfVrHz4bumOUKF+wzr6DJj0VdqWtr/mj7cWArr2O1p682NASLuOphWsqXEdDHuT4EcSUuDzOc2mMqBueZ0krwRG5b2dX32pb1vP
 kDyB49Ig
 stVtI/vtOGSH4jVP/lNHFPhjj+8/xUHCJqlpJAoFAUa8BdSSiHv9Log+smSTZZJPUF2HdU/rsHKnqSCxaAMtTuaijY9jlRUaGTOAXJifqMVa+W3EsVA6YARQidxYpcM8cILtNTbmaYA1jea63AS14frnV87GPwF6uzTqY3VukVHCgBZJPwBjtZBtDu/MhYLz5kYqjfJ13gPpyCp1n9e2EysZuZk+kDxOqDv8Si6xx+7ALeUwNoOt5cr99NmFlr5IFYieE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 04:48, Zi Yan wrote:
> Hi all,

Hi,

sorry for only going over that now.

> 
> Based on my discussion with Jason about device private folio
> reinitialization[1], I realize that the concepts of compound page and folio
> are mixed together and confusing, as people think a compound page is equal
> to a folio. This is not true, since a compound page means a group of
> pages is managed as a whole and it can be something other than a folio,
> for example, a slab page. To avoid further confusing people, this
> patchset separates compound page from folio by moving any folio related
> code out of compound page functions.
> 
> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
> passed.
> 
> The key change is that a compound page no longer sets:
> 1. folio->_nr_pages,
> 2. folio->_large_mapcount,
> 3. folio->_nr_pages_mapped,
> 4. folio->_mm_ids,
> 5. folio->_mm_id_mapcount,
> 6. folio->_pincount,
> 7. folio->_entire_mapcount,
> 8. folio->_deferred_list.

Noble goal! :)

As discussed, the issue is still that interpret non-folio page
allocations as folios, which can also be compound pages.

Now, there are PFN walkers that do that, but also page table handling code.

Most prominently, when mapping such pages through vm_insert_pages(), we
will call into folio_add_file_rmap_pte() and essentially touch mapcount
related stuff.

Once in the page tables, users can GUP them and modify the pincount.
Other page table walkers can just similarly find them and look them up.

To stop messing with mapcounts is easy once we can reliably identify
such pages when mapping/unmapping them.

GUP and other page table walkers are more problematic and need more
thought (and work :( ).

Essentially, vm_normal_folio() would have to fail on these pages. But
what to do about vm_normal_page() users? The page_folio() would have to
fail. But then we must keep some page table walkers working.

And we have to figure out what to do with GUP.

So compound pages are just the tip of the iceberg :)


We could maybe forbid mapping them through vm_insert_pages() in the
first place, requiring all callers to do order-0 page allocations. Hm.

Then at least they would not end up in user page tables.

But there is other code where compound pages are interpreted as folios
and the other way around that must be sorted out.

-- 
Cheers,

David

