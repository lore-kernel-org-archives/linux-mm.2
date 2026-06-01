Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79668CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B2D6B049A; Mon,  1 Jun 2026 14:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B727D6B049B; Mon,  1 Jun 2026 14:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88F16B049C; Mon,  1 Jun 2026 14:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9743A6B049A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:05:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4426E1C0B7E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:05:08 +0000 (UTC)
X-FDA: 84832120296.22.0E03B90
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2411420013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:05:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EKONVNk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780337106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXBxwpkZwhydr1L6EXrGt/4y8up0y+fMY9/ODpEynHo=;
	b=rD6XUDPlBjRZ3nblMekadIwnHwqyKrIodeldTWJzsOrbyso/yhZuwcZWmyKBwBCUwADXQI
	DnJiiiWUgzjXKBmEhiI+CqTl6J0BJkb+aOdCBf/RFDJkS+hmk/0U15rmcbRiAZ/3RYXWUj
	JbCkkHWZAWOhYLFAfAlnDqY10/+JF1s=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EKONVNk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780337106;
	b=eWaXau0rtyo87reToPrgqb512XJuE/SyMDZemwS1UDPYh0ZtDFCsvvNIQH42U72IPzJSpc
	ZoBgcHB68RqRI/Ywoe4q/fKTSeZ3uHO3fZ87LSe4lAhmNzLYe9q/hs3X2bRpw8qcFtA4Of
	Js4TjrUDsx2XiFcF6xnKGU154Gpk9gI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49045e2a8a2so2805e9.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 11:05:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780337104; cv=none;
        d=google.com; s=arc-20240605;
        b=Ze7BVZbREj0XtI08CbpX2+wlbpoztQ/QGo8lZSMQTQE7Z+1VOOkRjwkublSrDcyk6B
         NzOV3JkL/JKe8lqKtFL5OmhkTUnIP10Cz+v73u8muq7fqIJcZj3gLokATG7yGJM7d2LJ
         Tnmmgq+C/dlxo0xVmc/ubGWvnHF4jWbK8fcPB+g+ao84pGLYgvwdzKvaxHmXa/fUq8KI
         WnM1uGWiT9sAmw6Z1oLA6ZLi7pfoF0F1KPhP0ReEjCYLuGNqTu/YKWP2hjuUqNVYih3N
         en09UTvcbN4dlFMOs/Gj0VaoM3ShxKu08uhFUw9tnluz371ekwHlvU0Rd9WMajCdjUqz
         xTXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jXBxwpkZwhydr1L6EXrGt/4y8up0y+fMY9/ODpEynHo=;
        fh=PnalQnGadTmII5MzYv8rTO68Uz4XqCogG98bLEO4Dt0=;
        b=YJYKaEXuxXr3ACO26Q2yqufFRUdL3jveHyZ+xq7CkmoKwoIzIbozPC5izv1q8JeIju
         I+SEy/DYm/g/mvikVwMX5+jplt+ZTHGNA5Me7CQzQabzyY0i8b8o+c/A26aA1zxFNWKq
         g3xoCdhjiGM9oS0N/2UiSb3d4cTPwo8OMN/0etF27N8ctMUMbDtTDqOaAmFqADtoCcm6
         n8euFOZW+Wb8r64W+gmmRw2tsskbN28dxSHpzf6GYFdFW2DbLsFahDWpHr8YeFtWAa+W
         7rb0tEyY8t9a/kJkponverRLSYFrMNLGx4oCHaTQH/0YZAyuOCU9/Q0UjK8wyVRD4jqu
         BEBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780337104; x=1780941904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXBxwpkZwhydr1L6EXrGt/4y8up0y+fMY9/ODpEynHo=;
        b=EKONVNk0/Hl5gak//uTis9uYVvXXaEopV/3Xs8ZBF/MTFpQz5DYlAkC/p8Il8+cOBv
         zAhqw0p3UuUKRyKs4CWpK46lJPh3QNTg9CrSUKbNF/HeFVK4OYvZ0bO2ukwhNy8Fcr7e
         rlheUDCog55ypdVV9Ur4tVQkfBDGKGxO2in/thG7khl9kPZxnDtFOv/WiYXetRUnJQxN
         5y59U6/vkxQfMf5dBPMakc+uxDreonLtd8sN+BBdTbPHdekZDDukAqE2ShM4TG34Cv9q
         qMUcx2/Mz3qK6ckc8xlqTzjaRSTOvMidUWy68U+OnMSdHo2lNJiL0OHVmTJld7X3xKlQ
         GaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780337104; x=1780941904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jXBxwpkZwhydr1L6EXrGt/4y8up0y+fMY9/ODpEynHo=;
        b=KiIl45lX+/lXZBzjTEUjU3bYSjVyGCqvvPknAikY2vIEABnhNjrtvvjdy3VPS5q89k
         p5EqnPrY+yyB1C0jZ7mQ+LaPNQQ6gP+32PaAshlV0zEJ1d4M2p7juncccbPjBuZjmSjl
         DMbDIdf3JV3BsErHc6LgLdyUKa7QRdy/F5LumQnDMBlT0AZV+iBMK4cRRyvAlOag2SUt
         vwYd7mrfQoVDF+IWIy8eX3uhs4qNu6T1Ito+hRr7pS4gjZTRav51OEfHLuISLWNY7CR3
         OptH7IW5/+JZ4qYA3XLCU5Bi1/uC/wh8O0sstT1EdZx+4XHqddHP+WJ4YlSmL2QRMWdP
         1I8A==
