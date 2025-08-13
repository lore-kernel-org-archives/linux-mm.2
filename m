Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA6DCA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B76E8E01A3; Tue, 12 Aug 2025 23:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F8B8E019E; Tue, 12 Aug 2025 23:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5338E01A3; Tue, 12 Aug 2025 23:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5BB8E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:39:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B68FC1DA6DE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:39:03 +0000 (UTC)
X-FDA: 83770328166.23.A213892
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0567D80004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:39:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j+jlg4wf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755056342; a=rsa-sha256;
	cv=none;
	b=EODkJcYx2KmKirkSp9jWV8H5a+rGil4yax9vv/j+TgSYfUpsM9CNC5Z9kF+6mHec6ZA3Io
	kZOMJyPWeXcRhcGhfp7xpjaMgB/Kn3JVbfZqKwnkBtQPJWZlxUk7IWvZhjZr877wQIinQR
	yaNyldKNvcpoNp6//F70tGvgVA3b3j4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j+jlg4wf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755056342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCJ0ekjMXCLsQnoxZAx/o6xP0CM/0nYtYHB6pNmyNBg=;
	b=a2sdbTHXPCxE7JxHbgthPRaZRKzOnUy/083CFlk0ZvwykNA5LqhEEnlrmK+JYC7tb63gHZ
	OSj52WASYs5yk5ZWFyVUJJpwJp3XNmgTY39dvAa2RkRo6OJBH/XK0xT3BUedE7cOJmlfiJ
	tjlCAPwLbtRm9wWmYAGAvwirfnpKPrs=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bde897110so5172591b3a.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755056341; x=1755661141; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fCJ0ekjMXCLsQnoxZAx/o6xP0CM/0nYtYHB6pNmyNBg=;
        b=j+jlg4wfNJVUJaFKx+Dajy+QflIPBTyy84aUmIqEvW33SPPNQJGvZGDaX2QIepAbAN
         Osp16TS9z99D292KjL2FZqZBLN/pbFMbKJ9Jrv7xYNNSa31cgII/1GaphsMHxiw38mws
         PF5xyZg4BePN90953r/c339IdPR7GNixwoKqykiDwcjJZ9vmgx4ieUCrmKzAvQS5cgla
         W77msbwEAcLN2tnJF3W/K3O3TiAb70K6sA0a300+WvY5aMSY37rPc1iaQp70F0IJFrKV
         oNbiF5lXVIEZz8FirjRyZm9Aj4TOvTHnoE3zDcfthW6zM0g/8IF7tzLBq9i97LFJtqJy
         B2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755056341; x=1755661141;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCJ0ekjMXCLsQnoxZAx/o6xP0CM/0nYtYHB6pNmyNBg=;
        b=YBLmdpUucj1R5kExQsA7gLTMpDFYxy8xw0Q7iBCQCY8mOXXKoDlFFOLeOqfL7pPpGq
         k5jpYSLbvHzB/sdn2PKSLob7NsvYCtUt3td9rV++ouEe/43RCREwvsFiNENscmHoFtQN
         j1w6t9bjIq/BWzV3ncazlO4sdC2EpvT/GrkOSsQc+YKcoiF0nPx9k+NTJGWmJN1oAlLN
         6QgPrbSImML3cISzrhL++8G58hFBiWYO/6KsoKhp2TPyLwYqfKRIX0qsQvWsyzfeRuLu
         L2u5oJ4JhVELfmyuavsP7VVBXlhXdZn625p6rxqiSbhWUVBhTItfgFkxkWhXUwuC9Lxo
         wQHw==
X-Forwarded-Encrypted: i=1; AJvYcCWvMB76wafYm/PZm+SBQWZ6TSOgX9un/p8iFn26BpC3G0V4CmJkoKdA/52KtZa+vO080aRkOeOqeg==@kvack.org
X-Gm-Message-State: AOJu0YzxXg34VHZMCimE2gAMkqM+KP63rPUILVMbh6V2qgHoS82msnpn
	1QHsp9Z3GCR8yn4px7ncGPFPCUlxPMO8H05/h25jk4Dpcc9NUR3Zw6Nn
