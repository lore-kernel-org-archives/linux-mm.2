Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AB0C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 01:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629756B009C; Tue, 22 Jul 2025 21:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9E56B009E; Tue, 22 Jul 2025 21:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8FA6B009F; Tue, 22 Jul 2025 21:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4216B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:56:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5B16132F8E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:56:35 +0000 (UTC)
X-FDA: 83693865150.23.AB3A726
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA19840007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:56:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ainb3BsD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753235793; a=rsa-sha256;
	cv=none;
	b=N3BOa6TengOF65qmVCHLdoXsf0d87YQMOo2Zg71yQYMVIJjARgW1DrW8/6d/IZ3RQBKPP4
	FvEtawMHdmNSDYLHlNZyXioxzIVlgeFZYNgD6S4PAAHMuc7DXv5v1oudxtvRBVwUd9J6Bv
	RMz9ZlsG3j8gHO87G05meZht/c5Yktw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ainb3BsD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753235793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWvY+EVRl1d4IEPEsV3Ro9T/i9D4GNDRhkSCFN4ly7M=;
	b=vkbbdKdFp07JEltNkMBDAgMel+UP6MmHFWQmoSO091rKqU65YhsQyzaG4/1YwaLYr1mUcn
	5/7opIytDQkIENESjLxdGVe3MagZUFZtBzBNP1df+kVmVFUNtrOB5rspNc6J8wxQAXoMFB
	9YOmjmVfh2mTuEOzju4DEEmuQ/a3QHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753235793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWvY+EVRl1d4IEPEsV3Ro9T/i9D4GNDRhkSCFN4ly7M=;
	b=Ainb3BsDVGlGY4brn9nH0ABjnmyGK8q0yHL7SgXt2bcOzMvFGnfocJHrPAc9Q+QD6YKmTW
	xVyHrUTit9qEgCge54zrMIYqoF+ks6ctzPHCjOeK2GaRPBDHw7l+IDaDUVn97aUelmMfXs
	S7WHhtf7t29dOYg0B9/lplvtrptf8Vw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-fqxgIxCPPFyuJ8jFMVm2HA-1; Tue, 22 Jul 2025 21:56:32 -0400
X-MC-Unique: fqxgIxCPPFyuJ8jFMVm2HA-1
X-Mimecast-MFC-AGG-ID: fqxgIxCPPFyuJ8jFMVm2HA_1753235791
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-70e5e6ab756so79554787b3.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753235791; x=1753840591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWvY+EVRl1d4IEPEsV3Ro9T/i9D4GNDRhkSCFN4ly7M=;
        b=HBrRuCRed9nopYPIemBfQHeyNjULuwTPfRpBEJV5LdFDoxbSSopHJrVSzy3bUPjMR7
         cB9WUYSCVlq21/0GDPgSjQ+tct8lIeNXbhS+12OEdV4oy+Kb39m9555J/Ki/vlCBO15x
         yMs99KHgVOP9wzHL22eiIWW5js4YbVzg82HUoxEgF5aH9zLdbNuf2+nKigaus9Nezryo
         TamvBdEBtWUsLoBnJ7+zIYNECFtJzKApluwnIew0zKqnzv5DyGw/6yobQSFr5+/2m31I
         Ijke4EdohYx68njfjkcFN59ml1CFDUslSs+gwCssvDNHPe6AEL7FxN/xQ2s2uoWuPpAW
         Ooqw==
X-Gm-Message-State: AOJu0YxFERmppL0nGtmHeqgM5zJR6E1F+KNYkcdc1Nn+9V5D5UZ5PJCr
	J891lddk0tWYNcUasmnRZ9DfwITa5Oz6y47BbzlIopUjpju54wqj9NpnnHqJiEbGWDs/GuUOHkB
	qG7RR6YlY6ITQ/oVOP1uwdcgq0m50x8EWTwF5E6GYAYw3IKJTIqU7H6Fe0kGAzmIIl+IBLvp9sJ
	OLG8oB3Vqe1hdOANIPr2QJkpEjsC0=
X-Gm-Gg: ASbGncu+YtjqJIk2p7rxCbWC5RTkWb/jGJGeXdCt5GgMpHwwDseOJFM30bVo92OWDaE
	nzFsN5MtIJdLuLcSGVKey6ga1VSXXmIajp+k3KlmWLiP6PYH54B8Rsi6wQiqQecCrcauy9HH8fH
	fJKRAnpVYm/n1Uqcp/aobXSFw=
X-Received: by 2002:a05:690c:4c07:b0:719:a4af:9639 with SMTP id 00721157ae682-719b41e5d6bmr16296877b3.1.1753235791321;
        Tue, 22 Jul 2025 18:56:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEX+meq5RdllZJEUDDChs2t+MqwYsVzxeUCToWQLKJOqrxv1moejmBeLFBifralajhOqWd7T8wS8R3/FMQe+x8=
X-Received: by 2002:a05:690c:4c07:b0:719:a4af:9639 with SMTP id
 00721157ae682-719b41e5d6bmr16296707b3.1.1753235790942; Tue, 22 Jul 2025
 18:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250714003207.113275-1-npache@redhat.com> <20250714003207.113275-3-npache@redhat.com>
 <d8474462-a90d-4b35-bfd2-dc1a641cc837@redhat.com>
