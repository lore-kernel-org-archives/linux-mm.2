Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D506EF5A8DE
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F308B6B008A; Tue, 21 Apr 2026 00:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0DB6B008C; Tue, 21 Apr 2026 00:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6476B0092; Tue, 21 Apr 2026 00:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDED66B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:02:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6ECE28CEB0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:02:30 +0000 (UTC)
X-FDA: 84681216060.22.23A960C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2096BA000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:02:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0xaSkgf;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776744148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMdJRNtKo7iaVl+CsUGo+lqElncIkwLhNwFqakkkUeM=;
	b=hVnlX05IgB9z2yNXWbyBhHX7AcjBFsAPXT5wOyXVMHid3z0ceYW02yCWXdM9yKqLk8k0mH
	R3WJslLdQdHxeTg8vne0XYKnCfnHNkmya8U2u0OI0wa4D8BUm5rphhCEwFY+a6USTrz1Vu
	gFYvfPIM4k+/ZFXmauOqyynR8JsjYwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776744148; a=rsa-sha256;
	cv=none;
	b=npeEjDQjptCc0MDg5M6/nXa19xQQy5aVzHEjUX2i22bQOGtjz2pGXckQB5vVGE4B5FEgz7
	Y0xhVCDSE8Xqma1t/tFVk4IcVlbV4IG+AOhX0eGB12gc0YP9wuOuLHX1K5RAJ+cx+ukfFP
	BlFdO2lBQAwygigGTadP18XpCh9zwZw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0xaSkgf;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776744143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMdJRNtKo7iaVl+CsUGo+lqElncIkwLhNwFqakkkUeM=;
	b=P0xaSkgffkY/VRF9fMqKDRh7+V+gLrQC2wIjEZ6WMNXTbB4slbAyJZcsfbYpBc8bue41Gs
	uC++PiG4GNvn5/ExS0vNS0mVz2zXeeQ1kIUJ7wtddJaMO0GIWpx0gQHOLUqaQ7IjZOyY0b
	cV6Lg9OsFyqR52slTe7DWhNESR/Rq/0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v3 2/4] mm/sparse-vmemmap: Pass @pgmap argument to memory
 deactivation paths
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aeb1N2T1rX6GHrXn@localhost.localdomain>
Date: Tue, 21 Apr 2026 12:01:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9C51B52-F9AD-4D35-9B00-7C21950ABB29@linux.dev>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-3-songmuchun@bytedance.com>
 <aeb1N2T1rX6GHrXn@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2096BA000A
X-Rspamd-Server: rspam07
X-Stat-Signature: c81zqz9r88jgbq1z5j1wztwik3so959u
X-Rspam-User: 
X-HE-Tag: 1776744146-944022
X-HE-Meta: U2FsdGVkX1/fVhniKahlIxyy8SNf1NlFcHAWG9GlJ6sbh65E6RF1FrcfeVLYxtafxlAGiun1P27esG7MaWZUytN45KqVqK9zOBXykKbAm/c0tPSuT9VSfQ/6YEwc7mw7m/bInNpC1hgL0rx2f/PQDr3M/oUkeghlz9PPBMj7p095MSySFdnb/MW1EwFekBm/mzIotlVm115kjaJJXIsxD5LcYE0SyO/CiWNVCacUIYqe960f0L25xV/qGPtGMVgP3BMdRGbs6v7aWVyDzAbJxHeBkTF1HMjlGz66mBUsQrvOq0CI88GS+a9D0SSfSl6ZKg0n4Vof5/IzoaE9bAPXGmONs3RxtOlRYILFcSWSgIZS29bsCuYZcEmiSpPRifp8c4F0u/G6vropt17bKj2rk2huTBbhvKlEHR8PMyMLVB75x2jRob6QFiCmGADfvhvXl9sPiyueWfjYvERwemmNctmcGbiVtG2snhi+k2QmTGzj3i7inGKD/YajIDNsiXlq4jYCySxrKwzOU/pUvBeEL1QmYvDkywX2VEktecIb1P4EzJZJeN3jz3/6Hmq/00fGqSvKXoCZjNmvxUJYyRpF0tlefsSMW4waor4AMOCSMWFaNHOcigOehCtILpGAJuHEQSqzCtJou70nLnJv37bRBS79s8Jl95wJTtAaEI2ZXLY4gR3PBuMY10k6VwwgnA5peFK1X6k7bOG+vxY5MpzsYpzu0o733pEnvhKaYngK5CgxuUA9XhsPGzf2hS54j58c5vnsBPYmDgQiOLWqEI8eW5rn/nRNgpqBOtUUGEekwVNGOC8XOIwj1gqunbbcSw92d9T11mjoctc1dn/t/OfoNLhqmY6e3FVm/F3wWqxfm6/hYmv3A05HQ4l8D74YPjAl9ejPQ6zS2HHO8c1gOWEZRU24lvJKKOPlngZi0SnBErcX+CnZJPvWOA8NrJuGPDURL5rPzAka2VsNjJfFYVY
 kagoud+j
 CLlSeg2zgPfm5eIWlDvIMikqnNqYrlpkUL4yobbNw089DNZnwIeFEJEig3w/DTRHlz6xKphSQNlJeDLrTO5gF7UrS8TeZv/ij6IGDGRYOt9g9Ihcr4NXgH0CbOMz2qOnvtuo+faDAMrCmuHDzDhNJQv496vt1UOuPWlQuT8/T9PXR+XpOZCYwGJYFZLyUjFcwa1X7LC89JjSdYSKDFdWHS9KGLPtOSJEyX5fJ3FYYaItXTIA/ZidYfWfqPt5jJKAqqdIgJ1EJjUGZYgsEucwQbs94EBl2lF227boM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 21, 2026, at 11:55, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Tue, Apr 21, 2026 at 10:20:42AM +0800, Muchun Song wrote:
>> Currently, the memory hot-remove call chain -- arch_remove_memory(),
>> __remove_pages(), sparse_remove_section() and section_deactivate() --
>> does not carry the struct dev_pagemap pointer. This prevents the =
lower
>> levels from knowing whether the section was originally populated with
>> vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).
>>=20
>> Without this information, we cannot call vmemmap_can_optimize() to
>> determine if the vmemmap pages were optimized. As a result, the =
vmemmap
>> page accounting during teardown will mistakenly assume a =
non-optimized
>> allocation, leading to incorrect memmap statistics.
>>=20
>> To lay the groundwork for fixing the vmemmap page accounting, we need
>> to pass the @pgmap pointer down to the deactivation location. Plumb =
the
>> @pgmap argument through the APIs of arch_remove_memory(), =
__remove_pages()
>> and sparse_remove_section(), mirroring the corresponding *_activate()
>> paths.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>=20
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks.

>=20
> The change looks good to me, but I was wondering whether we should =
pass a
> mhp struct instead to low-level functions like arch_remove_memory and
> __remove_pages and have __remove_pages then pass the right stuff down
> the road.
> That way it would mimic more what we do in hot-add path.

Passing the pgmap parameter is a temporary fix, as I have another
patchset coming up to remove pgmap entirely [1].

[1] =
https://lore.kernel.org/linux-mm/20260405125240.2558577-46-songmuchun@byte=
dance.com/

Thanks,
Muchun.

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



