Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F366FCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25CC6B0088; Fri, 16 Oct 2026 03:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA75A6B008A; Fri, 16 Oct 2026 03:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70736B008C; Fri, 16 Oct 2026 03:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE706B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:16:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95DC74033D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:16:09 +0000 (UTC)
X-FDA: 85327630458.02.AD7F9EA
Received: from mta0.migadu.com (out-217.mta0.migadu.com [91.218.175.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6CD3FA0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:16:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gh+C1jE5;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792134967;
	b=nUZHgu9vgiGevp0jqb2oYHeinrynNF77iKjHV6TaiM3HlD9JqDLKwWNTnwgG3TovZby1Ow
	mHNTYR4AYxmhdwDZADRsmRecrMK1Z1os0Dr5k9fQX7qu2ustvv2BkTzERmY9+0KNp7l09a
	QVx70IFu6rbLCA7lLIKPxYKxgGfSHlQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gh+C1jE5;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792134967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMpimNJHBwVzdkbh0sG7nuKXhKgLFZjybYL4MeVlE4Q=;
	b=BZqBE9iyA5GVzR290F/WEM+c3WzYrztDIo6ySOQ85439hmCLwasPMGqOW5+HgRCiOOaBzL
	bLY/sjHa0+n1fhd+tSo7tt/eJ4pgT/CeLzRaR8jVC3roWG50w2HkNs06s3lL5zjmigQr1e
	p5D2ldZ1eAJnRkxQoX1A/CFNxUH+9+Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xgR1cjGY6ygGqvZie7u+u7EotdvcRJPIfh8Sp0piRWA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792134966; v=1; x=1792739766;
 b=Gh+C1jE5wn1ZarWB5JQV5xiMzm8445W0lzudkTz3wslMuSkdchSOteQiYbBTMPuEinwJNEyQ
 TNtaNC8dz+GxI8cPoLvenIPip8P+IGUnqnLHjAEKTJUdGF6wjW0ti4NKVkuWm2MzWcIxtRlsrps
 7rlNqFFBGDJxeBFwbcLfnT5c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1ef1cef91026e4e4;
	Fri, 16 Oct 2026 07:16:05 +0000
X-Mizu-Trace-ID: 1ef1cef91026e4e4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 00/10] mm: various (urgent?) fixes
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 15:15:44 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A061083A-3A02-4ADB-9CFB-7CF6C731A872@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6CD3FA0006
X-Stat-Signature: tmkw3i4q43fae4ret848joa8amatsp1g
X-HE-Tag: 1792134967-322837
X-HE-Meta: U2FsdGVkX1+p6uJbPR55cjQ3NPK0YrKNTEJw8nneplD2zpw5oOHcz+Fxe/gR0BDTIFwRMW+rVBIhYvZwtk2sNVu76M+RKnTmHhKdLD5zi47XIrSP8Ydl4wbAw0iA7kAR+7hPcMSktA0p9fyTFL/bULyzi8HOPbhkefM205O3pQlJNmNAPl+BeuQzPs1CSAbTE+WC2KV70YoBDyQqgrPLV/HVwf9Mm2xgjJxlrjIL6RACw2+awCqhq0FowH8jU8EV1KWFSOuMJoBQgrSWySML67pAuWBOfw6Id0ASQA83SmAz+QDfpgbz7jqExrZ+fGD+uIBU2iYppnXoRML/0LnCbOiwI9C79tUqHxv/Q2fmwpLru4513n7jQshrh5hkNgz1vc9oGAx+o+mdADzbMx8lvMjzGB26ZXCjoAtgnanTDJU82e/aAPxJfcbJEVFeyPhZGjyZ+o4ZlyZSCYABUfCo+Mz1FN/cZsFKZk9C2/Z/KWJzetLStjKiUdAIGdh5hY7o4vz/s7zbl3zT55LwL22jlTm/PVPOtJpQe9OzZc7gGkeauHDBJd0nL8njgzGe0rDIovRxv+72tKpuDU9X5a4JMSsI1gNY86jeJ7/YoGLl4VSkDtx2T7KGW/W2+3yjGuqXhyIGZ+3H3hbRO+ctH7adKA1krGpSJ32xsYdtQ5a+X8vIM2746t1dNHpYVWUo/7c+hMhOtf4aRa+ApBo6z4qDQnQAlXdkrQwOPsujFouis96AiLAMvOBru2YbZHqA+35ODOMSJhfPQ8EGq4nywJ8P6ZWqpp8VLi26/5v+B9+gTWV6znJgrfCsNSfXkHhGn8LvmWJYs1DzFjJy39rvIoOV0tX5ut3ucAv/b+5IkHPw2wPBYpH3FhGBMHVjJAz/xwlgI4clZaJ9x0rs0JN7dklNvGqMmLvEubOYG2Guz6e6Nr94ka+WVw9jIHcLtIrhfWdF5qHIIsVpx1jSudXftoW
 /nhl545u
 PR44F9JrdmLiC3XaJ4IrGpFRo5YS8uv9lriJyYbicCUWFQrcT2mR5yJjHbj7IckNSE00KbgTTAkp1MeV+kW92pijAFt+67kpxvHFgHYrdoytzPbPemRp0ANrUobTeaNQfJrBTSe0fg+6G4EluzYhhSC2uJ/lNkDC0n23VHzSVWAqLAAwrT9UX4D9CX+6NfK6WvBrh5DfQCwkz4oL6Jy3ZTCDY85pnnHfdL9VMprXpnjx+Wp/mAV+TbgtJiB7jFmLjFH5pkREvY30DLIh231YB9B4rD4qfG1zvmkdZjt8Kl5spq/D468+700CCWhWzxHq9FX55z+Wz4H7TY1RwcU5paEZ2kjwOBoWa4oXyUSdy263Yjam8qyXsikHEGWvAwkxPNfY17TlgYvVx0mEq4Kg1kaxWZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> Hi,
>=20
> here are various MM fixes. The majority was reported by Josef at
> Anthrophic, the remainder was found while reviewing/overhauling them.
>=20
> Two issues/fixes reported are not included, as we are discussing
> (better) alternatives on the list already.
>=20
> I left most of the original commit messages as schloppy as they are: I
> don't particularly care as long as the code is in good shape and as =
long as
> they are not actively wrong. But I (and Mike) could not be stopped =
from
> overhauling at least some of them.
>=20
> While I don't think there is anything too critical in here, I think =
this
> is a good opportunity to see how fast we can get =
pre-screened/pre-reviewed
> fixes upstream that might be security-related.
>=20
> The majority are hugetlb + uffd issues, that are not actually that
> relevant for most installations. But all things that should just get
> fixed. Some uffd fixes need proper follow ups to fix some more of the
> root causes of leftover UFFD PTE bits (or proof that there are none
> remaining).
>=20
> I ran some MM selftests and nothing popped up.
>=20
> So let's try to get these upstream in a timely fashion.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (4):
>      mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
>      mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE =
PTEs
>      mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
>      mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong =
VMA
>=20
> Josef Bacik (6):
>      mm/vma: don't leak the commit charge on mmap failure
>      mm/hugetlb: fix use-after-free of a new anon folio
>      mm/hugetlb: unmap the page where the other VMA maps it
>      mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
>      mm/hugetlb: fix endless write fault on a leftover uffd bit
>      mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP =
entry

HugeTLB is really nasty, while no new features are landing, we have a =
steady
stream of bug fixes coming in.

Thanks,
Muchun

>=20
> mm/hugetlb.c | 70 =
++++++++++++++++++++++++++++++++++++++++++++++--------------
> mm/mremap.c  |  2 +-
> mm/vma.c     | 11 ++++++----
> 3 files changed, 62 insertions(+), 21 deletions(-)
>=20
> ---
>=20
> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
>=20
> change-id: 20261015-urgent_fixes-7112629346eb
>=20
> --
>=20
> Cheers,
>=20
> David
>=20


