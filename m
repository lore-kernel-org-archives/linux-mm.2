Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A70606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtQ/gtQ9
Received: by kanga.kvack.org (Postfix)
	id 292C56B05B2; Thu, 26 Nov 2026 01:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243456B05B3; Thu, 26 Nov 2026 01:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181A56B05B5; Thu, 26 Nov 2026 01:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948786B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:53:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 157BEA8897
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:53:57 +0000 (UTC)
X-FDA: 85476355314.01.6E47758
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7147D80002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:53:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KtQ/gtQ9";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795676035;
	b=RL24tf0X9rpEP2Iwur4beiouM19iyNVozywXQEWuKif+Vh+kgaWcYF39qgxXUonSAG/j4z
	iAxovxK8A/5KWDn/Vr8RELd1Q4T3nbymVDeCKsEDnHJsBrOHA/tPCyM81Qv+gOMCY7flI8
	4m6dEdFlXg8VPvnUfLUGSjyuS01G9zI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795676035;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRCskMUsjY9VBCq/rzovphXjgMJvVJ0Y3mHcjjS/xbo=;
	b=1WkbmoxJ9n++QBBh5TrNjwoR9Q/HwHf2hKA3M1GKIHYcacWHO5oFmrSTbXVmnQETT2tYFT
	73wzJg2fjqvAEPiRZ1gQyQHl5ZJ3G6+dtHg9aPxz0b8U5kK+azyx7w3vR5oBAUh/GG7rVf
	pEcSVgZyItrvoB38nQGtFz98T7Ktc7w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KtQ/gtQ9";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C33FE62832;
	Thu, 26 Nov 2026 06:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7C41F000C4;
	Thu, 26 Nov 2026 06:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795676034;
	bh=BRCskMUsjY9VBCq/rzovphXjgMJvVJ0Y3mHcjjS/xbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KtQ/gtQ9S818EkS3E3ymldDptCZZacfyZVjE7TK9ejCvCjEQEs1qrfiIkTJIbOuKj
	 8Pk3rCVd7eQiN/h+YvqTOv8fUa5VvdmwQogCqiSp6Jz+Alo0syvbevC47HKXZjWe73
	 QQ/UxVoNJ6YNgyCstoiH99aqnSF37LOlsmQnZiY6slNuLRdScA0DXUYuTBl0/feraR
	 y5Gr0Sph1c0vdRdStdzcoVOFDWKjLwrL+Jl89VfE/n5zKdDk4jdLhDhTCNzyAQIpgY
	 Q8SNViK9m3uP1HlNABhkMwUiB4sU2/qYjKV4hOIltGwMWpaU7PFdWzX0nE+nIuick1
	 mMHYb3VG3rEvA==
Message-ID: <sashiko-outbox-234914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, =?utf-8?b?TWlrYSBQZW50?=
 =?utf-8?b?dGlsw6Q=?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, "Aveline Noir" <jm5905938@gmail.com>, "Ralph
 Campbell" <rcampbell@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon
 Romanovsky" <leon@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>
