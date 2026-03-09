Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE798F41808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337A26B0088; Mon,  9 Mar 2026 11:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301556B0089; Mon,  9 Mar 2026 11:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203EE6B008C; Mon,  9 Mar 2026 11:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10B976B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:12:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A82D0139E9E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:12:31 +0000 (UTC)
X-FDA: 84526866102.10.B2980D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3BE972000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:12:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I3OJ5JjU;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lctKp83r+2bpmROS8OcdfKMLjBlxuz3/Zezlrttqxok=;
	b=N8/P3SjL3zOYj/uEd2cqeD6dwTlaIu71A3t05Ux+N2BuDVLkb+z8zi6rNqF4JwkECh4Wi2
	sWh5aqTpchBT+j1A6eX+JhF91uT7qlJ/hpuHuu+4wyXT0mQbySPOGc7ui5SEjPoj3vOD9c
	Dd5bW1seNeEzXw5qW21nNqpZbuuTS/w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I3OJ5JjU;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069149; a=rsa-sha256;
	cv=none;
	b=HKbOimlFzftSDz0TRNHIFDVhfR8DLmpnArvAcYD+angwXSNFzEyrvGOG9gkqxkDwoSK+ay
	JXwXcdLFI9Y8nUrqm+52U/7DMdr54ZCNz4s4jWVv7UG038eXbdbayG6btirRP7+/MjKnik
	TKn/jOKOUGcI7hSAXeYRuCjZ8BN9CBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773069148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lctKp83r+2bpmROS8OcdfKMLjBlxuz3/Zezlrttqxok=;
	b=I3OJ5JjUfhyB78ogSbEVg6XLDk9Ny3Ke1AqkFv7+LkPvMxFKB7GbuEEOXTb7FqczjB5Z4O
	JHS8E5VwM5/fbI5tC1K9JYPaZyqR+NxMqnWrlZ52pK+GySbyoxG7l72q/Lr8Qnf+79ZUsc
	Be/PejraWQQ6PfiDIdeg5RMTFOKlxM8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-vPxBdj04MoqwOeet2yWMsA-1; Mon, 09 Mar 2026 11:12:25 -0400
X-MC-Unique: vPxBdj04MoqwOeet2yWMsA-1
X-Mimecast-MFC-AGG-ID: vPxBdj04MoqwOeet2yWMsA_1773069145
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7986f771f69so206051307b3.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773069145; x=1773673945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lctKp83r+2bpmROS8OcdfKMLjBlxuz3/Zezlrttqxok=;
        b=b9qGXjHvwinKdSzsBCUBpecwsiEZzqsL6zPhUkTOvcplkCx68Vohsn2NiZX4mCn66c
         FlCyhwX2konGdRNjQvZh99/ineJmAZfSclaLiCDAosyfQkN+EhSCm99iXYriT7boFl/d
         OZBrt/QnMO41w4orkrFPQ5NykNl4CG6t2oLzM8EaAqH5HuODifXnX5gZqUEktCuInwCc
         9OKrgJC/bpykB9p7JJjqnzX+uws0x7h0xmW47b77mg5GvH1o/1dZDMpL6WNyshSR3XLS
         hwaGQQ9O0anGJ0XcnmN55nqnOJ5itsDHfrxcdg+ZWU2KjtXNUWDJfapJ/pAzU4xVEmDW
         TdYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUasUv8X/yj8Wv6CT9UHb6H72gZ3R8Tb2pCUttebra528bQPM/bZfc3GMwBP13mkwy7Z1BsFBiyOg==@kvack.org
X-Gm-Message-State: AOJu0YyOt4nnJhJVvuGsW2RyIbPAJiBb/NkLlO4dHtouvNFQxQBVYbzs
	3yNoWzf67VJa6lW2q7Xk7OEqxgjgUWo5+bXc4a0dEUmfd2n1vvxzoAqF5DaOILZflbrZ1o1XQys
	NJ2+dLxT8s01Na2dd/kAOYayAa/jfxrV81WqqFZsNPoOWJYr6pk1r6udeFF+V+HrhbFwAT2vKQS
	1gQaa2OwcIB3iN5IXORe4q/zAioxo=
X-Gm-Gg: ATEYQzw6i5+Qw560gtGFyCuWXq5+M7Zix+E3Bk4v0aQv4bxxDE5hutYKCgcbZpDxRRq
	aHZmhxcYyzQLceTQ7q7pXIOH9QLxwj21eJLIAzuTYMjUblVc+YLHt1B4GTHJdkrs2zpjzapoFhW
	yRqRHMiNHlV/L7uXQ4SUi0Fy8/is+n/y3uuZM8wGRDXTpenW7WG6gL6D6AreO4MclfAbYHH4z0I
	k7Y
X-Received: by 2002:a05:690e:14c9:b0:649:d084:9ee2 with SMTP id 956f58d0204a3-64d070e1a7amr13120034d50.1.1773069144769;
        Mon, 09 Mar 2026 08:12:24 -0700 (PDT)
X-Received: by 2002:a05:690e:14c9:b0:649:d084:9ee2 with SMTP id
 956f58d0204a3-64d070e1a7amr13120002d50.1.1773069144368; Mon, 09 Mar 2026
 08:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260306104409.3915811-1-usama.arif@linux.dev>
