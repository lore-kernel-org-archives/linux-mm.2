Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A38CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 18:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BE58E0005; Tue,  9 Sep 2025 14:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC2C8E0001; Tue,  9 Sep 2025 14:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12BC8E0005; Tue,  9 Sep 2025 14:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B41F8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:50:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B59C13BA68
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:50:20 +0000 (UTC)
X-FDA: 83870602200.01.3B9BFAF
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 500211C0010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:50:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w2FGC4oE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=zokeefe@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757443818; a=rsa-sha256;
	cv=none;
	b=HhiGDP17s12KA70zjCFJlozbjLSA46Xd0Yw81QzKpvswML7sPsgDskT21z7nfbV6JUPHsX
	Nkh2/P8ldrSyET3XPwMc0GVHVEyB1HecDwQcH65nqbztFbdnHbWCfwuUcMt54H1BcSZDef
	GO33qp3Rq1yd6ORuuhk+pc4t3g7i74E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w2FGC4oE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=zokeefe@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757443818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eC3mUBzIF335HxcW34dFQJ7jnn4NSV7DuTmu23IsQDA=;
	b=NnV0jdsD36/aI39ppVQ8/Qq7tIvFVU/Rcw3CwZbfvDreu/54tyYEGyax0ztw0fdGQqyNAt
	rKz7UvoM7IkeHjgTyd8SJNfjr55keev2oWfBs3fv+Gg7Ix2R1Z5vGzlZFhPBFrdcFIASRh
	vMvXqS3/X2LxLwBY8KendY/OQIsGPLo=
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-408c236c500so32705ab.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 11:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757443817; x=1758048617; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC3mUBzIF335HxcW34dFQJ7jnn4NSV7DuTmu23IsQDA=;
        b=w2FGC4oE0fsVWUKL0JXna1fljIWPPhD5u4ULyLFIoG5VQDaikjBs/6Kz3LqNZqEOwC
         Y5ptNnewUhNFqzwBx0yCctWsOJa5yvVhano4NCOXgB8AYLcn5LIq/fg9Ojk68NimRCYt
         MutsLfUlgbSr4efpDd4Heak0Yi4NWHMIaXuLrnMfr6Chu7Uf37sC6hFT1U1dbGitlz3y
         cWl4HzjEHWrP0KQpZ4xYwMfHeqv7+2BKPKr3NLxfHYRP9kC8j0k57tvOma6qI2Dz9kig
         88O0AKhuH5Cfd9xoSQmM7fJRc+fsPAnsxYH+epFyx+qLrS/lQ9vO2J5C/E9r4iNvvBKy
         IHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757443817; x=1758048617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eC3mUBzIF335HxcW34dFQJ7jnn4NSV7DuTmu23IsQDA=;
        b=xJQf5/qpZd7+KE1rH7afQj1hXJe2w3D2aSlfeSdyAC29Ye7ZOcyMCIp1MGozdQHagb
         gdsRo5zh9r/sqPL2bntEc9b2berSy5RdrHXMdu++qPSATVzP/skZknA/aQ76ayA5lGJK
         ecjNU8sIHBHF2Fhh3zNkhITjqebqlqMidkDaKnPXVwMcGFjSZmFE3ba78L8YbedGTcF9
         wAjFAJZRzWEZLT9rFLTUxbZrBTZb4WmEogdxxUT4x44K0Y2euRgUvb9Ktyz+gBQD41D7
         whBSCXa0TwcF+WcA+Qn8pkGUr+u7OKIeH6LU/FR3RFb5DoGyUVfQHF3TM8pI1MjUXL70
         zp9A==
X-Forwarded-Encrypted: i=1; AJvYcCXe1qki3dX9PTFfglVxsR+AP2JsLoyDY9etQBm50jWvrCZJogiEuhFKvh3dPuY5xRy2lNGfuHEm8Q==@kvack.org
X-Gm-Message-State: AOJu0YwW+YtjCFRo4aLZWG3XPACBySm0RSRpVnEMKlONk2qfUeWFDz8j
	G2Zls/xq2WKvGCs18GJvw40vOTanf8gil23XMRJemJGtW2HOJoQ3vctpwfyEmhdL0PBpmhUp0rm
	gSnyeC75NPJY3OXEVA6Ijq5WFpwq5noEWsBli60Mi
