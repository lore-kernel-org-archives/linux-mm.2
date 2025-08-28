Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB68C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5E08E0003; Thu, 28 Aug 2025 15:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADE48E0001; Thu, 28 Aug 2025 15:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C45E8E0003; Thu, 28 Aug 2025 15:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B10B8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:59:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF1FB140392
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:59:06 +0000 (UTC)
X-FDA: 83827229892.15.E60E188
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id D08D5C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:59:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=slgnR0jg;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756411144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rb1Ys+OS8pMllVi9x1vwj1VWFDJ6Jd401gcPHSeVaJI=;
	b=hvWq9jOv6dHmlmwh7/2RDJr0XfaEGDgH97S9QEwveaaM6OfjmTr/C/7LQS9MMNhofoU0Hc
	TiAtmvDxuuah0WORlZ6ZAl0KInN4zzksBPYJEZWsKtlcjYFrfLBqh8h6iAhbaPUsLTgUKr
	ymIhbEkcC0GK29lYw0kizbdtqHWKMdo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=slgnR0jg;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756411144; a=rsa-sha256;
	cv=none;
	b=o4gYX7zfEBx4nyGyDbYliltkUXFIGGd4DGxkhCwjKjccg1T+y65bSXxBMRw/P/gW4utEjq
	H04FXVQKUUC4FjRpqW7sLUmN7jcVArc4i7fCL+ua70vMfMxvwLOrsryDjgdMaaRzbijcaC
	toIqQAT4Mi6jpGGpMqMxxxV+GHbzR8Q=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so23095e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756411143; x=1757015943; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rb1Ys+OS8pMllVi9x1vwj1VWFDJ6Jd401gcPHSeVaJI=;
        b=slgnR0jgtpgkk82ONOb19qNdpxmJqr9nlp7tMvlzpgTLRrqqad/LcMxe8dSejyErxZ
         Iukfh6QElBbdOKQOMvpCiIBWceAET/htTn4/ZnseT642VV0MSZbwRCbmqdTeVrpTpTED
         q6/v7b4urVuIZE1NqB4jngrJfNeQ7shcsELnyUj4mnNnpjH5HwCID2Rn5TPeEMR7PNUV
         JCGANNYlvlvERil+gWw/1ZS7CeY0mHU4xm8ItonW7cpIJfExTM3m6/KbdXAnxoVdY/h2
         /eBX6kUu54RghfP8HeOH8uZXe/d7WZ2omCv2uy4HNcKHUmebZroRGnazyzoHXlWRyUo8
         m+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756411143; x=1757015943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rb1Ys+OS8pMllVi9x1vwj1VWFDJ6Jd401gcPHSeVaJI=;
        b=nUoOK0SN9IiHn5imbbzuZyMvwpSUFe6DBbUm/yTo0av9VLbdrDFCz6jxUCmUilmFBu
         kypy/B0c+aO+7/kxWVYG5CoWyOeNwfwQ2vcEBQug/Tto8k47I7YfWNowsbVxCN3bATZI
         ol8D5ToGcSute+yaqjiqFOKKkrahN7alzou9A3Lh3SOqZ6VrQ9sqjK1Jhzx3DAnyX0KO
         Kge7o3m62pgLnj5QmSQVOQ07Uo23GQc4WwA3ThZPqgTnWvHsb9Yo5h6ZT8PCDCq36Fyr
         kVjCf2SW7wc7YdAOOePBRkMAXcpnV6mvXd+mWED2mU4niBWbuUSwwCv+dtFMVwBrpwjt
         dVkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL4zz7n4C9qjuilvh6xHj2W1HqFdAr6wo4J15bfhsyyq3FU3xsxHmAhvuIoyF7cXW4/kwh/B1GQw==@kvack.org
X-Gm-Message-State: AOJu0YyOY341Rv3FbatZYRpYGCXCDk5QiyZl/3/VyY5wFwFftsV6x59G
	lXjSa21gset9nW3qoTMN+o5Eb0cWuCJV61AFXGMd8XM+bwMzO4w4BHgLxtQZfz88MYs5liTnpRe
	fL+G5azMYetNFpaBUyxlf/PrNFEL6s7rD+aYcRVnW
