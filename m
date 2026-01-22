Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2575C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C666B0165; Thu, 22 Jan 2026 06:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039ED6B0166; Thu, 22 Jan 2026 06:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87D76B0167; Thu, 22 Jan 2026 06:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D60AE6B0165
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:57:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7528A160297
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:57:08 +0000 (UTC)
X-FDA: 84359448936.01.0B9FB77
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 16C0F40006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:57:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XLNZTWOy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769083026; a=rsa-sha256;
	cv=none;
	b=TaZjYNZfNjzlbZA3qXSn5bG+oAAfz3axXlnCE9LzT/oHFPLGSVwSFNjMo/hZHuWk/xZ/zr
	NLk78Z3qYRSzlJh+ltw4QhqYbxN7oi0rY00E6q1N51nTi0ZgI3PgVnRDbROyBvUv+oUgfq
	B2HpkqUmFvt+y3b9k2uQHo5btijiXXg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XLNZTWOy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769083026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZODvw+hrx9/BESJmdl6IXKkX3UkDOU9hBN+El/x3X0=;
	b=KEJPq6jr2sbd8OMyJWPfLE8uUdX2O6buYrvzSEYCU3YZ3NPuJilFjyw1LtVy1h0dWZdt4h
	UeH4S4HxjCjwOCcM02T5pua2KZGJd1trhVIeoTAXQi1LszEOSaGyfAQF66evKuV/pbL6eJ
	9XXLoMBa/1jTeFh0tLa71hoeNvKMczg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769083025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZODvw+hrx9/BESJmdl6IXKkX3UkDOU9hBN+El/x3X0=;
	b=XLNZTWOy2YSVV4B5Ir2g5vpJVXa4UuXdvJhwa45AGFqmxMd+lXwKdzz1l/e5M4xviyVhFU
	VHD84LUhbsy7iDIhukgc0IFk3uK2xbLUmHZs6mTp33dCiOzDZ5HkjyTtGhRtJSzRgVOCsH
	BEFaw3BACmhv6MOznIsXT8u7wxfdSFo=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-S6H7uWDxMv6TZNA64yjXPw-1; Thu, 22 Jan 2026 06:57:04 -0500
X-MC-Unique: S6H7uWDxMv6TZNA64yjXPw-1
X-Mimecast-MFC-AGG-ID: S6H7uWDxMv6TZNA64yjXPw_1769083024
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6445cf02fcbso1447276d50.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083024; x=1769687824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mZODvw+hrx9/BESJmdl6IXKkX3UkDOU9hBN+El/x3X0=;
        b=pMJkNUDpq7gIiGxZdBqcuQ76cWrbV6DZDpt2H74L03hI0ucY6ro9nWrzYlXPZUQf6F
         VBiF7sYa7RcWLBKQhSX+A5DxGcL18yrsVyqgTfpBrbEvY5ycDZ+4fIx297MOpzMgsL9e
         reSL6jo0rTO/3dhdUGdvDOjFlqAsyUU8/IqhrGxqzdg3W/odruJEH0sdhRD4a81UYNZL
         SiJGWL1Aw0j+QLjbtsQ0nuKsN8QcMhZ2FyKRpu3/upk8MGifDoMOGbDWbmY1ZnHShc05
         KBAzTHIKBLPv+9ku7bvnqZVJJvk4EGnD6X8PnC1tw8PwJf5KOJZDsrHufuplC11rYQ5c
         /OOA==
X-Forwarded-Encrypted: i=1; AJvYcCUkBhz9lc6/DAiyTV/ZhYFs8bGkxZTF5J8O/DFSVZPxqCzRCgfvq2KFZhC2Glmh9383BmE71fPOUw==@kvack.org
X-Gm-Message-State: AOJu0YzsvV9+xPz3vcWr3hUjHc7aPSs1nyhlAcavK77b9B56RHSbd9+M
	udsiAKUVE44Ca90C23eH30ItFPNqA92M15mI3PaTGs7orZAfoB5vE7ds5LUMm5q2DGKthr7KptO
	CDcey9VWokbsUCv85mFM+pIb7zkQQHW/O2r/t/wlTM9uC3YAmn0rrpib8Be3cSurv0k9YGegoxo
	hy+PM3VL3dKCk7xY04yGkcgMaWjrw=
X-Gm-Gg: AZuq6aKfTaByi7y7tBJQ5JMF5Yw1NmTiwS/GXKv2KlFW1/OKi/VpY2jv3lqQTrkxOPW
	ApEPsLdHJuYj9QVw1Q7rA+H9L5ZLLpOrSLMJun9akrXvPt/2p7aYTnz1zVpxOKYL6kUhpQvFTcA
	zOChsglZvFU0opprHqbG8fzxDGdvQMbVBBrw4gFmnp9gGbcjhtjNe8qSPHqH1jlnEIftqbSQJhq
	YtG1Joc
X-Received: by 2002:a05:690c:6312:b0:78f:8afc:c34b with SMTP id 00721157ae682-7940a21c226mr163125937b3.34.1769083023832;
        Thu, 22 Jan 2026 03:57:03 -0800 (PST)
X-Received: by 2002:a05:690c:6312:b0:78f:8afc:c34b with SMTP id
 00721157ae682-7940a21c226mr163125567b3.34.1769083023461; Thu, 22 Jan 2026
 03:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20260118192253.9263-4-shivankg@amd.com> <20260118192253.9263-6-shivankg@amd.com>