In-Reply-To: <d8474462-a90d-4b35-bfd2-dc1a641cc837@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 22 Jul 2025 19:56:02 -0600
X-Gm-Features: Ac12FXzNvvEMEJLag32zFFcnAA1AC1qSrsNvmQqD4k4iA-iTmL3V73nObHmbLoY
Message-ID: <CAA1CXcANV_Y=ka74CYFP0pqPWVYH9S33VzjyDUQ6Nmq1na+QFA@mail.gmail.com>
Subject: Re: [PATCH v9 02/14] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8VXwzX7IxQm1rlpIlM8EgD5bKy2bHB0uarA9ng5EGo8_1753235791
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA19840007
X-Stat-Signature: 3coxyjn4c7fehmjqxhj4hc1o3o3icwgj
X-Rspam-User: 
X-HE-Tag: 1753235793-734967
X-HE-Meta: U2FsdGVkX1+0kgdRqlXI0OpHFVJt2iUgBqvFblgtbmi9MXT+rvuTaXL2pqh5VNXOK0/W3IaPpTQxEvqWQLVABtlopubrzWDO7ygjkyMa1TL5VS4LQRu7yb1FEB0ch9Bgjl6zPhfScPu1S0+za1EQTV3rok8GIfhZ5oa5WjMkd79S0tjUr9H/Wg7QAeLB84BmfGU4x/11eWgJP9hphCs5EPz/ogiYZ5EAdHakYk2otnFwH/bujFI4ETcndtQOtjTAdqVuBDIArydajk4ObolA9v4yWpNFUaBoK06R0Y4kJ5AHP8ykpeCzFrv0oAUJaZ0cipYDWGAv/2nyfL7HiQpM07moofZK1yTSuCqC9AjNqcu0D1j66PrnwKDkL65pq2sLpkeYUEIP9LIW1mdQF4XxCbuikTfZ386mwnoykHTCILx2fcF+TMA7X1fPT8qw+qU1nlKVm80KoTt0iYWS2jA/iTAgo77o7RsMZxo8plKqY6t6L4KyI1GR5Z2v3UKi+nRzKB92qeWpw4z/G0u8/IWkNCALIv+bxN98z3OAlmPVYPj/GRkanfhfV6XjPfZnGqYhCG0V/jmVPxDUTjuLEnwZfjp3bVN++IZhJaPA6MK2xKXymQeluK6kdDHk3yzrLj/KqkdZGBayEagUoBCVcbEj3uBo/6zVUY0795wd37S3mG+W1XUmKPTJ6rPHho0S4WRENrWl2b4Vwx6hYDQBeMW9alXiX02Q9fpylAroOyLxIbUOAMG97lj7GKaE/L2OxLnvoxf+D3wk8LI6abQIhjkbGMn/N0ibaPScgBkaJsWkuMS0+dq5eIor2e8EunLArDY7+/ZQL5J4b5XaHP53oFO0JOPeOtuRPd+/hsxfSubAuWbUNtQB8MAFuiYX05A3v9jDZOWtxZLFzECa1RTobfrKv3W0Lsmu9V8OTKgfRd1VIpTK/hCXkFNjS1qSOOxKRd7h7g6T06PYe6drtkjQHAc
 UigzFrUU
 0dVM/A5q8rLSS3RuQDKik8/f3F1rrReXNEppqVNg7XSl9n+4MZQ/79VOJpgZpWSBCSL96qu6pN86uk6jj181MNcCeoDhx261TfXPRfDUGSHL8guz4vlE1NUa7yoQZ8SMlcyR+1fANZjtD9ADGnObD+zJ+gkavlvd3xEJgbOyfzdgI6wnZE0fx+3GCedx0GX1c6UgyqDse5zjBDRcE0pdGN4ZbrNEtTR3O3XBuzk4ghPgRHzXvXNjUGcobtlnRIFekNNtbI20hunWtYYlnP+uwFLf/MeOE1bXWqn24KuY7VVtMs/0vTvE6HlD23M7DQVdFphbh3wtb/gOknq5IrPFH8jnW8oFZp6+w1Bmy4aO6hUBveppIGz2ry9BmdKMBaW0G9QI8/c9IPL/nwWR70qmPZhYgLkkjxF6sfwAsk+m32hf2x/vOo8/vO/QHo7cfzOdh5Ix1yc/KkT0fre0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 15, 2025 at 9:54=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 14.07.25 02:31, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing.
> >
> > Create collapse_single_pmd to increase code reuse and create an entry
> > point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. This introduces a minor behavioral change
> > that is most likely an undiscovered bug. The current implementation of
> > khugepaged tests collapse_test_exit_or_disable before calling
> > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collaps=
e
> > case. By unifying these two callers madvise_collapse now also performs
> > this check.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >   mm/khugepaged.c | 95 +++++++++++++++++++++++++-----------------------=
-
> >   1 file changed, 49 insertions(+), 46 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index eb0babb51868..47a80638af97 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2362,6 +2362,50 @@ static int collapse_scan_file(struct mm_struct *=
mm, unsigned long addr,
> >       return result;
> >   }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static int collapse_single_pmd(unsigned long addr,
> > +                                struct vm_area_struct *vma, bool *mmap=
_locked,
> > +                                struct collapse_control *cc)
>
> Nit: we tend to use two-tabs indent here.
Thanks I cleaned up these indentations!
>
> Nice cleanup!
>
> Acked-by: David Hildenbrand <david@redhat.com>
Much appreciated :)
>
> --
> Cheers,
>
> David / dhildenb
>