X-Gm-Gg: ASbGncvWow/f4d2dC/LFloIQE6451LGZvcvvnbivCX7d9VFppvNDngnBCPo3frvbeMc
	S5652aAIsWlAerQQSeFanxhX1nzzZpx9SOlXjd535P80zgEBld+YO/2OUHmweoD0i8ansrfyZvj
	O8+QA+HKJbX3JSMAE5Dhe8AAmsDYVOT+W+HEpus3qYYEfvnjtoZYtVBpOVslaRrvZdK+7r5Aecz
	aeqY4MvbLBdPfs=
X-Google-Smtp-Source: AGHT+IG6p9OBV2LHpHJ2dnCTdEF/QlDlw3uEMnpPINTz7IGwtNn9XHfXL0nT5x0TVBBY4V1jajlMi/f/7FwLhI4UYXw=
X-Received: by 2002:a05:6e02:190e:b0:40b:e7e1:cfb5 with SMTP id
 e9e14a558f8ab-4164d86db7fmr699395ab.2.1757443816692; Tue, 09 Sep 2025
 11:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250908075028.38431-1-dev.jain@arm.com> <20250908075028.38431-2-dev.jain@arm.com>
In-Reply-To: <20250908075028.38431-2-dev.jain@arm.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Tue, 9 Sep 2025 11:49:39 -0700
X-Gm-Features: Ac12FXypQR8Ban_kXoWF6-UtTEU_BSzjrhtVgpc1eMzOq3TH_kElX763QBqhNKo
Message-ID: <CAAa6QmRtP9T8SVCVXkgLDtzZYYujh89R_FYzUanSckfe5znyyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: Enable khugepaged anonymous collapse on
 non-writable regions
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org, 
	willy@infradead.org, hughd@google.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 500211C0010
X-Stat-Signature: hmgm1gphuse1t9y1msoh79gtz5wimjyd
X-Rspam-User: 
X-HE-Tag: 1757443818-88853
X-HE-Meta: U2FsdGVkX19BGABkuaTX/mC28PxDLZi5a3vR+pHmfh4XFowDPIle14e/Owwq1Wd3tZw9DMUeLEKx9MRaCHV+ij31JXYTfSGfI/sCkDM5I0vk0vfwsFEpewdW1+UPJF3QiJAVX/QU/SNvAsI5KY6SVgWFtXYtseTVic0liefcjiApK2Kw0t4o58z4FBYQTIJsh8zP6+0fm3Re41QkJ2ueHCYlN83UgeiXcUBYVXL/kUvuD6uRk4Qp7wsRXSQ2ZCzkFqrwfm3ATJi5p5RlMCG3ZMx3Zt6fhJtjhfMnVQgSAN/vHpEqrdAOKemzNk6dkuqj67hRAq0tr5BrZBUffIGtCKBwDo3ycl1+/TeyeLcktdquCvn+/qS8YV4j81Li+Jsk80Vq9QmEVtka0HAgMDAEDZ3YvgBjvZaAjFuCfFaz+UXC0mre4Moxt3QaB9gHmPMnEtiqVes0KsspJl8g49HjFqGkZq9bktWlmovfhfKWTxNUqwFIzox3ROn2DzuSFXPeVztSlQnkYDTfgtL0IL5tkFheUc22WJlLN4YtRY9SzOYvtSTCbqgsIla2AGiEm4500BQJGoyvX/G4RIV+GmNlPEQYywOpL+/58g7tB0a7u0bAeqmXRp0/l/alofOENp7taIs4BPCknt4F33AufIl9UIil8jbYWLCgY+nU+D5OgaLMhru/5D4oWEcPDk+Zx4xI+t3QQuB2PLMy+wjagIs9dWwLqh0YWgO7UNXzCcdVBTaT3B0Iu7qXzh2cJ+hUdInjj6HpF7gnRHmcdu47/Sp5f9ghhRutrR+nOm3LqHVWIIaYvoOCpcdFAaomCLITZZNCjJ19fohRefgfh95jj5Hn/1z6+A2vWrhowXlMTqyEl9v0F4LgAlWtrASggqi0yYI5HGKVu7oI1CHZVCIU7GmeFep8wfaItlWt05GxSVURLsVFAcDDTAsRgg+UUZQUwlIOxqHx5obDMB0kyeyJEQF
 1ZPSRX2S
 PUryQGfNwRw3r4ft/hGT+dm7gBTfka2GIbU4pJ0rTN6ZKT/d3c3BCj9FVGXbvAsno84htMVccUBoSN3i9dFRScjz+7+yUgTt1H4QFW5mh5bblj2FCp8C7fbnLv5sTWoM79wbbuoxw/jy0bUGTkoddthRnBf9yjndyvQuskj8BIYnzOGFSUS/vdQeB0/j4NCezoj0bATR94GZVJ/JEsxaZacLvFLtG+I+m6lJgBE3Ln3r5y/Cbg/ejAZly6Udm5IXhtnB5aU60Psfx8SptFbKiji0B/CzxnzRHXPr4PEVT2hj1VF1cQC05La7IXL4H2qRX/uno7AgV/NyJ2zCJpKLIY2wV3ou0cLBYPSM4lkcfMw9LAwvD1fwqTXHS7oclZ284IsaBxC40q+l2Z0DW5wplAzCKfvfoo+fSfzYavOjqKeXjntucnS7PY12E6hbzZwAGMJhV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 12:51=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