In-Reply-To: <20260118192253.9263-6-shivankg@amd.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 22 Jan 2026 04:56:37 -0700
X-Gm-Features: AZwV_QjQJ98BVvBgFx7KzuIQZ9dnvMqmoAV5PsHfCMDGm8DbekvWiQQc2xEhOX0
Message-ID: <CAA1CXcANigb+AsbT68kQYJuxTw9F_iNRfGDwm1AJC7CcUmpHYw@mail.gmail.com>
Subject: Re: [PATCH V3 1/5] mm/khugepaged: remove unnecessary goto 'skip' label
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wga5CDj8863Y4teWVnBZupfW1BEFuJ7qghkAPJPt6LU_1769083024
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 16C0F40006
X-Stat-Signature: spkej6nefy6xn95qxqjaxkz3rnt1papw
X-HE-Tag: 1769083025-443699
X-HE-Meta: U2FsdGVkX1+DwH3ggsFvU6UM3jScSDgeLbFzUvuudnvphtUinoWA6Hpj8FuI0V8JJqPW7Sca10qOU44znPBYM76vPKxm5WGXjDl0EEzPJdPSEtU1Eg2YgmZSm6xT/0EgiK18wV8Qv5IJn7wyGrsExGA+Ziln+h5uQ3a3nR50qc/qKG5/yEOQcqJqTWSiTrtHq+HshSj+DhOcsULzuPVeZru3gU5SQIOruGf2XV/l/Bgd15+1W4NhR7fR3jEpkgvCP1qgxRQJvBPgoDOOp5u53r1AuJfGRocH6sisL3/xhjcKikcZst1eYDr0ij7OMnAj+YB0jZOdV/z8gCHObKAbEWLxMceLvYkjoraqXKjc7SYVoZGTT7m1wbVCUgWG+RPdbiMHgQpsHWFGtkCd15nkh2NfnKrXR8yWQur+ukXn5kdk4U+1Gi9rBNyeMgoXF0OVSHtgzKpJRn8PUgVcd23xK+ga+zM88BE8DtGBhkCmmEYdN0TqbMz9j2fQnVoUBmkKqlca4BRrtrQ4J7x2OtgDC23OPWJA+dJiJFd5JkRoBTH7WTG5PWSawjhl1wcCLZgDa2qRkt+dT6yl35o8kWiCeKbVno2hMKc+BdtoPmXgu0h5wjhtnT3Och/WjsYGBNeKb0W2gwFI1QnP1qBpwEd06xHwvHR8iZN0p61JlPj5UUmMCWMb5pMqK1m5VHvqQw82KPOQabOXcEu2Y1mK5wgIgfTGRw8tWJ3dLULFeHp6O3Rzhm42EsIhoJNP/+oHZDLXiThEe92weOkVFq9mELGrEOmNcIGK/s3FCP/xsU+58dUrvJ7rbmy0RSpSj0dwDOVAW+WtqWQlcSQGo2l+F7XTf912omGbF2DYOhiEsIGCrG5efkH6/pZsICac1JAs5VPVxQy6PB0i7V4GNfaZ0yfuAB8t4x8zteXK0OET4Wd4tS0wCgVZSLs3Gl5cCIXKCHteEeS5KChHUkw5cEsv+kx
 KYVhFTqn
 YwGAOd0d8ucMLagF3cT892ZORnVvXCiFm5tnZL2CKVHrBOI7kH8XbJk19tPSKDkSqSDkKw1e+vP9pnYpfvX5OevVp5xEh/VfpeXxUBvvuDvIy2Tyub95l8BDIlubvc7Txm+z+fs4sHjQ0wjygrR9AJGyTvzmx8YutBJwQhM9OWvSH2nQ/z/lSP1lpaknZ0lmjkmk/VE0xKQ13iLN9y/Uu0ut4yFn+P+hVxgKJORthh7p4dsgqUkYWNiUvVkEWK2jN2CR3n3TeQCOWyyAo7pawVn0Sn9qG2UrsBwNpP1qdxJmsJKobjuYLvkluK4ti6hnLyEj4cIVicRfHAdgbQ0aOIFHj3PSKg5V8MVm+qY+UNb2KGL4F5BKJeALKDgeMNNDwZi0nNn+vshXsEnHkuKDqYTRYn03UCMaOevIkdgclQUnfTjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 12:26=E2=80=AFPM Shivank Garg <shivankg@amd.com> wr=
ote:
>
> Replace goto skip with actual logic for better code readability.
>
> No functional change.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Recently I did a round of testing for khugepaged with regards to my
mTHP changes. This series was part of that testing. Thanks for the
cleanups!

Tested-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 16582bdcb6ff..984294a16861 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
>                         break;
>                 }
>                 if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUG=
EPAGED, PMD_ORDER)) {
> -skip:
>                         progress++;
>                         continue;
>                 }
>                 hstart =3D round_up(vma->vm_start, HPAGE_PMD_SIZE);
>                 hend =3D round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -               if (khugepaged_scan.address > hend)
> -                       goto skip;
> +               if (khugepaged_scan.address > hend) {
> +                       progress++;
> +                       continue;
> +               }
>                 if (khugepaged_scan.address < hstart)
>                         khugepaged_scan.address =3D hstart;
>                 VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
> --
> 2.43.0
>


