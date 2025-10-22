Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20181CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790FF8E0005; Wed, 22 Oct 2025 05:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741818E0002; Wed, 22 Oct 2025 05:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608F88E0005; Wed, 22 Oct 2025 05:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7998E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:55:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AC1013BBC0
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:55:20 +0000 (UTC)
X-FDA: 84025292400.17.B2F9079
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 98988C0008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:55:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSpfYXEx;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761126917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTt8+FqwI8Ns9wpiK4xWzSI+WicFqajXJHIJZoU9cx8=;
	b=CtEFJ+66mV/6vBjHSPOmIp+1C9YBOWxO3+0Nrc/qUFyjcxaXmL6RyvHIHYFiTsfsOgqkes
	uAHyk56UJj2Blt1TLw2T8WSqXnAYX/3QB142CkcnkL53rppcd9zI0Ma98jMWs6qy/gh8F4
	D/KSa1T0wDHU4kdGPz6YoQIw1wSEt8c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSpfYXEx;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761126917; a=rsa-sha256;
	cv=none;
	b=k4/cmANrBpXiPkt5IroFIaZmDP2nnDuGZZDhqpNPayb8H/ZifsDD5y81V4ecqlDsTN68go
	Y98YL55QBP8LI+diNeICg8ieXWY8Nf8HKThblkROA7nMe0zZr0Ye18LYUFbO5AhcU5xhAg
	tSHZNctAuA7JFPp3WSB9+urtYLI35Ec=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-88fa5974432so878919185a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761126917; x=1761731717; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTt8+FqwI8Ns9wpiK4xWzSI+WicFqajXJHIJZoU9cx8=;
        b=NSpfYXExXsIhkF8gIKSYSfyNvriVtHo10IweQPQDj28t2pW0QxC8/5pJ8vOtsBrwNV
         Oi4uM/LdgVqmq4XZLfncAqpnQQfnAG/F80LJ/i7F6qqvLVn1ZM5mUS46rD55jPFsu4jR
         UT4Hj9LSm1KTgqFTSJIJXKDGJhj0+7fD4n6UoJO9GLgZ76T7GQAhLTXsM+kDBm7lc7cs
         Nob7GtFPoAj9pSoIApaRdwIgWK/qJT6dztx+QKWoqguFJ7Lddw+jcRq7uXvT75pf3jb2
         TFd22uMUSK0zluu0/Q6Br6rswxGzwlnhi/Q9VfEAzdFPlxzYd/uksfbZRJ0JokI5oVLs
         cEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761126917; x=1761731717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qTt8+FqwI8Ns9wpiK4xWzSI+WicFqajXJHIJZoU9cx8=;
        b=A6y6m95mnG1+b/chW/VOcSzZYx0bScbe55wEsHIz3ggNuVZkjITwJ9DSNW16Npqxu5
         bkkyBypyny4KRiWHDsWEd+p6pj6WOFh29QU1hbqmfwUF7dD+UeYql9yIzrnYimeMMkQC
         zzhEiqloVD108KFYtbdIQ/a6wktyJ4BIe9lEvvUnYI9xoMm/XgigY1Jvnn4xtZhlsIJ7
         n8O91PIrP+ukTydaqrdW9bOwRUNvnnmpkK7Qu5UyQGSblbvxFqEpiRnaP66UNdKQaotO
         joYn2XR3DAESLrHc3CSDP8dDqWJwjlH8/vRmsv8ge9OTm0+GZqgqjXWVz0uykFUmT8o2
         ROtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy3jUOFefyWpEeRgK9PghOGKVdJL+rQfviw9eZ9kGeLM8LT/LRA5EOlbowfKyC9MBdtFPt3Adjqg==@kvack.org
X-Gm-Message-State: AOJu0Yz0T0jhZIaI8kEorPE6oA2Mer1VWq+3ErkF0A7S2W5p+2VlV3+u
	NK3+OCnaC6vENm4+DJXT1abvPLn4o7/3p74xibEtZhy+3mFPStzBnKbBVj5ZDU0OOupLq3K9abc
	f3oE15z/8IrVSPd/Pl8SC/3sQmNNGv9s=
X-Gm-Gg: ASbGncvm71ElsQkCli4AV1yGt+tgRjacPf1gmYOGFOHtiacfB4SARSvGZ8frRZOUQHA
	Kv8ttio8It0beqczr2Jcmo780ekPmGUBQ2jruuBXZ8Y3lNQ4lkfnvuc56Pmg0MK8RjY9fNfHujU
	wb4G9FtT6+uqyXBsdNjngqDmxf3wm8M07KbEhEfMCKaCaitrk4AWwVEp/Dvmon8z265saflZWKZ
	iMRVsN5LgzCXyQu1dgK9RrPaoWBKsjkA7XGluY9Ro/wD24hjp0/DLufw1Y3AYDePLbbXygiDz6T
	rpSIpBbnd4AkTpRFCeEMqRPqvts=
