Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76AAC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 03:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD016B007B; Fri, 24 Jul 2026 23:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E176B0088; Fri, 24 Jul 2026 23:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CDA6B008A; Fri, 24 Jul 2026 23:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBBE6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:06:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61DC1140234
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:10 +0000 (UTC)
X-FDA: 85025810100.27.CC851DA
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75DBAA000C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a+Gz72ay;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784948768;
	b=1/bsweDQHHTvPYRumlCtzrk4o2cMeCPGQwZ+b7h0vJb1LYGdWWUOq7LLim4nvUWWD9ZcTv
	OrLtrlBUkjMtH7L4mN7YHR4b6047dsbzfdXhpCDR15k4DNVmfJpNG1LPcIyuUw2f2JIrHr
	LTBGgvsNhWuWYELsoue3xQgfyA/rh/k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a+Gz72ay;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784948768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irNbnFIYJEygdH7Nv+c574HKymSb443hYjEGyIauYac=;
	b=rC2VJufKopaM124W7+fmGwVNdMAvmUU+Of60cFFuY+4KEGZAx4Xe7Ti/hMfJZY44HebSuq
	qr5Ohf5F/gROpWIyc1WWkbp2qF/zTcDWyBz5C7NtmoSZVsP4HdPa903ao+XmdgREfu+sdL
	CjzjfYXVaCLnrzq9Qla39bAFVpc8mqs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so65031cf.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784948767; cv=none;
        d=google.com; s=arc-20260327;
        b=LJpx1Hht4bDOVdIrNzrnqWVMaDQkCCgyLiIDiTLZlFH3QvRSzH/5IPtae5DMfiGJBa
         06AwGzpolJROgvh0T4/u4hfjvstphnF8PLb3u4Iew/hg1fiFo4Yq8A9YejkoEN/RTp59
         Smulo0lAXIubnXuW1REcbdYe8db2i1iESQtMKRWghCNwiKwqUBgq1K+J6nOnpkxU2/XQ
         HEk4oeP/9tvshTCVw1X0FBCTX4IoLQsrHIDR+SQRdv+kk8AYnjFHiJIfUvpGaMt1hLFs
         AOBkg5QrF8jdHj2PgONO5YawlusxtYH3kFiGO3Ojlt1rG1fofJ35eKt54HB1Cy10KPD4
         RRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=irNbnFIYJEygdH7Nv+c574HKymSb443hYjEGyIauYac=;
        fh=dKop7XH3xT2gStLIv8cCC810xqZg5L5XHiA+BfKeMsk=;
        b=bto3NHuYAH5FaPY5MUVArbzjMcXGeFMhaYtnyGKc9XzmoivE9lblvr947ekT1Nqb+8
         twboMv/Z+TIrBHzrH7WFoD6YBr0sP70Zhzy8tYFhSyXf4HR3Gpig06iEkSdnSG2O+LCk
         gvfNQwQXRhmPSgFQkIO5ajwPsFi6/EQ/5ojuARiuqc3Y9hzoHPzK06g/H7YX0XBafUAu
         ZCD1X+l7ikSex4GkR6p+kPZXJRYe0t2JEHYtNTwrCrSOv//WiLa42hQHn95lKDGhZoCZ
         6UvEu/yf/MSlgN7FHVwhDJb4KFj4ot2gI8YH9gUjs7JkqQ0CuluZdhpMgnwjCtM0K05A
         L55w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784948767; x=1785553567; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=irNbnFIYJEygdH7Nv+c574HKymSb443hYjEGyIauYac=;
        b=a+Gz72ayE10YJghkKVXLMrHZ0BUbTpX5Ehn766ocOmQnpCKQ9/c0czUI5PPBUq4JXA
         W6sXeTqWWIcn7SM31ilNf9xGOjmiW4AgQqFU8lFL/79HO1Ij7sJTnO+uD8z0U3TBYyp9
         nDcfm0XxhU3M7fl8rHa0UUyfzSNPugAWj/xVjfWpondNLBmRlRwOps1f2gUvLVSjI54K
         HfVeGNodPRpZOsXEteQ9LS7aZ8mv+nEWT42vcBnkZej65ZNlh4gndltEvjt+pWt5egTu
         c54uEMRLw2ttWgW3eNWZWod5YQw1Pdo0nNkk0jm1TBLv3RbRLqvCIqqaQJnbQFrZkhSG
         tIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784948767; x=1785553567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=irNbnFIYJEygdH7Nv+c574HKymSb443hYjEGyIauYac=;
        b=gcPm2MlAsZBftRpkBEnMblol3m29H5GRYCeQEUe5Z4212W/PmTV+6rFoXJVX2tNXRR
         rhLc25LUBJXzDqrjOGioA11CLT8VSUb96/y2Wpt+x8Q9+8rPOxmx4DB6t/+IRBmAfxtt
         aH1XWvW98Kg5Ip/wPXF3KjuEZLXm4oi8YjavWtTHjqhA+oz20f9y6/NI/F6ueEv0cMhz
         GfA+96Qr1v2XH+17K6V0Rkb8vUVXoAAvpqXzOKvaqSRk4iIChQe/wLjXNUvH18A4LtU0
         Vx0USFIRAXdrz2CdJl8G+hfy9OpzmK9SsxdKRb5OGx/n1cBoyRMGXm2qOmVuovx4745Z
         I8eg==