In-Reply-To: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 06:53:53 +0000
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7147D80002
X-Stat-Signature: jigykaesyhah8sqyzozq3r5t5ppsdgcr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795676035-408261
X-HE-Meta: U2FsdGVkX1/BwjRGqvh2oONNsJJnzKcfnNV8MFEgBcC/fKm1L0zJt3uqAnlb9ej7cJpqs640TYH+4z0aoqZiugqpAttwGQY1vRBMG2OQf1VP2kpuZoIGhD4utpiIaOE3EpEvt1UruLfuClPmRKyKvro9PqtXpavuKSW/Wktn7JSDaQJ1s3jCCxTy/FXGLmpnSegzsn8xXKBVSjQyiFdgNrS5Xqc58fSuOt5KADP04KwHkKRsBerdRSNwODnYZpwJ0peXgQVssUT+oucQFfLbnn4aJULDqx0K4ADyyO9O0MkhO6d7VLu/p4U7+qpoyV4aKWTwt+eeawNQr0l8/kQzc8QJZMkIYs21c64XESvtdMVoWXZ+3yiQnWPDmeB/KvW4lAFDuBKK2NKfZkXp8k08yBhLS6GWGWEZfvkE9OpKTeboN2/ICTpk9+xaGH5mcBDT9BgoHVzVEXYNaQcIqJv1HXXpC4wI/d88mqcHyQfu0rBZ5PecEU1V9A/6TrI6DMzJ4q6NzbK6FUv9oC4ccxPPDXQDEpVrTp39lfszItS4ANctN2Xq2QLNktCUlgVt5VqWhTKj+8x9m8BM1zbnQi9Xb/SHSRs3UazWmhhutNP01XtbSHAxVX1m9qDAFbyMEqCbM2qSwtB8zVuc8N0XB/E5L+zkUs3WoivAlLuCf8uuJ+IhHM3ec+YDCuSuWDYOZO0IvwKLWcBGGgDbqLtRTQyUWmRyKho+74HEMyYbrOC0xu3/ZnYPusen8SU9cGusxS9KiJ8qfI/QXeR2ITeVT/JfXhm0ap6KDa86M8se2g8GdHWHetzkSfIP5+MghfFcW/4oNw3by0mAuiLCKGJhh2muVIJ0QeT6OcM4gQXS2Zr5Mn1IHMCR3Ams0YL/Ek7xJvoe2+MiCDw7LoaEHLDPWy9yge2g94wz/We0pYJOYD6uZpBk9K8kaSB35DKgZQONlnsVsk2QMYcpffg7t6p2aRN
 QeMtxxfR
 /Zdg1HagSSkDAY0oZpGzQ6HoJz6XXNiHz/5y6iPBsQ+ozBM/kWL1Ad47rCYVtseFkiQDe5RpO2I8u+RXnJQpYV8X3KLcclaURysTLgMeep7R0wsdKfWa2UWArqN6TPmUwaisOfsjsL692/0LttwN+kDeLEev6gYuzWgeXmo0xCooAhktjK6M6IHIEGOH6RonNgxNYc7Z1C+meedJlw0Moi7AcJpJUGodcv1vQTnoRZRIZNmS7MbGjJmAOwl1IEODD/iZjIFOqzBSMuRsUBey7vKln+O4YxGaHVCyuWxMd9pygSJ1XqQgobO6CJ06fhdO6aFJGhdGPAC4yVnyEMkn8F4SiZ2BRw+7ruKyauCoa6TlX+Yh0II8/3f6RbQ7Nqe8u8eZPfancVOFSPH+zufAmn78CRFHLcOWTwD+D6iODWYPoKthrbqyOlV9Ip1dyFPBCexqhF5kP9GZvjoej2PzWUmeDdfLfqzSmJunrA5n8jKvHBrSR8moBZ1x73WyW4T75KZOB+J4K67fNO1oNM/6opinPLz2ur7+085OGVhrgZCJarclKhXPzGY7uaXfcmYH0T1RGiCfRxVw4f+191dp2gafokP1Q9T6/EDBqVw/b2EI5WlFvHJwb6AXGtNQE82PkZ+Y7q3wh+QYD7P9BJfXTFLmEkN/sNhSliEBH0Uh/QkdljxaRei9DUPil/n/TZsKClBfqfzTHTF9q2JWSOP/6T1Dy5wVTvvnOtF5VVZzRmc4CpPFzRseuqXasZVcgnzDZOwE2htYzWfh5jJOAXX/WxfKqhDO8yjj1efLC0ZE/bK4dW789bdSqT1htqY4xOFhk78yXVz0C4Vc/cmYWXFZdpMZ/jUZgWlEKotvyivvaFGW7+pYafN3Qmi4p70F3o/BDuE/zjoWyS3/rYi+q9Ot25c+cHdkWHLnZKAIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] lib/test_hmm: dmirror_migrate_to_device() fails on resident
  device pages
- [Medium] lib/test_hmm: dmirror_do_fault() maps subpage 0 on PMD
  device-private fault
--

commit fd992ab990d0dc726b0adb39191efdbd1d7b171d
Author: Andrew Morton <akpm@linux-foundation.org>

lib/test_hmm: invalidate all mirrors on device-private migration

