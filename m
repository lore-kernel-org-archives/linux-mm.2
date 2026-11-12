Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E37606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9ljRIUP
Received: by kanga.kvack.org (Postfix)
	id 19DD86B05B8; Wed, 11 Nov 2026 19:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127266B05B9; Wed, 11 Nov 2026 19:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064C36B05BA; Wed, 11 Nov 2026 19:31:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC5C86B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 696451C3C90
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:19 +0000 (UTC)
X-FDA: 85424587878.05.A2F7C87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE66812000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9ljRIUP;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443478;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AocDLMBbpZNZ5sJAdcXv8oijHd5rXik7WltaX6p9uk0=;
	b=mCU+60kt5V9Dub1r8rLF15sbey8EQLXN4B+2rbwD1bsFTJUKykU7MdhTQClMBq4/v/Qq/P
	sdcedb7swEFZsW2qvdn5ZmTtE3hr4xQlNTFdDse7Pl863tj86lFEGidj64Ij80WaDJdOw4
	P9W2tG4cviFmAsm7rjRI//WNT25K6uA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443478;
	b=wPPyF9GPLacoSf+4O2hGN9gdw1M3y26bKJxqqYwMPJoo8wZDmsLk3DhyXpR5G58tdxBBxB
	24pDgDk9HLjSjQ7b5W5tEY/anamtGfbK9s7BvYha1cbgw4tG8e/9wsFS9w3zjlHdM+tl8h
	2B97JV8sgCXTlRQWl5to/KRn8FVE6mA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9ljRIUP;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E92740415;
	Thu, 12 Nov 2026 00:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1352F1F00A06;
	Thu, 12 Nov 2026 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443477;
	bh=AocDLMBbpZNZ5sJAdcXv8oijHd5rXik7WltaX6p9uk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q9ljRIUPjChz5ZGTorTsDpLvyGckMV2DlshZHj8md3qzN6r2NwbFI1JlQHFCQmpGk
	 jhTq98y0IrpAJIwlbI/J2ta5GMnFABF7G6lYU3Ob2Z7Lf83NIOU1Y64NTYGlbgH3WC
	 l/DkLq2Dm9J5dYU8Hliz+B/yh/QDRP8pKLoOAC0HMYcipyD/Q2fDu7xJ1t8i3/ITUD
	 v84aPOIO7yLxvTgT5vbkiW2ZgngLHgr6NJnVS/K1FJngVUCad+o99E/qsUvf9ZW0HI
	 tqQvJ9ISc18SpG9Od78orZ19ie5u0WPg5yRwKjXlZweV/1ShAy3lq+Aum2H3ulVnj/
	 x5IuMaVPpGUaA==
Message-ID: <sashiko-outbox-209941@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/19] mm/shmem_luo: Leave freeing the preserved
 state to finish()
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
In-Reply-To: <20261111002358.1842967-10-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-10-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:15 +0000
X-Stat-Signature: 7yzg6qdg7gkiceq8tccyobce7xsz8sw4
X-Rspamd-Queue-Id: CE66812000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794443477-551540
X-HE-Meta: U2FsdGVkX19XxM/YxrNBC42Khs2MWPhLTb/5kOMxpe3VZWymAeaegVnPwpUVsNRrwIlMM0VQGMcZAUigIjcQ60VdiUQu4r9WFUjgRuGx2joWWEU/Mk7v6ZkEPQhpIFKvWwymnAS4/zLb2/olK+xzik7al839tew2GpvGlNZwebJIxU8ZGB6P9r1CRQpjorwnQBS/U5olsa+tS3PyGiO/CITi3lyiCD2GsZaKMS2GFw2S2/GW2qO3rHjG0Abgkcn/NvG647Axd6PCaa10TX8AYZMXIlp9lSweMCtH53dcUubXIDTLb2sLv/bH5Hu7NYywVuzARYG8RboFddKRifAIc0mqhIkcle9r0Gz5y+3jomjijH/zKkOOtkcLoGrxA86YNWO04zwZaVA5MFwT+5rpRZMAjETTSW2yOrYW20tT+8wXY1NkmniWz2/zO3H0XHrXAdvFDUANbHzI1a/rNJoZhRSgCTQymSMT/PMsKbPM4YgF8Hinn+ScxeH2hLboCjjndjOeAcJtB1cNQH4NvaI31l1Ygv6YdRq0sDrxKvOMD/OrpuoRT9P37htz6xw8YjN9ZGdLDjSKRJERNkpC+t47ucVSm7uTDBcK9MLiL2IzekG9lAPjJ+HUehyqOO9aFbrE4TOg9bScAO24cOt27pXu8DtIyYxmA7Kwfu3vj6QVd5JUu3ASjuH4XN+aJVYDAO9HPKu+VfuEdABQCXgEsca4hg8lNVXlF82jfn7KwBVMHvlAuBHiaEAXGq/mNOQO1gS6NF/elr2qr/umo6cPwKB2iRo23B/TC/D4f+e3OqBFCfagdBgFwwICCw1Xd6mZSJK1P5H/aKS0BZzyFR2h6IBroJ7qxllncayEBQNH2TYtEUMfsUz9cGBVmeIabHrIPUo5b3Jgk/StEQKICIxuvWc1qoXRyuDv1Ce6SV2S04KKbdUoVB4SYyuH2X5kuIp+Sjc2VITo3Ll0B2uJ78s0pFu
 f9UBSiQn
 yoqceh/zXyhqZE9/t4IKr90VDxKdrgeh1unN2vGnTiV0UfmymarB7zDIj7XEN/aM60RE3f6EDOWmx99R5r3cWLqmGfZViTKrGjDvwf/EQY6EXiP+HA6ci8uoCMfgTma/Jwaa8GRntSfeottUqm0OrG63chpST8gu6wRnNEb4FsxnVdHoEDNPY5T9bTaAXGzh4n211ypVKq2nj81KBTMlIPykBospkKR55GrCAOURXKTHKFMHrUcjiTU5INCCxcqZy05o/k61n6wjWfE3X8BhNTf0jKw2eM0ch6vS7dwc9emrpVhJHblHItkJEgU239whLTpggI6rkJIsZLA5Vd4ZGjuVBtHtmIp696a8GplbbAk5XmkEDqeIAVdmlxW1YzBIi5Qfizml/TGimTMsqxwHZQLaHioRRsDsWsUZR+m3x50sDxYxwFSXG7hvuHpw9Rbn24ko3Bsl+WUtrEpsdrGdrg9z4SLRxDS9o2uE7E0He9vSMNNaJ3fWOSAnfn3kr45zS2ECv0OUWnkARQ5X68TgaD9JOprlK+BBED9Oxf+K8rUmeLQ4XKUSCmfprOY2e/3HXrG9LcvlcaCbK9WBCU/g+oDrQq5JdDR3Le4fI4k7ovgbMqiVqW4dpwvb3hHmLCbsRd7Si4Y63eY44e1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/shmem_luo: preserved folios freed before finish() if
  retrieve_folios() fails