X-Google-Smtp-Source: AGHT+IFyP3YEd3jiEXUOevWyPggxevKHk8IGuxzG+Kc4aIoWgx3n9rH56kmrDHtPes/bm55BDKJ06bfA1HQys3hLS2I=
X-Received: by 2002:a05:620a:1aa2:b0:84b:97c2:4f27 with SMTP id
 af79cd13be357-8906dfded57mr1887986085a.4.1761126916473; Wed, 22 Oct 2025
 02:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
 <875xc78es0.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
 <87a51j6zg7.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87a51j6zg7.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 22:55:05 +1300
X-Gm-Features: AS18NWC0tC5R_nmZzildYKBiK0mP4MFijg1oZBWOAHCcOJkrnfuDN46LvjeO47c
Message-ID: <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98988C0008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9fep4dxxpb4bjiitjkh58idbox9iqxfh
X-HE-Tag: 1761126917-505539
X-HE-Meta: U2FsdGVkX19VUOavkJs+gghrzvS3kFt01lgo964UgPjDEoUX4Ofxtbitc6odBftHrE4QeHoDxNYctHOURI0CUTslDQlwmDqhAsqsCGnOsGTZ8igMbDjjQi5V09vo6PdUJ1RlBhp7ggT2sZJxqbGateRHmHbuAOgxTtUiCpN/4I+7A6tF+m1bE5kWMtH2cT4b077AOT6ZNKyOX6t96v3mh5UxKLq2O/UzAN40/ID7juN+P+ylLxVax9UmZRdz+LlGTRapIcaQQCTmWb6u/gkpiqUMq4NQMQW9rmOLKuj7DBEi+lKTIX5mizi2KJTQ/4H1cuf+oL+oaeioF4kx/ngPqwyb1FKCmR2m2Fpjxv4LxeFLczDRfl7k0mtkCmXZDpIxNlq+SJfeCecnLgjzeqksfFJZymvt1Gd6RtTlSWw3kOXXdxfkOUTTo46+yXAFfV3xSAICQDtCeWRTmelIweWc4PHkfsLx4ecKse51K+NpFo/8sOgcBJ/gm9YdaG4qbkU0nZw0yDmTq/UH9gSDhkYgQwy0ys6E2lTLKlidxbMo4of7/9YS/3pbzDJlcI2Ykv+0UkgMz+WJsJDOhvKRE0eRhjea9mR1R798Bv9ZRltjsQSK6sg/HT0xgFHs3zCuIbHJYh8PdpCHd5ZQn1oulQijW1udmAddZ9hAL2noq7KXxo/oYor/VDU+sAPIGaxJWmQuNueb2MON4jvSqErkfn5eV+frl6DxHNiQrMi3f/1Uj8xJTuXRPm7DJWkYwWoQXBuRDADD39iuGc/pmlVg8EPoZ+YLNpMjg4YS6P5lkizsugOdOwCtXLu1Ze8DGRRYjZLxCGb6AzJuW2o7X73hyebUen71rR+SLqxUzLkcyMU15VoWSf+7npCkM9wWDc2JYaM+SYJ1aUeViA4HOHcOtN/3z7PDndx/7VCbCN+Ch3vPJrJjycz8AJb0N4vZWbnPWusPz43tf9WDFsNPR0b1bHH
 tUp5rVZw
 PEnzcVK3moi3D5Sf7/1/snHuC7cSHPWYTt5Mi0I9RMJOyvdXNekz32QNZfjphABpAQHbFE7tRE6RoCcA11RVcCc8fEmfEuJnHt8w+omX6nObWsPMJKVPrDCnTVmdRE3ZtQEcMrJiKI7+RyGJhF1/Xh6GDNzNjFuzdCO+URC2H0kNAmAq4gwY5iuGEmJVtARctAW4w16rCnMMDlAaUD0S7pdrJUt2dKstBhETSiKuZKR+gMPIux8rss3ZAS2xE3nBPgAZ1SdVNixL7FyJD9bLQPLfOx0ZLeV4VAMBSVaqwgE3SCVzD+ySNY8ZLWbWdSFLE5CY49lfnilN5ZAkW6onkvo/KNzViQ1VO1eagGK4fYfQHMQ48btnrIpEFIIU65/N03hSXdfzeFFvsexjxyURrUgo04w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 10:46=E2=80=AFPM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:

> >
> > I agree. Yet the ish barrier can still avoid the page faults during CPU=
0's PTL.
>
> IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
> memory writing (visible to other CPUs).  TBH, I suspect that this is the
> case.

Why? In any case, nsh is not a smp domain.

I believe a dmb(ishst) is sufficient to ensure that the new PTE writes
are visible
to other CPUs. I=E2=80=99m not quite sure why the current flush code uses d=
sb(ish);
it seems like overkill.

Thanks
Barry

