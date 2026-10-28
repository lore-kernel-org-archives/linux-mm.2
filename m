Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0726860A260F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WKNMsN+/
Received: by kanga.kvack.org (Postfix)
	id 133AD6B05B0; Wed, 28 Oct 2026 09:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E47B6B05B1; Wed, 28 Oct 2026 09:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14616B05C1; Wed, 28 Oct 2026 09:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCA416B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:34:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 042C7C0C87
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:34:07 +0000 (UTC)
X-FDA: 85372128576.17.D0B6203
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF4C41C000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:34:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WKNMsN+/";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i89gbLbnk0eWNWQfGRGjKqDrE0gEnhRAgw++rXrpR4=;
	b=ULwktE0DcJ6Y2FtWr31Fu95zMQQ0ox1Bb0G8H1HpnigywAs51FvhooXQ77c/ezlhI99vJq
	GG2lswhcK0lThM567QjPIjXJJSG78cRjUtdW5TuVm75jLerHA68YOpLYDZG6DeseCH80Dz
	63q8LaB2SmJAKTnx7pE9wl2kGHxWv+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194446;
	b=O91XbNPFl22V7jGS29z9Ix3WAbTTwykBWXK26MJkGwANiE9IqWS39Bj237mDD+M4sCxfvz
	t+4ekOzsLUgjwxWm1ajsnMxXEpdnjywKlpkVygX+3eK0uKOyMwoyK9kgbTvxoDsv7XzT5g
	GINOC1Ze4MFmbNRjx1jSuNeIO8tlnJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WKNMsN+/";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZGabnbBPQOG1vD10Hk045MNH8SrJwcOoFj1T632b9xc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793194440; v=1; x=1793799240;
 b=WKNMsN+/7QQJ0nkJCxFdL6jIECD96U8E8w7ib/hk7NVugdFM4/sf31Fm7dzVpmjnTbBX/Q1m
 bklXMChdXq/GnVjzr+hEUwKRvazZvgtXPlRL7Xf1LQqCzwdzgtNJ0223jk7AD64gIWdIl/t6gTl
 mA4kYVS5itSBPG1qtU8eHgXs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 87b8adf5ccd19833;
	Wed, 28 Oct 2026 13:34:00 +0000
