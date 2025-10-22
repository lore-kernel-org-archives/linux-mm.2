Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F54BCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4838E000C; Wed, 22 Oct 2025 01:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7655C8E0002; Wed, 22 Oct 2025 01:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8648E000C; Wed, 22 Oct 2025 01:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 596568E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:49:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 178D91407A3
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:49:38 +0000 (UTC)
X-FDA: 84024673236.03.7AE2B50
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40253140004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:49:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bKrxyP7G;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761112176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QF6I12cmNwQJIE2Ooh/PoCg5Zdy7/MLhY3n+XRHHRpU=;
	b=dTYe8Aku3CeLZxMxUutxM0Q2hDwZCNPHgcL/NHQKAg2qHUyNFBh0HbxePMWUDx06ioDqAR
	03hr4IDciRgw5naUp1M9U21r5O08n+cfMuSHXx401SHFKPtlYgm7wD/LjLng2PKtYhC6zt
	s5r+W9bkIqDWxyLK+rT/vhgq1BQwDy8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bKrxyP7G;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761112176; a=rsa-sha256;
	cv=none;
	b=Vy9T3gGB4UtRdJk9Evpj9WIt6OuKF/om6OIKHVw/TJrvnTfIm5Wng15UDtHeGYjSGNfcOM
	sAzldZv3eZBW5SZTVUnFOcicmmFUMTNKWv8PeJg/SLikg88e1LObb8BVAppeLCxUz+O3sl
	4+y+DCCAYveklGPE8U/1OIw2dB2MdJI=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63c4f1e7243so6148122a12.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761112174; x=1761716974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QF6I12cmNwQJIE2Ooh/PoCg5Zdy7/MLhY3n+XRHHRpU=;
        b=bKrxyP7G/RX38RJ6GfKUIgxpdbM3L4IiahA/Uzxeh5ZErtfoEEZUhEU6v5I1eJnICk
         O789D5KPVUiiqSzVgkwyVl1qBRysRrRZFGSsJ3PtUJox1OogXqi/IX3MjcGBCGOFgn1/
         MvaloRKIc+hZn25t+OvtIMjQXJfxAYklRWpqQ1N/XiYWY1faagUxkqUC51kMQzouIKyb
         oxBJBF5SXOljTmVKyNRXTwdkZAnTwv6Wp+jS0gyABOJU8PlLcOfyjsQXlpg8eEKyNod5
         IIbxy04eH3LdmcYDuLs9KnszM2Hq7psPoxMh+BFlem50D/7MYbfcpQp6bI1rc3adOTqu
         WWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761112174; x=1761716974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QF6I12cmNwQJIE2Ooh/PoCg5Zdy7/MLhY3n+XRHHRpU=;
        b=BWTiqRmTay/cVSo+8hF44Gr8TN+QRfaMwhl2ECTgIhnq52wAv/xjWORrVLTb0iufjD
         AexgC40dWo3bTrDZ0AENZUMoKq5u2k40IzzZ0CJd9K0UaQl6mShBXGVgHI9GT/JMA+eq
         4LA+V3uBH6HWNj2/Q1jVQWo8nzrWOjrbxs335+S7Fh5+SgJbW5+MAEOzS1IiPlsKvMcR
         FC2sfntQiBZ5YRLE3fZn4IHjlpU8ALzQjWeB4OhmQNxxYdZzL0xcnxkrItGeCaudrT8K
         8I6gpQ/qqhwIE7GZzZcJBJzU6wIWWxxzNNNN0EDsBfcol3BYmjetKHAgrJBAihAgu+qx
         BWtw==
X-Gm-Message-State: AOJu0YypXv+GS1dZImzgTyA0/Ps/3K7e8OXnXQiv1cdcr6LyGg9eXUZq
	X8WZqOKKiDEQYtTM9UArTqnTZBocQC9UcbZGtIT8KhvGX293y/W2rCMN1e9f9grt2TaY6G8Dh87
	SOsA3DT0yM+0rXkC/LHXNYqVDqV+z1GQ=
X-Gm-Gg: ASbGnct5tOh6ElMOTZojrGd5gJALv8W3LMcIJqb288drXh/7+hRgQFR79rURzfjs6AM
	5/JV3zjZSzjkoCV/xnkjP3BUOGjEUAthOMNAnPdizoyF8fEtUwlxge2LzePQhIk3ZihNZVRkmIZ
	FnQcbU8ZG6AtCH+z8yAY2vClRfhwY4GOzGSXseRw681CJZRZez3gJSZtgqfkzmnTANcHVEzdgcJ
	lXgwP+WX46xUrbAdncKjD81ocLrmELAFw2GHCPlNtVKebd2YEsa1H9plWhQ4lHuwuEOS9g=
