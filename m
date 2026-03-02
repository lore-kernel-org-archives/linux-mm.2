Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62356EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7066B015C; Mon,  2 Mar 2026 16:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54466B015E; Mon,  2 Mar 2026 16:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B530A6B0162; Mon,  2 Mar 2026 16:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A388D6B015C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:20:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FE2058677
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:20:58 +0000 (UTC)
X-FDA: 84502392996.15.E73472F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id E085F120015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:20:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h6YsIDTb;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772486456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kFsAiWjV29y4/mqvpo63lZBzBcmEx6G8LioYTWyjt8=;
	b=jtnQALEftWb96g45a7d1wNDrfyFw8grljpUYXS097u9eV10RpTmRb9rXGIxb7+3p2VY5j6
	XuyDhsUw5oPmsYTPChPClGRCej09dL4K7C31y2s2T6StJGCvgK4qTgHyMGvO1ngj2C/1qy
	TNsjGJTFs+muac+2KEOBRXxo3vqmuxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772486456; a=rsa-sha256;
	cv=none;
	b=wkdcXp3/JdsyTuVEni5+MOX7wS+z3FLi2XRDvn+Z8tZ8qjHam827aGQ+Ao88NXt5DFnS6L
	lPRtBCg5j7J1gTYEjCOkh0H8fLSgnTWMLAKoIy275y+7g3l1pPESBb9pat5QMPnLYAaZzO
	01W0LOKff/yD9SpFhoJYZknf6SiX29A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h6YsIDTb;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772486455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kFsAiWjV29y4/mqvpo63lZBzBcmEx6G8LioYTWyjt8=;
	b=h6YsIDTb6H1r7K7oCSDfj6Ivj5tdMgnB6Il7nxXard4qcf7EKWPPsMwlbNEWBprjqK75uV
	bswtcCCpkoNaVA98XT2eqI1jK9MpjAiqZ5lJqNS5iTD0lhR0UIBAmC4OIt4UE9BPAyjB0Y
	g0ruEMup7jghKvu8+E0YbOlr+3UMiWc=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-j4RbIACON961mqTKvLSxxA-1; Mon, 02 Mar 2026 16:20:54 -0500
X-MC-Unique: j4RbIACON961mqTKvLSxxA-1
X-Mimecast-MFC-AGG-ID: j4RbIACON961mqTKvLSxxA_1772486454
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-794c39ea759so91498327b3.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:20:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772486454; x=1773091254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6kFsAiWjV29y4/mqvpo63lZBzBcmEx6G8LioYTWyjt8=;
        b=vmL3s9hlINlMqQPY6/apoTqjyRiXSu7swYtJDbc0mdQ/ODQsO5lXXLEDP27Qc9ox69
         9bdupkeVF3R7OkNlubmulkNxjCci20If87k03w/3CyaQw4+pn3ZKvE5eyLZitci/Q6B7
         H7xhR69/UxrY1/eN4U4ETUHqBNbfUCR2ye2vsaYoOL1fOoaIk+WjrGLM6ZUt4JrPFWl0
         Bt6LF1iWd98FHQQSWDD1vROayaWbpSXTC7OjGn6ahDr/0+FOjurhrSQlaGUgUmr2ML8h
         5N6pxOE98i6vkta2ADKFAjgnULaFlZXoTNYDLhwVlGF9T/7lACxYWjlL93Rol2wCYFBV
         q14Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnRwDwIsuIpLgHp7xem4ZCk+EgGPbMLEDP82WmZVs00ak4OPS5X9rdVuwaNQw0sPOA9k+CTWGwJw==@kvack.org
X-Gm-Message-State: AOJu0Yxn9YqCaarKT5IJFZbCM8Wa+VPRV/PndYInp9r8UvnsrBOc0FBl
	nHPW8Btw5PWXxZzkVpljZ9TWDC7p8nS2tUitqrvtfLbUfImYLDvCHO5kcRvjVIwZScWufg7Oh1+
	rKxTg9nPFQsqLObQA8yUuM0wBBosrRu2ol/AbDrqO4OgVLyAldA3ySh50yuQdpMPaz3pNQcizUP
	GHQsGbvVnBFELtryCHX02G1ZjR7yg=
X-Gm-Gg: ATEYQzw0OfeIu/4BKPnFHz+57uMnkV5GFB4qCPhfz7ylWfQas1dRrkGlljnJLmzzuX/
	nRpYRZ1E4IZCb81acF/tNNaeVDECdHpfTxQSlt3BKAqdmGvDxzmyYFcit6iunEyOlLJk5whQdtS
	7JLP+QG5WVpJeyNMtv/bBiSrd4kvm17jbWgsN14oE+yE6Ku8f1T0NI8J7k9xogMqN/pdyezo0RT
	Ozg
X-Received: by 2002:a53:a04d:0:b0:64a:ee9d:8b7c with SMTP id 956f58d0204a3-64cc2225811mr7952709d50.42.1772486453714;
        Mon, 02 Mar 2026 13:20:53 -0800 (PST)
X-Received: by 2002:a53:a04d:0:b0:64a:ee9d:8b7c with SMTP id
 956f58d0204a3-64cc2225811mr7952704d50.42.1772486453337; Mon, 02 Mar 2026
 13:20:53 -0800 (PST)
