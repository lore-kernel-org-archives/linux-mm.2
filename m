Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB372C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 21:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A576B018C; Wed, 23 Jul 2025 17:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B1F6B018D; Wed, 23 Jul 2025 17:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2866B018E; Wed, 23 Jul 2025 17:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0C386B018C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:14:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E45FB571E4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 21:14:01 +0000 (UTC)
X-FDA: 83696781882.06.977C77D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id AFD0840004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 21:13:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UWmsSVtM;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753305239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEFFKCC6CirY6Qu+LFOWn/4wjxHopYc9Cu/eHLmtLrk=;
	b=3TON6rS6tJToF993kmrAVWty7yq0/yFpActUEV1xhjVRkAUME5hsAtGrJWKkLXBczsmeCB
	Rp9imn3k0PJNoW68NR36lqCQbWk4yPjHfLrAx7fi4NzL4yNFI4lrJ14Y9cBtaVUTOxudaV
	Dqgl8IYfmfJzU48GwM6JgK0zOh5sA98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753305239; a=rsa-sha256;
	cv=none;
	b=FAHnJbifxAZ0ZpmV4GxhSDabNHElLkgU8Lr2sOZt8EaPKNVZwIDYC4r0vmP1M/XyCNReT9
	051scGBzgLprS/XOrT4b0YGqvXRnqAuDMpeeDlPJDboz5GaLoCGvETZ4o7fZAwLFdcU4WL
	vadaSF1OSjv1Zmmp1CoMpY/SLtx5qYE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UWmsSVtM;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753305239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KEFFKCC6CirY6Qu+LFOWn/4wjxHopYc9Cu/eHLmtLrk=;
	b=UWmsSVtMTjyVDXMa0TKoOm/8we+PvdI57HvYwhjApAB2RiDlgQX5kzL7G4Io4SCyDhBOoR
	bCEUWuj4q26sbaPh88P1pyhn8KDWeo7TEo5PzfRdgJ/tIsJQQYWsTnviGTO3maUASC9Ys8
	7nMGdpbAxTq4Ejnh6gGKUaqbcR4Hhhc=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-z4zZdIQ5NBaKtf09sogCEQ-1; Wed, 23 Jul 2025 17:13:57 -0400
X-MC-Unique: z4zZdIQ5NBaKtf09sogCEQ-1
X-Mimecast-MFC-AGG-ID: z4zZdIQ5NBaKtf09sogCEQ_1753305237
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-70e86a2a1b8so6483067b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753305237; x=1753910037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEFFKCC6CirY6Qu+LFOWn/4wjxHopYc9Cu/eHLmtLrk=;
        b=xEVSdpD7UuWI9aqKRz8B4IuC6KfnFGdY48H8V/0IPHvstPkGPgGSknO/ErBXFLAGvF
         zJGoTJVBq4i7W6GbAPFK5M/WRduhvkkglD5+6bW8mFAIIgLfHU1c1X40YQNy/gT9W48Z
         6mq79XC3mjXpM3nV+tywL9Xh/JRKYSJ6vMt7RRXwOOFFBtoFV9gIiOovtP1gohPwaSEK
         5KJ7LpY+tBuApAi90V0nAAFS5X+ISlct0fvGqQYX3qhi5yb2u+c2+thyW0JrTB4bgxgX
         kJUgz694B7V8ZijfEQM0CdCrCXDlCMFe3FubVG+56eVTrAPbmiAtAiEXjHqs5n0jmaF2
         WDCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ61AQOse3UQyyTgfzJIhqI7gNgNirmzIpxoUx9iD2nJLSGQ64EvaXWXR+OEWpfP+fylPZtcCNVg==@kvack.org
