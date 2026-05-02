Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC546CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 04:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587326B008A; Sat,  2 May 2026 00:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537F86B008C; Sat,  2 May 2026 00:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E986B0092; Sat,  2 May 2026 00:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 365696B008A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:39:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC96016047A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:39:01 +0000 (UTC)
X-FDA: 84721224882.20.9938160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 48CFE1C0006
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:39:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVKJ9QQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777696740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlIDMi7oYiwHx70q4i7PWynXdMclIh/XLXq++AYapz4=;
	b=obZseMADTG1xh80p6N/3kIS0VtaJ9c+EFfk3qUlP+BK07LM5khB0TXDrPgsd80r6/xxcgd
	vyO4mJ3tu7N2zRXak6xBikU0QX2FeYbAK/++GRlt9uE6+Mn9IS6DteobcUgc5Wc1aS1Zac
	o2PC3BwX1vNLwr1aB0zRcsNrcsPAzVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777696740; a=rsa-sha256;
	cv=none;
	b=XaDnB4DxzTQ0TZPpMCyoKUQDDO8t5BFi3Z5MVr/IS8Zu4Mt1i6hvUxQ16RGR+wLidLNX5R
	J2+sXLefhVlXXx4jvTxy8ss/qaWHf6vjop+UwQe42txHbHA1Twi1+nFXeJektBXMa1uD77
	e5NNWja6XcbpGXvr+oHMbqJ77swkgvw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVKJ9QQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B1B60120;
	Sat,  2 May 2026 04:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8719AC19425;
	Sat,  2 May 2026 04:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777696739;
	bh=i3HcnCoFSh5VeBUTX60vz5hhURORR//pulP1rg20n9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVKJ9QQWutEfe9rAD+mi+pF45Z+hx9zEJw+1jfpjjALUmVFLVPc+Bnd6N7BEaRh8U
	 QAmwKGNurLzdjVXegKoUIxh+qlfzEtZV5xDMUKHlaQCVfxd0hPiYW2bYKe/b+HwFck
	 ZkicFJK+o1uv0fhywnlKzvoV0zJPot+LU4FSCtOC9GdY2e+uwe0VXDEFw9ptR+6g2I
	 D/I4qE9yKdDvBiX99H6gcwVaUQaei5uAK2OzpiiHEpdz1nepKvVTzynTZpUmvNXYfj
	 qui4o0Vfj4fJxQV/0KPquo0ZXKStj0WahceE7D2wFsji+x0TnslildM/KwG+n7O+UV
	 ILn3tO03CuwoA==
Date: Sat, 2 May 2026 06:38:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-ID: <afV_3ZZ69cpeYmpS@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
 <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
 <afNtnXnU4J6syETa@kernel.org>
 <c2ecd0c6-fbb8-41f4-a7fb-2b1f15d1fa12@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2ecd0c6-fbb8-41f4-a7fb-2b1f15d1fa12@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48CFE1C0006
X-Stat-Signature: wakehbthm1ygc9yeybo9eer16y5ijo9c
X-Rspam-User: 
X-HE-Tag: 1777696740-534970
X-HE-Meta: U2FsdGVkX1/C4E4sm3AM9yIyg/fSZhPy3CefxwWBhkvvp402lg+wyO7F/8OjvC1wbiAU1vpRV8GJ3VLi0id0e/bMkTIgIeZ+hTk/AFWCHg+25MsaX3sqTJGEGmiP0YvsEglCuavmOcuyJgpM2gyZTWQbnNAfEMEMTPY3vwL3dfNmbc/KWHH7NE2AQYNrPfo6bQZVDM8DVIvuDxQQqC1vcBU2oAMqeZH8ynKIca6tH7cJNdxP+m9/OslFkayJLs2lNlwNkqjZIsc0vXHRZek5UUVb9T59NWijTpeLFrNYAj3oh//K5COBLRkB05BpTUpeTYxqPVueeW/jWZOjcR9ynXgHd20a/WTG2NrLdulL4pCspItRtmH0SCyGGeUlzvfRJdMOOQTdwbM4QoPUM85OadOsocQ+FHYWTVlqWims2XQvwUOzc3Oqw3CbMf6yTWFLbfNhZ7JJkd7hArFuM3xtfElLifF+yq3ylLlPd3qqz035+SPVxTHty5aHTEL1WmmV3Xp+A9sEYKRSYqiqgIpQFKtEVhWqSKQVyC8fXz1flqPYyharEm2ZV6iC6rxoyicpiS9BQnKsynCunQ/9OCpFpIKcgoHUZhKRGESh6OEJ9bZOJGDJnoP+mRO2Z6XuTlT6NAv/61iQfEsVN3pnws+HecPOaPjA1/kgxY0eFj7L0XUjP/WfI1I3lyXeuQf3wvJMoTKe7r+Zd6vd/V+l6ygI231eVVep75t/jZyvh/r5BTe5F28xVu8hCPu4s/3PkQ57345Vj6tRKAXBxw7Lwta3t+u9awR+h4wUc++EGSjAOXE8z/D9WQs27oMwoYkMWPW6Wh5S546cE7fi+r8tLlGZhr74QNeYzkhQJodQ9PpYDNXGN+TQG3DM0OkHhqd5GxVHFmXk5P2ka79D1mCfZMmlWY3awwM8BPFW+SBzuzTVjiKlztrWcwpyhgXE+vOM5wLu7oOBog/HfKjN6cY9aH4
 dqMm0QUc
 0vLvYEiA8dtWJMMnBS4QgdQle4/k0/m93xHJBS1f+u8DO5k4gItOy0/2thB/tbqz3VQaRHtjBH2yUd7IFkXXGXb1b8Ef9aIaifSSjlQzj01/nnkMrGNTC1/+7EZ2wU5Cl2rjPiADa75zSeGxjRBb3hVPAApviWX30GZagPF29Yz2ylNGHExKn4OX9FEJq+egrKMTutQepbutZtCsQUTqxSiTJq4rUSDwZ+E41fjd8n/YM34DLO7L0pRvI1KOP717pmykl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 08:33:04PM +0200, David Hildenbrand (Arm) wrote:
> On 4/30/26 16:56, Mike Rapoport wrote:
> > On Thu, Apr 30, 2026 at 04:23:08PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/30/26 13:38, David Hildenbrand (Arm) wrote:
> >>>
> >>> Yeah, makes sense to me!
> >>>
> >>
> >> Thinking about this, is it reasonable that the kconfig stuff stays in fs/ ?
> > 
> > But it's in mm already.
> 
> $ grep HUGETLB fs/Kconfig
> config ARCH_SUPPORTS_HUGETLBFS
> menuconfig HUGETLBFS
>         depends on ARCH_SUPPORTS_HUGETLBFS
> if HUGETLBFS
> config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
>         depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> endif # HUGETLBFS
> config HUGETLB_PAGE
>         def_bool HUGETLBFS
> config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>         def_bool HUGETLB_PAGE
>         depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>         select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
> config HUGETLB_PMD_PAGE_TABLE_SHARING
>         def_bool HUGETLB_PAGE
> 

$ grep -c USERFAULT fs/Kconfig
0

HugeTLB is another story.
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

