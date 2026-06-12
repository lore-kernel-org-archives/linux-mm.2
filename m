Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFCACD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB736B009D; Fri, 12 Jun 2026 01:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9558A6B00A1; Fri, 12 Jun 2026 01:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D576B00A2; Fri, 12 Jun 2026 01:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1906B009D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:52:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F17981A060C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:52:36 +0000 (UTC)
X-FDA: 84870191112.05.5B46165
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id D91868000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:52:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j3hebN37;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781243555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GS6ChxPYregKQzQhinCjFXuklagH+TzXqSce0NU3YLc=;
	b=hl7tHoO45f76hBKG9I146AxPALEU7o5jigmW0WmUtMlozBGZ5PQjkPB8r4aUbfc8zNV1P1
	OhQN+0pJhg7Ivgp9T/5A0e7vEy9ZdZ6L90yvp22JHtcKSbtllgLlLrNrWGJNarWCFuzWmS
	pKjyQrAcx82IhL0hfZjHdU2NssVlSYs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j3hebN37;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781243555;
	b=b1Rq9alOPq0mbXeO+UQl5pK14vklfXyheFtIhGvwN4rKMB0CPehDwzILNxHvuw9Flw/R2k
	WICvgAy71tjIthnN0P2OrNd4QvDt/Uqtx6QF0B6dh12BGlwJywvNLwbswCe4znY3X1QeVL
	46pX2Ji8WpnBWiTxv8op12OdDO3A4l4=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aa6b0f369fso39587e87.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:52:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781243553; cv=none;
        d=google.com; s=arc-20240605;
        b=FMo4hN9HOntQ3HvgaE9aEMoUUWwft+MRSudh91BFjdkWzhd/C7ZMJGIRNR+DiiEiol
         17w6c5F9y+pC0/YJTk480KUQYZnyCsxIhD64cDifeI3g/45YgAYRzvq2oZVh7ZwYaRVz
         orRK+Kceo2uEXe3Ht9iMfYF0z1fK/8HOrypW9cX9Kwn7pPl9IylTVlxtj/LhZ5XAkFCl
         yryCPtkC9goYJ59P3qHjZjdFkwUgspB3t2j8pg/fKWGbT092Rz4IriyQbpgAAYVTBxID
         eCJ8oXdl8fvPGoPvXuY3v4lZ4yjC4rlp3WItJ8ii04uoe5Q2FCbBnIFhN9xFWqmR9HZo
         7Odg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GS6ChxPYregKQzQhinCjFXuklagH+TzXqSce0NU3YLc=;
        fh=xheJFUubd0iFVgerEFLts2nB6Gz1XMmLTRyb2v5w/F0=;
        b=NSrSRaBnLrGBn/HPVVCqcaEllZV9oeiNRBLpOTR66QsGzS28IYTOfu9NZiW3N7t7OR
         UafJHhShcuhynhOZjbAjlPdfSeco3uHo6UUphRMILt7mW4wBHNMxr2fR5kkocl978d0i
         iN7F8DtXJoS7HOd7HfMyLauGXDbnr0d729G7PUgPB4C7wN94pc9pAduMrZ1zDAvVk7bo
         bqEZuVPIsLQCG5Tn7LQohEHu/RdR2YWk2bzvZmsf3hViHJkPReV3b5gKqOMQn39RqW3k
         RCL9EiPcJAjuNbj9t7TfzekpncdiHupu0M77+J8lGnTdrtbISvJgelkq86/VxQPlD5tO
         PyhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781243553; x=1781848353; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GS6ChxPYregKQzQhinCjFXuklagH+TzXqSce0NU3YLc=;
        b=j3hebN37yRQnC7RNjvWUFzqMmWpKTheCIF38wDRfSvJMXQF2WV+UVWXFjbEekB3UyI
         VMaUuHel2vWLczlFvv2tH4Yp8NocLEUSvYRTfma3t4RPJ52Z3P033NWe8ReVlVvgP8Cb
         lnRbqJFLCPVOrB4pHbgim73GVClWweej76+wt7IglgUE9wwEl8eQnsjoFnXz0auzhbYK
         sxePEQWFjtPWrS23iBuqkUzQv5yRet/N5lY14WiIyUGxjbo8d0hmweF0eln//ZWzWWFV
         8ypGC04Lu4wNaQTZR0RYtNcJYExlS7PP4hbSJhHtYH1YR1/vcT784tG64CXJzLDKJRR5
         tFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781243553; x=1781848353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GS6ChxPYregKQzQhinCjFXuklagH+TzXqSce0NU3YLc=;
        b=pdHOpytJGrbuT8H4lVV605ZLgiliCesVFcwBZIpwKwohLpsByHPFZBMnO+sBmrGQIg
         4S89BwZEYSdAz61Uqekzp/Y8eI8MJpSOhvSkbS1RQG7a8u0OBYwZXx/ZbhOb8MtH3hQ3
         XPhLKTlVwjl//VmUqBwnQ1/MS/TT0DTvp4kJ9kdQUJM9dWAuCPAwvWGe/y77qXw4a7kq
         GflZy3UdVicy2t6DGLSXGP6tOQootQ7sJOlDz71M9hfCJp5nW3NpyWrVGJu/Fu1v5bwE
         NMGkYmIHWyF9saCAOEJHdusrDBVaZzG+FCoQDjymRZmZ5RuVEB38CBFVjpPQ05HwSj0W
         VD8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/fe5UfIh7mTou9sfR2Uc3JB70Z+Svb22sFDf/O1rtkh9Pw00jKquZkzypHioityYW1BCgNBC96Jw==@kvack.org