> Currently khugepaged does not collapse an anonymous region which does not
> have a single writable pte. This is wasteful since a region mapped with
> non-writable ptes, for example, non-writable VMAs mapped by the
> application, won't benefit from THP collapse.
>
> An additional consequence of this constraint is that MADV_COLLAPSE does n=
ot
> perform a collapse on a non-writable VMA, and this restriction is nowhere
> to be found on the manpage - the restriction itself sounds wrong to me
> since the user knows the protection of the memory it has mapped, so
> collapsing read-only memory via madvise() should be a choice of the
> user which shouldn't be overridden by the kernel.

Sorry ; late to the party. Certainly agree wrt MADV_COLLAPSE.

Ditto for khugepaged as well. Check added when support for
non-writable pages were added to khugepaged, though retaining
heuristic that at least one pte should be writable;  10359213d05a
("mm: incorporate read-only pages into transparent huge pages"), which
predates max_ptes_swap.

> Therefore, remove this restriction by not honouring SCAN_PAGE_RO.>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Zach O'Keefe <zokeefe@google.com>

> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/khugepaged.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..a0f1df2a7ae6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                         writable =3D true;
>         }
>
> -       if (unlikely(!writable)) {
> -               result =3D SCAN_PAGE_RO;
> -       } else if (unlikely(cc->is_khugepaged && !referenced)) {
> +       if (unlikely(cc->is_khugepaged && !referenced)) {
>                 result =3D SCAN_LACK_REFERENCED_PAGE;
>         } else {
>                 result =3D SCAN_SUCCEED;
> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                      mmu_notifier_test_young(vma->vm_mm, _address)))
>                         referenced++;
>         }
> -       if (!writable) {
> -               result =3D SCAN_PAGE_RO;
> -       } else if (cc->is_khugepaged &&
> +       if (cc->is_khugepaged &&
>                    (!referenced ||
>                     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>                 result =3D SCAN_LACK_REFERENCED_PAGE;
> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>                 case SCAN_PMD_NULL:
>                 case SCAN_PTE_NON_PRESENT:
>                 case SCAN_PTE_UFFD_WP:
> -               case SCAN_PAGE_RO:
>                 case SCAN_LACK_REFERENCED_PAGE:
>                 case SCAN_PAGE_NULL:
>                 case SCAN_PAGE_COUNT:
> --
> 2.30.2
>
>

