Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B10CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 14:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AFA6B0088; Tue,  6 Oct 2026 10:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCACA6B008C; Tue,  6 Oct 2026 10:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1506B0092; Tue,  6 Oct 2026 10:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99B446B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:11:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D47E8A0145
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:11:20 +0000 (UTC)
X-FDA: 85292388720.06.D3F00E9
Received: from mta1.migadu.com (out-118.mta1.migadu.com [95.215.58.118])
	by imf14.hostedemail.com (Postfix) with ESMTP id BE37A100005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:11:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufa5h43O;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791295879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saqf3920fqackN7uHk5n98WIRXkVXaRESrKtRhlKO1c=;
	b=sHiiNUIV6kYN0n6vh1pPKW2kDSCuCSkz/PzVP3wM/k3JTjI/A5LvKIZVe+NWasy8aMF/Fp
	/zbz1Pdprpyh2yRrajOCjt/ioEkj1idCB7hWAaE2yuScKgZTn88W2VAdKg5KelqLp0Clmm
	iQk9izaOCZX5kcUyYA14BlUD/MyN+lY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufa5h43O;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791295879;
	b=z8cqDc2T2L+3CLcv/hvxXFk7Yr6u6P3qjTtjKUCuS7DK8jnj1eC5ew33b1sb4At1hgKBLb
	fqiJ/8zD6ASnPgtCzEeDwe9Qt/IAy0AWmgNFw2xEcoyo/SIaQ+/1/kpjjJAPX9q6Th9CCu
	PLsn92PQ1RPT7w5MUZXHvYZHI7x4nCc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fjCunfX9sDKQD5QYOaP2NzWehuR0nrD8qG2e5t5JFzI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791295876; v=1; x=1791900676;
 b=ufa5h43Or4Em8nOnSMkm4YHB0+B2tPUYvA7iur82l6PnQeLzYX2UaOXmmwCgoNTrWSDNJRB+
 AwUHPaO/ct0AN04kppAzwct/co3koYF4S1DhUaJYWT7aWtnhrGaafLsNl80jPpX7A7DMquvebMG
 YDQgLhzG9lzilB5YMktod5bM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 23a085b5514e6df1;
	Tue, 06 Oct 2026 14:11:16 +0000
X-Mizu-Trace-ID: 23a085b5514e6df1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: use kvmalloc_array for
 hugetlb_fault_mutex_table
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261006140226.11684-1-dheerajkumar.srivastava@amd.com>
Date: Tue, 6 Oct 2026 16:11:01 +0200
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 davidlohr@hp.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Vasant.Hegde@amd.com,
 bharata@amd.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB1A3722-E7F2-4E54-A0E4-940BEB15EBC9@linux.dev>
