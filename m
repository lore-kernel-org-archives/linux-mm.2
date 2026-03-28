Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D302B10BA423
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434196B008C; Sat, 28 Mar 2026 15:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C096B0095; Sat, 28 Mar 2026 15:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348686B0096; Sat, 28 Mar 2026 15:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 261086B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:17:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB4C3B6A78
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:17:24 +0000 (UTC)
X-FDA: 84596430408.07.DD3CC62
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD80840002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:17:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ezEW+xzE;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774725442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsrWI5YGiXr24OF2sWylcfnJ3x9HQedOr/bdkz+8Yd8=;
	b=ry0vK7y7L09sKl4RZz6pLyXtbmkJvdjulSdzAykWtD8+3mfbIp9TR+hjneQZYxytWrKBdO
	uaaIL8imrR3t+N0zHNN8974FY2mXmOCnsphNupsytCzj87bZASJOsGuaoGhUnmeJWqv1Fa
	px8xBhiB9htNnNcYW3/vGIpHIMB2NG0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ezEW+xzE;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774725442; a=rsa-sha256;
	cv=pass;
	b=TFHs8zle25GITPWBS7rog7QVEFFCH3Hmvq5m+6zfQ/wJhK/X8QrQUqeP+0/hRJCRC00PCL
	/5+wb5JZlzB3tn/PtmNoSVMBtoCMz/oXHwSiO5CgHkP0hHCfqiEtJIBlF19j6JlBiBjiC9
	apCD+8/Ey//tDPJHX2t52GEHQnOXTfo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509062d829dso437971cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774725442; cv=none;
        d=google.com; s=arc-20240605;
        b=Bawt+Qq0dAY2k+vcXP0osZSa1A+1SDpoYWlGEnFM37kyxdnd9Zduk1nEVAFhqQskVr
         9nxZWLwUPDG1d9kjveEGS4WWOQBgUnY3Q48zuovdVEUdo45xBdNxw2aVWQ1WIUTgcMhO
         WGnDUEOadVNQEpdr+9jMKflWfbXVZDdD9boLCtAWOlH3MmoyqpZp3PQXX/8QJp10K/sA
         QWPhObD1zq6RiyGBvuKRm8/yWNp+QxwwpvaJLUnIbLSAYIdVfmd1OIR3EvmitQWIYfN4
         rpxUFbV+51FrUlZsHL2UrP+BCadRP5DH6RDJ7CCoeCdhmlkKcPJPOyxZW85KYOOsVCoj
         nKPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tsrWI5YGiXr24OF2sWylcfnJ3x9HQedOr/bdkz+8Yd8=;
        fh=CSRyEzU2gEp5JgUWrBMDOfje4uFJY2HeLFPzazKP4sg=;
        b=RgD4baEIcs4tCm3Zj2eWQD2Q9TcD/YsVScuPHq4b3OFiaM/qpXc7bCL8FfvB5RW/Xw
         Panf8mGYF9zVkWtlMtcyu6+7gqqkz/Mv/BbOiWE8Agxb3FISze5/e8TDxKgoEpkYRboG
         7h9GZCAvA2SxnZO/sd+19KPrsVnzk6lBcXCr0jhJ017Di+nqmCVsTZjM0embFtMD7jVv
         OZRpgzOKKNdkpTHoZRhmBp9E4Pe7U8ez9eVlH/r0p58j1erCr5QRgBdkPhlle2Djk2gh
         0VwGmPSk8ZZvEE0vCZ9DQ6uZzSF1+0jAeFPzYsycVxpDOAwf6EdQ3Yznq6r9a7qHOjlp
         4dNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774725442; x=1775330242; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsrWI5YGiXr24OF2sWylcfnJ3x9HQedOr/bdkz+8Yd8=;
        b=ezEW+xzEJtmZqksRlJt57cRsBwgOu0+3qNpZld1B8paYODgulwn/m0Skd5PK3JKIqM
         ee/ah59CfvnNZn5ToqjEBODlnL5m354im1Qbky/QUxbUkubPdwNNZaLkv5wk/0Yu91xB
         L4B+3cZ7oBiwD9AyOp939sn23xFrjTFbGmMw/mQAUpjbx2H2VBbo46WO/C6v4YyhdsKp
         Jw2AhWSt2bRFxLdbtrJAmiMsF8OWdALvMSMTbVO2PEfozJtpkpA1I5/+7rmN8HzgewiS
         xzBqP0IywZDJfOYHSRhxz5ILJi4CdBt3+dCnLAt3zb/arGd03KmTt4yYvtawNTK0hPmw
         EBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774725442; x=1775330242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tsrWI5YGiXr24OF2sWylcfnJ3x9HQedOr/bdkz+8Yd8=;
        b=HkY3fbeRtt3hM9V+caSfkYaQGHkamUrdBJQaSPuo8AJBWY0JZKqv1wLbQc7tfGDXnW
         szXhsapyAdFtWhQtn6yUw4f9auA99jDPlgzzH4tLMqZsSYK3pBHP599watv0WZYILwNP
         k3Z9AdaX+SRe6lQ1GcKZ/ptumPFNaRpYtlm1kxLwAARAML7pB6ngZuaGFBI3ybeAsgNQ
         1LBuT9vlCZ1vqvN11C183b2kuRIwjipM96DT44FKN89UwRkzNohtWjrOlIdlSBTVNcrw
         dKTj5BCsJWCG9wPRsXBzFgezD8bATxt9W4YnjbOnXfwVOdqCsQLhZx9NAlUwFPFv8mWS
         si4A==
