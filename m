Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFBDCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431848E0102; Wed, 29 Oct 2025 17:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1BC8E00B2; Wed, 29 Oct 2025 17:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D11D8E0102; Wed, 29 Oct 2025 17:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA2D8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:14:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6B6D13BEC1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:14:45 +0000 (UTC)
X-FDA: 84052406130.19.772D48F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6AAAFC0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:14:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E1DbXeuC;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761772483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPTTtw8BTZD1fn+qIBXIK1gjHXor2Nf0ItE5USDfdEk=;
	b=Ly4hddSgpvp9/qoFcMmucJyD03wC9CWIFLnzhAZ0cZuBESDwVBPoRCz9dkimYmecKehaJl
	Dg5bFgkR5QJ+bylhn62C9VqWrAr45YmM8D0v+nmsnea0RaWnvJ/U2S3Nu4RNOUd15V610A
	IB5av887QuWFtjLVxsL+7gwf2/3D7cw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E1DbXeuC;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761772483; a=rsa-sha256;
	cv=none;
	b=WXtDWSnC+/R95ZsmYQOFde2fB4YXI+M/ZOCND2iVRe1aYrrTiQRLWjgYhvpQaCRZUbvvNU
	TH3OD31ZBJFC5F9vZpBFy5n5BcpF8UxJQ2K1S9RodwFDH0n7zhm7mY6vi63kUGanrRpq8r
	943VAHz1/B1NDzmMTS4oXd6/5vGrKTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761772482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPTTtw8BTZD1fn+qIBXIK1gjHXor2Nf0ItE5USDfdEk=;
	b=E1DbXeuC6tFAca0iR9b4vjcYrkMSifmOxcPwg1evTydD2Acwre//YK3hLNyBCrlnM3y+g6
	GetOqy+PHo7vHq7Or6PtgeDoMs1y1HPwws/aBzFddmNGf7fx8C7T7bBXxUtU3x5SQJJ0Ys
	bCFREHAolTigBwuPHW5XgXme+iptwFA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-Z1K_-Pa-O8aV9Jg7TvXWeg-1; Wed, 29 Oct 2025 17:14:40 -0400
X-MC-Unique: Z1K_-Pa-O8aV9Jg7TvXWeg-1
X-Mimecast-MFC-AGG-ID: Z1K_-Pa-O8aV9Jg7TvXWeg_1761772479
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-36d99707249so1040721fa.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761772479; x=1762377279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPTTtw8BTZD1fn+qIBXIK1gjHXor2Nf0ItE5USDfdEk=;
        b=h8kZl//YEw+13/A+oCuWkX81vfqlxxkrOq5uAolIvDNvuPpWCN5C3TzKk5oi6MFkbP
         hHiKagi5y9sPApVZipEFhueJrw5v24f0WbkPcm4aVbpaozyapAIyMgAupfdLOAv5gWtz
         La8IS4vxO8RVbAnkHQSKU+Kgmc2R4F1UALr2+YcCHnyZP1qqbQspRiI9lEF3/L0eywiy
         5+JyoWUfEe1EDEEf4xiXbuTl1/fBQ04hseoSeQ0rtT+zAcZgFS7Pe4pHgxD5X/mDKqsE
         E6LvIXJY9HmUpei4a2GOHpsZ16X9g92LidZUgo3dRi8y+FkH5NMmca6yTE5uFplDN0UN
         ajow==
X-Forwarded-Encrypted: i=1; AJvYcCW1KFX9t/NTHE2olV6XENF5ORCNv2JRWwh7U7eKwr4pg1mKYJpm9qmTMDUmr6X1JKSZApYVrDEEog==@kvack.org
X-Gm-Message-State: AOJu0YzBnhyQC/D5peMqNd0qZ20abw/N/Vl3y6a3RBgZO7jM/hXA5jvd
	sIoOx2BUe2n60H7XffuONxPzj/1X4nJul2te7vnAsCXOWiWX8SVDTb5VnFb7OAhTYykGsRVklFp
	6wONdwCE4URp1CJegYhTaFHay8X3A8Ry/MQIEKrzNJJcBTfB6YAIal0z4TvuddHigB+bqHK5wdk
	WUsLXQAp3DeLfKzxaBTWPOmO9upqs=