References: <20261006140226.11684-1-dheerajkumar.srivastava@amd.com>
To: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE37A100005
X-Stat-Signature: fb1319bd9b6uict9nhdw3wxzna6r3zat
X-HE-Tag: 1791295878-464032
X-HE-Meta: U2FsdGVkX1/cdICvkEbWKdWfA/QWJObAU5/CyFp0o61eCjuvNM8naoz2lZlrgniVCAX5Sf6VtCKBUd956kwPdRT5bES5Trf+k+LH0FrCVCPgSxrkRUlaneuZ2TkaokeHdT1Aj+WbaNNR4H4gEhdRpEZvPVbhFB95+ksub7sIZ3KewWxkflUX5GXq0DFf3pq+sXmn9yT1M7RMXJ8+0v3M17uMrt1vM0A1zDTEo6rp08HojodHGkc75yi2Pp7tqk9Ma8g9xIOyB3M1njLuOBCgbLfkPIqdJ8zxn71dNV4tGq6Kka69RyTVc+aBJ+yLoVOmy1ZH8INovAjJWB9wRmQeDPSZBycGfdmT82oZQWnBN1tOGcaI0enY8q8xoADYHvd2FckmVbw0GJvmozIsL9P9QsqaMMIAONWfoWYfAT20r7E67a/T9sEdCYjqqm8Lm/mvyP/r0XeMo5f2pcAJDlX0RrqjK8kFNjp8Bz2YSQcj5rESjT1KKJ1I6bbiFbcQoB1UAxdGwX5c8W8lbM7GkJdKi52LOXZf31JW2WbPXkkEH6piJtUqx0jrXMGmFievyb6YWNNyZZFccRhSux4vo1RlRUrMh3nglYOn36Q0xz9+Fi+Lx/aTaVk8spkWWcxOUfeIOrkxhajZBAyNdg4NKdkBRlhehXkQ9AJZHqg0Xw7df3NsCQB2drFuywH2Wy1c1EalyIHJw0Ux1tAvZfKXZi0wEX/uNLovbrEkm9ZPMHtoPdjg9aiaJNBsTObL0sOUk/sdjLWY89VMhqwYrJs1BNSbDY6s0Raw3nNQzBWCvZefsaCssHp1zY4Ksv1DxqBLhK+Wck8Qkg74W7NyZJX2reypyw91xqauzG016c1HKQ7S26ifl03iiUUOBsvD7v6V8UB7tDk6W6EDdu8bNPYlEWy6hiqI0GeRhkSNuN4cCyGytjtoLfkH5jzMgmLWpqRBLLta61vHtOB0hq5XJVPsH0s
 pEDHTuRN
 aICRKEipESI5ZzKLcGGerSDzF1tseYJpAisDBafB6GFqoQ5Bgzz69dp63j45DM7C0lIG0yNhxdLL2YievI6HbYKtK4L6hXhoyHzKPERWwxIWQK1z03HdEL9hOmM4EDGdM0PayrvRjaMlR/YxDAHwB0ynAPjDDmas8xHYpEE3D7nZ563ITCKvwfT+aX95H3U4rID8d7vJst1l8lEs5juM5iGusjkQ57Ude6s2TxxjK38JNh3gzqXeh8N6OcrRgOVFszvTsH8ksTQJqaJvgx4EaWOu2sl584AdF+nnXXqGoSmRrrDycWBQDWkyuBnLcjFTUFtght3g9LssSRkHIYaQ9cqgTDOv0xrkgp5UglYVECh3j2uoi3IANL7UNt0Hi+5trDozkgHhAi7dc8D/ZmqknVT62FPssUXQ+JDh8Xi+W3T3Rv5NaGnifsZ3nF6W6rdc9I75c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 6, 2026, at 16:02, Dheeraj Kumar Srivastava =
<dheerajkumar.srivastava@amd.com> wrote:
>=20
> On systems/VMs with a large number of CPUs (e.g. 4096), hugetlb_init()
> computes num_fault_mutexes =3D roundup_pow_of_two(8 * =
num_possible_cpus())
> =3D 32768.  The subsequent kmalloc for the mutex table can exceed
> MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
> CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:
>=20
>  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
>  kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
>  Kernel panic - not syncing: Fatal exception
>=20
> Switch to kvmalloc_array() so the allocation falls back to vmalloc =
when
> the contiguous physical allocation is too large.  The table is only
> accessed by index, so virtual contiguity is sufficient.
>=20
> Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
> Signed-off-by: Dheeraj Kumar Srivastava =
<dheerajkumar.srivastava@amd.com>
> ---
> mm/hugetlb.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cea25773a6c9..f1b982595151 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4177,7 +4177,8 @@ static int __init hugetlb_init(void)
> 	num_fault_mutexes =3D 1;
> #endif
> 	hugetlb_fault_mutex_table =3D
> - 		kmalloc_objs(struct mutex, num_fault_mutexes);
> + 		kvmalloc_array(num_fault_mutexes,
> +			       sizeof(*hugetlb_fault_mutex_table), =
GFP_KERNEL);

Why not use kvmalloc_objs instead? A little simple.

Thanks

> 	BUG_ON(!hugetlb_fault_mutex_table);
>=20
> 	for (i =3D 0; i < num_fault_mutexes; i++)
> --=20
> 2.25.1
>=20


