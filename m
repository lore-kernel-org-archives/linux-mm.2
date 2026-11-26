Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869A9606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahQPzA0V
Received: by kanga.kvack.org (Postfix)
	id 6E03C6B05B0; Thu, 26 Nov 2026 05:01:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7756B05B1; Thu, 26 Nov 2026 05:01:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F49B6B05B4; Thu, 26 Nov 2026 05:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B34A6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:01:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7C94C03A3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:01:43 +0000 (UTC)
X-FDA: 85476828486.14.560E5FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C6B9140004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:01:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahQPzA0V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795687302;
	b=5zobFq/WVdsn6XFAbLysuB5rFYTLxAQ1UTCGqZM0vhotDh1o7oRI0/QJovGfHyKHRuBRA5
	NkX6Rwz9wilH9sg6yro2Uhms8clG5c1LePQl+QoSBR6L9mrp3dM/zvkcvfkKWbM3PmwnHD
	WmI3kIfdG35tLnq5mFQpHDJRyNK8ok8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795687302;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnAoa+jygNNJRtGVw9eB/vx3TcCSoOnHrMLApkyb5wA=;
	b=FT/7PjocR/P0rAEOOFtk0glSGduWtrSZp5ebvVz4F1FwG375mYyD2z8r/c+MafrsMKe2ei
	0kBmSjPIF+aPWU4AnjT7M4nghdb659vWIXgmQ2xq4zzDA1pacLdF8NHIr6GxNIcrtocZ1O
	+/SV37761InzzRzS2NH/xyWLpylayRo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahQPzA0V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0548C42E6F;
	Thu, 26 Nov 2026 10:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B002E1F000ED;
	Thu, 26 Nov 2026 10:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795687300;
	bh=rnAoa+jygNNJRtGVw9eB/vx3TcCSoOnHrMLApkyb5wA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ahQPzA0VgASDYTrl1keMGPZSuE9CKjHtgXxEGOG9r6fqsO9OZcx32lK+y/NAzgr5x
	 bUNyIN0/4aeYmqKrHhgC5xL/kKBRCeYECgK3UuYX0CQ5PQNAmeWhxhHP/PfM5CY7sa
	 kSKezQDkiQimg7GqHC8ptLBIY3qybfWsohmPBkUgjcuoaiFmr5qAiKLKFggTB9f6n7
	 tjlEDQGF1m+kRiylxPAiY77daU9EpJX4u5U2hXdm0fKu8sDZ0an1WxUq4P5oA5TCmM
	 bWAP1nIcZ/oqoTzVHJwMGyHmUAzZCZoaEiQHw084QdMmYudUDNWL4PeJ/nmt5MMh6A
	 VoAlJ2pj4KeWQ==
Message-ID: <sashiko-outbox-235223@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds
 folio locks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "David Hildenbrand" <david@kernel.org>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Andrew Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>,
 =?utf-8?b?WmFjaCBPJ0tlZWZl?= <zokeefe@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Dev
 Jain" <dev.jain@arm.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Hugh
 Dickins" <hughd@google.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Rik van Riel" <riel@surriel.com>, "Song Liu" <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261125100058.15200-5-azpijr@gmail.com>
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-5-azpijr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 10:01:39 +0000
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C6B9140004
X-Stat-Signature: 5i4aw764e1dzkum7hozrfjb5utwjgau5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795687301-438572
X-HE-Meta: U2FsdGVkX1/rgEQUWHo3bZn3KED8INIweyj5fTC3Y3osUDZoImMKyL2U/ySd4g35+Vpp+sQdNhJYL53T8oKMdMY+8UnNLGqEYhYgMHIlpDco/LL09cRsiFpREtERZZDvGfDXKtzn8Y7n6vKemHIOH1NqqCxQECO422HzbkIN1PDF7Bq/SwG6aFg0MW2b6grUAc1bB9P7F6EdUJafpnP/y12SmRlJH6XSm6lc3MVvyO50chA33stuAwcd0sXFN6iq2gyNQ7z8ZJ1YxWHRcpHN2EUB+fNFEvxDCXC+e9CCDKomufdWBZksCRGkjs/Z/v/ezOG6kBylHtMTil2+zhoZ1J9O86n5Cv1ZrKGcakV/6YSgX44WELarRgrceVYXaQBdKwKTCDrzVeSiqnqw2DoIIZkg3zhVbiNoMfiA89W1H8nttajQf50S2m0TdAXeEGxNURjB8SUBFjId+GHMcM3Wq4KjDYM4w84B/tDn6iBmYYV7yxLxWDnt2weBoEje1uWuEVaceZkerijI4/bLL6uY/qigsAXYWiE+Fvv0Jt/LbyhQUq5RoBzn351QPnnFWAj1K5ZapCxpontU/V8Jn82rMKKpVwTpKd9uSwj4XcjFZUnBnPR2isDBn3xUMOINocnG7EbpscE+Smvilux+12jdH86XbzqTpIdUgm5gPoEkBU9Zwsg33X2wWFD2M5HZTnCcZ33NuSkZ+wu5LogSPSXOqFsHB6/P6rNjx22m+9qq3qp3NSeUXIrTtSkxMQwpdYc6VooBZhHBpZGgtpLzIeeQL4rGPrWs97z4xfR5HQn0NoaSK4a3yP7KWBJe/6KU8SeOIKefRCiOBUxmRGVev/Pq+exu1oJaqbg3KuMtrsQvsHnsR0+RMnbX2KyAtig/BzhdmCdkeer4ADQMAn2cEaUTJxb8C1d+JTU5+wypYRUp2ToWnLa8Dd7XvZHL5ps5EeqjWCowUsmL+Aq+AoJNXc6
 pGIL2Jpe
 t0+V22l6IAJwpW+75NsL+nsNcQi+Txq1h+FeUcZJ1CRmVJXK+XX2TYyAhBKDHumhGA79igVwUgkzrBNKOj63c1Zi3S7WX5Gf8byA4/w2o1ojkG2isFxH32tYWIOb1uvLWXcvfZ4Xm2zwoTS+5cTX0NIwuMCp9zRguW/dpL6dxWMXqHCu6aJFIy0XqdLbJRCtlzGS/7IdTyH34c7hAjIsXAsKp1M0WCZOSCJZQjqMB3/Pjon5wpTrfQBS1eNebUsvSCfi7/Q9aeSfRkIfnL92SqdLtwGfV1j5O5QUAtX9hWPTq/IXZvt3q9OG7zMahi4FYTzus5d8EE8glbhP57EUZBw2LWYlJEHe7E229uMhZUtOFk9H+yu9nHwv57pX4SUH6QOkm0g7B1kQJeIensKhAt/jEwuvIKL/D6ohh/Q0xz2iop0dpWWeVM3LqW8FQ49h7O3jWnVCg8NY/ps6Kf+Kuswf9cwjtDRmikMt23OMaWA8osU29HhnjbZd7piL8r0oLXydy0FLbDajBpkwBJEATSFAZubkpyHq+Jf6iRrrvihM/Dj8gOrSFq1OPzrvrx8AsdqK4NDoh4yOnF8C0SbQScfa/AhPuWexTtG0YZRa5CMiUrCMkwPU6XDJY1W3hjcyHRjNdxxFFHXvzFJGhw/PzVqBETF20uC68qj82MVvjE7BJUbNxtcASlRNCuH6Jju6pZ4pWhtHEZrGIXuZ+JVSOeDcY2MWi18DTqUjQpOXqC7NJitpSIz62Bk0DOjj+baYqGyTatgEKizb00BZXGQGmobWFP1o3OQk7lsLBrBZRyn1rehTU5qP13yC4LfsWUaDLPoBOPZk8dANTj4P+/Gk7q1Zrw/8hDM6KJds15Tsflg/O+3tZo7HPms8T8s4RB2oxTahFjlQ4/YN9hQVBtTRV5Xdgqg==
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
- [Medium] mm/khugepaged: filemap_release_folio() still gets __GFP_FS in
  collapse_file()
--

commit eca7ae08f59655cebfe256885070eec102a63325
Author: Jose A. Perez de Azpillaga <azpijr@gmail.com>

mm/khugepaged: use NOFS while collapse_file() holds folio locks

This commit wraps the folio-locked section of collapse_file() in a
memalloc_nofs_save() scope to avoid __GFP_FS allocations and filesystem
waits while holding folio locks.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6d2431a20bc98..c3c733d3a32b0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2302,6 +2302,7 @@ static enum scan_result collapse_file(struct mm_str=
uct *mm, unsigned long addr,
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
>  	enum scan_result result =3D SCAN_SUCCEED;
> +	unsigned int nofs_flags;
>  	int nr_none =3D 0;
>  	bool do_readahead =3D false;
>  	bool readahead_done =3D false;
> @@ -2320,6 +2321,13 @@ static enum scan_result collapse_file(struct mm_st=
ruct *mm, unsigned long addr,
>  		goto out;
>  	new_pfn =3D folio_pfn(new_folio);
> =20
> +	/*
> +	 * We allocate while holding folio locks below, when swapping in shmem
> +	 * folios and in filemap_release_folio(). Allocating with __GFP_FS
> +	 * there can deadlock in reclaim or compaction.
> +	 */
> +	nofs_flags =3D memalloc_nofs_save();

[Severity: Medium]
Does filemap_release_folio() in collapse_file() still receive __GFP_FS
despite memalloc_nofs_save()?

collapse_file() passes a literal GFP_KERNEL to
filemap_release_folio(folio, GFP_KERNEL), and filemap_release_folio()
forwards that mask unmodified to mapping->a_ops->release_folio(folio, gfp)
without applying current_gfp_context():

fs/netfs/misc.c:netfs_release_folio() {
	if (unlikely(folio_test_private_2(folio))) { /* [DEPRECATED] */
		if (current_is_kswapd() || !(gfp & __GFP_FS))
			return false;
		folio_wait_private_2(folio);
	}
	return fscache_release_folio(folio, gfp);
}

Callbacks such as netfs_release_folio() and nfs_fscache_release_folio()
test gfp & __GFP_FS directly, so they will still see __GFP_FS set and wait
in folio_wait_private_2() while collapse_file() holds folio locks.
Compare with __folio_freeze_split_file(), which passes
current_gfp_context() (or GFP_NOFS) to filemap_release_folio().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125100058.1520=
0-1-azpijr@gmail.com?part=3D4

