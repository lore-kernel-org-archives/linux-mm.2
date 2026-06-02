Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D943ACD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DDB6B03C4; Tue,  2 Jun 2026 08:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE8C6B03C6; Tue,  2 Jun 2026 08:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9DB6B03C7; Tue,  2 Jun 2026 08:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFF46B03C4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:02:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 349291408EE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:02:19 +0000 (UTC)
X-FDA: 84834834798.27.F38DC58
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB11D2001B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:02:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z5LxNo/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780401737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+72QC/29sQzn8Uu3Y8YY2M0V2ygqHpEiwFZA5N0acRE=;
	b=qDoBTd9D0hc9VKUjk3nBE8AhL8OSnlmAMykJX0HJvCn3GIFCTFiYJaQcyinXi45oP5snam
	RZeBUHIPzrGPPM7LL+9A8qcRpBWMCQzpXyzRJnhnfGeBSWesZrqUHytUIX85XphCL7icOm
	6LuHvHQGYHQUY72iJP9JDIUA+MBBbZg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z5LxNo/F";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780401737;
	b=DPiYlxCDK1mglnXVgzJikwtgPvBZzrA9iFLfl/3I5dK4wMUdgLgiTOykhcL9rb1I0/vVO/
	KkZUgQPYRESXdo+Z/V0c5ymgOKGmfeRFBZFWZoy92+ZcswhhwPz4NbGs05nfsLy+1UPAFL
	hu3vlOgSJsSe+qUctrkRfpAHRiW4JPU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780401731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+72QC/29sQzn8Uu3Y8YY2M0V2ygqHpEiwFZA5N0acRE=;
	b=Z5LxNo/FMI/JNJb/TqGZvbAG+U2opcWuC2sWGUblnS6pU3elGn3CL95KUFbPiFS5cVhvjV
	CX+ErMO6Eug6SV/lU5nicCMOFsKiI46gdjqRHyzsh8e6yt3EiHAy5KF9W76dCuWzqmFpHE
	P3OutiC++LR7VRSLhM3SYQ2kkyLPcJQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 00/19] mm: Refactor bootmem gigantic hugepage
 allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ah6xzZBh8IysNXpI@localhost.localdomain>
Date: Tue, 2 Jun 2026 20:01:17 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org,
 Mike Kravetz <mike.kravetz@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F527488F-E147-490D-81C5-01FCB8523820@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <ah6xzZBh8IysNXpI@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB11D2001B
X-Stat-Signature: s6tzf1r7whquccx6giagx6gio9mns1un
X-Rspam-User: 
X-HE-Tag: 1780401735-105242
X-HE-Meta: U2FsdGVkX18mpflFf2xTXn2dYV0azLP9i4EPZtWYNDthojlsZ4lxG+rUqw5Jvec4cqZ8oCTRBptnfN9rt2uG6nOvaioULsl4Svx5uTte1neAqI2VB6guW5JGcMPZgOjzKeoidEdEw7Sa7Ob/8N2fuEBodo1l+kZJPFjQPCZ2woKGwccS+7E2quC5k5kNua01e7b7AGyIgYtPsfyK3lnfY2SDU/PI7Kc63aUR+sNaBaaYQ59EVHv9K/gdVZOmqVuJakTQacYcUtQfyzjCgLn0wYHcFtoqMBO9XP8bCOlWEYV2UiRPy6Xx6m3te/dLPNTaiO+zII3AgvRi6AllyOxhg0Oq39nspeOWgbs9r8Yf7JQtKBV7f5jhIrjnzNmEM/G16/hUD8YI424coLqXwTjXtrn8opskoZEMGqeocxy7oDqP7MRToShihnEgjQh1a+Us6pksyhsFS3BB3pL3fAO4VNB84oW7vJ0MQEyBGLpQH+ahGLYrHOdkmFwKnTvH1FerkYc5dqy5K01ETvW29Hk1ArczjdDTjQYv/U/PGSY/1V9VEEXQbtowx5hdwYTuAIMvKoDNhJHSsoJd/fbRnraf2CRFlDP5yDRgpDkmixolgZSqX/aY8ksTgzrS4XyHR3McKg37skyqUprj4rzlZrCtfDJznxjITdPpVDLFDFP38hd2E3gY+gHNeKwddUvtUCDuGRGiu6e4AVeYYIwvBBHKZqUwRZm+vqXq/QSikBsBDY0Pzt5k1fniRtXkpTSNVjaoDhJdWo5WplDjr/fGzfPj1ypRnizYfwJHc0LeAPjwkK1mBhH9zguijKXdPebQZk7ZLmK81AMrLi5MXIVt+cyt7yvc9Y1UQkeTVFF/757lk7z7N9i5lCkrCsJ6CLZ19i6FECCQ1UVChko9oVfCbvvwRbwHj6AgLkdBVHhBODBqMFeL8BgYjAJsXAYvhxhHLvwa5ABu4o1vb5U6VINEvT4
 hnSEAqNz
 7faaHU3i8L9s9t4rJlTTrX5lwuJEnLQvUJJ6pfVvG+W4RVxtqCVKuhFLRfsnsxYI0hjvmwA0gAdxLsyaTqWfKRQtmGExe7Hi+fWVY6DGAUigKGVPouvSdgc9fLuphIpblqiTK14ciyZ92ZDUpD88/phwgsTiYh8i6U+4Qyw/9OlK694KrcQFE1UPxkH0AJy11kRJOlri968x2FBJHPSOFM3ZgOTYouQG439wFvccwR3quTy1VrAXuDdZJcZUvzJCY8F++0ThB+QTKlaGKA8RoBAyPI63tw/0LnSqtHQ3rOMM8nxDcpaQzZTV9B03HziJrl7lFaa3/r4RG5DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 18:34, Oscar Salvador (SUSE) <osalvador@kernel.org> =
wrote:
>=20
> On Tue, Jun 02, 2026 at 06:10:20PM +0800, Muchun Song wrote:
>> This series is split out from the earlier larger series "mm: =
Generalize
>> HVO for HugeTLB and device DAX" [1]. It collects the first 19 patches =
of
>> that series as a standalone set of fixes and preparatory cleanups =
around
>> bootmem HugeTLB handling, sparse initialization ordering, and related
>> vmemmap setup.

Hi Oscar,

>=20
> Thanks Munchun, this split out really helps easing the review.
> I think not so many patches from this series scaped review, but I =
shall
> get back ot it later this week.

Sounds good! Thanks for taking the time to review. Looking forward to =
your
feedback later this week.

Best,
Muchun

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


