Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5666E606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UK5LpKdm
Received: by kanga.kvack.org (Postfix)
	id 6C91E6B05B5; Sun, 22 Nov 2026 12:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679E56B05B6; Sun, 22 Nov 2026 12:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7146B05B7; Sun, 22 Nov 2026 12:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A64A6B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:14:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC0BD40722
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:14:23 +0000 (UTC)
X-FDA: 85463403606.19.DC20F6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA9C81C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:14:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UK5LpKdm;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367662;
	b=7Sa7hhcQXs09GpHxRRa3v/bXxAXIxjoITzNxiuzEhr5WP2WdajQtS5mZ9mrjDNQARDMQKU
	Xc/JKyq0eZcNUA451xTGw6pB8MhkPUhbfqPWIeK5/CErgwtdmu7xwgUa5XETdh4COIbK7X
	qzTClAKEkpsv3E3xyoe5Rh170TItJgM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JGbsedU74vIQ/0gQEWTkA66OhpSi5QLuKHx51jgv6o=;
	b=PUt8MK567HYimFE71ODaceq/z8wPbBU9ywLtQoWDJZGk8AU2MJgEVm9dJg8NZnCMoVDmSR
	9w1gbAJBs/+DorjaKui3r0nLZdBJKKCRquD+iXC7LDP4ZMRh+xzePsd9th6w3RkQkrcn/5
	4e5PAKwXy3zT4vf30S47X3gzil0XP28=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UK5LpKdm;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E635141913;
	Sun, 22 Nov 2026 17:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB51F000C4;
	Sun, 22 Nov 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795367660;
	bh=5JGbsedU74vIQ/0gQEWTkA66OhpSi5QLuKHx51jgv6o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UK5LpKdmOWL0+QIg66xeuCB/MCO3KleNEYpYNhkPYguIjSJsVEOTfFAFSYArDoe57
	 S9UVOHkKTNDRYrqblFi9Cs7MEWehlW8R2JFhx1Heql/svJVetyCbF8b2SY2y3FQoHX
	 trt7AR+PG2xFis8l1vlFBhzeunpgbz/Wn7bqWyXA=
Date: Sun, 22 Nov 2026 09:14:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Aveline Noir <jm5905938@gmail.com>, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>,
 mm-commits@vger.kernel.org, Patchwork <patchwork@emeril.freedesktop.org>,
 Shuah Khan <shuah@kernel.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
In-Reply-To: <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
References: <179342234355.4.16705453209886955762@gmail.com>
	<20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
	<36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
	<20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
	<179535872126.34.4789080961796247940.b4-reply@b4>
	<af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CA9C81C0006