--

commit 07031901f696f6bb10658c21e386ae0237da0633
Author: David Matlack <dmatlack@google.com>

mm/shmem_luo: Leave freeing the preserved state to finish()

This commit defers freeing the serialized shmem state from
shmem_luo_retrieve() to shmem_luo_finish() so that preserved folios are not
leaked or freed prematurely when retrieve fails.

> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index e747a04422954..b48d7f460493d 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
> @@ -390,13 +390,10 @@ static void shmem_luo_finish(struct liveupdate_file=
_op_args *args)
>  	struct shmem_luo_ser *ser;
> =20
>  	/*
> -	 * If retrieve was successful, nothing to do. If it failed, retrieve()
> -	 * already cleaned up everything it could. So nothing to do there
> -	 * either. Only need to clean up when retrieve was not called.
> +	 * Preserved folios may be in use until the session is finished, so
> +	 * retrieve() leaves freeing the preserved state to finish(), whether it
> +	 * succeeds or not.
>  	 */
> -	if (args->retrieve_status)
> -		return;
> -
>  	ser =3D phys_to_virt(args->serialized_data);
>  	if (!ser)
>  		return;
> @@ -515,9 +512,34 @@ static int shmem_luo_retrieve_folios(struct file *fi=
le,
>  	return err;
>  }
> =20
> -static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
> +/*
> + * Restore the preserved folios into @file. This consumes them even if i=
t fails,
> + * since they are then either in @file or freed, so make sure finish() d=
oesn't
> + * free them again.
> + */
> +static int shmem_luo_restore_folios(struct file *file,
> +				    struct shmem_luo_ser *ser)
>  {
>  	struct shmem_luo_folio_ser *folios_ser;
> +	u64 nr_folios =3D ser->nr_folios;
> +	int err;
> +
> +	if (!nr_folios)
> +		return 0;
> +
> +	ser->nr_folios =3D 0;
> +
> +	folios_ser =3D kho_restore_vmalloc(&ser->folios);
> +	if (!folios_ser)
> +		return -EINVAL;
> +
> +	err =3D shmem_luo_retrieve_folios(file, folios_ser, nr_folios);
> +	vfree(folios_ser);
> +	return err;
> +}

[ ... ]

> @@ -552,28 +571,15 @@ static int shmem_luo_retrieve(struct liveupdate_fil=
e_op_args *args)
>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
>  	i_size_write(file_inode(file), ser->size);
> =20
> -	if (ser->nr_folios) {
> -		folios_ser =3D kho_restore_vmalloc(&ser->folios);
> -		if (!folios_ser) {
> -			err =3D -EINVAL;
> -			goto put_file;
> -		}
> -
> -		err =3D shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
> -		vfree(folios_ser);
> -		if (err)
> -			goto put_file;
> -	}
> +	err =3D shmem_luo_restore_folios(file, ser);
> +	if (err)
> +		goto put_file;
> =20
>  	args->file =3D file;
> -	kho_restore_free(ser);
> -
>  	return 0;
> =20
>  put_file:
>  	fput(file);
> -free_ser:
> -	kho_restore_free(ser);
>  	return err;
>  }

[Severity: Medium]
Does shmem_luo_retrieve() still free all preserved folios before
shmem_luo_finish() if shmem_luo_retrieve_folios() fails?

When shmem_luo_retrieve_folios() fails mid-loop (for example, if
mem_cgroup_charge() fails), its error path restores and puts the remaining
folios, and the jump to put_file in shmem_luo_retrieve() calls fput(file),
which evicts the inode and frees the folios already added to the page cache:

mm/shmem_luo.c:shmem_luo_retrieve_folios() {
	...
unlock_folio:
	folio_unlock(folio);
	folio_put(folio);
put_folios:
	...
	for (long j =3D i + 1; j < nr_folios; j++) {
		...
		folio =3D kho_restore_folio(phys);
		if (folio)
			folio_put(folio);
	}
}

If a preserved device still holds DMA mappings to those folios until the
session finishes, freeing them during retrieve() allows the pages to be
reallocated while still in use.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D9

