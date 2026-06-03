Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3EECD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008026B0088; Tue,  2 Jun 2026 22:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21C86B008A; Tue,  2 Jun 2026 22:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EC16B008C; Tue,  2 Jun 2026 22:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6FE26B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:42:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FD9C1A01E8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:42:38 +0000 (UTC)
X-FDA: 84837053196.08.A6A8CBB
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5E23140009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:42:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TOdvl/0I";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780454557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFt3H9eVB4pknImQVyVI+Z5RNzHUL5L6kJW7ohYLnNU=;
	b=gwO83bVZ6k2t7dC4EBGg6X5UMgQX1f2XDw4ADM4frnHto2ioY3T0Kx0GNHTDwfbTbV6ciM
	sMKnCm88r38T0rv8Q2SyB4vxwa5fERmplHE5hvyaoyy3Wg98u3hkazgq/OUBAlb/b+sUcn
	kcxMXv0YGpGu5z+ZaltQ+zlM0K/Tfko=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TOdvl/0I";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780454557;
	b=YWWUqvUUGlNiXlNzu3u8LtNETvy5e6lw3LcozVdJxG1hKwkrS/MJEfQUFKPzK7NzEKl0ug
	c+2One8/BFdgz3hJD3woE77XShX/vaw3Mf5PzJL32zwXe/gHIPOxG01M29fRxbY22Zpnrq
	BrBYH3YU/+UddyaqyNCWaLHUKsdxnP8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780454555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFt3H9eVB4pknImQVyVI+Z5RNzHUL5L6kJW7ohYLnNU=;
	b=TOdvl/0IAihcEOBFeMilBYZiC2N2x4xQF/YenP5BCzSIZivaTf+rJmxh3QgmTsygF3QYy5
	6SIhrlIS5fkw4I7fdll+nDCefDuUeBS/cx4xVVbgeCYPAy9MkYxzVNh/R9Xdzok2RWfoJz
	qtTmVPZGmnAA2ahV5lFuLlLpdRcSoOc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 18/19] mm/hugetlb: Remove unused bootmem cma field
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178041489401.457517.7510742037477989122.b4-review@b4>
Date: Wed, 3 Jun 2026 10:41:44 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <101DD3F6-934E-4BFA-9FE7-361BBBD2080F@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-19-songmuchun@bytedance.com>
 <178041489401.457517.7510742037477989122.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jaaadbcm78dgpqmi5u91gmnxh6ih566e
X-Rspamd-Queue-Id: C5E23140009
X-HE-Tag: 1780454556-298399
X-HE-Meta: U2FsdGVkX19CNH4unJB5qOQ6f4k+08bi7VU+scmoyhX1v5/bwCrQkvti/N9ZluVab13uWAwu0Wb8J4IC+8Q3hF/jzyfyghncsqD3TgHA1eTQihTV0RthYuFbI7yPdlrbNDpLQwBtRZsXZZ3WqqLdWHCSTJNMpJSnd53wPCoc5kQhv7ZwAbrP7N0t/IsgOirUaJgebNRbeXVWD2VZuA9d0COHoVFh+2AarC0T3CVwyOXcU/O7MtVgJ/qm6F53blUSAFoUTAgoHyrriYbv+ZeXGjykAwg5WdYYjvpQdFFWyUPDoUToCGRoDaeAlFPX+wo4o97m7fi7VvcJewnzMu3uK8jHQvAhJVzcEDE9OSxOromhEc+sxwcrFZS+qnZwdRIgZ/sGeaIuZlGqEHgL1KkzHaW16yJblwEg0It28HaNS96LdO83Glajn9cWLLkXc2Pb4paWb81211SN6d2MUQiRlRVofTH6bGs8TqJnk5YM7iumjipVmuUFwp2g+hpK4lSTl1ftIJ60W1ZprXzzylymUBjdD080h4FLhRjhk4gLNlRrzwafX6paDWVwSnwABZEN1KQCkeqgqySTv95FKQOqqMg/xSYY/Sdk8g03jK87Y008Es5kMJqnw29i2W5akQHCFhtpDhOs3vN8jQ2PoSJSKrOloSQ+bafsOTXZDQ7/ArDFHZQOl84JOMhiKVYiQ/sCnDChIzHpz9Y7ndocF/sBFsjUS9XraSrFCPV+xonhFhuCxNT5IMfITYRrVf+suCiEmVWA1PIlxMRuUyaeSWlb23QmbduIxDOFkmc7py3OU67W7z3oa3YUj/AFpPDneZrmMhzHeK+dNjmNUf1iA//OTIIa0hi9DZvygCxIGPI9pqqL3lZtrsFmMttN05R7pJzB/mLk0P7hTzz7hvmr5lrwWvj3O6F/kJJx7W7aere37fDJPCMYfzW/1S9LV73zX5isQQS9m51YMi2risRC353
 MgZmHxMz
 20LRa7eKU7sSSPY+AkjK4X5GcvIMzk+OouMmMwIqEShZiEgvj85DAdDPvSa20gVawz5nIQrbJyckCWFG65vsJi4wm8owSgC7dUFqujjSyQtOr6VMqC5DppwSfMj8NFcIw8qffn9nuBLTCLbuqppRvCdpPtOwBtMDtJZHhlw+zoqMP+vFnGiWgxBErJVFLjkzl1JU/nA9h1Ez3ZSfQhQgvt4hzYV1WDznwfYi/Ty5QA/QydSv9q7CEqUOxUrlbhZSjJg+IvqbhmTOm6Le99lC2kNbM5Ag/Fj19nOBE2MyHhhgCzS9glGA+ZAq8zsKzBYL7bb7PUFsMVQthXB0qHL7KUbIWH+yyYpvX/drGHwJSqo5JVBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 23:41, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Tue, 02 Jun 2026 18:10:38 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>> struct huge_bootmem_page no longer needs to keep the CMA pointer. The
>> bootmem path only needs to remember whether a huge page came from =
CMA,
>> which is already encoded in the flags field.
>>=20
>> Set HUGE_BOOTMEM_CMA when the page is allocated and drop the unused =
cma
>> field together with the redundant assignments.
>=20
> It looks like the commit does more refactoring, please mention it in =
the
> changelog.

Will do.

Thanks.=

