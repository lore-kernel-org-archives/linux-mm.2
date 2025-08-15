Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B476CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 05:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D426C6B0098; Fri, 15 Aug 2025 01:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2C78E0002; Fri, 15 Aug 2025 01:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1606B00D5; Fri, 15 Aug 2025 01:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA0066B0098
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:41:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E30B83914
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:41:11 +0000 (UTC)
X-FDA: 83777893542.21.B959E85
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6448240002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:41:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f7IU03oe;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755236469; a=rsa-sha256;
	cv=none;
	b=0a7WQoJSmA26HQwU9fPaY3wPh08Yn43njVBNnKy2aJqrm3MUfwFvsHExX+ZXtHS/V8EwI6
	dqJrhnAzX9SnuFTwuTEuEqh02RHNZ8aP5HRi4rW8NwZeg5kgvdpfX6dVAxZl5ZVsezg2sK
	89Bddll8P0LgQlKov5wTKBALVvOEaOI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f7IU03oe;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755236469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbuDpmDlRwawJfHizwn4EMvbt2H+xgfAoq4Tssq0RnM=;
	b=7QNwmghXyVaeyE+W90ivvJEG+/A4yCszKX3VXk/+iuUYqsdMP1+OjxHPYXuOn/KT4LaupB
	csJRRQ6kiN9kZPapjea7qEAgiWl/nu7mI8DHaJXtyQmhKrv9gfvNQ8yR4BvKxzVohdLgZo
	MTH1QF7klVTJwlDK07MJHzT2vHHb9Qs=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e2ea94c7dso2183269b3a.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755236468; x=1755841268; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbuDpmDlRwawJfHizwn4EMvbt2H+xgfAoq4Tssq0RnM=;
        b=f7IU03oeufh1KwXFys6GCyl2NtSSsJn0TwG30gYPwODrQavgWZY5gINJJ0V3WQFf91
         QSkoq26+HMp0g4uZwtRI0njxlahWVhACQivrk/d7JiNa1j5y2WI2PaMYKXtsS2zg43w5
         2gz0/G7v5srYJQdNlYHdTkPNwsIVFtE6/jUJrQBILOWGt5RqSzm4PV87NJPjOsPI2Kmo
         JiLOiwotKDQa12LOI/DkF1p5XY+oJRLDSYuEPTYsnfWX1F9KnvqdUV78LCWbU/jaoQsN
         RE1c65yG2BT9GZ3z/9PhRJFrnnIhCp+WzuVYriTuvINSqddtrqxWS5ckttXbp+VMVoZq
         Ml7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755236468; x=1755841268;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NbuDpmDlRwawJfHizwn4EMvbt2H+xgfAoq4Tssq0RnM=;
        b=rE2gpdoG4w8WxOllNFkAqOgfCJQ9fGNNvsglWK4i5yPpOeXYngQ/tOULxDKruCSCir
         dH0nDdl9yWdPLa747i/2h7D+tttrhPJRxVqqlxHyrJ+ioWsbVSIVC/NBerTfC0+40zXW
         gvYEL07TBAMgzRkU5vXCX4yqN3g9x0FDLyctbu7/7EPoH8w39Qm6yaWH4EcsIp9J1AKn
         N4VOmUcTFvFZV/QC5Pq+0P3yTRJ7YKwjoE6fk+j1dBzOBVRpcudI3iIAF7VBPE3D+jvD
         Opel47XmZy5lJLU54aqbWdtavvo8pSdDKNxlyHfM4oe7jLUhgD3Cs09ThtQJ/9bsC30h
         938A==
X-Forwarded-Encrypted: i=1; AJvYcCWMKK202n2jQEI9sF7g7lMsiZswe2RrRERBxWoHkZVEALJP8x2Z35XafC1erqVsj/eS6xeq0Rz2UQ==@kvack.org
X-Gm-Message-State: AOJu0YwiAiBuzlA1w+uL0LdYmtHN4zbFsKnZEBqpyjxGzho+RPF+mf3I
	yOsVKRdXrvMw+//DsczqS4oeUkOyjui7OHJoo+niKVBn5HjCB66hBVeY
X-Gm-Gg: ASbGncsbtObEJOoyHcgC3LWQgQRAZN1NR11rkFUy7QX2IGP/+Ujd4Yhbfe0Jkm16QN3
	UNsdkFGmfhJx+Lm246UApgWDiQMGlrR/2DKPsuKHKeflJu29lG9WktUIxtcrb5aZHD2rXWx558e
	OoSYtolg7U3FZB45BzQ3oFyz3saITO/Con5tfHJkbKk2yiB+B78aA6x8JS7huX/3AEMkAnmv+C3
	JMItLYh/Jn3vXCUhGUliOdjU5omLx50y0y8zOt08L2o/ce+ENeSu0MUoGnJxYE6biZi0flCQ8qE
	7tl229GOTE0PhcrPfpSJ4DS2Z2U9yB446FZg/ym3pa38R2zfHXgyHn4mhuGR1hJYd8IjddorJ6q
	iKib7cPvfC33dIT3Nn3I2AQ==