X-Forwarded-Encrypted: i=1; AJvYcCXBwM8E8xKsIuP4tG61ZOBrXd7EYyXZU2xwh9Ibs38UzT6kA7JkvQbF6S9EF7C+X8I2O/sZek/m6A==@kvack.org
X-Gm-Message-State: AOJu0YzR2StwtUs0Y+MlpeJMxKfCzO6Mg8OL97tS2eGkmdkcw+ZPQ8S1
	RH1VBstaSR6khfFs43EyqewsOj5UGKIMMk8WKDai/e/NIX5fuPMJhn/V++srg9WWPdVXox8qhEy
	0PtILR/SFV6oi/0ME8B4GQ8JJPTuJfzhuWyf/XbsU
X-Gm-Gg: ATEYQzwIY5DRlDxVZAxWf8/v+v6edKV6fLn80ziqD+1fa0kAJ6TIGXBRtK6jKAHfJtc
	1ZZYXMsqTCj3mBNlGq7c9BpUhAaNzN5avy4XKY8OWNAI4WwC+FRk4d5ljWd7389RPIFhdoJWU/O
	mLQSx7dAQva1+S2Qq6HUfE3s4IKEmMKvaEN5N7F+DGNeV4IMrP9voasFluFzQUBEvcDdQG+U5Q0
	FR6tAMGYqhPZeIG1adDYARa73pjaQzT/cgoN5I8vrWIJ/WgqUJIPyYcWZo3RynEFyxSz4Bw6BNu
	XrPyAbEOtvbvywxx
X-Received: by 2002:a05:622a:2285:b0:509:15b6:f69f with SMTP id
 d75a77b69052e-50bb263780fmr13490791cf.2.1774725441253; Sat, 28 Mar 2026
 12:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <0c4c5ab247c90f80cf44718e8124b217d6a22544.1774029655.git.ljs@kernel.org>