X-Forwarded-Encrypted: i=1; AFNElJ+WpqWfqI1YHgzp/KrwHXapjK7QUNIxG9aMqCoUMwfKrtNnJ3aHXNHV3r4Bk/9/dkvGgjyCgPOc9g==@kvack.org
X-Gm-Message-State: AOJu0YwcdqT+bd3ssPuIakdek2mst9RwEiS6z2TNWnflP5/cGOKxVIPB
	ysIJQvZOT+ThABkK0AHOiGHev5ORUNgITXygAZcQTphyHnulI0dSab4HDLrxk6hqGIfMbtZ6kpM
	laycy4HHldyBP0PimIuCQYZNOKI1Zoe3tKx79MkSr
X-Gm-Gg: Acq92OGF+Qm+67QYft4C8eNOrflKcSG40+DTfZnUQXkeRgM3LOg6cte12Mh9U93fRU7
	H0CDRkbQQtZ1Kmsr68Ru5WL/FjeRnFQT2BzeHbje2267RlkQ/tA2opk0xxCvqsgjvmwj7rJJnEc
	BR6vAR8YDzgXCEeDMcvJli/TgntdJt7gXxJq2csfAlNJByTpev8mLTWXH+EXD5pArJQqRmnIB8O
	afjAWMpV+yNoaqxsBMqZcLdfgboy7VJNTexv3qpyUU7yia5/67nRqkYpregK5BrjKwPNYljpTGS
	cWK75vBBYJ/kADBgSfBViVjU4Xnt4Pm9WbFBCc/9QjsDsyq4
X-Received: by 2002:a05:600c:c094:b0:490:ad43:1efc with SMTP id
 5b1f17b1804b1-490b117cb9amr46555e9.9.1780337103964; Mon, 01 Jun 2026 11:05:03
 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-5-jiaqiyan@google.com>
In-Reply-To: <20260531055829.3636554-5-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 1 Jun 2026 11:04:52 -0700
X-Gm-Features: AVHnY4K8T0QE-tcz0RP9-ZFUdQucNWYZ4iD9XVvZ_XIEZThfbUMxIz2in1vMass
Message-ID: <CACw3F53QVfirQDeHVWCALqRQTkV_+E76wcyBicbMtMr4FiT3fQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] selftests/mm: add hard memory failure anonymous 1G
 HugeTLB page test
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2411420013
X-Stat-Signature: niuhq9cq7srx1mn18rqas8hki1q9ygfi
X-HE-Tag: 1780337105-706143
X-HE-Meta: U2FsdGVkX18gG7F6EuyDiirQmCaGa8cZIm2P9jj3ZKk6PI+dLn3VH9bCTEoBAMAqZRfD6JyAAQwxDQCe+O+IwNpLVCGDkXcTeDMtnbjZg5dzBDZI7QjnjGtqees+2ZchMOf9ZOAmscOzvaofWiFvFbxTKplZeYqsXK2vjrHVAXLZ1oJyMeNAsEA6+Z7mYnxZiUQ2IAaH9NWaz4ysh2TK9Sn9EZAAN3bSmW3fVrwRZtgDbZGyGnwZ+D+53Zu//kaqWIIxrPPYAIZskgbUEii+MbzzEw4HqMIxLJztO08lxw7LdE8gji89TQk0R+EECPHwZ42uJg4ODn9kkJwG/H0M1yTx5ruioAmwkp8mqO3GmBUJm1rvmFrnGCCuvukD3l+ADR0TYLUzL0i5m7M64qFT/Nfwqnw7zYRP8DtbfmhQB6yrxuKEKVqmvBvVcARXPK6P9pZBkTn72SrU44KgD05qwMS1T1px08lJHE+ZMqH1gdQtigLWfefPFGxNtuovOIxmWurqXKS2fBjddqJx9O+EuVlNM6gTbv4DTbyaa/zevbAAt1KPwFPuQ1pHx3jBwW9HnvUHrvQVkr2lWwVBqXFN+jQwr0m55pys13yx5phaKrbGL9tYox0X0eQqIUFbt7BX09ZKLFlp5O0LLT2+BluR164wdNqUIwJkn/NvYiIBb1yEPKFDrbcQmGzN1rp4uQbaeXnudS0FfBduYb2mgjlRgtl/99sPU/WfynZ4KdpN46e9ym2deQNPQb+1q31ns297ec9fIlF/qffJRrFgwf605ZHPZvpiod+v6VXonu1UiP9yfnS/2rYu9KF+B1iYnauotCCztno6aMKAjeE6DuMGYqW5kkgmbkha9RTTCX8aMI8CE0elFZ3+LCEmTfYY4Lw0wa4ZSo3N/L1Qoiube17msIa10AUFNzT5Kgy2aXr/FFTYaOj5pht160erojUW8oJMgaxXjtmWdD0cPsg1hxl
 HFW4Wlk2
 wZ7iZJQv9x8pftuDqv3XfWIo3+ZdpS/SQcapy41CubxTU9dYl5IZw1xXxtLGbesPxjwotGDXaJvX/Fg/dZvwfWJLxyMMmeqet3EwUHItrQV9X919BXFqvxN0d9Kwm9cjVYZcmvUzge82QOQnLSmg2cc2cYWBdrdDURJ2g6tXwwOnH7hqdWj3URKnst78R+bWiGP27vWgHJHOWecTCGy8DLPHAp96hBHCcB/xQCTCVtFt8wFwEe/tmUJnZDu1xwFhqTWoA0/ILqoRo3vegpxXo6GJrlgFitj/GHnAt/508oqtsAZpm+t61/uEHJQZDYs4MUiTsGaUCOEcfnESvmc4pYHzn3iibLoMhcehJlINf807lWaFstlSkujGhHSYup2wmnJr74a3S695aneY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the reviews from sashiko