X-Google-Smtp-Source: AGHT+IHPpbIWqcEPokwcYKxWUlJTP6UzgHy5feo84j1Dprh/U/xmK/5dUpcts6GO1JbUegQlIWNuyA==
X-Received: by 2002:a17:902:cecd:b0:240:14f9:cf13 with SMTP id d9443c01a7336-2446d9ffb3dmr13478895ad.51.1755236468078;
        Thu, 14 Aug 2025 22:41:08 -0700 (PDT)
Received: from smtpclient.apple ([2402:1f00:8001:567::104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d50f2d4sm5895565ad.102.2025.08.14.22.41.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Aug 2025 22:41:07 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v4 3/5] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
From: wang lian <lianux.mm@gmail.com>
In-Reply-To: <20250815023915.1394655-4-ziy@nvidia.com>
Date: Fri, 15 Aug 2025 13:40:47 +0800
Cc: Wei Yang <richard.weiyang@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 wang lian <lianux.mm@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <89F0947A-3956-4D10-B78A-2AA426B8BEE1@gmail.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-4-ziy@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6448240002
X-Stat-Signature: 1b8hx7srgtggwczm5utwcq33no138ncq
X-Rspam-User: 
X-HE-Tag: 1755236469-365460
X-HE-Meta: U2FsdGVkX1/sVLGefRSlj6asKgQxP/1sAKCs4DasZpZ0m36zW+6uedBM3lIaAs2M93vVcTO5JO+MWCmWygyI0dqDYrENMcugbMgfgBmSMslzEycvT4u3yaVpYjX9VCrDePPgbkMm09pPpzqE/TQzNQ4hZvOp3AjhSssHgms66tF1WPInzHt7rnLzQtmkY9IvkKz1cWshFgNKI8qovh38t3FXdf0or9VUxRE242HQ3uFs/ZBWmlaAOMUj9XQiUBOrnaKyQrIWiP9daGm4Dz6fdssZPprwJ2o2XEyhGVszoFeUtxM8+4fqcdSTwDO5+lAMh9KVDuY31h7WL4Rm/IygBZfxLcE/ix1D1HIf8Hb5FUnmtlW+7F5XpADymgdChTJecSb2sWpb66IRD4Tqn1+7rX528qf1pjCtirK45qYQppWQKiPDS9H4xS4hRIIlQ3/NZbkQtmb8kSxoI2BA7FQxNsyArfeU3W9tRqexU06OZ1xGgb3t+DXsnQtMzlFw/7JegtAZp7Z0DRuxI27a6Xb5nGnK/JLTpyPs7uJVWjU0G+nF2s1k7xplXpFOvGDc1jyx9fKmLzlRU9j6OA0axlh+SqFXMJLK4RDeMyWRVFaXrMBluSdHdE8XXcWR2iPGkW0D9+UnXijl+g2ARyGjpU5K73U364RkhqDtC0ncdAVjJw9YPmaN9xcNCKtehko96ikcy8+Q0o50fOemahmgXQBYX1109S5U3REzBL+M310U8v/E3qojnVQLOymnbAEK4KBOxlCWUiWUIzM10GV0VtN//dj3YSU9Db+H8pe3kyJi+uJNdDNbJiND88GKoLR8QDo9bOit6lm1VYnuOy8n8+0sgykWHpe662VrrcxAG8n9EO5lxuLfau/W4yRqkkDbypunYmlp66WiK1NNVjViHqlF/T4ec2S69dVEKSHDxfmzqt3aM8kSYOSexPK0smUv/37belgZV7AZ4WFdsOD3P56
 FSASA3En
 amD0w4Y38p6AnzSFllXrtbD9CUt2NRFZOYH0b+Y2NDoEcAMnbUgDITAblUKSqaxvfkxJ89k+kjZHlRt1HszDeVA9PliwlWaX7devGaA4QqwnMH5wRJY5jjTQnNO0qxlMAfSk98fcVa4ENBLhmX21yCqQj3PuSdlgSfOl4B7yik5nw0ET8KE9Bv23JMZkLr7vnXAUabiaSbyA6cP4gMO5zJ1ITTx4dOn44XuZ9JHlkGYViihu4L7TfzZZOz2hPruJ9LbuvFawFG/RI8KMoRXo3cHIAvofQBF1Fm0PqaHtdYMpySfFMBuwTgHT2QggvsCtgbAvSaGGyP58hIt7vF/wU8zUVyhske2NDJiNyQdFZS/YcgxN/H2LRtgjSsB3y0hw4mchKGVedLc7p5bVbRhlQXeavatzb9UnJ5WJ7w+6xPvu8vMcS9Cs3ScBWk51DKlsMW4HhZGap0WxUENRqNQcGovxog2TyhstVEmwXdXZKYCyyAouPQkrodEQ5urbEEpRYykVIFmSZXEjq9dow52PayBf93EzCHz7hp3UpMg5hMs2X2D1Rgo8a9kE0uT7bFSIxdPtDBlb7YBt8axBDrjzdtKLgUEcPBKOw8LaPLI8NRhSnNNVNVSg5hIQpVX3jSHVhcK0Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 15, 2025, at 10:39, Zi Yan <ziy@nvidia.com> wrote:
>=20
> and rename it to is_backed_by_folio().
>=20
> is_backed_by_folio() checks if the given vaddr is backed a folio with
> a given order. It does so by:
> 1. getting the pfn of the vaddr;
> 2. checking kpageflags of the pfn;
>=20
> if order is greater than 0:
> 3. checking kpageflags of the head pfn;
> 4. checking kpageflags of all tail pfns.
>=20
> pmd_order is added to split_huge_page_test.c and replaces max_order.
>=20
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> .../selftests/mm/split_huge_page_test.c       | 90 ++++++++++++++-----
> tools/testing/selftests/mm/vm_util.c          | 13 +++
> tools/testing/selftests/mm/vm_util.h          |  4 +
> 3 files changed, 84 insertions(+), 23 deletions(-)
>=20
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c =
b/tools/testing/selftests/mm/split_huge_page_test.c
> index 89d3dc08fe4c..80f718ca21c7 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -25,6 +25,7 @@
> uint64_t pagesize;
> unsigned int pageshift;
> uint64_t pmd_pagesize;
> +unsigned int pmd_order;
>=20
> #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
> #define SMAP_PATH "/proc/self/smaps"
> @@ -34,27 +35,71 @@ uint64_t pmd_pagesize;
> #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
> #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>=20
> -#define PFN_MASK     ((1UL<<55)-1)
> -#define KPF_THP      (1UL<<22)
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>=20
> -static int is_backed_by_thp(char *vaddr, int pagemap_file, int =
kpageflags_file)
> +static int is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> +		int kpageflags_fd)
> {
> -	uint64_t paddr;
> -	uint64_t page_flags;
> +	unsigned long pfn_head;
> +	uint64_t pfn_flags;
> +	unsigned long pfn;
> +	unsigned long i;
>=20
> -	if (pagemap_file) {
> -		pread(pagemap_file, &paddr, sizeof(paddr),
> -			((long)vaddr >> pageshift) * sizeof(paddr));
> +	if (pagemap_fd =3D=3D -1 || kpageflags_fd =3D=3D -1)
> +		goto fail;
>=20
> -		if (kpageflags_file) {
> -			pread(kpageflags_file, &page_flags, =
sizeof(page_flags),
> -				(paddr & PFN_MASK) * =
sizeof(page_flags));
> +	pfn =3D pagemap_get_pfn(pagemap_fd, vaddr);
>=20
> -			return !!(page_flags & KPF_THP);
> -		}
> +	/* non present page */
> +	if (pfn =3D=3D -1UL)
> +		return 0;
> +
> +	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
> +		goto fail;
> +
> +	/* check for order-0 pages */
> +	if (!order) {
> +		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | =
KPF_COMPOUND_TAIL))
> +			return 0;
> +		return 1;
> 	}
> -	return 0;
> +
> +	/* non THP folio */
> +	if (!(pfn_flags & KPF_THP))
> +		return 0;
> +
> +	pfn_head =3D pfn & ~((1 << order) - 1);
> +
> +	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
> +		goto fail;
> +
> +	/* head PFN has no compound_head flag set */
> +	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
> +		return 0;
> +
> +	/* check all tail PFN flags */
> +	for (i =3D 1; i < 1UL << order; i++) {
> +		if (get_pfn_flags(pfn_head + i, kpageflags_fd, =
&pfn_flags))
> +			goto fail;
> +		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
> +			return 0;
> +	}
> +
> +	/*
> +	 * check the PFN after this folio, but if its flags cannot be =
obtained,
> +	 * assume this folio has the expected order
> +	 */
> +	if (get_pfn_flags(pfn_head + (1UL << order), kpageflags_fd, =
&pfn_flags))
> +		return 1;
> +
> +	/* this folio is bigger than the given order */
> +	if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
> +		return 0;
> +
> +	return 1;
> +fail:
> +	ksft_exit_fail_msg("Failed to get folio info\n");
> +	return -1;
> }
>=20
> static void write_file(const char *path, const char *buf, size_t =
buflen)
> @@ -235,7 +280,7 @@ static void split_pte_mapped_thp(void)
> 	thp_size =3D 0;
> 	for (i =3D 0; i < pagesize * 4; i++)
> 		if (i % pagesize =3D=3D 0 &&
> -		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, =
kpageflags_fd))
> +		    is_backed_by_folio(&pte_mapped[i], pmd_order, =
pagemap_fd, kpageflags_fd) =3D=3D 1)
> 			thp_size++;
>=20
> 	if (thp_size !=3D 4)
> @@ -252,7 +297,7 @@ static void split_pte_mapped_thp(void)
> 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>=20
> 		if (i % pagesize =3D=3D 0 &&
> -		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, =
kpageflags_fd))
> +		    is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, =
kpageflags_fd) =3D=3D 0)
> 			thp_size++;
> 	}
>=20
> @@ -524,7 +569,6 @@ int main(int argc, char **argv)
> 	const char *fs_loc;
> 	bool created_tmp;
> 	int offset;
> -	unsigned int max_order;
> 	unsigned int nr_pages;
> 	unsigned int tests;
>=20
> @@ -545,28 +589,28 @@ int main(int argc, char **argv)
> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>=20
> 	nr_pages =3D pmd_pagesize / pagesize;
> -	max_order =3D GET_ORDER(nr_pages);
> -	tests =3D 2 + (max_order - 1) + (2 * max_order) + (max_order - =
1) * 4 + 2;
> +	pmd_order =3D GET_ORDER(nr_pages);
> +	tests =3D 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - =
1) * 4 + 2;
> 	ksft_set_plan(tests);
>=20
> 	fd_size =3D 2 * pmd_pagesize;
>=20
> 	split_pmd_zero_pages();
>=20
> -	for (i =3D 0; i < max_order; i++)
> +	for (i =3D 0; i < pmd_order; i++)
> 		if (i !=3D 1)
> 			split_pmd_thp_to_order(i);
>=20
> 	split_pte_mapped_thp();
> -	for (i =3D 0; i < max_order; i++)
> +	for (i =3D 0; i < pmd_order; i++)
> 		split_file_backed_thp(i);
>=20
> 	created_tmp =3D prepare_thp_fs(optional_xfs_path, =
fs_loc_template,
> 			&fs_loc);
> -	for (i =3D max_order - 1; i >=3D 0; i--)
> +	for (i =3D pmd_order - 1; i >=3D 0; i--)
> 		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, =
-1);
>=20
> -	for (i =3D 0; i < max_order; i++)
> +	for (i =3D 0; i < pmd_order; i++)
> 		for (offset =3D 0;
> 		     offset < nr_pages;
> 		     offset +=3D MAX(nr_pages / 4, 1 << i))
> diff --git a/tools/testing/selftests/mm/vm_util.c =
b/tools/testing/selftests/mm/vm_util.c
> index 6a239aa413e2..18b7cb51fc56 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -338,6 +338,19 @@ int detect_hugetlb_page_sizes(size_t sizes[], int =
max)
> 	return count;
> }
>=20
> +int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t =
*flags)
> +{
> +	size_t count;
> +
> +	count =3D pread(kpageflags_fd, flags, sizeof(*flags),
> +		      pfn * sizeof(*flags));
> +
> +	if (count !=3D sizeof(*flags))
> +		return -1;
> +
> +	return 0;
> +}
> +
> /* If `ioctls' non-NULL, the allowed ioctls will be returned into the =
var */
> int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
> 			      bool miss, bool wp, bool minor, uint64_t =
*ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h =
b/tools/testing/selftests/mm/vm_util.h
> index 1843ad48d32b..03481ca0a1b4 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,9 @@
> #define PM_SWAP                       BIT_ULL(62)
> #define PM_PRESENT                    BIT_ULL(63)
>=20
> +#define KPF_COMPOUND_HEAD             BIT_ULL(15)
> +#define KPF_COMPOUND_TAIL             BIT_ULL(16)
> +#define KPF_THP                       BIT_ULL(22)
> /*
>  * Ignore the checkpatch warning, we must read from x but don't want =
to do
>  * anything with it in order to trigger a read page fault. We =
therefore must use
> @@ -85,6 +88,7 @@ bool check_huge_shmem(void *addr, int nr_hpages, =
uint64_t hpage_size);
> int64_t allocate_transhuge(void *ptr, int pagemap_fd);
> unsigned long default_huge_page_size(void);
> int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t =
*flags);
>=20
> int uffd_register(int uffd, void *addr, uint64_t len,
> 		  bool miss, bool wp, bool minor);
> --=20
> 2.50.1

LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian


