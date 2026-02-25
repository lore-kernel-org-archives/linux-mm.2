Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C252DF55425
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050926B0088; Tue, 24 Feb 2026 19:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002036B0089; Tue, 24 Feb 2026 19:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22556B008A; Tue, 24 Feb 2026 19:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDCEC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:36:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 668BF1403A6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:36:02 +0000 (UTC)
X-FDA: 84481111764.30.50AD21B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8DA9C0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:35:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYSLc6Ao;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771979760; a=rsa-sha256;
	cv=none;
	b=K5aZSWOPPMcUKVgLlMexzPPJfdPCKw1a8nTpqP+gjlKDdGkehp8H5nhCIjqn5HdhUNIC3u
	XteXjvkL3gfPXYCbroozs3EvylqjBzSiXD0iBS7nT7WPAzi5SxxM/gHjJ953xlhjdlzXcP
	nzOrTETL/F1RVLQ6NG5CIiG6gNrdHOI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYSLc6Ao;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771979760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkBHHOg5OuieTqnkfSKoAOOsEN4SWNGp1NcoI85IXUA=;
	b=bi8PUVzbrRNq4WbQDxhhk1gJgboWbCkPv8/k451VZIg4ZLW+HGCZsdG1BZrMJwFgvhLnGo
	CYoa9lWWQvE6Q7cJEaGuudG7Ye01mtNiHYVVz3cbrmYCJuSY/JI++snp5raWF6lQimZ9z1
	FnupkuhTr2nlpXdFicDnLv50ALo3y4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771979759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JkBHHOg5OuieTqnkfSKoAOOsEN4SWNGp1NcoI85IXUA=;
	b=XYSLc6AoPfBy3uLXvZj2dVrvxr7wDJst4s8mhtBd0pYq4OVnrgC2UQ03PPGBsaHFBe4kKX
	u3ifNPmDM/KV6Vz57pWlXW8diy2qURlKb+7K15JmnSA6DKXALB16TZKsbFBQV+hlDWzAU3
	702dvv8pWWV5L63OpDBpi/dWXVYQ9RE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-pSTLyU1iNiejoJginwSiVQ-1; Tue, 24 Feb 2026 19:35:57 -0500
X-MC-Unique: pSTLyU1iNiejoJginwSiVQ-1
X-Mimecast-MFC-AGG-ID: pSTLyU1iNiejoJginwSiVQ_1771979757
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7960db651d9so6592197b3.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771979757; x=1772584557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JkBHHOg5OuieTqnkfSKoAOOsEN4SWNGp1NcoI85IXUA=;
        b=Bc5l1dBL5z8Y6/3xKeguumAIV2UuRiBwXcHTyHv+8yJyn3G1cS97ZBli+ZbFc6oOvf
         IpJoWINpb5wkRhM8A6kcLf3V++DMM9NvS7QdQaxl154xnaHmCBzl74DVlUauBvyW5FLu
         o2fMpy4h51e8XUV2JRe4JgUDD2O7Ky1EsxutWW4d9rcsFyQLXhzubXT6oKEe1Vycmaan
         GdQJjmpKC2KIWfWCL1tn/1jBRmKpEvXRzqkrWiqA2sPpTXMPXZi4LzHB43bgtDatPzcm
         sPik8iYtDleUWeAk57YQjBFULNlpxn6OfBG2PWLR7MrVvIDpQU8XT6OcXefYbaYuB94I
         TdCw==
X-Forwarded-Encrypted: i=1; AJvYcCWiz/blQUW7nT8PHnsm3X7ImfmOljiYG1thThJVcZ5LqvDZEpAQIq6+CtozqY1Y2zQa7ReQrHvxLA==@kvack.org
X-Gm-Message-State: AOJu0Yxh9VTdxRnYs7F+Nu7bmNiOs4GFmo6ePvC48VVsrJMEfR97WsF5
	SUhEPqGpRlOOi8JcA+KS+P3tKOBmTwIWu9zX7CDJ9u2cMNmn5oxz+9pGV9yyTSpKOCh7Sf9FrO8
	0EHciqq7Pwry+GRJEMsOKYvHaw887BWIL8B0+i33zqYXfl1dsDsd/VHIYiYGxilpMcRlS6NLY2D
	AfM7BuPPW37zGbb17TJcjMdo9EAGs=
X-Gm-Gg: ATEYQzxfiz+zg25E3+hqaUles10htFamz7b0Y/EB9WWn+x+gyuHPDEOUe/tHiVx6Li+
	7Q4TyDHwkSDiq5yKB+dmnjnLakonY2JaBzK9DpAEg+BSoaxCLDu6VDtBU2T1UPawQo8GJX/WGTa
	17E0hAjhA3aVDLMoLmY5Uit+tV0BJro0OiFCAYa4xlT6wGorne4+0OlzRop6KF2QeIItrbEeRhv
	get
X-Received: by 2002:a05:690c:38b:b0:798:1498:21b4 with SMTP id 00721157ae682-79864feb2c6mr17460287b3.16.1771979757222;
        Tue, 24 Feb 2026 16:35:57 -0800 (PST)
X-Received: by 2002:a05:690c:38b:b0:798:1498:21b4 with SMTP id
 00721157ae682-79864feb2c6mr17459837b3.16.1771979756797; Tue, 24 Feb 2026
 16:35:56 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com> <20260212021835.17755-4-npache@redhat.com>
 <493d7898-c959-42ee-ad09-35ffc631ec21@kernel.org>
In-Reply-To: <493d7898-c959-42ee-ad09-35ffc631ec21@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 24 Feb 2026 17:35:30 -0700
X-Gm-Features: AaiRm53ldIwCeEbELouUmMjJLLBe93kAkuyopj57jXHL3vu5d0ELkP7htF8Hsrk
Message-ID: <CAA1CXcApttZPka9EDdo1fV_ZtktRcXKivQYmLQ=xiwrYFfL4-w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lkxG7T5XijdvanCMYnXvYH7KvPpWPn_sZ12iZXyciLw_1771979757
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 19rbrsqj7ccu5jedggn1gwb8y3kke9js
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8DA9C0004
X-HE-Tag: 1771979759-788038
X-HE-Meta: U2FsdGVkX1+z+/K/2QYbjNspklsFeoiyv8o5CqZYHqxMTeY69WZRhlojCU0rh7ft9kEphzXaYMN4eX8R11fWrZbVyjTtcr2IoMlyS4e3VRbN4hyTxDg4eP2oPB2cM+vKbzIqiLJiVdUGolPTdYf9QpX98WOdDplLHntM0nM3H3WCCz8we/+MjmybZoDnPZvodKkMp8JyX7xNoljf8S3NlV+s3T7mmIXYDMMSU64S4G+i0ytdveRO/us/mlSh+keNwBkfX4dsSLSCDjPbUoXQV6uglSEd8eqM5f+I2hxoyszjrl3pPOyTIKPp/T8c7nKs1jVrKyKMRe3f16hwZPk7Q7JbDRZiUVbh1AqhXjuEyT9hyl9MQoJfMhrw4NZwAk0u7wTvk78rv6KqltWXOpCHsClP34D4mOhnySuxo+Q82129mZ3LQj2Z1fDx31z4Y1F4I2y6QebNZSqORZiriRvCk/6QbjN3sDgDwJDRCFMmA/xya8OhY4pwdkyAUyoezLlxzmz556uPviVQYlR+lCfQumc8jPaqbUSBIcbyaTLJ7n0+7jtKmDtmd7LStQ9Cd2nmBaLFbpiRMYKYEmZ9EGn9CkhHjfBud9KMPOYMV9VnajWu8/2e+GLc8VcejrLbJXqBWwQE2vt7Oe47g0vgzmDwEr1eLM7huPl2ORTsIt+FInhVhFyvqfsdB5ZxLbrESuxFg0XYurz7zmNx2ryIYJGzJO1ya7qevgcFZ+By+CQtACWUBpI5w7FiGRNfs9o08HUR7v+yTogdkGtMghlB99WweIgKJEwo0+EiVvMwueqDd/ICxFCcIOU9mmubm/nRQjX/0z2/ZpsI/wo45AJm+09U4QUEdYjseGXR34ES4QE/DZHxk6/T678TgILkEklBLdNk7dZakVOPFnD0JEthYKRpo13Lt26nlSF17T66442X8fA1Ro8NXbeSMmucwMjkSa9gyzQDQAi42UUNA6caKbH
 b/uEv4ER
 PWIQmW297zbMlMDvKZzjL5GqPFEEOJz6Kld1B937wH/mD/pRUKuHcFYC0zvgAoeX+ppOQZ7M0qmMIJeD/T+7o1s1xwRBsejzHL62zocXJlAKS1B1hfS48uxueCEZ6InIARIEfxI0vr4htXliWKMtQ7jgIWcvz8yk0FsO7OxvIYsBtS/egYx15j7DwkUy+OoNo5GedOUEcloeA6odnzs8qR7EyhlC/u1bVgJYYzHWQjMqeYIQkaEv0fBq74G/RFwohRB7Yhi695oDMeKZCzildJsSYkKbPVcZnML6cGO76LTSwy4OL0sWP20c3dVFQ6lYn41uGynbM2E62wFS8Ycwf02aYZ4Hd64dEJUEy7wHAVvJcOyoHuvJ3wLZmh6EZT0fRIoooOmBSmNitIIE/gOMz1Mr4BvNqibb3o13C0B+xz0Dmt1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 12:51=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/12/26 03:18, Nico Pache wrote:
> > The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> > signify the limit of the max_ptes_* values. Add a define for this to
> > increase code readability and reuse.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >   mm/khugepaged.c | 15 ++++++++-------
> >   1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index c362b3b2e08a..3dcce6018f20 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
> >    *
> >    * Note that these are only respected if collapse was initiated by kh=
ugepaged.
> >    */
> > +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
> >   unsigned int khugepaged_max_ptes_none __read_mostly;
> >   static unsigned int khugepaged_max_ptes_swap __read_mostly;
> >   static unsigned int khugepaged_max_ptes_shared __read_mostly;
> > @@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *=
kobj,
> >       unsigned long max_ptes_none;
> >
> >       err =3D kstrtoul(buf, 10, &max_ptes_none);
> > -     if (err || max_ptes_none > HPAGE_PMD_NR - 1)
> > +     if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
> >               return -EINVAL;
> >
> >       khugepaged_max_ptes_none =3D max_ptes_none;
> > @@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *=
kobj,
> >       unsigned long max_ptes_swap;
> >
> >       err  =3D kstrtoul(buf, 10, &max_ptes_swap);
> > -     if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
> > +     if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
> >               return -EINVAL;
> >
> >       khugepaged_max_ptes_swap =3D max_ptes_swap;
> > @@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject=
 *kobj,
> >       unsigned long max_ptes_shared;
> >
> >       err  =3D kstrtoul(buf, 10, &max_ptes_shared);
> > -     if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
> > +     if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
> >               return -EINVAL;
> >
> >       khugepaged_max_ptes_shared =3D max_ptes_shared;
> > @@ -384,7 +385,7 @@ int __init khugepaged_init(void)
> >               return -ENOMEM;
> >
> >       khugepaged_pages_to_scan =3D HPAGE_PMD_NR * 8;
> > -     khugepaged_max_ptes_none =3D HPAGE_PMD_NR - 1;
> > +     khugepaged_max_ptes_none =3D COLLAPSE_MAX_PTES_LIMIT;
> >       khugepaged_max_ptes_swap =3D HPAGE_PMD_NR / 8;
> >       khugepaged_max_ptes_shared =3D HPAGE_PMD_NR / 2;
>
>
> Changing these is ok. I don't like the name either.

Yeah I prefer COLLAPSE_MAX_PTES as others suggested, its shorter and
more general.

>
> It should be clear that they all belong to the "khugepaged_max_ptes" *
> values. (see below)
>
> >
> > @@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
> >       bool is_shmem =3D shmem_file(file);
> >
> >       VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > -     VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > +     VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));
> >
> >       result =3D alloc_charge_folio(&new_folio, mm, cc);
> >       if (result !=3D SCAN_SUCCEED)
> > @@ -2209,7 +2210,7 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
> >        * unwritten page.
> >        */
> >       folio_mark_uptodate(new_folio);
> > -     folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
> > +     folio_ref_add(new_folio, COLLAPSE_MAX_PTES_LIMIT);
> >
> >       if (is_shmem)
> >               folio_mark_dirty(new_folio);
> > @@ -2303,7 +2304,7 @@ static enum scan_result hpage_collapse_scan_file(=
struct mm_struct *mm, unsigned
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> >       rcu_read_lock();
> > -     xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> > +     xas_for_each(&xas, folio, start + COLLAPSE_MAX_PTES_LIMIT) {
> >               if (xas_retry(&xas, folio))
> >                       continue;
> >
>
> Changing these is not. They are semantically something different.

With the new name these are ok right? given we dropped the LIMIT
aspect. The only thing that comes to mind is that COLLAPSE_MAX_PTES
would seemingly refer to 512 not 511, but I'm ok with that if no one
objects.

-- Nico

>
> E.g., folio_ref_add() adds "HPAGE_PMD_NR - 1" because we already
> obtained a reference, and we need one per page -- HPAGE_PMD_NR.
>
> So it's something different than when messing with the magical
> khugepaged_max_ptes_none values.
>
> --
> Cheers,
>
> David
>