X-Stat-Signature: 6banwyaczsga5qsyztqm5j7ji5fb9h9s
X-Rspam-User:
X-HE-Tag: 1795367661-856123
X-HE-Meta: U2FsdGVkX18ye7VT2lEMnO6AUyTYeI7vLlNY9vKJRoNoXEv856irSlDgQ6U8xGWk5yIGcuMn9goyrpfjw9FODWzjKPR/RuUrowiyffT7plJdbb68eN6jmMD/ow834FwvQKvr5dZuaqw9Ou3luaBATaOZtZ3SbgIShr7GdfN2F/GBxVKrt9Iw8U5mBiE6h0DQdYWSdwzR/D9GtC9yDcKBgOu6h1kNq6QWHG4lJbj530+BU5qlwL6Rm3oLVpzjfcnDOPI+Hl2TgNuQUPSimLhwK4H+k4bzOl0afHviAanvURbvEz3sjRNoBoRqr29AjwphuVV2xW/L8nLnnTZxOzgX7KD8h8vJ+tBn23nPr/lF96Pa1oqP8VHtPu1QPXw6/mlSJ7qaS3KECFOVlPVrEWK6o2gX+e2hrKc1Jm/TWQIu01dQEghaSej9PouVkO6NiaicJ/2QwFy/HgPmRWsxPZYspIyzzPhhC287CyZhZPMjYRF/6tj1Pz/1LqzmrcLhchfzA3yxD9kZ+ewToyw3B1hVSm8pc843s8G8hoDxMeqgxB701XbuYjj3Q+BVROL0ksw4hhdNaRJ3JgXThcznZorbqhJj17Drlun9oPkYta4qFpfHcBJ3Xh1RM7nJVFolc6aeHq82QmMgXY3yU66vRJBFYPm2YpT8H1vcu6Oh56S9+745c01MeaMs2ZBzzKJpbh78JcTc71dvkUSx9UIKMFyaQBnMdSq5iZ3Zww2t0/tfZVLz5ir2RnMv2w5JauiDGhCzhYS/B1rhdnIITvohTlAWHSlEy7NmIJw9x/3mvAS6SBQOk3ZxowNpoqBfaQ8pgaNDQ5ZF81V0PD/whdn8ahJnCN3nEqO251WT4N9qAOwDFL8kU/08fqaQA0Zknq/H6aCb3MzKF2uguE6gnWa58QwNTWz0ER84JyvfVaecuDs6QDddXxb+rfC3leoXXwUVqyQylmmNhzEISwJOOI2umyU
 PTM2deHS
 irmDUBHa4C8glfY7Ey5cX8tM/aNS5KyQsliMSSiaqF6PNKwPyhwHbhbf3FI1m8ZoPbSlbDwZvRLoguJWfcFRN95EEB59lsfIcYTFUcD/XW0idqTsLx1fH0JqN1lv5rXoQuzNxBVbIZiJ3gc53/X6u6q5OdduQ2+HJbtzSDYrUmDqG4QIu33GiPrafFjbBteqCrkDycnduPyE3pmGgjBhInWJ5J2d7s3GxL0zTwTDIIhbPI4cogDqm/2YgSt27T3IFQ5qdx1aV0zHA1KlxfahQDSfeg2I9dcL4HMdzEhv/qB/njsHxqZVUECU6GW9oCPKoea+drM5pDiIfswTUriOloHWxE5tqcnFf5V9PqUqrCwCjMP692sTA6bwte4S1ZrNDGOveIonk4IfjlGixanaYdt8ax1nt+ddNC7As+feasWBEWo3J7JzeZfstJhWZPfRSVL2Ayhsqepj5lYR85vtr1GmHzSArC6rkt3LF2moOtDHSCzVDdcIutnzy9uhdxOtggKqIMxhV3kCSQYyoWqEmldjb2NQcVuAA24U6a295R11s+etNw3dwTRaD33N530uSclHknj5RA60jc4z+HwR7BV+My2cy3i6NQLTCOtr+059sIXrIO/hor6sSbJsJc0Z1XFjGXgVYJzWkkmYuWTEhq+H50J7SunOqv5rN2WTlWYn3euzo5OK6o0Llc+fkzfzD+viY+WLIQ5AQhsgD7RGuInolCQuLmGiJ2WOAdptQaXoLThYQbqynCunURh48YyN/F0rI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 18:41:39 +0200 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

>=20
> On 11/22/26 16:45, Aveline Noir wrote:
>=20
> > Hi Andrew,
> >
> > On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
> >
> >> Store the corresponding RAM backing page instead.
> > This avoids the oops on the first read through the second descriptor,
> > but leaves a stale backing page pointer after CPU faultback.
> >
> > Since the mirror XArray entries don't take a page reference, they rely
> > on invalidation.  When the CPU later faults the page back to RAM,
> > dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
> > mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
> > migrating descriptor's entry before the backing folio is freed.  The
> > second descriptor still points to that freed backing page.
> >
> > Reading the same page again through the second descriptor in QEMU
> > triggers a KASAN use-after-free in dmirror_do_read(), and the read
> > returns the stale data instead of what the CPU wrote.
>=20
> I think this is right, but a fairly artificial scenario: it needs two
> descriptors open on the same test device in one test, a migration through=
 one,
> a read through the other, a CPU fault back, and then another read through
> the second descriptor..
>=20
> The fix lets the device private page content be read without an oops
> in the context of one fd which is an improvement.=20

May as well fix it.  I'll test this updated version.