X-Forwarded-Encrypted: i=1; AHgh+Rqvbi//NpnZE1KmG24bL3BuawdzEenmS7ldPg9ADIdc+kU5/zqa8pISmnu7rXU2QiqQkWnCgznnWw==@kvack.org
X-Gm-Message-State: AOJu0Yw0yafbD7Y2cA1clO//M3EY1STV3/SoYdj7LL6/eex615VIpiVj
	ySig/CJEuEFbSOSC5VefQGNtuZqtNy+F1zrCJ0chw60NEPlcPgPDSpT46FLE6s+iRthV2D5Szzi
	QEoye4IRbPnmKKCDuUTNydHnHOQuukZuocnwYTJi+
X-Gm-Gg: AR+sD10a185btTR6ej9BKBJ1Y7gLTajIZ5nArWMIZafTLUmkCMA2pG+klpY4WIAM0eU
	euR1aChptQHTrTwggFiYt+3HghfDRcqpUv8TNe5WeU8zpnonuAebNiULoydXfvAFOFljE1gMfgm
	45Jc6qoGxy2QYxpDDVZUYNE2sv4crZQw8RU8aKaJt1XwNL65K/Wdht+Pl7tPDi004aOENMhkd8a
	x+5OJ+lH/3R0cbRfDauzx+QDuJYm8L2e14ngkm1osVYaQLw5ndDf3lZdNALvCOALtcG36pBGwwO
	h3q0O45vJpJKHcPJa3Q=
X-Received: by 2002:a05:622a:a989:20b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-529a766c095mr5563691cf.5.1784948766958; Fri, 24 Jul 2026
 20:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705180714.3708947-6-jiaqiyan@google.com>
