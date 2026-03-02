Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D05DEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155576B015B; Mon,  2 Mar 2026 15:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125D26B015D; Mon,  2 Mar 2026 15:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0691E6B015E; Mon,  2 Mar 2026 15:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA24D6B015B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:50:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6B68C185E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:36 +0000 (UTC)
X-FDA: 84502316472.24.544B0CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0860C40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:50:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FMTwm01K;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODWr/y8r3DDIXUnbUNf5ao2mOWx/uG0UmoDM9gRt+qU=;
	b=dU/lczIOCRm4zGD5L542MnFO+xHtBkxYcvlubgXQpnWTnDXQHcXUdG8xIa/uTANirVsUXx
	g2RafiB1B0YvlFDsLC4sX8FFjuhXPsXoJNE2CO/W4XyEBhz35anYLOOyfnP/ilaC7N8Pet
	KoIgnov65TO+SvFe1pjF2r/rkjA7WU4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FMTwm01K;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484635; a=rsa-sha256;
	cv=none;
	b=gMW7gm2bqr4Hb4dvpHGo2ppb9Fm7jDn6pOqDrt1Rnl+akZKUz8/d0Sw7LVpILZGqDpjFaI
	+cjddrF9EV41uWzjvPvUlrDygJyUqy93q1tCyjD7vcOMxauMk30K4CefhilBR6CtbgkvnO
	YXf9Msq4eyS+1T9PYS3NJxcX8O0P68g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C0C7439F6;
	Mon,  2 Mar 2026 20:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B44C19423;
	Mon,  2 Mar 2026 20:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772484634;
	bh=fe7AS7bSDFxyvKsRQWugpHVvNgzcBXPHv5cLcMLOtAw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FMTwm01Kj7R+4a+olQoLyISuk9xZtau1EC/9KpESu014RRC5M1wdwwFKzcyBGqxNy
	 eYSciT5KZ0FqX4XQ3ZgxRmMJs6TRThZmp1Fwf0NFxHas/OeS1E5+aMB3dKxGevT4SH
	 rwau/x3lPnzoZKaKeg9mPjmNJ3jYeUchr0Gnd898=
Date: Mon, 2 Mar 2026 12:50:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
 <willy@infradead.org>, Chris Down <chris@chrisdown.name>, Suren
 Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-Id: <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
In-Reply-To: <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
	<901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
	<f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0860C40004
X-Stat-Signature: ijx79gjmcpk5sqm9deyoqzphizo73piq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772484634-735499
X-HE-Meta: U2FsdGVkX182lhQb5ZPnlIBF5d/Bscg+3G0ZMchbrttm3n/sZ+Jyan9A+H+jrsDw9SoatLjmfVj8fztGwBhq3IDTF1qhIEIDG/QkRbf4oL125cqGeGMoKUAZW5/dx/bUfqs45piSUBtXo5LmEO4/1QS32mPdCHQ4/xlE6ovtWmsg4chGxAnroCdmAXVpK2oQYZIEPsN0ok+lV8x3tpeMOo0dpZAJLfiNC3zxur2M9+h6uC/4/oaXy5pmXVasqyNRPakSDWc9/NztGk/YwIc34JJT53E3V+de+7U+xFxIsnLJ9GggMRHWYft45lv70NaQjN8sXWaw/sfDhsqEilJGa9MShfyZTsLZZyf5YLg8nLpy9KiZcznerRkBX0pylZa+RlCtK1G+SI2jkwt1e1me7sZuv0pwiFPfGk5z+YOXj+DahNnrRN9JoZP7L9GzBD73t4ISOjFqn61u8E9b5+zz1/Bid4MBNM3UdDOuwIy6LCSkKHrmoPfO9cyC35y8SxdkOMStFaxoXhGCULlaHFQXMEHLWd4hg4SOjZat2n6FffQPRakDe3VWgcNzbxB5XG3kllxwif6Ah1+xlEVEy9XgV2FNDfcPJn3sinrGcKPTIz5RX+I2q5FmUqW+8im3plZZmPHh5U5Dqwuh2vkcxLK8jRwI0L1Jl+6kzseUr3fUfZtCIe2VH7dEMYXfvTf6mSUuly1v+EpczKMlGcgnjuW+/BdRD9RhX6/7Puxz9Kl37bo6AFAJW6A4lZPwLlxPvyB85eAOR7CpQVTe2derqwhXJ2bJfGpP6UBDQEjD3D91ayAbTXpHTvsRGvEV6D4m+YtXCnCSWqheP3qN1IhN3yyKn3f1a2saP+xpLdAcOdClnxOhWcE2EcN72y2Ht8ZxH9KCYrKeB+rFeo5mO046U1sq+LkSzInzBeiTty28j4Y+VULacdNwUTIfsXZxGPw3eghAdTt2nxLuiFqozIimQ9s
 EUMYisaC
 vjnT5+tlAlpu7TEnSKMoVjV650D6UC82duD4kzaftN14LwawJorEMJddu+RuVsuTJzUD9rAbyvNGYZmkffqILMoVs1TKk/N5dBc3REyZKBj9AiZPlmSKi/p57SG+OGgjVqBa4ie2OkvdMF0OT5FgRg6Jy+UJun813WQjg8/BVa0g82ZHdfWy8xXYIINTYVCEqtfjClYr0Ko6zbnJCKa1o5CN0wQMPJyAI1yLwtWQMg5gN4t+1jZsV/NFbLqtZKxP9P6doY5IyU9WX7qxNN9NuePctZL0nOUTabh4TxOmm7VDs8FpSMbQXQpSBYqn383jKBTWun/VhGmFKCV8tUsKOSfXv6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Mar 2026 17:19:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Mon, Mar 02, 2026 at 06:10:06PM +0100, David Hildenbrand (Arm) wrote:
> > There are already patches in flight:
> >
> > https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name
> 
> Yup, if people would actually cc the right people I'd not have wasted my
> afternoon.
> 
> Replying there.
> 

I'm not sure where this is headed but I'll queue this patch for now, to 
get it some testing, to lessen duplicated bug reports and to generally track things.