X-Gm-Message-State: AOJu0YyV6Yq9B8Zr8wcAzdnf6AdxMtosn72N9MD3KmN0hWb1pPly4jJy
	dtq16SvXZEVs7P+NUIkl7PleAqERJdv6EMbhjbWvfTf/FQ6aFRbGmllYqZshRF4+iJwrt77GtZd
	0yfOGsN92aVZNS4CmFd+Jo0Cry4xaaew6u5tgPowVggGJEYNKBtedzK6g+GXe/1wpEIJHDhW4x6
	NlkruxgC9/ptn77Apk54aM8BLHBr0=
X-Gm-Gg: ASbGncvf0dxq4DHbIvDy2WeYzopNHSxYDritiLjy5u5mufvHyX6k2WFyNvzVvKSPKWN
	IGi+ewNn4tt0uDvGZ9i0/eh6Z/lymKw/o7S1UP6xE7n93TkHAQ2L7CJUqK7GvRtcIaLJmEkS7Mg
	bN6cEw+qOhLbHflFNyd8ougtE=
X-Received: by 2002:a05:690c:600c:b0:710:f39f:a2bc with SMTP id 00721157ae682-719b4208ab4mr60589837b3.8.1753305236964;
        Wed, 23 Jul 2025 14:13:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHKu4d3onHAb7X8LWAPu0O+WUZ/aYhsMpnRlh9HgSTUlujJWY4TnCn/IV7CVGxpS2q71+P/Xaq3BIZIvRa+hU=
X-Received: by 2002:a05:690c:600c:b0:710:f39f:a2bc with SMTP id
 00721157ae682-719b4208ab4mr60589447b3.8.1753305236584; Wed, 23 Jul 2025
 14:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250704040417.63826-1-dev.jain@arm.com>
In-Reply-To: <20250704040417.63826-1-dev.jain@arm.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 23 Jul 2025 15:13:30 -0600
X-Gm-Features: Ac12FXwzjaonSZ_XBVSayzqL2leWBYkEuOCfl6SDlX5nA8rmqz_ZykeRteEcbLw
Message-ID: <CAA1CXcD2fRc-apfDi2UtQ-cvDwazxOu+bAVnKvVj2rgwdHedsA@mail.gmail.com>
Subject: Re: [PATCH v3] khugepaged: Reduce race probability between migration
 and khugepaged
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, baohua@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Anshuman Khandual <anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NnFJH3pFRcpWyg8uhwRB4tpvkuXCS_mlbwHcNZqC11w_1753305237
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AFD0840004
X-Stat-Signature: z4b4e6f8hkpjbknqwm6j8fge5mgsg71e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753305239-221462
X-HE-Meta: U2FsdGVkX1/tfTYtVwzqTz8e5Qc8NaueO/Nde+WMS6A+O7A+U3Z9CbcSCQC5zLPpQ6xPhJPUSUnWai+KUnSUlgQLsS7BeNaqQZXPBF4SG4xNNOUx4Ssfj9iwdU9/vyzua3EykFSN9SKEyA1fs2eCxnYQDJ+aFs/vGmwh5jyOFGyT5epi0eiuwW7+e8UnzHu6sunSL4tyjT7K6YCv5eH5z3a1ZduKt3f8Re9H1KOKli6fsKBfJf8AK4VP4xfu9b8dtuywg7mA8RzZmUTKG3GPrFJpPXMAbXE0seGRk/FVaszuT/Y0KLK7CoUihoqiuOwJin5swSpWLPy8drek0WFapKSe9Q2kL9EaKNAHvW5r7M1obHO3zSu4rs/TxOuvffgUb+9c488KH2/avuzSFDyZ7FENPnlsHrQFxRkGU6WQAOgixxlDBI998TAmYO/kMqXow06TKGGq1DEA9HbXQz9TzKPJbYZtYQAWF34C8fi3Yv+3KdV+K7Z9H5iGY33oaHynsCDgjbVvM3aQqmqxQ/OKAdl+Yg99UFkayDg0R5R4NxVwwvoyjAo6JPKzgEm3GExOAIlaJdQmP9yXXCDxc3Ql7+aOAvRZahOagG/r2b54D4HPrGxhRPMN7qU3cfP+6dGBgaAMXyl49QDLjifJ7kase18HvzemBx5JSXcHpSm0cmW84ISvrWLVsHNUybGvfXWWoRbQCehHtnxdvbCalYO+dsVrWX8dhUhi4cOTbv0qFlGivK4TWxxFe8U/HkBfd0eZ053Vu30Ry96RkaP4AT6gIndMmsXngor9I/KmWIy/vmRN+oHReN0CUsve8QyBtQsrpHl5V2J27MLlyAMbZQ8egJ7e20MvIW4cq3+FA7AKjsYB1wopt+2b/eRiz6beLmplD6AEeysi51cWJyPpvuXXaioTsTuP0OU/WnDYWVGlzmGbLCYOXrTJl8Sja8NyEryoYv9LD7ORru1FKcr16HX
 ofN1ijHl
 H7+1cgZjdnvw1kVTm7x44RzE5C9wJm2I9eG7dPQMXxdTEIPCHZktuPIIdFpUX8kxsJbZK0ruuKo87JAPB5qQVB1jWnNbQxD1Ck3UjlirpS7JqAKKFlqTHe6/sFqrbbQNrwJY4EMpNm0AbZHx3yffs6wETfFw5aaXYOoKeP/iHFmTXpj0FGvx3eZXMWkr2LagLdoY43ZUOq0DVlzB9T0Z8Cf9fGiTm0gNdo0vpKrlASD2KvbLykH9ehQnSdMymDFSWWO2WTaNz9nbyQzbyUPxcwMb9WvIG17XpQnmCw8RmoQ98ljB5u4Bf9MlXlDpKOpAH+2iC9gQCepWJ4lLgwfnNPTgpZVQXOPxjPkh3JXpZpKs8J/5eFjaxUZbpCrhPMgozheaELQIt9n/LIVS1ipXUuSp5jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 3, 2025 at 10:04=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Suppose a folio is under migration, and khugepaged is also trying to
