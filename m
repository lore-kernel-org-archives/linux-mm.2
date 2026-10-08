Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99A7CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E1E6B008A; Thu,  8 Oct 2026 04:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6E56B008C; Thu,  8 Oct 2026 04:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC726B0092; Thu,  8 Oct 2026 04:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A20BB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:33:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2795316049A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:33:20 +0000 (UTC)
X-FDA: 85298794560.06.C2C0249
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7105C0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:33:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJaTmY9Q;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791448398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mfZx2zinbwawb2SikdYr4parys9Z5tteYIz1sprlF4=;
	b=qxLvZRJZ7t2LWlL7eQlFtXPpCRAyP3m0jpM/C4aWZ0KURFOnLMeBA7KczMPY+S1LSRVXEM
	wppEzKMWNjwmJNBHyLWJ4lPZFFcVTqy3x0HiI3v5LeGtPFVt2jr1PIEHY10NmhHsnYreNV
	uo2+C55D15nA+/SPt5h+XcKKlKoKBYw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJaTmY9Q;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791448398;
	b=yzmaxSfL/aE1oSd1SP/bMSdpk7cDFKFgRgThtNE+j3Elrl2lp0LQPEzpxV6r0qjHVRlDvN
	4pdw53NVg+v9EOmudXsAhOTXu/jGaNQgRgxUb+5WedCpLmUYjAxI1DNuWUhhToiVIVbpBw
	2JY4H3kvhp/fRV27tot6wzUzH2gOQE8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HyGwwSVmXvhmOZPb5rYhVyPJ+UvfVubhGgu9kDF0uic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791448393; v=1; x=1792053193;
 b=BJaTmY9Q2AcNcg0Ibm4M/yFMd0jOkbvaF9GOOHOQC2F0NG/5vtTQRpNkUTdl7umzZkowp+Zg
 saCqstM8QnCXhqR6BV3oExuPa4vjItORXe5J2PfzMk0ZL5l8xXlY7kZNQe2GdUuhgcJlYN7Wbb3
 gFKgnhcpnbQTV25OLuzBl/PM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f276eb58ea604195;
	Thu, 08 Oct 2026 08:33:13 +0000
X-Mizu-Trace-ID: f276eb58ea604195
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261008073021.2512665-2-songmuchun@bytedance.com>
Date: Thu, 8 Oct 2026 10:32:58 +0200
Cc: akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 david@kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ECC604FF-E74D-43B1-9105-A6683EEDE558@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7105C0002
X-Rspam-User: 
X-Stat-Signature: ifaacinmo8p7yqy4q9fiqzy34exs46t5
X-HE-Tag: 1791448396-828563
X-HE-Meta: U2FsdGVkX19fh4cBH4CNUtKPgoF90ahGm7FgsNPZyCVu6aVjEomI6LZG+ywVu6/10xano5hwHTt8VZOQwVQqFl2Asy78X8M6XYFhlv1VBAOUh864PbkzzwEzKT26UmOl5T1uEabn9dGOqwlBLG4A2arSBAprfyY6qhU/dzGm0XBPAVKygQ9fBF0s3b5PdklMVVcYng9n8Wlo9+OQe3LpZJrobQG0YYANCt80AGc+KSdjFuQrhLkGmqvOFXx3t7aU+WR0l1Fhls6iRN1iphMEjmn1+ETA+ZeLrdL+KztyntvsDJofd++cFnVaI4HyOU2kn2SabsCDu3UBtMDszt/y2Fs5sND8cAjsrvnQg8xhhdESnuwxoX1NkU8IyoST222PSgk/RWo5tYw3O8YsOuMmQhmupFIbOacNDT4x+hmYs22//vHaaKIBNfOsrE3oltKVpNZfiY+hCRh0QXtUGdhEAxHLGSzj8ptsMGD5QVjC96MuLDAKDeh3UO0z+p9cSIWu1sKtTRmsyKyOSqN8S3qe39nKJ/WMZHGrOH1HpCMB9oQRDUztvcqA021bXLg+4+pK1SWpWvrjeCVeLWueOrJiWaCQBUkbek42c9GAM3Ifb+1R8FHIBU37Or3YyitKak9TAQgW5McFLyYI7GzSCoGUf96FHF1X5Dnf69dp8pptxbRQegs1l6GJfn3Uic0KZhbUC4dwsGrVb2NIxGD29Uq0rNYeX6W9uRiHTCDd71S3KlRDAN0gfgYKWDy+84uhxfa5xBn3FIVbD43psiDpRh5o3CcJ+E2JPISI6I3BfBydGDy+kyR7l2piQcY0rdYcheSfjOlUMcXgQU+71yZ0OAHYtGBl2cT4CWwJlkwjs3OOUhy/VvNH5+uiC8TQI/0mCjfce/Tm7azAQz6MdgEVaihKPqCTs6t+HS1IMHi+SW2kFSrTWWgPuG3gey6KpA0ZC8U3RuHxELG2Jt90prYdXEF
 nVl7DqtA
 Xt2XGrzNSC61tmqUzm+5p1rMiSO4hnAECAQqWI9H1GztaXhsdRmCYxPe9tE7ci5GLQfKzyefl0xi2VBEkI/cNmtIZEFLP/dmsDFRfVBs5yke5wzdNAeWWHJo3ZpEyx/5LMlgZtDB5EZadGRS0/JdmRjeB0evqeVWk9C3XfMny3DwKdm5RxF95SZAl1W36Nw133Ac0I/Dbj+8t+64ObNauXDEnFp8V0ip9WoY/b0TUVYgtUGF0IWkq4lPJaKO+13jM81FeKFpiu+1kksfAqNEyUA06Ja2VtKe/7cJ4X0hETc7AwanHaNG67jS+Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 8, 2026, at 09:30, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> tables.
>=20
> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when =
splitting
> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
> table, so a later memory hot-remove eventually frees that table =
through
> free_pagetable(). That path currently calls pagetable_free() directly
> without decrementing NR_PAGETABLE.
>=20
> Use PageTable() to identify constructor-backed tables and run the
> matching destructor before freeing them. Keep reserved and
> constructor-free tables on their existing paths. This also prepares
> vmemmap teardown for generic runtime allocations through the normal
> pgalloc helpers.
>=20
> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> arch/x86/mm/init_64.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 70e682180291..a3ea627157ab 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1003,6 +1003,8 @@ static void __meminit free_pagetable(struct page =
*page)
> {
> 	if (PageReserved(page))
> 		free_reserved_page(page);
> + 	else if (PageTable(page))
> + 		pagetable_dtor_free(page_ptdesc(page));

Sashiko mentioned that kernel page table pages and vmemmap pages are
freed to the buddy allocator before their parent entries are cleared
and before the TLB is flushed, creating a dangling pointer window.

That's a a real but pre-existing issue, I will not fix that in this
series.

> 	else
> 		pagetable_free(page_ptdesc(page));
> }
> --=20
> 2.54.0
>=20