X-Gm-Gg: ASbGnctYUREYP3FCw9Ci1SvY+l7bFnc2+DP5iR6Ec9/kkNxNXqICiGMjhmKBNhlcu3f
	JC4bNg608W0Sf+B35Gqs8vZTe+NFjl56vUL/CaleJpOO9CITc1tOp1nEUzdgQFcXDW8IkwNZ1CG
	FK9oagEU6kE+EvJwwN1fouymNICQWhg13qKa6naYMh7z6Ws/wVzSoGcICeCW5q/LqOAIuzOQQu3
	kBUeIFU2DyamVSMCV4jh7k8LdJ1yY7ae1vlD3INLZLF
X-Google-Smtp-Source: AGHT+IELO4yISZz+NofHK6C5sRr8016R68b1/4gVNR4ZG7rMts1wuKSLEVBc8+N5qzn2cwo5rC4hEXYji1cmxRvYCnw=
X-Received: by 2002:a05:600c:8219:b0:45a:2861:3625 with SMTP id
 5b1f17b1804b1-45b65ee0f36mr6131575e9.4.1756411142902; Thu, 28 Aug 2025
 12:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <aLCiHMy12Ck3ouwC@hpe.com>
In-Reply-To: <aLCiHMy12Ck3ouwC@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 28 Aug 2025 12:58:50 -0700
X-Gm-Features: Ac12FXzKI2iUWzk8A5Vs745uV1abRMo4VLeJy6UKcLM1l6gTfbZW8s4ZlI0mr68
Message-ID: <CACw3F50kFq4V9+-JUdi+PEYbNUkOJZHPOy4VCowhKXW-sB=Ugw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memory-failure: Fix redundant updates for already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, linmiaohe@huawei.com, jane.chu@oracle.com, 
	bp@alien8.de, david@redhat.com, Liam.Howlett@oracle.com, 
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, nao.horiguchi@gmail.com, 
	osalvador@suse.de, rppt@kernel.org, russ.anderson@hpe.com, surenb@google.com, 
	tony.luck@intel.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D08D5C000B
X-Stat-Signature: 1yjjk7x68puckh1aqqmdcct7ozyzhn1p
X-Rspam-User: 
X-HE-Tag: 1756411144-824924
X-HE-Meta: U2FsdGVkX1+b5sx96JF+OwSkGdVv+uGzDvuPwEJIDDW3P+Meto9qDutGdWuL5rNLOpM6JlRQBra2PtQ7RNsCYIeM+FMll5xMEq6sq1wBPsdy/3mAEJBaHzCVmkTMwe1rKqMhtEJrP2E1Gy4fS2BWggrVVukIoJbiHKA06g9cTm0lHMKHKjkKpq/bbRFrcGJvrxkRSHJg95aGsV082vtDUfY57AaeaTuHLYWwF+faroHRPhyhUbO5J5k0QYG5ipwXdmVDDfgfOY2qV4z3jKhZXBfNNohp1J+OmqZB4GSh0rFbHh2GJ7qceghDzQgPpVZ2SmLI5GgaMPDiukoleG4SMddEm4slJZFTzwxXxo3/qtROxaUXoDDwNzSWjZFnHJJUMqkzDjd4Qax5Q8Vy3Cm6DkodFCF2D89z9uZJPv98v08ixYOzawUVR8ONe/tp/i4LDRVJKnK3Vv9mMGtoi5uK6F/nUkpU6PPFCNzpYXrEHyk5s7vrEL8mj7kt+u75C+q2nk7sSRsMNmxhgHQv4QmpJ5oQ46AHr7q4I8h5Xy/dW5SclsUECXYS/8B6dONP0WtwfawpPKSFjyPJE/z04PEEYszCk9FkFEYOVEDNNZLO9im/fi/ZXa0JMdeNsHCpxNAmRQRGtN/KkKjaRizX4NwYAs+O41kNwNcLUA/mkawCCtCLPZPKpD82L4MaLCSNwxa2k0+eMsWVnR8CsqiHSiMRv/yvoMfkQub/l6cqNRKW4sAvn4Sc0eFgnK+ZfwUT/C+lP6lzdzgXXTZnOtwPGb6mMBKL9UWg4zgKCZ9BmExaJsMAAiw/ffPVJ6wiUtfI3UYtr15V/L4dCm5n4DdnPpdGv0UhQl5lUf4WxmQQiEzpkKBEwNnMLfhU79WzpWdlBRRWRSnJ+8GVspfpHEIhcqMW3rpJIorS+2ZU9OqrhMzxlGqEQBMBu+Gs8K7LEengv93RvxaYMpD+SYNo3e0k9zO
 WZED1rav
 qALI+Ue+X+UHDVYyYVeswMqEaPk9l/K7XXvr5TAjufE7ALKLKvbXxm5HBdGbfEhmEXwJsQ63shblovBOqGO2zEpCQwxNLTaqMA/k4zurJ6TZnVl8heMCxgGFlWT32yRh9VNYzzbBrhYnJ1w/JZ4YoIKQ++gbTdZsA7dnIeqeFnnMxMmFGY4ezQ+HqZ26qECTlppM36e2AdUgVrSOkcB9PlWa0xLgdfVVKdTA8NJe1eCuimnujci7rtCSpP/5xIf3HeSKy+P0FWUc98yFtkkknfuP4yocBqwPs0KRDPtmX+nCl3rgbpkzFo3tXdCYrzLeI/GMWuVTb4kPsvRQgGBwH4iAcxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:38=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com> wr=
