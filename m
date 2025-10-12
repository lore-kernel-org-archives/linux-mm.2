Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51422CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 04:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497338E0003; Sun, 12 Oct 2025 00:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447A68E0002; Sun, 12 Oct 2025 00:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3367C8E0003; Sun, 12 Oct 2025 00:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC2D8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 00:24:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A887C1407EB
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 04:24:05 +0000 (UTC)
X-FDA: 83988169650.29.7EE56FC
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA043C0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 04:24:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AGAI4F0g;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760243043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q31C64dvExcLvA+pvLaqKGJxfqiu7mgCUQLhcnfrebk=;
	b=7vxvWRUt97/LUwO5SkJp/LcIJZqU58nl7tGFIBtgurlN9mjZIr66WhcZ3bSWKch4R/+TVM
	bFO2abQyQgddQ9Kb/aTvyk9qzP6iUibEa6lYyMzF0PvSHzf7KEckEOFpbFUL9hJ1b5BRNU
	SyzqWHsjS00b4uRn52950PDLN3t6cuQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AGAI4F0g;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760243043; a=rsa-sha256;
	cv=none;
	b=BfJ7pJdNBZbqxOaMqJkNzSSbZftEQ3LNL2J47bDFF3nL8iiGxpUm1q6+rQOD7DYiyAnz+x
	dOYNQPIB8TIFGAt7nIifaIEfapZy6snU93UTQI3IfRKI/r6uK87TypKKl1yfp5WIXlGpoN
	J/H0nUEyyDEXMtZmRLyOOzuY/enSEcQ=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so53335e9.0
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760243042; x=1760847842; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q31C64dvExcLvA+pvLaqKGJxfqiu7mgCUQLhcnfrebk=;
        b=AGAI4F0g43jsBwJpOC2bWZbSouRkOy1sCvF9ufjyeMbdGNBd0LJwA/IyOrBA/CRDSz
         iUjqdf/b3+9sExb85iqZu9DYuaR6umjagn8Md9qZvWKvMAvZeA18WSYeiFa3pFoglUCj
         FUQap7WdXrr2itaiYlzUbMcjNbRYoaMXTFMnSBKd06esZwhaEY4heCk14cGTZDKOjvaw
         XaHlV1RIMwFyq2edW6XlptEV7UTKo2fBO1DjpVlUupxiHW5LSyNL9LeVgQxlWu5oGeQe
         bJTDBlQJ4qH1JUsJ5hKgJbVKzbNDxxLxTnao3j9wdHBy1LDQ3KhK2tRClNOKKI4hj67K
         KMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760243042; x=1760847842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q31C64dvExcLvA+pvLaqKGJxfqiu7mgCUQLhcnfrebk=;
        b=EoveiOUwBGZq4WW1t+Nr9j3JSJS3RpnOZVkInM+ZUYSqpupxW5Ol+qiwBvx6/C295/
         53JXCKKq720W/1/n5JyxYk/qXsftIhdmXecBe3zc53aWCz4jxQXm26fb81sbsgOZQqtl
         jEF4x4N97gWmxl4HVFdeLzNOrJONKDNG3LPEp9s2yFSmtOgPSHjD9XgsEmSBIWfRl5Zt
         6o5xrWS5Pd1Dddt3HBGYtXFI6lTcfplkqZiVBlTPkHBp94jMvNLmO8nXyURbgmI+Fs6B
         PFRE+2vDEXzO66bAoorev48iEERO9sDUnQvuMve377FkWu1jmbXewsOOtM+PIsTdxNEk
         U7Xw==