X-Gm-Message-State: AOJu0Yy4RfMwSWqGbTNtZb8IlNdvdPF9HgeVpAdUoeAdCuQmuRRUZtdt
	KWNvSZA9CIrxDzqFwDZP/jEtGD8XNnSvBWZ3VV1LXEMOuqg1h6s7TKgJBoeU+JTXAGQxq8sU83r
	gEUcctvkWvAAKNLFQtWbCPO9FgldTEug=
X-Gm-Gg: Acq92OG1u3OTRkufv8Jwoe+WdC97QsMU8LbZZXfOXr/5SrTHOhlBJ3q3vqPBGwY0aRH
	wgDeOJpNDOiRDOuzD4yeSRh0OOnqzfNkwLKhTJsP6Aw7tT92nGEChBx6NL2t8BxjO3hxwDygKCD
	yaAKR9EDEzGYZaHrHgEEVds7wHZo3LQ9emWACAMKSjsMwXb4/18x3vdTsV90t1TW+GetSdruVEV
	w7EAPYgsWQYOC7Bvd/49s0GokEwN+gJGkWSdu7ht/BjnzK+pQLhcSZigNIzE/PKO+DXueHAeVqh
	u9fxnAdVY+cQCOc+gTM=
X-Received: by 2002:a2e:a90d:0:b0:393:c17d:9cfa with SMTP id
 38308e7fff4ca-3992b25e16emr1604331fa.5.1781243552481; Thu, 11 Jun 2026
 22:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com> <aiuWPKy0ncsMIXgW@casper.infradead.org>
