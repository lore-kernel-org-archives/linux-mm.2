Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB64CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865578E0021; Tue, 19 Aug 2025 10:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8150A8E0007; Tue, 19 Aug 2025 10:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703F78E0021; Tue, 19 Aug 2025 10:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6468E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:25:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F1CC1DD991
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:25:00 +0000 (UTC)
X-FDA: 83793728760.02.4AAF6BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E838C0012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:24:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GO5lo9RH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613498; a=rsa-sha256;
	cv=none;
	b=q3G/5f5sCfsrogRTsiUllfPF8ToASkgzeESsgyvEUqwvBQrqhURe9YApwUIEAsl88qQnfq
	PBV4YFTBLa367TbOANO4e8e0YTxWK4fraRwKWJzzPjc71tfGq5gv2zYvwqO4Kq+wBO2NPv
	9nvY9nZBi1i6FAj1flY2Dj3jazqxpOQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GO5lo9RH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+6rtgrIobcRQVsNX25xQXMRbcgLTca8mFUg3pNO2o0=;
	b=3QpH3qVyktuEz7p5065tq8h6eNjKjbfo3lOIsT+tmwDCBeSz26Y8W31quXcawiPbPOgAKu
	DyQGm8Oq8TQWwBNoflF2pmBwMYI2GbYAwihRD7Kj3jqFxsPoK2Bc16LZU23/foVONuPgBI
	pEfe8qbRZfF2xgTUm+MgqJg5iJ9F38w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755613497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+6rtgrIobcRQVsNX25xQXMRbcgLTca8mFUg3pNO2o0=;
	b=GO5lo9RHF8c99I70sI0pKLdBGUFR639I9EF4bAl+Gb89YHmEbZQMG0+OcW/jdBz7SldjRt
	2xn+tO27syNmtKq7+tWa93WW/fjGHmTM4NOdaiy0w6a9vDOyD6O2xdaE13jE7A/6yQwVdU
	pv4h9Z03dKGyZrOaXsCV1NF/rforQCI=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-nLVxqTNhONe4kFik4W0AKQ-1; Tue, 19 Aug 2025 10:24:56 -0400
X-MC-Unique: nLVxqTNhONe4kFik4W0AKQ-1
X-Mimecast-MFC-AGG-ID: nLVxqTNhONe4kFik4W0AKQ_1755613496
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e931cb2a9d4so6714985276.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755613495; x=1756218295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+6rtgrIobcRQVsNX25xQXMRbcgLTca8mFUg3pNO2o0=;
        b=AlbnI9pDKYAomkPsP8oiF/G1DFs7NwGGluKwIf6+yF5OWpMI6mE0FTSYpl/xzGh16S
         ZQMGTjHT3wk8/015Nt3ksZ7jRyXQaGhY5Cai1cFmUuTMzJnwn0jusz2/jjF9uu/Fvi92
         plBLJipISM8EPyvejlVLSYyXMBBCACpLrvtygsnaQ9H5ptb9Y4b6LgnNttUOEILbrGww
         T406QDGhHUnQ5TbEUeplzOjUdSBSgbtVw/Z9QCpGgCpgWuFTEqrSIuW7sFwl06GJB+2v
         Q13BR5Cwp1qLfKs804UdDDAdPf+/pUxqg2zXTsHB48127rfS/WQlJ2cWtpZyeeHi1y7A
         FZ5A==
X-Gm-Message-State: AOJu0YweDT7ggDDwa+HdSkkAP+ap07l6SW15JHtp9xoFkVMiVIY/k3EM
	0U6zrThcvPqlXOs4CNW44SB4xGjiYfePW87psy2zLdR42E238IY0uDIIUt2MiW8xl7iNqHfBPyz
	ll4XJICBgm/jO5jGfF9nNVEkqPHkkCDCLsso5SIc3kDBNcnFQxDWHJU8rRm1rT3HtDE1yUQuTKD
	8z/zOUnzKOt5tW+bKiMmPUYHf05zQDBgCdnzI5efNr
X-Gm-Gg: ASbGncvs6eteSTFsVNECwKjsezykb2czZ+Z4JxwWESjFhxg+tuOiNjAI4ol09K3sB+R
	VotuidNOLCbwDX+5EVQMUh+4ukeVmgg+ULd3wt1sdLCPMuU9n/1QgL2spxPmaKvWsaZ+g7Gf4BJ
	m4epcSfxxqXv4cKd/pNyPw07s=
X-Received: by 2002:a05:6902:124d:b0:e90:6b79:23b5 with SMTP id 3f1490d57ef6-e94e6175edamr2941254276.11.1755613495457;
        Tue, 19 Aug 2025 07:24:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGF0NyUe7/RofjcC4QixzaRFRmVdElcMtMYnzi+jpWMgZd139uXmHSJYXx/CbZFkRV3womoYTYYBMDs+rGHGVg=
X-Received: by 2002:a05:6902:124d:b0:e90:6b79:23b5 with SMTP id
 3f1490d57ef6-e94e6175edamr2941207276.11.1755613494924; Tue, 19 Aug 2025
 07:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134824.623535-1-npache@redhat.com> <20250819134824.623535-2-npache@redhat.com>
In-Reply-To: <20250819134824.623535-2-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 Aug 2025 08:24:28 -0600
X-Gm-Features: Ac12FXyGOl9R8GM6piGm3MATFXxEB46AmdLRhkeJHEPEb8_8zxs7ckcl8qzqEps
Message-ID: <CAA1CXcCBu290fywdxqCY=05ejSLL0P4z5KWRrMf2LRxz1VzYGg@mail.gmail.com>
Subject: Re: [PATCH v10 13/13] Documentation: mm: update the admin guide for
 mTHP collapse
