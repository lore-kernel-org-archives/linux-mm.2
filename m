Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4628ACCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7588B8E01B8; Wed, 29 Oct 2025 22:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1188E01B2; Wed, 29 Oct 2025 22:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8BB8E01B8; Wed, 29 Oct 2025 22:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44DB78E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:38:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1859B832E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:38:51 +0000 (UTC)
X-FDA: 84053222862.14.0A3EC93
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53D3840006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:38:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B6NrGT/J";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761791930; a=rsa-sha256;
	cv=none;
	b=p/jdScglwjiXWuiC5A1ejWpu+ktj9ZUtW0BZ8ChRWyFHiA6GFllz5hA/XF2R+701++RQiJ
	FV8M6qDnPEJdCw6TowRP49/1beG7AT4A/5AL3FNWxwOobdE4s9p0Co+lLZ0xkesTPgYImb
	JPwlnvbv/tAca/FQL5OmamqTXD/U6Sw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B6NrGT/J";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761791930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6nNeYJj47LC/Yn9TG11EugyfogPj0qEsWlsX47jJWc=;
	b=vMcbBEt150Yb5LNjJi/ZSbH9c9HLbJwEOy9Se7MNWkRUE3JTHUfnBJIge403bgSnBURqtO
	EoDc/QJQwKo33D2m6tTJojP1Kk4ZjD25rp9riKCfMY6NCrwQgN1lC2i6yuaxzshiZDTSQ7
	SjYbuBtWaqDVEJPLikLomQ3ItjBDOBc=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-89ec3d9c773so71989285a.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761791929; x=1762396729; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6nNeYJj47LC/Yn9TG11EugyfogPj0qEsWlsX47jJWc=;
        b=B6NrGT/J2KOKOFOmAM7B8emwUU9TnCh1p8mkqu7+ulcN+FKgiqSMAGdjTvEZSd/znl
         JL0//SaGd6r7iC+C9V9toCWC8AQyDLdZ41BsLI2h2SuF5EC3zbgUCLAMLW+o5BZm0yS8
         XkzdQCadfpueP1NbdMriN3DCj1GnKohwjYWKPZhujIzYeJ3hQKwFgvQpzpZeAdn13Q40
         ChSUwEas6XQx+d85ojzmrSVUmz0egxgSmtXYpwTt6lUSYmoqb1/biVyTIDqcL0apsn1I
         KIedrIULvN8q7j9v91Mi3k/OkBhGv45cygMgdmmU4m61SK6PTLvd747Rh4GwfZTr8ghx
         ZODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761791929; x=1762396729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6nNeYJj47LC/Yn9TG11EugyfogPj0qEsWlsX47jJWc=;
        b=dPSaHueSbF5JOSkc0UAdoGTnhjuB54mgHxY3yqrjK8sGSTPY94oAIKniT/TIw4WwLR
         jnVYIyXSDCz4J5mkgxpGmIepHguEDB3aPjHzqJUpqR4q7yBCrBDGrTS02am3M0hU2NS8
         F1KW+tuJGTxsbGtReCE2v/gJHgaJyCyDDWic0sg35dK7ZBv+TCOIwqZ7Ls18nAYen2AD
         /IqNi1s8ljCbHhuslzsuEPx//xTLyHE2CYSkfN/5u4cfbC/01RhGMnf6PccwvHUn+z/O
         uIBk/SljOPErWXuKGYpuRIUMPa0p6RH61jBlRLz1udJ769rlWuVCxbIUrfW4J1cSXcD2
         HjBA==
X-Forwarded-Encrypted: i=1; AJvYcCWsmq5TrkKgf4vBfWxjg3QtmhAMNOz2vlmNmfHziRG1vnGRoytXfy5/4GOByVZRlt3pTgBHKCLgOA==@kvack.org
X-Gm-Message-State: AOJu0Yzojoq93ZS34EQLhrqIGIw7710o/GN2Q8HyUTjKXfO4j9rS0n1a
	D1qyv3936ozOGv8B7THW/VqmnGas7qBOF3qO5Zt2sShbLQMcMhFOei4K9W2dXv3m5vNMdn3VvmU
	tueZFn4q7IZijqyWrV2Z2uwG/2+yTZ3I=