X-Google-Smtp-Source: AGHT+IEL4L/n0/KZ2//izEt50x/P7vjrecEoRquGYRoVdQ4a49sx5DhBJ0rYUtgsnqQLisHd/Or3m5ShhudEHx4+ThI=
X-Received: by 2002:a05:6402:5189:b0:63c:3efe:d970 with SMTP id
 4fb4d7f45d1cf-63c3efeee6emr14892034a12.31.1761112174303; Tue, 21 Oct 2025
 22:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20251021190436.81682-1-ryncsn@gmail.com> <65f4dd0b-2bc2-4345-86c2-630a91fcfa39@linux.alibaba.com>
In-Reply-To: <65f4dd0b-2bc2-4345-86c2-630a91fcfa39@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Oct 2025 13:48:57 +0800
X-Gm-Features: AS18NWDTFF1efA6O66Kmu5sZvMNxApkc4VVj3WyF2eIjSrA0fBYB7cddYTfIxRE
Message-ID: <CAMgjq7D_G=5bJe_Uj11sHV2qCyu-Z-3PZu7QuZyPEhuFiE63wQ@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: fix THP allocation size check and fallback
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Dev Jain <dev.jain@arm.com>, 
	David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7m8j7ycd7s3kw8eihez9xmuatq3jy1aj
X-Rspamd-Queue-Id: 40253140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761112176-549122
X-HE-Meta: U2FsdGVkX18Tto7Aa3oq1/KQVdEdmsmR/PWi6Y/Smh4v2DvN44SJGLhCC9RRzA7WxsxHiNqcErJUUaEaYhB72FVTIUhQk9LQ7zFbXvJIV2Cz9pNV2Jwb1GCrZ/DdyvEbIrCscCYQSkFqf47tzTeyEBGleEJ/WmjNp8YIGGL4HSEkuhIXjwnCer5AIUYgvyv6XCCBITPDLw0DliMc59xpvZaQAJp7zLOCgGi9vlIrVjxnVCnVqyiUvhs6IBs9WngtqEDV+3GhRMa3ays5BqvTwYCEOgjlWP22oZmBbK0kl2BICgwj/FpgSBBMaoTj2PUh7BljmBRjIFmFNyNmyIJ2VkrZf5OijiyXQU9ey78my2ytiXccTDapAyx/e46fdmIbkCdjFSMZ+cjTeZNPmPTPfNotX0beNHroLuG8kaTUGwKQAxNOSGTl6Ugw3S+to4tHclIokDmbrwpVcabCK4P3+E/l/W8kVt5Bc+FoVhjwrwMMJNJwD+HBcgglBdapvYVIq4lXwMMRtNmxRwm3uXzN874WLNJt+GjGLH3n2qftBuhwTORhN4fNb9Hssr+9BE8Y053ZD6tDLL4Q7Naj1f7+4/mr06Hvv57MD6fqd9zrwHkVToz8TYY5aTnsv9yEMy4pG1ermi06nG9DZwoFTpbwk3BbxaFiMBtTqxcJ2uON5pMrHaf47YekWqEUHfmzQEKCqNxf+Dax/Ef5JQ0I6eTNA3ZWl2NiHCPUIlJvi6BiCG2xHWOaiqpnQroLKs49AGufH9H14z1yT2hKl9JtlSEPw8y/e4KBhq7jNimLkhf6kkpdbJk2PhTDO6OFDrANBIl5z+Mps+K5irlkC5li9OpjyxYj4hxelCF0T4F2lHA2Nn4gbeWjK3062DOGPefwiMFfEsDyFnbvQAK9YgLDwIq8mxta05rqF21dh6M+LYpYVwvuTtxNNaZ2z74+PjaLL6YJX0nYJywrJ5GbDBahoo1
 LJyesQny
 VlWx9fvzKiqR/n78Q+5v7ms3oMMnrKQasTCi/QFoLPJkz6iiap0TS/ebzxYQsMfqEf5QBplT/50Ec8N5WQuRlUyzIfP7+O2k8C/hUzfzvMyYyj60FU/0t2g7MCG9XWpJIaJ3/ejRmaX2aNDzdbHl50LBqwtKBfYW5ia0hcXFE115jLcH6pHv6W5rc4IUTSQuWOs9SYTGET+hHnzscik2bOQfsbTfclMDfZL7xSpcVtVsyM4724eHS5h7wfV0BRJM7POuBryA8KnOJSejdkekVKounJN13Re8d4lzW4jCC2v5Bh3CsZmTi7B7NNDT2fa3ajPQFUTff29VOKto/9bPuxYvNO+kIUkhGH/daQJ+/tJondfEhLYS5sQdR5CTvHaN2xUq1kKEAJvhachiJ1HMGP1xURQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 9:25=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/10/22 03:04, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > There are some problems with the code implementations of THP fallback.
