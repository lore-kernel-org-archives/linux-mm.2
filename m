Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D285CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF67E8E0006; Mon, 22 Sep 2025 09:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7928E0001; Mon, 22 Sep 2025 09:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97068E0006; Mon, 22 Sep 2025 09:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4B888E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:17:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3947D11AA21
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:17:44 +0000 (UTC)
X-FDA: 83916938448.29.EC6A891
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id EFAD54000E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:17:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NfYkIb6E;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758547062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IA1zUhjRviJIDCc/R9sbVzNFhsiBPzpLinzq6Wc7p0w=;
	b=SVUd7Eq15tsURL78S9B+f52l46WearktZ4WnPYu2jJbCmvC4rlDZNZSGL9a50pUX7v4Pkv
	oxp9AYGe7jNFt0Ms00wsWgltR0HZLmlY1p59mxFzj76K+ZwG8x6DTrgwQ/lJDaZyeO6mg/
	0vH10xre50rnfYkt3NA/nZyYvMH822s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NfYkIb6E;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758547062; a=rsa-sha256;
	cv=none;
	b=DQolUwaM+liXgT6+rm5XYkDNaQ2+YliwQdgEAmNfoXvtQlsvYNTT9ubrOsNfWdwsY6EuF8
	3xB+I0lr//0LRQRWCEW4J4tmXAg0AWfOXETK6G2G9cmzVzwLVVg3Uz1pDXs4Hk502Vjyai
	UJivIar/yA6u/cOHPnQQ6TdblMdKr2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758547061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IA1zUhjRviJIDCc/R9sbVzNFhsiBPzpLinzq6Wc7p0w=;
	b=NfYkIb6EOoRvOypWZ8LDNcaZ4INz/NGwJQCRYxECX5yNRKdR9dAqK0qsL5ABPeqHdJPlLT
	suQIYoHjHW8lao6eVUlFciIwkTYjYQtrqVBp9scHyxOyJOCFX1pwkiwd7Lg3B/+CXr1YAL
	nsIViWbtwhjjaIyYAab/hmbiG+7e0qU=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-SWLg9DFpMna4X3jHs15uhw-1; Mon, 22 Sep 2025 09:17:40 -0400
X-MC-Unique: SWLg9DFpMna4X3jHs15uhw-1
X-Mimecast-MFC-AGG-ID: SWLg9DFpMna4X3jHs15uhw_1758547059
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-74983d5be0bso20724797b3.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758547059; x=1759151859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IA1zUhjRviJIDCc/R9sbVzNFhsiBPzpLinzq6Wc7p0w=;
        b=YJFFW0HUAYHqYWOrrPGacgqZlykjnaV0eFSxgUEbqKNtON4uL8k0zQsS1W3FrqhizT
         cRD/DCpfJVUfChvypmOpRtJ9Hx2kLxMYDLi7G4dk3IqBcr2VHoZ/pucr+izT4bIdUUur
         GjJvUI8wZEBw3rK9BtNvFCuHzclvtJ8I7Q1FRHE12m6Ko45wpEr4UBv5qKHqjXw89wOe
         B0hKhJwUF2JFl7cVU4wHLgP+pl+HAze7FYxo42x2Re5XNOxVdoxNxBIFl+KpfNgOBJt2
         +KVISzty4/F4jxKdXAq0yz5YIT/NtWS5IB8DaPXID8tFguBXiR6LglLvH224QkI9SauR
         IU7g==
X-Forwarded-Encrypted: i=1; AJvYcCVe+2Hpuwkep+8j8C51RqTyjuanxctGXE4UGrHJvxpAc1rzpVih99oXpAnjvPsqL+UFO2xVMOcTJA==@kvack.org
X-Gm-Message-State: AOJu0Yyyeg4BpTHIoEN14GFCJn8m+Su3UHbwOrMzoi0tMpFtp2NiUrxf
	RWe1jH3Lh9AeGwh879pMa2WgwACrIs7sx13opM6P2fFf2wAvyPqLZc5QTA93S9etzzV+57RdK84
	RmWRReotgOsddhCQ6b3JeSLtt65Y0lCiY19KH4QEyR97BCmvAAQ5zmQgVrC8UR9ovPUylsH4L4o
	m5DI53aHTA/Xu/libIFuxm2Codym4=
