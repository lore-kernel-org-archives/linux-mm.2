Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD19E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 22:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990216B0088; Sun, 28 Dec 2025 17:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E8C6B0089; Sun, 28 Dec 2025 17:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A586B008A; Sun, 28 Dec 2025 17:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70EF46B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 17:35:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3446C174F
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:35:37 +0000 (UTC)
X-FDA: 84270337914.21.3B044A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4BE51180003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:35:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nOPuJZfl;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766961336; a=rsa-sha256;
	cv=none;
	b=3NrXRctgXA6qQmIpclrM9NpRTtMJf0FUduhIMY7DMbe0Vp7e4osUtzproSYGMwOGE+wktP
	xeGTKJklKET1fW66l/tRE1+mI3UF3LDRECFxZyMN68SDlljozp8H5pMcLBgSJ5Bzu4hFil
	OEDhYrD0VCV6/bC+Ht3WoW8DcQsQ6DQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nOPuJZfl;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766961336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WX4Noz/n1laWlBKp/F6l3H3S4jFd7v24aGogVxWXj+8=;
	b=XwvRygdB+al7bEbDM7rxG0GJwQRonsDxDIe/E3WVAFaZr92krLz0L5nCbZ46rVYtN44LjF
	4GQREnFxQFOGJxo4J3OEQhV0FjXp/6v+WpkI/hg1KtkkgZFdlSreRwpV6tCeqnDUmk9kXP
	CebXKETZyZcU2Clh7Tre7cnWOknDNOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CA2643B59;
	Sun, 28 Dec 2025 22:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A93BC4CEFB;
	Sun, 28 Dec 2025 22:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766961335;
	bh=CCaq+l+K6wsYD/FHpHvOEK+EvLHkFgdijLHqm1YV+20=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nOPuJZfl2av023bRQoktGLNCM+COk5pIMCL3h5ynU6rPF27c4c3qUu5AOfYvG7vuD
	 XUd0EqFI/LwVzvFi4U2RqsdgzyWfl4udZmt5/fIM8f5wWAzzZTy33cyo/WkHWrmA3m
	 dygVpmyLfSYEdyA81KLsG4iO0eh6iw9YBanxpO3E=
Date: Sun, 28 Dec 2025 14:35:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>,
 Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v7] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-Id: <20251228143533.33e2be2d6282d036f55e12cb@linux-foundation.org>
In-Reply-To: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
References: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4BE51180003
X-Stat-Signature: 5ic5beircaw5znd77x4oodcsaaeek56t
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766961336-418099
X-HE-Meta: U2FsdGVkX1+BjdzqO3JuC2vP/qt1MwkTgZ0gvuhlZky9XWkIqGsYA74+ILnvv4frxpgH5dl0F/mXQAk2+NPiDt/7TxEbN3mNXlh+i0n/g/d/6nMG46TJIqw64VJSSeUuFV2qMW2X+Ji6bmL3hIO/iSA088wniQkbjBLBhMPZsN8h8GcaApHfaNHP0CUdY/IoSGljBXy1YB7+fUKseKZsiHEIDv3pci6pzFkhtIQLbhFPsXDfuQu02+5N/4sb0kUokyOtk12+J3qVDRxt8OOHZkMEwqWyEAEC/hdfO9wgJ4ris/bN6PdsAQZBKGseOB4Za46d/JXftaWnBFV7FGw9c6+/DiOYEqK2nbNLmAJ5IK69ikugwVgTIqCXmrIFNimoPJ3mrl6CqdQ4ib9WbeltMaU8hiNYQJAuXzsXLFEoCRqDf1hZMO8rtXYsS6Bi09CrxENsg2ci29CTMhnq3PINx2QK+eZ5krEY1jvRvNjrM9rHB3md5Kh4eVrOeV4z1yr1tt7bWbdOriiVUjt5jYwN3btWMjPNAMOdlcl9PxEoG0D25383+pqal0bAm1ORDfMpnA3xoB0/X5YXV9OybVhcgQScMUdVvMClGsYyhDGXqlXTxzlkBbB7goJLdvVTvYzFY7Oe6o00BVUwhh/w7Gq6gBwjnm0n4CPdP8WwqC95vVwycDpDtCi7IwndJ9J2wxL0ADME66bUF8UXk3ttCXxD3wAN0Z0aRy8lAXmlZbc+BzSEAa+6LXd+HaXQWqzXZPWBBCXtJf3KMj5h12IyUkHFSKDuEO3Zy5OTFDS82YMkEA2CTp1ieNOPv3oWYd6lyOwBTGp9FEfg3SQi964/ATRSNwQd4yYNtTI/KJY0EOvRMawY+A6sRUYFXiXTH9ioP+mH5Efj2GlTUzoGqwZz4ld9otLx1QqK8Lg0tE5XYwRniCxJaCRzzaJ4lkuKs5XGXHR6H+sLLufjL8G9ujNhrVU
 PGuG9CCF
 S6TVBvvoIg08fcssLeE8t2bphJXqtLrf4z9M3zRokJdJ/36TIkJOQbREcljE5oEFseztJHdiHh1Kpi2JP1wp3H63yA7f1reSA0rU6V3YfqY1z8stbCoIPGiwrJt1TWQtcj0S1oi/RiDLriMm28adrKDB1sk0OT9UdszX/KMDvJsqaDERuF9lUFJDUgcKoHOxzMEeAWN37FXQ0WElprsRL3fppRXnLxd5TKRGy9MWKfgXJLLAudpHx1YdMzgeOAwFcKrRykn+2SlXBagTWWgZqRp6vrh3pkRUiMxHvdl4gOnadXpYREaf8DksGVi8YAaoLciUtu33FWeE+Ohiz36cO7aICkInEU2+uLE/siuncSOBS6a6MhNG7tGm3Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 17:25:24 +0530 Sourabh Jain <sourabhjain@linux.ibm.com> wrote:

> Note for backporting: This fix is a partial retrieval of the commit
> mentioned in the Fixes tag. It is only valid once the change referenced
> by the Depends-on tag is present. When backporting this patch, the
> commit mentioned in the Depends-on tag must be included first.
> 
> Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
> Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
> Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
> Depends-on: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")

This will be the first "Depends-on:" in history.  Which is a hint that
we're doing something wrong.  This innovation will surely fool any
downstream automation.  Let's use existing tools if possible.

What if we just said "Fixes: 2354ad252b66"?  That would tell people
that 2354ad252b66 is required for use of this patch.

Is there any kernel which has 2354ad252b66 but which doesn't have
c2833a5bf75b?  Probably there is, as neither had cc:stable.

2354ad252b66 is from 2020 and c2833a5bf75b is from 2022.  I'm thinking
the reliable thing to do here is to simply use Fixes:c2833a5bf75b. 
This will tell the world "please add this patch to any kernel which
contains c2833a5bf75b", which I suspect will be good enough?