> > suitable_orders could be zero, and calling highest_order on a zero valu=
e
> > returns an overflowed size. And the order check loop is updating the
> > index value on every loop which may cause the index to be aligned by a
> > larger value while the loop shrinks the order.
>
> No, this is not true. Although =E2=80=98suitable_orders=E2=80=99 might be=
 0, it will not
> enter the =E2=80=98while (suitable_orders)=E2=80=99 loop, and =E2=80=98or=
der=E2=80=99 will not be used
> (this is also how the highest_order() function is used in other places).

Maybe I shouldn't mix the trivial issue with the real issue here,
sorry, my bad, I was in a hurry :P.
I mean if suitable_orders is zero we should just skip calling the
highest_order since that returns a negative value. It's not causing an
issue though, but redundant.

>
> > And it forgot to try order
> > 0 after the final loop.
>
> This is also not true. We will fallback to order 0 allocation in
> shmem_get_folio_gfp() if large order allocation fails.

I thought after the fix, we can simplify the code, and maybe reduce
the call to shmem_alloc_and_add_folio to only one so it will be
inlined by the compiler.

On second thought some more changes are needed to respect the
huge_gfp. Maybe I should send a series to split the hot fix with clean
ups.

But here the index being modified during the loop do need a fix I
think, so, for the fix part, we just need:

diff --git a/mm/shmem.c b/mm/shmem.c
index 29e1eb690125..e89ae4dd6859 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1895,10 +1895,11 @@ static struct folio
*shmem_alloc_and_add_folio(struct vm_fault *vmf,
                order =3D highest_order(suitable_orders);
                while (suitable_orders) {
                        pages =3D 1UL << order;
-                       index =3D round_down(index, pages);
-                       folio =3D shmem_alloc_folio(gfp, order, info, index=
);
-                       if (folio)
+                       folio =3D shmem_alloc_folio(gfp, order, info,
round_down(index, pages));
+                       if (folio) {
+                               index =3D round_down(index, pages);
                                goto allocated;
+                       }

                        if (pages =3D=3D HPAGE_PMD_NR)
                                count_vm_event(THP_FILE_FALLBACK);

>
> > This is usually fine because shmem_add_to_page_cache ensures the shmem
> > mapping is still sane, but it might cause many potential issues like
> > allocating random folios into the random position in the map or return
> > -ENOMEM by accident. This triggered some strange userspace errors [1],
> > and shouldn't have happened in the first place.
>
> I tested tmpfs with swap on ZRAM in the mm-new branch, and no issues
> were encountered. However, it is worth mentioning that, after the commit
> 69e0a3b49003 ("mm: shmem: fix the strategy for the tmpfs 'huge=3D'
> options"), tmpfs may consume more memory (because we no longer allocate
> large folios based on the write size), which might cause your test case
> to run out of memory (OOM) and trigger some errors. You may need to
> adjust your swap size or memcg limit.
>

I'm not seeing any OOM issue, and I tested with different memory
sizes, the error occurs with all different setup.

If I compared the built object with the ones before 69e0a3b49003, I
can see that the build object is corrupted:

Compare using hexdump & diff on any .o generated by gcc:
--- GOOD        2025-10-21 12:17:44.121000287 +0000
+++ BAD 2025-10-21 12:18:01.094000870 +0000
@@ -3371,425 +3371,7 @@
... <summary: whole chunk of data & symbols missing> ...

GCC compile didn't fail because the problem occurs when writing the
objects, so instead LD failed and not due to OOM.

The reproduction rate is very high with different setup, not sure why
it didn't occur on your setup, I suspect it's related to how different
gcc handles write (not fault)?

Revert 69e0a3b49003, the build is OK. 69e0a3b49003 isn't the root
cause but triggered this.

The minimized fix posted above also fixes the problem just fine.

