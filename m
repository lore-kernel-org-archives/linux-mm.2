Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED64CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7F08E01E5; Fri, 15 Aug 2025 05:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551468E0002; Fri, 15 Aug 2025 05:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418E28E01E5; Fri, 15 Aug 2025 05:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF698E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:45:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D76261DD93B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:45:00 +0000 (UTC)
X-FDA: 83778507960.18.AB8464A
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A0561A0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:44:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gDJzZouN;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755251099; a=rsa-sha256;
	cv=none;
	b=c9vzkL1n7/VET7qZ5icB0BP6boDBzi8bq+RheozNU6mR82BQs0WPREbqOltZVtQvnDLL1i
	Du9TLDxv4c6OvVzM9Ve4McwnKOdaQl8q4xJLdg77p6d+ODFI0BofKs+RF2glmK6ZjsBYYU
	CObV96j+WdbvqGaOIaZFbtfPxy/qRY0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gDJzZouN;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755251099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWxDVNI9zWJDMw2/NzCN2d5ECLoC1ab46r5j/n61aEw=;
	b=w8Y5KSZjkB2OqGImZBUlMk5Jjg+DWAJ3S8b4SfViGx7BLL5IVdG9g+gnDR5zKnrkYQf8gJ
	pucqGPqp3ACLSSvMRkx2FJBVk6vNTJI+b6By0gdqw9AjYacB/GQugpixh4C/jKT86cd8Ky
	pAs0jeqOXE37thX5ThrAinZ3pFtUJxY=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-50f85ec0885so1332351137.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755251098; x=1755855898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWxDVNI9zWJDMw2/NzCN2d5ECLoC1ab46r5j/n61aEw=;
        b=gDJzZouN0a047osi6hT0gjnrsIzzgOK9eyiEyB/0970U9pl9wVtIsT+qhAjTbY1kO/
         ygOOdL1LNRMQ4533BWRKcFUqduwv4l7yFhEB+vmmUCNCKdFk9NYocqQZb+ia4Dt2nH0d
         mXvJXeEWnOUzsIYoSFEKGGQ4d1VN/b5sLnFrYcEC3Nk6Vzt9qRIoVxQlNG+ytsPDuXoI
         Zbz9W8d8uX9Jzk5FA29ahYGKEzfByaALAm/4JMoOOxbu1IYMafEiYRIfdQ/4+qQYwDvO
         X/Zo8hdjDDq0zOHdbBOucgJVqOp0mpbvh6uzzu2WjYTFXApOKpB1uQQvNhpOKyufSxYW
         6HIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755251098; x=1755855898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWxDVNI9zWJDMw2/NzCN2d5ECLoC1ab46r5j/n61aEw=;
        b=jzb2X4hzV8XzSKV67zX7/MR7ofR2DJNou9TPO8X7Gy0VffSknIERcnLmOkRhiy5sWS
         e6OJGfqBQPHq2ztVsfJqSS6Q3luUTcgRd893A7hW997AV92n0TTQpDTN3bLEqhXcztZ6
         YVRVTQvz7vJT7bFp7HsRUsD0qMKHZnG76Co/40VZjxZvWk8UtbDx6AsS6xjRiQtNt4iK
         Di5yA/YaRlsOQPgauGA1KJCuF6xQuK6Lx29P6QUa3A6G9Napzl/PPvkmrx38asNXBBp1
         hJMN+EwqX6dAkbyxI9GyGWKafJPELfHoBTNjNN6CliHe1pbJJ4XrvFpneUZrQJPbfrLN
         4p5w==
X-Forwarded-Encrypted: i=1; AJvYcCV3ByY9sSA9ztANzTvS8Y/UuEIABQtDMYFU2zmBzyszpnnLfcE8dpGWiBoIqMtKXJvJgbC/c9yXXw==@kvack.org
X-Gm-Message-State: AOJu0YzXt6xGG51INNC5WIjuY5cxr9VM4vbkg/lDmx7BMnvGYPck7dSH
	nnTKkN8qf6QTSWe3PpVp+VHfHxCpxSd7QOMcRTfJxI/tyMDpvsP7pY+4cZ4gbqhnRAkq9AzErVS
	fXBQkwZKjjRaLHeJD03MOaS1ORWgPPxQ=
X-Gm-Gg: ASbGncugZsxRNC0rDB3bwDDYxBIIA3r11+5+UqvlfZ6XS3/h7EJI2HzuQXsYSSz6Bim
	JA9RJYnVTH5aXIrlXa3+DdMMHWuCi3GsS/Zx7hM3FJZq/wS9C9SoSsYbJy5ApzHKJwtiPUw8XQ4
	jvInp1wLiqedKaUyeMbWZ9kvfUukYrP4Sum6Ir9Qxd1N5TG/+6WerUgWBcEulpZHFoPYXorL/Yz
	V7cXA8CPTpC4towokBEKPqpR0E+
X-Google-Smtp-Source: AGHT+IFFuOn0icKNoTW5k2DO+u5beiSHnjainhBGuGTUruUcvKzxOD6TN07/SDAAx0VUAv7dTxAzY+xEtBf/UX86WTc=
X-Received: by 2002:a05:6102:3049:b0:4e4:f503:666b with SMTP id
 ada2fe7eead31-5126ab24a39mr377560137.3.1755251098016; Fri, 15 Aug 2025
 02:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