To: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9mR6ERNpDJxdKO5OsuvQ-G6kjUdeu3hyZUuRmTqnzTA_1755613496
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0E838C0012
X-Stat-Signature: bizb4wrc5rooankuexi1jbua7uicoyu6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755613497-134570
X-HE-Meta: U2FsdGVkX19aInKaNedAtasbYfHvK0RETSA1xoruJMOWBuuegKlP2Q9eDVvEspQoKGXfHUyaRxVsPKfzldwP+7r/0NdtWhQwHc0XPtTuhPA85huo5BahR9AoxfLjG4Def4Jp+I5JetAgdDDjqapuXa+x3oGbR4reSG0UraoTRhaE0Wylbpm2KRhSYFC8pFEi2GEfneLkZ5EWf+ddyJqVtVJfzRnTjrthu/DNkI0lbgbW7j5zDDommhvtA2eX0Qtd4sA57Gu8+5H77+x6eFzMmlrIuSjrfdZdSP48AQJ+eEhcZQeqiOe6Q4oYAARp/+So9QEA0lSLgNVdz35+6M8U4BlOCvxuqnJ+hfdtFgGpjI35qOJbC9ksQo1OmHrQXuhbzrrvBR4+DKiPUPdY5PbYHKcaYlqQYWCzoNbMTEu9r8OE8R++UP+6Ru1K1j4MFrnu6GFXY4X7CEd1IUhZo1X96jswGMVvYRKF7ziR+roSmdZIN+YydyDmm/m3rDkADLPOyth2ug/2moJ7xq+mq/2Ve3ZZ7ypUnV6LfQYfFs6BfQBdaKgWeUVUaqPO7w0tUbI28WtJjAM+0xUFNN3GvV2JZKnkKr0MhKMKln39raxEaGn0btX4jzwGaZXA2/XwuMm+Ops8s9BeQbBV7Ka1bt3gAsk3Yo+DdHIHJIYZIvJ427YYtcjal/4dv/fI029lTaooACcIpMN1eISR+MdS2bDQQkpY15i9U+AtfFiEoYxs0w57je09RjngxSYbKdGCfkAyu0bOKJDJZIifWAFeNllUTuaaVTTA01uNYI47F8lLAjpWNLIJEYCnbemoixstzY6zSTZAl62U28qwWazkAbiOFBlA3Msg/kkjEXxF8GoPQzA7BHNeWtsQ01K1y2knNnC2FjnG6HsO0LaAPxNpOuCNm8fGtRbA3rXl2MhxC0loS+OKNFvvqqOrfnkh15GZVWCYWvWFw3tg7jf9MYW35mM
 qwfA6tdb
 m5CGdDws/Op862Rzka2MjmceRxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 7:49=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidence on how to utilize it.
>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
I had git send email error and had to resend this patch (13), but i
forgot the in-reply-to
please ignore this one and reply to correct version

https://lore.kernel.org/lkml/20250819141742.626517-1-npache@redhat.com/
--in-reply-to=3D20250819141742.626517-1-npache@redhat.com



-- Nico
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/a=
dmin-guide/mm/transhuge.rst
> index b85547ac4fe9..1f9e6a32052c 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -63,7 +63,7 @@ often.
>  THP can be enabled system wide or restricted to certain tasks or even
>  memory ranges inside task's address space. Unless THP is completely
>  disabled, there is ``khugepaged`` daemon that scans memory and
> -collapses sequences of basic pages into PMD-sized huge pages.
> +collapses sequences of basic pages into huge pages.
>
>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>  interface and using madvise(2) and prctl(2) system calls.
> @@ -149,6 +149,18 @@ hugepage sizes have enabled=3D"never". If enabling m=
ultiple hugepage
>  sizes, the kernel will select the most appropriate enabled size for a
>  given allocation.
>
> +khugepaged uses max_ptes_none scaled to the order of the enabled mTHP si=
ze
> +to determine collapses. When using mTHPs it's recommended to set
> +max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255 on 4k page
> +size). This will prevent undesired "creep" behavior that leads to
> +continuously collapsing to the largest mTHP size; when we collapse, we a=
re
> +bringing in new non-zero pages that will, on a subsequent scan, cause th=
e
> +max_ptes_none check of the +1 order to always be satisfied. By limiting
> +this to less than half the current order, we make sure we don't cause th=
is
> +feedback loop. max_ptes_shared and max_ptes_swap have no effect when
> +collapsing to a mTHP, and mTHP collapse will fail on shared or swapped o=
ut
> +pages.
> +
>  It's also possible to limit defrag efforts in the VM to generate
>  anonymous hugepages in case they're not immediately free to madvise
>  regions or to never try to defrag memory and simply fallback to regular
> @@ -264,11 +276,6 @@ support the following arguments::
>  Khugepaged controls
>  -------------------
>
> -.. note::
> -   khugepaged currently only searches for opportunities to collapse to
> -   PMD-sized THP and no attempt is made to collapse to other THP
> -   sizes.
> -
>  khugepaged runs usually at low frequency so while one may not want to
>  invoke defrag algorithms synchronously during the page faults, it
>  should be worth invoking defrag at least in khugepaged. However it's
> --
> 2.50.1
>