In-Reply-To: <aiuWPKy0ncsMIXgW@casper.infradead.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Fri, 12 Jun 2026 13:52:20 +0800
X-Gm-Features: AVVi8Ce59hWhhoF9H3fqpDrhhQ741QKKQXo9OJES32cLoj-4quAiReodERMUTY0
Message-ID: <CAGWkznFeSxurq27eYzRPN72j90EZx-Qwg1xWnfhApquDCtBQYA@mail.gmail.com>
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to LRU
To: Matthew Wilcox <willy@infradead.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bcasqgntwt38sdt4bt6abrqts7dzw3ps
X-Rspamd-Queue-Id: D91868000A
X-HE-Tag: 1781243554-555500
X-HE-Meta: U2FsdGVkX19U9MJ+Hh6hNjHMDI2I1svAsm2VDg5U2v910CskyEMC0IYtRr8hIFQmpq/7SZPIXUSPtCqyrfV0S9r30kMw9Ag3j3z8nCs48bZ//kqWCWOc54bsCHKJ8r5HLTPcBb6m9PXbIU+9iBY3STtCTd3uUB4z9fpznQM2r0vAcMDUNc1Q2cgXgJIjZ1TQ6mkpATe8l9/wKzChO1LxSB/7smbvPUhDm6Vsg+EscvvcFIdFxPwESTrvy2xbQz8KZJ37bEZXjIM6rjfBd4SSdVLa/QgmokxFLZi1pon1RZrlf0f39qrV1rQmTmnhoDVPmftzbk1khgcU5QyYIMqYvvmGn1Ewa787dPw/EgXKwHQsyDsGqpMeonxFLBPTVZJ89fmYjAx2w1kQ7wHqaN72MbkObMjlK5VgrqZqlonPbV+SlQnOj8RagH6Ax56RdxfECFh7BtF/xE6VYqccH8CXLYP23PsB+PXuJDHga+WWAjaLsiagjaAipSaP/qstbKq4FBgm+RVrs+rLZWmGTvxzrN+z98QnCD3OVnWnPDSw431mqhhSCCe8Y86o1i68zkK5j5PCoFzMjQUv7QJJBfwlFTZyZv/KFQslYOF08GUNdGHWcZ/6/d66+v5EiXx3Q8jPy1Kfd1cgTtj4TonWCKork18k7UgEKP5BMAUKyIZYgMp1ufmrlEDMaRXSMLqs8X81vXX9M8QB+SdKllUSSYYlfNIzvO3ePO6NHTo9yWbCnAX1H5PrhlqsyAnZgG53wUh4So5l6QtxyRcAfyWVnk09HKDdcrE3wtGjUU7zv+y8QPgyz0sV4Znilc621ue3vkxberDhTdgiP96uuO7IeDuOM//9eYSH6r2Q0d4cQpuJadNlX5ulRzaBSwpGkd7Sh2jeY+Wz9evdar1schoFlmIkW+AzXuNOftSjKh7VFWHfrkarK7cIkkEC+DSJBy/eP88H6MdYupCXVjIL2KvWYtq
 J6brVC1h
 OfyxEqSHmuQ5h0FJEWphWG//ctUuy8d727auPUlQbDoYponMMq8yDP3DQYEhjawHKpzAdyCw21O6O/UJ2XzpW5JygAZI1qZaWmFIWIjnt5xlvPYWTG5yqJgEO3D9gsRyE8VZPYHU7YPmWU2/CoKxZ9pX0KVHPvAE+IcDhphdDipB+Tt/cv45QQphLu6vcPnXb3TiWoTZVLhFw5d4dIZqP9XBzC+9poRr4/JSsj6q0BlOFIzQQEWNtpt4um80GayzMUk3MUJFfl+zEolyJQ284uMU9iBF0L28ffT5qmPP43yM3iYPvvqGfIuHpAG5Wusx+/hs8LGopXbiPR+5XDimBto+oM3Iyenj/RuapeJynrEDBTrD8huXqkDpjJcC17c4GJ/uhVVSePRTcG2GJ8L6F8kJcqXjn77SeOckVDeW+RheiRGfl0fhoeIr4f/VV4lQznKPXx74TGCBn4OxWKcwIRmKFXJlb4QlzHv4vf3HWpvBeGFebavCLyIY7qKwwPHfDdEfo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 1:17=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Jun 12, 2026 at 10:34:56AM +0800, zhaoyang.huang wrote:
> > [2]
> > *F: big folio before split
> > *T: tail folio after split
> > CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
> > *F: pagecache refs =3D n
> > *F: extra refs =3D split
> > *F: PG_lru set, mapping !=3D NULL
> >                             split_folio_to_order(F)
> >                               folio_ref_freeze(F, 1)
>
> I'll stop you right there.  folio_ref_freeze() is called with
> folio_cache_ref_count(folio) + 1.  That's defined as:
yes, it is a typo. The right one is folio_ref_freeze(F, n+1). The
folio could be split successfully by __folio_freeze_and_split_unmapped
and have all pages added to LRU then. The race window is the later
free_folio_and_swap_cache->folio_put_textzero vs
folio_isolate_lru->folio_clear_lru which lack synchronization between
and left a folio in LRU but !PG_lru.
>
> static unsigned int folio_cache_ref_count(const struct folio *folio)
> {
>         if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>                 return 0;
>         return folio_nr_pages(folio);
> }
>
> so you'd have to freeze it with 2^order + 1.  The 2^order is the number o=
f
> references the page cache takes on it and the 1 is the reference held by
> the caller of split_folio_to_order().  If anybody else has a reference
> to it at this point, the call to freeze will fail.
>

