Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F57F8D761
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 17:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0918F6B0092; Thu, 16 Apr 2026 13:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069146B0093; Thu, 16 Apr 2026 13:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9D46B0095; Thu, 16 Apr 2026 13:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E199B6B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:20:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 833048C77C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:20:33 +0000 (UTC)
X-FDA: 84665083146.05.7DAFF31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DFFB2160017
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:20:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3ecFB82;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776360031; a=rsa-sha256;
	cv=none;
	b=UXOWVdErRjZ2pc3ieZZOXbp/XzlhzpRjGzYYUcra4xnJC9kn2ENogaZVTQXI/qSEbRnOdm
	U0CIMI83zUKYNjKDQrhPFoYtEJVzqzzno6y9hJAD0WPFAGWspRqjZmRwU+efAReDwm/x+d
	3qsTWrZVZAKqwYZ61riKa2+Y4RA08PQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3ecFB82;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776360031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Cchl2ciG8ibgB1rPnlhkHS4vZaPAV43vVXtK0kPCJI=;
	b=16TO8W9Q/LekjGCkRJxcHIQmeEPmFSlg7j+gWn49CBiI02LpyhtBaKh/kuB8pe1D2ITR7P
	IYgeFZPILKjFNeyR/S59F2ue4VB563LNhwYffKBurN8k/HQzSUJNs9jm3c5MrtCDn0fA+s
	Y7ylzCpQk4O3Hr6PSB2ndakpciJJrEk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2106E60126;
	Thu, 16 Apr 2026 17:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B7C2BCAF;
	Thu, 16 Apr 2026 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776360030;
	bh=OCe7lQtFBAOv6teYJrmVIk6YfRVI3M+lrX8dmNsXNaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M3ecFB82gH2AD5sMovebRC3/MsJtyGt5ffGOEzSVt0ApVCTqDJHHxoWWexdFXUxcZ
	 MlcLb8i9c0jJtxIX4XSssFspPvdO2YQer4T/HHxU53xQGQTGYmf5MMOcQF+nwU2ax2
	 7VPr+k9B0NcrcPTj5dkhLf3MPw0Bg2lbSbtwTf22LrOipWXU6yKCDdP/TGkdO6Mdf2
	 AOqD1s2/QRzALtpxZx1sJh3KYHlenSO29NWleZ0I0ZVb8MD4otN1AOORvXT3kI55jC
	 gaby8PGuyOg4LMOqUCMsQosx9E3K93gvMw9J2JiaUqZysC1kGOu2XsFoIydtYz28XE
	 fMCw1ezVdYcwg==
Date: Thu, 16 Apr 2026 20:20:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
Message-ID: <aeEaVAfI-3mgJBgw@kernel.org>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-7-songmuchun@bytedance.com>
 <ad_EygHWDi19SS9y@kernel.org>
 <86523791-2C69-4A43-BD32-3713840A6640@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86523791-2C69-4A43-BD32-3713840A6640@linux.dev>
X-Rspamd-Queue-Id: DFFB2160017
X-Rspamd-Server: rspam12
X-Stat-Signature: e57kywa16crmg4wmjncuxx1yqup8fhth
X-Rspam-User: 
X-HE-Tag: 1776360031-843567
X-HE-Meta: U2FsdGVkX1+ZS/dPfLoF0m8RDGvtbpk4Qh5DieYRKHmT46LgTAXTUamPBERNI4PPX6WXJPxyZduaEHU7m6ArxiQqIfCppeuFEb/G7s+1mE+fNm5XANjTs3sRlPVmpFmD2quSpU7SRPHJez6J92YZitgaa1Rwr59cI2B/gx1VlH7T7ODEEC8mhWbQ88FtXPlu9hin2JVVgJNkMjAf7AbnLqjD166H1eZCoRVz1tyD3J8p7R8MMb0yUAB+8vsaq5H7mH10vwKbrehChCHRboycjAt2X1jI/oXuIIMQxUx0LQU55AXZzmFU76zpECYn1NbwwBRPl6ZBQYAdC+bflfWE4zjUciiXqlp/h/nZLr0xYgfj8RF9s39+c+xKGgxCotksZJgPOBpFFFJ/3BskLfNIus8iuB5zt02QC1XExRglgbVIyTORQ2CX/JQMBw3VTCcpWjDrPV6iP5xlpMtJQuSDhuAkSw5d7vgf6Q0UJK3CnYhM9enDrv5K+vN/IhBaZngJijONKQt4HMUrP0Kn2LdaMQB/XrARO3Dzz27w1MHQ6c7oQQTm92vexN0nHnx9k3X/0658hJmlB14THBNvlaByIEBqxGaf/dZ5mwOWBSC4pwqhph2nrz68Tv26wQ+/l+4rMhwHK5fQr9ygQC3brzHGxbqXQtHvweATsnxqg7ccCtLJJ14i1p97k+rC8fedVsfZdOUpLFIxA0vNBr1815UhtXlSqSpS0BPYQd+G3PWubGXnnvOIEiDpsSdIdo0ekqOGzBVZVnmAqhjrRSz9c8cjNDDeYc1wodCZ4ZWaLJJ320xlRYa6ze7ThVHdrXeZI4gajuiKALZ5UxokkJa1G7/Tg9KqRjX4MZA1s104D2T86naSKWzqg5R4pg54aM5MbKoGzOtdfRyOHYffgDJVp3DyLZfKM0yXtKmZj5rSeX3KEW0kGFLnWuSg5CGTL8WSqXURHq3MSorVsch1+TqO1hH
 rNuholoS
 luBaFApwJGopOOFqyXvlbZ7Dy678ZZAnhcjOnHpe3A7R2QMcIFjT5w1AzaQcTqA8MjnkcRcRu+g0lQVtUwv7ZjKXoWfN8w4y5V2KfURmTv1+X/MNWt1Vmfirqfnqc0uYDvvnmVgdrbJIu/4XwdqJDKPbY5LjQg2VZnetRRC6dIhr6ZaEySDu//VmCEf+FbWzVjnv2JKCW+lnVEY8zBLzhOSpvBLHG/NHBdWw0vB2yGoI2hdVullkcGycqi1tF28QVzshXuAA0qjmfUdxcBvxi9jm+y4knvxXpSXgQmPbv8QmwfjHrF2LeLZRPMBUw/IVLvdiA8H+RoaG/eNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 10:06:03AM +0800, Muchun Song wrote:
> 
> > On Apr 16, 2026, at 01:03, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > Hi Muchun,
> > 
> > On Wed, Apr 15, 2026 at 07:14:12PM +0800, Muchun Song wrote:
> >> /*
> >>  * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> >>  * directly to the driver page allocator which will set the page count
> >> @@ -1122,6 +1120,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >> 
> >> 	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >> 
> >> + 	cond_resched();
> >> +
> > 
> > I don't think we want cond_resched() for every page here too, even it's a
> > compound page :)
> 
> I'll update it to every PAGES_PER_SECTION, does this make sense for you?
 
Sounds fine.

> Thanks,
> Muchun

-- 
Sincerely yours,
Mike.

