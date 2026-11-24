Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627E6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqYKCbF0
Received: by kanga.kvack.org (Postfix)
	id 586CB6B08AB; Tue, 24 Nov 2026 18:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DDD6B08AD; Tue, 24 Nov 2026 18:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473886B08AE; Tue, 24 Nov 2026 18:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3716B08AB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:48:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77C8F120D11
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:48:15 +0000 (UTC)
X-FDA: 85471653750.11.E196AC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B10A1180009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:48:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqYKCbF0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795564093;
	b=3ASV9cWzFRoyAHP5d3jZmPwHq4QE7Kora8t8NK6ADFrhmf/UVKvicjT0ReWjddqTPxslbV
	f0e8RuQbUR5ZaYVpX4RfV8rIbLdXXGCPmtmTXj73V4skkr1pRY+b4oSifKCuSfiEfzDaa7
	Zlm4FaunUnAUTCRI1l9VtX9O8/k6iUg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795564093;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3MJzrZxWtNJBKkoxKkXdy3LcJvsbWutGHSCpDKZ3ao=;
	b=m3+QwLcSinBf+SdOMiMf96qMrJUFu6SnM8I1p05BX6g538ewkORG/cf9zAWcCsvR0bZtqI
	ZXmrafAU52WdRV5GLRRvw/qhaqsqgTrx8jxKE5n0I8LF6I+SGclVdoqj4oT1dHROIgknK2
	28NLlgYjxhKsmUkGHU2eq7m31TbM1HI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqYKCbF0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9F0D4234F;
	Tue, 24 Nov 2026 23:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413D01F000CF;
	Tue, 24 Nov 2026 23:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795564092;
	bh=x3MJzrZxWtNJBKkoxKkXdy3LcJvsbWutGHSCpDKZ3ao=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqYKCbF0PlRw+T183XyiDDeQMA9gFsm27TU/hnB+mfFhD/ScjiVDSVz8ZxGwCKTDV
	 3Og4OsE8htv87a5B8mziTQyVeRy8bPs5s6AKgtkH7+FQ5iRU0aWia7cCX2ApP+2WNV
	 AeDYvei6ciqwheb3PPso4jefNDmopqbrIJVSILIMglPhOMDbr7MXJoJocTcjpl+jJo
	 bV4qQJZXM/dWa/k36SehNVn72Eobpr9vF2rhuJpg5fsjkMlHELjR+a9dIp1Do6JPZ3
	 VJ3TGBh3BipG5kn4wMYJXN1RfuwVRpiXXuzQEqODE8kZ4zfZqBwMFz1w/2ajBdqiHj
	 RFxMHePyK+Y0g==
Message-ID: <sashiko-outbox-232248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/18] mm/shmem_luo: Retrieve tmpfs files into a file
 created by userspace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261123233924.3970932-12-dmatlack@google.com>
References: <20261123233924.3970932-1-dmatlack@google.com>
 <20261123233924.3970932-12-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 23:48:10 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: pmiyed6dmo7nw1pb3it18pnt855d3nc5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B10A1180009