X-Mizu-Trace-ID: 87b8adf5ccd19833
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028132623.2560146-1-kirill@shutemov.name>
Date: Wed, 28 Oct 2026 21:33:33 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Frank van der Linden <fvdl@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C23A63A-43C8-4434-BEB8-8E5ED3471C25@linux.dev>
References: <20261028132623.2560146-1-kirill@shutemov.name>
To: Kiryl Shutsemau <kirill@shutemov.name>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF4C41C000C
X-Stat-Signature: ucunz184js71fu1d7jwdjehym545j83x
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793194443-663774
X-HE-Meta: U2FsdGVkX19XOtK8kqnFKx/POyhHiBmbaAysthVlTyhTKpK+Lt62ouB1B0Ha4BH3wEv8OwkUJVG4GBCOzlle0RXROclksPJt9tMyS0Zd3umugcQFSREHtQAfDKvTEVBeLk8bMO0+hPG0WaMKvb3wNk41w6OT17WhJpt7OYI0U7QxqcVN+Nz4BOHiqk+YWAYePdJ5OhOm/M7XuokhbSWgDBwghSzFVS7Y9BEyARjLTlLuHiLfP2tsdRGaXUmvEDheKj0IR7Zz2UW47550Jiv0HOCIS36RJAMScjjSohYtynwVVFWozbmTQ2lQS/RWEXB161P3UNoisPqsyw5IxvW5Rg01N5UxFmw0UfB4F6JKmJM/lhvk3PaZ9Gp1KJn373XTp1xN8SPEKpln/14pHf6Id+HRbSFAL0fxO8K1/3vT/LnHToB7kpAJ8wDKjIaDyC227h06ssRHp9sMY1Lp7AJ8ro9QiDL5NvRXgK5lfQcct50NW0FoSGx7w/kpIcyPJN9CNvEwL7X0vs/263UBBP/EDFENso89U2qpYpCWdquz4dasY26vohHhDDtLiTsB+xHk6SCgj7bGk17uUw8F/DHOW+wI46jHr/Atm2EJdv9hA+14atikx6Ob7OldTP+cHlfvb4Apk/1rcJ5DduCF0vDLDSmzuYCa8SGsB1W+ZmHoTZhylax2aB+Cqh1o7hgdHdfPB/AyBlQvdEVV7IuUr2NJSgKgWc6YLJR5EudB3xYcICmNp6yIGlKoF/ezHEYN1LcIwOMYyg/mDu6wM4Hds1QjiBoZuSsBPw6fweOVmy0KkHAg/6Q7l5FPBxvUDEg9gtT7wRYSJL20hY0ReTvGj2ZTMtmkTaB4s64oSTKPR9gxnrqYoS2Jlqbh8TaMRD3RPt56liLvTwsOZzcxTg2bdRCfgP2kX3Oq/30EaCNNj4GHhFDuDtlvdmvW1MK09MkJ/pywksosHH5lF1CJ5Cfa/5u
 DsC+wn2d
 O6YBCUHQjTSf26yPS/zFAewZdUb9z2V5DTLPZFXZ3qEagI8dsurdJRyiEdZaKm2xPRtcCbORi/xCRam5hYtQ366MmOk54vH25QNIBnlYckmdAoOUWF1Ob/jI0PHGqQtxKUVLajbd/VpM+iBL91DTbNwHHgygZvKrsgPcO9ciKRgW4j5hgBgg5UE3fs3dA33i/t2IwBwuqdp5LWzDpYvICxB1v3uU3gnSXsDdsNgg8uIPe8LXohA/ihPnx7WhMAKsaC+4FRmeJisXD8j/kHAVC6BqJPeYApVneqPRb2GdrO/7RFsR63/me8Dt3EGrNNtt19zAr7tZMRBrBYVBm92/Erd4A++D4YLLsX09A7kuDCQSjBlvi+TdOMr3NrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 28, 2026, at 21:26, Kiryl Shutsemau <kirill@shutemov.name> =
wrote:
>=20
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>=20
> page_ref_add_unless_zero() reads the refcount and then updates it with
> a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
> scanner, can read a non-zero refcount from a page that is then freed
> and reused as a hugetlb tail page.  If HVO remaps its struct page to
> the shared tail page in between, the cmpxchg writes to read-only
> vmemmap:
>=20
>    CPU0 (lockless get)               CPU1
>    c =3D atomic_read(&page->_refcount)
>                                      page freed
>                                      page allocated as a hugetlb tail
>                                      HVO remaps the struct page RO
>    try_cmpxchg(&page->_refcount, &c, c + 1)
>      -> write fault on read-only vmemmap
>=20
> The refcount is zero by then and the compare fails, but a
> compare-and-swap instruction needs write access whether or not it
> succeeds.  The kernel oopses when hugetlb pages are allocated at
> runtime with HVO enabled while a lockless get races with it.
>=20
> Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative =
PFN
> walkers") closed the window with RCU on both sides.  The RCU was =
removed
> together with fake heads, on the wrong belief that it was only needed
> for them.
>=20
> Map the shared tail page writable instead of restoring the RCU.  Every
> struct page on it is a tail with a zero refcount, so a late cmpxchg
> fails and leaves the page unchanged.  RCU would put rcu_read_lock()
> back around every get and synchronize_rcu() back into hugetlb
> allocation and freeing.
>=20
> The cost is the protection against stray writes to tail struct pages.
> The shared page is shared by all hugetlb folios of the same order in
> the zone, so such a write now corrupts all of them instead of oopsing.
>=20
> Bootmem folios optimized when the memmap is set up keep their tails
> read-only.  Nothing does a lockless get on them before hugetlb takes
> them over.
>=20
> Fixes: 32c440d67e6c ("mm: drop fake head checks")
> Fixes: 01b1d0ffb6f7 ("hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU")
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Closes: =
https://lore.kernel.org/r/ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


