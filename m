Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9865EDEBE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5C66B0088; Tue,  3 Mar 2026 20:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3FA6B0089; Tue,  3 Mar 2026 20:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0784A6B008A; Tue,  3 Mar 2026 20:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E83676B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:42:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 889EF1403A2
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:42:31 +0000 (UTC)
X-FDA: 84506680902.22.6C25410
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B08E340010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:42:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sMxFd0PK;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772588549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8YHsp9xdDp5gO2vmWp+Mj1tgnlCCmcMHvtoXIwTi74=;
	b=AuufUeC2T1Drh5hqoslbuXAbfEDC9boO1ULRMEaN5AC/t1Q+JhTiQyeai+woJwk/UtNOEK
	OHL3k7aoVfVNRSQ3VXrvkaNPJ6HaBy/y0I752u0VgBVBguE2Gjm4lQ7d7PdnX8g3w/kcsq
	VYjVh0JkDxgMezzGSPoXvn+gxhU2JKY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sMxFd0PK;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772588549; a=rsa-sha256;
	cv=none;
	b=Rop0/2blEmq40M/MVFLMvSHmJpq5JTxS7wgqjprnV8ulNkv5CoPOPdEgHGoeieEc7DkGgf
	LERghKM0BYPxfygHG0N9sI9lqD9FnRgHoyPN2oa2hMla2/P/5ax9m+e3bOnI5uEznIml+d
	QtCjPhPlagyA6IdmKu25DkuA0vEZsiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2CB64437C;
	Wed,  4 Mar 2026 01:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F366C116C6;
	Wed,  4 Mar 2026 01:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772588547;
	bh=HtUcXngqU2WZtmvYiLqh/Lz8u8AzPsTyZFzC+kUR67c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sMxFd0PKpApfPEmkkUs99569yVWTUbSLlU2F9oWXQ8jOwRn5sV/HCZ3itm5+hPiLS
	 lCCrK9DTViXSrd+xCd4yHMLOHJiHAjvL5aR99MamoD4RVHKcEGcSc69VxSwxFtxTwa
	 ccJzlyXgALGUYK0cAZ/YbmDvqavbwXErIhX1ROfw=
Date: Tue, 3 Mar 2026 17:42:26 -0800
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
Message-Id: <20260303174226.1b9079ccd60164fe0b28a3e1@linux-foundation.org>
In-Reply-To: <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
	<901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
	<f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
	<20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
	<a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B08E340010
X-Stat-Signature: kue9fundowgmpcouk8y7jgyt4ia7arar
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772588549-624011
X-HE-Meta: U2FsdGVkX183J0K8ex3orzeCtRN1eT7prj3gYrZYJA/n4XhE60J6zm4Sio34Vo7Mm+wjMfSADTDQHZdDq1nDp1qLVJA+zL/ICEpeJeQb3RQRleq7BHJvZ2wFu7Ic9q62pwjM+biT5EIXSp3NCDMfa021FwhBu1LRo/OBCJ/2sucHw4RKS6y5raDDsl276wOKPMlX1qKgN57udCkaiy5RVllHK/Z7GFYgPYXDPvGb6Vlpbch/S6nI2lGH6OsshOE0Sce1mDAB279T50XyrI88z1mw1swcdUTRCOKc2Qa4MZy5REtjuV+wUE/UMJ8z2ZAQfMZc1LCuJiC1cQVcZBNhWFedULrL+c280yDp9Nt4jXKqwHClIjw526ccj74pXuopi/2t6nXkF61p3fIz3PRfjPLlxiotPwmpziscz784H/AIS3WBsRzc5hKY19C87Xb/Nx9YPJMenKb4QffothWJ+0zyZ1ZnmphRmdjap8n1/7hYUxyr9ilED5xs9nBmADt/YvpqIroKTv3tgBLmZDPSlCmI1UPYShEuPnkYzye06bz3IV1Ks23GKax6UlRd9XpxgtZApr4bi6DoBMq2qw/0fXIUdfBrJamtBhgESipOX+X0EmH+8nnT026fLZ+yT2kQ3905ZV0VA/pK9oiKSp8lC9EzcEXMuPrYeVIcY1SR0E7N+zTd8eP54xJkHCmOG49zSMoRodXsnsUGbObV6uCihyV7rbRdGLohDuJn9U1mPhdKSGc+i/pvra0nDV1o6m6Pb7ckzYLnMIa4gp6QnoOkssjYPaMQ1PLB0uM9IkQer0v54lT5ZlVphG3wJpbgQQWNzdezsrG3QWhJH6LDwsquFNOGCDKI7jW655NA+zNJgy/4PWhdXxrSlKuC9hKs/8qjimGcA70ALFVrMahFuUxdkGFMmNYiHiv2SXCZLrjN8xZlILpFADWQfyB9TSpNXjHhj/8qTEP90uJD0SNmdYt
 PSovc01V
 Kbu9TchcHDYnqmIo5LaXv9aOYy2pDwhIBySCDx3M7KpcLl2S6AA8WP6ijrT+EuA533oZ1zLmEOzwl1C3ReBUenPGVSBtfr9rFfORvbhs4Y8OqHHJ+qF0NtHePKL515n+p9LZxN4bgb0W6M4EbyiOZXIKCvRKMGu0hLfIAU4sLL23gYSmWuN2AgztP+HH4yJc7FD1NC70U+BHmLjUhTOdEbYZOeOqCWIYkenNonU4B6hiG2hgzzOqc25WRhHbi4uT3kdvoRVuLSe4jz1Mh4B7Ho+gntV0A9Q5x7QRI90OziLZ/byGaXfajTTX4nj89bFQWm6u6hUF5FPYhHA/RTQ5LgY4mzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 07:25:32 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Mon, Mar 02, 2026 at 12:50:32PM -0800, Andrew Morton wrote:
> > On Mon, 2 Mar 2026 17:19:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > > On Mon, Mar 02, 2026 at 06:10:06PM +0100, David Hildenbrand (Arm) wrote:
> > > > There are already patches in flight:
> > > >
> > > > https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name
> > >
> > > Yup, if people would actually cc the right people I'd not have wasted my
> > > afternoon.
> > >
> > > Replying there.
> > >
> >
> > I'm not sure where this is headed but I'll queue this patch for now, to
> > get it some testing, to lessen duplicated bug reports and to generally track things.
> 
> Hi Andrew -

Who is a confused person!

> We should drop my patch and take Chris's.

"my patch" being "mm/huge_memory: fix memory corruption on huge zero
page move", I assume.

> However, life isn't so simple :) as there's been some confusion with his series
> since his email client seemed to mess up somehow and a couple patches need to be
> squashed on one another.
> 
> So to make life easier, I enclose a squashed patch (combining the commit
> message from both), with my R-b, T-b tags attached, please replace my patch
> with this one.

OK.  I added your signed-off-by also.

> Also, could you make this into a 2 patch series with
> https://lore.kernel.org/linux-mm/aaBWG4fajXXbjpVN@chrisdown.name/ _after_ this
> one?

Well, "mm/huge_memory: Fix use of NULL folio in move_pages_huge_pmd()"
is a cc:stable mm-hotfix and I don't think "selftests/mm: Add UFFDIO_MOVE
huge zeropage PMD regression test" is to be treated that way?

If correct, I'd keep "selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
regression test" as a standalone singleton in mmm-unstable.

> mm-unstable (I'm not sure why we're rushing changes there so quick...) had
> _only_ this regression test patch in it, so we were left with a kernel that
> splatted on running mm selftests, which is not what we want.

But the regression fix "mm/huge_memory: fix memory corruption on huge
zero page move" was in mm-hotfixes, cc:stable?

> (It seems to me this is what mm-new is for, and it seems we have some holes in
> our testing still since this got thorugh).
> 
> Please drop the patch you have for this already in mm-unstable and make sure we
> only have it _after_ the fix is applied :)

I think you mean to drop "mm/huge_memory: fix memory corruption on huge
zero page move" from mm-hotfixes.


So we now have

"mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()" in
mm-hotfixes, cc:stable

"selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test" in
mm-unstable, not cc:stable.

btw, "selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test"
still has a bunch of unaddressed review comments from David.



