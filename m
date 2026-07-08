Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C47C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 21:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5116B0088; Wed,  8 Jul 2026 17:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EE56B008A; Wed,  8 Jul 2026 17:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187CC6B008C; Wed,  8 Jul 2026 17:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7C8A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:24:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C14FC19FC
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:24:59 +0000 (UTC)
X-FDA: 84966889518.20.3C4C310
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C98340007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:24:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f9q8IM11;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783545897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHVYNoMQA0BhF9UmwrbZnACd7dxHrgpxo3RgAW0uzE0=;
	b=ZQ3tpwESesyWtGyba8XORRDOIByP10SP9PXRMIgWs2iCmbgHHp1Qgn72uWME7UOOU5KH2L
	culK1+gPPPTrNB0yPHfALSxFuLkoGMfZ6tCbPQ+N1TApt4xWHup4wBbWXDx9K8gsHBnuce
	/s6Afo0x4aaFYu/+8y3zkgMyqWt/VgI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f9q8IM11;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783545897;
	b=EpQDP4O2G9GvvhptQLEOS0y8CdVaHMMILqTUy4opKL+yNHqG+SROham8XKQnUiRcZYUjDe
	2wrD+u2HjsnIsS+0d5iKBls8c76FJn7/55fVW2tWYAx3X0QoliN1PcADOKFn4o+HcstfsB
	9bHUve8miU66DWSfexwU2Vxe2ujiw4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70E9361372;
	Wed,  8 Jul 2026 21:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354441F00A3D;
	Wed,  8 Jul 2026 21:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545896;
	bh=QHVYNoMQA0BhF9UmwrbZnACd7dxHrgpxo3RgAW0uzE0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f9q8IM11qE8X9+BfI6N1CjNBm3AQU7pEkZNUuV4Cl3yOhQv4CeYXe22CypVW+3bS/
	 pE13Yn5jTc+bK9brIzcnZHoNdr30zsDRo/NY8NvsKtJiG8XaMHp8pUCm4aE4kAVw+O
	 aCJrVof2nQdsv8zTXFlLKEfjwTr7D4lk/H+YiaUg=
Date: Wed, 8 Jul 2026 14:24:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Subject: Re: [PATCH 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 2)
Message-Id: <20260708142454.fba56ae6372b473c0f2ef05a@linux-foundation.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C98340007
X-Stat-Signature: spufex33dhg3ca5ety15uj5xyhi7dufi
X-Rspam-User: 
X-HE-Tag: 1783545896-429421
X-HE-Meta: U2FsdGVkX19MxwNh75InDz60x3FkmMZ+Je5PAz2aSoAKe7ou2yubMmCVVT1XLNeFUc94BdjjRGaXZxakHf2RSvOK6n3RII3azoQWgNe5wFtHXA7+6aXu2jA4LWzP6LRcuqYy36ZQIxYSMEbc/pgJcYaLtrhU0POUSU+t9WmBjTVi720x4XZlQ+NQJxyh38Z7tyHKeshVTJnkIqEfBQOy/tzWXpNV3R2ZzJhUfuqroqlFnm/jaLKY3Feq+O9NUdSRV2EtpE5v+Xq9xeZefFyZeHGUE2HTRxXCPQuTP2SB+JGveewnpiMKQ1ChbuSvCm49QiHO1JS/Mngc6IOUApgxfIqCnBmtgrW4N/DEKk7aM+dGHq+dhSfD2om4NtHw1G52VoKQqilUwVuk4Nn3V/awsuVpeVNhXLcoqmPwcTE//cms/Wv+HniT/qZ0Pr2IAORYLVfRXBkfRfzpaz8osPVLfXiaZYNxVtvVNoz8CtyMHRLqHnw+EgUmcnYaZRME5PISJ++GSUE3fdkHO9kGuWnmCLHhjMRClZpkTWXF+5NZRO69mOlH3bxa8h7TWSx0Aihrqy418+313DAsOlllPb3w1awzoq8ZGviUoZYyJL3YGHCrwzm1cbmWTqGQF0kVM9Zdy/ejU16xPHtXe7oGUmFR5CLNj65nh06y194PV4hQvr/RqBjNZZ59Ncve8Q5vV6iifV/SxWSBs9brsOqT5vraFt3MDDDgvuEwtZt97vqVfGgJmBAx/ON2sC/M/jUOyVDMOw6P81ngqlCznmIXxovSKIyPi8uEj4bXX6V173+K5RoIkblEQuFIV7eRxIUJPHGK2C7J1AnBo8XuPhnmmKW4MN27289uqRqzCSQXZl55Cb5cM0BhrgslkJ82OKWKJNFPN7a36+L0RRZjvrJNRl8aqJcuas7ZG0jNIEJz526maCP/ykUYn4DxynLPlV1YjcsOWtp9+M1s/rMAKbZMlgQ
 bTuzV2Kc
 NZXLeJFP3TnqB4tggnQV0BhDXct2OT8UpeV7/b93A5/s/AfaeyagpeAjLNReOlqpoVv0T7PHoSpIoSqARq2HOhkDqWadYU5uxI/r/EbQ8o7bHr+vPdvKUOPnqPd/yFQViS9P24nwacDQpdALoNMxx45UH3CniD0rlbo3q5l1LQauR8cx8AHMznBP+DWO9mUR6hl/bnybvftvCjszr783JV8EGFABslugXoIAZv7CiiFO+3csnzBlSFKrvy2hJO86bvmdYMJfviOagNlWJHNNsh830XldhfHY47FUaf38BCBURAA3Px7fZyV5vqGI594tEsuxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 08 Jul 2026 16:10:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's remove the remaining pieces of CONFIG_HAVE_BOOTMEM_INFO_NODE,
> performing some smaller cleanups around freeing of reserved vmemmap
> pages on the way.

Thanks, looks pretty simple.   I'll add it to mm-new, along with a note that [02/10] is to-be-updated.

