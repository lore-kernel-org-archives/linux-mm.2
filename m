Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFE7FCC04D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82016B0092; Fri,  6 Mar 2026 13:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30206B0093; Fri,  6 Mar 2026 13:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EB96B0096; Fri,  6 Mar 2026 13:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80E506B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:33:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1121B1C952
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:33:11 +0000 (UTC)
X-FDA: 84516485382.10.C53C7A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 74F9340013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:33:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KRsRIbXg;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772821989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEqMV4FAiQ2ertZhW5R1v8PFsG+wXLi/IqOfPmPtzQ0=;
	b=mSRxWynneBe3S05skBLMqZB2xUVgYwTNZLuVTnCurjJvpVmY5IeEcTVqj+k+kHfdNr6YdL
	BUND0MQdfkF05QSKoyuSLpwWBK0P6zSRi9hQ13A1lenfI43NQlf/zEvT0yojma8OpE1hGn
	sVhVY3VYTVsnQ5cBYY+QnuNzFm37Ogo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KRsRIbXg;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772821989; a=rsa-sha256;
	cv=none;
	b=T9XS9vl1h72+asYyaySs8FWm665IRL9O/AJQNjSAGnV7aq4NZonSJX+cgSGlnvJ4nx7xZO
	tpLBpP/DwLgIK6cO3EHMzoNXAgTKzzXMdHN5KhSpsmdE2tfhzyXZ5iaRLLNnpWPylEy4cq
	t6/QHMJ4iVDck8Rs0orAf6v6MTaa10c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFC9560018;
	Fri,  6 Mar 2026 18:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9337C4CEF7;
	Fri,  6 Mar 2026 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772821988;
	bh=ueF0lQCMqn4ypX+Y+YxYy+NgBlb2Rb7LtaIJJKGG2Fc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KRsRIbXgs6VAkRPheR8mFFWeNSgVCVbf9AvoNcXeWNThs6FAcXlK4Gg9ApV+N6DHT
	 rnDXR+En9MjFfx5wTXfawW+Onou99NAzYJuUyoeGK9fReMxYr8XkY7v2wCMZKV2SVi
	 Rf4/rwGcPXAwY8i0hNd14n+XcPm7r+rsZQ3FZchA=
Date: Fri, 6 Mar 2026 10:33:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-Id: <20260306103307.43d12be7d32b3f3b06f7bb55@linux-foundation.org>
In-Reply-To: <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
References: <cover.1772811429.git.d@ilvokhin.com>
	<cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
	<20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
	<20260306130052.7da8eab3@gandalf.local.home>
	<ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 74F9340013
X-Rspamd-Server: rspam07
X-Stat-Signature: ue1kaek81qqqjjsgkqx4mbghj6pwwrdb
X-Rspam-User: 
X-HE-Tag: 1772821989-896740
X-HE-Meta: U2FsdGVkX19RGfy9QKHgd2TmTAvwIj/RNr9Ow+vWbldBzYIAfm0OHJ/mYWQG+WCnS19uzXPdpI/wvSyIHnz1i8+d/u4+hl9XNkusz3s7VOmBV8Ypo6OtlAH41lBM7cDseHHWMLMU11m1ZNV/npl9YyOMdXi21zSuu5OdlDlBLx0gHHadH3JaQ5kZYC3OUa+YPO7j9vLE9CwqbhGj+a0rPFElG0mEprfPtLVJUXoHbmpNTk2g9GJRBwaISrqHGK6wVvuqjT1LPeQoS+ZpjriDZ7BzPUY2is6VBe37oGkTL+E/QyZI+cORhg4wlSjgWSKS20G1hVl6ZGuDE81P2YBKhiEDGGOGmgGzXPxK8TKAdyfV5TA6ejpuGmSJH2QZEczB8JtyCimZV6XallwQH9TpA8uA9DJXKr3im0Jzu1FssjKk+x7eHPeen4txvmMVXVwnaC0Csr6sS4S9xio0nQdwlqsf6Rpyk2ztVxfCByrMAFFomQXoFMdu41fk+BpsTmyp2QKU++lbxj7K32YIZB7pHdL0Je4eT/yUqCTvpsmWZmq+6F6kVyKlDMTEuulmRv83QAbUiSZdDbIvh2pUdTs5dO5eC+E0RjOCy0ZjhGfI92k2HH1yN7rPpkvFKEqhkY6yCRsLChK75LmOYqupBYWoqTYXQNLEb0SQtTOPPiY2T3P/xu6y8zNRpfQfNqNU5kKce8M6Ht6bHIRxlWz1eTgOZ5oR9mFi8seUUrkbdi7Jhqwjs0TLu/CAmDklnC5CRTo5InqkfAS1FSLemFlwcq68u4rgClhq5EL6BS3/Cua2LsxEP8HwXl+ogdzCgUsQL+mhu9Rh22jyaAEf9sSTN202HZHShqlp3dHN/GZ5nP2ksi0PpnqJlTzYQdgvNtgvz03KVNgdYXHFTGCVvWsZLa6U8JjEV+9lXNFIHx/62AdXLGKBksoSdpY6aSeKyeBTJ5tPQlHXxurf5iGtfFFl5Yf
 IJgSqFpf
 VCOAGrKkGhqm9avMUHDSz01K6AvtS0cd04CmflEmLXaijuum94fLNBKggtGlrPLbsyTYWO55yHgRu+wIEzr9tha2TtqcM5W5C6FmhyESBUoqB2YrLvXIxaao/9o9MPkSfD5vXJ66zx/E36nhZFbrMGYkclPITsLQRUDJkdxCT7RWve4n0wbORF8TTTLQnY4TUHRLxueMOmC7l/+REgchWivdELB86aBMyy0sPoce0nWTHpkc38Gksru5r4ydb48d73G0btq+m75copEOHSsacU37HR52ikKyZTMNZEUXnAPiFiNqHSX87eDNwVxIuySx+hD/9+qqWqeQUVHbHJacL0KTMQgUZghIUtdeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Mar 2026 19:24:56 +0100 Vlastimil Babka <vbabka@kernel.org> wrote:

> >> 
> >> Is it worth it?
> > 
> > This is being done all over the kernel. Perhaps we should look at ways to
> > make the generic infrastructure more performant?
> 
> Yeah I don't think the guard construct in this case should be doing anything
> here that wouldn't allow the compiler to compile to the exactly same result
> as before? Either there's some problem with the infra, or we're just victim
> of compiler heuristics.

Sure, it'd be good to figure this out.

> In both cases imho worth looking into rather than
> rejecting the construct.

I'm not enjoying the ides of penalizing billions of machines all of the
time in order to make life a little easier for the developers.  Seems
like a poor tradeoff.