In-Reply-To: <20260705180714.3708947-6-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 24 Jul 2026 20:05:54 -0700
X-Gm-Features: AUfX_myIFFaUjfDx5aw5ISEvSaCmn3BHQrluKZ5peFeDhY7GfyFGFx2PqiFBCFI
Message-ID: <CACw3F53b2kmok37Yt26HpCTDZ9Ymd-QnF8yFwHzy==_ObwX=1A@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] selftests/mm: add hard memory failure anonymous
 HugeTLB test
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75DBAA000C
X-Stat-Signature: wfe44fe9yre38pa3eain459oerowohmu
X-Rspam-User: 
X-HE-Tag: 1784948768-83377
X-HE-Meta: U2FsdGVkX1+KYtejmwEn6szC1JaU4xIHi1lNPobQ1QZA7OvPG8cHkWRjnONZ3zxZ+chymJQBilS7aXp19uwUcZamgEn/I0BAXdHOvjnLi/DpEAwm/Gg1vSt+JJyouOgqBciLlM4vdbQrbRftDHvruCVNhpHUmZs2ZUz4DDVc+PcEOtrjUs41hlocKTE1xCtWrcvKA/Nh4gFXEHdEovgUmN+vkyrj63ewavb9In97GLfqyQ39LQEgNaA8JHe5Um4dfTktrqJBfp6XXss6cKFWW6RowFJNl9eOlNr4tVJZ1IRqqP643Mzf5c1rRDkXdP/CjpDs8VzfHOCwMbX5RhzFwQR00f8+/VMlb21nY0ktP9fVf8dPwOayxOmr1S4grHhDAZMVtY59+I8iqDStnwSA0xb5ArsgcMqzoVoWZue21AYcdDtnp8dHLs5n625wAYEu7U+XFJNE2QHr5tpkoLEL6kj0PRpGcnxCntHMtqWk1pFkYcZuMB3uAsKOC20wLCNVtJLMQphL4UzV/q9pw1UMWephU7Es+LWK6Wxjmn0LsFe+8tHlBZWsT3jYY3tQzzH2a+EaBCqsqXuU33jgxcO5+6otPKhKiGo7mAwT6ttahNyJW/r+Vq0sygEnfRxF+lFK0xlkvpZ2I4aBk1jvVoCZdA5AU46jXhhNEtqAPijpRoCytWJg+BF/jOO0+EWl5Fx4tBN1SOoJ0uRdXbRz++fnqDepp6ZxP7HiHvYEXEmzBzO2AtiDKM8xWkrbyBdMyOy9BkKHbZUGFpCKdydMIjs+6eiYvvJzLhFKIie6utpW7bhIY0oZeSZPy/BOX8IIbSbRkXzJPKtYvoj2afL0ZK9dLvgZoYxt3DPgO5W/ZaNdj39k+74Ol7cw/RutVsCsTIS4k4PCX3yiPV10GttWZfpJFo+8Np0owJpyq3NCwqhT6Yv4q7Bw8pSrt1wpwVoFpBQqC1nM4De1YzMCABlC9CW
 Ob5KaXvQ
 4j/plyiNaYDcjmvMJMWT78pyRFFMP8cJdPcB/Ln/vvkunNENbQa7lesCKipHANZm28HKZKLg1QUdJWdEHEskrDjrLFmjLnm7PJqb+zRyiIzZAvtIvoZ88o0e3n5fl3zx9MrD/47Z8ZvdustQfQkdyULLsK2gibuN7/jhTIMgw85F6pl+o9q71p30nXYRUKglxTegWZmPkc8EuyJVsIKTMIT1Ql3sv9P3mfTdZh95MQgsu5hUx8ujZ7fuIiB+M2qr/VQrV7VTfRNd2YQRd1bdCr1hA3TehFKR4Om1cUSgREl0QBFzACYwEBao9SQ8IlTxqzBh/2KOXROtWIz5npYXUn5mp/5ah7IUbsj6TgtPvz2LQnr5rFpo4Ol19iDdIOQLBfNGvW5FrTq8s9xIHzQREcVepqz5IwBHctzGRghRpLAM19wpET0xAWiqRHzMY+Jze2dhYKOZat8tIB+/P3U+HfnV9VYiqZ6OxUXt7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 5, 2026 at 11:07=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> Add a new testcase to validate memory failure recovery for HWPoison