In-Reply-To: <20260306104409.3915811-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 9 Mar 2026 09:11:58 -0600
X-Gm-Features: AaiRm51lnDTHxmeKJc2k4-o0nVjhNIb6POU26HCUfuoC4TBUxNfKffmYYq-XWqE
Message-ID: <CAA1CXcAN+i9z1Om_2tn5Y8gyRC0jqXTVtD7ZUtqQwEe6tHicYQ@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate_device: document folio_get requirement before
 frozen PMD split
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, mpenttil@redhat.com, balbirs@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, riel@surriel.com, 
	shakeel.butt@linux.dev, kas@kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ykBIUk7fTDs7D-17GOBflIjehndad34bSy-ja5pK-Ew_1773069145
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hfscqjxcjsh1fqsiru55jaym9rom7jzt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BE972000D
X-HE-Tag: 1773069149-972527
X-HE-Meta: U2FsdGVkX1/7QLBgoGciXMeLlAY6QIHnB9XNofps6+uWszsbgzgXLsQHChv844a6B08Z9JLmybQOReeTAbZTBysxVzMqOadXtaqNXcz5EsKeMIkSqiE0NEHDBkpoR95lLduvPqintN4wJtRdNIxMqXfOg03NHdjr+EVvJlexAR9wML6CahP9U87vCc1/nos1VbYVSR0h+mnVkgW4GGaSMqoByxdlH9uv0JhoYKS5FNtx68rz0DxhGJYnV+pOC1Nd17vs7LQB9yDYrB/ah9XTbeXW9V6CQL7RezlASXKWhZB1xQyI8K8oWDGGD5uiBRFW/kf6h9Ctnm3k4dObtpSFOK7AwdnYjfgyDOnHiY+H0m3PHJIHTKISgexese7n8W7FAujhjJ+xv16cHjmx+mvHTwYMUuYouFSF1B7nrDFwZc6nvzj6oJwjzaxvUxeYgCj+jb3eygZExmhDf5w019MCh84TE+BOCXc6ypbsEi0Hrw/DDTtUqoQXGuhamOnj7Y9eYlVhyTKl/E4S6+zuE6sBPJOagyOvZ+osU8T2tYZIxiIrim4ipHUkldaZGm2vmoEs/jrTIap7DOzhZfE+iPMyex9bhCEIuMtGPcYLHrtKJ5HW+cLBSj4tXkXenylxMgSBadrpagQFhd3s1hcvQrkh+39RI9GFGXJ8UALF9E53Q81eiiOH70nxYJtLpI4AudyGA5fikucTVXYfzuCSzmR/NjxPdICFKr4zmXxPJ9uBsL6zWIdPvoUM34vhj16tlVnAat53H0EAk110PZENaVt9WkI6w8iltWV+byF64afYDthPypUthebcejnJQDIU17O7C5StCM0alPs5dppIOVT31NnLC4QU+RwrJn0WcTP/Gb5GYxuyIAXUN0SX5c1zk3QxT/r2Htrba9iQtapE6ZWYSrncIBDwwXn6MSo2oK3wa2yCvHdNO9F0rAOGrjzyKtVrjF2BeS2IjgWhRqmEiRN
 PcynqCi5
 UtBMo+Nnr8T9es8kPXFJM2bV12Qik9i4AkJR5wSDhCiadQHCJLW8shYHtp7PPqYmnGiMSw+GohZQhJAnBR5WIDllS8XoolAn2rUyjJSIiN+6U6MY/f06HQj1bh40S+wVEb66hTl/ot3yj0joZJwgM/8k5pAw8NDCRJ/hWWp0ynOpsG3qz/0OjdLRz5CC8pPHZ6ths/ij0lzLWRvISOWk9Ncrq/KqJE6osA9aQjEvdbgXOETEfEYJisFbxCcxD5DunziOJjdTNdPfqfZSNOF+41YdILsJyPc32vI5XVp8KjeeLKNiwhb62v02FMrDUrxaUmzMgF37pMkVUAfi1AAVHS47YzPjvAtCcLSqnk5NICYyNVsyDvRPzSpKzXWkYio8GfCiCoLIucVXmNjZA2UiiZybGGdQjiYRr2U+Um6i4NcsWxFme/NPAtinETd8KW28Y1ZfR4ZSA78o4D+1DGfggo68fLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 3:44=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> split_huge_pmd_address() with freeze=3Dtrue splits a PMD migration entry
> into PTE migration entries, consuming one folio reference in the
> process.  The folio_get() before it provides this reference.
>
> Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
> catch an unexpected refcount !=3D 1 entry state.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM! Thank you for investigating my concerns about this. I'm glad you
found the proper answer.

Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>  mm/migrate_device.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf024615..6fa2878848a7e 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>         unsigned long flags;
>         int ret =3D 0;
>
> +       VM_WARN_ON_ONCE(folio_ref_count(folio) !=3D 1);
> +       /*
> +        * take a reference, since split_huge_pmd_address() with freeze =
=3D true
> +        * drops a reference at the end.
> +        */
>         folio_get(folio);
>         split_huge_pmd_address(migrate->vma, addr, true);
>         ret =3D folio_split_unmapped(folio, 0);
> --
> 2.47.3
>


