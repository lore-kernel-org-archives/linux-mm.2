Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E838F3382F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FA56B0088; Tue, 17 Mar 2026 05:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF04A6B0089; Tue, 17 Mar 2026 05:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06E46B008A; Tue, 17 Mar 2026 05:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F92F6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:44:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6414B1605B3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:05 +0000 (UTC)
X-FDA: 84555068850.15.1895DD1
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 387C7140010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=FBVFJZb7;
	spf=pass (imf26.hostedemail.com: domain of bas@dfinity.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=dfinity.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQVXw5BqQPlrykOq9wOrfS0RtHVDvKlRL1okYmgxXpc=;
	b=PbDpKwiQWOEQlk3rftuPLw49KoGB6u0diMj+gMd32QOwqzHuZKuYvnrHEIL6gfxQJJ5ecE
	8LH1D4U3Dyylbmh4V+yMrmkLBvgXbJ36R7nBRMM2Q4nuGeUDkanj6VocL8y0SM19w+Cx2A
	PEZ5DNZCF8o70aZRd12I9zCAAWgBszg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773740643; a=rsa-sha256;
	cv=pass;
	b=BUrl4UVFkHNGj/DaHZPgAZ4aocGL5rHK13lmCy1fWZoGdC8FjCRosFfhWAH4YzCDwyKxQW
	tM52hVoUZ/LQzCrTc1SVoI1tSk5uJUXcGKqFBq1muZHtwYIjuT9U/IS0EvRyxxn25ASOiK
	4UgxU3dn6jrn06r1UvVXp5Tz52Vd5F0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=FBVFJZb7;
	spf=pass (imf26.hostedemail.com: domain of bas@dfinity.org designates 209.85.218.48 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=dfinity.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b955351e0a6so879909766b.3
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:44:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773740641; cv=none;
        d=google.com; s=arc-20240605;
        b=WFDiTy1G5S49vFACKdalJnxhMJX3cBT0h3+R0hAhz9fKe7/H7Vssrs0BpYmQtn6x8i
         qqNhZBAGYvxHIyLBWXPvcus0OVN4OB5iCV+gGiJOsW9oOhuOxWEGR2c3QsFTZuXH/6LT
         FNlP+XA+u0EuHuRwn9mVic7PAPu8cQlPfGQK1Iz5PIOLUFR1cAbygf6VtMjIo2IfamWU
         2mk/hKjIP2+AMlBAGpslIMso98XeO0ltRGcwCIqsH/ZXmsVE+JWPpWCCSpGXArJs/fhF
         jmRJXNWyfvqi+sgabF3Vv30vzIyoLwq+QehguFKe5CYnX9wQtpIs3b0wpL1PoDvucx+D
         AvUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQVXw5BqQPlrykOq9wOrfS0RtHVDvKlRL1okYmgxXpc=;
        fh=073yx7bRRQnxUbfvuG87uQLhdZcY1A/z2OD3Gjy31Ng=;
        b=brEVAZs5xKEynDfUErMQWMfQRMbw5e8ImOMp0Svrsjs0paFLnbqJk9Ei8Rbii5tPfd
         WBdTi6omKRWIvpwlNB4VeRqErLuaf+m4hq7885AnC4X16VEIibI6L0BDN4tvzKm5D8yl
         +FwrP8eSa5lb60/o1cl+pd3R4HiJ9Tm/0fYTAByNoNDx+My3o7Z3J3InB2KM2bSNcosV
         aMNxf6+MaV2AvZFFtKdYRa7qpYIrkE6IvRaE53ZQ25m+kqePZKuZbUdrsjUxOKLnGiR1
         6WgumfrAPZ6Ew3i1NlK7rHpL+STt0CiT5lFm+Il5+uRcqyg5VK9OCxZVAteFeEZnFzLo
         KQKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1773740641; x=1774345441; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQVXw5BqQPlrykOq9wOrfS0RtHVDvKlRL1okYmgxXpc=;
        b=FBVFJZb7y6VKGHooOJkO6KrJ3cWEHDbSY5IzIrksweHor1+IfJsjxr+mQJrZxauMbL
         AtTWtM2qB2lT3YJCtCGLqGa9dbvtMngVKg5crqyfSsc0aGowO0mPUFp+q/A6qxyI67Mn
         vgDN1k91jLIsr8ksbuCCdM//mAzEaq1j6hPLS8bwMe9l1TT90eRBZGHXifyEE/EwN6st
         F4d1Z9jqnfQb32/rk98b5S2Tp/ZEL7Ec5PZVq3bmSWOi6n8Nc+cinYSSIIn97imzjx0D
         Z+hVdGgdmwQ89U8OxPrRTG7tTjoo9n+aEKFGWTU5g3DtJBY7dW6p7XaAl8YLEiNKABMg
         oA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773740641; x=1774345441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQVXw5BqQPlrykOq9wOrfS0RtHVDvKlRL1okYmgxXpc=;
        b=WJfeS+ki/664Z7yHhooa07ybeZW1DRCd1xDOrmVX+iHSF7QRYxX2vznyjGhfUPEgiv
         tcr9R9s5OJ+4IwQ0NZsKy+ltLZP6N0X/59j+tJQ24QrDElWX+NpDn1J+EmvvXHK+WnaV
         xgesUwWsgLUoyAdO9zkk5RSo9fAZwzFKAkboudDKgTUtPy9ji8cV3Myr2RGD+cUYN98k
         M3U5i1kp7H0mXDKwaHyBN+RGsgE9+KzxL80phNJd5aZnkeiCO+4+RE2ID7qTSv7dGXX9
         J+c79C2Ud9ep5Nlz9UQHyvBfYrfVo59ubd/4PgFNLm+7FDi1qnRg4yjRcrPeHQXPFQlf
         DoMw==
X-Forwarded-Encrypted: i=1; AJvYcCV3HHx0S/0q8WfyG2yshjTGlu9dCPvbTuIeiy1altXiXThzMtJoykAFBz3abKqvMlQZN6cgPr/UwA==@kvack.org
X-Gm-Message-State: AOJu0YweXaoT79kdbNNeWdXjoNe/l+wRUVNWs9MhOFUNyTsV38ulLxyM
	Y3cNLTyM67TJ09zHXDdV+RFG34cVAmNY1puJXRzkReDOXWRlxQVGNhsxvcEm642JTyotsdYD7Bp
	a0DsK8u4cwAbeLNX9/ituRjAtVU+5KafFim2j95S7XQ==
X-Gm-Gg: ATEYQzxEgUXUugh0MHFt+UgSIRy9wNLwMnT1/seqQ34RXY+0rXpQac1AY6nraQQdUbF
	D4tX+jzd3VxdzPw3e91SFajOiJ/OAIDPcRxud/e2BedPYR4ThL7cDelyGhrviCXyb95/U1GGjyI
	CLtLy0ivSZHypYD8YJh7ZfQ0sFaDLN1oxltUNzEDqYn4lIndYMHQAy64zbIJjMdSkZKclUOOFRX
	0waGYgEx0F+pk8JhbMol3Fvjc8rfdpGdTc5HOdV4m9Z3kiIxtrifEndzBcQF5jteELeu7cr2R1Q
	qV/U5q8=
X-Received: by 2002:a17:907:60cf:b0:b97:a459:b66a with SMTP id
 a640c23a62f3a-b97a459d1ccmr570643466b.25.1773740641289; Tue, 17 Mar 2026
 02:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260313114037.3593642-1-ziy@nvidia.com> <EC71CE3C-08D9-48FE-95CB-B6A43B4BDB9C@nvidia.com>
 <CAON2GcE-1t7pbunFwtymxEiz1f5osT2CSEGw35Lv=7UaWFkZzg@mail.gmail.com>
In-Reply-To: <CAON2GcE-1t7pbunFwtymxEiz1f5osT2CSEGw35Lv=7UaWFkZzg@mail.gmail.com>
From: Bas van Dijk <bas@dfinity.org>
Date: Tue, 17 Mar 2026 10:43:50 +0100
X-Gm-Features: AaiRm50lvHy9nwqfKUin80CixoRq3XUbY1YqSLlRzLkGbYylSr1K5KsUsnHB3zM
Message-ID: <CAKNNEtwtgbzGX3Ac8U4gZ40eRiMpmU9EAPM-epsnR85v0uprHA@mail.gmail.com>
Subject: Re: [External Sender] Re: [PATCH] selftests/mm: add folio_split() and
 filemap_get_entry() race test
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Eero Kelly <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 387C7140010
X-Stat-Signature: iwskpz17s8efqr4smytbjbx1kzbdgief
X-HE-Tag: 1773740642-646985
X-HE-Meta: U2FsdGVkX180a4cGYdkc0cq1n5XbekZvj/veDaS1Y51N61rbmu1R2VBRdfs9ADae2jhy+3nIJcY8VRKEvU3ecVG90HXyvUH+wBnb8G0wM3Yx7WDkdAfosSMLvaJ59mvFiAo3Yb0aJS0OXGaNKTALP3ZB8WwOxoK3Io/8KjQkdmvxSsQnVVcN81c5wiG6LzgpyiK9a6SdDqDXFv/dcUrE5PqFPTGRCsaYnSshpFVWwS7BhmBIAJFCbiJtNVJm4nHkctfD/TmDvAYwyeWvbtR2j5w0229e+9s9ghGBAUHWOOmfhKB3JkkhZV/6tlQiv07i+raz1bFfG+pTQR8Kmp0ByjThnVmS1zJQHJux0KTAhvPCMIbhBLvdJ0nL4Ki+xl48KxtAf7yptKYZk6Ckmw0HGuue3+jOMXfC25z+NlCXkH1Zxi37CAVPkpHHCPjn3Ua9sdACsy0gPqm1KMZDzSE7mr2So8fYGzy/ojoz38S8i7NjtVHELWAJe6D6F4phWZVgSW+FmrjwVETOEg+EfEcb3cemeHhm4MmifvxT//T2I9nE8qlEeYPXN3EBOL2ecamv8Nexzj+QEpnPgcxLW87yFXFsJxsHDb9vCl726Qp224Znp4IdTw37ak9d8bVAkvMlyrDzsb5H5MFgaSBFN88KixwXWW0Y6DnvBbe28lfTWuBYz47EqFPBUCsCiWH46Z8bmocRbEkJhhfi9VAnkH1NCqLdAl71EgNNTHGoK7ApKFcD0HYFL90k03xRy8hHVTsHU6GIbrn1m24drefjRxn1QdYdEQ2vDLM5vFLshWw0Nxnsk81TND3y7zaJuIoq7Ck4kVZ7RLox3pcGYGUvDIAC6feukmIAu4uLwnumZU9uGb/P9q43QyfevkFWbcvuxn8naSUmnxFczGuk0H6N3rWdkWKgx6B/vIHAk3KpkKodH5kDWaF0eyYeONFx/tRHyZXVG7sert9ADbb13KgaxVs
 KTZtDSFK
 GztoTojxP34nJgfFtQELvyhU5UXBw+LkFNfUoIuLy2roVfUywWrwes0we7ZilqLV7rCfiaznJOcUJzhHTofYQ3yZKnNx1uHjdfkw586PXGPNu//H5rmlMaZcS7FtO8OHvVh/2dByyyqZ+30iM6e7GWArkSGMA12S27x5OPPsRpNeJ3O1R3vSpJDhW1LEVciPYfKNY7HUolgavxhTnCdgsGRzCtXipi/QYBag0MU5a+gnl8lM7FAKlxcRvXNkmZgWmULgTrSNz6RvySklf2iSWfBvtWbbTyEPOq+lPGTG7S0iOYnU6ivA4j4JoD0O9W9mbIruw9u9MdRZhCorFe4wrs0GazGFPGY/hAMPfQKaZ8yrxbRh6qWfu1vKW05cPvdNnQhvg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No problem for me either.

Signed-off-by: Bas van Dijk <bas@dfinity.org>

I'll add a GPL-2.0 license to the repo.

On Tue, Mar 17, 2026 at 8:32=E2=80=AFAM Adam Bratschi-Kaye
<adam.bratschikaye@dfinity.org> wrote:
>
> On 13 Mar 2026, at 7:40, Zi Yan wrote:
> > The added folio_split_race_test is a modified C port of the race condit=
ion
> > test from [1]. The test creates shmem huge pages shared by both a paren=
t
> > and a child processes, where the parent process punches holes in the sh=
mem
> > to cause folio_split() in the kernel and the child process reads the sh=
mem
> > in 16 threads to cause filemap_get_entry() in the kernel.
>
> Note that the fork isn't actually necessary to reproduce the issue. I
> had it working as
> well with the reading and punching in the same process, but just with
> two separate
> mappings. Not that it makes much of a difference - just in case you
> wanted to simplify
> the test.
>
> On 14 Mar 2026, at 18:27, Andrew Morton wrote:
> > I couldn't immediately find any licensing info there.  Bas and Adam,
> > please advise?
>
> GPL-2.0 license is fine by me.
>
> > And sending your Signed-off-by's would be appropriate.
>
> No problem:
>
> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
>
> Thanks,
> Adam