X-Rspam-User:
X-HE-Tag: 1795564093-143410
X-HE-Meta: U2FsdGVkX19mFemHoGPlHLm4a8P2iuv63/mTh6n1sOD2O5v5DBuERlSjq9wnoEa5Gr9HrYLthGadDJ5UXoN3w30g+w/blkq9/L7PrCxSOxaMc0wKI4nmZLWYAcVX7Ikh0Aex38tbM3SQ79tU3mhJVAIzPyhknnfo4W+TMZZGFr5YDt/Ef3V54nvLJn7f//P1h1deuJOqsseRPVtARO9veEguIYAK5zDgO42W0PiJ8P2jqwbkfI5TsEt1mkZNHgmgNjRDiP77+i3i8tR2PzLJXAV8paqk4s82nESyaxMcNSUnobzxV/L5gOmBKFbdNe5LymiKAjS0D020OZb/XUaJctdFNwFdOgRpy8F5G7KR4o0CcMVC9v10wcxQrlR7a7SgtUJXOCaD4TT20wl9O8T6+KKw2z0MJShUKQ5B5ZfeY6eMDP0uaZC+0uS97CQZzRXPVqGRuhXXVI2sNbeTopISJD55kQXSGI3bagRRLl8C9c0IaONzsHxV75v0ygfkgzKj0RKvGqYXPz7+85mDVSqI1LlWAMp//pCF4dDJntY3dGOBtRt0KzY0w7QuO4hj00JyYtW+yq/60Vt4IVJYOH45CLonlYCtQewo5tAu3Spmw7FAe+0wtlKK16G4lGYhFd+U0V3n02pxgstAkZTh/sPw2px/+T/WLzZ6ZdX0TIJ9RQNAsUozfCunpxFeoIRsXpCoqqrxigvNTNv5nChVY2nk4y0Kkq21f3QIHLwjUpC8cZEm2Y4XJXMCsGFpOMPVUmBmFlCbgIqx2jUNMrLspQO6kJbjC8vF9/iUKhne6DGIiDYtgD0PkqYbjSzi6C7sg0NWKGyVK0f5bifc38TnKN5LpNrbjIaGFt+SAKUFAHT+JB2QIyKmu9FPIiMO9F8fU03R8SaGoksPV5mtRPQngiFQ0U3mpv/E0FXrkNeArmt1iQKMY2wqZXoZxKguFPlpmTAGWqxEhKPxuZrIVKriGoS
 hdFWS4kU
 F+KGwPjQWwa1H0vVZfRNICQCKZUhsgVMI6/H4u41s4iXU1zifCn4ByBls0jIDoqXzRLsRlLdUx3IVg/fyoRY9nnes5BulGxhL9Rv3MPHgcZyp87y/oXFAiD4Q03/flwuZNyT3CzgwZ3VHAMCfgDntpgNVgQabBsZomwoMKR0aoCTid7a9fWHwhb9YQg2O74z2PNpQZLjf5dpqGAjMM3CWFI/5hiXFbgDWUmOCnC77jNb+Vlk1J0Xp9Uq0oDf76+FE2/wJJf8poT+s8L/ZnTl6Oe5lt3wo7l7qHJdmWgoxBFzzKMP9u42CcG4VcqxBAAnwy7n1rrn/G96bxX55k9yVULjQnpAM5m757SNHN8xNcjKQ1tjyIuY64WXFx1bHqpE3Wif5fyIcqV0eh6lwHhGWaAV+T0GUhb9cBLZ0bOWP+kGWI+n28/mBM9HzcleYxsaMvJjDy2mLBSvvtynQ8au9i6jMK3t9iuajwnkzSeAy03i2U6Sipn445KcbDAQtgJd/DW6yS3eWN7fjXY187uNHRA+MaQv1YZ7TWLZzyiGJDB9E6hfvnIFs+O6Wu+O+zR5pDpOqrXv/yBMe80Q/c5OfyupJvoMI2bX4S44Yn4fnjXBZQneiKGhZ2YOaKX1+H5wSszpmTVkohHMK/oUr8Vq23VmJHfpZVq7bW0WjRt/n3Gwy0WPk4GKx0S+IdYCoBN1FO2FQ5D9vVMgrlseJhQg87IK53XtH7wBEThurhYtjaeEQdbr3dJXdDXsqvve0yPQKYlpf4NBlARWz9XcwcwE2lLdyowutf/Q/t0VPJ7PTNmjMLqRh5436FQbcx0ZMMFlUFFa4Zv3nhOB6HnUIwORDEBl0ibBxBNNU5BPa1DojwMy6d3kdzhIlkQzJL4fWL4/AlY9T
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
- [Medium] mm/shmem_luo: leak of preserved folios on error in
  shmem_luo_retrieve()
- [Medium] mm/shmem_luo: race between resetting fallocend and
  __folio_split() drops pages
--

commit a56e31ee7bf0ce9b4eb0f3ed9175bc42d7abd83d
Author: David Matlack <dmatlack@google.com>

mm/shmem_luo: Retrieve tmpfs files into a file created by userspace

This commit adds support for retrieving preserved tmpfs files into a
userspace-created tmpfs file passed via struct
liveupdate_shmem_retrieve_arg, and marks tmpfs files with
SHMEM_LUO_FLAG_TMPFS during preservation.

> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index 854a49cd0aaa5..2ea161fb00fc1 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
[ ... ]
> @@ -554,6 +580,108 @@ static int shmem_luo_retrieve_folios(struct file *f=
ile,
>  	return err;
>  }
> =20
> +/*
> + * Restore a preserved tmpfs file into the file that userspace passed in=
 the
> + * retrieve argument.
> + */
> +static int shmem_luo_retrieve_into(struct liveupdate_file_op_args *args,
> +				   struct shmem_luo_ser *ser)
> +{
[ ... ]
> +	fallocend =3D info->fallocend;
> +	if (ser->nr_folios) {
> +		folios_ser =3D kho_restore_vmalloc(&ser->folios);
> +		if (!folios_ser) {
> +			err =3D -EINVAL;
> +			goto free_ser;
> +		}
> +
> +		/*
> +		 * The folios are past the end of the file until i_size is set
> +		 * below, so reads, page faults and memfd_pin_folios() don't see
> +		 * them, and they can be removed again if adding one fails. Like
> +		 * fallocate(), raise fallocend meanwhile, so that splitting a
> +		 * large folio doesn't drop its pages past i_size.
> +		 */
> +		info->fallocend =3D ULONG_MAX;
> +		err =3D shmem_luo_retrieve_folios(file, folios_ser,
> +						ser->nr_folios);
> +		vfree(folios_ser);
> +		if (err)
> +			goto truncate;
> +	}
> +
> +	i_size_write(inode, ser->size);
> +	info->fallocend =3D fallocend;

[Severity: Medium]
Can a concurrent folio split observe both i_size =3D=3D 0 and info->falloce=
nd
=3D=3D 0 here and drop restored pages from the page cache?

shmem_luo_retrieve_folios() adds each folio to the LRU and unlocks it, so
reclaim or migration can split a restored large folio without holding
inode->i_rwsem.  __folio_freeze_split_file() reads i_size before
info->fallocend:

CPU0                                  CPU1
shmem_luo_retrieve_into()
  info->fallocend =3D ULONG_MAX;
  shmem_luo_retrieve_folios()
    folio_add_lru(folio)
    folio_unlock(folio)
                                      split_folio_to_list()
                                        ...
                                        __folio_freeze_split_file()
                                          end =3D DIV_ROUND_UP(
                                            i_size_read(inode), PAGE_SIZE);
                                            // reads 0
  i_size_write(inode, ser->size);
  info->fallocend =3D fallocend; // 0
                                          end =3D shmem_fallocend(inode, en=
d);
                                            // reads 0, end =3D 0
                                          // drops sub-folios with index >=
=3D 0

In addition, on 64-bit kernels smp_store_release() in i_size_write() does
not prevent the plain store to info->fallocend from reordering before the
i_size update.

[ ... ]

> @@ -565,6 +693,18 @@ static int shmem_luo_retrieve(struct liveupdate_file=
_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
> =20
> +	/* Make sure the file only has flags this version supports. */
> +	if (ser->flags & ~SHMEM_LUO_ALL_FLAGS) {
> +		err =3D -EOPNOTSUPP;
> +		goto free_ser;
> +	}
> +
> +	/* Files on tmpfs mounts can only have F_SEAL_SEAL. */
> +	if ((ser->flags & SHMEM_LUO_FLAG_TMPFS) && ser->seals !=3D F_SEAL_SEAL)=
 {
> +		err =3D -EINVAL;
> +		goto free_ser;
> +	}
> +
>  	/* Make sure the file only has seals supported by this version. */
>  	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
>  		err =3D -EOPNOTSUPP;

[Severity: Medium]
As reported by Pratyush Yadav on v4 [1], do these validation failures leak
ser->folios and all preserved data folios?

Jumping to free_ser while args->retryable is false only calls
kho_restore_free(ser) and records a non-zero retrieve_status on the file.
When the session finishes, shmem_luo_finish() returns early because
args->retrieve_status is non-zero, so the KHO vmalloc array in ser->folios
and the ser->nr_folios preserved data folios are never restored and freed.

[1] https://lore.kernel.org/r/2vxz33sv3ef3.fsf@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123233924.3970=
932-1-dmatlack@google.com?part=3D11