MIME-Version: 1.0
References: <20260226113233.3987674-1-usama.arif@linux.dev> <20260226113233.3987674-13-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-13-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 2 Mar 2026 14:20:27 -0700
X-Gm-Features: AaiRm50qkaj59sngcutouq41dPDnCRD-fKXemv-mcnstHZb0L6rgl_hR_ovxMIM
Message-ID: <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
Subject: Re: [RFC v2 12/21] mm: thp: handle split failure in device migration
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, lorenzo.stoakes@oracle.com, 
	willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: np_3WVhyotDc0YxC64irlx-Fm1eXgkQcPrX6A8MxKr0_1772486454
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E085F120015
X-Stat-Signature: rxk8ymbmb391wyjc9j65e37jpsq78iwu
X-Rspam-User: 
X-HE-Tag: 1772486455-135290
X-HE-Meta: U2FsdGVkX19LfDQblMVnQO+2lMAECwRiW2eF6bQIXAkoYnNyzLJGwU/s2YFycOUTqpblX3ayMtc6ZGyJNj99/APit69tg5vaOS2/pqKA3jJOFGA0cofoQBS65kqGwRIjQYtNAnjv0inGgdsGRsd2CHf0tTJQ7l2FK72KhHD6dXHjFq1UP4ZvoWBodmSYVfFxpRBMWkH2GnMrEtSndB441/ZShke1FSyWQAoS31MlbJYz4MQiUvwMNfI0hl4e/N1WUam+tRJ2H/hg/uvPE2+9MoY9rUdSMmea7zQIDHkFNjY1poL4vNLXHYYIQvuFkCOzek68qJYHkO5pZ+DZvbFe46zgqtCPGYuVFB+jFQOTwz7WUdPFR+TwAF4BaRZCPqe49aXO4yPbzzIyBwfcKNEdat3OJ4ZGXsyCnU7UI3IHscs9ah/0zeecmSrAO/kAv5Y4jYXO8g83CjLHefc8+KGnDnvB4X6eZnktNTqryWa1XTOnYfdsQKTSClK0s2eqsYyvUJibMNtlbFHVKunyvDcmH7VCUDoy/4RyiEUxfkdazHYuvjv603bNy11lY4eE+L+dMS5CPlvP80NgTXaiAr5W1I05NJnHV3dVZ66Vn/iJh+sqtj4rOMj2KZ74nKDLRstrDalk+qVKfcZsnlF2ofbUcl4zHxUhR11+qifFSuIfCVjEzGdmhDz8Uii8f8iDyZ6Fu0UjfL4yWY8Pe6r0mwkjy7w7QaDA6/2qB0P3znK0IpEEtPmEnBASVAs9cnb9ufxh3nZv52nI6afmmSdb8xtBg0i7GQC8sFmifBOOauGluNe8P7CsFNwL2sAHWXT4ImrelnS15fbrXY9j38Px2PUCFalZm/ICKiOoGtQ0YynGIWE0tpZ2FKCW903ZX9f4jO83veFwDPnwelrrjY82GM7jcOBGWsWVXkwCKOFAWCIr4FaIQcK5vW2DNmhGQ8+GuBHxe2YJ5NessfHcaRx6X3t
 0+AakIKQ
 K0GK+YL8WJCg8aShMEvO7wcxQSKTCjLAdghqngO+zh2mN4PPKOlbxy6/bDZ/ZRXR3WK3e8X8EcEbVcyNE0k4uqtLxW+j/3GH8E3DsqBS+O7I9QEgCAVCu/27BZfOlLrUjTgs9dEXz12lpUMwyRTIGlwYbQuw20pc66YH2eEkjWsids8OdreTjn8Y3Tfb5pNialJdtmyEyFxZQpvAUKizt69Ya/W02dnU3sjqO1yMGpcF6IiLgwskiv4KNEi8sNxcSwI7pi5NhsvehhS0QYg5BbGPpmGV6gaem7T3JVt7xqxhUl9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 4:34=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Device memory migration has two call sites that split huge PMDs:
>
> migrate_vma_split_unmapped_folio():
>   Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
>   destination that doesn't support compound pages.  It splits the PMD
>   then splits the folio via folio_split_unmapped().
>
>   If the PMD split fails, folio_split_unmapped() would operate on an
>   unsplit folio with inconsistent page table state.  Propagate -ENOMEM
>   to skip this page's migration. This is safe as folio_split_unmapped
>   failure would be propagated in a similar way.
>
> migrate_vma_insert_page():
>   Called from migrate_vma_pages() when inserting a page into a VMA
>   during migration back from device memory.  If a huge zero PMD exists
>   at the target address, it must be split before PTE insertion.
>
>   If the split fails, the subsequent pte_alloc() and set_pte_at() would
>   operate on a PMD slot still occupied by the huge zero entry.  Use
>   goto abort, consistent with other allocation failures in this function.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf024615..bc53e06fd9735 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>         int ret =3D 0;
>
>         folio_get(folio);

Should we be concerned about this folio_get? Are we incrementing a
reference that was already held if we back out of the split?

-- Nico

> -       split_huge_pmd_address(migrate->vma, addr, true);
> +       /*
> +        * If PMD split fails, folio_split_unmapped would operate on an
> +        * unsplit folio with inconsistent page table state.
> +        */
> +       ret =3D split_huge_pmd_address(migrate->vma, addr, true);
> +       if (ret)
> +               return ret;
>         ret =3D folio_split_unmapped(folio, 0);
>         if (ret)
>                 return ret;
> @@ -1005,7 +1011,13 @@ static void migrate_vma_insert_page(struct migrate=
_vma *migrate,
>                 if (pmd_trans_huge(*pmdp)) {
>                         if (!is_huge_zero_pmd(*pmdp))
>                                 goto abort;
> -                       split_huge_pmd(vma, pmdp, addr);
> +                       /*
> +                        * If split fails, the huge zero PMD remains and
> +                        * pte_alloc/PTE insertion that follows would be
> +                        * incorrect.
> +                        */
> +                       if (split_huge_pmd(vma, pmdp, addr))
> +                               goto abort;
>                 } else if (pmd_leaf(*pmdp))
>                         goto abort;
>         }
> --
> 2.47.3
>