In-Reply-To: <0c4c5ab247c90f80cf44718e8124b217d6a22544.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:17:10 -0700
X-Gm-Features: AQROBzBJltGfuSQ1ZSCtrfEPrtuK6MIuJhMYFQbFk7XQdtqEK-1dHuTfYiwRUf8
Message-ID: <CAJuCfpGZL+xcMyaLHWSPo0LZXB+DSO5zv-hqXSEDC+9h1idkJw@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] mm/huge_memory: remove unnecessary sanity checks
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AD80840002
X-Stat-Signature: 37h4kh7gy7ytuzku91au7b8tig1onu59
X-Rspamd-Server: rspam06
X-HE-Tag: 1774725442-11690
X-HE-Meta: U2FsdGVkX19mqKkz21wfiwzSjuCWtRAgs1pmUSjija1HbapgpJ1pW3aAyqd4zG6vcEc9g29onWlJ3N9Rs4OduoqbqAJYhXdH96vyNz05xu7qbZnlexEPzt5DalZUWiRnuGQ5Tae7VYvgQ4YnyVNLMhmGN9EK3NKrrt991nhw2lB3OdZfmSBT1j45ghvQfUvIVmif7UPwJu+hES6Bj8sPugA2RMG8uPhzg0qZxm15xoLBKL3mYB10WPA8kYQqEePL7Fbz+Xv+kBF2MyjkDEk8Bdjn8qoPx3Z1gF0AJ/gqe37MVhz5N7w7GGaGcIVxKuNf9KR9mEySwRBUp3yZtGtPExfa5+fLoYFVphqfxWoa8FTXkGVGSe4t2UQBdpf+iNko0bUUUd8Xl29QrMd6qWRzRJU/pZpCssr5TuezTRtlD9T8/Rd9RCtbrGt7eVCGkBQTR8dSupx8X8fH7pMSXXviD6k1pjJM/EIZdi1bc6fziYe+0VZH8/3xqCxOlARMaokeS9KzsmMXD9AnIzrV/t/yONtOcLht+Li9UqlpJfiXyGzH/+uwONpJM+csI9ExS0Lbmtjr35mg4o67CTwL/7Bljq841ymiXMo7vnyCTOPUc36jtF1ssngqzqT+Jn8T88senqWIFC4DLmhN+gr+fHnFrVYlbf+0d2m7/3e7pBeLjbI4eab0/8768lEs2l0J29m4CVdkYGl+LHBl4RSB3LOxvGz2oqsF4aDinu1AbqaPRkleqvzK8W3VlV+TJPCySedIgVTlXi6vBkpICRRLbCNCFUm5gRSUN/1S4Th/yjJbI4oi8zhVV+cEUUNB5s81sGZf/jQVh7mlpY+fzRitKAJQYRAlCw0kGBeeBEG0m0BQjLf2wcjAZQzO84coDAQ/pgG8+EJ3VDOa+0vExNuKYchn+UlmX7JbCn6Vn2O+cr/xO5TEjfBzHfVKMJ3gA/JCw6+PP6YhzuXJhfLehcjMzYW
 5U0Nsznb
 aNSxcKOXoYpWJJwEUpMIOI37MJqaV97I5zJnfOeZDMrrb0TmBJ9opk1R7f0OTTmAdVXmS0P/zQEiml7upgVxJw3N3Zbqt0d+Wr8tL3HNdL6/oDOXw+D5wjNG5ugllC1pSO7Gl0S2OnxJPy7mpDSvlGOc62hVBeHHlrjcQMgq/sOe8cpSFC772giNJSpY/YhkaTRZ7UZs7jggLhRHkwgSApJ6Ex0r81B9j8cmuGVJKGC5ekt3saIXzEP3XsU0q56OhU15RLO5vrruuBdsXy4Ejq4H7kyzKT2uC/yJSjyUfxHoAQEzU98x2BFahRdBkDNTtCPR2izgKl92A4fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> These checks have been in place since 2014, I think we can safely assume
> that we are in a place where we don't need these as runtime checks.
>
> In addition there are 4 other invocations of folio_remove_rmap_pmd(), non=
e
> of which make this assertion.
>
> If we need to add this assertion, it should be in folio_remove_rmap_pmd()=
,
> and as a VM_WARN_ON_ONCE(), however these seem superfluous so just remove
> them.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fca44aec6022..c5b16c218900 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2371,7 +2371,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>
>                 flush_needed =3D true;
>                 folio_remove_rmap_pmd(folio, &folio->page, vma);
> -               WARN_ON_ONCE(folio_mapcount(folio) < 0);
>         } else if (pmd_is_valid_softleaf(orig_pmd)) {
>                 const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
>
> @@ -2402,7 +2401,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>
>         if (folio_is_device_private(folio)) {
>                 folio_remove_rmap_pmd(folio, &folio->page, vma);
> -               WARN_ON_ONCE(folio_mapcount(folio) < 0);
>                 folio_put(folio);
>         }
>
> --
> 2.53.0
>