X-Gm-Gg: ASbGnctoznnsrIHdxuE62n6O8HsY7ewVIREgUgbP5/nFjEqAgwP56x9HOTlMDdnIjLd
	A6aPZ9p3uHB3hxyfP7gcX1ENp3+DQ2fwa3j1taD1XBX9pA4NSyQEdeZMVdiL78exISudvfrpizD
	IMJvbvBYChGW6iTG9eF1cZ7yBiqDoOB788uxQ=
X-Received: by 2002:a53:a484:0:b0:630:8dab:64f7 with SMTP id 956f58d0204a3-6347754ff00mr7549013d50.2.1758547059369;
        Mon, 22 Sep 2025 06:17:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCbNf0S1dYS7uoql1QDEivo+rhcilQ/jJVxmFE/J0Tq8eG2GvJKe5QTBOlU01XgL1VeLZmSCyssNQ0b9SeZ/M=
X-Received: by 2002:a53:a484:0:b0:630:8dab:64f7 with SMTP id
 956f58d0204a3-6347754ff00mr7548975d50.2.1758547058822; Mon, 22 Sep 2025
 06:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
 <20250919071244.17020-3-richard.weiyang@gmail.com> <66fdb874-1fb1-41c3-86ca-97755d09de9b@redhat.com>
In-Reply-To: <66fdb874-1fb1-41c3-86ca-97755d09de9b@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 22 Sep 2025 07:17:13 -0600
X-Gm-Features: AS18NWCGo8_40YJ9AoarPZU8ufyo4M8J0501HRH9DV3xM3XboNuBt2Cm7y2E5dM
Message-ID: <CAA1CXcBdKfB7DYY5Y5anf6tLS5u9ONakjcA+TCEVYKVUTbibYg@mail.gmail.com>
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6HDcU3xFyJGbm1lSQEGFXR_xNaHtYXtQ0E9JVGCY3mc_1758547059
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EFAD54000E
X-Stat-Signature: tpefsmyrqmc3379n81w49h8zrbh7iftr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758547061-57167
X-HE-Meta: U2FsdGVkX18r+WQhFknV55TLSDZU3YPQrdDVe5vYTWcp6qkTY4ebcIFMpfVPb93ZJy+X3S7MqQXpPsiiEAzI7SV1QIp3o13HnWrP9VtuaN+6n3Dplas0Z9vSjMZCBsClMtSp4bKXVsF9R6ewtH739rCtuOIYqzrZ9WIE0UwyJKXJ2kQUMNTQ3g69/lCVnmIL5ah8eF6nxkuWnzVhXR0ZMH7jdeXau2H88XQY6/xA2fCsstbbQql+Q8pMnD0UyZUrW59fG78GquFOot5rVoWCACHKYwSAPPbGkOGRbDSZlN/DQ7V4X99EKhoCHuXEr0uKEqFutVNoRGthT5Ph/pS8adX/VTQOa3CFCXoXF+//BkS6CRKc0w4ZdydMkVq7cSPVgghY1x7b5KrXfpYL0kX2HvyzMUfrLp827eX4mSk9E5XkGUnS26DjbyDi/g+Xt86u1kmkedv9nXpdqEeSluzUaOSyaHG21juAYmaF1kqLSoiaGL0GzpzLZR4yqYMNWvww51PyNIwNp9/7yj5z3GT61JgemCuY1FrBXPQovRHIG1LZ5f/qiP3Zd/3lLAaVGUXNr0m8zI9lbrzZ4fl6LV5Y/a+4VIMSUm8rW0zU+l7gPRoaTGkZf6oyRY0T52IxjFa8L6AaiSxf5VXn9O4dVVu4qOFcWZGW8JIvyz0EyeSjyYqMjLEzHbbEZXb0x4JahXQl7rMVzed4aqfLG0NWRBKifqv/KYtXoRXJ1Ew0BhjHI5qTYFzdYMcPCXx0aYhQPLkPvY8XqNVOEzvuWajdnIIsFVyjfW8Zv1OJWrBrHVb4wFboaQZwYwS3St5a5sCTWNFk2S0Ky7T6IDGUOgFg9tMb2xApO6YJNSbHHXwR/ux8T9ipd5EEwiZLjDLNgJ/bDr767uZaCuFwTDw5CbahsskTo5/U9EWsvMjMl2oLa9SwjW+8i5aQYubvje8WevRvW28QngaEpc6wPKRm5k8keM5
 zy849Ffa
 TvdqgVtK6zSjARgFRBn/yPLE2/d2dlnrOWcnAe+t2Pdjx4pbaFTDTmMF7uIVxwgvKkJEz0aK2H71JMJizPsE9uHhGr3JVSySzlQ1uA50xEdH9SKRuSZfCIcpLw1IiXI8p7t487fS9XIBA40CG5gq8cQgthkKv0blWteCrxVCRrpvjdW72kOc3ySfic2120EktAEQ0azsAVt8qRhC7TwZrNBDu9Y8d3Vfdw3/o+doYJKkMo+RVBPXO9fi4a+HmkK+Jsesv3myfSCKzhq+xd1MNkliyEpI5kFDSKcQO9tLRMJVX663ruxBS7RaUCV+XO3pGk9B22z54Y5wgJBnfsDZ8mmM4AFZ4D1JfqXrpmTKe3l6ZoO+1gQrU99RB72tKHMbDo9F4mzeY7/IXT0X9guC2tTXTVIZVNooeL/WA0C8IG8vqnaUVflbJEdBexU9jNNVPyUI+z1B87lLOYwCieffAIRFJNZrAAkAqSrIef5KdeCKUv+O9kx3A10pKPcc8tIQ0Mzqoe0XPFsGo1RdOrNpQdm1CKWgg5hCt0son
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 1:37=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 19.09.25 09:12, Wei Yang wrote:
> > Current code is not correct to get struct khugepaged_mm_slot by
> > mm_slot_entry() without checking mm_slot is !NULL. There is no problem
> > reported since slot is the first element of struct khugepaged_mm_slot.
> >
> > While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
> > there is no need to define it.
> >
> > Remove the definition of struct khugepaged_mm_slot, so there is not
> > chance to miss use mm_slot_entry().
> >
> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Kiryl Shutsemau <kirill@shutemov.name>
> > Cc: xu.xin16@zte.com.cn
> > ---
> >   mm/khugepaged.c | 57 ++++++++++++++++++------------------------------=
-
> >   1 file changed, 21 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e019ea2cbab0..88ea92c64bf0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -103,14 +103,6 @@ struct collapse_control {
> >       nodemask_t alloc_nmask;
> >   };
> >
> > -/**
> > - * struct khugepaged_mm_slot - khugepaged information per mm that is b=
eing scanned
> > - * @slot: hash lookup from mm to mm_slot
> > - */
> > -struct khugepaged_mm_slot {
> > -     struct mm_slot slot;
> > -};
> > -
>
> Looking into the details, we remove the last entries from this member in
> d50791c2bee9 ("mm/khugepaged: delete
> khugepaged_collapse_pte_mapped_thps()").
>
> @Nico did you have any use case in one of your scanning-optimizing
> prototypes for khugepaged_mm_slot?

Nope! Im utilizing the scan control struct. This change looks good
with the fix in place

>
> --
> Cheers
>
> David / dhildenb
>