> collapse it. collapse_pte_mapped_thp() will retrieve the folio from the
> page cache via filemap_lock_folio(), thus taking a reference on the folio
> and sleeping on the folio lock, since the lock is held by the migration
> path. Migration will then fail in
> __folio_migrate_mapping -> folio_ref_freeze. Reduce the probability of
> such a race happening (leading to migration failure) by bailing out
> if we detect a PMD is marked with a migration entry.
>
> This fixes the migration-shared-anon-thp testcase failure on Apple M3.
>
> Note that, this is not a "fix" since it only reduces the chance of
> interference of khugepaged with migration, wherein both the kernel
> functionalities are deemed "best-effort".
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM! This is a nice check to have here :)

Reviewed-by: Nico Pache <npache@redhat.com>
> ---
>
> v2->v3:
>  - Improve comment (David)
>
> v1->v2:
>  - Remove SCAN_PMD_MIGRATION, merge into SCAN_PMD_MAPPED (David, Anshuman=
)
>  - Add a comment (Lorenzo)
>
> v1:
>  - https://lore.kernel.org/all/20250630044837.4675-1-dev.jain@arm.com/
>
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1aa7ca67c756..a55fb1dcd224 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -941,6 +941,14 @@ static inline int check_pmd_state(pmd_t *pmd)
>
>         if (pmd_none(pmde))
>                 return SCAN_PMD_NONE;
> +
> +       /*
> +        * The folio may be under migration when khugepaged is trying to
> +        * collapse it. Migration success or failure will eventually end
> +        * up with a present PMD mapping a folio again.
> +        */
> +       if (is_pmd_migration_entry(pmde))
> +               return SCAN_PMD_MAPPED;
>         if (!pmd_present(pmde))
>                 return SCAN_PMD_NULL;
>         if (pmd_trans_huge(pmde))
> --
> 2.30.2
>


