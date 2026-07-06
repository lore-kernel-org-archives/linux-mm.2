Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CADC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B306B00BE; Mon,  6 Jul 2026 13:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4136B00C1; Mon,  6 Jul 2026 13:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93BB6B00C2; Mon,  6 Jul 2026 13:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B326B00BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:11:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 132A0140165
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:11:49 +0000 (UTC)
X-FDA: 84958993938.08.7C36AC0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id AAAC78000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:11:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QmC+9ZLb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783357907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnBU98aNlrYevbhd8MxC15hwUsvqjdD5Bdlyv7I0IMA=;
	b=mz8tQ1u6G39tIVgrGBHUJW4hWG/+NbdShS2o22OujElBoTPstZu/Y44vEbJ+WSMbaxhDYb
	eXV74t7RwihtHXBsRlWN8onfQUa7iSaB6SjgYjdr8IbsGbLcA+RPOlvhThdZQrs43WTMWA
	OEmYiAMqdP8Elmy+agglHHKIxMJt4FQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QmC+9ZLb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783357907;
	b=nJ1y5uUGw1VTBJub4TdEvW6+udcnI13z9312nBBbv7iXt/LlDHrxMTuF4Vh6uWHWgfBgzR
	PdYzdAjd2JdFnx09cFplE8mZTds6VV82076/vzjGBevthr0nGUS+cfBppfcd8HVXb07o0I
	WAKLu1wlJTCThkHynP6VdXnYLjZMy9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783357906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fnBU98aNlrYevbhd8MxC15hwUsvqjdD5Bdlyv7I0IMA=;
	b=QmC+9ZLbDdcGbZPr4RNmQRW2xMho1WDGKtCAtNfRrqhWRZTMIwnkZ8EO2wx2m5oYp638en
	6ixdbYZxqq9qNpQBzTriLaaMFgVVuqItAm1cUQ/FtRYT5ACgj3Khnj/zxOFHzPixrCY/vB
	CwrJw+h62h9mwd/VhgE8NlTBt0aaP0M=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-PFR4YW7ePKiXvgNxV4Hbpg-1; Mon, 06 Jul 2026 13:11:44 -0400
X-MC-Unique: PFR4YW7ePKiXvgNxV4Hbpg-1
X-Mimecast-MFC-AGG-ID: PFR4YW7ePKiXvgNxV4Hbpg_1783357903
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-39c65a48e45so113101fa.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783357903; x=1783962703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnBU98aNlrYevbhd8MxC15hwUsvqjdD5Bdlyv7I0IMA=;
        b=nlJsYQZ562l3t5yFCxyN4bXODSmMqv1ZYJdWUNXnOhchoi9bI//eDck1I5C9Av4K8f
         wlplO1Fn57+mSIpMrvHYFyHNrW3agRJHf1GDrprS3Tt5QSzCy/EuATqs5O6L/MJuq8Tz
         pxsnE7zImPcR8SfewAiv9f8shVemyH0+BDqLEkDDSrlQw/++17EPP0vJzs3+/r6T58qx
         HAmP4HFebGBck3rjtI+ehTVDD52o/da+5eGd5z4p/aNC/gA9LMyoaUyuZz2IDfoOjbJK
         lteUGX+LLhfv3vIEC7Vueo588EeXayREv3toeDhvom9JD3G6ff/hiv1QVcxOsgLooaHF
         RZpw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4mhu9tA5uTYmNSoDKVp5b43SsMzO0k9yFP+9wtAwCwx0JkjdFKVcdTYklI0OW2SItkbDhWRHarw==@kvack.org
X-Gm-Message-State: AOJu0YxBPdQOmma3Ama9Szg2ULeHDP4dtOZxA8GkeEAiqn82SgtLlfLi
	PNTHKE2U25BUrs/7HAcI08zdlRHfdpF2WODZVFDp1PSN21sp0U4z37IrHJVkpDuKkBXIm/ptv7P
	gR2vGtQ0+9TChohHR5jptmy2+EUiuNBgF+F8hUR6k690bgaCyrz26CyNXextuVHW2oTmBYWXDpl
	UUZRuqV8+2D1E2HQEAC/t7i/fS8+c=
X-Gm-Gg: AfdE7cmWDTJq99uOS9739W8UCF0oImeYIOD5PGn49AlEqTA2g14+jxks9dfTq33VRau
	Hognayi7i7+7iEhVSpuBH5+TpH5kPQDjGXDO7y6utPkBseyME9BDopYQ2RItQtlWtZBuPhYkSDR
	FIw0/vGo8kKlPACCfx1saLczVuQoXMVkkwrd7ltukQ0G5YbsTCgQh51YAHp50dqzBN
X-Received: by 2002:a2e:a410:0:b0:39a:ec61:6b71 with SMTP id 38308e7fff4ca-39c5ffb248dmr3106121fa.24.1783357903106;
        Mon, 06 Jul 2026 10:11:43 -0700 (PDT)
X-Received: by 2002:a2e:a410:0:b0:39a:ec61:6b71 with SMTP id
 38308e7fff4ca-39c5ffb248dmr3106021fa.24.1783357902639; Mon, 06 Jul 2026
 10:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260706154500.39178-2-npache@redhat.com> <20260706170755.3387204-1-usama.arif@linux.dev>