Mika, please feel free to take this over, perhaps integrate it (or
something like it) into whatever you've got going on?  Or not, let me
know ;)


From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: invalidate all mirrors on device-private migration
Date: Sun, 22 Nov 2026 08:53:12 -0800

When one open of the fake HMM device migrates a folio to device-private
memory, a second open can fault the same address into its mirror page
table. The second mirror then stores the inaccessible device page, which
can oops the kernel when dmirror_do_read() copies from it. Store the
corresponding RAM backing subpage instead.

That conversion also makes the backing page's lifetime significant to
the second mirror. migrate_vma_setup() notifies all mirrors before CPU
faultback, but dmirror_interval_invalidate() skips the notification for
every open on the same device. The faulting open clears only its own
XArray entry. The other open can read or write the backing page after
migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
and stale data through the second open.

Handle migration invalidation for every mirror under its mutex. This
clears pointers before faultback can free the backing pages and waits
for an active mirror read or write. During system-to-device migration,
the migrating open installs new entries after migration; other opens
refault on their next access. Remove the now redundant XArray erase
from the faultback copy loop.

Extend the PMD migration selftest to read its last device-private
subpage through a second open, then fault it back to RAM, change it,
and read the new value through that open. The trigger is available to
a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
enabled; it does not depend on physical GPU hardware.

Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@lin=
ux-foundation.org
Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-repl=
y@b4
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Aveline Noir <jm5905938@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttil=E4 <mpenttil@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>

 lib/test_hmm.c                         |   20 +++++++-----------
 tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
 2 files changed, 33 insertions(+), 12 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-=
migration
+++ a/lib/test_hmm.c
@@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
 		page =3D hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
=20
+		if (is_device_private_page(page)) {
+			struct folio *folio =3D page_folio(page);
+
+			page =3D BACKING_PAGE(&folio->page) +
+				folio_page_idx(folio, page);
+		}
 		entry =3D page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
@@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
 {
 	struct dmirror *dmirror =3D container_of(mni, struct dmirror, notifier);
=20
-	/*
-	 * Ignore invalidation callbacks for device private pages since
-	 * the invalidation is handled as part of the migration process.
-	 */
-	if (range->event =3D=3D MMU_NOTIFY_MIGRATE &&
-	    range->owner =3D=3D dmirror->mdevice)
-		return true;
-
 	if (mmu_notifier_range_blockable(range))
 		mutex_lock(&dmirror->mutex);
 	else if (!mutex_trylock(&dmirror->mutex))
@@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
=20
 			src_page =3D pfn_to_page(page_to_pfn(spage) + i);
=20
-			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 			addr +=3D PAGE_SIZE;
 			copy_highpage(dst_page, src_page);
 		}
@@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 	migrate_vma_pages(&args);
 	/*
-	 * No device finalize step is needed since
-	 * dmirror_devmem_fault_alloc_and_copy() will have already
-	 * invalidated the device page table.
+	 * The migration notifier has invalidated all mirror page tables
+	 * before the backing pages can be freed.
 	 */
 	migrate_vma_finalize(&args);
 err:
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mi=
rrors-on-device-private-migration
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 =3D -1;
 	int *ptr;
 	int ret;
=20
@@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
=20
 		close(pagemap_fd);
+
+		/* Read a device-private subpage through another open. */
+		fd2 =3D hmm_open(variant->device_number);
+		ASSERT_GE(fd2, 0);
+		buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
+		ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr =3D map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(*(int *)buffer->mirror,
+			  (npages - 1) * self->page_size / sizeof(int));
 	}
=20
 	/* Fault pages back to system memory and check them. */
 	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
=20
+	if (fd2 >=3D 0) {
+		/* This open must not retain the freed device backing page. */
+		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] =3D -1;
+		buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
+		ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr =3D map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(buffer->faults, 1);
+		ASSERT_EQ(*(int *)buffer->mirror, -1);
+		ASSERT_EQ(close(fd2), 0);
+	}
+
 	buffer->ptr =3D old_ptr;
 	hmm_buffer_free(buffer);
 }
_


