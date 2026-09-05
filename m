Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9118C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492786B008C; Sat,  5 Sep 2026 07:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C096B0092; Sat,  5 Sep 2026 07:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3976B0095; Sat,  5 Sep 2026 07:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC2BE6B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:57:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50A3412033B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:57:56 +0000 (UTC)
X-FDA: 85179559752.28.36FFF14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 879F71A0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:57:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zRIEiSll;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788609474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/x9C5bNxNWl9gURHOdoOE+fPK6NtP9yr0zoY9jWPaYs=;
	b=A0ja8RGPGM9PrSg9fvXpOKNjEwWaiM7Sy+UO8JKZLjBIxzfkjPt6wnAVxbjmvUc3hv15uY
	6MaZaiEjXZx2xiHtmbelmsnYM7tEeTXYZwpyLZJn9fW7Silou641sFOCchUjl1Yu8dYbEI
	jyF0QD78lygZTc0BUdQ6AfB5tFBe1Co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788609474;
	b=ETXpuf3/e1PBNV1mwSOg5jDoceVYZMAwykZBM45lMDmgnB1baGxBJ+gs4/K147IRw9h942
	19GDJfnLD8BiTFE8TbdQ8FdR/xv+8cKKvEYgNrk8EiDKQ5EWtZUdGWY0bqC6NS771b5vUO
	X1U/GpOy81fH7adgQmGmPNNw7e5q5bU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zRIEiSll;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1846A43E0D;
	Sat,  5 Sep 2026 11:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E51F00A3D;
	Sat,  5 Sep 2026 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788609472;
	bh=/x9C5bNxNWl9gURHOdoOE+fPK6NtP9yr0zoY9jWPaYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zRIEiSllWjjqKMphf2jfhctZ0NlrXjWQRUU/AfOo6qNsCmAQeLVGIh/ycZGD0zEwP
	 YR0g0dr+06CYTBIYyLs2S+/F8a5umC2Yd6op83rlS2imO8nJSMDLYE9lBTSnuy7y2w
	 Aix1OCYdeLxdsFOw2HgXwlLM4M9AuUPhixPage20=
Date: Sat, 5 Sep 2026 13:56:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Message-ID: <2026090538-irritant-tattoo-caa5@gregkh>
References: <20260904045747.813364717@linuxfoundation.org>
 <20260905114111.124795-1-ojeda@kernel.org>
 <apwBsCGpUG69KdGc@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apwBsCGpUG69KdGc@codewreck.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 879F71A0003
X-Stat-Signature: eg7c8e7tg9i5hqyxujipkrqa45jy9dj6
X-Rspam-User: 
X-HE-Tag: 1788609474-676494
X-HE-Meta: U2FsdGVkX1+LIHJq6V9e3Q0sWv831vBy4nr4Txfy2YNSs33tvkh1a81wBSAu1pNGgCmVY6s2bgCyVBdfJW+PA0vHK1kFJF91s63MVopNyP2MokrSeigSMhRDE8JNkV9d5OvK3pwP6L3YmZhMenvEUuzDrpRh0ZvQAT8NA01ig/dFmg093vq6lo/GDqyWdu+J+BpV/2URcQEZMwRjvC4s8G5V0gXZjDAT75YjmUTjLT68LzROW/IbimKbl+8fHbOojwzk08coMBuLXTI3SVyyJ9SSzST32V5t2Ghvsea4cOv8pPlJ+B72mVUsGtDyeDsRXv0DHpdtGjvQABZPzT7n5q7CMpppUqZzrcLU8s6FIt44ee0eOHEpDwRgRh7FArkKvTrpf3fSzAxgBY9CqXnjoSsvm3HTYlDN5VfinqhepW7jF/X9Gh8LzUM+ckNUU43VasQoa3daFh1qlGFI+zQLo1Duamp+i/EYjGIJ81TZXuil/KjlsmuSv+6aXoEQcGRbrv3jNb3ttmhfDJPHxgtwiiWrc0QObVGyXLWbKY9KLPjjineo4lXIzmehuY/1bnfMIakTAmSItiGenpYoneIzARtv7wUhAhsdV0mxTl4SfHPAEjKw5VAph3D41WaxkBYtRZ9NQKgFNO6DvYyQWTjZLHy0nTgsOoUI9XRwzLVrVP7aTfCIe6Qgo8LO0MD8MVBoSf2YItdF63D+aMW8ex/HzhxSBIay+ewmg7w7LvBmztn2bCBUzlGynlywMrs9zJeRgS9hkAoDfY4fJigpwcWXuZq1y5/WkvwtlVaCiLzr011z4NKzi1XdiMpLBXuaks4Kn6XEz+J0ydPTpCLk7sm/umEtl9W11QwIZC+VOng2qbsSjub+gAY2paY6YTN/900DBYVEDG3qjp0zCbUfWEyJPTi3VVM2WRphhLKc01K/u2FnxzJzu4xQfRCB3Zy7oJrky7F5NXD6pS41nF3XUco
 nqEis0TP
 Ec47Ca7N86qQUdQw5arbzqKVfPdVv1vom9jFGReRxFhEYgsNe9XCGqJT6N91uQvEp6QBH/quIrnWMP2wepPDGb6nrPozRt+p6Dq9zViobMOItC+E9oXY6HV8CCVZ5AhYFI9FhFw5TD7bzAygPqEJUqhqBKRgBMWgXq2odyZb8YU66/pS1kSJXwealIhfm0z2rnl5sovfmnXeGxPf49TFbNrmNtVAL9w5qObJ9BPBL8aaFIhfG8eD8VEvkhZUOk/Kt1d4W6vETTkqAAef2hqxFarYPbUVOfieitNiXcVaaDFUdh88II65sLgrRwt9QIl2YbiIuPaG622QNCXa0hgj7BduPSww5W2PTkoLUEU5jj+wrW9BA87bOxDyuyNxJw7A1wJmqhV/PpCnfbzwbhOiQ8Lim6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 08:49:04PM +0900, Dominique Martinet wrote:
> Miguel Ojeda wrote on Sat, Sep 05, 2026 at 01:41:11PM +0200:
> > I see the same arm32 build issue:
> > 
> >     mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> >           |                         ^
> > 
> > In addition, in UML (x86_64) there is also nearby:
> > 
> >     mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
> >       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> >           |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >       111 |                                       pvmw->pte);
> >           |                                       ~~~~~~~~~~
> 
> See this 6.12 thread[1] for this build failure (I didn't check but
> assume it is the same, that missing commit only made it 7.3-rc1 but was
> also backported to the 7.2 tree, which also explains 7.2 didn't build
> fail)

I should have this fixed up now, will push out a -rc2 so that you all
can test it as I'm away from my big build box at the moment :(

thanks,

greg k-h