(https://sashiko.dev/#/patchset/20260531055829.3636554-1-jiaqiyan@google.co=
m):

On Sat, May 30, 2026 at 10:58=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wr=
ote:
>
> Add a new testcase to validate memory failure recovery for HWPoison
> anonymous 1G HugeTLB page, including proper SIGBUS delivery,

This test is no longer 1G specific, I will update the commit msg accordingl=
y.

> releasing a 1G HugeTLB page containing one HWPoison page to buddy
> allocator, and isolation of the raw HWPoison page.
>
> Although can be added in future, this patch does not support testing
> the MADV_SOFT variant.
>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 73 +++++++++++++++++++--
>  1 file changed, 68 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/=
selftests/mm/memory-failure.c
> index 032ed952057c..ea43b2877c81 100644
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
> @@ -157,11 +161,11 @@ static void check(struct __test_metadata *_metadata=
, FIXTURE_DATA(memory_failure
>                   void *vaddr, enum result_type type, int setjmp)
>  {
>         unsigned long size;
> +       unsigned long nr_hugetlb_pages;
>         uint64_t pfn_flags;
>
>         switch (type) {
>         case MADV_SOFT_ANON:
> -       case MADV_HARD_CLEAN_PAGECACHE:

Sorry for the unintended change, I will revert it in the next revision.

>         case MADV_SOFT_CLEAN_PAGECACHE:
>         case MADV_SOFT_DIRTY_PAGECACHE:
>                 /* It is not expected to receive a SIGBUS signal. */
> @@ -174,6 +178,7 @@ static void check(struct __test_metadata *_metadata, =
FIXTURE_DATA(memory_failure
>                 ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self-=
>pfn);
>                 break;
>         case MADV_HARD_ANON:
> +       case MADV_HARD_ANON_HUGETLB:
>         case MADV_HARD_DIRTY_PAGECACHE:
>                 /* The SIGBUS signal should have been received. */
>                 ASSERT_EQ(setjmp, 1);
> @@ -183,17 +188,36 @@ static void check(struct __test_metadata *_metadata=
, FIXTURE_DATA(memory_failure
>                 ASSERT_EQ(siginfo.si_code, BUS_MCEERR_AR);
>                 ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
>                 ASSERT_EQ(siginfo.si_addr, vaddr);
> -
> -               /* XXX Check backing pte is hwpoison entry when supported=
. */
> -               ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
>                 break;
>         default:
>                 SKIP(return, "unexpected inject type %d.\n", type);
>         }
>
> +       if (type =3D=3D MADV_HARD_ANON || type =3D=3D MADV_HARD_DIRTY_PAG=
ECACHE) {
> +               /*
> +                * Check backing pte is hwpoison entry when supported.
> +                * Although try_to_unmap_one() also installs hwpoison ent=
ry
> +                * for HugeTLB, pagemap_hugetlb_range() doesn't parse
> +                * swap entries at all.
> +                */
> +               ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
> +       }
> +
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
> @@ -247,6 +271,45 @@ TEST_F(memory_failure, anon)
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
> +
> +       alloc_size =3D default_huge_page_size() * nr_alloc_hugetlb_pages;
> +       self->page_size =3D default_huge_page_size();
> +       self->nr_hugetlb_pages =3D hugetlb_nr_default_pages();
> +
> +       addr =3D mmap(0, alloc_size, PROT_READ | PROT_WRITE,
> +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
> +       if (addr =3D=3D MAP_FAILED)
> +               SKIP(return, "mmap failed, not enough memory or 1G hugetl=
b not supported.\n");
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
> 2.54.0.823.g6e5bcc1fc9-goog
>

