Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52258CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 00:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E638E001A; Fri,  7 Nov 2025 19:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE3D8E0006; Fri,  7 Nov 2025 19:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEB18E001A; Fri,  7 Nov 2025 19:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 698958E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:08:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0971059F2C
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:08:59 +0000 (UTC)
X-FDA: 84085504398.02.EDAD357
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 58E0F1A0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:08:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rDOela9v;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762560537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55EfdJXUuqqpSMDTiQXXuT9iEayOo2wsAzGbIW3ohjM=;
	b=qUrbiRXTxr+57iIR8Cq6HvH2K/JTGpMSGq8HtQUvBVbXdZgQOZjlrtbQJDOBh2cghVcCGy
	MS22PMVeYszyZVdctoXhzvl2txd9+SeqL1+tUT+cjEXrCxav2o6MMb2tqJvEd48lh0qfy1
	GR/CtUROZkj1h5DeTGpR/w3Rj8thawI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rDOela9v;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762560537; a=rsa-sha256;
	cv=none;
	b=b4N0qcSEmRlLyfHuKV2o5AZ019kQOauU7IgbDTYfrTm/5hGM3Xm/pfEa6xY3xUyNKvGcnj
	+bgmoO18g0JJiDIX9QailKPgFcN5XKsQvvNn7dATlzQGN1uMyN1rhzdQ6fIZipb1bg9hFE
	AI0FumooJRk+pbHhlZyyGX8Rr2pJStw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EBFA61934;
	Sat,  8 Nov 2025 00:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C2DC4CEF7;
	Sat,  8 Nov 2025 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762560536;
	bh=OTeLr/gdmWTJmpiKPkfQJJfAv0QmvVtcPkNjwhc99NY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rDOela9v4Nmo0EdfH0Cec9HO/dHEdeyP+DvdMtXYxA1H49algjk0eMiXxRk2DVLBT
	 gziferQ9JXx+Etq25IJmPttTOmFRuKw+TkiQAiMggVUmkEoZEdFqe7ITxZV4GwSA9k
	 WxbC4PN+8vIuDPtaclrn5UsM6Ub1oa61r0e3rcGs=
Date: Fri, 7 Nov 2025 16:08:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-Id: <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
In-Reply-To: <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
	<fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
	<aQyOZ6eYng-IjxS_@fedora>
	<6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 58E0F1A0003
X-Stat-Signature: u56bywjbw4r5m8obniidirthwpranhdd
X-Rspam-User: 
X-HE-Tag: 1762560537-511530
X-HE-Meta: U2FsdGVkX1/rWGV2CHbXSUpKa/or8b082kV4Pc4YH/jSHoSTAw5cqBxot6mIfj2ybWooKVB3kRTsha9BXCl5JQfqk9uuBpdV69/f7MQH7DiFa/rXBg0krPrRdLN5K2xPneXEMmrVsxciO0j4i17236MLRHfnAcYdjdhx7KSUY76zVY0hpInswWCKjSZYvYnJgK5SGN0hSDpXwCgBJjCZ6tp6DsAbjsvSnzqEad0Zv+jaHRHl05furTL0ocQTRW4BRHReS/pTrtuSYztidXmqcFbKfqlRTVUXvTm7+2v3QwOJ7Ec4YMmz7kV2w2iO4a64XxbzQd4Ib9WuzXdsWsUD/sgXaxMRA8/iaHVCO4fVX5SIjetIU+k8hjkj2nzjHZxlh3g9d5vG+6q2PkPpx48yTGhHNjUZ7ASpcI0HIAsNoy5iVr5pP0jULzBkKwB3TYiusp6NG7sw76kmh5t2pJS/ornOOVpui9bQZmMQUM7o3bp8QwGmSqzFGI1Uu7Vvf5XyiXiuGz9XvE3hH+Fok9r0ze1styIZ7j20hndqOuN9kAzVIrd/jwwk7cTP1mVV/SwtJ8pBUDrOb41hj8SnFkbdNHRFbroo3X8gSyOKxWmEZPJJOaxEm9NKMm8q/99kMegIdwM5Tkhx6PsqJir89R6CEeUDnlYOYvq5syGrtIF7K9rFWUQZk5gXk8IJX8HFGm6z00+tqh4T/EeWYZoHsUorBl4JLEvUVMXzvs8kQbK6hTrHQjbQcoGgvje4ptZalzogWkK3Q2+NXsYqjlZ6MjSipF9lRc+5SUdxiEiWsnI8cjMgvL9vm0p2RONNOlKOw2QBzEUwZyXI5+LDXOh+D2Uo+YmSIft2HfDiMt0dEkEumG6/k3NfFwMpzQjHLiNN4Vxe8holu7ZMGwnFodXQ1gmNsAg2XXfyW1gdL4LaBlceRwIYCqXOgWFD23N9TEVDr5omVQanfWouQOUhalodbZv
 jJRQEVhh
 56IlGz8r4SOA4HHpDAUZPSR86fCUixj6gf7s1/NP9e61Tb6RcCOMyhXIY13Ic5+Gd03Zluy5CXUNIIwIZdmdP75ZCVVwXrOx/Osw+ySdnLeOBndCZHfLqIF5KSwq420STmgau1lqklhgvr/Vm/4QdNHgphB6NlQ70f9yZ+S8uKE8WrOzvNPDRvi72X2xQLl8IJP4zsHcx4IGJCUV30/E3wxZd3pkGdvMc2ZQ30NgbT4jVZSZy9BBsUnI+cPRvkTUrkz90S6tSamK3LMs1sJBzFk2xummycVxU+3HrZcV2/Ilnhqa10iR2+W/y46pUT34W2pvV0P9z93RACxTC3tDuJ0/AqIPo/IJonS5L3pgQdQVzyuoFDxB8SXKgAiZ+TonKWoY3WBlXbQySqOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Nov 2025 10:27:27 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 06.11.25 13:02, Ankit Khushwaha wrote:
> > On Thu, Nov 06, 2025 at 12:18:57PM +0100, David Hildenbrand (Red Hat) wrote:
> >> On 06.11.25 11:49, Ankit Khushwaha wrote:
> >>> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> >>> triggers following warning:
> >>>
> >>> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> >>> false [-Wtautological-compare]
> >>>    1035 |                 if (addr + c.dest_alignment < addr) {
> >>>         |                                             ^
> >>>
> >>> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
> >>
> >> With which compiler are you seeing this?
> > 
> > Hi David,
> > 
> > clang version 20.1.8 (Fedora 20.1.8-4.fc42) raised this warning.
> > 
> > To reproduce:
> > 	make -C tools/testing/selftests/mm CC=clang
> 
> Thanks, and thanks to Lorenzo for the details.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

I must say, applying this would be an unhappy life event.

	if (void* + ulong < void*)

makes perfect sense in a world which permits void* arithmetic (ie,
ours).  So what the heck is clang doing??

If we do

	void *addr2 = addr + c.dest_alignment;
	if (addr2 < addr)
		...

then which statement warns, and why?