X-Gm-Gg: ASbGncutvuy+Pw+4zwWXDdddwgq04FltNcSzHLcxlkOk3yEnZOfSNTsgBZ5atHfd6Ht
	zKDTzqWlcjhJlTGzHR67oZ8o5p5KrDFa/g21MLS74/NVVV1nKkL1En4MPkEShKvd9nnWLYWCAif
	hAAp7AM7KqZWDz3KXdGN55Pon+e3jwhaXXGwmg1d869jKgASRGpGqMxyAtkzrw5Y3v2dIMdRf19
	v5V/0igMG/IrV/vMM5nWLH+wnWJpxeVNIVAUMvBnx/t7nD9JuPz4sPcI/544qs2NPY3ojv/a/DV
	LNzoNTOHMrcFFV3H
X-Google-Smtp-Source: AGHT+IH/NdEqkxVdErKm21bKL2gsa0HivcBd1sC5JLSxUC0NTL1b+8ekEWLzZcLSO5WqylHT28D8+ZBosG8IrfbuoAc=
X-Received: by 2002:a05:620a:6919:b0:8a1:c120:4617 with SMTP id
 af79cd13be357-8a8e4ff156amr776454585a.51.1761791929275; Wed, 29 Oct 2025
 19:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251030014020.475659-1-ziy@nvidia.com> <20251030014020.475659-2-ziy@nvidia.com>
In-Reply-To: <20251030014020.475659-2-ziy@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 30 Oct 2025 10:38:38 +0800
X-Gm-Features: AWmQ_bnlFtMc3CzOHCzWJ0c5wI5RvGU_i4SjVvno9Biz6ZUIiW7knGxWCgCNPkI
Message-ID: <CAGsJ_4yYrk5O29_+YdgufPCJ6h2xbEE7q4EbtFPCS6xqivWFug@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm/huge_memory: add split_huge_page_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mgnixjef785c6brotkrbtakf6gajh1ed
X-Rspamd-Queue-Id: 53D3840006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761791930-709531
X-HE-Meta: U2FsdGVkX19wnwoHAF8Qtl+g3GXCX495ebyHhbdujSPOIpOC/1BOs8egQnb3pYhfenYjm8KzpNn4gDmzBRnoMkRf8WVnKINUqZm/AVnIThKdAylW6Adrvvnrptf0iFcdp6ygUrRr/O7hJIVu138dtFiqtQTG9YUl3DGMN4/i6nBpTKb+HYq/kHd6eivBxmr0krAL1QkAvZCRA19OuPXkj32D2WEGuowDqF9yjn/WHVOzEJryeu9+LUdovCSkd0gEjbs+v6VEpdotnWqToVQMs50LE++IivPrW9SNKC1crv2BJhevM9qQU8IgCivZjVOV/gtsfMS91zp177lwHOZXLIb8bGxnXMV3dmNiRbgP6YrdCLOmVX62B2Xvp/9WJk9ll0o2veZEaQot0dOOQ1QxyegOjtJLfxHY+wb3kKXCGASJ35eydXyIBMQ5liZmHR651v+SEZB2zYJCh2j7qn+c1wjg7nfj7DLNB5Zjm7R6cFQKDs8Qy/bAPX7Nq+KEJhfKO7AodCh73XJgHPqjJ3TBraGdSYwr7UzY0/JZIoubuiNo6FcCOqIxPL+qw/m3v4EexBAqShefQRGJrKTBz2iwX/eos8rEVm6U3rhmeyn4/65NinTi7LZp/AWmtAXTQiN9KjC1vtfguQZHe36WH1Axk+D5EKOu/vF3+jmIwZi4z3UQz7WZbRM5kv/FQ24onwfTxdKGa/VFh+6Eh+fLSG7XQjFOd79HS8vKFo+gtpuCvpSQYbE6l5rjyi5ATT3d5Scis6qUAInmEXGIIDPkHfaSwgvMzNlRey8zCVrX7m/dUMJRBIcJ2e1rq291g1566Y87bF4TLF/ewuf4ICV0DtPC32a4uj/P+/V1gPvRViDWcUWX0eLNXlnF8cBKdhNkyzB5sC/nZ1zif9mhHoqkc5lad6mdZW/uB5w0XlyEW5eTo9GVfoUNYsaUcN6sgHK6L39xmtwJN7oVDKoGyUS9kHI
 Z7uVqoOO
 mn+5+/ptp8Kbklyzqc1MYdKwpWg8wLKQIxSExHqG0UudVQGDJ3uNIj42Bdrft+ySvx+0sf0AgeXb5KspXQGSZW/av4iLYRdS9ZxR2jOxcp9EwXq7nwUSNxOH8slhOJ9SBgmpsczdr2ctGRW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 9:40=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/huge_mm.h | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>