X-Gm-Gg: ASbGncseAUKvO+42NLnYRt2PKrnK0NugV1qiWAtySPz3gr1TR7BXntbTiKEaxFJVZsR
	kVfpmRsMKqPzbyczKDr2paNV/AOwdup4JwzkCUF1hoNL0TpjCJK31zv/wRjcA56eZD3Fksyuq7T
	7zCKHeuEEr/k8YXmba9Mf44ksYpdBbHp1IROVFKcJnnX5r08KW0y7HmbFEHe7Fjp7idKZuYw==
X-Received: by 2002:a05:651c:543:b0:378:dde4:7987 with SMTP id 38308e7fff4ca-37a05332c83mr15015571fa.28.1761772479017;
        Wed, 29 Oct 2025 14:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHT1rpy4gMrS8nShcIS4YGFz4w4G6pxRpfpNR82D/AUm8kkZFUHf+ArcjvP3FnX+a05XWhgXcWN2srFJMdzGAg=
X-Received: by 2002:a05:651c:543:b0:378:dde4:7987 with SMTP id
 38308e7fff4ca-37a05332c83mr15015071fa.28.1761772478459; Wed, 29 Oct 2025
 14:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com> <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com> <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com> <2ab547d2-584b-48fe-9f43-7c14caa7ab05@lucifer.local>
In-Reply-To: <2ab547d2-584b-48fe-9f43-7c14caa7ab05@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Oct 2025 15:14:11 -0600
X-Gm-Features: AWmQ_bkBHBsKVE1DM6K6PiXjxwYzk9VLBdKL8XAwMrrsQLZy0gtm_M8PLuoLaxI
Message-ID: <CAA1CXcA1nqt_f+zSOF66eTNWJACCE84hSQn4uNF8CjcBUZ_1oA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LI_VeKHsRpNUKAqzMyFcUcZhVTdXxo1a7DytFfi3sPw_1761772479
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AAAFC0009
X-Stat-Signature: zj7nt9fzqh6kct8h3tsrq1p9s39kyzsu
X-Rspam-User: 
X-HE-Tag: 1761772483-757340
X-HE-Meta: U2FsdGVkX1+mtulcQSnMQGCcVuhmpoC1F3YKhHQR6AmBDIIbR8DDCuOyUdL2vl96+IgX7J9Vu8ZInKK6oDlQg3jODOegzAiXHPMejKeFBwPvMJwRXk+5P87fkypKHQIGiJyLMpCR55JFuYU/AGtVlQkqVMdKGwjcbckCFU3tYGTqwDB8Gfu6n7xMC2M9XbTeuyrm9QKDRYJHHVAXXyqQMnGNZnwm77HmUyDLJnahP8VY5o6kcz2GNnR5qjyTQIV34wSsGrB8GeIbqXg8b4EXRqFM43w5rfueaOmv9f1jSsTfojfhb7AZV/lzuCdEs/P+3E/Y186ZdZhJD3tnXVODRQmdQfr7/3ASswbpJqOM3j2lOxMF/FgfpWyKkimqTi8ZEHJg3Obd3/yv7FGc5FwFszkv1gsifLghRo2H01bbtQ2Q8gAewm2iX9QXQ3OrINs/CEIM2wWVIbPDxPx88PX/s7+MisQBvOLa+gPtZWgPknN8GUHQ8nIMy2EaFMZMoQZCJu8MkPrTC8Ibt52Ym7uOtuSmZ9Qr7FcOkuHodUhD5lY0iEKHAFiPIa6WKLhnK33uAW7UTreZhA4muBWhrHEOC+rOJsnB5FWG/WeXmtHBvTP+TAKtndPn4dJBq5gdB6delymGZgNlsVfVAzEtJ28NTUVvuvu/odAjew6qtJgaQtOR2gdaXf5ulpvpMN6pYEnlgvwfSP4w+rct31qI1H2//DmIrppctr5tAKLs6SVxctBKvGvHJLD9u3YfPt317LbvCTaRhMOPUgfOhpacFh39NwzpCRJk5Ivz56hC8iCkw+7+ZmSw50L45Iham6RIb3+yXTrIs58t+Mi1CCF78PuLTChGipfCbHgzOrYVjutNMCNBFSI5JGtQRkWpddyp6p6hFLMfkotEdv15wupLnzLSy5PYP4bFH0fn1u17lVS3D1b71nktg9jI3PKxDH0YXdXC7rqysmWxG/DwMqC3DAh
 YdDlhTKj
 aL1K2yJnlk8tScflfZETWY1RoHCOIEys1PxoBdQZ4asvYBv6XunXJx/gMR7WBth8gPu0zAzsRKSqpdtN5W/YXMEmkSqV75slgcKMGYuBSR3MhWb3wYXXJEfa4vs8477UQEFu5MWaNZ+S62gafSmm/MEgO6Bfv5yCt8iVZFPajK2uW1AyuoUX1QPpJ/dXEUmpci9jYYgnO3RROpbNZuesGptVH7tvvVsCK2l4PtHwNAIaCKBqbQWLVniE/vAdnE/iQoUfOlcx4obsbX0LZ0UD4Eu76dGYLQ9FvN0Es4Ou6opQXCPIsxoEZ01SyjjJqqEl2uE3gC6m6bLqzlymcX5M0Cet6NrPDiJYQN191Z4WyP8JIb9hnFEEDCZ/dx77eNOHOFz9rYOspBFhdzLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 12:56=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 29, 2025 at 10:09:43AM +0800, Baolin Wang wrote:
> > I finally finished reading through the discussions across multiple
> > threads:), and it looks like we've reached a preliminary consensus (mak=
e
> > 0/511 work). Great and thanks!
>
> Yes we're getting there :) it's a sincere effort to try to find a way to =
move
> forwards.
>
> >
> > IIUC, the strategy is, configuring it to 511 means always enabling mTHP
> > collapse, configuring it to 0 means collapsing mTHP only if all PTEs ar=
e
> > non-none/zero, and for other values, we issue a warning and prohibit mT=
HP
> > collapse (avoid Lorenzo's concern about silently changing max_ptes_none=
).
> > Then the implementation for collapse_max_ptes_none() should be as follo=
ws:
> >
> > static int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > {
> >         /* ignore max_ptes_none limits */
> >         if (full_scan)
> >                 return HPAGE_PMD_NR - 1;
> >
> >         if (order =3D=3D HPAGE_PMD_ORDER)
> >                 return khugepaged_max_ptes_none;
> >
> >         /*
> >          * To prevent creeping towards larger order collapses for mTHP
> > collapse,
> >          * we restrict khugepaged_max_ptes_none to only 511 or 0,
> > simplifying the
> >          * logic. This means:
> >          * max_ptes_none =3D=3D 511 -> collapse mTHP always
> >          * max_ptes_none =3D=3D 0 -> collapse mTHP only if we all PTEs =
are
> > non-none/zero
> >          */
> >         if (!khugepaged_max_ptes_none || khugepaged_max_ptes_none =3D=
=3D
> > HPAGE_PMD_NR - 1)
> >                 return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
> > order);
> >
> >         pr_warn_once("mTHP collapse only supports khugepaged_max_ptes_n=
one
> > configured as 0 or %d\n", HPAGE_PMD_NR - 1);
> >         return -EINVAL;
> > }
> >
> > So what do you think?
>
> Yeah I think something like this.
>
> Though I'd implement it more explicitly like:
>
>         /* Zero/non-present collapse disabled. */
>         if (!khugepaged_max_ptes_none)
>            return 0;
>
>         /* Collapse the maximum number of zero/non-present PTEs. */
>         if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>                 return (1 << order) - 1;
>
> Then we can do away with this confusing (HPAGE_PMD_ORDER - order) stuff.

This looks cleaner/more explicit given the limits we are enforcing!

I'll go for something like that.

>
> A quick check in google sheets suggests my maths is ok here but do correc=
t me if
> I'm wrong :)

LGTM!

Thanks for all the reviews! I'm glad we were able to find a solution :)

-- Nico

>
> Cheers, Lorenzo
>