X-Forwarded-Encrypted: i=1; AJvYcCVk2+NCUyCWK2/ecF4jyQqq1FBbubMd2Du2YL7sz+/5O0JBFyXbuwRk6vBQh4v7908rdFif71b1yA==@kvack.org
X-Gm-Message-State: AOJu0YzI5O8JEKXOfSG+dMZRZSovYamiKjhcbyB4t5uyYF0KbfnxQLWR
	ckpfgDD7XJiHPqqrM9A0VtPBOr7TIp8BgdDehQN28FXv0xtLTJZCTO2cCkqe8828N4QudosqnV/
	WWw6beRAwM/pwWjxp4adnVaa1J8trV+nvrfKZTruc
X-Gm-Gg: ASbGncv5YKz7OZTFgxjWYje48obZKTwhw0gnmOnjKQGfqE1KewmKNNfVllbfl+S5gFq
	++/pf/9hj5cNkZNSGxZPND0fIC1hBM9ntJAtbz70jEM6u6dgBILnD3bAYzBlFOrD2HqHwOZ7MyM
	zCNKkt55CvPwcPv4OPuWT4tdFJTq8BFtaG9t0lGrAbEvFgiZUTcIM47m+l3QsKpSnbwayCZyhNr
	m2MfMZ6/qR5pE5aTOi+MPV9GMlqcAtOmYM1Un8z1B2UGdviVV61wcnhyHPrRy68t4ib3rkiLid8
X-Google-Smtp-Source: AGHT+IGvsstjeffMbp1ePFQhQfhyz1w3TBL7Vrpso3NyYJuEzW6XJ+XIKOWxbfWeymVsMQNNGLjg2FcyDIgoAeFr/5c=
X-Received: by 2002:a05:600d:60d2:b0:45f:2e6d:c9ee with SMTP id
 5b1f17b1804b1-46fa9b5c782mr7327035e9.6.1760243041944; Sat, 11 Oct 2025
 21:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <8ef5e3fd-2ee8-453a-b8ae-584e3d606aa4@redhat.com> <20251012013707.ukkczekcmhntrot2@master>
In-Reply-To: <20251012013707.ukkczekcmhntrot2@master>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sat, 11 Oct 2025 21:23:49 -0700
X-Gm-Features: AS18NWDNNlba9cWDLAJfo9IaE8VDGLe4DW6zFS7qQrYqn3KDTM-KUFsGnG9Bxpw
Message-ID: <CACw3F53kD_Toxwvb-WXsfhxLYwKovGoPKVV5z-_r6S77a=hH-A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, tony.luck@intel.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	nao.horiguchi@gmail.com, farrah.chen@intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Zaborowski <andrew.zaborowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA043C0002
X-Stat-Signature: 1mqof1i7tsw4ba9y96z7gk6bx4myhqwi
X-Rspam-User: 
X-HE-Tag: 1760243043-820663
X-HE-Meta: U2FsdGVkX1/tf7+VNhIkJWiMsKi1jNLYCL4p6miXxcsiHpOQGcLj77fNSXHP4o/+lccSET1I1EljGAn04RWFI9OFlVcO2imqcBVhJalPwKRVWGq79cIGx6Y/L6wKvfr4IC40T2UPtCGvRzZ4zCxn/LJCxUSQc2MKuwidq/M/IIheXpE6ElEnylqOfHa5Cm4PDGjV87ILMQRHj3epiXCrfSxhzqumMczUbObJhEhd0JpkPZ4IltPmhctMRCNjUUuRITDWOuNaJhn/JQ/LaUO4SKzqbcL7qaz8rkm1szF+A3cwpBEQXqvyrpUlMSklE7n34/57UvxIKSVQk5JmMH6WneaDeo2ALP8jNNgRtoKJ0mROtQ6hnceeazeP6KfgYFt62J0qFSMAtjQiukWCHpCeDAVmsLgP7VZfmhDZlMM5+RxvgPWXePp5j2Laa11z49bjN9zkfNAi+hjEP90L+ojQbIhFMrN8s/3xQdnBgiDdBeHCWY8jdumYlaSI3VQslj9zWe2EqlskuXCN7BZSpPsuiD1s0Gar6CHKK+NpAqgCxhZDYECtUdPofv8XGaYTGMNsiww4kUH+RdFWXurEOMRlt/JC1nXx4Zsw2ZerAOuoqlQEGyE6lPSUyeoPkfiS8Tq+O1vU4pgeH7IlH6KmXtB4dgHqEVN62MLk/uR8J+5e8u/WbV/MQMEtTfhL9fQ5xmrsXe2fhX1dKnKQPhOI4cERgZ2VlH9eCUKtl7aMcVC91YL3OuBPPR0YRm8JgDm8aRi/GUhdlPv3cBgdafz99XHFsg/KHOJSZVXa7wdGWblAtUMfTobG0BTxnHA09eVYJ/EOO7NfW/hjSrYG8XL2YiCLxxNVNVcWXXQ8k1/KnpAQ+r6q47fLxEAUOv2F3iBCqkUltDDTZf7xe2YxqNo/qIuECaejTHeua19hR+2EUAhso3+SpCJwrgURdiFEy/a+ilSGsli83mxwQOanQIDyTa9
 JdJzhalC
 mEE5JsdPUU+J+coeS7KrTWJ8qLtIgDyP7YQYP73aewXionj+BtoSZl3S1hL+vYOFGUioK7OwXOcMiYUUzy8kL2xZzXQ+Mer9xrr3L7hz2GqPQLXsvz1pwzEue/6ssLiIWQXjARaNNDe2GNLTUseCx7M29xGrWe8an58pAaZvvxKGI60+bSuor9DkR1d2li+ZsYt5lLRquwpwY/2a/+O97OH1w3FuZ+Jpj5LX7C0Y5g/ofhjI3HmLOGSwzSu5cAEKqe/gH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 6:37=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Mon, Sep 29, 2025 at 09:34:12AM +0200, David Hildenbrand wrote:
> >On 28.09.25 05:28, Qiuxu Zhuo wrote:
> [...]
> >
> >Hm, I wonder if we should actually check in try_to_map_unused_to_zeropag=
e()
> >whether the page has the hwpoison flag set. Nothing wrong with scanning
> >non-affected pages.
> >
> >In thp_underused() we should just skip the folio entirely I guess, so ke=
ep
> >it simple.
> >
> >So what about something like this:
> >
> >diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >index 9c38a95e9f091..d4109fd7fa1f2 100644
> >--- a/mm/huge_memory.c
> >+++ b/mm/huge_memory.c
> >@@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
> >        if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >                return false;
> >+       folio_contain_hwpoisoned_page(folio)
> >+               return false;
> >+
>
> One question.
>
> When hardware detect error, it would immediately trigger memory_failure()=
? Or
> it will wait until the memory is accessed?

Hardware detecting a memory error usually results in a poison
generation event. Kernel expects to receive such poison generation
event from modern platforms, then kicks off memory_failure without any
poison context, e.g. the current process cannot be assumed to be the
"culprit".

>
> >        for (i =3D 0; i < folio_nr_pages(folio); i++) {
> >                kaddr =3D kmap_local_folio(folio, i * PAGE_SIZE);
> >                if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> >diff --git a/mm/migrate.c b/mm/migrate.c
> >index 9e5ef39ce73af..393fc2ffc96e5 100644
> >--- a/mm/migrate.c
> >+++ b/mm/migrate.c
> >@@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct pag=
e_vma_mapped_walk *pvmw,
> >        pte_t newpte;
> >        void *addr;
> >-       if (PageCompound(page))
> >+       if (PageCompound(page) || PageHWPoison(page))
> >                return false;
> >+
> >        VM_BUG_ON_PAGE(!PageAnon(page), page);
> >        VM_BUG_ON_PAGE(!PageLocked(page), page);
> >        VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> >
> >
> >--
> >Cheers
> >
> >David / dhildenb
> >
>
> --
> Wei Yang
> Help you, Help me
>