In-Reply-To: <20260706170755.3387204-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 6 Jul 2026 11:12:55 -0600
X-Gm-Features: AVVi8CfrAoNr9vhVuFiPXHyhULcKpIIq9uX8GaPBDKJvs6cE0dILZtuftlDNu0M
Message-ID: <CAA1CXcB+VJvEmRZ-TXKzH5zi=UssCO1ytOy4O9o0icop921VTA@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a_51-FfSFJ5pp24ePoSWqTlTsi_pGFZLjqvGp9lRgZQ_1783357903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAAC78000B
X-Stat-Signature: 98ub7za475y6wikzs3u8zu5aqpaztf1d
X-Rspam-User: 
X-HE-Tag: 1783357906-54532
X-HE-Meta: U2FsdGVkX1/ez5qYvIoRstQXDDhTZQ6mvdZWeYS4hX3uKzYTyJ6ARl3h1l2n55HfCKAm1EhnZogO4TOYrEN5t5a4BoEXn4G++Kt1+mUIO0+m9ntNUL4s7eXgIjLHygABitG3gpgDEAkBBAVuqBLxfwvSF6zPThj/XJ4OXL0qDuvKlhzI2ngt8Yda++BBEzTI+zy1ebjq8JSIZOhQlMCVgfI0tCUTamLC39om+oxPE5AwzIGSWvps/mhJ84mNKk3QA9FphWGbfZk0+XgT+B5pYy5BuUFW66/faukalzkpCz234FewM6VWSgABVsDI/OjbZWEpHxayiGrlOe5k7G/OCsPYcKX1ZefxxDfgD51ZSJtNDGD49fjJcMrCBiejPVrHMbOyTxxaz92Pd2C7MPDJxlVb93ESwNQPbzzc3R2Ic7LwHOuK89kCAh4hPDyMuOKrjkhpRERKwtye0xqyTtcs/orgcrzbjKyagVfCCpwUATfJGJ3eOf0pCnQXhiGfCYRaqLC+YEa0K6TVN1pT+AqgF47NKWmKALT1VPooNFvehqjcnhRrOUlg9/lUoNJzvtHUYdzp7bVnzAfgLUq/tljHHbfu0CD9ZiJjCSAcSFz7MCz/twvVJ3vUX7cUqV2PhgEX/u+d8EScsHA0mPg/QG8DuueAQ18eOWkY7XJ6t/n/rbQJt/K5VQAH4j+YN5yeDM91Fs+52e1Q11i+gy6NJjEx6K0QhH7DY4l3KW5F4rQqwBQGWPtDA7aH6fhDCgZI+laNnUf3ef2o6K6Bdr7/QN2Pr9g1KeVNPtzkHpiiztPKeCocDL7YEEIsr8eRoy8l28Dzc64wVlbhusASjVuJeXfRffy60pouuYPSenSTAkZU/l0Xy+1SHSujh6Nu9J8pAfSbrtC7Agk2TJXPWcDpE8DgaxYBC5FnfdkYNvsc9m1Rwo+Lt8Y3rJsdzf8POsRts12qv5HjowAFrHoB18LEt4Q
 v+ZsA7xQ
 wc5Q/KVsQG+/LLEcbryqVfZ6yY92EGx8hYsfsP8EO4TQ+S0PQw7dOHyHCQtsV25Y38mp8kiOCzClL85ryUjYYq9fRUNlVL2DSHqoYZ+bYrQIay+8JszDOcbG5o79et77PykGOsWvUfZOgEn0FK92U2g8Y281MExaFuGEuj38KENws3DMCvbEBGeB/tPM6OC1P1LyeuTzTkQSf04sjDGQuapeaNwRNVZxTb9c8oqV3hAoqE656uAWKbLY56ot4mbadsJbZh7cDDxVLZNqqXs8EipFH9ggO3beUxXx1kyfl2NsDDKKGwCTk/1gwm08HnNE0VkjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:08=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Mon,  6 Jul 2026 09:44:48 -0600 Nico Pache <npache@redhat.com> wrote:
>
> > Extract the repeated clearing of node_load, alloc_nmask, and
> > mthp_present_ptes into a helper to reduce duplication in
> > collapse_scan_pmd() and collapse_scan_file(). Althought file scans do n=
ot
> > current use the bitmap, they will in the future, and clearing it now is
> > harmless.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..b3985b854e77 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -628,6 +628,17 @@ void __khugepaged_exit(struct mm_struct *mm)
> >       }
> >  }
> >
> > +/*
> > + * collapse_control_init_scan() - initialize/reset collapse_control va=
riables
> > + * that require being cleared once per-scan.
> > + */
>
> Probably don't need the above comment, but apart from that

It was a last minute addition because I feared a review asking to add
a comment ;P I'm cool with either. The nice part of the comment is
that it clarifies these variables are per-scan.

>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thank you :)

>
> > +static void collapse_control_init_scan(struct collapse_control *cc)
> > +{
> > +     memset(cc->node_load, 0, sizeof(cc->node_load));
> > +     nodes_clear(cc->alloc_nmask);
> > +     bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> > +}
> > +
> >  static void release_pte_folio(struct folio *folio)
> >  {
> >       node_stat_mod_folio(folio,
> > @@ -1616,9 +1627,7 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >               goto out;
> >       }
> >
> > -     bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> > -     memset(cc->node_load, 0, sizeof(cc->node_load));
> > -     nodes_clear(cc->alloc_nmask);
> > +     collapse_control_init_scan(cc);
> >
> >       enabled_orders =3D collapse_possible_orders(vma, vma->vm_flags, t=
va_flags);
> >
> > @@ -2686,8 +2695,7 @@ static enum scan_result collapse_scan_file(struct=
 mm_struct *mm,
> >
> >       present =3D 0;
> >       swap =3D 0;
> > -     memset(cc->node_load, 0, sizeof(cc->node_load));
> > -     nodes_clear(cc->alloc_nmask);
> > +     collapse_control_init_scan(cc);
> >       rcu_read_lock();
> >       xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> >               if (xas_retry(&xas, folio))
> > --
> > 2.54.0
> >
> >
>


