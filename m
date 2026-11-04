Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE3F606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CP8RO0lM
Received: by kanga.kvack.org (Postfix)
	id 87CBA6B05B8; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF296B05B9; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CED06B05BA; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44BF86B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEDBBC0655
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:08 +0000 (UTC)
X-FDA: 85396431456.15.B80377A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25A7740002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CP8RO0lM;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773087;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ncys28GT1dDbKRe5YD7u3dVcVKVjashKGfApS76zKk=;
	b=CuZSg079Lq4+6jo9DYWp04TmSllsjFgISdBf7DUXZFg8ih9dmAJBGfX7XFU2MYxYUIe8d1
	+IbMg10KuCv+ameIusPwjz/uD5IrgojdJ7Yb2eGYcphavqybOogFaMPzp8M1FFd0xQVxj6
	HbYh+4HpspUd5/Nxv0NKotEIGXxLIjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773087;
	b=gWiThji6SgccapN7oO4PhBjwcKpRTS2TtT+WqvMO7G9lBawrlm7DTvEslN+07sd0FY6ix4
	AvUPsSR2jEtyqLPyDq+Divpe7CaE9KXKpiIwYoMsd/li4zdNrQ1C2iRyAlaYGPlYvQHZ9K
	QtUqJvSII+tmyQ1GxKjCh0e4ndiDcEE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CP8RO0lM;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5919542DD5;
	Wed,  4 Nov 2026 06:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDE71F000C1;
	Wed,  4 Nov 2026 06:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773086;
	bh=0ncys28GT1dDbKRe5YD7u3dVcVKVjashKGfApS76zKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CP8RO0lM8yulylGyQYoWHmIJ3J40ONB8r+BClYOf9NNjilVFOZM2IlQfjUh/AH3nR
	 V4eink1u5v+Zm2AhRn/UaTloRxvpdG0INjoyyXKDfd74p2JMhBqDGifRDVVIya+voY
	 Jo0dwL5OUMqE/VP2+ydePNKVoqQWeZhtmTtdKN7qv1PKFcAkftEtp2og8/ehTtyE6B
	 wL7Lw7bsof9gCvJu1sdzlh1mmT50Gu124FdYc3jCn+4sKdRo7iM6AGsBMPm1s34IiL
	 l1EZDZ7IjjoTiWkOTBayxG1u8mnF9OgX6XgQ6Hpl0qVz/LtXQ/TDxr4x3QLGeeUgA3
	 r3hO2upBYAWcQ==
Message-ID: <sashiko-outbox-196748@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 10/12] lib/test_hmm: add a new testcase for the
 migrate on fault
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Marco Pagani" <marpagan@redhat.com>
In-Reply-To: <20261103061629.972669-11-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-11-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:18:04 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1w1pc5f8gj36h6tuunoy8n8994pe1p6d
X-Rspamd-Queue-Id: 25A7740002
X-Rspam-User: 
X-HE-Tag: 1793773086-296082
X-HE-Meta: U2FsdGVkX19JcVRe9MnfY5UMwYZeElSW8DKiAx58sQNG2YMfc2OgKM+cAmzCVNd6k8/Dw2Yex8iHeo3CyqSTrhbaPTMyuOmU0GvYzjLSUxUiSKE0/PFc121rZmcsl+X0voW3MlE4892aF2bexu75OyzwXFjtGwqhjy02ro2NsRwqyWW8VAzkkyuoK+fNQzeZSL8lSvvZLDBHlvQfzqdKhWO+ZfUnFm7jKYsG1nZkTWF7FKglgAPWU8OcPi8ATCHcsYkWwu4WCUdMazboRyE2jXc29oHXh2s1wIWlpx9ldmehoSv1E/hOncOQKmCHXz3Kpqt6Y40QKCIi4wwkyY2qXLLFasjWh2/nQ6LoD9lBQE63MsP2L9jrqZ4Mory8TUT+Yonk9n2WFF4pNoxdQ/3OsP3McUTKHL1A4K6H3T5jh1TwrG5irGyEG0rcptembdnn+dBA6QSREf9qsnotAI+Ld+dBIZGICFg3Oc7vPKEkkfn1ui+MtyttSpbeWc+fIAGSuRmMj4D5ciZVzx9QOiZuQ1S/3jYMpYRayGT1rwa0XhG7va0NssAVZGJXtedR4srIkkSTTfIKdddnsXwzSohv4oWCZxdJU7CCpVqGSNrE09+UyGrCFT2r8pmKkaaAgDeEgQzhoBaQGaj7jthjNuxF2Pub74tlLXP5y2Aah9elqoMC0cB0ZndO66b8gmiwNezwZxCEpQtsZQ4FuvOvK/HCbm9VCN3S/TUyfm32ZtOpWOKf86TrPf76HuFtyokM6/d/iQjXsUSEDZhozE2PBxlQYALjRCnP+nffIuCLflNlpXAOWpaKDj1ChipYe4q/1Fxb64ThstbVSYefwEAcIH7C0/VG/AgwTOOvJzaqXDRMcKpeFmQ2IlPPrAfcQTaW5/3xzGE6rK7cSlkwDJJOAen8+zsjzl9901pqTTDSVkMVDX3fxxCjFmWBbqDhyhrJokk39lrKdDDDf4x2NxSbBq+
 nMBzVV2Q
 YU0z8UJR+isNbp5nAHQQGodejbckKZqaXamWR7Tgp1MsqpEits/qDOEKU/3jYRVfMgHTQYQQS6aBqsKSzwXKPWKejSvxvPIELCVvNzInAMF30qs1cjdXW25yK1YAezfkHBoNB+ki6zMRQPpfTyJ4ggZ+12bMO/l1v6z0yg2ZeuKl50wsNOp4btxh/QUrIZ+eKijPnEatvWZk0hzdYDpADFsnH9Au4uGfd67pRVXKJ/Q/7YAXwJ0BKSAOu/kNggVs8/J68ehXU1VMk82yOMJD/oka3Q9IkB8jsTql9mj+AMXGNW4HSce2m6a69QutQDw0NU5rVZkCpHihzCK1ZDt5BDNGFT72e6kos1lcVyritYqXClK0eeghTTLwxGe91GOgArW6eZttPTM1rz1KorCkLjvWBsniGZ5un28FWCxC2CaeCM2WY2xxY5UN5I+36rlnYWBL6TZUz4iCPUKw+qDRD81wIi9HhC1Vawxx1jv6ynJmeyvTE0kQcPp9g+qFlaH/I7npzRRsOa0mQnRxk3WlyVMLV8j072BQVBU0wUNYaOCLQQhVPb4CIWfHfrfVGnxGN2KsBf0qSE/0zVaTr8vEQwZQn+AIy4wqomxVtVSKYQD9tYP6pOrXT+XtOKIPqa/syMThbgjkhuHGDYJf5qhapMvVuG1Nqd8h9i4ZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: test_hmm: deadlock and folio leak on retry in dmirror_range_fa=
ult()
- [Medium] mm: test_hmm: unmapped device pages on retry in do_fault_and_mig=
rate()
- [Low] lib/test_hmm: excessive stack frame in dmirror_fault_and_migrate_to=
_device()
--

commit 7670468c9cdf50d8e222db90061981491fa308c8
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

lib/test_hmm: add a new testcase for the migrate on fault

This commit adds a migrate-on-fault testcase to the HMM test driver and
selftests using HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE with
hmm_range_fault() to fault in and migrate ranges to device-private memory.

> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index f05f801b8404b..2045896493ae3 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -36,6 +36,7 @@
>  #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
>  #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
>  #define DEVMEM_CHUNKS_RESERVE		16
> +#define PFNS_ARRAY_SIZE			64
> =20
>  /*
>   * For device_private pages, dpage is just a dummy struct page
> @@ -355,6 +356,7 @@ static int dmirror_range_fault(struct dmirror *dmirro=
r,
>  	struct mm_struct *mm =3D dmirror->notifier.mm;
>  	unsigned long timeout =3D
>  		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	bool migrate =3D range->default_flags & HMM_PFN_REQ_MIGRATE;
>  	int ret;
> =20
>  	while (true) {
> @@ -364,9 +366,15 @@ static int dmirror_range_fault(struct dmirror *dmirr=
or,
>  		}
> =20
>  		range->notifier_seq =3D mmu_interval_read_begin(range->notifier);
> -		mmap_read_lock(mm);
> -		ret =3D hmm_range_fault(range);
> -		mmap_read_unlock(mm);
> +
> +		/* mmap lock held for whole migrate on fault operation */
> +		if (!migrate) {
> +			mmap_read_lock(mm);
> +			ret =3D hmm_range_fault(range);
> +			mmap_read_unlock(mm);
> +		} else {
> +			ret =3D hmm_range_fault(range);
> +		}
>  		if (ret) {
>  			if (ret =3D=3D -EBUSY)
>  				continue;
> @@ -382,7 +390,9 @@ static int dmirror_range_fault(struct dmirror *dmirro=
r,
>  		break;
>  	}
> =20
> -	ret =3D dmirror_do_fault(dmirror, range);
> +	/* update device page table after migration */
> +	if (!migrate)
> +		ret =3D dmirror_do_fault(dmirror, range);
> =20
>  	mutex_unlock(&dmirror->mutex);
>  out:

[Severity: High]
Can retrying inside dmirror_range_fault() when migrate is true cause a
self-deadlock and leak folio locks and references?

During the first call to hmm_range_fault(),
hmm_vma_handle_migrate_prepare() and hmm_vma_handle_migrate_prepare_pmd()
collect present pages by locking the folio, taking a folio reference,
installing a migration PTE, and setting HMM_PFN_VALID | HMM_PFN_MIGRATE in
range->hmm_pfns.

If hmm_range_fault() returns -EBUSY, or if hmm_range_fault() returns 0 and
mmu_interval_read_retry() trips in dmirror_range_fault() (for example,
after migrate_vma_split_folio() splits a PTE-mapped large folio and fires
MMU_NOTIFY_CLEAR, or due to a concurrent invalidation),
dmirror_range_fault() loops back via continue without returning to
do_fault_and_migrate() to abort and finalize the already-collected
migration entries.

On the next iteration of the loop in dmirror_range_fault(), calling
hmm_range_fault() -> hmm_range_fault_locked() zeroes range->hmm_pfns:

mm/hmm.c:hmm_range_fault_locked()
	if (hmm_select_migrate(range)) {
		WARN_ON_ONCE(range->pfn_flags_mask);
		WARN_ON_ONCE(range->dev_private_owner !=3D
			     range->migrate->pgmap_owner);
		memset(range->hmm_pfns, 0,
		       ((range->end - range->start) >> PAGE_SHIFT) *
		       sizeof(*range->hmm_pfns));
	}

When the retry walk visits the migration PTEs installed by the previous
attempt, hmm_pfn_collected(*hmm_pfn) evaluates to false in
hmm_vma_handle_pte() because *hmm_pfn was zeroed:

mm/hmm.c:hmm_vma_handle_pte()
		if (softleaf_is_migration(entry) && hmm_select_migrate(range) &&
		    hmm_pfn_collected(*hmm_pfn) &&
		    hmm_pfn_to_page(*hmm_pfn) =3D=3D softleaf_to_page(entry))
			return 0;

It then treats its own migration entry as an external migration entry and
calls hmm_do_fault() -> handle_mm_fault() -> migration_entry_wait(),
waiting forever on the folio lock already held by current. In addition, if
any collected PTEs were unmapped before the retry walk (or if the retry
walk fails or times out before revisiting them), zeroing range->hmm_pfns
prevents hmm_vma_handle_migrate_prepare_rollback() and
migrate_hmm_range_setup() / migrate_vma_finalize() from unlocking those
folios and dropping their references.

Furthermore, if dmirror_range_fault() times out at time_after(jiffies,
timeout) before calling hmm_range_fault() on a subsequent subrange chunk,
do_fault_and_migrate() still runs migrate_hmm_range_setup(),
migrate_vma_pages(), and migrate_vma_finalize() on the stale src_pfns and
migrate->start/end state from the previous chunk.

Should dmirror_range_fault() return -EBUSY to do_fault_and_migrate() when
migrate is true so the caller can run the migrate_hmm_range_setup(),
migrate_vma_pages(), and migrate_vma_finalize() cleanup before retrying?

[ ... ]

> @@ -1377,6 +1398,127 @@ static int dmirror_migrate_to_device(struct dmirr=
or *dmirror,
>  	return ret;
>  }
> =20
> +static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_rang=
e *range)
> +{
> +	struct migrate_vma *migrate =3D range->migrate;
> +	unsigned long timeout =3D
> +		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	int ret;
> +
> +	do {
> +		mmap_read_lock(dmirror->notifier.mm);
> +
> +		/* Fault-in pages for migration */
> +		ret =3D dmirror_range_fault(dmirror, range);
> +		/*
> +		 * Set this up even on error: hmm_range_fault() may have collected
> +		 * part of the range before failing.
> +		 */
> +		migrate_hmm_range_setup(range);
> +		if (ret) {
> +			/*
> +			 * dst[] entries are empty, so this marks every collected
> +			 * migration as failed. finalize then restores the source
> +			 * mappings and drops the associated locks/references.
> +			 */
> +			migrate_vma_pages(migrate);
> +			migrate_vma_finalize(migrate);
> +			goto unlock;
> +		}
> +
> +		pr_debug("Migrating from sys mem to device mem\n");
> +
> +		dmirror_migrate_alloc_and_copy(migrate, dmirror);
> +		migrate_vma_pages(migrate);
> +
> +		mutex_lock(&dmirror->mutex);
> +		if (mmu_interval_read_retry(&dmirror->notifier,
> +					    range->notifier_seq))
> +			ret =3D -EBUSY;
> +		else
> +			ret =3D __dmirror_migrate_map_locked(migrate, dmirror);
> +		mutex_unlock(&dmirror->mutex);
> +
> +		migrate_vma_finalize(migrate);
> +unlock:
> +		mmap_read_unlock(dmirror->notifier.mm);
> +	} while (ret =3D=3D -EBUSY && !time_after(jiffies, timeout));
> +
> +	return ret;
> +}

