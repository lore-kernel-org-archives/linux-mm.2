Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D10C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967546B00DD; Mon, 29 Jun 2026 17:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918576B00E4; Mon, 29 Jun 2026 17:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2006B0102; Mon, 29 Jun 2026 17:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4294E6B00DD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:09:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4CEC1A02A3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:59 +0000 (UTC)
X-FDA: 84934189998.06.D14C809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDF0FC0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nd31O+T4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782767338;
	b=sPGRmPw4/As6xVUdK6LQKFciRugPBMLIDhHxsXnieh79VqT0SXQQT1Q8i+M2WTP2YGxQBk
	T10Q8up/HcccvHRdbWUaR6tOQuKCkl6BsTnjHIfbJt1ZPyp2nMwz2D3oGlNEqdYGEEI0eh
	M1SnqrY84SZ91h9aTUppgMD9FhXT/Ss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782767338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qg0jkovDHOQp4wjev5J5mR8Y9cw9SpdhVKuP5+MzNkQ=;
	b=fJ7M6/3ySIVwmIgyVT+QrsoIREEV1fsIoqdY4YTsz6LK4lIXiMrMxFMJCywFuzfxV/8ehC
	o1DtRHZhlGl91BM1OS/s7TAl266v9HQuOVcIp7gmGJQzPg8AqWyA/LWRB+is15gk/pDu1w
	mrooGoJGsYMAw3ImCb8SjyFgGORGvFc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nd31O+T4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 160A9600BB;
	Mon, 29 Jun 2026 21:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D73A1F000E9;
	Mon, 29 Jun 2026 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782767336;
	bh=Qg0jkovDHOQp4wjev5J5mR8Y9cw9SpdhVKuP5+MzNkQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Nd31O+T4SwPacQvW01Y4halbn4fnaEYGVGkOPWbyakLXiuuOyznSyd1J4OXuTSTEW
	 nc4LWPrEZl+CrzggOcBD8dnto3D45scDybFn+sPq91x+LvE/sQxZPCJONY14Dh2TNm
	 chJh92007puaNUQwyI8du3eTxwY5wQS5lrgW1Qmg=
Date: Mon, 29 Jun 2026 14:08:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Peter Zijlstra
 <peterz@infradead.org>, "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] mm: drop pte_clear_not_present_full()
Message-Id: <20260629140855.584366abb95888a2ecbf4a8b@linux-foundation.org>
In-Reply-To: <fd1b4199-ebbc-420b-afe4-3bea4b9149fc@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
	<20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
	<20260629102215.09605f0e9ef66c5f58fe0932@linux-foundation.org>
	<fd1b4199-ebbc-420b-afe4-3bea4b9149fc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDF0FC0009
X-Stat-Signature: yqb1fzujis9rxp5oka9cco16b6osb3zu
X-HE-Tag: 1782767337-71032
X-HE-Meta: U2FsdGVkX1+daPJZ7Mkn6lctkeJW1QMRLXQV1OcpmeLqDcRra8GTIRwHn7bXO1iAx/oXra+pJbf6W3FXOnzO9ZCdYhMmWJ5rHpF199GuHfsUb4j2YBbusE8OnAX0D0JfubvycHZrM1O+ppn491tQbLMKk3ApRpU9BSpSOwKd7YpJEy09YzgqZGWb0ClfsMV77a4x/qy9lTu4s0uG5yKgtUcAZwAqx3uW0MgfyNmqxbhC2uQEoPKnv6nga1uZOwx9ilqfIrF116kQAwitBu15w/oHVMueoXFiAC5K7k/EOSHs0lYTclo89KrmsKFti4m+rsAJCvRJHWzxU8wMr1X8SRKSWsfX6f+9wTF2nliTsDwyOfmf8KuVEzQ2A5XzK+HPg0ihlgT9kMsZS1fyS0C0kAsilOQ2xgHhmVYWOsJCbG11N8WsD0TqVsuqmPiiTjtQb6a/b0fY/+nV32P7twxMSzWdCQwwheps2k5N9RfOwjKem+VSCOFT8Rg6dH9jUs8JY01QLYyyL+wu1m/LtxKKSIIQ3HIgDSDNErLhxB5Tf+uvlyedR28qk2FyB59WSiAhBzHDNWhH+j6OuuMvb6TjxkqqbnvBdxSOKsaEibTDrza98ZtjGaTi2RovZlphkG6TBzdaodK1vG4yV+r9uo8lXQ1Z6mfB+2xbEXObQiA0Y8xbCLBopvspCpn/H67M5PirSiVSliUkJUE3AdFz0iz4HnTK5b7cyqslXuDKkvFS3bMt9VfVbwCd9SK8IhggfgDljOwWcc7ooWHGaekXkNIdbawbvRzk2ulAftoK46njoRaHfDU+Ea9RIX/tNfKJWRKEClC/mA7brEZYourv0VVZ0nLIFOzFnOU6t4nH1RTdZtuuPDX7kds181juK5qmuXoeVjCIpkb9OESzQ91R9Wdy/72X02KbcdK58WMuQTLQh2i2ZfCww3r2awduGUEJ8/scvZt4mFdb+ALE40y5cVU
 HswEsmur
 7i83cz9b1ALw7fJCfIHCsxHupaci6ulYnqA2QBhrp/+htXMmo+E1pp13wEzUksamcuSP3I+ouhA+1//UThfZv42d4Ef119SW6UDGSkdPtm0L84SHbN1wNWzcADySPBifqyJcXOP/4rGD0Vn++L8lGHCDmN7IVFW2mmrQ59DoC+6vJx5Iv9T4cDNZs9LmYZkj/3A9bJDGNbeAMPmXEDQG6JusXVsCUchPmcEXFfQZq2uzMybRR89TGfoZ0euStPMHYMTN6B0cjCq9j2Nh979dPFftBf8Iv/kzl4BOcsKjJ2DFJuqcFfMgllXgjfXFohkMHU0OIaOqapTtRJKzFb3h7sH2w5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 19:43:53 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > So... what's happening here?
> 
> "nr_pages" are not modified in the function, so the compile does not complain.
> See below.
> 
> 
> A private build bot barked at me after v1 for
> 
> 	arm-linux-gnueabi-gcc
> 	openrisc-allnoconfig
> 	um-allmodconfig
> 
> For example:
> 
> https://lore.kernel.org/all/202606121420.Wke8Ipgx-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/kasan.h:38,
>                     from include/linux/slab.h:264,
>                     from lib/test_bitops.c:12:
>    include/linux/pgtable.h: In function 'clear_not_present_full_ptes':
> >> include/linux/pgtable.h:974:31: error: parameter 'addr' set but not used
> [-Werror=unused-but-set-parameter=]
>      974 |                 unsigned long addr, pte_t *ptep, unsigned int nr, int
> full)
>          |                 ~~~~~~~~~~~~~~^~~~
>    cc1: all warnings being treated as errors
> 
> 
> The problem is that addr is updated (written) in the function but never read.

Oh, OK, thanks.  I altered the changelog to read

"To prevent the compiler complaining on some configs about "set but not
used" addr parameter, silence that here."