X-Gm-Gg: ASbGncsBmVGHiZnuA/i7MblApaLlEwUJvrFfO1dCW4CoDtDMOZHmVh9YSKLOUNEO3fM
	hDneu2qSyISo6D1B1B6mGygYr8I3aby5WXlZVNQe/cdUVKHdlrY+ZhuAzb2ab2a7DJId9i7cV8E
	IPzMI/sXXbov56A8b2J4c1Z17Z9mE+SctzbpP9WI+0sXLkqsnQNeuZ/fS3Sa4Klf2T+LhtX1l5X
	UNznmOE5S9Wi/9l+JZA5DtwPvBIFy+5i38oAu8RBDMB2PGJfRlyT21yeEPUtVTWQGhSntnxnWdq
	lc7/zlXujqNLTfKHoA8oy7rYpEZqHHyQrqxNQBV6plDM8Z66nbkGhICqPu9ylq5MCqx2ViVdNUZ
	EF2iP6OpUqMM=
X-Google-Smtp-Source: AGHT+IEuhcHnMiqztTP7e90KUgTjM2DrehBTpSubQVMDvpMAdraKkDPvVOdfVi592vigrsuTLzx9aw==
X-Received: by 2002:a05:6a20:7493:b0:231:6ba:881c with SMTP id adf61e73a8af0-240a8a5defamr2480043637.6.1755056340718;
        Tue, 12 Aug 2025 20:39:00 -0700 (PDT)
Received: from smtpclient.apple ([2402:1f00:8001:567::104])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c3f85c720sm13483222b3a.27.2025.08.12.20.38.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Aug 2025 20:39:00 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v3 2/4] selftests/mm: add check_folio_orders() helper.
From: wang lian <lianux.mm@gmail.com>
In-Reply-To: <20250812155512.926011-3-ziy@nvidia.com>
Date: Wed, 13 Aug 2025 11:38:40 +0800
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
 linux-kselftest@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DB5B4E8A-3CE9-4F15-A52F-BA75E9BDA4FF@gmail.com>
References: <20250812155512.926011-1-ziy@nvidia.com>
 <20250812155512.926011-3-ziy@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Stat-Signature: 6etxgpt6eifs5u7ctsaduo1jayu1ebx7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0567D80004
X-Rspamd-Server: rspam02
X-HE-Tag: 1755056341-901706
X-HE-Meta: U2FsdGVkX1/X4yWJtQih5gIXeRGAYs78YszNuLJ7GaC3k8Cb6QUXL3y8XH226FkGSZkFbxsEr3FnXEGK5wIydz/OczBy70NcojQPAw96w57Zj8ydbA0HXvcBOcTDC4dbfZ6s+99Jla9GTVDdYYJz2QyGN8r0qiSxcsk322sh18N8eBQozJK3fS18+pNZIDq2gjRtR5c3r84Hdv3iqrp8O6DDfBdY06ltfNisp6JBcAFrGiAapn47HypHz8M8T+nomOyoEvXX7j5QgJcLGEkuKE6sEzFyWMQmiJzZHa2VZXqTZizBX1gBVAXGAbNHPjz984ybZTYF7VLT6vfWKOFa/5vyid39l77zm8l47QWeZOzyJKT4DXBPHtSHxVK5nwXbYfWPchkpv4TMWo065wqBvicwOCDVTskVr2bR9b8pS6IifmYcKTLCsb0r3wW794av+y8IQBSkBBM80JelG2qEAJ9C/qYSytFTpVDuujzK0TE4oCtbnvUX6v5152mpDhfFC0oC0Rk9IQ6S1DmrwQZRDv//61qgsjHQmGSXeeJP54TYI6gWOctVuyq/jBBNyIt35l5MHc9Kb+KxrhYev+xaOw3D1mWSrM2kYrnzWv/L8vpB0LRBCurkAq9SC86BxY/YlfrojjXC5jWwSGFfqSwFftYfIHuk1+Q/r5BdwemsbpPjuk79m+j7iF7q4OTwiXhyfyBklIDQRSZgvX5PGfGULQfPXY4C8DchnZRmbzylRMQlcyyyASFB6apM3lUQNb/ptaKwQOzf840R8uIQhQyaTIAYMH2vt6ShoaFe7qPvOiF/OyRq5/GORhjvKTtS8k5MsN53P7OrviSWkCDogBms3pEXuRKtpSJNTjRMNlnkCu4t5+Je0+nhD7p4Pt4pCBziufWgQYoPkn1g/+ssmJDVa+79Ihv9TJO/r/LBW9O9pRMm5euBv1JH3BZEnpfNDCHgl0uAzOOHwbscKGszlOB
 mgVyEnjw
 zc1v/HWacTVs41UfEOzFbeLZQ8VoDNdYWRvmK3pumU17Eu4J3kr0Qaao3qz2obyb50mFr2sDKvISTLb7PEOzGaiNU287RRlSJRQHJfKar8Xw9FpqYopdQDiTzDTfwgF7JayINgM4b6e58yDeLwhm3JFI2zw8j9GhCrzDS3HcRUuJThALvFcCXEq9HJGEblF6e95V9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 12, 2025, at 23:55, Zi Yan <ziy@nvidia.com> wrote:
>=20
> The helper gathers an folio order statistics of folios within a =
virtual
> address range and checks it against a given order list. It aims to =
provide
> a more precise folio order check instead of just checking the =
existence of
> PMD folios.
>=20
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> .../selftests/mm/split_huge_page_test.c       |   4 +-
> tools/testing/selftests/mm/vm_util.c          | 173 ++++++++++++++++++
> tools/testing/selftests/mm/vm_util.h          |   7 +
> 3 files changed, 181 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c =
b/tools/testing/selftests/mm/split_huge_page_test.c
> index 5d07b0b89226..63ac82f0b9e0 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
> #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
> #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>=20
> -#define PFN_MASK     ((1UL<<55)-1)
> -#define KPF_THP      (1UL<<22)
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>=20
> int is_backed_by_thp(char *vaddr, int pagemap_file, int =
kpageflags_file)
> @@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pagemap_file, =
int kpageflags_file)
>=20
> 		if (kpageflags_file) {
> 			pread(kpageflags_file, &page_flags, =
sizeof(page_flags),
> -				(paddr & PFN_MASK) * =
sizeof(page_flags));
> +				PAGEMAP_PFN(paddr) * =
sizeof(page_flags));
>=20
> 			return !!(page_flags & KPF_THP);
> 		}
> diff --git a/tools/testing/selftests/mm/vm_util.c =
b/tools/testing/selftests/mm/vm_util.c
> index 6a239aa413e2..4d952d1bc96d 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -338,6 +338,179 @@ int detect_hugetlb_page_sizes(size_t sizes[], =
int max)
> 	return count;
> }
>=20
> +static int get_pfn_flags(unsigned long pfn, int kpageflags_fd, =
uint64_t *flags)
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
> +static int get_page_flags(char *vaddr, int pagemap_fd, int =
kpageflags_fd,
> +			  uint64_t *flags)
> +{
> +	unsigned long pfn;
> +
> +	pfn =3D pagemap_get_pfn(pagemap_fd, vaddr);
> +	/*
> +	 * Treat non-present page as a page without any flag, so that
> +	 * gather_folio_orders() just record the current folio order.
> +	 */
> +	if (pfn =3D=3D -1UL) {
> +		*flags =3D 0;
> +		return 1;
> +	}
> +
> +	if (get_pfn_flags(pfn, kpageflags_fd, flags))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/*
> + * gather_folio_orders - scan through [vaddr_start, len) and record =
folio orders
> + * @vaddr_start: start vaddr
> + * @len: range length
> + * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
> + * @kpageflags_fd: file descriptor to /proc/kpageflags
> + * @orders: output folio order array
> + * @nr_orders: folio order array size
> + *
> + * gather_folio_orders() scan through [vaddr_start, len) and check =
all folios
> + * within the range and record their orders. All order-0 pages will =
be recorded.
> + * Non-present vaddr is skipped.
> + *
> + *
> + * Return: 0 - no error, -1 - unhandled cases
> + */
> +static int gather_folio_orders(char *vaddr_start, size_t len,
> +			       int pagemap_fd, int kpageflags_fd,
> +			       int orders[], int nr_orders)
> +{
> +	uint64_t page_flags =3D 0;
> +	int cur_order =3D -1;
> +	char *vaddr;
> +
> +	if (!pagemap_fd || !kpageflags_fd)
> +		return -1;
> +	if (nr_orders <=3D 0)
> +		return -1;
> +
> +	for (vaddr =3D vaddr_start; vaddr < vaddr_start + len;) {
> +		char *next_folio_vaddr;
> +		int status;
> +
> +		status =3D get_page_flags(vaddr, pagemap_fd, =
kpageflags_fd,
> +					&page_flags);
> +		if (status < 0)
> +			return -1;
> +
> +		/* skip non present vaddr */
> +		if (status =3D=3D 1) {
> +			vaddr +=3D psize();
> +			continue;
> +		}
> +
> +		/* all order-0 pages with possible false postive (non =
folio) */
> +		if (!(page_flags & (KPF_COMPOUND_HEAD | =
KPF_COMPOUND_TAIL))) {
> +			orders[0]++;
> +			vaddr +=3D psize();
> +			continue;
> +		}
> +
> +		/* skip non thp compound pages */
> +		if (!(page_flags & KPF_THP)) {
> +			vaddr +=3D psize();
> +			continue;
> +		}
> +
> +		/* vpn points to part of a THP at this point */
> +		if (page_flags & KPF_COMPOUND_HEAD)
> +			cur_order =3D 1;
> +		else {
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +
> +			vaddr +=3D psize();
> +			continue;
> +		}
> +
> +		next_folio_vaddr =3D vaddr + (1UL << (cur_order + =
pshift()));
> +
> +		if (next_folio_vaddr >=3D vaddr_start + len)
> +			break;
> +
> +		while ((status =3D get_page_flags(next_folio_vaddr, =
pagemap_fd,
> +						 kpageflags_fd,
> +						 &page_flags)) >=3D 0) {
> +			/*
> +			 * non present vaddr, next compound head page, =
or
> +			 * order-0 page
> +			 */
> +			if (status =3D=3D 1 ||
> +			    (page_flags & KPF_COMPOUND_HEAD) ||
> +			    !(page_flags & (KPF_COMPOUND_HEAD | =
KPF_COMPOUND_TAIL))) {
> +				if (cur_order < nr_orders) {
> +					orders[cur_order]++;
> +					cur_order =3D -1;
> +					vaddr =3D next_folio_vaddr;
> +				}
> +				break;
> +			}
> +
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +
> +			cur_order++;
> +			next_folio_vaddr =3D vaddr + (1UL << (cur_order =
+ pshift()));
> +		}
> +
> +		if (status < 0)
> +			return status;
> +	}
> +	if (cur_order > 0 && cur_order < nr_orders)
> +		orders[cur_order]++;
> +	return 0;
> +}
> +
> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_fd,
> +			int kpageflags_fd, int orders[], int nr_orders)
> +{
> +	int *vaddr_orders;
> +	int status;
> +	int i;
> +
> +	vaddr_orders =3D (int *)malloc(sizeof(int) * nr_orders);
> +
> +	if (!vaddr_orders)
> +		ksft_exit_fail_msg("Cannot allocate memory for =
vaddr_orders");
> +
> +	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
> +	status =3D gather_folio_orders(vaddr_start, len, pagemap_fd,
> +				     kpageflags_fd, vaddr_orders, =
nr_orders);
> +	if (status)
> +		goto out;
> +
> +	status =3D 0;

Nit.
It seems redundant.
Would you consider removing it for a bit more conciseness?
This doesn't block my approval, of course.
Reviewed-by: wang lian <lianux.mm@gmail.com>

> +	for (i =3D 0; i < nr_orders; i++)
> +		if (vaddr_orders[i] !=3D orders[i]) {
> +			ksft_print_msg("order %d: expected: %d got =
%d\n", i,
> +				       orders[i], vaddr_orders[i]);
> +			status =3D -1;
> +		}
> +
> +out:
> +	free(vaddr_orders);
> +	return status;
> +}
> +
> /* If `ioctls' non-NULL, the allowed ioctls will be returned into the =
var */
> int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
> 			      bool miss, bool wp, bool minor, uint64_t =
*ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h =
b/tools/testing/selftests/mm/vm_util.h
> index 1843ad48d32b..02e3f1e7065b 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,11 @@
> #define PM_SWAP                       BIT_ULL(62)
> #define PM_PRESENT                    BIT_ULL(63)
>=20
> +#define KPF_COMPOUND_HEAD             BIT_ULL(15)
> +#define KPF_COMPOUND_TAIL             BIT_ULL(16)
> +#define KPF_THP                       BIT_ULL(22)
> +
> +
> /*
>  * Ignore the checkpatch warning, we must read from x but don't want =
to do
>  * anything with it in order to trigger a read page fault. We =
therefore must use
> @@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, =
uint64_t hpage_size);
> int64_t allocate_transhuge(void *ptr, int pagemap_fd);
> unsigned long default_huge_page_size(void);
> int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int check_folio_orders(char *vaddr_start, size_t len, int =
pagemap_file,
> +			int kpageflags_file, int orders[], int =
nr_orders);
>=20
> int uffd_register(int uffd, void *addr, uint64_t len,
> 		  bool miss, bool wp, bool minor);
> --=20
> 2.47.2
>=20

Best regards,
wang lian