[Severity: Medium]
As reported by Sashiko on v16 [1], when mmu_interval_read_retry() returns
true in do_fault_and_migrate() after migrate_vma_pages() has executed, can
this leave migrated device-private pages unmapped in dmirror->pt and cause
dmirror_fault_and_migrate_to_device() to fail with -ENOENT?

When mmu_interval_read_retry() trips here (for example, due to an
invalidation anywhere in the process mm since dmirror->notifier covers the
entire address space, or a partial zap, or split_huge_pmd() in
migrate_vma_insert_page()), __dmirror_migrate_map_locked() is skipped,
while migrate_vma_finalize() still commits any non-zapped migration PTEs to
device-private memory (and migrate_vma_insert_page() has already installed
device-private PTEs for pte_none or zero-page entries).

On the subsequent -EBUSY retry iteration of do_fault_and_migrate(), those
already-committed device-private pages are reported by hmm_vma_handle_pte()
as HMM_PFN_VALID without HMM_PFN_MIGRATE because migrate.flags only sets
MIGRATE_VMA_SELECT_SYSTEM, and dmirror_range_fault() skips
dmirror_do_fault() because HMM_PFN_REQ_MIGRATE is set.

Although the commit message notes that a real device would map committed
pages on its next fault, dmirror_fault_and_migrate_to_device() immediately
verifies the range by calling dmirror_do_read() directly without a fault
retry loop:

	mutex_lock(&dmirror->mutex);
	ret =3D dmirror_do_read(dmirror, start, end, &bounce);
	mutex_unlock(&dmirror->mutex);

Wouldn't dmirror_do_read() find no entry in dmirror->pt for those
already-migrated pages and fail the ioctl with -ENOENT?

> +
> +static int dmirror_fault_and_migrate_to_device(struct dmirror *dmirror,
> +					       struct hmm_dmirror_cmd *cmd)
> +{
> +	unsigned long start, size, end, next;
> +	unsigned long src_pfns[PFNS_ARRAY_SIZE] =3D { 0 };
> +	unsigned long dst_pfns[PFNS_ARRAY_SIZE] =3D { 0 };
> +	struct migrate_vma migrate =3D { 0 };
> +	struct hmm_range range =3D { 0 };
> +	struct dmirror_bounce bounce;

[Severity: Low]
Does allocating src_pfns[64] and dst_pfns[64] on the stack in
dmirror_fault_and_migrate_to_device() risk triggering -Wframe-larger-than
warnings?

On 64-bit architectures, src_pfns and dst_pfns alone consume 1024 bytes of
stack space alongside struct migrate_vma, struct hmm_range, and struct
dmirror_bounce (exceeding 1230 bytes of local variables before saved
registers and inlining do_fault_and_migrate()).

Commit 6046a3bed1c2 ("lib/test_hmm: reduce stack usage") previously had to
reduce the 64-element stack arrays in dmirror_migrate_to_device() after
hitting a 1408-byte stack frame build failure, and commit 775465fd26a3
("lib/test_hmm: use kvcalloc() for src/dst pfns allocation") moved
dmirror_migrate_to_device() and dmirror_migrate_to_system() to dynamic
allocation with kvcalloc(). Should dmirror_fault_and_migrate_to_device()
also use kvcalloc() or a smaller PFNS_ARRAY_SIZE?

[1] https://lore.kernel.org/r/20261021060506.2377545-11-mpenttil@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D10

