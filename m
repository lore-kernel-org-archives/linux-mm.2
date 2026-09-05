Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852E5C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 09:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BE66B0088; Sat,  5 Sep 2026 05:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6046B008A; Sat,  5 Sep 2026 05:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE2D6B008C; Sat,  5 Sep 2026 05:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55BAF6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:08:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3528140287
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:08:36 +0000 (UTC)
X-FDA: 85179133032.08.A9E86C7
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 489361C0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:08:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/3gHvGu";
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788599315;
	b=qWzG+gABYSm8sCCfP7kmK40xNXySlS+VU+VS/fwAT7mC0HhZTrVqyd7Xa41m1++LTsxC5t
	1EPoaCu3i2lkKjuNkreTvR41t4JxnTWE1mJHkW5x2S7lDmK5PESOr7i8c4oqkBOezFr3e3
	xdRjbyFvmy+9mmLwSTIfxOo3EVR3Fdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788599315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=928ftpQdBwt+cq+MctmlsoRyqL5DINpZLnaKzBho3a0=;
	b=MUsXGAd+UaPJ7sUmYIh2GSogRI4tWhkv7GC9P4FPvwaIXE56VEbdln2uyiJ6b/kbZp8Gm8
	Tw13q9B+UETqkgwWAa+SAxeU1r3yqsryJ0JyST+rxHP5fx1I/ap/NQcx+jA8Zyh0I/vhOl
	ozLLNQ8qVMmzXaxK3ozNr9alwMw5H+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/3gHvGu";
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=928ftpQdBwt+cq+MctmlsoRyqL5DINpZLnaKzBho3a0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788599311; v=1; x=1789204111;
 b=M/3gHvGuKQyseerPBMWaIjrR9HHkxe5vMov/rwP54TOMft2DvArQHmeOJW8Ae+u0Y3Iiacvc
 iBNr1wkYBkLXlHElqXC4KyebKuUxmI/t+D/phJhRSMxQJcOrfRXA88FmD7JxUdjZ6tifxt6PdOR
 xvaUARySrGnmETV689CwX1Kc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6189846893d99aae;
	Sat, 05 Sep 2026 09:08:31 +0000
X-Mizu-Trace-ID: 6189846893d99aae
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 06/11] mm/sparse-vmemmap: switch device DAX to shared tail
 vmemmap pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <e3d0eaf8-a85f-48ff-96c2-dced4945b085@linux.dev>
Date: Sat, 5 Sep 2026 17:08:12 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <861645FA-43D5-4619-82B6-7A0C889F95B8@linux.dev>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-7-songmuchun@bytedance.com>
 <e3d0eaf8-a85f-48ff-96c2-dced4945b085@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 489361C0003
X-Stat-Signature: n317ofm5jzbxdwdiwurc3xagyp1hyobc
X-HE-Tag: 1788599313-649142
X-HE-Meta: U2FsdGVkX1/uTHNa3smUg/iFblApPqubbVH+7hsAzq/TNiMaQ0NK1fsb7l6abHHAc2Pf16CCs0fWLy3FCRaGogOiZDHgRWR0a/G6w/Z6BsdFSOG7UN4navqVjbEHsijzIIQhbiLD3P9Gw/pKOJuMMx9CzjoggR7yWTb0cAw4b71BvG8uh6o6fX4ZeSMYfYrPy7dJRVWOfuiqKuZq86zDOQJv0x2vPqPGdSD3DJm4cKKJ9AEvYSMgDFURhTAVzN8VzIgMFhbylKKUKdg3r6wgh+fuLpD21th0aCA1jp69ljvFj/IZ8h3iWTPiGqoGhtwegkvmDdAlp6J1FGOUaP+SC+IMNLD4ETw3EzCoTe1EgkFGRL03tUJaMOYPET255ijiZv4HzZhuJxtZS8o5oxF3La5i6UmnB593BHKN39yNQ/D9GdUjBYCB6MMbgQByy5HUd41yR01Ma2vX0bUW3r7SOtNu2u0D9bWVzVSqcu9zD1cKMBqrgkzAZifNCjGGocQWQ8eZoc/nBX1R3ZX4GOonCuV0PQHiO9oIU/yhjbaWxt5/tMjzZYdKNuc5tdcRBe1q/BHg3ugy1WMJvvjAk8U8xwBMAnd6XB6HLK4AY106XfWIdbl+ciZ2YArfqhMJz7e461lk6mpysmVyE9dx/jDOnMVJO3HKGrRcbh0h8FtUkVi5e4Sx2WwsClQF/ooUFOxHyaUAr8cu3XXywKC6ycn4uF44v4Z70Gw2r/ZZoy3TkcA/FZQbHtiJQEv9mViKk3PPnVDqZjZ/HbtX16blfIobpnztcIxhPZfSs98mJWKayJz9GsxpJuYTWvFTm8pz2T0hdSE4QzFW7Jfu/DflSynL07xb3+I7FdAAZ6uZVYYTvQRmDhyhhgpcIGnhszAtbGQbDrow8q1NVq+drAfhVTxUOBrsCuLMlWIhZF9pnw5zG3Ls9pMkMyRw4jP6xlh5sij0u9yy6UZmQfZUJw2knmv
 Iu8l69z6
 /SPsepZs8QoyTyaf+wnGEk4lLSHUO9WreQSqOJ9j06Hzq6TvhrlxjkNeXBzE7Vr+WjOv2+cMEoBMvvR9iajT9YVuutYT7eylA7W45hV8QRhcXL/uKfTOCpqotlErja7bFiM3YrLgHPzqmQBNOJFFmL8rLV6uEPWx3MsWtz8ZWYkXKZx6crT84QMOYoMCVT98odMZ7q11Y1BY0tEtW+b0rm/WkyScMgCtNfKeZ22vXTDZQWJhqEXoxPoQtb87MeslYc36sba7hX+NNgYW+rWqxy0oCaQOpfTiGVO3lsEO4lw2+8zTa2e9hxW4nfcyFlbJYaXCX6YyY4wDqw5+WK0SRVFhpAbyuAiaqd6cX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 5, 2026, at 16:35, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 8/31/26 3:53 PM, Muchun Song wrote:
>> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap =
pages.
>> Device DAX has not been switched to that mechanism yet.
>> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns =
DAX
>> with HugeTLB by using the common per-zone shared tail vmemmap page.
>> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
>=20
> Could you explain this in more detail?
>=20
> As sashiko pointed out [1], it looks like this assumption is
> problematic: dax_folio_reset_order() may end up modifying all shared
> tail pages?

I believe Sashiko's report is a false positive, because the issue =
Sashiko
raised is based on assumptions from code analysis for FS-DAX. =
Unfortunately,
the current implementation that supports HVO is DEV-DAX, and DEV-DAX =
does
not modify tail struct pages. Moreover, this patch itself is intended to
migrate DEV-DAX to section-based vmemmap optimization, so there is no =
issue
at all.

BTW, the current logic for determining whether DEV-DAX applies HVO is =
based
on pgmap->vmemmap_shift, and pgmap->vmemmap_shift is only assigned =
during the
initialization of DEV-DAX devices.

Muchun,
Thanks.

>=20
> [1]. =
https://sashiko.dev/#/patchset/20260831075342.57563-1-songmuchun%40bytedan=
ce.com
>=20
>> initialize its entries with PG_reserved for device zones. Also skip
>> poisoning vmemmap-optimizable sections while their struct pages may =
be
>> shared.