> anonymous HugeTLB page, including proper SIGBUS delivery, releasing
> a HugeTLB page containing one HWPoison page to buddy allocator, and
> isolation of the raw HWPoison page.
>
> The test uses HugeTLB's default hugesize.
>
> Although can be added in future, this patch does not support testing
> the MADV_SOFT variant.
>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 70 ++++++++++++++++++++-
>  1 file changed, 67 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/=
selftests/mm/memory-failure.c
> index 032ed952057c..78c105ce2af1 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -18,6 +18,7 @@
>  #include <linux/magic.h>
>  #include <errno.h>
>
> +#include "hugepage_settings.h"
>  #include "vm_util.h"
>
>  enum inject_type {
> @@ -27,6 +28,7 @@ enum inject_type {
>
>  enum result_type {
>         MADV_HARD_ANON,
> +       MADV_HARD_ANON_HUGETLB,
>         MADV_HARD_CLEAN_PAGECACHE,
>         MADV_HARD_DIRTY_PAGECACHE,
>         MADV_SOFT_ANON,
> @@ -47,6 +49,8 @@ FIXTURE(memory_failure)
>         int pagemap_fd;
>         int kpageflags_fd;
>         bool triggered;
> +       /* Number of initial HugeTLB pages with default page size. */
> +       unsigned long nr_hugetlb_pages;
>  };
>
>  FIXTURE_VARIANT(memory_failure)
> @@ -157,6 +161,7 @@ static void check(struct __test_metadata *_metadata, =
FIXTURE_DATA(memory_failure
>                   void *vaddr, enum result_type type, int setjmp)
>  {
>         unsigned long size;
> +       unsigned long nr_hugetlb_pages;
>         uint64_t pfn_flags;
>
>         switch (type) {
> @@ -174,6 +179,7 @@ static void check(struct __test_metadata *_metadata, =
FIXTURE_DATA(memory_failure
>                 ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self-=
>pfn);
>                 break;
>         case MADV_HARD_ANON:
> +       case MADV_HARD_ANON_HUGETLB:
>         case MADV_HARD_DIRTY_PAGECACHE:
>                 /* The SIGBUS signal should have been received. */
>                 ASSERT_EQ(setjmp, 1);
> @@ -184,8 +190,15 @@ static void check(struct __test_metadata *_metadata,=
 FIXTURE_DATA(memory_failure
>                 ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
>                 ASSERT_EQ(siginfo.si_addr, vaddr);
>
> -               /* XXX Check backing pte is hwpoison entry when supported=
. */
> -               ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
> +               if (type !=3D MADV_HARD_ANON_HUGETLB)
> +                       /*
> +                        * Check backing pte is hwpoison entry when suppo=
rted.
> +                        * Although try_to_unmap_one() also installs hwpo=
ison
> +                        * entry for HugeTLB, pagemap_hugetlb_range() doe=
sn't
> +                        * parse swap entries at all.
> +                        */
> +                       ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, =
vaddr));
> +
>                 break;
>         default:
>                 SKIP(return, "unexpected inject type %d.\n", type);
> @@ -193,7 +206,19 @@ static void check(struct __test_metadata *_metadata,=
 FIXTURE_DATA(memory_failure
>
>         /* Check if the value of HardwareCorrupted has increased. */
>         ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
> -       ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
> +
> +       if (type =3D=3D MADV_HARD_ANON_HUGETLB) {
> +               /*
> +                * Only one page is hardware corrupted; the rest should a=
ll be
> +                * released to buddy allocator.
> +                */
> +               ASSERT_EQ(size, self->corrupted_size + getpagesize() / 10=
24);
> +               /* HugeTLB should have lost the HWPoison HugeTLB page. */
> +               nr_hugetlb_pages =3D hugetlb_nr_default_pages();
> +               ASSERT_EQ(nr_hugetlb_pages + 1, self->nr_hugetlb_pages);
> +       } else {
> +               ASSERT_EQ(size, self->corrupted_size + self->page_size / =
1024);
> +       }
>
>         /* Check if HWPoison flag is set. */
>         ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flag=
s), 0);
> @@ -247,6 +272,45 @@ TEST_F(memory_failure, anon)
>         ASSERT_EQ(munmap(addr, self->page_size), 0);
>  }
>
> +TEST_F(memory_failure, anon_hugetlb)
> +{
> +       char *addr;
> +       int ret;
> +       const unsigned long nr_alloc_hugetlb_pages =3D 4;
> +       unsigned long alloc_size;
> +
> +       if (variant->type =3D=3D MADV_SOFT)
> +               SKIP(return, "Soft offline test is not implemented");
> +
> +       /* HugeTLB settings will be automatically restored when test exit=
s. */
> +       hugetlb_setup_default(nr_alloc_hugetlb_pages);

From Sashiko [1]

> Will the sysfs hugepage settings actually be restored when the test exits=
?

> The anon_hugetlb test calls hugetlb_setup_default() which registers the
> hugepage_restore_settings_atexit handler via atexit().

> However, this test is implemented using the kselftest_harness.h TEST_F()
> macro, which forks a child process to run the test case. When the test
> completes, the child process terminates using _exit() or abort(), both of
> which bypass atexit() handlers.

>  As a result, the cleanup handler is never executed, permanently leaking =
the
> modified nr_hugepages sysfs setting on the host machine.

This is true, and I double checked with this test.

> Could this cleanup be moved to a FIXTURE_TEARDOWN() block so the kselftes=
t
> harness guarantees it will execute?

However, this suggestion doesn't fix the problem. The harness runs
FIXTURE_TEARDOWN() inside the forked child process too, so it will be compl=
etely
bypassed in any of the following cases:
- An assertion fails
- The test crashes with a segmentation fault
- The test process is killed by a signal

I believe the correct fix is to use HUGETLB_SETUP_DEFAULT_PAGES() like
[2] did, and I have validated:

$ echo 16 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
$ ./memory-failure -r memory_failure.madv_hard.anon_hugetlb
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 32768 KiB
# [INFO] detected hugetlb page size: 64 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
TAP version 13
1..1
# Starting 1 tests from 1 test cases.
#  RUN           memory_failure.madv_hard.anon_hugetlb ...
#            OK  memory_failure.madv_hard.anon_hugetlb
ok 1 memory_failure.madv_hard.anon_hugetlb
# PASSED: 1 / 1 tests passed.
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
$ cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
16

[1] https://sashiko.dev/#/patchset/20260705180714.3708947-1-jiaqiyan@google=
.com
[2] https://patchew.org/linux/20260511162840.375890-1-rppt@kernel.org/20260=
511162840.375890-46-rppt@kernel.org/

> +
> +       alloc_size =3D default_huge_page_size() * nr_alloc_hugetlb_pages;
> +       self->page_size =3D default_huge_page_size();
> +       self->nr_hugetlb_pages =3D hugetlb_nr_default_pages();
> +
> +       addr =3D mmap(0, alloc_size, PROT_READ | PROT_WRITE,
> +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
> +       if (addr =3D=3D MAP_FAILED)
> +               SKIP(return, "mmap failed, not enough memory or hugetlb n=
ot supported.\n");
> +       memset(addr, 0xce, alloc_size);
> +
> +       prepare(_metadata, self, addr);
> +
> +       ret =3D sigsetjmp(signal_jmp_buf, 1);
> +       if (!self->triggered) {
> +               self->triggered =3D true;
> +               ASSERT_EQ(variant->inject(self, addr), 0);
> +               FORCE_READ(*addr);
> +       }
> +
> +       check(_metadata, self, addr, MADV_HARD_ANON_HUGETLB, ret);
> +
> +       cleanup(_metadata, self, addr);
> +
> +       ASSERT_EQ(munmap(addr, alloc_size), 0);
> +}
> +
>  static int prepare_file(const char *fname, unsigned long size)
>  {
>         int fd;
> --
> 2.55.0.rc0.799.gd6f94ed593-goog
>