ote:
>
> Duplicate memory errors can be reported by multiple sources.
>
> Passing an already poisoned page to action_result() causes issues:
>
> * The amount of hardware corrupted memory is incorrectly updated.
> * Per NUMA node MF stats are incorrectly updated.
> * Redundant "already poisoned" messages are printed.
>
> Avoid those issues by:
>
> * Skipping hardware corrupted memory updates for already poisoned pages.
> * Skipping per NUMA node MF stats updates for already poisoned pages.
> * Dropping redundant "already poisoned" messages.
>
> Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
> make calls to action_result() consistent for already poisoned
> normal pages and huge pages.
>
> Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_re=
sult messages")
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>
> v1 -> v2:
>  * Continue passing poisoned pages to action_result() with MF_FAILED but =
don't
> update anything.
>  * https://lore.kernel.org/all/20250821164445.14467-1-kyle.meyer@hpe.com
>
> ---
>  mm/memory-failure.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..10b3c281c2ae 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -956,7 +956,7 @@ static const char * const action_page_types[] =3D {
>         [MF_MSG_BUDDY]                  =3D "free buddy page",
>         [MF_MSG_DAX]                    =3D "dax page",
>         [MF_MSG_UNSPLIT_THP]            =3D "unsplit thp",
> -       [MF_MSG_ALREADY_POISONED]       =3D "already poisoned",
> +       [MF_MSG_ALREADY_POISONED]       =3D "already poisoned page",
>         [MF_MSG_UNKNOWN]                =3D "unknown page",
>  };
>
> @@ -1349,9 +1349,10 @@ static int action_result(unsigned long pfn, enum m=
f_action_page_type type,
>  {
>         trace_memory_failure_event(pfn, type, result);
>
> -       num_poisoned_pages_inc(pfn);
> -
> -       update_per_node_mf_stats(pfn, result);
> +       if (type !=3D MF_MSG_ALREADY_POISONED) {
> +               num_poisoned_pages_inc(pfn);
> +               update_per_node_mf_stats(pfn, result);
> +       }

Thanks Kyle, the code looks good to me. While you wait for Miaohe's
review/ack...

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

>
>         pr_err("%#lx: recovery action for %s: %s\n",
>                 pfn, action_page_types[type], action_name[result]);
> @@ -2094,12 +2095,11 @@ static int try_memory_failure_hugetlb(unsigned lo=
ng pfn, int flags, int *hugetlb
>                 *hugetlb =3D 0;
>                 return 0;
>         } else if (res =3D=3D -EHWPOISON) {
> -               pr_err("%#lx: already hardware poisoned\n", pfn);
>                 if (flags & MF_ACTION_REQUIRED) {
>                         folio =3D page_folio(p);
>                         res =3D kill_accessing_process(current, folio_pfn=
(folio), flags);
> -                       action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FA=
ILED);
>                 }
> +               action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>                 return res;
>         } else if (res =3D=3D -EBUSY) {
>                 if (!(flags & MF_NO_RETRY)) {
> @@ -2285,7 +2285,6 @@ int memory_failure(unsigned long pfn, int flags)
>                 goto unlock_mutex;
>
>         if (TestSetPageHWPoison(p)) {
> -               pr_err("%#lx: already hardware poisoned\n", pfn);
>                 res =3D -EHWPOISON;
>                 if (flags & MF_ACTION_REQUIRED)
>                         res =3D kill_accessing_process(current, pfn, flag=
s);
> --
> 2.50.1
>