This commit stores the RAM backing subpage instead of the device-private
page in mirror page tables on fault, and removes the same-owner
MMU_NOTIFY_MIGRATE bypass in dmirror_interval_invalidate() so all
mirrors are invalidated on migration.

Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@lin=
ux-foundation.org
Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-repl=
y@b4

> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index a09a766b15b05..ad68e2636f313 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -290,6 +290,12 @@ static int dmirror_do_fault(struct dmirror *dmirror,=
 struct hmm_range *range)
>  		page =3D hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
> =20
> +		if (is_device_private_page(page)) {
> +			struct folio *folio =3D page_folio(page);
> +			struct page *backing =3D BACKING_PAGE(&folio->page);
> +
> +			page =3D backing + folio_page_idx(folio, page);
> +		}
>  		entry =3D page;
>  		if (*pfns & HMM_PFN_WRITE)
>  			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);

[Severity: Medium]
Does folio_page_idx(folio, page) always evaluate to 0 when faulting a
non-PMD-aligned subpage of a PMD-mapped device-private folio?

When hmm_range_fault() walks a PMD device-private entry starting at a
non-zero offset within the PMD, hmm_vma_handle_absent_pmd() initializes
pfn to the folio's head PFN without adding the within-PMD page offset
((addr & ~PMD_MASK) >> PAGE_SHIFT):

mm/hmm.c:hmm_vma_handle_absent_pmd() {
    ...
	if (softleaf_is_device_private(entry) &&
	    softleaf_to_folio(entry)->pgmap->owner =3D=3D
	    range->dev_private_owner) {
		unsigned long cpu_flags =3D HMM_PFN_VALID |
			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
		unsigned long pfn =3D softleaf_to_pfn(entry);
		unsigned long i;
    ...
		for (i =3D 0; addr < end; addr +=3D PAGE_SIZE, i++, pfn++) {
			hmm_pfns[i] &=3D HMM_PFN_INOUT_FLAGS;
			hmm_pfns[i] |=3D pfn | cpu_flags;
		}
    ...
}

As a result, hmm_pfn_to_page(*pfns) is &folio->page rather than the
requested tail subpage, so dmirror_do_fault() maps backing subpage 0 into
dmirror->pt.  The new subpage read check in TEST_F(hmm,
migrate_anon_huge_fault) reads subpage 0 instead of subpage npages - 1
and fails its assertion.

> @@ -325,14 +331,6 @@ static bool dmirror_interval_invalidate(struct mmu_i=
nterval_notifier *mni,
>  {
>  	struct dmirror *dmirror =3D container_of(mni, struct dmirror, notifier);
> =20
> -	/*
> -	 * Ignore invalidation callbacks for device private pages since
> -	 * the invalidation is handled as part of the migration process.
> -	 */
> -	if (range->event =3D=3D MMU_NOTIFY_MIGRATE &&
> -	    range->owner =3D=3D dmirror->mdevice)
> -		return true;
> -
>  	if (mmu_notifier_range_blockable(range))
>  		mutex_lock(&dmirror->mutex);
>  	else if (!mutex_trylock(&dmirror->mutex))

[Severity: Medium]
Does removing this check cause a regression in dmirror_migrate_to_device()
when part of the requested range is already resident in device memory on
the same mirror?

During dmirror_migrate_to_device(), migrate_vma_setup() runs with
MIGRATE_VMA_SELECT_SYSTEM and fires MMU_NOTIFY_MIGRATE across
[args.start, args.end).  Without the same-owner check,
dmirror_interval_invalidate() calls dmirror_do_update() on the migrating
dmirror instance and erases all of its dmirror->pt entries in that range,
including pages already residing on the device (plus the entry at
end >> PAGE_SHIFT because xa_for_each_range() takes an inclusive upper
bound).  Because those already-resident device pages do not have
MIGRATE_PFN_MIGRATE set, dmirror_migrate_finalize_and_map() skips them
and leaves them unmapped in dmirror->pt, causing the verification
dmirror_do_read() at the end of dmirror_migrate_to_device() to fail with
-ENOENT (which breaks TEST_F(hmm, migrate_fault) in hmm-tests).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/bae41f6fc4114357a8a=
74c8b958f2bdc.1@linux-foundation.org?part=3D1