In-Reply-To: <20250813193024.2279805-1-lokeshgidra@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 15 Aug 2025 21:44:47 +1200
X-Gm-Features: Ac12FXyOCWcNh-7-U1FVsYELZvOP82LK07VXJeTUcBSMT9ncmkxu_m4V3mdpv-0
Message-ID: <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A0561A0003
X-Stat-Signature: csmm13mcoyp9eryxqeuomgu5fwnjpp5i
X-Rspam-User: 
X-HE-Tag: 1755251098-692535
X-HE-Meta: U2FsdGVkX18KJmHlFL6u+okgJGWNAUvLluRwWJSc0iRiQcdOi9irulYPZCQTP+lE44k7btFa0tZMmOlrloh3I4pFAxSddMh4Ra9COI02153z9idpWrpBhJGfq7N6+HQ8ZozhazPgdihlVAbx32vTmldmOd0IT5iy2FLUAvAUXSAq/GbU8ySFBZB2WJxSWMfoi3nYOLbJzvw9KtJD1vBUW8K/5VpNPEc1XcaFXPvTgoQHX+bQaiszbQdz1PjkdnxhHLaVu6ypnYJyymPVgGE3k54nYpTfrvEq0uerR4e183ATXO1Li5TENqtkKvW0JCj6Bc+qPHsLQulBHQzOF2meBCjAOUXDu1oxIcYmYGaG69Xy6EYiIl3yVnoIY23bRVNI3JiDvDR+3xlDcnDRjNW1fH1L4v7e+K4KgINwyToWhyk/+Q8gV6SBO/iubDFUUvdSB2Xz9GyXSzzAwM63YNwuROH+YYkBkDZmXZ/na3nqOXIVf94iwwntVcbHIVclgXR28ldg69Lm/DLjTIJer4c2N7QqA9OmlDTa6B8cOwrM+B4pAMUlgX5si2CEubjDtp40KIVb7Hl44xh4/dT6a/XtMDhV2uUoU8Q4MnPTZIPBbLa3UFB9uXwz8XwBuV3bs3SBfYw8M5mneEZbnyOdU59EvLTnxqnGup9vdsujk2tqRQgCtZ8E6Zfxzy6Z0GXhhgqN/i9Q+0J72uo6sHxMtPKp5RwuMOmKY1D3jPUwArg3J3H43T+QX7kgbhX1UNJu0oKEDQmYzaAtchf2LLAKd7AI3TV4Z/MOUv5egrKB5dh65K7AoqYPJwvJwWl32Srbj+fmj6P8AsGhnXGxa+vFp+ilHQVc9Juzcj/xV2ZpvlZVFM6N2D6vlsilPCsgePK6IY2A9GkziYGQMJ3mQovg056QBh54udwc1B/QYW2ksfXLYGqUSKrFg1TaVQ/VG91/OuRhdEmAn4Qi8UMoCZJJVYT
 1u5GrxSC
 WihUUZAGTrAg0Tx1jSt9dYv6BiuCH334tAy9vxqyGMpVWFJXocFfJluo5qoGBZt+/DEhKAoqrI0phxly0LeNLc/o/YPN9lDKipSjqeBLUdEplwWEpS3ucVLOzgWRUN08lvzKxuyFaGtZSP5UkguMMLG1R2Sc0ATuvqXSwXhPsqV597uErYvUea97+raj2l/uIY5mjoiKquol29BdCqV65k7ugInxeOkEHAOh2GMMYnrzPzVF3+KpEBh2Jc2KcdWobjPHiAlptY1e8yqff9Sww7+4Pq3Ndmm+tJ+RA+i8rZ9wahVkQjox2dW6CPbdkayWq3bM3fuG7WpNP1d0v8MqwsCRKE525bDBFwQeT0icDuTH7V9qNL5bc8PfmhePfyvPgiT/d5WAKwGEKUP7FeTbB6L7W8RhQHdznijJLzJMnyqD0eQ0kpwqlOJwwVLrMWOyuTaKX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 7:30=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
>
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
>
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().
> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.
>
> When the GC intensive benchmark, which was used to gather the above
> numbers, is run on cuttlefish (qemu android instance on x86_64), the
> completion time of the benchmark went down from ~45mins to ~20mins.
>
> Furthermore, system_server, one of the most performance critical system
> processes on android, saw over 50% reduction in GC compaction time on an
> arm64 android device.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
> +static long move_present_ptes(struct mm_struct *mm,
> +                             struct vm_area_struct *dst_vma,
> +                             struct vm_area_struct *src_vma,
> +                             unsigned long dst_addr, unsigned long src_a=
ddr,
> +                             pte_t *dst_pte, pte_t *src_pte,
> +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> +                             struct folio **first_src_folio, unsigned lo=
ng len,
> +                             struct anon_vma *src_anon_vma)
> +{
> +       int err =3D 0;
> +       struct folio *src_folio =3D *first_src_folio;
> +       unsigned long src_start =3D src_addr;
> +       unsigned long src_end;
> +
> +       if (len > PAGE_SIZE) {
> +               len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr=
;
> +               src_end =3D pmd_addr_end(src_addr, src_addr + len);
> +       } else
> +               src_end =3D src_addr + len;

Nit:

Look at Documentation/process/coding-style.rst.

This does not apply if only one branch of a conditional statement is a sing=
le
statement; in the latter case use braces in both branches:

.. code-block:: c

    if (condition) {
        do_this();
        do_that();
    } else {
        otherwise();
    }

By the way, what about the following for both cases? Would it impact
performance in the `PAGE_SIZE` cases?

len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
src_end =3D pmd_addr_end(src_addr, src_addr + len);

Thanks
Barry

