Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA84109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B466B0005; Wed, 25 Mar 2026 12:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5346B0089; Wed, 25 Mar 2026 12:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC9E6B0095; Wed, 25 Mar 2026 12:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25E9C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:09:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7B7B1609D8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:09:53 +0000 (UTC)
X-FDA: 84585071466.29.0CD5F02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37C11180006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:09:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yu2nTqTr;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774454992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hvko/myVXBSL3XjUJs7M6eNXPWsG85odKtJdX4y2Yg=;
	b=8EEo91lRi8AWJ+G4XlUyMo9tjrTOp4pdG95Om6pfODM5EIEAKoqF9HKLj9xzsBKeOah5m7
	8SCTh/G0G4W/h1y6Io49JIEIxPzdLcZRAUeqSY6LOJrLKXWiPrp9Pe44APnuJ6Xx5+f6Q0
	U8grfei3hydjVt0GdqzBAcJZuM2aGzA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yu2nTqTr;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774454992; a=rsa-sha256;
	cv=none;
	b=bUFJZ1TZWxRUayxVammkjGtNpP1dbks6mTIdHk4gvAF6Em45j/5tOUjJPQBYLlpr1dIJGI
	Mf/vRLoeEtyOzXN56nKrDt6eTn7CQVz0xcO6VeHB4YdY2RR6tn0JiUUHObyozaX3M6B8QE
	RWk0BFcE2MGQeNTHQ/pqwv+puNM35zk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CB73600AC;
	Wed, 25 Mar 2026 16:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBA3C4CEF7;
	Wed, 25 Mar 2026 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774454991;
	bh=CpwACGnKbmh8bnL86Y86WsKuJUxg5abhUqwLWbX/48s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yu2nTqTr+4Ixa0aIK77JmVd/k21R9kBHnAAnN62dMDBskTZPMj6ItigXaNiPWYaDN
	 owILDdRj9CR94Ne+mlXhFs0xeZET+j+BL7Wc2PyC7Y5JlWmPDlJwczr1b4LsYZy2nY
	 cP83/jsCsjO9VMlXX+z1yugQE+WA+BNaE8wcuZeA=
Date: Wed, 25 Mar 2026 09:09:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
In-Reply-To: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 37C11180006
X-Stat-Signature: 96urfxsykaygzn1fy4gyg3qnrf83jhnp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774454992-609811
X-HE-Meta: U2FsdGVkX18EY1Y5Mqv8hzBGSqsh/y07IsuUeTjnwYKBo6NYXzEp8qjS5an3PI7Ws+Spqh+8vOuMre3kaEFKBkpCrr6aZkrYy014M62euI9ikEzYZI7rMQ3kCm6jKLnhNY73tFcmN7SiG71OdSv6mF074LJ02tPG6QiExh2Quurt28LsCT+Ld0ZSMzZpo+sIvQMiaZsRGmSpUnXBBvSGPcGYgFjAOqKYTJCpXTffmJC8yjTLA9lZpmbGhQO8mHBG6a9H4wSo65hWqZ09yHh73XdtX2sVRGSf6OEIqUJ+GFVPGcHfktsJasMS2CEbVPjhtj5z13962zca8cJROsctsBVQWGRqZKhf7A0987bmImMXINcwy52hom9mm4cSiTNDzqkoDq37BpyrcT5xo7H0LglqkkHmjRx6O+V4se+9mvmb+6DZxo5g9elTrgCVLSlsl8mEcUJN0s260rx0M+HHSA3FIXUAmmWkQX5q2wWfpz6ZCR6HH52CeoKTifO37cA/Eo4+rxmxCY5q3PpVAxCeQ/B+8JDFGiFqlDH/fR/Lmwm0iTzMJ2AoD6ePnIIkyGsPvG/fE1E0Ln+iwvjUrwJqLbgYOBr5f6LV0QH/YllOsKrWpfLBdmYfeqsHZZmpgwDod2iXm/5J0eg9p7tlu4BlHqOzCYmCRw2fOItZnhbqaOoYY/cu7X28kW98/QIg6CZxlIwWORZ0aRru7uVdpi33nVp1pUfwAc//GMuw7TxuhVm/A8cM7E27XfsS7UyRZZiCfvGCSb7jpleuJ5JY0F6kMja/ZjaragLu27tZfwe4C8bKsW5c1Cumhi289W7ilvSXpGdZol96OsuAp6igUYDl1Lf+7fDNKAOuj8iIrYvdeBhSyfZ5bim5jDqGE1nC5vHrgcdn++xiuOY7lo61EATK8E3+llnmeqfYIjzdbV9wkGnQtU8HzFD1RkKToxE9QexPeVZgquvCJHcM9yWqPIs
 PLc1NT1/
 wO6YYYtD+8NCV0aP3e4crL+9KZKgkTBKo734ATnQNECRx7ZGNaSooJaZM9KLnzSB4djsR4MFOxkR5pGsfQq+gNpd/lfM6ETBik6dHfKidle5lzONumasJUMnMTddJEg5GErGSyOFII2PyydAUWrJbscR+1vdR2zJUwBENv5ChDA/5g6MOe9Nc2UzcFzrCHUDjvutZVfXBA43bNXGji2iOhWCy2sUTGDTfoPwH+VH3zMgHFmzOdyHda5vqFuYaXnlx8hN3R5L3JTy/ybPpSKphezQLjpA+7SfX1RfNiw4Fz3cxNcLB3MLUVTaOl1B5xIRBVX14
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > macro) always being inline, as we rely on the compiler converting this
> > > function into meaningful.
> > 		meaningful what?
> 
> 'into the equivalent compile-time constant code' probably fine.
> 
> Andrew - could you update that if there's time?


np


: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler converting this
: function into the equivalent compile-time constant code.

what does "compile-time constant code" actually mean?  That constants
within the code are evaluated at compile-time?

